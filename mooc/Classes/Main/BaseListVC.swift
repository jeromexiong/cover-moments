//
//  BaseListVC.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/14.
//  Copyright © 2020 kilomind. All rights reserved.
//

import Foundation

class BaseListVC: UIViewController {
    fileprivate lazy var fpsLb: V2FPSLabel = {
        let lb = V2FPSLabel()
        lb.frame = CGRect(x: self.view.frame.maxX-70, y: self.view.frame.midY-15, width: 60, height: 30)
        return lb
    }()
    var objects: [ListDiffable] = [ListDiffable]()
    
    lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        return adapter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        view.addSubview(fpsLb)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension BaseListVC : ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        // 无数据时collectionView的展示
        return nil
    }
}
