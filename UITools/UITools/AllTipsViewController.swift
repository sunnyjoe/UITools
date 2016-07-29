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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "All kinds of tips, toast"
        view.backgroundColor = UIColor.whiteColor()
        
        var oY : CGFloat = 74
        buildOneButton("Simple Short Tips", sel: #selector(tipOneBtnDidClicked), offset: &oY)
        buildOneButton("TutorailWindow", sel: #selector(TutorailWindow), offset: &oY)
    }
    
    func tipOneBtnDidClicked(){
        MBProgressHUD.showHUDAddedTo(view, text: "MBProgressHUD", duration: 1)
    }
    
    func TutorailWindow(){
        window.hollowArea(CGRectMake(100, 118, 190, 44))
        window.makeKeyAndVisible()
    }
    
    
    
    func buildOneButton(name : String, sel : Selector, inout offset : CGFloat) -> UIButton{
        let oneBtn = UIButton(frame:CGRectMake(0, offset, view.frame.size.width, 44))
        oneBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        oneBtn.setTitle(name, forState: .Normal)
        oneBtn.addTarget(self, action: sel, forControlEvents: .TouchUpInside)
        
        offset += 44
        view.addSubview(oneBtn)
        return oneBtn
    }
}
