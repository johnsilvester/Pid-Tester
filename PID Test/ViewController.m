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
    
    self.P = 20;
    self.I = .5;
    
    
}
//set up gravity
-(void)applyForce{ //gravit is applied horizantally.
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];


    UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc]initWithItems:@[self.ball]];
    item.friction = 10;
    item.density = 0;
    item.resistance = .8;
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
    
        self.windMagnitude = diffP + diffI;
    
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




- (IBAction)pStepper:(UIStepper*)sender {
    self.P =sender.value;
    self.pLabel.text = [NSString stringWithFormat:@"%f",self.P];
}

- (IBAction)iStepper:(UIStepper*)sender {
    self.I =sender.value/10;
    self.iLabel.text = [NSString stringWithFormat:@"%f",self.I];
}
@end
