//
//  KGGEditPublishViewController.m
//  kuaigong
//
//  Created by Ding on 2017/10/29.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGEditPublishViewController.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIView+Layout.h"
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"
#import "LCActionSheet.h"
#import "KGGPictureMetadata.h"
#import "KGGShowFeedApiItem.h"
#import "SNHPublishToolBar.h"
#import "KGGPublishOrderRequestManager.h"
#import "KGGOrderImageModel.h"
#import "KGGAliyunRequestManager.h"

typedef NS_ENUM(NSUInteger, SNHSelectedPublishType) {
    SNHSelectedPublishTypeDefault,
    SNHSelectedPublishTypeVideo,
    SNHSelectedPublishTypePhoto
};

/** 图片允许选择的最多个数 */
static NSUInteger SNHMaxImagesCount = 8;
/** 列数 */
static NSUInteger SNHColumnNumber = 3;
/** 列间距 */
static CGFloat SNHColumnMargin = 3.f;
/** 行间距 */
static CGFloat SNHRowMargin = 3.f;
/** collection的缩进 */
static UIEdgeInsets SNHCollectionInset = {0, 15.f, 0, 15.f};

//static CGFloat SNHPublishUserViewHeight = 65.f;

static NSString *TZTestCellIdfy = @"TZTestCell";


@interface KGGEditPublishViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *userView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, assign) CGFloat itemWH;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

/** 记录正选择的类型 */
@property (nonatomic, assign) SNHSelectedPublishType selectedPublishType;
/** 记录上一次选择的类型 */
@property (nonatomic, assign) SNHSelectedPublishType lastSelectedPublishType;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightCons;
/** scrollView的ContentSize的宽度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentWidthCons;
/** scrollView的ContentSize的高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTopCons;

@end

@implementation KGGEditPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KGGTitleTextColor;
    [self setUpTextView];
    // 设置导航栏上单元素
    [self setUpNavi];
    // 初始化CollectionView的一些配置
    [self configCollectionView];
    // 更新高度
    [self updateContentHeight];
}

- (void)dealloc
{
    KGGLogFunc
}

#pragma mark - setUp
/**
 初始化导航栏上的元素
 */
- (void)setUpNavi{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"取消" target:self action:@selector(cancelPublish)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButtonTitle:@"发布" target:self action:@selector(publish:)];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.navigationItem.title = @"工地图片";
}

- (void)setUpTextView{
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 10, kMainScreenWidth, kMainScreenHeight)];
    _textView.xc_height -= 64.f;
    _textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_textView];
}

/**
 初始化CollectionView的一些参数
 */
- (void)configCollectionView {
    
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc]init];
    
    layout.sectionInset = SNHCollectionInset;
    _itemWH = (kMainScreenWidth - SNHCollectionInset.left - SNHCollectionInset.right - (SNHColumnNumber - 1) * SNHColumnMargin) / SNHColumnNumber;
    layout.minimumInteritemSpacing = SNHRowMargin;
    layout.minimumLineSpacing = SNHColumnMargin;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, _itemWH + KGGOnePixelHeight) collectionViewLayout:layout];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:TZTestCellIdfy];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.scrollsToTop = NO;
    _collectionView.scrollEnabled = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_textView addSubview:_collectionView];
}


#pragma mark - 懒加载
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (NSMutableArray *)selectedPhotos{
    if (!_selectedPhotos) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}

