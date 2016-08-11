//
//  UIScrollView+IHFEmptyData.h
//  IHFRefresh
//
//  Created by CjSon on 16/4/23.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IHEmptyDataView.h"

@interface UIScrollView (IHFEmptyData)

@property (nonatomic,readwrite) IHEmptyDataView *emptyDataView;

/**
 Show the empty view from IHEmptyDataViewXib!
 
*/

-(void)showEmptyDataView;

/**
 Show the empty view from IHEmptyDataViewXib!
 
 @ title : set the title if you not want to display the defalt from IHEmptyDataViewXib!
 @ buttonTitle : set the buttonTitle if you not want to display the defalt from IHEmptyDataViewXib!
 
 */

-(void)showEmptyDataViewWithTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle;

/**
 hide the empty view from IHEmptyDataViewXib!
 
 */

-(void)hideEmptyDataView;

/** 
 Relaod data , if the data is empty , it will auto show the empty data for you ,otherwise it will hide the emprty
 
 @ Main for table View or colletion View to relaod data !
 @ The empty data view is IHEmptyDataViewXib!
 */
-(void)reloadDataWithEmptyData;

/**
 Relaod data , if the data is empty , it will auto show the empty data you ,otherwise it will hide the emprty
 
 @ Main for table View or colletion View to relaod data !
 @ title : set the title if you not want to display the defalt from IHEmptyDataViewXib!
 @ buttonTitle : set the buttonTitle if you not want to display the defalt from IHEmptyDataViewXib!

 */

-(void)reloadDataWithEmptyDataViewTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle;

// the fresh method is call by controller and view !
// if not implementation in controller or view , it will to call drop-down refresh method！

typedef void (^RefreshOperation)();

@property (nonatomic,copy) RefreshOperation refreshOperation; // when click the refresh btn , to tell delegate to refresh

// when click the refresh btn , refreshTarget perform the refreshAction!
@property (nonatomic, weak) id refreshTarget;
@property (nonatomic, assign) SEL refreshAction;
- (void)addTarget:(id)target refreshAction:(SEL)action;



@end
