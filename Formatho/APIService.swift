//
//  APIService.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 17/9/22.
//

import Foundation

struct APIService {

    func fetch<T: Decodable>(_ type: T.Type, url: URL?, headers: [String: String]? = nil, completion: @escaping(Result<T, APIError>) -> Void) {

        guard let url = url else {
            let error = APIError.badURL
            completion(Result.failure(error))
            return
        }

        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
            //self.errorMessage = APIError.badURL.localizedDescription

        request.httpMethod = "GET"

        if headers != nil {
            request.allHTTPHeaderFields = headers
        }

        let task = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in

            if let error = error as? URLError {
                completion(Result.failure(APIError.url(error)))
            } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    // ERROR
                print(response.statusCode)

                completion(Result.failure(APIError.badResponse(statusCode: response.statusCode)))
            } else if let data = data {

                /*if let string = String(data: data, encoding: .utf8) {
                    print("APIService string: \(string)")
                }*/

                let decoder = JSONDecoder()

                do {
                    //print("APIService data: \(data)")

                    let result = try decoder.decode(type, from: data)

                    completion(Result.success(result))

                } catch {
                    print("APIService error: \(error)")

                    completion(Result.failure(APIError.parsing(error as? DecodingError)))
                }
            }
        }

        task.resume()
    }
}