- (NSMutableArray *)selectedAssets{
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

#pragma mark - NavigationAction
/**
 取消
 */
- (void)cancelPublish{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 发表
 
 @param item <#item description#>
 */
- (void)publish:(UIBarButtonItem *)item{
    
    item.enabled = NO;
    
    [self.view endEditing:YES];
    
    if (!self.selectedAssets.count) {
        [MBProgressHUD showMessag:@"请至少选择一张图片或一个文字"];
        item.enabled = YES;
        return;
    }
    
//    if (SNHSelectedPublishTypeVideo == _selectedPublishType) {
//
//        [self.view showHUD];
//
//        // 上传视频
//        [[TZImageManager manager] getVideoOutputPathWithAsset:self.selectedAssets.firstObject completion:^(NSString *outputPath) {
//
//            [self.view hideHUD];
//            if (!outputPath.length) {
//                [self.view showHint:@"导出视频出错!"];
//                item.enabled = YES;
//                return;
//            }
//
//
//            SNHShowFeedApiItem *param = [[SNHShowFeedApiItem alloc] init];
//            param.uid = [SNHUserManager sharedUserManager].currentUser.userId;
//            param.body = [self.textView getContentText];
//            param.footer = self.userView.locationView.currentLocation;
//            param.city_name = self.userView.locationView.city;
//            param.videoCoverImage = self.selectedPhotos.firstObject;
//            param.videoFilePath = outputPath;
//            param.activity_id = self.activityId;
//            if (self.stageId) {
//                param.stage_id = self.stageId;
//            }
//
//            [SNHShowRequestManager publishVideoFeedWithParam:param completion:^(SNHShowFeedModel *response) {
//
//                item.enabled = YES;
//
//                if (!response) return;
//
//                if (!_stageId.length) {
//                    [MBProgressHUD showSuYaSuccess:@"发表成功" toView:nil];
//                }
//
//                [self dismissViewControllerAnimated:YES completion:^{
//                    if ([self.delegate respondsToSelector:@selector(publisSuccess:)]) {
//                        [self.delegate publisSuccess:response];
//                    }
//                }];
//
//
//            } aboveView:self.view inCaller:self];
//
//
//        }];
//
////    }else if (SNHSelectedPublishTypePhoto == _selectedPublishType){
//
//        [self.view showHUD];
//
//        NSMutableArray<SNHPictureMetadata *> *imageDatas = [NSMutableArray array];
//        for (NSUInteger i = 0; i < self.selectedAssets.count; i++) {
//            SNHPictureMetadata *pictureMeta = [[SNHPictureMetadata alloc] init];
//            [imageDatas addObject:pictureMeta];
//        }
//
//        NSUInteger index = 0;
//        for (id asset in self.selectedAssets) {
//
//            SNHPictureMetadata *pictureMeta = imageDatas[index];
//
//            if ([asset isKindOfClass:[PHAsset class]]) {
//                PHAsset *alAsset = (PHAsset *)asset;
//                pictureMeta.width = alAsset.pixelWidth;
//                pictureMeta.height = alAsset.pixelHeight;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//            }else if ([asset isKindOfClass:[ALAsset class]]) {
//                ALAsset *alAsset = (ALAsset *)asset;
//                ALAssetRepresentation *assetRep = [alAsset defaultRepresentation];
//#pragma clang diagnostic pop
//                CGSize dimension = [assetRep dimensions];
//                KGGLog(@"dimension = %@",NSStringFromCGSize(dimension));
//                pictureMeta.width = dimension.width;
//                pictureMeta.height = dimension.height;
//            }
//
//            [[TZImageManager manager] getOriginalPhotoDataWithAsset:asset completion:^(NSData *data, NSDictionary *info) {
//                KGGLog(@"index = %zd",index);
//                [imageDatas removeObject:pictureMeta];
//                pictureMeta.data = data;
//                [imageDatas insertObject:pictureMeta atIndex:index];
//
//                if (asset == self.selectedAssets.lastObject) {
//
//                    SNHShowFeedApiItem *param = [[SNHShowFeedApiItem alloc] init];
//                    param.uid = [SNHUserManager sharedUserManager].currentUser.userId;
//                    param.body = [self.textView getContentText];
//                    param.footer = self.userView.locationView.currentLocation;
//                    param.city_name = self.userView.locationView.city;
//                    param.imageDatas = imageDatas;
//                    param.activity_id = self.activityId;
//                    if (self.stageId) {
//                        param.stage_id = self.stageId;
//                    }
//                    [self.view hideHUD];
//
//                    [SNHShowRequestManager publishImagesFeedWithParam:param completion:^(SNHShowFeedModel *response) {
//
//                        item.enabled = YES;
//
//                        if (!response) return;
//
//
//                        if (!_stageId.length) {
//                            [MBProgressHUD showSuYaSuccess:@"发表成功" toView:nil];
//                        }
//
//
//
//                        [self dismissViewControllerAnimated:YES completion:^{
//                            if ([self.delegate respondsToSelector:@selector(publisSuccess:)]) {
//                                [self.delegate publisSuccess:response];
//                            }
//                        }];
//
//                    } aboveView:self.view inCaller:self];
//
//                }
//            }];
//            index++;
//        }
//
//    }else{
//        SNHShowFeedApiItem *param = [[SNHShowFeedApiItem alloc] init];
//        param.uid = @"878";
//        param.body = [self.textView getContentText];
//        param.footer = self.userView.locationView.currentLocation;
//        param.city_name = self.userView.locationView.city;
//        param.activity_id = self.activityId;
//        if (self.stageId) {
//            param.stage_id = self.stageId;
//        }
//        [SNHShowRequestManager publishTextFeedWithParam:param completion:^(SNHShowFeedModel *response) {
//
//            item.enabled = YES;
//
//            if (!response) return;
//
//            if (!_stageId.length) {
//                [MBProgressHUD showSuYaSuccess:@"发表成功" toView:nil];
//            }
//
//            [self dismissViewControllerAnimated:YES completion:^{
//                if ([self.delegate respondsToSelector:@selector(publisSuccess:)]) {
//                    [self.delegate publisSuccess:response];
//                }
//            }];
//
//        } aboveView:self.view inCaller:self];
//    }
    
    
    if (SNHSelectedPublishTypePhoto == _selectedPublishType){
        
        [self.view showHUD];
        
        NSMutableArray<KGGPictureMetadata *> *imageDatas = [NSMutableArray array];
        for (NSUInteger i = 0; i < self.selectedAssets.count; i++) {
            KGGPictureMetadata *pictureMeta = [[KGGPictureMetadata alloc] init];
            [imageDatas addObject:pictureMeta];
        }
        
        NSUInteger index = 0;
        for (id asset in self.selectedAssets) {
            
            KGGPictureMetadata *pictureMeta = imageDatas[index];
            
            if ([asset isKindOfClass:[PHAsset class]]) {
                PHAsset *alAsset = (PHAsset *)asset;
                pictureMeta.width = alAsset.pixelWidth;
                pictureMeta.height = alAsset.pixelHeight;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            }else if ([asset isKindOfClass:[ALAsset class]]) {
                ALAsset *alAsset = (ALAsset *)asset;
                ALAssetRepresentation *assetRep = [alAsset defaultRepresentation];
#pragma clang diagnostic pop
                CGSize dimension = [assetRep dimensions];
                KGGLog(@"dimension = %@",NSStringFromCGSize(dimension));
                pictureMeta.width = dimension.width;
                pictureMeta.height = dimension.height;
            }
            
            [[TZImageManager manager] getOriginalPhotoDataWithAsset:asset completion:^(NSData *data, NSDictionary *info) {
                KGGLog(@"index = %zd",index);
                [imageDatas removeObject:pictureMeta];
                pictureMeta.data = data;
                [imageDatas insertObject:pictureMeta atIndex:index];
                
                if (asset == self.selectedAssets.lastObject) {
                    
                    KGGShowFeedApiItem *param = [[KGGShowFeedApiItem alloc] init];
                    param.imageDatas = imageDatas;
                    [self.view hideHUD];
                    
                    NSString *timeStamp = [NSString publishSetUpNowTime];
                    NSString *sign = [NSString stringWithFormat:@"order/%@%@",timeStamp,KGGAesKey];
                    NSString *sig = [sign md5String];

                    
                    [KGGPublishOrderRequestManager publishOrderUpdataImagePath:@"order/" TimeStamp:timeStamp Signature:sig completion:^(KGGOrderImageModel *imageModel) {
                        
                    } aboveView:self.view inCaller:self];
                    
                    
                    
                    
                    
                    
                    
                    
//                    [SNHShowRequestManager publishImagesFeedWithParam:param completion:^(SNHShowFeedModel *response) {
//
//                        item.enabled = YES;
//
//                        if (!response) return;
//
//
//                        if (!_stageId.length) {
//                            [MBProgressHUD showSuYaSuccess:@"发表成功" toView:nil];
//                        }
//
//
//
//                        [self dismissViewControllerAnimated:YES completion:^{
//                            if ([self.delegate respondsToSelector:@selector(publisSuccess:)]) {
//                                [self.delegate publisSuccess:response];
//                            }
//                        }];
//
//                    } aboveView:self.view inCaller:self];
                    
                }
            }];
            index++;
        }
        
    }
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    KGGLog(@"_selectedPhotos = %zd",_selectedPhotos.count);
    // 已经选择了一个视频
    if (_selectedPublishType == SNHSelectedPublishTypeVideo && _selectedPhotos.count) {
        return _selectedPhotos.count;
    }
    // 选择的图片达到最多
    if (_selectedPhotos.count >= SNHMaxImagesCount - 1) {
        return SNHMaxImagesCount;
    }
    // 选择的图片、视频 没有达到最多，多显示一个加号
    return self.selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TZTestCellIdfy forIndexPath:indexPath];
    
    cell.videoImageView.hidden = YES;
    
    if (indexPath.row == self.selectedPhotos.count) {
        // 显示添加按钮
        cell.imageView.image = [UIImage imageNamed:@"addphoto_pressed"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = self.selectedPhotos[indexPath.row];
        cell.asset = self.selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.selectedPhotos.count) {
        // 点击加号按钮
        [self showActionSheetWithPublishType:_selectedPublishType];
        
    } else { // preview photos or video / 预览照片或者视频
        id asset = self.selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
#pragma clang diagnostic pop
        }
        if (isVideo) { // perview video / 预览视频
//            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
//            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
//            vc.model = model;
//            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:self.selectedAssets selectedPhotos:self.selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = SNHMaxImagesCount;
            imagePickerVc.allowPickingOriginalPhoto = YES;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
                self.selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                
                [self updateContentHeight];
                
                [_collectionView reloadData];
                
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (SNHSelectedPublishTypeVideo == _selectedPublishType) {
        return CGSizeMake(_itemWH * (16 / 9.f), _itemWH);
    }else{
        return CGSizeMake(_itemWH, _itemWH);
    }
}

#pragma mark - LxGridViewDataSource
/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < self.selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < self.selectedPhotos.count && destinationIndexPath.item < self.selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = self.selectedPhotos[sourceIndexPath.item];
    [self.selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [self.selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = self.selectedAssets[sourceIndexPath.item];
    [self.selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [self.selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

#pragma mark - private
/**
 展示一个图片或者视频选择器
 
 @param allowPickingImage 图片
 @param allowPickingVideo 视频
 */
- (void)pushImagePickerControllerWithAllowPickingImage:(BOOL)allowPickingImage  allowPickingVideo:(BOOL)allowPickingVideo{
    
    NSUInteger count = allowPickingVideo ? 1 : SNHMaxImagesCount;
    // 初始化
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count columnNumber:SNHColumnNumber delegate:self pushPhotoPickerVc:YES];
    
    // 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = self.selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = allowPickingImage; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
         [imagePickerVc.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_icon"] forBarMetrics:UIBarMetricsDefault];
        imagePickerVc.barItemTextFont = KGGLightFont(15);
        imagePickerVc.barItemTextColor = KGGTitleTextColor;
     imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
         imagePickerVc.oKButtonTitleColorNormal = KGGContentTextColor;
    
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = allowPickingVideo;
    imagePickerVc.allowPickingImage = allowPickingImage;
    imagePickerVc.allowPickingOriginalPhoto = allowPickingImage;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
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
            return [self takePhoto];
        });
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
/**
 取消拍照
 
 @param picker <#picker description#>
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.selectedPublishType = _lastSelectedPublishType;
}


/**
 拍照完成
 
 @param picker <#picker description#>
 @param info <#info description#>
 */
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:SNHMaxImagesCount delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = NO;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                KGGLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [self.selectedAssets addObject:assetModel.asset];
                        [self.selectedPhotos addObject:image];
                        
                        
                        [self updateContentHeight];
                        
                        [_collectionView reloadData];
                    }];
                }];
            }
        }];
    }
}


