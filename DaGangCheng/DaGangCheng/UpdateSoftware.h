//
//  UpdateSoftware.h
//  DaGangCheng
//
//  Created by huaxo on 14-11-14.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UpdateSoftware;

@protocol UpdateSoftwareDelegate <NSObject>

- (void)updateSoftwareDidClickedUpdateBtn;

@end

@interface UpdateSoftware : UIView <UIAlertViewDelegate>
@property (nonatomic, weak) id<UpdateSoftwareDelegate>delegate;
- (void)start;
@end
