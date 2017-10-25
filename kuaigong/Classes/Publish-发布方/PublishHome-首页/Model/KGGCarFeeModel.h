//
//  KGGCarFeeModel.h
//  kuaigong
//
//  Created by Ding on 2017/10/25.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGCarFeeModel : NSObject

/**  */
@property (nonatomic,copy) NSString *childs;
/**  */
@property (nonatomic,copy) NSString *isChild;
/**  */
@property (nonatomic,copy) NSString *itemKey;
/** 车费 */
@property (nonatomic,copy) NSString *itemName;
/** 车价 */
@property (nonatomic,assign) int itemValue;
/**  */
@property (nonatomic,assign) NSUInteger  level;
/**  */
@property (nonatomic,assign) NSUInteger  parentId;
/**  */
@property (nonatomic,copy) NSString *sort;
/**  */
@property (nonatomic,copy) NSString *status;


@end
