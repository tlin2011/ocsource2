//
//  Post.h
//  ex7-cell20
//
//  Created by huaxo on 14-10-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject
@property (nonatomic, copy) NSString *title;           //帖子的主题
@property (nonatomic, copy) NSString *content;         //帖子内容
@property (nonatomic, strong) NSArray *imageList;      //帖子中的图片数组
@property (nonatomic, strong) NSDictionary *imageWHs;       //帖子中图片的宽高数组
@property (nonatomic, copy) NSString *pindaoName;      //帖子的频道名
@property (nonatomic, assign) NSInteger zan;           //赞
@property (nonatomic, assign) NSInteger replyNum;      //回帖数
@property (nonatomic, copy) NSString *createTime;      //帖子创建时间
//@property (nonatomic, copy) NSString *pindaoId;
@property (nonatomic, copy) NSString *postId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) int64_t userImageId;       //用户头像
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) NSInteger flag;                //标签
@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, assign) int64_t preImageId;        //预览图
@property (nonatomic, assign) NSInteger readNum;         //浏览数
//@property (nonatomic, copy) NSString *activityTimeInfo;

@property (nonatomic, copy) NSString *activtyTag;    // 活动标签
@property (nonatomic, copy) NSString *startTime;     // 活动开始时间
@property (nonatomic, copy) NSString *endTime;       // 活动结束时间

@property (nonatomic, copy) NSString *postUrl;      // 跳转url

/**
 *  PostFull
 */
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) NSInteger pindaoID;
@property (nonatomic, copy) NSString *pindaoDesc;
@property (nonatomic, assign) long pindaoImageID;

@property (nonatomic, assign) NSInteger topFlag;





- (CGSize)getImageWidthAndHeightByImageId:(NSString *)imageId;
+ (CGSize)getImageWidthAndHeightByImageId:(NSString *)imageId andPost:(Post *)post;

+ (Post *)getPostByJson:(NSDictionary *)json;
//根据width去掉小图片
+ (Post *)getPostByJson:(NSDictionary *)json andRemoveSmallImageWithWidth:(CGFloat)width;

//帖子标签
+ (UIImage *)imageByPostFlag:(NSInteger)flag;

@end

