
user/_pingpong:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char **argv)
{
   0:	fd010113          	addi	sp,sp,-48
   4:	02113423          	sd	ra,40(sp)
   8:	02813023          	sd	s0,32(sp)
   c:	03010413          	addi	s0,sp,48
	int child;

	char parent;
	char child_char;

	if(pipe(parent_fd) == -1)
  10:	fe840513          	addi	a0,s0,-24
  14:	514000ef          	jal	528 <pipe>
  18:	fff00793          	li	a5,-1
  1c:	08f50663          	beq	a0,a5,a8 <main+0xa8>
	{
		fprintf(2, "Pipe failed\n");
    	exit(1);
	}

	if(pipe(child_fd) == -1)
  20:	fe040513          	addi	a0,s0,-32
  24:	504000ef          	jal	528 <pipe>
  28:	fff00793          	li	a5,-1
  2c:	08f50a63          	beq	a0,a5,c0 <main+0xc0>
	{
		fprintf(2, "Pipe failed\n");
    	exit(1);
	}

	child = fork();
  30:	4d4000ef          	jal	504 <fork>

	
	if(child == 0)
  34:	0a050263          	beqz	a0,d8 <main+0xd8>
		write(child_fd[1], &child_char, 1);
		close(child_fd[1]);
		exit(0);
	}
	else{
		parent = 'p';
  38:	07000793          	li	a5,112
  3c:	fcf40fa3          	sb	a5,-33(s0)

		close(parent_fd[0]);
  40:	fe842503          	lw	a0,-24(s0)
  44:	508000ef          	jal	54c <close>
		close(child_fd[1]);
  48:	fe442503          	lw	a0,-28(s0)
  4c:	500000ef          	jal	54c <close>

		write(parent_fd[1], &parent, 1);
  50:	00100613          	li	a2,1
  54:	fdf40593          	addi	a1,s0,-33
  58:	fec42503          	lw	a0,-20(s0)
  5c:	4e4000ef          	jal	540 <write>
		close(parent_fd[1]);
  60:	fec42503          	lw	a0,-20(s0)
  64:	4e8000ef          	jal	54c <close>

		read(child_fd[0], &child_char, 1);
  68:	00100613          	li	a2,1
  6c:	fde40593          	addi	a1,s0,-34
  70:	fe042503          	lw	a0,-32(s0)
  74:	4c0000ef          	jal	534 <read>
		printf("%d: received pong \n", getpid());
  78:	558000ef          	jal	5d0 <getpid>
  7c:	00050593          	mv	a1,a0
  80:	00001517          	auipc	a0,0x1
  84:	d2050513          	addi	a0,a0,-736 # da0 <malloc+0x1ac>
  88:	26d000ef          	jal	af4 <printf>

		close(child_fd[0]);
  8c:	fe042503          	lw	a0,-32(s0)
  90:	4bc000ef          	jal	54c <close>

	}

	return 0;

  94:	00000513          	li	a0,0
  98:	02813083          	ld	ra,40(sp)
  9c:	02013403          	ld	s0,32(sp)
  a0:	03010113          	addi	sp,sp,48
  a4:	00008067          	ret
		fprintf(2, "Pipe failed\n");
  a8:	00001597          	auipc	a1,0x1
  ac:	cc858593          	addi	a1,a1,-824 # d70 <malloc+0x17c>
  b0:	00200513          	li	a0,2
  b4:	1fd000ef          	jal	ab0 <fprintf>
    	exit(1);
  b8:	00100513          	li	a0,1
  bc:	454000ef          	jal	510 <exit>
		fprintf(2, "Pipe failed\n");
  c0:	00001597          	auipc	a1,0x1
  c4:	cb058593          	addi	a1,a1,-848 # d70 <malloc+0x17c>
  c8:	00200513          	li	a0,2
  cc:	1e5000ef          	jal	ab0 <fprintf>
    	exit(1);
  d0:	00100513          	li	a0,1
  d4:	43c000ef          	jal	510 <exit>
		child_char = 'c';
  d8:	06300793          	li	a5,99
  dc:	fcf40f23          	sb	a5,-34(s0)
		close(parent_fd[1]); 	//close writting end of the pipe
  e0:	fec42503          	lw	a0,-20(s0)
  e4:	468000ef          	jal	54c <close>
		close(child_fd[0]); 	//close reading end of the pipe
  e8:	fe042503          	lw	a0,-32(s0)
  ec:	460000ef          	jal	54c <close>
	 	read(parent_fd[0], &parent, 1); //read from parent
  f0:	00100613          	li	a2,1
  f4:	fdf40593          	addi	a1,s0,-33
  f8:	fe842503          	lw	a0,-24(s0)
  fc:	438000ef          	jal	534 <read>
		printf("%d: received ping \n", getpid());
 100:	4d0000ef          	jal	5d0 <getpid>
 104:	00050593          	mv	a1,a0
 108:	00001517          	auipc	a0,0x1
 10c:	c8050513          	addi	a0,a0,-896 # d88 <malloc+0x194>
 110:	1e5000ef          	jal	af4 <printf>
		close(parent_fd[0]); 	//after reading
 114:	fe842503          	lw	a0,-24(s0)
 118:	434000ef          	jal	54c <close>
		write(child_fd[1], &child_char, 1);
 11c:	00100613          	li	a2,1
 120:	fde40593          	addi	a1,s0,-34
 124:	fe442503          	lw	a0,-28(s0)
 128:	418000ef          	jal	540 <write>
		close(child_fd[1]);
 12c:	fe442503          	lw	a0,-28(s0)
 130:	41c000ef          	jal	54c <close>
		exit(0);
 134:	00000513          	li	a0,0
 138:	3d8000ef          	jal	510 <exit>

000000000000013c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 13c:	ff010113          	addi	sp,sp,-16
 140:	00113423          	sd	ra,8(sp)
 144:	00813023          	sd	s0,0(sp)
 148:	01010413          	addi	s0,sp,16
  extern int main();
  main();
 14c:	eb5ff0ef          	jal	0 <main>
  exit(0);
 150:	00000513          	li	a0,0
 154:	3bc000ef          	jal	510 <exit>

