//
//  ZBPostListCell.m
//  DaGangCheng
//
//  Created by huaxo on 15-3-31.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBPostListCell.h"

@implementation ZBPostListCell

+ (CGFloat)getCellHeightByPost:(Post *)post {
    return 44;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    //init subviews
}

@end
