//
//  Pindao.h
//  DaGangCheng
//
//  Created by huaxo on 14-10-28.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pindao : NSObject

/**
 *  频道Id
 */
@property (nonatomic, copy) NSString *pindaoId;

/**
 *  用户Id
 */
@property (nonatomic, copy) NSString *uid;

/**
 *  频道名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  频道图片Id
 */
@property (nonatomic, copy) NSString *imageId;

/**
 *  频道描述
 */
@property (nonatomic, copy) NSString *desc;

/**
 *  经度
 */
@property (nonatomic, assign) CGFloat gps_lat;

/**
 *  维度
 */
@property (nonatomic, assign) CGFloat gps_lng;

/**
 *  地址
 */
@property (nonatomic, copy) NSString *addr;

/**
 *  被推荐的原因
 */
@property (nonatomic, copy) NSString *tips;

/**
 *  用户关注数
 */
@property (nonatomic, copy) NSString *userNum;

/**
 *  创建时间
 */
@property (nonatomic, copy) NSString *createTime;

/**
 *  距离
 */
@property (nonatomic, copy) NSString *distance;

/**
 *  今日发帖数
 */
@property (nonatomic, copy) NSString *todayPostNum;

/**
 *  频道限定
 */
@property (nonatomic, assign) NSInteger statusValue;


#pragma mark - addBy Nick（频道分类）
/**
 *  频道分类id
 */
@property (nonatomic, copy) NSString *kindId;

/**
 *  频道分类名称
 */
@property (nonatomic, copy) NSString *kindName;

/**
 *  发贴数量
 */
@property (nonatomic, copy) NSString *postNum;

/**
 *  回帖数量
 */
@property (nonatomic, copy) NSString *replyNum;

/**
 *  字典转模型
 */
+ (Pindao *)getPindaoByJson:(NSDictionary *)json;

@end
