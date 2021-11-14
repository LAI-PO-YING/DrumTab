//
//  PersonalInfoCollectionViewCell.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/11/11.
//

import UIKit

class PersonalInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    func setupCell() {
        backgroundCardView.layer.borderWidth = 1
        backgroundCardView.layer.borderColor = UIColor(named: "D3")?.cgColor
        backgroundCardView.layer.cornerRadius = 3
    }
}
