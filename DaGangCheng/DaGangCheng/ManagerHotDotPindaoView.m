//
//  ManagerHotDotPindaoView.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-24.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ManagerHotDotPindaoView.h"
#define PindaoTitleHeight 40
#define PindaoTitleTopHeight 44
#define PindaoTitleLeftWidth 10
#define PindaoTitleHorizontalSpacing 2
#define PindaoTitleVerticalSpacing 2

@interface ManagerHotDotPindaoView () {

    CGFloat PindaoTitleWidth;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger from;
@property (nonatomic, assign) NSInteger to;
@property (nonatomic, strong) NSMutableArray *ivs;
@property (nonatomic, strong) NSMutableArray *delIvs;

@property (nonatomic) CGAffineTransform oldTransForm;


@end

@implementation ManagerHotDotPindaoView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void) initSubviews {
    self.backgroundColor = [UIColor whiteColor];
    //lab
    CGRect labFrame = self.bounds;
    labFrame.size.height = 34;
    UILabel *lab = [[UILabel alloc] initWithFrame:labFrame];
    lab.text = [NSString stringWithFormat:@"   %@", GDLocalizedString(@"长按拖动排序")];
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = UIColorFromRGB(0x7d8187);
    lab.backgroundColor = UIColorFromRGB(0xebeff0);
    [self addSubview:lab];
    
    PindaoTitleWidth = (self.frame.size.width - 2*PindaoTitleLeftWidth + PindaoTitleHorizontalSpacing) / 4.0 - PindaoTitleHorizontalSpacing;
}

- (void)show{
    NSArray *list = [NaviPindao unarchiverDisplayList];
    self.ivs = [NSMutableArray array];
    for (int i=0; i<[list count]; i++) {
        //lab
        NaviPindaoView *pv = [[NaviPindaoView alloc]initWithFrame:CGRectMake(PindaoTitleLeftWidth + i%4*(PindaoTitleWidth + PindaoTitleHorizontalSpacing), i/4*(PindaoTitleHeight + PindaoTitleVerticalSpacing) + PindaoTitleTopHeight, PindaoTitleWidth, PindaoTitleHeight)];
        pv.tag = i;
        self.oldTransForm = pv.transform;
        
        NaviPindao *pindao = list[i];
        pv.titleLab.text = [NSString stringWithFormat:@"%@",pindao.name];
        pv.pindao = pindao;
        [self addSubview:pv];
        UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longAction:)];
        [pv addGestureRecognizer:longP];
        [self.ivs addObject:pv];
        if ([pindao.ID isEqualToString:@"1"]) {
            pv.delBtn.hidden = YES;
        }
        [pv.delBtn addTarget:self action:@selector(clickedDelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self displayDelView];
    
    
}

- (void)updateDisplayView {
    for (int i=0; i<[self.ivs count]; i++) {
        //lab
        NaviPindaoView *pv = self.ivs[i];
        pv.frame = CGRectMake(PindaoTitleLeftWidth + i%4*(PindaoTitleWidth + PindaoTitleHorizontalSpacing), i/4*(PindaoTitleHeight + PindaoTitleVerticalSpacing) + PindaoTitleTopHeight, PindaoTitleWidth, PindaoTitleHeight);
        pv.tag = i;
        [self addSubview:pv];
    }
}

