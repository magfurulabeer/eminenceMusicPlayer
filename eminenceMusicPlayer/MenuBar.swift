//
//  MenuBar.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/23/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var index = 1
    let deselectedColor = UIColor.white.withAlphaComponent(0.2)
    let imageIcons: [UIImage] = [#imageLiteral(resourceName: "playlistIcon"), #imageLiteral(resourceName: "songIcon"), #imageLiteral(resourceName: "artistIcon"), #imageLiteral(resourceName: "albumIcon")]
    weak var viewController: MusicPlayerViewController?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let cellID = "cellID"
    let collectionViewHeight = 64 - 20
    
    var horizontalBarLeadingConstraint: NSLayoutConstraint?
    
    override var backgroundColor: UIColor? {
        didSet {
            self.collectionView.backgroundColor = self.backgroundColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellID)
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        setUpHorizontalBar()
        selectItemAtIndex(index: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // necessary??
    func selectItemAtIndex(index: Int) {
        if index < imageIcons.count {
            let selectedIndexPath = IndexPath(item: index, section: 0)
            collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
            self.index = index
        }
    }
    
    func setUpHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor.white
        addSubview(horizontalBarView)
        
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarLeadingConstraint = horizontalBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width/4 + frame.width/16)
        horizontalBarLeadingConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/8).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: HorizontalBarHeight).isActive = true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuCell
        cell.imageView.image = imageIcons[indexPath.row].withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        cell.tintColor = deselectedColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewController?.scrollToMenuIndex(index: indexPath.item)
        selectItemAtIndex(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width/4, height: CGFloat(collectionViewHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func highlightCell(index: Int) {
        let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0))
        UIView.animate(withDuration: 0.2) {
            cell?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
    }
    
    func unhighlightCell(index: Int, wasSuccessful: Bool) {
        let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0))
        if wasSuccessful {
            cell?.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                cell?.backgroundColor = UIColor.clear
            }) { (bool) in
                // Code?
            }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                cell?.backgroundColor = UIColor.clear
            }) { (bool) in
            }
        }
    }
    
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MenuCell: BaseCell {
    
    let deselectedColor = UIColor.white.withAlphaComponent(0.2)
    let selectedColor = #colorLiteral(red: 0.7422102094, green: 0.764362216, blue: 0.7821244597, alpha: 1)//UIColor.white.withAlphaComponent(0.8)
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "songIcon")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? selectedColor : deselectedColor
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? selectedColor : deselectedColor
        }
    }
    
    override func setUpViews() {
        super.setUpViews()
        
        addSubview(imageView)
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
