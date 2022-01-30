; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

;     include files
;     ~~~~~~~~~~~~~
      include \masm32\INCLUDE\windows.inc
      include \masm32\INCLUDE\masm32.inc
      include \masm32\INCLUDE\gdi32.inc
      include \masm32\INCLUDE\user32.inc
      include \masm32\INCLUDE\kernel32.inc
      include \masm32\INCLUDE\Comctl32.inc
      include \masm32\INCLUDE\comdlg32.inc
      include \masm32\INCLUDE\shell32.inc
      include \masm32\INCLUDE\oleaut32.inc
      include \masm32\INCLUDE\msvcrt.inc

      include \masm32\macros\macros.asm

;     libraries
;     ~~~~~~~~~
      includelib \masm32\LIB\masm32.lib
      includelib \masm32\LIB\gdi32.lib
      includelib \masm32\LIB\user32.lib
      includelib \masm32\LIB\kernel32.lib
      includelib \masm32\LIB\Comctl32.lib
      includelib \masm32\LIB\comdlg32.lib
      includelib \masm32\LIB\shell32.lib
      includelib \masm32\LIB\oleaut32.lib
      includelib \masm32\LIB\msvcrt.lib

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

      ; -----------------
      ; Local prototypes
      ; -----------------
        WndProc          PROTO :DWORD,:DWORD,:DWORD,:DWORD
        MsgLoop          PROTO
        Main             PROTO
        rebar            PROTO :DWORD,:DWORD,:DWORD
        addband          PROTO :DWORD,:DWORD

; ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-

      IFNDEF cgv                     ;; include this macro if not defined elsewhere
        cgv MACRO args:VARARG
          LOCAL hndl
          .data?
            hndl dd ?
          .code
            invoke args
            mov hndl, eax
          EXITM < EQU <hndl>>
        ENDM
      ENDIF

; ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-ч-

  ; -----------------------------
  ; uninitialised data allocation
  ; -----------------------------
    .data?
        hInstance   dd ?
        hWnd        dd ?
        hIcon       dd ?
        hCursor     dd ?
        CommandLine dd ?
        sWid        dd ?
        sHgt        dd ?

IF 0  ; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

    insert additional code files within the .CODE section

ENDIF ; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

  .code
    include misc.asm

    .data
