
user/_init:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	fe010113          	addi	sp,sp,-32
   4:	00113c23          	sd	ra,24(sp)
   8:	00813823          	sd	s0,16(sp)
   c:	00913423          	sd	s1,8(sp)
  10:	01213023          	sd	s2,0(sp)
  14:	02010413          	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  18:	00200593          	li	a1,2
  1c:	00001517          	auipc	a0,0x1
  20:	cf450513          	addi	a0,a0,-780 # d10 <malloc+0x174>
  24:	4f4000ef          	jal	518 <open>
  28:	04054c63          	bltz	a0,80 <main+0x80>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  2c:	00000513          	li	a0,0
  30:	53c000ef          	jal	56c <dup>
  dup(0);  // stderr
  34:	00000513          	li	a0,0
  38:	534000ef          	jal	56c <dup>

  for(;;){
    printf("init: starting sh\n");
  3c:	00001917          	auipc	s2,0x1
  40:	cdc90913          	addi	s2,s2,-804 # d18 <malloc+0x17c>
  44:	00090513          	mv	a0,s2
  48:	255000ef          	jal	a9c <printf>
    pid = fork();
  4c:	460000ef          	jal	4ac <fork>
  50:	00050493          	mv	s1,a0
    if(pid < 0){
  54:	04054a63          	bltz	a0,a8 <main+0xa8>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  58:	06050263          	beqz	a0,bc <main+0xbc>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  5c:	00000513          	li	a0,0
  60:	464000ef          	jal	4c4 <wait>
      if(wpid == pid){
  64:	fea480e3          	beq	s1,a0,44 <main+0x44>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  68:	fe055ae3          	bgez	a0,5c <main+0x5c>
        printf("init: wait returned an error\n");
  6c:	00001517          	auipc	a0,0x1
  70:	cfc50513          	addi	a0,a0,-772 # d68 <malloc+0x1cc>
  74:	229000ef          	jal	a9c <printf>
        exit(1);
  78:	00100513          	li	a0,1
  7c:	43c000ef          	jal	4b8 <exit>
    mknod("console", CONSOLE, 0);
  80:	00000613          	li	a2,0
  84:	00100593          	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	c8850513          	addi	a0,a0,-888 # d10 <malloc+0x174>
  90:	494000ef          	jal	524 <mknod>
    open("console", O_RDWR);
  94:	00200593          	li	a1,2
  98:	00001517          	auipc	a0,0x1
  9c:	c7850513          	addi	a0,a0,-904 # d10 <malloc+0x174>
  a0:	478000ef          	jal	518 <open>
  a4:	f89ff06f          	j	2c <main+0x2c>
      printf("init: fork failed\n");
  a8:	00001517          	auipc	a0,0x1
  ac:	c8850513          	addi	a0,a0,-888 # d30 <malloc+0x194>
  b0:	1ed000ef          	jal	a9c <printf>
      exit(1);
  b4:	00100513          	li	a0,1
  b8:	400000ef          	jal	4b8 <exit>
      exec("sh", argv);
  bc:	00001597          	auipc	a1,0x1
  c0:	f4458593          	addi	a1,a1,-188 # 1000 <argv>
  c4:	00001517          	auipc	a0,0x1
  c8:	c8450513          	addi	a0,a0,-892 # d48 <malloc+0x1ac>
  cc:	440000ef          	jal	50c <exec>
      printf("init: exec sh failed\n");
  d0:	00001517          	auipc	a0,0x1
  d4:	c8050513          	addi	a0,a0,-896 # d50 <malloc+0x1b4>
  d8:	1c5000ef          	jal	a9c <printf>
      exit(1);
  dc:	00100513          	li	a0,1
  e0:	3d8000ef          	jal	4b8 <exit>

00000000000000e4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  e4:	ff010113          	addi	sp,sp,-16
  e8:	00113423          	sd	ra,8(sp)
  ec:	00813023          	sd	s0,0(sp)
  f0:	01010413          	addi	s0,sp,16
  extern int main();
  main();
  f4:	f0dff0ef          	jal	0 <main>
  exit(0);
  f8:	00000513          	li	a0,0
  fc:	3bc000ef          	jal	4b8 <exit>

0000000000000100 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 100:	ff010113          	addi	sp,sp,-16
 104:	00813423          	sd	s0,8(sp)
 108:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10c:	00050793          	mv	a5,a0
 110:	00158593          	addi	a1,a1,1
 114:	00178793          	addi	a5,a5,1
 118:	fff5c703          	lbu	a4,-1(a1)
 11c:	fee78fa3          	sb	a4,-1(a5)
 120:	fe0718e3          	bnez	a4,110 <strcpy+0x10>
    ;
  return os;
}
 124:	00813403          	ld	s0,8(sp)
 128:	01010113          	addi	sp,sp,16
 12c:	00008067          	ret

0000000000000130 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 130:	ff010113          	addi	sp,sp,-16
 134:	00813423          	sd	s0,8(sp)
 138:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
 13c:	00054783          	lbu	a5,0(a0)
 140:	00078e63          	beqz	a5,15c <strcmp+0x2c>
 144:	0005c703          	lbu	a4,0(a1)
 148:	00f71a63          	bne	a4,a5,15c <strcmp+0x2c>
    p++, q++;
 14c:	00150513          	addi	a0,a0,1
 150:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
 154:	00054783          	lbu	a5,0(a0)
 158:	fe0796e3          	bnez	a5,144 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 15c:	0005c503          	lbu	a0,0(a1)
}
 160:	40a7853b          	subw	a0,a5,a0
 164:	00813403          	ld	s0,8(sp)
 168:	01010113          	addi	sp,sp,16
 16c:	00008067          	ret

0000000000000170 <strlen>:

uint
strlen(const char *s)
{
 170:	ff010113          	addi	sp,sp,-16
 174:	00813423          	sd	s0,8(sp)
 178:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 17c:	00054783          	lbu	a5,0(a0)
 180:	02078863          	beqz	a5,1b0 <strlen+0x40>
 184:	00150513          	addi	a0,a0,1
 188:	00050793          	mv	a5,a0
 18c:	00078693          	mv	a3,a5
 190:	00178793          	addi	a5,a5,1
 194:	fff7c703          	lbu	a4,-1(a5)
 198:	fe071ae3          	bnez	a4,18c <strlen+0x1c>
 19c:	40a6853b          	subw	a0,a3,a0
 1a0:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
 1a4:	00813403          	ld	s0,8(sp)
 1a8:	01010113          	addi	sp,sp,16
 1ac:	00008067          	ret
  for(n = 0; s[n]; n++)
 1b0:	00000513          	li	a0,0
 1b4:	ff1ff06f          	j	1a4 <strlen+0x34>

00000000000001b8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b8:	ff010113          	addi	sp,sp,-16
 1bc:	00813423          	sd	s0,8(sp)
 1c0:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1c4:	02060063          	beqz	a2,1e4 <memset+0x2c>
 1c8:	00050793          	mv	a5,a0
 1cc:	02061613          	slli	a2,a2,0x20
 1d0:	02065613          	srli	a2,a2,0x20
 1d4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1dc:	00178793          	addi	a5,a5,1
 1e0:	fee79ce3          	bne	a5,a4,1d8 <memset+0x20>
  }
  return dst;
}
 1e4:	00813403          	ld	s0,8(sp)
 1e8:	01010113          	addi	sp,sp,16
 1ec:	00008067          	ret

