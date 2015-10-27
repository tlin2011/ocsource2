//
//  replyBoxView.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-11.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "replyBoxView.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "NetRequest.h"
#import "ApiUrl.h"
#import "ZBAppSetting.h"
#import "HuaxoUtil.h"
#import "Praise.h"

#import "AudioRecordView.h"

#import "UploadAudio.h"
#import "WaitUploadImageView.h"
#import "UploadImage.h"
#import "WaitUploadImage.h"
#import "DrawPictureView.h"
#import "WaitUploadAudio.h"
#import "QBImagePickerController.h"

#import "ZBTFaceScrollView.h"
#import "ZBTFaceImage.h"


#define TopViewHeight 44
#define AddButtonClickedViewHeight 200
@interface ReplyBoxView ()<UITextViewDelegate,UIPageViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WaitUploadImageDelegate, AudioRecordDelegate, DrawPictureDelegate,ZBTFaceScrollViewDelegate, QBImagePickerControllerDelegate>
{
    UIScrollView *scrollView;
    UIPageControl *pageControl;
}

@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) AudioRecordView *audioView;
@property (nonatomic, strong) WaitUploadImageView *imageView;
@property (nonatomic, strong) DrawPictureView *drawView;

@property (nonatomic, strong) UILabel *imageNumLabel;
@property (nonatomic, strong) UILabel *imageNumLabel2;
@property (nonatomic, strong) UILabel *audioNumLabel;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) WaitUploadAudio *waitUploadAudio;


@end

@implementation ReplyBoxView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, TopViewHeight)];
    [self.voiceBtn setTitle:@"" forState:UIControlStateNormal];
    [self.voiceBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.voiceBtn setImage:[UIImage imageNamed:@"语音_回复.png"] forState:UIControlStateNormal];
    [self.voiceBtn setImage:[[UIImage imageNamed:@"语音_回复_s.png"] imageWithMobanThemeColor] forState:UIControlStateSelected];
    [self.voiceBtn addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.voiceBtn];
    
    //提示语音数
    self.audioNumLabel = [[UILabel alloc] init];
    self.audioNumLabel.backgroundColor = [UIColor redColor];
    self.audioNumLabel.textColor = [UIColor whiteColor];
    self.audioNumLabel.frame = CGRectMake(0, 0, 10, 10);
    self.audioNumLabel.center = CGPointMake(self.voiceBtn.frame.size.width/2.0+12, self.voiceBtn.frame.size.height/2.0-12);
    self.audioNumLabel.font = [UIFont systemFontOfSize:12];
    self.audioNumLabel.textAlignment = NSTextAlignmentCenter;
    self.audioNumLabel.layer.cornerRadius = self.audioNumLabel.frame.size.width/2.0;
    self.audioNumLabel.layer.masksToBounds = YES;
    self.audioNumLabel.hidden = YES;
    [self.voiceBtn addSubview:self.audioNumLabel];
    
    self.addBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, TopViewHeight)];
    [self.addBtn setTitle:@"" forState:UIControlStateNormal];
    [self.addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"添加_回复.png"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"添加_回复_h.png"] forState:UIControlStateHighlighted];
    [self.addBtn setImage:[[UIImage imageNamed:@"添加_回复_s.png"] imageWithMobanThemeColor] forState:UIControlStateSelected];
    [self.addBtn addTarget:self action:@selector(clickedAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addBtn];
    //提示图片数
    self.imageNumLabel = [[UILabel alloc] init];
    self.imageNumLabel.backgroundColor = [UIColor redColor];
    self.imageNumLabel.textColor = [UIColor whiteColor];
    self.imageNumLabel.frame = CGRectMake(0, 0, 14, 14);
    self.imageNumLabel.center = CGPointMake(self.addBtn.frame.size.width/2.0+12, self.addBtn.frame.size.height/2.0-12);
    self.imageNumLabel.font = [UIFont systemFontOfSize:12];
    self.imageNumLabel.textAlignment = NSTextAlignmentCenter;
    self.imageNumLabel.layer.cornerRadius = self.imageNumLabel.frame.size.width/2.0;
    self.imageNumLabel.layer.masksToBounds = YES;
    self.imageNumLabel.hidden = YES;
    [self.addBtn addSubview:self.imageNumLabel];
    
    self.inputTV = [[UITextView alloc] initWithFrame:CGRectMake(80, 5, self.frame.size.width- 80-50, TopViewHeight-5*2)];
    self.inputTV.font = [UIFont systemFontOfSize:15];
    self.inputTV.layer.cornerRadius = 5.0f;
    self.inputTV.layer.masksToBounds = YES;
    self.inputTV.layer.borderColor = UIColorFromRGB(0xe9e9e9).CGColor;
    self.inputTV.layer.borderWidth = 1.0f;
    self.inputTV.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedInputView:)];
    [self.inputTV addGestureRecognizer:tap];
    [self addSubview:self.inputTV];
    
    self.sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width- 48, 0, 48, TopViewHeight)];
    [self.sendBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
//    [self.sendBtn setTitle:@"发表" forState:UIControlStateNormal];
//    [self.sendBtn setTitleColor:UIColorFromRGB(0x828d96) forState:UIControlStateNormal];
//    [self.sendBtn setFont:[UIFont systemFontOfSize:15]];
//    self.sendBtn.layer.cornerRadius = 3;
//    self.sendBtn.layer.masksToBounds = YES;
//    self.sendBtn.layer.borderColor = UIColorFromRGB(0x828d96).CGColor;
//    self.sendBtn.layer.borderWidth = 1;
    [self.sendBtn setImage:[UIImage imageNamed:@"发表.png"] forState:UIControlStateNormal];
    [self.sendBtn setImage:[UIImage imageNamed:@"发表.png"] forState:UIControlStateHighlighted];
    [self addSubview:self.sendBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImageNumLabelValue:) name:@"WaitUploadImageView_ImageList_Change" object:nil];
    
    
}

