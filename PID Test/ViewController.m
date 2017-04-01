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
double screenX;
double screenY;
double mouseX;
double mouseY;
double homeX;
double homeY;
double calcDX;
double calcDY;

/*working variables*/
long lastTime_x;
double Input_x, Output_x, Setpoint_Gain_x =0;
double ITerm_x, lastInput_x;
long lastTime_y;
double Input_y, Output_y, Setpoint_Gain_y;
double ITerm_y, lastInput_y;
double kp = 1.2;
double ki = .5;
double kd = 0.1;
long SampleTime = 10; //.1 sec
double outMin = 0;
double outMax = 1000;
bool inAuto = true;
#define MANUAL 0
#define AUTOMATIC 1
#define DIRECT 0
#define REVERSE 1

int controllerDirection = DIRECT;





- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *currentTime = [NSDate date];

    lastTime_x = lastTime_y = currentTime.timeIntervalSince1970;
    
    screenX = self.view.frame.size.width;
    screenY = self.view.frame.size.height;
    
    homeX = screenX/2;
    homeY = screenY/2;
    
    mouseX =screenX/2;
    mouseY = screenY/2;
    
    
    // Do any additional setup after loading the view, typically from a nib.
    self.ball.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.ball.layer.cornerRadius = self.ball.frame.size.width/2;
    self.goalButton.layer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    self.goalButton.layer.borderWidth = 5;
    
    [self ForceInit];
    
    //the 300ms paint timer line 102
    NSTimer *pidTimer = [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(loop) userInfo:nil repeats:YES]; //rather than while loop using timer to run PID function, for debug purposes
    
    //mouse listener line 104
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGesture];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:gesture];
   
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    //run PID
   
}

-(void)handlePan:(UIPanGestureRecognizer*)pan{
    mouseX = [pan locationInView:self.view].x;
    mouseY = [pan locationInView:self.view].y;
    
}
//set up gravity
-(void)applyForce{ //gravit is initially applied horizantally.
    
    //NOTE: applyForce is called everytime the loop runs but runs with updated values based on PID loop
    
    
    //_animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    
    UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc]initWithItems:@[self.ball]]; // add physics behaviors on ball
    item.friction = 10;
    item.density = 1;
    item.resistance = 3;
    item.elasticity = 0;
    
    UIPushBehavior *pushBehvaior = [[UIPushBehavior alloc]initWithItems:@[self.ball] mode:UIPushBehaviorModeInstantaneous];
    
    pushBehvaior.pushDirection = self.direction; // create a push with a basic direction of CGVectorMake(1.0, 0.0);
    pushBehvaior.magnitude = self.windMagnitude; //keep constant speed of one
    
    
    [_animator addBehavior:pushBehvaior];
    [_animator addBehavior:item]; // adds the behaviors and excutes.
    
    
    
    
    
    
}

-(void)ForceInit{ //gravit is initially applied horizantally.
    
    //NOTE: applyForce is called everytime the loop runs but runs with updated values based on PID loop
    
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.direction = CGVectorMake(1, 0);
    self.windMagnitude = 1;
    
    UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc]initWithItems:@[self.ball]]; // add physics behaviors on ball
    item.friction = 10;
    item.density = 1;
    item.resistance = 3;
    item.elasticity = 0;
    
    UIPushBehavior *pushBehvaior = [[UIPushBehavior alloc]initWithItems:@[self.ball] mode:UIPushBehaviorModeContinuous];
    
    pushBehvaior.pushDirection = self.direction; // create a push with a basic direction of CGVectorMake(1.0, 0.0);
    pushBehvaior.magnitude = self.windMagnitude; //keep constant speed of one
    
    
    [_animator addBehavior:pushBehvaior];
    [_animator addBehavior:item]; // adds the behaviors and excutes.
    

}

-(void)loop{
    
    Input_x = self.view.frame.size.width/2;
    Input_y = self.view.frame.size.height/2;
    
    Setpoint_Gain_x = 100;
    Setpoint_Gain_y = 100;
    
    [self computeX];
    [self computeY];
    
    calcDX = (int)Output_x + self.view.frame.size.width/2;
    calcDY = (int)Output_y + self.view.frame.size.height/2;
    
    NSLog(@"PID Output Values: X - %f Y - %f", Output_x, Output_y);
    NSLog(@"PID  Input Values: X - %f Y - %f", Input_x, Input_y);
    NSLog(@"calc'd  X - %f Y - %f", calcDX, calcDY);
    
    
}