00000000000001f0 <strchr>:

char*
strchr(const char *s, char c)
{
 1f0:	ff010113          	addi	sp,sp,-16
 1f4:	00813423          	sd	s0,8(sp)
 1f8:	01010413          	addi	s0,sp,16
  for(; *s; s++)
 1fc:	00054783          	lbu	a5,0(a0)
 200:	02078263          	beqz	a5,224 <strchr+0x34>
    if(*s == c)
 204:	00f58a63          	beq	a1,a5,218 <strchr+0x28>
  for(; *s; s++)
 208:	00150513          	addi	a0,a0,1
 20c:	00054783          	lbu	a5,0(a0)
 210:	fe079ae3          	bnez	a5,204 <strchr+0x14>
      return (char*)s;
  return 0;
 214:	00000513          	li	a0,0
}
 218:	00813403          	ld	s0,8(sp)
 21c:	01010113          	addi	sp,sp,16
 220:	00008067          	ret
  return 0;
 224:	00000513          	li	a0,0
 228:	ff1ff06f          	j	218 <strchr+0x28>

000000000000022c <gets>:

char*
gets(char *buf, int max)
{
 22c:	fa010113          	addi	sp,sp,-96
 230:	04113c23          	sd	ra,88(sp)
 234:	04813823          	sd	s0,80(sp)
 238:	04913423          	sd	s1,72(sp)
 23c:	05213023          	sd	s2,64(sp)
 240:	03313c23          	sd	s3,56(sp)
 244:	03413823          	sd	s4,48(sp)
 248:	03513423          	sd	s5,40(sp)
 24c:	03613023          	sd	s6,32(sp)
 250:	01713c23          	sd	s7,24(sp)
 254:	06010413          	addi	s0,sp,96
 258:	00050b93          	mv	s7,a0
 25c:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 260:	00050913          	mv	s2,a0
 264:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 268:	00a00a93          	li	s5,10
 26c:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 270:	00048993          	mv	s3,s1
 274:	0014849b          	addiw	s1,s1,1
 278:	0344dc63          	bge	s1,s4,2b0 <gets+0x84>
    cc = read(0, &c, 1);
 27c:	00100613          	li	a2,1
 280:	faf40593          	addi	a1,s0,-81
 284:	00000513          	li	a0,0
 288:	254000ef          	jal	4dc <read>
    if(cc < 1)
 28c:	02a05263          	blez	a0,2b0 <gets+0x84>
    buf[i++] = c;
 290:	faf44783          	lbu	a5,-81(s0)
 294:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 298:	01578a63          	beq	a5,s5,2ac <gets+0x80>
 29c:	00190913          	addi	s2,s2,1
 2a0:	fd6798e3          	bne	a5,s6,270 <gets+0x44>
    buf[i++] = c;
 2a4:	00048993          	mv	s3,s1
 2a8:	0080006f          	j	2b0 <gets+0x84>
 2ac:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2b0:	013b89b3          	add	s3,s7,s3
 2b4:	00098023          	sb	zero,0(s3)
  return buf;
}
 2b8:	000b8513          	mv	a0,s7
 2bc:	05813083          	ld	ra,88(sp)
 2c0:	05013403          	ld	s0,80(sp)
 2c4:	04813483          	ld	s1,72(sp)
 2c8:	04013903          	ld	s2,64(sp)
 2cc:	03813983          	ld	s3,56(sp)
 2d0:	03013a03          	ld	s4,48(sp)
 2d4:	02813a83          	ld	s5,40(sp)
 2d8:	02013b03          	ld	s6,32(sp)
 2dc:	01813b83          	ld	s7,24(sp)
 2e0:	06010113          	addi	sp,sp,96
 2e4:	00008067          	ret

