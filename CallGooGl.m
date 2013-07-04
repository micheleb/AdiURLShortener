//
//  CallGooGl.m
//  AdiURLShortener
//
//  Created by michele bonazza on 26/05/2013.
//  Copyright (c) 2013 MB. All rights reserved.
//

#import "CallGooGl.h"

@implementation CallGooGl

- (id)initWithUrl:(NSString *)url {
    self = [super init];
    _url = url;
    return self;
}

- (void)main {
    @autoreleasepool {
//        NSLog(@"shortening %@...", _url);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.googleapis.com/urlshortener/v1/url"]];
        [request setHTTPMethod:@"POST"];
        
        NSDictionary *json = @{@"longUrl":_url};
        
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        [request setHTTPBody:postData];
        NSURLResponse *response;
        NSHTTPURLResponse *httpResponse;
        NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        httpResponse = (NSHTTPURLResponse*) response;
        NSInteger statusCode = [httpResponse statusCode];
        
        if (statusCode == 200) {
            json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
            _shortened = [json valueForKey:@"id"];
        } else {
            // leave _shortened empty so no replacement is made
            NSLog(@"goo.gl call failed, statusCode is %ld", (long)statusCode);
        }
    }
}

@end
