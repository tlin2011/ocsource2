//
//  PlateTableViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-2.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PlateTableViewController.h"
#import "PlateCell.h"
#import "ApiUrl.h"
#import "NetRequest.h"
#import "SQLDataBase.h"
#import "ArchiverAndUnarchiver.h"
#import "UIImageView+WebCache.h"
#import "PindaoIndexViewController.h"
#import "YRJSONAdapter.h"
#import "HuaxoUtil.h"
#import "JYSlideSegmentController.h"
#import "ZBTMyFeedTableVC.h"
#import "JYSlideSegmentController.h"
#import "MyMsgTableVC.h"
#import "FriendViewController.h"
#import "NearbyUsersViewController.h"
#import "SearchUserViewController.h"
#import "RecommendPindaoTableVC.h"
#import "RecommendFriendTableVC.h"
#import "Pindao.h"
#import "CreatePindaoTableVC.h"
#import "TipLabel.h"
#import "NewPostViewController.h"
#import "ZBAppSetting.h"

#import "ShequPindaoTableVC.h"
#import "NearHotPindaoTableVC.h"
#import "SearchTableViewController.h"
#import "ShequPindaoKindVC.h"
#import "ShequPindaoTableCell.h"
#import "PindaoCacher.h"
#import "UIImage+Color.h"

#import "ZBHtmlToApp.h"

#import "ScanViewController.h"

@interface PlateTableViewController () <WKTableViewCellDelegate, ScanViewControllerDelegate>
{
    NSMutableArray * jsonArr;
    
    BOOL isLoadingNews,isLoadingPds;
}

@property (nonatomic, strong) TipLabel *myTipNum;
@property (nonatomic, strong) TipLabel *talkTipNum;

@property (strong, nonatomic) UIView *butonBG;
@property (strong, nonatomic) UIButton *pindaoBtn;
@property (strong, nonatomic) UIButton *myBtn;
@property (strong, nonatomic) UIButton *talkBtn;
@property (strong, nonatomic) UIButton *recommendBtn;

@property (strong, nonatomic) UIView *attentionView;

@property (strong, nonatomic) NSArray *focusList; //关注列表

@property (strong, nonatomic) NSMutableArray *recommendPindaos; // 推荐频道
@property (strong, nonatomic) UIView *changeView;
@property (weak, nonatomic) UIButton *changeBtn;  // 换一换按钮
@property (weak, nonatomic) UILabel *recommendLabel;
@property (weak, nonatomic) UIImageView *lineView;
@property (strong, nonatomic) NSMutableArray *displayPindaos;

@end

@implementation PlateTableViewController

- (NSMutableArray *)recommendPindaos
{
    if (!_recommendPindaos) {
        _recommendPindaos = [NSMutableArray array];
    }
    return _recommendPindaos;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [self initUI];
    
    UIBarButtonItem *createPostBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"编辑_频道主页.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedCreatePostBtn)];
    
    
    UIBarButtonItem *scanBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"二维码.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedScanBtn)];
    
    
    NSArray *scanArray=[[NSArray alloc] initWithObjects:createPostBtn,scanBtn,nil];
    
//  self.navigationItem.rightBarButtonItem = createPostBtn;
    
    
    self.navigationItem.rightBarButtonItems=scanArray;
    
    [self disposeData];
    [self requestData];

    [self addLisenter];
    
    [self requestRecommendPindaos];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[NotifyCenter alloc] init] getUserNews];
    [self disposeData];
    [self requestNEWS];
    
    [self recommendPindaosData];
}

/**
 *  跳转到发帖页面
 */
- (void)clickedCreatePostBtn {
    [ZBHtmlToApp toNewPostVCWithVC:self];
}

/**
 *  跳转到扫描页面
 */
- (void)clickedScanBtn {
    ScanViewController *svController=[[ScanViewController alloc] init];
    svController.delegate = self;
    [self presentViewController:svController animated:YES completion:nil];
}

#pragma mark -- scanViewControllerDelegate
- (void)scanViewController:(ScanViewController *)vc DidFinishedWithString:(NSString *)string {
    
    [ScanViewController resultDispalyByString:string viewController:self];
}

