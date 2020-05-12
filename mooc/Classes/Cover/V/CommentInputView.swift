//
//  CommentInputView.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/5/12.
//  Copyright © 2020 kilomind. All rights reserved.
//

import Foundation

class CommentInputView: UIView {
    fileprivate(set) lazy var contentView: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: mScreenH, width: mScreenW, height: contentMinHeight)
        v.backgroundColor = .groupTableViewBackground
        
        let layer = CALayer()
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: mScreenW, height: 0.5)
        v.layer.addSublayer(layer)
        return v
    }()
    /// 容器的最小高度
    fileprivate let contentMinHeight: CGFloat = 50
    /// 容器最大高度
    fileprivate let contentMaxHeight: CGFloat = 120
    /// 容器减去输入框的高度
    fileprivate let surplusHeight: CGFloat = 15
    /// // 记录上一次容器高度
    fileprivate var previousCtHeight: CGFloat = 0
    /// 记录容器高度
    fileprivate var ctHeight: CGFloat = 0
    fileprivate(set) var keyboardHeight: CGFloat = 0
    /// 容器高度
    fileprivate(set) var ctTop: CGFloat = 0 {
        didSet {
            self.onTopChanged?(ctTop)
        }
    }
    /// 容器高度变化通知
    var onTopChanged: ((CGFloat)->Void)?
    fileprivate(set) lazy var textView: JXTextView = {
        let tv = JXTextView()
        tv.backgroundColor = .white
        tv.textColor = mBlackColor
        tv.placeholder = "评论"
        tv.returnKeyType = .send
        tv.enablesReturnKeyAutomatically = true
        tv.showsVerticalScrollIndicator = false
        tv.showsHorizontalScrollIndicator = false
        tv.layer.cornerRadius = 4
        tv.layer.masksToBounds = true
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.frame = CGRect(x: 15, y: surplusHeight/2, width: mScreenW-30, height: contentMinHeight-surplusHeight)
        return tv
    }()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        setup()
    }
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        textView.becomeFirstResponder()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentPoint = touches.first?.location(in: superview) else {
            return
        }
        if !contentView.frame.contains(currentPoint) {
            textView.resignFirstResponder()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 滚动collectionview
    /// - Parameter relative: 相对于底部的视图
    func scrollForComment(_ relative: UIView) {
        /// 当前view相对于Windows的坐标
        let rect = relative.convert(relative.bounds, to: UIApplication.shared.keyWindow)
        if keyboardHeight > 0 {
            let delta = ctTop - rect.maxY
            NotificationCenter.default.post(name: NSNotification.Name.list.contentOffset, object: delta)
//            let offsetY = self.collectionView.contentOffset.y - delta
//            self.collectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
        }
    }
}

fileprivate extension CommentInputView {
    func setup() {
        addSubview(contentView)
        contentView.addSubview(textView)
        
        textView.onKeyAction = {[weak self] action in
            guard let `self` = self else {
                return
            }
            switch action {
            case .keyboard(let rect, let duration):
                self.updateTop(rect: rect, duration: duration)
            case .change(_):
                self.updateHeight(self.textView.autoHeight)
            case .done:
                print("done")
            default:
                break
            }
        }
    }
    func updateTop(rect: CGRect, duration: Double) {
        var keyboardH: CGFloat = 0
        if rect.origin.y == UIScreen.main.bounds.height {
            keyboardH = 0
        } else {
            keyboardH = rect.size.height
        }
        keyboardHeight = keyboardH
        // 容器的top
        var top: CGFloat = 0
        if keyboardH > 0 {
            top = mScreenH - contentView.frame.height - keyboardHeight
        } else {
            top = mScreenH
        }
        if ctTop == top { return }
        ctTop = top
        
        UIView.animate(withDuration: duration, animations: {
            self.contentView.frame.origin.y = top
        }) { finished in
            if keyboardH == 0 {
                self.textView.text = nil
                self.updateHeight(self.textView.autoHeight)
                self.removeFromSuperview()
            }
        }
    }
    func updateHeight(_ height: CGFloat) {
        var ctHeight = height + surplusHeight
        if ctHeight < contentMinHeight || textView.text.count == 0 {
            ctHeight = contentMinHeight
        }
        if ctHeight > contentMaxHeight {
            ctHeight = contentMaxHeight
        }
        if ctHeight == previousCtHeight {
            return
        }
        previousCtHeight = ctHeight
        self.ctHeight = ctHeight
        ctTop = mScreenH - ctHeight - keyboardHeight
        
        UIView.animate(withDuration: 0.25) {
            self.contentView.frame.size.height = ctHeight
            self.contentView.frame.origin.y = self.ctTop
            
            self.textView.frame.size.height = ctHeight - self.surplusHeight
            
        }
    }
}
