//
//  MKLayout.m
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLayout.h"

@interface MKLayout ()

@property (strong, nonatomic, readwrite) MKLayoutItem *item;

@property (strong, nonatomic) NSMutableArray *mutableItems;

@end

@implementation MKLayout

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.view = view;
        self.mutableItems = [[NSMutableArray alloc] init];
        self.margin = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.mutableItems = [[NSMutableArray alloc] init];
        self.margin = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    return self;
}

- (void)clear
{
    NSArray *layoutItems = [self.items copy];
    for (MKLayoutItem *layoutItem in layoutItems) {
        [layoutItem removeFromLayout];
    }
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
    if (layoutItem.sublayout) {
        layoutItem.sublayout.item = layoutItem;
        layoutItem.sublayout.view = self.view;
    }
    [self.mutableItems addObject:layoutItem];
    if ([self.delegate respondsToSelector:@selector(layout:didAddLayoutItem:)]) {
        [self.delegate layout:self didAddLayoutItem:layoutItem];
    }
}

- (void)removeLayoutItem:(MKLayoutItem *)layoutItem
{
    [self.mutableItems removeObject:layoutItem];
    if ([self.delegate respondsToSelector:@selector(layout:didRemoveLayoutItem:)]) {
        [self.delegate layout:self didRemoveLayoutItem:layoutItem];
    }
}

- (NSArray *)items
{
    return [NSArray arrayWithArray:self.mutableItems];
}

- (void)layout
{
    if ([self.delegate respondsToSelector:@selector(layoutDidStartToLayout:)]) {
        [self.delegate layoutDidStartToLayout:self];
    }
    [self layoutBounds:self.view.bounds];
    if ([self.delegate respondsToSelector:@selector(layoutDidFinishToLayout:)]) {
        [self.delegate layoutDidFinishToLayout:self];
    }
}

- (void)layoutBounds:(CGRect)bounds
{
    
}

- (void)setView:(UIView *)view
{
    _view = view;
    for (MKLayoutItem *item in self.items) {
        if (item.subview) {
            [item.subview removeFromSuperview];
            [view addSubview:item.subview];
        } else if (item.sublayout) {
            item.sublayout.view = view;
        }
    }
}

- (void)setDelegate:(id<MKLayoutDelegate>)delegate
{
    _delegate = delegate;
    for (MKLayoutItem *item in self.items) {
        if (item.sublayout) {
            item.sublayout.delegate = delegate;
        }
    }
}

// Layout helper
- (CGRect)applyGravity:(MKLayoutGravity)gravity withRect:(CGRect)rect withinRect:(CGRect)outerRect
{
    if (MKLayoutGravityNone == gravity) {
        return rect;
    }
    
    // Can be both, centered horizontally and vertically at the same time
    if ((gravity & MKLayoutGravityCenterHorizontal) == MKLayoutGravityCenterHorizontal) {
        rect = CGRectMake(outerRect.size.width / 2.0f - rect.size.width / 2.0f + outerRect.origin.x,
                          rect.origin.y,
                          rect.size.width,
                          rect.size.height);
    }
    if ((gravity & MKLayoutGravityCenterVertical) == MKLayoutGravityCenterVertical) {
        rect = CGRectMake(rect.origin.x,
                          outerRect.size.height / 2.0f - rect.size.height / 2.0f + outerRect.origin.y,
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
