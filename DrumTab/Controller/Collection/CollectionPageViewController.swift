//
//  CollectionPageViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/18.
//

import UIKit

class CollectionPageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private struct CollectionLocalUse {
        var creation: Creation
        var creater: User
    }
    private var collections: [CollectionLocalUse] = [] {
        didSet {
            filteredCollections = collections
        }
    }
    private lazy var filteredCollections = collections {
        didSet {
            tableView.reloadData()
        }
    }

    let firebase = FirebaseFirestoreManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        collections = []
        firebase.fetchCollections { collectionIDs in
            collectionIDs.forEach { collectionID in
                self.firebase.fetchSpecificCreation(creationId: collectionID) { result in
                    switch result {
                    case .success(let creation):
                        self.firebase.fetchSpecificUser(userId: creation.userId) { result in
                            switch result {
                            case .success(let user):
                                let collection = CollectionLocalUse(creation: creation, creater: user)
                                self.collections.append(collection)
                            case .failure(let error):
                                print(error)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}

extension CollectionPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCollections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(CollectionTableViewCell.self)",
            for: indexPath
        ) as? CollectionTableViewCell else { return UITableViewCell() }
        let collection = filteredCollections[indexPath.row]
        cell.setupCell(
            creationName: collection.creation.name,
            userImage: UIImage(systemName: "tropicalstorm")!,
            userName: collection.creater.userName
        )
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            firebase.removeCollection(
                userId: "HKL3bzZ7aJOAEa5Fo0xO",
                creationId: collections[indexPath.row].creation.id
            )
            collections.remove(at: indexPath.row)
        } else if editingStyle == .insert {

        }
    }
}

extension CollectionPageViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
           searchText.isEmpty == false {
            filteredCollections = collections.filter({ collection in
                collection.creation.name.localizedStandardContains(searchText)
            })
        } else {
            filteredCollections = collections
        }
    }
}
