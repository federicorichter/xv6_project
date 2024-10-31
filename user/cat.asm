
user/_cat:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	fd010113          	addi	sp,sp,-48
   4:	02113423          	sd	ra,40(sp)
   8:	02813023          	sd	s0,32(sp)
   c:	00913c23          	sd	s1,24(sp)
  10:	01213823          	sd	s2,16(sp)
  14:	01313423          	sd	s3,8(sp)
  18:	03010413          	addi	s0,sp,48
  1c:	00050993          	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  20:	00001917          	auipc	s2,0x1
  24:	ff090913          	addi	s2,s2,-16 # 1010 <buf>
  28:	20000613          	li	a2,512
  2c:	00090593          	mv	a1,s2
  30:	00098513          	mv	a0,s3
  34:	50c000ef          	jal	540 <read>
  38:	00050493          	mv	s1,a0
  3c:	02a05863          	blez	a0,6c <cat+0x6c>
    if (write(1, buf, n) != n) {
  40:	00048613          	mv	a2,s1
  44:	00090593          	mv	a1,s2
  48:	00100513          	li	a0,1
  4c:	500000ef          	jal	54c <write>
  50:	fc950ce3          	beq	a0,s1,28 <cat+0x28>
      fprintf(2, "cat: write error\n");
  54:	00001597          	auipc	a1,0x1
  58:	d1c58593          	addi	a1,a1,-740 # d70 <malloc+0x170>
  5c:	00200513          	li	a0,2
  60:	25d000ef          	jal	abc <fprintf>
      exit(1);
  64:	00100513          	li	a0,1
  68:	4b4000ef          	jal	51c <exit>
    }
  }
  if(n < 0){
  6c:	02054063          	bltz	a0,8c <cat+0x8c>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  70:	02813083          	ld	ra,40(sp)
  74:	02013403          	ld	s0,32(sp)
  78:	01813483          	ld	s1,24(sp)
  7c:	01013903          	ld	s2,16(sp)
  80:	00813983          	ld	s3,8(sp)
  84:	03010113          	addi	sp,sp,48
  88:	00008067          	ret
    fprintf(2, "cat: read error\n");
  8c:	00001597          	auipc	a1,0x1
  90:	cfc58593          	addi	a1,a1,-772 # d88 <malloc+0x188>
  94:	00200513          	li	a0,2
  98:	225000ef          	jal	abc <fprintf>
    exit(1);
  9c:	00100513          	li	a0,1
  a0:	47c000ef          	jal	51c <exit>

00000000000000a4 <main>:

int
main(int argc, char *argv[])
{
  a4:	fd010113          	addi	sp,sp,-48
  a8:	02113423          	sd	ra,40(sp)
  ac:	02813023          	sd	s0,32(sp)
  b0:	03010413          	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  b4:	00100793          	li	a5,1
  b8:	04a7dc63          	bge	a5,a0,110 <main+0x6c>
  bc:	00913c23          	sd	s1,24(sp)
  c0:	01213823          	sd	s2,16(sp)
  c4:	01313423          	sd	s3,8(sp)
  c8:	00858913          	addi	s2,a1,8
  cc:	ffe5099b          	addiw	s3,a0,-2
  d0:	02099793          	slli	a5,s3,0x20
  d4:	01d7d993          	srli	s3,a5,0x1d
  d8:	01058593          	addi	a1,a1,16
  dc:	00b989b3          	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  e0:	00000593          	li	a1,0
  e4:	00093503          	ld	a0,0(s2)
  e8:	494000ef          	jal	57c <open>
  ec:	00050493          	mv	s1,a0
  f0:	02054e63          	bltz	a0,12c <main+0x88>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  f4:	f0dff0ef          	jal	0 <cat>
    close(fd);
  f8:	00048513          	mv	a0,s1
  fc:	45c000ef          	jal	558 <close>
  for(i = 1; i < argc; i++){
 100:	00890913          	addi	s2,s2,8
 104:	fd391ee3          	bne	s2,s3,e0 <main+0x3c>
  }
  exit(0);
 108:	00000513          	li	a0,0
 10c:	410000ef          	jal	51c <exit>
 110:	00913c23          	sd	s1,24(sp)
 114:	01213823          	sd	s2,16(sp)
 118:	01313423          	sd	s3,8(sp)
    cat(0);
 11c:	00000513          	li	a0,0
 120:	ee1ff0ef          	jal	0 <cat>
    exit(0);
 124:	00000513          	li	a0,0
 128:	3f4000ef          	jal	51c <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 12c:	00093603          	ld	a2,0(s2)
 130:	00001597          	auipc	a1,0x1
 134:	c7058593          	addi	a1,a1,-912 # da0 <malloc+0x1a0>
 138:	00200513          	li	a0,2
 13c:	181000ef          	jal	abc <fprintf>
      exit(1);
 140:	00100513          	li	a0,1
 144:	3d8000ef          	jal	51c <exit>

0000000000000148 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 148:	ff010113          	addi	sp,sp,-16
 14c:	00113423          	sd	ra,8(sp)
 150:	00813023          	sd	s0,0(sp)
 154:	01010413          	addi	s0,sp,16
  extern int main();
  main();
 158:	f4dff0ef          	jal	a4 <main>
  exit(0);
 15c:	00000513          	li	a0,0
 160:	3bc000ef          	jal	51c <exit>

0000000000000164 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 164:	ff010113          	addi	sp,sp,-16
 168:	00813423          	sd	s0,8(sp)
 16c:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 170:	00050793          	mv	a5,a0
 174:	00158593          	addi	a1,a1,1
 178:	00178793          	addi	a5,a5,1
 17c:	fff5c703          	lbu	a4,-1(a1)
 180:	fee78fa3          	sb	a4,-1(a5)
 184:	fe0718e3          	bnez	a4,174 <strcpy+0x10>
    ;
  return os;
}
 188:	00813403          	ld	s0,8(sp)
 18c:	01010113          	addi	sp,sp,16
 190:	00008067          	ret

0000000000000194 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 194:	ff010113          	addi	sp,sp,-16
 198:	00813423          	sd	s0,8(sp)
 19c:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	00078e63          	beqz	a5,1c0 <strcmp+0x2c>
 1a8:	0005c703          	lbu	a4,0(a1)
 1ac:	00f71a63          	bne	a4,a5,1c0 <strcmp+0x2c>
    p++, q++;
 1b0:	00150513          	addi	a0,a0,1
 1b4:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	fe0796e3          	bnez	a5,1a8 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 1c0:	0005c503          	lbu	a0,0(a1)
}
 1c4:	40a7853b          	subw	a0,a5,a0
 1c8:	00813403          	ld	s0,8(sp)
 1cc:	01010113          	addi	sp,sp,16
 1d0:	00008067          	ret

