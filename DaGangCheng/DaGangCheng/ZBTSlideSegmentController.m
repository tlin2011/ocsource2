//
//  JYSlideSegmentController.m
//  JYSlideSegmentController
//
//  Created by Alvin on 14-3-16.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import "ZBTSlideSegmentController.h"
#import "ManagerHotDotPindaoView.h"
#import "MBProgressHUD.h"
#import "NaviPindao.h"
#import "NaviButton.h"

#import "HotDotPindaoTableVC.h"
#import "HotPhotoPindaoTableVC.h"
#import "HotGeneralPindaoTableVC.h"
#import "HotNewInteractionTableVC.h"
#import "HotActivityPindaoTableVC2.h"

#import "ArchiverAndUnarchiver.h"
static NSString *dpfileName = @"DefaultPindaoListFile2";

#define SEGMENT_BAR_HEIGHT 32
#define INDICATOR_HEIGHT 3

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ZBTSlideSegmentController ()
<UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UIScrollView *segmentBar;
@property (nonatomic, strong, readwrite) UIScrollView *slideView;
@property (nonatomic, assign, readwrite) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) UIButton *selectPindaoBtn;
@property (nonatomic, strong) UIImageView *selectPindaoBtnBg;
@property (nonatomic, strong) ManagerHotDotPindaoView *managerView;

//@property (nonatomic, strong) UIView *
- (void)reset;

@end

@implementation ZBTSlideSegmentController
@synthesize viewControllers = _viewControllers;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self) {
        _viewControllers = [viewControllers copy];
        _selectedIndex = NSNotFound;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [self setupSubviews];
    [self reset];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGSize conentSize = CGSizeMake(self.view.frame.size.width * self.viewControllers.count, 0);
    [self.slideView setContentSize:conentSize];
}

#pragma mark - Setup
- (void)setupSubviews
{
    self.segmentBar.backgroundColor = UIColorFromRGB(0xe1e2e5);
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleColor = UIColorFromRGB(0x7d8187);
    self.titleBackgroundColor = UIColorFromRGB(0xe1e2e5);
    self.titleSelectedColor = [UIColor whiteColor];
    self.titleSelectedBackgroundCorlor = UIColorWithMobanTheme;
    
    // iOS7 set layout
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view addSubview:self.segmentBar];
    [self.view addSubview:self.slideView];
    
    //这句在segmentbar之后
    [self setupSelectPindaoBtn];
}

