//
//  NSCard.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 23/02/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "NSCard.h"

@implementation NSString (ContainsClass)
-(BOOL)contains:(NSString*)string{
    if ([self rangeOfString:string].location == NSNotFound) return NO;
    return YES;
}
@end

@implementation NSCard

-(instancetype)init{
    self = [super init];
    if (self){
        cards = [[NSArray alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"DuelMonsterCards" withExtension:@"plist"]];
    }
    return self;
}
-(NSCard*)getCardWithID:(int)idCard{
    NSCard* new = [super init];
    if (new){
        if (idCard <= [cards count]){
            [new setCard:[(NSDictionary*)cards[idCard-1] copy]];
            _cardID = idCard;
        } else return nil;
    }
    return self;
}
-(NSCard*)getCardWithSerial:(NSString*)serial{
    NSCard* new = [super init];
    if (new){
        [new setName:@"x"];
        for (int x=0;x<[cards count];x++){
            NSDictionary* card = cards[x];
            if ([[card objectForKey:@"Serial"] isEqualToString:serial]){
                [new setCard:card];
                _cardID = x;
                break;
            }
        }
        if ([[new name] isEqualToString:@"x"]) return nil;
    }
    return self;
}
-(void)setCard:(NSDictionary*)card{
    [self setName:[card objectForKey:@"Name"]];
    [self setRarity:[card objectForKey:@"Rarity"]];
    [self setCirculation:[card objectForKey:@"Circulation"]];
    [self setCardId:[card objectForKey:@"Card ID"]];
    [self setCardDescription:[card objectForKey:@"Description"]];
    [self setSerial:[card objectForKey:@"Serial"]];
    [self setAttribute:[card objectForKey:@"Attribute"]];
    [self setLevel:[card objectForKey:@"Level"]];
    [self setType:[card objectForKey:@"Type"]];
    [self setAttack:[[card objectForKey:@"Attack"] intValue]];
    [self setDefense:[[card objectForKey:@"Defense"] intValue]];
    [self setGuardianStarOne:[NSCard getGuardianStarForString:[card objectForKey:@"Guardian Star 1"]]];
    [self setGuardianStarTwo:[NSCard getGuardianStarForString:[card objectForKey:@"Guardian Star 2"]]];
    [self setIsAnimal:[[card objectForKey:@"isAnimal"] intValue]];
    [self setIsDarkMagic:[[card objectForKey:@"isDarkMagic"] intValue]];
    [self setIsDarkSpellcaster:[[card objectForKey:@"isDarkSpellcaster"] intValue]];
    [self setIsDragon:[[card objectForKey:@"isDragon"] intValue]];
    [self setIsElf:[[card objectForKey:@"isElf"] intValue]];
    [self setIsFemale:[[card objectForKey:@"isFemale"] intValue]];
    [self setIsHFDMaterial:[[card objectForKey:@"isHFDMaterial"] intValue]];
    [self setIsJar:[[card objectForKey:@"isJar"] intValue]];
    [self setIsKoumoriMaterial:[[card objectForKey:@"isKoumoriMaterial"] intValue]];
    [self setIsMysticalMaterial:[[card objectForKey:@"isMysticalMaterial"] intValue]];
    [self setIsPyro:[[card objectForKey:@"isPyro"] intValue]];
    [self setIsTurtle:[[card objectForKey:@"isTurtle"] intValue]];
    [self setIsWinged:[[card objectForKey:@"isWinged"] intValue]];
}

+(int)getNumberOfCards{
    NSArray* data = [[NSArray alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"DuelMonsterCards" withExtension:@"plist"]];
    return (int)[data count];
}
-(UIImage*)image{
    return [NSCard getCardPicture:[self serial]];
}
+(UIImage*)getCardPicture:(NSString*)code{
    NSString* imageFile = [NSString stringWithFormat:@"%@/%@.",[[NSBundle mainBundle] resourcePath],code];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[imageFile stringByAppendingString:@"jpg"]])
        return [UIImage imageWithContentsOfFile:[imageFile stringByAppendingString:@"jpg"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[imageFile stringByAppendingString:@"png"]])
        return [UIImage imageWithContentsOfFile:[imageFile stringByAppendingString:@"png"]];
    return nil;
}

-(UIImage*)getTypeIcon{
    NSString* iconName = [self type];
    if ([self isTrap])   iconName = @"Trap";
    if ([self isMagic])  iconName = @"Magic";
    if ([self isEquip])  iconName = @"Equip";
    if ([self isRitual]) iconName = @"Ritual";
    if ([self isField])  iconName = @"Field";
    return [UIImage imageNamed:iconName];
}
+(UIImage*)getGuardianStarSymbol:(GuardianStar)guard{
    return [UIImage imageNamed:[[NSCard getGuardianStarName:guard] lowercaseString]];
}
+(NSString*)getGuardianStarName:(GuardianStar)guard{
    if (guard == Mercury) return @"Mercury";
    if (guard == Sun) return @"Sun";
    if (guard == Moon) return @"Moon";
    if (guard == Venus) return @"Venus";
    if (guard == Mars) return @"Mars";
    if (guard == Jupiter) return @"Jupiter";
    if (guard == Saturn) return @"Saturn";
    if (guard == Uranus) return @"Uranus";
    if (guard == Pluto) return @"Pluto";
    if (guard == Neptune) return @"Neptune";
    return nil;
}
+(GuardianStar)getGuardianStarForString:(NSString*)string{
    if ([[string capitalizedString] contains:@"Mercury"]) return Mercury;
    if ([[string capitalizedString] contains:@"Sun"]) return Sun;
    if ([[string capitalizedString] contains:@"Moon"]) return Moon;
    if ([[string capitalizedString] contains:@"Venus"]) return Venus;
    if ([[string capitalizedString] contains:@"Mars"]) return Mars;
    if ([[string capitalizedString] contains:@"Jupiter"]) return Jupiter;
    if ([[string capitalizedString] contains:@"Saturn"]) return Saturn;
    if ([[string capitalizedString] contains:@"Uranus"]) return Uranus;
    if ([[string capitalizedString] contains:@"Pluto"]) return Pluto;
    if ([[string capitalizedString] contains:@"Neptune"]) return Neptune;
    return -1;
}