00000000000001d4 <strlen>:

uint
strlen(const char *s)
{
 1d4:	ff010113          	addi	sp,sp,-16
 1d8:	00813423          	sd	s0,8(sp)
 1dc:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1e0:	00054783          	lbu	a5,0(a0)
 1e4:	02078863          	beqz	a5,214 <strlen+0x40>
 1e8:	00150513          	addi	a0,a0,1
 1ec:	00050793          	mv	a5,a0
 1f0:	00078693          	mv	a3,a5
 1f4:	00178793          	addi	a5,a5,1
 1f8:	fff7c703          	lbu	a4,-1(a5)
 1fc:	fe071ae3          	bnez	a4,1f0 <strlen+0x1c>
 200:	40a6853b          	subw	a0,a3,a0
 204:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
 208:	00813403          	ld	s0,8(sp)
 20c:	01010113          	addi	sp,sp,16
 210:	00008067          	ret
  for(n = 0; s[n]; n++)
 214:	00000513          	li	a0,0
 218:	ff1ff06f          	j	208 <strlen+0x34>

000000000000021c <memset>:

void*
memset(void *dst, int c, uint n)
{
 21c:	ff010113          	addi	sp,sp,-16
 220:	00813423          	sd	s0,8(sp)
 224:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 228:	02060063          	beqz	a2,248 <memset+0x2c>
 22c:	00050793          	mv	a5,a0
 230:	02061613          	slli	a2,a2,0x20
 234:	02065613          	srli	a2,a2,0x20
 238:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 23c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 240:	00178793          	addi	a5,a5,1
 244:	fee79ce3          	bne	a5,a4,23c <memset+0x20>
  }
  return dst;
}
 248:	00813403          	ld	s0,8(sp)
 24c:	01010113          	addi	sp,sp,16
 250:	00008067          	ret

0000000000000254 <strchr>:

char*
strchr(const char *s, char c)
{
 254:	ff010113          	addi	sp,sp,-16
 258:	00813423          	sd	s0,8(sp)
 25c:	01010413          	addi	s0,sp,16
  for(; *s; s++)
 260:	00054783          	lbu	a5,0(a0)
 264:	02078263          	beqz	a5,288 <strchr+0x34>
    if(*s == c)
 268:	00f58a63          	beq	a1,a5,27c <strchr+0x28>
  for(; *s; s++)
 26c:	00150513          	addi	a0,a0,1
 270:	00054783          	lbu	a5,0(a0)
 274:	fe079ae3          	bnez	a5,268 <strchr+0x14>
      return (char*)s;
  return 0;
 278:	00000513          	li	a0,0
}
 27c:	00813403          	ld	s0,8(sp)
 280:	01010113          	addi	sp,sp,16
 284:	00008067          	ret
  return 0;
 288:	00000513          	li	a0,0
 28c:	ff1ff06f          	j	27c <strchr+0x28>

0000000000000290 <gets>:

char*
gets(char *buf, int max)
{
 290:	fa010113          	addi	sp,sp,-96
 294:	04113c23          	sd	ra,88(sp)
 298:	04813823          	sd	s0,80(sp)
 29c:	04913423          	sd	s1,72(sp)
 2a0:	05213023          	sd	s2,64(sp)
 2a4:	03313c23          	sd	s3,56(sp)
 2a8:	03413823          	sd	s4,48(sp)
 2ac:	03513423          	sd	s5,40(sp)
 2b0:	03613023          	sd	s6,32(sp)
 2b4:	01713c23          	sd	s7,24(sp)
 2b8:	06010413          	addi	s0,sp,96
 2bc:	00050b93          	mv	s7,a0
 2c0:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c4:	00050913          	mv	s2,a0
 2c8:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2cc:	00a00a93          	li	s5,10
 2d0:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 2d4:	00048993          	mv	s3,s1
 2d8:	0014849b          	addiw	s1,s1,1
 2dc:	0344dc63          	bge	s1,s4,314 <gets+0x84>
    cc = read(0, &c, 1);
 2e0:	00100613          	li	a2,1
 2e4:	faf40593          	addi	a1,s0,-81
 2e8:	00000513          	li	a0,0
 2ec:	254000ef          	jal	540 <read>
    if(cc < 1)
 2f0:	02a05263          	blez	a0,314 <gets+0x84>
    buf[i++] = c;
 2f4:	faf44783          	lbu	a5,-81(s0)
 2f8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2fc:	01578a63          	beq	a5,s5,310 <gets+0x80>
 300:	00190913          	addi	s2,s2,1
 304:	fd6798e3          	bne	a5,s6,2d4 <gets+0x44>
    buf[i++] = c;
 308:	00048993          	mv	s3,s1
 30c:	0080006f          	j	314 <gets+0x84>
 310:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 314:	013b89b3          	add	s3,s7,s3
 318:	00098023          	sb	zero,0(s3)
  return buf;
}
 31c:	000b8513          	mv	a0,s7
 320:	05813083          	ld	ra,88(sp)
 324:	05013403          	ld	s0,80(sp)
 328:	04813483          	ld	s1,72(sp)
 32c:	04013903          	ld	s2,64(sp)
 330:	03813983          	ld	s3,56(sp)
 334:	03013a03          	ld	s4,48(sp)
 338:	02813a83          	ld	s5,40(sp)
 33c:	02013b03          	ld	s6,32(sp)
 340:	01813b83          	ld	s7,24(sp)
 344:	06010113          	addi	sp,sp,96
 348:	00008067          	ret

