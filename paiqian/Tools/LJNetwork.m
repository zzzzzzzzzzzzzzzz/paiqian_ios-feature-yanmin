//
//  LJNetwork.m
//  paiqian
//
//  Created by LuoJiee on 15/9/24.
//  Copyright © 2015年 LuoJiee. All rights reserved.
//

#import "LJNetwork.h"

#define kBaseURL @""

static BOOL isFirst = NO ;
static BOOL canCheckNetwork = NO ;

@implementation LJNetwork

+(void)requestURL:(NSString *) urlString
       httpMethod:(NSString *) method
           patams:(NSMutableDictionary *) parmas
          success:(void (^)(id data)) success
             fail:(void(^)(NSError* error)) fail {
    
    if (isFirst == NO) {
        //网络只有在startMonitoring完成后才可以使用检查网络状态
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            canCheckNetwork = YES;
        }];
        isFirst = YES;
    }
    
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    //BOOL isWifiOK = [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
    //BOOL is3GOK = [[AFNetworkReachabilityManager sharedManager]isReachableViaWWAN];
    //网络有问题
    if(isOK == NO && canCheckNetwork == YES){
        NSError *error = [NSError errorWithDomain:@"网络错位" code:100 userInfo:nil];
        fail(error) ;
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [ AFJSONResponseSerializer serializer] ;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    
    if ([[method uppercaseString] isEqualToString:@"GET"])  {
        
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
            
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
////
 //   根据返回状态做一些处理
////
            success(obj);
            
        } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
            
            fail(error);
            
        }];
        
    }else if ([[method uppercaseString] isEqualToString:@"POST"]){
        
        [manager  POST:urlString parameters:parmas success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            success(obj);
        } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
            fail(error);
        }];
        
        
    }
    
    
    
    
    
}

+(void)requestBaseURL:(NSString *) urlString
           httpMethod:(NSString *) method
               patams:(NSMutableDictionary *) parmas
              success:(void (^)(id data)) success
                 fail:(void(^)(NSError* error)) fail {
    
     NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseURL, urlString];
     NSString *encodeURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    if (isFirst == NO) {
        //网络只有在startMonitoring完成后才可以使用检查网络状态
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            canCheckNetwork = YES;
        }];
        isFirst = YES;
    }
    
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    //BOOL isWifiOK = [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
    //BOOL is3GOK = [[AFNetworkReachabilityManager sharedManager]isReachableViaWWAN];
    //网络有问题
    if(isOK == NO && canCheckNetwork == YES){
        NSError *error = [NSError errorWithDomain:@"网络错位" code:100 userInfo:nil];
        fail(error) ;
        return;
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [ AFJSONResponseSerializer serializer] ;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    
    if ([[method uppercaseString] isEqualToString:@"GET"])  {
        
        [manager GET:encodeURL parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
            
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            success(obj);
            
        } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
            
            fail(error);
            
        }];
        
    }else if ([[method uppercaseString] isEqualToString:@"POST"]){
        
        [manager  POST:encodeURL parameters:parmas success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            success(obj);
            
        } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
            fail(error);
        }];
        
        
    }

}
@end
