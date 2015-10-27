//
//  PostViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-18.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PostViewController.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "PindaoIndexViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "AppDelegate.h"
#import "PostManagerView.h"
#import "PostZanAndReplyView.h"
#import "ReplyManagerView.h"
#import "Praise.h"
#import "HuaxoUtil.h"
#import "RecentlyVisitTableVC.h"
#import "PersonageSlideVC.h"
#import "ReplyBoxView.h"
#import "PraisePersonTableVC.h"
#import "ZBTSuperCSWebVC.h"
#import "LookPictureVC.h"
#import "SubReplyViewController.h"
#import "ReportPost.h"
#import "Post.h"
#import "ZBPraise.h"
#import "ZBCollection.h"
#import "ZBPostView.h"
#import "ZBPostReplyCell.h"
#import "ZBPostSubReplyCell.h"
#import "UITableView+separator.h"

#import "ZbtUserPm.h"
#import "MJExtension.h"

#import "NewLoginContoller.h"


#import "HudUtil.h"



//友盟统计
#import "MobClick.h"

#define ReplyRichTextWidth 250
#define ZBPostReplyCellContentWidth (DeviceWidth - 62 - 10)

@interface PostViewController ()<UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate, PostManagerViewDelegate, PostZanAndReplyViewDelegate, ReplyManagerViewDelegate, ISSShareViewDelegate, ReplyBoxViewDelegate,SubReplyDelegate, ZBPostViewDelegate,ZBPostReplyCellDelegate,ZBPostSubReplyCellDelegate>
{
    //ApiUrl * url;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    BOOL pullOrder;
    BOOL sortNow;
    int pm;
}
@property (nonatomic, assign) NSInteger currentRow;

@property (nonatomic, strong) ZBPostView *postView;

@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIActivityIndicatorView *activityInd;

@property (strong, nonatomic) PostZanAndReplyView *zanView;
@property (strong, nonatomic) ReplyBoxView *boxView;

@property (strong, nonatomic) NSString *praiseUsers;
@property (assign, nonatomic) NSInteger praiseNum;

@property (nonatomic, strong) ReportPost *report;
@property (nonatomic, copy) NSString *telephoneNumberStr;

@property (nonatomic, strong) Post *post;

@property (nonatomic, strong) NSString *shareUrl;

@end

@implementation PostViewController


ZbtUserPm *catchUserPm;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"更多操作_帖子_查看话题.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(managerBtnClicked:)];
    //
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    //显示赞和评论的数量
    PostZanAndReplyView *zanView = [[PostZanAndReplyView alloc] initWithFrame:CGRectMake(0,DeviceHeight - 44, DeviceWidth, 44)];
    zanView.delegate = self;
    [self.view addSubview:zanView];
    self.zanView = zanView;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 44, 0)];
    
    //点击浏览图片的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedImage:) name:@"clickedPostImage" object:nil];
    
    //点击超链的图片
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedSuperCSImage:) name:@"clickedPostSuperCSImage" object:nil];
    
    
    [self initUI];
    
    //[self addHeader];
    [self addFooter];
    [self requestPostInfo];
    
    
    
    
    [self requstUserPm];
    
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToTop)];
    tapGR.numberOfTapsRequired = 2;
    UILabel *topTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    topTitle.text = GDLocalizedString(@"查看话题");
    topTitle.textColor = UIColorWithMobanThemeSub;
    topTitle.textAlignment = NSTextAlignmentCenter;
    topTitle.userInteractionEnabled = YES;
    topTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    ZBLog(@"titleView------------------ %@", self.navigationItem.titleView);
    self.navigationItem.titleView = topTitle;
    [self.navigationItem.titleView addGestureRecognizer:tapGR];
    
}



-(void)requstUserPm{
    
}


- (ZBPostView *)postView {
    
    if (!_postView) {
        _postView = [[ZBPostView alloc] initWithFrame:CGRectZero];
        _postView.delegate = self;
        _postView.tableView = self.tableView;
        _tableView.tableHeaderView = self.postView;
    }
    return _postView;
}

#pragma mark - 回到话题顶部并刷新
- (void)backToTop
{
    ZBLog(@"%s", __func__);
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.tableView.contentOffset = CGPointMake(0, -64);
    } completion:^(BOOL finished) {
        [self requestPostInfo];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //设置查看话题内置网页的跳转控制器。
    [ZBAppSetting standardSetting].postController = self;
    
    CGRect rect = [self.postView convertRect:self.postView.fromPindaoName.frame fromView:self.view];
    NSLog(@"pindaoView frame %@",NSStringFromCGRect(rect));
    
    [self.tableView reloadData];
    
    //友盟统计
    [MobClick beginLogPageView:GDLocalizedString(@"看帖页面出现")];
}

