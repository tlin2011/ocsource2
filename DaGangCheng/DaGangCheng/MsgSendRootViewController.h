//
//  MsgSendRootViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-25.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgSendViewController.h"


@interface MsgSendRootViewController : UINavigationController

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *msg;

@end
