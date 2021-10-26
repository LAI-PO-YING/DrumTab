//
//  Post.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/26.
//

import Foundation

struct Post: Codable {

    var creationId: String
    var postTime: TimeInterval
    var postId: String
    var userId: String
    var content: String
    var like: Int

}
