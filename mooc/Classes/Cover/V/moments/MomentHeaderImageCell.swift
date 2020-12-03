//
//  MomentHeaderImageCell.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/16.
//  Copyright © 2020 kilomind. All rights reserved.
//

import Kingfisher

/// 单张图片显示
class MomentHeaderImageCell: UICollectionViewCell {
    static let padding: CGFloat = 16
    static let contentLeft = padding+10+50
    static let contentW = mScreenW-padding-contentLeft
    fileprivate lazy var avatarIV: UIImageView = {
        let iv = UIImageView()
        iv.frame = CGRect(x: MomentHeaderCell.padding, y: 10, width: 50, height: 50)
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(previewImage(_:)))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    fileprivate lazy var usernameLb: UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: avatarIV.frame.maxX+10, y: avatarIV.frame.minY+2, width: MomentHeaderCell.contentW, height: 20)
        lb.textColor = mCoverColor
        lb.font = UIFont.boldSystemFont(ofSize: 17)
        return lb
    }()
    fileprivate lazy var contentLb: JXLabel = {
        let lb = JXLabel()
        lb.frame = CGRect(x: usernameLb.frame.minX, y: usernameLb.frame.maxY+5, width: MomentHeaderCell.contentW, height: 0)
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.numberOfLines = 0
        lb.showFavor = {[weak self] in
            guard let self = self else { return }
        }
        return lb
    }()
    /// 单张图片
    fileprivate lazy var singleIV: UIImageView = {
        let iv = UIImageView()
        iv.frame = contentLb.frame
        iv.clipsToBounds = true
        iv.autoresizesSubviews = true
        iv.clearsContextBeforeDrawing = true
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(previewImage(_:)))
        iv.addGestureRecognizer(tap)
        iv.tag = 10
        return iv
    }()
    fileprivate lazy var expendBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("展开", for: .normal)
        btn.setTitle("收起", for: .selected)
        btn.setTitleColor(.blue, for: .normal)
        btn.setTitleColor(.blue, for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        btn.sizeToFit()
        btn.isHidden = true
        return btn
    }()
    
    var onClick: ((Int)->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    var viewModel: MomentInfo?
}
extension MomentHeaderImageCell {
    func setup() {
        addSubview(avatarIV)
        addSubview(usernameLb)
        addSubview(contentLb)
        addSubview(singleIV)
        addSubview(expendBtn)
        setLabel()
    }
    func setLabel() {
        contentLb.enabledTypes = [.URL, .phone]
        contentLb.handleURLTap { (text) in
            NotificationCenter.default.post(name: NSNotification.Name.list.openURL, object: URL(string: text))
        }
        contentLb.handlePhoneTap { (phone) in
            UIApplication.shared.openURL(URL(string: "tel://\(phone)")!)
        }
    }
    @objc func previewImage(_ ges: UIGestureRecognizer) {
        switch ges.view?.tag {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name.list.push, object: viewModel?.userInfo)
        case 10:
            print("预览图片")
        default:
            break
        }
    }
    @objc func click(_ btn: UIButton) {
        onClick?(btn.tag)
    }
}
extension MomentHeaderImageCell: ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? MomentInfo else { return }
        self.viewModel = viewModel
        avatarIV.kf.setImage(with: URL(string: viewModel.avatar))
        usernameLb.text = viewModel.userName
        
        contentLb.text = viewModel.content
        contentLb.frame.size.height = viewModel.textHeight
        
        
        if viewModel.isNeedExpend {
            expendBtn.isSelected = viewModel.isTextExpend
            contentLb.numberOfLines = viewModel.isTextExpend ? 0 : 3
            expendBtn.frame.origin = CGPoint(x: contentLb.frame.minX, y: contentLb.frame.maxY)
        }
        expendBtn.isHidden = !viewModel.isNeedExpend
        
        if viewModel.images.count > 0 {
            let maxY = contentLb.frame.maxY + 10 + (!expendBtn.isHidden ? expendBtn.frame.height : 0)
            singleIV.kf.setImage(with: URL(string: viewModel.images[0]))
            singleIV.frame.origin.y = maxY
            singleIV.frame.size.height = viewModel.momentPicsHeight(viewModel.images.count)
            singleIV.frame.size.width = singleIV.frame.size.height
        }else {
            singleIV.frame.size.height = 0
        }
    }
}

