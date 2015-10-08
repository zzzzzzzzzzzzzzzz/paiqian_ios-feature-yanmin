//
//  ZHVideoTools.m
//  nvshengpai_2
//
//  Created by 360 on 14-7-25.
//  Copyright (c) 2014年 nvshengpai. All rights reserved.
//

#import "ZHVideoTools.h"
#import "ZHFileManager.h"
#import <UIKit/UIKit.h>

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@implementation ZHVideoTools

+ (NSURL*)createFileUrlWithPath:(NSString*)path
{
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
		[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	}
    unlink([path UTF8String]);
    return [NSURL fileURLWithPath:path];
}

+ (CGSize)videoSizeWithSessionPreset:(NSString *)sessionPreset{
    
    if ([sessionPreset isEqualToString:AVCaptureSessionPreset1280x720]){
        
        return CGSizeMake(720.0, 1280.0);
    }else if ([sessionPreset isEqualToString:AVCaptureSessionPreset640x480]) {
        
        return CGSizeMake(480.0, 640.0);
    }
    
    return CGSizeMake(480.0, 480.0);
}

+ (CGSize)cutSizeWithVideoSize:(CGSize)videoSize{
    
    CGFloat bufferWidth = videoSize.width;
    CGFloat bufferHeight = videoSize.height;
    
    if (bufferHeight >= 720) {
        
        bufferHeight = bufferWidth = 720;
    }else if (bufferHeight <= bufferWidth) {
       
        bufferWidth = bufferHeight;
    }else{
        
        bufferHeight = bufferWidth;
    }
    return CGSizeMake(bufferWidth, bufferHeight);
}


+ (void)addAudioWithAudioUrl:(NSURL*)audioUrl
                    videoUrl:(NSURL*)videoUrl
             addSuccessBlock:(void (^) (NSString *exportPath, NSURL *exportUrl))addSuccessBlock
              addFailedBlock:(void (^) (NSError *error))addFailedBlock
{
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
	AVURLAsset* videoAsset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    //混合视频
	AVMutableCompositionTrack *vcTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack* vtrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0];
	[vcTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:vtrack atTime:kCMTimeZero error:nil];
    //混合音乐
	AVMutableCompositionTrack *acTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *aTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
	[acTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:aTrack atTime:kCMTimeZero error:nil];

    //保存混合后的文件的过程
    NSString *exportPath = [ZHFileManager getTempVideoFileSavePath];
	NSURL *exportUrl = [ZHVideoTools createFileUrlWithPath:exportPath];
	AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                          presetName:AVAssetExportPresetPassthrough];
	_assetExport.outputFileType                 = @"com.apple.quicktime-movie";
	_assetExport.outputURL                      = exportUrl;
	_assetExport.shouldOptimizeForNetworkUse    = YES;

    [_assetExport exportAsynchronouslyWithCompletionHandler:^{
        
        while(YES){
            if(_assetExport.status == AVAssetExportSessionStatusCompleted){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    addSuccessBlock(exportPath,exportUrl);
                });
                break;
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    addFailedBlock(_assetExport.error);
                });
                break;
            }
        }
    }];
}

+ (void)videoSoundAddBGMWithAudioUrl:(NSURL*)audioUrl
                            videoUrl:(NSURL*)videoUrl
                     mixSuccessBlock:(void (^) (NSURL *exportUrl))mixSuccessBlock
                      mixFailedBlock:(void (^) (NSError *error))mixFailedBlock
{
    AVURLAsset* videoAsset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];

    AVMutableAudioMixInputParameters *trackAudioMix = [ZHVideoTools setUpAndAddAudioAtPath:videoUrl toComposition:mixComposition volume:0.9];
    AVMutableAudioMixInputParameters *bgmMixTrack = [ZHVideoTools setUpAndAddAudioAtPath:audioUrl toComposition:mixComposition volume:0.5];

    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    audioMix.inputParameters = @[bgmMixTrack,trackAudioMix];
    
    NSString *exportPath = [ZHFileManager getTempAudioFileSavePath];
    NSURL *exportUrl = [ZHVideoTools createFileUrlWithPath:exportPath];
    AVAssetExportSession *session = [AVAssetExportSession exportSessionWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];
    session.outputFileType        = AVFileTypeAppleM4A;
    session.outputURL             = exportUrl;
    session.audioMix              = audioMix;
    session.timeRange             = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    [session exportAsynchronouslyWithCompletionHandler:^{
        while(YES){
            if(session.status == AVAssetExportSessionStatusCompleted){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (mixSuccessBlock) {
                        mixSuccessBlock(exportUrl);
                    }
                });
                break;
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (mixFailedBlock) {
                        mixFailedBlock(session.error);
                    }
                });
                break;
            }
        }
    }];
}

