
user/_primes:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <new_process>:
#include "kernel/stat.h"
#include "user/user.h"


void new_process(int pipe_last[2])
{
   0:	f2010113          	addi	sp,sp,-224
   4:	0c113c23          	sd	ra,216(sp)
   8:	0c813823          	sd	s0,208(sp)
   c:	0c913423          	sd	s1,200(sp)
  10:	0d213023          	sd	s2,192(sp)
  14:	0b313c23          	sd	s3,184(sp)
  18:	0e010413          	addi	s0,sp,224
  1c:	00050993          	mv	s3,a0
	int n;
	int pipe_next[2];
	int i = 0;
	int p;

	if(pipe(pipe_next) == -1)
  20:	f3040513          	addi	a0,s0,-208
  24:	5ac000ef          	jal	5d0 <pipe>
  28:	fff00793          	li	a5,-1
  2c:	02f50063          	beq	a0,a5,4c <new_process+0x4c>
	{
		fprintf(2, "Pipe failed\n");
    	exit(1);
	}

	memset(primes, 0, sizeof(primes));
  30:	08c00613          	li	a2,140
  34:	00000593          	li	a1,0
  38:	f4040513          	addi	a0,s0,-192
  3c:	27c000ef          	jal	2b8 <memset>

	while(read(pipe_last[0],aux_buf, sizeof(int)) != 0)
  40:	f4040493          	addi	s1,s0,-192
	int i = 0;
  44:	00000913          	li	s2,0
	while(read(pipe_last[0],aux_buf, sizeof(int)) != 0)
  48:	02c0006f          	j	74 <new_process+0x74>
		fprintf(2, "Pipe failed\n");
  4c:	00001597          	auipc	a1,0x1
  50:	dc458593          	addi	a1,a1,-572 # e10 <malloc+0x174>
  54:	00200513          	li	a0,2
  58:	301000ef          	jal	b58 <fprintf>
    	exit(1);
  5c:	00100513          	li	a0,1
  60:	558000ef          	jal	5b8 <exit>
	{
		primes[i] = aux_buf[0];
  64:	f3844783          	lbu	a5,-200(s0)
  68:	00f4a023          	sw	a5,0(s1)
		i++;
  6c:	0019091b          	addiw	s2,s2,1
  70:	00448493          	addi	s1,s1,4
	while(read(pipe_last[0],aux_buf, sizeof(int)) != 0)
  74:	00400613          	li	a2,4
  78:	f3840593          	addi	a1,s0,-200
  7c:	0009a503          	lw	a0,0(s3)
  80:	55c000ef          	jal	5dc <read>
  84:	fe0510e3          	bnez	a0,64 <new_process+0x64>
	}
	close(pipe_last[0]);
  88:	0009a503          	lw	a0,0(s3)
  8c:	568000ef          	jal	5f4 <close>

	if(i == 0) //its the last iteration
  90:	02090263          	beqz	s2,b4 <new_process+0xb4>
		close(pipe_next[0]);
		close(pipe_next[1]);
		return;
	}

	n = primes[0];
  94:	f4042983          	lw	s3,-192(s0)
	printf("%d \n", n);
  98:	00098593          	mv	a1,s3
  9c:	00001517          	auipc	a0,0x1
  a0:	d8450513          	addi	a0,a0,-636 # e20 <malloc+0x184>
  a4:	2f9000ef          	jal	b9c <printf>

	for(i = 1;i < 35; i++)
  a8:	f4440493          	addi	s1,s0,-188
  ac:	fcc40913          	addi	s2,s0,-52
  b0:	0200006f          	j	d0 <new_process+0xd0>
		close(pipe_next[0]);
  b4:	f3042503          	lw	a0,-208(s0)
  b8:	53c000ef          	jal	5f4 <close>
		close(pipe_next[1]);
  bc:	f3442503          	lw	a0,-204(s0)
  c0:	534000ef          	jal	5f4 <close>
		return;
  c4:	0400006f          	j	104 <new_process+0x104>
	for(i = 1;i < 35; i++)
  c8:	00448493          	addi	s1,s1,4
  cc:	03248463          	beq	s1,s2,f4 <new_process+0xf4>
	{
		if(primes[i] % n != 0)
  d0:	0004a783          	lw	a5,0(s1)
  d4:	0337e73b          	remw	a4,a5,s3
  d8:	fe0708e3          	beqz	a4,c8 <new_process+0xc8>
		{
			p = primes[i];
  dc:	f2f42623          	sw	a5,-212(s0)
			write(pipe_next[1], &p, sizeof(p));
  e0:	00400613          	li	a2,4
  e4:	f2c40593          	addi	a1,s0,-212
  e8:	f3442503          	lw	a0,-204(s0)
  ec:	4fc000ef          	jal	5e8 <write>
  f0:	fd9ff06f          	j	c8 <new_process+0xc8>
		}
	}

	close(pipe_next[1]);
  f4:	f3442503          	lw	a0,-204(s0)
  f8:	4fc000ef          	jal	5f4 <close>

	int pid = fork();
  fc:	4b0000ef          	jal	5ac <fork>
	if(pid == 0)
 100:	02050063          	beqz	a0,120 <new_process+0x120>
	{
		new_process(pipe_next);
	}


}
 104:	0d813083          	ld	ra,216(sp)
 108:	0d013403          	ld	s0,208(sp)
 10c:	0c813483          	ld	s1,200(sp)
 110:	0c013903          	ld	s2,192(sp)
 114:	0b813983          	ld	s3,184(sp)
 118:	0e010113          	addi	sp,sp,224
 11c:	00008067          	ret
		new_process(pipe_next);
 120:	f3040513          	addi	a0,s0,-208
 124:	eddff0ef          	jal	0 <new_process>
 128:	fddff06f          	j	104 <new_process+0x104>

000000000000012c <main>:

int main()
{
 12c:	fd010113          	addi	sp,sp,-48
 130:	02113423          	sd	ra,40(sp)
 134:	02813023          	sd	s0,32(sp)
 138:	00913c23          	sd	s1,24(sp)
 13c:	01213823          	sd	s2,16(sp)
 140:	03010413          	addi	s0,sp,48
	int pipe1[2];

	if(pipe(pipe1) == -1)
 144:	fd840513          	addi	a0,s0,-40
 148:	488000ef          	jal	5d0 <pipe>
 14c:	fff00793          	li	a5,-1
 150:	02f50063          	beq	a0,a5,170 <main+0x44>
	{
		fprintf(2, "Pipe failed\n");
    	exit(1);
	}

	printf("%d \n", 2);
 154:	00200593          	li	a1,2
 158:	00001517          	auipc	a0,0x1
 15c:	cc850513          	addi	a0,a0,-824 # e20 <malloc+0x184>
 160:	23d000ef          	jal	b9c <printf>

	for(int i = 2;i <= 35; i++)
 164:	00200493          	li	s1,2
 168:	02400913          	li	s2,36
 16c:	0240006f          	j	190 <main+0x64>
		fprintf(2, "Pipe failed\n");
 170:	00001597          	auipc	a1,0x1
 174:	ca058593          	addi	a1,a1,-864 # e10 <malloc+0x174>
 178:	00200513          	li	a0,2
 17c:	1dd000ef          	jal	b58 <fprintf>
    	exit(1);
 180:	00100513          	li	a0,1
 184:	434000ef          	jal	5b8 <exit>
	for(int i = 2;i <= 35; i++)
 188:	0014849b          	addiw	s1,s1,1
 18c:	03248263          	beq	s1,s2,1b0 <main+0x84>
	{
		if(i % 2 != 0)
 190:	0014f793          	andi	a5,s1,1
 194:	fe078ae3          	beqz	a5,188 <main+0x5c>
		{
			int p = i;
 198:	fc942a23          	sw	s1,-44(s0)
			write(pipe1[1], &p, sizeof(p)); //all even number pass here
 19c:	00400613          	li	a2,4
 1a0:	fd440593          	addi	a1,s0,-44
 1a4:	fdc42503          	lw	a0,-36(s0)
 1a8:	440000ef          	jal	5e8 <write>
 1ac:	fddff06f          	j	188 <main+0x5c>
		}
	}

	close(pipe1[1]);
 1b0:	fdc42503          	lw	a0,-36(s0)
 1b4:	440000ef          	jal	5f4 <close>
	new_process(pipe1);
 1b8:	fd840513          	addi	a0,s0,-40
 1bc:	e45ff0ef          	jal	0 <new_process>

	wait(0);
 1c0:	00000513          	li	a0,0
 1c4:	400000ef          	jal	5c4 <wait>

	return 0;

 1c8:	00000513          	li	a0,0
 1cc:	02813083          	ld	ra,40(sp)
 1d0:	02013403          	ld	s0,32(sp)
 1d4:	01813483          	ld	s1,24(sp)
 1d8:	01013903          	ld	s2,16(sp)
 1dc:	03010113          	addi	sp,sp,48
 1e0:	00008067          	ret

00000000000001e4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1e4:	ff010113          	addi	sp,sp,-16
 1e8:	00113423          	sd	ra,8(sp)
 1ec:	00813023          	sd	s0,0(sp)
 1f0:	01010413          	addi	s0,sp,16
  extern int main();
  main();
 1f4:	f39ff0ef          	jal	12c <main>
  exit(0);
 1f8:	00000513          	li	a0,0
 1fc:	3bc000ef          	jal	5b8 <exit>

0000000000000200 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 200:	ff010113          	addi	sp,sp,-16
 204:	00813423          	sd	s0,8(sp)
 208:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 20c:	00050793          	mv	a5,a0
 210:	00158593          	addi	a1,a1,1
 214:	00178793          	addi	a5,a5,1
 218:	fff5c703          	lbu	a4,-1(a1)
 21c:	fee78fa3          	sb	a4,-1(a5)
 220:	fe0718e3          	bnez	a4,210 <strcpy+0x10>
    ;
  return os;
}
 224:	00813403          	ld	s0,8(sp)
 228:	01010113          	addi	sp,sp,16
 22c:	00008067          	ret

0000000000000230 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 230:	ff010113          	addi	sp,sp,-16
 234:	00813423          	sd	s0,8(sp)
 238:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
 23c:	00054783          	lbu	a5,0(a0)
 240:	00078e63          	beqz	a5,25c <strcmp+0x2c>
 244:	0005c703          	lbu	a4,0(a1)
 248:	00f71a63          	bne	a4,a5,25c <strcmp+0x2c>
    p++, q++;
 24c:	00150513          	addi	a0,a0,1
 250:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
 254:	00054783          	lbu	a5,0(a0)
 258:	fe0796e3          	bnez	a5,244 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 25c:	0005c503          	lbu	a0,0(a1)
}
 260:	40a7853b          	subw	a0,a5,a0
 264:	00813403          	ld	s0,8(sp)
 268:	01010113          	addi	sp,sp,16
 26c:	00008067          	ret

0000000000000270 <strlen>:

uint
strlen(const char *s)
{
 270:	ff010113          	addi	sp,sp,-16
 274:	00813423          	sd	s0,8(sp)
 278:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 27c:	00054783          	lbu	a5,0(a0)
 280:	02078863          	beqz	a5,2b0 <strlen+0x40>
 284:	00150513          	addi	a0,a0,1
 288:	00050793          	mv	a5,a0
 28c:	00078693          	mv	a3,a5
 290:	00178793          	addi	a5,a5,1
 294:	fff7c703          	lbu	a4,-1(a5)
 298:	fe071ae3          	bnez	a4,28c <strlen+0x1c>
 29c:	40a6853b          	subw	a0,a3,a0
 2a0:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
 2a4:	00813403          	ld	s0,8(sp)
 2a8:	01010113          	addi	sp,sp,16
 2ac:	00008067          	ret
  for(n = 0; s[n]; n++)
 2b0:	00000513          	li	a0,0
 2b4:	ff1ff06f          	j	2a4 <strlen+0x34>

00000000000002b8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2b8:	ff010113          	addi	sp,sp,-16
 2bc:	00813423          	sd	s0,8(sp)
 2c0:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2c4:	02060063          	beqz	a2,2e4 <memset+0x2c>
 2c8:	00050793          	mv	a5,a0
 2cc:	02061613          	slli	a2,a2,0x20
 2d0:	02065613          	srli	a2,a2,0x20
 2d4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2dc:	00178793          	addi	a5,a5,1
 2e0:	fee79ce3          	bne	a5,a4,2d8 <memset+0x20>
  }
  return dst;
}
 2e4:	00813403          	ld	s0,8(sp)
 2e8:	01010113          	addi	sp,sp,16
 2ec:	00008067          	ret

00000000000002f0 <strchr>:

char*
strchr(const char *s, char c)
{
 2f0:	ff010113          	addi	sp,sp,-16
 2f4:	00813423          	sd	s0,8(sp)
 2f8:	01010413          	addi	s0,sp,16
  for(; *s; s++)
 2fc:	00054783          	lbu	a5,0(a0)
 300:	02078263          	beqz	a5,324 <strchr+0x34>
    if(*s == c)
 304:	00f58a63          	beq	a1,a5,318 <strchr+0x28>
  for(; *s; s++)
 308:	00150513          	addi	a0,a0,1
 30c:	00054783          	lbu	a5,0(a0)
 310:	fe079ae3          	bnez	a5,304 <strchr+0x14>
      return (char*)s;
  return 0;
 314:	00000513          	li	a0,0
}
 318:	00813403          	ld	s0,8(sp)
 31c:	01010113          	addi	sp,sp,16
 320:	00008067          	ret
  return 0;
 324:	00000513          	li	a0,0
 328:	ff1ff06f          	j	318 <strchr+0x28>

000000000000032c <gets>:

char*
gets(char *buf, int max)
{
 32c:	fa010113          	addi	sp,sp,-96
 330:	04113c23          	sd	ra,88(sp)
 334:	04813823          	sd	s0,80(sp)
 338:	04913423          	sd	s1,72(sp)
 33c:	05213023          	sd	s2,64(sp)
 340:	03313c23          	sd	s3,56(sp)
 344:	03413823          	sd	s4,48(sp)
 348:	03513423          	sd	s5,40(sp)
 34c:	03613023          	sd	s6,32(sp)
 350:	01713c23          	sd	s7,24(sp)
 354:	06010413          	addi	s0,sp,96
 358:	00050b93          	mv	s7,a0
 35c:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 360:	00050913          	mv	s2,a0
 364:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 368:	00a00a93          	li	s5,10
 36c:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 370:	00048993          	mv	s3,s1
 374:	0014849b          	addiw	s1,s1,1
 378:	0344dc63          	bge	s1,s4,3b0 <gets+0x84>
    cc = read(0, &c, 1);
 37c:	00100613          	li	a2,1
 380:	faf40593          	addi	a1,s0,-81
 384:	00000513          	li	a0,0
 388:	254000ef          	jal	5dc <read>
    if(cc < 1)
 38c:	02a05263          	blez	a0,3b0 <gets+0x84>
    buf[i++] = c;
 390:	faf44783          	lbu	a5,-81(s0)
 394:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 398:	01578a63          	beq	a5,s5,3ac <gets+0x80>
 39c:	00190913          	addi	s2,s2,1
 3a0:	fd6798e3          	bne	a5,s6,370 <gets+0x44>
    buf[i++] = c;
 3a4:	00048993          	mv	s3,s1
 3a8:	0080006f          	j	3b0 <gets+0x84>
 3ac:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3b0:	013b89b3          	add	s3,s7,s3
 3b4:	00098023          	sb	zero,0(s3)
  return buf;
}
 3b8:	000b8513          	mv	a0,s7
 3bc:	05813083          	ld	ra,88(sp)
 3c0:	05013403          	ld	s0,80(sp)
 3c4:	04813483          	ld	s1,72(sp)
 3c8:	04013903          	ld	s2,64(sp)
 3cc:	03813983          	ld	s3,56(sp)
 3d0:	03013a03          	ld	s4,48(sp)
 3d4:	02813a83          	ld	s5,40(sp)
 3d8:	02013b03          	ld	s6,32(sp)
 3dc:	01813b83          	ld	s7,24(sp)
 3e0:	06010113          	addi	sp,sp,96
 3e4:	00008067          	ret

00000000000003e8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e8:	fe010113          	addi	sp,sp,-32
 3ec:	00113c23          	sd	ra,24(sp)
 3f0:	00813823          	sd	s0,16(sp)
 3f4:	01213023          	sd	s2,0(sp)
 3f8:	02010413          	addi	s0,sp,32
 3fc:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 400:	00000593          	li	a1,0
 404:	214000ef          	jal	618 <open>
  if(fd < 0)
 408:	02054e63          	bltz	a0,444 <stat+0x5c>
 40c:	00913423          	sd	s1,8(sp)
 410:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 414:	00090593          	mv	a1,s2
 418:	224000ef          	jal	63c <fstat>
 41c:	00050913          	mv	s2,a0
  close(fd);
 420:	00048513          	mv	a0,s1
 424:	1d0000ef          	jal	5f4 <close>
  return r;
 428:	00813483          	ld	s1,8(sp)
}
 42c:	00090513          	mv	a0,s2
 430:	01813083          	ld	ra,24(sp)
 434:	01013403          	ld	s0,16(sp)
 438:	00013903          	ld	s2,0(sp)
 43c:	02010113          	addi	sp,sp,32
 440:	00008067          	ret
    return -1;
 444:	fff00913          	li	s2,-1
 448:	fe5ff06f          	j	42c <stat+0x44>

000000000000044c <atoi>:

int
atoi(const char *s)
{
 44c:	ff010113          	addi	sp,sp,-16
 450:	00813423          	sd	s0,8(sp)
 454:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 458:	00054683          	lbu	a3,0(a0)
 45c:	fd06879b          	addiw	a5,a3,-48
 460:	0ff7f793          	zext.b	a5,a5
 464:	00900613          	li	a2,9
 468:	04f66063          	bltu	a2,a5,4a8 <atoi+0x5c>
 46c:	00050713          	mv	a4,a0
  n = 0;
 470:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 474:	00170713          	addi	a4,a4,1
 478:	0025179b          	slliw	a5,a0,0x2
 47c:	00a787bb          	addw	a5,a5,a0
 480:	0017979b          	slliw	a5,a5,0x1
 484:	00d787bb          	addw	a5,a5,a3
 488:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 48c:	00074683          	lbu	a3,0(a4)
 490:	fd06879b          	addiw	a5,a3,-48
 494:	0ff7f793          	zext.b	a5,a5
 498:	fcf67ee3          	bgeu	a2,a5,474 <atoi+0x28>
  return n;
}
 49c:	00813403          	ld	s0,8(sp)
 4a0:	01010113          	addi	sp,sp,16
 4a4:	00008067          	ret
  n = 0;
 4a8:	00000513          	li	a0,0
 4ac:	ff1ff06f          	j	49c <atoi+0x50>

