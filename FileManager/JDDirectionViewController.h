//
//  JDDirectionViewController.h
//  FileManager
//
//  Created by jsd on 28.12.15.
//  Copyright © 2015 jsd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDDirectionViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *navigationTitle;

- (IBAction)actionHomeButton:(UIButton *)sender;
- (IBAction)actionEditButton:(UIButton *)sender;

@end
