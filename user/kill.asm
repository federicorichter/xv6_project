
user/_kill:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	fe010113          	addi	sp,sp,-32
   4:	00113c23          	sd	ra,24(sp)
   8:	00813823          	sd	s0,16(sp)
   c:	02010413          	addi	s0,sp,32
  int i;

  if(argc < 2){
  10:	00100793          	li	a5,1
  14:	04a7d063          	bge	a5,a0,54 <main+0x54>
  18:	00913423          	sd	s1,8(sp)
  1c:	01213023          	sd	s2,0(sp)
  20:	00858493          	addi	s1,a1,8
  24:	ffe5091b          	addiw	s2,a0,-2
  28:	02091793          	slli	a5,s2,0x20
  2c:	01d7d913          	srli	s2,a5,0x1d
  30:	01058593          	addi	a1,a1,16
  34:	00b90933          	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  38:	0004b503          	ld	a0,0(s1)
  3c:	2a0000ef          	jal	2dc <atoi>
  40:	450000ef          	jal	490 <kill>
  for(i=1; i<argc; i++)
  44:	00848493          	addi	s1,s1,8
  48:	ff2498e3          	bne	s1,s2,38 <main+0x38>
  exit(0);
  4c:	00000513          	li	a0,0
  50:	3f8000ef          	jal	448 <exit>
  54:	00913423          	sd	s1,8(sp)
  58:	01213023          	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  5c:	00001597          	auipc	a1,0x1
  60:	c4458593          	addi	a1,a1,-956 # ca0 <malloc+0x174>
  64:	00200513          	li	a0,2
  68:	181000ef          	jal	9e8 <fprintf>
    exit(1);
  6c:	00100513          	li	a0,1
  70:	3d8000ef          	jal	448 <exit>

0000000000000074 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  74:	ff010113          	addi	sp,sp,-16
  78:	00113423          	sd	ra,8(sp)
  7c:	00813023          	sd	s0,0(sp)
  80:	01010413          	addi	s0,sp,16
  extern int main();
  main();
  84:	f7dff0ef          	jal	0 <main>
  exit(0);
  88:	00000513          	li	a0,0
  8c:	3bc000ef          	jal	448 <exit>

0000000000000090 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  90:	ff010113          	addi	sp,sp,-16
  94:	00813423          	sd	s0,8(sp)
  98:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9c:	00050793          	mv	a5,a0
  a0:	00158593          	addi	a1,a1,1
  a4:	00178793          	addi	a5,a5,1
  a8:	fff5c703          	lbu	a4,-1(a1)
  ac:	fee78fa3          	sb	a4,-1(a5)
  b0:	fe0718e3          	bnez	a4,a0 <strcpy+0x10>
    ;
  return os;
}
  b4:	00813403          	ld	s0,8(sp)
  b8:	01010113          	addi	sp,sp,16
  bc:	00008067          	ret

00000000000000c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c0:	ff010113          	addi	sp,sp,-16
  c4:	00813423          	sd	s0,8(sp)
  c8:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	00078e63          	beqz	a5,ec <strcmp+0x2c>
  d4:	0005c703          	lbu	a4,0(a1)
  d8:	00f71a63          	bne	a4,a5,ec <strcmp+0x2c>
    p++, q++;
  dc:	00150513          	addi	a0,a0,1
  e0:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	fe0796e3          	bnez	a5,d4 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  ec:	0005c503          	lbu	a0,0(a1)
}
  f0:	40a7853b          	subw	a0,a5,a0
  f4:	00813403          	ld	s0,8(sp)
  f8:	01010113          	addi	sp,sp,16
  fc:	00008067          	ret

0000000000000100 <strlen>:

uint
strlen(const char *s)
{
 100:	ff010113          	addi	sp,sp,-16
 104:	00813423          	sd	s0,8(sp)
 108:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 10c:	00054783          	lbu	a5,0(a0)
 110:	02078863          	beqz	a5,140 <strlen+0x40>
 114:	00150513          	addi	a0,a0,1
 118:	00050793          	mv	a5,a0
 11c:	00078693          	mv	a3,a5
 120:	00178793          	addi	a5,a5,1
 124:	fff7c703          	lbu	a4,-1(a5)
 128:	fe071ae3          	bnez	a4,11c <strlen+0x1c>
 12c:	40a6853b          	subw	a0,a3,a0
 130:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
 134:	00813403          	ld	s0,8(sp)
 138:	01010113          	addi	sp,sp,16
 13c:	00008067          	ret
  for(n = 0; s[n]; n++)
 140:	00000513          	li	a0,0
 144:	ff1ff06f          	j	134 <strlen+0x34>

0000000000000148 <memset>:

void*
memset(void *dst, int c, uint n)
{
 148:	ff010113          	addi	sp,sp,-16
 14c:	00813423          	sd	s0,8(sp)
 150:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 154:	02060063          	beqz	a2,174 <memset+0x2c>
 158:	00050793          	mv	a5,a0
 15c:	02061613          	slli	a2,a2,0x20
 160:	02065613          	srli	a2,a2,0x20
 164:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 168:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 16c:	00178793          	addi	a5,a5,1
 170:	fee79ce3          	bne	a5,a4,168 <memset+0x20>
  }
  return dst;
}
 174:	00813403          	ld	s0,8(sp)
 178:	01010113          	addi	sp,sp,16
 17c:	00008067          	ret

0000000000000180 <strchr>:

