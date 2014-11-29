#ifndef _TOUCH_C
#define _TOUCH_C

#include "touch.h"

#define TOUCH_THRESHOLD 20

uns8 touch_value[4];
uns8 touch_state[4];
uns8 touch_count[4];
uns8 touch_result[4];
uns8 touch_low_pass_count[4];

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
	ADCON1 = 0b00001010;
	
	ADON = 1; //Turn On A/D
	CTMUEN = 1; //Enable CTMU
	
// Set inputs to 0 to drain charge
	TRISA = 0;
	LATA = 0;
	
	touch_count[0] = 0;
	touch_count[1] = 0;
	touch_count[2] = 0;
	touch_count[3] = 0;
	touch_state[0] = 0;
	touch_state[1] = 0;
	touch_state[2] = 0;
	touch_state[3] = 0;
	touch_value[0] = 0;
	touch_value[1] = 0;
	touch_value[2] = 0;
	touch_value[3] = 0;
	touch_low_pass_count[0] = 0;
	touch_low_pass_count[1] = 0;
	touch_low_pass_count[2] = 0;
	touch_low_pass_count[3] = 0;
}

#define WAIT_COUNT 4

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

	// cap sense values are never higher that 0x7f, so shift up
	// one bit to gain some precision
	if( ADRESH >= 0x80 )
		ADRESH = 0xff;
	else
		ADRESH <<= 1;
			
	ADRESH.0 = ADRESL.7;
	touch_result[button] = ADRESH;
	
	// return the (left justified) result
	return( ADRESH );
}	


// Use for debugging of cap sense to store latest sensed values
//uns8 t_s[4];

uns8 touch_filter( uns8 button )
{
	uns8 smp, val;
	val = touch_value[ button ];
	touch_sample( button );
	smp = touch_result[ button ];
	
	// Use for debugging of cap sense to store latest sensed values
	//t_s[button] = smp;
	
	// if this is the first time through, take sample value as 
	// average value
	if( val == 0 )
		val = smp;
	
	if( smp < (val-TOUCH_THRESHOLD) )
	{
		if( touch_count[ button ] < 4 )
			touch_count[ button ]++;
		else
			touch_state[ button ] = 1;
	}
	else
	{
		if( touch_count[ button ] )
			touch_count[ button ]--;
		else
			touch_state[ button ] = 0;
	}

	// update average value filter every 16 samples
	if( ++touch_low_pass_count[ button ] >= 16 )
	{
		touch_low_pass_count[ button ] = 0;
		
		// if the button is not pressed, use a faster filter constant
		if( touch_state[ button ] == 0 )
		{
			val -= ((val>>2) + Carry);
			val += (smp>>2) + Carry;
		}
		else
		{
			val -= ((val>>4) + Carry);
			val += (smp>>4) + Carry;
		}
		
		// store the new filtered average value
		touch_value[ button ] = val;
	}	
	
	return touch_state[ button ];
}	
	

uns8 touch_task( void )
{
	return 0;
}	

#endif // _TOUCH_C