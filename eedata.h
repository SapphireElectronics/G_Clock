#ifndef _EEDATA_H
#define _EEDATA_H

uns16 ee_read_word( uns8 upper, uns8 high, uns8 low );
void ee_write_word( uns8 upper, uns8 high, uns8 low, uns16 data );

#endif // _EEDATA_H
