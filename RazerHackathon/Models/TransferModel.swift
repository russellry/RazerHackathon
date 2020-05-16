//
//  TransferModel.swift
//  RazerHackathon
//
//  Created by Russell Ong on 16/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import Foundation

struct TransferModel: Codable {
    let type: String
    let amount: String
    let notes: String
    let toSavingsAccount: String
    let method: String
}
