//
//  UIScrollView+IHFEmptyData.m
//  IHFRefresh
//
//  Created by CjSon on 16/4/23.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import "UIScrollView+IHFEmptyData.h"
#import "IHFRefresh.h"
#import "UIScrollView+IHFRefresh.h"
#import <objc/runtime.h>

NSString const *IHFEmptyDataViewKey = @"IHFEmptyDataViewKey";
NSString const *IHFOperationKey = @"IHFOperationKey";
NSString const *IHFRefreshTargetKey = @"IHFRefreshTargetKey";
NSString const *IHFRefreshActionKey = @"IHFRefreshActionKey";

@implementation UIScrollView (IHFEmptyData)

#pragma mark - empty data view show and hide 

-(void)showEmptyDataView{
    [self showEmptyDataViewWithTitle:nil buttonTitle:nil];
}

-(void)showEmptyDataViewWithTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle{
    if (!self) return; // if self is nil , not add the data view
    
    if(!self.emptyDataView) { // Use lazy load empty data view
        
        IHEmptyDataView *dataView = [IHEmptyDataView emptyDataViewShowInView:self title:title buttonTitle:buttonTitle];
        
        dataView.didClickRefreshButtonOperation = ^(){
            if (self.refreshOperation) {
                self.refreshOperation();
            }else if (self.refreshTarget) { // use target
                if ([self.refreshTarget respondsToSelector:self.refreshAction]) {
                    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [self.refreshTarget performSelector:self.refreshAction];
                }
            }else{ // not implementation in controller or view , it will to call drop-down refresh method！
                
                if([self isKindOfClass:[UITableView class]]){
                    
                    UITableView *tableView = (UITableView *)self;
                    [tableView.refreshHeader beginRefreshing];
                    
                }else if([self isKindOfClass:[UICollectionView class]]){
                    
                    UICollectionView *collectionView = (UICollectionView *)self;
                    [collectionView.refreshHeader beginRefreshing];
                }
            }
        };
        self.emptyDataView = dataView;
    }
    
    [self.emptyDataView showPopupAnimationInView:self];
}

- (void)addTarget:(id)target refreshAction:(SEL)action{
    self.refreshTarget = target;
    self.refreshAction = action;
}

-(void)hideEmptyDataView{
    [self.emptyDataView hidePopupAnimation];
}

#pragma mark - reload data method
-(void)reloadDataWithEmptyData{
    [self reloadDataWithEmptyDataViewTitle:nil buttonTitle:nil];
}

-(void)reloadDataWithEmptyDataViewTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle{
    
    if([self isKindOfClass:[UITableView class]]){
        
        UITableView *tableView = (UITableView *)self;
        [tableView reloadData];
        if (tableView.numberOfSections == 0 || (tableView.numberOfSections == 1 && [tableView numberOfRowsInSection:0] == 0)) {
            [self showEmptyDataViewWithTitle:title buttonTitle:buttonTitle];
        }else{
            [self hideEmptyDataView];
        }
    }else if([self isKindOfClass:[UICollectionView class]]){
        
        UICollectionView *collectionView = (UICollectionView *)self;
        [collectionView reloadData];
        if (collectionView.numberOfSections == 0 || (collectionView.numberOfSections == 1 && [collectionView numberOfItemsInSection:0] == 0)) {
            [self showEmptyDataViewWithTitle:title buttonTitle:buttonTitle];
        }else{
            [self hideEmptyDataView];
        }
    }
}

#pragma mark - getter and setter
-(void)setEmptyDataView:(IHEmptyDataView *)emptyDataView{
    
    objc_setAssociatedObject(self, &IHFEmptyDataViewKey, emptyDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView *)emptyDataView{
    return objc_getAssociatedObject(self, &IHFEmptyDataViewKey);
}

-(void)setRefreshOperation:(RefreshOperation)refreshOperation{
    objc_setAssociatedObject(self, &IHFOperationKey, refreshOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(RefreshOperation)refreshOperation{
    return objc_getAssociatedObject(self, &IHFOperationKey);
}

-(void)setRefreshTarget:(id)refreshTarget{
    
    objc_setAssociatedObject(self, &IHFRefreshTargetKey, refreshTarget, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)refreshTarget{
    return objc_getAssociatedObject(self, &IHFRefreshTargetKey);
}

-(void)setRefreshAction:(SEL)refreshAction{
    
    NSString *action = NSStringFromSelector(refreshAction);
    objc_setAssociatedObject(self, &IHFRefreshActionKey, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(SEL)refreshAction{
    
    id action = objc_getAssociatedObject(self, &IHFRefreshActionKey);
    return NSSelectorFromString(action);
}
@end