0000000000000158 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 158:	ff010113          	addi	sp,sp,-16
 15c:	00813423          	sd	s0,8(sp)
 160:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 164:	00050793          	mv	a5,a0
 168:	00158593          	addi	a1,a1,1
 16c:	00178793          	addi	a5,a5,1
 170:	fff5c703          	lbu	a4,-1(a1)
 174:	fee78fa3          	sb	a4,-1(a5)
 178:	fe0718e3          	bnez	a4,168 <strcpy+0x10>
    ;
  return os;
}
 17c:	00813403          	ld	s0,8(sp)
 180:	01010113          	addi	sp,sp,16
 184:	00008067          	ret

0000000000000188 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 188:	ff010113          	addi	sp,sp,-16
 18c:	00813423          	sd	s0,8(sp)
 190:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
 194:	00054783          	lbu	a5,0(a0)
 198:	00078e63          	beqz	a5,1b4 <strcmp+0x2c>
 19c:	0005c703          	lbu	a4,0(a1)
 1a0:	00f71a63          	bne	a4,a5,1b4 <strcmp+0x2c>
    p++, q++;
 1a4:	00150513          	addi	a0,a0,1
 1a8:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	fe0796e3          	bnez	a5,19c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 1b4:	0005c503          	lbu	a0,0(a1)
}
 1b8:	40a7853b          	subw	a0,a5,a0
 1bc:	00813403          	ld	s0,8(sp)
 1c0:	01010113          	addi	sp,sp,16
 1c4:	00008067          	ret

00000000000001c8 <strlen>:

uint
strlen(const char *s)
{
 1c8:	ff010113          	addi	sp,sp,-16
 1cc:	00813423          	sd	s0,8(sp)
 1d0:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1d4:	00054783          	lbu	a5,0(a0)
 1d8:	02078863          	beqz	a5,208 <strlen+0x40>
 1dc:	00150513          	addi	a0,a0,1
 1e0:	00050793          	mv	a5,a0
 1e4:	00078693          	mv	a3,a5
 1e8:	00178793          	addi	a5,a5,1
 1ec:	fff7c703          	lbu	a4,-1(a5)
 1f0:	fe071ae3          	bnez	a4,1e4 <strlen+0x1c>
 1f4:	40a6853b          	subw	a0,a3,a0
 1f8:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
 1fc:	00813403          	ld	s0,8(sp)
 200:	01010113          	addi	sp,sp,16
 204:	00008067          	ret
  for(n = 0; s[n]; n++)
 208:	00000513          	li	a0,0
 20c:	ff1ff06f          	j	1fc <strlen+0x34>

0000000000000210 <memset>:

void*
memset(void *dst, int c, uint n)
{
 210:	ff010113          	addi	sp,sp,-16
 214:	00813423          	sd	s0,8(sp)
 218:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 21c:	02060063          	beqz	a2,23c <memset+0x2c>
 220:	00050793          	mv	a5,a0
 224:	02061613          	slli	a2,a2,0x20
 228:	02065613          	srli	a2,a2,0x20
 22c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 230:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 234:	00178793          	addi	a5,a5,1
 238:	fee79ce3          	bne	a5,a4,230 <memset+0x20>
  }
  return dst;
}
 23c:	00813403          	ld	s0,8(sp)
 240:	01010113          	addi	sp,sp,16
 244:	00008067          	ret

0000000000000248 <strchr>:

char*
strchr(const char *s, char c)
{
 248:	ff010113          	addi	sp,sp,-16
 24c:	00813423          	sd	s0,8(sp)
 250:	01010413          	addi	s0,sp,16
  for(; *s; s++)
 254:	00054783          	lbu	a5,0(a0)
 258:	02078263          	beqz	a5,27c <strchr+0x34>
    if(*s == c)
 25c:	00f58a63          	beq	a1,a5,270 <strchr+0x28>
  for(; *s; s++)
 260:	00150513          	addi	a0,a0,1
 264:	00054783          	lbu	a5,0(a0)
 268:	fe079ae3          	bnez	a5,25c <strchr+0x14>
      return (char*)s;
  return 0;
 26c:	00000513          	li	a0,0
}
 270:	00813403          	ld	s0,8(sp)
 274:	01010113          	addi	sp,sp,16
 278:	00008067          	ret
  return 0;
 27c:	00000513          	li	a0,0
 280:	ff1ff06f          	j	270 <strchr+0x28>

0000000000000284 <gets>:

char*
gets(char *buf, int max)
{
 284:	fa010113          	addi	sp,sp,-96
 288:	04113c23          	sd	ra,88(sp)
 28c:	04813823          	sd	s0,80(sp)
 290:	04913423          	sd	s1,72(sp)
 294:	05213023          	sd	s2,64(sp)
 298:	03313c23          	sd	s3,56(sp)
 29c:	03413823          	sd	s4,48(sp)
 2a0:	03513423          	sd	s5,40(sp)
 2a4:	03613023          	sd	s6,32(sp)
 2a8:	01713c23          	sd	s7,24(sp)
 2ac:	06010413          	addi	s0,sp,96
 2b0:	00050b93          	mv	s7,a0
 2b4:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b8:	00050913          	mv	s2,a0
 2bc:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2c0:	00a00a93          	li	s5,10
 2c4:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 2c8:	00048993          	mv	s3,s1
 2cc:	0014849b          	addiw	s1,s1,1
 2d0:	0344dc63          	bge	s1,s4,308 <gets+0x84>
    cc = read(0, &c, 1);
 2d4:	00100613          	li	a2,1
 2d8:	faf40593          	addi	a1,s0,-81
 2dc:	00000513          	li	a0,0
 2e0:	254000ef          	jal	534 <read>
    if(cc < 1)
 2e4:	02a05263          	blez	a0,308 <gets+0x84>
    buf[i++] = c;
 2e8:	faf44783          	lbu	a5,-81(s0)
 2ec:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2f0:	01578a63          	beq	a5,s5,304 <gets+0x80>
 2f4:	00190913          	addi	s2,s2,1
 2f8:	fd6798e3          	bne	a5,s6,2c8 <gets+0x44>
    buf[i++] = c;
 2fc:	00048993          	mv	s3,s1
 300:	0080006f          	j	308 <gets+0x84>
 304:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 308:	013b89b3          	add	s3,s7,s3
 30c:	00098023          	sb	zero,0(s3)
  return buf;
}
 310:	000b8513          	mv	a0,s7
 314:	05813083          	ld	ra,88(sp)
 318:	05013403          	ld	s0,80(sp)
 31c:	04813483          	ld	s1,72(sp)
 320:	04013903          	ld	s2,64(sp)
 324:	03813983          	ld	s3,56(sp)
 328:	03013a03          	ld	s4,48(sp)
 32c:	02813a83          	ld	s5,40(sp)
 330:	02013b03          	ld	s6,32(sp)
 334:	01813b83          	ld	s7,24(sp)
 338:	06010113          	addi	sp,sp,96
 33c:	00008067          	ret

