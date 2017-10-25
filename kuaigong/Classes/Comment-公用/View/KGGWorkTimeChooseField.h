//
//  KGGWorkTimeChooseField.h
//  kuaigong
//
//  Created by Ding on 2017/10/24.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGGWorkTimeChooseFieldDelegate <NSObject>

- (void)workTimeChooseFieldEnsureButtonClick;

@end

@interface KGGWorkTimeChooseField : UITextField

@property (nonatomic,weak) id<KGGWorkTimeChooseFieldDelegate>workDelegate;

@end
