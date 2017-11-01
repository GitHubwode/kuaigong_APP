//
//  KGGPictureMetadata.h
//  kuaigong
//
//  Created by Ding on 2017/10/29.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGPictureMetadata : NSObject<NSCoding>

@property (nonatomic, strong) NSString *url; ///< Full image url
@property (nonatomic, assign) CGFloat width; ///< pixel width
@property (nonatomic, assign) CGFloat height; ///< pixel height
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSData *data; // image data

@end
