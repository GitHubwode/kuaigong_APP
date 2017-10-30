//
//  KGGShowFeedApiItem.h
//  kuaigong
//
//  Created by Ding on 2017/10/29.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KGGPictureMetadata;

@interface KGGShowFeedApiItem : NSObject
@property (nonatomic, copy) NSString *img_list;
/** 第一张图片的地址 */
@property (nonatomic, copy) NSString *img_top;

@property (nonatomic, copy) NSString *stage_id;

//////***  以下参数为辅助参数，并不参与到接口的请求中  ***/////////
@property (nonatomic, strong) NSArray<UIImage *> *images;
@property (nonatomic, strong) NSArray<KGGPictureMetadata *> *imageDatas;

@end
