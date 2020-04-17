//
//  MomentTopCell.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/16.
//  Copyright © 2020 kilomind. All rights reserved.
//

import Foundation

private let topOffset: CGFloat = 60
private let bottomIndent: CGFloat = 40
private let avatorW: CGFloat = 80
private let space: CGFloat = 20
class MomentTopCell: UICollectionViewCell {
    fileprivate lazy var headIV: UIImageView = {
        let iv = UIImageView()
        iv.frame = CGRect(x: 0, y: 0, width: mScreenW, height: bounds.size.height - bottomIndent)
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    fileprivate lazy var avatarIV: UIImageView = {
        let iv = UIImageView()
        iv.frame =  CGRect(x: mScreenW - avatorW - 16, y: headIV.frame.maxY, width: avatorW, height: avatorW)
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        return iv
    }()
    fileprivate lazy var usernameLb: UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: 0, y: avatarIV.frame.minY + space, width: avatarIV.frame.minX - space, height: 30)
        lb.textAlignment = .right
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 25)
        return lb
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
        addSubview(headIV)
        addSubview(avatarIV)
        addSubview(usernameLb)
        headIV.frame.origin.y -= topOffset
        avatarIV.frame.origin.y -= topOffset
        usernameLb.frame.origin.y -= topOffset
        headIV.frame.size.height += topOffset
    }
}
extension MomentTopCell: ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? MomentInfo, let info = viewModel.userInfo else { return }
        headIV.kf.setImage(with: URL(string: info.topUrl))
        avatarIV.kf.setImage(with: URL(string: info.avatar))
        usernameLb.text = info.userName
    }
}
