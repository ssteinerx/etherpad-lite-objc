//
//  EtherAPIController.m
//  etherpad-lite-objc
//
//  Copyright (c) 2012 Alexander Zautke.
//  This code is released under the MIT License (MIT).
//  For conditions of distribution and use, see the disclaimer and license in EtherpadController.h
//

#import "EtherAPIController.h"

@interface EtherAPIController()

@property EtherNetworkController* etherNetworkController;
@property EtherJsonController* etherJsonParser;

@property NSString* message;
@property NSString* messageParameters;

@property NSData* responseData;

-(void)sendMessageToPad;
-(NSDictionary*)getResponseDictionary;
-(NSDictionary*)jsonToDictionary;
-(NSData*)getPrettyPrintedJson:(id)jsonDataObject;

@end

@implementation EtherAPIController

#pragma mark init methods

- (id)init
{
    self = [super init];
    if (self) {
        self.etherNetworkController = [[EtherNetworkController alloc] init];
        self.etherJsonParser = [[EtherJsonController alloc] init];
        self.etherNetworkController.delegate = self;
        self.etherJsonParser.delegate = self;
    }
    return self;
}

#pragma mark Groups

-(void)createGroup{
    self.message = @"createGroup";
    self.messageParameters = nil;
    [self sendMessageToPad];
}

-(void)createGroupIfNotExistsFor:(NSString *)groupMapper{
    self.message = @"createGroupIfNotExistsFor";
    self.messageParameters = [NSString stringWithFormat:@"groupMapper=%@",groupMapper];
    [self sendMessageToPad];
}

-(void)deleteGroup:(NSString*)groupID{
    self.message = @"deleteGroup";
    self.messageParameters = [NSString stringWithFormat:@"groupID=%@",groupID];
    [self sendMessageToPad];
}

-(void)listPads:(NSString *)groupID{
    self.message = @"listPads";
    self.messageParameters = [NSString stringWithFormat:@"groupID=%@",groupID];
    [self sendMessageToPad];
}

-(void)createGroupPad:(NSString*)groupID:(NSString*)padName:(NSString*)text{
    self.message = @"createGroupPad";
    if (text != nil) {
        self.messageParameters = [NSString stringWithFormat:@"groupID=%@&padName=%@&text=%@",groupID,padName,text];
    }
    else{
        self.messageParameters = [NSString stringWithFormat:@"groupID=%@&padName=%@",groupID,padName];
    }
    [self sendMessageToPad];
}

#pragma mark Author

-(void)createAuthor:(NSString *)name{
    self.message = @"createAuthor";
    if (name != nil) {
        self.messageParameters = [NSString stringWithFormat:@"name=%@",name];
    }
    [self sendMessageToPad];
}

-(void)listPadsOfAuthor:(NSString *)authorID{
    self.message = @"listPadsOfAuthor";
    self.messageParameters = [NSString stringWithFormat:@"authorID=%@",authorID];
    [self sendMessageToPad];
}

-(void)createAuthorIfNotExistsFor:(NSString *)authorMapper:(NSString *)name{
    self.message = @"createAuthorIfNotExistsFor";
    if (name != nil) {
        self.messageParameters = [NSString stringWithFormat:@"authorMapper=%@&name=%@",authorMapper,name];
    }
    else{
        self.messageParameters = [NSString stringWithFormat:@"authorMapper=%@",authorMapper];
    }
    [self sendMessageToPad];
}

#pragma mark Session

-(void)createSession:(NSString *)groupID :(NSString *)authorID :(long)validUntil{
    self.message = @"createSession";
    self.messageParameters = [NSString stringWithFormat:@"groupID=%@&authorID=%@&validUntil=%ld",groupID,authorID,validUntil];
    [self sendMessageToPad];
}

-(void)deleteSession:(NSString*)sessionID{
    self.message = @"deleteSession";
    self.messageParameters = [NSString stringWithFormat:@"sessionID=%@",sessionID];
    [self sendMessageToPad];
}

-(void)getSessionInfo:(NSString*)sessionID{
    self.message = @"getSessionInfo";
    self.messageParameters = [NSString stringWithFormat:@"sessionID=%@",sessionID];
    [self sendMessageToPad];
}

-(void)listSessionsOfGroup:(NSString *)groupID{
    self.message = @"listSessionsOfGroup";
    self.messageParameters = [NSString stringWithFormat:@"groupID=%@",groupID];
    [self sendMessageToPad];
}

-(void)listSessionsOfAuthor:(NSString *)authorID{
    self.message = @"listSessionsOfAuthor";
    self.messageParameters = [NSString stringWithFormat:@"authorID=%@",authorID];
    [self sendMessageToPad];
}

