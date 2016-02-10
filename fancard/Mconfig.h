//
//  Mconfig.h
//  fancard
//
//  Created by MEETStudio on 15-8-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#ifndef fancard_Mconfig_h
#define fancard_Mconfig_h

#define iOS7 ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//Google clientId
#define kClientId @"682762043175-8lcn1pjeanvojna8fi14lkhuaacctri4.apps.googleusercontent.com"

//twitter key and secret
#define consumer_key    @"iFJrhBed9KVOXbrcc7zJ03yFz"
#define consumer_secret @"KHLT2Ugq99Y2HtlgX8wj3I53YRKaFRZwuYl50YzmjPuwfbq68F"

//#define kServerURL @"http://ec2-52-27-33-107.us-west-2.compute.amazonaws.com/phpfancard/API/index.php"
//socketURL
//#define kSocketURL @"ws://52.27.33.107:2346"

//#define kServerURL @"http://192.168.3.3/phpfancard/API/index.php"
//#define kSocketURL @"ws://192.168.3.3:2346"

static NSString *const kServerURL = @"http://ec2-52-27-33-107.us-west-2.compute.amazonaws.com/phpfancard/API/index.php";
static NSString *const kSocketURL = @"ws://52.27.33.107:2346";

//static NSString *const kServerURL = @"http://192.168.3.10/phpfancard/API/index.php";
//static NSString *const kSocketURL = @"ws://192.168.3.10:2346";


#define UIColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorHexAlpha(rgbValue, alphaNum) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaNum]

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;
#define SS(strongSelf) __strong __typeof(&*weakSelf)strongSelf = weakSelf;


/*
 Font
 */
#define kDigitalFont     @"Digital-7Mono"
#define kAsapBoldFont    @"Asap-Bold"
#define kAsapRegularFont @"Asap-Regular"

//Color
#define kMyRedColor [UIColor colorWithRed:148.0 / 255.0 green:18.0/255.0 blue:26.0 / 255.0 alpha:1.0f]
#define kLevelGray  [UIColor colorWithRed:46.0 / 255.0 green:46.0 / 255.0 blue:46.0 / 255.0 alpha:1.0f]
#define kMyBlue     [UIColor colorWithRed:17.0f/255.0f green:-0 blue:254.0f/255.0f alpha:1.0f]
#define KNewHeader  [UIColor colorWithRed:44.0/255.0 green:151.0/255.0 blue:223.0/255.0 alpha:1.0]
/*   audio:
 */
#define kTimeRunningOut @"Time Running Out.mp3"
#define kCountDown      @"CountDown.mp3"
#define kDribble        @"Clickable-Button-Dribble.mp3"
#define kWhistle        @"Unclickable-Button-Whistle.mp3"
#define kBucketsFaDays  @"Buckets Fa Days.mp3"
#define kBallin         @"Ballin.mp3"
#define kAfter3rdQua    @"After 3rd Quarter.mp3"
#define kWelcome        @"Welcome to the MG.mp3"
#define kChallengeAlert @"Challenge Alert.mp3"
#define kSendChallenge  @"Send Challenge.mp3"
#define kBeenWaiting    @"Been Waiting All Day.mp3"

#define kDateFormat @"yyyy-MM-dd HH:mm:ss"

//socket
#define kSocketNotification @"socketNotification"

#ifdef DEBUG
#define LLog(format, ...) NSLog((@"%s Line:%d Log: " format), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#else
#define LLog(format, ...)
#endif

#endif
