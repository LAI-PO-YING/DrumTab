//
//  PersonalInfoView.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/11/2.
//

import UIKit

class PersonalInfoView: UIView {

    let nibName = "PersonalInfoView"

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    var itemName: String {
        didSet {
            itemNameLabel.text = itemName
        }
    }
    var value: Int {
        didSet {
            valueLabel.text = "\(value)"
        }
    }

    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        containerView.layer.cornerRadius = 5
        containerView.layer.borderColor = UIColor(named: "D3")?.cgColor
        containerView.layer.borderWidth = 1
        itemNameLabel.text = itemName
        valueLabel.text = "\(value)"
        self.addSubview(view)
    }

    init(
        frame: CGRect,
        itemName: String,
        value: Int
    ) {
        self.itemName = itemName
        self.value = value
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
