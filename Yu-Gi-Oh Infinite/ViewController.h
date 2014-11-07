//
//  ViewController.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 23/02/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtilities.h"
#import "UIMainMenuView.h"

@interface ViewController : UIViewController <AVAudioSessionDelegate>{
    MPMoviePlayerViewController *playerViewController;
    UIButton* startButton;
    CGRect frame;
    
    UIMainMenuView* mainMenuView;
}

@end
