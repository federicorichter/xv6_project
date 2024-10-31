
user/_mkdir:     formato del fichero elf64-littleriscv


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
  int i;

  if(argc < 2){
  10:	00100793          	li	a5,1
  14:	02a7de63          	bge	a5,a0,50 <main+0x50>
  18:	00913423          	sd	s1,8(sp)
  1c:	01213023          	sd	s2,0(sp)
  20:	00858493          	addi	s1,a1,8
  24:	ffe5091b          	addiw	s2,a0,-2
  28:	02091793          	slli	a5,s2,0x20
  2c:	01d7d913          	srli	s2,a5,0x1d
  30:	01058593          	addi	a1,a1,16
  34:	00b90933          	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  38:	0004b503          	ld	a0,0(s1)
  3c:	4c0000ef          	jal	4fc <mkdir>
  40:	02054863          	bltz	a0,70 <main+0x70>
  for(i = 1; i < argc; i++){
  44:	00848493          	addi	s1,s1,8
  48:	ff2498e3          	bne	s1,s2,38 <main+0x38>
  4c:	0380006f          	j	84 <main+0x84>
  50:	00913423          	sd	s1,8(sp)
  54:	01213023          	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
  58:	00001597          	auipc	a1,0x1
  5c:	c6858593          	addi	a1,a1,-920 # cc0 <malloc+0x17c>
  60:	00200513          	li	a0,2
  64:	19d000ef          	jal	a00 <fprintf>
    exit(1);
  68:	00100513          	li	a0,1
  6c:	3f4000ef          	jal	460 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  70:	0004b603          	ld	a2,0(s1)
  74:	00001597          	auipc	a1,0x1
  78:	c6458593          	addi	a1,a1,-924 # cd8 <malloc+0x194>
  7c:	00200513          	li	a0,2
  80:	181000ef          	jal	a00 <fprintf>
      break;
    }
  }

  exit(0);
  84:	00000513          	li	a0,0
  88:	3d8000ef          	jal	460 <exit>

000000000000008c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  8c:	ff010113          	addi	sp,sp,-16
  90:	00113423          	sd	ra,8(sp)
  94:	00813023          	sd	s0,0(sp)
  98:	01010413          	addi	s0,sp,16
  extern int main();
  main();
  9c:	f65ff0ef          	jal	0 <main>
  exit(0);
  a0:	00000513          	li	a0,0
  a4:	3bc000ef          	jal	460 <exit>

00000000000000a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a8:	ff010113          	addi	sp,sp,-16
  ac:	00813423          	sd	s0,8(sp)
  b0:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b4:	00050793          	mv	a5,a0
  b8:	00158593          	addi	a1,a1,1
  bc:	00178793          	addi	a5,a5,1
  c0:	fff5c703          	lbu	a4,-1(a1)
  c4:	fee78fa3          	sb	a4,-1(a5)
  c8:	fe0718e3          	bnez	a4,b8 <strcpy+0x10>
    ;
  return os;
}
  cc:	00813403          	ld	s0,8(sp)
  d0:	01010113          	addi	sp,sp,16
  d4:	00008067          	ret

00000000000000d8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d8:	ff010113          	addi	sp,sp,-16
  dc:	00813423          	sd	s0,8(sp)
  e0:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	00078e63          	beqz	a5,104 <strcmp+0x2c>
  ec:	0005c703          	lbu	a4,0(a1)
  f0:	00f71a63          	bne	a4,a5,104 <strcmp+0x2c>
    p++, q++;
  f4:	00150513          	addi	a0,a0,1
  f8:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
  fc:	00054783          	lbu	a5,0(a0)
 100:	fe0796e3          	bnez	a5,ec <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 104:	0005c503          	lbu	a0,0(a1)
}
 108:	40a7853b          	subw	a0,a5,a0
 10c:	00813403          	ld	s0,8(sp)
 110:	01010113          	addi	sp,sp,16
 114:	00008067          	ret

0000000000000118 <strlen>:

uint
strlen(const char *s)
{
 118:	ff010113          	addi	sp,sp,-16
 11c:	00813423          	sd	s0,8(sp)
 120:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 124:	00054783          	lbu	a5,0(a0)
 128:	02078863          	beqz	a5,158 <strlen+0x40>
 12c:	00150513          	addi	a0,a0,1
 130:	00050793          	mv	a5,a0
 134:	00078693          	mv	a3,a5
 138:	00178793          	addi	a5,a5,1
 13c:	fff7c703          	lbu	a4,-1(a5)
 140:	fe071ae3          	bnez	a4,134 <strlen+0x1c>
 144:	40a6853b          	subw	a0,a3,a0
 148:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
 14c:	00813403          	ld	s0,8(sp)
 150:	01010113          	addi	sp,sp,16
 154:	00008067          	ret
  for(n = 0; s[n]; n++)
 158:	00000513          	li	a0,0
 15c:	ff1ff06f          	j	14c <strlen+0x34>

0000000000000160 <memset>:

void*
memset(void *dst, int c, uint n)
{
 160:	ff010113          	addi	sp,sp,-16
 164:	00813423          	sd	s0,8(sp)
 168:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 16c:	02060063          	beqz	a2,18c <memset+0x2c>
 170:	00050793          	mv	a5,a0
 174:	02061613          	slli	a2,a2,0x20
 178:	02065613          	srli	a2,a2,0x20
 17c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 180:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 184:	00178793          	addi	a5,a5,1
 188:	fee79ce3          	bne	a5,a4,180 <memset+0x20>
  }
  return dst;
}
 18c:	00813403          	ld	s0,8(sp)
 190:	01010113          	addi	sp,sp,16
 194:	00008067          	ret

