//
//  MsgSendViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-25.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MsgSendViewControllerDelate <NSObject>
@optional
-(void)sendMsgSuccess:(NSNumber*)msgid msg:(NSString*)msg;

@end
@interface MsgSendViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *editView;

@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;

@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString* msg;

@property (nonatomic, strong)UITextView* fastTextView;

@property (weak, nonatomic)id<MsgSendViewControllerDelate> delegate;


@end
