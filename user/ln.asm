
user/_ln:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	fe010113          	addi	sp,sp,-32
   4:	00113c23          	sd	ra,24(sp)
   8:	00813823          	sd	s0,16(sp)
   c:	02010413          	addi	s0,sp,32
  if(argc != 3){
  10:	00300793          	li	a5,3
  14:	02f50063          	beq	a0,a5,34 <main+0x34>
  18:	00913423          	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  1c:	00001597          	auipc	a1,0x1
  20:	c8458593          	addi	a1,a1,-892 # ca0 <malloc+0x178>
  24:	00200513          	li	a0,2
  28:	1bd000ef          	jal	9e4 <fprintf>
    exit(1);
  2c:	00100513          	li	a0,1
  30:	414000ef          	jal	444 <exit>
  34:	00913423          	sd	s1,8(sp)
  38:	00058493          	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  3c:	0105b583          	ld	a1,16(a1)
  40:	0084b503          	ld	a0,8(s1)
  44:	490000ef          	jal	4d4 <link>
  48:	00054663          	bltz	a0,54 <main+0x54>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  4c:	00000513          	li	a0,0
  50:	3f4000ef          	jal	444 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  54:	0104b683          	ld	a3,16(s1)
  58:	0084b603          	ld	a2,8(s1)
  5c:	00001597          	auipc	a1,0x1
  60:	c5c58593          	addi	a1,a1,-932 # cb8 <malloc+0x190>
  64:	00200513          	li	a0,2
  68:	17d000ef          	jal	9e4 <fprintf>
  6c:	fe1ff06f          	j	4c <main+0x4c>

0000000000000070 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  70:	ff010113          	addi	sp,sp,-16
  74:	00113423          	sd	ra,8(sp)
  78:	00813023          	sd	s0,0(sp)
  7c:	01010413          	addi	s0,sp,16
  extern int main();
  main();
  80:	f81ff0ef          	jal	0 <main>
  exit(0);
  84:	00000513          	li	a0,0
  88:	3bc000ef          	jal	444 <exit>

000000000000008c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  8c:	ff010113          	addi	sp,sp,-16
  90:	00813423          	sd	s0,8(sp)
  94:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  98:	00050793          	mv	a5,a0
  9c:	00158593          	addi	a1,a1,1
  a0:	00178793          	addi	a5,a5,1
  a4:	fff5c703          	lbu	a4,-1(a1)
  a8:	fee78fa3          	sb	a4,-1(a5)
  ac:	fe0718e3          	bnez	a4,9c <strcpy+0x10>
    ;
  return os;
}
  b0:	00813403          	ld	s0,8(sp)
  b4:	01010113          	addi	sp,sp,16
  b8:	00008067          	ret

00000000000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	ff010113          	addi	sp,sp,-16
  c0:	00813423          	sd	s0,8(sp)
  c4:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	00078e63          	beqz	a5,e8 <strcmp+0x2c>
  d0:	0005c703          	lbu	a4,0(a1)
  d4:	00f71a63          	bne	a4,a5,e8 <strcmp+0x2c>
    p++, q++;
  d8:	00150513          	addi	a0,a0,1
  dc:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	fe0796e3          	bnez	a5,d0 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  e8:	0005c503          	lbu	a0,0(a1)
}
  ec:	40a7853b          	subw	a0,a5,a0
  f0:	00813403          	ld	s0,8(sp)
  f4:	01010113          	addi	sp,sp,16
  f8:	00008067          	ret

00000000000000fc <strlen>:

uint
strlen(const char *s)
{
  fc:	ff010113          	addi	sp,sp,-16
 100:	00813423          	sd	s0,8(sp)
 104:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 108:	00054783          	lbu	a5,0(a0)
 10c:	02078863          	beqz	a5,13c <strlen+0x40>
 110:	00150513          	addi	a0,a0,1
 114:	00050793          	mv	a5,a0
 118:	00078693          	mv	a3,a5
 11c:	00178793          	addi	a5,a5,1
 120:	fff7c703          	lbu	a4,-1(a5)
 124:	fe071ae3          	bnez	a4,118 <strlen+0x1c>
 128:	40a6853b          	subw	a0,a3,a0
 12c:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
 130:	00813403          	ld	s0,8(sp)
 134:	01010113          	addi	sp,sp,16
 138:	00008067          	ret
  for(n = 0; s[n]; n++)
 13c:	00000513          	li	a0,0
 140:	ff1ff06f          	j	130 <strlen+0x34>

0000000000000144 <memset>:

void*
memset(void *dst, int c, uint n)
{
 144:	ff010113          	addi	sp,sp,-16
 148:	00813423          	sd	s0,8(sp)
 14c:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 150:	02060063          	beqz	a2,170 <memset+0x2c>
 154:	00050793          	mv	a5,a0
 158:	02061613          	slli	a2,a2,0x20
 15c:	02065613          	srli	a2,a2,0x20
 160:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 164:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 168:	00178793          	addi	a5,a5,1
 16c:	fee79ce3          	bne	a5,a4,164 <memset+0x20>
  }
  return dst;
}
 170:	00813403          	ld	s0,8(sp)
 174:	01010113          	addi	sp,sp,16
 178:	00008067          	ret

000000000000017c <strchr>:

