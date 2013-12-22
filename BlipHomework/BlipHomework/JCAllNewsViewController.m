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
#import "Reachability.h"
#import "JCWebViewController.h"
#import "NSDate+Extras.h"

#define URL @"http://betting.betfair.com/index.xml"
#define HOST @"http://betting.betfair.com"

#define TEST @"http://feeds.bbci.co.uk/news/rss.xml"


@interface JCAllNewsViewController ()

@end

@implementation JCAllNewsViewController

@synthesize newsDataModel, managedObjectContext;

// ivar to check is user was already notified
BOOL wasNotified = NO;


#pragma mark - inits

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        self.newsDataModel = [[JCNewsDataModel alloc] init];
    }
    return self;
}


#pragma mark - View-related methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNews];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)viewWillAppear:(BOOL)animated
{
    if(wasNotified == NO)
    {
        wasNotified = YES;
        hostReachable = [Reachability reachabilityWithHostname:HOST];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(checkConnection:)
                                                        name:kReachabilityChangedNotification
                                                        object:nil];
        [hostReachable startNotifier];
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Instance methods

-(void)checkConnection:(NSNotification *)notification
{
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    
    if(hostStatus == NotReachable)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error!"
                                                            message:@"Can't connect to host!"
                                                            delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                            otherButtonTitles:@"Report", nil];
        [alertView show];
    }
}


/**
 * setting up data for this table view controller
 */
-(void)setupNews
{
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
             news.link = [@"http:" stringByAppendingString:[[element child:@"link"] text]];
             
             [self.newsDataModel.allNews addObject:news];
             [self.newsDataModel sortNewsByDate];
         }
         [self.tableView reloadData];
     }];
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


-(NSString *)setupTitleFrom:(JCNewsItem *)newsItem
{
    BOOL isSameDay = [NSDate isSameDayDate1:[[NSDate alloc] init] comparedWithDate2:newsItem.datePublished];
    BOOL isYesterday = [NSDate isYesterdayDate1:[[NSDate alloc] init] comparedWithDate2:newsItem.datePublished];
    NSString *timeString = [NSDate getHoursAndMinutesFromDate:newsItem.datePublished withDateFormat:@"EE, d LLLL yyyy HH:mm:ss Z"];
    
    if(isSameDay)
    {
        return [@"Today, " stringByAppendingString:timeString] ;
    }
    else if(isYesterday)
    {
        return [@"Yesterday, " stringByAppendingString:timeString];
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/YY HH:mm"];
        return  [dateFormatter stringFromDate:newsItem.datePublished];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsDataModel.allNews count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    JCNewsItem *newsItem = [self.newsDataModel.allNews objectAtIndex: indexPath.row];
    
    // setting up the cells labels
    [self configureCell:cell withNewsItem:newsItem];
    
    return cell;
}


#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"WebPush"])
    {
        JCWebViewController *webViewController = segue.destinationViewController;
        
        // passing the managedObjectContext
        webViewController.managedObjectContext = self.managedObjectContext;
        
        // passing the newsItem correspoding to the tapped row
        NSIndexPath *indexPath =[self.tableView indexPathForCell:sender];
        JCNewsItem *newsItem = [self.newsDataModel.allNews objectAtIndex:indexPath.row];
        webViewController.newsItem = newsItem;
        webViewController.title = [self setupTitleFrom:newsItem];
    }
}


#pragma mark - AlertView delegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != [alertView cancelButtonIndex])
    {
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate = self;
        [mailComposeViewController setToRecipients:[NSArray arrayWithObject:@"jpmavcarreira@gmail.com"]];
        [mailComposeViewController setSubject:@"Can't connect to Betfair!"];
        NSString *msg = @"App is not working!";
        [mailComposeViewController setMessageBody:msg isHTML:NO];
        [self presentModalViewController:mailComposeViewController animated:YES];
    }
}


#pragma mark - MailComposer delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *messageToDisplay;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            messageToDisplay = @"You cancelled the operation";
            break;
        case MFMailComposeResultSaved:
            messageToDisplay = @"Mail saved in your drafts folder.";
            break;
        case MFMailComposeResultSent:
            messageToDisplay = @"Mail sent";
            break;
        case MFMailComposeResultFailed:
            messageToDisplay = @"Mail failed!";
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reporting problem"
                                                        message:messageToDisplay
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
    
    [alertView show];
    
    [self dismissModalViewControllerAnimated:YES];
}


@end
