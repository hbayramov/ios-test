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
            return try generateRequest(baseUrl: "", mockUrl: Constants.API.getCategoriesMockUrl)
        case .makeNewPayment:
            return try generateRequest(baseUrl: "", mockUrl: Constants.API.makeNewPaymentMockUrl)
        }
    }
}

extension Router {
    func generateRequest(baseUrl: String = "", mockUrl: String = "", body: String = "", headers: [String: String] = [:], contentType: String = "") throws -> URLRequest {
        let url = baseUrl.isEmpty ? mockUrl : baseUrl + path
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = body.data(using: .utf8, allowLossyConversion: false)
        
        if !contentType.isEmpty {
           urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
}