00000000000004b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b0:	ff010113          	addi	sp,sp,-16
 4b4:	00813423          	sd	s0,8(sp)
 4b8:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4bc:	02b57c63          	bgeu	a0,a1,4f4 <memmove+0x44>
    while(n-- > 0)
 4c0:	02c05463          	blez	a2,4e8 <memmove+0x38>
 4c4:	02061613          	slli	a2,a2,0x20
 4c8:	02065613          	srli	a2,a2,0x20
 4cc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4d0:	00050713          	mv	a4,a0
      *dst++ = *src++;
 4d4:	00158593          	addi	a1,a1,1
 4d8:	00170713          	addi	a4,a4,1
 4dc:	fff5c683          	lbu	a3,-1(a1)
 4e0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4e4:	fef718e3          	bne	a4,a5,4d4 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4e8:	00813403          	ld	s0,8(sp)
 4ec:	01010113          	addi	sp,sp,16
 4f0:	00008067          	ret
    dst += n;
 4f4:	00c50733          	add	a4,a0,a2
    src += n;
 4f8:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 4fc:	fec056e3          	blez	a2,4e8 <memmove+0x38>
 500:	fff6079b          	addiw	a5,a2,-1
 504:	02079793          	slli	a5,a5,0x20
 508:	0207d793          	srli	a5,a5,0x20
 50c:	fff7c793          	not	a5,a5
 510:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 514:	fff58593          	addi	a1,a1,-1
 518:	fff70713          	addi	a4,a4,-1
 51c:	0005c683          	lbu	a3,0(a1)
 520:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 524:	fee798e3          	bne	a5,a4,514 <memmove+0x64>
 528:	fc1ff06f          	j	4e8 <memmove+0x38>

000000000000052c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 52c:	ff010113          	addi	sp,sp,-16
 530:	00813423          	sd	s0,8(sp)
 534:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 538:	04060463          	beqz	a2,580 <memcmp+0x54>
 53c:	fff6069b          	addiw	a3,a2,-1
 540:	02069693          	slli	a3,a3,0x20
 544:	0206d693          	srli	a3,a3,0x20
 548:	00168693          	addi	a3,a3,1
 54c:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 550:	00054783          	lbu	a5,0(a0)
 554:	0005c703          	lbu	a4,0(a1)
 558:	00e79c63          	bne	a5,a4,570 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 55c:	00150513          	addi	a0,a0,1
    p2++;
 560:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
 564:	fed516e3          	bne	a0,a3,550 <memcmp+0x24>
  }
  return 0;
 568:	00000513          	li	a0,0
 56c:	0080006f          	j	574 <memcmp+0x48>
      return *p1 - *p2;
 570:	40e7853b          	subw	a0,a5,a4
}
 574:	00813403          	ld	s0,8(sp)
 578:	01010113          	addi	sp,sp,16
 57c:	00008067          	ret
  return 0;
 580:	00000513          	li	a0,0
 584:	ff1ff06f          	j	574 <memcmp+0x48>

0000000000000588 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 588:	ff010113          	addi	sp,sp,-16
 58c:	00113423          	sd	ra,8(sp)
 590:	00813023          	sd	s0,0(sp)
 594:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
 598:	f19ff0ef          	jal	4b0 <memmove>
}
 59c:	00813083          	ld	ra,8(sp)
 5a0:	00013403          	ld	s0,0(sp)
 5a4:	01010113          	addi	sp,sp,16
 5a8:	00008067          	ret

00000000000005ac <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5ac:	00100893          	li	a7,1
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	00008067          	ret

00000000000005b8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5b8:	00200893          	li	a7,2
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	00008067          	ret

00000000000005c4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5c4:	00300893          	li	a7,3
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	00008067          	ret

00000000000005d0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5d0:	00400893          	li	a7,4
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	00008067          	ret

00000000000005dc <read>:
.global read
read:
 li a7, SYS_read
 5dc:	00500893          	li	a7,5
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	00008067          	ret

00000000000005e8 <write>:
.global write
write:
 li a7, SYS_write
 5e8:	01000893          	li	a7,16
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	00008067          	ret

00000000000005f4 <close>:
.global close
close:
 li a7, SYS_close
 5f4:	01500893          	li	a7,21
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	00008067          	ret

0000000000000600 <kill>:
.global kill
kill:
 li a7, SYS_kill
 600:	00600893          	li	a7,6
 ecall
 604:	00000073          	ecall
 ret
 608:	00008067          	ret

000000000000060c <exec>:
.global exec
exec:
 li a7, SYS_exec
 60c:	00700893          	li	a7,7
 ecall
 610:	00000073          	ecall
 ret
 614:	00008067          	ret

0000000000000618 <open>:
.global open
open:
 li a7, SYS_open
 618:	00f00893          	li	a7,15
 ecall
 61c:	00000073          	ecall
 ret
 620:	00008067          	ret

0000000000000624 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 624:	01100893          	li	a7,17
 ecall
 628:	00000073          	ecall
 ret
 62c:	00008067          	ret

0000000000000630 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 630:	01200893          	li	a7,18
 ecall
 634:	00000073          	ecall
 ret
 638:	00008067          	ret

000000000000063c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 63c:	00800893          	li	a7,8
 ecall
 640:	00000073          	ecall
 ret
 644:	00008067          	ret

0000000000000648 <link>:
.global link
link:
 li a7, SYS_link
 648:	01300893          	li	a7,19
 ecall
 64c:	00000073          	ecall
 ret
 650:	00008067          	ret

0000000000000654 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 654:	01400893          	li	a7,20
 ecall
 658:	00000073          	ecall
 ret
 65c:	00008067          	ret

0000000000000660 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 660:	00900893          	li	a7,9
 ecall
 664:	00000073          	ecall
 ret
 668:	00008067          	ret

000000000000066c <dup>:
.global dup
dup:
 li a7, SYS_dup
 66c:	00a00893          	li	a7,10
 ecall
 670:	00000073          	ecall
 ret
 674:	00008067          	ret

0000000000000678 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 678:	00b00893          	li	a7,11
 ecall
 67c:	00000073          	ecall
 ret
 680:	00008067          	ret

0000000000000684 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 684:	00c00893          	li	a7,12
 ecall
 688:	00000073          	ecall
 ret
 68c:	00008067          	ret

0000000000000690 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 690:	00d00893          	li	a7,13
 ecall
 694:	00000073          	ecall
 ret
 698:	00008067          	ret

000000000000069c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 69c:	00e00893          	li	a7,14
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	00008067          	ret

