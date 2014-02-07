//
//  MAIViewController.m
//  FastyFinal
//
//  Created by Manuel Amado on 07/01/2014.
//  Copyright (c) 2014 Manuel Amado. All rights reserved.
//

#import "MAIGameViewController.h"
#import "MAIGameScene.h"
#import "MAIGameOverViewController.h"
#import "MAIDatosJuego.h"

@interface MAIGameViewController()
{
    SKScene * scene;
    SKView * skView;
    
    MAIDatosJuego *datos;
    
    BOOL joystick;
    int sensibility;
    
    
}
@end

@implementation MAIGameViewController
@synthesize point;

-(id)initWithDificult:(int)dificulta mode:(BOOL)puntos
{
    
    self = [super initWithNibName:@"MAIGameViewController" bundle:nil];
    if (self) {
        
        point = puntos;
        
        _dificultad = dificulta;
        datos = [[MAIDatosJuego alloc]init];
        
    }

    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *notificationName = @"MTPostNotificationTut";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cambiarControlador:)
                                                 name:notificationName
                                               object:nil];
    
    
    
    // Configure the view.
    skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    scene = [MAIGameScene sceneWithSize:[[UIScreen mainScreen] bounds].size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    datos.esPuntos = point;
    datos.dificultad = [self dificultad];
   
    [scene.userData setObject:datos
                       forKey:@"datos"];
    
    
    
    

    
    // Present the scene.
    [skView presentScene:scene];
    
}
/*
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}
*/
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    if (scene != nil)
    {
        [scene setPaused:YES];
        
        [scene removeAllActions];
        [scene removeAllChildren];
        
        scene = nil;
        
        [((SKView *)skView) presentScene:nil];
        
        skView = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)cambiarControlador:(NSNotification *)notification
{
    
    NSDictionary *dict = [notification userInfo];
    datos = [dict objectForKey:@"datosPartida"];
    
   
    
   
    
    MAIGameOverViewController* gameOverController = [[MAIGameOverViewController alloc]initWithNibName:@"MAIGameOverViewController"
                                                                                               bundle:nil];
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  //  [self presentViewController:gameOverController animated:YES completion:nil];
    
    [gameOverController setDatosFinales:datos];
    
    
    [self.navigationController pushViewController:gameOverController animated:YES];
    
    
    
    if (scene != nil)
    {
        [scene setPaused:YES];
        
        [scene removeAllActions];
        [scene removeAllChildren];
        
        scene = nil;
        
        [((SKView *)skView) presentScene:nil];
        
        skView = nil;
    }
    
    [self removeFromParentViewController];

    

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)save:(id)sender
{
   
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:joystick forKey:@"joystickPosition"];
    [defaults setInteger:sensibility forKey:@"sensibility"];
    [defaults synchronize];
    NSLog(@"Data saved");
}
@end
