//
//  ClientAccountModel.swift
//  RazerHackathon
//
//  Created by Russell Ong on 16/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import Foundation

struct ClientAccountModel: Decodable {
    let encodedKey: String
    let accountType: String
    let balance: String
}
