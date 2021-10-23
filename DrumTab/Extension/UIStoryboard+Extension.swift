//
//  File.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/18.
//

import UIKit

private struct StoryboardCategory {

    static let main = "Main"

    static let home = "Home"

    static let creation = "Creation"

    static let collection = "Collection"

    static let profile = "Profile"

}

extension UIStoryboard {

    static var main: UIStoryboard { return dtStoryboard(name: StoryboardCategory.main) }

    static var home: UIStoryboard { return dtStoryboard(name: StoryboardCategory.home) }

    static var creation: UIStoryboard { return dtStoryboard(name: StoryboardCategory.creation) }

    static var collection: UIStoryboard { return dtStoryboard(name: StoryboardCategory.collection) }

    static var profile: UIStoryboard { return dtStoryboard(name: StoryboardCategory.profile) }

    private static func dtStoryboard(name: String) -> UIStoryboard {

        return UIStoryboard(name: name, bundle: nil)
    }
}
