//
//  PindaoIndexViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-16.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PindaoIndexViewController.h"
#import "PindaoHomeFansCell.h"
#import "PindaoHomeTopCell.h"
#import "PindaoHomeChildPlate.h"
#import "PindaoHomeNewsCell.h"
#import "PindaoFansViewController.h"
#import "Post.h"
#import "PostManagerView.h"
#import "ReplyManagerView.h"
#import "AppDelegate.h"
#import "RecentlyVisitTableVC.h"
#import "NewPostViewController.h"
#import "CreatePindaoTableVC.h"
#import "Pindao.h"
#import "MBProgressHUD.h"
#import "PindaoThemeTitleView.h"

#import "Praise.h"
#import "ReportPost.h"
#import "ZBTUrlCacher.h"

#import "PindaoHomeNewsCell.h"
#import "ZBTiebaPostCell.h"
#import "ZBAppSetting.h"
#import "ZBPraise.h"
#import "ZBCollection.h"

#import "ZBPostJumpTool.h"

#import "TabPostManagerView.h"
#import "MJExtension.h"

#import "ZbtUserPm.h"

@interface PindaoIndexViewController ()<PostManagerViewDelegate, ReplyManagerViewDelegate, MBProgressHUDDelegate, PostViewControllerDelegate,TabPostManagerViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *nePostList;
@property (nonatomic, strong) NSMutableArray *postList;
@property (nonatomic, strong) ReportPost *report;

@property (nonatomic, strong) PostManagerView *themeTitleManagerView;
@property (nonatomic, copy) NSString *nePostListStr;
@property (nonatomic, copy) NSString *themeTitleStr;
@property (nonatomic, assign) BOOL isClickedThemeTitle;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation PindaoIndexViewController
@synthesize kind_id,pindaoInfo;

static ZbtUserPm *userPm;

static NSString *pindaoId;

NSIndexPath *indexPath;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initSubviews];
    
    NSString *title = [NSString stringWithFormat:@"%@%@",[ZBAppSetting standardSetting].pindaoName, GDLocalizedString(@"主页")];
    self.title = title;
    
    UIBarButtonItem *createPostBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"编辑_频道主页.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedCreatePostBtn)];
    UIBarButtonItem *managerBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"更多操作_帖子_查看话题.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedManagerBtn)];
    self.navigationItem.rightBarButtonItems = @[managerBtn, createPostBtn];
    
    //cell注册
    if ([[ZBAppSetting standardSetting] naviCellStyle]==1) {
        [self.tableView registerClass:[ZBTiebaPostCell class] forCellReuseIdentifier:@"ZBTiebaPostCell"];
    } else {
        [self.tableView registerClass:[PindaoHomeNewsCell class] forCellReuseIdentifier:@"PindaoHomeNewsCell"];
    }

    
    
    //添加手势
    UILongPressGestureRecognizer *gestureLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureLongPress:)];
    gestureLongPress.minimumPressDuration =1;
    gestureLongPress.delegate=self;
    [self.tableView addGestureRecognizer:gestureLongPress];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self addHeader];
    [self addFooter];

    [self getCacheData];
    [self request];
    
    //置顶数据请求
    [self requestPostList];
    
    //请求新贴
    self.themeTitleStr = @"最新话题";
    //[self requestPostsWithTitle:self.themeTitleStr refreshView:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    if (self.tableView) {
        
            [_postList  removeAllObjects];
            [self requestPostList];
    }
    
}




-(void)gestureLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{

    
    if (gestureRecognizer.state==UIGestureRecognizerStateBegan) {
        
        CGPoint point=[gestureRecognizer locationInView:self.tableView];
        if (gestureRecognizer.state ==UIGestureRecognizerStateBegan) {
            indexPath= [self.tableView indexPathForRowAtPoint:point];
        }
        if (indexPath.section==0) {
            return;
        }
        
            NetRequest * request =[NetRequest new];
            NSDictionary * parmeters = @{@"uid": [HuaxoUtil getUdidStr]};
            
            [request urlStr:[ApiUrl getUserPm] parameters:parmeters passBlock:^(NSDictionary *customDict) {
                if ([customDict[@"ret"] integerValue]) {
                    NSDictionary *dict2 =customDict;
                    ZbtUserPm   *tempZbtUserPm = [ZbtUserPm objectWithKeyValues:dict2];
                    [self showTabPostManagerView:tempZbtUserPm];
                    userPm=tempZbtUserPm;
                }
            }];
    }
}



