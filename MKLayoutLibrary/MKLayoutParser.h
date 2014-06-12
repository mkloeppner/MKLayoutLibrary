//
//  MKLayoutParser.h
//  LayoutParser
//
//  Created by Martin Klöppner on 12/06/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKLayoutLibrary.h"

extern NSString *const kMKLayoutParserErrorDomain;

typedef enum {
    MKLayoutParserUnsupportedAttributeError
} MKLayoutParserError;

@interface MKLayoutParser : NSObject

+ (MKLayout *)parseXMLFromFileAtURL:(NSURL *)fileURL error:(NSError *__autoreleasing *)error;
- (MKLayout *)parseXMLFromFileAtURL:(NSURL *)fileURL error:(NSError *__autoreleasing *)error;
- (MKLayout *)parseLayoutFromString:(NSString *)xmlLayout error:(NSError *__autoreleasing *)error;

@end
