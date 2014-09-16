
// 1. macro that check if the device is iPhone5
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)

// 2. log output
#ifdef DEBUG
// debug
#define MyLog(...) NSLog(__VA_ARGS__)
#else
// release
#define MyLog(...)
#endif

// cell border width
#define kCellBorderWidth 10
// tableview border width
#define kTableBorderWidth 8
// cell margin
#define kCellMargin 8
// cell dock height
#define kStatusDockHeight 30
// set height for retweet dock
#define kRetweetDockHeight 35

// cell subview config
#define kScreenNameFont [UIFont systemFontOfSize:15]
#define kTimeFont [UIFont systemFontOfSize:13]
#define kSourceFont kTimeFont
#define kTextFont [UIFont systemFontOfSize:15]
#define kRetweetedTextFont [UIFont systemFontOfSize:15]
#define kRetweetedScreenNameFont [UIFont systemFontOfSize:15]

// get rgb color
#define kColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

// global background color
#define kGlobalBg kColor(230, 230, 230)

// membership screen name color
#define kMBScreenNameColor kColor(243, 101, 18)
// non-membership screen name color
#define kScreenNameColor kColor(93, 93, 93)
// retweet screen name color
#define kRetweetSceenNameColor kColor(63, 104, 161)

// membership icon size
#define kMBIconWidth 14
#define kMBIconHeight 14
// profile small image size
#define kIconSmallWidth 34
#define kIconSmallHeight 34
// profile default image size
#define kIconDefaultWidth 50
#define kIconDefaultHeight 50
// profile big image size
#define kIconBigWidth 85
#define kIconBigHeight 85
// verification image size
#define kVerifyIconWidth 18
#define kVerifyIconHeight 18

// remove scroll bar
#define kHideScrollBar - (void)viewDidAppear:(BOOL)animated { }








