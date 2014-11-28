
; CC8E Version 1.3F, Copyright (c) B Knudsen Data
; C compiler for the PIC18 microcontrollers
; ************  28. Nov 2014   0:57  *************

	processor  PIC18F26J53
	radix  DEC

TBLPTR      EQU   0xFF6
TABLAT      EQU   0xFF5
INDF0       EQU   0xFEF
FSR0        EQU   0xFE9
WREG        EQU   0xFE8
Carry       EQU   0
Zero_       EQU   2
T0CON       EQU   0xFD5
ADRESH      EQU   0xFC4
ADCON0      EQU   0xFC2
ADCON1      EQU   0xFC1
CTMUICON    EQU   0xFB1
EECON2      EQU   0xFA7
TRISC       EQU   0xF94
TRISB       EQU   0xF93
TRISA       EQU   0xF92
LATA        EQU   0xF89
PORTC       EQU   0xF82
PORTB       EQU   0xF81
ANCON1      EQU   0xF49
ANCON0      EQU   0xF48
RTCVALH     EQU   0xF3B
RTCVALL     EQU   0xF3A
TMR0IF      EQU   2
GIE         EQU   7
ADON        EQU   0
GO          EQU   1
CHS0        EQU   2
CHS1        EQU   3
CTTRIG      EQU   0
IDISSEN     EQU   1
EDGSEQEN    EQU   2
EDGEN       EQU   3
TGEN        EQU   4
CTMUSIDL    EQU   5
CTMUEN      EQU   7
EDG1STAT    EQU   0
EDG2STAT    EQU   1
EDG1SEL0    EQU   2
EDG1SEL1    EQU   3
EDG1POL     EQU   4
EDG2SEL0    EQU   5
EDG2SEL1    EQU   6
EDG2POL     EQU   7
RTCPTR0     EQU   0
RTCPTR1     EQU   1
RTCSYNC     EQU   4
RTCWREN     EQU   5
RTCEN       EQU   7
hour        EQU   0x08
minute      EQU   0x08
second      EQU   0xF7F
led_mode    EQU   0x0E
led_row     EQU   0x0F
second_2    EQU   0x08
minute_2    EQU   0x08
hour_2      EQU   0x08
row         EQU   0x08
icon        EQU   0x08
icon_2      EQU   0x08
touch_value EQU   0x14
touch_state EQU   0x18
touch_count EQU   0x1C
button      EQU   0x0B
wait        EQU   0x0C
button_2    EQU   0x08
smp         EQU   0x09
val         EQU   0x0A
row_2       EQU   0x00
delay       EQU   0x01
sec         EQU   0x02
ci          EQU   0x0D

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
			;	rtc_wr_enable();	// enable rtc writes
	RCALL rtc_wr_enable
			;	RTCEN = 1;			// enable RTC
	MOVLB 15
	BSF   0xF3F,RTCEN,1
			;	rtc_wr_disable();	// disable rtc writes
	RCALL rtc_wr_disable
			;
			;	RTCPTR0 = 0;		// select second/minutes register pair
	MOVLB 15
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
			;
			;uns8 rtc_get_hour( void )
			;{
rtc_get_hour
			;	RTCPTR0 = 1;		// select hours in register pointer
	MOVLB 15
	BSF   0xF3F,RTCPTR0,1
			;	return( RTCVALL );
	MOVF  RTCVALL,W,1
	RETURN
			;}	
			;
			;uns8 rtc_get_minute( void )
			;{
rtc_get_minute
			;	RTCPTR0 = 0;		// select minutes in register pointer
	MOVLB 15
	BCF   0xF3F,RTCPTR0,1
			;	return( RTCVALH );
	MOVF  RTCVALH,W,1
	RETURN
			;}	
			;
			;uns8 rtc_get_second( void )
			;{
rtc_get_second
			;	RTCPTR0 = 0;		// select seconds in register pointer
	MOVLB 15
	BCF   0xF3F,RTCPTR0,1
			;	return( RTCVALL );
	MOVF  RTCVALL,W,1
	RETURN

  ; FILE led.c
			;#ifndef _LED_C
			;#define _LED_C
			;
			;#include "led.h"
			;
			;#define LED_ROW_PORT PORTB
			;#define LED_COL_PORT PORTC
			;
			;// LED data is stored in an array of 5 bytes.
			;// each byte represents a row
			;// row data is loaded into the row output registers,
			;//   then the corresponding col bit is set low to turn on the LEDs
			;//
			;//      MSB           LSB
			;// Row4  O 0 0 0 0 0 0 0
			;//    3  O 0 0 0 0 0 0 0
			;//    2  O 0 0 0 0 0 0 0
			;//    1  O 0 0 0 0 0 0 0
			;//    0  O 0 0 0 0 0 0 0
			;
			;uns8 led_mode;
			;uns8 led_row[5];
			;
			;const uns8 led_row_enable[5] =
			;{	
			;	0b11111110,
			;	0b11111101,
			;	0b11111011,
			;	0b10111111,
			;	0b01111111
			;};	
			;
			;// seconds are displayed in rows 7 and 8
			;// value is formatted in BCD, upper nibble is tens, lower nibble is units.
			;void led_load_second( uns8 second )
			;{
led_load_second
	MOVWF second_2,0
			;	led_row[0].0 = second.0;
	BCF   led_row,0,0
	BTFSC second_2,0,0
	BSF   led_row,0,0
			;	led_row[1].0 = second.1;
	BCF   led_row+1,0,0
	BTFSC second_2,1,0
	BSF   led_row+1,0,0
			;	led_row[2].0 = second.2;
	BCF   led_row+2,0,0
	BTFSC second_2,2,0
	BSF   led_row+2,0,0
			;	led_row[3].0 = second.3;
	BCF   led_row+3,0,0
	BTFSC second_2,3,0
	BSF   led_row+3,0,0
			;	led_row[0].1 = second.4;
	BCF   led_row,1,0
	BTFSC second_2,4,0
	BSF   led_row,1,0
			;	led_row[1].1 = second.5;
	BCF   led_row+1,1,0
	BTFSC second_2,5,0
	BSF   led_row+1,1,0
			;	led_row[2].1 = second.6;
	BCF   led_row+2,1,0
	BTFSC second_2,6,0
	BSF   led_row+2,1,0
			;	led_row[3].1 = second.7;
	BCF   led_row+3,1,0
	BTFSC second_2,7,0
	BSF   led_row+3,1,0
			;}
	RETURN
			;	
			;// seconds are displayed in rows 4 and 5
			;// value is formatted in BCD, upper nibble is tens, lower nibble is units.
			;void led_load_minute( uns8 minute )
			;{
led_load_minute
	MOVWF minute_2,0
			;	led_row[0].3 = minute.0;
	BCF   led_row,3,0
	BTFSC minute_2,0,0
	BSF   led_row,3,0
			;	led_row[1].3 = minute.1;
	BCF   led_row+1,3,0
	BTFSC minute_2,1,0
	BSF   led_row+1,3,0
			;	led_row[2].3 = minute.2;
	BCF   led_row+2,3,0
	BTFSC minute_2,2,0
	BSF   led_row+2,3,0
			;	led_row[3].3 = minute.3;
	BCF   led_row+3,3,0
	BTFSC minute_2,3,0
	BSF   led_row+3,3,0
			;	led_row[0].4 = minute.4;
	BCF   led_row,4,0
	BTFSC minute_2,4,0
	BSF   led_row,4,0
			;	led_row[1].4 = minute.5;
	BCF   led_row+1,4,0
	BTFSC minute_2,5,0
	BSF   led_row+1,4,0
			;	led_row[2].4 = minute.6;
	BCF   led_row+2,4,0
	BTFSC minute_2,6,0
	BSF   led_row+2,4,0
			;	led_row[3].4 = minute.7;
	BCF   led_row+3,4,0
	BTFSC minute_2,7,0
	BSF   led_row+3,4,0
			;}
	RETURN
			;	
			;// seconds are displayed in rows 1 and 2
			;// value is formatted in BCD, upper nibble is tens, lower nibble is units.
			;void led_load_hour( uns8 hour )
			;{
led_load_hour
	MOVWF hour_2,0
			;	led_row[0].6 = hour.0;
	BCF   led_row,6,0
	BTFSC hour_2,0,0
	BSF   led_row,6,0
			;	led_row[1].6 = hour.1;
	BCF   led_row+1,6,0
	BTFSC hour_2,1,0
	BSF   led_row+1,6,0
			;	led_row[2].6 = hour.2;
	BCF   led_row+2,6,0
	BTFSC hour_2,2,0
	BSF   led_row+2,6,0
			;	led_row[3].6 = hour.3;
	BCF   led_row+3,6,0
	BTFSC hour_2,3,0
	BSF   led_row+3,6,0
			;	led_row[0].7 = hour.4;
	BCF   led_row,7,0
	BTFSC hour_2,4,0
	BSF   led_row,7,0
			;	led_row[1].7 = hour.5;
	BCF   led_row+1,7,0
	BTFSC hour_2,5,0
	BSF   led_row+1,7,0
			;	led_row[2].7 = hour.6;
	BCF   led_row+2,7,0
	BTFSC hour_2,6,0
	BSF   led_row+2,7,0
			;	led_row[3].7 = hour.7;
	BCF   led_row+3,7,0
	BTFSC hour_2,7,0
	BSF   led_row+3,7,0
			;}	
	RETURN
			;
			;
			;void led_load_logo( void )
			;{
led_load_logo
			;	led_row[4] = 0b01100010;
	MOVLW 98
	MOVWF led_row+4,0
			;	led_row[3] = 0b10010101;
	MOVLW 149
	MOVWF led_row+3,0
			;	led_row[2] = 0b10000100;
	MOVLW 132
	MOVWF led_row+2,0
			;	led_row[1] = 0b10110101;
	MOVLW 181
	MOVWF led_row+1,0
			;	led_row[0] = 0b01100010;
	MOVLW 98
	MOVWF led_row,0
			;}	
	RETURN
			;
			;void led_clear( void )
			;{
led_clear
			;	led_row[0] = 0;
	CLRF  led_row,0
			;	led_row[1] = 0;
	CLRF  led_row+1,0
			;	led_row[2] = 0;
	CLRF  led_row+2,0
			;	led_row[3] = 0;
	CLRF  led_row+3,0
			;	led_row[4] = 0;
	CLRF  led_row+4,0
			;}	
	RETURN
			;
			;void led_show_row( uns8 row )
			;{
led_show_row
	MOVWF row,0
			;	LED_COL_PORT = 0xff;
	SETF  PORTC,0
			;	LED_ROW_PORT = led_row[ row ];
	CLRF  FSR0+1,0
	MOVLW 15
	ADDWF row,W,0
	MOVWF FSR0,0
	MOVFF INDF0,PORTB
			;	LED_COL_PORT = led_row_enable[ row ];
	MOVF  row,W,0
	RCALL _const1
	MOVWF PORTC,0
			;}	
	RETURN
			;
			;void led_show_icon( uns8 icon )
			;{
led_show_icon
	MOVWF icon,0
			;	switch( icon ) {
	MOVF  icon,W,0
	BTFSC 0xFD8,Zero_,0
	BRA   m010
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m011
	XORLW 3
	BTFSC 0xFD8,Zero_,0
	BRA   m012
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m013
	BRA   m014
			;		case 0:	led_row[4].4 = 1;	break; 
m010	BSF   led_row+4,4,0
	BRA   m014
			;		case 1:	led_row[4].5 = 1;	break; 
m011	BSF   led_row+4,5,0
	BRA   m014
			;		case 2:	led_row[4].3 = 1;	break; 
m012	BSF   led_row+4,3,0
	BRA   m014
			;		case 3:	led_row[4].1 = 1;	break; 
m013	BSF   led_row+4,1,0
			;	}	
			;}
m014	RETURN
			;
			;void led_hide_icon( uns8 icon )
			;{
led_hide_icon
	MOVWF icon_2,0
			;	switch( icon ) {
	MOVF  icon_2,W,0
	BTFSC 0xFD8,Zero_,0
	BRA   m015
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m016
	XORLW 3
	BTFSC 0xFD8,Zero_,0
	BRA   m017
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m018
	BRA   m019
			;		case 0:	led_row[4].4 = 0;	break; 
m015	BCF   led_row+4,4,0
	BRA   m019
			;		case 1:	led_row[4].5 = 0;	break; 
m016	BCF   led_row+4,5,0
	BRA   m019
			;		case 2:	led_row[4].3 = 0;	break; 
m017	BCF   led_row+4,3,0
	BRA   m019
			;		case 3:	led_row[4].1 = 0;	break; 
m018	BCF   led_row+4,1,0
			;	}	
			;}		
m019	RETURN
			;
			;void led_init( void )
			;{
led_init
			;	led_mode = LED_MODE_HORI;
	CLRF  led_mode,0
			;	led_clear();
	BRA   led_clear
			;}	

  ; FILE touch.c
			;#ifndef _TOUCH_C
			;#define _TOUCH_C
			;
			;#include "touch.h"
			;
			;#define TOUCH_THRESHOLD 5
			;
			;//uns8 touch_count;
			;uns8 touch_value[4];
			;uns8 touch_state[4];
			;uns8 touch_count[4];
			;
			;void touch_init( void )
			;{
touch_init
			;//setup CTMU
			;//CTMUCON
			;	CTMUEN = 0; //make sure CTMU is disabled
	BCF   0xFB3,CTMUEN,0
			;	CTMUSIDL = 0; //CTMU continues to run in idle mode
	BCF   0xFB3,CTMUSIDL,0
			;	TGEN = 0; //disable edge delay generation mode of the CTMU
	BCF   0xFB3,TGEN,0
			;	EDGEN = 0; //edges are blocked
	BCF   0xFB3,EDGEN,0
			;	EDGSEQEN = 0; //edge sequence not needed
	BCF   0xFB3,EDGSEQEN,0
			;	IDISSEN = 0; //Do not ground the current source
	BCF   0xFB3,IDISSEN,0
			;	CTTRIG = 0; //Trigger Output is disabled
	BCF   0xFB3,CTTRIG,0
			;	EDG2POL = 0;
	BCF   0xFB2,EDG2POL,0
			;
			;	EDG2SEL0 = 1; //Edge2 Src = OC1 (don't care)
	BSF   0xFB2,EDG2SEL0,0
			;	EDG2SEL1 = 1; //Edge2 Src = OC1 (don't care)
	BSF   0xFB2,EDG2SEL1,0
			;	EDG1POL = 1;
	BSF   0xFB2,EDG1POL,0
			;
			;	EDG1SEL0 = 1; //Edge1 Src = Timer1 (don't care)
	BSF   0xFB2,EDG1SEL0,0
			;	EDG1SEL1 = 1; //Edge1 Src = Timer1 (don't care)
	BSF   0xFB2,EDG1SEL1,0
			;
			;//CTMUICON
			;	CTMUICON = 0x03; //55uA
	MOVLW 3
	MOVWF CTMUICON,0
			;
			;//setup A/D converter
			;//	Setup analog input pins
			;	ANCON0 = 0b11111111;
	MOVLB 15
	SETF  ANCON0,1
			;	ANCON1 = 0b00011111;
	MOVLW 31
	MOVWF ANCON1,1
			;	
			;//	Configure AtoD, left justify
			;	ADCON0 = 0b00000000;
	CLRF  ADCON0,0
			;	ADCON1 = 0b00001010;
	MOVLW 10
	MOVWF ADCON1,0
			;	
			;	ADON = 1; //Turn On A/D
	BSF   0xFC2,ADON,0
			;	CTMUEN = 1; //Enable CTMU
	BSF   0xFB3,CTMUEN,0
			;	
			;// Set inputs to 0 to drain charge
			;	TRISA = 0;
	CLRF  TRISA,0
			;	LATA = 0;
	CLRF  LATA,0
			;	
			;	touch_count[0] = 0;
	CLRF  touch_count,0
			;	touch_count[1] = 0;
	CLRF  touch_count+1,0
			;	touch_count[2] = 0;
	CLRF  touch_count+2,0
			;	touch_count[3] = 0;
	CLRF  touch_count+3,0
			;	touch_state[0] = 0;
	CLRF  touch_state,0
			;	touch_state[1] = 0;
	CLRF  touch_state+1,0
			;	touch_state[2] = 0;
	CLRF  touch_state+2,0
			;	touch_state[3] = 0;
	CLRF  touch_state+3,0
			;	touch_value[0] = 0;
	CLRF  touch_value,0
			;	touch_value[1] = 0;
	CLRF  touch_value+1,0
			;	touch_value[2] = 0;
	CLRF  touch_value+2,0
			;	touch_value[3] = 0;
	CLRF  touch_value+3,0
			;}
	RETURN
			;
			;#define WAIT_COUNT 4
			;
			;const uns8 touch_button_tris[4] = { 0x01, 0x02, 0x04, 0x08 };
			;const uns8 touch_button_adcon[4] = 
			;	{ 0b11111110, 0b11111101, 0b11111011, 0b11110111 };
			;const uns8 touch_button_chs0[4] = { 0, 1, 0, 1 };
			;const uns8 touch_button_chs1[4] = { 0, 0, 1, 1 };
			;
			;uns8 touch_sample( uns8 button )
			;{
touch_sample
	MOVWF button,0
			;	uns8 wait;
			;	
			;	// drive PORTA outputs low and wait for charge to drain
			;	LATA = 0;
	CLRF  LATA,0
			;	nop(); nop(); nop(); nop(); nop(); nop(); nop(); nop();
	NOP  
	NOP  
	NOP  
	NOP  
	NOP  
	NOP  
	NOP  
	NOP  
			;	
			;	// select ANx as analog input and wait
			;	TRISA = touch_button_tris[ button ];
	MOVLW 5
	ADDWF button,W,0
	RCALL _const1
	MOVWF TRISA,0
			;	ANCON0 = touch_button_adcon[ button ];
	MOVLW 9
	ADDWF button,W,0
	RCALL _const1
	MOVLB 15
	MOVWF ANCON0,1
			;	nop(); nop(); nop(); nop(); nop(); nop(); nop(); nop();
	NOP  
	NOP  
	NOP  
	NOP  
	NOP  
	NOP  
	NOP  
	NOP  
			;	
			;	// select input ANx, drain charge on input channel
			;	CHS0 = touch_button_chs0[ button ];
	MOVLW 13
	ADDWF button,W,0
	RCALL _const1
	XORLW 0
	BTFSS 0xFD8,Zero_,0
	BSF   0xFC2,CHS0,0
	BTFSC 0xFD8,Zero_,0
	BCF   0xFC2,CHS0,0
			;	CHS1 = touch_button_chs1[ button ];
	MOVLW 17
	ADDWF button,W,0
	RCALL _const1
	XORLW 0
	BTFSS 0xFD8,Zero_,0
	BSF   0xFC2,CHS1,0
	BTFSC 0xFD8,Zero_,0
	BCF   0xFC2,CHS1,0
			;	IDISSEN = 1;
	BSF   0xFB3,IDISSEN,0
			;	nop(); nop(); nop(); nop(); nop();
	NOP  
	NOP  
	NOP  
	NOP  
	NOP  
			;
			;	// stop charge drain
			;	IDISSEN = 0;
	BCF   0xFB3,IDISSEN,0
			;	nop(); nop();
	NOP  
	NOP  
			;	
			;	// edge2 = 0, edge1 = start charge
			;	EDG2STAT = 0;
	BCF   0xFB2,EDG2STAT,0
			;	EDG1STAT = 1;
	BSF   0xFB2,EDG1STAT,0
			;
			;	for( wait = 0; wait < WAIT_COUNT; wait++ )
	CLRF  wait,0
m020	MOVLW 4
	CPFSLT wait,0
	BRA   m021
			;		;
	INCF  wait,1,0
	BRA   m020
			;		
			;	// stop charge, start conversion
			;	EDG1STAT = 0;
m021	BCF   0xFB2,EDG1STAT,0
			;	GO = 1;
	BSF   0xFC2,GO,0
			;	
			;	// wait until conversion is complete
			;	while( GO )
m022	BTFSC 0xFC2,GO,0
			;		;
	BRA   m022
			;	
			;	TRISA = 0b00000000;
	CLRF  TRISA,0
			;	LATA = 0;
	CLRF  LATA,0
			;	ANCON0 = 0b11111111;
	MOVLB 15
	SETF  ANCON0,1
			;	ANCON1 = 0b00011111;
	MOVLW 31
	MOVWF ANCON1,1
			;
			;	
			;	// return the (left justified) result
			;	return( ADRESH );
	MOVF  ADRESH,W,0
	RETURN
			;}	
			;
			;
			;uns8 t_s[4];
			;
			;uns8 touch_filter( uns8 button )
			;{
touch_filter
	MOVWF button_2,0
			;	uns8 smp, val;
			;	val = touch_value[ button ];
	CLRF  FSR0+1,0
	MOVLW 20
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVFF INDF0,val
			;	smp = touch_sample( button );
	MOVF  button_2,W,0
	RCALL touch_sample
	MOVWF smp,0
			;	
			;	t_s[button] = smp;
	CLRF  FSR0+1,0
	MOVLW 32
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVFF smp,INDF0
			;	
			;	if( val == 0 )
	MOVF  val,1,0
	BTFSC 0xFD8,Zero_,0
			;		val = smp;
	MOVFF smp,val
			;	
			;	if( smp < (val-TOUCH_THRESHOLD) )
	MOVLW 5
	SUBWF val,W,0
	CPFSLT smp,0
	BRA   m024
			;	{
			;		if( touch_count[ button ] < 4 )
	CLRF  FSR0+1,0
	MOVLW 28
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVLW 4
	CPFSLT INDF0,0
	BRA   m023
			;		{
			;			touch_count[ button ]++;
	CLRF  FSR0+1,0
	MOVLW 28
	ADDWF button_2,W,0
	MOVWF FSR0,0
	INCF  INDF0,1,0
			;		}
			;		else
	BRA   m026
			;		{
			;			touch_state[ button ] = 1;
m023	CLRF  FSR0+1,0
	MOVLW 24
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVLW 1
	MOVWF INDF0,0
			;		}
			;	}
			;	else
	BRA   m026
			;	{
			;		if( touch_count[ button ] )
m024	CLRF  FSR0+1,0
	MOVLW 28
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVF  INDF0,W,0
	BTFSC 0xFD8,Zero_,0
	BRA   m025
			;		{
			;			touch_count[ button ]--;
	CLRF  FSR0+1,0
	MOVLW 28
	ADDWF button_2,W,0
	MOVWF FSR0,0
	DECF  INDF0,1,0
			;		}
			;		else
	BRA   m026
			;		{
			;			touch_state[ button ] = 0;
m025	CLRF  FSR0+1,0
	MOVLW 24
	ADDWF button_2,W,0
	MOVWF FSR0,0
	CLRF  INDF0,0
			;		}
			;	}
			;	
			;//	if( touch_state[ button ] == 0 ) 
			;	{ 
			;//		smp >>= 1;
			;//		val >>= 1;
			;//		val = ( val+val+val+smp ) >> 1;
			;//		val += Carry;
			;
			;		val -= ((val>>3) + Carry);
m026	SWAPF val,W,0
	RLNCF WREG,1,0
	ANDLW 31
	BTFSC 0xFD8,Carry,0
	ADDLW 1
	SUBWF val,1,0
			;		val += (smp>>3) + Carry;
	SWAPF smp,W,0
	RLNCF WREG,1,0
	ANDLW 31
	BTFSC 0xFD8,Carry,0
	ADDLW 1
	ADDWF val,1,0
			;		
			;		touch_value[ button ] = val;
	CLRF  FSR0+1,0
	MOVLW 20
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVFF val,INDF0
			;	}
			;	
			;	
			;	
			;	
			;	return touch_state[ button ];
	CLRF  FSR0+1,0
	MOVLW 24
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVF  INDF0,W,0
	RETURN
			;}	
			;	
			;
			;uns8 touch_task( void )
			;{
touch_task
			;	return 0;
	RETLW 0

  ; FILE main.c
			;#pragma chip PIC18F26J53
			;
			;#pragma cdata[0x7ffc]
			;#pragma cdata[] = 0xBE, 0xF7, 0xD8, 0xFF
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
			;#include "touch.h"
			;
			;#include "rtc.c"
			;#include "led.c"
			;#include "touch.c"
			;
			;	
			;
			;void main(void)
			;{
main
			;	ADCON1 = 0x1f;
	MOVLW 31
	MOVWF ADCON1,0
			;	
			;	TRISB = 0x00;
	CLRF  TRISB,0
			;	TRISC = 0x00;
	CLRF  TRISC,0
			;	
			;	led_load_second( 5 );
	MOVLW 5
	RCALL led_load_second
			;	led_load_minute( 5 );
	MOVLW 5
	RCALL led_load_minute
			;	led_load_hour( 5 );
	MOVLW 5
	RCALL led_load_hour
			;	
			;	uns8 row;
			;	uns8 delay;
			;
			;	T0CON = 0b11000001;		// set TMR0 to overflow on 1024 instructions cycles.  1ms @ 4MHz
	MOVLW 193
	MOVWF T0CON,0
			;//	T0CON = 0b11000111;		// set TMR0 to overflow on 64k instructions cycles.  65ms
			;	TMR0IF = 0;
	BCF   0xFF2,TMR0IF,0
			;
			;	led_init();
	RCALL led_init
			;	led_load_logo();
	RCALL led_load_logo
			;
			;	for( delay = 0; delay < 250; delay++ )	// 250 x 5 x 1ms = 1.25 seconds
	CLRF  delay,0
m027	MOVLW 250
	CPFSLT delay,0
	BRA   m031
			;	{
			;		for( row=0; row <=4; row++ )
	CLRF  row_2,0
m028	MOVLW 5
	CPFSLT row_2,0
	BRA   m030
			;		{
			;			led_show_row( row );
	MOVF  row_2,W,0
	RCALL led_show_row
			;
			;			while( !TMR0IF )
m029	BTFSS 0xFF2,TMR0IF,0
			;				;
	BRA   m029
			;				
			;			TMR0IF = 0;
	BCF   0xFF2,TMR0IF,0
			;		}	
	INCF  row_2,1,0
	BRA   m028
			;	}		
m030	INCF  delay,1,0
	BRA   m027
			;	
			;	uns8 sec;
			;	led_clear();
m031	RCALL led_clear
			;	
			;	sec = 0;
	CLRF  sec,0
			;	
			;/*	
			;	while( 1 )
			;	{
			;		sec++;
			;		
			;		led_load_second( sec );
			;		
			;		for( delay = 0; delay < 200; delay++ )	// 200 x 5 x 1ms = 1.25 seconds
			;		{
			;			for( row=0; row <=4; row++ )
			;			{
			;				led_show_row( row );
			;
			;				while( !TMR0IF )
			;					;
			;				
			;				TMR0IF = 0;
			;			}	
			;		}	
			;	}		
			;*/	
			;	
			;	rtc_init();
	RCALL rtc_init
			;	
			;	rtc_set_hour( 0x11 );
	MOVLW 17
	RCALL rtc_set_hour
			;	rtc_set_minute( 0x35 );
	MOVLW 53
	RCALL rtc_set_minute
			;	
			;	touch_init();
	RCALL touch_init
			;
			;	uns8 tmp[4];
			;	uns8 t;
			;
			;	while( 1 )
			;	{
			;		led_load_second( rtc_get_second() );
m032	RCALL rtc_get_second
	RCALL led_load_second
			;		led_load_minute( rtc_get_minute() );
	RCALL rtc_get_minute
	RCALL led_load_minute
			;		led_load_hour( rtc_get_hour() );
	RCALL rtc_get_hour
	RCALL led_load_hour
			;		
			;
			;		for( row=0; row <=4; row++ )
	CLRF  row_2,0
m033	MOVLW 5
	CPFSLT row_2,0
	BRA   m032
			;		{
			;			led_show_row( row );
	MOVF  row_2,W,0
	RCALL led_show_row
			;
			;			while( !TMR0IF )
m034	BTFSS 0xFF2,TMR0IF,0
			;				;
	BRA   m034
			;				
			;			TMR0IF = 0;
	BCF   0xFF2,TMR0IF,0
			;			
			;			if( row < 4 )
	MOVLW 4
	CPFSLT row_2,0
	BRA   m036
			;			{
			;				if( touch_filter( row ) )
	MOVF  row_2,W,0
	RCALL touch_filter
	XORLW 0
	BTFSC 0xFD8,Zero_,0
	BRA   m035
			;					led_show_icon( row );
	MOVF  row_2,W,0
	RCALL led_show_icon
			;				else
	BRA   m036
			;					led_hide_icon( row );
m035	MOVF  row_2,W,0
	RCALL led_hide_icon
			;				
			;
			;#if 0
			;				t = touch_sample( row );
			;				tmp[row] = t;
			;			
			;				if( t < 78 )
			;					led_show_icon( row );
			;				else
			;					led_hide_icon( row );
			;#endif
			;			}		
			;
			;		}	
m036	INCF  row_2,1,0
	BRA   m033
			;		
			;//		tmp = touch_sample( 2 );
			;	}		
_const1
	MOVWF ci,0
	MOVF  ci,W,0
	ADDLW 112
	MOVWF TBLPTR,0
	MOVLW 4
	CLRF  TBLPTR+1,0
	ADDWFC TBLPTR+1,1,0
	CLRF  TBLPTR+2,0
	TBLRD *
	MOVF  TABLAT,W,0
	RETURN
	DW    0xFDFE
	DW    0xBFFB
	DW    0x17F
	DW    0x402
	DW    0xFE08
	DW    0xFBFD
	DW    0xF7
	DW    0x1
	DW    0x1
	DW    0x100
	DW    0x1

	ORG 0x7FFC
	DATA 0x00BE
	DATA 0x00F7
	DATA 0x00D8
	DATA 0x00FF
	DATA 0x00FD
	DATA 0x00FB
	DATA 0x00BF
	DATA 0x00FB
	END


; *** KEY INFO ***

; 0x000004    8 word(s)  0 % : rtc_init
; 0x000014    9 word(s)  0 % : rtc_wr_enable
; 0x000026    3 word(s)  0 % : rtc_wr_disable
; 0x00002C   10 word(s)  0 % : rtc_set_hour
; 0x000040   10 word(s)  0 % : rtc_set_minute
; 0x000054   10 word(s)  0 % : rtc_set_second
; 0x000068   12 word(s)  0 % : rtc_inc_hour
; 0x000080   12 word(s)  0 % : rtc_dec_hour
; 0x000098   12 word(s)  0 % : rtc_inc_minute
; 0x0000B0   12 word(s)  0 % : rtc_dec_minute
; 0x0000C8   12 word(s)  0 % : rtc_inc_second
; 0x0000E0   12 word(s)  0 % : rtc_dec_second
; 0x000108    4 word(s)  0 % : rtc_get_second
; 0x000100    4 word(s)  0 % : rtc_get_minute
; 0x0000F8    4 word(s)  0 % : rtc_get_hour
; 0x000110   26 word(s)  0 % : led_load_second
; 0x000144   26 word(s)  0 % : led_load_minute
; 0x000178   26 word(s)  0 % : led_load_hour
; 0x0001AC   11 word(s)  0 % : led_load_logo
; 0x0001C2    6 word(s)  0 % : led_clear
; 0x0001CE   12 word(s)  0 % : led_show_row
; 0x00023E    2 word(s)  0 % : led_init
; 0x0001E6   22 word(s)  0 % : led_show_icon
; 0x000212   22 word(s)  0 % : led_hide_icon
; 0x000242   39 word(s)  0 % : touch_init
; 0x000290   72 word(s)  0 % : touch_sample
; 0x00045A   22 word(s)  0 % : _const1
; 0x000320   86 word(s)  0 % : touch_filter
; 0x0003CC    1 word(s)  0 % : touch_task
; 0x0003CE   70 word(s)  0 % : main

; RAM usage: 42 bytes (14 local), 3734 bytes free
; Maximum call level: 3
; Total of 587 code words (1 %)
