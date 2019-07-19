/*  HBQueueItem.m $

 This file is part of the HandBrake source code.
 Homepage: <http://handbrake.fr/>.
 It may be used under the terms of the GNU General Public License. */

#import "HBQueueItem.h"

#import "HBCodingUtilities.h"

@implementation HBQueueItem

@synthesize job = _job;
@synthesize attributedTitleDescription = _attributedTitleDescription;
@synthesize attributedDescription = _attributedDescription;

@synthesize uuid = _uuid;

- (instancetype)initWithJob:(HBJob *)job
{
    self = [super init];
    if (self)
    {
        _job = job;
        _uuid = [NSUUID UUID].UUIDString;
    }
    return self;
}

#pragma mark - Properties

- (NSURL *)fileURL
{
    return _job.fileURL;
}

- (NSString *)outputFileName
{
    return _job.outputFileName;
}

- (NSURL *)outputURL
{
    return _job.outputURL;
}

- (NSURL *)completeOutputURL
{
    return _job.completeOutputURL;
}

- (NSAttributedString *)attributedTitleDescription
{
    if (_attributedTitleDescription == nil) {
        _attributedTitleDescription = _job.attributedTitleDescription;
    }
    return _attributedTitleDescription;
}

- (NSAttributedString *)attributedDescription
{
    if (_attributedDescription == nil) {
        _attributedDescription = _job.attributedDescription;
    }
    return _attributedDescription;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

static NSString *versionKey = @"HBQueueItemVersion";

- (void)encodeWithCoder:(nonnull NSCoder *)coder
{
    [coder encodeInt:1 forKey:versionKey];
    encodeInt(_state);
    encodeObject(_job);
    encodeObject(_uuid);
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder
{
    int version = [decoder decodeIntForKey:versionKey];

    if (version == 1 && (self = [super init]))
    {
        decodeInt(_state); if (_state < HBQueueItemStateReady || _state > HBQueueItemStateFailed) { goto fail; }
        decodeObjectOrFail(_job, HBJob);
        decodeObjectOrFail(_uuid, NSString);
        return self;
    }
fail:
    return nil;
}

@end
