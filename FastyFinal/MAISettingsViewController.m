//
//  MAISettingsViewController.m
//  FastyFinal
//
//  Created by Manuel Amado on 13/01/2014.
//  Copyright (c) 2014 Manuel Amado. All rights reserved.
//

#import "MAISettingsViewController.h"
#import "TBCircularSlider.h"

@interface MAISettingsViewController ()

{
    BOOL joystick; //true left
    NSInteger sensibility;
    
    NSUserDefaults *defaults;
    __weak IBOutlet UIButton *leftButton;
    __weak IBOutlet UIButton *rightButton;
    
    __weak IBOutlet UIButton *back;
}
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *joystickPositionLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftJoystckButton;
@property (weak, nonatomic) IBOutlet UIButton *rigthJoystickPositionButton;
@property (weak, nonatomic) IBOutlet UILabel *joystickSensibilityLabel;

@end

@implementation MAISettingsViewController
@synthesize backButton,joystickPositionLabel, joystickSensibilityLabel, leftJoystckButton, rigthJoystickPositionButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];

    TBCircularSlider *slider;
    
    if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
        //Create the Circular Slider
        slider = [[TBCircularSlider alloc]initWithFrame:CGRectMake(40, 250, TB_SLIDER_SIZE, TB_SLIDER_SIZE)];
        
        backButton.layer.position = CGPointMake(backButton.layer.position.x, backButton.frame.origin.y - 15);
        joystickPositionLabel.layer.position = CGPointMake(joystickPositionLabel.layer.position.x, joystickPositionLabel.frame.origin.y - 15);
        leftJoystckButton.layer.position = CGPointMake(leftJoystckButton.layer.position.x, leftJoystckButton.frame.origin.y + -20);
        rigthJoystickPositionButton.layer.position = CGPointMake(rigthJoystickPositionButton.layer.position.x, rigthJoystickPositionButton.frame.origin.y - 20);
        joystickSensibilityLabel.layer.position = CGPointMake(joystickSensibilityLabel.layer.position.x, joystickSensibilityLabel.frame.origin.y - 40);
        
    }else{
        //Create the Circular Slider
        slider = [[TBCircularSlider alloc]initWithFrame:CGRectMake(40, 340, TB_SLIDER_SIZE, TB_SLIDER_SIZE)];
    }
    
    
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    joystick = [defaults boolForKey:@"joystick"];

    
    sensibility = [defaults integerForKey:@"sensibility"];
    
    NSLog(@"sensibilidad es %ld",(long)sensibility);

    if (joystick) {
        NSLog(@"Joystick en la izquierda");
        leftButton.selected = TRUE;

    }else{
        NSLog(@"Joystick en la derecha");
        rightButton.selected = TRUE;


    }
    
    if (sensibility == 0) {
        sensibility = 180;
    }
    
    slider.angle = sensibility;
    
    //Define Target-Action behaviour
    [slider addTarget:self action:@selector(newValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:slider];
    
    
    CALayer *leftLayer = [leftButton layer];
    [leftLayer setMasksToBounds:YES];
    [leftLayer setCornerRadius:30.0f];
    
    CALayer *rightLayer = [rightButton layer];
    [rightLayer setMasksToBounds:YES];
    [rightLayer setCornerRadius:30.0f];
    
    CALayer *backLayer = [back layer];
    [backLayer setMasksToBounds:YES];
    [backLayer setCornerRadius:20.0f];
    
 

}

/** This function is called when Circular slider value changes **/
-(void)newValue:(TBCircularSlider*)slider{
    //TBCircularSlider *slider = (TBCircularSlider*)sender;
  //  NSLog(@"Slider Value %d",slider.angle);
    sensibility = slider.angle;
    [defaults setInteger:sensibility forKey:@"sensibility"];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPress:(id)sender {
    
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self.navigationController popViewControllerAnimated:YES];
    

}

- (IBAction)leftJoystick:(id)sender {
    
    joystick = YES;
    [defaults setBool:joystick forKey:@"joystick"];
    NSLog(@"Joystick en la izquierda");
    leftButton.selected = TRUE;
    rightButton.selected = false;


    
}

- (IBAction)rigthJoystick:(id)sender {

    joystick = NO;
    [defaults setBool:joystick forKey:@"joystick"];
    NSLog(@"Joystick en la derecha");
    rightButton.selected = TRUE;
    leftButton.selected = false;


}




@end
