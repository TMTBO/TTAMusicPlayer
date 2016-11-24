//
//  MusicListViewController.swift
//  MusicPlayer
//
//  Created by ys on 16/11/22.
//  Copyright © 2016年 TobyoTenma. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicListViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.rowHeight = 60 * kSCALEP

        cells = ["music_list_cell" : MusicLisbleViewCell.self]
    }
    
    func item(at indexPaht : IndexPath) -> MPMediaItem {
        return PlayerManager.sharedPlayerManager.musics[indexPaht.row]
    }
}

// MARK: - UITableViewController
extension MusicListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayerManager.sharedPlayerManager.musics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: "music_list_cell", for: indexPath)
        guard let cell = reuseCell as? MusicLisbleViewCell else {
            return reuseCell
        }
        cell.music = item(at: indexPath)
        return cell
    }
}

extension MusicListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playerVc = PlayerViewController()
        playerVc.music = item(at: indexPath)
        playerVc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(playerVc, animated: true)
    }
}
