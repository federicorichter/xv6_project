#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "elf.h"

//static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    int perm = 0;
    if(flags & 0x1)
      perm = PTE_X;
    if(flags & 0x2)
      perm |= PTE_W;
    return perm;
}

int
exec(char *path, char **argv)
{
  char *s, *last;
  int i, off;
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  //pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;

  if(elf.magic != ELF_MAGIC)
    goto bad;

  //if((pagetable = proc_pagetable(p)) == 0)
    //goto bad;

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    
    //uint64 sz1;
    uint64 pointer_segment; 
    //this has to be changed to use the heap memory space
    if((pointer_segment = ualloc(sz, ph.vaddr + ph.memsz)) == 0){
      goto bad;
    }

    /*if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0) 
      goto bad;
    sz = sz1;
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;*/
    memset((void *)pointer_segment, 0, ph.memsz);

    // Copy the program data from the ELF file to the allocated memory
    if (readi(ip, 0, pointer_segment, ph.off, ph.filesz) != ph.filesz)
      goto bad;

    sz = pointer_segment + ph.memsz;
  }
  iunlockput(ip);
  end_op();
  ip = 0;

  p = myproc();
  //uint64 oldsz = p->sz;

  // Align the process size to a page boundary
  sz = PGROUNDUP(sz);

  // Allocate space for the stack (guard + user stack)
  uint64 stack_guard = PGSIZE; // Guard page size
  uint64 stack_size = USERSTACK * PGSIZE; // Total stack size
  uint64 stack_top;

  // Allocate memory for stack
  if ((stack_top = ualloc(sz, stack_guard + stack_size)) == 0)
    goto bad;

  // Set stack base and top
  stackbase = stack_top - stack_size;
  sp = stack_top;

  // Push argument strings onto the stack
  for (argc = 0; argv[argc]; argc++) {
    if (argc >= MAXARG)
      goto bad;
    sp -= strlen(argv[argc]) + 1;
    sp -= sp % 16; // Align stack to 16 bytes
    if (sp < stackbase)
      goto bad;
    // Copy argument to stack
    memmove((void *)sp, argv[argc], strlen(argv[argc]) + 1);
    ustack[argc] = sp;
  }
  ustack[argc] = 0;

  // Push the array of argv[] pointers
  sp -= (argc + 1) * sizeof(uint64);
  sp -= sp % 16;
  if (sp < stackbase)
    goto bad;
  memmove((void *)sp, (void *)ustack, (argc + 1) * sizeof(uint64));

  // Set arguments for user main(argc, argv)
  p->trapframe->a1 = sp;

  // Save program name for debugging
  for (last = s = path; *s; s++) {
    if (*s == '/')
      last = s + 1;
  }
  safestrcpy(p->name, last, sizeof(p->name));

  // Commit to the user image
  p->sz = sz + stack_guard + stack_size; // Update process size
  p->trapframe->epc = elf.entry;         // Entry point for program
  p->trapframe->sp = sp;                 // Initial stack pointer

  return argc; // this ends up in a0, the first argument to main(argc, argv)

 bad:
  //if(pagetable)
    //proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}

// Load a program segment into pagetable at virtual address va.
// va must be page-aligned
// and the pages from va to va+sz must already be mapped.
// Returns 0 on success, -1 on failure.
/*static int
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
      return -1;
  }
  
  return 0;
}*/