000000000000034c <stat>:

int
stat(const char *n, struct stat *st)
{
 34c:	fe010113          	addi	sp,sp,-32
 350:	00113c23          	sd	ra,24(sp)
 354:	00813823          	sd	s0,16(sp)
 358:	01213023          	sd	s2,0(sp)
 35c:	02010413          	addi	s0,sp,32
 360:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 364:	00000593          	li	a1,0
 368:	214000ef          	jal	57c <open>
  if(fd < 0)
 36c:	02054e63          	bltz	a0,3a8 <stat+0x5c>
 370:	00913423          	sd	s1,8(sp)
 374:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 378:	00090593          	mv	a1,s2
 37c:	224000ef          	jal	5a0 <fstat>
 380:	00050913          	mv	s2,a0
  close(fd);
 384:	00048513          	mv	a0,s1
 388:	1d0000ef          	jal	558 <close>
  return r;
 38c:	00813483          	ld	s1,8(sp)
}
 390:	00090513          	mv	a0,s2
 394:	01813083          	ld	ra,24(sp)
 398:	01013403          	ld	s0,16(sp)
 39c:	00013903          	ld	s2,0(sp)
 3a0:	02010113          	addi	sp,sp,32
 3a4:	00008067          	ret
    return -1;
 3a8:	fff00913          	li	s2,-1
 3ac:	fe5ff06f          	j	390 <stat+0x44>

00000000000003b0 <atoi>:

int
atoi(const char *s)
{
 3b0:	ff010113          	addi	sp,sp,-16
 3b4:	00813423          	sd	s0,8(sp)
 3b8:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3bc:	00054683          	lbu	a3,0(a0)
 3c0:	fd06879b          	addiw	a5,a3,-48
 3c4:	0ff7f793          	zext.b	a5,a5
 3c8:	00900613          	li	a2,9
 3cc:	04f66063          	bltu	a2,a5,40c <atoi+0x5c>
 3d0:	00050713          	mv	a4,a0
  n = 0;
 3d4:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 3d8:	00170713          	addi	a4,a4,1
 3dc:	0025179b          	slliw	a5,a0,0x2
 3e0:	00a787bb          	addw	a5,a5,a0
 3e4:	0017979b          	slliw	a5,a5,0x1
 3e8:	00d787bb          	addw	a5,a5,a3
 3ec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3f0:	00074683          	lbu	a3,0(a4)
 3f4:	fd06879b          	addiw	a5,a3,-48
 3f8:	0ff7f793          	zext.b	a5,a5
 3fc:	fcf67ee3          	bgeu	a2,a5,3d8 <atoi+0x28>
  return n;
}
 400:	00813403          	ld	s0,8(sp)
 404:	01010113          	addi	sp,sp,16
 408:	00008067          	ret
  n = 0;
 40c:	00000513          	li	a0,0
 410:	ff1ff06f          	j	400 <atoi+0x50>

0000000000000414 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 414:	ff010113          	addi	sp,sp,-16
 418:	00813423          	sd	s0,8(sp)
 41c:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 420:	02b57c63          	bgeu	a0,a1,458 <memmove+0x44>
    while(n-- > 0)
 424:	02c05463          	blez	a2,44c <memmove+0x38>
 428:	02061613          	slli	a2,a2,0x20
 42c:	02065613          	srli	a2,a2,0x20
 430:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 434:	00050713          	mv	a4,a0
      *dst++ = *src++;
 438:	00158593          	addi	a1,a1,1
 43c:	00170713          	addi	a4,a4,1
 440:	fff5c683          	lbu	a3,-1(a1)
 444:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 448:	fef718e3          	bne	a4,a5,438 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 44c:	00813403          	ld	s0,8(sp)
 450:	01010113          	addi	sp,sp,16
 454:	00008067          	ret
    dst += n;
 458:	00c50733          	add	a4,a0,a2
    src += n;
 45c:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 460:	fec056e3          	blez	a2,44c <memmove+0x38>
 464:	fff6079b          	addiw	a5,a2,-1
 468:	02079793          	slli	a5,a5,0x20
 46c:	0207d793          	srli	a5,a5,0x20
 470:	fff7c793          	not	a5,a5
 474:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 478:	fff58593          	addi	a1,a1,-1
 47c:	fff70713          	addi	a4,a4,-1
 480:	0005c683          	lbu	a3,0(a1)
 484:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 488:	fee798e3          	bne	a5,a4,478 <memmove+0x64>
 48c:	fc1ff06f          	j	44c <memmove+0x38>

0000000000000490 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 490:	ff010113          	addi	sp,sp,-16
 494:	00813423          	sd	s0,8(sp)
 498:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 49c:	04060463          	beqz	a2,4e4 <memcmp+0x54>
 4a0:	fff6069b          	addiw	a3,a2,-1
 4a4:	02069693          	slli	a3,a3,0x20
 4a8:	0206d693          	srli	a3,a3,0x20
 4ac:	00168693          	addi	a3,a3,1
 4b0:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 4b4:	00054783          	lbu	a5,0(a0)
 4b8:	0005c703          	lbu	a4,0(a1)
 4bc:	00e79c63          	bne	a5,a4,4d4 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 4c0:	00150513          	addi	a0,a0,1
    p2++;
 4c4:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
 4c8:	fed516e3          	bne	a0,a3,4b4 <memcmp+0x24>
  }
  return 0;
 4cc:	00000513          	li	a0,0
 4d0:	0080006f          	j	4d8 <memcmp+0x48>
      return *p1 - *p2;
 4d4:	40e7853b          	subw	a0,a5,a4
}
 4d8:	00813403          	ld	s0,8(sp)
 4dc:	01010113          	addi	sp,sp,16
 4e0:	00008067          	ret
  return 0;
 4e4:	00000513          	li	a0,0
 4e8:	ff1ff06f          	j	4d8 <memcmp+0x48>

