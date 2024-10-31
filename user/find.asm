
user/_find:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <match>:
//   return strcmp(filename, name) == 0;
// }

// '.' Matches any single character.​​​​
// '*' Matches zero or more of the preceding element.
int match(char* s, char* p) {
       0:	fe010113          	addi	sp,sp,-32
       4:	00113c23          	sd	ra,24(sp)
       8:	00813823          	sd	s0,16(sp)
       c:	01213023          	sd	s2,0(sp)
      10:	02010413          	addi	s0,sp,32
      14:	00050913          	mv	s2,a0
  if (!*p) return !*s;
      18:	0005c783          	lbu	a5,0(a1)
      1c:	02078a63          	beqz	a5,50 <match+0x50>
      20:	00913423          	sd	s1,8(sp)
      24:	00058493          	mv	s1,a1
  if (*(p + 1) != '*') 
      28:	0015c683          	lbu	a3,1(a1)
      2c:	02a00713          	li	a4,42
      30:	04e68a63          	beq	a3,a4,84 <match+0x84>
    return *s == *p || (*p == '.' && *s != '\0') ? match(s + 1, p + 1) : 0; 
      34:	00054703          	lbu	a4,0(a0)
      38:	02e78c63          	beq	a5,a4,70 <match+0x70>
      3c:	02e00693          	li	a3,46
      40:	00000513          	li	a0,0
      44:	02d78463          	beq	a5,a3,6c <match+0x6c>
      48:	00813483          	ld	s1,8(sp)
      4c:	00c0006f          	j	58 <match+0x58>
  if (!*p) return !*s;
      50:	00054503          	lbu	a0,0(a0)
      54:	00153513          	seqz	a0,a0
  else 
    return *s == *p || (*p == '.' && *s != '\0') ? match(s, p + 2) || match(s + 1, p) : match(s, p + 2);
    //return (*s == *p || (*p == '.' && *s != '\0')) && match(s + 1, p) || match(s, p + 2);
}
      58:	01813083          	ld	ra,24(sp)
      5c:	01013403          	ld	s0,16(sp)
      60:	00013903          	ld	s2,0(sp)
      64:	02010113          	addi	sp,sp,32
      68:	00008067          	ret
    return *s == *p || (*p == '.' && *s != '\0') ? match(s + 1, p + 1) : 0; 
      6c:	06070c63          	beqz	a4,e4 <match+0xe4>
      70:	00148593          	addi	a1,s1,1
      74:	00190513          	addi	a0,s2,1
      78:	f89ff0ef          	jal	0 <match>
      7c:	00813483          	ld	s1,8(sp)
      80:	fd9ff06f          	j	58 <match+0x58>
    return *s == *p || (*p == '.' && *s != '\0') ? match(s, p + 2) || match(s + 1, p) : match(s, p + 2);
      84:	00054703          	lbu	a4,0(a0)
      88:	00e78863          	beq	a5,a4,98 <match+0x98>
      8c:	02e00693          	li	a3,46
      90:	04d79063          	bne	a5,a3,d0 <match+0xd0>
      94:	02070e63          	beqz	a4,d0 <match+0xd0>
      98:	00248593          	addi	a1,s1,2
      9c:	00090513          	mv	a0,s2
      a0:	f61ff0ef          	jal	0 <match>
      a4:	00050793          	mv	a5,a0
      a8:	00100513          	li	a0,1
      ac:	00078663          	beqz	a5,b8 <match+0xb8>
      b0:	00813483          	ld	s1,8(sp)
      b4:	fa5ff06f          	j	58 <match+0x58>
      b8:	00048593          	mv	a1,s1
      bc:	00190513          	addi	a0,s2,1
      c0:	f41ff0ef          	jal	0 <match>
      c4:	00a03533          	snez	a0,a0
      c8:	00813483          	ld	s1,8(sp)
      cc:	f8dff06f          	j	58 <match+0x58>
      d0:	00248593          	addi	a1,s1,2
      d4:	00090513          	mv	a0,s2
      d8:	f29ff0ef          	jal	0 <match>
      dc:	00813483          	ld	s1,8(sp)
      e0:	f79ff06f          	j	58 <match+0x58>
      e4:	00813483          	ld	s1,8(sp)
      e8:	f71ff06f          	j	58 <match+0x58>

00000000000000ec <catdir>:


void
catdir(char *predix, char *name, char *buf)
{
      ec:	fd010113          	addi	sp,sp,-48
      f0:	02113423          	sd	ra,40(sp)
      f4:	02813023          	sd	s0,32(sp)
      f8:	00913c23          	sd	s1,24(sp)
      fc:	01213823          	sd	s2,16(sp)
     100:	01313423          	sd	s3,8(sp)
     104:	03010413          	addi	s0,sp,48
     108:	00050993          	mv	s3,a0
     10c:	00058913          	mv	s2,a1
     110:	00060493          	mv	s1,a2
  memcpy(buf, predix, strlen(predix));
     114:	3a8000ef          	jal	4bc <strlen>
     118:	0005061b          	sext.w	a2,a0
     11c:	00098593          	mv	a1,s3
     120:	00048513          	mv	a0,s1
     124:	6b0000ef          	jal	7d4 <memcpy>
  char *p = buf + strlen(predix);
     128:	00098513          	mv	a0,s3
     12c:	390000ef          	jal	4bc <strlen>
     130:	02051513          	slli	a0,a0,0x20
     134:	02055513          	srli	a0,a0,0x20
     138:	00a484b3          	add	s1,s1,a0
  *p++ = '/';
     13c:	00148993          	addi	s3,s1,1
     140:	02f00793          	li	a5,47
     144:	00f48023          	sb	a5,0(s1)
  memcpy(p, name, strlen(name));
     148:	00090513          	mv	a0,s2
     14c:	370000ef          	jal	4bc <strlen>
     150:	0005061b          	sext.w	a2,a0
     154:	00090593          	mv	a1,s2
     158:	00098513          	mv	a0,s3
     15c:	678000ef          	jal	7d4 <memcpy>
  p += strlen(name);
     160:	00090513          	mv	a0,s2
     164:	358000ef          	jal	4bc <strlen>
     168:	02051513          	slli	a0,a0,0x20
     16c:	02055513          	srli	a0,a0,0x20
  *p++ = 0;
     170:	00a989b3          	add	s3,s3,a0
     174:	00098023          	sb	zero,0(s3)
}
     178:	02813083          	ld	ra,40(sp)
     17c:	02013403          	ld	s0,32(sp)
     180:	01813483          	ld	s1,24(sp)
     184:	01013903          	ld	s2,16(sp)
     188:	00813983          	ld	s3,8(sp)
     18c:	03010113          	addi	sp,sp,48
     190:	00008067          	ret

0000000000000194 <find>:


void
find(int fd, char *dir, char *name) {
     194:	d9010113          	addi	sp,sp,-624
     198:	26113423          	sd	ra,616(sp)
     19c:	26813023          	sd	s0,608(sp)
     1a0:	24913c23          	sd	s1,600(sp)
     1a4:	25213823          	sd	s2,592(sp)
     1a8:	25313423          	sd	s3,584(sp)
     1ac:	25413023          	sd	s4,576(sp)
     1b0:	23513c23          	sd	s5,568(sp)
     1b4:	27010413          	addi	s0,sp,624
     1b8:	00050493          	mv	s1,a0
     1bc:	00058993          	mv	s3,a1
     1c0:	00060a93          	mv	s5,a2
  struct dirent de;
  
  while(read(fd, &de, sizeof(de)) == sizeof(de)) {
    if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
     1c4:	00001917          	auipc	s2,0x1
     1c8:	e9c90913          	addi	s2,s2,-356 # 1060 <malloc+0x178>
     1cc:	00001a17          	auipc	s4,0x1
     1d0:	e9ca0a13          	addi	s4,s4,-356 # 1068 <malloc+0x180>
  while(read(fd, &de, sizeof(de)) == sizeof(de)) {
     1d4:	01000613          	li	a2,16
     1d8:	fb040593          	addi	a1,s0,-80
     1dc:	00048513          	mv	a0,s1
     1e0:	648000ef          	jal	828 <read>
     1e4:	01000793          	li	a5,16
     1e8:	0cf51663          	bne	a0,a5,2b4 <find+0x120>
    if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
     1ec:	00090593          	mv	a1,s2
     1f0:	fb240513          	addi	a0,s0,-78
     1f4:	288000ef          	jal	47c <strcmp>
     1f8:	fc050ee3          	beqz	a0,1d4 <find+0x40>
     1fc:	000a0593          	mv	a1,s4
     200:	fb240513          	addi	a0,s0,-78
     204:	278000ef          	jal	47c <strcmp>
     208:	fc0506e3          	beqz	a0,1d4 <find+0x40>
      continue;
    struct stat st;
    char path[512];
    catdir(dir, de.name, path);
     20c:	db040613          	addi	a2,s0,-592
     210:	fb240593          	addi	a1,s0,-78
     214:	00098513          	mv	a0,s3
     218:	ed5ff0ef          	jal	ec <catdir>
  
    if(de.inum == 0)
     21c:	fb045783          	lhu	a5,-80(s0)
     220:	fa078ae3          	beqz	a5,1d4 <find+0x40>
        continue;
    if(stat(path, &st) < 0){
     224:	d9840593          	addi	a1,s0,-616
     228:	db040513          	addi	a0,s0,-592
     22c:	408000ef          	jal	634 <stat>
     230:	02054c63          	bltz	a0,268 <find+0xd4>
        printf("find: cannot stat %s\n", path);
        continue;
    }
    if (st.type == T_FILE && match(de.name, name)) {
     234:	da041783          	lh	a5,-608(s0)
     238:	00200713          	li	a4,2
     23c:	04e78063          	beq	a5,a4,27c <find+0xe8>
      printf("%s\n", path);
    } else if (st.type == T_DIR) {
     240:	00100713          	li	a4,1
     244:	f8e798e3          	bne	a5,a4,1d4 <find+0x40>
      int subfd;
      if((subfd = open(path, 0)) < 0){
     248:	00000593          	li	a1,0
     24c:	db040513          	addi	a0,s0,-592
     250:	614000ef          	jal	864 <open>
     254:	04054663          	bltz	a0,2a0 <find+0x10c>
        printf("find: cannot open %s\n", path);
        continue;
      }
      find(subfd, path, name);
     258:	000a8613          	mv	a2,s5
     25c:	db040593          	addi	a1,s0,-592
     260:	f35ff0ef          	jal	194 <find>
     264:	f71ff06f          	j	1d4 <find+0x40>
        printf("find: cannot stat %s\n", path);
     268:	db040593          	addi	a1,s0,-592
     26c:	00001517          	auipc	a0,0x1
     270:	e0450513          	addi	a0,a0,-508 # 1070 <malloc+0x188>
     274:	375000ef          	jal	de8 <printf>
        continue;
     278:	f5dff06f          	j	1d4 <find+0x40>
    if (st.type == T_FILE && match(de.name, name)) {
     27c:	000a8593          	mv	a1,s5
     280:	fb240513          	addi	a0,s0,-78
     284:	d7dff0ef          	jal	0 <match>
     288:	f40506e3          	beqz	a0,1d4 <find+0x40>
      printf("%s\n", path);
     28c:	db040593          	addi	a1,s0,-592
     290:	00001517          	auipc	a0,0x1
     294:	df850513          	addi	a0,a0,-520 # 1088 <malloc+0x1a0>
     298:	351000ef          	jal	de8 <printf>
     29c:	f39ff06f          	j	1d4 <find+0x40>
        printf("find: cannot open %s\n", path);
     2a0:	db040593          	addi	a1,s0,-592
     2a4:	00001517          	auipc	a0,0x1
     2a8:	dec50513          	addi	a0,a0,-532 # 1090 <malloc+0x1a8>
     2ac:	33d000ef          	jal	de8 <printf>
        continue;
     2b0:	f25ff06f          	j	1d4 <find+0x40>
    }

  }
}
     2b4:	26813083          	ld	ra,616(sp)
     2b8:	26013403          	ld	s0,608(sp)
     2bc:	25813483          	ld	s1,600(sp)
     2c0:	25013903          	ld	s2,592(sp)
     2c4:	24813983          	ld	s3,584(sp)
     2c8:	24013a03          	ld	s4,576(sp)
     2cc:	23813a83          	ld	s5,568(sp)
     2d0:	27010113          	addi	sp,sp,624
     2d4:	00008067          	ret

00000000000002d8 <main>:


int
main(int argc, char *argv[])
{
     2d8:	fa010113          	addi	sp,sp,-96
     2dc:	04113c23          	sd	ra,88(sp)
     2e0:	04813823          	sd	s0,80(sp)
     2e4:	06010413          	addi	s0,sp,96
  if (argc != 3) {
     2e8:	00300793          	li	a5,3
     2ec:	02f50263          	beq	a0,a5,310 <main+0x38>
     2f0:	04913423          	sd	s1,72(sp)
     2f4:	05213023          	sd	s2,64(sp)
    fprintf(2, "Usage: find dir name\n");
     2f8:	00001597          	auipc	a1,0x1
     2fc:	db058593          	addi	a1,a1,-592 # 10a8 <malloc+0x1c0>
     300:	00200513          	li	a0,2
     304:	2a1000ef          	jal	da4 <fprintf>
    exit(1);
     308:	00100513          	li	a0,1
     30c:	4f8000ef          	jal	804 <exit>
     310:	04913423          	sd	s1,72(sp)
     314:	00058493          	mv	s1,a1
  }

  char dir[DIRSIZ + 1];
  char name[DIRSIZ + 1];

  if (strlen(argv[1]) > DIRSIZ || strlen(argv[2]) > DIRSIZ) {
     318:	0085b503          	ld	a0,8(a1)
     31c:	1a0000ef          	jal	4bc <strlen>
     320:	0005051b          	sext.w	a0,a0
     324:	00e00793          	li	a5,14
     328:	00a7ec63          	bltu	a5,a0,340 <main+0x68>
     32c:	0104b503          	ld	a0,16(s1)
     330:	18c000ef          	jal	4bc <strlen>
     334:	0005051b          	sext.w	a0,a0
     338:	00e00793          	li	a5,14
     33c:	02a7f063          	bgeu	a5,a0,35c <main+0x84>
     340:	05213023          	sd	s2,64(sp)
    fprintf(2, "dir or name too long...\n");
     344:	00001597          	auipc	a1,0x1
     348:	d7c58593          	addi	a1,a1,-644 # 10c0 <malloc+0x1d8>
     34c:	00200513          	li	a0,2
     350:	255000ef          	jal	da4 <fprintf>
    exit(1);
     354:	00100513          	li	a0,1
     358:	4ac000ef          	jal	804 <exit>
     35c:	05213023          	sd	s2,64(sp)
  }

  memcpy(dir, argv[1], strlen(argv[1]));
     360:	0084b903          	ld	s2,8(s1)
     364:	00090513          	mv	a0,s2
     368:	154000ef          	jal	4bc <strlen>
     36c:	0005061b          	sext.w	a2,a0
     370:	00090593          	mv	a1,s2
     374:	fd040513          	addi	a0,s0,-48
     378:	45c000ef          	jal	7d4 <memcpy>
  memcpy(name, argv[2], strlen(argv[2]));
     37c:	0104b483          	ld	s1,16(s1)
     380:	00048513          	mv	a0,s1
     384:	138000ef          	jal	4bc <strlen>
     388:	0005061b          	sext.w	a2,a0
     38c:	00048593          	mv	a1,s1
     390:	fc040513          	addi	a0,s0,-64
     394:	440000ef          	jal	7d4 <memcpy>

  int fd;
  struct stat st;

  if((fd = open(dir, 0)) < 0){
     398:	00000593          	li	a1,0
     39c:	fd040513          	addi	a0,s0,-48
     3a0:	4c4000ef          	jal	864 <open>
     3a4:	00050493          	mv	s1,a0
     3a8:	02054a63          	bltz	a0,3dc <main+0x104>
    fprintf(2, "find: cannot open %s\n", dir);
    exit(1);
  }

  if(fstat(fd, &st) < 0){
     3ac:	fa840593          	addi	a1,s0,-88
     3b0:	4d8000ef          	jal	888 <fstat>
     3b4:	04054263          	bltz	a0,3f8 <main+0x120>
    fprintf(2, "find: cannot stat %s\n", dir);
    close(fd);
    exit(1);
  }

  if (st.type != T_DIR) {
     3b8:	fb041703          	lh	a4,-80(s0)
     3bc:	00100793          	li	a5,1
     3c0:	04f70e63          	beq	a4,a5,41c <main+0x144>
    printf("%s is not a dir\n", dir);
     3c4:	fd040593          	addi	a1,s0,-48
     3c8:	00001517          	auipc	a0,0x1
     3cc:	d1850513          	addi	a0,a0,-744 # 10e0 <malloc+0x1f8>
     3d0:	219000ef          	jal	de8 <printf>
  } else {
    find(fd, dir, name);
  }
  
  exit(0);
     3d4:	00000513          	li	a0,0
     3d8:	42c000ef          	jal	804 <exit>
    fprintf(2, "find: cannot open %s\n", dir);
     3dc:	fd040613          	addi	a2,s0,-48
     3e0:	00001597          	auipc	a1,0x1
     3e4:	cb058593          	addi	a1,a1,-848 # 1090 <malloc+0x1a8>
     3e8:	00200513          	li	a0,2
     3ec:	1b9000ef          	jal	da4 <fprintf>
    exit(1);
     3f0:	00100513          	li	a0,1
     3f4:	410000ef          	jal	804 <exit>
    fprintf(2, "find: cannot stat %s\n", dir);
     3f8:	fd040613          	addi	a2,s0,-48
     3fc:	00001597          	auipc	a1,0x1
     400:	c7458593          	addi	a1,a1,-908 # 1070 <malloc+0x188>
     404:	00200513          	li	a0,2
     408:	19d000ef          	jal	da4 <fprintf>
    close(fd);
     40c:	00048513          	mv	a0,s1
     410:	430000ef          	jal	840 <close>
    exit(1);
     414:	00100513          	li	a0,1
     418:	3ec000ef          	jal	804 <exit>
    find(fd, dir, name);
     41c:	fc040613          	addi	a2,s0,-64
     420:	fd040593          	addi	a1,s0,-48
     424:	00048513          	mv	a0,s1
     428:	d6dff0ef          	jal	194 <find>
     42c:	fa9ff06f          	j	3d4 <main+0xfc>

0000000000000430 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     430:	ff010113          	addi	sp,sp,-16
     434:	00113423          	sd	ra,8(sp)
     438:	00813023          	sd	s0,0(sp)
     43c:	01010413          	addi	s0,sp,16
  extern int main();
  main();
     440:	e99ff0ef          	jal	2d8 <main>
  exit(0);
     444:	00000513          	li	a0,0
     448:	3bc000ef          	jal	804 <exit>

000000000000044c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     44c:	ff010113          	addi	sp,sp,-16
     450:	00813423          	sd	s0,8(sp)
     454:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     458:	00050793          	mv	a5,a0
     45c:	00158593          	addi	a1,a1,1
     460:	00178793          	addi	a5,a5,1
     464:	fff5c703          	lbu	a4,-1(a1)
     468:	fee78fa3          	sb	a4,-1(a5)
     46c:	fe0718e3          	bnez	a4,45c <strcpy+0x10>
    ;
  return os;
}
     470:	00813403          	ld	s0,8(sp)
     474:	01010113          	addi	sp,sp,16
     478:	00008067          	ret

000000000000047c <strcmp>:

int
strcmp(const char *p, const char *q)
{
     47c:	ff010113          	addi	sp,sp,-16
     480:	00813423          	sd	s0,8(sp)
     484:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
     488:	00054783          	lbu	a5,0(a0)
     48c:	00078e63          	beqz	a5,4a8 <strcmp+0x2c>
     490:	0005c703          	lbu	a4,0(a1)
     494:	00f71a63          	bne	a4,a5,4a8 <strcmp+0x2c>
    p++, q++;
     498:	00150513          	addi	a0,a0,1
     49c:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
     4a0:	00054783          	lbu	a5,0(a0)
     4a4:	fe0796e3          	bnez	a5,490 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
     4a8:	0005c503          	lbu	a0,0(a1)
}
     4ac:	40a7853b          	subw	a0,a5,a0
     4b0:	00813403          	ld	s0,8(sp)
     4b4:	01010113          	addi	sp,sp,16
     4b8:	00008067          	ret

00000000000004bc <strlen>:

uint
strlen(const char *s)
{
     4bc:	ff010113          	addi	sp,sp,-16
     4c0:	00813423          	sd	s0,8(sp)
     4c4:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     4c8:	00054783          	lbu	a5,0(a0)
     4cc:	02078863          	beqz	a5,4fc <strlen+0x40>
     4d0:	00150513          	addi	a0,a0,1
     4d4:	00050793          	mv	a5,a0
     4d8:	00078693          	mv	a3,a5
     4dc:	00178793          	addi	a5,a5,1
     4e0:	fff7c703          	lbu	a4,-1(a5)
     4e4:	fe071ae3          	bnez	a4,4d8 <strlen+0x1c>
     4e8:	40a6853b          	subw	a0,a3,a0
     4ec:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
     4f0:	00813403          	ld	s0,8(sp)
     4f4:	01010113          	addi	sp,sp,16
     4f8:	00008067          	ret
  for(n = 0; s[n]; n++)
     4fc:	00000513          	li	a0,0
     500:	ff1ff06f          	j	4f0 <strlen+0x34>

0000000000000504 <memset>:

void*
memset(void *dst, int c, uint n)
{
     504:	ff010113          	addi	sp,sp,-16
     508:	00813423          	sd	s0,8(sp)
     50c:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     510:	02060063          	beqz	a2,530 <memset+0x2c>
     514:	00050793          	mv	a5,a0
     518:	02061613          	slli	a2,a2,0x20
     51c:	02065613          	srli	a2,a2,0x20
     520:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     524:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     528:	00178793          	addi	a5,a5,1
     52c:	fee79ce3          	bne	a5,a4,524 <memset+0x20>
  }
  return dst;
}
     530:	00813403          	ld	s0,8(sp)
     534:	01010113          	addi	sp,sp,16
     538:	00008067          	ret

000000000000053c <strchr>:

char*
strchr(const char *s, char c)
{
     53c:	ff010113          	addi	sp,sp,-16
     540:	00813423          	sd	s0,8(sp)
     544:	01010413          	addi	s0,sp,16
  for(; *s; s++)
     548:	00054783          	lbu	a5,0(a0)
     54c:	02078263          	beqz	a5,570 <strchr+0x34>
    if(*s == c)
     550:	00f58a63          	beq	a1,a5,564 <strchr+0x28>
  for(; *s; s++)
     554:	00150513          	addi	a0,a0,1
     558:	00054783          	lbu	a5,0(a0)
     55c:	fe079ae3          	bnez	a5,550 <strchr+0x14>
      return (char*)s;
  return 0;
     560:	00000513          	li	a0,0
}
     564:	00813403          	ld	s0,8(sp)
     568:	01010113          	addi	sp,sp,16
     56c:	00008067          	ret
  return 0;
     570:	00000513          	li	a0,0
     574:	ff1ff06f          	j	564 <strchr+0x28>

0000000000000578 <gets>:

char*
gets(char *buf, int max)
{
     578:	fa010113          	addi	sp,sp,-96
     57c:	04113c23          	sd	ra,88(sp)
     580:	04813823          	sd	s0,80(sp)
     584:	04913423          	sd	s1,72(sp)
     588:	05213023          	sd	s2,64(sp)
     58c:	03313c23          	sd	s3,56(sp)
     590:	03413823          	sd	s4,48(sp)
     594:	03513423          	sd	s5,40(sp)
     598:	03613023          	sd	s6,32(sp)
     59c:	01713c23          	sd	s7,24(sp)
     5a0:	06010413          	addi	s0,sp,96
     5a4:	00050b93          	mv	s7,a0
     5a8:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     5ac:	00050913          	mv	s2,a0
     5b0:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     5b4:	00a00a93          	li	s5,10
     5b8:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
     5bc:	00048993          	mv	s3,s1
     5c0:	0014849b          	addiw	s1,s1,1
     5c4:	0344dc63          	bge	s1,s4,5fc <gets+0x84>
    cc = read(0, &c, 1);
     5c8:	00100613          	li	a2,1
     5cc:	faf40593          	addi	a1,s0,-81
     5d0:	00000513          	li	a0,0
     5d4:	254000ef          	jal	828 <read>
    if(cc < 1)
     5d8:	02a05263          	blez	a0,5fc <gets+0x84>
    buf[i++] = c;
     5dc:	faf44783          	lbu	a5,-81(s0)
     5e0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     5e4:	01578a63          	beq	a5,s5,5f8 <gets+0x80>
     5e8:	00190913          	addi	s2,s2,1
     5ec:	fd6798e3          	bne	a5,s6,5bc <gets+0x44>
    buf[i++] = c;
     5f0:	00048993          	mv	s3,s1
     5f4:	0080006f          	j	5fc <gets+0x84>
     5f8:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     5fc:	013b89b3          	add	s3,s7,s3
     600:	00098023          	sb	zero,0(s3)
  return buf;
}
     604:	000b8513          	mv	a0,s7
     608:	05813083          	ld	ra,88(sp)
     60c:	05013403          	ld	s0,80(sp)
     610:	04813483          	ld	s1,72(sp)
     614:	04013903          	ld	s2,64(sp)
     618:	03813983          	ld	s3,56(sp)
     61c:	03013a03          	ld	s4,48(sp)
     620:	02813a83          	ld	s5,40(sp)
     624:	02013b03          	ld	s6,32(sp)
     628:	01813b83          	ld	s7,24(sp)
     62c:	06010113          	addi	sp,sp,96
     630:	00008067          	ret

0000000000000634 <stat>:

int
stat(const char *n, struct stat *st)
{
     634:	fe010113          	addi	sp,sp,-32
     638:	00113c23          	sd	ra,24(sp)
     63c:	00813823          	sd	s0,16(sp)
     640:	01213023          	sd	s2,0(sp)
     644:	02010413          	addi	s0,sp,32
     648:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     64c:	00000593          	li	a1,0
     650:	214000ef          	jal	864 <open>
  if(fd < 0)
     654:	02054e63          	bltz	a0,690 <stat+0x5c>
     658:	00913423          	sd	s1,8(sp)
     65c:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     660:	00090593          	mv	a1,s2
     664:	224000ef          	jal	888 <fstat>
     668:	00050913          	mv	s2,a0
  close(fd);
     66c:	00048513          	mv	a0,s1
     670:	1d0000ef          	jal	840 <close>
  return r;
     674:	00813483          	ld	s1,8(sp)
}
     678:	00090513          	mv	a0,s2
     67c:	01813083          	ld	ra,24(sp)
     680:	01013403          	ld	s0,16(sp)
     684:	00013903          	ld	s2,0(sp)
     688:	02010113          	addi	sp,sp,32
     68c:	00008067          	ret
    return -1;
     690:	fff00913          	li	s2,-1
     694:	fe5ff06f          	j	678 <stat+0x44>

0000000000000698 <atoi>:

int
atoi(const char *s)
{
     698:	ff010113          	addi	sp,sp,-16
     69c:	00813423          	sd	s0,8(sp)
     6a0:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     6a4:	00054683          	lbu	a3,0(a0)
     6a8:	fd06879b          	addiw	a5,a3,-48
     6ac:	0ff7f793          	zext.b	a5,a5
     6b0:	00900613          	li	a2,9
     6b4:	04f66063          	bltu	a2,a5,6f4 <atoi+0x5c>
     6b8:	00050713          	mv	a4,a0
  n = 0;
     6bc:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
     6c0:	00170713          	addi	a4,a4,1
     6c4:	0025179b          	slliw	a5,a0,0x2
     6c8:	00a787bb          	addw	a5,a5,a0
     6cc:	0017979b          	slliw	a5,a5,0x1
     6d0:	00d787bb          	addw	a5,a5,a3
     6d4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     6d8:	00074683          	lbu	a3,0(a4)
     6dc:	fd06879b          	addiw	a5,a3,-48
     6e0:	0ff7f793          	zext.b	a5,a5
     6e4:	fcf67ee3          	bgeu	a2,a5,6c0 <atoi+0x28>
  return n;
}
     6e8:	00813403          	ld	s0,8(sp)
     6ec:	01010113          	addi	sp,sp,16
     6f0:	00008067          	ret
  n = 0;
     6f4:	00000513          	li	a0,0
     6f8:	ff1ff06f          	j	6e8 <atoi+0x50>

00000000000006fc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     6fc:	ff010113          	addi	sp,sp,-16
     700:	00813423          	sd	s0,8(sp)
     704:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     708:	02b57c63          	bgeu	a0,a1,740 <memmove+0x44>
    while(n-- > 0)
     70c:	02c05463          	blez	a2,734 <memmove+0x38>
     710:	02061613          	slli	a2,a2,0x20
     714:	02065613          	srli	a2,a2,0x20
     718:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     71c:	00050713          	mv	a4,a0
      *dst++ = *src++;
     720:	00158593          	addi	a1,a1,1
     724:	00170713          	addi	a4,a4,1
     728:	fff5c683          	lbu	a3,-1(a1)
     72c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     730:	fef718e3          	bne	a4,a5,720 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     734:	00813403          	ld	s0,8(sp)
     738:	01010113          	addi	sp,sp,16
     73c:	00008067          	ret
    dst += n;
     740:	00c50733          	add	a4,a0,a2
    src += n;
     744:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
     748:	fec056e3          	blez	a2,734 <memmove+0x38>
     74c:	fff6079b          	addiw	a5,a2,-1
     750:	02079793          	slli	a5,a5,0x20
     754:	0207d793          	srli	a5,a5,0x20
     758:	fff7c793          	not	a5,a5
     75c:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
     760:	fff58593          	addi	a1,a1,-1
     764:	fff70713          	addi	a4,a4,-1
     768:	0005c683          	lbu	a3,0(a1)
     76c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     770:	fee798e3          	bne	a5,a4,760 <memmove+0x64>
     774:	fc1ff06f          	j	734 <memmove+0x38>

0000000000000778 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     778:	ff010113          	addi	sp,sp,-16
     77c:	00813423          	sd	s0,8(sp)
     780:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     784:	04060463          	beqz	a2,7cc <memcmp+0x54>
     788:	fff6069b          	addiw	a3,a2,-1
     78c:	02069693          	slli	a3,a3,0x20
     790:	0206d693          	srli	a3,a3,0x20
     794:	00168693          	addi	a3,a3,1
     798:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
     79c:	00054783          	lbu	a5,0(a0)
     7a0:	0005c703          	lbu	a4,0(a1)
     7a4:	00e79c63          	bne	a5,a4,7bc <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
     7a8:	00150513          	addi	a0,a0,1
    p2++;
     7ac:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
     7b0:	fed516e3          	bne	a0,a3,79c <memcmp+0x24>
  }
  return 0;
     7b4:	00000513          	li	a0,0
     7b8:	0080006f          	j	7c0 <memcmp+0x48>
      return *p1 - *p2;
     7bc:	40e7853b          	subw	a0,a5,a4
}
     7c0:	00813403          	ld	s0,8(sp)
     7c4:	01010113          	addi	sp,sp,16
     7c8:	00008067          	ret
  return 0;
     7cc:	00000513          	li	a0,0
     7d0:	ff1ff06f          	j	7c0 <memcmp+0x48>

