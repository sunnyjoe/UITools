//
//  DJShareEntry.h
//  DejaFashion
//
//  Created by Kevin Lin on 10/12/14.
//  Copyright (c) 2014 Mozat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MBProgressHUD+ShowTextHUD.h"
#import "UIColor+MOAdditions.h"
#import "DJFont.h"

@protocol DJShareEntryDelegate <NSObject>

-(void)sharedCompleted:(BOOL)success;

@end

@interface DJShareEntry : NSObject

@property (weak, nonatomic) id<DJShareEntryDelegate> delegate;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *contentText;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *shortLink;
@property (nonatomic, strong) UIViewController *showInViewController;

- (UIImage *)icon;
- (void)share;
- (void)share:(UIWindow *)window;
- (NSString *)name;
-(NSString *)labelName;
@end
