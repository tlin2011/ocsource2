//
//  MyCardPkgTableViewController.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/21.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CFAccount;


@interface MyCardPkgTableViewController : UITableViewController


@property(nonatomic,strong) NSArray *accountList;


+(CFAccount *)getCFAccountObject;

@end