//社区频道
- (void)shequPindao:(UIButton *)sender {
    NSMutableArray *vcs = [NSMutableArray array];
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([ZBAppSetting standardSetting].isOpenPindaoKind) {
        ShequPindaoKindVC *vc1 = [[ShequPindaoKindVC alloc] init];
        NSString *title = [NSString stringWithFormat:@"%@%@", GDLocalizedString(@"社区"),[ZBAppSetting standardSetting].pindaoName];
        vc1.title = title;
        [vcs addObject:vc1];
    } else
    {
        ShequPindaoTableVC *vc1 = [[ShequPindaoTableVC alloc] init];
        NSString *title = [NSString stringWithFormat:@"%@%@", GDLocalizedString(@"社区"), [ZBAppSetting standardSetting].pindaoName];
        vc1.title = title;
        [vcs addObject:vc1];
    }
    
    NearHotPindaoTableVC *vc2 = [[NearHotPindaoTableVC alloc] init];
    vc2.title = GDLocalizedString(@"附近热点");
    [vcs addObject:vc2];
    
    if (![ZBAppSetting standardSetting].isCreatePindaoLimit) {
        CreatePindaoTableVC *vc3 = [board instantiateViewControllerWithIdentifier:@"CreatePindaoTableVC"];
        NSString *title = [NSString stringWithFormat:@"%@%@", GDLocalizedString(@"创建"), [ZBAppSetting standardSetting].pindaoName];
        vc3.title = title;
        [vcs addObject:vc3];
    }
    JYSlideSegmentController *sc = [[JYSlideSegmentController alloc] initWithViewControllers:vcs];
    sc.title = [ZBAppSetting standardSetting].pindaoName;
    sc.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    sc.indicator.backgroundColor = UIColorWithMobanTheme;
    
    sc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"搜索.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(searchPindao)];
    sc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sc animated:YES];
}

