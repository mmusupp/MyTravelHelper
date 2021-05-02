//
//  WebServiceHelper.swift
//  MyTravelHelper
//
//  Created by Musthafa on 02/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

////typealias CompletionBlock = (_ result:Codable?, _ error:Error?) -> Void
////typealias SuccessBlock = (_ result: Codable?) -> Void
////typealias FailureBlock = (_ httpULResponse: URLResponse?, _ error: Error?) -> Void
//
//typealias SuccessBlock = (_ result: Data?) -> Void
//typealias FailureBlock = (_ httpULResponse: URLResponse?, _ error: Error?) -> Void
//
//protocol WebServiceHelperProtocol {
//    func requestDataTask(_ apiEndPoint: String,
//                             success: @escaping SuccessBlock,
//                             failure: @escaping FailureBlock)
//}



class WebServiceHelper: WebServiceHelperProtocol {
   
    lazy var session: URLSession = createURLSession()
    
    private func createURLSession() -> URLSession {
        return URLSession(configuration: getSessionConfiguration())
    }
    
    private func getSessionConfiguration() -> URLSessionConfiguration {
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 120
        sessionConfig.timeoutIntervalForResource = 0
        sessionConfig.httpAdditionalHeaders = [:]
        return sessionConfig
    }
        
    func requestDataTask(_ apiEndPoint: String, success: @escaping SuccessBlock, failure: @escaping FailureBlock) {
        
        let url = URL(string: apiEndPoint)!
        
        let task = session.dataTask(with: url) { data, response, error in
           
            guard error == nil else {
                print ("error: \(error!)")
                failure(response, error)
                return
            }
            
            guard let resultData = data else {
                print("No data")
                let noDataerror = WebServiceError.error_1
                failure(response, noDataerror)
                return
            }
            success(resultData)
        }
        task.resume()
    }
}
