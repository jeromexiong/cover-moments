//
//  CommentContentView.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/5/11.
//  Copyright © 2020 kilomind. All rights reserved.
//

import SnapKit

class CommentContentView: UICollectionView {
    var comments = [CommentInfo]() {
        didSet {
            reloadData()
        }
    }
    
    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        backgroundColor = .clear
        register(CommentContentCell.self, forCellWithReuseIdentifier: "CommentContentCell")
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
extension CommentContentView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentContentCell", for: indexPath) as! CommentContentCell
        let model = comments[indexPath.item]
        cell.imageIV.kf.setImage(with: URL(string: model.avatar_url), placeholder: UIImage(named: "默认头像"))
        cell.titleBtn.setTitle(model.person, for: .normal)
        cell.setContent(model.comment, parent: indexPath.item%2==0 ?nil:"xxx")
        cell.onClick = {[weak self] idx in
            print(idx)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 不能动态设置size
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

class CommentContentCell: UICollectionViewCell {
    lazy var imageIV: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
//        iv.isUserInteractionEnabled = true
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
    
    var onClick: ((Int)->Void)?
    func setContent(_ text: String, parent: String?) {
        contentLb.text = parent == nil ? text : "回复\(parent!)：\(text)"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
            print(text)
            self?.onClick?(2)
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
        print("view click")
        onClick?(0)
    }
    @objc private func click(_ btn: UIButton) {
        print("title click")
        onClick?(1)
    }
    
}

