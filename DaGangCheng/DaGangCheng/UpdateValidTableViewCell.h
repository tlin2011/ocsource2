//
//  UpdateValidTableViewCell.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/7.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol UpdatePhoneDelegate<NSObject>
- (void)getValidateCode;
@end

@interface UpdateValidTableViewCell : UITableViewCell

@property(nonatomic,strong)UITextField *textField;

@property(nonatomic,strong)UIButton *validButton;

@property (nonatomic, unsafe_unretained) id<UpdatePhoneDelegate> delegate;

@end
