
user/_grep:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	fd010113          	addi	sp,sp,-48
   4:	02113423          	sd	ra,40(sp)
   8:	02813023          	sd	s0,32(sp)
   c:	00913c23          	sd	s1,24(sp)
  10:	01213823          	sd	s2,16(sp)
  14:	01313423          	sd	s3,8(sp)
  18:	01413023          	sd	s4,0(sp)
  1c:	03010413          	addi	s0,sp,48
  20:	00050913          	mv	s2,a0
  24:	00058993          	mv	s3,a1
  28:	00060493          	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  2c:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  30:	00048593          	mv	a1,s1
  34:	00098513          	mv	a0,s3
  38:	048000ef          	jal	80 <matchhere>
  3c:	02051063          	bnez	a0,5c <matchstar+0x5c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  40:	0004c783          	lbu	a5,0(s1)
  44:	00078e63          	beqz	a5,60 <matchstar+0x60>
  48:	00148493          	addi	s1,s1,1
  4c:	0007879b          	sext.w	a5,a5
  50:	ff2780e3          	beq	a5,s2,30 <matchstar+0x30>
  54:	fd490ee3          	beq	s2,s4,30 <matchstar+0x30>
  58:	0080006f          	j	60 <matchstar+0x60>
      return 1;
  5c:	00100513          	li	a0,1
  return 0;
}
  60:	02813083          	ld	ra,40(sp)
  64:	02013403          	ld	s0,32(sp)
  68:	01813483          	ld	s1,24(sp)
  6c:	01013903          	ld	s2,16(sp)
  70:	00813983          	ld	s3,8(sp)
  74:	00013a03          	ld	s4,0(sp)
  78:	03010113          	addi	sp,sp,48
  7c:	00008067          	ret

0000000000000080 <matchhere>:
  if(re[0] == '\0')
  80:	00054703          	lbu	a4,0(a0)
  84:	08070e63          	beqz	a4,120 <matchhere+0xa0>
{
  88:	ff010113          	addi	sp,sp,-16
  8c:	00113423          	sd	ra,8(sp)
  90:	00813023          	sd	s0,0(sp)
  94:	01010413          	addi	s0,sp,16
  98:	00050793          	mv	a5,a0
  if(re[1] == '*')
  9c:	00154683          	lbu	a3,1(a0)
  a0:	02a00613          	li	a2,42
  a4:	02c68c63          	beq	a3,a2,dc <matchhere+0x5c>
  if(re[0] == '$' && re[1] == '\0')
  a8:	02400613          	li	a2,36
  ac:	04c70263          	beq	a4,a2,f0 <matchhere+0x70>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  b0:	0005c683          	lbu	a3,0(a1)
  return 0;
  b4:	00000513          	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  b8:	00068a63          	beqz	a3,cc <matchhere+0x4c>
  bc:	02e00613          	li	a2,46
  c0:	04c70863          	beq	a4,a2,110 <matchhere+0x90>
  return 0;
  c4:	00000513          	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  c8:	04d70463          	beq	a4,a3,110 <matchhere+0x90>
}
  cc:	00813083          	ld	ra,8(sp)
  d0:	00013403          	ld	s0,0(sp)
  d4:	01010113          	addi	sp,sp,16
  d8:	00008067          	ret
    return matchstar(re[0], re+2, text);
  dc:	00058613          	mv	a2,a1
  e0:	00250593          	addi	a1,a0,2
  e4:	00070513          	mv	a0,a4
  e8:	f19ff0ef          	jal	0 <matchstar>
  ec:	fe1ff06f          	j	cc <matchhere+0x4c>
  if(re[0] == '$' && re[1] == '\0')
  f0:	00068a63          	beqz	a3,104 <matchhere+0x84>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  f4:	0005c683          	lbu	a3,0(a1)
  f8:	fc0696e3          	bnez	a3,c4 <matchhere+0x44>
  return 0;
  fc:	00000513          	li	a0,0
 100:	fcdff06f          	j	cc <matchhere+0x4c>
    return *text == '\0';
 104:	0005c503          	lbu	a0,0(a1)
 108:	00153513          	seqz	a0,a0
 10c:	fc1ff06f          	j	cc <matchhere+0x4c>
    return matchhere(re+1, text+1);
 110:	00158593          	addi	a1,a1,1
 114:	00178513          	addi	a0,a5,1
 118:	f69ff0ef          	jal	80 <matchhere>
 11c:	fb1ff06f          	j	cc <matchhere+0x4c>
    return 1;
 120:	00100513          	li	a0,1
}
 124:	00008067          	ret

0000000000000128 <match>:
{
 128:	fe010113          	addi	sp,sp,-32
 12c:	00113c23          	sd	ra,24(sp)
 130:	00813823          	sd	s0,16(sp)
 134:	00913423          	sd	s1,8(sp)
 138:	01213023          	sd	s2,0(sp)
 13c:	02010413          	addi	s0,sp,32
 140:	00050913          	mv	s2,a0
 144:	00058493          	mv	s1,a1
  if(re[0] == '^')
 148:	00054703          	lbu	a4,0(a0)
 14c:	05e00793          	li	a5,94
 150:	02f70263          	beq	a4,a5,174 <match+0x4c>
    if(matchhere(re, text))
 154:	00048593          	mv	a1,s1
 158:	00090513          	mv	a0,s2
 15c:	f25ff0ef          	jal	80 <matchhere>
 160:	02051063          	bnez	a0,180 <match+0x58>
  }while(*text++ != '\0');
 164:	00148493          	addi	s1,s1,1
 168:	fff4c783          	lbu	a5,-1(s1)
 16c:	fe0794e3          	bnez	a5,154 <match+0x2c>
 170:	0140006f          	j	184 <match+0x5c>
    return matchhere(re+1, text);
 174:	00150513          	addi	a0,a0,1
 178:	f09ff0ef          	jal	80 <matchhere>
 17c:	0080006f          	j	184 <match+0x5c>
      return 1;
 180:	00100513          	li	a0,1
}
 184:	01813083          	ld	ra,24(sp)
 188:	01013403          	ld	s0,16(sp)
 18c:	00813483          	ld	s1,8(sp)
 190:	00013903          	ld	s2,0(sp)
 194:	02010113          	addi	sp,sp,32
 198:	00008067          	ret

