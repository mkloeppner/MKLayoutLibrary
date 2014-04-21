//
//  MKStackLayout.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKStackLayout.h"
#import "MKLayout_SubclassAccessors.h"

@interface MKStackLayout ()

@property (assign, nonatomic) CGRect bounds;

@end

@implementation MKStackLayout

SYNTHESIZE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(MKStackLayoutItem)

- (void)layoutBounds:(CGRect)bounds
{
    for (NSUInteger i = 0; i < self.items.count; i++) {
        MKStackLayoutItem *item = self.items[i];
        [item applyPositionWithinLayoutFrame:self.bounds];
    }
}


@end
