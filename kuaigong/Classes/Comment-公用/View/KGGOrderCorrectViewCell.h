//
//  KGGOrderCorrectViewCell.h
//  kuaigong
//
//  Created by Ding on 2017/10/17.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGGOrderCorrectModel;

@interface KGGOrderCorrectViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *correctTextField;
@property (nonatomic, strong) KGGOrderCorrectModel *correntModel;
+ (NSString *)ordeCorrectIdentifier;


@end
