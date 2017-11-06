//
//  KGGWorkTypeModel.h
//  kuaigong
//
//  Created by Ding on 2017/10/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGWorkTypeModel : NSObject

/**  */
@property (nonatomic,copy) NSString *ext;
/** 价钱 */
@property (nonatomic,copy) NSString *guidePrice;
/**  */
@property (nonatomic,copy) NSString *isDisplay;
/** 工种名称 */
@property (nonatomic,copy) NSString *name;
/** 排序 */
@property (nonatomic,assign) NSUInteger  sort;
/** 类型 */
@property (nonatomic,copy) NSString *type;

//增加参数
/** 工作时间 */
@property (nonatomic,copy) NSString *whenLong;


@end
