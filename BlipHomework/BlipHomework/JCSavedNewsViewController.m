//
//  JCSavedNewsViewController.m
//  BlipHomework
//
//  Created by João Carreira on 21/12/13.
//  Copyright (c) 2013 João Carreira. All rights reserved.
//

#import "JCSavedNewsViewController.h"
#import "JCNewsItemCD.h"
#import "JCWebViewController.h"
#import "JCNewsItem.h"

@interface JCSavedNewsViewController ()
{
    NSArray *savedNews;
}

@end

@implementation JCSavedNewsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSavedNews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Instance methods

-(void)setupSavedNews
{
    // fetch request for saved news
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NewsItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // sorting by date
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"datePublished" ascending:NO];
    [fetchRequest setSortDescriptors: [NSArray arrayWithObject:sortDescriptor]];

    NSError *error;
    NSArray *foundNews = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(foundNews == nil)
    {
        abort();
    }
    
    // storing all found news in the ivar
    savedNews = foundNews;
}


-(void)configureCell:(UITableViewCell *)cell withSavedNewsItem:(JCNewsItemCD *)savedNewsItem
{
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:2000];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:2001];
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"dd/MM/YY HH:mm"];
    
    titleLabel.text = savedNewsItem.title;
    dateLabel.text = savedNewsItem.datePublished;
}


#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"WebPush"])
    {
        JCWebViewController *webViewController = segue.destinationViewController;
        
        // passing the newsItem correspoding to the tapped row
        NSIndexPath *indexPath =[self.tableView indexPathForCell:sender];
        JCNewsItem *newsItem = [[JCNewsItem alloc] init];
        newsItem.title = [[savedNews objectAtIndex:indexPath.row] title];
        newsItem.link = [[savedNews objectAtIndex:indexPath.row] link];
        webViewController.newsItem = newsItem;
        [webViewController.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [savedNews count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SavedNewsCell"];
    [self configureCell:cell withSavedNewsItem:[savedNews objectAtIndex:indexPath.row]];
    
    return cell;
}

@end
