//
//  CollectionProvider.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/11/26.
//

import Foundation

class CollectionProvider {

    static let shared = CollectionProvider()

    private let firebase = FirebaseFirestoreManager.shared

    func fetchCollections(completion:@escaping ([Creation]) -> Void) {

        let dispatchGroup = DispatchGroup()

        guard let user = LocalUserData.user else { return }

        var collection = [String: Creation]()
        
        user.userCollection.forEach { creationId in
            dispatchGroup.enter()
            getCreation(creationId: creationId) { creation in
                collection[creationId] = creation
                dispatchGroup.enter()
                self.getUserInfoFromCreation(creation: creation) {
                    dispatchGroup.leave()
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            var collections = [Creation]()
            collection.values.forEach { creation in
                collections.append(creation)
            }
            collections.sort { $0.createdTime > $1.createdTime }

            completion(collections)
        }

    }

    private func getCreation(creationId: String, completion: @escaping (Creation) -> Void) {
        if Cache.creationCache[creationId] == nil {
            self.firebase.fetchSpecificCreation(creationId: creationId) { creation in
                Cache.creationCache[creationId] = creation
                completion(creation)
            }
        } else {
            completion(Cache.creationCache[creationId]!)
        }
    }
    private func getUserInfoFromCreation(creation: Creation, completion: @escaping () -> Void) {
        if Cache.userCache[creation.userId] == nil {
            self.firebase.fetchSpecificUser(userId: creation.userId) { user in
                Cache.userCache[creation.userId] = user
                completion()
            }
        } else {
            completion()
        }
    }
}
