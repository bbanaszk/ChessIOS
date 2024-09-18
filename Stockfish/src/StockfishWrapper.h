#ifndef STOCKFISHWRAPPER_H_INCLUDED
#define STOCKFISHWRAPPER_H_INCLUDED

#import <Foundation/Foundation.h>

@interface StockfishWrapper : NSObject

- (void)startEngine;
- (void)sendCommand:(NSString *)command;
- (void)resetEngine;
@property (nonatomic, strong) void (^onResponse)(NSString *);

@end

#endif /* STOCKFISHWRAPPER_H_INCLUDED */
