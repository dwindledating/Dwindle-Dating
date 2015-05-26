//
//  IOUtility.h
//  IFFT2014
//
//  Created by Yunas Qazi on 3/25/14.
//  Copyright (c) 2014 AppsFoundry. All rights reserved.
//


#import "UserSettings.h"

@implementation UserSettings

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.userGender     = [decoder decodeObjectForKey:@"userGender"];
        self.userBirthday   = [decoder decodeObjectForKey:@"userBirthday"];
        self.requiredGender = [decoder decodeObjectForKey:@"requiredGender"];
        self.userDistance   = [decoder decodeObjectForKey:@"userDistance"];
        self.userAgeFrom    = [decoder decodeObjectForKey:@"userAgeFrom"];
        self.userAgeTo      = [decoder decodeObjectForKey:@"userAgeTo"];
        self.fbName         = [decoder decodeObjectForKey:@"fbName"];
        self.fbId           = [decoder decodeObjectForKey:@"fbId"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.userGender       forKey:@"userGender"];
    [encoder encodeObject:self.userBirthday     forKey:@"userBirthday"];
    [encoder encodeObject:self.requiredGender   forKey:@"requiredGender"];
    [encoder encodeObject:self.userDistance     forKey:@"userDistance"];
    [encoder encodeObject:self.userAgeFrom      forKey:@"userAgeFrom"];
    [encoder encodeObject:self.userAgeTo        forKey:@"userAgeTo"];
    [encoder encodeObject:self.fbName           forKey:@"fbName"];
    [encoder encodeObject:self.fbId             forKey:@"fbId"];
    
}


+(UserSettings *) loadUserSettings{

    NSData *archivedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserSettings"];
    
    if (archivedObject)
        return (UserSettings *)[NSKeyedUnarchiver unarchiveObjectWithData: archivedObject];
    else{
        
        UserSettings *settings = [UserSettings new];
        settings.userGender     = @"";
        settings.userBirthday   = @"";
        settings.requiredGender = @"";
        settings.userDistance   = @"";
        settings.userAgeFrom    = @"";
        settings.userAgeTo      = @"";
        settings.fbName         = @"";
        settings.fbId           = @"";
        
        return settings;
    }
}



-(void)removeUserSettings{

    self.userGender     = @"";
    self.userBirthday   = @"";
    self.requiredGender = @"";
    self.userDistance   = @"";
    self.userAgeFrom    = @"";
    self.userAgeTo      = @"";
    self.fbName         = @"";
    self.fbId           = @"";
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserSettings"];
    
}

-(void)saveUserSettings{
    
    NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:archivedObject forKey:@"UserSettings"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

@end
