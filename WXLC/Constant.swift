//
//  Constant.swift
//  WXLC
//
//  Created by liangpengshuai on 21/11/2016.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

import UIKit

let APP_THEME_COLOR: UIColor            = UIColorFromRGB(rgb: 0xF04F46, alpha:1)
let APP_GREEN_COLOR: UIColor            = UIColorFromRGB(rgb: 0x00c284, alpha:1)

let APP_PAGE_COLOR: UIColor             = UIColorFromRGB(rgb: 0xfafafa, alpha:1)

let COLOR_LINE: UIColor                 = UIColorFromRGB(rgb: 0xe2e2e2, alpha:1)

let COLOR_TEXT_I: UIColor               = UIColorFromRGB(rgb: 0x323232, alpha:1)
let COLOR_TEXT_II: UIColor              = UIColorFromRGB(rgb: 0x646464, alpha:1)
let COLOR_TEXT_III: UIColor             = UIColorFromRGB(rgb: 0x969696, alpha:1)
let COLOR_TEXT_IV: UIColor              = UIColorFromRGB(rgb: 0xc8c8c8, alpha:1)
let COLOR_TEXT_V: UIColor               = UIColorFromRGB(rgb: 0xcdcdcd, alpha:1)

let kWindowWidth = UIScreen.main.bounds.size.width
let kWindowHeight = UIScreen.main.bounds.size.height

class Constants {
    
}

func UIColorFromRGB(rgb: Int, alpha: Float) -> UIColor {
    let red = CGFloat(Float(((rgb>>16) & 0xFF)) / 255.0)
    let green = CGFloat(Float(((rgb>>8) & 0xFF)) / 255.0)
    let blue = CGFloat(Float(((rgb>>0) & 0xFF)) / 255.0)
    let alpha = CGFloat(alpha)
    
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}
