//
//  CreatePindaoTableVC.h
//  DaGangCheng
//
//  Created by huaxo on 14-10-23.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pindao.h"

typedef enum {
    PindaoModeCreatePindao = 0, // 创建频道
    PindaoModeSeePindaoInfo = 1, // 查看频道信息
    PindaoModeEditingPindao = 2  //编辑频道
}PindaoMode;


@interface CreatePindaoTableVC : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *pindaoIcoLab;
@property (weak, nonatomic) IBOutlet UILabel *pindaoNameLab;
@property (weak, nonatomic) IBOutlet UILabel *pindaoSettingLab;
@property (weak, nonatomic) IBOutlet UILabel *pindaoDescHiteLab;



@property (weak, nonatomic) IBOutlet UIImageView *pindaoImage;
@property (weak, nonatomic) IBOutlet UITextField *pindaoName;
@property (weak, nonatomic) IBOutlet UITextView *pindaoDesc;
@property (weak, nonatomic) IBOutlet UILabel *pindaoSettingLabel;
@property (weak, nonatomic) IBOutlet UILabel *pindaoDescHite;

@property (weak, nonatomic) IBOutlet UIButton *createPindaoBtn;
@property (weak, nonatomic) IBOutlet UILabel *pindaoAddr;
@property (weak, nonatomic) IBOutlet UILabel *pindaoAddrLabel;

@property (assign, nonatomic) PindaoMode pindaoMode;
@property (strong, nonatomic) Pindao *pindao;
@end
