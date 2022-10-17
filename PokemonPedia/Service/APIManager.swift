//
//  APIManager.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import Foundation
import RxSwift

final class APIManager {

    // MARK: - Singleton

    static let shared: APIManager = APIManager()

    // MARK: - Initializers

    private init() {}

    // MARK: - Interfaces

    func request<Model: Decodable>(service: WebService) -> Single<Model> {
        var component = URLComponents(string: service.baseURL)
        component?.path = service.version + service.path
        component?.queryItems = service.parameters.map { parameters in
            parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let url = component?.url else {
            return Single.error(APIError.invalidURL)
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return Single<Model>.create { single in
            let dataTask = URLSession(configuration: .default).dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.failure(error))
                }

                switch (response as? HTTPURLResponse)?.statusCode {
                case .none:
                    single(.failure(APIError.statusCodeNotFound))
                case .some(let code) where 200...399 ~= code:
                    guard let data = data else { fallthrough }
                    do {
                        let decodable = try JSONDecoder().decode(Model.self, from: data)
                        single(.success(decodable))
                    } catch {
                        single(.failure(APIError.decodeFailed(error: error)))
                    }
                default:
                    single(.failure(APIError.unexpected))
                }
            }

            dataTask.resume()

            return Disposables.create {
                dataTask.cancel()
            }
        }
    }
}
