//
//  NowPlayingQuickBar.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/22/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

class NowPlayingQuickBar: UIView {

    var musicManager = MusicManager.sharedManager

    var albumThumbnail = UIImageView()
    var songTitleLabel = UILabel()
    var artistLabel = UILabel()
    var playButton = UIButton(type: UIButtonType.custom)
    var pauseButton = UIButton(type: UIButtonType.custom)
    
 
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpAlbumThumbnail()
        setUpPlayButton()
        setUpPauseButton()
        setUpSongTitleLabel()
        setUpArtistLabel()
        
        if musicManager.player.playbackState == MPMusicPlaybackState.playing {
            playButton.isHidden = true
        } else {
            pauseButton.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func playButtonTapped(sender: UIButton) {
        musicManager.player.play()
        playButton.isHidden = true
        pauseButton.isHidden = false
    }
    
    func pauseButtonTapped(sender: UIButton) {
        musicManager.player.pause()
        playButton.isHidden = false
        pauseButton.isHidden = true
    }
}
