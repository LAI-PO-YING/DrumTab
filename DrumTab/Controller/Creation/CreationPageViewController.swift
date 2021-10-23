//
//  CreationPageViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/18.
//

import UIKit

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

        tableView.delegate = self
        tableView.dataSource = self

        firebaseFirestoreManager.fetchArticles { result in
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
            DrumKit.hiHat = currentSelectedCreation.record["hiHat"]!
            DrumKit.snare = currentSelectedCreation.record["snare"]!
            DrumKit.tom1 = currentSelectedCreation.record["tom1"]!
            DrumKit.tom2 = currentSelectedCreation.record["tom2"]!
            DrumKit.tomF = currentSelectedCreation.record["tomF"]!
            DrumKit.bass = currentSelectedCreation.record["bass"]!
            DrumKit.crash = currentSelectedCreation.record["crash"]!
            DrumKit.ride = currentSelectedCreation.record["ride"]!
            self.currentSelectedCellIndex = nil
        } else {
            dvc.bpm = 120
            dvc.beatInASection = 4
            DrumKit.initSounds()
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
