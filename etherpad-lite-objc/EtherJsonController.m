//
//  EtherJsonController.m
//  etherpad-lite-objc
//
//  Copyright (c) 2012 Alexander Zautke.
//  This code is released under the MIT License (MIT).
//  For conditions of distribution and use, see the disclaimer and license in EtherpadController.h
//

#import "EtherJsonController.h"

@implementation EtherJsonController

@synthesize delegate;

#pragma mark init methods

-(id)init{
    self = [super init];
    if (self) {
        // Initialization code here.
    }    
    return self;
}

#pragma mark main methods

-(id)objectWithData:(NSData *)jsonData{
    NSError *error = nil;
    id jObject = [NSJSONSerialization
                   JSONObjectWithData:jsonData
                   options:NSJSONReadingMutableContainers
                   error:&error];
    if (jObject != nil) {
        return jObject;
    }
    else {
        if ([self.delegate respondsToSelector:@selector(jsonDidFailWithError:)]) {
            [self.delegate jsonDidFailWithError:error];
        }
        return nil;
    }
}

-(NSData*)dataWithObject:(id)jsonObject{
    NSError *error = nil;
    NSData* jsonData = [NSJSONSerialization
                         dataWithJSONObject:jsonObject
                         options:NSJSONWritingPrettyPrinted
                         error:&error];
    if (jsonData != nil) {
        return jsonData;
    }
    else {
        if ([self.delegate respondsToSelector:@selector(jsonDidFailWithError:)]) {
            [self.delegate jsonDidFailWithError:error];
        }
        return nil;
    }
}

@end
