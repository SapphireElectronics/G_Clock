#ifndef _RTC_C
#define _RTC_C

#include "rtc.h"

uns8 rtc_second;
uns8 rtc_minute;
uns8 rtc_hour;
uns8 rtc_tick;

void rtc_init( void )
{
	T2CON = 0b01001110;		// Timer 2 on, divide by 16 * 10 = 160
	PR2 = 250;				// Match at 125
							// 250 x 160 = 40000
							// count 25 times to divide 1MHz clock 
							// into 1 second intervals

	TMR2IF = 0;				// clear interrupt flag
	TMR2IE = 1;				// enable TMR2 interrupt
}	

void rtc_int( void )
{
	TMR2IF = 0;
	++rtc_tick;
}	

void rtc_set_hour( uns8 hour )
{
	rtc_hour = hour;
}	

void rtc_set_minute( uns8 minute )
{
	rtc_minute = minute;
}	

void rtc_set_second( uns8 second )
{
	rtc_second = second;
}	

void rtc_inc_hour( void )
{
	if( ++rtc_hour > 0x23 )
		rtc_hour = 0;
	else
		rtc_daw_hour();
}	

void rtc_dec_hour( void )
{
	if( rtc_hour == 0 )
		rtc_hour = 0x23;
	else
	{
		rtc_hour += 0x99;	// this is the same as subtracting 1 in 
							// BCD format. Tricky!
		rtc_daw_hour();
	}	
}

void rtc_inc_minute( void )
{
	if( ++rtc_minute > 0x59 )
		rtc_minute = 0;
	else
		rtc_daw_minute();
}	

void rtc_dec_minute( void )
{
	if( rtc_minute == 0 )
		rtc_minute = 0x59;
	else
	{
		rtc_minute += 0x99;	// this is the same as subtracting 1 in 
							// BCD format. Tricky!
		rtc_daw_minute();
	}	
}	

void rtc_inc_second( void )
{
	if( ++rtc_second > 0x59 )
		rtc_second = 0;
	else
		rtc_daw_second();
}	

void rtc_dec_second( void )
{
	if( rtc_second == 0 )
		rtc_second = 0x59;
	else
	{
		rtc_second += 0x99;	// this is the same as subtracting 1 in 
							// BCD format. Tricky!
		rtc_daw_second();
	}	
}	

uns8 rtc_get_hour( void )
{
	return( rtc_hour );
}	

uns8 rtc_get_minute( void )
{
	return( rtc_minute );
}	

uns8 rtc_get_second( void )
{
	return( rtc_second );
}	

void rtc_increment( void )
{
	if( ++rtc_second <= 0x59 )
	{
		rtc_daw_second();
		return;
	}

	rtc_second = 0;	
	if( ++rtc_minute <= 0x59 )
	{
		rtc_daw_minute();
		return;
	}	

	rtc_minute = 0;
	if( ++rtc_hour <= 0x23 )
	{
		rtc_daw_hour();
		return;
	}
}	

void rtc_daw_hour( void )
{
	W = rtc_hour;	
	W = decadj( W );
	rtc_hour = W;
}	

void rtc_daw_minute( void )
{
	W = rtc_minute;
	W = decadj( W );
	rtc_minute = W;
}

void rtc_daw_second( void )
{
	W = rtc_second;
	W = decadj( W );
	rtc_second = W;			
}	

#endif // _RTC_C