- (void)searchUser {
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchUserViewController *vc = [board instantiateViewControllerWithIdentifier:@"SearchUserViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchPindao {
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchTableViewController *vc = [board instantiateViewControllerWithIdentifier:@"SearchTableViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) addLisenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processUserLoginStatus:) name:[NotifyCenter userLoginStatusKey] object:nil];
}
-(void)processUserLoginStatus:(NSNotification*) aNotification
{
    [self disposeData];
    [self requestData];
}

#pragma mark - 设置子控件
- (void)initUI {
    
    self.tableView.backgroundColor = UIColorFromRGB(0xf3f5f6);
    //[self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    //提示—-红点
    self.myTipNum = [[TipLabel alloc] init];
    self.myTipNum.center = CGPointMake(68-7, 17);
    [self.myBtn addSubview:self.myTipNum];

    self.talkTipNum = [[TipLabel alloc] init];
    self.talkTipNum.center = CGPointMake(68-7, 17);
    [self.talkBtn addSubview:self.talkTipNum];
    
    NSString *pindaoNameTitle = [ZBAppSetting standardSetting].pindaoName;
    [self.pindaoBtn setTitle:pindaoNameTitle forState:UIControlStateNormal];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;

}

- (void)clickedConceernBtn {
    [self shequPindao:nil];
}

#pragma mark - -- 数据处理
-(void)disposeData
{
    NSArray* array = [PindaoCacher getPindaoList];
    if(array.count<1 || ![[HuaxoUtil getUdidStr] integerValue]) {


        [jsonArr removeAllObjects];
        [self tableViewReload];

        return;
    }

    
    NSMutableArray* tmpArr= [[NSMutableArray alloc] init];
    for(int i=0;i<[array count];i++)
    {
        //if(array[i] == nil) return ;
        //NSLog(@"disposeData---array[%d][kind]:%@",i,array[i]);
        if([array[i][@"kind"] isEqualToString:@"huashuo_pd"])
            [tmpArr addObject:[array[i] mutableCopy]];
    }
    jsonArr = tmpArr;
    jsonArr = [[self tableDataWithArr:[jsonArr copy] addNewsArr:self.focusList] mutableCopy];
    //[self.tableView reloadData];
    [self tableViewReload];
}

#pragma mark - -- 数据请求
-(void)requestData
{
    
    SQLDataBase * sql = [SQLDataBase new];
    NSString* ver = [sql queryWithCondition:@"pdlist-ver"];
    ver = ver==nil ? @"0":ver;
    [PindaoCacher getPindaoListFromNetwork:[ver intValue] completed:^(NSDictionary *customDict) {
        if (![(NSNumber*)customDict[@"ret"] intValue]) {
            NSLog(@"pdlist need didn't refresh");
            return ;
        }
        NSLog(@"pdlist need refresh");
        [self disposeData];
    }];
    [self requestNEWS];
}


-(void)requestNEWS
{
    
    if(isLoadingNews) return ;
    isLoadingNews = YES;
    ////ApiUrl * url = [ApiUrl new];
    NSString* uid  = [HuaxoUtil getUdidStr];
    if (![uid integerValue]) {
        return;
    }
    NetRequest * request = [NetRequest new];
    
    NSDictionary * parameters =@{@"uid":uid};
    [request urlStr:[ApiUrl AttentionChannelUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        isLoadingNews = NO;

        if (![customDict[@"ret"] integerValue]) {
            NSLog(@"getPindaoNews failed,msg:%@",customDict[@"msg"]);
            return ;
        }
        NSArray* list = customDict[@"list"];
        self.focusList = list;
        jsonArr = [[self tableDataWithArr:[jsonArr copy] addNewsArr:self.focusList] mutableCopy];
        
        //[self.tableView reloadData];
        [self tableViewReload];
    }];
    
}

- (NSArray *)tableDataWithArr:(NSArray *)arr addNewsArr:(NSArray *)neArr {
    NSMutableArray *mArr = [arr mutableCopy];
    for (int i=0; i< [mArr count]; i++) {
        NSDictionary *dic = mArr[i];
        
        for (int j=0; j<[neArr count]; j++) {
            NSDictionary *neDic = neArr[j];
            if ([dic[@"id"] integerValue] == [neDic[@"kind_id"] integerValue]) {
                NSMutableDictionary *nowDic = [dic mutableCopy];
                [nowDic setObject:[NSString stringWithFormat:@"%ld",(long)[neDic[@"post_num"] integerValue]] forKey:@"post_num"];
                [nowDic setObject:[NSString stringWithFormat:@"%ld",(long)[neDic[@"cur_post_num"] integerValue]] forKey:@"cur_post_num"];
                [nowDic setObject:[NSString stringWithFormat:@"%ld",(long)[neDic[@"user_num"] integerValue]] forKey:@"user_num"];
                
                [mArr replaceObjectAtIndex:i withObject:[nowDic copy]];
            }

        }
    }
    return [mArr copy];
}

- (void)tableViewReload{
    if (!self.navigationController) return;
    //[self.navigationController.tabBarController.selectedViewController isEqual:self.navigationController] &&
    if ([self.navigationController.topViewController isEqual:self]) {
        //[self.tableView reloadData];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 95;
    } else if (indexPath.section == 1 ) {
        return [ShequPindaoTableCell cellHeight];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [jsonArr count];
    } else
    {
        return self.displayPindaos.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString* identity=@"plteCell";
        PlateCell* cell=(PlateCell*)[tableView dequeueReusableCellWithIdentifier:identity];
        if (!cell){
            cell=[[PlateCell alloc]initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:identity
                                        delegate:self
                                     inTableView:tableView withRightButtonTitles:@[@"Delete"]];
        }
        
        Pindao *pindao = [Pindao getPindaoByJson:jsonArr[indexPath.row]];
        
        cell.titleLabel.text = jsonArr[indexPath.row][@"title"]? jsonArr[indexPath.row][@"title"]: jsonArr[indexPath.row][@"kind"]; //兼容默认推荐
        
        //显示动态信息
        int todayNum = [jsonArr[indexPath.row][@"cur_post_num"] intValue];
        NSString *commentStr = todayNum>0? [NSString stringWithFormat:@"%@:%d%@",GDLocalizedString(@"今天"),todayNum, GDLocalizedString(@"话题")] :@"";
        if (commentStr.length <= 1) {
            cell.comment.hidden = YES;
        } else {
            cell.comment.hidden = NO;
            cell.commentStr = commentStr;
        }
        
        cell.content.text = pindao.desc;
        
        //ApiUrl * url = [ApiUrl new];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:[pindao.imageId integerValue] w:100]] placeholderImage:[UIImage imageNamed:@"频道默认图片.png"]];
        

        
        //粉丝 和 今日贴数
        cell.fansNum.text = pindao.userNum;
//        CGSize fansStrSize = [cell.fansNum.text sizeWithFont:cell.fansNum.font forWidth:100 lineBreakMode:NSLineBreakByWordWrapping];
//        cell.fansNum.frame = CGRectMake(103, 38, fansStrSize.width, 13);
//        cell.topicIco.frame = CGRectMake(cell.fansNum.frame.origin.x + cell.fansNum.frame.size.width + 10, 38, 13, 12);
//        cell.topicNum.frame = CGRectMake(cell.topicIco.frame.origin.x + cell.topicIco.frame.size.width + 5, 38, 80, 13);
        
        cell.topicNum.text = [NSString stringWithFormat:@"%ld",(long)[jsonArr[indexPath.row][@"post_num"] integerValue]];
        
        [cell layoutSubviews];
        
        return cell;
    } else
    {
        static NSString *reuseID=@"recommendCell";
        ShequPindaoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[ShequPindaoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }
        Pindao *pindao = self.displayPindaos[indexPath.row];
        
        cell.titleLabel.text = pindao.name;
        
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:[pindao.imageId integerValue] w:100]] placeholderImage:[UIImage imageNamed:@"频道默认图片.png"]];
        cell.fansNum.text = pindao.userNum;
        cell.topicNum.text = pindao.postNum;
        cell.content.text = pindao.desc;
        
        if ([PindaoCacher isFocused:HUASHUO_PD kindID:pindao.pindaoId]) {
            cell.concernBtn.selected = YES;
        } else {
            //按钮设置
            cell.concernBtn.selected = NO;
        }
        [cell.concernBtn addTarget:self action:@selector(focus:) forControlEvents:UIControlEventTouchUpInside];
        cell.concernBtn.tag = indexPath.row;
        return cell;
    }
    
}

