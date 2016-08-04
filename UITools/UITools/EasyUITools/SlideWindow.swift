//
//  BrandListWindow.swift
//  DejaFashion
//
//  Created by jiao qing on 23/5/16.
//  Copyright © 2016 Mozat. All rights reserved.
//

import UIKit

class SlideWindow: UIWindow {
    var rightView = UIView()
    var backView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        windowLevel = UIWindowLevelAlert
        
        backView.frame = bounds
        addSubview(backView)
        backView.backgroundColor = UIColor(fromHexString: "272629", alpha: 0.8)
        backView.addTapGestureTarget(self, action: #selector(hideAnimation))
        backView.userInteractionEnabled = true
        
        rightView.frame = CGRectMake(frame.size.width, 0, 255, frame.size.height)
        rightView.backgroundColor = UIColor.defaultBlack()
        addSubview(rightView)
    }
    
    func showAnimation(){
        self.makeKeyAndVisible()
        
        rightView.frame = CGRectMake(frame.size.width, 0, 255, frame.size.height)
        backView.alpha = 0
        
        UIView.animateWithDuration(0.3, animations: {
            self.backView.alpha = 1
            self.rightView.frame = CGRectMake(self.frame.size.width - 255, 0, 255, self.frame.size.height)
        })
    }
    
    func hideAnimation(){
        rightView.frame = CGRectMake(frame.size.width - 255, 0, 255, frame.size.height)
        backView.alpha = 1
        
        UIView.animateWithDuration(0.3, animations: {
            self.backView.alpha = 0
            self.rightView.frame = CGRectMake(self.frame.size.width, 0, 255, self.frame.size.height)
            }, completion: {(Bool) -> Void in
                self.hidden = true
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
