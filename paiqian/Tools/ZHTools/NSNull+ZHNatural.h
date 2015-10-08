//
//  NSNull+ZHNatural.h
//  nvshengpai_2
//
//  Created by 360 on 15/2/11.
//  Copyright (c) 2015年 nvshengpai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (ZHNatural)

- (void)forwardInvocation:(NSInvocation *)anInvocation;

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;

@end
