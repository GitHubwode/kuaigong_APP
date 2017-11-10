//
//  KGGHomeListViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/8/22.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGHomePublishModel;

@interface KGGHomeListViewCell : UITableViewCell

+ (NSString *)homeListIdentifier;
@property (weak, nonatomic) IBOutlet UITextField *homeTextField;

@property (nonatomic, strong) KGGHomePublishModel *publishModel;
@property (weak, nonatomic) IBOutlet UIButton *loseButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic, copy) NSString *price;


@end
