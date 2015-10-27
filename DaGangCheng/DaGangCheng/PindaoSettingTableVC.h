//
//  PindaoSettingTableVC.h
//  DaGangCheng
//
//  Created by huaxo on 14-11-7.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PindaoSettingTableVC;

@protocol PindaoSettingDelegate <NSObject>

- (void)pindaoSettingTableVC:(PindaoSettingTableVC *)vc title:(NSString *)title value:(int)value;

@end

@interface PindaoSettingTableVC : UITableViewController
@property (nonatomic, weak) id<PindaoSettingDelegate> delegate;
@end
