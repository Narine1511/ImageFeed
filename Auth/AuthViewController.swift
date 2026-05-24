
//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 07.03.2026.
//

import UIKit
import WebKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

// MARK: - AuthViewController
final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    private var isAuthorizing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("[viewDidLoad]: AuthViewController загружен")
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            
            guard !isAuthorizing else {
                print("[prepare]: Авторизация уже идет, WebView не будет открыт")
                return
            }
            
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            isAuthorizing = true
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(resource: .navBackButton)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(resource: .navBackButton)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:  .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypBlack")
    }
}

extension AuthViewController {
    private func showAuthErrorAlert() {
        let alertController = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - AuthViewController + WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        /*ProgressHUD.animate()*/
        
        UIBlockingProgressHUD.show()
        
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            /*ProgressHUD.dismiss()*/
            UIBlockingProgressHUD.dismiss()
            
            guard let self else {return}
            switch result{
            case .success(let token):
                OAuth2TokenStorage.shared.token = token
                vc.dismiss(animated: true) {
                    self.delegate?.didAuthenticate(self)
                }
            case .failure(let error):
                print("[webViewViewController]: Ошибка получения токена: \(error)")
                vc.dismiss(animated: true)
                self.showAuthErrorAlert()
                break
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        /*vc.dismiss(animated: true)*/
    }
}
