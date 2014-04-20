//
//  MKFlowLayout.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 20/04/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKFlowLayout.h"
#import "MKLayout_SubclassAccessors.h"

@implementation MKFlowLayout

SYNTHESIZE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(MKFlowLayoutItem);

- (void)layoutBounds:(CGRect)bounds
{
    for (MKFlowLayoutItem *item in self.items) {
        
        CGRect frame = bounds;
    
        [item setFrame:frame];
        
    }
}

@end
