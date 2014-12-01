#ifndef _RTCC_C
#define _RTCC_C

#include "rtcc.h"

void rtc_init( void )
{
	rtc_wr_enable();	// enable rtc writes
	RTCEN = 1;			// enable RTC
	rtc_wr_disable();	// disable rtc writes

	RTCPTR0 = 0;		// select second/minutes register pair
	RTCPTR1 = 0;
	
}	

void rtc_wr_enable( void )
{
	GIE = 0;		// disable all interrupts
	EECON2 = 0x55;	// write unlock sequence
	EECON2 = 0xaa;
	RTCWREN = 1;	// set the write enable bit
	GIE = 1;		// enable interrupts
}	

void rtc_wr_disable( void )
{
	RTCWREN = 0;	// clear the write enable bit
}	

void rtc_set_hour( uns8 hour )
{
	while( RTCSYNC );	// wait until safe to write
	RTCPTR0 = 1;		// select hours in register pointer
	rtc_wr_enable();	// enable rtc writes
	RTCVALL = hour;		// load hours
	rtc_wr_disable();	// disable rtc writes
}	

void rtc_set_minute( uns8 minute )
{
	while( RTCSYNC );	// wait until safe to write
	RTCPTR0 = 0;		// select minutes in register pointer
	rtc_wr_enable();	// enable rtc writes
	RTCVALH = minute;	// load hours
	rtc_wr_disable();	// disable rtc writes
}	

void rtc_set_second( uns8 second )
{
	while( RTCSYNC );	// wait until safe to write
	RTCPTR0 = 0;		// select seconds in register pointer
	rtc_wr_enable();	// enable rtc writes
	RTCVALL = second;	// load hours
	rtc_wr_disable();	// disable rtc writes
}	

void rtc_inc_hour( void )
{
	uns8 hour;

	while( RTCSYNC );	// wait until safe to write
	RTCPTR0 = 1;		// select hours in register pointer
	rtc_wr_enable();	// enable rtc writes
	
	hour = RTCVALL;
	if( hour == 0x23 )
		hour = 0;
	else
		++hour;

	W = hour;
	W = decadj( W );
	RTCVALL = W;

	rtc_wr_disable();	// disable rtc writes
}	

void rtc_dec_hour( void )
{
	uns8 hour;

	while( RTCSYNC );	// wait until safe to write
	RTCPTR0 = 1;		// select hours in register pointer
	rtc_wr_enable();	// enable rtc writes
	
	hour = RTCVALL;
	if( hour == 0 )
		hour = 0x23;
	else
		hour += 0x99;	// this is the same as subtracting 1 in 
						// BCD format. Tricky!
	
	W = hour;	
	W = decadj( W );
	RTCVALL = W;

	rtc_wr_disable();	// disable rtc writes
}

void rtc_inc_minute( void )
{
	uns8 minute;
	
	while( RTCSYNC );	// wait until safe to write
	RTCPTR0 = 0;		// select minutes in register pointer
	rtc_wr_enable();	// enable rtc writes

	minute = RTCVALH;
	if( minute == 0x59 )
		minute = 0;
	else
		++minute;

	W = minute;
	W = decadj( W );
	RTCVALH = W;

	rtc_wr_disable();	// disable rtc writes
}	

void rtc_dec_minute( void )
{
	uns8 minute;
	
	while( RTCSYNC );	// wait until safe to write
	RTCPTR0 = 0;		// select minutes in register pointer
	rtc_wr_enable();	// enable rtc writes

	minute = RTCVALH;
	if( minute == 0 )
		minute = 0x59;
	else
		minute += 0x99;	// this is the same as subtracting 1 in 
						// BCD format. Tricky!
	
	W = minute;
	W = decadj( W );
	RTCVALH = W;

	rtc_wr_disable();	// disable rtc writes
}	

void rtc_inc_second( void )
{
	uns8 second;
	
	while( RTCSYNC );	// wait until safe to write
	RTCPTR0 = 0;		// select seconds in register pointer
	rtc_wr_enable();	// enable rtc writes

	second = RTCVALL;
	if( second == 0x59 )
		second = 0;
	else
		second++;

	W = second;
	W = decadj( W );
	RTCVALL = W;

	rtc_wr_disable();	// disable rtc writes
}	

void rtc_dec_second( void )
{
	uns8 second;
	
	while( RTCSYNC );	// wait until safe to write
	RTCPTR0 = 0;		// select seconds in register pointer
	rtc_wr_enable();	// enable rtc writes

	second = RTCVALL;
	if( second == 0 )
		second = 0x59;
	else
		second += 0x99;	// this is the same as subtracting 1 in 
						// BCD format. Tricky!

	W = second;
	W = decadj( W );
	RTCVALL = W;

	rtc_wr_disable();	// disable rtc writes
}	

uns8 rtc_get_hour( void )
{
	RTCPTR0 = 1;		// select hours in register pointer
	return( RTCVALL );
}	

uns8 rtc_get_minute( void )
{
	RTCPTR0 = 0;		// select minutes in register pointer
	return( RTCVALH );
}	

uns8 rtc_get_second( void )
{
	RTCPTR0 = 0;		// select seconds in register pointer
	return( RTCVALL );
}	

#endif // _RTCC_C