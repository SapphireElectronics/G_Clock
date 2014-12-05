#ifndef _EEDATA_H
#define _EEDATA_H

void copyToRam( char block, char *ram_ptr, char size );
void copyToEE( char *ram_ptr, char block, char size );

#if 0
uns16 ee_read_word( uns8 upper, uns8 high, uns8 low );
void ee_write_word( uns8 upper, uns8 high, uns8 low, uns16 data );
#endif
	
#endif // _EEDATA_H
