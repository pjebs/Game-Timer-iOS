Purpose
--------------

GameTimer is a light-weight timer that you can use for iOS games. It can be enhanced easily for more complex projects. One use is to update a progressbar whilst the main timer is running.

GameTimer incorporates 2 timers that work in unison - referred to as *longTimer* and *shortTimer*.
The *shortTimer* acts as a 'finer' resolution timer that can be used to update a progressbar or continually poll a network connection (for example). It's interval is usually set to a fraction of the longTimer.

GameTimer automatically pauses when the app enters the BACKGROUND and 'unpauses' when the app is ACTIVE again.


Supported OS & SDK Versions
-----------------------------

* Supported build target - iOS 7.0 
* Earliest supported deployment target - iOS 6.0 

ARC Compatibility
------------------

GameTimer requires ARC.

If you wish to convert your whole project to ARC, then run the Edit > Refactor > Convert to Objective-C ARC... tool in Xcode and make sure all files that you wish to use ARC for are checked.

Thread Safety
--------------

The **stopTimer** method **must** be called from the same thread that called the **startTimer** method.

Installation
--------------

To install GameTimer into your app, drag the **GameTimer.h** and **GameTimer.m** files into your project.

Add:
```
#import "GameTimer.h"
```
to the top of any class (*.h or *.m) that will use GameTimer.

Make sure the class conforms to the GameTimerDelegate protocol:

Modify .h file:

	@interface ViewController : UIViewController <GameTimerDelegate>

Implement Protocol methods such as:

``` 
-(void)longTimerExpired: (GameTimer *)gameTimer
{
    //Time is up
}
```

Declare a instance variable/property:

```
@property (strong, nonatomic) GameTimer *gameTimer;
```

Initialise the timer in a method such as **viewDidLoad**:

```
self.gameTimer = [[GameTimer alloc] initWithLongInterval:2*60 andShortInterval:5 andDelegate:self]; //2 minute timer with short intervals of 5 seconds
```

Start the timer when you want to start:

```
[self.gameTimer startTimer];
```

Stop the timer prematurely if required:

```
[self.gameTimer stopTimer];
```

Properties
--------------

The 'finer' resolution timer duration. This must be less than *longInterval*.
The behaviour of GameTimer is unpredictable otherwise.
The units are in seconds. It can be as small as 0.1 milliseconds.

    @property float shortInterval;

The overall timer duration. When this timer expires, then GameTimer deactivates by itself.
It automatically cleans it's memory after deactivating the *shortTimer* **and** *longTimer*.
The units are in seconds. It can be as small as 0.1 milliseconds.

    @property float longInterval;

The amount of time in seconds since GameTimer was started, excluding when the app enters the BACKGROUND state.

    @property (nonatomic, readonly) float time;

The delegate must respond to **longTimerExpired:** method. This is **mandatory**.
It is called when the *longTimer* expires.

    @property(nonatomic, weak) IBOutlet id <GameTimerDelegate> delegate;


Methods
--------------

This method is used to initialise GameTimer. GameTimer **MUST NOT** be initialised using **init**:
Initialising GameTimer does not automatically begin the timer.

An example:

```
self.gameTimer = [[GameTimer alloc] initWithLongInterval:2*60 andShortInterval:0.5 andDelegate:self];
```

The above example will create a GameTimer with a *longInterval* of 120 seconds. It will fire the
**shortTimerExpired:** method every 0.5 seconds.

Always allocate GameTimer to the instance variable **ONCE** (such as in **viewDidLoad** method). If you need to
change the settings, stop the timer and then do so using the properties i.e. 

```
[self.gameTimer stop];
self.gameTimer.longInterval = 3*60; //change settings
[self.gameTimer start]; //then start the timer
```

If you need to deallocate GameTimer, then stop GameTimer first.
i.e. 
```
[self.gameTimer stop];
self.gameTimer = nil;
```

Class Initializer.

    - (id)initWithLongInterval:(float)longInterval andShortInterval: (float)shortInterval 
	andDelegate:(id <GameTimerDelegate>) delegate;

Stops the timer. This **MUST** be called from the same thread that called the **startTimer** method.

    - (void) stopTimer;

Restarts the timer.

    - (void) startTimer;

Pauses the timer

    -(void)pauseTime;

Unpauses the timer

    -(void)unPauseTime;


Delegate methods
---------------

This method is fired when the *longTimer* expires. GameTimer will stop at this point. You will need to
call the **startTimer** method to restart the timer. It is **mandatory** for the delegate to implement this.

    -(void)longTimerExpired: (GameTimer *)gameTimer;

This method is fired when the *shortTimer* expires. It will continue to fire until the *longTimer* expires,
at which point GameTimer will stop. It is **optional** for the delegate to implement this.
In order to update a progressbar, this method should be implemented and used in conjunction with
the *time* value and the *longInterval* value.
The method is not expected to fire at precise moments. It is only for tasks such as updating, polling etc.

    -(void)shortTimerExpired: (GameTimer *)gameTimer time: (float)time longInterval: (float)longInterval;


Example Projects
---------------

The example project will demonstrate how to use the basic features of the class. It will update a progressbar.
Obviously it can be extended to your game engine for example. Imagination is the key.


Known Issues
---------------

**WARNING:** If the reference to the newly created gameTimer is changed to point to a **brand** new [GameTimer alloc],
then you must call the **stopTimer** method before reallocating. This is because **NSRunLoop** keeps a strong reference.

An example (CORRECT WAY - EVEN THOUGH I RECOMMEND NEVER REALLOCATING):

```
  self.gameTimer = [[GameTimer alloc] initWithLongInterval:2*60 andShortInterval:0.5 andDelegate:self]; //First allocation
  [self.gameTimer stop];
  self.gameTimer = [[GameTimer alloc] initWithLongInterval:5 andShortInterval:2 andDelegate:self]; //Second NEW allocation
```


Any Questions
---------------

Feel Free to suggest improvements, fork, report bugs or ask any questions.

PJ Engineering and Business Solutions Pty. Ltd
http://www.pjebs.com.au
