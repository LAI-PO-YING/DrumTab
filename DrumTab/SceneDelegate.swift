//
//  SceneDelegate.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/18.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let _ = (scene as? UIWindowScene) else { return }

//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        if let user = Auth.auth().currentUser {
//
//            let mainTabBarController = storyboard.instantiateViewController(identifier: "DTTabBarViewController")
//
//            LocalUserData.userId = user.uid
//
//            window?.rootViewController = mainTabBarController
//
//        } else {
//
//            let loginNavController = storyboard.instantiateViewController(identifier: "AuthViewController")
//
//            window?.rootViewController = loginNavController
//        }

    }
    func changeRootViewController(_ viewController: UIViewController, animated: Bool = true) {

        guard let window = self.window else {
            return
        }

        window.rootViewController = viewController

        UIView.transition(
            with: window,
            duration: 0.5,
            options: [.transitionFlipFromLeft],
            animations: nil,
            completion: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }

}
