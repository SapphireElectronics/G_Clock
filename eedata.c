#ifndef _EEDATA_C
#define _EEDATA_C

#include "eedata.h"

// copy block of Flash memory to RAM
// done at startup to populate parameter values

void copyToRam( char block, char *ram_ptr, char size )
{
	char i;

	// set EEPROM address
	TBLPTRU = 0x00;
	TBLPTRH = block;
	TBLPTRL = 0x00;

	for( i=0; i<size; i++ )
	{
		tableReadInc();
		*ram_ptr++ = TABLAT;
	}	
}	

void copyToEE( char *ram_ptr, char block, char size )
{
	char i;

	// set EEPROM address
	TBLPTRU = 0x00;
	TBLPTRH = block;
	TBLPTRL = 0x00;

	// erase the EEPROM block
	WREN = 1;	// enable write to memory
	FREE = 1;	// enable erase
	GIE = 0;		// disable interrupts
	
	EECON2 = 0x55;		// unlock EEPROM
	EECON2 = 0xaa;

	WR = 1;		// start erase, halts until complete

	// load new data into the holding registers

	for( i=0; i<size; i++ )
	{
		TABLAT = *ram_ptr++;
		tableWriteInc();
	}	

	WREN = 1;	// enable write to memory
	
	EECON2 = 0x55;		// unlock EEPROM
	EECON2 = 0xaa;

	WR = 1;		// start write, halts until complete
	WREN = 0;	// disable writes

	GIE = 1;		// enable interrupts
}	

#if 0
uns16 ee_read_word( uns8 upper, uns8 high, uns8 low )
{
	uns16 data;
	
	TBLPTRU = upper;
	TBLPTRH = high;
	TBLPTRL = low;

	tableReadInc();
	data.low8 = TABLAT;
	
	tableReadInc();
	data.high8 = TABLAT;
}
	
// NOTES:  Can only erase blocks of 512 words (1024 bytes)
// make sure write addess is an even location
	
void ee_write_word( uns8 upper, uns8 high, uns8 low, uns16 data )
{
	TBLPTRU = upper;
	TBLPTRH = high;
	TBLPTRL = low;

	// erase the EEPROM block
	WREN = 1;	// enable write to memory
	FREE = 1;	// enable erase
	GIE = 0;	// disable interrupts
	
	EECON2 = 0x55;		// unlock EEPROM
	EECON2 = 0xaa;

	WR = 1;		// start erase, halts until complete

	// load new data into the holding registers
	TABLAT = data.low8;
	tableWriteInc();
	TABLAT = data.high8;
	
	WPROG = 1;	// enable single word mode
	WREN = 1;	// enable write to memory
	
	EECON2 = 0x55;		// unlock EEPROM
	EECON2 = 0xaa;

	WR = 1;		// start write, halts until complete

	GIE = 1;	// enable interrupts
	WREN = 0;	// disable writes
	WPROG = 0;	// disable single word more
}	
#endif 

#endif // _EEDATA_C
