//
//  MAIGameScene.m
//  Fancy2
//
//  Created by Manuel Amado on 28/12/2013.
//  Copyright (c) 2013 Manuel Amado. All rights reserved.
//

#import "MAIGameScene.h"
#import "Joystick.h"
#import "MAIGameViewController.h"
#import "MAIDatosJuego.h"


// iPhone 5 support
#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)


static const uint32_t principalCategory  =0x1 << 0;  // 00000000000000000000000000000001
static const uint32_t pointCategory  =0x1 << 1;  // 00000000000000000000000000000001
static const uint32_t enemyCategory =0x1 << 2; // 00000000000000000000000000000010
static const uint32_t backgroundWhiteCategory =0x1 << 3;  // 00000000000000000000000000000100
static const uint32_t backgroundBlackCategory =0x1 << 4; // 00000000000000000000000000001000

@interface MAIGameScene()
{
    SKSpriteNode* protagonista;
    int posicionBase;
    
    NSInteger statusBarSize;
    
    bool primerTiempoCalculado;
    float tiempoDeJuego;
    float primerTiempo;
    
    SKLabelNode *labelTimePlay;
    SKLabelNode *labelPointPlay;
    
    BOOL gameOver;
    BOOL juegoComenzo;
    
    SKSpriteNode* enemigo1;
    SKSpriteNode* enemigo2;
    SKSpriteNode* enemigo3;
    SKSpriteNode* enemigo4;
    
    BOOL esModoPuntos;
    int nivel;
    
    
    MAIDatosJuego *datos;
    
    float fuerzoImpulsoInicial;
    
    CGSize blackNodeGameSize;
    SKSpriteNode *blackNodeGame;
    
    SKLabelNode *labelPuntos;
    
    float tiempoCreacionLabel;
    int sumaPuntos;
    
    NSUserDefaults *defaults;
    
}
@end


@implementation MAIGameScene

@synthesize joystick;

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        
        self.physicsWorld.contactDelegate = self;
        
        posicionBase = [[UIScreen mainScreen]bounds].size.height;
        statusBarSize = [UIApplication sharedApplication].statusBarFrame.size.height;

        
        NSString *notification2Name = @"ComienzaJuego";
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(iniciarFisica)
                                                     name:notification2Name
                                                   object:nil];
        
        defaults = [NSUserDefaults standardUserDefaults];

        
        self.userData = [NSMutableDictionary dictionary];

        datos = [[MAIDatosJuego alloc]init];
    
        SKSpriteNode* background;
        
        if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
            background = [SKSpriteNode spriteNodeWithImageNamed:@"mainImage@2x.png"];
        }else{
            background = [SKSpriteNode spriteNodeWithImageNamed:@"mainImage-568h@2x.png"];
        }
        
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:background];
        

     
        [self addElementes];
        
        self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
        
        primerTiempoCalculado = NO;
        self.anchorPoint = CGPointMake(0.0, 0);
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(gameOver)
                                                     name:@"homePush"
                                                   object:nil];

        
         }
    return self;
}

#pragma mark - Metodos spriteKit


-(void)update:(CFTimeInterval)currentTime {
 
    if (protagonista.position.x > (285 - protagonista.size.height/2)) {
        [self gameOver];
    }
    if (protagonista.position.x < (35 + protagonista.size.height/2)) {
        [self gameOver];
    }
    if (protagonista.position.y > (posicionBase-statusBarSize- 35 - protagonista.size.height/2)) {
        [self gameOver];
    }
    if (protagonista.position.y < (posicionBase-statusBarSize-35-250+protagonista.size.height/2)) {
        [self gameOver];
    }
    
  
    if (juegoComenzo) {
        if (!primerTiempoCalculado) {
            primerTiempo = currentTime;
            primerTiempoCalculado = YES;
        }
        
        tiempoDeJuego = currentTime - primerTiempo;
        NSString* cadenaTiempo = [NSString stringWithFormat:@"%.0f sec",tiempoDeJuego];
        NSString* cadenaPuntos = [NSString stringWithFormat:@"%d pts",sumaPuntos];

        labelTimePlay.text = cadenaTiempo;
        labelPointPlay.text = cadenaPuntos;
        
        if (esModoPuntos) {
            
            if (!labelPuntos) {
                [self crearLabelPuntos:[self giveMeRandomPoint:10]];
            }else{
                if (tiempoDeJuego >( tiempoCreacionLabel + 3)) {
                    [labelPuntos removeFromParent];
                    labelPuntos = nil;
                    tiempoCreacionLabel = 0;
                }
            }
            
        }
    }
}


