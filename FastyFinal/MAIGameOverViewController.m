//
//  MAIGameOverViewController.m
//  Fancy2
//
//  Created by Manuel Amado on 29/12/2013.
//  Copyright (c) 2013 Manuel Amado. All rights reserved.
//

#import "MAIGameOverViewController.h"
#import "MAIMenuViewController.h"
#import "MAIDatosJuego.h"
#import "MAIGameViewController.h"
#import <GameKit/GameKit.h>
#import "MAISettingsViewController.h"
#import "VENSnowOverlayView.h"

@interface MAIGameOverViewController ()
{
    NSString *leaderboard;

}
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointTitleLabel;
@end

@implementation MAIGameOverViewController
@synthesize datosFinales,timeLabel, pointsLabel;
@synthesize timeTitleLabel, pointTitleLabel, recordLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        datosFinales = [[MAIDatosJuego alloc]init];

    
        [super viewDidLoad];
            }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    


    timeLabel.text = [[NSString alloc] initWithFormat:@"%.3f s", datosFinales.tiempoDuracion];
    pointsLabel.text = [[NSString alloc] initWithFormat:@"%d pts", datosFinales.puntos];
    
    if (!datosFinales.esPuntos) {
        
        pointsLabel.hidden = YES;
        pointTitleLabel.hidden = YES;
        
        timeLabel.layer.position = CGPointMake(timeLabel.layer.position.x, timeLabel.layer.position.y + 30);
        timeTitleLabel.layer.position = CGPointMake(timeTitleLabel.layer.position.x, timeTitleLabel.layer.position.y + 30);


    }
    
    
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [self reportarPuntuacionGameCenter];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)newGameButtonPress:(id)sender {
    
    UIViewController *gameViewController = [[MAIGameViewController alloc]initWithDificult:datosFinales.dificultad mode:datosFinales.esPuntos];
    
    [self.navigationController pushViewController:gameViewController animated:YES];
    
    [self removeFromParentViewController];
    
    


}
- (IBAction)menuButtonPress:(id)sender {
    
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self.navigationController popToRootViewControllerAnimated:YES];

    
}
- (IBAction)settingsButtonPress:(id)sender {
    
    
    MAISettingsViewController *settingViewController = [[MAISettingsViewController alloc]init];
    
    [self.navigationController pushViewController:settingViewController animated:YES];
    

}
- (IBAction)leaderboardButtonPress:(id)sender {
    NSLog(@"Leaderboard");
    
}
- (void)reportarPuntuacionGameCenter {
    
    NSLog(@"carga puntuacion");
    
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        if (viewController != nil) {
            
            // Presentamos el Login para el usuario
            [self presentViewController:viewController animated:YES completion:nil];
            
        } else if (localPlayer.isAuthenticated) {
            
            NSLog(@"El usuario ya esta logado en Game Center");
            
        } else {
            
            // El usuario ha pulsado cancelar o bien se ha producido algún error
        /*    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error" message:@"El usuario ha cancelado o ha habido algún error." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alerta show];
          */  
        }
    };
    
    if (!datosFinales.esPuntos) {
        
        if (datosFinales.dificultad == 0) {
            leaderboard = @"Leaderboard1A";
        }else if (datosFinales.dificultad == 1) {
            leaderboard = @"Leaderboard1B";
        }else{
            leaderboard = @"Leaderboard1C";
        }
    }else{
        if (datosFinales.dificultad == 0) {
            leaderboard = @"Leaderboard2A";
        }else if (datosFinales.dificultad == 1) {
            leaderboard = @"Leaderboard2B";
        }else{
            leaderboard = @"Leaderboard2C";
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!datosFinales.esPuntos) {
    
    if ([defaults floatForKey:leaderboard] < datosFinales.tiempoDuracion * 1000) {
        [self newRecord];
        
        NSLog(@"Salto NEWWWWWW REEEECORDD");

        NSLog(@"Datos tiempo %f      %f", [defaults floatForKey:leaderboard] , (datosFinales.tiempoDuracion * 1000));
        
        [defaults setFloat:datosFinales.tiempoDuracion*1000 forKey:leaderboard];
    }
        
    }else{
        
        if ([defaults integerForKey:leaderboard] < datosFinales.puntos) {
            [self newRecord];
            NSLog(@"Salto NEWWWWWW REEEECORDD");

            NSLog(@"Datos tiempo %ld      %d", (long)[defaults integerForKey:leaderboard] , (datosFinales.puntos));

            [defaults setFloat:datosFinales.puntos forKey:leaderboard];

        }
        
        
    }
    
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        GKScore* score = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboard];
        
        if (datosFinales.esPuntos) {
            score.value = datosFinales.puntos;
        }else{
            score.value = datosFinales.tiempoDuracion * 1000;
        }
        
        
        
        
        NSLog(@"puntuacion de %f", datosFinales.tiempoDuracion);
        NSLog(@"carga de %lld",score.value);

        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            }
        }];
        
        
    }
    
    
}

-(void)newRecord
{
    
    VENSnowOverlayView *snowOverlay = [[VENSnowOverlayView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:snowOverlay];
    [snowOverlay beginSnowAnimation];
    
    recordLabel.hidden = NO;

}



@end
