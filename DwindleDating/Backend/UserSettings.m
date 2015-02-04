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
        self.userDistance   = [decoder decodeObjectForKey:@"userDistance"];
        self.userAgeFrom    = [decoder decodeObjectForKey:@"userAgeFrom"];
        self.userAgeTo      = [decoder decodeObjectForKey:@"userAgeTo"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.userGender   forKey:@"userGender"];
    [encoder encodeObject:self.userDistance forKey:@"userDistance"];
    [encoder encodeObject:self.userAgeFrom  forKey:@"userAgeFrom"];
    [encoder encodeObject:self.userAgeTo    forKey:@"userAgeTo"];

    
}


+(UserSettings *) loadUserSettings{

    NSData *archivedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserSettings"];
    
    if (archivedObject)
        return (UserSettings *)[NSKeyedUnarchiver unarchiveObjectWithData: archivedObject];
    else{
        
        UserSettings *settings = [UserSettings new];
        settings.userGender     = @"";
        settings.userDistance   = @"";
        settings.userAgeFrom    = @"";
        settings.userAgeTo      = @"";
        return settings;
    }
}

-(void)saveUserSettings{
    
    NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:archivedObject forKey:@"UserSettings"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

@end
