//
//  KGGSexChangeViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/9/1.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGGSexField.h"

@class KGGPublishPersonModel;

@protocol KGGSexChangeViewCellDelegate <NSObject>

- (void)KGGSexChangeButtonClickSex:(NSString *)sex;

@end

@interface KGGSexChangeViewCell : UITableViewCell

/** 模型 */
@property (nonatomic,strong)KGGPublishPersonModel *personModel;
@property (weak, nonatomic) IBOutlet KGGSexField *personTextField;
@property (nonatomic, weak) id<KGGSexChangeViewCellDelegate>sexDelegate;

+ (NSString *)cellIdentifier;

@end
