//
//  IHFRefreshHeaderView.h
//  IHFRefresh
//
//  Created by CjSon on 16/4/23.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import "IHFRefreshView.h"

@interface IHFRefreshHeaderView : IHFRefreshView

- (void)autoRefreshWhenViewDidAppear;

+(instancetype)headerWithRefreshingOperation:(BeginRefreshingOperation)refreshingOperation;

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
