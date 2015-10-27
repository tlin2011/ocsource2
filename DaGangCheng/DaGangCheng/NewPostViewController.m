//
//  NewPostViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-22.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "NewPostViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "SelectLocationTVC.h"
#import "SelectedPindaoTVC.h"
#import "PindaoCacher.h"
#import "UploadImage.h"
#import "ZBTFaceImage.h"
#import "WaitUploadAudio.h"
#import "Praise.h"

#import "QBImagePickerController.h"
#import "ZBWaitUploadImageView.h"
#import "UITableView+separator.h"

#import "NewLoginContoller.h"

#import "MobClick.h"

#import "ZBAppSetting.h"

#define kTitle @"title"
#define kContent @"content"
#define kPindao @"pindao"
#define kNiming @"niming"
#define kPindaoId @"pindaoId"

@interface NewPostViewController ()<UITableViewDataSource, UITableViewDelegate, SelectLocationDelegate, SelectedPindaoDelegate, UIActionSheetDelegate, UITextFieldDelegate, NewPostBoxViewDelegate, UITextViewDelegate, QBImagePickerControllerDelegate,ZBWaitUploadImageViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (copy, nonatomic) NSString *location; //当前位置
@property (copy, nonatomic) NSString *locationLatitude;
@property (copy, nonatomic) NSString *locationLongitude;

@property (nonatomic, weak) UILabel *locationLabel; // 所在位置
@property (nonatomic, strong) UILabel *pindaoLabel; //频道名称
@property (nonatomic, strong) UISwitch *nimingSwitch; //匿名选择

@property (strong, nonatomic) UIBarButtonItem *sendBarBtn;

@property (nonatomic, strong) ZBWaitUploadImageView *waitView;

@property (nonatomic, strong) NSUserDefaults *defaults;

@property (nonatomic, assign, getter=isSend) BOOL send; // 是否发送成功

@end

@implementation NewPostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [self initUI];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    //键盘工具栏
    [self showNewPostBoxView];

}

- (void)showNewPostBoxView {
//    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:self];
//        return;
//    }
    
    if (!self.boxView) {
        CGRect frame = self.view.frame;
        self.boxView = [[NewPostBoxView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 40)];
        //
        UITextView *contentTV = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
        contentTV.font = [UIFont systemFontOfSize:15];
        contentTV.delegate = self;
        //[self.view addSubview:contentTV];
        self.boxView.contentTV = contentTV;
        self.contentTV = contentTV;
        self.contentTV.text = [self.defaults objectForKey:kContent];
        
        
        if (_subContent && ![_subContent isEqualToString:@""]) {
            self.contentTV.text=_subContent;
        }
    }
    //    self.boxView.postId = self.postID;
    self.boxView.delegate = self;
    self.boxView.dataDelegate = self;
    self.boxView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [self.view addSubview:self.boxView];
}

- (void)NewPostBoxView:(NewPostBoxView *)view drawImage:(UIImage *)image {

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
                
                [self.waitView addImageOnView:upload];
                
            }failureBlock:^(NSError *error) {
                NSLog(@"error=%@",error);
            }];
        }
    }];
}

- (void) hideKeyboard {
    [self.titleText resignFirstResponder];
    [self.contentTV resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.boxView.hidden = YES;
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.boxView.hidden = NO;
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.msgLabel.text = GDLocalizedString(@"请输入内容...");
    }else{
        self.msgLabel.text = @"";
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideKeyboard];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView reloadData];
    //友盟统计
    [MobClick beginLogPageView:GDLocalizedString(@"发帖页面出现")];
    
    if (self.contentTV.text.length) {
        self.msgLabel.text =@"";
    }
}

#pragma mark - 页面即将消失时保存用户编辑内容
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //友盟统计
    [MobClick endLogPageView:GDLocalizedString(@"发帖页面关闭")];
    
    // 隐藏键盘
    [self.view endEditing:YES];
}

#pragma mark - ZBWaitUploadImageViewDelegate
- (void)waitUploadImageviewDidClickedAddPhotoBtn {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:GDLocalizedString(@"取消") destructiveButtonTitle:nil otherButtonTitles:GDLocalizedString(@"拍照"), GDLocalizedString(@"从相册选择"), nil];
    //[as showInView:self.view];
    [as showInView:[UIApplication sharedApplication].keyWindow];
}
- (void)waitUploadImageviewDidRemovedPhotoBtn {
    [self.tableView reloadData];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"拍照");
        [self takePhoto];

    } else if (buttonIndex == 1) {
        NSLog(@"从相册选择");
        [self selectedPhotos];
    }
}

#pragma mark - 相机
- (void)takePhoto {
    
    @try{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }@catch (NSException* ex)
    {
        NSLog(@"takePhoto catch exception:%@",ex);
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"无法打开相机") message:GDLocalizedString(@"可能是由于您使用的是模拟器") delegate:nil cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"确定"),nil];
        [alertView show];
    }
}

