
user/_stressfs:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	23010413          	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  18:	00001797          	auipc	a5,0x1
  1c:	d4878793          	addi	a5,a5,-696 # d60 <malloc+0x1a4>
  20:	0007b703          	ld	a4,0(a5)
  24:	fce43823          	sd	a4,-48(s0)
  28:	0087d783          	lhu	a5,8(a5)
  2c:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  30:	00001517          	auipc	a0,0x1
  34:	d0050513          	addi	a0,a0,-768 # d30 <malloc+0x174>
  38:	285000ef          	jal	abc <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	190000ef          	jal	1d8 <memset>

  for(i = 0; i < 4; i++)
  4c:	00000493          	li	s1,0
  50:	00400913          	li	s2,4
    if(fork() > 0)
  54:	478000ef          	jal	4cc <fork>
  58:	00a04663          	bgtz	a0,64 <main+0x64>
  for(i = 0; i < 4; i++)
  5c:	0014849b          	addiw	s1,s1,1
  60:	ff249ae3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  64:	00048593          	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	ce050513          	addi	a0,a0,-800 # d48 <malloc+0x18c>
  70:	24d000ef          	jal	abc <printf>

  path[8] += i;
  74:	fd844783          	lbu	a5,-40(s0)
  78:	009787bb          	addw	a5,a5,s1
  7c:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  80:	20200593          	li	a1,514
  84:	fd040513          	addi	a0,s0,-48
  88:	4b0000ef          	jal	538 <open>
  8c:	00050913          	mv	s2,a0
  90:	01400493          	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  94:	20000613          	li	a2,512
  98:	dd040593          	addi	a1,s0,-560
  9c:	00090513          	mv	a0,s2
  a0:	468000ef          	jal	508 <write>
  for(i = 0; i < 20; i++)
  a4:	fff4849b          	addiw	s1,s1,-1
  a8:	fe0496e3          	bnez	s1,94 <main+0x94>
  close(fd);
  ac:	00090513          	mv	a0,s2
  b0:	464000ef          	jal	514 <close>

  printf("read\n");
  b4:	00001517          	auipc	a0,0x1
  b8:	ca450513          	addi	a0,a0,-860 # d58 <malloc+0x19c>
  bc:	201000ef          	jal	abc <printf>

  fd = open(path, O_RDONLY);
  c0:	00000593          	li	a1,0
  c4:	fd040513          	addi	a0,s0,-48
  c8:	470000ef          	jal	538 <open>
  cc:	00050913          	mv	s2,a0
  d0:	01400493          	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d4:	20000613          	li	a2,512
  d8:	dd040593          	addi	a1,s0,-560
  dc:	00090513          	mv	a0,s2
  e0:	41c000ef          	jal	4fc <read>
  for (i = 0; i < 20; i++)
  e4:	fff4849b          	addiw	s1,s1,-1
  e8:	fe0496e3          	bnez	s1,d4 <main+0xd4>
  close(fd);
  ec:	00090513          	mv	a0,s2
  f0:	424000ef          	jal	514 <close>

  wait(0);
  f4:	00000513          	li	a0,0
  f8:	3ec000ef          	jal	4e4 <wait>

  exit(0);
  fc:	00000513          	li	a0,0
 100:	3d8000ef          	jal	4d8 <exit>

0000000000000104 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 104:	ff010113          	addi	sp,sp,-16
 108:	00113423          	sd	ra,8(sp)
 10c:	00813023          	sd	s0,0(sp)
 110:	01010413          	addi	s0,sp,16
  extern int main();
  main();
 114:	eedff0ef          	jal	0 <main>
  exit(0);
 118:	00000513          	li	a0,0
 11c:	3bc000ef          	jal	4d8 <exit>

0000000000000120 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 120:	ff010113          	addi	sp,sp,-16
 124:	00813423          	sd	s0,8(sp)
 128:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12c:	00050793          	mv	a5,a0
 130:	00158593          	addi	a1,a1,1
 134:	00178793          	addi	a5,a5,1
 138:	fff5c703          	lbu	a4,-1(a1)
 13c:	fee78fa3          	sb	a4,-1(a5)
 140:	fe0718e3          	bnez	a4,130 <strcpy+0x10>
    ;
  return os;
}
 144:	00813403          	ld	s0,8(sp)
 148:	01010113          	addi	sp,sp,16
 14c:	00008067          	ret

0000000000000150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 150:	ff010113          	addi	sp,sp,-16
 154:	00813423          	sd	s0,8(sp)
 158:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
 15c:	00054783          	lbu	a5,0(a0)
 160:	00078e63          	beqz	a5,17c <strcmp+0x2c>
 164:	0005c703          	lbu	a4,0(a1)
 168:	00f71a63          	bne	a4,a5,17c <strcmp+0x2c>
    p++, q++;
 16c:	00150513          	addi	a0,a0,1
 170:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
 174:	00054783          	lbu	a5,0(a0)
 178:	fe0796e3          	bnez	a5,164 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 17c:	0005c503          	lbu	a0,0(a1)
}
 180:	40a7853b          	subw	a0,a5,a0
 184:	00813403          	ld	s0,8(sp)
 188:	01010113          	addi	sp,sp,16
 18c:	00008067          	ret

0000000000000190 <strlen>:

uint
strlen(const char *s)
{
 190:	ff010113          	addi	sp,sp,-16
 194:	00813423          	sd	s0,8(sp)
 198:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 19c:	00054783          	lbu	a5,0(a0)
 1a0:	02078863          	beqz	a5,1d0 <strlen+0x40>
 1a4:	00150513          	addi	a0,a0,1
 1a8:	00050793          	mv	a5,a0
 1ac:	00078693          	mv	a3,a5
 1b0:	00178793          	addi	a5,a5,1
 1b4:	fff7c703          	lbu	a4,-1(a5)
 1b8:	fe071ae3          	bnez	a4,1ac <strlen+0x1c>
 1bc:	40a6853b          	subw	a0,a3,a0
 1c0:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
 1c4:	00813403          	ld	s0,8(sp)
 1c8:	01010113          	addi	sp,sp,16
 1cc:	00008067          	ret
  for(n = 0; s[n]; n++)
 1d0:	00000513          	li	a0,0
 1d4:	ff1ff06f          	j	1c4 <strlen+0x34>

00000000000001d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d8:	ff010113          	addi	sp,sp,-16
 1dc:	00813423          	sd	s0,8(sp)
 1e0:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1e4:	02060063          	beqz	a2,204 <memset+0x2c>
 1e8:	00050793          	mv	a5,a0
 1ec:	02061613          	slli	a2,a2,0x20
 1f0:	02065613          	srli	a2,a2,0x20
 1f4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1f8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1fc:	00178793          	addi	a5,a5,1
 200:	fee79ce3          	bne	a5,a4,1f8 <memset+0x20>
  }
  return dst;
}
 204:	00813403          	ld	s0,8(sp)
 208:	01010113          	addi	sp,sp,16
 20c:	00008067          	ret

0000000000000210 <strchr>:

char*
strchr(const char *s, char c)
{
 210:	ff010113          	addi	sp,sp,-16
 214:	00813423          	sd	s0,8(sp)
 218:	01010413          	addi	s0,sp,16
  for(; *s; s++)
 21c:	00054783          	lbu	a5,0(a0)
 220:	02078263          	beqz	a5,244 <strchr+0x34>
    if(*s == c)
 224:	00f58a63          	beq	a1,a5,238 <strchr+0x28>
  for(; *s; s++)
 228:	00150513          	addi	a0,a0,1
 22c:	00054783          	lbu	a5,0(a0)
 230:	fe079ae3          	bnez	a5,224 <strchr+0x14>
      return (char*)s;
  return 0;
 234:	00000513          	li	a0,0
}
 238:	00813403          	ld	s0,8(sp)
 23c:	01010113          	addi	sp,sp,16
 240:	00008067          	ret
  return 0;
 244:	00000513          	li	a0,0
 248:	ff1ff06f          	j	238 <strchr+0x28>

000000000000024c <gets>:

char*
gets(char *buf, int max)
{
 24c:	fa010113          	addi	sp,sp,-96
 250:	04113c23          	sd	ra,88(sp)
 254:	04813823          	sd	s0,80(sp)
 258:	04913423          	sd	s1,72(sp)
 25c:	05213023          	sd	s2,64(sp)
 260:	03313c23          	sd	s3,56(sp)
 264:	03413823          	sd	s4,48(sp)
 268:	03513423          	sd	s5,40(sp)
 26c:	03613023          	sd	s6,32(sp)
 270:	01713c23          	sd	s7,24(sp)
 274:	06010413          	addi	s0,sp,96
 278:	00050b93          	mv	s7,a0
 27c:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 280:	00050913          	mv	s2,a0
 284:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 288:	00a00a93          	li	s5,10
 28c:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 290:	00048993          	mv	s3,s1
 294:	0014849b          	addiw	s1,s1,1
 298:	0344dc63          	bge	s1,s4,2d0 <gets+0x84>
    cc = read(0, &c, 1);
 29c:	00100613          	li	a2,1
 2a0:	faf40593          	addi	a1,s0,-81
 2a4:	00000513          	li	a0,0
 2a8:	254000ef          	jal	4fc <read>
    if(cc < 1)
 2ac:	02a05263          	blez	a0,2d0 <gets+0x84>
    buf[i++] = c;
 2b0:	faf44783          	lbu	a5,-81(s0)
 2b4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2b8:	01578a63          	beq	a5,s5,2cc <gets+0x80>
 2bc:	00190913          	addi	s2,s2,1
 2c0:	fd6798e3          	bne	a5,s6,290 <gets+0x44>
    buf[i++] = c;
 2c4:	00048993          	mv	s3,s1
 2c8:	0080006f          	j	2d0 <gets+0x84>
 2cc:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2d0:	013b89b3          	add	s3,s7,s3
 2d4:	00098023          	sb	zero,0(s3)
  return buf;
}
 2d8:	000b8513          	mv	a0,s7
 2dc:	05813083          	ld	ra,88(sp)
 2e0:	05013403          	ld	s0,80(sp)
 2e4:	04813483          	ld	s1,72(sp)
 2e8:	04013903          	ld	s2,64(sp)
 2ec:	03813983          	ld	s3,56(sp)
 2f0:	03013a03          	ld	s4,48(sp)
 2f4:	02813a83          	ld	s5,40(sp)
 2f8:	02013b03          	ld	s6,32(sp)
 2fc:	01813b83          	ld	s7,24(sp)
 300:	06010113          	addi	sp,sp,96
 304:	00008067          	ret

0000000000000308 <stat>:

int
stat(const char *n, struct stat *st)
{
 308:	fe010113          	addi	sp,sp,-32
 30c:	00113c23          	sd	ra,24(sp)
 310:	00813823          	sd	s0,16(sp)
 314:	01213023          	sd	s2,0(sp)
 318:	02010413          	addi	s0,sp,32
 31c:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 320:	00000593          	li	a1,0
 324:	214000ef          	jal	538 <open>
  if(fd < 0)
 328:	02054e63          	bltz	a0,364 <stat+0x5c>
 32c:	00913423          	sd	s1,8(sp)
 330:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 334:	00090593          	mv	a1,s2
 338:	224000ef          	jal	55c <fstat>
 33c:	00050913          	mv	s2,a0
  close(fd);
 340:	00048513          	mv	a0,s1
 344:	1d0000ef          	jal	514 <close>
  return r;
 348:	00813483          	ld	s1,8(sp)
}
 34c:	00090513          	mv	a0,s2
 350:	01813083          	ld	ra,24(sp)
 354:	01013403          	ld	s0,16(sp)
 358:	00013903          	ld	s2,0(sp)
 35c:	02010113          	addi	sp,sp,32
 360:	00008067          	ret
    return -1;
 364:	fff00913          	li	s2,-1
 368:	fe5ff06f          	j	34c <stat+0x44>

