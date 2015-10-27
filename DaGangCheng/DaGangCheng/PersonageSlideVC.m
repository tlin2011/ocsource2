//
//  PersonageSlideVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PersonageSlideVC.h"
#import "PersonageSlideBackgroundView.h"

#import "PersonageFocusTableVC.h"
#import "PersonageCardTableVC.h"
#import "PersonageVisitorTableVC.h"
#import "PersonageDynamicTableVC.h"
#import "PersonageTopicTableVC.h"
#import "PersonageTableVC.h"

#define SEGMENT_BAR_HEIGHT 34
#define INDICATOR_HEIGHT 1.5

NSString * const PersonageSlideBarItemID = @"PersonageSlideBarItem";

@interface PersonageSlideBarItem : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation PersonageSlideBarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        self.backgroundColor = UIColorFromRGB(0xf0f1f3);
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        //
        _titleLabel.backgroundColor = UIColorFromRGB(0xf0f1f3);
        _titleLabel.textColor = UIColorFromRGB(0x6e7279);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        
        _titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end

@interface PersonageSlideVC ()
<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UICollectionView *segmentBar;
@property (nonatomic, strong, readwrite) UIScrollView *slideView;
@property (nonatomic, assign, readwrite) NSInteger selectedIndex;
@property (nonatomic, strong, readwrite) UIView *indicator;
@property (nonatomic, strong) UIView *indicatorBgView;

@property (nonatomic, strong) UICollectionViewFlowLayout *segmentBarLayout;


- (void)reset;

@end

@implementation PersonageSlideVC
@synthesize viewControllers = _viewControllers;


- (id)initWithUserId:(NSString *)uid {
    self = [super init];
    if (self) {
        self.userId = uid;
        //self.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        //self.indicator.backgroundColor = UIColorWithMobanTheme;
        
        NSMutableArray *vcs = [NSMutableArray array];
        PersonageTopicTableVC *vc1 = [[PersonageTopicTableVC alloc] init];
        vc1.userId = uid;
        vc1.title = GDLocalizedString(@"话题");
        PersonageDynamicTableVC *vc2 = [[PersonageDynamicTableVC alloc] init];
        vc2.title = GDLocalizedString(@"动态");
        vc2.userId = uid;
        PersonageFocusTableVC *vc3 = [[PersonageFocusTableVC alloc] init];
        NSString *vc3Title = [ZBAppSetting standardSetting].unfocusName;
        vc3.title = vc3Title;
        vc3.userId = uid;
        PersonageVisitorTableVC *vc4 = [[PersonageVisitorTableVC alloc] init];
        vc4.title = GDLocalizedString(@"访客");
        vc4.userId = uid;
        PersonageCardTableVC *vc5 = [[PersonageCardTableVC alloc] init];
        vc5.title = GDLocalizedString(@"名片");
        vc5.userId = uid;
        [vcs addObject:vc1];
        [vcs addObject:vc2];
        [vcs addObject:vc3];
        [vcs addObject:vc4];
        [vcs addObject:vc5];
        _viewControllers = [vcs copy];
        _selectedIndex = NSNotFound;
    }
    return self;
}

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
    [super viewDidLoad];    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personageTableVCUp) name:@"PersonageTableVCUp" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personageTableVCDown) name:@"PersonageTableVCDown" object:nil];
    [self initSubviews];
    
    
    [self setupSubviews];
    [self reset];
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
    // iOS7 set layout
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view addSubview:self.segmentBar];
    [self.view addSubview:self.slideView];
    [self.segmentBar registerClass:[PersonageSlideBarItem class] forCellWithReuseIdentifier:PersonageSlideBarItemID];
    [self.segmentBar addSubview:self.indicatorBgView];
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

- (UICollectionView *)segmentBar
{
    if (!_segmentBar) {
        CGRect frame = self.view.bounds;
        frame.origin.y = 200;
        frame.size.height = SEGMENT_BAR_HEIGHT;
        _segmentBar = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.segmentBarLayout];
        _segmentBar.backgroundColor = [UIColor whiteColor];
        _segmentBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _segmentBar.delegate = self;
        _segmentBar.dataSource = self;
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
        [separator setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        //[separator setBackgroundColor:UIColorFromRGB(0xdcdcdc)];
        [separator setBackgroundColor:[UIColor whiteColor]];
        [_segmentBar addSubview:separator];
    }
    return _segmentBar;
}

- (UIView *)indicatorBgView
{
    if (!_indicatorBgView) {
        CGRect frame = CGRectMake(0, self.segmentBar.frame.size.height - INDICATOR_HEIGHT - 1,
                                  self.view.frame.size.width / self.viewControllers.count, INDICATOR_HEIGHT);
        _indicatorBgView = [[UIView alloc] initWithFrame:frame];
        _indicatorBgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _indicatorBgView.backgroundColor = [UIColor clearColor];
        [_indicatorBgView addSubview:self.indicator];
    }
    return _indicatorBgView;
}