000000000000019c <grep>:
{
 19c:	fb010113          	addi	sp,sp,-80
 1a0:	04113423          	sd	ra,72(sp)
 1a4:	04813023          	sd	s0,64(sp)
 1a8:	02913c23          	sd	s1,56(sp)
 1ac:	03213823          	sd	s2,48(sp)
 1b0:	03313423          	sd	s3,40(sp)
 1b4:	03413023          	sd	s4,32(sp)
 1b8:	01513c23          	sd	s5,24(sp)
 1bc:	01613823          	sd	s6,16(sp)
 1c0:	01713423          	sd	s7,8(sp)
 1c4:	01813023          	sd	s8,0(sp)
 1c8:	05010413          	addi	s0,sp,80
 1cc:	00050993          	mv	s3,a0
 1d0:	00058b13          	mv	s6,a1
  m = 0;
 1d4:	00000a13          	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 1d8:	3ff00b93          	li	s7,1023
 1dc:	00002a97          	auipc	s5,0x2
 1e0:	e34a8a93          	addi	s5,s5,-460 # 2010 <buf>
 1e4:	0540006f          	j	238 <grep+0x9c>
      p = q+1;
 1e8:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 1ec:	00a00593          	li	a1,10
 1f0:	00090513          	mv	a0,s2
 1f4:	294000ef          	jal	488 <strchr>
 1f8:	00050493          	mv	s1,a0
 1fc:	02050c63          	beqz	a0,234 <grep+0x98>
      *q = 0;
 200:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 204:	00090593          	mv	a1,s2
 208:	00098513          	mv	a0,s3
 20c:	f1dff0ef          	jal	128 <match>
 210:	fc050ce3          	beqz	a0,1e8 <grep+0x4c>
        *q = '\n';
 214:	00a00793          	li	a5,10
 218:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 21c:	00148613          	addi	a2,s1,1
 220:	4126063b          	subw	a2,a2,s2
 224:	00090593          	mv	a1,s2
 228:	00100513          	li	a0,1
 22c:	554000ef          	jal	780 <write>
 230:	fb9ff06f          	j	1e8 <grep+0x4c>
    if(m > 0){
 234:	03404863          	bgtz	s4,264 <grep+0xc8>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 238:	414b863b          	subw	a2,s7,s4
 23c:	014a85b3          	add	a1,s5,s4
 240:	000b0513          	mv	a0,s6
 244:	530000ef          	jal	774 <read>
 248:	02a05e63          	blez	a0,284 <grep+0xe8>
    m += n;
 24c:	00aa0c3b          	addw	s8,s4,a0
 250:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
 254:	014a87b3          	add	a5,s5,s4
 258:	00078023          	sb	zero,0(a5)
    p = buf;
 25c:	000a8913          	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 260:	f8dff06f          	j	1ec <grep+0x50>
      m -= p - buf;
 264:	00002517          	auipc	a0,0x2
 268:	dac50513          	addi	a0,a0,-596 # 2010 <buf>
 26c:	40a90a33          	sub	s4,s2,a0
 270:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
 274:	000a0613          	mv	a2,s4
 278:	00090593          	mv	a1,s2
 27c:	3cc000ef          	jal	648 <memmove>
 280:	fb9ff06f          	j	238 <grep+0x9c>
}
 284:	04813083          	ld	ra,72(sp)
 288:	04013403          	ld	s0,64(sp)
 28c:	03813483          	ld	s1,56(sp)
 290:	03013903          	ld	s2,48(sp)
 294:	02813983          	ld	s3,40(sp)
 298:	02013a03          	ld	s4,32(sp)
 29c:	01813a83          	ld	s5,24(sp)
 2a0:	01013b03          	ld	s6,16(sp)
 2a4:	00813b83          	ld	s7,8(sp)
 2a8:	00013c03          	ld	s8,0(sp)
 2ac:	05010113          	addi	sp,sp,80
 2b0:	00008067          	ret

00000000000002b4 <main>:
{
 2b4:	fd010113          	addi	sp,sp,-48
 2b8:	02113423          	sd	ra,40(sp)
 2bc:	02813023          	sd	s0,32(sp)
 2c0:	00913c23          	sd	s1,24(sp)
 2c4:	01213823          	sd	s2,16(sp)
 2c8:	01313423          	sd	s3,8(sp)
 2cc:	01413023          	sd	s4,0(sp)
 2d0:	03010413          	addi	s0,sp,48
  if(argc <= 1){
 2d4:	00100793          	li	a5,1
 2d8:	06a7d063          	bge	a5,a0,338 <main+0x84>
  pattern = argv[1];
 2dc:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 2e0:	00200793          	li	a5,2
 2e4:	06a7d663          	bge	a5,a0,350 <main+0x9c>
 2e8:	01058913          	addi	s2,a1,16
 2ec:	ffd5099b          	addiw	s3,a0,-3
 2f0:	02099793          	slli	a5,s3,0x20
 2f4:	01d7d993          	srli	s3,a5,0x1d
 2f8:	01858593          	addi	a1,a1,24
 2fc:	00b989b3          	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 300:	00000593          	li	a1,0
 304:	00093503          	ld	a0,0(s2)
 308:	4a8000ef          	jal	7b0 <open>
 30c:	00050493          	mv	s1,a0
 310:	04054a63          	bltz	a0,364 <main+0xb0>
    grep(pattern, fd);
 314:	00050593          	mv	a1,a0
 318:	000a0513          	mv	a0,s4
 31c:	e81ff0ef          	jal	19c <grep>
    close(fd);
 320:	00048513          	mv	a0,s1
 324:	468000ef          	jal	78c <close>
  for(i = 2; i < argc; i++){
 328:	00890913          	addi	s2,s2,8
 32c:	fd391ae3          	bne	s2,s3,300 <main+0x4c>
  exit(0);
 330:	00000513          	li	a0,0
 334:	41c000ef          	jal	750 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 338:	00001597          	auipc	a1,0x1
 33c:	c7858593          	addi	a1,a1,-904 # fb0 <malloc+0x17c>
 340:	00200513          	li	a0,2
 344:	1ad000ef          	jal	cf0 <fprintf>
    exit(1);
 348:	00100513          	li	a0,1
 34c:	404000ef          	jal	750 <exit>
    grep(pattern, 0);
 350:	00000593          	li	a1,0
 354:	000a0513          	mv	a0,s4
 358:	e45ff0ef          	jal	19c <grep>
    exit(0);
 35c:	00000513          	li	a0,0
 360:	3f0000ef          	jal	750 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 364:	00093583          	ld	a1,0(s2)
 368:	00001517          	auipc	a0,0x1
 36c:	c6850513          	addi	a0,a0,-920 # fd0 <malloc+0x19c>
 370:	1c5000ef          	jal	d34 <printf>
      exit(1);
 374:	00100513          	li	a0,1
 378:	3d8000ef          	jal	750 <exit>

000000000000037c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 37c:	ff010113          	addi	sp,sp,-16
 380:	00113423          	sd	ra,8(sp)
 384:	00813023          	sd	s0,0(sp)
 388:	01010413          	addi	s0,sp,16
  extern int main();
  main();
 38c:	f29ff0ef          	jal	2b4 <main>
  exit(0);
 390:	00000513          	li	a0,0
 394:	3bc000ef          	jal	750 <exit>

0000000000000398 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 398:	ff010113          	addi	sp,sp,-16
 39c:	00813423          	sd	s0,8(sp)
 3a0:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3a4:	00050793          	mv	a5,a0
 3a8:	00158593          	addi	a1,a1,1
 3ac:	00178793          	addi	a5,a5,1
 3b0:	fff5c703          	lbu	a4,-1(a1)
 3b4:	fee78fa3          	sb	a4,-1(a5)
 3b8:	fe0718e3          	bnez	a4,3a8 <strcpy+0x10>
    ;
  return os;
}
 3bc:	00813403          	ld	s0,8(sp)
 3c0:	01010113          	addi	sp,sp,16
 3c4:	00008067          	ret

00000000000003c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3c8:	ff010113          	addi	sp,sp,-16
 3cc:	00813423          	sd	s0,8(sp)
 3d0:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
 3d4:	00054783          	lbu	a5,0(a0)
 3d8:	00078e63          	beqz	a5,3f4 <strcmp+0x2c>
 3dc:	0005c703          	lbu	a4,0(a1)
 3e0:	00f71a63          	bne	a4,a5,3f4 <strcmp+0x2c>
    p++, q++;
 3e4:	00150513          	addi	a0,a0,1
 3e8:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
 3ec:	00054783          	lbu	a5,0(a0)
 3f0:	fe0796e3          	bnez	a5,3dc <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 3f4:	0005c503          	lbu	a0,0(a1)
}
 3f8:	40a7853b          	subw	a0,a5,a0
 3fc:	00813403          	ld	s0,8(sp)
 400:	01010113          	addi	sp,sp,16
 404:	00008067          	ret

0000000000000408 <strlen>:

uint
strlen(const char *s)
{
 408:	ff010113          	addi	sp,sp,-16
 40c:	00813423          	sd	s0,8(sp)
 410:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 414:	00054783          	lbu	a5,0(a0)
 418:	02078863          	beqz	a5,448 <strlen+0x40>
 41c:	00150513          	addi	a0,a0,1
 420:	00050793          	mv	a5,a0
 424:	00078693          	mv	a3,a5
 428:	00178793          	addi	a5,a5,1
 42c:	fff7c703          	lbu	a4,-1(a5)
 430:	fe071ae3          	bnez	a4,424 <strlen+0x1c>
 434:	40a6853b          	subw	a0,a3,a0
 438:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
 43c:	00813403          	ld	s0,8(sp)
 440:	01010113          	addi	sp,sp,16
 444:	00008067          	ret
  for(n = 0; s[n]; n++)
 448:	00000513          	li	a0,0
 44c:	ff1ff06f          	j	43c <strlen+0x34>

0000000000000450 <memset>:

void*
memset(void *dst, int c, uint n)
{
 450:	ff010113          	addi	sp,sp,-16
 454:	00813423          	sd	s0,8(sp)
 458:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 45c:	02060063          	beqz	a2,47c <memset+0x2c>
 460:	00050793          	mv	a5,a0
 464:	02061613          	slli	a2,a2,0x20
 468:	02065613          	srli	a2,a2,0x20
 46c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 470:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 474:	00178793          	addi	a5,a5,1
 478:	fee79ce3          	bne	a5,a4,470 <memset+0x20>
  }
  return dst;
}
 47c:	00813403          	ld	s0,8(sp)
 480:	01010113          	addi	sp,sp,16
 484:	00008067          	ret

0000000000000488 <strchr>:

char*
strchr(const char *s, char c)
{
 488:	ff010113          	addi	sp,sp,-16
 48c:	00813423          	sd	s0,8(sp)
 490:	01010413          	addi	s0,sp,16
  for(; *s; s++)
 494:	00054783          	lbu	a5,0(a0)
 498:	02078263          	beqz	a5,4bc <strchr+0x34>
    if(*s == c)
 49c:	00f58a63          	beq	a1,a5,4b0 <strchr+0x28>
  for(; *s; s++)
 4a0:	00150513          	addi	a0,a0,1
 4a4:	00054783          	lbu	a5,0(a0)
 4a8:	fe079ae3          	bnez	a5,49c <strchr+0x14>
      return (char*)s;
  return 0;
 4ac:	00000513          	li	a0,0
}
 4b0:	00813403          	ld	s0,8(sp)
 4b4:	01010113          	addi	sp,sp,16
 4b8:	00008067          	ret
  return 0;
 4bc:	00000513          	li	a0,0
 4c0:	ff1ff06f          	j	4b0 <strchr+0x28>

00000000000004c4 <gets>:

char*
gets(char *buf, int max)
{
 4c4:	fa010113          	addi	sp,sp,-96
 4c8:	04113c23          	sd	ra,88(sp)
 4cc:	04813823          	sd	s0,80(sp)
 4d0:	04913423          	sd	s1,72(sp)
 4d4:	05213023          	sd	s2,64(sp)
 4d8:	03313c23          	sd	s3,56(sp)
 4dc:	03413823          	sd	s4,48(sp)
 4e0:	03513423          	sd	s5,40(sp)
 4e4:	03613023          	sd	s6,32(sp)
 4e8:	01713c23          	sd	s7,24(sp)
 4ec:	06010413          	addi	s0,sp,96
 4f0:	00050b93          	mv	s7,a0
 4f4:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4f8:	00050913          	mv	s2,a0
 4fc:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 500:	00a00a93          	li	s5,10
 504:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 508:	00048993          	mv	s3,s1
 50c:	0014849b          	addiw	s1,s1,1
 510:	0344dc63          	bge	s1,s4,548 <gets+0x84>
    cc = read(0, &c, 1);
 514:	00100613          	li	a2,1
 518:	faf40593          	addi	a1,s0,-81
 51c:	00000513          	li	a0,0
 520:	254000ef          	jal	774 <read>
    if(cc < 1)
 524:	02a05263          	blez	a0,548 <gets+0x84>
    buf[i++] = c;
 528:	faf44783          	lbu	a5,-81(s0)
 52c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 530:	01578a63          	beq	a5,s5,544 <gets+0x80>
 534:	00190913          	addi	s2,s2,1
 538:	fd6798e3          	bne	a5,s6,508 <gets+0x44>
    buf[i++] = c;
 53c:	00048993          	mv	s3,s1
 540:	0080006f          	j	548 <gets+0x84>
 544:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 548:	013b89b3          	add	s3,s7,s3
 54c:	00098023          	sb	zero,0(s3)
  return buf;
}
 550:	000b8513          	mv	a0,s7
 554:	05813083          	ld	ra,88(sp)
 558:	05013403          	ld	s0,80(sp)
 55c:	04813483          	ld	s1,72(sp)
 560:	04013903          	ld	s2,64(sp)
 564:	03813983          	ld	s3,56(sp)
 568:	03013a03          	ld	s4,48(sp)
 56c:	02813a83          	ld	s5,40(sp)
 570:	02013b03          	ld	s6,32(sp)
 574:	01813b83          	ld	s7,24(sp)
 578:	06010113          	addi	sp,sp,96
 57c:	00008067          	ret

0000000000000580 <stat>:

int
stat(const char *n, struct stat *st)
{
 580:	fe010113          	addi	sp,sp,-32
 584:	00113c23          	sd	ra,24(sp)
 588:	00813823          	sd	s0,16(sp)
 58c:	01213023          	sd	s2,0(sp)
 590:	02010413          	addi	s0,sp,32
 594:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 598:	00000593          	li	a1,0
 59c:	214000ef          	jal	7b0 <open>
  if(fd < 0)
 5a0:	02054e63          	bltz	a0,5dc <stat+0x5c>
 5a4:	00913423          	sd	s1,8(sp)
 5a8:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5ac:	00090593          	mv	a1,s2
 5b0:	224000ef          	jal	7d4 <fstat>
 5b4:	00050913          	mv	s2,a0
  close(fd);
 5b8:	00048513          	mv	a0,s1
 5bc:	1d0000ef          	jal	78c <close>
  return r;
 5c0:	00813483          	ld	s1,8(sp)
}
 5c4:	00090513          	mv	a0,s2
 5c8:	01813083          	ld	ra,24(sp)
 5cc:	01013403          	ld	s0,16(sp)
 5d0:	00013903          	ld	s2,0(sp)
 5d4:	02010113          	addi	sp,sp,32
 5d8:	00008067          	ret
    return -1;
 5dc:	fff00913          	li	s2,-1
 5e0:	fe5ff06f          	j	5c4 <stat+0x44>

00000000000005e4 <atoi>:

int
atoi(const char *s)
{
 5e4:	ff010113          	addi	sp,sp,-16
 5e8:	00813423          	sd	s0,8(sp)
 5ec:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5f0:	00054683          	lbu	a3,0(a0)
 5f4:	fd06879b          	addiw	a5,a3,-48
 5f8:	0ff7f793          	zext.b	a5,a5
 5fc:	00900613          	li	a2,9
 600:	04f66063          	bltu	a2,a5,640 <atoi+0x5c>
 604:	00050713          	mv	a4,a0
  n = 0;
 608:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 60c:	00170713          	addi	a4,a4,1
 610:	0025179b          	slliw	a5,a0,0x2
 614:	00a787bb          	addw	a5,a5,a0
 618:	0017979b          	slliw	a5,a5,0x1
 61c:	00d787bb          	addw	a5,a5,a3
 620:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 624:	00074683          	lbu	a3,0(a4)
 628:	fd06879b          	addiw	a5,a3,-48
 62c:	0ff7f793          	zext.b	a5,a5
 630:	fcf67ee3          	bgeu	a2,a5,60c <atoi+0x28>
  return n;
}
 634:	00813403          	ld	s0,8(sp)
 638:	01010113          	addi	sp,sp,16
 63c:	00008067          	ret
  n = 0;
 640:	00000513          	li	a0,0
 644:	ff1ff06f          	j	634 <atoi+0x50>

0000000000000648 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 648:	ff010113          	addi	sp,sp,-16
 64c:	00813423          	sd	s0,8(sp)
 650:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 654:	02b57c63          	bgeu	a0,a1,68c <memmove+0x44>
    while(n-- > 0)
 658:	02c05463          	blez	a2,680 <memmove+0x38>
 65c:	02061613          	slli	a2,a2,0x20
 660:	02065613          	srli	a2,a2,0x20
 664:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 668:	00050713          	mv	a4,a0
      *dst++ = *src++;
 66c:	00158593          	addi	a1,a1,1
 670:	00170713          	addi	a4,a4,1
 674:	fff5c683          	lbu	a3,-1(a1)
 678:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 67c:	fef718e3          	bne	a4,a5,66c <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 680:	00813403          	ld	s0,8(sp)
 684:	01010113          	addi	sp,sp,16
 688:	00008067          	ret
    dst += n;
 68c:	00c50733          	add	a4,a0,a2
    src += n;
 690:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 694:	fec056e3          	blez	a2,680 <memmove+0x38>
 698:	fff6079b          	addiw	a5,a2,-1
 69c:	02079793          	slli	a5,a5,0x20
 6a0:	0207d793          	srli	a5,a5,0x20
 6a4:	fff7c793          	not	a5,a5
 6a8:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 6ac:	fff58593          	addi	a1,a1,-1
 6b0:	fff70713          	addi	a4,a4,-1
 6b4:	0005c683          	lbu	a3,0(a1)
 6b8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6bc:	fee798e3          	bne	a5,a4,6ac <memmove+0x64>
 6c0:	fc1ff06f          	j	680 <memmove+0x38>

00000000000006c4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6c4:	ff010113          	addi	sp,sp,-16
 6c8:	00813423          	sd	s0,8(sp)
 6cc:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6d0:	04060463          	beqz	a2,718 <memcmp+0x54>
 6d4:	fff6069b          	addiw	a3,a2,-1
 6d8:	02069693          	slli	a3,a3,0x20
 6dc:	0206d693          	srli	a3,a3,0x20
 6e0:	00168693          	addi	a3,a3,1
 6e4:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 6e8:	00054783          	lbu	a5,0(a0)
 6ec:	0005c703          	lbu	a4,0(a1)
 6f0:	00e79c63          	bne	a5,a4,708 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 6f4:	00150513          	addi	a0,a0,1
    p2++;
 6f8:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
 6fc:	fed516e3          	bne	a0,a3,6e8 <memcmp+0x24>
  }
  return 0;
 700:	00000513          	li	a0,0
 704:	0080006f          	j	70c <memcmp+0x48>
      return *p1 - *p2;
 708:	40e7853b          	subw	a0,a5,a4
}
 70c:	00813403          	ld	s0,8(sp)
 710:	01010113          	addi	sp,sp,16
 714:	00008067          	ret
  return 0;
 718:	00000513          	li	a0,0
 71c:	ff1ff06f          	j	70c <memcmp+0x48>

