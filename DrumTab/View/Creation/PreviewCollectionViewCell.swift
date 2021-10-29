//
//  PreviewCollectionViewCell.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/23.
//

import UIKit

class PreviewCollectionViewCell: UICollectionViewCell {
    func addSectionView(
        hiHat: [String],
        snare: [String],
        tom1: [String],
        tom2: [String],
        tomF: [String],
        bass: [String],
        crash: [String],
        ride: [String]
    ) {
        let view = SectionView(
            frame: CGRect.zero,
            hiHat: hiHat,
            snare: snare,
            tom1: tom1,
            tom2: tom2,
            tomF: tomF,
            bass: bass,
            crash: crash,
            ride: ride
        )
        self.stickSubView(view)
    }
}
