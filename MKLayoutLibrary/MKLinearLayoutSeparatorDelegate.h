//
// Created by Martin Klöppner on 1/26/14.
// Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKLinearLayout;

@protocol MKLinearLayoutSeparatorDelegate <NSObject>

- (CGFloat)separatorThicknessForLayout:(MKLinearLayout *)layout;
- (UIEdgeInsets)separatorIntersectionOffsetsForLayout:(MKLinearLayout *)layout;
- (UIImage *)horizontalSeparatorImageForLayout:(MKLinearLayout *)layout;
- (UIImage *)verticalSeparatorImageForLayout:(MKLinearLayout *)layout;

@end