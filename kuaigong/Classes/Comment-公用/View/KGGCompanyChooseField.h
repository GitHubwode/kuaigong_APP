//
//  KGGCompanyChooseField.h
//  kuaigong
//
//  Created by Ding on 2017/11/12.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGGCompanyChooseFieldDelegate <NSObject>

@optional

- (void)companyChooseFieldFieldEnsureButtonClickText:(NSString *)text;

@end

@interface KGGCompanyChooseField : UITextField

@property (nonatomic, weak)id<KGGCompanyChooseFieldDelegate>companyDelegate;

@end
