//
//  MyTableViewCell.m
//  DaGangCheng
//
//  Created by huaxo on 15-7-16.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    self.textLabel.font = [UIFont systemFontOfSize:17];
    self.textLabel.textColor = [UIColor darkGrayColor];
    
    //self.line = [[UIImageView alloc] initWithFrame:CGRectZero];
    //self.line.backgroundColor = UIColorFromRGB(0xdbdbdb);
    //[self addSubview:self.line];
}

- (void)updateUI {
    
    self.imageView.image = self.image;
    self.textLabel.text = self.title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    self.imageView.frame = CGRectMake(12, 11, 24, 24);
    self.textLabel.frame = CGRectMake(45, 14, 220, 18);
    self.line.frame = CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5);
}

+ (CGFloat)heightWithCell {
    return 44;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
