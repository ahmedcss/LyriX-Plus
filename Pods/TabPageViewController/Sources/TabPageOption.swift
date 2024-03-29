//
//  TabPageOption.swift
//  TabPageViewController
//
//  Created by EndouMari on 2016/02/24.
//  Copyright © 2016年 EndouMari. All rights reserved.
//

import UIKit

public struct TabPageOption {
    
    public init() {}
    
    public var fontSize = UIFont.systemFontSize
    public var currentColor = UIColor(red: 0.921, green: 0.341, blue: 0.38, alpha: 1)
    public var defaultColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
    public var tabHeight: CGFloat = 32.0
    public var tabMargin: CGFloat = 20.0
    public var tabWidth: CGFloat?
    public var currentBarHeight: CGFloat = 2.0
    public var tabBackgroundColor: UIColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
    public var pageBackgoundColor: UIColor = UIColor(red: 0.921, green: 0.341, blue: 0.38, alpha: 1)
    public var isTranslucent: Bool = true
    public var hidesTabBarOnSwipe: Bool = false
    
    internal var tabBarAlpha: CGFloat {
        return isTranslucent ? 0.95 : 1.0
    }
    internal var tabBackgroundImage: UIImage {
        return convertImage()
    }
    
    fileprivate func convertImage() -> UIImage {
        let rect : CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context : CGContext? = UIGraphicsGetCurrentContext()
        let backgroundColor = tabBackgroundColor.withAlphaComponent(tabBarAlpha).cgColor
        context?.setFillColor(backgroundColor)
        context?.fill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