char*
strchr(const char *s, char c)
{
 17c:	ff010113          	addi	sp,sp,-16
 180:	00813423          	sd	s0,8(sp)
 184:	01010413          	addi	s0,sp,16
  for(; *s; s++)
 188:	00054783          	lbu	a5,0(a0)
 18c:	02078263          	beqz	a5,1b0 <strchr+0x34>
    if(*s == c)
 190:	00f58a63          	beq	a1,a5,1a4 <strchr+0x28>
  for(; *s; s++)
 194:	00150513          	addi	a0,a0,1
 198:	00054783          	lbu	a5,0(a0)
 19c:	fe079ae3          	bnez	a5,190 <strchr+0x14>
      return (char*)s;
  return 0;
 1a0:	00000513          	li	a0,0
}
 1a4:	00813403          	ld	s0,8(sp)
 1a8:	01010113          	addi	sp,sp,16
 1ac:	00008067          	ret
  return 0;
 1b0:	00000513          	li	a0,0
 1b4:	ff1ff06f          	j	1a4 <strchr+0x28>

00000000000001b8 <gets>:

char*
gets(char *buf, int max)
{
 1b8:	fa010113          	addi	sp,sp,-96
 1bc:	04113c23          	sd	ra,88(sp)
 1c0:	04813823          	sd	s0,80(sp)
 1c4:	04913423          	sd	s1,72(sp)
 1c8:	05213023          	sd	s2,64(sp)
 1cc:	03313c23          	sd	s3,56(sp)
 1d0:	03413823          	sd	s4,48(sp)
 1d4:	03513423          	sd	s5,40(sp)
 1d8:	03613023          	sd	s6,32(sp)
 1dc:	01713c23          	sd	s7,24(sp)
 1e0:	06010413          	addi	s0,sp,96
 1e4:	00050b93          	mv	s7,a0
 1e8:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ec:	00050913          	mv	s2,a0
 1f0:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f4:	00a00a93          	li	s5,10
 1f8:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 1fc:	00048993          	mv	s3,s1
 200:	0014849b          	addiw	s1,s1,1
 204:	0344dc63          	bge	s1,s4,23c <gets+0x84>
    cc = read(0, &c, 1);
 208:	00100613          	li	a2,1
 20c:	faf40593          	addi	a1,s0,-81
 210:	00000513          	li	a0,0
 214:	254000ef          	jal	468 <read>
    if(cc < 1)
 218:	02a05263          	blez	a0,23c <gets+0x84>
    buf[i++] = c;
 21c:	faf44783          	lbu	a5,-81(s0)
 220:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 224:	01578a63          	beq	a5,s5,238 <gets+0x80>
 228:	00190913          	addi	s2,s2,1
 22c:	fd6798e3          	bne	a5,s6,1fc <gets+0x44>
    buf[i++] = c;
 230:	00048993          	mv	s3,s1
 234:	0080006f          	j	23c <gets+0x84>
 238:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 23c:	013b89b3          	add	s3,s7,s3
 240:	00098023          	sb	zero,0(s3)
  return buf;
}
 244:	000b8513          	mv	a0,s7
 248:	05813083          	ld	ra,88(sp)
 24c:	05013403          	ld	s0,80(sp)
 250:	04813483          	ld	s1,72(sp)
 254:	04013903          	ld	s2,64(sp)
 258:	03813983          	ld	s3,56(sp)
 25c:	03013a03          	ld	s4,48(sp)
 260:	02813a83          	ld	s5,40(sp)
 264:	02013b03          	ld	s6,32(sp)
 268:	01813b83          	ld	s7,24(sp)
 26c:	06010113          	addi	sp,sp,96
 270:	00008067          	ret

0000000000000274 <stat>:

int
stat(const char *n, struct stat *st)
{
 274:	fe010113          	addi	sp,sp,-32
 278:	00113c23          	sd	ra,24(sp)
 27c:	00813823          	sd	s0,16(sp)
 280:	01213023          	sd	s2,0(sp)
 284:	02010413          	addi	s0,sp,32
 288:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28c:	00000593          	li	a1,0
 290:	214000ef          	jal	4a4 <open>
  if(fd < 0)
 294:	02054e63          	bltz	a0,2d0 <stat+0x5c>
 298:	00913423          	sd	s1,8(sp)
 29c:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2a0:	00090593          	mv	a1,s2
 2a4:	224000ef          	jal	4c8 <fstat>
 2a8:	00050913          	mv	s2,a0
  close(fd);
 2ac:	00048513          	mv	a0,s1
 2b0:	1d0000ef          	jal	480 <close>
  return r;
 2b4:	00813483          	ld	s1,8(sp)
}
 2b8:	00090513          	mv	a0,s2
 2bc:	01813083          	ld	ra,24(sp)
 2c0:	01013403          	ld	s0,16(sp)
 2c4:	00013903          	ld	s2,0(sp)
 2c8:	02010113          	addi	sp,sp,32
 2cc:	00008067          	ret
    return -1;
 2d0:	fff00913          	li	s2,-1
 2d4:	fe5ff06f          	j	2b8 <stat+0x44>

00000000000002d8 <atoi>:

int
atoi(const char *s)
{
 2d8:	ff010113          	addi	sp,sp,-16
 2dc:	00813423          	sd	s0,8(sp)
 2e0:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e4:	00054683          	lbu	a3,0(a0)
 2e8:	fd06879b          	addiw	a5,a3,-48
 2ec:	0ff7f793          	zext.b	a5,a5
 2f0:	00900613          	li	a2,9
 2f4:	04f66063          	bltu	a2,a5,334 <atoi+0x5c>
 2f8:	00050713          	mv	a4,a0
  n = 0;
 2fc:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 300:	00170713          	addi	a4,a4,1
 304:	0025179b          	slliw	a5,a0,0x2
 308:	00a787bb          	addw	a5,a5,a0
 30c:	0017979b          	slliw	a5,a5,0x1
 310:	00d787bb          	addw	a5,a5,a3
 314:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 318:	00074683          	lbu	a3,0(a4)
 31c:	fd06879b          	addiw	a5,a3,-48
 320:	0ff7f793          	zext.b	a5,a5
 324:	fcf67ee3          	bgeu	a2,a5,300 <atoi+0x28>
  return n;
}
 328:	00813403          	ld	s0,8(sp)
 32c:	01010113          	addi	sp,sp,16
 330:	00008067          	ret
  n = 0;
 334:	00000513          	li	a0,0
 338:	ff1ff06f          	j	328 <atoi+0x50>

000000000000033c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 33c:	ff010113          	addi	sp,sp,-16
 340:	00813423          	sd	s0,8(sp)
 344:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 348:	02b57c63          	bgeu	a0,a1,380 <memmove+0x44>
    while(n-- > 0)
 34c:	02c05463          	blez	a2,374 <memmove+0x38>
 350:	02061613          	slli	a2,a2,0x20
 354:	02065613          	srli	a2,a2,0x20
 358:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 35c:	00050713          	mv	a4,a0
      *dst++ = *src++;
 360:	00158593          	addi	a1,a1,1
 364:	00170713          	addi	a4,a4,1
 368:	fff5c683          	lbu	a3,-1(a1)
 36c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 370:	fef718e3          	bne	a4,a5,360 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 374:	00813403          	ld	s0,8(sp)
 378:	01010113          	addi	sp,sp,16
 37c:	00008067          	ret
    dst += n;
 380:	00c50733          	add	a4,a0,a2
    src += n;
 384:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 388:	fec056e3          	blez	a2,374 <memmove+0x38>
 38c:	fff6079b          	addiw	a5,a2,-1
 390:	02079793          	slli	a5,a5,0x20
 394:	0207d793          	srli	a5,a5,0x20
 398:	fff7c793          	not	a5,a5
 39c:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 3a0:	fff58593          	addi	a1,a1,-1
 3a4:	fff70713          	addi	a4,a4,-1
 3a8:	0005c683          	lbu	a3,0(a1)
 3ac:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3b0:	fee798e3          	bne	a5,a4,3a0 <memmove+0x64>
 3b4:	fc1ff06f          	j	374 <memmove+0x38>

00000000000003b8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3b8:	ff010113          	addi	sp,sp,-16
 3bc:	00813423          	sd	s0,8(sp)
 3c0:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3c4:	04060463          	beqz	a2,40c <memcmp+0x54>
 3c8:	fff6069b          	addiw	a3,a2,-1
 3cc:	02069693          	slli	a3,a3,0x20
 3d0:	0206d693          	srli	a3,a3,0x20
 3d4:	00168693          	addi	a3,a3,1
 3d8:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 3dc:	00054783          	lbu	a5,0(a0)
 3e0:	0005c703          	lbu	a4,0(a1)
 3e4:	00e79c63          	bne	a5,a4,3fc <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 3e8:	00150513          	addi	a0,a0,1
    p2++;
 3ec:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
 3f0:	fed516e3          	bne	a0,a3,3dc <memcmp+0x24>
  }
  return 0;
 3f4:	00000513          	li	a0,0
 3f8:	0080006f          	j	400 <memcmp+0x48>
      return *p1 - *p2;
 3fc:	40e7853b          	subw	a0,a5,a4
}
 400:	00813403          	ld	s0,8(sp)
 404:	01010113          	addi	sp,sp,16
 408:	00008067          	ret
  return 0;
 40c:	00000513          	li	a0,0
 410:	ff1ff06f          	j	400 <memcmp+0x48>

0000000000000414 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 414:	ff010113          	addi	sp,sp,-16
 418:	00113423          	sd	ra,8(sp)
 41c:	00813023          	sd	s0,0(sp)
 420:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
 424:	f19ff0ef          	jal	33c <memmove>
}
 428:	00813083          	ld	ra,8(sp)
 42c:	00013403          	ld	s0,0(sp)
 430:	01010113          	addi	sp,sp,16
 434:	00008067          	ret

0000000000000438 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 438:	00100893          	li	a7,1
 ecall
 43c:	00000073          	ecall
 ret
 440:	00008067          	ret

0000000000000444 <exit>:
.global exit
exit:
 li a7, SYS_exit
 444:	00200893          	li	a7,2
 ecall
 448:	00000073          	ecall
 ret
 44c:	00008067          	ret

0000000000000450 <wait>:
.global wait
wait:
 li a7, SYS_wait
 450:	00300893          	li	a7,3
 ecall
 454:	00000073          	ecall
 ret
 458:	00008067          	ret

000000000000045c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 45c:	00400893          	li	a7,4
 ecall
 460:	00000073          	ecall
 ret
 464:	00008067          	ret

0000000000000468 <read>:
.global read
read:
 li a7, SYS_read
 468:	00500893          	li	a7,5
 ecall
 46c:	00000073          	ecall
 ret
 470:	00008067          	ret

0000000000000474 <write>:
.global write
write:
 li a7, SYS_write
 474:	01000893          	li	a7,16
 ecall
 478:	00000073          	ecall
 ret
 47c:	00008067          	ret

0000000000000480 <close>:
.global close
close:
 li a7, SYS_close
 480:	01500893          	li	a7,21
 ecall
 484:	00000073          	ecall
 ret
 488:	00008067          	ret

