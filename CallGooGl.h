//
//  CallGooGl.h
//  AdiURLShortener
//
//  Created by Michele Bonazza on May 26th, 2013.
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
//

#import <Foundation/Foundation.h>

@interface CallGooGl : NSOperation {
    @private
    NSString *_url;
}

@property(strong) NSString *shortened;

-(id)initWithUrl:(NSString *)url;

@end
