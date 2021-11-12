//
//  HeaderCollectionReusableView.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/11/9.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "HeaderCollectionReusableView"
    lazy var lineView: UIView = {

        let view = UIView()

        view.backgroundColor = UIColor(named: "D3")

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func initView() {

        addSubview(lineView)

        lineView.translatesAutoresizingMaskIntoConstraints = false

        lineView.topAnchor.constraint(equalTo: topAnchor).isActive = true

        lineView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        lineView.widthAnchor.constraint(equalToConstant: 1).isActive = true

        lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

    }
}
