//
//  CreationPageViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/18.
//

import UIKit
import ESPullToRefresh

class CreationPageViewController: UIViewController {

    let firebaseFirestoreManager = FirebaseFirestoreManager.shared

    var creations = [Creation]() {
        didSet {
            tableView.reloadData()
        }
    }
    var currentSelectedCellIndex: Int?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "STHeitiTC-Light", size: 20)!]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.es.addPullToRefresh { [unowned self] in
            firebaseFirestoreManager.fetchCreations { result in
                switch result {
                case .success(let creations):
                    self.creations = creations
                case .failure(let error):
                    print(error)
                }
                self.tableView.es.stopPullToRefresh()
            }
        }

        firebaseFirestoreManager.fetchCreations { result in
            switch result {
            case .success(let creations):
                self.creations = creations
            case .failure(let error):
                print(error)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? CreationPreviewViewController else {
            fatalError("Destination is not CreationPreviewViewController")
        }
        if segue.identifier == "FromCell" {
            guard let currentSelectedCellIndex = currentSelectedCellIndex else { return }
            let currentSelectedCreation = creations[currentSelectedCellIndex]
            dvc.bpm = currentSelectedCreation.bpm
            dvc.beatInASection = currentSelectedCreation.timeSignature[0]
            dvc.creationId = currentSelectedCreation.id
            dvc.numberOfSection = currentSelectedCreation.numberOfSection
            DrumKit.updateDrumRecord(creation: currentSelectedCreation)
            self.currentSelectedCellIndex = nil
        } else {
            dvc.bpm = 120
            dvc.beatInASection = 4
            dvc.numberOfSection = 1
            dvc.creationId = nil
            DrumKit.initSounds()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseFirestoreManager.fetchCreations { result in
            switch result {
            case .success(let creations):
                self.creations = creations
            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "FromPlus", sender: nil)
    }

}

extension CreationPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        creations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(CreationPageTableViewCell.self)",
            for: indexPath
        ) as? CreationPageTableViewCell else { return UITableViewCell() }

        cell.setupCell(
            title: creations[indexPath.row].name,
            time: creations[indexPath.row].createdTime,
            bpm: creations[indexPath.row].bpm,
            timeSignature: creations[indexPath.row].timeSignature
        )

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedCellIndex = indexPath.row
        performSegue(withIdentifier: "FromCell", sender: nil)
    }

}
