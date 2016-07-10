//
//  UIScrollView+IHFRefresh.h
//  IHFRefresh
//
//  Created by CjSon on 16/4/23.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IHFRefreshFooterView,IHFRefreshHeaderView;
@interface UIScrollView (IHFRefresh)
@property (strong, nonatomic) IHFRefreshHeaderView *refreshHeader;
@property (strong, nonatomic) IHFRefreshFooterView *refreshFooter;
@end
