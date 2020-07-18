//
//  Endpoints.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Alamofire

class Endpoints {
    private init() {}
    
    static let shared = Endpoints()
    
    private var manager: Alamofire.Session = {
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForResource = 60
        
        let manager = Alamofire.Session(configuration: conf)
        return manager
    }()
    
    typealias categoryResponse = (AppResponse<Response<[Category]>>) -> ()
    typealias paymentResponse = (AppResponse<Response<Receipt>>) -> ()
    
    func getCategories(completion: @escaping categoryResponse) {
        customRequest(to: Router.getCategories) { completion($0) }
    }
    
    func makeNewPayment(body: String, completion: @escaping paymentResponse) {
        customRequest(to: Router.makeNewPayment(body: body)) { completion($0) }
    }
}

extension Endpoints {
    private func customRequest<T: Decodable>(to route: Router, completion: @escaping (AppResponse<T>) -> ()) {
        manager.request(route).validate(statusCode: 200..<600).responseJSON { response in
            let decoder = JSONDecoder()
            let response = decoder.decodeResponse(T.self, response: response)
            completion(response)
        }
    }
}

extension JSONDecoder {
    func decodeResponse<T: Decodable>(_ type: T.Type, response: AFDataResponse<Any>) -> AppResponse<T> {
        switch response.result {
        case .failure(let error):
            if error._code == NSURLErrorTimedOut {
                return .failure(.responseError("Time out"))
            }
            if error._code == NSURLErrorNotConnectedToInternet {
                return .failure(.notConnectedToInternet)
            }
            return .failure(.responseError("Please, call the support."))
        case .success(_):
            if let data = response.data {
                nonConformingFloatDecodingStrategy = .throw
                do {
                    let result = try decode(type.self, from: data)
//                    if let data = result as? BaseResponse, data.code == ResultCode.invalidSid {
//                        PinViewController(with: LoginViewModel()).setAsRoot()
//                        return .failure(.responseError(Labels.Error.sessionError.localized))
//                    }
                    return .success(result)
                } catch {
                    print("parsing error \(error)")
                    return .failure(.responseError("No Data Found"))
                }
            } else {
                return .failure(.noData("No Data Found"))
            }
        }
    }
}
