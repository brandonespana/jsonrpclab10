//
//  ViewController.h
//  Lab10_jsonrpc
//
//  Created by biespana on 4/6/15.
//  @author: Brandon Espana mailto:biespana@asu.edu
//  @Version: March 30, 2015
//  Copyright (c) 2015 Brandon Espana.
//  The professor and TA have the right to build and evaluate this software package
#import <UIKit/UIKit.h>
#import "WaypointTableViewController.h"
@interface ViewController : UIViewController

@property(strong,nonatomic)NSString* waypointName;
@property(strong,nonatomic)WaypointTableViewController* parent;

@end

