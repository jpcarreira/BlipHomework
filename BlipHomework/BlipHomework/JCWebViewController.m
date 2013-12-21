//
//  JCWebViewController.m
//  BlipHomework
//
//  Created by João Carreira on 20/12/13.
//  Copyright (c) 2013 João Carreira. All rights reserved.
//

#import "JCWebViewController.h"
#import "JCNewsItem.h"

@interface JCWebViewController ()

@end

@implementation JCWebViewController


@synthesize webView, newsItem;


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
    NSString *link = [@"http:" stringByAppendingString:newsItem.link];
    NSURL *url = [NSURL URLWithString: link];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:@"about:blank"]]];
}

@end
