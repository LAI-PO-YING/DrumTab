//
//  User.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/26.
//

import Foundation

struct User: Codable {

    var userId: String
    var token: String
    var userName: String
    var userEmail: String
    var userPhoto: String
    var userCollection: [String]
    var userFollow: [String]
    var followBy: [String]

}
