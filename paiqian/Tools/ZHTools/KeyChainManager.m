//
//  KeyChainManager.m
//  nvshengpai_2
//
//  Created by 360 on 14/11/20.
//  Copyright (c) 2014年 nvshengpai. All rights reserved.
//

#import "KeyChainManager.h"

#define NameService @"com.hl.ehuangli.uName"
#define PwdService  @"com.hl.ehuangli.uPwd"
#define UUIDService @"com.hl.ehuangli.uuid"

@implementation KeyChainManager

+ (NSMutableDictionary *)getKeyChainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

+ (BOOL)saveUserName:(NSString*)uName
             userPwd:(NSString*)pwd{
    
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:NameService];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:uName] forKey:(__bridge id)kSecValueData];
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
    
    keychainQuery = [self getKeyChainQuery:PwdService];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:pwd] forKey:(__bridge id)kSecValueData];
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
    
    return YES;
}

+ (BOOL)deletePassword{

    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:PwdService];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    return YES;
}

+ (BOOL)clean{
    
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:NameService];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    keychainQuery = [self getKeyChainQuery:PwdService];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    return YES;
}

+ (NSString*)getUserName{

    NSString* ret;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:NameService];
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
//        @try
//        {
//            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
//        }
//        @catch (NSException *e)
//        {
//            NSLog(@"Unarchive of %@ failed: %@", NameService, e);
//        }
//        @finally
//        {
//        }
          ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (NSString*)getUserPwd{
    
    NSString* ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:PwdService];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
//        @try
//        {
//            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
//        }
//        @catch (NSException *e)
//        {
//            NSLog(@"Unarchive of %@ failed: %@", PwdService, e);
//        }
//        @finally
//        {
//        }
        ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (BOOL)saveUUID:(NSString*)uuid{
    
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:UUIDService];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:uuid] forKey:(__bridge id)kSecValueData];
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
    return YES;
}

+ (NSString*)getUUID{
    
    NSString* ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:UUIDService];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
//        @try
//        {
//            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
//        }
//        @catch (NSException *e)
//        {
//            NSLog(@"Unarchive of %@ failed: %@", UUIDService, e);
//        }
//        @finally
//        {
//        }
         ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (BOOL)isValidateEmail:(NSString*)email{
    
    if (!email) {
        return NO;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//+ (int)isValidatePassward:(NSString*)pwd{
//    
//    if ([ZHTools isEmptyOrNull:pwd]) {//提示密码为空
//        
//        return 0;
//    }
//    if (pwd && pwd.length < 6){//密码太短
//    
//        return -1;
//    }
//    if (pwd && pwd.length > 16){//密码太长
//    
//        return -2;
//    }
//    
//    return 1;
//}

@end