00000000000002e8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2e8:	fe010113          	addi	sp,sp,-32
 2ec:	00113c23          	sd	ra,24(sp)
 2f0:	00813823          	sd	s0,16(sp)
 2f4:	01213023          	sd	s2,0(sp)
 2f8:	02010413          	addi	s0,sp,32
 2fc:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 300:	00000593          	li	a1,0
 304:	214000ef          	jal	518 <open>
  if(fd < 0)
 308:	02054e63          	bltz	a0,344 <stat+0x5c>
 30c:	00913423          	sd	s1,8(sp)
 310:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 314:	00090593          	mv	a1,s2
 318:	224000ef          	jal	53c <fstat>
 31c:	00050913          	mv	s2,a0
  close(fd);
 320:	00048513          	mv	a0,s1
 324:	1d0000ef          	jal	4f4 <close>
  return r;
 328:	00813483          	ld	s1,8(sp)
}
 32c:	00090513          	mv	a0,s2
 330:	01813083          	ld	ra,24(sp)
 334:	01013403          	ld	s0,16(sp)
 338:	00013903          	ld	s2,0(sp)
 33c:	02010113          	addi	sp,sp,32
 340:	00008067          	ret
    return -1;
 344:	fff00913          	li	s2,-1
 348:	fe5ff06f          	j	32c <stat+0x44>

000000000000034c <atoi>:

int
atoi(const char *s)
{
 34c:	ff010113          	addi	sp,sp,-16
 350:	00813423          	sd	s0,8(sp)
 354:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 358:	00054683          	lbu	a3,0(a0)
 35c:	fd06879b          	addiw	a5,a3,-48
 360:	0ff7f793          	zext.b	a5,a5
 364:	00900613          	li	a2,9
 368:	04f66063          	bltu	a2,a5,3a8 <atoi+0x5c>
 36c:	00050713          	mv	a4,a0
  n = 0;
 370:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 374:	00170713          	addi	a4,a4,1
 378:	0025179b          	slliw	a5,a0,0x2
 37c:	00a787bb          	addw	a5,a5,a0
 380:	0017979b          	slliw	a5,a5,0x1
 384:	00d787bb          	addw	a5,a5,a3
 388:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 38c:	00074683          	lbu	a3,0(a4)
 390:	fd06879b          	addiw	a5,a3,-48
 394:	0ff7f793          	zext.b	a5,a5
 398:	fcf67ee3          	bgeu	a2,a5,374 <atoi+0x28>
  return n;
}
 39c:	00813403          	ld	s0,8(sp)
 3a0:	01010113          	addi	sp,sp,16
 3a4:	00008067          	ret
  n = 0;
 3a8:	00000513          	li	a0,0
 3ac:	ff1ff06f          	j	39c <atoi+0x50>

00000000000003b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b0:	ff010113          	addi	sp,sp,-16
 3b4:	00813423          	sd	s0,8(sp)
 3b8:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3bc:	02b57c63          	bgeu	a0,a1,3f4 <memmove+0x44>
    while(n-- > 0)
 3c0:	02c05463          	blez	a2,3e8 <memmove+0x38>
 3c4:	02061613          	slli	a2,a2,0x20
 3c8:	02065613          	srli	a2,a2,0x20
 3cc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3d0:	00050713          	mv	a4,a0
      *dst++ = *src++;
 3d4:	00158593          	addi	a1,a1,1
 3d8:	00170713          	addi	a4,a4,1
 3dc:	fff5c683          	lbu	a3,-1(a1)
 3e0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3e4:	fef718e3          	bne	a4,a5,3d4 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e8:	00813403          	ld	s0,8(sp)
 3ec:	01010113          	addi	sp,sp,16
 3f0:	00008067          	ret
    dst += n;
 3f4:	00c50733          	add	a4,a0,a2
    src += n;
 3f8:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 3fc:	fec056e3          	blez	a2,3e8 <memmove+0x38>
 400:	fff6079b          	addiw	a5,a2,-1
 404:	02079793          	slli	a5,a5,0x20
 408:	0207d793          	srli	a5,a5,0x20
 40c:	fff7c793          	not	a5,a5
 410:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 414:	fff58593          	addi	a1,a1,-1
 418:	fff70713          	addi	a4,a4,-1
 41c:	0005c683          	lbu	a3,0(a1)
 420:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 424:	fee798e3          	bne	a5,a4,414 <memmove+0x64>
 428:	fc1ff06f          	j	3e8 <memmove+0x38>

000000000000042c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 42c:	ff010113          	addi	sp,sp,-16
 430:	00813423          	sd	s0,8(sp)
 434:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 438:	04060463          	beqz	a2,480 <memcmp+0x54>
 43c:	fff6069b          	addiw	a3,a2,-1
 440:	02069693          	slli	a3,a3,0x20
 444:	0206d693          	srli	a3,a3,0x20
 448:	00168693          	addi	a3,a3,1
 44c:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 450:	00054783          	lbu	a5,0(a0)
 454:	0005c703          	lbu	a4,0(a1)
 458:	00e79c63          	bne	a5,a4,470 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 45c:	00150513          	addi	a0,a0,1
    p2++;
 460:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
 464:	fed516e3          	bne	a0,a3,450 <memcmp+0x24>
  }
  return 0;
 468:	00000513          	li	a0,0
 46c:	0080006f          	j	474 <memcmp+0x48>
      return *p1 - *p2;
 470:	40e7853b          	subw	a0,a5,a4
}
 474:	00813403          	ld	s0,8(sp)
 478:	01010113          	addi	sp,sp,16
 47c:	00008067          	ret
  return 0;
 480:	00000513          	li	a0,0
 484:	ff1ff06f          	j	474 <memcmp+0x48>

0000000000000488 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 488:	ff010113          	addi	sp,sp,-16
 48c:	00113423          	sd	ra,8(sp)
 490:	00813023          	sd	s0,0(sp)
 494:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
 498:	f19ff0ef          	jal	3b0 <memmove>
}
 49c:	00813083          	ld	ra,8(sp)
 4a0:	00013403          	ld	s0,0(sp)
 4a4:	01010113          	addi	sp,sp,16
 4a8:	00008067          	ret

00000000000004ac <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ac:	00100893          	li	a7,1
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	00008067          	ret

