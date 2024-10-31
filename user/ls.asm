
user/_ls:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	fd010113          	addi	sp,sp,-48
   4:	02113423          	sd	ra,40(sp)
   8:	02813023          	sd	s0,32(sp)
   c:	00913c23          	sd	s1,24(sp)
  10:	03010413          	addi	s0,sp,48
  14:	00050493          	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  18:	384000ef          	jal	39c <strlen>
  1c:	02051793          	slli	a5,a0,0x20
  20:	0207d793          	srli	a5,a5,0x20
  24:	00f487b3          	add	a5,s1,a5
  28:	02f00693          	li	a3,47
  2c:	0097ea63          	bltu	a5,s1,40 <fmtname+0x40>
  30:	0007c703          	lbu	a4,0(a5)
  34:	00d70663          	beq	a4,a3,40 <fmtname+0x40>
  38:	fff78793          	addi	a5,a5,-1
  3c:	fe97fae3          	bgeu	a5,s1,30 <fmtname+0x30>
    ;
  p++;
  40:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  44:	00048513          	mv	a0,s1
  48:	354000ef          	jal	39c <strlen>
  4c:	0005051b          	sext.w	a0,a0
  50:	00d00793          	li	a5,13
  54:	00a7fe63          	bgeu	a5,a0,70 <fmtname+0x70>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  58:	00048513          	mv	a0,s1
  5c:	02813083          	ld	ra,40(sp)
  60:	02013403          	ld	s0,32(sp)
  64:	01813483          	ld	s1,24(sp)
  68:	03010113          	addi	sp,sp,48
  6c:	00008067          	ret
  70:	01213823          	sd	s2,16(sp)
  74:	01313423          	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  78:	00048513          	mv	a0,s1
  7c:	320000ef          	jal	39c <strlen>
  80:	00001997          	auipc	s3,0x1
  84:	f9098993          	addi	s3,s3,-112 # 1010 <buf.0>
  88:	0005061b          	sext.w	a2,a0
  8c:	00048593          	mv	a1,s1
  90:	00098513          	mv	a0,s3
  94:	548000ef          	jal	5dc <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  98:	00048513          	mv	a0,s1
  9c:	300000ef          	jal	39c <strlen>
  a0:	0005091b          	sext.w	s2,a0
  a4:	00048513          	mv	a0,s1
  a8:	2f4000ef          	jal	39c <strlen>
  ac:	02091913          	slli	s2,s2,0x20
  b0:	02095913          	srli	s2,s2,0x20
  b4:	00e00613          	li	a2,14
  b8:	40a6063b          	subw	a2,a2,a0
  bc:	02000593          	li	a1,32
  c0:	01298533          	add	a0,s3,s2
  c4:	320000ef          	jal	3e4 <memset>
  return buf;
  c8:	00098493          	mv	s1,s3
  cc:	01013903          	ld	s2,16(sp)
  d0:	00813983          	ld	s3,8(sp)
  d4:	f85ff06f          	j	58 <fmtname+0x58>

00000000000000d8 <ls>:

void
ls(char *path)
{
  d8:	d9010113          	addi	sp,sp,-624
  dc:	26113423          	sd	ra,616(sp)
  e0:	26813023          	sd	s0,608(sp)
  e4:	25213823          	sd	s2,592(sp)
  e8:	27010413          	addi	s0,sp,624
  ec:	00050913          	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  f0:	00000593          	li	a1,0
  f4:	650000ef          	jal	744 <open>
  f8:	06054c63          	bltz	a0,170 <ls+0x98>
  fc:	24913c23          	sd	s1,600(sp)
 100:	00050493          	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
 104:	d9840593          	addi	a1,s0,-616
 108:	660000ef          	jal	768 <fstat>
 10c:	06054e63          	bltz	a0,188 <ls+0xb0>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
 110:	da041783          	lh	a5,-608(s0)
 114:	00100713          	li	a4,1
 118:	08e78a63          	beq	a5,a4,1ac <ls+0xd4>
 11c:	ffe7879b          	addiw	a5,a5,-2
 120:	03079793          	slli	a5,a5,0x30
 124:	0307d793          	srli	a5,a5,0x30
 128:	02f76463          	bltu	a4,a5,150 <ls+0x78>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
 12c:	00090513          	mv	a0,s2
 130:	ed1ff0ef          	jal	0 <fmtname>
 134:	00050593          	mv	a1,a0
 138:	da842703          	lw	a4,-600(s0)
 13c:	d9c42683          	lw	a3,-612(s0)
 140:	da041603          	lh	a2,-608(s0)
 144:	00001517          	auipc	a0,0x1
 148:	e2c50513          	addi	a0,a0,-468 # f70 <malloc+0x1a8>
 14c:	37d000ef          	jal	cc8 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
 150:	00048513          	mv	a0,s1
 154:	5cc000ef          	jal	720 <close>
 158:	25813483          	ld	s1,600(sp)
}
 15c:	26813083          	ld	ra,616(sp)
 160:	26013403          	ld	s0,608(sp)
 164:	25013903          	ld	s2,592(sp)
 168:	27010113          	addi	sp,sp,624
 16c:	00008067          	ret
    fprintf(2, "ls: cannot open %s\n", path);
 170:	00090613          	mv	a2,s2
 174:	00001597          	auipc	a1,0x1
 178:	dcc58593          	addi	a1,a1,-564 # f40 <malloc+0x178>
 17c:	00200513          	li	a0,2
 180:	305000ef          	jal	c84 <fprintf>
    return;
 184:	fd9ff06f          	j	15c <ls+0x84>
    fprintf(2, "ls: cannot stat %s\n", path);
 188:	00090613          	mv	a2,s2
 18c:	00001597          	auipc	a1,0x1
 190:	dcc58593          	addi	a1,a1,-564 # f58 <malloc+0x190>
 194:	00200513          	li	a0,2
 198:	2ed000ef          	jal	c84 <fprintf>
    close(fd);
 19c:	00048513          	mv	a0,s1
 1a0:	580000ef          	jal	720 <close>
    return;
 1a4:	25813483          	ld	s1,600(sp)
 1a8:	fb5ff06f          	j	15c <ls+0x84>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1ac:	00090513          	mv	a0,s2
 1b0:	1ec000ef          	jal	39c <strlen>
 1b4:	0105051b          	addiw	a0,a0,16
 1b8:	20000793          	li	a5,512
 1bc:	00a7fa63          	bgeu	a5,a0,1d0 <ls+0xf8>
      printf("ls: path too long\n");
 1c0:	00001517          	auipc	a0,0x1
 1c4:	dc050513          	addi	a0,a0,-576 # f80 <malloc+0x1b8>
 1c8:	301000ef          	jal	cc8 <printf>
      break;
 1cc:	f85ff06f          	j	150 <ls+0x78>
 1d0:	25313423          	sd	s3,584(sp)
 1d4:	25413023          	sd	s4,576(sp)
 1d8:	23513c23          	sd	s5,568(sp)
    strcpy(buf, path);
 1dc:	00090593          	mv	a1,s2
 1e0:	dc040513          	addi	a0,s0,-576
 1e4:	148000ef          	jal	32c <strcpy>
    p = buf+strlen(buf);
 1e8:	dc040513          	addi	a0,s0,-576
 1ec:	1b0000ef          	jal	39c <strlen>
 1f0:	02051513          	slli	a0,a0,0x20
 1f4:	02055513          	srli	a0,a0,0x20
 1f8:	dc040793          	addi	a5,s0,-576
 1fc:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 200:	00190993          	addi	s3,s2,1
 204:	02f00793          	li	a5,47
 208:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 20c:	00001a17          	auipc	s4,0x1
 210:	d64a0a13          	addi	s4,s4,-668 # f70 <malloc+0x1a8>
        printf("ls: cannot stat %s\n", buf);
 214:	00001a97          	auipc	s5,0x1
 218:	d44a8a93          	addi	s5,s5,-700 # f58 <malloc+0x190>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 21c:	0100006f          	j	22c <ls+0x154>
        printf("ls: cannot stat %s\n", buf);
 220:	dc040593          	addi	a1,s0,-576
 224:	000a8513          	mv	a0,s5
 228:	2a1000ef          	jal	cc8 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 22c:	01000613          	li	a2,16
 230:	db040593          	addi	a1,s0,-592
 234:	00048513          	mv	a0,s1
 238:	4d0000ef          	jal	708 <read>
 23c:	01000793          	li	a5,16
 240:	04f51a63          	bne	a0,a5,294 <ls+0x1bc>
      if(de.inum == 0)
 244:	db045783          	lhu	a5,-592(s0)
 248:	fe0782e3          	beqz	a5,22c <ls+0x154>
      memmove(p, de.name, DIRSIZ);
 24c:	00e00613          	li	a2,14
 250:	db240593          	addi	a1,s0,-590
 254:	00098513          	mv	a0,s3
 258:	384000ef          	jal	5dc <memmove>
      p[DIRSIZ] = 0;
 25c:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 260:	d9840593          	addi	a1,s0,-616
 264:	dc040513          	addi	a0,s0,-576
 268:	2ac000ef          	jal	514 <stat>
 26c:	fa054ae3          	bltz	a0,220 <ls+0x148>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 270:	dc040513          	addi	a0,s0,-576
 274:	d8dff0ef          	jal	0 <fmtname>
 278:	00050593          	mv	a1,a0
 27c:	da842703          	lw	a4,-600(s0)
 280:	d9c42683          	lw	a3,-612(s0)
 284:	da041603          	lh	a2,-608(s0)
 288:	000a0513          	mv	a0,s4
 28c:	23d000ef          	jal	cc8 <printf>
 290:	f9dff06f          	j	22c <ls+0x154>
 294:	24813983          	ld	s3,584(sp)
 298:	24013a03          	ld	s4,576(sp)
 29c:	23813a83          	ld	s5,568(sp)
 2a0:	eb1ff06f          	j	150 <ls+0x78>

