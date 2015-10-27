//
//  FriendDataItem.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "FriendDataItem.h"

@implementation FriendDataItem
@synthesize flag,data;

-(id)initWithData:(id) d dataFlag:(int)f
{
    self.data  = d;
    self.flag  = f;
    self.showFlag = YES;
    return self;
}

-(id)initWithData:(id) d dataFlag:(int)f showFlag:(BOOL)sf
{
    self.data  = d;
    self.flag  = f;
    self.showFlag = sf;
    return self;
}
@end
