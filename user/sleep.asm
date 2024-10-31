
user/_sleep:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char **argv)
{
   0:	ff010113          	addi	sp,sp,-16
   4:	00113423          	sd	ra,8(sp)
   8:	00813023          	sd	s0,0(sp)
   c:	01010413          	addi	s0,sp,16

	if(argc < 2)
  10:	00100793          	li	a5,1
  14:	02a7d263          	bge	a5,a0,38 <main+0x38>
	{
		fprintf(2, "usage: sleep [time]\n");
    	exit(1);
	}

	sleep(atoi(argv[1]));
  18:	0085b503          	ld	a0,8(a1)
  1c:	29c000ef          	jal	2b8 <atoi>
  20:	4dc000ef          	jal	4fc <sleep>

	return 0;

  24:	00000513          	li	a0,0
  28:	00813083          	ld	ra,8(sp)
  2c:	00013403          	ld	s0,0(sp)
  30:	01010113          	addi	sp,sp,16
  34:	00008067          	ret
		fprintf(2, "usage: sleep [time]\n");
  38:	00001597          	auipc	a1,0x1
  3c:	c4858593          	addi	a1,a1,-952 # c80 <malloc+0x178>
  40:	00200513          	li	a0,2
  44:	181000ef          	jal	9c4 <fprintf>
    	exit(1);
  48:	00100513          	li	a0,1
  4c:	3d8000ef          	jal	424 <exit>

0000000000000050 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  50:	ff010113          	addi	sp,sp,-16
  54:	00113423          	sd	ra,8(sp)
  58:	00813023          	sd	s0,0(sp)
  5c:	01010413          	addi	s0,sp,16
  extern int main();
  main();
  60:	fa1ff0ef          	jal	0 <main>
  exit(0);
  64:	00000513          	li	a0,0
  68:	3bc000ef          	jal	424 <exit>

000000000000006c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  6c:	ff010113          	addi	sp,sp,-16
  70:	00813423          	sd	s0,8(sp)
  74:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  78:	00050793          	mv	a5,a0
  7c:	00158593          	addi	a1,a1,1
  80:	00178793          	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fe0718e3          	bnez	a4,7c <strcpy+0x10>
    ;
  return os;
}
  90:	00813403          	ld	s0,8(sp)
  94:	01010113          	addi	sp,sp,16
  98:	00008067          	ret

000000000000009c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9c:	ff010113          	addi	sp,sp,-16
  a0:	00813423          	sd	s0,8(sp)
  a4:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
  a8:	00054783          	lbu	a5,0(a0)
  ac:	00078e63          	beqz	a5,c8 <strcmp+0x2c>
  b0:	0005c703          	lbu	a4,0(a1)
  b4:	00f71a63          	bne	a4,a5,c8 <strcmp+0x2c>
    p++, q++;
  b8:	00150513          	addi	a0,a0,1
  bc:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
  c0:	00054783          	lbu	a5,0(a0)
  c4:	fe0796e3          	bnez	a5,b0 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  c8:	0005c503          	lbu	a0,0(a1)
}
  cc:	40a7853b          	subw	a0,a5,a0
  d0:	00813403          	ld	s0,8(sp)
  d4:	01010113          	addi	sp,sp,16
  d8:	00008067          	ret

00000000000000dc <strlen>:

uint
strlen(const char *s)
{
  dc:	ff010113          	addi	sp,sp,-16
  e0:	00813423          	sd	s0,8(sp)
  e4:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e8:	00054783          	lbu	a5,0(a0)
  ec:	02078863          	beqz	a5,11c <strlen+0x40>
  f0:	00150513          	addi	a0,a0,1
  f4:	00050793          	mv	a5,a0
  f8:	00078693          	mv	a3,a5
  fc:	00178793          	addi	a5,a5,1
 100:	fff7c703          	lbu	a4,-1(a5)
 104:	fe071ae3          	bnez	a4,f8 <strlen+0x1c>
 108:	40a6853b          	subw	a0,a3,a0
 10c:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
 110:	00813403          	ld	s0,8(sp)
 114:	01010113          	addi	sp,sp,16
 118:	00008067          	ret
  for(n = 0; s[n]; n++)
 11c:	00000513          	li	a0,0
 120:	ff1ff06f          	j	110 <strlen+0x34>

0000000000000124 <memset>:

void*
memset(void *dst, int c, uint n)
{
 124:	ff010113          	addi	sp,sp,-16
 128:	00813423          	sd	s0,8(sp)
 12c:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 130:	02060063          	beqz	a2,150 <memset+0x2c>
 134:	00050793          	mv	a5,a0
 138:	02061613          	slli	a2,a2,0x20
 13c:	02065613          	srli	a2,a2,0x20
 140:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 144:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 148:	00178793          	addi	a5,a5,1
 14c:	fee79ce3          	bne	a5,a4,144 <memset+0x20>
  }
  return dst;
}
 150:	00813403          	ld	s0,8(sp)
 154:	01010113          	addi	sp,sp,16
 158:	00008067          	ret

000000000000015c <strchr>:

char*
strchr(const char *s, char c)
{
 15c:	ff010113          	addi	sp,sp,-16
 160:	00813423          	sd	s0,8(sp)
 164:	01010413          	addi	s0,sp,16
  for(; *s; s++)
 168:	00054783          	lbu	a5,0(a0)
 16c:	02078263          	beqz	a5,190 <strchr+0x34>
    if(*s == c)
 170:	00f58a63          	beq	a1,a5,184 <strchr+0x28>
  for(; *s; s++)
 174:	00150513          	addi	a0,a0,1
 178:	00054783          	lbu	a5,0(a0)
 17c:	fe079ae3          	bnez	a5,170 <strchr+0x14>
      return (char*)s;
  return 0;
 180:	00000513          	li	a0,0
}
 184:	00813403          	ld	s0,8(sp)
 188:	01010113          	addi	sp,sp,16
 18c:	00008067          	ret
  return 0;
 190:	00000513          	li	a0,0
 194:	ff1ff06f          	j	184 <strchr+0x28>

0000000000000198 <gets>:

char*
gets(char *buf, int max)
{
 198:	fa010113          	addi	sp,sp,-96
 19c:	04113c23          	sd	ra,88(sp)
 1a0:	04813823          	sd	s0,80(sp)
 1a4:	04913423          	sd	s1,72(sp)
 1a8:	05213023          	sd	s2,64(sp)
 1ac:	03313c23          	sd	s3,56(sp)
 1b0:	03413823          	sd	s4,48(sp)
 1b4:	03513423          	sd	s5,40(sp)
 1b8:	03613023          	sd	s6,32(sp)
 1bc:	01713c23          	sd	s7,24(sp)
 1c0:	06010413          	addi	s0,sp,96
 1c4:	00050b93          	mv	s7,a0
 1c8:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cc:	00050913          	mv	s2,a0
 1d0:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1d4:	00a00a93          	li	s5,10
 1d8:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 1dc:	00048993          	mv	s3,s1
 1e0:	0014849b          	addiw	s1,s1,1
 1e4:	0344dc63          	bge	s1,s4,21c <gets+0x84>
    cc = read(0, &c, 1);
 1e8:	00100613          	li	a2,1
 1ec:	faf40593          	addi	a1,s0,-81
 1f0:	00000513          	li	a0,0
 1f4:	254000ef          	jal	448 <read>
    if(cc < 1)
 1f8:	02a05263          	blez	a0,21c <gets+0x84>
    buf[i++] = c;
 1fc:	faf44783          	lbu	a5,-81(s0)
 200:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 204:	01578a63          	beq	a5,s5,218 <gets+0x80>
 208:	00190913          	addi	s2,s2,1
 20c:	fd6798e3          	bne	a5,s6,1dc <gets+0x44>
    buf[i++] = c;
 210:	00048993          	mv	s3,s1
 214:	0080006f          	j	21c <gets+0x84>
 218:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 21c:	013b89b3          	add	s3,s7,s3
 220:	00098023          	sb	zero,0(s3)
  return buf;
}
 224:	000b8513          	mv	a0,s7
 228:	05813083          	ld	ra,88(sp)
 22c:	05013403          	ld	s0,80(sp)
 230:	04813483          	ld	s1,72(sp)
 234:	04013903          	ld	s2,64(sp)
 238:	03813983          	ld	s3,56(sp)
 23c:	03013a03          	ld	s4,48(sp)
 240:	02813a83          	ld	s5,40(sp)
 244:	02013b03          	ld	s6,32(sp)
 248:	01813b83          	ld	s7,24(sp)
 24c:	06010113          	addi	sp,sp,96
 250:	00008067          	ret

0000000000000254 <stat>:

int
stat(const char *n, struct stat *st)
{
 254:	fe010113          	addi	sp,sp,-32
 258:	00113c23          	sd	ra,24(sp)
 25c:	00813823          	sd	s0,16(sp)
 260:	01213023          	sd	s2,0(sp)
 264:	02010413          	addi	s0,sp,32
 268:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26c:	00000593          	li	a1,0
 270:	214000ef          	jal	484 <open>
  if(fd < 0)
 274:	02054e63          	bltz	a0,2b0 <stat+0x5c>
 278:	00913423          	sd	s1,8(sp)
 27c:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 280:	00090593          	mv	a1,s2
 284:	224000ef          	jal	4a8 <fstat>
 288:	00050913          	mv	s2,a0
  close(fd);
 28c:	00048513          	mv	a0,s1
 290:	1d0000ef          	jal	460 <close>
  return r;
 294:	00813483          	ld	s1,8(sp)
}
 298:	00090513          	mv	a0,s2
 29c:	01813083          	ld	ra,24(sp)
 2a0:	01013403          	ld	s0,16(sp)
 2a4:	00013903          	ld	s2,0(sp)
 2a8:	02010113          	addi	sp,sp,32
 2ac:	00008067          	ret
    return -1;
 2b0:	fff00913          	li	s2,-1
 2b4:	fe5ff06f          	j	298 <stat+0x44>

00000000000002b8 <atoi>:

int
atoi(const char *s)
{
 2b8:	ff010113          	addi	sp,sp,-16
 2bc:	00813423          	sd	s0,8(sp)
 2c0:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c4:	00054683          	lbu	a3,0(a0)
 2c8:	fd06879b          	addiw	a5,a3,-48
 2cc:	0ff7f793          	zext.b	a5,a5
 2d0:	00900613          	li	a2,9
 2d4:	04f66063          	bltu	a2,a5,314 <atoi+0x5c>
 2d8:	00050713          	mv	a4,a0
  n = 0;
 2dc:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 2e0:	00170713          	addi	a4,a4,1
 2e4:	0025179b          	slliw	a5,a0,0x2
 2e8:	00a787bb          	addw	a5,a5,a0
 2ec:	0017979b          	slliw	a5,a5,0x1
 2f0:	00d787bb          	addw	a5,a5,a3
 2f4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2f8:	00074683          	lbu	a3,0(a4)
 2fc:	fd06879b          	addiw	a5,a3,-48
 300:	0ff7f793          	zext.b	a5,a5
 304:	fcf67ee3          	bgeu	a2,a5,2e0 <atoi+0x28>
  return n;
}
 308:	00813403          	ld	s0,8(sp)
 30c:	01010113          	addi	sp,sp,16
 310:	00008067          	ret
  n = 0;
 314:	00000513          	li	a0,0
 318:	ff1ff06f          	j	308 <atoi+0x50>

