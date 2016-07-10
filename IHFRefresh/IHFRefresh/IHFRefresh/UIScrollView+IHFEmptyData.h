//
//  UIScrollView+IHFEmptyData.h
//  IHFRefresh
//
//  Created by CjSon on 16/4/23.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (IHFEmptyData)

@property (nonatomic,readwrite) UIView *emptyDataView;
-(void)showEmptyDataView;
-(void)showEmptyDataViewWithTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle;

-(void)hideEmptyDataView;

-(void)reloadDataWithEmptyData;
-(void)reloadDataWithEmptyDataViewTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle;

// the fresh method is call by controller and view !
// if not implementation in controller or view , it will to call drop-down refresh method！

typedef void (^RefreshOperation)();
@property (nonatomic,copy) RefreshOperation refreshOperation; // when click the refresh btn , to tell delegate to refresh

@property (nonatomic, weak) id refreshTarget;
@property (nonatomic, assign) SEL refreshAction;
- (void)addTarget:(id)target refreshAction:(SEL)action;



@end
