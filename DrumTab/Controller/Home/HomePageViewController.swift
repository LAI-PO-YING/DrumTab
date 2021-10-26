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
    var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var posts: [Post] = [] {
        didSet {
            posts.forEach { post in
                firebase.fetchSpecificUser(userId: post.userId) { result in
                    switch result {
                    case .success(let user):
                        self.users.append(user)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebase.fetchPosts { result in
            switch result {
            case .success(let posts):
                self.posts = posts
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
        cell.setupCell(
            name: users[indexPath.row].userName,
            time: posts[indexPath.row].postTime,
            content: posts[indexPath.row].content,
            like: posts[indexPath.row].like
        )
        return cell
    }

}