000000000000036c <atoi>:

int
atoi(const char *s)
{
 36c:	ff010113          	addi	sp,sp,-16
 370:	00813423          	sd	s0,8(sp)
 374:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 378:	00054683          	lbu	a3,0(a0)
 37c:	fd06879b          	addiw	a5,a3,-48
 380:	0ff7f793          	zext.b	a5,a5
 384:	00900613          	li	a2,9
 388:	04f66063          	bltu	a2,a5,3c8 <atoi+0x5c>
 38c:	00050713          	mv	a4,a0
  n = 0;
 390:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 394:	00170713          	addi	a4,a4,1
 398:	0025179b          	slliw	a5,a0,0x2
 39c:	00a787bb          	addw	a5,a5,a0
 3a0:	0017979b          	slliw	a5,a5,0x1
 3a4:	00d787bb          	addw	a5,a5,a3
 3a8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3ac:	00074683          	lbu	a3,0(a4)
 3b0:	fd06879b          	addiw	a5,a3,-48
 3b4:	0ff7f793          	zext.b	a5,a5
 3b8:	fcf67ee3          	bgeu	a2,a5,394 <atoi+0x28>
  return n;
}
 3bc:	00813403          	ld	s0,8(sp)
 3c0:	01010113          	addi	sp,sp,16
 3c4:	00008067          	ret
  n = 0;
 3c8:	00000513          	li	a0,0
 3cc:	ff1ff06f          	j	3bc <atoi+0x50>

00000000000003d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d0:	ff010113          	addi	sp,sp,-16
 3d4:	00813423          	sd	s0,8(sp)
 3d8:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3dc:	02b57c63          	bgeu	a0,a1,414 <memmove+0x44>
    while(n-- > 0)
 3e0:	02c05463          	blez	a2,408 <memmove+0x38>
 3e4:	02061613          	slli	a2,a2,0x20
 3e8:	02065613          	srli	a2,a2,0x20
 3ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3f0:	00050713          	mv	a4,a0
      *dst++ = *src++;
 3f4:	00158593          	addi	a1,a1,1
 3f8:	00170713          	addi	a4,a4,1
 3fc:	fff5c683          	lbu	a3,-1(a1)
 400:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 404:	fef718e3          	bne	a4,a5,3f4 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 408:	00813403          	ld	s0,8(sp)
 40c:	01010113          	addi	sp,sp,16
 410:	00008067          	ret
    dst += n;
 414:	00c50733          	add	a4,a0,a2
    src += n;
 418:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 41c:	fec056e3          	blez	a2,408 <memmove+0x38>
 420:	fff6079b          	addiw	a5,a2,-1
 424:	02079793          	slli	a5,a5,0x20
 428:	0207d793          	srli	a5,a5,0x20
 42c:	fff7c793          	not	a5,a5
 430:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 434:	fff58593          	addi	a1,a1,-1
 438:	fff70713          	addi	a4,a4,-1
 43c:	0005c683          	lbu	a3,0(a1)
 440:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 444:	fee798e3          	bne	a5,a4,434 <memmove+0x64>
 448:	fc1ff06f          	j	408 <memmove+0x38>

000000000000044c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 44c:	ff010113          	addi	sp,sp,-16
 450:	00813423          	sd	s0,8(sp)
 454:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 458:	04060463          	beqz	a2,4a0 <memcmp+0x54>
 45c:	fff6069b          	addiw	a3,a2,-1
 460:	02069693          	slli	a3,a3,0x20
 464:	0206d693          	srli	a3,a3,0x20
 468:	00168693          	addi	a3,a3,1
 46c:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 470:	00054783          	lbu	a5,0(a0)
 474:	0005c703          	lbu	a4,0(a1)
 478:	00e79c63          	bne	a5,a4,490 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 47c:	00150513          	addi	a0,a0,1
    p2++;
 480:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
 484:	fed516e3          	bne	a0,a3,470 <memcmp+0x24>
  }
  return 0;
 488:	00000513          	li	a0,0
 48c:	0080006f          	j	494 <memcmp+0x48>
      return *p1 - *p2;
 490:	40e7853b          	subw	a0,a5,a4
}
 494:	00813403          	ld	s0,8(sp)
 498:	01010113          	addi	sp,sp,16
 49c:	00008067          	ret
  return 0;
 4a0:	00000513          	li	a0,0
 4a4:	ff1ff06f          	j	494 <memcmp+0x48>

00000000000004a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4a8:	ff010113          	addi	sp,sp,-16
 4ac:	00113423          	sd	ra,8(sp)
 4b0:	00813023          	sd	s0,0(sp)
 4b4:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
 4b8:	f19ff0ef          	jal	3d0 <memmove>
}
 4bc:	00813083          	ld	ra,8(sp)
 4c0:	00013403          	ld	s0,0(sp)
 4c4:	01010113          	addi	sp,sp,16
 4c8:	00008067          	ret

00000000000004cc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4cc:	00100893          	li	a7,1
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	00008067          	ret

00000000000004d8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d8:	00200893          	li	a7,2
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	00008067          	ret

00000000000004e4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4e4:	00300893          	li	a7,3
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	00008067          	ret

00000000000004f0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4f0:	00400893          	li	a7,4
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	00008067          	ret

