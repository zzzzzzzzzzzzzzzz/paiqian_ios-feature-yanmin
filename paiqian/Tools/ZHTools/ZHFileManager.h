//
//  ZHFileManager.h
//  nvshengpai_2
//
//  Created by 360 on 14/12/22.
//  Copyright (c) 2014年 nvshengpai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHFileManager : NSObject

/**
 *  获取用户信息缓存路径
 */
+ (NSString *)userDataFilePath;

+ (NSString *)dataFilePath;

/**
 *  获取视频文件缓存路径
 */
+ (NSString*)getVideoFileFolder;

/**
 *  获取视频缓存文件名
 */
+ (NSString*)getVideoFileName;
+ (NSString*)getVideoFileNameWithPath:(NSString*)path;
+ (NSString*)getVideoFileNameWithUrl:(NSURL*)url;

/**
 *  获取视频文件保存路径
 */
+ (NSString*)getVideoFileSavePath;

/**
 *  通过视频文件名获取视频缓存文件夹下的视频文件路径
 */
+ (NSString*)getVideoFilePathWithFileName:(NSString*)name;

/**
 *  通过视频文件名获取视频文件URL地址
 */
+ (NSURL*)getVideoFileUrlWithFileName:(NSString*)nam;

/**
 *  获取图片缓存路径
 */

+ (NSString *)getImageCacheFile;

+ (NSString*)getAudioFileName;
+ (NSString*)getTempAudioFileSavePath;
+ (NSString*)getTempVideoFileSavePath;

/**
 *  计算一个文件的大小 (M)
 */
//+ (CGFloat)folderSizeAtPath:(NSString *)folderPath;
//
//+ (long long)fileSizeAtPath:(NSString*)filePath;
//
//+ (CGFloat)clearDataCache;


@end
