//
// Created by Martin Klöppner on 1/26/14.
// Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKLinearLayoutSeparatorDelegate.h"

FOUNDATION_EXPORT NSString *const kSeparatorsDictionaryKeyRect;
FOUNDATION_EXPORT NSString *const kSeparatorsDictionaryKeyType;

@interface MKLinearLayoutSeparatorImpl : NSObject <MKLinearLayoutSeparatorDelegate>

@property (assign, nonatomic) CGFloat separatorThickness;
@property (assign, nonatomic) UIEdgeInsets separatorIntersectionOffsets;
@property (strong, nonatomic, readonly) NSMutableArray *separators;

- (instancetype)initWithSeparatorThickness:(CGFloat)separatorThickness separatorIntersectionOffsets:(UIEdgeInsets)separatorIntersectionOffsets;

+ (instancetype)separatorWithSeparatorThickness:(CGFloat)separatorThickness separatorIntersectionOffsets:(UIEdgeInsets)separatorIntersectionOffsets;


@end