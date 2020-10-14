//
//  Request.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 14/10/20.
//

import Foundation

typealias Headers = Dictionary<String, String>
typealias Response<Value: Decodable> = (_ completionHandler: @escaping(Result<Value, Error>) -> Void) -> Void
private let baseUrl = "https://5f86a59ec8a16a0016e6b823.mockapi.io/api"

enum HTTPMethods: String {
    case get = "GET", post = "POST", delete = "DELETE", patch = "PATCH"
}

@propertyWrapper
internal struct Request<Value> where Value: Decodable {

    private var request: URLRequest

    init(
        url: String,
        method: HTTPMethods = .get,
        body: Data? = nil,
        headers: Headers? = nil
    ) {
        guard let url = URL(string: String(baseUrl+url).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            precondition(false, "Must add a valid url.")
        }

        var aRequest = URLRequest(url: url)
        aRequest.httpMethod = method.rawValue
        aRequest.httpBody = body
        headers?.forEach { aRequest.setValue($1, forHTTPHeaderField: $0) }
        aRequest.allowsCellularAccess = true
        self.request = aRequest
    }

    var wrappedValue: Response<Value> {
        get {
            return { completion in
                URLSession.shared
                    .dataTask(with: self.request) { data, _, error in
                        if error != nil {
                            return completion(.failure(error!))
                        }
                        let decoder = JSONDecoder()
                        do {
                            let info = try decoder.decode(Value.self, from: data ?? .init())
                            completion(.success(info))
                        } catch {
                            completion(.failure(error))
                        }
                }
                .resume()
            }
        }
    }
}