-(void)didBeginContact:(SKPhysicsContact*)contact {
    // 1 Create local variables for two physics bodies
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
   // 3 react to the contact between ball and bottom
    if (firstBody.categoryBitMask == principalCategory && secondBody.categoryBitMask == enemyCategory) {
        [self gameOver];
    }

    if (firstBody.categoryBitMask == principalCategory && secondBody.categoryBitMask == pointCategory) {
        [self sumaPuntos];
        [UIView animateWithDuration:0.3 animations:^{
            
        }];
        
        UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut;

        
        [UIView animateWithDuration:1
                              delay:0
                            options:options
                         animations:^{
                             
                             labelPuntos.position = labelPointPlay.position;
                             
                         }
                         completion:^(BOOL finnished) {
                             [labelPuntos removeFromParent];
                             labelPuntos = nil;
                             tiempoCreacionLabel = 0;

                         }];
        
    }

}

-(void)sumaPuntos
{
    sumaPuntos = sumaPuntos + [labelPuntos.text intValue];
}

-(void)gameOver
{
    NSLog(@"GAME OVER");
    
    datos.tiempoDuracion = tiempoDeJuego;
    datos.puntos = sumaPuntos;
    
    
    NSDictionary *datosPartida = [NSDictionary dictionaryWithObject:datos forKey:@"datosPartida"];
    
    
    if (!gameOver) {
        NSString *notificationName = @"MTPostNotificationTut";
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:datosPartida];
    }
   
    gameOver = YES;
}

# pragma mark - Metodos creacion

-(void)addElementes
{
    //Add black background game
    blackNodeGameSize = CGSizeMake(320, 320);
    blackNodeGame = [[SKSpriteNode alloc]initWithColor:[SKColor blackColor]
                                                  size:blackNodeGameSize];
    blackNodeGame.anchorPoint = CGPointMake(0, 0);
    blackNodeGame.position = (CGPoint) {0,posicionBase - statusBarSize - blackNodeGame.size.height};
//self.frame.size.height-60-blackNodeGame.size.height
    [self addChild:blackNodeGame];
    
    
    //CREAMOS BORDES PARA QUE REBOTEN Cuerpos
    // 1 Create a physics body that borders the screen
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:blackNodeGame.frame];
    // 2 Set physicsBody of scene to borderBody
    self.physicsBody = borderBody;
    // 3 Set the friction of that physicsBody to 0
    self.physicsBody.friction = 0.0f;
    blackNodeGame.physicsBody.categoryBitMask = backgroundBlackCategory;
    blackNodeGame.physicsBody.collisionBitMask = enemyCategory;
    

    //Add white background game
    SKSpriteNode *whiteNodeGame =  [SKSpriteNode spriteNodeWithImageNamed:@"whiteBackground@2x.png"];
    whiteNodeGame.anchorPoint = CGPointMake(0.5,0);
    whiteNodeGame.position = (CGPoint) {blackNodeGame.size.width/2, posicionBase - statusBarSize - whiteNodeGame.size.height-(blackNodeGame.size.height-whiteNodeGame.size.height)/2};

    [self addChild:whiteNodeGame];
    
    whiteNodeGame.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:whiteNodeGame.frame];
    
    //SKPhysicsBody* borderBody2 = [SKPhysicsBody bodyWithEdgeLoopFromRect:whiteNodeGame.frame];
    //     self.physicsBody = borderBody2;
    whiteNodeGame.physicsBody.categoryBitMask = backgroundWhiteCategory;
    whiteNodeGame.physicsBody.contactTestBitMask = principalCategory;
    whiteNodeGame.physicsBody.collisionBitMask = backgroundBlackCategory;
    
    
    //AÑADIMOS enemigo
    // creamos sprite
    enemigo1 = [SKSpriteNode spriteNodeWithImageNamed: @"rectangle1.png"];
    [self addChild:enemigo1];
    
    enemigo2 = [SKSpriteNode spriteNodeWithImageNamed: @"rectangle2.png"];
    [self addChild:enemigo2];
    
    enemigo3 = [SKSpriteNode spriteNodeWithImageNamed: @"rectangle3.png"];
    [self addChild:enemigo3];
    
    
    enemigo4 = [SKSpriteNode spriteNodeWithImageNamed: @"rectangle4.png"];
    [self addChild:enemigo4];
    
    if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
        enemigo1.position = CGPointMake(80, posicionBase - statusBarSize - 80);
        enemigo2.position = CGPointMake(240, posicionBase - statusBarSize - 240);
        enemigo3.position = CGPointMake(80, posicionBase - statusBarSize - 240);
        enemigo4.position = CGPointMake(240, posicionBase - statusBarSize - 80);
    }
    else{
        enemigo1.position = CGPointMake(80, posicionBase - statusBarSize - 80);
        enemigo2.position = CGPointMake(240, posicionBase - statusBarSize - 240);
        enemigo3.position = CGPointMake(80, posicionBase - statusBarSize - 240);
        enemigo4.position = CGPointMake(240, posicionBase - statusBarSize - 80);
    }
    
    //añadimos protagonista
    protagonista = [SKSpriteNode spriteNodeWithImageNamed: @"protagonista.png"];
    protagonista.position = CGPointMake(self.frame.size.width/2, posicionBase - statusBarSize - blackNodeGame.size.height/2);
    [self addChild:protagonista];
    protagonista.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:protagonista.size.height/2];
    protagonista.physicsBody.categoryBitMask = principalCategory;
    protagonista.physicsBody.collisionBitMask = backgroundBlackCategory;
    protagonista.physicsBody.contactTestBitMask = enemyCategory | backgroundWhiteCategory | pointCategory;
    
    
    //Joystick
    
    SKSpriteNode *jsThumb = [SKSpriteNode spriteNodeWithImageNamed:@"joystick.png"];
    SKSpriteNode *jsBackdrop = [SKSpriteNode spriteNodeWithImageNamed:@"dpad"];
    joystick = [Joystick joystickWithThumb:jsThumb andBackdrop:jsBackdrop];
   
    if ([defaults boolForKey:@"joystick"]) {
        
        joystick.position = CGPointMake(90,(self.frame.size.height - (statusBarSize+blackNodeGameSize.height))/2);
        
    }else{
        
        joystick.position = CGPointMake(230,(self.frame.size.height - (statusBarSize+blackNodeGameSize.height))/2);

    }
    
    
    [self addChild:joystick];
    
    CADisplayLink *velocityTick = [CADisplayLink displayLinkWithTarget:self selector:@selector(joystickMovement)];
    [velocityTick addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
   
 
}

