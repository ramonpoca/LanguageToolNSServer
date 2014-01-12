/*
 * (c) Ramon Poca - 2014
 *
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

#import "LTSpellChecker.h"


@implementation LTSpellChecker {

}
/*


- (NSArray *)spellServer:(NSSpellServer *)sender suggestGuessesForWord:(NSString *)word inLanguage:(NSString *)language {
    return nil;
}

- (void)spellServer:(NSSpellServer *)sender didLearnWord:(NSString *)word inLanguage:(NSString *)language {

}

- (void)spellServer:(NSSpellServer *)sender didForgetWord:(NSString *)word inLanguage:(NSString *)language {

}

- (NSArray *)spellServer:(NSSpellServer *)sender suggestCompletionsForPartialWordRange:(NSRange)range inString:(NSString *)string language:(NSString *)language {
    return nil;
}

- (void)spellServer:(NSSpellServer *)sender recordResponse:(NSUInteger)response toCorrection:(NSString *)correction forWord:(NSString *)word language:(NSString *)language {

}

- (NSArray *)spellServer:(NSSpellServer *)sender checkString:(NSString *)stringToCheck offset:(NSUInteger)offset types:(NSTextCheckingTypes)checkingTypes options:(NSDictionary *)options orthography:(NSOrthography *)orthography wordCount:(NSInteger *)wordCount {



    return nil;
}
*/
/*
NSGrammarRange
The value for the NSGrammarRange dictionary key should be an NSValue containing an NSRange,
a subrange of the sentence range used as the return value, whose location should be an offset
from the beginning of the sentence--so, for example, an NSGrammarRange for the first four
characters of the overall sentence range should be {0, 4}. If the NSGrammarRange key is not present in the dictionary it is assumed to be equal to the overall sentence range.
NSGrammarUserDescription
The value for the NSGrammarUserDescription dictionary key should be an NSString containing
descriptive text about that range, to be presented directly to the user; it is intended that
the user description should provide enough information to allow the user to correct the problem.
It is recommended that NSGrammarUserDescription be supplied in all cases, however,
NSGrammarUserDescription or NSGrammarCorrections must be supplied in order for correction
 guidance to be presented to the user.
NSGrammarCorrections
The value for the NSGrammarCorrections key should be an NSArray of NSStrings representing potential substitutions to correct the problem, but it is expected that this may not be available in all cases. NSGrammarUserDescription or NSGrammarCorrections must be supplied in order for correction guidance to be presented to the user.

<error fromy="0" fromx="0" toy="0" tox="2" ruleId="UPPERCASE_SENTENCE_START"
msg="This sentence does not start with an uppercase letter"
replacements="My" context="my text"
contextoffset="0" offset="0" errorlength="2"
category="Capitalization" locqualityissuetype="typographical"/>

 */

- (NSRange)spellServer:(NSSpellServer *)sender checkGrammarInString:(NSString *)stringToCheck language:(NSString *)language details:(NSArray **)details {
    NSRange result = NSMakeRange(NSNotFound, 0);
    NSArray *errorDetails = [[NSArray alloc] init];
    NSArray *errors = [self.connection checkGrammarForText:stringToCheck inLanguage:language];
    NSLog(@"Checking \"%@\"", stringToCheck);
    if (errors) {
        for (NSXMLElement *element in errors) {
            NSRange erange;
            erange.location = (NSUInteger) [element attributeForName:@"offset"].stringValue.integerValue;
            erange.length = (NSUInteger) [element attributeForName:@"errorlength"].stringValue.integerValue;
            NSString *message = [element attributeForName:@"msg"].stringValue;
            NSString *replacements = [element attributeForName:@"replacements"].stringValue;
            NSArray *replacementsArray = [replacements componentsSeparatedByString:@"#"];

            if (result.length == 0 && result.location == NSNotFound)
                result = erange;
            NSLog(@"Result: at %d len %d \"%@\" replacements:%d",erange.location, erange.length, message, replacementsArray.count);
            errorDetails = [errorDetails arrayByAddingObject:@{NSGrammarRange : [NSValue valueWithRange:erange],
                    NSGrammarUserDescription : message,
                    NSGrammarCorrections : replacementsArray
            }];

        }
        *details = errorDetails;
    }
    return NSMakeRange(0, stringToCheck.length);

//    return result;
}



/*
- (NSRange)spellServer:(NSSpellServer *)sender findMisspelledWordInString:(NSString *)stringToCheck language:(NSString *)language wordCount:(NSInteger *)wordCount countOnly:(BOOL)countOnly {
    NSRange result = NSMakeRange(NSNotFound, 0);
    NSLog(@"Spelling req: %@", stringToCheck);
    return result;
} */

- (NSString *)codeForLanguage:(NSString *)language {
    return [@{
             @"Català":@"ca",
             @"Español":@"es",
             @"English":@"en"
             } objectForKey:language];
}

@end