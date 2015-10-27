//
//  WeatherView.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-1.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "WeatherView.h"
#import "NetRequest.h"
#import "ArchiverAndUnarchiver.h"
#import "ZBAppSetting.h"

@implementation WeatherView
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 20)];
    self.weatherImageView.clipsToBounds = YES;
    self.weatherImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.weatherImageView];
    
    self.weather = [[UILabel alloc] initWithFrame:CGRectMake(self.weatherImageView.frame.size.width+1, 0, 22, 20)];
    self.weather.font = [UIFont systemFontOfSize:20.0];
    self.weather.textColor = UIColorWithMobanThemeSub;
    [self addSubview:self.weather];
    
    self.weatherText = [[UILabel alloc] initWithFrame:CGRectMake(self.weather.frame.origin.x + self.weather.frame.size.width+1, 0, 40, 8)];
    self.weatherText.font = [UIFont systemFontOfSize:8];
    self.weatherText.textColor = UIColorWithMobanThemeSub;
    [self addSubview:self.weatherText];
    
    self.weatherC = [[UILabel alloc] initWithFrame:CGRectMake(self.weather.frame.origin.x + self.weather.frame.size.width+1, 12, 20, 8)];
    self.weatherC.font = [UIFont systemFontOfSize:8];
    self.weatherC.textColor = UIColorWithMobanThemeSub;
    [self addSubview:self.weatherC];
    
    [self addTarget:self action:@selector(weatherHandleSingleFingerEvent) forControlEvents:UIControlEventTouchUpInside];
    
    
    //调用天气方法
    [self weatherHandleSingleFingerEvent];
    [self performSelector:@selector(weatherHandleSingleFingerEvent) withObject:nil afterDelay:5];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //计算weatherC的位置
    NSString *tempStr = self.weather.text;
    CGSize size = [tempStr sizeWithFont:self.weather.font forWidth:200 lineBreakMode:NSLineBreakByWordWrapping];
    CGRect weatherFrame = self.weather.frame;
    weatherFrame.size.width = size.width;
    CGRect weatherCFrame = self.weatherC.frame;
    weatherCFrame.origin.x = weatherFrame.origin.x + weatherFrame.size.width + 1;
    self.weatherC.frame = weatherCFrame;
}

-(void)weatherHandleSingleFingerEvent
{
    //归档路径
    NSString *filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"weaher.txt"];
    //网络请求
    NetRequest * weactherRequest =[[NetRequest alloc] init];
    
    //参数
    ZBAppSetting *appsetting = [ZBAppSetting standardSetting];
    NSString *lng = appsetting.longitudeStr;
    NSString *lat = appsetting.latitudeStr;
    NSString *addr = appsetting.address;
    NSDictionary * parameters =@{@"app_kind": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"],
                                 @"gps_lng": lng,
                                 @"gps_lat": lat,
                                 @"addr": addr};
    
    //网络地址
    ////ApiUrl * urlStr =[[ApiUrl alloc] init];
    [weactherRequest urlStr:[ApiUrl weaherUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        //NSLog(@"%@",customDict);
        if ([[customDict objectForKey:@"ret"] intValue]==1) {
            //归档
            ArchiverAndUnarchiver * weaherArchiver =[[ArchiverAndUnarchiver alloc] init];
            [weaherArchiver archiverPath:filePath andData:customDict andForKey:@"weaher"];
            //调用天气方法
            [self weatherShowSetup];
        }
    }];
    //调用天气方法
    [self weatherShowSetup];
    [self layoutSubviews];
    
}

//天气显示设置
-(void)weatherShowSetup
{
    //归档路径
    NSString *filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"weaher.txt"];
    
    //反归档
    NSData * data =[[NSData alloc]initWithContentsOfFile:filePath];
    //反归档人
    NSKeyedUnarchiver * unarchiver =[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary * aDcit =[unarchiver decodeObjectForKey:@"weaher"];
    NSLog(@"%@",[[aDcit objectForKey:@"weatherinfo"] objectForKey:@"weather"]);
    
    //当前位置天气设置
    //self.place.text = [[aDcit objectForKey:@"weatherinfo"] objectForKey:@"city"] ? [[aDcit objectForKey:@"weatherinfo"] objectForKey:@"city"]: @"苏州";
    
    //天气温度文字处理
    NSString * temp1Str = [[aDcit objectForKey:@"weatherinfo"] objectForKey:@"temp1"];
    NSString * temp2Str = [[aDcit objectForKey:@"weatherinfo"] objectForKey:@"temp2"];
    
    //天气温度合拼
    NSString * tempStr=[[NSString alloc] initWithFormat:@"%d",([temp1Str integerValue]+ [temp2Str integerValue])/2];
    
    //当前天气温度文字设置
    self.weather.text = tempStr;
    
    //图片数组
    NSArray *  weatherTextArr =@[@"晴",@"多云",@"阴",@"阵雨",
                                 @"雷阵雨",@"雷阵雨并伴有冰雹",@"雨加雪",@"小雨",
                                 @"中雨",@"大雨",@"暴雨",@"大暴雨",
                                 @"特大暴雨",@"阵雪",@"小雪",@"中雪",
                                 @"大雪",@"暴雪",@"雾",@"冻雨",
                                 @"沙尘暴",@"小雨-中雨",@"中雨-大雨",@"大雨-暴雨",
                                 @"暴雨-大暴雨",@"大暴雨-特大暴雨",@"小雪-中雪",@"中雪-大雪",
                                 @"大雪-暴雪",@"浮尘",@"扬沙",@"强沙尘暴"
                                 ,@"多云转阴",@"阴转多云",@"晴转小雨",@"多云转晴",@"多云转阵雨",@"晴转多云",@"阴转小雨"];
    NSArray * weatherImageArr =@[@"weather01",@"weather02",@"weather03",@"weather04",
                                 @"weather05",@"weather06",@"weather07",@"weather08",
                                 @"weather09",@"weather10",@"weather11",@"weather12",
                                 @"weather13",@"weather14",@"weather15",@"weather16",
                                 @"weather17",@"weather18",@"weather19",@"weather20",
                                 @"weather21",@"weather22",@"weather23",@"weather24",
                                 @"weather25",@"weather26",@"weather27",@"weather28",
                                 @"weather29",@"weather30",@"weather31",@"weather32",
                                 @"weather02",@"weather02",@"weather08",@"weather02",@"weather04",@"weather01",@"weather03"];
    NSDictionary *  weatherDict =[[NSDictionary alloc] initWithObjects:weatherImageArr forKeys:weatherTextArr];
    
    //图片设置

    NSString *weatherImageStr = [weatherDict objectForKey:[[aDcit objectForKey:@"weatherinfo"] objectForKey:@"weather"]];
    self.weatherImageView.image =[UIImage imageNamed: weatherImageStr?weatherImageStr: @"weather02"];
    if (tempStr) {
        self.weatherC.text = @"℃";
    }
    
    //计算weatherC的位置
    CGSize size = [tempStr sizeWithFont:self.weather.font forWidth:200 lineBreakMode:NSLineBreakByWordWrapping];
    CGRect weatherFrame = self.weather.frame;
    weatherFrame.size.width = size.width;
    CGRect weatherCFrame = self.weatherC.frame;
    weatherCFrame.origin.x = weatherFrame.origin.x + weatherFrame.size.width + 1;
    self.weatherC.frame = weatherCFrame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
