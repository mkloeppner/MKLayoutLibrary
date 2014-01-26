//
// Created by Martin Klöppner on 1/26/14.
// Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKLinearLayoutSeparatorDelegate.h"

@interface MKLinearLayoutSeparatorImpl : NSObject <MKLinearLayoutSeparatorDelegate>

@property (assign, nonatomic) CGFloat separatorThickness;
@property (assign, nonatomic) UIEdgeInsets separatorIntersectionOffsets;
@property (strong, nonatomic) UIImage *horizontalSeparatorImage;
@property (strong, nonatomic) UIImage *verticalSeparatorImage;

@end