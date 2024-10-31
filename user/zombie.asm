
user/_zombie:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	ff010113          	addi	sp,sp,-16
   4:	00113423          	sd	ra,8(sp)
   8:	00813023          	sd	s0,0(sp)
   c:	01010413          	addi	s0,sp,16
  if(fork() > 0)
  10:	3e4000ef          	jal	3f4 <fork>
  14:	00a04663          	bgtz	a0,20 <main+0x20>
    sleep(5);  // Let child exit before parent.
  exit(0);
  18:	00000513          	li	a0,0
  1c:	3e4000ef          	jal	400 <exit>
    sleep(5);  // Let child exit before parent.
  20:	00500513          	li	a0,5
  24:	4b4000ef          	jal	4d8 <sleep>
  28:	ff1ff06f          	j	18 <main+0x18>

000000000000002c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  2c:	ff010113          	addi	sp,sp,-16
  30:	00113423          	sd	ra,8(sp)
  34:	00813023          	sd	s0,0(sp)
  38:	01010413          	addi	s0,sp,16
  extern int main();
  main();
  3c:	fc5ff0ef          	jal	0 <main>
  exit(0);
  40:	00000513          	li	a0,0
  44:	3bc000ef          	jal	400 <exit>

0000000000000048 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  48:	ff010113          	addi	sp,sp,-16
  4c:	00813423          	sd	s0,8(sp)
  50:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  54:	00050793          	mv	a5,a0
  58:	00158593          	addi	a1,a1,1
  5c:	00178793          	addi	a5,a5,1
  60:	fff5c703          	lbu	a4,-1(a1)
  64:	fee78fa3          	sb	a4,-1(a5)
  68:	fe0718e3          	bnez	a4,58 <strcpy+0x10>
    ;
  return os;
}
  6c:	00813403          	ld	s0,8(sp)
  70:	01010113          	addi	sp,sp,16
  74:	00008067          	ret

0000000000000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	ff010113          	addi	sp,sp,-16
  7c:	00813423          	sd	s0,8(sp)
  80:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
  84:	00054783          	lbu	a5,0(a0)
  88:	00078e63          	beqz	a5,a4 <strcmp+0x2c>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71a63          	bne	a4,a5,a4 <strcmp+0x2c>
    p++, q++;
  94:	00150513          	addi	a0,a0,1
  98:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
  9c:	00054783          	lbu	a5,0(a0)
  a0:	fe0796e3          	bnez	a5,8c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  a4:	0005c503          	lbu	a0,0(a1)
}
  a8:	40a7853b          	subw	a0,a5,a0
  ac:	00813403          	ld	s0,8(sp)
  b0:	01010113          	addi	sp,sp,16
  b4:	00008067          	ret

00000000000000b8 <strlen>:

uint
strlen(const char *s)
{
  b8:	ff010113          	addi	sp,sp,-16
  bc:	00813423          	sd	s0,8(sp)
  c0:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	02078863          	beqz	a5,f8 <strlen+0x40>
  cc:	00150513          	addi	a0,a0,1
  d0:	00050793          	mv	a5,a0
  d4:	00078693          	mv	a3,a5
  d8:	00178793          	addi	a5,a5,1
  dc:	fff7c703          	lbu	a4,-1(a5)
  e0:	fe071ae3          	bnez	a4,d4 <strlen+0x1c>
  e4:	40a6853b          	subw	a0,a3,a0
  e8:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
  ec:	00813403          	ld	s0,8(sp)
  f0:	01010113          	addi	sp,sp,16
  f4:	00008067          	ret
  for(n = 0; s[n]; n++)
  f8:	00000513          	li	a0,0
  fc:	ff1ff06f          	j	ec <strlen+0x34>

0000000000000100 <memset>:

void*
memset(void *dst, int c, uint n)
{
 100:	ff010113          	addi	sp,sp,-16
 104:	00813423          	sd	s0,8(sp)
 108:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 10c:	02060063          	beqz	a2,12c <memset+0x2c>
 110:	00050793          	mv	a5,a0
 114:	02061613          	slli	a2,a2,0x20
 118:	02065613          	srli	a2,a2,0x20
 11c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 120:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 124:	00178793          	addi	a5,a5,1
 128:	fee79ce3          	bne	a5,a4,120 <memset+0x20>
  }
  return dst;
}
 12c:	00813403          	ld	s0,8(sp)
 130:	01010113          	addi	sp,sp,16
 134:	00008067          	ret

0000000000000138 <strchr>:

char*
strchr(const char *s, char c)
{
 138:	ff010113          	addi	sp,sp,-16
 13c:	00813423          	sd	s0,8(sp)
 140:	01010413          	addi	s0,sp,16
  for(; *s; s++)
 144:	00054783          	lbu	a5,0(a0)
 148:	02078263          	beqz	a5,16c <strchr+0x34>
    if(*s == c)
 14c:	00f58a63          	beq	a1,a5,160 <strchr+0x28>
  for(; *s; s++)
 150:	00150513          	addi	a0,a0,1
 154:	00054783          	lbu	a5,0(a0)
 158:	fe079ae3          	bnez	a5,14c <strchr+0x14>
      return (char*)s;
  return 0;
 15c:	00000513          	li	a0,0
}
 160:	00813403          	ld	s0,8(sp)
 164:	01010113          	addi	sp,sp,16
 168:	00008067          	ret
  return 0;
 16c:	00000513          	li	a0,0
 170:	ff1ff06f          	j	160 <strchr+0x28>

