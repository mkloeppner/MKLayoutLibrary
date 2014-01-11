//
//  MKLinearLayout.m
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLinearLayout.h"

@implementation MKLinearLayout

- (instancetype)initWithView:(UIView *)view
{
    self = [super initWithView:view];
    if (self) {
        self.orientation = MKLinearLayoutOrientationHorizontal;
    }
    return self;
}

- (MKLinearLayoutItem *)addSubview:(UIView *)subview
{
    MKLinearLayoutItem *item = [[MKLinearLayoutItem alloc] initWithLayout:self subview:subview];
    [self addLayoutItem:item];
    return item;
}

- (MKLinearLayoutItem *)addSublayout:(MKLayout *)sublayout
{
    MKLinearLayoutItem *item = [[MKLinearLayoutItem alloc] initWithLayout:self sublayout:sublayout];
    [self addLayoutItem:item];
    return item;
}

- (void)layoutBounds:(CGRect)bounds
{
    float currentPos = 0.0f;
    float overallWeight = 0.0f;
    float overallPoints = 0.0f;
    float contentSize = self.orientation == MKLinearLayoutOrientationHorizontal ? bounds.size.width : bounds.size.height;
    
    for (int i = 0; i < self.items.count; i++) {
        MKLinearLayoutItem *item = self.items[i];
        if (item.usesRelativeSize) {
            overallWeight += item.weight;
        } else {
            overallPoints += item.points;
        }
    }
    
    for (int i = 0; i < self.items.count; i++) {
        
        MKLinearLayoutItem *item = self.items[i];
        
        float currentStep = item.points;
        if (item.usesRelativeSize) {
            float percent = item.weight / overallWeight;
            
            float boundsWithoutAbsoluteSizes = contentSize - overallPoints;
            currentStep = boundsWithoutAbsoluteSizes * percent;
        }
        
        CGRect rect = [self orientedRectForPosition:currentPos length:currentStep bounds:bounds];
        rect.origin.x += bounds.origin.x;
        rect.origin.y += bounds.origin.y;
        
        if (item.subview) {
            item.subview.frame = rect;
        } else if (item.sublayout) {
            [item.sublayout layoutBounds:rect];
        }
        
        currentPos += currentStep;
    }
}

/**
 * Get the rect for the actual orientation
 */
- (CGRect)orientedRectForPosition:(CGFloat)position length:(CGFloat)length bounds:(CGRect)bounds
{
    CGRect rect;
    
    if (self.orientation == MKLinearLayoutOrientationHorizontal) {
        rect.origin.x = position;
        rect.origin.y = 0.0f;
        rect.size.width = length;
        rect.size.height = bounds.size.height;
    } else if (self.orientation == MKLinearLayoutOrientationVertical) {
        rect.origin.x =  0.0f;
        rect.origin.y = position;
        rect.size.width = bounds.size.width;
        rect.size.height = length;
    } else {
        [NSException raise:@"InvalidArgumentException" format:@"property \"orientation\" got an invalid value"];
    }
    return rect;
}

@end
