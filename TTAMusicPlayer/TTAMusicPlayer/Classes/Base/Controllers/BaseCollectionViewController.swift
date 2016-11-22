//
//  BaseCollectionViewController.swift
//  TTAMusicPlayer
//
//  Created by ys on 16/11/22.
//  Copyright © 2016年 YS. All rights reserved.
//

import UIKit

class BaseCollectionViewController: BaseViewController {
    
    var collectionView : UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: prepareCollectionViewLauout())
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        view.addSubview(collectionView!)
        
        registCells(with: ["cell" : UICollectionView.self])
    }

    func prepareCollectionViewLauout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return layout
    }
    
    func registCells(with cellIds : [String : UICollectionView.Type]) {
        for (cellId, cellClass) in cellIds {
            collectionView?.register(cellClass, forCellWithReuseIdentifier: cellId)
        }
    }
    

}


// MARK: - UICollectionViewDataSource
extension BaseCollectionViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension BaseCollectionViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