- (void)changeImageNumLabelValue:(NSNotification *)noti {
    NSString *numStr = noti.userInfo[@"NumStr"];
    if ([numStr integerValue]<=0) {
        self.imageNumLabel.hidden = YES;
        self.imageNumLabel2.hidden = YES;
    } else {
        self.imageNumLabel.text = [NSString stringWithFormat:@"%ld",(long)[numStr integerValue]];
        self.imageNumLabel2.text = [NSString stringWithFormat:@"%ld",(long)[numStr integerValue]];
        self.imageNumLabel.hidden = NO;
        self.imageNumLabel2.hidden = NO;
    }
}

- (void)sendMessage {
    self.voiceBtn.selected = NO;
    self.addBtn.selected = NO;

    //判断图片有没有上传完
    NSString *imageIds = @"";
    for (int i=0; i<[self.imageView.imageList count]; i++) {
        WaitUploadImage *upload = self.imageView.imageList[i];
        if (upload.isUploadSuccess == 0) {
            NSLog(@"还有图片没有上传完");
            [Praise hudShowTextOnly:GDLocalizedString(@"图片还未上传完")  delegate:self.delegate];
            return;
        }
        imageIds = [imageIds stringByAppendingString:upload.imageId];
    }
    [self.inputTV resignFirstResponder];
    NSLog(@"inputTV.text %@",self.inputTV.text);
    self.content = self.inputTV.text;
    
    
    //表情转换
    self.content = [ZBTFaceImage wordToFace:self.content];
    
    //判断语音用没有上传完
    NSLog(@"filePath:%@",self.waitUploadAudio.filePath);
    if (self.waitUploadAudio.filePath) {
        if (self.waitUploadAudio.isUploadSuccess) {
            self.content = [self.content stringByAppendingString:self.waitUploadAudio.audioId];
        }else {
            [Praise hudShowTextOnly:GDLocalizedString(@"语音未上传完,请稍后重试！") delegate:self];
            return;
        }
    }

    //追加图片
    self.content = [self.content stringByAppendingString:imageIds];
    
    [self replyPost:self.content];
}

