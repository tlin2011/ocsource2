//
//  MyCardViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-15.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "MyCardViewController.h"

@interface MyCardViewController ()

@end

@implementation MyCardViewController
@synthesize nameLabel,phoneText,qqText,emailText,homeAddrText,saveBtn,myCardInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    self.nameLabel.placeholder = GDLocalizedString(@"姓名");
    self.phoneText.placeholder = GDLocalizedString(@"手机");
    self.qqText.placeholder = @"QQ";
    self.emailText.placeholder = GDLocalizedString(@"邮箱");
    self.homeAddrText.placeholder = GDLocalizedString(@"家乡");
    //
    self.introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 180, 14)];
    self.introduceLabel.font = [UIFont systemFontOfSize:14];
    self.introduceLabel.textColor = UIColorFromRGB(0xceced3);
    self.introduceLabel.text = GDLocalizedString(@"简介");
    [self.introduceTV addSubview:self.introduceLabel];
    //
    self.nameLabel.delegate = self;
    self.phoneText.delegate = self;
    self.qqText.delegate = self;
    self.emailText.delegate = self;
    self.homeAddrText.delegate = self;
    self.introduceTV.delegate = self;
    
    self.introduceTV.layer.cornerRadius = 5;
    self.introduceTV.layer.masksToBounds = YES;
    self.introduceTV.layer.borderColor = UIColorFromRGB(0xcdcdcd).CGColor;
    self.introduceTV.layer.borderWidth = 0.5;
    
    [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveBtn setBackgroundColor:UIColorWithMobanTheme];
    self.saveBtn.layer.cornerRadius = 5;
    self.saveBtn.layer.masksToBounds = YES;
    [self.saveBtn setTitle:GDLocalizedString(@"保存名片") forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    
    [self query];
    
    
    
    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    
    longPressReger.minimumPressDuration = 2.0;
    
    [self.saveBtn addGestureRecognizer:longPressReger];
}



-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    NSString* msg= @"ibuger_xiaoqiao";
    [HuaxoUtil showMsg:msg title:@"Ver:2.0.111_150819"];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
       self.introduceLabel.text = GDLocalizedString(@"简介");
    }else{
        self.introduceLabel.text = @"";
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)query
{
    NetRequest * request =[NetRequest new];
    NSDictionary * parameters = @{@"uid":[HuaxoUtil getUdidStr]};
    [request urlStr:[ApiUrl getMyCardUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        if(![(NSNumber*)customDict[@"ret"] intValue])
        {
            NSLog(@"get-cardinfo failed!msg:%@",customDict[@"msg"]);
            return ;
        }
        self.myCardInfo = customDict;

        nameLabel.text = myCardInfo[@"name"];
        phoneText.text = myCardInfo[@"phone"];
        qqText.text = [NSString stringWithFormat:@"%@",myCardInfo[@"qq"]];
        emailText.text = myCardInfo[@"email"];
        homeAddrText.text = myCardInfo[@"home_addr"];
        

        self.introduceTV.text = myCardInfo[@"desc"];
        
        if (self.introduceTV.text.length!=0) {
            self.introduceLabel.text=@"";
        }
    }];
}

-(void)save:(UIButton *)sender
{
    [self.nameLabel resignFirstResponder];
    [self.phoneText resignFirstResponder];
    [self.qqText resignFirstResponder];
    [self.emailText resignFirstResponder];
    [self.homeAddrText resignFirstResponder];
    [self.introduceTV resignFirstResponder];
    
    [self.saveBtn setTitle:GDLocalizedString(@"保存中...") forState:UIControlStateNormal];
    
    NetRequest * request =[NetRequest new];
    NSString *desc = self.introduceTV.text;
    desc = desc?desc:@"";
    NSDictionary * parameters = @{@"uid":[HuaxoUtil getUdidStr],@"name":nameLabel.text,@"qq":qqText.text,@"phone":phoneText.text,@"email":emailText.text,@"home_addr":homeAddrText.text,@"desc":desc,@"short_num":@"10000"};
    [request urlStr:[ApiUrl saveMyCardUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        if(![customDict[@"ret"] intValue])
        {
            NSLog(@"get-cardinfo failed!msg:%@",customDict[@"msg"]);
            [HuaxoUtil showMsg:[NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"原因"),customDict[@"msg"]] title:GDLocalizedString(@"保存失败")];
            [self.saveBtn setTitle:GDLocalizedString(@"保存名片") forState:UIControlStateNormal];
            return ;
        }
        [self.saveBtn setTitle:GDLocalizedString(@"保存名片成功") forState:UIControlStateNormal];
    }];
}


- (void)back:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:self];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
