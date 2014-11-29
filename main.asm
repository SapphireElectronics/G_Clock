
; CC8E Version 1.3F, Copyright (c) B Knudsen Data
; C compiler for the PIC18 microcontrollers
; ************  29. Nov 2014   0:00  *************

	processor  PIC18F26J53
	radix  DEC

TBLPTR      EQU   0xFF6
TABLAT      EQU   0xFF5
INDF0       EQU   0xFEF
POSTDEC0    EQU   0xFED
FSR0H       EQU   0xFEA
FSR0        EQU   0xFE9
WREG        EQU   0xFE8
Carry       EQU   0
Zero_       EQU   2
T0CON       EQU   0xFD5
ADRESH      EQU   0xFC4
ADRESL      EQU   0xFC3
ADCON0      EQU   0xFC2
ADCON1      EQU   0xFC1
CTMUICON    EQU   0xFB1
EECON2      EQU   0xFA7
OSCTUNE     EQU   0xF9B
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
hour        EQU   0x11
minute      EQU   0x11
second      EQU   0xF7F
hour_2      EQU   0x12
hour_3      EQU   0x12
minute_2    EQU   0x12
minute_3    EQU   0x12
second_2    EQU   0x12
second_3    EQU   0x12
led_mode    EQU   0x17
led_row     EQU   0x18
second_4    EQU   0x11
minute_4    EQU   0x11
hour_4      EQU   0x11
hour_5      EQU   0x11
minute_5    EQU   0x11
second_5    EQU   0x11
row         EQU   0x11
icon        EQU   0x11
icon_2      EQU   0x11
touch_value EQU   0x1D
touch_state EQU   0x21
touch_count EQU   0x25
touch_low_pass_count EQU   0x2D
button      EQU   0x14
wait        EQU   0x15
button_2    EQU   0x11
smp         EQU   0x12
val         EQU   0x13
state       EQU   0x31
key         EQU   0x11
sec         EQU   0x09
row_2       EQU   0x0F
delay       EQU   0x10
ci          EQU   0x16

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
			;	uns8 hour;
			;
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
			;	hour = RTCVALL;
	MOVFF RTCVALL,hour_2
			;	if( hour == 0x23 )
	MOVLW 35
	CPFSEQ hour_2,0
	BRA   m005
			;		hour = 0;
	CLRF  hour_2,0
			;	else
	BRA   m006
			;		++hour;
m005	INCF  hour_2,1,0
			;
			;	W = hour;