00000000000004b8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4b8:	00200893          	li	a7,2
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	00008067          	ret

00000000000004c4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4c4:	00300893          	li	a7,3
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	00008067          	ret

00000000000004d0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4d0:	00400893          	li	a7,4
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	00008067          	ret

00000000000004dc <read>:
.global read
read:
 li a7, SYS_read
 4dc:	00500893          	li	a7,5
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	00008067          	ret

00000000000004e8 <write>:
.global write
write:
 li a7, SYS_write
 4e8:	01000893          	li	a7,16
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	00008067          	ret

00000000000004f4 <close>:
.global close
close:
 li a7, SYS_close
 4f4:	01500893          	li	a7,21
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	00008067          	ret

0000000000000500 <kill>:
.global kill
kill:
 li a7, SYS_kill
 500:	00600893          	li	a7,6
 ecall
 504:	00000073          	ecall
 ret
 508:	00008067          	ret

000000000000050c <exec>:
.global exec
exec:
 li a7, SYS_exec
 50c:	00700893          	li	a7,7
 ecall
 510:	00000073          	ecall
 ret
 514:	00008067          	ret

0000000000000518 <open>:
.global open
open:
 li a7, SYS_open
 518:	00f00893          	li	a7,15
 ecall
 51c:	00000073          	ecall
 ret
 520:	00008067          	ret

0000000000000524 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 524:	01100893          	li	a7,17
 ecall
 528:	00000073          	ecall
 ret
 52c:	00008067          	ret

0000000000000530 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 530:	01200893          	li	a7,18
 ecall
 534:	00000073          	ecall
 ret
 538:	00008067          	ret

000000000000053c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 53c:	00800893          	li	a7,8
 ecall
 540:	00000073          	ecall
 ret
 544:	00008067          	ret

0000000000000548 <link>:
.global link
link:
 li a7, SYS_link
 548:	01300893          	li	a7,19
 ecall
 54c:	00000073          	ecall
 ret
 550:	00008067          	ret

0000000000000554 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 554:	01400893          	li	a7,20
 ecall
 558:	00000073          	ecall
 ret
 55c:	00008067          	ret

0000000000000560 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 560:	00900893          	li	a7,9
 ecall
 564:	00000073          	ecall
 ret
 568:	00008067          	ret

000000000000056c <dup>:
.global dup
dup:
 li a7, SYS_dup
 56c:	00a00893          	li	a7,10
 ecall
 570:	00000073          	ecall
 ret
 574:	00008067          	ret

0000000000000578 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 578:	00b00893          	li	a7,11
 ecall
 57c:	00000073          	ecall
 ret
 580:	00008067          	ret

0000000000000584 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 584:	00c00893          	li	a7,12
 ecall
 588:	00000073          	ecall
 ret
 58c:	00008067          	ret

0000000000000590 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 590:	00d00893          	li	a7,13
 ecall
 594:	00000073          	ecall
 ret
 598:	00008067          	ret

000000000000059c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 59c:	00e00893          	li	a7,14
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	00008067          	ret

00000000000005a8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5a8:	fe010113          	addi	sp,sp,-32
 5ac:	00113c23          	sd	ra,24(sp)
 5b0:	00813823          	sd	s0,16(sp)
 5b4:	02010413          	addi	s0,sp,32
 5b8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5bc:	00100613          	li	a2,1
 5c0:	fef40593          	addi	a1,s0,-17
 5c4:	f25ff0ef          	jal	4e8 <write>
}
 5c8:	01813083          	ld	ra,24(sp)
 5cc:	01013403          	ld	s0,16(sp)
 5d0:	02010113          	addi	sp,sp,32
 5d4:	00008067          	ret

00000000000005d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d8:	fc010113          	addi	sp,sp,-64
 5dc:	02113c23          	sd	ra,56(sp)
 5e0:	02813823          	sd	s0,48(sp)
 5e4:	02913423          	sd	s1,40(sp)
 5e8:	04010413          	addi	s0,sp,64
 5ec:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5f0:	00068463          	beqz	a3,5f8 <printint+0x20>
 5f4:	0c05c263          	bltz	a1,6b8 <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5f8:	0005859b          	sext.w	a1,a1
  neg = 0;
 5fc:	00000893          	li	a7,0
 600:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 604:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 608:	0006061b          	sext.w	a2,a2
 60c:	00000517          	auipc	a0,0x0
 610:	78450513          	addi	a0,a0,1924 # d90 <digits>
 614:	00070813          	mv	a6,a4
 618:	0017071b          	addiw	a4,a4,1
 61c:	02c5f7bb          	remuw	a5,a1,a2
 620:	02079793          	slli	a5,a5,0x20
 624:	0207d793          	srli	a5,a5,0x20
 628:	00f507b3          	add	a5,a0,a5
 62c:	0007c783          	lbu	a5,0(a5)
 630:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 634:	0005879b          	sext.w	a5,a1
 638:	02c5d5bb          	divuw	a1,a1,a2
 63c:	00168693          	addi	a3,a3,1
 640:	fcc7fae3          	bgeu	a5,a2,614 <printint+0x3c>
  if(neg)
 644:	00088c63          	beqz	a7,65c <printint+0x84>
    buf[i++] = '-';
 648:	fd070793          	addi	a5,a4,-48
 64c:	00878733          	add	a4,a5,s0
 650:	02d00793          	li	a5,45
 654:	fef70823          	sb	a5,-16(a4)
 658:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 65c:	04e05463          	blez	a4,6a4 <printint+0xcc>
 660:	03213023          	sd	s2,32(sp)
 664:	01313c23          	sd	s3,24(sp)
 668:	fc040793          	addi	a5,s0,-64
 66c:	00e78933          	add	s2,a5,a4
 670:	fff78993          	addi	s3,a5,-1
 674:	00e989b3          	add	s3,s3,a4
 678:	fff7071b          	addiw	a4,a4,-1
 67c:	02071713          	slli	a4,a4,0x20
 680:	02075713          	srli	a4,a4,0x20
 684:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 688:	fff94583          	lbu	a1,-1(s2)
 68c:	00048513          	mv	a0,s1
 690:	f19ff0ef          	jal	5a8 <putc>
  while(--i >= 0)
 694:	fff90913          	addi	s2,s2,-1
 698:	ff3918e3          	bne	s2,s3,688 <printint+0xb0>
 69c:	02013903          	ld	s2,32(sp)
 6a0:	01813983          	ld	s3,24(sp)
}
 6a4:	03813083          	ld	ra,56(sp)
 6a8:	03013403          	ld	s0,48(sp)
 6ac:	02813483          	ld	s1,40(sp)
 6b0:	04010113          	addi	sp,sp,64
 6b4:	00008067          	ret
    x = -xx;
 6b8:	40b005bb          	negw	a1,a1
    neg = 1;
 6bc:	00100893          	li	a7,1
    x = -xx;
 6c0:	f41ff06f          	j	600 <printint+0x28>