00000000000002a4 <main>:

int
main(int argc, char *argv[])
{
 2a4:	fe010113          	addi	sp,sp,-32
 2a8:	00113c23          	sd	ra,24(sp)
 2ac:	00813823          	sd	s0,16(sp)
 2b0:	02010413          	addi	s0,sp,32
  int i;

  if(argc < 2){
 2b4:	00100793          	li	a5,1
 2b8:	02a7de63          	bge	a5,a0,2f4 <main+0x50>
 2bc:	00913423          	sd	s1,8(sp)
 2c0:	01213023          	sd	s2,0(sp)
 2c4:	00858493          	addi	s1,a1,8
 2c8:	ffe5091b          	addiw	s2,a0,-2
 2cc:	02091793          	slli	a5,s2,0x20
 2d0:	01d7d913          	srli	s2,a5,0x1d
 2d4:	01058593          	addi	a1,a1,16
 2d8:	00b90933          	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2dc:	0004b503          	ld	a0,0(s1)
 2e0:	df9ff0ef          	jal	d8 <ls>
  for(i=1; i<argc; i++)
 2e4:	00848493          	addi	s1,s1,8
 2e8:	ff249ae3          	bne	s1,s2,2dc <main+0x38>
  exit(0);
 2ec:	00000513          	li	a0,0
 2f0:	3f4000ef          	jal	6e4 <exit>
 2f4:	00913423          	sd	s1,8(sp)
 2f8:	01213023          	sd	s2,0(sp)
    ls(".");
 2fc:	00001517          	auipc	a0,0x1
 300:	c9c50513          	addi	a0,a0,-868 # f98 <malloc+0x1d0>
 304:	dd5ff0ef          	jal	d8 <ls>
    exit(0);
 308:	00000513          	li	a0,0
 30c:	3d8000ef          	jal	6e4 <exit>

0000000000000310 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 310:	ff010113          	addi	sp,sp,-16
 314:	00113423          	sd	ra,8(sp)
 318:	00813023          	sd	s0,0(sp)
 31c:	01010413          	addi	s0,sp,16
  extern int main();
  main();
 320:	f85ff0ef          	jal	2a4 <main>
  exit(0);
 324:	00000513          	li	a0,0
 328:	3bc000ef          	jal	6e4 <exit>

000000000000032c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 32c:	ff010113          	addi	sp,sp,-16
 330:	00813423          	sd	s0,8(sp)
 334:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 338:	00050793          	mv	a5,a0
 33c:	00158593          	addi	a1,a1,1
 340:	00178793          	addi	a5,a5,1
 344:	fff5c703          	lbu	a4,-1(a1)
 348:	fee78fa3          	sb	a4,-1(a5)
 34c:	fe0718e3          	bnez	a4,33c <strcpy+0x10>
    ;
  return os;
}
 350:	00813403          	ld	s0,8(sp)
 354:	01010113          	addi	sp,sp,16
 358:	00008067          	ret

000000000000035c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 35c:	ff010113          	addi	sp,sp,-16
 360:	00813423          	sd	s0,8(sp)
 364:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
 368:	00054783          	lbu	a5,0(a0)
 36c:	00078e63          	beqz	a5,388 <strcmp+0x2c>
 370:	0005c703          	lbu	a4,0(a1)
 374:	00f71a63          	bne	a4,a5,388 <strcmp+0x2c>
    p++, q++;
 378:	00150513          	addi	a0,a0,1
 37c:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
 380:	00054783          	lbu	a5,0(a0)
 384:	fe0796e3          	bnez	a5,370 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 388:	0005c503          	lbu	a0,0(a1)
}
 38c:	40a7853b          	subw	a0,a5,a0
 390:	00813403          	ld	s0,8(sp)
 394:	01010113          	addi	sp,sp,16
 398:	00008067          	ret

