//
//  ZBTLoadingView.m
//  DaGangCheng
//
//  Created by huaxo on 14-9-17.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ZBTLoadingView.h"
@interface ZBTLoadingView ()
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UILabel *label;
@end

@implementation ZBTLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    self.indicator = [[UIActivityIndicatorView alloc] init];
    [self addSubview:self.indicator];
    self.label = [[UILabel alloc] init];
    [self addSubview:self.label];
}

- (void)displayWithMode:(ZBTLoadingViewMode)mode {
    if (ZBTLoadingViewModeLoading == mode) {
        [self.indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        if (self.frame.size.height<60) {
            [self.indicator setCenter:CGPointMake(self.frame.size.width * 0.5, 15)];
        } else {
            [self.indicator setCenter:CGPointMake(self.frame.size.width * 0.5, 45)];
        }
        [self.indicator startAnimating];
        self.label.text = GDLocalizedString(@"加载中...");
        self.label.bounds = CGRectMake(0, 0, 80, 15);
        self.label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        self.label.textColor = [UIColor grayColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.center = CGPointMake(self.frame.size.width * 0.5, self.indicator.center.y + 25);
    } else if (ZBTLoadingViewModeNoInternetConnection == mode) {
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
