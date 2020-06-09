//
//  CommentContentView.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/5/11.
//  Copyright © 2020 kilomind. All rights reserved.
//

import Foundation

class CommentContentView: UICollectionView {
    var comments = [CommentInfo]() {
        didSet {
            reloadData()
        }
    }
    weak var actionDelegate: MomentCommentDelegate?
    
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
        cell.comment = model
        cell.onClick = {[weak self] action in
            self?.actionDelegate?.contentDidSelected(model, action: action)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 不能动态设置size
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}