000000000000048c <kill>:
.global kill
kill:
 li a7, SYS_kill
 48c:	00600893          	li	a7,6
 ecall
 490:	00000073          	ecall
 ret
 494:	00008067          	ret

0000000000000498 <exec>:
.global exec
exec:
 li a7, SYS_exec
 498:	00700893          	li	a7,7
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	00008067          	ret

00000000000004a4 <open>:
.global open
open:
 li a7, SYS_open
 4a4:	00f00893          	li	a7,15
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	00008067          	ret

00000000000004b0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b0:	01100893          	li	a7,17
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	00008067          	ret

00000000000004bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4bc:	01200893          	li	a7,18
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	00008067          	ret

00000000000004c8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c8:	00800893          	li	a7,8
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	00008067          	ret

00000000000004d4 <link>:
.global link
link:
 li a7, SYS_link
 4d4:	01300893          	li	a7,19
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	00008067          	ret

00000000000004e0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4e0:	01400893          	li	a7,20
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	00008067          	ret

00000000000004ec <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ec:	00900893          	li	a7,9
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	00008067          	ret

00000000000004f8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4f8:	00a00893          	li	a7,10
 ecall
 4fc:	00000073          	ecall
 ret
 500:	00008067          	ret

0000000000000504 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 504:	00b00893          	li	a7,11
 ecall
 508:	00000073          	ecall
 ret
 50c:	00008067          	ret

0000000000000510 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 510:	00c00893          	li	a7,12
 ecall
 514:	00000073          	ecall
 ret
 518:	00008067          	ret

000000000000051c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 51c:	00d00893          	li	a7,13
 ecall
 520:	00000073          	ecall
 ret
 524:	00008067          	ret

0000000000000528 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 528:	00e00893          	li	a7,14
 ecall
 52c:	00000073          	ecall
 ret
 530:	00008067          	ret

0000000000000534 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 534:	fe010113          	addi	sp,sp,-32
 538:	00113c23          	sd	ra,24(sp)
 53c:	00813823          	sd	s0,16(sp)
 540:	02010413          	addi	s0,sp,32
 544:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 548:	00100613          	li	a2,1
 54c:	fef40593          	addi	a1,s0,-17
 550:	f25ff0ef          	jal	474 <write>
}
 554:	01813083          	ld	ra,24(sp)
 558:	01013403          	ld	s0,16(sp)
 55c:	02010113          	addi	sp,sp,32
 560:	00008067          	ret

0000000000000564 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 564:	fc010113          	addi	sp,sp,-64
 568:	02113c23          	sd	ra,56(sp)
 56c:	02813823          	sd	s0,48(sp)
 570:	02913423          	sd	s1,40(sp)
 574:	04010413          	addi	s0,sp,64
 578:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 57c:	00068463          	beqz	a3,584 <printint+0x20>
 580:	0c05c263          	bltz	a1,644 <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 584:	0005859b          	sext.w	a1,a1
  neg = 0;
 588:	00000893          	li	a7,0
 58c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 590:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 594:	0006061b          	sext.w	a2,a2
 598:	00000517          	auipc	a0,0x0
 59c:	74050513          	addi	a0,a0,1856 # cd8 <digits>
 5a0:	00070813          	mv	a6,a4
 5a4:	0017071b          	addiw	a4,a4,1
 5a8:	02c5f7bb          	remuw	a5,a1,a2
 5ac:	02079793          	slli	a5,a5,0x20
 5b0:	0207d793          	srli	a5,a5,0x20
 5b4:	00f507b3          	add	a5,a0,a5
 5b8:	0007c783          	lbu	a5,0(a5)
 5bc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5c0:	0005879b          	sext.w	a5,a1
 5c4:	02c5d5bb          	divuw	a1,a1,a2
 5c8:	00168693          	addi	a3,a3,1
 5cc:	fcc7fae3          	bgeu	a5,a2,5a0 <printint+0x3c>
  if(neg)
 5d0:	00088c63          	beqz	a7,5e8 <printint+0x84>
    buf[i++] = '-';
 5d4:	fd070793          	addi	a5,a4,-48
 5d8:	00878733          	add	a4,a5,s0
 5dc:	02d00793          	li	a5,45
 5e0:	fef70823          	sb	a5,-16(a4)
 5e4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5e8:	04e05463          	blez	a4,630 <printint+0xcc>
 5ec:	03213023          	sd	s2,32(sp)
 5f0:	01313c23          	sd	s3,24(sp)
 5f4:	fc040793          	addi	a5,s0,-64
 5f8:	00e78933          	add	s2,a5,a4
 5fc:	fff78993          	addi	s3,a5,-1
 600:	00e989b3          	add	s3,s3,a4
 604:	fff7071b          	addiw	a4,a4,-1
 608:	02071713          	slli	a4,a4,0x20
 60c:	02075713          	srli	a4,a4,0x20
 610:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 614:	fff94583          	lbu	a1,-1(s2)
 618:	00048513          	mv	a0,s1
 61c:	f19ff0ef          	jal	534 <putc>
  while(--i >= 0)
 620:	fff90913          	addi	s2,s2,-1
 624:	ff3918e3          	bne	s2,s3,614 <printint+0xb0>
 628:	02013903          	ld	s2,32(sp)
 62c:	01813983          	ld	s3,24(sp)
}
 630:	03813083          	ld	ra,56(sp)
 634:	03013403          	ld	s0,48(sp)
 638:	02813483          	ld	s1,40(sp)
 63c:	04010113          	addi	sp,sp,64
 640:	00008067          	ret
    x = -xx;
 644:	40b005bb          	negw	a1,a1
    neg = 1;
 648:	00100893          	li	a7,1
    x = -xx;
 64c:	f41ff06f          	j	58c <printint+0x28>

