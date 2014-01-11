//
//  MKLayoutTests.m
//  MKLayoutTests
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "MKLayout.h"

#define EXP_SHORTHAND
#import "Expecta.h"


SpecBegin(MKLayoutSpecification)

describe(@"MKLayout", ^{
    
    __block MKLayout *layout;
    __block UIView *container;
    
    beforeEach(^{
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 100.0)];
        layout = [[MKLayout alloc] initWithView:container];
    });
    
    
    // View management
    it(@"should associate the specified container", ^{
        expect(layout.view).to.equal(container);
    });
    
    it(@"should add a view to the associated view of the layout when added to it", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        [layout addSubview:childView];
        
        expect(container.subviews.count).to.equal(1);
        expect(container.subviews[0]).to.equal(childView);
    });
    
    it(@"should add multiple views to the associated view of the layout when added to it", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        [layout addSubview:childView];
        
        UIView *childView2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        [layout addSubview:childView2];
        
        expect(container.subviews.count).to.equal(2);
        expect(container.subviews[0]).to.equal(childView);
        expect(container.subviews[1]).to.equal(childView2);
    });
    
    it(@"should return an layout reference object to identify the childViews associated layout parameters", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        MKLayoutItem *layoutItem = [layout addSubview:childView];
        
        expect(layoutItem).toNot.beNil;
        expect(layoutItem.subview).to.equal(childView);
        expect(layoutItem.layout).to.equal(layout);
    });
    
    it(@"should remove view from layout", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        MKLayoutItem *layoutItem = [layout addSubview:childView];
        
        [layoutItem removeFromLayout];
        
        expect(layout.view.subviews.count).to.equal(0);
        expect(layoutItem.layout).to.beNil;
        
    });
    
    it(@"should add a view of a sublayout with adding this sublayout", ^{
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        
        MKLayout *sublayout = [[MKLayout alloc] initWithView:container];
        MKLayoutItem *layoutItem = [sublayout addSubview:childView];
        [layout addSublayout:sublayout];
        
        expect(layoutItem).toNot.beNil;
        expect(layoutItem.subview).to.equal(childView);
        expect(layoutItem.layout).to.equal(sublayout);
        
    });
    
    it(@"should remove a view of a sublayout with removing this sublayout", ^{
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        
        MKLayout *sublayout = [[MKLayout alloc] initWithView:container];
        [sublayout addSubview:childView];
        MKLayoutItem *sublayoutItem = [layout addSublayout:sublayout];
        
        [sublayoutItem removeFromLayout];
        
        expect(layout.view.subviews.count).to.equal(0);
        expect(sublayoutItem.layout).to.beNil;
        
    });
    
    // Item management
    it(@"should cache the layout item for a added view to allow to access information at any time", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        MKLayoutItem *layoutItem = [layout addSubview:childView];
        
        expect(layout.items.count).to.equal(1);
        expect(layout.items[0]).to.equal(layoutItem);
    });
    
    it(@"should remove a layout item from cache with removing the view", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        MKLayoutItem *layoutItem = [layout addSubview:childView];
        
        [layoutItem removeFromLayout];
        
        expect(layout.items.count).to.equal(0);
    });
    
    it(@"should provide an empty method to override", ^{
        [layout layoutBounds:layout.view.bounds];
    });
    
});

SpecEnd