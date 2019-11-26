/*
* poke utility - for those who remember the good old days!
*

* Copyright (C) 2013 - 2016  Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or (b) that interact
* with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in this
* Software without prior written authorization from Xilinx.
*
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>

void usage(char *prog)
{
	printf("usage: %s /dev/uio0 MAPPING OFFSET VAL\n",prog);
	printf("\n");
	printf("MAPPING, OFFSET and VAL may be specified as hex values\n");
}

int main(int argc, char *argv[])
{
	int fd;
	void *ptr;
	unsigned val;
	unsigned addr, mapping,  page_mask, map_size;
	unsigned page_size=sysconf(_SC_PAGESIZE);

	if(argc!=5) {
		usage(argv[0]);
		exit(-1);
	}

	fd=open(argv[1],O_RDWR);
	if(fd<1) {
		perror(argv[0]);
		exit(-1);
	}

	page_mask = ~(page_size - 1); // mask of page-selector address bits
	mapping = strtoul(argv[2],NULL,0);
	addr = strtoul(argv[3],NULL,0);
	val = strtoul(argv[4],NULL,0);
	map_size = (addr & page_mask) + page_size; // what page it is in, plus the length of that page.

	ptr=mmap(NULL,map_size,PROT_READ|PROT_WRITE,MAP_SHARED,fd,mapping);
	if((int)ptr==-1) {
		perror(argv[0]);
		exit(-1);
	}

	*((unsigned *)(ptr+addr))=val;
	return 0;
}
