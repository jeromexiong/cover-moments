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
class CommentContentCell: UITableViewCell {
    fileprivate lazy var imageIV: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClick(_:)))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    fileprivate lazy var titleBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(mDarkBlueColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var contentLb: JXLabel = {
        let lb = JXLabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = mBlackColor
        lb.numberOfLines = 0
        return lb
    }()
    fileprivate lazy var commentnputView: CommentInputView = {
        let inputView = CommentInputView()
        inputView.delegate = self
        return inputView
    }()
    /// 是否是自己的评论
    fileprivate var isSelf = false
    var comment: CommentInfo! {
        didSet {
            imageIV.kf.setImage(with: URL(string: comment.avatar_url))
            titleBtn.setTitle(comment.person, for: .normal)

            let reply: String? = "xxx"
            if let parent = reply, !parent.isEmpty {
                contentLb.text = "回复\(parent)：\(comment.comment)"
            }else {
                contentLb.text = comment.comment
            }
            isSelf = true
        }
    }
    var onClick: ((CommentContentClickAction)->Void)?
    var onRelativeRect: (()->CGRect)?
    
    static func getHeight(_ model: CommentInfo) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 14)
        let width = mScreenW - 50 - 34 - MomentHeaderCell.padding * 2
        let height = 50 + model.comment.textSize(width, font: font).height - font.lineHeight
        return height
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClick(_:)))
        tag = 10
        self.addGestureRecognizer(tap)
        
        addSubview(imageIV)
        addSubview(titleBtn)
        addSubview(contentLb)
        setMultiLabel(contentLb)
        
        imageIV.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.leading.equalToSuperview()
            make.top.equalTo(5)
        }
        titleBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(imageIV.snp.trailing).offset(5)
            make.top.equalTo(imageIV)
            make.height.equalTo(18)
            make.trailing.equalToSuperview().offset(-5)
        }
        contentLb.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleBtn)
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
            NotificationCenter.default.post(name: NSNotification.Name.list.openURL, object: URL(string: text))
        }
        lb.handlePhoneTap { (phone) in
            UIApplication.shared.openURL(URL(string: "tel://\(phone)")!)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func viewClick(_ ges: UIGestureRecognizer) {
        let avatar = ges.view?.tag == 0
        if !isSelf {
            self.commentnputView.textView.placeholder = "回复\(comment.person)："
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
        if let onRelativeRect = onRelativeRect {
            commentnputView.scrollForComment(onRelativeRect())
        }
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