000000000000039c <strlen>:

uint
strlen(const char *s)
{
 39c:	ff010113          	addi	sp,sp,-16
 3a0:	00813423          	sd	s0,8(sp)
 3a4:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 3a8:	00054783          	lbu	a5,0(a0)
 3ac:	02078863          	beqz	a5,3dc <strlen+0x40>
 3b0:	00150513          	addi	a0,a0,1
 3b4:	00050793          	mv	a5,a0
 3b8:	00078693          	mv	a3,a5
 3bc:	00178793          	addi	a5,a5,1
 3c0:	fff7c703          	lbu	a4,-1(a5)
 3c4:	fe071ae3          	bnez	a4,3b8 <strlen+0x1c>
 3c8:	40a6853b          	subw	a0,a3,a0
 3cc:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
 3d0:	00813403          	ld	s0,8(sp)
 3d4:	01010113          	addi	sp,sp,16
 3d8:	00008067          	ret
  for(n = 0; s[n]; n++)
 3dc:	00000513          	li	a0,0
 3e0:	ff1ff06f          	j	3d0 <strlen+0x34>

00000000000003e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3e4:	ff010113          	addi	sp,sp,-16
 3e8:	00813423          	sd	s0,8(sp)
 3ec:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3f0:	02060063          	beqz	a2,410 <memset+0x2c>
 3f4:	00050793          	mv	a5,a0
 3f8:	02061613          	slli	a2,a2,0x20
 3fc:	02065613          	srli	a2,a2,0x20
 400:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 404:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 408:	00178793          	addi	a5,a5,1
 40c:	fee79ce3          	bne	a5,a4,404 <memset+0x20>
  }
  return dst;
}
 410:	00813403          	ld	s0,8(sp)
 414:	01010113          	addi	sp,sp,16
 418:	00008067          	ret

000000000000041c <strchr>:

char*
strchr(const char *s, char c)
{
 41c:	ff010113          	addi	sp,sp,-16
 420:	00813423          	sd	s0,8(sp)
 424:	01010413          	addi	s0,sp,16
  for(; *s; s++)
 428:	00054783          	lbu	a5,0(a0)
 42c:	02078263          	beqz	a5,450 <strchr+0x34>
    if(*s == c)
 430:	00f58a63          	beq	a1,a5,444 <strchr+0x28>
  for(; *s; s++)
 434:	00150513          	addi	a0,a0,1
 438:	00054783          	lbu	a5,0(a0)
 43c:	fe079ae3          	bnez	a5,430 <strchr+0x14>
      return (char*)s;
  return 0;
 440:	00000513          	li	a0,0
}
 444:	00813403          	ld	s0,8(sp)
 448:	01010113          	addi	sp,sp,16
 44c:	00008067          	ret
  return 0;
 450:	00000513          	li	a0,0
 454:	ff1ff06f          	j	444 <strchr+0x28>

0000000000000458 <gets>:

char*
gets(char *buf, int max)
{
 458:	fa010113          	addi	sp,sp,-96
 45c:	04113c23          	sd	ra,88(sp)
 460:	04813823          	sd	s0,80(sp)
 464:	04913423          	sd	s1,72(sp)
 468:	05213023          	sd	s2,64(sp)
 46c:	03313c23          	sd	s3,56(sp)
 470:	03413823          	sd	s4,48(sp)
 474:	03513423          	sd	s5,40(sp)
 478:	03613023          	sd	s6,32(sp)
 47c:	01713c23          	sd	s7,24(sp)
 480:	06010413          	addi	s0,sp,96
 484:	00050b93          	mv	s7,a0
 488:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 48c:	00050913          	mv	s2,a0
 490:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 494:	00a00a93          	li	s5,10
 498:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 49c:	00048993          	mv	s3,s1
 4a0:	0014849b          	addiw	s1,s1,1
 4a4:	0344dc63          	bge	s1,s4,4dc <gets+0x84>
    cc = read(0, &c, 1);
 4a8:	00100613          	li	a2,1
 4ac:	faf40593          	addi	a1,s0,-81
 4b0:	00000513          	li	a0,0
 4b4:	254000ef          	jal	708 <read>
    if(cc < 1)
 4b8:	02a05263          	blez	a0,4dc <gets+0x84>
    buf[i++] = c;
 4bc:	faf44783          	lbu	a5,-81(s0)
 4c0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4c4:	01578a63          	beq	a5,s5,4d8 <gets+0x80>
 4c8:	00190913          	addi	s2,s2,1
 4cc:	fd6798e3          	bne	a5,s6,49c <gets+0x44>
    buf[i++] = c;
 4d0:	00048993          	mv	s3,s1
 4d4:	0080006f          	j	4dc <gets+0x84>
 4d8:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4dc:	013b89b3          	add	s3,s7,s3
 4e0:	00098023          	sb	zero,0(s3)
  return buf;
}
 4e4:	000b8513          	mv	a0,s7
 4e8:	05813083          	ld	ra,88(sp)
 4ec:	05013403          	ld	s0,80(sp)
 4f0:	04813483          	ld	s1,72(sp)
 4f4:	04013903          	ld	s2,64(sp)
 4f8:	03813983          	ld	s3,56(sp)
 4fc:	03013a03          	ld	s4,48(sp)
 500:	02813a83          	ld	s5,40(sp)
 504:	02013b03          	ld	s6,32(sp)
 508:	01813b83          	ld	s7,24(sp)
 50c:	06010113          	addi	sp,sp,96
 510:	00008067          	ret

0000000000000514 <stat>:

int
stat(const char *n, struct stat *st)
{
 514:	fe010113          	addi	sp,sp,-32
 518:	00113c23          	sd	ra,24(sp)
 51c:	00813823          	sd	s0,16(sp)
 520:	01213023          	sd	s2,0(sp)
 524:	02010413          	addi	s0,sp,32
 528:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 52c:	00000593          	li	a1,0
 530:	214000ef          	jal	744 <open>
  if(fd < 0)
 534:	02054e63          	bltz	a0,570 <stat+0x5c>
 538:	00913423          	sd	s1,8(sp)
 53c:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 540:	00090593          	mv	a1,s2
 544:	224000ef          	jal	768 <fstat>
 548:	00050913          	mv	s2,a0
  close(fd);
 54c:	00048513          	mv	a0,s1
 550:	1d0000ef          	jal	720 <close>
  return r;
 554:	00813483          	ld	s1,8(sp)
}
 558:	00090513          	mv	a0,s2
 55c:	01813083          	ld	ra,24(sp)
 560:	01013403          	ld	s0,16(sp)
 564:	00013903          	ld	s2,0(sp)
 568:	02010113          	addi	sp,sp,32
 56c:	00008067          	ret
    return -1;
 570:	fff00913          	li	s2,-1
 574:	fe5ff06f          	j	558 <stat+0x44>

