//
//  KGGPayTimeChooseField.h
//  kuaigong
//
//  Created by Ding on 2017/9/18.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGGPayTimeChooseFieldDelegate <NSObject>

@optional
- (void)payTimeChooseFieldEnsureButtonClick;


@end

@interface KGGPayTimeChooseField : UITextField

@property (nonatomic, weak)id<KGGPayTimeChooseFieldDelegate >timeDelegate;

/** 数据源 */
@property (nonatomic,strong)NSMutableArray *timeDatasource;;

@end
