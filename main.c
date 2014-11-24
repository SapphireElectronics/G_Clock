#pragma chip PIC18F26J53

#pragma cdata[0x7ffc]
#pragma cdata[] = 0xFE, 0xF7, 0xD8, 0xFF
#pragma cdata[] = 0xFD, 0xFB, 0xBF, 0xFB 

/* Pin mappings
	Pn	Port	Type	Name	Chan	Details
   	01	MCLR	Pwr		MCLR			ICSP MLR/VPP
	02	RA0		CapSen	BT1		AN0		Cap Sense Input 1
   	03	RA1		CapSen	BT2		AN1		Cap Sense Input 2
   	04	RA2		CapSen	BT3		AN2		Cap Sense Input 3
   	05	RA3		CapSen	BT4		AN3		Cap Sense Input 4
   	06	Vcore	Pwr		Vcore			Vcore output (filter cap)
   	07	RA5		Unused
   	08	Vss1	Pwr		GND				Ground
   	09	RA7		Unused
   	10	RA6		Unused
   	11	RC0		Dout	Col1	RC0		LED Column 1 - Active Low
   	12	RC1		Dout	Col2	RC1		LED Column 2 - Active Low
   	13	RC2		Dout	Col3	RC2		LED Column 3 - Active Low
   	14	Vusb	Pwr		Vdd
   	15	RC4		Comm	D-
   	16	RC5		Comm	D+
   	17	RC6		Dout	Col4	RC6		LED Column 4 - Active Low
   	18	RC7		Dout	Col5	RC7		LED Column 5 - Active Low
   	19	Vss2	Pwr		GND				Ground
   	20	Vdd		Pwr		Vdd				Power
   	21	RB0		Dout	Row1	RB0		LED Row 1 - Active Hi
   	22	RB1		Dout	Row2	RB1		LED Row 2 - Active Hi
   	23	RB2		Dout	Row3	RB2		LED Row 3 - Active Hi
   	24	RB3		Dout	Row4	RB3		LED Row 4 - Active Hi
   	25	RB4		Dout	Row5	RB4		LED Row 5 - Active Hi
   	26	RB5		Dout	Row6	RB5		LED Row 6 - Active Hi
   	27	RB6		Dout	Row7	RB6		LED Row 7 / ICSP Clock
   	28	RB7		Dout	Row8	RB7		LED Row 8 / ICSP Data
*/

#include "rtc.h"
#include "led.h"

#include "rtc.c"
#include "led.c"

	

void main(void)
{
	led_show_second( 5 );
	led_show_minute( 5 );
	led_show_hour( 5 );
	
}