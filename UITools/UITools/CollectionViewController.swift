//
//  CollectionViewController.swift
//  UITools
//
//  Created by jiao qing on 2/8/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = .None
        
        title = "WaterfallCollectionView"
        
        let collectionView = WaterfallCollectionView(frame : CGRectMake(0, 0, view.frame.size.width, UIScreen.mainScreen().bounds.size.height - 64))
        collectionView.delegate = self
        view.addSubview(collectionView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

}

extension CollectionViewController : WaterfallCollectionViewDelegate {
    func waterfallCollectionViewNeedRefresh(collectionView: WaterfallCollectionView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 2)), dispatch_get_main_queue()) {
            collectionView.setPullLoading(false)
        }
    }
    
    func waterfallCollectionViewNeedLoadMore(collectionView: WaterfallCollectionView) {
        collectionView.setLoadingMore(true)
        collectionView.items.appendContentsOf([UIColor.brownColor(), UIColor.redColor(), UIColor.darkGrayColor()])
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 3)), dispatch_get_main_queue()) {
            collectionView.reloadData()
            collectionView.setLoadingMore(false)
        }
    }
    
    func waterfallCollectionViewDidSelect(collectionView: WaterfallCollectionView, item: AnyObject) {
        
    }
}