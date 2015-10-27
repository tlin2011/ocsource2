//
//  ZBSelectLanguageTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 15-7-20.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBSelectLanguageTableVC.h"
#import "UITableView+separator.h"
#import "AppDelegate.h"
#import "GDLocalizable.h"

@interface ZBLanguageItem : NSObject
@property (copy, nonatomic) NSString *language;
@property (assign, nonatomic) BOOL isSelected;
@end

@implementation ZBLanguageItem
@end

@interface ZBSelectLanguageTableVC ()
@property (strong, nonatomic) NSMutableArray *dataList;
@end

@implementation ZBSelectLanguageTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:GDLocalizedString(@"保存") style:UIBarButtonItemStyleDone target:self action:@selector(saveLanguage)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSArray *languages = [ZBAppSetting standardSetting].languages;
    self.dataList = [[NSMutableArray alloc] init];
    for (NSString *str in languages) {
        NSString *language = [self smallLanguageByNanoLanguage:str];
        if (languages) {
            ZBLanguageItem *item = [[ZBLanguageItem alloc] init];
            item.language = language;
            
            NSString *currentLanguage = [GDLocalizable userLanguage];
            if ([currentLanguage isEqualToString:language]) {
                item.isSelected = YES;
            } else {
                item.isSelected = NO;
            }
            
            [self.dataList addObject:item];
        }
    }
    

    
    [self.tableView bottomSeparatorHidden];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = @"ZBSelectLanguageTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    ZBLanguageItem *item = self.dataList[indexPath.row];
    cell.textLabel.text = [self languageBySmallLanguage:item.language];
    
    if (item.isSelected == YES) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSString *)languageBySmallLanguage:(NSString *)small {
    NSString *str = nil;
    if ([small isEqualToString:CHINESE]) {
        str = @"简体中文";
    } else if ([small isEqualToString:ENGLISH]) {
        str = @"English";
    } else if ([small isEqualToString:TIBETAN]) {
        str = @"བོད་ཡིག";
    }
    return str;
}

- (NSString *)smallLanguageByNanoLanguage:(NSString *)nano {
    
    NSString *str = nil;
    if ([nano isEqualToString:@"zh"]) {
        str = CHINESE;
    } else if ([nano isEqualToString:@"en"]) {
        str = ENGLISH;
    } else if ([nano isEqualToString:@"bo"]) {
        str = TIBETAN;
    }
    return str;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (ZBLanguageItem *item in self.dataList) {
        item.isSelected = NO;
    }
    
    ZBLanguageItem *item = self.dataList[indexPath.row];
    item.isSelected = YES;
    
    [self.tableView reloadData];
}

- (void)saveLanguage {
    ZBLanguageItem *selectedItem =nil;
    for (ZBLanguageItem *item in self.dataList) {
        if (item.isSelected) {
            selectedItem = item;
            break;
        }
    }

    [GDLocalizable setUserlanguage:selectedItem.language];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app toRootViewControllerWithIsGotoAd:NO];
}

- (void)back:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
