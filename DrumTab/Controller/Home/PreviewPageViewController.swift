//
//  PreviewPageViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/28.
//

import UIKit

protocol PreviewPageViewControllerDelegate: AnyObject {
    func didPressBlock(blockId: String)
}

class PreviewPageViewController: UIViewController {
    @IBOutlet weak var creationNameLabel: UILabel!
    @IBOutlet weak var addInToCollectionButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addInCollectionButton: UIButton!
    weak var delegate: PreviewPageViewControllerDelegate?

    let firebase = FirebaseFirestoreManager.shared
    let commentProvider = CreationCommentProvider.shared

    let drumKit = DrumKit()
    var playTimer: Timer?
    var autoScrollTimer: Timer?
    var timerIndex = 0
    var speed: Double = 0
    var userComment: String?
    var user = LocalUserData.user

    var creationId: String?
    var creation: Creation? {
        didSet {
            collectionView.reloadData()
        }
    }
    private var comments: [CreationComment] = [] {
        didSet {
            tableView.reloadData()
        }
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
        autoScrollTimer = Timer.scheduledTimer(
            timeInterval: speed*4,
            target: self,
            selector: #selector(autoScroll),
            userInfo: nil,
            repeats: true
        )
        RunLoop.current.add(self.autoScrollTimer!, forMode: .common)
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
    func updateCollectionButton(creationId: String) {
        guard let user = LocalUserData.user else { return }
        if user.userCollection.contains("\(creationId)") {
            self.addInToCollectionButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            self.addInToCollectionButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let creationId = creationId,
              let creation = Cache.creationCache[creationId]
        else {
            return
        }

        self.creation = creation

        updateCollectionButton(creationId: creationId)

        DrumKit.updateDrumRecord(creation: creation)

        creationNameLabel.text = creation.name

        collectionView.delegate = self
        collectionView.dataSource = self

        commentProvider.fetchComment(creation: creation) { comments in
            self.comments = comments
        }
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    deinit {
        stopTimer()
    }
    @IBAction func backButtoPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        stopTimer()
    }
    @IBAction func playButtonPressed(_ sender: UIButton) {
        timerIndex += 1
        speed = 60.0 / Double(creation!.bpm) / Double(creation!.timeSignature[0])
        if timerIndex == 1 {
            startTimer()
            timerIndex += 1
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            stopTimer()
            timerIndex = 0
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
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
    @IBAction func textField(_ sender: UITextField) {
        userComment = sender.text
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        guard let userComment = userComment else {
            return
        }
        let commentData: [String: String] = [
            "userId": LocalUserData.userId,
            "comment": userComment,
            "time": "\(Int(Date().timeIntervalSince1970))"
        ]
        firebase.uploadComment(
            creationId: creationId!,
            userId: LocalUserData.userId,
            comment: userComment
        )
        commentTextField.text = nil
        comments.append(
            CreationComment(
                user: LocalUserData.user!,
                time: Int(Date().timeIntervalSince1970),
                comment: userComment
            )
        )
        Cache.creationCache[creationId!]?.comment.append(commentData)
        tableView.scrollToRow(at: [0, Cache.creationCache[creationId!]!.comment.count - 1], at: .bottom, animated: false)
        self.userComment = nil
    }
    @IBAction func addInCollectionButtonPressed(_ sender: UIButton) {
        if user!.userCollection.contains("\(creationId!)") {
            firebase.removeCollection(userId: user!.userId, creationId: creationId!)
            let updateCollections = user!.userCollection.filter {$0 != "\(creationId!)"}
            user!.userCollection = updateCollections
            LocalUserData.user?.userCollection = updateCollections
            sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
        } else {
            firebase.addCollection(userId: user!.userId, creationId: creationId!)
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            user!.userCollection.append("\(creationId!)")
            LocalUserData.user?.userCollection.append(creationId!)
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
        return CGSize(width: view.bounds.width / 4 - 0.01, height: 106)
    }

}

extension PreviewPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(CommentTableViewCell.self)",
            for: indexPath
        ) as? CommentTableViewCell else { return UITableViewCell() }
        cell.setupCommentCell(floor: indexPath.row + 1, comment: comments[indexPath.row])
        if comments[indexPath.row].user.userId != LocalUserData.userId {
            cell.photoPressedClosure = { [unowned self] in
                
                let memberPageVC = UIStoryboard.profile.instantiateViewController(
                    withIdentifier: String(describing: OtherMemberViewController.self)
                )
                
                guard let memberPageVC = memberPageVC as? OtherMemberViewController else { return }
                
                memberPageVC.userId = comments[indexPath.row].user.userId
                
                show(memberPageVC, sender: nil)
            }
        }
        if comments[indexPath.row].user.userId == LocalUserData.userId {
            cell.moreButton.isHidden = true
        } else {
            cell.moreButton.isHidden = false
            cell.moreButtonPressedClosure = { [unowned self] in
                let alert = UIAlertController(
                    title: "檢舉並封鎖 \(comments[indexPath.row].user.userName)的留言。封鎖後您將看不到關於\(comments[indexPath.row].user.userName)的任何貼文及留言。",
                    message: nil,
                    preferredStyle: .actionSheet
                )
                let blockAction = UIAlertAction(title: "封鎖", style: .destructive) { _ in
                    self.firebase.blockUser(userId: comments[indexPath.row].user.userId)
                    LocalUserData.user?.blockList.append(comments[indexPath.row].user.userId)
                    delegate?.didPressBlock(blockId: comments[indexPath.row].user.userId)
                    let updateComments = comments.filter {
                        $0.user.userId != comments[indexPath.row].user.userId
                    }
                    comments = updateComments
                }
                let cancelAction = UIAlertAction(title: "取消", style: .default)
                let actions: [UIAlertAction] = [
                    blockAction,
                    cancelAction
                ]
                for action in actions {
                    alert.addAction(action)
                }
                if let popoverController = alert.popoverPresentationController {
                    
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                    
                }
                present(alert, animated: true, completion: nil)
            }
        }
        return cell
    }
}