0000000000000340 <stat>:

int
stat(const char *n, struct stat *st)
{
 340:	fe010113          	addi	sp,sp,-32
 344:	00113c23          	sd	ra,24(sp)
 348:	00813823          	sd	s0,16(sp)
 34c:	01213023          	sd	s2,0(sp)
 350:	02010413          	addi	s0,sp,32
 354:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 358:	00000593          	li	a1,0
 35c:	214000ef          	jal	570 <open>
  if(fd < 0)
 360:	02054e63          	bltz	a0,39c <stat+0x5c>
 364:	00913423          	sd	s1,8(sp)
 368:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 36c:	00090593          	mv	a1,s2
 370:	224000ef          	jal	594 <fstat>
 374:	00050913          	mv	s2,a0
  close(fd);
 378:	00048513          	mv	a0,s1
 37c:	1d0000ef          	jal	54c <close>
  return r;
 380:	00813483          	ld	s1,8(sp)
}
 384:	00090513          	mv	a0,s2
 388:	01813083          	ld	ra,24(sp)
 38c:	01013403          	ld	s0,16(sp)
 390:	00013903          	ld	s2,0(sp)
 394:	02010113          	addi	sp,sp,32
 398:	00008067          	ret
    return -1;
 39c:	fff00913          	li	s2,-1
 3a0:	fe5ff06f          	j	384 <stat+0x44>

00000000000003a4 <atoi>:

int
atoi(const char *s)
{
 3a4:	ff010113          	addi	sp,sp,-16
 3a8:	00813423          	sd	s0,8(sp)
 3ac:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3b0:	00054683          	lbu	a3,0(a0)
 3b4:	fd06879b          	addiw	a5,a3,-48
 3b8:	0ff7f793          	zext.b	a5,a5
 3bc:	00900613          	li	a2,9
 3c0:	04f66063          	bltu	a2,a5,400 <atoi+0x5c>
 3c4:	00050713          	mv	a4,a0
  n = 0;
 3c8:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 3cc:	00170713          	addi	a4,a4,1
 3d0:	0025179b          	slliw	a5,a0,0x2
 3d4:	00a787bb          	addw	a5,a5,a0
 3d8:	0017979b          	slliw	a5,a5,0x1
 3dc:	00d787bb          	addw	a5,a5,a3
 3e0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3e4:	00074683          	lbu	a3,0(a4)
 3e8:	fd06879b          	addiw	a5,a3,-48
 3ec:	0ff7f793          	zext.b	a5,a5
 3f0:	fcf67ee3          	bgeu	a2,a5,3cc <atoi+0x28>
  return n;
}
 3f4:	00813403          	ld	s0,8(sp)
 3f8:	01010113          	addi	sp,sp,16
 3fc:	00008067          	ret
  n = 0;
 400:	00000513          	li	a0,0
 404:	ff1ff06f          	j	3f4 <atoi+0x50>

0000000000000408 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 408:	ff010113          	addi	sp,sp,-16
 40c:	00813423          	sd	s0,8(sp)
 410:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 414:	02b57c63          	bgeu	a0,a1,44c <memmove+0x44>
    while(n-- > 0)
 418:	02c05463          	blez	a2,440 <memmove+0x38>
 41c:	02061613          	slli	a2,a2,0x20
 420:	02065613          	srli	a2,a2,0x20
 424:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 428:	00050713          	mv	a4,a0
      *dst++ = *src++;
 42c:	00158593          	addi	a1,a1,1
 430:	00170713          	addi	a4,a4,1
 434:	fff5c683          	lbu	a3,-1(a1)
 438:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 43c:	fef718e3          	bne	a4,a5,42c <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 440:	00813403          	ld	s0,8(sp)
 444:	01010113          	addi	sp,sp,16
 448:	00008067          	ret
    dst += n;
 44c:	00c50733          	add	a4,a0,a2
    src += n;
 450:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 454:	fec056e3          	blez	a2,440 <memmove+0x38>
 458:	fff6079b          	addiw	a5,a2,-1
 45c:	02079793          	slli	a5,a5,0x20
 460:	0207d793          	srli	a5,a5,0x20
 464:	fff7c793          	not	a5,a5
 468:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 46c:	fff58593          	addi	a1,a1,-1
 470:	fff70713          	addi	a4,a4,-1
 474:	0005c683          	lbu	a3,0(a1)
 478:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 47c:	fee798e3          	bne	a5,a4,46c <memmove+0x64>
 480:	fc1ff06f          	j	440 <memmove+0x38>