0000000000000174 <gets>:

char*
gets(char *buf, int max)
{
 174:	fa010113          	addi	sp,sp,-96
 178:	04113c23          	sd	ra,88(sp)
 17c:	04813823          	sd	s0,80(sp)
 180:	04913423          	sd	s1,72(sp)
 184:	05213023          	sd	s2,64(sp)
 188:	03313c23          	sd	s3,56(sp)
 18c:	03413823          	sd	s4,48(sp)
 190:	03513423          	sd	s5,40(sp)
 194:	03613023          	sd	s6,32(sp)
 198:	01713c23          	sd	s7,24(sp)
 19c:	06010413          	addi	s0,sp,96
 1a0:	00050b93          	mv	s7,a0
 1a4:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a8:	00050913          	mv	s2,a0
 1ac:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1b0:	00a00a93          	li	s5,10
 1b4:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 1b8:	00048993          	mv	s3,s1
 1bc:	0014849b          	addiw	s1,s1,1
 1c0:	0344dc63          	bge	s1,s4,1f8 <gets+0x84>
    cc = read(0, &c, 1);
 1c4:	00100613          	li	a2,1
 1c8:	faf40593          	addi	a1,s0,-81
 1cc:	00000513          	li	a0,0
 1d0:	254000ef          	jal	424 <read>
    if(cc < 1)
 1d4:	02a05263          	blez	a0,1f8 <gets+0x84>
    buf[i++] = c;
 1d8:	faf44783          	lbu	a5,-81(s0)
 1dc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e0:	01578a63          	beq	a5,s5,1f4 <gets+0x80>
 1e4:	00190913          	addi	s2,s2,1
 1e8:	fd6798e3          	bne	a5,s6,1b8 <gets+0x44>
    buf[i++] = c;
 1ec:	00048993          	mv	s3,s1
 1f0:	0080006f          	j	1f8 <gets+0x84>
 1f4:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1f8:	013b89b3          	add	s3,s7,s3
 1fc:	00098023          	sb	zero,0(s3)
  return buf;
}
 200:	000b8513          	mv	a0,s7
 204:	05813083          	ld	ra,88(sp)
 208:	05013403          	ld	s0,80(sp)
 20c:	04813483          	ld	s1,72(sp)
 210:	04013903          	ld	s2,64(sp)
 214:	03813983          	ld	s3,56(sp)
 218:	03013a03          	ld	s4,48(sp)
 21c:	02813a83          	ld	s5,40(sp)
 220:	02013b03          	ld	s6,32(sp)
 224:	01813b83          	ld	s7,24(sp)
 228:	06010113          	addi	sp,sp,96
 22c:	00008067          	ret

0000000000000230 <stat>:

int
stat(const char *n, struct stat *st)
{
 230:	fe010113          	addi	sp,sp,-32
 234:	00113c23          	sd	ra,24(sp)
 238:	00813823          	sd	s0,16(sp)
 23c:	01213023          	sd	s2,0(sp)
 240:	02010413          	addi	s0,sp,32
 244:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 248:	00000593          	li	a1,0
 24c:	214000ef          	jal	460 <open>
  if(fd < 0)
 250:	02054e63          	bltz	a0,28c <stat+0x5c>
 254:	00913423          	sd	s1,8(sp)
 258:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25c:	00090593          	mv	a1,s2
 260:	224000ef          	jal	484 <fstat>
 264:	00050913          	mv	s2,a0
  close(fd);
 268:	00048513          	mv	a0,s1
 26c:	1d0000ef          	jal	43c <close>
  return r;
 270:	00813483          	ld	s1,8(sp)
}
 274:	00090513          	mv	a0,s2
 278:	01813083          	ld	ra,24(sp)
 27c:	01013403          	ld	s0,16(sp)
 280:	00013903          	ld	s2,0(sp)
 284:	02010113          	addi	sp,sp,32
 288:	00008067          	ret
    return -1;
 28c:	fff00913          	li	s2,-1
 290:	fe5ff06f          	j	274 <stat+0x44>

0000000000000294 <atoi>:

int
atoi(const char *s)
{
 294:	ff010113          	addi	sp,sp,-16
 298:	00813423          	sd	s0,8(sp)
 29c:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a0:	00054683          	lbu	a3,0(a0)
 2a4:	fd06879b          	addiw	a5,a3,-48
 2a8:	0ff7f793          	zext.b	a5,a5
 2ac:	00900613          	li	a2,9
 2b0:	04f66063          	bltu	a2,a5,2f0 <atoi+0x5c>
 2b4:	00050713          	mv	a4,a0
  n = 0;
 2b8:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 2bc:	00170713          	addi	a4,a4,1
 2c0:	0025179b          	slliw	a5,a0,0x2
 2c4:	00a787bb          	addw	a5,a5,a0
 2c8:	0017979b          	slliw	a5,a5,0x1
 2cc:	00d787bb          	addw	a5,a5,a3
 2d0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2d4:	00074683          	lbu	a3,0(a4)
 2d8:	fd06879b          	addiw	a5,a3,-48
 2dc:	0ff7f793          	zext.b	a5,a5
 2e0:	fcf67ee3          	bgeu	a2,a5,2bc <atoi+0x28>
  return n;
}
 2e4:	00813403          	ld	s0,8(sp)
 2e8:	01010113          	addi	sp,sp,16
 2ec:	00008067          	ret
  n = 0;
 2f0:	00000513          	li	a0,0
 2f4:	ff1ff06f          	j	2e4 <atoi+0x50>