#pragma mark - 点击关注
- (void)focus:(UIButton *)sender {
    Pindao *pindao = self.displayPindaos[sender.tag];
    NSString *kindId = pindao.pindaoId;
    BOOL ret = NO;
    if (sender.selected) {
        sender.selected = NO;
        ret = [PindaoCacher unfocusPindao:HUASHUO_PD kindId:kindId];
    }
    else
    {
        if(self.displayPindaos==nil) return ;
        //按钮设置
        sender.selected = YES;
        
        ret = [PindaoCacher focusPindao:pindao.name kind:HUASHUO_PD kindID:[NSNumber numberWithFloat:[kindId floatValue]] imgID:[NSNumber numberWithInteger:[pindao.imageId integerValue]] desc:pindao.desc];
    }
    
    if(ret){
        [PindaoCacher forceSaveToNetwork];
        
        [self recommendPindaosData];
        [self disposeData];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.得到总故事版
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PindaoIndexViewController *next = [board instantiateViewControllerWithIdentifier:@"PindaoIndexViewController"];
    
    //2.属性传值
    if (indexPath.section == 0) {
        next.kind_id = [NSString stringWithFormat:@"%@", jsonArr[indexPath.row][@"id"]];
    } else {
        next.kind_id = [self.displayPindaos[indexPath.row] pindaoId];
    }
    
    //3.跳转,视图
    next.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - WKTableViewCellDelegate
-(void)buttonTouchedOnCell:(WKTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath atButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"row:%ld,buttonIndex:%ld",(long)indexPath.row,(long)buttonIndex);
    if (buttonIndex==0){
        //取消关注
        [self performSelector:@selector(cancelConcernwithPindaoId:) withObject:[NSString stringWithFormat:@"%@",jsonArr[indexPath.row][@"id"]] afterDelay:1];
        
        NSLog(@"2 row:%ld,buttonIndex:%ld",(long)indexPath.row,(long)buttonIndex);
        [jsonArr removeObjectAtIndex:indexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        [[NSNotificationCenter defaultCenter] postNotificationName:WKTableViewCellNotificationChangeToUnexpanded object:nil];
    }
}

- (void)cancelConcernwithPindaoId:(NSString *)pindaoId {
    if ([PindaoCacher isFocused:HUASHUO_PD kindID:pindaoId])
    {
        BOOL ret = NO;
        ret = [PindaoCacher unfocusPindao:HUASHUO_PD kindId:pindaoId];
        if(ret){
            [PindaoCacher forceSaveToNetwork];
        }
    }
}

#pragma mark - 频道推荐
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (!self.attentionView) {
            
            UIView *attentionView = [[UIView alloc] initWithFrame:CGRectZero];
            attentionView.backgroundColor = UIColorFromRGB(0xf3f5f6);
            
            UILabel *recommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 120, 24)];
            NSString *recommendLabelTitle = [NSString stringWithFormat:@"%@%@%@%@",GDLocalizedString(@"我"),[ZBAppSetting standardSetting].unfocusName,GDLocalizedString(@"的社区"),[ZBAppSetting standardSetting].pindaoName];
            recommendLabel.text = recommendLabelTitle;
            recommendLabel.font = [UIFont systemFontOfSize:12];
            recommendLabel.textColor = UIColorFromRGB(0x98999a);
            [attentionView addSubview:recommendLabel];
            
            self.attentionView = attentionView;
        }
        return self.attentionView;
    } else if (section == 1) {
        
        if (!self.changeView) {
            UIView *careView = [[UIView alloc] init];
            careView.backgroundColor = UIColorFromRGB(0xf3f5f6);
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(8, 4, tableView.width - 2 * 8, 36)];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:UIColorWithMobanTheme forState:UIControlStateNormal];
            NSString *btnTitle = [NSString stringWithFormat:@"%@%@%@%@",GDLocalizedString(@"点击"),[ZBAppSetting standardSetting].unfocusName,GDLocalizedString(@"更多"),[ZBAppSetting standardSetting].pindaoName];
            [btn setTitle:btnTitle forState:UIControlStateNormal];
            btn.layer.cornerRadius = 2;
            btn.layer.masksToBounds = YES;
            btn.layer.borderColor = UIColorFromRGB(0xdbdbdb).CGColor;
            btn.layer.borderWidth = 0.5;
            [btn addTarget:self action:@selector(clickedConceernBtn) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [careView addSubview:btn];
            
            UILabel *recommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(btn.frame)+12, 180, 24)];
            NSString *recommendLabelTitle = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"你有可能感兴趣的"),[ZBAppSetting standardSetting].pindaoName];
            recommendLabel.text = recommendLabelTitle;
            recommendLabel.font = [UIFont systemFontOfSize:12];
            recommendLabel.textColor = UIColorFromRGB(0x98999a);
            [careView addSubview:recommendLabel];
            self.recommendLabel = recommendLabel;
            
            UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [changeBtn setTitle:GDLocalizedString(@"换一换") forState:UIControlStateNormal];
            changeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [changeBtn setTitleColor:UIColorWithMobanTheme forState:UIControlStateNormal];
            [changeBtn setTitleColor:UIColorFromRGB(0x98999a) forState:UIControlStateDisabled];
            changeBtn.frame = CGRectMake(tableView.width - 75, recommendLabel.y, 75, 24);
            [changeBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [careView addSubview:changeBtn];
            self.changeView = careView;
            self.changeBtn = changeBtn;
        }
        return self.changeView;
    }
    return nil;
}

