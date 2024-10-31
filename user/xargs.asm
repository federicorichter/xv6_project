
user/_xargs:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <copy_argv>:

#define MAX_ARG_LEN 512

void
copy_argv(char **ori_argv, int ori_argc, char *new_argv, char **argv)
{
   0:	fb010113          	addi	sp,sp,-80
   4:	04113423          	sd	ra,72(sp)
   8:	04813023          	sd	s0,64(sp)
   c:	02913c23          	sd	s1,56(sp)
  10:	01613823          	sd	s6,16(sp)
  14:	01713423          	sd	s7,8(sp)
  18:	01813023          	sd	s8,0(sp)
  1c:	05010413          	addi	s0,sp,80
  20:	00060c13          	mv	s8,a2
  24:	00068b93          	mv	s7,a3
  int k = 0;
  for (int i = 0; i < ori_argc; i++) {
  28:	0cb05863          	blez	a1,f8 <copy_argv+0xf8>
  2c:	03213823          	sd	s2,48(sp)
  30:	03313423          	sd	s3,40(sp)
  34:	03413023          	sd	s4,32(sp)
  38:	01513c23          	sd	s5,24(sp)
  3c:	00058b13          	mv	s6,a1
  40:	00050493          	mv	s1,a0
  44:	00068993          	mv	s3,a3
  48:	00359793          	slli	a5,a1,0x3
  4c:	00f50ab3          	add	s5,a0,a5
    argv[k] = malloc(strlen(ori_argv[i]) + 1);
  50:	0004b503          	ld	a0,0(s1)
  54:	2e4000ef          	jal	338 <strlen>
  58:	0015051b          	addiw	a0,a0,1
  5c:	509000ef          	jal	d64 <malloc>
  60:	00050913          	mv	s2,a0
  64:	00a9b023          	sd	a0,0(s3)
    memcpy(argv[k++], ori_argv[i], strlen(ori_argv[i]) + 1);
  68:	0004ba03          	ld	s4,0(s1)
  6c:	000a0513          	mv	a0,s4
  70:	2c8000ef          	jal	338 <strlen>
  74:	0015061b          	addiw	a2,a0,1
  78:	000a0593          	mv	a1,s4
  7c:	00090513          	mv	a0,s2
  80:	5d0000ef          	jal	650 <memcpy>
  for (int i = 0; i < ori_argc; i++) {
  84:	00848493          	addi	s1,s1,8
  88:	00898993          	addi	s3,s3,8
  8c:	fd5492e3          	bne	s1,s5,50 <copy_argv+0x50>
  90:	03013903          	ld	s2,48(sp)
  94:	02813983          	ld	s3,40(sp)
  98:	02013a03          	ld	s4,32(sp)
  9c:	01813a83          	ld	s5,24(sp)
  }
  argv[k] = malloc(strlen(new_argv) + 1);
  a0:	000c0513          	mv	a0,s8
  a4:	294000ef          	jal	338 <strlen>
  a8:	003b1b13          	slli	s6,s6,0x3
  ac:	016b8bb3          	add	s7,s7,s6
  b0:	0015051b          	addiw	a0,a0,1
  b4:	4b1000ef          	jal	d64 <malloc>
  b8:	00050493          	mv	s1,a0
  bc:	00abb023          	sd	a0,0(s7)
  memcpy(argv[k++], new_argv, strlen(new_argv) + 1);
  c0:	000c0513          	mv	a0,s8
  c4:	274000ef          	jal	338 <strlen>
  c8:	0015061b          	addiw	a2,a0,1
  cc:	000c0593          	mv	a1,s8
  d0:	00048513          	mv	a0,s1
  d4:	57c000ef          	jal	650 <memcpy>
}
  d8:	04813083          	ld	ra,72(sp)
  dc:	04013403          	ld	s0,64(sp)
  e0:	03813483          	ld	s1,56(sp)
  e4:	01013b03          	ld	s6,16(sp)
  e8:	00813b83          	ld	s7,8(sp)
  ec:	00013c03          	ld	s8,0(sp)
  f0:	05010113          	addi	sp,sp,80
  f4:	00008067          	ret
  int k = 0;
  f8:	00000b13          	li	s6,0
  fc:	fa5ff06f          	j	a0 <copy_argv+0xa0>

0000000000000100 <print>:


void
print(char **s, int n)
{
  for (int i = 0; i < n; i++) {
 100:	06b05263          	blez	a1,164 <print+0x64>
{
 104:	fd010113          	addi	sp,sp,-48
 108:	02113423          	sd	ra,40(sp)
 10c:	02813023          	sd	s0,32(sp)
 110:	00913c23          	sd	s1,24(sp)
 114:	01213823          	sd	s2,16(sp)
 118:	01313423          	sd	s3,8(sp)
 11c:	03010413          	addi	s0,sp,48
 120:	00050493          	mv	s1,a0
 124:	00359593          	slli	a1,a1,0x3
 128:	00b50933          	add	s2,a0,a1
    printf("%s\n", s[i]);
 12c:	00001997          	auipc	s3,0x1
 130:	db498993          	addi	s3,s3,-588 # ee0 <malloc+0x17c>
 134:	0004b583          	ld	a1,0(s1)
 138:	00098513          	mv	a0,s3
 13c:	329000ef          	jal	c64 <printf>
  for (int i = 0; i < n; i++) {
 140:	00848493          	addi	s1,s1,8
 144:	ff2498e3          	bne	s1,s2,134 <print+0x34>
  }
}
 148:	02813083          	ld	ra,40(sp)
 14c:	02013403          	ld	s0,32(sp)
 150:	01813483          	ld	s1,24(sp)
 154:	01013903          	ld	s2,16(sp)
 158:	00813983          	ld	s3,8(sp)
 15c:	03010113          	addi	sp,sp,48
 160:	00008067          	ret
 164:	00008067          	ret

0000000000000168 <main>:

int 
main(int argc, char *argv[])
{
 168:	ca010113          	addi	sp,sp,-864
 16c:	34113c23          	sd	ra,856(sp)
 170:	34813823          	sd	s0,848(sp)
 174:	36010413          	addi	s0,sp,864
  if (argc <= 1) {
 178:	00100793          	li	a5,1
 17c:	04a7d263          	bge	a5,a0,1c0 <main+0x58>
 180:	34913423          	sd	s1,840(sp)
 184:	35213023          	sd	s2,832(sp)
 188:	33313c23          	sd	s3,824(sp)
 18c:	33413823          	sd	s4,816(sp)
 190:	33513423          	sd	s5,808(sp)
 194:	33613023          	sd	s6,800(sp)
 198:	31713c23          	sd	s7,792(sp)
 19c:	00050a13          	mv	s4,a0
 1a0:	00058b13          	mv	s6,a1
 1a4:	00000913          	li	s2,0
 1a8:	00000493          	li	s1,0
  char param[MAX_ARG_LEN];
  int i = 0;
  char ch;
  int ignore = 0;
  while (read(0, &ch, 1) > 0) {
    if (ch == '\n') {
 1ac:	00a00993          	li	s3,10
        wait((int *)0);
      }
      
    } else {
      
      if (!ignore && i >= MAX_ARG_LEN - 1) {
 1b0:	1fe00a93          	li	s5,510
        printf("xargs: too long arguments...\n");
 1b4:	00001b97          	auipc	s7,0x1
 1b8:	d54b8b93          	addi	s7,s7,-684 # f08 <malloc+0x1a4>
 1bc:	0a40006f          	j	260 <main+0xf8>
 1c0:	34913423          	sd	s1,840(sp)
 1c4:	35213023          	sd	s2,832(sp)
 1c8:	33313c23          	sd	s3,824(sp)
 1cc:	33413823          	sd	s4,816(sp)
 1d0:	33513423          	sd	s5,808(sp)
 1d4:	33613023          	sd	s6,800(sp)
 1d8:	31713c23          	sd	s7,792(sp)
    fprintf(2, "Usage: xargx command [arg ...]\n");
 1dc:	00001597          	auipc	a1,0x1
 1e0:	d0c58593          	addi	a1,a1,-756 # ee8 <malloc+0x184>
 1e4:	00200513          	li	a0,2
 1e8:	239000ef          	jal	c20 <fprintf>
    exit(1);
 1ec:	00100513          	li	a0,1
 1f0:	490000ef          	jal	680 <exit>
      if (ignore) {
 1f4:	0a091263          	bnez	s2,298 <main+0x130>
      param[i] = 0;
 1f8:	fb048793          	addi	a5,s1,-80
 1fc:	008784b3          	add	s1,a5,s0
 200:	e0048023          	sb	zero,-512(s1)
      int pid = fork();
 204:	470000ef          	jal	674 <fork>
      if (pid == 0) {
 208:	00050a63          	beqz	a0,21c <main+0xb4>
        wait((int *)0);
 20c:	00000513          	li	a0,0
 210:	47c000ef          	jal	68c <wait>
      i = 0;
 214:	00090493          	mv	s1,s2
 218:	0480006f          	j	260 <main+0xf8>
        copy_argv(argv + 1, argc - 1, param, cmd_argv);
 21c:	ca840693          	addi	a3,s0,-856
 220:	db040613          	addi	a2,s0,-592
 224:	fffa059b          	addiw	a1,s4,-1
 228:	008b0513          	addi	a0,s6,8
 22c:	dd5ff0ef          	jal	0 <copy_argv>
        cmd_argv[cmd_argc] = 0;
 230:	003a1793          	slli	a5,s4,0x3
 234:	fb078793          	addi	a5,a5,-80
 238:	008787b3          	add	a5,a5,s0
 23c:	ce07bc23          	sd	zero,-776(a5)
        exec(cmd_argv[0], cmd_argv);
 240:	ca840593          	addi	a1,s0,-856
 244:	ca843503          	ld	a0,-856(s0)
 248:	48c000ef          	jal	6d4 <exec>
        exit(0);
 24c:	00000513          	li	a0,0
 250:	430000ef          	jal	680 <exit>
        printf("xargs: too long arguments...\n");
 254:	000b8513          	mv	a0,s7
 258:	20d000ef          	jal	c64 <printf>
        i = 0;
 25c:	00100913          	li	s2,1
  while (read(0, &ch, 1) > 0) {
 260:	00100613          	li	a2,1
 264:	daf40593          	addi	a1,s0,-593
 268:	00000513          	li	a0,0
 26c:	438000ef          	jal	6a4 <read>
 270:	02a05a63          	blez	a0,2a4 <main+0x13c>
    if (ch == '\n') {
 274:	daf44783          	lbu	a5,-593(s0)
 278:	f7378ee3          	beq	a5,s3,1f4 <main+0x8c>
      if (!ignore && i >= MAX_ARG_LEN - 1) {
 27c:	fe0910e3          	bnez	s2,25c <main+0xf4>
 280:	fc9acae3          	blt	s5,s1,254 <main+0xec>
        ignore = 1;
      }

      if (!ignore) {
        param[i++] = ch;
 284:	fb048713          	addi	a4,s1,-80
 288:	00870733          	add	a4,a4,s0
 28c:	e0f70023          	sb	a5,-512(a4)
 290:	0014849b          	addiw	s1,s1,1
 294:	fcdff06f          	j	260 <main+0xf8>
        ignore = 0;
 298:	00000913          	li	s2,0
        i = 0;
 29c:	00000493          	li	s1,0
 2a0:	fc1ff06f          	j	260 <main+0xf8>
      }
    }
  }

  exit(0);
 2a4:	00000513          	li	a0,0
 2a8:	3d8000ef          	jal	680 <exit>

00000000000002ac <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 2ac:	ff010113          	addi	sp,sp,-16
 2b0:	00113423          	sd	ra,8(sp)
 2b4:	00813023          	sd	s0,0(sp)
 2b8:	01010413          	addi	s0,sp,16
  extern int main();
  main();
 2bc:	eadff0ef          	jal	168 <main>
  exit(0);
 2c0:	00000513          	li	a0,0
 2c4:	3bc000ef          	jal	680 <exit>

00000000000002c8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2c8:	ff010113          	addi	sp,sp,-16
 2cc:	00813423          	sd	s0,8(sp)
 2d0:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2d4:	00050793          	mv	a5,a0
 2d8:	00158593          	addi	a1,a1,1
 2dc:	00178793          	addi	a5,a5,1
 2e0:	fff5c703          	lbu	a4,-1(a1)
 2e4:	fee78fa3          	sb	a4,-1(a5)
 2e8:	fe0718e3          	bnez	a4,2d8 <strcpy+0x10>
    ;
  return os;
}
 2ec:	00813403          	ld	s0,8(sp)
 2f0:	01010113          	addi	sp,sp,16
 2f4:	00008067          	ret

00000000000002f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f8:	ff010113          	addi	sp,sp,-16
 2fc:	00813423          	sd	s0,8(sp)
 300:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
 304:	00054783          	lbu	a5,0(a0)
 308:	00078e63          	beqz	a5,324 <strcmp+0x2c>
 30c:	0005c703          	lbu	a4,0(a1)
 310:	00f71a63          	bne	a4,a5,324 <strcmp+0x2c>
    p++, q++;
 314:	00150513          	addi	a0,a0,1
 318:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
 31c:	00054783          	lbu	a5,0(a0)
 320:	fe0796e3          	bnez	a5,30c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 324:	0005c503          	lbu	a0,0(a1)
}
 328:	40a7853b          	subw	a0,a5,a0
 32c:	00813403          	ld	s0,8(sp)
 330:	01010113          	addi	sp,sp,16
 334:	00008067          	ret

0000000000000338 <strlen>:

uint
strlen(const char *s)
{
 338:	ff010113          	addi	sp,sp,-16
 33c:	00813423          	sd	s0,8(sp)
 340:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 344:	00054783          	lbu	a5,0(a0)
 348:	02078863          	beqz	a5,378 <strlen+0x40>
 34c:	00150513          	addi	a0,a0,1
 350:	00050793          	mv	a5,a0
 354:	00078693          	mv	a3,a5
 358:	00178793          	addi	a5,a5,1
 35c:	fff7c703          	lbu	a4,-1(a5)
 360:	fe071ae3          	bnez	a4,354 <strlen+0x1c>
 364:	40a6853b          	subw	a0,a3,a0
 368:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
 36c:	00813403          	ld	s0,8(sp)
 370:	01010113          	addi	sp,sp,16
 374:	00008067          	ret
  for(n = 0; s[n]; n++)
 378:	00000513          	li	a0,0
 37c:	ff1ff06f          	j	36c <strlen+0x34>

0000000000000380 <memset>:

void*
memset(void *dst, int c, uint n)
{
 380:	ff010113          	addi	sp,sp,-16
 384:	00813423          	sd	s0,8(sp)
 388:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 38c:	02060063          	beqz	a2,3ac <memset+0x2c>
 390:	00050793          	mv	a5,a0
 394:	02061613          	slli	a2,a2,0x20
 398:	02065613          	srli	a2,a2,0x20
 39c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3a0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3a4:	00178793          	addi	a5,a5,1
 3a8:	fee79ce3          	bne	a5,a4,3a0 <memset+0x20>
  }
  return dst;
}
 3ac:	00813403          	ld	s0,8(sp)
 3b0:	01010113          	addi	sp,sp,16
 3b4:	00008067          	ret

00000000000003b8 <strchr>:

char*
strchr(const char *s, char c)
{
 3b8:	ff010113          	addi	sp,sp,-16
 3bc:	00813423          	sd	s0,8(sp)
 3c0:	01010413          	addi	s0,sp,16
  for(; *s; s++)
 3c4:	00054783          	lbu	a5,0(a0)
 3c8:	02078263          	beqz	a5,3ec <strchr+0x34>
    if(*s == c)
 3cc:	00f58a63          	beq	a1,a5,3e0 <strchr+0x28>
  for(; *s; s++)
 3d0:	00150513          	addi	a0,a0,1
 3d4:	00054783          	lbu	a5,0(a0)
 3d8:	fe079ae3          	bnez	a5,3cc <strchr+0x14>
      return (char*)s;
  return 0;
 3dc:	00000513          	li	a0,0
}
 3e0:	00813403          	ld	s0,8(sp)
 3e4:	01010113          	addi	sp,sp,16
 3e8:	00008067          	ret
  return 0;
 3ec:	00000513          	li	a0,0
 3f0:	ff1ff06f          	j	3e0 <strchr+0x28>

00000000000003f4 <gets>:

char*
gets(char *buf, int max)
{
 3f4:	fa010113          	addi	sp,sp,-96
 3f8:	04113c23          	sd	ra,88(sp)
 3fc:	04813823          	sd	s0,80(sp)
 400:	04913423          	sd	s1,72(sp)
 404:	05213023          	sd	s2,64(sp)
 408:	03313c23          	sd	s3,56(sp)
 40c:	03413823          	sd	s4,48(sp)
 410:	03513423          	sd	s5,40(sp)
 414:	03613023          	sd	s6,32(sp)
 418:	01713c23          	sd	s7,24(sp)
 41c:	06010413          	addi	s0,sp,96
 420:	00050b93          	mv	s7,a0
 424:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 428:	00050913          	mv	s2,a0
 42c:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 430:	00a00a93          	li	s5,10
 434:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 438:	00048993          	mv	s3,s1
 43c:	0014849b          	addiw	s1,s1,1
 440:	0344dc63          	bge	s1,s4,478 <gets+0x84>
    cc = read(0, &c, 1);
 444:	00100613          	li	a2,1
 448:	faf40593          	addi	a1,s0,-81
 44c:	00000513          	li	a0,0
 450:	254000ef          	jal	6a4 <read>
    if(cc < 1)
 454:	02a05263          	blez	a0,478 <gets+0x84>
    buf[i++] = c;
 458:	faf44783          	lbu	a5,-81(s0)
 45c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 460:	01578a63          	beq	a5,s5,474 <gets+0x80>
 464:	00190913          	addi	s2,s2,1
 468:	fd6798e3          	bne	a5,s6,438 <gets+0x44>
    buf[i++] = c;
 46c:	00048993          	mv	s3,s1
 470:	0080006f          	j	478 <gets+0x84>
 474:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 478:	013b89b3          	add	s3,s7,s3
 47c:	00098023          	sb	zero,0(s3)
  return buf;
}
 480:	000b8513          	mv	a0,s7
 484:	05813083          	ld	ra,88(sp)
 488:	05013403          	ld	s0,80(sp)
 48c:	04813483          	ld	s1,72(sp)
 490:	04013903          	ld	s2,64(sp)
 494:	03813983          	ld	s3,56(sp)
 498:	03013a03          	ld	s4,48(sp)
 49c:	02813a83          	ld	s5,40(sp)
 4a0:	02013b03          	ld	s6,32(sp)
 4a4:	01813b83          	ld	s7,24(sp)
 4a8:	06010113          	addi	sp,sp,96
 4ac:	00008067          	ret

00000000000004b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4b0:	fe010113          	addi	sp,sp,-32
 4b4:	00113c23          	sd	ra,24(sp)
 4b8:	00813823          	sd	s0,16(sp)
 4bc:	01213023          	sd	s2,0(sp)
 4c0:	02010413          	addi	s0,sp,32
 4c4:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c8:	00000593          	li	a1,0
 4cc:	214000ef          	jal	6e0 <open>
  if(fd < 0)
 4d0:	02054e63          	bltz	a0,50c <stat+0x5c>
 4d4:	00913423          	sd	s1,8(sp)
 4d8:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4dc:	00090593          	mv	a1,s2
 4e0:	224000ef          	jal	704 <fstat>
 4e4:	00050913          	mv	s2,a0
  close(fd);
 4e8:	00048513          	mv	a0,s1
 4ec:	1d0000ef          	jal	6bc <close>
  return r;
 4f0:	00813483          	ld	s1,8(sp)
}
 4f4:	00090513          	mv	a0,s2
 4f8:	01813083          	ld	ra,24(sp)
 4fc:	01013403          	ld	s0,16(sp)
 500:	00013903          	ld	s2,0(sp)
 504:	02010113          	addi	sp,sp,32
 508:	00008067          	ret
    return -1;
 50c:	fff00913          	li	s2,-1
 510:	fe5ff06f          	j	4f4 <stat+0x44>

0000000000000514 <atoi>:

int
atoi(const char *s)
{
 514:	ff010113          	addi	sp,sp,-16
 518:	00813423          	sd	s0,8(sp)
 51c:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 520:	00054683          	lbu	a3,0(a0)
 524:	fd06879b          	addiw	a5,a3,-48
 528:	0ff7f793          	zext.b	a5,a5
 52c:	00900613          	li	a2,9
 530:	04f66063          	bltu	a2,a5,570 <atoi+0x5c>
 534:	00050713          	mv	a4,a0
  n = 0;
 538:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 53c:	00170713          	addi	a4,a4,1
 540:	0025179b          	slliw	a5,a0,0x2
 544:	00a787bb          	addw	a5,a5,a0
 548:	0017979b          	slliw	a5,a5,0x1
 54c:	00d787bb          	addw	a5,a5,a3
 550:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 554:	00074683          	lbu	a3,0(a4)
 558:	fd06879b          	addiw	a5,a3,-48
 55c:	0ff7f793          	zext.b	a5,a5
 560:	fcf67ee3          	bgeu	a2,a5,53c <atoi+0x28>
  return n;
}
 564:	00813403          	ld	s0,8(sp)
 568:	01010113          	addi	sp,sp,16
 56c:	00008067          	ret
  n = 0;
 570:	00000513          	li	a0,0
 574:	ff1ff06f          	j	564 <atoi+0x50>

0000000000000578 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 578:	ff010113          	addi	sp,sp,-16
 57c:	00813423          	sd	s0,8(sp)
 580:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 584:	02b57c63          	bgeu	a0,a1,5bc <memmove+0x44>
    while(n-- > 0)
 588:	02c05463          	blez	a2,5b0 <memmove+0x38>
 58c:	02061613          	slli	a2,a2,0x20
 590:	02065613          	srli	a2,a2,0x20
 594:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 598:	00050713          	mv	a4,a0
      *dst++ = *src++;
 59c:	00158593          	addi	a1,a1,1
 5a0:	00170713          	addi	a4,a4,1
 5a4:	fff5c683          	lbu	a3,-1(a1)
 5a8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5ac:	fef718e3          	bne	a4,a5,59c <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5b0:	00813403          	ld	s0,8(sp)
 5b4:	01010113          	addi	sp,sp,16
 5b8:	00008067          	ret
    dst += n;
 5bc:	00c50733          	add	a4,a0,a2
    src += n;
 5c0:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 5c4:	fec056e3          	blez	a2,5b0 <memmove+0x38>
 5c8:	fff6079b          	addiw	a5,a2,-1
 5cc:	02079793          	slli	a5,a5,0x20
 5d0:	0207d793          	srli	a5,a5,0x20
 5d4:	fff7c793          	not	a5,a5
 5d8:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 5dc:	fff58593          	addi	a1,a1,-1
 5e0:	fff70713          	addi	a4,a4,-1
 5e4:	0005c683          	lbu	a3,0(a1)
 5e8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5ec:	fee798e3          	bne	a5,a4,5dc <memmove+0x64>
 5f0:	fc1ff06f          	j	5b0 <memmove+0x38>

00000000000005f4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5f4:	ff010113          	addi	sp,sp,-16
 5f8:	00813423          	sd	s0,8(sp)
 5fc:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 600:	04060463          	beqz	a2,648 <memcmp+0x54>
 604:	fff6069b          	addiw	a3,a2,-1
 608:	02069693          	slli	a3,a3,0x20
 60c:	0206d693          	srli	a3,a3,0x20
 610:	00168693          	addi	a3,a3,1
 614:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 618:	00054783          	lbu	a5,0(a0)
 61c:	0005c703          	lbu	a4,0(a1)
 620:	00e79c63          	bne	a5,a4,638 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 624:	00150513          	addi	a0,a0,1
    p2++;
 628:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
 62c:	fed516e3          	bne	a0,a3,618 <memcmp+0x24>
  }
  return 0;
 630:	00000513          	li	a0,0
 634:	0080006f          	j	63c <memcmp+0x48>
      return *p1 - *p2;
 638:	40e7853b          	subw	a0,a5,a4
}
 63c:	00813403          	ld	s0,8(sp)
 640:	01010113          	addi	sp,sp,16
 644:	00008067          	ret
  return 0;
 648:	00000513          	li	a0,0
 64c:	ff1ff06f          	j	63c <memcmp+0x48>

0000000000000650 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 650:	ff010113          	addi	sp,sp,-16
 654:	00113423          	sd	ra,8(sp)
 658:	00813023          	sd	s0,0(sp)
 65c:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
 660:	f19ff0ef          	jal	578 <memmove>
}
 664:	00813083          	ld	ra,8(sp)
 668:	00013403          	ld	s0,0(sp)
 66c:	01010113          	addi	sp,sp,16
 670:	00008067          	ret

0000000000000674 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 674:	00100893          	li	a7,1
 ecall
 678:	00000073          	ecall
 ret
 67c:	00008067          	ret

0000000000000680 <exit>:
.global exit
exit:
 li a7, SYS_exit
 680:	00200893          	li	a7,2
 ecall
 684:	00000073          	ecall
 ret
 688:	00008067          	ret

000000000000068c <wait>:
.global wait
wait:
 li a7, SYS_wait
 68c:	00300893          	li	a7,3
 ecall
 690:	00000073          	ecall
 ret
 694:	00008067          	ret

0000000000000698 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 698:	00400893          	li	a7,4
 ecall
 69c:	00000073          	ecall
 ret
 6a0:	00008067          	ret

00000000000006a4 <read>:
.global read
read:
 li a7, SYS_read
 6a4:	00500893          	li	a7,5
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	00008067          	ret

00000000000006b0 <write>:
.global write
write:
 li a7, SYS_write
 6b0:	01000893          	li	a7,16
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	00008067          	ret

00000000000006bc <close>:
.global close
close:
 li a7, SYS_close
 6bc:	01500893          	li	a7,21
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	00008067          	ret

00000000000006c8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 6c8:	00600893          	li	a7,6
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	00008067          	ret

00000000000006d4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 6d4:	00700893          	li	a7,7
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	00008067          	ret

00000000000006e0 <open>:
.global open
open:
 li a7, SYS_open
 6e0:	00f00893          	li	a7,15
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	00008067          	ret

00000000000006ec <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6ec:	01100893          	li	a7,17
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	00008067          	ret

00000000000006f8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6f8:	01200893          	li	a7,18
 ecall
 6fc:	00000073          	ecall
 ret
 700:	00008067          	ret

0000000000000704 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 704:	00800893          	li	a7,8
 ecall
 708:	00000073          	ecall
 ret
 70c:	00008067          	ret

0000000000000710 <link>:
.global link
link:
 li a7, SYS_link
 710:	01300893          	li	a7,19
 ecall
 714:	00000073          	ecall
 ret
 718:	00008067          	ret

000000000000071c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 71c:	01400893          	li	a7,20
 ecall
 720:	00000073          	ecall
 ret
 724:	00008067          	ret

0000000000000728 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 728:	00900893          	li	a7,9
 ecall
 72c:	00000073          	ecall
 ret
 730:	00008067          	ret

0000000000000734 <dup>:
.global dup
dup:
 li a7, SYS_dup
 734:	00a00893          	li	a7,10
 ecall
 738:	00000073          	ecall
 ret
 73c:	00008067          	ret

0000000000000740 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 740:	00b00893          	li	a7,11
 ecall
 744:	00000073          	ecall
 ret
 748:	00008067          	ret

000000000000074c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 74c:	00c00893          	li	a7,12
 ecall
 750:	00000073          	ecall
 ret
 754:	00008067          	ret

0000000000000758 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 758:	00d00893          	li	a7,13
 ecall
 75c:	00000073          	ecall
 ret
 760:	00008067          	ret

0000000000000764 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 764:	00e00893          	li	a7,14
 ecall
 768:	00000073          	ecall
 ret
 76c:	00008067          	ret

0000000000000770 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 770:	fe010113          	addi	sp,sp,-32
 774:	00113c23          	sd	ra,24(sp)
 778:	00813823          	sd	s0,16(sp)
 77c:	02010413          	addi	s0,sp,32
 780:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 784:	00100613          	li	a2,1
 788:	fef40593          	addi	a1,s0,-17
 78c:	f25ff0ef          	jal	6b0 <write>
}
 790:	01813083          	ld	ra,24(sp)
 794:	01013403          	ld	s0,16(sp)
 798:	02010113          	addi	sp,sp,32
 79c:	00008067          	ret

00000000000007a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7a0:	fc010113          	addi	sp,sp,-64
 7a4:	02113c23          	sd	ra,56(sp)
 7a8:	02813823          	sd	s0,48(sp)
 7ac:	02913423          	sd	s1,40(sp)
 7b0:	04010413          	addi	s0,sp,64
 7b4:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7b8:	00068463          	beqz	a3,7c0 <printint+0x20>
 7bc:	0c05c263          	bltz	a1,880 <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7c0:	0005859b          	sext.w	a1,a1
  neg = 0;
 7c4:	00000893          	li	a7,0
 7c8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7cc:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7d0:	0006061b          	sext.w	a2,a2
 7d4:	00000517          	auipc	a0,0x0
 7d8:	75c50513          	addi	a0,a0,1884 # f30 <digits>
 7dc:	00070813          	mv	a6,a4
 7e0:	0017071b          	addiw	a4,a4,1
 7e4:	02c5f7bb          	remuw	a5,a1,a2
 7e8:	02079793          	slli	a5,a5,0x20
 7ec:	0207d793          	srli	a5,a5,0x20
 7f0:	00f507b3          	add	a5,a0,a5
 7f4:	0007c783          	lbu	a5,0(a5)
 7f8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7fc:	0005879b          	sext.w	a5,a1
 800:	02c5d5bb          	divuw	a1,a1,a2
 804:	00168693          	addi	a3,a3,1
 808:	fcc7fae3          	bgeu	a5,a2,7dc <printint+0x3c>
  if(neg)
 80c:	00088c63          	beqz	a7,824 <printint+0x84>
    buf[i++] = '-';
 810:	fd070793          	addi	a5,a4,-48
 814:	00878733          	add	a4,a5,s0
 818:	02d00793          	li	a5,45
 81c:	fef70823          	sb	a5,-16(a4)
 820:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 824:	04e05463          	blez	a4,86c <printint+0xcc>
 828:	03213023          	sd	s2,32(sp)
 82c:	01313c23          	sd	s3,24(sp)
 830:	fc040793          	addi	a5,s0,-64
 834:	00e78933          	add	s2,a5,a4
 838:	fff78993          	addi	s3,a5,-1
 83c:	00e989b3          	add	s3,s3,a4
 840:	fff7071b          	addiw	a4,a4,-1
 844:	02071713          	slli	a4,a4,0x20
 848:	02075713          	srli	a4,a4,0x20
 84c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 850:	fff94583          	lbu	a1,-1(s2)
 854:	00048513          	mv	a0,s1
 858:	f19ff0ef          	jal	770 <putc>
  while(--i >= 0)
 85c:	fff90913          	addi	s2,s2,-1
 860:	ff3918e3          	bne	s2,s3,850 <printint+0xb0>
 864:	02013903          	ld	s2,32(sp)
 868:	01813983          	ld	s3,24(sp)
}
 86c:	03813083          	ld	ra,56(sp)
 870:	03013403          	ld	s0,48(sp)
 874:	02813483          	ld	s1,40(sp)
 878:	04010113          	addi	sp,sp,64
 87c:	00008067          	ret
    x = -xx;
 880:	40b005bb          	negw	a1,a1
    neg = 1;
 884:	00100893          	li	a7,1
    x = -xx;
 888:	f41ff06f          	j	7c8 <printint+0x28>

000000000000088c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 88c:	fa010113          	addi	sp,sp,-96
 890:	04113c23          	sd	ra,88(sp)
 894:	04813823          	sd	s0,80(sp)
 898:	05213023          	sd	s2,64(sp)
 89c:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8a0:	0005c903          	lbu	s2,0(a1)
 8a4:	36090463          	beqz	s2,c0c <vprintf+0x380>
 8a8:	04913423          	sd	s1,72(sp)
 8ac:	03313c23          	sd	s3,56(sp)
 8b0:	03413823          	sd	s4,48(sp)
 8b4:	03513423          	sd	s5,40(sp)
 8b8:	03613023          	sd	s6,32(sp)
 8bc:	01713c23          	sd	s7,24(sp)
 8c0:	01813823          	sd	s8,16(sp)
 8c4:	01913423          	sd	s9,8(sp)
 8c8:	00050b13          	mv	s6,a0
 8cc:	00058a13          	mv	s4,a1
 8d0:	00060b93          	mv	s7,a2
  state = 0;
 8d4:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
 8d8:	00000493          	li	s1,0
 8dc:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 8e0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 8e4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 8e8:	06c00c93          	li	s9,108
 8ec:	02c0006f          	j	918 <vprintf+0x8c>
        putc(fd, c0);
 8f0:	00090593          	mv	a1,s2
 8f4:	000b0513          	mv	a0,s6
 8f8:	e79ff0ef          	jal	770 <putc>
 8fc:	0080006f          	j	904 <vprintf+0x78>
    } else if(state == '%'){
 900:	03598663          	beq	s3,s5,92c <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
 904:	0014849b          	addiw	s1,s1,1
 908:	00048713          	mv	a4,s1
 90c:	009a07b3          	add	a5,s4,s1
 910:	0007c903          	lbu	s2,0(a5)
 914:	2c090c63          	beqz	s2,bec <vprintf+0x360>
    c0 = fmt[i] & 0xff;
 918:	0009079b          	sext.w	a5,s2
    if(state == 0){
 91c:	fe0992e3          	bnez	s3,900 <vprintf+0x74>
      if(c0 == '%'){
 920:	fd5798e3          	bne	a5,s5,8f0 <vprintf+0x64>
        state = '%';
 924:	00078993          	mv	s3,a5
 928:	fddff06f          	j	904 <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
 92c:	00ea06b3          	add	a3,s4,a4
 930:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 934:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 938:	00068663          	beqz	a3,944 <vprintf+0xb8>
 93c:	00ea0733          	add	a4,s4,a4
 940:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 944:	05878263          	beq	a5,s8,988 <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
 948:	07978263          	beq	a5,s9,9ac <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 94c:	07500713          	li	a4,117
 950:	12e78663          	beq	a5,a4,a7c <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 954:	07800713          	li	a4,120
 958:	18e78c63          	beq	a5,a4,af0 <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 95c:	07000713          	li	a4,112
 960:	1ce78e63          	beq	a5,a4,b3c <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 964:	07300713          	li	a4,115
 968:	22e78a63          	beq	a5,a4,b9c <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 96c:	02500713          	li	a4,37
 970:	04e79e63          	bne	a5,a4,9cc <vprintf+0x140>
        putc(fd, '%');
 974:	02500593          	li	a1,37
 978:	000b0513          	mv	a0,s6
 97c:	df5ff0ef          	jal	770 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 980:	00000993          	li	s3,0
 984:	f81ff06f          	j	904 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
 988:	008b8913          	addi	s2,s7,8
 98c:	00100693          	li	a3,1
 990:	00a00613          	li	a2,10
 994:	000ba583          	lw	a1,0(s7)
 998:	000b0513          	mv	a0,s6
 99c:	e05ff0ef          	jal	7a0 <printint>
 9a0:	00090b93          	mv	s7,s2
      state = 0;
 9a4:	00000993          	li	s3,0
 9a8:	f5dff06f          	j	904 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
 9ac:	06400793          	li	a5,100
 9b0:	02f68e63          	beq	a3,a5,9ec <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9b4:	06c00793          	li	a5,108
 9b8:	04f68e63          	beq	a3,a5,a14 <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
 9bc:	07500793          	li	a5,117
 9c0:	0ef68063          	beq	a3,a5,aa0 <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
 9c4:	07800793          	li	a5,120
 9c8:	14f68663          	beq	a3,a5,b14 <vprintf+0x288>
        putc(fd, '%');
 9cc:	02500593          	li	a1,37
 9d0:	000b0513          	mv	a0,s6
 9d4:	d9dff0ef          	jal	770 <putc>
        putc(fd, c0);
 9d8:	00090593          	mv	a1,s2
 9dc:	000b0513          	mv	a0,s6
 9e0:	d91ff0ef          	jal	770 <putc>
      state = 0;
 9e4:	00000993          	li	s3,0
 9e8:	f1dff06f          	j	904 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9ec:	008b8913          	addi	s2,s7,8
 9f0:	00100693          	li	a3,1
 9f4:	00a00613          	li	a2,10
 9f8:	000ba583          	lw	a1,0(s7)
 9fc:	000b0513          	mv	a0,s6
 a00:	da1ff0ef          	jal	7a0 <printint>
        i += 1;
 a04:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 a08:	00090b93          	mv	s7,s2
      state = 0;
 a0c:	00000993          	li	s3,0
        i += 1;
 a10:	ef5ff06f          	j	904 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a14:	06400793          	li	a5,100
 a18:	02f60e63          	beq	a2,a5,a54 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a1c:	07500793          	li	a5,117
 a20:	0af60463          	beq	a2,a5,ac8 <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a24:	07800793          	li	a5,120
 a28:	faf612e3          	bne	a2,a5,9cc <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a2c:	008b8913          	addi	s2,s7,8
 a30:	00000693          	li	a3,0
 a34:	01000613          	li	a2,16
 a38:	000ba583          	lw	a1,0(s7)
 a3c:	000b0513          	mv	a0,s6
 a40:	d61ff0ef          	jal	7a0 <printint>
        i += 2;
 a44:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a48:	00090b93          	mv	s7,s2
      state = 0;
 a4c:	00000993          	li	s3,0
        i += 2;
 a50:	eb5ff06f          	j	904 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a54:	008b8913          	addi	s2,s7,8
 a58:	00100693          	li	a3,1
 a5c:	00a00613          	li	a2,10
 a60:	000ba583          	lw	a1,0(s7)
 a64:	000b0513          	mv	a0,s6
 a68:	d39ff0ef          	jal	7a0 <printint>
        i += 2;
 a6c:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a70:	00090b93          	mv	s7,s2
      state = 0;
 a74:	00000993          	li	s3,0
        i += 2;
 a78:	e8dff06f          	j	904 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
 a7c:	008b8913          	addi	s2,s7,8
 a80:	00000693          	li	a3,0
 a84:	00a00613          	li	a2,10
 a88:	000ba583          	lw	a1,0(s7)
 a8c:	000b0513          	mv	a0,s6
 a90:	d11ff0ef          	jal	7a0 <printint>
 a94:	00090b93          	mv	s7,s2
      state = 0;
 a98:	00000993          	li	s3,0
 a9c:	e69ff06f          	j	904 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 aa0:	008b8913          	addi	s2,s7,8
 aa4:	00000693          	li	a3,0
 aa8:	00a00613          	li	a2,10
 aac:	000ba583          	lw	a1,0(s7)
 ab0:	000b0513          	mv	a0,s6
 ab4:	cedff0ef          	jal	7a0 <printint>
        i += 1;
 ab8:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 abc:	00090b93          	mv	s7,s2
      state = 0;
 ac0:	00000993          	li	s3,0
        i += 1;
 ac4:	e41ff06f          	j	904 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ac8:	008b8913          	addi	s2,s7,8
 acc:	00000693          	li	a3,0
 ad0:	00a00613          	li	a2,10
 ad4:	000ba583          	lw	a1,0(s7)
 ad8:	000b0513          	mv	a0,s6
 adc:	cc5ff0ef          	jal	7a0 <printint>
        i += 2;
 ae0:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 ae4:	00090b93          	mv	s7,s2
      state = 0;
 ae8:	00000993          	li	s3,0
        i += 2;
 aec:	e19ff06f          	j	904 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
 af0:	008b8913          	addi	s2,s7,8
 af4:	00000693          	li	a3,0
 af8:	01000613          	li	a2,16
 afc:	000ba583          	lw	a1,0(s7)
 b00:	000b0513          	mv	a0,s6
 b04:	c9dff0ef          	jal	7a0 <printint>
 b08:	00090b93          	mv	s7,s2
      state = 0;
 b0c:	00000993          	li	s3,0
 b10:	df5ff06f          	j	904 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
 b14:	008b8913          	addi	s2,s7,8
 b18:	00000693          	li	a3,0
 b1c:	01000613          	li	a2,16
 b20:	000ba583          	lw	a1,0(s7)
 b24:	000b0513          	mv	a0,s6
 b28:	c79ff0ef          	jal	7a0 <printint>
        i += 1;
 b2c:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 b30:	00090b93          	mv	s7,s2
      state = 0;
 b34:	00000993          	li	s3,0
        i += 1;
 b38:	dcdff06f          	j	904 <vprintf+0x78>
 b3c:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 b40:	008b8d13          	addi	s10,s7,8
 b44:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b48:	03000593          	li	a1,48
 b4c:	000b0513          	mv	a0,s6
 b50:	c21ff0ef          	jal	770 <putc>
  putc(fd, 'x');
 b54:	07800593          	li	a1,120
 b58:	000b0513          	mv	a0,s6
 b5c:	c15ff0ef          	jal	770 <putc>
 b60:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b64:	00000b97          	auipc	s7,0x0
 b68:	3ccb8b93          	addi	s7,s7,972 # f30 <digits>
 b6c:	03c9d793          	srli	a5,s3,0x3c
 b70:	00fb87b3          	add	a5,s7,a5
 b74:	0007c583          	lbu	a1,0(a5)
 b78:	000b0513          	mv	a0,s6
 b7c:	bf5ff0ef          	jal	770 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b80:	00499993          	slli	s3,s3,0x4
 b84:	fff9091b          	addiw	s2,s2,-1
 b88:	fe0912e3          	bnez	s2,b6c <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
 b8c:	000d0b93          	mv	s7,s10
      state = 0;
 b90:	00000993          	li	s3,0
 b94:	00013d03          	ld	s10,0(sp)
 b98:	d6dff06f          	j	904 <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
 b9c:	008b8993          	addi	s3,s7,8
 ba0:	000bb903          	ld	s2,0(s7)
 ba4:	02090663          	beqz	s2,bd0 <vprintf+0x344>
        for(; *s; s++)
 ba8:	00094583          	lbu	a1,0(s2)
 bac:	02058a63          	beqz	a1,be0 <vprintf+0x354>
          putc(fd, *s);
 bb0:	000b0513          	mv	a0,s6
 bb4:	bbdff0ef          	jal	770 <putc>
        for(; *s; s++)
 bb8:	00190913          	addi	s2,s2,1
 bbc:	00094583          	lbu	a1,0(s2)
 bc0:	fe0598e3          	bnez	a1,bb0 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 bc4:	00098b93          	mv	s7,s3
      state = 0;
 bc8:	00000993          	li	s3,0
 bcc:	d39ff06f          	j	904 <vprintf+0x78>
          s = "(null)";
 bd0:	00000917          	auipc	s2,0x0
 bd4:	35890913          	addi	s2,s2,856 # f28 <malloc+0x1c4>
        for(; *s; s++)
 bd8:	02800593          	li	a1,40
 bdc:	fd5ff06f          	j	bb0 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 be0:	00098b93          	mv	s7,s3
      state = 0;
 be4:	00000993          	li	s3,0
 be8:	d1dff06f          	j	904 <vprintf+0x78>
 bec:	04813483          	ld	s1,72(sp)
 bf0:	03813983          	ld	s3,56(sp)
 bf4:	03013a03          	ld	s4,48(sp)
 bf8:	02813a83          	ld	s5,40(sp)
 bfc:	02013b03          	ld	s6,32(sp)
 c00:	01813b83          	ld	s7,24(sp)
 c04:	01013c03          	ld	s8,16(sp)
 c08:	00813c83          	ld	s9,8(sp)
    }
  }
}
 c0c:	05813083          	ld	ra,88(sp)
 c10:	05013403          	ld	s0,80(sp)
 c14:	04013903          	ld	s2,64(sp)
 c18:	06010113          	addi	sp,sp,96
 c1c:	00008067          	ret

