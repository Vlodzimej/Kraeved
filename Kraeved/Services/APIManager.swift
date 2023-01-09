//
//  APIManager.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 09.11.2022.
//

import MapKit

// MARK: - Result
enum Result<Success, Error: Swift.Error> {
    case success(Success)
    case failure(Error)
}

extension Result {
    func get() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - APIManagerProtocol
protocol APIManagerProtocol {
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    func get<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
}

// MARK: - APIError
enum APIError: Error {
    case badRequest
    case jsonDecode
}

// MARK: - APIManager
final class APIManager: APIManagerProtocol {
    static let shared = APIManager()

    var sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        URLSession(configuration: sessionConfiguration)
    }()

    private init () {
        sessionConfiguration = URLSessionConfiguration.default
    }

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.dataTask(with: url, completionHandler: completion).resume()
    }

    func get<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) in

            guard error == nil else { return completion(.failure(error!)) }

            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                completion(.failure(APIError.badRequest))
                return
            }

            guard let data = data else { return }

            guard let value = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(APIError.jsonDecode))
                return
            }
            completion(.success(value))
        }
        task.resume()
    }
}
