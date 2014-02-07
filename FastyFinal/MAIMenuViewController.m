//
//  MAIMenuViewController.m
//  FastyFinal
//
//  Created by Manuel Amado on 07/01/2014.
//  Copyright (c) 2014 Manuel Amado. All rights reserved.
//

#import "MAIMenuViewController.h"
#import "MAIGameViewController.h"
#import <GameKit/GameKit.h>
#import "MAISettingsViewController.h"



@interface MAIMenuViewController () <GKGameCenterControllerDelegate>
{
    
    
    UIButton *easyButton;
    UIButton *mediumButton;
    UIButton *hardButton;
    
    BOOL puedeCambiar;
    
    CGRect buttonTimeInicial;
    CGRect buttonPointInicial;
    
    BOOL points;
    
    int dificultad;
    
    
}

@end

@implementation MAIMenuViewController

@synthesize pointsButton, timeButton, championButton, settingButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        buttonTimeInicial = timeButton.frame;
        buttonPointInicial = pointsButton.frame;
        [self conectarGameCenter];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    CALayer *timeLayer = [timeButton layer];
    [timeLayer setMasksToBounds:YES];
    [timeLayer setCornerRadius:10.0f];
    CALayer *pointLayer = [pointsButton layer];
    [pointLayer setMasksToBounds:YES];
    [pointLayer setCornerRadius:10.0f];
    
    
    puedeCambiar = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    timeButton.frame = buttonTimeInicial;
    pointsButton.frame = buttonPointInicial;
    
    timeButton.hidden = NO;
    pointsButton.hidden = NO;
    
    [timeButton setTitleColor:[UIColor blackColor]
                     forState:UIControlStateNormal];
    [pointsButton setTitleColor:[UIColor blackColor]
                       forState:UIControlStateNormal];
    
    [[timeButton layer] setBorderWidth:0.0f];
    [[pointsButton layer] setBorderWidth:0.0f];
    
    easyButton.hidden = YES;
    mediumButton.hidden = YES;
    hardButton.hidden = YES;
    
    puedeCambiar = YES;
    
    points = NO;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)leaderboardButton:(id)sender {
    
    NSLog(@"Leaderboard");

   
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        [self presentViewController: gameCenterController animated: YES completion:nil];
    }
    
    
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)timeButtonPush:(id)sender {
    
    if (puedeCambiar) {
        [self crearBotones];
        
        [timeButton setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
        //   [timeButton setBackgroundColor:[UIColor colorWithRed:(3/255.0) green:(170/255.0) blue:(174/255.0) alpha:1]];
        pointsButton.hidden = YES;
        
        [[timeButton layer] setBorderWidth:2.0f];
        [[timeButton layer] setBorderColor:[UIColor blackColor].CGColor];
        
        
        CGRect buttonTimeFrame = timeButton.frame;
        
        easyButton.frame = CGRectMake(buttonTimeFrame.origin.x, 390, 76, 44);
        mediumButton.frame = CGRectMake(160-38, 390, 76, 44);
        hardButton.frame = CGRectMake(pointsButton.frame.origin.x + pointsButton.frame.size.width-76, 390, 76, 44);
        
        puedeCambiar = NO;
        
        if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
            championButton.hidden = YES;
            settingButton.hidden = YES;
        }
        
    }else{
        [easyButton removeFromSuperview];
        [mediumButton removeFromSuperview];
        [hardButton removeFromSuperview];
        
        puedeCambiar = YES;
        
        pointsButton.hidden = NO;
        [[timeButton layer] setBorderWidth:0.0f];
        [[timeButton layer] setBorderColor:[UIColor clearColor].CGColor];
        [timeButton setTitleColor:[UIColor blackColor]
                         forState:UIControlStateNormal];
        
        if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
            championButton.hidden = NO;
            settingButton.hidden = NO;
        }
        
        
    }
    
    
    
    
    
    
}
- (IBAction)pointsButtonPush:(id)sender {
    
    
    if (puedeCambiar) {
        [self crearBotones];
        
        [pointsButton setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateNormal];
        //[pointsButton setBackgroundColor:[UIColor colorWithRed:(3/255.0) green:(170/255.0) blue:(174/255.0) alpha:1]];
        timeButton.hidden = YES;
        
        [[pointsButton layer] setBorderWidth:2.0f];
        [[pointsButton layer] setBorderColor:[UIColor blackColor].CGColor];
        
        
        CGRect buttonTimeFrame = pointsButton.frame;
        
        
        easyButton.frame = CGRectMake(timeButton.frame.origin.x, 390, 76, 44);
        mediumButton.frame = CGRectMake(160-38, 390, 76, 44);
        hardButton.frame = CGRectMake(buttonTimeFrame.origin.x + buttonTimeFrame.size.width-76, 390, 76, 44);
        
        points = YES;

        puedeCambiar = NO;
        
        if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
            championButton.hidden = YES;
            settingButton.hidden = YES;
        }
        
    }else{
        
        [easyButton removeFromSuperview];
        [mediumButton removeFromSuperview];
        [hardButton removeFromSuperview];
        
        puedeCambiar = YES;
        
        timeButton.hidden = NO;
        [[pointsButton layer] setBorderWidth:0];
        [pointsButton setTitleColor:[UIColor blackColor]
                           forState:UIControlStateNormal];
  
        
        if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
            championButton.hidden = NO;
            settingButton.hidden = NO;
        }
    }
  

    
}