00000000000006a8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6a8:	fe010113          	addi	sp,sp,-32
 6ac:	00113c23          	sd	ra,24(sp)
 6b0:	00813823          	sd	s0,16(sp)
 6b4:	02010413          	addi	s0,sp,32
 6b8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6bc:	00100613          	li	a2,1
 6c0:	fef40593          	addi	a1,s0,-17
 6c4:	f25ff0ef          	jal	5e8 <write>
}
 6c8:	01813083          	ld	ra,24(sp)
 6cc:	01013403          	ld	s0,16(sp)
 6d0:	02010113          	addi	sp,sp,32
 6d4:	00008067          	ret

00000000000006d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6d8:	fc010113          	addi	sp,sp,-64
 6dc:	02113c23          	sd	ra,56(sp)
 6e0:	02813823          	sd	s0,48(sp)
 6e4:	02913423          	sd	s1,40(sp)
 6e8:	04010413          	addi	s0,sp,64
 6ec:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6f0:	00068463          	beqz	a3,6f8 <printint+0x20>
 6f4:	0c05c263          	bltz	a1,7b8 <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6f8:	0005859b          	sext.w	a1,a1
  neg = 0;
 6fc:	00000893          	li	a7,0
 700:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 704:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 708:	0006061b          	sext.w	a2,a2
 70c:	00000517          	auipc	a0,0x0
 710:	72450513          	addi	a0,a0,1828 # e30 <digits>
 714:	00070813          	mv	a6,a4
 718:	0017071b          	addiw	a4,a4,1
 71c:	02c5f7bb          	remuw	a5,a1,a2
 720:	02079793          	slli	a5,a5,0x20
 724:	0207d793          	srli	a5,a5,0x20
 728:	00f507b3          	add	a5,a0,a5
 72c:	0007c783          	lbu	a5,0(a5)
 730:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 734:	0005879b          	sext.w	a5,a1
 738:	02c5d5bb          	divuw	a1,a1,a2
 73c:	00168693          	addi	a3,a3,1
 740:	fcc7fae3          	bgeu	a5,a2,714 <printint+0x3c>
  if(neg)
 744:	00088c63          	beqz	a7,75c <printint+0x84>
    buf[i++] = '-';
 748:	fd070793          	addi	a5,a4,-48
 74c:	00878733          	add	a4,a5,s0
 750:	02d00793          	li	a5,45
 754:	fef70823          	sb	a5,-16(a4)
 758:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 75c:	04e05463          	blez	a4,7a4 <printint+0xcc>
 760:	03213023          	sd	s2,32(sp)
 764:	01313c23          	sd	s3,24(sp)
 768:	fc040793          	addi	a5,s0,-64
 76c:	00e78933          	add	s2,a5,a4
 770:	fff78993          	addi	s3,a5,-1
 774:	00e989b3          	add	s3,s3,a4
 778:	fff7071b          	addiw	a4,a4,-1
 77c:	02071713          	slli	a4,a4,0x20
 780:	02075713          	srli	a4,a4,0x20
 784:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 788:	fff94583          	lbu	a1,-1(s2)
 78c:	00048513          	mv	a0,s1
 790:	f19ff0ef          	jal	6a8 <putc>
  while(--i >= 0)
 794:	fff90913          	addi	s2,s2,-1
 798:	ff3918e3          	bne	s2,s3,788 <printint+0xb0>
 79c:	02013903          	ld	s2,32(sp)
 7a0:	01813983          	ld	s3,24(sp)
}
 7a4:	03813083          	ld	ra,56(sp)
 7a8:	03013403          	ld	s0,48(sp)
 7ac:	02813483          	ld	s1,40(sp)
 7b0:	04010113          	addi	sp,sp,64
 7b4:	00008067          	ret
    x = -xx;
 7b8:	40b005bb          	negw	a1,a1
    neg = 1;
 7bc:	00100893          	li	a7,1
    x = -xx;
 7c0:	f41ff06f          	j	700 <printint+0x28>

