
; CC8E Version 1.3F, Copyright (c) B Knudsen Data
; C compiler for the PIC18 microcontrollers
; ************   1. Dec 2014   0:07  *************

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
PR2         EQU   0xFCB
T2CON       EQU   0xFCA
ADRESH      EQU   0xFC4
ADRESL      EQU   0xFC3
ADCON0      EQU   0xFC2
ADCON1      EQU   0xFC1
CTMUICON    EQU   0xFB1
OSCTUNE     EQU   0xF9B
TRISC       EQU   0xF94
TRISB       EQU   0xF93
TRISA       EQU   0xF92
LATA        EQU   0xF89
PORTC       EQU   0xF82
PORTB       EQU   0xF81
ANCON1      EQU   0xF49
ANCON0      EQU   0xF48
TMR0IF      EQU   2
PEIE        EQU   6
GIE         EQU   7
IPEN        EQU   7
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
TMR2IF      EQU   1
TMR2IE      EQU   1
rtc_second  EQU   0x17
rtc_minute  EQU   0x18
rtc_hour    EQU   0x19
rtc_tick    EQU   0x1A
hour        EQU   0x11
minute      EQU   0x11
second      EQU   0xF7F
led_mode    EQU   0x1B
led_row     EQU   0x1C
second_2    EQU   0x11
minute_2    EQU   0x11
hour_2      EQU   0x11
hour_3      EQU   0x11
minute_3    EQU   0x11
second_3    EQU   0x11
row         EQU   0x11
icon        EQU   0x11
icon_2      EQU   0x11
touch_value EQU   0x21
touch_state EQU   0x25
touch_count EQU   0x29
touch_low_pass_count EQU   0x31
button      EQU   0x14
wait        EQU   0x15
button_2    EQU   0x11
smp         EQU   0x12
val         EQU   0x13
state       EQU   0x35
key         EQU   0x11
sec         EQU   0x09
row_2       EQU   0x0F
delay       EQU   0x10
ci          EQU   0x16

	GOTO main

  ; FILE main.c
			;#pragma chip PIC18F26J53
			;
			;#pragma cdata[0x7ffc]
			;#pragma cdata[] = 0xBE, 0xF7, 0xD8, 0xFF
			;#pragma cdata[] = 0xFD, 0xFB, 0xBF, 0xFB 
			;
			;#include "int18XXX.h"
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
			;void _highPriorityInt(void);
			;
			;#pragma origin 0x8
	ORG 0x0008
			;interrupt highPriorityIntServer(void)
			;{
highPriorityIntServer
			;// W, STATUS and BSR are saved to shadow registers
			;// handle the interrupt
			;// 8 code words available including call and RETFIE
			;	_highPriorityInt();
	RCALL _highPriorityInt
			;// restore W, STATUS and BSR from shadow registers
			;#pragma fastMode
			;}
	RETFIE 1
			;
			;void _highPriorityInt( void )
			;{
_highPriorityInt
			;	if( TMR2IF )
	BTFSC 0xF9E,TMR2IF,0
			;		rtc_int();
	BRA   rtc_int
			;}	
	RETURN

  ; FILE rtc.c
			;#ifndef _RTC_C
			;#define _RTC_C
			;
			;#include "rtc.h"
			;
			;uns8 rtc_second;
			;uns8 rtc_minute;
			;uns8 rtc_hour;
			;uns8 rtc_tick;
			;
			;void rtc_init( void )
			;{
rtc_init
			;	T2CON = 0b01001110;		// Timer 2 on, divide by 16 * 10 = 160
	MOVLW 78
	MOVWF T2CON,0
			;	PR2 = 250;				// Match at 125
	MOVLW 250
	MOVWF PR2,0
			;							// 250 x 160 = 40000
			;							// count 25 times to divide 1MHz clock 
			;							// into 1 second intervals
			;
			;	TMR2IF = 0;				// clear interrupt flag
	BCF   0xF9E,TMR2IF,0
			;	TMR2IE = 1;				// enable TMR2 interrupt
	BSF   0xF9D,TMR2IE,0
			;}	
	RETURN
			;
			;void rtc_int( void )
			;{
rtc_int
			;	TMR2IF = 0;
	BCF   0xF9E,TMR2IF,0
			;	++rtc_tick;
	INCF  rtc_tick,1,0
			;}	
	RETURN
			;
			;void rtc_set_hour( uns8 hour )
			;{
rtc_set_hour
	MOVWF hour,0
			;	rtc_hour = hour;
	MOVFF hour,rtc_hour
			;}	
	RETURN
			;
			;void rtc_set_minute( uns8 minute )
			;{
rtc_set_minute
	MOVWF minute,0
			;	rtc_minute = minute;
	MOVFF minute,rtc_minute
			;}	
	RETURN
			;
			;void rtc_set_second( uns8 second )
			;{
rtc_set_second
	MOVWF second,0
			;	rtc_second = second;
	MOVFF second,rtc_second
			;}	
	RETURN
			;
			;void rtc_inc_hour( void )
			;{
rtc_inc_hour
			;	if( ++rtc_hour > 0x23 )
	INCF  rtc_hour,1,0
	MOVLW 35
	CPFSGT rtc_hour,0
	BRA   rtc_daw_hour
			;		rtc_hour = 0;
	CLRF  rtc_hour,0
			;	else
			;		rtc_daw_hour();
			;}	
