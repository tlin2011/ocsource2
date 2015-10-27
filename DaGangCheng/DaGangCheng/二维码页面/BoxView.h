//
//  BoxView.h
//  DHT
//
//  Created by xiatian on 14-9-3.
//  Copyright (c) 2014年 xiatian. All rights reserved.
//

#import <UIKit/UIKit.h>

//扫描的菱形区域的边长
#define SCAN_WH 220.0f

@interface BoxView : UIView
{
    
}
@property (nonatomic, strong) UIView *rimView;
@end

@interface UIImageView (extension)

+ (UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)name tag:(NSInteger)tag;

@end

@interface UILabel (extension)

+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor
                  alignment:(NSTextAlignment)alignment
                        tag:(NSInteger)tag;
@end
@interface UIButton	(extension)

+(UIButton *)buttonWithFrame:(CGRect)frame
                       title:(NSString *)title
                 normalImage:(UIImage *)normalImage
              highlightImage:(UIImage *)highlightImage
               selectedImage:(UIImage *)selectedImage
                        font:(UIFont *)font
                      target:(id)target
                      action:(SEL)action
                controlEvent:(UIControlEvents)controlEvent
                         tag:(NSInteger)tag;
@end