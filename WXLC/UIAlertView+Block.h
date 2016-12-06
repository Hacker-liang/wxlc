//
//  UIAlertView+Block.h
//  lvxingpai
//
//  Created by liangpengshuai on 14-8-20.
//  Copyright (c) 2014年 aizou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void(^CompleteBlock) (NSInteger buttonIndex);

@interface UIAlertView (Block)

- (void)showAlertViewWithBlock:(CompleteBlock) completeBlock;

@end
