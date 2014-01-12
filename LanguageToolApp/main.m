//
//  main.m
//  LanguageToolApp
//
//  Created by Ramon Poca on 11/01/14.
//  Copyright (c) 2014 Ramon Poca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTLanguageToolConnection.h"
#import "LTSpellChecker.h"


int main(int argc, const char * argv[])
{
    @autoreleasepool {
        
        NSURL *url = [NSURL URLWithString:@"http://localhost:8081"];
        LTLanguageToolConnection *connection = [[LTLanguageToolConnection alloc] init];
        LTSpellChecker *spellChecker = [[LTSpellChecker alloc] init];
        spellChecker.connection = connection;
        connection.serverURL = url;
        NSArray *languages = [connection supportedLanguages];
        
        if (languages && languages.count > 0) {
            NSSpellServer *aServer = [[NSSpellServer alloc] init];
            NSInteger registeredLanguages = 0;
            for (NSString *language in languages) {
                NSString *appleName = [NSLocale canonicalLanguageIdentifierFromString:language];
                if ([aServer registerLanguage:language byVendor:@"LanguageTool"]) {
                    registeredLanguages++;
                }
                NSLog(@"Registering %@", language);
            }
            if (registeredLanguages > 0) {
                [aServer setDelegate:spellChecker];
                [aServer run];
                NSLog(@"Unexpected death of LanguageTool SpellChecker!\n");
            } else {
                NSLog(@"Unable to check in LanguageTool SpellChecker.\n");
            }
        }
    }
    return 0;
}
