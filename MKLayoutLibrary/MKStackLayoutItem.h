//
//  MKStackLayoutItem.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLayoutItem.h"

@interface MKStackLayoutItem : MKLayoutItem

/**
 * The offset between the parent and the layout items view
 */
@property (assign, nonatomic) UIEdgeInsets margin;

@end