0000000000000484 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 484:	ff010113          	addi	sp,sp,-16
 488:	00813423          	sd	s0,8(sp)
 48c:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 490:	04060463          	beqz	a2,4d8 <memcmp+0x54>
 494:	fff6069b          	addiw	a3,a2,-1
 498:	02069693          	slli	a3,a3,0x20
 49c:	0206d693          	srli	a3,a3,0x20
 4a0:	00168693          	addi	a3,a3,1
 4a4:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 4a8:	00054783          	lbu	a5,0(a0)
 4ac:	0005c703          	lbu	a4,0(a1)
 4b0:	00e79c63          	bne	a5,a4,4c8 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 4b4:	00150513          	addi	a0,a0,1
    p2++;
 4b8:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
 4bc:	fed516e3          	bne	a0,a3,4a8 <memcmp+0x24>
  }
  return 0;
 4c0:	00000513          	li	a0,0
 4c4:	0080006f          	j	4cc <memcmp+0x48>
      return *p1 - *p2;
 4c8:	40e7853b          	subw	a0,a5,a4
}
 4cc:	00813403          	ld	s0,8(sp)
 4d0:	01010113          	addi	sp,sp,16
 4d4:	00008067          	ret
  return 0;
 4d8:	00000513          	li	a0,0
 4dc:	ff1ff06f          	j	4cc <memcmp+0x48>

00000000000004e0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4e0:	ff010113          	addi	sp,sp,-16
 4e4:	00113423          	sd	ra,8(sp)
 4e8:	00813023          	sd	s0,0(sp)
 4ec:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
 4f0:	f19ff0ef          	jal	408 <memmove>
}
 4f4:	00813083          	ld	ra,8(sp)
 4f8:	00013403          	ld	s0,0(sp)
 4fc:	01010113          	addi	sp,sp,16
 500:	00008067          	ret

0000000000000504 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 504:	00100893          	li	a7,1
 ecall
 508:	00000073          	ecall
 ret
 50c:	00008067          	ret

0000000000000510 <exit>:
.global exit
exit:
 li a7, SYS_exit
 510:	00200893          	li	a7,2
 ecall
 514:	00000073          	ecall
 ret
 518:	00008067          	ret

000000000000051c <wait>:
.global wait
wait:
 li a7, SYS_wait
 51c:	00300893          	li	a7,3
 ecall
 520:	00000073          	ecall
 ret
 524:	00008067          	ret

0000000000000528 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 528:	00400893          	li	a7,4
 ecall
 52c:	00000073          	ecall
 ret
 530:	00008067          	ret

0000000000000534 <read>:
.global read
read:
 li a7, SYS_read
 534:	00500893          	li	a7,5
 ecall
 538:	00000073          	ecall
 ret
 53c:	00008067          	ret

0000000000000540 <write>:
.global write
write:
 li a7, SYS_write
 540:	01000893          	li	a7,16
 ecall
 544:	00000073          	ecall
 ret
 548:	00008067          	ret

000000000000054c <close>:
.global close
close:
 li a7, SYS_close
 54c:	01500893          	li	a7,21
 ecall
 550:	00000073          	ecall
 ret
 554:	00008067          	ret

0000000000000558 <kill>:
.global kill
kill:
 li a7, SYS_kill
 558:	00600893          	li	a7,6
 ecall
 55c:	00000073          	ecall
 ret
 560:	00008067          	ret

0000000000000564 <exec>:
.global exec
exec:
 li a7, SYS_exec
 564:	00700893          	li	a7,7
 ecall
 568:	00000073          	ecall
 ret
 56c:	00008067          	ret

0000000000000570 <open>:
.global open
open:
 li a7, SYS_open
 570:	00f00893          	li	a7,15
 ecall
 574:	00000073          	ecall
 ret
 578:	00008067          	ret

000000000000057c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 57c:	01100893          	li	a7,17
 ecall
 580:	00000073          	ecall
 ret
 584:	00008067          	ret

0000000000000588 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 588:	01200893          	li	a7,18
 ecall
 58c:	00000073          	ecall
 ret
 590:	00008067          	ret

0000000000000594 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 594:	00800893          	li	a7,8
 ecall
 598:	00000073          	ecall
 ret
 59c:	00008067          	ret

00000000000005a0 <link>:
.global link
link:
 li a7, SYS_link
 5a0:	01300893          	li	a7,19
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	00008067          	ret

00000000000005ac <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ac:	01400893          	li	a7,20
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	00008067          	ret

00000000000005b8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5b8:	00900893          	li	a7,9
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	00008067          	ret

00000000000005c4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5c4:	00a00893          	li	a7,10
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	00008067          	ret

00000000000005d0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5d0:	00b00893          	li	a7,11
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	00008067          	ret

00000000000005dc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5dc:	00c00893          	li	a7,12
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	00008067          	ret

00000000000005e8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5e8:	00d00893          	li	a7,13
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	00008067          	ret

00000000000005f4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5f4:	00e00893          	li	a7,14
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	00008067          	ret

0000000000000600 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 600:	fe010113          	addi	sp,sp,-32
 604:	00113c23          	sd	ra,24(sp)
 608:	00813823          	sd	s0,16(sp)
 60c:	02010413          	addi	s0,sp,32
 610:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 614:	00100613          	li	a2,1
 618:	fef40593          	addi	a1,s0,-17
 61c:	f25ff0ef          	jal	540 <write>
}
 620:	01813083          	ld	ra,24(sp)
 624:	01013403          	ld	s0,16(sp)
 628:	02010113          	addi	sp,sp,32
 62c:	00008067          	ret

