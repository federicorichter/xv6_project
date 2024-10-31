
user/_echo:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	fc010113          	addi	sp,sp,-64
   4:	02113c23          	sd	ra,56(sp)
   8:	02813823          	sd	s0,48(sp)
   c:	02913423          	sd	s1,40(sp)
  10:	03213023          	sd	s2,32(sp)
  14:	01313c23          	sd	s3,24(sp)
  18:	01413823          	sd	s4,16(sp)
  1c:	01513423          	sd	s5,8(sp)
  20:	04010413          	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  24:	00100793          	li	a5,1
  28:	06a7dc63          	bge	a5,a0,a0 <main+0xa0>
  2c:	00858493          	addi	s1,a1,8
  30:	ffe5051b          	addiw	a0,a0,-2
  34:	02051793          	slli	a5,a0,0x20
  38:	01d7d513          	srli	a0,a5,0x1d
  3c:	00a48a33          	add	s4,s1,a0
  40:	01058593          	addi	a1,a1,16
  44:	00a589b3          	add	s3,a1,a0
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  48:	00001a97          	auipc	s5,0x1
  4c:	c88a8a93          	addi	s5,s5,-888 # cd0 <malloc+0x170>
  50:	01c0006f          	j	6c <main+0x6c>
  54:	00100613          	li	a2,1
  58:	000a8593          	mv	a1,s5
  5c:	00100513          	li	a0,1
  60:	44c000ef          	jal	4ac <write>
  for(i = 1; i < argc; i++){
  64:	00848493          	addi	s1,s1,8
  68:	03348c63          	beq	s1,s3,a0 <main+0xa0>
    write(1, argv[i], strlen(argv[i]));
  6c:	0004b903          	ld	s2,0(s1)
  70:	00090513          	mv	a0,s2
  74:	0c0000ef          	jal	134 <strlen>
  78:	0005061b          	sext.w	a2,a0
  7c:	00090593          	mv	a1,s2
  80:	00100513          	li	a0,1
  84:	428000ef          	jal	4ac <write>
    if(i + 1 < argc){
  88:	fd4496e3          	bne	s1,s4,54 <main+0x54>
    } else {
      write(1, "\n", 1);
  8c:	00100613          	li	a2,1
  90:	00001597          	auipc	a1,0x1
  94:	c4858593          	addi	a1,a1,-952 # cd8 <malloc+0x178>
  98:	00100513          	li	a0,1
  9c:	410000ef          	jal	4ac <write>
    }
  }
  exit(0);
  a0:	00000513          	li	a0,0
  a4:	3d8000ef          	jal	47c <exit>

00000000000000a8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  a8:	ff010113          	addi	sp,sp,-16
  ac:	00113423          	sd	ra,8(sp)
  b0:	00813023          	sd	s0,0(sp)
  b4:	01010413          	addi	s0,sp,16
  extern int main();
  main();
  b8:	f49ff0ef          	jal	0 <main>
  exit(0);
  bc:	00000513          	li	a0,0
  c0:	3bc000ef          	jal	47c <exit>

00000000000000c4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  c4:	ff010113          	addi	sp,sp,-16
  c8:	00813423          	sd	s0,8(sp)
  cc:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d0:	00050793          	mv	a5,a0
  d4:	00158593          	addi	a1,a1,1
  d8:	00178793          	addi	a5,a5,1
  dc:	fff5c703          	lbu	a4,-1(a1)
  e0:	fee78fa3          	sb	a4,-1(a5)
  e4:	fe0718e3          	bnez	a4,d4 <strcpy+0x10>
    ;
  return os;
}
  e8:	00813403          	ld	s0,8(sp)
  ec:	01010113          	addi	sp,sp,16
  f0:	00008067          	ret

00000000000000f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f4:	ff010113          	addi	sp,sp,-16
  f8:	00813423          	sd	s0,8(sp)
  fc:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
 100:	00054783          	lbu	a5,0(a0)
 104:	00078e63          	beqz	a5,120 <strcmp+0x2c>
 108:	0005c703          	lbu	a4,0(a1)
 10c:	00f71a63          	bne	a4,a5,120 <strcmp+0x2c>
    p++, q++;
 110:	00150513          	addi	a0,a0,1
 114:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
 118:	00054783          	lbu	a5,0(a0)
 11c:	fe0796e3          	bnez	a5,108 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 120:	0005c503          	lbu	a0,0(a1)
}
 124:	40a7853b          	subw	a0,a5,a0
 128:	00813403          	ld	s0,8(sp)
 12c:	01010113          	addi	sp,sp,16
 130:	00008067          	ret

0000000000000134 <strlen>:

uint
strlen(const char *s)
{
 134:	ff010113          	addi	sp,sp,-16
 138:	00813423          	sd	s0,8(sp)
 13c:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 140:	00054783          	lbu	a5,0(a0)
 144:	02078863          	beqz	a5,174 <strlen+0x40>
 148:	00150513          	addi	a0,a0,1
 14c:	00050793          	mv	a5,a0
 150:	00078693          	mv	a3,a5
 154:	00178793          	addi	a5,a5,1
 158:	fff7c703          	lbu	a4,-1(a5)
 15c:	fe071ae3          	bnez	a4,150 <strlen+0x1c>
 160:	40a6853b          	subw	a0,a3,a0
 164:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
 168:	00813403          	ld	s0,8(sp)
 16c:	01010113          	addi	sp,sp,16
 170:	00008067          	ret
  for(n = 0; s[n]; n++)
 174:	00000513          	li	a0,0
 178:	ff1ff06f          	j	168 <strlen+0x34>

000000000000017c <memset>:

void*
memset(void *dst, int c, uint n)
{
 17c:	ff010113          	addi	sp,sp,-16
 180:	00813423          	sd	s0,8(sp)
 184:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 188:	02060063          	beqz	a2,1a8 <memset+0x2c>
 18c:	00050793          	mv	a5,a0
 190:	02061613          	slli	a2,a2,0x20
 194:	02065613          	srli	a2,a2,0x20
 198:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 19c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a0:	00178793          	addi	a5,a5,1
 1a4:	fee79ce3          	bne	a5,a4,19c <memset+0x20>
  }
  return dst;
}
 1a8:	00813403          	ld	s0,8(sp)
 1ac:	01010113          	addi	sp,sp,16
 1b0:	00008067          	ret

