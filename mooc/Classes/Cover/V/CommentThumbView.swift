//
//  CommentThumbView.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/5/11.
//  Copyright © 2020 kilomind. All rights reserved.
//

import Foundation

/// 点赞头像
class CommentThumbView: NineImageView {
    static let itemWidth: CGFloat = (mScreenW - 30 - 16*2) / 7
    var onClick: ((Int)->Void)?
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CommentThumbView.itemWidth, height: CommentThumbView.itemWidth)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点赞头像 \(indexPath)")
        onClick?(indexPath.item)
    }
}