0000000000000630 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 630:	fc010113          	addi	sp,sp,-64
 634:	02113c23          	sd	ra,56(sp)
 638:	02813823          	sd	s0,48(sp)
 63c:	02913423          	sd	s1,40(sp)
 640:	04010413          	addi	s0,sp,64
 644:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 648:	00068463          	beqz	a3,650 <printint+0x20>
 64c:	0c05c263          	bltz	a1,710 <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 650:	0005859b          	sext.w	a1,a1
  neg = 0;
 654:	00000893          	li	a7,0
 658:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 65c:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 660:	0006061b          	sext.w	a2,a2
 664:	00000517          	auipc	a0,0x0
 668:	75c50513          	addi	a0,a0,1884 # dc0 <digits>
 66c:	00070813          	mv	a6,a4
 670:	0017071b          	addiw	a4,a4,1
 674:	02c5f7bb          	remuw	a5,a1,a2
 678:	02079793          	slli	a5,a5,0x20
 67c:	0207d793          	srli	a5,a5,0x20
 680:	00f507b3          	add	a5,a0,a5
 684:	0007c783          	lbu	a5,0(a5)
 688:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 68c:	0005879b          	sext.w	a5,a1
 690:	02c5d5bb          	divuw	a1,a1,a2
 694:	00168693          	addi	a3,a3,1
 698:	fcc7fae3          	bgeu	a5,a2,66c <printint+0x3c>
  if(neg)
 69c:	00088c63          	beqz	a7,6b4 <printint+0x84>
    buf[i++] = '-';
 6a0:	fd070793          	addi	a5,a4,-48
 6a4:	00878733          	add	a4,a5,s0
 6a8:	02d00793          	li	a5,45
 6ac:	fef70823          	sb	a5,-16(a4)
 6b0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6b4:	04e05463          	blez	a4,6fc <printint+0xcc>
 6b8:	03213023          	sd	s2,32(sp)
 6bc:	01313c23          	sd	s3,24(sp)
 6c0:	fc040793          	addi	a5,s0,-64
 6c4:	00e78933          	add	s2,a5,a4
 6c8:	fff78993          	addi	s3,a5,-1
 6cc:	00e989b3          	add	s3,s3,a4
 6d0:	fff7071b          	addiw	a4,a4,-1
 6d4:	02071713          	slli	a4,a4,0x20
 6d8:	02075713          	srli	a4,a4,0x20
 6dc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6e0:	fff94583          	lbu	a1,-1(s2)
 6e4:	00048513          	mv	a0,s1
 6e8:	f19ff0ef          	jal	600 <putc>
  while(--i >= 0)
 6ec:	fff90913          	addi	s2,s2,-1
 6f0:	ff3918e3          	bne	s2,s3,6e0 <printint+0xb0>
 6f4:	02013903          	ld	s2,32(sp)
 6f8:	01813983          	ld	s3,24(sp)
}
 6fc:	03813083          	ld	ra,56(sp)
 700:	03013403          	ld	s0,48(sp)
 704:	02813483          	ld	s1,40(sp)
 708:	04010113          	addi	sp,sp,64
 70c:	00008067          	ret
    x = -xx;
 710:	40b005bb          	negw	a1,a1
    neg = 1;
 714:	00100893          	li	a7,1
    x = -xx;
 718:	f41ff06f          	j	658 <printint+0x28>

