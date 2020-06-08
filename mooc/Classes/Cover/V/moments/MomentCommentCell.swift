//
//  MomentCommentCell.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/17.
//  Copyright © 2020 kilomind. All rights reserved.
//

import Foundation

class MomentCommentCell: UICollectionViewCell {
    fileprivate lazy var contentV: UIView = {
        let v = UIView()
        let x = MomentHeaderCell.padding
        v.frame = CGRect(x: x, y: 10, width: bounds.width-x*2, height: 0)
        v.backgroundColor = UIColor.groupTableViewBackground.withAlphaComponent(0.5)
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        return v
    }()
    fileprivate lazy var thumbView: NineImageView = {
        let view = CommentThumbView(frame: .zero)
        return view
    }()
    fileprivate lazy var thumbIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "ico-点赞-moment"))
        iv.frame = CGRect(x: 10, y: 10, width: 14, height: 12)
        return iv
    }()
    fileprivate lazy var commentIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "ico-评论-moment"))
        iv.frame = CGRect(x: 10, y: 10, width: 14, height: 12)
        return iv
    }()
    fileprivate lazy var commentView: CommentContentView = {
        let view = CommentContentView(frame: .zero)
        return view
    }()
    fileprivate lazy var divisionV: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: contentV.bounds.width, height: 1)
        v.backgroundColor = UIColor.jx_color(hex: "#F0F0F0")
        return v
    }()
    fileprivate lazy var separatorV: UIView = {
        let v = UIView(frame: bounds)
        v.frame = CGRect(x: 0, y: bounds.height-1, width: bounds.width, height: 1)
        v.backgroundColor = UIColor.jx_color(hex: "#F0F0F0")
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        addSubview(contentV)
        contentV.addSubview(thumbIcon)
        contentV.addSubview(thumbView)
        
        contentV.addSubview(divisionV)
        contentV.addSubview(commentIcon)
        contentV.addSubview(commentView)
        
        addSubview(separatorV)
        
        // 离屏渲染 + 栅格化
        layer.drawsAsynchronously = true
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
extension MomentCommentCell: ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? MomentInfo else { return }
        contentV.frame.size.height = viewModel.contentHeight
        
        let minX = thumbIcon.frame.maxX + thumbIcon.frame.minX
        thumbView.frame = CGRect(x: minX, y: 5, width: contentV.bounds.width-minX, height: viewModel.thumbsHeight-10)
        thumbView.images = viewModel.comments.map({$0.avatar_url})
        
        divisionV.frame.origin.y = thumbView.frame.maxY+5-divisionV.frame.height
        divisionV.isHidden = viewModel.comments.count == 0
        
        commentIcon.frame.origin.y = thumbIcon.frame.minY + divisionV.frame.maxY
        commentView.frame = CGRect(x: minX, y: divisionV.frame.maxY, width: thumbView.bounds.width, height: viewModel.commentHeight)
        commentView.comments = viewModel.comments
    }
}
