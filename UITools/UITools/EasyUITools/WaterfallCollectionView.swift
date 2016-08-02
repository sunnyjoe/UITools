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
}

let kDJPulltoRefreshDistance : CGFloat = 60
let kDJRefreshDotRadius = 7
let kDJRefreshDotMaxScale = 1.3
let kDJDotSpacing = 8
let kDJRefreshScrollViewBottomMargin = 30

class WaterfallCollectionView : UIView {
    private let collectionViewLayout = CHTCollectionViewWaterfallLayout()
    var mainCollectionView : UICollectionView!
    weak var delegate : WaterfallCollectionViewDelegate?
    var items = [UIColor]()
    
    var topRefreshView : DJRefreshView!
    var bottomRefreshView : DJRefreshView!
    var animating = false
    var isLoadingMore = false
    var isPullLoading = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        items = [UIColor.lightGrayColor(), UIColor.purpleColor(), UIColor.redColor(), UIColor.blueColor(), UIColor.defaultRed(), UIColor.grayColor(), UIColor.greenColor(),UIColor.lightGrayColor(), UIColor.purpleColor(), UIColor.redColor(), UIColor.blueColor(), UIColor.defaultRed(), UIColor.grayColor(), UIColor.greenColor(),UIColor.lightGrayColor(), UIColor.purpleColor(), UIColor.redColor(), UIColor.blueColor(), UIColor.defaultRed(), UIColor.grayColor(), UIColor.greenColor(),UIColor.lightGrayColor(), UIColor.purpleColor(), UIColor.redColor(), UIColor.blueColor(), UIColor.defaultRed(), UIColor.grayColor(), UIColor.greenColor(),UIColor.lightGrayColor(), UIColor.purpleColor(), UIColor.redColor(), UIColor.blueColor(), UIColor.defaultRed(), UIColor.grayColor(), UIColor.greenColor()];
        
        mainCollectionView = UICollectionView(frame: bounds, collectionViewLayout: collectionViewLayout)
        mainCollectionView.backgroundColor = UIColor.whiteColor()
        addSubview(mainCollectionView)
        mainCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        
        topRefreshView = DJRefreshView(frame : CGRectMake(0, -kDJPulltoRefreshDistance, frame.size.width, kDJPulltoRefreshDistance))
        addSubview(topRefreshView)
        
        bottomRefreshView = DJRefreshView()
        bottomRefreshView.dotColor = UIColor.grayColor()
        bottomRefreshView.hidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainCollectionView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension WaterfallCollectionView{
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
        
        /*
 
         
         float ty;
         if (scrollView.contentOffset.y > -kDJPulltoRefreshDistance)
         {
         ty = - scrollView.contentOffset.y;
         }else
         {
         ty = kDJPulltoRefreshDistance;
         }
         self.topRefreshView.transform = CGAffineTransformMakeTranslation(0, ty);
         
         float dotDis = kDJRefreshDotRadius + kDJDotSpacing;
         if (scrollView.contentOffset.y >= -kDJPulltoRefreshDistance / 2)
         {
         [self.topRefreshView zeroScaleDots];
         }
         else if (scrollView.contentOffset.y > -kDJPulltoRefreshDistance + 10)
         {
         float scale = MIN(1 - (kDJPulltoRefreshDistance - 10 + scrollView.contentOffset.y) / (kDJPulltoRefreshDistance / 2 - 10), 1);
         //  NSLog(@"scale is %f offset %f", scale, scrollView.contentOffset.y);
         self.topRefreshView.redDot1.transform = CGAffineTransformMakeScale(0, 0);
         self.topRefreshView.redDot2.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
         self.topRefreshView.redDot3.transform = CGAffineTransformMakeScale(0, 0);
         }
         else if (scrollView.contentOffset.y > - kDJPulltoRefreshDistance)
         {
         float dotTx = dotDis * (10 - kDJPulltoRefreshDistance - scrollView.contentOffset.y) / 10;
         self.topRefreshView.redDot1.transform = CGAffineTransformMakeTranslation(dotDis - dotTx, 0);
         self.topRefreshView.redDot2.transform = CGAffineTransformIdentity;
         self.topRefreshView.redDot3.transform = CGAffineTransformMakeTranslation(-dotDis + dotTx, 0);
         }
         else if(scrollView.contentOffset.y <= - kDJPulltoRefreshDistance)
         {
         [self.topRefreshView resetTransform];
         }
         }
         */
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        /*
         if (scrollView.contentOffset.y < - kDJPulltoRefreshDistance && !self.isPullLoading) {
         scrollView.frame = CGRectMake(0, -scrollView.contentOffset.y, scrollView.frame.size.width, scrollView.frame.size.height);
         scrollView.bounces = NO;
         scrollView.contentOffset = CGPointZero;
         
         [self.scrollView.layer removeAllAnimations];
         __weak DJRefreshContainerView *weakSelf = self;
         self.animating = YES;
         [scrollView moveFrom:CGPointMake(0, scrollView.frame.origin.y) to:CGPointMake(0, kDJPulltoRefreshDistance - 4) time:0.2 completion:^(){
         [scrollView moveFrom:CGPointMake(0, scrollView.frame.origin.y) to:CGPointMake(0, kDJPulltoRefreshDistance + 3) time:0.2 completion:^(){
         [weakSelf.scrollView moveFrom:CGPointMake(0, weakSelf.scrollView.frame.origin.y) to:CGPointMake(0, kDJPulltoRefreshDistance) time:0.2 completion:^(){
         weakSelf.scrollView.bounces = YES;
         [weakSelf.topRefreshView startLoadingAnimation];
         self.animating = NO;
         if ([weakSelf.delegate respondsToSelector:@selector(refreshContainerViewPullLoading:)]) {
         [weakSelf.delegate refreshContainerViewPullLoading:weakSelf];
         }
         }];
         }];
         }];
         }
         */
    }
}

extension WaterfallCollectionView : UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if delegate == nil {
            return
        }
        if indexPath.row == items.count - 1{
            if delegate!.respondsToSelector(#selector(WaterfallCollectionViewDelegate.waterfallCollectionViewNeedLoadMore(_:))){
                delegate?.waterfallCollectionViewNeedLoadMore!(self)
            }
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
        return UIEdgeInsetsMake(20, 23, 20, 23)
    }
    
}
