//
//  ALSearchViewController.m
//  iTunesSearchiOS
//
//  Created by Andrew Little on 2013-04-21.
//  Copyright (c) 2013 Andrew Little. All rights reserved.
//

#import "ALSearchViewController.h"
#import "ALMusicTrack.h"

@interface ALSearchViewController ()

@end

@implementation ALSearchViewController

- (IBAction)onSearchTermChanged:(id)sender {

    [self calliTunesSearchAPIWithSearchTerm:self.searchTermField.text];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mediaSearchResults = [[NSMutableArray alloc] init];
    [self setupResponseDescriptor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mediaSearchResults count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    ALMusicTrack *track = (ALMusicTrack *)[self.mediaSearchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = track.trackName;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark iTunes Search Handling

-(void)setupResponseDescriptor {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ALMusicTrack class]];
    [mapping addAttributeMappingsFromDictionary:@{
         @"artistId": @"artistId",
         @"artistName": @"artistName",
         @"trackName": @"trackName"
     }];
    
    self.responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:nil keyPath:@"results" statusCodes:nil];
}

-(NSURL *)createURLForCallWithSearchTerm:(NSString *)searchTerm {
    
    NSString *urlAsString = [NSString stringWithFormat:@"https://itunes.apple.com/search?entity=musicTrack&limit=5&term=%@",
                             [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlAsString];

    return url;
}

-(void)displayAlertForError:(NSError *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)calliTunesSearchAPIWithSearchTerm:(NSString *)searchTerm {

    //Let's get this on a background thread. Thanks, GCD.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[self createURLForCallWithSearchTerm:searchTerm]];
        RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[self.responseDescriptor]];
        [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
            
            [self.mediaSearchResults removeAllObjects];
            [self.mediaSearchResults addObjectsFromArray:[result array]];
            
            //About to update the UI, so jump back to the main/UI thread
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.tableView reloadData];
            });
            
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            
            //About to update the UI, so jump back to the main/UI thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self displayAlertForError:error];
            });
        }];
        [operation start];
    });
}



@end
