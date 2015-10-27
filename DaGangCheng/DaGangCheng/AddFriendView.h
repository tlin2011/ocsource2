//
//  AddFriendView.h
//  DaGangCheng
//
//  Created by huaxo on 14-11-11.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    me = 0,
    
}user;

@interface AddFriendView : UIView
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *talkBtn;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, weak) UITableViewController *delegate;

- (id)initWithFrame:(CGRect)frame andUserId:(NSString *)uid;
@end
