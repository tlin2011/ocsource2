//
//  UpdatePhoneTableViewController.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/7.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UpdateValidTableViewCell.h"

@interface UpdatePhoneTableViewController : UITableViewController<UpdatePhoneDelegate>

@property(nonatomic,strong)NSString *phone;


@property(nonatomic,unsafe_unretained)UITableView *mtableView;

@end
