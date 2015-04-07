//
//  ViewController.m
//  Lab10_jsonrpc
//
//  Created by biespana on 4/6/15.
//  @author: Brandon Espana mailto:biespana@asu.edu
//  @Version: March 30, 2015
//  Copyright (c) 2015 Brandon Espana.
//  The professor and TA have the right to build and evaluate this software package
#import "ViewController.h"
#import "ServerProxy.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *wpName;

@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *category;
@property (weak, nonatomic) IBOutlet UITextField *lat;
@property (weak, nonatomic) IBOutlet UITextField *lon;
@property (weak, nonatomic) IBOutlet UITextField *elevation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"From inside the controller the name is this: %@",self.waypointName);
    [self.wpName setText:self.waypointName];
    ServerProxy* proxy = [[ServerProxy alloc]initWithTarget:self action:@selector(loadTextFields:)];
    [proxy getWPnamed:self.waypointName];
    
//    [self.address setText:@"An Address"];
    
    
}

-(void)loadTextFields:(id)result{
    [self.address setText:[NSString stringWithFormat:@"%@",[result objectForKey:@"address"]]];
    [self.category setText:[NSString stringWithFormat:@"%@",[result objectForKey:@"category"]]];
    [self.lat setText:[NSString stringWithFormat:@"%@",[result objectForKey:@"lat"]]];
    [self.lon setText:[NSString stringWithFormat:@"%@",[result objectForKey:@"lon"]]];
    [self.elevation setText:[NSString stringWithFormat:@"%@",[result objectForKey:@"ele"]]];
}
- (IBAction)deleteWaypoint:(id)sender {
    ServerProxy* proxyToDelete = [[ServerProxy alloc]initWithTarget:self action:@selector(deletedWaypoint:)];
    [proxyToDelete removeWaypoint:self.wpName.text];
}

-(void)deletedWaypoint:(id)result{
    [self.navigationController popViewControllerAnimated:TRUE];
    ServerProxy* proxyToReload = [[ServerProxy alloc]initWithTarget:self.parent action:@selector(receiveResult:)];
    [proxyToReload getNames];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
