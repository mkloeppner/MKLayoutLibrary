//
//  MKLinearLayoutItem.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLinearLayoutItem.h"
#import "MKLayoutItem_SubclassAccessors.h"

@interface MKLinearLayoutItem ()

@property (assign, nonatomic) BOOL usesRelativeSize;

@end

@implementation MKLinearLayoutItem

- (instancetype)initWithLayout:(MKLayout *)layout
{
    MKLinearLayoutItem *layoutItem = [super initWithLayout:layout];
    layoutItem.usesRelativeSize = NO;
    return layoutItem;
}

- (void)setPoints:(CGFloat)points
{
    _points = points;
    self.usesRelativeSize = NO;
}

- (void)setWeight:(CGFloat)weight
{
    _weight = weight;
    self.usesRelativeSize = YES;
}

@end