0000000000000650 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 650:	fa010113          	addi	sp,sp,-96
 654:	04113c23          	sd	ra,88(sp)
 658:	04813823          	sd	s0,80(sp)
 65c:	05213023          	sd	s2,64(sp)
 660:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 664:	0005c903          	lbu	s2,0(a1)
 668:	36090463          	beqz	s2,9d0 <vprintf+0x380>
 66c:	04913423          	sd	s1,72(sp)
 670:	03313c23          	sd	s3,56(sp)
 674:	03413823          	sd	s4,48(sp)
 678:	03513423          	sd	s5,40(sp)
 67c:	03613023          	sd	s6,32(sp)
 680:	01713c23          	sd	s7,24(sp)
 684:	01813823          	sd	s8,16(sp)
 688:	01913423          	sd	s9,8(sp)
 68c:	00050b13          	mv	s6,a0
 690:	00058a13          	mv	s4,a1
 694:	00060b93          	mv	s7,a2
  state = 0;
 698:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
 69c:	00000493          	li	s1,0
 6a0:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6a4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6a8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6ac:	06c00c93          	li	s9,108
 6b0:	02c0006f          	j	6dc <vprintf+0x8c>
        putc(fd, c0);
 6b4:	00090593          	mv	a1,s2
 6b8:	000b0513          	mv	a0,s6
 6bc:	e79ff0ef          	jal	534 <putc>
 6c0:	0080006f          	j	6c8 <vprintf+0x78>
    } else if(state == '%'){
 6c4:	03598663          	beq	s3,s5,6f0 <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
 6c8:	0014849b          	addiw	s1,s1,1
 6cc:	00048713          	mv	a4,s1
 6d0:	009a07b3          	add	a5,s4,s1
 6d4:	0007c903          	lbu	s2,0(a5)
 6d8:	2c090c63          	beqz	s2,9b0 <vprintf+0x360>
    c0 = fmt[i] & 0xff;
 6dc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6e0:	fe0992e3          	bnez	s3,6c4 <vprintf+0x74>
      if(c0 == '%'){
 6e4:	fd5798e3          	bne	a5,s5,6b4 <vprintf+0x64>
        state = '%';
 6e8:	00078993          	mv	s3,a5
 6ec:	fddff06f          	j	6c8 <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
 6f0:	00ea06b3          	add	a3,s4,a4
 6f4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6f8:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6fc:	00068663          	beqz	a3,708 <vprintf+0xb8>
 700:	00ea0733          	add	a4,s4,a4
 704:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 708:	05878263          	beq	a5,s8,74c <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
 70c:	07978263          	beq	a5,s9,770 <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 710:	07500713          	li	a4,117
 714:	12e78663          	beq	a5,a4,840 <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 718:	07800713          	li	a4,120
 71c:	18e78c63          	beq	a5,a4,8b4 <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 720:	07000713          	li	a4,112
 724:	1ce78e63          	beq	a5,a4,900 <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 728:	07300713          	li	a4,115
 72c:	22e78a63          	beq	a5,a4,960 <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 730:	02500713          	li	a4,37
 734:	04e79e63          	bne	a5,a4,790 <vprintf+0x140>
        putc(fd, '%');
 738:	02500593          	li	a1,37
 73c:	000b0513          	mv	a0,s6
 740:	df5ff0ef          	jal	534 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 744:	00000993          	li	s3,0
 748:	f81ff06f          	j	6c8 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
 74c:	008b8913          	addi	s2,s7,8
 750:	00100693          	li	a3,1
 754:	00a00613          	li	a2,10
 758:	000ba583          	lw	a1,0(s7)
 75c:	000b0513          	mv	a0,s6
 760:	e05ff0ef          	jal	564 <printint>
 764:	00090b93          	mv	s7,s2
      state = 0;
 768:	00000993          	li	s3,0
 76c:	f5dff06f          	j	6c8 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
 770:	06400793          	li	a5,100
 774:	02f68e63          	beq	a3,a5,7b0 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 778:	06c00793          	li	a5,108
 77c:	04f68e63          	beq	a3,a5,7d8 <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
 780:	07500793          	li	a5,117
 784:	0ef68063          	beq	a3,a5,864 <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
 788:	07800793          	li	a5,120
 78c:	14f68663          	beq	a3,a5,8d8 <vprintf+0x288>
        putc(fd, '%');
 790:	02500593          	li	a1,37
 794:	000b0513          	mv	a0,s6
 798:	d9dff0ef          	jal	534 <putc>
        putc(fd, c0);
 79c:	00090593          	mv	a1,s2
 7a0:	000b0513          	mv	a0,s6
 7a4:	d91ff0ef          	jal	534 <putc>
      state = 0;
 7a8:	00000993          	li	s3,0
 7ac:	f1dff06f          	j	6c8 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b0:	008b8913          	addi	s2,s7,8
 7b4:	00100693          	li	a3,1
 7b8:	00a00613          	li	a2,10
 7bc:	000ba583          	lw	a1,0(s7)
 7c0:	000b0513          	mv	a0,s6
 7c4:	da1ff0ef          	jal	564 <printint>
        i += 1;
 7c8:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7cc:	00090b93          	mv	s7,s2
      state = 0;
 7d0:	00000993          	li	s3,0
        i += 1;
 7d4:	ef5ff06f          	j	6c8 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7d8:	06400793          	li	a5,100
 7dc:	02f60e63          	beq	a2,a5,818 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7e0:	07500793          	li	a5,117
 7e4:	0af60463          	beq	a2,a5,88c <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7e8:	07800793          	li	a5,120
 7ec:	faf612e3          	bne	a2,a5,790 <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f0:	008b8913          	addi	s2,s7,8
 7f4:	00000693          	li	a3,0
 7f8:	01000613          	li	a2,16
 7fc:	000ba583          	lw	a1,0(s7)
 800:	000b0513          	mv	a0,s6
 804:	d61ff0ef          	jal	564 <printint>
        i += 2;
 808:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 80c:	00090b93          	mv	s7,s2
      state = 0;
 810:	00000993          	li	s3,0
        i += 2;
 814:	eb5ff06f          	j	6c8 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 818:	008b8913          	addi	s2,s7,8
 81c:	00100693          	li	a3,1
 820:	00a00613          	li	a2,10
 824:	000ba583          	lw	a1,0(s7)
 828:	000b0513          	mv	a0,s6
 82c:	d39ff0ef          	jal	564 <printint>
        i += 2;
 830:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 834:	00090b93          	mv	s7,s2
      state = 0;
 838:	00000993          	li	s3,0
        i += 2;
 83c:	e8dff06f          	j	6c8 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
 840:	008b8913          	addi	s2,s7,8
 844:	00000693          	li	a3,0
 848:	00a00613          	li	a2,10
 84c:	000ba583          	lw	a1,0(s7)
 850:	000b0513          	mv	a0,s6
 854:	d11ff0ef          	jal	564 <printint>
 858:	00090b93          	mv	s7,s2
      state = 0;
 85c:	00000993          	li	s3,0
 860:	e69ff06f          	j	6c8 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 864:	008b8913          	addi	s2,s7,8
 868:	00000693          	li	a3,0
 86c:	00a00613          	li	a2,10
 870:	000ba583          	lw	a1,0(s7)
 874:	000b0513          	mv	a0,s6
 878:	cedff0ef          	jal	564 <printint>
        i += 1;
 87c:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 880:	00090b93          	mv	s7,s2
      state = 0;
 884:	00000993          	li	s3,0
        i += 1;
 888:	e41ff06f          	j	6c8 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 88c:	008b8913          	addi	s2,s7,8
 890:	00000693          	li	a3,0
 894:	00a00613          	li	a2,10
 898:	000ba583          	lw	a1,0(s7)
 89c:	000b0513          	mv	a0,s6
 8a0:	cc5ff0ef          	jal	564 <printint>
        i += 2;
 8a4:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8a8:	00090b93          	mv	s7,s2
      state = 0;
 8ac:	00000993          	li	s3,0
        i += 2;
 8b0:	e19ff06f          	j	6c8 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
 8b4:	008b8913          	addi	s2,s7,8
 8b8:	00000693          	li	a3,0
 8bc:	01000613          	li	a2,16
 8c0:	000ba583          	lw	a1,0(s7)
 8c4:	000b0513          	mv	a0,s6
 8c8:	c9dff0ef          	jal	564 <printint>
 8cc:	00090b93          	mv	s7,s2
      state = 0;
 8d0:	00000993          	li	s3,0
 8d4:	df5ff06f          	j	6c8 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8d8:	008b8913          	addi	s2,s7,8
 8dc:	00000693          	li	a3,0
 8e0:	01000613          	li	a2,16
 8e4:	000ba583          	lw	a1,0(s7)
 8e8:	000b0513          	mv	a0,s6
 8ec:	c79ff0ef          	jal	564 <printint>
        i += 1;
 8f0:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8f4:	00090b93          	mv	s7,s2
      state = 0;
 8f8:	00000993          	li	s3,0
        i += 1;
 8fc:	dcdff06f          	j	6c8 <vprintf+0x78>
 900:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 904:	008b8d13          	addi	s10,s7,8
 908:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 90c:	03000593          	li	a1,48
 910:	000b0513          	mv	a0,s6
 914:	c21ff0ef          	jal	534 <putc>
  putc(fd, 'x');
 918:	07800593          	li	a1,120
 91c:	000b0513          	mv	a0,s6
 920:	c15ff0ef          	jal	534 <putc>
 924:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 928:	00000b97          	auipc	s7,0x0
 92c:	3b0b8b93          	addi	s7,s7,944 # cd8 <digits>
 930:	03c9d793          	srli	a5,s3,0x3c
 934:	00fb87b3          	add	a5,s7,a5
 938:	0007c583          	lbu	a1,0(a5)
 93c:	000b0513          	mv	a0,s6
 940:	bf5ff0ef          	jal	534 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 944:	00499993          	slli	s3,s3,0x4
 948:	fff9091b          	addiw	s2,s2,-1
 94c:	fe0912e3          	bnez	s2,930 <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
 950:	000d0b93          	mv	s7,s10
      state = 0;
 954:	00000993          	li	s3,0
 958:	00013d03          	ld	s10,0(sp)
 95c:	d6dff06f          	j	6c8 <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
 960:	008b8993          	addi	s3,s7,8
 964:	000bb903          	ld	s2,0(s7)
 968:	02090663          	beqz	s2,994 <vprintf+0x344>
        for(; *s; s++)
 96c:	00094583          	lbu	a1,0(s2)
 970:	02058a63          	beqz	a1,9a4 <vprintf+0x354>
          putc(fd, *s);
 974:	000b0513          	mv	a0,s6
 978:	bbdff0ef          	jal	534 <putc>
        for(; *s; s++)
 97c:	00190913          	addi	s2,s2,1
 980:	00094583          	lbu	a1,0(s2)
 984:	fe0598e3          	bnez	a1,974 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 988:	00098b93          	mv	s7,s3
      state = 0;
 98c:	00000993          	li	s3,0
 990:	d39ff06f          	j	6c8 <vprintf+0x78>
          s = "(null)";
 994:	00000917          	auipc	s2,0x0
 998:	33c90913          	addi	s2,s2,828 # cd0 <malloc+0x1a8>
        for(; *s; s++)
 99c:	02800593          	li	a1,40
 9a0:	fd5ff06f          	j	974 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 9a4:	00098b93          	mv	s7,s3
      state = 0;
 9a8:	00000993          	li	s3,0
 9ac:	d1dff06f          	j	6c8 <vprintf+0x78>
 9b0:	04813483          	ld	s1,72(sp)
 9b4:	03813983          	ld	s3,56(sp)
 9b8:	03013a03          	ld	s4,48(sp)
 9bc:	02813a83          	ld	s5,40(sp)
 9c0:	02013b03          	ld	s6,32(sp)
 9c4:	01813b83          	ld	s7,24(sp)
 9c8:	01013c03          	ld	s8,16(sp)
 9cc:	00813c83          	ld	s9,8(sp)
    }
  }
}
 9d0:	05813083          	ld	ra,88(sp)
 9d4:	05013403          	ld	s0,80(sp)
 9d8:	04013903          	ld	s2,64(sp)
 9dc:	06010113          	addi	sp,sp,96
 9e0:	00008067          	ret

