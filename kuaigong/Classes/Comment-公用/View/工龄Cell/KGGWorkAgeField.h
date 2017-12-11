//
//  KGGWorkAgeField.h
//  kuaigong
//
//  Created by Ding on 2017/12/8.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGGWorkAgeChooseFieldDelegate <NSObject>

@optional
- (void)workAgeChooseFieldEnsureButtonClickText:(NSString *)text;

@end


@interface KGGWorkAgeField : UITextField

@property (nonatomic, weak) id<KGGWorkAgeChooseFieldDelegate>workAgeDelegate;

@end