//得到图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    
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
                    
                    [self.waitView addImageOnView:upload];
                    
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
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //
    if(![HuaxoUtil isLogined])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:GDLocalizedString(@"您尚未登录") message:GDLocalizedString(@"请登录后再发表新话题") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"确定"), nil];
        [alertView show];
        return ;
    }
}

- (void)initUI{
    
    // 读取草稿
    self.defaults = [NSUserDefaults standardUserDefaults];
    //
    self.msgLabel = [[UILabel alloc] init];
    self.msgLabel.frame = CGRectMake(8, 6, 100, 20);
    self.msgLabel.font = [UIFont systemFontOfSize:15];
    self.msgLabel.text = GDLocalizedString(@"请输入内容...");
    //self.msgLabel.enabled = NO;
    self.msgLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
    self.msgLabel.backgroundColor = [UIColor clearColor];
    //
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //
    CGRect frame = self.tableView.bounds;
    frame.size.height = 27;
    UIView *headview = [[UIView alloc] initWithFrame:frame];
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xe3e3e5);
    [headview addSubview:line];
    self.tableView.tableHeaderView = headview;
    //table没数据时,去掉线
    [self.tableView bottomSeparatorHidden];
    
    //发表按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:GDLocalizedString(@"发表") style:UIBarButtonItemStyleDone target:self action:@selector(sendPost:)];
    self.sendBarBtn = self.navigationItem.rightBarButtonItem;

    //主题
    self.titleText = [[UITextField alloc] initWithFrame:CGRectZero];
    self.titleText.placeholder = GDLocalizedString(@"请输入标题");
    self.titleText.delegate = self;
    self.titleText.font = [UIFont systemFontOfSize:17];
    self.titleText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.titleText.text = [self.defaults objectForKey:kTitle];
    
    if (_subTitle && ![_subTitle isEqualToString:@""]) {
        self.titleText.text=_subTitle;
    }
    
    //
    ZBWaitUploadImageView *waitView = [[ZBWaitUploadImageView alloc] initWithFrame:CGRectZero];
    waitView.delegate = self;
    //[self.view addSubview:waitView];
    self.waitView = waitView;
}