00000000000006c4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6c4:	fa010113          	addi	sp,sp,-96
 6c8:	04113c23          	sd	ra,88(sp)
 6cc:	04813823          	sd	s0,80(sp)
 6d0:	05213023          	sd	s2,64(sp)
 6d4:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6d8:	0005c903          	lbu	s2,0(a1)
 6dc:	36090463          	beqz	s2,a44 <vprintf+0x380>
 6e0:	04913423          	sd	s1,72(sp)
 6e4:	03313c23          	sd	s3,56(sp)
 6e8:	03413823          	sd	s4,48(sp)
 6ec:	03513423          	sd	s5,40(sp)
 6f0:	03613023          	sd	s6,32(sp)
 6f4:	01713c23          	sd	s7,24(sp)
 6f8:	01813823          	sd	s8,16(sp)
 6fc:	01913423          	sd	s9,8(sp)
 700:	00050b13          	mv	s6,a0
 704:	00058a13          	mv	s4,a1
 708:	00060b93          	mv	s7,a2
  state = 0;
 70c:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
 710:	00000493          	li	s1,0
 714:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 718:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 71c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 720:	06c00c93          	li	s9,108
 724:	02c0006f          	j	750 <vprintf+0x8c>
        putc(fd, c0);
 728:	00090593          	mv	a1,s2
 72c:	000b0513          	mv	a0,s6
 730:	e79ff0ef          	jal	5a8 <putc>
 734:	0080006f          	j	73c <vprintf+0x78>
    } else if(state == '%'){
 738:	03598663          	beq	s3,s5,764 <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
 73c:	0014849b          	addiw	s1,s1,1
 740:	00048713          	mv	a4,s1
 744:	009a07b3          	add	a5,s4,s1
 748:	0007c903          	lbu	s2,0(a5)
 74c:	2c090c63          	beqz	s2,a24 <vprintf+0x360>
    c0 = fmt[i] & 0xff;
 750:	0009079b          	sext.w	a5,s2
    if(state == 0){
 754:	fe0992e3          	bnez	s3,738 <vprintf+0x74>
      if(c0 == '%'){
 758:	fd5798e3          	bne	a5,s5,728 <vprintf+0x64>
        state = '%';
 75c:	00078993          	mv	s3,a5
 760:	fddff06f          	j	73c <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
 764:	00ea06b3          	add	a3,s4,a4
 768:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 76c:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 770:	00068663          	beqz	a3,77c <vprintf+0xb8>
 774:	00ea0733          	add	a4,s4,a4
 778:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 77c:	05878263          	beq	a5,s8,7c0 <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
 780:	07978263          	beq	a5,s9,7e4 <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 784:	07500713          	li	a4,117
 788:	12e78663          	beq	a5,a4,8b4 <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 78c:	07800713          	li	a4,120
 790:	18e78c63          	beq	a5,a4,928 <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 794:	07000713          	li	a4,112
 798:	1ce78e63          	beq	a5,a4,974 <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 79c:	07300713          	li	a4,115
 7a0:	22e78a63          	beq	a5,a4,9d4 <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 7a4:	02500713          	li	a4,37
 7a8:	04e79e63          	bne	a5,a4,804 <vprintf+0x140>
        putc(fd, '%');
 7ac:	02500593          	li	a1,37
 7b0:	000b0513          	mv	a0,s6
 7b4:	df5ff0ef          	jal	5a8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 7b8:	00000993          	li	s3,0
 7bc:	f81ff06f          	j	73c <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
 7c0:	008b8913          	addi	s2,s7,8
 7c4:	00100693          	li	a3,1
 7c8:	00a00613          	li	a2,10
 7cc:	000ba583          	lw	a1,0(s7)
 7d0:	000b0513          	mv	a0,s6
 7d4:	e05ff0ef          	jal	5d8 <printint>
 7d8:	00090b93          	mv	s7,s2
      state = 0;
 7dc:	00000993          	li	s3,0
 7e0:	f5dff06f          	j	73c <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
 7e4:	06400793          	li	a5,100
 7e8:	02f68e63          	beq	a3,a5,824 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7ec:	06c00793          	li	a5,108
 7f0:	04f68e63          	beq	a3,a5,84c <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
 7f4:	07500793          	li	a5,117
 7f8:	0ef68063          	beq	a3,a5,8d8 <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
 7fc:	07800793          	li	a5,120
 800:	14f68663          	beq	a3,a5,94c <vprintf+0x288>
        putc(fd, '%');
 804:	02500593          	li	a1,37
 808:	000b0513          	mv	a0,s6
 80c:	d9dff0ef          	jal	5a8 <putc>
        putc(fd, c0);
 810:	00090593          	mv	a1,s2
 814:	000b0513          	mv	a0,s6
 818:	d91ff0ef          	jal	5a8 <putc>
      state = 0;
 81c:	00000993          	li	s3,0
 820:	f1dff06f          	j	73c <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 824:	008b8913          	addi	s2,s7,8
 828:	00100693          	li	a3,1
 82c:	00a00613          	li	a2,10
 830:	000ba583          	lw	a1,0(s7)
 834:	000b0513          	mv	a0,s6
 838:	da1ff0ef          	jal	5d8 <printint>
        i += 1;
 83c:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 840:	00090b93          	mv	s7,s2
      state = 0;
 844:	00000993          	li	s3,0
        i += 1;
 848:	ef5ff06f          	j	73c <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 84c:	06400793          	li	a5,100
 850:	02f60e63          	beq	a2,a5,88c <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 854:	07500793          	li	a5,117
 858:	0af60463          	beq	a2,a5,900 <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 85c:	07800793          	li	a5,120
 860:	faf612e3          	bne	a2,a5,804 <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
 864:	008b8913          	addi	s2,s7,8
 868:	00000693          	li	a3,0
 86c:	01000613          	li	a2,16
 870:	000ba583          	lw	a1,0(s7)
 874:	000b0513          	mv	a0,s6
 878:	d61ff0ef          	jal	5d8 <printint>
        i += 2;
 87c:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 880:	00090b93          	mv	s7,s2
      state = 0;
 884:	00000993          	li	s3,0
        i += 2;
 888:	eb5ff06f          	j	73c <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 88c:	008b8913          	addi	s2,s7,8
 890:	00100693          	li	a3,1
 894:	00a00613          	li	a2,10
 898:	000ba583          	lw	a1,0(s7)
 89c:	000b0513          	mv	a0,s6
 8a0:	d39ff0ef          	jal	5d8 <printint>
        i += 2;
 8a4:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 8a8:	00090b93          	mv	s7,s2
      state = 0;
 8ac:	00000993          	li	s3,0
        i += 2;
 8b0:	e8dff06f          	j	73c <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
 8b4:	008b8913          	addi	s2,s7,8
 8b8:	00000693          	li	a3,0
 8bc:	00a00613          	li	a2,10
 8c0:	000ba583          	lw	a1,0(s7)
 8c4:	000b0513          	mv	a0,s6
 8c8:	d11ff0ef          	jal	5d8 <printint>
 8cc:	00090b93          	mv	s7,s2
      state = 0;
 8d0:	00000993          	li	s3,0
 8d4:	e69ff06f          	j	73c <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8d8:	008b8913          	addi	s2,s7,8
 8dc:	00000693          	li	a3,0
 8e0:	00a00613          	li	a2,10
 8e4:	000ba583          	lw	a1,0(s7)
 8e8:	000b0513          	mv	a0,s6
 8ec:	cedff0ef          	jal	5d8 <printint>
        i += 1;
 8f0:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8f4:	00090b93          	mv	s7,s2
      state = 0;
 8f8:	00000993          	li	s3,0
        i += 1;
 8fc:	e41ff06f          	j	73c <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 900:	008b8913          	addi	s2,s7,8
 904:	00000693          	li	a3,0
 908:	00a00613          	li	a2,10
 90c:	000ba583          	lw	a1,0(s7)
 910:	000b0513          	mv	a0,s6
 914:	cc5ff0ef          	jal	5d8 <printint>
        i += 2;
 918:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 91c:	00090b93          	mv	s7,s2
      state = 0;
 920:	00000993          	li	s3,0
        i += 2;
 924:	e19ff06f          	j	73c <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
 928:	008b8913          	addi	s2,s7,8
 92c:	00000693          	li	a3,0
 930:	01000613          	li	a2,16
 934:	000ba583          	lw	a1,0(s7)
 938:	000b0513          	mv	a0,s6
 93c:	c9dff0ef          	jal	5d8 <printint>
 940:	00090b93          	mv	s7,s2
      state = 0;
 944:	00000993          	li	s3,0
 948:	df5ff06f          	j	73c <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
 94c:	008b8913          	addi	s2,s7,8
 950:	00000693          	li	a3,0
 954:	01000613          	li	a2,16
 958:	000ba583          	lw	a1,0(s7)
 95c:	000b0513          	mv	a0,s6
 960:	c79ff0ef          	jal	5d8 <printint>
        i += 1;
 964:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 968:	00090b93          	mv	s7,s2
      state = 0;
 96c:	00000993          	li	s3,0
        i += 1;
 970:	dcdff06f          	j	73c <vprintf+0x78>
 974:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 978:	008b8d13          	addi	s10,s7,8
 97c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 980:	03000593          	li	a1,48
 984:	000b0513          	mv	a0,s6
 988:	c21ff0ef          	jal	5a8 <putc>
  putc(fd, 'x');
 98c:	07800593          	li	a1,120
 990:	000b0513          	mv	a0,s6
 994:	c15ff0ef          	jal	5a8 <putc>
 998:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 99c:	00000b97          	auipc	s7,0x0
 9a0:	3f4b8b93          	addi	s7,s7,1012 # d90 <digits>
 9a4:	03c9d793          	srli	a5,s3,0x3c
 9a8:	00fb87b3          	add	a5,s7,a5
 9ac:	0007c583          	lbu	a1,0(a5)
 9b0:	000b0513          	mv	a0,s6
 9b4:	bf5ff0ef          	jal	5a8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9b8:	00499993          	slli	s3,s3,0x4
 9bc:	fff9091b          	addiw	s2,s2,-1
 9c0:	fe0912e3          	bnez	s2,9a4 <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
 9c4:	000d0b93          	mv	s7,s10
      state = 0;
 9c8:	00000993          	li	s3,0
 9cc:	00013d03          	ld	s10,0(sp)
 9d0:	d6dff06f          	j	73c <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
 9d4:	008b8993          	addi	s3,s7,8
 9d8:	000bb903          	ld	s2,0(s7)
 9dc:	02090663          	beqz	s2,a08 <vprintf+0x344>
        for(; *s; s++)
 9e0:	00094583          	lbu	a1,0(s2)
 9e4:	02058a63          	beqz	a1,a18 <vprintf+0x354>
          putc(fd, *s);
 9e8:	000b0513          	mv	a0,s6
 9ec:	bbdff0ef          	jal	5a8 <putc>
        for(; *s; s++)
 9f0:	00190913          	addi	s2,s2,1
 9f4:	00094583          	lbu	a1,0(s2)
 9f8:	fe0598e3          	bnez	a1,9e8 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 9fc:	00098b93          	mv	s7,s3
      state = 0;
 a00:	00000993          	li	s3,0
 a04:	d39ff06f          	j	73c <vprintf+0x78>
          s = "(null)";
 a08:	00000917          	auipc	s2,0x0
 a0c:	38090913          	addi	s2,s2,896 # d88 <malloc+0x1ec>
        for(; *s; s++)
 a10:	02800593          	li	a1,40
 a14:	fd5ff06f          	j	9e8 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 a18:	00098b93          	mv	s7,s3
      state = 0;
 a1c:	00000993          	li	s3,0
 a20:	d1dff06f          	j	73c <vprintf+0x78>
 a24:	04813483          	ld	s1,72(sp)
 a28:	03813983          	ld	s3,56(sp)
 a2c:	03013a03          	ld	s4,48(sp)
 a30:	02813a83          	ld	s5,40(sp)
 a34:	02013b03          	ld	s6,32(sp)
 a38:	01813b83          	ld	s7,24(sp)
 a3c:	01013c03          	ld	s8,16(sp)
 a40:	00813c83          	ld	s9,8(sp)
    }
  }
}
 a44:	05813083          	ld	ra,88(sp)
 a48:	05013403          	ld	s0,80(sp)
 a4c:	04013903          	ld	s2,64(sp)
 a50:	06010113          	addi	sp,sp,96
 a54:	00008067          	ret

