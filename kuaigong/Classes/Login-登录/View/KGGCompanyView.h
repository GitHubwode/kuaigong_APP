//
//  KGGCompanyView.h
//  kuaigong
//
//  Created by Ding on 2017/11/12.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGCompanyChooseField;

@protocol KGGCompanyViewDelegate <NSObject>

- (void)textFieldCompanyName:(NSString *)name;

@end

@interface KGGCompanyView : UIView

- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title imageString:(NSString *)imageString PlaceText:(NSString *)placeText;

@property (nonatomic, weak) id<KGGCompanyViewDelegate> companyDelegate;
@property (nonatomic, strong) KGGCompanyChooseField *textField;


@end