/**
 *  view消失时更新上一个页面
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //友盟统计
    [MobClick endLogPageView:GDLocalizedString(@"看帖页面关闭")];
    
    Post *changedPost = [[Post alloc] init];
    changedPost.readNum = self.post.readNum;
    changedPost.zan = self.zanView.zanNum;
    changedPost.replyNum = self.zanView.replyNum;
    if ([self.delegate respondsToSelector:@selector(postViewController:withIndex:post:)]) {
        [self.delegate postViewController:self withIndex:self.index post:changedPost];
    }
}

- (void)initUI {
    
    self.title = GDLocalizedString(@"查看话题");
    
    //table没数据时,去掉线
    [self.tableView bottomSeparatorHidden];
    
    //创建加载框
    self.maskView = [[UIView alloc] initWithFrame:self.view.frame];
    self.activityInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityInd.center = self.maskView.center;
    [self.activityInd startAnimating];
    [self.maskView addSubview:self.activityInd];
    self.maskView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.maskView];
    
}

- (void)clickedSuperCSImage:(NSNotification *)sender {
    NSDictionary *info = sender.userInfo;
    ZBTSuperCSWebVC *vc = [[ZBTSuperCSWebVC alloc] init];
    vc.postId = self.postID;
    vc.title = info[@"link_name"];
    vc.urlStr = info[@"short_url"];
    //vc.urlStr = @"http://game.91.com/h5/";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//跳转指定行.
-(void)gotoRow:(NSInteger)row section:(NSInteger)section bottom:(BOOL)bottom animated:(BOOL) flag
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}
-(void)gotoRow:(NSInteger)row section:(NSInteger)section bottom:(BOOL)bottom
{
    [self gotoRow:row section:section bottom:bottom animated:YES];
}

#pragma mark - -- 上下拉刷新
- (void)addFooter
{
    __weak PostViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //[vc neRequestData:anyUrlStr];
        NSLog(@"我想知道有没有");
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        
        [vc requestReplys:refreshView];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.tableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return [self.praiseList count]>0?1:0;
    }else if (section == 1) {
        return self.replyList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        PostVisitorsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostVisitorsCell"];
        if (!cell) {
            cell = [[PostVisitorsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostVisitorsCell"];
        }
        
        cell.dataList = self.praiseList;
        cell.praiseNum = self.praiseNum;
        
        //去掉cell点击效果
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else{
        
        ZBPost *post = self.replyList[indexPath.row];
        
        if ([post isMemberOfClass:[ZBReply class]]) {
            
            static NSString *CellIdentifier = @"ZBPostReplyCell";
            ZBPostReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[ZBPostReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.reply = (ZBReply *)post;
            cell.indexPath = indexPath;
            cell.delegate = self;
            
            /**
             *  分割线
             */
            if (indexPath.row == 0) {
                cell.topLine.hidden = YES;
                cell.bottomLine.hidden = YES;
            } else if (indexPath.row == self.replyList.count-1) {
                cell.topLine.hidden = NO;
                cell.bottomLine.hidden = NO;
            } else {
                cell.topLine.hidden = NO;
                cell.bottomLine.hidden = YES;
            }
            if (self.replyList.count == 1) {
                cell.topLine.hidden = YES;
                cell.bottomLine.hidden = NO;
            }
            
            [cell updateUI];
            
            //去掉cell点击效果
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
        } else {
            
            static NSString *CellIdentifier = @"ZBPostSubReplyCell";
            ZBPostSubReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[ZBPostSubReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.subReply = (ZBSubReply *)post;
            cell.delegate = self;
            
            /**
             *  分割线
             */
            if (indexPath.row == self.replyList.count-1) {
                cell.bottomLine.hidden = NO;
            } else {
                cell.bottomLine.hidden = YES;
            }
            
            [cell layoutSubviews];
            
            //去掉cell点击效果
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
            
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 && indexPath.row ==0) {
        PraisePersonTableVC *vc = [[PraisePersonTableVC alloc] init];
        vc.title = GDLocalizedString(@"点赞的用户");
        vc.postId = self.postID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)clickedheadPortraitWithUid:(NSString *)uid {
    
    PersonageSlideVC *sc = [[PersonageSlideVC alloc] initWithUserId:uid];
    sc.title = GDLocalizedString(@"个人主页");
    sc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sc animated:YES];
}

- (void)clickedPindaoNameWithPindaoID:(NSString *)pindaoID {
    //1.得到总故事版
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PindaoIndexViewController *next = [board instantiateViewControllerWithIdentifier:@"PindaoIndexViewController"];
    
    //2.属性传值
    next.kind_id = pindaoID;
    
    //3.跳转,视图
    next.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:next animated:YES];
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 50;
    }
    else if (indexPath.section == 1)
    {
        ZBPost *post = self.replyList[indexPath.row];
        if ([post isMemberOfClass:[ZBReply class]]) {
            return [ZBPostReplyCell heightFromReply:(ZBReply *)post];
        } else {
            return [ZBPostSubReplyCell heightFromSubReply:(ZBSubReply *)post];
        }
        
    }
    return 44;
}

-(void)requestPostInfo
{
    ZBAppSetting *appsetting = [ZBAppSetting standardSetting];
    
    NSString* lng = appsetting.longitudeStr;
    NSString* lat = appsetting.latitudeStr;
    NSString *addr = appsetting.address;
    NSString *uid = [HuaxoUtil getUdidStr];
    
    self.postID = self.postID?self.postID:@"-1";
    
    
    NSDictionary * parameters =@{@"post_id": self.postID,
                                 @"uid": uid,
                                 @"need_pm": @"true",
                                 @"gps_lng": lng,
                                 @"gps_lat": lat,
                                 @"addr": addr,
                                 @"begin": @"0",
                                 @"len": @"10",
                                 @"need_flag": @"true",
                                 @"need_imgs":@"yes"
                                 };
    
    [NetRequest urlStr:[ApiUrl seeTopicUrlStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *customDict = responseObject;
        
        if(![customDict[@"ret"] intValue])
        {
            NSLog(@"getTopic failed,msg:%@",customDict);
            NSString* msg = [NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"原因"),customDict[@"msg"]];
            
            if ([customDict[@"msg"] isEqualToString:@"session_error"]) {
                msg = GDLocalizedString(@"会话超时！请重试.");
            }
            
            [Praise hudShowTextOnly:msg delegate:self];
            if (self.navigationController) {
                [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.5];
            }
            return ;
        }
        
        //评论
        NSArray *replyArr = customDict[@"list"];
        
        [self addListToReplyList:replyArr];
        
        self.post = [Post getPostByJson:customDict];
        
        pm = [customDict[@"pm"] intValue];
        NSString *str = customDict[@"praise_users"];
        NSLog(@"str %@",str);
        if (str && ![str isKindOfClass:[NSNull class]] && ![str isEqualToString:@"null"]) {
            self.praiseUsers = str;
        }else {
            self.praiseUsers = nil;
        }
        
        //请求赞的列表
        [self requestPraise];
        
        
        [self.tableView reloadData];
        
        //保存CS
        NSDictionary* log = [CSHistory getPostLog:[NSNumber numberWithLong:[self.post.postId integerValue]] title:self.post.title];
        [CSHistory addCSLog:log];
        
        /**
         *  帖子
         */
        //预处理数据
        NSArray *regularMatchArray = [ZBCoreTextRegularMatch arrayFromString:self.post.content];
        regularMatchArray = [ZBCoreTextGetSize regularMatchArrayHadHeightFromRegularMatchArray:regularMatchArray imageWHs:[ZBCoreTextGetSize coreTextImageHWsFromServerImageWHs:self.post.imageWHs]];
        //开始布局
        CGFloat postViewHeight = [ZBPostView heightFromRegularMatchArray:regularMatchArray post:self.post];
        CGRect postViewFrame = CGRectMake(0, 0, self.view.width, postViewHeight);
        
        self.postView.frame = postViewFrame;
        self.postView.regularMatchArray = regularMatchArray;
        self.postView.post = self.post;
        [self.postView updateData];
        
        //赞和评论数
        self.zanView.replyNum = self.post.replyNum;
        self.zanView.zanNum = self.post.zan;
        
        
        [ZBPraise isPraiseWithKindId:self.post.postId praisedUid:[HuaxoUtil getUdidStr] praiseKind:ZBPraiseKindPost completed:^(BOOL result, NSString *msg, NSError *error) {
            if (result) {
                self.zanView.zanBtn.selected = YES;
            }
        }];
        
        //友盟统计
        if (self.post.pindaoName && self.post.pindaoID && self.post.postId && self.post.title) {
            
            [MobClick event:@"seePost" attributes:@{@"pindao_name": self.post.pindaoName, @"pindao_id":[NSString stringWithFormat:@"%ld", (long)self.post.pindaoID], @"post_name":self.post.title, @"post_id":self.post.postId}];
        }
        
        //取消加载框
        [self.activityInd stopAnimating];
        [self.maskView removeFromSuperview];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *msg = nil;
        if (error.code == -1009) {
            msg = GDLocalizedString(@"请检查网络！");
        } else {
            msg = GDLocalizedString(@"请求超时！请重试。");
        }
        
        [Praise hudShowTextOnly:msg delegate:self];
        if (self.navigationController) {
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.5];
        }
    }];
}


