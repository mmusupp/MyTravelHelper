//
//  AppUserDefaults.swift
//  MyTravelHelper
//
//  Created by Musthafa on 02/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

class AppUserDefaults {
    
    static let shared = AppUserDefaults()
    private init() { }
    lazy var userDefaults = UserDefaults.standard
    
    
    var sourceStation : String? {
        get {
            guard let token = userDefaults.object(forKey: destinationStationKey) as? String? else {
                return nil
            }
            return token
        }
        set {
            if let value = newValue {
                userDefaults.set(value, forKey: destinationStationKey)
                userDefaults.synchronize()
            } else {
               UserDefaults.standard.removeObject(forKey: destinationStationKey)
            }
        }
    }
    
    
    var destinationStation : String? {
        get {
            guard let token = userDefaults.object(forKey: sourceStationKey) as? String? else {
                return nil
            }
            return token
        }
        set {
            if let value = newValue {
                userDefaults.set(value, forKey: sourceStationKey)
                userDefaults.synchronize()
            } else {
               UserDefaults.standard.removeObject(forKey: sourceStationKey)
            }
        }
    }
}
