//
//  EtherAPIController.m
//  etherpad-lite-objc
//
//  Copyright (c) 2012 Alexander Zautke.
//  This code is released under the MIT License (MIT).
//  For conditions of distribution and use, see the disclaimer and license in EtherpadController.h
//

#import "EtherAPIController.h"

@interface EtherAPIController()<EtherpadNetworkDelegate>

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

-(void)createGroupPad:(NSString*)groupID padName:(NSString*)padName text:(NSString*)text{
    self.message = @"createGroupPad";
    if (text != nil) {
        self.messageParameters = [NSString stringWithFormat:@"groupID=%@&padName=%@&text=%@",groupID,padName,text];
    }
    else{
        self.messageParameters = [NSString stringWithFormat:@"groupID=%@&padName=%@",groupID,padName];
    }
    [self sendMessageToPad];
}

-(void)listAllGroups{
    self.message = @"listAllGroups";
    self.messageParameters = nil;
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

-(void)createAuthorIfNotExistsFor:(NSString *)authorMapper name:(NSString *)name{
    self.message = @"createAuthorIfNotExistsFor";
    if (name != nil) {
        self.messageParameters = [NSString stringWithFormat:@"authorMapper=%@&name=%@",authorMapper,name];
    }
    else{
        self.messageParameters = [NSString stringWithFormat:@"authorMapper=%@",authorMapper];
    }
    [self sendMessageToPad];
}

-(void)getAuthorName:(NSString *)authorID{
    self.message = @"getAuthorName";
    self.messageParameters = [NSString stringWithFormat:@"authorID=%@",authorID];
    [self sendMessageToPad];
}

#pragma mark Session

-(void)createSession:(NSString *)groupID authorID:(NSString *)authorID validUntil:(long)validUntil{
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

-(void)getText:(NSString *)padID rev:(NSString *)rev{
    self.message = @"getText";
    if (rev != nil) {
        self.messageParameters = [NSString stringWithFormat:@"padID=%@&rev=%@",padID,rev];
    }
    else{
        self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    }
    [self sendMessageToPad];
}

-(void)setText:(NSString*)padID text:(NSString*)text{
    self.message = @"setText";
    if (text != nil) {
        self.messageParameters = [NSString stringWithFormat:@"padID=%@&text=%@",padID,text];
    }
    else{
        self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    }
    [self sendMessageToPad];
}

-(void)getHTML:(NSString*)padID rev:(NSString*)rev{
    self.message = @"getHTML";
    if (rev != nil) {
        self.messageParameters = [NSString stringWithFormat:@"padID=%@&rev=%@",padID,rev];
    }
    else{
        self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    }
    [self sendMessageToPad];
}

-(void)setHTML:(NSString *)padID html:(NSString *)html{
    self.message = @"setHTML";
    self.messageParameters = [NSString stringWithFormat:@"padID=%@&html=%@",padID,html];
    [self sendMessageToPad];
}

#pragma mark Chat

-(void)getChatHistory:(NSString *)padID start:(NSString *)start end:(NSString *)end{
    self.message = @"getChatHistory";
    if (start != nil && end != nil) {
        self.messageParameters = [NSString stringWithFormat:@"padID=%@&start=%@&end=%@",padID,start,end];
    }
    else{
        self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    }
    [self sendMessageToPad];
}

-(void)getChatHead:(NSString *)padID{
    self.message = @"getChatHead";
    self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    [self sendMessageToPad];
}

#pragma mark Pad

-(void)createPad:(NSString *)padID text:(NSString *)text{
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

-(void)padUsers:(NSString *)padID{
    self.message = @"padUsers";
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

-(void)setPublicStatus:(NSString*)padID publicStatus:(BOOL)publicStatus{
    self.message = @"setPublicStatus";
    NSString* publicS;
    if (publicStatus) {
        publicS = @"true";
    }
    else{
        publicS = @"false";
    }
    self.messageParameters = [NSString stringWithFormat:@"padID=%@&publicStatus=%@",padID,publicS];
    [self sendMessageToPad];
}

-(void)getPublicStatus:(NSString *)padID{
    self.message = @"getPublicStatus";
    self.messageParameters = [NSString stringWithFormat:@"padID=%@",padID];
    [self sendMessageToPad];
}

-(void)setPassword:(NSString *)padID password:(NSString *)password{
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

-(void)sendClientsMessage:(NSString *)padID msg:(NSString *)msg{
    self.message = @"sendClientsMessage";
    self.messageParameters = [NSString stringWithFormat:@"padID=%@&msg=%@",padID,msg];
    [self sendMessageToPad];
}

-(void)checkToken{
    self.message = @"checkToken";
    self.messageParameters = nil;
    [self sendMessageToPad];
}

#pragma mark Pads

-(void)listAllPads{
    self.message = @"listAllPads";
    self.messageParameters = nil;
    [self sendMessageToPad];
}


#pragma mark helper methods

-(void)sendMessageToPad{
    [self.etherNetworkController sendMessage:self.message ToHost:self.host apiVersion:self.apiVersion apiKey:self.apiKey messageParameters:self.messageParameters];
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
    NSError* error;
    NSDictionary* jsonData = [EtherJsonController objectWithData:self.responseData error:&error];
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
    }
    return jsonData;
}

-(NSData*)getPrettyPrintedJson:(id)jsonDataObject{
    NSError* error;
    jsonDataObject = self.etherJsonParser;
    NSData* data = [EtherJsonController dataWithObject:jsonDataObject error:&error];
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
    }
    return data;
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

@end
