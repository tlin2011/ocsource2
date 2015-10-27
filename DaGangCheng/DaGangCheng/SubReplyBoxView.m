//
//  PostReplyBoxView.m
//  DaGangCheng
//
//  Created by huaxo on 15-1-19.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "SubReplyBoxView.h"
#define TopViewHeight 40
@implementation SubReplyBoxView

#pragma mark Removing toolbar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, TopViewHeight)];
    //[self.faceBtn setTitle:@"" forState:UIControlStateNormal];
    //[self.faceBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.faceBtn setImage:[UIImage imageNamed:@"icons01.png"] forState:UIControlStateNormal];
    [self.faceBtn setImage:[UIImage imageNamed:@"icons06.png"] forState:UIControlStateSelected];
    [self.faceBtn addTarget:self action:@selector(clickedFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.faceBtn];
    
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

- (void)clickedFaceBtn:(UIButton *)sender {
    sender.selected = sender.selected?NO:YES;
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

- (void)keyboardBtnClick:(UIButton *)sender {
    self.contentTV.inputView = nil;
    self.faceBtn.selected = NO;
    [self.contentTV reloadInputViews];
    [self.contentTV resignFirstResponder];
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
//    CGFloat height = self.inputTV.contentSize.height;
//    [self changReplyBoxViewHeightWithHeight:height];
}

- (void)faceScrollView:(ZBTFaceScrollView *)faceView selectedDeleteButton:(UIButton *)deleBtn {
    [self.contentTV deleteBackward];
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
    startFrame.origin = CGPointMake(startFrame.origin.x, DeviceHeight - startFrame.size.height);
    self.frame = startFrame;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