0000000000000578 <atoi>:

int
atoi(const char *s)
{
 578:	ff010113          	addi	sp,sp,-16
 57c:	00813423          	sd	s0,8(sp)
 580:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 584:	00054683          	lbu	a3,0(a0)
 588:	fd06879b          	addiw	a5,a3,-48
 58c:	0ff7f793          	zext.b	a5,a5
 590:	00900613          	li	a2,9
 594:	04f66063          	bltu	a2,a5,5d4 <atoi+0x5c>
 598:	00050713          	mv	a4,a0
  n = 0;
 59c:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 5a0:	00170713          	addi	a4,a4,1
 5a4:	0025179b          	slliw	a5,a0,0x2
 5a8:	00a787bb          	addw	a5,a5,a0
 5ac:	0017979b          	slliw	a5,a5,0x1
 5b0:	00d787bb          	addw	a5,a5,a3
 5b4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 5b8:	00074683          	lbu	a3,0(a4)
 5bc:	fd06879b          	addiw	a5,a3,-48
 5c0:	0ff7f793          	zext.b	a5,a5
 5c4:	fcf67ee3          	bgeu	a2,a5,5a0 <atoi+0x28>
  return n;
}
 5c8:	00813403          	ld	s0,8(sp)
 5cc:	01010113          	addi	sp,sp,16
 5d0:	00008067          	ret
  n = 0;
 5d4:	00000513          	li	a0,0
 5d8:	ff1ff06f          	j	5c8 <atoi+0x50>

00000000000005dc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5dc:	ff010113          	addi	sp,sp,-16
 5e0:	00813423          	sd	s0,8(sp)
 5e4:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 5e8:	02b57c63          	bgeu	a0,a1,620 <memmove+0x44>
    while(n-- > 0)
 5ec:	02c05463          	blez	a2,614 <memmove+0x38>
 5f0:	02061613          	slli	a2,a2,0x20
 5f4:	02065613          	srli	a2,a2,0x20
 5f8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5fc:	00050713          	mv	a4,a0
      *dst++ = *src++;
 600:	00158593          	addi	a1,a1,1
 604:	00170713          	addi	a4,a4,1
 608:	fff5c683          	lbu	a3,-1(a1)
 60c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 610:	fef718e3          	bne	a4,a5,600 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 614:	00813403          	ld	s0,8(sp)
 618:	01010113          	addi	sp,sp,16
 61c:	00008067          	ret
    dst += n;
 620:	00c50733          	add	a4,a0,a2
    src += n;
 624:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 628:	fec056e3          	blez	a2,614 <memmove+0x38>
 62c:	fff6079b          	addiw	a5,a2,-1
 630:	02079793          	slli	a5,a5,0x20
 634:	0207d793          	srli	a5,a5,0x20
 638:	fff7c793          	not	a5,a5
 63c:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 640:	fff58593          	addi	a1,a1,-1
 644:	fff70713          	addi	a4,a4,-1
 648:	0005c683          	lbu	a3,0(a1)
 64c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 650:	fee798e3          	bne	a5,a4,640 <memmove+0x64>
 654:	fc1ff06f          	j	614 <memmove+0x38>

0000000000000658 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 658:	ff010113          	addi	sp,sp,-16
 65c:	00813423          	sd	s0,8(sp)
 660:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 664:	04060463          	beqz	a2,6ac <memcmp+0x54>
 668:	fff6069b          	addiw	a3,a2,-1
 66c:	02069693          	slli	a3,a3,0x20
 670:	0206d693          	srli	a3,a3,0x20
 674:	00168693          	addi	a3,a3,1
 678:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 67c:	00054783          	lbu	a5,0(a0)
 680:	0005c703          	lbu	a4,0(a1)
 684:	00e79c63          	bne	a5,a4,69c <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 688:	00150513          	addi	a0,a0,1
    p2++;
 68c:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
 690:	fed516e3          	bne	a0,a3,67c <memcmp+0x24>
  }
  return 0;
 694:	00000513          	li	a0,0
 698:	0080006f          	j	6a0 <memcmp+0x48>
      return *p1 - *p2;
 69c:	40e7853b          	subw	a0,a5,a4
}
 6a0:	00813403          	ld	s0,8(sp)
 6a4:	01010113          	addi	sp,sp,16
 6a8:	00008067          	ret
  return 0;
 6ac:	00000513          	li	a0,0
 6b0:	ff1ff06f          	j	6a0 <memcmp+0x48>

00000000000006b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6b4:	ff010113          	addi	sp,sp,-16
 6b8:	00113423          	sd	ra,8(sp)
 6bc:	00813023          	sd	s0,0(sp)
 6c0:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
 6c4:	f19ff0ef          	jal	5dc <memmove>
}
 6c8:	00813083          	ld	ra,8(sp)
 6cc:	00013403          	ld	s0,0(sp)
 6d0:	01010113          	addi	sp,sp,16
 6d4:	00008067          	ret

00000000000006d8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6d8:	00100893          	li	a7,1
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	00008067          	ret

00000000000006e4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6e4:	00200893          	li	a7,2
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	00008067          	ret

00000000000006f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6f0:	00300893          	li	a7,3
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	00008067          	ret

00000000000006fc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6fc:	00400893          	li	a7,4
 ecall
 700:	00000073          	ecall
 ret
 704:	00008067          	ret

0000000000000708 <read>:
.global read
read:
 li a7, SYS_read
 708:	00500893          	li	a7,5
 ecall
 70c:	00000073          	ecall
 ret
 710:	00008067          	ret

0000000000000714 <write>:
.global write
write:
 li a7, SYS_write
 714:	01000893          	li	a7,16
 ecall
 718:	00000073          	ecall
 ret
 71c:	00008067          	ret

0000000000000720 <close>:
.global close
close:
 li a7, SYS_close
 720:	01500893          	li	a7,21
 ecall
 724:	00000073          	ecall
 ret
 728:	00008067          	ret

000000000000072c <kill>:
.global kill
kill:
 li a7, SYS_kill
 72c:	00600893          	li	a7,6
 ecall
 730:	00000073          	ecall
 ret
 734:	00008067          	ret

0000000000000738 <exec>:
.global exec
exec:
 li a7, SYS_exec
 738:	00700893          	li	a7,7
 ecall
 73c:	00000073          	ecall
 ret
 740:	00008067          	ret

0000000000000744 <open>:
.global open
open:
 li a7, SYS_open
 744:	00f00893          	li	a7,15
 ecall
 748:	00000073          	ecall
 ret
 74c:	00008067          	ret

0000000000000750 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 750:	01100893          	li	a7,17
 ecall
 754:	00000073          	ecall
 ret
 758:	00008067          	ret

000000000000075c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 75c:	01200893          	li	a7,18
 ecall
 760:	00000073          	ecall
 ret
 764:	00008067          	ret