0000000000000c20 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c20:	fb010113          	addi	sp,sp,-80
 c24:	00113c23          	sd	ra,24(sp)
 c28:	00813823          	sd	s0,16(sp)
 c2c:	02010413          	addi	s0,sp,32
 c30:	00c43023          	sd	a2,0(s0)
 c34:	00d43423          	sd	a3,8(s0)
 c38:	00e43823          	sd	a4,16(s0)
 c3c:	00f43c23          	sd	a5,24(s0)
 c40:	03043023          	sd	a6,32(s0)
 c44:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c48:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c4c:	00040613          	mv	a2,s0
 c50:	c3dff0ef          	jal	88c <vprintf>
}
 c54:	01813083          	ld	ra,24(sp)
 c58:	01013403          	ld	s0,16(sp)
 c5c:	05010113          	addi	sp,sp,80
 c60:	00008067          	ret

0000000000000c64 <printf>:

void
printf(const char *fmt, ...)
{
 c64:	fa010113          	addi	sp,sp,-96
 c68:	00113c23          	sd	ra,24(sp)
 c6c:	00813823          	sd	s0,16(sp)
 c70:	02010413          	addi	s0,sp,32
 c74:	00b43423          	sd	a1,8(s0)
 c78:	00c43823          	sd	a2,16(s0)
 c7c:	00d43c23          	sd	a3,24(s0)
 c80:	02e43023          	sd	a4,32(s0)
 c84:	02f43423          	sd	a5,40(s0)
 c88:	03043823          	sd	a6,48(s0)
 c8c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c90:	00840613          	addi	a2,s0,8
 c94:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 c98:	00050593          	mv	a1,a0
 c9c:	00100513          	li	a0,1
 ca0:	bedff0ef          	jal	88c <vprintf>
}
 ca4:	01813083          	ld	ra,24(sp)
 ca8:	01013403          	ld	s0,16(sp)
 cac:	06010113          	addi	sp,sp,96
 cb0:	00008067          	ret

