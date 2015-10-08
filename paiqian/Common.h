//
//  Common.h
//  paiqian
//
//  Created by LuoJiee on 15/9/24.
//  Copyright © 2015年 LuoJiee. All rights reserved.
//

#ifndef Common_h
#define Common_h


#import "HUD.h"  // 提示框
#import "KeyChainManager.h"  // 归档
#import "JKNotifier.h"      // 推送消息提示栏
#import "AFNetworking.h"
#import "MJRefresh.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import <ReactiveCocoa/ReactiveCocoa.h>



#define RGBA(r,g,b,a)           [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:(a)]

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

// View 坐标(x,y)和宽高(width,height)
#define ZHX(v)                    (v).frame.origin.x
#define ZHY(v)                    (v).frame.origin.y
#define ZHWIDTH(v)                (v).frame.size.width
#define ZHHEIGHT(v)               (v).frame.size.height


/**
 *  格式化输出日志
 *
 */



#define ZHLOG( s, ... ) NSLog( @"<类名：%@ 位置：%d>  类方法：%s 输出：%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define ZHLOG( s, ... ) do {} while (0)

#endif /* Common_h */