0000000000000720 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 720:	ff010113          	addi	sp,sp,-16
 724:	00113423          	sd	ra,8(sp)
 728:	00813023          	sd	s0,0(sp)
 72c:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
 730:	f19ff0ef          	jal	648 <memmove>
}
 734:	00813083          	ld	ra,8(sp)
 738:	00013403          	ld	s0,0(sp)
 73c:	01010113          	addi	sp,sp,16
 740:	00008067          	ret

0000000000000744 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 744:	00100893          	li	a7,1
 ecall
 748:	00000073          	ecall
 ret
 74c:	00008067          	ret

0000000000000750 <exit>:
.global exit
exit:
 li a7, SYS_exit
 750:	00200893          	li	a7,2
 ecall
 754:	00000073          	ecall
 ret
 758:	00008067          	ret

000000000000075c <wait>:
.global wait
wait:
 li a7, SYS_wait
 75c:	00300893          	li	a7,3
 ecall
 760:	00000073          	ecall
 ret
 764:	00008067          	ret

0000000000000768 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 768:	00400893          	li	a7,4
 ecall
 76c:	00000073          	ecall
 ret
 770:	00008067          	ret

0000000000000774 <read>:
.global read
read:
 li a7, SYS_read
 774:	00500893          	li	a7,5
 ecall
 778:	00000073          	ecall
 ret
 77c:	00008067          	ret