- (UIView *)indicator
{
    if (!_indicator) {
        CGFloat width = self.view.frame.size.width / self.viewControllers.count - self.indicatorInsets.left - self.indicatorInsets.right;
        CGRect frame = CGRectMake(self.indicatorInsets.left, 0, width, INDICATOR_HEIGHT);
        _indicator = [[UIView alloc] initWithFrame:frame];
        _indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _indicator.backgroundColor = UIColorWithMobanTheme;
    }
    return _indicator;
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

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    if (!_segmentBarLayout) {
        _segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
        _segmentBarLayout.itemSize = CGSizeMake(self.view.frame.size.width / self.viewControllers.count, SEGMENT_BAR_HEIGHT);
        _segmentBarLayout.sectionInset = UIEdgeInsetsZero;
        _segmentBarLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _segmentBarLayout.minimumLineSpacing = 0;
        _segmentBarLayout.minimumInteritemSpacing = 0;
    }
    return _segmentBarLayout;
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

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([_dataSource respondsToSelector:@selector(numberOfSectionsInslideSegment:)]) {
        return [_dataSource numberOfSectionsInslideSegment:collectionView];
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_dataSource respondsToSelector:@selector(slideSegment:numberOfItemsInSection:)]) {
        return [_dataSource slideSegment:collectionView numberOfItemsInSection:section];
    }
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataSource respondsToSelector:@selector(slideSegment:cellForItemAtIndexPath:)]) {
        return [_dataSource slideSegment:collectionView cellForItemAtIndexPath:indexPath];
    }
    
    PersonageSlideBarItem *segmentBarItem = [collectionView dequeueReusableCellWithReuseIdentifier:PersonageSlideBarItemID
                                                                                 forIndexPath:indexPath];
    UIViewController *vc = self.viewControllers[indexPath.row];
    segmentBarItem.titleLabel.text = vc.title;
    return segmentBarItem;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
        return;
    }
    
    UIViewController *vc = self.viewControllers[indexPath.row];
    if ([_delegate respondsToSelector:@selector(slideSegment:didSelectedViewController:)]) {
        [_delegate slideSegment:collectionView didSelectedViewController:vc];
    }
    [self setSelectedIndex:indexPath.row];
    [self scrollToViewWithIndex:self.selectedIndex animated:NO];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
        return NO;
    }
    
    BOOL flag = YES;
    UIViewController *vc = self.viewControllers[indexPath.row];
    if ([_delegate respondsToSelector:@selector(slideSegment:shouldSelectViewController:)]) {
        flag = [_delegate slideSegment:collectionView shouldSelectViewController:vc];
    }
    return flag;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.slideView) {
        // set indicator frame
        CGRect frame = self.indicatorBgView.frame;
        CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
        frame.origin.x = scrollView.frame.size.width * percent;
        self.indicatorBgView.frame = frame;
        
        NSInteger index = ceilf(percent * self.viewControllers.count);
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
    [self.segmentBar reloadData];
}

#pragma mark - 初始化背景
- (void)initSubviews {
    
    CGRect bgFrame = self.view.bounds;
    bgFrame.origin.y = 0;
    bgFrame.size.height = 200;
    PersonageSlideBackgroundView *bg = [[PersonageSlideBackgroundView alloc] initWithFrame:bgFrame andUserId:self.userId];
    bg.myVC = self;
    [self.view addSubview:bg];
}

//向上位移
- (void)personageTableVCUp {
    CGRect segmentBarFrame = self.view.bounds;
    segmentBarFrame.origin.y = 0;
    segmentBarFrame.size.height = SEGMENT_BAR_HEIGHT;

    CGRect slideViewFrame = self.view.bounds;
    slideViewFrame.size.height -= _segmentBar.frame.size.height;
    slideViewFrame.origin.y = CGRectGetMaxY(_segmentBar.frame);

    
    if (![self isEqualtoRect1:segmentBarFrame andRect2:self.segmentBar.frame] || ![self isEqualtoRect1:slideViewFrame andRect2:self.slideView.frame]) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.segmentBar.frame = segmentBarFrame;
            self.slideView.frame = slideViewFrame;
        } completion:nil];
    }

}
//向下位移

- (void)personageTableVCDown {
    CGRect segmentBarFrame = self.view.bounds;
    segmentBarFrame.origin.y = 200;
    segmentBarFrame.size.height = SEGMENT_BAR_HEIGHT;
    
    CGRect slideViewFrame = self.view.bounds;
    slideViewFrame.size.height -= _segmentBar.frame.size.height;
    slideViewFrame.origin.y = CGRectGetMaxY(_segmentBar.frame);

    if (![self isEqualtoRect1:segmentBarFrame andRect2:self.segmentBar.frame] || ![self isEqualtoRect1:slideViewFrame andRect2:self.slideView.frame]) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.segmentBar.frame = segmentBarFrame;
            self.slideView.frame = slideViewFrame;
        } completion:nil];
    }
}

- (BOOL)isEqualtoRect1:(CGRect)r1 andRect2:(CGRect)r2 {
    if (r1.origin.x==r2.origin.x && r1.origin.y==r2.origin.y && r1.size.width==r2.size.width && r1.size.height==r2.size.height) {
        return YES;
    }
    return NO;
}

- (void)back:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