00000000000007d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     7d4:	ff010113          	addi	sp,sp,-16
     7d8:	00113423          	sd	ra,8(sp)
     7dc:	00813023          	sd	s0,0(sp)
     7e0:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
     7e4:	f19ff0ef          	jal	6fc <memmove>
}
     7e8:	00813083          	ld	ra,8(sp)
     7ec:	00013403          	ld	s0,0(sp)
     7f0:	01010113          	addi	sp,sp,16
     7f4:	00008067          	ret

00000000000007f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     7f8:	00100893          	li	a7,1
 ecall
     7fc:	00000073          	ecall
 ret
     800:	00008067          	ret

0000000000000804 <exit>:
.global exit
exit:
 li a7, SYS_exit
     804:	00200893          	li	a7,2
 ecall
     808:	00000073          	ecall
 ret
     80c:	00008067          	ret

0000000000000810 <wait>:
.global wait
wait:
 li a7, SYS_wait
     810:	00300893          	li	a7,3
 ecall
     814:	00000073          	ecall
 ret
     818:	00008067          	ret

000000000000081c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     81c:	00400893          	li	a7,4
 ecall
     820:	00000073          	ecall
 ret
     824:	00008067          	ret

0000000000000828 <read>:
.global read
read:
 li a7, SYS_read
     828:	00500893          	li	a7,5
 ecall
     82c:	00000073          	ecall
 ret
     830:	00008067          	ret

