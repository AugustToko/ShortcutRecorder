//
//  Copyright 2012 ShortcutRecorder Contributors
//  CC BY 4.0
//

#import <os/trace.h>

#import "SRKeyCodeTransformer.h"
#import "SRCommon.h"


FOUNDATION_STATIC_INLINE NSString* _SRUnicharToString(unichar aChar)
{
    return [NSString stringWithFormat: @"%C", aChar];
}


@implementation SRKeyCodeTransformer

- (instancetype)initWithASCIICapableKeyboardInputSource:(BOOL)aUsesASCII isLiteral:(BOOL)aIsLiteral
{
    self = [super init];

    if (self)
    {
        _usesASCIICapableKeyboardInputSource = aUsesASCII;
        _isLiteral = aIsLiteral;
    }

    return self;
}

- (instancetype)init
{
    return [self initWithASCIICapableKeyboardInputSource:NO isLiteral:NO];
}


#pragma mark Methods

+ (instancetype)sharedSymbolicTransformer
{
    static dispatch_once_t OnceToken;
    static SRKeyCodeTransformer *Transformer = nil;
    dispatch_once(&OnceToken, ^{
        Transformer = [[self alloc] initWithASCIICapableKeyboardInputSource:NO isLiteral:NO];
    });
    return Transformer;
}

+ (instancetype)sharedSymbolicASCIITransformer
{
    static dispatch_once_t OnceToken;
    static SRKeyCodeTransformer *Transformer = nil;
    dispatch_once(&OnceToken, ^{
        Transformer = [[self alloc] initWithASCIICapableKeyboardInputSource:YES isLiteral:NO];
    });
    return Transformer;
}

+ (instancetype)sharedLiteralTransformer
{
    static dispatch_once_t OnceToken;
    static SRKeyCodeTransformer *Transformer = nil;
    dispatch_once(&OnceToken, ^{
        Transformer = [[self alloc] initWithASCIICapableKeyboardInputSource:NO isLiteral:YES];
    });
    return Transformer;
}

+ (SRKeyCodeTransformer *)sharedLiteralASCIITransformer
{
    static dispatch_once_t OnceToken;
    static SRKeyCodeTransformer *Transformer = nil;
    dispatch_once(&OnceToken, ^{
        Transformer = [[self alloc] initWithASCIICapableKeyboardInputSource:YES isLiteral:YES];
    });
    return Transformer;
}