00000000000004fc <read>:
.global read
read:
 li a7, SYS_read
 4fc:	00500893          	li	a7,5
 ecall
 500:	00000073          	ecall
 ret
 504:	00008067          	ret

0000000000000508 <write>:
.global write
write:
 li a7, SYS_write
 508:	01000893          	li	a7,16
 ecall
 50c:	00000073          	ecall
 ret
 510:	00008067          	ret

0000000000000514 <close>:
.global close
close:
 li a7, SYS_close
 514:	01500893          	li	a7,21
 ecall
 518:	00000073          	ecall
 ret
 51c:	00008067          	ret

0000000000000520 <kill>:
.global kill
kill:
 li a7, SYS_kill
 520:	00600893          	li	a7,6
 ecall
 524:	00000073          	ecall
 ret
 528:	00008067          	ret

000000000000052c <exec>:
.global exec
exec:
 li a7, SYS_exec
 52c:	00700893          	li	a7,7
 ecall
 530:	00000073          	ecall
 ret
 534:	00008067          	ret

0000000000000538 <open>:
.global open
open:
 li a7, SYS_open
 538:	00f00893          	li	a7,15
 ecall
 53c:	00000073          	ecall
 ret
 540:	00008067          	ret

0000000000000544 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 544:	01100893          	li	a7,17
 ecall
 548:	00000073          	ecall
 ret
 54c:	00008067          	ret

0000000000000550 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 550:	01200893          	li	a7,18
 ecall
 554:	00000073          	ecall
 ret
 558:	00008067          	ret

000000000000055c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 55c:	00800893          	li	a7,8
 ecall
 560:	00000073          	ecall
 ret
 564:	00008067          	ret

0000000000000568 <link>:
.global link
link:
 li a7, SYS_link
 568:	01300893          	li	a7,19
 ecall
 56c:	00000073          	ecall
 ret
 570:	00008067          	ret

0000000000000574 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 574:	01400893          	li	a7,20
 ecall
 578:	00000073          	ecall
 ret
 57c:	00008067          	ret

0000000000000580 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 580:	00900893          	li	a7,9
 ecall
 584:	00000073          	ecall
 ret
 588:	00008067          	ret

000000000000058c <dup>:
.global dup
dup:
 li a7, SYS_dup
 58c:	00a00893          	li	a7,10
 ecall
 590:	00000073          	ecall
 ret
 594:	00008067          	ret

0000000000000598 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 598:	00b00893          	li	a7,11
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	00008067          	ret

00000000000005a4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5a4:	00c00893          	li	a7,12
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	00008067          	ret

00000000000005b0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5b0:	00d00893          	li	a7,13
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	00008067          	ret

00000000000005bc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5bc:	00e00893          	li	a7,14
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	00008067          	ret

00000000000005c8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5c8:	fe010113          	addi	sp,sp,-32
 5cc:	00113c23          	sd	ra,24(sp)
 5d0:	00813823          	sd	s0,16(sp)
 5d4:	02010413          	addi	s0,sp,32
 5d8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5dc:	00100613          	li	a2,1
 5e0:	fef40593          	addi	a1,s0,-17
 5e4:	f25ff0ef          	jal	508 <write>
}
 5e8:	01813083          	ld	ra,24(sp)
 5ec:	01013403          	ld	s0,16(sp)
 5f0:	02010113          	addi	sp,sp,32
 5f4:	00008067          	ret

00000000000005f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5f8:	fc010113          	addi	sp,sp,-64
 5fc:	02113c23          	sd	ra,56(sp)
 600:	02813823          	sd	s0,48(sp)
 604:	02913423          	sd	s1,40(sp)
 608:	04010413          	addi	s0,sp,64
 60c:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 610:	00068463          	beqz	a3,618 <printint+0x20>
 614:	0c05c263          	bltz	a1,6d8 <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 618:	0005859b          	sext.w	a1,a1
  neg = 0;
 61c:	00000893          	li	a7,0
 620:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 624:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 628:	0006061b          	sext.w	a2,a2
 62c:	00000517          	auipc	a0,0x0
 630:	74c50513          	addi	a0,a0,1868 # d78 <digits>
 634:	00070813          	mv	a6,a4
 638:	0017071b          	addiw	a4,a4,1
 63c:	02c5f7bb          	remuw	a5,a1,a2
 640:	02079793          	slli	a5,a5,0x20
 644:	0207d793          	srli	a5,a5,0x20
 648:	00f507b3          	add	a5,a0,a5
 64c:	0007c783          	lbu	a5,0(a5)
 650:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 654:	0005879b          	sext.w	a5,a1
 658:	02c5d5bb          	divuw	a1,a1,a2
 65c:	00168693          	addi	a3,a3,1
 660:	fcc7fae3          	bgeu	a5,a2,634 <printint+0x3c>
  if(neg)
 664:	00088c63          	beqz	a7,67c <printint+0x84>
    buf[i++] = '-';
 668:	fd070793          	addi	a5,a4,-48
 66c:	00878733          	add	a4,a5,s0
 670:	02d00793          	li	a5,45
 674:	fef70823          	sb	a5,-16(a4)
 678:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 67c:	04e05463          	blez	a4,6c4 <printint+0xcc>
 680:	03213023          	sd	s2,32(sp)
 684:	01313c23          	sd	s3,24(sp)
 688:	fc040793          	addi	a5,s0,-64
 68c:	00e78933          	add	s2,a5,a4
 690:	fff78993          	addi	s3,a5,-1
 694:	00e989b3          	add	s3,s3,a4
 698:	fff7071b          	addiw	a4,a4,-1
 69c:	02071713          	slli	a4,a4,0x20
 6a0:	02075713          	srli	a4,a4,0x20
 6a4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6a8:	fff94583          	lbu	a1,-1(s2)
 6ac:	00048513          	mv	a0,s1
 6b0:	f19ff0ef          	jal	5c8 <putc>
  while(--i >= 0)
 6b4:	fff90913          	addi	s2,s2,-1
 6b8:	ff3918e3          	bne	s2,s3,6a8 <printint+0xb0>
 6bc:	02013903          	ld	s2,32(sp)
 6c0:	01813983          	ld	s3,24(sp)
}
 6c4:	03813083          	ld	ra,56(sp)
 6c8:	03013403          	ld	s0,48(sp)
 6cc:	02813483          	ld	s1,40(sp)
 6d0:	04010113          	addi	sp,sp,64
 6d4:	00008067          	ret
    x = -xx;
 6d8:	40b005bb          	negw	a1,a1
    neg = 1;
 6dc:	00100893          	li	a7,1
    x = -xx;
 6e0:	f41ff06f          	j	620 <printint+0x28>

