//
//  MyProfileTableViewController.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/6.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyProfileTableViewController.h"
#import "MyProfileTableViewCell.h"
#import "UpdatePwdTableViewController.h"
#import "UpdateNameTableViewController.h"
#import "UpdatePhoneTableViewController.h"


#import "MyCardViewController.h"



@interface MyProfileTableViewController (){
    NSDictionary * userDic;
}

@end

@implementation MyProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[MyProfileTableViewCell class] forCellReuseIdentifier:@"MyProfileTableViewCell"];
    
    


}




-(void)viewWillAppear:(BOOL)animated{
    SQLDataBase * sql =[[SQLDataBase alloc] init];
    userDic =[sql query];
}

-(void)refreshTable{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger row = 2;
    if (section == 2) {
        row = 1;
    }
    return row;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MyProfileTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MyProfileTableViewCell"];
    
    if (indexPath.section==0 && indexPath.row==0) {
        cell.cellType=MyProfileTabelViewCellImage;
        cell.myLabel.text=GDLocalizedString(@"头像");
    
        long imageID = [[userDic objectForKey:@"img_id"] integerValue];
        
        NSURL *url = [NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:120]];
        
        [cell.myHeaderImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"nm.png"]];
        
        self.headerImage=cell.myHeaderImage;

    }else{
        cell.cellType=MyProfileTabelViewCellText;
        
        if (indexPath.section==0 && indexPath.row==1) {
            cell.myLabel.text=GDLocalizedString(@"用户名");
            cell.myValLabel.text=[userDic objectForKey:@"user_name"];
        }else if (indexPath.section==1 && indexPath.row==0){
            cell.myLabel.text=GDLocalizedString(@"手机号码");
            cell.myValLabel.text=[userDic objectForKey:@"phone"];
        }else if (indexPath.section==1 && indexPath.row==1){
            cell.myLabel.text=GDLocalizedString(@"密码");
            cell.myValLabel.text=@"***********";
        }else if (indexPath.section==2 && indexPath.row==0){
            cell.myLabel.text=GDLocalizedString(@"我的名片");
            cell.myValLabel.text=@"";
        }
    }
    [cell initMyProfileCell];
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0  && indexPath.row==0){
        return 83;
    }
    return 44;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 7;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==1 && indexPath.row==1) {
        UpdatePwdTableViewController *uptv=[[UpdatePwdTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        uptv.title =GDLocalizedString(@"修改密码");
        uptv.hidesBottomBarWhenPushed=YES;
        
        UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:GDLocalizedString(@"保存") style:UIBarButtonItemStyleBordered target:uptv action:@selector(clickSave)];
        
        uptv.navigationItem.rightBarButtonItem=save;
        
        uptv.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:uptv action:@selector(back:)];
        
        
        [self.navigationController pushViewController:uptv animated:YES];
    }else if (indexPath.section==0 && indexPath.row==1){
        UpdateNameTableViewController *untvc=[[UpdateNameTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        untvc.title =GDLocalizedString(@"修改用户名");
        untvc.hidesBottomBarWhenPushed=YES;
        
        untvc.userName=[userDic objectForKey:@"user_name"];
        
        untvc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:untvc action:@selector(back:)];

        
        UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:GDLocalizedString(@"保存") style:UIBarButtonItemStyleBordered target:untvc action:@selector(clickSave)];
        untvc.navigationItem.rightBarButtonItem=save;
        untvc.mtableView=self.tableView;
        
        [self.navigationController pushViewController:untvc animated:YES];
    }else if (indexPath.section==1 && indexPath.row==0){
        

        UpdatePhoneTableViewController *uptvc=[[UpdatePhoneTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        
        uptvc.title =GDLocalizedString(@"修改手机号码");
        uptvc.hidesBottomBarWhenPushed=YES;
        
        UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:GDLocalizedString(@"保存") style:UIBarButtonItemStyleBordered target:uptvc action:@selector(clickSave)];
        
        uptvc.navigationItem.rightBarButtonItem=save;
        
        uptvc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:uptvc action:@selector(back:)];
        
        
        uptvc.mtableView=self.tableView;
        
        [self.navigationController pushViewController:uptvc animated:YES];
        
        
    }else if (indexPath.section==0 && indexPath.row==0){
        [self uploadTxClicked];
    }else if (indexPath.section==2 && indexPath.row==0){
                UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MyCardViewController *vc = [board instantiateViewControllerWithIdentifier:@"MyCardViewController"];
                vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:vc action:@selector(back:)];
                vc.title = GDLocalizedString(@"我的名片");
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    
}




- (void)uploadTxClicked
{
        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:GDLocalizedString(@"上传新的个人头像") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") destructiveButtonTitle:nil otherButtonTitles:GDLocalizedString(@"相册上传"),GDLocalizedString(@"拍照上传"), nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self pickPhotoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }else if(buttonIndex==1){
        
        [self pickPhotoWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }
}


- (void)pickPhotoWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //判断设备的相机模式是否可用
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
}


//得到图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (image) {
        [self uploadImg:image];
    } else {
        NSLog(@"编辑的图片为空!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  上传头像到服务器
 */
- (void)uploadImg:(UIImage*)img
{
    [UploadImage uploadWithImage:img completed:^(NSString *imageStr, NSError *error) {
        if (imageStr) {
            NSString *imgId = [imageStr substringWithRange:NSMakeRange(5, imageStr.length-6)];
            [self setTouxiangByImgId:imgId];
        }else {
            [HuaxoUtil showMsg:nil title:GDLocalizedString(@"图片上传失败")];
        }
    }];
}


-(void)setTouxiangByImgId:(NSString *)imageId
{
    NetRequest * request =[NetRequest new];
    SQLDataBase * sql = [SQLDataBase new];
    
    NSDictionary * parameters = @{
                                  @"uid":[HuaxoUtil getUdidStr],
                                  @"img_id":imageId
                                  };
    [request urlStr:[ApiUrl setMyTouxiangUrl] parameters:parameters passBlock:^(NSDictionary *customDict)
     {
         BOOL ret = [customDict[@"ret"] intValue];;
         if(ret)
         {
             [HuaxoUtil showMsg:customDict[@"msg"] title:@""];
             [sql updateValue:imageId key:@"img_id"];
             
             SQLDataBase * sql =[[SQLDataBase alloc] init];
             NSDictionary * aDic =[sql query];

             long imageID = [aDic[@"img_id"] integerValue];
             
//             //头像
//             [self.head sd_setBackgroundImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:160]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm.png"]];
             
             
             [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:160]] placeholderImage:[UIImage imageNamed:@"nm.png"]];
            
             
             
            // [[NSNotificationCenter defaultCenter] postNotificationName:@"用户更改头像" object:nil userInfo:aDic];
         }else{
             NSString* msg= customDict[@"msg"];
             [HuaxoUtil showMsg:msg title:@""];
         }
     }];
}


@end
