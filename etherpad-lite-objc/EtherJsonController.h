//
//  EtherJsonController.h
//  etherpad-lite-objc
//
//  Copyright (c) 2012 Alexander Zautke.
//  This code is released under the MIT License (MIT).
//  For conditions of distribution and use, see the disclaimer and license in EtherpadController.h
//

#import <Foundation/Foundation.h>

@interface EtherJsonController : NSObject

+ (id)objectWithData:(NSData*)jsonData; // returns a Foundation object (like NSDictionary or NSArray) from given JSON data.
+ (id)objectWithData:(NSData *)jsonData error:(NSError**)error;

+ (NSData*)dataWithObject:(id)jsonObject; // returns JSON data from a Foundation object.
+ (NSData*)dataWithObject:(id)jsonObject error:(NSError**)error;

@end
