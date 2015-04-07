//
//  WaypointTableViewController.m
//  Lab10_jsonrpc
//
//  Created by biespana on 4/6/15.
//  @author: Brandon Espana mailto:biespana@asu.edu
//  @Version: March 30, 2015
//  Copyright (c) 2015 Brandon Espana.
//  The professor and TA have the right to build and evaluate this software package

#import "WaypointTableViewController.h"
#import "ServerProxy.h"
#import "ViewController.h"

@interface WaypointTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *waypointTableView;
@property (strong, nonatomic) NSArray* waypointNames;

@end

@implementation WaypointTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.waypointTableView.delegate = self;
    self.waypointTableView.dataSource = self;
    
    //call server using proxy to get the list of  names
    ServerProxy* proxy = [[ServerProxy alloc]initWithTarget: self action:@selector(receiveResult:)];
    [proxy getNames];
}


-(void)receiveResult: (id)result{
    self.waypointNames = result;
    [self.waypointTableView reloadData];
    NSLog(@"Received something");
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.waypointNames count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"waypointCell" forIndexPath:indexPath];
    NSString* waypointName = [self.waypointNames objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.textLabel.text = waypointName;
    return cell;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailWaypointSegue"]){
        
        NSIndexPath* indexPath = [self.waypointTableView indexPathForSelectedRow];
        NSLog(@"Will send this to the detail: %@",[self.waypointNames objectAtIndex:indexPath.row]);
        ViewController* theDestination = (ViewController*)[segue destinationViewController];
        theDestination.waypointName = [self.waypointNames objectAtIndex:indexPath.row];
        theDestination.parent = self;
        NSLog(@"SEt the name now");
        
    }
}


@end
