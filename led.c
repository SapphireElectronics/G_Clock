#ifndef _LED_C
#define _LED_C

#include "led.h"

#define LED_ROW_PORT PORTB
#define LED_COL_PORT PORTC

// LED data is stored in an array of 5 bytes.
// each byte represents a row
// row data is loaded into the row output registers,
//   then the corresponding col bit is set low to turn on the LEDs
//
//      MSB           LSB
// Row4  O 0 0 0 0 0 0 0
//    3  O 0 0 0 0 0 0 0
//    2  O 0 0 0 0 0 0 0
//    1  O 0 0 0 0 0 0 0
//    0  O 0 0 0 0 0 0 0

uns8 led_mode;
uns8 led_row[5];

const uns8 led_row_enable[5] =
{	
	0b11111110,
	0b11111101,
	0b11111011,
	0b10111111,
	0b01111111
};	

// seconds are displayed in rows 7 and 8
// value is formatted in BCD, upper nibble is tens, lower nibble is units.
void led_load_second( uns8 second )
{
	led_row[0].0 = second.0;
	led_row[1].0 = second.1;
	led_row[2].0 = second.2;
	led_row[3].0 = second.3;
	led_row[0].1 = second.4;
	led_row[1].1 = second.5;
	led_row[2].1 = second.6;
	led_row[3].1 = second.7;
}
	
// seconds are displayed in rows 4 and 5
// value is formatted in BCD, upper nibble is tens, lower nibble is units.
void led_load_minute( uns8 minute )
{
	led_row[0].3 = minute.0;
	led_row[1].3 = minute.1;
	led_row[2].3 = minute.2;
	led_row[3].3 = minute.3;
	led_row[0].4 = minute.4;
	led_row[1].4 = minute.5;
	led_row[2].4 = minute.6;
	led_row[3].4 = minute.7;
}
	
// seconds are displayed in rows 1 and 2
// value is formatted in BCD, upper nibble is tens, lower nibble is units.
void led_load_hour( uns8 hour )
{
	led_row[0].6 = hour.0;
	led_row[1].6 = hour.1;
	led_row[2].6 = hour.2;
	led_row[3].6 = hour.3;
	led_row[0].7 = hour.4;
	led_row[1].7 = hour.5;
	led_row[2].7 = hour.6;
	led_row[3].7 = hour.7;
}	

const uns8 led_char[] = 
{
	0b01000000, 0b10100000, 0b11100000, 0b10100000, 0b10100000,		// A
	0b11000000, 0b10100000, 0b11000000, 0b10100000, 0b11000000,		// B
	0b01000000, 0b10100000, 0b10000000, 0b10100000, 0b01000000,		// C
	0b11000000, 0b10100000, 0b10100000, 0b10100000, 0b11000000,		// D
	0b11100000, 0b10000000, 0b11100000, 0b10000000, 0b11100000,		// E
	0b11100000, 0b10000000, 0b11100000, 0b10000000, 0b10000000,		// F
	0b01000000, 0b10100000, 0b10000000, 0b11100000, 0b01000000,		// G
	0b10100000, 0b10100000, 0b11100000, 0b10100000, 0b10100000,		// H
	0b01000000, 0b01000000, 0b01000000, 0b01000000, 0b11100000,		// I
	0b00100000, 0b00100000, 0b00100000, 0b10100000, 0b01000000,		// J
	0b10100000, 0b11000000, 0b10000000, 0b11000000, 0b10100000,		// K
	0b10000000, 0b10000000, 0b10000000, 0b10000000, 0b11100000,		// L
	0b10100000, 0b11100000, 0b10100000, 0b10100000, 0b10100000,		// M
	0b10100000, 0b11100000, 0b11100000, 0b10100000, 0b10100000,		// N
	0b01000000, 0b10100000, 0b10100000, 0b10100000, 0b01000000,		// O
	0b11000000, 0b10100000, 0b11000000, 0b10000000, 0b10000000,		// P
	0b01000000, 0b10100000, 0b10100000, 0b10100000, 0b01100000,		// Q
	0b11000000, 0b10100000, 0b11000000, 0b11000000, 0b10100000,		// R
	0b11100000, 0b10000000, 0b01000000, 0b00100000, 0b11100000,		// S
	0b11100000, 0b01000000, 0b01000000, 0b01000000, 0b11100000,		// T
	0b10100000, 0b10100000, 0b10100000, 0b10100000, 0b11100000,		// U
	0b10100000, 0b10100000, 0b10100000, 0b10100000, 0b01000000,		// V
	0b10100000, 0b10100000, 0b10100000, 0b11100000, 0b10100000,		// W
	0b10100000, 0b10100000, 0b01000000, 0b10100000, 0b10100000,		// X
	0b10100000, 0b10100000, 0b01000000, 0b01000000, 0b01000000,		// Y
	0b11100000, 0b00100000, 0b01000000, 0b10000000, 0b11100000		// Z
};	