- (void)addListToReplyList:(NSArray *)inArr{
    
    if (![inArr isKindOfClass:[NSArray class]]) {
        return;
    }
    
    if (!self.replyList || [self.replyList count]==0) {
        self.replyList = [[NSMutableArray alloc]init];
    }
    
    NSRange range = NSMakeRange(0,0);
    
    if (self.replyList.count) {
        ZBPost *post = [self.replyList lastObject];
        range.location = post.range.location + 1;
    }
    
    for (int i=0; i<[inArr count]; i++) {
        NSDictionary *json = inArr[i];
        if ([json isKindOfClass:[NSDictionary class]]) {
            
            ZBReply *reply = [ZBReply replyFromJson:json];
            
            range.length = 0;
            reply.range = range;
            [self.replyList addObject:reply];
            
            //预处理数据
            NSArray *regularMatchArray = [ZBCoreTextRegularMatch arrayFromString:reply.content];
            
            regularMatchArray = [ZBCoreTextGetSize regularMatchArrayHadHeightFromRegularMatchArray:regularMatchArray imageWHs:[ZBCoreTextGetSize coreTextImageHWsFromServerImageWHs:reply.imageWHs] font:[UIFont systemFontOfSize:17] lineSpace:6 width:ZBPostReplyCellContentWidth];
            reply.regularMatchArray = regularMatchArray;
            
            CGRect replyRect = CGRectZero;
            replyRect.size.height = [ZBCoreTextView heightFromRegularMatchArray:reply.regularMatchArray];
            reply.rect = replyRect;
            
            for (ZBSubReply *subReply in reply.subReplys) {
                
                range.length ++;
                subReply.range = range;
                
                //预处理数据
                //CGRect rect = [ZBRichTextView boundingRectWithSize:CGSizeMake(ZBPostReplyCellContentWidth, 999) font:[UIFont systemFontOfSize:17.0f] AttString:subReply.combinationContent];
                CGRect rect = [ZBRichTextView boundingRectWithSize:CGSizeMake(ZBPostReplyCellContentWidth, 999) font:[UIFont systemFontOfSize:14.0f] string:subReply.combinationContent lineSpace:4];
                
                rect.origin = CGPointMake(0, 0);
                rect.size.height = (NSInteger)rect.size.height;  //取整，防止文字顶部有黑线。
                subReply.rect = rect;
                
                [self.replyList addObject:subReply];
            }
            
            range.location ++;
        }
        
    }
}

//删除评论
- (void)removeReplyToReplyListWithIndex:(NSInteger)index {
    
    if (!self.replyList || [self.replyList count]==0) {
        self.replyList = [[NSMutableArray alloc]init];
    }
    ZBReply *reply = self.replyList[index];
    NSRange indexRange = reply.range;
    
    NSMutableArray *removeArray = [[NSMutableArray alloc] init];
    for (int i=index; i<[self.replyList count]; i++) {
        
        ZBPost *post = self.replyList[i];
        NSRange range = post.range;
        NSLog(@"post range %@",NSStringFromRange(range));
        if (range.location == indexRange.location) {
            
            [removeArray addObject:post];
        }
        
        if (range.location>indexRange.location) {
            range.location -= 1;
        }
        post.range = range;
    }
    NSLog(@"remove array count %ld", (long)removeArray.count);
    [self.replyList removeObjectsInArray:removeArray];
    
}

//插入子评论
- (void)insertSubReplyToReplyList:(NSDictionary *)subReplyJson index:(NSInteger)index{
    
    if (!self.replyList || [self.replyList count]==0) {
        self.replyList = [[NSMutableArray alloc]init];
    }
    
    ZBPost *post = self.replyList[index];
    
    NSRange range = NSMakeRange(post.range.location,0);
    
    NSDictionary *json = subReplyJson;
    if ([json isKindOfClass:[NSDictionary class]] && post.range.length==0) {
        
        ZBReply *reply = [ZBReply replyFromJson:json];
        
        for (ZBSubReply *subReply in reply.subReplys) {
            
            range.length ++;
            subReply.range = range;
            
            //预处理数据
            //CGRect rect = [ZBRichTextView boundingRectWithSize:CGSizeMake(ZBPostReplyCellContentWidth, 999) font:[UIFont systemFontOfSize:17.0f] AttString:subReply.combinationContent];
            CGRect rect = [ZBRichTextView boundingRectWithSize:CGSizeMake(ZBPostReplyCellContentWidth, 999) font:[UIFont systemFontOfSize:14.0f] string:subReply.combinationContent lineSpace:4];
            
            rect.origin = CGPointMake(0, 0);
            rect.size.height = (NSInteger)rect.size.height;  //取整，防止文字顶部有黑线。
            subReply.rect = rect;
        }
        //        NSInteger count = [reply.subReplys count];
        //        if (count) {
        //            [self.replyList insertObject:[reply.subReplys lastObject] atIndex:(index + count)];
        //        }
        
        for (int i = index; i<self.replyList.count; i++) {
            ZBPost *tempPost = self.replyList[i];
            BOOL isLastPost = self.replyList.count == i+1 && tempPost.range.location == post.range.location;
            if ((tempPost.range.location != post.range.location || isLastPost) && [reply.subReplys lastObject]) {
                if (isLastPost) {
                    [self.replyList addObject:[reply.subReplys lastObject]];
                } else {
                    [self.replyList insertObject:[reply.subReplys lastObject] atIndex:i];
                }
                break;
            }
        }
    }
}