0000000000000198 <strchr>:

char*
strchr(const char *s, char c)
{
 198:	ff010113          	addi	sp,sp,-16
 19c:	00813423          	sd	s0,8(sp)
 1a0:	01010413          	addi	s0,sp,16
  for(; *s; s++)
 1a4:	00054783          	lbu	a5,0(a0)
 1a8:	02078263          	beqz	a5,1cc <strchr+0x34>
    if(*s == c)
 1ac:	00f58a63          	beq	a1,a5,1c0 <strchr+0x28>
  for(; *s; s++)
 1b0:	00150513          	addi	a0,a0,1
 1b4:	00054783          	lbu	a5,0(a0)
 1b8:	fe079ae3          	bnez	a5,1ac <strchr+0x14>
      return (char*)s;
  return 0;
 1bc:	00000513          	li	a0,0
}
 1c0:	00813403          	ld	s0,8(sp)
 1c4:	01010113          	addi	sp,sp,16
 1c8:	00008067          	ret
  return 0;
 1cc:	00000513          	li	a0,0
 1d0:	ff1ff06f          	j	1c0 <strchr+0x28>

00000000000001d4 <gets>:

char*
gets(char *buf, int max)
{
 1d4:	fa010113          	addi	sp,sp,-96
 1d8:	04113c23          	sd	ra,88(sp)
 1dc:	04813823          	sd	s0,80(sp)
 1e0:	04913423          	sd	s1,72(sp)
 1e4:	05213023          	sd	s2,64(sp)
 1e8:	03313c23          	sd	s3,56(sp)
 1ec:	03413823          	sd	s4,48(sp)
 1f0:	03513423          	sd	s5,40(sp)
 1f4:	03613023          	sd	s6,32(sp)
 1f8:	01713c23          	sd	s7,24(sp)
 1fc:	06010413          	addi	s0,sp,96
 200:	00050b93          	mv	s7,a0
 204:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 208:	00050913          	mv	s2,a0
 20c:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 210:	00a00a93          	li	s5,10
 214:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 218:	00048993          	mv	s3,s1
 21c:	0014849b          	addiw	s1,s1,1
 220:	0344dc63          	bge	s1,s4,258 <gets+0x84>
    cc = read(0, &c, 1);
 224:	00100613          	li	a2,1
 228:	faf40593          	addi	a1,s0,-81
 22c:	00000513          	li	a0,0
 230:	254000ef          	jal	484 <read>
    if(cc < 1)
 234:	02a05263          	blez	a0,258 <gets+0x84>
    buf[i++] = c;
 238:	faf44783          	lbu	a5,-81(s0)
 23c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 240:	01578a63          	beq	a5,s5,254 <gets+0x80>
 244:	00190913          	addi	s2,s2,1
 248:	fd6798e3          	bne	a5,s6,218 <gets+0x44>
    buf[i++] = c;
 24c:	00048993          	mv	s3,s1
 250:	0080006f          	j	258 <gets+0x84>
 254:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 258:	013b89b3          	add	s3,s7,s3
 25c:	00098023          	sb	zero,0(s3)
  return buf;
}
 260:	000b8513          	mv	a0,s7
 264:	05813083          	ld	ra,88(sp)
 268:	05013403          	ld	s0,80(sp)
 26c:	04813483          	ld	s1,72(sp)
 270:	04013903          	ld	s2,64(sp)
 274:	03813983          	ld	s3,56(sp)
 278:	03013a03          	ld	s4,48(sp)
 27c:	02813a83          	ld	s5,40(sp)
 280:	02013b03          	ld	s6,32(sp)
 284:	01813b83          	ld	s7,24(sp)
 288:	06010113          	addi	sp,sp,96
 28c:	00008067          	ret

0000000000000290 <stat>:

int
stat(const char *n, struct stat *st)
{
 290:	fe010113          	addi	sp,sp,-32
 294:	00113c23          	sd	ra,24(sp)
 298:	00813823          	sd	s0,16(sp)
 29c:	01213023          	sd	s2,0(sp)
 2a0:	02010413          	addi	s0,sp,32
 2a4:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a8:	00000593          	li	a1,0
 2ac:	214000ef          	jal	4c0 <open>
  if(fd < 0)
 2b0:	02054e63          	bltz	a0,2ec <stat+0x5c>
 2b4:	00913423          	sd	s1,8(sp)
 2b8:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2bc:	00090593          	mv	a1,s2
 2c0:	224000ef          	jal	4e4 <fstat>
 2c4:	00050913          	mv	s2,a0
  close(fd);
 2c8:	00048513          	mv	a0,s1
 2cc:	1d0000ef          	jal	49c <close>
  return r;
 2d0:	00813483          	ld	s1,8(sp)
}
 2d4:	00090513          	mv	a0,s2
 2d8:	01813083          	ld	ra,24(sp)
 2dc:	01013403          	ld	s0,16(sp)
 2e0:	00013903          	ld	s2,0(sp)
 2e4:	02010113          	addi	sp,sp,32
 2e8:	00008067          	ret
    return -1;
 2ec:	fff00913          	li	s2,-1
 2f0:	fe5ff06f          	j	2d4 <stat+0x44>

00000000000002f4 <atoi>:

