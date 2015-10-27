//
//  ArchiverAndUnarchiver.m
//  DaGangCheng
//
//  Created by huaxo on 14-3-4.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ArchiverAndUnarchiver.h"

@implementation ArchiverAndUnarchiver

-(void)archiverPath:(NSString *)path andData:(id)responseObject andForKey:(NSString *)key
{
    //归档处理
    //一个Data对象存放数据
    NSMutableData * mData =[[NSMutableData alloc] init];
    //数据
    NSDictionary * aDict =responseObject;
    //归档人
    NSKeyedArchiver * archiver =[[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
    //归档人编码
    [archiver encodeObject:aDict forKey:key];
    //归档人完成编码
    [archiver finishEncoding];
    //Data对象保存数据
    [mData writeToFile:path atomically:YES];
}

@end
