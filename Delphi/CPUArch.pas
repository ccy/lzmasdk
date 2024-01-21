unit CPUArch;

interface

uses LzmaTypes;

type
  BoolInt = Integer;

function CPU_IsSupported_AVX2: BoolInt; cdecl; external
    name _PU + 'CPU_IsSupported_AVX2';

function CPU_IsSupported_SSE41: BoolInt; cdecl; external
    name _PU + 'CPU_IsSupported_SSE41';

implementation

uses Winapi.Windows;

{$ifdef Win32}
  {$L Win32\CPUArch.obj}
{$else}
  {$L Win64\CPUArch.o}
{$endif}

end.