-(void)showTabPostManagerView:(ZbtUserPm *)userPmParam{
    NSMutableArray *tempArr=[NSMutableArray array];
    
    Post *mpost=self.nePostList[indexPath.row];
    
    if ([userPmParam.pm integerValue]==1) {
        
        if ((mpost.flag&0x01)>0){
             [tempArr addObject:@{@"title":@"取消置顶",@"image":@""}];
        }else{
             [tempArr addObject:@{@"title":@"置顶",@"image":@""}];
        }
        
        
//        if (indexPath.section==1) {
//            [tempArr addObject:@{@"title":@"取消置顶",@"image":@""}];
//        }else if (indexPath.section==2){
//            [tempArr addObject:@{@"title":@"置顶",@"image":@""}];
//        }
        
        [tempArr addObject:@{@"title":@"删除",@"image":@""}];
        
    }else if([userPmParam.pm integerValue]==2){
        
        if(userPmParam.kind_ids.count>0){
            if([userPmParam.kind_ids[0][@"kind_id"] intValue]==0){
                
                if ((mpost.flag&0x01)>0){
                    [tempArr addObject:@{@"title":@"取消置顶",@"image":@""}];
                }else{
                    [tempArr addObject:@{@"title":@"置顶",@"image":@""}];
                }
                
                 [tempArr addObject:@{@"title":@"删除",@"image":@""}];
//                if (indexPath.section==1) {
//                    [tempArr addObject:@{@"title":@"取消置顶",@"image":@""}];
//                }else if (indexPath.section==2){
//                    [tempArr addObject:@{@"title":@"置顶",@"image":@""}];
//                }
            }else{
                for (NSDictionary *dict in userPmParam.kind_ids) {
                    NSString *resultKindId= [dict[@"kind_id"] stringValue];
                    NSString *myKindId=self.kind_id;
                    
                    if ([resultKindId isEqualToString:myKindId]) {
                        
                        if ((mpost.flag&0x01)>0){
                            [tempArr addObject:@{@"title":@"取消置顶",@"image":@""}];
                        }else{
                            [tempArr addObject:@{@"title":@"置顶",@"image":@""}];
                        }
                       [tempArr addObject:@{@"title":@"删除",@"image":@""}];
//                        if (indexPath.section==1) {
//                            [tempArr addObject:@{@"title":@"取消置顶",@"image":@""}];
//                        }else if (indexPath.section==2){
//                            [tempArr addObject:@{@"title":@"置顶",@"image":@""}];
//                        }
                    }
                }
            }
        }
       
    }
    
    
    NSArray *arr = @[@{@"title":GDLocalizedString(@"查看"),@"image":@""},
                     @{@"title":GDLocalizedString(@"收藏"),@"image":@""},
                     @{@"title":GDLocalizedString(@"举报"),@"image":@""}];
    [tempArr addObjectsFromArray:arr];
    
    TabPostManagerView *maView = [[TabPostManagerView alloc] initWithButtonTitles:tempArr delegate:self];
    CGRect frame = maView.viewFrame;
    frame.origin.x =(DeviceWidth-frame.size.width)/2;
    frame.origin.y = (DeviceHeight-frame.size.height)/2;
    frame.size.width=frame.size.width+100;
    maView.viewFrame = frame;
    [maView show];

}





#pragma mark - alertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {   // 不保存
        
    } else {
        [self deletePost:pindaoId];
    }
}



//取消置顶
-(void)cancelPostTop:(Post *)post{
    
    NetRequest * request =[NetRequest new];
    NSDictionary * parmeters = @{@"uid": [HuaxoUtil getUdidStr],
                                 @"post_id":post.postId,
                                 @"flag":@0x01};
    
    [request urlStr:[ApiUrl getCancelPostTop] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
        if (self.postList.count==1) {
            [self.postList removeAllObjects];
             [self.tableView reloadData];
        }else{
            post.flag=1;
            [self requestPostList];
            
        }
        
    }];
    
}


//置顶
-(void)setPostTop:(Post *)post{
    
    NetRequest * request =[NetRequest new];
    NSDictionary * parmeters = @{@"uid": [HuaxoUtil getUdidStr],
                                 @"post_id":post.postId,
                                 @"flag":@0x01};
    
    [request urlStr:[ApiUrl getSetPostTop] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
        post.flag=0;
        [self requestPostList];
    }];

}


//删除帖子
-(void)deletePost:(NSString *)postId{
    
    
    Post *mpost=self.nePostList[indexPath.row];
    
//    NSString *muid=[HuaxoUtil getUdidStr];
    
    NetRequest * request =[NetRequest new];
    
    NSDictionary * parmeters = @{@"uid":mpost.uid,
                                 @"post_id":postId
                                };
    [request urlStr:[ApiUrl getDeletePost] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        if (customDict[@"ret"]) {
            [self.nePostList removeObjectAtIndex:indexPath.row];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [HuaxoUtil showMsg:@"" title:customDict[@"msg"]];
        }
        
    }];
}


