//
//  MyChargeOrderTableViewController.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/25.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CFAccountInfo;

@interface MyGiftTableViewController : UITableViewController


@property(nonatomic,strong) NSString *goodsId;
@property(nonatomic,strong) NSString *goodsName;
@property(nonatomic,strong) NSString *goodsNum;
@property(nonatomic,strong) NSString *integral;
@property(nonatomic,strong) NSString *currencyId;
@property(nonatomic,strong) NSString *currencyType;

@property(nonatomic,strong) NSString *uid;
@property(nonatomic,strong) NSString *appKind;
@property(nonatomic,strong) NSString *token;

@property(nonatomic,strong) NSString *info;
@property(nonatomic,strong) NSString *callbackUrl;

@property(nonatomic,strong) NSString *appId;

@property(nonatomic,strong) NSNumber *userPoint;

@property(nonatomic,strong) CFAccountInfo *accountInfo;

@end
