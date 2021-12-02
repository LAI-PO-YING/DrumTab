//
//  RecordPageViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/19.
//

import UIKit

protocol RecordPageViewControllerDelegate: AnyObject {
    func didChangeSelectedStatus(index: Int)
    func didPressedSubmitButton()
    func didChangedBPM(bpm: Int)
    func didPressedPlayButton(speed: Double, start: Bool)
}

class RecordPageViewController: UIViewController {
    
    weak var delegate: RecordPageViewControllerDelegate?
    let drumKit = DrumKit()
    let firebaseFirestoreManager = FirebaseFirestoreManager.shared
    
    var playTimer: Timer?
    var autoScrollTimer: Timer?
    var timerIndex = 0
    // 一小節的拍數×小節數÷速度＝演奏時間(分鐘)
    var creationId: String?
    var beatInASection = 4
    var numberOfSection = 1
    var bpm = 60
    var speed: Double = 0
    var picker = UIPickerView()
    var pickerData = [String]()
    
    @IBOutlet weak var hiHatSelectionView: SelectionView!
    @IBOutlet weak var snareSelectionView: SelectionView!
    @IBOutlet weak var tom1SelectionView: SelectionView!
    @IBOutlet weak var tom2SelectionView: SelectionView!
    @IBOutlet weak var floorTomSelectionView: SelectionView!
    @IBOutlet weak var bassSelectionView: SelectionView!
    @IBOutlet weak var crashSelectionView: SelectionView!
    @IBOutlet weak var rideSelectionView: SelectionView!
    
    @IBOutlet weak var bpmTextField: UITextField!
    @objc func closeKeyboard(){
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationName = Notification.Name("dataChanged")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSelectionView), name: notificationName, object: nil)
        setupSelectionViewDelegate()
        bpmTextField.text = "\(bpm)"
        for bpm in 60...140 {
            pickerData.append("\(bpm)")
        }
        picker.delegate = self
        picker.dataSource = self
        bpmTextField.inputView = picker
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
        NotificationCenter.default.removeObserver(self)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupSelectionViewDelegate() {
        hiHatSelectionView.delegate = self
        snareSelectionView.delegate = self
        tom1SelectionView.delegate = self
        tom2SelectionView.delegate = self
        floorTomSelectionView.delegate = self
        bassSelectionView.delegate = self
        crashSelectionView.delegate = self
        rideSelectionView.delegate = self
        hiHatSelectionView.dataSource = self
        snareSelectionView.dataSource = self
        tom1SelectionView.dataSource = self
        tom2SelectionView.dataSource = self
        floorTomSelectionView.dataSource = self
        bassSelectionView.dataSource = self
        crashSelectionView.dataSource = self
        rideSelectionView.dataSource = self
    }
    
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
    }
    
    func stopTimer() {
        playTimer?.invalidate()
        playTimer = nil
        DrumKit.index = 0
    }

    @objc func reloadSelectionView() {
        hiHatSelectionView.collectionView.reloadData()
        snareSelectionView.collectionView.reloadData()
        tom1SelectionView.collectionView.reloadData()
        tom2SelectionView.collectionView.reloadData()
        floorTomSelectionView.collectionView.reloadData()
        bassSelectionView.collectionView.reloadData()
        crashSelectionView.collectionView.reloadData()
        rideSelectionView.collectionView.reloadData()
        numberOfSection += 1
    }
    
    @objc func autoScroll() {
        hiHatSelectionView.collectionView.scrollToItem(
            at: [0, DrumKit.index],
            at: .centeredHorizontally,
            animated: false
        )
        snareSelectionView.collectionView.scrollToItem(
            at: [0, DrumKit.index],
            at: .centeredHorizontally,
            animated: false
        )
        tom1SelectionView.collectionView.scrollToItem(
            at: [0, DrumKit.index],
            at: .centeredHorizontally,
            animated: false
        )
        tom2SelectionView.collectionView.scrollToItem(
            at: [0, DrumKit.index],
            at: .centeredHorizontally,
            animated: false
        )
        floorTomSelectionView.collectionView.scrollToItem(
            at: [0, DrumKit.index],
            at: .centeredHorizontally,
            animated: false
        )
        bassSelectionView.collectionView.scrollToItem(
            at: [0, DrumKit.index],
            at: .centeredHorizontally,
            animated: false
        )
        crashSelectionView.collectionView.scrollToItem(
            at: [0, DrumKit.index],
            at: .centeredHorizontally,
            animated: false
        )
        rideSelectionView.collectionView.scrollToItem(
            at: [0, DrumKit.index],
            at: .centeredHorizontally,
            animated: false
        )
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        
        timerIndex += 1
        speed = 60.0 / Double(bpm) / Double(beatInASection)
        if timerIndex == 1 {
            startTimer()
            self.delegate?.didPressedPlayButton(speed: speed * 4, start: true)
            timerIndex += 1
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            bpmTextField.isEnabled = false
        } else {
            stopTimer()
            self.delegate?.didPressedPlayButton(speed: speed * 4, start: false)
            timerIndex = 0
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            bpmTextField.isEnabled = true
        }
    }

    @IBAction func submitButtonPressed(_ sender: Any) {

    }
    @IBAction func publishButtonPressed(_ sender: Any) {
        
    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
    }
    
    deinit {
        stopTimer()
    }
    
}

