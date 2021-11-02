//
//  ProfilePageViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/18.
//

import UIKit
import Lottie

class ProfilePageViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    var firstPrizeView = RankingView(
        frame: CGRect.zero,
        prize: 1,
        userName: "1st Name",
        userPhoto: UIImage(systemName: "tropicalstorm")!,
        likes: 500
    )
    var secondPrizeView = RankingView(
        frame: CGRect.zero,
        prize: 2,
        userName: "2nd Name",
        userPhoto: UIImage(systemName: "tropicalstorm")!,
        likes: 250
    )
    var thirdPrizeView = RankingView(
        frame: CGRect.zero,
        prize: 3,
        userName: "3rd Name",
        userPhoto: UIImage(systemName: "tropicalstorm")!,
        likes: 100
    )
    var creationInfoView = PersonalInfoView(
        frame: CGRect.zero,
        itemName: "Creations",
        value: 35
    )
    var likesInfoView = PersonalInfoView(
        frame: CGRect.zero,
        itemName: "Likes",
        value: 4770
    )
    var rankInfoView = PersonalInfoView(
        frame: CGRect.zero,
        itemName: "Rank",
        value: 17
    )
    var followerInfoView = PersonalInfoView(
        frame: CGRect.zero,
        itemName: "Followers",
        value: 481
    )
    var containerView = UIView(frame: CGRect.zero)

    func setupPersonalInfoView() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: thirdPrizeView.bottomAnchor, constant: 10).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110).isActive = true

        containerView.addSubview(creationInfoView)
        creationInfoView.translatesAutoresizingMaskIntoConstraints = false
        creationInfoView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        creationInfoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        creationInfoView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
        creationInfoView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5).isActive = true

        containerView.addSubview(rankInfoView)
        rankInfoView.translatesAutoresizingMaskIntoConstraints = false
        rankInfoView.topAnchor.constraint(equalTo: creationInfoView.bottomAnchor).isActive = true
        rankInfoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        rankInfoView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
        rankInfoView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5).isActive = true

        containerView.addSubview(likesInfoView)
        likesInfoView.translatesAutoresizingMaskIntoConstraints = false
        likesInfoView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        likesInfoView.leadingAnchor.constraint(equalTo: creationInfoView.trailingAnchor).isActive = true
        likesInfoView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
        likesInfoView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5).isActive = true

        containerView.addSubview(followerInfoView)
        followerInfoView.translatesAutoresizingMaskIntoConstraints = false
        followerInfoView.topAnchor.constraint(equalTo: likesInfoView.bottomAnchor).isActive = true
        followerInfoView.leadingAnchor.constraint(equalTo: rankInfoView.trailingAnchor).isActive = true
        followerInfoView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
        followerInfoView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5).isActive = true

    }
    
    func setupRankingView(
        first: UIView,
        second: UIView,
        third: UIView
    ) {
        view.addSubview(first)
        first.translatesAutoresizingMaskIntoConstraints = false
        first.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        first.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        first.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        first.heightAnchor.constraint(equalToConstant: 40).isActive = true

        view.addSubview(second)
        second.translatesAutoresizingMaskIntoConstraints = false
        second.topAnchor.constraint(equalTo: first.bottomAnchor, constant: 10).isActive = true
        second.leadingAnchor.constraint(equalTo: first.leadingAnchor).isActive = true
        second.trailingAnchor.constraint(equalTo: first.trailingAnchor).isActive = true
        second.heightAnchor.constraint(equalToConstant: 40).isActive = true

        view.addSubview(third)
        third.translatesAutoresizingMaskIntoConstraints = false
        third.topAnchor.constraint(equalTo: second.bottomAnchor, constant: 10).isActive = true
        third.leadingAnchor.constraint(equalTo: first.leadingAnchor).isActive = true
        third.trailingAnchor.constraint(equalTo: first.trailingAnchor).isActive = true
        third.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }
    override func viewDidLayoutSubviews() {
        setupRankingView(
            first: firstPrizeView,
            second: secondPrizeView,
            third: thirdPrizeView
        )
        setupPersonalInfoView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        let animationView = AnimationView(name: "loadingAnimation")
//        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
//        animationView.center = self.view.center
//        animationView.contentMode = .scaleAspectFill
//        view.addSubview(animationView)
//        animationView.loopMode = .loop
//        animationView.backgroundBehavior = .pauseAndRestore
//        animationView.play()

        firstPrizeView.userName = "Ivan"
        firstPrizeView.likes = 6893
        firstPrizeView.userPhoto = UIImage(systemName: "book.fill")!

        secondPrizeView.userName = "Willy"
        secondPrizeView.likes = 5504
        secondPrizeView.userPhoto = UIImage(systemName: "book.fill")!

        thirdPrizeView.userName = "Dean"
        thirdPrizeView.likes = 4989
        thirdPrizeView.userPhoto = UIImage(systemName: "book.fill")!

        containerView.backgroundColor = .black
    }
    
    @IBAction func imageViewTap(_ sender: Any) {
        print("YOOO")
        firstPrizeView.userName = "Ivan"
    }
    
}