char*
strchr(const char *s, char c)
{
 180:	ff010113          	addi	sp,sp,-16
 184:	00813423          	sd	s0,8(sp)
 188:	01010413          	addi	s0,sp,16
  for(; *s; s++)
 18c:	00054783          	lbu	a5,0(a0)
 190:	02078263          	beqz	a5,1b4 <strchr+0x34>
    if(*s == c)
 194:	00f58a63          	beq	a1,a5,1a8 <strchr+0x28>
  for(; *s; s++)
 198:	00150513          	addi	a0,a0,1
 19c:	00054783          	lbu	a5,0(a0)
 1a0:	fe079ae3          	bnez	a5,194 <strchr+0x14>
      return (char*)s;
  return 0;
 1a4:	00000513          	li	a0,0
}
 1a8:	00813403          	ld	s0,8(sp)
 1ac:	01010113          	addi	sp,sp,16
 1b0:	00008067          	ret
  return 0;
 1b4:	00000513          	li	a0,0
 1b8:	ff1ff06f          	j	1a8 <strchr+0x28>

00000000000001bc <gets>:

char*
gets(char *buf, int max)
{
 1bc:	fa010113          	addi	sp,sp,-96
 1c0:	04113c23          	sd	ra,88(sp)
 1c4:	04813823          	sd	s0,80(sp)
 1c8:	04913423          	sd	s1,72(sp)
 1cc:	05213023          	sd	s2,64(sp)
 1d0:	03313c23          	sd	s3,56(sp)
 1d4:	03413823          	sd	s4,48(sp)
 1d8:	03513423          	sd	s5,40(sp)
 1dc:	03613023          	sd	s6,32(sp)
 1e0:	01713c23          	sd	s7,24(sp)
 1e4:	06010413          	addi	s0,sp,96
 1e8:	00050b93          	mv	s7,a0
 1ec:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f0:	00050913          	mv	s2,a0
 1f4:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f8:	00a00a93          	li	s5,10
 1fc:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 200:	00048993          	mv	s3,s1
 204:	0014849b          	addiw	s1,s1,1
 208:	0344dc63          	bge	s1,s4,240 <gets+0x84>
    cc = read(0, &c, 1);
 20c:	00100613          	li	a2,1
 210:	faf40593          	addi	a1,s0,-81
 214:	00000513          	li	a0,0
 218:	254000ef          	jal	46c <read>
    if(cc < 1)
 21c:	02a05263          	blez	a0,240 <gets+0x84>
    buf[i++] = c;
 220:	faf44783          	lbu	a5,-81(s0)
 224:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 228:	01578a63          	beq	a5,s5,23c <gets+0x80>
 22c:	00190913          	addi	s2,s2,1
 230:	fd6798e3          	bne	a5,s6,200 <gets+0x44>
    buf[i++] = c;
 234:	00048993          	mv	s3,s1
 238:	0080006f          	j	240 <gets+0x84>
 23c:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 240:	013b89b3          	add	s3,s7,s3
 244:	00098023          	sb	zero,0(s3)
  return buf;
}
 248:	000b8513          	mv	a0,s7
 24c:	05813083          	ld	ra,88(sp)
 250:	05013403          	ld	s0,80(sp)
 254:	04813483          	ld	s1,72(sp)
 258:	04013903          	ld	s2,64(sp)
 25c:	03813983          	ld	s3,56(sp)
 260:	03013a03          	ld	s4,48(sp)
 264:	02813a83          	ld	s5,40(sp)
 268:	02013b03          	ld	s6,32(sp)
 26c:	01813b83          	ld	s7,24(sp)
 270:	06010113          	addi	sp,sp,96
 274:	00008067          	ret

0000000000000278 <stat>:

int
stat(const char *n, struct stat *st)
{
 278:	fe010113          	addi	sp,sp,-32
 27c:	00113c23          	sd	ra,24(sp)
 280:	00813823          	sd	s0,16(sp)
 284:	01213023          	sd	s2,0(sp)
 288:	02010413          	addi	s0,sp,32
 28c:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 290:	00000593          	li	a1,0
 294:	214000ef          	jal	4a8 <open>
  if(fd < 0)
 298:	02054e63          	bltz	a0,2d4 <stat+0x5c>
 29c:	00913423          	sd	s1,8(sp)
 2a0:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2a4:	00090593          	mv	a1,s2
 2a8:	224000ef          	jal	4cc <fstat>
 2ac:	00050913          	mv	s2,a0
  close(fd);
 2b0:	00048513          	mv	a0,s1
 2b4:	1d0000ef          	jal	484 <close>
  return r;
 2b8:	00813483          	ld	s1,8(sp)
}
 2bc:	00090513          	mv	a0,s2
 2c0:	01813083          	ld	ra,24(sp)
 2c4:	01013403          	ld	s0,16(sp)
 2c8:	00013903          	ld	s2,0(sp)
 2cc:	02010113          	addi	sp,sp,32
 2d0:	00008067          	ret
    return -1;
 2d4:	fff00913          	li	s2,-1
 2d8:	fe5ff06f          	j	2bc <stat+0x44>

00000000000002dc <atoi>:

