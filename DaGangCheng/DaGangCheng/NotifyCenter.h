//
//  NotifyCenter.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-28.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NotifyCenter : NSObject


+(NSString*)userNotifyKey;
+(NSString*)userLoginStatusKey;

-(void)startUserNewsNotify;

-(void)stopUserNewsNotify;

+(void)sendLoginStatus:(id)obj;

-(void)getUserNews;
@end
