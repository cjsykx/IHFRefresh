//
//  IHFRefreshFooterView.h
//  IHFRefresh
//
//  Created by CjSon on 16/4/23.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import "IHFRefreshView.h"

@interface IHFRefreshFooterView : IHFRefreshView

+(instancetype)footerWithRefreshingOperation:(BeginRefreshingOperation)refreshingOperation;

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
