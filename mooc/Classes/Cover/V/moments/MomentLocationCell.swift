//
//  MomentLocationCell.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/15.
//  Copyright © 2020 kilomind. All rights reserved.
//

import Foundation

class MomentLocationCell: UICollectionViewCell {
    fileprivate lazy var locationBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame.origin = CGPoint(x: MomentHeaderCell.contentLeft, y: 0)
        btn.setTitleColor(UIColor.jx_color(hex: "#7B7F8E"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
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
        addSubview(locationBtn)
    }
    @objc func click(_ btn: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name.list.location, object: viewModel)
    }
    var viewModel: MomentInfo?
}
extension MomentLocationCell: ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? MomentInfo else { return }
        self.viewModel = viewModel
        locationBtn.setTitle(viewModel.location, for: .normal)
        locationBtn.sizeToFit()
    }
}
