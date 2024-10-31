
user/_wc:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	f8010113          	addi	sp,sp,-128
   4:	06113c23          	sd	ra,120(sp)
   8:	06813823          	sd	s0,112(sp)
   c:	06913423          	sd	s1,104(sp)
  10:	07213023          	sd	s2,96(sp)
  14:	05313c23          	sd	s3,88(sp)
  18:	05413823          	sd	s4,80(sp)
  1c:	05513423          	sd	s5,72(sp)
  20:	05613023          	sd	s6,64(sp)
  24:	03713c23          	sd	s7,56(sp)
  28:	03813823          	sd	s8,48(sp)
  2c:	03913423          	sd	s9,40(sp)
  30:	03a13023          	sd	s10,32(sp)
  34:	01b13c23          	sd	s11,24(sp)
  38:	08010413          	addi	s0,sp,128
  3c:	f8a43423          	sd	a0,-120(s0)
  40:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  44:	00000913          	li	s2,0
  l = w = c = 0;
  48:	00000d13          	li	s10,0
  4c:	00000c93          	li	s9,0
  50:	00000c13          	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  54:	00001d97          	auipc	s11,0x1
  58:	fbcd8d93          	addi	s11,s11,-68 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  5c:	00a00a93          	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  60:	00001a17          	auipc	s4,0x1
  64:	dc0a0a13          	addi	s4,s4,-576 # e20 <malloc+0x178>
        inword = 0;
  68:	00000b93          	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  6c:	0400006f          	j	ac <wc+0xac>
      if(strchr(" \r\t\n\v", buf[i]))
  70:	000a0513          	mv	a0,s4
  74:	288000ef          	jal	2fc <strchr>
  78:	02050063          	beqz	a0,98 <wc+0x98>
        inword = 0;
  7c:	000b8913          	mv	s2,s7
    for(i=0; i<n; i++){
  80:	00148493          	addi	s1,s1,1
  84:	03348263          	beq	s1,s3,a8 <wc+0xa8>
      if(buf[i] == '\n')
  88:	0004c583          	lbu	a1,0(s1)
  8c:	ff5592e3          	bne	a1,s5,70 <wc+0x70>
        l++;
  90:	001c0c1b          	addiw	s8,s8,1
  94:	fddff06f          	j	70 <wc+0x70>
      else if(!inword){
  98:	fe0914e3          	bnez	s2,80 <wc+0x80>
        w++;
  9c:	001c8c9b          	addiw	s9,s9,1
        inword = 1;
  a0:	00100913          	li	s2,1
  a4:	fddff06f          	j	80 <wc+0x80>
  a8:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  ac:	20000613          	li	a2,512
  b0:	000d8593          	mv	a1,s11
  b4:	f8843503          	ld	a0,-120(s0)
  b8:	530000ef          	jal	5e8 <read>
  bc:	00050b13          	mv	s6,a0
  c0:	00a05a63          	blez	a0,d4 <wc+0xd4>
    for(i=0; i<n; i++){
  c4:	00001497          	auipc	s1,0x1
  c8:	f4c48493          	addi	s1,s1,-180 # 1010 <buf>
  cc:	009509b3          	add	s3,a0,s1
  d0:	fb9ff06f          	j	88 <wc+0x88>
      }
    }
  }
  if(n < 0){
  d4:	04054e63          	bltz	a0,130 <wc+0x130>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  d8:	f8043703          	ld	a4,-128(s0)
  dc:	000d0693          	mv	a3,s10
  e0:	000c8613          	mv	a2,s9
  e4:	000c0593          	mv	a1,s8
  e8:	00001517          	auipc	a0,0x1
  ec:	d5850513          	addi	a0,a0,-680 # e40 <malloc+0x198>
  f0:	2b9000ef          	jal	ba8 <printf>
}
  f4:	07813083          	ld	ra,120(sp)
  f8:	07013403          	ld	s0,112(sp)
  fc:	06813483          	ld	s1,104(sp)
 100:	06013903          	ld	s2,96(sp)
 104:	05813983          	ld	s3,88(sp)
 108:	05013a03          	ld	s4,80(sp)
 10c:	04813a83          	ld	s5,72(sp)
 110:	04013b03          	ld	s6,64(sp)
 114:	03813b83          	ld	s7,56(sp)
 118:	03013c03          	ld	s8,48(sp)
 11c:	02813c83          	ld	s9,40(sp)
 120:	02013d03          	ld	s10,32(sp)
 124:	01813d83          	ld	s11,24(sp)
 128:	08010113          	addi	sp,sp,128
 12c:	00008067          	ret
    printf("wc: read error\n");
 130:	00001517          	auipc	a0,0x1
 134:	d0050513          	addi	a0,a0,-768 # e30 <malloc+0x188>
 138:	271000ef          	jal	ba8 <printf>
    exit(1);
 13c:	00100513          	li	a0,1
 140:	484000ef          	jal	5c4 <exit>

0000000000000144 <main>:

int
main(int argc, char *argv[])
{
 144:	fd010113          	addi	sp,sp,-48
 148:	02113423          	sd	ra,40(sp)
 14c:	02813023          	sd	s0,32(sp)
 150:	03010413          	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
 154:	00100793          	li	a5,1
 158:	04a7de63          	bge	a5,a0,1b4 <main+0x70>
 15c:	00913c23          	sd	s1,24(sp)
 160:	01213823          	sd	s2,16(sp)
 164:	01313423          	sd	s3,8(sp)
 168:	00858913          	addi	s2,a1,8
 16c:	ffe5099b          	addiw	s3,a0,-2
 170:	02099793          	slli	a5,s3,0x20
 174:	01d7d993          	srli	s3,a5,0x1d
 178:	01058593          	addi	a1,a1,16
 17c:	00b989b3          	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 180:	00000593          	li	a1,0
 184:	00093503          	ld	a0,0(s2)
 188:	49c000ef          	jal	624 <open>
 18c:	00050493          	mv	s1,a0
 190:	04054463          	bltz	a0,1d8 <main+0x94>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 194:	00093583          	ld	a1,0(s2)
 198:	e69ff0ef          	jal	0 <wc>
    close(fd);
 19c:	00048513          	mv	a0,s1
 1a0:	460000ef          	jal	600 <close>
  for(i = 1; i < argc; i++){
 1a4:	00890913          	addi	s2,s2,8
 1a8:	fd391ce3          	bne	s2,s3,180 <main+0x3c>
  }
  exit(0);
 1ac:	00000513          	li	a0,0
 1b0:	414000ef          	jal	5c4 <exit>
 1b4:	00913c23          	sd	s1,24(sp)
 1b8:	01213823          	sd	s2,16(sp)
 1bc:	01313423          	sd	s3,8(sp)
    wc(0, "");
 1c0:	00001597          	auipc	a1,0x1
 1c4:	c6858593          	addi	a1,a1,-920 # e28 <malloc+0x180>
 1c8:	00000513          	li	a0,0
 1cc:	e35ff0ef          	jal	0 <wc>
    exit(0);
 1d0:	00000513          	li	a0,0
 1d4:	3f0000ef          	jal	5c4 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 1d8:	00093583          	ld	a1,0(s2)
 1dc:	00001517          	auipc	a0,0x1
 1e0:	c7450513          	addi	a0,a0,-908 # e50 <malloc+0x1a8>
 1e4:	1c5000ef          	jal	ba8 <printf>
      exit(1);
 1e8:	00100513          	li	a0,1
 1ec:	3d8000ef          	jal	5c4 <exit>

00000000000001f0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1f0:	ff010113          	addi	sp,sp,-16
 1f4:	00113423          	sd	ra,8(sp)
 1f8:	00813023          	sd	s0,0(sp)
 1fc:	01010413          	addi	s0,sp,16
  extern int main();
  main();
 200:	f45ff0ef          	jal	144 <main>
  exit(0);
 204:	00000513          	li	a0,0
 208:	3bc000ef          	jal	5c4 <exit>

000000000000020c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 20c:	ff010113          	addi	sp,sp,-16
 210:	00813423          	sd	s0,8(sp)
 214:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 218:	00050793          	mv	a5,a0
 21c:	00158593          	addi	a1,a1,1
 220:	00178793          	addi	a5,a5,1
 224:	fff5c703          	lbu	a4,-1(a1)
 228:	fee78fa3          	sb	a4,-1(a5)
 22c:	fe0718e3          	bnez	a4,21c <strcpy+0x10>
    ;
  return os;
}
 230:	00813403          	ld	s0,8(sp)
 234:	01010113          	addi	sp,sp,16
 238:	00008067          	ret

000000000000023c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 23c:	ff010113          	addi	sp,sp,-16
 240:	00813423          	sd	s0,8(sp)
 244:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
 248:	00054783          	lbu	a5,0(a0)
 24c:	00078e63          	beqz	a5,268 <strcmp+0x2c>
 250:	0005c703          	lbu	a4,0(a1)
 254:	00f71a63          	bne	a4,a5,268 <strcmp+0x2c>
    p++, q++;
 258:	00150513          	addi	a0,a0,1
 25c:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
 260:	00054783          	lbu	a5,0(a0)
 264:	fe0796e3          	bnez	a5,250 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 268:	0005c503          	lbu	a0,0(a1)
}
 26c:	40a7853b          	subw	a0,a5,a0
 270:	00813403          	ld	s0,8(sp)
 274:	01010113          	addi	sp,sp,16
 278:	00008067          	ret

000000000000027c <strlen>:

uint
strlen(const char *s)
{
 27c:	ff010113          	addi	sp,sp,-16
 280:	00813423          	sd	s0,8(sp)
 284:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 288:	00054783          	lbu	a5,0(a0)
 28c:	02078863          	beqz	a5,2bc <strlen+0x40>
 290:	00150513          	addi	a0,a0,1
 294:	00050793          	mv	a5,a0
 298:	00078693          	mv	a3,a5
 29c:	00178793          	addi	a5,a5,1
 2a0:	fff7c703          	lbu	a4,-1(a5)
 2a4:	fe071ae3          	bnez	a4,298 <strlen+0x1c>
 2a8:	40a6853b          	subw	a0,a3,a0
 2ac:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
 2b0:	00813403          	ld	s0,8(sp)
 2b4:	01010113          	addi	sp,sp,16
 2b8:	00008067          	ret
  for(n = 0; s[n]; n++)
 2bc:	00000513          	li	a0,0
 2c0:	ff1ff06f          	j	2b0 <strlen+0x34>

00000000000002c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c4:	ff010113          	addi	sp,sp,-16
 2c8:	00813423          	sd	s0,8(sp)
 2cc:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2d0:	02060063          	beqz	a2,2f0 <memset+0x2c>
 2d4:	00050793          	mv	a5,a0
 2d8:	02061613          	slli	a2,a2,0x20
 2dc:	02065613          	srli	a2,a2,0x20
 2e0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2e8:	00178793          	addi	a5,a5,1
 2ec:	fee79ce3          	bne	a5,a4,2e4 <memset+0x20>
  }
  return dst;
}
 2f0:	00813403          	ld	s0,8(sp)
 2f4:	01010113          	addi	sp,sp,16
 2f8:	00008067          	ret

00000000000002fc <strchr>:

char*
strchr(const char *s, char c)
{
 2fc:	ff010113          	addi	sp,sp,-16
 300:	00813423          	sd	s0,8(sp)
 304:	01010413          	addi	s0,sp,16
  for(; *s; s++)
 308:	00054783          	lbu	a5,0(a0)
 30c:	02078263          	beqz	a5,330 <strchr+0x34>
    if(*s == c)
 310:	00f58a63          	beq	a1,a5,324 <strchr+0x28>
  for(; *s; s++)
 314:	00150513          	addi	a0,a0,1
 318:	00054783          	lbu	a5,0(a0)
 31c:	fe079ae3          	bnez	a5,310 <strchr+0x14>
      return (char*)s;
  return 0;
 320:	00000513          	li	a0,0
}
 324:	00813403          	ld	s0,8(sp)
 328:	01010113          	addi	sp,sp,16
 32c:	00008067          	ret
  return 0;
 330:	00000513          	li	a0,0
 334:	ff1ff06f          	j	324 <strchr+0x28>

0000000000000338 <gets>:

char*
gets(char *buf, int max)
{
 338:	fa010113          	addi	sp,sp,-96
 33c:	04113c23          	sd	ra,88(sp)
 340:	04813823          	sd	s0,80(sp)
 344:	04913423          	sd	s1,72(sp)
 348:	05213023          	sd	s2,64(sp)
 34c:	03313c23          	sd	s3,56(sp)
 350:	03413823          	sd	s4,48(sp)
 354:	03513423          	sd	s5,40(sp)
 358:	03613023          	sd	s6,32(sp)
 35c:	01713c23          	sd	s7,24(sp)
 360:	06010413          	addi	s0,sp,96
 364:	00050b93          	mv	s7,a0
 368:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 36c:	00050913          	mv	s2,a0
 370:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 374:	00a00a93          	li	s5,10
 378:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 37c:	00048993          	mv	s3,s1
 380:	0014849b          	addiw	s1,s1,1
 384:	0344dc63          	bge	s1,s4,3bc <gets+0x84>
    cc = read(0, &c, 1);
 388:	00100613          	li	a2,1
 38c:	faf40593          	addi	a1,s0,-81
 390:	00000513          	li	a0,0
 394:	254000ef          	jal	5e8 <read>
    if(cc < 1)
 398:	02a05263          	blez	a0,3bc <gets+0x84>
    buf[i++] = c;
 39c:	faf44783          	lbu	a5,-81(s0)
 3a0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3a4:	01578a63          	beq	a5,s5,3b8 <gets+0x80>
 3a8:	00190913          	addi	s2,s2,1
 3ac:	fd6798e3          	bne	a5,s6,37c <gets+0x44>
    buf[i++] = c;
 3b0:	00048993          	mv	s3,s1
 3b4:	0080006f          	j	3bc <gets+0x84>
 3b8:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3bc:	013b89b3          	add	s3,s7,s3
 3c0:	00098023          	sb	zero,0(s3)
  return buf;
}
 3c4:	000b8513          	mv	a0,s7
 3c8:	05813083          	ld	ra,88(sp)
 3cc:	05013403          	ld	s0,80(sp)
 3d0:	04813483          	ld	s1,72(sp)
 3d4:	04013903          	ld	s2,64(sp)
 3d8:	03813983          	ld	s3,56(sp)
 3dc:	03013a03          	ld	s4,48(sp)
 3e0:	02813a83          	ld	s5,40(sp)
 3e4:	02013b03          	ld	s6,32(sp)
 3e8:	01813b83          	ld	s7,24(sp)
 3ec:	06010113          	addi	sp,sp,96
 3f0:	00008067          	ret

00000000000003f4 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f4:	fe010113          	addi	sp,sp,-32
 3f8:	00113c23          	sd	ra,24(sp)
 3fc:	00813823          	sd	s0,16(sp)
 400:	01213023          	sd	s2,0(sp)
 404:	02010413          	addi	s0,sp,32
 408:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 40c:	00000593          	li	a1,0
 410:	214000ef          	jal	624 <open>
  if(fd < 0)
 414:	02054e63          	bltz	a0,450 <stat+0x5c>
 418:	00913423          	sd	s1,8(sp)
 41c:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 420:	00090593          	mv	a1,s2
 424:	224000ef          	jal	648 <fstat>
 428:	00050913          	mv	s2,a0
  close(fd);
 42c:	00048513          	mv	a0,s1
 430:	1d0000ef          	jal	600 <close>
  return r;
 434:	00813483          	ld	s1,8(sp)
}
 438:	00090513          	mv	a0,s2
 43c:	01813083          	ld	ra,24(sp)
 440:	01013403          	ld	s0,16(sp)
 444:	00013903          	ld	s2,0(sp)
 448:	02010113          	addi	sp,sp,32
 44c:	00008067          	ret
    return -1;
 450:	fff00913          	li	s2,-1
 454:	fe5ff06f          	j	438 <stat+0x44>

0000000000000458 <atoi>:

int
atoi(const char *s)
{
 458:	ff010113          	addi	sp,sp,-16
 45c:	00813423          	sd	s0,8(sp)
 460:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 464:	00054683          	lbu	a3,0(a0)
 468:	fd06879b          	addiw	a5,a3,-48
 46c:	0ff7f793          	zext.b	a5,a5
 470:	00900613          	li	a2,9
 474:	04f66063          	bltu	a2,a5,4b4 <atoi+0x5c>
 478:	00050713          	mv	a4,a0
  n = 0;
 47c:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 480:	00170713          	addi	a4,a4,1
 484:	0025179b          	slliw	a5,a0,0x2
 488:	00a787bb          	addw	a5,a5,a0
 48c:	0017979b          	slliw	a5,a5,0x1
 490:	00d787bb          	addw	a5,a5,a3
 494:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 498:	00074683          	lbu	a3,0(a4)
 49c:	fd06879b          	addiw	a5,a3,-48
 4a0:	0ff7f793          	zext.b	a5,a5
 4a4:	fcf67ee3          	bgeu	a2,a5,480 <atoi+0x28>
  return n;
}
 4a8:	00813403          	ld	s0,8(sp)
 4ac:	01010113          	addi	sp,sp,16
 4b0:	00008067          	ret
  n = 0;
 4b4:	00000513          	li	a0,0
 4b8:	ff1ff06f          	j	4a8 <atoi+0x50>

00000000000004bc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4bc:	ff010113          	addi	sp,sp,-16
 4c0:	00813423          	sd	s0,8(sp)
 4c4:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4c8:	02b57c63          	bgeu	a0,a1,500 <memmove+0x44>
    while(n-- > 0)
 4cc:	02c05463          	blez	a2,4f4 <memmove+0x38>
 4d0:	02061613          	slli	a2,a2,0x20
 4d4:	02065613          	srli	a2,a2,0x20
 4d8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4dc:	00050713          	mv	a4,a0
      *dst++ = *src++;
 4e0:	00158593          	addi	a1,a1,1
 4e4:	00170713          	addi	a4,a4,1
 4e8:	fff5c683          	lbu	a3,-1(a1)
 4ec:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4f0:	fef718e3          	bne	a4,a5,4e0 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4f4:	00813403          	ld	s0,8(sp)
 4f8:	01010113          	addi	sp,sp,16
 4fc:	00008067          	ret
    dst += n;
 500:	00c50733          	add	a4,a0,a2
    src += n;
 504:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 508:	fec056e3          	blez	a2,4f4 <memmove+0x38>
 50c:	fff6079b          	addiw	a5,a2,-1
 510:	02079793          	slli	a5,a5,0x20
 514:	0207d793          	srli	a5,a5,0x20
 518:	fff7c793          	not	a5,a5
 51c:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 520:	fff58593          	addi	a1,a1,-1
 524:	fff70713          	addi	a4,a4,-1
 528:	0005c683          	lbu	a3,0(a1)
 52c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 530:	fee798e3          	bne	a5,a4,520 <memmove+0x64>
 534:	fc1ff06f          	j	4f4 <memmove+0x38>

