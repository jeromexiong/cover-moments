//
//  CommentContentView.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/5/11.
//  Copyright © 2020 kilomind. All rights reserved.
//

import Foundation

class CommentContentView: UITableView {
    var comments = [CommentInfo]() {
        didSet {
            reloadData()
        }
    }
    weak var actionDelegate: MomentCommentDelegate?
    
    init(frame: CGRect) {
        super.init(frame: frame, style: .plain)
        delegate = self
        dataSource = self
        backgroundColor = .clear
        separatorColor = UIColor.jx_color(hex: "#F0F0F0")
        separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
extension CommentContentView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(CommentContentCell.self)
        let model = comments[indexPath.item]
        cell.comment = model
        cell.onClick = {[weak self] action in
            self?.actionDelegate?.contentDidSelected(model, action: action)
        }
        cell.onRelativeRect = {[weak self] () -> CGRect in
            guard let self = self, var rect = self.actionDelegate?.commentRect() else {
                return .zero
            }
            var height: CGFloat = 0
            for idx in 0...indexPath.item {
                height += CommentContentCell.getHeight(self.comments[idx])
            }
            rect.origin.y += height
            rect.size.height = 10
            return rect
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = comments[indexPath.item]
        return CommentContentCell.getHeight(model)
    }
}
