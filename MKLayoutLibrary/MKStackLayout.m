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
        MKLayoutItem *layoutItem = self.items[i];
        
        CGRect rect = UIEdgeInsetsInsetRect(bounds, layoutItem.margin);
        
        if ([layoutItem isKindOfClass:[MKViewLayoutItem class]]) {
            MKViewLayoutItem *viewLayoutItem = (MKViewLayoutItem *)layoutItem;
            viewLayoutItem.view.frame = rect;
        } else if ([layoutItem isKindOfClass:[MKSublayoutLayoutItem class]]) {
            MKSublayoutLayoutItem *sublayoutItem = (MKSublayoutLayoutItem *)layoutItem;
            [sublayoutItem.sublayout layoutBounds:rect];
        }
    }
}

@end