- (void)clickedAddBtn:(UIButton *)sender {
    self.voiceBtn.selected = NO;
    
    sender.selected = sender.selected ? NO: YES;
    
    if (sender.selected == YES) {
        //[self.inputTV resignFirstResponder];
        if (!self.addView) {

            CGRect frame = self.bounds;
            frame.size.height = AddButtonClickedViewHeight;
            UIView *view = [[UIView alloc] initWithFrame:frame];
            view.backgroundColor = UIColorFromRGB(0xfbfbfb);
            
            NSArray *textArr = @[GDLocalizedString(@"表情"),@"表情_添加.png",@"表情_添加_h.png",
                                 GDLocalizedString(@"图片"),@"图片_添加.png",@"图片_添加_h.png",
                                 GDLocalizedString(@"拍照"),@"拍照_添加.png",@"拍照_添加_h.png",
                                 GDLocalizedString(@"画板"),@"画板_添加.png",@"画板_添加_h.png"];
            CGFloat btnWidth = 50;
            CGFloat width = (DeviceWidth - 20*2 - 4*btnWidth)/3 + btnWidth;
            for (int i=0; i<4; i++) {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+i%4*width, 15+i/4*70, 50, 75)];
                [btn setTitle:textArr[i*3] forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [btn setTitleColor:UIColorFromRGB(0x6b7178) forState:UIControlStateNormal];
                //[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor clearColor]];
                
                [btn setImage:[UIImage imageNamed:textArr[i*3+1]] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:textArr[i*3+2]] forState:UIControlStateHighlighted];
                [btn setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(55, -52, 0, 0)];
                [btn addTarget:self action:@selector(clickedAddViewInBtn:) forControlEvents:UIControlEventTouchUpInside];
                
                if ([textArr[i*3] isEqualToString:GDLocalizedString(@"图片")]) {
                    //提示图片数
                    self.imageNumLabel2 = [[UILabel alloc] init];
                    self.imageNumLabel2.backgroundColor = [UIColor redColor];
                    self.imageNumLabel2.textColor = [UIColor whiteColor];
                    self.imageNumLabel2.frame = CGRectMake(50-7, 0, 14, 14);
                    self.imageNumLabel2.font = [UIFont systemFontOfSize:12];
                    self.imageNumLabel2.textAlignment = NSTextAlignmentCenter;
                    self.imageNumLabel2.layer.cornerRadius = self.imageNumLabel.frame.size.width/2.0;
                    self.imageNumLabel2.layer.masksToBounds = YES;
                    self.imageNumLabel2.hidden = YES;
                    [btn addSubview:self.imageNumLabel2];
                }
                
                //btn.backgroundColor = [UIColor orangeColor];
                [view addSubview:btn];
                self.addView = view;
            }
        }
        
        self.inputTV.inputView = self.addView;
        [self.inputTV reloadInputViews];
        [self.inputView becomeFirstResponder];
    }else {
        self.inputTV.inputView = nil;
        [self.inputTV reloadInputViews];
        [self.inputTV becomeFirstResponder];
    }
    
}

- (void) clickedAddViewInBtn:(UIButton *)sender {
    NSString *title = [sender titleForState:UIControlStateNormal];
    NSLog(@"title %@",title);
    if ([title isEqualToString:GDLocalizedString(@"表情")]) {
        [self clickedFaceBtn:sender];
    } else if ([title isEqualToString:GDLocalizedString(@"图片")]) {
        [self clickedImageBtn:sender];
    } else if ([title isEqualToString:GDLocalizedString(@"拍照")]) {
        [self clickedCameraBtn:sender];
    } else if ([title isEqualToString:GDLocalizedString(@"画板")]) {
        [self clickedDrawBtn:sender];
    }
    
}

- (void)clickedFaceBtn:(UIButton *)sender {

    ZBTFaceScrollView *faceView = [[ZBTFaceScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 200)];
    faceView.delegate = self;
    self.inputTV.inputView = faceView;
    [self.inputTV reloadInputViews];
    [self.inputTV becomeFirstResponder];
    
    
}

