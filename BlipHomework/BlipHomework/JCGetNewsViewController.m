//
//  JCGetNewsViewController.m
//  BlipHomework
//
//  Created by João Carreira on 19/12/13.
//  Copyright (c) 2013 João Carreira. All rights reserved.
//

#import "JCGetNewsViewController.h"
#import "RXMLElement.h"

@interface JCGetNewsViewController ()

@end

@implementation JCGetNewsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // testing RaptureXML lib with betfair.xml
    RXMLElement *bootstrap = [RXMLElement elementFromXMLFile:@"betfair.xml"];
    
    [bootstrap iterate:@"channel.item" usingBlock: ^(RXMLElement *newsItem)
     {
         NSLog(@"Title: %@", [newsItem child:@"title"].text);
         NSLog(@"Description: %@", [newsItem child:@"description"].text);
         NSLog(@"Date: %@", [newsItem child:@"pubDate"].text);
         NSLog(@"Link: %@", [newsItem child:@"link"].text);
         NSLog(@"-------------------------------------------");
     }
     ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