extension RecordPageViewController: SelectionViewDelegate {
    func didScroll(offset: CGPoint) {
        hiHatSelectionView.collectionView.contentOffset = offset
        snareSelectionView.collectionView.contentOffset = offset
        tom1SelectionView.collectionView.contentOffset = offset
        tom2SelectionView.collectionView.contentOffset = offset
        floorTomSelectionView.collectionView.contentOffset = offset
        bassSelectionView.collectionView.contentOffset = offset
        crashSelectionView.collectionView.contentOffset = offset
        rideSelectionView.collectionView.contentOffset = offset
        
    }
    
    func didSelected(selectionView: SelectionView, indexPath: IndexPath) {
        let currentIndex = 16 * (numberOfSection-1) + indexPath.section*4 + indexPath.item
        switch selectionView {
        case hiHatSelectionView:
            if DrumKit.hiHat[currentIndex] == "0" {
                DrumKit.hiHat[currentIndex] = "1"
            } else {
                DrumKit.hiHat[currentIndex] = "0"
            }
        case snareSelectionView:
            if DrumKit.snare[currentIndex] == "0" {
                DrumKit.snare[currentIndex] = "1"
            } else {
                DrumKit.snare[currentIndex] = "0"
            }
        case tom1SelectionView:
            if DrumKit.tom1[currentIndex] == "0" {
                DrumKit.tom1[currentIndex] = "1"
            } else {
                DrumKit.tom1[currentIndex] = "0"
            }
        case tom2SelectionView:
            if DrumKit.tom2[currentIndex] == "0" {
                DrumKit.tom2[currentIndex] = "1"
            } else {
                DrumKit.tom2[currentIndex] = "0"
            }
        case floorTomSelectionView:
            if DrumKit.tomF[currentIndex] == "0" {
                DrumKit.tomF[currentIndex] = "1"
            } else {
                DrumKit.tomF[currentIndex] = "0"
            }
        case bassSelectionView:
            if DrumKit.bass[currentIndex] == "0" {
                DrumKit.bass[currentIndex] = "1"
            } else {
                DrumKit.bass[currentIndex] = "0"
            }
        case crashSelectionView:
            if DrumKit.crash[currentIndex] == "0" {
                DrumKit.crash[currentIndex] = "1"
            } else {
                DrumKit.crash[currentIndex] = "0"
            }
        case rideSelectionView:
            if DrumKit.ride[currentIndex] == "0" {
                DrumKit.ride[currentIndex] = "1"
            } else {
                DrumKit.ride[currentIndex] = "0"
            }
        default:
            break
        }
        delegate?.didChangeSelectedStatus(index: currentIndex)
    }
}

extension RecordPageViewController: SelectionViewDatasource {
    
    func setImage(selectionView: SelectionView) -> UIImage {
        switch selectionView {
        case hiHatSelectionView:
            return UIImage(named: "hihat")!
        case snareSelectionView:
            return UIImage(named: "snare")!
        case tom1SelectionView:
            return UIImage(named: "tom1")!
        case tom2SelectionView:
            return UIImage(named: "tom2")!
        case floorTomSelectionView:
            return UIImage(named: "tomFl")!
        case bassSelectionView:
            return UIImage(named: "bass")!
        case crashSelectionView:
            return UIImage(named: "crash")!
        case rideSelectionView:
            return UIImage(named: "ride")!
        default:
            return UIImage(systemName: "pencil.circle.fill")!
        }
    }
    
    func selectStatus(selectionView: SelectionView) -> [String] {
        let startIndex = 16*(numberOfSection-1)
        switch selectionView {
        case hiHatSelectionView:
            var hiHat: [String] = []
            for index in startIndex..<startIndex+16 {
                hiHat.append(DrumKit.hiHat[index])
            }
            return hiHat
        case snareSelectionView:
            var snare: [String] = []
            for index in startIndex..<startIndex+16 {
                snare.append(DrumKit.snare[index])
            }
            return snare
        case tom1SelectionView:
            var tom1: [String] = []
            for index in startIndex..<startIndex+16 {
                tom1.append(DrumKit.tom1[index])
            }
            return tom1
        case tom2SelectionView:
            var tom2: [String] = []
            for index in startIndex..<startIndex+16 {
                tom2.append(DrumKit.tom2[index])
            }
            return tom2
        case floorTomSelectionView:
            var tomF: [String] = []
            for index in startIndex..<startIndex+16 {
                tomF.append(DrumKit.tomF[index])
            }
            return tomF
        case bassSelectionView:
            var bass: [String] = []
            for index in startIndex..<startIndex+16 {
                bass.append(DrumKit.bass[index])
            }
            return bass
        case crashSelectionView:
            var crash: [String] = []
            for index in startIndex..<startIndex+16 {
                crash.append(DrumKit.crash[index])
            }
            return crash
        case rideSelectionView:
            var ride: [String] = []
            for index in startIndex..<startIndex+16 {
                ride.append(DrumKit.ride[index])
            }
            return ride
        default:
            return ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
        }
    }
    
}

extension RecordPageViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bpmTextField.text = pickerData[row]
        guard let bpmStr = bpmTextField.text,
              let bpm = Int(bpmStr) else { return }
        self.bpm = bpm
        delegate?.didChangedBPM(bpm: bpm)
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerData[row]
    }
}
