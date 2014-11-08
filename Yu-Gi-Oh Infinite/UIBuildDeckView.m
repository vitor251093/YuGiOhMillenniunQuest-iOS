//
//  UIBuildDeckView.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 11/03/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "UIBuildDeckView.h"

@implementation UIBuildDeckView

-(int)numberOfDigitsInNumber:(int)number{
    int x=1;
    while (number/10>0){
        x++;
        number/=10;
    }
    return x;
}
-(void)setSelectionFrame:(int)x{
    selectorPosition = x;
    CGRect bFrame = orderTab.frame;
    [selection setFrame:CGRectMake(bFrame.origin.x-(orderTab.frame.size.width/400)+(bFrame.size.width*(248+x*115))/1089, bFrame.origin.y,
                                   selection.frame.size.width, selection.frame.size.height)];
}

-(NSMutableArray*)orderMutableArray:(NSMutableArray*)mArray By:(int)attribute{
    NSMutableArray* cards = [[NSMutableArray alloc] init];
    NSArray* data = [[NSArray alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"DuelMonsterCards" withExtension:@"plist"]];
    BOOL isString = NO;
    
    [self setSelectionFrame:attribute];
    switch (attribute) {
        case 0:
            for (int x=0;x<[mArray count];x++){
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                [dict setObject:mArray[x] forKey:@"card"];
                [dict setObject:@([data count]-[mArray[x] intValue]) forKey:@"var"];
                [cards addObject:dict];
            }
            break;
        case 1:
            for (int x=0;x<[mArray count];x++){
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                [dict setObject:mArray[x] forKey:@"card"];
                NSDictionary* temp = data[[mArray[x] intValue]-1];
                [dict setObject:(NSString*)[temp objectForKey:@"Name"] forKey:@"var"];
                [cards addObject:dict];
            }
            isString = YES;
            break;
        case 2:
            for (int x=0;x<[mArray count];x++){
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                [dict setObject:mArray[x] forKey:@"card"];
                NSDictionary* temp = data[[mArray[x] intValue]-1];
                [dict setObject:@([[temp objectForKey:@"Attack"] intValue] + [[temp objectForKey:@"Defense"] intValue]) forKey:@"var"];
                [cards addObject:dict];
            }
            break;
        case 3:
            for (int x=0;x<[mArray count];x++){
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                [dict setObject:mArray[x] forKey:@"card"];
                NSDictionary* temp = data[[mArray[x] intValue]-1];
                [dict setObject:(NSNumber*)[temp objectForKey:@"Attack"] forKey:@"var"];
                [cards addObject:dict];
            }
            break;
        case 4:
            for (int x=0;x<[mArray count];x++){
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                [dict setObject:mArray[x] forKey:@"card"];
                NSDictionary* temp = data[[mArray[x] intValue]-1];
                [dict setObject:(NSNumber*)[temp objectForKey:@"Defense"] forKey:@"var"];
                [cards addObject:dict];
            }
            break;
        case 5:
            for (int x=0;x<[mArray count];x++){
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                [dict setObject:mArray[x] forKey:@"card"];
                NSDictionary* temp = data[[mArray[x] intValue]-1];
                [dict setObject:(NSString*)[temp objectForKey:@"Type"] forKey:@"var"];
                [cards addObject:dict];
            }
            isString = YES;
            break;
        case 6:
            for (int x=0;x<[mArray count];x++)
                [cards addObject:mArray[[mArray count] - (x+1)]];
            return cards;
            break;
        default:
            break;
    }
    
    NSSortDescriptor *descript = [[NSSortDescriptor alloc] initWithKey:@"var" ascending:isString];
	[cards sortUsingDescriptors:[NSArray arrayWithObject:descript]];
    return [cards mutableArrayValueForKey:@"card"];
}
-(void)orderTableBy:(int)attribute{
    if (isSeenDeck){
        deck = [self orderMutableArray:[[gameSave deck] mutableCopy] By:attribute];
        [deckTable reloadData];
    }else{
        box = [self orderMutableArray:[[gameSave box] removeDuplicates] By:attribute];
        [boxTable reloadData];
    }
}
-(void)orderTableWithButton:(UIButton*)sender{
    [UIUtilities playSound:@"switchOrder" ofType:@"wav"];
    [self orderTableBy:(int)sender.tag];
}

