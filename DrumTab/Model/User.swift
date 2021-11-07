//
//  User.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/26.
//

import Foundation
import UIKit

struct User: Codable {

    var userId: String
    var userName: String
    var userEmail: String
    var userPhoto: String
    var userCollection: [String]
    var userFollow: [String]
    var followBy: [String]
    var likesCount: Int
    var userPhotoId: String

}

struct UserLocalUse {

    var userId: String
    var userName: String
    var userEmail: String
    var userPhoto: UIImage
    var userCollection: [String]
    var userFollow: [String]
    var followBy: [String]
    var likesCount: Int
    var userPhotoId: String

}
