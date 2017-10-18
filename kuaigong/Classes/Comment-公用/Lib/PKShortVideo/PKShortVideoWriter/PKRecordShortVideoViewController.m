//
//  PKShortVideoViewController.m
//  DevelopWriterDemo
//
//  Created by jiangxincai on 16/1/14.
//  Copyright © 2016年 pepsikirk. All rights reserved.
//

#import "PKRecordShortVideoViewController.h"
#import "PKShortVideoRecorder.h"
#import "PKShortVideoProgressBar.h"
#import <AVFoundation/AVFoundation.h>
#import "PKFullScreenPlayerViewController.h"
#import "UIImage+PKShortVideoPlayer.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHAssetChangeRequest.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

static NSString *SNHSmallVideoFolderName = @"com.sunvhui.videos";

#define SNHSmallVideoFolderPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:SNHSmallVideoFolderName]


//static CGFloat PKOtherButtonVarticalHeight = 0;
static CGFloat PKRecordButtonVarticalHeight = 0;
static CGFloat PKPreviewLayerHeight = 0;

static CGFloat const PKRecordButtonWidth = 80;

@interface PKRecordShortVideoViewController() <PKShortVideoRecorderDelegate>

@property (nonatomic, strong) NSString *outputFilePath;
@property (nonatomic, assign) CGSize outputSize;

@property (strong, nonatomic) NSTimer *stopRecordTimer;
@property (nonatomic, assign) CFAbsoluteTime beginRecordTime;

@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *deleteButton;

/** 聚焦光标 */
@property (strong, nonatomic) UIImageView *focusCursor;

@property (nonatomic, strong) PKShortVideoProgressBar *progressBar;
@property (nonatomic, strong) PKShortVideoRecorder *recorder;

@end

@implementation PKRecordShortVideoViewController

#pragma mark - Init 



- (void)dealloc {
    KGGLogFunc
    [_recorder stopRunning];
    [self removeVideoFolder];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self removeVideoFolder];
        [self createVideoFolderIfNotExist];
        
        NSString *fileName = [NSProcessInfo processInfo].globallyUniqueString;
        NSString *path = [SNHSmallVideoFolderPath stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"mp4"]];
        
        _outputFilePath = path;
        _outputSize = CGSizeMake(720, 720);
        _videoMaximumDuration = 60.f;
        _videoMinimumDuration = 10.f;
        
    }
    return self;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self addNotificationToApplication];
    
    self.navigationItem.title = @"拍摄小视频";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"取消" target:self action:@selector(cancelShoot)];
    
    
    PKPreviewLayerHeight = kScreenWidth;
    CGFloat spaceHeight = ceilf( (kScreenHeight - 64 - PKPreviewLayerHeight)/3 );
    PKRecordButtonVarticalHeight = ceilf( kScreenHeight - 2 * spaceHeight );
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIView *viewContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , kScreenWidth, PKPreviewLayerHeight - 5)];
    viewContainer.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewContainer:)];
    [viewContainer addGestureRecognizer:tapGesture];
    [self.view addSubview:viewContainer];
    
    
    //创建视频录制对象
    self.recorder = [[PKShortVideoRecorder alloc] initWithOutputFilePath:self.outputFilePath outputSize:self.outputSize];
    //通过代理回调
    self.recorder.delegate = self;
    //录制时需要获取预览显示的layer，根据情况设置layer属性，显示在自定义的界面上
    AVCaptureVideoPreviewLayer *previewLayer = [self.recorder previewLayer];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = viewContainer.bounds;
    [viewContainer.layer insertSublayer:previewLayer atIndex:0];
    
    self.progressBar = [[PKShortVideoProgressBar alloc] initWithFrame:CGRectMake(0,PKPreviewLayerHeight - 5, kScreenWidth, 5) themeColor:KGGGoldenThemeColor duration:self.videoMaximumDuration miniDuration:_videoMinimumDuration];
    [self.view addSubview:self.progressBar];
    
    self.focusCursor = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_focus"]];
    self.focusCursor.alpha = 0.f;
    [viewContainer addSubview:self.focusCursor];
    
    
    
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.adjustsImageWhenHighlighted = NO;
    [self.recordButton setImage:[UIImage imageNamed:@"shooting_default"] forState:UIControlStateNormal];
    [self.recordButton setImage:[UIImage imageNamed:@"shooting_ing"] forState:UIControlStateHighlighted];
    [self.recordButton setImage:[UIImage imageNamed:@"shooting_over"] forState:UIControlStateDisabled];
