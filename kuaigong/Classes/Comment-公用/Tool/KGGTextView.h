//
//  KGGTextView.h
//  kuaigong
//
//  Created by Ding on 2017/8/23.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGGTextView : UITextView

@property (nonatomic, copy) NSString *kgg_placeholder;
@property (nonatomic, strong) UIColor *kgg_placeholderColor;
@property (nonatomic, strong) UIFont *kgg_placeholderFont;

@end
