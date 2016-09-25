//
//  MusicViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/21/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, QuickBarDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var musicManager = MusicManager.sharedManager
    var tableView = UITableView()
    var selectedCell: UITableViewCell?
    var selectedIndexPath: IndexPath?
    var savedSong: MPMediaItem?
    var savedTime: TimeInterval?
    var savedRepeatMode: MPMusicRepeatMode?
    var savedPlayerIsPlaying: MPMusicPlaybackState?
    var quickBar: NowPlayingQuickBar?
    let slideDownInteractor = SlideDownInteractor()
    let menuBar: MenuBar = {
        let mb = MenuBar()
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        setUpMenuBar()
        setUpQuickBar()
        setUpTableView()
        quickBar?.delegate = self
        setUpGradient()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if musicManager.itemNowPlaying == nil {
            quickBar?.fullHeightConstraint.isActive = false
            quickBar?.zeroHeightConstraint.isActive = true
            view.layoutIfNeeded()
        } else {
            quickBar?.fullHeightConstraint.isActive = true
            quickBar?.zeroHeightConstraint.isActive = false
        }
    }
    
    func setUpGradient() {
        let gradient = CAGradientLayer()
//        let startColor = UIColor(red: 155/255.0, green: 107/255.0, blue: 98/255.0, alpha: 1)
//        let endColor = UIColor(red: 75/255.0, green: 47/255.0, blue: 51/255.0, alpha: 1)
//        let endColor = UIColor(red: 51/255.0, green: 32/255.0, blue: 35/255.0, alpha: 1)
        let startColor = UIColor(red: 92/255.0, green: 46/255.0, blue: 46/255.0, alpha: 1)
        let endColor = UIColor(red: 54/255.0, green: 49/255.0, blue: 58/255.0, alpha: 1)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.frame = self.view.frame
        let points = (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1))
        gradient.startPoint = points.0
        gradient.endPoint = points.1
        view.layer.addSublayer(gradient)
        gradient.zPosition = -5
    }
    
    func setUpQuickBar() {
        quickBar = NowPlayingQuickBar(frame: CGRect(x: 0, y: view.frame.height - tabBarHeight - quickBarHeight, width: view.frame.width, height: quickBarHeight))
        quickBar!.backgroundColor = QuickBarBackgroundColor // UIColor.red.withAlphaComponent(0.5)
        view.addSubview(quickBar!)
        quickBar!.translatesAutoresizingMaskIntoConstraints = false
        quickBar!.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        quickBar!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quickBar!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quickBar!.fullHeightConstraint.isActive = true
    }
    
    func setUpMenuBar() {
        view.addSubview(menuBar)
        menuBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 64).isActive = true
        menuBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuBar.backgroundColor = QuickBarBackgroundColor
        
        menuBar.layer.shadowColor = UIColor.black.cgColor
        menuBar.layer.shadowOpacity = 1
        menuBar.layer.shadowOffset = CGSize.zero
        menuBar.layer.shadowRadius = 10
        let rect = CGRect(x: 0, y: 0, width: view.frame.width, height: 70)
        menuBar.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        
        let border = UIView()
        border.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        menuBar.addSubview(border)
        border.translatesAutoresizingMaskIntoConstraints = false
        border.bottomAnchor.constraint(equalTo: menuBar.bottomAnchor).isActive = true
        border.leadingAnchor.constraint(equalTo: menuBar.leadingAnchor).isActive = true
        border.trailingAnchor.constraint(equalTo: menuBar.trailingAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setUpTableView() {
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
//        tableView.separatorEffect = 
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MusicViewController.handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPressGestureRecognizer)
//        tableView.register(UINib(nibName: "BasicSongCell", bundle: Bundle.main), forCellReuseIdentifier: "BasicCell")
        tableView.register(UINib(nibName: "SongCell", bundle: Bundle.main), forCellReuseIdentifier: "SongCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: menuBar.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: quickBar!.topAnchor).isActive = true
        tableView.reloadData()
    }
    
    
    func quickBarWasTapped(sender: NowPlayingQuickBar) {
        if let nowPlayingVC = storyboard!.instantiateViewController(withIdentifier: "NowPlayingViewController") as? NowPlayingViewController {
            nowPlayingVC.transitioningDelegate = nowPlayingVC
            nowPlayingVC.interactor = slideDownInteractor
            present(nowPlayingVC, animated: true, completion: nil)
        }
//        performSegue(withIdentifier: "NowPlayingSegue", sender: nil)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destination as? NowPlayingViewController {
            destinationVC.transitioningDelegate = destinationVC
            destinationVC.interactor = slideDownInteractor
        }
    }
    
    
}
