//
//  SelectionView.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/18.
//

import UIKit

protocol SelectionViewDelegate: AnyObject {

    func didSelected(selectionView: SelectionView, index: Int)

}

protocol SelectionViewDatasource: AnyObject {

    func selectStatus(selectionView: SelectionView) -> [String]

}

class SelectionView: UIView {

    weak var delegate: SelectionViewDelegate? {

        didSet {

            collectionView.delegate = self

        }

    }

    weak var dataSource: SelectionViewDatasource? {

        didSet {

            collectionView.dataSource = self
            collectionView.reloadData()

        }

    }

    lazy var collectionView: UICollectionView = {

        let layoutObject = UICollectionViewFlowLayout()

        layoutObject.minimumInteritemSpacing = 5

        layoutObject.minimumLineSpacing = 5

        layoutObject.itemSize = bounds.size

        layoutObject.sectionInset = UIEdgeInsets.zero

        layoutObject.scrollDirection = .horizontal

        let collectionView = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: layoutObject
        )

        collectionView.register(
            SelectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: SelectionViewCell.self)
        )

        collectionView.backgroundColor = UIColor.white

        collectionView.showsHorizontalScrollIndicator = false

        collectionView.allowsMultipleSelection = true

        return collectionView
    }()

    lazy var imageView: UIImageView = {

        let imageView = UIImageView(image: UIImage(systemName: "pencil.circle.fill")) // remember to change pic

        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initView()
    }

    private func initView() {

        self.backgroundColor = .white

        addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true

        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65).isActive = true

        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true

        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true

        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true

        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }

}

extension SelectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        16
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(
            describing: SelectionViewCell.self), for: indexPath)
        guard let selectionViewCell = cell as? SelectionViewCell else { return cell }
        if let selectStatus = dataSource?.selectStatus(selectionView: self) {
            if selectStatus[indexPath.item] == "0" {
                selectionViewCell.isSelected = false
            } else {
                self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
        }

        return selectionViewCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelected(selectionView: self, index: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegate?.didSelected(selectionView: self, index: indexPath.row)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        return CGSize(width: 50, height: 50)
    }

}

class SelectionViewCell: UICollectionViewCell {

    private let colorView = UIView()

    override var isSelected: Bool {
        didSet {
            colorView.backgroundColor = isSelected ? .yellow : .red
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initView()
    }

    private func initView() {

        stickSubView(colorView)

        colorView.backgroundColor = .black
    }
}