000000000000031c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 31c:	ff010113          	addi	sp,sp,-16
 320:	00813423          	sd	s0,8(sp)
 324:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 328:	02b57c63          	bgeu	a0,a1,360 <memmove+0x44>
    while(n-- > 0)
 32c:	02c05463          	blez	a2,354 <memmove+0x38>
 330:	02061613          	slli	a2,a2,0x20
 334:	02065613          	srli	a2,a2,0x20
 338:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 33c:	00050713          	mv	a4,a0
      *dst++ = *src++;
 340:	00158593          	addi	a1,a1,1
 344:	00170713          	addi	a4,a4,1
 348:	fff5c683          	lbu	a3,-1(a1)
 34c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 350:	fef718e3          	bne	a4,a5,340 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 354:	00813403          	ld	s0,8(sp)
 358:	01010113          	addi	sp,sp,16
 35c:	00008067          	ret
    dst += n;
 360:	00c50733          	add	a4,a0,a2
    src += n;
 364:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 368:	fec056e3          	blez	a2,354 <memmove+0x38>
 36c:	fff6079b          	addiw	a5,a2,-1
 370:	02079793          	slli	a5,a5,0x20
 374:	0207d793          	srli	a5,a5,0x20
 378:	fff7c793          	not	a5,a5
 37c:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 380:	fff58593          	addi	a1,a1,-1
 384:	fff70713          	addi	a4,a4,-1
 388:	0005c683          	lbu	a3,0(a1)
 38c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 390:	fee798e3          	bne	a5,a4,380 <memmove+0x64>
 394:	fc1ff06f          	j	354 <memmove+0x38>

0000000000000398 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 398:	ff010113          	addi	sp,sp,-16
 39c:	00813423          	sd	s0,8(sp)
 3a0:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a4:	04060463          	beqz	a2,3ec <memcmp+0x54>
 3a8:	fff6069b          	addiw	a3,a2,-1
 3ac:	02069693          	slli	a3,a3,0x20
 3b0:	0206d693          	srli	a3,a3,0x20
 3b4:	00168693          	addi	a3,a3,1
 3b8:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 3bc:	00054783          	lbu	a5,0(a0)
 3c0:	0005c703          	lbu	a4,0(a1)
 3c4:	00e79c63          	bne	a5,a4,3dc <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 3c8:	00150513          	addi	a0,a0,1
    p2++;
 3cc:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
 3d0:	fed516e3          	bne	a0,a3,3bc <memcmp+0x24>
  }
  return 0;
 3d4:	00000513          	li	a0,0
 3d8:	0080006f          	j	3e0 <memcmp+0x48>
      return *p1 - *p2;
 3dc:	40e7853b          	subw	a0,a5,a4
}
 3e0:	00813403          	ld	s0,8(sp)
 3e4:	01010113          	addi	sp,sp,16
 3e8:	00008067          	ret
  return 0;
 3ec:	00000513          	li	a0,0
 3f0:	ff1ff06f          	j	3e0 <memcmp+0x48>

00000000000003f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3f4:	ff010113          	addi	sp,sp,-16
 3f8:	00113423          	sd	ra,8(sp)
 3fc:	00813023          	sd	s0,0(sp)
 400:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
 404:	f19ff0ef          	jal	31c <memmove>
}
 408:	00813083          	ld	ra,8(sp)
 40c:	00013403          	ld	s0,0(sp)
 410:	01010113          	addi	sp,sp,16
 414:	00008067          	ret

0000000000000418 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 418:	00100893          	li	a7,1
 ecall
 41c:	00000073          	ecall
 ret
 420:	00008067          	ret

0000000000000424 <exit>:
.global exit
exit:
 li a7, SYS_exit
 424:	00200893          	li	a7,2
 ecall
 428:	00000073          	ecall
 ret
 42c:	00008067          	ret

0000000000000430 <wait>:
.global wait
wait:
 li a7, SYS_wait
 430:	00300893          	li	a7,3
 ecall
 434:	00000073          	ecall
 ret
 438:	00008067          	ret

000000000000043c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 43c:	00400893          	li	a7,4
 ecall
 440:	00000073          	ecall
 ret
 444:	00008067          	ret

0000000000000448 <read>:
.global read
read:
 li a7, SYS_read
 448:	00500893          	li	a7,5
 ecall
 44c:	00000073          	ecall
 ret
 450:	00008067          	ret

0000000000000454 <write>:
.global write
write:
 li a7, SYS_write
 454:	01000893          	li	a7,16
 ecall
 458:	00000073          	ecall
 ret
 45c:	00008067          	ret

0000000000000460 <close>:
.global close
close:
 li a7, SYS_close
 460:	01500893          	li	a7,21
 ecall
 464:	00000073          	ecall
 ret
 468:	00008067          	ret

000000000000046c <kill>:
.global kill
kill:
 li a7, SYS_kill
 46c:	00600893          	li	a7,6
 ecall
 470:	00000073          	ecall
 ret
 474:	00008067          	ret

