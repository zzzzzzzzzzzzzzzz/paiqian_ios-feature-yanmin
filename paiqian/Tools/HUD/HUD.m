//
//  HUD.m
//  ZHFilterCamera
//
//  Created by 360 on 13-9-25.
//  Copyright (c) 2013年 nvshengpai. All rights reserved.
//

#import "HUD.h"

@implementation HUD
@synthesize myHud;
@synthesize isShowing;

- (id)init{
    
    if (self = [super init]) {
        
    }
    return self;
}

+ (HUD*)sharedHUD{

    static dispatch_once_t once;
    static HUD* instance;
    dispatch_once(&once, ^ {
        instance = [[HUD alloc] init];
    });
    return instance;

}

- (void)showHUDWithView:(UIView*)view Mode:(MBProgressHUDMode)mode Title:(NSString*)title{
    if (isShowing) {
        [self hideHUD];
    }
    myHud = [[MBProgressHUD alloc]initWithView:view];
    [view addSubview:myHud];
    myHud.mode = mode;
    myHud.margin = 20;
    myHud.labelText = title;
    myHud.delegate = self;
    [myHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    isShowing = YES;
}

- (void)showHUDNeverAutoHide:(UIView*)view Mode:(MBProgressHUDMode)mode Title:(NSString*)title{
    if (isShowing) {
        [self hideHUD];
    }
    myHud = [[MBProgressHUD alloc]initWithView:view];
    [view addSubview:myHud];
    myHud.mode = mode;
    myHud.margin = 20;
    myHud.labelText = title;
    myHud.delegate = self;
    [myHud show:YES];
    isShowing = YES;
}

- (void)showHUDWithView:(UIView*)view mode:(MBProgressHUDMode)mode Title:(NSString*)title delayHiden:(int)delay{

    if (isShowing) {
        [self hideHUD];
    }
    myHud = [[MBProgressHUD alloc]initWithView:view];
    [view addSubview:myHud];
    myHud.mode = mode;
    myHud.margin = 20;
    myHud.labelText = title;
    myHud.delegate = self;
    [myHud showWhileExecuting:@selector(myTaskWithTime:) onTarget:self withObject:@(delay) animated:YES];
    isShowing = YES;
}

- (void)myTaskWithTime:(id)delay{

    sleep([delay intValue]);
    isShowing = NO;
}

- (void)myTask{
    
    sleep(30);
    isShowing = NO;
}

- (void)hideHUD{
    
    [myHud hide:YES];
    isShowing = NO;
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    isShowing = NO;
}
@end