00000000000006e4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6e4:	fa010113          	addi	sp,sp,-96
 6e8:	04113c23          	sd	ra,88(sp)
 6ec:	04813823          	sd	s0,80(sp)
 6f0:	05213023          	sd	s2,64(sp)
 6f4:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6f8:	0005c903          	lbu	s2,0(a1)
 6fc:	36090463          	beqz	s2,a64 <vprintf+0x380>
 700:	04913423          	sd	s1,72(sp)
 704:	03313c23          	sd	s3,56(sp)
 708:	03413823          	sd	s4,48(sp)
 70c:	03513423          	sd	s5,40(sp)
 710:	03613023          	sd	s6,32(sp)
 714:	01713c23          	sd	s7,24(sp)
 718:	01813823          	sd	s8,16(sp)
 71c:	01913423          	sd	s9,8(sp)
 720:	00050b13          	mv	s6,a0
 724:	00058a13          	mv	s4,a1
 728:	00060b93          	mv	s7,a2
  state = 0;
 72c:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
 730:	00000493          	li	s1,0
 734:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 738:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 73c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 740:	06c00c93          	li	s9,108
 744:	02c0006f          	j	770 <vprintf+0x8c>
        putc(fd, c0);
 748:	00090593          	mv	a1,s2
 74c:	000b0513          	mv	a0,s6
 750:	e79ff0ef          	jal	5c8 <putc>
 754:	0080006f          	j	75c <vprintf+0x78>
    } else if(state == '%'){
 758:	03598663          	beq	s3,s5,784 <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
 75c:	0014849b          	addiw	s1,s1,1
 760:	00048713          	mv	a4,s1
 764:	009a07b3          	add	a5,s4,s1
 768:	0007c903          	lbu	s2,0(a5)
 76c:	2c090c63          	beqz	s2,a44 <vprintf+0x360>
    c0 = fmt[i] & 0xff;
 770:	0009079b          	sext.w	a5,s2
    if(state == 0){
 774:	fe0992e3          	bnez	s3,758 <vprintf+0x74>
      if(c0 == '%'){
 778:	fd5798e3          	bne	a5,s5,748 <vprintf+0x64>
        state = '%';
 77c:	00078993          	mv	s3,a5
 780:	fddff06f          	j	75c <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
 784:	00ea06b3          	add	a3,s4,a4
 788:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 78c:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 790:	00068663          	beqz	a3,79c <vprintf+0xb8>
 794:	00ea0733          	add	a4,s4,a4
 798:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 79c:	05878263          	beq	a5,s8,7e0 <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
 7a0:	07978263          	beq	a5,s9,804 <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 7a4:	07500713          	li	a4,117
 7a8:	12e78663          	beq	a5,a4,8d4 <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 7ac:	07800713          	li	a4,120
 7b0:	18e78c63          	beq	a5,a4,948 <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 7b4:	07000713          	li	a4,112
 7b8:	1ce78e63          	beq	a5,a4,994 <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 7bc:	07300713          	li	a4,115
 7c0:	22e78a63          	beq	a5,a4,9f4 <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 7c4:	02500713          	li	a4,37
 7c8:	04e79e63          	bne	a5,a4,824 <vprintf+0x140>
        putc(fd, '%');
 7cc:	02500593          	li	a1,37
 7d0:	000b0513          	mv	a0,s6
 7d4:	df5ff0ef          	jal	5c8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 7d8:	00000993          	li	s3,0
 7dc:	f81ff06f          	j	75c <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
 7e0:	008b8913          	addi	s2,s7,8
 7e4:	00100693          	li	a3,1
 7e8:	00a00613          	li	a2,10
 7ec:	000ba583          	lw	a1,0(s7)
 7f0:	000b0513          	mv	a0,s6
 7f4:	e05ff0ef          	jal	5f8 <printint>
 7f8:	00090b93          	mv	s7,s2
      state = 0;
 7fc:	00000993          	li	s3,0
 800:	f5dff06f          	j	75c <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
 804:	06400793          	li	a5,100
 808:	02f68e63          	beq	a3,a5,844 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 80c:	06c00793          	li	a5,108
 810:	04f68e63          	beq	a3,a5,86c <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
 814:	07500793          	li	a5,117
 818:	0ef68063          	beq	a3,a5,8f8 <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
 81c:	07800793          	li	a5,120
 820:	14f68663          	beq	a3,a5,96c <vprintf+0x288>
        putc(fd, '%');
 824:	02500593          	li	a1,37
 828:	000b0513          	mv	a0,s6
 82c:	d9dff0ef          	jal	5c8 <putc>
        putc(fd, c0);
 830:	00090593          	mv	a1,s2
 834:	000b0513          	mv	a0,s6
 838:	d91ff0ef          	jal	5c8 <putc>
      state = 0;
 83c:	00000993          	li	s3,0
 840:	f1dff06f          	j	75c <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 844:	008b8913          	addi	s2,s7,8
 848:	00100693          	li	a3,1
 84c:	00a00613          	li	a2,10
 850:	000ba583          	lw	a1,0(s7)
 854:	000b0513          	mv	a0,s6
 858:	da1ff0ef          	jal	5f8 <printint>
        i += 1;
 85c:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 860:	00090b93          	mv	s7,s2
      state = 0;
 864:	00000993          	li	s3,0
        i += 1;
 868:	ef5ff06f          	j	75c <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 86c:	06400793          	li	a5,100
 870:	02f60e63          	beq	a2,a5,8ac <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 874:	07500793          	li	a5,117
 878:	0af60463          	beq	a2,a5,920 <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 87c:	07800793          	li	a5,120
 880:	faf612e3          	bne	a2,a5,824 <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
 884:	008b8913          	addi	s2,s7,8
 888:	00000693          	li	a3,0
 88c:	01000613          	li	a2,16
 890:	000ba583          	lw	a1,0(s7)
 894:	000b0513          	mv	a0,s6
 898:	d61ff0ef          	jal	5f8 <printint>
        i += 2;
 89c:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 8a0:	00090b93          	mv	s7,s2
      state = 0;
 8a4:	00000993          	li	s3,0
        i += 2;
 8a8:	eb5ff06f          	j	75c <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8ac:	008b8913          	addi	s2,s7,8
 8b0:	00100693          	li	a3,1
 8b4:	00a00613          	li	a2,10
 8b8:	000ba583          	lw	a1,0(s7)
 8bc:	000b0513          	mv	a0,s6
 8c0:	d39ff0ef          	jal	5f8 <printint>
        i += 2;
 8c4:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 8c8:	00090b93          	mv	s7,s2
      state = 0;
 8cc:	00000993          	li	s3,0
        i += 2;
 8d0:	e8dff06f          	j	75c <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
 8d4:	008b8913          	addi	s2,s7,8
 8d8:	00000693          	li	a3,0
 8dc:	00a00613          	li	a2,10
 8e0:	000ba583          	lw	a1,0(s7)
 8e4:	000b0513          	mv	a0,s6
 8e8:	d11ff0ef          	jal	5f8 <printint>
 8ec:	00090b93          	mv	s7,s2
      state = 0;
 8f0:	00000993          	li	s3,0
 8f4:	e69ff06f          	j	75c <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8f8:	008b8913          	addi	s2,s7,8
 8fc:	00000693          	li	a3,0
 900:	00a00613          	li	a2,10
 904:	000ba583          	lw	a1,0(s7)
 908:	000b0513          	mv	a0,s6
 90c:	cedff0ef          	jal	5f8 <printint>
        i += 1;
 910:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 914:	00090b93          	mv	s7,s2
      state = 0;
 918:	00000993          	li	s3,0
        i += 1;
 91c:	e41ff06f          	j	75c <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 920:	008b8913          	addi	s2,s7,8
 924:	00000693          	li	a3,0
 928:	00a00613          	li	a2,10
 92c:	000ba583          	lw	a1,0(s7)
 930:	000b0513          	mv	a0,s6
 934:	cc5ff0ef          	jal	5f8 <printint>
        i += 2;
 938:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 93c:	00090b93          	mv	s7,s2
      state = 0;
 940:	00000993          	li	s3,0
        i += 2;
 944:	e19ff06f          	j	75c <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
 948:	008b8913          	addi	s2,s7,8
 94c:	00000693          	li	a3,0
 950:	01000613          	li	a2,16
 954:	000ba583          	lw	a1,0(s7)
 958:	000b0513          	mv	a0,s6
 95c:	c9dff0ef          	jal	5f8 <printint>
 960:	00090b93          	mv	s7,s2
      state = 0;
 964:	00000993          	li	s3,0
 968:	df5ff06f          	j	75c <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
 96c:	008b8913          	addi	s2,s7,8
 970:	00000693          	li	a3,0
 974:	01000613          	li	a2,16
 978:	000ba583          	lw	a1,0(s7)
 97c:	000b0513          	mv	a0,s6
 980:	c79ff0ef          	jal	5f8 <printint>
        i += 1;
 984:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 988:	00090b93          	mv	s7,s2
      state = 0;
 98c:	00000993          	li	s3,0
        i += 1;
 990:	dcdff06f          	j	75c <vprintf+0x78>
 994:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 998:	008b8d13          	addi	s10,s7,8
 99c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9a0:	03000593          	li	a1,48
 9a4:	000b0513          	mv	a0,s6
 9a8:	c21ff0ef          	jal	5c8 <putc>
  putc(fd, 'x');
 9ac:	07800593          	li	a1,120
 9b0:	000b0513          	mv	a0,s6
 9b4:	c15ff0ef          	jal	5c8 <putc>
 9b8:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9bc:	00000b97          	auipc	s7,0x0
 9c0:	3bcb8b93          	addi	s7,s7,956 # d78 <digits>
 9c4:	03c9d793          	srli	a5,s3,0x3c
 9c8:	00fb87b3          	add	a5,s7,a5
 9cc:	0007c583          	lbu	a1,0(a5)
 9d0:	000b0513          	mv	a0,s6
 9d4:	bf5ff0ef          	jal	5c8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9d8:	00499993          	slli	s3,s3,0x4
 9dc:	fff9091b          	addiw	s2,s2,-1
 9e0:	fe0912e3          	bnez	s2,9c4 <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
 9e4:	000d0b93          	mv	s7,s10
      state = 0;
 9e8:	00000993          	li	s3,0
 9ec:	00013d03          	ld	s10,0(sp)
 9f0:	d6dff06f          	j	75c <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
 9f4:	008b8993          	addi	s3,s7,8
 9f8:	000bb903          	ld	s2,0(s7)
 9fc:	02090663          	beqz	s2,a28 <vprintf+0x344>
        for(; *s; s++)
 a00:	00094583          	lbu	a1,0(s2)
 a04:	02058a63          	beqz	a1,a38 <vprintf+0x354>
          putc(fd, *s);
 a08:	000b0513          	mv	a0,s6
 a0c:	bbdff0ef          	jal	5c8 <putc>
        for(; *s; s++)
 a10:	00190913          	addi	s2,s2,1
 a14:	00094583          	lbu	a1,0(s2)
 a18:	fe0598e3          	bnez	a1,a08 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 a1c:	00098b93          	mv	s7,s3
      state = 0;
 a20:	00000993          	li	s3,0
 a24:	d39ff06f          	j	75c <vprintf+0x78>
          s = "(null)";
 a28:	00000917          	auipc	s2,0x0
 a2c:	34890913          	addi	s2,s2,840 # d70 <malloc+0x1b4>
        for(; *s; s++)
 a30:	02800593          	li	a1,40
 a34:	fd5ff06f          	j	a08 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 a38:	00098b93          	mv	s7,s3
      state = 0;
 a3c:	00000993          	li	s3,0
 a40:	d1dff06f          	j	75c <vprintf+0x78>
 a44:	04813483          	ld	s1,72(sp)
 a48:	03813983          	ld	s3,56(sp)
 a4c:	03013a03          	ld	s4,48(sp)
 a50:	02813a83          	ld	s5,40(sp)
 a54:	02013b03          	ld	s6,32(sp)
 a58:	01813b83          	ld	s7,24(sp)
 a5c:	01013c03          	ld	s8,16(sp)
 a60:	00813c83          	ld	s9,8(sp)
    }
  }
}
 a64:	05813083          	ld	ra,88(sp)
 a68:	05013403          	ld	s0,80(sp)
 a6c:	04013903          	ld	s2,64(sp)
 a70:	06010113          	addi	sp,sp,96
 a74:	00008067          	ret