00000000000002f8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f8:	ff010113          	addi	sp,sp,-16
 2fc:	00813423          	sd	s0,8(sp)
 300:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 304:	02b57c63          	bgeu	a0,a1,33c <memmove+0x44>
    while(n-- > 0)
 308:	02c05463          	blez	a2,330 <memmove+0x38>
 30c:	02061613          	slli	a2,a2,0x20
 310:	02065613          	srli	a2,a2,0x20
 314:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 318:	00050713          	mv	a4,a0
      *dst++ = *src++;
 31c:	00158593          	addi	a1,a1,1
 320:	00170713          	addi	a4,a4,1
 324:	fff5c683          	lbu	a3,-1(a1)
 328:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 32c:	fef718e3          	bne	a4,a5,31c <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 330:	00813403          	ld	s0,8(sp)
 334:	01010113          	addi	sp,sp,16
 338:	00008067          	ret
    dst += n;
 33c:	00c50733          	add	a4,a0,a2
    src += n;
 340:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 344:	fec056e3          	blez	a2,330 <memmove+0x38>
 348:	fff6079b          	addiw	a5,a2,-1
 34c:	02079793          	slli	a5,a5,0x20
 350:	0207d793          	srli	a5,a5,0x20
 354:	fff7c793          	not	a5,a5
 358:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 35c:	fff58593          	addi	a1,a1,-1
 360:	fff70713          	addi	a4,a4,-1
 364:	0005c683          	lbu	a3,0(a1)
 368:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 36c:	fee798e3          	bne	a5,a4,35c <memmove+0x64>
 370:	fc1ff06f          	j	330 <memmove+0x38>

0000000000000374 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 374:	ff010113          	addi	sp,sp,-16
 378:	00813423          	sd	s0,8(sp)
 37c:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 380:	04060463          	beqz	a2,3c8 <memcmp+0x54>
 384:	fff6069b          	addiw	a3,a2,-1
 388:	02069693          	slli	a3,a3,0x20
 38c:	0206d693          	srli	a3,a3,0x20
 390:	00168693          	addi	a3,a3,1
 394:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 398:	00054783          	lbu	a5,0(a0)
 39c:	0005c703          	lbu	a4,0(a1)
 3a0:	00e79c63          	bne	a5,a4,3b8 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 3a4:	00150513          	addi	a0,a0,1
    p2++;
 3a8:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
 3ac:	fed516e3          	bne	a0,a3,398 <memcmp+0x24>
  }
  return 0;
 3b0:	00000513          	li	a0,0
 3b4:	0080006f          	j	3bc <memcmp+0x48>
      return *p1 - *p2;
 3b8:	40e7853b          	subw	a0,a5,a4
}
 3bc:	00813403          	ld	s0,8(sp)
 3c0:	01010113          	addi	sp,sp,16
 3c4:	00008067          	ret
  return 0;
 3c8:	00000513          	li	a0,0
 3cc:	ff1ff06f          	j	3bc <memcmp+0x48>

00000000000003d0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3d0:	ff010113          	addi	sp,sp,-16
 3d4:	00113423          	sd	ra,8(sp)
 3d8:	00813023          	sd	s0,0(sp)
 3dc:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
 3e0:	f19ff0ef          	jal	2f8 <memmove>
}
 3e4:	00813083          	ld	ra,8(sp)
 3e8:	00013403          	ld	s0,0(sp)
 3ec:	01010113          	addi	sp,sp,16
 3f0:	00008067          	ret

00000000000003f4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f4:	00100893          	li	a7,1
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	00008067          	ret

0000000000000400 <exit>:
.global exit
exit:
 li a7, SYS_exit
 400:	00200893          	li	a7,2
 ecall
 404:	00000073          	ecall
 ret
 408:	00008067          	ret

000000000000040c <wait>:
.global wait
wait:
 li a7, SYS_wait
 40c:	00300893          	li	a7,3
 ecall
 410:	00000073          	ecall
 ret
 414:	00008067          	ret

0000000000000418 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 418:	00400893          	li	a7,4
 ecall
 41c:	00000073          	ecall
 ret
 420:	00008067          	ret

0000000000000424 <read>:
.global read
read:
 li a7, SYS_read
 424:	00500893          	li	a7,5
 ecall
 428:	00000073          	ecall
 ret
 42c:	00008067          	ret

0000000000000430 <write>:
.global write
write:
 li a7, SYS_write
 430:	01000893          	li	a7,16
 ecall
 434:	00000073          	ecall
 ret
 438:	00008067          	ret

000000000000043c <close>:
.global close
close:
 li a7, SYS_close
 43c:	01500893          	li	a7,21
 ecall
 440:	00000073          	ecall
 ret
 444:	00008067          	ret

0000000000000448 <kill>:
.global kill
kill:
 li a7, SYS_kill
 448:	00600893          	li	a7,6
 ecall
 44c:	00000073          	ecall
 ret
 450:	00008067          	ret

0000000000000454 <exec>:
.global exec
exec:
 li a7, SYS_exec
 454:	00700893          	li	a7,7
 ecall
 458:	00000073          	ecall
 ret
 45c:	00008067          	ret

0000000000000460 <open>:
.global open
open:
 li a7, SYS_open
 460:	00f00893          	li	a7,15
 ecall
 464:	00000073          	ecall
 ret
 468:	00008067          	ret

