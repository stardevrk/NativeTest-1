//
//  ViewController.h
//  BZTestPicker
//
//  Created by DevMaster on 12/5/19.
//  Copyright © 2019 DevMaster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *myTestPickerButton;
@property (weak, nonatomic) IBOutlet UIButton *uiImagePickerButton;
- (IBAction)touchUIImagePickerButton:(id)sender;
- (IBAction)touchMyPickerButton:(id)sender;


@end

