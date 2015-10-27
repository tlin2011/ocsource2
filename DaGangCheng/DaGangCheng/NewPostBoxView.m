//
//  NewPostBoxView.m
//  DaGangCheng
//
//  Created by huaxo on 15-1-20.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "NewPostBoxView.h"

#define TopViewHeight 40
@implementation NewPostBoxView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    //表情
    self.faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, TopViewHeight)];
    //[self.faceBtn setTitle:@"" forState:UIControlStateNormal];
    //[self.faceBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.faceBtn setImage:[UIImage imageNamed:@"icons01.png"] forState:UIControlStateNormal];
    [self.faceBtn setImage:[UIImage imageNamed:@"icons06.png"] forState:UIControlStateSelected];
    [self.faceBtn addTarget:self action:@selector(clickedFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.faceBtn];
    
    //语音
    self.voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, TopViewHeight)];
    //[self.faceBtn setTitle:@"" forState:UIControlStateNormal];
    //[self.faceBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.voiceBtn setImage:[UIImage imageNamed:@"icons05.png"] forState:UIControlStateNormal];
    [self.voiceBtn setImage:[UIImage imageNamed:@"icons06.png"] forState:UIControlStateSelected];
    [self.voiceBtn addTarget:self action:@selector(clickedVoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.voiceBtn];
    
    //提示语音数
    self.audioNumLabel = [[UILabel alloc] init];
    self.audioNumLabel.backgroundColor = [UIColor redColor];
    self.audioNumLabel.textColor = [UIColor whiteColor];
    self.audioNumLabel.frame = CGRectMake(40-14, TopViewHeight/2.0-20, 10, 10);
    self.audioNumLabel.font = [UIFont systemFontOfSize:12];
    self.audioNumLabel.textAlignment = NSTextAlignmentCenter;
    self.audioNumLabel.layer.cornerRadius = self.audioNumLabel.frame.size.width/2.0;
    self.audioNumLabel.layer.masksToBounds = YES;
    self.audioNumLabel.hidden = YES;
    [self.voiceBtn addSubview:self.audioNumLabel];
    
    //画板
    self.drawBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 0, 40, TopViewHeight)];
    //[self.faceBtn setTitle:@"" forState:UIControlStateNormal];
    //[self.faceBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.drawBtn setImage:[UIImage imageNamed:@"draw.png"] forState:UIControlStateNormal];
    [self.drawBtn setImage:[UIImage imageNamed:@"icons06.png"] forState:UIControlStateSelected];
    [self.drawBtn addTarget:self action:@selector(clickedDrawBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.drawBtn];
    
    //键盘按钮
    UIButton* keyboardBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-50, 4, 50, 32)];
    [keyboardBtn setTitle:@"" forState:UIControlStateNormal];
    [keyboardBtn setImage:[UIImage imageNamed:@"icons06_2.png"] forState:UIControlStateNormal];
    //keyboardBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [keyboardBtn addTarget:self action:@selector(keyboardBtnClick:) forControlEvents:UIControlEventTouchUpInside];//keyboard.png
    [self addSubview:keyboardBtn];
    self.keyboardBtn = keyboardBtn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//表情
- (void)clickedFaceBtn:(UIButton *)sender {
    sender.selected = sender.selected?NO:YES;
    self.voiceBtn.selected = NO;
    self.drawBtn.selected = NO;
    
    if (sender.selected) {
        ZBTFaceScrollView *faceView = [[ZBTFaceScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 200)];
        faceView.delegate = self;
        self.contentTV.inputView = faceView;
        [self.contentTV reloadInputViews];
        [self.contentTV becomeFirstResponder];
    } else {
        self.contentTV.inputView = nil;
        [self.contentTV reloadInputViews];
        [self.contentTV becomeFirstResponder];
    }
}

//语音
- (void)clickedVoiceBtn:(UIButton *)sender {
    
    sender.selected = sender.selected?NO:YES;
    self.faceBtn.selected = NO;
    self.drawBtn.selected = NO;
    
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
        self.contentTV.inputView = arv;
        [self.contentTV reloadInputViews];
        [self.contentTV becomeFirstResponder];
        
    }else {
        self.contentTV.inputView=nil;
        
        [self.contentTV reloadInputViews];
        [self.contentTV becomeFirstResponder];
    }
}

//画板
- (void)clickedDrawBtn:(UIButton *)sender {
    sender.selected = sender.selected?NO:YES;
    self.faceBtn.selected = NO;
    self.voiceBtn.selected = NO;
    
    if (sender.selected) {
        if (!self.drawView) {
            self.drawView = [[DrawPictureView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
            self.drawView.delegate = self;
        }
        
        //[self.imageView setBackgroundColor:UIColorFromRGB(0xfbfbfb)];
        //fred
        self.contentTV.inputView = self.drawView;
        [self.contentTV reloadInputViews];
        [self.contentTV becomeFirstResponder];
    } else {
        self.contentTV.inputView=nil;
        
        [self.contentTV reloadInputViews];
        [self.contentTV becomeFirstResponder];
    }

}

- (void)keyboardBtnClick:(UIButton *)sender {
    self.contentTV.inputView = nil;
    self.faceBtn.selected = NO;
    self.voiceBtn.selected = NO;
    self.drawBtn.selected = NO;
    [self.contentTV reloadInputViews];
    [self.contentTV resignFirstResponder];
}

#pragma faceScrollView - delegate
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
    //    CGFloat height = self.inputTV.contentSize.height;
    //    [self changReplyBoxViewHeightWithHeight:height];
}

- (void)faceScrollView:(ZBTFaceScrollView *)faceView selectedDeleteButton:(UIButton *)deleBtn {
    [self.contentTV deleteBackward];
}


#pragma audioRecordView - delegate
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


#pragma drawPictureView - delegate
- (void)drawPictureView:(DrawPictureView *)view uploadImage:(UIImage *)image {
    if (!image) return;
    if ([self.dataDelegate respondsToSelector:@selector(NewPostBoxView:drawImage:)]) {
        [self.dataDelegate NewPostBoxView:self drawImage:image];
        
        [self keyboardBtnClick:nil];
    }
}


- (void)inputToInputTV:(NSString *)text {
    // 获得光标所在的位置
    NSUInteger location = self.contentTV.selectedRange.location;
    // 将UITextView中的内容进行调整（主要是在光标所在的位置进行字符串截取，再拼接你需要插入的文字即可）
    NSString *content = self.contentTV.text;
    NSString *result = [NSString stringWithFormat:@"%@%@%@",[content substringToIndex:location],text,[content substringFromIndex:location]];
    // 将调整后的字符串添加到UITextView上面
    self.contentTV.text = result;
    NSRange range = NSMakeRange(location + text.length, 0);
    self.contentTV.selectedRange = range;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    //NSLog(@"%@", notification);
    //1. 通过notification的userInfo获取键盘的坐标系信息
    NSDictionary *userInfo = notification.userInfo;
    CGSize keyboardSize = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self.delegate.view bringSubviewToFront:self];
    
    CGRect endFrame = self.frame;
    //2. 计算输入框的坐标
    endFrame.origin = CGPointMake(endFrame.origin.x, /*self.superview.frame.size.height*/DeviceHeight-keyboardSize.height - endFrame.size.height);
    
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