int
atoi(const char *s)
{
 2dc:	ff010113          	addi	sp,sp,-16
 2e0:	00813423          	sd	s0,8(sp)
 2e4:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e8:	00054683          	lbu	a3,0(a0)
 2ec:	fd06879b          	addiw	a5,a3,-48
 2f0:	0ff7f793          	zext.b	a5,a5
 2f4:	00900613          	li	a2,9
 2f8:	04f66063          	bltu	a2,a5,338 <atoi+0x5c>
 2fc:	00050713          	mv	a4,a0
  n = 0;
 300:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 304:	00170713          	addi	a4,a4,1
 308:	0025179b          	slliw	a5,a0,0x2
 30c:	00a787bb          	addw	a5,a5,a0
 310:	0017979b          	slliw	a5,a5,0x1
 314:	00d787bb          	addw	a5,a5,a3
 318:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 31c:	00074683          	lbu	a3,0(a4)
 320:	fd06879b          	addiw	a5,a3,-48
 324:	0ff7f793          	zext.b	a5,a5
 328:	fcf67ee3          	bgeu	a2,a5,304 <atoi+0x28>
  return n;
}
 32c:	00813403          	ld	s0,8(sp)
 330:	01010113          	addi	sp,sp,16
 334:	00008067          	ret
  n = 0;
 338:	00000513          	li	a0,0
 33c:	ff1ff06f          	j	32c <atoi+0x50>

0000000000000340 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 340:	ff010113          	addi	sp,sp,-16
 344:	00813423          	sd	s0,8(sp)
 348:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 34c:	02b57c63          	bgeu	a0,a1,384 <memmove+0x44>
    while(n-- > 0)
 350:	02c05463          	blez	a2,378 <memmove+0x38>
 354:	02061613          	slli	a2,a2,0x20
 358:	02065613          	srli	a2,a2,0x20
 35c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 360:	00050713          	mv	a4,a0
      *dst++ = *src++;
 364:	00158593          	addi	a1,a1,1
 368:	00170713          	addi	a4,a4,1
 36c:	fff5c683          	lbu	a3,-1(a1)
 370:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 374:	fef718e3          	bne	a4,a5,364 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 378:	00813403          	ld	s0,8(sp)
 37c:	01010113          	addi	sp,sp,16
 380:	00008067          	ret
    dst += n;
 384:	00c50733          	add	a4,a0,a2
    src += n;
 388:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 38c:	fec056e3          	blez	a2,378 <memmove+0x38>
 390:	fff6079b          	addiw	a5,a2,-1
 394:	02079793          	slli	a5,a5,0x20
 398:	0207d793          	srli	a5,a5,0x20
 39c:	fff7c793          	not	a5,a5
 3a0:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 3a4:	fff58593          	addi	a1,a1,-1
 3a8:	fff70713          	addi	a4,a4,-1
 3ac:	0005c683          	lbu	a3,0(a1)
 3b0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3b4:	fee798e3          	bne	a5,a4,3a4 <memmove+0x64>
 3b8:	fc1ff06f          	j	378 <memmove+0x38>

00000000000003bc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3bc:	ff010113          	addi	sp,sp,-16
 3c0:	00813423          	sd	s0,8(sp)
 3c4:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3c8:	04060463          	beqz	a2,410 <memcmp+0x54>
 3cc:	fff6069b          	addiw	a3,a2,-1
 3d0:	02069693          	slli	a3,a3,0x20
 3d4:	0206d693          	srli	a3,a3,0x20
 3d8:	00168693          	addi	a3,a3,1
 3dc:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 3e0:	00054783          	lbu	a5,0(a0)
 3e4:	0005c703          	lbu	a4,0(a1)
 3e8:	00e79c63          	bne	a5,a4,400 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 3ec:	00150513          	addi	a0,a0,1
    p2++;
 3f0:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
 3f4:	fed516e3          	bne	a0,a3,3e0 <memcmp+0x24>
  }
  return 0;
 3f8:	00000513          	li	a0,0
 3fc:	0080006f          	j	404 <memcmp+0x48>
      return *p1 - *p2;
 400:	40e7853b          	subw	a0,a5,a4
}
 404:	00813403          	ld	s0,8(sp)
 408:	01010113          	addi	sp,sp,16
 40c:	00008067          	ret
  return 0;
 410:	00000513          	li	a0,0
 414:	ff1ff06f          	j	404 <memcmp+0x48>

0000000000000418 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 418:	ff010113          	addi	sp,sp,-16
 41c:	00113423          	sd	ra,8(sp)
 420:	00813023          	sd	s0,0(sp)
 424:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
 428:	f19ff0ef          	jal	340 <memmove>
}
 42c:	00813083          	ld	ra,8(sp)
 430:	00013403          	ld	s0,0(sp)
 434:	01010113          	addi	sp,sp,16
 438:	00008067          	ret

000000000000043c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 43c:	00100893          	li	a7,1
 ecall
 440:	00000073          	ecall
 ret
 444:	00008067          	ret

0000000000000448 <exit>:
.global exit
exit:
 li a7, SYS_exit
 448:	00200893          	li	a7,2
 ecall
 44c:	00000073          	ecall
 ret
 450:	00008067          	ret

0000000000000454 <wait>:
.global wait
wait:
 li a7, SYS_wait
 454:	00300893          	li	a7,3
 ecall
 458:	00000073          	ecall
 ret
 45c:	00008067          	ret

0000000000000460 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 460:	00400893          	li	a7,4
 ecall
 464:	00000073          	ecall
 ret
 468:	00008067          	ret

000000000000046c <read>:
.global read
read:
 li a7, SYS_read
 46c:	00500893          	li	a7,5
 ecall
 470:	00000073          	ecall
 ret
 474:	00008067          	ret

0000000000000478 <write>:
.global write
write:
 li a7, SYS_write
 478:	01000893          	li	a7,16
 ecall
 47c:	00000073          	ecall
 ret
 480:	00008067          	ret

0000000000000484 <close>:
.global close
close:
 li a7, SYS_close
 484:	01500893          	li	a7,21
 ecall
 488:	00000073          	ecall
 ret
 48c:	00008067          	ret

