//
//  ProductCollectionView
//  DejaFashion
//
//  Created by jiao qing on 13/4/16.
//  Copyright © 2016 Mozat. All rights reserved.
//

import UIKit

@objc protocol WaterfallCollectionViewDelegate : NSObjectProtocol{
    func waterfallCollectionViewDidSelect(collectionView: WaterfallCollectionView, item : AnyObject)
    optional func waterfallCollectionViewNeedLoadMore(collectionView: WaterfallCollectionView)
    optional func waterfallCollectionViewNeedRefresh(collectionView: WaterfallCollectionView)
}

let kDJPulltoRefreshDistance : CGFloat = 60
let kDJRefreshDotRadius : CGFloat = 7
let kDJRefreshDotMaxScale : CGFloat = 1.3
let kDJDotSpacing : CGFloat = 8
let kDJRefreshScrollViewBottomMargin : CGFloat = 30

class WaterfallCollectionView : UIView {
    private let collectionViewLayout = CHTCollectionViewWaterfallLayout()
    private var mainCollectionView : UICollectionView!
    weak var delegate : WaterfallCollectionViewDelegate?
    var items = [UIColor]()
    
    private var topRefreshView : DJRefreshView!
    private var bottomRefreshView : DJRefreshView!
    private var animating = false
    private var isLoadingMore = false
    private var isPullLoading = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        items = [UIColor.lightGrayColor(), UIColor.purpleColor(), UIColor.redColor(), UIColor.blueColor(), UIColor.defaultRed(), UIColor.grayColor(), UIColor.greenColor(),UIColor.lightGrayColor(), UIColor.purpleColor(), UIColor.redColor(), UIColor.blueColor(), UIColor.defaultRed(), UIColor.grayColor(), UIColor.greenColor(),UIColor.lightGrayColor(), UIColor.purpleColor(), UIColor.redColor(), UIColor.blueColor(), UIColor.defaultRed(), UIColor.grayColor()];
        
        topRefreshView = DJRefreshView(frame : CGRectMake(0, -kDJPulltoRefreshDistance, frame.size.width, kDJPulltoRefreshDistance))
        
        mainCollectionView = UICollectionView(frame: bounds, collectionViewLayout: collectionViewLayout)
        mainCollectionView.backgroundColor = UIColor.whiteColor()
        addSubview(mainCollectionView)
        mainCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.reloadData()
        addSubview(topRefreshView)
        
        bottomRefreshView = DJRefreshView()
        bottomRefreshView.dotColor = UIColor.grayColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(){
        mainCollectionView.reloadData()
    }
}

extension WaterfallCollectionView{
    private func triggerRefresh(){
        if ((self.delegate?.respondsToSelector(#selector(WaterfallCollectionViewDelegate.waterfallCollectionViewNeedRefresh(_:)))) != nil){
            self.delegate?.waterfallCollectionViewNeedRefresh!(self)
        }
    }
    
    private func triggerLoadMore(){
        if delegate!.respondsToSelector(#selector(WaterfallCollectionViewDelegate.waterfallCollectionViewNeedLoadMore(_:))){
            delegate?.waterfallCollectionViewNeedLoadMore!(self)
        }
    }
    
    func setLoadingMore(loading : Bool){
        if isPullLoading || animating || loading == isLoadingMore {
            return
        }
        
        isLoadingMore = loading
        if loading {
            mainCollectionView.addSubview(bottomRefreshView)
            bottomRefreshView.frame = CGRectMake(0, self.mainCollectionView.contentSize.height - kDJPulltoRefreshDistance, self.mainCollectionView.frame.size.width, kDJPulltoRefreshDistance)
            bottomRefreshView.startLoadingAnimation()
        }else{
            bottomRefreshView.removeFromSuperview()
        }
    }
    
    func setPullLoading(loading : Bool){
        if isPullLoading == loading || animating || isLoadingMore{
            return
        }
        
        animating = true
        if loading {
            var offY = mainCollectionView.contentOffset.y
            if offY > -kDJPulltoRefreshDistance {
                offY = -kDJPulltoRefreshDistance
            }
            mainCollectionView.bounces = false
            
            mainCollectionView.contentInset = UIEdgeInsetsMake(-offY, 0, 0, 0)
            mainCollectionView.setContentOffset(CGPointMake(0, -kDJPulltoRefreshDistance), animated: true)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.33)), dispatch_get_main_queue()) {
                self.mainCollectionView.contentInset = UIEdgeInsetsMake(kDJPulltoRefreshDistance, 0, 0, 0)
                self.animating = false
                self.mainCollectionView.bounces = true
                self.topRefreshView.startLoadingAnimation()
                self.isPullLoading = true
                self.triggerRefresh()
            }
        }else{
            topRefreshView.fadeAnimation(nil)
            mainCollectionView.setContentOffset(CGPointZero, animated: true)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.33)), dispatch_get_main_queue()) {
                self.mainCollectionView.contentInset = UIEdgeInsetsZero
                self.animating = false
                self.isPullLoading = false
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isPullLoading || isLoadingMore || animating {
            return
        }
        
        let offY = scrollView.contentOffset.y
        if offY >= 0 {
            return
        }
        
        var ty = kDJPulltoRefreshDistance
        if offY > -kDJPulltoRefreshDistance {
            ty = -offY
        }
        topRefreshView.transform = CGAffineTransformMakeTranslation(0, ty)
        
        let dotDis = kDJRefreshDotRadius + kDJDotSpacing
        if offY >= -kDJPulltoRefreshDistance / 2 {
            topRefreshView.zeroScaleDots()
        }else if offY > -kDJPulltoRefreshDistance + 10 {
            let scale = min(1 - (kDJPulltoRefreshDistance - 10 + offY) / (kDJPulltoRefreshDistance / 2 - 10), 1)
            topRefreshView.redDot1.transform = CGAffineTransformMakeScale(0, 0)
            topRefreshView.redDot2.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale)
            topRefreshView.redDot3.transform = CGAffineTransformMakeScale(0, 0)
        }else if offY > -kDJPulltoRefreshDistance {
            let dotTx = dotDis * (10 - kDJPulltoRefreshDistance - offY) / 10
            self.topRefreshView.redDot1.transform = CGAffineTransformMakeTranslation(dotDis - dotTx, 0)
            self.topRefreshView.redDot2.transform = CGAffineTransformIdentity;
            self.topRefreshView.redDot3.transform = CGAffineTransformMakeTranslation(-dotDis + dotTx, 0)
        }else if offY <= -kDJPulltoRefreshDistance {
            topRefreshView.resetTransform()
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offY = scrollView.contentOffset.y
        if offY > -kDJPulltoRefreshDistance || isPullLoading {
            return
        }
        
        setPullLoading(true)
    }
}

extension WaterfallCollectionView : UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == items.count - 1{
            triggerLoadMore()
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath)
        cell.backgroundColor = items[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let pdt = items[indexPath.row]
        delegate?.waterfallCollectionViewDidSelect(self, item: pdt)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // let clothSummary = items[indexPath.row]
        let width = (frame.width - 15 - 23 * 2) / 2
        if indexPath.row % 3 == 0 {
            return CGSizeMake(width, 150)
        }else{
            return CGSizeMake(width, 190)
        }
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, minimumColumnSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20, 20, kDJPulltoRefreshDistance, 20)
    }
    
}
