//
//  ZBTSuperCSWebVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-12-9.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ZBTSuperCSWebVC.h"


@interface ZBTSuperCSWebVC ()<PostManagerViewDelegate, ISSShareViewDelegate, UINavigationControllerDelegate>
@property (nonatomic, copy) NSString *saveImagePath;
@end
@implementation ZBTSuperCSWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"更多操作_帖子_查看话题.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(managerBtnClicked:)];
    
    //
    if (!self.navigationItem.leftBarButtonItems) {
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tab_cs_关闭页面.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(backVC:)];
        [backBtn setImageInsets:UIEdgeInsetsMake(0, -4, 0, 4)];
        
        UIBarButtonItem *webBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tab_cs_返回上页.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedWebBackBtn:)];
        [webBackBtn setImageInsets:UIEdgeInsetsMake(0, -4, 0, 4)];
        
        self.navigationItem.leftBarButtonItems = @[webBackBtn, backBtn];
    }
}

- (void)clickedWebBackBtn:(id)sender {
    [self.webView goBack];
}

- (void)back:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)backVC:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSArray *)menuStr {
    return @[@{@"title":GDLocalizedString(@"截图评论"),@"image":@""},
             @{@"title":GDLocalizedString(@"截图分享"),@"image":@""},
             @{@"title":GDLocalizedString(@"复制网址"),@"image":@""},
             //@{@"title":@"收藏",@"image":@"倒序查看_查看话题"}
             ];
}

- (void)managerBtnClicked:(UIBarButtonItem *)sender{

    NSArray *arr3 = [self menuStr];
    
    PostManagerView *managerView = [[PostManagerView alloc] initWithButtonTitles:arr3 delegate:self];
    [managerView show];
}

- (void)postManagerView:(PostManagerView *)view selectedButtonTitle:(NSString *)title {
    NSLog(@"title %@",title);

    if([title isEqualToString:GDLocalizedString(@"截图评论")]) {
        ZBTSuperCSReplyView *rv = [[ZBTSuperCSReplyView alloc] init];
        rv.delegate = self;
        rv.postId = self.postId;
        rv.image = [self screenShot];
        [rv show];
    } else if ([title isEqualToString:GDLocalizedString(@"截图分享")]) {
        [self screenShot];
        [self shareScreen];
    }else if ([title isEqualToString:GDLocalizedString(@"复制网址")]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [self.class stringRemoveToken:self.urlStr];
        [Praise hudShowTextOnly:GDLocalizedString(@"复制网址成功!") delegate:self];
    } else if ([title isEqualToString:GDLocalizedString(@"收藏")]) {
        
    } else {}
}

//去除字符串中的token
+ (NSString *)stringRemoveToken:(NSString *)string {
    NSString *temp = nil;
    
    for (int i=0; i<[string length]-7; i++) {
        temp = [string substringWithRange:NSMakeRange(i, 7)];
        if ([temp isEqualToString:@"&oc_uid"]) {
            string = [string substringToIndex:i];
            return string;
        }
    }
    return string;
}

//截图评论


/**
 *截图功能
 */
-(UIImage *)screenShot{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(DeviceWidth, DeviceHeight), YES, 0);
    
    //设置截屏大小
    
    //[[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = viewImage.CGImage;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    CGRect rect = CGRectMake(0, 0, DeviceWidth*scale_screen, DeviceHeight*scale_screen);//这里可以设置想要截图的区域
    
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    //以下为图片保存代码
    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);//保存图片到照片库
    
    
    NSData *imageViewData = UIImagePNGRepresentation(sendImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pictureName= @"screenShow.png";
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pictureName];
    [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
    
    CGImageRelease(imageRefRect);
    
    self.saveImagePath = savedImagePath;
    
//    //从手机本地加载图片
//    
//    UIImage *bgImage2 = [[UIImage alloc]initWithContentsOfFile:savedImagePath];
    return sendImage;
    
}


-(NSString*)url
{
    NSString *englishName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    englishName = [englishName substringFromIndex:7];
    return [NSString stringWithFormat:@"http://cs.opencom.cn/app/%@/post/%@",englishName, self.postId];
}

- (void)shareScreen {
    
    NSString *desc = [NSString stringWithFormat:@"%@  ",[self.class stringRemoveToken:self.urlStr]];
    if (desc.length>80) {
        desc = [desc substringToIndex:80];
    }
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:desc
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:self.saveImagePath]
                                                title:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_name"]
                                                  url:[self.class stringRemoveToken:self.urlStr]
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    
    //自定义标题栏相关委托
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    //自定义标题栏相关委托
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:GDLocalizedString(@"分享")
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
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:NO
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                    [Praise hudShowTextOnly:GDLocalizedString(@"分享成功") delegate:self];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    [Praise hudShowTextOnly:[NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"分享失败"),[error errorDescription]] delegate:self];
                                }
                            }];
    
}

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType

{
    
    //修改分享编辑框的标题栏颜色
    viewController.navigationController.navigationBar.barTintColor = UIColorWithMobanTheme;
    
    //将分享编辑框的标题栏替换为图片
    //    UIImage *image = [UIImage imageNamed:@"iPhoneNavigationBarBG.png"];
    //    [viewController.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}


- (void)dealloc {

}
@end