0000000000000a58 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a58:	fb010113          	addi	sp,sp,-80
 a5c:	00113c23          	sd	ra,24(sp)
 a60:	00813823          	sd	s0,16(sp)
 a64:	02010413          	addi	s0,sp,32
 a68:	00c43023          	sd	a2,0(s0)
 a6c:	00d43423          	sd	a3,8(s0)
 a70:	00e43823          	sd	a4,16(s0)
 a74:	00f43c23          	sd	a5,24(s0)
 a78:	03043023          	sd	a6,32(s0)
 a7c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a80:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a84:	00040613          	mv	a2,s0
 a88:	c3dff0ef          	jal	6c4 <vprintf>
}
 a8c:	01813083          	ld	ra,24(sp)
 a90:	01013403          	ld	s0,16(sp)
 a94:	05010113          	addi	sp,sp,80
 a98:	00008067          	ret

0000000000000a9c <printf>:

void
printf(const char *fmt, ...)
{
 a9c:	fa010113          	addi	sp,sp,-96
 aa0:	00113c23          	sd	ra,24(sp)
 aa4:	00813823          	sd	s0,16(sp)
 aa8:	02010413          	addi	s0,sp,32
 aac:	00b43423          	sd	a1,8(s0)
 ab0:	00c43823          	sd	a2,16(s0)
 ab4:	00d43c23          	sd	a3,24(s0)
 ab8:	02e43023          	sd	a4,32(s0)
 abc:	02f43423          	sd	a5,40(s0)
 ac0:	03043823          	sd	a6,48(s0)
 ac4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ac8:	00840613          	addi	a2,s0,8
 acc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ad0:	00050593          	mv	a1,a0
 ad4:	00100513          	li	a0,1
 ad8:	bedff0ef          	jal	6c4 <vprintf>
}
 adc:	01813083          	ld	ra,24(sp)
 ae0:	01013403          	ld	s0,16(sp)
 ae4:	06010113          	addi	sp,sp,96
 ae8:	00008067          	ret

