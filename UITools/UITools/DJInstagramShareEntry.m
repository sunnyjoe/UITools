//
//  DJInstagramShareEntry.m
//  DejaFashion
//
//  Created by Kevin Lin on 10/12/14.
//  Copyright (c) 2014 Mozat. All rights reserved.
//

#import "DJInstagramShareEntry.h"

@interface DJInstagramShareEntry ()

@property (nonatomic, strong) UIDocumentInteractionController *docController;

@end

@implementation DJInstagramShareEntry

- (UIImage *)icon
{
    return [UIImage imageNamed:@"InstagramFollowIcon"];
}

- (void)share:(UIWindow *)window
{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
    if (![[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"Please install Instagram to share."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (self.thumbnail.size.width != self.thumbnail.size.height) {
        float imageSize = self.thumbnail.size.width > self.thumbnail.size.height ? self.thumbnail.size.width : self.thumbnail.size.height;
        CGRect rect = CGRectMake(0, 0, imageSize, imageSize);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextFillRect(ctx,rect);
        [self.thumbnail drawInRect:CGRectMake((imageSize - self.thumbnail.size.width) / 2, (imageSize - self.thumbnail.size.height) / 2,
                                          self.thumbnail.size.width, self.thumbnail.size.height)];
        self.thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    if (self.thumbnail.size.width < 612) {
        CGSize size = CGSizeMake(612, 612);
        UIGraphicsBeginImageContext(size);
        [self.thumbnail drawInRect:CGRectMake(0, 0, size.width, size.height)];
        self.thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    NSString *jpgPath= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/instagram_share.igo"];
    [UIImageJPEGRepresentation(self.thumbnail, 1.0) writeToFile:jpgPath atomically:YES];
    NSURL *imageFileUrl = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@", jpgPath]];
    
    self.docController = [UIDocumentInteractionController interactionControllerWithURL:imageFileUrl];
    self.docController.UTI = @"com.instagram.exclusivegram";
    //    self.docController.annotation = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@(%@) - %@",
    //                                                                        self.title, self.link, self.text]
    self.docController.annotation = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %@",
                                                                        self.contentText, @"Download Deja now! @dejafashion"]
                                                                forKey:@"InstagramCaption"];
    
    UIViewController *topViewController = window.rootViewController;
    if (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    [self.docController presentOpenInMenuFromRect:topViewController.view.bounds
                                           inView:topViewController.view
                                         animated:YES];
}

- (NSString *)name
{
    return @"ins";
}

-(NSString *)labelName{
    return @"Instagram";
}
@end