0000000000000490 <kill>:
.global kill
kill:
 li a7, SYS_kill
 490:	00600893          	li	a7,6
 ecall
 494:	00000073          	ecall
 ret
 498:	00008067          	ret

000000000000049c <exec>:
.global exec
exec:
 li a7, SYS_exec
 49c:	00700893          	li	a7,7
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	00008067          	ret

00000000000004a8 <open>:
.global open
open:
 li a7, SYS_open
 4a8:	00f00893          	li	a7,15
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	00008067          	ret

00000000000004b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b4:	01100893          	li	a7,17
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	00008067          	ret

00000000000004c0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4c0:	01200893          	li	a7,18
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	00008067          	ret

00000000000004cc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4cc:	00800893          	li	a7,8
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	00008067          	ret

00000000000004d8 <link>:
.global link
link:
 li a7, SYS_link
 4d8:	01300893          	li	a7,19
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	00008067          	ret

00000000000004e4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4e4:	01400893          	li	a7,20
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	00008067          	ret

00000000000004f0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4f0:	00900893          	li	a7,9
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	00008067          	ret

00000000000004fc <dup>:
.global dup
dup:
 li a7, SYS_dup
 4fc:	00a00893          	li	a7,10
 ecall
 500:	00000073          	ecall
 ret
 504:	00008067          	ret

0000000000000508 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 508:	00b00893          	li	a7,11
 ecall
 50c:	00000073          	ecall
 ret
 510:	00008067          	ret

0000000000000514 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 514:	00c00893          	li	a7,12
 ecall
 518:	00000073          	ecall
 ret
 51c:	00008067          	ret

0000000000000520 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 520:	00d00893          	li	a7,13
 ecall
 524:	00000073          	ecall
 ret
 528:	00008067          	ret

000000000000052c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 52c:	00e00893          	li	a7,14
 ecall
 530:	00000073          	ecall
 ret
 534:	00008067          	ret

0000000000000538 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 538:	fe010113          	addi	sp,sp,-32
 53c:	00113c23          	sd	ra,24(sp)
 540:	00813823          	sd	s0,16(sp)
 544:	02010413          	addi	s0,sp,32
 548:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 54c:	00100613          	li	a2,1
 550:	fef40593          	addi	a1,s0,-17
 554:	f25ff0ef          	jal	478 <write>
}
 558:	01813083          	ld	ra,24(sp)
 55c:	01013403          	ld	s0,16(sp)
 560:	02010113          	addi	sp,sp,32
 564:	00008067          	ret

0000000000000568 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 568:	fc010113          	addi	sp,sp,-64
 56c:	02113c23          	sd	ra,56(sp)
 570:	02813823          	sd	s0,48(sp)
 574:	02913423          	sd	s1,40(sp)
 578:	04010413          	addi	s0,sp,64
 57c:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 580:	00068463          	beqz	a3,588 <printint+0x20>
 584:	0c05c263          	bltz	a1,648 <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 588:	0005859b          	sext.w	a1,a1
  neg = 0;
 58c:	00000893          	li	a7,0
 590:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 594:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 598:	0006061b          	sext.w	a2,a2
 59c:	00000517          	auipc	a0,0x0
 5a0:	72450513          	addi	a0,a0,1828 # cc0 <digits>
 5a4:	00070813          	mv	a6,a4
 5a8:	0017071b          	addiw	a4,a4,1
 5ac:	02c5f7bb          	remuw	a5,a1,a2
 5b0:	02079793          	slli	a5,a5,0x20
 5b4:	0207d793          	srli	a5,a5,0x20
 5b8:	00f507b3          	add	a5,a0,a5
 5bc:	0007c783          	lbu	a5,0(a5)
 5c0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5c4:	0005879b          	sext.w	a5,a1
 5c8:	02c5d5bb          	divuw	a1,a1,a2
 5cc:	00168693          	addi	a3,a3,1
 5d0:	fcc7fae3          	bgeu	a5,a2,5a4 <printint+0x3c>
  if(neg)
 5d4:	00088c63          	beqz	a7,5ec <printint+0x84>
    buf[i++] = '-';
 5d8:	fd070793          	addi	a5,a4,-48
 5dc:	00878733          	add	a4,a5,s0
 5e0:	02d00793          	li	a5,45
 5e4:	fef70823          	sb	a5,-16(a4)
 5e8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5ec:	04e05463          	blez	a4,634 <printint+0xcc>
 5f0:	03213023          	sd	s2,32(sp)
 5f4:	01313c23          	sd	s3,24(sp)
 5f8:	fc040793          	addi	a5,s0,-64
 5fc:	00e78933          	add	s2,a5,a4
 600:	fff78993          	addi	s3,a5,-1
 604:	00e989b3          	add	s3,s3,a4
 608:	fff7071b          	addiw	a4,a4,-1
 60c:	02071713          	slli	a4,a4,0x20
 610:	02075713          	srli	a4,a4,0x20
 614:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 618:	fff94583          	lbu	a1,-1(s2)
 61c:	00048513          	mv	a0,s1
 620:	f19ff0ef          	jal	538 <putc>
  while(--i >= 0)
 624:	fff90913          	addi	s2,s2,-1
 628:	ff3918e3          	bne	s2,s3,618 <printint+0xb0>
 62c:	02013903          	ld	s2,32(sp)
 630:	01813983          	ld	s3,24(sp)
}
 634:	03813083          	ld	ra,56(sp)
 638:	03013403          	ld	s0,48(sp)
 63c:	02813483          	ld	s1,40(sp)
 640:	04010113          	addi	sp,sp,64
 644:	00008067          	ret
    x = -xx;
 648:	40b005bb          	negw	a1,a1
    neg = 1;
 64c:	00100893          	li	a7,1
    x = -xx;
 650:	f41ff06f          	j	590 <printint+0x28>

