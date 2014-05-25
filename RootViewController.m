//
//  RootViewController.m
//  FileBrowser
//
//  Created by Kobe Dai on 10/24/12.
//  Copyright (c) 2012 Kobe Dai. All rights reserved.
//
//＃i nclude<stdlib.h>
#include<stdlib.h>

#import "ZipArchive.h"
#import "RootViewController.h"
#import "FileViewController.h"

@interface AppInfo : NSObject
@property (nonatomic, retain) NSString *iconPath;
@property (nonatomic, retain) NSString *appName;
@property (nonatomic, retain) NSString *dspName;
@end
@implementation AppInfo
- (void)dealloc
{
    [super dealloc];
    self.iconPath = nil;
    self.appName  = nil;
    self.dspName  = nil;
}
@end



@interface RootViewController ()
{
    NSMutableArray *appInfoArray;
}
@property (nonatomic, retain) NSArray *contentsDirectory;
@property (nonatomic, retain) NSString *creationDate;
@property (nonatomic, retain) NSString *modificationDate;

@end




@implementation RootViewController

- (void)dealloc
{
    self.contentsDirectory = nil;
    self.creationDate    = nil;
    self.modificationDate= nil;
    [appInfoArray release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SEL act = nil;
    NSString *titile=nil;
    if (_isRoot) {
        act    = @selector(clearDocument);
        titile = [NSString stringWithFormat:@"[%@]清空",[self getZipNum]];
    }
    else
    {
        act = @selector(zipFolder);
        titile = @"压缩";
    }
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:titile style:0 target:self action:act];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    NSString *currentPath =  [self.fm currentDirectoryPath]; //@"/var/mobile/Applications/";//
    
    NSDictionary *currentDitionary = [self.fm attributesOfItemAtPath: currentPath error: nil];
    self.creationDate = [[currentDitionary valueForKey: NSFileCreationDate] description];
    self.modificationDate = [[currentDitionary valueForKey: NSFileModificationDate] description];
    
    
    self.contentsDirectory = [self.fm contentsOfDirectoryAtPath: currentPath error: nil];
    
    
    //root Applications Get!
    if (_isRoot) {
        appInfoArray = [[NSMutableArray alloc] init];
        for (NSString* item in self.contentsDirectory) {
            NSString *itemPath =   [currentPath stringByAppendingPathComponent:item];
            //search
            NSArray *itemsSub = [self.fm contentsOfDirectoryAtPath:itemPath error:nil];
            
            // get [*.app] directory
            for (NSString *subItem in itemsSub) {
                if ([subItem hasSuffix:@".app"]) {
                    
                    AppInfo *appInfo = [AppInfo new];
                    appInfo.appName = subItem;
                    
                    NSString *subItemAppPath =  [itemPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/icon.png",subItem]];
                    
                    NSString *subItemAppPath1 =  [itemPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/Icon.png",subItem]];
                    if([self.fm fileExistsAtPath:subItemAppPath])
                    {
                        appInfo.iconPath = subItemAppPath;
                    }
                    else if ([self.fm fileExistsAtPath:subItemAppPath1] )
                    {
                        appInfo.iconPath = subItemAppPath1;
                    }
                    else
                    {
                        NSString *pilstPath = [itemPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/Info.plist",subItem]];
                        
                        
                        NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:pilstPath];
                        //NSDictionary *dict1,*dict2,*dict3;
                        NSString *iconName = [plistDict[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"] lastObject];
                        appInfo.iconPath = [itemPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",subItem,iconName]];
                    }
                    
                    [appInfoArray addObject:appInfo];
                }
            }
        }
    }
    
    //OVER
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    if (self.isPoped)
    {
        [self.fm changeCurrentDirectoryPath: self.previousPath];
        self.isPoped = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section <2) {
        return 44;
    }

    return _isRoot?70:44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1 || section == 2)
    {
        return 1;
    }
    else
    {
        return [self.contentsDirectory count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ContentsCellIdentifier = @"ContentsCell";
    UITableViewCell *contentsCell = [tableView dequeueReusableCellWithIdentifier:ContentsCellIdentifier];
    
    
    static NSString *DateCellIdentifier = @"DateCell";
    UITableViewCell *dateCell = [tableView dequeueReusableCellWithIdentifier: DateCellIdentifier];
    
    if (contentsCell == nil)
    {
        contentsCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContentsCellIdentifier] autorelease];
    }
    if (dateCell == nil)
    {
        dateCell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: DateCellIdentifier] autorelease];
    }

    
    int section = [indexPath section];
    int row = [indexPath row];
    
    if (section == 0)
    {
        dateCell.textLabel.text = _creationDate;
        return dateCell;
    }
    else if (section == 1)
    {
        dateCell.textLabel.text = _modificationDate;
        return dateCell;
    }
    else if(section == 2)
    {
        dateCell.textLabel.text = self.title;
        [dateCell.textLabel setNumberOfLines:3];
        return dateCell;
    }
    else
    {
        if (_isRoot) {
            AppInfo *app = appInfoArray[row];
            contentsCell.textLabel.text = app.appName;
            
            UIImage *image = [UIImage imageWithContentsOfFile:app.iconPath];
            if (image==NULL) {
                image = [UIImage imageNamed:@"cell_default"];
            }
            [contentsCell.imageView setImage:image];
        }
        else
        {
            
            contentsCell.textLabel.text = [self.contentsDirectory objectAtIndex: row];
            [contentsCell.imageView setImage:nil];
        }
        
        contentsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return contentsCell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Creation Date";
    }
    else if (section == 1)
    {
        return @"Modification Date";
    }
    else if (section == 2)
    {
        return @"Folder";
    }
    else
    {
        return @"Contents";
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] >2)
    {
        // Check whether it is a directory or a folder
        NSString *selectedPath = [self.contentsDirectory objectAtIndex: [indexPath row]];
        NSString *prePath = [self.fm currentDirectoryPath];
        BOOL flag = [self.fm changeCurrentDirectoryPath: selectedPath];
    
        // It is a directory
        if (flag)
        {
            RootViewController *rootViewController = [[[RootViewController alloc] initWithNibName: @"RootViewController" bundle: nil] autorelease];
            rootViewController.fm = self.fm;
            rootViewController.title = selectedPath;
        
            self.previousPath = prePath;
            self.isPoped = YES;
            [self.navigationController pushViewController: rootViewController animated: YES];
        }
        // It is a file
        else
        {
            FileViewController *fileViewController = [[[FileViewController alloc] initWithNibName: @"FileViewController" bundle: nil] autorelease];
            NSString *path = selectedPath;
            NSDictionary *file = [self.fm attributesOfItemAtPath: path error: nil];
        
            fileViewController.creationDate = [[file valueForKey: NSFileCreationDate] description];
            fileViewController.modificationDate = [[file valueForKey: NSFileModificationDate] description];
            fileViewController.fileSize = [NSString stringWithFormat: @"%@", [file valueForKey: NSFileSize]];
            fileViewController.title = selectedPath;
        
            [self.navigationController pushViewController: fileViewController animated: YES];
        }
    }
    
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

-(void)zipFolder
{
    //Documents
    
    //zip file
    NSString *appDocument =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *zipPath = [NSString stringWithFormat:@"%@/%@_%.lf.zip",appDocument,self.title,[[NSDate date] timeIntervalSince1970]];//[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",[[NSDate date] description]]];
    
    
    //get All files
    NSString *srcPath =  [self.fm currentDirectoryPath];
    
    NSArray *filesPaths = [self.fm subpathsOfDirectoryAtPath:srcPath error: nil];
    
    if (filesPaths.count==0) {
        return;
    }
    
    ZipArchive *zip = [[ZipArchive alloc] init];
    [zip CreateZipFile2:zipPath];
    
    //int i=0;
    for (NSString *path in filesPaths) {
        
        NSString *curFilePath = [srcPath stringByAppendingPathComponent:path];
        [zip addFileToZip:curFilePath newname:path];
    }
    
    [zip CloseZipFile2];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zip Archive is OK!" message:@"Alert" delegate:nil cancelButtonTitle:@"Good!" otherButtonTitles: nil];
    [alert show];
    [alert release];
    
    return;
    // "/var/"
    
    
    NSString *comm = [NSString stringWithFormat:@"zip -r \"%@\" \"%@\" ",zipPath,srcPath];
    
    system([comm UTF8String]);
    
    /*
    
    
    
    zip addFileToZip:<#(NSString *)#> newname:<#(NSString *)#>
    //可以压缩文件夹， ret =
    //newname目录形式就可以
    */
}


-(NSString*) getZipNum
{
    NSString *appDocument =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *ary  = [self.fm subpathsOfDirectoryAtPath:appDocument error: nil];
    return [NSString stringWithFormat:@"%d",ary.count];
    
    NSDictionary *currentDitionary = [self.fm attributesOfItemAtPath:appDocument error: nil];
    return [[currentDitionary valueForKey: NSFileSystemFileNumber] description];
}

-(void) clearDocument
{
    NSString *appDocument =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *filesPaths = [self.fm subpathsOfDirectoryAtPath:appDocument error: nil];
    for (NSString *fileName in filesPaths) {
        NSString *curFilePath = [appDocument stringByAppendingPathComponent:fileName];
        [self.fm removeItemAtPath:curFilePath error:nil];
    }
    
    [self.navigationItem.rightBarButtonItem setTitle:[NSString stringWithFormat:@"[0]清空"]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Alert" delegate:nil cancelButtonTitle:@"Good!" otherButtonTitles: nil];
    [alert show];
    [alert release];
    
    return;
}

@end
