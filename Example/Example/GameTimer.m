//
//  GameTimer.m
//
//  Version 1.0
//
//  Copyright (c) 2013 PJ Engineering and Business Solutions Pty. Ltd.
//  All rights reserved.
//  enquiries@pjebs.com.au
//

#import "GameTimer.h"

@interface GameTimer ()
{
    NSDate *startingTime;
    NSDate *tempDate;
    BOOL currentlyPaused;
}

@property (strong, nonatomic) NSTimer *longTimer;
@property (strong, nonatomic) NSTimer *shortTimer;

-(void)longTimerExpired;
-(void)shortTimerExpired;

@end

@implementation GameTimer

- (id)initWithLongInterval:(float)longInterval andShortInterval: (float)shortInterval andDelegate:(id <GameTimerDelegate>) delegate;
{
    self = [super init];
    
    if (self)
    {
        self.shortInterval = shortInterval;
        self.longInterval = longInterval;
        self.delegate = delegate;
        startingTime = nil;
        tempDate = nil;
        currentlyPaused = NO;
    }
    
    return self;
}

- (float) time
{
    return -[startingTime timeIntervalSinceNow];
}

-(void)longTimerExpired
{
    [self stopTimer];
    [self shortTimerExpired];
    if ([self.delegate respondsToSelector:@selector(longTimerExpired:)])
    {
        [self.delegate longTimerExpired:self];
    }
}

-(void)shortTimerExpired
{
    if ( (self.longTimer != nil) && ([self.delegate respondsToSelector:@selector(shortTimerExpired:time:longInterval:)]) )
    {
        [self.delegate shortTimerExpired:self time:self.time longInterval:self.longInterval];
    }
}

- (void) stopTimer
{
    [self.shortTimer invalidate];
    [self.longTimer invalidate];
    self.longTimer = nil;
    self.shortTimer = nil;
    startingTime = nil;
    currentlyPaused = NO;
    tempDate = nil;
    
    //Remove Notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) startTimer
{
    [self stopTimer];
    self.shortTimer = [NSTimer scheduledTimerWithTimeInterval:self.shortInterval target:self selector:@selector(shortTimerExpired) userInfo:nil repeats:YES];
    self.longTimer = [NSTimer scheduledTimerWithTimeInterval:self.longInterval target:self selector:@selector(longTimerExpired) userInfo:nil repeats:NO];
    startingTime = [[NSDate alloc] init];
    
    currentlyPaused = NO;
    tempDate = nil;
    
    //Start Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseTime) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unPauseTime) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)pauseTime
{
    [self.longTimer invalidate];
    self.longTimer = nil;
    
    if (currentlyPaused == NO) tempDate = [[NSDate alloc] init];
    currentlyPaused = YES;
}

-(void)unPauseTime
{
    if (currentlyPaused == NO) return;
        
    NSTimeInterval totalElapsedTime = [startingTime timeIntervalSinceNow];
    
    NSTimeInterval elapsedPauseTime = [tempDate timeIntervalSinceNow];
    startingTime = [startingTime dateByAddingTimeInterval:-elapsedPauseTime];
    tempDate = nil;
    
    //Create new longTimer
    self.longTimer = [NSTimer scheduledTimerWithTimeInterval:(self.longInterval + totalElapsedTime - elapsedPauseTime) target:self selector:@selector(longTimerExpired) userInfo:nil repeats:NO];
    
    [self shortTimerExpired];
}

- (void)dealloc
{
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.shortTimer invalidate];
    [self.longTimer invalidate];
    self.longTimer = nil;
    self.shortTimer = nil;
}

@end
