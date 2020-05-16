//
//  Defaults.swift
//  RazerHackathon
//
//  Created by Russell Ong on 17/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import Foundation

public func getDefaultsValue(key: String) -> String {
    let defaults = UserDefaults.standard

    guard let value = defaults.string(forKey: key) else {
         return ""
     }
    return value
}

public func setDefaultsValue(key: String, value: String) {
    let defaults = UserDefaults.standard
    
    defaults.set(value, forKey: key)
}