int
atoi(const char *s)
{
 2f4:	ff010113          	addi	sp,sp,-16
 2f8:	00813423          	sd	s0,8(sp)
 2fc:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 300:	00054683          	lbu	a3,0(a0)
 304:	fd06879b          	addiw	a5,a3,-48
 308:	0ff7f793          	zext.b	a5,a5
 30c:	00900613          	li	a2,9
 310:	04f66063          	bltu	a2,a5,350 <atoi+0x5c>
 314:	00050713          	mv	a4,a0
  n = 0;
 318:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 31c:	00170713          	addi	a4,a4,1
 320:	0025179b          	slliw	a5,a0,0x2
 324:	00a787bb          	addw	a5,a5,a0
 328:	0017979b          	slliw	a5,a5,0x1
 32c:	00d787bb          	addw	a5,a5,a3
 330:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 334:	00074683          	lbu	a3,0(a4)
 338:	fd06879b          	addiw	a5,a3,-48
 33c:	0ff7f793          	zext.b	a5,a5
 340:	fcf67ee3          	bgeu	a2,a5,31c <atoi+0x28>
  return n;
}
 344:	00813403          	ld	s0,8(sp)
 348:	01010113          	addi	sp,sp,16
 34c:	00008067          	ret
  n = 0;
 350:	00000513          	li	a0,0
 354:	ff1ff06f          	j	344 <atoi+0x50>

0000000000000358 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 358:	ff010113          	addi	sp,sp,-16
 35c:	00813423          	sd	s0,8(sp)
 360:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 364:	02b57c63          	bgeu	a0,a1,39c <memmove+0x44>
    while(n-- > 0)
 368:	02c05463          	blez	a2,390 <memmove+0x38>
 36c:	02061613          	slli	a2,a2,0x20
 370:	02065613          	srli	a2,a2,0x20
 374:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 378:	00050713          	mv	a4,a0
      *dst++ = *src++;
 37c:	00158593          	addi	a1,a1,1
 380:	00170713          	addi	a4,a4,1
 384:	fff5c683          	lbu	a3,-1(a1)
 388:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 38c:	fef718e3          	bne	a4,a5,37c <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 390:	00813403          	ld	s0,8(sp)
 394:	01010113          	addi	sp,sp,16
 398:	00008067          	ret
    dst += n;
 39c:	00c50733          	add	a4,a0,a2
    src += n;
 3a0:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 3a4:	fec056e3          	blez	a2,390 <memmove+0x38>
 3a8:	fff6079b          	addiw	a5,a2,-1
 3ac:	02079793          	slli	a5,a5,0x20
 3b0:	0207d793          	srli	a5,a5,0x20
 3b4:	fff7c793          	not	a5,a5
 3b8:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 3bc:	fff58593          	addi	a1,a1,-1
 3c0:	fff70713          	addi	a4,a4,-1
 3c4:	0005c683          	lbu	a3,0(a1)
 3c8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3cc:	fee798e3          	bne	a5,a4,3bc <memmove+0x64>
 3d0:	fc1ff06f          	j	390 <memmove+0x38>

00000000000003d4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3d4:	ff010113          	addi	sp,sp,-16
 3d8:	00813423          	sd	s0,8(sp)
 3dc:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3e0:	04060463          	beqz	a2,428 <memcmp+0x54>
 3e4:	fff6069b          	addiw	a3,a2,-1
 3e8:	02069693          	slli	a3,a3,0x20
 3ec:	0206d693          	srli	a3,a3,0x20
 3f0:	00168693          	addi	a3,a3,1
 3f4:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 3f8:	00054783          	lbu	a5,0(a0)
 3fc:	0005c703          	lbu	a4,0(a1)
 400:	00e79c63          	bne	a5,a4,418 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 404:	00150513          	addi	a0,a0,1
    p2++;
 408:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
 40c:	fed516e3          	bne	a0,a3,3f8 <memcmp+0x24>
  }
  return 0;
 410:	00000513          	li	a0,0
 414:	0080006f          	j	41c <memcmp+0x48>
      return *p1 - *p2;
 418:	40e7853b          	subw	a0,a5,a4
}
 41c:	00813403          	ld	s0,8(sp)
 420:	01010113          	addi	sp,sp,16
 424:	00008067          	ret
  return 0;
 428:	00000513          	li	a0,0
 42c:	ff1ff06f          	j	41c <memcmp+0x48>

0000000000000430 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 430:	ff010113          	addi	sp,sp,-16
 434:	00113423          	sd	ra,8(sp)
 438:	00813023          	sd	s0,0(sp)
 43c:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
 440:	f19ff0ef          	jal	358 <memmove>
}
 444:	00813083          	ld	ra,8(sp)
 448:	00013403          	ld	s0,0(sp)
 44c:	01010113          	addi	sp,sp,16
 450:	00008067          	ret

0000000000000454 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 454:	00100893          	li	a7,1
 ecall
 458:	00000073          	ecall
 ret
 45c:	00008067          	ret

0000000000000460 <exit>:
.global exit
exit:
 li a7, SYS_exit
 460:	00200893          	li	a7,2
 ecall
 464:	00000073          	ecall
 ret
 468:	00008067          	ret

000000000000046c <wait>:
.global wait
wait:
 li a7, SYS_wait
 46c:	00300893          	li	a7,3
 ecall
 470:	00000073          	ecall
 ret
 474:	00008067          	ret

0000000000000478 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 478:	00400893          	li	a7,4
 ecall
 47c:	00000073          	ecall
 ret
 480:	00008067          	ret

0000000000000484 <read>:
.global read
read:
 li a7, SYS_read
 484:	00500893          	li	a7,5
 ecall
 488:	00000073          	ecall
 ret
 48c:	00008067          	ret

0000000000000490 <write>:
.global write
write:
 li a7, SYS_write
 490:	01000893          	li	a7,16
 ecall
 494:	00000073          	ecall
 ret
 498:	00008067          	ret