+ (NSDictionary *)specialKeyCodeToSymbolMapping
{
    // Most of these keys are system constans.
    // Values for rest of the keys were given by setting key equivalents in IB.
    static dispatch_once_t OnceToken;
    static NSDictionary *Mapping = nil;
    dispatch_once(&OnceToken, ^{
        Mapping = @{
            @(kVK_F1): _SRUnicharToString(NSF1FunctionKey),
            @(kVK_F2): _SRUnicharToString(NSF2FunctionKey),
            @(kVK_F3): _SRUnicharToString(NSF3FunctionKey),
            @(kVK_F4): _SRUnicharToString(NSF4FunctionKey),
            @(kVK_F5): _SRUnicharToString(NSF5FunctionKey),
            @(kVK_F6): _SRUnicharToString(NSF6FunctionKey),
            @(kVK_F7): _SRUnicharToString(NSF7FunctionKey),
            @(kVK_F8): _SRUnicharToString(NSF8FunctionKey),
            @(kVK_F9): _SRUnicharToString(NSF9FunctionKey),
            @(kVK_F10): _SRUnicharToString(NSF10FunctionKey),
            @(kVK_F11): _SRUnicharToString(NSF11FunctionKey),
            @(kVK_F12): _SRUnicharToString(NSF12FunctionKey),
            @(kVK_F13): _SRUnicharToString(NSF13FunctionKey),
            @(kVK_F14): _SRUnicharToString(NSF14FunctionKey),
            @(kVK_F15): _SRUnicharToString(NSF15FunctionKey),
            @(kVK_F16): _SRUnicharToString(NSF16FunctionKey),
            @(kVK_F17): _SRUnicharToString(NSF17FunctionKey),
            @(kVK_F18): _SRUnicharToString(NSF18FunctionKey),
            @(kVK_F19): _SRUnicharToString(NSF19FunctionKey),
            @(kVK_F20): _SRUnicharToString(NSF20FunctionKey),
            @(kVK_Space): _SRUnicharToString(' '),
            @(kVK_Delete): _SRUnicharToString(NSBackspaceCharacter),
            @(kVK_ForwardDelete): _SRUnicharToString(NSDeleteCharacter),
            @(kVK_ANSI_KeypadClear): _SRUnicharToString(NSClearLineFunctionKey),
            @(kVK_LeftArrow): _SRUnicharToString(NSLeftArrowFunctionKey),
            @(kVK_RightArrow): _SRUnicharToString(NSRightArrowFunctionKey),
            @(kVK_UpArrow): _SRUnicharToString(NSUpArrowFunctionKey),
            @(kVK_DownArrow): _SRUnicharToString(NSDownArrowFunctionKey),
            @(kVK_End): _SRUnicharToString(NSEndFunctionKey),
            @(kVK_Home): _SRUnicharToString(NSHomeFunctionKey),
            @(kVK_Escape): _SRUnicharToString('\e'),
            @(kVK_PageDown): _SRUnicharToString(NSPageDownFunctionKey),
            @(kVK_PageUp): _SRUnicharToString(NSPageUpFunctionKey),
            @(kVK_Return): _SRUnicharToString(NSCarriageReturnCharacter),
            @(kVK_ANSI_KeypadEnter): _SRUnicharToString(NSEnterCharacter),
            @(kVK_Tab): _SRUnicharToString(NSTabCharacter),
            @(kVK_Help): _SRUnicharToString(NSHelpFunctionKey)
        };
    });
    return Mapping;
}

+ (NSDictionary *)specialKeyCodeToLiteralMapping
{
    static dispatch_once_t OnceToken;
    static NSDictionary *Mapping = nil;
    dispatch_once(&OnceToken, ^{
        Mapping = @{
            @(kVK_F1): @"F1",
            @(kVK_F2): @"F2",
            @(kVK_F3): @"F3",
            @(kVK_F4): @"F4",
            @(kVK_F5): @"F5",
            @(kVK_F6): @"F6",
            @(kVK_F7): @"F7",
            @(kVK_F8): @"F8",
            @(kVK_F9): @"F9",
            @(kVK_F10): @"F10",
            @(kVK_F11): @"F11",
            @(kVK_F12): @"F12",
            @(kVK_F13): @"F13",
            @(kVK_F14): @"F14",
            @(kVK_F15): @"F15",
            @(kVK_F16): @"F16",
            @(kVK_F17): @"F17",
            @(kVK_F18): @"F18",
            @(kVK_F19): @"F19",
            @(kVK_F20): @"F20",
            @(kVK_Space): SRLoc(@"Space"),
            @(kVK_Delete): _SRUnicharToString(SRKeyCodeGlyphDeleteLeft),
            @(kVK_ForwardDelete): _SRUnicharToString(SRKeyCodeGlyphDeleteRight),
            @(kVK_ANSI_KeypadClear): _SRUnicharToString(SRKeyCodeGlyphPadClear),
            @(kVK_LeftArrow): _SRUnicharToString(SRKeyCodeGlyphLeftArrow),
            @(kVK_RightArrow): _SRUnicharToString(SRKeyCodeGlyphRightArrow),
            @(kVK_UpArrow): _SRUnicharToString(SRKeyCodeGlyphUpArrow),
            @(kVK_DownArrow): _SRUnicharToString(SRKeyCodeGlyphDownArrow),
            @(kVK_End): _SRUnicharToString(SRKeyCodeGlyphSoutheastArrow),
            @(kVK_Home): _SRUnicharToString(SRKeyCodeGlyphNorthwestArrow),
            @(kVK_Escape): _SRUnicharToString(SRKeyCodeGlyphEscape),
            @(kVK_PageDown): _SRUnicharToString(SRKeyCodeGlyphPageDown),
            @(kVK_PageUp): _SRUnicharToString(SRKeyCodeGlyphPageUp),
            @(kVK_Return): _SRUnicharToString(SRKeyCodeGlyphReturnR2L),
            @(kVK_ANSI_KeypadEnter): _SRUnicharToString(SRKeyCodeGlyphReturn),
            @(kVK_Tab): _SRUnicharToString(SRKeyCodeGlyphTabRight),
            @(kVK_Help): @"?⃝"
        };
    });
    return Mapping;
}