- (void)tabPostManagerView:(TabPostManagerView *)view selectedButtonTitle:(NSString *)title{
    
    Post *post = nil;
    if (indexPath.section==2) {
        post=self.nePostList[indexPath.row];
    }else if(indexPath.section==1){
        post=self.postList[indexPath.row];
    }
    
    if ([title isEqualToString:@"置顶"]) {
        
        [self setPostTop:post];
        
    }else if ([title isEqualToString:GDLocalizedString(@"删除")]) {
        pindaoId=post.postId;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"提示") message:GDLocalizedString(@"确定要删除该记录?") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"确定"), nil];
        [alert show];
        
    }else if ([title isEqualToString:GDLocalizedString(@"查看")]) {

        [ZBPostJumpTool intoPage:post.postId withIndex:indexPath.row delegate:self vc:self urlStr:post.postUrl];
        
        
    }else if ([title isEqualToString:@"收藏"]) {
        [ZBCollection collectionWithKindId:post.postId getCollectionUid:post.uid collectionUid:[HuaxoUtil getUdidStr] collectionKind:ZBCollectionKindPost completed:^(BOOL result, NSString *msg, NSError *error) {
            [Praise hudShowTextOnly:msg delegate:self];
        }];
    }else if ([title isEqualToString:GDLocalizedString(@"举报")]) {
        ReportPost *report = [[ReportPost alloc] initWithWithPostId:post.postId postUid:(post.uid?post.uid:@"0") actKind:@"1" delegate:self];
        [report startReport];
        self.report = report;
    }else if ([title isEqualToString:@"取消置顶"]) {
        [self cancelPostTop:post];
    }
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self request];
}

- (void)initSubviews {
    
    UIButton *themeTitleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 18)];
    [themeTitleBtn setTitleColor:UIColorWithMobanThemeSub forState:UIControlStateNormal];
    NSString *themeTitleBtnTitle = [NSString stringWithFormat:@"%@%@",[ZBAppSetting standardSetting].pindaoName, GDLocalizedString(@"主页")];
    [themeTitleBtn setTitle:themeTitleBtnTitle forState:UIControlStateNormal];
    themeTitleBtn.backgroundColor = [UIColor clearColor];
    [themeTitleBtn addTarget:self action:@selector(clickedThemeTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(themeTitleBtn.frame.size.width-8-6, themeTitleBtn.frame.size.height-8-1, 8, 8)];
    iv.image = [UIImage imageNamed:@"频道名_jt_频道主页.png"];
    [themeTitleBtn addSubview:iv];
    
    self.navigationItem.titleView = themeTitleBtn;
    
    
    self.tableView.backgroundColor = UIColorFromRGB(0xf3f3f5);
    
    self.line = [[UIImageView alloc] init];
    self.line.frame = CGRectMake(0, 98, DeviceWidth, 0.5);
    self.line.backgroundColor = UIColorFromRGB(0xc8c7cc);
    [self.headView addSubview:self.line];
    
    self.focusBtn = [[UIButton alloc] initWithFrame:CGRectMake(255, 12, 57, 25)];
    self.focusBtn.layer.cornerRadius = 3;
    self.focusBtn.layer.borderColor = UIColorFromRGB(0xe7e7e7).CGColor;
    self.focusBtn.layer.borderWidth = 0.5;
    [self.focusBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.headView addSubview:self.focusBtn];
    [self.focusBtn setImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [self.focusBtn setImage:[[UIImage imageNamed:@"社区频道分类_+.png"] imageWithMobanThemeColor] forState:UIControlStateSelected];
    [self.focusBtn setTitleColor:UIColorWithMobanTheme forState:UIControlStateSelected];
    [self.focusBtn setTitleColor:UIColorFromRGB(0x98999a) forState:UIControlStateNormal];
    [self.focusBtn addTarget:self action:@selector(focus:) forControlEvents:UIControlEventTouchUpInside];
    NSString *focus = [ZBAppSetting standardSetting].focusName;
    NSString *unfocus = [NSString stringWithFormat:@" %@",[ZBAppSetting standardSetting].unfocusName];
    [self.focusBtn setTitle:focus forState:UIControlStateNormal];
    [self.focusBtn setTitle:unfocus forState:UIControlStateSelected];
    
    if ([PindaoCacher isFocused:HUASHUO_PD kindID:self.kind_id]) {
        self.focusBtn.selected = NO;
    }
    else
    {
        //按钮设置
        self.focusBtn.selected = YES;
    }
}

- (void)clickedCreatePostBtn {
    //1.得到总故事版
    NewPostViewController *vc = [[NewPostViewController alloc] init];
    vc.title = GDLocalizedString(@"发帖");
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:vc action:@selector(back:)];
    [vc.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    Pindao *pindao = [[Pindao alloc] init];
    pindao.pindaoId = self.kind_id;
    pindao.name = pindaoInfo[@"kind"];
    //2.属性传值
    vc.selectedPindao = pindao;
    
    //3.跳转,视图
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

- (void)clickedThemeTitleBtn:(UIButton *)sender {
    NSArray *arr2 = @[@{@"title":GDLocalizedString(@"最新话题"),@"image":@""},
                      @{@"title":GDLocalizedString(@"最新互动"),@"image":@""},
                      @{@"title":GDLocalizedString(@"热门话题"),@"image":@""}];
    
    PindaoThemeTitleView *managerView = [[PindaoThemeTitleView alloc] initWithButtonTitles:arr2 delegate:self];
    [managerView show];
    self.themeTitleManagerView = managerView;
    

}

- (void)clickedManagerBtn {
    NSString *btnTitle = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"编辑"),[ZBAppSetting standardSetting].pindaoName];
    NSString *btnTitle1 = [NSString stringWithFormat:@"%@%@",[ZBAppSetting standardSetting].pindaoName, GDLocalizedString(@"简介")];
    
    
    NSMutableArray *arr2=[NSMutableArray array];
    
    
    if([pindaoInfo[@"creator"] intValue]==1){
        [arr2 addObject:@{@"title":btnTitle,@"image":@"编辑_频道主页_社区"}];
    }
    [arr2 addObject:@{@"title":GDLocalizedString(@"最近访客"),@"image":@"查看_频道主页_社区"}];
    
//    NSArray *arr2 = @[
//                      @{@"title":btnTitle,@"image":@"编辑_频道主页_社区"},
//                      
////                      @{@"title":btnTitle1,@"image":@"新建_频道主页_社区"},
//                      
//                      ];
    
    PostManagerView *managerView = [[PostManagerView alloc] initWithButtonTitles:arr2 delegate:self];
    [managerView show];
}

