;Small demostration program to display coloured screen segments
;based on the inputs received from a cassette loading program file
;First published in Your Computer September 1984
        ORG   $6000
        SETDP 0

INPUT0  FCB   $43 
INPUT1  FCB   0
INPUT2  FCB   0

START   JSR   $8015             ;Turn Motor On
        JSR   $BAEC             ;Audio On
        LDB   #$80
        JSR   $BA79             ;Clear screen to character in "B" register
MAINLP  JSR   $8024             ;Input one byte from cassette to Register A
        
        ;Calculate input value
        STA   INPUT0
        LDA   #$1F
        STA   INPUT1
        LDA   #$08
        STA   INPUT2
        LDB   INPUT0
        CLRA
LP2     ASLB
        ROLA
        CMPA  INPUT1
        BCS   LP1
        SUBA  INPUT1
        INCB
LP1     DEC   INPUT2
        BNE   LP2
        
        ;based on value branch to set appropriate screen segment
        CMPA  #$01
        BEQ   CHK1
        CMPA  #$02
        BEQ   CHK2
        CMPA  #$03
        BEQ   CHK3
        CMPA  #$04
        BEQ   CHK4
        CMPA  #$05
        BEQ   CHK5
        CMPA  #$06
        BEQ   CHK6
        CMPA  #$07
        LBEQ  CHK7
        CMPA  #$08
        LBEQ  CHK8
        BRA   MAINLP

CHK1    LDA   $0400             ;Get character currently displayed in 1st segment
        CMPA  #$8F              ;is segment already drawn?
        BEQ   CHK1A            ;Yes - jump to clear
        LDB   #$8F              ;No - set to colour
        BRA   CHK1B            
CHK1A   LDB   #$80              ;set blank character
CHK1B   LDX   #$0400            ;set start position
        LBSR  SHOW              ;draw screen
        BRA   MAINLP            ;start again

CHK2    LDA   $040B
        CMPA  #$9F
        BEQ   CHK2A
        LDB   #$9F
        BRA   CHK2B
CHK2A   LDB   #$80
CHK2B   LDX   #$040B
        LBSR  SHOW
        BRA   MAINLP

CHK3    LDA   $0416
        CMPA  #$AF
        BEQ   CHK3A
        LDB   #$AF
        BRA   CHK3B
CHK3A   LDB   #$80
CHK3B   LDX   #$0416
        BSR   SHOW
        LBRA  MAINLP

CHK4    LDA   $04A0
        CMPA  #$BF
        BEQ   CHK4A
        LDB   #$BF
        BRA   CHK4B
CHK4A   LDB   #$80
CHK4B   LDX   #$04A0
        BSR   SHOW
        LBRA  MAINLP

CHK5    LDA   $04B6
        CMPA  #$CF
        BEQ   CHK5A
        LDB   #$CF
        BRA   CHK5B
CHK5A   LDB   #$80
CHK5B   LDX   #$04B6
        BSR   SHOW
        LBRA  MAINLP

CHK6    LDA   $0540
        CMPA  #$DF
        BEQ   CHK6A
        LDB   #$DF
        BRA   CHK6B
CHK6A   LDB   #$80
CHK6B   LDX   #$0540
        BSR   SHOW
        LBRA  MAINLP

CHK7    LDA   $054B
        CMPA  #$EF
        BEQ   CHK7A
        LDB   #$EF
        BRA   CHK7B
CHK7A   LDB   #$80
CHK7B   LDX   #$054B
        BSR   SHOW
        LBRA  MAINLP

CHK8    LDA   $0556
        CMPA  #$FF
        BEQ   CHK8A
        LDB   #$FF
        BRA   CHK8B
CHK8A   LDB   #$80
CHK8B   LDX   #$0556
        BSR   SHOW
        LBRA  MAINLP

SHOW    TFR   B,A
        LDB   #$05              ;depth of segment
SHOW2   LDY   #$000A            ;width of segment
SHOW1   STA   ,X+               ;draw chacter to screen
        LEAY  -1,Y              ;reduce width counter
        BNE   SHOW1             ;still more columns to draw?
        LEAX  22,X              ;go down to next row
        DECB                    ;reduce row counter
        BNE   SHOW2             ;still more rows to draw?
        RTS                     ;Return
