//
//  ServerProxy.h
//  Lab10_JSONrpc
//
//  Created by biespana on 4/6/15.
//  @author: Brandon Espana mailto:biespana@asu.edu
//  @Version: March 30, 2015
//  Copyright (c) 2015 Brandon Espana.
//  The professor and TA have the right to build and evaluate this software package
#import <Foundation/Foundation.h>

@interface ServerProxy : NSObject

-(id) initWithTarget: (id)target action: (SEL) action;
-(void) getNames;
-(void) getWPnamed: (NSString*) wpName;
-(void) removeWaypoint: (NSString*) wpName;


@end