0000000000000478 <exec>:
.global exec
exec:
 li a7, SYS_exec
 478:	00700893          	li	a7,7
 ecall
 47c:	00000073          	ecall
 ret
 480:	00008067          	ret

0000000000000484 <open>:
.global open
open:
 li a7, SYS_open
 484:	00f00893          	li	a7,15
 ecall
 488:	00000073          	ecall
 ret
 48c:	00008067          	ret

0000000000000490 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 490:	01100893          	li	a7,17
 ecall
 494:	00000073          	ecall
 ret
 498:	00008067          	ret

000000000000049c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 49c:	01200893          	li	a7,18
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	00008067          	ret

00000000000004a8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4a8:	00800893          	li	a7,8
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	00008067          	ret

00000000000004b4 <link>:
.global link
link:
 li a7, SYS_link
 4b4:	01300893          	li	a7,19
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	00008067          	ret

00000000000004c0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4c0:	01400893          	li	a7,20
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	00008067          	ret

00000000000004cc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4cc:	00900893          	li	a7,9
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	00008067          	ret

00000000000004d8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4d8:	00a00893          	li	a7,10
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	00008067          	ret

00000000000004e4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4e4:	00b00893          	li	a7,11
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	00008067          	ret

00000000000004f0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f0:	00c00893          	li	a7,12
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	00008067          	ret

00000000000004fc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4fc:	00d00893          	li	a7,13
 ecall
 500:	00000073          	ecall
 ret
 504:	00008067          	ret

0000000000000508 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 508:	00e00893          	li	a7,14
 ecall
 50c:	00000073          	ecall
 ret
 510:	00008067          	ret

0000000000000514 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 514:	fe010113          	addi	sp,sp,-32
 518:	00113c23          	sd	ra,24(sp)
 51c:	00813823          	sd	s0,16(sp)
 520:	02010413          	addi	s0,sp,32
 524:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 528:	00100613          	li	a2,1
 52c:	fef40593          	addi	a1,s0,-17
 530:	f25ff0ef          	jal	454 <write>
}
 534:	01813083          	ld	ra,24(sp)
 538:	01013403          	ld	s0,16(sp)
 53c:	02010113          	addi	sp,sp,32
 540:	00008067          	ret

0000000000000544 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 544:	fc010113          	addi	sp,sp,-64
 548:	02113c23          	sd	ra,56(sp)
 54c:	02813823          	sd	s0,48(sp)
 550:	02913423          	sd	s1,40(sp)
 554:	04010413          	addi	s0,sp,64
 558:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 55c:	00068463          	beqz	a3,564 <printint+0x20>
 560:	0c05c263          	bltz	a1,624 <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 564:	0005859b          	sext.w	a1,a1
  neg = 0;
 568:	00000893          	li	a7,0
 56c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 570:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 574:	0006061b          	sext.w	a2,a2
 578:	00000517          	auipc	a0,0x0
 57c:	72850513          	addi	a0,a0,1832 # ca0 <digits>
 580:	00070813          	mv	a6,a4
 584:	0017071b          	addiw	a4,a4,1
 588:	02c5f7bb          	remuw	a5,a1,a2
 58c:	02079793          	slli	a5,a5,0x20
 590:	0207d793          	srli	a5,a5,0x20
 594:	00f507b3          	add	a5,a0,a5
 598:	0007c783          	lbu	a5,0(a5)
 59c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5a0:	0005879b          	sext.w	a5,a1
 5a4:	02c5d5bb          	divuw	a1,a1,a2
 5a8:	00168693          	addi	a3,a3,1
 5ac:	fcc7fae3          	bgeu	a5,a2,580 <printint+0x3c>
  if(neg)
 5b0:	00088c63          	beqz	a7,5c8 <printint+0x84>
    buf[i++] = '-';
 5b4:	fd070793          	addi	a5,a4,-48
 5b8:	00878733          	add	a4,a5,s0
 5bc:	02d00793          	li	a5,45
 5c0:	fef70823          	sb	a5,-16(a4)
 5c4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5c8:	04e05463          	blez	a4,610 <printint+0xcc>
 5cc:	03213023          	sd	s2,32(sp)
 5d0:	01313c23          	sd	s3,24(sp)
 5d4:	fc040793          	addi	a5,s0,-64
 5d8:	00e78933          	add	s2,a5,a4
 5dc:	fff78993          	addi	s3,a5,-1
 5e0:	00e989b3          	add	s3,s3,a4
 5e4:	fff7071b          	addiw	a4,a4,-1
 5e8:	02071713          	slli	a4,a4,0x20
 5ec:	02075713          	srli	a4,a4,0x20
 5f0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5f4:	fff94583          	lbu	a1,-1(s2)
 5f8:	00048513          	mv	a0,s1
 5fc:	f19ff0ef          	jal	514 <putc>
  while(--i >= 0)
 600:	fff90913          	addi	s2,s2,-1
 604:	ff3918e3          	bne	s2,s3,5f4 <printint+0xb0>
 608:	02013903          	ld	s2,32(sp)
 60c:	01813983          	ld	s3,24(sp)
}
 610:	03813083          	ld	ra,56(sp)
 614:	03013403          	ld	s0,48(sp)
 618:	02813483          	ld	s1,40(sp)
 61c:	04010113          	addi	sp,sp,64
 620:	00008067          	ret
    x = -xx;
 624:	40b005bb          	negw	a1,a1
    neg = 1;
 628:	00100893          	li	a7,1
    x = -xx;
 62c:	f41ff06f          	j	56c <printint+0x28>

