#ifndef _OP_C
#define _OP_C

#include "rtc.h"

uns8 state;
bit dirty;

void op_init( void )
{
	state = ST_RUN;
}

void op_task( void )
{
	switch( state )	{
		case ST_RUN:
			dirty = 0;
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

		case ST_BRIGHT:
			led_show_char( 'B' );
			op_show_param( 0 );
			break;
			
		case ST_DELAY:
			led_show_char( 'D' );
			op_show_param( 1 );
			break;

		case ST_CLOCK:
			led_show_char( 'C' );
			op_show_param( 2 );
			break;


	}	
}	

void op_proc( uns8 key )
{
	switch( state )	{
		case ST_RUN:
			break;	
				
		case ST_ADJ_HOUR:
			if( key == BUTTON_S )
				rtc_inc_hour();
			if( key == BUTTON_X )
				rtc_dec_hour();
			break;			
	
		case ST_ADJ_MIN:
			if( key == BUTTON_S )
				rtc_inc_minute();
			if( key == BUTTON_X )
				rtc_dec_minute();
			break;			

		case ST_ADJ_SEC:
			if( key == BUTTON_S )
				rtc_inc_second();
			if( key == BUTTON_X )
				rtc_dec_second();
			break;			

		case ST_BRIGHT:
			op_adj_param( 0, key );
			break;
			
		case ST_DELAY:
			op_adj_param( 1, key );
			break;
			
		case ST_CLOCK:
			op_adj_param( 2, key );
			break;
	}	

	if( key == BUTTON_T )
	{
		if( ++state >= ST_END )
		{
			// check is EE data needs to be updated
			if( dirty )
			{
				copyToEE( &param[0], 0x60, sizeof( param ) );
				dirty = 0;
			}	
			state = ST_RUN;
		}	
	}
}		
	
	
void op_show_param( uns8 data )
{
	led_show_value( param[data].value );
}	

void op_adj_param( uns8 data, uns8 key )
{
	uns8 value = param[data].value;
	
	// increment parameter
	if( key == BUTTON_S )
	{
		if( value < param[data].max )
		{
			value = daw( ++value );
			param[data].value = value;
			dirty = 1;
		}	
	}
	
	// decrement parameter
	if( key == BUTTON_X )
	{
		if( value > param[data].min )
		{
			value = daw( --value );
			param[data].value = value;
			dirty = 1;
		}	
	}	
	op_show_param( data );
}		

uns8 daw( uns8 data )
{
	W = data;
	W = decadj( W );
	data = W;
	return data;
}	
	
#endif // _OP_C