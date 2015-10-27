//
//  SelectedPindaoTVC.h
//  DaGangCheng
//
//  Created by huaxo on 14-7-29.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pindao.h"
@class SelectedPindaoTVC;
@protocol SelectedPindaoDelegate <NSObject>
- (void)SelectedPindaoTVC:(SelectedPindaoTVC *)tvc selectedPindao:(Pindao *)pindao;
@end
@interface SelectedPindaoTVC : UITableViewController
@property (strong, nonatomic) Pindao *selectedPindao;
@property (weak, nonatomic) id<SelectedPindaoDelegate>delegate;
@end
