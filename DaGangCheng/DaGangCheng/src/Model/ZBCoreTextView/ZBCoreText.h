//
//  ZBCoreText.h
//  DaGangCheng
//
//  Created by huaxo on 15-6-17.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZBCoreTextKind) {
    /**
     * 文字.
     */
    ZBCoreTextKindText = 0,
    /**
     * 图片.
     */
    ZBCoreTextKindImage,
    /**
     * 语音.
     */
    ZBCoreTextKindVoice,
    /**
     * 超链.
     */
    ZBCoreTextKindSuperCS
};

@interface ZBCoreText : NSObject
@property (copy, nonatomic) NSString *string;
@property (assign, nonatomic) ZBCoreTextKind kind;
@property (assign, nonatomic) CGRect rect;     //rect缓存，提高性能。不用重复计算搞度。
@property (assign, nonatomic) NSInteger tag;  //通过其找到视图复用，提高性能。不用重复创建视图。
@property (strong, nonatomic) id kindData;     //用来挂载数据。
@property (assign, atomic) NSInteger state;  //网络加载状态。
@end
