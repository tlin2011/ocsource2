//
//  MsgBoxView.h
//  DaGangCheng
//
//  Created by huaxo on 15-1-20.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "replyBoxView.h"


@protocol MsgBoxViewDelegate <NSObject>
@optional
-(void)sendMsgSuccess:(NSNumber*)msgid msg:(NSString*)msg;

@end
@interface MsgBoxView : ReplyBoxView
@property (nonatomic, copy) NSString *toUid;
@property (nonatomic, weak) id<MsgBoxViewDelegate> msgDelegate;
@end
