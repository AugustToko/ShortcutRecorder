//
//  Copyright 2018 ShortcutRecorder Contributors
//  CC BY 4.0
//

#import "SRCommon.h"
#import "SRKeyCodeTransformer.h"
#import "SRShortcutFormatter.h"

#import "SRShortcut.h"


SRShortcutKey const SRShortcutKeyKeyCode = @"keyCode";
SRShortcutKey const SRShortcutKeyModifierFlags = @"modifierFlags";
SRShortcutKey const SRShortcutKeyCharacters = @"characters";
SRShortcutKey const SRShortcutKeyCharactersIgnoringModifiers = @"charactersIgnoringModifiers";

NSString *const SRShortcutKeyCode = SRShortcutKeyKeyCode;
NSString *const SRShortcutModifierFlagsKey = SRShortcutKeyModifierFlags;
NSString *const SRShortcutCharacters = SRShortcutKeyCharacters;
NSString *const SRShortcutCharactersIgnoringModifiers = SRShortcutKeyCharactersIgnoringModifiers;


@implementation SRShortcut

+ (instancetype)shortcutWithCode:(unsigned short)aKeyCode
                   modifierFlags:(NSEventModifierFlags)aModifierFlags
                      characters:(NSString *)aCharacters
     charactersIgnoringModifiers:(NSString *)aCharactersIgnoringModifiers
{
    return [[self alloc] initWithCode:aKeyCode
                        modifierFlags:aModifierFlags
                            characters:aCharacters
           charactersIgnoringModifiers:aCharactersIgnoringModifiers];
}

+ (instancetype)shortcutWithEvent:(NSEvent *)aKeyboardEvent
{
    if (((1 << aKeyboardEvent.type) & (NSEventMaskKeyDown | NSEventMaskKeyUp)) == 0)
        [NSException raise:NSInvalidArgumentException format:@"aKeyboardEvent must be either NSEventTypeKeyUp or NSEventTypeKeyDown, got %lu", aKeyboardEvent.type, nil];

    return [self shortcutWithCode:aKeyboardEvent.keyCode
                    modifierFlags:aKeyboardEvent.modifierFlags
                       characters:aKeyboardEvent.characters
      charactersIgnoringModifiers:aKeyboardEvent.charactersIgnoringModifiers];
}

+ (instancetype)shortcutWithDictionary:(NSDictionary *)aDictionary
{
    NSNumber *keyCode = aDictionary[SRShortcutKeyKeyCode];

    if (![keyCode isKindOfClass:NSNumber.class])
        [NSException raise:NSInvalidArgumentException format:@"aDictionary must contain a key code", nil];

    unsigned short keyCodeValue = keyCode.unsignedShortValue;
    NSUInteger modifierFlagsValue = 0;
    NSString *charactersValue = nil;
    NSString *charactersIgnoringModifiersValue = nil;

    NSNumber *modifierFlags = aDictionary[SRShortcutKeyModifierFlags];
    if ((NSNull *)modifierFlags != NSNull.null)
        modifierFlagsValue = modifierFlags.unsignedIntegerValue;

    NSString *characters = aDictionary[SRShortcutKeyCharacters];
    if ((NSNull *)characters != NSNull.null)
        charactersValue = characters;

    NSString *charactersIgnoringModifiers = aDictionary[SRShortcutKeyCharactersIgnoringModifiers];
    if ((NSNull *)charactersIgnoringModifiers != NSNull.null)
        charactersIgnoringModifiersValue = charactersIgnoringModifiers;

    return [self shortcutWithCode:keyCodeValue
                    modifierFlags:modifierFlagsValue
                       characters:charactersValue
      charactersIgnoringModifiers:charactersIgnoringModifiersValue];
}

- (instancetype)initWithCode:(unsigned short)aKeyCode
               modifierFlags:(NSEventModifierFlags)aModifierFlags
                  characters:(NSString *)aCharacters
 charactersIgnoringModifiers:(NSString *)aCharactersIgnoringModifiers
{
    self = [super init];

    if (self)
    {
        _keyCode = aKeyCode;
        _modifierFlags = aModifierFlags & SRCocoaModifierFlagsMask;
        _characters = aCharacters.copy;
        _charactersIgnoringModifiers = aCharactersIgnoringModifiers.copy;
    }

    return self;
}


#pragma mark Properties

- (NSDictionary<SRShortcutKey, id> *)dictionaryRepresentation
{
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:4];

    d[SRShortcutKeyKeyCode] = @(self.keyCode);
    d[SRShortcutKeyModifierFlags] = @(self.modifierFlags);

    if (self.characters)
        d[SRShortcutKeyCharacters] = self.characters;

    if (self.charactersIgnoringModifiers)
        d[SRShortcutKeyCharactersIgnoringModifiers] = self.charactersIgnoringModifiers;

    return d;
}


#pragma mark Methods

- (NSString *)readableStringRepresentation:(BOOL)isASCII
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (isASCII)
        return SRReadableASCIIStringForCocoaModifierFlagsAndKeyCode(self.modifierFlags, self.keyCode);
    else
        return SRReadableStringForCocoaModifierFlagsAndKeyCode(self.modifierFlags, self.keyCode);
