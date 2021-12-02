//
//  CreationCommentProvider.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/11/25.
//

import Foundation

class CreationCommentProvider {

    static let shared = CreationCommentProvider()

    private let firebase = FirebaseFirestoreManager.shared

    private enum CommentDictKey: String {

        case userId

        case time

        case comment
    }

    func fetchComment(creation: Creation, completion: @escaping ([CreationComment]) -> Void) {

        let dispatchGroup = DispatchGroup()

        var comments = [CreationComment]()

        creation.comment.forEach { commentDict in

            guard let userId = commentDict[CommentDictKey.userId.rawValue],
                  let timeStr = commentDict[CommentDictKey.time.rawValue],
                  let time = Int(timeStr),
                  let comment = commentDict[CommentDictKey.comment.rawValue]
            else {
                return
            }
            guard let localUser = LocalUserData.user else { return }

            let isNotInMyBlockList = !localUser.blockList.contains(userId)

            guard isNotInMyBlockList else { return }

            let cacheHasUser: Bool = checkUserInCache(userId: userId)

            if cacheHasUser {

                guard let user = Cache.userCache[userId] else { return }

                let isNotInCommentUserBlockList = !user.blockList.contains(localUser.userId)

                guard isNotInCommentUserBlockList else { return }

                let comment = CreationComment(user: user, time: time, comment: comment)

                comments.append(comment)

            } else {

                dispatchGroup.enter()

                self.firebase.fetchSpecificUser(userId: userId) { user in

                    let isNotInCommentUserBlockList = !user.blockList.contains(localUser.userId)

                    guard isNotInCommentUserBlockList else {

                        dispatchGroup.leave()

                        return

                    }

                    Cache.userCache[userId] = user

                    let comment = CreationComment(user: user, time: time, comment: comment)

                    comments.append(comment)

                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {

            comments.sort { $0.time < $1.time }
            completion(comments)

        }

    }

    private func checkUserInCache(userId: String) -> Bool {
        if Cache.userCache[userId] == nil {
            return false
        } else {
            return true
        }
    }
}
