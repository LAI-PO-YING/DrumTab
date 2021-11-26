//
//  CollectionTableViewCell.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/30.
//

import UIKit
import Kingfisher

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var creationNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    let customSelectedBackgroundView = UIView()
    func setupCell(collection: Creation) {
        backgroundCardView.layer.cornerRadius = 5
        creationNameLabel.text = collection.name
        guard let user = collection.user else { return }
        let url = URL(string: user.userPhoto)
        userImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.circle.fill"))
        userImageView.layer.cornerRadius = 9.25
        userNameLabel.text = user.userName
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        customSelectedBackgroundView.backgroundColor = UIColor(named: "D2")
        selectedBackgroundView = customSelectedBackgroundView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
