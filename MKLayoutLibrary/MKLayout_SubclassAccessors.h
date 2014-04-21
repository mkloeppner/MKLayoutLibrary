//
//  MKLayout_SubclassAccessors.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 20/04/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//
#import "MKLayoutItem.h"

@interface MKLayoutItem ()

/**
 *  Applies the frame to its view or sublayout
 *
 *  @param frame The frame where the subview or the sublayout is beeing placed within the container
 */
- (void)applyPositionWithinLayoutFrame:(CGRect)frame;

@end

@interface MKLayout ()

/**
 *  The bounds to layout
 */
@property (assign, nonatomic) CGRect bounds;

@end