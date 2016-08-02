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
        
        let collectionView = WaterfallCollectionView(frame : view.bounds)
        view.addSubview(collectionView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

}
