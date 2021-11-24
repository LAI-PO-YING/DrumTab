//
//  HomePageViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/18.
//

import UIKit
import ESPullToRefresh
import Lottie

class HomePageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let firebase = FirebaseFirestoreManager.shared
    var currentSelectedRow: Int?
    let loadingAnimationView = AnimationView(name: "loadingAnimation")
    let lottie = LoadingAnimationManager.shared
    let dispatchGroup = DispatchGroup()
    
    var posts: [PostLocalUse] = [] {
        didSet {
//            let result = posts.sorted { $0.postTime > $1.postTime }
//            posts = result
//            tableView.reloadData()
        }
    }
    
    var postsRefactor = [String: Post]() {
        didSet {
            
        }
    }
    
    func checkCache(user: User, post: Post, creation: Creation) {
        if UserPhotoCache.userPhotoCache["\(user.userPhoto)"] == nil {
            let urlStr = user.userPhoto
            var image = UIImage(systemName: "person.circle.fill")
            if let url = URL(string: urlStr) {
                dispatchGroup.enter()
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

                    DispatchQueue.main.async {
                        if let data = data {
                            if let downloadedImage = UIImage(data: data) {
                                
                                image = downloadedImage
                                UserPhotoCache.userPhotoCache["\(user.userPhoto)"] = image
                            }
                        }
                        let userLocalUse = UserLocalUse(
                            userId: user.userId,
                            userName: user.userName,
                            userEmail: user.userEmail,
                            userPhoto: image ?? UIImage(systemName: "person.circle.fill")!,
                            userCollection: user.userCollection,
                            userFollow: user.userFollow,
                            followBy: user.followBy,
                            likesCount: user.likesCount,
                            userPhotoId: user.userPhotoId,
                            createdTime: user.createdTime,
                            aboutMe: user.aboutMe,
                            blockList: user.blockList,
                            blockBy: user.blockBy
                        )
                        let post = PostLocalUse(
                            creationId: post.creationId,
                            postTime: post.postTime,
                            postId: post.postId,
                            user: userLocalUse,
                            content: post.content,
                            like: post.like,
                            creation: creation
                        )
                        if LocalUserData.user!.blockList.contains(post.user.userId) || post.user.blockList.contains(LocalUserData.user!.userId) {
                            
                        } else {
                            self.posts.append(post)
                        }
                        self.dispatchGroup.leave()
                    }
                }).resume()
            } else {
                let userLocalUse = UserLocalUse(
                    userId: user.userId,
                    userName: user.userName,
                    userEmail: user.userEmail,
                    userPhoto: UIImage(systemName: "person.circle.fill")!,
                    userCollection: user.userCollection,
                    userFollow: user.userFollow,
                    followBy: user.followBy,
                    likesCount: user.likesCount,
                    userPhotoId: user.userPhotoId,
                    createdTime: user.createdTime,
                    aboutMe: user.aboutMe,
                    blockList: user.blockList,
                    blockBy: user.blockBy
                )
                let post = PostLocalUse(
                    creationId: post.creationId,
                    postTime: post.postTime,
                    postId: post.postId,
                    user: userLocalUse,
                    content: post.content,
                    like: post.like,
                    creation: creation
                )
                if LocalUserData.user!.blockList.contains(post.user.userId) || post.user.blockList.contains(LocalUserData.user!.userId) {
                    
                } else {
                    self.posts.append(post)
                }
            }
            
        } else {
            let userLocalUse = UserLocalUse(
                userId: user.userId,
                userName: user.userName,
                userEmail: user.userEmail,
                userPhoto: UserPhotoCache.userPhotoCache["\(user.userPhoto)"]!,
                userCollection: user.userCollection,
                userFollow: user.userFollow,
                followBy: user.followBy,
                likesCount: user.likesCount,
                userPhotoId: user.userPhotoId,
                createdTime: user.createdTime,
                aboutMe: user.aboutMe,
                blockList: user.blockList,
                blockBy: user.blockBy
            )
            let post = PostLocalUse(
                creationId: post.creationId,
                postTime: post.postTime,
                postId: post.postId,
                user: userLocalUse,
                content: post.content,
                like: post.like,
                creation: creation
            )
            if LocalUserData.user!.blockList.contains(post.user.userId) || post.user.blockList.contains(LocalUserData.user!.userId) {
                
            } else {
                self.posts.append(post)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        lottie.startLoading(target: self, animationView: loadingAnimationView)
        dispatchGroup.enter()
        firebase.fetchSpecificUser(userId: LocalUserData.userId) { result in
            switch result {
            case .success(let localUser):
                LocalUserData.user = localUser
                self.tableView.es.addPullToRefresh {
                    self.dispatchGroup.enter()
                    self.firebase.fetchPosts { result in
                        switch result {
                        case .success(let posts):
                            self.posts = []
                            posts.forEach { post in
                                self.dispatchGroup.enter()
                                self.firebase.fetchSpecificUser(userId: post.userId) { result in
                                    switch result {
                                    case .success(let user):
                                        self.dispatchGroup.enter()
                                        self.firebase.fetchSpecificCreation(creationId: post.creationId) { result in
                                            switch result {
                                            case .success(let creation):
                                                self.checkCache(user: user, post: post, creation: creation)
                                            case .failure(let error):
                                                print(error)
                                            }
                                            self.dispatchGroup.leave()
                                        }
                                    case .failure(let error):
                                        print(error)
                                    }
                                    self.dispatchGroup.leave()
                                }
                            }
                        case .failure(let error):
                            print(error)
                        }
                        self.dispatchGroup.leave()
                    }
                    self.dispatchGroup.notify(queue: .main) {
                        let result = self.posts.sorted { $0.postTime > $1.postTime }
                        self.posts = result
                        self.tableView.reloadData()
                        self.tableView.es.stopPullToRefresh()
                    }
                }
                
                self.firebase.fetchPosts { result in
                    switch result {
                    case .success(let posts):
                        posts.forEach { self.postsRefactor[$0.postId] = $0 }
                    case .failure(let error):
                        print(error)
                    }
                }
                
//                self.dispatchGroup.enter()
//                self.firebase.fetchPosts { result in
//                    switch result {
//                    case .success(let posts):
//                        posts.forEach { post in
//                            self.dispatchGroup.enter()
//                            self.firebase.fetchSpecificUser(userId: post.userId) { result in
//                                switch result {
//                                case .success(let user):
//                                    self.dispatchGroup.enter()
//                                    self.firebase.fetchSpecificCreation(creationId: post.creationId) { result in
//                                        switch result {
//                                        case .success(let creation):
//                                            self.checkCache(user: user, post: post, creation: creation)
//                                        case .failure(let error):
//                                            print(error)
//                                        }
//                                        self.dispatchGroup.leave()
//                                    }
//                                case .failure(let error):
//                                    print(error)
//                                }
//                                self.dispatchGroup.leave()
//                            }
//                        }
//                    case .failure(let error):
//                        print(error)
//                    }
//                    self.dispatchGroup.leave()
//                }
            case .failure(let error):
                print(error)
            }
            self.dispatchGroup.leave()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        dispatchGroup.notify(queue: .main) {
            let result = self.posts.sorted { $0.postTime > $1.postTime }
            self.posts = result
            self.tableView.reloadData()
            self.loadingAnimationView.removeFromSuperview()
        }
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
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        cell.setupCell(
            userName: posts[indexPath.row].user.userName,
            creationName: posts[indexPath.row].creation.name,
            image: posts[indexPath.row].user.userPhoto,
            time: posts[indexPath.row].postTime,
            content: posts[indexPath.row].content,
            like: posts[indexPath.row].like.count
        )
        cell.likeButtonPressedClosure = { [unowned self] in
            if posts[indexPath.row].like.contains(LocalUserData.userId) {
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                let updateLikes = posts[indexPath.row].like.filter {$0 != LocalUserData.userId}
                posts[indexPath.row].like = updateLikes
                tableView.reloadRows(at: [indexPath], with: .none)
                firebase.removeLike(postId: posts[indexPath.row].postId, userId: LocalUserData.userId)
            } else {
                posts[indexPath.row].like.append(LocalUserData.userId)
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                tableView.reloadRows(at: [indexPath], with: .none)
                firebase.addLike(postId: posts[indexPath.row].postId, userId: LocalUserData.userId)
            }
        }
        if posts[indexPath.row].user.userId == LocalUserData.userId {
            cell.moreButton.isHidden = true
        } else {
            cell.moreButton.isHidden = false
            cell.moreButtonPressedClosure = { [unowned self] in
                let alert = UIAlertController(
                    title: "檢舉並封鎖 \(posts[indexPath.row].user.userName)的貼文。封鎖後您將看不到關於\(posts[indexPath.row].user.userName)的任何貼文及留言。",
                    message: nil,
                    preferredStyle: .actionSheet
                )
                let blockAction = UIAlertAction(title: "封鎖", style: .destructive) { _ in
                    self.firebase.blockUser(userId: posts[indexPath.row].user.userId)
                    LocalUserData.user?.blockList.append(posts[indexPath.row].user.userId)
                    let updatePosts = posts.filter {
                        $0.user.userId != posts[indexPath.row].user.userId
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
        
        if posts[indexPath.row].user.userId != LocalUserData.userId {
            cell.photoPressedClosure = { [unowned self] in

                let memberPageVC = UIStoryboard.profile.instantiateViewController(withIdentifier:
                    String(describing: OtherMemberViewController.self)
                )

                guard let memberPageVC = memberPageVC as? OtherMemberViewController else { return }

                memberPageVC.userId = posts[indexPath.row].user.userId

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
            $0.user.userId != blockId
        }
        posts = updatePosts
        tableView.reloadData()
    }
}
