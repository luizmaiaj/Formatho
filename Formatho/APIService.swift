//
//  APIService.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 17/9/22.
//

import Foundation

/*
200    Success, and there's a response body.
201    Success, when creating resources. Some APIs return 200 when successfully creating a resource. Look at the docs for the API you're using to be sure.
204    Success, and there's no response body. For example, you get this response when you delete a resource.
400    The parameters in the URL or in the request body aren't valid.
401    Authentication has failed. Often, this response is because of a missing or malformed Authorization header.
403    The authenticated user doesn't have permission to do the operation.
404    The resource doesn't exist, or the authenticated user doesn't have permission to see that it exists.
409    There's a conflict between the request and the state of the data on the server. For example, if you attempt to submit a pull request and there's already a pull request for the commits, the response code is 409.
*/

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

                if let string = String(data: data, encoding: .utf8) {
                    print("APIService string: \(string)")
                }

                let decoder = JSONDecoder()

                do {
                    print("APIService data: \(data)")

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
