//
//  KGGRongCloudModel.h
//  kuaigong
//
//  Created by Ding on 2017/9/12.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *KGGConnectRongCloudSuccess = @"KGGConnectRongCloudSuccess";

@interface KGGRongCloudModel : NSObject

+ (void)kgg_initRongCloudAppkey;
+ (void)kgg_initRongCloudLogin;

@end
