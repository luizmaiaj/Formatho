//
//  APIError.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 17/9/22.
//

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
        case .badResponse(let code):
            
            switch code {
            case 400:
                return "The parameters in the URL or in the request body aren't valid"
            case 401:
                return "Authentication has failed, please check your credentials"
            case 403:
                return "The authenticated user doesn't have permission for the operation"
            case 404:
                return "The wit doesn't exist, or you doesn't have permission to see it"
            case 409:
                return "There's a conflict between the request and the state of the data on the server"
            default:
                return "Sorry, the connection to the server has failed"
            }
            
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