#pragma mark -- ZBPostViewDelegate
- (void)postViewShouldRefresh:(ZBPostView *)postView {
    
    //开始布局
    CGFloat coreTextViewHeight = [ZBPostView heightFromRegularMatchArray:postView.regularMatchArray post:postView.post];
    CGRect coreTextViewFrame = CGRectMake(0, 0, self.view.frame.size.width, coreTextViewHeight);
    postView.frame = coreTextViewFrame;
    [postView layoutSubviews];
}
- (void)postView:(ZBPostView *)View clickedImageView:(UIImageView *)imageView imageID:(NSString *)imageID {
    NSLog(@"点击图片id:%@",imageID);
    [self clickedImageWithText:self.post.content imageID:imageID];
}
- (void)postView:(ZBPostView *)view textTouchEndRun:(ZBRichTextRun *)run {
    
    if ([run isKindOfClass:[ZBRichTextRunURL class]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:run.text]];
    } else if ([run isKindOfClass:[ZBRichTextRunTelephone class]]) {
        
        self.telephoneNumberStr = run.text;
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"拨打电话"),run.text]  message:GDLocalizedString(@"确定是否拨打该电话?") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"拨打"), nil];
        alertView.delegate = self;
        alertView.tag = 120;
        [alertView show];
    }
}
- (void)postView:(ZBPostView *)View clickedPindaoName:(NSString *)pindaoName pindaoID:(NSString *)pindaoID {
    [self clickedPindaoNameWithPindaoID:pindaoID];
}
- (void)postView:(ZBPostView *)View clickedHeadPortraitFromUid:(NSString *)uid imageID:(NSInteger)imageID {
    [self clickedheadPortraitWithUid:uid];
}


#pragma mark -- ZBPostReplyCellDelegate
- (void)postReplyCell:(ZBPostReplyCell *)replyCell clickedPraiseButton:(UIButton *)praiseButton Row:(NSInteger)row{
    
    [self praiseBtnClicked:praiseButton Row:row];
}
- (void)postReplyCell:(ZBPostReplyCell *)replyCell clickedReplyManagerButton:(UIButton *)managerButton row:(NSInteger)row {
    
    [self layerClicked:managerButton row:row];
}
- (void)postReplyCell:(ZBPostReplyCell *)View clickedHeadPortraitFromUid:(long)uid imageID:(long)imageID {
    
    [self clickedheadPortraitWithUid:[NSString stringWithFormat:@"%ld",uid]];
}
- (void)postReplyCell:(ZBPostReplyCell *)replyCell textTouchEndRun:(ZBRichTextRun *)run {
    
    if ([run isKindOfClass:[ZBRichTextRunURL class]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:run.text]];
    } else if ([run isKindOfClass:[ZBRichTextRunTelephone class]]) {
        
        self.telephoneNumberStr = run.text;
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@:%@", GDLocalizedString(@"拨打电话"),run.text]  message:GDLocalizedString(@"确定是否拨打该电话?") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"拨打"), nil];
        alertView.delegate = self;
        alertView.tag = 120;
        [alertView show];
    }
}
- (void)postReplyCell:(ZBPostReplyCell *)replyCell clickedImageView:(UIImageView *)imageView imageID:(NSString *)imageID {
    
    NSLog(@"点击图片id:%@",imageID);
    
    Post *post = [[Post alloc] init];
    post.imageWHs = replyCell.reply.imageWHs;
    [self clickedImageWithText:replyCell.reply.content imageID:imageID post:post];
}
- (void)postReplyCellShouldRefresh:(ZBPostReplyCell *)replyCell {
    [self.tableView reloadData];
}


#pragma mark -- ZBPostSubReplyCellDelegate
- (void)postSubReplyCell:(ZBPostSubReplyCell *)cell touchEndRun:(ZBRichTextRun *)run {
    if ([run isKindOfClass:[ZBRichTextRunURL class]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:run.text]];
    } else if ([run isKindOfClass:[ZBRichTextRunTelephone class]]) {
        
        self.telephoneNumberStr = run.text;
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@:%@", GDLocalizedString(@"拨打电话"),run.text]  message:GDLocalizedString(@"确定是否拨打该电话?") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"拨打"), nil];
        alertView.delegate = self;
        alertView.tag = 120;
        [alertView show];
    }
}


- (void)clickedImageWithText:(NSString *)text imageID:(NSString *)imageID {
    [self clickedImageWithText:text imageID:imageID post:self.post];
}

- (void)clickedImageWithText:(NSString *)text imageID:(NSString *)imageID post:(Post *)post{
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    NSString *string = text;
    
    NSString *selectedImgId = imageID;
    
    CGSize selectedImgSize = [post getImageWidthAndHeightByImageId:selectedImgId];
    
    if (selectedImgSize.width<30 || selectedImgSize.height<30) {
        return;
    }
    
    //正则表达式
    NSError *error;
    NSString *regulaStr = @"(\\[img:[0-9]{1,15}\\])";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [string substringWithRange:match.range];
        [mArr addObject:substringForMatch];
    }
    NSLog(@"marr: %@",mArr);
    
    NSMutableArray *imgIds = [[NSMutableArray alloc] init];
    for (int i = 0; i<[mArr count]; i++) {
        NSString *imageStr = mArr[i];
        NSString* imgId = [imageStr substringWithRange:NSMakeRange(5, [imageStr length]-6)];
        CGSize size = [post getImageWidthAndHeightByImageId:imgId];
        if (size.width<30 || size.height<30) {
        }else{
            [imgIds addObject:imgId];
        }
    }
    
    int index = 0;
    
    for (int i=0; i<[imgIds count]; i++) {
        NSString *imgId = imgIds[i];
        if ([imgId isEqualToString:selectedImgId]) {
            index = i;
            break;
        }
    }
    
    NSMutableArray *imgUrls = [[NSMutableArray alloc] init];
    for (NSString *imgId in imgIds) {
        [imgUrls addObject:[ApiUrl getImageUrlStrFromID:[imgId integerValue]]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickedPostImage" object:nil userInfo:@{@"imgUrlStrs":[imgUrls copy],@"index":@(index),@"btnSuperView":self}];
}

#pragma mark - 请求评论列表
-(void)requestReplys:(MJRefreshBaseView *)refreshView
{
    
    ZBPost *post = [self.replyList lastObject];
    NSString * strBegin = !post ? @"0" : [[NSString alloc] initWithFormat:@"%ld",(unsigned long)post.range.location + 1];
    
    //请求
    NetRequest * req =[[NetRequest alloc]init];
    NSDictionary*  parameret =@{
                                @"post_id":self.postID,
                                @"begin":strBegin,
                                @"len":@"10",
                                @"need_imgs":@"yes"
                                };
    
    //调用
    [req urlStr:(!pullOrder?[ApiUrl postReplysUrlStr]:[ApiUrl postLastReplysUrlStr]) parameters:parameret passBlock:^(NSDictionary *customDict) {
        
        BOOL sortYes = sortNow;
        sortNow = NO;
        
        if(![customDict[@"ret"] intValue])
        {
            NSLog(@"getReplys failed,msg:%@",customDict[@"msg"]);
            if (customDict[@"not_have"] && [customDict[@"not_have"] intValue] == 1) {
                [refreshView noHaveMoreData];
                return ;
            }
            [refreshView loadingDataFail];
            return ;
        }
        [refreshView endRefreshing];
        NSArray* list = customDict[@"list"];
        
        [self addListToReplyList:list];
        
        [self.tableView reloadData];
        
        if(sortYes){
            [self gotoRow:0 section:1 bottom:NO];
        }
    }];
}

- (void)managerBtnClicked:(UIButton *)sender{
    
    
    NetRequest * request =[NetRequest new];
    NSDictionary * parmeters = @{@"uid": [HuaxoUtil getUdidStr]};
    
    [request urlStr:[ApiUrl getUserPm] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        if ([customDict[@"ret"] integerValue]) {
            
            
            ZbtUserPm   *tempZbtUserPm = [ZbtUserPm objectWithKeyValues:customDict];
            
            catchUserPm=tempZbtUserPm;
            
            [self managerViewShow:tempZbtUserPm];
            
        }
    }];

}



