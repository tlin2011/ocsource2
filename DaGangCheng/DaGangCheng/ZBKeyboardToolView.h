//
//  ZBKeyboardToolView.h
//  DaGangCheng
//
//  Created by huaxo on 15-3-4.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBKeyboardToolView : UIView
- (void)initSubviews;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
@end