#pragma mark - PID

-(void)computeX{
    
    
//    if(!inAuto) return;
//    NSDate *currentTime = [NSDate date];
//    long now = currentTime.timeIntervalSince1970;
//    long timeChange = (now - lastTime_x);
//    NSLog(@"compute Loop TC %ld",timeChange);
//    
//    if(timeChange>=SampleTime)
//        
//    {
        /*Compute all the working error variables*/
        double error = Setpoint_Gain_x - Input_x;
        
        ITerm_x+= (ki * error);
        if(ITerm_x> outMax) ITerm_x= outMax;
        else if(ITerm_x< outMin) ITerm_x= outMin;
        double dInput = (Input_x - lastInput_x);
        
        /*Compute PID Output*/
        Output_x = kp * error + ITerm_x- kd * dInput;
        if(Output_x > outMax) Output_x = outMax;
        else if(Output_x < outMin) Output_x = outMin;
        NSLog(@"%f",Output_x);
        /*Remember some variables for next time*/
        lastInput_x = Input_x;
       // lastTime_x = now;
        
    
}

-(void)computeY{
    
    
    if(!inAuto) return;
    NSDate *currentTime = [NSDate date];
    long now = currentTime.timeIntervalSince1970;
    long timeChange = (now - lastTime_y);
    NSLog(@"compute Loop TC %ld",timeChange);
    
    if(timeChange>=SampleTime)
        
    {
        /*Compute all the working error variables*/
        double error = Setpoint_Gain_y - Input_y;
        
        ITerm_y+= (ki * error);
        if(ITerm_y> outMax) ITerm_y= outMax;
        else if(ITerm_y< outMin) ITerm_y= outMin;
        double dInput = (Input_y - lastInput_y);
        
        /*Compute PID Output*/
        Output_y = kp * error + ITerm_y- kd * dInput;
        if(Output_y > outMax) Output_y = outMax;
        else if(Output_y < outMin) Output_y = outMin;
        
        /*Remember some variables for next time*/
        lastInput_y = Input_y;
        lastTime_y = now;
        
    }
}



-(void)SetTunings: (double) Kp :(double) Ki :(double) Kd{
    
    if (Kp<0 || Ki<0|| Kd<0) return;
    
    double SampleTimeInSec = ((double)SampleTime)/1000;
    kp = Kp;
    ki = Ki * SampleTimeInSec;
    kd = Kd / SampleTimeInSec;
    
    if(controllerDirection == REVERSE)
    {
        kp = (0 - kp);
        ki = (0 - ki);
        kd = (0 - kd);
    }
    
}

-(void)setSampleTime: (long) NewSampleTime{
    
    if (NewSampleTime > 0)
    {
        double ratio  = (double)NewSampleTime
        / (double)SampleTime;
        ki *= ratio;
        kd /= ratio;
        SampleTime = (long)NewSampleTime;
    }
}


-(void) setOutpitLimits: (double)Min :(double)Max{
    
    if(Min > Max) return;
    outMin = Min;
    outMax = Max;
    
    if(Output_x > outMax) Output_x = outMax;
    else if(Output_x < outMin) Output_x = outMin;
    
    if(ITerm_x > outMax) ITerm_x= outMax;
    else if(ITerm_x < outMin) ITerm_x= outMin;
    
    if(Output_y > outMax) Output_y = outMax;
    else if(Output_y < outMin) Output_y = outMin;
    
    if(ITerm_y > outMax) ITerm_y= outMax;
    else if(ITerm_y < outMin) ITerm_y= outMin;
    
}

-(void)initialize{
    lastInput_x = Input_x;
    ITerm_x = Output_x;
    if(ITerm_x > outMax) ITerm_x= outMax;
    else if(ITerm_x < outMin) ITerm_x= outMin;
    lastInput_y = Input_y;
    ITerm_y = Output_y;
    if(ITerm_y > outMax) ITerm_y= outMax;
    else if(ITerm_y < outMin) ITerm_y= outMin;
}

-(void)setControllerDirection:(int)direction{
    controllerDirection = direction;
}


-(void)forceChecker{ //failsafe not to break the UIDynamicAnimator
    
    
   
 
    
}



#pragma mark - actions


- (IBAction)pStepper:(UIStepper*)sender {
  
}

- (IBAction)iStepper:(UIStepper*)sender {
 
}

- (IBAction)buttonRandom:(UIButton *)sender {
    
    [self loop];
    
  
}

- (IBAction)callPID:(id)sender {
    
    
    
    
}
@end