0000000000000654 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 654:	fa010113          	addi	sp,sp,-96
 658:	04113c23          	sd	ra,88(sp)
 65c:	04813823          	sd	s0,80(sp)
 660:	05213023          	sd	s2,64(sp)
 664:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 668:	0005c903          	lbu	s2,0(a1)
 66c:	36090463          	beqz	s2,9d4 <vprintf+0x380>
 670:	04913423          	sd	s1,72(sp)
 674:	03313c23          	sd	s3,56(sp)
 678:	03413823          	sd	s4,48(sp)
 67c:	03513423          	sd	s5,40(sp)
 680:	03613023          	sd	s6,32(sp)
 684:	01713c23          	sd	s7,24(sp)
 688:	01813823          	sd	s8,16(sp)
 68c:	01913423          	sd	s9,8(sp)
 690:	00050b13          	mv	s6,a0
 694:	00058a13          	mv	s4,a1
 698:	00060b93          	mv	s7,a2
  state = 0;
 69c:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
 6a0:	00000493          	li	s1,0
 6a4:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6a8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6ac:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6b0:	06c00c93          	li	s9,108
 6b4:	02c0006f          	j	6e0 <vprintf+0x8c>
        putc(fd, c0);
 6b8:	00090593          	mv	a1,s2
 6bc:	000b0513          	mv	a0,s6
 6c0:	e79ff0ef          	jal	538 <putc>
 6c4:	0080006f          	j	6cc <vprintf+0x78>
    } else if(state == '%'){
 6c8:	03598663          	beq	s3,s5,6f4 <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
 6cc:	0014849b          	addiw	s1,s1,1
 6d0:	00048713          	mv	a4,s1
 6d4:	009a07b3          	add	a5,s4,s1
 6d8:	0007c903          	lbu	s2,0(a5)
 6dc:	2c090c63          	beqz	s2,9b4 <vprintf+0x360>
    c0 = fmt[i] & 0xff;
 6e0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6e4:	fe0992e3          	bnez	s3,6c8 <vprintf+0x74>
      if(c0 == '%'){
 6e8:	fd5798e3          	bne	a5,s5,6b8 <vprintf+0x64>
        state = '%';
 6ec:	00078993          	mv	s3,a5
 6f0:	fddff06f          	j	6cc <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
 6f4:	00ea06b3          	add	a3,s4,a4
 6f8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6fc:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 700:	00068663          	beqz	a3,70c <vprintf+0xb8>
 704:	00ea0733          	add	a4,s4,a4
 708:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 70c:	05878263          	beq	a5,s8,750 <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
 710:	07978263          	beq	a5,s9,774 <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 714:	07500713          	li	a4,117
 718:	12e78663          	beq	a5,a4,844 <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 71c:	07800713          	li	a4,120
 720:	18e78c63          	beq	a5,a4,8b8 <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 724:	07000713          	li	a4,112
 728:	1ce78e63          	beq	a5,a4,904 <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 72c:	07300713          	li	a4,115
 730:	22e78a63          	beq	a5,a4,964 <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 734:	02500713          	li	a4,37
 738:	04e79e63          	bne	a5,a4,794 <vprintf+0x140>
        putc(fd, '%');
 73c:	02500593          	li	a1,37
 740:	000b0513          	mv	a0,s6
 744:	df5ff0ef          	jal	538 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 748:	00000993          	li	s3,0
 74c:	f81ff06f          	j	6cc <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
 750:	008b8913          	addi	s2,s7,8
 754:	00100693          	li	a3,1
 758:	00a00613          	li	a2,10
 75c:	000ba583          	lw	a1,0(s7)
 760:	000b0513          	mv	a0,s6
 764:	e05ff0ef          	jal	568 <printint>
 768:	00090b93          	mv	s7,s2
      state = 0;
 76c:	00000993          	li	s3,0
 770:	f5dff06f          	j	6cc <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
 774:	06400793          	li	a5,100
 778:	02f68e63          	beq	a3,a5,7b4 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 77c:	06c00793          	li	a5,108
 780:	04f68e63          	beq	a3,a5,7dc <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
 784:	07500793          	li	a5,117
 788:	0ef68063          	beq	a3,a5,868 <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
 78c:	07800793          	li	a5,120
 790:	14f68663          	beq	a3,a5,8dc <vprintf+0x288>
        putc(fd, '%');
 794:	02500593          	li	a1,37
 798:	000b0513          	mv	a0,s6
 79c:	d9dff0ef          	jal	538 <putc>
        putc(fd, c0);
 7a0:	00090593          	mv	a1,s2
 7a4:	000b0513          	mv	a0,s6
 7a8:	d91ff0ef          	jal	538 <putc>
      state = 0;
 7ac:	00000993          	li	s3,0
 7b0:	f1dff06f          	j	6cc <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b4:	008b8913          	addi	s2,s7,8
 7b8:	00100693          	li	a3,1
 7bc:	00a00613          	li	a2,10
 7c0:	000ba583          	lw	a1,0(s7)
 7c4:	000b0513          	mv	a0,s6
 7c8:	da1ff0ef          	jal	568 <printint>
        i += 1;
 7cc:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d0:	00090b93          	mv	s7,s2
      state = 0;
 7d4:	00000993          	li	s3,0
        i += 1;
 7d8:	ef5ff06f          	j	6cc <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7dc:	06400793          	li	a5,100
 7e0:	02f60e63          	beq	a2,a5,81c <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7e4:	07500793          	li	a5,117
 7e8:	0af60463          	beq	a2,a5,890 <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7ec:	07800793          	li	a5,120
 7f0:	faf612e3          	bne	a2,a5,794 <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f4:	008b8913          	addi	s2,s7,8
 7f8:	00000693          	li	a3,0
 7fc:	01000613          	li	a2,16
 800:	000ba583          	lw	a1,0(s7)
 804:	000b0513          	mv	a0,s6
 808:	d61ff0ef          	jal	568 <printint>
        i += 2;
 80c:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 810:	00090b93          	mv	s7,s2
      state = 0;
 814:	00000993          	li	s3,0
        i += 2;
 818:	eb5ff06f          	j	6cc <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 81c:	008b8913          	addi	s2,s7,8
 820:	00100693          	li	a3,1
 824:	00a00613          	li	a2,10
 828:	000ba583          	lw	a1,0(s7)
 82c:	000b0513          	mv	a0,s6
 830:	d39ff0ef          	jal	568 <printint>
        i += 2;
 834:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 838:	00090b93          	mv	s7,s2
      state = 0;
 83c:	00000993          	li	s3,0
        i += 2;
 840:	e8dff06f          	j	6cc <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
 844:	008b8913          	addi	s2,s7,8
 848:	00000693          	li	a3,0
 84c:	00a00613          	li	a2,10
 850:	000ba583          	lw	a1,0(s7)
 854:	000b0513          	mv	a0,s6
 858:	d11ff0ef          	jal	568 <printint>
 85c:	00090b93          	mv	s7,s2
      state = 0;
 860:	00000993          	li	s3,0
 864:	e69ff06f          	j	6cc <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 868:	008b8913          	addi	s2,s7,8
 86c:	00000693          	li	a3,0
 870:	00a00613          	li	a2,10
 874:	000ba583          	lw	a1,0(s7)
 878:	000b0513          	mv	a0,s6
 87c:	cedff0ef          	jal	568 <printint>
        i += 1;
 880:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 884:	00090b93          	mv	s7,s2
      state = 0;
 888:	00000993          	li	s3,0
        i += 1;
 88c:	e41ff06f          	j	6cc <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 890:	008b8913          	addi	s2,s7,8
 894:	00000693          	li	a3,0
 898:	00a00613          	li	a2,10
 89c:	000ba583          	lw	a1,0(s7)
 8a0:	000b0513          	mv	a0,s6
 8a4:	cc5ff0ef          	jal	568 <printint>
        i += 2;
 8a8:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8ac:	00090b93          	mv	s7,s2
      state = 0;
 8b0:	00000993          	li	s3,0
        i += 2;
 8b4:	e19ff06f          	j	6cc <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
 8b8:	008b8913          	addi	s2,s7,8
 8bc:	00000693          	li	a3,0
 8c0:	01000613          	li	a2,16
 8c4:	000ba583          	lw	a1,0(s7)
 8c8:	000b0513          	mv	a0,s6
 8cc:	c9dff0ef          	jal	568 <printint>
 8d0:	00090b93          	mv	s7,s2
      state = 0;
 8d4:	00000993          	li	s3,0
 8d8:	df5ff06f          	j	6cc <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8dc:	008b8913          	addi	s2,s7,8
 8e0:	00000693          	li	a3,0
 8e4:	01000613          	li	a2,16
 8e8:	000ba583          	lw	a1,0(s7)
 8ec:	000b0513          	mv	a0,s6
 8f0:	c79ff0ef          	jal	568 <printint>
        i += 1;
 8f4:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8f8:	00090b93          	mv	s7,s2
      state = 0;
 8fc:	00000993          	li	s3,0
        i += 1;
 900:	dcdff06f          	j	6cc <vprintf+0x78>
 904:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 908:	008b8d13          	addi	s10,s7,8
 90c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 910:	03000593          	li	a1,48
 914:	000b0513          	mv	a0,s6
 918:	c21ff0ef          	jal	538 <putc>
  putc(fd, 'x');
 91c:	07800593          	li	a1,120
 920:	000b0513          	mv	a0,s6
 924:	c15ff0ef          	jal	538 <putc>
 928:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 92c:	00000b97          	auipc	s7,0x0
 930:	394b8b93          	addi	s7,s7,916 # cc0 <digits>
 934:	03c9d793          	srli	a5,s3,0x3c
 938:	00fb87b3          	add	a5,s7,a5
 93c:	0007c583          	lbu	a1,0(a5)
 940:	000b0513          	mv	a0,s6
 944:	bf5ff0ef          	jal	538 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 948:	00499993          	slli	s3,s3,0x4
 94c:	fff9091b          	addiw	s2,s2,-1
 950:	fe0912e3          	bnez	s2,934 <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
 954:	000d0b93          	mv	s7,s10
      state = 0;
 958:	00000993          	li	s3,0
 95c:	00013d03          	ld	s10,0(sp)
 960:	d6dff06f          	j	6cc <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
 964:	008b8993          	addi	s3,s7,8
 968:	000bb903          	ld	s2,0(s7)
 96c:	02090663          	beqz	s2,998 <vprintf+0x344>
        for(; *s; s++)
 970:	00094583          	lbu	a1,0(s2)
 974:	02058a63          	beqz	a1,9a8 <vprintf+0x354>
          putc(fd, *s);
 978:	000b0513          	mv	a0,s6
 97c:	bbdff0ef          	jal	538 <putc>
        for(; *s; s++)
 980:	00190913          	addi	s2,s2,1
 984:	00094583          	lbu	a1,0(s2)
 988:	fe0598e3          	bnez	a1,978 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 98c:	00098b93          	mv	s7,s3
      state = 0;
 990:	00000993          	li	s3,0
 994:	d39ff06f          	j	6cc <vprintf+0x78>
          s = "(null)";
 998:	00000917          	auipc	s2,0x0
 99c:	32090913          	addi	s2,s2,800 # cb8 <malloc+0x18c>
        for(; *s; s++)
 9a0:	02800593          	li	a1,40
 9a4:	fd5ff06f          	j	978 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 9a8:	00098b93          	mv	s7,s3
      state = 0;
 9ac:	00000993          	li	s3,0
 9b0:	d1dff06f          	j	6cc <vprintf+0x78>
 9b4:	04813483          	ld	s1,72(sp)
 9b8:	03813983          	ld	s3,56(sp)
 9bc:	03013a03          	ld	s4,48(sp)
 9c0:	02813a83          	ld	s5,40(sp)
 9c4:	02013b03          	ld	s6,32(sp)
 9c8:	01813b83          	ld	s7,24(sp)
 9cc:	01013c03          	ld	s8,16(sp)
 9d0:	00813c83          	ld	s9,8(sp)
    }
  }
}
 9d4:	05813083          	ld	ra,88(sp)
 9d8:	05013403          	ld	s0,80(sp)
 9dc:	04013903          	ld	s2,64(sp)
 9e0:	06010113          	addi	sp,sp,96
 9e4:	00008067          	ret

