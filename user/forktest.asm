
user/_forktest:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <print>:

#define N  1000

void
print(const char *s)
{
   0:	fe010113          	addi	sp,sp,-32
   4:	00113c23          	sd	ra,24(sp)
   8:	00813823          	sd	s0,16(sp)
   c:	00913423          	sd	s1,8(sp)
  10:	02010413          	addi	s0,sp,32
  14:	00050493          	mv	s1,a0
  write(1, s, strlen(s));
  18:	19c000ef          	jal	1b4 <strlen>
  1c:	0005061b          	sext.w	a2,a0
  20:	00048593          	mv	a1,s1
  24:	00100513          	li	a0,1
  28:	504000ef          	jal	52c <write>
}
  2c:	01813083          	ld	ra,24(sp)
  30:	01013403          	ld	s0,16(sp)
  34:	00813483          	ld	s1,8(sp)
  38:	02010113          	addi	sp,sp,32
  3c:	00008067          	ret

0000000000000040 <forktest>:

void
forktest(void)
{
  40:	fe010113          	addi	sp,sp,-32
  44:	00113c23          	sd	ra,24(sp)
  48:	00813823          	sd	s0,16(sp)
  4c:	00913423          	sd	s1,8(sp)
  50:	01213023          	sd	s2,0(sp)
  54:	02010413          	addi	s0,sp,32
  int n, pid;

  print("fork test\n");
  58:	00000517          	auipc	a0,0x0
  5c:	59850513          	addi	a0,a0,1432 # 5f0 <uptime+0x10>
  60:	fa1ff0ef          	jal	0 <print>

  for(n=0; n<N; n++){
  64:	00000493          	li	s1,0
  68:	3e800913          	li	s2,1000
    pid = fork();
  6c:	484000ef          	jal	4f0 <fork>
    if(pid < 0)
  70:	04054863          	bltz	a0,c0 <forktest+0x80>
      break;
    if(pid == 0)
  74:	02050063          	beqz	a0,94 <forktest+0x54>
  for(n=0; n<N; n++){
  78:	0014849b          	addiw	s1,s1,1
  7c:	ff2498e3          	bne	s1,s2,6c <forktest+0x2c>
      exit(0);
  }

  if(n == N){
    print("fork claimed to work N times!\n");
  80:	00000517          	auipc	a0,0x0
  84:	5c050513          	addi	a0,a0,1472 # 640 <uptime+0x60>
  88:	f79ff0ef          	jal	0 <print>
    exit(1);
  8c:	00100513          	li	a0,1
  90:	46c000ef          	jal	4fc <exit>
      exit(0);
  94:	468000ef          	jal	4fc <exit>
  }

  for(; n > 0; n--){
    if(wait(0) < 0){
      print("wait stopped early\n");
  98:	00000517          	auipc	a0,0x0
  9c:	56850513          	addi	a0,a0,1384 # 600 <uptime+0x20>
  a0:	f61ff0ef          	jal	0 <print>
      exit(1);
  a4:	00100513          	li	a0,1
  a8:	454000ef          	jal	4fc <exit>
    }
  }

  if(wait(0) != -1){
    print("wait got too many\n");
  ac:	00000517          	auipc	a0,0x0
  b0:	56c50513          	addi	a0,a0,1388 # 618 <uptime+0x38>
  b4:	f4dff0ef          	jal	0 <print>
    exit(1);
  b8:	00100513          	li	a0,1
  bc:	440000ef          	jal	4fc <exit>
  for(; n > 0; n--){
  c0:	00905c63          	blez	s1,d8 <forktest+0x98>
    if(wait(0) < 0){
  c4:	00000513          	li	a0,0
  c8:	440000ef          	jal	508 <wait>
  cc:	fc0546e3          	bltz	a0,98 <forktest+0x58>
  for(; n > 0; n--){
  d0:	fff4849b          	addiw	s1,s1,-1
  d4:	fe0498e3          	bnez	s1,c4 <forktest+0x84>
  if(wait(0) != -1){
  d8:	00000513          	li	a0,0
  dc:	42c000ef          	jal	508 <wait>
  e0:	fff00793          	li	a5,-1
  e4:	fcf514e3          	bne	a0,a5,ac <forktest+0x6c>
  }

  print("fork test OK\n");
  e8:	00000517          	auipc	a0,0x0
  ec:	54850513          	addi	a0,a0,1352 # 630 <uptime+0x50>
  f0:	f11ff0ef          	jal	0 <print>
}
  f4:	01813083          	ld	ra,24(sp)
  f8:	01013403          	ld	s0,16(sp)
  fc:	00813483          	ld	s1,8(sp)
 100:	00013903          	ld	s2,0(sp)
 104:	02010113          	addi	sp,sp,32
 108:	00008067          	ret

000000000000010c <main>:

int
main(void)
{
 10c:	ff010113          	addi	sp,sp,-16
 110:	00113423          	sd	ra,8(sp)
 114:	00813023          	sd	s0,0(sp)
 118:	01010413          	addi	s0,sp,16
  forktest();
 11c:	f25ff0ef          	jal	40 <forktest>
  exit(0);
 120:	00000513          	li	a0,0
 124:	3d8000ef          	jal	4fc <exit>

0000000000000128 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 128:	ff010113          	addi	sp,sp,-16
 12c:	00113423          	sd	ra,8(sp)
 130:	00813023          	sd	s0,0(sp)
 134:	01010413          	addi	s0,sp,16
  extern int main();
  main();
 138:	fd5ff0ef          	jal	10c <main>
  exit(0);
 13c:	00000513          	li	a0,0
 140:	3bc000ef          	jal	4fc <exit>

0000000000000144 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 144:	ff010113          	addi	sp,sp,-16
 148:	00813423          	sd	s0,8(sp)
 14c:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 150:	00050793          	mv	a5,a0
 154:	00158593          	addi	a1,a1,1
 158:	00178793          	addi	a5,a5,1
 15c:	fff5c703          	lbu	a4,-1(a1)
 160:	fee78fa3          	sb	a4,-1(a5)
 164:	fe0718e3          	bnez	a4,154 <strcpy+0x10>
    ;
  return os;
}
 168:	00813403          	ld	s0,8(sp)
 16c:	01010113          	addi	sp,sp,16
 170:	00008067          	ret

0000000000000174 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 174:	ff010113          	addi	sp,sp,-16
 178:	00813423          	sd	s0,8(sp)
 17c:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
 180:	00054783          	lbu	a5,0(a0)
 184:	00078e63          	beqz	a5,1a0 <strcmp+0x2c>
 188:	0005c703          	lbu	a4,0(a1)
 18c:	00f71a63          	bne	a4,a5,1a0 <strcmp+0x2c>
    p++, q++;
 190:	00150513          	addi	a0,a0,1
 194:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
 198:	00054783          	lbu	a5,0(a0)
 19c:	fe0796e3          	bnez	a5,188 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 1a0:	0005c503          	lbu	a0,0(a1)
}
 1a4:	40a7853b          	subw	a0,a5,a0
 1a8:	00813403          	ld	s0,8(sp)
 1ac:	01010113          	addi	sp,sp,16
 1b0:	00008067          	ret

00000000000001b4 <strlen>:

uint
strlen(const char *s)
{
 1b4:	ff010113          	addi	sp,sp,-16
 1b8:	00813423          	sd	s0,8(sp)
 1bc:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	02078863          	beqz	a5,1f4 <strlen+0x40>
 1c8:	00150513          	addi	a0,a0,1
 1cc:	00050793          	mv	a5,a0
 1d0:	00078693          	mv	a3,a5
 1d4:	00178793          	addi	a5,a5,1
 1d8:	fff7c703          	lbu	a4,-1(a5)
 1dc:	fe071ae3          	bnez	a4,1d0 <strlen+0x1c>
 1e0:	40a6853b          	subw	a0,a3,a0
 1e4:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
 1e8:	00813403          	ld	s0,8(sp)
 1ec:	01010113          	addi	sp,sp,16
 1f0:	00008067          	ret
  for(n = 0; s[n]; n++)
 1f4:	00000513          	li	a0,0
 1f8:	ff1ff06f          	j	1e8 <strlen+0x34>

00000000000001fc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fc:	ff010113          	addi	sp,sp,-16
 200:	00813423          	sd	s0,8(sp)
 204:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 208:	02060063          	beqz	a2,228 <memset+0x2c>
 20c:	00050793          	mv	a5,a0
 210:	02061613          	slli	a2,a2,0x20
 214:	02065613          	srli	a2,a2,0x20
 218:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 21c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 220:	00178793          	addi	a5,a5,1
 224:	fee79ce3          	bne	a5,a4,21c <memset+0x20>
  }
  return dst;
}
 228:	00813403          	ld	s0,8(sp)
 22c:	01010113          	addi	sp,sp,16
 230:	00008067          	ret

0000000000000234 <strchr>:

char*
strchr(const char *s, char c)
{
 234:	ff010113          	addi	sp,sp,-16
 238:	00813423          	sd	s0,8(sp)
 23c:	01010413          	addi	s0,sp,16
  for(; *s; s++)
 240:	00054783          	lbu	a5,0(a0)
 244:	02078263          	beqz	a5,268 <strchr+0x34>
    if(*s == c)
 248:	00f58a63          	beq	a1,a5,25c <strchr+0x28>
  for(; *s; s++)
 24c:	00150513          	addi	a0,a0,1
 250:	00054783          	lbu	a5,0(a0)
 254:	fe079ae3          	bnez	a5,248 <strchr+0x14>
      return (char*)s;
  return 0;
 258:	00000513          	li	a0,0
}
 25c:	00813403          	ld	s0,8(sp)
 260:	01010113          	addi	sp,sp,16
 264:	00008067          	ret
  return 0;
 268:	00000513          	li	a0,0
 26c:	ff1ff06f          	j	25c <strchr+0x28>

0000000000000270 <gets>:

char*
gets(char *buf, int max)
{
 270:	fa010113          	addi	sp,sp,-96
 274:	04113c23          	sd	ra,88(sp)
 278:	04813823          	sd	s0,80(sp)
 27c:	04913423          	sd	s1,72(sp)
 280:	05213023          	sd	s2,64(sp)
 284:	03313c23          	sd	s3,56(sp)
 288:	03413823          	sd	s4,48(sp)
 28c:	03513423          	sd	s5,40(sp)
 290:	03613023          	sd	s6,32(sp)
 294:	01713c23          	sd	s7,24(sp)
 298:	06010413          	addi	s0,sp,96
 29c:	00050b93          	mv	s7,a0
 2a0:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a4:	00050913          	mv	s2,a0
 2a8:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2ac:	00a00a93          	li	s5,10
 2b0:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 2b4:	00048993          	mv	s3,s1
 2b8:	0014849b          	addiw	s1,s1,1
 2bc:	0344dc63          	bge	s1,s4,2f4 <gets+0x84>
    cc = read(0, &c, 1);
 2c0:	00100613          	li	a2,1
 2c4:	faf40593          	addi	a1,s0,-81
 2c8:	00000513          	li	a0,0
 2cc:	254000ef          	jal	520 <read>
    if(cc < 1)
 2d0:	02a05263          	blez	a0,2f4 <gets+0x84>
    buf[i++] = c;
 2d4:	faf44783          	lbu	a5,-81(s0)
 2d8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2dc:	01578a63          	beq	a5,s5,2f0 <gets+0x80>
 2e0:	00190913          	addi	s2,s2,1
 2e4:	fd6798e3          	bne	a5,s6,2b4 <gets+0x44>
    buf[i++] = c;
 2e8:	00048993          	mv	s3,s1
 2ec:	0080006f          	j	2f4 <gets+0x84>
 2f0:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2f4:	013b89b3          	add	s3,s7,s3
 2f8:	00098023          	sb	zero,0(s3)
  return buf;
}
 2fc:	000b8513          	mv	a0,s7
 300:	05813083          	ld	ra,88(sp)
 304:	05013403          	ld	s0,80(sp)
 308:	04813483          	ld	s1,72(sp)
 30c:	04013903          	ld	s2,64(sp)
 310:	03813983          	ld	s3,56(sp)
 314:	03013a03          	ld	s4,48(sp)
 318:	02813a83          	ld	s5,40(sp)
 31c:	02013b03          	ld	s6,32(sp)
 320:	01813b83          	ld	s7,24(sp)
 324:	06010113          	addi	sp,sp,96
 328:	00008067          	ret

000000000000032c <stat>:

int
stat(const char *n, struct stat *st)
{
 32c:	fe010113          	addi	sp,sp,-32
 330:	00113c23          	sd	ra,24(sp)
 334:	00813823          	sd	s0,16(sp)
 338:	01213023          	sd	s2,0(sp)
 33c:	02010413          	addi	s0,sp,32
 340:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 344:	00000593          	li	a1,0
 348:	214000ef          	jal	55c <open>
  if(fd < 0)
 34c:	02054e63          	bltz	a0,388 <stat+0x5c>
 350:	00913423          	sd	s1,8(sp)
 354:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 358:	00090593          	mv	a1,s2
 35c:	224000ef          	jal	580 <fstat>
 360:	00050913          	mv	s2,a0
  close(fd);
 364:	00048513          	mv	a0,s1
 368:	1d0000ef          	jal	538 <close>
  return r;
 36c:	00813483          	ld	s1,8(sp)
}
 370:	00090513          	mv	a0,s2
 374:	01813083          	ld	ra,24(sp)
 378:	01013403          	ld	s0,16(sp)
 37c:	00013903          	ld	s2,0(sp)
 380:	02010113          	addi	sp,sp,32
 384:	00008067          	ret
    return -1;
 388:	fff00913          	li	s2,-1
 38c:	fe5ff06f          	j	370 <stat+0x44>

0000000000000390 <atoi>:

int
atoi(const char *s)
{
 390:	ff010113          	addi	sp,sp,-16
 394:	00813423          	sd	s0,8(sp)
 398:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 39c:	00054683          	lbu	a3,0(a0)
 3a0:	fd06879b          	addiw	a5,a3,-48
 3a4:	0ff7f793          	zext.b	a5,a5
 3a8:	00900613          	li	a2,9
 3ac:	04f66063          	bltu	a2,a5,3ec <atoi+0x5c>
 3b0:	00050713          	mv	a4,a0
  n = 0;
 3b4:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 3b8:	00170713          	addi	a4,a4,1
 3bc:	0025179b          	slliw	a5,a0,0x2
 3c0:	00a787bb          	addw	a5,a5,a0
 3c4:	0017979b          	slliw	a5,a5,0x1
 3c8:	00d787bb          	addw	a5,a5,a3
 3cc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3d0:	00074683          	lbu	a3,0(a4)
 3d4:	fd06879b          	addiw	a5,a3,-48
 3d8:	0ff7f793          	zext.b	a5,a5
 3dc:	fcf67ee3          	bgeu	a2,a5,3b8 <atoi+0x28>
  return n;
}
 3e0:	00813403          	ld	s0,8(sp)
 3e4:	01010113          	addi	sp,sp,16
 3e8:	00008067          	ret
  n = 0;
 3ec:	00000513          	li	a0,0
 3f0:	ff1ff06f          	j	3e0 <atoi+0x50>

00000000000003f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3f4:	ff010113          	addi	sp,sp,-16
 3f8:	00813423          	sd	s0,8(sp)
 3fc:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 400:	02b57c63          	bgeu	a0,a1,438 <memmove+0x44>
    while(n-- > 0)
 404:	02c05463          	blez	a2,42c <memmove+0x38>
 408:	02061613          	slli	a2,a2,0x20
 40c:	02065613          	srli	a2,a2,0x20
 410:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 414:	00050713          	mv	a4,a0
      *dst++ = *src++;
 418:	00158593          	addi	a1,a1,1
 41c:	00170713          	addi	a4,a4,1
 420:	fff5c683          	lbu	a3,-1(a1)
 424:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 428:	fef718e3          	bne	a4,a5,418 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 42c:	00813403          	ld	s0,8(sp)
 430:	01010113          	addi	sp,sp,16
 434:	00008067          	ret
    dst += n;
 438:	00c50733          	add	a4,a0,a2
    src += n;
 43c:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 440:	fec056e3          	blez	a2,42c <memmove+0x38>
 444:	fff6079b          	addiw	a5,a2,-1
 448:	02079793          	slli	a5,a5,0x20
 44c:	0207d793          	srli	a5,a5,0x20
 450:	fff7c793          	not	a5,a5
 454:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 458:	fff58593          	addi	a1,a1,-1
 45c:	fff70713          	addi	a4,a4,-1
 460:	0005c683          	lbu	a3,0(a1)
 464:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 468:	fee798e3          	bne	a5,a4,458 <memmove+0x64>
 46c:	fc1ff06f          	j	42c <memmove+0x38>

0000000000000470 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 470:	ff010113          	addi	sp,sp,-16
 474:	00813423          	sd	s0,8(sp)
 478:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 47c:	04060463          	beqz	a2,4c4 <memcmp+0x54>
 480:	fff6069b          	addiw	a3,a2,-1
 484:	02069693          	slli	a3,a3,0x20
 488:	0206d693          	srli	a3,a3,0x20
 48c:	00168693          	addi	a3,a3,1
 490:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 494:	00054783          	lbu	a5,0(a0)
 498:	0005c703          	lbu	a4,0(a1)
 49c:	00e79c63          	bne	a5,a4,4b4 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 4a0:	00150513          	addi	a0,a0,1
    p2++;
 4a4:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
 4a8:	fed516e3          	bne	a0,a3,494 <memcmp+0x24>
  }
  return 0;
 4ac:	00000513          	li	a0,0
 4b0:	0080006f          	j	4b8 <memcmp+0x48>
      return *p1 - *p2;
 4b4:	40e7853b          	subw	a0,a5,a4
}
 4b8:	00813403          	ld	s0,8(sp)
 4bc:	01010113          	addi	sp,sp,16
 4c0:	00008067          	ret
  return 0;
 4c4:	00000513          	li	a0,0
 4c8:	ff1ff06f          	j	4b8 <memcmp+0x48>

00000000000004cc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4cc:	ff010113          	addi	sp,sp,-16
 4d0:	00113423          	sd	ra,8(sp)
 4d4:	00813023          	sd	s0,0(sp)
 4d8:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
 4dc:	f19ff0ef          	jal	3f4 <memmove>
}
 4e0:	00813083          	ld	ra,8(sp)
 4e4:	00013403          	ld	s0,0(sp)
 4e8:	01010113          	addi	sp,sp,16
 4ec:	00008067          	ret