0000000000000538 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 538:	ff010113          	addi	sp,sp,-16
 53c:	00813423          	sd	s0,8(sp)
 540:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 544:	04060463          	beqz	a2,58c <memcmp+0x54>
 548:	fff6069b          	addiw	a3,a2,-1
 54c:	02069693          	slli	a3,a3,0x20
 550:	0206d693          	srli	a3,a3,0x20
 554:	00168693          	addi	a3,a3,1
 558:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 55c:	00054783          	lbu	a5,0(a0)
 560:	0005c703          	lbu	a4,0(a1)
 564:	00e79c63          	bne	a5,a4,57c <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 568:	00150513          	addi	a0,a0,1
    p2++;
 56c:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
 570:	fed516e3          	bne	a0,a3,55c <memcmp+0x24>
  }
  return 0;
 574:	00000513          	li	a0,0
 578:	0080006f          	j	580 <memcmp+0x48>
      return *p1 - *p2;
 57c:	40e7853b          	subw	a0,a5,a4
}
 580:	00813403          	ld	s0,8(sp)
 584:	01010113          	addi	sp,sp,16
 588:	00008067          	ret
  return 0;
 58c:	00000513          	li	a0,0
 590:	ff1ff06f          	j	580 <memcmp+0x48>

0000000000000594 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 594:	ff010113          	addi	sp,sp,-16
 598:	00113423          	sd	ra,8(sp)
 59c:	00813023          	sd	s0,0(sp)
 5a0:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
 5a4:	f19ff0ef          	jal	4bc <memmove>
}
 5a8:	00813083          	ld	ra,8(sp)
 5ac:	00013403          	ld	s0,0(sp)
 5b0:	01010113          	addi	sp,sp,16
 5b4:	00008067          	ret

00000000000005b8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5b8:	00100893          	li	a7,1
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	00008067          	ret

00000000000005c4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5c4:	00200893          	li	a7,2
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	00008067          	ret

00000000000005d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5d0:	00300893          	li	a7,3
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	00008067          	ret

00000000000005dc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5dc:	00400893          	li	a7,4
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	00008067          	ret

00000000000005e8 <read>:
.global read
read:
 li a7, SYS_read
 5e8:	00500893          	li	a7,5
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	00008067          	ret

00000000000005f4 <write>:
.global write
write:
 li a7, SYS_write
 5f4:	01000893          	li	a7,16
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	00008067          	ret

0000000000000600 <close>:
.global close
close:
 li a7, SYS_close
 600:	01500893          	li	a7,21
 ecall
 604:	00000073          	ecall
 ret
 608:	00008067          	ret

000000000000060c <kill>:
.global kill
kill:
 li a7, SYS_kill
 60c:	00600893          	li	a7,6
 ecall
 610:	00000073          	ecall
 ret
 614:	00008067          	ret

0000000000000618 <exec>:
.global exec
exec:
 li a7, SYS_exec
 618:	00700893          	li	a7,7
 ecall
 61c:	00000073          	ecall
 ret
 620:	00008067          	ret

0000000000000624 <open>:
.global open
open:
 li a7, SYS_open
 624:	00f00893          	li	a7,15
 ecall
 628:	00000073          	ecall
 ret
 62c:	00008067          	ret

0000000000000630 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 630:	01100893          	li	a7,17
 ecall
 634:	00000073          	ecall
 ret
 638:	00008067          	ret

000000000000063c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 63c:	01200893          	li	a7,18
 ecall
 640:	00000073          	ecall
 ret
 644:	00008067          	ret

0000000000000648 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 648:	00800893          	li	a7,8
 ecall
 64c:	00000073          	ecall
 ret
 650:	00008067          	ret

0000000000000654 <link>:
.global link
link:
 li a7, SYS_link
 654:	01300893          	li	a7,19
 ecall
 658:	00000073          	ecall
 ret
 65c:	00008067          	ret

0000000000000660 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 660:	01400893          	li	a7,20
 ecall
 664:	00000073          	ecall
 ret
 668:	00008067          	ret

000000000000066c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 66c:	00900893          	li	a7,9
 ecall
 670:	00000073          	ecall
 ret
 674:	00008067          	ret

0000000000000678 <dup>:
.global dup
dup:
 li a7, SYS_dup
 678:	00a00893          	li	a7,10
 ecall
 67c:	00000073          	ecall
 ret
 680:	00008067          	ret

0000000000000684 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 684:	00b00893          	li	a7,11
 ecall
 688:	00000073          	ecall
 ret
 68c:	00008067          	ret

0000000000000690 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 690:	00c00893          	li	a7,12
 ecall
 694:	00000073          	ecall
 ret
 698:	00008067          	ret

000000000000069c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 69c:	00d00893          	li	a7,13
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	00008067          	ret

00000000000006a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6a8:	00e00893          	li	a7,14
 ecall
 6ac:	00000073          	ecall
 ret
 6b0:	00008067          	ret

00000000000006b4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6b4:	fe010113          	addi	sp,sp,-32
 6b8:	00113c23          	sd	ra,24(sp)
 6bc:	00813823          	sd	s0,16(sp)
 6c0:	02010413          	addi	s0,sp,32
 6c4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6c8:	00100613          	li	a2,1
 6cc:	fef40593          	addi	a1,s0,-17
 6d0:	f25ff0ef          	jal	5f4 <write>
}
 6d4:	01813083          	ld	ra,24(sp)
 6d8:	01013403          	ld	s0,16(sp)
 6dc:	02010113          	addi	sp,sp,32
 6e0:	00008067          	ret