00000000000004ec <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ec:	ff010113          	addi	sp,sp,-16
 4f0:	00113423          	sd	ra,8(sp)
 4f4:	00813023          	sd	s0,0(sp)
 4f8:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
 4fc:	f19ff0ef          	jal	414 <memmove>
}
 500:	00813083          	ld	ra,8(sp)
 504:	00013403          	ld	s0,0(sp)
 508:	01010113          	addi	sp,sp,16
 50c:	00008067          	ret

0000000000000510 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 510:	00100893          	li	a7,1
 ecall
 514:	00000073          	ecall
 ret
 518:	00008067          	ret

000000000000051c <exit>:
.global exit
exit:
 li a7, SYS_exit
 51c:	00200893          	li	a7,2
 ecall
 520:	00000073          	ecall
 ret
 524:	00008067          	ret

0000000000000528 <wait>:
.global wait
wait:
 li a7, SYS_wait
 528:	00300893          	li	a7,3
 ecall
 52c:	00000073          	ecall
 ret
 530:	00008067          	ret

0000000000000534 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 534:	00400893          	li	a7,4
 ecall
 538:	00000073          	ecall
 ret
 53c:	00008067          	ret

0000000000000540 <read>:
.global read
read:
 li a7, SYS_read
 540:	00500893          	li	a7,5
 ecall
 544:	00000073          	ecall
 ret
 548:	00008067          	ret

000000000000054c <write>:
.global write
write:
 li a7, SYS_write
 54c:	01000893          	li	a7,16
 ecall
 550:	00000073          	ecall
 ret
 554:	00008067          	ret

0000000000000558 <close>:
.global close
close:
 li a7, SYS_close
 558:	01500893          	li	a7,21
 ecall
 55c:	00000073          	ecall
 ret
 560:	00008067          	ret

0000000000000564 <kill>:
.global kill
kill:
 li a7, SYS_kill
 564:	00600893          	li	a7,6
 ecall
 568:	00000073          	ecall
 ret
 56c:	00008067          	ret

0000000000000570 <exec>:
.global exec
exec:
 li a7, SYS_exec
 570:	00700893          	li	a7,7
 ecall
 574:	00000073          	ecall
 ret
 578:	00008067          	ret

000000000000057c <open>:
.global open
open:
 li a7, SYS_open
 57c:	00f00893          	li	a7,15
 ecall
 580:	00000073          	ecall
 ret
 584:	00008067          	ret

0000000000000588 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 588:	01100893          	li	a7,17
 ecall
 58c:	00000073          	ecall
 ret
 590:	00008067          	ret

0000000000000594 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 594:	01200893          	li	a7,18
 ecall
 598:	00000073          	ecall
 ret
 59c:	00008067          	ret

00000000000005a0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5a0:	00800893          	li	a7,8
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	00008067          	ret

00000000000005ac <link>:
.global link
link:
 li a7, SYS_link
 5ac:	01300893          	li	a7,19
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	00008067          	ret

00000000000005b8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5b8:	01400893          	li	a7,20
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	00008067          	ret

00000000000005c4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5c4:	00900893          	li	a7,9
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	00008067          	ret

00000000000005d0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5d0:	00a00893          	li	a7,10
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	00008067          	ret

00000000000005dc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5dc:	00b00893          	li	a7,11
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	00008067          	ret

00000000000005e8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5e8:	00c00893          	li	a7,12
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	00008067          	ret

00000000000005f4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5f4:	00d00893          	li	a7,13
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	00008067          	ret

0000000000000600 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 600:	00e00893          	li	a7,14
 ecall
 604:	00000073          	ecall
 ret
 608:	00008067          	ret

000000000000060c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 60c:	fe010113          	addi	sp,sp,-32
 610:	00113c23          	sd	ra,24(sp)
 614:	00813823          	sd	s0,16(sp)
 618:	02010413          	addi	s0,sp,32
 61c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 620:	00100613          	li	a2,1
 624:	fef40593          	addi	a1,s0,-17
 628:	f25ff0ef          	jal	54c <write>
}
 62c:	01813083          	ld	ra,24(sp)
 630:	01013403          	ld	s0,16(sp)
 634:	02010113          	addi	sp,sp,32
 638:	00008067          	ret