000000000000049c <close>:
.global close
close:
 li a7, SYS_close
 49c:	01500893          	li	a7,21
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	00008067          	ret

00000000000004a8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4a8:	00600893          	li	a7,6
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	00008067          	ret

00000000000004b4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4b4:	00700893          	li	a7,7
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	00008067          	ret

00000000000004c0 <open>:
.global open
open:
 li a7, SYS_open
 4c0:	00f00893          	li	a7,15
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	00008067          	ret

00000000000004cc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4cc:	01100893          	li	a7,17
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	00008067          	ret

00000000000004d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4d8:	01200893          	li	a7,18
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	00008067          	ret

00000000000004e4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4e4:	00800893          	li	a7,8
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	00008067          	ret

00000000000004f0 <link>:
.global link
link:
 li a7, SYS_link
 4f0:	01300893          	li	a7,19
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	00008067          	ret

00000000000004fc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4fc:	01400893          	li	a7,20
 ecall
 500:	00000073          	ecall
 ret
 504:	00008067          	ret

0000000000000508 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 508:	00900893          	li	a7,9
 ecall
 50c:	00000073          	ecall
 ret
 510:	00008067          	ret

0000000000000514 <dup>:
.global dup
dup:
 li a7, SYS_dup
 514:	00a00893          	li	a7,10
 ecall
 518:	00000073          	ecall
 ret
 51c:	00008067          	ret

0000000000000520 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 520:	00b00893          	li	a7,11
 ecall
 524:	00000073          	ecall
 ret
 528:	00008067          	ret

000000000000052c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 52c:	00c00893          	li	a7,12
 ecall
 530:	00000073          	ecall
 ret
 534:	00008067          	ret

0000000000000538 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 538:	00d00893          	li	a7,13
 ecall
 53c:	00000073          	ecall
 ret
 540:	00008067          	ret

0000000000000544 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 544:	00e00893          	li	a7,14
 ecall
 548:	00000073          	ecall
 ret
 54c:	00008067          	ret

0000000000000550 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 550:	fe010113          	addi	sp,sp,-32
 554:	00113c23          	sd	ra,24(sp)
 558:	00813823          	sd	s0,16(sp)
 55c:	02010413          	addi	s0,sp,32
 560:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 564:	00100613          	li	a2,1
 568:	fef40593          	addi	a1,s0,-17
 56c:	f25ff0ef          	jal	490 <write>
}
 570:	01813083          	ld	ra,24(sp)
 574:	01013403          	ld	s0,16(sp)
 578:	02010113          	addi	sp,sp,32
 57c:	00008067          	ret

0000000000000580 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 580:	fc010113          	addi	sp,sp,-64
 584:	02113c23          	sd	ra,56(sp)
 588:	02813823          	sd	s0,48(sp)
 58c:	02913423          	sd	s1,40(sp)
 590:	04010413          	addi	s0,sp,64
 594:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 598:	00068463          	beqz	a3,5a0 <printint+0x20>
 59c:	0c05c263          	bltz	a1,660 <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5a0:	0005859b          	sext.w	a1,a1
  neg = 0;
 5a4:	00000893          	li	a7,0
 5a8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5ac:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5b0:	0006061b          	sext.w	a2,a2
 5b4:	00000517          	auipc	a0,0x0
 5b8:	74c50513          	addi	a0,a0,1868 # d00 <digits>
 5bc:	00070813          	mv	a6,a4
 5c0:	0017071b          	addiw	a4,a4,1
 5c4:	02c5f7bb          	remuw	a5,a1,a2
 5c8:	02079793          	slli	a5,a5,0x20
 5cc:	0207d793          	srli	a5,a5,0x20
 5d0:	00f507b3          	add	a5,a0,a5
 5d4:	0007c783          	lbu	a5,0(a5)
 5d8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5dc:	0005879b          	sext.w	a5,a1
 5e0:	02c5d5bb          	divuw	a1,a1,a2
 5e4:	00168693          	addi	a3,a3,1
 5e8:	fcc7fae3          	bgeu	a5,a2,5bc <printint+0x3c>
  if(neg)
 5ec:	00088c63          	beqz	a7,604 <printint+0x84>
    buf[i++] = '-';
 5f0:	fd070793          	addi	a5,a4,-48
 5f4:	00878733          	add	a4,a5,s0
 5f8:	02d00793          	li	a5,45
 5fc:	fef70823          	sb	a5,-16(a4)
 600:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 604:	04e05463          	blez	a4,64c <printint+0xcc>
 608:	03213023          	sd	s2,32(sp)
 60c:	01313c23          	sd	s3,24(sp)
 610:	fc040793          	addi	a5,s0,-64
 614:	00e78933          	add	s2,a5,a4
 618:	fff78993          	addi	s3,a5,-1
 61c:	00e989b3          	add	s3,s3,a4
 620:	fff7071b          	addiw	a4,a4,-1
 624:	02071713          	slli	a4,a4,0x20
 628:	02075713          	srli	a4,a4,0x20
 62c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 630:	fff94583          	lbu	a1,-1(s2)
 634:	00048513          	mv	a0,s1
 638:	f19ff0ef          	jal	550 <putc>
  while(--i >= 0)
 63c:	fff90913          	addi	s2,s2,-1
 640:	ff3918e3          	bne	s2,s3,630 <printint+0xb0>
 644:	02013903          	ld	s2,32(sp)
 648:	01813983          	ld	s3,24(sp)
}
 64c:	03813083          	ld	ra,56(sp)
 650:	03013403          	ld	s0,48(sp)
 654:	02813483          	ld	s1,40(sp)
 658:	04010113          	addi	sp,sp,64
 65c:	00008067          	ret
    x = -xx;
 660:	40b005bb          	negw	a1,a1
    neg = 1;
 664:	00100893          	li	a7,1
    x = -xx;
 668:	f41ff06f          	j	5a8 <printint+0x28>