#pragma clang diagnostic pop
}


#pragma mark Equality

- (BOOL)isEqualToShortcut:(SRShortcut *)aShortcut
{
    if (aShortcut == self)
        return YES;
    else if (![aShortcut isKindOfClass:SRShortcut.class])
        return NO;
    else
        return (aShortcut.keyCode == self.keyCode && aShortcut.modifierFlags == self.modifierFlags);
}

- (BOOL)isEqualToDictionary:(NSDictionary<SRShortcutKey, id> *)aDictionary
{
    if ([aDictionary[SRShortcutKeyKeyCode] isKindOfClass:NSNumber.class])
        return [aDictionary[SRShortcutKeyKeyCode] unsignedShortValue] == self.keyCode && ([aDictionary[SRShortcutKeyModifierFlags] unsignedIntegerValue] & SRCocoaModifierFlagsMask) == self.modifierFlags;
    else
        return NO;
}

- (BOOL)isEqualToKeyEquivalent:(nullable NSString *)aKeyEquivalent withModifierFlags:(NSEventModifierFlags)aModifierFlags
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return SRKeyCodeWithFlagsEqualToKeyEquivalentWithFlags(self.keyCode, self.modifierFlags, aKeyEquivalent, aModifierFlags);
#pragma clang diagnostic pop
}


#pragma mark Subscript

- (nullable id)objectForKeyedSubscript:(SRShortcutKey)aKey
{
    if ([aKey isEqualToString:SRShortcutKeyKeyCode])
        return @(self.keyCode);
    else if ([aKey isEqualToString:SRShortcutKeyModifierFlags])
        return @(self.modifierFlags);
    else if ([aKey isEqualToString:SRShortcutKeyCharacters])
        return self.characters;
    else if ([aKey isEqualToString:SRShortcutKeyCharactersIgnoringModifiers])
        return self.charactersIgnoringModifiers;
    else
        return nil;
}


#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)aZone
{
    // SRShortcut is immutable.
    return self;
}


#pragma mark NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithCode:[[aDecoder decodeObjectOfClass:NSNumber.class forKey:SRShortcutKeyKeyCode] unsignedShortValue]
                modifierFlags:[[aDecoder decodeObjectOfClass:NSNumber.class forKey:SRShortcutKeyModifierFlags] unsignedIntegerValue]
                   characters:[aDecoder decodeObjectOfClass:NSString.class forKey:SRShortcutKeyCharacters]
  charactersIgnoringModifiers:[aDecoder decodeObjectOfClass:NSString.class forKey:SRShortcutKeyCharactersIgnoringModifiers]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:SRBundle().infoDictionary[(__bridge NSString *)kCFBundleVersionKey] forKey:@"version"];
    [aCoder encodeObject:@(self.keyCode) forKey:SRShortcutKeyKeyCode];
    [aCoder encodeObject:@(self.modifierFlags) forKey:SRShortcutKeyModifierFlags];
    [aCoder encodeObject:self.characters forKey:SRShortcutKeyCharacters];
    [aCoder encodeObject:self.charactersIgnoringModifiers forKey:SRShortcutKeyCharactersIgnoringModifiers];
}


#pragma mark NSObject

- (BOOL)isEqual:(NSObject *)anObject
{
    return [self SR_isEqual:anObject usingSelector:@selector(isEqualToShortcut:) ofCommonAncestor:SRShortcut.class];
}

- (NSUInteger)hash
{
    // SRCocoaModifierFlagsMask leaves enough bits for key code
    return (self.modifierFlags & SRCocoaModifierFlagsMask) | self.keyCode;
}

- (NSString *)description
{
    static SRShortcutFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [SRShortcutFormatter new];
        formatter.usesASCIICapableKeyboardInputSource = YES;
        formatter.isKeyCodeLiteral = YES;
    });

    return [formatter stringForObjectValue:self];
}

@end


@implementation SRShortcut (Carbon)

- (UInt32)carbonKeyCode
{
    return self.keyCode;
}

- (UInt32)carbonModifierFlags
{
    switch (self.carbonKeyCode)
    {
        case kVK_F1:
        case kVK_F2:
        case kVK_F3:
        case kVK_F4:
        case kVK_F5:
        case kVK_F6:
        case kVK_F7:
        case kVK_F8:
        case kVK_F9:
        case kVK_F10:
        case kVK_F11:
        case kVK_F12:
        case kVK_F13:
        case kVK_F14:
        case kVK_F15:
        case kVK_F16:
        case kVK_F17:
        case kVK_F18:
        case kVK_F19:
        case kVK_F20:
            return SRCocoaToCarbonFlags(self.modifierFlags) | NSFunctionKeyMask;
        default:
            return SRCocoaToCarbonFlags(self.modifierFlags);
    }
}

@end


