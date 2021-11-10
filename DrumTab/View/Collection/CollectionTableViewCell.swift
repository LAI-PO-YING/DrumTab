//
//  CollectionTableViewCell.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/30.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var creationNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    func setupCell(creationName: String, userImage: UIImage,  userName: String) {
        backgroundCardView.layer.cornerRadius = 5
        creationNameLabel.text = creationName
        userImageView.image = userImage
        userImageView.layer.cornerRadius = 9.25
        userNameLabel.text = userName
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
