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

@property (nonatomic,strong) NSMutableData* receivedData; // raw json data / server response
@property (nonatomic,strong) NSURLConnection* connection;

-(void)clearReceivedData;

@end

@implementation EtherNetworkController

@synthesize delegate;
@synthesize padData;
@synthesize receivedData;
@synthesize connection;

#pragma mark init methods

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}

#pragma mark main methods

-(void)sendMessage:(NSString *)message ToHost:(NSString *)host apiKey:(NSString *)apiKey messageParameters:(NSString *)messageParameters{
    NSString* urlString = [[NSString alloc] initWithFormat:@"%@/api/1/%@?apikey=%@&%@",host,message,apiKey,messageParameters];
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.receivedData = [[NSMutableData alloc] init];
}

- (void)clearReceivedData{
    [self.receivedData setLength:0];
}

#pragma mark delegate methods nsurlconnection

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.padData = (NSData*)self.receivedData;
    if (self.padData != nil) {
        if ([self.delegate respondsToSelector:@selector(networkRequestDidFinish)]) {
            [self.delegate networkRequestDidFinish];
        }
    }
    else {
        int errorCode = 0;
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"Failed to get receivedData" forKey:NSLocalizedDescriptionKey];
        NSError* error = [[NSError alloc] initWithDomain:@"com.etherpad-lite-client.Network" code:errorCode userInfo:errorDetail];
        if ([self.delegate respondsToSelector:@selector(networkRequestDidFailWithError:)]) {
            [self.delegate networkRequestDidFailWithError:error];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self clearReceivedData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self clearReceivedData];
    if ([self.delegate respondsToSelector:@selector(networkRequestDidFailWithError:)]) {
        [self.delegate networkRequestDidFailWithError:error];
    }
}

@end