00000000000004f0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4f0:	00100893          	li	a7,1
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	00008067          	ret

00000000000004fc <exit>:
.global exit
exit:
 li a7, SYS_exit
 4fc:	00200893          	li	a7,2
 ecall
 500:	00000073          	ecall
 ret
 504:	00008067          	ret

0000000000000508 <wait>:
.global wait
wait:
 li a7, SYS_wait
 508:	00300893          	li	a7,3
 ecall
 50c:	00000073          	ecall
 ret
 510:	00008067          	ret

0000000000000514 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 514:	00400893          	li	a7,4
 ecall
 518:	00000073          	ecall
 ret
 51c:	00008067          	ret

0000000000000520 <read>:
.global read
read:
 li a7, SYS_read
 520:	00500893          	li	a7,5
 ecall
 524:	00000073          	ecall
 ret
 528:	00008067          	ret

000000000000052c <write>:
.global write
write:
 li a7, SYS_write
 52c:	01000893          	li	a7,16
 ecall
 530:	00000073          	ecall
 ret
 534:	00008067          	ret

0000000000000538 <close>:
.global close
close:
 li a7, SYS_close
 538:	01500893          	li	a7,21
 ecall
 53c:	00000073          	ecall
 ret
 540:	00008067          	ret

0000000000000544 <kill>:
.global kill
kill:
 li a7, SYS_kill
 544:	00600893          	li	a7,6
 ecall
 548:	00000073          	ecall
 ret
 54c:	00008067          	ret

