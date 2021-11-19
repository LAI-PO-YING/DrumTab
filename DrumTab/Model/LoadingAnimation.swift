//
//  LoadingAnimation.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/11/18.
//

import Foundation
import UIKit
import Lottie

class LoadingAnimationManager {

    static let shared = LoadingAnimationManager()
    func startLoading(target: UIViewController, animationView: AnimationView) {
        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        animationView.center = target.view.center
        animationView.contentMode = .scaleAspectFill
        target.view.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play()
    }
    func endLoading(
        target: UIViewController,
        animationView: AnimationView,
        completion: @escaping (Bool) -> Void
    ) {
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.center = target.view.center
        animationView.contentMode = .scaleAspectFill
        target.view.addSubview(animationView)
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play { isFinish in
            completion(isFinish)
        }
    }

}
