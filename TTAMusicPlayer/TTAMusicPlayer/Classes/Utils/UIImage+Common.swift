//
//  UIImage+Common.swift
//  TTAMusicPlayer
//
//  Created by ys on 16/11/25.
//  Copyright © 2016年 TobyoTenma. All rights reserved.
//

import UIKit

extension UIImage {
    func tta_combineAtCenter(with image : UIImage) -> UIImage? {
        let point = CGPoint(x: (size.width - image.size.width) / 2.0, y: (size.height - image.size.height) / 2.0)
        return tta_combine(with: image, at: point)
    }
    
    func tta_combine(with image : UIImage, at point : CGPoint) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, kSCREEN_SCALE)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        image.draw(at: point)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func tta_clip(image : UIImage, with rect : CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, kSCREEN_SCALE)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.addEllipse(in: rect)
        ctx?.clip()
        image.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func tta_pickColor(from point : CGPoint) -> UIColor {
        let inImage = self.cgImage
        let pixelData = inImage?.dataProvider?.data
        let data : UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo : Int = ((Int(self.size.width) * Int(point.y)) + Int(point.x)) * 4
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo + 1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo + 2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo + 3]) / CGFloat(255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: a)
        return color

    }
}
