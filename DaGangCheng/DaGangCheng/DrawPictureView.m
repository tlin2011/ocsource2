//
//  DrawPictureView.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-13.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "DrawPictureView.h"
#import "DrawPad.h"
#import "UploadImage.h"

@interface DrawPictureView ()
@property (nonatomic, strong) DrawPad *drawView;


@property (assign,nonatomic)  BOOL buttonHidden;
@property (assign,nonatomic)  BOOL widthHidden;
@property (assign,nonatomic)  BOOL colorHidden;
@property (assign,nonatomic)  BOOL bgColorsHidden;

@end

@implementation DrawPictureView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    _buttonHidden=YES;
    _widthHidden=YES;
    _colorHidden=YES;
    _bgColorsHidden = YES;
    
    self.drawView=[[DrawPad alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
    [self.drawView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview: self.drawView];
    

    CGRect frame = self.frame;
    //
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-40, frame.size.width, 40)];
    btnView.backgroundColor = UIColorFromRGB(0xfbfbfb);
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [btnView addSubview:line];
    [self addSubview:btnView];
    float edge = 5.0;
    // 创建画板第1个按钮(保存) tag: 1001
    UIButton *saveScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveScreenButton setFrame:CGRectMake(0, 0, 40, 40)];
    [saveScreenButton addTarget:self action:@selector(saveScreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveScreenButton setImage:[UIImage imageNamed:@"保存_画板.png"] forState:UIControlStateNormal];
    [saveScreenButton setImage:[UIImage imageNamed:@"保存_画板_h.png"] forState:UIControlStateHighlighted];
    [saveScreenButton setImageEdgeInsets:UIEdgeInsetsMake(edge, edge, edge, edge)];
    saveScreenButton.tag = 1001;
    [btnView addSubview:saveScreenButton];
    
    // 创建画板第2个按钮(清屏) tag: 1002
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setFrame:CGRectMake(40, 0, 40, 40)];
    [clearButton addTarget:self action:@selector(clearButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setImage:[UIImage imageNamed:@"清空_画板.png"] forState:UIControlStateNormal];
    [clearButton setImage:[UIImage imageNamed:@"清空_画板_h.png"] forState:UIControlStateHighlighted];
    [clearButton setImageEdgeInsets:UIEdgeInsetsMake(edge, edge, edge, edge)];
    clearButton.tag = 1002;
    [btnView addSubview:clearButton];
    
    // 创建画板第3个按钮(颜色) tag: 1003
    UIButton *colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [colorButton setFrame:CGRectMake(80, 0, 40, 40)];
    [colorButton addTarget:self action:@selector(drawPadPenColorsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [colorButton setImage:[UIImage imageNamed:@"颜色_画板.png"] forState:UIControlStateNormal];
    [colorButton setImage:[UIImage imageNamed:@"颜色_画板_h.png"] forState:UIControlStateHighlighted];
    [colorButton setImageEdgeInsets:UIEdgeInsetsMake(edge, edge, edge, edge)];
    colorButton.tag = 1003;
    [btnView addSubview:colorButton];
    
    // 创建画板第4个按钮(宽度) tag: 1004
    UIButton *changeWidthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeWidthButton setFrame:CGRectMake(120, 0, 40, 40)];
    [changeWidthButton addTarget:self action:@selector(drawPadPenWidthButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [changeWidthButton setImage:[UIImage imageNamed:@"笔宽_画板.png"] forState:UIControlStateNormal];
    [changeWidthButton setImage:[UIImage imageNamed:@"笔宽_画板_h.png"] forState:UIControlStateHighlighted];
    [changeWidthButton setImageEdgeInsets:UIEdgeInsetsMake(edge, edge, edge, edge)];
    changeWidthButton.tag = 1004;
    [btnView addSubview:changeWidthButton];
    
    // 创建画板第5个按钮(画板背景颜色) tag: 1005
    UIButton *backgroundColorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backgroundColorButton setFrame:CGRectMake(160, 0, 40, 40)];
    [backgroundColorButton addTarget:self action:@selector(drawPadBackgroundColorsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundColorButton setImage:[UIImage imageNamed:@"背景色_画板.png"] forState:UIControlStateNormal];
    [backgroundColorButton setImage:[UIImage imageNamed:@"背景色_画板_h.png"] forState:UIControlStateHighlighted];
    [backgroundColorButton setImageEdgeInsets:UIEdgeInsetsMake(edge, edge, edge, edge)];
    backgroundColorButton.tag = 1005;
    [btnView addSubview:backgroundColorButton];
    
    // 创建画板第6个按钮(后退) tag: 1006
    UIButton *undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [undoButton setFrame:CGRectMake(200, 0, 40, 40)];
    [undoButton addTarget:self action:@selector(undoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [undoButton setImage:[UIImage imageNamed:@"后退_画板.png"] forState:UIControlStateNormal];
    [undoButton setImage:[UIImage imageNamed:@"后退_画板_h.png"] forState:UIControlStateHighlighted];
    //[undoButton setImageEdgeInsets:UIEdgeInsetsMake(edge, edge, edge, edge)];
    undoButton.tag = 1006;
    [btnView addSubview:undoButton];
    
    // 创建画板第7个按钮(前进) tag: 1007
    UIButton *redoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redoButton setFrame:CGRectMake(240, 0, 40, 40)];
    [redoButton addTarget:self action:@selector(redoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [redoButton setImage:[UIImage imageNamed:@"前进_画板.png"] forState:UIControlStateNormal];
    [redoButton setImage:[UIImage imageNamed:@"前进_画板_h.png"] forState:UIControlStateHighlighted];
    //[redoButton setImageEdgeInsets:UIEdgeInsetsMake(edge, edge, edge, edge)];
    redoButton.tag = 1007;
    [btnView addSubview:redoButton];
    
    // 创建画板第8个按钮(上图) tag: 1008
    UIButton *uploadPicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [uploadPicButton setFrame:CGRectMake(280, 0.5, 40, 40)];
    [uploadPicButton addTarget:self action:@selector(uploadPic:) forControlEvents:UIControlEventTouchUpInside];
    [uploadPicButton setImage:[[UIImage imageNamed:@"上传_画板.png"] imageWithMobanThemeColor] forState:UIControlStateNormal];
    [uploadPicButton setImage:[[UIImage imageNamed:@"上传_画板_h.png"] imageWithMobanThemeColor] forState:UIControlStateHighlighted];
    [uploadPicButton setImageEdgeInsets:UIEdgeInsetsMake(4, 10, 15, 9)];
    [uploadPicButton setTitle:GDLocalizedString(@"上传") forState:UIControlStateNormal];
    [uploadPicButton setTitleColor:UIColorWithMobanTheme forState:UIControlStateNormal];
    [uploadPicButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [uploadPicButton setTitleEdgeInsets:UIEdgeInsetsMake(25, -25, 0, 0)];
    [uploadPicButton setBackgroundColor:[UIColor whiteColor]];
    uploadPicButton.tag = 1008;
    [btnView addSubview:uploadPicButton];
    
#pragma mark 涂鸦板的笔头颜色
    
    // 创建画板笔头颜色底板 tag: 1100
    UIView *penColorsPad = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [penColorsPad setFrame:CGRectMake(0, 0, 320, 80)];
    penColorsPad.backgroundColor=[UIColor colorWithRed:0.0 green:0.2 blue:0.5 alpha:0.2];
    penColorsPad.tag = 1100;
    penColorsPad.hidden = YES;
    [self.drawView addSubview:penColorsPad];
    
    // 创建画板第1个颜色按钮 tag: 1101
    UIButton *colorButton1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [colorButton1 setFrame:CGRectMake(19, 25, 30, 30)];
    [colorButton1 addTarget:self action:@selector(setDrawPadPenColor:) forControlEvents:UIControlEventTouchUpInside];
    [colorButton1 setBackgroundImage:[UIImage imageNamed:@"circleColor00.png"] forState:UIControlStateNormal];
    colorButton1.tag = 1101;
    colorButton1.hidden = YES;
    [self.drawView addSubview:colorButton1];
    
    // 创建画板第2个颜色按钮 tag: 1102
    UIButton *colorButton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [colorButton2 setFrame:CGRectMake(55, 25, 30, 30)];
    [colorButton2 addTarget:self action:@selector(setDrawPadPenColor:) forControlEvents:UIControlEventTouchUpInside];
    [colorButton2 setBackgroundImage:[UIImage imageNamed:@"circleColor01.png"] forState:UIControlStateNormal];
    colorButton2.tag = 1102;
    colorButton2.hidden = YES;
    [self.drawView addSubview:colorButton2];
    
    // 创建画板第3个颜色按钮 tag: 1103
    UIButton *colorButton3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [colorButton3 setFrame:CGRectMake(91, 25, 30, 30)];
    [colorButton3 addTarget:self action:@selector(setDrawPadPenColor:) forControlEvents:UIControlEventTouchUpInside];
    [colorButton3 setBackgroundImage:[UIImage imageNamed:@"circleColor02.png"] forState:UIControlStateNormal];
    colorButton3.tag = 1103;
    colorButton3.hidden = YES;
    [self.drawView addSubview:colorButton3];
    
    // 创建画板第4个颜色按钮 tag: 1104
    UIButton *colorButton4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [colorButton4 setFrame:CGRectMake(127, 25, 30, 30)];
    [colorButton4 addTarget:self action:@selector(setDrawPadPenColor:) forControlEvents:UIControlEventTouchUpInside];
    [colorButton4 setBackgroundImage:[UIImage imageNamed:@"circleColor03.png"] forState:UIControlStateNormal];
    colorButton4.tag = 1104;
    colorButton4.hidden = YES;
    [self.drawView addSubview:colorButton4];
    
    // 创建画板第5个颜色按钮 tag: 1105
    UIButton *colorButton5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [colorButton5 setFrame:CGRectMake(163, 25, 30, 30)];
    [colorButton5 addTarget:self action:@selector(setDrawPadPenColor:) forControlEvents:UIControlEventTouchUpInside];
    [colorButton5 setBackgroundImage:[UIImage imageNamed:@"circleColor04.png"] forState:UIControlStateNormal];
    colorButton5.tag = 1105;
    colorButton5.hidden = YES;
    [self.drawView addSubview:colorButton5];
    
    // 创建画板第6个颜色按钮 tag: 1106
    UIButton *colorButton6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [colorButton6 setFrame:CGRectMake(199, 25, 30, 30)];
    [colorButton6 addTarget:self action:@selector(setDrawPadPenColor:) forControlEvents:UIControlEventTouchUpInside];
    [colorButton6 setBackgroundImage:[UIImage imageNamed:@"circleColor05.png"] forState:UIControlStateNormal];
    colorButton6.tag = 1106;
    colorButton6.hidden = YES;
    [self.drawView addSubview:colorButton6];
    
    // 创建画板第7个颜色按钮 tag: 1107
    UIButton *colorButton7 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [colorButton7 setFrame:CGRectMake(235, 25, 30, 30)];
    [colorButton7 addTarget:self action:@selector(setDrawPadPenColor:) forControlEvents:UIControlEventTouchUpInside];
    [colorButton7 setBackgroundImage:[UIImage imageNamed:@"circleColor06.png"] forState:UIControlStateNormal];
    colorButton7.tag = 1107;
    colorButton7.hidden = YES;
    [self.drawView addSubview:colorButton7];
    
    // 创建画板第8个颜色按钮 tag: 1108
    UIButton *colorButton8 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [colorButton8 setFrame:CGRectMake(271, 25, 30, 30)];
    [colorButton8 addTarget:self action:@selector(setDrawPadPenColor:) forControlEvents:UIControlEventTouchUpInside];
    [colorButton8 setBackgroundImage:[UIImage imageNamed:@"circleColor07.png"] forState:UIControlStateNormal];
    colorButton8.tag = 1108;
    colorButton8.hidden = YES;
    [self.drawView addSubview:colorButton8];
    
#pragma mark 涂鸦板的笔头宽度
    
    // 创建画板笔头宽度底板 tag: 1200
    UIView *palettePad = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [palettePad setFrame:CGRectMake(0, 0, 320, 80)];
    palettePad.backgroundColor = [UIColor colorWithRed:0.0 green:0.2 blue:0.5 alpha:0.2];
    palettePad.tag = 1200;
    palettePad.hidden = YES;
    [self.drawView addSubview:palettePad];
    [self.drawView bringSubviewToFront:palettePad];
    
    // 创建笔头宽度拖拉条 tag: 1201
    UISlider *widthSlider = [[UISlider alloc] initWithFrame:CGRectMake(60, 30, 200, 10)];
    widthSlider.minimumValue = 1.0;
    widthSlider.maximumValue = 22.0;
    widthSlider.value = 6.0;
    widthSlider.tag = 1201;
    widthSlider.hidden = YES;
    [widthSlider addTarget:self action:@selector(setWidthSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.drawView addSubview:widthSlider];
    [self.drawView setlineWidth:5];
    
    // 创建Label "1" tag: 1202
    UILabel *widthLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(70, 50, 20, 20)];
    [widthLabel1 setText:@"1"];
    widthLabel1.tag = 1202;
    widthLabel1.hidden = YES;
    [self.drawView addSubview:widthLabel1];
    
    // 创建Label "8" tag: 1203
    UILabel *widthLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(127, 50, 20, 20)];
    [widthLabel2 setText:@"8"];
    widthLabel2.tag = 1203;
    widthLabel2.hidden = YES;
    [self.drawView addSubview:widthLabel2];
    
    // 创建Label "15" tag: 1204
    UILabel *widthLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(177, 50, 20, 20)];
    [widthLabel3 setText:@"15"];
    widthLabel3.tag = 1204;
    widthLabel3.hidden = YES;
    [self.drawView addSubview:widthLabel3];
    
    // 创建Label "22" tag: 1205
    UILabel *widthLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(236, 50, 20, 20)];
    [widthLabel4 setText:@"22"];
    widthLabel4.tag = 1205;
    widthLabel4.hidden = YES;
    [self.drawView addSubview:widthLabel4];
    
#pragma mark 涂鸦板的背景颜色
    // --- ---
    UIColor *bgColor1 = [UIColor colorWithRed:243/255.0 green:241/255.0 blue:218/255.0 alpha:1];
    
    UIColor *bgColor2 = [UIColor colorWithRed:255/255.0 green:242/255.0 blue:143/255.0 alpha:1];
    
    UIColor *bgColor3 = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    
    UIColor *bgColor4 = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    
    UIColor *bgColor5 = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    
    UIColor *bgColor6 = [UIColor colorWithRed:193/255.0 green:232/255.0 blue:249/255.0 alpha:1];
    
    UIColor *bgColor7 = [UIColor colorWithRed:249/255.0 green:231/255.0 blue:181/255.0 alpha:1];
    
    UIColor *bgColor8 = [UIColor colorWithRed:254/255.0 green:233/255.0 blue:232/255.0 alpha:1];
    
    UIColor *bgColor9 = [UIColor colorWithRed:252/255.0 green:211/255.0 blue:217/255.0 alpha:1];
    
    // 创建画板背景色底板 tag: 1300
    UIView *backgroundColorsPad = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backgroundColorsPad setFrame:CGRectMake(10, 40, 300, 180)];
    backgroundColorsPad.backgroundColor=[UIColor colorWithRed:0.0 green:0.2 blue:0.5 alpha:0.2];
    backgroundColorsPad.tag = 1300;
    backgroundColorsPad.hidden = YES;
    [self.drawView addSubview:backgroundColorsPad];
    
    // 创建画板第1个背景颜色按钮 tag: 1301
    UIButton *backgroundButton1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backgroundButton1 setFrame:CGRectMake(15, 45, 93, 53)];
    [backgroundButton1 addTarget:self action:@selector(setDrawPadBackgroundColor:) forControlEvents:UIControlEventTouchUpInside];
    backgroundButton1.backgroundColor = bgColor1;
    backgroundButton1.tag = 1301;
    backgroundButton1.hidden = YES;
    [self.drawView addSubview:backgroundButton1];
    
    // 创建画板第2个背景颜色按钮 tag: 1302
    UIButton *backgroundButton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backgroundButton2 setFrame:CGRectMake(113, 45, 93, 53)];
    [backgroundButton2 addTarget:self action:@selector(setDrawPadBackgroundColor:) forControlEvents:UIControlEventTouchUpInside];
    backgroundButton2.backgroundColor = bgColor2;
    backgroundButton2.tag = 1302;
    backgroundButton2.hidden = YES;
    [self.drawView addSubview:backgroundButton2];
    
    // 创建画板第3个背景颜色按钮 tag: 1303
    UIButton *backgroundButton3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backgroundButton3 setFrame:CGRectMake(211, 45, 93, 53)];
    [backgroundButton3 addTarget:self action:@selector(setDrawPadBackgroundColor:) forControlEvents:UIControlEventTouchUpInside];
    backgroundButton3.backgroundColor = bgColor3;
    backgroundButton3.tag = 1303;
    backgroundButton3.hidden = YES;
    [self.drawView addSubview:backgroundButton3];
    
    
    // 创建画板第4个背景颜色按钮 tag: 1304
    UIButton *backgroundButton4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backgroundButton4 setFrame:CGRectMake(15, 103, 93, 53)];
    [backgroundButton4 addTarget:self action:@selector(setDrawPadBackgroundColor:) forControlEvents:UIControlEventTouchUpInside];
    backgroundButton4.backgroundColor = bgColor4;
    backgroundButton4.tag = 1304;
    backgroundButton4.hidden = YES;
    [self.drawView addSubview:backgroundButton4];
    
    // 创建画板第5个背景颜色按钮 tag: 1305
    UIButton *backgroundButton5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backgroundButton5 setFrame:CGRectMake(113, 103, 93, 53)];
    [backgroundButton5 addTarget:self action:@selector(setDrawPadBackgroundColor:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundButton5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backgroundButton5.backgroundColor = bgColor5;
    backgroundButton5.tag = 1305;
    backgroundButton5.hidden = YES;
    [self.drawView addSubview:backgroundButton5];
    
    // 创建画板第6个背景颜色按钮 tag: 1306
    UIButton *backgroundButton6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backgroundButton6 setFrame:CGRectMake(211, 103, 93, 53)];
    [backgroundButton6 addTarget:self action:@selector(setDrawPadBackgroundColor:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundButton6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backgroundButton6.backgroundColor = bgColor6;
    backgroundButton6.tag = 1306;
    backgroundButton6.hidden = YES;
    [self.drawView addSubview:backgroundButton6];
    
    // 创建画板第7个背景颜色按钮 tag: 1307
    UIButton *backgroundButton7 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backgroundButton7 setFrame:CGRectMake(15, 161, 93, 53)];
    [backgroundButton7 addTarget:self action:@selector(setDrawPadBackgroundColor:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundButton7 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backgroundButton7.backgroundColor = bgColor7;
    backgroundButton7.tag = 1307;
    backgroundButton7.hidden = YES;
    [self.drawView addSubview:backgroundButton7];
    
    // 创建画板第8个背景颜色按钮 tag: 1308
    UIButton *backgroundButton8 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backgroundButton8 setFrame:CGRectMake(113, 161, 93, 53)];
    [backgroundButton8 addTarget:self action:@selector(setDrawPadBackgroundColor:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundButton8 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backgroundButton8.backgroundColor = bgColor8;
    backgroundButton8.tag = 1308;
    backgroundButton8.hidden = YES;
    [self.drawView addSubview:backgroundButton8];
    
    // 创建画板第9个背景颜色按钮 tag: 1309
    UIButton *backgroundButton9 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backgroundButton9 setFrame:CGRectMake(211, 161, 93, 53)];
    [backgroundButton9 addTarget:self action:@selector(setDrawPadBackgroundColor:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundButton9 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backgroundButton9.backgroundColor = bgColor9;
    backgroundButton9.tag = 1309;
    backgroundButton9.hidden = YES;
    [self.drawView addSubview:backgroundButton9];

}



// 保存画板内容到相册 (Jes)
- (IBAction)saveScreenButtonClick:(id)sender {
    
    for(UIView *tmpView in [self.drawView subviews])
    {
        if (tmpView.tag >= 1100 && tmpView.tag <= 1108)
        {
            tmpView.hidden = YES;
            self.colorHidden = YES;
        }
        if (tmpView.tag >= 1200 && tmpView.tag <= 1205)
        {
            tmpView.hidden = YES;
            self.widthHidden = YES;
        }
        if (tmpView.tag >= 1300 && tmpView.tag <= 1309)
        {
            tmpView.hidden = YES;
            self.bgColorsHidden = YES;
        }
    }
    
    UIGraphicsBeginImageContext(self.drawView.bounds.size);
    //    CGContextRef c = UIGraphicsGetCurrentContext();
    //    CGContextTranslateCTM(c, 0, 200);    // <-- shift everything up by 40px when drawing.
    //    [self.view.layer renderInContext:c];
    [self.drawView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    //截屏成功
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:GDLocalizedString(@"涂鸦已保存到相册") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    [alertView show];
    //    [alertView release];
    
}

// 清除画板的内容 (Jes)
-(IBAction)clearButtonClick:(id)sender{
    [self.drawView clear];
    
}

// 点击画板后退按钮 (Jes)
-(void)undoButtonClick:(id)sender{
    [ self.drawView revocation];
}

// 点击画板前进按钮 (Jes)
-(void)redoButtonClick:(id)sender{
    [ self.drawView refrom];
}

// 点击画板笔头颜色按钮 (Jes)
-(IBAction)drawPadPenColorsButtonClick:(id)sender
{
    for (int i=1200; i<=1205; i++)
    {
        UIView *tmpView = (UIView *)[self.drawView viewWithTag:i];
        tmpView.hidden = YES;
        self.widthHidden = YES;
    }
    
    for (int i=1300; i<=1309; i++)
    {
        UIView *tmpView = (UIView *)[self.drawView viewWithTag:i];
        tmpView.hidden = YES;
        self.bgColorsHidden = YES;
    }
    
    //    if (self.colorHidden == YES) {
    
    for(UIView *tmpView in [self.drawView subviews])
    {
        if (tmpView.tag >= 1100 && tmpView.tag <= 1108)
        {
            if (tmpView.hidden == YES) {
                tmpView.hidden = NO;
            }
            
            else{tmpView.hidden = YES;}
            //                tmpView.hidden = NO;
            //                self.colorHidden = NO;
        }
    }
    //    }
    //    else
    //    {
    //        for(UIView *tmpView in [self.drawView subviews])
    //        {
    //            if (tmpView.tag >= 1100 && tmpView.tag <= 1108)
    //            {
    //                tmpView.hidden = YES;
    //                self.colorHidden = YES;
    //            }
    //        }
    //    }
}

// 点击画板背景色按钮 (Jes)
-(IBAction)drawPadBackgroundColorsButtonClick:(id)sender
{
    for (int i=1100; i<=1108; i++)
    {
        UIView *tmpView = (UIView *)[self.drawView viewWithTag:i];
        tmpView.hidden = YES;
        self.colorHidden = YES;
    }
    
    for (int i=1200; i<=1205; i++)
    {
        UIView *tmpView = (UIView *)[self.drawView viewWithTag:i];
        tmpView.hidden = YES;
        self.widthHidden = YES;
    }
    
    //    if (self.bgColorsHidden == YES) {
    //
    for(UIView *tmpView in [self.drawView subviews])
    {
        if (tmpView.tag >= 1300 && tmpView.tag <= 1309)
        {
            if (tmpView.hidden == YES) {
                tmpView.hidden = NO;
            }
            else {tmpView.hidden = YES;}
            //                tmpView.hidden = NO;
            //                self.bgColorsHidden = NO;
        }
    }
    //    }
    //    else
    //    {
    //        for(UIView *tmpView in [self.drawView subviews])
    //        {
    //            if (tmpView.tag >= 1300 && tmpView.tag <= 1309)
    //            {
    //                tmpView.hidden = YES;
    //                self.bgColorsHidden = YES;
    //            }
    //        }
    //    }
}

// 设置画板背景色 (Jes)
- (IBAction)setDrawPadBackgroundColor:(id)sender {
    UIColor *bgColor1 = [UIColor colorWithRed:243/255.0 green:241/255.0 blue:218/255.0 alpha:1];
    
    UIColor *bgColor2 = [UIColor colorWithRed:255/255.0 green:242/255.0 blue:143/255.0 alpha:1];
    
    UIColor *bgColor3 = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    
    UIColor *bgColor4 = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    
    UIColor *bgColor5 = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    
    UIColor *bgColor6 = [UIColor colorWithRed:193/255.0 green:232/255.0 blue:249/255.0 alpha:1];
    
    UIColor *bgColor7 = [UIColor colorWithRed:249/255.0 green:231/255.0 blue:181/255.0 alpha:1];
    
    UIColor *bgColor8 = [UIColor colorWithRed:254/255.0 green:233/255.0 blue:232/255.0 alpha:1];
    
    UIColor *bgColor9 = [UIColor colorWithRed:252/255.0 green:211/255.0 blue:217/255.0 alpha:1];
    
    if ([sender tag] == 1301)
    {
        [self.drawView setBackgroundColor:bgColor1];
    }
    else if ([sender tag] == 1302)
    {
        [self.drawView setBackgroundColor:bgColor2];
    }
    else if ([sender tag] == 1303)
    {
        [self.drawView setBackgroundColor:bgColor3];
    }
    else if ([sender tag] == 1304)
    {
        [self.drawView setBackgroundColor:bgColor4];
    }
    
    else if ([sender tag] == 1305)
    {
        [self.drawView setBackgroundColor:bgColor5];
    }
    
    else if ([sender tag] == 1306)
    {
        [self.drawView setBackgroundColor:bgColor6];
    }
    
    else if ([sender tag] == 1307)
    {
        [self.drawView setBackgroundColor:bgColor7];
    }
    
    else if ([sender tag] == 1308)
    {
        [self.drawView setBackgroundColor:bgColor8];
    }
    
    else if ([sender tag] == 1309)
    {
        [self.drawView setBackgroundColor:bgColor9];
    }
    
    for(UIView *tmpView in [self.drawView subviews])
    {
        if (tmpView.tag >= 1300 && tmpView.tag <= 1309)
        {
            tmpView.hidden = YES;
            self.bgColorsHidden = YES;
        }
    }
}

-(IBAction)drawPadPenWidthButtonClick:(id)sender
{
    for (int i=1100; i<=1108; i++)
    {
        UIView *tmpView = (UIView *)[self.drawView viewWithTag:i];
        tmpView.hidden = YES;
        self.colorHidden = YES;
    }
    
    for (int i=1300; i<=1309; i++)
    {
        UIView *tmpView = (UIView *)[self.drawView viewWithTag:i];
        tmpView.hidden = YES;
        self.bgColorsHidden = YES;
    }
    
    //    if (self.widthHidden==YES)
    //    {
    //        for (int i=1200; i<=1205; i++)
    //        {
    //            UIView *tempView=(UIView *)[self.drawView viewWithTag:i];
    //            tempView.hidden=NO;
    //            self.widthHidden=NO;
    //        }
    
    for(UIView *tmpView in [self.drawView subviews])
    {
        if (tmpView.tag >= 1200 && tmpView.tag <= 1205)
        {
            if (tmpView.hidden == YES) {
                tmpView.hidden = NO;
            }
            else {tmpView.hidden = YES;}
            //                tmpView.hidden = NO;
            //                self.bgColorsHidden = NO;
        }
    }
    //    }
    //    else
    //    {
    //        for (int i=1200; i<=1205; i++)
    //        {
    //            UIView *button=(UIView *)[self.drawView viewWithTag:i];
    //            button.hidden=YES;
    //            self.widthHidden=YES;
    //        }
    //    }
}

- (IBAction)setDrawPadPenWidth:(id)sender {
    UIButton *button=(UIButton *)sender;
    [self.drawView setlineWidth:button.tag-1301];
    
    for (int i=1301; i<=1304; i++) {
        UIButton *button=(UIButton *)[self.drawView viewWithTag:i];
        button.hidden=YES;
        self.widthHidden=YES;
    }
}

- (IBAction)setDrawPadPenColor:(id)sender {
    UIButton *button=(UIButton *)sender;
    [self.drawView setLineColor:button.tag-1101];
    //self.colorButton.backgroundColor=[colors objectAtIndex:button.tag-1101];
    
    for(UIView *tmpView in [self.drawView subviews])
    {
        if (tmpView.tag >= 1100 && tmpView.tag <= 1108)
        {
            tmpView.hidden = YES;
            self.colorHidden = YES;
        }
    }
}


// 涂鸦上传图片 (Jes)
- (IBAction)uploadPic:(id)sender
{
    for(UIView *tmpView in [self.drawView subviews])
    {
        if (tmpView.tag >= 1100 && tmpView.tag <= 1108)
        {
            tmpView.hidden = YES;
            self.colorHidden = YES;
        }
        if (tmpView.tag >= 1200 && tmpView.tag <= 1205)
        {
            tmpView.hidden = YES;
            self.widthHidden = YES;
        }
        if (tmpView.tag >= 1300 && tmpView.tag <= 1309)
        {
            tmpView.hidden = YES;
            self.bgColorsHidden = YES;
        }
    }
    
    //   UIGraphicsBeginImageContextWithOptions(CGSizeMake(640, 960), YES, 0);
    UIGraphicsBeginImageContext(self.drawView.bounds.size);
    [self.drawView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    CGRect rect = CGRectMake(0, 0, 320, 260);//设置想要截图的区域
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    if ([self.delegate respondsToSelector:@selector(drawPictureView:uploadImage:)]) {
        [self.delegate drawPictureView:self uploadImage:sendImage];
    }
    
    for(UIView *tmpView in [self.drawView subviews])
    {
        if (tmpView.tag >= 1001 && tmpView.tag <= 1008)
        {
            tmpView.hidden = NO;
        }
    }
}

//UIButton *button=(UIButton *)sender;
//[self.drawView setlineWidth:button.tag-1301];
//
//for (int i=1301; i<=1304; i++) {
//    UIButton *button=(UIButton *)[self.drawView viewWithTag:i];
//    button.hidden=YES;
//    self.widthHidden=YES;
//}

- (IBAction)setWidthSliderValueChanged:(id)sender
{
    for(UISlider *tmpView in [self.drawView subviews])
    {
        
        if (tmpView.tag == 1201)
        {
            float tempFloat = tmpView.value;
            int tempInteger = (int)tempFloat;
            [self.drawView setlineWidth:tempInteger - 1];
        }
    }
}

- (void)dealloc {

}

@end
