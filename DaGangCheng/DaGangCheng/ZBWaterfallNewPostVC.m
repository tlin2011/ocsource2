//
//  ZBWaterfallNewPostVC.m
//  DaGangCheng
//
//  Created by huaxo on 15-3-2.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBWaterfallNewPostVC.h"
#import "HuaxoUtil.h"
#import "NetRequest.h"
#import "ZBAppSetting.h"
#import "ZBTFaceImage.h"
#import "Praise.h"
#import "MobClick.h"

#import "NewLoginContoller.h"

#import "PostViewController.h"

#define kTitleKey @"title"
#define kContentKey @"content"

@interface ZBWaterfallNewPostVC ()
@property (nonatomic, strong) UITextField *titleTf;
@property (nonatomic, strong) UIImageView *lineIv;
@property (nonatomic, strong) UITextView *contentTv;
@property (nonatomic, strong) UIBarButtonItem *sendBtn;
@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, strong) ZBWaterfallNewPostBoxView *boxView;

// 草稿本地持久化
@property (nonatomic, strong) NSUserDefaults *defaults;

@property (nonatomic, assign, getter=isSend) BOOL send;
@end

@implementation ZBWaterfallNewPostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [self initSubviews];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.titleTf.text =  [self.defaults objectForKey:kTitleKey];
    self.contentTv.text = [self.defaults objectForKey:kContentKey];
    if (self.contentTv.text.length) {
        self.placeholderLabel.hidden = YES;
    }
}

- (void)initSubviews {
    CGRect frame = self.view.bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = GDLocalizedString(@"晒图");
    
    if(DeviceVersion >= 7.0){
        self.automaticallyAdjustsScrollViewInsets = NO; // Avoid the top UITextView space, iOS7 (~bug?)
    }
    
    //
    self.titleTf = [[UITextField alloc] initWithFrame:CGRectMake(10, 10+64, frame.size.width-10, 45)];
    self.titleTf.placeholder = GDLocalizedString(@"分享新鲜事...(标题)");
    self.titleTf.textColor = [UIColor blackColor];
    self.titleTf.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.titleTf];
    
    //
    self.lineIv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45+10+64, frame.size.width-10, 0.5)];
    self.lineIv.backgroundColor = UIColorFromRGB(0xe0e0e0);
    [self.view addSubview:self.lineIv];
    
    //表情
    [self showSubReplyBoxView];
    
    //
//    self.contentTv = [[UITextView alloc] initWithFrame:CGRectMake(6, 50+64, frame.size.width-6, 110)];
//    self.contentTv.font = [UIFont systemFontOfSize:15];
//    self.contentTv.textColor = [UIColor blackColor];
//    self.contentTv.delegate = self;
//    [self.view addSubview:self.contentTv];
    //self.contentTv.text = @"写点什么吧";
    
    //
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 56+10+64, frame.size.width-10, 20)];
    self.placeholderLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.placeholderLabel.font = [UIFont systemFontOfSize:15];
    self.placeholderLabel.text = GDLocalizedString(@"说说此刻的心情...(选填)");
    [self.view addSubview:self.placeholderLabel];
    
    //
    ZBWaitUploadImageView *waitView = [[ZBWaitUploadImageView alloc] initWithFrame:CGRectMake(0, self.contentTv.frame.size.height + self.contentTv.frame.origin.y, frame.size.width, frame.size.height-(self.contentTv.frame.size.height + self.contentTv.frame.origin.y))];
    waitView.delegate = self;
    [self.view addSubview:waitView];
    self.waitView = waitView;

    for (int i=0; i<[self.assets count]; i++) {
        WaitUploadImage *upload = self.assets[i];
        [self.waitView addImageOnView:upload];
    }
    
    //发表按钮