- (void)faceScrollView:(ZBTFaceScrollView *)faceView selectedFaceName:(NSString *)faceName {
    NSString *str = faceName;
    NSLog(@"face %@",str);
    NSArray *arr = [str componentsSeparatedByString:@"."];
    NSString *faceId = arr.firstObject;
    NSLog(@"faceId=%@", faceId);
    if (!faceId) {
        return;
    }
    faceId = [NSString stringWithFormat:@"[%@]",faceId];
    
    NSString *faceText = [ZBTFaceImage faceTextByFaceId:faceId];
    if (!faceText) return;
    [self inputToInputTV:faceText];

    //replyBoxView调高
    CGFloat height = self.inputTV.contentSize.height;
    [self changReplyBoxViewHeightWithHeight:height];
}

- (void)faceScrollView:(ZBTFaceScrollView *)faceView selectedDeleteButton:(UIButton *)deleBtn {
    [self.inputTV deleteBackward];
}


- (void)inputToInputTV:(NSString *)text {
    // 获得光标所在的位置
    NSUInteger location = self.inputTV.selectedRange.location;
    // 将UITextView中的内容进行调整（主要是在光标所在的位置进行字符串截取，再拼接你需要插入的文字即可）
    NSString *content = self.inputTV.text;
    NSString *result = [NSString stringWithFormat:@"%@%@%@",[content substringToIndex:location],text,[content substringFromIndex:location]];
    // 将调整后的字符串添加到UITextView上面
    self.inputTV.text = result;
    NSRange range = NSMakeRange(location + text.length, 0);
    self.inputTV.selectedRange = range;

    [self textViewDidChange:self.inputTV];
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat height = textView.contentSize.height;
    [self changReplyBoxViewHeightWithHeight:height];
}

//ReplyBoxView 调高
- (void)changReplyBoxViewHeightWithHeight:(int)height {
    if (height <=0 || height > 80) {
        return;
    }

    CGRect frame = self.frame;
    CGRect endFrame = CGRectZero;
    
    endFrame = CGRectMake(frame.origin.x, frame.origin.y+frame.size.height - (height+10), frame.size.width, height+10);
    self.frame = endFrame;
    
    CGRect voiceFrame = self.voiceBtn.frame;
    voiceFrame.size.height = endFrame.size.height;
    self.voiceBtn.frame = voiceFrame;
    self.audioNumLabel.center = CGPointMake(self.voiceBtn.frame.size.width/2.0+12, self.voiceBtn.frame.size.height/2.0-12);
    
    CGRect addFrame = self.addBtn.frame;
    addFrame.size.height = endFrame.size.height;
    self.addBtn.frame = addFrame;
    self.imageNumLabel.center = CGPointMake(self.addBtn.frame.size.width/2.0+12, self.addBtn.frame.size.height/2.0-12);
    
    CGRect inputFrame = self.inputTV.frame;
    inputFrame.size.height = height;
    self.inputTV.frame = inputFrame;
    
    CGRect sendFrame = self.sendBtn.frame;
    sendFrame.size.height = endFrame.size.height;
    self.sendBtn.frame = sendFrame;
    
}

