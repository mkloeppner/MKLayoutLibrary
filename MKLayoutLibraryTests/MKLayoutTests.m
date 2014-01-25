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
    
    it(@"should return a specified userInfo for meta data", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        MKLayoutItem *layoutItem = [layout addSubview:childView];
        NSDictionary *userInfo = @{@"name": @"layoutItem"};
        layoutItem.userInfo = userInfo;
        
        expect(layout.items.count).to.equal(1);
        expect(layout.items[0]).to.equal(layoutItem);
        expect(layoutItem.userInfo).to.equal(userInfo);
    });
    
    // Helper
    it(@"should not apply gravity if gravity it set to MKLayoutGravityNone", ^{
        
        CGRect rect = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
        CGRect itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        CGRect resultHorizontalOnly = [layout applyGravity:MKLayoutGravityNone withRect:itemRect withinRect:rect];
        
        expect(resultHorizontalOnly).to.equal(itemRect);
        
    });
    
    it(@"should apply a gravity for rect within another rect horizontally (center)", ^{
        
        CGRect rect = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
        CGRect itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        CGRect resultHorizontalOnly = [layout applyGravity:MKLayoutGravityCenterHorizontal withRect:itemRect withinRect:rect];
        
        expect(resultHorizontalOnly).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f, 0.0f, itemRect.size.width, itemRect.size.height));
        
    });
    
    it(@"should apply a gravity for rect within another rect vertically (center)", ^{
        
        CGRect rect = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
        CGRect itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        CGRect resultVerticalOnly = [layout applyGravity:MKLayoutGravityCenterVertical withRect:itemRect withinRect:rect];
        
        expect(resultVerticalOnly).to.equal(CGRectMake(0.0f, rect.size.height / 2.0f - itemRect.size.height / 2.0f, itemRect.size.width, itemRect.size.height));
        
    });
    
    it(@"should apply a gravity for rect within another rect horizontally and vertically (center)", ^{
        
        CGRect rect = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
        CGRect itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        CGRect resultCentered = [layout applyGravity:MKLayoutGravityCenterHorizontal | MKLayoutGravityCenterVertical withRect:itemRect withinRect:rect];
        
        expect(resultCentered).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f, rect.size.height / 2.0f - itemRect.size.height / 2.0f, itemRect.size.width, itemRect.size.height));
        
    });
    
    it(@"should apply a gravity for rect within another rect horizontally and keep the vertical offset", ^{
        
        CGRect rect = CGRectMake(0.0f, 10.0f, 100.0f, 100.0f);
        CGRect itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        CGRect resultHorizontalOnly = [layout applyGravity:MKLayoutGravityCenterHorizontal withRect:itemRect withinRect:rect];
        
        expect(resultHorizontalOnly).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f, itemRect.origin.y, itemRect.size.width, itemRect.size.height));
        
    });
    
    it(@"should apply a gravity for rect within another rect vertically and keep the horizontal offset", ^{
        
        CGRect rect = CGRectMake(10.0f, 0.0f, 100.0f, 100.0f);
        CGRect itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        CGRect resultVerticalOnly = [layout applyGravity:MKLayoutGravityCenterVertical withRect:itemRect withinRect:rect];
        
        expect(resultVerticalOnly).to.equal(CGRectMake(itemRect.origin.x, rect.size.height / 2.0f - itemRect.size.height / 2.0f, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to topleft", ^{
        
        CGRect rect = CGRectMake(10.0f, 0.0f, 100.0f, 100.0f);
        CGRect itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        CGRect resultVerticalOnly = [layout applyGravity:MKLayoutGravityTop | MKLayoutGravityLeft withRect:itemRect withinRect:rect];
        
        expect(resultVerticalOnly).to.equal(CGRectMake(rect.origin.x, rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to topright", ^{
        
        CGRect rect = CGRectMake(10.0f, 0.0f, 100.0f, 100.0f);
        CGRect itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        CGRect resultVerticalOnly = [layout applyGravity:MKLayoutGravityTop | MKLayoutGravityRight withRect:itemRect withinRect:rect];
        
        expect(resultVerticalOnly).to.equal(CGRectMake(rect.size.width - itemRect.size.width + rect.origin.x, rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to top and horizontalcenter", ^{
        
        CGRect rect = CGRectMake(10.0f, 0.0f, 100.0f, 100.0f);
        CGRect itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        CGRect resultVerticalOnly = [layout applyGravity:MKLayoutGravityTop | MKLayoutGravityCenterHorizontal withRect:itemRect withinRect:rect];
        
        expect(resultVerticalOnly).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f + rect.origin.x, rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to bottomleft", ^{
        
        CGRect rect = CGRectMake(10.0f, 0.0f, 100.0f, 100.0f);
        CGRect itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        CGRect resultVerticalOnly = [layout applyGravity:MKLayoutGravityBottom | MKLayoutGravityLeft withRect:itemRect withinRect:rect];
        
        expect(resultVerticalOnly).to.equal(CGRectMake(rect.origin.x, rect.size.height - itemRect.size.height, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to bottomright", ^{
        
        CGRect rect = CGRectMake(10.0f, 0.0f, 100.0f, 100.0f);
        CGRect itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        CGRect resultVerticalOnly = [layout applyGravity:MKLayoutGravityBottom | MKLayoutGravityRight withRect:itemRect withinRect:rect];
        
        expect(resultVerticalOnly).to.equal(CGRectMake(rect.size.width - itemRect.size.width + rect.origin.x, rect.size.height - itemRect.size.height + rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to bottom and horizontalcenter", ^{
        
        CGRect rect = CGRectMake(10.0f, 0.0f, 100.0f, 100.0f);
        CGRect itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        CGRect resultVerticalOnly = [layout applyGravity:MKLayoutGravityBottom | MKLayoutGravityCenterHorizontal withRect:itemRect withinRect:rect];
        
        expect(resultVerticalOnly).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f + rect.origin.x, rect.size.height - itemRect.size.height + rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to vericalcenter left", ^{
        
        CGRect rect = CGRectMake(10.0f, 0.0f, 100.0f, 100.0f);
        CGRect itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        CGRect resultVerticalOnly = [layout applyGravity:MKLayoutGravityCenterVertical | MKLayoutGravityLeft withRect:itemRect withinRect:rect];
        
        expect(resultVerticalOnly).to.equal(CGRectMake(rect.origin.x, rect.size.height / 2.0f - itemRect.size.height / 2.0f, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to verticalcenter right", ^{
        
        CGRect rect = CGRectMake(10.0f, 0.0f, 100.0f, 100.0f);
        CGRect itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        CGRect resultVerticalOnly = [layout applyGravity:MKLayoutGravityCenterVertical | MKLayoutGravityRight withRect:itemRect withinRect:rect];
        
        expect(resultVerticalOnly).to.equal(CGRectMake(rect.size.width - itemRect.size.width + rect.origin.x, rect.size.height / 2.0f - itemRect.size.height / 2.0f, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to horizontalcenter top", ^{
        
        CGRect rect = CGRectMake(10.0f, 0.0f, 100.0f, 100.0f);
        CGRect itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        CGRect resultVerticalOnly = [layout applyGravity:MKLayoutGravityCenterHorizontal | MKLayoutGravityTop withRect:itemRect withinRect:rect];
        
        expect(resultVerticalOnly).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f + rect.origin.x, rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to horizontalcenter bottom", ^{
        
        CGRect rect = CGRectMake(10.0f, 0.0f, 100.0f, 100.0f);
        CGRect itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        CGRect resultVerticalOnly = [layout applyGravity:MKLayoutGravityCenterHorizontal | MKLayoutGravityBottom withRect:itemRect withinRect:rect];
        
        expect(resultVerticalOnly).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f + rect.origin.x, rect.size.height - itemRect.size.height, itemRect.size.width, itemRect.size.height));
    });
    
});

SpecEnd