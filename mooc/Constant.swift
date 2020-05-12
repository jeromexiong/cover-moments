//
//  Constant.swift
//
//  Created by Jerome Xiong on 2020/4/17.
//  Copyright © 2020 kilomind. All rights reserved.
//

import UIKit

// MARK: - Common
/// 是否刘海屏
var isFringe: Bool {
    if #available(iOS 11, *) {
          guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
              return false
          }
          
          if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
              return true
          }
    }
    return false
}
/// 状态栏高度
var mStatusBarH: CGFloat {
    if #available(iOS 13.0, *) {
        guard let statusbar = UIApplication.shared.windows.first?.windowScene?.statusBarManager else {
            return 0
        }
        return statusbar.statusBarFrame.size.height
    } else {
        return UIApplication.shared.statusBarFrame.size.height
    }
}
var mBottomIndent: CGFloat = isFringe ? 34 : 0
let mNavigationBarH: CGFloat = 44
let mTopHeight: CGFloat = mNavigationBarH + mStatusBarH
let mTabbarH: CGFloat = UIApplication.shared.statusBarFrame.size.height > 20.0 ? 83.0 : 49.0

let mScreenBounds = UIScreen.main.bounds
let mScreenW = UIScreen.main.bounds.width
let mScreenH = UIScreen.main.bounds.height
let mImageW = (mScreenW - 156) / 3

let mBlackColor = UIColor.jx_color(hex: "#444444")
let mDarkBlueColor = UIColor.jx_color(hex: "#375793")
let mCoverColor = UIColor(r: 104, g: 114, b: 140)