-(UITextField*)generateTextFieldAtFrame:(CGRect)frame{
    UITextField* textField = [[UITextField alloc] initWithFrame:frame];
    textField.textAlignment = NSTextAlignmentRight;
    textField.textColor = [UIColor whiteColor];
    textField.backgroundColor = [UIColor clearColor];
    textField.enabled = NO;
    return textField;
}
-(UITableView*)generateTableView{
    UITableView* table = [[UITableView alloc] initWithFrame:tableFrame];
    table.delegate = self;
    table.dataSource = self;
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:buildDeckFrame];
    [tempImageView setFrame:tableFrame];
    table.backgroundView = tempImageView;
    
    [table setRowHeight:tableFrame.size.height/8];
    return table;
}
-(UIButton*)generateOrderButton:(int)num InRect:(CGRect)rect withAction:(SEL)action{
    UIButton* strenghtButton = [[UIButton alloc] initWithFrame:rect];
    strenghtButton.tag = num;
    [strenghtButton addTarget:self action:action forControlEvents:UIControlEventTouchDown];
    return strenghtButton;
}

-(void)addOrderTab{
    orderTab = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OrderTab"]];
    CGFloat orderTabY = sideSpace;
    CGFloat orderTabHeight = windowFrame.size.height - tableFrame.size.height - sideSpace*2;
    CGFloat orderTabWidth = (orderTabHeight*1089)/142;
    CGFloat orderTabX = (windowFrame.size.width - orderTabWidth)/2;
    orderTab.frame = CGRectMake(orderTabX,orderTabY,orderTabWidth,orderTabHeight);
    [self addSubview:orderTab];
    
    CGFloat buttonsY = orderTabY + (orderTabHeight*18)/142;
    CGFloat buttonsWidth = (orderTabWidth*107)/1089;
    CGFloat buttonsHeight = orderTabHeight - (orderTabHeight*107)/1089;
    CGFloat buttonsX = orderTabX;
    
    selection = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buildDeckSelection"]];
    [selection setFrame:CGRectMake(buttonsX+(orderTabWidth*248)/1089, orderTabY, (orderTabHeight*115)/142, orderTabHeight)];
    [self addSubview:selection];
    
    buttonsX += (orderTabWidth*133)/1089;
    for (int x=0;x<=6;x++){
        buttonsX += (orderTabWidth*115)/1089;
        CGRect idFrame = CGRectMake(buttonsX, buttonsY, buttonsWidth, buttonsHeight);
        [self addSubview:[self generateOrderButton:x InRect:idFrame withAction:@selector(orderTableWithButton:)]];
    }
}
-(void)addReturnButton{
    CGFloat side = orderTab.frame.size.height;
    returnButton = [[UIButton alloc] init];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:side*4/12];
    
    [returnButton setBackgroundImage:buildDeckFrame forState:UIControlStateNormal];
    [returnButton setBackgroundImage:buildDeckFrame forState:UIControlStateHighlighted];
    
    CGFloat variation = windowFrame.size.width/orderTab.frame.size.width;
    CGRect frame = CGRectMake(20,20,(side*variation)/2,side);
    [returnButton setFrame:frame];
    
    [returnButton setTitle:@"OK" forState:UIControlStateNormal];
    [returnButton setTitle:@"OK" forState:UIControlStateHighlighted];
    
    [returnButton addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:returnButton];
}
-(void)addChestButton{
    CGFloat side = orderTab.frame.size.height;
    chestButton = [[UIButton alloc] init];
    CGFloat size = [self numberOfDigitsInNumber:(int)[[gameSave box] count]];
    chestButton.titleLabel.font = [UIFont systemFontOfSize:side*size/8];
    
    CGRect frame = CGRectMake(20+returnButton.frame.size.width, 20, side, side);
    [chestButton setFrame:[UIUtilities addBorder:frame atPercent:10]];
    
    [chestButton setBackgroundImage:[UIImage imageNamed:@"Chest"] forState:UIControlStateNormal];
    [chestButton setTitle:[NSString stringWithFormat:@"%ld",[[gameSave box] count]] forState:UIControlStateNormal];
    
    [chestButton addTarget:self action:@selector(changeChest:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:chestButton];
}
-(void)addDeckButton{
    CGFloat side = orderTab.frame.size.height;
    deckButton = [[UIButton alloc] init];
    deckButton.titleLabel.font = [UIFont systemFontOfSize:side/2];
    
    CGRect frame = CGRectMake(windowFrame.size.width-20-side-moveCardButton.frame.size.width, 20, side, side);
    [deckButton setFrame:[UIUtilities addBorder:frame atPercent:10]];
    
    [deckButton setBackgroundImage:[UIImage imageNamed:@"Deck"] forState:UIControlStateNormal];
    [deckButton setTitle:[NSString stringWithFormat:@"%ld",[[gameSave deck] count]] forState:UIControlStateNormal];
    
    [deckButton addTarget:self action:@selector(changeDeck:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:deckButton];
}
-(void)addMoveCardButton{
    CGFloat side = orderTab.frame.size.height;
    moveCardButton = [[UIButton alloc] init];
    moveCardButton.titleLabel.font = [UIFont systemFontOfSize:side*10/12];
    
    [moveCardButton setBackgroundImage:buildDeckFrame forState:UIControlStateNormal];
    [moveCardButton setBackgroundImage:buildDeckFrame forState:UIControlStateHighlighted];
    
    CGFloat variation = windowFrame.size.width/orderTab.frame.size.width;
    CGRect frame = CGRectMake(windowFrame.size.width-20-(side*variation)/2, 20, (side*variation)/2, side);
    [moveCardButton setFrame:[UIUtilities addBorder:frame atPercent:0]];
    
    [moveCardButton setTitle:@"⇵" forState:UIControlStateNormal];
    
    [moveCardButton addTarget:self action:@selector(moveCardToChestOrDeck:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:moveCardButton];
}

-(id)initWithFrame:(CGRect)frame atDuel:(BOOL)duel inFreeDuel:(BOOL)freeDuel{
    self = [self initWithFrame:frame];
    if (self){
        isDuel = duel;
        isFreeDuel = freeDuel;
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        windowFrame = frame;
        selColor = [UIColor colorWithRed:0.0 green:0.0 blue:100.0/255.0 alpha:0.3];
        [self setBackgroundColor:[UIColor blackColor]];
        
        sideSpace = 20;
        tableFrame = CGRectMake(windowFrame.origin.x+sideSpace, windowFrame.origin.y+(windowFrame.size.height*14)/100,
                                windowFrame.size.width-2*sideSpace, (windowFrame.size.height*86)/100 - sideSpace);
        
        CGFloat scale = (0.3*windowFrame.size.height)/320;
        buildDeckFrame = [UIImage imageNamed:@"buildDeckFrame"];
        buildDeckFrame = [buildDeckFrame imageWithScaledRate:scale];
        buildDeckFrame = [buildDeckFrame imageWithCapInsets];
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    boxTable = [self generateTableView];
    deckTable = [self generateTableView];
    box = [[gameSave box] removeDuplicates];
    deck = [[gameSave deck] mutableCopy];
    [self addSubview:boxTable];
    
    [self addOrderTab];
    [self addReturnButton];
    [self addChestButton];
    [self addMoveCardButton];
    [self addDeckButton];
    
    selectorPosition = 0;
    box = [self orderMutableArray:box By:selectorPosition];
    isSeenDeck = NO;
    [self setSelectionFrame:0];
    [boxTable reloadData];
    
    [audioPlayer setBGMusic:@"BuildDeckTrack" ofExtension:@"mp3"];
}

-(void)backToMenu:(UIButton*)sender{
    if ([[gameSave deck] count]!=40){
        [UIUtilities playSound:@"invalidAction" ofType:@"wav"];
    }
    else{
        UIView* fadeView = self.superview;
        while ([fadeView superview]) fadeView = fadeView.superview;
        [UIUtilities playSound:@"returnAction" ofType:@"wav"];
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             fadeView.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             self.alpha = 0.0;
                             if (isDuel) [(UIDuelView*)self.superview startDuel];
                             else{
                                 if (isFreeDuel){
                                     [audioPlayer setBGMusic:@"FreeDuelTrack" ofExtension:@"mp3"];
                                 }
                                 else{
                                     [audioPlayer setBGMusic:@"MainMenuTrack" ofExtension:@"aac"];
                                     [(UIMainMenuView*)self.superview addTitleMenuButtons];
                                 }
                                 
                             }
                             [UIView animateWithDuration:0.5
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  fadeView.alpha = 1.0;
                                                  [self removeFromSuperview];
                                              }
                                              completion:nil];
                         }];
    }
}
-(void)changeChest:(UIButton*)sender{
    if (isSeenDeck){
        [deckTable removeFromSuperview];
        [self addSubview:boxTable];
        isSeenDeck = NO;
        [self orderTableBy:selectorPosition];
    }
}
-(void)changeDeck:(UIButton*)sender{
    if (!isSeenDeck){
        [boxTable removeFromSuperview];
        [self addSubview:deckTable];
        isSeenDeck = YES;
        [self orderTableBy:selectorPosition];
    }
}
-(void)moveCardToChestOrDeck:(UIButton*)sender{
    int idCard;
    if (isSeenDeck){
        NSIndexPath* index = [deckTable indexPathForSelectedRow];
        if (index!=nil){
            idCard = (int)[deckTable cellForRowAtIndexPath:index].tag;
            
            [UIUtilities playSound:@"selectAction" ofType:@"wav"];
            [gameSave removeCardFromDeck:idCard];
            [gameSave addCardToBox:idCard];
            
            if (![box containsObject:@(idCard)]) [box addObject:@(idCard)];
            
            [self orderTableBy:selectorPosition];
            [chestButton setTitle:[NSString stringWithFormat:@"%ld",[[gameSave box] count]] forState:UIControlStateNormal];
            [deckButton setTitle:[NSString stringWithFormat:@"%ld",[[gameSave deck] count]] forState:UIControlStateNormal];
        }
    }else{
        NSIndexPath* index = [boxTable indexPathForSelectedRow];
        if (index!=nil){
            if ([deck count] + 1 > 40)
                [UIUtilities playSound:@"invalidAction" ofType:@"wav"];
            else{
                idCard = (int)[boxTable cellForRowAtIndexPath:index].tag;
                if ([gameSave countCardAtDeck:idCard]>2)
                    [UIUtilities playSound:@"invalidAction" ofType:@"wav"];
                else{
                    [UIUtilities playSound:@"selectAction" ofType:@"wav"];
                    [gameSave removeCardFromBox:idCard];
                    [gameSave addCardToDeck:idCard];
                    [deck addObject:@(idCard)];
            
                    [self orderTableBy:selectorPosition];
                    [chestButton setTitle:[NSString stringWithFormat:@"%ld",[[gameSave box] count]] forState:UIControlStateNormal];
                    [deckButton setTitle:[NSString stringWithFormat:@"%ld",[[gameSave deck] count]] forState:UIControlStateNormal];
                }
            }
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == boxTable) return [box count];
    if (tableView == deckTable) return [deck count];
    return 0;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath{
    CGFloat pos;
    int idCard;
    
    if (tableView == boxTable)  idCard = [box[[indexPath item]] intValue];
    if (tableView == deckTable) idCard = [deck[[indexPath item]] intValue];

    CGFloat cellHeight = tableFrame.size.height/8;
    NSCard* card = [gameSave.gameCards getCardWithID:idCard];
    
    UITableViewCell* cardCell = [[UITableViewCell alloc] init];
    cardCell.backgroundColor = [UIColor clearColor];
    cardCell.selectedBackgroundView = [[UIView alloc] initWithFrame:cardCell.bounds];
    cardCell.selectedBackgroundView.backgroundColor = selColor;
    cardCell.tag = idCard;
    
    pos = tableFrame.size.width - cellHeight/10;
    if (tableView == boxTable){
        //Deck Icon
        pos -= (cellHeight*11)/10;
        UIImageView* deckIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Deck"]];
        [deckIcon setFrame:[UIUtilities addBorder:CGRectMake(pos,0,cellHeight,cellHeight) atPercent:20.0]];
        [cardCell addSubview:deckIcon];
    
        //Cards in Deck
        UITextField* deckText = [self generateTextFieldAtFrame:CGRectMake(pos,cellHeight/2-cellHeight/10,(cellHeight*11)/10,(cellHeight*2)/3)];
        deckText.text = [NSString stringWithFormat:@"%d",[gameSave countCardAtDeck:[card cardID]]];
        deckText.font = [UIFont systemFontOfSize:cellHeight/3.0];
        [cardCell addSubview:deckText];
    
        //Box Icon
        pos -= (cellHeight*11)/10;
        UIImageView* boxIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Chest"]];
        [boxIcon setFrame:[UIUtilities addBorder:CGRectMake(pos,0,cellHeight,cellHeight) atPercent:20.0]];
        [cardCell addSubview:boxIcon];
    
        //Cards in Box
        UITextField* boxText = [self generateTextFieldAtFrame:CGRectMake(pos,cellHeight/2-cellHeight/10,(cellHeight*11)/10,(cellHeight*2)/3)];
        boxText.text = [NSString stringWithFormat:@"%d",[gameSave countCardAtBox:[card cardID]]];
        boxText.font = [UIFont systemFontOfSize:cellHeight/3.0];
        [cardCell addSubview:boxText];
    }
    
    //Card Guardian Stars Icons / Spell or Trap Type
    if ([card isMonster]){
        pos -= cellHeight;
        UIImageView* GSOne = [[UIImageView alloc] initWithImage:[NSCard getGuardianStarSymbol:[card guardianStarTwo]]];
        [GSOne setFrame:[UIUtilities addBorder:CGRectMake(pos,0,cellHeight,cellHeight) atPercent:40.0]];
        [cardCell addSubview:GSOne];
        
        pos -= (cellHeight*4)/5;
        UIImageView* GSTwo = [[UIImageView alloc] initWithImage:[NSCard getGuardianStarSymbol:[card guardianStarOne]]];
        [GSTwo setFrame:[UIUtilities addBorder:CGRectMake(pos,0,cellHeight,cellHeight) atPercent:40.0]];
        [cardCell addSubview:GSTwo];
    }else{
        pos -= (cellHeight*9)/5;
        UITextField* typeText = [self generateTextFieldAtFrame:CGRectMake(pos,0,(cellHeight*9)/5,cellHeight)];
        typeText.textAlignment = NSTextAlignmentCenter;
        typeText.text = [[card type] componentsSeparatedByString:@" "][0];
        typeText.font = [UIFont systemFontOfSize:cellHeight/2.0];
        [cardCell addSubview:typeText];
    }
    
    //Type Icon
    //Source: http://yugioh.wikia.com/wiki/User:Falzar_FZ/SVG
    pos -= cellHeight;
    
    UIImage* icon = [card getTypeIcon];
    if (icon){
        UIImageView* typeIcon = [[UIImageView alloc] initWithImage:icon];
        [typeIcon setFrame:[UIUtilities addBorder:CGRectMake(pos,0,cellHeight,cellHeight) atPercent:40.0]];
        [cardCell addSubview:typeIcon];
    }
    
    //Attack and Defense Text Views
    pos -= (cellHeight*11)/10;
    if ([card isMonster]){
        UITextField* attackText = [self generateTextFieldAtFrame:CGRectMake(pos,-cellHeight/10,(cellHeight*11)/10,(cellHeight*2)/3)];
        attackText.text = [NSString stringWithFormat:@"%d",[card attack]];
        attackText.font = [UIFont systemFontOfSize:cellHeight/3.0];
        [cardCell addSubview:attackText];
        
        UITextField* defenseText = [self generateTextFieldAtFrame:CGRectMake(pos,cellHeight/2-cellHeight/10,(cellHeight*11)/10,(cellHeight*2)/3)];
        defenseText.text = [NSString stringWithFormat:@"%d",[card defense]];
        defenseText.font = [UIFont systemFontOfSize:cellHeight/3.0];
        [cardCell addSubview:defenseText];
    }
    
    //Attack and Defense Icons
    pos -= (cellHeight)/4;
    if ([card isMonster]){
        UIImageView* attackIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sword"]];
        [attackIcon setFrame:[UIUtilities addBorder:CGRectMake(pos,0,cellHeight/2,cellHeight/2) atPercent:40.0]];
        [cardCell addSubview:attackIcon];
        
        UIImageView* defenseIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shield"]];
        [defenseIcon setFrame:[UIUtilities addBorder:CGRectMake(pos,cellHeight/2,cellHeight/2,cellHeight/2) atPercent:40.0]];
        [cardCell addSubview:defenseIcon];
    }
    
    //Card ID
    UITextField* idText = [self generateTextFieldAtFrame:CGRectMake(15, 0, 200, cellHeight)];
    idText.textAlignment = NSTextAlignmentLeft;
    idText.text = [UIUtilities intToString:[card cardID] WithHouses:4];
    idText.font = [UIFont systemFontOfSize:cellHeight/2.0];
    [cardCell addSubview:idText];
    
    //Card Name
    CGFloat idLenght = [UIUtilities widthOfString:idText.text withFont:idText.font]+25;
    pos -= cellHeight + idLenght;
    UIFont* nameFont = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:(20*windowFrame.size.height)/320];
    CGFloat widthOfName = [UIUtilities widthOfString:[card name] withFont:nameFont];
    if (widthOfName > pos){
        nameFont = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:(22*windowFrame.size.height*pos)/(320*widthOfName)];
        widthOfName = [UIUtilities widthOfString:[card name] withFont:nameFont];
    }
    
    UITextField* nameText = [self generateTextFieldAtFrame:CGRectMake(idLenght, 0, widthOfName + 50, cellHeight)];
    nameText.font = nameFont;
    nameText.textAlignment = NSTextAlignmentLeft;
    nameText.text = [card name];
    [cardCell addSubview:nameText];
    cardCell.textLabel.text = @"";
    cardCell.exclusiveTouch = NO;
    
    return cardCell;
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[tableView indexPathForSelectedRow] isEqual:indexPath]){
        UITableViewCell* cell;
        if (tableView == deckTable) cell = [deckTable cellForRowAtIndexPath:indexPath];
        if (tableView == boxTable)  cell = [boxTable cellForRowAtIndexPath:indexPath];
        NSCard* card = [gameSave.gameCards getCardWithID:(int)cell.tag];
        UICardDetailsView* details = [[UICardDetailsView alloc] initWithFrame:self.frame andCard:card];
        [self addSubview:details];
    }
    return indexPath;
}

@end
