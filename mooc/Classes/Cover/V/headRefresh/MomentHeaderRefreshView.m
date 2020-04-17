//
//  MomentHeaderRefreshView.m
//  SilkyWXList
//
//  Created by Runing on 2019/10/12.
//  Copyright © 2019 Doogore. All rights reserved.
//

#import "MomentHeaderRefreshView.h"

#define headHeight  60

@interface  MomentHeaderRefreshView ()

@property (weak, nonatomic) UIImageView* rotateImage;

@end

@implementation MomentHeaderRefreshView

- (void)prepare
{
    [super prepare];
    
    self.ignoredScrollViewContentInsetTop = - 60;

    self.mj_h = headHeight;
    
    UIImageView* rotateImage = [[UIImageView alloc]
                                 initWithImage:[UIImage imageNamed:@"refresh"]];
    [self addSubview:rotateImage];

    self.rotateImage = rotateImage;
    
    self.mj_y = -self.mj_h - self.ignoredScrollViewContentInsetTop;
}

- (void)placeSubviews
{
    [super placeSubviews];
     
    self.rotateImage.frame = CGRectMake(30, 30, 30, 30);

}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary*)change
{
    [super scrollViewContentOffsetDidChange:change];

    self.mj_y = -self.mj_h - self.ignoredScrollViewContentInsetTop;
    
    CGFloat pullingY = fabs(self.scrollView.mj_offsetY + 64 +
                            self.ignoredScrollViewContentInsetTop);
    if (pullingY >= headHeight) {

        CGFloat marginY = -headHeight - (pullingY - headHeight) -
        self.ignoredScrollViewContentInsetTop;
        self.mj_y = marginY ;
    }
 
    [UIView animateWithDuration:2 animations:^{
        self.rotateImage.transform = CGAffineTransformRotate(self.rotateImage.transform,M_PI/2);
    }];
    
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            self.rotateImage.hidden = YES;
            break;
        case MJRefreshStatePulling:
            self.rotateImage.hidden = NO;
            break;
        case MJRefreshStateRefreshing:
            self.rotateImage.hidden = NO;
            break;
        default:
            break;
    }
}

@end
