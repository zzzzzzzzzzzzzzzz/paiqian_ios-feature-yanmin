//
//  HUD.h
//  ZHFilterCamera
//
//  Created by 360 on 13-9-25.
//  Copyright (c) 2013年 nvshengpai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface HUD : NSObject<MBProgressHUDDelegate>

@property(strong,nonatomic)MBProgressHUD* myHud;
@property(assign,nonatomic)bool isShowing;

#pragma mark - HUD
+ (HUD*)sharedHUD;
/**
 *  显示一个HUD，超过30秒后自动消失
 */
- (void)showHUDWithView:(UIView*)view Mode:(MBProgressHUDMode)mode Title:(NSString*)title;
/**
 *  显示一个HUD，需要手动隐藏hide
 */
- (void)showHUDNeverAutoHide:(UIView*)view Mode:(MBProgressHUDMode)mode Title:(NSString*)title;
/**
 *  显示一个HUD，延迟delay秒隐藏
 */
- (void)showHUDWithView:(UIView*)view mode:(MBProgressHUDMode)mode Title:(NSString*)title delayHiden:(int)delay;

- (void)hideHUD;
@end
