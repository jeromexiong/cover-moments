//
//  JXActionSheet.swift
//
//  Created by Jerome Xiong on 2020/4/28.
//  Copyright © 2020 kilomind. All rights reserved.
//

import UIKit

fileprivate let kScreenW = UIScreen.main.bounds.width
fileprivate let kScreenH = UIScreen.main.bounds.height
fileprivate let animationDuration: TimeInterval = 0.25
fileprivate let cornerRadius: CGFloat = 10
fileprivate let bgAlpha: CGFloat = 0.6
fileprivate let rowHeight: CGFloat = 50
fileprivate let separatorH: CGFloat = 5
fileprivate let textColor: UIColor = mBlackColor
fileprivate let separatorColor: UIColor = .groupTableViewBackground
fileprivate let textFont: UIFont = UIFont.systemFont(ofSize: 16)
fileprivate let bottomIndent: CGFloat = mBottomIndent

/// 仿微信ActionSheet
class JXActionSheet: UIView {
    struct Model {
        let title: String
        let subtitle: String = ""
    }
    static func show(_ data: [JXActionSheet.Model], completed: ((Int)->Void)?) {
        if data.count == 0 {
            return
        }
        let v = JXActionSheet(data, completed: completed)
        
        UIApplication.shared.delegate?.window!!.addSubview(v)
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {[unowned v] in
            v.contentView.frame.origin.y = kScreenH - v.contentHeight
            v.backgroundColor = UIColor.black.withAlphaComponent(bgAlpha)
        })
    }
    
    fileprivate lazy var contentView: UIView = {
        let frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: 0)
        let view = UIView(frame: frame)
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.frame = CGRect(x: 0, y: 0, width: kScreenW, height: rowHeight)
        cancelBtn.titleLabel?.textAlignment = .center
        cancelBtn.titleLabel?.font = textFont
        cancelBtn.setTitleColor(textColor, for: .normal)
        cancelBtn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        return cancelBtn
    }()
    fileprivate lazy var separatorView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: separatorH))
        view.backgroundColor = separatorColor
        return view
    }()
    
    fileprivate var completed: ((Int)->Void)?
    fileprivate(set) var dataArr = [Model]()
    fileprivate(set) var contentHeight: CGFloat = 0
    init(_ data: [JXActionSheet.Model], completed: ((Int)->Void)?) {
        super.init(frame: UIScreen.main.bounds)
        self.completed = completed
        dataArr = data
        if data.count == 0 { return }
        
        contentHeight = CGFloat(data.count+1) * rowHeight + separatorH + bottomIndent
        contentView.frame.size.height = contentHeight
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func hide() {
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {[unowned self] in
            self.contentView.frame.origin.y = kScreenH
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}
private extension JXActionSheet {
    func setup() {
        backgroundColor = .clear
        let ges = UITapGestureRecognizer(target: self, action: #selector(hide))
        addGestureRecognizer(ges)
        addSubview(contentView)
        
        for (idx, model) in dataArr.enumerated() {
            let frame = CGRect(x: 0, y: CGFloat(idx) * rowHeight, width: kScreenW, height: rowHeight)
            let btn = createBtn(frame, title: model.title)
            btn.tag = idx + 1
            contentView.addSubview(btn)
        }
        let maxY = contentView.subviews.last!.frame.maxY
        
        contentView.addSubview(separatorView)
        contentView.addSubview(cancelBtn)
        separatorView.frame.origin.y = maxY
        cancelBtn.frame.origin.y = separatorView.frame.maxY
    }
    func createBtn(_ frame: CGRect, title: String) -> UIButton {
        let actionBtn = UIButton(type: .custom)
        actionBtn.frame = frame
        actionBtn.titleLabel?.font = textFont
        actionBtn.titleLabel?.textAlignment = .center
        actionBtn.backgroundColor = .clear
        actionBtn.setTitle(title, for: .normal)
        actionBtn.setTitleColor(textColor, for: .normal)
        actionBtn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        
        let divider = UIView(frame: CGRect(x: 0, y: frame.height-1, width: frame.width, height: 1))
        divider.backgroundColor = separatorColor
        actionBtn.addSubview(divider)
        
        return actionBtn
    }
    @objc func click(_ btn: UIButton) {
        completed?(btn.tag)
        hide()
    }
}
