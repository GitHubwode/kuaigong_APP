//
//  KGGLeftTableController.h
//  kuaigong
//
//  Created by Ding on 2017/10/27.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeMenuViewDelegate <NSObject>

-(void)LeftMenuViewClick:(NSInteger)tag Drawer:(NSString *)model;

@end

@interface KGGLeftTableController : UIView

@property (nonatomic ,weak)id <HomeMenuViewDelegate> customDelegate;
- (void)changeUserAvatarIamge;

@end