- (void)displayDelView {
    NSArray *delList = [NaviPindao unarchiverDeleteList];
    if ([delList count]<=0) {
        return;
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.clipsToBounds = YES;
    [self addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    //去掉 homeScrollView 下面的滚动条
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    CGRect frame = self.frame;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 34)];
    lab.backgroundColor = UIColorFromRGB(0xebeff0);
    lab.textColor = UIColorFromRGB(0x7d8187);
    lab.font = [UIFont systemFontOfSize:13];
    lab.text = [NSString stringWithFormat:@"  %@", GDLocalizedString(@"点击添加")];
    [self.scrollView addSubview:lab];
    NSArray *list = [NaviPindao unarchiverDisplayList];
    float scrollViewY = PindaoTitleTopHeight + (list.count/4+([list count]%4==0?0:1))*(PindaoTitleHeight+PindaoTitleVerticalSpacing) + 10;
    self.scrollView.frame = CGRectMake(0, scrollViewY, frame.size.width, self.frame.size.height-scrollViewY);
    
    self.delIvs = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[delList count]; i++) {
        NaviPindaoDelView *pd = [[NaviPindaoDelView alloc]initWithFrame:CGRectMake(PindaoTitleLeftWidth + i%4*(PindaoTitleWidth + PindaoTitleHorizontalSpacing), i/4*(PindaoTitleHeight + PindaoTitleVerticalSpacing) + PindaoTitleTopHeight, PindaoTitleWidth, PindaoTitleHeight)];
        
        NaviPindao *pindao = delList[i];
        pd.pindao = pindao;
        [pd.titleBtn setTitle:pindao.name forState:UIControlStateNormal];
        [pd.titleBtn addTarget:self action:@selector(clickedAddBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:pd];
        [self.delIvs addObject:pd];
    }
    float scrollViewHeight = PindaoTitleTopHeight + (delList.count/4+1)*(PindaoTitleHeight+PindaoTitleVerticalSpacing);
    self.scrollView.contentSize = CGSizeMake(0, scrollViewHeight);
}

- (void)updatedisplayDelView {
    NSArray *delList = [NaviPindao unarchiverDeleteList];

    if ([delList count]<=0) {
        self.scrollView.frame = CGRectZero;
        return;
    }
    
    if (!self.scrollView) {
        [self displayDelView];
    }else {
    
        CGRect frame = self.frame;
        NSArray *list = [NaviPindao unarchiverDisplayList];
        float scrollViewY = PindaoTitleTopHeight + (list.count/4+([list count]%4==0?0:1))*(PindaoTitleHeight+PindaoTitleVerticalSpacing) + 10;
        self.scrollView.frame = CGRectMake(0, scrollViewY, frame.size.width, self.frame.size.height-scrollViewY);
        
        //self.delIvs = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[self.delIvs count]; i++) {
            NaviPindaoDelView *pd = self.delIvs[i];
            pd.frame = CGRectMake(PindaoTitleLeftWidth + i%4*(PindaoTitleWidth + PindaoTitleHorizontalSpacing), i/4*(PindaoTitleHeight + PindaoTitleVerticalSpacing) + PindaoTitleTopHeight, PindaoTitleWidth, PindaoTitleHeight);
    //        pv.tag = i;
    //        
    //        NaviPindao *pindao = pv.pindao;
    //        pv.titleLab.text = [NSString stringWithFormat:@"%@",pindao.name];
            
            [self.scrollView addSubview:pd];
            //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            //[pv addGestureRecognizer:tap];
            //[self.delIvs addObject:pd];
        }
        float scrollViewHeight = PindaoTitleTopHeight + (delList.count/4+1)*(PindaoTitleHeight+PindaoTitleVerticalSpacing);
        self.scrollView.contentSize = CGSizeMake(0, scrollViewHeight);
    }
}

- (void)clickedAddBtn:(UIButton *)sender {
    NSLog(@"del");
    NaviPindaoView *pd = (NaviPindaoView *)[sender superview];
    [pd removeFromSuperview];
    
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    [mArr addObjectsFromArray:[NaviPindao unarchiverDisplayList]];
    NSArray *arr = [NaviPindao arr:[mArr copy]addNaviPindao:pd.pindao];
    [NaviPindao archiveDisplayList:arr];
    //self.dataList = mArr;
    NSArray *delList = [NaviPindao unarchiverDeleteList];
    [NaviPindao archiveDeleteList:[NaviPindao arr:delList removeNaviPindao:pd.pindao]];
    [self.delIvs removeObject:pd];

    NaviPindaoView *pv = [[NaviPindaoView alloc] initWithFrame:CGRectMake(0, 0, PindaoTitleWidth, PindaoTitleHeight)];
    pv.titleLab.text = pd.pindao.name;
    pv.pindao = pd.pindao;
    [self.ivs addObject:pv];
    
    UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longAction:)];
    [pv addGestureRecognizer:longP];
    self.oldTransForm = pv.transform;
    [pv.delBtn addTarget:self action:@selector(clickedDelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateDisplayView];
    [self updatedisplayDelView];
}

