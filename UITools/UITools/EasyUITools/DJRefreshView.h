//
//  DJRefreshContainerView.h
//  DejaFashion
//
//  Created by Sunny XiaoQing on 8/10/15.
//  Copyright © 2015 Mozat. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DJRefreshView : UIView
@property (strong, nonatomic) UIImageView *redDot1;
@property (strong, nonatomic) UIImageView *redDot2;
@property (strong, nonatomic) UIImageView *redDot3;
@property (strong, nonatomic) UIColor *dotColor;

-(void)initDotsView:(CGRect)frame;

-(void)initDotsFrame;
-(UIImageView *)createRefreshDot;
-(void)setDotColor:(UIColor *)dotColor;

-(void)startLoadingAnimation;

-(void)resetTransform;
-(void)resetAnimation;

-(void)zeroScaleDots;
-(void)fadeAnimation:(void (^)())completionBegin;
@end