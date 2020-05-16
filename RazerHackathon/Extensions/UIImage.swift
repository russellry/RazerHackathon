//
//  UIImage.swift
//  RazerHackathon
//
//  Created by Russell Ong on 15/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import Foundation
import UIKit

public func convertImageToBase64String (img: UIImage) -> String {
    return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
}

