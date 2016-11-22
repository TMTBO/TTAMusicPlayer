//
//  BaseTableViewController.swift
//  TTAMusicPlayer
//
//  Created by ys on 16/11/22.
//  Copyright © 2016年 YS. All rights reserved.
//

import UIKit

class BaseTableViewController: BaseViewController {
    var tableView : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView()
        tableView?.dataSource = self
        tableView?.delegate = self
        
        view.addSubview(tableView!)
        
        registCells(with: ["cell" : UITableViewCell.self])
    }

    override func viewDidLayoutSubviews() {
        tableView?.frame = view.bounds;
    }

    
    /// 注册 cell
    ///
    /// - Parameter cellIds: cellId 与 类对应的字典
    func registCells(with cellIds : [String : UITableViewCell.Type]) {
        for (cellID, cellClass) in cellIds {
            tableView?.register(cellClass, forCellReuseIdentifier: cellID)
        }
    }
}

// MARK: - UITableViewDataSource
extension BaseTableViewController : UITableViewDataSource {
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "This comes from BaseTableViewController"
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BaseTableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
