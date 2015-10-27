//
//  ZBUser.h
//  DaGangCheng
//
//  Created by huaxo on 15-7-23.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBUser : NSObject

/**
 *  UserID
 */
@property (assign, nonatomic) int64_t UID;

/**
 *  电话号码 类型：NSString。
 */
@property (copy,   nonatomic) NSString *phoneNumber;

/**
 *  昵称
 */
@property (copy,   nonatomic) NSString *nickName;

/**
 *  姓名
 */
@property (copy,   nonatomic) NSString *name;

/**
 *  用户的头像ID
 */
@property (assign, nonatomic) int64_t userImageID;

@end
