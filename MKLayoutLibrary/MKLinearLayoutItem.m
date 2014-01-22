//
//  MKLinearLayoutItem.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLinearLayoutItem.h"
#import "MKLayoutItem_SubclassAccessors.h"

const CGFloat kMKLinearLayoutSizeValueMatchParent = -1.0f;

const CGFloat kMKLinearLayoutWeightInvalid = -2.0f;

@implementation MKLinearLayoutItem

- (instancetype)initWithLayout:(MKLayout *)layout
{
    MKLinearLayoutItem *layoutItem = [super initWithLayout:layout];
    layoutItem.weight = kMKLinearLayoutWeightInvalid;
    layoutItem.size = CGSizeMake(kMKLinearLayoutSizeValueMatchParent, 10);
    return layoutItem;
}

@end
