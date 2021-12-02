//
//  HomePageTableViewCell.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/25.
//

import UIKit
import Kingfisher

class HomePageTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var creationNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var moreButton: UIButton!
    var likeButtonPressedClosure: (()->Void) = {}
    var photoPressedClosure: (()->Void) = {}
    var moreButtonPressedClosure: (()->Void) = {}
    let customSelectedBackgroundView = UIView()
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundCardView.layer.cornerRadius = 5
        moreButton.transform = moreButton.transform.rotated(by: .pi / 2)
        customSelectedBackgroundView.backgroundColor = UIColor(named: "D2")
        selectedBackgroundView = customSelectedBackgroundView
    }
    func setupCell(
        userName: String,
        creationName: String,
        image: String,
        time: TimeInterval,
        content: String,
        like: Int
    ) {
        // transform time
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        // setup cell
        let url = URL(string: image)
        userPhotoImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.circle.fill"))
        userPhotoImageView.layer.cornerRadius = 15
        nameLabel.text = userName
        creationNameLabel.text = "\(creationName)"
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
    @IBAction func photoPressed(_ sender: Any) {
        photoPressedClosure()
    }
    @IBAction func moreButtonPressed(_ sender: Any) {
        moreButtonPressedClosure()
    }
    
}
