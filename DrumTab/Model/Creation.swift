//
//  Creation.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/20.
//

import Foundation

struct Creation: Codable {

    var bpm: Int
    var createdTime: TimeInterval
    var id: String
    var name: String
    var record: [String: [String]]
    var timeSignature: [Int]
    var published: Bool
    var userId: String
    var comment: [[String: String]]
    var numberOfSection: Int

    var user: User? {
        Cache.userCache[userId]
    }

}

struct CreationComment {
    var user: User
    var time: Int
    var comment: String
}
