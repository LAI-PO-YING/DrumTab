//
//  CreationPreviewViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/19.
//

import UIKit

class CreationPreviewViewController: UIViewController {

    var bpm: Int?
    var beatInASection: Int?
    var creationId: String?
    var numberOfSection: Int?
    let firebaseFirestoreManager = FirebaseFirestoreManager.shared
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var publishButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        publishButton.backgroundColor = UIColor(named: "G1")
        publishButton.layer.cornerRadius = 5
        saveButton.backgroundColor = UIColor(named: "D1")
        saveButton.layer.cornerRadius = 5
        addButton.backgroundColor = UIColor(named: "R1")
        addButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? RecordPageViewController else {
            fatalError("Destination is not RecordPageViewController")
        }
        dvc.bpm = self.bpm!
        dvc.beatInASection = self.beatInASection!
        dvc.numberOfSection = self.numberOfSection ?? 1
        if creationId != nil {
            dvc.creationId = self.creationId!
        } else {
            dvc.creationId = nil
        }
        dvc.delegate = self
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        let lastIndex = DrumKit.hiHat.count - 1
        let firstIndext = DrumKit.hiHat.count - 16
        DrumKit.hiHat += DrumKit.hiHat[firstIndext...lastIndex]
        DrumKit.snare += DrumKit.snare[firstIndext...lastIndex]
        DrumKit.tom1 += DrumKit.tom1[firstIndext...lastIndex]
        DrumKit.tom2 += DrumKit.tom2[firstIndext...lastIndex]
        DrumKit.tomF += DrumKit.tomF[firstIndext...lastIndex]
        DrumKit.bass += DrumKit.bass[firstIndext...lastIndex]
        DrumKit.crash += DrumKit.crash[firstIndext...lastIndex]
        DrumKit.ride += DrumKit.ride[firstIndext...lastIndex]
        numberOfSection! += 1
        collectionView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name("dataChanged"), object: nil)
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        let controller = UIAlertController(
            title: "Save your draft",
            message: "Pleas enter your creation name.", preferredStyle: .alert
        )
        controller.addTextField { textField in
            textField.placeholder = "Creation name"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned controller] _ in
            if let name = controller.textFields?[0].text {
                self.firebaseFirestoreManager.addCreation(
                    timeSignature: [4, 4],
                    name: name,
                    bpm: self.bpm!,
                    published: false,
                    numberOfSection: DrumKit.hiHat.count / 16,
                    record: [
                        "hiHat": DrumKit.hiHat,
                        "snare": DrumKit.snare,
                        "tom1": DrumKit.tom1,
                        "tom2": DrumKit.tom2,
                        "tomF": DrumKit.tomF,
                        "bass": DrumKit.bass,
                        "crash": DrumKit.crash,
                        "ride": DrumKit.ride
                    ]) { _ in
                        if self.creationId != nil {
                            self.firebaseFirestoreManager.deleteCreation(creationId: self.creationId!)
                            self.creationId = nil
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
            }
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    @IBAction func publishButtonPressed(_ sender: Any) {
        let controller = UIAlertController(
            title: "Publish your creation",
            message: "Pleas enter your creation name.", preferredStyle: .alert
        )
        controller.addTextField { textField in
            textField.placeholder = "Creation name"
        }
        controller.addTextField { textField in
            textField.placeholder = "Content"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned controller] _ in
            if let name = controller.textFields?[0].text,
                let content = controller.textFields?[1].text {
                self.firebaseFirestoreManager.addCreation(
                    timeSignature: [4, 4],
                    name: name,
                    bpm: self.bpm!,
                    published: true,
                    numberOfSection: DrumKit.hiHat.count / 16,
                    record: [
                        "hiHat": DrumKit.hiHat,
                        "snare": DrumKit.snare,
                        "tom1": DrumKit.tom1,
                        "tom2": DrumKit.tom2,
                        "tomF": DrumKit.tomF,
                        "bass": DrumKit.bass,
                        "crash": DrumKit.crash,
                        "ride": DrumKit.ride
                    ]) { id in
                        if self.creationId != nil {
                            self.firebaseFirestoreManager.deleteCreation(creationId: self.creationId!)
                            self.creationId = nil
                        }
                        self.firebaseFirestoreManager.addPost(
                            content: content,
                            creationId: id
                        )
                        self.navigationController?.popViewController(animated: true)
                    }
            }
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
}

extension CreationPreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DrumKit.hiHat.count / 4
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    	) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(PreviewCollectionViewCell.self)",
            for: indexPath
        ) as? PreviewCollectionViewCell else { return UICollectionViewCell() }
            var currentSectionHiHat: [String] = []
            for index in 4*indexPath.row ... 4*indexPath.row+3 {
                currentSectionHiHat.append(DrumKit.hiHat[index])
            }
            var currentSectionSnare: [String] = []
            for index in 4*indexPath.row ... 4*indexPath.row+3 {
                currentSectionSnare.append(DrumKit.snare[index])
            }
            var currentSectionTom1: [String] = []
            for index in 4*indexPath.row ... 4*indexPath.row+3 {
                currentSectionTom1.append(DrumKit.tom1[index])
            }
            var currentSectionTom2: [String] = []
            for index in 4*indexPath.row ... 4*indexPath.row+3 {
                currentSectionTom2.append(DrumKit.tom2[index])
            }
            var currentSectionTomF: [String] = []
            for index in 4*indexPath.row ... 4*indexPath.row+3 {
                currentSectionTomF.append(DrumKit.tomF[index])
            }
            var currentSectionBass: [String] = []
            for index in 4*indexPath.row ... 4*indexPath.row+3 {
                currentSectionBass.append(DrumKit.bass[index])
            }
            var currentSectionCrash: [String] = []
            for index in 4*indexPath.row ... 4*indexPath.row+3 {
                currentSectionCrash.append(DrumKit.crash[index])
            }
            var currentSectionRide: [String] = []
            for index in 4*indexPath.row ... 4*indexPath.row+3 {
                currentSectionRide.append(DrumKit.ride[index])
            }

            cell.addSectionView(
                hiHat: currentSectionHiHat,
                snare: currentSectionSnare,
                tom1: currentSectionTom1,
                tom2: currentSectionTom2,
                tomF: currentSectionTomF,
                bass: currentSectionBass,
                crash: currentSectionCrash,
                ride: currentSectionRide
            )
        return cell
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: view.bounds.width / 4 - 0.01, height: 86)
    }

}

extension CreationPreviewViewController: RecordPageViewControllerDelegate {
    func didChangedBPM(bpm: Int) {
        self.bpm = bpm
    }
    
    func didPressedSubmitButton() {
        collectionView.reloadData()
    }
    
    func didChangeSelectedStatus(index: Int) {
        collectionView?.reloadItems(at: [[0, index/4]])
    }
}
