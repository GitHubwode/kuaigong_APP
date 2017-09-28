//
//  KGGPayChooseModel.h
//  kuaigong
//
//  Created by Ding on 2017/9/14.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGPayChooseModel : NSObject

/** 未选择图标 */
@property (nonatomic,copy) NSString *iconImage;
/** 已选择图标 */
@property (nonatomic,copy) NSString *iconPressImage;
/** 标题 */
@property (nonatomic,copy) NSString *title;
@property (nonatomic, copy)NSString *chooseImage;
@property (nonatomic, copy)NSString *choosePressImage;

@end