- (void)setupSelectPindaoBtn {
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(self.segmentBar.frame.origin.x + self.segmentBar.frame.size.width-6, self.segmentBar.frame.origin.y, self.view.bounds.size.width - (self.segmentBar.frame.origin.x + self.segmentBar.frame.size.width) + 6, self.segmentBar.frame.size.height)];
    [bg setImage:[UIImage imageNamed:@"点击向上收起bg.png"]];
    [self.view addSubview:bg];
    self.selectPindaoBtnBg = bg;
    //[bg setBackgroundImage:[UIImage imageNamed:@"点击向上收起bg.png"] forState:UIControlStateHighlighted];
    
    self.selectPindaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.segmentBar.frame.origin.x + self.segmentBar.frame.size.width-12, self.segmentBar.frame.origin.y, self.view.bounds.size.width - (self.segmentBar.frame.origin.x + self.segmentBar.frame.size.width) + 12, self.segmentBar.frame.size.height+12)];
    [self.selectPindaoBtn setImage:[UIImage imageNamed:@"点击向下展开.png"] forState:UIControlStateNormal];
    [self.selectPindaoBtn setImage:[UIImage imageNamed:@"点击向上收起.png"] forState:UIControlStateSelected];
    [self.selectPindaoBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 10, 0, 0)];
    
    [self.view addSubview:self.selectPindaoBtn];
    
    [self.selectPindaoBtn addTarget:self action:@selector(clickedSelectPindaoBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickedSelectPindaoBtn:(UIButton *)sender {
    
    NSArray *list = [NaviPindao unarchiverDisplayList];
    if (![list count]) {
        [self hudShowTextOnly:GDLocalizedString(@"没有读取到数据")];
        return;
    }
    
    if (sender.selected == NO) {
        sender.selected = YES;
        ManagerHotDotPindaoView *managerView = [[ManagerHotDotPindaoView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:managerView];
        [managerView show];
        self.managerView = managerView;
        [self.view bringSubviewToFront:self.selectPindaoBtnBg];
        [self.view bringSubviewToFront:self.selectPindaoBtn];
        
    } else {
        sender.selected = NO;
        
        NSArray *list = [self.managerView getNewList];
        NSArray *vcs = [self vcArrByArr:list];
        for (int i=0; i<[_viewControllers count]; i++) {
            UIViewController *vc = _viewControllers[i];
            [vc removeFromParentViewController];
        }
        _viewControllers = nil;
//        for (int i=0; i<[self.childViewControllers count]; i++) {
//            id v = self.childViewControllers[i];
//            v = nil;
//        }
        self.slideView = nil;
        _viewControllers = [vcs copy];
        [self setupSubviews];
        [self reset];
        //[self.segmentBar setNeedsDisplay];
        CGSize conentSize = CGSizeMake(self.view.frame.size.width * self.viewControllers.count, 0);
        [self.slideView setContentSize:conentSize];
        [self.managerView removeFromSuperview];
        //self.managerView = nil;
        
    }
}

- (NSArray *)vcArrByArr:(NSArray *)arr {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSMutableArray *vcs = [NSMutableArray array];
    for (int i=0; i<[arr count]; i++) {
        NaviPindao *pindao = arr[i];
        if ([pindao.ID isEqualToString:@"1"]) {
            HotDotPindaoTableVC *vc = [[HotDotPindaoTableVC alloc] initWithStyle:UITableViewStylePlain];
            vc.title = pindao.name;
            [vcs addObject:vc];
        } else if([pindao.ID isEqualToString:@"2"]){
            HotNewInteractionTableVC *vc = [[HotNewInteractionTableVC alloc] init];
            vc.title = pindao.name;
            [vcs addObject:vc];
        } else if([pindao.ID isEqualToString:@"3"] ){
            //            HotNewInteractionTableVC *vc = [[HotNewInteractionTableVC alloc] init];
            //            vc.title = @"语音";
        } else if([pindao.ID isEqualToString:@"-1"]){

            HotActivityPindaoTableVC2 *vc = [[HotActivityPindaoTableVC2 alloc] init];
            vc.title = pindao.name;
            [vcs addObject:vc];
        } else if([pindao.ID isEqualToString:@"0"]){
            HotPhotoPindaoTableVC *vc = [[HotPhotoPindaoTableVC alloc] initWithStyle:UITableViewStylePlain];
            vc.title = pindao.name;
            [vcs addObject:vc];
        } else if([pindao.ID integerValue] <100) {
        } else{
            HotGeneralPindaoTableVC *vc = [[HotGeneralPindaoTableVC alloc] initWithStyle:UITableViewStylePlain];
            vc.title = pindao.name;
            vc.pindaoId = pindao.ID;
            [vcs addObject:vc];
        }
    }
    return [vcs copy];
}

- (void)hudShowTextOnly:(NSString *)str {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
}


#pragma mark - Property
- (UIScrollView *)slideView
{
    if (!_slideView) {
        CGRect frame = self.view.bounds;
        frame.size.height -= _segmentBar.frame.size.height;
        frame.origin.y = CGRectGetMaxY(_segmentBar.frame);
        _slideView = [[UIScrollView alloc] initWithFrame:frame];
        [_slideView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth
                                         | UIViewAutoresizingFlexibleHeight)];
        [_slideView setShowsHorizontalScrollIndicator:NO];
        [_slideView setShowsVerticalScrollIndicator:NO];
        [_slideView setPagingEnabled:YES];
        [_slideView setBounces:NO];
        [_slideView setDelegate:self];
    }
    return _slideView;
}

- (UIScrollView *)segmentBar
{
    if (!_segmentBar) {
        CGRect frame = self.view.bounds;
        frame.size.height = SEGMENT_BAR_HEIGHT;
        _segmentBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-SEGMENT_BAR_HEIGHT, SEGMENT_BAR_HEIGHT)];
        _segmentBar.backgroundColor = [UIColor whiteColor];
        _segmentBar.delegate = self;
        _segmentBar.canCancelContentTouches = YES;
        [_segmentBar setShowsHorizontalScrollIndicator:NO];
        [_segmentBar setShowsVerticalScrollIndicator:NO];
        [_segmentBar setBounces:NO];
        [self setSegmentBarTitle];
    }
    
    return _segmentBar;
}