-(void)addLabels
{
    
    labelTimePlay = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    [labelTimePlay setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [labelTimePlay setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    labelTimePlay.fontSize =36;
    labelTimePlay.fontColor = [UIColor blackColor];
    labelTimePlay.text = @"0";
    [self addChild:labelTimePlay];
    
    
    
    if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {

        if ([defaults boolForKey:@"joystick"]) {
            labelTimePlay.position = CGPointMake(230,(self.frame.size.height - (statusBarSize+blackNodeGameSize.height))/2);
        }else{
            labelTimePlay.position = CGPointMake(90,(self.frame.size.height - (statusBarSize+blackNodeGameSize.height))/2);
        }

        
    }
    else{
        
        
        if ([defaults boolForKey:@"joystick"]) {
            labelTimePlay.position = CGPointMake(230,(self.frame.size.height - (statusBarSize+blackNodeGameSize.height))/2);
        }else{
            labelTimePlay.position = CGPointMake(90,(self.frame.size.height - (statusBarSize+blackNodeGameSize.height))/2);
        }
    }
    
    
    
    if (esModoPuntos) {
        
        labelPointPlay = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
        [labelPointPlay setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
        [labelPointPlay setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        labelPointPlay.fontSize =36;
        labelPointPlay.fontColor = [UIColor blackColor];
        labelPointPlay.text = @"0";
        [self addChild:labelPointPlay];
        
        if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
           
            if ([defaults boolForKey:@"joystick"]) {
                labelPointPlay.position = CGPointMake(230,(self.frame.size.height - (statusBarSize+blackNodeGameSize.height))/2 + 30);
                labelTimePlay.position = CGPointMake(230,(self.frame.size.height - (statusBarSize+blackNodeGameSize.height))/2 - 30);
                
            }else{
                labelPointPlay.position = CGPointMake(90,(self.frame.size.height - (statusBarSize+blackNodeGameSize.height))/2 + 30);
                labelTimePlay.position = CGPointMake(90,(self.frame.size.height - (statusBarSize+blackNodeGameSize.height))/2 - 30);
            }
                
        }
        else{
            
            
            if ([defaults boolForKey:@"joystick"]) {
                labelPointPlay.position = CGPointMake(230,(self.frame.size.height - (statusBarSize+blackNodeGameSize.height))/2 + 30);
                labelTimePlay.position = CGPointMake(230,(self.frame.size.height - (statusBarSize+blackNodeGameSize.height))/2 - 30);
                
            }else{
                labelPointPlay.position = CGPointMake(90,(self.frame.size.height - (statusBarSize+blackNodeGameSize.height))/2 + 30);
                labelTimePlay.position = CGPointMake(90,(self.frame.size.height - (statusBarSize+blackNodeGameSize.height))/2 - 30);
            }
        }
        
    }

}

-(void)crearLabelPuntos:(int)valorPuntos{
    
    labelPuntos = [[SKLabelNode alloc]initWithFontNamed:@"HelveticaNeue-Light"];
    [labelPuntos setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [labelPuntos setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    labelPuntos.fontSize =20;
    labelPuntos.fontColor = [UIColor redColor];
    labelPuntos.text = [[NSString alloc] initWithFormat:@"%d", valorPuntos];
    
    [self addChild:labelPuntos];
    
    tiempoCreacionLabel = tiempoDeJuego;
    
    labelPuntos.position = [self giveMeRandomPositionEscena ];
    
    labelPuntos.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:protagonista.size.height/2];
    labelPuntos.physicsBody.categoryBitMask = pointCategory;
    labelPuntos.physicsBody.collisionBitMask = 0;
    labelPuntos.physicsBody.contactTestBitMask =  pointCategory;

    
    if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
    }
    else{
    }
    
}



-(void)iniciarFisica
{
    
    datos = [self.userData objectForKey:@"datos"] ;
    nivel = datos.dificultad * 1.7;
    esModoPuntos = datos.esPuntos;
    
    [self addLabels];
    
    fuerzoImpulsoInicial = 6.5 + nivel;
    
    [self darFisica:enemigo1 impulso:fuerzoImpulsoInicial];
    [self darFisica:enemigo2 impulso:fuerzoImpulsoInicial];
    [self darFisica:enemigo3 impulso:fuerzoImpulsoInicial];
    [self darFisica:enemigo4 impulso:fuerzoImpulsoInicial];
    
    
    
    juegoComenzo = YES;
}

-(void)darFisica:(SKSpriteNode *)nodo impulso:(float)impulso
{
    
    //añadimos fisica al rectangulo
    nodo.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(nodo.size.width, nodo.size.height)];
    
    nodo.physicsBody.categoryBitMask = enemyCategory;
    nodo.physicsBody.contactTestBitMask = principalCategory;
    nodo.physicsBody.collisionBitMask = backgroundBlackCategory;
    
    // Definimos friccion
    nodo.physicsBody.friction = 0.0f;
    // Definimos capacidad de rebote
    nodo.physicsBody.restitution = 1.0f;
    // Friccion del objeto
    nodo.physicsBody.linearDamping = 0.0f;
    // Posibilidad de rotacion
    nodo.physicsBody.allowsRotation = NO;
    //damos un impulso inicial a la bola
    [nodo.physicsBody applyImpulse:[self giveMeRandomVector:impulso]];
    
}


-(void)joystickMovement
{
    
    
    
    if (joystick.velocity.x != 0 || joystick.velocity.y != 0)
    {
        
        int sensibility = [[defaults objectForKey:@"sensibility"] intValue];
        
      float rango =  (sensibility/360.0)*0.1 + 0.05 ;
        
       protagonista.position = CGPointMake(protagonista.position.x + rango *joystick.velocity.x, protagonista.position.y + rango * joystick.velocity.y);
    }
}




# pragma mark - Metodos aleatorios


-(CGVector)giveMeRandomVector:(float)moduloVector
{
    CGFloat dx,dy;
    do {
        dx = [self randomFloatBetween:1 and:moduloVector];
        dy = sqrtf(pow(moduloVector, 2)-pow(dx, 2));
        
        int paridad1 = rand();
        int paridad2 = rand();
        if (paridad1 % 2 == 0) {
            dx = dx*-1;
        }
        if (paridad2 % 2 ==0) {
            dy = dy*-1;
        }
        
    } while (dy/moduloVector > 0.85 || moduloVector < 0.5);
    
    
    //  NSLog(@"valores del vector,x=%f   y=%f",dx,dy);
    
    return CGVectorMake(dx, dy);
}

-(CGPoint)giveMeRandomPositionEscena
{
    CGPoint puntoAleatorio;
    
    puntoAleatorio = CGPointMake(45 + [self giveMeRandomPoint:230] , self.size.height - statusBarSize - 320 + 45 + [self giveMeRandomPoint:230]);
    
    
    return puntoAleatorio;
}

-(int)giveMeRandomPoint:(int)cantidadModulo
{
    int enteroAleatorio;
    
        enteroAleatorio = rand() % cantidadModulo;

    
    return enteroAleatorio;
    
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

@end