-(void)managerViewShow:(ZbtUserPm *)tempZbtUserPm{
    NSMutableArray *arr = [NSMutableArray array];
    
    
    if ([tempZbtUserPm.pm intValue]==1) {
        
        if (_post.topFlag==1) {
            [arr addObject:@{@"title":@"取消置顶(热点)",@"image":@"热点置顶"}];
        }else{
            [arr addObject:@{@"title":@"置顶(热点)",@"image":@"热点置顶"}];
        }
        
        if ((_post.flag&0x01)>0) {
            [arr addObject:@{@"title":@"取消置顶(频道)",@"image":@"频道置顶"}];
        }else{
            [arr addObject:@{@"title":@"置顶(频道)",@"image":@"频道置顶"}];
        }
        
        [arr addObject:@{@"title":GDLocalizedString(@"删除话题"),@"image":@"删除话题_查看话题"}];
    }
    
    
    
    if ([tempZbtUserPm.pm intValue]==2) {
        
        if([tempZbtUserPm.kind_ids[0][@"kind_id"]  intValue]==0){
            
            if (_post.topFlag==1) {
                [arr addObject:@{@"title":@"取消置顶(热点)",@"image":@"热点置顶"}];
            }else{
                [arr addObject:@{@"title":@"置顶(热点)",@"image":@"热点置顶"}];
            }
            
            
            if([tempZbtUserPm.kind_ids[0][@"kind_id"] intValue]==0){
                if ((_post.flag&0x01)>0) {
                    [arr addObject:@{@"title":@"取消置顶(频道)",@"image":@"频道置顶"}];
                }else{
                    [arr addObject:@{@"title":@"置顶(频道)",@"image":@"频道置顶"}];
                }
            [arr addObject:@{@"title":GDLocalizedString(@"删除话题"),@"image":@"删除话题_查看话题"}];
            }
         }else{
                for(NSDictionary *dict in tempZbtUserPm.kind_ids) {
                    NSString *resultKindId= [dict[@"kind_id"] stringValue];
                    NSString *myKindId=_kindId;
                    if ([resultKindId isEqualToString:myKindId]) {
                        if ((_post.flag&0x01)>0) {
                            
                             [arr addObject:@{@"title":@"取消置顶",@"image":@"频道置顶"}];
                        }else{
                           [arr addObject:@{@"title":@"频道置顶",@"image":@"频道置顶"}];
                        }
                         [arr addObject:@{@"title":GDLocalizedString(@"删除话题"),@"image":@"删除话题_查看话题"}];
                        
                    }
                }
            }
    }
    
    
    NSArray *arr2 = @[@{@"title":GDLocalizedString(@"收藏话题"),@"image":@"收藏话题_查看话题"},
                      @{@"title":GDLocalizedString(@"举报话题"),@"image":@"举报话题_查看话题"},
                      @{@"title":GDLocalizedString(@"最近访客"),@"image":@"最近访客_查看话题"},
                      @{@"title":GDLocalizedString(@"分享话题"),@"image":@"分享话题_查看话题"},
                      @{@"title":GDLocalizedString(@"倒序查看"),@"image":@"倒序查看_查看话题"}];
    NSMutableArray *arr3 = [[NSMutableArray alloc] initWithArray:arr];
    [arr3 addObjectsFromArray:arr2];
    PostManagerView *managerView = [[PostManagerView alloc] initWithButtonTitles:arr3 delegate:self];
    [managerView show];

}

- (void)postManagerView:(PostManagerView *)view selectedButtonTitle:(NSString *)title {
    NSLog(@"title %@",title);
    
    
    if([title isEqualToString:GDLocalizedString(@"删除话题")]) {
        [self delPostBtnClicked:nil];
    } else if ([title isEqualToString:GDLocalizedString(@"收藏话题")]) {
        
        [ZBCollection collectionWithKindId:self.post.postId getCollectionUid:self.post.uid collectionUid:[HuaxoUtil getUdidStr] collectionKind:ZBCollectionKindPost completed:^(BOOL result, NSString *msg, NSError *error) {
            [Praise hudShowTextOnly:msg delegate:self];
        }];
    }else if ([title isEqualToString:GDLocalizedString(@"最近访客")]) {
        
        [self intoRecentlyVisitTableVCWithPostId:self.postID];
    } else if ([title isEqualToString:GDLocalizedString(@"分享话题")]) {
        
        UIView *v = [[UIView alloc] init];
        v.tag = 2;
        [self toolBarBtnClicked:v];
    } else if ([title isEqualToString:GDLocalizedString(@"倒序查看")]) {
        
        UIView *v = [[UIView alloc] init];
        v.tag = 1;
        [self toolBarBtnClicked:v];
    } else if ([title isEqualToString:GDLocalizedString(@"举报话题")]) {
        
        ReportPost *report = [[ReportPost alloc] initWithWithPostId:self.postID postUid:(self.post.uid?self.post.uid:@"0") actKind:@"1" delegate:self];
        [report startReport];
        self.report = report;
    } else if ([title isEqualToString:GDLocalizedString(@"置顶(频道)")]) {
        
        [self setPostTop:self.postID];
    } else if ([title isEqualToString:GDLocalizedString(@"置顶(热点)")]) {
        
        [self handleHotPostTop:self.postID topFlag:1];
        
    } else if ([title isEqualToString:GDLocalizedString(@"取消置顶(频道)")]) {
        
        [self cancelPostTop:self.postID];
    } else if ([title isEqualToString:GDLocalizedString(@"取消置顶(热点)")]) {
        
        [self handleHotPostTop:self.postID topFlag:0];
        
    } else if ([title isEqualToString:GDLocalizedString(@"频道置顶")]) {
         [self setPostTop:self.postID];
    } else if ([title isEqualToString:GDLocalizedString(@"取消置顶")]) {
         [self cancelPostTop:self.postID];
    }else {}
}