0000000000000630 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 630:	fa010113          	addi	sp,sp,-96
 634:	04113c23          	sd	ra,88(sp)
 638:	04813823          	sd	s0,80(sp)
 63c:	05213023          	sd	s2,64(sp)
 640:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 644:	0005c903          	lbu	s2,0(a1)
 648:	36090463          	beqz	s2,9b0 <vprintf+0x380>
 64c:	04913423          	sd	s1,72(sp)
 650:	03313c23          	sd	s3,56(sp)
 654:	03413823          	sd	s4,48(sp)
 658:	03513423          	sd	s5,40(sp)
 65c:	03613023          	sd	s6,32(sp)
 660:	01713c23          	sd	s7,24(sp)
 664:	01813823          	sd	s8,16(sp)
 668:	01913423          	sd	s9,8(sp)
 66c:	00050b13          	mv	s6,a0
 670:	00058a13          	mv	s4,a1
 674:	00060b93          	mv	s7,a2
  state = 0;
 678:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
 67c:	00000493          	li	s1,0
 680:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 684:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 688:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 68c:	06c00c93          	li	s9,108
 690:	02c0006f          	j	6bc <vprintf+0x8c>
        putc(fd, c0);
 694:	00090593          	mv	a1,s2
 698:	000b0513          	mv	a0,s6
 69c:	e79ff0ef          	jal	514 <putc>
 6a0:	0080006f          	j	6a8 <vprintf+0x78>
    } else if(state == '%'){
 6a4:	03598663          	beq	s3,s5,6d0 <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
 6a8:	0014849b          	addiw	s1,s1,1
 6ac:	00048713          	mv	a4,s1
 6b0:	009a07b3          	add	a5,s4,s1
 6b4:	0007c903          	lbu	s2,0(a5)
 6b8:	2c090c63          	beqz	s2,990 <vprintf+0x360>
    c0 = fmt[i] & 0xff;
 6bc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6c0:	fe0992e3          	bnez	s3,6a4 <vprintf+0x74>
      if(c0 == '%'){
 6c4:	fd5798e3          	bne	a5,s5,694 <vprintf+0x64>
        state = '%';
 6c8:	00078993          	mv	s3,a5
 6cc:	fddff06f          	j	6a8 <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
 6d0:	00ea06b3          	add	a3,s4,a4
 6d4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6d8:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6dc:	00068663          	beqz	a3,6e8 <vprintf+0xb8>
 6e0:	00ea0733          	add	a4,s4,a4
 6e4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6e8:	05878263          	beq	a5,s8,72c <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
 6ec:	07978263          	beq	a5,s9,750 <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6f0:	07500713          	li	a4,117
 6f4:	12e78663          	beq	a5,a4,820 <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6f8:	07800713          	li	a4,120
 6fc:	18e78c63          	beq	a5,a4,894 <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 700:	07000713          	li	a4,112
 704:	1ce78e63          	beq	a5,a4,8e0 <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 708:	07300713          	li	a4,115
 70c:	22e78a63          	beq	a5,a4,940 <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 710:	02500713          	li	a4,37
 714:	04e79e63          	bne	a5,a4,770 <vprintf+0x140>
        putc(fd, '%');
 718:	02500593          	li	a1,37
 71c:	000b0513          	mv	a0,s6
 720:	df5ff0ef          	jal	514 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 724:	00000993          	li	s3,0
 728:	f81ff06f          	j	6a8 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
 72c:	008b8913          	addi	s2,s7,8
 730:	00100693          	li	a3,1
 734:	00a00613          	li	a2,10
 738:	000ba583          	lw	a1,0(s7)
 73c:	000b0513          	mv	a0,s6
 740:	e05ff0ef          	jal	544 <printint>
 744:	00090b93          	mv	s7,s2
      state = 0;
 748:	00000993          	li	s3,0
 74c:	f5dff06f          	j	6a8 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
 750:	06400793          	li	a5,100
 754:	02f68e63          	beq	a3,a5,790 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 758:	06c00793          	li	a5,108
 75c:	04f68e63          	beq	a3,a5,7b8 <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
 760:	07500793          	li	a5,117
 764:	0ef68063          	beq	a3,a5,844 <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
 768:	07800793          	li	a5,120
 76c:	14f68663          	beq	a3,a5,8b8 <vprintf+0x288>
        putc(fd, '%');
 770:	02500593          	li	a1,37
 774:	000b0513          	mv	a0,s6
 778:	d9dff0ef          	jal	514 <putc>
        putc(fd, c0);
 77c:	00090593          	mv	a1,s2
 780:	000b0513          	mv	a0,s6
 784:	d91ff0ef          	jal	514 <putc>
      state = 0;
 788:	00000993          	li	s3,0
 78c:	f1dff06f          	j	6a8 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 790:	008b8913          	addi	s2,s7,8
 794:	00100693          	li	a3,1
 798:	00a00613          	li	a2,10
 79c:	000ba583          	lw	a1,0(s7)
 7a0:	000b0513          	mv	a0,s6
 7a4:	da1ff0ef          	jal	544 <printint>
        i += 1;
 7a8:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ac:	00090b93          	mv	s7,s2
      state = 0;
 7b0:	00000993          	li	s3,0
        i += 1;
 7b4:	ef5ff06f          	j	6a8 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7b8:	06400793          	li	a5,100
 7bc:	02f60e63          	beq	a2,a5,7f8 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7c0:	07500793          	li	a5,117
 7c4:	0af60463          	beq	a2,a5,86c <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7c8:	07800793          	li	a5,120
 7cc:	faf612e3          	bne	a2,a5,770 <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d0:	008b8913          	addi	s2,s7,8
 7d4:	00000693          	li	a3,0
 7d8:	01000613          	li	a2,16
 7dc:	000ba583          	lw	a1,0(s7)
 7e0:	000b0513          	mv	a0,s6
 7e4:	d61ff0ef          	jal	544 <printint>
        i += 2;
 7e8:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ec:	00090b93          	mv	s7,s2
      state = 0;
 7f0:	00000993          	li	s3,0
        i += 2;
 7f4:	eb5ff06f          	j	6a8 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f8:	008b8913          	addi	s2,s7,8
 7fc:	00100693          	li	a3,1
 800:	00a00613          	li	a2,10
 804:	000ba583          	lw	a1,0(s7)
 808:	000b0513          	mv	a0,s6
 80c:	d39ff0ef          	jal	544 <printint>
        i += 2;
 810:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 814:	00090b93          	mv	s7,s2
      state = 0;
 818:	00000993          	li	s3,0
        i += 2;
 81c:	e8dff06f          	j	6a8 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
 820:	008b8913          	addi	s2,s7,8
 824:	00000693          	li	a3,0
 828:	00a00613          	li	a2,10
 82c:	000ba583          	lw	a1,0(s7)
 830:	000b0513          	mv	a0,s6
 834:	d11ff0ef          	jal	544 <printint>
 838:	00090b93          	mv	s7,s2
      state = 0;
 83c:	00000993          	li	s3,0
 840:	e69ff06f          	j	6a8 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 844:	008b8913          	addi	s2,s7,8
 848:	00000693          	li	a3,0
 84c:	00a00613          	li	a2,10
 850:	000ba583          	lw	a1,0(s7)
 854:	000b0513          	mv	a0,s6
 858:	cedff0ef          	jal	544 <printint>
        i += 1;
 85c:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 860:	00090b93          	mv	s7,s2
      state = 0;
 864:	00000993          	li	s3,0
        i += 1;
 868:	e41ff06f          	j	6a8 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 86c:	008b8913          	addi	s2,s7,8
 870:	00000693          	li	a3,0
 874:	00a00613          	li	a2,10
 878:	000ba583          	lw	a1,0(s7)
 87c:	000b0513          	mv	a0,s6
 880:	cc5ff0ef          	jal	544 <printint>
        i += 2;
 884:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 888:	00090b93          	mv	s7,s2
      state = 0;
 88c:	00000993          	li	s3,0
        i += 2;
 890:	e19ff06f          	j	6a8 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
 894:	008b8913          	addi	s2,s7,8
 898:	00000693          	li	a3,0
 89c:	01000613          	li	a2,16
 8a0:	000ba583          	lw	a1,0(s7)
 8a4:	000b0513          	mv	a0,s6
 8a8:	c9dff0ef          	jal	544 <printint>
 8ac:	00090b93          	mv	s7,s2
      state = 0;
 8b0:	00000993          	li	s3,0
 8b4:	df5ff06f          	j	6a8 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8b8:	008b8913          	addi	s2,s7,8
 8bc:	00000693          	li	a3,0
 8c0:	01000613          	li	a2,16
 8c4:	000ba583          	lw	a1,0(s7)
 8c8:	000b0513          	mv	a0,s6
 8cc:	c79ff0ef          	jal	544 <printint>
        i += 1;
 8d0:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8d4:	00090b93          	mv	s7,s2
      state = 0;
 8d8:	00000993          	li	s3,0
        i += 1;
 8dc:	dcdff06f          	j	6a8 <vprintf+0x78>
 8e0:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 8e4:	008b8d13          	addi	s10,s7,8
 8e8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8ec:	03000593          	li	a1,48
 8f0:	000b0513          	mv	a0,s6
 8f4:	c21ff0ef          	jal	514 <putc>
  putc(fd, 'x');
 8f8:	07800593          	li	a1,120
 8fc:	000b0513          	mv	a0,s6
 900:	c15ff0ef          	jal	514 <putc>
 904:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 908:	00000b97          	auipc	s7,0x0
 90c:	398b8b93          	addi	s7,s7,920 # ca0 <digits>
 910:	03c9d793          	srli	a5,s3,0x3c
 914:	00fb87b3          	add	a5,s7,a5
 918:	0007c583          	lbu	a1,0(a5)
 91c:	000b0513          	mv	a0,s6
 920:	bf5ff0ef          	jal	514 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 924:	00499993          	slli	s3,s3,0x4
 928:	fff9091b          	addiw	s2,s2,-1
 92c:	fe0912e3          	bnez	s2,910 <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
 930:	000d0b93          	mv	s7,s10
      state = 0;
 934:	00000993          	li	s3,0
 938:	00013d03          	ld	s10,0(sp)
 93c:	d6dff06f          	j	6a8 <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
 940:	008b8993          	addi	s3,s7,8
 944:	000bb903          	ld	s2,0(s7)
 948:	02090663          	beqz	s2,974 <vprintf+0x344>
        for(; *s; s++)
 94c:	00094583          	lbu	a1,0(s2)
 950:	02058a63          	beqz	a1,984 <vprintf+0x354>
          putc(fd, *s);
 954:	000b0513          	mv	a0,s6
 958:	bbdff0ef          	jal	514 <putc>
        for(; *s; s++)
 95c:	00190913          	addi	s2,s2,1
 960:	00094583          	lbu	a1,0(s2)
 964:	fe0598e3          	bnez	a1,954 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 968:	00098b93          	mv	s7,s3
      state = 0;
 96c:	00000993          	li	s3,0
 970:	d39ff06f          	j	6a8 <vprintf+0x78>
          s = "(null)";
 974:	00000917          	auipc	s2,0x0
 978:	32490913          	addi	s2,s2,804 # c98 <malloc+0x190>
        for(; *s; s++)
 97c:	02800593          	li	a1,40
 980:	fd5ff06f          	j	954 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 984:	00098b93          	mv	s7,s3
      state = 0;
 988:	00000993          	li	s3,0
 98c:	d1dff06f          	j	6a8 <vprintf+0x78>
 990:	04813483          	ld	s1,72(sp)
 994:	03813983          	ld	s3,56(sp)
 998:	03013a03          	ld	s4,48(sp)
 99c:	02813a83          	ld	s5,40(sp)
 9a0:	02013b03          	ld	s6,32(sp)
 9a4:	01813b83          	ld	s7,24(sp)
 9a8:	01013c03          	ld	s8,16(sp)
 9ac:	00813c83          	ld	s9,8(sp)
    }
  }
}
 9b0:	05813083          	ld	ra,88(sp)
 9b4:	05013403          	ld	s0,80(sp)
 9b8:	04013903          	ld	s2,64(sp)
 9bc:	06010113          	addi	sp,sp,96
 9c0:	00008067          	ret