0000000000000780 <write>:
.global write
write:
 li a7, SYS_write
 780:	01000893          	li	a7,16
 ecall
 784:	00000073          	ecall
 ret
 788:	00008067          	ret

000000000000078c <close>:
.global close
close:
 li a7, SYS_close
 78c:	01500893          	li	a7,21
 ecall
 790:	00000073          	ecall
 ret
 794:	00008067          	ret

0000000000000798 <kill>:
.global kill
kill:
 li a7, SYS_kill
 798:	00600893          	li	a7,6
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	00008067          	ret

00000000000007a4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 7a4:	00700893          	li	a7,7
 ecall
 7a8:	00000073          	ecall
 ret
 7ac:	00008067          	ret

00000000000007b0 <open>:
.global open
open:
 li a7, SYS_open
 7b0:	00f00893          	li	a7,15
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	00008067          	ret

00000000000007bc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7bc:	01100893          	li	a7,17
 ecall
 7c0:	00000073          	ecall
 ret
 7c4:	00008067          	ret

00000000000007c8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7c8:	01200893          	li	a7,18
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	00008067          	ret

00000000000007d4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7d4:	00800893          	li	a7,8
 ecall
 7d8:	00000073          	ecall
 ret
 7dc:	00008067          	ret

00000000000007e0 <link>:
.global link
link:
 li a7, SYS_link
 7e0:	01300893          	li	a7,19
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	00008067          	ret

