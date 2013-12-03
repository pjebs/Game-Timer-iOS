//
//  ViewController.m
//  Example
//
//  Created by PJ on 2/12/13.
//
//

#import "ViewController.h"



@interface ViewController ()

    @property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
    @property (strong, nonatomic) GameTimer *gameTimer;
    @property float timerDuration;

    - (IBAction)play:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.timerDuration = 1; //The timer is set to 2 minutes
	self.gameTimer = [[GameTimer alloc] initWithLongInterval:self.timerDuration*60 andShortInterval:5 andDelegate:self];
}

- (IBAction)play:(id)sender
{
    [self.gameTimer startTimer];
}

- (void)dealloc
{
    //Since self.gameTimer is a 'strong' property we need to set it to nil to release memory.
    self.gameTimer = nil;
}

#pragma mark - GameTimer delegate methods

-(void)longTimerExpired: (GameTimer *)gameTimer
{
    //Time is up
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GameTimer" message:@"Time is Up" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)shortTimerExpired: (GameTimer *)gameTimer time:(float)time longInterval:(float)longInterval
{
    NSLog(@"Short Timer Fired %f", time);
    //Update progress bar
    [UIView setAnimationsEnabled:NO];
    self.progressBar.progress = time/longInterval;
    [UIView setAnimationsEnabled:YES];
}
@end
