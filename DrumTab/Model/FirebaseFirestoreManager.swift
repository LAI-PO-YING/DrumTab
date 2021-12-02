//
//  FirebaseFirestoreManager.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

class FirebaseFirestoreManager {

    static let shared = FirebaseFirestoreManager()

    private lazy var db = Firestore.firestore()
    private lazy var storage = Storage.storage().reference()

    func addCreation(
        timeSignature: [Int],
        name: String,
        bpm: Int,
        published: Bool,
        numberOfSection: Int,
        record: [String: [String]],
        completion: @escaping (String) -> Void
    ) {

        let creation = db.collection("creation")

        let document = creation.document()
        
        let comment: [[String: String]] = []

        let data: [String: Any] = [
            "userId": LocalUserData.userId,
            "id": document.documentID,
            "timeSignature": timeSignature,
            "bpm": bpm,
            "createdTime": NSDate().timeIntervalSince1970,
            "name": name,
            "published": published,
            "record": record,
            "comment": comment,
            "numberOfSection": numberOfSection
        ]

        document.setData(data)
        completion(document.documentID)

    }

    func addPost(
        content: String,
        creationId: String
    ) {
        let post = db.collection("post")

        let document = post.document()

        let like = [String]()

        let data: [String: Any] = [
            "userId": LocalUserData.userId,
            "postId": document.documentID,
            "postTime": NSDate().timeIntervalSince1970,
            "content": content,
            "creationId": creationId,
            "like": like
        ]

        document.setData(data)
    }

