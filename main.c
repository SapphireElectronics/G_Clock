#pragma chip PIC18F26J53

#pragma config[0] = 0xbe
#pragma config[1] = 0xf7
#pragma config[2] = 0xd8
#pragma config[3] = 0xff
#pragma config[4] = 0xfd
#pragma config[5] = 0xff
#pragma config[6] = 0xbf
#pragma config[7] = 0xff

#include "int18XXX.h"

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

// button identifiers
enum { BUTTON_O, BUTTON_T, BUTTON_X, BUTTON_S };

#include "rtc.h"
#include "led.h"
#include "touch.h"
#include "op.h"
#include "eedata.h"


// Parameters
// - brightness
// - clock correction
// - display timeout


void _highPriorityInt(void);


struct
{
	uns8 value;
	uns8 min, max;
} param[4];


#pragma cdata[0x6000]		// parameter block
#pragma cdata[] = 0x0501
#pragma cdata[] = 0x0904
#pragma cdata[] = 0x0109
#pragma cdata[] = 0x5500
#pragma cdata[] = 0x9900


#pragma origin 0x8
interrupt highPriorityIntServer(void)
{
// W, STATUS and BSR are saved to shadow registers
// handle the interrupt
// 8 code words available including call and RETFIE
	_highPriorityInt();
// restore W, STATUS and BSR from shadow registers
#pragma fastMode
}

void _highPriorityInt( void )
{
	if( TMR2IF )
		rtc_int();
}	


#include "rtc.c"
#include "led.c"
#include "touch.c"
#include "op.c"
#include "eedata.c"

void main(void)
{
	OSCTUNE = 0b10001000;	// 31.25 clock from HSINTOSC, increased by about 5% to tune RTCC
	
	uns8 pressed[4];
	uns8 key;
	uns8 handled[4];
	uns8 sec;
	uns8 tmp[4];
	uns8 t;
	clearRAM();

	ADCON1 = 0x1f;
	
	TRISB = 0x00;
	TRISC = 0x00;
	
	led_load_second( 5 );
	led_load_minute( 5 );
	led_load_hour( 5 );
	
	uns8 row;
	uns8 delay;

	T0CON = 0b11000001;		// set TMR0 to overflow on 1024 instructions cycles.  1ms @ 4MHz
//	T0CON = 0b11000111;		// set TMR0 to overflow on 64k instructions cycles.  65ms
	TMR0IF = 0;

	IPEN = 0;
	PEIE = 1;
	GIE = 1;
	
	rtc_init();
	
	
	rtc_set_hour( 0x11 );
	rtc_set_minute( 0x35 );
	
	led_init();
	led_load_logo();

	copyToRam( 0x60, &param[0], sizeof( param ) );

	for( delay = 0; delay < 250; delay++ )	// 250 x 5 x 1ms = 1.25 seconds
	{
		for( row=0; row <=4; row++ )
		{
			led_show_row( row );

			while( !TMR0IF )
				;
				
			TMR0IF = 0;
		}	
	}		
	
	led_clear();
	
	sec = 0;
	
	touch_init();
	op_init();



	while( 1 )
	{
		TMR2IE = 0;
		if( rtc_tick >= 25 )
		{
			rtc_tick -= 25;
			TMR2IE = 1;
			rtc_increment();
		}	
		TMR2IE = 1;
			
//		led_load_second( rtc_get_second() );
//		led_load_minute( rtc_get_minute() );
//		led_load_hour( rtc_get_hour() );
		op_task();
		

		for( row=0; row <=4; row++ )
		{
			led_show_row( row );

			while( !TMR0IF )
				;
				
			TMR0IF = 0;
			
			if( row < 4 )
			{
				if( touch_filter( row ) )
				{
					led_show_icon( row );
					pressed[ row ] = 1;
				}	
				else
				{
					led_hide_icon( row );
					pressed[ row ] = 0;
					handled[ row ] = 0;
				}	

			}
			
			if( pressed[ row ] && !handled[ row ] )
			{
				op_proc( row );
				handled[ row ] = 1;
			}	
		}	
	}		
}