00000000000001b4 <strchr>:

char*
strchr(const char *s, char c)
{
 1b4:	ff010113          	addi	sp,sp,-16
 1b8:	00813423          	sd	s0,8(sp)
 1bc:	01010413          	addi	s0,sp,16
  for(; *s; s++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	02078263          	beqz	a5,1e8 <strchr+0x34>
    if(*s == c)
 1c8:	00f58a63          	beq	a1,a5,1dc <strchr+0x28>
  for(; *s; s++)
 1cc:	00150513          	addi	a0,a0,1
 1d0:	00054783          	lbu	a5,0(a0)
 1d4:	fe079ae3          	bnez	a5,1c8 <strchr+0x14>
      return (char*)s;
  return 0;
 1d8:	00000513          	li	a0,0
}
 1dc:	00813403          	ld	s0,8(sp)
 1e0:	01010113          	addi	sp,sp,16
 1e4:	00008067          	ret
  return 0;
 1e8:	00000513          	li	a0,0
 1ec:	ff1ff06f          	j	1dc <strchr+0x28>

00000000000001f0 <gets>:

char*
gets(char *buf, int max)
{
 1f0:	fa010113          	addi	sp,sp,-96
 1f4:	04113c23          	sd	ra,88(sp)
 1f8:	04813823          	sd	s0,80(sp)
 1fc:	04913423          	sd	s1,72(sp)
 200:	05213023          	sd	s2,64(sp)
 204:	03313c23          	sd	s3,56(sp)
 208:	03413823          	sd	s4,48(sp)
 20c:	03513423          	sd	s5,40(sp)
 210:	03613023          	sd	s6,32(sp)
 214:	01713c23          	sd	s7,24(sp)
 218:	06010413          	addi	s0,sp,96
 21c:	00050b93          	mv	s7,a0
 220:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 224:	00050913          	mv	s2,a0
 228:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 22c:	00a00a93          	li	s5,10
 230:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 234:	00048993          	mv	s3,s1
 238:	0014849b          	addiw	s1,s1,1
 23c:	0344dc63          	bge	s1,s4,274 <gets+0x84>
    cc = read(0, &c, 1);
 240:	00100613          	li	a2,1
 244:	faf40593          	addi	a1,s0,-81
 248:	00000513          	li	a0,0
 24c:	254000ef          	jal	4a0 <read>
    if(cc < 1)
 250:	02a05263          	blez	a0,274 <gets+0x84>
    buf[i++] = c;
 254:	faf44783          	lbu	a5,-81(s0)
 258:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 25c:	01578a63          	beq	a5,s5,270 <gets+0x80>
 260:	00190913          	addi	s2,s2,1
 264:	fd6798e3          	bne	a5,s6,234 <gets+0x44>
    buf[i++] = c;
 268:	00048993          	mv	s3,s1
 26c:	0080006f          	j	274 <gets+0x84>
 270:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 274:	013b89b3          	add	s3,s7,s3
 278:	00098023          	sb	zero,0(s3)
  return buf;
}
 27c:	000b8513          	mv	a0,s7
 280:	05813083          	ld	ra,88(sp)
 284:	05013403          	ld	s0,80(sp)
 288:	04813483          	ld	s1,72(sp)
 28c:	04013903          	ld	s2,64(sp)
 290:	03813983          	ld	s3,56(sp)
 294:	03013a03          	ld	s4,48(sp)
 298:	02813a83          	ld	s5,40(sp)
 29c:	02013b03          	ld	s6,32(sp)
 2a0:	01813b83          	ld	s7,24(sp)
 2a4:	06010113          	addi	sp,sp,96
 2a8:	00008067          	ret

00000000000002ac <stat>:

int
stat(const char *n, struct stat *st)
{
 2ac:	fe010113          	addi	sp,sp,-32
 2b0:	00113c23          	sd	ra,24(sp)
 2b4:	00813823          	sd	s0,16(sp)
 2b8:	01213023          	sd	s2,0(sp)
 2bc:	02010413          	addi	s0,sp,32
 2c0:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c4:	00000593          	li	a1,0
 2c8:	214000ef          	jal	4dc <open>
  if(fd < 0)
 2cc:	02054e63          	bltz	a0,308 <stat+0x5c>
 2d0:	00913423          	sd	s1,8(sp)
 2d4:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d8:	00090593          	mv	a1,s2
 2dc:	224000ef          	jal	500 <fstat>
 2e0:	00050913          	mv	s2,a0
  close(fd);
 2e4:	00048513          	mv	a0,s1
 2e8:	1d0000ef          	jal	4b8 <close>
  return r;
 2ec:	00813483          	ld	s1,8(sp)
}
 2f0:	00090513          	mv	a0,s2
 2f4:	01813083          	ld	ra,24(sp)
 2f8:	01013403          	ld	s0,16(sp)
 2fc:	00013903          	ld	s2,0(sp)
 300:	02010113          	addi	sp,sp,32
 304:	00008067          	ret
    return -1;
 308:	fff00913          	li	s2,-1
 30c:	fe5ff06f          	j	2f0 <stat+0x44>

0000000000000310 <atoi>:

int
atoi(const char *s)
{
 310:	ff010113          	addi	sp,sp,-16
 314:	00813423          	sd	s0,8(sp)
 318:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31c:	00054683          	lbu	a3,0(a0)
 320:	fd06879b          	addiw	a5,a3,-48
 324:	0ff7f793          	zext.b	a5,a5
 328:	00900613          	li	a2,9
 32c:	04f66063          	bltu	a2,a5,36c <atoi+0x5c>
 330:	00050713          	mv	a4,a0
  n = 0;
 334:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 338:	00170713          	addi	a4,a4,1
 33c:	0025179b          	slliw	a5,a0,0x2
 340:	00a787bb          	addw	a5,a5,a0
 344:	0017979b          	slliw	a5,a5,0x1
 348:	00d787bb          	addw	a5,a5,a3
 34c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 350:	00074683          	lbu	a3,0(a4)
 354:	fd06879b          	addiw	a5,a3,-48
 358:	0ff7f793          	zext.b	a5,a5
 35c:	fcf67ee3          	bgeu	a2,a5,338 <atoi+0x28>
  return n;
}
 360:	00813403          	ld	s0,8(sp)
 364:	01010113          	addi	sp,sp,16
 368:	00008067          	ret
  n = 0;
 36c:	00000513          	li	a0,0
 370:	ff1ff06f          	j	360 <atoi+0x50>

0000000000000374 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 374:	ff010113          	addi	sp,sp,-16
 378:	00813423          	sd	s0,8(sp)
 37c:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 380:	02b57c63          	bgeu	a0,a1,3b8 <memmove+0x44>
    while(n-- > 0)
 384:	02c05463          	blez	a2,3ac <memmove+0x38>
 388:	02061613          	slli	a2,a2,0x20
 38c:	02065613          	srli	a2,a2,0x20
 390:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 394:	00050713          	mv	a4,a0
      *dst++ = *src++;
 398:	00158593          	addi	a1,a1,1
 39c:	00170713          	addi	a4,a4,1
 3a0:	fff5c683          	lbu	a3,-1(a1)
 3a4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3a8:	fef718e3          	bne	a4,a5,398 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3ac:	00813403          	ld	s0,8(sp)
 3b0:	01010113          	addi	sp,sp,16
 3b4:	00008067          	ret
    dst += n;
 3b8:	00c50733          	add	a4,a0,a2
    src += n;
 3bc:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 3c0:	fec056e3          	blez	a2,3ac <memmove+0x38>
 3c4:	fff6079b          	addiw	a5,a2,-1
 3c8:	02079793          	slli	a5,a5,0x20
 3cc:	0207d793          	srli	a5,a5,0x20
 3d0:	fff7c793          	not	a5,a5
 3d4:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 3d8:	fff58593          	addi	a1,a1,-1
 3dc:	fff70713          	addi	a4,a4,-1
 3e0:	0005c683          	lbu	a3,0(a1)
 3e4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3e8:	fee798e3          	bne	a5,a4,3d8 <memmove+0x64>
 3ec:	fc1ff06f          	j	3ac <memmove+0x38>

00000000000003f0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3f0:	ff010113          	addi	sp,sp,-16
 3f4:	00813423          	sd	s0,8(sp)
 3f8:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3fc:	04060463          	beqz	a2,444 <memcmp+0x54>
 400:	fff6069b          	addiw	a3,a2,-1
 404:	02069693          	slli	a3,a3,0x20
 408:	0206d693          	srli	a3,a3,0x20
 40c:	00168693          	addi	a3,a3,1
 410:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 414:	00054783          	lbu	a5,0(a0)
 418:	0005c703          	lbu	a4,0(a1)
 41c:	00e79c63          	bne	a5,a4,434 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 420:	00150513          	addi	a0,a0,1
    p2++;
 424:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
 428:	fed516e3          	bne	a0,a3,414 <memcmp+0x24>
  }
  return 0;
 42c:	00000513          	li	a0,0
 430:	0080006f          	j	438 <memcmp+0x48>
      return *p1 - *p2;
 434:	40e7853b          	subw	a0,a5,a4
}
 438:	00813403          	ld	s0,8(sp)
 43c:	01010113          	addi	sp,sp,16
 440:	00008067          	ret
  return 0;
 444:	00000513          	li	a0,0
 448:	ff1ff06f          	j	438 <memcmp+0x48>