- (void)setIndicatorInsets:(UIEdgeInsets)indicatorInsets
{
    _indicatorInsets = indicatorInsets;
    CGRect frame = _indicator.frame;
    frame.origin.x = _indicatorInsets.left;
    CGFloat width = self.view.frame.size.width / self.viewControllers.count - _indicatorInsets.left - _indicatorInsets.right;
    frame.size.width = width;
    frame.size.height = INDICATOR_HEIGHT;
    _indicator.frame = frame;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) {
        return;
    }
    
    NSParameterAssert(selectedIndex >= 0 && selectedIndex < self.viewControllers.count);
    
    UIViewController *toSelectController = [self.viewControllers objectAtIndex:selectedIndex];
    
    // Add selected view controller as child view controller
    if (!toSelectController.parentViewController) {
        [self addChildViewController:toSelectController];
        CGRect rect = self.slideView.bounds;
        rect.origin.x = rect.size.width * selectedIndex;
        toSelectController.view.frame = rect;
        [self.slideView addSubview:toSelectController.view];
        [toSelectController didMoveToParentViewController:self];
    }
    _selectedIndex = selectedIndex;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    // Need remove previous viewControllers
    for (UIViewController *vc in _viewControllers) {
        [vc removeFromParentViewController];
    }
    _viewControllers = [viewControllers copy];
    [self reset];
}

- (NSArray *)viewControllers
{
    return [_viewControllers copy];
}

- (UIViewController *)selectedViewController
{
    return self.viewControllers[self.selectedIndex];
}

- (void)setSegmentBarTitle
{
    for (int i = 0; i<self.titles.count; i++) {
        id v = self.titles[i];
        if ([v isMemberOfClass:[NaviButton class]]) {
            [v removeFromSuperview];
        }
    }
    self.titles = [[NSMutableArray alloc] init];
    float btnX = 4.0;
    for (int i=0; i<self.viewControllers.count; i++) {
        UIViewController *vc = self.viewControllers[i];
        CGSize size = [vc.title sizeWithFont:[UIFont systemFontOfSize:15] forWidth:CGRectGetWidth(self.view.bounds) lineBreakMode:NSLineBreakByWordWrapping];
        size.width += 12 + 8;
        NaviButton * btn = [[NaviButton alloc] initWithFrame:CGRectMake(btnX, 0, size.width, CGRectGetHeight(_segmentBar.bounds))];
        btn.gapEdgeInsets = UIEdgeInsetsMake(6, 4, 6, 4);
        btnX += size.width;
        
        [btn setTitle:vc.title forState:UIControlStateNormal];
        btn.lab.textColor = self.titleColor;
        btn.lab.backgroundColor = self.titleBackgroundColor;
        [_segmentBar addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.titles addObject:btn];

        if (i == 0) {

            btn.lab.textColor = self.titleSelectedColor;
            btn.lab.backgroundColor = self.titleSelectedBackgroundCorlor;
        }
    }
    [_segmentBar setContentSize:CGSizeMake(btnX, 0)];
}

- (void)clickedBtn:(UIButton *)sender
{
    if (sender.tag < 0 || sender.tag >= self.viewControllers.count) {
        return;
    }
    
    UIViewController *vc = self.viewControllers[sender.tag];
    if ([_delegate respondsToSelector:@selector(slideSegment:didSelectedViewController:)]) {
        [_delegate slideSegment:_segmentBar didSelectedViewController:vc];
    }
    [self setSelectedIndex:sender.tag];
    [self scrollToViewWithIndex:self.selectedIndex animated:NO];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.slideView) {
        
        CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
        NSInteger index = ceilf(percent * self.viewControllers.count);
        //设置title的颜色
        for (NaviButton *btn in self.titles) {
            btn.lab.textColor = self.titleColor;
            btn.lab.backgroundColor = self.titleBackgroundColor;
        }
        NaviButton *button = self.titles[index];
        button.lab.textColor = self.titleSelectedColor;
        button.lab.backgroundColor = self.titleSelectedBackgroundCorlor;
        //移动title的位置
        CGRect frame = [_segmentBar convertRect:button.frame toView:self.view];
        if ((frame.origin.x + frame.size.width) > CGRectGetWidth(_segmentBar.bounds)) {
            CGPoint p = _segmentBar.contentOffset;
            p.x += (frame.origin.x + frame.size.width) - CGRectGetWidth(_segmentBar.bounds);
            [_segmentBar setContentOffset:p animated:YES];
        } else if (frame.origin.x<0) {
            CGPoint p = _segmentBar.contentOffset;
            p.x += frame.origin.x;
            [_segmentBar setContentOffset:p animated:YES];
        }
        
        if (index >= 0 && index < self.viewControllers.count) {
            [self setSelectedIndex:index];
        }
    }
}

#pragma mark - Action
- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated
{
    CGRect rect = self.slideView.bounds;
    rect.origin.x = rect.size.width * index;
    [self.slideView setContentOffset:CGPointMake(rect.origin.x, rect.origin.y) animated:animated];
}

- (void)reset
{
    _selectedIndex = NSNotFound;
    [self setSelectedIndex:0];
    [self scrollToViewWithIndex:0 animated:NO];
    [self setSegmentBarTitle];
    self.segmentBar.contentOffset = CGPointMake(0, 0);
}

@end

