//
//  CreationPageTableViewCell.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/20.
//

import UIKit

class CreationPageTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var timeSignatureLabel: UILabel!

    func setupCell(
        title: String,
        time: TimeInterval,
        bpm: Int,
        timeSignature: [Int]
    ) {
        // transform time
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        // setup cell
        titleLabel.text = title
        bpmLabel.text = "BPM: \(bpm)"
        timeSignatureLabel.text = "\(timeSignature[0])/\(timeSignature[1])拍"
        createdTimeLabel.text = dateFormatter.string(from: date)

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
