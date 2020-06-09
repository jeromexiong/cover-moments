//
//  MomentsVC.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/14.
//  Copyright © 2020 kilomind. All rights reserved.
//

import SwiftyJSON

class MomentsVC: BaseListVC {
    fileprivate lazy var navView: NavView = {
        let v = NavView(frame: CGRect(x: 0, y: 0, width: mScreenW, height: mTopHeight))
        v.onClick = {[weak self] tag in
            guard let `self` = self else { return }
            if tag == 0 {
                self.dismiss(animated: true, completion: nil)
            }
        }
        return v
    }()
    fileprivate var contentOffsetY: CGFloat = 0
    fileprivate var publish: NSObjectProtocol?
    fileprivate var location: NSObjectProtocol?
    fileprivate var delete: NSObjectProtocol?
    fileprivate var contentOffset: NSObjectProtocol?
    fileprivate var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adapter.scrollViewDelegate = self
        view.addSubview(navView)
        
        loadData()
        addRefresh()
        notification()
    }
    
    override func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is MomentInfo:
            let section = MomentBindingSection()
            return section
        default:
            fatalError()
        }
    }
    
    func addRefresh() {
        collectionView.mj_header = MomentHeaderRefreshView(refreshingBlock: {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.collectionView.mj_header?.endRefreshing()
            }
        })
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.loadData("data2")
                self?.collectionView.mj_footer?.endRefreshing()
            }
        })
    }
    func loadData(_ resource: String = "data1") {
        do {
            let url = Bundle.main.url(forResource: resource, withExtension: "json")!
            let jsons = try JSON(data: Data(contentsOf: url))
            for (_, sub) in jsons {
                let info = MomentInfo(sub)
                info.id = Int(arc4random_uniform(255))
                self.objects.append(info)
            }
            adapter.performUpdates(animated: true, completion: nil)
        } catch {
            print("decode failure")
        }
    }
}
fileprivate extension MomentsVC {
    func notification() {
        publish = NotificationCenter.default.addObserver(forName: NSNotification.Name.list.publish, object: nil, queue: OperationQueue.main) {[weak self] (noti) in
            self?.loadData()
        }
        location = NotificationCenter.default.addObserver(forName: NSNotification.Name.list.location, object: nil, queue: OperationQueue.main) {[weak self] (noti) in
            guard let object = noti.object as? MomentInfo, let self = self else {
                return
            }
            print("click location", object)
        }
        delete = NotificationCenter.default.addObserver(forName: Notification.Name.list.delete, object: nil, queue: OperationQueue.main) {[weak self] (noti) in
            guard let object = noti.object as? MomentInfo, let self = self else {
                return
            }
            self.objects.removeAll { (element) -> Bool in
                guard let ele = element as? MomentInfo else {
                    return false
                }
                return ele.id == object.id
            }
            self.adapter.performUpdates(animated: true, completion: nil)
        }
        contentOffset = NotificationCenter.default.addObserver(forName: NSNotification.Name.list.contentOffset, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in
            guard let delta = noti.object as? CGFloat, let self = self else {
                return
            }
            let offsetY = self.collectionView.contentOffset.y - delta
            self.collectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
        })
    }
}
extension MomentsVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentOffsetY = scrollView.contentOffset.y

        navView.navView.alpha = contentOffsetY / 150
        navView.navlb.alpha = contentOffsetY / 150

        if contentOffsetY / 150 > 0.6 {
            navView.isScrollUp = true
        } else {
            navView.isScrollUp = false
        }
    }
}

extension Notification.Name {
    struct list {
        /// 发布通知
        static let publish = Notification.Name("list-publish")
        /// 删除通知
        static let delete = Notification.Name("list-delete")
        /// 定位通知
        static let location = Notification.Name("list-location")
        /// collectionview的评论列表定位到当前通知
        static let contentOffset = Notification.Name("list-contentOffset")
    }
}