00000000000009e4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9e4:	fb010113          	addi	sp,sp,-80
 9e8:	00113c23          	sd	ra,24(sp)
 9ec:	00813823          	sd	s0,16(sp)
 9f0:	02010413          	addi	s0,sp,32
 9f4:	00c43023          	sd	a2,0(s0)
 9f8:	00d43423          	sd	a3,8(s0)
 9fc:	00e43823          	sd	a4,16(s0)
 a00:	00f43c23          	sd	a5,24(s0)
 a04:	03043023          	sd	a6,32(s0)
 a08:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a0c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a10:	00040613          	mv	a2,s0
 a14:	c3dff0ef          	jal	650 <vprintf>
}
 a18:	01813083          	ld	ra,24(sp)
 a1c:	01013403          	ld	s0,16(sp)
 a20:	05010113          	addi	sp,sp,80
 a24:	00008067          	ret

0000000000000a28 <printf>:

void
printf(const char *fmt, ...)
{
 a28:	fa010113          	addi	sp,sp,-96
 a2c:	00113c23          	sd	ra,24(sp)
 a30:	00813823          	sd	s0,16(sp)
 a34:	02010413          	addi	s0,sp,32
 a38:	00b43423          	sd	a1,8(s0)
 a3c:	00c43823          	sd	a2,16(s0)
 a40:	00d43c23          	sd	a3,24(s0)
 a44:	02e43023          	sd	a4,32(s0)
 a48:	02f43423          	sd	a5,40(s0)
 a4c:	03043823          	sd	a6,48(s0)
 a50:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a54:	00840613          	addi	a2,s0,8
 a58:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a5c:	00050593          	mv	a1,a0
 a60:	00100513          	li	a0,1
 a64:	bedff0ef          	jal	650 <vprintf>
}
 a68:	01813083          	ld	ra,24(sp)
 a6c:	01013403          	ld	s0,16(sp)
 a70:	06010113          	addi	sp,sp,96
 a74:	00008067          	ret

