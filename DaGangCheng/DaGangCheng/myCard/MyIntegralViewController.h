//
//  MyIntegralViewController.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/24.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyIntegralViewController : UIViewController

@property(nonatomic,strong)UIImageView *integralImage;

@property(nonatomic,strong)UILabel *integralLabel;

@property(nonatomic,strong)UIButton *chargeButton;

@property(nonatomic,strong)UIButton *giftButton;



 @property(nonatomic,copy)   NSString *currencyId;

 @property(nonatomic,copy)   NSString *accountId;

 @property(nonatomic,copy)   NSString *currency_type;



 @property(nonatomic,copy)   NSString *currency_name;

-(instancetype)initWithCurrencyId:(NSString *)currencyId accountId:(NSString *)accountId currencyType:(NSString *)currencyType currencyName:(NSString *)currencyName;


+ (void)setAccountId:(NSString *)accountId;
+ (NSString *)getAccountId;


@end
