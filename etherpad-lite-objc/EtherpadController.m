//
//  EtherpadController.m
//  etherpad-lite-objc
//
//  Copyright (c) 2012 Alexander Zautke.
//  This code is released under the MIT License (MIT).
//  For conditions of distribution and use, see the disclaimer and license in EtherpadController.h
//

#import "EtherpadController.h"

@implementation EtherpadController

@synthesize apiController;
@synthesize dataLabel;
@synthesize codeLabel;
@synthesize messageLabel;

- (id)init
{
    self = [super init];
    if (self) {
        apiController = [[EtherAPIController alloc] init];
        apiController.delegate = self;
        apiController.apiKey = @"apiKey";
        apiController.host = @"http://localhost:9001";
    }
    return self;
}


-(IBAction)sendMessage:(id)sender{
    [apiController createPad:@"newEtherpad" :@"HelloWorld"];
}

-(IBAction)clearData:(id)sender{
    dataLabel.stringValue = @"";
    codeLabel.stringValue = @"";
    messageLabel.stringValue = @"";
}

-(void)requestDidFinish:(NSDictionary *)responseDictionary{
    [codeLabel setStringValue:[responseDictionary objectForKey:@"code"]];
    [messageLabel setStringValue:[responseDictionary objectForKey:@"message"]];
    [dataLabel setStringValue:[responseDictionary objectForKey:@"data"]];
    
    NSData* jsonData = [apiController getJSON];
    NSLog(@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
}

-(void)requestDidFailWithError:(NSError *)error{
    NSLog(@"%@",[error localizedDescription]);
}

@end
