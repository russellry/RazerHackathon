//
//  ClientModel.swift
//  RazerHackathon
//
//  Created by Russell Ong on 15/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import Foundation

struct ClientModel: Codable {
    let client: Client
    let idDocuments: [IDDocuments]
}

struct Client: Codable {
    let firstName: String
    let lastName: String
    let assignedBranchKey: String
}

struct IDDocuments: Codable {
    let identificationDocumentTemplateKey: String
    let documentType: String
    let documentId: String
}


struct ClientModelResponse: Decodable {
    let client: ClientResponse
    
}

struct ClientResponse: Decodable {
    let encodedKey: String
    let clientRole: ClientRole
}

struct ClientRole: Decodable {
    let encodedKey: String
}
