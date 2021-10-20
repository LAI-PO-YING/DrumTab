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

    lazy var db = Firestore.firestore()

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

    func fetchArticles(completion: @escaping (Result<[Creation], Error>) -> Void) {

        db.collection("creation").order(by: "createdTime", descending: true).getDocuments() { (querySnapshot, error) in

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
}
