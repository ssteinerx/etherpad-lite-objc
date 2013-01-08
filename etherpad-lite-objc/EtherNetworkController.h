//
//  EtherNetworkController.h
//  etherpad-lite-objc
//
//  Copyright (c) 2012 Alexander Zautke.
//  This code is released under the MIT License (MIT).
//  For conditions of distribution and use, see the disclaimer and license in EtherpadController.h
//

#import <Foundation/Foundation.h>

@interface EtherNetworkController : NSObject

@property (weak) id delegate;
@property (weak) NSData* padData; // parsed JSON data / server response

-(id)init;
-(void)sendMessage:(NSString *)message ToHost:(NSString *)host apiVersion:(NSString *)apiVersion apiKey:(NSString *)apiKey messageParameters:(NSString *)messageParameters; // sends the request with the passed parameters to the etherpad-lite api

@end

@protocol EtherpadNetworkDelegate
-(void)networkRequestDidFinish; // informs the delegate, that the etherpad-lite server has sent a response
-(void)networkRequestDidFailWithError:(NSError*)error; // reports any network-related errors to the delegate
@end
