//
//  NSNull+ZHNatural.m
//  nvshengpai_2
//
//  Created by 360 on 15/2/11.
//  Copyright (c) 2015年 nvshengpai. All rights reserved.
//

#import "NSNull+ZHNatural.h"

@implementation NSNull (ZHNatural)

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([self respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:self];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *sig = [[NSNull class] instanceMethodSignatureForSelector:selector];
    if(sig == nil) {
        sig = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
    }
    return sig;
}

@end
