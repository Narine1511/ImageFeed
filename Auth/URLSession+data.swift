//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 21.03.2026.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
    case noData
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else if 300..<400 ~= statusCode {
                    print("Сообщение о перенаправлении: код \(statusCode)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                } else if 400..<500 ~= statusCode {
                    print("Ошибка валидации: код \(statusCode)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                } else if 500..<600 ~= statusCode {
                    print("Ошибка сервера: код \(statusCode)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            }
            else if let error = error {
                print("Сетевая ошибка")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("Неизвестная ошибка")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        }
        
        task.resume()
        return task
    }
}
extension URLSession {
    func objectTask<T: Decodable> (
        for request: URLRequest,
        completion: @escaping(Result<T, Error>) -> Void)
    -> URLSessionTask {
        let decoder = JSONDecoder()
        let task = data(for: request) {(result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                if let jsonString = String(data:data, encoding: .utf8) {
                    print("Полученные данные: \(jsonString)")
                }
                do {
                    let decodedObject = try decoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    if let decodingError = error as? DecodingError {
                        print("Ошибка декодирования: \(decodingError)")
                    } else {
                        print("Ошибка декодирования: \(error.localizedDescription)")
                    }
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Ошибка запроса: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        return task
    }
}
