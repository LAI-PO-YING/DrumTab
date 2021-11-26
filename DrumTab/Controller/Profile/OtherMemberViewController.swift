//
//  OtherMemberViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/11/12.
//

import UIKit
import Kingfisher

class OtherMemberViewController: UIViewController {
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var userPhotoImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAboutMeLabel: UILabel!
    @IBOutlet weak var creationValueLabel: UILabel!
    @IBOutlet weak var likeValueLabel: UILabel!
    @IBOutlet weak var followerValueLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var creationView: UIView!
    @IBOutlet weak var followerView: UIView!
    @IBOutlet weak var likeView: UIView!
    
    var posts = [Post]() {
        didSet {
            tableView.reloadData()
        }
    }

    var userId: String?
    var user: User?
    let firebase = FirebaseFirestoreManager.shared
    let postProvider = PostProvider.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let userId = userId,
              let user = Cache.userCache[userId]
        else {
            return
        }

        userPhotoImage.layer.cornerRadius = 50
        userNameLabel.text = user.userName
        userAboutMeLabel.text = user.aboutMe
        let url = URL(string: user.userPhoto)
        userPhotoImage.kf.setImage(with: url, placeholder: UIImage(systemName: "person.circle.fill"))
        if user.followBy.contains(LocalUserData.userId) {
            self.followButton.setTitle("Following", for: .normal)
        } else {
            self.followButton.setTitle("Follow", for: .normal)
        }

        firebase.getPersonalCreation(userId: userId) { result in
            switch result {
            case .success(let creations):
                print("creation: \(creations.count)")
                self.creationValueLabel.text = "\(creations.count)"
            case .failure(let error):
                print(error)
            }
        }

        firebase.getPersonalLikeValue(userId: userId) { numberOfLikes in
            print("numberOfLikes: \(numberOfLikes)")
            self.likeValueLabel.text = "\(numberOfLikes)"
        }

        firebase.getFollowers(userId: userId) { numberOfFollowers in
            print("numberOfFollowers: \(numberOfFollowers)")
            self.followerValueLabel.text = "\(numberOfFollowers)"
        }
        postProvider.fetchSpecificUserPost(userId: userId) { posts in
            self.posts = posts
        }
            
        tableView.delegate = self
        tableView.dataSource = self
        creationView.layer.borderColor = UIColor(named: "D2")?.cgColor
        creationView.layer.borderWidth = 1
        followerView.layer.borderColor = UIColor(named: "D2")?.cgColor
        followerView.layer.borderWidth = 1
        likeView.layer.borderColor = UIColor(named: "D2")?.cgColor
        likeView.layer.borderWidth = 1
        followButton.layer.cornerRadius = 5
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func followButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: userNameLabel.text, message: nil, preferredStyle: .actionSheet)
        if followButton.title(for: .normal) == "Follow" {
            let followAction = UIAlertAction(title: "Follow \(userNameLabel.text!)", style: .default) { _ in
                self.firebase.addFollower(userId: self.userId!)
                self.followButton.setTitle("Following", for: .normal)
                self.followerValueLabel.text = "\(Int(self.followerValueLabel.text!)! + 1)"
            }
            let blockAction = UIAlertAction(title: "Block \(userNameLabel.text!)", style: .destructive) { _ in
                self.firebase.blockUser(userId: self.userId!)
                self.followButton.setTitle("Block", for: .normal)
                LocalUserData.user?.blockList.append(self.userId!)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            let actions: [UIAlertAction] = [
                followAction,
                blockAction,
                cancelAction
            ]
            for action in actions {
                alert.addAction(action)
            }
            
            present(alert, animated: true, completion: nil)
        } else if followButton.title(for: .normal) == "Following"{
            let unfollowAction = UIAlertAction(title: "Unfollow \(userNameLabel.text!)", style: .default) { _ in
                self.firebase.removeFollower(userId: self.userId!)
                self.followButton.setTitle("Follow", for: .normal)
                self.followerValueLabel.text = "\(Int(self.followerValueLabel.text!)! - 1)"
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            let actions: [UIAlertAction] = [
                unfollowAction,
                cancelAction
            ]
            for action in actions {
                alert.addAction(action)
            }
            
            present(alert, animated: true, completion: nil)
        } else {
            let unblockAction = UIAlertAction(title: "Unblock \(userNameLabel.text!)", style: .default) { _ in
                self.firebase.unblockUser(userId: self.userId!)
                self.followButton.setTitle("Follow", for: .normal)
                let updateBlockList = LocalUserData.user?.blockList.filter({ $0 != self.userId! })
                LocalUserData.user?.blockList = updateBlockList!
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            let actions: [UIAlertAction] = [
                unblockAction,
                cancelAction
            ]
            for action in actions {
                alert.addAction(action)
            }
            
            present(alert, animated: true, completion: nil)
        }
    }
}

extension OtherMemberViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(PersonalPostTableViewCell.self)",
            for: indexPath) as? PersonalPostTableViewCell else { return UITableViewCell() }
        if posts[indexPath.row].like.contains(LocalUserData.userId) {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        cell.setupCell(post: posts[indexPath.row])
        cell.likeButtonPressedClosure = { [unowned self] in
            if posts[indexPath.row].like.contains(LocalUserData.userId) {
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                let updateLikes = posts[indexPath.row].like.filter {$0 != LocalUserData.userId}
                posts[indexPath.row].like = updateLikes
                firebase.removeLike(postId: posts[indexPath.row].postId, userId: LocalUserData.userId)
            } else {
                posts[indexPath.row].like.append(LocalUserData.userId)
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                firebase.addLike(postId: posts[indexPath.row].postId, userId: LocalUserData.userId)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let selectedCreationId = posts[indexPath.row].creationId

        let previewPageVC = UIStoryboard.home.instantiateViewController(withIdentifier:
            String(describing: PreviewPageViewController.self)
        )

        guard let previewPageVC = previewPageVC as? PreviewPageViewController else { return }

        previewPageVC.creationId = selectedCreationId

        show(previewPageVC, sender: nil)
    }
}