0000000000000aec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 aec:	ff010113          	addi	sp,sp,-16
 af0:	00813423          	sd	s0,8(sp)
 af4:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 af8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 afc:	00000797          	auipc	a5,0x0
 b00:	5147b783          	ld	a5,1300(a5) # 1010 <freep>
 b04:	0400006f          	j	b44 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b08:	00862703          	lw	a4,8(a2)
 b0c:	00b7073b          	addw	a4,a4,a1
 b10:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b14:	0007b703          	ld	a4,0(a5)
 b18:	00073603          	ld	a2,0(a4)
 b1c:	0500006f          	j	b6c <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b20:	ff852703          	lw	a4,-8(a0)
 b24:	00c7073b          	addw	a4,a4,a2
 b28:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b2c:	ff053683          	ld	a3,-16(a0)
 b30:	0540006f          	j	b84 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b34:	0007b703          	ld	a4,0(a5)
 b38:	00e7e463          	bltu	a5,a4,b40 <free+0x54>
 b3c:	00e6ec63          	bltu	a3,a4,b54 <free+0x68>
{
 b40:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b44:	fed7f8e3          	bgeu	a5,a3,b34 <free+0x48>
 b48:	0007b703          	ld	a4,0(a5)
 b4c:	00e6e463          	bltu	a3,a4,b54 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b50:	fee7e8e3          	bltu	a5,a4,b40 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 b54:	ff852583          	lw	a1,-8(a0)
 b58:	0007b603          	ld	a2,0(a5)
 b5c:	02059813          	slli	a6,a1,0x20
 b60:	01c85713          	srli	a4,a6,0x1c
 b64:	00e68733          	add	a4,a3,a4
 b68:	fae600e3          	beq	a2,a4,b08 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 b6c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b70:	0087a603          	lw	a2,8(a5)
 b74:	02061593          	slli	a1,a2,0x20
 b78:	01c5d713          	srli	a4,a1,0x1c
 b7c:	00e78733          	add	a4,a5,a4
 b80:	fae680e3          	beq	a3,a4,b20 <free+0x34>
    p->s.ptr = bp->s.ptr;
 b84:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b88:	00000717          	auipc	a4,0x0
 b8c:	48f73423          	sd	a5,1160(a4) # 1010 <freep>
}
 b90:	00813403          	ld	s0,8(sp)
 b94:	01010113          	addi	sp,sp,16
 b98:	00008067          	ret

