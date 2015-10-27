//
//  PostVisitorsCell.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-21.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PostVisitorsCell.h"
#import "ApiUrl.h"
@interface PostVisitorsCell ()
@property (nonatomic, strong) NSMutableArray *images;
@end


@implementation PostVisitorsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.backgroundColor = UIColorFromRGB(0xfbfbfb);
    self.clipsToBounds = YES;
    
    self.zanIco = [[UIImageView alloc] initWithFrame:CGRectMake(7, 9, 34, 34)];
    self.zanIco.image = [UIImage imageNamed:@"赞_查看话题.png"];
    self.zanIco.layer.cornerRadius = self.zanIco.frame.size.width/2.0;
    self.zanIco.layer.masksToBounds = YES;
    [self addSubview:self.zanIco];

    self.zanLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.zanLabel.textColor = UIColorFromRGB(0xa6a9af);
    self.zanLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.zanLabel];
    
    //底端线
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    self.bottomLine = bottomLine;
    [self addSubview:self.bottomLine];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    for (UIButton *btn in self.images) {
        [btn removeFromSuperview];
    }
    
    self.images = [[NSMutableArray alloc] init];
    int j = 0;
    for (int i=0; i<[self.dataList count] && i<4; i++) {
        NSDictionary *json = self.dataList[i];
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(49+ i*40, 9, 34, 34);
        long imageID = [(NSString *)json[@"img_id"] integerValue];  //fred img_id->String
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:btn.frame.size.width*2]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm.png"]];
        
        btn.layer.cornerRadius = btn.frame.size.width/2.0;
        btn.layer.masksToBounds = YES;
        
        btn.userInteractionEnabled = NO;
        [btn addTarget:self action:@selector(clickedBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.images addObject:btn];
        j=i;
        
    }
    

    self.zanLabel.frame = CGRectMake(49+40*(j+1), 20, 110, 12);
    self.zanLabel.text = [NSString stringWithFormat:@"%@%ld%@", GDLocalizedString(@"共"),(long)self.praiseNum,GDLocalizedString(@"人赞过该帖")];
    
    //底端线
    self.bottomLine.frame = CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5);
}

- (NSArray *)getListByDataStr:(NSString *)str {
    NSMutableArray *mArr = nil;
    if (str) {
        mArr = [[NSMutableArray alloc] init];
        NSArray *arr = [str componentsSeparatedByString:@";"];
        for (int i=0; i<[arr count]; i++) {
            NSString *subStr = arr[i];
            if (subStr && ![subStr isEqualToString:@"null"]) {
                NSArray *subArr = [subStr componentsSeparatedByString:@":"];
                if (subArr.count == 3) {
                    NSDictionary *dic = @{@"uid":subArr[0],@"name":subArr[1],@"tx_id":subArr[2]};
                    [mArr addObject:dic];
                }
            }
        }
    }
    return mArr;
}

- (void)clickedBtn {
}

@end
