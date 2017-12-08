//
//  KGGBirthdayField.h
//  kuaigong
//
//  Created by Ding on 2017/12/7.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGGBirthdayFieldDelegate <NSObject>

@optional
- (void)ensureButtonClick;
@end

@interface KGGBirthdayField : UITextField
@property (nonatomic, weak)id<KGGBirthdayFieldDelegate>birthdayDelegate;

@end