0000000000000b9c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b9c:	fc010113          	addi	sp,sp,-64
 ba0:	02113c23          	sd	ra,56(sp)
 ba4:	02813823          	sd	s0,48(sp)
 ba8:	02913423          	sd	s1,40(sp)
 bac:	01313c23          	sd	s3,24(sp)
 bb0:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bb4:	02051493          	slli	s1,a0,0x20
 bb8:	0204d493          	srli	s1,s1,0x20
 bbc:	00f48493          	addi	s1,s1,15
 bc0:	0044d493          	srli	s1,s1,0x4
 bc4:	0014899b          	addiw	s3,s1,1
 bc8:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
 bcc:	00000517          	auipc	a0,0x0
 bd0:	44453503          	ld	a0,1092(a0) # 1010 <freep>
 bd4:	04050663          	beqz	a0,c20 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd8:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bdc:	0087a703          	lw	a4,8(a5)
 be0:	0c977c63          	bgeu	a4,s1,cb8 <malloc+0x11c>
 be4:	03213023          	sd	s2,32(sp)
 be8:	01413823          	sd	s4,16(sp)
 bec:	01513423          	sd	s5,8(sp)
 bf0:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
 bf4:	00098a13          	mv	s4,s3
 bf8:	0009871b          	sext.w	a4,s3
 bfc:	000016b7          	lui	a3,0x1
 c00:	00d77463          	bgeu	a4,a3,c08 <malloc+0x6c>
 c04:	00001a37          	lui	s4,0x1
 c08:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c0c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c10:	00000917          	auipc	s2,0x0
 c14:	40090913          	addi	s2,s2,1024 # 1010 <freep>
  if(p == (char*)-1)
 c18:	fff00a93          	li	s5,-1
 c1c:	05c0006f          	j	c78 <malloc+0xdc>
 c20:	03213023          	sd	s2,32(sp)
 c24:	01413823          	sd	s4,16(sp)
 c28:	01513423          	sd	s5,8(sp)
 c2c:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c30:	00000797          	auipc	a5,0x0
 c34:	3f078793          	addi	a5,a5,1008 # 1020 <base>
 c38:	00000717          	auipc	a4,0x0
 c3c:	3cf73c23          	sd	a5,984(a4) # 1010 <freep>
 c40:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 c44:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c48:	fadff06f          	j	bf4 <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
 c4c:	0007b703          	ld	a4,0(a5)
 c50:	00e53023          	sd	a4,0(a0)
 c54:	0800006f          	j	cd4 <malloc+0x138>
  hp->s.size = nu;
 c58:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c5c:	01050513          	addi	a0,a0,16
 c60:	e8dff0ef          	jal	aec <free>
  return freep;
 c64:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c68:	08050863          	beqz	a0,cf8 <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c6c:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c70:	0087a703          	lw	a4,8(a5)
 c74:	02977a63          	bgeu	a4,s1,ca8 <malloc+0x10c>
    if(p == freep)
 c78:	00093703          	ld	a4,0(s2)
 c7c:	00078513          	mv	a0,a5
 c80:	fef716e3          	bne	a4,a5,c6c <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
 c84:	000a0513          	mv	a0,s4
 c88:	8fdff0ef          	jal	584 <sbrk>
  if(p == (char*)-1)
 c8c:	fd5516e3          	bne	a0,s5,c58 <malloc+0xbc>
        return 0;
 c90:	00000513          	li	a0,0
 c94:	02013903          	ld	s2,32(sp)
 c98:	01013a03          	ld	s4,16(sp)
 c9c:	00813a83          	ld	s5,8(sp)
 ca0:	00013b03          	ld	s6,0(sp)
 ca4:	03c0006f          	j	ce0 <malloc+0x144>
 ca8:	02013903          	ld	s2,32(sp)
 cac:	01013a03          	ld	s4,16(sp)
 cb0:	00813a83          	ld	s5,8(sp)
 cb4:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
 cb8:	f8e48ae3          	beq	s1,a4,c4c <malloc+0xb0>
        p->s.size -= nunits;
 cbc:	4137073b          	subw	a4,a4,s3
 cc0:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 cc4:	02071693          	slli	a3,a4,0x20
 cc8:	01c6d713          	srli	a4,a3,0x1c
 ccc:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 cd0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 cd4:	00000717          	auipc	a4,0x0
 cd8:	32a73e23          	sd	a0,828(a4) # 1010 <freep>
      return (void*)(p + 1);
 cdc:	01078513          	addi	a0,a5,16
  }
}
 ce0:	03813083          	ld	ra,56(sp)
 ce4:	03013403          	ld	s0,48(sp)
 ce8:	02813483          	ld	s1,40(sp)
 cec:	01813983          	ld	s3,24(sp)
 cf0:	04010113          	addi	sp,sp,64
 cf4:	00008067          	ret
 cf8:	02013903          	ld	s2,32(sp)
 cfc:	01013a03          	ld	s4,16(sp)
 d00:	00813a83          	ld	s5,8(sp)
 d04:	00013b03          	ld	s6,0(sp)
 d08:	fd9ff06f          	j	ce0 <malloc+0x144>