#pragma mark - UIAlertViewDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            NSURL *privacyUrl;
            if (alertView.tag == 1) {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
            } else {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
            }
            if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                [[UIApplication sharedApplication] openURL:privacyUrl];
            } else {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }else{
        self.selectedPublishType = _lastSelectedPublishType;
    }
}

#pragma mark - TZImagePickerControllerDelegate
/**
 取消选择图片、视频
 
 @param picker <#picker description#>
 */
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    self.selectedPublishType = _lastSelectedPublishType;
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _lastSelectedPublishType = _selectedPublishType;
    
    
    [self updateContentHeight];
    [_collectionView reloadData];
    // 1.打印图片名字
        [self printAssetsName:assets];
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    
    self.selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    self.selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    _lastSelectedPublishType = _selectedPublishType;
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    
    LxGridViewFlowLayout *layout = (LxGridViewFlowLayout *)_collectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self updateContentHeight];
    [_collectionView reloadData];
    
}

#pragma mark - Click Event
/**
 点击TZTestCell中的删除按钮
 
 @param sender <#sender description#>
 */
- (void)deleteBtnClik:(UIButton *)sender {
    
    KGGLog(@"deleteBtnClik = %zd",sender.tag);
    
    [self.selectedPhotos removeObjectAtIndex:sender.tag];
    [self.selectedAssets removeObjectAtIndex:sender.tag];
    
    
    [self updateContentHeight];
    
    if (self.selectedPhotos.count == SNHMaxImagesCount - 1) {
        [_collectionView reloadData];
    }else{
        
        if (SNHSelectedPublishTypeVideo == _selectedPublishType) {
            LxGridViewFlowLayout *layout = (LxGridViewFlowLayout *)_collectionView.collectionViewLayout;
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            [_collectionView reloadData];
        }else{
            [_collectionView performBatchUpdates:^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
                [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
            } completion:^(BOOL finished) {
                [_collectionView reloadData];
            }];
        }
    }
    
    if (!self.selectedPhotos.count){
        self.selectedPublishType = SNHSelectedPublishTypeDefault;
        _lastSelectedPublishType = SNHSelectedPublishTypeDefault;
    }
    
}


