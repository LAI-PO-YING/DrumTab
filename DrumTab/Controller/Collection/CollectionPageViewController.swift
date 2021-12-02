//
//  CollectionPageViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/18.
//

import UIKit

class CollectionPageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let collectionProvider = CollectionProvider.shared
    private var collections = [Creation]() {
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
        searchController.searchBar.tintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        collectionProvider.fetchCollections { collections in
            self.collections = collections
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        cell.setupCell(collection: collection)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let selectedCreationId = filteredCollections[indexPath.row].id

        let previewPageVC = UIStoryboard.home.instantiateViewController(withIdentifier:
            String(describing: PreviewPageViewController.self)
        )

        guard let previewPageVC = previewPageVC as? PreviewPageViewController else { return }

        previewPageVC.creationId = selectedCreationId

        show(previewPageVC, sender: nil)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            firebase.removeCollection(
                userId: LocalUserData.userId,
                creationId: collections[indexPath.row].id
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
                collection.name.localizedStandardContains(searchText)
            })
        } else {
            filteredCollections = collections
        }
    }
}
