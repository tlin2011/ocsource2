//
//  NewNoEnoughTabelViewController.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/9/30.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CFAccountInfo;

@interface NewNoEnoughTabelViewController : UITableViewController


@property(nonatomic,strong) NSString *goodsName;
@property(nonatomic,strong) NSString *integral;
@property(nonatomic,strong) NSString *currencyId;

@property(nonatomic,strong) CFAccountInfo *accountInfo;








@property(nonatomic,strong) NSArray *list;


@property(nonatomic,strong) NSString *diyTitle;
@property(nonatomic,strong) NSString *diyName;
@property(nonatomic,strong) NSString *diyMoney;
@property(nonatomic,strong) NSString *diyPassword;
@property(nonatomic,strong) NSString *diySureText;
@property(nonatomic,strong) NSString *diyCancelText;



@end