0000000000000768 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 768:	00800893          	li	a7,8
 ecall
 76c:	00000073          	ecall
 ret
 770:	00008067          	ret

0000000000000774 <link>:
.global link
link:
 li a7, SYS_link
 774:	01300893          	li	a7,19
 ecall
 778:	00000073          	ecall
 ret
 77c:	00008067          	ret

0000000000000780 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 780:	01400893          	li	a7,20
 ecall
 784:	00000073          	ecall
 ret
 788:	00008067          	ret

000000000000078c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 78c:	00900893          	li	a7,9
 ecall
 790:	00000073          	ecall
 ret
 794:	00008067          	ret

0000000000000798 <dup>:
.global dup
dup:
 li a7, SYS_dup
 798:	00a00893          	li	a7,10
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	00008067          	ret

00000000000007a4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7a4:	00b00893          	li	a7,11
 ecall
 7a8:	00000073          	ecall
 ret
 7ac:	00008067          	ret

00000000000007b0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 7b0:	00c00893          	li	a7,12
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	00008067          	ret

00000000000007bc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 7bc:	00d00893          	li	a7,13
 ecall
 7c0:	00000073          	ecall
 ret
 7c4:	00008067          	ret

00000000000007c8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7c8:	00e00893          	li	a7,14
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	00008067          	ret

00000000000007d4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7d4:	fe010113          	addi	sp,sp,-32
 7d8:	00113c23          	sd	ra,24(sp)
 7dc:	00813823          	sd	s0,16(sp)
 7e0:	02010413          	addi	s0,sp,32
 7e4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7e8:	00100613          	li	a2,1
 7ec:	fef40593          	addi	a1,s0,-17
 7f0:	f25ff0ef          	jal	714 <write>
}
 7f4:	01813083          	ld	ra,24(sp)
 7f8:	01013403          	ld	s0,16(sp)
 7fc:	02010113          	addi	sp,sp,32
 800:	00008067          	ret

0000000000000804 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 804:	fc010113          	addi	sp,sp,-64
 808:	02113c23          	sd	ra,56(sp)
 80c:	02813823          	sd	s0,48(sp)
 810:	02913423          	sd	s1,40(sp)
 814:	04010413          	addi	s0,sp,64
 818:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 81c:	00068463          	beqz	a3,824 <printint+0x20>
 820:	0c05c263          	bltz	a1,8e4 <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 824:	0005859b          	sext.w	a1,a1
  neg = 0;
 828:	00000893          	li	a7,0
 82c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 830:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 834:	0006061b          	sext.w	a2,a2
 838:	00000517          	auipc	a0,0x0
 83c:	77050513          	addi	a0,a0,1904 # fa8 <digits>
 840:	00070813          	mv	a6,a4
 844:	0017071b          	addiw	a4,a4,1
 848:	02c5f7bb          	remuw	a5,a1,a2
 84c:	02079793          	slli	a5,a5,0x20
 850:	0207d793          	srli	a5,a5,0x20
 854:	00f507b3          	add	a5,a0,a5
 858:	0007c783          	lbu	a5,0(a5)
 85c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 860:	0005879b          	sext.w	a5,a1
 864:	02c5d5bb          	divuw	a1,a1,a2
 868:	00168693          	addi	a3,a3,1
 86c:	fcc7fae3          	bgeu	a5,a2,840 <printint+0x3c>
  if(neg)
 870:	00088c63          	beqz	a7,888 <printint+0x84>
    buf[i++] = '-';
 874:	fd070793          	addi	a5,a4,-48
 878:	00878733          	add	a4,a5,s0
 87c:	02d00793          	li	a5,45
 880:	fef70823          	sb	a5,-16(a4)
 884:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 888:	04e05463          	blez	a4,8d0 <printint+0xcc>
 88c:	03213023          	sd	s2,32(sp)
 890:	01313c23          	sd	s3,24(sp)
 894:	fc040793          	addi	a5,s0,-64
 898:	00e78933          	add	s2,a5,a4
 89c:	fff78993          	addi	s3,a5,-1
 8a0:	00e989b3          	add	s3,s3,a4
 8a4:	fff7071b          	addiw	a4,a4,-1
 8a8:	02071713          	slli	a4,a4,0x20
 8ac:	02075713          	srli	a4,a4,0x20
 8b0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 8b4:	fff94583          	lbu	a1,-1(s2)
 8b8:	00048513          	mv	a0,s1
 8bc:	f19ff0ef          	jal	7d4 <putc>
  while(--i >= 0)
 8c0:	fff90913          	addi	s2,s2,-1
 8c4:	ff3918e3          	bne	s2,s3,8b4 <printint+0xb0>
 8c8:	02013903          	ld	s2,32(sp)
 8cc:	01813983          	ld	s3,24(sp)
}
 8d0:	03813083          	ld	ra,56(sp)
 8d4:	03013403          	ld	s0,48(sp)
 8d8:	02813483          	ld	s1,40(sp)
 8dc:	04010113          	addi	sp,sp,64
 8e0:	00008067          	ret
    x = -xx;
 8e4:	40b005bb          	negw	a1,a1
    neg = 1;
 8e8:	00100893          	li	a7,1
    x = -xx;
 8ec:	f41ff06f          	j	82c <printint+0x28>

