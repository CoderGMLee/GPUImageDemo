//
//  UIView+Frame.h
// 
//
//  Created by ws ou on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIView_Frame)


@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
//
@property(nonatomic, assign) CGSize size;
@property(nonatomic, assign) CGPoint origin;
//
@property(nonatomic, assign) CGFloat left;
@property(nonatomic, assign) CGFloat top;
@property(nonatomic, assign) CGFloat right;
@property(nonatomic, assign) CGFloat bottom;

@property(nonatomic, assign) CGFloat centerX;
@property(nonatomic, assign) CGFloat centerY;


@end
