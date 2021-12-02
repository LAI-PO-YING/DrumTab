//
//  HomePageViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/18.
//

import UIKit
import ESPullToRefresh
import Lottie
import Kingfisher

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let firebase = FirebaseFirestoreManager.shared
    var currentSelectedRow: Int?
    let loadingAnimationView = AnimationView(name: "loadingAnimation")
    let lottie = LoadingAnimationManager.shared

    var provider = PostProvider.shared
    var posts = [Post]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 記得刪掉，SceneDelegate 會抓local user data
        firebase.fetchSpecificUser(userId: LocalUserData.userId) { user in
            LocalUserData.user = user
        }

        lottie.startLoading(target: self, animationView: loadingAnimationView)

        provider.fetchAllPost(completion: { posts in
            self.posts = posts
            self.loadingAnimationView.removeFromSuperview()
        })

        tableView.es.addPullToRefresh {
            self.provider.fetchAllPost(completion: { posts in
                self.posts = posts
                self.tableView.es.stopPullToRefresh()
            })
        }

        tableView.delegate = self
        tableView.dataSource = self

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? PreviewPageViewController else {
            fatalError("Destination is not PreviewPageViewController")
        }
        guard let currentSelectedRow = currentSelectedRow else {
            return
        }
        
        destinationVC.creationId = posts[currentSelectedRow].creationId
        destinationVC.delegate = self
        self.currentSelectedRow = nil
    }
}

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(HomePageTableViewCell.self)",
            for: indexPath) as? HomePageTableViewCell else { return UITableViewCell() }
        if posts[indexPath.row].like.contains(LocalUserData.userId) {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        guard let user = posts[indexPath.row].user,
              let creation = posts[indexPath.row].creation else { fatalError("Lost user and creation!")
              }
        cell.setupCell(
            userName: user.userName,
            creationName: creation.name,
            image: user.userPhoto,
            time: posts[indexPath.row].postTime,
            content: posts[indexPath.row].content,
            like: posts[indexPath.row].like.count
        )
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
        if user.userId == LocalUserData.userId {
            cell.moreButton.isHidden = true
        } else {
            cell.moreButton.isHidden = false
            cell.moreButtonPressedClosure = { [unowned self] in
                let alert = UIAlertController(
                    title: "檢舉並封鎖 \(user.userName)的貼文。封鎖後您將看不到關於\(user.userName)的任何貼文及留言。",
                    message: nil,
                    preferredStyle: .actionSheet
                )
                let blockAction = UIAlertAction(title: "封鎖", style: .destructive) { _ in
                    self.firebase.blockUser(userId: user.userId)
                    LocalUserData.user?.blockList.append(user.userId)
                    let updatePosts = posts.filter {
                        $0.user!.userId != posts[indexPath.row].user!.userId
                    }
                    posts = updatePosts
                    self.tableView.reloadData()
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
        
        if user.userId != LocalUserData.userId {
            cell.photoPressedClosure = { [unowned self] in
                
                let memberPageVC = UIStoryboard.profile.instantiateViewController(
                    withIdentifier: String(describing: OtherMemberViewController.self)
                )
                
                guard let memberPageVC = memberPageVC as? OtherMemberViewController else { return }
                
                memberPageVC.userId = user.userId
                
                show(memberPageVC, sender: nil)
            }
        } else {
            cell.photoPressedClosure = {
                self.tabBarController?.selectedIndex = 3
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        currentSelectedRow = indexPath.row
        performSegue(withIdentifier: "FromHomePage", sender: nil)
    }
    
}

extension HomePageViewController: PreviewPageViewControllerDelegate {
    func didPressBlock(blockId: String) {
        let updatePosts = posts.filter {
            $0.user!.userId != blockId
        }
        posts = updatePosts
        tableView.reloadData()
    }
}
