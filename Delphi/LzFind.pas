unit LzFind;

interface

uses Winapi.Windows, System.SysUtils, LzmaTypes;

{$Z4}
type
  PCLzRef = ^TCLzRef;
  TCLzRef = UInt32;

  PCMatchFinder = ^TCMatchFinder;

  TCMatchFinder = record
    buffer: PByte;
    pos: UInt32;
    posLimit: UInt32;
    streamPos: UInt32;
    lenLimit: UInt32;

    cyclicBufferPos: UInt32;
    cyclicBufferSize: UInt32;  (* it must be = (historySize + 1) *)

    matchMaxLen: UInt32;
    hash: PCLzRef;
    son: PCLzRef;
    hashMask: UInt32;
    cutValue: UInt32;

    bufBase: PByte;
    stream: PISeqInStream;
    streamEndWasReached: Integer;

    blockSize: UInt32;
    keepSizeBefore: UInt32;
    keepSizeAfter: UInt32;

    numHashBytes: UInt32;
    directInput: Integer;
    directInputRem: SIZE_T;
    btMode: Integer;
    bigHash: Integer;
    historySize: UInt32;
    fixedHashSize: UInt32;
    numHashBytes_Min: Byte;
    numHashOutBits: Byte;
    _pad2_: array[0..1] of Byte;
    result: TSRes;
    crc: array[0..255] of UInt32;
    numRefs: SIZE_T;

    expectedDataSize: UInt64;
  end;

  //typedef void (*Mf_Init_Func)(void *object);
  Mf_Init_Func = procedure (aobject: pointer); cdecl;

  //typedef Byte (*Mf_GetIndexByte_Func)(void *object, Int32 index);
  Mf_GetIndexByte_Func = function(aobject: pointer): UInt32; cdecl;

  //typedef UInt32 (*Mf_GetNumAvailableBytes_Func)(void *object);
  Mf_GetNumAvailableBytes_Func = function(aobject: pointer): UInt32; cdecl;

  //typedef const Byte * (*Mf_GetPointerToCurrentPos_Func)(void *object);
  Mf_GetPointerToCurrentPos_Func = function(aobject: pointer): PByte; cdecl;

  //typedef UInt32 (*Mf_GetMatches_Func)(void *object, UInt32 *distances);
  Mf_GetMatches_Func = function(aobject: Pointer; var distances: UInt32): UInt32; cdecl;

  //typedef void (*Mf_Skip_Func)(void *object, UInt32);
  Mf_Skip_Func = procedure(aobject: Pointer; a: UInt32); cdecl;

  TIMatchFinder = record
    Init: Mf_Init_Func;
    GetIndexByte: Mf_GetIndexByte_Func;
    GetNumAvailableBytes: Mf_GetNumAvailableBytes_Func;
    GetPointerToCurrentPos: Mf_GetPointerToCurrentPos_Func;
    GetMatches: Mf_GetMatches_Func;
    Skip: Mf_Skip_Func;
  end;

function {$ifdef UNDERSCOREIMPORTNAME}_MatchFinder_NeedMove{$else}MatchFinder_NeedMove{$endif}(var p: TCMatchFinder): Integer; cdecl; external;

procedure {$ifdef UNDERSCOREIMPORTNAME}_MatchFinder_MoveBlock{$else}MatchFinder_MoveBlock{$endif}(var p: TCMatchFinder); cdecl; external;

procedure {$ifdef UNDERSCOREIMPORTNAME}_MatchFinder_ReadIfRequired{$else}MatchFinder_ReadIfRequired{$endif}(var p: TCMatchFinder); cdecl; external;

procedure {$ifdef UNDERSCOREIMPORTNAME}_MatchFinder_Normalize3{$else}MatchFinder_Normalize3{$endif}(subValue: UInt32; items: PCLzRef; numItems:
    UInt32); cdecl; external;

function {$ifdef UNDERSCOREIMPORTNAME}_MatchFinder_Create{$else}MatchFinder_Create{$endif}(var p: TCMatchFinder; historySize: UInt32;
    keepAddBufferBefore: UInt32; matchMaxLen: UInt32; keepAddBufferAfter:
    UInt32; var alloc: TISzAlloc): Integer; cdecl; external;

procedure {$ifdef UNDERSCOREIMPORTNAME}_MatchFinder_Init{$else}MatchFinder_Init{$endif}(var p: TCMatchFinder); cdecl; external;

function {$ifdef UNDERSCOREIMPORTNAME}_GetMatchesSpec1{$else}GetMatchesSpec1{$endif}(lenLimit: UInt32; curMatch: UInt32; pos: UInt32;
    const buffer: TBytes; son: PCLzRef; _cyclicBufferPos: UInt32;
    _cyclicBufferSize: UInt32; _cutValue: UInt32; var distances: UInt32;
    maxLen: UInt32): TArray<UInt32>; cdecl; external;

procedure {$ifdef UNDERSCOREIMPORTNAME}_MatchFinder_Construct{$else}MatchFinder_Construct{$endif}(var p: TCMatchFinder); cdecl; external;

procedure {$ifdef UNDERSCOREIMPORTNAME}_MatchFinder_Free{$else}MatchFinder_Free{$endif}(var p: TCMatchFinder; var alloc: TISzAlloc); cdecl;
    external;

procedure {$ifdef UNDERSCOREIMPORTNAME}_MatchFinder_CreateVTable{$else}MatchFinder_CreateVTable{$endif}(var p: TCMatchFinder; var vTable:
    TIMatchFinder); cdecl; external;

procedure {$ifdef UNDERSCOREIMPORTNAME}_MatchFinder_Init_LowHash{$else}MatchFinder_Init_LowHash{$endif}(var p: TCMatchFinder); cdecl; external name _PU + 'MatchFinder_Init_LowHash';

procedure {$ifdef UNDERSCOREIMPORTNAME}_MatchFinder_Init_HighHash{$else}MatchFinder_Init_HighHash{$endif}(var p: TCMatchFinder); cdecl; external name _PU + 'MatchFinder_Init_HighHash';

function {$ifdef UNDERSCOREIMPORTNAME}_GetMatchesSpecN_2{$else}GetMatchesSpecN_2{$endif}(const lenLimit : PByte; pos : NativeInt; const cur : PByte; son : PCLzRef; _cutValue : Cardinal; d : PCardinal; _maxLen : NativeInt; const hash : PCardinal; const limit : PCardinal; const size : PCardinal; _cyclicBufferPos : NativeInt; _cyclicBufferSize : Cardinal; posRes : PCardinal) : PCardinal; cdecl; external name _PU + 'GetMatchesSpecN_2';

procedure {$ifdef UNDERSCOREIMPORTNAME}_MatchFinder_Init_4{$else}MatchFinder_Init_4{$endif}(var p: TCMatchFinder); cdecl; external name _PU + 'MatchFinder_Init_4';

implementation

uses System.Win.Crtl, CPUArch;

{$ifdef Win32}
  {$L Win32\LzFind.obj}
  {$L Win32\LzFindOpt.obj}
{$else}
  {$L Win64\LzFind.o}
  {$L Win64\LzFindOpt.o}
{$endif}

end.

