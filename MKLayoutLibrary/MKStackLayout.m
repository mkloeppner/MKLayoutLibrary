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
    self.bounds = UIEdgeInsetsInsetRect(bounds, self.margin);
    
    for (NSUInteger i = 0; i < self.items.count; i++) {
        MKStackLayoutItem *item = self.items[i];
        [item applyPositionWithinLayoutFrame:self.bounds];
    }
    
    if (!self.item.layout) {
        [self callSeparatorDelegate];
    }
    
    self.bounds = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (NSInteger)numberOfSeparatorsForSeparatorOrientation:(MKLayoutOrientation)orientation
{
    NSInteger numberOfSeparators = 0;
    
    for (MKLayoutItem *item in self.items) {
        if (item.sublayout) {
            MKLayout *layout = (MKLayout *)item.sublayout;
            numberOfSeparators += [layout numberOfSeparatorsForSeparatorOrientation:orientation];
        }
    }
    
    return numberOfSeparators;
}

- (void)callSeparatorDelegate
{
    for (MKLayoutItem *item in self.items) {
        if (item.sublayout && [item.sublayout respondsToSelector:@selector(callSeparatorDelegate)]) {
            id sublayout = item.sublayout;
            [sublayout callSeparatorDelegate];
        }
    }
}


@end