//取消置顶
-(void)cancelPostTop:(NSString *)postId{
    
    NetRequest * request =[NetRequest new];
    NSDictionary * parmeters = @{@"uid": [HuaxoUtil getUdidStr],
                                 @"post_id":postId,
                                 @"flag":@0x01};
    
    [request urlStr:[ApiUrl getCancelPostTop] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
        if(customDict[@"ret"]){
             _post.flag=0;
             [HudUtil showTextDialog:@"取消置顶成功" view:self.view showSecond:1];
        }else{
             [HuaxoUtil showMsg:@"" title:customDict[@"msg"]];
        }
        
    }];
    
}


//置顶
-(void)setPostTop:(NSString *)postId{
    
    NetRequest * request =[NetRequest new];
    NSDictionary * parmeters = @{@"uid": [HuaxoUtil getUdidStr],
                                 @"post_id":postId,
                                 @"flag":@0x01};
    
    
    [request urlStr:[ApiUrl getSetPostTop] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        if(customDict[@"ret"]){
              _post.flag=1;
            [HudUtil showTextDialog:@"置顶成功" view:self.view showSecond:1];
        }else{
            [HuaxoUtil showMsg:@"" title:customDict[@"msg"]];
        }
    }];
    
}



//热点置顶   热点取消置顶
-(void)handleHotPostTop:(NSString *)postIdParam topFlag:(int)topFlag{
    NetRequest * request =[NetRequest new];
    NSDictionary * parmeters = @{@"uid": [HuaxoUtil getUdidStr],
                                 @"post_id":postIdParam,
                                 @"type":@0,
                                 @"op":@"zd",
                                 @"top_flag":@(topFlag)};
    
    [request urlStr:[ApiUrl getHotPostTop] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
        if(customDict[@"ret"]){
            if (topFlag) {
                
                   _post.topFlag=1;
                [HudUtil showTextDialog:@"置顶成功" view:self.view showSecond:1];
                
             
            }else{
                
                _post.topFlag=0;
                [HudUtil showTextDialog:@"取消置顶成功" view:self.view showSecond:1];
                
            }
        }else{
            [HuaxoUtil showMsg:@"" title:customDict[@"msg"]];
        }
    }];
}


- (void)postZanAndReplyView:(PostZanAndReplyView *)view selectedTitle:(NSString *)title {
    
    if ([title isEqualToString:@"zan"]) {
        NSLog(@"clicked zan");
        if (view.zanBtn.selected == YES) {
            return;
        }
        
        [ZBPraise praiseWithKindId:self.post.postId getPraiseUid:self.post.uid praisedUid:[HuaxoUtil getUdidStr] praiseKind:ZBPraiseKindPost completed:^(BOOL result, NSString *msg, NSError *error) {
            
            if (result) {
                view.zanNum = view.zanNum + 1;
                view.zanBtn.selected = YES;
                //刷新点赞列表
                [self requestPraise];
            } else {
                [Praise hudShowTextOnly:msg delegate:self];
            }
        }];
    } else if ( [title isEqualToString:@"reply"]) {
        [self showReplyBoxView];
    }
    
}

- (void)showReplyBoxView {
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:self];
        [NewLoginContoller tologinWithVC:self];
        return;
    }
    
    if (!self.boxView) {
        CGRect frame = self.view.frame;
        self.boxView = [[ReplyBoxView alloc] initWithFrame:CGRectMake(0, frame.size.height-44, frame.size.width, 44)];
    }
    //    CGRect frame = self.boxView.frame;
    //    self.boxView.frame = CGRectMake(frame.origin.x, self.view.frame.size.height-frame.size.height, frame.size.width, frame.size.height);
    self.boxView.postId = self.postID;
    self.boxView.delegate = self;
    self.boxView.replyDelegate = self;
    self.boxView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [self.view addSubview:self.boxView];
    [self.boxView.inputTV becomeFirstResponder];
}


- (void)praiseBtnClicked:(UIButton *)button Row:(NSInteger)row  {
    if (button.selected == YES) {
        return;
    }
    ZBReply *reply = [self.replyList objectAtIndex:row];
    __block UIButton *bSender = button;
    
    NSString *replyId = [NSString stringWithFormat:@"%ld",reply.ID];
    NSString *gUid = [NSString stringWithFormat:@"%ld",reply.uid];
    [ZBPraise praiseWithKindId:replyId getPraiseUid:gUid praisedUid:[HuaxoUtil getUdidStr] praiseKind:ZBPraiseKindReply completed:^(BOOL result, NSString *msg, NSError *error) {
        if (result) {
            bSender.selected = YES;
            NSString *zanNumStr = [bSender titleForState:UIControlStateNormal];
            [bSender setTitle:[NSString stringWithFormat:@"%ld",(long)[zanNumStr integerValue]+1] forState:UIControlStateNormal];
        } else {
            [Praise hudShowTextOnly:msg delegate:self];
        }
    }];
}

-(void)layerClicked:(UIButton *)button row:(NSInteger)row
{
    
    self.currentRow = row;
    
    //sheet.tag = POST_REPLY_LAYER_ALERT;
    
    NSArray *arr = [NSArray array];
    ZBReply *reply = self.replyList[row];
    NSString* replyUid = [NSString stringWithFormat:@"%ld",reply.uid];
    BOOL isMyReply = replyUid && [replyUid isEqualToString:[HuaxoUtil getUdidStr]];
    BOOL isAuthor = [self.post.uid isEqualToString:[HuaxoUtil getUdidStr]];
    
    if(pm>=0|| isMyReply || isAuthor)
    {
        arr = @[GDLocalizedString(@"删除")];
    }
    NSArray *arr2 = @[GDLocalizedString(@"收藏"),GDLocalizedString(@"评论")];
    NSMutableArray *arr3 = [[NSMutableArray alloc] initWithArray:arr];
    [arr3 addObjectsFromArray:arr2];
    
    CGPoint origin = [button convertPoint:button.center fromView:self.view];
    origin = CGPointMake(DeviceWidth-origin.x+10, -origin.y+30);
    NSLog(@"origin %@",NSStringFromCGPoint(origin));
    
    ReplyManagerView *managerView = [[ReplyManagerView alloc] initWithButtonTitles:arr3 delegate:self origin:origin];
    [managerView show];
}