- (BOOL)isKeyCodeSpecial:(unsigned short)aKeyCode
{
    switch (aKeyCode)
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
        case kVK_Space:
        case kVK_Delete:
        case kVK_ForwardDelete:
        case kVK_ANSI_KeypadClear:
        case kVK_LeftArrow:
        case kVK_RightArrow:
        case kVK_UpArrow:
        case kVK_DownArrow:
        case kVK_End:
        case kVK_Home:
        case kVK_Escape:
        case kVK_PageDown:
        case kVK_PageUp:
        case kVK_Return:
        case kVK_ANSI_KeypadEnter:
        case kVK_Tab:
        case kVK_Help:
            return YES;
        default:
            return NO;
    }
}


#pragma mark Deprecated

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

+ (instancetype)sharedTransformer
{
    return self.sharedSymbolicTransformer;
}

+ (instancetype)sharedASCIITransformer
{
    return self.sharedSymbolicASCIITransformer;
}

+ (instancetype)sharedPlainTransformer
{
    return self.sharedLiteralTransformer;
}

+ (SRKeyCodeTransformer *)sharedPlainASCIITransformer
{
    return self.sharedLiteralASCIITransformer;
}

- (instancetype)initWithASCIICapableKeyboardInputSource:(BOOL)aUsesASCII plainStrings:(BOOL)aUsesPlainStrings
{
    return [self initWithASCIICapableKeyboardInputSource:aUsesASCII isLiteral:aUsesPlainStrings];
}

#pragma clang diagnostic pop


#pragma mark NSValueTransformer

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

+ (Class)transformedValueClass;
{
    return [NSString class];
}

- (NSString *)transformedValue:(NSNumber *)aValue
{
    return [self transformedValue:aValue withModifierFlags:nil];
}

- (NSString *)transformedValue:(NSNumber *)aValue withModifierFlags:(NSNumber *)aModifierFlags
{
    return [self transformedValue:aValue withImplicitModifierFlags:aModifierFlags explicitModifierFlags:nil];
}

- (NSString *)transformedValue:(NSNumber *)aValue
     withImplicitModifierFlags:(NSNumber *)anImplicitModifierFlags
         explicitModifierFlags:(NSNumber *)anExplicitModifierFlags
{
    return [self transformedValue:aValue
        withImplicitModifierFlags:anImplicitModifierFlags
            explicitModifierFlags:anExplicitModifierFlags
                          forView:nil];
}

