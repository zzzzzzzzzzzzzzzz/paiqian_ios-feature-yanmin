//
//  LJNetwork.h
//  paiqian
//
//  Created by LuoJiee on 15/9/24.
//  Copyright © 2015年 LuoJiee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJNetwork : NSObject
//请求完成网络地址
+(void)requestURL:(NSString *) urlString
       httpMethod:(NSString *) method
           patams:(NSMutableDictionary *) parmas
          success:(void (^)(id data)) success
             fail:(void(^)(NSError* error)) fail ;

//请求接口
+(void)requestBaseURL:(NSString *) urlString
       httpMethod:(NSString *) method
           patams:(NSMutableDictionary *) parmas
          success:(void (^)(id data)) success
             fail:(void(^)(NSError* error)) fail ;
@end
