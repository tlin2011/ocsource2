//
//  ZBCoreTextViewController.h
//  DaGangCheng
//
//  Created by huaxo on 15-6-17.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBCoreTextView.h"
@interface ZBCoreTextViewController : UIViewController<ZBCoreTextViewDelegate>

@property (strong, nonatomic) NSArray *rmArray;
@property (strong, nonatomic) UIScrollView *sv;

@end
