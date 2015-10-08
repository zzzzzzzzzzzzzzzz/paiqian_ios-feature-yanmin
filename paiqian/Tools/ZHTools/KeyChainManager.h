//
//  KeyChainManager.h
//  nvshengpai_2
//
//  Created by 360 on 14/11/20.
//  Copyright (c) 2014年 nvshengpai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainManager : NSObject

+ (BOOL)saveUserName:(NSString*)uName
             userPwd:(NSString*)pwd;

+ (BOOL)deletePassword;

+ (BOOL)clean;

+ (NSString*)getUserName;

+ (NSString*)getUserPwd;


+ (BOOL)saveUUID:(NSString*)uuid;
+ (NSString*)getUUID;


+ (BOOL)isValidateEmail:(NSString*)email;
//+ (int)isValidatePassward:(NSString*)pwd;

@end