000000000000044c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 44c:	ff010113          	addi	sp,sp,-16
 450:	00113423          	sd	ra,8(sp)
 454:	00813023          	sd	s0,0(sp)
 458:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
 45c:	f19ff0ef          	jal	374 <memmove>
}
 460:	00813083          	ld	ra,8(sp)
 464:	00013403          	ld	s0,0(sp)
 468:	01010113          	addi	sp,sp,16
 46c:	00008067          	ret

0000000000000470 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 470:	00100893          	li	a7,1
 ecall
 474:	00000073          	ecall
 ret
 478:	00008067          	ret

000000000000047c <exit>:
.global exit
exit:
 li a7, SYS_exit
 47c:	00200893          	li	a7,2
 ecall
 480:	00000073          	ecall
 ret
 484:	00008067          	ret

0000000000000488 <wait>:
.global wait
wait:
 li a7, SYS_wait
 488:	00300893          	li	a7,3
 ecall
 48c:	00000073          	ecall
 ret
 490:	00008067          	ret

0000000000000494 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 494:	00400893          	li	a7,4
 ecall
 498:	00000073          	ecall
 ret
 49c:	00008067          	ret

00000000000004a0 <read>:
.global read
read:
 li a7, SYS_read
 4a0:	00500893          	li	a7,5
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	00008067          	ret

