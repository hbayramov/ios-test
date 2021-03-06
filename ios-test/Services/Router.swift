//
//  Router.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Alamofire

enum Router: URLRequestConvertible {
    case getCategories
    case makeNewPayment(body: String)
    
    var method: HTTPMethod {
        switch self {
        case .getCategories:
            return .get
        case .makeNewPayment:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getCategories:
            return "payment/categories"
        case .makeNewPayment:
            return "payment/new"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        switch self {
        case .getCategories:
            return try generateRequest(mockUrl: Constants.API.getCategoriesMockUrl)
        case .makeNewPayment(let body):
            return try generateRequest(mockUrl: Constants.API.makeNewPaymentMockUrl, body: body)
        }
    }
}

extension Router {
    func generateRequest(mockUrl: String = "", body: String = "", headers: [String: String] = [:], contentType: String = "") throws -> URLRequest {
        let baseUrl = Constants.API.baseUrl
        let url = baseUrl.isEmpty ? mockUrl : baseUrl + path
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        if !body.isEmpty {
            urlRequest.httpBody = body.data(using: .utf8, allowLossyConversion: false)
        }
        
        if !contentType.isEmpty {
           urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
}
