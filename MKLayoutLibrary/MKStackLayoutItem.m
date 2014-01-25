//
//  MKStackLayoutItem.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKStackLayoutItem.h"
#import "MKLayoutItem_SubclassAccessors.h"

const CGFloat kMKStackLayoutSizeValueMatchParent = -1.0;

@implementation MKStackLayoutItem

- (instancetype)initWithLayout:(MKLayout *)layout
{
    MKStackLayoutItem *layoutItem = [super initWithLayout:layout];
    layoutItem.size = CGSizeMake(kMKStackLayoutSizeValueMatchParent, kMKStackLayoutSizeValueMatchParent);
    return layoutItem;
}

@end
