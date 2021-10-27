//
//  HomePageViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/18.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let firebase = FirebaseFirestoreManager.shared
    
    var posts: [PostLocalUse] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebase.fetchPosts { result in
            switch result {
            case .success(let posts):
                posts.forEach { post in
                    self.firebase.fetchSpecificUser(userId: post.userId) { result in
                        switch result {
                        case .success(let user):
                            let post = PostLocalUse(
                                creationId: post.creationId,
                                postTime: post.postTime,
                                postId: post.postId,
                                user: user,
                                content: post.content,
                                like: post.like
                            )
                            self.posts.append(post)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
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
        if posts[indexPath.row].like.contains("JSDKSDFewrdwSDF") {
            cell.likeButton.isSelected = true
        } else {
            cell.likeButton.isSelected = false
        }
        cell.setupCell(
            name: posts[indexPath.row].user.userName,
            time: posts[indexPath.row].postTime,
            content: posts[indexPath.row].content,
            like: posts[indexPath.row].like.count
        )
        cell.likeButtonPressedClosure = { [unowned self] in
            if posts[indexPath.row].like.contains("JSDKSDFewrdwSDF") {
                let updateLikes = posts[indexPath.row].like.filter {$0 != "JSDKSDFewrdwSDF"}
                posts[indexPath.row].like = updateLikes
                firebase.removeLike(postId: posts[indexPath.row].postId, userId: "JSDKSDFewrdwSDF")
            } else {
                posts[indexPath.row].like.append("JSDKSDFewrdwSDF")
                firebase.addLike(postId: posts[indexPath.row].postId, userId: "JSDKSDFewrdwSDF")
            }
        }
        return cell
    }

}