+ (AVMutableAudioMixInputParameters*)setUpAndAddAudioAtPath:(NSURL*)assetURL
                                              toComposition:(AVMutableComposition *)composition
                                                     volume:(CGFloat)volume{
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *sourceAudioTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
    [trackMix setVolumeRampFromStartVolume:volume toEndVolume:volume timeRange:CMTimeRangeMake(kCMTimeZero, songAsset.duration)];
    
    NSError *error = nil;
    [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, songAsset.duration) ofTrack:sourceAudioTrack atTime:kCMTimeInvalid error:&error];

    return trackMix;
}

+ (void)videoTranscodingWithUrl:(NSURL*)url
                      videoSize:(CGSize)videoSize
           transcodSuccessBlock:(void (^) (NSString *exportPath, NSURL *exportUrl))transcodSuccessBlock
            transcodFailedBlock:(void (^) (NSError *error))transcodFailedBlock
{
    AVAsset* videoAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSString *exportPath = [ZHFileManager getTempVideoFileSavePath];
    NSURL *exportUrl = [ZHVideoTools createFileUrlWithPath:exportPath];
    
    //裁剪区域
    CGSize renderSize = [ZHVideoTools cutSizeWithVideoSize:videoSize];
    //裁剪坐标偏移
    CGFloat dy = fabs(videoSize.width - videoSize.height)/2;
    
    if ([videoAsset tracksWithMediaType:AVMediaTypeVideo].count <= 0) {
        
        NSLog(@"失败");
        if (transcodFailedBlock) {
            transcodFailedBlock(nil);
        }
        return;
    }
    AVAssetTrack *avAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionInstruction *avMutableVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    [avMutableVideoCompositionInstruction setTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)];
   
    AVMutableVideoCompositionLayerInstruction *avMutableVideoCompositionLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:avAssetTrack];
    //Y轴坐标向上偏移300像素，从（x0,y0）开始按renderSize裁剪
    [avMutableVideoCompositionLayerInstruction setTransform:CGAffineTransformMake(1.0f, 0.0f, 0.0f, 1.0f, 0.0f, -dy) atTime:kCMTimeZero];
    NSLog(@"%f,%f,%f,%f,%f,%f",avAssetTrack.preferredTransform.a,
          avAssetTrack.preferredTransform.b,
          avAssetTrack.preferredTransform.c,
          avAssetTrack.preferredTransform.d,
          avAssetTrack.preferredTransform.tx,
          avAssetTrack.preferredTransform.ty);

    avMutableVideoCompositionInstruction.layerInstructions = [NSArray arrayWithObject:avMutableVideoCompositionLayerInstruction];

    AVMutableVideoComposition *avMutableVideoComposition = [AVMutableVideoComposition videoComposition];
    // 这个视频大小可以由你自己设置。比如源视频640*480.而你这320*480.最后出来的是320*480这么大的，640多出来的部分就没有了。并非是把图片压缩成那么大了。
    avMutableVideoComposition.renderSize = renderSize;
    avMutableVideoComposition.frameDuration = CMTimeMake(1, 25);
    avMutableVideoComposition.instructions = [NSArray arrayWithObject:avMutableVideoCompositionInstruction];

    AVAssetExportSession *session = [AVAssetExportSession exportSessionWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality];
    session.outputFileType        = AVFileTypeQuickTimeMovie;
    session.outputURL             = exportUrl;
    session.videoComposition      = avMutableVideoComposition;
    [session exportAsynchronouslyWithCompletionHandler:^{
        
        while(YES){
            if(session.status == AVAssetExportSessionStatusCompleted){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (transcodSuccessBlock) {
                        transcodSuccessBlock(exportPath,exportUrl);
                    }
                });
                break;
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (transcodFailedBlock) {
                        transcodFailedBlock(session.error);
                    }
                });
                break;
            }
        }
    }];
}

+ (void)clipVideoWithVideoUrl:(NSURL*)url
                    startTime:(CGFloat)startTime
                     stopTime:(CGFloat)stopTime
                   presetName:(NSString*)presetName
             clipSuccessBlock:(void (^) (NSString *exportPath, NSURL *exportUrl))clipSuccessBlock
              clipFailedBlock:(void (^) (NSError *error))clipFailedBlock{
    
    AVAsset* videoAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    if (!compatiblePresets || compatiblePresets.count <= 0) {
        
        clipFailedBlock(nil);
        return;
    }
    
    if ([compatiblePresets containsObject:presetName]) {
        
        AVAssetExportSession* exportSession = [[AVAssetExportSession alloc]
                                               initWithAsset:videoAsset presetName:presetName];
        NSString *exportPath = [ZHFileManager getVideoFileSavePath];
        NSURL *exportUrl = [ZHVideoTools createFileUrlWithPath:exportPath];
        exportSession.outputURL = exportUrl;
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        
        CMTime start = CMTimeMakeWithSeconds(startTime, videoAsset.duration.timescale);
        CMTime duration = CMTimeMakeWithSeconds(stopTime - startTime, videoAsset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        exportSession.timeRange = range;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            while(YES){
                if(exportSession.status == AVAssetExportSessionStatusCompleted){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        clipSuccessBlock(exportPath,exportUrl);
                    });
                    break;
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        clipFailedBlock(exportSession.error);
                    });
                    break;
                }
            }
        }];
    }else{
        
        clipFailedBlock(nil);
    }
}

