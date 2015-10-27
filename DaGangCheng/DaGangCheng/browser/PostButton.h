//
//  PostButton.h
//  UIWebViewTest
//
//  Created by huaxo2 on 15/9/11.
//  Copyright (c) 2015年 opencom. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]



@interface PostButton : UIButton


-(instancetype)initWithFrame:(CGRect)frame width:(CGFloat)width height:(CGFloat)height imageWidth:(CGFloat)btnWidth;

@end
