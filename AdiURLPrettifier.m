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

- (NSString *)filterHTMLString:(NSString *)inHTMLString content:(AIContentObject *)content {
    if ([[[adium preferenceController] preferenceForKey:KEY_SHORTENER_TYPE group:APP_NAME] intValue] == VALUE_PRETTIFY) {
        NSMutableString *builder = [NSMutableString string];
        int minLengthToShorten = [[[adium preferenceController] preferenceForKey:KEY_URL_MIN_LENGTH group:APP_NAME] intValue];
        int index = 0;
        // these are here so not to conflict with the awesome adinline plugin
        NSArray *imageExtensions = @[@"png", @"jpg", @"jpeg", @"tif", @"tiff", @"gif", @"bmp"];
        NSError *error = nil;
        // let's grab all links
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a href=\"([^\"]+)\".+</a>" options:0 error:&error];
        NSArray *matches = [regex matchesInString:inHTMLString options:0 range:NSMakeRange(0, [inHTMLString length])];
        for (NSTextCheckingResult *match in matches) {
            NSRange matchRange = [match range];
            [builder appendString:[inHTMLString substringWithRange:NSMakeRange(index, (matchRange.location - index))]];
            index = (int)(matchRange.location + matchRange.length);
            NSString *matchText = [inHTMLString substringWithRange:matchRange];
            if (![imageExtensions containsObject:[[[[NSURL URLWithString:matchText] path] pathExtension] lowercaseString]]) {
                NSString *url = [inHTMLString substringWithRange:[match rangeAtIndex:1]];
                if ([url length] > minLengthToShorten) {
                    [builder appendString:[self shorten:url]];
                }
            } else {
                NSLog(@"link to an image: %@", matchText);
                [builder appendString:matchText];
            }
        }
        if (index < [inHTMLString length]) {
            [builder appendString:[inHTMLString substringFromIndex:index]];
        }
        return builder;
    }
    return inHTMLString;
}

- (NSString *)shorten:(NSString *)url {
    NSError *error = nil;
    NSLog(@"this is the string to shorten: %@", url);
    // let's take the domain and drop all the rest
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(http|https)://w{0,3}\\.?[^/]+" options:0 error:&error];
    NSRange rangeOfFirst = [regex rangeOfFirstMatchInString:url options:0 range:NSMakeRange(0, [url length])];
    if (!NSEqualRanges(rangeOfFirst, NSMakeRange(NSNotFound, 0))) {
        NSString *domain = [url substringWithRange:rangeOfFirst];
        NSLog(@"this is the url: %@, this is the domain: %@", url, domain);
        return [NSString stringWithFormat:@"<a href=\"%1$@\" title=\"%1$@\">%2$@/shortened</a>", url, domain];
    }
    return url;
}

- (CGFloat)filterPriority {
	return (CGFloat)LOWEST_FILTER_PRIORITY;
}

@end
