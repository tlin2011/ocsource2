//
//  ZBTLoadingView.h
//  DaGangCheng
//
//  Created by huaxo on 14-9-17.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZBTLoadingViewMode) {
    ZBTLoadingViewModeLoading = 0, // 加载中
    ZBTLoadingViewModeNoInternetConnection = 1, //无网络连接
    ZBTLoadingViewModeServerBusy = 2 //服务器繁忙
};

@interface ZBTLoadingView : UIView
- (void)displayWithMode:(ZBTLoadingViewMode)mode;
@end