00000000000009e8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9e8:	fb010113          	addi	sp,sp,-80
 9ec:	00113c23          	sd	ra,24(sp)
 9f0:	00813823          	sd	s0,16(sp)
 9f4:	02010413          	addi	s0,sp,32
 9f8:	00c43023          	sd	a2,0(s0)
 9fc:	00d43423          	sd	a3,8(s0)
 a00:	00e43823          	sd	a4,16(s0)
 a04:	00f43c23          	sd	a5,24(s0)
 a08:	03043023          	sd	a6,32(s0)
 a0c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a10:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a14:	00040613          	mv	a2,s0
 a18:	c3dff0ef          	jal	654 <vprintf>
}
 a1c:	01813083          	ld	ra,24(sp)
 a20:	01013403          	ld	s0,16(sp)
 a24:	05010113          	addi	sp,sp,80
 a28:	00008067          	ret

0000000000000a2c <printf>:

void
printf(const char *fmt, ...)
{
 a2c:	fa010113          	addi	sp,sp,-96
 a30:	00113c23          	sd	ra,24(sp)
 a34:	00813823          	sd	s0,16(sp)
 a38:	02010413          	addi	s0,sp,32
 a3c:	00b43423          	sd	a1,8(s0)
 a40:	00c43823          	sd	a2,16(s0)
 a44:	00d43c23          	sd	a3,24(s0)
 a48:	02e43023          	sd	a4,32(s0)
 a4c:	02f43423          	sd	a5,40(s0)
 a50:	03043823          	sd	a6,48(s0)
 a54:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a58:	00840613          	addi	a2,s0,8
 a5c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a60:	00050593          	mv	a1,a0
 a64:	00100513          	li	a0,1
 a68:	bedff0ef          	jal	654 <vprintf>
}
 a6c:	01813083          	ld	ra,24(sp)
 a70:	01013403          	ld	s0,16(sp)
 a74:	06010113          	addi	sp,sp,96
 a78:	00008067          	ret