000000000000046c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 46c:	01100893          	li	a7,17
 ecall
 470:	00000073          	ecall
 ret
 474:	00008067          	ret

0000000000000478 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 478:	01200893          	li	a7,18
 ecall
 47c:	00000073          	ecall
 ret
 480:	00008067          	ret

0000000000000484 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 484:	00800893          	li	a7,8
 ecall
 488:	00000073          	ecall
 ret
 48c:	00008067          	ret

0000000000000490 <link>:
.global link
link:
 li a7, SYS_link
 490:	01300893          	li	a7,19
 ecall
 494:	00000073          	ecall
 ret
 498:	00008067          	ret

000000000000049c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 49c:	01400893          	li	a7,20
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	00008067          	ret

00000000000004a8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4a8:	00900893          	li	a7,9
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	00008067          	ret

00000000000004b4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4b4:	00a00893          	li	a7,10
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	00008067          	ret

00000000000004c0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4c0:	00b00893          	li	a7,11
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	00008067          	ret

00000000000004cc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4cc:	00c00893          	li	a7,12
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	00008067          	ret

00000000000004d8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4d8:	00d00893          	li	a7,13
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	00008067          	ret

00000000000004e4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4e4:	00e00893          	li	a7,14
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	00008067          	ret

00000000000004f0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4f0:	fe010113          	addi	sp,sp,-32
 4f4:	00113c23          	sd	ra,24(sp)
 4f8:	00813823          	sd	s0,16(sp)
 4fc:	02010413          	addi	s0,sp,32
 500:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 504:	00100613          	li	a2,1
 508:	fef40593          	addi	a1,s0,-17
 50c:	f25ff0ef          	jal	430 <write>
}
 510:	01813083          	ld	ra,24(sp)
 514:	01013403          	ld	s0,16(sp)
 518:	02010113          	addi	sp,sp,32
 51c:	00008067          	ret

0000000000000520 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 520:	fc010113          	addi	sp,sp,-64
 524:	02113c23          	sd	ra,56(sp)
 528:	02813823          	sd	s0,48(sp)
 52c:	02913423          	sd	s1,40(sp)
 530:	04010413          	addi	s0,sp,64
 534:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 538:	00068463          	beqz	a3,540 <printint+0x20>
 53c:	0c05c263          	bltz	a1,600 <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 540:	0005859b          	sext.w	a1,a1
  neg = 0;
 544:	00000893          	li	a7,0
 548:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 54c:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 550:	0006061b          	sext.w	a2,a2
 554:	00000517          	auipc	a0,0x0
 558:	71450513          	addi	a0,a0,1812 # c68 <digits>
 55c:	00070813          	mv	a6,a4
 560:	0017071b          	addiw	a4,a4,1
 564:	02c5f7bb          	remuw	a5,a1,a2
 568:	02079793          	slli	a5,a5,0x20
 56c:	0207d793          	srli	a5,a5,0x20
 570:	00f507b3          	add	a5,a0,a5
 574:	0007c783          	lbu	a5,0(a5)
 578:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 57c:	0005879b          	sext.w	a5,a1
 580:	02c5d5bb          	divuw	a1,a1,a2
 584:	00168693          	addi	a3,a3,1
 588:	fcc7fae3          	bgeu	a5,a2,55c <printint+0x3c>
  if(neg)
 58c:	00088c63          	beqz	a7,5a4 <printint+0x84>
    buf[i++] = '-';
 590:	fd070793          	addi	a5,a4,-48
 594:	00878733          	add	a4,a5,s0
 598:	02d00793          	li	a5,45
 59c:	fef70823          	sb	a5,-16(a4)
 5a0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5a4:	04e05463          	blez	a4,5ec <printint+0xcc>
 5a8:	03213023          	sd	s2,32(sp)
 5ac:	01313c23          	sd	s3,24(sp)
 5b0:	fc040793          	addi	a5,s0,-64
 5b4:	00e78933          	add	s2,a5,a4
 5b8:	fff78993          	addi	s3,a5,-1
 5bc:	00e989b3          	add	s3,s3,a4
 5c0:	fff7071b          	addiw	a4,a4,-1
 5c4:	02071713          	slli	a4,a4,0x20
 5c8:	02075713          	srli	a4,a4,0x20
 5cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5d0:	fff94583          	lbu	a1,-1(s2)
 5d4:	00048513          	mv	a0,s1
 5d8:	f19ff0ef          	jal	4f0 <putc>
  while(--i >= 0)
 5dc:	fff90913          	addi	s2,s2,-1
 5e0:	ff3918e3          	bne	s2,s3,5d0 <printint+0xb0>
 5e4:	02013903          	ld	s2,32(sp)
 5e8:	01813983          	ld	s3,24(sp)
}
 5ec:	03813083          	ld	ra,56(sp)
 5f0:	03013403          	ld	s0,48(sp)
 5f4:	02813483          	ld	s1,40(sp)
 5f8:	04010113          	addi	sp,sp,64
 5fc:	00008067          	ret
    x = -xx;
 600:	40b005bb          	negw	a1,a1
    neg = 1;
 604:	00100893          	li	a7,1
    x = -xx;
 608:	f41ff06f          	j	548 <printint+0x28>

