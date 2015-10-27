//
//  PindaoCacher.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-16.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommHead.h"
#import "NotifyCenter.h"


extern NSString* const HUASHUO_PD ;

typedef void(^PindaoProcessEndBlock)(NSDictionary * customDict);

@interface PindaoCacher : NSObject
//上传网络
+ (void)uploadToNetwork;

//延时上传网络
+(void)forceSaveToNetwork;

//得到缓存列表
+(id)getPindaoList;

//云同步
+(void)getPindaoListFromNetwork:(int)ver completed:(PindaoProcessEndBlock)sender;

//是否关注
+(BOOL)isFocused:(NSString*)kind kindID:(NSString*)kind_id;

//关注频道
+(BOOL)focusPindao:(NSString*) title kind:(NSString*)kind kindID:(NSNumber*)kindID imgID:(NSNumber*)imgID desc:(NSString*)desc;

//取消关注
+(BOOL)unfocusPindao:(NSString*)kind kindId:(NSString*)kindID;

@end