NSString *SRReadableStringForCocoaModifierFlagsAndKeyCode(NSEventModifierFlags aModifierFlags, unsigned short aKeyCode)
{
    SRKeyCodeTransformer *t = [SRKeyCodeTransformer sharedPlainTransformer];
    NSString *c = [t transformedValue:@(aKeyCode)];

    return [NSString stringWithFormat:@"%@%@%@%@%@",
                                      (aModifierFlags & NSCommandKeyMask ? SRLoc(@"Command-") : @""),
                                      (aModifierFlags & NSAlternateKeyMask ? SRLoc(@"Option-") : @""),
                                      (aModifierFlags & NSControlKeyMask ? SRLoc(@"Control-") : @""),
                                      (aModifierFlags & NSShiftKeyMask ? SRLoc(@"Shift-") : @""),
                                      c];
}


NSString *SRReadableASCIIStringForCocoaModifierFlagsAndKeyCode(NSEventModifierFlags aModifierFlags, unsigned short aKeyCode)
{
    SRKeyCodeTransformer *t = [SRKeyCodeTransformer sharedPlainASCIITransformer];
    NSString *c = [t transformedValue:@(aKeyCode)];

    return [NSString stringWithFormat:@"%@%@%@%@%@",
            (aModifierFlags & NSCommandKeyMask ? SRLoc(@"Command-") : @""),
            (aModifierFlags & NSAlternateKeyMask ? SRLoc(@"Option-") : @""),
            (aModifierFlags & NSControlKeyMask ? SRLoc(@"Control-") : @""),
            (aModifierFlags & NSShiftKeyMask ? SRLoc(@"Shift-") : @""),
            c];
}


static BOOL _SRKeyCodeWithFlagsEqualToKeyEquivalentWithFlags(unsigned short aKeyCode,
                                                             NSEventModifierFlags aKeyCodeFlags,
                                                             NSString * _Nullable aKeyEquivalent,
                                                             NSEventModifierFlags aKeyEquivalentModifierFlags,
                                                             SRKeyCodeTransformer * _Nonnull aTransformer)
{
    if (![aKeyEquivalent length])
        return NO;

    aKeyCodeFlags &= SRCocoaModifierFlagsMask;
    aKeyEquivalentModifierFlags &= SRCocoaModifierFlagsMask;

    if (aKeyCodeFlags == aKeyEquivalentModifierFlags)
    {
        NSString *keyCodeRepresentation = [aTransformer transformedValue:@(aKeyCode)
                                               withImplicitModifierFlags:nil
                                                   explicitModifierFlags:@(aKeyCodeFlags)];
        return [keyCodeRepresentation isEqual:aKeyEquivalent];
    }
    else if (!aKeyEquivalentModifierFlags ||
             (aKeyCodeFlags & aKeyEquivalentModifierFlags) == aKeyEquivalentModifierFlags)
    {
        // Some key equivalent modifier flags can be implicitly set via special unicode characters. E.g. å instead of opt-a.
        // However all modifier flags explictily set in key equivalent MUST be also set in key code flags.
        // E.g. ctrl-å/ctrl-opt-a and å/opt-a match this condition, but cmd-å/ctrl-opt-a doesn't.
        NSString *keyCodeRepresentation = [aTransformer transformedValue:@(aKeyCode)
                                               withImplicitModifierFlags:nil
                                                   explicitModifierFlags:@(aKeyCodeFlags)];

        if ([keyCodeRepresentation isEqual:aKeyEquivalent])
        {
            // Key code and key equivalent are not equal if key code representation matches key equivalent, but modifier flags are not.
            return NO;
        }
        else
        {
            NSEventModifierFlags possiblyImplicitFlags = aKeyCodeFlags & ~aKeyEquivalentModifierFlags;
            keyCodeRepresentation = [aTransformer transformedValue:@(aKeyCode)
                                         withImplicitModifierFlags:@(possiblyImplicitFlags)
                                             explicitModifierFlags:@(aKeyEquivalentModifierFlags)];
            return [keyCodeRepresentation isEqual:aKeyEquivalent];
        }
    }
    else
        return NO;
}


BOOL SRKeyCodeWithFlagsEqualToKeyEquivalentWithFlags(unsigned short aKeyCode,
                                                     NSEventModifierFlags aKeyCodeFlags,
                                                     NSString *aKeyEquivalent,
                                                     NSEventModifierFlags aKeyEquivalentModifierFlags)
{
    BOOL isEqual = _SRKeyCodeWithFlagsEqualToKeyEquivalentWithFlags(aKeyCode,
                                                                    aKeyCodeFlags,
                                                                    aKeyEquivalent,
                                                                    aKeyEquivalentModifierFlags,
                                                                    [SRKeyCodeTransformer sharedASCIITransformer]);

    if (!isEqual)
    {
        isEqual = _SRKeyCodeWithFlagsEqualToKeyEquivalentWithFlags(aKeyCode,
                                                                   aKeyCodeFlags,
                                                                   aKeyEquivalent,
                                                                   aKeyEquivalentModifierFlags,
                                                                   [SRKeyCodeTransformer sharedTransformer]);
    }

    return isEqual;
}
