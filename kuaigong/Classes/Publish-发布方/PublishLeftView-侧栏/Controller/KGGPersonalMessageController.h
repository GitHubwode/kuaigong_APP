//
//  KGGPersonalMessageController.h
//  kuaigong
//
//  Created by Ding on 2017/8/30.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^editInfoSuccessBlock)(void);

@interface KGGPersonalMessageController : UIViewController

@property (nonatomic, copy) editInfoSuccessBlock editInfoSuccessBlock;

@end
