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
    deinit {
        print("deinit")
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

public extension UITableView {
    /// 获取当前`cell`实例
    func cell<T>(_ cellClass: T.Type, reuseIdentifier: String? = nil, fromNib: Bool = false) -> T where T : UITableViewCell {
        let identifier = reuseIdentifier ?? cellClass.jx_className
        var cell = dequeueReusableCell(withIdentifier: identifier) as? T
        if cell == nil {
            if fromNib {
                cell = Bundle.main.loadNibNamed(cellClass.jx_className, owner: self
                                                , options: nil)?.last as? T
            }else {
                cell = T(style: .default, reuseIdentifier: identifier)
            }
        }
        return cell!
    }
}
public extension UICollectionView {
    /// 获取当前`cell`实例
    func cell<T>(_ cellClass: T.Type, indexPath: IndexPath, reuseIdentifier: String? = nil, fromNib: Bool = false) -> T where T : UICollectionViewCell {
        let identifier = reuseIdentifier ?? cellClass.jx_className
        if fromNib {
            register(UINib(nibName: cellClass.jx_className, bundle: nil), forCellWithReuseIdentifier: identifier)
        }else {
            register(cellClass, forCellWithReuseIdentifier: identifier)
        }
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}

