//
//  NRIC.swift
//  RazerHackathon
//
//  Created by Russell Ong on 15/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import Foundation

struct NRICModel: Decodable {
    let prediction: Prediction
    let qualityCheck: QualityCheck
    let vision: Vision
}

struct Prediction: Decodable {
    let confidence: Double
    let type: String
}

struct QualityCheck: Decodable {
    let finalDecision: Bool
}

struct Vision: Decodable {
    let extract: Extract
    let type: String
}

struct Extract: Decodable {
    let countryOfBirth: String
    let dob: String
    let idNum: String
    let name: String
    let race: String
}
