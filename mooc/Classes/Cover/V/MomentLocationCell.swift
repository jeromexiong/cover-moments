//
//  MomentLocationCell.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/15.
//  Copyright © 2020 kilomind. All rights reserved.
//

import Foundation

class MomentLocationCell: UICollectionViewCell {
    fileprivate lazy var locationLb: UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: MomentHeaderCell.contentLeft, y: 0, width: mScreenW, height: 20)
        lb.textColor = UIColor.jx_color(hex: "#7B7F8E")
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.contentMode = .left
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
        addSubview(locationLb)
    }
}
extension MomentLocationCell: ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? MomentInfo else { return }
        locationLb.text = viewModel.location
    }
}
