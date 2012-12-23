//
//  EtherAPIController.h
//  etherpad-lite-objc
//
//  Copyright (c) 2012 Alexander Zautke.
//  This code is released under the MIT License (MIT).
//  For conditions of distribution and use, see the disclaimer and license in EtherpadController.h
//

#import <Foundation/Foundation.h>
#import "EtherJsonController.h"
#import "EtherNetworkController.h"

@interface EtherAPIController : NSObject

@property id delegate;
@property NSString* host;
@property NSString* apiKey;

//Groups
-(void)createGroup; // creates a new group
-(void)createGroupIfNotExistsFor:(NSString*)groupMapper; // this functions helps you to map your application group ids to etherpad lite group ids
-(void)deleteGroup:(NSString*)groupID; // deletes a group
-(void)listPads:(NSString*)groupID; // returns all pads of this group
-(void)createGroupPad:(NSString*)groupID padName:(NSString*)padName text:(NSString*)text; // creates a new pad in this group
-(void)listAllGroups;//Test

//Author
-(void)createAuthor:(NSString*)name; // creates a new author
-(void)createAuthorIfNotExistsFor:(NSString*)authorMapper name:(NSString*)name; // this functions helps you to map your application author ids to etherpad lite author ids
-(void)listPadsOfAuthor:(NSString*)authorID; // returns an array of all pads this author contributed to
-(void)getAuthorName:(NSString*)authorID;//Test

//Session
-(void)createSession:(NSString*)groupID authorID:(NSString*)authorID validUntil:(long)validUntil; // creates a new session. validUntil is an unix timestamp in seconds
-(void)deleteSession:(NSString*)sessionID; // deletes a session
-(void)getSessionInfo:(NSString*)sessionID; // returns informations about a session
-(void)listSessionsOfGroup:(NSString*)groupID; // returns all sessions of a group
-(void)listSessionsOfAuthor:(NSString*)authorID; // returns all sessions of an author

//Pad Content
-(void)getText:(NSString*)padID rev:(NSString*)rev; // returns the text of a pad
-(void)setText:(NSString*)padID text:(NSString*)text; // sets the text of a pad
-(void)getHTML:(NSString*)padID rev:(NSString*)rev; // returns the text of a pad formatted as HTML

//Pad
-(void)createPad:(NSString*)padID text:(NSString*)text; // creates a new (non-group) pad. Note that if you need to create a group Pad, you should call createGroupPad.
-(void)getRevisionsCount:(NSString*)padID; // returns the number of revisions of this pad
-(void)padUsersCount:(NSString*)padID; // returns the number of user that are currently editing this pad
-(void)padUsers:(NSString*)padID;//Test
-(void)deletePad:(NSString*)padID; // deletes a pad
-(void)getReadOnlyID:(NSString*)padID; // returns the read only link of a pad
-(void)setPublicStatus:(NSString*)padID publicStatus:(BOOL)publicStatus; // sets a boolean for the public status of a pad
-(void)getPublicStatus:(NSString*)padID; // return true of false
-(void)setPassword:(NSString*)padID password:(NSString*)password; // returns ok or a error message
-(void)isPasswordProtected:(NSString*)padID; // returns true or false
-(void)listAuthorsOfPad:(NSString*)padID; // returns an array of authors who contributed to this pad
-(void)getLastEdited:(NSString*)padID; // returns the timestamp of the last revision of the pad
//sendClientsMessage

-(NSData*)getJSON; // returns raw JSON data

@end

@protocol EtherAPIDelegate
-(void)requestDidFinish:(NSDictionary*)responseDictionary; //responseDictionary contains the parsed JSON-Response (message,data,code) / method gets called after each successful API request
-(void)requestDidFailWithError:(NSError*)error; // reports any errors to the delegate
@end
