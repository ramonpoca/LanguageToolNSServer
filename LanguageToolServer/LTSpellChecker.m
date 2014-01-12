/*
 * (c) Ramon Poca - 2014
 *
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

#import "LTSpellChecker.h"


@implementation LTSpellChecker {
}
/**
  Convert errors from LanguageTool in this format
    <error fromy="0" fromx="0" toy="0" tox="2" ruleId="UPPERCASE_SENTENCE_START"
    msg="This sentence does not start with an uppercase letter"
    replacements="My" context="my text"
    contextoffset="0" offset="0" errorlength="2"
    category="Capitalization" locqualityissuetype="typographical"/>

  To the output dictionary expected by NSSpellChecker.

  Important: We return the whole input string as a matched range, if not done this way
  NSSpellChecker keeps sending pieces of the string after the first match. ¬¬
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
    //    return result; Wrong...
    return NSMakeRange(0, stringToCheck.length);

}

@end