//图片
- (void)clickedImageBtn:(UIButton *)sender {
    if (!self.imageView) {
        self.imageView =[[WaitUploadImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        self.imageView.delegate = self;
    }
    
    [self.imageView setBackgroundColor:UIColorFromRGB(0xfbfbfb)];
    //fred
    self.inputTV.inputView = self.imageView;
    [self.inputTV reloadInputViews];
    [self.inputTV becomeFirstResponder];
    
    //[self pickPhoto:nil];
}

//照相
- (void)clickedCameraBtn:(UIButton *)sender {
    if (!self.imageView) {
        self.imageView =[[WaitUploadImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        self.imageView.delegate = self;
    }
    [self takePhoto:nil];
}

- (void)waitUploadImageViewdidClickedAddPhotoBtn {
    [self pickPhoto:nil];
}

- (void)takePhoto:(id)sender
{
    @try{
        [self.inputTV resignFirstResponder];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.delegate presentViewController:picker animated:YES completion:nil];
    }@catch (NSException* ex)
    {
        NSLog(@"takePhoto catch exception:%@",ex);
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"无法打开相机" message:@"可能是由于您使用的是虚拟机" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alertView show];
    }
}
- (void)pickPhoto:(id)sender;
{
    [self.inputTV resignFirstResponder];
    
    //
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.title = GDLocalizedString(@"照片");
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self.delegate presentViewController:navigationController animated:YES completion:NULL];
}

- (void)dismissImagePickerController
{
    if ([self.delegate presentedViewController]) {
        [self.delegate dismissViewControllerAnimated:YES completion:Nil];
    } else {
        [self.delegate.navigationController popToViewController:self.delegate animated:YES];
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
        
        [self.imageView addImageOnView:upload];
    }
    
    [self.delegate dismissViewControllerAnimated:YES completion:^{
        [self.delegate.view addSubview:self];
        [self.inputTV becomeFirstResponder];
        [self clickedImageBtn:nil];
    }];
}
- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"*** imagePickerControllerDidCancel:");
    
    [self dismissImagePickerController];
    
    [self.delegate.view addSubview:self];
    [self.inputTV becomeFirstResponder];
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
                    
                    [self.imageView addImageOnView:upload];
                    //[self uploadImg:nil image:image];
                }failureBlock:^(NSError *error) {
                    NSLog(@"error=%@",error);
                }];
            }
        }];
    }

    //[self.delegate dismissModalViewControllerAnimated:YES];
    [self.delegate dismissViewControllerAnimated:YES completion:^{
        [self.delegate.view addSubview:self];
        [self.inputTV becomeFirstResponder];
        [self clickedImageBtn:nil];
    }];
}

//画板
- (void)clickedDrawBtn:(UIButton *)sender {

    if (!self.drawView) {
        self.drawView = [[DrawPictureView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        self.drawView.delegate = self;
    }
    
    //[self.imageView setBackgroundColor:UIColorFromRGB(0xfbfbfb)];
    //fred
    self.inputTV.inputView = self.drawView;
    [self.inputTV reloadInputViews];
    [self.inputTV becomeFirstResponder];
    
}

- (void)drawPictureView:(DrawPictureView *)view uploadImage:(UIImage *)image {
    WaitUploadImage *upload = [[WaitUploadImage alloc] init];
    upload.smallImage = image;
    upload.fullImage = image;
    
    [self clickedImageBtn:nil];
    
    [self.imageView addImageOnView:upload];
}

#pragma mark Removing toolbar

- (void)keyboardWillShow:(NSNotification *)notification {
    
    //NSLog(@"%@", notification);
    //1. 通过notification的userInfo获取键盘的坐标系信息
    NSDictionary *userInfo = notification.userInfo;
    CGSize keyboardSize = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self.delegate.view bringSubviewToFront:self];
    
    CGRect endFrame = self.frame;
    //2. 计算输入框的坐标
    endFrame.origin = CGPointMake(endFrame.origin.x, self.superview.frame.size.height-keyboardSize.height - endFrame.size.height);
    
    //3. 动画地改变坐标
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.frame = endFrame;
    } completion:nil];
    
}

- (void)keyboardWillHide:(NSNotification *)notification{
    CGRect startFrame = self.frame;
    startFrame.origin = CGPointMake(startFrame.origin.x, DeviceHeight);
    self.frame = startFrame;
}

- (void)clickedInputView:(UITapGestureRecognizer *)sender {
    self.inputTV.inputView = nil;
    [self.inputTV reloadInputViews];
    [self.inputTV becomeFirstResponder];
}

