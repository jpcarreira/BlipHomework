//
//  JCAllNewsViewController.m
//  BlipHomework
//
//  Created by João Carreira on 20/12/13.
//  Copyright (c) 2013 João Carreira. All rights reserved.
//

#import "JCAllNewsViewController.h"
#import "RXMLElement.h"
#import "JCDownloadManager.h"
#import "JCNewsItem.h"

#define URL @"http://betting.betfair.com/index.xml"

@interface JCAllNewsViewController ()

@end

@implementation JCAllNewsViewController

// ivar to save all news downloaded from URL
NSMutableArray *allNews;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNews];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


/**
 * setting up data for this table view controller
 */
-(void)setupNews
{
    allNews = [[NSMutableArray alloc] initWithCapacity:1];
    
    // block to download data from the RSS feeder URL
    [JCDownloadManager downloadData:URL withCompletionBlock:^(NSData *result)
     {
         RXMLElement *xml = [RXMLElement elementFromXMLData:result];
        
         NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
         [dateFormater setDateFormat:@"EE, d LLLL yyyy HH:mm:ss Z"];
         
         NSArray *items = [[xml child:@"channel"] children:@"item"];
         
         for(RXMLElement *element in items)
         {
             JCNewsItem *news = [[JCNewsItem alloc] init];
             news.title = [[element child:@"title"] text];
             news.description = [[element child:@"description"] text];
             news.datePublished = [dateFormater dateFromString: [[element child:@"pubDate"] text]];
             news.link = [[element child:@"link"] text];
             
             [allNews addObject:news];
         }
         [self.tableView reloadData];
     }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allNews count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    JCNewsItem *newsItem = [allNews objectAtIndex: indexPath.row];
    
    // setting up the cells labels
    [self configureCell:cell withNewsItem:newsItem];
    
    return cell;
}


-(void)configureCell:(UITableViewCell *)cell withNewsItem:(JCNewsItem *)newsItem
{
    UILabel *textLabel = (UILabel *)[cell viewWithTag:1000];
    UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:1001];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:1002];
    
     NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"dd/MM/YY HH:mm"];
    
    textLabel.text = newsItem.title;
    descriptionLabel.text = newsItem.description;
    dateLabel.text = [dateFormater stringFromDate:newsItem.datePublished];
}

@end
