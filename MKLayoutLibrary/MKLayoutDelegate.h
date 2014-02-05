//
//  MKLayoutDelegate.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 05/02/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKLayout;

@protocol MKLayoutDelegate <NSObject>

@optional
- (void)layoutDidStartToLayout:(MKLayout *)layout;
- (void)layout:(MKLayout *)layout didAddLayoutItem:(MKLayoutItem *)item;
- (void)layout:(MKLayout *)layout didRemoveLayoutItem:(MKLayoutItem *)item;
- (void)layoutDidFinishToLayout:(MKLayout *)layout;

@end

