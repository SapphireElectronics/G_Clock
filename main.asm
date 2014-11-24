
; CC8E Version 1.3F, Copyright (c) B Knudsen Data
; C compiler for the PIC18 microcontrollers
; ************  23. Nov 2014  19:22  *************

	processor  PIC18F26J53
	radix  DEC

TBLPTR      EQU   0xFF6
TABLAT      EQU   0xFF5
INDF0       EQU   0xFEF
FSR0        EQU   0xFE9
WREG        EQU   0xFE8
EECON2      EQU   0xFA7
PORTC       EQU   0xF82
PORTB       EQU   0xF81
RTCVALH     EQU   0xF3B
RTCVALL     EQU   0xF3A
GIE         EQU   7
RTCPTR0     EQU   0
RTCPTR1     EQU   1
RTCSYNC     EQU   4
RTCWREN     EQU   5
RTCEN       EQU   7
hour        EQU   0xF7F
minute      EQU   0xF7F
second      EQU   0xF7F
led_row     EQU   0x02
second_2    EQU   0x00
minute_2    EQU   0x00
hour_2      EQU   0x00
row         EQU   0xF7F
ci          EQU   0x01

	GOTO main

  ; FILE rtc.c
			;#ifndef _RTC_C
			;#define _RTC_C
			;
			;#include "rtc.h"
			;
			;void rtc_init( void )
			;{
rtc_init
			;	RTCEN = 1;		// enable RTC
	MOVLB 15
	BSF   0xF3F,RTCEN,1
			;	RTCPTR0 = 0;	// select second/minutes register pair
	BCF   0xF3F,RTCPTR0,1
			;	RTCPTR1 = 0;
	BCF   0xF3F,RTCPTR1,1
			;	
			;}	
	RETURN
			;
			;void rtc_wr_enable( void )
			;{
rtc_wr_enable
			;	GIE = 0;		// disable all interrupts
	BCF   0xFF2,GIE,0
			;	EECON2 = 0x55;	// write unlock sequence
	MOVLW 85
	MOVWF EECON2,0
			;	EECON2 = 0xaa;
	MOVLW 170
	MOVWF EECON2,0
			;	RTCWREN = 1;	// set the write enable bit
	MOVLB 15
	BSF   0xF3F,RTCWREN,1
			;	GIE = 1;		// enable interrupts
	BSF   0xFF2,GIE,0
			;}	
	RETURN
			;
			;void rtc_wr_disable( void )
			;{
rtc_wr_disable
			;	RTCWREN = 0;	// clear the write enable bit
	MOVLB 15
	BCF   0xF3F,RTCWREN,1
			;}	
	RETURN
			;
			;void rtc_set_hour( uns8 hour )
			;{
rtc_set_hour
	MOVWF hour,0
			;	while( RTCSYNC );	// wait until safe to write
m001	MOVLB 15
	BTFSC 0xF3F,RTCSYNC,1
	BRA   m001
			;	RTCPTR0 = 1;		// select hours in register pointer
	MOVLB 15
	BSF   0xF3F,RTCPTR0,1
			;	rtc_wr_enable();	// enable rtc writes
	RCALL rtc_wr_enable
			;	RTCVALL = hour;		// load hours
	MOVFF hour,RTCVALL
			;	rtc_wr_disable();	// disable rtc writes
	BRA   rtc_wr_disable
			;}	
			;
			;void rtc_set_minute( uns8 minute )
			;{
rtc_set_minute
	MOVWF minute,0
			;	while( RTCSYNC );	// wait until safe to write
m002	MOVLB 15
	BTFSC 0xF3F,RTCSYNC,1
	BRA   m002
			;	RTCPTR0 = 0;		// select minutes in register pointer
	MOVLB 15
	BCF   0xF3F,RTCPTR0,1
			;	rtc_wr_enable();	// enable rtc writes
	RCALL rtc_wr_enable
			;	RTCVALH = minute;	// load hours
	MOVFF minute,RTCVALH
			;	rtc_wr_disable();	// disable rtc writes
	BRA   rtc_wr_disable
			;}	
			;
			;void rtc_set_second( uns8 second )
			;{
rtc_set_second
	MOVWF second,0
			;	while( RTCSYNC );	// wait until safe to write
m003	MOVLB 15
	BTFSC 0xF3F,RTCSYNC,1
	BRA   m003
			;	RTCPTR0 = 0;		// select seconds in register pointer
	MOVLB 15
	BCF   0xF3F,RTCPTR0,1
			;	rtc_wr_enable();	// enable rtc writes
	RCALL rtc_wr_enable
			;	RTCVALL = second;	// load hours
	MOVFF second,RTCVALL
			;	rtc_wr_disable();	// disable rtc writes
	BRA   rtc_wr_disable
			;}	
			;
			;void rtc_inc_hour( void )
			;{
rtc_inc_hour
			;	while( RTCSYNC );	// wait until safe to write
m004	MOVLB 15
	BTFSC 0xF3F,RTCSYNC,1
	BRA   m004
			;	RTCPTR0 = 1;		// select hours in register pointer
	MOVLB 15
	BSF   0xF3F,RTCPTR0,1
			;	rtc_wr_enable();	// enable rtc writes
	RCALL rtc_wr_enable
			;	
			;	W = RTCVALL;
	MOVLB 15
	MOVF  RTCVALL,W,1
			;	W = decadj( ++W );
	ADDLW 1
	DAW  
			;	RTCVALL = W;
	MOVWF RTCVALL,1
			;
			;	rtc_wr_disable();	// disable rtc writes
	BRA   rtc_wr_disable
			;}	
			;
			;void rtc_dec_hour( void )
			;{
rtc_dec_hour
			;	while( RTCSYNC );	// wait until safe to write
m005	MOVLB 15
	BTFSC 0xF3F,RTCSYNC,1
	BRA   m005
			;	RTCPTR0 = 1;		// select hours in register pointer
	MOVLB 15
	BSF   0xF3F,RTCPTR0,1
			;	rtc_wr_enable();	// enable rtc writes
	RCALL rtc_wr_enable
			;	
			;	W = RTCVALL;
	MOVLB 15
	MOVF  RTCVALL,W,1
			;	W = decadj( --W );
	DECF  WREG,1,0
	DAW  
			;	RTCVALL = W;
	MOVWF RTCVALL,1
			;
			;	rtc_wr_disable();	// disable rtc writes
	BRA   rtc_wr_disable
			;}
			;
			;void rtc_inc_minute( void )
			;{
rtc_inc_minute
			;	while( RTCSYNC );	// wait until safe to write
m006	MOVLB 15
	BTFSC 0xF3F,RTCSYNC,1
	BRA   m006
			;	RTCPTR0 = 0;		// select minutes in register pointer
	MOVLB 15
	BCF   0xF3F,RTCPTR0,1
			;	rtc_wr_enable();	// enable rtc writes
	RCALL rtc_wr_enable
			;
			;	W = RTCVALH;
	MOVLB 15
	MOVF  RTCVALH,W,1
			;	W = decadj( ++W );
	ADDLW 1
	DAW  
			;	RTCVALH = W;
	MOVWF RTCVALH,1
			;
			;	rtc_wr_disable();	// disable rtc writes
	BRA   rtc_wr_disable
			;}	
			;
			;void rtc_dec_minute( void )
			;{
rtc_dec_minute
			;	while( RTCSYNC );	// wait until safe to write
m007	MOVLB 15
	BTFSC 0xF3F,RTCSYNC,1
	BRA   m007
			;	RTCPTR0 = 0;		// select minutes in register pointer
	MOVLB 15
	BCF   0xF3F,RTCPTR0,1
			;	rtc_wr_enable();	// enable rtc writes
	RCALL rtc_wr_enable
			;
			;	W = RTCVALH;
	MOVLB 15
	MOVF  RTCVALH,W,1
			;	W = decadj( --W );
	DECF  WREG,1,0
	DAW  
			;	RTCVALH = W;
	MOVWF RTCVALH,1
			;
			;	rtc_wr_disable();	// disable rtc writes
	BRA   rtc_wr_disable
			;}	
			;
			;void rtc_inc_second( void )
			;{
rtc_inc_second
			;	while( RTCSYNC );	// wait until safe to write
m008	MOVLB 15
	BTFSC 0xF3F,RTCSYNC,1
	BRA   m008
			;	RTCPTR0 = 0;		// select seconds in register pointer
	MOVLB 15
	BCF   0xF3F,RTCPTR0,1
			;	rtc_wr_enable();	// enable rtc writes
	RCALL rtc_wr_enable
			;
			;	W = RTCVALL;
	MOVLB 15
	MOVF  RTCVALL,W,1
			;	W = decadj( ++W );
	ADDLW 1
	DAW  
			;	RTCVALL = W;
	MOVWF RTCVALL,1
			;
			;	rtc_wr_disable();	// disable rtc writes
	BRA   rtc_wr_disable
			;}	
			;
			;void rtc_dec_second( void )
			;{
rtc_dec_second
			;	while( RTCSYNC );	// wait until safe to write
m009	MOVLB 15
	BTFSC 0xF3F,RTCSYNC,1
	BRA   m009
			;	RTCPTR0 = 0;		// select seconds in register pointer
	MOVLB 15
	BCF   0xF3F,RTCPTR0,1
			;	rtc_wr_enable();	// enable rtc writes
	RCALL rtc_wr_enable
			;
			;	W = RTCVALL;
	MOVLB 15
	MOVF  RTCVALL,W,1
			;	W = decadj( --W );
	DECF  WREG,1,0
	DAW  
			;	RTCVALL = W;
	MOVWF RTCVALL,1
			;
			;	rtc_wr_disable();	// disable rtc writes
	BRA   rtc_wr_disable
			;}	

  ; FILE led.c
			;#ifndef _LED_C
			;#define _LED_C
			;
			;#include "led.h"
			;
			;#define LED_ROW_PORT PORTB
			;#define LED_COL_PORT PORTC
			;
			;// LED data is stored in an array of 8 bytes.
			;// each byte represents row
			;// row data is loaded into the column output registers,
			;//   then the corresponding row bit is set high to turn on the LEDs
			;
			;uns8 led_row[8];
			;
			;const uns8 led_col_map[] =
			;{
			;	0b00000000,
			;	0b01000000,
			;	0b00000100,
			;	0b01000100,
			;	0b00000010,
			;	0b01000010,
			;	0b00000110,
			;	0b01000110,
			;	0b00000001,
			;	0b01000001,
			;	0b00000101,
			;	0b01000101,
			;	0b00000011,
			;	0b01000011,
			;	0b00000111,
			;	0b01000111
			;};
			;
			;const uns8 led_row_map[] =
			;{ 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };	
			;
			;
			;
			;// seconds are displayed in rows 7 and 8
			;// value is formatted in BCD, upper nibble is tens, lower nibble is units.
			;void led_show_second( uns8 second )
			;{
led_show_second
	MOVWF second_2,0
			;	led_row[7] = led_col_map[ second & 0x0f ];
	MOVLW 15
	ANDWF second_2,W,0
	RCALL _const1
	MOVWF led_row+7,0
			;	second = swap( second );
	SWAPF second_2,1,0
			;	led_row[6] = led_col_map[ second & 0x0f ];
	MOVLW 15
	ANDWF second_2,W,0
	RCALL _const1
	MOVWF led_row+6,0
			;}
	RETURN
			;	
			;// seconds are displayed in rows 4 and 5
			;// value is formatted in BCD, upper nibble is tens, lower nibble is units.
			;void led_show_minute( uns8 minute )
			;{
led_show_minute
	MOVWF minute_2,0
			;	led_row[4] = led_col_map[ minute & 0x0f ];
	MOVLW 15
	ANDWF minute_2,W,0
	RCALL _const1
	MOVWF led_row+4,0
			;	minute = swap( minute );
	SWAPF minute_2,1,0
			;	led_row[3] = led_col_map[ minute & 0x0f ];
	MOVLW 15
	ANDWF minute_2,W,0
	RCALL _const1
	MOVWF led_row+3,0
			;}
	RETURN
			;	
			;// seconds are displayed in rows 1 and 2
			;// value is formatted in BCD, upper nibble is tens, lower nibble is units.
			;void led_show_hour( uns8 hour )
			;{
led_show_hour
	MOVWF hour_2,0
			;	led_row[1] = led_col_map[ hour & 0x0f ];
	MOVLW 15
	ANDWF hour_2,W,0
	RCALL _const1
	MOVWF led_row+1,0
			;	hour = swap( hour );
	SWAPF hour_2,1,0
			;	led_row[0] = led_col_map[ hour & 0x0f ];
	MOVLW 15
	ANDWF hour_2,W,0
	RCALL _const1
	MOVWF led_row,0
			;}	
	RETURN
			;
			;
			;void led_show_row( uns8 row )
			;{
led_show_row
	MOVWF row,0
			;	LED_ROW_PORT = 0;
	CLRF  PORTB,0
			;	LED_COL_PORT = led_row[ row ];
	CLRF  FSR0+1,0
	MOVLW 2
	ADDWF row,W,0
	MOVWF FSR0,0
	MOVFF INDF0,PORTC
			;	LED_ROW_PORT = led_row_map[ row ];
	MOVLW 16
	ADDWF row,W,0
	RCALL _const1
	MOVWF PORTB,0
			;}	
	RETURN

  ; FILE main.c
			;#pragma chip PIC18F26J53
			;
			;#pragma cdata[0x7ffc]
			;#pragma cdata[] = 0xFE, 0xF7, 0xD8, 0xFF
			;#pragma cdata[] = 0xFD, 0xFB, 0xBF, 0xFB 
			;
			;/* Pin mappings
			;	Pn	Port	Type	Name	Chan	Details
			;   	01	MCLR	Pwr		MCLR			ICSP MLR/VPP
			;	02	RA0		CapSen	BT1		AN0		Cap Sense Input 1
			;   	03	RA1		CapSen	BT2		AN1		Cap Sense Input 2
			;   	04	RA2		CapSen	BT3		AN2		Cap Sense Input 3
			;   	05	RA3		CapSen	BT4		AN3		Cap Sense Input 4
			;   	06	Vcore	Pwr		Vcore			Vcore output (filter cap)
			;   	07	RA5		Unused
			;   	08	Vss1	Pwr		GND				Ground
			;   	09	RA7		Unused
			;   	10	RA6		Unused
			;   	11	RC0		Dout	Col1	RC0		LED Column 1 - Active Low
			;   	12	RC1		Dout	Col2	RC1		LED Column 2 - Active Low
			;   	13	RC2		Dout	Col3	RC2		LED Column 3 - Active Low
			;   	14	Vusb	Pwr		Vdd
			;   	15	RC4		Comm	D-
			;   	16	RC5		Comm	D+
			;   	17	RC6		Dout	Col4	RC6		LED Column 4 - Active Low
			;   	18	RC7		Dout	Col5	RC7		LED Column 5 - Active Low
			;   	19	Vss2	Pwr		GND				Ground
			;   	20	Vdd		Pwr		Vdd				Power
			;   	21	RB0		Dout	Row1	RB0		LED Row 1 - Active Hi
			;   	22	RB1		Dout	Row2	RB1		LED Row 2 - Active Hi
			;   	23	RB2		Dout	Row3	RB2		LED Row 3 - Active Hi
			;   	24	RB3		Dout	Row4	RB3		LED Row 4 - Active Hi
			;   	25	RB4		Dout	Row5	RB4		LED Row 5 - Active Hi
			;   	26	RB5		Dout	Row6	RB5		LED Row 6 - Active Hi
			;   	27	RB6		Dout	Row7	RB6		LED Row 7 / ICSP Clock
			;   	28	RB7		Dout	Row8	RB7		LED Row 8 / ICSP Data
			;*/
			;
			;#include "rtc.h"
			;#include "led.h"
			;
			;#include "rtc.c"
			;#include "led.c"
			;
			;	
			;
			;void main(void)
			;{
main
			;	led_show_second( 5 );
	MOVLW 5
	RCALL led_show_second
			;	led_show_minute( 5 );
	MOVLW 5
	RCALL led_show_minute
			;	led_show_hour( 5 );
	MOVLW 5
	RCALL led_show_hour
	SLEEP
	RESET
_const1
	MOVWF ci,0
	MOVF  ci,W,0
	ADDLW 116
	MOVWF TBLPTR,0
	MOVLW 1
	CLRF  TBLPTR+1,0
	ADDWFC TBLPTR+1,1,0
	CLRF  TBLPTR+2,0
	TBLRD *
	MOVF  TABLAT,W,0
	RETURN
	DW    0x4000
	DW    0x4404
	DW    0x4202
	DW    0x4606
	DW    0x4101
	DW    0x4505
	DW    0x4303
	DW    0x4707
	DW    0x201
	DW    0x804
	DW    0x2010
	DW    0x8040

	ORG 0x7FFC
	DATA 0x00FE
	DATA 0x00F7
	DATA 0x00D8
	DATA 0x00FF
	DATA 0x00FD
	DATA 0x00FB
	DATA 0x00BF
	DATA 0x00FB
	END


; *** KEY INFO ***

; 0x000004    5 word(s)  0 % : rtc_init
; 0x00000E    9 word(s)  0 % : rtc_wr_enable
; 0x000020    3 word(s)  0 % : rtc_wr_disable
; 0x000026   10 word(s)  0 % : rtc_set_hour
; 0x00003A   10 word(s)  0 % : rtc_set_minute
; 0x00004E   10 word(s)  0 % : rtc_set_second
; 0x000062   12 word(s)  0 % : rtc_inc_hour
; 0x00007A   12 word(s)  0 % : rtc_dec_hour
; 0x000092   12 word(s)  0 % : rtc_inc_minute
; 0x0000AA   12 word(s)  0 % : rtc_dec_minute
; 0x0000C2   12 word(s)  0 % : rtc_inc_second
; 0x0000DA   12 word(s)  0 % : rtc_dec_second
; 0x0000F2   11 word(s)  0 % : led_show_second
; 0x000108   11 word(s)  0 % : led_show_minute
; 0x00011E   11 word(s)  0 % : led_show_hour
; 0x00015E   23 word(s)  0 % : _const1
; 0x000134   13 word(s)  0 % : led_show_row
; 0x00014E    8 word(s)  0 % : main

; RAM usage: 16 bytes (2 local), 3760 bytes free
; Maximum call level: 2
; Total of 206 code words (0 %)
