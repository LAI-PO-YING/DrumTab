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
    func endLoading() {
        
    }

}
