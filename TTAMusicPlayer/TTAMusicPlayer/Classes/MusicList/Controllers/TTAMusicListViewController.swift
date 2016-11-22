//
//  TTAMusicListViewController.swift
//  TTAMusicPlayer
//
//  Created by ys on 16/11/22.
//  Copyright © 2016年 TobyoTenma. All rights reserved.
//

import UIKit
import MediaPlayer

class TTAMusicListViewController: BaseTableViewController {
    
    var musics : [MPMediaItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.rowHeight = 60
        
//        cells = ["music_list_cell" : TTAMusicListTableViewCell.self]
        tableView?.register(TTAMusicListTableViewCell.self, forCellReuseIdentifier: "music_list_cell")
    }

    override func getMainData() {
        let allMusic = MPMediaQuery.songs()
        musics = allMusic.items!
        tableView?.reloadData()
    }
    
    func item(at indexPaht : IndexPath) -> MPMediaItem {
        return musics[indexPaht.row]
    }
}

// MARK: - UITableViewController
extension TTAMusicListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: "music_list_cell", for: indexPath)
        guard let cell = reuseCell as? TTAMusicListTableViewCell else {
            return reuseCell
        }
        cell.music = item(at: indexPath)
        return cell
    }
}
