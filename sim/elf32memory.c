#include <stdio.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <elf.h>
#include <string.h>

#include "svdpi.h"

typedef char data_type;

int fd;                                                                                                               
FILE *fp;                                                                                                                                                                                                                                       
struct stat stbuf;                                                                                                    

struct memory_t {
  int start_address;
  int length;
  char* mem;
} memory[4];

//memory_t* memory;

data_type* head;
unsigned char *buf;

Elf32_Ehdr* elf_header;
Elf32_Phdr* elf_pheader;

Elf32_Shdr* elf_sheader;
Elf32_Shdr* elf_shstr;

Elf32_Phdr* get_phdr(const int index){
  return (Elf32_Phdr *)(head + elf_header->e_phoff + elf_header->e_phentsize * index);
}

Elf32_Shdr* get_shdr(const int index){
  return (Elf32_Shdr *)(head + elf_header->e_shoff + elf_header->e_shentsize * index);
}

char* get_section(const int index){
  Elf32_Shdr* shdr = get_shdr(index);
  return (data_type *)(head + shdr->sh_offset);
}

char* get_program(const int index){
  Elf32_Phdr* phdr = get_phdr(index);
  return (data_type* ) (head + phdr->p_offset);
}


char* get_label(const int index){
  Elf32_Shdr* shdr = get_shdr(index);
  return (char *)(head + elf_shstr->sh_offset + shdr->sh_name);
}

void display_elf_header(){
  int i;
  for( i=0; i<elf_header->e_phnum; i++){                                                                             
    //printf("Memory Select ", decode_chip_select(elf_pheader[i].p_paddr);                                        
    printf("\tStart Address : 0x%x\n", elf_pheader[i].p_paddr);                                         
    printf("\tFile size     : %d\n", elf_pheader[i].p_filesz);                                           
    printf("\tMemory size   : %d\n", elf_pheader[i].p_memsz);                                            
    
    printf("\n");
  }
}



void loadFile(char* name){
  int i=0;
  fd = open(name, O_RDONLY);                                                                                         
  if( fd != NULL ) printf("@1 Load File : %s\n", name);

  fstat(fd, &stbuf);                                                                                                    
  printf("@2 File size : %d byte\n", stbuf.st_size);

  head = (char*)mmap(NULL, stbuf.st_size, PROT_READ, MAP_SHARED, fd, 0);                                           
  
  elf_header  = (Elf32_Ehdr *)head;                                                                                     
  elf_pheader = (Elf32_Phdr *)(head + elf_header->e_phoff);                                                             

  // 使わない                                                                                                               
  elf_sheader = (Elf32_Shdr *)(head + elf_header->e_shoff);                                                             
  elf_shstr   = get_shdr(elf_header->e_shstrndx);                                                                       
    
  memory[0].start_address  = 0x00000000;
  memory[0].length = 1024*1024*256;
  memory[0].mem = (char *)malloc(memory[0].length);

  memory[1].start_address  = 0x10000000;
  memory[1].length = 1024*1024*256;
  memory[1].mem = (char *)malloc(1024*1024*1024);

  memory[2].start_address  = 0x20000000;
  memory[2].length = 1024*1024*256;
  memory[2].mem = (char *)malloc(1024*1024*1024);

  memory[3].start_address  = 0x30000000;
  memory[3].length = 1024*1024*256;
  memory[3].mem = (char *)malloc(1024*1024*1024);

  display_elf_header();


  for(i=0; i<elf_header->e_phnum; i++){                                                                                    
    data_type* m = memory[ decode_cs(elf_pheader[i].p_paddr) ].mem;                                                  

    int offset = elf_pheader[i].p_paddr - memory[ decode_cs(elf_pheader[i].p_paddr) ].start_address;                    
    
    if( offset >= 0 ){                                                                                                         
      m = m+offset;                                                                                                            
    }else{                                                                                                                     
      printf("Program Area is not overlapped.\n");
    }                                                                                                                          
    
    memcpy( m, get_program(i), elf_pheader[i].p_memsz );                                                                           
  }                                                                                                                            
                                                                                                                                 
}

int decode_cs(int address){
  if( 0x00000000 <= address && address < 0x10000000 ) return 0;
  if( 0x10000000 <= address && address < 0x20000000 ) return 1;
  if( 0x20000000 <= address && address < 0x30000000 ) return 2;

  return 3;
}

void readdata (int address, int length, char* data){
  int i=0;
  int cs_index = decode_cs(address);
  int memaddr  = address - memory[cs_index].start_address;

  for( i=0; i<length; i++){
    data[i] = memory[cs_index].mem[memaddr+i];
  }

}

void writedata(int address, int length, char* data, char* mask){
  int i=0;
  int cs_index = decode_cs(address);
  int memaddr  = address - memory[cs_index].start_address;

  for( i=0; i<length; i++){
    memory[cs_index].mem[memaddr+i] = data[i];
  }

}