m001	RETURN
			;
			;void rtc_dec_hour( void )
			;{
rtc_dec_hour
			;	if( rtc_hour == 0 )
	MOVF  rtc_hour,1,0
	BTFSS 0xFD8,Zero_,0
	BRA   m002
			;		rtc_hour = 0x23;
	MOVLW 35
	MOVWF rtc_hour,0
			;	else
	BRA   m003
			;	{
			;		rtc_hour += 0x99;	// this is the same as subtracting 1 in 
m002	MOVLW 153
	ADDWF rtc_hour,1,0
			;							// BCD format. Tricky!
			;		rtc_daw_hour();
	BRA   rtc_daw_hour
			;	}	
			;}
m003	RETURN
			;
			;void rtc_inc_minute( void )
			;{
rtc_inc_minute
			;	if( ++rtc_minute > 0x59 )
	INCF  rtc_minute,1,0
	MOVLW 89
	CPFSGT rtc_minute,0
	BRA   rtc_daw_minute
			;		rtc_minute = 0;
	CLRF  rtc_minute,0
			;	else
			;		rtc_daw_minute();
			;}	
m004	RETURN
			;
			;void rtc_dec_minute( void )
			;{
rtc_dec_minute
			;	if( rtc_minute == 0 )
	MOVF  rtc_minute,1,0
	BTFSS 0xFD8,Zero_,0
	BRA   m005
			;		rtc_minute = 0x59;
	MOVLW 89
	MOVWF rtc_minute,0
			;	else
	BRA   m006
			;	{
			;		rtc_minute += 0x99;	// this is the same as subtracting 1 in 
m005	MOVLW 153
	ADDWF rtc_minute,1,0
			;							// BCD format. Tricky!
			;		rtc_daw_minute();
	BRA   rtc_daw_minute
			;	}	
			;}	
m006	RETURN
			;
			;void rtc_inc_second( void )
			;{
rtc_inc_second
			;	if( ++rtc_second > 0x59 )
	INCF  rtc_second,1,0
	MOVLW 89
	CPFSGT rtc_second,0
	BRA   rtc_daw_second
			;		rtc_second = 0;
	CLRF  rtc_second,0
			;	else
			;		rtc_daw_second();
			;}	
m007	RETURN
			;
			;void rtc_dec_second( void )
			;{
rtc_dec_second
			;	if( rtc_second == 0 )
	MOVF  rtc_second,1,0
	BTFSS 0xFD8,Zero_,0
	BRA   m008
			;		rtc_second = 0x59;
	MOVLW 89
	MOVWF rtc_second,0
			;	else
	BRA   m009
			;	{
			;		rtc_second += 0x99;	// this is the same as subtracting 1 in 
m008	MOVLW 153
	ADDWF rtc_second,1,0
			;							// BCD format. Tricky!
			;		rtc_daw_second();
	BRA   rtc_daw_second
			;	}	
			;}	
