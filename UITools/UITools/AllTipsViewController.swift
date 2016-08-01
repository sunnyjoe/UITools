//
//  AllTipsViewController.swift
//  UITools
//
//  Created by jiao qing on 29/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class AllTipsViewController: UIViewController {
    let window = TutorialWindow()
    var oY : CGFloat = 74
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "All kinds of tips, toast"
        view.backgroundColor = UIColor.whiteColor()
        
        buildOneButton("Simple Short Tips", sel: #selector(tipOneBtnDidClicked))
        buildOneButton("TutorailWindow", sel: #selector(TutorailWindow))
        buildOneButton("BannerTips", sel: #selector(bannerTip))
        buildOneButton("BannerSlidDownTips", sel: #selector(bannerSlideDownTip))
        buildOneButton("Drow Menu", sel: #selector(drowMenuFunc))
    }
    
    func drowMenuFunc(){
        let directorView = DropMenuView(menus:["Function1", "Function2", "Function3"])
        if directorView.superview != nil{
            directorView.hideAnimation()
            return
        }
        directorView.delegate = self
        
        if let nv = self.navigationController{
            nv.view.addSubview(directorView)
        }else{
            view.addSubview(directorView)
        }
        
        directorView.showAnimation()
    }

    func tipOneBtnDidClicked(){
        MBProgressHUD.showHUDAddedTo(view, text: "MBProgressHUD", duration: 1)
    }
    
    func TutorailWindow(){
        window.hollowArea(CGRectMake(100, 118, 190, 44))
        window.makeKeyAndVisible()
    }
    
    func bannerSlideDownTip(){
        UITips.showSlideDownTip("bannerSlideDownTip", icon: UIImage(named:"Speaker"), duration: 2, offsetY: 64, insideParentView: self.view)
    }
    
    func bannerTip(){
        UITips.showTip("bannerTip appear", icon: UIImage(named:"Speaker"), duration: 2, offsetY: 64, insideParentView: self.view)
    }
    
    func buildOneButton(name : String, sel : Selector) -> UIButton{
        let oneBtn = UIButton(frame:CGRectMake(0, oY, view.frame.size.width, 44))
        oneBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        oneBtn.setTitle(name, forState: .Normal)
        oneBtn.addTarget(self, action: sel, forControlEvents: .TouchUpInside)
        
        oY += 44
        view.addSubview(oneBtn)
        return oneBtn
    }
}

extension AllTipsViewController : DropMenuViewDelegate{
    func dropMenuViewDidClickIndex(dropMenuView: DropMenuView, index : Int){
        dropMenuView.removeFromSuperview()
    }
    
}
