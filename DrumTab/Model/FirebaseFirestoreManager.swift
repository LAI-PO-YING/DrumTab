//
//  FirebaseFirestoreManager.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseFirestoreManager {

    static let shared = FirebaseFirestoreManager()

    private lazy var db = Firestore.firestore()

    func createCollection(
        timeSignature: [Int],
        name: String,
        bpm: Int,
        record: [String: [String]]
    ) {

        let articles = db.collection("creation")

        let document = articles.document()

        let data: [String: Any] = [
            "id": document.documentID,
            "timeSignature": timeSignature,
            "bpm": bpm,
            "createdTime": NSDate().timeIntervalSince1970,
            "name": name,
            "record": record
        ]

        document.setData(data)

    }

    func fetchCreations(completion: @escaping (Result<[Creation], Error>) -> Void) {

        db.collection("creation").order(by: "createdTime", descending: true).getDocuments() { querySnapshot, error in

            if let error = error {
                completion(.failure(error))
            } else {

                var creations = [Creation]()

                for document in querySnapshot!.documents {

                    do {

                        if let creation = try document.data(as: Creation.self, decoder: Firestore.Decoder()) {
                            creations.append(creation)
                        }

                    } catch {

                        completion(.failure(error))

                    }
                }
                completion(.success(creations))
            }
        }
    }

    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {

        db.collection("post").order(by: "postTime", descending: true).getDocuments() { querySnapshot, error in

            if let error = error {
                completion(.failure(error))
            } else {

                var posts = [Post]()

                for document in querySnapshot!.documents {

                    do {

                        if let post = try document.data(as: Post.self, decoder: Firestore.Decoder()) {
                            posts.append(post)
                        }

                    } catch {

                        completion(.failure(error))

                    }
                }
                completion(.success(posts))
            }
        }
    }

    func fetchSpecificCreation(
        creationId: String,
        completion: @escaping (Result<Creation, Error>) -> Void
    ) {

        db.collection("creation").whereField("id", isEqualTo: creationId).getDocuments { querySnapshot, error in

            if let error = error {
                completion(.failure(error))
            } else {

                var currentCreation: Creation?

                for document in querySnapshot!.documents {

                    do {

                        if let creation = try document.data(as: Creation.self, decoder: Firestore.Decoder()) {
                            currentCreation = creation
                        }

                    } catch {

                        completion(.failure(error))

                    }
                }
                completion(.success(currentCreation!))
            }
        }

    }

    func fetchSpecificUser(
        userId: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {

        db.collection("user").whereField("userId", isEqualTo: userId).getDocuments { querySnapshot, error in

            if let error = error {
                completion(.failure(error))
            } else {

                var currentUser: User?

                for document in querySnapshot!.documents {

                    do {

                        if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            currentUser = user
                        }

                    } catch {

                        completion(.failure(error))

                    }
                }
                completion(.success(currentUser!))
            }
        }
    }

    func addLike(postId: String, userId: String) {
        db.collection("post").whereField("postId", isEqualTo: postId).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                let myDocId = querySnapshot?.documents[0].documentID
                let myDoc = self.db.collection("post").document("\(myDocId!)")
                myDoc.updateData([
                    "like": FieldValue.arrayUnion(["\(userId)"])
                ])
            }
        }
    }
    func removeLike(postId: String, userId: String) {
        db.collection("post").whereField("postId", isEqualTo: postId).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                let myDocId = querySnapshot?.documents[0].documentID
                let myDoc = self.db.collection("post").document("\(myDocId!)")
                myDoc.updateData([
                    "like": FieldValue.arrayRemove(["\(userId)"])
                ])
            }
        }
    }
}