m009	RETURN
			;
			;uns8 rtc_get_hour( void )
			;{
rtc_get_hour
			;	return( rtc_hour );
	MOVF  rtc_hour,W,0
	RETURN
			;}	
			;
			;uns8 rtc_get_minute( void )
			;{
rtc_get_minute
			;	return( rtc_minute );
	MOVF  rtc_minute,W,0
	RETURN
			;}	
			;
			;uns8 rtc_get_second( void )
			;{
rtc_get_second
			;	return( rtc_second );
	MOVF  rtc_second,W,0
	RETURN
			;}	
			;
			;void rtc_increment( void )
			;{
rtc_increment
			;	if( ++rtc_second <= 0x59 )
	INCF  rtc_second,1,0
	MOVLW 89
	CPFSGT rtc_second,0
			;	{
			;		rtc_daw_second();
	BRA   rtc_daw_second
			;		return;
			;	}
			;
			;	rtc_second = 0;	
	CLRF  rtc_second,0
			;	if( ++rtc_minute <= 0x59 )
	INCF  rtc_minute,1,0
	MOVLW 89
	CPFSGT rtc_minute,0
			;	{
			;		rtc_daw_minute();
	BRA   rtc_daw_minute
			;		return;
			;	}	
			;
			;	rtc_minute = 0;
	CLRF  rtc_minute,0
			;	if( ++rtc_hour <= 0x23 )
	INCF  rtc_hour,1,0
	MOVLW 35
	CPFSGT rtc_hour,0
			;	{
			;		rtc_daw_hour();
	BRA   rtc_daw_hour
			;		return;
			;	}
			;}	
	RETURN
			;
			;void rtc_daw_hour( void )
			;{
rtc_daw_hour
			;	W = rtc_hour;	
	MOVF  rtc_hour,W,0
			;	W = decadj( W );
	DAW  
			;	rtc_hour = W;
	MOVWF rtc_hour,0
			;}	
	RETURN
			;
			;void rtc_daw_minute( void )
			;{
rtc_daw_minute
			;	W = rtc_minute;
	MOVF  rtc_minute,W,0
			;	W = decadj( W );
	DAW  
			;	rtc_minute = W;
	MOVWF rtc_minute,0
			;}
	RETURN
			;
			;void rtc_daw_second( void )
			;{
rtc_daw_second
			;	W = rtc_second;
	MOVF  rtc_second,W,0
			;	W = decadj( W );
	DAW  
			;	rtc_second = W;			
	MOVWF rtc_second,0
			;}	
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
			;void led_adj_hour( uns8 hour )
			;{
led_adj_hour
	MOVWF hour_3,0
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
	BTFSC hour_3,0,0
	BSF   led_row,0,0
			;	led_row[1].0 = hour.1;
	BCF   led_row+1,0,0
	BTFSC hour_3,1,0
	BSF   led_row+1,0,0
			;	led_row[2].0 = hour.2;
	BCF   led_row+2,0,0
	BTFSC hour_3,2,0
	BSF   led_row+2,0,0
			;	led_row[3].0 = hour.3;
	BCF   led_row+3,0,0
	BTFSC hour_3,3,0
	BSF   led_row+3,0,0
			;	led_row[0].1 = hour.4;
	BCF   led_row,1,0
	BTFSC hour_3,4,0
	BSF   led_row,1,0
			;	led_row[1].1 = hour.5;
	BCF   led_row+1,1,0
	BTFSC hour_3,5,0
	BSF   led_row+1,1,0
			;	led_row[2].1 = hour.6;
	BCF   led_row+2,1,0
	BTFSC hour_3,6,0
	BSF   led_row+2,1,0
			;	led_row[3].1 = hour.7;
	BCF   led_row+3,1,0
	BTFSC hour_3,7,0
	BSF   led_row+3,1,0
			;}	
	RETURN
			;
			;void led_adj_minute( uns8 minute )
			;{
led_adj_minute
	MOVWF minute_3,0
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
	BTFSC minute_3,0,0
	BSF   led_row,0,0
			;	led_row[1].0 = minute.1;
	BCF   led_row+1,0,0
	BTFSC minute_3,1,0
	BSF   led_row+1,0,0
			;	led_row[2].0 = minute.2;
	BCF   led_row+2,0,0
	BTFSC minute_3,2,0
	BSF   led_row+2,0,0
			;	led_row[3].0 = minute.3;
	BCF   led_row+3,0,0
	BTFSC minute_3,3,0
	BSF   led_row+3,0,0
			;	led_row[0].1 = minute.4;
	BCF   led_row,1,0
	BTFSC minute_3,4,0
	BSF   led_row,1,0
			;	led_row[1].1 = minute.5;
	BCF   led_row+1,1,0
	BTFSC minute_3,5,0
	BSF   led_row+1,1,0
			;	led_row[2].1 = minute.6;
	BCF   led_row+2,1,0
	BTFSC minute_3,6,0
	BSF   led_row+2,1,0
			;	led_row[3].1 = minute.7;
	BCF   led_row+3,1,0
	BTFSC minute_3,7,0
	BSF   led_row+3,1,0
			;}	
	RETURN
			;
			;void led_adj_second( uns8 second )
			;{
led_adj_second
	MOVWF second_3,0
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
	BTFSC second_3,0,0
	BSF   led_row,0,0
			;	led_row[1].0 = second.1;
	BCF   led_row+1,0,0
	BTFSC second_3,1,0
	BSF   led_row+1,0,0
			;	led_row[2].0 = second.2;
	BCF   led_row+2,0,0
	BTFSC second_3,2,0
	BSF   led_row+2,0,0
			;	led_row[3].0 = second.3;
	BCF   led_row+3,0,0
	BTFSC second_3,3,0
	BSF   led_row+3,0,0
			;	led_row[0].1 = second.4;
	BCF   led_row,1,0
	BTFSC second_3,4,0
	BSF   led_row,1,0
			;	led_row[1].1 = second.5;
	BCF   led_row+1,1,0
	BTFSC second_3,5,0
	BSF   led_row+1,1,0
			;	led_row[2].1 = second.6;
	BCF   led_row+2,1,0
	BTFSC second_3,6,0
	BSF   led_row+2,1,0
			;	led_row[3].1 = second.7;
	BCF   led_row+3,1,0
	BTFSC second_3,7,0
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
	MOVLW 28
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
			;		case BUTTON_T:	led_row[4].5 = 1;	break; 
m010	BSF   led_row+4,5,0
	BRA   m014
			;		case BUTTON_O:	led_row[4].4 = 1;	break; 
m011	BSF   led_row+4,4,0
	BRA   m014
			;		case BUTTON_S:	led_row[4].2 = 1;	break; 
m012	BSF   led_row+4,2,0
	BRA   m014
			;		case BUTTON_X:	led_row[4].0 = 1;	break; 
m013	BSF   led_row+4,0,0
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
	XORLW 1
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
			;		case BUTTON_T:	led_row[4].5 = 0;	break; 
m015	BCF   led_row+4,5,0
	BRA   m019
			;		case BUTTON_O:	led_row[4].4 = 0;	break; 
m016	BCF   led_row+4,4,0
	BRA   m019
			;		case BUTTON_S:	led_row[4].2 = 0;	break; 
m017	BCF   led_row+4,2,0
	BRA   m019
			;		case BUTTON_X:	led_row[4].0 = 0;	break; 
m018	BCF   led_row+4,0,0
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
			;	// cap sense values are never higher that 0x7f, so shift up
			;	// one bit to gain some precision
			;	if( ADRESH >= 0x80 )
	MOVLW 127
	CPFSGT ADRESH,0
	BRA   m023
			;		ADRESH = 0xff;
	SETF  ADRESH,0
			;	else
	BRA   m024
			;		ADRESH <<= 1;
m023	BCF   0xFD8,Carry,0
	RLCF  ADRESH,1,0
			;			
			;	ADRESH.0 = ADRESL.7;
m024	BTFSS ADRESL,7,0
	BCF   ADRESH,0,0
	BTFSC ADRESL,7,0
	BSF   ADRESH,0,0
			;	touch_result[button] = ADRESH;
	CLRF  FSR0+1,0
	MOVLW 45
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
	MOVLW 33
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVFF INDF0,val
			;	touch_sample( button );
	MOVF  button_2,W,0
	RCALL touch_sample
			;	smp = touch_result[ button ];
	CLRF  FSR0+1,0
	MOVLW 45
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
	BRA   m026
			;	{
			;		if( touch_count[ button ] < 4 )
	CLRF  FSR0+1,0
	MOVLW 41
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVLW 4
	CPFSLT INDF0,0
	BRA   m025
			;			touch_count[ button ]++;
	CLRF  FSR0+1,0
	MOVLW 41
	ADDWF button_2,W,0
	MOVWF FSR0,0
	INCF  INDF0,1,0
			;		else
	BRA   m028
			;			touch_state[ button ] = 1;
m025	CLRF  FSR0+1,0
	MOVLW 37
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVLW 1
	MOVWF INDF0,0
			;	}
			;	else
	BRA   m028
			;	{
			;		if( touch_count[ button ] )
m026	CLRF  FSR0+1,0
	MOVLW 41
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVF  INDF0,W,0
	BTFSC 0xFD8,Zero_,0
	BRA   m027
			;			touch_count[ button ]--;
	CLRF  FSR0+1,0
	MOVLW 41
	ADDWF button_2,W,0
	MOVWF FSR0,0
	DECF  INDF0,1,0
			;		else
	BRA   m028
			;			touch_state[ button ] = 0;
m027	CLRF  FSR0+1,0
	MOVLW 37
	ADDWF button_2,W,0
	MOVWF FSR0,0
	CLRF  INDF0,0
			;	}
			;
			;	// update average value filter every 16 samples
			;	if( ++touch_low_pass_count[ button ] >= 16 )
m028	CLRF  FSR0+1,0
	MOVLW 49
	ADDWF button_2,W,0
	MOVWF FSR0,0
	INCF  INDF0,1,0
	MOVLW 15
	CPFSGT INDF0,0
	BRA   m031
			;	{
			;		touch_low_pass_count[ button ] = 0;
	CLRF  FSR0+1,0
	MOVLW 49
	ADDWF button_2,W,0
	MOVWF FSR0,0
	CLRF  INDF0,0
			;		
			;		// if the button is not pressed, use a faster filter constant
			;		if( touch_state[ button ] == 0 )
	CLRF  FSR0+1,0
	MOVLW 37
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVF  INDF0,W,0
	BTFSS 0xFD8,Zero_,0
	BRA   m029
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
	BRA   m030
			;		{
			;			val -= ((val>>4) + Carry);
m029	SWAPF val,W,0
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
m030	CLRF  FSR0+1,0
	MOVLW 33
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVFF val,INDF0
			;	}	
			;	
			;	return touch_state[ button ];
m031	CLRF  FSR0+1,0
	MOVLW 37
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
	BRA   m032
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m033
	XORLW 3
	BTFSC 0xFD8,Zero_,0
	BRA   m034
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m035
	XORLW 7
	BTFSC 0xFD8,Zero_,0
	BRA   m036
	BRA   m036
			;		case ST_RUN:
			;			led_clear();
m032	RCALL led_clear
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
	BRA   m036
			;			
			;		case ST_ADJ_HOUR:
			;			led_adj_hour( rtc_get_hour() );
m033	RCALL rtc_get_hour
	RCALL led_adj_hour
			;			break;	
	BRA   m036
			;				
			;		case ST_ADJ_MIN:
			;			led_adj_minute( rtc_get_minute() );
m034	RCALL rtc_get_minute
	RCALL led_adj_minute
			;			break;	
	BRA   m036
			;
			;		case ST_ADJ_SEC:
			;			led_adj_second( rtc_get_second() );
m035	RCALL rtc_get_second
	RCALL led_adj_second
			;			break;	
			;
			;		case ST_ADJ_BRIGHT:
			;	}	
			;}	
