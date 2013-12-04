//
//  AdiURLPrettifier.m
//  AdiURLShortener
//
//  Created by michele bonazza on 29/05/2013.
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
#import "AdiURLPrettifier.h"
#import "AdiURLShortener.h"
#import <Adium/AIPreferenceControllerProtocol.h>

@implementation AdiURLPrettifier

- (id) initWithDirection:(AIFilterDirection)direct {
    self = [super init];
    self->direction = direct;
    return self;
}

- (NSString *)filterHTMLString:(NSString *)inHTMLString content:(AIContentObject *)content {
    int index = 0;
    @try {
        // incoming links are never sent to goo.gl
        if (direction == AIFilterIncoming ||
            [[[adium preferenceController] preferenceForKey:KEY_SHORTENER_TYPE group:APP_NAME] intValue] == VALUE_PRETTIFY) {
            NSString *minLengthKey, *enabledKey;
            
            // check preferences
            if (direction == AIFilterIncoming) {
                enabledKey = KEY_INCOMING_ENABLED;
                minLengthKey = KEY_MIN_INCOMING;
            } else {
                enabledKey = KEY_OUTGOING_ENABLED;
                minLengthKey = KEY_MIN_OUTGOING;
            }
            if (![[[adium preferenceController] preferenceForKey:enabledKey group:APP_NAME] boolValue]) {
                // not enabled
                return inHTMLString;
            }
            
            // we'll use this to build our result string
            NSMutableString *builder = [NSMutableString string];
            int minLengthToShorten =  [[[adium preferenceController] preferenceForKey:minLengthKey group:APP_NAME] intValue];
            
            // these are here so not to conflict with the awesome adinline plugin
            NSArray *imageExtensions = @[@"png", @"jpg", @"jpeg", @"tif", @"tiff", @"gif", @"bmp"];
            NSError *error = nil;
            
            // check if there are dropbox links first
            if ([[[adium preferenceController] preferenceForKey:KEY_CONVERT_DROPBOX_LINKS group:APP_NAME] boolValue]) {
                // a dropbox link, and user wants to change them
                inHTMLString = [inHTMLString stringByReplacingOccurrencesOfString:@"www.dropbox.com" withString:@"dl.dropbox.com" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [inHTMLString length])];
            }
            
            // let's grab all links
            NSRange searchRange = NSMakeRange(0, [inHTMLString length]);
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a[^>]*href\\s*=\\s*\"(http(?:s)?://[^\"]+)\"[^>]*>([^<]*)</a>" options:0 error:&error];
            NSArray *linkMatches = [regex matchesInString:inHTMLString options:NSRegularExpressionCaseInsensitive range:searchRange];
            
            for (NSTextCheckingResult *match in linkMatches) {
                NSRange matchRange = [match range];
                
                if (matchRange.location > index) {
                    // add everything between last match and this match, as in
                    // <a href="...">...</a> ADD THIS <a href="...">...
                    [builder appendString:[inHTMLString substringWithRange:NSMakeRange(index, (matchRange.location - index))]];
                }
                index = (int)(matchRange.location + matchRange.length);
                
                NSString *fullLink = [inHTMLString substringWithRange:matchRange];
                NSString *url = [inHTMLString substringWithRange:[match rangeAtIndex:1]];
                NSString *urlName = [inHTMLString substringWithRange:[match rangeAtIndex:2]];

                // if it's an image link, don't shorten unless the user said so
                if ([[[adium preferenceController] preferenceForKey:KEY_SHORTEN_IMAGE_LINKS group:APP_NAME] boolValue] ||
                    ![imageExtensions containsObject:[[[[NSURL URLWithString:url] path] pathExtension] lowercaseString]]) {
                    if ([urlName hasPrefix:@"http"] && [urlName length] > minLengthToShorten && [url length] > minLengthToShorten) {
                        [builder appendString:[self shorten:url]];
                    } else {
                        // don't prettify links that are already pretty!
                        [builder appendString:fullLink];
                    }
                } else {
                    [builder appendString:fullLink];
                }
            }
            
            // append whatever we got after the last match
            if (index < [inHTMLString length]) {
                [builder appendString:[inHTMLString substringFromIndex:index]];
            }
            return builder;
        }
    } @catch (NSException *e) {
        // if all goes wrong...
        NSLog(@"d'oh, %@; index was %d", e, index);
    }
    return inHTMLString;
}

- (NSString *)shorten:(NSString *)url {
    NSError *error = nil;
    // let's take the domain and drop all the rest
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(http|https)://w{0,3}\\.?[^/]+" options:NSRegularExpressionCaseInsensitive error:&error];
    // links are passed to this function one at the time
    NSRange rangeOfFirst = [regex rangeOfFirstMatchInString:url options:0 range:NSMakeRange(0, [url length])];
    
    if (!NSEqualRanges(rangeOfFirst, NSMakeRange(NSNotFound, 0))) {
        NSString *domain = [url substringWithRange:rangeOfFirst];
        
        if ([url length] <= [domain length] + 5) {
            // don't add the "shortened" part if there's nothing after the domain
            return [NSString stringWithFormat:@"<a href=\"%1$@\" title=\"%1$@\">%2$@</a>", url, domain];
        }
        return [NSString stringWithFormat:@"<a href=\"%1$@\" title=\"%1$@\">%2$@/shortened</a>", url, domain];
    }
    return url;
}

- (CGFloat)filterPriority {
	return (CGFloat)HIGHEST_FILTER_PRIORITY;
}

@end
