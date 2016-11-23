//
//  UIButton+Common.swift
//  TTAMusicPlayer
//
//  Created by ys on 16/11/23.
//  Copyright © 2016年 TobyoTenma. All rights reserved.
//

import UIKit

typealias TTAButtonActionClosure = ((UIButton?) -> Void)

var tta_actionClosure : TTAButtonActionClosure? = nil


extension UIButton {
    func tta_addTarget(for controlEvents: UIControlEvents, actionClosure: @escaping TTAButtonActionClosure) {
        tta_actionClosure = actionClosure
        self.addTarget(self, action: #selector(action(sender:)), for: controlEvents)
    }
    
    func action(sender: UIButton) {
        tta_actionClosure!(sender)
    }
}
