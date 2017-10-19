//
//  KGGPersonNameEditController.h
//  kuaigong
//
//  Created by Ding on 2017/10/19.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGPublishPersonModel;

@interface KGGPersonNameEditController : UIViewController
@property (nonatomic, copy) void(^completionHandler)();
- (instancetype)initWithInfoItem:(KGGPublishPersonModel *)item currentUser:(KGGUserObj *)user;

@end
