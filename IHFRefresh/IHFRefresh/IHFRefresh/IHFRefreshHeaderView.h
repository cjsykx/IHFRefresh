//
//  IHFRefreshHeaderView.h
//  IHFRefresh
//
//  Created by CjSon on 16/4/23.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import "IHFRefreshView.h"

@interface IHFRefreshHeaderView : IHFRefreshView

/**
 In the view did appear , to auto refresh
 */

- (void)autoRefreshWhenViewDidAppear;

/**
 Pull down for refresh
 
 @ refreshingOperation : Do the refresh in the block
 */

+(instancetype)headerWithRefreshingOperation:(BeginRefreshingOperation)refreshingOperation;

/**
 Pull down for refresh
 
 @ target : Do the refresh in the target to perform the action!
 */

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