00000000000006e4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6e4:	fc010113          	addi	sp,sp,-64
 6e8:	02113c23          	sd	ra,56(sp)
 6ec:	02813823          	sd	s0,48(sp)
 6f0:	02913423          	sd	s1,40(sp)
 6f4:	04010413          	addi	s0,sp,64
 6f8:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6fc:	00068463          	beqz	a3,704 <printint+0x20>
 700:	0c05c263          	bltz	a1,7c4 <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 704:	0005859b          	sext.w	a1,a1
  neg = 0;
 708:	00000893          	li	a7,0
 70c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 710:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 714:	0006061b          	sext.w	a2,a2
 718:	00000517          	auipc	a0,0x0
 71c:	75850513          	addi	a0,a0,1880 # e70 <digits>
 720:	00070813          	mv	a6,a4
 724:	0017071b          	addiw	a4,a4,1
 728:	02c5f7bb          	remuw	a5,a1,a2
 72c:	02079793          	slli	a5,a5,0x20
 730:	0207d793          	srli	a5,a5,0x20
 734:	00f507b3          	add	a5,a0,a5
 738:	0007c783          	lbu	a5,0(a5)
 73c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 740:	0005879b          	sext.w	a5,a1
 744:	02c5d5bb          	divuw	a1,a1,a2
 748:	00168693          	addi	a3,a3,1
 74c:	fcc7fae3          	bgeu	a5,a2,720 <printint+0x3c>
  if(neg)
 750:	00088c63          	beqz	a7,768 <printint+0x84>
    buf[i++] = '-';
 754:	fd070793          	addi	a5,a4,-48
 758:	00878733          	add	a4,a5,s0
 75c:	02d00793          	li	a5,45
 760:	fef70823          	sb	a5,-16(a4)
 764:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 768:	04e05463          	blez	a4,7b0 <printint+0xcc>
 76c:	03213023          	sd	s2,32(sp)
 770:	01313c23          	sd	s3,24(sp)
 774:	fc040793          	addi	a5,s0,-64
 778:	00e78933          	add	s2,a5,a4
 77c:	fff78993          	addi	s3,a5,-1
 780:	00e989b3          	add	s3,s3,a4
 784:	fff7071b          	addiw	a4,a4,-1
 788:	02071713          	slli	a4,a4,0x20
 78c:	02075713          	srli	a4,a4,0x20
 790:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 794:	fff94583          	lbu	a1,-1(s2)
 798:	00048513          	mv	a0,s1
 79c:	f19ff0ef          	jal	6b4 <putc>
  while(--i >= 0)
 7a0:	fff90913          	addi	s2,s2,-1
 7a4:	ff3918e3          	bne	s2,s3,794 <printint+0xb0>
 7a8:	02013903          	ld	s2,32(sp)
 7ac:	01813983          	ld	s3,24(sp)
}
 7b0:	03813083          	ld	ra,56(sp)
 7b4:	03013403          	ld	s0,48(sp)
 7b8:	02813483          	ld	s1,40(sp)
 7bc:	04010113          	addi	sp,sp,64
 7c0:	00008067          	ret
    x = -xx;
 7c4:	40b005bb          	negw	a1,a1
    neg = 1;
 7c8:	00100893          	li	a7,1
    x = -xx;
 7cc:	f41ff06f          	j	70c <printint+0x28>