- (NSString *)transformedValue:(NSNumber *)aValue
     withImplicitModifierFlags:(NSNumber *)anImplicitModifierFlags
         explicitModifierFlags:(NSNumber *)anExplicitModifierFlags
                       forView:(nullable NSView *)aView
{
    if (anImplicitModifierFlags.unsignedIntegerValue & anExplicitModifierFlags.unsignedIntegerValue & SRCocoaModifierFlagsMask)
        [NSException raise:NSInvalidArgumentException format:@"anImplicitModifierFlags and anExplicitModifierFlags MUST NOT have common elements"];

    if (![aValue isKindOfClass:[NSNumber class]])
        return nil;

    // Some key codes cannot be translated directly.
    NSString *unmappedString = [self transformedSpecialKeyCode:aValue withExplicitModifierFlags:anExplicitModifierFlags forView:aView];

    if (unmappedString)
        return unmappedString;

    CFDataRef layoutData = NULL;

    if (self.usesASCIICapableKeyboardInputSource)
    {
        TISInputSourceRef tisSource = TISCopyCurrentASCIICapableKeyboardLayoutInputSource();

        if (!tisSource)
            return nil;

        layoutData = (CFDataRef)TISGetInputSourceProperty(tisSource, kTISPropertyUnicodeKeyLayoutData);
        CFRelease(tisSource);
    }
    else
    {
        TISInputSourceRef tisSource = TISCopyCurrentKeyboardLayoutInputSource();

        if (!tisSource)
            return nil;

        layoutData = (CFDataRef)TISGetInputSourceProperty(tisSource, kTISPropertyUnicodeKeyLayoutData);
        CFRelease(tisSource);

        // For non-unicode layouts such as Chinese, Japanese, and Korean, get the ASCII capable layout
        if (!layoutData)
        {
            tisSource = TISCopyCurrentASCIICapableKeyboardLayoutInputSource();

            if (!tisSource)
                return nil;

            layoutData = (CFDataRef)TISGetInputSourceProperty(tisSource, kTISPropertyUnicodeKeyLayoutData);
            CFRelease(tisSource);
        }
    }

    if (!layoutData)
        return nil;

    const UCKeyboardLayout *keyLayout = (const UCKeyboardLayout *)CFDataGetBytePtr(layoutData);

    static const UniCharCount MaxLength = 255;
    UniCharCount actualLength = 0;
    UniChar chars[MaxLength] = {0};

    UInt32 deadKeyState = 0;
    OSStatus err = UCKeyTranslate(keyLayout,
                                  aValue.unsignedShortValue,
                                  kUCKeyActionDisplay,
                                  SRCocoaToCarbonFlags(anImplicitModifierFlags.unsignedIntegerValue) >> 8,
                                  LMGetKbdType(),
                                  kUCKeyTranslateNoDeadKeysBit,
                                  &deadKeyState,
                                  sizeof(chars) / sizeof(UniChar),
                                  &actualLength,
                                  chars);
    if (err != noErr)
    {
        os_trace_error("#Error Unable to translate keyCode %hu and modifierFlags %lu", aValue.unsignedShortValue, anImplicitModifierFlags.unsignedIntegerValue);
        return nil;
    }

    if (self.isLiteral)
        return [NSString stringWithCharacters:chars length:actualLength].uppercaseString;
    else
        return [NSString stringWithCharacters:chars length:actualLength];
}

- (NSString *)transformedSpecialKeyCode:(NSNumber *)aKeyCode
              withExplicitModifierFlags:(NSNumber *)anExplicitModifierFlags
{
    return [self transformedSpecialKeyCode:aKeyCode withExplicitModifierFlags:anExplicitModifierFlags forView:nil];
}

- (NSString *)transformedSpecialKeyCode:(NSNumber *)aKeyCode
              withExplicitModifierFlags:(NSNumber *)anExplicitModifierFlags
                                forView:(NSView *)aView
{
    __auto_type layoutDirection = aView ? aView.userInterfaceLayoutDirection : NSApp.userInterfaceLayoutDirection;

    if (aKeyCode.unsignedShortValue == kVK_Tab)
    {
        if (((anExplicitModifierFlags.unsignedIntegerValue & NSShiftKeyMask) &&
             layoutDirection == NSUserInterfaceLayoutDirectionRightToLeft) ||
            ((anExplicitModifierFlags.unsignedIntegerValue & NSShiftKeyMask) == 0 &&
             layoutDirection == NSUserInterfaceLayoutDirectionLeftToRight))
        {
            if (self.isLiteral)
                return _SRUnicharToString(SRKeyCodeGlyphTabRight);
            else
                return _SRUnicharToString(NSTabCharacter);
        }
        else
        {
            if (self.isLiteral)
                return _SRUnicharToString(SRKeyCodeGlyphTabLeft);
            else
                return _SRUnicharToString(NSBackTabCharacter);
        }
    }

    if (self.isLiteral)
        return self.class.specialKeyCodeToLiteralMapping[aKeyCode];
    else
        return self.class.specialKeyCodeToSymbolMapping[aKeyCode];
}

@end
