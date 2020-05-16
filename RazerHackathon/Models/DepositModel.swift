//
//  DepositModel.swift
//  RazerHackathon
//
//  Created by Russell Ong on 16/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import Foundation

struct DepositModel: Codable {
    let amount: Double
    let notes: String
    let type: String
    let method: String
    let customInformation: [CustomInformation]
}

struct CustomInformation: Codable {
    let value: String
    let customFieldID: String
}