0000000000000834 <write>:
.global write
write:
 li a7, SYS_write
     834:	01000893          	li	a7,16
 ecall
     838:	00000073          	ecall
 ret
     83c:	00008067          	ret

0000000000000840 <close>:
.global close
close:
 li a7, SYS_close
     840:	01500893          	li	a7,21
 ecall
     844:	00000073          	ecall
 ret
     848:	00008067          	ret

000000000000084c <kill>:
.global kill
kill:
 li a7, SYS_kill
     84c:	00600893          	li	a7,6
 ecall
     850:	00000073          	ecall
 ret
     854:	00008067          	ret

0000000000000858 <exec>:
.global exec
exec:
 li a7, SYS_exec
     858:	00700893          	li	a7,7
 ecall
     85c:	00000073          	ecall
 ret
     860:	00008067          	ret

0000000000000864 <open>:
.global open
open:
 li a7, SYS_open
     864:	00f00893          	li	a7,15
 ecall
     868:	00000073          	ecall
 ret
     86c:	00008067          	ret

0000000000000870 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     870:	01100893          	li	a7,17
 ecall
     874:	00000073          	ecall
 ret
     878:	00008067          	ret

000000000000087c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     87c:	01200893          	li	a7,18
 ecall
     880:	00000073          	ecall
 ret
     884:	00008067          	ret

