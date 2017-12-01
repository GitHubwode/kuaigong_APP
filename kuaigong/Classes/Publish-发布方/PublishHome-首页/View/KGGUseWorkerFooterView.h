//
//  KGGUseWorkerFooterView.h
//  kuaigong
//
//  Created by Ding on 2017/12/1.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGGUseWorkerFooterViewDelegate <NSObject>

- (void)kgg_userworkFooterPhoneButtonClick;

@end

@interface KGGUseWorkerFooterView : UIView

@property (nonatomic, weak) id<KGGUseWorkerFooterViewDelegate>footerDelegate;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end