00000000000004ac <write>:
.global write
write:
 li a7, SYS_write
 4ac:	01000893          	li	a7,16
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	00008067          	ret

00000000000004b8 <close>:
.global close
close:
 li a7, SYS_close
 4b8:	01500893          	li	a7,21
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	00008067          	ret

00000000000004c4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4c4:	00600893          	li	a7,6
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	00008067          	ret

00000000000004d0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4d0:	00700893          	li	a7,7
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	00008067          	ret

00000000000004dc <open>:
.global open
open:
 li a7, SYS_open
 4dc:	00f00893          	li	a7,15
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	00008067          	ret

00000000000004e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4e8:	01100893          	li	a7,17
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	00008067          	ret

00000000000004f4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4f4:	01200893          	li	a7,18
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	00008067          	ret

0000000000000500 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 500:	00800893          	li	a7,8
 ecall
 504:	00000073          	ecall
 ret
 508:	00008067          	ret

000000000000050c <link>:
.global link
link:
 li a7, SYS_link
 50c:	01300893          	li	a7,19
 ecall
 510:	00000073          	ecall
 ret
 514:	00008067          	ret

0000000000000518 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 518:	01400893          	li	a7,20
 ecall
 51c:	00000073          	ecall
 ret
 520:	00008067          	ret

0000000000000524 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 524:	00900893          	li	a7,9
 ecall
 528:	00000073          	ecall
 ret
 52c:	00008067          	ret

0000000000000530 <dup>:
.global dup
dup:
 li a7, SYS_dup
 530:	00a00893          	li	a7,10
 ecall
 534:	00000073          	ecall
 ret
 538:	00008067          	ret

000000000000053c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 53c:	00b00893          	li	a7,11
 ecall
 540:	00000073          	ecall
 ret
 544:	00008067          	ret

0000000000000548 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 548:	00c00893          	li	a7,12
 ecall
 54c:	00000073          	ecall
 ret
 550:	00008067          	ret

0000000000000554 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 554:	00d00893          	li	a7,13
 ecall
 558:	00000073          	ecall
 ret
 55c:	00008067          	ret

0000000000000560 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 560:	00e00893          	li	a7,14
 ecall
 564:	00000073          	ecall
 ret
 568:	00008067          	ret

000000000000056c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 56c:	fe010113          	addi	sp,sp,-32
 570:	00113c23          	sd	ra,24(sp)
 574:	00813823          	sd	s0,16(sp)
 578:	02010413          	addi	s0,sp,32
 57c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 580:	00100613          	li	a2,1
 584:	fef40593          	addi	a1,s0,-17
 588:	f25ff0ef          	jal	4ac <write>
}
 58c:	01813083          	ld	ra,24(sp)
 590:	01013403          	ld	s0,16(sp)
 594:	02010113          	addi	sp,sp,32
 598:	00008067          	ret

000000000000059c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 59c:	fc010113          	addi	sp,sp,-64
 5a0:	02113c23          	sd	ra,56(sp)
 5a4:	02813823          	sd	s0,48(sp)
 5a8:	02913423          	sd	s1,40(sp)
 5ac:	04010413          	addi	s0,sp,64
 5b0:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5b4:	00068463          	beqz	a3,5bc <printint+0x20>
 5b8:	0c05c263          	bltz	a1,67c <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5bc:	0005859b          	sext.w	a1,a1
  neg = 0;
 5c0:	00000893          	li	a7,0
 5c4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5c8:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5cc:	0006061b          	sext.w	a2,a2
 5d0:	00000517          	auipc	a0,0x0
 5d4:	71850513          	addi	a0,a0,1816 # ce8 <digits>
 5d8:	00070813          	mv	a6,a4
 5dc:	0017071b          	addiw	a4,a4,1
 5e0:	02c5f7bb          	remuw	a5,a1,a2
 5e4:	02079793          	slli	a5,a5,0x20
 5e8:	0207d793          	srli	a5,a5,0x20
 5ec:	00f507b3          	add	a5,a0,a5
 5f0:	0007c783          	lbu	a5,0(a5)
 5f4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5f8:	0005879b          	sext.w	a5,a1
 5fc:	02c5d5bb          	divuw	a1,a1,a2
 600:	00168693          	addi	a3,a3,1
 604:	fcc7fae3          	bgeu	a5,a2,5d8 <printint+0x3c>
  if(neg)
 608:	00088c63          	beqz	a7,620 <printint+0x84>
    buf[i++] = '-';
 60c:	fd070793          	addi	a5,a4,-48
 610:	00878733          	add	a4,a5,s0
 614:	02d00793          	li	a5,45
 618:	fef70823          	sb	a5,-16(a4)
 61c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 620:	04e05463          	blez	a4,668 <printint+0xcc>
 624:	03213023          	sd	s2,32(sp)
 628:	01313c23          	sd	s3,24(sp)
 62c:	fc040793          	addi	a5,s0,-64
 630:	00e78933          	add	s2,a5,a4
 634:	fff78993          	addi	s3,a5,-1
 638:	00e989b3          	add	s3,s3,a4
 63c:	fff7071b          	addiw	a4,a4,-1
 640:	02071713          	slli	a4,a4,0x20
 644:	02075713          	srli	a4,a4,0x20
 648:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 64c:	fff94583          	lbu	a1,-1(s2)
 650:	00048513          	mv	a0,s1
 654:	f19ff0ef          	jal	56c <putc>
  while(--i >= 0)
 658:	fff90913          	addi	s2,s2,-1
 65c:	ff3918e3          	bne	s2,s3,64c <printint+0xb0>
 660:	02013903          	ld	s2,32(sp)
 664:	01813983          	ld	s3,24(sp)
}
 668:	03813083          	ld	ra,56(sp)
 66c:	03013403          	ld	s0,48(sp)
 670:	02813483          	ld	s1,40(sp)
 674:	04010113          	addi	sp,sp,64
 678:	00008067          	ret
    x = -xx;
 67c:	40b005bb          	negw	a1,a1
    neg = 1;
 680:	00100893          	li	a7,1
    x = -xx;
 684:	f41ff06f          	j	5c4 <printint+0x28>

