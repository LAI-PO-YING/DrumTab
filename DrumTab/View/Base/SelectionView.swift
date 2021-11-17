//
//  SelectionView.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/18.
//

import UIKit

protocol SelectionViewDelegate: AnyObject {

    func didSelected(selectionView: SelectionView, indexPath: IndexPath)
    func didScroll(offset: CGPoint)

}

protocol SelectionViewDatasource: AnyObject {

    func selectStatus(selectionView: SelectionView) -> [String]
    func setImage(selectionView: SelectionView) -> UIImage

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
            imageView.image = dataSource?.setImage(selectionView: self)
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

        collectionView.register(
            HeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderCollectionReusableView.identifier
        )

        collectionView.backgroundColor = UIColor(named: "D2")

        collectionView.showsHorizontalScrollIndicator = false

        collectionView.allowsMultipleSelection = true

        return collectionView
    }()

    lazy var imageView: UIImageView = {

        let imageView = UIImageView(image: UIImage(systemName: "pencil.circle.fill")) // remember to change pic

        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.clear

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

        self.backgroundColor = UIColor(named: "D2")

        addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true

        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65).isActive = true

        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true

        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true

        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true

        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true

    }

}

extension SelectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(
            describing: SelectionViewCell.self), for: indexPath)
        guard let selectionViewCell = cell as? SelectionViewCell else { return cell }
        if let selectStatus = dataSource?.selectStatus(selectionView: self) {
            if selectStatus[4*indexPath.section + indexPath.item] == "0" {
                selectionViewCell.isSelected = false
            } else {
                self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
        }

        return selectionViewCell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScroll(offset: collectionView.contentOffset)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelected(selectionView: self, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegate?.didSelected(selectionView: self, indexPath: indexPath)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        return CGSize(width: 50, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderCollectionReusableView.identifier,
            for: indexPath
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        } else {
            return CGSize(
                width: 20, height: self.frame.size.height
            )
        }
    }
}

class SelectionViewCell: UICollectionViewCell {

    private let colorView = UIView()

    override var isSelected: Bool {
        didSet {
            colorView.backgroundColor = isSelected ? UIColor(named: "G1") : UIColor(named: "D3")
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
        colorView.layer.shadowOffset = CGSize(width: 0, height: 5)
        colorView.layer.shadowOpacity = 0.2
        colorView.layer.cornerRadius = 5
    }
}
