//
// Created by Martin Klöppner on 1/26/14.
// Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKLinearLayoutOrientation.h"

@class MKLinearLayout;

@protocol MKLinearLayoutSeparatorDelegate <NSObject>

- (CGFloat)separatorThicknessForLinearLayout:(MKLinearLayout *)layout;

@optional
- (UIEdgeInsets)separatorIntersectionOffsetsForLinearLayout:(MKLinearLayout *)layout;

- (void)linearLayout:(MKLinearLayout *)linearLayout separatorRect:(CGRect)rect type:(MKLinearLayoutOrientation)type;

@end