//
//  CommentTableViewCell.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/29.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var backgroundCardView: UIView!
    func setupCommentCell(
        image: UIImage,
        name: String,
        time: String,
        comment: String,
        floor: Int
    ) {
        userImageView.image = image
        userNameLabel.text = name
        timeLabel.text = time
        commentLabel.text = comment
        floorLabel.text = "\(floor)F"
        backgroundCardView.layer.cornerRadius = 5
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
