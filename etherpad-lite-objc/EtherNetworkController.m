//
//  EtherNetworkController.m
//  etherpad-lite-objc
//
//  Copyright (c) 2012 Alexander Zautke.
//  This code is released under the MIT License (MIT).
//  For conditions of distribution and use, see the disclaimer and license in EtherpadController.h
//

#import "EtherNetworkController.h"

@interface EtherNetworkController()

@property (strong) NSURLConnection* connection;
@property NSOperationQueue* operationQueue;

@end

@implementation EtherNetworkController

@synthesize delegate;
@synthesize padData;
@synthesize connection;

#pragma mark init methods

- (id)init
{
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

#pragma mark main methods

-(void)sendMessage:(NSString *)message ToHost:(NSString *)host apiKey:(NSString *)apiKey messageParameters:(NSString *)messageParameters{
    NSString* urlString = [[NSString alloc] initWithFormat:@"%@/api/1/%@?apikey=%@&%@",host,message,apiKey,messageParameters];
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [NSURLConnection sendAsynchronousRequest:request queue:self.operationQueue completionHandler:^(NSURLResponse *respone, NSData *data, NSError *error){
        self.padData = data;
        if (self.padData != nil) {
            if ([self.delegate respondsToSelector:@selector(networkRequestDidFinish)]) {
                [self.delegate networkRequestDidFinish];
            }
        }
        else {
            int errorCode = 0;
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:@"Failed to get data" forKey:NSLocalizedDescriptionKey];
            NSError* error = [[NSError alloc] initWithDomain:@"com.etherpad-lite-client.Network" code:errorCode userInfo:errorDetail];
            if ([self.delegate respondsToSelector:@selector(networkRequestDidFailWithError:)]) {
                [self.delegate networkRequestDidFailWithError:error];
            }
        }
    }];
}

#pragma mark delegate methods nsurlconnection

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(networkRequestDidFailWithError:)]) {
        [self.delegate networkRequestDidFailWithError:error];
    }
}

@end