0000000000000688 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 688:	fa010113          	addi	sp,sp,-96
 68c:	04113c23          	sd	ra,88(sp)
 690:	04813823          	sd	s0,80(sp)
 694:	05213023          	sd	s2,64(sp)
 698:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 69c:	0005c903          	lbu	s2,0(a1)
 6a0:	36090463          	beqz	s2,a08 <vprintf+0x380>
 6a4:	04913423          	sd	s1,72(sp)
 6a8:	03313c23          	sd	s3,56(sp)
 6ac:	03413823          	sd	s4,48(sp)
 6b0:	03513423          	sd	s5,40(sp)
 6b4:	03613023          	sd	s6,32(sp)
 6b8:	01713c23          	sd	s7,24(sp)
 6bc:	01813823          	sd	s8,16(sp)
 6c0:	01913423          	sd	s9,8(sp)
 6c4:	00050b13          	mv	s6,a0
 6c8:	00058a13          	mv	s4,a1
 6cc:	00060b93          	mv	s7,a2
  state = 0;
 6d0:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
 6d4:	00000493          	li	s1,0
 6d8:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6dc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6e0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6e4:	06c00c93          	li	s9,108
 6e8:	02c0006f          	j	714 <vprintf+0x8c>
        putc(fd, c0);
 6ec:	00090593          	mv	a1,s2
 6f0:	000b0513          	mv	a0,s6
 6f4:	e79ff0ef          	jal	56c <putc>
 6f8:	0080006f          	j	700 <vprintf+0x78>
    } else if(state == '%'){
 6fc:	03598663          	beq	s3,s5,728 <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
 700:	0014849b          	addiw	s1,s1,1
 704:	00048713          	mv	a4,s1
 708:	009a07b3          	add	a5,s4,s1
 70c:	0007c903          	lbu	s2,0(a5)
 710:	2c090c63          	beqz	s2,9e8 <vprintf+0x360>
    c0 = fmt[i] & 0xff;
 714:	0009079b          	sext.w	a5,s2
    if(state == 0){
 718:	fe0992e3          	bnez	s3,6fc <vprintf+0x74>
      if(c0 == '%'){
 71c:	fd5798e3          	bne	a5,s5,6ec <vprintf+0x64>
        state = '%';
 720:	00078993          	mv	s3,a5
 724:	fddff06f          	j	700 <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
 728:	00ea06b3          	add	a3,s4,a4
 72c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 730:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 734:	00068663          	beqz	a3,740 <vprintf+0xb8>
 738:	00ea0733          	add	a4,s4,a4
 73c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 740:	05878263          	beq	a5,s8,784 <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
 744:	07978263          	beq	a5,s9,7a8 <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 748:	07500713          	li	a4,117
 74c:	12e78663          	beq	a5,a4,878 <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 750:	07800713          	li	a4,120
 754:	18e78c63          	beq	a5,a4,8ec <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 758:	07000713          	li	a4,112
 75c:	1ce78e63          	beq	a5,a4,938 <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 760:	07300713          	li	a4,115
 764:	22e78a63          	beq	a5,a4,998 <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 768:	02500713          	li	a4,37
 76c:	04e79e63          	bne	a5,a4,7c8 <vprintf+0x140>
        putc(fd, '%');
 770:	02500593          	li	a1,37
 774:	000b0513          	mv	a0,s6
 778:	df5ff0ef          	jal	56c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 77c:	00000993          	li	s3,0
 780:	f81ff06f          	j	700 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
 784:	008b8913          	addi	s2,s7,8
 788:	00100693          	li	a3,1
 78c:	00a00613          	li	a2,10
 790:	000ba583          	lw	a1,0(s7)
 794:	000b0513          	mv	a0,s6
 798:	e05ff0ef          	jal	59c <printint>
 79c:	00090b93          	mv	s7,s2
      state = 0;
 7a0:	00000993          	li	s3,0
 7a4:	f5dff06f          	j	700 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
 7a8:	06400793          	li	a5,100
 7ac:	02f68e63          	beq	a3,a5,7e8 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7b0:	06c00793          	li	a5,108
 7b4:	04f68e63          	beq	a3,a5,810 <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
 7b8:	07500793          	li	a5,117
 7bc:	0ef68063          	beq	a3,a5,89c <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
 7c0:	07800793          	li	a5,120
 7c4:	14f68663          	beq	a3,a5,910 <vprintf+0x288>
        putc(fd, '%');
 7c8:	02500593          	li	a1,37
 7cc:	000b0513          	mv	a0,s6
 7d0:	d9dff0ef          	jal	56c <putc>
        putc(fd, c0);
 7d4:	00090593          	mv	a1,s2
 7d8:	000b0513          	mv	a0,s6
 7dc:	d91ff0ef          	jal	56c <putc>
      state = 0;
 7e0:	00000993          	li	s3,0
 7e4:	f1dff06f          	j	700 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7e8:	008b8913          	addi	s2,s7,8
 7ec:	00100693          	li	a3,1
 7f0:	00a00613          	li	a2,10
 7f4:	000ba583          	lw	a1,0(s7)
 7f8:	000b0513          	mv	a0,s6
 7fc:	da1ff0ef          	jal	59c <printint>
        i += 1;
 800:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 804:	00090b93          	mv	s7,s2
      state = 0;
 808:	00000993          	li	s3,0
        i += 1;
 80c:	ef5ff06f          	j	700 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 810:	06400793          	li	a5,100
 814:	02f60e63          	beq	a2,a5,850 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 818:	07500793          	li	a5,117
 81c:	0af60463          	beq	a2,a5,8c4 <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 820:	07800793          	li	a5,120
 824:	faf612e3          	bne	a2,a5,7c8 <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
 828:	008b8913          	addi	s2,s7,8
 82c:	00000693          	li	a3,0
 830:	01000613          	li	a2,16
 834:	000ba583          	lw	a1,0(s7)
 838:	000b0513          	mv	a0,s6
 83c:	d61ff0ef          	jal	59c <printint>
        i += 2;
 840:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 844:	00090b93          	mv	s7,s2
      state = 0;
 848:	00000993          	li	s3,0
        i += 2;
 84c:	eb5ff06f          	j	700 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 850:	008b8913          	addi	s2,s7,8
 854:	00100693          	li	a3,1
 858:	00a00613          	li	a2,10
 85c:	000ba583          	lw	a1,0(s7)
 860:	000b0513          	mv	a0,s6
 864:	d39ff0ef          	jal	59c <printint>
        i += 2;
 868:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 86c:	00090b93          	mv	s7,s2
      state = 0;
 870:	00000993          	li	s3,0
        i += 2;
 874:	e8dff06f          	j	700 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
 878:	008b8913          	addi	s2,s7,8
 87c:	00000693          	li	a3,0
 880:	00a00613          	li	a2,10
 884:	000ba583          	lw	a1,0(s7)
 888:	000b0513          	mv	a0,s6
 88c:	d11ff0ef          	jal	59c <printint>
 890:	00090b93          	mv	s7,s2
      state = 0;
 894:	00000993          	li	s3,0
 898:	e69ff06f          	j	700 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 89c:	008b8913          	addi	s2,s7,8
 8a0:	00000693          	li	a3,0
 8a4:	00a00613          	li	a2,10
 8a8:	000ba583          	lw	a1,0(s7)
 8ac:	000b0513          	mv	a0,s6
 8b0:	cedff0ef          	jal	59c <printint>
        i += 1;
 8b4:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8b8:	00090b93          	mv	s7,s2
      state = 0;
 8bc:	00000993          	li	s3,0
        i += 1;
 8c0:	e41ff06f          	j	700 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8c4:	008b8913          	addi	s2,s7,8
 8c8:	00000693          	li	a3,0
 8cc:	00a00613          	li	a2,10
 8d0:	000ba583          	lw	a1,0(s7)
 8d4:	000b0513          	mv	a0,s6
 8d8:	cc5ff0ef          	jal	59c <printint>
        i += 2;
 8dc:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8e0:	00090b93          	mv	s7,s2
      state = 0;
 8e4:	00000993          	li	s3,0
        i += 2;
 8e8:	e19ff06f          	j	700 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
 8ec:	008b8913          	addi	s2,s7,8
 8f0:	00000693          	li	a3,0
 8f4:	01000613          	li	a2,16
 8f8:	000ba583          	lw	a1,0(s7)
 8fc:	000b0513          	mv	a0,s6
 900:	c9dff0ef          	jal	59c <printint>
 904:	00090b93          	mv	s7,s2
      state = 0;
 908:	00000993          	li	s3,0
 90c:	df5ff06f          	j	700 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
 910:	008b8913          	addi	s2,s7,8
 914:	00000693          	li	a3,0
 918:	01000613          	li	a2,16
 91c:	000ba583          	lw	a1,0(s7)
 920:	000b0513          	mv	a0,s6
 924:	c79ff0ef          	jal	59c <printint>
        i += 1;
 928:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 92c:	00090b93          	mv	s7,s2
      state = 0;
 930:	00000993          	li	s3,0
        i += 1;
 934:	dcdff06f          	j	700 <vprintf+0x78>
 938:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 93c:	008b8d13          	addi	s10,s7,8
 940:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 944:	03000593          	li	a1,48
 948:	000b0513          	mv	a0,s6
 94c:	c21ff0ef          	jal	56c <putc>
  putc(fd, 'x');
 950:	07800593          	li	a1,120
 954:	000b0513          	mv	a0,s6
 958:	c15ff0ef          	jal	56c <putc>
 95c:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 960:	00000b97          	auipc	s7,0x0
 964:	388b8b93          	addi	s7,s7,904 # ce8 <digits>
 968:	03c9d793          	srli	a5,s3,0x3c
 96c:	00fb87b3          	add	a5,s7,a5
 970:	0007c583          	lbu	a1,0(a5)
 974:	000b0513          	mv	a0,s6
 978:	bf5ff0ef          	jal	56c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 97c:	00499993          	slli	s3,s3,0x4
 980:	fff9091b          	addiw	s2,s2,-1
 984:	fe0912e3          	bnez	s2,968 <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
 988:	000d0b93          	mv	s7,s10
      state = 0;
 98c:	00000993          	li	s3,0
 990:	00013d03          	ld	s10,0(sp)
 994:	d6dff06f          	j	700 <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
 998:	008b8993          	addi	s3,s7,8
 99c:	000bb903          	ld	s2,0(s7)
 9a0:	02090663          	beqz	s2,9cc <vprintf+0x344>
        for(; *s; s++)
 9a4:	00094583          	lbu	a1,0(s2)
 9a8:	02058a63          	beqz	a1,9dc <vprintf+0x354>
          putc(fd, *s);
 9ac:	000b0513          	mv	a0,s6
 9b0:	bbdff0ef          	jal	56c <putc>
        for(; *s; s++)
 9b4:	00190913          	addi	s2,s2,1
 9b8:	00094583          	lbu	a1,0(s2)
 9bc:	fe0598e3          	bnez	a1,9ac <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 9c0:	00098b93          	mv	s7,s3
      state = 0;
 9c4:	00000993          	li	s3,0
 9c8:	d39ff06f          	j	700 <vprintf+0x78>
          s = "(null)";
 9cc:	00000917          	auipc	s2,0x0
 9d0:	31490913          	addi	s2,s2,788 # ce0 <malloc+0x180>
        for(; *s; s++)
 9d4:	02800593          	li	a1,40
 9d8:	fd5ff06f          	j	9ac <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 9dc:	00098b93          	mv	s7,s3
      state = 0;
 9e0:	00000993          	li	s3,0
 9e4:	d1dff06f          	j	700 <vprintf+0x78>
 9e8:	04813483          	ld	s1,72(sp)
 9ec:	03813983          	ld	s3,56(sp)
 9f0:	03013a03          	ld	s4,48(sp)
 9f4:	02813a83          	ld	s5,40(sp)
 9f8:	02013b03          	ld	s6,32(sp)
 9fc:	01813b83          	ld	s7,24(sp)
 a00:	01013c03          	ld	s8,16(sp)
 a04:	00813c83          	ld	s9,8(sp)
    }
  }
}
 a08:	05813083          	ld	ra,88(sp)
 a0c:	05013403          	ld	s0,80(sp)
 a10:	04013903          	ld	s2,64(sp)
 a14:	06010113          	addi	sp,sp,96
 a18:	00008067          	ret