000000000000060c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 60c:	fa010113          	addi	sp,sp,-96
 610:	04113c23          	sd	ra,88(sp)
 614:	04813823          	sd	s0,80(sp)
 618:	05213023          	sd	s2,64(sp)
 61c:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 620:	0005c903          	lbu	s2,0(a1)
 624:	36090463          	beqz	s2,98c <vprintf+0x380>
 628:	04913423          	sd	s1,72(sp)
 62c:	03313c23          	sd	s3,56(sp)
 630:	03413823          	sd	s4,48(sp)
 634:	03513423          	sd	s5,40(sp)
 638:	03613023          	sd	s6,32(sp)
 63c:	01713c23          	sd	s7,24(sp)
 640:	01813823          	sd	s8,16(sp)
 644:	01913423          	sd	s9,8(sp)
 648:	00050b13          	mv	s6,a0
 64c:	00058a13          	mv	s4,a1
 650:	00060b93          	mv	s7,a2
  state = 0;
 654:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
 658:	00000493          	li	s1,0
 65c:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 660:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 664:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 668:	06c00c93          	li	s9,108
 66c:	02c0006f          	j	698 <vprintf+0x8c>
        putc(fd, c0);
 670:	00090593          	mv	a1,s2
 674:	000b0513          	mv	a0,s6
 678:	e79ff0ef          	jal	4f0 <putc>
 67c:	0080006f          	j	684 <vprintf+0x78>
    } else if(state == '%'){
 680:	03598663          	beq	s3,s5,6ac <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
 684:	0014849b          	addiw	s1,s1,1
 688:	00048713          	mv	a4,s1
 68c:	009a07b3          	add	a5,s4,s1
 690:	0007c903          	lbu	s2,0(a5)
 694:	2c090c63          	beqz	s2,96c <vprintf+0x360>
    c0 = fmt[i] & 0xff;
 698:	0009079b          	sext.w	a5,s2
    if(state == 0){
 69c:	fe0992e3          	bnez	s3,680 <vprintf+0x74>
      if(c0 == '%'){
 6a0:	fd5798e3          	bne	a5,s5,670 <vprintf+0x64>
        state = '%';
 6a4:	00078993          	mv	s3,a5
 6a8:	fddff06f          	j	684 <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
 6ac:	00ea06b3          	add	a3,s4,a4
 6b0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6b4:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6b8:	00068663          	beqz	a3,6c4 <vprintf+0xb8>
 6bc:	00ea0733          	add	a4,s4,a4
 6c0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6c4:	05878263          	beq	a5,s8,708 <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
 6c8:	07978263          	beq	a5,s9,72c <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6cc:	07500713          	li	a4,117
 6d0:	12e78663          	beq	a5,a4,7fc <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6d4:	07800713          	li	a4,120
 6d8:	18e78c63          	beq	a5,a4,870 <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6dc:	07000713          	li	a4,112
 6e0:	1ce78e63          	beq	a5,a4,8bc <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6e4:	07300713          	li	a4,115
 6e8:	22e78a63          	beq	a5,a4,91c <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6ec:	02500713          	li	a4,37
 6f0:	04e79e63          	bne	a5,a4,74c <vprintf+0x140>
        putc(fd, '%');
 6f4:	02500593          	li	a1,37
 6f8:	000b0513          	mv	a0,s6
 6fc:	df5ff0ef          	jal	4f0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 700:	00000993          	li	s3,0
 704:	f81ff06f          	j	684 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
 708:	008b8913          	addi	s2,s7,8
 70c:	00100693          	li	a3,1
 710:	00a00613          	li	a2,10
 714:	000ba583          	lw	a1,0(s7)
 718:	000b0513          	mv	a0,s6
 71c:	e05ff0ef          	jal	520 <printint>
 720:	00090b93          	mv	s7,s2
      state = 0;
 724:	00000993          	li	s3,0
 728:	f5dff06f          	j	684 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
 72c:	06400793          	li	a5,100
 730:	02f68e63          	beq	a3,a5,76c <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 734:	06c00793          	li	a5,108
 738:	04f68e63          	beq	a3,a5,794 <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
 73c:	07500793          	li	a5,117
 740:	0ef68063          	beq	a3,a5,820 <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
 744:	07800793          	li	a5,120
 748:	14f68663          	beq	a3,a5,894 <vprintf+0x288>
        putc(fd, '%');
 74c:	02500593          	li	a1,37
 750:	000b0513          	mv	a0,s6
 754:	d9dff0ef          	jal	4f0 <putc>
        putc(fd, c0);
 758:	00090593          	mv	a1,s2
 75c:	000b0513          	mv	a0,s6
 760:	d91ff0ef          	jal	4f0 <putc>
      state = 0;
 764:	00000993          	li	s3,0
 768:	f1dff06f          	j	684 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 76c:	008b8913          	addi	s2,s7,8
 770:	00100693          	li	a3,1
 774:	00a00613          	li	a2,10
 778:	000ba583          	lw	a1,0(s7)
 77c:	000b0513          	mv	a0,s6
 780:	da1ff0ef          	jal	520 <printint>
        i += 1;
 784:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 788:	00090b93          	mv	s7,s2
      state = 0;
 78c:	00000993          	li	s3,0
        i += 1;
 790:	ef5ff06f          	j	684 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 794:	06400793          	li	a5,100
 798:	02f60e63          	beq	a2,a5,7d4 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 79c:	07500793          	li	a5,117
 7a0:	0af60463          	beq	a2,a5,848 <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7a4:	07800793          	li	a5,120
 7a8:	faf612e3          	bne	a2,a5,74c <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ac:	008b8913          	addi	s2,s7,8
 7b0:	00000693          	li	a3,0
 7b4:	01000613          	li	a2,16
 7b8:	000ba583          	lw	a1,0(s7)
 7bc:	000b0513          	mv	a0,s6
 7c0:	d61ff0ef          	jal	520 <printint>
        i += 2;
 7c4:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c8:	00090b93          	mv	s7,s2
      state = 0;
 7cc:	00000993          	li	s3,0
        i += 2;
 7d0:	eb5ff06f          	j	684 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d4:	008b8913          	addi	s2,s7,8
 7d8:	00100693          	li	a3,1
 7dc:	00a00613          	li	a2,10
 7e0:	000ba583          	lw	a1,0(s7)
 7e4:	000b0513          	mv	a0,s6
 7e8:	d39ff0ef          	jal	520 <printint>
        i += 2;
 7ec:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f0:	00090b93          	mv	s7,s2
      state = 0;
 7f4:	00000993          	li	s3,0
        i += 2;
 7f8:	e8dff06f          	j	684 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
 7fc:	008b8913          	addi	s2,s7,8
 800:	00000693          	li	a3,0
 804:	00a00613          	li	a2,10
 808:	000ba583          	lw	a1,0(s7)
 80c:	000b0513          	mv	a0,s6
 810:	d11ff0ef          	jal	520 <printint>
 814:	00090b93          	mv	s7,s2
      state = 0;
 818:	00000993          	li	s3,0
 81c:	e69ff06f          	j	684 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 820:	008b8913          	addi	s2,s7,8
 824:	00000693          	li	a3,0
 828:	00a00613          	li	a2,10
 82c:	000ba583          	lw	a1,0(s7)
 830:	000b0513          	mv	a0,s6
 834:	cedff0ef          	jal	520 <printint>
        i += 1;
 838:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 83c:	00090b93          	mv	s7,s2
      state = 0;
 840:	00000993          	li	s3,0
        i += 1;
 844:	e41ff06f          	j	684 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 848:	008b8913          	addi	s2,s7,8
 84c:	00000693          	li	a3,0
 850:	00a00613          	li	a2,10
 854:	000ba583          	lw	a1,0(s7)
 858:	000b0513          	mv	a0,s6
 85c:	cc5ff0ef          	jal	520 <printint>
        i += 2;
 860:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 864:	00090b93          	mv	s7,s2
      state = 0;
 868:	00000993          	li	s3,0
        i += 2;
 86c:	e19ff06f          	j	684 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
 870:	008b8913          	addi	s2,s7,8
 874:	00000693          	li	a3,0
 878:	01000613          	li	a2,16
 87c:	000ba583          	lw	a1,0(s7)
 880:	000b0513          	mv	a0,s6
 884:	c9dff0ef          	jal	520 <printint>
 888:	00090b93          	mv	s7,s2
      state = 0;
 88c:	00000993          	li	s3,0
 890:	df5ff06f          	j	684 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
 894:	008b8913          	addi	s2,s7,8
 898:	00000693          	li	a3,0
 89c:	01000613          	li	a2,16
 8a0:	000ba583          	lw	a1,0(s7)
 8a4:	000b0513          	mv	a0,s6
 8a8:	c79ff0ef          	jal	520 <printint>
        i += 1;
 8ac:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8b0:	00090b93          	mv	s7,s2
      state = 0;
 8b4:	00000993          	li	s3,0
        i += 1;
 8b8:	dcdff06f          	j	684 <vprintf+0x78>
 8bc:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 8c0:	008b8d13          	addi	s10,s7,8
 8c4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8c8:	03000593          	li	a1,48
 8cc:	000b0513          	mv	a0,s6
 8d0:	c21ff0ef          	jal	4f0 <putc>
  putc(fd, 'x');
 8d4:	07800593          	li	a1,120
 8d8:	000b0513          	mv	a0,s6
 8dc:	c15ff0ef          	jal	4f0 <putc>
 8e0:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8e4:	00000b97          	auipc	s7,0x0
 8e8:	384b8b93          	addi	s7,s7,900 # c68 <digits>
 8ec:	03c9d793          	srli	a5,s3,0x3c
 8f0:	00fb87b3          	add	a5,s7,a5
 8f4:	0007c583          	lbu	a1,0(a5)
 8f8:	000b0513          	mv	a0,s6
 8fc:	bf5ff0ef          	jal	4f0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 900:	00499993          	slli	s3,s3,0x4
 904:	fff9091b          	addiw	s2,s2,-1
 908:	fe0912e3          	bnez	s2,8ec <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
 90c:	000d0b93          	mv	s7,s10
      state = 0;
 910:	00000993          	li	s3,0
 914:	00013d03          	ld	s10,0(sp)
 918:	d6dff06f          	j	684 <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
 91c:	008b8993          	addi	s3,s7,8
 920:	000bb903          	ld	s2,0(s7)
 924:	02090663          	beqz	s2,950 <vprintf+0x344>
        for(; *s; s++)
 928:	00094583          	lbu	a1,0(s2)
 92c:	02058a63          	beqz	a1,960 <vprintf+0x354>
          putc(fd, *s);
 930:	000b0513          	mv	a0,s6
 934:	bbdff0ef          	jal	4f0 <putc>
        for(; *s; s++)
 938:	00190913          	addi	s2,s2,1
 93c:	00094583          	lbu	a1,0(s2)
 940:	fe0598e3          	bnez	a1,930 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 944:	00098b93          	mv	s7,s3
      state = 0;
 948:	00000993          	li	s3,0
 94c:	d39ff06f          	j	684 <vprintf+0x78>
          s = "(null)";
 950:	00000917          	auipc	s2,0x0
 954:	31090913          	addi	s2,s2,784 # c60 <malloc+0x17c>
        for(; *s; s++)
 958:	02800593          	li	a1,40
 95c:	fd5ff06f          	j	930 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 960:	00098b93          	mv	s7,s3
      state = 0;
 964:	00000993          	li	s3,0
 968:	d1dff06f          	j	684 <vprintf+0x78>
 96c:	04813483          	ld	s1,72(sp)
 970:	03813983          	ld	s3,56(sp)
 974:	03013a03          	ld	s4,48(sp)
 978:	02813a83          	ld	s5,40(sp)
 97c:	02013b03          	ld	s6,32(sp)
 980:	01813b83          	ld	s7,24(sp)
 984:	01013c03          	ld	s8,16(sp)
 988:	00813c83          	ld	s9,8(sp)
    }
  }
}
 98c:	05813083          	ld	ra,88(sp)
 990:	05013403          	ld	s0,80(sp)
 994:	04013903          	ld	s2,64(sp)
 998:	06010113          	addi	sp,sp,96
 99c:	00008067          	ret