0000000000000888 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     888:	00800893          	li	a7,8
 ecall
     88c:	00000073          	ecall
 ret
     890:	00008067          	ret

0000000000000894 <link>:
.global link
link:
 li a7, SYS_link
     894:	01300893          	li	a7,19
 ecall
     898:	00000073          	ecall
 ret
     89c:	00008067          	ret

00000000000008a0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     8a0:	01400893          	li	a7,20
 ecall
     8a4:	00000073          	ecall
 ret
     8a8:	00008067          	ret

00000000000008ac <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     8ac:	00900893          	li	a7,9
 ecall
     8b0:	00000073          	ecall
 ret
     8b4:	00008067          	ret

00000000000008b8 <dup>:
.global dup
dup:
 li a7, SYS_dup
     8b8:	00a00893          	li	a7,10
 ecall
     8bc:	00000073          	ecall
 ret
     8c0:	00008067          	ret

00000000000008c4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     8c4:	00b00893          	li	a7,11
 ecall
     8c8:	00000073          	ecall
 ret
     8cc:	00008067          	ret

00000000000008d0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     8d0:	00c00893          	li	a7,12
 ecall
     8d4:	00000073          	ecall
 ret
     8d8:	00008067          	ret

00000000000008dc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     8dc:	00d00893          	li	a7,13
 ecall
     8e0:	00000073          	ecall
 ret
     8e4:	00008067          	ret

00000000000008e8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     8e8:	00e00893          	li	a7,14
 ecall
     8ec:	00000073          	ecall
 ret
     8f0:	00008067          	ret

00000000000008f4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     8f4:	fe010113          	addi	sp,sp,-32
     8f8:	00113c23          	sd	ra,24(sp)
     8fc:	00813823          	sd	s0,16(sp)
     900:	02010413          	addi	s0,sp,32
     904:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     908:	00100613          	li	a2,1
     90c:	fef40593          	addi	a1,s0,-17
     910:	f25ff0ef          	jal	834 <write>
}
     914:	01813083          	ld	ra,24(sp)
     918:	01013403          	ld	s0,16(sp)
     91c:	02010113          	addi	sp,sp,32
     920:	00008067          	ret

0000000000000924 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     924:	fc010113          	addi	sp,sp,-64
     928:	02113c23          	sd	ra,56(sp)
     92c:	02813823          	sd	s0,48(sp)
     930:	02913423          	sd	s1,40(sp)
     934:	04010413          	addi	s0,sp,64
     938:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     93c:	00068463          	beqz	a3,944 <printint+0x20>
     940:	0c05c263          	bltz	a1,a04 <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     944:	0005859b          	sext.w	a1,a1
  neg = 0;
     948:	00000893          	li	a7,0
     94c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     950:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
     954:	0006061b          	sext.w	a2,a2
     958:	00000517          	auipc	a0,0x0
     95c:	7a850513          	addi	a0,a0,1960 # 1100 <digits>
     960:	00070813          	mv	a6,a4
     964:	0017071b          	addiw	a4,a4,1
     968:	02c5f7bb          	remuw	a5,a1,a2
     96c:	02079793          	slli	a5,a5,0x20
     970:	0207d793          	srli	a5,a5,0x20
     974:	00f507b3          	add	a5,a0,a5
     978:	0007c783          	lbu	a5,0(a5)
     97c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     980:	0005879b          	sext.w	a5,a1
     984:	02c5d5bb          	divuw	a1,a1,a2
     988:	00168693          	addi	a3,a3,1
     98c:	fcc7fae3          	bgeu	a5,a2,960 <printint+0x3c>
  if(neg)
     990:	00088c63          	beqz	a7,9a8 <printint+0x84>
    buf[i++] = '-';
     994:	fd070793          	addi	a5,a4,-48
     998:	00878733          	add	a4,a5,s0
     99c:	02d00793          	li	a5,45
     9a0:	fef70823          	sb	a5,-16(a4)
     9a4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     9a8:	04e05463          	blez	a4,9f0 <printint+0xcc>
     9ac:	03213023          	sd	s2,32(sp)
     9b0:	01313c23          	sd	s3,24(sp)
     9b4:	fc040793          	addi	a5,s0,-64
     9b8:	00e78933          	add	s2,a5,a4
     9bc:	fff78993          	addi	s3,a5,-1
     9c0:	00e989b3          	add	s3,s3,a4
     9c4:	fff7071b          	addiw	a4,a4,-1
     9c8:	02071713          	slli	a4,a4,0x20
     9cc:	02075713          	srli	a4,a4,0x20
     9d0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     9d4:	fff94583          	lbu	a1,-1(s2)
     9d8:	00048513          	mv	a0,s1
     9dc:	f19ff0ef          	jal	8f4 <putc>
  while(--i >= 0)
     9e0:	fff90913          	addi	s2,s2,-1
     9e4:	ff3918e3          	bne	s2,s3,9d4 <printint+0xb0>
     9e8:	02013903          	ld	s2,32(sp)
     9ec:	01813983          	ld	s3,24(sp)
}
     9f0:	03813083          	ld	ra,56(sp)
     9f4:	03013403          	ld	s0,48(sp)
     9f8:	02813483          	ld	s1,40(sp)
     9fc:	04010113          	addi	sp,sp,64
     a00:	00008067          	ret
    x = -xx;
     a04:	40b005bb          	negw	a1,a1
    neg = 1;
     a08:	00100893          	li	a7,1
    x = -xx;
     a0c:	f41ff06f          	j	94c <printint+0x28>

