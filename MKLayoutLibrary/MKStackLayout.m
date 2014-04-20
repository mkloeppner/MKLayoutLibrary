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
        
        CGRect rect = [self rectForItem:item];
        
        rect.origin.x += self.bounds.origin.x;
        rect.origin.y += self.bounds.origin.y;
        
        // In order to generate the inner margins we already reduced the size of the inner rect
        rect = UIEdgeInsetsInsetRect(rect, item.padding);
        
        // Now we move the view to the edges of the outer rectange so we have to apply the margin on the outer rect too
        rect = [self applyGravity:item.gravity withRect:rect withinRect:UIEdgeInsetsInsetRect(self.bounds, item.padding)];
        
        rect.origin.x += item.offset.horizontal;
        rect.origin.y += item.offset.vertical;
        
        rect = [self rectRoundedToGridWithRect:rect];
        [item setFrame:rect];
    }
    
    if (!self.item.layout) {
        [self callSeparatorDelegate];
    }
    
    self.bounds = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (CGRect)rectForItem:(MKStackLayoutItem *)item
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
    rect.size.width = [self widthForItem:item];
    rect.size.height = [self heightForItem:item];
    return rect;
}

- (CGFloat)widthForItem:(MKStackLayoutItem *)item
{
    if (item.size.width == kMKLayoutItemSizeValueMatchParent) {
        return self.bounds.size.width;
    }
    return item.size.width;
}

- (CGFloat)heightForItem:(MKStackLayoutItem *)item
{
    if (item.size.height == kMKLayoutItemSizeValueMatchParent) {
        return self.bounds.size.height;
    }
    return item.size.height;
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
