
import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let dataStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() { }
    
    var authToken: String? {
        return dataStorage.token
    }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            print("[makeOAuthTokenRequest]: Ошибка: не удалось создать URL")
            return nil
        }
        
        /*var urlComponents = URLComponents()*/
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
            print("[makeOAuthTokenRequest] Ошибка: не удалось создать URL для токена")
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
        assert(Thread.isMainThread)
        guard lastCode != code else {
            print("[fetchOAuthToken]: Ошибка: уже выполняется запрос с таким же кодом")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("[fetchOAuthToken]: Ошибка: не удалось создать запрос для получения токена")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in DispatchQueue.main.async {
            
            guard let self = self else { return }
            
            defer {
                self.task = nil
                self.lastCode = nil
            }
            
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.dataStorage.token = authToken
                completion(.success(authToken))
                /*self.task = nil
                 self.lastCode = nil*/
                
            case .failure(let error):
                print("[fetchOAuthToken]: Ошибка запроса: \(error.localizedDescription)")
                completion(.failure(error))
                /*self.task = nil
                 self.lastCode = nil*/
            }
        }
        }
        self.task = task
        task.resume()
    }
}
