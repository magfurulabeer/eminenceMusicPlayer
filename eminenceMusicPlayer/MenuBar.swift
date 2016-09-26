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
    let deselectedColor = UIColor(red: 92/255.0, green: 46/255.0, blue: 46/255.0, alpha: 1)
    let imageIcons: [UIImage] = [#imageLiteral(resourceName: "genreIcon"), #imageLiteral(resourceName: "songIcon"), #imageLiteral(resourceName: "artistIcon"), #imageLiteral(resourceName: "albumIcon")]
    
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
        backgroundColor = UIColor.blue
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
        let x = CGFloat(indexPath.item) * frame.width/4 + frame.width/16
        horizontalBarLeadingConstraint?.constant = x
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
            self.layoutIfNeeded()
            }, completion: nil)
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width/4, height: CGFloat(collectionViewHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
    
    let deselectedColor = UIColor(red: 92/255.0, green: 46/255.0, blue: 46/255.0, alpha: 1)
    let selectedColor = UIColor.white.withAlphaComponent(0.8)
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