- (void)replyManagerView:(ReplyManagerView *)view selectedButtonTitle:(NSString *)title {
    NSLog(@"title %@",title);
    ZBReply *reply = self.replyList[self.currentRow];
    
    if([title isEqualToString:GDLocalizedString(@"删除")]) {
        NSLog(@"into delPostBtnClicked");
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:GDLocalizedString(@"确定删除该评论?") message:nil delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles: GDLocalizedString(@"确定") , nil];
        alertView.tag = DEL_REPLY_ALERT;
        [alertView show];
    } else if ([title isEqualToString:GDLocalizedString(@"收藏")]) {
        NSLog(@"clicked collectionPost");
        
        NSString *replyId = [NSString stringWithFormat:@"%ld", reply.ID];
        NSString *gUid = [NSString stringWithFormat:@"%ld", reply.uid];
        [ZBCollection collectionWithKindId:replyId getCollectionUid:gUid collectionUid:[HuaxoUtil getUdidStr] collectionKind:ZBCollectionKindReply completed:^(BOOL result, NSString *msg, NSError *error) {
            [Praise hudShowTextOnly:msg delegate:self];
        }];
    } else if ([title isEqualToString:GDLocalizedString(@"评论")]) {
        [self showReplyPopView:nil];
    } else {}
    
}

-(void)delPostBtnClicked:(id)sender
{
    NSLog(@"into delPostBtnClicked");
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle: GDLocalizedString(@"确定删除该话题?") message:GDLocalizedString(@"删除后将无法看到该话题") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"确定"), nil];
    alertView.tag = DEL_POST_ALERT;
    [alertView show];
}

-(NSString *)postTitle{
    return self.post.title;
}
-(NSString*)desc
{
    
    NSString *descStr = @"";
    if (self.postView) {
        for (ZBCoreText *coreText in self.postView.regularMatchArray) {
            if (coreText.kind == ZBCoreTextKindText) {
                descStr = [descStr stringByAppendingString:coreText.string];
            }
        }
    }
    
    return descStr;
}
-(NSString*)url
{
    NSString *englishName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    englishName = [englishName substringFromIndex:7];
    return [NSString stringWithFormat:@"http://cs.opencom.cn/app/%@/post/%@",englishName, self.postID];
    
}

-(void)toolBarBtnClicked:(id)sender
{
    UIView *btn = sender;
    if(btn.tag==1)
    {
        NSLog(@"sort btn clicked");
        pullOrder = !pullOrder;
        self.replyList = nil;
        sortNow = YES;
        [self requestReplys:nil];
    }else if(btn.tag==2)
    {
        
        if(!self.shareUrl){
            NSString *appKind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
            NSString *postId=self.postID;
            NSString *englishName =[appKind substringFromIndex:7];
            
            NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:appKind,@"app_kind",postId,@"post_id",nil];
            
            [NetRequest urlStr:[ApiUrl getShareUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *json = responseObject;
                NSString *url=json[@"url"];
                if(url){
                    self.shareUrl=url;
                }else{
                    self.shareUrl=[NSString stringWithFormat:@"http://cs.opencom.cn/app/%@/post/%@",englishName,postId];
                }
                [self shareBtnClicked:sender andBtn:btn];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                self.shareUrl=[NSString stringWithFormat:@"http://cs.opencom.cn/app/%@/post/%@",englishName,postId];
                [self shareBtnClicked:sender andBtn:btn];
            }];
        }else{
            [self shareBtnClicked:sender andBtn:btn];
        }
    }
}


-(void)shareBtnClicked:(id)sender andBtn:(UIView *)btn{
    
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:btn arrowDirect:UIPopoverArrowDirectionUp];
    
    SSPublishContentMediaType mediaType = SSPublishContentMediaTypeNews;
    
    NSString* imgId = [self.postView.post.imageList firstObject];
    imgId = imgId==nil ? [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_logo"]:imgId;
    
    //id<ISSCAttachment> imageAttach = [ShareSDK imageWithUrl:[ApiUrl getImageUrlStrFromID:[imgId integerValue] w:60]];
    
    NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:[imgId integerValue]]]];
    
    id<ISSCAttachment> imageAttach=[ShareSDK imageWithData:imageData fileName:@"test22.jpg" mimeType:@"jpg"];
    
    NSString *desc = self.desc;
    if (desc.length>80) {
        desc = [self.desc substringToIndex:80];
        desc = [desc stringByAppendingString:@" "];
        desc = [desc stringByAppendingString:self.shareUrl];
    }
    
    
    NSString *redesc=[NSString stringWithFormat:@"描述//%@",self.desc];
    
    id<ISSContent> publishContent = [ShareSDK content:redesc
                                       defaultContent:@""
                                                image:imageAttach
                                                title:[self postTitle]
                                                  url:self.shareUrl
                                          description:nil
                                            mediaType:mediaType];
    NSLog(@"title:%@ desc:%@ url:%@",[self postTitle], self.desc, self.shareUrl);
    NSLog(@"desc %@",desc);
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    NSString* app_name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_name"];
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:app_name],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:app_name],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    //自定义标题栏相关委托
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:GDLocalizedString(@"分享话题")
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:self
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    //创建自定义分享列表
//    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeWeixiFav,ShareTypeQQ,ShareTypeQQSpace,ShareTypeSinaWeibo,ShareTypeTencentWeibo,ShareTypeSMS,ShareTypeRenren,ShareTypeYiXinSession,ShareTypeYiXinTimeline,ShareTypeYouDaoNote,ShareTypeMail, nil];
//    
    
    
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ,ShareTypeQQSpace,ShareTypeSinaWeibo,nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:NO
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    [Praise hudShowTextOnly:GDLocalizedString(@"分享成功") delegate:self];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    [Praise hudShowTextOnly:[NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"分享失败"),[error errorDescription]] delegate:self];
                                }
                            }];
    
}

#pragma mark - ISSShareViewDelegate
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType

