//
//  ALAssetsLibrary+ZHExpand.h
//  nvshengpai_2
//
//  Created by 360 on 14-7-24.
//  Copyright (c) 2014年 nvshengpai. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

/**
 *  女生派相册名称
 */
extern NSString *const ZHAssetGroupName;

@interface ALAssetsLibrary (ZHExpand)

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
                   createFaieldBlock:(void (^) (NSError *error))createFaieldBlock;
/**
 *  保存视频到指定相册（直接调用可保存到指定分组）
 *
 *  @param path             视频路径
 *  @param name             相册名称
 *  @param saveSuccessBlock 保存成功回调
 *  @param saveFaieldBlock  保存失败回调
 */
- (void)zh_saveVideoWithVideoPath:(NSURL*)url
                          toAlbum:(NSString*)name
                 saveSuccessBlock:(void (^) (ALAssetsGroup *group, NSURL *assetURL, ALAsset *asset))saveSuccessBlock
                  saveFaieldBlock:(void (^) (NSError *error))saveFaieldBlock;

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
                             addFaieldBlock:(void (^) (NSError *error))addFaieldBlock;


@end
