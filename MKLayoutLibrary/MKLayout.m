//
//  MKLayout.m
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLayout.h"

@interface MKLayout ()

@property (strong, nonatomic) NSMutableArray *mutableItems;

@end

@implementation MKLayout

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.view = view;
        
        self.mutableItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (MKLayoutItem *)addSubview:(UIView *)subview
{
    MKLayoutItem *layoutItem = [[MKLayoutItem alloc] initWithLayout:self subview:subview];
    [self addLayoutItem:layoutItem];
    return layoutItem;
}

- (MKLayoutItem *)addSublayout:(MKLayout *)sublayout
{
    MKLayoutItem *layoutItem = [[MKLayoutItem alloc] initWithLayout:self sublayout:sublayout];
    [self addLayoutItem:layoutItem];
    return layoutItem;
}

- (void)addLayoutItem:(MKLayoutItem *)layoutItem
{
    if (layoutItem.subview) {
        [self.view addSubview:layoutItem.subview];
    }
    [self.mutableItems addObject:layoutItem];
}

- (void)removeLayoutItem:(MKLayoutItem *)layoutItem
{
    [self.mutableItems removeObject:layoutItem];
}

- (NSArray *)items
{
    return [NSArray arrayWithArray:self.mutableItems];
}

- (void)layout
{
    [self layoutBounds:self.view.bounds];
}

- (void)layoutBounds:(CGRect)bounds
{
    
}

// Layout helper
- (CGRect)applyGravity:(MKLayoutGravity)gravity withRect:(CGRect)rect withinRect:(CGRect)outerRect
{
    if (MKLayoutGravityNone == gravity) {
        return rect;
    }
    
    // Can be both, centered horizontally and vertically at the same time
    if ((gravity & MKLayoutGravityCenterHorizontal) == MKLayoutGravityCenterHorizontal) {
        rect = CGRectMake(outerRect.size.width / 2.0f - rect.size.width / 2.0f,
                          rect.origin.y,
                          rect.size.width,
                          rect.size.height);
    }
    if ((gravity & MKLayoutGravityCenterVertical) == MKLayoutGravityCenterVertical) {
        rect = CGRectMake(rect.origin.x,
                          outerRect.size.height / 2.0f - rect.size.height / 2.0f,
                          rect.size.width,
                          rect.size.height);
    }
    
    if (((gravity & MKLayoutGravityCenterHorizontal) != MKLayoutGravityCenterHorizontal)) {
        
        if ((gravity & MKLayoutGravityLeft) == MKLayoutGravityLeft) {
            
            rect = CGRectMake(outerRect.origin.x,
                              rect.origin.y,
                              rect.size.width,
                              rect.size.height);
            
        } else if ((gravity & MKLayoutGravityRight) == MKLayoutGravityRight) {
            
            rect = CGRectMake(outerRect.origin.x + outerRect.size.width - rect.size.width,
                              rect.origin.y,
                              rect.size.width,
                              rect.size.height);
            
        }
        
    }
    
    if (((gravity & MKLayoutGravityCenterVertical) != MKLayoutGravityCenterVertical)) {
        
        if ((gravity & MKLayoutGravityTop) == MKLayoutGravityTop) {
            
            rect = CGRectMake(rect.origin.x,
                              outerRect.origin.y,
                              rect.size.width,
                              rect.size.height);
            
        } else if ((gravity & MKLayoutGravityBottom) == MKLayoutGravityBottom) {
            
            rect = CGRectMake(rect.origin.x,
                              outerRect.origin.y + outerRect.size.height - rect.size.height,
                              rect.size.width,
                              rect.size.height);
            
        }
        
    }
    
    
    return rect;
}

@end