-(int)getStarValueOfCardSerial:(NSString*)serial{
    NSCard* card = [self getCardWithSerial:serial];
    if (card == nil) return 0;
    
    if ([card ultimateRare]) return 999999;
    if ([card uniqueCard]) return -1;
    if ([card isMonster]) return [card getMonsterStarValue];
    if ([card isSpell]){
        if ([[card type] isEqualToString:@"Field"]) return 55;
        if ([[card type] isEqualToString:@"Equip"]){
            if ([[card level] isEqualToString:@"All"])
                return 3*([card attack]+[card defense]);
            else return [card attack]+[card defense];
        }
        if ([[card type] isEqualToString:@"Ritual"]){
            NSCard* ref = [self getCardWithSerial:[card level]];
            return [ref getMonsterStarValue]/2;
        }
        if ([[card type] isEqualToString:@"Magic"]) return 2000;
    }
    if ([card isTrap]){
        if ([[card type] isEqualToString:@"LifePoints"]) return [card attack];
        else return 2000;
    }
    
    return -1;
}
-(int)getMonsterStarValue{
	int VAL = [self attack] + [self defense];
	if (VAL<=400) return 5;                 //Price: 5
	if (VAL<=1200) return (VAL/40)-5;       //Price: from 5    to 25
	if (VAL<=2200) return (VAL/20)-35;      //Price: from 25   to 75
	if (VAL<=2600) return ((3*VAL)/20)-255;	//Price: from 75   to 135
	if (VAL<=3000) return (VAL/5)-385;      //Price: from 135  to 215
	if (VAL<=3400) return ((2*VAL)/5)-985;	//Price: from 215  to 375
	if (VAL<=4200) return (VAL/2)-1325;     //Price: from 375  to 775
	if (VAL<=4800) return ((3*VAL)/2)-5525;	//Price: from 775  to 1675
	return (2*VAL)-7925;                    //Price: from 1675 to 32075 (ATK:10000 DEF:10000)
}

-(NSArray*)sortRandomMonsters:(int)number WithMoreThen:(int)min andLessThen:(int)max withExtra:(NSArray*)extra{
    NSMutableArray* dataRes = [[NSMutableArray alloc] init];
    NSCard* card;
    int idCard;
    while (number > 0){
        idCard = 0;
        while (idCard == 0){
            idCard = (arc4random()%[cards count])+1;
            card = [self getCardWithID:idCard];
            
            CGFloat som = card.attack + card.defense;
            if (!(([card isMonster] && ![card ultimateRare] && ![card uniqueCard] && som>=min && som<=max) || [extra containsObject:@(idCard)]))
                idCard = 0;
        }
        [dataRes addObject:@(idCard)];
        number--;
    }
    return dataRes;
}
-(int)sortRandomMagic{
    int idCard = 0;
    NSCard* card;
    while (idCard == 0){
        NSArray* data = [[NSArray alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"DuelMonsterCards" withExtension:@"plist"]];
        idCard = (arc4random()%[data count])+1;
        card = [self getCardWithID:idCard];
        if (!([card isSpell] && ![card ultimateRare] && ![card uniqueCard])) idCard = 0;
    }
    return idCard;
}

-(BOOL)isType:(NSString*)type{
    if ([[self type] isEqualToString:@"type"]) return TRUE;
    if ([type isEqualToString:@"Animal"] && [self isAnimal]) return TRUE;
    if ([type isEqualToString:@"DarkMagic"] && [self isDarkMagic]) return TRUE;
    if ([type isEqualToString:@"DarkSpellcaster"] && [self isDarkSpellcaster]) return TRUE;
    if ([type isEqualToString:@"Dragon"] && [self isDragon]) return TRUE;
    if ([type isEqualToString:@"Elf"] && [self isElf]) return TRUE;
    if ([type isEqualToString:@"Female"] && [self isFemale]) return TRUE;
    if ([type isEqualToString:@"HFDMaterial"] && [self isHFDMaterial]) return TRUE;
    if ([type isEqualToString:@"Jar"] && [self isJar]) return TRUE;
    if ([type isEqualToString:@"KoumoriMaterial"] && [self isKoumoriMaterial]) return TRUE;
    if ([type isEqualToString:@"MysticalMaterial"] && [self isMysticalMaterial]) return TRUE;
    if ([type isEqualToString:@"Pyro"] && [self isPyro]) return TRUE;
    if ([type isEqualToString:@"Turtle"] && [self isTurtle]) return TRUE;
    if ([type isEqualToString:@"Winged"] && [self isWinged]) return TRUE;
    if ([type isEqualToString:@"Egg"] && [[self name] contains:@"Egg"]) return TRUE;
    return FALSE;
}

