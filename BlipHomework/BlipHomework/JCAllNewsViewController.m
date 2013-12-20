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

#define URL @"http://betting.betfair.com/index.xml"

@interface JCAllNewsViewController ()

@end

@implementation JCAllNewsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNews];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 * setting up data for this table view controller
 */
-(void)setupNews
{
    [JCDownloadManager downloadData:URL withCompletionBlock:^(NSData *result)
     {
         RXMLElement *xml = [RXMLElement elementFromXMLData:result];
         
         [xml iterate:@"channel.item" usingBlock: ^(RXMLElement *newsItem)
          {
              NSLog(@"Title: %@", [newsItem child:@"title"].text);
              NSLog(@"Description: %@", [newsItem child:@"description"].text);
              NSLog(@"Date: %@", [newsItem child:@"pubDate"].text);
              NSLog(@"Link: %@", [newsItem child:@"link"].text);
              NSLog(@"-------------------------------------------");
          }
          ];
     }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
