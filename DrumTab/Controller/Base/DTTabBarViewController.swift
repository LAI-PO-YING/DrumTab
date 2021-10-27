//
//  DTTabBarViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/18.
//

import UIKit

private enum Tab {

    case home

    case creation

    case collection

    case profile

    func controller() -> UIViewController {

        var controller: UIViewController

        switch self {

        case .home: controller = UIStoryboard.home.instantiateInitialViewController()!

        case .creation: controller = UIStoryboard.creation.instantiateInitialViewController()!

        case .collection: controller = UIStoryboard.collection.instantiateInitialViewController()!

        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!

        }

        controller.tabBarItem = tabBarItem()

        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)

        return controller
    }

    func tabBarItem() -> UITabBarItem {

        switch self {

        case .home:
            return UITabBarItem(
                title: nil,
                image: UIImage(systemName: "pencil.circle"), // remember to change icon
                selectedImage: UIImage(systemName: "pencil.circle.fill") // remember to change icon
            )

        case .creation:
            return UITabBarItem(
                title: nil,
                image: UIImage(systemName: "pencil.circle"), // remember to change icon
                selectedImage: UIImage(systemName: "pencil.circle.fill") // remember to change icon
            )

        case .collection:
            return UITabBarItem(
                title: nil,
                image: UIImage(systemName: "pencil.circle"), // remember to change icon
                selectedImage: UIImage(systemName: "pencil.circle.fill") // remember to change icon
            )

        case .profile:
            return UITabBarItem(
                title: nil,
                image: UIImage(systemName: "pencil.circle"), // remember to change icon
                selectedImage: UIImage(systemName: "pencil.circle.fill") // remember to change icon
            )

        }
    }
}

class DTTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    private let tabs: [Tab] = [.home, .creation, .collection, .profile]

    var trolleyTabBarItem: UITabBarItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })

        delegate = self

    }

    // MARK: - UITabBarControllerDelegate

    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {

        return true
    }

}
