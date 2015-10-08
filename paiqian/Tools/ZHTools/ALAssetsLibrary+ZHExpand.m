//
//  ALAssetsLibrary+ZHExpand.m
//  nvshengpai_2
//
//  Created by 360 on 14-7-24.
//  Copyright (c) 2014年 nvshengpai. All rights reserved.
//

#import "ALAssetsLibrary+ZHExpand.h"

NSString *const ZHAssetGroupName = @"机器人";

@implementation ALAssetsLibrary (ZHExpand)

/**
 *  创建本地相册
 *
 *  @param name                        相册名称
 *  @param enumerateGroupsFailureBlock 遍历相册分组失败回调
 *  @param hasGroup                    本地已经存在该相册，请重新命名
 *  @param createSuccessedBlock        创建相册成功回调
 *  @param createFaieldBlock           创建相册失败回调
 */
- (void)zh_createAssetsGroupWithName:(NSString*)name
         enumerateGroupsFailureBlock:(void (^) (NSError *error))enumerateGroupsFailureBlock
                 hasTheNewGroupBlock:(void (^) (ALAssetsGroup *group))hasGroup
                createSuccessedBlock:(void (^) (ALAssetsGroup *group))createSuccessedBlock
                   createFaieldBlock:(void (^) (NSError *error))createFaieldBlock
{
    
    __block BOOL hasTheNewGroup = NO;
    
    [self enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        hasTheNewGroup = [name isEqualToString:[group valueForProperty:ALAssetsGroupPropertyName]];
        if (hasTheNewGroup) {
                
            dispatch_async(dispatch_get_main_queue(), ^{
                
                hasGroup(group);
            });
            *stop = YES;
        }
        if (!group && !hasTheNewGroup && !*stop) {//遍历完毕，本地没有该文件夹，非手动停止的遍历
            
            [self addAssetsGroupAlbumWithName:name resultBlock:^(ALAssetsGroup *agroup) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    createSuccessedBlock(agroup);
                });
            } failureBlock:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    createFaieldBlock(error);
                });
            }];
        }
    } failureBlock:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            enumerateGroupsFailureBlock(error);
        });
    }];
}

/**
 *  保存视频到指定相册（直接调用可保存到指定分组）
 *
 *  @param url             视频路径
 *  @param name             相册名称
 *  @param saveSuccessBlock 保存成功回调
 *  @param saveFaieldBlock  保存失败回调
 */
- (void)zh_saveVideoWithVideoPath:(NSURL*)url
                          toAlbum:(NSString*)name
                 saveSuccessBlock:(void (^) (ALAssetsGroup *group, NSURL *assetURL, ALAsset *asset))saveSuccessBlock
                  saveFaieldBlock:(void (^) (NSError *error))saveFaieldBlock
{
    
    [self writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {//先添加到公众相册
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                saveFaieldBlock(error);
            });
            return;
        }
        
        [self zh_addVideoToAssetGroupWithAssetUrl:assetURL toAlbum:name addSuccessBlock:^(ALAssetsGroup *targetGroup, NSURL *currentAssetUrl, ALAsset *currentAsset) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                saveSuccessBlock(targetGroup,currentAssetUrl,currentAsset);
            });
        } addFaieldBlock:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                saveFaieldBlock(error);
            });
        }];
    }];
}

/**
 *  添加相册视频到指定分组
 *
 *  @param assetURL        视频在相册的URL
 *  @param name            指定分组名称
 *  @param addSuccessBlock 添加成功回调
 *  @param addFaieldBlock  添加失败回调
 */
- (void)zh_addVideoToAssetGroupWithAssetUrl:(NSURL*)assetURL
                                    toAlbum:(NSString*)name
                            addSuccessBlock:(void (^) (ALAssetsGroup *targetGroup, NSURL *currentAssetUrl, ALAsset *currentAsset))addSuccessBlock
                             addFaieldBlock:(void (^) (NSError *error))addFaieldBlock
{

    [self zh_createAssetsGroupWithName:name enumerateGroupsFailureBlock:^(NSError *error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                addFaieldBlock(error);
            });
            return ;
        }
    } hasTheNewGroupBlock:^(ALAssetsGroup *group) {
        
        [self assetForURL:assetURL resultBlock:^(ALAsset *asset) {//得到视频的ALAsset实例
            
            [group addAsset:asset];//添加视频到指定相册分组
            dispatch_async(dispatch_get_main_queue(), ^{
                
                addSuccessBlock(group,assetURL,asset);
            });
        } failureBlock:^(NSError *error) {
            
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    addFaieldBlock(error);
                });
                return ;
            }
        }];
    } createSuccessedBlock:^(ALAssetsGroup *group) {
        
        [self assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            
            [group addAsset:asset];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                addSuccessBlock(group,assetURL,asset);
            });
        } failureBlock:^(NSError *error) {
            
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    addFaieldBlock(error);
                });
                return ;
            }
        }];
    } createFaieldBlock:^(NSError *error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                addFaieldBlock(error);
            });
            return ;
        }
    }];
}


@end
