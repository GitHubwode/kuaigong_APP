//
//  KGGNewFeatureCell.m
//  kuaigong
//
//  Created by Ding on 2017/11/27.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGNewFeatureCell.h"

@interface KGGNewFeatureCell()

@property (nonatomic, weak) UIImageView *imageView;

@end
@implementation KGGNewFeatureCell

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imageView];
    }
    
    return _imageView;
}



- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
    self.imageView.frame = self.bounds;
}

- (UIButton *)creatButtonImage:(NSString *)imageString HightString:(NSString *)hightString TagButton:(NSInteger )tagButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tagButton;
    [button setBackgroundImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:hightString] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
