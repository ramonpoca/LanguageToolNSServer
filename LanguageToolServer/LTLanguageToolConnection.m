/*
 * (c) Ramon Poca - 2014
 *
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

#import "LTLanguageToolConnection.h"
#import "JXHTTP.h"

@implementation LTLanguageToolConnection {

}

- (NSArray *)supportedLanguages {
    NSURL *langURL = [self.serverURL URLByAppendingPathComponent:@"/Languages"];
    JXHTTPOperation *op = [[JXHTTPOperation alloc] initWithURL:langURL];
    [op startAndWaitUntilFinished];
    if (op.response && op.responseStatusCode == 200) {
        NSError *err;
        NSXMLDocument *doc = [[NSXMLDocument alloc] initWithData:op.responseData options:0 error:&err];
        NSXMLElement *root = doc.rootElement;
        NSArray *languages = [root elementsForName:@"language"];
        NSArray *langNames = [[NSArray alloc] init];
        if (languages.count > 0) {
            for (NSXMLElement *element in languages) {
                langNames = [langNames arrayByAddingObject:[element attributeForName:@"abbrWithVariant"].stringValue];
            }
            return langNames;
        }
    }
    return nil;
}


/// Check grammar, return an array of errors
- (NSArray *)checkGrammarForText:(NSString *)text inLanguage:(NSString *)lang {
    JXHTTPOperation *op = [[JXHTTPOperation alloc] initWithURL:self.serverURL];
    op.requestBody = [[JXHTTPFormEncodedBody alloc] initWithDictionary:@{@"language" : lang, @"text" : text}];
    op.requestCachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    op.requestMethod = @"POST";
    [op startAndWaitUntilFinished];
    if (op.response && op.responseStatusCode == 200) {
        NSError *err;
        NSXMLDocument *doc = [[NSXMLDocument alloc] initWithData:op.responseData options:0 error:&err];
        if (!err) {
            NSXMLElement *root = doc.rootElement;
            NSArray *errors = [root elementsForName:@"error"];
            if (errors && errors.count > 0)
                return errors;
        }
    }

    return nil;
}

@end