m006	MOVF  hour_2,W,0
			;	W = decadj( W );
	DAW  
			;	RTCVALL = W;
	MOVLB 15
	MOVWF RTCVALL,1
			;
			;	rtc_wr_disable();	// disable rtc writes
	BRA   rtc_wr_disable
			;}	
			;
			;void rtc_dec_hour( void )
			;{
rtc_dec_hour
			;	uns8 hour;
			;
			;	while( RTCSYNC );	// wait until safe to write
m007	MOVLB 15
	BTFSC 0xF3F,RTCSYNC,1
	BRA   m007
			;	RTCPTR0 = 1;		// select hours in register pointer
	MOVLB 15
	BSF   0xF3F,RTCPTR0,1
			;	rtc_wr_enable();	// enable rtc writes
	RCALL rtc_wr_enable
			;	
			;	hour = RTCVALL;
	MOVFF RTCVALL,hour_3
			;	if( hour == 0 )
	MOVF  hour_3,1,0
	BTFSS 0xFD8,Zero_,0
	BRA   m008
			;		hour = 0x23;
	MOVLW 35
	MOVWF hour_3,0
			;	else
	BRA   m009
			;		hour += 0x99;	// this is the same as subtracting 1 in 
m008	MOVLW 153
	ADDWF hour_3,1,0
			;						// BCD format. Tricky!
			;	
			;	W = hour;	
m009	MOVF  hour_3,W,0
			;	W = decadj( W );
	DAW  
			;	RTCVALL = W;
	MOVLB 15
	MOVWF RTCVALL,1
			;
			;	rtc_wr_disable();	// disable rtc writes
	BRA   rtc_wr_disable
			;}
			;
			;void rtc_inc_minute( void )
			;{
rtc_inc_minute
			;	uns8 minute;
			;	
			;	while( RTCSYNC );	// wait until safe to write
m010	MOVLB 15
	BTFSC 0xF3F,RTCSYNC,1
	BRA   m010
			;	RTCPTR0 = 0;		// select minutes in register pointer
	MOVLB 15
	BCF   0xF3F,RTCPTR0,1
			;	rtc_wr_enable();	// enable rtc writes
	RCALL rtc_wr_enable
			;
			;	minute = RTCVALH;
	MOVFF RTCVALH,minute_2
			;	if( minute == 0x59 )
	MOVLW 89
	CPFSEQ minute_2,0
	BRA   m011
			;		minute = 0;
	CLRF  minute_2,0
			;	else
	BRA   m012
			;		++minute;
m011	INCF  minute_2,1,0
			;
			;	W = minute;
m012	MOVF  minute_2,W,0
			;	W = decadj( W );
	DAW  
			;	RTCVALH = W;
	MOVLB 15
	MOVWF RTCVALH,1
			;
			;	rtc_wr_disable();	// disable rtc writes
	BRA   rtc_wr_disable
			;}	
			;
			;void rtc_dec_minute( void )
			;{
rtc_dec_minute
			;	uns8 minute;
			;	
			;	while( RTCSYNC );	// wait until safe to write
m013	MOVLB 15
	BTFSC 0xF3F,RTCSYNC,1
	BRA   m013
			;	RTCPTR0 = 0;		// select minutes in register pointer
	MOVLB 15
	BCF   0xF3F,RTCPTR0,1
			;	rtc_wr_enable();	// enable rtc writes
	RCALL rtc_wr_enable
			;
			;	minute = RTCVALH;
	MOVFF RTCVALH,minute_3
			;	if( minute == 0 )
	MOVF  minute_3,1,0
	BTFSS 0xFD8,Zero_,0
	BRA   m014
			;		minute = 0x59;
	MOVLW 89
	MOVWF minute_3,0
			;	else
	BRA   m015
			;		minute += 0x99;	// this is the same as subtracting 1 in 
m014	MOVLW 153
	ADDWF minute_3,1,0
			;						// BCD format. Tricky!
			;	
			;	W = minute;
m015	MOVF  minute_3,W,0
			;	W = decadj( W );
	DAW  
			;	RTCVALH = W;
	MOVLB 15
	MOVWF RTCVALH,1
			;
			;	rtc_wr_disable();	// disable rtc writes
	BRA   rtc_wr_disable
			;}	
			;
			;void rtc_inc_second( void )
			;{
rtc_inc_second
			;	uns8 second;
			;	
			;	while( RTCSYNC );	// wait until safe to write
m016	MOVLB 15
	BTFSC 0xF3F,RTCSYNC,1
	BRA   m016
			;	RTCPTR0 = 0;		// select seconds in register pointer
	MOVLB 15
	BCF   0xF3F,RTCPTR0,1
			;	rtc_wr_enable();	// enable rtc writes
	RCALL rtc_wr_enable
			;
			;	second = RTCVALL;
	MOVFF RTCVALL,second_2
			;	if( second == 0x59 )
	MOVLW 89
	CPFSEQ second_2,0
	BRA   m017
			;		second = 0;
	CLRF  second_2,0
			;	else
	BRA   m018
			;		second++;
m017	INCF  second_2,1,0
			;
			;	W = second;
m018	MOVF  second_2,W,0
			;	W = decadj( W );
	DAW  
			;	RTCVALL = W;
	MOVLB 15
	MOVWF RTCVALL,1
			;
			;	rtc_wr_disable();	// disable rtc writes
	BRA   rtc_wr_disable
			;}	
			;
			;void rtc_dec_second( void )
			;{
rtc_dec_second
			;	uns8 second;
			;	
			;	while( RTCSYNC );	// wait until safe to write
m019	MOVLB 15
	BTFSC 0xF3F,RTCSYNC,1
	BRA   m019
			;	RTCPTR0 = 0;		// select seconds in register pointer
	MOVLB 15
	BCF   0xF3F,RTCPTR0,1
			;	rtc_wr_enable();	// enable rtc writes
	RCALL rtc_wr_enable
			;
			;	second = RTCVALL;
	MOVFF RTCVALL,second_3
			;	if( second == 0 )
	MOVF  second_3,1,0
	BTFSS 0xFD8,Zero_,0
	BRA   m020
			;		second = 0x59;
	MOVLW 89
	MOVWF second_3,0
			;	else
	BRA   m021
			;		second += 0x99;	// this is the same as subtracting 1 in 
m020	MOVLW 153
	ADDWF second_3,1,0
			;						// BCD format. Tricky!
			;
			;	W = second;
m021	MOVF  second_3,W,0
			;	W = decadj( W );
	DAW  
			;	RTCVALL = W;
	MOVLB 15
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
	MOVWF second_4,0
			;	led_row[0].0 = second.0;
	BCF   led_row,0,0
	BTFSC second_4,0,0
	BSF   led_row,0,0
			;	led_row[1].0 = second.1;
	BCF   led_row+1,0,0
	BTFSC second_4,1,0
	BSF   led_row+1,0,0
			;	led_row[2].0 = second.2;
	BCF   led_row+2,0,0
	BTFSC second_4,2,0
	BSF   led_row+2,0,0
			;	led_row[3].0 = second.3;
	BCF   led_row+3,0,0
	BTFSC second_4,3,0
	BSF   led_row+3,0,0
			;	led_row[0].1 = second.4;
	BCF   led_row,1,0
	BTFSC second_4,4,0
	BSF   led_row,1,0
			;	led_row[1].1 = second.5;
	BCF   led_row+1,1,0
	BTFSC second_4,5,0
	BSF   led_row+1,1,0
			;	led_row[2].1 = second.6;
	BCF   led_row+2,1,0
	BTFSC second_4,6,0
	BSF   led_row+2,1,0
			;	led_row[3].1 = second.7;
	BCF   led_row+3,1,0
	BTFSC second_4,7,0
	BSF   led_row+3,1,0
			;}
	RETURN
			;	
			;// seconds are displayed in rows 4 and 5
			;// value is formatted in BCD, upper nibble is tens, lower nibble is units.
			;void led_load_minute( uns8 minute )
			;{
led_load_minute
	MOVWF minute_4,0
			;	led_row[0].3 = minute.0;
	BCF   led_row,3,0
	BTFSC minute_4,0,0
	BSF   led_row,3,0
			;	led_row[1].3 = minute.1;
	BCF   led_row+1,3,0
	BTFSC minute_4,1,0
	BSF   led_row+1,3,0
			;	led_row[2].3 = minute.2;
	BCF   led_row+2,3,0
	BTFSC minute_4,2,0
	BSF   led_row+2,3,0
			;	led_row[3].3 = minute.3;
	BCF   led_row+3,3,0
	BTFSC minute_4,3,0
	BSF   led_row+3,3,0
			;	led_row[0].4 = minute.4;
	BCF   led_row,4,0
	BTFSC minute_4,4,0
	BSF   led_row,4,0
			;	led_row[1].4 = minute.5;
	BCF   led_row+1,4,0
	BTFSC minute_4,5,0
	BSF   led_row+1,4,0
			;	led_row[2].4 = minute.6;
	BCF   led_row+2,4,0
	BTFSC minute_4,6,0
	BSF   led_row+2,4,0
			;	led_row[3].4 = minute.7;
	BCF   led_row+3,4,0
	BTFSC minute_4,7,0
	BSF   led_row+3,4,0
			;}
	RETURN
			;	
			;// seconds are displayed in rows 1 and 2
			;// value is formatted in BCD, upper nibble is tens, lower nibble is units.
			;void led_load_hour( uns8 hour )
			;{
led_load_hour
	MOVWF hour_4,0
			;	led_row[0].6 = hour.0;
	BCF   led_row,6,0
	BTFSC hour_4,0,0
	BSF   led_row,6,0
			;	led_row[1].6 = hour.1;
	BCF   led_row+1,6,0
	BTFSC hour_4,1,0
	BSF   led_row+1,6,0
			;	led_row[2].6 = hour.2;
	BCF   led_row+2,6,0
	BTFSC hour_4,2,0
	BSF   led_row+2,6,0
			;	led_row[3].6 = hour.3;
	BCF   led_row+3,6,0
	BTFSC hour_4,3,0
	BSF   led_row+3,6,0
			;	led_row[0].7 = hour.4;
	BCF   led_row,7,0
	BTFSC hour_4,4,0
	BSF   led_row,7,0
			;	led_row[1].7 = hour.5;
	BCF   led_row+1,7,0
	BTFSC hour_4,5,0
	BSF   led_row+1,7,0
			;	led_row[2].7 = hour.6;
	BCF   led_row+2,7,0
	BTFSC hour_4,6,0
	BSF   led_row+2,7,0
			;	led_row[3].7 = hour.7;
	BCF   led_row+3,7,0
	BTFSC hour_4,7,0
	BSF   led_row+3,7,0
			;}	
	RETURN
			;
			;void led_adj_hour( uns8 hour )
			;{
led_adj_hour
	MOVWF hour_5,0
			;	led_row[4] = 0b10100000;
	MOVLW 160
	MOVWF led_row+4,0
			;	led_row[3] = 0b10100000;
	MOVLW 160
	MOVWF led_row+3,0
			;	led_row[2] = 0b11100000;
	MOVLW 224
	MOVWF led_row+2,0
			;	led_row[1] = 0b10100000;
	MOVLW 160
	MOVWF led_row+1,0
			;	led_row[0] = 0b10100000;
	MOVLW 160
	MOVWF led_row,0
			;
			;	led_row[0].0 = hour.0;
	BCF   led_row,0,0
	BTFSC hour_5,0,0
	BSF   led_row,0,0
			;	led_row[1].0 = hour.1;
	BCF   led_row+1,0,0
	BTFSC hour_5,1,0
	BSF   led_row+1,0,0
			;	led_row[2].0 = hour.2;
	BCF   led_row+2,0,0
	BTFSC hour_5,2,0
	BSF   led_row+2,0,0
			;	led_row[3].0 = hour.3;
	BCF   led_row+3,0,0
	BTFSC hour_5,3,0
	BSF   led_row+3,0,0
			;	led_row[0].1 = hour.4;
	BCF   led_row,1,0
	BTFSC hour_5,4,0
	BSF   led_row,1,0
			;	led_row[1].1 = hour.5;
	BCF   led_row+1,1,0
	BTFSC hour_5,5,0
	BSF   led_row+1,1,0
			;	led_row[2].1 = hour.6;
	BCF   led_row+2,1,0
	BTFSC hour_5,6,0
	BSF   led_row+2,1,0
			;	led_row[3].1 = hour.7;
	BCF   led_row+3,1,0
	BTFSC hour_5,7,0
	BSF   led_row+3,1,0
			;}	
	RETURN
			;
			;void led_adj_minute( uns8 minute )
			;{
led_adj_minute
	MOVWF minute_5,0
			;	led_row[4] = 0b10100000;
	MOVLW 160
	MOVWF led_row+4,0
			;	led_row[3] = 0b11100000;
	MOVLW 224
	MOVWF led_row+3,0
			;	led_row[2] = 0b10100000;
	MOVLW 160
	MOVWF led_row+2,0
			;	led_row[1] = 0b10100000;
	MOVLW 160
	MOVWF led_row+1,0
			;	led_row[0] = 0b10100000;
	MOVLW 160
	MOVWF led_row,0
			;	
			;	led_row[0].0 = minute.0;
	BCF   led_row,0,0
	BTFSC minute_5,0,0
	BSF   led_row,0,0
			;	led_row[1].0 = minute.1;
	BCF   led_row+1,0,0
	BTFSC minute_5,1,0
	BSF   led_row+1,0,0
			;	led_row[2].0 = minute.2;
	BCF   led_row+2,0,0
	BTFSC minute_5,2,0
	BSF   led_row+2,0,0
			;	led_row[3].0 = minute.3;
	BCF   led_row+3,0,0
	BTFSC minute_5,3,0
	BSF   led_row+3,0,0
			;	led_row[0].1 = minute.4;
	BCF   led_row,1,0
	BTFSC minute_5,4,0
	BSF   led_row,1,0
			;	led_row[1].1 = minute.5;
	BCF   led_row+1,1,0
	BTFSC minute_5,5,0
	BSF   led_row+1,1,0
			;	led_row[2].1 = minute.6;
	BCF   led_row+2,1,0
	BTFSC minute_5,6,0
	BSF   led_row+2,1,0
			;	led_row[3].1 = minute.7;
	BCF   led_row+3,1,0
	BTFSC minute_5,7,0
	BSF   led_row+3,1,0
			;}	
	RETURN
			;
			;void led_adj_second( uns8 second )
			;{
led_adj_second
	MOVWF second_5,0
			;	led_row[4] = 0b11100000;
	MOVLW 224
	MOVWF led_row+4,0
			;	led_row[3] = 0b10000000;
	MOVLW 128
	MOVWF led_row+3,0
			;	led_row[2] = 0b11100000;
	MOVLW 224
	MOVWF led_row+2,0
			;	led_row[1] = 0b00100000;
	MOVLW 32
	MOVWF led_row+1,0
			;	led_row[0] = 0b11100000;
	MOVLW 224
	MOVWF led_row,0
			;	
			;	led_row[0].0 = second.0;
	BCF   led_row,0,0
	BTFSC second_5,0,0
	BSF   led_row,0,0
			;	led_row[1].0 = second.1;
	BCF   led_row+1,0,0
	BTFSC second_5,1,0
	BSF   led_row+1,0,0
			;	led_row[2].0 = second.2;
	BCF   led_row+2,0,0
	BTFSC second_5,2,0
	BSF   led_row+2,0,0
			;	led_row[3].0 = second.3;
	BCF   led_row+3,0,0
	BTFSC second_5,3,0
	BSF   led_row+3,0,0
			;	led_row[0].1 = second.4;
	BCF   led_row,1,0
	BTFSC second_5,4,0
	BSF   led_row,1,0
			;	led_row[1].1 = second.5;
	BCF   led_row+1,1,0
	BTFSC second_5,5,0
	BSF   led_row+1,1,0
			;	led_row[2].1 = second.6;
	BCF   led_row+2,1,0
	BTFSC second_5,6,0
	BSF   led_row+2,1,0
			;	led_row[3].1 = second.7;
	BCF   led_row+3,1,0
	BTFSC second_5,7,0
	BSF   led_row+3,1,0
			;}
	RETURN
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
	MOVLW 24
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
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m022
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m023
	XORLW 3
	BTFSC 0xFD8,Zero_,0
	BRA   m024
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m025
	BRA   m026
			;		case BUTTON_T:	led_row[4].5 = 1;	break; 
