//
//  RecordPageViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/19.
//

import UIKit

class RecordPageViewController: UIViewController {

    let drumKit = DrumKit()
    let firebaseFirestoreManager = FirebaseFirestoreManager.shared

    var timer: Timer?
    var timerIndex = 0
    // 一小節的拍數×小節數÷速度＝演奏時間(分鐘)
    var beatInASection = 4
    var numberOfSection = 40
    var bpm = 120
    var speed: Double = 0

    @IBOutlet weak var hiHatSelectionView: SelectionView!
    @IBOutlet weak var snareSelectionView: SelectionView!
    @IBOutlet weak var tom1SelectionView: SelectionView!
    @IBOutlet weak var tom2SelectionView: SelectionView!
    @IBOutlet weak var floorTomSelectionView: SelectionView!
    @IBOutlet weak var stoolSelectionView: SelectionView!
    @IBOutlet weak var crashSelectionView: SelectionView!
    @IBOutlet weak var rideSelectionView: SelectionView!

    @IBOutlet weak var bpmTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSelectionViewDelegate()
    }

    func setupSelectionViewDelegate() {
        hiHatSelectionView.delegate = self
        snareSelectionView.delegate = self
        tom1SelectionView.delegate = self
        tom2SelectionView.delegate = self
        floorTomSelectionView.delegate = self
        stoolSelectionView.delegate = self
        crashSelectionView.delegate = self
        rideSelectionView.delegate = self
        hiHatSelectionView.dataSource = self
        snareSelectionView.dataSource = self
        tom1SelectionView.dataSource = self
        tom2SelectionView.dataSource = self
        floorTomSelectionView.dataSource = self
        stoolSelectionView.dataSource = self
        crashSelectionView.dataSource = self
        rideSelectionView.dataSource = self
    }

    func startTimer () {
        guard timer == nil else { return }

        timer = Timer.scheduledTimer(
            timeInterval: speed,
            target: drumKit,
            selector: #selector(drumKit.playDrumSound),
            userInfo: nil,
            repeats: true
        )
        RunLoop.current.add(self.timer!, forMode: .common)

    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    @IBAction func playButtonPressed(_ sender: UIButton) {

        timerIndex += 1
        speed = 60.0 / Double(bpm) / Double(beatInASection)
        if timerIndex == 1 {
            startTimer()
            timerIndex += 1
            sender.setTitle("Stop", for: .normal)
            bpmTextField.isEnabled = false
        } else {
            stopTimer()
            timerIndex = 0
            sender.setTitle("Play", for: .normal)
            bpmTextField.isEnabled = true
        }
    }

    @IBAction func bpmChanged(_ sender: Any) {
        guard let bpmStr = bpmTextField.text,
              let bpm = Int(bpmStr) else { return }
        self.bpm = bpm
    }
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        firebaseFirestoreManager.createCollection(
            timeSignature: ["4", "4"],
            name: "Test",
            bpm: bpm,
            record: [
                "hiHat": DrumKit.hiHat,
                "snare": DrumKit.snare,
                "tom1": DrumKit.tom1,
                "tomF": DrumKit.tomF,
                "stool": DrumKit.stool,
                "crash": DrumKit.crash
            ]
        )
    }

    deinit {
        stopTimer()
    }

}

extension RecordPageViewController: SelectionViewDelegate {
    func didSelected(selectionView: SelectionView, index: Int) {
        switch selectionView {
        case hiHatSelectionView:
            if DrumKit.hiHat[index] == "0" {
                DrumKit.hiHat[index] = "1"
            } else {
                DrumKit.hiHat[index] = "0"
            }
        case snareSelectionView:
            if DrumKit.snare[index] == "0" {
                DrumKit.snare[index] = "1"
            } else {
                DrumKit.snare[index] = "0"
            }
        case tom1SelectionView:
            if DrumKit.tom1[index] == "0" {
                DrumKit.tom1[index] = "1"
            } else {
                DrumKit.tom1[index] = "0"
            }
//        case tom2SelectionView:
//            if DrumKit.tom2[index] == "0" {
//                DrumKit.tom2[index] = "1"
//            } else {
//                DrumKit.tom2[index] = "0"
//            }
        case floorTomSelectionView:
            if DrumKit.tomF[index] == "0" {
                DrumKit.tomF[index] = "1"
            } else {
                DrumKit.tomF[index] = "0"
            }
        case stoolSelectionView:
            if DrumKit.stool[index] == "0" {
                DrumKit.stool[index] = "1"
            } else {
                DrumKit.stool[index] = "0"
            }
        case crashSelectionView:
            if DrumKit.crash[index] == "0" {
                DrumKit.crash[index] = "1"
            } else {
                DrumKit.crash[index] = "0"
            }
//        case rideSelectionView:
//            if DrumKit.ride[index] == "0" {
//                DrumKit.ride[index] = "1"
//            } else {
//                DrumKit.ride[index] = "0"
//            }
        default:
            break
        }
    }
}

extension RecordPageViewController: SelectionViewDatasource {

    func selectStatus(selectionView: SelectionView) -> [String] {

        switch selectionView {
        case hiHatSelectionView:
            return DrumKit.hiHat
        case snareSelectionView:
            return DrumKit.snare
        case tom1SelectionView:
            return DrumKit.tom1
//        case tom2SelectionView:
//            return DrumKit.tom2
        case floorTomSelectionView:
            return DrumKit.tomF
        case stoolSelectionView:
            return DrumKit.stool
        case crashSelectionView:
            return DrumKit.crash
//        case rideSelectionView:
//            return DrumKit.ride
        default:
            return ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
        }
    }

}