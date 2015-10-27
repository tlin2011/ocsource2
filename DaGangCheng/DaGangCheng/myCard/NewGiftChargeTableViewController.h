//
//  NewGiftChargeTableViewController.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/9/28.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CFAccountInfo;

@interface NewGiftChargeTableViewController : UITableViewController

//@property(nonatomic,strong) NSString *goodsId;
//@property(nonatomic,strong) NSString *goodsName;
//@property(nonatomic,strong) NSString *goodsNum;
//@property(nonatomic,strong) NSString *integral;
//@property(nonatomic,strong) NSString *currencyId;
//@property(nonatomic,strong) NSString *currencyType;
//
//@property(nonatomic,strong) NSString *uid;
//@property(nonatomic,strong) NSString *appKind;
//@property(nonatomic,strong) NSString *token;
//
//@property(nonatomic,strong) NSString *info;
//@property(nonatomic,strong) NSString *callbackUrl;
//
//@property(nonatomic,strong) NSString *appId;
//

//
@property(nonatomic,strong) CFAccountInfo *accountInfo;



@property(nonatomic,strong) NSString *money;
@property(nonatomic,strong) NSString *integral;
@property(nonatomic,strong) NSString *currencyId;
@property(nonatomic,strong) NSString *currencyType;

@property(nonatomic,strong) NSString *uid;
@property(nonatomic,strong) NSString *appKind;
@property(nonatomic,strong) NSString *appId;
@property(nonatomic,strong) NSString *token;
@property(nonatomic,strong) NSString *param;
@property(nonatomic,strong) NSString *info;
@property(nonatomic,strong) NSArray *list;
@property(nonatomic,strong) NSString *callbackUrl;

@property(nonatomic,strong) NSString *diyTitle;
@property(nonatomic,strong) NSString *diyName;
@property(nonatomic,strong) NSString *diyMoney;
@property(nonatomic,strong) NSString *diyPassword;
@property(nonatomic,strong) NSString *diySureText;
@property(nonatomic,strong) NSString *diyCancelText;


@property(nonatomic,strong) NSNumber *userPoint;
@property(nonatomic,strong) NSString *mtitle;
@property(nonatomic,strong) NSString *detailsUrl;

@property(nonatomic,strong) NSString *orderName;




@end