//语音
- (void)record:(UIButton*)sender
{
    self.addBtn.selected = NO;
    sender.selected = sender.selected?NO:YES;
    if (sender.selected)
    {
        //[self.inputTV resignFirstResponder];
        AudioRecordView *arv = nil;
        if (self.audioView) {
            arv = self.audioView;
        } else {
            arv=[[AudioRecordView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
            arv.delegate = self;
            arv.hiddenSendBtn = YES;
            self.audioView = arv;
        }
        self.inputTV.inputView = arv;
        [self.inputTV reloadInputViews];
        [self.inputTV becomeFirstResponder];
        
    }else {
        self.inputTV.inputView=nil;
        
        [self.inputTV reloadInputViews];
        [self.inputTV becomeFirstResponder];
    }
}

- (void)audioRecordView:(AudioRecordView *)arv createdAudio:(NSString *)path audioLen:(long)len {
    if(path==nil) return;
    NSData* tmpData =  [NSData dataWithContentsOfFile:path];
    if(!tmpData) return;
    /*
     NSString* fileName = [NSString stringWithFormat:@"0_user_tmp%.0f.%ld.bgamr", [NSDate timeIntervalSinceReferenceDate] * 1000.0,len];
     NSString* newfilePath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(),fileName];
     */
    NSArray* array = [path componentsSeparatedByString:@"/"];
    NSString* fileName = array[[array count]-1 ];
    NSLog(@"sendAudio newFilePath=%@  fileName=%@",path,fileName);
    BOOL isSaved = [tmpData writeToFile:path atomically:NO];
    if (!isSaved) {
        NSLog(@"%@文件保存失败！", path);
        return;
    }
    self.audioNumLabel.hidden = NO;
    self.waitUploadAudio = [[WaitUploadAudio alloc] init];
    self.waitUploadAudio.filePath = path;
    self.waitUploadAudio.isUploadSuccess = NO;
    
    [UploadAudio uploadWithFilePath:path completed:^(NSString *audioStr, NSError *error) {
        if (audioStr) {
            self.waitUploadAudio.audioId = audioStr;
            self.waitUploadAudio.isUploadSuccess = YES;
            //self.content = audioStr;
            //[self replyPost:self.content];
        }
    }];
    
    return;
}

//取消语音
- (void)audioRecordViewWithCancelAudio:(AudioRecordView *)arv {
    self.audioNumLabel.hidden = YES;
    self.waitUploadAudio = [[WaitUploadAudio alloc] init];
    self.waitUploadAudio.filePath = nil;
    self.waitUploadAudio.isUploadSuccess = NO;
}

//回复一级评论
-(void)replyPost:(NSString *)content {
    
    NetRequest *request =[[NetRequest alloc] init];
    ZBAppSetting *appsetting = [ZBAppSetting standardSetting];
    
    if (content.length<1) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:GDLocalizedString(@"输入内容为空!") delegate:nil cancelButtonTitle:GDLocalizedString(@"确定") otherButtonTitles:nil];
        [av show];
        return;
    }
    
    self.sendBtn.enabled = NO;
    
    NSDictionary * parameters =@{
                                 @"post_id": self.postId,
                                 @"content":content,
                                 @"uid": [HuaxoUtil getUdidStr],
                                 @"xid": @"",
                                 @"xkind": @"",
                                 @"xlen": @"",
                                 @"gps_lng":appsetting.longitudeStr,
                                 @"gps_lat":appsetting.latitudeStr,
                                 @"addr":appsetting.address,
                                 };
    
    [request urlStr:[ApiUrl replyPlusUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        self.sendBtn.enabled = YES;
        
        if(![customDict[@"ret"] intValue])
        {
            NSLog(@"reply failed!  %@",customDict );
            [self.replyDelegate failedReplyWithReplyBoxView:self msg:customDict[@"msg"]];
            return ;
        }
        
        [self updateView];
        
        //委托
        [self.replyDelegate finishedReplyWithReplyBoxView:self];

    }];
    
}

- (void)updateView {
    //清除变量的数据
    self.inputTV.inputView = nil;
    [self.inputTV reloadInputViews];
    self.imageView=nil;
    self.imageNumLabel.hidden = YES;
    self.imageNumLabel2.hidden = YES;
    self.audioNumLabel.hidden = YES;
    self.content = nil;
    self.inputTV.text = @"";

    NSLog(@"lineHeight %f",self.inputTV.font.lineHeight);
    [self changReplyBoxViewHeightWithHeight:TopViewHeight-5*2];

    self.audioView = nil;
    self.waitUploadAudio = nil;
    
    [self.inputTV resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
