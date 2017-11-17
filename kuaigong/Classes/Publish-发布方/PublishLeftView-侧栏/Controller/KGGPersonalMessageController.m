//
//  KGGPersonalMessageController.m
//  kuaigong
//
//  Created by Ding on 2017/8/30.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGPersonalMessageController.h"
#import "KGGPersonMessageCell.h"
#import "KGGPublishPersonModel.h"
#import "KGGSexChangeViewCell.h"
#import "TZImageManager.h"
#import "KGGLoginRequestManager.h"
#import "KGGPersonNameEditController.h"


@interface KGGPersonalMessageController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,KGGSexChangeViewCellDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, strong) UITableView *perTableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSMutableArray *newDatasource;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation KGGPersonalMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGViewBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"个人信息";
    [self userMessage];
    [self.view addSubview:self.perTableView];
}

- (void)userMessage
{
    KGGPublishPersonModel *model1 = self.datasource[0];
    model1.subTitle = [KGGUserManager shareUserManager].currentUser.avatarUrl;
    [self.newDatasource addObject:model1];
    KGGPublishPersonModel *model2 = self.datasource[1];
    model2.subTitle = [KGGUserManager shareUserManager].currentUser.nickname;
    [self.newDatasource addObject:model2];
    KGGPublishPersonModel *model3 = self.datasource[2];
    model3.subTitle = [KGGUserManager shareUserManager].currentUser.sexName;
    [self.newDatasource addObject:model3];
    KGGPublishPersonModel *model4 = self.datasource[3];
    model4.subTitle = [KGGUserManager shareUserManager].currentUser.hidePhone;
    [self.newDatasource addObject:model4];
}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 90.f;
    }else{
        return 48.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGPublishPersonModel *model = self.newDatasource[indexPath.row];
    if (indexPath.row == 2) {
        KGGSexChangeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGSexChangeViewCell cellIdentifier]];
        cell.sexDelegate = self;
        cell.personModel = model;
        return cell;
    }else{
        KGGPersonMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGGPersonMessageCell personIdentifier] forIndexPath:indexPath];
        cell.personModel = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGLog(@"%ld",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KGGPublishPersonModel *model = self.newDatasource[indexPath.row];
    
    if (indexPath.row == 0) {
        [self updateUserAvatar];
    }
    if (indexPath.row == 2) {
        id cell = [tableView cellForRowAtIndexPath:indexPath];
        [[cell personTextField] becomeFirstResponder];
    }
    if (indexPath.row == 1) {
        KGGLog(@"跳转页面更改昵称");
        
        KGGPersonNameEditController *deitVC = [[KGGPersonNameEditController alloc]initWithInfoItem:model currentUser:nil];
        deitVC.completionHandler = ^(){
            [self userMessage];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (self.editInfoSuccessBlock) {
                self.editInfoSuccessBlock();
            }
        };
        [self presentViewController:[[KGGNavigationController alloc]initWithRootViewController:deitVC] animated:YES completion:nil];

    }
}

#pragma mark - cellSexDelegate
- (void)KGGSexChangeButtonClickSex:(NSString *)sex
{
    [KGGLoginRequestManager updataUserNameNickString:nil Sex:sex completion:^(KGGResponseObj *responseObj) {
        if (responseObj.code == KGGSuccessCode) {
            [MBProgressHUD showSuYaSuccess:@"修改成功" toView:nil];
        }
    } aboveView:self.view inCaller:self];
}

- (void)updateUserAvatar
{
    KGGLog(@"更新头像");
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从手机相册选择", nil];
    [sheet showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    KGGLog(@"result = %d", (int)buttonIndex);
    if (1 == buttonIndex) {
        [self selectPhoto:YES];//相册
    }else if (0 == buttonIndex){
        [self takePhoto:YES];//相机
    }
}

- (void)selectPhoto:(BOOL)allowsEditing{
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (PHAuthorizationStatusAuthorized == status) {
                // 已获得权限
                self.imagePickerVc.allowsEditing = allowsEditing;
                self.imagePickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:_imagePickerVc animated:YES completion:nil];
                
            }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                alert.tag = 1;
                [alert show];
#define push @#clang diagnostic pop
            }
        });
    }];
    
    
}

- (void)takePhoto:(BOOL)allowsEditing{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)) {
        // 无相机权限 做一个友好的提示
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
#define push @#clang diagnostic pop
        // 拍照之前还需要检查相册权限
    } else if ([[TZImageManager manager] authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([[TZImageManager manager] authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [self takePhoto:allowsEditing];
        });
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.allowsEditing = allowsEditing;
            self.imagePickerVc.sourceType = sourceType;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:_imagePickerVc animated:YES completion:nil];
            });
        } else {
            KGGLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

#pragma mark - UIAlertViewDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
//    base64EncodedStringWithOptions

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSData *data =UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 0.5f);
    NSString *encodedImageString = [data base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
    
    [KGGLoginRequestManager updataUserAvatarString:encodedImageString completion:^(KGGResponseObj *responseObj) {
        if (!responseObj) return ;
        if (responseObj.code == KGGSuccessCode) {
            KGGLog(@"%@",responseObj);
            [self userMessage];
            [self.perTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (self.editInfoSuccessBlock) {
                self.editInfoSuccessBlock();
            }
        }
    } aboveView:self.view inCaller:self];
    
}


#pragma mark - 选择图片
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerVc.delegate = self;
        UIBarButtonItem *BarItem;
        if (([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)) {
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
        }
        UIImage *backImage = [UIImage imageNamed:@"nav_icon_back_photo_white"];
        [BarItem setBackButtonBackgroundImage:[backImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backImage.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    return _imagePickerVc;
}



- (UITableView *)perTableView
{
    if (!_perTableView) {
        _perTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -37, kMainScreenWidth, kMainScreenHeight) style:UITableViewStyleGrouped];
        [_perTableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGPersonMessageCell class]) bundle:nil] forCellReuseIdentifier:[KGGPersonMessageCell personIdentifier]];
        [_perTableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGGSexChangeViewCell class]) bundle:nil] forCellReuseIdentifier:[KGGSexChangeViewCell cellIdentifier]];
        _perTableView.separatorStyle = UITableViewCellStyleDefault;
        _perTableView.delegate = self;
        _perTableView.dataSource = self;
    }
    return _perTableView;
}


- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [KGGPublishPersonModel mj_objectArrayWithFilename:@"KGGPublishPrivate.plist"];
    }
    return _datasource;
}

- (NSMutableArray *)newDatasource
{
    if (!_newDatasource) {
        _newDatasource = [NSMutableArray array];
    }
    return _newDatasource;
}

- (void)dealloc
{
    KGGLogFunc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
