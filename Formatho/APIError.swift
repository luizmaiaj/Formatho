//
//  APIError.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 17/9/22.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case badURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown

    var localizedDescription: String {
        // user feedback
        switch self {
            case .badURL, .parsing, .unknown:
                return "Sorry, something went wrong"
            case .badResponse(_):
                return "Sorry, the connection to the server has failed"
            case .url(let error):
                return error?.localizedDescription ?? "Something went wrong"
        }
    }

    var description: String {
        // data for debugging
        switch self {
            case .unknown: return "unknown error"
            case .badURL: return "invalid url"
            case .url(let error):
                return error?.localizedDescription ?? "url session error"
            case .parsing(let error):
                return "parsing error \(error?.localizedDescription ?? "")"
            case .badResponse(statusCode: let statusCode):
                return "bad response with status code \(statusCode)"
        }
    }
}
