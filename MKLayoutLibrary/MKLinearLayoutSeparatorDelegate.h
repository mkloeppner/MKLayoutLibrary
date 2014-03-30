//
// Created by Martin Klöppner on 1/26/14.
// Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKLayoutOrientation.h"
#import "MKLayoutSeparatorDelegate.h"

@class MKLinearLayout;
@class MKLinearLayoutItem;

@protocol MKLinearLayoutSeparatorDelegate <MKLayoutSeparatorDelegate>

- (CGFloat)separatorThicknessForLinearLayout:(MKLinearLayout *)layout;

@optional

- (UIEdgeInsets)separatorIntersectionOffsetsForLinearLayout:(MKLinearLayout *)layout;

- (void)linearLayout:(MKLinearLayout *)linearLayout separatorRect:(CGRect)rect type:(MKLayoutOrientation)type;

@end