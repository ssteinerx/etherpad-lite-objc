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

#pragma mark main methods

+ (id)objectWithData:(NSData *)jsonData error:(NSError**)error{
    id jsonObject = [NSJSONSerialization
                  JSONObjectWithData:jsonData
                  options:NSJSONReadingMutableContainers
                  error:error];
    return jsonObject;
}

+ (id)objectWithData:(NSData *)jsonData{
    return [self objectWithData:jsonData error:NULL];
}

+ (NSData*)dataWithObject:(id)jsonObject error:(NSError**)error{
    if (![NSJSONSerialization isValidJSONObject:jsonObject]) {
        if (error != NULL) {
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            NSString* localizedDescription = [NSString stringWithFormat:@"The given object \"%@\" is not a valid JSON object.",[jsonObject description]];
            [errorDetail setValue:localizedDescription forKey:NSLocalizedDescriptionKey];
            *error = [[NSError alloc] initWithDomain:@"com.etherpad-lite-client.EtherJsonController" code:nil userInfo:errorDetail];
        }
        return nil;
    }
    NSData* jsonData = [NSJSONSerialization
                         dataWithJSONObject:jsonObject
                         options:NSJSONWritingPrettyPrinted
                         error:error];
    return jsonData;
}

+ (NSData*)dataWithObject:(id)jsonObject{
    return [self dataWithObject:jsonObject error:NULL];
}

@end
