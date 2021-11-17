//
//  PreviewPageViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/28.
//

import UIKit
import ESPullToRefresh

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
    private struct CreationComment {
        var userId: String
        var userBlockList: [String]
        var userName: String
        var userPhoto: UIImage
        var time: String
        var comment: String
    }
    let firebase = FirebaseFirestoreManager.shared

    let drumKit = DrumKit()
    var playTimer: Timer?
    var autoScrollTimer: Timer?
    var timerIndex = 0
    var speed: Double = 0
    var userComment: String?
    var user: User?

    var creationId: String?
    var creation: Creation? {
        didSet {
            collectionView.reloadData()
        }
    }
    private var comments: [CreationComment] = [] {
        didSet {
            comments.sort {
                Int($0.time)! < Int($1.time)!
            }
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
    func addPullToRefreshToTableView() {
        tableView.es.addPullToRefresh {
            self.comments = []
            if let creationId = self.creationId {
                self.firebase.fetchSpecificCreation(creationId: creationId) { result in
                    switch result {
                    case .success(let creation):
                        self.creation = creation
                        for comment in creation.comment {
                            self.firebase.fetchSpecificUser(userId: comment["userId"]!) { result in
                                switch result {
                                case .success(let user):
                                    if UserPhotoCache.userPhotoCache["\(user.userPhoto)"] == nil {
                                        let urlStr = user.userPhoto
                                        if let url = URL(string: urlStr),
                                           let data = try? Data(contentsOf: url) {
                                            UserPhotoCache.userPhotoCache["\(user.userPhoto)"] = UIImage(data: data)
                                            let creationComment = CreationComment(
                                                userId: user.userId,
                                                userBlockList: user.blockList,
                                                userName: user.userName,
                                                userPhoto: UIImage(data: data) ?? UIImage(systemName: "person.circle.fill")!,
                                                time: comment["time"]!,
                                                comment: comment["comment"]!
                                            )
                                            if LocalUserData.user!.blockList.contains(creationComment.userId) || creationComment.userBlockList.contains(LocalUserData.userId) {
                                                
                                            } else {
                                                self.comments.append(creationComment)
                                            }
                                        }
                                    } else {
                                        let creationComment = CreationComment(
                                            userId: user.userId,
                                            userBlockList: user.blockList,
                                            userName: user.userName,
                                            userPhoto: UserPhotoCache.userPhotoCache["\(user.userPhoto)"]!,
                                            time: comment["time"]!,
                                            comment: comment["comment"]!
                                        )
                                        if LocalUserData.user!.blockList.contains(creationComment.userId) || creationComment.userBlockList.contains(LocalUserData.userId) {
                                            
                                        } else {
                                            self.comments.append(creationComment)
                                        }
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                                self.tableView.es.stopPullToRefresh()
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addInToCollectionButton.setTitle("", for: .normal)
        rewindButton.setTitle("", for: .normal)
        playButton.setTitle("", for: .normal)
        forwardButton.setTitle("", for: .normal)
        sendButton.setTitle("", for: .normal)
        firebase.fetchSpecificUser(userId: LocalUserData.userId) { result in
            switch result {
            case .success(let user):
                self.user = user
                if user.userCollection.contains("\(self.creationId!)") {
                    self.addInToCollectionButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                } else {
                    self.addInToCollectionButton.setImage(UIImage(systemName: "bookmark"), for: .normal)                }
            case .failure(let error):
                print(error)
            }
        }

        collectionView.delegate = self
        collectionView.dataSource = self
        if let creationId = creationId {
            firebase.fetchSpecificCreation(creationId: creationId) { result in
                switch result {
                case .success(let creation):
                    DrumKit.hiHat = creation.record["hiHat"]!
                    DrumKit.snare = creation.record["snare"]!
                    DrumKit.tom1 = creation.record["tom1"]!
                    DrumKit.tom2 = creation.record["tom2"]!
                    DrumKit.tomF = creation.record["tomF"]!
                    DrumKit.bass = creation.record["bass"]!
                    DrumKit.crash = creation.record["crash"]!
                    DrumKit.ride = creation.record["ride"]!
                    self.creationNameLabel.text = creation.name
                    self.creation = creation
                    for comment in creation.comment {
                        self.firebase.fetchSpecificUser(userId: comment["userId"]!) { result in
                            switch result {
                            case .success(let user):
                                if UserPhotoCache.userPhotoCache["\(user.userPhoto)"] == nil {
                                    let urlStr = user.userPhoto
                                    if let url = URL(string: urlStr),
                                       let data = try? Data(contentsOf: url) {
                                        UserPhotoCache.userPhotoCache["\(user.userPhoto)"] = UIImage(data: data)
                                        let creationComment = CreationComment(
                                            userId: user.userId,
                                            userBlockList: user.blockList,
                                            userName: user.userName,
                                            userPhoto: UIImage(data: data) ?? UIImage(systemName: "person.circle.fill")!,
                                            time: comment["time"]!,
                                            comment: comment["comment"]!
                                        )
                                        if LocalUserData.user!.blockList.contains(creationComment.userId) || creationComment.userBlockList.contains(LocalUserData.userId) {
                                            
                                        } else {
                                            self.comments.append(creationComment)
                                        }
                                    }
                                } else {
                                    let creationComment = CreationComment(
                                        userId: user.userId,
                                        userBlockList: user.blockList,
                                        userName: user.userName,
                                        userPhoto: UserPhotoCache.userPhotoCache["\(user.userPhoto)"]!,
                                        time: comment["time"]!,
                                        comment: comment["comment"]!
                                    )
                                    if LocalUserData.user!.blockList.contains(creationComment.userId) || creationComment.userBlockList.contains(LocalUserData.userId) {
                                        
                                    } else {
                                        self.comments.append(creationComment)
                                    }
                                }
                                
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        addPullToRefreshToTableView()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
//        navigationController?.setNavigationBarHidden(false, animated: true)
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
        firebase.uploadComment(
            creationId: creationId!,
            userId: LocalUserData.userId,
            comment: userComment
        )
        commentTextField.text = nil
        self.userComment = nil
    }
    @IBAction func addInCollectionButtonPressed(_ sender: UIButton) {
        if user!.userCollection.contains("\(creationId!)") {
            firebase.removeCollection(userId: user!.userId, creationId: creationId!)
            let updateCollections = user!.userCollection.filter {$0 != "\(creationId!)"}
            user!.userCollection = updateCollections
            sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
        } else {
            firebase.addCollection(userId: user!.userId, creationId: creationId!)
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            user!.userCollection.append("\(creationId!)")
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
        cell.setupCommentCell(
            image: comments[indexPath.row].userPhoto,
            name: comments[indexPath.row].userName,
            time: comments[indexPath.row].time,
            comment: comments[indexPath.row].comment,
            floor: indexPath.row + 1
        )
        if comments[indexPath.row].userId != LocalUserData.userId {
            cell.photoPressedClosure = { [unowned self] in
                
                let memberPageVC = UIStoryboard.profile.instantiateViewController(
                    withIdentifier: String(describing: OtherMemberViewController.self)
                )
                
                guard let memberPageVC = memberPageVC as? OtherMemberViewController else { return }
                
                memberPageVC.userId = comments[indexPath.row].userId
                
                show(memberPageVC, sender: nil)
            }
        }
        if comments[indexPath.row].userId == LocalUserData.userId {
            cell.moreButton.isHidden = true
        } else {
            cell.moreButton.isHidden = false
            cell.moreButtonPressedClosure = { [unowned self] in
                let alert = UIAlertController(title: "檢舉並封鎖 \(comments[indexPath.row].userName)的留言", message: nil, preferredStyle: .actionSheet)
                let blockAction = UIAlertAction(title: "Block", style: .destructive) { _ in
                    self.firebase.blockUser(userId: comments[indexPath.row].userId)
                    LocalUserData.user?.blockList.append(comments[indexPath.row].userId)
                    delegate?.didPressBlock(blockId: comments[indexPath.row].userId)
                    let updateComments = comments.filter {
                        $0.userId != comments[indexPath.row].userId
                    }
                    comments = updateComments
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .default)
                let actions: [UIAlertAction] = [
                    blockAction,
                    cancelAction
                ]
                for action in actions {
                    alert.addAction(action)
                }
                
                present(alert, animated: true, completion: nil)
            }
        }
        return cell
    }
}