00000000000007d0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7d0:	fa010113          	addi	sp,sp,-96
 7d4:	04113c23          	sd	ra,88(sp)
 7d8:	04813823          	sd	s0,80(sp)
 7dc:	05213023          	sd	s2,64(sp)
 7e0:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7e4:	0005c903          	lbu	s2,0(a1)
 7e8:	36090463          	beqz	s2,b50 <vprintf+0x380>
 7ec:	04913423          	sd	s1,72(sp)
 7f0:	03313c23          	sd	s3,56(sp)
 7f4:	03413823          	sd	s4,48(sp)
 7f8:	03513423          	sd	s5,40(sp)
 7fc:	03613023          	sd	s6,32(sp)
 800:	01713c23          	sd	s7,24(sp)
 804:	01813823          	sd	s8,16(sp)
 808:	01913423          	sd	s9,8(sp)
 80c:	00050b13          	mv	s6,a0
 810:	00058a13          	mv	s4,a1
 814:	00060b93          	mv	s7,a2
  state = 0;
 818:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
 81c:	00000493          	li	s1,0
 820:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 824:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 828:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 82c:	06c00c93          	li	s9,108
 830:	02c0006f          	j	85c <vprintf+0x8c>
        putc(fd, c0);
 834:	00090593          	mv	a1,s2
 838:	000b0513          	mv	a0,s6
 83c:	e79ff0ef          	jal	6b4 <putc>
 840:	0080006f          	j	848 <vprintf+0x78>
    } else if(state == '%'){
 844:	03598663          	beq	s3,s5,870 <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
 848:	0014849b          	addiw	s1,s1,1
 84c:	00048713          	mv	a4,s1
 850:	009a07b3          	add	a5,s4,s1
 854:	0007c903          	lbu	s2,0(a5)
 858:	2c090c63          	beqz	s2,b30 <vprintf+0x360>
    c0 = fmt[i] & 0xff;
 85c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 860:	fe0992e3          	bnez	s3,844 <vprintf+0x74>
      if(c0 == '%'){
 864:	fd5798e3          	bne	a5,s5,834 <vprintf+0x64>
        state = '%';
 868:	00078993          	mv	s3,a5
 86c:	fddff06f          	j	848 <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
 870:	00ea06b3          	add	a3,s4,a4
 874:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 878:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 87c:	00068663          	beqz	a3,888 <vprintf+0xb8>
 880:	00ea0733          	add	a4,s4,a4
 884:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 888:	05878263          	beq	a5,s8,8cc <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
 88c:	07978263          	beq	a5,s9,8f0 <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 890:	07500713          	li	a4,117
 894:	12e78663          	beq	a5,a4,9c0 <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 898:	07800713          	li	a4,120
 89c:	18e78c63          	beq	a5,a4,a34 <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 8a0:	07000713          	li	a4,112
 8a4:	1ce78e63          	beq	a5,a4,a80 <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 8a8:	07300713          	li	a4,115
 8ac:	22e78a63          	beq	a5,a4,ae0 <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 8b0:	02500713          	li	a4,37
 8b4:	04e79e63          	bne	a5,a4,910 <vprintf+0x140>
        putc(fd, '%');
 8b8:	02500593          	li	a1,37
 8bc:	000b0513          	mv	a0,s6
 8c0:	df5ff0ef          	jal	6b4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 8c4:	00000993          	li	s3,0
 8c8:	f81ff06f          	j	848 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
 8cc:	008b8913          	addi	s2,s7,8
 8d0:	00100693          	li	a3,1
 8d4:	00a00613          	li	a2,10
 8d8:	000ba583          	lw	a1,0(s7)
 8dc:	000b0513          	mv	a0,s6
 8e0:	e05ff0ef          	jal	6e4 <printint>
 8e4:	00090b93          	mv	s7,s2
      state = 0;
 8e8:	00000993          	li	s3,0
 8ec:	f5dff06f          	j	848 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
 8f0:	06400793          	li	a5,100
 8f4:	02f68e63          	beq	a3,a5,930 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8f8:	06c00793          	li	a5,108
 8fc:	04f68e63          	beq	a3,a5,958 <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
 900:	07500793          	li	a5,117
 904:	0ef68063          	beq	a3,a5,9e4 <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
 908:	07800793          	li	a5,120
 90c:	14f68663          	beq	a3,a5,a58 <vprintf+0x288>
        putc(fd, '%');
 910:	02500593          	li	a1,37
 914:	000b0513          	mv	a0,s6
 918:	d9dff0ef          	jal	6b4 <putc>
        putc(fd, c0);
 91c:	00090593          	mv	a1,s2
 920:	000b0513          	mv	a0,s6
 924:	d91ff0ef          	jal	6b4 <putc>
      state = 0;
 928:	00000993          	li	s3,0
 92c:	f1dff06f          	j	848 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 930:	008b8913          	addi	s2,s7,8
 934:	00100693          	li	a3,1
 938:	00a00613          	li	a2,10
 93c:	000ba583          	lw	a1,0(s7)
 940:	000b0513          	mv	a0,s6
 944:	da1ff0ef          	jal	6e4 <printint>
        i += 1;
 948:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 94c:	00090b93          	mv	s7,s2
      state = 0;
 950:	00000993          	li	s3,0
        i += 1;
 954:	ef5ff06f          	j	848 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 958:	06400793          	li	a5,100
 95c:	02f60e63          	beq	a2,a5,998 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 960:	07500793          	li	a5,117
 964:	0af60463          	beq	a2,a5,a0c <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 968:	07800793          	li	a5,120
 96c:	faf612e3          	bne	a2,a5,910 <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
 970:	008b8913          	addi	s2,s7,8
 974:	00000693          	li	a3,0
 978:	01000613          	li	a2,16
 97c:	000ba583          	lw	a1,0(s7)
 980:	000b0513          	mv	a0,s6
 984:	d61ff0ef          	jal	6e4 <printint>
        i += 2;
 988:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 98c:	00090b93          	mv	s7,s2
      state = 0;
 990:	00000993          	li	s3,0
        i += 2;
 994:	eb5ff06f          	j	848 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 998:	008b8913          	addi	s2,s7,8
 99c:	00100693          	li	a3,1
 9a0:	00a00613          	li	a2,10
 9a4:	000ba583          	lw	a1,0(s7)
 9a8:	000b0513          	mv	a0,s6
 9ac:	d39ff0ef          	jal	6e4 <printint>
        i += 2;
 9b0:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 9b4:	00090b93          	mv	s7,s2
      state = 0;
 9b8:	00000993          	li	s3,0
        i += 2;
 9bc:	e8dff06f          	j	848 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
 9c0:	008b8913          	addi	s2,s7,8
 9c4:	00000693          	li	a3,0
 9c8:	00a00613          	li	a2,10
 9cc:	000ba583          	lw	a1,0(s7)
 9d0:	000b0513          	mv	a0,s6
 9d4:	d11ff0ef          	jal	6e4 <printint>
 9d8:	00090b93          	mv	s7,s2
      state = 0;
 9dc:	00000993          	li	s3,0
 9e0:	e69ff06f          	j	848 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9e4:	008b8913          	addi	s2,s7,8
 9e8:	00000693          	li	a3,0
 9ec:	00a00613          	li	a2,10
 9f0:	000ba583          	lw	a1,0(s7)
 9f4:	000b0513          	mv	a0,s6
 9f8:	cedff0ef          	jal	6e4 <printint>
        i += 1;
 9fc:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a00:	00090b93          	mv	s7,s2
      state = 0;
 a04:	00000993          	li	s3,0
        i += 1;
 a08:	e41ff06f          	j	848 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a0c:	008b8913          	addi	s2,s7,8
 a10:	00000693          	li	a3,0
 a14:	00a00613          	li	a2,10
 a18:	000ba583          	lw	a1,0(s7)
 a1c:	000b0513          	mv	a0,s6
 a20:	cc5ff0ef          	jal	6e4 <printint>
        i += 2;
 a24:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a28:	00090b93          	mv	s7,s2
      state = 0;
 a2c:	00000993          	li	s3,0
        i += 2;
 a30:	e19ff06f          	j	848 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
 a34:	008b8913          	addi	s2,s7,8
 a38:	00000693          	li	a3,0
 a3c:	01000613          	li	a2,16
 a40:	000ba583          	lw	a1,0(s7)
 a44:	000b0513          	mv	a0,s6
 a48:	c9dff0ef          	jal	6e4 <printint>
 a4c:	00090b93          	mv	s7,s2
      state = 0;
 a50:	00000993          	li	s3,0
 a54:	df5ff06f          	j	848 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a58:	008b8913          	addi	s2,s7,8
 a5c:	00000693          	li	a3,0
 a60:	01000613          	li	a2,16
 a64:	000ba583          	lw	a1,0(s7)
 a68:	000b0513          	mv	a0,s6
 a6c:	c79ff0ef          	jal	6e4 <printint>
        i += 1;
 a70:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a74:	00090b93          	mv	s7,s2
      state = 0;
 a78:	00000993          	li	s3,0
        i += 1;
 a7c:	dcdff06f          	j	848 <vprintf+0x78>
 a80:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 a84:	008b8d13          	addi	s10,s7,8
 a88:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a8c:	03000593          	li	a1,48
 a90:	000b0513          	mv	a0,s6
 a94:	c21ff0ef          	jal	6b4 <putc>
  putc(fd, 'x');
 a98:	07800593          	li	a1,120
 a9c:	000b0513          	mv	a0,s6
 aa0:	c15ff0ef          	jal	6b4 <putc>
 aa4:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 aa8:	00000b97          	auipc	s7,0x0
 aac:	3c8b8b93          	addi	s7,s7,968 # e70 <digits>
 ab0:	03c9d793          	srli	a5,s3,0x3c
 ab4:	00fb87b3          	add	a5,s7,a5
 ab8:	0007c583          	lbu	a1,0(a5)
 abc:	000b0513          	mv	a0,s6
 ac0:	bf5ff0ef          	jal	6b4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 ac4:	00499993          	slli	s3,s3,0x4
 ac8:	fff9091b          	addiw	s2,s2,-1
 acc:	fe0912e3          	bnez	s2,ab0 <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
 ad0:	000d0b93          	mv	s7,s10
      state = 0;
 ad4:	00000993          	li	s3,0
 ad8:	00013d03          	ld	s10,0(sp)
 adc:	d6dff06f          	j	848 <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
 ae0:	008b8993          	addi	s3,s7,8
 ae4:	000bb903          	ld	s2,0(s7)
 ae8:	02090663          	beqz	s2,b14 <vprintf+0x344>
        for(; *s; s++)
 aec:	00094583          	lbu	a1,0(s2)
 af0:	02058a63          	beqz	a1,b24 <vprintf+0x354>
          putc(fd, *s);
 af4:	000b0513          	mv	a0,s6
 af8:	bbdff0ef          	jal	6b4 <putc>
        for(; *s; s++)
 afc:	00190913          	addi	s2,s2,1
 b00:	00094583          	lbu	a1,0(s2)
 b04:	fe0598e3          	bnez	a1,af4 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 b08:	00098b93          	mv	s7,s3
      state = 0;
 b0c:	00000993          	li	s3,0
 b10:	d39ff06f          	j	848 <vprintf+0x78>
          s = "(null)";
 b14:	00000917          	auipc	s2,0x0
 b18:	35490913          	addi	s2,s2,852 # e68 <malloc+0x1c0>
        for(; *s; s++)
 b1c:	02800593          	li	a1,40
 b20:	fd5ff06f          	j	af4 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 b24:	00098b93          	mv	s7,s3
      state = 0;
 b28:	00000993          	li	s3,0
 b2c:	d1dff06f          	j	848 <vprintf+0x78>
 b30:	04813483          	ld	s1,72(sp)
 b34:	03813983          	ld	s3,56(sp)
 b38:	03013a03          	ld	s4,48(sp)
 b3c:	02813a83          	ld	s5,40(sp)
 b40:	02013b03          	ld	s6,32(sp)
 b44:	01813b83          	ld	s7,24(sp)
 b48:	01013c03          	ld	s8,16(sp)
 b4c:	00813c83          	ld	s9,8(sp)
    }
  }
}
 b50:	05813083          	ld	ra,88(sp)
 b54:	05013403          	ld	s0,80(sp)
 b58:	04013903          	ld	s2,64(sp)
 b5c:	06010113          	addi	sp,sp,96
 b60:	00008067          	ret

