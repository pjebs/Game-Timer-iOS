//
//  GameTimer.h
//
//  Version 1.0
//
//  Copyright (c) 2013 PJ Engineering and Business Solutions Pty. Ltd.
//  All rights reserved.
//  enquiries@pjebs.com.au
//

//GameTimer incorporates 2 timers - referred to as longTimer and shortTimer.
//The longTimer MUST have a longer timer duration than the shortTimer.
//If that is not the case, then the behaviour of GameTimer is indeterminate and unpredictable.
//The shortTimer acts as a 'finer' resolution timer that can be used to update a progressbar or
//continually poll a network connection (for example). It's interval is usually set to a fraction
//of the longTimer.
//
//Example: The longTimer can be set to 2 minutes (i.e. the time to boil an egg). The shortTimer can be
//set to 1 second so the progressbar updates every 1 second. This represents a fraction of 1/120.
//
//GameTimer automatically pauses when the app enters the BACKGROUND and 'unpauses' when the app is
//ACTIVE again.


#import <Foundation/Foundation.h>
@protocol GameTimerDelegate;

@interface GameTimer : NSObject


//The 'finer' resolution timer duration. This must be less than longInterval.
//The behaviour of GameTimer is unpredictable otherwise.
//The units are in seconds. It can be as small as 0.1 milliseconds.
@property float shortInterval;

//The overall timer duration. When this timer expires, then GameTimer deactivates by itself.
//It automatically cleans its memory after deactivating the shortTimer AND longTimer.
//The units are in seconds. It can be as small as 0.1 milliseconds.
@property float longInterval;

//The amount of time in seconds since GameTimer was started
//excluding when the app enters the background state.
@property (nonatomic, readonly) float time;

//The delegate must respond to longTimerExpired: method. This is mandatory.
//It is called when the longTimer expires.
@property(nonatomic, weak) IBOutlet id <GameTimerDelegate> delegate;

//This method is used to initialise GameTimer. GameTimer MUST NOT be initialised using init:
//Initialising GameTimer does not start the timer.
//
//An example:
//  self.gameTimer = [[GameTimer alloc] initWithLongInterval:2*60 andShortInterval:0.5 andDelegate:self];
//
//The above example will create a GameTimer with a longInterval of 120 seconds. It will fire the
//shortTimerExpired: method every 0.5 seconds.
//
//Always allocate GameTimer to the instance variable ONCE (such as in viewDidLoad method). If you need to
//change the settings, stop the timer and then do so using the instance variables
//(i.e. self.gameTimer.longInterval = 3*60;) and then start the timer (i.e. [self.gameTimer start];)
//If you need to deallocate GameTimer, then stop GameTimer first.
//(i.e. [self.gameTimer stop]; self.gameTimer = nil;)
//
//WARNING: If the reference to the newly created gameTimer is changed to point to a BRAND new gameTimer alloc,
//then you must call the 'stopTimer' before reallocating. This is because NSRunLoop keeps a strong reference.
//An example (CORRECT WAY - EVEN THOUGH I RECOMMEND NEVER REALLOCATING):
//  self.gameTimer = [[GameTimer alloc] initWithLongInterval:2*60 andShortInterval:0.5 andDelegate:self]; //First allocation
//  [self.gameTimer stop]; //Even if self.gameTimer is declared as a 'strong' reference, the original does not deallocate
//  self.gameTimer = [[GameTimer alloc] initWithLongInterval:5 andShortInterval:2 andDelegate:self]; //Second BRAND NEW allocation
- (id)initWithLongInterval:(float)longInterval andShortInterval: (float)shortInterval andDelegate:(id <GameTimerDelegate>) delegate;

//Stops the timer. This MUST be called from the same thread that called the startTimer method.
- (void) stopTimer;

//Restarts the timer.
- (void) startTimer;

//Pauses the timer
-(void)pauseTime;

//Unpauses the timer
-(void)unPauseTime;

@end


@protocol GameTimerDelegate <NSObject>

@required
//This method is fired when the longTimer expires. GameTimer will stop at this point. You will need to
//call the startTimer method to restart the timer. It is MANDATORY for the delegate to implement this.
-(void)longTimerExpired: (GameTimer *)gameTimer;

@optional
//This method is fired when the shortTimer expires. It will continue to fire until the longTimer expires,
//at which point GameTimer will stop. It is OPTIONAL for the delegate to implement this.
//In order to update a progressbar, this method should be implemented and used in conjunction with
//the 'time' value and the 'longInterval' value.
//The method is not expected to fire at precise moments. It is only for tasks such as updating, polling etc.
-(void)shortTimerExpired: (GameTimer *)gameTimer time: (float)time longInterval: (float)longInterval;
@end

