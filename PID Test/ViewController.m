//
//  ViewController.m
//  PID Test
//
//  Created by John Silvester on 3/18/17.
//  Copyright © 2017 FlyPhone. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController
int counter = 0;
double diffI = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.ball.layer.cornerRadius = self.ball.frame.size.width/2;
    
    self.loopIsRunning = true;
    
    [self setInitValues];
    
    [self applyForce]; //apply basic gravity.
    

    self.loopIsRunning = true;
   
  NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(loop) userInfo:nil repeats:YES];
    
 

    
}
-(void)viewDidAppear:(BOOL)animated{
    //run PID
    
}

-(void)setInitValues{
    
    self.windMagnitude = .2;
    
    self.setLocation = self.ball.center.x;
    self.direction = CGVectorMake(1.0, 0.0);
    
    self.P = 2;
    self.I = .5;
    
    
}
//set up gravity
-(void)applyForce{ //gravit is applied horizantally.
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];


    UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc]initWithItems:@[self.ball]];
    item.friction = 10;
    item.density = 1;
    item.resistance = 7;
    item.elasticity = 0;
    
    UIPushBehavior *pushBehvaior = [[UIPushBehavior alloc]initWithItems:@[self.ball] mode:UIPushBehaviorModeInstantaneous];
    
    pushBehvaior.pushDirection = self.direction;
    pushBehvaior.magnitude = 1;
    
    
    [_animator addBehavior:pushBehvaior];
    [_animator addBehavior:item];

    
 
    
    
    
}



#pragma mark - PID

-(void)loop{
    
    counter++;
    
        self.actualLocation = self.ball.center.x;
        
        double diff =  self.setLocation - self.actualLocation;
    
        double diffP = diff * self.P;
    
        diffI += diff;
    
        diffI = self.I * diffI;
    
        self.windMagnitude = (diffP + diffI)/2;
    
        double direction = self.windMagnitude;
    
        self.windMagnitude = 1;
    
        self.direction = CGVectorMake(direction, 0);
    
 
        
        [self forceChecker];
    
    

}

-(void)forceChecker{
    
    if (_animator.behaviors.count > 2) {
        
        [_animator removeBehavior:[_animator.behaviors objectAtIndex:_animator.behaviors.count-1]];
        
    } else{
    
        [self applyForce];

    }
    
    
}
#pragma mark - PID in C //probabaly not using
-(void)examplePID{
    
    // Declare de new object
    qPID controller;
    
    // Configure settings
    controller.AntiWindup = DISABLED;
    controller.Bumpless = DISABLED;
    
    // Set mode to auotmatic (otherwise it will be in manual mode)
    controller.Mode = AUTOMATIC;
    
    
    // Configure de output limits for clamping
    controller.OutputMax = 1000;
    controller.OutputMin = -1000;
    
    // Set the rate at the PID will run in seconds
    controller.Ts = 0.005;
    
    // More settings
    controller.b = 1.0;
    controller.c = 1.0;
    
    // Init de controller
    qPID_Init(&controller);
    
    // Set the tunning constants
    controller.K = 0.5;
    controller.Ti = 1/0.02;
    controller.Td = 0.0;
    controller.Nd = 4.0;
    
  //  while (1){
        
        
        //sensor = readSensor();				// update the process variable
        //setPoint = readSetPoint(); 			// update the user desired value
        
        // Update the PID and get the new output
        float output = qPID_Procees(&controller, self.setLocation, self.actualLocation);
        
        //replace method setActuator(output); // update the actuator input
        
        self.direction = CGVectorMake(output*1.4, 0);
    
        
   // }
    
}


#pragma mark - actions


- (IBAction)pStepper:(UIStepper*)sender {
    self.P =sender.value;
    self.pLabel.text = [NSString stringWithFormat:@"%f",self.P];
}

- (IBAction)iStepper:(UIStepper*)sender {
    self.I =sender.value/10;
    self.iLabel.text = [NSString stringWithFormat:@"%f",self.I];
}

@end
