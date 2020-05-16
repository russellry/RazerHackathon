//
//  TransactionModel.swift
//  RazerHackathon
//
//  Created by Russell Ong on 16/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import Foundation

struct TransactionModel: Decodable {
    let amount: String
    let type: String
    let comment: String
}
