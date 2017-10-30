//
//  SNHPublishToolBar.h
//  sunvhui
//
//  Created by apple on 2016/11/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, SNHPublishToolBarSelectedType) {
    SNHPublishToolBarSelectedVideoType = 101,
    SNHPublishToolBarSelectedPictureType,
    SNHPublishToolBarSelectedEmojiType,
    SNHPublishToolBarSelectedLocationType,
    SNHPublishToolBarSelectedActivityType,
};


@interface SNHPublishToolBar : UIView

@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIButton *emojiButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *activityButton;



+ (instancetype)publishToolBar;

@end
