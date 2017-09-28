//
//  KGGPaychooseHeaderView.h
//  kuaigong
//
//  Created by Ding on 2017/9/14.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGGPaychooseHeaderViewDelegate <NSObject>

- (void)kgg_paySheetHeaderViewDeleteClick;


@end

@interface KGGPaychooseHeaderView : UIView

@property (nonatomic, strong) UILabel *titleStateLabel;
@property (nonatomic, weak) id <KGGPaychooseHeaderViewDelegate>delegate;


@end
