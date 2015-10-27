//
//  PersonageSlideBackgroundView.h
//  DaGangCheng
//
//  Created by huaxo on 14-11-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#

@interface PersonageSlideBackgroundView : UIView<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UIButton *head;
@property (strong, nonatomic) UILabel *name;

@property (strong, nonatomic) UIButton *prohibitBtn;

@property (strong, nonatomic) UIImageView *headBg;
@property (strong, nonatomic) UILabel *msgLabel;
@property (strong, nonatomic) UIImageView *recommendIco;
@property (strong, nonatomic) UIImageView *bg;
@property (strong, nonatomic) NSString *userId;

@property (weak, nonatomic) UIViewController *myVC;  // 所属控制器

- (id)initWithFrame:(CGRect)frame andUserId:(NSString *)uid;

@end