//    [self.recordButton setTitle:@"按住录" forState:UIControlStateNormal];

    self.recordButton.frame = CGRectMake(0, 0, PKRecordButtonWidth, PKRecordButtonWidth);
    self.recordButton.center = CGPointMake(kScreenWidth/2, PKRecordButtonVarticalHeight);
//    [self recordButtonAction];
    [self.recordButton addTarget:self action:@selector(toggleRecording) forControlEvents:UIControlEventTouchDown];
    [self.recordButton addTarget:self action:@selector(buttonStopRecording) forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    [self.view addSubview:self.recordButton];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //开始预览摄像头工作
        [self.recorder startRunning];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addNotificationToApplication{
    
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

/**
 *  程序进入前台
 *
 *  @param notification 通知对象
 */
- (void)applicationDidBecomeActive:(NSNotification *)notification{
    
    KGGLog(@"%s",__func__);
    
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if ((AVAuthorizationStatusDenied == audioAuthStatus && AVAuthorizationStatusNotDetermined != videoAuthStatus) || (AVAuthorizationStatusDenied == videoAuthStatus && AVAuthorizationStatusNotDetermined != audioAuthStatus)) {
        
        [self cancelShoot];
    }
}

/**
 *  程序进入后台
 *
 *  @param notification 通知对象
 */
- (void)applicationWillResignActive:(NSNotification *)notification{
    KGGLog(@"%s",__func__);
    [self buttonStopRecording];
}



#pragma mark - Private 
- (void)tapViewContainer:(UITapGestureRecognizer *)tapGesture{
    CGPoint point= [tapGesture locationInView:tapGesture.view];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint= [[self.recorder previewLayer] captureDevicePointOfInterestForPoint:point];
    
    [self setFocusCursorWithPoint:point];
    
    [self.recorder focusWithPoint:cameraPoint];
}


/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    
    if (!CGAffineTransformIsIdentity(self.focusCursor.transform)) return;
    
    self.focusCursor.center = point;
    self.focusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha = 1.0;
    [UIView animateWithDuration:0.8 animations:^{
        self.focusCursor.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.focusCursor.alpha=0;
        }];
    }];
}




/**
 删除保存视频的文件夹
 */
- (void)removeVideoFolder{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = SNHSmallVideoFolderPath;
    
    if ([fileManager fileExistsAtPath:path]) {
        
        NSError *error = nil;
        [fileManager removeItemAtPath:path error:&error];
        
        if (error) {
            KGGLog(@"deleteAllVideo删除视频文件出错:%@", error);
        }
    }
}

/**
 创建保存视频的文件夹
 
 @return <#return value description#>
 */
- (BOOL)createVideoFolderIfNotExist{
    
    NSString *folderPath = SNHSmallVideoFolderPath;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir)){
        
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            return NO;
        }
        return YES;
    }
    return YES;
}





- (void)cancelShoot {
    [self.recorder stopRunning];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate didCancelRecording];
    }];
}

- (void)swapCamera {
    //切换前后摄像头
    [self.recorder swapFrontAndBackCameras];
}


- (void)refreshView {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认删除该段视频?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSFileManager defaultManager] removeItemAtPath:self.outputFilePath error:nil];
        //    [self.recordButton setTitle:@"按住录" forState:UIControlStateNormal];
        self.recordButton.enabled = YES;
        //    [self recordButtonAction ];
        [self.deleteButton removeFromSuperview];
        self.deleteButton = nil;
        [self.sendButton removeFromSuperview];
        self.sendButton = nil;
        
        [self.progressBar restore];
    }]];
    [self presentViewController:alert animated:YES completion:nil];

}

//- (void)playVideo {
//    UIImage *image = [UIImage pk_previewImageWithVideoURL:[NSURL fileURLWithPath:self.outputFilePath]];
//    PKFullScreenPlayerViewController *vc = [[PKFullScreenPlayerViewController alloc] initWithVideoPath:self.outputFilePath previewImage:image];
//    [self presentViewController:vc animated:NO completion:NULL];
//}