0000000000000a78 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a78:	ff010113          	addi	sp,sp,-16
 a7c:	00813423          	sd	s0,8(sp)
 a80:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a84:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a88:	00000797          	auipc	a5,0x0
 a8c:	5787b783          	ld	a5,1400(a5) # 1000 <freep>
 a90:	0400006f          	j	ad0 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a94:	00862703          	lw	a4,8(a2)
 a98:	00b7073b          	addw	a4,a4,a1
 a9c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 aa0:	0007b703          	ld	a4,0(a5)
 aa4:	00073603          	ld	a2,0(a4)
 aa8:	0500006f          	j	af8 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 aac:	ff852703          	lw	a4,-8(a0)
 ab0:	00c7073b          	addw	a4,a4,a2
 ab4:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ab8:	ff053683          	ld	a3,-16(a0)
 abc:	0540006f          	j	b10 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac0:	0007b703          	ld	a4,0(a5)
 ac4:	00e7e463          	bltu	a5,a4,acc <free+0x54>
 ac8:	00e6ec63          	bltu	a3,a4,ae0 <free+0x68>
{
 acc:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad0:	fed7f8e3          	bgeu	a5,a3,ac0 <free+0x48>
 ad4:	0007b703          	ld	a4,0(a5)
 ad8:	00e6e463          	bltu	a3,a4,ae0 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 adc:	fee7e8e3          	bltu	a5,a4,acc <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 ae0:	ff852583          	lw	a1,-8(a0)
 ae4:	0007b603          	ld	a2,0(a5)
 ae8:	02059813          	slli	a6,a1,0x20
 aec:	01c85713          	srli	a4,a6,0x1c
 af0:	00e68733          	add	a4,a3,a4
 af4:	fae600e3          	beq	a2,a4,a94 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 af8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 afc:	0087a603          	lw	a2,8(a5)
 b00:	02061593          	slli	a1,a2,0x20
 b04:	01c5d713          	srli	a4,a1,0x1c
 b08:	00e78733          	add	a4,a5,a4
 b0c:	fae680e3          	beq	a3,a4,aac <free+0x34>
    p->s.ptr = bp->s.ptr;
 b10:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b14:	00000717          	auipc	a4,0x0
 b18:	4ef73623          	sd	a5,1260(a4) # 1000 <freep>
}
 b1c:	00813403          	ld	s0,8(sp)
 b20:	01010113          	addi	sp,sp,16
 b24:	00008067          	ret