0000000000000a10 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     a10:	fa010113          	addi	sp,sp,-96
     a14:	04113c23          	sd	ra,88(sp)
     a18:	04813823          	sd	s0,80(sp)
     a1c:	05213023          	sd	s2,64(sp)
     a20:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     a24:	0005c903          	lbu	s2,0(a1)
     a28:	36090463          	beqz	s2,d90 <vprintf+0x380>
     a2c:	04913423          	sd	s1,72(sp)
     a30:	03313c23          	sd	s3,56(sp)
     a34:	03413823          	sd	s4,48(sp)
     a38:	03513423          	sd	s5,40(sp)
     a3c:	03613023          	sd	s6,32(sp)
     a40:	01713c23          	sd	s7,24(sp)
     a44:	01813823          	sd	s8,16(sp)
     a48:	01913423          	sd	s9,8(sp)
     a4c:	00050b13          	mv	s6,a0
     a50:	00058a13          	mv	s4,a1
     a54:	00060b93          	mv	s7,a2
  state = 0;
     a58:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
     a5c:	00000493          	li	s1,0
     a60:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     a64:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     a68:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     a6c:	06c00c93          	li	s9,108
     a70:	02c0006f          	j	a9c <vprintf+0x8c>
        putc(fd, c0);
     a74:	00090593          	mv	a1,s2
     a78:	000b0513          	mv	a0,s6
     a7c:	e79ff0ef          	jal	8f4 <putc>
     a80:	0080006f          	j	a88 <vprintf+0x78>
    } else if(state == '%'){
     a84:	03598663          	beq	s3,s5,ab0 <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
     a88:	0014849b          	addiw	s1,s1,1
     a8c:	00048713          	mv	a4,s1
     a90:	009a07b3          	add	a5,s4,s1
     a94:	0007c903          	lbu	s2,0(a5)
     a98:	2c090c63          	beqz	s2,d70 <vprintf+0x360>
    c0 = fmt[i] & 0xff;
     a9c:	0009079b          	sext.w	a5,s2
    if(state == 0){
     aa0:	fe0992e3          	bnez	s3,a84 <vprintf+0x74>
      if(c0 == '%'){
     aa4:	fd5798e3          	bne	a5,s5,a74 <vprintf+0x64>
        state = '%';
     aa8:	00078993          	mv	s3,a5
     aac:	fddff06f          	j	a88 <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
     ab0:	00ea06b3          	add	a3,s4,a4
     ab4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     ab8:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     abc:	00068663          	beqz	a3,ac8 <vprintf+0xb8>
     ac0:	00ea0733          	add	a4,s4,a4
     ac4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     ac8:	05878263          	beq	a5,s8,b0c <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
     acc:	07978263          	beq	a5,s9,b30 <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     ad0:	07500713          	li	a4,117
     ad4:	12e78663          	beq	a5,a4,c00 <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     ad8:	07800713          	li	a4,120
     adc:	18e78c63          	beq	a5,a4,c74 <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     ae0:	07000713          	li	a4,112
     ae4:	1ce78e63          	beq	a5,a4,cc0 <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     ae8:	07300713          	li	a4,115
     aec:	22e78a63          	beq	a5,a4,d20 <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     af0:	02500713          	li	a4,37
     af4:	04e79e63          	bne	a5,a4,b50 <vprintf+0x140>
        putc(fd, '%');
     af8:	02500593          	li	a1,37
     afc:	000b0513          	mv	a0,s6
     b00:	df5ff0ef          	jal	8f4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     b04:	00000993          	li	s3,0
     b08:	f81ff06f          	j	a88 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
     b0c:	008b8913          	addi	s2,s7,8
     b10:	00100693          	li	a3,1
     b14:	00a00613          	li	a2,10
     b18:	000ba583          	lw	a1,0(s7)
     b1c:	000b0513          	mv	a0,s6
     b20:	e05ff0ef          	jal	924 <printint>
     b24:	00090b93          	mv	s7,s2
      state = 0;
     b28:	00000993          	li	s3,0
     b2c:	f5dff06f          	j	a88 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
     b30:	06400793          	li	a5,100
     b34:	02f68e63          	beq	a3,a5,b70 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     b38:	06c00793          	li	a5,108
     b3c:	04f68e63          	beq	a3,a5,b98 <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
     b40:	07500793          	li	a5,117
     b44:	0ef68063          	beq	a3,a5,c24 <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
     b48:	07800793          	li	a5,120
     b4c:	14f68663          	beq	a3,a5,c98 <vprintf+0x288>
        putc(fd, '%');
     b50:	02500593          	li	a1,37
     b54:	000b0513          	mv	a0,s6
     b58:	d9dff0ef          	jal	8f4 <putc>
        putc(fd, c0);
     b5c:	00090593          	mv	a1,s2
     b60:	000b0513          	mv	a0,s6
     b64:	d91ff0ef          	jal	8f4 <putc>
      state = 0;
     b68:	00000993          	li	s3,0
     b6c:	f1dff06f          	j	a88 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
     b70:	008b8913          	addi	s2,s7,8
     b74:	00100693          	li	a3,1
     b78:	00a00613          	li	a2,10
     b7c:	000ba583          	lw	a1,0(s7)
     b80:	000b0513          	mv	a0,s6
     b84:	da1ff0ef          	jal	924 <printint>
        i += 1;
     b88:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     b8c:	00090b93          	mv	s7,s2
      state = 0;
     b90:	00000993          	li	s3,0
        i += 1;
     b94:	ef5ff06f          	j	a88 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     b98:	06400793          	li	a5,100
     b9c:	02f60e63          	beq	a2,a5,bd8 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     ba0:	07500793          	li	a5,117
     ba4:	0af60463          	beq	a2,a5,c4c <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     ba8:	07800793          	li	a5,120
     bac:	faf612e3          	bne	a2,a5,b50 <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
     bb0:	008b8913          	addi	s2,s7,8
     bb4:	00000693          	li	a3,0
     bb8:	01000613          	li	a2,16
     bbc:	000ba583          	lw	a1,0(s7)
     bc0:	000b0513          	mv	a0,s6
     bc4:	d61ff0ef          	jal	924 <printint>
        i += 2;
     bc8:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     bcc:	00090b93          	mv	s7,s2
      state = 0;
     bd0:	00000993          	li	s3,0
        i += 2;
     bd4:	eb5ff06f          	j	a88 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
     bd8:	008b8913          	addi	s2,s7,8
     bdc:	00100693          	li	a3,1
     be0:	00a00613          	li	a2,10
     be4:	000ba583          	lw	a1,0(s7)
     be8:	000b0513          	mv	a0,s6
     bec:	d39ff0ef          	jal	924 <printint>
        i += 2;
     bf0:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     bf4:	00090b93          	mv	s7,s2
      state = 0;
     bf8:	00000993          	li	s3,0
        i += 2;
     bfc:	e8dff06f          	j	a88 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
     c00:	008b8913          	addi	s2,s7,8
     c04:	00000693          	li	a3,0
     c08:	00a00613          	li	a2,10
     c0c:	000ba583          	lw	a1,0(s7)
     c10:	000b0513          	mv	a0,s6
     c14:	d11ff0ef          	jal	924 <printint>
     c18:	00090b93          	mv	s7,s2
      state = 0;
     c1c:	00000993          	li	s3,0
     c20:	e69ff06f          	j	a88 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
     c24:	008b8913          	addi	s2,s7,8
     c28:	00000693          	li	a3,0
     c2c:	00a00613          	li	a2,10
     c30:	000ba583          	lw	a1,0(s7)
     c34:	000b0513          	mv	a0,s6
     c38:	cedff0ef          	jal	924 <printint>
        i += 1;
     c3c:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     c40:	00090b93          	mv	s7,s2
      state = 0;
     c44:	00000993          	li	s3,0
        i += 1;
     c48:	e41ff06f          	j	a88 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
     c4c:	008b8913          	addi	s2,s7,8
     c50:	00000693          	li	a3,0
     c54:	00a00613          	li	a2,10
     c58:	000ba583          	lw	a1,0(s7)
     c5c:	000b0513          	mv	a0,s6
     c60:	cc5ff0ef          	jal	924 <printint>
        i += 2;
     c64:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     c68:	00090b93          	mv	s7,s2
      state = 0;
     c6c:	00000993          	li	s3,0
        i += 2;
     c70:	e19ff06f          	j	a88 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
     c74:	008b8913          	addi	s2,s7,8
     c78:	00000693          	li	a3,0
     c7c:	01000613          	li	a2,16
     c80:	000ba583          	lw	a1,0(s7)
     c84:	000b0513          	mv	a0,s6
     c88:	c9dff0ef          	jal	924 <printint>
     c8c:	00090b93          	mv	s7,s2
      state = 0;
     c90:	00000993          	li	s3,0
     c94:	df5ff06f          	j	a88 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
     c98:	008b8913          	addi	s2,s7,8
     c9c:	00000693          	li	a3,0
     ca0:	01000613          	li	a2,16
     ca4:	000ba583          	lw	a1,0(s7)
     ca8:	000b0513          	mv	a0,s6
     cac:	c79ff0ef          	jal	924 <printint>
        i += 1;
     cb0:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     cb4:	00090b93          	mv	s7,s2
      state = 0;
     cb8:	00000993          	li	s3,0
        i += 1;
     cbc:	dcdff06f          	j	a88 <vprintf+0x78>
     cc0:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     cc4:	008b8d13          	addi	s10,s7,8
     cc8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     ccc:	03000593          	li	a1,48
     cd0:	000b0513          	mv	a0,s6
     cd4:	c21ff0ef          	jal	8f4 <putc>
  putc(fd, 'x');
     cd8:	07800593          	li	a1,120
     cdc:	000b0513          	mv	a0,s6
     ce0:	c15ff0ef          	jal	8f4 <putc>
     ce4:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     ce8:	00000b97          	auipc	s7,0x0
     cec:	418b8b93          	addi	s7,s7,1048 # 1100 <digits>
     cf0:	03c9d793          	srli	a5,s3,0x3c
     cf4:	00fb87b3          	add	a5,s7,a5
     cf8:	0007c583          	lbu	a1,0(a5)
     cfc:	000b0513          	mv	a0,s6
     d00:	bf5ff0ef          	jal	8f4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     d04:	00499993          	slli	s3,s3,0x4
     d08:	fff9091b          	addiw	s2,s2,-1
     d0c:	fe0912e3          	bnez	s2,cf0 <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
     d10:	000d0b93          	mv	s7,s10
      state = 0;
     d14:	00000993          	li	s3,0
     d18:	00013d03          	ld	s10,0(sp)
     d1c:	d6dff06f          	j	a88 <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
     d20:	008b8993          	addi	s3,s7,8
     d24:	000bb903          	ld	s2,0(s7)
     d28:	02090663          	beqz	s2,d54 <vprintf+0x344>
        for(; *s; s++)
     d2c:	00094583          	lbu	a1,0(s2)
     d30:	02058a63          	beqz	a1,d64 <vprintf+0x354>
          putc(fd, *s);
     d34:	000b0513          	mv	a0,s6
     d38:	bbdff0ef          	jal	8f4 <putc>
        for(; *s; s++)
     d3c:	00190913          	addi	s2,s2,1
     d40:	00094583          	lbu	a1,0(s2)
     d44:	fe0598e3          	bnez	a1,d34 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
     d48:	00098b93          	mv	s7,s3
      state = 0;
     d4c:	00000993          	li	s3,0
     d50:	d39ff06f          	j	a88 <vprintf+0x78>
          s = "(null)";
     d54:	00000917          	auipc	s2,0x0
     d58:	3a490913          	addi	s2,s2,932 # 10f8 <malloc+0x210>
        for(; *s; s++)
     d5c:	02800593          	li	a1,40
     d60:	fd5ff06f          	j	d34 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
     d64:	00098b93          	mv	s7,s3
      state = 0;
     d68:	00000993          	li	s3,0
     d6c:	d1dff06f          	j	a88 <vprintf+0x78>
     d70:	04813483          	ld	s1,72(sp)
     d74:	03813983          	ld	s3,56(sp)
     d78:	03013a03          	ld	s4,48(sp)
     d7c:	02813a83          	ld	s5,40(sp)
     d80:	02013b03          	ld	s6,32(sp)
     d84:	01813b83          	ld	s7,24(sp)
     d88:	01013c03          	ld	s8,16(sp)
     d8c:	00813c83          	ld	s9,8(sp)
    }
  }
}
     d90:	05813083          	ld	ra,88(sp)
     d94:	05013403          	ld	s0,80(sp)
     d98:	04013903          	ld	s2,64(sp)
     d9c:	06010113          	addi	sp,sp,96
     da0:	00008067          	ret

