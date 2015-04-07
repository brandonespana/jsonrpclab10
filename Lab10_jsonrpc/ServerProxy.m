//
//  ServerProxy.m
//  Lab10_jsonrpc
//
//  Created by biespana on 4/6/15.
//  @author: Brandon Espana mailto:biespana@asu.edu
//  @Version: March 30, 2015
//  Copyright (c) 2015 Brandon Espana.
//  The professor and TA have the right to build and evaluate this software package

#import "ServerProxy.h"
static int iden = 1;
@interface ServerProxy()

@property (unsafe_unretained, atomic) SEL action;
@property (strong, atomic) id target;
@property (strong, atomic) NSMutableData * receivedData;
@property (strong, nonatomic) NSString * urlString;

@end

@implementation ServerProxy
- (id) initWithTarget: (id) target action: (SEL) action{
    if( self = [super init] ){
        self.target = target;
        self.action = action;
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Server_URL" ofType:@"plist"];
        NSDictionary * serverDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        self.urlString = [serverDictionary objectForKey:@"server_url"];
        //NSLog(@"server url in plist is: %@",[serverDictionary objectForKey:@"server_url"]);
    }
    return self;
}

-(void) getNames{
    //NSArray* names = [[NSArray]]
     NSArray * params = @[];
    [self dispatchCall:@"getNames" withParms:params];
    
}
-(void)getWPnamed:(NSString *)wpName{
    NSArray* params = @[wpName];
    [self dispatchCall:@"get" withParms:params];
}

-(void)removeWaypoint:(NSString *)wpName{
    NSArray* params = @[wpName];
    [self dispatchCall:@"remove" withParms:params];
}

- (BOOL) dispatchCall: (NSString*) method withParms: (NSArray*) parms{
    BOOL ret = NO;
    NSNumber * ID = [NSNumber numberWithInt:iden++];
    NSDictionary * rpcDict = @{@"jsonrpc":@"2.0",  @"method":method, @"params":parms, @"id":ID};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rpcDict
                        //options:NSJSONWritingPrettyPrinted
                                                       options:0
                                                         error:&error];
    NSLog(@"jsonData: %@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    self.receivedData = [NSMutableData data];
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if(request){
        request.URL = url;
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        request.HTTPBody= jsonData;
        ret = YES;
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        [connection start];
    }
    return ret;
}

// NSURLConnectionDelegate and NSURLConnectionDataDelegate methods.

// May be called multiple times, such as a redirect, so reset the data.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"connection: didReceiveResponse");
}

//   Append the new data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"connection: didReceiveData:");
    if(data){
        //NSLog(@"in didReceiveData and got %lu bytes: ",(unsigned long)data.length);
        [self.receivedData appendData:data];
    }else{
        NSLog(@"in didReceiveData, but data is nil");
    }
}

// Connection has completed. De-serialize to nsdictionary and pick out result value.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSError *error;
    NSDictionary *myDictionary = @{@"result":@"no return value"};
    if(self.receivedData==nil){
        NSLog(@"connectionDidFinishLoading with No data received");
    } else {
        NSLog(@"receivedData: %@",[[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding]);
        myDictionary = [NSJSONSerialization
                        JSONObjectWithData:self.receivedData
                        options:NSJSONReadingMutableContainers
                        error:&error];
    }
    id result = [myDictionary objectForKey:@"result"];
//    double res = 0;
//    if([result class]==[@2.2 class]){
//        res = [[myDictionary objectForKey:@"result"] doubleValue];
//    }
    //NSData* connectionData = connection.request.HTTPBody
    //call the method in the controller who will perform the ui update.
    
    NSURLRequest* request = connection.currentRequest;
    NSData *data = [request HTTPBody];
    
    NSDictionary* requestDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSString* theMethodCalled = [requestDictionary objectForKey:@"method"];
    NSLog(@"Called this method: %@",theMethodCalled);
    
    
    
    [self.target performSelector:self.action withObject:result];
    connection = nil;
    self.receivedData = nil;
}

@end
