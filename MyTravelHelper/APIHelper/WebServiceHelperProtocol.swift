//
//  WebServiceHelperProtocol.swift
//  MyTravelHelper
//
//  Created by Musthafa on 02/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

typealias SuccessBlock = (_ result: Data?) -> Void
typealias FailureBlock = (_ httpULResponse: URLResponse?, _ error: Error?) -> Void

protocol WebServiceHelperProtocol {
    func requestDataTask(_ apiEndPoint: String,
                             success: @escaping SuccessBlock,
                             failure: @escaping FailureBlock)
}