00000000000007ec <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7ec:	01400893          	li	a7,20
 ecall
 7f0:	00000073          	ecall
 ret
 7f4:	00008067          	ret

00000000000007f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7f8:	00900893          	li	a7,9
 ecall
 7fc:	00000073          	ecall
 ret
 800:	00008067          	ret

0000000000000804 <dup>:
.global dup
dup:
 li a7, SYS_dup
 804:	00a00893          	li	a7,10
 ecall
 808:	00000073          	ecall
 ret
 80c:	00008067          	ret

0000000000000810 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 810:	00b00893          	li	a7,11
 ecall
 814:	00000073          	ecall
 ret
 818:	00008067          	ret

000000000000081c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 81c:	00c00893          	li	a7,12
 ecall
 820:	00000073          	ecall
 ret
 824:	00008067          	ret

0000000000000828 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 828:	00d00893          	li	a7,13
 ecall
 82c:	00000073          	ecall
 ret
 830:	00008067          	ret

0000000000000834 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 834:	00e00893          	li	a7,14
 ecall
 838:	00000073          	ecall
 ret
 83c:	00008067          	ret

0000000000000840 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 840:	fe010113          	addi	sp,sp,-32
 844:	00113c23          	sd	ra,24(sp)
 848:	00813823          	sd	s0,16(sp)
 84c:	02010413          	addi	s0,sp,32
 850:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 854:	00100613          	li	a2,1
 858:	fef40593          	addi	a1,s0,-17
 85c:	f25ff0ef          	jal	780 <write>
}
 860:	01813083          	ld	ra,24(sp)
 864:	01013403          	ld	s0,16(sp)
 868:	02010113          	addi	sp,sp,32
 86c:	00008067          	ret

0000000000000870 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 870:	fc010113          	addi	sp,sp,-64
 874:	02113c23          	sd	ra,56(sp)
 878:	02813823          	sd	s0,48(sp)
 87c:	02913423          	sd	s1,40(sp)
 880:	04010413          	addi	s0,sp,64
 884:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 888:	00068463          	beqz	a3,890 <printint+0x20>
 88c:	0c05c263          	bltz	a1,950 <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 890:	0005859b          	sext.w	a1,a1
  neg = 0;
 894:	00000893          	li	a7,0
 898:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 89c:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 8a0:	0006061b          	sext.w	a2,a2
 8a4:	00000517          	auipc	a0,0x0
 8a8:	74c50513          	addi	a0,a0,1868 # ff0 <digits>
 8ac:	00070813          	mv	a6,a4
 8b0:	0017071b          	addiw	a4,a4,1
 8b4:	02c5f7bb          	remuw	a5,a1,a2
 8b8:	02079793          	slli	a5,a5,0x20
 8bc:	0207d793          	srli	a5,a5,0x20
 8c0:	00f507b3          	add	a5,a0,a5
 8c4:	0007c783          	lbu	a5,0(a5)
 8c8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 8cc:	0005879b          	sext.w	a5,a1
 8d0:	02c5d5bb          	divuw	a1,a1,a2
 8d4:	00168693          	addi	a3,a3,1
 8d8:	fcc7fae3          	bgeu	a5,a2,8ac <printint+0x3c>
  if(neg)
 8dc:	00088c63          	beqz	a7,8f4 <printint+0x84>
    buf[i++] = '-';
 8e0:	fd070793          	addi	a5,a4,-48
 8e4:	00878733          	add	a4,a5,s0
 8e8:	02d00793          	li	a5,45
 8ec:	fef70823          	sb	a5,-16(a4)
 8f0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 8f4:	04e05463          	blez	a4,93c <printint+0xcc>
 8f8:	03213023          	sd	s2,32(sp)
 8fc:	01313c23          	sd	s3,24(sp)
 900:	fc040793          	addi	a5,s0,-64
 904:	00e78933          	add	s2,a5,a4
 908:	fff78993          	addi	s3,a5,-1
 90c:	00e989b3          	add	s3,s3,a4
 910:	fff7071b          	addiw	a4,a4,-1
 914:	02071713          	slli	a4,a4,0x20
 918:	02075713          	srli	a4,a4,0x20
 91c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 920:	fff94583          	lbu	a1,-1(s2)
 924:	00048513          	mv	a0,s1
 928:	f19ff0ef          	jal	840 <putc>
  while(--i >= 0)
 92c:	fff90913          	addi	s2,s2,-1
 930:	ff3918e3          	bne	s2,s3,920 <printint+0xb0>
 934:	02013903          	ld	s2,32(sp)
 938:	01813983          	ld	s3,24(sp)
}
 93c:	03813083          	ld	ra,56(sp)
 940:	03013403          	ld	s0,48(sp)
 944:	02813483          	ld	s1,40(sp)
 948:	04010113          	addi	sp,sp,64
 94c:	00008067          	ret
    x = -xx;
 950:	40b005bb          	negw	a1,a1
    neg = 1;
 954:	00100893          	li	a7,1
    x = -xx;
 958:	f41ff06f          	j	898 <printint+0x28>

