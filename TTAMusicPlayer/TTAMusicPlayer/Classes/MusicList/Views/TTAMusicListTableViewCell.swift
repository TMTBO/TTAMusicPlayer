//
//  TTAMusicListTableViewCell.swift
//  TTAMusicPlayer
//
//  Created by ys on 16/11/22.
//  Copyright © 2016年 TobyoTenma. All rights reserved.
//

import UIKit
import SnapKit
import MediaPlayer

class TTAMusicListTableViewCell: UITableViewCell {
    var songImageView = UIImageView()
    var nameLabel = UILabel()
    var singerLabel = UILabel()
    
    var music : MPMediaItem? {
        didSet {
            songImageView.image = music?.artwork?.image(at: songImageView.bounds.size)
            nameLabel.text = music?.title
            singerLabel.text = music?.artist
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.separatorInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    func setupUI() {
        // config
        songImageView.image = UIImage(named: "cm2_default_cover")
        songImageView.layer.cornerRadius = 5
        songImageView.layer.masksToBounds = true
        songImageView.layer.shouldRasterize = true
        songImageView.layer.rasterizationScale = UIScreen.main.scale
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        singerLabel.font = UIFont.systemFont(ofSize: 15)
        singerLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        nameLabel.text = "song's name"
        singerLabel.text = "singer name"
        
        // add
        contentView.addSubview(songImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(singerLabel)
        
        // layout
        songImageView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.contentView).offset(3)
            make.leftMargin.equalTo(self.contentView)
            make.width.height.equalTo(snp.height).offset(-6)
        })
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(songImageView).offset(3)
            make.left.equalTo(songImageView.snp.right).offset(14)
        }
        singerLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(songImageView.snp.bottom).offset(-3)
            make.left.equalTo(nameLabel.snp.left)
        }
    }

}
