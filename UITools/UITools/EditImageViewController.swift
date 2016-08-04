//
//  EditImageViewController.swift
//  UITools
//
//  Created by jiao qing on 4/8/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class EditImageViewController: UIViewController {
    let selectedView = DJScaleMoveView()
    let maskView = UIImageView()
    let bottomView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(selectedView)
        
        selectedView.resetImage(UIImage(named: "DemoImage"))
        selectedView.maskRect = CGRectMake(100, 150, view.frame.size.width - 200, view.frame.size.height - 300)
        
        view.addSubview(maskView)
        maskView.image = UIImage(named: "PatternTemplate")
        
        view.addSubview(bottomView)
        bottomView.backgroundColor = UIColor.defaultBlack()
 
        let doneBtn = UIButton()
        doneBtn.withTitle("Done").withFontHeleticaMedium(15).withTitleColor(UIColor(fromHexString: "f1f1f1"))
        doneBtn.addTarget(self, action: #selector(doneBtnDidTapped), forControlEvents: .TouchUpInside)
        bottomView.addSubview(doneBtn)
        doneBtn.sizeToFit()
        doneBtn.frame = CGRectMake(view.frame.size.width / 2 - doneBtn.frame.size.width / 2, 60 / 2 - doneBtn.frame.size.height / 2, doneBtn.frame.size.width, doneBtn.frame.size.height)
        
        let cancelBtn = UIButton(frame : CGRectMake(view.frame.size.width - 50 - 15, 0, 50, 60))
        cancelBtn.withTitle("Cancel").withFontHeleticaMedium(15).withTitleColor(UIColor(fromHexString: "f1f1f1"))
        cancelBtn.addTarget(self, action: #selector(cancelBtnDidTapped), forControlEvents: .TouchUpInside)
        bottomView.addSubview(cancelBtn)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        selectedView.frame = view.bounds
        maskView.frame = view.bounds
        bottomView.frame = CGRectMake(0, view.frame.size.height - 60, view.frame.size.width, 60)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBarHidden = false
    }
    
    func cancelBtnDidTapped() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func doneBtnDidTapped(){
        let croppedImage = selectedView.clipImageWithImage(UIImage(named: "PatternCrop"))
        DJAblumOperation.saveImageToAlbum(croppedImage)
        MBProgressHUD.showHUDAddedTo(view, text: "Saved to ablum", animated: true)
    }
}