0000000000000b64 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b64:	fb010113          	addi	sp,sp,-80
 b68:	00113c23          	sd	ra,24(sp)
 b6c:	00813823          	sd	s0,16(sp)
 b70:	02010413          	addi	s0,sp,32
 b74:	00c43023          	sd	a2,0(s0)
 b78:	00d43423          	sd	a3,8(s0)
 b7c:	00e43823          	sd	a4,16(s0)
 b80:	00f43c23          	sd	a5,24(s0)
 b84:	03043023          	sd	a6,32(s0)
 b88:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b8c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b90:	00040613          	mv	a2,s0
 b94:	c3dff0ef          	jal	7d0 <vprintf>
}
 b98:	01813083          	ld	ra,24(sp)
 b9c:	01013403          	ld	s0,16(sp)
 ba0:	05010113          	addi	sp,sp,80
 ba4:	00008067          	ret

0000000000000ba8 <printf>:

void
printf(const char *fmt, ...)
{
 ba8:	fa010113          	addi	sp,sp,-96
 bac:	00113c23          	sd	ra,24(sp)
 bb0:	00813823          	sd	s0,16(sp)
 bb4:	02010413          	addi	s0,sp,32
 bb8:	00b43423          	sd	a1,8(s0)
 bbc:	00c43823          	sd	a2,16(s0)
 bc0:	00d43c23          	sd	a3,24(s0)
 bc4:	02e43023          	sd	a4,32(s0)
 bc8:	02f43423          	sd	a5,40(s0)
 bcc:	03043823          	sd	a6,48(s0)
 bd0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 bd4:	00840613          	addi	a2,s0,8
 bd8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 bdc:	00050593          	mv	a1,a0
 be0:	00100513          	li	a0,1
 be4:	bedff0ef          	jal	7d0 <vprintf>
}
 be8:	01813083          	ld	ra,24(sp)
 bec:	01013403          	ld	s0,16(sp)
 bf0:	06010113          	addi	sp,sp,96
 bf4:	00008067          	ret

