//
//  KGGEditPublishViewController.h
//  kuaigong
//
//  Created by Ding on 2017/10/29.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UpdataImageBlock)(NSArray *imageListArray);

@interface KGGEditPublishViewController : UIViewController

@property (nonatomic, copy) UpdataImageBlock imageBlock;

@end