#pragma mark - Private
/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        KGGLog(@"图片名字:%@",fileName);
    }
}

/**
 更新高度
 */
- (void)updateContentHeight{
    
    // 实时更新完成按钮是否可以被点击
    self.navigationItem.rightBarButtonItem.enabled = (self.selectedPhotos.count);
    
    // 选择的图片数量
    NSUInteger count = self.selectedPhotos.count >= (SNHMaxImagesCount - 1) ? SNHMaxImagesCount : (self.selectedPhotos.count + 1);
    //  根据图片数量计算行数
    NSUInteger row = ((count - 1) / SNHColumnNumber) + 1;
    // 根据行数计算高度
    CGFloat h = SNHCollectionInset.top + SNHCollectionInset.bottom + row * _itemWH + (row - 1) * SNHRowMargin;
    // 更新collectionView的高度
    self.collectionView.xc_height = h + KGGOnePixelHeight;
    
    // 计算文本的高度
    NSUInteger H = 0;
    
    
    
    CGFloat contentH = H + h + 15.f + 0 + 15.f;
    
    
    if (contentH <= kMainScreenHeight - 64.f) {
        contentH = kMainScreenHeight + KGGOnePixelHeight - 64.f;
    }
    
//    self.textView.contentSize = CGSizeMake(0, contentH);
    
    [UIView animateWithDuration:0.1f animations:^{
        self.collectionView.xc_y = H;
    }];
    
}