- (void)postManagerView:(PostManagerView *)view selectedButtonTitle:(NSString *)title {
    NSLog(@"%@",title);
    
    if ([self.themeTitleManagerView isEqual:view]) {
        self.isClickedThemeTitle = YES;
        self.themeTitleStr = title;
        [self requestPostsWithTitle:title refreshView:nil];
        
        //显示加载按框
        self.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.hud];
        self.hud.delegate = self;
        self.hud.labelText = @"Loading";
        [self.hud show:YES];
        
    }else{
        
        NSString *btnTitle = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"编辑"),[ZBAppSetting standardSetting].pindaoName];
        NSString *btnTitle1 = [NSString stringWithFormat:@"%@%@",[ZBAppSetting standardSetting].pindaoName, GDLocalizedString(@"简介")];
    
        if ([title isEqualToString:btnTitle]) {
            [self requestPindaoInfo:title];
        }else if ([title isEqualToString:btnTitle1]) {
            
            [self requestPindaoInfo:title];
            
        }else if ([title isEqualToString:GDLocalizedString(@"最近访客")]) {
            RecentlyVisitTableVC *rvc = [[RecentlyVisitTableVC alloc] init];
            rvc.pindao_id = self.kind_id;
            rvc.title = GDLocalizedString(@"最近访客");
            [self.navigationController pushViewController:rvc animated:YES];
        }
    }
}