+ (void)clipVideoWithVideoUrl:(NSURL*)url
                    startTime:(CGFloat)startTime
                     stopTime:(CGFloat)stopTime
             clipSuccessBlock:(void (^) (NSString *exportPath, NSURL *exportUrl))clipSuccessBlock
              clipFailedBlock:(void (^) (NSError *error))clipFailedBlock
{
    
	AVAsset* videoAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    if (!compatiblePresets || compatiblePresets.count <= 0) {
        
        clipFailedBlock(nil);
        return;
    }
    
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        
        AVAssetExportSession* exportSession = [[AVAssetExportSession alloc]
                                               initWithAsset:videoAsset presetName:AVAssetExportPresetPassthrough];
        NSString *exportPath = [ZHFileManager getVideoFileSavePath];
        NSURL *exportUrl = [ZHVideoTools createFileUrlWithPath:exportPath];
        exportSession.outputURL = exportUrl;
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        
        CMTime start = CMTimeMakeWithSeconds(startTime, videoAsset.duration.timescale);
        CMTime duration = CMTimeMakeWithSeconds(stopTime - startTime, videoAsset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        exportSession.timeRange = range;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            while(YES){
                if(exportSession.status == AVAssetExportSessionStatusCompleted){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        clipSuccessBlock(exportPath,exportUrl);
                    });
                    break;
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [ZHVideoTools clipVideoWithVideoUrl:url startTime:startTime stopTime:stopTime presetName:AVAssetExportPresetMediumQuality clipSuccessBlock:^(NSString *exportPath, NSURL *exportUrl) {
                            
                            clipSuccessBlock(exportPath,exportUrl);
                        } clipFailedBlock:^(NSError *error) {
                            
                            [ZHVideoTools clipVideoWithVideoUrl:url startTime:startTime stopTime:stopTime presetName:AVAssetExportPresetLowQuality clipSuccessBlock:^(NSString *exportPath, NSURL *exportUrl) {
                                
                                clipSuccessBlock(exportPath,exportUrl);
                            } clipFailedBlock:^(NSError *error) {
                                
                                clipFailedBlock(exportSession.error);
                            }];
                        }];
                    });
                    break;
                }
            }
        }];
    }else{
        
        clipFailedBlock(nil);
    }
    
}

+ (void)cacheVideoWithUrl:(NSURL*)url
           removeBlackFrame:(BOOL)needRemove
          cacheSuccessBlock:(void (^) (NSString *exportPath, NSURL *exportUrl))cacheSuccessBlock
           cacheFailedBlock:(void (^) (NSError *error))cacheFailedBlock
{

    AVAsset* videoAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    if (!compatiblePresets || compatiblePresets.count <= 0) {
        
        cacheFailedBlock(nil);
        return;
    }
    
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        
        AVAssetExportSession* exportSession = [[AVAssetExportSession alloc]
                                               initWithAsset:videoAsset presetName:AVAssetExportPresetPassthrough];
        NSString *exportPath = [ZHFileManager getVideoFileSavePath];
        NSURL *exportUrl = [ZHVideoTools createFileUrlWithPath:exportPath];
        exportSession.outputURL = exportUrl;
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            while(YES){
                if(exportSession.status == AVAssetExportSessionStatusCompleted){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        cacheSuccessBlock(exportPath,exportUrl);
                    });
                    break;
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [ZHVideoTools clipVideoWithVideoUrl:url startTime:0 stopTime:CMTimeGetSeconds(videoAsset.duration) presetName:AVAssetExportPresetMediumQuality clipSuccessBlock:^(NSString *exportPath, NSURL *exportUrl) {
                            
                            cacheSuccessBlock(exportPath,exportUrl);
                        } clipFailedBlock:^(NSError *error) {
                            
                            [ZHVideoTools clipVideoWithVideoUrl:url startTime:0 stopTime:CMTimeGetSeconds(videoAsset.duration) presetName:AVAssetExportPresetLowQuality clipSuccessBlock:^(NSString *exportPath, NSURL *exportUrl) {
                                
                                cacheSuccessBlock(exportPath,exportUrl);
                            } clipFailedBlock:^(NSError *error) {
                                
                                cacheFailedBlock(exportSession.error);
                            }];
                        }];
                    });
                    break;
                }
            }
        }];
    }else{
        
        cacheFailedBlock(nil);
    }
}


+ (UIImage*)getCoverWithVideoUrl:(NSURL*)theUrl atTime:(NSTimeInterval)time{
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    
    AVAsset *myAsset = [[AVURLAsset alloc] initWithURL:theUrl options:opts];
    
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:myAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.maximumSize = CGSizeMake(kWidth*2, kWidth*2);
    imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;

    NSError *error;
    CGImageRef image = [imageGenerator copyCGImageAtTime:CMTimeMake(time, 60) actualTime:NULL error:&error];
    if (error) {
        NSLog(@"###获取封面失败###");
        return nil;
    }
    return [UIImage imageWithCGImage:image];
}


@end