m036	RETURN
			;
			;void op_proc( uns8 key )
			;{
op_proc
	MOVWF key,0
			;	switch( state )	{
	MOVF  state,W,0
	BTFSC 0xFD8,Zero_,0
	BRA   m037
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m038
	XORLW 3
	BTFSC 0xFD8,Zero_,0
	BRA   m041
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m044
	XORLW 7
	BTFSC 0xFD8,Zero_,0
	BRA   m047
	BRA   m047
			;		case ST_RUN:
			;			if( key == BUTTON_T )
m037	DECFSZ key,W,0
	BRA   m047
			;				state = ST_ADJ_HOUR;
	MOVLW 1
	MOVWF state,0
			;			break;	
	BRA   m047
			;				
			;		case ST_ADJ_HOUR:
			;			if( key == BUTTON_S )
m038	MOVLW 3
	CPFSEQ key,0
	BRA   m039
			;				rtc_inc_hour();
	RCALL rtc_inc_hour
			;			if( key == BUTTON_X )
m039	MOVLW 2
	CPFSEQ key,0
	BRA   m040
			;				rtc_dec_hour();
	RCALL rtc_dec_hour
			;			if( key == BUTTON_T )
m040	DECFSZ key,W,0
	BRA   m047
			;				state = ST_ADJ_MIN;
	MOVLW 2
	MOVWF state,0
			;			break;			
	BRA   m047
			;	
			;		case ST_ADJ_MIN:
			;			if( key == BUTTON_S )
m041	MOVLW 3
	CPFSEQ key,0
	BRA   m042
			;				rtc_inc_minute();
	RCALL rtc_inc_minute
			;			if( key == BUTTON_X )
m042	MOVLW 2
	CPFSEQ key,0
	BRA   m043
			;				rtc_dec_minute();
	RCALL rtc_dec_minute
			;			if( key == BUTTON_T )
m043	DECFSZ key,W,0
	BRA   m047
			;				state = ST_ADJ_SEC;
	MOVLW 3
	MOVWF state,0
			;			break;			
	BRA   m047
			;
			;		case ST_ADJ_SEC:
			;			if( key == BUTTON_S )
m044	MOVLW 3
	CPFSEQ key,0
	BRA   m045
			;				rtc_inc_second();
	RCALL rtc_inc_second
			;			if( key == BUTTON_X )
m045	MOVLW 2
	CPFSEQ key,0
	BRA   m046
			;				rtc_dec_second();
	RCALL rtc_dec_second
			;			if( key == BUTTON_T )
m046	DECFSZ key,W,0
	BRA   m047
			;				state = ST_RUN;
	CLRF  state,0
			;			break;			
			;
			;		case ST_ADJ_BRIGHT:
			;	}	
			;}		
