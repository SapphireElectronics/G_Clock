
; CC8E Version 1.3F, Copyright (c) B Knudsen Data
; C compiler for the PIC18 microcontrollers
; ************   3. Dec 2014  23:51  *************

	processor  PIC18F26J53
	radix  DEC

TBLPTR      EQU   0xFF6
TABLAT      EQU   0xFF5
PRODL       EQU   0xFF3
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
rtc_second  EQU   0x18
rtc_minute  EQU   0x19
rtc_hour    EQU   0x1A
rtc_tick    EQU   0x1B
hour        EQU   0x11
minute      EQU   0x11
second      EQU   0xF7F
led_mode    EQU   0x1C
led_row     EQU   0x1D
second_2    EQU   0x11
minute_2    EQU   0x11
hour_2      EQU   0x11
hour_3      EQU   0x11
minute_3    EQU   0x11
second_3    EQU   0x11
row         EQU   0x11
data        EQU   0x12
data_2      EQU   0x16
icon        EQU   0x11
icon_2      EQU   0x11
touch_value EQU   0x22
touch_state EQU   0x26
touch_count EQU   0x2A
touch_low_pass_count EQU   0x32
button      EQU   0x14
wait        EQU   0x15
button_2    EQU   0x11
smp         EQU   0x12
val         EQU   0x13
state       EQU   0x36
param       EQU   0x37
key         EQU   0x11
data_3      EQU   0x15
data_4      EQU   0x12
key_2       EQU   0x13
value       EQU   0x14
sec         EQU   0x09
row_2       EQU   0x0F
delay       EQU   0x10
ci          EQU   0x17

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
			;
			;// Parameters
			;// - brightness
			;// - clock correction
			;// - display timeout
			;
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
			;	
			;	rtc_hour = 0;
	CLRF  rtc_hour,0
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
			;const uns8 led_char[] = 
			;{
			;	0b01000000, 0b10100000, 0b11100000, 0b10100000, 0b10100000,		// A
			;	0b11000000, 0b10100000, 0b11000000, 0b10100000, 0b11000000,		// B
			;	0b01000000, 0b10100000, 0b10000000, 0b10100000, 0b01000000,		// C
			;	0b11000000, 0b10100000, 0b10100000, 0b10100000, 0b11000000,		// D
			;	0b11100000, 0b10000000, 0b11100000, 0b10000000, 0b11100000,		// E
			;	0b11100000, 0b10000000, 0b11100000, 0b10000000, 0b10000000,		// F
			;	0b01000000, 0b10100000, 0b10000000, 0b11100000, 0b01000000,		// G
			;	0b10100000, 0b10100000, 0b11100000, 0b10100000, 0b10100000,		// H
			;	0b01000000, 0b01000000, 0b01000000, 0b01000000, 0b11100000,		// I
			;	0b00100000, 0b00100000, 0b00100000, 0b10100000, 0b01000000,		// J
			;	0b10100000, 0b11000000, 0b10000000, 0b11000000, 0b10100000,		// K
			;	0b10000000, 0b10000000, 0b10000000, 0b10000000, 0b11100000,		// L
			;	0b10100000, 0b11100000, 0b10100000, 0b10100000, 0b10100000,		// M
			;	0b10100000, 0b11100000, 0b11100000, 0b10100000, 0b10100000,		// N
			;	0b01000000, 0b10100000, 0b10100000, 0b10100000, 0b01000000,		// O
			;	0b11000000, 0b10100000, 0b11000000, 0b10000000, 0b10000000,		// P
			;	0b01000000, 0b10100000, 0b10100000, 0b10100000, 0b01100000,		// Q
			;	0b11000000, 0b10100000, 0b11000000, 0b11000000, 0b10100000,		// R
			;	0b11100000, 0b10000000, 0b01000000, 0b00100000, 0b11100000,		// S
			;	0b11100000, 0b01000000, 0b01000000, 0b01000000, 0b11100000,		// T
			;	0b10100000, 0b10100000, 0b10100000, 0b10100000, 0b11100000,		// U
			;	0b10100000, 0b10100000, 0b10100000, 0b10100000, 0b01000000,		// V
			;	0b10100000, 0b10100000, 0b10100000, 0b11100000, 0b10100000,		// W
			;	0b10100000, 0b10100000, 0b01000000, 0b10100000, 0b10100000,		// X
			;	0b10100000, 0b10100000, 0b01000000, 0b01000000, 0b01000000,		// Y
			;	0b11100000, 0b00100000, 0b01000000, 0b10000000, 0b11100000		// Z
			;};	
			;
			;const uns8 led_value[] = 
			;{
			;	0b00000010, 0b00000101, 0b00000101, 0b00000101, 0b00000010,		// 0
			;	0b00000010, 0b00000010, 0b00000010, 0b00000010, 0b00000010,		// 1
			;	0b00000110, 0b00000001, 0b00000010, 0b00000100, 0b00000111,		// 2
			;	0b00000110, 0b00000001, 0b00000010, 0b00000001, 0b00000110,		// 3
			;	0b00000101, 0b00000101, 0b00000111, 0b00000001, 0b00000001,		// 4
			;	0b00000111, 0b00000100, 0b00000110, 0b00000001, 0b00000110,		// 5
			;	0b00000010, 0b00000100, 0b00000110, 0b00000101, 0b00000010,		// 6
			;	0b00000111, 0b00000001, 0b00000010, 0b00000010, 0b00000010,		// 7
			;	0b00000010, 0b00000101, 0b00000010, 0b00000101, 0b00000010,		// 8
			;	0b00000010, 0b00000101, 0b00000011, 0b00000001, 0b00000010		// 9
			;};
			;
			;void led_adj_hour( uns8 hour )
			;{
led_adj_hour
	MOVWF hour_3,0
			;	led_show_char( 'H' );
	MOVLW 72
	RCALL led_show_char
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
			;	led_show_char( 'M' );
	MOVLW 77
	RCALL led_show_char
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
			;	led_show_char( 'S' );
	MOVLW 83
	RCALL led_show_char
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
	MOVLW 29
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
			;void led_show_char( uns8 data )
			;{
led_show_char
	MOVWF data,0
			;	data -= 'A';		// offset to first character in table
	MOVLW 65
	SUBWF data,1,0
			;	data += (data<<2);	// multiply by 5 (5 bytes per character)
	MOVF  data,W,0
	MULLW 4
	MOVF  PRODL,W,0
	ADDWF data,1,0
			;	led_row[4] = led_char[data++];
	MOVLW 5
	ADDWF data,W,0
	RCALL _const1
	MOVWF led_row+4,0
	INCF  data,1,0
			;	led_row[3] = led_char[data++];
	MOVLW 5
	ADDWF data,W,0
	RCALL _const1
	MOVWF led_row+3,0
	INCF  data,1,0
			;	led_row[2] = led_char[data++];
	MOVLW 5
	ADDWF data,W,0
	RCALL _const1
	MOVWF led_row+2,0
	INCF  data,1,0
			;	led_row[1] = led_char[data++];
	MOVLW 5
	ADDWF data,W,0
	RCALL _const1
	MOVWF led_row+1,0
	INCF  data,1,0
			;	led_row[0] = led_char[data++];
	MOVLW 5
	ADDWF data,W,0
	RCALL _const1
	MOVWF led_row,0
	INCF  data,1,0
			;}	
	RETURN
			;
			;void led_show_value( uns8 data )
			;{
led_show_value
	MOVWF data_2,0
			;	data += (data<<2);	// multiply by 5 (5 bytes per character)
	MOVF  data_2,W,0
	MULLW 4
	MOVF  PRODL,W,0
	ADDWF data_2,1,0
			;	led_row[4] &= 0b11111000;
	MOVLW 248
	ANDWF led_row+4,1,0
			;	led_row[4] |= led_value[data++];
	MOVLW 135
	ADDWF data_2,W,0
	RCALL _const1
	IORWF led_row+4,1,0
	INCF  data_2,1,0
			;	led_row[3] &= 0b11111000;
	MOVLW 248
	ANDWF led_row+3,1,0
			;	led_row[3] |= led_value[data++];
	MOVLW 135
	ADDWF data_2,W,0
	RCALL _const1
	IORWF led_row+3,1,0
	INCF  data_2,1,0
			;	led_row[2] &= 0b11111000;
	MOVLW 248
	ANDWF led_row+2,1,0
			;	led_row[2] |= led_value[data++];
	MOVLW 135
	ADDWF data_2,W,0
	RCALL _const1
	IORWF led_row+2,1,0
	INCF  data_2,1,0
			;	led_row[1] &= 0b11111000;
	MOVLW 248
	ANDWF led_row+1,1,0
			;	led_row[1] |= led_value[data++];
	MOVLW 135
	ADDWF data_2,W,0
	RCALL _const1
	IORWF led_row+1,1,0
	INCF  data_2,1,0
			;	led_row[0] &= 0b11111000;
	MOVLW 248
	ANDWF led_row,1,0
			;	led_row[0] |= led_value[data++];
	MOVLW 135
	ADDWF data_2,W,0
	RCALL _const1
	IORWF led_row,1,0
	INCF  data_2,1,0
			;}	
	RETURN
			;
			;
			;void led_show_icon( uns8 icon )
			;{
led_show_icon
	MOVWF icon,0
			;#if 0
			;	switch( icon ) {
			;		case BUTTON_T:	led_row[4].3 = 1;	break; 
			;		case BUTTON_O:	led_row[4].2 = 1;	break; 
			;		case BUTTON_S:	led_row[4].1 = 1;	break; 
			;		case BUTTON_X:	led_row[4].0 = 1;	break; 
			;	}	
			;#endif
			;}
	RETURN
			;
			;void led_hide_icon( uns8 icon )
			;{
led_hide_icon
	MOVWF icon_2,0
			;#if 0
			;	switch( icon ) {
			;		case BUTTON_T:	led_row[4].3 = 0;	break; 
			;		case BUTTON_O:	led_row[4].2 = 0;	break; 
			;		case BUTTON_S:	led_row[4].1 = 0;	break; 
			;		case BUTTON_X:	led_row[4].0 = 0;	break; 
			;	}
			;#endif	
			;}		
	RETURN
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
	MOVLW 185
	ADDWF button,W,0
	RCALL _const1
	MOVWF TRISA,0
			;	ANCON0 = touch_button_adcon[ button ];
	MOVLW 189
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
	MOVLW 193
	ADDWF button,W,0
	RCALL _const1
	XORLW 0
	BTFSS 0xFD8,Zero_,0
	BSF   0xFC2,CHS0,0
	BTFSC 0xFD8,Zero_,0
	BCF   0xFC2,CHS0,0
			;	CHS1 = touch_button_chs1[ button ];
	MOVLW 197
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
m010	MOVLW 4
	CPFSLT wait,0
	BRA   m011
			;		;
	INCF  wait,1,0
	BRA   m010
			;		
			;	// stop charge, start conversion
			;	EDG1STAT = 0;
m011	BCF   0xFB2,EDG1STAT,0
			;	GO = 1;
	BSF   0xFC2,GO,0
			;	
			;	// wait until conversion is complete
			;	while( GO )
m012	BTFSC 0xFC2,GO,0
			;		;
	BRA   m012
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
	BRA   m013
			;		ADRESH = 0xff;
	SETF  ADRESH,0
			;	else
	BRA   m014
			;		ADRESH <<= 1;
m013	BCF   0xFD8,Carry,0
	RLCF  ADRESH,1,0
			;			
			;	ADRESH.0 = ADRESL.7;
m014	BTFSS ADRESL,7,0
	BCF   ADRESH,0,0
	BTFSC ADRESL,7,0
	BSF   ADRESH,0,0
			;	touch_result[button] = ADRESH;
	CLRF  FSR0+1,0
	MOVLW 46
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
	MOVLW 34
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVFF INDF0,val
			;	touch_sample( button );
	MOVF  button_2,W,0
	RCALL touch_sample
			;	smp = touch_result[ button ];
	CLRF  FSR0+1,0
	MOVLW 46
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
	BRA   m016
			;	{
			;		if( touch_count[ button ] < 4 )
	CLRF  FSR0+1,0
	MOVLW 42
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVLW 4
	CPFSLT INDF0,0
	BRA   m015
			;			touch_count[ button ]++;
	CLRF  FSR0+1,0
	MOVLW 42
	ADDWF button_2,W,0
	MOVWF FSR0,0
	INCF  INDF0,1,0
			;		else
	BRA   m018
			;			touch_state[ button ] = 1;
m015	CLRF  FSR0+1,0
	MOVLW 38
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVLW 1
	MOVWF INDF0,0
			;	}
			;	else
	BRA   m018
			;	{
			;		if( touch_count[ button ] )
m016	CLRF  FSR0+1,0
	MOVLW 42
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVF  INDF0,W,0
	BTFSC 0xFD8,Zero_,0
	BRA   m017
			;			touch_count[ button ]--;
	CLRF  FSR0+1,0
	MOVLW 42
	ADDWF button_2,W,0
	MOVWF FSR0,0
	DECF  INDF0,1,0
			;		else
	BRA   m018
			;			touch_state[ button ] = 0;
m017	CLRF  FSR0+1,0
	MOVLW 38
	ADDWF button_2,W,0
	MOVWF FSR0,0
	CLRF  INDF0,0
			;	}
			;
			;	// update average value filter every 16 samples
			;	if( ++touch_low_pass_count[ button ] >= 16 )
m018	CLRF  FSR0+1,0
	MOVLW 50
	ADDWF button_2,W,0
	MOVWF FSR0,0
	INCF  INDF0,1,0
	MOVLW 15
	CPFSGT INDF0,0
	BRA   m021
			;	{
			;		touch_low_pass_count[ button ] = 0;
	CLRF  FSR0+1,0
	MOVLW 50
	ADDWF button_2,W,0
	MOVWF FSR0,0
	CLRF  INDF0,0
			;		
			;		// if the button is not pressed, use a faster filter constant
			;		if( touch_state[ button ] == 0 )
	CLRF  FSR0+1,0
	MOVLW 38
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVF  INDF0,W,0
	BTFSS 0xFD8,Zero_,0
	BRA   m019
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
	BRA   m020
			;		{
			;			val -= ((val>>4) + Carry);
m019	SWAPF val,W,0
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
m020	CLRF  FSR0+1,0
	MOVLW 34
	ADDWF button_2,W,0
	MOVWF FSR0,0
	MOVFF val,INDF0
			;	}	
			;	
			;	return touch_state[ button ];
m021	CLRF  FSR0+1,0
	MOVLW 38
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
			;struct
			;{
			;	uns8 value;
			;	uns8 min, max;
			;} param[4];
			;
			;void op_init( void )
			;{
op_init
			;	state = ST_RUN;
	CLRF  state,0
			;	
			;	param[0].value = 5;
	MOVLW 5
	MOVWF param,0
			;	param[0].min = 1;
	MOVLW 1
	MOVWF param+1,0
			;	param[0].max = 9;
	MOVLW 9
	MOVWF param+2,0
			;	
			;	param[1].value = 10;
	MOVLW 10
	MOVWF param+3,0
			;	param[1].min = 5;
	MOVLW 5
	MOVWF param+4,0
			;	param[1].max = 20;
	MOVLW 20
	MOVWF param+5,0
			;
			;	param[0].value = 128;
	MOVLW 128
	MOVWF param,0
			;	param[0].min = 1;
	MOVLW 1
	MOVWF param+1,0
			;	param[0].max = 255;
	SETF  param+2,0
			;	
			;}
	RETURN
			;
			;void op_task( void )
			;{
op_task
			;	switch( state )	{
	MOVF  state,W,0
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
	XORLW 7
	BTFSC 0xFD8,Zero_,0
	BRA   m026
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m027
	XORLW 3
	BTFSC 0xFD8,Zero_,0
	BRA   m028
	BRA   m029
			;		case ST_RUN:
			;			led_clear();
m022	RCALL led_clear
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
	BRA   m029
			;			
			;		case ST_ADJ_HOUR:
			;			led_adj_hour( rtc_get_hour() );
m023	RCALL rtc_get_hour
	RCALL led_adj_hour
			;			break;	
	BRA   m029
			;				
			;		case ST_ADJ_MIN:
			;			led_adj_minute( rtc_get_minute() );
m024	RCALL rtc_get_minute
	RCALL led_adj_minute
			;			break;	
	BRA   m029
			;
			;		case ST_ADJ_SEC:
			;			led_adj_second( rtc_get_second() );
m025	RCALL rtc_get_second
	RCALL led_adj_second
			;			break;	
	BRA   m029
			;
			;		case ST_BRIGHT:
			;			led_show_char( 'B' );
m026	MOVLW 66
	RCALL led_show_char
			;			op_show_param( 0 );
	MOVLW 0
	RCALL op_show_param
			;			break;
	BRA   m029
			;			
			;		case ST_DELAY:
			;			led_show_char( 'D' );
m027	MOVLW 68
	RCALL led_show_char
			;			op_show_param( 1 );
	MOVLW 1
	RCALL op_show_param
			;			break;
	BRA   m029
			;
			;		case ST_CLOCK:
			;			led_show_char( 'C' );
m028	MOVLW 67
	RCALL led_show_char
			;			op_show_param( 2 );
	MOVLW 2
	RCALL op_show_param
			;			break;
			;
			;
			;	}	
			;}	
m029	RETURN
			;
			;void op_proc( uns8 key )
			;{
op_proc
	MOVWF key,0
			;	switch( state )	{
	MOVF  state,W,0
	BTFSC 0xFD8,Zero_,0
	BRA   m039
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m030
	XORLW 3
	BTFSC 0xFD8,Zero_,0
	BRA   m032
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m034
	XORLW 7
	BTFSC 0xFD8,Zero_,0
	BRA   m036
	XORLW 1
	BTFSC 0xFD8,Zero_,0
	BRA   m037
	XORLW 3
	BTFSC 0xFD8,Zero_,0
	BRA   m038
	BRA   m039
			;		case ST_RUN:
			;			break;	
			;				
			;		case ST_ADJ_HOUR:
			;			if( key == BUTTON_S )
m030	MOVLW 3
	CPFSEQ key,0
	BRA   m031
			;				rtc_inc_hour();
	RCALL rtc_inc_hour
			;			if( key == BUTTON_X )
m031	MOVLW 2
	CPFSEQ key,0
	BRA   m039
			;				rtc_dec_hour();
	RCALL rtc_dec_hour
			;			break;			
	BRA   m039
			;	
			;		case ST_ADJ_MIN:
			;			if( key == BUTTON_S )
m032	MOVLW 3
	CPFSEQ key,0
	BRA   m033
			;				rtc_inc_minute();
	RCALL rtc_inc_minute
			;			if( key == BUTTON_X )
m033	MOVLW 2
	CPFSEQ key,0
	BRA   m039
			;				rtc_dec_minute();
	RCALL rtc_dec_minute
			;			break;			
	BRA   m039
			;
			;		case ST_ADJ_SEC:
			;			if( key == BUTTON_S )
m034	MOVLW 3
	CPFSEQ key,0
	BRA   m035
			;				rtc_inc_second();
	RCALL rtc_inc_second
			;			if( key == BUTTON_X )
m035	MOVLW 2
	CPFSEQ key,0
	BRA   m039
			;				rtc_dec_second();
	RCALL rtc_dec_second
			;			break;			
	BRA   m039
			;
			;		case ST_BRIGHT:
			;			op_adj_param( 0, key );
m036	CLRF  data_4,0
	MOVF  key,W,0
	RCALL op_adj_param
			;			break;
	BRA   m039
			;			
			;		case ST_DELAY:
			;			op_adj_param( 1, key );
m037	MOVLW 1
	MOVWF data_4,0
	MOVF  key,W,0
	RCALL op_adj_param
			;			break;
	BRA   m039
			;			
			;		case ST_CLOCK:
			;			op_adj_param( 2, key );
m038	MOVLW 2
	MOVWF data_4,0
	MOVF  key,W,0
	RCALL op_adj_param
			;			break;
			;	}	
			;
			;	if( key == BUTTON_T )
m039	DECFSZ key,W,0
	BRA   m040
			;	{
			;		if( ++state >= ST_END )
	INCF  state,1,0
	MOVLW 7
	CPFSLT state,0
			;			state = ST_RUN;
	CLRF  state,0
			;	}		
			;		
			;
			;}		
m040	RETURN
			;	
			;	
			;void op_show_param( uns8 data )
			;{
op_show_param
	MOVWF data_3,0
			;	led_show_value( param[data].value );
	CLRF  FSR0+1,0
	MOVLW 3
	MULWF data_3,0
	MOVF  PRODL,W,0
	ADDLW 55
	MOVWF FSR0,0
	MOVF  INDF0,W,0
	BRA   led_show_value
			;}	
			;
			;void op_adj_param( uns8 data, uns8 key )
			;{
op_adj_param
	MOVWF key_2,0
			;	uns8 value = param[data].value;
	CLRF  FSR0+1,0
	MOVLW 3
	MULWF data_4,0
	MOVF  PRODL,W,0
	ADDLW 55
	MOVWF FSR0,0
	MOVFF INDF0,value
			;	
			;	// increment parameter
			;	if( key == BUTTON_S )
	MOVLW 3
	CPFSEQ key_2,0
	BRA   m041
			;	{
			;		if( value < param[data].max )
	CLRF  FSR0+1,0
	MOVLW 3
	MULWF data_4,0
	MOVF  PRODL,W,0
	ADDLW 57
	MOVWF FSR0,0
	MOVF  INDF0,W,0
	CPFSLT value,0
	BRA   m041
			;			param[data].value++;
	CLRF  FSR0+1,0
	MOVLW 3
	MULWF data_4,0
	MOVF  PRODL,W,0
	ADDLW 55
	MOVWF FSR0,0
	INCF  INDF0,1,0
			;	}
			;	
			;	// decrement parameter
			;	if( key == BUTTON_X )
m041	MOVLW 2
	CPFSEQ key_2,0
	BRA   m042
			;	{
			;		if( value > param[data].min )
	CLRF  FSR0+1,0
	MOVLW 3
	MULWF data_4,0
	MOVF  PRODL,W,0
	ADDLW 56
	MOVWF FSR0,0
	MOVF  value,W,0
	CPFSLT INDF0,0
	BRA   m042
			;			param[data].value--;
	CLRF  FSR0+1,0
	MOVLW 3
	MULWF data_4,0
	MOVF  PRODL,W,0
	ADDLW 55
	MOVWF FSR0,0
	DECF  INDF0,1,0
			;	}	
			;	op_show_param( data );
m042	MOVF  data_4,W,0
	BRA   op_show_param
			;}		

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
m043	CLRF  POSTDEC0,0
	MOVF  FSR0H,W,0
	BNZ   m043
	MOVF  FSR0,W,0
	BNZ   m043
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
m044	MOVLW 250
	CPFSLT delay,0
	BRA   m048
			;	{
			;		for( row=0; row <=4; row++ )
	CLRF  row_2,0
m045	MOVLW 5
	CPFSLT row_2,0
	BRA   m047
			;		{
			;			led_show_row( row );
	MOVF  row_2,W,0
	RCALL led_show_row
			;
			;			while( !TMR0IF )
m046	BTFSS 0xFF2,TMR0IF,0
			;				;
	BRA   m046
			;				
			;			TMR0IF = 0;
	BCF   0xFF2,TMR0IF,0
			;		}	
	INCF  row_2,1,0
	BRA   m045
			;	}		
m047	INCF  delay,1,0
	BRA   m044
			;	
			;	led_clear();
m048	RCALL led_clear
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
m049	BCF   0xF9D,TMR2IE,0
			;		if( rtc_tick >= 25 )
	MOVLW 24
	CPFSGT rtc_tick,0
	BRA   m050
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
m050	BSF   0xF9D,TMR2IE,0
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
m051	MOVLW 5
	CPFSLT row_2,0
	BRA   m049
			;		{
			;			led_show_row( row );
	MOVF  row_2,W,0
	RCALL led_show_row
			;
			;			while( !TMR0IF )
m052	BTFSS 0xFF2,TMR0IF,0
			;				;
	BRA   m052
			;				
			;			TMR0IF = 0;
	BCF   0xFF2,TMR0IF,0
			;			
			;			if( row < 4 )
	MOVLW 4
	CPFSLT row_2,0
	BRA   m054
			;			{
			;				if( touch_filter( row ) )
	MOVF  row_2,W,0
	RCALL touch_filter
	XORLW 0
	BTFSC 0xFD8,Zero_,0
	BRA   m053
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
	BRA   m054
			;				{
			;					led_hide_icon( row );
m053	MOVF  row_2,W,0
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
m054	CLRF  FSR0+1,0
	MOVF  row_2,W,0
	MOVWF FSR0,0
	MOVF  INDF0,W,0
	BTFSC 0xFD8,Zero_,0
	BRA   m055
	CLRF  FSR0+1,0
	MOVLW 5
	ADDWF row_2,W,0
	MOVWF FSR0,0
	MOVF  INDF0,W,0
	BTFSS 0xFD8,Zero_,0
	BRA   m055
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
m055	INCF  row_2,1,0
	BRA   m051
			;	}		
_const1
	MOVWF ci,0
	MOVF  ci,W,0
	ADDLW 144
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
	DW    0x407F
	DW    0xE0A0
	DW    0xA0A0
	DW    0xA0C0
	DW    0xA0C0
	DW    0x40C0
	DW    0x80A0
	DW    0x40A0
	DW    0xA0C0
	DW    0xA0A0
	DW    0xE0C0
	DW    0xE080
	DW    0xE080
	DW    0x80E0
	DW    0x80E0
	DW    0x4080
	DW    0x80A0
	DW    0x40E0
	DW    0xA0A0
	DW    0xA0E0
	DW    0x40A0
	DW    0x4040
	DW    0xE040
	DW    0x2020
	DW    0xA020
	DW    0xA040
	DW    0x80C0
	DW    0xA0C0
	DW    0x8080
	DW    0x8080
	DW    0xA0E0
	DW    0xA0E0
	DW    0xA0A0
	DW    0xE0A0
	DW    0xA0E0
	DW    0x40A0
	DW    0xA0A0
	DW    0x40A0
	DW    0xA0C0
	DW    0x80C0
	DW    0x4080
	DW    0xA0A0
	DW    0x60A0
	DW    0xA0C0
	DW    0xC0C0
	DW    0xE0A0
	DW    0x4080
	DW    0xE020
	DW    0x40E0
	DW    0x4040
	DW    0xA0E0
	DW    0xA0A0
	DW    0xE0A0
	DW    0xA0A0
	DW    0xA0A0
	DW    0xA040
	DW    0xA0A0
	DW    0xA0E0
	DW    0xA0A0
	DW    0xA040
	DW    0xA0A0
	DW    0x40A0
	DW    0x4040
	DW    0x20E0
	DW    0x8040
	DW    0x2E0
	DW    0x505
	DW    0x205
	DW    0x202
	DW    0x202
	DW    0x602
	DW    0x201
	DW    0x704
	DW    0x106
	DW    0x102
	DW    0x506
	DW    0x705
	DW    0x101
	DW    0x407
	DW    0x106
	DW    0x206
	DW    0x604
	DW    0x205
	DW    0x107
	DW    0x202
	DW    0x202
	DW    0x205
	DW    0x205
	DW    0x502
	DW    0x103
	DW    0x102
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
; 0x0000AA   16 word(s)  0 % : rtc_increment
; 0x0000CA    4 word(s)  0 % : rtc_daw_hour
; 0x0000D2    4 word(s)  0 % : rtc_daw_minute
; 0x0000DA    4 word(s)  0 % : rtc_daw_second
; 0x0000E2   26 word(s)  0 % : led_load_second
; 0x000116   26 word(s)  0 % : led_load_minute
; 0x00014A   26 word(s)  0 % : led_load_hour
; 0x000226   11 word(s)  0 % : led_load_logo
; 0x00023C    6 word(s)  0 % : led_clear
; 0x000248   12 word(s)  0 % : led_show_row
; 0x000260   33 word(s)  0 % : led_show_char
; 0x0002A2   41 word(s)  0 % : led_show_value
; 0x0002FC    2 word(s)  0 % : led_init
; 0x0002F4    2 word(s)  0 % : led_show_icon
; 0x0002F8    2 word(s)  0 % : led_hide_icon
; 0x000300   43 word(s)  0 % : touch_init
; 0x000356   89 word(s)  0 % : touch_sample
; 0x0004F2   19 word(s)  0 % : op_init
; 0x000518   54 word(s)  0 % : op_task
; 0x000584   70 word(s)  0 % : op_proc
; 0x000610    9 word(s)  0 % : op_show_param
; 0x000622   49 word(s)  0 % : op_adj_param
; 0x00000C    3 word(s)  0 % : _highPriorityInt
; 0x000008    2 word(s)  0 % : highPriorityIntServer
; 0x00017E   28 word(s)  0 % : led_adj_hour
; 0x0001B6   28 word(s)  0 % : led_adj_minute
; 0x0001EE   28 word(s)  0 % : led_adj_second
; 0x00077A  112 word(s)  0 % : _const1
; 0x000408  116 word(s)  0 % : touch_filter
; 0x0004F0    1 word(s)  0 % : touch_task
; 0x000684  123 word(s)  0 % : main

; RAM usage: 73 bytes (24 local), 3703 bytes free
; Maximum call level: 4 (+2 for interrupt)
; Total of 1075 code words (3 %)
