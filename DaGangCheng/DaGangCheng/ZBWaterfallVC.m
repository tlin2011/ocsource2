//
//  ZBWaterfallVC.m
//  DaGangCheng
//
//  Created by huaxo on 15-2-11.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBWaterfallVC.h"


#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"

#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

#import "NetRequest.h"
#import "ApiUrl.h"
#import "PostLockedSQL.h"
#import "ZBTUrlCacher.h"
#import "Post.h"
#import "WaitUploadImage.h"
#import "LoginViewController.h"

#import "NewLoginContoller.h"

#import "ZBPostJumpTool.h"

@interface ZBWaterfallVC ()
@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSMutableArray *cellSizes;
@property (nonatomic, assign) int beginCount;
@end

@implementation ZBWaterfallVC

#pragma mark - Accessors
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.headerHeight = 0;
        layout.footerHeight = 0;
        layout.minimumColumnSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xeceff2);
        [_collectionView registerClass:[CHTCollectionViewWaterfallCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:FOOTER_IDENTIFIER];
    }
    return _collectionView;
}

#pragma mark - Life Cycle

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    
    [_footer free];
    [_header free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"瀑布流_拍照.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedCameraBarBtn)];
    
    [self.view addSubview:self.collectionView];
    
    self.beginCount = 0;
    self.dataList = [[NSMutableArray alloc] init];
    
    [self addHeader];
    [self addFooter];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataList count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHTCollectionViewWaterfallCell *cell =
    (CHTCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    Post *post = self.dataList[indexPath.item];
    cell.post = post;
    cell.delegate = self;
    [cell layoutSubviews];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = self.dataList[indexPath.item];
    CGSize size = [post getImageWidthAndHeightByImageId:[post.imageList firstObject]];
    //图片校正
    size.height = size.height>2.5*size.width?2.5*size.width:size.height;
    size.width = size.width>2.5*size.height?2.5*size.height:size.width;
    
    //size.height = size.height + (size.height*1.0/size.width)*45;
    return size;
}

#pragma mark - CHTCollectionViewWaterfallCellDelegate
- (void)collectionViewWaterfallCellDidClicked:(CHTCollectionViewWaterfallCell *)cell {
    Post *post = cell.post;
    // index不传值，随便传个数字
    [ZBPostJumpTool intoPage:post.postId withIndex:0 delegate:nil vc:self urlStr:post.postUrl];
}
- (void)collectionViewWaterfallCellDidLongPressed:(CHTCollectionViewWaterfallCell *)cell {
    NSLog(@"长按");
    //[cell showManagerView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[ZBWaterfallMangerView sharedManager] removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)requestPost:(MJRefreshBaseView *)refreshView
{
    NetRequest * request =[NetRequest new];
    
    self.beginCount = self.isPullDownRefreshing ? 0: self.beginCount;
    NSDictionary * parmeters = @{@"id": self.pindaoId,
                                 @"gps_lng": @"",
                                 @"gps_lat": @"",
                                 @"begin":[NSString stringWithFormat:@"%d",self.beginCount],
                                 @"plen":@"10",
                                 @"need_flag":@"true",
                                 @"need_img":@"true",
                                 @"need_imgs":@"yes",
                                 @"need_whs":@"yes"
                                 };
    
    [request urlStr:[ApiUrl pindaoImageUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
        if (![customDict[@"ret"] integerValue]) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            if (customDict[@"not_have"] && [customDict[@"not_have"] intValue] == 1) {
                [refreshView noHaveMoreData];
                return ;
            }
            [refreshView loadingDataFail];
            return ;
        }
        self.beginCount += 10; //plen
        [refreshView endRefreshing];
        if (self.isPullDownRefreshing) {
            [self.dataList removeAllObjects];
            
            if ([customDict[@"list"] count]>0) {
                ZBTUrlCacher *urlCacher = [[ZBTUrlCacher  alloc] init];
                
                [urlCacher insertUrlStr:[self urlCacherStr] andJson:customDict];
                //[urlCacher queryAll];
            }
            
        }
        self.isPullDownRefreshing = NO;
        self.dataList = !self.dataList || [self.dataList count]<=0 ? [[NSMutableArray alloc]init]:self.dataList;
        
        NSArray* list = customDict[@"list"];
        
        for(int i=0;i<[list count];i++){
            NSMutableDictionary* data = [list[i] mutableCopy];
            
            Post *post = [Post getPostByJson:data andRemoveSmallImageWithWidth:60];
            PostLockedSQL *pSql = [[PostLockedSQL alloc] init];
            if ([pSql isExistingByPostId:post.postId]) {
                post.isLocked = YES;
            }
            
            if (![post.imageList isKindOfClass:[NSNull class]] && [post.imageList count] >= 1) {
                [self.dataList addObject:post];
            }
        }
        //回到主线程执行
        //dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        //});
    }];
}

- (NSString *)urlCacherStr {
    NSString *Id = [NSString stringWithFormat:@"%@#id:%@",[ApiUrl neBbsPostUrlStr],self.pindaoId];
    return Id;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - -- 上下拉刷新
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.collectionView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self beginRefreshing:refreshView];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    
    _footer = footer;
}