0000000000000a78 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a78:	fb010113          	addi	sp,sp,-80
 a7c:	00113c23          	sd	ra,24(sp)
 a80:	00813823          	sd	s0,16(sp)
 a84:	02010413          	addi	s0,sp,32
 a88:	00c43023          	sd	a2,0(s0)
 a8c:	00d43423          	sd	a3,8(s0)
 a90:	00e43823          	sd	a4,16(s0)
 a94:	00f43c23          	sd	a5,24(s0)
 a98:	03043023          	sd	a6,32(s0)
 a9c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 aa0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 aa4:	00040613          	mv	a2,s0
 aa8:	c3dff0ef          	jal	6e4 <vprintf>
}
 aac:	01813083          	ld	ra,24(sp)
 ab0:	01013403          	ld	s0,16(sp)
 ab4:	05010113          	addi	sp,sp,80
 ab8:	00008067          	ret

0000000000000abc <printf>:

void
printf(const char *fmt, ...)
{
 abc:	fa010113          	addi	sp,sp,-96
 ac0:	00113c23          	sd	ra,24(sp)
 ac4:	00813823          	sd	s0,16(sp)
 ac8:	02010413          	addi	s0,sp,32
 acc:	00b43423          	sd	a1,8(s0)
 ad0:	00c43823          	sd	a2,16(s0)
 ad4:	00d43c23          	sd	a3,24(s0)
 ad8:	02e43023          	sd	a4,32(s0)
 adc:	02f43423          	sd	a5,40(s0)
 ae0:	03043823          	sd	a6,48(s0)
 ae4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ae8:	00840613          	addi	a2,s0,8
 aec:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 af0:	00050593          	mv	a1,a0
 af4:	00100513          	li	a0,1
 af8:	bedff0ef          	jal	6e4 <vprintf>
}
 afc:	01813083          	ld	ra,24(sp)
 b00:	01013403          	ld	s0,16(sp)
 b04:	06010113          	addi	sp,sp,96
 b08:	00008067          	ret