00000000000009c4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9c4:	fb010113          	addi	sp,sp,-80
 9c8:	00113c23          	sd	ra,24(sp)
 9cc:	00813823          	sd	s0,16(sp)
 9d0:	02010413          	addi	s0,sp,32
 9d4:	00c43023          	sd	a2,0(s0)
 9d8:	00d43423          	sd	a3,8(s0)
 9dc:	00e43823          	sd	a4,16(s0)
 9e0:	00f43c23          	sd	a5,24(s0)
 9e4:	03043023          	sd	a6,32(s0)
 9e8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9ec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9f0:	00040613          	mv	a2,s0
 9f4:	c3dff0ef          	jal	630 <vprintf>
}
 9f8:	01813083          	ld	ra,24(sp)
 9fc:	01013403          	ld	s0,16(sp)
 a00:	05010113          	addi	sp,sp,80
 a04:	00008067          	ret

0000000000000a08 <printf>:

void
printf(const char *fmt, ...)
{
 a08:	fa010113          	addi	sp,sp,-96
 a0c:	00113c23          	sd	ra,24(sp)
 a10:	00813823          	sd	s0,16(sp)
 a14:	02010413          	addi	s0,sp,32
 a18:	00b43423          	sd	a1,8(s0)
 a1c:	00c43823          	sd	a2,16(s0)
 a20:	00d43c23          	sd	a3,24(s0)
 a24:	02e43023          	sd	a4,32(s0)
 a28:	02f43423          	sd	a5,40(s0)
 a2c:	03043823          	sd	a6,48(s0)
 a30:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a34:	00840613          	addi	a2,s0,8
 a38:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a3c:	00050593          	mv	a1,a0
 a40:	00100513          	li	a0,1
 a44:	bedff0ef          	jal	630 <vprintf>
}
 a48:	01813083          	ld	ra,24(sp)
 a4c:	01013403          	ld	s0,16(sp)
 a50:	06010113          	addi	sp,sp,96
 a54:	00008067          	ret

