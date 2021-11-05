//
//  HomePageTableViewCell.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/25.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var creationNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var backgroundCardView: UIView!

    var likeButtonPressedClosure: (()->Void) = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundCardView.layer.cornerRadius = 5
    }
    func setupCell(
        userName: String,
        creationName: String,
        time: TimeInterval,
        content: String,
        like: Int
    ) {
        // transform time
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        // setup cell
        nameLabel.text = userName
        creationNameLabel.text = "作品名稱：\(creationName)"
        contentLabel.text = content
        timeLabel.text = dateFormatter.string(from: date)
        likeLabel.text = "\(like)"
//        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func likeButtonPressed(_ sender: UIButton) {
        likeButtonPressedClosure()
    }

}