m022	BSF   led_row+4,5,0
	BRA   m026
			;		case BUTTON_O:	led_row[4].4 = 1;	break; 
m023	BSF   led_row+4,4,0
	BRA   m026
			;		case BUTTON_S:	led_row[4].2 = 1;	break; 
m024	BSF   led_row+4,2,0
	BRA   m026
			;		case BUTTON_X:	led_row[4].0 = 1;	break; 
m025	BSF   led_row+4,0,0
			;	}	
			;}
m026	RETURN
			;
			;void led_hide_icon( uns8 icon )
			;{
led_hide_icon
	MOVWF icon_2,0
			;	switch( icon ) {
	MOVF  icon_2,W,0
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m027
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m028
	XORLW 3
	BTFSC 0xFD8,Zero_,0
	BRA   m029
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m030
	BRA   m031
			;		case BUTTON_T:	led_row[4].5 = 0;	break; 
m027	BCF   led_row+4,5,0
	BRA   m031
			;		case BUTTON_O:	led_row[4].4 = 0;	break; 
m028	BCF   led_row+4,4,0
	BRA   m031
			;		case BUTTON_S:	led_row[4].2 = 0;	break; 
m029	BCF   led_row+4,2,0
	BRA   m031
			;		case BUTTON_X:	led_row[4].0 = 0;	break; 
m030	BCF   led_row+4,0,0
			;	}	
			;}		
