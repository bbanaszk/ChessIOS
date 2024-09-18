#import "StockfishWrapper.h"
#include "bitboard.h"
#include "evaluate.h"
#include "misc.h"
#include "position.h"
#include "tune.h"
#include "types.h"
#include "uci.h"

@interface StockfishWrapper ()
{
    int inputPipe[2];
    int outputPipe[2];
    Stockfish::UCI *uci;
}
@property (nonatomic, strong) NSThread *engineThread;
@property (nonatomic, strong) NSMutableString *accumulatedOutput;
@property (nonatomic, assign) BOOL isReady;
@end

@implementation StockfishWrapper

- (instancetype)init {
    self = [super init];
    if (self) {
        if (pipe(inputPipe) == -1) {
            perror("input pipe creation failed");
        }
        if (pipe(outputPipe) == -1) {
            perror("output pipe creation failed");
        }
        self.engineThread = [[NSThread alloc] initWithTarget:self selector:@selector(runEngine) object:nil];
        self.accumulatedOutput = [[NSMutableString alloc] init];
        self.isReady = NO;
    }
    return self;
}

- (void)startEngine {
    NSLog(@"Starting engine");
    [self.engineThread start];
    [NSThread detachNewThreadSelector:@selector(readOutput) toTarget:self withObject:nil];
}

- (void)runEngine {
    NSLog(@"Running engine");
    dup2(inputPipe[0], STDIN_FILENO);
    
    setvbuf(stdout, nil, _IONBF, 0);
    dup2(outputPipe[1], STDOUT_FILENO);

    Stockfish::Bitboards::init();
    Stockfish::Position::init();
    
    int argc = 1;
    const char* argv[] = {"stockfish"};
    uci = new Stockfish::UCI(argc, (char**)argv);
    Stockfish::Tune::init(uci->options);
    uci->evalFiles = Stockfish::Eval::NNUE::load_networks(uci->workingDirectory(), uci->options, uci->evalFiles);
    uci->loop();
}

- (void)sendCommand:(NSString *)command {
    
    [self sendStopCommand];
    
    NSLog(@"Sending command: %@", command);
    NSArray<NSString *> *commands = [command componentsSeparatedByString:@";"];
    for (NSString *cmd in commands) {
        NSString *cmdWithNewline = [cmd stringByAppendingString:@"\n"];
        ssize_t bytesWritten = write(inputPipe[1], [cmdWithNewline UTF8String], [cmdWithNewline lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
        if (bytesWritten == -1) {
            perror("Error writing to inputPipe");
        } else {
            NSLog(@"Successfully wrote %zd bytes to inputPipe", bytesWritten);
        }
    }
}

- (void)sendStopCommand {
    NSString *stopCommand = @"stop\n";
    ssize_t bytesWritten = write(inputPipe[1], [stopCommand UTF8String], [stopCommand lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    if (bytesWritten == -1) {
        perror("Error writing to inputPipe");
    } else {
        NSLog(@"Successfully sent stop command to engine.");
    }
}

- (void)readOutput {
    char buffer[256];
    ssize_t count;

    while (true) {
        count = read(outputPipe[0], buffer, sizeof(buffer) - 1);
        if (count > 0) {
            buffer[count] = '\0';
            NSString *output = [NSString stringWithUTF8String:buffer];
            [self.accumulatedOutput appendString:output];
            
            // Process each line to find relevant move information.
            [self processAndExtractMoves];
            
            
        }
        // Else part commented out as per your previous snippet.
    }
}

- (void)processAndExtractMoves {
    NSArray *lines = [self.accumulatedOutput componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSMutableArray *relevantMoves = [NSMutableArray array];

    for (NSString *line in lines) {
//        if ([line containsString:@"pv"]) {
//            NSString *firstMove = [self extractFirstMoveAfterPV:line];
//            if (firstMove.length > 0) {
//                [relevantMoves addObject:firstMove];
//            }
//        }
        if ([line containsString:@"bestmove"]) {
            NSString *bestMove = [self extractMoveAfterKeyword:@"bestmove" fromLine:line];
            if (bestMove.length > 0) {
                [relevantMoves addObject:bestMove];
            }
        }
    }
    
    // Send only if there are new moves to send
    if (relevantMoves.count > 0 && self.onResponse) {
        NSString *movesToSend = [relevantMoves componentsJoinedByString:@", "];
        NSLog(@"Sending moves to response handler: %@", movesToSend);
//        self.onResponse(movesToSend);
        self.onResponse([movesToSend copy]);
    }

    // Reset the accumulated output
    [self.accumulatedOutput setString:@""];
}

//- (NSString *)extractFirstMoveAfterPV:(NSString *)line {
//    NSScanner *scanner = [NSScanner scannerWithString:line];
//    NSString *beforePV = @"";
//    NSString *afterPV = @"";
//    
//    // Scan up to "pv", but make sure we're actually past "multipv"
//    [scanner scanUpToString:@" pv" intoString:&beforePV];
//    if ([beforePV rangeOfString:@"multipv"].location != NSNotFound) {
//        // We have "multipv" before "pv", adjust scanner position
//        [scanner scanString:@" pv" intoString:nil];
//        [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:nil]; // skip the number after "pv"
//        if ([scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&afterPV]) {
//            return afterPV;
//        }
//    }
//
//    return nil;
//}

- (NSString *)extractMoveAfterKeyword:(NSString *)keyword fromLine:(NSString *)line {
    NSScanner *scanner = [NSScanner scannerWithString:line];
    [scanner scanUpToString:keyword intoString:nil];
    [scanner scanString:keyword intoString:nil];
    NSString *move;
    [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&move];
    return move;
}

@end
