//
//  MomentBottomCell.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/15.
//  Copyright © 2020 kilomind. All rights reserved.
//

import Foundation

class MomentBottomCell: UICollectionViewCell {
    fileprivate lazy var timeLb: UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: MomentHeaderCell.contentLeft, y: 0, width: mScreenW-100, height: 20)
        lb.textColor = UIColor.jx_color(hex: "#BCBBBD")
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    fileprivate lazy var moreBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: mScreenW-MomentHeaderCell.padding-30, y: 0, width: 30, height: 20)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.setTitleColor(mCoverColor, for: .normal)
        btn.setTitle("··", for: .normal)
        btn.backgroundColor = .groupTableViewBackground
        btn.layer.cornerRadius = 2
        btn.layer.masksToBounds = true
        return btn
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
        addSubview(timeLb)
        addSubview(moreBtn)
    }
}
extension MomentBottomCell: ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? MomentInfo else { return }
        timeLb.text = viewModel.publicTime
    }
}