m031	RETURN
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
			;#define TOUCH_THRESHOLD 20
			;
			;uns8 touch_value[4];
			;uns8 touch_state[4];
			;uns8 touch_count[4];
			;uns8 touch_result[4];
			;uns8 touch_low_pass_count[4];
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
			;	touch_low_pass_count[0] = 0;
	CLRF  touch_low_pass_count,0
			;	touch_low_pass_count[1] = 0;
	CLRF  touch_low_pass_count+1,0
			;	touch_low_pass_count[2] = 0;
	CLRF  touch_low_pass_count+2,0
			;	touch_low_pass_count[3] = 0;
	CLRF  touch_low_pass_count+3,0
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
m032	MOVLW 4
	CPFSLT wait,0
	BRA   m033
			;		;
	INCF  wait,1,0
	BRA   m032
			;		
			;	// stop charge, start conversion
			;	EDG1STAT = 0;
m033	BCF   0xFB2,EDG1STAT,0
			;	GO = 1;
	BSF   0xFC2,GO,0
			;	
			;	// wait until conversion is complete
			;	while( GO )
m034	BTFSC 0xFC2,GO,0
			;		;
	BRA   m034
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
			;	// cap sense values are never higher that 0x7f, so shift up
			;	// one bit to gain some precision
			;	if( ADRESH >= 0x80 )
	MOVLW 127
	CPFSGT ADRESH,0
	BRA   m035
			;		ADRESH = 0xff;
	SETF  ADRESH,0
			;	else
	BRA   m036
			;		ADRESH <<= 1;