0000000000000b0c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b0c:	ff010113          	addi	sp,sp,-16
 b10:	00813423          	sd	s0,8(sp)
 b14:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b18:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b1c:	00000797          	auipc	a5,0x0
 b20:	4e47b783          	ld	a5,1252(a5) # 1000 <freep>
 b24:	0400006f          	j	b64 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b28:	00862703          	lw	a4,8(a2)
 b2c:	00b7073b          	addw	a4,a4,a1
 b30:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b34:	0007b703          	ld	a4,0(a5)
 b38:	00073603          	ld	a2,0(a4)
 b3c:	0500006f          	j	b8c <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b40:	ff852703          	lw	a4,-8(a0)
 b44:	00c7073b          	addw	a4,a4,a2
 b48:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b4c:	ff053683          	ld	a3,-16(a0)
 b50:	0540006f          	j	ba4 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b54:	0007b703          	ld	a4,0(a5)
 b58:	00e7e463          	bltu	a5,a4,b60 <free+0x54>
 b5c:	00e6ec63          	bltu	a3,a4,b74 <free+0x68>
{
 b60:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b64:	fed7f8e3          	bgeu	a5,a3,b54 <free+0x48>
 b68:	0007b703          	ld	a4,0(a5)
 b6c:	00e6e463          	bltu	a3,a4,b74 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b70:	fee7e8e3          	bltu	a5,a4,b60 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 b74:	ff852583          	lw	a1,-8(a0)
 b78:	0007b603          	ld	a2,0(a5)
 b7c:	02059813          	slli	a6,a1,0x20
 b80:	01c85713          	srli	a4,a6,0x1c
 b84:	00e68733          	add	a4,a3,a4
 b88:	fae600e3          	beq	a2,a4,b28 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 b8c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b90:	0087a603          	lw	a2,8(a5)
 b94:	02061593          	slli	a1,a2,0x20
 b98:	01c5d713          	srli	a4,a1,0x1c
 b9c:	00e78733          	add	a4,a5,a4
 ba0:	fae680e3          	beq	a3,a4,b40 <free+0x34>
    p->s.ptr = bp->s.ptr;
 ba4:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 ba8:	00000717          	auipc	a4,0x0
 bac:	44f73c23          	sd	a5,1112(a4) # 1000 <freep>
}
 bb0:	00813403          	ld	s0,8(sp)
 bb4:	01010113          	addi	sp,sp,16
 bb8:	00008067          	ret

