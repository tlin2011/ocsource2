//
//  FriendDataItem.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

enum FriendCelKind {
    FUNC_CELL = 0,
    TAB_CELL = 1,
    MSG_CELL = 2,
    FRIEND_CELL = 3
};

@interface FriendDataItem : NSObject

@property (assign, nonatomic)   int flag;
@property (strong, nonatomic)   id data;
@property (assign, nonatomic) BOOL showFlag;

-(id)initWithData:(id) data dataFlag:(int)flag;
-(id)initWithData:(id) d dataFlag:(int)f showFlag:(BOOL)sf;

@end