    func fetchCreations(completion: @escaping (Result<[Creation], Error>) -> Void) {

        db.collection("creation").whereField("userId", isEqualTo: LocalUserData.userId).whereField("published", isEqualTo: false).getDocuments() { querySnapshot, error in

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
                creations.sort { $0.createdTime > $1.createdTime }
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
    func fetchSpecificUserPosts(userId: String, completion: @escaping (Result<[Post], Error>) -> Void) {

        db.collection("post").whereField("userId", isEqualTo: userId) .getDocuments() { querySnapshot, error in

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
        completion: @escaping (Creation) -> Void
    ) {

        db.collection("creation").whereField("id", isEqualTo: creationId).getDocuments { querySnapshot, error in

            if let error = error {
                print(error)
            } else {

                var currentCreation: Creation?

                for document in querySnapshot!.documents {

                    do {

                        if let creation = try document.data(as: Creation.self, decoder: Firestore.Decoder()) {
                            currentCreation = creation
                        }

                    } catch {

                        print(error)

                    }
                }
                if let currentCreation = currentCreation {
                    completion(currentCreation)
                }
            }
        }

    }

    func fetchSpecificUser(
        userId: String,
        completion: @escaping (User) -> Void
    ) {

        db.collection("user").whereField("userId", isEqualTo: userId).getDocuments { querySnapshot, error in

            if let error = error {
                print(error)
            } else {

                var currentUser: User?

                for document in querySnapshot!.documents {

                    do {

                        if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            currentUser = user
                        }

                    } catch {

                        print(error)

                    }
                }
                if let currentUser = currentUser {

                    completion(currentUser)

                }
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

                for document in querySnapshot!.documents {

                    do {
                        if let post = try document.data(as: Post.self, decoder: Firestore.Decoder()) {
                            self.db.collection("user").whereField("userId", isEqualTo: post.userId).getDocuments { querySnapshot, error in
                                let myDocId = querySnapshot?.documents[0].documentID
                                let myDoc = self.db.collection("user").document("\(myDocId!)")
                                myDoc.updateData([
                                    "likesCount": FieldValue.increment(Int64(1)),
                                ])
                            }
                        }

                    } catch {

                        print(error)

                    }
                }
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

            for document in querySnapshot!.documents {

                do {
                    if let post = try document.data(as: Post.self, decoder: Firestore.Decoder()) {
                        self.db.collection("user").whereField("userId", isEqualTo: post.userId).getDocuments { querySnapshot, error in
                            let myDocId = querySnapshot?.documents[0].documentID
                            let myDoc = self.db.collection("user").document("\(myDocId!)")
                            myDoc.updateData([
                                "likesCount": FieldValue.increment(Int64(-1)),
                            ])
                        }
                    }

                } catch {

                    print(error)

                }
            }
        }
    }
    func deleteCreation(creationId: String) {
        db.collection("creation").document(creationId).delete()
    }
    func uploadComment(
        creationId: String,
        userId: String,
        comment: String
    ) {
        db.collection("creation").whereField("id", isEqualTo: creationId).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                let myDocId = querySnapshot?.documents[0].documentID
                let myDoc = self.db.collection("creation").document("\(myDocId!)")
                myDoc.updateData([
                    "comment": FieldValue.arrayUnion([[
                        "userId": userId,
                        "comment": comment,
                        "time": "\(Int(Date().timeIntervalSince1970))"
                    ]])
                ])
            }
        }
    }
    func addCollection(userId: String, creationId: String) {
        db.collection("user").whereField("userId", isEqualTo: userId).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                let myDocId = querySnapshot?.documents[0].documentID
                let myDoc = self.db.collection("user").document("\(myDocId!)")
                myDoc.updateData([
                    "userCollection": FieldValue.arrayUnion(["\(creationId)"])
                ])
            }
        }
    }
    func removeCollection(userId: String, creationId: String) {
        db.collection("user").whereField("userId", isEqualTo: userId).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                let myDocId = querySnapshot?.documents[0].documentID
                let myDoc = self.db.collection("user").document("\(myDocId!)")
                myDoc.updateData([
                    "userCollection": FieldValue.arrayRemove(["\(creationId)"])
                ])
            }
        }
    }
    func fetchCollections(completion: @escaping ([String]) -> Void) {
        fetchSpecificUser(userId: LocalUserData.userId) { user in
            completion(user.userCollection)
        }
    }
    func createUser(
        uid: String,
        userName: String, userEmail: String,
        completion: @escaping () -> Void
    ) {

        let collection = db.collection("user")

        let document = collection.document()
        
        let followBy = [String]()

        let userCollection = [String]()

        let userFollow = [String]()

        let userPhoto = ""

        let data: [String: Any] = [
            "followBy": followBy,
            "userCollection": userCollection,
            "userEmail": userEmail,
            "createdTime": NSDate().timeIntervalSince1970,
            "userFollow": userFollow,
            "userId": uid,
            "userName": userName,
            "userPhoto": userPhoto,
            "userPhotoId": "", 
            "likesCount": 0,
            "aboutMe": "About me...",
            "blockList": [String](),
            "blockBy": [String]()
        ]

        document.setData(data)
        completion()
    }
    func checkUserSignInBefore(uid: String, completion: @escaping (Result<User?, Error>) -> Void) {
        db.collection("user").whereField("userId", isEqualTo: uid).getDocuments { querySnapshot, error in

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
                completion(.success(currentUser))
            }
        }
    }
    func getRankInfo(completion: @escaping ([User]) -> Void) {
        db.collection("user").order(by: "likesCount", descending: true).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {

                var users = [User]()

                for document in querySnapshot!.documents {

                    do {

                        if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            users.append(user)
                        }

                    } catch {

                        print(error)

                    }
                }
                
                completion(Array(users[0..<3]))
            }
        }
    }
    func getPersonalCreation(
        userId: String,
        completion: @escaping (Result<[Creation], Error>) -> Void
    ) {
        db.collection("creation").whereField("userId", isEqualTo: userId).whereField("published", isEqualTo: true).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {

                var personalCreation = [Creation]()

                for document in querySnapshot!.documents {

                    do {

                        if let creation = try document.data(as: Creation.self, decoder: Firestore.Decoder()) {
                            personalCreation.append(creation)
                        }

                    } catch {

                        completion(.failure(error))

                    }
                }
                personalCreation.sort { $0.createdTime > $1.createdTime }
                completion(.success(personalCreation))
            }
        }
    }
    func getPersonalLikeValue(userId: String, completion: @escaping (Int) -> Void) {
        db.collection("user").whereField("userId", isEqualTo: userId).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {

                var likes = 0

                for document in querySnapshot!.documents {

                    do {

                        if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            likes = user.likesCount
                        }

                    } catch {

                        print(error)

                    }
                }
                completion(likes)
            }
        }
    }
    func getPersonalRank(completion: @escaping (Int) -> Void) {
        db.collection("user").order(by: "likesCount", descending: true).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {

                var usersID = [String]()

                for document in querySnapshot!.documents {

                    do {

                        if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            usersID.append(user.userId)
                        }

                    } catch {

                        print(error)

                    }
                }
                if let index = usersID.firstIndex(of: LocalUserData.userId) {
                    let rank = index + 1
                    completion(rank)
                }
            }
        }
    }
    func getFollowers(userId: String, completion: @escaping (Int) -> Void) {
        db.collection("user").whereField("userId", isEqualTo: userId).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {

                var followers = 0

                for document in querySnapshot!.documents {

                    do {

                        if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            followers = user.followBy.count
                        }

                    } catch {

                        print(error)

                    }
                }
                completion(followers)
            }
        }
    }
    
    func uploadPhoto(image: UIImage) {
        let uniqueStr = NSUUID().uuidString
        guard let imageData = image.jpegData(compressionQuality: 0.15) else { return }
        storage.child("images/\(uniqueStr)").putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                print("Upload fail. Check image data.")
                return
            }
            self.storage.child("images/\(uniqueStr)").downloadURL { url, error in
                guard let url = url, error == nil else {
                    print("Fail to fetch photo url")
                    return
                }
                let urlStr = url.absoluteString
                self.db.collection("user").whereField("userId", isEqualTo: LocalUserData.userId).getDocuments { querySnapshot, error in
                    if let error = error {
                        print(error)
                    } else {
                        let documentID = querySnapshot?.documents[0].documentID
                        let userDocument = self.db.collection("user").document(documentID!)
                        do {

                            if let user = try querySnapshot?.documents[0].data(as: User.self, decoder: Firestore.Decoder()) {
                                if user.userPhotoId == "" {
                                    userDocument.updateData([
                                        "userPhoto": urlStr,
                                        "userPhotoId": uniqueStr
                                    ])
                                    print("Update successfully.")
                                } else {
                                    self.storage.child("images/\(user.userPhotoId)").delete { error in
                                        if let error = error {
                                            print(error)
                                          } else {
                                              userDocument.updateData([
                                                  "userPhoto": urlStr,
                                                  "userPhotoId": uniqueStr
                                              ])
                                              print("Update successfully.")
                                          }
                                    }
                                }
                            }
                        } catch {

                            print(error)

                        }
                    }
                }
            }
        }
    }
    func updateUserName(name: String) {
        self.db.collection("user").whereField("userId", isEqualTo: LocalUserData.userId).getDocuments{ querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                let documentID = querySnapshot?.documents[0].documentID
                let userDocument = self.db.collection("user").document(documentID!)
                userDocument.updateData([
                    "userName": name
                ])
            }
        }
    }
    func updateUserAboutMe(aboutMe: String) {
        self.db.collection("user").whereField("userId", isEqualTo: LocalUserData.userId).getDocuments{ querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                let documentID = querySnapshot?.documents[0].documentID
                let userDocument = self.db.collection("user").document(documentID!)
                userDocument.updateData([
                    "aboutMe": aboutMe
                ])
            }
        }
    }
    func addFollower(userId: String) {
        db.collection("user").whereField("userId", isEqualTo: LocalUserData.userId).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                let myDocId = querySnapshot?.documents[0].documentID
                let myDoc = self.db.collection("user").document("\(myDocId!)")
                myDoc.updateData([
                    "userFollow": FieldValue.arrayUnion(["\(userId)"])
                ])
            }
        }
        db.collection("user").whereField("userId", isEqualTo: userId).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                let myDocId = querySnapshot?.documents[0].documentID
                let myDoc = self.db.collection("user").document("\(myDocId!)")
                myDoc.updateData([
                    "followBy": FieldValue.arrayUnion(["\(LocalUserData.userId)"])
                ])
            }
        }
    }
    func removeFollower(userId: String) {
        db.collection("user").whereField("userId", isEqualTo: LocalUserData.userId).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                let myDocId = querySnapshot?.documents[0].documentID
                let myDoc = self.db.collection("user").document("\(myDocId!)")
                myDoc.updateData([
                    "userFollow": FieldValue.arrayRemove(["\(userId)"])
                ])
            }
        }
        db.collection("user").whereField("userId", isEqualTo: userId).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                let myDocId = querySnapshot?.documents[0].documentID
                let myDoc = self.db.collection("user").document("\(myDocId!)")
                myDoc.updateData([
                    "followBy": FieldValue.arrayRemove(["\(LocalUserData.userId)"])
                ])
            }
        }
    }
    func blockUser(userId: String) {
        db.collection("user").whereField("userId", isEqualTo: LocalUserData.userId).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                let myDocId = querySnapshot?.documents[0].documentID
                let myDoc = self.db.collection("user").document("\(myDocId!)")
                myDoc.updateData([
                    "blockList": FieldValue.arrayUnion(["\(userId)"])
                ])
            }
        }
        db.collection("user").whereField("userId", isEqualTo: userId).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                let myDocId = querySnapshot?.documents[0].documentID
                let myDoc = self.db.collection("user").document("\(myDocId!)")
                myDoc.updateData([
                    "blockBy": FieldValue.arrayUnion(["\(LocalUserData.userId)"])
                ])
            }
        }
    }
    func unblockUser(userId: String) {
        db.collection("user").whereField("userId", isEqualTo: LocalUserData.userId).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                let myDocId = querySnapshot?.documents[0].documentID
                let myDoc = self.db.collection("user").document("\(myDocId!)")
                myDoc.updateData([
                    "blockList": FieldValue.arrayRemove(["\(userId)"])
                ])
            }
        }
        db.collection("user").whereField("userId", isEqualTo: userId).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                let myDocId = querySnapshot?.documents[0].documentID
                let myDoc = self.db.collection("user").document("\(myDocId!)")
                myDoc.updateData([
                    "blockBy": FieldValue.arrayRemove(["\(LocalUserData.userId)"])
                ])
            }
        }
    }
}
