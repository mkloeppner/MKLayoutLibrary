//
//  MKCGRectAdditions.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 7/12/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#ifndef MKLayoutLibrary_MKCGRectAdditions_h
#define MKLayoutLibrary_MKCGRectAdditions_h

static inline CGRect CGRectMoveHorizontallyToCenterWithinRect(CGRect rect, CGRect outerRect) {
    return CGRectMake(outerRect.size.width / 2.0f - rect.size.width / 2.0f + outerRect.origin.x,
                      rect.origin.y,
                      rect.size.width,
                      rect.size.height);
}

static inline CGRect CGRectMoveVerticallyToCenterWithinRect(CGRect rect, CGRect outerRect) {
    return CGRectMake(rect.origin.x,
                      outerRect.size.height / 2.0f - rect.size.height / 2.0f + outerRect.origin.y,
                      rect.size.width,
                      rect.size.height);
}

static inline CGRect CGRectMoveToLeftWithinRect(CGRect rect, CGRect outerRect)
{
    return CGRectMake(outerRect.origin.x,
                      rect.origin.y,
                      rect.size.width,
                      rect.size.height);
}

static inline CGRect CGRectMoveToRightWithinRect(CGRect rect, CGRect outerRect)
{
    return CGRectMake(outerRect.origin.x + outerRect.size.width - rect.size.width,
                      rect.origin.y,
                      rect.size.width,
                      rect.size.height);
}

static inline CGRect CGRectMoveToTopWithinRect(CGRect rect, CGRect outerRect)
{
    return CGRectMake(rect.origin.x,
                      outerRect.origin.y,
                      rect.size.width,
                      rect.size.height);
}

static inline CGRect CGRectMoveToBottomWithinRect(CGRect rect, CGRect outerRect)
{
    return CGRectMake(rect.origin.x,
                      outerRect.origin.y + outerRect.size.height - rect.size.height,
                      rect.size.width,
                      rect.size.height);
}


#endif