- (BOOL)canSelectedType:(SNHSelectedPublishType)type{
    
    if (SNHSelectedPublishTypeDefault == type) return YES;
    
    if (SNHSelectedPublishTypeVideo == type && SNHSelectedPublishTypePhoto == _selectedPublishType) return NO;
    
    if (SNHSelectedPublishTypePhoto == type && SNHSelectedPublishTypeVideo == _selectedPublishType) return NO;
    
    return YES;
}

/**
 根据情况展示选项菜单
 
 @param type 正选择的类型
 */
- (void)showActionSheetWithPublishType:(SNHSelectedPublishType)type{
    
    [self.view endEditing:YES];
    
//    NSArray *otherTitles = @[@"小视频",@"本地视频上传",@"拍照",@"从手机相册选择"];
    NSArray *otherTitles = @[@"拍照",@"从手机相册选择"];

    
    switch (type) {
        case SNHSelectedPublishTypeVideo: otherTitles = @[@"小视频",@"本地视频上传"]; break;
        case SNHSelectedPublishTypePhoto: otherTitles = @[@"拍照",@"从手机相册选择"]; break;
        default:break;
    }
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        
        switch (type) {
                // 图片
            case SNHSelectedPublishTypePhoto:
                self.selectedPublishType = SNHSelectedPublishTypePhoto;
                switch (buttonIndex) {
                    case 1: [self takePhoto]; break;
                    case 2: [self pushImagePickerControllerWithAllowPickingImage:YES allowPickingVideo:NO]; break;
                    default: self.selectedPublishType = self.lastSelectedPublishType; break;
                }
                break;
                // 视频
            case SNHSelectedPublishTypeVideo:
                self.selectedPublishType = SNHSelectedPublishTypeVideo;
                switch (buttonIndex) {
                    case 1:[self takeSmallVideo]; break;
                    case 2:[self pushImagePickerControllerWithAllowPickingImage:NO allowPickingVideo:YES]; break;
                    default:self.selectedPublishType = self.lastSelectedPublishType; break;
                }
                break;
                // 默认
            default:
                switch (buttonIndex) {
                    case 3:
                        self.selectedPublishType = SNHSelectedPublishTypeVideo;
                        [self takeSmallVideo];
                        break;
                    case 4:
                        self.selectedPublishType = SNHSelectedPublishTypeVideo;
                        [self pushImagePickerControllerWithAllowPickingImage:NO allowPickingVideo:YES];
                        break;
                    case 1:
                        self.selectedPublishType = SNHSelectedPublishTypePhoto;
                        [self takePhoto];
                        break;
                    case 2:
                        self.selectedPublishType = SNHSelectedPublishTypePhoto;
                        [self pushImagePickerControllerWithAllowPickingImage:YES allowPickingVideo:NO];
                        break;
                    default:
                        self.selectedPublishType = self.lastSelectedPublishType;
                        break;
                }
                break;
        }
        
    } otherButtonTitleArray:otherTitles];
    [sheet show];
}