//上下拉刷新
- (void)beginRefreshing:(MJRefreshBaseView *)refreshView {
    [self requestPostsWithTitle:self.themeTitleStr refreshView:refreshView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(pindaoInfo)
    // Return the number of sections.
        return 3;
    else return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return [self.postList count]>4?4:[self.postList count];
        case 2:
        {
            if(!self.nePostList) {
                self.nePostList = [[NSMutableArray alloc] init];
                ZBTUrlCacher *urlCacher = [[ZBTUrlCacher alloc] init];
                NSDictionary *dic = [urlCacher queryByUrlStr:[self urlCacherStr]];
                NSArray *list = dic[@"list"];
                for(int i=0;i<[list count];i++){
                    NSMutableDictionary* data = [list[i] mutableCopy];
                    
                    Post *post = [Post getPostByJson:data andRemoveSmallImageWithWidth:60];
                    PostLockedSQL *pSql = [[PostLockedSQL alloc] init];
                    if ([pSql isExistingByPostId:post.postId]) {
                        post.isLocked = YES;
                    }
                    [self.nePostList addObject:post];
                }
            }
            return [self.nePostList count];
        }
        default:
            return 0;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        PindaoHomeFansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PindaoHomeFansCell"];
        cell.fansNumLabel.text = [NSString stringWithFormat:@"(%@)",pindaoInfo[@"user_num"]];
        return cell;
    }
    else if (indexPath.section ==1)
    {
        
        PindaoHomeTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PindaoHomeTopCell"];
        Post *post = self.postList[indexPath.row];
        cell.title.text = post.title;
        if (post.isLocked) {
            cell.title.textColor = UIColorFromRGB(0x898989);
        } else {
            cell.title.textColor = [UIColor blackColor];
        }
        return cell;

    }
    else if (indexPath.section == 2)
    {
        Post *post = [self.nePostList objectAtIndex:indexPath.row];
        
        if ([[ZBAppSetting standardSetting] naviCellStyle] == 1) {
            ZBTiebaPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZBTiebaPostCell"];
            cell.post = post;
            [cell layoutSubviews];
            return cell;
        }
        
        PindaoHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PindaoHomeNewsCell"];
        Post *p = post;
        p.userName = p.pindaoName;
        cell.post = p;
        [cell layoutSubviews];
        cell.managerBtn.tag = indexPath.row;
        [cell.managerBtn addTarget:self action:@selector(clickedManagerBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    UITableViewCell * cell =[[UITableViewCell alloc] init];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0){
        return 44;
    }else if (indexPath.section == 1) {
        return 36;
    }else if (indexPath.section == 2)
    {
        Post *post = self.nePostList[indexPath.row];
        
        if ([[ZBAppSetting standardSetting] naviCellStyle] == 1) {
            return [ZBTiebaPostCell getCellHeightByPost:post];
        }
        return [PindaoHomeNewsCell getCellHeightByPost:post];
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *post_id = nil;
    NSString *postUrl = nil;
    //粉丝
    if(indexPath.section==0){
        UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PindaoFansViewController *tvc = [board instantiateViewControllerWithIdentifier:@"PindaoFansViewController"];
        tvc.kind_id = self.kind_id;
        [self.navigationController pushViewController:tvc animated:YES];
        return;
    }
    //置顶
    else if(indexPath.section==1)
    {
        PindaoHomeTopCell *cell = (PindaoHomeTopCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        Post *post = self.postList[indexPath.row];
        PostLockedSQL *pSql = [[PostLockedSQL alloc] init];
        [pSql insertPostId:post.postId];
        post.isLocked = YES;
        cell.title.textColor = UIColorFromRGB(0x898989);
        
        post_id = post.postId;
    }
    //最新话题
    else if (indexPath.section == 2) {
        Post *post = self.nePostList[indexPath.row];
        post_id = post.postId;
        postUrl = post.postUrl;
    }
    
    //跳转话题.
    if(post_id){
        [ZBPostJumpTool intoPage:post_id kindId:kind_id withIndex:indexPath.row delegate:self vc:self urlStr:postUrl];
    }
}
-(void)getCacheData
{
    ZBTUrlCacher *urlCacher = [[ZBTUrlCacher alloc] init];
    NSDictionary *dic = [urlCacher queryByUrlStr:[self pindaoHomeUrlCacherStr]];
    [self showData:dic];
}
-(void)request
{
    //ApiUrl * url =[ ApiUrl new];
    NetRequest * request =[NetRequest new];
    ZBAppSetting *appsetting = [ZBAppSetting standardSetting];
    
    NSString* lng = appsetting.longitudeStr;
    NSString* lat = appsetting.latitudeStr;
    
    NSString* ibg_udid = [HuaxoUtil getUdidStr];
    
    NSDictionary * parameters = @{
                                  @"uid":ibg_udid,
                                  @"id":( kind_id?kind_id:@"0"),
                                  @"gps_lng": lng,
                                  @"gps_lat": lat
                                  };

    [request urlStr:[ApiUrl channelUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        if(![customDict[@"ret"] intValue])
        {
            NSLog(@"get pindao info failed! msg:%@",customDict[@"msg"]);
            return ;
        }
        //缓存
        ZBTUrlCacher *urlCacher = [[ZBTUrlCacher  alloc] init];
        [urlCacher insertUrlStr:[self pindaoHomeUrlCacherStr] andJson:customDict];
        
        [self showData:customDict];
    }];
}

- (NSString *)pindaoHomeUrlCacherStr {
    NSString *Id = [NSString stringWithFormat:@"%@#uid:%@#id:%@",[ApiUrl channelUrlStr],[HuaxoUtil getUdidStr], kind_id];
    return Id;
}

- (void)clickedManagerBtn:(UIButton *)sender {
    NSInteger row = [sender tag];
    
    //sheet.tag = POST_REPLY_LAYER_ALERT;
    //NSDictionary *dic = self.nePostList[row];
    
    NSArray *arr = @[GDLocalizedString(@"赞"), GDLocalizedString(@"收藏"), GDLocalizedString(@"举报")];
    
    AppDelegate *app = (AppDelegate *)([UIApplication sharedApplication].delegate);
    CGPoint origin = [sender.superview convertPoint:sender.center fromView:[app window]];
    origin = CGPointMake(origin.x+10, -origin.y + sender.superview.frame.size.height*2-53);
    NSLog(@"origin %@",NSStringFromCGPoint(origin));
    
    ReplyManagerView *managerView = [[ReplyManagerView alloc] initWithButtonTitles:arr delegate:self origin:origin];
    managerView.tag = row;
    [managerView show];
}

- (void)replyManagerView:(ReplyManagerView *)view selectedButtonTitle:(NSString *)title  {
    Post *post = self.nePostList[view.tag];
    if ([title isEqualToString:GDLocalizedString(@"赞")]) {
        NSLog(@"title:%@",title);

        [ZBPraise praiseWithKindId:post.postId getPraiseUid:post.uid praisedUid:[HuaxoUtil getUdidStr] praiseKind:ZBPraiseKindPost completed:^(BOOL result, NSString *msg, NSError *error) {
            [Praise hudShowTextOnly:msg delegate:self];
        }];
    } else if ([title isEqualToString:GDLocalizedString(@"收藏")]) {
        NSLog(@"title:%@",title);

        [ZBCollection collectionWithKindId:post.postId getCollectionUid:post.uid collectionUid:[HuaxoUtil getUdidStr] collectionKind:ZBCollectionKindPost completed:^(BOOL result, NSString *msg, NSError *error) {
            [Praise hudShowTextOnly:msg delegate:self];
        }];
    } else if ([title isEqualToString:GDLocalizedString(@"举报")]) {
        NSLog(@"title:%@",title);
        ReportPost *report = [[ReportPost alloc] initWithWithPostId:post.postId postUid:post.uid actKind:@"1" delegate:self];
        [report startReport];
        self.report = report;
    }
    
}

-(void)showData:(NSDictionary*)customDict
{
    pindaoInfo  =   customDict;
    //名字
    NSString *nameTitle = [NSString stringWithFormat:@"%@%@",[ZBAppSetting standardSetting].pindaoName, GDLocalizedString(@"名")];
    NSString *DescTitle = [NSString stringWithFormat:@"%@%@",[ZBAppSetting standardSetting].pindaoName, GDLocalizedString(@"简介")];
    
    self.nameLabel.text = customDict[@"kind"]?customDict[@"kind"]:nameTitle;
    self.descLabel.text = customDict[@"desc"]?customDict[@"desc"]:DescTitle;

    //获取频道图片
    long imageID = [(NSNumber *)customDict[@"img_id"] integerValue];
    [self.logoView sd_setBackgroundImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:120]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"chanel_picture_new.png"]];
    //话题数量
    self.postNumLabel.text = [ZBNumberUtil shortStringByInteger:[customDict[@"post_num"] integerValue]];
    self.postNumLabel.textColor = UIColorFromRGB(0xf39500);
    
    //今日话题
    self.todayNumLabel.text = [ZBNumberUtil shortStringByInteger:[customDict[@"today_num"] integerValue]];
    self.todayNumLabel.textColor = UIColorFromRGB(0xf39500);
    
    self.logoView.layer.cornerRadius = 6;
    self.logoView.layer.masksToBounds = YES;
    
    [self.tableView reloadData];
    
    NSDictionary* log = [CSHistory getPindaoLog: [NSNumber numberWithInt:[self.kind_id intValue]] title:customDict[@"kind"]];
    [CSHistory addCSLog:log];
}

# pragma mark - postViewController代理方法实现
- (void)postViewController:(PostViewController *)postViewController withIndex:(NSInteger)index post:(Post *)changedPost
{
    Post *post = self.nePostList[index];
    post.readNum = changedPost.readNum;
    post.zan = changedPost.zan;
    post.replyNum = changedPost.replyNum;
    
    // 刷新数据
    [self.tableView reloadData];
}

- (void)postViewController:(PostViewController *)postViewController deleteWithIndex:(NSInteger)index
{
    if (index >= self.nePostList.count) return;
    
    [self.nePostList removeObjectAtIndex:index];
    [self.tableView reloadData];
}

- (void)focus:(id)sender {
    //[PindaoCacher isFocused:@"huashuo_pd" kindID:self.kind_id]
    BOOL ret = NO;
    if (!self.focusBtn.selected) {
        self.focusBtn.selected = YES;
        ret = [PindaoCacher unfocusPindao:HUASHUO_PD kindId:self.kind_id];
    }
    else
    {
        if(pindaoInfo==nil) return ;
        //按钮设置
        self.focusBtn.selected = NO;
        
        ret = [PindaoCacher focusPindao:pindaoInfo[@"kind"] kind:HUASHUO_PD kindID:[NSNumber numberWithFloat:[self.kind_id floatValue]] imgID:(NSNumber*)pindaoInfo[@"img_id"] desc:pindaoInfo[@"desc"]];
    }
    
    if(ret){
        [PindaoCacher forceSaveToNetwork];
    }
}

-(void)requestNewPosts:(MJRefreshBaseView *)refreshView
{
    NetRequest * request =[NetRequest new];
    
    NSUInteger begin = [self.nePostList count];
    NSDictionary * parmeters = @{@"id": self.kind_id,
                                 @"gps_lng": @"",
                                 @"gps_lat": @"",
                                 @"begin":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                 @"plen":@"15",
                                 @"need_flag":@"true",
                                 @"need_img":@"true",
                                 @"need_imgs":@"yes",
                                 @"need_whs":@"yes"
                                 };
    
    [request urlStr:[ApiUrl neBbsPostUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
        if (![customDict[@"ret"] integerValue]) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            if (customDict[@"not_have"] && [customDict[@"not_have"] intValue] == 1) {
                [refreshView noHaveMoreData];
                return ;
            }
            [refreshView loadingDataFail];
            return ;
        }
        [refreshView endRefreshing];
        self.nePostList = !self.nePostList || [self.nePostList count]<=0 ? [[NSMutableArray alloc]init]:self.nePostList;
        
        NSArray* list = customDict[@"list"];
        
        for(int i=0;i<[list count];i++){
            NSMutableDictionary* data = [list[i] mutableCopy];
            
            Post *post = [Post getPostByJson:data andRemoveSmallImageWithWidth:60];
            PostLockedSQL *pSql = [[PostLockedSQL alloc] init];
            if ([pSql isExistingByPostId:post.postId]) {
                post.isLocked = YES;
            }
            [self.nePostList addObject:post];
        }
        [self.tableView reloadData];
    }];
}

-(void)requestPostsWithTitle:(NSString *)title refreshView:(MJRefreshBaseView *)refreshView
{
    
    NSString *anyUrlStr = @"";
    if ([title isEqualToString:GDLocalizedString(@"最新话题")]) {
        anyUrlStr = [ApiUrl neBbsPostUrlStr];
    } else if ([title isEqualToString:GDLocalizedString(@"最新互动")]) {
        anyUrlStr = [ApiUrl pindaoNewInteractionUrlStr];
    } else if ([title isEqualToString:GDLocalizedString(@"热门话题")]) {
        anyUrlStr = [ApiUrl channelHotPostUrlStr];
    }
    
    
    NSUInteger begin = [self.nePostList count];
    if (self.isClickedThemeTitle || self.isPullDownRefreshing) {
        begin = 0;
    }
    NSDictionary * parmeters = @{@"id": self.kind_id,
                                 @"gps_lng": @"",
                                 @"gps_lat": @"",
                                 @"begin":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                 @"plen":@"15",
                                 @"need_flag":@"true",
                                 @"need_img":@"true",
                                 @"need_imgs":@"yes",
                                 @"need_whs":@"yes"
                                 };
    NetRequest * request =[NetRequest new];
    [request urlStr:anyUrlStr parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
        if (![customDict[@"ret"] integerValue]) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            if (customDict[@"not_have"] && [customDict[@"not_have"] intValue] == 1) {
                [refreshView noHaveMoreData];
                [self progressHUD:self.hud showTextOnly:GDLocalizedString(@"没有更多")];
                self.isClickedThemeTitle = NO;
                return ;
            }
            [refreshView loadingDataFail];
            [self progressHUD:self.hud showTextOnly:GDLocalizedString(@"加载失败")];
            self.isClickedThemeTitle = NO;
            return ;
        }
        [refreshView endRefreshing];
        if (self.isPullDownRefreshing) {
            [self.nePostList removeAllObjects];
            
            if ([title isEqualToString:GDLocalizedString(@"最新话题")]) {
                if ([customDict[@"list"] count]>0) {
                    ZBTUrlCacher *urlCacher = [[ZBTUrlCacher  alloc] init];
                    [urlCacher insertUrlStr:[self urlCacherStr] andJson:customDict];
                    
                }
            }
            
        }
        self.isPullDownRefreshing = NO;
        [self.hud hide:YES];
        

        if (![self.nePostListStr isEqualToString:title] || self.isClickedThemeTitle) {
            self.nePostList = nil;
        }
        self.nePostListStr = title;
        
        if (self.isClickedThemeTitle) {
            self.isClickedThemeTitle = NO;
            
            //tableview 回到顶部
            CGPoint point = self.tableView.contentOffset;
            point.y = 0.0;
            self.tableView.contentOffset = point;
        }

        self.nePostList = !self.nePostList || [self.nePostList count]<=0 ? [[NSMutableArray alloc]init]:self.nePostList;
        
        NSArray* list = customDict[@"list"];
        
        for(int i=0;i<[list count];i++){
            NSMutableDictionary* data = [list[i] mutableCopy];
            
            Post *post = [Post getPostByJson:data andRemoveSmallImageWithWidth:60];
            PostLockedSQL *pSql = [[PostLockedSQL alloc] init];
            if ([pSql isExistingByPostId:post.postId]) {
                post.isLocked = YES;
            }
            [self.nePostList addObject:post];
        }
        [self.tableView reloadData];
    }];
}