0000000000000550 <exec>:
.global exec
exec:
 li a7, SYS_exec
 550:	00700893          	li	a7,7
 ecall
 554:	00000073          	ecall
 ret
 558:	00008067          	ret

000000000000055c <open>:
.global open
open:
 li a7, SYS_open
 55c:	00f00893          	li	a7,15
 ecall
 560:	00000073          	ecall
 ret
 564:	00008067          	ret

0000000000000568 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 568:	01100893          	li	a7,17
 ecall
 56c:	00000073          	ecall
 ret
 570:	00008067          	ret

0000000000000574 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 574:	01200893          	li	a7,18
 ecall
 578:	00000073          	ecall
 ret
 57c:	00008067          	ret

0000000000000580 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 580:	00800893          	li	a7,8
 ecall
 584:	00000073          	ecall
 ret
 588:	00008067          	ret

000000000000058c <link>:
.global link
link:
 li a7, SYS_link
 58c:	01300893          	li	a7,19
 ecall
 590:	00000073          	ecall
 ret
 594:	00008067          	ret

0000000000000598 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 598:	01400893          	li	a7,20
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	00008067          	ret

00000000000005a4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5a4:	00900893          	li	a7,9
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	00008067          	ret

00000000000005b0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5b0:	00a00893          	li	a7,10
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	00008067          	ret

00000000000005bc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5bc:	00b00893          	li	a7,11
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	00008067          	ret

00000000000005c8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5c8:	00c00893          	li	a7,12
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	00008067          	ret

00000000000005d4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5d4:	00d00893          	li	a7,13
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	00008067          	ret

00000000000005e0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5e0:	00e00893          	li	a7,14
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	00008067          	ret