- (IBAction)easyButtonPressed:(id)sender {
    
    
    
    NSLog(@"EASY");
    
    dificultad = 0;
    
    [self changeViewController];
    
}

- (IBAction)mediumButtonPressed:(id)sender {
    
    NSLog(@"MEDIUM");
    
    dificultad = 1;
    
    [self changeViewController];
    
    
}

- (IBAction)hardButtonPressed:(id)sender {
    
    NSLog(@"HARD");

    dificultad = 2;

    [self changeViewController];
    
}

-(void)changeViewController
{
    
    UIViewController *gameViewController = [[MAIGameViewController alloc]initWithDificult:dificultad mode:points];
    
    [self.navigationController pushViewController:gameViewController animated:YES];
 

}

-(void)crearBotones
{
    //CREACION BOTONES
    
    easyButton = [[UIButton alloc]init];
    [easyButton setTitle:@"Easy" forState:UIControlStateNormal];
    [easyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [easyButton setBackgroundColor:[UIColor colorWithRed:(3/255.0) green:(170/255.0) blue:(174/255.0) alpha:1]];
    easyButton.titleLabel.font = [UIFont fontWithName:@"Noteworthy Light" size:20];
    [easyButton addTarget:self action:@selector(easyButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:easyButton];
    CALayer *easyLayer = [easyButton layer];
    [easyLayer setMasksToBounds:YES];
    [easyLayer setCornerRadius:10.0f];
    
    mediumButton = [[UIButton alloc]init];
    [mediumButton setTitle:@"Medium" forState:UIControlStateNormal];
    [mediumButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mediumButton setBackgroundColor:[UIColor colorWithRed:(3/255.0) green:(170/255.0) blue:(174/255.0) alpha:1]];
    mediumButton.titleLabel.font = [UIFont fontWithName:@"Noteworthy Light" size:20];
    [mediumButton addTarget:self action:@selector(mediumButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:mediumButton];
    CALayer *mediumLayer = [mediumButton layer];
    [mediumLayer setMasksToBounds:YES];
    [mediumLayer setCornerRadius:10.0f];
    
    hardButton = [[UIButton alloc]init];
    [hardButton setTitle:@"Hard" forState:UIControlStateNormal];
    [hardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [hardButton setBackgroundColor:[UIColor colorWithRed:(3/255.0) green:(170/255.0) blue:(174/255.0) alpha:1]];
    hardButton.titleLabel.font = [UIFont fontWithName:@"Noteworthy Light" size:20];
    [hardButton addTarget:self action:@selector(hardButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:hardButton];
    CALayer *hardLayer = [hardButton layer];
    [hardLayer setMasksToBounds:YES];
    [hardLayer setCornerRadius:10.0f];
    
    
}

- (void)conectarGameCenter {
    
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        if (viewController != nil) {
            
            // Presentamos el Login para el usuario
            [self presentViewController:viewController animated:YES completion:nil];
            
        } else if (localPlayer.isAuthenticated) {
            
            NSLog(@"El usuario ya esta logado en Game Center");
            
        } else {
            
            // El usuario ha pulsado cancelar o bien se ha producido algún error
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error" message:@"El usuario ha cancelado o ha habido algún error." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alerta show];
            
        }
    };    
    
}


- (IBAction)settingButtonPress:(id)sender {
    
    NSLog(@"Settings");
    
    MAISettingsViewController *settingViewController = [[MAISettingsViewController alloc]init];
    
    [self.navigationController pushViewController:settingViewController animated:YES];
    

}






@end