#pragma mark - alertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if(buttonIndex==1)
        {
//            [LoginViewController tologinWithVC:self];
             [NewLoginContoller tologinWithVC:self];
            return ;
        }
    } else  // 询问客户是否保存草稿
    {
        if (buttonIndex == 0) {    // 不保存
            [self.defaults removeObjectForKey:kTitle];
            [self.defaults removeObjectForKey:kContent];
            [self.defaults removeObjectForKey:kPindao];
            [self.defaults removeObjectForKey:kNiming];
            [self.defaults synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {                  // 保存
            [self.defaults setObject:self.titleText.text forKey:kTitle];
            [self.defaults setObject:self.contentTV.text forKey:kContent];
            [self.defaults setObject:self.selectedPindao.name forKey:kPindao];
            [self.defaults setBool:self.nimingSwitch.isOn forKey:kNiming];
            [self.defaults synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
}

-(void)modifyBtnTitle:(NSString*)title button:(UIButton*)btn
{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateSelected];
}
-(void)dismissKeyBoard:(id)sender
{
    [self.titleText resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendPost:(UIButton *)sender
{
     [self newPost];
}

#pragma mark - 返回是否保存草稿
- (void)back:(id)sender
{
    if ((self.titleText.text && ![self.titleText.text isEqualToString:@""]) || (self.contentTV.text && ![self.contentTV.text isEqualToString:@""]) || (self.pindaoLabel.text && ![self.pindaoLabel.text isEqualToString:@""]) || self.nimingSwitch.isOn) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"提示") message:GDLocalizedString(@"您是否要保存草稿?") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"确定"), nil];
        alert.tag = 2;
        [alert show];
    } else
    {
        [self.defaults removeObjectForKey:kTitle];
        [self.defaults removeObjectForKey:kContent];
        [self.defaults removeObjectForKey:kPindao];
        [self.defaults removeObjectForKey:kNiming];
        [self.defaults synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    NSString *addrLoc = self.location?self.location:@"";

    NSMutableString* content = [[NSMutableString alloc] init];
    [content appendString:@""];
    
    //判断图片有没有上传完
    NSString *imageIds = @"";
    for (int i=0; i<[self.waitView.imageList count]; i++) {
        WaitUploadImage *upload = self.waitView.imageList[i];
        if (upload.isUploadSuccess == 0) {
            [Praise hudShowTextOnly:GDLocalizedString(@"图片还未上传完") delegate:self];
            return;
        }
        imageIds = [imageIds stringByAppendingString:upload.imageId];
    }
    [self.contentTV resignFirstResponder];
    
    
    if (self.contentTV.text.length>=1) {
        [content appendString:self.contentTV.text];
    }
    
    //去除ios自带表情
    content = [[ZBTFaceImage stringContainsEmoji:[content copy]] mutableCopy];

    //表情转换
    content = [[ZBTFaceImage wordToFace:[content copy]] mutableCopy];
    
    //判断语音用没有上传完
    NSLog(@"filePath:%@",self.boxView.waitUploadAudio.filePath);
    if (self.boxView.waitUploadAudio.filePath) {
        if (self.boxView.waitUploadAudio.isUploadSuccess) {
            [content appendString:self.boxView.waitUploadAudio.audioId];
            //content = [content stringByAppendingString:self.boxView.waitUploadAudio.audioId];
        }else {
            [Praise hudShowTextOnly:GDLocalizedString(@"语音未上传完,请稍后重试！") delegate:self];
            return;
        }
    }
    
    //追加图片
    [content appendString:imageIds];
    
    NSString *titleStr = self.titleText.text;
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
    } else if (self.selectedPindao.pindaoId == nil) {
        NSString *msgTitle = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"请选择"),[ZBAppSetting standardSetting].pindaoName];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:msgTitle delegate:nil cancelButtonTitle:GDLocalizedString(@"确定") otherButtonTitles:nil];
        [av show];
        return;
    }
    
    self.sendBarBtn.enabled = NO;
    
    NSLog(@"content %@ %@ %@",content,self.locationLongitude, self.locationLatitude
          );
    NSDictionary * parameters =@{
                                 @"uid":[HuaxoUtil getUdidStr],
                                 @"subject":titleStr,
                                 @"kind_id":self.selectedPindao.pindaoId,
                                 @"content":[content copy],
                                 @"xid": @"",
                                 @"xkind": @"",
                                 @"xlen": @"",
                                 @"gps_lng":lng,
                                 @"gps_lat":lat,
                                 @"addr":addrLoc,
                                 @"img_id":@"0",
                                 @"nm_post":self.nimingSwitch.isOn?@"yes":@"no",
                                 };
    
    //__block NewPostViewController * blockself = self;
    [request2 urlStr:[ApiUrl publishTopicUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        if ([(NSNumber*)customDict[@"ret"] intValue]) {
            //[blockself channelPush:[customDict objectForKey:@"post_id"]];
            NSString* post_id = [NSString stringWithFormat:@"%@",customDict[@"post_id"]] ;
            
            //友盟统计
            [MobClick event:@"sendPost" attributes:@{@"pindao_name": self.selectedPindao.pindaoId, @"niming":(self.nimingSwitch.isOn?@"yes":@"no"), @"post_id":post_id}];
            
            
            
            
            PostViewController * next =[[PostViewController alloc] init];
            next.postID = post_id;
            next.hidesBottomBarWhenPushed = YES;

            next.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:next action:@selector(back:)];
            [next.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
            [self.navigationController pushViewController:next animated:YES];
            
            self.send = YES;
            // 帖子发表成功删除草稿
            [self.defaults removeObjectForKey:kTitle];
            [self.defaults removeObjectForKey:kContent];
            [self.defaults removeObjectForKey:kPindao];
            [self.defaults removeObjectForKey:kNiming];
            [self.defaults synchronize];
        }
        else
        {
            NSString* msg = [NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"原因"),customDict[@"msg"]];
            [HuaxoUtil showMsg:msg title:GDLocalizedString(@"发表新话题失败")];
        }
        self.sendBarBtn.enabled = YES;
        
    }];
}