000000000000071c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 71c:	fa010113          	addi	sp,sp,-96
 720:	04113c23          	sd	ra,88(sp)
 724:	04813823          	sd	s0,80(sp)
 728:	05213023          	sd	s2,64(sp)
 72c:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 730:	0005c903          	lbu	s2,0(a1)
 734:	36090463          	beqz	s2,a9c <vprintf+0x380>
 738:	04913423          	sd	s1,72(sp)
 73c:	03313c23          	sd	s3,56(sp)
 740:	03413823          	sd	s4,48(sp)
 744:	03513423          	sd	s5,40(sp)
 748:	03613023          	sd	s6,32(sp)
 74c:	01713c23          	sd	s7,24(sp)
 750:	01813823          	sd	s8,16(sp)
 754:	01913423          	sd	s9,8(sp)
 758:	00050b13          	mv	s6,a0
 75c:	00058a13          	mv	s4,a1
 760:	00060b93          	mv	s7,a2
  state = 0;
 764:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
 768:	00000493          	li	s1,0
 76c:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 770:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 774:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 778:	06c00c93          	li	s9,108
 77c:	02c0006f          	j	7a8 <vprintf+0x8c>
        putc(fd, c0);
 780:	00090593          	mv	a1,s2
 784:	000b0513          	mv	a0,s6
 788:	e79ff0ef          	jal	600 <putc>
 78c:	0080006f          	j	794 <vprintf+0x78>
    } else if(state == '%'){
 790:	03598663          	beq	s3,s5,7bc <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
 794:	0014849b          	addiw	s1,s1,1
 798:	00048713          	mv	a4,s1
 79c:	009a07b3          	add	a5,s4,s1
 7a0:	0007c903          	lbu	s2,0(a5)
 7a4:	2c090c63          	beqz	s2,a7c <vprintf+0x360>
    c0 = fmt[i] & 0xff;
 7a8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 7ac:	fe0992e3          	bnez	s3,790 <vprintf+0x74>
      if(c0 == '%'){
 7b0:	fd5798e3          	bne	a5,s5,780 <vprintf+0x64>
        state = '%';
 7b4:	00078993          	mv	s3,a5
 7b8:	fddff06f          	j	794 <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
 7bc:	00ea06b3          	add	a3,s4,a4
 7c0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 7c4:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 7c8:	00068663          	beqz	a3,7d4 <vprintf+0xb8>
 7cc:	00ea0733          	add	a4,s4,a4
 7d0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 7d4:	05878263          	beq	a5,s8,818 <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
 7d8:	07978263          	beq	a5,s9,83c <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 7dc:	07500713          	li	a4,117
 7e0:	12e78663          	beq	a5,a4,90c <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 7e4:	07800713          	li	a4,120
 7e8:	18e78c63          	beq	a5,a4,980 <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 7ec:	07000713          	li	a4,112
 7f0:	1ce78e63          	beq	a5,a4,9cc <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 7f4:	07300713          	li	a4,115
 7f8:	22e78a63          	beq	a5,a4,a2c <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 7fc:	02500713          	li	a4,37
 800:	04e79e63          	bne	a5,a4,85c <vprintf+0x140>
        putc(fd, '%');
 804:	02500593          	li	a1,37
 808:	000b0513          	mv	a0,s6
 80c:	df5ff0ef          	jal	600 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 810:	00000993          	li	s3,0
 814:	f81ff06f          	j	794 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
 818:	008b8913          	addi	s2,s7,8
 81c:	00100693          	li	a3,1
 820:	00a00613          	li	a2,10
 824:	000ba583          	lw	a1,0(s7)
 828:	000b0513          	mv	a0,s6
 82c:	e05ff0ef          	jal	630 <printint>
 830:	00090b93          	mv	s7,s2
      state = 0;
 834:	00000993          	li	s3,0
 838:	f5dff06f          	j	794 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
 83c:	06400793          	li	a5,100
 840:	02f68e63          	beq	a3,a5,87c <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 844:	06c00793          	li	a5,108
 848:	04f68e63          	beq	a3,a5,8a4 <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
 84c:	07500793          	li	a5,117
 850:	0ef68063          	beq	a3,a5,930 <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
 854:	07800793          	li	a5,120
 858:	14f68663          	beq	a3,a5,9a4 <vprintf+0x288>
        putc(fd, '%');
 85c:	02500593          	li	a1,37
 860:	000b0513          	mv	a0,s6
 864:	d9dff0ef          	jal	600 <putc>
        putc(fd, c0);
 868:	00090593          	mv	a1,s2
 86c:	000b0513          	mv	a0,s6
 870:	d91ff0ef          	jal	600 <putc>
      state = 0;
 874:	00000993          	li	s3,0
 878:	f1dff06f          	j	794 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 87c:	008b8913          	addi	s2,s7,8
 880:	00100693          	li	a3,1
 884:	00a00613          	li	a2,10
 888:	000ba583          	lw	a1,0(s7)
 88c:	000b0513          	mv	a0,s6
 890:	da1ff0ef          	jal	630 <printint>
        i += 1;
 894:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 898:	00090b93          	mv	s7,s2
      state = 0;
 89c:	00000993          	li	s3,0
        i += 1;
 8a0:	ef5ff06f          	j	794 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8a4:	06400793          	li	a5,100
 8a8:	02f60e63          	beq	a2,a5,8e4 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8ac:	07500793          	li	a5,117
 8b0:	0af60463          	beq	a2,a5,958 <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8b4:	07800793          	li	a5,120
 8b8:	faf612e3          	bne	a2,a5,85c <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8bc:	008b8913          	addi	s2,s7,8
 8c0:	00000693          	li	a3,0
 8c4:	01000613          	li	a2,16
 8c8:	000ba583          	lw	a1,0(s7)
 8cc:	000b0513          	mv	a0,s6
 8d0:	d61ff0ef          	jal	630 <printint>
        i += 2;
 8d4:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 8d8:	00090b93          	mv	s7,s2
      state = 0;
 8dc:	00000993          	li	s3,0
        i += 2;
 8e0:	eb5ff06f          	j	794 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8e4:	008b8913          	addi	s2,s7,8
 8e8:	00100693          	li	a3,1
 8ec:	00a00613          	li	a2,10
 8f0:	000ba583          	lw	a1,0(s7)
 8f4:	000b0513          	mv	a0,s6
 8f8:	d39ff0ef          	jal	630 <printint>
        i += 2;
 8fc:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 900:	00090b93          	mv	s7,s2
      state = 0;
 904:	00000993          	li	s3,0
        i += 2;
 908:	e8dff06f          	j	794 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
 90c:	008b8913          	addi	s2,s7,8
 910:	00000693          	li	a3,0
 914:	00a00613          	li	a2,10
 918:	000ba583          	lw	a1,0(s7)
 91c:	000b0513          	mv	a0,s6
 920:	d11ff0ef          	jal	630 <printint>
 924:	00090b93          	mv	s7,s2
      state = 0;
 928:	00000993          	li	s3,0
 92c:	e69ff06f          	j	794 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 930:	008b8913          	addi	s2,s7,8
 934:	00000693          	li	a3,0
 938:	00a00613          	li	a2,10
 93c:	000ba583          	lw	a1,0(s7)
 940:	000b0513          	mv	a0,s6
 944:	cedff0ef          	jal	630 <printint>
        i += 1;
 948:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 94c:	00090b93          	mv	s7,s2
      state = 0;
 950:	00000993          	li	s3,0
        i += 1;
 954:	e41ff06f          	j	794 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 958:	008b8913          	addi	s2,s7,8
 95c:	00000693          	li	a3,0
 960:	00a00613          	li	a2,10
 964:	000ba583          	lw	a1,0(s7)
 968:	000b0513          	mv	a0,s6
 96c:	cc5ff0ef          	jal	630 <printint>
        i += 2;
 970:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 974:	00090b93          	mv	s7,s2
      state = 0;
 978:	00000993          	li	s3,0
        i += 2;
 97c:	e19ff06f          	j	794 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
 980:	008b8913          	addi	s2,s7,8
 984:	00000693          	li	a3,0
 988:	01000613          	li	a2,16
 98c:	000ba583          	lw	a1,0(s7)
 990:	000b0513          	mv	a0,s6
 994:	c9dff0ef          	jal	630 <printint>
 998:	00090b93          	mv	s7,s2
      state = 0;
 99c:	00000993          	li	s3,0
 9a0:	df5ff06f          	j	794 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9a4:	008b8913          	addi	s2,s7,8
 9a8:	00000693          	li	a3,0
 9ac:	01000613          	li	a2,16
 9b0:	000ba583          	lw	a1,0(s7)
 9b4:	000b0513          	mv	a0,s6
 9b8:	c79ff0ef          	jal	630 <printint>
        i += 1;
 9bc:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 9c0:	00090b93          	mv	s7,s2
      state = 0;
 9c4:	00000993          	li	s3,0
        i += 1;
 9c8:	dcdff06f          	j	794 <vprintf+0x78>
 9cc:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 9d0:	008b8d13          	addi	s10,s7,8
 9d4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9d8:	03000593          	li	a1,48
 9dc:	000b0513          	mv	a0,s6
 9e0:	c21ff0ef          	jal	600 <putc>
  putc(fd, 'x');
 9e4:	07800593          	li	a1,120
 9e8:	000b0513          	mv	a0,s6
 9ec:	c15ff0ef          	jal	600 <putc>
 9f0:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9f4:	00000b97          	auipc	s7,0x0
 9f8:	3ccb8b93          	addi	s7,s7,972 # dc0 <digits>
 9fc:	03c9d793          	srli	a5,s3,0x3c
 a00:	00fb87b3          	add	a5,s7,a5
 a04:	0007c583          	lbu	a1,0(a5)
 a08:	000b0513          	mv	a0,s6
 a0c:	bf5ff0ef          	jal	600 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a10:	00499993          	slli	s3,s3,0x4
 a14:	fff9091b          	addiw	s2,s2,-1
 a18:	fe0912e3          	bnez	s2,9fc <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
 a1c:	000d0b93          	mv	s7,s10
      state = 0;
 a20:	00000993          	li	s3,0
 a24:	00013d03          	ld	s10,0(sp)
 a28:	d6dff06f          	j	794 <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
 a2c:	008b8993          	addi	s3,s7,8
 a30:	000bb903          	ld	s2,0(s7)
 a34:	02090663          	beqz	s2,a60 <vprintf+0x344>
        for(; *s; s++)
 a38:	00094583          	lbu	a1,0(s2)
 a3c:	02058a63          	beqz	a1,a70 <vprintf+0x354>
          putc(fd, *s);
 a40:	000b0513          	mv	a0,s6
 a44:	bbdff0ef          	jal	600 <putc>
        for(; *s; s++)
 a48:	00190913          	addi	s2,s2,1
 a4c:	00094583          	lbu	a1,0(s2)
 a50:	fe0598e3          	bnez	a1,a40 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 a54:	00098b93          	mv	s7,s3
      state = 0;
 a58:	00000993          	li	s3,0
 a5c:	d39ff06f          	j	794 <vprintf+0x78>
          s = "(null)";
 a60:	00000917          	auipc	s2,0x0
 a64:	35890913          	addi	s2,s2,856 # db8 <malloc+0x1c4>
        for(; *s; s++)
 a68:	02800593          	li	a1,40
 a6c:	fd5ff06f          	j	a40 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 a70:	00098b93          	mv	s7,s3
      state = 0;
 a74:	00000993          	li	s3,0
 a78:	d1dff06f          	j	794 <vprintf+0x78>
 a7c:	04813483          	ld	s1,72(sp)
 a80:	03813983          	ld	s3,56(sp)
 a84:	03013a03          	ld	s4,48(sp)
 a88:	02813a83          	ld	s5,40(sp)
 a8c:	02013b03          	ld	s6,32(sp)
 a90:	01813b83          	ld	s7,24(sp)
 a94:	01013c03          	ld	s8,16(sp)
 a98:	00813c83          	ld	s9,8(sp)
    }
  }
}
 a9c:	05813083          	ld	ra,88(sp)
 aa0:	05013403          	ld	s0,80(sp)
 aa4:	04013903          	ld	s2,64(sp)
 aa8:	06010113          	addi	sp,sp,96
 aac:	00008067          	ret

