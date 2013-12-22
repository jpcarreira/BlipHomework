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
    NSFetchedResultsController *fetchedResultsController;
}

@end


@implementation JCSavedNewsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self performFetch];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)dealloc
{
    fetchedResultsController.delegate = nil;
}


#pragma mark - Instance methods

-(void)performFetch
{
    NSError *error;
    if(![self.fetchedResultsController performFetch:&error])
    {
        abort();
    }
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


-(NSFetchedResultsController *)fetchedResultsController
{
    // lazy loading NSFetchedResultsController
    if(fetchedResultsController == nil)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"NewsItem" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"datePublished" ascending:NO];
        [fetchRequest setFetchBatchSize:20];
        [fetchRequest setSortDescriptors: [NSArray arrayWithObject:sortDescriptor]];
        
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:self.managedObjectContext
                                                                         sectionNameKeyPath:nil
                                                                                  cacheName:@"SavedNews"];
        fetchedResultsController.delegate = self;
    }
    return fetchedResultsController;
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
        newsItem.title = [[self.fetchedResultsController objectAtIndexPath:indexPath] title];
        newsItem.link = [[self.fetchedResultsController objectAtIndexPath:indexPath] link];
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
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SavedNewsCell"];
    //[self configureCell:cell withSavedNewsItem:[savedNews objectAtIndex:indexPath.row]];
    [self configureCell:cell withSavedNewsItem:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    return cell;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // swipe to delete
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        // getting the object from the index path and deleting it from the data store
        JCNewsItemCD *newsItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        [self.managedObjectContext deleteObject:newsItem];
        
        // dealing with errors
        NSError *error;
        if(![self.managedObjectContext save:&error])
        {
            abort();
        }
    }
}


#pragma mark - NSFetchedResultsController delegate

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    //NSLog(@"Controller will change content");
    [self.tableView beginUpdates];
}


-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            //NSLog(@"Controller did change object: NSFetchedResultsChangeInsert");
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            //NSLog(@"Controller did change object: NSFetchedResultsChangeDelete");
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //NSLog(@"Controller did change object: NSFetchedResultsChangeUpdate");
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] withSavedNewsItem:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            break;
            
        case NSFetchedResultsChangeMove:
            //NSLog(@"Controller did change object: NSFetchedResultsChangeMove");
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            //NSLog(@"Controller did change section: NSFetchedResultsChangeInsert");
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            //NSLog(@"Controller did change section: NSFetchedResultsChangeDelete");
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //NSLog(@"Controller did change content");
    [self.tableView endUpdates];
}


@end