00000000000007c4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7c4:	fa010113          	addi	sp,sp,-96
 7c8:	04113c23          	sd	ra,88(sp)
 7cc:	04813823          	sd	s0,80(sp)
 7d0:	05213023          	sd	s2,64(sp)
 7d4:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7d8:	0005c903          	lbu	s2,0(a1)
 7dc:	36090463          	beqz	s2,b44 <vprintf+0x380>
 7e0:	04913423          	sd	s1,72(sp)
 7e4:	03313c23          	sd	s3,56(sp)
 7e8:	03413823          	sd	s4,48(sp)
 7ec:	03513423          	sd	s5,40(sp)
 7f0:	03613023          	sd	s6,32(sp)
 7f4:	01713c23          	sd	s7,24(sp)
 7f8:	01813823          	sd	s8,16(sp)
 7fc:	01913423          	sd	s9,8(sp)
 800:	00050b13          	mv	s6,a0
 804:	00058a13          	mv	s4,a1
 808:	00060b93          	mv	s7,a2
  state = 0;
 80c:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
 810:	00000493          	li	s1,0
 814:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 818:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 81c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 820:	06c00c93          	li	s9,108
 824:	02c0006f          	j	850 <vprintf+0x8c>
        putc(fd, c0);
 828:	00090593          	mv	a1,s2
 82c:	000b0513          	mv	a0,s6
 830:	e79ff0ef          	jal	6a8 <putc>
 834:	0080006f          	j	83c <vprintf+0x78>
    } else if(state == '%'){
 838:	03598663          	beq	s3,s5,864 <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
 83c:	0014849b          	addiw	s1,s1,1
 840:	00048713          	mv	a4,s1
 844:	009a07b3          	add	a5,s4,s1
 848:	0007c903          	lbu	s2,0(a5)
 84c:	2c090c63          	beqz	s2,b24 <vprintf+0x360>
    c0 = fmt[i] & 0xff;
 850:	0009079b          	sext.w	a5,s2
    if(state == 0){
 854:	fe0992e3          	bnez	s3,838 <vprintf+0x74>
      if(c0 == '%'){
 858:	fd5798e3          	bne	a5,s5,828 <vprintf+0x64>
        state = '%';
 85c:	00078993          	mv	s3,a5
 860:	fddff06f          	j	83c <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
 864:	00ea06b3          	add	a3,s4,a4
 868:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 86c:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 870:	00068663          	beqz	a3,87c <vprintf+0xb8>
 874:	00ea0733          	add	a4,s4,a4
 878:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 87c:	05878263          	beq	a5,s8,8c0 <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
 880:	07978263          	beq	a5,s9,8e4 <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 884:	07500713          	li	a4,117
 888:	12e78663          	beq	a5,a4,9b4 <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 88c:	07800713          	li	a4,120
 890:	18e78c63          	beq	a5,a4,a28 <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 894:	07000713          	li	a4,112
 898:	1ce78e63          	beq	a5,a4,a74 <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 89c:	07300713          	li	a4,115
 8a0:	22e78a63          	beq	a5,a4,ad4 <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 8a4:	02500713          	li	a4,37
 8a8:	04e79e63          	bne	a5,a4,904 <vprintf+0x140>
        putc(fd, '%');
 8ac:	02500593          	li	a1,37
 8b0:	000b0513          	mv	a0,s6
 8b4:	df5ff0ef          	jal	6a8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 8b8:	00000993          	li	s3,0
 8bc:	f81ff06f          	j	83c <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
 8c0:	008b8913          	addi	s2,s7,8
 8c4:	00100693          	li	a3,1
 8c8:	00a00613          	li	a2,10
 8cc:	000ba583          	lw	a1,0(s7)
 8d0:	000b0513          	mv	a0,s6
 8d4:	e05ff0ef          	jal	6d8 <printint>
 8d8:	00090b93          	mv	s7,s2
      state = 0;
 8dc:	00000993          	li	s3,0
 8e0:	f5dff06f          	j	83c <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
 8e4:	06400793          	li	a5,100
 8e8:	02f68e63          	beq	a3,a5,924 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8ec:	06c00793          	li	a5,108
 8f0:	04f68e63          	beq	a3,a5,94c <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
 8f4:	07500793          	li	a5,117
 8f8:	0ef68063          	beq	a3,a5,9d8 <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
 8fc:	07800793          	li	a5,120
 900:	14f68663          	beq	a3,a5,a4c <vprintf+0x288>
        putc(fd, '%');
 904:	02500593          	li	a1,37
 908:	000b0513          	mv	a0,s6
 90c:	d9dff0ef          	jal	6a8 <putc>
        putc(fd, c0);
 910:	00090593          	mv	a1,s2
 914:	000b0513          	mv	a0,s6
 918:	d91ff0ef          	jal	6a8 <putc>
      state = 0;
 91c:	00000993          	li	s3,0
 920:	f1dff06f          	j	83c <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 924:	008b8913          	addi	s2,s7,8
 928:	00100693          	li	a3,1
 92c:	00a00613          	li	a2,10
 930:	000ba583          	lw	a1,0(s7)
 934:	000b0513          	mv	a0,s6
 938:	da1ff0ef          	jal	6d8 <printint>
        i += 1;
 93c:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 940:	00090b93          	mv	s7,s2
      state = 0;
 944:	00000993          	li	s3,0
        i += 1;
 948:	ef5ff06f          	j	83c <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 94c:	06400793          	li	a5,100
 950:	02f60e63          	beq	a2,a5,98c <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 954:	07500793          	li	a5,117
 958:	0af60463          	beq	a2,a5,a00 <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 95c:	07800793          	li	a5,120
 960:	faf612e3          	bne	a2,a5,904 <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
 964:	008b8913          	addi	s2,s7,8
 968:	00000693          	li	a3,0
 96c:	01000613          	li	a2,16
 970:	000ba583          	lw	a1,0(s7)
 974:	000b0513          	mv	a0,s6
 978:	d61ff0ef          	jal	6d8 <printint>
        i += 2;
 97c:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 980:	00090b93          	mv	s7,s2
      state = 0;
 984:	00000993          	li	s3,0
        i += 2;
 988:	eb5ff06f          	j	83c <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 98c:	008b8913          	addi	s2,s7,8
 990:	00100693          	li	a3,1
 994:	00a00613          	li	a2,10
 998:	000ba583          	lw	a1,0(s7)
 99c:	000b0513          	mv	a0,s6
 9a0:	d39ff0ef          	jal	6d8 <printint>
        i += 2;
 9a4:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 9a8:	00090b93          	mv	s7,s2
      state = 0;
 9ac:	00000993          	li	s3,0
        i += 2;
 9b0:	e8dff06f          	j	83c <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
 9b4:	008b8913          	addi	s2,s7,8
 9b8:	00000693          	li	a3,0
 9bc:	00a00613          	li	a2,10
 9c0:	000ba583          	lw	a1,0(s7)
 9c4:	000b0513          	mv	a0,s6
 9c8:	d11ff0ef          	jal	6d8 <printint>
 9cc:	00090b93          	mv	s7,s2
      state = 0;
 9d0:	00000993          	li	s3,0
 9d4:	e69ff06f          	j	83c <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9d8:	008b8913          	addi	s2,s7,8
 9dc:	00000693          	li	a3,0
 9e0:	00a00613          	li	a2,10
 9e4:	000ba583          	lw	a1,0(s7)
 9e8:	000b0513          	mv	a0,s6
 9ec:	cedff0ef          	jal	6d8 <printint>
        i += 1;
 9f0:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 9f4:	00090b93          	mv	s7,s2
      state = 0;
 9f8:	00000993          	li	s3,0
        i += 1;
 9fc:	e41ff06f          	j	83c <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a00:	008b8913          	addi	s2,s7,8
 a04:	00000693          	li	a3,0
 a08:	00a00613          	li	a2,10
 a0c:	000ba583          	lw	a1,0(s7)
 a10:	000b0513          	mv	a0,s6
 a14:	cc5ff0ef          	jal	6d8 <printint>
        i += 2;
 a18:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a1c:	00090b93          	mv	s7,s2
      state = 0;
 a20:	00000993          	li	s3,0
        i += 2;
 a24:	e19ff06f          	j	83c <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
 a28:	008b8913          	addi	s2,s7,8
 a2c:	00000693          	li	a3,0
 a30:	01000613          	li	a2,16
 a34:	000ba583          	lw	a1,0(s7)
 a38:	000b0513          	mv	a0,s6
 a3c:	c9dff0ef          	jal	6d8 <printint>
 a40:	00090b93          	mv	s7,s2
      state = 0;
 a44:	00000993          	li	s3,0
 a48:	df5ff06f          	j	83c <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a4c:	008b8913          	addi	s2,s7,8
 a50:	00000693          	li	a3,0
 a54:	01000613          	li	a2,16
 a58:	000ba583          	lw	a1,0(s7)
 a5c:	000b0513          	mv	a0,s6
 a60:	c79ff0ef          	jal	6d8 <printint>
        i += 1;
 a64:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a68:	00090b93          	mv	s7,s2
      state = 0;
 a6c:	00000993          	li	s3,0
        i += 1;
 a70:	dcdff06f          	j	83c <vprintf+0x78>
 a74:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 a78:	008b8d13          	addi	s10,s7,8
 a7c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a80:	03000593          	li	a1,48
 a84:	000b0513          	mv	a0,s6
 a88:	c21ff0ef          	jal	6a8 <putc>
  putc(fd, 'x');
 a8c:	07800593          	li	a1,120
 a90:	000b0513          	mv	a0,s6
 a94:	c15ff0ef          	jal	6a8 <putc>
 a98:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a9c:	00000b97          	auipc	s7,0x0
 aa0:	394b8b93          	addi	s7,s7,916 # e30 <digits>
 aa4:	03c9d793          	srli	a5,s3,0x3c
 aa8:	00fb87b3          	add	a5,s7,a5
 aac:	0007c583          	lbu	a1,0(a5)
 ab0:	000b0513          	mv	a0,s6
 ab4:	bf5ff0ef          	jal	6a8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 ab8:	00499993          	slli	s3,s3,0x4
 abc:	fff9091b          	addiw	s2,s2,-1
 ac0:	fe0912e3          	bnez	s2,aa4 <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
 ac4:	000d0b93          	mv	s7,s10
      state = 0;
 ac8:	00000993          	li	s3,0
 acc:	00013d03          	ld	s10,0(sp)
 ad0:	d6dff06f          	j	83c <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
 ad4:	008b8993          	addi	s3,s7,8
 ad8:	000bb903          	ld	s2,0(s7)
 adc:	02090663          	beqz	s2,b08 <vprintf+0x344>
        for(; *s; s++)
 ae0:	00094583          	lbu	a1,0(s2)
 ae4:	02058a63          	beqz	a1,b18 <vprintf+0x354>
          putc(fd, *s);
 ae8:	000b0513          	mv	a0,s6
 aec:	bbdff0ef          	jal	6a8 <putc>
        for(; *s; s++)
 af0:	00190913          	addi	s2,s2,1
 af4:	00094583          	lbu	a1,0(s2)
 af8:	fe0598e3          	bnez	a1,ae8 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 afc:	00098b93          	mv	s7,s3
      state = 0;
 b00:	00000993          	li	s3,0
 b04:	d39ff06f          	j	83c <vprintf+0x78>
          s = "(null)";
 b08:	00000917          	auipc	s2,0x0
 b0c:	32090913          	addi	s2,s2,800 # e28 <malloc+0x18c>
        for(; *s; s++)
 b10:	02800593          	li	a1,40
 b14:	fd5ff06f          	j	ae8 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 b18:	00098b93          	mv	s7,s3
      state = 0;
 b1c:	00000993          	li	s3,0
 b20:	d1dff06f          	j	83c <vprintf+0x78>
 b24:	04813483          	ld	s1,72(sp)
 b28:	03813983          	ld	s3,56(sp)
 b2c:	03013a03          	ld	s4,48(sp)
 b30:	02813a83          	ld	s5,40(sp)
 b34:	02013b03          	ld	s6,32(sp)
 b38:	01813b83          	ld	s7,24(sp)
 b3c:	01013c03          	ld	s8,16(sp)
 b40:	00813c83          	ld	s9,8(sp)
    }
  }
}
 b44:	05813083          	ld	ra,88(sp)
 b48:	05013403          	ld	s0,80(sp)
 b4c:	04013903          	ld	s2,64(sp)
 b50:	06010113          	addi	sp,sp,96
 b54:	00008067          	ret