0000000000000b28 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b28:	fc010113          	addi	sp,sp,-64
 b2c:	02113c23          	sd	ra,56(sp)
 b30:	02813823          	sd	s0,48(sp)
 b34:	02913423          	sd	s1,40(sp)
 b38:	01313c23          	sd	s3,24(sp)
 b3c:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b40:	02051493          	slli	s1,a0,0x20
 b44:	0204d493          	srli	s1,s1,0x20
 b48:	00f48493          	addi	s1,s1,15
 b4c:	0044d493          	srli	s1,s1,0x4
 b50:	0014899b          	addiw	s3,s1,1
 b54:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
 b58:	00000517          	auipc	a0,0x0
 b5c:	4a853503          	ld	a0,1192(a0) # 1000 <freep>
 b60:	04050663          	beqz	a0,bac <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b64:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b68:	0087a703          	lw	a4,8(a5)
 b6c:	0c977c63          	bgeu	a4,s1,c44 <malloc+0x11c>
 b70:	03213023          	sd	s2,32(sp)
 b74:	01413823          	sd	s4,16(sp)
 b78:	01513423          	sd	s5,8(sp)
 b7c:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
 b80:	00098a13          	mv	s4,s3
 b84:	0009871b          	sext.w	a4,s3
 b88:	000016b7          	lui	a3,0x1
 b8c:	00d77463          	bgeu	a4,a3,b94 <malloc+0x6c>
 b90:	00001a37          	lui	s4,0x1
 b94:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b98:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b9c:	00000917          	auipc	s2,0x0
 ba0:	46490913          	addi	s2,s2,1124 # 1000 <freep>
  if(p == (char*)-1)
 ba4:	fff00a93          	li	s5,-1
 ba8:	05c0006f          	j	c04 <malloc+0xdc>
 bac:	03213023          	sd	s2,32(sp)
 bb0:	01413823          	sd	s4,16(sp)
 bb4:	01513423          	sd	s5,8(sp)
 bb8:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 bbc:	00000797          	auipc	a5,0x0
 bc0:	45478793          	addi	a5,a5,1108 # 1010 <base>
 bc4:	00000717          	auipc	a4,0x0
 bc8:	42f73e23          	sd	a5,1084(a4) # 1000 <freep>
 bcc:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 bd0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bd4:	fadff06f          	j	b80 <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
 bd8:	0007b703          	ld	a4,0(a5)
 bdc:	00e53023          	sd	a4,0(a0)
 be0:	0800006f          	j	c60 <malloc+0x138>
  hp->s.size = nu;
 be4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 be8:	01050513          	addi	a0,a0,16
 bec:	e8dff0ef          	jal	a78 <free>
  return freep;
 bf0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bf4:	08050863          	beqz	a0,c84 <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bf8:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bfc:	0087a703          	lw	a4,8(a5)
 c00:	02977a63          	bgeu	a4,s1,c34 <malloc+0x10c>
    if(p == freep)
 c04:	00093703          	ld	a4,0(s2)
 c08:	00078513          	mv	a0,a5
 c0c:	fef716e3          	bne	a4,a5,bf8 <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
 c10:	000a0513          	mv	a0,s4
 c14:	8fdff0ef          	jal	510 <sbrk>
  if(p == (char*)-1)
 c18:	fd5516e3          	bne	a0,s5,be4 <malloc+0xbc>
        return 0;
 c1c:	00000513          	li	a0,0
 c20:	02013903          	ld	s2,32(sp)
 c24:	01013a03          	ld	s4,16(sp)
 c28:	00813a83          	ld	s5,8(sp)
 c2c:	00013b03          	ld	s6,0(sp)
 c30:	03c0006f          	j	c6c <malloc+0x144>
 c34:	02013903          	ld	s2,32(sp)
 c38:	01013a03          	ld	s4,16(sp)
 c3c:	00813a83          	ld	s5,8(sp)
 c40:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
 c44:	f8e48ae3          	beq	s1,a4,bd8 <malloc+0xb0>
        p->s.size -= nunits;
 c48:	4137073b          	subw	a4,a4,s3
 c4c:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 c50:	02071693          	slli	a3,a4,0x20
 c54:	01c6d713          	srli	a4,a3,0x1c
 c58:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 c5c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c60:	00000717          	auipc	a4,0x0
 c64:	3aa73023          	sd	a0,928(a4) # 1000 <freep>
      return (void*)(p + 1);
 c68:	01078513          	addi	a0,a5,16
  }
}
 c6c:	03813083          	ld	ra,56(sp)
 c70:	03013403          	ld	s0,48(sp)
 c74:	02813483          	ld	s1,40(sp)
 c78:	01813983          	ld	s3,24(sp)
 c7c:	04010113          	addi	sp,sp,64
 c80:	00008067          	ret
 c84:	02013903          	ld	s2,32(sp)
 c88:	01013a03          	ld	s4,16(sp)
 c8c:	00813a83          	ld	s5,8(sp)
 c90:	00013b03          	ld	s6,0(sp)
 c94:	fd9ff06f          	j	c6c <malloc+0x144>