000000000000063c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 63c:	fc010113          	addi	sp,sp,-64
 640:	02113c23          	sd	ra,56(sp)
 644:	02813823          	sd	s0,48(sp)
 648:	02913423          	sd	s1,40(sp)
 64c:	04010413          	addi	s0,sp,64
 650:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 654:	00068463          	beqz	a3,65c <printint+0x20>
 658:	0c05c263          	bltz	a1,71c <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 65c:	0005859b          	sext.w	a1,a1
  neg = 0;
 660:	00000893          	li	a7,0
 664:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 668:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 66c:	0006061b          	sext.w	a2,a2
 670:	00000517          	auipc	a0,0x0
 674:	75050513          	addi	a0,a0,1872 # dc0 <digits>
 678:	00070813          	mv	a6,a4
 67c:	0017071b          	addiw	a4,a4,1
 680:	02c5f7bb          	remuw	a5,a1,a2
 684:	02079793          	slli	a5,a5,0x20
 688:	0207d793          	srli	a5,a5,0x20
 68c:	00f507b3          	add	a5,a0,a5
 690:	0007c783          	lbu	a5,0(a5)
 694:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 698:	0005879b          	sext.w	a5,a1
 69c:	02c5d5bb          	divuw	a1,a1,a2
 6a0:	00168693          	addi	a3,a3,1
 6a4:	fcc7fae3          	bgeu	a5,a2,678 <printint+0x3c>
  if(neg)
 6a8:	00088c63          	beqz	a7,6c0 <printint+0x84>
    buf[i++] = '-';
 6ac:	fd070793          	addi	a5,a4,-48
 6b0:	00878733          	add	a4,a5,s0
 6b4:	02d00793          	li	a5,45
 6b8:	fef70823          	sb	a5,-16(a4)
 6bc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6c0:	04e05463          	blez	a4,708 <printint+0xcc>
 6c4:	03213023          	sd	s2,32(sp)
 6c8:	01313c23          	sd	s3,24(sp)
 6cc:	fc040793          	addi	a5,s0,-64
 6d0:	00e78933          	add	s2,a5,a4
 6d4:	fff78993          	addi	s3,a5,-1
 6d8:	00e989b3          	add	s3,s3,a4
 6dc:	fff7071b          	addiw	a4,a4,-1
 6e0:	02071713          	slli	a4,a4,0x20
 6e4:	02075713          	srli	a4,a4,0x20
 6e8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6ec:	fff94583          	lbu	a1,-1(s2)
 6f0:	00048513          	mv	a0,s1
 6f4:	f19ff0ef          	jal	60c <putc>
  while(--i >= 0)
 6f8:	fff90913          	addi	s2,s2,-1
 6fc:	ff3918e3          	bne	s2,s3,6ec <printint+0xb0>
 700:	02013903          	ld	s2,32(sp)
 704:	01813983          	ld	s3,24(sp)
}
 708:	03813083          	ld	ra,56(sp)
 70c:	03013403          	ld	s0,48(sp)
 710:	02813483          	ld	s1,40(sp)
 714:	04010113          	addi	sp,sp,64
 718:	00008067          	ret
    x = -xx;
 71c:	40b005bb          	negw	a1,a1
    neg = 1;
 720:	00100893          	li	a7,1
    x = -xx;
 724:	f41ff06f          	j	664 <printint+0x28>

