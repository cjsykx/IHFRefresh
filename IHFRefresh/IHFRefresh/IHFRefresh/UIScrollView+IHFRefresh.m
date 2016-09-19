//
//  UIScrollView+IHFRefresh.m
//  IHFRefresh
//
//  Created by CjSon on 16/4/23.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import "UIScrollView+IHFRefresh.h"
#import "IHFRefreshFooterView.h"
#import "IHFRefreshHeaderView.h"
#import <objc/runtime.h>

static const NSString * IHFRefreshFooterKey = @"IHFRefreshFooterKey";
static const NSString * IHFRefreshHeaderKey = @"IHFRefreshHeaderKey";

@implementation UIScrollView (IHFRefresh)

#pragma mark - Refresh Header view

- (void)setRefreshHeader:(IHFRefreshHeaderView *)refreshHeader {
    
    if (refreshHeader != self.refreshHeader) {
        
        // delete old header view , add insert new head view
        [self.refreshHeader removeFromSuperview];
        [self insertSubview:refreshHeader atIndex:0];
        
        // set new
        [self willChangeValueForKey:@"refreshHeader"];
        objc_setAssociatedObject(self, &IHFRefreshHeaderKey,
                                 refreshHeader, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"refreshHeader"];
    }
    
}

- (IHFRefreshHeaderView *)refreshHeader {
    return objc_getAssociatedObject(self, &IHFRefreshHeaderKey);
}

#pragma mark - Refresh footer view

- (void)setRefreshFooter:(IHFRefreshFooterView *)refreshFooter {
    
    if (refreshFooter != self.refreshFooter) {
        
        // delete old header view , add insert new head view
        [self.refreshFooter removeFromSuperview];
        [self insertSubview:refreshFooter atIndex:0];
        
        // set new
        [self willChangeValueForKey:@"IHFRefreshFooter"];
        objc_setAssociatedObject(self, &IHFRefreshFooterKey,
                                 refreshFooter, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"IHFRefreshFooter"];
    }
}

- (IHFRefreshFooterView *)refreshFooter {
    return objc_getAssociatedObject(self, &IHFRefreshFooterKey);
}
@end