0000000000000b58 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b58:	fb010113          	addi	sp,sp,-80
 b5c:	00113c23          	sd	ra,24(sp)
 b60:	00813823          	sd	s0,16(sp)
 b64:	02010413          	addi	s0,sp,32
 b68:	00c43023          	sd	a2,0(s0)
 b6c:	00d43423          	sd	a3,8(s0)
 b70:	00e43823          	sd	a4,16(s0)
 b74:	00f43c23          	sd	a5,24(s0)
 b78:	03043023          	sd	a6,32(s0)
 b7c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b80:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b84:	00040613          	mv	a2,s0
 b88:	c3dff0ef          	jal	7c4 <vprintf>
}
 b8c:	01813083          	ld	ra,24(sp)
 b90:	01013403          	ld	s0,16(sp)
 b94:	05010113          	addi	sp,sp,80
 b98:	00008067          	ret

0000000000000b9c <printf>:

void
printf(const char *fmt, ...)
{
 b9c:	fa010113          	addi	sp,sp,-96
 ba0:	00113c23          	sd	ra,24(sp)
 ba4:	00813823          	sd	s0,16(sp)
 ba8:	02010413          	addi	s0,sp,32
 bac:	00b43423          	sd	a1,8(s0)
 bb0:	00c43823          	sd	a2,16(s0)
 bb4:	00d43c23          	sd	a3,24(s0)
 bb8:	02e43023          	sd	a4,32(s0)
 bbc:	02f43423          	sd	a5,40(s0)
 bc0:	03043823          	sd	a6,48(s0)
 bc4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 bc8:	00840613          	addi	a2,s0,8
 bcc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 bd0:	00050593          	mv	a1,a0
 bd4:	00100513          	li	a0,1
 bd8:	bedff0ef          	jal	7c4 <vprintf>
}
 bdc:	01813083          	ld	ra,24(sp)
 be0:	01013403          	ld	s0,16(sp)
 be4:	06010113          	addi	sp,sp,96
 be8:	00008067          	ret

