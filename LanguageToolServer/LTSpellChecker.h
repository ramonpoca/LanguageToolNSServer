/*
 * (c) Ramon Poca - 2014
 *
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

#import <Foundation/Foundation.h>
#import "LTLanguageToolConnection.h"


@interface LTSpellChecker : NSObject <NSSpellServerDelegate>
@property (strong, nonatomic) LTLanguageToolConnection *connection;
@end