-(BOOL)canFuseWith:(NSCard*)fusionMaterial WithCard:(NSString*)card1 andCard:(NSString*)card2{
    if (([[self serial] isEqualToString:card1] && [[fusionMaterial serial] isEqualToString:card2]) ||
        ([[self serial] isEqualToString:card2] && [[fusionMaterial serial] isEqualToString:card1])){
        return YES;
    }
    return NO;
}
-(BOOL)canFuseWith:(NSCard*)fusionMaterial WithType:(NSString*)type1 andType:(NSString*)type2 withMaxAttack:(int)maxAttack{
    if (([self isType:type1] && [fusionMaterial isType:type2]) ||
        ([self isType:type2] && [fusionMaterial isType:type1])){
        if ([self attack]<maxAttack && [fusionMaterial attack]<maxAttack)
            return YES;
    }
    return NO;
}
-(BOOL)canFuseWith:(NSCard*)fusionMaterial WithType:(NSString*)type1 andCard:(NSString*)card1 withMaxAttack:(int)maxAttack{
    if (([self isType:type1] && [[fusionMaterial serial] isEqualToString:card1]) ||
        ([[self serial] isEqualToString:card1] && [fusionMaterial isType:type1])){
        if ([self attack]<maxAttack && [fusionMaterial attack]<maxAttack)
            return YES;
    }
    return NO;
}
-(NSCard*)fusionWith:(NSCard*)fusionMaterial{
    //Original Game Source:
    //http://www.gamefaqs.com/ps/561010-yu-gi-oh-forbidden-memories/faqs/16613
    //http://yugioh.wikia.com/wiki/List_of_Yu-Gi-Oh!_Forbidden_Memories_cards
    
    if ([self canFuseWith:fusionMaterial WithCard:@"70781052" andCard:@"74677422"]) //B. Skull Dragon
        return [self getCardWithSerial:@"11901678"];
    if ([self canFuseWith:fusionMaterial WithCard:@"06368038" andCard:@"28279543"]) //Gaia The Dragon Champion
        return [self getCardWithSerial:@"66889139"];
    if ([self canFuseWith:fusionMaterial WithCard:@"05053103" andCard:@"68516705"]) //Rabid Horseman
        return [self getCardWithSerial:@"94905343"];
    if ([self canFuseWith:fusionMaterial WithCard:@"28725004" andCard:@"42431843"]) //Skull Knight
        return [self getCardWithSerial:@"02504891"];
    if ([self canFuseWith:fusionMaterial WithCard:@"71625222" andCard:@"46986414"]) //Dark Sage
        return [self getCardWithSerial:@"92377303"];
    if ([self canFuseWith:fusionMaterial WithCard:@"23995346" andCard:@"05405694"]) //Dragon Master Knight
        return [self getCardWithSerial:@"62873545"];
    if ([self canFuseWith:fusionMaterial WithCard:@"74677422" andCard:@"68540058"]) //Red-Eyes Black Metal Dragon
        return [self getCardWithSerial:@"64335804"];
    if ([self canFuseWith:fusionMaterial WithCard:@"66672569" andCard:@"29491031"]) //Great Mammoth of Goldfine
        return [self getCardWithSerial:@"54622031"];
    if ([self canFuseWith:fusionMaterial WithCard:@"67284908" andCard:@"30778711"]) //Wall Shadow
        return [self getCardWithSerial:@"63162310"];
    if ([self canFuseWith:fusionMaterial WithCard:@"46986414" andCard:@"78193831"]) //Dark Paladin
        return [self getCardWithSerial:@"98502113"];
    if ([self canFuseWith:fusionMaterial WithCard:@"86569121" andCard:@"13676474"]) //Masked Beast Des Gardius
        return [self getCardWithSerial:@"48948935"];
    if ([self canFuseWith:fusionMaterial WithCard:@"70095154" andCard:@"70095154"]) //Cyber Twin Dragon
        return [self getCardWithSerial:@"74157028"];
    if ([self canFuseWith:fusionMaterial WithCard:@"70095154" andCard:@"74157028"]) //Cyber End Dragon
        return [self getCardWithSerial:@"01546123"];
    if ([self canFuseWith:fusionMaterial WithCard:@"73216412" andCard:@"46821314"]) //Humanoid Worm Drake
        return [self getCardWithSerial:@"05600127"];
    if ([self canFuseWith:fusionMaterial WithCard:@"23205979" andCard:@"59290628"]) //Reaper on the Nightmare
        return [self getCardWithSerial:@"85684223"];
    if ([self canFuseWith:fusionMaterial WithCard:@"38247752" andCard:@"41426869"]) //Relinquished
        return [self getCardWithSerial:@"64631466"];
    if ([self canFuseWith:fusionMaterial WithCard:@"75417459" andCard:@"00423705"]) //Gearfried the Swordmaster
        return [self getCardWithSerial:@"57046845"];
    if ([self canFuseWith:fusionMaterial WithCard:@"46986414" andCard:@"01784686"]) //Amulet Dragon
        return [self getCardWithSerial:@"75380687"];
    if ([self canFuseWith:fusionMaterial WithCard:@"46986414" andCard:@"38033121"]) //Sorcerer of Dark Magic
        return [self getCardWithSerial:@"88619463"];
    if ([self canFuseWith:fusionMaterial WithCard:@"38916461" andCard:@"92421852"]) //Super Roboyarou
        return [self getCardWithSerial:@"01412158"];
    if ([self canFuseWith:fusionMaterial WithCard:@"88819587" andCard:@"64428736"]) //Alligator's Sword Dragon
        return [self getCardWithSerial:@"03366982"];
    if ([self canFuseWith:fusionMaterial WithCard:@"01784686" andCard:@"38033121"]) //Dark Magician Girl the Dragon Knight
        return [self getCardWithSerial:@"43892408"];
    if ([self canFuseWith:fusionMaterial WithCard:@"25833572" andCard:@"72425059"]) //Dark Guardian
        return [self getCardWithSerial:@"96363274"];
    if ([self canFuseWith:fusionMaterial WithCard:@"00726695" andCard:@"74677422"]) //Red-Eyes Black Dragon Sword
        return [self getCardWithSerial:@"61036413"];
    
    
    if ([self canFuseWith:fusionMaterial WithType:@"Fiend" andCard:@"83464209" withMaxAttack:1100])
        return [self getCardWithSerial:@"30451366"];
    if ([self canFuseWith:fusionMaterial WithType:@"Zombie" andCard:@"83464209" withMaxAttack:1100])
        return [self getCardWithSerial:@"30451366"];
    if ([self canFuseWith:fusionMaterial WithType:@"Fiend" andCard:@"53830602" withMaxAttack:1200])
        return [self getCardWithSerial:@"43500484"];
    if ([self canFuseWith:fusionMaterial WithType:@"Fiend" andCard:@"07892180" withMaxAttack:1200])
        return [self getCardWithSerial:@"48109103"];
    if ([self canFuseWith:fusionMaterial WithType:@"Beast" andCard:@"94675535" withMaxAttack:1300])
        return [self getCardWithSerial:@"07225792"];
    if ([self canFuseWith:fusionMaterial WithType:@"Winged Beast" andCard:@"02863439" withMaxAttack:1300])
        return [self getCardWithSerial:@"68870276"];
    if ([self canFuseWith:fusionMaterial WithType:@"Winged Beast" andCard:@"55337339" withMaxAttack:1300])
        return [self getCardWithSerial:@"68870276"];
    if ([self canFuseWith:fusionMaterial WithType:@"Winged Beast" andCard:@"15150371" withMaxAttack:1300])
        return [self getCardWithSerial:@"68870276"];
    if ([self canFuseWith:fusionMaterial WithType:@"Spellcaster" andCard:@"98049915" withMaxAttack:1400])
        return [self getCardWithSerial:@"99510761"];
    if ([self canFuseWith:fusionMaterial WithType:@"Winged Beast" andCard:@"68963107" withMaxAttack:1400])
        return [self getCardWithSerial:@"14037717"];
    if ([self canFuseWith:fusionMaterial WithType:@"Aqua" andCard:@"48109103" withMaxAttack:1500])
        return [self getCardWithSerial:@"02118022"];
    if ([self canFuseWith:fusionMaterial WithType:@"Aqua" andCard:@"07892180" withMaxAttack:1500])
        return [self getCardWithSerial:@"02118022"];
    if ([self canFuseWith:fusionMaterial WithType:@"Zombie" andCard:@"27094595" withMaxAttack:1500])
        return [self getCardWithSerial:@"29491031"];
    if ([self canFuseWith:fusionMaterial WithType:@"Pyro" andCard:@"77456781" withMaxAttack:1600])
        return [self getCardWithSerial:@"46534755"];
    if ([self canFuseWith:fusionMaterial WithType:@"DarkSpellcaster" andCard:@"15303296" withMaxAttack:1600])
        return [self getCardWithSerial:@"24611934"];
    if ([self canFuseWith:fusionMaterial WithType:@"Winged Beast" andCard:@"15303296" withMaxAttack:1650])
        return [self getCardWithSerial:@"91996584"];
    if ([self canFuseWith:fusionMaterial WithType:@"Fairy" andCard:@"64501875" withMaxAttack:1750])
        return [self getCardWithSerial:@"56907389"];
    if ([self canFuseWith:fusionMaterial WithType:@"Fairy" andCard:@"38942059" withMaxAttack:1750])
        return [self getCardWithSerial:@"56907389"];
    if ([self canFuseWith:fusionMaterial WithType:@"Fish" andCard:@"67629977" withMaxAttack:1800])
        return [self getCardWithSerial:@"23771716"];
    if ([self canFuseWith:fusionMaterial WithType:@"Fish" andCard:@"21347810" withMaxAttack:1800])
        return [self getCardWithSerial:@"23771716"];
    if ([self canFuseWith:fusionMaterial WithType:@"Aqua" andCard:@"58314394" withMaxAttack:1850])
        return [self getCardWithSerial:@"40173854"];
    if ([self canFuseWith:fusionMaterial WithType:@"Insect" andCard:@"60802233" withMaxAttack:1900])
        return [self getCardWithSerial:@"95144193"];
    if ([self canFuseWith:fusionMaterial WithType:@"Spellcaster" andCard:@"85326399" withMaxAttack:1900])
        return [self getCardWithSerial:@"09653271"];
    if ([self canFuseWith:fusionMaterial WithType:@"Fiend" andCard:@"14708569" withMaxAttack:2000])
        return [self getCardWithSerial:@"32485271"];
    if ([self canFuseWith:fusionMaterial WithType:@"Winged Beast" andCard:@"28003512" withMaxAttack:2100])
        return [self getCardWithSerial:@"74703140"];
    if ([self canFuseWith:fusionMaterial WithType:@"Reptile" andCard:@"92667214" withMaxAttack:2200])
        return [self getCardWithSerial:@"72869010"];
    if ([self canFuseWith:fusionMaterial WithType:@"Reptile" andCard:@"93889755" withMaxAttack:2200])
        return [self getCardWithSerial:@"72869010"];
    if ([self canFuseWith:fusionMaterial WithType:@"Warrior" andCard:@"28003512" withMaxAttack:2200])
        return [self getCardWithSerial:@"30113682"];
    if ([self canFuseWith:fusionMaterial WithType:@"Zombie" andCard:@"40374923" withMaxAttack:2200])
        return [self getCardWithSerial:@"54622031"];
    if ([self canFuseWith:fusionMaterial WithType:@"Dragon" andCard:@"71625222" withMaxAttack:2400])
        return [self getCardWithSerial:@"41462083"];
    if ([self canFuseWith:fusionMaterial WithType:@"Fiend" andCard:@"55337339" withMaxAttack:2500])
        return [self getCardWithSerial:@"70781052"];
    if ([self canFuseWith:fusionMaterial WithType:@"DarkSpellcaster" andCard:@"97454149" withMaxAttack:2500])
        return [self getCardWithSerial:@"46986414"];
    
    if ([self canFuseWith:fusionMaterial WithType:@"Plant" andType:@"Pyro" withMaxAttack:700])
        return [self getCardWithSerial:@"53293545"];
    if ([self canFuseWith:fusionMaterial WithType:@"Pyro" andType:@"Zombie" withMaxAttack:700])
        return [self getCardWithSerial:@"53581214"];
    if ([self canFuseWith:fusionMaterial WithType:@"Elf" andType:@"MysticalMaterial" withMaxAttack:800])
        return [self getCardWithSerial:@"15025844"];
    if ([self canFuseWith:fusionMaterial WithType:@"Insect" andType:@"Warrior" withMaxAttack:800])
        return [self getCardWithSerial:@"33413638"];
    if ([self canFuseWith:fusionMaterial WithType:@"Reptile" andType:@"Thunder" withMaxAttack:850])
        return [self getCardWithSerial:@"55875323"];
    if ([self canFuseWith:fusionMaterial WithType:@"Pyro" andType:@"Rock" withMaxAttack:900])
        return [self getCardWithSerial:@"40826495"];
    if ([self canFuseWith:fusionMaterial WithType:@"Plant" andType:@"Reptile" withMaxAttack:1000])
        return [self getCardWithSerial:@"29802344"];
    if ([self canFuseWith:fusionMaterial WithType:@"Plant" andType:@"Zombie" withMaxAttack:1000])
        return [self getCardWithSerial:@"17733394"];
    if ([self canFuseWith:fusionMaterial WithType:@"Pyro" andType:@"Female" withMaxAttack:1000])
        return [self getCardWithSerial:@"27132350"];
    if ([self canFuseWith:fusionMaterial WithType:@"Pyro" andType:@"Zombie" withMaxAttack:1000])
        return [self getCardWithSerial:@"58528964"];
    if ([self canFuseWith:fusionMaterial WithType:@"Turtle" andType:@"Beast" withMaxAttack:1000])
        return [self getCardWithSerial:@"37313348"];
    if ([self canFuseWith:fusionMaterial WithType:@"Dragon" andType:@"Warrior" withMaxAttack:1100])
        return [self getCardWithSerial:@"09197735"];
    if ([self canFuseWith:fusionMaterial WithType:@"Fish" andType:@"Zombie" withMaxAttack:1100])
        return [self getCardWithSerial:@"34290067"];
    if ([self canFuseWith:fusionMaterial WithType:@"Pyro" andType:@"Warrior" withMaxAttack:1100])
        return [self getCardWithSerial:@"37421579"];
    if ([self canFuseWith:fusionMaterial WithType:@"Female" andType:@"Fish" withMaxAttack:1150])
        return [self getCardWithSerial:@"20848593"];
    if ([self canFuseWith:fusionMaterial WithType:@"Female" andType:@"Fish" withMaxAttack:1200])
        return [self getCardWithSerial:@"75376965"];
    if ([self canFuseWith:fusionMaterial WithType:@"Beast" andType:@"Machine" withMaxAttack:1200])
        return [self getCardWithSerial:@"08471389"];
    if ([self canFuseWith:fusionMaterial WithType:@"Beast" andType:@"Thunder" withMaxAttack:1200])
        return [self getCardWithSerial:@"45042329"];
    if ([self canFuseWith:fusionMaterial WithType:@"Dragon" andType:@"Warrior" withMaxAttack:1200])
        return [self getCardWithSerial:@"70681994"];
    if ([self canFuseWith:fusionMaterial WithType:@"Rock" andType:@"Zombie" withMaxAttack:1200])
        return [self getCardWithSerial:@"72269672"];
    if ([self canFuseWith:fusionMaterial WithType:@"Warrior" andType:@"Zombie" withMaxAttack:1200])
        return [self getCardWithSerial:@"31339260"];
    if ([self canFuseWith:fusionMaterial WithType:@"Fish" andType:@"Warrior" withMaxAttack:1250])
        return [self getCardWithSerial:@"69750536"];
    if ([self canFuseWith:fusionMaterial WithType:@"Spellcaster" andType:@"Thunder" withMaxAttack:1250])
        return [self getCardWithSerial:@"11714098"];
    if ([self canFuseWith:fusionMaterial WithType:@"Dragon" andType:@"Warrior" withMaxAttack:1300])
        return [self getCardWithSerial:@"81057959"];
    if ([self canFuseWith:fusionMaterial WithType:@"Beast" andType:@"Warrior" withMaxAttack:1300])
        return [self getCardWithSerial:@"49791927"];
    if ([self canFuseWith:fusionMaterial WithType:@"Pyro" andType:@"Winged Beast" withMaxAttack:1300])
        return [self getCardWithSerial:@"59036972"];
    if ([self canFuseWith:fusionMaterial WithType:@"Rock" andType:@"Warrior" withMaxAttack:1300])
        return [self getCardWithSerial:@"46864967"];
    if ([self canFuseWith:fusionMaterial WithType:@"Spellcaster" andType:@"Zombie" withMaxAttack:1300])
        return [self getCardWithSerial:@"46474915"];
    if ([self canFuseWith:fusionMaterial WithType:@"Female" andType:@"Fish" withMaxAttack:1300])
        return [self getCardWithSerial:@"17968114"];
    if ([self canFuseWith:fusionMaterial WithType:@"Machine" andType:@"DarkSpellcaster" withMaxAttack:1350])
        return [self getCardWithSerial:@"76446915"];
    if ([self canFuseWith:fusionMaterial WithType:@"Beast" andType:@"Fish" withMaxAttack:1350])
        return [self getCardWithSerial:@"47922711"];
    if ([self canFuseWith:fusionMaterial WithType:@"Egg" andType:@"Winged" withMaxAttack:1400])
        return [self getCardWithSerial:@"42418084"];
    if ([self canFuseWith:fusionMaterial WithType:@"Aqua" andType:@"Thunder" withMaxAttack:1400])
        return [self getCardWithSerial:@"12146024"];
    if ([self canFuseWith:fusionMaterial WithType:@"Fish" andType:@"Machine" withMaxAttack:1400])
        return [self getCardWithSerial:@"33178416"];
    if ([self canFuseWith:fusionMaterial WithType:@"Plant" andType:@"Warrior" withMaxAttack:1400])
        return [self getCardWithSerial:@"84990171"];
    if ([self canFuseWith:fusionMaterial WithType:@"Pyro" andType:@"Turtle" withMaxAttack:1400])
        return [self getCardWithSerial:@"96981563"];
    if ([self canFuseWith:fusionMaterial WithType:@"Turtle" andType:@"Rock" withMaxAttack:1450])
        return [self getCardWithSerial:@"09540040"];
    if ([self canFuseWith:fusionMaterial WithType:@"KoumoriMaterial" andType:@"Dragon" withMaxAttack:1500])
        return [self getCardWithSerial:@"67724379"];
    if ([self canFuseWith:fusionMaterial WithType:@"Dragon" andType:@"DarkMagic" withMaxAttack:1500])
        return [self getCardWithSerial:@"87564352"];
    if ([self canFuseWith:fusionMaterial WithType:@"Beast" andType:@"Fish" withMaxAttack:1500])
        return [self getCardWithSerial:@"80516007"];
    if ([self canFuseWith:fusionMaterial WithType:@"Machine" andType:@"Warrior" withMaxAttack:1500])
        return [self getCardWithSerial:@"75559356"];
    if ([self canFuseWith:fusionMaterial WithType:@"Spellcaster" andType:@"Thunder" withMaxAttack:1500])
        return [self getCardWithSerial:@"84926738"];
    if ([self canFuseWith:fusionMaterial WithType:@"Warrior" andType:@"Zombie" withMaxAttack:1500])
        return [self getCardWithSerial:@"20277860"];
    if ([self canFuseWith:fusionMaterial WithType:@"Aqua" andType:@"Dragon" withMaxAttack:1600])
        return [self getCardWithSerial:@"85326399"];
    if ([self canFuseWith:fusionMaterial WithType:@"Dragon" andType:@"Thunder" withMaxAttack:1600])
        return [self getCardWithSerial:@"31786629"];
    if ([self canFuseWith:fusionMaterial WithType:@"Dragon" andType:@"Zombie" withMaxAttack:1600])
        return [self getCardWithSerial:@"66672569"];
    if ([self canFuseWith:fusionMaterial WithType:@"Fish" andType:@"Machine" withMaxAttack:1600])
        return [self getCardWithSerial:@"55998462"];
    if ([self canFuseWith:fusionMaterial WithType:@"Beast" andType:@"Machine" withMaxAttack:1650])
        return [self getCardWithSerial:@"69893315"];
    if ([self canFuseWith:fusionMaterial WithType:@"Beast" andType:@"Fish" withMaxAttack:1700])
        return [self getCardWithSerial:@"29929832"];
    if ([self canFuseWith:fusionMaterial WithType:@"Dragon" andType:@"Zombie" withMaxAttack:1700])
        return [self getCardWithSerial:@"32355828"];
    if ([self canFuseWith:fusionMaterial WithType:@"Dragon" andType:@"Warrior" withMaxAttack:1750])
        return [self getCardWithSerial:@"13069066"];
    if ([self canFuseWith:fusionMaterial WithType:@"Aqua" andType:@"Dragon" withMaxAttack:1800])
        return [self getCardWithSerial:@"76634149"];
    if ([self canFuseWith:fusionMaterial WithType:@"Beast" andType:@"Plant" withMaxAttack:1800])
        return [self getCardWithSerial:@"95952802"];
    if ([self canFuseWith:fusionMaterial WithType:@"Dinosaur" andType:@"Machine" withMaxAttack:1800])
        return [self getCardWithSerial:@"89112729"];
    if ([self canFuseWith:fusionMaterial WithType:@"Plant" andType:@"Zombie" withMaxAttack:1800])
        return [self getCardWithSerial:@"29155212"];
    if ([self canFuseWith:fusionMaterial WithType:@"Pyro" andType:@"Warrior" withMaxAttack:1800])
        return [self getCardWithSerial:@"45231177"];
    if ([self canFuseWith:fusionMaterial WithType:@"Female" andType:@"Fairy" withMaxAttack:1800])
        return [self getCardWithSerial:@"35565537"];
    if ([self canFuseWith:fusionMaterial WithType:@"Female" andType:@"Plant" withMaxAttack:1800])
        return [self getCardWithSerial:@"04179849"];
    if ([self canFuseWith:fusionMaterial WithType:@"Dragon" andType:@"Machine" withMaxAttack:1850])
        return [self getCardWithSerial:@"09293977"];
    if ([self canFuseWith:fusionMaterial WithType:@"Dragon" andType:@"Plant" withMaxAttack:1850])
        return [self getCardWithSerial:@"89832901"];
    if ([self canFuseWith:fusionMaterial WithType:@"Pyro" andType:@"Warrior" withMaxAttack:1900])
        return [self getCardWithSerial:@"35752363"];
    if ([self canFuseWith:fusionMaterial WithType:@"Spellcaster" andType:@"Thunder" withMaxAttack:1900])
        return [self getCardWithSerial:@"09653271"];
    if ([self canFuseWith:fusionMaterial WithType:@"Female" andType:@"Beast" withMaxAttack:1900])
        return [self getCardWithSerial:@"43352213"];
    if ([self canFuseWith:fusionMaterial WithType:@"Turtle" andType:@"Winged Beast" withMaxAttack:1900])
        return [self getCardWithSerial:@"72929454"];
    if ([self canFuseWith:fusionMaterial WithType:@"Beast" andType:@"Winged" withMaxAttack:2000])
        return [self getCardWithSerial:@"69780745"];
    if ([self canFuseWith:fusionMaterial WithType:@"Elf" andType:@"DarkMagic"  withMaxAttack:2000])
        return [self getCardWithSerial:@"21417692"];
    if ([self canFuseWith:fusionMaterial WithType:@"Dragon" andType:@"Rock" withMaxAttack:2000])
        return [self getCardWithSerial:@"68171737"];
    if ([self canFuseWith:fusionMaterial WithType:@"Dragon" andType:@"Zombie" withMaxAttack:2000])
        return [self getCardWithSerial:@"28279543"];
    if ([self canFuseWith:fusionMaterial WithType:@"Turtle" andType:@"Dragon" withMaxAttack:2000])
        return [self getCardWithSerial:@"23659124"];
    if ([self canFuseWith:fusionMaterial WithType:@"Beast" andType:@"Pyro" withMaxAttack:2100])
        return [self getCardWithSerial:@"60862676"];
    if ([self canFuseWith:fusionMaterial WithType:@"Beast" andType:@"Winged" withMaxAttack:2100])
        return [self getCardWithSerial:@"04796100"];
    if ([self canFuseWith:fusionMaterial WithType:@"Female" andType:@"Rock" withMaxAttack:2100])
        return [self getCardWithSerial:@"32751480"];
    if ([self canFuseWith:fusionMaterial WithType:@"Machine" andType:@"Dragon" withMaxAttack:2100])
        return [self getCardWithSerial:@"70095154"];
    if ([self canFuseWith:fusionMaterial WithType:@"Jar" andType:@"DarkSpellcaster" withMaxAttack:2150])
        return [self getCardWithSerial:@"48649353"];
    if ([self canFuseWith:fusionMaterial WithType:@"Female" andType:@"Insect" withMaxAttack:2200])
        return [self getCardWithSerial:@"91512835"];
    if ([self canFuseWith:fusionMaterial WithType:@"Pyro" andType:@"Winged Beast" withMaxAttack:2300])
        return [self getCardWithSerial:@"46696593"];
    if ([self canFuseWith:fusionMaterial WithType:@"Dragon" andType:@"Machine" withMaxAttack:2600])
        return [self getCardWithSerial:@"81480460"];
    if ([self canFuseWith:fusionMaterial WithType:@"Dragon" andType:@"Thunder" withMaxAttack:2800])
        return [self getCardWithSerial:@"54752875"];
    
    if ([fusionMaterial isSpell] || [fusionMaterial isTrap]) return self;
    else return fusionMaterial;
}