00000000000009a0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9a0:	fb010113          	addi	sp,sp,-80
 9a4:	00113c23          	sd	ra,24(sp)
 9a8:	00813823          	sd	s0,16(sp)
 9ac:	02010413          	addi	s0,sp,32
 9b0:	00c43023          	sd	a2,0(s0)
 9b4:	00d43423          	sd	a3,8(s0)
 9b8:	00e43823          	sd	a4,16(s0)
 9bc:	00f43c23          	sd	a5,24(s0)
 9c0:	03043023          	sd	a6,32(s0)
 9c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9cc:	00040613          	mv	a2,s0
 9d0:	c3dff0ef          	jal	60c <vprintf>
}
 9d4:	01813083          	ld	ra,24(sp)
 9d8:	01013403          	ld	s0,16(sp)
 9dc:	05010113          	addi	sp,sp,80
 9e0:	00008067          	ret

00000000000009e4 <printf>:

void
printf(const char *fmt, ...)
{
 9e4:	fa010113          	addi	sp,sp,-96
 9e8:	00113c23          	sd	ra,24(sp)
 9ec:	00813823          	sd	s0,16(sp)
 9f0:	02010413          	addi	s0,sp,32
 9f4:	00b43423          	sd	a1,8(s0)
 9f8:	00c43823          	sd	a2,16(s0)
 9fc:	00d43c23          	sd	a3,24(s0)
 a00:	02e43023          	sd	a4,32(s0)
 a04:	02f43423          	sd	a5,40(s0)
 a08:	03043823          	sd	a6,48(s0)
 a0c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a10:	00840613          	addi	a2,s0,8
 a14:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a18:	00050593          	mv	a1,a0
 a1c:	00100513          	li	a0,1
 a20:	bedff0ef          	jal	60c <vprintf>
}
 a24:	01813083          	ld	ra,24(sp)
 a28:	01013403          	ld	s0,16(sp)
 a2c:	06010113          	addi	sp,sp,96
 a30:	00008067          	ret