00000000000008f0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8f0:	fa010113          	addi	sp,sp,-96
 8f4:	04113c23          	sd	ra,88(sp)
 8f8:	04813823          	sd	s0,80(sp)
 8fc:	05213023          	sd	s2,64(sp)
 900:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 904:	0005c903          	lbu	s2,0(a1)
 908:	36090463          	beqz	s2,c70 <vprintf+0x380>
 90c:	04913423          	sd	s1,72(sp)
 910:	03313c23          	sd	s3,56(sp)
 914:	03413823          	sd	s4,48(sp)
 918:	03513423          	sd	s5,40(sp)
 91c:	03613023          	sd	s6,32(sp)
 920:	01713c23          	sd	s7,24(sp)
 924:	01813823          	sd	s8,16(sp)
 928:	01913423          	sd	s9,8(sp)
 92c:	00050b13          	mv	s6,a0
 930:	00058a13          	mv	s4,a1
 934:	00060b93          	mv	s7,a2
  state = 0;
 938:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
 93c:	00000493          	li	s1,0
 940:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 944:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 948:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 94c:	06c00c93          	li	s9,108
 950:	02c0006f          	j	97c <vprintf+0x8c>
        putc(fd, c0);
 954:	00090593          	mv	a1,s2
 958:	000b0513          	mv	a0,s6
 95c:	e79ff0ef          	jal	7d4 <putc>
 960:	0080006f          	j	968 <vprintf+0x78>
    } else if(state == '%'){
 964:	03598663          	beq	s3,s5,990 <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
 968:	0014849b          	addiw	s1,s1,1
 96c:	00048713          	mv	a4,s1
 970:	009a07b3          	add	a5,s4,s1
 974:	0007c903          	lbu	s2,0(a5)
 978:	2c090c63          	beqz	s2,c50 <vprintf+0x360>
    c0 = fmt[i] & 0xff;
 97c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 980:	fe0992e3          	bnez	s3,964 <vprintf+0x74>
      if(c0 == '%'){
 984:	fd5798e3          	bne	a5,s5,954 <vprintf+0x64>
        state = '%';
 988:	00078993          	mv	s3,a5
 98c:	fddff06f          	j	968 <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
 990:	00ea06b3          	add	a3,s4,a4
 994:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 998:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 99c:	00068663          	beqz	a3,9a8 <vprintf+0xb8>
 9a0:	00ea0733          	add	a4,s4,a4
 9a4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 9a8:	05878263          	beq	a5,s8,9ec <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
 9ac:	07978263          	beq	a5,s9,a10 <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 9b0:	07500713          	li	a4,117
 9b4:	12e78663          	beq	a5,a4,ae0 <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 9b8:	07800713          	li	a4,120
 9bc:	18e78c63          	beq	a5,a4,b54 <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 9c0:	07000713          	li	a4,112
 9c4:	1ce78e63          	beq	a5,a4,ba0 <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 9c8:	07300713          	li	a4,115
 9cc:	22e78a63          	beq	a5,a4,c00 <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 9d0:	02500713          	li	a4,37
 9d4:	04e79e63          	bne	a5,a4,a30 <vprintf+0x140>
        putc(fd, '%');
 9d8:	02500593          	li	a1,37
 9dc:	000b0513          	mv	a0,s6
 9e0:	df5ff0ef          	jal	7d4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 9e4:	00000993          	li	s3,0
 9e8:	f81ff06f          	j	968 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
 9ec:	008b8913          	addi	s2,s7,8
 9f0:	00100693          	li	a3,1
 9f4:	00a00613          	li	a2,10
 9f8:	000ba583          	lw	a1,0(s7)
 9fc:	000b0513          	mv	a0,s6
 a00:	e05ff0ef          	jal	804 <printint>
 a04:	00090b93          	mv	s7,s2
      state = 0;
 a08:	00000993          	li	s3,0
 a0c:	f5dff06f          	j	968 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
 a10:	06400793          	li	a5,100
 a14:	02f68e63          	beq	a3,a5,a50 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a18:	06c00793          	li	a5,108
 a1c:	04f68e63          	beq	a3,a5,a78 <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
 a20:	07500793          	li	a5,117
 a24:	0ef68063          	beq	a3,a5,b04 <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
 a28:	07800793          	li	a5,120
 a2c:	14f68663          	beq	a3,a5,b78 <vprintf+0x288>
        putc(fd, '%');
 a30:	02500593          	li	a1,37
 a34:	000b0513          	mv	a0,s6
 a38:	d9dff0ef          	jal	7d4 <putc>
        putc(fd, c0);
 a3c:	00090593          	mv	a1,s2
 a40:	000b0513          	mv	a0,s6
 a44:	d91ff0ef          	jal	7d4 <putc>
      state = 0;
 a48:	00000993          	li	s3,0
 a4c:	f1dff06f          	j	968 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a50:	008b8913          	addi	s2,s7,8
 a54:	00100693          	li	a3,1
 a58:	00a00613          	li	a2,10
 a5c:	000ba583          	lw	a1,0(s7)
 a60:	000b0513          	mv	a0,s6
 a64:	da1ff0ef          	jal	804 <printint>
        i += 1;
 a68:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 a6c:	00090b93          	mv	s7,s2
      state = 0;
 a70:	00000993          	li	s3,0
        i += 1;
 a74:	ef5ff06f          	j	968 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a78:	06400793          	li	a5,100
 a7c:	02f60e63          	beq	a2,a5,ab8 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a80:	07500793          	li	a5,117
 a84:	0af60463          	beq	a2,a5,b2c <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a88:	07800793          	li	a5,120
 a8c:	faf612e3          	bne	a2,a5,a30 <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a90:	008b8913          	addi	s2,s7,8
 a94:	00000693          	li	a3,0
 a98:	01000613          	li	a2,16
 a9c:	000ba583          	lw	a1,0(s7)
 aa0:	000b0513          	mv	a0,s6
 aa4:	d61ff0ef          	jal	804 <printint>
        i += 2;
 aa8:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 aac:	00090b93          	mv	s7,s2
      state = 0;
 ab0:	00000993          	li	s3,0
        i += 2;
 ab4:	eb5ff06f          	j	968 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
 ab8:	008b8913          	addi	s2,s7,8
 abc:	00100693          	li	a3,1
 ac0:	00a00613          	li	a2,10
 ac4:	000ba583          	lw	a1,0(s7)
 ac8:	000b0513          	mv	a0,s6
 acc:	d39ff0ef          	jal	804 <printint>
        i += 2;
 ad0:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 ad4:	00090b93          	mv	s7,s2
      state = 0;
 ad8:	00000993          	li	s3,0
        i += 2;
 adc:	e8dff06f          	j	968 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
 ae0:	008b8913          	addi	s2,s7,8
 ae4:	00000693          	li	a3,0
 ae8:	00a00613          	li	a2,10
 aec:	000ba583          	lw	a1,0(s7)
 af0:	000b0513          	mv	a0,s6
 af4:	d11ff0ef          	jal	804 <printint>
 af8:	00090b93          	mv	s7,s2
      state = 0;
 afc:	00000993          	li	s3,0
 b00:	e69ff06f          	j	968 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b04:	008b8913          	addi	s2,s7,8
 b08:	00000693          	li	a3,0
 b0c:	00a00613          	li	a2,10
 b10:	000ba583          	lw	a1,0(s7)
 b14:	000b0513          	mv	a0,s6
 b18:	cedff0ef          	jal	804 <printint>
        i += 1;
 b1c:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 b20:	00090b93          	mv	s7,s2
      state = 0;
 b24:	00000993          	li	s3,0
        i += 1;
 b28:	e41ff06f          	j	968 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b2c:	008b8913          	addi	s2,s7,8
 b30:	00000693          	li	a3,0
 b34:	00a00613          	li	a2,10
 b38:	000ba583          	lw	a1,0(s7)
 b3c:	000b0513          	mv	a0,s6
 b40:	cc5ff0ef          	jal	804 <printint>
        i += 2;
 b44:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 b48:	00090b93          	mv	s7,s2
      state = 0;
 b4c:	00000993          	li	s3,0
        i += 2;
 b50:	e19ff06f          	j	968 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
 b54:	008b8913          	addi	s2,s7,8
 b58:	00000693          	li	a3,0
 b5c:	01000613          	li	a2,16
 b60:	000ba583          	lw	a1,0(s7)
 b64:	000b0513          	mv	a0,s6
 b68:	c9dff0ef          	jal	804 <printint>
 b6c:	00090b93          	mv	s7,s2
      state = 0;
 b70:	00000993          	li	s3,0
 b74:	df5ff06f          	j	968 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
 b78:	008b8913          	addi	s2,s7,8
 b7c:	00000693          	li	a3,0
 b80:	01000613          	li	a2,16
 b84:	000ba583          	lw	a1,0(s7)
 b88:	000b0513          	mv	a0,s6
 b8c:	c79ff0ef          	jal	804 <printint>
        i += 1;
 b90:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 b94:	00090b93          	mv	s7,s2
      state = 0;
 b98:	00000993          	li	s3,0
        i += 1;
 b9c:	dcdff06f          	j	968 <vprintf+0x78>
 ba0:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 ba4:	008b8d13          	addi	s10,s7,8
 ba8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 bac:	03000593          	li	a1,48
 bb0:	000b0513          	mv	a0,s6
 bb4:	c21ff0ef          	jal	7d4 <putc>
  putc(fd, 'x');
 bb8:	07800593          	li	a1,120
 bbc:	000b0513          	mv	a0,s6
 bc0:	c15ff0ef          	jal	7d4 <putc>
 bc4:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 bc8:	00000b97          	auipc	s7,0x0
 bcc:	3e0b8b93          	addi	s7,s7,992 # fa8 <digits>
 bd0:	03c9d793          	srli	a5,s3,0x3c
 bd4:	00fb87b3          	add	a5,s7,a5
 bd8:	0007c583          	lbu	a1,0(a5)
 bdc:	000b0513          	mv	a0,s6
 be0:	bf5ff0ef          	jal	7d4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 be4:	00499993          	slli	s3,s3,0x4
 be8:	fff9091b          	addiw	s2,s2,-1
 bec:	fe0912e3          	bnez	s2,bd0 <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
 bf0:	000d0b93          	mv	s7,s10
      state = 0;
 bf4:	00000993          	li	s3,0
 bf8:	00013d03          	ld	s10,0(sp)
 bfc:	d6dff06f          	j	968 <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
 c00:	008b8993          	addi	s3,s7,8
 c04:	000bb903          	ld	s2,0(s7)
 c08:	02090663          	beqz	s2,c34 <vprintf+0x344>
        for(; *s; s++)
 c0c:	00094583          	lbu	a1,0(s2)
 c10:	02058a63          	beqz	a1,c44 <vprintf+0x354>
          putc(fd, *s);
 c14:	000b0513          	mv	a0,s6
 c18:	bbdff0ef          	jal	7d4 <putc>
        for(; *s; s++)
 c1c:	00190913          	addi	s2,s2,1
 c20:	00094583          	lbu	a1,0(s2)
 c24:	fe0598e3          	bnez	a1,c14 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 c28:	00098b93          	mv	s7,s3
      state = 0;
 c2c:	00000993          	li	s3,0
 c30:	d39ff06f          	j	968 <vprintf+0x78>
          s = "(null)";
 c34:	00000917          	auipc	s2,0x0
 c38:	36c90913          	addi	s2,s2,876 # fa0 <malloc+0x1d8>
        for(; *s; s++)
 c3c:	02800593          	li	a1,40
 c40:	fd5ff06f          	j	c14 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
 c44:	00098b93          	mv	s7,s3
      state = 0;
 c48:	00000993          	li	s3,0
 c4c:	d1dff06f          	j	968 <vprintf+0x78>
 c50:	04813483          	ld	s1,72(sp)
 c54:	03813983          	ld	s3,56(sp)
 c58:	03013a03          	ld	s4,48(sp)
 c5c:	02813a83          	ld	s5,40(sp)
 c60:	02013b03          	ld	s6,32(sp)
 c64:	01813b83          	ld	s7,24(sp)
 c68:	01013c03          	ld	s8,16(sp)
 c6c:	00813c83          	ld	s9,8(sp)
    }
  }
}
 c70:	05813083          	ld	ra,88(sp)
 c74:	05013403          	ld	s0,80(sp)
 c78:	04013903          	ld	s2,64(sp)
 c7c:	06010113          	addi	sp,sp,96
 c80:	00008067          	ret

