//
//  ZHFileManager.m
//  nvshengpai_2
//
//  Created by 360 on 14/12/22.
//  Copyright (c) 2014年 nvshengpai. All rights reserved.
//

#import "ZHFileManager.h"

@implementation ZHFileManager

//返回用户信息缓存路径
+ (NSString *)userDataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"userDataCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return documentsDirectory;
}

+ (NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"dataCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return documentsDirectory;
}

+ (NSString *)getImageCacheFile{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *imageFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
    
    return imageFile;
}

#pragma  视频缓存文件
+ (NSString*)getVideoFileFolder{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"VideoFileCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return documentsDirectory;
}

+ (NSString*)getVideoFileName{
    
    return [NSString stringWithFormat:@"/%.0f.mp4",[[NSDate date] timeIntervalSince1970]];
}

+ (NSString*)getVideoFileNameWithPath:(NSString*)path{
    
    return [[path componentsSeparatedByString:@"/"] lastObject];
}

+ (NSString*)getVideoFileNameWithUrl:(NSURL*)url{
    
    return [[url.absoluteString componentsSeparatedByString:@"/"] lastObject];
}

+ (NSString*)getVideoFileSavePath{
    
    return [[ZHFileManager getVideoFileFolder] stringByAppendingString:[ZHFileManager getVideoFileName]];
}

+ (NSString*)getVideoFilePathWithFileName:(NSString*)name{
    
    return [NSString stringWithFormat:@"%@/%@",[ZHFileManager getVideoFileFolder],name];
}

+ (NSURL*)getVideoFileUrlWithFileName:(NSString*)name{
    
    return [NSURL fileURLWithPath:[ZHFileManager getVideoFilePathWithFileName:name]];
}

+ (NSURL*)getVideoFileUrlWithFilePath:(NSString*)path{
    
    return [NSURL fileURLWithPath:path];
}

#pragma  视频，音频零时文件
+ (NSString*)getAudioFileName{
    
    return [NSString stringWithFormat:@"/%.0f.mp4",[[NSDate date] timeIntervalSince1970]];
}

+ (NSString*)getTempAudioFileSavePath{
    
    return [NSString stringWithFormat:@"%@/%@",NSTemporaryDirectory(),[ZHFileManager getAudioFileName]];
}

+ (NSString*)getTempVideoFileSavePath{
    
    return [NSString stringWithFormat:@"%@/%@",NSTemporaryDirectory(),[ZHFileManager getVideoFileName]];
}

//+ (CGFloat)clearDataCache{
//    
//    CGFloat CacheFileSize = 0;
//    
//    NSString *diskCachePath = [ZHFileManager getVideoFileFolder];
//    NSArray *videoPaths = [ZHUploaderManager fetchUploaderVideoPaths];
//    
//    NSMutableArray *allFiles = [[NSMutableArray alloc]initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:diskCachePath error:nil]];
//    [allFiles removeObjectsInArray:videoPaths];//安全删除
//    [allFiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        
//        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",diskCachePath,obj] error:nil];
//    }];
//    
//    //删除图片缓存
//    NSString *imageFile = [ZHFileManager getImageCacheFile];
//    NSMutableArray *allImageFiles = [[NSMutableArray alloc] initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:imageFile error:nil]];
//    [allImageFiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        
//        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@",imageFile,obj] error:nil];
//        
//    }];
//    
//    //tmp文件的内容也清掉
//    NSString *tmpDire = NSTemporaryDirectory();
//    NSMutableArray *tmpFiles = [[NSMutableArray alloc] initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:tmpDire error:nil]];
//    [tmpFiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        
//        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@",tmpDire,obj] error:nil];
//    }];
//    
////    CacheFileSize = [self folderSizeAtPath:diskCachePath] + [self folderSizeAtPath:imageFile] + [self folderSizeAtPath:tmpDire];
//    
//    return CacheFileSize;
//}
//
//+ (long long)fileSizeAtPath:(NSString*)filePath{
//    
//    NSFileManager *manger = [NSFileManager defaultManager];
//    
//    if ([manger fileExistsAtPath:filePath]) {
//        
//        return [[manger attributesOfItemAtPath:filePath error:nil] fileSize];
//    }
//    
//    return 0;
//}
//
//+ (CGFloat)folderSizeAtPath:(NSString *)folderPath{
//    
//    NSFileManager *manger = [NSFileManager defaultManager];
//    
//    if (![manger fileExistsAtPath:folderPath]) return 0;
//    
//    NSEnumerator *childFilesEnumerator = [[manger subpathsAtPath:folderPath] objectEnumerator];
//    
//    NSString *fileName;
//    
//    long long folderSize = 0;
//    
//    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
//        
//        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
//        
//        folderSize += [ZHFileManager fileSizeAtPath:fileAbsolutePath];
//    }
//    return folderSize/(1024.0 * 1024.0);
//    
//}




@end