0000000000000a1c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a1c:	fb010113          	addi	sp,sp,-80
 a20:	00113c23          	sd	ra,24(sp)
 a24:	00813823          	sd	s0,16(sp)
 a28:	02010413          	addi	s0,sp,32
 a2c:	00c43023          	sd	a2,0(s0)
 a30:	00d43423          	sd	a3,8(s0)
 a34:	00e43823          	sd	a4,16(s0)
 a38:	00f43c23          	sd	a5,24(s0)
 a3c:	03043023          	sd	a6,32(s0)
 a40:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a44:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a48:	00040613          	mv	a2,s0
 a4c:	c3dff0ef          	jal	688 <vprintf>
}
 a50:	01813083          	ld	ra,24(sp)
 a54:	01013403          	ld	s0,16(sp)
 a58:	05010113          	addi	sp,sp,80
 a5c:	00008067          	ret

0000000000000a60 <printf>:

void
printf(const char *fmt, ...)
{
 a60:	fa010113          	addi	sp,sp,-96
 a64:	00113c23          	sd	ra,24(sp)
 a68:	00813823          	sd	s0,16(sp)
 a6c:	02010413          	addi	s0,sp,32
 a70:	00b43423          	sd	a1,8(s0)
 a74:	00c43823          	sd	a2,16(s0)
 a78:	00d43c23          	sd	a3,24(s0)
 a7c:	02e43023          	sd	a4,32(s0)
 a80:	02f43423          	sd	a5,40(s0)
 a84:	03043823          	sd	a6,48(s0)
 a88:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a8c:	00840613          	addi	a2,s0,8
 a90:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a94:	00050593          	mv	a1,a0
 a98:	00100513          	li	a0,1
 a9c:	bedff0ef          	jal	688 <vprintf>
}
 aa0:	01813083          	ld	ra,24(sp)
 aa4:	01013403          	ld	s0,16(sp)
 aa8:	06010113          	addi	sp,sp,96
 aac:	00008067          	ret

