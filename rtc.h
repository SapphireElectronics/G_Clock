#ifndef _RTC_H
#define _RTC_H

void rtc_init( void );
void rtc_set_hour( uns8 hour );
void rtc_set_minute( uns8 minute );
void rtc_set_second( uns8 second );

void rtc_inc_hour( void );
void rtc_dec_hour( void );
void rtc_inc_minute( void );
void rtc_dec_minute( void );
void rtc_inc_second( void );
void rtc_dec_second( void );

uns8 rtc_get_second( void );
uns8 rtc_get_minute( void );
uns8 rtc_get_hour( void );

void rtc_int( void );
void rtc_increment( void );

void rtc_daw_hour( void );
void rtc_daw_minute( void );
void rtc_daw_second( void );



#endif // _RTC_H