000000000000095c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 95c:	fa010113          	addi	sp,sp,-96
 960:	04113c23          	sd	ra,88(sp)
 964:	04813823          	sd	s0,80(sp)
 968:	05213023          	sd	s2,64(sp)
 96c:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 970:	0005c903          	lbu	s2,0(a1)
 974:	36090463          	beqz	s2,cdc <vprintf+0x380>
 978:	04913423          	sd	s1,72(sp)
 97c:	03313c23          	sd	s3,56(sp)
 980:	03413823          	sd	s4,48(sp)
 984:	03513423          	sd	s5,40(sp)
 988:	03613023          	sd	s6,32(sp)
 98c:	01713c23          	sd	s7,24(sp)
 990:	01813823          	sd	s8,16(sp)
 994:	01913423          	sd	s9,8(sp)
 998:	00050b13          	mv	s6,a0
 99c:	00058a13          	mv	s4,a1
 9a0:	00060b93          	mv	s7,a2
  state = 0;
 9a4:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
 9a8:	00000493          	li	s1,0
 9ac:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 9b0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 9b4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 9b8:	06c00c93          	li	s9,108
 9bc:	02c0006f          	j	9e8 <vprintf+0x8c>
        putc(fd, c0);
 9c0:	00090593          	mv	a1,s2
 9c4:	000b0513          	mv	a0,s6
 9c8:	e79ff0ef          	jal	840 <putc>
 9cc:	0080006f          	j	9d4 <vprintf+0x78>
    } else if(state == '%'){
 9d0:	03598663          	beq	s3,s5,9fc <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
 9d4:	0014849b          	addiw	s1,s1,1
 9d8:	00048713          	mv	a4,s1
 9dc:	009a07b3          	add	a5,s4,s1
 9e0:	0007c903          	lbu	s2,0(a5)
 9e4:	2c090c63          	beqz	s2,cbc <vprintf+0x360>
    c0 = fmt[i] & 0xff;
 9e8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 9ec:	fe0992e3          	bnez	s3,9d0 <vprintf+0x74>
      if(c0 == '%'){
 9f0:	fd5798e3          	bne	a5,s5,9c0 <vprintf+0x64>
        state = '%';
 9f4:	00078993          	mv	s3,a5
 9f8:	fddff06f          	j	9d4 <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
 9fc:	00ea06b3          	add	a3,s4,a4
 a00:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 a04:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 a08:	00068663          	beqz	a3,a14 <vprintf+0xb8>
 a0c:	00ea0733          	add	a4,s4,a4
 a10:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 a14:	05878263          	beq	a5,s8,a58 <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
 a18:	07978263          	beq	a5,s9,a7c <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 a1c:	07500713          	li	a4,117
 a20:	12e78663          	beq	a5,a4,b4c <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 a24:	07800713          	li	a4,120
 a28:	18e78c63          	beq	a5,a4,bc0 <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 a2c:	07000713          	li	a4,112
 a30:	1ce78e63          	beq	a5,a4,c0c <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 a34:	07300713          	li	a4,115
 a38:	22e78a63          	beq	a5,a4,c6c <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 a3c:	02500713          	li	a4,37
 a40:	04e79e63          	bne	a5,a4,a9c <vprintf+0x140>
        putc(fd, '%');
 a44:	02500593          	li	a1,37
 a48:	000b0513          	mv	a0,s6
 a4c:	df5ff0ef          	jal	840 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 a50:	00000993          	li	s3,0
 a54:	f81ff06f          	j	9d4 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
 a58:	008b8913          	addi	s2,s7,8
 a5c:	00100693          	li	a3,1
 a60:	00a00613          	li	a2,10
 a64:	000ba583          	lw	a1,0(s7)
 a68:	000b0513          	mv	a0,s6
 a6c:	e05ff0ef          	jal	870 <printint>
 a70:	00090b93          	mv	s7,s2
      state = 0;
 a74:	00000993          	li	s3,0
 a78:	f5dff06f          	j	9d4 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
 a7c:	06400793          	li	a5,100
 a80:	02f68e63          	beq	a3,a5,abc <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a84:	06c00793          	li	a5,108
 a88:	04f68e63          	beq	a3,a5,ae4 <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
 a8c:	07500793          	li	a5,117
 a90:	0ef68063          	beq	a3,a5,b70 <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
 a94:	07800793          	li	a5,120
 a98:	14f68663          	beq	a3,a5,be4 <vprintf+0x288>
        putc(fd, '%');
 a9c:	02500593          	li	a1,37
 aa0:	000b0513          	mv	a0,s6
 aa4:	d9dff0ef          	jal	840 <putc>
        putc(fd, c0);
 aa8:	00090593          	mv	a1,s2
 aac:	000b0513          	mv	a0,s6
 ab0:	d91ff0ef          	jal	840 <putc>
      state = 0;
 ab4:	00000993          	li	s3,0
 ab8:	f1dff06f          	j	9d4 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 abc:	008b8913          	addi	s2,s7,8
 ac0:	00100693          	li	a3,1
 ac4:	00a00613          	li	a2,10
 ac8:	000ba583          	lw	a1,0(s7)
 acc:	000b0513          	mv	a0,s6
 ad0:	da1ff0ef          	jal	870 <printint>
        i += 1;
 ad4:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 ad8:	00090b93          	mv	s7,s2
      state = 0;
 adc:	00000993          	li	s3,0
        i += 1;
 ae0:	ef5ff06f          	j	9d4 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 ae4:	06400793          	li	a5,100
 ae8:	02f60e63          	beq	a2,a5,b24 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 aec:	07500793          	li	a5,117
 af0:	0af60463          	beq	a2,a5,b98 <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 af4:	07800793          	li	a5,120
 af8:	faf612e3          	bne	a2,a5,a9c <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
 afc:	008b8913          	addi	s2,s7,8
 b00:	00000693          	li	a3,0
 b04:	01000613          	li	a2,16
 b08:	000ba583          	lw	a1,0(s7)
 b0c:	000b0513          	mv	a0,s6
 b10:	d61ff0ef          	jal	870 <printint>
        i += 2;
 b14:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 b18:	00090b93          	mv	s7,s2
      state = 0;
 b1c:	00000993          	li	s3,0
        i += 2;
 b20:	eb5ff06f          	j	9d4 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 b24:	008b8913          	addi	s2,s7,8
 b28:	00100693          	li	a3,1
 b2c:	00a00613          	li	a2,10
 b30:	000ba583          	lw	a1,0(s7)
 b34:	000b0513          	mv	a0,s6
 b38:	d39ff0ef          	jal	870 <printint>
        i += 2;
 b3c:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 b40:	00090b93          	mv	s7,s2
      state = 0;
 b44:	00000993          	li	s3,0
        i += 2;
 b48:	e8dff06f          	j	9d4 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
 b4c:	008b8913          	addi	s2,s7,8
 b50:	00000693          	li	a3,0
 b54:	00a00613          	li	a2,10
 b58:	000ba583          	lw	a1,0(s7)
 b5c:	000b0513          	mv	a0,s6
 b60:	d11ff0ef          	jal	870 <printint>
 b64:	00090b93          	mv	s7,s2
      state = 0;
 b68:	00000993          	li	s3,0
 b6c:	e69ff06f          	j	9d4 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b70:	008b8913          	addi	s2,s7,8
 b74:	00000693          	li	a3,0
 b78:	00a00613          	li	a2,10
 b7c:	000ba583          	lw	a1,0(s7)
 b80:	000b0513          	mv	a0,s6
 b84:	cedff0ef          	jal	870 <printint>
        i += 1;
 b88:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 b8c:	00090b93          	mv	s7,s2
      state = 0;
 b90:	00000993          	li	s3,0
        i += 1;
 b94:	e41ff06f          	j	9d4 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b98:	008b8913          	addi	s2,s7,8
 b9c:	00000693          	li	a3,0
 ba0:	00a00613          	li	a2,10
 ba4:	000ba583          	lw	a1,0(s7)
 ba8:	000b0513          	mv	a0,s6
 bac:	cc5ff0ef          	jal	870 <printint>
        i += 2;
 bb0:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 bb4:	00090b93          	mv	s7,s2
      state = 0;
 bb8:	00000993          	li	s3,0
        i += 2;
 bbc:	e19ff06f          	j	9d4 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
 bc0:	008b8913          	addi	s2,s7,8
 bc4:	00000693          	li	a3,0
 bc8:	01000613          	li	a2,16
 bcc:	000ba583          	lw	a1,0(s7)
 bd0:	000b0513          	mv	a0,s6
 bd4:	c9dff0ef          	jal	870 <printint>
 bd8:	00090b93          	mv	s7,s2
      state = 0;
 bdc:	00000993          	li	s3,0
 be0:	df5ff06f          	j	9d4 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
 be4:	008b8913          	addi	s2,s7,8
 be8:	00000693          	li	a3,0
 bec:	01000613          	li	a2,16
 bf0:	000ba583          	lw	a1,0(s7)
 bf4:	000b0513          	mv	a0,s6
 bf8:	c79ff0ef          	jal	870 <printint>
        i += 1;
 bfc:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 c00:	00090b93          	mv	s7,s2
      state = 0;
 c04:	00000993          	li	s3,0
        i += 1;
 c08:	dcdff06f          	j	9d4 <vprintf+0x78>
 c0c:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 c10:	008b8d13          	addi	s10,s7,8
 c14:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 c18:	03000593          	li	a1,48
 c1c:	000b0513          	mv	a0,s6
 c20:	c21ff0ef          	jal	840 <putc>
  putc(fd, 'x');
 c24:	07800593          	li	a1,120
 c28:	000b0513          	mv	a0,s6
 c2c:	c15ff0ef          	jal	840 <putc>
 c30:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 c34:	00000b97          	auipc	s7,0x0
 c38:	3bcb8b93          	addi	s7,s7,956 # ff0 <digits>
 c3c:	03c9d793          	srli	a5,s3,0x3c
 c40:	00fb87b3          	add	a5,s7,a5
 c44:	0007c583          	lbu	a1,0(a5)
 c48:	000b0513          	mv	a0,s6
 c4c:	bf5ff0ef          	jal	840 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 c50:	00499993          	slli	s3,s3,0x4
 c54:	fff9091b          	addiw	s2,s2,-1
 c58:	fe0912e3          	bnez	s2,c3c <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
 c5c:	000d0b93          	mv	s7,s10
      state = 0;
 c60:	00000993          	li	s3,0
 c64:	00013d03          	ld	s10,0(sp)
 c68:	d6dff06f          	j	9d4 <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
 c6c:	008b8993          	addi	s3,s7,8
 c70:	000bb903          	ld	s2,0(s7)
 c74:	02090663          	beqz	s2,ca0 <vprintf+0x344>
        for(; *s; s++)
 c78:	00094583          	lbu	a1,0(s2)
 c7c:	02058a63          	beqz	a1,cb0 <vprintf+0x354>
          putc(fd, *s);
 c80:	000b0513          	mv	a0,s6
 c84:	bbdff0ef          	jal	840 <putc>
        for(; *s; s++)
 c88:	00190913          	addi	s2,s2,1
 c8c:	00094583          	lbu	a1,0(s2)
 c90:	fe0598e3          	bnez	a1,c80 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 c94:	00098b93          	mv	s7,s3
      state = 0;
 c98:	00000993          	li	s3,0
 c9c:	d39ff06f          	j	9d4 <vprintf+0x78>
          s = "(null)";
 ca0:	00000917          	auipc	s2,0x0
 ca4:	34890913          	addi	s2,s2,840 # fe8 <malloc+0x1b4>
        for(; *s; s++)
 ca8:	02800593          	li	a1,40
 cac:	fd5ff06f          	j	c80 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 cb0:	00098b93          	mv	s7,s3
      state = 0;
 cb4:	00000993          	li	s3,0
 cb8:	d1dff06f          	j	9d4 <vprintf+0x78>
 cbc:	04813483          	ld	s1,72(sp)
 cc0:	03813983          	ld	s3,56(sp)
 cc4:	03013a03          	ld	s4,48(sp)
 cc8:	02813a83          	ld	s5,40(sp)
 ccc:	02013b03          	ld	s6,32(sp)
 cd0:	01813b83          	ld	s7,24(sp)
 cd4:	01013c03          	ld	s8,16(sp)
 cd8:	00813c83          	ld	s9,8(sp)
    }
  }
}
 cdc:	05813083          	ld	ra,88(sp)
 ce0:	05013403          	ld	s0,80(sp)
 ce4:	04013903          	ld	s2,64(sp)
 ce8:	06010113          	addi	sp,sp,96
 cec:	00008067          	ret

