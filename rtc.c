#ifndef _RTC_C
#define _RTC_C

#include "rtc.h"

void rtc_init( void )
{
	RTCEN = 1;		// enable RTC
	RTCPTR0 = 0;	// select second/minutes register pair
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
	while( RTCSYNC );	// wait until safe to write
	RTCPTR0 = 1;		// select hours in register pointer
	rtc_wr_enable();	// enable rtc writes
	
	W = RTCVALL;
	W = decadj( ++W );
	RTCVALL = W;

	rtc_wr_disable();	// disable rtc writes
}	

void rtc_dec_hour( void )
{
	while( RTCSYNC );	// wait until safe to write
	RTCPTR0 = 1;		// select hours in register pointer
	rtc_wr_enable();	// enable rtc writes
	
	W = RTCVALL;
	W = decadj( --W );
	RTCVALL = W;

	rtc_wr_disable();	// disable rtc writes
}

void rtc_inc_minute( void )
{
	while( RTCSYNC );	// wait until safe to write
	RTCPTR0 = 0;		// select minutes in register pointer
	rtc_wr_enable();	// enable rtc writes

	W = RTCVALH;
	W = decadj( ++W );
	RTCVALH = W;

	rtc_wr_disable();	// disable rtc writes
}	

void rtc_dec_minute( void )
{
	while( RTCSYNC );	// wait until safe to write
	RTCPTR0 = 0;		// select minutes in register pointer
	rtc_wr_enable();	// enable rtc writes

	W = RTCVALH;
	W = decadj( --W );
	RTCVALH = W;

	rtc_wr_disable();	// disable rtc writes
}	

void rtc_inc_second( void )
{
	while( RTCSYNC );	// wait until safe to write
	RTCPTR0 = 0;		// select seconds in register pointer
	rtc_wr_enable();	// enable rtc writes

	W = RTCVALL;
	W = decadj( ++W );
	RTCVALL = W;

	rtc_wr_disable();	// disable rtc writes
}	

void rtc_dec_second( void )
{
	while( RTCSYNC );	// wait until safe to write
	RTCPTR0 = 0;		// select seconds in register pointer
	rtc_wr_enable();	// enable rtc writes

	W = RTCVALL;
	W = decadj( --W );
	RTCVALL = W;

	rtc_wr_disable();	// disable rtc writes
}	

#endif // _RTC_C