m047	RETURN

  ; FILE main.c
			;
			;#include "rtc.c"
			;#include "led.c"
			;#include "touch.c"
			;#include "op.c"
			;
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
m048	CLRF  POSTDEC0,0
	MOVF  FSR0H,W,0
	BNZ   m048
	MOVF  FSR0,W,0
	BNZ   m048
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
			;	IPEN = 0;
	BCF   0xFD0,IPEN,0
			;	PEIE = 1;
	BSF   0xFF2,PEIE,0
			;	GIE = 1;
	BSF   0xFF2,GIE,0
			;	
			;	rtc_init();
	RCALL rtc_init
			;	
			;	
			;	rtc_set_hour( 0x11 );
	MOVLW 17
	RCALL rtc_set_hour
			;	rtc_set_minute( 0x35 );
	MOVLW 53
	RCALL rtc_set_minute
			;	
			;
			;	
			;
			;	led_init();
	RCALL led_init
			;	led_load_logo();
	RCALL led_load_logo
			;
			;	for( delay = 0; delay < 250; delay++ )	// 250 x 5 x 1ms = 1.25 seconds
	CLRF  delay,0
m049	MOVLW 250
	CPFSLT delay,0
	BRA   m053
			;	{
			;		for( row=0; row <=4; row++ )
	CLRF  row_2,0
m050	MOVLW 5
	CPFSLT row_2,0
	BRA   m052
			;		{
			;			led_show_row( row );
	MOVF  row_2,W,0
	RCALL led_show_row
			;
			;			while( !TMR0IF )
m051	BTFSS 0xFF2,TMR0IF,0
			;				;
	BRA   m051
			;				
			;			TMR0IF = 0;
	BCF   0xFF2,TMR0IF,0
			;		}	
	INCF  row_2,1,0
	BRA   m050
			;	}		
