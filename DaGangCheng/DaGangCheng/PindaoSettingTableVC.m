//
//  PindaoSettingTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-7.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PindaoSettingTableVC.h"
#import "PindaoSetting.h"

@interface PindaoSettingTableVC ()
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) int settingValue;
@property (nonatomic, copy) NSString *settingTitle;
@end

@implementation PindaoSettingTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataList = [[NSMutableArray alloc] init];
    
    PindaoSetting *setting1 = [[PindaoSetting alloc] init];
    setting1.title = GDLocalizedString(@"匿名");
    NSString *setting1Title = [NSString stringWithFormat:@"%@%@%@", GDLocalizedString(@"在此"),[ZBAppSetting standardSetting].pindaoName,GDLocalizedString(@"发表的话题自动匿名")];
    setting1.desc = setting1Title;
    setting1.value = 0;
    
    PindaoSetting *setting2 = [[PindaoSetting alloc] init];
    setting2.title = GDLocalizedString(@"图片");
    NSString *setting2Title = [NSString stringWithFormat:@"%@%@%@",GDLocalizedString(@"在此"),[ZBAppSetting standardSetting].pindaoName, GDLocalizedString(@"发表的话题需要包含图片")];
    setting2.desc = setting2Title;
    setting2.value = 0;
    
    PindaoSetting *setting3 = [[PindaoSetting alloc] init];
    setting3.title = GDLocalizedString(@"语音");
    NSString *setting3Title = [NSString stringWithFormat:@"%@%@%@",GDLocalizedString(@"在此"),[ZBAppSetting standardSetting].pindaoName,GDLocalizedString(@"发表的话题需要包含语音")];
    setting3.desc = setting3Title;
    setting3.value = 0;
    
    PindaoSetting *setting4 = [[PindaoSetting alloc] init];
    setting4.title = GDLocalizedString(@"管理员");
    NSString *setting4Title = [NSString stringWithFormat:@"%@%@%@",GDLocalizedString(@"在此"),[ZBAppSetting standardSetting].pindaoName, GDLocalizedString(@"发表的话题需要管理员权限")];
    setting4.desc = setting4Title;
    setting4.value = 0;
    
    [self.dataList addObject:setting1];
    [self.dataList addObject:setting2];
    [self.dataList addObject:setting3];
    [self.dataList addObject:setting4];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(clickedOK)];
}

- (void)clickedOK {
    int totalVale = 0;
    NSString *totalTitle = @"  ";
    for (int i=0; i<[self.dataList count]; i++) {
        PindaoSetting *setting = self.dataList[i];
        totalVale += setting.value;
        if (setting.value) {
            totalTitle = [totalTitle stringByAppendingString:setting.title];
            totalTitle = [totalTitle stringByAppendingString:@","];
        }
    }
    self.settingValue = totalVale;
    self.settingTitle = [totalTitle substringToIndex:(totalTitle.length - 1)];
    
    if ([self.delegate respondsToSelector:@selector(pindaoSettingTableVC:title:value:)]) {
        [self.delegate pindaoSettingTableVC:self title:self.settingTitle value:self.settingValue];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    // Configure the cell...
    PindaoSetting *setting = self.dataList[indexPath.row];
    cell.textLabel.text = setting.title;
    cell.detailTextLabel.text = setting.desc;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    PindaoSetting *setting = self.dataList[indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        setting.value = 0;
    }else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        setting.value = pow(2, indexPath.row);
    }

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
