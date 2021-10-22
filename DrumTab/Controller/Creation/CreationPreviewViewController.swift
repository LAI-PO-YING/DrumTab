//
//  CreationPreviewViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/19.
//

import UIKit

class CreationPreviewViewController: UIViewController {

    var bpm: Int?
    var beatInASection: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? RecordPageViewController else {
            fatalError("Destination is not RecordPageViewController")
        }
        dvc.bpm = self.bpm!
        dvc.beatInASection = self.beatInASection!
    }
}