m052	INCF  delay,1,0
	BRA   m049
			;	
			;	led_clear();
m053	RCALL led_clear
			;	
			;	sec = 0;
	CLRF  sec,0
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
			;		TMR2IE = 0;
m054	BCF   0xF9D,TMR2IE,0
			;		if( rtc_tick >= 25 )
	MOVLW 24
	CPFSGT rtc_tick,0
	BRA   m055
			;		{
			;			rtc_tick -= 25;
	MOVLW 25
	SUBWF rtc_tick,1,0
			;			TMR2IE = 1;
	BSF   0xF9D,TMR2IE,0
			;			rtc_increment();
	RCALL rtc_increment
			;		}	
			;		TMR2IE = 1;
m055	BSF   0xF9D,TMR2IE,0
			;			
			;//		led_load_second( rtc_get_second() );
			;//		led_load_minute( rtc_get_minute() );
			;//		led_load_hour( rtc_get_hour() );
			;		op_task();
	RCALL op_task
			;		
			;
			;		for( row=0; row <=4; row++ )
	CLRF  row_2,0
m056	MOVLW 5
	CPFSLT row_2,0
	BRA   m054
			;		{
			;			led_show_row( row );
	MOVF  row_2,W,0
	RCALL led_show_row
			;
			;			while( !TMR0IF )
m057	BTFSS 0xFF2,TMR0IF,0
			;				;
	BRA   m057
			;				
			;			TMR0IF = 0;
	BCF   0xFF2,TMR0IF,0
			;			
			;			if( row < 4 )
	MOVLW 4
	CPFSLT row_2,0
	BRA   m059
			;			{
			;				if( touch_filter( row ) )
	MOVF  row_2,W,0
	RCALL touch_filter
	XORLW 0
	BTFSC 0xFD8,Zero_,0
	BRA   m058
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
	BRA   m059
			;				{
			;					led_hide_icon( row );
m058	MOVF  row_2,W,0
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
m059	CLRF  FSR0+1,0
	MOVF  row_2,W,0
	MOVWF FSR0,0
	MOVF  INDF0,W,0
	BTFSC 0xFD8,Zero_,0
	BRA   m060
	CLRF  FSR0+1,0
	MOVLW 5
	ADDWF row_2,W,0
	MOVWF FSR0,0
	MOVF  INDF0,W,0
	BTFSS 0xFD8,Zero_,0
	BRA   m060
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
m060	INCF  row_2,1,0
	BRA   m056
			;	}		
_const1
	MOVWF ci,0
	MOVF  ci,W,0
	ADDLW 170
	MOVWF TBLPTR,0
	MOVLW 6
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

; 0x000012    7 word(s)  0 % : rtc_init
; 0x000026    4 word(s)  0 % : rtc_set_hour
; 0x00002E    4 word(s)  0 % : rtc_set_minute
; 0x000036    4 word(s)  0 % : rtc_set_second
; 0x00003E    6 word(s)  0 % : rtc_inc_hour
; 0x00004A   10 word(s)  0 % : rtc_dec_hour
; 0x00005E    6 word(s)  0 % : rtc_inc_minute
; 0x00006A   10 word(s)  0 % : rtc_dec_minute
; 0x00007E    6 word(s)  0 % : rtc_inc_second
; 0x00008A   10 word(s)  0 % : rtc_dec_second
; 0x0000A6    2 word(s)  0 % : rtc_get_second
; 0x0000A2    2 word(s)  0 % : rtc_get_minute
; 0x00009E    2 word(s)  0 % : rtc_get_hour
; 0x000020    3 word(s)  0 % : rtc_int
; 0x0000AA   15 word(s)  0 % : rtc_increment
; 0x0000C8    4 word(s)  0 % : rtc_daw_hour
; 0x0000D0    4 word(s)  0 % : rtc_daw_minute
; 0x0000D8    4 word(s)  0 % : rtc_daw_second
; 0x0000E0   26 word(s)  0 % : led_load_second
; 0x000114   26 word(s)  0 % : led_load_minute
; 0x000148   26 word(s)  0 % : led_load_hour
; 0x000254   11 word(s)  0 % : led_load_logo
; 0x00026A    6 word(s)  0 % : led_clear
; 0x000276   12 word(s)  0 % : led_show_row
; 0x0002EA    2 word(s)  0 % : led_init
; 0x00028E   23 word(s)  0 % : led_show_icon
; 0x0002BC   23 word(s)  0 % : led_hide_icon
; 0x0002EE   43 word(s)  0 % : touch_init
; 0x000344   89 word(s)  0 % : touch_sample
; 0x0004E0    2 word(s)  0 % : op_init
; 0x0004E4   33 word(s)  0 % : op_task
; 0x000526   60 word(s)  0 % : op_proc
; 0x00000C    3 word(s)  0 % : _highPriorityInt
; 0x000008    2 word(s)  0 % : highPriorityIntServer
; 0x00017C   36 word(s)  0 % : led_adj_hour
; 0x0001C4   36 word(s)  0 % : led_adj_minute
; 0x00020C   36 word(s)  0 % : led_adj_second
; 0x000694   22 word(s)  0 % : _const1
; 0x0003F6  116 word(s)  0 % : touch_filter
; 0x0004DE    1 word(s)  0 % : touch_task
; 0x00059E  123 word(s)  0 % : main

; RAM usage: 60 bytes (23 local), 3716 bytes free
; Maximum call level: 3 (+2 for interrupt)
; Total of 870 code words (2 %)
