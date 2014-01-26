//
// Created by Martin Klöppner on 1/26/14.
// Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLinearLayoutSeparatorImpl.h"
#import "MKLinearLayout.h"


@implementation MKLinearLayoutSeparatorImpl

- (instancetype)initWithSeparatorThickness:(CGFloat)separatorThickness separatorIntersectionOffsets:(UIEdgeInsets)separatorIntersectionOffsets horizontalSeparatorImage:(UIImage *)horizontalSeparatorImage verticalSeparatorImage:(UIImage *)verticalSeparatorImage {
    self = [super init];
    if (self) {
        self.separatorThickness = separatorThickness;
        self.separatorIntersectionOffsets = separatorIntersectionOffsets;
        self.horizontalSeparatorImage = horizontalSeparatorImage;
        self.verticalSeparatorImage = verticalSeparatorImage;
    }

    return self;
}

+ (instancetype)separatorWithSeparatorThickness:(CGFloat)separatorThickness separatorIntersectionOffsets:(UIEdgeInsets)separatorIntersectionOffsets horizontalSeparatorImage:(UIImage *)horizontalSeparatorImage verticalSeparatorImage:(UIImage *)verticalSeparatorImage {
    return [[self alloc] initWithSeparatorThickness:separatorThickness separatorIntersectionOffsets:separatorIntersectionOffsets horizontalSeparatorImage:horizontalSeparatorImage verticalSeparatorImage:verticalSeparatorImage];
}


- (CGFloat)separatorThicknessForLayout:(MKLinearLayout *)layout {
    return self.separatorThickness;
}

- (UIEdgeInsets)separatorIntersectionOffsetsForLayout:(MKLinearLayout *)layout {
    UIEdgeInsets result;
    return self.separatorIntersectionOffsets;
}

- (UIImage *)horizontalSeparatorImageForLayout:(MKLinearLayout *)layout {
    return self.horizontalSeparatorImage;
}

- (UIImage *)verticalSeparatorImageForLayout:(MKLinearLayout *)layout {
    return self.verticalSeparatorImage;
}


@end