000000000000066c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 66c:	fa010113          	addi	sp,sp,-96
 670:	04113c23          	sd	ra,88(sp)
 674:	04813823          	sd	s0,80(sp)
 678:	05213023          	sd	s2,64(sp)
 67c:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 680:	0005c903          	lbu	s2,0(a1)
 684:	36090463          	beqz	s2,9ec <vprintf+0x380>
 688:	04913423          	sd	s1,72(sp)
 68c:	03313c23          	sd	s3,56(sp)
 690:	03413823          	sd	s4,48(sp)
 694:	03513423          	sd	s5,40(sp)
 698:	03613023          	sd	s6,32(sp)
 69c:	01713c23          	sd	s7,24(sp)
 6a0:	01813823          	sd	s8,16(sp)
 6a4:	01913423          	sd	s9,8(sp)
 6a8:	00050b13          	mv	s6,a0
 6ac:	00058a13          	mv	s4,a1
 6b0:	00060b93          	mv	s7,a2
  state = 0;
 6b4:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
 6b8:	00000493          	li	s1,0
 6bc:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6c0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6c4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6c8:	06c00c93          	li	s9,108
 6cc:	02c0006f          	j	6f8 <vprintf+0x8c>
        putc(fd, c0);
 6d0:	00090593          	mv	a1,s2
 6d4:	000b0513          	mv	a0,s6
 6d8:	e79ff0ef          	jal	550 <putc>
 6dc:	0080006f          	j	6e4 <vprintf+0x78>
    } else if(state == '%'){
 6e0:	03598663          	beq	s3,s5,70c <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
 6e4:	0014849b          	addiw	s1,s1,1
 6e8:	00048713          	mv	a4,s1
 6ec:	009a07b3          	add	a5,s4,s1
 6f0:	0007c903          	lbu	s2,0(a5)
 6f4:	2c090c63          	beqz	s2,9cc <vprintf+0x360>
    c0 = fmt[i] & 0xff;
 6f8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6fc:	fe0992e3          	bnez	s3,6e0 <vprintf+0x74>
      if(c0 == '%'){
 700:	fd5798e3          	bne	a5,s5,6d0 <vprintf+0x64>
        state = '%';
 704:	00078993          	mv	s3,a5
 708:	fddff06f          	j	6e4 <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
 70c:	00ea06b3          	add	a3,s4,a4
 710:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 714:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 718:	00068663          	beqz	a3,724 <vprintf+0xb8>
 71c:	00ea0733          	add	a4,s4,a4
 720:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 724:	05878263          	beq	a5,s8,768 <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
 728:	07978263          	beq	a5,s9,78c <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 72c:	07500713          	li	a4,117
 730:	12e78663          	beq	a5,a4,85c <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 734:	07800713          	li	a4,120
 738:	18e78c63          	beq	a5,a4,8d0 <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 73c:	07000713          	li	a4,112
 740:	1ce78e63          	beq	a5,a4,91c <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 744:	07300713          	li	a4,115
 748:	22e78a63          	beq	a5,a4,97c <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 74c:	02500713          	li	a4,37
 750:	04e79e63          	bne	a5,a4,7ac <vprintf+0x140>
        putc(fd, '%');
 754:	02500593          	li	a1,37
 758:	000b0513          	mv	a0,s6
 75c:	df5ff0ef          	jal	550 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 760:	00000993          	li	s3,0
 764:	f81ff06f          	j	6e4 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
 768:	008b8913          	addi	s2,s7,8
 76c:	00100693          	li	a3,1
 770:	00a00613          	li	a2,10
 774:	000ba583          	lw	a1,0(s7)
 778:	000b0513          	mv	a0,s6
 77c:	e05ff0ef          	jal	580 <printint>
 780:	00090b93          	mv	s7,s2
      state = 0;
 784:	00000993          	li	s3,0
 788:	f5dff06f          	j	6e4 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
 78c:	06400793          	li	a5,100
 790:	02f68e63          	beq	a3,a5,7cc <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 794:	06c00793          	li	a5,108
 798:	04f68e63          	beq	a3,a5,7f4 <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
 79c:	07500793          	li	a5,117
 7a0:	0ef68063          	beq	a3,a5,880 <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
 7a4:	07800793          	li	a5,120
 7a8:	14f68663          	beq	a3,a5,8f4 <vprintf+0x288>
        putc(fd, '%');
 7ac:	02500593          	li	a1,37
 7b0:	000b0513          	mv	a0,s6
 7b4:	d9dff0ef          	jal	550 <putc>
        putc(fd, c0);
 7b8:	00090593          	mv	a1,s2
 7bc:	000b0513          	mv	a0,s6
 7c0:	d91ff0ef          	jal	550 <putc>
      state = 0;
 7c4:	00000993          	li	s3,0
 7c8:	f1dff06f          	j	6e4 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7cc:	008b8913          	addi	s2,s7,8
 7d0:	00100693          	li	a3,1
 7d4:	00a00613          	li	a2,10
 7d8:	000ba583          	lw	a1,0(s7)
 7dc:	000b0513          	mv	a0,s6
 7e0:	da1ff0ef          	jal	580 <printint>
        i += 1;
 7e4:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7e8:	00090b93          	mv	s7,s2
      state = 0;
 7ec:	00000993          	li	s3,0
        i += 1;
 7f0:	ef5ff06f          	j	6e4 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7f4:	06400793          	li	a5,100
 7f8:	02f60e63          	beq	a2,a5,834 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7fc:	07500793          	li	a5,117
 800:	0af60463          	beq	a2,a5,8a8 <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 804:	07800793          	li	a5,120
 808:	faf612e3          	bne	a2,a5,7ac <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
 80c:	008b8913          	addi	s2,s7,8
 810:	00000693          	li	a3,0
 814:	01000613          	li	a2,16
 818:	000ba583          	lw	a1,0(s7)
 81c:	000b0513          	mv	a0,s6
 820:	d61ff0ef          	jal	580 <printint>
        i += 2;
 824:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 828:	00090b93          	mv	s7,s2
      state = 0;
 82c:	00000993          	li	s3,0
        i += 2;
 830:	eb5ff06f          	j	6e4 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 834:	008b8913          	addi	s2,s7,8
 838:	00100693          	li	a3,1
 83c:	00a00613          	li	a2,10
 840:	000ba583          	lw	a1,0(s7)
 844:	000b0513          	mv	a0,s6
 848:	d39ff0ef          	jal	580 <printint>
        i += 2;
 84c:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 850:	00090b93          	mv	s7,s2
      state = 0;
 854:	00000993          	li	s3,0
        i += 2;
 858:	e8dff06f          	j	6e4 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
 85c:	008b8913          	addi	s2,s7,8
 860:	00000693          	li	a3,0
 864:	00a00613          	li	a2,10
 868:	000ba583          	lw	a1,0(s7)
 86c:	000b0513          	mv	a0,s6
 870:	d11ff0ef          	jal	580 <printint>
 874:	00090b93          	mv	s7,s2
      state = 0;
 878:	00000993          	li	s3,0
 87c:	e69ff06f          	j	6e4 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 880:	008b8913          	addi	s2,s7,8
 884:	00000693          	li	a3,0
 888:	00a00613          	li	a2,10
 88c:	000ba583          	lw	a1,0(s7)
 890:	000b0513          	mv	a0,s6
 894:	cedff0ef          	jal	580 <printint>
        i += 1;
 898:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 89c:	00090b93          	mv	s7,s2
      state = 0;
 8a0:	00000993          	li	s3,0
        i += 1;
 8a4:	e41ff06f          	j	6e4 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8a8:	008b8913          	addi	s2,s7,8
 8ac:	00000693          	li	a3,0
 8b0:	00a00613          	li	a2,10
 8b4:	000ba583          	lw	a1,0(s7)
 8b8:	000b0513          	mv	a0,s6
 8bc:	cc5ff0ef          	jal	580 <printint>
        i += 2;
 8c0:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8c4:	00090b93          	mv	s7,s2
      state = 0;
 8c8:	00000993          	li	s3,0
        i += 2;
 8cc:	e19ff06f          	j	6e4 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
 8d0:	008b8913          	addi	s2,s7,8
 8d4:	00000693          	li	a3,0
 8d8:	01000613          	li	a2,16
 8dc:	000ba583          	lw	a1,0(s7)
 8e0:	000b0513          	mv	a0,s6
 8e4:	c9dff0ef          	jal	580 <printint>
 8e8:	00090b93          	mv	s7,s2
      state = 0;
 8ec:	00000993          	li	s3,0
 8f0:	df5ff06f          	j	6e4 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8f4:	008b8913          	addi	s2,s7,8
 8f8:	00000693          	li	a3,0
 8fc:	01000613          	li	a2,16
 900:	000ba583          	lw	a1,0(s7)
 904:	000b0513          	mv	a0,s6
 908:	c79ff0ef          	jal	580 <printint>
        i += 1;
 90c:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 910:	00090b93          	mv	s7,s2
      state = 0;
 914:	00000993          	li	s3,0
        i += 1;
 918:	dcdff06f          	j	6e4 <vprintf+0x78>
 91c:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 920:	008b8d13          	addi	s10,s7,8
 924:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 928:	03000593          	li	a1,48
 92c:	000b0513          	mv	a0,s6
 930:	c21ff0ef          	jal	550 <putc>
  putc(fd, 'x');
 934:	07800593          	li	a1,120
 938:	000b0513          	mv	a0,s6
 93c:	c15ff0ef          	jal	550 <putc>
 940:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 944:	00000b97          	auipc	s7,0x0
 948:	3bcb8b93          	addi	s7,s7,956 # d00 <digits>
 94c:	03c9d793          	srli	a5,s3,0x3c
 950:	00fb87b3          	add	a5,s7,a5
 954:	0007c583          	lbu	a1,0(a5)
 958:	000b0513          	mv	a0,s6
 95c:	bf5ff0ef          	jal	550 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 960:	00499993          	slli	s3,s3,0x4
 964:	fff9091b          	addiw	s2,s2,-1
 968:	fe0912e3          	bnez	s2,94c <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
 96c:	000d0b93          	mv	s7,s10
      state = 0;
 970:	00000993          	li	s3,0
 974:	00013d03          	ld	s10,0(sp)
 978:	d6dff06f          	j	6e4 <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
 97c:	008b8993          	addi	s3,s7,8
 980:	000bb903          	ld	s2,0(s7)
 984:	02090663          	beqz	s2,9b0 <vprintf+0x344>
        for(; *s; s++)
 988:	00094583          	lbu	a1,0(s2)
 98c:	02058a63          	beqz	a1,9c0 <vprintf+0x354>
          putc(fd, *s);
 990:	000b0513          	mv	a0,s6
 994:	bbdff0ef          	jal	550 <putc>
        for(; *s; s++)
 998:	00190913          	addi	s2,s2,1
 99c:	00094583          	lbu	a1,0(s2)
 9a0:	fe0598e3          	bnez	a1,990 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 9a4:	00098b93          	mv	s7,s3
      state = 0;
 9a8:	00000993          	li	s3,0
 9ac:	d39ff06f          	j	6e4 <vprintf+0x78>
          s = "(null)";
 9b0:	00000917          	auipc	s2,0x0
 9b4:	34890913          	addi	s2,s2,840 # cf8 <malloc+0x1b4>
        for(; *s; s++)
 9b8:	02800593          	li	a1,40
 9bc:	fd5ff06f          	j	990 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 9c0:	00098b93          	mv	s7,s3
      state = 0;
 9c4:	00000993          	li	s3,0
 9c8:	d1dff06f          	j	6e4 <vprintf+0x78>
 9cc:	04813483          	ld	s1,72(sp)
 9d0:	03813983          	ld	s3,56(sp)
 9d4:	03013a03          	ld	s4,48(sp)
 9d8:	02813a83          	ld	s5,40(sp)
 9dc:	02013b03          	ld	s6,32(sp)
 9e0:	01813b83          	ld	s7,24(sp)
 9e4:	01013c03          	ld	s8,16(sp)
 9e8:	00813c83          	ld	s9,8(sp)
    }
  }
}
 9ec:	05813083          	ld	ra,88(sp)
 9f0:	05013403          	ld	s0,80(sp)
 9f4:	04013903          	ld	s2,64(sp)
 9f8:	06010113          	addi	sp,sp,96
 9fc:	00008067          	ret