0000000000000bbc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 bbc:	fc010113          	addi	sp,sp,-64
 bc0:	02113c23          	sd	ra,56(sp)
 bc4:	02813823          	sd	s0,48(sp)
 bc8:	02913423          	sd	s1,40(sp)
 bcc:	01313c23          	sd	s3,24(sp)
 bd0:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bd4:	02051493          	slli	s1,a0,0x20
 bd8:	0204d493          	srli	s1,s1,0x20
 bdc:	00f48493          	addi	s1,s1,15
 be0:	0044d493          	srli	s1,s1,0x4
 be4:	0014899b          	addiw	s3,s1,1
 be8:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
 bec:	00000517          	auipc	a0,0x0
 bf0:	41453503          	ld	a0,1044(a0) # 1000 <freep>
 bf4:	04050663          	beqz	a0,c40 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bf8:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bfc:	0087a703          	lw	a4,8(a5)
 c00:	0c977c63          	bgeu	a4,s1,cd8 <malloc+0x11c>
 c04:	03213023          	sd	s2,32(sp)
 c08:	01413823          	sd	s4,16(sp)
 c0c:	01513423          	sd	s5,8(sp)
 c10:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
 c14:	00098a13          	mv	s4,s3
 c18:	0009871b          	sext.w	a4,s3
 c1c:	000016b7          	lui	a3,0x1
 c20:	00d77463          	bgeu	a4,a3,c28 <malloc+0x6c>
 c24:	00001a37          	lui	s4,0x1
 c28:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c2c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c30:	00000917          	auipc	s2,0x0
 c34:	3d090913          	addi	s2,s2,976 # 1000 <freep>
  if(p == (char*)-1)
 c38:	fff00a93          	li	s5,-1
 c3c:	05c0006f          	j	c98 <malloc+0xdc>
 c40:	03213023          	sd	s2,32(sp)
 c44:	01413823          	sd	s4,16(sp)
 c48:	01513423          	sd	s5,8(sp)
 c4c:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c50:	00000797          	auipc	a5,0x0
 c54:	3c078793          	addi	a5,a5,960 # 1010 <base>
 c58:	00000717          	auipc	a4,0x0
 c5c:	3af73423          	sd	a5,936(a4) # 1000 <freep>
 c60:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 c64:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c68:	fadff06f          	j	c14 <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
 c6c:	0007b703          	ld	a4,0(a5)
 c70:	00e53023          	sd	a4,0(a0)
 c74:	0800006f          	j	cf4 <malloc+0x138>
  hp->s.size = nu;
 c78:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c7c:	01050513          	addi	a0,a0,16
 c80:	e8dff0ef          	jal	b0c <free>
  return freep;
 c84:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c88:	08050863          	beqz	a0,d18 <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c8c:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c90:	0087a703          	lw	a4,8(a5)
 c94:	02977a63          	bgeu	a4,s1,cc8 <malloc+0x10c>
    if(p == freep)
 c98:	00093703          	ld	a4,0(s2)
 c9c:	00078513          	mv	a0,a5
 ca0:	fef716e3          	bne	a4,a5,c8c <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
 ca4:	000a0513          	mv	a0,s4
 ca8:	8fdff0ef          	jal	5a4 <sbrk>
  if(p == (char*)-1)
 cac:	fd5516e3          	bne	a0,s5,c78 <malloc+0xbc>
        return 0;
 cb0:	00000513          	li	a0,0
 cb4:	02013903          	ld	s2,32(sp)
 cb8:	01013a03          	ld	s4,16(sp)
 cbc:	00813a83          	ld	s5,8(sp)
 cc0:	00013b03          	ld	s6,0(sp)
 cc4:	03c0006f          	j	d00 <malloc+0x144>
 cc8:	02013903          	ld	s2,32(sp)
 ccc:	01013a03          	ld	s4,16(sp)
 cd0:	00813a83          	ld	s5,8(sp)
 cd4:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
 cd8:	f8e48ae3          	beq	s1,a4,c6c <malloc+0xb0>
        p->s.size -= nunits;
 cdc:	4137073b          	subw	a4,a4,s3
 ce0:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 ce4:	02071693          	slli	a3,a4,0x20
 ce8:	01c6d713          	srli	a4,a3,0x1c
 cec:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 cf0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 cf4:	00000717          	auipc	a4,0x0
 cf8:	30a73623          	sd	a0,780(a4) # 1000 <freep>
      return (void*)(p + 1);
 cfc:	01078513          	addi	a0,a5,16
  }
}
 d00:	03813083          	ld	ra,56(sp)
 d04:	03013403          	ld	s0,48(sp)
 d08:	02813483          	ld	s1,40(sp)
 d0c:	01813983          	ld	s3,24(sp)
 d10:	04010113          	addi	sp,sp,64
 d14:	00008067          	ret
 d18:	02013903          	ld	s2,32(sp)
 d1c:	01013a03          	ld	s4,16(sp)
 d20:	00813a83          	ld	s5,8(sp)
 d24:	00013b03          	ld	s6,0(sp)
 d28:	fd9ff06f          	j	d00 <malloc+0x144>
