//
//  PostProvider.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/11/24.
//

import Foundation

class PostProvider {

    static let shared = PostProvider()

    private let firebase = FirebaseFirestoreManager.shared

    func fetchAllPost(completion: @escaping ([Post]) -> Void) {
                
        let dispatchGroup = DispatchGroup()

        var postResults = [Post]()

        dispatchGroup.enter()

        self.firebase.fetchPosts { result in
            switch result {
            case .success(let posts):
                postResults = posts
                posts.forEach { post in

                    dispatchGroup.enter()
                    self.getUserInfoFromPost(post: post) {
                        dispatchGroup.leave()
                    }
                    dispatchGroup.enter()
                    self.getCreationFromfoInPost(post: post) {
                        dispatchGroup.leave()
                    }
                }
            case .failure(let error):
                print(error)
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion(postResults)
        }
    }

    func fetchSpecificUserPost(
        userId: String,
        completion: @escaping ([Post]) -> Void
    ) {

        let dispatchGroup = DispatchGroup()

        var postResults = [Post]()

        dispatchGroup.enter()

        firebase.fetchSpecificUserPosts(userId: userId) { result in

            switch result {

            case .success(let posts):

                postResults = posts
                posts.forEach { post in

                    dispatchGroup.enter()
                    self.getUserInfoFromPost(post: post) {
                        dispatchGroup.leave()
                    }
                    dispatchGroup.enter()
                    self.getCreationFromfoInPost(post: post) {
                        dispatchGroup.leave()
                    }
                }

            case .failure(let error):

                print(error)

            }
            dispatchGroup.leave()
            
        }
        dispatchGroup.notify(queue: .main) {

            postResults.sort { $0.postTime > $1.postTime }
            completion(postResults)
        }
    }
 
    private func getUserInfoFromPost(post: Post, completion: @escaping () -> Void) {
        if Cache.userCache[post.userId] == nil {
            self.firebase.fetchSpecificUser(userId: post.userId) { user in
                Cache.userCache[post.userId] = user
                completion()
            }
        } else {
            completion()
        }
    }
    private func getCreationFromfoInPost(post: Post, completion: @escaping () -> Void) {
        if Cache.creationCache[post.creationId] == nil {
            self.firebase.fetchSpecificCreation(creationId: post.creationId) { creation in
                Cache.creationCache[post.creationId] = creation
                completion()
            }
        } else {
            completion()
        }
    }

}
