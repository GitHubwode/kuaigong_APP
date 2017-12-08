//
//  KGGSexField.h
//  kuaigong
//
//  Created by Ding on 2017/9/1.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGGSexFieldDelegate <NSObject>

@optional
- (void)ensureButtonClick;

@end

@interface KGGSexField : UITextField

@property (nonatomic, weak) id<KGGSexFieldDelegate >sexDelegate;

@end
