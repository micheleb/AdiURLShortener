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

@implementation AdiURLPrettifier

- (NSString *)filterHTMLString:(NSString *)inHTMLString content:(AIContentObject *)content {
    return inHTMLString;
//    return [NSString stringWithFormat:@"<a href=\"http://www.google.com\" alt=\"test\">%@</a>", inHTMLString];
}

- (CGFloat)filterPriority {
	return (CGFloat)LOWEST_FILTER_PRIORITY;
}

@end
