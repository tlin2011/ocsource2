//
//  ReportPost.h
//  DaGangCheng
//
//  Created by huaxo on 14-10-27.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBReport.h"
#import "Praise.h"

@interface ReportPost : NSObject <UIAlertViewDelegate>

- (id)initWithWithPostId:(NSString *)postId postUid:(NSString *)uid actKind:(NSString *)kind delegate:(id)delegate;

- (void)startReport;
@end