- (void)toggleRecording {
    
    //静止自动锁屏
//    [UIApplication sharedApplication].idleTimerDisabled = YES;
    //记录开始录制时间
    self.beginRecordTime = CACurrentMediaTime();
    //开始录制视频
    [self.recorder startRecording];
    //进度条开始动
    [self.progressBar play];
}

- (void)buttonStopRecording {
    //停止录制
    [self.recorder stopRecording];
}

- (void)sendVideo {
    
    [self.view showHUD];

    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
    weakSelf(self);
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:self.outputFilePath] completionBlock:^(NSURL *assetURL, NSError *error) {
        __strong typeof(weakself) strongSelf = weakself;
        KGGLog(@"assetURL = %@ - %@",assetURL,error);
        if (strongSelf) {
            [strongSelf.view hideHUD];
            [strongSelf dismissViewControllerAnimated:YES completion:^{
                [strongSelf.delegate didFinishRecording];
            }];
        }
    }];
    
    
    
    
    
}

- (void)endRecordingWithPath:(NSString *)path failture:(BOOL)failture {
    [self.progressBar restore];
    
    self.recordButton.enabled = YES;
//    [self.recordButton setTitle:@"按住拍摄" forState:UIControlStateNormal];
    
    if (failture) {
        [self.view showHint:@"生成视频失败"];
    } else {
        [self.view showHint:[NSString stringWithFormat:@"请长按超过%@秒钟",@(self.videoMinimumDuration)]];
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//    [self recordButtonAction];
}



- (void)invalidateTime {
    if ([self.stopRecordTimer isValid]) {
        [self.stopRecordTimer invalidate];
        self.stopRecordTimer = nil;
    }
}


#pragma mark - PKShortVideoRecorderDelegate

///录制开始回调
- (void)recorderDidBeginRecording:(PKShortVideoRecorder *)recorder {
    //录制长度限制到时间停止
    self.stopRecordTimer = [NSTimer scheduledTimerWithTimeInterval:self.videoMaximumDuration target:self selector:@selector(buttonStopRecording) userInfo:nil repeats:NO];
    
//    [self.recordButton setTitle:@"" forState:UIControlStateNormal];
}

//录制结束回调
- (void)recorderDidEndRecording:(PKShortVideoRecorder *)recorder {
    //停止进度条
    [self.progressBar stop];
}

//视频录制结束回调
- (void)recorder:(PKShortVideoRecorder *)recorder didFinishRecordingToOutputFilePath:(NSString *)outputFilePath error:(NSError *)error {
    //解除自动锁屏限制
//    [UIApplication sharedApplication].idleTimerDisabled = NO;
    //取消计时器
    [self invalidateTime];

    if (error) {
        KGGLog(@"视频拍摄失败: %@", error.localizedDescription);
        [self endRecordingWithPath:outputFilePath failture:YES];
    } else {
        //当前时间
        CFAbsoluteTime nowTime = CACurrentMediaTime();
        if (self.beginRecordTime != 0 && nowTime - self.beginRecordTime < self.videoMinimumDuration) {
            
            [self endRecordingWithPath:outputFilePath failture:NO];
        } else {
            self.outputFilePath = outputFilePath;
//            [self.recordButton setTitle:@"完成" forState:UIControlStateNormal];
            self.recordButton.enabled = NO;
            
            self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.deleteButton setImage:[UIImage imageNamed:@"shooting_icon_delete"] forState:UIControlStateNormal];
            [self.deleteButton sizeToFit];
            self.deleteButton.xc_x = self.recordButton.xc_x - 40.f - self.deleteButton.xc_width;
            self.deleteButton.xc_centerY = PKRecordButtonVarticalHeight;
            [self.view addSubview:self.deleteButton];
            
            
            self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.sendButton.xc_x = CGRectGetMaxX(self.recordButton.frame) + 40.f;
            [self.sendButton setImage:[UIImage imageNamed:@"shooting_icon_send"] forState:UIControlStateNormal];
            [self.sendButton sizeToFit];
            self.sendButton.xc_centerY = self.deleteButton.xc_centerY;
            [self.view addSubview:self.sendButton];
            
            [self.sendButton addTarget:self action:@selector(sendVideo) forControlEvents:UIControlEventTouchUpInside];
            [self.deleteButton addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventTouchUpInside];
            
        }

    }
}






@end
