//
//  IHFRefreshFooterView.h
//  IHFRefresh
//
//  Created by CjSon on 16/4/23.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import "IHFRefreshView.h"

@interface IHFRefreshFooterView : IHFRefreshView

/**
 Pull up for refresh
 
 @ refreshingOperation : Do the refresh in the block
 */
+ (instancetype)footerWithRefreshingOperation:(BeginRefreshingOperation)refreshingOperation;

/**
 Pull up for refresh
 
 @ target : Do the refresh in the target to perform the action!
 */

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
