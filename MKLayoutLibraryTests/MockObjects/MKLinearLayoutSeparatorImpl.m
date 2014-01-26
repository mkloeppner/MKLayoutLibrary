//
// Created by Martin Klöppner on 1/26/14.
// Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLinearLayoutSeparatorImpl.h"
#import "MKLinearLayout.h"


@implementation MKLinearLayoutSeparatorImpl

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