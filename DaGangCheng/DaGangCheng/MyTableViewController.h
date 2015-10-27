//
//  MyTableViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-2-27.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"
#import "ApiUrl.h"
#import "MyCardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AFNetworking.h"
#import "NotifyCenter.h"
#import "SearchUserViewController.h"

#import "MyTableViewCell.h"
#import "MyTableViewHeadCell.h"
#import "MyTableViewMessageCell.h"
#import "ZBUser.h"

@interface MyTableViewController : UITableViewController<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MyTableViewMessageCellDelegate>

@property (weak, nonatomic) IBOutlet UIButton *upImage;


@property (strong, nonatomic) ZBUser *user;
@property (assign, nonatomic) NSInteger myDynamicTipNum;
@property (assign, nonatomic) NSInteger myTalkTipNum;

@property (strong, nonatomic) IBOutlet UIButton *myManage;
//@property (strong, nonatomic) IBOutlet UITableViewCell *myLoginCell;

//管理方法
- (IBAction)myManage:(UIButton *)sender;
@end