0000000000000cf0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 cf0:	fb010113          	addi	sp,sp,-80
 cf4:	00113c23          	sd	ra,24(sp)
 cf8:	00813823          	sd	s0,16(sp)
 cfc:	02010413          	addi	s0,sp,32
 d00:	00c43023          	sd	a2,0(s0)
 d04:	00d43423          	sd	a3,8(s0)
 d08:	00e43823          	sd	a4,16(s0)
 d0c:	00f43c23          	sd	a5,24(s0)
 d10:	03043023          	sd	a6,32(s0)
 d14:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 d18:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 d1c:	00040613          	mv	a2,s0
 d20:	c3dff0ef          	jal	95c <vprintf>
}
 d24:	01813083          	ld	ra,24(sp)
 d28:	01013403          	ld	s0,16(sp)
 d2c:	05010113          	addi	sp,sp,80
 d30:	00008067          	ret

0000000000000d34 <printf>:

void
printf(const char *fmt, ...)
{
 d34:	fa010113          	addi	sp,sp,-96
 d38:	00113c23          	sd	ra,24(sp)
 d3c:	00813823          	sd	s0,16(sp)
 d40:	02010413          	addi	s0,sp,32
 d44:	00b43423          	sd	a1,8(s0)
 d48:	00c43823          	sd	a2,16(s0)
 d4c:	00d43c23          	sd	a3,24(s0)
 d50:	02e43023          	sd	a4,32(s0)
 d54:	02f43423          	sd	a5,40(s0)
 d58:	03043823          	sd	a6,48(s0)
 d5c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 d60:	00840613          	addi	a2,s0,8
 d64:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 d68:	00050593          	mv	a1,a0
 d6c:	00100513          	li	a0,1
 d70:	bedff0ef          	jal	95c <vprintf>
}
 d74:	01813083          	ld	ra,24(sp)
 d78:	01013403          	ld	s0,16(sp)
 d7c:	06010113          	addi	sp,sp,96
 d80:	00008067          	ret