const uns8 led_value[] = 
{
	0b00000010, 0b00000101, 0b00000101, 0b00000101, 0b00000010,		// 0
	0b00000010, 0b00000010, 0b00000010, 0b00000010, 0b00000010,		// 1
	0b00000110, 0b00000001, 0b00000010, 0b00000100, 0b00000111,		// 2
	0b00000110, 0b00000001, 0b00000010, 0b00000001, 0b00000110,		// 3
	0b00000101, 0b00000101, 0b00000111, 0b00000001, 0b00000001,		// 4
	0b00000111, 0b00000100, 0b00000110, 0b00000001, 0b00000110,		// 5
	0b00000010, 0b00000100, 0b00000110, 0b00000101, 0b00000010,		// 6
	0b00000111, 0b00000001, 0b00000010, 0b00000010, 0b00000010,		// 7
	0b00000010, 0b00000101, 0b00000010, 0b00000101, 0b00000010,		// 8
	0b00000010, 0b00000101, 0b00000011, 0b00000001, 0b00000010		// 9
};

void led_adj_hour( uns8 hour )
{
	led_show_char( 'H' );

	led_row[0].0 = hour.0;
	led_row[1].0 = hour.1;
	led_row[2].0 = hour.2;
	led_row[3].0 = hour.3;
	led_row[0].1 = hour.4;
	led_row[1].1 = hour.5;
	led_row[2].1 = hour.6;
	led_row[3].1 = hour.7;
}	

void led_adj_minute( uns8 minute )
{
	led_show_char( 'M' );
	
	led_row[0].0 = minute.0;
	led_row[1].0 = minute.1;
	led_row[2].0 = minute.2;
	led_row[3].0 = minute.3;
	led_row[0].1 = minute.4;
	led_row[1].1 = minute.5;
	led_row[2].1 = minute.6;
	led_row[3].1 = minute.7;
}	

void led_adj_second( uns8 second )
{
	led_show_char( 'S' );
	
	led_row[0].0 = second.0;
	led_row[1].0 = second.1;
	led_row[2].0 = second.2;
	led_row[3].0 = second.3;
	led_row[0].1 = second.4;
	led_row[1].1 = second.5;
	led_row[2].1 = second.6;
	led_row[3].1 = second.7;
}

void led_load_logo( void )
{
	led_row[4] = 0b01100010;
	led_row[3] = 0b10010101;
	led_row[2] = 0b10000100;
	led_row[1] = 0b10110101;
	led_row[0] = 0b01100010;
}	

void led_clear( void )
{
	led_row[0] = 0;
	led_row[1] = 0;
	led_row[2] = 0;
	led_row[3] = 0;
	led_row[4] = 0;
}	

void led_show_row( uns8 row )
{
	LED_COL_PORT = 0xff;
	LED_ROW_PORT = led_row[ row ];
	LED_COL_PORT = led_row_enable[ row ];
}	

void led_show_char( uns8 data )
{
	data -= 'A';		// offset to first character in table
	data += (data<<2);	// multiply by 5 (5 bytes per character)
	led_row[4] = led_char[data++];
	led_row[3] = led_char[data++];
	led_row[2] = led_char[data++];
	led_row[1] = led_char[data++];
	led_row[0] = led_char[data++];
}	

void led_show_value( uns8 data )
{
	data += (data<<2);	// multiply by 5 (5 bytes per character)
	led_row[4] &= 0b11111000;
	led_row[4] |= led_value[data++];
	led_row[3] &= 0b11111000;
	led_row[3] |= led_value[data++];
	led_row[2] &= 0b11111000;
	led_row[2] |= led_value[data++];
	led_row[1] &= 0b11111000;
	led_row[1] |= led_value[data++];
	led_row[0] &= 0b11111000;
	led_row[0] |= led_value[data++];
}	


void led_show_icon( uns8 icon )
{
#if 0
	switch( icon ) {
		case BUTTON_T:	led_row[4].3 = 1;	break; 
		case BUTTON_O:	led_row[4].2 = 1;	break; 
		case BUTTON_S:	led_row[4].1 = 1;	break; 
		case BUTTON_X:	led_row[4].0 = 1;	break; 
	}	
#endif
}

void led_hide_icon( uns8 icon )
{
#if 0
	switch( icon ) {
		case BUTTON_T:	led_row[4].3 = 0;	break; 
		case BUTTON_O:	led_row[4].2 = 0;	break; 
		case BUTTON_S:	led_row[4].1 = 0;	break; 
		case BUTTON_X:	led_row[4].0 = 0;	break; 
	}
#endif	
}		

void led_init( void )
{
	led_mode = LED_MODE_HORI;
	led_clear();
}	
	

#endif // _LED_C