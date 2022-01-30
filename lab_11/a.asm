    .686p                       ; create 32 bit code
    .model flat, stdcall        ; 32 bit memory model
    option casemap :none        ; case sensitive
	
    include a.inc           ; local includes for this file

    include \masm32\include\ole32.inc
    includelib \masm32\lib\ole32.lib
	
    Static   PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
    Staticr  PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
    Editml   PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
    PushButton PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD

    .data?
      hLbl1  dd ?
      hLbl2  dd ?
      hEdit1 dd ?
      hEdit2 dd ?

    .data

.code

start:

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

  ; ------------------
  ; set global values
  ; ------------------
    mov hInstance,   rv(GetModuleHandle, NULL)
    mov CommandLine, rv(GetCommandLine)
    mov hIcon,       rv(LoadIcon,hInstance,500)
    mov hCursor,     rv(LoadCursor,NULL,IDC_ARROW)
    mov sWid,        rv(GetSystemMetrics,SM_CXSCREEN)
    mov sHgt,        rv(GetSystemMetrics,SM_CYSCREEN)

  ; -------------------------------------------------
  ; load the toolbar button strip at its default size
  ; -------------------------------------------------
    invoke LoadImage,hInstance,700,IMAGE_BITMAP,0,0, \
           LR_DEFAULTSIZE or LR_LOADTRANSPARENT or LR_LOADMAP3DCOLORS

    call Main

    invoke ExitProcess,eax

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

Main proc

    LOCAL Wwd:DWORD,Wht:DWORD,Wtx:DWORD,Wty:DWORD
    LOCAL wc:WNDCLASSEX,icce:INITCOMMONCONTROLSEX

    mov icce.dwSize, SIZEOF INITCOMMONCONTROLSEX            ; set the structure size
    xor eax, eax                                            ; set EAX to zero

    mov icce.dwICC, eax
    invoke InitCommonControlsEx,ADDR icce                   ; initialise the common control library
  ; --------------------------------------

    STRING szClassName,   "lab11_Class"
    STRING szDisplayName, "Sum of Two Numbers"

  ; ---------------------------------------------------
  ; set window class attributes in WNDCLASSEX structure
  ; ---------------------------------------------------
    mov wc.cbSize,         sizeof WNDCLASSEX
    mov wc.style,          CS_BYTEALIGNCLIENT or CS_BYTEALIGNWINDOW
    m2m wc.lpfnWndProc,    OFFSET WndProc
    mov wc.cbClsExtra,     NULL
    mov wc.cbWndExtra,     NULL
    m2m wc.hInstance,      hInstance
    m2m wc.hbrBackground,  COLOR_BTNFACE+1
    mov wc.lpszMenuName,   NULL
    mov wc.lpszClassName,  OFFSET szClassName
    m2m wc.hIcon,          hIcon
    m2m wc.hCursor,        hCursor
    m2m wc.hIconSm,        hIcon

  ; ------------------------------------
  ; register class with these attributes
  ; ------------------------------------
    invoke RegisterClassEx, ADDR wc

    mov Wwd, 400
    mov Wht, 200

  ; ------------------------------------------------
  ; Top X and Y co-ordinates for the centered window
  ; ------------------------------------------------
    mov eax, sWid
    sub eax, Wwd                ; sub window width from screen width
    shr eax, 1                  ; divide it by 2
    mov Wtx, eax                ; copy it to variable

    mov eax, sHgt
    sub eax, Wht                ; sub window height from screen height
    shr eax, 1                  ; divide it by 2
    mov Wty, eax                ; copy it to variable

  ; -----------------------------------------------------------------
  ; create the main window with the size and attributes defined above
  ; -----------------------------------------------------------------
    invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES,
                          ADDR szClassName,
                          ADDR szDisplayName,
                          WS_OVERLAPPED or WS_SYSMENU,
                          Wtx,Wty,Wwd,Wht,
                          NULL,NULL,
                          hInstance,NULL
    mov hWnd,eax

    invoke ShowWindow,hWnd, SW_SHOWNORMAL
    invoke UpdateWindow,hWnd

    call MsgLoop
    ret

Main endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

MsgLoop proc

    LOCAL msg:MSG

    push ebx
    lea ebx, msg
    invoke GetMessage,ebx,0,0,0

  msgloop:
    invoke TranslateMessage, ebx
    invoke DispatchMessage,  ebx
    invoke GetMessage,ebx,0,0,0
    test eax, eax
    jnz msgloop

    pop ebx
    ret

MsgLoop endp


