//
//  ZBTFaceImage.h
//  DaGangCheng
//
//  Created by huaxo on 15-1-9.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBTFaceImage : UIView

//表情转文字
//+ (NSString *)faceToWord:(NSString *)string runsArray:(NSMutableArray **)runArray;

//文字转表情
+ (NSString *)wordToFace:(NSString *)string;
//文字转表情，如果传入数组将返回所有匹配
+ (NSString *)wordToFace:(NSString *)string runsArray:(NSMutableArray **)runArray;

+ (NSString *)faceTextByFaceId:(NSString *)faceId;
+ (NSString *)faceIdByFaceText:(NSString *)faceText;

// 过滤ios自带emoji
+ (NSString *)stringContainsEmoji:(NSString *)string;
@end
