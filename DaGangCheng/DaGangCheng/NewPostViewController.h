//
//  NewPostViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-22.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommHead.h"
#import "Pindao.h"
#import "NewPostBoxView.h"
#import "PostViewController.h"

@interface NewPostViewController : UIViewController

@property (strong, nonatomic) UITextField *titleText;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) Pindao *selectedPindao; //当前选择的频道

@property (strong, nonatomic) NewPostBoxView *boxView;
@property (strong, nonatomic) UITextView *contentTV;
@property (strong, nonatomic) UILabel *msgLabel;


@property (strong, nonatomic) NSString *subTitle;
@property (strong, nonatomic) NSString *subContent;

@end
