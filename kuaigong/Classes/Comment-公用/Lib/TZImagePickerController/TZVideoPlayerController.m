//
//  TZVideoPlayerController.m
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/5.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZVideoPlayerController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+Layout.h"
#import "TZImageManager.h"
#import "TZAssetModel.h"
#import "TZImagePickerController.h"
#import "TZPhotoPreviewController.h"

@interface TZVideoPlayerController () {
    AVPlayer *_player;
    UIButton *_playButton;
    UIImage *_cover;
    
    UIView *_toolBar;
    UIButton *_okButton;
    UIProgressView *_progress;
#pragma XC-添加
    UIButton *_selectButton;
    UIView *_naviBar;
    UIButton *_backButton;

    
}
@end

@implementation TZVideoPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = [NSBundle tz_localizedStringForKey:@"Preview"];
    
    [self configNavBar];
    
    [self configMoviePlayer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    _selectButton.selected = _model.isSelected;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}



- (void)configNavBar{
    
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    
    if (!tzImagePickerVc) return;
    
    _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.tz_width, 64)];
    _naviBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    _naviBar.alpha = 0.7;
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _backButton.tz_centerY = _naviBar.xc_height * 0.5f;
    [_backButton setImage:[UIImage imageNamed:@"nav_icon_back_white"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    // 24*24 44-24=20
    _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.tz_width - 44 - 5, 0, 44, 44)];
    _selectButton.tz_centerY = _backButton.tz_centerY;
    [_selectButton setImage:[UIImage imageNamedFromMyBundle:tzImagePickerVc.photoDefImageName] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamedFromMyBundle:tzImagePickerVc.photoSelImageName] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [_naviBar addSubview:_selectButton];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
    

}

- (void)back{
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)configMoviePlayer {
    [[TZImageManager manager] getPhotoWithAsset:_model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        _cover = photo;
    }];
    [[TZImageManager manager] getVideoWithAsset:_model.asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _player = [AVPlayer playerWithPlayerItem:playerItem];
            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
            playerLayer.frame = self.view.bounds;
            [self.view.layer addSublayer:playerLayer];
            [self addProgressObserver];
            [self configPlayButton];
            [self configBottomToolBar];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
        });
    }];
}

/// Show progress，do it next time / 给播放器添加进度更新,下次加上
- (void)addProgressObserver{
    AVPlayerItem *playerItem = _player.currentItem;
    UIProgressView *progress = _progress;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([playerItem duration]);
        if (current) {
            [progress setProgress:(current/total) animated:YES];
        }
    }];
}

- (void)configPlayButton {
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *playImage = [UIImage imageNamed:@"icon_play_big"];
    _playButton.frame = CGRectMake(0, 64, self.view.tz_width, self.view.tz_height - 64 - 44);
    [_playButton setImage:playImage forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
}

- (void)configBottomToolBar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.tz_height - 44, self.view.tz_width, 44)];
    CGFloat rgb = 34 / 255.0;
    _toolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _toolBar.alpha = 0.7;
    
    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _okButton.frame = CGRectMake(self.view.tz_width - 44 - 12, 0, 44, 44);
    _okButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_okButton addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_okButton setTitle:[NSBundle tz_localizedStringForKey:@"Done"] forState:UIControlStateNormal];
    [_okButton setTitleColor:KGGGoldenThemeColor forState:UIControlStateNormal];
    
    [_toolBar addSubview:_okButton];
    [self.view addSubview:_toolBar];
}

#pragma mark - Click Event

- (void)playButtonClick {
    CMTime currentTime = _player.currentItem.currentTime;
    CMTime durationTime = _player.currentItem.duration;
    if (_player.rate == 0.0f) {
        if (currentTime.value == durationTime.value) [_player.currentItem seekToTime:CMTimeMake(0, 1)];
        [_player play];
        _toolBar.hidden = YES;
        _naviBar.hidden = YES;
        [_playButton setImage:nil forState:UIControlStateNormal];
    } else {
        [self pausePlayerAndShowNaviBar];
    }
}

- (void)okButtonClick {
    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
    if ([imagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingVideo:sourceAssets:)]) {
        [imagePickerVc.pickerDelegate imagePickerController:imagePickerVc didFinishPickingVideo:_cover sourceAssets:_model.asset];
    }
    if (imagePickerVc.didFinishPickingVideoHandle) {
        imagePickerVc.didFinishPickingVideoHandle(_cover,_model.asset);
    }
    if (self.navigationController) {
        if (imagePickerVc.autoDismiss) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Notification Method
- (void)pausePlayerAndShowNaviBar {
    [_player pause];
    _toolBar.hidden = NO;
    _naviBar.hidden = NO;
    [_playButton setImage:[UIImage imageNamed:@"icon_play_big"] forState:UIControlStateNormal];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Click Event

- (void)select:(UIButton *)selectButton {
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;

    if (!selectButton.isSelected) {
        // 1. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
        if (_tzImagePickerVc.selectedModels.count >= _tzImagePickerVc.maxImagesCount) {
            NSString *title = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Select a maximum of %zd videos"], _tzImagePickerVc.maxImagesCount];
            [_tzImagePickerVc showAlertWithTitle:title];
            return;
            // 2. if not over the maxImagesCount / 如果没有超过最大个数限制
        } else {
            [_tzImagePickerVc.selectedModels addObject:_model];
        }
    } else {
        NSArray *selectedModels = [NSArray arrayWithArray:_tzImagePickerVc.selectedModels];
        for (TZAssetModel *model_item in selectedModels) {
            if ([[[TZImageManager manager] getAssetIdentifier:_model.asset] isEqualToString:[[TZImageManager manager] getAssetIdentifier:model_item.asset]]) {
                // 1.6.7版本更新:防止有多个一样的model,一次性被移除了
                NSArray *selectedModelsTmp = [NSArray arrayWithArray:_tzImagePickerVc.selectedModels];
                for (NSInteger i = 0; i < selectedModelsTmp.count; i++) {
                    TZAssetModel *model = selectedModelsTmp[i];
                    if ([model isEqual:model_item]) {
                        [_tzImagePickerVc.selectedModels removeObjectAtIndex:i];
                        break;
                    }
                }
                // [_tzImagePickerVc.selectedModels removeObject:model_item];
                break;
            }
        }
    }
    _model.isSelected = !selectButton.isSelected;

    _selectButton.selected = _model.isSelected;
    
    if (_model.isSelected) {
        [UIView showOscillatoryAnimationWithLayer:selectButton.imageView.layer type:TZOscillatoryAnimationToBigger];
    }
}





@end
