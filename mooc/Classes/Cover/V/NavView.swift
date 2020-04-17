//
//  NavView.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/16.
//  Copyright © 2020 kilomind. All rights reserved.
//

import Foundation

class NavView: UIView {
    lazy var navView: UIView = {
        let v = UIView(frame: bounds)
        v.backgroundColor = UIColor(r: 239, g: 239, b: 239)
        v.alpha = 0
        return v
    }()
    lazy var navlb: UIView = {
        let lb = UILabel()
        lb.text = "朋友圈"
        lb.alpha = 0
        lb.font = UIFont.boldSystemFont(ofSize: 17)
        lb.textAlignment = .center
        lb.frame = CGRect(x: 0, y: navView.frame.height - 40, width: mScreenW, height: 30)
        return lb
    }()
    lazy var backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "back_w"), for: .normal)
        btn.frame = CGRect(x: 20, y: navView.frame.height - 40, width: 30, height: 30)
        btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        return btn
    }()
    lazy var camareBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "camera_w"), for: .normal)
        btn.frame = CGRect(x: mScreenW - 20 - 30, y: navView.frame.height - 40, width: 30, height: 30)
        btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    var isScrollUp: Bool = false {
        didSet {
            let backImage = isScrollUp ? "back" : "back_w"
            let cameraImage = isScrollUp ? "camera" : "camera_w"
            
            backBtn.setImage(UIImage(named: backImage), for: .normal)
            camareBtn.setImage(UIImage(named: cameraImage), for: .normal)
        }
    }
    var onClick: ((Int)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
fileprivate extension NavView {
    func setup() {
        addSubview(navView)
        addSubview(navlb)
        addSubview(backBtn)
        addSubview(camareBtn)
    }
    @objc func click(_ btn: UIButton) {
        onClick?(btn.tag)
    }
}