0000000000000d84 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 d84:	ff010113          	addi	sp,sp,-16
 d88:	00813423          	sd	s0,8(sp)
 d8c:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 d90:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d94:	00001797          	auipc	a5,0x1
 d98:	26c7b783          	ld	a5,620(a5) # 2000 <freep>
 d9c:	0400006f          	j	ddc <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 da0:	00862703          	lw	a4,8(a2)
 da4:	00b7073b          	addw	a4,a4,a1
 da8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 dac:	0007b703          	ld	a4,0(a5)
 db0:	00073603          	ld	a2,0(a4)
 db4:	0500006f          	j	e04 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 db8:	ff852703          	lw	a4,-8(a0)
 dbc:	00c7073b          	addw	a4,a4,a2
 dc0:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 dc4:	ff053683          	ld	a3,-16(a0)
 dc8:	0540006f          	j	e1c <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 dcc:	0007b703          	ld	a4,0(a5)
 dd0:	00e7e463          	bltu	a5,a4,dd8 <free+0x54>
 dd4:	00e6ec63          	bltu	a3,a4,dec <free+0x68>
{
 dd8:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ddc:	fed7f8e3          	bgeu	a5,a3,dcc <free+0x48>
 de0:	0007b703          	ld	a4,0(a5)
 de4:	00e6e463          	bltu	a3,a4,dec <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 de8:	fee7e8e3          	bltu	a5,a4,dd8 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 dec:	ff852583          	lw	a1,-8(a0)
 df0:	0007b603          	ld	a2,0(a5)
 df4:	02059813          	slli	a6,a1,0x20
 df8:	01c85713          	srli	a4,a6,0x1c
 dfc:	00e68733          	add	a4,a3,a4
 e00:	fae600e3          	beq	a2,a4,da0 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 e04:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 e08:	0087a603          	lw	a2,8(a5)
 e0c:	02061593          	slli	a1,a2,0x20
 e10:	01c5d713          	srli	a4,a1,0x1c
 e14:	00e78733          	add	a4,a5,a4
 e18:	fae680e3          	beq	a3,a4,db8 <free+0x34>
    p->s.ptr = bp->s.ptr;
 e1c:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 e20:	00001717          	auipc	a4,0x1
 e24:	1ef73023          	sd	a5,480(a4) # 2000 <freep>
}
 e28:	00813403          	ld	s0,8(sp)
 e2c:	01010113          	addi	sp,sp,16
 e30:	00008067          	ret

0000000000000e34 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 e34:	fc010113          	addi	sp,sp,-64
 e38:	02113c23          	sd	ra,56(sp)
 e3c:	02813823          	sd	s0,48(sp)
 e40:	02913423          	sd	s1,40(sp)
 e44:	01313c23          	sd	s3,24(sp)
 e48:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e4c:	02051493          	slli	s1,a0,0x20
 e50:	0204d493          	srli	s1,s1,0x20
 e54:	00f48493          	addi	s1,s1,15
 e58:	0044d493          	srli	s1,s1,0x4
 e5c:	0014899b          	addiw	s3,s1,1
 e60:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
 e64:	00001517          	auipc	a0,0x1
 e68:	19c53503          	ld	a0,412(a0) # 2000 <freep>
 e6c:	04050663          	beqz	a0,eb8 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e70:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 e74:	0087a703          	lw	a4,8(a5)
 e78:	0c977c63          	bgeu	a4,s1,f50 <malloc+0x11c>
 e7c:	03213023          	sd	s2,32(sp)
 e80:	01413823          	sd	s4,16(sp)
 e84:	01513423          	sd	s5,8(sp)
 e88:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
 e8c:	00098a13          	mv	s4,s3
 e90:	0009871b          	sext.w	a4,s3
 e94:	000016b7          	lui	a3,0x1
 e98:	00d77463          	bgeu	a4,a3,ea0 <malloc+0x6c>
 e9c:	00001a37          	lui	s4,0x1
 ea0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ea4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ea8:	00001917          	auipc	s2,0x1
 eac:	15890913          	addi	s2,s2,344 # 2000 <freep>
  if(p == (char*)-1)
 eb0:	fff00a93          	li	s5,-1
 eb4:	05c0006f          	j	f10 <malloc+0xdc>
 eb8:	03213023          	sd	s2,32(sp)
 ebc:	01413823          	sd	s4,16(sp)
 ec0:	01513423          	sd	s5,8(sp)
 ec4:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 ec8:	00001797          	auipc	a5,0x1
 ecc:	54878793          	addi	a5,a5,1352 # 2410 <base>
 ed0:	00001717          	auipc	a4,0x1
 ed4:	12f73823          	sd	a5,304(a4) # 2000 <freep>
 ed8:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 edc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ee0:	fadff06f          	j	e8c <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
 ee4:	0007b703          	ld	a4,0(a5)
 ee8:	00e53023          	sd	a4,0(a0)
 eec:	0800006f          	j	f6c <malloc+0x138>
  hp->s.size = nu;
 ef0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ef4:	01050513          	addi	a0,a0,16
 ef8:	e8dff0ef          	jal	d84 <free>
  return freep;
 efc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 f00:	08050863          	beqz	a0,f90 <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f04:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 f08:	0087a703          	lw	a4,8(a5)
 f0c:	02977a63          	bgeu	a4,s1,f40 <malloc+0x10c>
    if(p == freep)
 f10:	00093703          	ld	a4,0(s2)
 f14:	00078513          	mv	a0,a5
 f18:	fef716e3          	bne	a4,a5,f04 <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
 f1c:	000a0513          	mv	a0,s4
 f20:	8fdff0ef          	jal	81c <sbrk>
  if(p == (char*)-1)
 f24:	fd5516e3          	bne	a0,s5,ef0 <malloc+0xbc>
        return 0;
 f28:	00000513          	li	a0,0
 f2c:	02013903          	ld	s2,32(sp)
 f30:	01013a03          	ld	s4,16(sp)
 f34:	00813a83          	ld	s5,8(sp)
 f38:	00013b03          	ld	s6,0(sp)
 f3c:	03c0006f          	j	f78 <malloc+0x144>
 f40:	02013903          	ld	s2,32(sp)
 f44:	01013a03          	ld	s4,16(sp)
 f48:	00813a83          	ld	s5,8(sp)
 f4c:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
 f50:	f8e48ae3          	beq	s1,a4,ee4 <malloc+0xb0>
        p->s.size -= nunits;
 f54:	4137073b          	subw	a4,a4,s3
 f58:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 f5c:	02071693          	slli	a3,a4,0x20
 f60:	01c6d713          	srli	a4,a3,0x1c
 f64:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 f68:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 f6c:	00001717          	auipc	a4,0x1
 f70:	08a73a23          	sd	a0,148(a4) # 2000 <freep>
      return (void*)(p + 1);
 f74:	01078513          	addi	a0,a5,16
  }
}
 f78:	03813083          	ld	ra,56(sp)
 f7c:	03013403          	ld	s0,48(sp)
 f80:	02813483          	ld	s1,40(sp)
 f84:	01813983          	ld	s3,24(sp)
 f88:	04010113          	addi	sp,sp,64
 f8c:	00008067          	ret
 f90:	02013903          	ld	s2,32(sp)
 f94:	01013a03          	ld	s4,16(sp)
 f98:	00813a83          	ld	s5,8(sp)
 f9c:	00013b03          	ld	s6,0(sp)
 fa0:	fd9ff06f          	j	f78 <malloc+0x144>