0000000000000cb4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cb4:	ff010113          	addi	sp,sp,-16
 cb8:	00813423          	sd	s0,8(sp)
 cbc:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 cc0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cc4:	00000797          	auipc	a5,0x0
 cc8:	33c7b783          	ld	a5,828(a5) # 1000 <freep>
 ccc:	0400006f          	j	d0c <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 cd0:	00862703          	lw	a4,8(a2)
 cd4:	00b7073b          	addw	a4,a4,a1
 cd8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 cdc:	0007b703          	ld	a4,0(a5)
 ce0:	00073603          	ld	a2,0(a4)
 ce4:	0500006f          	j	d34 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ce8:	ff852703          	lw	a4,-8(a0)
 cec:	00c7073b          	addw	a4,a4,a2
 cf0:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 cf4:	ff053683          	ld	a3,-16(a0)
 cf8:	0540006f          	j	d4c <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cfc:	0007b703          	ld	a4,0(a5)
 d00:	00e7e463          	bltu	a5,a4,d08 <free+0x54>
 d04:	00e6ec63          	bltu	a3,a4,d1c <free+0x68>
{
 d08:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d0c:	fed7f8e3          	bgeu	a5,a3,cfc <free+0x48>
 d10:	0007b703          	ld	a4,0(a5)
 d14:	00e6e463          	bltu	a3,a4,d1c <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d18:	fee7e8e3          	bltu	a5,a4,d08 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 d1c:	ff852583          	lw	a1,-8(a0)
 d20:	0007b603          	ld	a2,0(a5)
 d24:	02059813          	slli	a6,a1,0x20
 d28:	01c85713          	srli	a4,a6,0x1c
 d2c:	00e68733          	add	a4,a3,a4
 d30:	fae600e3          	beq	a2,a4,cd0 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 d34:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d38:	0087a603          	lw	a2,8(a5)
 d3c:	02061593          	slli	a1,a2,0x20
 d40:	01c5d713          	srli	a4,a1,0x1c
 d44:	00e78733          	add	a4,a5,a4
 d48:	fae680e3          	beq	a3,a4,ce8 <free+0x34>
    p->s.ptr = bp->s.ptr;
 d4c:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d50:	00000717          	auipc	a4,0x0
 d54:	2af73823          	sd	a5,688(a4) # 1000 <freep>
}
 d58:	00813403          	ld	s0,8(sp)
 d5c:	01010113          	addi	sp,sp,16
 d60:	00008067          	ret