0000000000000728 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 728:	fa010113          	addi	sp,sp,-96
 72c:	04113c23          	sd	ra,88(sp)
 730:	04813823          	sd	s0,80(sp)
 734:	05213023          	sd	s2,64(sp)
 738:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 73c:	0005c903          	lbu	s2,0(a1)
 740:	36090463          	beqz	s2,aa8 <vprintf+0x380>
 744:	04913423          	sd	s1,72(sp)
 748:	03313c23          	sd	s3,56(sp)
 74c:	03413823          	sd	s4,48(sp)
 750:	03513423          	sd	s5,40(sp)
 754:	03613023          	sd	s6,32(sp)
 758:	01713c23          	sd	s7,24(sp)
 75c:	01813823          	sd	s8,16(sp)
 760:	01913423          	sd	s9,8(sp)
 764:	00050b13          	mv	s6,a0
 768:	00058a13          	mv	s4,a1
 76c:	00060b93          	mv	s7,a2
  state = 0;
 770:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
 774:	00000493          	li	s1,0
 778:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 77c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 780:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 784:	06c00c93          	li	s9,108
 788:	02c0006f          	j	7b4 <vprintf+0x8c>
        putc(fd, c0);
 78c:	00090593          	mv	a1,s2
 790:	000b0513          	mv	a0,s6
 794:	e79ff0ef          	jal	60c <putc>
 798:	0080006f          	j	7a0 <vprintf+0x78>
    } else if(state == '%'){
 79c:	03598663          	beq	s3,s5,7c8 <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
 7a0:	0014849b          	addiw	s1,s1,1
 7a4:	00048713          	mv	a4,s1
 7a8:	009a07b3          	add	a5,s4,s1
 7ac:	0007c903          	lbu	s2,0(a5)
 7b0:	2c090c63          	beqz	s2,a88 <vprintf+0x360>
    c0 = fmt[i] & 0xff;
 7b4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 7b8:	fe0992e3          	bnez	s3,79c <vprintf+0x74>
      if(c0 == '%'){
 7bc:	fd5798e3          	bne	a5,s5,78c <vprintf+0x64>
        state = '%';
 7c0:	00078993          	mv	s3,a5
 7c4:	fddff06f          	j	7a0 <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
 7c8:	00ea06b3          	add	a3,s4,a4
 7cc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 7d0:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 7d4:	00068663          	beqz	a3,7e0 <vprintf+0xb8>
 7d8:	00ea0733          	add	a4,s4,a4
 7dc:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 7e0:	05878263          	beq	a5,s8,824 <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
 7e4:	07978263          	beq	a5,s9,848 <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 7e8:	07500713          	li	a4,117
 7ec:	12e78663          	beq	a5,a4,918 <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 7f0:	07800713          	li	a4,120
 7f4:	18e78c63          	beq	a5,a4,98c <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 7f8:	07000713          	li	a4,112
 7fc:	1ce78e63          	beq	a5,a4,9d8 <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 800:	07300713          	li	a4,115
 804:	22e78a63          	beq	a5,a4,a38 <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 808:	02500713          	li	a4,37
 80c:	04e79e63          	bne	a5,a4,868 <vprintf+0x140>
        putc(fd, '%');
 810:	02500593          	li	a1,37
 814:	000b0513          	mv	a0,s6
 818:	df5ff0ef          	jal	60c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 81c:	00000993          	li	s3,0
 820:	f81ff06f          	j	7a0 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
 824:	008b8913          	addi	s2,s7,8
 828:	00100693          	li	a3,1
 82c:	00a00613          	li	a2,10
 830:	000ba583          	lw	a1,0(s7)
 834:	000b0513          	mv	a0,s6
 838:	e05ff0ef          	jal	63c <printint>
 83c:	00090b93          	mv	s7,s2
      state = 0;
 840:	00000993          	li	s3,0
 844:	f5dff06f          	j	7a0 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
 848:	06400793          	li	a5,100
 84c:	02f68e63          	beq	a3,a5,888 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 850:	06c00793          	li	a5,108
 854:	04f68e63          	beq	a3,a5,8b0 <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
 858:	07500793          	li	a5,117
 85c:	0ef68063          	beq	a3,a5,93c <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
 860:	07800793          	li	a5,120
 864:	14f68663          	beq	a3,a5,9b0 <vprintf+0x288>
        putc(fd, '%');
 868:	02500593          	li	a1,37
 86c:	000b0513          	mv	a0,s6
 870:	d9dff0ef          	jal	60c <putc>
        putc(fd, c0);
 874:	00090593          	mv	a1,s2
 878:	000b0513          	mv	a0,s6
 87c:	d91ff0ef          	jal	60c <putc>
      state = 0;
 880:	00000993          	li	s3,0
 884:	f1dff06f          	j	7a0 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 888:	008b8913          	addi	s2,s7,8
 88c:	00100693          	li	a3,1
 890:	00a00613          	li	a2,10
 894:	000ba583          	lw	a1,0(s7)
 898:	000b0513          	mv	a0,s6
 89c:	da1ff0ef          	jal	63c <printint>
        i += 1;
 8a0:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 8a4:	00090b93          	mv	s7,s2
      state = 0;
 8a8:	00000993          	li	s3,0
        i += 1;
 8ac:	ef5ff06f          	j	7a0 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8b0:	06400793          	li	a5,100
 8b4:	02f60e63          	beq	a2,a5,8f0 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8b8:	07500793          	li	a5,117
 8bc:	0af60463          	beq	a2,a5,964 <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8c0:	07800793          	li	a5,120
 8c4:	faf612e3          	bne	a2,a5,868 <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8c8:	008b8913          	addi	s2,s7,8
 8cc:	00000693          	li	a3,0
 8d0:	01000613          	li	a2,16
 8d4:	000ba583          	lw	a1,0(s7)
 8d8:	000b0513          	mv	a0,s6
 8dc:	d61ff0ef          	jal	63c <printint>
        i += 2;
 8e0:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 8e4:	00090b93          	mv	s7,s2
      state = 0;
 8e8:	00000993          	li	s3,0
        i += 2;
 8ec:	eb5ff06f          	j	7a0 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8f0:	008b8913          	addi	s2,s7,8
 8f4:	00100693          	li	a3,1
 8f8:	00a00613          	li	a2,10
 8fc:	000ba583          	lw	a1,0(s7)
 900:	000b0513          	mv	a0,s6
 904:	d39ff0ef          	jal	63c <printint>
        i += 2;
 908:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 90c:	00090b93          	mv	s7,s2
      state = 0;
 910:	00000993          	li	s3,0
        i += 2;
 914:	e8dff06f          	j	7a0 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
 918:	008b8913          	addi	s2,s7,8
 91c:	00000693          	li	a3,0
 920:	00a00613          	li	a2,10
 924:	000ba583          	lw	a1,0(s7)
 928:	000b0513          	mv	a0,s6
 92c:	d11ff0ef          	jal	63c <printint>
 930:	00090b93          	mv	s7,s2
      state = 0;
 934:	00000993          	li	s3,0
 938:	e69ff06f          	j	7a0 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 93c:	008b8913          	addi	s2,s7,8
 940:	00000693          	li	a3,0
 944:	00a00613          	li	a2,10
 948:	000ba583          	lw	a1,0(s7)
 94c:	000b0513          	mv	a0,s6
 950:	cedff0ef          	jal	63c <printint>
        i += 1;
 954:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 958:	00090b93          	mv	s7,s2
      state = 0;
 95c:	00000993          	li	s3,0
        i += 1;
 960:	e41ff06f          	j	7a0 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 964:	008b8913          	addi	s2,s7,8
 968:	00000693          	li	a3,0
 96c:	00a00613          	li	a2,10
 970:	000ba583          	lw	a1,0(s7)
 974:	000b0513          	mv	a0,s6
 978:	cc5ff0ef          	jal	63c <printint>
        i += 2;
 97c:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 980:	00090b93          	mv	s7,s2
      state = 0;
 984:	00000993          	li	s3,0
        i += 2;
 988:	e19ff06f          	j	7a0 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
 98c:	008b8913          	addi	s2,s7,8
 990:	00000693          	li	a3,0
 994:	01000613          	li	a2,16
 998:	000ba583          	lw	a1,0(s7)
 99c:	000b0513          	mv	a0,s6
 9a0:	c9dff0ef          	jal	63c <printint>
 9a4:	00090b93          	mv	s7,s2
      state = 0;
 9a8:	00000993          	li	s3,0
 9ac:	df5ff06f          	j	7a0 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9b0:	008b8913          	addi	s2,s7,8
 9b4:	00000693          	li	a3,0
 9b8:	01000613          	li	a2,16
 9bc:	000ba583          	lw	a1,0(s7)
 9c0:	000b0513          	mv	a0,s6
 9c4:	c79ff0ef          	jal	63c <printint>
        i += 1;
 9c8:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 9cc:	00090b93          	mv	s7,s2
      state = 0;
 9d0:	00000993          	li	s3,0
        i += 1;
 9d4:	dcdff06f          	j	7a0 <vprintf+0x78>
 9d8:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 9dc:	008b8d13          	addi	s10,s7,8
 9e0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9e4:	03000593          	li	a1,48
 9e8:	000b0513          	mv	a0,s6
 9ec:	c21ff0ef          	jal	60c <putc>
  putc(fd, 'x');
 9f0:	07800593          	li	a1,120
 9f4:	000b0513          	mv	a0,s6
 9f8:	c15ff0ef          	jal	60c <putc>
 9fc:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a00:	00000b97          	auipc	s7,0x0
 a04:	3c0b8b93          	addi	s7,s7,960 # dc0 <digits>
 a08:	03c9d793          	srli	a5,s3,0x3c
 a0c:	00fb87b3          	add	a5,s7,a5
 a10:	0007c583          	lbu	a1,0(a5)
 a14:	000b0513          	mv	a0,s6
 a18:	bf5ff0ef          	jal	60c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a1c:	00499993          	slli	s3,s3,0x4
 a20:	fff9091b          	addiw	s2,s2,-1
 a24:	fe0912e3          	bnez	s2,a08 <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
 a28:	000d0b93          	mv	s7,s10
      state = 0;
 a2c:	00000993          	li	s3,0
 a30:	00013d03          	ld	s10,0(sp)
 a34:	d6dff06f          	j	7a0 <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
 a38:	008b8993          	addi	s3,s7,8
 a3c:	000bb903          	ld	s2,0(s7)
 a40:	02090663          	beqz	s2,a6c <vprintf+0x344>
        for(; *s; s++)
 a44:	00094583          	lbu	a1,0(s2)
 a48:	02058a63          	beqz	a1,a7c <vprintf+0x354>
          putc(fd, *s);
 a4c:	000b0513          	mv	a0,s6
 a50:	bbdff0ef          	jal	60c <putc>
        for(; *s; s++)
 a54:	00190913          	addi	s2,s2,1
 a58:	00094583          	lbu	a1,0(s2)
 a5c:	fe0598e3          	bnez	a1,a4c <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 a60:	00098b93          	mv	s7,s3
      state = 0;
 a64:	00000993          	li	s3,0
 a68:	d39ff06f          	j	7a0 <vprintf+0x78>
          s = "(null)";
 a6c:	00000917          	auipc	s2,0x0
 a70:	34c90913          	addi	s2,s2,844 # db8 <malloc+0x1b8>
        for(; *s; s++)
 a74:	02800593          	li	a1,40
 a78:	fd5ff06f          	j	a4c <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 a7c:	00098b93          	mv	s7,s3
      state = 0;
 a80:	00000993          	li	s3,0
 a84:	d1dff06f          	j	7a0 <vprintf+0x78>
 a88:	04813483          	ld	s1,72(sp)
 a8c:	03813983          	ld	s3,56(sp)
 a90:	03013a03          	ld	s4,48(sp)
 a94:	02813a83          	ld	s5,40(sp)
 a98:	02013b03          	ld	s6,32(sp)
 a9c:	01813b83          	ld	s7,24(sp)
 aa0:	01013c03          	ld	s8,16(sp)
 aa4:	00813c83          	ld	s9,8(sp)
    }
  }
}
 aa8:	05813083          	ld	ra,88(sp)
 aac:	05013403          	ld	s0,80(sp)
 ab0:	04013903          	ld	s2,64(sp)
 ab4:	06010113          	addi	sp,sp,96
 ab8:	00008067          	ret

