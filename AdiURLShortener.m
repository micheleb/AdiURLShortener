//
//  AdiURLShortener.m
//  AdiURLShortener
//
//  Created by Michele Bonazza on May 25th, 2013.
//  Copyright (c) 2013 MB. All rights reserved.
//
//
// This file is part of AdiURLShortener.
//
// AdiURLShortener is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// AdiURLShortener is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with AdiURLShortener.  If not, see <http://www.gnu.org/licenses/>.

#import "AdiURLShortener.h"
#import "CallGooGl.h"

@implementation AdiURLShortener

- (void)installPlugin {
    [[adium contentController] registerContentFilter:self ofType:AIFilterContent direction:AIFilterOutgoing];
}

- (void)uninstallPlugin {
    [[adium contentController] unregisterContentFilter:self];
}

- (NSAttributedString *)filterAttributedString:(NSAttributedString *)inAttributedString context:(id)context {
    NSAttributedString *returnMe = inAttributedString;
    NSString *typed = [inAttributedString string];
    NSMutableString *changed = [[NSMutableString alloc]initWithString:typed];
    NSUInteger typedLength = [typed length];
    
    if (typedLength > MIN_LENGTH_TO_SHORTEN) {
        NSError *error = nil;
        // these are here so not to conflict with the awesome adinline plugin
        NSArray *imageExtensions = @[@"png", @"jpg", @"jpeg", @"tif", @"tiff", @"gif", @"bmp"];
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((http|https)://w{0,3}\\.?[^\\s,:]+)" options:0 error:&error];
        NSArray *matches = [regex matchesInString:typed options:0 range:NSMakeRange(0, typedLength)];
        NSMutableDictionary *replacements = [[NSMutableDictionary alloc] init];
        NSOperationQueue *shortenedUrls = [[NSOperationQueue alloc] init];
        for (NSTextCheckingResult *match in matches) {
            NSString *matchText = [typed substringWithRange:[match range]];
            if (![imageExtensions containsObject:[[[[NSURL URLWithString:matchText] path] pathExtension] lowercaseString]]) {
                NSRange range = [match rangeAtIndex:1];
                NSString *url = [typed substringWithRange:range];
                if ([url length] > MIN_LENGTH_TO_SHORTEN) {
                    CallGooGl *worker = [[CallGooGl alloc] initWithUrl:url];
                    [replacements setValue:worker forKey:url];
                    [shortenedUrls addOperation:worker];
                }
            } else {
                NSLog(@"link to an image: %@", matchText);
            }
        }
        [shortenedUrls waitUntilAllOperationsAreFinished];
        if ([replacements count]) {
            returnMe = [[NSMutableAttributedString alloc]initWithString:[self replaceAll:changed using:replacements]];
        }
    }
    return returnMe;
}

- (NSMutableString *)replaceAll:(NSMutableString *)string using:(NSDictionary *)replacements {
    for (NSString *key in replacements) {
        NSString *replace = [[replacements valueForKey:key] shortened];
        if (replace) {
            [string replaceOccurrencesOfString:key withString:replace options: NSLiteralSearch range:NSMakeRange(0, [string length])];
        }
    }
    return string;
}

- (CGFloat)filterPriority {
	return (CGFloat)LOWEST_FILTER_PRIORITY;
}

- (NSString *)pluginAuthor {
	return @"Michele Bonazza";
}

- (NSString *)pluginVersion {
	return @"0.1";
}

- (NSString *)pluginDescription {
	return @"This plugin shortens non-image links that you're about to send using Google's URL Shortener API.";
}

- (NSString *)pluginURL {
	return @"https://github.com/micheleb/AdiURLShortener";
}

@end
