//
//  RankingView.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/11/2.
//

import UIKit

class RankingView: UIView {

    let nibName = "RankingView"

    @IBOutlet weak var prizeBackGroundView: UIView!
    @IBOutlet weak var prizeLabel: UILabel!
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!

    var prize: Int
    var userName: String {
        didSet {
            userNameLabel.text = userName
        }
    }
    var userPhoto: UIImage{
        didSet {
            userPhotoImageView.image = userPhoto
        }
    }
    var likes: Int{
        didSet {
            likesLabel.text = "\(likes) Likes"
        }
    }

    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        switch prize {
        case 1:
            prizeBackGroundView.backgroundColor = UIColor(red: 246/255, green: 179/255, blue: 64/255, alpha: 1)
            prizeLabel.text = "1"
        case 2:
            prizeBackGroundView.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 216/255, alpha: 1)
            prizeLabel.text = "2"
        case 3:
            prizeBackGroundView.backgroundColor = UIColor(red: 194/255, green: 115/255, blue: 84/255, alpha: 1)
            prizeLabel.text = "3"
        default:
            break
        }
        prizeBackGroundView.layer.cornerRadius = 10
        userPhotoImageView.image = userPhoto
        userPhotoImageView.layer.cornerRadius = 20
        userNameLabel.text = userName
        likesLabel.text = "\(likes) Likes"
        self.addSubview(view)
    }

    init(
        frame: CGRect,
        prize: Int,
        userName: String,
        userPhoto: UIImage,
        likes: Int
    ) {
        self.prize = prize
        self.userName = userName
        self.userPhoto = userPhoto
        self.likes = likes
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
