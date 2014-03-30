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
        [self setDefaultValues];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.view = nil;
        [self setDefaultValues];
    }
    return self;
}

- (void)setDefaultValues
{
    self.contentScaleFactor = [[UIScreen mainScreen] scale];
    self.mutableItems = [[NSMutableArray alloc] init];
    self.margin = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (MKLayoutItem *)addSubview:(UIView *)subview
{
    return [self insertSubview:subview atIndex:self.items.count];
}

- (MKLayoutItem *)addSublayout:(MKLayout *)sublayout
{
    return [self insertSublayout:sublayout atIndex:self.items.count];
}

- (MKLayoutItem *)insertSubview:(UIView *)subview atIndex:(NSInteger)index
{
    MKLayoutItem *layoutItem = [[MKLayoutItem alloc] initWithLayout:self subview:subview];
    [self insertLayoutItem:layoutItem atIndex:index];
    return layoutItem;
}

- (MKLayoutItem *)insertSublayout:(MKLayout *)sublayout atIndex:(NSInteger)index
{
    MKLayoutItem *layoutItem = [[MKLayoutItem alloc] initWithLayout:self sublayout:sublayout];
    [self insertLayoutItem:layoutItem atIndex:index];
    return layoutItem;
}

- (void)removeLayoutItemAtIndex:(NSInteger)index
{
    MKLayoutItem *item = self.items[index];
    [self.mutableItems removeObjectAtIndex:index];
    if ([self.delegate respondsToSelector:@selector(layout:didRemoveLayoutItem:)]) {
        [self.delegate layout:self didRemoveLayoutItem:item];
    }
}

- (void)clear
{
    NSArray *layoutItems = [self.items copy];
    for (MKLayoutItem *layoutItem in layoutItems) {
        [layoutItem removeFromLayout]; // To notify the delegate for every item that has been removed
    }
}

- (void)insertLayoutItem:(MKLayoutItem *)layoutItem atIndex:(NSInteger)index
{
    if (layoutItem.subview) {
        [self.view addSubview:layoutItem.subview];
    }
    if (layoutItem.sublayout) {
        layoutItem.sublayout.item = layoutItem;
        layoutItem.sublayout.view = self.view;
        layoutItem.sublayout.delegate = self.delegate;
        layoutItem.sublayout.separatorDelegate = self.separatorDelegate;
    }
    [self.mutableItems insertObject:layoutItem atIndex:index];
    if ([self.delegate respondsToSelector:@selector(layout:didAddLayoutItem:)]) {
        [self.delegate layout:self didAddLayoutItem:layoutItem];
    }
}

- (void)removeLayoutItem:(MKLayoutItem *)layoutItem
{
    [self removeLayoutItemAtIndex:[self.mutableItems indexOfObject:layoutItem]];
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

- (void)setSeparatorDelegate:(id<MKLayoutSeparatorDelegate>)separatorDelegate
{
    _separatorDelegate = separatorDelegate;
    for (MKLayoutItem *item in self.items) {
        if (item.sublayout) {
            item.sublayout.separatorDelegate = separatorDelegate;
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

- (CGRect)rectRoundedToGridWithRect:(CGRect)rect
{
    return CGRectMake(roundf(rect.origin.x * self.contentScaleFactor) / self.contentScaleFactor,
                      roundf(rect.origin.y * self.contentScaleFactor) / self.contentScaleFactor,
                      roundf(rect.size.width * self.contentScaleFactor) / self.contentScaleFactor,
                      roundf(rect.size.height * self.contentScaleFactor) / self.contentScaleFactor);
}

- (MKLayoutOrientation)flipOrientation:(MKLayoutOrientation)orientation
{
    if (MKLayoutOrientationHorizontal == orientation) {
        return MKLayoutOrientationVertical;
    }
    if (MKLayoutOrientationVertical == orientation) {
        return MKLayoutOrientationHorizontal;
    }
    [NSException raise:@"UnknownParamValueException" format:@"The specified orientation is unknown"];
    return -1;
}

-(NSInteger)numberOfSeparatorsForSeparatorOrientation:(MKLayoutOrientation)orientation
{
    return 0;
}

@end
