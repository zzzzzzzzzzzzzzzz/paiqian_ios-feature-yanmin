//
//  ZHVideoTools.h
//  nvshengpai_2
//
//  Created by 360 on 14-7-25.
//  Copyright (c) 2014年 nvshengpai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface ZHVideoTools : NSObject

/**
 *  根据文件保存路径创建一个url
 *
 *  @param path 文件路径
 *
 *  @return url
 */
+ (NSURL*)createFileUrlWithPath:(NSString*)path;

+ (CGSize)videoSizeWithSessionPreset:(NSString *)sessionPreset;

+ (CGSize)cutSizeWithVideoSize:(CGSize)videoSize;

    
/**
 *  向视频中添加音乐
 *
 *  @param audioUrl        音乐地址
 *  @param videoUrl        视频地址
 *  @param addSuccessBlock 添加成功回调
 *  @param addFailedBlock  添加失败回调
 */
+ (void)addAudioWithAudioUrl:(NSURL*)audioUrl
                    videoUrl:(NSURL*)videoUrl
             addSuccessBlock:(void (^) (NSString *exportPath, NSURL *exportUrl))addSuccessBlock
              addFailedBlock:(void (^) (NSError *error))addFailedBlock;

+ (void)videoSoundAddBGMWithAudioUrl:(NSURL*)audioUrl
                            videoUrl:(NSURL*)videoUrl
                     mixSuccessBlock:(void (^) (NSURL *exportUrl))mixSuccessBlock
                      mixFailedBlock:(void (^) (NSError *error))mixFailedBlock;

/**
 *  视频转码
 *
 *  @param URL              视频地址
 *  @param renderSize       指定转码后的分辨率
 *  @param addSuccessBlock  添加成功回调
 *  @param addFailedBlock   添加失败回调
 */
+ (void)videoTranscodingWithUrl:(NSURL*)url
                      videoSize:(CGSize)videoSize
           transcodSuccessBlock:(void (^) (NSString *exportPath, NSURL *exportUrl))transcodSuccessBlock
            transcodFailedBlock:(void (^) (NSError *error))transcodFailedBlock;

/**
 *  视频剪辑
 *
 *  @param url              视频地址
 *  @param startTime        开始时间
 *  @param stopTime         结束时间
 *  @param clipSuccessBlock 剪辑成功回调
 *  @param clipFailedBlock  剪辑失败回调
 */
+ (void)clipVideoWithVideoUrl:(NSURL*)url
                    startTime:(CGFloat)startTime
                     stopTime:(CGFloat)stopTime
             clipSuccessBlock:(void (^) (NSString *exportPath, NSURL *exportUrl))clipSuccessBlock
              clipFailedBlock:(void (^) (NSError *error))clipFailedBlock;

/**
 *  缓存相册视频
 *
 *  @param url               从相册读取的视频Url
 *  @param needRemove        是否需要取消前三侦
 *  @param cacheSuccessBlock 缓存成功回调
 *  @param cacheFailedBlock  缓存失败回调
 */
+ (void)cacheVideoWithUrl:(NSURL*)url
           removeBlackFrame:(BOOL)needRemove
          cacheSuccessBlock:(void (^) (NSString *exportPath, NSURL *exportUrl))cacheSuccessBlock
           cacheFailedBlock:(void (^) (NSError *error))cacheFailedBlock;

+ (UIImage*)getCoverWithVideoUrl:(NSURL*)theUrl atTime:(NSTimeInterval)time;

@end
