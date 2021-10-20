//
//  FirebaseFirestoreManager.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/20.
//

import Foundation
import FirebaseFirestore

class FirebaseFirestoreManager {

    static let shared = FirebaseFirestoreManager()

    func createCollection(
        timeSignature: [String],
        name: String,
        bpm: Int,
        record: [String: [String]]
    ) {

        let articles = Firestore.firestore().collection("creation")

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
}
