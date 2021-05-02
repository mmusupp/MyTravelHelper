//
//  WebServiceConstants.swift
//  MyTravelHelper
//
//  Created by Musthafa on 02/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

struct WebServiceURLs {
    static let fetchallStations = "http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML"
    static let fetchTrainsFromSource = "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML?StationCode="
}

public enum WebServiceError: Error {
    case error_1
    case error_2
    case error_3
    case error_4
}

extension WebServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .error_1:
            return NSLocalizedString("A user-friendly description of the error_1.", comment: "My error_1")
        case .error_2:
            return NSLocalizedString("A user-friendly description of the error_2.", comment: "My error_2")
        case .error_3:
            return NSLocalizedString("A user-friendly description of the error_3.", comment: "My error_3")
        case .error_4:
            return NSLocalizedString("A user-friendly description of the error_4.", comment: "My error_4")
        }
    }
}
