//
//  DJTwitterShareEntry.m
//  DejaFashion
//
//  Created by Kevin Lin on 10/12/14.
//  Copyright (c) 2014 Mozat. All rights reserved.
//

#import "DJTwitterShareEntry.h"
#import <Social/Social.h>

@implementation DJTwitterShareEntry

- (UIImage *)icon
{
    return [UIImage imageNamed:@"TwitterFollowIcon"];
}


- (void)share:(UIWindow *)window
{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"Please install and login Twitter to share."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
        return;
    }
    
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controller setInitialText:[NSString stringWithFormat:@"%@", self.contentText]];
    [controller addURL:[NSURL URLWithString:self.link]];
    [controller addImage:self.thumbnail];
    
    UIViewController *topViewController = window.rootViewController;
    if (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    __weak UIView *weakView = topViewController.view;
    controller.completionHandler = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultDone) {
            if (weakView) {
                [MBProgressHUD showHUDAddedTo:weakView text:@"Shared Successfully" animated:YES];
                
                if ([self.delegate respondsToSelector:@selector(sharedCompleted:)]) {
                    [self.delegate sharedCompleted:YES];
                }
            }
        }
    };
    [topViewController presentViewController:controller animated:YES completion:nil];
    
}

- (NSString *)name
{
    return @"tw";
}

-(NSString *)labelName{
    return @"Twitter";
}

@end
