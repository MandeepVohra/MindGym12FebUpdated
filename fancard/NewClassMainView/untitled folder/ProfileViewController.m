//
//  ProfileViewController.m
//  fancard
//
//  Created by Mandeep on 03/02/16.
//  Copyright © 2016 MEETStudio. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIFactory.h"
#import <AFNetworking/AFNetworking.h>
#import "LanbaooPrefs.h"
#import "UserInfo.h"
#import <LKDBHelper/NSObject+LKDBHelper.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ProfileBg"]]];
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    _titleView.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:151.0/255.0 blue:223.0/255.0 alpha:1.0];
    [self.view addSubview:_titleView];
    
    
    UILabel* TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 100, 30)];
    [TitleLabel setTextColor:[UIColor whiteColor]];
    [TitleLabel setText:@"Edit Profile"];
    [TitleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0]];
    [TitleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleView addSubview:TitleLabel];
    
    
    _backButton = [UIFactory createButtonWithFrame:CGRectMake(5, 10, 31, 30)
                                            Target:self
                                          Selector:@selector(backPressed)
                                             Image:@"BackArrow"
                                      ImagePressed:@"BackArrow"];
    [_titleView addSubview:_backButton];
    
    self.ProfilePic = [[UIImageView alloc] initWithFrame:CGRectMake(22, 110, 70, 70)];
    [[self.ProfilePic layer] setCornerRadius:self.ProfilePic.frame.size.width/2];
    [self.ProfilePic sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveImageUrl"]] placeholderImage:[UIImage imageNamed:@"PlaceholderImageWithoutBorder"]];
    [self.ProfilePic setClipsToBounds:YES];
    [self.view addSubview:self.ProfilePic];
    
    self.BackroundPic = [[UIImageView alloc] initWithFrame:CGRectMake(150, 110, 70, 70)];
    [self.BackroundPic setClipsToBounds:YES];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"myfile.png"];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    [self.BackroundPic setImage:img];
    [self.view addSubview:self.BackroundPic];
    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(55, 240, 250, 40)];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = @"Name";
    [textField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserName"]];
    [textField setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0]];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    [self.view addSubview:textField];
    
    
    UITextField *textFieldEmail = [[UITextField alloc] initWithFrame:CGRectMake(55, 277, 250, 40)];
    textFieldEmail.borderStyle = UITextBorderStyleNone;
    [textFieldEmail setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0]];
    textFieldEmail.placeholder = @"Email";
    textFieldEmail.keyboardType = UIKeyboardTypeEmailAddress;
    textFieldEmail.returnKeyType = UIReturnKeyDone;
    textFieldEmail.delegate = self;
    [self.view addSubview:textFieldEmail];
    
    
    UIButton *buttonUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonUpdate addTarget:self
                     action:@selector(UpdateButtonMethod:)
           forControlEvents:UIControlEventTouchUpInside];
    [buttonUpdate setBackgroundColor:[UIColor clearColor]];
    buttonUpdate.frame = CGRectMake(120, 380, 80, 80);
    [self.view addSubview:buttonUpdate];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    UIButton *buttonMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonMenu addTarget:self
                   action:@selector(EditProfile:)
         forControlEvents:UIControlEventTouchUpInside];
    [buttonMenu setImage:[UIImage imageNamed:@"EditProfile"] forState:UIControlStateNormal];
    buttonMenu.frame = CGRectMake(50, 155, 43, 42);
    [self.view addSubview:buttonMenu];
    
    
    UIButton *buttonEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonEdit addTarget:self
                   action:@selector(EditProfileBg:)
         forControlEvents:UIControlEventTouchUpInside];
    [buttonEdit setImage:[UIImage imageNamed:@"EditProfile"] forState:UIControlStateNormal];
    buttonEdit.frame = CGRectMake(195, 155, 43, 42);
    [self.view addSubview:buttonEdit];
    
    
    
    
    
    
}

-(void)EditProfile:(id)sender{
    
    stringCompare = @"Profile";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallary", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}
-(void)EditProfileBg:(id)sender{
    stringCompare = @"BgImage";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallary", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag)
    {
        case 1:
            switch (buttonIndex)
        {
            case 0:
            {
#if TARGET_IPHONE_SIMULATOR
                
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Camera not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
#elif TARGET_OS_IPHONE
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                //picker.allowsEditing = YES;
                [self presentModalViewController:picker animated:YES];
                // [picker release];
                
#endif
            }
                break;
            case 1:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                [self presentViewController:picker animated:YES completion:nil];
            }
                break;
        }
            break;
            
        default:
            break;
    }
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    if ([stringCompare isEqualToString:@"Profile"])
    {
        imagePick =  [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.ProfilePic setImage:imagePick];
    }
    else{
        imagePick = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.BackroundPic setImage:imagePick];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark Back Button
-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UpdateButtonMethod
-(void)UpdateButtonMethod:(id)sender{
    
    if (self.BackroundPic.image != nil && self.ProfilePic.image != nil) {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        
        UIImage * imageToSave = self.BackroundPic.image;
        NSData * binaryImageData = UIImagePNGRepresentation(imageToSave);
        
        [binaryImageData writeToFile:[basePath stringByAppendingPathComponent:@"myfile.png"] atomically:YES];
        
        
        
        NSString *userId = [LanbaooPrefs sharedInstance].userId;
        
        //The picture uploaded to the server
        NSDictionary *parameters = @{
                                     @"command" : @"update_user",
                                     @"uid" : userId
                                     };
        NSError *err;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
                                        multipartFormRequestWithMethod:@"POST"
                                        URLString:kServerURL
                                        parameters:parameters
                                        constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
                                            NSData *uploadImage = [self compressImageToUpload:self.ProfilePic.image];
                                            [formData appendPartWithFileData:uploadImage
                                                                        name:@"avatar"
                                                                    fileName:@"user.jpg"
                                                                    mimeType:@"image/jpg"];
                                        } error:&err];
        NSLog(@"err = %@", err);
        
        AFHTTPRequestOperation *opration = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        opration.responseSerializer = [AFJSONResponseSerializer serializer];
        [opration setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            //[self showHUdComplete:@"Upload Successful!"];
            //  _avatar.image = image;
            
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSString *photo = [dict objectForKey:@"avatar"];
            
            UserInfo *userInfo = [UserInfo searchSingleWithWhere:nil orderBy:nil];
            if (!userInfo)
            {
                userInfo = [[UserInfo alloc] init];
            }
            userInfo.avatar = photo;
            [userInfo updateToDB];
            [[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Profile Update Sucessfully" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
            [LanbaooPrefs sharedInstance].userName = [NSString stringWithFormat:@"%@ %@", userInfo.firstname, userInfo.lastname];
            
        }
         
                                        failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
            
            NSLog(@"error = %@", error);
            
        }];
        
        [opration start];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Please set Images" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
    }
    
}

#pragma mark Compress Image

- (NSData *)compressImageToUpload:(UIImage *)image {
    // Determine output size
    CGFloat maxSize = 200.0f;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat newWidth = width;
    CGFloat newHeight = height;
    
    // If any side exceeds the maximun size, reduce the greater side to 800px and proportionately the other one
    if (width > maxSize || height > maxSize) {
        if (width > height) {
            newWidth = maxSize;
            newHeight = (height * maxSize) / width;
        } else {
            newHeight = maxSize;
            newWidth = (width * maxSize) / height;
        }
    }
    
    // Resize the image
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Set maximun compression in order to decrease file size and enable faster uploads & downloads
    NSData *processedImageData = UIImageJPEGRepresentation(newImage, 0.9f);
    return processedImageData;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