0000000000000ab0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ab0:	ff010113          	addi	sp,sp,-16
 ab4:	00813423          	sd	s0,8(sp)
 ab8:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 abc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac0:	00000797          	auipc	a5,0x0
 ac4:	5407b783          	ld	a5,1344(a5) # 1000 <freep>
 ac8:	0400006f          	j	b08 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 acc:	00862703          	lw	a4,8(a2)
 ad0:	00b7073b          	addw	a4,a4,a1
 ad4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 ad8:	0007b703          	ld	a4,0(a5)
 adc:	00073603          	ld	a2,0(a4)
 ae0:	0500006f          	j	b30 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ae4:	ff852703          	lw	a4,-8(a0)
 ae8:	00c7073b          	addw	a4,a4,a2
 aec:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 af0:	ff053683          	ld	a3,-16(a0)
 af4:	0540006f          	j	b48 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 af8:	0007b703          	ld	a4,0(a5)
 afc:	00e7e463          	bltu	a5,a4,b04 <free+0x54>
 b00:	00e6ec63          	bltu	a3,a4,b18 <free+0x68>
{
 b04:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b08:	fed7f8e3          	bgeu	a5,a3,af8 <free+0x48>
 b0c:	0007b703          	ld	a4,0(a5)
 b10:	00e6e463          	bltu	a3,a4,b18 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b14:	fee7e8e3          	bltu	a5,a4,b04 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 b18:	ff852583          	lw	a1,-8(a0)
 b1c:	0007b603          	ld	a2,0(a5)
 b20:	02059813          	slli	a6,a1,0x20
 b24:	01c85713          	srli	a4,a6,0x1c
 b28:	00e68733          	add	a4,a3,a4
 b2c:	fae600e3          	beq	a2,a4,acc <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 b30:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b34:	0087a603          	lw	a2,8(a5)
 b38:	02061593          	slli	a1,a2,0x20
 b3c:	01c5d713          	srli	a4,a1,0x1c
 b40:	00e78733          	add	a4,a5,a4
 b44:	fae680e3          	beq	a3,a4,ae4 <free+0x34>
    p->s.ptr = bp->s.ptr;
 b48:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b4c:	00000717          	auipc	a4,0x0
 b50:	4af73a23          	sd	a5,1204(a4) # 1000 <freep>
}
 b54:	00813403          	ld	s0,8(sp)
 b58:	01010113          	addi	sp,sp,16
 b5c:	00008067          	ret