#pragma mark Pad Content

-(void)getText:(NSString *)padID :(NSString *)rev{
    self.message = @"getText";
    if (rev != nil) {
        self.messageParameters = [NSString stringWithFormat:@"padID=%@&rev=%@",padID,rev];
    }
    else{
        self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    }
    [self sendMessageToPad];
}

-(void)setText:(NSString*)padID:(NSString*)text{
    self.message = @"setText";
    if (text != nil) {
        self.messageParameters = [NSString stringWithFormat:@"padID=%@&text=%@",padID,text];
    }
    else{
        self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    }
    [self sendMessageToPad];
}

-(void)getHTML:(NSString*)padID:(NSString*)rev{
    self.message = @"getHTML";
    if (rev != nil) {
        self.messageParameters = [NSString stringWithFormat:@"padID=%@&rev=%@",padID,rev];
    }
    else{
        self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    }
    [self sendMessageToPad];
}

#pragma mark Pad

-(void)createPad:(NSString *)padID :(NSString *)text{
    self.message = @"createPad";
    if (text != nil) {
        self.messageParameters = [NSString stringWithFormat:@"padID=%@&text=%@",padID,text];
    }
    else{
        self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];   
    }
    [self sendMessageToPad];
}

-(void)getRevisionsCount:(NSString*)padID{
    self.message = @"getRevisionsCount";
    self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    [self sendMessageToPad];
}

-(void)padUsersCount:(NSString *)padID{
    self.message = @"padUsersCount";
    self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    [self sendMessageToPad];
}

-(void)deletePad:(NSString *)padID{
    self.message = @"deletePad";
    self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    [self sendMessageToPad];
}

-(void)getReadOnlyID:(NSString*)padID{
    self.message = @"getReadOnlyID";
    self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    [self sendMessageToPad];
}

-(void)setPublicStatus:(NSString*)padID:(BOOL)publicStatus{
    self.message = @"setPublicStatus";
    self.messageParameters = [NSString stringWithFormat:@"padID=%@&publicStatus=%d",padID,publicStatus];
    [self sendMessageToPad];
}

-(void)getPublicStatus:(NSString *)padID{
    self.message = @"getPublicStatus";
    self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    [self sendMessageToPad];
}

-(void)setPassword:(NSString *)padID :(NSString *)password{
    self.message = @"setPassword";
    self.messageParameters = [NSString stringWithFormat:@"padID=%@&password=%@",padID,password];
    [self sendMessageToPad];
}

-(void)isPasswordProtected:(NSString*)padID{
    self.message = @"isPasswordProtected";
    self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    [self sendMessageToPad];
}

-(void)listAuthorsOfPad:(NSString*)padID{
    self.message = @"listAuthorsOfPad";
    self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    [self sendMessageToPad];
}

-(void)getLastEdited:(NSString*)padID{
    self.message = @"getLastEdited";
    self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    [self sendMessageToPad];
}


#pragma mark helper methods

-(void)sendMessageToPad{
    [self.etherNetworkController sendMessage:self.message ToHost:self.host apiKey:self.apiKey messageParameters:self.messageParameters];
}

-(NSData*)getJSON{
    self.responseData = [self getPrettyPrintedJson:[self getResponseDictionary]];
    return self.responseData;
}

-(NSDictionary*)getResponseDictionary{
    NSDictionary* responseDictionary = [self jsonToDictionary];
    return responseDictionary;
}

-(NSDictionary*)jsonToDictionary{
    NSDictionary* jsonData = [self.etherJsonParser objectWithData:self.responseData];
    return jsonData;
}

-(NSData*)getPrettyPrintedJson:(id)jsonDataObject{
    return [self.etherJsonParser dataWithObject:jsonDataObject];
}

#pragma mark delegate methods

-(void)networkRequestDidFinish{
    self.responseData = self.etherNetworkController.padData;
    if ([self.delegate respondsToSelector:@selector(requestDidFinish:)]) {
        [self.delegate requestDidFinish:[self getResponseDictionary]];
    }
}

-(void)networkRequestDidFailWithError:(NSError*)error{
    if ([self.delegate respondsToSelector:@selector(requestDidFailWithError:)]) {
        [self.delegate requestDidFailWithError:error];
    }
}

-(void)jsonDidFailWithError:(NSError*)error{
    if ([self.delegate respondsToSelector:@selector(requestDidFailWithError:)]) {
        [self.delegate requestDidFailWithError:error];
    }
}

@end