0000000000000a58 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a58:	ff010113          	addi	sp,sp,-16
 a5c:	00813423          	sd	s0,8(sp)
 a60:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a64:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a68:	00000797          	auipc	a5,0x0
 a6c:	5987b783          	ld	a5,1432(a5) # 1000 <freep>
 a70:	0400006f          	j	ab0 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a74:	00862703          	lw	a4,8(a2)
 a78:	00b7073b          	addw	a4,a4,a1
 a7c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a80:	0007b703          	ld	a4,0(a5)
 a84:	00073603          	ld	a2,0(a4)
 a88:	0500006f          	j	ad8 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a8c:	ff852703          	lw	a4,-8(a0)
 a90:	00c7073b          	addw	a4,a4,a2
 a94:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a98:	ff053683          	ld	a3,-16(a0)
 a9c:	0540006f          	j	af0 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa0:	0007b703          	ld	a4,0(a5)
 aa4:	00e7e463          	bltu	a5,a4,aac <free+0x54>
 aa8:	00e6ec63          	bltu	a3,a4,ac0 <free+0x68>
{
 aac:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab0:	fed7f8e3          	bgeu	a5,a3,aa0 <free+0x48>
 ab4:	0007b703          	ld	a4,0(a5)
 ab8:	00e6e463          	bltu	a3,a4,ac0 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 abc:	fee7e8e3          	bltu	a5,a4,aac <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 ac0:	ff852583          	lw	a1,-8(a0)
 ac4:	0007b603          	ld	a2,0(a5)
 ac8:	02059813          	slli	a6,a1,0x20
 acc:	01c85713          	srli	a4,a6,0x1c
 ad0:	00e68733          	add	a4,a3,a4
 ad4:	fae600e3          	beq	a2,a4,a74 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 ad8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 adc:	0087a603          	lw	a2,8(a5)
 ae0:	02061593          	slli	a1,a2,0x20
 ae4:	01c5d713          	srli	a4,a1,0x1c
 ae8:	00e78733          	add	a4,a5,a4
 aec:	fae680e3          	beq	a3,a4,a8c <free+0x34>
    p->s.ptr = bp->s.ptr;
 af0:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 af4:	00000717          	auipc	a4,0x0
 af8:	50f73623          	sd	a5,1292(a4) # 1000 <freep>
}
 afc:	00813403          	ld	s0,8(sp)
 b00:	01010113          	addi	sp,sp,16
 b04:	00008067          	ret