WndProc proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
    LOCAL buffer1[20]:BYTE
    LOCAL bufnum   :DWORD

    Switch uMsg
      Case WM_COMMAND
      ; -------------------------------------------------------------------
        Switch wParam
          case 400
            push ebx
            push eax
            invoke GetDlgItemInt,hWin,700,0,FALSE
            mov ebx, eax
            invoke GetDlgItemInt,hWin,701,0,FALSE
            add eax, ebx
            mov bufnum, eax
            invoke wsprintf, addr buffer1, chr$("The result is %u"), bufnum
            invoke MessageBox,hWin,addr buffer1,SADD("Success"),MB_OK
            pop eax
            pop ebx                        

          case 1090
          app_close:
            invoke SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL

        Endsw
      ; -------------------------------------------------------------------

      case WM_CREATE
        fn PushButton,"Get sum",hWin,15,125,150,27,400

        mov hLbl1, rv(Staticr,"First Number",hWin,15,50,80,20,502)
        fn SendMessage,hLbl1,WM_SETFONT,rv(GetStockObject,ANSI_VAR_FONT),TRUE

        mov hEdit1, rv(Editml,0,110,48,200,18,hWin,700)
        fn SendMessage,hEdit1,WM_SETFONT,rv(GetStockObject,ANSI_VAR_FONT),TRUE

        mov hLbl2, rv(Staticr,"Second Number",hWin,15,85,80,20,503)
        fn SendMessage,hLbl2,WM_SETFONT,rv(GetStockObject,ANSI_VAR_FONT),TRUE

        mov hEdit2, rv(Editml,0,110,83,200,18,hWin,701)
        fn SendMessage,hEdit2,WM_SETFONT,rv(GetStockObject,ANSI_VAR_FONT),TRUE

      case WM_DESTROY
        invoke PostQuitMessage,NULL
        return 0

    Endsw

    invoke DefWindowProc,hWin,uMsg,wParam,lParam

    ret

WndProc endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

TBcreate proc parent:DWORD

    ret

TBcreate endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

StatusBar proc hParent:DWORD

    LOCAL handl :DWORD
    LOCAL sbParts[1] :DWORD

    mov handl, rv(CreateStatusWindow,WS_CHILD or WS_VISIBLE or SBS_SIZEGRIP,NULL,hParent,200)

  ; --------------------------------------------
  ; set the width of each part, -1 for last part
  ; --------------------------------------------
    mov [sbParts+0], -1

    invoke SendMessage,handl,SB_SETPARTS,1,ADDR sbParts

    mov eax, handl

    ret

StatusBar endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

Static proc lpText:DWORD,hParent:DWORD,
                 a:DWORD,b:DWORD,wd:DWORD,ht:DWORD,ID:DWORD

    fn CreateWindowEx,WS_EX_LEFT, \
            "STATIC",lpText, \
            WS_CHILD or WS_VISIBLE or SS_LEFT, \
            a,b,wd,ht,hParent,ID, \
            hInstance,NULL

    ret

Static endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

Staticr proc lpText:DWORD,hParent:DWORD,
                 a:DWORD,b:DWORD,wd:DWORD,ht:DWORD,ID:DWORD

    fn CreateWindowEx,WS_EX_LEFT, \
            "STATIC",lpText, \
            WS_CHILD or WS_VISIBLE or SS_RIGHT, \
            a,b,wd,ht,hParent,ID, \
            hInstance,NULL

    ret

Staticr endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

Editml proc szMsg:DWORD,a:DWORD,b:DWORD,
               wd:DWORD,ht:DWORD,hParent:DWORD,ID:DWORD

    fn CreateWindowEx,WS_EX_STATICEDGE,"EDIT",szMsg, \
                WS_VISIBLE or WS_CHILDWINDOW or \
                ES_AUTOHSCROLL or ES_NOHIDESEL or ES_MULTILINE, \
                a,b,wd,ht,hParent,ID,hInstance,NULL

    ret

Editml endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

PushButton proc lpText:DWORD,hParent:DWORD,
                a:DWORD,b:DWORD,wd:DWORD,ht:DWORD,ID:DWORD

    LOCAL hCtrl :DWORD

    fn CreateWindowEx,WS_EX_LEFT, \
                      "BUTTON",lpText, \
                      WS_CHILD or WS_VISIBLE, \
                      a,b,wd,ht,hParent,ID, \
                      hInstance,NULL
    mov hCtrl, eax
    invoke SendMessage,hCtrl,WM_SETFONT,rv(GetStockObject,ANSI_VAR_FONT),0
    mov eax, hCtrl

    ret

PushButton endp

end start