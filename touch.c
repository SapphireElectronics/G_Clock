#ifndef _TOUCH_C
#define _TOUCH_C

#include "touch.h"

uns8 touch_count;

void touch_init( void )
{
//setup CTMU
//CTMUCON
	CTMUEN = 0; //make sure CTMU is disabled
	CTMUSIDL = 0; //CTMU continues to run in idle mode
	TGEN = 0; //disable edge delay generation mode of the CTMU
	EDGEN = 0; //edges are blocked
	EDGSEQEN = 0; //edge sequence not needed
	IDISSEN = 0; //Do not ground the current source
	CTTRIG = 0; //Trigger Output is disabled
	EDG2POL = 0;

	EDG2SEL0 = 1; //Edge2 Src = OC1 (don't care)
	EDG2SEL1 = 1; //Edge2 Src = OC1 (don't care)
	EDG1POL = 1;

	EDG1SEL0 = 1; //Edge1 Src = Timer1 (don't care)
	EDG1SEL1 = 1; //Edge1 Src = Timer1 (don't care)

//CTMUICON
	CTMUICON = 0x03; //55uA

//setup A/D converter
//	Setup analog input pins
	ANCON0 = 0b11111111;
	ANCON1 = 0b00011111;
	
//	Configure AtoD, left justify
	ADCON0 = 0b00000000;
	ADCON1 = 0b00000000;
	
	ADON = 1; //Turn On A/D
	CTMUEN = 1; //Enable CTMU
	
// Set inputs to 0 to drain charge
	TRISA = 0;
	LATA = 0;
	
	touch_count = 0;
}

#define WAIT_COUNT 100

const uns8 touch_button_tris[4] = { 0x01, 0x02, 0x04, 0x08 };
const uns8 touch_button_adcon[4] = 
	{ 0b11111110, 0b11111101, 0b11111011, 0b11110111 };
const uns8 touch_button_chs0[4] = { 0, 1, 0, 1 };
const uns8 touch_button_chs1[4] = { 0, 0, 1, 1 };

uns8 touch_sample( uns8 button )
{
	uns8 wait;
	
	// drive PORTA outputs low and wait for charge to drain
	LATA = 0;
	nop(); nop(); nop(); nop(); nop(); nop(); nop(); nop();
	
	// select ANx as analog input and wait
	TRISA = touch_button_tris[ button ];
	ANCON0 = touch_button_adcon[ button ];
	nop(); nop(); nop(); nop(); nop(); nop(); nop(); nop();
	
	// select input ANx, drain charge on input channel
	CHS0 = touch_button_chs0[ button ];
	CHS1 = touch_button_chs1[ button ];
	IDISSEN = 1;
	nop(); nop(); nop(); nop(); nop();

	// stop charge drain
	IDISSEN = 0;
	nop(); nop();
	
	// edge2 = 0, edge1 = start charge
	EDG2STAT = 0;
	EDG1STAT = 1;

	for( wait = 0; wait < WAIT_COUNT; wait++ )
		;
		
	// stop charge, start conversion
	EDG1STAT = 0;
	GO = 1;
	
	// wait until conversion is complete
	while( GO )
		;
	
	TRISA = 0b00000000;
	LATA = 0;
	ANCON0 = 0b11111111;
	ANCON1 = 0b00011111;

	
	// return the (left justified) result
	return( ADRESH );
}	


uns8 touch_task( void )
{
	return 0;
}	

#endif // _TOUCH_C