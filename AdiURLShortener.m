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
#import <AIUtilities/AIDictionaryAdditions.h>
#import <Adium/AIPreferenceControllerProtocol.h>

@implementation AdiURLShortener

- (void)installPlugin {
    prefs = [Prefs preferencePaneForPlugin:self];
    
    NSDictionary *defaults = [NSDictionary dictionaryNamed:@"AdiURLShortenerDefaults" forClass:[self class]];
    if (defaults) {
        [[adium preferenceController] registerDefaults:defaults forGroup:APP_NAME];
    }
    _incomingPrettifier = [[AdiURLPrettifier alloc] init];
    _outgoingPrettifier = [[AdiURLPrettifier alloc] init];
    [[adium contentController] registerContentFilter:self ofType:AIFilterContent direction:AIFilterOutgoing];
    [[adium contentController] registerHTMLContentFilter:_incomingPrettifier direction:AIFilterIncoming];
    [[adium contentController] registerHTMLContentFilter:_outgoingPrettifier direction:AIFilterOutgoing];
}

- (void)uninstallPlugin {
    [[adium contentController] unregisterContentFilter:self];
    [[adium contentController] unregisterHTMLContentFilter:_incomingPrettifier];
    [[adium contentController] unregisterHTMLContentFilter:_outgoingPrettifier];
}

- (NSAttributedString *)filterAttributedString:(NSAttributedString *)inAttributedString context:(id)context {
    NSAttributedString *returnMe = inAttributedString;
    int shortenerType = [[[adium preferenceController] preferenceForKey:KEY_SHORTENER_TYPE group:APP_NAME] intValue];
    if ([[[adium preferenceController] preferenceForKey:KEY_OUTGOING_ENABLED group:APP_NAME] boolValue] && shortenerType == VALUE_GOO_GL) {
        NSString *typed = [inAttributedString string];
        NSMutableString *changed = [[NSMutableString alloc]initWithString:typed];
        NSUInteger typedLength = [typed length];
        int minLengthToShorten = [[[adium preferenceController] preferenceForKey:KEY_MIN_OUTGOING group:APP_NAME] intValue];
        
        if (typedLength > minLengthToShorten) {
            NSError *error = nil;
            // these are here so not to conflict with the awesome adinline plugin
            NSArray *imageExtensions = @[@"png", @"jpg", @"jpeg", @"tif", @"tiff", @"gif", @"bmp"];
            
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((http|https)://w{0,3}\\.?[^\\s]+)" options:0 error:&error];
            NSArray *matches = [regex matchesInString:typed options:0 range:NSMakeRange(0, typedLength)];
            NSMutableDictionary *replacements = [[NSMutableDictionary alloc] init];
            NSOperationQueue *shortenedUrls = [[NSOperationQueue alloc] init];
            
            for (NSTextCheckingResult *match in matches) {
                NSString *matchText = [typed substringWithRange:[match range]];
                if ([[[adium preferenceController] preferenceForKey:KEY_SHORTEN_IMAGE_LINKS group:APP_NAME] boolValue] || ![imageExtensions containsObject:[[[[NSURL URLWithString:matchText] path] pathExtension] lowercaseString]]) {
                    NSRange range = [match rangeAtIndex:1];
                    NSString *url = [typed substringWithRange:range];
                    if ([url length] > minLengthToShorten) {
                        [self shortenWithGooGl:url using:replacements withQueue:shortenedUrls];                    }
                } // else don't shorten
            }
            [shortenedUrls waitUntilAllOperationsAreFinished];
            if ([replacements count]) {
                returnMe = [[NSMutableAttributedString alloc]initWithString:[self replaceAll:changed using:replacements]];
            }
        }
    }
    return returnMe;
}

- (void)shortenWithGooGl:(NSString *)url using:(NSDictionary *)replacements withQueue:(NSOperationQueue *)queue {
    CallGooGl *worker = [[CallGooGl alloc] initWithUrl:url];
    [replacements setValue:worker forKey:url];
    [queue addOperation:worker];
}


- (NSMutableString *)replaceAll:(NSMutableString *)string using:(NSDictionary *)replacements {
    for (NSString *key in replacements) {
        NSString *replace;
            replace = [[replacements valueForKey:key] shortened];
        if (replace) {
            [string replaceOccurrencesOfString:key withString:replace options: NSLiteralSearch range:NSMakeRange(0, [string length])];
//            NSLog(@"this is the replaced string: %@", string);
        }
    }
    return string;
}

- (CGFloat)filterPriority {
	return (CGFloat)HIGHEST_FILTER_PRIORITY;
}

- (NSString *)pluginAuthor {
	return @"Michele Bonazza";
}

- (NSString *)pluginVersion {
	return @"0.3";
}

- (NSString *)pluginDescription {
	return @"This plugin shortens links that you either send, receive or both.";
}

- (NSString *)pluginURL {
	return @"https://github.com/micheleb/AdiURLShortener";
}

@end