0000000000000a00 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a00:	fb010113          	addi	sp,sp,-80
 a04:	00113c23          	sd	ra,24(sp)
 a08:	00813823          	sd	s0,16(sp)
 a0c:	02010413          	addi	s0,sp,32
 a10:	00c43023          	sd	a2,0(s0)
 a14:	00d43423          	sd	a3,8(s0)
 a18:	00e43823          	sd	a4,16(s0)
 a1c:	00f43c23          	sd	a5,24(s0)
 a20:	03043023          	sd	a6,32(s0)
 a24:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a28:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a2c:	00040613          	mv	a2,s0
 a30:	c3dff0ef          	jal	66c <vprintf>
}
 a34:	01813083          	ld	ra,24(sp)
 a38:	01013403          	ld	s0,16(sp)
 a3c:	05010113          	addi	sp,sp,80
 a40:	00008067          	ret

0000000000000a44 <printf>:

void
printf(const char *fmt, ...)
{
 a44:	fa010113          	addi	sp,sp,-96
 a48:	00113c23          	sd	ra,24(sp)
 a4c:	00813823          	sd	s0,16(sp)
 a50:	02010413          	addi	s0,sp,32
 a54:	00b43423          	sd	a1,8(s0)
 a58:	00c43823          	sd	a2,16(s0)
 a5c:	00d43c23          	sd	a3,24(s0)
 a60:	02e43023          	sd	a4,32(s0)
 a64:	02f43423          	sd	a5,40(s0)
 a68:	03043823          	sd	a6,48(s0)
 a6c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a70:	00840613          	addi	a2,s0,8
 a74:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a78:	00050593          	mv	a1,a0
 a7c:	00100513          	li	a0,1
 a80:	bedff0ef          	jal	66c <vprintf>
}
 a84:	01813083          	ld	ra,24(sp)
 a88:	01013403          	ld	s0,16(sp)
 a8c:	06010113          	addi	sp,sp,96
 a90:	00008067          	ret

