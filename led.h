#ifndef _LED_H
#define _LED_H

enum { LED_MODE_HORI, LED_MOD_VERT };

void led_load_second( uns8 second );
void led_load_minute( uns8 minute );
void led_load_hour( uns8 hour );
void led_load_logo();
void led_clear( void );
void led_show_row( uns8 row );
void led_show_char( uns8 data );
void led_show_value( uns8 data );
void led_init( void );
void led_set_mode( void );
void led_show_icon( uns8 icon );
void led_hide_icon( uns8 icon );

#endif // _LED_H