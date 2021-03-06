//
//  MainViewController.swift
//  UITools
//
//  Created by jiao qing on 28/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let tableView = UITableView()
    var funcBtns = [UIButton]()
    
    var displayV = UIImageView()
    var slideWindow : SlideWindow?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .None
        
        title = "UI Library"
        
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 64, 0)
        
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.registerClass(FunctionTableCell.self, forCellReuseIdentifier: "FunctionTableCell")
        self.view.addSubview(tableView)
        
        buildOneButton("Camera", sel: #selector(cameraMethod))
        buildOneButton("Share Window", sel: #selector(ShareWindowDidTapped))
        buildOneButton("Scale Move Edit Image", sel: #selector(editImage))
        buildOneButton("Slide Window", sel: #selector(slideWindowDidTapped))
        
        buildOneButton("AlphabetTableView", sel: #selector(alphabetTableView))
        
        buildOneButton("Alert Hint Tips Toast Tutorial", sel: #selector(allTipsDidTapped))
        
        let albumBtn = buildOneButton("Album Operations", sel: #selector(albumOperation))
        albumBtn.addSubview(displayV)
        displayV.frame = CGRectMake(albumBtn.frame.size.width - 60 - 20, -5, 60, 60)
        DJAblumOperation.getAlbumPoster({(img : UIImage?) -> Void in
            self.displayV.image = img
        })
        
        buildOneButton("Photo Browser照片浏览", sel: #selector(photobrowser))
        buildOneButton("WaterfallCollectionView && 下拉刷新 加载", sel: #selector(waterfallCollectionView))
        buildOneButton("Range SliderView", sel: #selector(rangeSliderView))
        
        buildOneButton("ScrollBanner", sel: #selector(scrollBanner))
        buildOneButton("ScrollBanner Timer", sel: #selector(scrollBannerTimer))
        buildOneButton("ScrollCategory", sel: #selector(scrollCategory))
        
        buildOneButton("WaterProgress", sel: #selector(waterProgress))
        
        tableView.reloadData()
    }
    
    func waterProgress(){
        let wp = WaterProgressView(frame: CGRectMake(20, 0, 55, 55))
        wp.setProgress(0.6, animated: true)
        wp.delegate = self
        
        showViewWithContent(wp)
    }
    
    func editImage(){
        self.navigationController?.pushViewController(EditImageViewController(), animated: true)
    }
    
    func cameraMethod(){
        self.navigationController?.pushViewController(CameraViewController(), animated: true)
    }
    
    func alphabetTableView(){
        let alphabetTV = AlphabetTableView(frame : CGRectMake(0, 0, view.frame.size.width, 300))
        alphabetTV.setTheContent(["Abc", "CBC", "Def", "Lpj", "Abc", "CBC", "Def", "Lpj", "Abc", "CBC", "Def", "Lpj", "Typ", "October", "September", "Julyt", "Typ", "October", "September", "Julyt", "Typ", "October", "September", "Julyt"])
        showViewWithContent(alphabetTV)
        
        //  alphabetTV.setContentSelector(self, sel: #selector(didSelectName(_:)))
    }
    
    func slideWindowDidTapped(){
        if slideWindow == nil{
            slideWindow = SlideWindow(frame: UIScreen.mainScreen().bounds)
        }
        slideWindow!.showAnimation()
    }
    
    func scrollCategory(){
        let cateView = ScrollableCategoryView(frame : CGRectMake(0, 0, view.frame.size.width, 45), infos : ["XiaoQing", "JiaoXiaoQing", "Love", "XiaoQing", "God", "XiaoQing", "ArkXiaoQing", "XiaoQing"])
        cateView.scrollToIndex(2)
        
        showViewWithContent(cateView)
    }
    
    func scrollBanner(){
        let scrollView = ScrollableBannerView(frame : CGRectMake(0, 0, view.frame.size.width, 200))
        
        let colours = [UIColor.redColor(), UIColor.purpleColor(), UIColor.blackColor(), UIColor.grayColor()]
        var allviews = [UIView]()
        for one in colours{
            let oneView = UIView(frame : CGRectMake(0, 0, 161, scrollView.frame.size.height))
            allviews.append(oneView)
            oneView.backgroundColor = one
        }
        scrollView.setScrollViews(allviews)
        
        showViewWithContent(scrollView)
    }
    
    func scrollBannerTimer(){
        let scrollView = ScrollableBannerView(frame : CGRectMake(0, 0, view.frame.size.width, 200))
        
        let colours = [UIColor.redColor(), UIColor.purpleColor(), UIColor.blackColor(), UIColor.grayColor()]
        var allviews = [UIView]()
        for one in colours{
            let oneView = UIView(frame : CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height))
            allviews.append(oneView)
            oneView.backgroundColor = one
        }
        scrollView.setScrollViewFull(allviews)
        scrollView.startTimer()
        showViewWithContent(scrollView)
    }
    
    func rangeSliderView(){
        let rangeSilderView = DJRangeSilderView(frame: CGRectMake(0, 0, view.frame.size.width, 60))
        rangeSilderView.rangeValues = [0, 30, 50, 80, 120, 200]
        showViewWithContent(rangeSilderView)
        rangeSilderView.delegate = self
    }
    
    func showViewWithContent(theview : UIView) {
        let conV = UIView(frame : view.bounds)
        conV.backgroundColor = UIColor.whiteColor()
        conV.layer.borderColor = UIColor.grayColor().CGColor
        conV.layer.borderWidth = 0.5
        view.addSubview(conV)
        
        theview.frame = CGRectMake(0, 25, theview.frame.size.width, theview.frame.size.height)
        theview.layer.borderColor = UIColor.blueColor().CGColor
        theview.layer.borderWidth = 1
        
        let closeBtn = UIButton(frame : CGRectMake(0, 0, 60, 20))
        conV.addSubview(closeBtn)
        closeBtn.withTitleColor(UIColor.blackColor()).withFontHeletica(15).withTitle("Close")
        closeBtn.addTarget(self, action: #selector(closeShowView), forControlEvents: .TouchUpInside)
        
        conV.addSubview(theview)
    }
    
    func closeShowView(btn : UIButton){
        if let tmp = btn.superview {
            tmp.removeFromSuperview()
        }
    }
    
    func waterfallCollectionView(){
        self.navigationController?.pushViewController(CollectionViewController(), animated: true)
    }
    
    func photobrowser(){
        let photoB = PhotoBrowser(frame : UIScreen.mainScreen().bounds)
        photoB.resetDimissSelector(self, sel: #selector(handleUDismissPhotoBrowser(_:)))
        
        let imgUrls = ["http://d1h06o39vyn1mi.cloudfront.net/product/detail/full/bc/d2/bcd2101ec2374435559b044b238804258808691b.jpg", "http://d1h06o39vyn1mi.cloudfront.net/product/detail/full/25/5f/255f5562ecbbd49ca7cf83b1de2dfe3e5f490ea6.jpg", "http://d1h06o39vyn1mi.cloudfront.net/product/detail/full/cb/2e/cb2e47ffe739de2e21f08fc3398fa3f64bd2cee6.jpg"];
        photoB.showPhotoBrowser(self, imageUrls: imgUrls, index: 0)
    }
    
    func allTipsDidTapped(){
        self.navigationController?.pushViewController(AllTipsViewController(), animated: true)
    }
    
    func albumOperation(){
        DJAblumOperation.choosePicture(self)
    }
    
    
    func ShareWindowDidTapped(){
        let nailImageURL = "https://3.bp.blogspot.com/-W__wiaHUjwI/Vt3Grd8df0I/AAAAAAAAA78/7xqUNj8ujtY/s1600/image02.png"
        let fbEntry = DJFBShareEntry()
        // fbEntry.delegate = self
        
        let shareEntries = [fbEntry, DJTwitterShareEntry(), DJCopyURLShareEntry(), DJInstagramShareEntry(), DJSaveImageShareEntry(), DJWXShareEntry(), DJWhatsappEntry()]
        
        DJShareWindow.shareWithThumbnail(UIImage(named : "SampleImage"), imageUrl: nailImageURL, title: "A dog", contentText: "A white dog", link: nailImageURL, shortLink: nailImageURL, entries: shareEntries, showInViewController: self, completion: {(entry : DJShareEntry?) -> Void in
            //do whatever you want
            if entry == fbEntry {
                //do it
            }
        })
    }
    
    func handleUDismissPhotoBrowser(index : NSNumber){
        // bannerView.scrollToPage(index.integerValue)
    }
}

extension MainViewController :DJRangeSilderViewDelegate, WaterProgressViewDelegate {
    func rangeValueDidChanged(rangeSliderView: DJRangeSilderView, lowerValue: CGFloat, higherValue: CGFloat) {
        //do something here
    }
    
    func waterProgressViewDidClick(waterProgressView: WaterProgressView!) {
    }
    
}

extension MainViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        if let img = info[UIImagePickerControllerOriginalImage] {
            displayV.image = img as! UIImage
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func buildOneButton(name : String, sel : Selector?) -> UIButton{
        let oneBtn = UIButton(frame:CGRectMake(0, 0, view.frame.size.width, 50))
        oneBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        oneBtn.setTitle(name, forState: .Normal)
        if let tmp = sel{
            oneBtn.addTarget(self, action: tmp, forControlEvents: .TouchUpInside)
        }
        funcBtns.append(oneBtn)
        return oneBtn
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return funcBtns.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FunctionTableCell") as! FunctionTableCell
        let oneBtn = funcBtns[indexPath.row]
        cell.selectionStyle = .None
        cell.setFunctionButton(oneBtn)
        
        return cell
    }
    
}


class FunctionTableCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    func setFunctionButton(btn : UIButton){
        let subViews = self.subviews
        for one in subViews {
            one.removeFromSuperview()
        }
        addSubview(btn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}