0000000000000a7c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a7c:	ff010113          	addi	sp,sp,-16
 a80:	00813423          	sd	s0,8(sp)
 a84:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a88:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a8c:	00000797          	auipc	a5,0x0
 a90:	5747b783          	ld	a5,1396(a5) # 1000 <freep>
 a94:	0400006f          	j	ad4 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a98:	00862703          	lw	a4,8(a2)
 a9c:	00b7073b          	addw	a4,a4,a1
 aa0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 aa4:	0007b703          	ld	a4,0(a5)
 aa8:	00073603          	ld	a2,0(a4)
 aac:	0500006f          	j	afc <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ab0:	ff852703          	lw	a4,-8(a0)
 ab4:	00c7073b          	addw	a4,a4,a2
 ab8:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 abc:	ff053683          	ld	a3,-16(a0)
 ac0:	0540006f          	j	b14 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac4:	0007b703          	ld	a4,0(a5)
 ac8:	00e7e463          	bltu	a5,a4,ad0 <free+0x54>
 acc:	00e6ec63          	bltu	a3,a4,ae4 <free+0x68>
{
 ad0:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad4:	fed7f8e3          	bgeu	a5,a3,ac4 <free+0x48>
 ad8:	0007b703          	ld	a4,0(a5)
 adc:	00e6e463          	bltu	a3,a4,ae4 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ae0:	fee7e8e3          	bltu	a5,a4,ad0 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 ae4:	ff852583          	lw	a1,-8(a0)
 ae8:	0007b603          	ld	a2,0(a5)
 aec:	02059813          	slli	a6,a1,0x20
 af0:	01c85713          	srli	a4,a6,0x1c
 af4:	00e68733          	add	a4,a3,a4
 af8:	fae600e3          	beq	a2,a4,a98 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 afc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b00:	0087a603          	lw	a2,8(a5)
 b04:	02061593          	slli	a1,a2,0x20
 b08:	01c5d713          	srli	a4,a1,0x1c
 b0c:	00e78733          	add	a4,a5,a4
 b10:	fae680e3          	beq	a3,a4,ab0 <free+0x34>
    p->s.ptr = bp->s.ptr;
 b14:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b18:	00000717          	auipc	a4,0x0
 b1c:	4ef73423          	sd	a5,1256(a4) # 1000 <freep>
}
 b20:	00813403          	ld	s0,8(sp)
 b24:	01010113          	addi	sp,sp,16
 b28:	00008067          	ret

