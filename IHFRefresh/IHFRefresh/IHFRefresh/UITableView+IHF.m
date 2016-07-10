//
//  UITableView+IHF.m
//  nursing
//
//  Created by CjSon on 16/5/30.
//  Copyright © 2016年 IHEFE CO., LIMITED. All rights reserved.
//

#import "UITableView+IHF.h"
#import <objc/runtime.h>
#import "UIScrollView+IHFEmptyData.h"
static const void *rotateKey = &rotateKey;
static const void *delegateKey = &delegateKey;

@interface UITableView ()<IHFTableViewDelegate>

@end

@implementation UITableView (IHF)



#pragma marl - rotate cell
-(void)rotateCell:(UITableViewCell *)cell{
    CATransform3D rotate;
    
    CGFloat value = ((90.0 * M_PI) / 180.0);
    
    rotate = CATransform3DMakeRotation(value, 0.0, 0.7, 0.4);
    
    rotate.m34 = 1.0 / -600;
    
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotate;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    
    [UIView beginAnimations:@"rotate" context:nil];
    
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self rotateCell:cell];
}

-(void)setRotateAnimate:(BOOL)rotateAnimate{
    
    objc_setAssociatedObject(self, rotateKey, @(rotateAnimate),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (rotateAnimate) {
        self.IHFDelegate = self;
    }
}

-(BOOL)rotateAnimate{
    return [objc_getAssociatedObject(self, rotateKey) boolValue];
}

-(void)setIHFDelegate:(id<IHFTableViewDelegate>)IHFDelegate{
    objc_setAssociatedObject(self,delegateKey,IHFDelegate ,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id<IHFTableViewDelegate>)IHFDelegate{
    return objc_getAssociatedObject(self, delegateKey);
}



@end
