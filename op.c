#ifndef _OP_C
#define _OP_C

#include "rtc.h"

uns8 state;

void op_init( void )
{
	state = ST_RUN;
}

void op_task( void )
{
	switch( state )	{
		case ST_RUN:
			led_clear();
			led_load_second( rtc_get_second() );
			led_load_minute( rtc_get_minute() );
			led_load_hour( rtc_get_hour() );
			break;
			
		case ST_ADJ_HOUR:
			led_adj_hour( rtc_get_hour() );
			break;	
				
		case ST_ADJ_MIN:
			led_adj_minute( rtc_get_minute() );
			break;	

		case ST_ADJ_SEC:
			led_adj_second( rtc_get_second() );
			break;	

		case ST_ADJ_BRIGHT:
	}	
}	

void op_proc( uns8 key )
{
	switch( state )	{
		case ST_RUN:
			if( key == BUTTON_T )
				state = ST_ADJ_HOUR;
			break;	
				
		case ST_ADJ_HOUR:
			if( key == BUTTON_S )
				rtc_inc_hour();
			if( key == BUTTON_X )
				rtc_dec_hour();
			if( key == BUTTON_T )
				state = ST_ADJ_MIN;
			break;			
	
		case ST_ADJ_MIN:
			if( key == BUTTON_S )
				rtc_inc_minute();
			if( key == BUTTON_X )
				rtc_dec_minute();
			if( key == BUTTON_T )
				state = ST_ADJ_SEC;
			break;			

		case ST_ADJ_SEC:
			if( key == BUTTON_S )
				rtc_inc_second();
			if( key == BUTTON_X )
				rtc_dec_second();
			if( key == BUTTON_T )
				state = ST_RUN;
			break;			

		case ST_ADJ_BRIGHT:
	}	
}		
	
#endif // _OP_C