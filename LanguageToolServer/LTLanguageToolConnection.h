/*
 * (c) Ramon Poca - 2014
 *
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

#import <Foundation/Foundation.h>

@interface LTLanguageToolConnection : NSObject
@property (strong, nonatomic) NSURL *serverURL;


/// Get a list of supported languages (Array of NSString*)
- (NSArray *) supportedLanguages;

- (NSArray *)checkGrammarForText:(NSString *)text inLanguage:(NSString *)lang;

@end