0000000000000b2c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b2c:	fc010113          	addi	sp,sp,-64
 b30:	02113c23          	sd	ra,56(sp)
 b34:	02813823          	sd	s0,48(sp)
 b38:	02913423          	sd	s1,40(sp)
 b3c:	01313c23          	sd	s3,24(sp)
 b40:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b44:	02051493          	slli	s1,a0,0x20
 b48:	0204d493          	srli	s1,s1,0x20
 b4c:	00f48493          	addi	s1,s1,15
 b50:	0044d493          	srli	s1,s1,0x4
 b54:	0014899b          	addiw	s3,s1,1
 b58:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
 b5c:	00000517          	auipc	a0,0x0
 b60:	4a453503          	ld	a0,1188(a0) # 1000 <freep>
 b64:	04050663          	beqz	a0,bb0 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b68:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b6c:	0087a703          	lw	a4,8(a5)
 b70:	0c977c63          	bgeu	a4,s1,c48 <malloc+0x11c>
 b74:	03213023          	sd	s2,32(sp)
 b78:	01413823          	sd	s4,16(sp)
 b7c:	01513423          	sd	s5,8(sp)
 b80:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
 b84:	00098a13          	mv	s4,s3
 b88:	0009871b          	sext.w	a4,s3
 b8c:	000016b7          	lui	a3,0x1
 b90:	00d77463          	bgeu	a4,a3,b98 <malloc+0x6c>
 b94:	00001a37          	lui	s4,0x1
 b98:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b9c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ba0:	00000917          	auipc	s2,0x0
 ba4:	46090913          	addi	s2,s2,1120 # 1000 <freep>
  if(p == (char*)-1)
 ba8:	fff00a93          	li	s5,-1
 bac:	05c0006f          	j	c08 <malloc+0xdc>
 bb0:	03213023          	sd	s2,32(sp)
 bb4:	01413823          	sd	s4,16(sp)
 bb8:	01513423          	sd	s5,8(sp)
 bbc:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 bc0:	00000797          	auipc	a5,0x0
 bc4:	45078793          	addi	a5,a5,1104 # 1010 <base>
 bc8:	00000717          	auipc	a4,0x0
 bcc:	42f73c23          	sd	a5,1080(a4) # 1000 <freep>
 bd0:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 bd4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bd8:	fadff06f          	j	b84 <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
 bdc:	0007b703          	ld	a4,0(a5)
 be0:	00e53023          	sd	a4,0(a0)
 be4:	0800006f          	j	c64 <malloc+0x138>
  hp->s.size = nu;
 be8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bec:	01050513          	addi	a0,a0,16
 bf0:	e8dff0ef          	jal	a7c <free>
  return freep;
 bf4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bf8:	08050863          	beqz	a0,c88 <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bfc:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c00:	0087a703          	lw	a4,8(a5)
 c04:	02977a63          	bgeu	a4,s1,c38 <malloc+0x10c>
    if(p == freep)
 c08:	00093703          	ld	a4,0(s2)
 c0c:	00078513          	mv	a0,a5
 c10:	fef716e3          	bne	a4,a5,bfc <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
 c14:	000a0513          	mv	a0,s4
 c18:	8fdff0ef          	jal	514 <sbrk>
  if(p == (char*)-1)
 c1c:	fd5516e3          	bne	a0,s5,be8 <malloc+0xbc>
        return 0;
 c20:	00000513          	li	a0,0
 c24:	02013903          	ld	s2,32(sp)
 c28:	01013a03          	ld	s4,16(sp)
 c2c:	00813a83          	ld	s5,8(sp)
 c30:	00013b03          	ld	s6,0(sp)
 c34:	03c0006f          	j	c70 <malloc+0x144>
 c38:	02013903          	ld	s2,32(sp)
 c3c:	01013a03          	ld	s4,16(sp)
 c40:	00813a83          	ld	s5,8(sp)
 c44:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
 c48:	f8e48ae3          	beq	s1,a4,bdc <malloc+0xb0>
        p->s.size -= nunits;
 c4c:	4137073b          	subw	a4,a4,s3
 c50:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 c54:	02071693          	slli	a3,a4,0x20
 c58:	01c6d713          	srli	a4,a3,0x1c
 c5c:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 c60:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c64:	00000717          	auipc	a4,0x0
 c68:	38a73e23          	sd	a0,924(a4) # 1000 <freep>
      return (void*)(p + 1);
 c6c:	01078513          	addi	a0,a5,16
  }
}
 c70:	03813083          	ld	ra,56(sp)
 c74:	03013403          	ld	s0,48(sp)
 c78:	02813483          	ld	s1,40(sp)
 c7c:	01813983          	ld	s3,24(sp)
 c80:	04010113          	addi	sp,sp,64
 c84:	00008067          	ret
 c88:	02013903          	ld	s2,32(sp)
 c8c:	01013a03          	ld	s4,16(sp)
 c90:	00813a83          	ld	s5,8(sp)
 c94:	00013b03          	ld	s6,0(sp)
 c98:	fd9ff06f          	j	c70 <malloc+0x144>
