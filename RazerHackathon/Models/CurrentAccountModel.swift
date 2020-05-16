//
//  CurrentAccountModel.swift
//  RazerHackathon
//
//  Created by Russell Ong on 15/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import Foundation

struct CurrentAccountModel: Codable {
    let savingsAccount: SavingsAccount
}

struct SavingsAccount: Codable {
    let accountHolderType: String
    let accountHolderKey: String
    let accountState: String
    let productTypeKey: String
    let allowOverdraft: String
    let accountType: String
    let interestSettings: InterestSettings
}

struct InterestSettings: Codable {
    let interestRate: String
}

struct CurrentAccountModelResponse: Decodable {
    let savingsAccount: SavingsAccountResponse
}

struct SavingsAccountResponse: Decodable {
    let encodedKey: String
    let id: String
}
