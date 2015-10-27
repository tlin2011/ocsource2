//
//  ZBWaterfallVC.h
//  DaGangCheng
//
//  Created by huaxo on 15-2-11.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "CHTCollectionViewWaterfallCell.h"

#import "NewPostViewController.h"
#import "Pindao.h"
#import "ZBWaterfallMangerView.h"
#import "QBImagePickerController.h"
#import "ZBWaterfallNewPostVC.h"

#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"

@interface ZBWaterfallVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout, CHTCollectionViewWaterfallCellDelegate, UIActionSheetDelegate, QBImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    //ApiUrl * url;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
}
@property (nonatomic, assign) BOOL isPullDownRefreshing;
//上下拉刷新调用
- (void)beginRefreshing:(MJRefreshBaseView *)refreshView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSString *pindaoId;

@end
