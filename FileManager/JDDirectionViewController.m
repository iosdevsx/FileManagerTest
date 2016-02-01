//
//  JDDirectionViewController.m
//  FileManager
//
//  Created by jsd on 28.12.15.
//  Copyright © 2015 jsd. All rights reserved.
//

#import "JDDirectionViewController.h"
#import "JDFileCell.h"
#import "JDFolderCell.h"
#import "JDCellHelper.h"

@interface JDDirectionViewController()

@property (strong, nonatomic) NSString* path;
@property (strong, nonatomic) NSArray* contents;

@end

@implementation JDDirectionViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler)];
    tapGesture.numberOfTapsRequired = 1;
    self.navigationTitle.userInteractionEnabled = YES;
    [self.navigationTitle addGestureRecognizer:tapGesture];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.path)
    {
        self.path = @"/";
    }
    [self orderContentsArray];
}

- (void) setPath:(NSString *)path
{
    _path = path;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    self.contents = [self deleteAllHiddenFilesFromArray:[fileManager contentsOfDirectoryAtPath:self.path error:nil]];
    self.navigationTitle.text = [self.path lastPathComponent];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -Gestures
- (void) tapGestureHandler
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Add Folder" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Type new folder name here...";
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                               {
                                   NSString* newFolderName = alertController.textFields.firstObject.text;
                                   [self createNewFolderWithName:newFolderName];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -Private Methods

- (BOOL) isDirectoryForPath: (NSIndexPath*) indexPath
{
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:[self getStringPathForIndexPath:indexPath]
                                         isDirectory:&isDirectory];
    return isDirectory;
}

- (NSString*)getStringPathForIndexPath: (NSIndexPath*)indexPath
{
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
    return filePath;
}

- (void) createNewFolderWithName: (NSString*) folderName
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* folderPath = [self.path stringByAppendingPathComponent:folderName];
    NSMutableArray* tempContents = nil;
    NSInteger index = 0;
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    if (self.contents)
    {
        tempContents = [NSMutableArray arrayWithArray:self.contents];
    } else
    {
        tempContents = [NSMutableArray array];
    }
    if ([fileManager fileExistsAtPath:folderPath])
    {
        [self showModalWithMessage:@"Folder already exists"];
    } else
    {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
        [tempContents insertObject:folderName atIndex:index];
        self.contents = [NSArray arrayWithArray:tempContents];
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
}

- (void) orderContentsArray
 {
     NSMutableArray* contents = [NSMutableArray array];
     if (self.contents)
     {
         contents = [NSMutableArray arrayWithArray:self.contents];
         NSMutableArray* folders = [NSMutableArray array];
         NSMutableArray* files = [NSMutableArray array];
         
         for (NSString* item in contents)
         {
             BOOL isDir = NO;
             [[NSFileManager defaultManager] fileExistsAtPath:[self.path stringByAppendingPathComponent:item] isDirectory:&isDir];
             
             if (isDir)
             {
                 [folders addObject:item];
             } else
             {
                 [files addObject:item];
             }
         }
             
         contents = [NSMutableArray arrayWithArray:folders];
         [contents addObjectsFromArray:files];
         self.contents = contents;
     }
 }

- (NSArray*) deleteAllHiddenFilesFromArray:(NSArray*) array
{
    NSMutableArray* tempArray = [NSMutableArray array];
    for (NSString* item in array)
    {
        if (![item hasPrefix:@"."])
        {
            [tempArray addObject:item];
        }
    }
    
    return [NSArray arrayWithArray:tempArray];
}

- (void) showModalWithMessage: (NSString*) message
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Attention!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -Actions

- (IBAction)actionHomeButton:(UIButton*) sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionEditButton:(UIButton *) sender
{
    BOOL isEditing = self.tableView.isEditing;
    [self.tableView setEditing:!isEditing animated:YES];
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self isDirectoryForPath:indexPath])
    {
        NSString* fileName = [self.contents objectAtIndex:indexPath.row];
        NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
        
        UIStoryboard* storyboard = self.storyboard;
        JDDirectionViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"JDDirectionViewController"];
        //JDDirectionViewController* viewController = [[JDDirectionViewController alloc] init];
        viewController.path = filePath;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* fileIdentifier = @"FileCell";
    static NSString* folderIdentifier = @"FolderCell";
    
    NSString* name = [self.contents objectAtIndex:indexPath.row];
    NSString* path = [self.path stringByAppendingPathComponent:name];
    NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                error:nil];
    if ([self isDirectoryForPath:indexPath])
    {
        JDFolderCell* cell = [tableView dequeueReusableCellWithIdentifier:folderIdentifier];
        cell.folderNameLabel.text = name;
        cell.folderSizeLabel.text = [JDCellHelper getFolderSizeForPath:path];
        return cell;
    } else
    {
        JDFileCell* cell = [tableView dequeueReusableCellWithIdentifier:fileIdentifier];
        cell.fileNamelabel.text = name;
        cell.fileSizeLabel.text = [JDCellHelper getFormattedStringForSize:[attributes fileSize]];
        cell.fileDateModifiedLabel.text = [JDCellHelper getFormattedDateFor:[attributes fileModificationDate]];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableArray* contents = [NSMutableArray arrayWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path
                                                                                                                      error:nil]];
        NSString* folder = [contents objectAtIndex:indexPath.row];
        NSString* path = [self.path stringByAppendingPathComponent:folder];
        
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        [contents removeObject:folder];
        
        self.contents = [NSArray arrayWithArray:contents];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [tableView endUpdates];
    }
}


@end
