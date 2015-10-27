//
//  MyChargeOrderTableViewController.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/25.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CFAccountInfo;

@interface MyNoEnoughTableViewController : UITableViewController
@property(nonatomic,strong) NSString *goodsName;
@property(nonatomic,strong) NSString *integral;
@property(nonatomic,strong) NSString *currencyId;

@property(nonatomic,strong) CFAccountInfo *accountInfo;

@end