0000000000000ab0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 ab0:	fb010113          	addi	sp,sp,-80
 ab4:	00113c23          	sd	ra,24(sp)
 ab8:	00813823          	sd	s0,16(sp)
 abc:	02010413          	addi	s0,sp,32
 ac0:	00c43023          	sd	a2,0(s0)
 ac4:	00d43423          	sd	a3,8(s0)
 ac8:	00e43823          	sd	a4,16(s0)
 acc:	00f43c23          	sd	a5,24(s0)
 ad0:	03043023          	sd	a6,32(s0)
 ad4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 ad8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 adc:	00040613          	mv	a2,s0
 ae0:	c3dff0ef          	jal	71c <vprintf>
}
 ae4:	01813083          	ld	ra,24(sp)
 ae8:	01013403          	ld	s0,16(sp)
 aec:	05010113          	addi	sp,sp,80
 af0:	00008067          	ret

0000000000000af4 <printf>:

void
printf(const char *fmt, ...)
{
 af4:	fa010113          	addi	sp,sp,-96
 af8:	00113c23          	sd	ra,24(sp)
 afc:	00813823          	sd	s0,16(sp)
 b00:	02010413          	addi	s0,sp,32
 b04:	00b43423          	sd	a1,8(s0)
 b08:	00c43823          	sd	a2,16(s0)
 b0c:	00d43c23          	sd	a3,24(s0)
 b10:	02e43023          	sd	a4,32(s0)
 b14:	02f43423          	sd	a5,40(s0)
 b18:	03043823          	sd	a6,48(s0)
 b1c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b20:	00840613          	addi	a2,s0,8
 b24:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b28:	00050593          	mv	a1,a0
 b2c:	00100513          	li	a0,1
 b30:	bedff0ef          	jal	71c <vprintf>
}
 b34:	01813083          	ld	ra,24(sp)
 b38:	01013403          	ld	s0,16(sp)
 b3c:	06010113          	addi	sp,sp,96
 b40:	00008067          	ret

0000000000000b44 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b44:	ff010113          	addi	sp,sp,-16
 b48:	00813423          	sd	s0,8(sp)
 b4c:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b50:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b54:	00000797          	auipc	a5,0x0
 b58:	4ac7b783          	ld	a5,1196(a5) # 1000 <freep>
 b5c:	0400006f          	j	b9c <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b60:	00862703          	lw	a4,8(a2)
 b64:	00b7073b          	addw	a4,a4,a1
 b68:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b6c:	0007b703          	ld	a4,0(a5)
 b70:	00073603          	ld	a2,0(a4)
 b74:	0500006f          	j	bc4 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b78:	ff852703          	lw	a4,-8(a0)
 b7c:	00c7073b          	addw	a4,a4,a2
 b80:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b84:	ff053683          	ld	a3,-16(a0)
 b88:	0540006f          	j	bdc <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b8c:	0007b703          	ld	a4,0(a5)
 b90:	00e7e463          	bltu	a5,a4,b98 <free+0x54>
 b94:	00e6ec63          	bltu	a3,a4,bac <free+0x68>
{
 b98:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b9c:	fed7f8e3          	bgeu	a5,a3,b8c <free+0x48>
 ba0:	0007b703          	ld	a4,0(a5)
 ba4:	00e6e463          	bltu	a3,a4,bac <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ba8:	fee7e8e3          	bltu	a5,a4,b98 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 bac:	ff852583          	lw	a1,-8(a0)
 bb0:	0007b603          	ld	a2,0(a5)
 bb4:	02059813          	slli	a6,a1,0x20
 bb8:	01c85713          	srli	a4,a6,0x1c
 bbc:	00e68733          	add	a4,a3,a4
 bc0:	fae600e3          	beq	a2,a4,b60 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 bc4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 bc8:	0087a603          	lw	a2,8(a5)
 bcc:	02061593          	slli	a1,a2,0x20
 bd0:	01c5d713          	srli	a4,a1,0x1c
 bd4:	00e78733          	add	a4,a5,a4
 bd8:	fae680e3          	beq	a3,a4,b78 <free+0x34>
    p->s.ptr = bp->s.ptr;
 bdc:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 be0:	00000717          	auipc	a4,0x0
 be4:	42f73023          	sd	a5,1056(a4) # 1000 <freep>
}
 be8:	00813403          	ld	s0,8(sp)
 bec:	01010113          	addi	sp,sp,16
 bf0:	00008067          	ret

