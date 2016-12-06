//
//  UIAlertView+Block.m
//  lvxingpai
//
//  Created by liangpengshuai on 14-8-20.
//  Copyright (c) 2014年 aizou. All rights reserved.
//

#import "UIAlertView+Block.h"

@implementation UIAlertView (Block)
static char key;

- (void)showAlertViewWithBlock:(CompleteBlock) completeBlock
{
    objc_removeAssociatedObjects(self);
    objc_setAssociatedObject(self, &key, completeBlock, OBJC_ASSOCIATION_COPY);
    self.delegate = self;
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    CompleteBlock block = objc_getAssociatedObject(self, &key);
    if (block) {
        block(buttonIndex);
    }
}

@end