0000000000000a94 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a94:	ff010113          	addi	sp,sp,-16
 a98:	00813423          	sd	s0,8(sp)
 a9c:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aa0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aa4:	00000797          	auipc	a5,0x0
 aa8:	55c7b783          	ld	a5,1372(a5) # 1000 <freep>
 aac:	0400006f          	j	aec <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ab0:	00862703          	lw	a4,8(a2)
 ab4:	00b7073b          	addw	a4,a4,a1
 ab8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 abc:	0007b703          	ld	a4,0(a5)
 ac0:	00073603          	ld	a2,0(a4)
 ac4:	0500006f          	j	b14 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ac8:	ff852703          	lw	a4,-8(a0)
 acc:	00c7073b          	addw	a4,a4,a2
 ad0:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ad4:	ff053683          	ld	a3,-16(a0)
 ad8:	0540006f          	j	b2c <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 adc:	0007b703          	ld	a4,0(a5)
 ae0:	00e7e463          	bltu	a5,a4,ae8 <free+0x54>
 ae4:	00e6ec63          	bltu	a3,a4,afc <free+0x68>
{
 ae8:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aec:	fed7f8e3          	bgeu	a5,a3,adc <free+0x48>
 af0:	0007b703          	ld	a4,0(a5)
 af4:	00e6e463          	bltu	a3,a4,afc <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 af8:	fee7e8e3          	bltu	a5,a4,ae8 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 afc:	ff852583          	lw	a1,-8(a0)
 b00:	0007b603          	ld	a2,0(a5)
 b04:	02059813          	slli	a6,a1,0x20
 b08:	01c85713          	srli	a4,a6,0x1c
 b0c:	00e68733          	add	a4,a3,a4
 b10:	fae600e3          	beq	a2,a4,ab0 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 b14:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b18:	0087a603          	lw	a2,8(a5)
 b1c:	02061593          	slli	a1,a2,0x20
 b20:	01c5d713          	srli	a4,a1,0x1c
 b24:	00e78733          	add	a4,a5,a4
 b28:	fae680e3          	beq	a3,a4,ac8 <free+0x34>
    p->s.ptr = bp->s.ptr;
 b2c:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b30:	00000717          	auipc	a4,0x0
 b34:	4cf73823          	sd	a5,1232(a4) # 1000 <freep>
}
 b38:	00813403          	ld	s0,8(sp)
 b3c:	01010113          	addi	sp,sp,16
 b40:	00008067          	ret