m035	BCF   0xFD8,Carry,0
	RLCF  ADRESH,1,0
			;			
			;	ADRESH.0 = ADRESL.7;
m036	BTFSS ADRESL,7,0
	BCF   ADRESH,0,0
	BTFSC ADRESL,7,0
	BSF   ADRESH,0,0
			;	touch_result[button] = ADRESH;
	CLRF  FSR0+1,0
	MOVLW 41
	ADDWF button,W,0
	MOVWF FSR0,0
	MOVFF ADRESH,INDF0
			;	
			;	// return the (left justified) result
			;	return( ADRESH );
	MOVF  ADRESH,W,0
	RETURN
			;}	
			;
			;
			;// Use for debugging of cap sense to store latest sensed values
			;//uns8 t_s[4];
			;
			;uns8 touch_filter( uns8 button )
			;{
touch_filter
	MOVWF button_2,0
			;	uns8 smp, val;
			;	val = touch_value[ button ];
	CLRF  FSR0+1,0
	MOVLW 29
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVFF INDF0,val
			;	touch_sample( button );
	MOVF  button_2,W,0
	RCALL touch_sample
			;	smp = touch_result[ button ];
	CLRF  FSR0+1,0
	MOVLW 41
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVFF INDF0,smp
			;	
			;	// Use for debugging of cap sense to store latest sensed values
			;	//t_s[button] = smp;
			;	
			;	// if this is the first time through, take sample value as 
			;	// average value
			;	if( val == 0 )
	MOVF  val,1,0
	BTFSC 0xFD8,Zero_,0
			;		val = smp;
	MOVFF smp,val
			;	
			;	if( smp < (val-TOUCH_THRESHOLD) )
	MOVLW 20
	SUBWF val,W,0
	CPFSLT smp,0
	BRA   m038
			;	{
			;		if( touch_count[ button ] < 4 )
	CLRF  FSR0+1,0
	MOVLW 37
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVLW 4
	CPFSLT INDF0,0
	BRA   m037
			;			touch_count[ button ]++;
	CLRF  FSR0+1,0
	MOVLW 37
	ADDWF button_2,W,0
	MOVWF FSR0,0
	INCF  INDF0,1,0
			;		else
	BRA   m040
			;			touch_state[ button ] = 1;
m037	CLRF  FSR0+1,0
	MOVLW 33
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVLW 1
	MOVWF INDF0,0
			;	}
			;	else
	BRA   m040
			;	{
			;		if( touch_count[ button ] )
m038	CLRF  FSR0+1,0
	MOVLW 37
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVF  INDF0,W,0
	BTFSC 0xFD8,Zero_,0
	BRA   m039
			;			touch_count[ button ]--;
	CLRF  FSR0+1,0
	MOVLW 37
	ADDWF button_2,W,0
	MOVWF FSR0,0
	DECF  INDF0,1,0
			;		else
	BRA   m040
			;			touch_state[ button ] = 0;
m039	CLRF  FSR0+1,0
	MOVLW 33
	ADDWF button_2,W,0
	MOVWF FSR0,0
	CLRF  INDF0,0
			;	}
			;
			;	// update average value filter every 16 samples
			;	if( ++touch_low_pass_count[ button ] >= 16 )
m040	CLRF  FSR0+1,0
	MOVLW 45
	ADDWF button_2,W,0
	MOVWF FSR0,0
	INCF  INDF0,1,0
	MOVLW 15
	CPFSGT INDF0,0
	BRA   m043
			;	{
			;		touch_low_pass_count[ button ] = 0;
	CLRF  FSR0+1,0
	MOVLW 45
	ADDWF button_2,W,0
	MOVWF FSR0,0
	CLRF  INDF0,0
			;		
			;		// if the button is not pressed, use a faster filter constant
			;		if( touch_state[ button ] == 0 )
	CLRF  FSR0+1,0
	MOVLW 33
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVF  INDF0,W,0
	BTFSS 0xFD8,Zero_,0
	BRA   m041
			;		{
			;			val -= ((val>>2) + Carry);
	RRNCF val,W,0
	RRNCF WREG,1,0
	ANDLW 63
	BTFSC 0xFD8,Carry,0
	ADDLW 1
	SUBWF val,1,0
			;			val += (smp>>2) + Carry;
	RRNCF smp,W,0
	RRNCF WREG,1,0
	ANDLW 63
	BTFSC 0xFD8,Carry,0
	ADDLW 1
	ADDWF val,1,0
			;		}
			;		else
	BRA   m042
			;		{
			;			val -= ((val>>4) + Carry);
m041	SWAPF val,W,0
	ANDLW 15
	BTFSC 0xFD8,Carry,0
	ADDLW 1
	SUBWF val,1,0
			;			val += (smp>>4) + Carry;
	SWAPF smp,W,0
	ANDLW 15
	BTFSC 0xFD8,Carry,0
	ADDLW 1
	ADDWF val,1,0
			;		}
			;		
			;		// store the new filtered average value
			;		touch_value[ button ] = val;
m042	CLRF  FSR0+1,0
	MOVLW 29
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVFF val,INDF0
			;	}	
			;	
			;	return touch_state[ button ];
m043	CLRF  FSR0+1,0
	MOVLW 33
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

  ; FILE op.c
			;#ifndef _OP_C
			;#define _OP_C
			;
			;#include "rtc.h"
			;
			;uns8 state;
			;
			;void op_init( void )
			;{
op_init
			;	state = ST_RUN;
	CLRF  state,0
			;}
	RETURN
			;
			;void op_task( void )
			;{
op_task
			;	switch( state )	{
	MOVF  state,W,0
	BTFSC 0xFD8,Zero_,0
	BRA   m044
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m045
	XORLW 3
	BTFSC 0xFD8,Zero_,0
	BRA   m046
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m047
	XORLW 7
	BTFSC 0xFD8,Zero_,0
	BRA   m048
	BRA   m048
			;		case ST_RUN:
			;			led_clear();
m044	RCALL led_clear
			;			led_load_second( rtc_get_second() );
	RCALL rtc_get_second
	RCALL led_load_second
			;			led_load_minute( rtc_get_minute() );
	RCALL rtc_get_minute
	RCALL led_load_minute
			;			led_load_hour( rtc_get_hour() );
	RCALL rtc_get_hour
	RCALL led_load_hour
			;			break;
	BRA   m048
			;			
			;		case ST_ADJ_HOUR:
			;			led_adj_hour( rtc_get_hour() );
m045	RCALL rtc_get_hour
	RCALL led_adj_hour
			;			break;	
	BRA   m048
			;				
			;		case ST_ADJ_MIN:
			;			led_adj_minute( rtc_get_minute() );
m046	RCALL rtc_get_minute
	RCALL led_adj_minute
			;			break;	
	BRA   m048
			;
			;		case ST_ADJ_SEC:
			;			led_adj_second( rtc_get_second() );
m047	RCALL rtc_get_second
	RCALL led_adj_second
			;			break;	
			;
			;		case ST_ADJ_BRIGHT:
			;	}	
			;}	
m048	RETURN
			;
			;void op_proc( uns8 key )
			;{
op_proc
	MOVWF key,0
			;	switch( state )	{
	MOVF  state,W,0
	BTFSC 0xFD8,Zero_,0
	BRA   m049
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m050
	XORLW 3
	BTFSC 0xFD8,Zero_,0
	BRA   m053
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m056
	XORLW 7
	BTFSC 0xFD8,Zero_,0
	BRA   m059
	BRA   m059
			;		case ST_RUN:
			;			if( key == BUTTON_T )
m049	DECFSZ key,W,0
	BRA   m059
			;				state = ST_ADJ_HOUR;
	MOVLW 1
	MOVWF state,0
			;			break;	
	BRA   m059
			;				
			;		case ST_ADJ_HOUR:
			;			if( key == BUTTON_S )
m050	MOVLW 3
	CPFSEQ key,0
	BRA   m051
			;				rtc_inc_hour();
	RCALL rtc_inc_hour
			;			if( key == BUTTON_X )
m051	MOVLW 2
	CPFSEQ key,0
	BRA   m052
			;				rtc_dec_hour();
	RCALL rtc_dec_hour
			;			if( key == BUTTON_T )
m052	DECFSZ key,W,0
	BRA   m059
			;				state = ST_ADJ_MIN;
	MOVLW 2
	MOVWF state,0
			;			break;			
	BRA   m059
			;	
			;		case ST_ADJ_MIN:
			;			if( key == BUTTON_S )
m053	MOVLW 3
	CPFSEQ key,0
	BRA   m054
			;				rtc_inc_minute();
	RCALL rtc_inc_minute
			;			if( key == BUTTON_X )
m054	MOVLW 2
	CPFSEQ key,0
	BRA   m055
			;				rtc_dec_minute();
	RCALL rtc_dec_minute
			;			if( key == BUTTON_T )
m055	DECFSZ key,W,0
	BRA   m059
			;				state = ST_ADJ_SEC;
	MOVLW 3
	MOVWF state,0
			;			break;			
	BRA   m059
			;
			;		case ST_ADJ_SEC:
			;			if( key == BUTTON_S )
m056	MOVLW 3
	CPFSEQ key,0
	BRA   m057
			;				rtc_inc_second();
	RCALL rtc_inc_second
			;			if( key == BUTTON_X )
m057	MOVLW 2
	CPFSEQ key,0
	BRA   m058
			;				rtc_dec_second();
	RCALL rtc_dec_second
			;			if( key == BUTTON_T )
m058	DECFSZ key,W,0
	BRA   m059
			;				state = ST_RUN;
	CLRF  state,0
			;			break;			
			;
			;		case ST_ADJ_BRIGHT:
			;	}	
			;}		
m059	RETURN

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
			;// button identifiers
			;enum { BUTTON_O, BUTTON_T, BUTTON_X, BUTTON_S };
			;
			;#include "rtc.h"
			;#include "led.h"
			;#include "touch.h"
			;#include "op.h"
			;
			;#include "rtc.c"
			;#include "led.c"
			;#include "touch.c"
			;#include "op.c"
			;
			;void main(void)
			;{
main
			;	OSCTUNE = 0b10001000;	// 31.25 clock from HSINTOSC, increased by about 5% to tune RTCC
	MOVLW 136
	MOVWF OSCTUNE,0
			;	
			;	uns8 pressed[4];
			;	uns8 key;
			;	uns8 handled[4];
			;	uns8 sec;
			;	uns8 tmp[4];
			;	uns8 t;
			;	clearRAM();
	LFSR  0,3775 
m060	CLRF  POSTDEC0,0
	MOVF  FSR0H,W,0
	BNZ   m060
	MOVF  FSR0,W,0
	BNZ   m060
	CLRF  INDF0,0
			;
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
m061	MOVLW 250
	CPFSLT delay,0
	BRA   m065
			;	{
			;		for( row=0; row <=4; row++ )
	CLRF  row_2,0
m062	MOVLW 5
	CPFSLT row_2,0
	BRA   m064
			;		{
			;			led_show_row( row );
	MOVF  row_2,W,0
	RCALL led_show_row
			;
			;			while( !TMR0IF )
m063	BTFSS 0xFF2,TMR0IF,0
			;				;
	BRA   m063
			;				
			;			TMR0IF = 0;
	BCF   0xFF2,TMR0IF,0
			;		}	
	INCF  row_2,1,0
	BRA   m062
			;	}		
m064	INCF  delay,1,0
	BRA   m061
			;	
			;	led_clear();
m065	RCALL led_clear
			;	
			;	sec = 0;
	CLRF  sec,0
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
			;	op_init();
	RCALL op_init
			;
			;
			;
			;	while( 1 )
			;	{
			;			
			;//		led_load_second( rtc_get_second() );
			;//		led_load_minute( rtc_get_minute() );
			;//		led_load_hour( rtc_get_hour() );
			;		op_task();
m066	RCALL op_task
			;		
			;
			;		for( row=0; row <=4; row++ )
	CLRF  row_2,0
m067	MOVLW 5
	CPFSLT row_2,0
	BRA   m066
			;		{
			;			led_show_row( row );
	MOVF  row_2,W,0
	RCALL led_show_row
			;
			;			while( !TMR0IF )
m068	BTFSS 0xFF2,TMR0IF,0
			;				;
	BRA   m068
			;				
			;			TMR0IF = 0;
	BCF   0xFF2,TMR0IF,0
			;			
			;			if( row < 4 )
	MOVLW 4
	CPFSLT row_2,0
	BRA   m070
			;			{
			;				if( touch_filter( row ) )
	MOVF  row_2,W,0
	RCALL touch_filter
	XORLW 0
	BTFSC 0xFD8,Zero_,0
	BRA   m069
			;				{
			;					led_show_icon( row );
	MOVF  row_2,W,0
	RCALL led_show_icon
			;					pressed[ row ] = 1;
	CLRF  FSR0+1,0
	MOVF  row_2,W,0
	MOVWF FSR0,0
	MOVLW 1
	MOVWF INDF0,0
			;				}	
			;				else
	BRA   m070
			;				{
			;					led_hide_icon( row );
m069	MOVF  row_2,W,0
	RCALL led_hide_icon
			;					pressed[ row ] = 0;
	CLRF  FSR0+1,0
	MOVF  row_2,W,0
	MOVWF FSR0,0
	CLRF  INDF0,0
			;					handled[ row ] = 0;
	CLRF  FSR0+1,0
	MOVLW 5
	ADDWF row_2,W,0
	MOVWF FSR0,0
	CLRF  INDF0,0
			;				}	
			;
			;			}
			;			
			;			if( pressed[ row ] && !handled[ row ] )
m070	CLRF  FSR0+1,0
	MOVF  row_2,W,0
	MOVWF FSR0,0
	MOVF  INDF0,W,0
	BTFSC 0xFD8,Zero_,0
	BRA   m071
	CLRF  FSR0+1,0
	MOVLW 5
	ADDWF row_2,W,0
	MOVWF FSR0,0
	MOVF  INDF0,W,0
	BTFSS 0xFD8,Zero_,0
	BRA   m071
			;			{
			;				op_proc( row );
	MOVF  row_2,W,0
	RCALL op_proc
			;				handled[ row ] = 1;
	CLRF  FSR0+1,0
	MOVLW 5
	ADDWF row_2,W,0
	MOVWF FSR0,0
	MOVLW 1
	MOVWF INDF0,0
			;			}	
			;		}	
m071	INCF  row_2,1,0
	BRA   m067
			;	}		
_const1
	MOVWF ci,0
	MOVF  ci,W,0
	ADDLW 34
	MOVWF TBLPTR,0
	MOVLW 7
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
; 0x000068   19 word(s)  0 % : rtc_inc_hour
; 0x00008E   21 word(s)  0 % : rtc_dec_hour
; 0x0000B8   19 word(s)  0 % : rtc_inc_minute
; 0x0000DE   21 word(s)  0 % : rtc_dec_minute
; 0x000108   19 word(s)  0 % : rtc_inc_second
; 0x00012E   21 word(s)  0 % : rtc_dec_second
; 0x000168    4 word(s)  0 % : rtc_get_second
; 0x000160    4 word(s)  0 % : rtc_get_minute
; 0x000158    4 word(s)  0 % : rtc_get_hour
; 0x000170   26 word(s)  0 % : led_load_second
; 0x0001A4   26 word(s)  0 % : led_load_minute
; 0x0001D8   26 word(s)  0 % : led_load_hour
; 0x0002E4   11 word(s)  0 % : led_load_logo
; 0x0002FA    6 word(s)  0 % : led_clear
; 0x000306   12 word(s)  0 % : led_show_row
; 0x00037A    2 word(s)  0 % : led_init
; 0x00031E   23 word(s)  0 % : led_show_icon
; 0x00034C   23 word(s)  0 % : led_hide_icon
; 0x00037E   43 word(s)  0 % : touch_init
; 0x0003D4   89 word(s)  0 % : touch_sample
; 0x000570    2 word(s)  0 % : op_init
; 0x000574   33 word(s)  0 % : op_task
; 0x0005B6   60 word(s)  0 % : op_proc
; 0x00020C   36 word(s)  0 % : led_adj_hour
; 0x000254   36 word(s)  0 % : led_adj_minute
; 0x00029C   36 word(s)  0 % : led_adj_second
; 0x00070C   22 word(s)  0 % : _const1
; 0x000486  116 word(s)  0 % : touch_filter
; 0x00056E    1 word(s)  0 % : touch_task
; 0x00062E  111 word(s)  0 % : main

; RAM usage: 56 bytes (23 local), 3720 bytes free
; Maximum call level: 3
; Total of 932 code words (2 %)
