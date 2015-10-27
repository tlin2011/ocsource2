//
//  selectLocationTVC.h
//  DaGangCheng
//
//  Created by huaxo on 14-7-24.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectLocationTVC;
@protocol SelectLocationDelegate <NSObject>
@optional
- (void)SelectLocationTVC:(SelectLocationTVC *)tvc selectedLocation:(NSString *)location;

- (void)SelectLocationTVC:(SelectLocationTVC *)tvc selectedLocation:(NSString *)location latitude:(NSString *)latitude longitude:(NSString *)longitude;
@end

@interface SelectLocationTVC : UITableViewController
@property (copy, nonatomic) NSString *selectedLocation;
@property (weak, nonatomic) id<SelectLocationDelegate>delegate;
@end
