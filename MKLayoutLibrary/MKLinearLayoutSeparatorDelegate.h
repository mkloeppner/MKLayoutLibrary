//
// Created by Martin Klöppner on 1/26/14.
// Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKLinearLayoutOrientation.h"

@class MKLinearLayout;
@class MKLinearLayoutItem;

@protocol MKLinearLayoutSeparatorDelegate <NSObject>

- (CGFloat)separatorThicknessForLinearLayout:(MKLinearLayout *)layout;

@optional

- (BOOL)linearLayout:(MKLinearLayout *)linearLayout shouldAddSeparatorBetweenLeftLayoutItem:(MKLinearLayoutItem *)leftItem andRightLayoutItem:(MKLinearLayoutItem *)rightItem;

- (UIEdgeInsets)separatorIntersectionOffsetsForLinearLayout:(MKLinearLayout *)layout;

- (void)linearLayout:(MKLinearLayout *)linearLayout separatorRect:(CGRect)rect type:(MKLinearLayoutOrientation)type;

@end