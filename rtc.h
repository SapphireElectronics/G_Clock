#ifndef _RTC_H
#define _RTC_H

void rtc_init( void );
void rtc_wr_enable( void );
void rtc_wr_disable( void );
void rtc_set_hour( uns8 hour );
void rtc_set_minute( uns8 minute );
void rtc_set_second( uns8 second );
void rtc_inc_hour( void );
void rtc_dec_hour( void );
void rtc_inc_minute( void );
void rtc_dec_minute( void );
void rtc_inc_second( void );
void rtc_dec_second( void );


#endif // _RTC_H