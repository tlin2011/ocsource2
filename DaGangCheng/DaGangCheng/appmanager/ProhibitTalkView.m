//
//  ProhibitTalkView.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/9/23.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ProhibitTalkView.h"


@implementation ProhibitTalkView

UIButton *selectBtn;

-(id)initPTView{
    
    self=[super init];
    
    if (self) {
        [self initSubview];
    }
    return self;

}



-(void)initSubview{
    CGFloat viewWidth=260;
    CGFloat viewHeight=250;
    
    self.view=[[UIView alloc] initWithFrame:CGRectMake( (DeviceWidth-viewWidth)/2, (DeviceHeight-viewHeight)/2,viewWidth,viewHeight)];
    self.view.layer.masksToBounds=YES;
    [self.view.layer setCornerRadius:5.0];
    
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 48)];
    headerView.backgroundColor=UIColorFromRGB(0xdcdddd);
    
    UILabel *titleLable=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 210, 48)];
    titleLable.text=@"禁言";
    //GDLocalizedString(@"忘记密码")
    titleLable.font=[UIFont systemFontOfSize:18];
    titleLable.textColor=UIColorFromRGB(0x7e8a9b);
    titleLable.adjustsFontSizeToFitWidth = YES;
    [headerView addSubview:titleLable];
    
    
    UIButton  *closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLable.frame), 8, 32,32)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close_.png"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:closeBtn];
    
    
    [self.view addSubview:headerView];
    
    UIView *contentView=[[UIView alloc] initWithFrame:CGRectMake(0,48, viewWidth,viewHeight-48)];
    contentView.backgroundColor=[UIColor whiteColor];
    
    UILabel *userLable=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 36)];
    userLable.text=@"用       户";
    //GDLocalizedString(@"用户")
    userLable.font=[UIFont systemFontOfSize:14];
    userLable.textColor=UIColorFromRGB(0x32373e);
    [contentView addSubview:userLable];
    
    UILabel *showLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userLable.frame)+5, 0, 100, 36)];
//    showLable.text=@"小扯淡";
    showLable.font=[UIFont systemFontOfSize:14];
    showLable.textColor=UIColorFromRGB(0x32373e);
    showLable.adjustsFontSizeToFitWidth = YES;
    [contentView addSubview:showLable];
    
    
    
    UILabel *lineLable=[[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(showLable.frame),viewWidth-20, 1)];
    lineLable.backgroundColor=UIColorFromRGB(0xdcdddd);
    [contentView addSubview:lineLable];
    
    
    
    UILabel *timeLable=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineLable.frame), 70, 48)];
    timeLable.text=@"禁言时间";
//    GDLocalizedString(@"禁言时间")
    timeLable.font=[UIFont systemFontOfSize:14];
    timeLable.textColor=UIColorFromRGB(0x32373e);
    [contentView addSubview:timeLable];
    
    
    NSArray *timeArray=[NSArray arrayWithObjects:@"1天",@"3天",@"1个星期",@"1个月",@"永久", nil];
    int linenum =(int)(timeArray.count%2==0?timeArray.count/2:(timeArray.count/2)+1);
    UIView *timeView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userLable.frame)+5, CGRectGetMaxY(lineLable.frame)+5,viewWidth-110, linenum*35)];
    
    for (int i=0; i<timeArray.count; i++) {
        
        int row=i/2;
        int lie=i%2;
        
        CGFloat x=80*lie;
        CGFloat y=35*row+5;
        
        UIButton *oneDayBtn=[[UIButton alloc] initWithFrame:CGRectMake(x,y, 70, 28)];
        
        [oneDayBtn.layer setMasksToBounds:YES];
        [oneDayBtn setTitleColor:UIColorFromRGB(0x32373e) forState:UIControlStateNormal];
        [oneDayBtn.layer setBorderWidth:1.0];
        [oneDayBtn.layer setBorderColor:[UIColorFromRGB(0xdcdddd) CGColor]];
        [oneDayBtn.layer setCornerRadius:12.0];
        [oneDayBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [oneDayBtn setTitle:timeArray[i] forState:UIControlStateNormal];
        [oneDayBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        oneDayBtn.tag=100+i;
        if (i==0) {
            [self selectTime:oneDayBtn];
        }
        [timeView addSubview:oneDayBtn];
    }
    
    [contentView addSubview:timeView];
    
    UILabel *line2Lable=[[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(timeView.frame)+5,viewWidth-20, 1)];
    line2Lable.backgroundColor=UIColorFromRGB(0xdcdddd);
    [contentView addSubview:line2Lable];
    
    UIButton *okBtn=[[UIButton alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(line2Lable.frame)+5, viewWidth-20, 36)];
    [okBtn.layer setMasksToBounds:YES];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn.layer setCornerRadius:5.0];
    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [okBtn setTitle:GDLocalizedString(@"确定") forState:UIControlStateNormal];
    
    [okBtn addTarget:self action:@selector(clickOkBtn) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setBackgroundColor:UIColorFromRGB(0xFF8B00)];
    [contentView addSubview:okBtn];
    [self.view addSubview:contentView];
}



-(void)clickOkBtn{
    if ([self.prohibitTalkViewDelegate respondsToSelector:@selector(clickOk:)]) {
        [self.prohibitTalkViewDelegate clickOk:self];
    }
}

-(void)clickCloseBtn{
    if ([self.prohibitTalkViewDelegate respondsToSelector:@selector(closeDialog:)]) {
        [self.prohibitTalkViewDelegate closeDialog:self];
    }
}

-(void)selectTime:(UIButton *)btn{
    if (selectBtn) {
        [selectBtn.layer setBorderColor:[UIColorFromRGB(0xdcdddd) CGColor]];
    }
    [btn.layer setBorderColor:[UIColorFromRGB(0xff8b00) CGColor]];
    selectBtn=btn;
}


-(int)getMinuteBySelectTag{
    int result;
    if (!selectBtn) {
         result=24*60;
    }else{
        switch (selectBtn.tag) {
            case 100:
                result=24*60;
                break;
            case 101:
                result=3*24*60;
                break;
            case 102:
                result=7*24*60;
                break;
            case 103:
                result=30*24*60;
                break;
            case 104:
                result=3000*24*60;
                break;
        }
    }
    return result;
}

@end



