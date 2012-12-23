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

@property (weak) id delegate;

-(id)init;
-(id)objectWithData:(NSData*)jsonData; // returns a Foundation object (like NSDictionary or NSArray) from given JSON data.
-(NSData*)dataWithObject:(id)jsonObject; // returns JSON data from a Foundation object.

@end

@protocol EtherpadJsonDelegate
-(void)jsonDidFailWithError:(NSError*)error; // reports any errors to the delegate
@end
