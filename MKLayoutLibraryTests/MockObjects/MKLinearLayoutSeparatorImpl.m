//
// Created by Martin Klöppner on 1/26/14.
// Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLinearLayoutSeparatorImpl.h"
#import "MKLinearLayout.h"

NSString *const kSeparatorsDictionaryKeyRect = @"kSeparatorsDictionaryKeyRect";
NSString *const kSeparatorsDictionaryKeyType = @"kSeparatorsDictionaryKeyType";

@interface MKLinearLayoutSeparatorImpl ()

@property (strong, nonatomic, readwrite) NSMutableArray *separators;

@end

@implementation MKLinearLayoutSeparatorImpl

- (instancetype)initWithSeparatorThickness:(CGFloat)separatorThickness separatorIntersectionOffsets:(UIEdgeInsets)separatorIntersectionOffsets {
    self = [super init];
    if (self) {
        self.separatorThickness = separatorThickness;
        self.separatorIntersectionOffsets = separatorIntersectionOffsets;
        self.separators = [[NSMutableArray alloc] init];
    }

    return self;
}

+ (instancetype)separatorWithSeparatorThickness:(CGFloat)separatorThickness separatorIntersectionOffsets:(UIEdgeInsets)separatorIntersectionOffsets {
    return [[self alloc] initWithSeparatorThickness:separatorThickness separatorIntersectionOffsets:separatorIntersectionOffsets];
}

- (CGFloat)separatorThicknessForLinearLayout:(MKLinearLayout *)layout {
    return self.separatorThickness;
}

- (UIEdgeInsets)separatorIntersectionOffsetsForLinearLayout:(MKLinearLayout *)layout
{
    return self.separatorIntersectionOffsets;
}

- (void)linearLayout:(MKLinearLayout *)linearLayout separatorRect:(CGRect)rect type:(MKLayoutOrientation)type {
    NSValue *separatorRect = [NSValue valueWithCGRect:rect];
    NSNumber *separatorType = @(type);

    [self.separators addObject:@{
            kSeparatorsDictionaryKeyRect : separatorRect,
            kSeparatorsDictionaryKeyType : separatorType
    }];
}

@end