#pragma mark - SNHPublishTextViewDelegate
- (void)SNHPublishToolBarVideoButtonDidClicked{
    
    if (![self canSelectedType:SNHSelectedPublishTypeVideo]) {
        [MBProgressHUD showMessag:@"不能同时选择图片和视频"];
        return;
    }
    
    if (SNHSelectedPublishTypeVideo == _selectedPublishType && self.selectedAssets.count) {
        [MBProgressHUD showMessag:@"只能同时选择一个视频"];
        return;
    }
    
    
    
    [self showActionSheetWithPublishType:SNHSelectedPublishTypeVideo];
}

- (void)SNHPublishToolBarPictureButtonDidClicked{
    
    
    if (![self canSelectedType:SNHSelectedPublishTypePhoto]) {
        [MBProgressHUD showMessag:@"不能同时选择视频和图片"];
        return;
    }
    
    
    
    [self showActionSheetWithPublishType:SNHSelectedPublishTypePhoto];
}

- (void)SNHPublishToolBarEmojiButtonDidClicked:(UIButton *)emojiButton{
    KGGLogFunc
}

- (void)SNHPublishToolBarLocationButtonDidClicked{
    
//    SNHLocationViewController *location = [[SNHLocationViewController alloc]init];
//    location.selectedLocationCompletion = ^(NSString *city, NSString *address){
//        KGGLog(@"city = %@ - address = %@",city,address);
//        [self.userView.locationView setLocationWithCity:city address:address];
//    };
//    SNHNavigationController *nav = [[SNHNavigationController alloc]initWithRootViewController:location];
//    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)SNHPublishToolBarActivityButtonDidClicked{
    
    [self.view endEditing:YES];
    
//    SNHAssociateActivityViewController *associateActivity = [[SNHAssociateActivityViewController alloc]initWithSelectedActivityId:self.activityId];
//    associateActivity.delegate = self;
//    [associateActivity presentInViewController:self.navigationController];
}