0000000000000b08 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b08:	fc010113          	addi	sp,sp,-64
 b0c:	02113c23          	sd	ra,56(sp)
 b10:	02813823          	sd	s0,48(sp)
 b14:	02913423          	sd	s1,40(sp)
 b18:	01313c23          	sd	s3,24(sp)
 b1c:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b20:	02051493          	slli	s1,a0,0x20
 b24:	0204d493          	srli	s1,s1,0x20
 b28:	00f48493          	addi	s1,s1,15
 b2c:	0044d493          	srli	s1,s1,0x4
 b30:	0014899b          	addiw	s3,s1,1
 b34:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
 b38:	00000517          	auipc	a0,0x0
 b3c:	4c853503          	ld	a0,1224(a0) # 1000 <freep>
 b40:	04050663          	beqz	a0,b8c <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b44:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b48:	0087a703          	lw	a4,8(a5)
 b4c:	0c977c63          	bgeu	a4,s1,c24 <malloc+0x11c>
 b50:	03213023          	sd	s2,32(sp)
 b54:	01413823          	sd	s4,16(sp)
 b58:	01513423          	sd	s5,8(sp)
 b5c:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
 b60:	00098a13          	mv	s4,s3
 b64:	0009871b          	sext.w	a4,s3
 b68:	000016b7          	lui	a3,0x1
 b6c:	00d77463          	bgeu	a4,a3,b74 <malloc+0x6c>
 b70:	00001a37          	lui	s4,0x1
 b74:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b78:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b7c:	00000917          	auipc	s2,0x0
 b80:	48490913          	addi	s2,s2,1156 # 1000 <freep>
  if(p == (char*)-1)
 b84:	fff00a93          	li	s5,-1
 b88:	05c0006f          	j	be4 <malloc+0xdc>
 b8c:	03213023          	sd	s2,32(sp)
 b90:	01413823          	sd	s4,16(sp)
 b94:	01513423          	sd	s5,8(sp)
 b98:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b9c:	00000797          	auipc	a5,0x0
 ba0:	47478793          	addi	a5,a5,1140 # 1010 <base>
 ba4:	00000717          	auipc	a4,0x0
 ba8:	44f73e23          	sd	a5,1116(a4) # 1000 <freep>
 bac:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 bb0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bb4:	fadff06f          	j	b60 <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
 bb8:	0007b703          	ld	a4,0(a5)
 bbc:	00e53023          	sd	a4,0(a0)
 bc0:	0800006f          	j	c40 <malloc+0x138>
  hp->s.size = nu;
 bc4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bc8:	01050513          	addi	a0,a0,16
 bcc:	e8dff0ef          	jal	a58 <free>
  return freep;
 bd0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bd4:	08050863          	beqz	a0,c64 <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd8:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bdc:	0087a703          	lw	a4,8(a5)
 be0:	02977a63          	bgeu	a4,s1,c14 <malloc+0x10c>
    if(p == freep)
 be4:	00093703          	ld	a4,0(s2)
 be8:	00078513          	mv	a0,a5
 bec:	fef716e3          	bne	a4,a5,bd8 <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
 bf0:	000a0513          	mv	a0,s4
 bf4:	8fdff0ef          	jal	4f0 <sbrk>
  if(p == (char*)-1)
 bf8:	fd5516e3          	bne	a0,s5,bc4 <malloc+0xbc>
        return 0;
 bfc:	00000513          	li	a0,0
 c00:	02013903          	ld	s2,32(sp)
 c04:	01013a03          	ld	s4,16(sp)
 c08:	00813a83          	ld	s5,8(sp)
 c0c:	00013b03          	ld	s6,0(sp)
 c10:	03c0006f          	j	c4c <malloc+0x144>
 c14:	02013903          	ld	s2,32(sp)
 c18:	01013a03          	ld	s4,16(sp)
 c1c:	00813a83          	ld	s5,8(sp)
 c20:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
 c24:	f8e48ae3          	beq	s1,a4,bb8 <malloc+0xb0>
        p->s.size -= nunits;
 c28:	4137073b          	subw	a4,a4,s3
 c2c:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 c30:	02071693          	slli	a3,a4,0x20
 c34:	01c6d713          	srli	a4,a3,0x1c
 c38:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 c3c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c40:	00000717          	auipc	a4,0x0
 c44:	3ca73023          	sd	a0,960(a4) # 1000 <freep>
      return (void*)(p + 1);
 c48:	01078513          	addi	a0,a5,16
  }
}
 c4c:	03813083          	ld	ra,56(sp)
 c50:	03013403          	ld	s0,48(sp)
 c54:	02813483          	ld	s1,40(sp)
 c58:	01813983          	ld	s3,24(sp)
 c5c:	04010113          	addi	sp,sp,64
 c60:	00008067          	ret
 c64:	02013903          	ld	s2,32(sp)
 c68:	01013a03          	ld	s4,16(sp)
 c6c:	00813a83          	ld	s5,8(sp)
 c70:	00013b03          	ld	s6,0(sp)
 c74:	fd9ff06f          	j	c4c <malloc+0x144>
