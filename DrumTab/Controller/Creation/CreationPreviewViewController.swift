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
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
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
            creationId = nil
        }
        dvc.delegate = self
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    func didPressedSubmitButton() {
        collectionView.reloadData()
    }
    
    func didChangeSelectedStatus(index: Int) {
        collectionView?.reloadItems(at: [[0, index/4]])
    }
}
