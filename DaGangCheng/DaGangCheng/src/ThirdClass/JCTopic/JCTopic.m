//
//  JCTopic.m
//  PSCollectionViewDemo
//
//  Created by jc on 14-1-7.
//
//

#import "JCTopic.h"
@implementation JCTopic
@synthesize JCdelegate;

//在storyboard中的初始化
- (id)initWithCoder:(NSCoder *)aDecoder {
    self  = [super initWithCoder:aDecoder];
    if (self) {
        [self setSelf];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setSelf];
    }
    return self;
}
-(void)setSelf{
    self.pagingEnabled = YES;
    self.scrollEnabled = YES;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.canCancelContentTouches = YES;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self setSelf];
    
    // Drawing code
}
-(void)upDate{
    NSMutableArray * tempImageArray = [[NSMutableArray alloc]init];
    
    
    [tempImageArray addObject:[self.pics lastObject]];
    for (id obj in self.pics) {
        [tempImageArray addObject:obj];
    }
    [tempImageArray addObject:[self.pics objectAtIndex:0]];
    self.pics = Nil;
    self.pics = tempImageArray;
    
    int i = 0;
    for (id obj in self.pics) {
        pic= Nil;
        pic = [UIButton buttonWithType:UIButtonTypeCustom];
        pic.imageView.contentMode = UIViewContentModeTop;
        [pic setFrame:CGRectMake(i*self.frame.size.width,0, self.frame.size.width, self.frame.size.height)];
        UIImageView * tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, pic.frame.size.width, pic.frame.size.height)];
        tempImage.contentMode = UIViewContentModeScaleAspectFill;
        [tempImage setClipsToBounds:YES];
        if ([[obj objectForKey:@"isLoc"]boolValue]) {
            [tempImage setImage:[obj objectForKey:@"pic"]];
        }else{
            //使用UIImageView+WebCache.h
            [tempImage sd_setImageWithURL:[NSURL URLWithString:[obj objectForKey:@"pic"]] placeholderImage:[obj objectForKey:@"placeholderImage"]];
            
            //JCTopic默认的获取图片
//            if ([obj objectForKey:@"placeholderImage"]) {
//                [tempImage setImage:[obj objectForKey:@"placeholderImage"]];
//            }
//            [NSURLConnection sendAsynchronousRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[obj objectForKey:@"pic"]]]
//                                               queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//                                                   if (!error && responseCode == 200) {
//                                                       tempImage.image = Nil;
//                                                       UIImage *_img = [[UIImage alloc] initWithData:data];
//                                                       [tempImage setImage:_img];
//                                                   }else{
//                                                       if ([obj objectForKey:@"placeholderImage"]) {
//                                                           [tempImage setImage:[obj objectForKey:@"placeholderImage"]];
//                                                       }
//                                                   }
//                                               }];
        }
        [pic addSubview:tempImage];
        [pic setBackgroundColor:[UIColor grayColor]];
        pic.tag = i;
        [pic addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pic];
        
        UIImageView *titleBg = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.frame.size.width, self.frame.size.height-34, self.frame.size.width, 34)];
        [titleBg setBackgroundColor:[UIColor blackColor]];
        [titleBg setAlpha:.5f];
        [self addSubview:titleBg];
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(9+i*self.frame.size.width, self.frame.size.height-25, self.frame.size.width-([self.pics count])*13,17)];
        //[title setBackgroundColor:[UIColor redColor]];
        //        [title sette
        //[title setAlpha:.5f];
        [title setText:[NSString stringWithFormat:@"%@",[obj objectForKey:@"title"]]];
        [title setTextColor:[UIColor whiteColor]];
        //[title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [title setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:title];
        i ++;
    }
    [self setContentSize:CGSizeMake(self.frame.size.width*[self.pics count], self.frame.size.height)];
    [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
        
    }
    if ([self.pics count]>3) {
        scrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
    }
}
-(void)click:(id)sender{
    [JCdelegate didClick:[self.pics objectAtIndex:[sender tag]]];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat Width=self.frame.size.width;
    if (scrollView.contentOffset.x == self.frame.size.width) {
        flag = YES;
    }
    if (flag) {
        if (scrollView.contentOffset.x <= 0) {
            [self setContentOffset:CGPointMake(Width*([self.pics count]-2), 0) animated:NO];
        }else if (scrollView.contentOffset.x >= Width*([self.pics count]-1)) {
            [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        }
    }
    currentPage = scrollView.contentOffset.x/self.frame.size.width-1;
    [JCdelegate currentPage:currentPage total:[self.pics count]-2];
    scrollTopicFlag = currentPage+2==2?2:currentPage+2;
}
-(void)scrollTopic{
    [self setContentOffset:CGPointMake(self.frame.size.width*scrollTopicFlag, 0) animated:YES];
    
    if (scrollTopicFlag > [self.pics count]) {
        scrollTopicFlag = 1;
    }else {
        scrollTopicFlag++;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
    }
    
}
-(void)releaseTimer{
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
        
    }
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isMemberOfClass:[UIButton class]]) {
        return YES;
    }
    return NO;
}
@end