0000000000000b44 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b44:	fc010113          	addi	sp,sp,-64
 b48:	02113c23          	sd	ra,56(sp)
 b4c:	02813823          	sd	s0,48(sp)
 b50:	02913423          	sd	s1,40(sp)
 b54:	01313c23          	sd	s3,24(sp)
 b58:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b5c:	02051493          	slli	s1,a0,0x20
 b60:	0204d493          	srli	s1,s1,0x20
 b64:	00f48493          	addi	s1,s1,15
 b68:	0044d493          	srli	s1,s1,0x4
 b6c:	0014899b          	addiw	s3,s1,1
 b70:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
 b74:	00000517          	auipc	a0,0x0
 b78:	48c53503          	ld	a0,1164(a0) # 1000 <freep>
 b7c:	04050663          	beqz	a0,bc8 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b80:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b84:	0087a703          	lw	a4,8(a5)
 b88:	0c977c63          	bgeu	a4,s1,c60 <malloc+0x11c>
 b8c:	03213023          	sd	s2,32(sp)
 b90:	01413823          	sd	s4,16(sp)
 b94:	01513423          	sd	s5,8(sp)
 b98:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
 b9c:	00098a13          	mv	s4,s3
 ba0:	0009871b          	sext.w	a4,s3
 ba4:	000016b7          	lui	a3,0x1
 ba8:	00d77463          	bgeu	a4,a3,bb0 <malloc+0x6c>
 bac:	00001a37          	lui	s4,0x1
 bb0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 bb4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bb8:	00000917          	auipc	s2,0x0
 bbc:	44890913          	addi	s2,s2,1096 # 1000 <freep>
  if(p == (char*)-1)
 bc0:	fff00a93          	li	s5,-1
 bc4:	05c0006f          	j	c20 <malloc+0xdc>
 bc8:	03213023          	sd	s2,32(sp)
 bcc:	01413823          	sd	s4,16(sp)
 bd0:	01513423          	sd	s5,8(sp)
 bd4:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 bd8:	00000797          	auipc	a5,0x0
 bdc:	43878793          	addi	a5,a5,1080 # 1010 <base>
 be0:	00000717          	auipc	a4,0x0
 be4:	42f73023          	sd	a5,1056(a4) # 1000 <freep>
 be8:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 bec:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bf0:	fadff06f          	j	b9c <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
 bf4:	0007b703          	ld	a4,0(a5)
 bf8:	00e53023          	sd	a4,0(a0)
 bfc:	0800006f          	j	c7c <malloc+0x138>
  hp->s.size = nu;
 c00:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c04:	01050513          	addi	a0,a0,16
 c08:	e8dff0ef          	jal	a94 <free>
  return freep;
 c0c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c10:	08050863          	beqz	a0,ca0 <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c14:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c18:	0087a703          	lw	a4,8(a5)
 c1c:	02977a63          	bgeu	a4,s1,c50 <malloc+0x10c>
    if(p == freep)
 c20:	00093703          	ld	a4,0(s2)
 c24:	00078513          	mv	a0,a5
 c28:	fef716e3          	bne	a4,a5,c14 <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
 c2c:	000a0513          	mv	a0,s4
 c30:	8fdff0ef          	jal	52c <sbrk>
  if(p == (char*)-1)
 c34:	fd5516e3          	bne	a0,s5,c00 <malloc+0xbc>
        return 0;
 c38:	00000513          	li	a0,0
 c3c:	02013903          	ld	s2,32(sp)
 c40:	01013a03          	ld	s4,16(sp)
 c44:	00813a83          	ld	s5,8(sp)
 c48:	00013b03          	ld	s6,0(sp)
 c4c:	03c0006f          	j	c88 <malloc+0x144>
 c50:	02013903          	ld	s2,32(sp)
 c54:	01013a03          	ld	s4,16(sp)
 c58:	00813a83          	ld	s5,8(sp)
 c5c:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
 c60:	f8e48ae3          	beq	s1,a4,bf4 <malloc+0xb0>
        p->s.size -= nunits;
 c64:	4137073b          	subw	a4,a4,s3
 c68:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 c6c:	02071693          	slli	a3,a4,0x20
 c70:	01c6d713          	srli	a4,a3,0x1c
 c74:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 c78:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c7c:	00000717          	auipc	a4,0x0
 c80:	38a73223          	sd	a0,900(a4) # 1000 <freep>
      return (void*)(p + 1);
 c84:	01078513          	addi	a0,a5,16
  }
}
 c88:	03813083          	ld	ra,56(sp)
 c8c:	03013403          	ld	s0,48(sp)
 c90:	02813483          	ld	s1,40(sp)
 c94:	01813983          	ld	s3,24(sp)
 c98:	04010113          	addi	sp,sp,64
 c9c:	00008067          	ret
 ca0:	02013903          	ld	s2,32(sp)
 ca4:	01013a03          	ld	s4,16(sp)
 ca8:	00813a83          	ld	s5,8(sp)
 cac:	00013b03          	ld	s6,0(sp)
 cb0:	fd9ff06f          	j	c88 <malloc+0x144>