#pragma mark - 小视频
- (void)takeSmallVideo{
    
    KGGLogFunc
    
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (videoAuthStatus == AVAuthorizationStatusRestricted || videoAuthStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
#define push @#clang diagnostic pop
        // 拍照之前还需要检查相册权限
    }else if (audioAuthStatus == AVAuthorizationStatusRestricted || audioAuthStatus == AVAuthorizationStatusDenied){
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法麦克风" message:@"请在iPhone的""设置-隐私-麦克风""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
#define push @#clang diagnostic pop
        
    }else if ([[TZImageManager manager] authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([[TZImageManager manager] authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [self takeSmallVideo];
        });
    }else{
        
//        PKRecordShortVideoViewController *video = [[PKRecordShortVideoViewController alloc] init];
//        video.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        video.delegate = self;
//        SNHNavigationController *nav = [[SNHNavigationController alloc] initWithRootViewController:video];
//        [self presentViewController:nav animated:YES completion:nil];
    }
    
}

#pragma mark - PKRecordShortVideoDelegate
- (void)didCancelRecording{
    self.selectedPublishType = _lastSelectedPublishType;
}
- (void)didFinishRecording{
    
    [[TZImageManager manager] getCameraRollAlbum:YES allowPickingImage:NO completion:^(TZAlbumModel *model) {
        [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:YES allowPickingImage:NO completion:^(NSArray<TZAssetModel *> *models) {
            
            TZAssetModel *assetModel = [models firstObject];
            
            [[TZImageManager manager] getPhotoWithAsset:assetModel.asset photoWidth:(_itemWH * (16 / 9.f)) completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                
                self.selectedPhotos = [NSMutableArray arrayWithArray:@[photo]];
                self.selectedAssets = [NSMutableArray arrayWithArray:@[assetModel.asset]];
                
                _lastSelectedPublishType = _selectedPublishType;
                
                LxGridViewFlowLayout *layout = (LxGridViewFlowLayout *)_collectionView.collectionViewLayout;
                layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                
                [self updateContentHeight];
                
                [_collectionView reloadData];
            }];
            
        }];
    }];
    
}


#pragma mark - setter
- (void)setSelectedPublishType:(SNHSelectedPublishType)selectedPublishType{
    _selectedPublishType = selectedPublishType;
//    SNHPublishToolBar *toolbar = (SNHPublishToolBar *)self.textView.inputAccessoryView;
//    if (SNHSelectedPublishTypeVideo == selectedPublishType) {
//        toolbar.videoButton.enabled = YES;
//        toolbar.pictureButton.enabled = NO;
//    }else if (SNHSelectedPublishTypePhoto == selectedPublishType){
//        toolbar.videoButton.enabled = NO;
//        toolbar.pictureButton.enabled = YES;
//    }else{
//        toolbar.videoButton.enabled = YES;
//        toolbar.pictureButton.enabled = YES;
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