-(BattleResult)resultBattleWith:(NSCard*)enemyCard{
    BOOL isEnemyInAttackPosition = [enemyCard isInAttackPosition];
    int yourAttack = [self attack];
    int enemyPoint = isEnemyInAttackPosition?[enemyCard attack]:[enemyCard defense];
    
    GuardianStarEffect effect = [self getGuardianStarEffectOf:self with:enemyCard];
    if (effect == YourBigger) yourAttack += 500;
    if (effect == EnemyBigger) enemyPoint += 500;
    
    if (yourAttack > enemyPoint) return BattleWon;
    if (yourAttack < enemyPoint){
        if (isEnemyInAttackPosition) return BattleLostWhileAttackPosition;
        else return BattleLostWhileDefensePosition;
    }
    if (isEnemyInAttackPosition) return BattleDrawWhileAttackPosition;
    else return BattleDrawWhileDefensePosition;
}
-(GuardianStarEffect)getGuardianStarEffectOf:(NSCard*)yourCard with:(NSCard*)enemyCard{
         if ([yourCard activeGuardianStar] == Mercury) {
        if ([enemyCard activeGuardianStar] == Sun) return YourBigger;
        if ([enemyCard activeGuardianStar] == Venus) return EnemyBigger;
    }
    else if ([yourCard activeGuardianStar] == Sun) {
        if ([enemyCard activeGuardianStar] == Moon) return YourBigger;
        if ([enemyCard activeGuardianStar] == Mercury) return EnemyBigger;
    }
    else if ([yourCard activeGuardianStar] == Moon) {
        if ([enemyCard activeGuardianStar] == Venus) return YourBigger;
        if ([enemyCard activeGuardianStar] == Sun) return EnemyBigger;
    }
    else if ([yourCard activeGuardianStar] == Venus) {
        if ([enemyCard activeGuardianStar] == Mercury) return YourBigger;
        if ([enemyCard activeGuardianStar] == Moon) return EnemyBigger;
    }
    else if ([yourCard activeGuardianStar] == Mars) {
        if ([enemyCard activeGuardianStar] == Jupiter) return YourBigger;
        if ([enemyCard activeGuardianStar] == Neptune) return EnemyBigger;
    }
    else if ([yourCard activeGuardianStar] == Jupiter) {
        if ([enemyCard activeGuardianStar] == Saturn) return YourBigger;
        if ([enemyCard activeGuardianStar] == Mars) return EnemyBigger;
    }
    else if ([yourCard activeGuardianStar] == Saturn) {
        if ([enemyCard activeGuardianStar] == Uranus) return YourBigger;
        if ([enemyCard activeGuardianStar] == Jupiter) return EnemyBigger;
    }
    else if ([yourCard activeGuardianStar] == Uranus) {
        if ([enemyCard activeGuardianStar] == Pluto) return YourBigger;
        if ([enemyCard activeGuardianStar] == Saturn) return EnemyBigger;
    }
    else if ([yourCard activeGuardianStar] == Pluto) {
        if ([enemyCard activeGuardianStar] == Neptune) return YourBigger;
        if ([enemyCard activeGuardianStar] == Uranus) return EnemyBigger;
    }
    else if ([yourCard activeGuardianStar] == Neptune) {
        if ([enemyCard activeGuardianStar] == Mars) return YourBigger;
        if ([enemyCard activeGuardianStar] == Pluto) return EnemyBigger;
    }
    return Nothing;
}

-(BOOL)isMonster {return (![self isSpell] && ![self isTrap]);}
-(BOOL)isSpell   {return ([[self attribute] isEqualToString:@"SPELL"]);}
-(BOOL)isMagic   {return ([[self type] hasPrefix:@"Magic"]);}
-(BOOL)isEquip   {return ([[self type] hasPrefix:@"Equip"]);}
-(BOOL)isRitual  {return ([[self type] hasPrefix:@"Ritual"]);}
-(BOOL)isField   {return ([[self type] hasPrefix:@"Field"]);}
-(BOOL)isTrap    {return ([[self attribute] isEqualToString:@"TRAP"]);}

-(BOOL)ultimateRare{
    //Exodia Cards are Ultimate Rare
    NSArray* Ucards = @[@"33396948",@"07902349",@"70903634",@"44519536",@"08124921"];
    for (NSString *card in Ucards)
        if ([card isEqualToString:[self serial]]) return TRUE;
    return FALSE;
}
-(BOOL)uniqueCard{
    //The Divine Beast will be Unique
    NSArray* Ucards = @[];
    for (NSString *card in Ucards)
        if ([card isEqualToString:[self serial]]) return TRUE;
    return FALSE;
}

@end
