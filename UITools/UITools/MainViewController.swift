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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .None
        
        title = "UI Library"
        
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0)
        
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(FunctionTableCell.self, forCellReuseIdentifier: "FunctionTableCell")
        self.view.addSubview(tableView)
        
        
        buildOneButton("Share Window", sel: #selector(ShareWindowDidTapped))
        buildOneButton("Alert Hint Tips Toast Tutorial", sel: #selector(allTipsDidTapped))
        
        let albumBtn = buildOneButton("Album Operations", sel: #selector(albumOperation))
        albumBtn.addSubview(displayV)
        displayV.frame = CGRectMake(albumBtn.frame.size.width - 60 - 20, -5, 60, 60)
        DJAblumOperation.getAlbumPoster({(img : UIImage?) -> Void in
            self.displayV.image = img
        })
    
        
        tableView.reloadData()
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