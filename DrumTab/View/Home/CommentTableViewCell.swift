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
    @IBOutlet weak var moreButton: UIButton!
    var photoPressedClosure: (() -> Void) = {}
    var moreButtonPressedClosure: (() -> Void) = {}
func setupCommentCell(
        image: UIImage,
        name: String,
        time: String,
        comment: String,
        floor: Int
    ) {
        // transform time
        let date = Date(timeIntervalSince1970: TimeInterval(time)!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        userImageView.image = image
        userImageView.layer.cornerRadius = 15
        userNameLabel.text = name
        timeLabel.text = dateFormatter.string(from: date)
        commentLabel.text = comment
        floorLabel.text = "\(floor)F"
        backgroundCardView.layer.cornerRadius = 5
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        moreButton.transform = moreButton.transform.rotated(by: .pi / 2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func photoPressed(_ sender: Any) {
        photoPressedClosure()
    }
    @IBAction func moreButtonPressed(_ sender: Any) {
        moreButtonPressedClosure()
    }
    
}
