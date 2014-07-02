//
//  MKRect.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 7/2/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKLayoutItem.h"

/**
 * Applies gravity to a rectangle within another one.
 */
@interface MKGravity : NSObject

@property (assign, nonatomic, readonly) CGRect CGRect;
@property (assign, nonatomic, readonly) CGRect parentRect;

- (instancetype)initWithCGRect:(CGRect)rect parent:(CGRect)parentRect;

/**
 * Moves an rect within an other rect and uses the gravity to align it within.
 *
 *      Note: If gravity is MKLayoutGravityNone the method exits immediately with return the rect param.
 */
- (void)moveByGravity:(MKLayoutGravity)gravity;

@end
