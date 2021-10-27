//
//  ProfilePageViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/18.
//

import UIKit
import Lottie

class ProfilePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let animationView = AnimationView(name: "loadingAnimation")
        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        view.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play()
    }

}
