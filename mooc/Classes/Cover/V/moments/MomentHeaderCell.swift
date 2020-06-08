//
//  MomentHeaderCell.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/14.
//  Copyright © 2020 kilomind. All rights reserved.
//

import Kingfisher

/// 多张图片显示
class MomentHeaderCell: UICollectionViewCell {
    static let padding: CGFloat = 16
    static let contentLeft = padding+10+50
    static let contentW = mScreenW-padding-contentLeft
    fileprivate lazy var avatarIV: UIImageView = {
        let iv = UIImageView()
        iv.frame = CGRect(x: MomentHeaderCell.padding, y: 10, width: 50, height: 50)
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        return iv
    }()
    fileprivate lazy var usernameLb: UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: avatarIV.frame.maxX+10, y: 12, width: MomentHeaderCell.contentW, height: 20)
        lb.textColor = mCoverColor
        lb.font = UIFont.boldSystemFont(ofSize: 17)
        return lb
    }()
    fileprivate lazy var contentLb: JXLabel = {
        let lb = JXLabel()
        lb.frame = CGRect(x: usernameLb.frame.minX, y: usernameLb.frame.maxY, width: MomentHeaderCell.contentW, height: 0)
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.numberOfLines = 0
        return lb
    }()
    fileprivate lazy var nineImageView: NineImageView = {
        let view = NineImageView(frame: .zero)
        view.frame = contentLb.frame
        view.frame.size.width -= 50
        return view
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
        addSubview(avatarIV)
        addSubview(usernameLb)
        addSubview(contentLb)
        addSubview(nineImageView)
        setLabel()
    }
    func setLabel() {
        let reply = JXLabelType.custom(pattern: "回复(.+)：", start: 2, tender: -1)
        contentLb.customColor = [reply: mDarkBlueColor]
        contentLb.enabledTypes = [.URL, .phone, reply]
        contentLb.handleCustomTap(reply) { (text) in
            print(text)
        }
        contentLb.handleURLTap { (text) in
            print(text)
        }
    }
}

extension MomentHeaderCell: ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? MomentInfo else { return }
        self.avatarIV.kf.setImage(with: URL(string: viewModel.avatar))
        self.usernameLb.text = viewModel.userName
        
        if !viewModel.content.isEmpty {
            contentLb.text = viewModel.content
            let size = viewModel.content.textSize(contentLb.frame.width, font: contentLb.font)
            contentLb.frame.size.height = size.height
        }else {
            contentLb.frame.size.height = 0
        }
        // 不能通过if判断切换同一位置的显示视图
        if viewModel.images.count > 0 {
            let maxY = contentLb.frame.maxY + 10
            nineImageView.images = viewModel.images
            nineImageView.frame.origin.y = maxY
            nineImageView.frame.size.height = viewModel.momentPicsHeight(viewModel.images.count)
        }else {
            nineImageView.frame.size.height = 0
        }
    }
}
