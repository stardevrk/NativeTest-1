//
//  ViewController.m
//  BZTestPicker
//
//  Created by DevMaster on 12/5/19.
//  Copyright © 2019 DevMaster. All rights reserved.
//

#import "ViewController.h"
#import "GMImagePickerController.h"

@import FilestackSDK;
@import Filestack;

@import UIKit;
@import Photos;

@interface ViewController ()
@property (strong) FSClient *client;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)touchUIImagePickerButton:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popPC = picker.popoverPresentationController;
    popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popPC.sourceView = _uiImagePickerButton;
    popPC.sourceRect = _uiImagePickerButton.bounds;
    
    [self showViewController:picker sender:sender];
}

- (IBAction)touchMyPickerButton:(id)sender {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];

    if (status == PHAuthorizationStatusAuthorized) {
        [self openPickerViewController];
    } else if (status == PHAuthorizationStatusDenied) {
    // Access has been denied.
    } else if (status == PHAuthorizationStatusNotDetermined) {
        // Access has not been determined.
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                // Access has been granted.
                [self openPickerViewController];
            }

            else {
                // Access has been denied.
            }
            }];
    } else if (status == PHAuthorizationStatusRestricted) {
        // Restricted access - normally won't happen.
    }
}

- (void)openPickerViewController {

        GMImagePickerController *picker = [[GMImagePickerController alloc] init];
        picker.delegate = self;
        picker.title = @"Custom title";
        
        picker.customDoneButtonTitle = @"Finished";
        picker.customCancelButtonTitle = @"Nope";
        picker.customNavigationBarPrompt = @"Take a new photo or select an existing one!";
        
        picker.colsInPortrait = 3;
        picker.colsInLandscape = 5;
        picker.minimumInteritemSpacing = 2.0;
        
    //    picker.allowsMultipleSelection = NO;
    //    picker.confirmSingleSelection = YES;
    //    picker.confirmSingleSelectionPrompt = @"Do you want to select the image you have chosen?";
        
    //    picker.showCameraButton = YES;
    //    picker.autoSelectCameraImages = YES;
        
        picker.modalPresentationStyle = UIModalPresentationPopover;

    //    picker.mediaTypes = @[@(PHAssetMediaTypeImage)];

    //    picker.pickerBackgroundColor = [UIColor blackColor];
    //    picker.pickerTextColor = [UIColor whiteColor];
    //    picker.toolbarBarTintColor = [UIColor darkGrayColor];
    //    picker.toolbarTextColor = [UIColor whiteColor];
    //    picker.toolbarTintColor = [UIColor redColor];
    //    picker.navigationBarBackgroundColor = [UIColor blackColor];
    //    picker.navigationBarTextColor = [UIColor whiteColor];
    //    picker.navigationBarTintColor = [UIColor redColor];
    //    picker.pickerFontName = @"Verdana";
    //    picker.pickerBoldFontName = @"Verdana-Bold";
    //    picker.pickerFontNormalSize = 14.f;
    //    picker.pickerFontHeaderSize = 17.0f;
    //    picker.pickerStatusBarStyle = UIStatusBarStyleLightContent;
    //    picker.useCustomFontForNavigationBar = YES;
        
        UIPopoverPresentationController *popPC = picker.popoverPresentationController;
        popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popPC.sourceView = _myTestPickerButton;
        popPC.sourceRect = _myTestPickerButton.bounds;
    //    popPC.backgroundColor = [UIColor blackColor];
        
        [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"UIImagePickerController: User ended picking assets");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"UIImagePickerController: User pressed cancel button");
}

#pragma mark - GMImagePickerControllerDelegate

- (void)assetsPickerController:(GMImagePickerController *)picker didFinishPickingAssets:(NSArray *)assetArray
{
    
    for (PHAsset *asset in assetArray) {
        if (asset.mediaType == PHAssetMediaTypeImage) {
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                NSURL *url = [info objectForKey:@"PHImageFileURLKey"];
                // do what you want with it
//                NSString *path = [url absoluteURL];
                NSString *path=[NSString stringWithFormat:@"%@",url];
                NSLog(@"GMImagePicker: User ended picking assets. Image Path is: %@", path);
            }];
        }
        
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info)
            {
                if ([asset isKindOfClass:[AVURLAsset class]])
                {
                    NSURL *url = [(AVURLAsset*)asset URL];
                     // do what you want with it
                    
//                    FSUploader *uploader = [self->_client uploadURLUsing:url options:uploadOptions queue:dispatch_get_main_queue() uploadProgress:^(NSProgress * _Nonnull progress) {
//                         NSLog(@"Progress: %@", progress);
//                        
//                    } completionHandler:^(FSNetworkJSONResponse * _Nullable response) { NSDictionary *jsonResponse = response.json;
//                        NSString *handle = jsonResponse[@"handle"];
//                        NSError *error = response.error;
//                        if (handle) { // Use Filestack handle
//                            NSLog(@"Handle is: %@", handle);
//                        } else if (error) { // Handle error
//                            NSLog(@"Error is: %@", error);
//                        }
//                        
//                    } ];
                    
//                    NSString *path = [url absoluteURL];
                    NSString *path=[NSString stringWithFormat:@"%@",url];
                    NSLog(@"GMImagePicker: User ended picking assets. Video Path is: %@", path);
                }
            }];
        }
    }
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
//    NSLog(@"GMImagePicker: User ended picking assets. Number of selected items is: %lu", (unsigned long)assetArray.count);
}

//Optional implementation:
-(void)assetsPickerControllerDidCancel:(GMImagePickerController *)picker
{
    NSLog(@"GMImagePicker: User pressed cancel button");
}

@end
