//
//  PlaylistsCollectionCell.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/30/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

class PlaylistsCollectionCell: UICollectionViewCell {
    var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    let musicManager = MusicManager.sharedManager
    weak var viewController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        setUpTableView()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTableView() {
        tableView.frame = frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        contentView.addSubview(tableView)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(QuickQueueCell.self, forCellReuseIdentifier: "QuickQueueCell")
        tableView.register(UINib(nibName: "BasicCell", bundle: Bundle.main), forCellReuseIdentifier: "BasicCell")

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tableView.reloadData()
    }
}
