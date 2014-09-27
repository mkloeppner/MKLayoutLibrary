//
//  MKLayoutItemTestsSpec.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 4/19/14.
//  Copyright 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "MKLayout.h"
#import "MKLinearLayoutSeparatorImpl.h"
#import "MKLayoutDelegateImpl.h"

#define EXP_SHORTHAND
#import "Expecta.h"

SpecBegin(MKLayoutItemTests)

describe(@"MKLayoutItemTests", ^{
    
    __block UIView *container;
    
    __block MKLayout *layout;
    
    __block UIView *subview1;
    __block UIView *subview2;
    __block UIView *subview3;
    __block UIView *subview4;
    
    beforeEach(^{
        
        container = [[UIView alloc] initWithFrame:(CGRect){300.0f}];
        
        layout = [[MKLayout alloc] initWithView:container];
        
        subview1 = [[UIView alloc] initWithFrame:(CGRect){100.0f}];
        subview2 = [[UIView alloc] initWithFrame:(CGRect){100.0f}];
        subview3 = [[UIView alloc] initWithFrame:(CGRect){100.0f}];
        subview4 = [[UIView alloc] initWithFrame:(CGRect){100.0f}];
    });
    
    it(@"should provide a userInfo dictionary in order to allow introspection", ^{
        
        NSDictionary *userInfo = @{@"test": @"test"};
        
        MKLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.userInfo = userInfo;
        
        expect(userInfo).to.equal(userInfo);
        
    });
    
    it(@"should not remove its sublayout views if its a sublayout item and removeFromLayout is beeing called", ^{
        
        MKLayout *sublayout = [[MKLayout alloc] init];
        [sublayout addSubview:subview1];
        
        expect(sublayout.items.count).to.equal(1);
        
        MKLayoutItem *layoutItem = [layout addSublayout:sublayout];
        
        expect(sublayout.items.count).to.equal(1);
        
        [layoutItem removeFromLayout];
        
        expect(sublayout.items.count).to.equal(1);
        
    });
    
    it(@"should not retain its delegate since its holding the layout", ^{
        
        __weak MKLayoutDelegateImpl *weakInstanceOfLayoutDelegate = nil;
        __strong MKLayout *layout = [[MKLayout alloc] init];
        
        @autoreleasepool {
            MKLayoutDelegateImpl *createdInstanceOfLayoutDelegate = [[MKLayoutDelegateImpl alloc] init];
            weakInstanceOfLayoutDelegate = createdInstanceOfLayoutDelegate;
            
            layout.delegate = weakInstanceOfLayoutDelegate;
        }
        
        expect(layout.delegate).to.equal(nil);
        
    });
    
    it(@"should not retain its layout delegate since its holding the layout", ^{
        
        __weak MKLinearLayoutSeparatorImpl *weakInstanceOfLayoutDelegate = nil;
        __strong MKLayout *layout = [[MKLayout alloc] init];
        
        @autoreleasepool {
            MKLinearLayoutSeparatorImpl *createdInstanceOfLayoutDelegate = [[MKLinearLayoutSeparatorImpl alloc] init];
            weakInstanceOfLayoutDelegate = createdInstanceOfLayoutDelegate;
            
            layout.separatorDelegate = weakInstanceOfLayoutDelegate;
        }
        
        expect(layout.separatorDelegate).to.equal(nil);
        
    });
    
});

SpecEnd
