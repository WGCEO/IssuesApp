//
//  IssuesViewController.swift
//  IssuesApp
//
//  Created by changi kim on 2017. 11. 4..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit
import Alamofire

protocol DataSourceRefreshable: class {
    associatedtype Item
    var dataSource: [Item] { get set }
    var needRefreshDataSource: Bool { get set }
}

extension DataSourceRefreshable {
    func setNeedRefreshDataSource(){
        needRefreshDataSource = true
    }
    
    func refreshDataSourceIfNeeded(){
        if needRefreshDataSource {
            dataSource = []
            needRefreshDataSource = false
        }
    }
}

class IssuesViewController: UIViewController, DataSourceRefreshable {
    
    typealias Item = Model.Issue
    
    var needRefreshDataSource: Bool = false
    let refreshControl = UIRefreshControl()
    
    let owner: String = GlobalState.instance.owner
    let repo: String = GlobalState.instance.repo
    var dataSource: [Model.Issue] = []
    fileprivate let estimateCell: IssueCell = IssueCell.cellFromNib

    var page: Int = 1
    var canLoadMore: Bool = true
    var isLoading: Bool = false
    var loadMoreFooterView: LoadMoreFooterView?
    
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

extension IssuesViewController {
    func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "IssueCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "IssueCell")
        collectionView.refreshControl  = refreshControl
        collectionView.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        load()
    }
    
    func load() {
        guard !isLoading else { return }
        isLoading = true
        App.api.repoIssues(owner: owner, repo: repo, page: page) { [weak self] (dataResponse) in
            guard let `self` = self else { return }
            switch dataResponse.result {
            case .success(let items):
                self.isLoading = false
                self.dataLoaded(items: items)
                
            case .failure(_):
                self.isLoading = false
                break
            }
        }
    }
    
    func dataLoaded(items: [Model.Issue]) {
        refreshDataSourceIfNeeded()
        refreshControl.endRefreshing()
        page += 1
        if items.isEmpty {
            canLoadMore = false
            loadMoreFooterView?.loadDone()
        }
        dataSource.append(contentsOf: items)
        collectionView.reloadData()
    }
    
    @objc func refresh() {
        page = 1
        canLoadMore = true
        loadMoreFooterView?.load()
        setNeedRefreshDataSource()
        load()
    }
    
    func loadMore(indexPath: IndexPath) {
        guard indexPath.item == dataSource.count - 1 && isLoading && canLoadMore else { return }
        load()
    }
}

extension IssuesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueCell", for: indexPath) as? IssueCell else { return IssueCell()}
        let data = dataSource[indexPath.item]
        cell.update(date: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "LoadMoreFooterView", for: indexPath)
        return view
    }
}
extension IssuesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = dataSource[indexPath.item]
        estimateCell.update(date: data)
        let targetSize = CGSize(width: collectionView.frame.width, height: 50)
        let estimatedSize = estimateCell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        return estimatedSize
    }
}

extension IssuesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        loadMore(indexPath: indexPath)
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
//        <#code#>
//    }
}
