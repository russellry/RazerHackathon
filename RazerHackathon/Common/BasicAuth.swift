//
//  Login.swift
//  RazerHackathon
//
//  Created by Russell Ong on 17/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import Alamofire

public func mambuBasicAuth() -> HTTPHeaders {
    let user = "Team11"
    let password = "pass8AE7D4715"
    let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
    let base64Credentials = credentialData.base64EncodedString()
    let headers = ["Authorization": "Basic \(base64Credentials)"]
    
    return HTTPHeaders(headers)
}
