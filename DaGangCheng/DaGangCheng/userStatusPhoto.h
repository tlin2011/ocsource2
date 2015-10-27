//
//  userStatusPhoto.h
//  DaGangCheng
//
//  Created by huaxo on 14-11-1.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"
#import "NotifyCenter.h"
#import "ApiUrl.h"
#import "SQLDataBase.h"
#import "HuaxoUtil.h"

@interface userStatusPhoto : UIView
@property (nonatomic, strong) UIImageView *headBg;
@property (nonatomic, strong) UIButton *head;
@property (nonatomic, weak) UIViewController *delegate;
@end
