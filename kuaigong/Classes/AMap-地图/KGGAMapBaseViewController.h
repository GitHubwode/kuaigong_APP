//
//  KGGAMapBaseViewController.h
//  kuaigong
//
//  Created by Ding on 2017/9/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^backAddressDetailsBlock)(NSString *addressDetails, CGFloat longitude,CGFloat latitude);

@interface KGGAMapBaseViewController : UIViewController

@property (nonatomic,copy) backAddressDetailsBlock backBlock;
@end
