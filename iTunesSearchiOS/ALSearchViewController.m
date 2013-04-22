//
//  ALSearchViewController.m
//  iTunesSearchiOS
//
//  Created by Andrew Little on 2013-04-21.
//  Copyright (c) 2013 Andrew Little. All rights reserved.
//

#import "ALSearchViewController.h"
#import "ALMusicTrack.h"
#import "ALAlbum.h"

@interface ALSearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *mediaSearchResults;
@property (weak, nonatomic) IBOutlet UITextField *searchTermField;
@property (strong, nonatomic) RKResponseDescriptor *responseDescriptor;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filterSearchControl;

typedef enum FilterState : NSInteger FilterState;
enum FilterState : NSInteger {

    FilterStateAlbum = 0,
    FilterStateSong = 1
    
};


@end

@implementation ALSearchViewController



- (IBAction)onSearchTermChanged:(id)sender {

    NSString *filterTerm = [self filterStringForIndex:self.filterSearchControl.selectedSegmentIndex];
    [self calliTunesSearchAPIWithSearchTerm:self.searchTermField.text andFilter:filterTerm];
}


- (IBAction)onFilterChanged:(id)sender {
    
    [self setupResponseDescriptorForFilter:self.filterSearchControl.selectedSegmentIndex];
    
    //rerun the iTunes sear
    NSString *filterTerm = [self filterStringForIndex:self.filterSearchControl.selectedSegmentIndex];
    [self calliTunesSearchAPIWithSearchTerm:self.searchTermField.text andFilter:filterTerm];
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
    [self setupResponseDescriptorForFilter:self.filterSearchControl.selectedSegmentIndex];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (self.filterSearchControl.selectedSegmentIndex == FilterStateAlbum){

        ALAlbum *album = (ALAlbum *)[self.mediaSearchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = album.albumName;
        cell.detailTextLabel.text = @"Album";
    }
    else {
        ALMusicTrack *track = (ALMusicTrack *)[self.mediaSearchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = track.trackName;
        cell.detailTextLabel.text = @"Song";
    }
    
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

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self.searchTermField resignFirstResponder];
}

#pragma mark Filter Search Control

-(NSString *)filterStringForIndex:(NSInteger)filterIndex {
    
    if (filterIndex == FilterStateSong)
        return @"musicTrack";
    else
        return @"album";
}

#pragma mark iTunes Search Handling

-(void)setupResponseDescriptorForFilter:(FilterState)filterIndex {
    
    NSDictionary *mappingDictionary;
    Class mappingClass;
    
    if (filterIndex == FilterStateAlbum) {
        mappingDictionary = @{
                              @"artistId": @"artistId",
                              @"artistName": @"artistName",
                              @"collectionName": @"albumName" };
        mappingClass = [ALAlbum class];
    }
    else {
        mappingDictionary = @{
                              @"artistId": @"artistId",
                              @"artistName": @"artistName",
                              @"trackName": @"trackName" };
         mappingClass = [ALMusicTrack class];
    }
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:mappingClass];
    [mapping addAttributeMappingsFromDictionary:mappingDictionary];
    
    self.responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:nil keyPath:@"results" statusCodes:nil];
}

-(NSURL *)createURLForCallWithSearchTerm:(NSString *)searchTerm andFilter:(NSString *)filterTerm {
    
    NSString *urlAsString = [NSString stringWithFormat:@"https://itunes.apple.com/search?entity=%@&limit=25&term=%@", filterTerm,
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

-(void)calliTunesSearchAPIWithSearchTerm:(NSString *)searchTerm andFilter:(NSString *)filterTerm {

    //Let's get this on a background thread. Thanks, GCD.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[self createURLForCallWithSearchTerm:searchTerm andFilter:filterTerm]];
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
