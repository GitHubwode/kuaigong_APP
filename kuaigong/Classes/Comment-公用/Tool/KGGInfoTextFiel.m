//
//  KGGInfoTextFiel.m
//  kuaigong
//
//  Created by Ding on 2017/9/11.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGInfoTextFiel.h"
#import "UITextField+KGGExtension.h"

@implementation KGGInfoTextFiel

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}


- (void)config{
    self.borderStyle = UITextBorderStyleNone;
    self.placeholderColor = KGGTimeTextColor;
    self.textColor = KGGContentTextColor;
    self.font = KGGLightFont(15);
    self.userInteractionEnabled = NO;
    self.tintColor = KGGGoldenThemeColor;
    self.returnKeyType = UIReturnKeyDone;
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}





@end
