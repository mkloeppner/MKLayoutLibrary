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

@end
