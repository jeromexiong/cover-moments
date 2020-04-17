//
//  MomentCommentCell.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/17.
//  Copyright © 2020 kilomind. All rights reserved.
//

import Foundation

private let paddingBottom: CGFloat = 10
class MomentCommentCell: UICollectionViewCell {
    fileprivate lazy var separatorV: UIView = {
        let v = UIView(frame: bounds)
        v.frame = CGRect(x: 0, y: bounds.height-paddingBottom, width: bounds.width, height: 1)
        v.backgroundColor = UIColor(r: 239, g: 239, b: 239)
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
        addSubview(separatorV)
    }
}
extension MomentCommentCell: ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? MomentInfo else { return }
        print(viewModel.comments.count)
    }
}