//    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 32)];
//    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [sendBtn setTitle:@"发表" forState:UIControlStateNormal];
//    [sendBtn setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2]];
//    [sendBtn setFont:[UIFont systemFontOfSize:15]];
//    sendBtn.layer.cornerRadius = 2;
//    [sendBtn addTarget:self action:@selector(sendPost:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
//    self.sendBtn = sendBtn;
    
    //NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"发表" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18]}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(sendPost:)];
    self.sendBtn = self.navigationItem.rightBarButtonItem;
    
    
}

- (void)showSubReplyBoxView {
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:self];
         [NewLoginContoller tologinWithVC:self];
        return;
    }
    
    if (!self.boxView) {
        CGRect frame = self.view.frame;
        self.boxView = [[ZBWaterfallNewPostBoxView alloc] initWithFrame:CGRectMake(0, frame.size.height-40, frame.size.width, 40)];
        //
        UITextView *contentTv = [[UITextView alloc] initWithFrame:CGRectMake(6, 50+10+64, frame.size.width-6, 110)];
        contentTv.font = [UIFont systemFontOfSize:15];
        contentTv.textColor = [UIColor blackColor];
        contentTv.delegate = self;
        [self.view addSubview:contentTv];
        
        //self.boxView.contentTV = contentTv;
        self.contentTv = contentTv;
    }
    //    self.boxView.postId = self.postID;
    self.boxView.delegate = self;
    //    self.boxView.replyDelegate = self;
    self.boxView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [self.view addSubview:self.boxView];
    //[self.boxView.contentTV becomeFirstResponder];
}

- (void)waterfallNewPostBoxViewClickKeyboardBtn {
    [self.contentTv resignFirstResponder];
    [self.titleTf resignFirstResponder];
}

#pragma mark - ZBWaitUploadImageViewDelegate
- (void)waitUploadImageviewDidClickedAddPhotoBtn {
//    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
//    [as showInView:self.view];
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.title = GDLocalizedString(@"照片");
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    for (int i=0; i<[assets count]; i++) {
        ALAsset *asset = assets[i];
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        UIImage *smallImage = [UIImage imageWithCGImage:asset.thumbnail];
        WaitUploadImage *upload = [[WaitUploadImage alloc] init];
        upload.smallImage = smallImage;
        upload.fullImage = image;
        
        [self.waitView addImageOnView:upload];
    }
    
    [self dismissImagePickerController];
}
- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"*** imagePickerControllerDidCancel:");
    
    [self dismissImagePickerController];
}


- (void)sendPost:(id)sender {
    [self newPost];
}

-(void)newPost
{
    
    if(![HuaxoUtil isLogined])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:GDLocalizedString(@"您尚未登录") message:GDLocalizedString(@"请登录后再发表新话题") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"确定"), nil];
        [alertView show];
        return ;
    }
    
    NetRequest * request2 =[[NetRequest alloc]init];
    ZBAppSetting *appsetting = [ZBAppSetting standardSetting];
    NSString *lng = appsetting.longitudeStr;
    NSString *lat = appsetting.latitudeStr;
    NSString *addrLoc = appsetting.address;
    
    NSMutableString* content = [[NSMutableString alloc] init];
    [content appendString:@""];
    
    //判断图片有没有上传完
    NSString *imageIds = @"";
    for (int i=0; i<[self.waitView.imageList count]; i++) {
        WaitUploadImage *upload = self.waitView.imageList[i];
        if (upload.isUploadSuccess == 0) {
            NSLog(@"图片还未上传完");
            [Praise hudShowTextOnly:GDLocalizedString(@"图片还未上传完") delegate:self];
            return;
        }
        imageIds = [imageIds stringByAppendingString:upload.imageId];
    }
    [self.contentTv resignFirstResponder];
    NSLog(@"contentTv.text %@",self.contentTv.text);
    
    if (self.contentTv.text.length>=1) {
        [content appendString:self.contentTv.text];
    }
    [content appendString:imageIds];
    
    //去除ios自带表情
    content = [[ZBTFaceImage stringContainsEmoji:[content copy]] mutableCopy];
    
    //表情转换
    content = [[ZBTFaceImage wordToFace:[content copy]] mutableCopy];
    