#pragma make - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
        return 3;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0 && indexPath.row ==0) {
        return 44;
    }else if (indexPath.section ==0 && indexPath.row ==1) {
        return 80;
    }else if (indexPath.section ==1 && indexPath.row ==0) {
        int count=0;
        if (self.waitView.imageList.count <= 4-1) {
            count = 1;
        }else if (self.waitView.imageList.count <= 8-1) {
            count = 2;
        } else {
            count = 3;
        }
        return count*75 +16;
    }else if(indexPath.section ==2) {
        return 44;
    }else {
        return 44;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierCell = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    //if (!cell) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    //}
    
    cell.backgroundColor =[UIColor whiteColor];
    cell.textLabel.text = nil;

    
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    
    
    if (indexPath.section ==0 &&indexPath.row==0){
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.titleText.frame = CGRectMake(8, 0, cell.bounds.size.width, cell.bounds.size.height);
        [cell addSubview:self.titleText];
    }else if (indexPath.section ==0 && indexPath.row == 1) {
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell addSubview:self.contentTV];
        [cell addSubview:self.msgLabel];
        
    }else if (indexPath.section ==1 && indexPath.row == 0) {
        
        cell.backgroundColor =[UIColor clearColor];
        self.waitView.frame = cell.bounds;
        [cell addSubview:self.waitView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else if (indexPath.section ==2 && indexPath.row ==0) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(11, 12, 22, 22)];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.image = [[UIImage imageNamed:@"定位_发帖.png"] imageWithMobanThemeColor];
        [cell addSubview:iv];
        //
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 200, 15)];
        lab.font = [UIFont systemFontOfSize:16];
        
        lab.text = self.location ? self.location : GDLocalizedString(@"所在位置");

        self.locationLabel = lab;
        [cell addSubview:lab];
        
    }else if (indexPath.section ==2 && indexPath.row ==1) {

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(11, 12, 22, 22)];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.image = [[UIImage imageNamed:@"频道_发帖.png"] imageWithMobanThemeColor];
        [cell addSubview:iv];
        //
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 100, 15)];
        lab.font = [UIFont systemFontOfSize:16];
        NSString *labTitle = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"选择"),[ZBAppSetting standardSetting].pindaoName];
        lab.text = labTitle;
        [cell addSubview:lab];
        //
        if (!self.pindaoLabel) {
            self.pindaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 15, 140, 15)];
        }
        self.pindaoLabel.textAlignment = NSTextAlignmentRight;
        if (self.selectedPindao==nil) {
            self.selectedPindao = [[Pindao alloc] init];
            self.selectedPindao.name = [self.defaults objectForKey:kPindao];
            self.selectedPindao.pindaoId = [self.defaults objectForKey:kPindaoId];
        }
        
        self.pindaoLabel.text = self.selectedPindao.name;
        self.pindaoLabel.textColor = UIColorFromRGB(0x406192);
        self.pindaoLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15];
        [cell addSubview:self.pindaoLabel];
    }else if (indexPath.section == 2 && indexPath.row == 2){
        
            ZBAppSetting *appSetting = [ZBAppSetting standardSetting];
        
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            //
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(11, 12, 22, 22)];
            iv.contentMode = UIViewContentModeScaleAspectFit;
            iv.image = [[UIImage imageNamed:@"匿名发帖_社区.png"] imageWithMobanThemeColor];
            [cell addSubview:iv];
            //
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 100, 15)];
            lab.font = [UIFont systemFontOfSize:16];
            lab.text = GDLocalizedString(@"匿名发帖");
            [cell addSubview:lab];
            
            //(40, 15, 100, 15)];
            if (!self.nimingSwitch) {
                self.nimingSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(256, 8, 15, 15)];
                [self.nimingSwitch setOnTintColor:UIColorWithMobanTheme];
            }
            self.nimingSwitch.on= [self.defaults boolForKey:kNiming];
        
        
            [cell addSubview:self.nimingSwitch];
        
        if (!appSetting.isOpenAnonymity) {
            [cell setHidden:YES];
        }
    }else {}
    //NSLog(@"cell01 w%f h%f",cell.frame.size.width,cell.frame.size.height);
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        self.waitView.frame = cell.bounds;
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section==2 && indexPath.row==0) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SelectLocationTVC *tvc = [board instantiateViewControllerWithIdentifier:@"SelectLocationTVC"];
        tvc.delegate = self;
        tvc.selectedLocation = self.location;
        [self.navigationController pushViewController:tvc animated:YES];
    } else if (indexPath.section==2 && indexPath.row==1) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SelectedPindaoTVC *tvc = [board instantiateViewControllerWithIdentifier:@"SelectedPindaoTVC"];
        tvc.delegate = self;
        tvc.selectedPindao = self.selectedPindao;
        NSString *msgTitle = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"选择"),[ZBAppSetting standardSetting].pindaoName];
        tvc.title = msgTitle;
        [self.navigationController pushViewController:tvc animated:YES];
    }else {}
}

#pragma mark - 选择相片
- (void)selectedPhotos {
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.title = GDLocalizedString(@"照片");
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
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



//选择当前位置的委托
- (void)SelectLocationTVC:(SelectLocationTVC *)tvc selectedLocation:(NSString *)location {
    self.location = location;
    [self.tableView reloadData];
}
- (void)SelectLocationTVC:(SelectLocationTVC *)tvc selectedLocation:(NSString *)location latitude:(NSString *)latitude longitude:(NSString *)longitude {

    self.location = location;
    self.locationLatitude = latitude;
    self.locationLongitude = longitude;
    [self.tableView reloadData];
}

//选择频道的委托
- (void)SelectedPindaoTVC:(SelectedPindaoTVC *)tvc selectedPindao:(Pindao *)pindao {
    self.selectedPindao = pindao;
    [self.tableView reloadData];
}

- (void)dealloc {
    NSLog(@"NewPostViewController dealloc");
}

@end
