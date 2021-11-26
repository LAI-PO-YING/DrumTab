//
//  CommentTableViewCell.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/29.
//

import UIKit
import Kingfisher

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
        floor: Int,
        comment: CreationComment
    ) {
        // transform time
        let date = Date(timeIntervalSince1970: TimeInterval(comment.time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let url = URL(string: comment.user.userPhoto)
        userImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.circle.fill"))
        userImageView.layer.cornerRadius = 15
        userNameLabel.text = comment.user.userName
        timeLabel.text = dateFormatter.string(from: date)
        commentLabel.text = comment.comment
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
