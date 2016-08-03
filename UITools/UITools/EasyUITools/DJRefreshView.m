//
//  DJRefreshContainerView.m
//  DejaFashion
//
//  Created by Sunny XiaoQing on 8/10/15.
//  Copyright © 2015 Mozat. All rights reserved.
//

#import "DJRefreshView.h"
#import "UIView+Mozat.h"
#import "UIView+DJAnimation.h"

static float kDJRefreshDotRadius = 7;
static float kDJRefreshDotMaxScale = 1.3;
static float kDJDotSpacing = 8;


@implementation DJRefreshView
-(instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initDotsView:frame];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self initDotsFrame];
}

-(void)initDotsView:(CGRect)frame{
    self.redDot1 = [self createRefreshDot];
    self.redDot2 = [self createRefreshDot];
    self.redDot3 = [self createRefreshDot];
    
    [self initDotsFrame];
}
 
-(void)initDotsFrame{
    self.redDot1.frame = CGRectMake(self.frame.size.width / 2 - kDJRefreshDotRadius * 3 / 2 - kDJDotSpacing, self.frame.size.height / 2, kDJRefreshDotRadius, kDJRefreshDotRadius);
    self.redDot2.frame = CGRectMake(self.frame.size.width / 2 - kDJRefreshDotRadius / 2, self.frame.size.height / 2, kDJRefreshDotRadius, kDJRefreshDotRadius);
    self.redDot3.frame = CGRectMake(self.frame.size.width / 2 + kDJRefreshDotRadius / 2 + kDJDotSpacing, self.frame.size.height / 2, kDJRefreshDotRadius, kDJRefreshDotRadius);
}

-(UIImageView *)createRefreshDot{
    UIImageView * redDot = [UIImageView new];
    redDot.backgroundColor = self.dotColor?: [UIColor redColor];
    redDot.layer.cornerRadius = kDJRefreshDotRadius / 2;
    [self addSubview:redDot];
    
    return redDot;
}

-(void)setDotColor:(UIColor *)dotColor{
    _dotColor = dotColor;
    
    [self removeAllSubViews];
    [self initDotsView:self.frame];
}

-(void)startLoadingAnimation{
    [self resetAnimation];
    [self resetTransform];
    [self initDotsFrame];
    float duration = 0.3;
    CGAffineTransform scale = CGAffineTransformMakeScale(kDJRefreshDotMaxScale, kDJRefreshDotMaxScale);
    [UIView animateKeyframesWithDuration:duration delay:0.0 options:UIViewKeyframeAnimationOptionAutoreverse |UIViewAnimationOptionCurveEaseInOut | UIViewKeyframeAnimationOptionRepeat animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1 animations:^{
            self.redDot1.transform = scale;
        }];
    } completion:nil];
    
    [UIView animateKeyframesWithDuration:duration delay:(duration / 2) options:UIViewKeyframeAnimationOptionAutoreverse|UIViewAnimationOptionCurveEaseInOut | UIViewKeyframeAnimationOptionRepeat animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1 animations:^{
            self.redDot2.transform = scale;
        }];
    } completion:nil];
    
    [UIView animateKeyframesWithDuration:duration delay:duration options:UIViewKeyframeAnimationOptionAutoreverse|UIViewAnimationOptionCurveEaseInOut | UIViewKeyframeAnimationOptionRepeat animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1 animations:^{
            self.redDot3.transform = scale;
        }];
    } completion:nil];
}

-(void)resetTransform{
    self.redDot1.transform = CGAffineTransformIdentity;
    self.redDot2.transform = CGAffineTransformIdentity;
    self.redDot3.transform = CGAffineTransformIdentity;
}

-(void)resetAnimation{
    [self.redDot1.layer removeAllAnimations];
    [self.redDot2.layer removeAllAnimations];
    [self.redDot3.layer removeAllAnimations];
}

-(void)zeroScaleDots{
    self.redDot1.transform = CGAffineTransformMakeScale(0, 0);
    self.redDot2.transform = CGAffineTransformMakeScale(0, 0);
    self.redDot3.transform = CGAffineTransformMakeScale(0, 0);
}

-(void)fadeAnimation:(void (^)())completionBegin{
    [self resetAnimation];
    [self resetTransform];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(){
        self.redDot1.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL completion){
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(){
            self.redDot2.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL completion){
            [UIView animateWithDuration:0.1  delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(){
                self.redDot3.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL completion){
                if (completionBegin) {
                    completionBegin();
                    [self resetAnimation];
                    [self resetTransform];
                }
            }];
        }];
    }];
}
@end

