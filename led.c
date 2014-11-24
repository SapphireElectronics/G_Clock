#ifndef _LED_C
#define _LED_C

#include "led.h"

#define LED_ROW_PORT PORTB
#define LED_COL_PORT PORTC

// LED data is stored in an array of 8 bytes.
// each byte represents row
// row data is loaded into the column output registers,
//   then the corresponding row bit is set high to turn on the LEDs

uns8 led_row[8];

const uns8 led_col_map[] =
{
	0b00000000,
	0b01000000,
	0b00000100,
	0b01000100,
	0b00000010,
	0b01000010,
	0b00000110,
	0b01000110,
	0b00000001,
	0b01000001,
	0b00000101,
	0b01000101,
	0b00000011,
	0b01000011,
	0b00000111,
	0b01000111
};

const uns8 led_row_map[] =
{ 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };	



// seconds are displayed in rows 7 and 8
// value is formatted in BCD, upper nibble is tens, lower nibble is units.
void led_show_second( uns8 second )
{
	led_row[7] = led_col_map[ second & 0x0f ];
	second = swap( second );
	led_row[6] = led_col_map[ second & 0x0f ];
}
	
// seconds are displayed in rows 4 and 5
// value is formatted in BCD, upper nibble is tens, lower nibble is units.
void led_show_minute( uns8 minute )
{
	led_row[4] = led_col_map[ minute & 0x0f ];
	minute = swap( minute );
	led_row[3] = led_col_map[ minute & 0x0f ];
}
	
// seconds are displayed in rows 1 and 2
// value is formatted in BCD, upper nibble is tens, lower nibble is units.
void led_show_hour( uns8 hour )
{
	led_row[1] = led_col_map[ hour & 0x0f ];
	hour = swap( hour );
	led_row[0] = led_col_map[ hour & 0x0f ];
}	


void led_show_row( uns8 row )
{
	LED_ROW_PORT = 0;
	LED_COL_PORT = led_row[ row ];
	LED_ROW_PORT = led_row_map[ row ];
}	

#endif // _LED_C