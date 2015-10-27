//
//  ZBChat.h
//  DaGangCheng
//
//  Created by huaxo on 15-7-10.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBChat : NSObject

@property (assign, nonatomic) NSInteger imgID;
@property (copy,   nonatomic) NSString *msg;
@property (assign, nonatomic) NSInteger msgID;
@property (assign, nonatomic) NSInteger createTime;
@property (copy,   nonatomic) NSString *combinationCreateTime;
@property (assign, nonatomic) NSInteger userImageID;
@property (assign, nonatomic) NSInteger uid;

@property (strong, nonatomic) NSDictionary *imageWHs;

//缓存高度
@property (strong, nonatomic) NSArray *regularMatchArray;
@property (assign, nonatomic) CGRect rect;

+ (ZBChat *)chatFromJson:(NSDictionary *)json;
@end