0000000000000abc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 abc:	fb010113          	addi	sp,sp,-80
 ac0:	00113c23          	sd	ra,24(sp)
 ac4:	00813823          	sd	s0,16(sp)
 ac8:	02010413          	addi	s0,sp,32
 acc:	00c43023          	sd	a2,0(s0)
 ad0:	00d43423          	sd	a3,8(s0)
 ad4:	00e43823          	sd	a4,16(s0)
 ad8:	00f43c23          	sd	a5,24(s0)
 adc:	03043023          	sd	a6,32(s0)
 ae0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 ae4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 ae8:	00040613          	mv	a2,s0
 aec:	c3dff0ef          	jal	728 <vprintf>
}
 af0:	01813083          	ld	ra,24(sp)
 af4:	01013403          	ld	s0,16(sp)
 af8:	05010113          	addi	sp,sp,80
 afc:	00008067          	ret

0000000000000b00 <printf>:

void
printf(const char *fmt, ...)
{
 b00:	fa010113          	addi	sp,sp,-96
 b04:	00113c23          	sd	ra,24(sp)
 b08:	00813823          	sd	s0,16(sp)
 b0c:	02010413          	addi	s0,sp,32
 b10:	00b43423          	sd	a1,8(s0)
 b14:	00c43823          	sd	a2,16(s0)
 b18:	00d43c23          	sd	a3,24(s0)
 b1c:	02e43023          	sd	a4,32(s0)
 b20:	02f43423          	sd	a5,40(s0)
 b24:	03043823          	sd	a6,48(s0)
 b28:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b2c:	00840613          	addi	a2,s0,8
 b30:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b34:	00050593          	mv	a1,a0
 b38:	00100513          	li	a0,1
 b3c:	bedff0ef          	jal	728 <vprintf>
}
 b40:	01813083          	ld	ra,24(sp)
 b44:	01013403          	ld	s0,16(sp)
 b48:	06010113          	addi	sp,sp,96
 b4c:	00008067          	ret

0000000000000b50 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b50:	ff010113          	addi	sp,sp,-16
 b54:	00813423          	sd	s0,8(sp)
 b58:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b5c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b60:	00000797          	auipc	a5,0x0
 b64:	4a07b783          	ld	a5,1184(a5) # 1000 <freep>
 b68:	0400006f          	j	ba8 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b6c:	00862703          	lw	a4,8(a2)
 b70:	00b7073b          	addw	a4,a4,a1
 b74:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b78:	0007b703          	ld	a4,0(a5)
 b7c:	00073603          	ld	a2,0(a4)
 b80:	0500006f          	j	bd0 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b84:	ff852703          	lw	a4,-8(a0)
 b88:	00c7073b          	addw	a4,a4,a2
 b8c:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b90:	ff053683          	ld	a3,-16(a0)
 b94:	0540006f          	j	be8 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b98:	0007b703          	ld	a4,0(a5)
 b9c:	00e7e463          	bltu	a5,a4,ba4 <free+0x54>
 ba0:	00e6ec63          	bltu	a3,a4,bb8 <free+0x68>
{
 ba4:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ba8:	fed7f8e3          	bgeu	a5,a3,b98 <free+0x48>
 bac:	0007b703          	ld	a4,0(a5)
 bb0:	00e6e463          	bltu	a3,a4,bb8 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bb4:	fee7e8e3          	bltu	a5,a4,ba4 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 bb8:	ff852583          	lw	a1,-8(a0)
 bbc:	0007b603          	ld	a2,0(a5)
 bc0:	02059813          	slli	a6,a1,0x20
 bc4:	01c85713          	srli	a4,a6,0x1c
 bc8:	00e68733          	add	a4,a3,a4
 bcc:	fae600e3          	beq	a2,a4,b6c <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 bd0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 bd4:	0087a603          	lw	a2,8(a5)
 bd8:	02061593          	slli	a1,a2,0x20
 bdc:	01c5d713          	srli	a4,a1,0x1c
 be0:	00e78733          	add	a4,a5,a4
 be4:	fae680e3          	beq	a3,a4,b84 <free+0x34>
    p->s.ptr = bp->s.ptr;
 be8:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 bec:	00000717          	auipc	a4,0x0
 bf0:	40f73a23          	sd	a5,1044(a4) # 1000 <freep>
}
 bf4:	00813403          	ld	s0,8(sp)
 bf8:	01010113          	addi	sp,sp,16
 bfc:	00008067          	ret

