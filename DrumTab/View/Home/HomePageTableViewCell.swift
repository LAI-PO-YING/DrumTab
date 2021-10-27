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
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var likeButtonPressedClosure: (()->Void) = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(
        name: String,
        time: TimeInterval,
        content: String,
        like: Int
    ) {
        // transform time
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        // setup cell
        nameLabel.text = name
        contentLabel.text = content
        timeLabel.text = dateFormatter.string(from: date)
        likeLabel.text = "\(like)"
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func likeButtonPressed(_ sender: UIButton) {
        likeButtonPressedClosure()
        sender.isSelected.toggle()
    }

}