//    //判断语音用没有上传完
//    NSLog(@"filePath:%@",self.boxView.waitUploadAudio.filePath);
//    if (self.boxView.waitUploadAudio.filePath) {
//        if (self.boxView.waitUploadAudio.isUploadSuccess) {
//            [content appendString:self.boxView.waitUploadAudio.audioId];
//            //content = [content stringByAppendingString:self.boxView.waitUploadAudio.audioId];
//        }else {
//            [Praise hudShowTextOnly:@"语音未上传完,请稍后重试！" delegate:self];
//            return;
//        }
//    }
    
    NSString *titleStr = self.titleTf.text;
    //去除ios自带表情
    titleStr = [ZBTFaceImage stringContainsEmoji:titleStr];
    //
    if (titleStr.length<2) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:GDLocalizedString(@"标题最少输入2个字") delegate:nil cancelButtonTitle:GDLocalizedString(@"确定") otherButtonTitles:nil];
        [av show];
        return;
    } else if (content.length<1) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:GDLocalizedString(@"内容为空") delegate:nil cancelButtonTitle:GDLocalizedString(@"确定") otherButtonTitles:nil];
        [av show];
        return;
    }
    
    self.sendBtn.enabled = NO;
    
    NSDictionary * parameters =@{
                                 @"uid":[HuaxoUtil getUdidStr],
                                 @"subject":titleStr,
                                 @"kind_id":self.pindaoId,
                                 @"content":[content copy],
                                 @"xid": @"",
                                 @"xkind": @"",
                                 @"xlen": @"",
                                 @"gps_lng":lng,
                                 @"gps_lat":lat,
                                 @"addr":addrLoc,
                                 @"img_id":@"0",
                                 @"nm_post":@"no",
                                 };
    
    //__block NewPostViewController * blockself = self;
    [request2 urlStr:[ApiUrl publishTopicUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        if ([(NSNumber*)customDict[@"ret"] intValue]) {
            //[blockself channelPush:[customDict objectForKey:@"post_id"]];
            NSString* post_id = [NSString stringWithFormat:@"%@",customDict[@"post_id"]] ;
            
            //友盟统计
            [MobClick event:@"sendPost" attributes:@{@"pindao_name": self.pindaoId, @"niming":@"no", @"post_id":post_id}];
            
            
            
            
            PostViewController * next =[[PostViewController alloc] init];
            next.postID = post_id;
            next.hidesBottomBarWhenPushed = YES;
            
            next.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:next action:@selector(back:)];
            [next.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
            [self.navigationController pushViewController:next animated:YES];
            
            self.send = YES;
            // 帖子发表成功删除草稿
            [self.defaults removeObjectForKey:kTitleKey];
            [self.defaults removeObjectForKey:kContentKey];
            [self.defaults synchronize];
            
            //[self dismissViewControllerAnimated:YES completion:nil];
            //[self presentViewController:next animated:YES completion:^{
            
            //}];
        }
        else
        {
            NSString* msg = [NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"原因"),customDict[@"msg"]];
            [HuaxoUtil showMsg:msg title:GDLocalizedString(@"发表新话题失败")];
        }
        self.sendBtn.enabled = YES;
        
    }];
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.placeholderLabel.hidden = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView.text.length) {
        self.placeholderLabel.hidden = YES;
    } else
    {
        self.placeholderLabel.hidden = NO;
    }
    return YES;
}

//- (void)textViewDidChange:(UITextView *)textView
//{
//    if (textView.text.length) {
//        self.placeholderLabel.hidden = YES;
//    }
//    self.placeholderLabel.hidden = NO;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)back:(id)sender
{
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
}

# pragma mark - view将要消失的时候存储草稿
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (!self.isSend) {
        [self.defaults setObject:self.titleTf.text forKey:kTitleKey];
        [self.defaults setObject:self.contentTv.text forKey:kContentKey];
        // 数据同步
        [self.defaults synchronize];
    }
    
}

@end