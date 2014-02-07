//
//  MAIViewController.h
//  FastyFinal
//

//  Copyright (c) 2014 Manuel Amado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface MAIGameViewController : UIViewController

@property(nonatomic) BOOL point;
@property(nonatomic) int dificultad;

-(void)cambiarControlador:(NSNotification *)notification;
-(id)initWithDificult:(int)dificulta mode:(BOOL)puntos;


@end