0000000000000c00 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c00:	fc010113          	addi	sp,sp,-64
 c04:	02113c23          	sd	ra,56(sp)
 c08:	02813823          	sd	s0,48(sp)
 c0c:	02913423          	sd	s1,40(sp)
 c10:	01313c23          	sd	s3,24(sp)
 c14:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c18:	02051493          	slli	s1,a0,0x20
 c1c:	0204d493          	srli	s1,s1,0x20
 c20:	00f48493          	addi	s1,s1,15
 c24:	0044d493          	srli	s1,s1,0x4
 c28:	0014899b          	addiw	s3,s1,1
 c2c:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
 c30:	00000517          	auipc	a0,0x0
 c34:	3d053503          	ld	a0,976(a0) # 1000 <freep>
 c38:	04050663          	beqz	a0,c84 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c3c:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c40:	0087a703          	lw	a4,8(a5)
 c44:	0c977c63          	bgeu	a4,s1,d1c <malloc+0x11c>
 c48:	03213023          	sd	s2,32(sp)
 c4c:	01413823          	sd	s4,16(sp)
 c50:	01513423          	sd	s5,8(sp)
 c54:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
 c58:	00098a13          	mv	s4,s3
 c5c:	0009871b          	sext.w	a4,s3
 c60:	000016b7          	lui	a3,0x1
 c64:	00d77463          	bgeu	a4,a3,c6c <malloc+0x6c>
 c68:	00001a37          	lui	s4,0x1
 c6c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c70:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c74:	00000917          	auipc	s2,0x0
 c78:	38c90913          	addi	s2,s2,908 # 1000 <freep>
  if(p == (char*)-1)
 c7c:	fff00a93          	li	s5,-1
 c80:	05c0006f          	j	cdc <malloc+0xdc>
 c84:	03213023          	sd	s2,32(sp)
 c88:	01413823          	sd	s4,16(sp)
 c8c:	01513423          	sd	s5,8(sp)
 c90:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c94:	00000797          	auipc	a5,0x0
 c98:	57c78793          	addi	a5,a5,1404 # 1210 <base>
 c9c:	00000717          	auipc	a4,0x0
 ca0:	36f73223          	sd	a5,868(a4) # 1000 <freep>
 ca4:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 ca8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 cac:	fadff06f          	j	c58 <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
 cb0:	0007b703          	ld	a4,0(a5)
 cb4:	00e53023          	sd	a4,0(a0)
 cb8:	0800006f          	j	d38 <malloc+0x138>
  hp->s.size = nu;
 cbc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cc0:	01050513          	addi	a0,a0,16
 cc4:	e8dff0ef          	jal	b50 <free>
  return freep;
 cc8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 ccc:	08050863          	beqz	a0,d5c <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cd0:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cd4:	0087a703          	lw	a4,8(a5)
 cd8:	02977a63          	bgeu	a4,s1,d0c <malloc+0x10c>
    if(p == freep)
 cdc:	00093703          	ld	a4,0(s2)
 ce0:	00078513          	mv	a0,a5
 ce4:	fef716e3          	bne	a4,a5,cd0 <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
 ce8:	000a0513          	mv	a0,s4
 cec:	8fdff0ef          	jal	5e8 <sbrk>
  if(p == (char*)-1)
 cf0:	fd5516e3          	bne	a0,s5,cbc <malloc+0xbc>
        return 0;
 cf4:	00000513          	li	a0,0
 cf8:	02013903          	ld	s2,32(sp)
 cfc:	01013a03          	ld	s4,16(sp)
 d00:	00813a83          	ld	s5,8(sp)
 d04:	00013b03          	ld	s6,0(sp)
 d08:	03c0006f          	j	d44 <malloc+0x144>
 d0c:	02013903          	ld	s2,32(sp)
 d10:	01013a03          	ld	s4,16(sp)
 d14:	00813a83          	ld	s5,8(sp)
 d18:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
 d1c:	f8e48ae3          	beq	s1,a4,cb0 <malloc+0xb0>
        p->s.size -= nunits;
 d20:	4137073b          	subw	a4,a4,s3
 d24:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 d28:	02071693          	slli	a3,a4,0x20
 d2c:	01c6d713          	srli	a4,a3,0x1c
 d30:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 d34:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d38:	00000717          	auipc	a4,0x0
 d3c:	2ca73423          	sd	a0,712(a4) # 1000 <freep>
      return (void*)(p + 1);
 d40:	01078513          	addi	a0,a5,16
  }
}
 d44:	03813083          	ld	ra,56(sp)
 d48:	03013403          	ld	s0,48(sp)
 d4c:	02813483          	ld	s1,40(sp)
 d50:	01813983          	ld	s3,24(sp)
 d54:	04010113          	addi	sp,sp,64
 d58:	00008067          	ret
 d5c:	02013903          	ld	s2,32(sp)
 d60:	01013a03          	ld	s4,16(sp)
 d64:	00813a83          	ld	s5,8(sp)
 d68:	00013b03          	ld	s6,0(sp)
 d6c:	fd9ff06f          	j	d44 <malloc+0x144>