0000000000000bec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bec:	ff010113          	addi	sp,sp,-16
 bf0:	00813423          	sd	s0,8(sp)
 bf4:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bf8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bfc:	00000797          	auipc	a5,0x0
 c00:	4047b783          	ld	a5,1028(a5) # 1000 <freep>
 c04:	0400006f          	j	c44 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c08:	00862703          	lw	a4,8(a2)
 c0c:	00b7073b          	addw	a4,a4,a1
 c10:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c14:	0007b703          	ld	a4,0(a5)
 c18:	00073603          	ld	a2,0(a4)
 c1c:	0500006f          	j	c6c <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 c20:	ff852703          	lw	a4,-8(a0)
 c24:	00c7073b          	addw	a4,a4,a2
 c28:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c2c:	ff053683          	ld	a3,-16(a0)
 c30:	0540006f          	j	c84 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c34:	0007b703          	ld	a4,0(a5)
 c38:	00e7e463          	bltu	a5,a4,c40 <free+0x54>
 c3c:	00e6ec63          	bltu	a3,a4,c54 <free+0x68>
{
 c40:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c44:	fed7f8e3          	bgeu	a5,a3,c34 <free+0x48>
 c48:	0007b703          	ld	a4,0(a5)
 c4c:	00e6e463          	bltu	a3,a4,c54 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c50:	fee7e8e3          	bltu	a5,a4,c40 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 c54:	ff852583          	lw	a1,-8(a0)
 c58:	0007b603          	ld	a2,0(a5)
 c5c:	02059813          	slli	a6,a1,0x20
 c60:	01c85713          	srli	a4,a6,0x1c
 c64:	00e68733          	add	a4,a3,a4
 c68:	fae600e3          	beq	a2,a4,c08 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 c6c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c70:	0087a603          	lw	a2,8(a5)
 c74:	02061593          	slli	a1,a2,0x20
 c78:	01c5d713          	srli	a4,a1,0x1c
 c7c:	00e78733          	add	a4,a5,a4
 c80:	fae680e3          	beq	a3,a4,c20 <free+0x34>
    p->s.ptr = bp->s.ptr;
 c84:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c88:	00000717          	auipc	a4,0x0
 c8c:	36f73c23          	sd	a5,888(a4) # 1000 <freep>
}
 c90:	00813403          	ld	s0,8(sp)
 c94:	01010113          	addi	sp,sp,16
 c98:	00008067          	ret

0000000000000c9c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c9c:	fc010113          	addi	sp,sp,-64
 ca0:	02113c23          	sd	ra,56(sp)
 ca4:	02813823          	sd	s0,48(sp)
 ca8:	02913423          	sd	s1,40(sp)
 cac:	01313c23          	sd	s3,24(sp)
 cb0:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cb4:	02051493          	slli	s1,a0,0x20
 cb8:	0204d493          	srli	s1,s1,0x20
 cbc:	00f48493          	addi	s1,s1,15
 cc0:	0044d493          	srli	s1,s1,0x4
 cc4:	0014899b          	addiw	s3,s1,1
 cc8:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
 ccc:	00000517          	auipc	a0,0x0
 cd0:	33453503          	ld	a0,820(a0) # 1000 <freep>
 cd4:	04050663          	beqz	a0,d20 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cd8:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cdc:	0087a703          	lw	a4,8(a5)
 ce0:	0c977c63          	bgeu	a4,s1,db8 <malloc+0x11c>
 ce4:	03213023          	sd	s2,32(sp)
 ce8:	01413823          	sd	s4,16(sp)
 cec:	01513423          	sd	s5,8(sp)
 cf0:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
 cf4:	00098a13          	mv	s4,s3
 cf8:	0009871b          	sext.w	a4,s3
 cfc:	000016b7          	lui	a3,0x1
 d00:	00d77463          	bgeu	a4,a3,d08 <malloc+0x6c>
 d04:	00001a37          	lui	s4,0x1
 d08:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 d0c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d10:	00000917          	auipc	s2,0x0
 d14:	2f090913          	addi	s2,s2,752 # 1000 <freep>
  if(p == (char*)-1)
 d18:	fff00a93          	li	s5,-1
 d1c:	05c0006f          	j	d78 <malloc+0xdc>
 d20:	03213023          	sd	s2,32(sp)
 d24:	01413823          	sd	s4,16(sp)
 d28:	01513423          	sd	s5,8(sp)
 d2c:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 d30:	00000797          	auipc	a5,0x0
 d34:	2e078793          	addi	a5,a5,736 # 1010 <base>
 d38:	00000717          	auipc	a4,0x0
 d3c:	2cf73423          	sd	a5,712(a4) # 1000 <freep>
 d40:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 d44:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 d48:	fadff06f          	j	cf4 <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
 d4c:	0007b703          	ld	a4,0(a5)
 d50:	00e53023          	sd	a4,0(a0)
 d54:	0800006f          	j	dd4 <malloc+0x138>
  hp->s.size = nu;
 d58:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d5c:	01050513          	addi	a0,a0,16
 d60:	e8dff0ef          	jal	bec <free>
  return freep;
 d64:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 d68:	08050863          	beqz	a0,df8 <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d6c:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d70:	0087a703          	lw	a4,8(a5)
 d74:	02977a63          	bgeu	a4,s1,da8 <malloc+0x10c>
    if(p == freep)
 d78:	00093703          	ld	a4,0(s2)
 d7c:	00078513          	mv	a0,a5
 d80:	fef716e3          	bne	a4,a5,d6c <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
 d84:	000a0513          	mv	a0,s4
 d88:	8fdff0ef          	jal	684 <sbrk>
  if(p == (char*)-1)
 d8c:	fd5516e3          	bne	a0,s5,d58 <malloc+0xbc>
        return 0;
 d90:	00000513          	li	a0,0
 d94:	02013903          	ld	s2,32(sp)
 d98:	01013a03          	ld	s4,16(sp)
 d9c:	00813a83          	ld	s5,8(sp)
 da0:	00013b03          	ld	s6,0(sp)
 da4:	03c0006f          	j	de0 <malloc+0x144>
 da8:	02013903          	ld	s2,32(sp)
 dac:	01013a03          	ld	s4,16(sp)
 db0:	00813a83          	ld	s5,8(sp)
 db4:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
 db8:	f8e48ae3          	beq	s1,a4,d4c <malloc+0xb0>
        p->s.size -= nunits;
 dbc:	4137073b          	subw	a4,a4,s3
 dc0:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 dc4:	02071693          	slli	a3,a4,0x20
 dc8:	01c6d713          	srli	a4,a3,0x1c
 dcc:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 dd0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 dd4:	00000717          	auipc	a4,0x0
 dd8:	22a73623          	sd	a0,556(a4) # 1000 <freep>
      return (void*)(p + 1);
 ddc:	01078513          	addi	a0,a5,16
  }
}
 de0:	03813083          	ld	ra,56(sp)
 de4:	03013403          	ld	s0,48(sp)
 de8:	02813483          	ld	s1,40(sp)
 dec:	01813983          	ld	s3,24(sp)
 df0:	04010113          	addi	sp,sp,64
 df4:	00008067          	ret
 df8:	02013903          	ld	s2,32(sp)
 dfc:	01013a03          	ld	s4,16(sp)
 e00:	00813a83          	ld	s5,8(sp)
 e04:	00013b03          	ld	s6,0(sp)
 e08:	fd9ff06f          	j	de0 <malloc+0x144>
