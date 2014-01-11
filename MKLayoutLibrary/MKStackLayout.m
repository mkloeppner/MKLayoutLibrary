//
//  MKStackLayout.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKStackLayout.h"

@implementation MKStackLayout

- (void)layoutBounds:(CGRect)bounds
{
    for (int i = 0; i < self.items.count; i++) {
        MKStackLayoutItem *layoutItem = self.items[i];
        
        CGRect rect = UIEdgeInsetsInsetRect(bounds, layoutItem.margin);
        
        if (layoutItem.view) {
            layoutItem.view.frame = rect;
        } else if (layoutItem.sublayout) {
            [layoutItem.sublayout layoutBounds:rect];
        }
    }
}

- (MKStackLayoutItem *)addSubview:(UIView *)subview
{
    MKStackLayoutItem *stackLayoutItem = [[MKStackLayoutItem alloc] initWithLayout:self view:subview];
    [self addLayoutItem:stackLayoutItem];
    return stackLayoutItem;
}

- (MKStackLayoutItem *)addSublayout:(MKLayout *)sublayout
{
    MKStackLayoutItem *stackLayoutItem = [[MKStackLayoutItem alloc] initWithLayout:self sublayout:sublayout];
    [self addLayoutItem:stackLayoutItem];
    return stackLayoutItem;
}

@end