- (void)clickedDelBtn:(UIButton *)sender {
    NSLog(@"del");
    NaviPindaoView *pv = (NaviPindaoView *)[sender superview];
    [pv removeFromSuperview];
    
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    [mArr addObjectsFromArray:[NaviPindao unarchiverDeleteList]];

    [NaviPindao archiveDeleteList:[NaviPindao arr:[mArr copy] addNaviPindao:pv.pindao]];
    NSArray *list = [NaviPindao unarchiverDisplayList];
    [NaviPindao archiveDisplayList:[NaviPindao arr:list removeNaviPindao:pv.pindao]];
    
    [self.ivs removeObject:pv];
    //[self.delIvs addObject:pv];
    NaviPindaoDelView *pindaoDel = [[NaviPindaoDelView alloc] initWithFrame:CGRectMake(0, 0, PindaoTitleWidth, PindaoTitleHeight)];
    [pindaoDel.titleBtn setTitle:pv.pindao.name forState:UIControlStateNormal];
    pindaoDel.pindao = pv.pindao;
    [pindaoDel.titleBtn addTarget:self action:@selector(clickedAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.delIvs addObject:pindaoDel];

    
    [self updateDisplayView];
    [self updatedisplayDelView];
}

-(void)longAction:(UILongPressGestureRecognizer *)longP{
    NaviPindaoView *dragIV = (NaviPindaoView*)longP.view;
    self.from = dragIV.tag;
    CGPoint p = [longP locationInView:self];
    //把点击到的图片前置
    [self.scrollView bringSubviewToFront:dragIV];
    switch ((int)longP.state) {
        case UIGestureRecognizerStateBegan:
        {
            [UIView animateWithDuration:.4 animations:^{
                dragIV.transform = CGAffineTransformScale(dragIV.transform, 1.5, 1.5);
            }];
        }
            break;
            
        case UIGestureRecognizerStateChanged:
            dragIV.center = p;
            //找到点击的坐标点着了哪张图片
            
            for (NaviPindaoView *iv in self.ivs) {
                if (CGRectContainsPoint(iv.frame, p)) {
                    if (self.from!=iv.tag) {
                        self.to = iv.tag;
                        [self.ivs removeObject:dragIV];
                        [self.ivs insertObject:dragIV atIndex:self.to];
                        
                        
                        [self updateUI];
                        
                        break;
                    }
                    
                }
            }
            
            break;
        case UIGestureRecognizerStateEnded:
            
            [UIView animateWithDuration:.4 animations:^{
                dragIV.transform = self.oldTransForm;
                dragIV.frame = CGRectMake(PindaoTitleLeftWidth + dragIV.tag%4*(PindaoTitleWidth + PindaoTitleHorizontalSpacing), dragIV.tag/4*(PindaoTitleHeight + PindaoTitleVerticalSpacing) + PindaoTitleTopHeight, PindaoTitleWidth, PindaoTitleHeight);
            }];
            break;
    }
    
}

-(void)updateUI{
    
    for (int i=0;i<self.ivs.count; i++) {
        NaviPindaoView *iv = self.ivs[i];
        
        if (self.from!=iv.tag) {
            [UIView animateWithDuration:.4 animations:^{
                iv.frame = CGRectMake(PindaoTitleLeftWidth + i%4*(PindaoTitleWidth + PindaoTitleHorizontalSpacing), i/4*(PindaoTitleHeight + PindaoTitleVerticalSpacing) + PindaoTitleTopHeight, PindaoTitleWidth, PindaoTitleHeight);
            }];
            
        }
        iv.tag = i;
        
    }
    
    
}

- (NSArray *)getNewList {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NaviPindaoView *lab in self.ivs) {
        NSString *pindaoName = [lab.titleLab text];
        NSArray *list = [NaviPindao unarchiverDisplayList];
        for (NaviPindao *p in list) {
            if ([p.name isEqualToString:pindaoName]) {
                [arr addObject:p];
            }
        }
    }
    [NaviPindao archiveDisplayList:arr];
    return arr;
}

- (void)dealloc {
    NSLog(@"ManagerHotDotPindaoView dealloc");
}

@end
