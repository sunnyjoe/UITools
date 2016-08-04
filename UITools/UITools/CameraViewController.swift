//
//  CameraViewController.swift
//  UITools
//
//  Created by jiao qing on 4/8/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    private let cameraView = CameraView()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(cameraView)
        cameraView.switchCamera(true)
        
        let bottomView = UIView(frame : CGRectMake(0, view.frame.size.height - 92.5, view.frame.size.width, 92.5))
        view.addSubview(bottomView)
        bottomView.backgroundColor = UIColor.defaultBlack()
        
        let captureBtn = UIButton(frame : CGRectMake((bottomView.frame.size.width - 61) / 2, (bottomView.frame.size.height - 61) / 2, 61, 61))
        captureBtn.setImage(UIImage(named: "BigWhiteCamera"), forState: .Normal)
        captureBtn.addTarget(self, action: #selector(takePhotoDidPressed), forControlEvents: .TouchUpInside)
        bottomView.addSubview(captureBtn)
        
        let cancelBtn = UIButton(frame : CGRectMake(bottomView.frame.size.width - 50 - 15, 0, 50, bottomView.frame.size.height))
        cancelBtn.withTitle("Cancel").withFontHeleticaMedium(15).withTitleColor(UIColor(fromHexString: "f1f1f1"))
        cancelBtn.addTarget(self, action: #selector(cancelBtnDidTapped), forControlEvents: .TouchUpInside)
        bottomView.addSubview(cancelBtn)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        cameraView.frame = view.bounds
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
    
    func takePhotoDidPressed(){
        let afterCapture = {
            if let theImage = self.cameraView.capturedImage {
                DJAblumOperation.saveImageToAlbum(theImage)
                // or do someting else
            }else{
                
            }
            self.cameraView.switchCamera(false)
        }
        cameraView.capturePhoto(afterCapture)
    }
 

}