0000000000000a34 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a34:	ff010113          	addi	sp,sp,-16
 a38:	00813423          	sd	s0,8(sp)
 a3c:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a40:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a44:	00000797          	auipc	a5,0x0
 a48:	5bc7b783          	ld	a5,1468(a5) # 1000 <freep>
 a4c:	0400006f          	j	a8c <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a50:	00862703          	lw	a4,8(a2)
 a54:	00b7073b          	addw	a4,a4,a1
 a58:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a5c:	0007b703          	ld	a4,0(a5)
 a60:	00073603          	ld	a2,0(a4)
 a64:	0500006f          	j	ab4 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a68:	ff852703          	lw	a4,-8(a0)
 a6c:	00c7073b          	addw	a4,a4,a2
 a70:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a74:	ff053683          	ld	a3,-16(a0)
 a78:	0540006f          	j	acc <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a7c:	0007b703          	ld	a4,0(a5)
 a80:	00e7e463          	bltu	a5,a4,a88 <free+0x54>
 a84:	00e6ec63          	bltu	a3,a4,a9c <free+0x68>
{
 a88:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a8c:	fed7f8e3          	bgeu	a5,a3,a7c <free+0x48>
 a90:	0007b703          	ld	a4,0(a5)
 a94:	00e6e463          	bltu	a3,a4,a9c <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a98:	fee7e8e3          	bltu	a5,a4,a88 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 a9c:	ff852583          	lw	a1,-8(a0)
 aa0:	0007b603          	ld	a2,0(a5)
 aa4:	02059813          	slli	a6,a1,0x20
 aa8:	01c85713          	srli	a4,a6,0x1c
 aac:	00e68733          	add	a4,a3,a4
 ab0:	fae600e3          	beq	a2,a4,a50 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 ab4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ab8:	0087a603          	lw	a2,8(a5)
 abc:	02061593          	slli	a1,a2,0x20
 ac0:	01c5d713          	srli	a4,a1,0x1c
 ac4:	00e78733          	add	a4,a5,a4
 ac8:	fae680e3          	beq	a3,a4,a68 <free+0x34>
    p->s.ptr = bp->s.ptr;
 acc:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 ad0:	00000717          	auipc	a4,0x0
 ad4:	52f73823          	sd	a5,1328(a4) # 1000 <freep>
}
 ad8:	00813403          	ld	s0,8(sp)
 adc:	01010113          	addi	sp,sp,16
 ae0:	00008067          	ret

