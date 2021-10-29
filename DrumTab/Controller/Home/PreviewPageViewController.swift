//
//  PreviewPageViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/28.
//

import UIKit

class PreviewPageViewController: UIViewController {
    @IBOutlet weak var addInToCollectionButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    let drumKit = DrumKit()
    var playTimer: Timer?
    var autoScrollTimer: Timer?
    var timerIndex = 0
    var speed: Double = 0

    var creationId: String?
    var creation: Creation? {
        didSet {
            collectionView.reloadData()
        }
    }
    let firebase = FirebaseFirestoreManager.shared

    func startTimer () {
        guard playTimer == nil else { return }
        guard autoScrollTimer == nil else { return }
        
        playTimer = Timer.scheduledTimer(
            timeInterval: speed,
            target: drumKit,
            selector: #selector(drumKit.playDrumSound),
            userInfo: nil,
            repeats: true
        )
        RunLoop.current.add(self.playTimer!, forMode: .common)
        autoScrollTimer = Timer.scheduledTimer(
            timeInterval: speed*4,
            target: self,
            selector: #selector(autoScroll),
            userInfo: nil,
            repeats: true
        )
        RunLoop.current.add(self.playTimer!, forMode: .common)
    }
    
    func stopTimer() {
        playTimer?.invalidate()
        playTimer = nil
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
        DrumKit.index = 0
    }

    @objc func autoScroll() {
        collectionView.scrollToItem(at: [0, DrumKit.index/4], at: .top, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addInToCollectionButton.setTitle("", for: .normal)
        rewindButton.setTitle("", for: .normal)
        playButton.setTitle("", for: .normal)
        forwardButton.setTitle("", for: .normal)
        sendButton.setTitle("", for: .normal)

        collectionView.delegate = self
        collectionView.dataSource = self
        if let creationId = creationId {
            firebase.fetchSpecificCreation(creationId: creationId) { result in
                switch result {
                case .success(let creation):
                    self.creation = creation
                    DrumKit.hiHat = creation.record["hiHat"]!
                    DrumKit.snare = creation.record["snare"]!
                    DrumKit.tom1 = creation.record["tom1"]!
                    DrumKit.tom2 = creation.record["tom2"]!
                    DrumKit.tomF = creation.record["tomF"]!
                    DrumKit.bass = creation.record["bass"]!
                    DrumKit.crash = creation.record["crash"]!
                    DrumKit.ride = creation.record["ride"]!
                    self.creation = creation
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    deinit {
        stopTimer()
    }
    @IBAction func backButtoPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func playButtonPressed(_ sender: UIButton) {
        timerIndex += 1
        speed = 60.0 / Double(creation!.bpm) / Double(creation!.timeSignature[0])
        if timerIndex == 1 {
            startTimer()
            timerIndex += 1
            sender.setImage(UIImage(systemName: "pause"), for: .normal)
        } else {
            stopTimer()
            timerIndex = 0
            sender.setImage(UIImage(systemName: "play"), for: .normal)
        }
    }
    @IBAction func forwardButtonPressed(_ sender: Any) {
        if DrumKit.index+16 >= DrumKit.hiHat.count-1 {
            DrumKit.index = DrumKit.hiHat.count-1
        } else {
            DrumKit.index += 16
        }
    }
    @IBAction func rewindButtonPressed(_ sender: Any) {
        if DrumKit.index-16 <= 0 {
            DrumKit.index = 0
        } else {
            DrumKit.index -= 16
        }
    }
    
}

extension PreviewPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (creation?.record["hiHat"]?.count ?? 0) / 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
