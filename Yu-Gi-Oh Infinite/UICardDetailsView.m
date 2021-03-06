//
//  UICardDetailsView.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 18/03/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "UICardDetailsView.h"

#define BASE_WINDOW_HEIGHT 320
#define BASE_WINDOW_WIDTH  480

#define BASE_CARD_LEFT_MARGIN    10
#define BASE_CARD_HEIGHT         300
#define BASE_CARD_PICTURE_WIDTH  419
#define BASE_CARD_PICTURE_HEIGHT 610

#define BASE_ANIMATION_MOVEMENT 1000

#define ANIMATION_DURATION 0.7

@implementation UICardDetailsView

-(void)calculateBaseBlockWidth{
    CGRect card = cardPlayer.frame;
    blockStartX = card.origin.x*2 + card.size.width;
    baseBlockWidth = windowFrame.size.width - card.origin.x - blockStartX;
}
-(CGRect)generateRectOf:(CGRect)position{
    CGFloat x = blockStartX + (position.origin.x*baseBlockWidth)/BASE_WINDOW_WIDTH;
    CGFloat y = cardPlayer.frame.origin.y + (position.origin.y*windowFrame.size.height)/BASE_WINDOW_HEIGHT;
    CGFloat w = (baseBlockWidth*position.size.width)/BASE_WINDOW_WIDTH;
    CGFloat h = (position.size.height*windowFrame.size.height)/BASE_WINDOW_HEIGHT;
    return CGRectMake(x,y,w,h);
}
-(CGRect)slideToLeft:(CGRect)frame{
    return CGRectMake(frame.origin.x-BASE_ANIMATION_MOVEMENT,frame.origin.y,frame.size.width,frame.size.height);
}
-(CGRect)slideToRight:(CGRect)frame{
    return CGRectMake(frame.origin.x+BASE_ANIMATION_MOVEMENT,frame.origin.y,frame.size.width,frame.size.height);
}