#pragma mark - 换一换
- (void)click:(UIButton *)sender
{
    [self recommendPindaosData];
//    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
    //[self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    [self tableViewReload];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 24;
    } else if (section == 1) {
        return 77;
    }
    return 0;
}


- (void)recommendPindaosData {
#warning todo
    
    ZBTUrlCacher *urlCacher = [[ZBTUrlCacher alloc] init];
    NSDictionary *customDict = [urlCacher queryByUrlStr:[ApiUrl reconmmendPindaoUrlStr]];
    [self.recommendPindaos removeAllObjects];
    ZBLog(@"requestRecommendPindaos-----------%@", customDict);
    NSArray* list = customDict[@"list"];
    for (NSDictionary *json in list) {
        Pindao *pindao = [Pindao getPindaoByJson:json];
        if (![PindaoCacher isFocused:HUASHUO_PD kindID:pindao.pindaoId]) {
            [self.recommendPindaos addObject:pindao];
        }
    }
    
    // 如果推荐频道<=2，则隐藏换一换按钮
    if (self.recommendPindaos.count == 0) {
        self.lineView.hidden = YES;
        self.recommendLabel.hidden = YES;
    } else {
        self.lineView.hidden = NO;
        self.recommendLabel.hidden = NO;
    }
    
    if (self.recommendPindaos.count <= 2) {
        self.changeBtn.hidden = YES;
        
    } else
    {
        self.changeBtn.hidden = NO;
    }
    
    self.displayPindaos = [NSMutableArray array];
    
    for (int i=0; i<2 && [self.recommendPindaos count]>0; i++) {
        int index = arc4random()%self.recommendPindaos.count;
        [self.displayPindaos addObject:self.recommendPindaos[index]];
        [self.recommendPindaos removeObjectAtIndex:index];
    }
    
}

/**
 *  请求推荐频道
 */
-(void)requestRecommendPindaos
{
    NetRequest * request =[NetRequest new];
    ZBAppSetting *appsetting = [ZBAppSetting standardSetting];
    NSString *lng = appsetting.longitudeStr;
    NSString *lat = appsetting.latitudeStr;
    NSString *uid = [HuaxoUtil getUdidStr];
    
    NSDictionary * parameters = @{@"app_kind": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"],
                                  @"uid":uid,
                                  @"gps_lng":lng,
                                  @"gps_lat":lat,
                                  @"begin":@"0",
                                  @"plen":@"50"};
    
    [request urlStr:[ApiUrl getNewReconmmendPindaoUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        if (![customDict[@"ret"] integerValue]) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            return ;
        }
        
        ZBTUrlCacher *urlCacher = [[ZBTUrlCacher alloc] init];        
        NSString *urlCacherStr = [ApiUrl reconmmendPindaoUrlStr];
        [urlCacher insertUrlStr:urlCacherStr andJson:customDict];

        ZBLog(@"requestRecommendPindaos------------%@", customDict[@"list"]);
        [self recommendPindaosData];
        [self tableViewReload];
    }];
}
/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end