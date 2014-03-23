//
//  MKStackLayout.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKStackLayout.h"

@interface MKStackLayout ()

@property (assign, nonatomic) CGRect bounds;

@end

@implementation MKStackLayout

- (void)layoutBounds:(CGRect)bounds
{
    self.bounds = UIEdgeInsetsInsetRect(bounds, self.margin);
    
    for (NSUInteger i = 0; i < self.items.count; i++) {
        MKStackLayoutItem *layoutItem = self.items[i];
        
        CGRect rect = [self rectForItem:layoutItem];
        
        rect.origin.x += self.bounds.origin.x;
        rect.origin.y += self.bounds.origin.y;
        
        // In order to generate the inner margins we already reduced the size of the inner rect
        rect = UIEdgeInsetsInsetRect(rect, layoutItem.margin);
        
        // Now we move the view to the edges of the outer rectange so we have to apply the margin on the outer rect too
        rect = [self applyGravity:layoutItem.gravity withRect:rect withinRect:UIEdgeInsetsInsetRect(self.bounds, layoutItem.margin)];
        
        if (layoutItem.subview) {
            layoutItem.subview.frame = [self rectRoundedToGridWithRect:rect];
        } else if (layoutItem.sublayout) {
            [layoutItem.sublayout layoutBounds:rect];
        }
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

- (MKStackLayoutItem *)addSubview:(UIView *)subview
{
    MKStackLayoutItem *stackLayoutItem = [[MKStackLayoutItem alloc] initWithLayout:self subview:subview];
    [self addLayoutItem:stackLayoutItem];
    return stackLayoutItem;
}

- (MKStackLayoutItem *)addSublayout:(MKLayout *)sublayout
{
    MKStackLayoutItem *stackLayoutItem = [[MKStackLayoutItem alloc] initWithLayout:self sublayout:sublayout];
    [self addLayoutItem:stackLayoutItem];
    return stackLayoutItem;
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
