//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 07.03.2026.
//

import UIKit
import WebKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

// MARK: - AuthViewController
final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == showWebViewSegueIdentifier {
                guard
                    let webViewViewController = segue.destination as? WebViewViewController
                else {
                    assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                    return
                }
                webViewViewController.delegate = self
            } else {
                super.prepare(for: segue, sender: sender)
            }
        }
        
        private func configureBackButton() {
            navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
            navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:  .plain, target: nil, action: nil)
            navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypBlack")
        }
    }
    
// MARK: - AuthViewController + WebViewViewControllerDelegate
    extension AuthViewController: WebViewViewControllerDelegate {
        func webVviewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
            vc.dismiss(animated: true)
            OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
                guard let self = self else {return}
                
                switch result{
                case .success(let token):
                    OAuth2TokenStorage.shared.token = token
                    vc.dismiss(animated: true) {
                        self.delegate?.didAuthenticate(self)
                    }
                case .failure(let error):
                    print("Ошибка получения токена: \(error)")
                    break
                }
            }
        }
        
        func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
            vc.dismiss(animated: true)
        }
    }

// MARK: - OAuth2TokenStorage
    

    final class OAuth2TokenStorage {
        static let shared = OAuth2TokenStorage()
        private init() {}
        
        private let tokenKey = "authToken"
        var token: String? {
            get { UserDefaults.standard.string(forKey: tokenKey)}
            set { UserDefaults.standard.set(newValue, forKey: tokenKey)}
        }
    }
    
// MARK: - OAuth2Service
final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {
    }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "unsplash.com"
        urlComponents.path = "/oauth/token"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code)
        ]
        
        guard let authTokenUrl = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
    
    struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
        }
    }
        func fetchOAuthToken(code: String, completion: @escaping (Result <String, Error>) -> Void) {
            guard let request = makeOAuthTokenRequest(code: code) else {
                completion(.failure(NetworkError.invalidRequest))
                return
            }
            
            let task = URLSession.shared.data(for: request) { result in
                switch result {
                case .success(let success):
                    do {
                        let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: success)
                        completion(.success(response.accessToken))
                    } catch {
                        completion(.failure(NetworkError.decodingError(error)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

/* extension AuthViewController {
    private func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        oauth2Service.fetchOAuthToken(code) { result in
            completion(result)
        }
    }
}*/