0000000000000da4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     da4:	fb010113          	addi	sp,sp,-80
     da8:	00113c23          	sd	ra,24(sp)
     dac:	00813823          	sd	s0,16(sp)
     db0:	02010413          	addi	s0,sp,32
     db4:	00c43023          	sd	a2,0(s0)
     db8:	00d43423          	sd	a3,8(s0)
     dbc:	00e43823          	sd	a4,16(s0)
     dc0:	00f43c23          	sd	a5,24(s0)
     dc4:	03043023          	sd	a6,32(s0)
     dc8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     dcc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     dd0:	00040613          	mv	a2,s0
     dd4:	c3dff0ef          	jal	a10 <vprintf>
}
     dd8:	01813083          	ld	ra,24(sp)
     ddc:	01013403          	ld	s0,16(sp)
     de0:	05010113          	addi	sp,sp,80
     de4:	00008067          	ret

0000000000000de8 <printf>:

void
printf(const char *fmt, ...)
{
     de8:	fa010113          	addi	sp,sp,-96
     dec:	00113c23          	sd	ra,24(sp)
     df0:	00813823          	sd	s0,16(sp)
     df4:	02010413          	addi	s0,sp,32
     df8:	00b43423          	sd	a1,8(s0)
     dfc:	00c43823          	sd	a2,16(s0)
     e00:	00d43c23          	sd	a3,24(s0)
     e04:	02e43023          	sd	a4,32(s0)
     e08:	02f43423          	sd	a5,40(s0)
     e0c:	03043823          	sd	a6,48(s0)
     e10:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     e14:	00840613          	addi	a2,s0,8
     e18:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     e1c:	00050593          	mv	a1,a0
     e20:	00100513          	li	a0,1
     e24:	bedff0ef          	jal	a10 <vprintf>
}
     e28:	01813083          	ld	ra,24(sp)
     e2c:	01013403          	ld	s0,16(sp)
     e30:	06010113          	addi	sp,sp,96
     e34:	00008067          	ret

