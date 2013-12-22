//
//  JCWebViewController.m
//  BlipHomework
//
//  Created by João Carreira on 20/12/13.
//  Copyright (c) 2013 João Carreira. All rights reserved.
//

#import "JCWebViewController.h"
#import "JCNewsItem.h"
#import "JCNewsItemCD.h"

@interface JCWebViewController ()

@end

@implementation JCWebViewController


@synthesize webView, newsItem, managedObjectContext;


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)viewWillAppear:(BOOL)animated
{
    NSURL *url = [NSURL URLWithString: newsItem.link];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:@"about:blank"]]];
}


-(IBAction)save:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YY HH:mm"];
    
    JCNewsItemCD *newsItemsCD = [NSEntityDescription insertNewObjectForEntityForName:@"NewsItem" inManagedObjectContext:self.managedObjectContext];
    newsItemsCD.title = newsItem.title;
    newsItemsCD.link = [@"http:" stringByAppendingString:newsItem.link];
    newsItemsCD.datePublished = [dateFormatter stringFromDate:newsItem.datePublished];
    
    NSError *error;
    if(![self.managedObjectContext save:&error])
    {
        abort();
    }
}

@end