0000000000000ae4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ae4:	fc010113          	addi	sp,sp,-64
 ae8:	02113c23          	sd	ra,56(sp)
 aec:	02813823          	sd	s0,48(sp)
 af0:	02913423          	sd	s1,40(sp)
 af4:	01313c23          	sd	s3,24(sp)
 af8:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 afc:	02051493          	slli	s1,a0,0x20
 b00:	0204d493          	srli	s1,s1,0x20
 b04:	00f48493          	addi	s1,s1,15
 b08:	0044d493          	srli	s1,s1,0x4
 b0c:	0014899b          	addiw	s3,s1,1
 b10:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
 b14:	00000517          	auipc	a0,0x0
 b18:	4ec53503          	ld	a0,1260(a0) # 1000 <freep>
 b1c:	04050663          	beqz	a0,b68 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b20:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b24:	0087a703          	lw	a4,8(a5)
 b28:	0c977c63          	bgeu	a4,s1,c00 <malloc+0x11c>
 b2c:	03213023          	sd	s2,32(sp)
 b30:	01413823          	sd	s4,16(sp)
 b34:	01513423          	sd	s5,8(sp)
 b38:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
 b3c:	00098a13          	mv	s4,s3
 b40:	0009871b          	sext.w	a4,s3
 b44:	000016b7          	lui	a3,0x1
 b48:	00d77463          	bgeu	a4,a3,b50 <malloc+0x6c>
 b4c:	00001a37          	lui	s4,0x1
 b50:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b54:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b58:	00000917          	auipc	s2,0x0
 b5c:	4a890913          	addi	s2,s2,1192 # 1000 <freep>
  if(p == (char*)-1)
 b60:	fff00a93          	li	s5,-1
 b64:	05c0006f          	j	bc0 <malloc+0xdc>
 b68:	03213023          	sd	s2,32(sp)
 b6c:	01413823          	sd	s4,16(sp)
 b70:	01513423          	sd	s5,8(sp)
 b74:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b78:	00000797          	auipc	a5,0x0
 b7c:	49878793          	addi	a5,a5,1176 # 1010 <base>
 b80:	00000717          	auipc	a4,0x0
 b84:	48f73023          	sd	a5,1152(a4) # 1000 <freep>
 b88:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 b8c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b90:	fadff06f          	j	b3c <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
 b94:	0007b703          	ld	a4,0(a5)
 b98:	00e53023          	sd	a4,0(a0)
 b9c:	0800006f          	j	c1c <malloc+0x138>
  hp->s.size = nu;
 ba0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ba4:	01050513          	addi	a0,a0,16
 ba8:	e8dff0ef          	jal	a34 <free>
  return freep;
 bac:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bb0:	08050863          	beqz	a0,c40 <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bb4:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bb8:	0087a703          	lw	a4,8(a5)
 bbc:	02977a63          	bgeu	a4,s1,bf0 <malloc+0x10c>
    if(p == freep)
 bc0:	00093703          	ld	a4,0(s2)
 bc4:	00078513          	mv	a0,a5
 bc8:	fef716e3          	bne	a4,a5,bb4 <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
 bcc:	000a0513          	mv	a0,s4
 bd0:	8fdff0ef          	jal	4cc <sbrk>
  if(p == (char*)-1)
 bd4:	fd5516e3          	bne	a0,s5,ba0 <malloc+0xbc>
        return 0;
 bd8:	00000513          	li	a0,0
 bdc:	02013903          	ld	s2,32(sp)
 be0:	01013a03          	ld	s4,16(sp)
 be4:	00813a83          	ld	s5,8(sp)
 be8:	00013b03          	ld	s6,0(sp)
 bec:	03c0006f          	j	c28 <malloc+0x144>
 bf0:	02013903          	ld	s2,32(sp)
 bf4:	01013a03          	ld	s4,16(sp)
 bf8:	00813a83          	ld	s5,8(sp)
 bfc:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
 c00:	f8e48ae3          	beq	s1,a4,b94 <malloc+0xb0>
        p->s.size -= nunits;
 c04:	4137073b          	subw	a4,a4,s3
 c08:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 c0c:	02071693          	slli	a3,a4,0x20
 c10:	01c6d713          	srli	a4,a3,0x1c
 c14:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 c18:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c1c:	00000717          	auipc	a4,0x0
 c20:	3ea73223          	sd	a0,996(a4) # 1000 <freep>
      return (void*)(p + 1);
 c24:	01078513          	addi	a0,a5,16
  }
}
 c28:	03813083          	ld	ra,56(sp)
 c2c:	03013403          	ld	s0,48(sp)
 c30:	02813483          	ld	s1,40(sp)
 c34:	01813983          	ld	s3,24(sp)
 c38:	04010113          	addi	sp,sp,64
 c3c:	00008067          	ret
 c40:	02013903          	ld	s2,32(sp)
 c44:	01013a03          	ld	s4,16(sp)
 c48:	00813a83          	ld	s5,8(sp)
 c4c:	00013b03          	ld	s6,0(sp)
 c50:	fd9ff06f          	j	c28 <malloc+0x144>
