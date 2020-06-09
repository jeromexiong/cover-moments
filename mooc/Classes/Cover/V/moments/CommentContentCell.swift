//
//  CommentContentCell.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/6/9.
//  Copyright © 2020 kilomind. All rights reserved.
//

import Foundation

enum CommentContentClickAction {
    /// 点击头像
    case avatar
    /// 点击title
    case title
    /// 回复的标题
    case reply
    /// 点击背景 是否是自己的评论
    case bg(Bool)
    /// 评论
    case comment(String)
    /// 草稿
    case commentDraft(String)
}
class CommentContentCell: UICollectionViewCell {
    lazy var imageIV: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClick(_:)))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    lazy var titleBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(mDarkBlueColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        return btn
    }()
    lazy var contentLb: JXLabel = {
        let lb = JXLabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = mBlackColor
        lb.numberOfLines = 0
        return lb
    }()
    fileprivate lazy var separatorView: UIView = {
        let v = UIView()
        v.frame = self.bounds
        v.frame.size.height = 0.5
        v.frame.origin.y = self.bounds.height - 0.5
        v.backgroundColor = UIColor.jx_color(hex: "#F0F0F0")
        return v
    }()
    fileprivate lazy var commentnputView: CommentInputView = {
        let inputView = CommentInputView()
        inputView.delegate = self
        return inputView
    }()
    /// 是否是自己的评论
    var isSelf = false
    var onClick: ((CommentContentClickAction)->Void)?
    func setContent(_ text: String, parent: String?) {
        if let parent = parent, !parent.isEmpty {
            contentLb.text = "回复\(parent)：\(text)"
        }else {
            contentLb.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClick(_:)))
        tag = 10
        self.addGestureRecognizer(tap)
        
        addSubview(imageIV)
        addSubview(titleBtn)
        addSubview(contentLb)
        setMultiLabel(contentLb)
        addSubview(separatorView)
        
        imageIV.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.leading.centerY.equalToSuperview()
        }
        titleBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(imageIV.snp.trailing).offset(5)
            make.top.equalTo(imageIV)
            make.height.equalTo(18)
            make.trailing.lessThanOrEqualToSuperview()
        }
        contentLb.snp.makeConstraints { (make) in
            make.leading.equalTo(titleBtn)
            make.top.equalTo(titleBtn.snp.bottom)
        }
    }
    
    private func setMultiLabel(_ lb: JXLabel) {
        let reply = JXLabelType.custom(pattern: "回复(.+)：", start: 2, tender: -1)
        lb.customColor = [reply: mDarkBlueColor]
        lb.enabledTypes = [.URL, .phone, reply]
        lb.handleCustomTap(reply) {[weak self] (text) in
            self?.onClick?(.reply)
        }
        lb.handleURLTap { (text) in
            print(text)
        }
        lb.handlePhoneTap { (phone) in
            print(phone)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func viewClick(_ ges: UIGestureRecognizer) {
        let avatar = ges.view?.tag == 0
        if !isSelf {
            self.commentnputView.show()
        }
        onClick?(avatar ? .avatar : .bg(isSelf))
    }
    @objc private func click(_ btn: UIButton) {
        onClick?(.title)
    }
    
}

extension CommentContentCell: CommentInputViewDelegate {
    func onTopChanged(_ top: CGFloat) {
        commentnputView.scrollForComment(self)
    }
    
    func onTextChanged(_ text: String) {
        print("comment draft: \(text)")
        self.onClick?(.commentDraft(text))
    }
    
    func onSend(_ text: String) {
        if !text.isEmpty {
            self.onClick?(.comment(text))
        }
    }
}