- (NSString *)urlCacherStr {
    NSString *Id = [NSString stringWithFormat:@"%@#id:%@",[ApiUrl neBbsPostUrlStr],self.kind_id];
    return Id;
}

- (void)progressHUD:(MBProgressHUD *)hud showTextOnly:(NSString *)message {
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:5];
}

- (void)requestPindaoInfo:(NSString *)title {
    NetRequest * request =[NetRequest new];
    
    NSDictionary * parmeters = @{@"id": self.kind_id
                                 };
    
    [request urlStr:[ApiUrl pindaoInfoUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict) {

        if (![customDict[@"ret"] integerValue]) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            [Praise hudShowTextOnly:[NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"失败"),customDict[@"msg"]] delegate:self];
        }
        Pindao *pindao = [Pindao getPindaoByJson:customDict];
        pindao.pindaoId = self.kind_id;
        UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CreatePindaoTableVC *vc = [board instantiateViewControllerWithIdentifier:@"CreatePindaoTableVC"];
        vc.pindao = pindao;
        
        NSString *btnTitle = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"编辑"),[ZBAppSetting standardSetting].pindaoName];
        NSString *btnTitle1 = [NSString stringWithFormat:@"%@%@",[ZBAppSetting standardSetting].pindaoName, GDLocalizedString(@"简介")];
        
        if ([title isEqualToString:btnTitle1]) {
            vc.pindaoMode = PindaoModeSeePindaoInfo;
        } else if ([title isEqualToString:btnTitle]) {
            vc.pindaoMode = PindaoModeEditingPindao;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

//置顶数据请求
- (void)requestPostList {
    NetRequest * request =[NetRequest new];
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    NSDictionary * parmeters = @{@"app_kind": app_kind,
                                 @"kind_id": self.kind_id,
                                 @"tag": @"1",
                                 @"begin":@"0",
                                 @"plen":@"3",
                                 @"need_flag":@"true",
                                 //@"need_img":@"true",
                                 //@"need_imgs":@"yes",
                                 //@"need_whs":@"yes"
                                 };
    
    [request urlStr:[ApiUrl pindaoFlagUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
        if (![customDict[@"ret"] integerValue]) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
             [self.tableView reloadData];
            return ;
        }
        
        self.postList = [[NSMutableArray alloc] init];
        
        NSArray* list = customDict[@"list"];
        
        for(int i=0;i<[list count];i++){
            NSDictionary* data = list[i];
            
            Post *post = [Post getPostByJson:data andRemoveSmallImageWithWidth:60];
            PostLockedSQL *pSql = [[PostLockedSQL alloc] init];
            if ([pSql isExistingByPostId:post.postId]) {
                post.isLocked = YES;
            }
            [self.postList addObject:post];
        }
        [self.tableView reloadData];
    }];
}

//创建频道页面会调用backVC
- (void)backVC {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)back:(id)sender {
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dealloc {
    NSLog(@"PindaoIndexViewController  dealloc");
}

@end