0000000000000bf8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bf8:	ff010113          	addi	sp,sp,-16
 bfc:	00813423          	sd	s0,8(sp)
 c00:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c04:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c08:	00000797          	auipc	a5,0x0
 c0c:	3f87b783          	ld	a5,1016(a5) # 1000 <freep>
 c10:	0400006f          	j	c50 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c14:	00862703          	lw	a4,8(a2)
 c18:	00b7073b          	addw	a4,a4,a1
 c1c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c20:	0007b703          	ld	a4,0(a5)
 c24:	00073603          	ld	a2,0(a4)
 c28:	0500006f          	j	c78 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 c2c:	ff852703          	lw	a4,-8(a0)
 c30:	00c7073b          	addw	a4,a4,a2
 c34:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c38:	ff053683          	ld	a3,-16(a0)
 c3c:	0540006f          	j	c90 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c40:	0007b703          	ld	a4,0(a5)
 c44:	00e7e463          	bltu	a5,a4,c4c <free+0x54>
 c48:	00e6ec63          	bltu	a3,a4,c60 <free+0x68>
{
 c4c:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c50:	fed7f8e3          	bgeu	a5,a3,c40 <free+0x48>
 c54:	0007b703          	ld	a4,0(a5)
 c58:	00e6e463          	bltu	a3,a4,c60 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c5c:	fee7e8e3          	bltu	a5,a4,c4c <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 c60:	ff852583          	lw	a1,-8(a0)
 c64:	0007b603          	ld	a2,0(a5)
 c68:	02059813          	slli	a6,a1,0x20
 c6c:	01c85713          	srli	a4,a6,0x1c
 c70:	00e68733          	add	a4,a3,a4
 c74:	fae600e3          	beq	a2,a4,c14 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 c78:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c7c:	0087a603          	lw	a2,8(a5)
 c80:	02061593          	slli	a1,a2,0x20
 c84:	01c5d713          	srli	a4,a1,0x1c
 c88:	00e78733          	add	a4,a5,a4
 c8c:	fae680e3          	beq	a3,a4,c2c <free+0x34>
    p->s.ptr = bp->s.ptr;
 c90:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c94:	00000717          	auipc	a4,0x0
 c98:	36f73623          	sd	a5,876(a4) # 1000 <freep>
}
 c9c:	00813403          	ld	s0,8(sp)
 ca0:	01010113          	addi	sp,sp,16
 ca4:	00008067          	ret

0000000000000ca8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ca8:	fc010113          	addi	sp,sp,-64
 cac:	02113c23          	sd	ra,56(sp)
 cb0:	02813823          	sd	s0,48(sp)
 cb4:	02913423          	sd	s1,40(sp)
 cb8:	01313c23          	sd	s3,24(sp)
 cbc:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cc0:	02051493          	slli	s1,a0,0x20
 cc4:	0204d493          	srli	s1,s1,0x20
 cc8:	00f48493          	addi	s1,s1,15
 ccc:	0044d493          	srli	s1,s1,0x4
 cd0:	0014899b          	addiw	s3,s1,1
 cd4:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
 cd8:	00000517          	auipc	a0,0x0
 cdc:	32853503          	ld	a0,808(a0) # 1000 <freep>
 ce0:	04050663          	beqz	a0,d2c <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ce4:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ce8:	0087a703          	lw	a4,8(a5)
 cec:	0c977c63          	bgeu	a4,s1,dc4 <malloc+0x11c>
 cf0:	03213023          	sd	s2,32(sp)
 cf4:	01413823          	sd	s4,16(sp)
 cf8:	01513423          	sd	s5,8(sp)
 cfc:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
 d00:	00098a13          	mv	s4,s3
 d04:	0009871b          	sext.w	a4,s3
 d08:	000016b7          	lui	a3,0x1
 d0c:	00d77463          	bgeu	a4,a3,d14 <malloc+0x6c>
 d10:	00001a37          	lui	s4,0x1
 d14:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 d18:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d1c:	00000917          	auipc	s2,0x0
 d20:	2e490913          	addi	s2,s2,740 # 1000 <freep>
  if(p == (char*)-1)
 d24:	fff00a93          	li	s5,-1
 d28:	05c0006f          	j	d84 <malloc+0xdc>
 d2c:	03213023          	sd	s2,32(sp)
 d30:	01413823          	sd	s4,16(sp)
 d34:	01513423          	sd	s5,8(sp)
 d38:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 d3c:	00000797          	auipc	a5,0x0
 d40:	4d478793          	addi	a5,a5,1236 # 1210 <base>
 d44:	00000717          	auipc	a4,0x0
 d48:	2af73e23          	sd	a5,700(a4) # 1000 <freep>
 d4c:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 d50:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 d54:	fadff06f          	j	d00 <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
 d58:	0007b703          	ld	a4,0(a5)
 d5c:	00e53023          	sd	a4,0(a0)
 d60:	0800006f          	j	de0 <malloc+0x138>
  hp->s.size = nu;
 d64:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d68:	01050513          	addi	a0,a0,16
 d6c:	e8dff0ef          	jal	bf8 <free>
  return freep;
 d70:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 d74:	08050863          	beqz	a0,e04 <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d78:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d7c:	0087a703          	lw	a4,8(a5)
 d80:	02977a63          	bgeu	a4,s1,db4 <malloc+0x10c>
    if(p == freep)
 d84:	00093703          	ld	a4,0(s2)
 d88:	00078513          	mv	a0,a5
 d8c:	fef716e3          	bne	a4,a5,d78 <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
 d90:	000a0513          	mv	a0,s4
 d94:	8fdff0ef          	jal	690 <sbrk>
  if(p == (char*)-1)
 d98:	fd5516e3          	bne	a0,s5,d64 <malloc+0xbc>
        return 0;
 d9c:	00000513          	li	a0,0
 da0:	02013903          	ld	s2,32(sp)
 da4:	01013a03          	ld	s4,16(sp)
 da8:	00813a83          	ld	s5,8(sp)
 dac:	00013b03          	ld	s6,0(sp)
 db0:	03c0006f          	j	dec <malloc+0x144>
 db4:	02013903          	ld	s2,32(sp)
 db8:	01013a03          	ld	s4,16(sp)
 dbc:	00813a83          	ld	s5,8(sp)
 dc0:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
 dc4:	f8e48ae3          	beq	s1,a4,d58 <malloc+0xb0>
        p->s.size -= nunits;
 dc8:	4137073b          	subw	a4,a4,s3
 dcc:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 dd0:	02071693          	slli	a3,a4,0x20
 dd4:	01c6d713          	srli	a4,a3,0x1c
 dd8:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 ddc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 de0:	00000717          	auipc	a4,0x0
 de4:	22a73023          	sd	a0,544(a4) # 1000 <freep>
      return (void*)(p + 1);
 de8:	01078513          	addi	a0,a5,16
  }
}
 dec:	03813083          	ld	ra,56(sp)
 df0:	03013403          	ld	s0,48(sp)
 df4:	02813483          	ld	s1,40(sp)
 df8:	01813983          	ld	s3,24(sp)
 dfc:	04010113          	addi	sp,sp,64
 e00:	00008067          	ret
 e04:	02013903          	ld	s2,32(sp)
 e08:	01013a03          	ld	s4,16(sp)
 e0c:	00813a83          	ld	s5,8(sp)
 e10:	00013b03          	ld	s6,0(sp)
 e14:	fd9ff06f          	j	dec <malloc+0x144>
