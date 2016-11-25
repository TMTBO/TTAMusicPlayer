//
//  String+Common.swift
//  TTAMusicPlayer
//
//  Created by ys on 16/11/25.
//  Copyright © 2016年 TobyoTenma. All rights reserved.
//

import UIKit

let dateFormater = DateFormatter()

extension String {
    static func tta_string(from timeInterval : TimeInterval, with format : String) -> String? {
        dateFormater.dateFormat = format
        let date = Date(timeIntervalSince1970: timeInterval)
        let timeString = dateFormater.string(from: date)
        return timeString
    }
}
