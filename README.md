## Swift 5.1 高帧率朋友圈实现

> 本文基于**[IGListKit 4.0]([https://github.com/Instagram/IGListKit](https://github.com/Instagram/IGListKit))**实现列表的高帧率滑动效果，项目地址见[GitHub](https://github.com/jeromexiong/cover-moments)

## 话不多说，上图
![ezgif.com-resize.gif](https://upload-images.jianshu.io/upload_images/5677882-4d4fa7da7876da44.gif?imageMogr2/auto-orient/strip)
## 创建基类控制器
所有`IGListKit`的视图控制器都应该继承此类，减少复用
```swift
class BaseListVC: UIViewController {

    var objects: [ListDiffable] = [ListDiffable]()
    
    lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        collectionView.backgroundColor = UIColor.groupTableViewBackground
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

```

## 创建`MomentInfo`模型
```
class MomentInfo {
    var id: Int = 0
    ...
}
extension MomentInfo: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        // 区分是否为同一对象，可多属性叠加
        return id as NSObjectProtocol
    }
    
    // 判断对象是否相同，不同(false)则刷新
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self === object else { return true }
        guard let object = object as? MomentInfo else { return false }
        return id == object.id
    }
}

extension MomentInfo: Equatable {
    static func == (lhs: MomentInfo, rhs: MomentInfo) -> Bool {
        return lhs.isEqual(toDiffableObject: rhs)
    }
}

```

## 子类复写
1. 更新数据
```swift
//info -> MomentInfo的对象
self.objects.append(info)
// 数据添加完成后更新
self.adapter.performUpdates(animated: true, completion: nil)
```
2. 复写绑定Section
```
override func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    // 此object的类型就是更新的self.objects的item类型
    switch object {
    case is MomentInfo:
        // MomentBindingSection 继承自 ListBindingSectionController
        let section = MomentBindingSection()
        return section
    default:
        fatalError()
    }
}
```
## 使用`ListBindingSectionController`绑定多个cell
1. 创建`UICollectionViewCell`⚠️**只能有一种样式布局，不同样式需要不同的cell**
```
class MomentTopCell: UICollectionViewCell {
    ...
}
extension MomentTopCell: ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? MomentInfo else { return }
        // 更新cell数据
    }
}
```
2. 获取cell对象
```
func momentTopCell(at index: Int) -> MomentTopCell {
//  guard let cell = collectionContext?.dequeueReusableCell(withNibName: MomentTopCell.jx_className, bundle: nil, for: self, at: index) as? MomentTopCell else { fatalError() }
    guard let cell = collectionContext?.dequeueReusableCell(of: MomentTopCell.self, for: self, at: index) as? MomentTopCell else { fatalError() }
    // 传入cell数据
    cell.bindViewModel(object!)
    return cell
}
```
3. 绑定视图模型(ViewModel)，可使用枚举替代
```
enum ViewModelEnum: String {
    case top, header, image_single, location, bottom
}
/// 绑定viewmodels，用以区分不同cell
func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
    guard let object = object as? MomentInfo else { return [] }
    var results: [ListDiffable] = []
    if object.userInfo != nil {
        results.append(ViewModelEnum.top.rawValue as ListDiffable)
    }
    if object.images.count == 1 {
        results.append(ViewModelEnum.image_single.rawValue as ListDiffable)
    }else {
        results.append(ViewModelEnum.header.rawValue as ListDiffable)
    }
    if !object.location.isEmpty {
        results.append(ViewModelEnum.location.rawValue as ListDiffable)
    }
    results.append(ViewModelEnum.bottom.rawValue as ListDiffable)
    return results
}

/// 不同viewmodel对应的cell
func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
    let viewModel = ViewModelEnum(rawValue: viewModel as! String)!
    switch viewModel {
    case .top:
        return momentTopCell(at: index)
    case .image_single:
        return momentHeaderImageCell(at: index)
    case .header:
        return momentHeaderCell(at: index)
    case .location:
        return momentLocationCell(at: index)
    case .bottom:
        return momentBottomCell(at: index)
    }
}
/// 不同cell对应的size
func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
    guard let object = object as? MomentInfo else { fatalError() }
    let viewModel = ViewModelEnum(rawValue: viewModel as! String)!
    let width: CGFloat = collectionContext!.containerSize(for: self).width
    switch viewModel {
    case .top:
        return CGSize(width: width, height: 400)
    case .header, .image_single:
        return CGSize(width: width, height: object.cellHeight)
    case .location:
        return CGSize(width: width, height: 30)
    case .bottom:
        return CGSize(width: width, height: 30)
    }
}
```