0000000000000b60 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b60:	fc010113          	addi	sp,sp,-64
 b64:	02113c23          	sd	ra,56(sp)
 b68:	02813823          	sd	s0,48(sp)
 b6c:	02913423          	sd	s1,40(sp)
 b70:	01313c23          	sd	s3,24(sp)
 b74:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b78:	02051493          	slli	s1,a0,0x20
 b7c:	0204d493          	srli	s1,s1,0x20
 b80:	00f48493          	addi	s1,s1,15
 b84:	0044d493          	srli	s1,s1,0x4
 b88:	0014899b          	addiw	s3,s1,1
 b8c:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
 b90:	00000517          	auipc	a0,0x0
 b94:	47053503          	ld	a0,1136(a0) # 1000 <freep>
 b98:	04050663          	beqz	a0,be4 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b9c:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ba0:	0087a703          	lw	a4,8(a5)
 ba4:	0c977c63          	bgeu	a4,s1,c7c <malloc+0x11c>
 ba8:	03213023          	sd	s2,32(sp)
 bac:	01413823          	sd	s4,16(sp)
 bb0:	01513423          	sd	s5,8(sp)
 bb4:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
 bb8:	00098a13          	mv	s4,s3
 bbc:	0009871b          	sext.w	a4,s3
 bc0:	000016b7          	lui	a3,0x1
 bc4:	00d77463          	bgeu	a4,a3,bcc <malloc+0x6c>
 bc8:	00001a37          	lui	s4,0x1
 bcc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 bd0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bd4:	00000917          	auipc	s2,0x0
 bd8:	42c90913          	addi	s2,s2,1068 # 1000 <freep>
  if(p == (char*)-1)
 bdc:	fff00a93          	li	s5,-1
 be0:	05c0006f          	j	c3c <malloc+0xdc>
 be4:	03213023          	sd	s2,32(sp)
 be8:	01413823          	sd	s4,16(sp)
 bec:	01513423          	sd	s5,8(sp)
 bf0:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 bf4:	00000797          	auipc	a5,0x0
 bf8:	41c78793          	addi	a5,a5,1052 # 1010 <base>
 bfc:	00000717          	auipc	a4,0x0
 c00:	40f73223          	sd	a5,1028(a4) # 1000 <freep>
 c04:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 c08:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c0c:	fadff06f          	j	bb8 <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
 c10:	0007b703          	ld	a4,0(a5)
 c14:	00e53023          	sd	a4,0(a0)
 c18:	0800006f          	j	c98 <malloc+0x138>
  hp->s.size = nu;
 c1c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c20:	01050513          	addi	a0,a0,16
 c24:	e8dff0ef          	jal	ab0 <free>
  return freep;
 c28:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c2c:	08050863          	beqz	a0,cbc <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c30:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c34:	0087a703          	lw	a4,8(a5)
 c38:	02977a63          	bgeu	a4,s1,c6c <malloc+0x10c>
    if(p == freep)
 c3c:	00093703          	ld	a4,0(s2)
 c40:	00078513          	mv	a0,a5
 c44:	fef716e3          	bne	a4,a5,c30 <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
 c48:	000a0513          	mv	a0,s4
 c4c:	8fdff0ef          	jal	548 <sbrk>
  if(p == (char*)-1)
 c50:	fd5516e3          	bne	a0,s5,c1c <malloc+0xbc>
        return 0;
 c54:	00000513          	li	a0,0
 c58:	02013903          	ld	s2,32(sp)
 c5c:	01013a03          	ld	s4,16(sp)
 c60:	00813a83          	ld	s5,8(sp)
 c64:	00013b03          	ld	s6,0(sp)
 c68:	03c0006f          	j	ca4 <malloc+0x144>
 c6c:	02013903          	ld	s2,32(sp)
 c70:	01013a03          	ld	s4,16(sp)
 c74:	00813a83          	ld	s5,8(sp)
 c78:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
 c7c:	f8e48ae3          	beq	s1,a4,c10 <malloc+0xb0>
        p->s.size -= nunits;
 c80:	4137073b          	subw	a4,a4,s3
 c84:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 c88:	02071693          	slli	a3,a4,0x20
 c8c:	01c6d713          	srli	a4,a3,0x1c
 c90:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 c94:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c98:	00000717          	auipc	a4,0x0
 c9c:	36a73423          	sd	a0,872(a4) # 1000 <freep>
      return (void*)(p + 1);
 ca0:	01078513          	addi	a0,a5,16
  }
}
 ca4:	03813083          	ld	ra,56(sp)
 ca8:	03013403          	ld	s0,48(sp)
 cac:	02813483          	ld	s1,40(sp)
 cb0:	01813983          	ld	s3,24(sp)
 cb4:	04010113          	addi	sp,sp,64
 cb8:	00008067          	ret
 cbc:	02013903          	ld	s2,32(sp)
 cc0:	01013a03          	ld	s4,16(sp)
 cc4:	00813a83          	ld	s5,8(sp)
 cc8:	00013b03          	ld	s6,0(sp)
 ccc:	fd9ff06f          	j	ca4 <malloc+0x144>