0000000000000d64 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d64:	fc010113          	addi	sp,sp,-64
 d68:	02113c23          	sd	ra,56(sp)
 d6c:	02813823          	sd	s0,48(sp)
 d70:	02913423          	sd	s1,40(sp)
 d74:	01313c23          	sd	s3,24(sp)
 d78:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d7c:	02051493          	slli	s1,a0,0x20
 d80:	0204d493          	srli	s1,s1,0x20
 d84:	00f48493          	addi	s1,s1,15
 d88:	0044d493          	srli	s1,s1,0x4
 d8c:	0014899b          	addiw	s3,s1,1
 d90:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
 d94:	00000517          	auipc	a0,0x0
 d98:	26c53503          	ld	a0,620(a0) # 1000 <freep>
 d9c:	04050663          	beqz	a0,de8 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 da0:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 da4:	0087a703          	lw	a4,8(a5)
 da8:	0c977c63          	bgeu	a4,s1,e80 <malloc+0x11c>
 dac:	03213023          	sd	s2,32(sp)
 db0:	01413823          	sd	s4,16(sp)
 db4:	01513423          	sd	s5,8(sp)
 db8:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
 dbc:	00098a13          	mv	s4,s3
 dc0:	0009871b          	sext.w	a4,s3
 dc4:	000016b7          	lui	a3,0x1
 dc8:	00d77463          	bgeu	a4,a3,dd0 <malloc+0x6c>
 dcc:	00001a37          	lui	s4,0x1
 dd0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 dd4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 dd8:	00000917          	auipc	s2,0x0
 ddc:	22890913          	addi	s2,s2,552 # 1000 <freep>
  if(p == (char*)-1)
 de0:	fff00a93          	li	s5,-1
 de4:	05c0006f          	j	e40 <malloc+0xdc>
 de8:	03213023          	sd	s2,32(sp)
 dec:	01413823          	sd	s4,16(sp)
 df0:	01513423          	sd	s5,8(sp)
 df4:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 df8:	00000797          	auipc	a5,0x0
 dfc:	21878793          	addi	a5,a5,536 # 1010 <base>
 e00:	00000717          	auipc	a4,0x0
 e04:	20f73023          	sd	a5,512(a4) # 1000 <freep>
 e08:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 e0c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 e10:	fadff06f          	j	dbc <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
 e14:	0007b703          	ld	a4,0(a5)
 e18:	00e53023          	sd	a4,0(a0)
 e1c:	0800006f          	j	e9c <malloc+0x138>
  hp->s.size = nu;
 e20:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 e24:	01050513          	addi	a0,a0,16
 e28:	e8dff0ef          	jal	cb4 <free>
  return freep;
 e2c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 e30:	08050863          	beqz	a0,ec0 <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e34:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 e38:	0087a703          	lw	a4,8(a5)
 e3c:	02977a63          	bgeu	a4,s1,e70 <malloc+0x10c>
    if(p == freep)
 e40:	00093703          	ld	a4,0(s2)
 e44:	00078513          	mv	a0,a5
 e48:	fef716e3          	bne	a4,a5,e34 <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
 e4c:	000a0513          	mv	a0,s4
 e50:	8fdff0ef          	jal	74c <sbrk>
  if(p == (char*)-1)
 e54:	fd5516e3          	bne	a0,s5,e20 <malloc+0xbc>
        return 0;
 e58:	00000513          	li	a0,0
 e5c:	02013903          	ld	s2,32(sp)
 e60:	01013a03          	ld	s4,16(sp)
 e64:	00813a83          	ld	s5,8(sp)
 e68:	00013b03          	ld	s6,0(sp)
 e6c:	03c0006f          	j	ea8 <malloc+0x144>
 e70:	02013903          	ld	s2,32(sp)
 e74:	01013a03          	ld	s4,16(sp)
 e78:	00813a83          	ld	s5,8(sp)
 e7c:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
 e80:	f8e48ae3          	beq	s1,a4,e14 <malloc+0xb0>
        p->s.size -= nunits;
 e84:	4137073b          	subw	a4,a4,s3
 e88:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 e8c:	02071693          	slli	a3,a4,0x20
 e90:	01c6d713          	srli	a4,a3,0x1c
 e94:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 e98:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 e9c:	00000717          	auipc	a4,0x0
 ea0:	16a73223          	sd	a0,356(a4) # 1000 <freep>
      return (void*)(p + 1);
 ea4:	01078513          	addi	a0,a5,16
  }
}
 ea8:	03813083          	ld	ra,56(sp)
 eac:	03013403          	ld	s0,48(sp)
 eb0:	02813483          	ld	s1,40(sp)
 eb4:	01813983          	ld	s3,24(sp)
 eb8:	04010113          	addi	sp,sp,64
 ebc:	00008067          	ret
 ec0:	02013903          	ld	s2,32(sp)
 ec4:	01013a03          	ld	s4,16(sp)
 ec8:	00813a83          	ld	s5,8(sp)
 ecc:	00013b03          	ld	s6,0(sp)
 ed0:	fd9ff06f          	j	ea8 <malloc+0x144>
