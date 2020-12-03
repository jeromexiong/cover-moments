//
//  NineImageView.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/14.
//  Copyright © 2020 kilomind. All rights reserved.
//

import Kingfisher

class NineImageView: UICollectionView {
    var images = [String]() {
        didSet {
            reloadData()
        }
    }
    var isRounds = false
    
    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        backgroundColor = .clear
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    @objc var onPreviewImages: ((IndexPath)->Void)?
}
extension NineImageView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.cell(NineImageViewCell.self, indexPath: indexPath)
        cell.imageIV.kf.setImage(with: URL(string: images[indexPath.item]))
        if isRounds {
            cell.imageIV.layer.cornerRadius = 5
            cell.imageIV.layer.masksToBounds = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 不能动态设置size
        return CGSize(width: mImageW, height: mImageW)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("图片预览\(indexPath)")
        onPreviewImages?(indexPath)
    }
}

class NineImageViewCell: UICollectionViewCell {
    lazy var imageIV: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.autoresizesSubviews = true
        iv.clearsContextBeforeDrawing = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageIV)
        imageIV.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