0000000000000c84 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c84:	fb010113          	addi	sp,sp,-80
 c88:	00113c23          	sd	ra,24(sp)
 c8c:	00813823          	sd	s0,16(sp)
 c90:	02010413          	addi	s0,sp,32
 c94:	00c43023          	sd	a2,0(s0)
 c98:	00d43423          	sd	a3,8(s0)
 c9c:	00e43823          	sd	a4,16(s0)
 ca0:	00f43c23          	sd	a5,24(s0)
 ca4:	03043023          	sd	a6,32(s0)
 ca8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 cac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 cb0:	00040613          	mv	a2,s0
 cb4:	c3dff0ef          	jal	8f0 <vprintf>
}
 cb8:	01813083          	ld	ra,24(sp)
 cbc:	01013403          	ld	s0,16(sp)
 cc0:	05010113          	addi	sp,sp,80
 cc4:	00008067          	ret

0000000000000cc8 <printf>:

void
printf(const char *fmt, ...)
{
 cc8:	fa010113          	addi	sp,sp,-96
 ccc:	00113c23          	sd	ra,24(sp)
 cd0:	00813823          	sd	s0,16(sp)
 cd4:	02010413          	addi	s0,sp,32
 cd8:	00b43423          	sd	a1,8(s0)
 cdc:	00c43823          	sd	a2,16(s0)
 ce0:	00d43c23          	sd	a3,24(s0)
 ce4:	02e43023          	sd	a4,32(s0)
 ce8:	02f43423          	sd	a5,40(s0)
 cec:	03043823          	sd	a6,48(s0)
 cf0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 cf4:	00840613          	addi	a2,s0,8
 cf8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 cfc:	00050593          	mv	a1,a0
 d00:	00100513          	li	a0,1
 d04:	bedff0ef          	jal	8f0 <vprintf>
}
 d08:	01813083          	ld	ra,24(sp)
 d0c:	01013403          	ld	s0,16(sp)
 d10:	06010113          	addi	sp,sp,96
 d14:	00008067          	ret

