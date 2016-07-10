//
//  CurveView.m
//  LayerTest
//
//  Created by CjSon on 16/5/30.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#define Radius  10
#define Space    1
#define LineLength 30
#define CenterY  self.frame.size.height/2

#define Degree M_PI/3


#import "CurveView.h"
#import "CurveLayer.h"

@interface CurveView()

@property (nonatomic,strong)CurveLayer *curveLayer;

@end

@implementation CurveView

+ (Class)layerClass{
    return [CurveLayer class];
}

-(void)setProgress:(CGFloat)progress{
    self.curveLayer.progress = progress;
    [self.curveLayer setNeedsDisplay];
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    self.curveLayer = [CurveLayer layer];
    self.curveLayer.frame = self.bounds;
    self.curveLayer.contentsScale = [UIScreen mainScreen].scale;
    self.progress = 0.0f;
    [self.curveLayer setNeedsDisplay];
    [self.layer addSublayer:self.curveLayer];
    
}

#pragma mark --

-(CGPoint)getMiddlePointWithPoint1:(CGPoint)point1 point2:(CGPoint)point2{
    
    CGFloat middle_x = (point1.x + point2.x)/2;
    CGFloat middle_y = (point1.y + point2.y)/2;
    
    return CGPointMake(middle_x, middle_y);
}

-(CGFloat)getDistanceWithPoint1:(CGPoint)point1 point2:(CGPoint)point2{
    return sqrtf(pow(fabs(point1.x - point2.x), 2) + pow(fabs(point1.y - point2.y), 2));
}

@end
