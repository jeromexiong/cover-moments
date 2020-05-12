//
//  PhotoManager.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/5/8.
//  Copyright © 2020 kilomind. All rights reserved.
//

import JXPhotoBrowser

class PhotoManager {
    /// 预览单张图片
    static func previewImage(_ imageView: UIImageView) {
        let browser = JXPhotoBrowser()
        browser.numberOfItems = { 1 }
        browser.reloadCellAtIndex = { context in
            // 大图显示cell
            guard let browserCell = context.cell as? JXPhotoBrowserImageCell else {
                return
            }
            
            browserCell.imageView.image = imageView.image
            
            // 添加长按事件
            browserCell.longPressedAction = { cell, _ in
                longPress(cell: cell)
            }
        }
        
        // 更丝滑的Zoom动画
        browser.transitionAnimator = JXPhotoBrowserSmoothZoomAnimator(transitionViewAndFrame: { (index, destinationView) -> JXPhotoBrowserSmoothZoomAnimator.TransitionViewAndFrame? in
            let transitionView = UIImageView(image: imageView.image)
            transitionView.contentMode = imageView.contentMode
            transitionView.clipsToBounds = true
            let thumbnailFrame = imageView.convert(imageView.bounds, to: destinationView)
            return (transitionView, thumbnailFrame)
        })
        
        browser.show()
    }
    /// 预览多张图片
    static func previewImages(_ images: [String], collectionView: UICollectionView, indexPath: IndexPath) {
        let browser = JXPhotoBrowser()
        browser.numberOfItems = {
            images.count
        }
        browser.reloadCellAtIndex = { context in
            // 大图显示cell
            guard let browserCell = context.cell as? JXPhotoBrowserImageCell else {
                return
            }
            
            let url = URL(string: images[context.index])
            browserCell.index = context.index
            
            browserCell.imageView.kf.setImage(with: url, placeholder: nil, options: [], progressBlock: nil, completionHandler: { (_, _, _, _) in
                browserCell.setNeedsLayout()
            })
            
            // 添加长按事件
            browserCell.longPressedAction = { cell, _ in
                self.longPress(cell: cell)
            }
        }
        
        // 更丝滑的Zoom动画
        browser.transitionAnimator = JXPhotoBrowserSmoothZoomAnimator(transitionViewAndFrame: { (index, destinationView) -> JXPhotoBrowserSmoothZoomAnimator.TransitionViewAndFrame? in
            let path = IndexPath(item: index, section: indexPath.section)
            guard let cell = collectionView.cellForItem(at: path) as? NineImageViewCell else {
                return nil
            }
            let image = cell.imageIV.image
            let transitionView = UIImageView(image: image)
            transitionView.contentMode = cell.imageIV.contentMode
            transitionView.clipsToBounds = true
            let thumbnailFrame = cell.imageIV.convert(cell.imageIV.bounds, to: destinationView)
            return (transitionView, thumbnailFrame)
        })
        
        // UIPageIndicator样式的页码指示器
        browser.pageIndicator = JXPhotoBrowserDefaultPageIndicator()
        browser.pageIndex = indexPath.item
        browser.show()
    }
    
    static private func longPress(cell: JXPhotoBrowserImageCell) {
        let root = UIApplication.shared.windows.first!
        let sheets = [JXActionSheet.Model(title: "保存图片")]
        JXActionSheet.show(sheets) { (index) in
            if index == 1 {
                SystemProxy().saveImage(cell.imageView.image!) { (status) in
                    if status {
                        print("保存成功")
                    } else {
                        print("保存失败")
                    }
                }
            }
        }
    }
}