-(UITextField*)generateTextFieldAt:(CGRect)position{
    CGRect newPos = [self generateRectOf:position];
    UITextField* result = [[UITextField alloc] initWithFrame:newPos];
    [result setTextColor:[UIColor whiteColor]];
    [result adjustsFontSizeToFitWidth];
    return result;
}
-(UITextView*)generateTextViewAt:(CGRect)position{
    CGRect newPos = [self generateRectOf:position];
    UITextView* result = [[UITextView alloc] initWithFrame:newPos];
    [result setTextColor:[UIColor whiteColor]];
    [result setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
    result.textAlignment = NSTextAlignmentJustified;
    result.editable = NO;
    return result;
}

-(void)initCard:(UIImage*)cardImage{
    CGFloat h = (BASE_CARD_HEIGHT*windowFrame.size.height)/BASE_WINDOW_HEIGHT;
    CGFloat w = (h*BASE_CARD_PICTURE_WIDTH)/BASE_CARD_PICTURE_HEIGHT;
    CGFloat x = (BASE_CARD_LEFT_MARGIN*windowFrame.size.width)/BASE_WINDOW_WIDTH;
    CGFloat y = windowFrame.origin.y + windowFrame.size.height/2 - h/2;
    
    cardPlayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FaceDown"]];
    [cardPlayer setFrame:CGRectMake(x,y,w,h)];
    [cardPlayer setImage:cardImage];
    [self addSubview:cardPlayer];
}
-(void)loadBackground{
    CGFloat scale = (0.3*windowFrame.size.height)/BASE_WINDOW_HEIGHT;
    UIImage *passwordFrame = [UIImage imageNamed:@"passwordFrame"];
    passwordFrame = [passwordFrame imageWithScaledRate:scale];
    passwordFrame = [passwordFrame imageWithCapInsets];
    
    BGType = [[UIImageView alloc] initWithFrame:[self generateRectOf:CGRectMake(0,0,BASE_WINDOW_WIDTH,45)]];
    [BGType setImage:passwordFrame];
    [self addSubview:BGType];
    
    BGGuardianStar = [[UIImageView alloc] initWithFrame:[self generateRectOf:CGRectMake(0,45,BASE_WINDOW_WIDTH,90)]];
    [BGGuardianStar setImage:passwordFrame];
    [self addSubview:BGGuardianStar];
    
    BGDescription = [[UIImageView alloc] initWithFrame:[self generateRectOf:CGRectMake(0,135,BASE_WINDOW_WIDTH,166)]];
    [BGDescription setImage:passwordFrame];
    [self addSubview:BGDescription];
}
-(void)loadTexts{
    CGRect frameBase;
    CGFloat space;
    CGFloat windowHeight = windowFrame.size.height;
    
    frameBase = [self generateRectOf:CGRectMake(0,12,0,0)];
    UIImage* icon = [playerCard getTypeIcon];
    if (icon){
        typeIcon = [[UIImageView alloc] initWithImage:icon];
        [typeIcon setFrame:CGRectMake(frameBase.origin.x+windowHeight/25, frameBase.origin.y, windowHeight/15, windowHeight/15)];
        [self addSubview:typeIcon];
    }
    
    typeText = [self generateTextFieldAt:CGRectMake(0,0,BASE_WINDOW_WIDTH,45)];
    frameBase = typeText.frame;
    [typeText setFrame:CGRectMake(frameBase.origin.x + 10*windowHeight/75, frameBase.origin.y, frameBase.size.width, frameBase.size.height)];
    [typeText setText:[[playerCard type] componentsSeparatedByString:@" "][0]];
    typeText.font = [UIFont systemFontOfSize:windowHeight/20];
    [self addSubview:typeText];
    
    if ([playerCard isMonster]){
        CGFloat textY;
        CGFloat side = windowFrame.size.height/20;
        space =  windowFrame.size.height/9;
        
        //Guardian Star Text
        guardianStarText = [self generateTextFieldAt:CGRectMake(0,45,BASE_WINDOW_WIDTH/2,45)];
        [guardianStarText setText:@"GUARDIAN STAR"];
        guardianStarText.font = [UIFont systemFontOfSize:windowHeight/20];
        frameBase = guardianStarText.frame;
        [guardianStarText setFrame:CGRectMake(frameBase.origin.x+3*windowHeight/75,frameBase.origin.y, frameBase.size.width,frameBase.size.height)];
        
        //Guardian Star One Icon
        guardianStarOneIcon = [[UIImageView alloc] initWithImage:[NSCard getGuardianStarSymbol:[playerCard guardianStarOne]]];
        [guardianStarOneIcon setFrame:CGRectMake(frameBase.origin.x + space/1.7, frameBase.origin.y + space,     side, side)];
        
        //Guardian Star Two Icon
        guardianStarTwoIcon = [[UIImageView alloc] initWithImage:[NSCard getGuardianStarSymbol:[playerCard guardianStarTwo]]];
        [guardianStarTwoIcon setFrame:CGRectMake(frameBase.origin.x + space/1.7, frameBase.origin.y + space*1.7, side, side)];
        
        //Guardian Star One and Two Text
        guardianStarOneText = [self generateTextFieldAt:CGRectMake(0,70,BASE_WINDOW_WIDTH/2,35)];
        guardianStarTwoText = [self generateTextFieldAt:CGRectMake(0,70,BASE_WINDOW_WIDTH/2,35)];
        frameBase = guardianStarOneText.frame;
        
        //Guardian Star One Text
        textY = guardianStarOneIcon.frame.origin.y + guardianStarOneIcon.frame.size.height/2 - frameBase.size.height/2;
        [guardianStarOneText setFrame:CGRectMake(frameBase.origin.x + space/1.3 + side, textY, frameBase.size.width,frameBase.size.height)];
        [guardianStarOneText setText:[NSCard getGuardianStarName:[playerCard guardianStarOne]]];
        guardianStarOneText.font = [UIFont systemFontOfSize:windowHeight/22];
        
        //Guardian Star Two Text
        textY = guardianStarTwoIcon.frame.origin.y + guardianStarTwoIcon.frame.size.height/2 - frameBase.size.height/2;
        [guardianStarTwoText setFrame:CGRectMake(frameBase.origin.x + space/1.3 + side, textY, frameBase.size.width, frameBase.size.height)];
        [guardianStarTwoText setText:[NSCard getGuardianStarName:[playerCard guardianStarTwo]]];
        guardianStarTwoText.font = [UIFont systemFontOfSize:windowHeight/22];
        
        [self addSubview:guardianStarText];
        [self addSubview:guardianStarOneIcon];
        [self addSubview:guardianStarOneText];
        [self addSubview:guardianStarTwoIcon];
        [self addSubview:guardianStarTwoText];
    }
    
    frameBase = [self generateRectOf:CGRectMake(0,42,BASE_WINDOW_WIDTH,45)];
    frameBase = CGRectMake(frameBase.origin.x+3*windowHeight/75, frameBase.origin.y, frameBase.size.width, frameBase.size.height);
    space = frameBase.origin.x - blockStartX;
    descriptionText = [self generateTextViewAt:CGRectMake(0,142,BASE_WINDOW_WIDTH,35)];
    [descriptionText setFrame:CGRectMake(frameBase.origin.x, descriptionText.frame.origin.y,
                                         BGDescription.frame.size.width - space*2,BGDescription.frame.size.height)];
    [descriptionText setText:[playerCard cardDescription]];
    descriptionText.font = [UIFont systemFontOfSize:windowHeight/22];
    [self addSubview:descriptionText];
}
-(void)loadOkButton{
    okButton = [[UIButton alloc] initWithFrame:windowFrame];
    [okButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchDown];
    [self addSubview:okButton];
}

-(void)intro{
    CGRect cardFrame      = cardPlayer.frame;
    CGRect bgTypeFrame    = BGType.frame;
    CGRect bgGSFrame      = BGGuardianStar.frame;
    CGRect bgDescFrame    = BGDescription.frame;
    CGRect typeIconFrame  = typeIcon.frame;
    CGRect typeTextFrame  = typeText.frame;
    CGRect GSFrame        = guardianStarText.frame;
    CGRect GSOneIconFrame = guardianStarOneIcon.frame;
    CGRect GSOneTextFrame = guardianStarOneText.frame;
    CGRect GSTwoIconFrame = guardianStarTwoIcon.frame;
    CGRect GSTwoTextFrame = guardianStarTwoText.frame;
    CGRect GSDescFrame    = descriptionText.frame;
    
    cardPlayer.frame          = [self slideToLeft:cardFrame];
    BGType.frame              = [self slideToRight:bgTypeFrame];
    BGGuardianStar.frame      = [self slideToRight:bgGSFrame];
    BGDescription.frame       = [self slideToRight:bgDescFrame];
    typeIcon.frame            = [self slideToRight:typeIconFrame];
    typeText.frame            = [self slideToRight:typeTextFrame];
    guardianStarText.frame    = [self slideToRight:GSFrame];
    guardianStarOneIcon.frame = [self slideToRight:GSOneIconFrame];
    guardianStarOneText.frame = [self slideToRight:GSOneTextFrame];
    guardianStarTwoIcon.frame = [self slideToRight:GSTwoIconFrame];
    guardianStarTwoText.frame = [self slideToRight:GSTwoTextFrame];
    descriptionText.frame     = [self slideToRight:GSDescFrame];
    self.alpha = 0;
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        cardPlayer.frame          = cardFrame;
        BGType.frame              = bgTypeFrame;
        BGGuardianStar.frame      = bgGSFrame;
        BGDescription.frame       = bgDescFrame;
        typeIcon.frame            = typeIconFrame;
        typeText.frame            = typeTextFrame;
        guardianStarText.frame    = GSFrame;
        guardianStarOneIcon.frame = GSOneIconFrame;
        guardianStarOneText.frame = GSOneTextFrame;
        guardianStarTwoIcon.frame = GSTwoIconFrame;
        guardianStarTwoText.frame = GSTwoTextFrame;
        descriptionText.frame     = GSDescFrame;
        self.alpha = 1.0;
    } completion:nil];
}
-(id)initWithFrame:(CGRect)frame andCard:(NSCard*)card{
    self = [super initWithFrame:frame];
    if (self) {
        windowFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        playerCard = card;
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    [self setBackgroundColor:[UIColor blackColor]];
    [self initCard:[NSCard getCardPicture:[playerCard serial]]];
    [self calculateBaseBlockWidth];
    [self loadBackground];
    [self loadTexts];
    [self loadOkButton];
    [self intro];
}
-(void)close{
    CGRect cardFrame      = cardPlayer.frame;
    CGRect bgTypeFrame    = BGType.frame;
    CGRect bgGSFrame      = BGGuardianStar.frame;
    CGRect bgDescFrame    = BGDescription.frame;
    CGRect typeIconFrame  = typeIcon.frame;
    CGRect typeTextFrame  = typeText.frame;
    CGRect GSFrame        = guardianStarText.frame;
    CGRect GSOneIconFrame = guardianStarOneIcon.frame;
    CGRect GSOneTextFrame = guardianStarOneText.frame;
    CGRect GSTwoIconFrame = guardianStarTwoIcon.frame;
    CGRect GSTwoTextFrame = guardianStarTwoText.frame;
    CGRect GSDescFrame    = descriptionText.frame;
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        cardPlayer.frame          = [self slideToLeft:cardFrame];
        BGType.frame              = [self slideToRight:bgTypeFrame];
        BGGuardianStar.frame      = [self slideToRight:bgGSFrame];
        BGDescription.frame       = [self slideToRight:bgDescFrame];
        typeIcon.frame            = [self slideToRight:typeIconFrame];
        typeText.frame            = [self slideToRight:typeTextFrame];
        guardianStarText.frame    = [self slideToRight:GSFrame];
        guardianStarOneIcon.frame = [self slideToRight:GSOneIconFrame];
        guardianStarOneText.frame = [self slideToRight:GSOneTextFrame];
        guardianStarTwoIcon.frame = [self slideToRight:GSTwoIconFrame];
        guardianStarTwoText.frame = [self slideToRight:GSTwoTextFrame];
        descriptionText.frame     = [self slideToRight:GSDescFrame];
        self.alpha = 0;
    } completion:^(BOOL finished){[self removeFromSuperview];}];
}

@end