{
    
    //修改分享编辑框的标题栏颜色
    viewController.navigationController.navigationBar.barTintColor = UIColorWithMobanTheme;
    
    //将分享编辑框的标题栏替换为图片
    //    UIImage *image = [UIImage imageNamed:@"iPhoneNavigationBarBG.png"];
    //    [viewController.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==DEL_POST_ALERT)
    {
        if(buttonIndex==1)
        {
            [self delPost];
        }
    }else if(alertView.tag==DEL_REPLY_ALERT)
    {
        if(buttonIndex==1){
            [self delReply];
        }
    } else if (alertView.tag == 120) {
        if(buttonIndex == 1)
        {
            NSString* str = [NSString stringWithFormat:@"tel:%@",self.telephoneNumberStr];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}

#pragma mark - 删除帖子
-(void)delPost
{
    if(!self.post) return ;
    NetRequest *request =[[NetRequest alloc] init];
    //SQLDataBase * sql = [[SQLDataBase alloc]init];
    
    NSDictionary * parameters =@{
                                 @"post_id":self.post.postId,
                                 @"uid": self.post.uid,
                                 };
    
    [request urlStr:[ApiUrl delPostUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        if(![customDict[@"ret"] intValue])
        {
            NSLog(@"delete post failed!msg:%@",customDict[@"msg"]);
            NSString* msg = [NSString stringWithFormat:@"%@:%@", GDLocalizedString(@"原因"),customDict[@"msg"]];
            [HuaxoUtil showMsg:GDLocalizedString(@"删除话题失败") title:msg];
        }
        if ([self.delegate respondsToSelector:@selector(postViewController:deleteWithIndex:)]) {
            [self.delegate postViewController:self deleteWithIndex:self.index];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
-(void)delReply
{
    NetRequest *request =[[NetRequest alloc] init];
    
    ZBReply *reply = self.replyList[self.currentRow];
    NSDictionary * parameters =@{
                                 @"reply_id":[NSString stringWithFormat:@"%ld",reply.ID],
                                 @"uid":[HuaxoUtil getUdidStr],
                                 };
    
    [request urlStr:[ApiUrl deleReply1UrlStr] parameters:parameters passBlock:^(NSDictionary *customDict)
     {
         if(![customDict[@"ret"] intValue])
         {
             NSLog(@"delete reply failed!msg:%@",customDict[@"msg"]);
             NSString* msg = [NSString stringWithFormat:@"%@:%@", GDLocalizedString(@"原因"),customDict[@"msg"]];
             [HuaxoUtil showMsg:GDLocalizedString(@"删除评论失败") title:msg];
         }else
         {
             [self removeReplyToReplyListWithIndex:self.currentRow];
             [self.tableView reloadData];
             [Praise hudShowTextOnly:GDLocalizedString(@"删除评论成功") delegate:self];
             //[HuaxoUtil showMsg:@"删除评论成功" title:nil];
         }
     }];
}

#pragma mark - 子评论发表成功后的代理方法

- (void)subReplySuccessWithIndex:(NSInteger)index content:(NSString *)content
{
    ZBPost *post = self.replyList[index];
    
    NSString * strBegin = [NSString stringWithFormat:@"%ld", (unsigned long)(post.range.location)];
    NSDictionary*  parameret =@{
                                @"post_id":self.postID,
                                @"begin":strBegin,
                                @"len":@"1",
                                @"need_imgs":@"yes"
                                };
    
    NetRequest * req =[[NetRequest alloc]init];
    
    [req urlStr:(!pullOrder?[ApiUrl postReplysUrlStr]:[ApiUrl postLastReplysUrlStr]) parameters:parameret passBlock:^(NSDictionary *customDict) {
        
        BOOL sortYes = sortNow;
        sortNow = NO;
        
        if(![customDict[@"ret"] intValue])
        {
            NSLog(@"getReplys failed,msg:%@",customDict[@"msg"]);
            if (customDict[@"not_have"] && [customDict[@"not_have"] intValue] == 1) {
                return ;
            }
        }
        NSArray* list = customDict[@"list"];
        
        [self insertSubReplyToReplyList:[list firstObject] index:index];
        
        [self.tableView reloadData];
        
        if(sortYes){
            [self gotoRow:index section:1 bottom:NO];
        }
    }];
}

#pragma mark - 请求某个评论
//- (void)requestReply:(MJRefreshBaseView *)refreshView withIndex:(NSInteger)index
//{
//
//}

#pragma mark - 跳转发表子评论页面
-(void)showReplyPopView:(id)sender
{
    ZBPost *post = self.replyList[self.currentRow];
    if ([post isMemberOfClass:[ZBReply class]]) {
        ZBReply *reply = (ZBReply *)post;
        [self toPostReplyViewControllerByReplyId:reply.ID withIndex:self.currentRow];
    }
    
}

-(void)toPostReplyViewControllerByReplyId:(long)replyId withIndex:(NSInteger)index
{
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:self];
        [NewLoginContoller tologinWithVC:self];
        return;
    }
    
    if (!replyId) {
        return;
    }
    SubReplyViewController *vc = [[SubReplyViewController alloc] init];
    vc.replyId = replyId;
    vc.index = index;
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickedImage:(NSNotification *)sender {
    NSArray *imgUrls = sender.userInfo[@"imgUrlStrs"];
    NSInteger index = [sender.userInfo[@"index"] integerValue];
    
    LookPictureVC *picVC = [[LookPictureVC alloc] initWithImageStrs:imgUrls index:index];
    picVC.hidesBottomBarWhenPushed = YES;
    
    [self presentViewController:picVC animated:YES completion:nil];
}

- (void)intoRecentlyVisitTableVCWithPostId:(NSString *)postId {
    
    RecentlyVisitTableVC *vc = [[RecentlyVisitTableVC alloc] init];
    vc.post_id =postId;
    vc.pindao_id=self.kindId;
    vc.title = GDLocalizedString(@"最近访客");
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)back:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//滑动收起键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.boxView.inputTV resignFirstResponder];
}

//请求点赞用户列表
-(void)requestPraise
{
    //ApiUrl * url =[ApiUrl new];
    NetRequest * request =[NetRequest new];
    
    NSDictionary * parameters = @{@"support_id": self.postID,
                                  @"praise_kind":@"1",
                                  @"index":@"0",
                                  @"size":@"10"};
    
    [request urlStr: [ApiUrl praiseUserListUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        if (!customDict[@"ret"]  ) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            return ;
        }
        NSArray* list = customDict[@"list"];
        self.praiseList = [[NSMutableArray alloc] initWithArray:list];
        self.praiseNum = [customDict[@"size"] integerValue];
        [self.tableView reloadData];
    }];
}

//刷新回复列表
- (void)finishedReplyWithReplyBoxView:(ReplyBoxView *)rbview {
    [self requestReplys:nil];
    [Praise hudShowTextOnly:GDLocalizedString(@"回复成功") delegate:self];
}
//回复失败 - delegate
- (void)failedReplyWithReplyBoxView:(ReplyBoxView *)rbview msg:(NSString *)msg {
    [Praise hudShowTextOnly:[NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"回复失败"),msg] delegate:self];
}

- (void)dealloc {
    
    //取消加载框
    [self.activityInd stopAnimating];
    [self.maskView removeFromSuperview];
    self.activityInd = nil;
    self.maskView = nil;
    
    self.boxView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_footer free];
    [_header free];
    NSLog(@"PostViewController dealloc");
}
@end
