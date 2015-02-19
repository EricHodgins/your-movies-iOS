//
//  UsersTableViewController.m
//  Your Movie Reader
//
//  Created by Eric Hodgins on 2015-02-12.
//  Copyright (c) 2015 Eric Hodgins. All rights reserved.
//

#import "UsersTableViewController.h"
#import "YourMoviesTableViewController.h"

@interface UsersTableViewController ()

@property(strong, nonatomic) NSMutableDictionary *jsonDict;

@end

@implementation UsersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Your-Movies";

    self.usersArray = [NSMutableArray array];
    [self refreshData];
}


- (void)refreshData {
    NSURL *movieURL = [NSURL URLWithString:@"http://your-movies.appspot.com/.json"];
    NSData *jsonData = [NSData dataWithContentsOfURL:movieURL];
    NSLog(@"JSON data: %@", jsonData);
    
    if (jsonData) {
        
        NSError *error = nil;
        
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        NSLog(@"json as Dict: %@", dataDictionary);
        
        
        
        for (NSDictionary *movieDict in dataDictionary) {
            NSLog(@"%@", [movieDict objectForKey:@"username"]);
            [self.usersArray addObject:[movieDict objectForKey:@"username"]];
        }
        
        self.jsonDict = [[NSMutableDictionary alloc] init];
        for (NSDictionary *users in dataDictionary) {
            [self.jsonDict setValue:[users objectForKey:@"movies"] forKey:[users objectForKey:@"username"]];
        }
        
        [self.tableView reloadData];
        
        NSLog(@"THE DICT: %@", self.jsonDict);
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Site Down" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)refreshButton:(id)sender {
    
    [self refreshData];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.usersArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.usersArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier isEqualToString:@"showUserMovies"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *username = [self.usersArray objectAtIndex:indexPath.row];
        YourMoviesTableViewController *yourMovies = (YourMoviesTableViewController *)segue.destinationViewController;
        yourMovies.userMovies = [self.jsonDict valueForKey:username];
    }
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



@end
