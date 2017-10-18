//
//  PKShortVideoViewController.h
//  DevelopWriterDemo
//
//  Created by jiangxincai on 16/1/14.
//  Copyright © 2016年 pepsikirk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PKRecordShortVideoDelegate <NSObject>

- (void)didFinishRecording;
- (void)didCancelRecording;
@end

@interface PKRecordShortVideoViewController : UIViewController

@property (nonatomic, assign) NSTimeInterval videoMaximumDuration;
@property (nonatomic, assign) NSTimeInterval videoMinimumDuration;
@property (nonatomic, weak) id<PKRecordShortVideoDelegate> delegate;


@end
