//
//  PersonalPostTableViewCell.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/11/12.
//

import UIKit

class PersonalPostTableViewCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var creationNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var backgroundCardView: UIView!
    var likeButtonPressedClosure: (()->Void) = {}
    func setupCell(post: Post) {
        // transform time
        let date = Date(timeIntervalSince1970: post.postTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        // setup cell
        guard let creation = post.creation else { return }
        creationNameLabel.text = "\(creation.name)"
        contentLabel.text = post.content
        timeLabel.text = dateFormatter.string(from: date)
        likeLabel.text = "\(post.like.count)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundCardView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonPressed(_ sender: Any) {
        likeButtonPressedClosure()
    }
}
