//
//  MyChargeOrderTableViewController.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/25.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CFOrder.h"

@class CFCurrency;

@interface MyChargeOrderTableViewController : UITableViewController

@property(nonatomic,strong)CFOrder *chargeOrder;

@property(nonatomic,strong)CFCurrency *currency;;


@end