0000000000000e38 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     e38:	ff010113          	addi	sp,sp,-16
     e3c:	00813423          	sd	s0,8(sp)
     e40:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     e44:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e48:	00001797          	auipc	a5,0x1
     e4c:	1b87b783          	ld	a5,440(a5) # 2000 <freep>
     e50:	0400006f          	j	e90 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     e54:	00862703          	lw	a4,8(a2)
     e58:	00b7073b          	addw	a4,a4,a1
     e5c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     e60:	0007b703          	ld	a4,0(a5)
     e64:	00073603          	ld	a2,0(a4)
     e68:	0500006f          	j	eb8 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     e6c:	ff852703          	lw	a4,-8(a0)
     e70:	00c7073b          	addw	a4,a4,a2
     e74:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     e78:	ff053683          	ld	a3,-16(a0)
     e7c:	0540006f          	j	ed0 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     e80:	0007b703          	ld	a4,0(a5)
     e84:	00e7e463          	bltu	a5,a4,e8c <free+0x54>
     e88:	00e6ec63          	bltu	a3,a4,ea0 <free+0x68>
{
     e8c:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e90:	fed7f8e3          	bgeu	a5,a3,e80 <free+0x48>
     e94:	0007b703          	ld	a4,0(a5)
     e98:	00e6e463          	bltu	a3,a4,ea0 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     e9c:	fee7e8e3          	bltu	a5,a4,e8c <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
     ea0:	ff852583          	lw	a1,-8(a0)
     ea4:	0007b603          	ld	a2,0(a5)
     ea8:	02059813          	slli	a6,a1,0x20
     eac:	01c85713          	srli	a4,a6,0x1c
     eb0:	00e68733          	add	a4,a3,a4
     eb4:	fae600e3          	beq	a2,a4,e54 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
     eb8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     ebc:	0087a603          	lw	a2,8(a5)
     ec0:	02061593          	slli	a1,a2,0x20
     ec4:	01c5d713          	srli	a4,a1,0x1c
     ec8:	00e78733          	add	a4,a5,a4
     ecc:	fae680e3          	beq	a3,a4,e6c <free+0x34>
    p->s.ptr = bp->s.ptr;
     ed0:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     ed4:	00001717          	auipc	a4,0x1
     ed8:	12f73623          	sd	a5,300(a4) # 2000 <freep>
}
     edc:	00813403          	ld	s0,8(sp)
     ee0:	01010113          	addi	sp,sp,16
     ee4:	00008067          	ret

0000000000000ee8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     ee8:	fc010113          	addi	sp,sp,-64
     eec:	02113c23          	sd	ra,56(sp)
     ef0:	02813823          	sd	s0,48(sp)
     ef4:	02913423          	sd	s1,40(sp)
     ef8:	01313c23          	sd	s3,24(sp)
     efc:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f00:	02051493          	slli	s1,a0,0x20
     f04:	0204d493          	srli	s1,s1,0x20
     f08:	00f48493          	addi	s1,s1,15
     f0c:	0044d493          	srli	s1,s1,0x4
     f10:	0014899b          	addiw	s3,s1,1
     f14:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
     f18:	00001517          	auipc	a0,0x1
     f1c:	0e853503          	ld	a0,232(a0) # 2000 <freep>
     f20:	04050663          	beqz	a0,f6c <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     f24:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
     f28:	0087a703          	lw	a4,8(a5)
     f2c:	0c977c63          	bgeu	a4,s1,1004 <malloc+0x11c>
     f30:	03213023          	sd	s2,32(sp)
     f34:	01413823          	sd	s4,16(sp)
     f38:	01513423          	sd	s5,8(sp)
     f3c:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
     f40:	00098a13          	mv	s4,s3
     f44:	0009871b          	sext.w	a4,s3
     f48:	000016b7          	lui	a3,0x1
     f4c:	00d77463          	bgeu	a4,a3,f54 <malloc+0x6c>
     f50:	00001a37          	lui	s4,0x1
     f54:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     f58:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     f5c:	00001917          	auipc	s2,0x1
     f60:	0a490913          	addi	s2,s2,164 # 2000 <freep>
  if(p == (char*)-1)
     f64:	fff00a93          	li	s5,-1
     f68:	05c0006f          	j	fc4 <malloc+0xdc>
     f6c:	03213023          	sd	s2,32(sp)
     f70:	01413823          	sd	s4,16(sp)
     f74:	01513423          	sd	s5,8(sp)
     f78:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
     f7c:	00001797          	auipc	a5,0x1
     f80:	09478793          	addi	a5,a5,148 # 2010 <base>
     f84:	00001717          	auipc	a4,0x1
     f88:	06f73e23          	sd	a5,124(a4) # 2000 <freep>
     f8c:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
     f90:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
     f94:	fadff06f          	j	f40 <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
     f98:	0007b703          	ld	a4,0(a5)
     f9c:	00e53023          	sd	a4,0(a0)
     fa0:	0800006f          	j	1020 <malloc+0x138>
  hp->s.size = nu;
     fa4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
     fa8:	01050513          	addi	a0,a0,16
     fac:	e8dff0ef          	jal	e38 <free>
  return freep;
     fb0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
     fb4:	08050863          	beqz	a0,1044 <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fb8:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
     fbc:	0087a703          	lw	a4,8(a5)
     fc0:	02977a63          	bgeu	a4,s1,ff4 <malloc+0x10c>
    if(p == freep)
     fc4:	00093703          	ld	a4,0(s2)
     fc8:	00078513          	mv	a0,a5
     fcc:	fef716e3          	bne	a4,a5,fb8 <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
     fd0:	000a0513          	mv	a0,s4
     fd4:	8fdff0ef          	jal	8d0 <sbrk>
  if(p == (char*)-1)
     fd8:	fd5516e3          	bne	a0,s5,fa4 <malloc+0xbc>
        return 0;
     fdc:	00000513          	li	a0,0
     fe0:	02013903          	ld	s2,32(sp)
     fe4:	01013a03          	ld	s4,16(sp)
     fe8:	00813a83          	ld	s5,8(sp)
     fec:	00013b03          	ld	s6,0(sp)
     ff0:	03c0006f          	j	102c <malloc+0x144>
     ff4:	02013903          	ld	s2,32(sp)
     ff8:	01013a03          	ld	s4,16(sp)
     ffc:	00813a83          	ld	s5,8(sp)
    1000:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
    1004:	f8e48ae3          	beq	s1,a4,f98 <malloc+0xb0>
        p->s.size -= nunits;
    1008:	4137073b          	subw	a4,a4,s3
    100c:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
    1010:	02071693          	slli	a3,a4,0x20
    1014:	01c6d713          	srli	a4,a3,0x1c
    1018:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
    101c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1020:	00001717          	auipc	a4,0x1
    1024:	fea73023          	sd	a0,-32(a4) # 2000 <freep>
      return (void*)(p + 1);
    1028:	01078513          	addi	a0,a5,16
  }
}
    102c:	03813083          	ld	ra,56(sp)
    1030:	03013403          	ld	s0,48(sp)
    1034:	02813483          	ld	s1,40(sp)
    1038:	01813983          	ld	s3,24(sp)
    103c:	04010113          	addi	sp,sp,64
    1040:	00008067          	ret
    1044:	02013903          	ld	s2,32(sp)
    1048:	01013a03          	ld	s4,16(sp)
    104c:	00813a83          	ld	s5,8(sp)
    1050:	00013b03          	ld	s6,0(sp)
    1054:	fd9ff06f          	j	102c <malloc+0x144>