- (void)addHeader
{
    __weak ZBWaterfallVC *vc = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.collectionView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        
        vc.isPullDownRefreshing = YES;
        [vc beginRefreshing:refreshView];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        //[vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    
    //未用到
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
}

//上下拉刷新调用
- (void)beginRefreshing:(MJRefreshBaseView *)refreshView {
    [self requestPost:refreshView];
}

- (void)clickedCameraBarBtn {
    
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:self];
            [NewLoginContoller tologinWithVC:self];
        return;
    }
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:GDLocalizedString(@"取消") destructiveButtonTitle:nil otherButtonTitles:GDLocalizedString(@"拍照"), GDLocalizedString(@"从相册选择"), nil];
    [as showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex == 0) {
        [self takePhoto];
    } else if (buttonIndex == 1) {
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.minimumNumberOfSelection = 1;
        imagePickerController.maximumNumberOfSelection = 9;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.title = GDLocalizedString(@"照片");
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}

- (void)dismissImagePickerController
{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:Nil];
    } else {
        [self.navigationController popToViewController:self animated:YES];
    }
}

#pragma mark - QBImagePickerControllerDelegate
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    NSLog(@"*** imagePickerController:didSelectAsset:");
    NSLog(@"%@", asset);
    
    [self dismissImagePickerController];
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSLog(@"*** imagePickerController:didSelectAssets:");
    NSLog(@"%@", assets);
    
    NSMutableArray *imageList = [[NSMutableArray alloc] init];
    for (int i=0; i<[assets count]; i++) {
        ALAsset *asset = assets[i];
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        UIImage *smallImage = [UIImage imageWithCGImage:asset.thumbnail];
        WaitUploadImage *upload = [[WaitUploadImage alloc] init];
        upload.smallImage = smallImage;
        upload.fullImage = image;
        
        //[self.waitView addImageOnView:upload];
        [imageList addObject:upload];
    }
    
    //[self dismissImagePickerController];
    [self dismissViewControllerAnimated:NO completion:^{
        [self toZBWaterfallNewPostVCWithAssets:[imageList copy]];
    }];
}

- (void)toZBWaterfallNewPostVCWithAssets:(NSArray *)assets {
    ZBWaterfallNewPostVC *vc = [[ZBWaterfallNewPostVC alloc] init];
    vc.pindaoId = self.pindaoId;
    vc.assets = assets;
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:vc action:@selector(back:)];
    [vc.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"*** imagePickerControllerDidCancel:");
    
    [self dismissImagePickerController];
}


- (void)takePhoto {
    
    @try{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }@catch (NSException* ex)
    {
        NSLog(@"takePhoto catch exception:%@",ex);
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"无法打开相机" message:@"可能是由于您使用的是虚拟机" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alertView show];
    }
}

//得到图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    NSMutableArray *imageList = [[NSMutableArray alloc] init];
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //图片 不能直接用这个image上传，会发生旋转
        UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            if (error) {
                // TODO: error handling
            } else {
                // TODO: success handling
                NSLog(@"assetURL %@",assetURL);
                //根据图片的url反取图片
                ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
                [assetLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset)  {
                    UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                    UIImage *smallImage = [UIImage imageWithCGImage:asset.thumbnail];
                    WaitUploadImage *upload = [[WaitUploadImage alloc] init];
                    upload.smallImage = smallImage;
                    upload.fullImage = image;
                    
                    [imageList addObject:upload];
                    
                    [self dismissViewControllerAnimated:NO completion:^{
                        [self toZBWaterfallNewPostVCWithAssets:[imageList copy]];
                    }];

                }failureBlock:^(NSError *error) {
                    NSLog(@"error=%@",error);
                    [self dismissViewControllerAnimated:YES completion:Nil];
                }];
            }
        }];
    }
    else{
//        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
//        [assetLibrary assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset)  {
//            UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//            
//            UIImage *smallImage = [UIImage imageWithCGImage:asset.thumbnail];
//            WaitUploadImage *upload = [[WaitUploadImage alloc] init];
//            upload.smallImage = smallImage;
//            upload.fullImage = image;
//            [imageList addObject:upload];
//            
//        }failureBlock:^(NSError *error) {
//            NSLog(@"error=%@",error);
//        }];
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
    //[self dismissViewControllerAnimated:YES completion:Nil];
}
@end