0000000000000bf4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 bf4:	fc010113          	addi	sp,sp,-64
 bf8:	02113c23          	sd	ra,56(sp)
 bfc:	02813823          	sd	s0,48(sp)
 c00:	02913423          	sd	s1,40(sp)
 c04:	01313c23          	sd	s3,24(sp)
 c08:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c0c:	02051493          	slli	s1,a0,0x20
 c10:	0204d493          	srli	s1,s1,0x20
 c14:	00f48493          	addi	s1,s1,15
 c18:	0044d493          	srli	s1,s1,0x4
 c1c:	0014899b          	addiw	s3,s1,1
 c20:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
 c24:	00000517          	auipc	a0,0x0
 c28:	3dc53503          	ld	a0,988(a0) # 1000 <freep>
 c2c:	04050663          	beqz	a0,c78 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c30:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c34:	0087a703          	lw	a4,8(a5)
 c38:	0c977c63          	bgeu	a4,s1,d10 <malloc+0x11c>
 c3c:	03213023          	sd	s2,32(sp)
 c40:	01413823          	sd	s4,16(sp)
 c44:	01513423          	sd	s5,8(sp)
 c48:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
 c4c:	00098a13          	mv	s4,s3
 c50:	0009871b          	sext.w	a4,s3
 c54:	000016b7          	lui	a3,0x1
 c58:	00d77463          	bgeu	a4,a3,c60 <malloc+0x6c>
 c5c:	00001a37          	lui	s4,0x1
 c60:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c64:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c68:	00000917          	auipc	s2,0x0
 c6c:	39890913          	addi	s2,s2,920 # 1000 <freep>
  if(p == (char*)-1)
 c70:	fff00a93          	li	s5,-1
 c74:	05c0006f          	j	cd0 <malloc+0xdc>
 c78:	03213023          	sd	s2,32(sp)
 c7c:	01413823          	sd	s4,16(sp)
 c80:	01513423          	sd	s5,8(sp)
 c84:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c88:	00000797          	auipc	a5,0x0
 c8c:	38878793          	addi	a5,a5,904 # 1010 <base>
 c90:	00000717          	auipc	a4,0x0
 c94:	36f73823          	sd	a5,880(a4) # 1000 <freep>
 c98:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 c9c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ca0:	fadff06f          	j	c4c <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
 ca4:	0007b703          	ld	a4,0(a5)
 ca8:	00e53023          	sd	a4,0(a0)
 cac:	0800006f          	j	d2c <malloc+0x138>
  hp->s.size = nu;
 cb0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cb4:	01050513          	addi	a0,a0,16
 cb8:	e8dff0ef          	jal	b44 <free>
  return freep;
 cbc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 cc0:	08050863          	beqz	a0,d50 <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cc4:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cc8:	0087a703          	lw	a4,8(a5)
 ccc:	02977a63          	bgeu	a4,s1,d00 <malloc+0x10c>
    if(p == freep)
 cd0:	00093703          	ld	a4,0(s2)
 cd4:	00078513          	mv	a0,a5
 cd8:	fef716e3          	bne	a4,a5,cc4 <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
 cdc:	000a0513          	mv	a0,s4
 ce0:	8fdff0ef          	jal	5dc <sbrk>
  if(p == (char*)-1)
 ce4:	fd5516e3          	bne	a0,s5,cb0 <malloc+0xbc>
        return 0;
 ce8:	00000513          	li	a0,0
 cec:	02013903          	ld	s2,32(sp)
 cf0:	01013a03          	ld	s4,16(sp)
 cf4:	00813a83          	ld	s5,8(sp)
 cf8:	00013b03          	ld	s6,0(sp)
 cfc:	03c0006f          	j	d38 <malloc+0x144>
 d00:	02013903          	ld	s2,32(sp)
 d04:	01013a03          	ld	s4,16(sp)
 d08:	00813a83          	ld	s5,8(sp)
 d0c:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
 d10:	f8e48ae3          	beq	s1,a4,ca4 <malloc+0xb0>
        p->s.size -= nunits;
 d14:	4137073b          	subw	a4,a4,s3
 d18:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 d1c:	02071693          	slli	a3,a4,0x20
 d20:	01c6d713          	srli	a4,a3,0x1c
 d24:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 d28:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d2c:	00000717          	auipc	a4,0x0
 d30:	2ca73a23          	sd	a0,724(a4) # 1000 <freep>
      return (void*)(p + 1);
 d34:	01078513          	addi	a0,a5,16
  }
}
 d38:	03813083          	ld	ra,56(sp)
 d3c:	03013403          	ld	s0,48(sp)
 d40:	02813483          	ld	s1,40(sp)
 d44:	01813983          	ld	s3,24(sp)
 d48:	04010113          	addi	sp,sp,64
 d4c:	00008067          	ret
 d50:	02013903          	ld	s2,32(sp)
 d54:	01013a03          	ld	s4,16(sp)
 d58:	00813a83          	ld	s5,8(sp)
 d5c:	00013b03          	ld	s6,0(sp)
 d60:	fd9ff06f          	j	d38 <malloc+0x144>