0000000000000d18 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 d18:	ff010113          	addi	sp,sp,-16
 d1c:	00813423          	sd	s0,8(sp)
 d20:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 d24:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d28:	00000797          	auipc	a5,0x0
 d2c:	2d87b783          	ld	a5,728(a5) # 1000 <freep>
 d30:	0400006f          	j	d70 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 d34:	00862703          	lw	a4,8(a2)
 d38:	00b7073b          	addw	a4,a4,a1
 d3c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 d40:	0007b703          	ld	a4,0(a5)
 d44:	00073603          	ld	a2,0(a4)
 d48:	0500006f          	j	d98 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 d4c:	ff852703          	lw	a4,-8(a0)
 d50:	00c7073b          	addw	a4,a4,a2
 d54:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d58:	ff053683          	ld	a3,-16(a0)
 d5c:	0540006f          	j	db0 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d60:	0007b703          	ld	a4,0(a5)
 d64:	00e7e463          	bltu	a5,a4,d6c <free+0x54>
 d68:	00e6ec63          	bltu	a3,a4,d80 <free+0x68>
{
 d6c:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d70:	fed7f8e3          	bgeu	a5,a3,d60 <free+0x48>
 d74:	0007b703          	ld	a4,0(a5)
 d78:	00e6e463          	bltu	a3,a4,d80 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d7c:	fee7e8e3          	bltu	a5,a4,d6c <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 d80:	ff852583          	lw	a1,-8(a0)
 d84:	0007b603          	ld	a2,0(a5)
 d88:	02059813          	slli	a6,a1,0x20
 d8c:	01c85713          	srli	a4,a6,0x1c
 d90:	00e68733          	add	a4,a3,a4
 d94:	fae600e3          	beq	a2,a4,d34 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 d98:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d9c:	0087a603          	lw	a2,8(a5)
 da0:	02061593          	slli	a1,a2,0x20
 da4:	01c5d713          	srli	a4,a1,0x1c
 da8:	00e78733          	add	a4,a5,a4
 dac:	fae680e3          	beq	a3,a4,d4c <free+0x34>
    p->s.ptr = bp->s.ptr;
 db0:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 db4:	00000717          	auipc	a4,0x0
 db8:	24f73623          	sd	a5,588(a4) # 1000 <freep>
}
 dbc:	00813403          	ld	s0,8(sp)
 dc0:	01010113          	addi	sp,sp,16
 dc4:	00008067          	ret

0000000000000dc8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 dc8:	fc010113          	addi	sp,sp,-64
 dcc:	02113c23          	sd	ra,56(sp)
 dd0:	02813823          	sd	s0,48(sp)
 dd4:	02913423          	sd	s1,40(sp)
 dd8:	01313c23          	sd	s3,24(sp)
 ddc:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 de0:	02051493          	slli	s1,a0,0x20
 de4:	0204d493          	srli	s1,s1,0x20
 de8:	00f48493          	addi	s1,s1,15
 dec:	0044d493          	srli	s1,s1,0x4
 df0:	0014899b          	addiw	s3,s1,1
 df4:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
 df8:	00000517          	auipc	a0,0x0
 dfc:	20853503          	ld	a0,520(a0) # 1000 <freep>
 e00:	04050663          	beqz	a0,e4c <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e04:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 e08:	0087a703          	lw	a4,8(a5)
 e0c:	0c977c63          	bgeu	a4,s1,ee4 <malloc+0x11c>
 e10:	03213023          	sd	s2,32(sp)
 e14:	01413823          	sd	s4,16(sp)
 e18:	01513423          	sd	s5,8(sp)
 e1c:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
 e20:	00098a13          	mv	s4,s3
 e24:	0009871b          	sext.w	a4,s3
 e28:	000016b7          	lui	a3,0x1
 e2c:	00d77463          	bgeu	a4,a3,e34 <malloc+0x6c>
 e30:	00001a37          	lui	s4,0x1
 e34:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 e38:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 e3c:	00000917          	auipc	s2,0x0
 e40:	1c490913          	addi	s2,s2,452 # 1000 <freep>
  if(p == (char*)-1)
 e44:	fff00a93          	li	s5,-1
 e48:	05c0006f          	j	ea4 <malloc+0xdc>
 e4c:	03213023          	sd	s2,32(sp)
 e50:	01413823          	sd	s4,16(sp)
 e54:	01513423          	sd	s5,8(sp)
 e58:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 e5c:	00000797          	auipc	a5,0x0
 e60:	1c478793          	addi	a5,a5,452 # 1020 <base>
 e64:	00000717          	auipc	a4,0x0
 e68:	18f73e23          	sd	a5,412(a4) # 1000 <freep>
 e6c:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 e70:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 e74:	fadff06f          	j	e20 <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
 e78:	0007b703          	ld	a4,0(a5)
 e7c:	00e53023          	sd	a4,0(a0)
 e80:	0800006f          	j	f00 <malloc+0x138>
  hp->s.size = nu;
 e84:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 e88:	01050513          	addi	a0,a0,16
 e8c:	e8dff0ef          	jal	d18 <free>
  return freep;
 e90:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 e94:	08050863          	beqz	a0,f24 <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e98:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 e9c:	0087a703          	lw	a4,8(a5)
 ea0:	02977a63          	bgeu	a4,s1,ed4 <malloc+0x10c>
    if(p == freep)
 ea4:	00093703          	ld	a4,0(s2)
 ea8:	00078513          	mv	a0,a5
 eac:	fef716e3          	bne	a4,a5,e98 <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
 eb0:	000a0513          	mv	a0,s4
 eb4:	8fdff0ef          	jal	7b0 <sbrk>
  if(p == (char*)-1)
 eb8:	fd5516e3          	bne	a0,s5,e84 <malloc+0xbc>
        return 0;
 ebc:	00000513          	li	a0,0
 ec0:	02013903          	ld	s2,32(sp)
 ec4:	01013a03          	ld	s4,16(sp)
 ec8:	00813a83          	ld	s5,8(sp)
 ecc:	00013b03          	ld	s6,0(sp)
 ed0:	03c0006f          	j	f0c <malloc+0x144>
 ed4:	02013903          	ld	s2,32(sp)
 ed8:	01013a03          	ld	s4,16(sp)
 edc:	00813a83          	ld	s5,8(sp)
 ee0:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
 ee4:	f8e48ae3          	beq	s1,a4,e78 <malloc+0xb0>
        p->s.size -= nunits;
 ee8:	4137073b          	subw	a4,a4,s3
 eec:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 ef0:	02071693          	slli	a3,a4,0x20
 ef4:	01c6d713          	srli	a4,a3,0x1c
 ef8:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 efc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 f00:	00000717          	auipc	a4,0x0
 f04:	10a73023          	sd	a0,256(a4) # 1000 <freep>
      return (void*)(p + 1);
 f08:	01078513          	addi	a0,a5,16
  }
}
 f0c:	03813083          	ld	ra,56(sp)
 f10:	03013403          	ld	s0,48(sp)
 f14:	02813483          	ld	s1,40(sp)
 f18:	01813983          	ld	s3,24(sp)
 f1c:	04010113          	addi	sp,sp,64
 f20:	00008067          	ret
 f24:	02013903          	ld	s2,32(sp)
 f28:	01013a03          	ld	s4,16(sp)
 f2c:	00813a83          	ld	s5,8(sp)
 f30:	00013b03          	ld	s6,0(sp)
 f34:	fd9ff06f          	j	f0c <malloc+0x144>
