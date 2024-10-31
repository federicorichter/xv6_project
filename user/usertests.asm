
user/_usertests:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	fa010113          	addi	sp,sp,-96
       4:	04113c23          	sd	ra,88(sp)
       8:	04813823          	sd	s0,80(sp)
       c:	04913423          	sd	s1,72(sp)
      10:	05213023          	sd	s2,64(sp)
      14:	03313c23          	sd	s3,56(sp)
      18:	06010413          	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
      1c:	00009797          	auipc	a5,0x9
      20:	bcc78793          	addi	a5,a5,-1076 # 8be8 <malloc+0x2508>
      24:	0007b583          	ld	a1,0(a5)
      28:	0087b603          	ld	a2,8(a5)
      2c:	0107b683          	ld	a3,16(a5)
      30:	0187b703          	ld	a4,24(a5)
      34:	0207b783          	ld	a5,32(a5)
      38:	fab43423          	sd	a1,-88(s0)
      3c:	fac43823          	sd	a2,-80(s0)
      40:	fad43c23          	sd	a3,-72(s0)
      44:	fce43023          	sd	a4,-64(s0)
      48:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      4c:	fa840493          	addi	s1,s0,-88
      50:	fd040993          	addi	s3,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      54:	0004b903          	ld	s2,0(s1)
      58:	20100593          	li	a1,513
      5c:	00090513          	mv	a0,s2
      60:	7fd050ef          	jal	605c <open>
    if(fd >= 0){
      64:	02055463          	bgez	a0,8c <copyinstr1+0x8c>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      68:	00848493          	addi	s1,s1,8
      6c:	ff3494e3          	bne	s1,s3,54 <copyinstr1+0x54>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      70:	05813083          	ld	ra,88(sp)
      74:	05013403          	ld	s0,80(sp)
      78:	04813483          	ld	s1,72(sp)
      7c:	04013903          	ld	s2,64(sp)
      80:	03813983          	ld	s3,56(sp)
      84:	06010113          	addi	sp,sp,96
      88:	00008067          	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      8c:	00050613          	mv	a2,a0
      90:	00090593          	mv	a1,s2
      94:	00006517          	auipc	a0,0x6
      98:	7bc50513          	addi	a0,a0,1980 # 6850 <malloc+0x170>
      9c:	544060ef          	jal	65e0 <printf>
      exit(1);
      a0:	00100513          	li	a0,1
      a4:	759050ef          	jal	5ffc <exit>

00000000000000a8 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      a8:	0000a797          	auipc	a5,0xa
      ac:	4c078793          	addi	a5,a5,1216 # a568 <uninit>
      b0:	0000d697          	auipc	a3,0xd
      b4:	bc868693          	addi	a3,a3,-1080 # cc78 <buf>
    if(uninit[i] != '\0'){
      b8:	0007c703          	lbu	a4,0(a5)
      bc:	00071863          	bnez	a4,cc <bsstest+0x24>
  for(i = 0; i < sizeof(uninit); i++){
      c0:	00178793          	addi	a5,a5,1
      c4:	fed79ae3          	bne	a5,a3,b8 <bsstest+0x10>
      c8:	00008067          	ret
{
      cc:	ff010113          	addi	sp,sp,-16
      d0:	00113423          	sd	ra,8(sp)
      d4:	00813023          	sd	s0,0(sp)
      d8:	01010413          	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      dc:	00050593          	mv	a1,a0
      e0:	00006517          	auipc	a0,0x6
      e4:	79050513          	addi	a0,a0,1936 # 6870 <malloc+0x190>
      e8:	4f8060ef          	jal	65e0 <printf>
      exit(1);
      ec:	00100513          	li	a0,1
      f0:	70d050ef          	jal	5ffc <exit>

00000000000000f4 <opentest>:
{
      f4:	fe010113          	addi	sp,sp,-32
      f8:	00113c23          	sd	ra,24(sp)
      fc:	00813823          	sd	s0,16(sp)
     100:	00913423          	sd	s1,8(sp)
     104:	02010413          	addi	s0,sp,32
     108:	00050493          	mv	s1,a0
  fd = open("echo", 0);
     10c:	00000593          	li	a1,0
     110:	00006517          	auipc	a0,0x6
     114:	77850513          	addi	a0,a0,1912 # 6888 <malloc+0x1a8>
     118:	745050ef          	jal	605c <open>
  if(fd < 0){
     11c:	02054863          	bltz	a0,14c <opentest+0x58>
  close(fd);
     120:	719050ef          	jal	6038 <close>
  fd = open("doesnotexist", 0);
     124:	00000593          	li	a1,0
     128:	00006517          	auipc	a0,0x6
     12c:	78050513          	addi	a0,a0,1920 # 68a8 <malloc+0x1c8>
     130:	72d050ef          	jal	605c <open>
  if(fd >= 0){
     134:	02055863          	bgez	a0,164 <opentest+0x70>
}
     138:	01813083          	ld	ra,24(sp)
     13c:	01013403          	ld	s0,16(sp)
     140:	00813483          	ld	s1,8(sp)
     144:	02010113          	addi	sp,sp,32
     148:	00008067          	ret
    printf("%s: open echo failed!\n", s);
     14c:	00048593          	mv	a1,s1
     150:	00006517          	auipc	a0,0x6
     154:	74050513          	addi	a0,a0,1856 # 6890 <malloc+0x1b0>
     158:	488060ef          	jal	65e0 <printf>
    exit(1);
     15c:	00100513          	li	a0,1
     160:	69d050ef          	jal	5ffc <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     164:	00048593          	mv	a1,s1
     168:	00006517          	auipc	a0,0x6
     16c:	75050513          	addi	a0,a0,1872 # 68b8 <malloc+0x1d8>
     170:	470060ef          	jal	65e0 <printf>
    exit(1);
     174:	00100513          	li	a0,1
     178:	685050ef          	jal	5ffc <exit>

000000000000017c <truncate2>:
{
     17c:	fd010113          	addi	sp,sp,-48
     180:	02113423          	sd	ra,40(sp)
     184:	02813023          	sd	s0,32(sp)
     188:	00913c23          	sd	s1,24(sp)
     18c:	01213823          	sd	s2,16(sp)
     190:	01313423          	sd	s3,8(sp)
     194:	03010413          	addi	s0,sp,48
     198:	00050993          	mv	s3,a0
  unlink("truncfile");
     19c:	00006517          	auipc	a0,0x6
     1a0:	74450513          	addi	a0,a0,1860 # 68e0 <malloc+0x200>
     1a4:	6d1050ef          	jal	6074 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     1a8:	60100593          	li	a1,1537
     1ac:	00006517          	auipc	a0,0x6
     1b0:	73450513          	addi	a0,a0,1844 # 68e0 <malloc+0x200>
     1b4:	6a9050ef          	jal	605c <open>
     1b8:	00050493          	mv	s1,a0
  write(fd1, "abcd", 4);
     1bc:	00400613          	li	a2,4
     1c0:	00006597          	auipc	a1,0x6
     1c4:	73058593          	addi	a1,a1,1840 # 68f0 <malloc+0x210>
     1c8:	665050ef          	jal	602c <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     1cc:	40100593          	li	a1,1025
     1d0:	00006517          	auipc	a0,0x6
     1d4:	71050513          	addi	a0,a0,1808 # 68e0 <malloc+0x200>
     1d8:	685050ef          	jal	605c <open>
     1dc:	00050913          	mv	s2,a0
  int n = write(fd1, "x", 1);
     1e0:	00100613          	li	a2,1
     1e4:	00006597          	auipc	a1,0x6
     1e8:	71458593          	addi	a1,a1,1812 # 68f8 <malloc+0x218>
     1ec:	00048513          	mv	a0,s1
     1f0:	63d050ef          	jal	602c <write>
  if(n != -1){
     1f4:	fff00793          	li	a5,-1
     1f8:	02f51e63          	bne	a0,a5,234 <truncate2+0xb8>
  unlink("truncfile");
     1fc:	00006517          	auipc	a0,0x6
     200:	6e450513          	addi	a0,a0,1764 # 68e0 <malloc+0x200>
     204:	671050ef          	jal	6074 <unlink>
  close(fd1);
     208:	00048513          	mv	a0,s1
     20c:	62d050ef          	jal	6038 <close>
  close(fd2);
     210:	00090513          	mv	a0,s2
     214:	625050ef          	jal	6038 <close>
}
     218:	02813083          	ld	ra,40(sp)
     21c:	02013403          	ld	s0,32(sp)
     220:	01813483          	ld	s1,24(sp)
     224:	01013903          	ld	s2,16(sp)
     228:	00813983          	ld	s3,8(sp)
     22c:	03010113          	addi	sp,sp,48
     230:	00008067          	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     234:	00050613          	mv	a2,a0
     238:	00098593          	mv	a1,s3
     23c:	00006517          	auipc	a0,0x6
     240:	6c450513          	addi	a0,a0,1732 # 6900 <malloc+0x220>
     244:	39c060ef          	jal	65e0 <printf>
    exit(1);
     248:	00100513          	li	a0,1
     24c:	5b1050ef          	jal	5ffc <exit>

0000000000000250 <createtest>:
{
     250:	fd010113          	addi	sp,sp,-48
     254:	02113423          	sd	ra,40(sp)
     258:	02813023          	sd	s0,32(sp)
     25c:	00913c23          	sd	s1,24(sp)
     260:	01213823          	sd	s2,16(sp)
     264:	03010413          	addi	s0,sp,48
  name[0] = 'a';
     268:	06100793          	li	a5,97
     26c:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     270:	fc040d23          	sb	zero,-38(s0)
     274:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     278:	06400913          	li	s2,100
    name[1] = '0' + i;
     27c:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     280:	20200593          	li	a1,514
     284:	fd840513          	addi	a0,s0,-40
     288:	5d5050ef          	jal	605c <open>
    close(fd);
     28c:	5ad050ef          	jal	6038 <close>
  for(i = 0; i < N; i++){
     290:	0014849b          	addiw	s1,s1,1
     294:	0ff4f493          	zext.b	s1,s1
     298:	ff2492e3          	bne	s1,s2,27c <createtest+0x2c>
  name[0] = 'a';
     29c:	06100793          	li	a5,97
     2a0:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     2a4:	fc040d23          	sb	zero,-38(s0)
     2a8:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     2ac:	06400913          	li	s2,100
    name[1] = '0' + i;
     2b0:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     2b4:	fd840513          	addi	a0,s0,-40
     2b8:	5bd050ef          	jal	6074 <unlink>
  for(i = 0; i < N; i++){
     2bc:	0014849b          	addiw	s1,s1,1
     2c0:	0ff4f493          	zext.b	s1,s1
     2c4:	ff2496e3          	bne	s1,s2,2b0 <createtest+0x60>
}
     2c8:	02813083          	ld	ra,40(sp)
     2cc:	02013403          	ld	s0,32(sp)
     2d0:	01813483          	ld	s1,24(sp)
     2d4:	01013903          	ld	s2,16(sp)
     2d8:	03010113          	addi	sp,sp,48
     2dc:	00008067          	ret

00000000000002e0 <bigwrite>:
{
     2e0:	fb010113          	addi	sp,sp,-80
     2e4:	04113423          	sd	ra,72(sp)
     2e8:	04813023          	sd	s0,64(sp)
     2ec:	02913c23          	sd	s1,56(sp)
     2f0:	03213823          	sd	s2,48(sp)
     2f4:	03313423          	sd	s3,40(sp)
     2f8:	03413023          	sd	s4,32(sp)
     2fc:	01513c23          	sd	s5,24(sp)
     300:	01613823          	sd	s6,16(sp)
     304:	01713423          	sd	s7,8(sp)
     308:	05010413          	addi	s0,sp,80
     30c:	00050b93          	mv	s7,a0
  unlink("bigwrite");
     310:	00006517          	auipc	a0,0x6
     314:	61850513          	addi	a0,a0,1560 # 6928 <malloc+0x248>
     318:	55d050ef          	jal	6074 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     31c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     320:	00006a97          	auipc	s5,0x6
     324:	608a8a93          	addi	s5,s5,1544 # 6928 <malloc+0x248>
      int cc = write(fd, buf, sz);
     328:	0000da17          	auipc	s4,0xd
     32c:	950a0a13          	addi	s4,s4,-1712 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     330:	00003b37          	lui	s6,0x3
     334:	1c9b0b13          	addi	s6,s6,457 # 31c9 <execout+0x3d>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     338:	20200593          	li	a1,514
     33c:	000a8513          	mv	a0,s5
     340:	51d050ef          	jal	605c <open>
     344:	00050913          	mv	s2,a0
    if(fd < 0){
     348:	06054863          	bltz	a0,3b8 <bigwrite+0xd8>
      int cc = write(fd, buf, sz);
     34c:	00048613          	mv	a2,s1
     350:	000a0593          	mv	a1,s4
     354:	4d9050ef          	jal	602c <write>
     358:	00050993          	mv	s3,a0
      if(cc != sz){
     35c:	06a49a63          	bne	s1,a0,3d0 <bigwrite+0xf0>
      int cc = write(fd, buf, sz);
     360:	00048613          	mv	a2,s1
     364:	000a0593          	mv	a1,s4
     368:	00090513          	mv	a0,s2
     36c:	4c1050ef          	jal	602c <write>
      if(cc != sz){
     370:	06951263          	bne	a0,s1,3d4 <bigwrite+0xf4>
    close(fd);
     374:	00090513          	mv	a0,s2
     378:	4c1050ef          	jal	6038 <close>
    unlink("bigwrite");
     37c:	000a8513          	mv	a0,s5
     380:	4f5050ef          	jal	6074 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     384:	1d74849b          	addiw	s1,s1,471
     388:	fb6498e3          	bne	s1,s6,338 <bigwrite+0x58>
}
     38c:	04813083          	ld	ra,72(sp)
     390:	04013403          	ld	s0,64(sp)
     394:	03813483          	ld	s1,56(sp)
     398:	03013903          	ld	s2,48(sp)
     39c:	02813983          	ld	s3,40(sp)
     3a0:	02013a03          	ld	s4,32(sp)
     3a4:	01813a83          	ld	s5,24(sp)
     3a8:	01013b03          	ld	s6,16(sp)
     3ac:	00813b83          	ld	s7,8(sp)
     3b0:	05010113          	addi	sp,sp,80
     3b4:	00008067          	ret
      printf("%s: cannot create bigwrite\n", s);
     3b8:	000b8593          	mv	a1,s7
     3bc:	00006517          	auipc	a0,0x6
     3c0:	57c50513          	addi	a0,a0,1404 # 6938 <malloc+0x258>
     3c4:	21c060ef          	jal	65e0 <printf>
      exit(1);
     3c8:	00100513          	li	a0,1
     3cc:	431050ef          	jal	5ffc <exit>
      if(cc != sz){
     3d0:	00048993          	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     3d4:	00050693          	mv	a3,a0
     3d8:	00098613          	mv	a2,s3
     3dc:	000b8593          	mv	a1,s7
     3e0:	00006517          	auipc	a0,0x6
     3e4:	57850513          	addi	a0,a0,1400 # 6958 <malloc+0x278>
     3e8:	1f8060ef          	jal	65e0 <printf>
        exit(1);
     3ec:	00100513          	li	a0,1
     3f0:	40d050ef          	jal	5ffc <exit>

00000000000003f4 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     3f4:	fd010113          	addi	sp,sp,-48
     3f8:	02113423          	sd	ra,40(sp)
     3fc:	02813023          	sd	s0,32(sp)
     400:	00913c23          	sd	s1,24(sp)
     404:	01213823          	sd	s2,16(sp)
     408:	01313423          	sd	s3,8(sp)
     40c:	01413023          	sd	s4,0(sp)
     410:	03010413          	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     414:	00006517          	auipc	a0,0x6
     418:	55c50513          	addi	a0,a0,1372 # 6970 <malloc+0x290>
     41c:	459050ef          	jal	6074 <unlink>
     420:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     424:	00006997          	auipc	s3,0x6
     428:	54c98993          	addi	s3,s3,1356 # 6970 <malloc+0x290>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     42c:	fff00a13          	li	s4,-1
     430:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     434:	20100593          	li	a1,513
     438:	00098513          	mv	a0,s3
     43c:	421050ef          	jal	605c <open>
     440:	00050493          	mv	s1,a0
    if(fd < 0){
     444:	06054663          	bltz	a0,4b0 <badwrite+0xbc>
    write(fd, (char*)0xffffffffffL, 1);
     448:	00100613          	li	a2,1
     44c:	000a0593          	mv	a1,s4
     450:	3dd050ef          	jal	602c <write>
    close(fd);
     454:	00048513          	mv	a0,s1
     458:	3e1050ef          	jal	6038 <close>
    unlink("junk");
     45c:	00098513          	mv	a0,s3
     460:	415050ef          	jal	6074 <unlink>
  for(int i = 0; i < assumed_free; i++){
     464:	fff9091b          	addiw	s2,s2,-1
     468:	fc0916e3          	bnez	s2,434 <badwrite+0x40>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     46c:	20100593          	li	a1,513
     470:	00006517          	auipc	a0,0x6
     474:	50050513          	addi	a0,a0,1280 # 6970 <malloc+0x290>
     478:	3e5050ef          	jal	605c <open>
     47c:	00050493          	mv	s1,a0
  if(fd < 0){
     480:	04054263          	bltz	a0,4c4 <badwrite+0xd0>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     484:	00100613          	li	a2,1
     488:	00006597          	auipc	a1,0x6
     48c:	47058593          	addi	a1,a1,1136 # 68f8 <malloc+0x218>
     490:	39d050ef          	jal	602c <write>
     494:	00100793          	li	a5,1
     498:	04f50063          	beq	a0,a5,4d8 <badwrite+0xe4>
    printf("write failed\n");
     49c:	00006517          	auipc	a0,0x6
     4a0:	4f450513          	addi	a0,a0,1268 # 6990 <malloc+0x2b0>
     4a4:	13c060ef          	jal	65e0 <printf>
    exit(1);
     4a8:	00100513          	li	a0,1
     4ac:	351050ef          	jal	5ffc <exit>
      printf("open junk failed\n");
     4b0:	00006517          	auipc	a0,0x6
     4b4:	4c850513          	addi	a0,a0,1224 # 6978 <malloc+0x298>
     4b8:	128060ef          	jal	65e0 <printf>
      exit(1);
     4bc:	00100513          	li	a0,1
     4c0:	33d050ef          	jal	5ffc <exit>
    printf("open junk failed\n");
     4c4:	00006517          	auipc	a0,0x6
     4c8:	4b450513          	addi	a0,a0,1204 # 6978 <malloc+0x298>
     4cc:	114060ef          	jal	65e0 <printf>
    exit(1);
     4d0:	00100513          	li	a0,1
     4d4:	329050ef          	jal	5ffc <exit>
  }
  close(fd);
     4d8:	00048513          	mv	a0,s1
     4dc:	35d050ef          	jal	6038 <close>
  unlink("junk");
     4e0:	00006517          	auipc	a0,0x6
     4e4:	49050513          	addi	a0,a0,1168 # 6970 <malloc+0x290>
     4e8:	38d050ef          	jal	6074 <unlink>

  exit(0);
     4ec:	00000513          	li	a0,0
     4f0:	30d050ef          	jal	5ffc <exit>

00000000000004f4 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     4f4:	fb010113          	addi	sp,sp,-80
     4f8:	04113423          	sd	ra,72(sp)
     4fc:	04813023          	sd	s0,64(sp)
     500:	02913c23          	sd	s1,56(sp)
     504:	03213823          	sd	s2,48(sp)
     508:	03313423          	sd	s3,40(sp)
     50c:	05010413          	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     510:	00000493          	li	s1,0
    char name[32];
    name[0] = 'z';
     514:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     518:	40000993          	li	s3,1024
    name[0] = 'z';
     51c:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     520:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     524:	41f4d71b          	sraiw	a4,s1,0x1f
     528:	01b7571b          	srliw	a4,a4,0x1b
     52c:	009707bb          	addw	a5,a4,s1
     530:	4057d69b          	sraiw	a3,a5,0x5
     534:	0306869b          	addiw	a3,a3,48
     538:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     53c:	01f7f793          	andi	a5,a5,31
     540:	40e787bb          	subw	a5,a5,a4
     544:	0307879b          	addiw	a5,a5,48
     548:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     54c:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     550:	fb040513          	addi	a0,s0,-80
     554:	321050ef          	jal	6074 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     558:	60200593          	li	a1,1538
     55c:	fb040513          	addi	a0,s0,-80
     560:	2fd050ef          	jal	605c <open>
    if(fd < 0){
     564:	00054863          	bltz	a0,574 <outofinodes+0x80>
      // failure is eventually expected.
      break;
    }
    close(fd);
     568:	2d1050ef          	jal	6038 <close>
  for(int i = 0; i < nzz; i++){
     56c:	0014849b          	addiw	s1,s1,1
     570:	fb3496e3          	bne	s1,s3,51c <outofinodes+0x28>
     574:	00000493          	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     578:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     57c:	40000993          	li	s3,1024
    name[0] = 'z';
     580:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     584:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     588:	41f4d71b          	sraiw	a4,s1,0x1f
     58c:	01b7571b          	srliw	a4,a4,0x1b
     590:	009707bb          	addw	a5,a4,s1
     594:	4057d69b          	sraiw	a3,a5,0x5
     598:	0306869b          	addiw	a3,a3,48
     59c:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     5a0:	01f7f793          	andi	a5,a5,31
     5a4:	40e787bb          	subw	a5,a5,a4
     5a8:	0307879b          	addiw	a5,a5,48
     5ac:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     5b0:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     5b4:	fb040513          	addi	a0,s0,-80
     5b8:	2bd050ef          	jal	6074 <unlink>
  for(int i = 0; i < nzz; i++){
     5bc:	0014849b          	addiw	s1,s1,1
     5c0:	fd3490e3          	bne	s1,s3,580 <outofinodes+0x8c>
  }
}
     5c4:	04813083          	ld	ra,72(sp)
     5c8:	04013403          	ld	s0,64(sp)
     5cc:	03813483          	ld	s1,56(sp)
     5d0:	03013903          	ld	s2,48(sp)
     5d4:	02813983          	ld	s3,40(sp)
     5d8:	05010113          	addi	sp,sp,80
     5dc:	00008067          	ret

00000000000005e0 <copyin>:
{
     5e0:	f9010113          	addi	sp,sp,-112
     5e4:	06113423          	sd	ra,104(sp)
     5e8:	06813023          	sd	s0,96(sp)
     5ec:	04913c23          	sd	s1,88(sp)
     5f0:	05213823          	sd	s2,80(sp)
     5f4:	05313423          	sd	s3,72(sp)
     5f8:	05413023          	sd	s4,64(sp)
     5fc:	03513c23          	sd	s5,56(sp)
     600:	07010413          	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     604:	00008797          	auipc	a5,0x8
     608:	5e478793          	addi	a5,a5,1508 # 8be8 <malloc+0x2508>
     60c:	0007b583          	ld	a1,0(a5)
     610:	0087b603          	ld	a2,8(a5)
     614:	0107b683          	ld	a3,16(a5)
     618:	0187b703          	ld	a4,24(a5)
     61c:	0207b783          	ld	a5,32(a5)
     620:	f8b43c23          	sd	a1,-104(s0)
     624:	fac43023          	sd	a2,-96(s0)
     628:	fad43423          	sd	a3,-88(s0)
     62c:	fae43823          	sd	a4,-80(s0)
     630:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     634:	f9840913          	addi	s2,s0,-104
     638:	fc040a93          	addi	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     63c:	00006a17          	auipc	s4,0x6
     640:	364a0a13          	addi	s4,s4,868 # 69a0 <malloc+0x2c0>
    uint64 addr = addrs[ai];
     644:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     648:	20100593          	li	a1,513
     64c:	000a0513          	mv	a0,s4
     650:	20d050ef          	jal	605c <open>
     654:	00050493          	mv	s1,a0
    if(fd < 0){
     658:	08054a63          	bltz	a0,6ec <copyin+0x10c>
    int n = write(fd, (void*)addr, 8192);
     65c:	00002637          	lui	a2,0x2
     660:	00098593          	mv	a1,s3
     664:	1c9050ef          	jal	602c <write>
    if(n >= 0){
     668:	08055c63          	bgez	a0,700 <copyin+0x120>
    close(fd);
     66c:	00048513          	mv	a0,s1
     670:	1c9050ef          	jal	6038 <close>
    unlink("copyin1");
     674:	000a0513          	mv	a0,s4
     678:	1fd050ef          	jal	6074 <unlink>
    n = write(1, (char*)addr, 8192);
     67c:	00002637          	lui	a2,0x2
     680:	00098593          	mv	a1,s3
     684:	00100513          	li	a0,1
     688:	1a5050ef          	jal	602c <write>
    if(n > 0){
     68c:	08a04863          	bgtz	a0,71c <copyin+0x13c>
    if(pipe(fds) < 0){
     690:	f9040513          	addi	a0,s0,-112
     694:	181050ef          	jal	6014 <pipe>
     698:	0a054063          	bltz	a0,738 <copyin+0x158>
    n = write(fds[1], (char*)addr, 8192);
     69c:	00002637          	lui	a2,0x2
     6a0:	00098593          	mv	a1,s3
     6a4:	f9442503          	lw	a0,-108(s0)
     6a8:	185050ef          	jal	602c <write>
    if(n > 0){
     6ac:	0aa04063          	bgtz	a0,74c <copyin+0x16c>
    close(fds[0]);
     6b0:	f9042503          	lw	a0,-112(s0)
     6b4:	185050ef          	jal	6038 <close>
    close(fds[1]);
     6b8:	f9442503          	lw	a0,-108(s0)
     6bc:	17d050ef          	jal	6038 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     6c0:	00890913          	addi	s2,s2,8
     6c4:	f95910e3          	bne	s2,s5,644 <copyin+0x64>
}
     6c8:	06813083          	ld	ra,104(sp)
     6cc:	06013403          	ld	s0,96(sp)
     6d0:	05813483          	ld	s1,88(sp)
     6d4:	05013903          	ld	s2,80(sp)
     6d8:	04813983          	ld	s3,72(sp)
     6dc:	04013a03          	ld	s4,64(sp)
     6e0:	03813a83          	ld	s5,56(sp)
     6e4:	07010113          	addi	sp,sp,112
     6e8:	00008067          	ret
      printf("open(copyin1) failed\n");
     6ec:	00006517          	auipc	a0,0x6
     6f0:	2bc50513          	addi	a0,a0,700 # 69a8 <malloc+0x2c8>
     6f4:	6ed050ef          	jal	65e0 <printf>
      exit(1);
     6f8:	00100513          	li	a0,1
     6fc:	101050ef          	jal	5ffc <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     700:	00050613          	mv	a2,a0
     704:	00098593          	mv	a1,s3
     708:	00006517          	auipc	a0,0x6
     70c:	2b850513          	addi	a0,a0,696 # 69c0 <malloc+0x2e0>
     710:	6d1050ef          	jal	65e0 <printf>
      exit(1);
     714:	00100513          	li	a0,1
     718:	0e5050ef          	jal	5ffc <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     71c:	00050613          	mv	a2,a0
     720:	00098593          	mv	a1,s3
     724:	00006517          	auipc	a0,0x6
     728:	2cc50513          	addi	a0,a0,716 # 69f0 <malloc+0x310>
     72c:	6b5050ef          	jal	65e0 <printf>
      exit(1);
     730:	00100513          	li	a0,1
     734:	0c9050ef          	jal	5ffc <exit>
      printf("pipe() failed\n");
     738:	00006517          	auipc	a0,0x6
     73c:	2e850513          	addi	a0,a0,744 # 6a20 <malloc+0x340>
     740:	6a1050ef          	jal	65e0 <printf>
      exit(1);
     744:	00100513          	li	a0,1
     748:	0b5050ef          	jal	5ffc <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     74c:	00050613          	mv	a2,a0
     750:	00098593          	mv	a1,s3
     754:	00006517          	auipc	a0,0x6
     758:	2dc50513          	addi	a0,a0,732 # 6a30 <malloc+0x350>
     75c:	685050ef          	jal	65e0 <printf>
      exit(1);
     760:	00100513          	li	a0,1
     764:	099050ef          	jal	5ffc <exit>

0000000000000768 <copyout>:
{
     768:	f8010113          	addi	sp,sp,-128
     76c:	06113c23          	sd	ra,120(sp)
     770:	06813823          	sd	s0,112(sp)
     774:	06913423          	sd	s1,104(sp)
     778:	07213023          	sd	s2,96(sp)
     77c:	05313c23          	sd	s3,88(sp)
     780:	05413823          	sd	s4,80(sp)
     784:	05513423          	sd	s5,72(sp)
     788:	05613023          	sd	s6,64(sp)
     78c:	08010413          	addi	s0,sp,128
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     790:	00008797          	auipc	a5,0x8
     794:	45878793          	addi	a5,a5,1112 # 8be8 <malloc+0x2508>
     798:	0287b503          	ld	a0,40(a5)
     79c:	0307b583          	ld	a1,48(a5)
     7a0:	0387b603          	ld	a2,56(a5)
     7a4:	0407b683          	ld	a3,64(a5)
     7a8:	0487b703          	ld	a4,72(a5)
     7ac:	0507b783          	ld	a5,80(a5)
     7b0:	f8a43823          	sd	a0,-112(s0)
     7b4:	f8b43c23          	sd	a1,-104(s0)
     7b8:	fac43023          	sd	a2,-96(s0)
     7bc:	fad43423          	sd	a3,-88(s0)
     7c0:	fae43823          	sd	a4,-80(s0)
     7c4:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     7c8:	f9040913          	addi	s2,s0,-112
     7cc:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
     7d0:	00006a17          	auipc	s4,0x6
     7d4:	290a0a13          	addi	s4,s4,656 # 6a60 <malloc+0x380>
    n = write(fds[1], "x", 1);
     7d8:	00006a97          	auipc	s5,0x6
     7dc:	120a8a93          	addi	s5,s5,288 # 68f8 <malloc+0x218>
    uint64 addr = addrs[ai];
     7e0:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     7e4:	00000593          	li	a1,0
     7e8:	000a0513          	mv	a0,s4
     7ec:	071050ef          	jal	605c <open>
     7f0:	00050493          	mv	s1,a0
    if(fd < 0){
     7f4:	08054a63          	bltz	a0,888 <copyout+0x120>
    int n = read(fd, (void*)addr, 8192);
     7f8:	00002637          	lui	a2,0x2
     7fc:	00098593          	mv	a1,s3
     800:	021050ef          	jal	6020 <read>
    if(n > 0){
     804:	08a04c63          	bgtz	a0,89c <copyout+0x134>
    close(fd);
     808:	00048513          	mv	a0,s1
     80c:	02d050ef          	jal	6038 <close>
    if(pipe(fds) < 0){
     810:	f8840513          	addi	a0,s0,-120
     814:	001050ef          	jal	6014 <pipe>
     818:	0a054063          	bltz	a0,8b8 <copyout+0x150>
    n = write(fds[1], "x", 1);
     81c:	00100613          	li	a2,1
     820:	000a8593          	mv	a1,s5
     824:	f8c42503          	lw	a0,-116(s0)
     828:	005050ef          	jal	602c <write>
    if(n != 1){
     82c:	00100793          	li	a5,1
     830:	08f51e63          	bne	a0,a5,8cc <copyout+0x164>
    n = read(fds[0], (void*)addr, 8192);
     834:	00002637          	lui	a2,0x2
     838:	00098593          	mv	a1,s3
     83c:	f8842503          	lw	a0,-120(s0)
     840:	7e0050ef          	jal	6020 <read>
    if(n > 0){
     844:	08a04e63          	bgtz	a0,8e0 <copyout+0x178>
    close(fds[0]);
     848:	f8842503          	lw	a0,-120(s0)
     84c:	7ec050ef          	jal	6038 <close>
    close(fds[1]);
     850:	f8c42503          	lw	a0,-116(s0)
     854:	7e4050ef          	jal	6038 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     858:	00890913          	addi	s2,s2,8
     85c:	f96912e3          	bne	s2,s6,7e0 <copyout+0x78>
}
     860:	07813083          	ld	ra,120(sp)
     864:	07013403          	ld	s0,112(sp)
     868:	06813483          	ld	s1,104(sp)
     86c:	06013903          	ld	s2,96(sp)
     870:	05813983          	ld	s3,88(sp)
     874:	05013a03          	ld	s4,80(sp)
     878:	04813a83          	ld	s5,72(sp)
     87c:	04013b03          	ld	s6,64(sp)
     880:	08010113          	addi	sp,sp,128
     884:	00008067          	ret
      printf("open(README) failed\n");
     888:	00006517          	auipc	a0,0x6
     88c:	1e050513          	addi	a0,a0,480 # 6a68 <malloc+0x388>
     890:	551050ef          	jal	65e0 <printf>
      exit(1);
     894:	00100513          	li	a0,1
     898:	764050ef          	jal	5ffc <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     89c:	00050613          	mv	a2,a0
     8a0:	00098593          	mv	a1,s3
     8a4:	00006517          	auipc	a0,0x6
     8a8:	1dc50513          	addi	a0,a0,476 # 6a80 <malloc+0x3a0>
     8ac:	535050ef          	jal	65e0 <printf>
      exit(1);
     8b0:	00100513          	li	a0,1
     8b4:	748050ef          	jal	5ffc <exit>
      printf("pipe() failed\n");
     8b8:	00006517          	auipc	a0,0x6
     8bc:	16850513          	addi	a0,a0,360 # 6a20 <malloc+0x340>
     8c0:	521050ef          	jal	65e0 <printf>
      exit(1);
     8c4:	00100513          	li	a0,1
     8c8:	734050ef          	jal	5ffc <exit>
      printf("pipe write failed\n");
     8cc:	00006517          	auipc	a0,0x6
     8d0:	1e450513          	addi	a0,a0,484 # 6ab0 <malloc+0x3d0>
     8d4:	50d050ef          	jal	65e0 <printf>
      exit(1);
     8d8:	00100513          	li	a0,1
     8dc:	720050ef          	jal	5ffc <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     8e0:	00050613          	mv	a2,a0
     8e4:	00098593          	mv	a1,s3
     8e8:	00006517          	auipc	a0,0x6
     8ec:	1e050513          	addi	a0,a0,480 # 6ac8 <malloc+0x3e8>
     8f0:	4f1050ef          	jal	65e0 <printf>
      exit(1);
     8f4:	00100513          	li	a0,1
     8f8:	704050ef          	jal	5ffc <exit>

00000000000008fc <truncate1>:
{
     8fc:	fa010113          	addi	sp,sp,-96
     900:	04113c23          	sd	ra,88(sp)
     904:	04813823          	sd	s0,80(sp)
     908:	04913423          	sd	s1,72(sp)
     90c:	05213023          	sd	s2,64(sp)
     910:	03313c23          	sd	s3,56(sp)
     914:	03413823          	sd	s4,48(sp)
     918:	03513423          	sd	s5,40(sp)
     91c:	06010413          	addi	s0,sp,96
     920:	00050a93          	mv	s5,a0
  unlink("truncfile");
     924:	00006517          	auipc	a0,0x6
     928:	fbc50513          	addi	a0,a0,-68 # 68e0 <malloc+0x200>
     92c:	748050ef          	jal	6074 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     930:	60100593          	li	a1,1537
     934:	00006517          	auipc	a0,0x6
     938:	fac50513          	addi	a0,a0,-84 # 68e0 <malloc+0x200>
     93c:	720050ef          	jal	605c <open>
     940:	00050493          	mv	s1,a0
  write(fd1, "abcd", 4);
     944:	00400613          	li	a2,4
     948:	00006597          	auipc	a1,0x6
     94c:	fa858593          	addi	a1,a1,-88 # 68f0 <malloc+0x210>
     950:	6dc050ef          	jal	602c <write>
  close(fd1);
     954:	00048513          	mv	a0,s1
     958:	6e0050ef          	jal	6038 <close>
  int fd2 = open("truncfile", O_RDONLY);
     95c:	00000593          	li	a1,0
     960:	00006517          	auipc	a0,0x6
     964:	f8050513          	addi	a0,a0,-128 # 68e0 <malloc+0x200>
     968:	6f4050ef          	jal	605c <open>
     96c:	00050493          	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     970:	02000613          	li	a2,32
     974:	fa040593          	addi	a1,s0,-96
     978:	6a8050ef          	jal	6020 <read>
  if(n != 4){
     97c:	00400793          	li	a5,4
     980:	0ef51263          	bne	a0,a5,a64 <truncate1+0x168>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     984:	40100593          	li	a1,1025
     988:	00006517          	auipc	a0,0x6
     98c:	f5850513          	addi	a0,a0,-168 # 68e0 <malloc+0x200>
     990:	6cc050ef          	jal	605c <open>
     994:	00050993          	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     998:	00000593          	li	a1,0
     99c:	00006517          	auipc	a0,0x6
     9a0:	f4450513          	addi	a0,a0,-188 # 68e0 <malloc+0x200>
     9a4:	6b8050ef          	jal	605c <open>
     9a8:	00050913          	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     9ac:	02000613          	li	a2,32
     9b0:	fa040593          	addi	a1,s0,-96
     9b4:	66c050ef          	jal	6020 <read>
     9b8:	00050a13          	mv	s4,a0
  if(n != 0){
     9bc:	0c051263          	bnez	a0,a80 <truncate1+0x184>
  n = read(fd2, buf, sizeof(buf));
     9c0:	02000613          	li	a2,32
     9c4:	fa040593          	addi	a1,s0,-96
     9c8:	00048513          	mv	a0,s1
     9cc:	654050ef          	jal	6020 <read>
     9d0:	00050a13          	mv	s4,a0
  if(n != 0){
     9d4:	0c051c63          	bnez	a0,aac <truncate1+0x1b0>
  write(fd1, "abcdef", 6);
     9d8:	00600613          	li	a2,6
     9dc:	00006597          	auipc	a1,0x6
     9e0:	17c58593          	addi	a1,a1,380 # 6b58 <malloc+0x478>
     9e4:	00098513          	mv	a0,s3
     9e8:	644050ef          	jal	602c <write>
  n = read(fd3, buf, sizeof(buf));
     9ec:	02000613          	li	a2,32
     9f0:	fa040593          	addi	a1,s0,-96
     9f4:	00090513          	mv	a0,s2
     9f8:	628050ef          	jal	6020 <read>
  if(n != 6){
     9fc:	00600793          	li	a5,6
     a00:	0cf51c63          	bne	a0,a5,ad8 <truncate1+0x1dc>
  n = read(fd2, buf, sizeof(buf));
     a04:	02000613          	li	a2,32
     a08:	fa040593          	addi	a1,s0,-96
     a0c:	00048513          	mv	a0,s1
     a10:	610050ef          	jal	6020 <read>
  if(n != 2){
     a14:	00200793          	li	a5,2
     a18:	0cf51e63          	bne	a0,a5,af4 <truncate1+0x1f8>
  unlink("truncfile");
     a1c:	00006517          	auipc	a0,0x6
     a20:	ec450513          	addi	a0,a0,-316 # 68e0 <malloc+0x200>
     a24:	650050ef          	jal	6074 <unlink>
  close(fd1);
     a28:	00098513          	mv	a0,s3
     a2c:	60c050ef          	jal	6038 <close>
  close(fd2);
     a30:	00048513          	mv	a0,s1
     a34:	604050ef          	jal	6038 <close>
  close(fd3);
     a38:	00090513          	mv	a0,s2
     a3c:	5fc050ef          	jal	6038 <close>
}
     a40:	05813083          	ld	ra,88(sp)
     a44:	05013403          	ld	s0,80(sp)
     a48:	04813483          	ld	s1,72(sp)
     a4c:	04013903          	ld	s2,64(sp)
     a50:	03813983          	ld	s3,56(sp)
     a54:	03013a03          	ld	s4,48(sp)
     a58:	02813a83          	ld	s5,40(sp)
     a5c:	06010113          	addi	sp,sp,96
     a60:	00008067          	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     a64:	00050613          	mv	a2,a0
     a68:	000a8593          	mv	a1,s5
     a6c:	00006517          	auipc	a0,0x6
     a70:	08c50513          	addi	a0,a0,140 # 6af8 <malloc+0x418>
     a74:	36d050ef          	jal	65e0 <printf>
    exit(1);
     a78:	00100513          	li	a0,1
     a7c:	580050ef          	jal	5ffc <exit>
    printf("aaa fd3=%d\n", fd3);
     a80:	00090593          	mv	a1,s2
     a84:	00006517          	auipc	a0,0x6
     a88:	09450513          	addi	a0,a0,148 # 6b18 <malloc+0x438>
     a8c:	355050ef          	jal	65e0 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     a90:	000a0613          	mv	a2,s4
     a94:	000a8593          	mv	a1,s5
     a98:	00006517          	auipc	a0,0x6
     a9c:	09050513          	addi	a0,a0,144 # 6b28 <malloc+0x448>
     aa0:	341050ef          	jal	65e0 <printf>
    exit(1);
     aa4:	00100513          	li	a0,1
     aa8:	554050ef          	jal	5ffc <exit>
    printf("bbb fd2=%d\n", fd2);
     aac:	00048593          	mv	a1,s1
     ab0:	00006517          	auipc	a0,0x6
     ab4:	09850513          	addi	a0,a0,152 # 6b48 <malloc+0x468>
     ab8:	329050ef          	jal	65e0 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     abc:	000a0613          	mv	a2,s4
     ac0:	000a8593          	mv	a1,s5
     ac4:	00006517          	auipc	a0,0x6
     ac8:	06450513          	addi	a0,a0,100 # 6b28 <malloc+0x448>
     acc:	315050ef          	jal	65e0 <printf>
    exit(1);
     ad0:	00100513          	li	a0,1
     ad4:	528050ef          	jal	5ffc <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     ad8:	00050613          	mv	a2,a0
     adc:	000a8593          	mv	a1,s5
     ae0:	00006517          	auipc	a0,0x6
     ae4:	08050513          	addi	a0,a0,128 # 6b60 <malloc+0x480>
     ae8:	2f9050ef          	jal	65e0 <printf>
    exit(1);
     aec:	00100513          	li	a0,1
     af0:	50c050ef          	jal	5ffc <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     af4:	00050613          	mv	a2,a0
     af8:	000a8593          	mv	a1,s5
     afc:	00006517          	auipc	a0,0x6
     b00:	08450513          	addi	a0,a0,132 # 6b80 <malloc+0x4a0>
     b04:	2dd050ef          	jal	65e0 <printf>
    exit(1);
     b08:	00100513          	li	a0,1
     b0c:	4f0050ef          	jal	5ffc <exit>

0000000000000b10 <writetest>:
{
     b10:	fc010113          	addi	sp,sp,-64
     b14:	02113c23          	sd	ra,56(sp)
     b18:	02813823          	sd	s0,48(sp)
     b1c:	02913423          	sd	s1,40(sp)
     b20:	03213023          	sd	s2,32(sp)
     b24:	01313c23          	sd	s3,24(sp)
     b28:	01413823          	sd	s4,16(sp)
     b2c:	01513423          	sd	s5,8(sp)
     b30:	01613023          	sd	s6,0(sp)
     b34:	04010413          	addi	s0,sp,64
     b38:	00050b13          	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     b3c:	20200593          	li	a1,514
     b40:	00006517          	auipc	a0,0x6
     b44:	06050513          	addi	a0,a0,96 # 6ba0 <malloc+0x4c0>
     b48:	514050ef          	jal	605c <open>
  if(fd < 0){
     b4c:	0c054863          	bltz	a0,c1c <writetest+0x10c>
     b50:	00050913          	mv	s2,a0
     b54:	00000493          	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     b58:	00006997          	auipc	s3,0x6
     b5c:	07098993          	addi	s3,s3,112 # 6bc8 <malloc+0x4e8>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     b60:	00006a97          	auipc	s5,0x6
     b64:	0a0a8a93          	addi	s5,s5,160 # 6c00 <malloc+0x520>
  for(i = 0; i < N; i++){
     b68:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     b6c:	00a00613          	li	a2,10
     b70:	00098593          	mv	a1,s3
     b74:	00090513          	mv	a0,s2
     b78:	4b4050ef          	jal	602c <write>
     b7c:	00a00793          	li	a5,10
     b80:	0af51a63          	bne	a0,a5,c34 <writetest+0x124>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     b84:	00a00613          	li	a2,10
     b88:	000a8593          	mv	a1,s5
     b8c:	00090513          	mv	a0,s2
     b90:	49c050ef          	jal	602c <write>
     b94:	00a00793          	li	a5,10
     b98:	0af51c63          	bne	a0,a5,c50 <writetest+0x140>
  for(i = 0; i < N; i++){
     b9c:	0014849b          	addiw	s1,s1,1
     ba0:	fd4496e3          	bne	s1,s4,b6c <writetest+0x5c>
  close(fd);
     ba4:	00090513          	mv	a0,s2
     ba8:	490050ef          	jal	6038 <close>
  fd = open("small", O_RDONLY);
     bac:	00000593          	li	a1,0
     bb0:	00006517          	auipc	a0,0x6
     bb4:	ff050513          	addi	a0,a0,-16 # 6ba0 <malloc+0x4c0>
     bb8:	4a4050ef          	jal	605c <open>
     bbc:	00050493          	mv	s1,a0
  if(fd < 0){
     bc0:	0a054663          	bltz	a0,c6c <writetest+0x15c>
  i = read(fd, buf, N*SZ*2);
     bc4:	7d000613          	li	a2,2000
     bc8:	0000c597          	auipc	a1,0xc
     bcc:	0b058593          	addi	a1,a1,176 # cc78 <buf>
     bd0:	450050ef          	jal	6020 <read>
  if(i != N*SZ*2){
     bd4:	7d000793          	li	a5,2000
     bd8:	0af51663          	bne	a0,a5,c84 <writetest+0x174>
  close(fd);
     bdc:	00048513          	mv	a0,s1
     be0:	458050ef          	jal	6038 <close>
  if(unlink("small") < 0){
     be4:	00006517          	auipc	a0,0x6
     be8:	fbc50513          	addi	a0,a0,-68 # 6ba0 <malloc+0x4c0>
     bec:	488050ef          	jal	6074 <unlink>
     bf0:	0a054663          	bltz	a0,c9c <writetest+0x18c>
}
     bf4:	03813083          	ld	ra,56(sp)
     bf8:	03013403          	ld	s0,48(sp)
     bfc:	02813483          	ld	s1,40(sp)
     c00:	02013903          	ld	s2,32(sp)
     c04:	01813983          	ld	s3,24(sp)
     c08:	01013a03          	ld	s4,16(sp)
     c0c:	00813a83          	ld	s5,8(sp)
     c10:	00013b03          	ld	s6,0(sp)
     c14:	04010113          	addi	sp,sp,64
     c18:	00008067          	ret
    printf("%s: error: creat small failed!\n", s);
     c1c:	000b0593          	mv	a1,s6
     c20:	00006517          	auipc	a0,0x6
     c24:	f8850513          	addi	a0,a0,-120 # 6ba8 <malloc+0x4c8>
     c28:	1b9050ef          	jal	65e0 <printf>
    exit(1);
     c2c:	00100513          	li	a0,1
     c30:	3cc050ef          	jal	5ffc <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     c34:	00048613          	mv	a2,s1
     c38:	000b0593          	mv	a1,s6
     c3c:	00006517          	auipc	a0,0x6
     c40:	f9c50513          	addi	a0,a0,-100 # 6bd8 <malloc+0x4f8>
     c44:	19d050ef          	jal	65e0 <printf>
      exit(1);
     c48:	00100513          	li	a0,1
     c4c:	3b0050ef          	jal	5ffc <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     c50:	00048613          	mv	a2,s1
     c54:	000b0593          	mv	a1,s6
     c58:	00006517          	auipc	a0,0x6
     c5c:	fb850513          	addi	a0,a0,-72 # 6c10 <malloc+0x530>
     c60:	181050ef          	jal	65e0 <printf>
      exit(1);
     c64:	00100513          	li	a0,1
     c68:	394050ef          	jal	5ffc <exit>
    printf("%s: error: open small failed!\n", s);
     c6c:	000b0593          	mv	a1,s6
     c70:	00006517          	auipc	a0,0x6
     c74:	fc850513          	addi	a0,a0,-56 # 6c38 <malloc+0x558>
     c78:	169050ef          	jal	65e0 <printf>
    exit(1);
     c7c:	00100513          	li	a0,1
     c80:	37c050ef          	jal	5ffc <exit>
    printf("%s: read failed\n", s);
     c84:	000b0593          	mv	a1,s6
     c88:	00006517          	auipc	a0,0x6
     c8c:	fd050513          	addi	a0,a0,-48 # 6c58 <malloc+0x578>
     c90:	151050ef          	jal	65e0 <printf>
    exit(1);
     c94:	00100513          	li	a0,1
     c98:	364050ef          	jal	5ffc <exit>
    printf("%s: unlink small failed\n", s);
     c9c:	000b0593          	mv	a1,s6
     ca0:	00006517          	auipc	a0,0x6
     ca4:	fd050513          	addi	a0,a0,-48 # 6c70 <malloc+0x590>
     ca8:	139050ef          	jal	65e0 <printf>
    exit(1);
     cac:	00100513          	li	a0,1
     cb0:	34c050ef          	jal	5ffc <exit>

0000000000000cb4 <writebig>:
{
     cb4:	fc010113          	addi	sp,sp,-64
     cb8:	02113c23          	sd	ra,56(sp)
     cbc:	02813823          	sd	s0,48(sp)
     cc0:	02913423          	sd	s1,40(sp)
     cc4:	03213023          	sd	s2,32(sp)
     cc8:	01313c23          	sd	s3,24(sp)
     ccc:	01413823          	sd	s4,16(sp)
     cd0:	01513423          	sd	s5,8(sp)
     cd4:	04010413          	addi	s0,sp,64
     cd8:	00050a93          	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     cdc:	20200593          	li	a1,514
     ce0:	00006517          	auipc	a0,0x6
     ce4:	fb050513          	addi	a0,a0,-80 # 6c90 <malloc+0x5b0>
     ce8:	374050ef          	jal	605c <open>
     cec:	00050993          	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     cf0:	00000493          	li	s1,0
    ((int*)buf)[0] = i;
     cf4:	0000c917          	auipc	s2,0xc
     cf8:	f8490913          	addi	s2,s2,-124 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     cfc:	10c00a13          	li	s4,268
  if(fd < 0){
     d00:	08054063          	bltz	a0,d80 <writebig+0xcc>
    ((int*)buf)[0] = i;
     d04:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     d08:	40000613          	li	a2,1024
     d0c:	00090593          	mv	a1,s2
     d10:	00098513          	mv	a0,s3
     d14:	318050ef          	jal	602c <write>
     d18:	40000793          	li	a5,1024
     d1c:	06f51e63          	bne	a0,a5,d98 <writebig+0xe4>
  for(i = 0; i < MAXFILE; i++){
     d20:	0014849b          	addiw	s1,s1,1
     d24:	ff4490e3          	bne	s1,s4,d04 <writebig+0x50>
  close(fd);
     d28:	00098513          	mv	a0,s3
     d2c:	30c050ef          	jal	6038 <close>
  fd = open("big", O_RDONLY);
     d30:	00000593          	li	a1,0
     d34:	00006517          	auipc	a0,0x6
     d38:	f5c50513          	addi	a0,a0,-164 # 6c90 <malloc+0x5b0>
     d3c:	320050ef          	jal	605c <open>
     d40:	00050993          	mv	s3,a0
  n = 0;
     d44:	00000493          	li	s1,0
    i = read(fd, buf, BSIZE);
     d48:	0000c917          	auipc	s2,0xc
     d4c:	f3090913          	addi	s2,s2,-208 # cc78 <buf>
  if(fd < 0){
     d50:	06054263          	bltz	a0,db4 <writebig+0x100>
    i = read(fd, buf, BSIZE);
     d54:	40000613          	li	a2,1024
     d58:	00090593          	mv	a1,s2
     d5c:	00098513          	mv	a0,s3
     d60:	2c0050ef          	jal	6020 <read>
    if(i == 0){
     d64:	06050463          	beqz	a0,dcc <writebig+0x118>
    } else if(i != BSIZE){
     d68:	40000793          	li	a5,1024
     d6c:	0cf51063          	bne	a0,a5,e2c <writebig+0x178>
    if(((int*)buf)[0] != n){
     d70:	00092683          	lw	a3,0(s2)
     d74:	0c969a63          	bne	a3,s1,e48 <writebig+0x194>
    n++;
     d78:	0014849b          	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     d7c:	fd9ff06f          	j	d54 <writebig+0xa0>
    printf("%s: error: creat big failed!\n", s);
     d80:	000a8593          	mv	a1,s5
     d84:	00006517          	auipc	a0,0x6
     d88:	f1450513          	addi	a0,a0,-236 # 6c98 <malloc+0x5b8>
     d8c:	055050ef          	jal	65e0 <printf>
    exit(1);
     d90:	00100513          	li	a0,1
     d94:	268050ef          	jal	5ffc <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     d98:	00048613          	mv	a2,s1
     d9c:	000a8593          	mv	a1,s5
     da0:	00006517          	auipc	a0,0x6
     da4:	f1850513          	addi	a0,a0,-232 # 6cb8 <malloc+0x5d8>
     da8:	039050ef          	jal	65e0 <printf>
      exit(1);
     dac:	00100513          	li	a0,1
     db0:	24c050ef          	jal	5ffc <exit>
    printf("%s: error: open big failed!\n", s);
     db4:	000a8593          	mv	a1,s5
     db8:	00006517          	auipc	a0,0x6
     dbc:	f2850513          	addi	a0,a0,-216 # 6ce0 <malloc+0x600>
     dc0:	021050ef          	jal	65e0 <printf>
    exit(1);
     dc4:	00100513          	li	a0,1
     dc8:	234050ef          	jal	5ffc <exit>
      if(n != MAXFILE){
     dcc:	10c00793          	li	a5,268
     dd0:	04f49063          	bne	s1,a5,e10 <writebig+0x15c>
  close(fd);
     dd4:	00098513          	mv	a0,s3
     dd8:	260050ef          	jal	6038 <close>
  if(unlink("big") < 0){
     ddc:	00006517          	auipc	a0,0x6
     de0:	eb450513          	addi	a0,a0,-332 # 6c90 <malloc+0x5b0>
     de4:	290050ef          	jal	6074 <unlink>
     de8:	06054e63          	bltz	a0,e64 <writebig+0x1b0>
}
     dec:	03813083          	ld	ra,56(sp)
     df0:	03013403          	ld	s0,48(sp)
     df4:	02813483          	ld	s1,40(sp)
     df8:	02013903          	ld	s2,32(sp)
     dfc:	01813983          	ld	s3,24(sp)
     e00:	01013a03          	ld	s4,16(sp)
     e04:	00813a83          	ld	s5,8(sp)
     e08:	04010113          	addi	sp,sp,64
     e0c:	00008067          	ret
        printf("%s: read only %d blocks from big", s, n);
     e10:	00048613          	mv	a2,s1
     e14:	000a8593          	mv	a1,s5
     e18:	00006517          	auipc	a0,0x6
     e1c:	ee850513          	addi	a0,a0,-280 # 6d00 <malloc+0x620>
     e20:	7c0050ef          	jal	65e0 <printf>
        exit(1);
     e24:	00100513          	li	a0,1
     e28:	1d4050ef          	jal	5ffc <exit>
      printf("%s: read failed %d\n", s, i);
     e2c:	00050613          	mv	a2,a0
     e30:	000a8593          	mv	a1,s5
     e34:	00006517          	auipc	a0,0x6
     e38:	ef450513          	addi	a0,a0,-268 # 6d28 <malloc+0x648>
     e3c:	7a4050ef          	jal	65e0 <printf>
      exit(1);
     e40:	00100513          	li	a0,1
     e44:	1b8050ef          	jal	5ffc <exit>
      printf("%s: read content of block %d is %d\n", s,
     e48:	00048613          	mv	a2,s1
     e4c:	000a8593          	mv	a1,s5
     e50:	00006517          	auipc	a0,0x6
     e54:	ef050513          	addi	a0,a0,-272 # 6d40 <malloc+0x660>
     e58:	788050ef          	jal	65e0 <printf>
      exit(1);
     e5c:	00100513          	li	a0,1
     e60:	19c050ef          	jal	5ffc <exit>
    printf("%s: unlink big failed\n", s);
     e64:	000a8593          	mv	a1,s5
     e68:	00006517          	auipc	a0,0x6
     e6c:	f0050513          	addi	a0,a0,-256 # 6d68 <malloc+0x688>
     e70:	770050ef          	jal	65e0 <printf>
    exit(1);
     e74:	00100513          	li	a0,1
     e78:	184050ef          	jal	5ffc <exit>

0000000000000e7c <unlinkread>:
{
     e7c:	fd010113          	addi	sp,sp,-48
     e80:	02113423          	sd	ra,40(sp)
     e84:	02813023          	sd	s0,32(sp)
     e88:	00913c23          	sd	s1,24(sp)
     e8c:	01213823          	sd	s2,16(sp)
     e90:	01313423          	sd	s3,8(sp)
     e94:	03010413          	addi	s0,sp,48
     e98:	00050993          	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     e9c:	20200593          	li	a1,514
     ea0:	00006517          	auipc	a0,0x6
     ea4:	ee050513          	addi	a0,a0,-288 # 6d80 <malloc+0x6a0>
     ea8:	1b4050ef          	jal	605c <open>
  if(fd < 0){
     eac:	0e054663          	bltz	a0,f98 <unlinkread+0x11c>
     eb0:	00050493          	mv	s1,a0
  write(fd, "hello", SZ);
     eb4:	00500613          	li	a2,5
     eb8:	00006597          	auipc	a1,0x6
     ebc:	ef858593          	addi	a1,a1,-264 # 6db0 <malloc+0x6d0>
     ec0:	16c050ef          	jal	602c <write>
  close(fd);
     ec4:	00048513          	mv	a0,s1
     ec8:	170050ef          	jal	6038 <close>
  fd = open("unlinkread", O_RDWR);
     ecc:	00200593          	li	a1,2
     ed0:	00006517          	auipc	a0,0x6
     ed4:	eb050513          	addi	a0,a0,-336 # 6d80 <malloc+0x6a0>
     ed8:	184050ef          	jal	605c <open>
     edc:	00050493          	mv	s1,a0
  if(fd < 0){
     ee0:	0c054863          	bltz	a0,fb0 <unlinkread+0x134>
  if(unlink("unlinkread") != 0){
     ee4:	00006517          	auipc	a0,0x6
     ee8:	e9c50513          	addi	a0,a0,-356 # 6d80 <malloc+0x6a0>
     eec:	188050ef          	jal	6074 <unlink>
     ef0:	0c051c63          	bnez	a0,fc8 <unlinkread+0x14c>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     ef4:	20200593          	li	a1,514
     ef8:	00006517          	auipc	a0,0x6
     efc:	e8850513          	addi	a0,a0,-376 # 6d80 <malloc+0x6a0>
     f00:	15c050ef          	jal	605c <open>
     f04:	00050913          	mv	s2,a0
  write(fd1, "yyy", 3);
     f08:	00300613          	li	a2,3
     f0c:	00006597          	auipc	a1,0x6
     f10:	eec58593          	addi	a1,a1,-276 # 6df8 <malloc+0x718>
     f14:	118050ef          	jal	602c <write>
  close(fd1);
     f18:	00090513          	mv	a0,s2
     f1c:	11c050ef          	jal	6038 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     f20:	00003637          	lui	a2,0x3
     f24:	0000c597          	auipc	a1,0xc
     f28:	d5458593          	addi	a1,a1,-684 # cc78 <buf>
     f2c:	00048513          	mv	a0,s1
     f30:	0f0050ef          	jal	6020 <read>
     f34:	00500793          	li	a5,5
     f38:	0af51463          	bne	a0,a5,fe0 <unlinkread+0x164>
  if(buf[0] != 'h'){
     f3c:	0000c717          	auipc	a4,0xc
     f40:	d3c74703          	lbu	a4,-708(a4) # cc78 <buf>
     f44:	06800793          	li	a5,104
     f48:	0af71863          	bne	a4,a5,ff8 <unlinkread+0x17c>
  if(write(fd, buf, 10) != 10){
     f4c:	00a00613          	li	a2,10
     f50:	0000c597          	auipc	a1,0xc
     f54:	d2858593          	addi	a1,a1,-728 # cc78 <buf>
     f58:	00048513          	mv	a0,s1
     f5c:	0d0050ef          	jal	602c <write>
     f60:	00a00793          	li	a5,10
     f64:	0af51663          	bne	a0,a5,1010 <unlinkread+0x194>
  close(fd);
     f68:	00048513          	mv	a0,s1
     f6c:	0cc050ef          	jal	6038 <close>
  unlink("unlinkread");
     f70:	00006517          	auipc	a0,0x6
     f74:	e1050513          	addi	a0,a0,-496 # 6d80 <malloc+0x6a0>
     f78:	0fc050ef          	jal	6074 <unlink>
}
     f7c:	02813083          	ld	ra,40(sp)
     f80:	02013403          	ld	s0,32(sp)
     f84:	01813483          	ld	s1,24(sp)
     f88:	01013903          	ld	s2,16(sp)
     f8c:	00813983          	ld	s3,8(sp)
     f90:	03010113          	addi	sp,sp,48
     f94:	00008067          	ret
    printf("%s: create unlinkread failed\n", s);
     f98:	00098593          	mv	a1,s3
     f9c:	00006517          	auipc	a0,0x6
     fa0:	df450513          	addi	a0,a0,-524 # 6d90 <malloc+0x6b0>
     fa4:	63c050ef          	jal	65e0 <printf>
    exit(1);
     fa8:	00100513          	li	a0,1
     fac:	050050ef          	jal	5ffc <exit>
    printf("%s: open unlinkread failed\n", s);
     fb0:	00098593          	mv	a1,s3
     fb4:	00006517          	auipc	a0,0x6
     fb8:	e0450513          	addi	a0,a0,-508 # 6db8 <malloc+0x6d8>
     fbc:	624050ef          	jal	65e0 <printf>
    exit(1);
     fc0:	00100513          	li	a0,1
     fc4:	038050ef          	jal	5ffc <exit>
    printf("%s: unlink unlinkread failed\n", s);
     fc8:	00098593          	mv	a1,s3
     fcc:	00006517          	auipc	a0,0x6
     fd0:	e0c50513          	addi	a0,a0,-500 # 6dd8 <malloc+0x6f8>
     fd4:	60c050ef          	jal	65e0 <printf>
    exit(1);
     fd8:	00100513          	li	a0,1
     fdc:	020050ef          	jal	5ffc <exit>
    printf("%s: unlinkread read failed", s);
     fe0:	00098593          	mv	a1,s3
     fe4:	00006517          	auipc	a0,0x6
     fe8:	e1c50513          	addi	a0,a0,-484 # 6e00 <malloc+0x720>
     fec:	5f4050ef          	jal	65e0 <printf>
    exit(1);
     ff0:	00100513          	li	a0,1
     ff4:	008050ef          	jal	5ffc <exit>
    printf("%s: unlinkread wrong data\n", s);
     ff8:	00098593          	mv	a1,s3
     ffc:	00006517          	auipc	a0,0x6
    1000:	e2450513          	addi	a0,a0,-476 # 6e20 <malloc+0x740>
    1004:	5dc050ef          	jal	65e0 <printf>
    exit(1);
    1008:	00100513          	li	a0,1
    100c:	7f1040ef          	jal	5ffc <exit>
    printf("%s: unlinkread write failed\n", s);
    1010:	00098593          	mv	a1,s3
    1014:	00006517          	auipc	a0,0x6
    1018:	e2c50513          	addi	a0,a0,-468 # 6e40 <malloc+0x760>
    101c:	5c4050ef          	jal	65e0 <printf>
    exit(1);
    1020:	00100513          	li	a0,1
    1024:	7d9040ef          	jal	5ffc <exit>

0000000000001028 <linktest>:
{
    1028:	fe010113          	addi	sp,sp,-32
    102c:	00113c23          	sd	ra,24(sp)
    1030:	00813823          	sd	s0,16(sp)
    1034:	00913423          	sd	s1,8(sp)
    1038:	01213023          	sd	s2,0(sp)
    103c:	02010413          	addi	s0,sp,32
    1040:	00050913          	mv	s2,a0
  unlink("lf1");
    1044:	00006517          	auipc	a0,0x6
    1048:	e1c50513          	addi	a0,a0,-484 # 6e60 <malloc+0x780>
    104c:	028050ef          	jal	6074 <unlink>
  unlink("lf2");
    1050:	00006517          	auipc	a0,0x6
    1054:	e1850513          	addi	a0,a0,-488 # 6e68 <malloc+0x788>
    1058:	01c050ef          	jal	6074 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    105c:	20200593          	li	a1,514
    1060:	00006517          	auipc	a0,0x6
    1064:	e0050513          	addi	a0,a0,-512 # 6e60 <malloc+0x780>
    1068:	7f5040ef          	jal	605c <open>
  if(fd < 0){
    106c:	10054063          	bltz	a0,116c <linktest+0x144>
    1070:	00050493          	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
    1074:	00500613          	li	a2,5
    1078:	00006597          	auipc	a1,0x6
    107c:	d3858593          	addi	a1,a1,-712 # 6db0 <malloc+0x6d0>
    1080:	7ad040ef          	jal	602c <write>
    1084:	00500793          	li	a5,5
    1088:	0ef51e63          	bne	a0,a5,1184 <linktest+0x15c>
  close(fd);
    108c:	00048513          	mv	a0,s1
    1090:	7a9040ef          	jal	6038 <close>
  if(link("lf1", "lf2") < 0){
    1094:	00006597          	auipc	a1,0x6
    1098:	dd458593          	addi	a1,a1,-556 # 6e68 <malloc+0x788>
    109c:	00006517          	auipc	a0,0x6
    10a0:	dc450513          	addi	a0,a0,-572 # 6e60 <malloc+0x780>
    10a4:	7e9040ef          	jal	608c <link>
    10a8:	0e054a63          	bltz	a0,119c <linktest+0x174>
  unlink("lf1");
    10ac:	00006517          	auipc	a0,0x6
    10b0:	db450513          	addi	a0,a0,-588 # 6e60 <malloc+0x780>
    10b4:	7c1040ef          	jal	6074 <unlink>
  if(open("lf1", 0) >= 0){
    10b8:	00000593          	li	a1,0
    10bc:	00006517          	auipc	a0,0x6
    10c0:	da450513          	addi	a0,a0,-604 # 6e60 <malloc+0x780>
    10c4:	799040ef          	jal	605c <open>
    10c8:	0e055663          	bgez	a0,11b4 <linktest+0x18c>
  fd = open("lf2", 0);
    10cc:	00000593          	li	a1,0
    10d0:	00006517          	auipc	a0,0x6
    10d4:	d9850513          	addi	a0,a0,-616 # 6e68 <malloc+0x788>
    10d8:	785040ef          	jal	605c <open>
    10dc:	00050493          	mv	s1,a0
  if(fd < 0){
    10e0:	0e054663          	bltz	a0,11cc <linktest+0x1a4>
  if(read(fd, buf, sizeof(buf)) != SZ){
    10e4:	00003637          	lui	a2,0x3
    10e8:	0000c597          	auipc	a1,0xc
    10ec:	b9058593          	addi	a1,a1,-1136 # cc78 <buf>
    10f0:	731040ef          	jal	6020 <read>
    10f4:	00500793          	li	a5,5
    10f8:	0ef51663          	bne	a0,a5,11e4 <linktest+0x1bc>
  close(fd);
    10fc:	00048513          	mv	a0,s1
    1100:	739040ef          	jal	6038 <close>
  if(link("lf2", "lf2") >= 0){
    1104:	00006597          	auipc	a1,0x6
    1108:	d6458593          	addi	a1,a1,-668 # 6e68 <malloc+0x788>
    110c:	00058513          	mv	a0,a1
    1110:	77d040ef          	jal	608c <link>
    1114:	0e055463          	bgez	a0,11fc <linktest+0x1d4>
  unlink("lf2");
    1118:	00006517          	auipc	a0,0x6
    111c:	d5050513          	addi	a0,a0,-688 # 6e68 <malloc+0x788>
    1120:	755040ef          	jal	6074 <unlink>
  if(link("lf2", "lf1") >= 0){
    1124:	00006597          	auipc	a1,0x6
    1128:	d3c58593          	addi	a1,a1,-708 # 6e60 <malloc+0x780>
    112c:	00006517          	auipc	a0,0x6
    1130:	d3c50513          	addi	a0,a0,-708 # 6e68 <malloc+0x788>
    1134:	759040ef          	jal	608c <link>
    1138:	0c055e63          	bgez	a0,1214 <linktest+0x1ec>
  if(link(".", "lf1") >= 0){
    113c:	00006597          	auipc	a1,0x6
    1140:	d2458593          	addi	a1,a1,-732 # 6e60 <malloc+0x780>
    1144:	00006517          	auipc	a0,0x6
    1148:	e2c50513          	addi	a0,a0,-468 # 6f70 <malloc+0x890>
    114c:	741040ef          	jal	608c <link>
    1150:	0c055e63          	bgez	a0,122c <linktest+0x204>
}
    1154:	01813083          	ld	ra,24(sp)
    1158:	01013403          	ld	s0,16(sp)
    115c:	00813483          	ld	s1,8(sp)
    1160:	00013903          	ld	s2,0(sp)
    1164:	02010113          	addi	sp,sp,32
    1168:	00008067          	ret
    printf("%s: create lf1 failed\n", s);
    116c:	00090593          	mv	a1,s2
    1170:	00006517          	auipc	a0,0x6
    1174:	d0050513          	addi	a0,a0,-768 # 6e70 <malloc+0x790>
    1178:	468050ef          	jal	65e0 <printf>
    exit(1);
    117c:	00100513          	li	a0,1
    1180:	67d040ef          	jal	5ffc <exit>
    printf("%s: write lf1 failed\n", s);
    1184:	00090593          	mv	a1,s2
    1188:	00006517          	auipc	a0,0x6
    118c:	d0050513          	addi	a0,a0,-768 # 6e88 <malloc+0x7a8>
    1190:	450050ef          	jal	65e0 <printf>
    exit(1);
    1194:	00100513          	li	a0,1
    1198:	665040ef          	jal	5ffc <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    119c:	00090593          	mv	a1,s2
    11a0:	00006517          	auipc	a0,0x6
    11a4:	d0050513          	addi	a0,a0,-768 # 6ea0 <malloc+0x7c0>
    11a8:	438050ef          	jal	65e0 <printf>
    exit(1);
    11ac:	00100513          	li	a0,1
    11b0:	64d040ef          	jal	5ffc <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    11b4:	00090593          	mv	a1,s2
    11b8:	00006517          	auipc	a0,0x6
    11bc:	d0850513          	addi	a0,a0,-760 # 6ec0 <malloc+0x7e0>
    11c0:	420050ef          	jal	65e0 <printf>
    exit(1);
    11c4:	00100513          	li	a0,1
    11c8:	635040ef          	jal	5ffc <exit>
    printf("%s: open lf2 failed\n", s);
    11cc:	00090593          	mv	a1,s2
    11d0:	00006517          	auipc	a0,0x6
    11d4:	d2050513          	addi	a0,a0,-736 # 6ef0 <malloc+0x810>
    11d8:	408050ef          	jal	65e0 <printf>
    exit(1);
    11dc:	00100513          	li	a0,1
    11e0:	61d040ef          	jal	5ffc <exit>
    printf("%s: read lf2 failed\n", s);
    11e4:	00090593          	mv	a1,s2
    11e8:	00006517          	auipc	a0,0x6
    11ec:	d2050513          	addi	a0,a0,-736 # 6f08 <malloc+0x828>
    11f0:	3f0050ef          	jal	65e0 <printf>
    exit(1);
    11f4:	00100513          	li	a0,1
    11f8:	605040ef          	jal	5ffc <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    11fc:	00090593          	mv	a1,s2
    1200:	00006517          	auipc	a0,0x6
    1204:	d2050513          	addi	a0,a0,-736 # 6f20 <malloc+0x840>
    1208:	3d8050ef          	jal	65e0 <printf>
    exit(1);
    120c:	00100513          	li	a0,1
    1210:	5ed040ef          	jal	5ffc <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1214:	00090593          	mv	a1,s2
    1218:	00006517          	auipc	a0,0x6
    121c:	d3050513          	addi	a0,a0,-720 # 6f48 <malloc+0x868>
    1220:	3c0050ef          	jal	65e0 <printf>
    exit(1);
    1224:	00100513          	li	a0,1
    1228:	5d5040ef          	jal	5ffc <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    122c:	00090593          	mv	a1,s2
    1230:	00006517          	auipc	a0,0x6
    1234:	d4850513          	addi	a0,a0,-696 # 6f78 <malloc+0x898>
    1238:	3a8050ef          	jal	65e0 <printf>
    exit(1);
    123c:	00100513          	li	a0,1
    1240:	5bd040ef          	jal	5ffc <exit>

0000000000001244 <validatetest>:
{
    1244:	fc010113          	addi	sp,sp,-64
    1248:	02113c23          	sd	ra,56(sp)
    124c:	02813823          	sd	s0,48(sp)
    1250:	02913423          	sd	s1,40(sp)
    1254:	03213023          	sd	s2,32(sp)
    1258:	01313c23          	sd	s3,24(sp)
    125c:	01413823          	sd	s4,16(sp)
    1260:	01513423          	sd	s5,8(sp)
    1264:	01613023          	sd	s6,0(sp)
    1268:	04010413          	addi	s0,sp,64
    126c:	00050b13          	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1270:	00000493          	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    1274:	00006997          	auipc	s3,0x6
    1278:	d2498993          	addi	s3,s3,-732 # 6f98 <malloc+0x8b8>
    127c:	fff00913          	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1280:	00001ab7          	lui	s5,0x1
    1284:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1288:	00048593          	mv	a1,s1
    128c:	00098513          	mv	a0,s3
    1290:	5fd040ef          	jal	608c <link>
    1294:	03251a63          	bne	a0,s2,12c8 <validatetest+0x84>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1298:	015484b3          	add	s1,s1,s5
    129c:	ff4496e3          	bne	s1,s4,1288 <validatetest+0x44>
}
    12a0:	03813083          	ld	ra,56(sp)
    12a4:	03013403          	ld	s0,48(sp)
    12a8:	02813483          	ld	s1,40(sp)
    12ac:	02013903          	ld	s2,32(sp)
    12b0:	01813983          	ld	s3,24(sp)
    12b4:	01013a03          	ld	s4,16(sp)
    12b8:	00813a83          	ld	s5,8(sp)
    12bc:	00013b03          	ld	s6,0(sp)
    12c0:	04010113          	addi	sp,sp,64
    12c4:	00008067          	ret
      printf("%s: link should not succeed\n", s);
    12c8:	000b0593          	mv	a1,s6
    12cc:	00006517          	auipc	a0,0x6
    12d0:	cdc50513          	addi	a0,a0,-804 # 6fa8 <malloc+0x8c8>
    12d4:	30c050ef          	jal	65e0 <printf>
      exit(1);
    12d8:	00100513          	li	a0,1
    12dc:	521040ef          	jal	5ffc <exit>

00000000000012e0 <bigdir>:
{
    12e0:	fb010113          	addi	sp,sp,-80
    12e4:	04113423          	sd	ra,72(sp)
    12e8:	04813023          	sd	s0,64(sp)
    12ec:	02913c23          	sd	s1,56(sp)
    12f0:	03213823          	sd	s2,48(sp)
    12f4:	03313423          	sd	s3,40(sp)
    12f8:	03413023          	sd	s4,32(sp)
    12fc:	01513c23          	sd	s5,24(sp)
    1300:	01613823          	sd	s6,16(sp)
    1304:	05010413          	addi	s0,sp,80
    1308:	00050993          	mv	s3,a0
  unlink("bd");
    130c:	00006517          	auipc	a0,0x6
    1310:	cbc50513          	addi	a0,a0,-836 # 6fc8 <malloc+0x8e8>
    1314:	561040ef          	jal	6074 <unlink>
  fd = open("bd", O_CREATE);
    1318:	20000593          	li	a1,512
    131c:	00006517          	auipc	a0,0x6
    1320:	cac50513          	addi	a0,a0,-852 # 6fc8 <malloc+0x8e8>
    1324:	539040ef          	jal	605c <open>
  if(fd < 0){
    1328:	0e054463          	bltz	a0,1410 <bigdir+0x130>
  close(fd);
    132c:	50d040ef          	jal	6038 <close>
  for(i = 0; i < N; i++){
    1330:	00000913          	li	s2,0
    name[0] = 'x';
    1334:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    1338:	00006a17          	auipc	s4,0x6
    133c:	c90a0a13          	addi	s4,s4,-880 # 6fc8 <malloc+0x8e8>
  for(i = 0; i < N; i++){
    1340:	1f400b13          	li	s6,500
    name[0] = 'x';
    1344:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    1348:	41f9571b          	sraiw	a4,s2,0x1f
    134c:	01a7571b          	srliw	a4,a4,0x1a
    1350:	012707bb          	addw	a5,a4,s2
    1354:	4067d69b          	sraiw	a3,a5,0x6
    1358:	0306869b          	addiw	a3,a3,48
    135c:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1360:	03f7f793          	andi	a5,a5,63
    1364:	40e787bb          	subw	a5,a5,a4
    1368:	0307879b          	addiw	a5,a5,48
    136c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1370:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1374:	fb040593          	addi	a1,s0,-80
    1378:	000a0513          	mv	a0,s4
    137c:	511040ef          	jal	608c <link>
    1380:	00050493          	mv	s1,a0
    1384:	0a051263          	bnez	a0,1428 <bigdir+0x148>
  for(i = 0; i < N; i++){
    1388:	0019091b          	addiw	s2,s2,1
    138c:	fb691ce3          	bne	s2,s6,1344 <bigdir+0x64>
  unlink("bd");
    1390:	00006517          	auipc	a0,0x6
    1394:	c3850513          	addi	a0,a0,-968 # 6fc8 <malloc+0x8e8>
    1398:	4dd040ef          	jal	6074 <unlink>
    name[0] = 'x';
    139c:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    13a0:	1f400a13          	li	s4,500
    name[0] = 'x';
    13a4:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    13a8:	41f4d71b          	sraiw	a4,s1,0x1f
    13ac:	01a7571b          	srliw	a4,a4,0x1a
    13b0:	009707bb          	addw	a5,a4,s1
    13b4:	4067d69b          	sraiw	a3,a5,0x6
    13b8:	0306869b          	addiw	a3,a3,48
    13bc:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    13c0:	03f7f793          	andi	a5,a5,63
    13c4:	40e787bb          	subw	a5,a5,a4
    13c8:	0307879b          	addiw	a5,a5,48
    13cc:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    13d0:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    13d4:	fb040513          	addi	a0,s0,-80
    13d8:	49d040ef          	jal	6074 <unlink>
    13dc:	06051663          	bnez	a0,1448 <bigdir+0x168>
  for(i = 0; i < N; i++){
    13e0:	0014849b          	addiw	s1,s1,1
    13e4:	fd4490e3          	bne	s1,s4,13a4 <bigdir+0xc4>
}
    13e8:	04813083          	ld	ra,72(sp)
    13ec:	04013403          	ld	s0,64(sp)
    13f0:	03813483          	ld	s1,56(sp)
    13f4:	03013903          	ld	s2,48(sp)
    13f8:	02813983          	ld	s3,40(sp)
    13fc:	02013a03          	ld	s4,32(sp)
    1400:	01813a83          	ld	s5,24(sp)
    1404:	01013b03          	ld	s6,16(sp)
    1408:	05010113          	addi	sp,sp,80
    140c:	00008067          	ret
    printf("%s: bigdir create failed\n", s);
    1410:	00098593          	mv	a1,s3
    1414:	00006517          	auipc	a0,0x6
    1418:	bbc50513          	addi	a0,a0,-1092 # 6fd0 <malloc+0x8f0>
    141c:	1c4050ef          	jal	65e0 <printf>
    exit(1);
    1420:	00100513          	li	a0,1
    1424:	3d9040ef          	jal	5ffc <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1428:	fb040693          	addi	a3,s0,-80
    142c:	00090613          	mv	a2,s2
    1430:	00098593          	mv	a1,s3
    1434:	00006517          	auipc	a0,0x6
    1438:	bbc50513          	addi	a0,a0,-1092 # 6ff0 <malloc+0x910>
    143c:	1a4050ef          	jal	65e0 <printf>
      exit(1);
    1440:	00100513          	li	a0,1
    1444:	3b9040ef          	jal	5ffc <exit>
      printf("%s: bigdir unlink failed", s);
    1448:	00098593          	mv	a1,s3
    144c:	00006517          	auipc	a0,0x6
    1450:	bcc50513          	addi	a0,a0,-1076 # 7018 <malloc+0x938>
    1454:	18c050ef          	jal	65e0 <printf>
      exit(1);
    1458:	00100513          	li	a0,1
    145c:	3a1040ef          	jal	5ffc <exit>

0000000000001460 <pgbug>:
{
    1460:	fd010113          	addi	sp,sp,-48
    1464:	02113423          	sd	ra,40(sp)
    1468:	02813023          	sd	s0,32(sp)
    146c:	00913c23          	sd	s1,24(sp)
    1470:	03010413          	addi	s0,sp,48
  argv[0] = 0;
    1474:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1478:	00008497          	auipc	s1,0x8
    147c:	b8848493          	addi	s1,s1,-1144 # 9000 <big>
    1480:	fd840593          	addi	a1,s0,-40
    1484:	0004b503          	ld	a0,0(s1)
    1488:	3c9040ef          	jal	6050 <exec>
  pipe(big);
    148c:	0004b503          	ld	a0,0(s1)
    1490:	385040ef          	jal	6014 <pipe>
  exit(0);
    1494:	00000513          	li	a0,0
    1498:	365040ef          	jal	5ffc <exit>

000000000000149c <badarg>:
{
    149c:	fc010113          	addi	sp,sp,-64
    14a0:	02113c23          	sd	ra,56(sp)
    14a4:	02813823          	sd	s0,48(sp)
    14a8:	02913423          	sd	s1,40(sp)
    14ac:	03213023          	sd	s2,32(sp)
    14b0:	01313c23          	sd	s3,24(sp)
    14b4:	04010413          	addi	s0,sp,64
    14b8:	0000c4b7          	lui	s1,0xc
    14bc:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    14c0:	fff00913          	li	s2,-1
    14c4:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    14c8:	00005997          	auipc	s3,0x5
    14cc:	3c098993          	addi	s3,s3,960 # 6888 <malloc+0x1a8>
    argv[0] = (char*)0xffffffff;
    14d0:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    14d4:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    14d8:	fc040593          	addi	a1,s0,-64
    14dc:	00098513          	mv	a0,s3
    14e0:	371040ef          	jal	6050 <exec>
  for(int i = 0; i < 50000; i++){
    14e4:	fff4849b          	addiw	s1,s1,-1
    14e8:	fe0494e3          	bnez	s1,14d0 <badarg+0x34>
  exit(0);
    14ec:	00000513          	li	a0,0
    14f0:	30d040ef          	jal	5ffc <exit>

00000000000014f4 <copyinstr2>:
{
    14f4:	f3010113          	addi	sp,sp,-208
    14f8:	0c113423          	sd	ra,200(sp)
    14fc:	0c813023          	sd	s0,192(sp)
    1500:	0d010413          	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1504:	f6840793          	addi	a5,s0,-152
    1508:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    150c:	07800713          	li	a4,120
    1510:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1514:	00178793          	addi	a5,a5,1
    1518:	fed79ce3          	bne	a5,a3,1510 <copyinstr2+0x1c>
  b[MAXPATH] = '\0';
    151c:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1520:	f6840513          	addi	a0,s0,-152
    1524:	351040ef          	jal	6074 <unlink>
  if(ret != -1){
    1528:	fff00793          	li	a5,-1
    152c:	0cf51e63          	bne	a0,a5,1608 <copyinstr2+0x114>
  int fd = open(b, O_CREATE | O_WRONLY);
    1530:	20100593          	li	a1,513
    1534:	f6840513          	addi	a0,s0,-152
    1538:	325040ef          	jal	605c <open>
  if(fd != -1){
    153c:	fff00793          	li	a5,-1
    1540:	0ef51263          	bne	a0,a5,1624 <copyinstr2+0x130>
  ret = link(b, b);
    1544:	f6840593          	addi	a1,s0,-152
    1548:	00058513          	mv	a0,a1
    154c:	341040ef          	jal	608c <link>
  if(ret != -1){
    1550:	fff00793          	li	a5,-1
    1554:	0ef51663          	bne	a0,a5,1640 <copyinstr2+0x14c>
  char *args[] = { "xx", 0 };
    1558:	00007797          	auipc	a5,0x7
    155c:	c1078793          	addi	a5,a5,-1008 # 8168 <malloc+0x1a88>
    1560:	f4f43c23          	sd	a5,-168(s0)
    1564:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1568:	f5840593          	addi	a1,s0,-168
    156c:	f6840513          	addi	a0,s0,-152
    1570:	2e1040ef          	jal	6050 <exec>
  if(ret != -1){
    1574:	fff00793          	li	a5,-1
    1578:	0ef51463          	bne	a0,a5,1660 <copyinstr2+0x16c>
  int pid = fork();
    157c:	275040ef          	jal	5ff0 <fork>
  if(pid < 0){
    1580:	0e054e63          	bltz	a0,167c <copyinstr2+0x188>
  if(pid == 0){
    1584:	10051a63          	bnez	a0,1698 <copyinstr2+0x1a4>
    1588:	00008797          	auipc	a5,0x8
    158c:	fd878793          	addi	a5,a5,-40 # 9560 <big.0>
    1590:	00009697          	auipc	a3,0x9
    1594:	fd068693          	addi	a3,a3,-48 # a560 <big.0+0x1000>
      big[i] = 'x';
    1598:	07800713          	li	a4,120
    159c:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    15a0:	00178793          	addi	a5,a5,1
    15a4:	fed79ce3          	bne	a5,a3,159c <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    15a8:	00009797          	auipc	a5,0x9
    15ac:	fa078c23          	sb	zero,-72(a5) # a560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    15b0:	00007797          	auipc	a5,0x7
    15b4:	63878793          	addi	a5,a5,1592 # 8be8 <malloc+0x2508>
    15b8:	0587b603          	ld	a2,88(a5)
    15bc:	0607b683          	ld	a3,96(a5)
    15c0:	0687b703          	ld	a4,104(a5)
    15c4:	0707b783          	ld	a5,112(a5)
    15c8:	f2c43823          	sd	a2,-208(s0)
    15cc:	f2d43c23          	sd	a3,-200(s0)
    15d0:	f4e43023          	sd	a4,-192(s0)
    15d4:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    15d8:	f3040593          	addi	a1,s0,-208
    15dc:	00005517          	auipc	a0,0x5
    15e0:	2ac50513          	addi	a0,a0,684 # 6888 <malloc+0x1a8>
    15e4:	26d040ef          	jal	6050 <exec>
    if(ret != -1){
    15e8:	fff00793          	li	a5,-1
    15ec:	0af50263          	beq	a0,a5,1690 <copyinstr2+0x19c>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    15f0:	fff00593          	li	a1,-1
    15f4:	00006517          	auipc	a0,0x6
    15f8:	acc50513          	addi	a0,a0,-1332 # 70c0 <malloc+0x9e0>
    15fc:	7e5040ef          	jal	65e0 <printf>
      exit(1);
    1600:	00100513          	li	a0,1
    1604:	1f9040ef          	jal	5ffc <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1608:	00050613          	mv	a2,a0
    160c:	f6840593          	addi	a1,s0,-152
    1610:	00006517          	auipc	a0,0x6
    1614:	a2850513          	addi	a0,a0,-1496 # 7038 <malloc+0x958>
    1618:	7c9040ef          	jal	65e0 <printf>
    exit(1);
    161c:	00100513          	li	a0,1
    1620:	1dd040ef          	jal	5ffc <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1624:	00050613          	mv	a2,a0
    1628:	f6840593          	addi	a1,s0,-152
    162c:	00006517          	auipc	a0,0x6
    1630:	a2c50513          	addi	a0,a0,-1492 # 7058 <malloc+0x978>
    1634:	7ad040ef          	jal	65e0 <printf>
    exit(1);
    1638:	00100513          	li	a0,1
    163c:	1c1040ef          	jal	5ffc <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1640:	00050693          	mv	a3,a0
    1644:	f6840613          	addi	a2,s0,-152
    1648:	00060593          	mv	a1,a2
    164c:	00006517          	auipc	a0,0x6
    1650:	a2c50513          	addi	a0,a0,-1492 # 7078 <malloc+0x998>
    1654:	78d040ef          	jal	65e0 <printf>
    exit(1);
    1658:	00100513          	li	a0,1
    165c:	1a1040ef          	jal	5ffc <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1660:	fff00613          	li	a2,-1
    1664:	f6840593          	addi	a1,s0,-152
    1668:	00006517          	auipc	a0,0x6
    166c:	a3850513          	addi	a0,a0,-1480 # 70a0 <malloc+0x9c0>
    1670:	771040ef          	jal	65e0 <printf>
    exit(1);
    1674:	00100513          	li	a0,1
    1678:	185040ef          	jal	5ffc <exit>
    printf("fork failed\n");
    167c:	00007517          	auipc	a0,0x7
    1680:	00c50513          	addi	a0,a0,12 # 8688 <malloc+0x1fa8>
    1684:	75d040ef          	jal	65e0 <printf>
    exit(1);
    1688:	00100513          	li	a0,1
    168c:	171040ef          	jal	5ffc <exit>
    exit(747); // OK
    1690:	2eb00513          	li	a0,747
    1694:	169040ef          	jal	5ffc <exit>
  int st = 0;
    1698:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    169c:	f5440513          	addi	a0,s0,-172
    16a0:	169040ef          	jal	6008 <wait>
  if(st != 747){
    16a4:	f5442703          	lw	a4,-172(s0)
    16a8:	2eb00793          	li	a5,747
    16ac:	00f71a63          	bne	a4,a5,16c0 <copyinstr2+0x1cc>
}
    16b0:	0c813083          	ld	ra,200(sp)
    16b4:	0c013403          	ld	s0,192(sp)
    16b8:	0d010113          	addi	sp,sp,208
    16bc:	00008067          	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    16c0:	00006517          	auipc	a0,0x6
    16c4:	a2850513          	addi	a0,a0,-1496 # 70e8 <malloc+0xa08>
    16c8:	719040ef          	jal	65e0 <printf>
    exit(1);
    16cc:	00100513          	li	a0,1
    16d0:	12d040ef          	jal	5ffc <exit>

00000000000016d4 <truncate3>:
{
    16d4:	f9010113          	addi	sp,sp,-112
    16d8:	06113423          	sd	ra,104(sp)
    16dc:	06813023          	sd	s0,96(sp)
    16e0:	05213823          	sd	s2,80(sp)
    16e4:	07010413          	addi	s0,sp,112
    16e8:	00050913          	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    16ec:	60100593          	li	a1,1537
    16f0:	00005517          	auipc	a0,0x5
    16f4:	1f050513          	addi	a0,a0,496 # 68e0 <malloc+0x200>
    16f8:	165040ef          	jal	605c <open>
    16fc:	13d040ef          	jal	6038 <close>
  pid = fork();
    1700:	0f1040ef          	jal	5ff0 <fork>
  if(pid < 0){
    1704:	08054863          	bltz	a0,1794 <truncate3+0xc0>
  if(pid == 0){
    1708:	0e051463          	bnez	a0,17f0 <truncate3+0x11c>
    170c:	04913c23          	sd	s1,88(sp)
    1710:	05313423          	sd	s3,72(sp)
    1714:	05413023          	sd	s4,64(sp)
    1718:	03513c23          	sd	s5,56(sp)
    171c:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1720:	00005a17          	auipc	s4,0x5
    1724:	1c0a0a13          	addi	s4,s4,448 # 68e0 <malloc+0x200>
      int n = write(fd, "1234567890", 10);
    1728:	00006a97          	auipc	s5,0x6
    172c:	a20a8a93          	addi	s5,s5,-1504 # 7148 <malloc+0xa68>
      int fd = open("truncfile", O_WRONLY);
    1730:	00100593          	li	a1,1
    1734:	000a0513          	mv	a0,s4
    1738:	125040ef          	jal	605c <open>
    173c:	00050493          	mv	s1,a0
      if(fd < 0){
    1740:	06054e63          	bltz	a0,17bc <truncate3+0xe8>
      int n = write(fd, "1234567890", 10);
    1744:	00a00613          	li	a2,10
    1748:	000a8593          	mv	a1,s5
    174c:	0e1040ef          	jal	602c <write>
      if(n != 10){
    1750:	00a00793          	li	a5,10
    1754:	08f51063          	bne	a0,a5,17d4 <truncate3+0x100>
      close(fd);
    1758:	00048513          	mv	a0,s1
    175c:	0dd040ef          	jal	6038 <close>
      fd = open("truncfile", O_RDONLY);
    1760:	00000593          	li	a1,0
    1764:	000a0513          	mv	a0,s4
    1768:	0f5040ef          	jal	605c <open>
    176c:	00050493          	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1770:	02000613          	li	a2,32
    1774:	f9840593          	addi	a1,s0,-104
    1778:	0a9040ef          	jal	6020 <read>
      close(fd);
    177c:	00048513          	mv	a0,s1
    1780:	0b9040ef          	jal	6038 <close>
    for(int i = 0; i < 100; i++){
    1784:	fff9899b          	addiw	s3,s3,-1
    1788:	fa0994e3          	bnez	s3,1730 <truncate3+0x5c>
    exit(0);
    178c:	00000513          	li	a0,0
    1790:	06d040ef          	jal	5ffc <exit>
    1794:	04913c23          	sd	s1,88(sp)
    1798:	05313423          	sd	s3,72(sp)
    179c:	05413023          	sd	s4,64(sp)
    17a0:	03513c23          	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    17a4:	00090593          	mv	a1,s2
    17a8:	00006517          	auipc	a0,0x6
    17ac:	97050513          	addi	a0,a0,-1680 # 7118 <malloc+0xa38>
    17b0:	631040ef          	jal	65e0 <printf>
    exit(1);
    17b4:	00100513          	li	a0,1
    17b8:	045040ef          	jal	5ffc <exit>
        printf("%s: open failed\n", s);
    17bc:	00090593          	mv	a1,s2
    17c0:	00006517          	auipc	a0,0x6
    17c4:	97050513          	addi	a0,a0,-1680 # 7130 <malloc+0xa50>
    17c8:	619040ef          	jal	65e0 <printf>
        exit(1);
    17cc:	00100513          	li	a0,1
    17d0:	02d040ef          	jal	5ffc <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    17d4:	00050613          	mv	a2,a0
    17d8:	00090593          	mv	a1,s2
    17dc:	00006517          	auipc	a0,0x6
    17e0:	97c50513          	addi	a0,a0,-1668 # 7158 <malloc+0xa78>
    17e4:	5fd040ef          	jal	65e0 <printf>
        exit(1);
    17e8:	00100513          	li	a0,1
    17ec:	011040ef          	jal	5ffc <exit>
    17f0:	04913c23          	sd	s1,88(sp)
    17f4:	05313423          	sd	s3,72(sp)
    17f8:	05413023          	sd	s4,64(sp)
    17fc:	03513c23          	sd	s5,56(sp)
    1800:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1804:	00005a17          	auipc	s4,0x5
    1808:	0dca0a13          	addi	s4,s4,220 # 68e0 <malloc+0x200>
    int n = write(fd, "xxx", 3);
    180c:	00006a97          	auipc	s5,0x6
    1810:	96ca8a93          	addi	s5,s5,-1684 # 7178 <malloc+0xa98>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1814:	60100593          	li	a1,1537
    1818:	000a0513          	mv	a0,s4
    181c:	041040ef          	jal	605c <open>
    1820:	00050493          	mv	s1,a0
    if(fd < 0){
    1824:	04054263          	bltz	a0,1868 <truncate3+0x194>
    int n = write(fd, "xxx", 3);
    1828:	00300613          	li	a2,3
    182c:	000a8593          	mv	a1,s5
    1830:	7fc040ef          	jal	602c <write>
    if(n != 3){
    1834:	00300793          	li	a5,3
    1838:	04f51463          	bne	a0,a5,1880 <truncate3+0x1ac>
    close(fd);
    183c:	00048513          	mv	a0,s1
    1840:	7f8040ef          	jal	6038 <close>
  for(int i = 0; i < 150; i++){
    1844:	fff9899b          	addiw	s3,s3,-1
    1848:	fc0996e3          	bnez	s3,1814 <truncate3+0x140>
  wait(&xstatus);
    184c:	fbc40513          	addi	a0,s0,-68
    1850:	7b8040ef          	jal	6008 <wait>
  unlink("truncfile");
    1854:	00005517          	auipc	a0,0x5
    1858:	08c50513          	addi	a0,a0,140 # 68e0 <malloc+0x200>
    185c:	019040ef          	jal	6074 <unlink>
  exit(xstatus);
    1860:	fbc42503          	lw	a0,-68(s0)
    1864:	798040ef          	jal	5ffc <exit>
      printf("%s: open failed\n", s);
    1868:	00090593          	mv	a1,s2
    186c:	00006517          	auipc	a0,0x6
    1870:	8c450513          	addi	a0,a0,-1852 # 7130 <malloc+0xa50>
    1874:	56d040ef          	jal	65e0 <printf>
      exit(1);
    1878:	00100513          	li	a0,1
    187c:	780040ef          	jal	5ffc <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1880:	00050613          	mv	a2,a0
    1884:	00090593          	mv	a1,s2
    1888:	00006517          	auipc	a0,0x6
    188c:	8f850513          	addi	a0,a0,-1800 # 7180 <malloc+0xaa0>
    1890:	551040ef          	jal	65e0 <printf>
      exit(1);
    1894:	00100513          	li	a0,1
    1898:	764040ef          	jal	5ffc <exit>

000000000000189c <exectest>:
{
    189c:	fb010113          	addi	sp,sp,-80
    18a0:	04113423          	sd	ra,72(sp)
    18a4:	04813023          	sd	s0,64(sp)
    18a8:	03213823          	sd	s2,48(sp)
    18ac:	05010413          	addi	s0,sp,80
    18b0:	00050913          	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    18b4:	00005797          	auipc	a5,0x5
    18b8:	fd478793          	addi	a5,a5,-44 # 6888 <malloc+0x1a8>
    18bc:	fcf43023          	sd	a5,-64(s0)
    18c0:	00006797          	auipc	a5,0x6
    18c4:	8e078793          	addi	a5,a5,-1824 # 71a0 <malloc+0xac0>
    18c8:	fcf43423          	sd	a5,-56(s0)
    18cc:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    18d0:	00006517          	auipc	a0,0x6
    18d4:	8d850513          	addi	a0,a0,-1832 # 71a8 <malloc+0xac8>
    18d8:	79c040ef          	jal	6074 <unlink>
  pid = fork();
    18dc:	714040ef          	jal	5ff0 <fork>
  if(pid < 0) {
    18e0:	04054663          	bltz	a0,192c <exectest+0x90>
    18e4:	02913c23          	sd	s1,56(sp)
    18e8:	00050493          	mv	s1,a0
  if(pid == 0) {
    18ec:	08051463          	bnez	a0,1974 <exectest+0xd8>
    close(1);
    18f0:	00100513          	li	a0,1
    18f4:	744040ef          	jal	6038 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    18f8:	20100593          	li	a1,513
    18fc:	00006517          	auipc	a0,0x6
    1900:	8ac50513          	addi	a0,a0,-1876 # 71a8 <malloc+0xac8>
    1904:	758040ef          	jal	605c <open>
    if(fd < 0) {
    1908:	04054063          	bltz	a0,1948 <exectest+0xac>
    if(fd != 1) {
    190c:	00100793          	li	a5,1
    1910:	04f50863          	beq	a0,a5,1960 <exectest+0xc4>
      printf("%s: wrong fd\n", s);
    1914:	00090593          	mv	a1,s2
    1918:	00006517          	auipc	a0,0x6
    191c:	8b050513          	addi	a0,a0,-1872 # 71c8 <malloc+0xae8>
    1920:	4c1040ef          	jal	65e0 <printf>
      exit(1);
    1924:	00100513          	li	a0,1
    1928:	6d4040ef          	jal	5ffc <exit>
    192c:	02913c23          	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    1930:	00090593          	mv	a1,s2
    1934:	00005517          	auipc	a0,0x5
    1938:	7e450513          	addi	a0,a0,2020 # 7118 <malloc+0xa38>
    193c:	4a5040ef          	jal	65e0 <printf>
     exit(1);
    1940:	00100513          	li	a0,1
    1944:	6b8040ef          	jal	5ffc <exit>
      printf("%s: create failed\n", s);
    1948:	00090593          	mv	a1,s2
    194c:	00006517          	auipc	a0,0x6
    1950:	86450513          	addi	a0,a0,-1948 # 71b0 <malloc+0xad0>
    1954:	48d040ef          	jal	65e0 <printf>
      exit(1);
    1958:	00100513          	li	a0,1
    195c:	6a0040ef          	jal	5ffc <exit>
    if(exec("echo", echoargv) < 0){
    1960:	fc040593          	addi	a1,s0,-64
    1964:	00005517          	auipc	a0,0x5
    1968:	f2450513          	addi	a0,a0,-220 # 6888 <malloc+0x1a8>
    196c:	6e4040ef          	jal	6050 <exec>
    1970:	00054e63          	bltz	a0,198c <exectest+0xf0>
  if (wait(&xstatus) != pid) {
    1974:	fdc40513          	addi	a0,s0,-36
    1978:	690040ef          	jal	6008 <wait>
    197c:	02951463          	bne	a0,s1,19a4 <exectest+0x108>
  if(xstatus != 0)
    1980:	fdc42503          	lw	a0,-36(s0)
    1984:	02050a63          	beqz	a0,19b8 <exectest+0x11c>
    exit(xstatus);
    1988:	674040ef          	jal	5ffc <exit>
      printf("%s: exec echo failed\n", s);
    198c:	00090593          	mv	a1,s2
    1990:	00006517          	auipc	a0,0x6
    1994:	84850513          	addi	a0,a0,-1976 # 71d8 <malloc+0xaf8>
    1998:	449040ef          	jal	65e0 <printf>
      exit(1);
    199c:	00100513          	li	a0,1
    19a0:	65c040ef          	jal	5ffc <exit>
    printf("%s: wait failed!\n", s);
    19a4:	00090593          	mv	a1,s2
    19a8:	00006517          	auipc	a0,0x6
    19ac:	84850513          	addi	a0,a0,-1976 # 71f0 <malloc+0xb10>
    19b0:	431040ef          	jal	65e0 <printf>
    19b4:	fcdff06f          	j	1980 <exectest+0xe4>
  fd = open("echo-ok", O_RDONLY);
    19b8:	00000593          	li	a1,0
    19bc:	00005517          	auipc	a0,0x5
    19c0:	7ec50513          	addi	a0,a0,2028 # 71a8 <malloc+0xac8>
    19c4:	698040ef          	jal	605c <open>
  if(fd < 0) {
    19c8:	02054863          	bltz	a0,19f8 <exectest+0x15c>
  if (read(fd, buf, 2) != 2) {
    19cc:	00200613          	li	a2,2
    19d0:	fb840593          	addi	a1,s0,-72
    19d4:	64c040ef          	jal	6020 <read>
    19d8:	00200793          	li	a5,2
    19dc:	02f50a63          	beq	a0,a5,1a10 <exectest+0x174>
    printf("%s: read failed\n", s);
    19e0:	00090593          	mv	a1,s2
    19e4:	00005517          	auipc	a0,0x5
    19e8:	27450513          	addi	a0,a0,628 # 6c58 <malloc+0x578>
    19ec:	3f5040ef          	jal	65e0 <printf>
    exit(1);
    19f0:	00100513          	li	a0,1
    19f4:	608040ef          	jal	5ffc <exit>
    printf("%s: open failed\n", s);
    19f8:	00090593          	mv	a1,s2
    19fc:	00005517          	auipc	a0,0x5
    1a00:	73450513          	addi	a0,a0,1844 # 7130 <malloc+0xa50>
    1a04:	3dd040ef          	jal	65e0 <printf>
    exit(1);
    1a08:	00100513          	li	a0,1
    1a0c:	5f0040ef          	jal	5ffc <exit>
  unlink("echo-ok");
    1a10:	00005517          	auipc	a0,0x5
    1a14:	79850513          	addi	a0,a0,1944 # 71a8 <malloc+0xac8>
    1a18:	65c040ef          	jal	6074 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1a1c:	fb844703          	lbu	a4,-72(s0)
    1a20:	04f00793          	li	a5,79
    1a24:	00f71863          	bne	a4,a5,1a34 <exectest+0x198>
    1a28:	fb944703          	lbu	a4,-71(s0)
    1a2c:	04b00793          	li	a5,75
    1a30:	00f70e63          	beq	a4,a5,1a4c <exectest+0x1b0>
    printf("%s: wrong output\n", s);
    1a34:	00090593          	mv	a1,s2
    1a38:	00005517          	auipc	a0,0x5
    1a3c:	7d050513          	addi	a0,a0,2000 # 7208 <malloc+0xb28>
    1a40:	3a1040ef          	jal	65e0 <printf>
    exit(1);
    1a44:	00100513          	li	a0,1
    1a48:	5b4040ef          	jal	5ffc <exit>
    exit(0);
    1a4c:	00000513          	li	a0,0
    1a50:	5ac040ef          	jal	5ffc <exit>

0000000000001a54 <pipe1>:
{
    1a54:	fa010113          	addi	sp,sp,-96
    1a58:	04113c23          	sd	ra,88(sp)
    1a5c:	04813823          	sd	s0,80(sp)
    1a60:	03313c23          	sd	s3,56(sp)
    1a64:	06010413          	addi	s0,sp,96
    1a68:	00050993          	mv	s3,a0
  if(pipe(fds) != 0){
    1a6c:	fa840513          	addi	a0,s0,-88
    1a70:	5a4040ef          	jal	6014 <pipe>
    1a74:	08051a63          	bnez	a0,1b08 <pipe1+0xb4>
    1a78:	04913423          	sd	s1,72(sp)
    1a7c:	03413823          	sd	s4,48(sp)
    1a80:	00050493          	mv	s1,a0
  pid = fork();
    1a84:	56c040ef          	jal	5ff0 <fork>
    1a88:	00050a13          	mv	s4,a0
  if(pid == 0){
    1a8c:	0a050663          	beqz	a0,1b38 <pipe1+0xe4>
  } else if(pid > 0){
    1a90:	1ca05063          	blez	a0,1c50 <pipe1+0x1fc>
    1a94:	05213023          	sd	s2,64(sp)
    1a98:	03513423          	sd	s5,40(sp)
    close(fds[1]);
    1a9c:	fac42503          	lw	a0,-84(s0)
    1aa0:	598040ef          	jal	6038 <close>
    total = 0;
    1aa4:	00048a13          	mv	s4,s1
    cc = 1;
    1aa8:	00100913          	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    1aac:	0000ba97          	auipc	s5,0xb
    1ab0:	1cca8a93          	addi	s5,s5,460 # cc78 <buf>
    1ab4:	00090613          	mv	a2,s2
    1ab8:	000a8593          	mv	a1,s5
    1abc:	fa842503          	lw	a0,-88(s0)
    1ac0:	560040ef          	jal	6020 <read>
    1ac4:	12a05e63          	blez	a0,1c00 <pipe1+0x1ac>
      for(i = 0; i < n; i++){
    1ac8:	0000b717          	auipc	a4,0xb
    1acc:	1b070713          	addi	a4,a4,432 # cc78 <buf>
    1ad0:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1ad4:	00074683          	lbu	a3,0(a4)
    1ad8:	0ff4f793          	zext.b	a5,s1
    1adc:	0014849b          	addiw	s1,s1,1
    1ae0:	0ef69663          	bne	a3,a5,1bcc <pipe1+0x178>
      for(i = 0; i < n; i++){
    1ae4:	00170713          	addi	a4,a4,1
    1ae8:	fec496e3          	bne	s1,a2,1ad4 <pipe1+0x80>
      total += n;
    1aec:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    1af0:	0019179b          	slliw	a5,s2,0x1
    1af4:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
    1af8:	00003737          	lui	a4,0x3
    1afc:	fb277ce3          	bgeu	a4,s2,1ab4 <pipe1+0x60>
        cc = sizeof(buf);
    1b00:	00003937          	lui	s2,0x3
    1b04:	fb1ff06f          	j	1ab4 <pipe1+0x60>
    1b08:	04913423          	sd	s1,72(sp)
    1b0c:	05213023          	sd	s2,64(sp)
    1b10:	03413823          	sd	s4,48(sp)
    1b14:	03513423          	sd	s5,40(sp)
    1b18:	03613023          	sd	s6,32(sp)
    1b1c:	01713c23          	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    1b20:	00098593          	mv	a1,s3
    1b24:	00005517          	auipc	a0,0x5
    1b28:	6fc50513          	addi	a0,a0,1788 # 7220 <malloc+0xb40>
    1b2c:	2b5040ef          	jal	65e0 <printf>
    exit(1);
    1b30:	00100513          	li	a0,1
    1b34:	4c8040ef          	jal	5ffc <exit>
    1b38:	05213023          	sd	s2,64(sp)
    1b3c:	03513423          	sd	s5,40(sp)
    1b40:	03613023          	sd	s6,32(sp)
    1b44:	01713c23          	sd	s7,24(sp)
    close(fds[0]);
    1b48:	fa842503          	lw	a0,-88(s0)
    1b4c:	4ec040ef          	jal	6038 <close>
    for(n = 0; n < N; n++){
    1b50:	0000bb17          	auipc	s6,0xb
    1b54:	128b0b13          	addi	s6,s6,296 # cc78 <buf>
    1b58:	416004bb          	negw	s1,s6
    1b5c:	0ff4f493          	zext.b	s1,s1
    1b60:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1b64:	000b0b93          	mv	s7,s6
    for(n = 0; n < N; n++){
    1b68:	00001ab7          	lui	s5,0x1
    1b6c:	42da8a93          	addi	s5,s5,1069 # 142d <bigdir+0x14d>
{
    1b70:	000b0793          	mv	a5,s6
        buf[i] = seq++;
    1b74:	0097873b          	addw	a4,a5,s1
    1b78:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1b7c:	00178793          	addi	a5,a5,1
    1b80:	ff279ae3          	bne	a5,s2,1b74 <pipe1+0x120>
    1b84:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1b88:	40900613          	li	a2,1033
    1b8c:	000b8593          	mv	a1,s7
    1b90:	fac42503          	lw	a0,-84(s0)
    1b94:	498040ef          	jal	602c <write>
    1b98:	40900793          	li	a5,1033
    1b9c:	00f51c63          	bne	a0,a5,1bb4 <pipe1+0x160>
    for(n = 0; n < N; n++){
    1ba0:	0094849b          	addiw	s1,s1,9
    1ba4:	0ff4f493          	zext.b	s1,s1
    1ba8:	fd5a14e3          	bne	s4,s5,1b70 <pipe1+0x11c>
    exit(0);
    1bac:	00000513          	li	a0,0
    1bb0:	44c040ef          	jal	5ffc <exit>
        printf("%s: pipe1 oops 1\n", s);
    1bb4:	00098593          	mv	a1,s3
    1bb8:	00005517          	auipc	a0,0x5
    1bbc:	68050513          	addi	a0,a0,1664 # 7238 <malloc+0xb58>
    1bc0:	221040ef          	jal	65e0 <printf>
        exit(1);
    1bc4:	00100513          	li	a0,1
    1bc8:	434040ef          	jal	5ffc <exit>
          printf("%s: pipe1 oops 2\n", s);
    1bcc:	00098593          	mv	a1,s3
    1bd0:	00005517          	auipc	a0,0x5
    1bd4:	68050513          	addi	a0,a0,1664 # 7250 <malloc+0xb70>
    1bd8:	209040ef          	jal	65e0 <printf>
          return;
    1bdc:	04813483          	ld	s1,72(sp)
    1be0:	04013903          	ld	s2,64(sp)
    1be4:	03013a03          	ld	s4,48(sp)
    1be8:	02813a83          	ld	s5,40(sp)
}
    1bec:	05813083          	ld	ra,88(sp)
    1bf0:	05013403          	ld	s0,80(sp)
    1bf4:	03813983          	ld	s3,56(sp)
    1bf8:	06010113          	addi	sp,sp,96
    1bfc:	00008067          	ret
    if(total != N * SZ){
    1c00:	000017b7          	lui	a5,0x1
    1c04:	42d78793          	addi	a5,a5,1069 # 142d <bigdir+0x14d>
    1c08:	02fa0463          	beq	s4,a5,1c30 <pipe1+0x1dc>
    1c0c:	03613023          	sd	s6,32(sp)
    1c10:	01713c23          	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1c14:	000a0613          	mv	a2,s4
    1c18:	00098593          	mv	a1,s3
    1c1c:	00005517          	auipc	a0,0x5
    1c20:	64c50513          	addi	a0,a0,1612 # 7268 <malloc+0xb88>
    1c24:	1bd040ef          	jal	65e0 <printf>
      exit(1);
    1c28:	00100513          	li	a0,1
    1c2c:	3d0040ef          	jal	5ffc <exit>
    1c30:	03613023          	sd	s6,32(sp)
    1c34:	01713c23          	sd	s7,24(sp)
    close(fds[0]);
    1c38:	fa842503          	lw	a0,-88(s0)
    1c3c:	3fc040ef          	jal	6038 <close>
    wait(&xstatus);
    1c40:	fa440513          	addi	a0,s0,-92
    1c44:	3c4040ef          	jal	6008 <wait>
    exit(xstatus);
    1c48:	fa442503          	lw	a0,-92(s0)
    1c4c:	3b0040ef          	jal	5ffc <exit>
    1c50:	05213023          	sd	s2,64(sp)
    1c54:	03513423          	sd	s5,40(sp)
    1c58:	03613023          	sd	s6,32(sp)
    1c5c:	01713c23          	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1c60:	00098593          	mv	a1,s3
    1c64:	00005517          	auipc	a0,0x5
    1c68:	62450513          	addi	a0,a0,1572 # 7288 <malloc+0xba8>
    1c6c:	175040ef          	jal	65e0 <printf>
    exit(1);
    1c70:	00100513          	li	a0,1
    1c74:	388040ef          	jal	5ffc <exit>

0000000000001c78 <exitwait>:
{
    1c78:	fc010113          	addi	sp,sp,-64
    1c7c:	02113c23          	sd	ra,56(sp)
    1c80:	02813823          	sd	s0,48(sp)
    1c84:	02913423          	sd	s1,40(sp)
    1c88:	03213023          	sd	s2,32(sp)
    1c8c:	01313c23          	sd	s3,24(sp)
    1c90:	01413823          	sd	s4,16(sp)
    1c94:	04010413          	addi	s0,sp,64
    1c98:	00050a13          	mv	s4,a0
  for(i = 0; i < 100; i++){
    1c9c:	00000913          	li	s2,0
    1ca0:	06400993          	li	s3,100
    pid = fork();
    1ca4:	34c040ef          	jal	5ff0 <fork>
    1ca8:	00050493          	mv	s1,a0
    if(pid < 0){
    1cac:	04054263          	bltz	a0,1cf0 <exitwait+0x78>
    if(pid){
    1cb0:	08050463          	beqz	a0,1d38 <exitwait+0xc0>
      if(wait(&xstate) != pid){
    1cb4:	fcc40513          	addi	a0,s0,-52
    1cb8:	350040ef          	jal	6008 <wait>
    1cbc:	04951663          	bne	a0,s1,1d08 <exitwait+0x90>
      if(i != xstate) {
    1cc0:	fcc42783          	lw	a5,-52(s0)
    1cc4:	05279e63          	bne	a5,s2,1d20 <exitwait+0xa8>
  for(i = 0; i < 100; i++){
    1cc8:	0019091b          	addiw	s2,s2,1 # 3001 <sbrkbugs+0x85>
    1ccc:	fd391ce3          	bne	s2,s3,1ca4 <exitwait+0x2c>
}
    1cd0:	03813083          	ld	ra,56(sp)
    1cd4:	03013403          	ld	s0,48(sp)
    1cd8:	02813483          	ld	s1,40(sp)
    1cdc:	02013903          	ld	s2,32(sp)
    1ce0:	01813983          	ld	s3,24(sp)
    1ce4:	01013a03          	ld	s4,16(sp)
    1ce8:	04010113          	addi	sp,sp,64
    1cec:	00008067          	ret
      printf("%s: fork failed\n", s);
    1cf0:	000a0593          	mv	a1,s4
    1cf4:	00005517          	auipc	a0,0x5
    1cf8:	42450513          	addi	a0,a0,1060 # 7118 <malloc+0xa38>
    1cfc:	0e5040ef          	jal	65e0 <printf>
      exit(1);
    1d00:	00100513          	li	a0,1
    1d04:	2f8040ef          	jal	5ffc <exit>
        printf("%s: wait wrong pid\n", s);
    1d08:	000a0593          	mv	a1,s4
    1d0c:	00005517          	auipc	a0,0x5
    1d10:	59450513          	addi	a0,a0,1428 # 72a0 <malloc+0xbc0>
    1d14:	0cd040ef          	jal	65e0 <printf>
        exit(1);
    1d18:	00100513          	li	a0,1
    1d1c:	2e0040ef          	jal	5ffc <exit>
        printf("%s: wait wrong exit status\n", s);
    1d20:	000a0593          	mv	a1,s4
    1d24:	00005517          	auipc	a0,0x5
    1d28:	59450513          	addi	a0,a0,1428 # 72b8 <malloc+0xbd8>
    1d2c:	0b5040ef          	jal	65e0 <printf>
        exit(1);
    1d30:	00100513          	li	a0,1
    1d34:	2c8040ef          	jal	5ffc <exit>
      exit(i);
    1d38:	00090513          	mv	a0,s2
    1d3c:	2c0040ef          	jal	5ffc <exit>

0000000000001d40 <twochildren>:
{
    1d40:	fe010113          	addi	sp,sp,-32
    1d44:	00113c23          	sd	ra,24(sp)
    1d48:	00813823          	sd	s0,16(sp)
    1d4c:	00913423          	sd	s1,8(sp)
    1d50:	01213023          	sd	s2,0(sp)
    1d54:	02010413          	addi	s0,sp,32
    1d58:	00050913          	mv	s2,a0
    1d5c:	3e800493          	li	s1,1000
    int pid1 = fork();
    1d60:	290040ef          	jal	5ff0 <fork>
    if(pid1 < 0){
    1d64:	04054263          	bltz	a0,1da8 <twochildren+0x68>
    if(pid1 == 0){
    1d68:	04050c63          	beqz	a0,1dc0 <twochildren+0x80>
      int pid2 = fork();
    1d6c:	284040ef          	jal	5ff0 <fork>
      if(pid2 < 0){
    1d70:	04054a63          	bltz	a0,1dc4 <twochildren+0x84>
      if(pid2 == 0){
    1d74:	06050463          	beqz	a0,1ddc <twochildren+0x9c>
        wait(0);
    1d78:	00000513          	li	a0,0
    1d7c:	28c040ef          	jal	6008 <wait>
        wait(0);
    1d80:	00000513          	li	a0,0
    1d84:	284040ef          	jal	6008 <wait>
  for(int i = 0; i < 1000; i++){
    1d88:	fff4849b          	addiw	s1,s1,-1
    1d8c:	fc049ae3          	bnez	s1,1d60 <twochildren+0x20>
}
    1d90:	01813083          	ld	ra,24(sp)
    1d94:	01013403          	ld	s0,16(sp)
    1d98:	00813483          	ld	s1,8(sp)
    1d9c:	00013903          	ld	s2,0(sp)
    1da0:	02010113          	addi	sp,sp,32
    1da4:	00008067          	ret
      printf("%s: fork failed\n", s);
    1da8:	00090593          	mv	a1,s2
    1dac:	00005517          	auipc	a0,0x5
    1db0:	36c50513          	addi	a0,a0,876 # 7118 <malloc+0xa38>
    1db4:	02d040ef          	jal	65e0 <printf>
      exit(1);
    1db8:	00100513          	li	a0,1
    1dbc:	240040ef          	jal	5ffc <exit>
      exit(0);
    1dc0:	23c040ef          	jal	5ffc <exit>
        printf("%s: fork failed\n", s);
    1dc4:	00090593          	mv	a1,s2
    1dc8:	00005517          	auipc	a0,0x5
    1dcc:	35050513          	addi	a0,a0,848 # 7118 <malloc+0xa38>
    1dd0:	011040ef          	jal	65e0 <printf>
        exit(1);
    1dd4:	00100513          	li	a0,1
    1dd8:	224040ef          	jal	5ffc <exit>
        exit(0);
    1ddc:	220040ef          	jal	5ffc <exit>

0000000000001de0 <forkfork>:
{
    1de0:	fd010113          	addi	sp,sp,-48
    1de4:	02113423          	sd	ra,40(sp)
    1de8:	02813023          	sd	s0,32(sp)
    1dec:	00913c23          	sd	s1,24(sp)
    1df0:	03010413          	addi	s0,sp,48
    1df4:	00050493          	mv	s1,a0
    int pid = fork();
    1df8:	1f8040ef          	jal	5ff0 <fork>
    if(pid < 0){
    1dfc:	04054463          	bltz	a0,1e44 <forkfork+0x64>
    if(pid == 0){
    1e00:	04050e63          	beqz	a0,1e5c <forkfork+0x7c>
    int pid = fork();
    1e04:	1ec040ef          	jal	5ff0 <fork>
    if(pid < 0){
    1e08:	02054e63          	bltz	a0,1e44 <forkfork+0x64>
    if(pid == 0){
    1e0c:	04050863          	beqz	a0,1e5c <forkfork+0x7c>
    wait(&xstatus);
    1e10:	fdc40513          	addi	a0,s0,-36
    1e14:	1f4040ef          	jal	6008 <wait>
    if(xstatus != 0) {
    1e18:	fdc42783          	lw	a5,-36(s0)
    1e1c:	06079a63          	bnez	a5,1e90 <forkfork+0xb0>
    wait(&xstatus);
    1e20:	fdc40513          	addi	a0,s0,-36
    1e24:	1e4040ef          	jal	6008 <wait>
    if(xstatus != 0) {
    1e28:	fdc42783          	lw	a5,-36(s0)
    1e2c:	06079263          	bnez	a5,1e90 <forkfork+0xb0>
}
    1e30:	02813083          	ld	ra,40(sp)
    1e34:	02013403          	ld	s0,32(sp)
    1e38:	01813483          	ld	s1,24(sp)
    1e3c:	03010113          	addi	sp,sp,48
    1e40:	00008067          	ret
      printf("%s: fork failed", s);
    1e44:	00048593          	mv	a1,s1
    1e48:	00005517          	auipc	a0,0x5
    1e4c:	49050513          	addi	a0,a0,1168 # 72d8 <malloc+0xbf8>
    1e50:	790040ef          	jal	65e0 <printf>
      exit(1);
    1e54:	00100513          	li	a0,1
    1e58:	1a4040ef          	jal	5ffc <exit>
{
    1e5c:	0c800493          	li	s1,200
        int pid1 = fork();
    1e60:	190040ef          	jal	5ff0 <fork>
        if(pid1 < 0){
    1e64:	02054063          	bltz	a0,1e84 <forkfork+0xa4>
        if(pid1 == 0){
    1e68:	02050263          	beqz	a0,1e8c <forkfork+0xac>
        wait(0);
    1e6c:	00000513          	li	a0,0
    1e70:	198040ef          	jal	6008 <wait>
      for(int j = 0; j < 200; j++){
    1e74:	fff4849b          	addiw	s1,s1,-1
    1e78:	fe0494e3          	bnez	s1,1e60 <forkfork+0x80>
      exit(0);
    1e7c:	00000513          	li	a0,0
    1e80:	17c040ef          	jal	5ffc <exit>
          exit(1);
    1e84:	00100513          	li	a0,1
    1e88:	174040ef          	jal	5ffc <exit>
          exit(0);
    1e8c:	170040ef          	jal	5ffc <exit>
      printf("%s: fork in child failed", s);
    1e90:	00048593          	mv	a1,s1
    1e94:	00005517          	auipc	a0,0x5
    1e98:	45450513          	addi	a0,a0,1108 # 72e8 <malloc+0xc08>
    1e9c:	744040ef          	jal	65e0 <printf>
      exit(1);
    1ea0:	00100513          	li	a0,1
    1ea4:	158040ef          	jal	5ffc <exit>

0000000000001ea8 <reparent2>:
{
    1ea8:	fe010113          	addi	sp,sp,-32
    1eac:	00113c23          	sd	ra,24(sp)
    1eb0:	00813823          	sd	s0,16(sp)
    1eb4:	00913423          	sd	s1,8(sp)
    1eb8:	02010413          	addi	s0,sp,32
    1ebc:	32000493          	li	s1,800
    int pid1 = fork();
    1ec0:	130040ef          	jal	5ff0 <fork>
    if(pid1 < 0){
    1ec4:	02054063          	bltz	a0,1ee4 <reparent2+0x3c>
    if(pid1 == 0){
    1ec8:	02050863          	beqz	a0,1ef8 <reparent2+0x50>
    wait(0);
    1ecc:	00000513          	li	a0,0
    1ed0:	138040ef          	jal	6008 <wait>
  for(int i = 0; i < 800; i++){
    1ed4:	fff4849b          	addiw	s1,s1,-1
    1ed8:	fe0494e3          	bnez	s1,1ec0 <reparent2+0x18>
  exit(0);
    1edc:	00000513          	li	a0,0
    1ee0:	11c040ef          	jal	5ffc <exit>
      printf("fork failed\n");
    1ee4:	00006517          	auipc	a0,0x6
    1ee8:	7a450513          	addi	a0,a0,1956 # 8688 <malloc+0x1fa8>
    1eec:	6f4040ef          	jal	65e0 <printf>
      exit(1);
    1ef0:	00100513          	li	a0,1
    1ef4:	108040ef          	jal	5ffc <exit>
      fork();
    1ef8:	0f8040ef          	jal	5ff0 <fork>
      fork();
    1efc:	0f4040ef          	jal	5ff0 <fork>
      exit(0);
    1f00:	00000513          	li	a0,0
    1f04:	0f8040ef          	jal	5ffc <exit>

0000000000001f08 <createdelete>:
{
    1f08:	f7010113          	addi	sp,sp,-144
    1f0c:	08113423          	sd	ra,136(sp)
    1f10:	08813023          	sd	s0,128(sp)
    1f14:	06913c23          	sd	s1,120(sp)
    1f18:	07213823          	sd	s2,112(sp)
    1f1c:	07313423          	sd	s3,104(sp)
    1f20:	07413023          	sd	s4,96(sp)
    1f24:	05513c23          	sd	s5,88(sp)
    1f28:	05613823          	sd	s6,80(sp)
    1f2c:	05713423          	sd	s7,72(sp)
    1f30:	05813023          	sd	s8,64(sp)
    1f34:	03913c23          	sd	s9,56(sp)
    1f38:	09010413          	addi	s0,sp,144
    1f3c:	00050c93          	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1f40:	00000913          	li	s2,0
    1f44:	00400993          	li	s3,4
    pid = fork();
    1f48:	0a8040ef          	jal	5ff0 <fork>
    1f4c:	00050493          	mv	s1,a0
    if(pid < 0){
    1f50:	04054663          	bltz	a0,1f9c <createdelete+0x94>
    if(pid == 0){
    1f54:	06050063          	beqz	a0,1fb4 <createdelete+0xac>
  for(pi = 0; pi < NCHILD; pi++){
    1f58:	0019091b          	addiw	s2,s2,1
    1f5c:	ff3916e3          	bne	s2,s3,1f48 <createdelete+0x40>
    1f60:	00400493          	li	s1,4
    wait(&xstatus);
    1f64:	f7c40513          	addi	a0,s0,-132
    1f68:	0a0040ef          	jal	6008 <wait>
    if(xstatus != 0)
    1f6c:	f7c42903          	lw	s2,-132(s0)
    1f70:	0e091063          	bnez	s2,2050 <createdelete+0x148>
  for(pi = 0; pi < NCHILD; pi++){
    1f74:	fff4849b          	addiw	s1,s1,-1
    1f78:	fe0496e3          	bnez	s1,1f64 <createdelete+0x5c>
  name[0] = name[1] = name[2] = 0;
    1f7c:	f8040123          	sb	zero,-126(s0)
    1f80:	03000993          	li	s3,48
    1f84:	fff00a13          	li	s4,-1
    1f88:	07000c13          	li	s8,112
      if((i == 0 || i >= N/2) && fd < 0){
    1f8c:	00900b13          	li	s6,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f90:	00800b93          	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    1f94:	07400a93          	li	s5,116
    1f98:	1500006f          	j	20e8 <createdelete+0x1e0>
      printf("%s: fork failed\n", s);
    1f9c:	000c8593          	mv	a1,s9
    1fa0:	00005517          	auipc	a0,0x5
    1fa4:	17850513          	addi	a0,a0,376 # 7118 <malloc+0xa38>
    1fa8:	638040ef          	jal	65e0 <printf>
      exit(1);
    1fac:	00100513          	li	a0,1
    1fb0:	04c040ef          	jal	5ffc <exit>
      name[0] = 'p' + pi;
    1fb4:	0709091b          	addiw	s2,s2,112
    1fb8:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1fbc:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1fc0:	01400913          	li	s2,20
    1fc4:	0240006f          	j	1fe8 <createdelete+0xe0>
          printf("%s: create failed\n", s);
    1fc8:	000c8593          	mv	a1,s9
    1fcc:	00005517          	auipc	a0,0x5
    1fd0:	1e450513          	addi	a0,a0,484 # 71b0 <malloc+0xad0>
    1fd4:	60c040ef          	jal	65e0 <printf>
          exit(1);
    1fd8:	00100513          	li	a0,1
    1fdc:	020040ef          	jal	5ffc <exit>
      for(i = 0; i < N; i++){
    1fe0:	0014849b          	addiw	s1,s1,1
    1fe4:	07248263          	beq	s1,s2,2048 <createdelete+0x140>
        name[1] = '0' + i;
    1fe8:	0304879b          	addiw	a5,s1,48
    1fec:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1ff0:	20200593          	li	a1,514
    1ff4:	f8040513          	addi	a0,s0,-128
    1ff8:	064040ef          	jal	605c <open>
        if(fd < 0){
    1ffc:	fc0546e3          	bltz	a0,1fc8 <createdelete+0xc0>
        close(fd);
    2000:	038040ef          	jal	6038 <close>
        if(i > 0 && (i % 2 ) == 0){
    2004:	12905863          	blez	s1,2134 <createdelete+0x22c>
    2008:	0014f793          	andi	a5,s1,1
    200c:	fc079ae3          	bnez	a5,1fe0 <createdelete+0xd8>
          name[1] = '0' + (i / 2);
    2010:	01f4d79b          	srliw	a5,s1,0x1f
    2014:	009787bb          	addw	a5,a5,s1
    2018:	4017d79b          	sraiw	a5,a5,0x1
    201c:	0307879b          	addiw	a5,a5,48
    2020:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    2024:	f8040513          	addi	a0,s0,-128
    2028:	04c040ef          	jal	6074 <unlink>
    202c:	fa055ae3          	bgez	a0,1fe0 <createdelete+0xd8>
            printf("%s: unlink failed\n", s);
    2030:	000c8593          	mv	a1,s9
    2034:	00005517          	auipc	a0,0x5
    2038:	2d450513          	addi	a0,a0,724 # 7308 <malloc+0xc28>
    203c:	5a4040ef          	jal	65e0 <printf>
            exit(1);
    2040:	00100513          	li	a0,1
    2044:	7b9030ef          	jal	5ffc <exit>
      exit(0);
    2048:	00000513          	li	a0,0
    204c:	7b1030ef          	jal	5ffc <exit>
      exit(1);
    2050:	00100513          	li	a0,1
    2054:	7a9030ef          	jal	5ffc <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    2058:	f8040613          	addi	a2,s0,-128
    205c:	000c8593          	mv	a1,s9
    2060:	00005517          	auipc	a0,0x5
    2064:	2c050513          	addi	a0,a0,704 # 7320 <malloc+0xc40>
    2068:	578040ef          	jal	65e0 <printf>
        exit(1);
    206c:	00100513          	li	a0,1
    2070:	78d030ef          	jal	5ffc <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2074:	034bfe63          	bgeu	s7,s4,20b0 <createdelete+0x1a8>
      if(fd >= 0)
    2078:	02055863          	bgez	a0,20a8 <createdelete+0x1a0>
    for(pi = 0; pi < NCHILD; pi++){
    207c:	0014849b          	addiw	s1,s1,1
    2080:	0ff4f493          	zext.b	s1,s1
    2084:	05548663          	beq	s1,s5,20d0 <createdelete+0x1c8>
      name[0] = 'p' + pi;
    2088:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    208c:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    2090:	00000593          	li	a1,0
    2094:	f8040513          	addi	a0,s0,-128
    2098:	7c5030ef          	jal	605c <open>
      if((i == 0 || i >= N/2) && fd < 0){
    209c:	00090463          	beqz	s2,20a4 <createdelete+0x19c>
    20a0:	fd2b5ae3          	bge	s6,s2,2074 <createdelete+0x16c>
    20a4:	fa054ae3          	bltz	a0,2058 <createdelete+0x150>
        close(fd);
    20a8:	791030ef          	jal	6038 <close>
    20ac:	fd1ff06f          	j	207c <createdelete+0x174>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    20b0:	fc0546e3          	bltz	a0,207c <createdelete+0x174>
        printf("%s: oops createdelete %s did exist\n", s, name);
    20b4:	f8040613          	addi	a2,s0,-128
    20b8:	000c8593          	mv	a1,s9
    20bc:	00005517          	auipc	a0,0x5
    20c0:	28c50513          	addi	a0,a0,652 # 7348 <malloc+0xc68>
    20c4:	51c040ef          	jal	65e0 <printf>
        exit(1);
    20c8:	00100513          	li	a0,1
    20cc:	731030ef          	jal	5ffc <exit>
  for(i = 0; i < N; i++){
    20d0:	0019091b          	addiw	s2,s2,1
    20d4:	001a0a1b          	addiw	s4,s4,1
    20d8:	0019899b          	addiw	s3,s3,1
    20dc:	0ff9f993          	zext.b	s3,s3
    20e0:	01400793          	li	a5,20
    20e4:	02f90e63          	beq	s2,a5,2120 <createdelete+0x218>
    for(pi = 0; pi < NCHILD; pi++){
    20e8:	000c0493          	mv	s1,s8
    20ec:	f9dff06f          	j	2088 <createdelete+0x180>
  for(i = 0; i < N; i++){
    20f0:	0019091b          	addiw	s2,s2,1
    20f4:	0ff97913          	zext.b	s2,s2
    20f8:	05490263          	beq	s2,s4,213c <createdelete+0x234>
  name[0] = name[1] = name[2] = 0;
    20fc:	000a8493          	mv	s1,s5
      name[0] = 'p' + pi;
    2100:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    2104:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    2108:	f8040513          	addi	a0,s0,-128
    210c:	769030ef          	jal	6074 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    2110:	0014849b          	addiw	s1,s1,1
    2114:	0ff4f493          	zext.b	s1,s1
    2118:	ff3494e3          	bne	s1,s3,2100 <createdelete+0x1f8>
    211c:	fd5ff06f          	j	20f0 <createdelete+0x1e8>
    2120:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    2124:	07000a93          	li	s5,112
    for(pi = 0; pi < NCHILD; pi++){
    2128:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    212c:	04400a13          	li	s4,68
    2130:	fcdff06f          	j	20fc <createdelete+0x1f4>
      for(i = 0; i < N; i++){
    2134:	0014849b          	addiw	s1,s1,1
    2138:	eb1ff06f          	j	1fe8 <createdelete+0xe0>
}
    213c:	08813083          	ld	ra,136(sp)
    2140:	08013403          	ld	s0,128(sp)
    2144:	07813483          	ld	s1,120(sp)
    2148:	07013903          	ld	s2,112(sp)
    214c:	06813983          	ld	s3,104(sp)
    2150:	06013a03          	ld	s4,96(sp)
    2154:	05813a83          	ld	s5,88(sp)
    2158:	05013b03          	ld	s6,80(sp)
    215c:	04813b83          	ld	s7,72(sp)
    2160:	04013c03          	ld	s8,64(sp)
    2164:	03813c83          	ld	s9,56(sp)
    2168:	09010113          	addi	sp,sp,144
    216c:	00008067          	ret

0000000000002170 <linkunlink>:
{
    2170:	fa010113          	addi	sp,sp,-96
    2174:	04113c23          	sd	ra,88(sp)
    2178:	04813823          	sd	s0,80(sp)
    217c:	04913423          	sd	s1,72(sp)
    2180:	05213023          	sd	s2,64(sp)
    2184:	03313c23          	sd	s3,56(sp)
    2188:	03413823          	sd	s4,48(sp)
    218c:	03513423          	sd	s5,40(sp)
    2190:	03613023          	sd	s6,32(sp)
    2194:	01713c23          	sd	s7,24(sp)
    2198:	01813823          	sd	s8,16(sp)
    219c:	01913423          	sd	s9,8(sp)
    21a0:	06010413          	addi	s0,sp,96
    21a4:	00050493          	mv	s1,a0
  unlink("x");
    21a8:	00004517          	auipc	a0,0x4
    21ac:	75050513          	addi	a0,a0,1872 # 68f8 <malloc+0x218>
    21b0:	6c5030ef          	jal	6074 <unlink>
  pid = fork();
    21b4:	63d030ef          	jal	5ff0 <fork>
  if(pid < 0){
    21b8:	04054263          	bltz	a0,21fc <linkunlink+0x8c>
    21bc:	00050c93          	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    21c0:	06100913          	li	s2,97
    21c4:	00050463          	beqz	a0,21cc <linkunlink+0x5c>
    21c8:	00100913          	li	s2,1
    21cc:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    21d0:	41c65a37          	lui	s4,0x41c65
    21d4:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <base+0x41c551f5>
    21d8:	000039b7          	lui	s3,0x3
    21dc:	0399899b          	addiw	s3,s3,57 # 3039 <sbrkbugs+0xbd>
    if((x % 3) == 0){
    21e0:	00300a93          	li	s5,3
    } else if((x % 3) == 1){
    21e4:	00100b93          	li	s7,1
      unlink("x");
    21e8:	00004b17          	auipc	s6,0x4
    21ec:	710b0b13          	addi	s6,s6,1808 # 68f8 <malloc+0x218>
      link("cat", "x");
    21f0:	00005c17          	auipc	s8,0x5
    21f4:	180c0c13          	addi	s8,s8,384 # 7370 <malloc+0xc90>
    21f8:	0340006f          	j	222c <linkunlink+0xbc>
    printf("%s: fork failed\n", s);
    21fc:	00048593          	mv	a1,s1
    2200:	00005517          	auipc	a0,0x5
    2204:	f1850513          	addi	a0,a0,-232 # 7118 <malloc+0xa38>
    2208:	3d8040ef          	jal	65e0 <printf>
    exit(1);
    220c:	00100513          	li	a0,1
    2210:	5ed030ef          	jal	5ffc <exit>
      close(open("x", O_RDWR | O_CREATE));
    2214:	20200593          	li	a1,514
    2218:	000b0513          	mv	a0,s6
    221c:	641030ef          	jal	605c <open>
    2220:	619030ef          	jal	6038 <close>
  for(i = 0; i < 100; i++){
    2224:	fff4849b          	addiw	s1,s1,-1
    2228:	02048e63          	beqz	s1,2264 <linkunlink+0xf4>
    x = x * 1103515245 + 12345;
    222c:	034907bb          	mulw	a5,s2,s4
    2230:	013787bb          	addw	a5,a5,s3
    2234:	0007891b          	sext.w	s2,a5
    if((x % 3) == 0){
    2238:	0357f7bb          	remuw	a5,a5,s5
    223c:	0007879b          	sext.w	a5,a5
    2240:	fc078ae3          	beqz	a5,2214 <linkunlink+0xa4>
    } else if((x % 3) == 1){
    2244:	01778863          	beq	a5,s7,2254 <linkunlink+0xe4>
      unlink("x");
    2248:	000b0513          	mv	a0,s6
    224c:	629030ef          	jal	6074 <unlink>
    2250:	fd5ff06f          	j	2224 <linkunlink+0xb4>
      link("cat", "x");
    2254:	000b0593          	mv	a1,s6
    2258:	000c0513          	mv	a0,s8
    225c:	631030ef          	jal	608c <link>
    2260:	fc5ff06f          	j	2224 <linkunlink+0xb4>
  if(pid)
    2264:	040c8063          	beqz	s9,22a4 <linkunlink+0x134>
    wait(0);
    2268:	00000513          	li	a0,0
    226c:	59d030ef          	jal	6008 <wait>
}
    2270:	05813083          	ld	ra,88(sp)
    2274:	05013403          	ld	s0,80(sp)
    2278:	04813483          	ld	s1,72(sp)
    227c:	04013903          	ld	s2,64(sp)
    2280:	03813983          	ld	s3,56(sp)
    2284:	03013a03          	ld	s4,48(sp)
    2288:	02813a83          	ld	s5,40(sp)
    228c:	02013b03          	ld	s6,32(sp)
    2290:	01813b83          	ld	s7,24(sp)
    2294:	01013c03          	ld	s8,16(sp)
    2298:	00813c83          	ld	s9,8(sp)
    229c:	06010113          	addi	sp,sp,96
    22a0:	00008067          	ret
    exit(0);
    22a4:	00000513          	li	a0,0
    22a8:	555030ef          	jal	5ffc <exit>

00000000000022ac <forktest>:
{
    22ac:	fd010113          	addi	sp,sp,-48
    22b0:	02113423          	sd	ra,40(sp)
    22b4:	02813023          	sd	s0,32(sp)
    22b8:	00913c23          	sd	s1,24(sp)
    22bc:	01213823          	sd	s2,16(sp)
    22c0:	01313423          	sd	s3,8(sp)
    22c4:	03010413          	addi	s0,sp,48
    22c8:	00050993          	mv	s3,a0
  for(n=0; n<N; n++){
    22cc:	00000493          	li	s1,0
    22d0:	3e800913          	li	s2,1000
    pid = fork();
    22d4:	51d030ef          	jal	5ff0 <fork>
    if(pid < 0)
    22d8:	06054a63          	bltz	a0,234c <forktest+0xa0>
    if(pid == 0)
    22dc:	02050263          	beqz	a0,2300 <forktest+0x54>
  for(n=0; n<N; n++){
    22e0:	0014849b          	addiw	s1,s1,1
    22e4:	ff2498e3          	bne	s1,s2,22d4 <forktest+0x28>
    printf("%s: fork claimed to work 1000 times!\n", s);
    22e8:	00098593          	mv	a1,s3
    22ec:	00005517          	auipc	a0,0x5
    22f0:	0d450513          	addi	a0,a0,212 # 73c0 <malloc+0xce0>
    22f4:	2ec040ef          	jal	65e0 <printf>
    exit(1);
    22f8:	00100513          	li	a0,1
    22fc:	501030ef          	jal	5ffc <exit>
      exit(0);
    2300:	4fd030ef          	jal	5ffc <exit>
    printf("%s: no fork at all!\n", s);
    2304:	00098593          	mv	a1,s3
    2308:	00005517          	auipc	a0,0x5
    230c:	07050513          	addi	a0,a0,112 # 7378 <malloc+0xc98>
    2310:	2d0040ef          	jal	65e0 <printf>
    exit(1);
    2314:	00100513          	li	a0,1
    2318:	4e5030ef          	jal	5ffc <exit>
      printf("%s: wait stopped early\n", s);
    231c:	00098593          	mv	a1,s3
    2320:	00005517          	auipc	a0,0x5
    2324:	07050513          	addi	a0,a0,112 # 7390 <malloc+0xcb0>
    2328:	2b8040ef          	jal	65e0 <printf>
      exit(1);
    232c:	00100513          	li	a0,1
    2330:	4cd030ef          	jal	5ffc <exit>
    printf("%s: wait got too many\n", s);
    2334:	00098593          	mv	a1,s3
    2338:	00005517          	auipc	a0,0x5
    233c:	07050513          	addi	a0,a0,112 # 73a8 <malloc+0xcc8>
    2340:	2a0040ef          	jal	65e0 <printf>
    exit(1);
    2344:	00100513          	li	a0,1
    2348:	4b5030ef          	jal	5ffc <exit>
  if (n == 0) {
    234c:	fa048ce3          	beqz	s1,2304 <forktest+0x58>
  for(; n > 0; n--){
    2350:	00905c63          	blez	s1,2368 <forktest+0xbc>
    if(wait(0) < 0){
    2354:	00000513          	li	a0,0
    2358:	4b1030ef          	jal	6008 <wait>
    235c:	fc0540e3          	bltz	a0,231c <forktest+0x70>
  for(; n > 0; n--){
    2360:	fff4849b          	addiw	s1,s1,-1
    2364:	fe0498e3          	bnez	s1,2354 <forktest+0xa8>
  if(wait(0) != -1){
    2368:	00000513          	li	a0,0
    236c:	49d030ef          	jal	6008 <wait>
    2370:	fff00793          	li	a5,-1
    2374:	fcf510e3          	bne	a0,a5,2334 <forktest+0x88>
}
    2378:	02813083          	ld	ra,40(sp)
    237c:	02013403          	ld	s0,32(sp)
    2380:	01813483          	ld	s1,24(sp)
    2384:	01013903          	ld	s2,16(sp)
    2388:	00813983          	ld	s3,8(sp)
    238c:	03010113          	addi	sp,sp,48
    2390:	00008067          	ret

0000000000002394 <kernmem>:
{
    2394:	fb010113          	addi	sp,sp,-80
    2398:	04113423          	sd	ra,72(sp)
    239c:	04813023          	sd	s0,64(sp)
    23a0:	02913c23          	sd	s1,56(sp)
    23a4:	03213823          	sd	s2,48(sp)
    23a8:	03313423          	sd	s3,40(sp)
    23ac:	03413023          	sd	s4,32(sp)
    23b0:	01513c23          	sd	s5,24(sp)
    23b4:	05010413          	addi	s0,sp,80
    23b8:	00050a93          	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    23bc:	00100493          	li	s1,1
    23c0:	01f49493          	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    23c4:	fff00a13          	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    23c8:	0000c9b7          	lui	s3,0xc
    23cc:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    23d0:	1003d937          	lui	s2,0x1003d
    23d4:	00391913          	slli	s2,s2,0x3
    23d8:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    23dc:	415030ef          	jal	5ff0 <fork>
    if(pid < 0){
    23e0:	04054263          	bltz	a0,2424 <kernmem+0x90>
    if(pid == 0){
    23e4:	04050c63          	beqz	a0,243c <kernmem+0xa8>
    wait(&xstatus);
    23e8:	fbc40513          	addi	a0,s0,-68
    23ec:	41d030ef          	jal	6008 <wait>
    if(xstatus != -1)  // did kernel kill child?
    23f0:	fbc42783          	lw	a5,-68(s0)
    23f4:	07479463          	bne	a5,s4,245c <kernmem+0xc8>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    23f8:	013484b3          	add	s1,s1,s3
    23fc:	ff2490e3          	bne	s1,s2,23dc <kernmem+0x48>
}
    2400:	04813083          	ld	ra,72(sp)
    2404:	04013403          	ld	s0,64(sp)
    2408:	03813483          	ld	s1,56(sp)
    240c:	03013903          	ld	s2,48(sp)
    2410:	02813983          	ld	s3,40(sp)
    2414:	02013a03          	ld	s4,32(sp)
    2418:	01813a83          	ld	s5,24(sp)
    241c:	05010113          	addi	sp,sp,80
    2420:	00008067          	ret
      printf("%s: fork failed\n", s);
    2424:	000a8593          	mv	a1,s5
    2428:	00005517          	auipc	a0,0x5
    242c:	cf050513          	addi	a0,a0,-784 # 7118 <malloc+0xa38>
    2430:	1b0040ef          	jal	65e0 <printf>
      exit(1);
    2434:	00100513          	li	a0,1
    2438:	3c5030ef          	jal	5ffc <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    243c:	0004c683          	lbu	a3,0(s1)
    2440:	00048613          	mv	a2,s1
    2444:	000a8593          	mv	a1,s5
    2448:	00005517          	auipc	a0,0x5
    244c:	fa050513          	addi	a0,a0,-96 # 73e8 <malloc+0xd08>
    2450:	190040ef          	jal	65e0 <printf>
      exit(1);
    2454:	00100513          	li	a0,1
    2458:	3a5030ef          	jal	5ffc <exit>
      exit(1);
    245c:	00100513          	li	a0,1
    2460:	39d030ef          	jal	5ffc <exit>

0000000000002464 <MAXVAplus>:
{
    2464:	fd010113          	addi	sp,sp,-48
    2468:	02113423          	sd	ra,40(sp)
    246c:	02813023          	sd	s0,32(sp)
    2470:	03010413          	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    2474:	00100793          	li	a5,1
    2478:	02679793          	slli	a5,a5,0x26
    247c:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2480:	fd843783          	ld	a5,-40(s0)
    2484:	04078663          	beqz	a5,24d0 <MAXVAplus+0x6c>
    2488:	00913c23          	sd	s1,24(sp)
    248c:	01213823          	sd	s2,16(sp)
    2490:	00050913          	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    2494:	fff00493          	li	s1,-1
    pid = fork();
    2498:	359030ef          	jal	5ff0 <fork>
    if(pid < 0){
    249c:	04054263          	bltz	a0,24e0 <MAXVAplus+0x7c>
    if(pid == 0){
    24a0:	04050c63          	beqz	a0,24f8 <MAXVAplus+0x94>
    wait(&xstatus);
    24a4:	fd440513          	addi	a0,s0,-44
    24a8:	361030ef          	jal	6008 <wait>
    if(xstatus != -1)  // did kernel kill child?
    24ac:	fd442783          	lw	a5,-44(s0)
    24b0:	06979863          	bne	a5,s1,2520 <MAXVAplus+0xbc>
  for( ; a != 0; a <<= 1){
    24b4:	fd843783          	ld	a5,-40(s0)
    24b8:	00179793          	slli	a5,a5,0x1
    24bc:	fcf43c23          	sd	a5,-40(s0)
    24c0:	fd843783          	ld	a5,-40(s0)
    24c4:	fc079ae3          	bnez	a5,2498 <MAXVAplus+0x34>
    24c8:	01813483          	ld	s1,24(sp)
    24cc:	01013903          	ld	s2,16(sp)
}
    24d0:	02813083          	ld	ra,40(sp)
    24d4:	02013403          	ld	s0,32(sp)
    24d8:	03010113          	addi	sp,sp,48
    24dc:	00008067          	ret
      printf("%s: fork failed\n", s);
    24e0:	00090593          	mv	a1,s2
    24e4:	00005517          	auipc	a0,0x5
    24e8:	c3450513          	addi	a0,a0,-972 # 7118 <malloc+0xa38>
    24ec:	0f4040ef          	jal	65e0 <printf>
      exit(1);
    24f0:	00100513          	li	a0,1
    24f4:	309030ef          	jal	5ffc <exit>
      *(char*)a = 99;
    24f8:	fd843783          	ld	a5,-40(s0)
    24fc:	06300713          	li	a4,99
    2500:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    2504:	fd843603          	ld	a2,-40(s0)
    2508:	00090593          	mv	a1,s2
    250c:	00005517          	auipc	a0,0x5
    2510:	efc50513          	addi	a0,a0,-260 # 7408 <malloc+0xd28>
    2514:	0cc040ef          	jal	65e0 <printf>
      exit(1);
    2518:	00100513          	li	a0,1
    251c:	2e1030ef          	jal	5ffc <exit>
      exit(1);
    2520:	00100513          	li	a0,1
    2524:	2d9030ef          	jal	5ffc <exit>

0000000000002528 <stacktest>:
{
    2528:	fd010113          	addi	sp,sp,-48
    252c:	02113423          	sd	ra,40(sp)
    2530:	02813023          	sd	s0,32(sp)
    2534:	00913c23          	sd	s1,24(sp)
    2538:	03010413          	addi	s0,sp,48
    253c:	00050493          	mv	s1,a0
  pid = fork();
    2540:	2b1030ef          	jal	5ff0 <fork>
  if(pid == 0) {
    2544:	02050063          	beqz	a0,2564 <stacktest+0x3c>
  } else if(pid < 0){
    2548:	04054263          	bltz	a0,258c <stacktest+0x64>
  wait(&xstatus);
    254c:	fdc40513          	addi	a0,s0,-36
    2550:	2b9030ef          	jal	6008 <wait>
  if(xstatus == -1)  // kernel killed child?
    2554:	fdc42503          	lw	a0,-36(s0)
    2558:	fff00793          	li	a5,-1
    255c:	04f50463          	beq	a0,a5,25a4 <stacktest+0x7c>
    exit(xstatus);
    2560:	29d030ef          	jal	5ffc <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2564:	00010713          	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    2568:	fffff7b7          	lui	a5,0xfffff
    256c:	00e787b3          	add	a5,a5,a4
    2570:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    2574:	00048593          	mv	a1,s1
    2578:	00005517          	auipc	a0,0x5
    257c:	ea850513          	addi	a0,a0,-344 # 7420 <malloc+0xd40>
    2580:	060040ef          	jal	65e0 <printf>
    exit(1);
    2584:	00100513          	li	a0,1
    2588:	275030ef          	jal	5ffc <exit>
    printf("%s: fork failed\n", s);
    258c:	00048593          	mv	a1,s1
    2590:	00005517          	auipc	a0,0x5
    2594:	b8850513          	addi	a0,a0,-1144 # 7118 <malloc+0xa38>
    2598:	048040ef          	jal	65e0 <printf>
    exit(1);
    259c:	00100513          	li	a0,1
    25a0:	25d030ef          	jal	5ffc <exit>
    exit(0);
    25a4:	00000513          	li	a0,0
    25a8:	255030ef          	jal	5ffc <exit>

00000000000025ac <nowrite>:
{
    25ac:	f9010113          	addi	sp,sp,-112
    25b0:	06113423          	sd	ra,104(sp)
    25b4:	06813023          	sd	s0,96(sp)
    25b8:	04913c23          	sd	s1,88(sp)
    25bc:	05213823          	sd	s2,80(sp)
    25c0:	05313423          	sd	s3,72(sp)
    25c4:	07010413          	addi	s0,sp,112
    25c8:	00050993          	mv	s3,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    25cc:	00006797          	auipc	a5,0x6
    25d0:	61c78793          	addi	a5,a5,1564 # 8be8 <malloc+0x2508>
    25d4:	0287b503          	ld	a0,40(a5)
    25d8:	0307b583          	ld	a1,48(a5)
    25dc:	0387b603          	ld	a2,56(a5)
    25e0:	0407b683          	ld	a3,64(a5)
    25e4:	0487b703          	ld	a4,72(a5)
    25e8:	0507b783          	ld	a5,80(a5)
    25ec:	f8a43c23          	sd	a0,-104(s0)
    25f0:	fab43023          	sd	a1,-96(s0)
    25f4:	fac43423          	sd	a2,-88(s0)
    25f8:	fad43823          	sd	a3,-80(s0)
    25fc:	fae43c23          	sd	a4,-72(s0)
    2600:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    2604:	00000493          	li	s1,0
    2608:	00600913          	li	s2,6
    pid = fork();
    260c:	1e5030ef          	jal	5ff0 <fork>
    if(pid == 0) {
    2610:	02050463          	beqz	a0,2638 <nowrite+0x8c>
    } else if(pid < 0){
    2614:	04054a63          	bltz	a0,2668 <nowrite+0xbc>
    wait(&xstatus);
    2618:	fcc40513          	addi	a0,s0,-52
    261c:	1ed030ef          	jal	6008 <wait>
    if(xstatus == 0){
    2620:	fcc42783          	lw	a5,-52(s0)
    2624:	04078e63          	beqz	a5,2680 <nowrite+0xd4>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    2628:	0014849b          	addiw	s1,s1,1
    262c:	ff2490e3          	bne	s1,s2,260c <nowrite+0x60>
  exit(0);
    2630:	00000513          	li	a0,0
    2634:	1c9030ef          	jal	5ffc <exit>
      volatile int *addr = (int *) addrs[ai];
    2638:	00349493          	slli	s1,s1,0x3
    263c:	fd048793          	addi	a5,s1,-48
    2640:	008784b3          	add	s1,a5,s0
    2644:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    2648:	00a00793          	li	a5,10
    264c:	00f62023          	sw	a5,0(a2) # 3000 <sbrkbugs+0x84>
      printf("%s: write to %p did not fail!\n", s, addr);
    2650:	00098593          	mv	a1,s3
    2654:	00005517          	auipc	a0,0x5
    2658:	df450513          	addi	a0,a0,-524 # 7448 <malloc+0xd68>
    265c:	785030ef          	jal	65e0 <printf>
      exit(0);
    2660:	00000513          	li	a0,0
    2664:	199030ef          	jal	5ffc <exit>
      printf("%s: fork failed\n", s);
    2668:	00098593          	mv	a1,s3
    266c:	00005517          	auipc	a0,0x5
    2670:	aac50513          	addi	a0,a0,-1364 # 7118 <malloc+0xa38>
    2674:	76d030ef          	jal	65e0 <printf>
      exit(1);
    2678:	00100513          	li	a0,1
    267c:	181030ef          	jal	5ffc <exit>
      exit(1);
    2680:	00100513          	li	a0,1
    2684:	179030ef          	jal	5ffc <exit>

0000000000002688 <manywrites>:
{
    2688:	fa010113          	addi	sp,sp,-96
    268c:	04113c23          	sd	ra,88(sp)
    2690:	04813823          	sd	s0,80(sp)
    2694:	04913423          	sd	s1,72(sp)
    2698:	05213023          	sd	s2,64(sp)
    269c:	03313c23          	sd	s3,56(sp)
    26a0:	03513423          	sd	s5,40(sp)
    26a4:	06010413          	addi	s0,sp,96
    26a8:	00050a93          	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    26ac:	00000993          	li	s3,0
    26b0:	00400913          	li	s2,4
    int pid = fork();
    26b4:	13d030ef          	jal	5ff0 <fork>
    26b8:	00050493          	mv	s1,a0
    if(pid < 0){
    26bc:	04054263          	bltz	a0,2700 <manywrites+0x78>
    if(pid == 0){
    26c0:	06050063          	beqz	a0,2720 <manywrites+0x98>
  for(int ci = 0; ci < nchildren; ci++){
    26c4:	0019899b          	addiw	s3,s3,1
    26c8:	ff2996e3          	bne	s3,s2,26b4 <manywrites+0x2c>
    26cc:	03413823          	sd	s4,48(sp)
    26d0:	03613023          	sd	s6,32(sp)
    26d4:	01713c23          	sd	s7,24(sp)
    26d8:	00400493          	li	s1,4
    int st = 0;
    26dc:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    26e0:	fa840513          	addi	a0,s0,-88
    26e4:	125030ef          	jal	6008 <wait>
    if(st != 0)
    26e8:	fa842503          	lw	a0,-88(s0)
    26ec:	10051263          	bnez	a0,27f0 <manywrites+0x168>
  for(int ci = 0; ci < nchildren; ci++){
    26f0:	fff4849b          	addiw	s1,s1,-1
    26f4:	fe0494e3          	bnez	s1,26dc <manywrites+0x54>
  exit(0);
    26f8:	00000513          	li	a0,0
    26fc:	101030ef          	jal	5ffc <exit>
    2700:	03413823          	sd	s4,48(sp)
    2704:	03613023          	sd	s6,32(sp)
    2708:	01713c23          	sd	s7,24(sp)
      printf("fork failed\n");
    270c:	00006517          	auipc	a0,0x6
    2710:	f7c50513          	addi	a0,a0,-132 # 8688 <malloc+0x1fa8>
    2714:	6cd030ef          	jal	65e0 <printf>
      exit(1);
    2718:	00100513          	li	a0,1
    271c:	0e1030ef          	jal	5ffc <exit>
    2720:	03413823          	sd	s4,48(sp)
    2724:	03613023          	sd	s6,32(sp)
    2728:	01713c23          	sd	s7,24(sp)
      name[0] = 'b';
    272c:	06200793          	li	a5,98
    2730:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2734:	0619879b          	addiw	a5,s3,97
    2738:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    273c:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    2740:	fa840513          	addi	a0,s0,-88
    2744:	131030ef          	jal	6074 <unlink>
    2748:	01e00b93          	li	s7,30
          int cc = write(fd, buf, sz);
    274c:	0000ab17          	auipc	s6,0xa
    2750:	52cb0b13          	addi	s6,s6,1324 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    2754:	00048a13          	mv	s4,s1
    2758:	0209ce63          	bltz	s3,2794 <manywrites+0x10c>
          int fd = open(name, O_CREATE | O_RDWR);
    275c:	20200593          	li	a1,514
    2760:	fa840513          	addi	a0,s0,-88
    2764:	0f9030ef          	jal	605c <open>
    2768:	00050913          	mv	s2,a0
          if(fd < 0){
    276c:	04054463          	bltz	a0,27b4 <manywrites+0x12c>
          int cc = write(fd, buf, sz);
    2770:	00003637          	lui	a2,0x3
    2774:	000b0593          	mv	a1,s6
    2778:	0b5030ef          	jal	602c <write>
          if(cc != sz){
    277c:	000037b7          	lui	a5,0x3
    2780:	04f51863          	bne	a0,a5,27d0 <manywrites+0x148>
          close(fd);
    2784:	00090513          	mv	a0,s2
    2788:	0b1030ef          	jal	6038 <close>
        for(int i = 0; i < ci+1; i++){
    278c:	001a0a1b          	addiw	s4,s4,1
    2790:	fd49d6e3          	bge	s3,s4,275c <manywrites+0xd4>
        unlink(name);
    2794:	fa840513          	addi	a0,s0,-88
    2798:	0dd030ef          	jal	6074 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    279c:	fffb8b9b          	addiw	s7,s7,-1
    27a0:	fa0b9ae3          	bnez	s7,2754 <manywrites+0xcc>
      unlink(name);
    27a4:	fa840513          	addi	a0,s0,-88
    27a8:	0cd030ef          	jal	6074 <unlink>
      exit(0);
    27ac:	00000513          	li	a0,0
    27b0:	04d030ef          	jal	5ffc <exit>
            printf("%s: cannot create %s\n", s, name);
    27b4:	fa840613          	addi	a2,s0,-88
    27b8:	000a8593          	mv	a1,s5
    27bc:	00005517          	auipc	a0,0x5
    27c0:	cac50513          	addi	a0,a0,-852 # 7468 <malloc+0xd88>
    27c4:	61d030ef          	jal	65e0 <printf>
            exit(1);
    27c8:	00100513          	li	a0,1
    27cc:	031030ef          	jal	5ffc <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    27d0:	00050693          	mv	a3,a0
    27d4:	00003637          	lui	a2,0x3
    27d8:	000a8593          	mv	a1,s5
    27dc:	00004517          	auipc	a0,0x4
    27e0:	17c50513          	addi	a0,a0,380 # 6958 <malloc+0x278>
    27e4:	5fd030ef          	jal	65e0 <printf>
            exit(1);
    27e8:	00100513          	li	a0,1
    27ec:	011030ef          	jal	5ffc <exit>
      exit(st);
    27f0:	00d030ef          	jal	5ffc <exit>

00000000000027f4 <copyinstr3>:
{
    27f4:	fd010113          	addi	sp,sp,-48
    27f8:	02113423          	sd	ra,40(sp)
    27fc:	02813023          	sd	s0,32(sp)
    2800:	00913c23          	sd	s1,24(sp)
    2804:	03010413          	addi	s0,sp,48
  sbrk(8192);
    2808:	00002537          	lui	a0,0x2
    280c:	0bd030ef          	jal	60c8 <sbrk>
  uint64 top = (uint64) sbrk(0);
    2810:	00000513          	li	a0,0
    2814:	0b5030ef          	jal	60c8 <sbrk>
  if((top % PGSIZE) != 0){
    2818:	03451793          	slli	a5,a0,0x34
    281c:	08079863          	bnez	a5,28ac <copyinstr3+0xb8>
  top = (uint64) sbrk(0);
    2820:	00000513          	li	a0,0
    2824:	0a5030ef          	jal	60c8 <sbrk>
  if(top % PGSIZE){
    2828:	03451793          	slli	a5,a0,0x34
    282c:	08079a63          	bnez	a5,28c0 <copyinstr3+0xcc>
  char *b = (char *) (top - 1);
    2830:	fff50493          	addi	s1,a0,-1 # 1fff <createdelete+0xf7>
  *b = 'x';
    2834:	07800793          	li	a5,120
    2838:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    283c:	00048513          	mv	a0,s1
    2840:	035030ef          	jal	6074 <unlink>
  if(ret != -1){
    2844:	fff00793          	li	a5,-1
    2848:	08f51663          	bne	a0,a5,28d4 <copyinstr3+0xe0>
  int fd = open(b, O_CREATE | O_WRONLY);
    284c:	20100593          	li	a1,513
    2850:	00048513          	mv	a0,s1
    2854:	009030ef          	jal	605c <open>
  if(fd != -1){
    2858:	fff00793          	li	a5,-1
    285c:	08f51a63          	bne	a0,a5,28f0 <copyinstr3+0xfc>
  ret = link(b, b);
    2860:	00048593          	mv	a1,s1
    2864:	00048513          	mv	a0,s1
    2868:	025030ef          	jal	608c <link>
  if(ret != -1){
    286c:	fff00793          	li	a5,-1
    2870:	08f51e63          	bne	a0,a5,290c <copyinstr3+0x118>
  char *args[] = { "xx", 0 };
    2874:	00006797          	auipc	a5,0x6
    2878:	8f478793          	addi	a5,a5,-1804 # 8168 <malloc+0x1a88>
    287c:	fcf43823          	sd	a5,-48(s0)
    2880:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2884:	fd040593          	addi	a1,s0,-48
    2888:	00048513          	mv	a0,s1
    288c:	7c4030ef          	jal	6050 <exec>
  if(ret != -1){
    2890:	fff00793          	li	a5,-1
    2894:	08f51c63          	bne	a0,a5,292c <copyinstr3+0x138>
}
    2898:	02813083          	ld	ra,40(sp)
    289c:	02013403          	ld	s0,32(sp)
    28a0:	01813483          	ld	s1,24(sp)
    28a4:	03010113          	addi	sp,sp,48
    28a8:	00008067          	ret
    sbrk(PGSIZE - (top % PGSIZE));
    28ac:	0347d513          	srli	a0,a5,0x34
    28b0:	000017b7          	lui	a5,0x1
    28b4:	40a7853b          	subw	a0,a5,a0
    28b8:	011030ef          	jal	60c8 <sbrk>
    28bc:	f65ff06f          	j	2820 <copyinstr3+0x2c>
    printf("oops\n");
    28c0:	00005517          	auipc	a0,0x5
    28c4:	bc050513          	addi	a0,a0,-1088 # 7480 <malloc+0xda0>
    28c8:	519030ef          	jal	65e0 <printf>
    exit(1);
    28cc:	00100513          	li	a0,1
    28d0:	72c030ef          	jal	5ffc <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    28d4:	00050613          	mv	a2,a0
    28d8:	00048593          	mv	a1,s1
    28dc:	00004517          	auipc	a0,0x4
    28e0:	75c50513          	addi	a0,a0,1884 # 7038 <malloc+0x958>
    28e4:	4fd030ef          	jal	65e0 <printf>
    exit(1);
    28e8:	00100513          	li	a0,1
    28ec:	710030ef          	jal	5ffc <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    28f0:	00050613          	mv	a2,a0
    28f4:	00048593          	mv	a1,s1
    28f8:	00004517          	auipc	a0,0x4
    28fc:	76050513          	addi	a0,a0,1888 # 7058 <malloc+0x978>
    2900:	4e1030ef          	jal	65e0 <printf>
    exit(1);
    2904:	00100513          	li	a0,1
    2908:	6f4030ef          	jal	5ffc <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    290c:	00050693          	mv	a3,a0
    2910:	00048613          	mv	a2,s1
    2914:	00048593          	mv	a1,s1
    2918:	00004517          	auipc	a0,0x4
    291c:	76050513          	addi	a0,a0,1888 # 7078 <malloc+0x998>
    2920:	4c1030ef          	jal	65e0 <printf>
    exit(1);
    2924:	00100513          	li	a0,1
    2928:	6d4030ef          	jal	5ffc <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    292c:	fff00613          	li	a2,-1
    2930:	00048593          	mv	a1,s1
    2934:	00004517          	auipc	a0,0x4
    2938:	76c50513          	addi	a0,a0,1900 # 70a0 <malloc+0x9c0>
    293c:	4a5030ef          	jal	65e0 <printf>
    exit(1);
    2940:	00100513          	li	a0,1
    2944:	6b8030ef          	jal	5ffc <exit>

0000000000002948 <rwsbrk>:
{
    2948:	fe010113          	addi	sp,sp,-32
    294c:	00113c23          	sd	ra,24(sp)
    2950:	00813823          	sd	s0,16(sp)
    2954:	02010413          	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2958:	00002537          	lui	a0,0x2
    295c:	76c030ef          	jal	60c8 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2960:	fff00793          	li	a5,-1
    2964:	06f50663          	beq	a0,a5,29d0 <rwsbrk+0x88>
    2968:	00913423          	sd	s1,8(sp)
    296c:	00050493          	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2970:	ffffe537          	lui	a0,0xffffe
    2974:	754030ef          	jal	60c8 <sbrk>
    2978:	fff00793          	li	a5,-1
    297c:	06f50863          	beq	a0,a5,29ec <rwsbrk+0xa4>
    2980:	01213023          	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2984:	20100593          	li	a1,513
    2988:	00005517          	auipc	a0,0x5
    298c:	b3850513          	addi	a0,a0,-1224 # 74c0 <malloc+0xde0>
    2990:	6cc030ef          	jal	605c <open>
    2994:	00050913          	mv	s2,a0
  if(fd < 0){
    2998:	06054663          	bltz	a0,2a04 <rwsbrk+0xbc>
  n = write(fd, (void*)(a+4096), 1024);
    299c:	000017b7          	lui	a5,0x1
    29a0:	00f484b3          	add	s1,s1,a5
    29a4:	40000613          	li	a2,1024
    29a8:	00048593          	mv	a1,s1
    29ac:	680030ef          	jal	602c <write>
    29b0:	00050613          	mv	a2,a0
  if(n >= 0){
    29b4:	06054263          	bltz	a0,2a18 <rwsbrk+0xd0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+4096, n);
    29b8:	00048593          	mv	a1,s1
    29bc:	00005517          	auipc	a0,0x5
    29c0:	b2450513          	addi	a0,a0,-1244 # 74e0 <malloc+0xe00>
    29c4:	41d030ef          	jal	65e0 <printf>
    exit(1);
    29c8:	00100513          	li	a0,1
    29cc:	630030ef          	jal	5ffc <exit>
    29d0:	00913423          	sd	s1,8(sp)
    29d4:	01213023          	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    29d8:	00005517          	auipc	a0,0x5
    29dc:	ab050513          	addi	a0,a0,-1360 # 7488 <malloc+0xda8>
    29e0:	401030ef          	jal	65e0 <printf>
    exit(1);
    29e4:	00100513          	li	a0,1
    29e8:	614030ef          	jal	5ffc <exit>
    29ec:	01213023          	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    29f0:	00005517          	auipc	a0,0x5
    29f4:	ab050513          	addi	a0,a0,-1360 # 74a0 <malloc+0xdc0>
    29f8:	3e9030ef          	jal	65e0 <printf>
    exit(1);
    29fc:	00100513          	li	a0,1
    2a00:	5fc030ef          	jal	5ffc <exit>
    printf("open(rwsbrk) failed\n");
    2a04:	00005517          	auipc	a0,0x5
    2a08:	ac450513          	addi	a0,a0,-1340 # 74c8 <malloc+0xde8>
    2a0c:	3d5030ef          	jal	65e0 <printf>
    exit(1);
    2a10:	00100513          	li	a0,1
    2a14:	5e8030ef          	jal	5ffc <exit>
  close(fd);
    2a18:	00090513          	mv	a0,s2
    2a1c:	61c030ef          	jal	6038 <close>
  unlink("rwsbrk");
    2a20:	00005517          	auipc	a0,0x5
    2a24:	aa050513          	addi	a0,a0,-1376 # 74c0 <malloc+0xde0>
    2a28:	64c030ef          	jal	6074 <unlink>
  fd = open("README", O_RDONLY);
    2a2c:	00000593          	li	a1,0
    2a30:	00004517          	auipc	a0,0x4
    2a34:	03050513          	addi	a0,a0,48 # 6a60 <malloc+0x380>
    2a38:	624030ef          	jal	605c <open>
    2a3c:	00050913          	mv	s2,a0
  if(fd < 0){
    2a40:	02054863          	bltz	a0,2a70 <rwsbrk+0x128>
  n = read(fd, (void*)(a+4096), 10);
    2a44:	00a00613          	li	a2,10
    2a48:	00048593          	mv	a1,s1
    2a4c:	5d4030ef          	jal	6020 <read>
    2a50:	00050613          	mv	a2,a0
  if(n >= 0){
    2a54:	02054863          	bltz	a0,2a84 <rwsbrk+0x13c>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+4096, n);
    2a58:	00048593          	mv	a1,s1
    2a5c:	00005517          	auipc	a0,0x5
    2a60:	ab450513          	addi	a0,a0,-1356 # 7510 <malloc+0xe30>
    2a64:	37d030ef          	jal	65e0 <printf>
    exit(1);
    2a68:	00100513          	li	a0,1
    2a6c:	590030ef          	jal	5ffc <exit>
    printf("open(rwsbrk) failed\n");
    2a70:	00005517          	auipc	a0,0x5
    2a74:	a5850513          	addi	a0,a0,-1448 # 74c8 <malloc+0xde8>
    2a78:	369030ef          	jal	65e0 <printf>
    exit(1);
    2a7c:	00100513          	li	a0,1
    2a80:	57c030ef          	jal	5ffc <exit>
  close(fd);
    2a84:	00090513          	mv	a0,s2
    2a88:	5b0030ef          	jal	6038 <close>
  exit(0);
    2a8c:	00000513          	li	a0,0
    2a90:	56c030ef          	jal	5ffc <exit>

0000000000002a94 <sbrkbasic>:
{
    2a94:	fc010113          	addi	sp,sp,-64
    2a98:	02113c23          	sd	ra,56(sp)
    2a9c:	02813823          	sd	s0,48(sp)
    2aa0:	01313c23          	sd	s3,24(sp)
    2aa4:	04010413          	addi	s0,sp,64
    2aa8:	00050993          	mv	s3,a0
  pid = fork();
    2aac:	544030ef          	jal	5ff0 <fork>
  if(pid < 0){
    2ab0:	04054463          	bltz	a0,2af8 <sbrkbasic+0x64>
  if(pid == 0){
    2ab4:	06051c63          	bnez	a0,2b2c <sbrkbasic+0x98>
    a = sbrk(TOOMUCH);
    2ab8:	40000537          	lui	a0,0x40000
    2abc:	60c030ef          	jal	60c8 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2ac0:	fff00793          	li	a5,-1
    2ac4:	04f50a63          	beq	a0,a5,2b18 <sbrkbasic+0x84>
    2ac8:	02913423          	sd	s1,40(sp)
    2acc:	03213023          	sd	s2,32(sp)
    2ad0:	01413823          	sd	s4,16(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    2ad4:	400007b7          	lui	a5,0x40000
    2ad8:	00f507b3          	add	a5,a0,a5
      *b = 99;
    2adc:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2ae0:	00001737          	lui	a4,0x1
      *b = 99;
    2ae4:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2ae8:	00e50533          	add	a0,a0,a4
    2aec:	fef51ce3          	bne	a0,a5,2ae4 <sbrkbasic+0x50>
    exit(1);
    2af0:	00100513          	li	a0,1
    2af4:	508030ef          	jal	5ffc <exit>
    2af8:	02913423          	sd	s1,40(sp)
    2afc:	03213023          	sd	s2,32(sp)
    2b00:	01413823          	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    2b04:	00005517          	auipc	a0,0x5
    2b08:	a3450513          	addi	a0,a0,-1484 # 7538 <malloc+0xe58>
    2b0c:	2d5030ef          	jal	65e0 <printf>
    exit(1);
    2b10:	00100513          	li	a0,1
    2b14:	4e8030ef          	jal	5ffc <exit>
    2b18:	02913423          	sd	s1,40(sp)
    2b1c:	03213023          	sd	s2,32(sp)
    2b20:	01413823          	sd	s4,16(sp)
      exit(0);
    2b24:	00000513          	li	a0,0
    2b28:	4d4030ef          	jal	5ffc <exit>
  wait(&xstatus);
    2b2c:	fcc40513          	addi	a0,s0,-52
    2b30:	4d8030ef          	jal	6008 <wait>
  if(xstatus == 1){
    2b34:	fcc42703          	lw	a4,-52(s0)
    2b38:	00100793          	li	a5,1
    2b3c:	02f70663          	beq	a4,a5,2b68 <sbrkbasic+0xd4>
    2b40:	02913423          	sd	s1,40(sp)
    2b44:	03213023          	sd	s2,32(sp)
    2b48:	01413823          	sd	s4,16(sp)
  a = sbrk(0);
    2b4c:	00000513          	li	a0,0
    2b50:	578030ef          	jal	60c8 <sbrk>
    2b54:	00050493          	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2b58:	00000913          	li	s2,0
    2b5c:	00001a37          	lui	s4,0x1
    2b60:	388a0a13          	addi	s4,s4,904 # 1388 <bigdir+0xa8>
    2b64:	02c0006f          	j	2b90 <sbrkbasic+0xfc>
    2b68:	02913423          	sd	s1,40(sp)
    2b6c:	03213023          	sd	s2,32(sp)
    2b70:	01413823          	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    2b74:	00098593          	mv	a1,s3
    2b78:	00005517          	auipc	a0,0x5
    2b7c:	9e050513          	addi	a0,a0,-1568 # 7558 <malloc+0xe78>
    2b80:	261030ef          	jal	65e0 <printf>
    exit(1);
    2b84:	00100513          	li	a0,1
    2b88:	474030ef          	jal	5ffc <exit>
    2b8c:	00078493          	mv	s1,a5
    b = sbrk(1);
    2b90:	00100513          	li	a0,1
    2b94:	534030ef          	jal	60c8 <sbrk>
    if(b != a){
    2b98:	04951a63          	bne	a0,s1,2bec <sbrkbasic+0x158>
    *b = 1;
    2b9c:	00100793          	li	a5,1
    2ba0:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2ba4:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2ba8:	0019091b          	addiw	s2,s2,1
    2bac:	ff4910e3          	bne	s2,s4,2b8c <sbrkbasic+0xf8>
  pid = fork();
    2bb0:	440030ef          	jal	5ff0 <fork>
    2bb4:	00050913          	mv	s2,a0
  if(pid < 0){
    2bb8:	04054c63          	bltz	a0,2c10 <sbrkbasic+0x17c>
  c = sbrk(1);
    2bbc:	00100513          	li	a0,1
    2bc0:	508030ef          	jal	60c8 <sbrk>
  c = sbrk(1);
    2bc4:	00100513          	li	a0,1
    2bc8:	500030ef          	jal	60c8 <sbrk>
  if(c != a + 1){
    2bcc:	00248493          	addi	s1,s1,2
    2bd0:	04a48c63          	beq	s1,a0,2c28 <sbrkbasic+0x194>
    printf("%s: sbrk test failed post-fork\n", s);
    2bd4:	00098593          	mv	a1,s3
    2bd8:	00005517          	auipc	a0,0x5
    2bdc:	9e050513          	addi	a0,a0,-1568 # 75b8 <malloc+0xed8>
    2be0:	201030ef          	jal	65e0 <printf>
    exit(1);
    2be4:	00100513          	li	a0,1
    2be8:	414030ef          	jal	5ffc <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    2bec:	00050713          	mv	a4,a0
    2bf0:	00048693          	mv	a3,s1
    2bf4:	00090613          	mv	a2,s2
    2bf8:	00098593          	mv	a1,s3
    2bfc:	00005517          	auipc	a0,0x5
    2c00:	97c50513          	addi	a0,a0,-1668 # 7578 <malloc+0xe98>
    2c04:	1dd030ef          	jal	65e0 <printf>
      exit(1);
    2c08:	00100513          	li	a0,1
    2c0c:	3f0030ef          	jal	5ffc <exit>
    printf("%s: sbrk test fork failed\n", s);
    2c10:	00098593          	mv	a1,s3
    2c14:	00005517          	auipc	a0,0x5
    2c18:	98450513          	addi	a0,a0,-1660 # 7598 <malloc+0xeb8>
    2c1c:	1c5030ef          	jal	65e0 <printf>
    exit(1);
    2c20:	00100513          	li	a0,1
    2c24:	3d8030ef          	jal	5ffc <exit>
  if(pid == 0)
    2c28:	00091663          	bnez	s2,2c34 <sbrkbasic+0x1a0>
    exit(0);
    2c2c:	00000513          	li	a0,0
    2c30:	3cc030ef          	jal	5ffc <exit>
  wait(&xstatus);
    2c34:	fcc40513          	addi	a0,s0,-52
    2c38:	3d0030ef          	jal	6008 <wait>
  exit(xstatus);
    2c3c:	fcc42503          	lw	a0,-52(s0)
    2c40:	3bc030ef          	jal	5ffc <exit>

0000000000002c44 <sbrkmuch>:
{
    2c44:	fd010113          	addi	sp,sp,-48
    2c48:	02113423          	sd	ra,40(sp)
    2c4c:	02813023          	sd	s0,32(sp)
    2c50:	00913c23          	sd	s1,24(sp)
    2c54:	01213823          	sd	s2,16(sp)
    2c58:	01313423          	sd	s3,8(sp)
    2c5c:	01413023          	sd	s4,0(sp)
    2c60:	03010413          	addi	s0,sp,48
    2c64:	00050993          	mv	s3,a0
  oldbrk = sbrk(0);
    2c68:	00000513          	li	a0,0
    2c6c:	45c030ef          	jal	60c8 <sbrk>
    2c70:	00050913          	mv	s2,a0
  a = sbrk(0);
    2c74:	00000513          	li	a0,0
    2c78:	450030ef          	jal	60c8 <sbrk>
    2c7c:	00050493          	mv	s1,a0
  p = sbrk(amt);
    2c80:	06400537          	lui	a0,0x6400
    2c84:	4095053b          	subw	a0,a0,s1
    2c88:	440030ef          	jal	60c8 <sbrk>
  if (p != a) {
    2c8c:	0ea49263          	bne	s1,a0,2d70 <sbrkmuch+0x12c>
  char *eee = sbrk(0);
    2c90:	00000513          	li	a0,0
    2c94:	434030ef          	jal	60c8 <sbrk>
    2c98:	00050793          	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2c9c:	00a4fc63          	bgeu	s1,a0,2cb4 <sbrkmuch+0x70>
    *pp = 1;
    2ca0:	00100693          	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2ca4:	00001737          	lui	a4,0x1
    *pp = 1;
    2ca8:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2cac:	00e484b3          	add	s1,s1,a4
    2cb0:	fef4ece3          	bltu	s1,a5,2ca8 <sbrkmuch+0x64>
  *lastaddr = 99;
    2cb4:	064007b7          	lui	a5,0x6400
    2cb8:	06300713          	li	a4,99
    2cbc:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2cc0:	00000513          	li	a0,0
    2cc4:	404030ef          	jal	60c8 <sbrk>
    2cc8:	00050493          	mv	s1,a0
  c = sbrk(-PGSIZE);
    2ccc:	fffff537          	lui	a0,0xfffff
    2cd0:	3f8030ef          	jal	60c8 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2cd4:	fff00793          	li	a5,-1
    2cd8:	0af50863          	beq	a0,a5,2d88 <sbrkmuch+0x144>
  c = sbrk(0);
    2cdc:	00000513          	li	a0,0
    2ce0:	3e8030ef          	jal	60c8 <sbrk>
  if(c != a - PGSIZE){
    2ce4:	fffff7b7          	lui	a5,0xfffff
    2ce8:	00f487b3          	add	a5,s1,a5
    2cec:	0af51a63          	bne	a0,a5,2da0 <sbrkmuch+0x15c>
  a = sbrk(0);
    2cf0:	00000513          	li	a0,0
    2cf4:	3d4030ef          	jal	60c8 <sbrk>
    2cf8:	00050493          	mv	s1,a0
  c = sbrk(PGSIZE);
    2cfc:	00001537          	lui	a0,0x1
    2d00:	3c8030ef          	jal	60c8 <sbrk>
    2d04:	00050a13          	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2d08:	0aa49c63          	bne	s1,a0,2dc0 <sbrkmuch+0x17c>
    2d0c:	00000513          	li	a0,0
    2d10:	3b8030ef          	jal	60c8 <sbrk>
    2d14:	000017b7          	lui	a5,0x1
    2d18:	00f487b3          	add	a5,s1,a5
    2d1c:	0af51263          	bne	a0,a5,2dc0 <sbrkmuch+0x17c>
  if(*lastaddr == 99){
    2d20:	064007b7          	lui	a5,0x6400
    2d24:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2d28:	06300793          	li	a5,99
    2d2c:	0af70a63          	beq	a4,a5,2de0 <sbrkmuch+0x19c>
  a = sbrk(0);
    2d30:	00000513          	li	a0,0
    2d34:	394030ef          	jal	60c8 <sbrk>
    2d38:	00050493          	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2d3c:	00000513          	li	a0,0
    2d40:	388030ef          	jal	60c8 <sbrk>
    2d44:	40a9053b          	subw	a0,s2,a0
    2d48:	380030ef          	jal	60c8 <sbrk>
  if(c != a){
    2d4c:	0aa49663          	bne	s1,a0,2df8 <sbrkmuch+0x1b4>
}
    2d50:	02813083          	ld	ra,40(sp)
    2d54:	02013403          	ld	s0,32(sp)
    2d58:	01813483          	ld	s1,24(sp)
    2d5c:	01013903          	ld	s2,16(sp)
    2d60:	00813983          	ld	s3,8(sp)
    2d64:	00013a03          	ld	s4,0(sp)
    2d68:	03010113          	addi	sp,sp,48
    2d6c:	00008067          	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2d70:	00098593          	mv	a1,s3
    2d74:	00005517          	auipc	a0,0x5
    2d78:	86450513          	addi	a0,a0,-1948 # 75d8 <malloc+0xef8>
    2d7c:	065030ef          	jal	65e0 <printf>
    exit(1);
    2d80:	00100513          	li	a0,1
    2d84:	278030ef          	jal	5ffc <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2d88:	00098593          	mv	a1,s3
    2d8c:	00005517          	auipc	a0,0x5
    2d90:	89450513          	addi	a0,a0,-1900 # 7620 <malloc+0xf40>
    2d94:	04d030ef          	jal	65e0 <printf>
    exit(1);
    2d98:	00100513          	li	a0,1
    2d9c:	260030ef          	jal	5ffc <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    2da0:	00050693          	mv	a3,a0
    2da4:	00048613          	mv	a2,s1
    2da8:	00098593          	mv	a1,s3
    2dac:	00005517          	auipc	a0,0x5
    2db0:	89450513          	addi	a0,a0,-1900 # 7640 <malloc+0xf60>
    2db4:	02d030ef          	jal	65e0 <printf>
    exit(1);
    2db8:	00100513          	li	a0,1
    2dbc:	240030ef          	jal	5ffc <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    2dc0:	000a0693          	mv	a3,s4
    2dc4:	00048613          	mv	a2,s1
    2dc8:	00098593          	mv	a1,s3
    2dcc:	00005517          	auipc	a0,0x5
    2dd0:	8b450513          	addi	a0,a0,-1868 # 7680 <malloc+0xfa0>
    2dd4:	00d030ef          	jal	65e0 <printf>
    exit(1);
    2dd8:	00100513          	li	a0,1
    2ddc:	220030ef          	jal	5ffc <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2de0:	00098593          	mv	a1,s3
    2de4:	00005517          	auipc	a0,0x5
    2de8:	8cc50513          	addi	a0,a0,-1844 # 76b0 <malloc+0xfd0>
    2dec:	7f4030ef          	jal	65e0 <printf>
    exit(1);
    2df0:	00100513          	li	a0,1
    2df4:	208030ef          	jal	5ffc <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2df8:	00050693          	mv	a3,a0
    2dfc:	00048613          	mv	a2,s1
    2e00:	00098593          	mv	a1,s3
    2e04:	00005517          	auipc	a0,0x5
    2e08:	8e450513          	addi	a0,a0,-1820 # 76e8 <malloc+0x1008>
    2e0c:	7d4030ef          	jal	65e0 <printf>
    exit(1);
    2e10:	00100513          	li	a0,1
    2e14:	1e8030ef          	jal	5ffc <exit>

0000000000002e18 <sbrkarg>:
{
    2e18:	fd010113          	addi	sp,sp,-48
    2e1c:	02113423          	sd	ra,40(sp)
    2e20:	02813023          	sd	s0,32(sp)
    2e24:	00913c23          	sd	s1,24(sp)
    2e28:	01213823          	sd	s2,16(sp)
    2e2c:	01313423          	sd	s3,8(sp)
    2e30:	03010413          	addi	s0,sp,48
    2e34:	00050993          	mv	s3,a0
  a = sbrk(PGSIZE);
    2e38:	00001537          	lui	a0,0x1
    2e3c:	28c030ef          	jal	60c8 <sbrk>
    2e40:	00050913          	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2e44:	20100593          	li	a1,513
    2e48:	00005517          	auipc	a0,0x5
    2e4c:	8c850513          	addi	a0,a0,-1848 # 7710 <malloc+0x1030>
    2e50:	20c030ef          	jal	605c <open>
    2e54:	00050493          	mv	s1,a0
  unlink("sbrk");
    2e58:	00005517          	auipc	a0,0x5
    2e5c:	8b850513          	addi	a0,a0,-1864 # 7710 <malloc+0x1030>
    2e60:	214030ef          	jal	6074 <unlink>
  if(fd < 0)  {
    2e64:	0404c663          	bltz	s1,2eb0 <sbrkarg+0x98>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2e68:	00001637          	lui	a2,0x1
    2e6c:	00090593          	mv	a1,s2
    2e70:	00048513          	mv	a0,s1
    2e74:	1b8030ef          	jal	602c <write>
    2e78:	04054863          	bltz	a0,2ec8 <sbrkarg+0xb0>
  close(fd);
    2e7c:	00048513          	mv	a0,s1
    2e80:	1b8030ef          	jal	6038 <close>
  a = sbrk(PGSIZE);
    2e84:	00001537          	lui	a0,0x1
    2e88:	240030ef          	jal	60c8 <sbrk>
  if(pipe((int *) a) != 0){
    2e8c:	188030ef          	jal	6014 <pipe>
    2e90:	04051863          	bnez	a0,2ee0 <sbrkarg+0xc8>
}
    2e94:	02813083          	ld	ra,40(sp)
    2e98:	02013403          	ld	s0,32(sp)
    2e9c:	01813483          	ld	s1,24(sp)
    2ea0:	01013903          	ld	s2,16(sp)
    2ea4:	00813983          	ld	s3,8(sp)
    2ea8:	03010113          	addi	sp,sp,48
    2eac:	00008067          	ret
    printf("%s: open sbrk failed\n", s);
    2eb0:	00098593          	mv	a1,s3
    2eb4:	00005517          	auipc	a0,0x5
    2eb8:	86450513          	addi	a0,a0,-1948 # 7718 <malloc+0x1038>
    2ebc:	724030ef          	jal	65e0 <printf>
    exit(1);
    2ec0:	00100513          	li	a0,1
    2ec4:	138030ef          	jal	5ffc <exit>
    printf("%s: write sbrk failed\n", s);
    2ec8:	00098593          	mv	a1,s3
    2ecc:	00005517          	auipc	a0,0x5
    2ed0:	86450513          	addi	a0,a0,-1948 # 7730 <malloc+0x1050>
    2ed4:	70c030ef          	jal	65e0 <printf>
    exit(1);
    2ed8:	00100513          	li	a0,1
    2edc:	120030ef          	jal	5ffc <exit>
    printf("%s: pipe() failed\n", s);
    2ee0:	00098593          	mv	a1,s3
    2ee4:	00004517          	auipc	a0,0x4
    2ee8:	33c50513          	addi	a0,a0,828 # 7220 <malloc+0xb40>
    2eec:	6f4030ef          	jal	65e0 <printf>
    exit(1);
    2ef0:	00100513          	li	a0,1
    2ef4:	108030ef          	jal	5ffc <exit>

0000000000002ef8 <argptest>:
{
    2ef8:	fe010113          	addi	sp,sp,-32
    2efc:	00113c23          	sd	ra,24(sp)
    2f00:	00813823          	sd	s0,16(sp)
    2f04:	00913423          	sd	s1,8(sp)
    2f08:	01213023          	sd	s2,0(sp)
    2f0c:	02010413          	addi	s0,sp,32
    2f10:	00050913          	mv	s2,a0
  fd = open("init", O_RDONLY);
    2f14:	00000593          	li	a1,0
    2f18:	00005517          	auipc	a0,0x5
    2f1c:	83050513          	addi	a0,a0,-2000 # 7748 <malloc+0x1068>
    2f20:	13c030ef          	jal	605c <open>
  if (fd < 0) {
    2f24:	04054063          	bltz	a0,2f64 <argptest+0x6c>
    2f28:	00050493          	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2f2c:	00000513          	li	a0,0
    2f30:	198030ef          	jal	60c8 <sbrk>
    2f34:	fff00613          	li	a2,-1
    2f38:	fff50593          	addi	a1,a0,-1
    2f3c:	00048513          	mv	a0,s1
    2f40:	0e0030ef          	jal	6020 <read>
  close(fd);
    2f44:	00048513          	mv	a0,s1
    2f48:	0f0030ef          	jal	6038 <close>
}
    2f4c:	01813083          	ld	ra,24(sp)
    2f50:	01013403          	ld	s0,16(sp)
    2f54:	00813483          	ld	s1,8(sp)
    2f58:	00013903          	ld	s2,0(sp)
    2f5c:	02010113          	addi	sp,sp,32
    2f60:	00008067          	ret
    printf("%s: open failed\n", s);
    2f64:	00090593          	mv	a1,s2
    2f68:	00004517          	auipc	a0,0x4
    2f6c:	1c850513          	addi	a0,a0,456 # 7130 <malloc+0xa50>
    2f70:	670030ef          	jal	65e0 <printf>
    exit(1);
    2f74:	00100513          	li	a0,1
    2f78:	084030ef          	jal	5ffc <exit>

0000000000002f7c <sbrkbugs>:
{
    2f7c:	ff010113          	addi	sp,sp,-16
    2f80:	00113423          	sd	ra,8(sp)
    2f84:	00813023          	sd	s0,0(sp)
    2f88:	01010413          	addi	s0,sp,16
  int pid = fork();
    2f8c:	064030ef          	jal	5ff0 <fork>
  if(pid < 0){
    2f90:	00054e63          	bltz	a0,2fac <sbrkbugs+0x30>
  if(pid == 0){
    2f94:	02051663          	bnez	a0,2fc0 <sbrkbugs+0x44>
    int sz = (uint64) sbrk(0);
    2f98:	130030ef          	jal	60c8 <sbrk>
    sbrk(-sz);
    2f9c:	40a0053b          	negw	a0,a0
    2fa0:	128030ef          	jal	60c8 <sbrk>
    exit(0);
    2fa4:	00000513          	li	a0,0
    2fa8:	054030ef          	jal	5ffc <exit>
    printf("fork failed\n");
    2fac:	00005517          	auipc	a0,0x5
    2fb0:	6dc50513          	addi	a0,a0,1756 # 8688 <malloc+0x1fa8>
    2fb4:	62c030ef          	jal	65e0 <printf>
    exit(1);
    2fb8:	00100513          	li	a0,1
    2fbc:	040030ef          	jal	5ffc <exit>
  wait(0);
    2fc0:	00000513          	li	a0,0
    2fc4:	044030ef          	jal	6008 <wait>
  pid = fork();
    2fc8:	028030ef          	jal	5ff0 <fork>
  if(pid < 0){
    2fcc:	02054263          	bltz	a0,2ff0 <sbrkbugs+0x74>
  if(pid == 0){
    2fd0:	02051a63          	bnez	a0,3004 <sbrkbugs+0x88>
    int sz = (uint64) sbrk(0);
    2fd4:	0f4030ef          	jal	60c8 <sbrk>
    sbrk(-(sz - 3500));
    2fd8:	000017b7          	lui	a5,0x1
    2fdc:	dac7879b          	addiw	a5,a5,-596 # dac <writebig+0xf8>
    2fe0:	40a7853b          	subw	a0,a5,a0
    2fe4:	0e4030ef          	jal	60c8 <sbrk>
    exit(0);
    2fe8:	00000513          	li	a0,0
    2fec:	010030ef          	jal	5ffc <exit>
    printf("fork failed\n");
    2ff0:	00005517          	auipc	a0,0x5
    2ff4:	69850513          	addi	a0,a0,1688 # 8688 <malloc+0x1fa8>
    2ff8:	5e8030ef          	jal	65e0 <printf>
    exit(1);
    2ffc:	00100513          	li	a0,1
    3000:	7fd020ef          	jal	5ffc <exit>
  wait(0);
    3004:	00000513          	li	a0,0
    3008:	000030ef          	jal	6008 <wait>
  pid = fork();
    300c:	7e5020ef          	jal	5ff0 <fork>
  if(pid < 0){
    3010:	02054663          	bltz	a0,303c <sbrkbugs+0xc0>
  if(pid == 0){
    3014:	02051e63          	bnez	a0,3050 <sbrkbugs+0xd4>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    3018:	0b0030ef          	jal	60c8 <sbrk>
    301c:	0000b7b7          	lui	a5,0xb
    3020:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x298>
    3024:	40a7853b          	subw	a0,a5,a0
    3028:	0a0030ef          	jal	60c8 <sbrk>
    sbrk(-10);
    302c:	ff600513          	li	a0,-10
    3030:	098030ef          	jal	60c8 <sbrk>
    exit(0);
    3034:	00000513          	li	a0,0
    3038:	7c5020ef          	jal	5ffc <exit>
    printf("fork failed\n");
    303c:	00005517          	auipc	a0,0x5
    3040:	64c50513          	addi	a0,a0,1612 # 8688 <malloc+0x1fa8>
    3044:	59c030ef          	jal	65e0 <printf>
    exit(1);
    3048:	00100513          	li	a0,1
    304c:	7b1020ef          	jal	5ffc <exit>
  wait(0);
    3050:	00000513          	li	a0,0
    3054:	7b5020ef          	jal	6008 <wait>
  exit(0);
    3058:	00000513          	li	a0,0
    305c:	7a1020ef          	jal	5ffc <exit>

0000000000003060 <sbrklast>:
{
    3060:	fd010113          	addi	sp,sp,-48
    3064:	02113423          	sd	ra,40(sp)
    3068:	02813023          	sd	s0,32(sp)
    306c:	00913c23          	sd	s1,24(sp)
    3070:	01213823          	sd	s2,16(sp)
    3074:	01313423          	sd	s3,8(sp)
    3078:	01413023          	sd	s4,0(sp)
    307c:	03010413          	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    3080:	00000513          	li	a0,0
    3084:	044030ef          	jal	60c8 <sbrk>
  if((top % 4096) != 0)
    3088:	03451793          	slli	a5,a0,0x34
    308c:	0a079063          	bnez	a5,312c <sbrklast+0xcc>
  sbrk(4096);
    3090:	00001537          	lui	a0,0x1
    3094:	034030ef          	jal	60c8 <sbrk>
  sbrk(10);
    3098:	00a00513          	li	a0,10
    309c:	02c030ef          	jal	60c8 <sbrk>
  sbrk(-20);
    30a0:	fec00513          	li	a0,-20
    30a4:	024030ef          	jal	60c8 <sbrk>
  top = (uint64) sbrk(0);
    30a8:	00000513          	li	a0,0
    30ac:	01c030ef          	jal	60c8 <sbrk>
    30b0:	00050493          	mv	s1,a0
  char *p = (char *) (top - 64);
    30b4:	fc050913          	addi	s2,a0,-64 # fc0 <unlinkread+0x144>
  p[0] = 'x';
    30b8:	07800a13          	li	s4,120
    30bc:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    30c0:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    30c4:	20200593          	li	a1,514
    30c8:	00090513          	mv	a0,s2
    30cc:	791020ef          	jal	605c <open>
    30d0:	00050993          	mv	s3,a0
  write(fd, p, 1);
    30d4:	00100613          	li	a2,1
    30d8:	00090593          	mv	a1,s2
    30dc:	751020ef          	jal	602c <write>
  close(fd);
    30e0:	00098513          	mv	a0,s3
    30e4:	755020ef          	jal	6038 <close>
  fd = open(p, O_RDWR);
    30e8:	00200593          	li	a1,2
    30ec:	00090513          	mv	a0,s2
    30f0:	76d020ef          	jal	605c <open>
  p[0] = '\0';
    30f4:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    30f8:	00100613          	li	a2,1
    30fc:	00090593          	mv	a1,s2
    3100:	721020ef          	jal	6020 <read>
  if(p[0] != 'x')
    3104:	fc04c783          	lbu	a5,-64(s1)
    3108:	03479c63          	bne	a5,s4,3140 <sbrklast+0xe0>
}
    310c:	02813083          	ld	ra,40(sp)
    3110:	02013403          	ld	s0,32(sp)
    3114:	01813483          	ld	s1,24(sp)
    3118:	01013903          	ld	s2,16(sp)
    311c:	00813983          	ld	s3,8(sp)
    3120:	00013a03          	ld	s4,0(sp)
    3124:	03010113          	addi	sp,sp,48
    3128:	00008067          	ret
    sbrk(4096 - (top % 4096));
    312c:	0347d513          	srli	a0,a5,0x34
    3130:	000017b7          	lui	a5,0x1
    3134:	40a7853b          	subw	a0,a5,a0
    3138:	791020ef          	jal	60c8 <sbrk>
    313c:	f55ff06f          	j	3090 <sbrklast+0x30>
    exit(1);
    3140:	00100513          	li	a0,1
    3144:	6b9020ef          	jal	5ffc <exit>

0000000000003148 <sbrk8000>:
{
    3148:	ff010113          	addi	sp,sp,-16
    314c:	00113423          	sd	ra,8(sp)
    3150:	00813023          	sd	s0,0(sp)
    3154:	01010413          	addi	s0,sp,16
  sbrk(0x80000004);
    3158:	80000537          	lui	a0,0x80000
    315c:	00450513          	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    3160:	769020ef          	jal	60c8 <sbrk>
  volatile char *top = sbrk(0);
    3164:	00000513          	li	a0,0
    3168:	761020ef          	jal	60c8 <sbrk>
  *(top-1) = *(top-1) + 1;
    316c:	fff54783          	lbu	a5,-1(a0)
    3170:	0017879b          	addiw	a5,a5,1 # 1001 <unlinkread+0x185>
    3174:	0ff7f793          	zext.b	a5,a5
    3178:	fef50fa3          	sb	a5,-1(a0)
}
    317c:	00813083          	ld	ra,8(sp)
    3180:	00013403          	ld	s0,0(sp)
    3184:	01010113          	addi	sp,sp,16
    3188:	00008067          	ret

000000000000318c <execout>:
{
    318c:	fb010113          	addi	sp,sp,-80
    3190:	04113423          	sd	ra,72(sp)
    3194:	04813023          	sd	s0,64(sp)
    3198:	02913c23          	sd	s1,56(sp)
    319c:	03213823          	sd	s2,48(sp)
    31a0:	03313423          	sd	s3,40(sp)
    31a4:	03413023          	sd	s4,32(sp)
    31a8:	05010413          	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    31ac:	00000913          	li	s2,0
    31b0:	00f00993          	li	s3,15
    int pid = fork();
    31b4:	63d020ef          	jal	5ff0 <fork>
    31b8:	00050493          	mv	s1,a0
    if(pid < 0){
    31bc:	02054063          	bltz	a0,31dc <execout+0x50>
    } else if(pid == 0){
    31c0:	02050863          	beqz	a0,31f0 <execout+0x64>
      wait((int*)0);
    31c4:	00000513          	li	a0,0
    31c8:	641020ef          	jal	6008 <wait>
  for(int avail = 0; avail < 15; avail++){
    31cc:	0019091b          	addiw	s2,s2,1
    31d0:	ff3912e3          	bne	s2,s3,31b4 <execout+0x28>
  exit(0);
    31d4:	00000513          	li	a0,0
    31d8:	625020ef          	jal	5ffc <exit>
      printf("fork failed\n");
    31dc:	00005517          	auipc	a0,0x5
    31e0:	4ac50513          	addi	a0,a0,1196 # 8688 <malloc+0x1fa8>
    31e4:	3fc030ef          	jal	65e0 <printf>
      exit(1);
    31e8:	00100513          	li	a0,1
    31ec:	611020ef          	jal	5ffc <exit>
        if(a == 0xffffffffffffffffLL)
    31f0:	fff00993          	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    31f4:	00100a13          	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    31f8:	00001537          	lui	a0,0x1
    31fc:	6cd020ef          	jal	60c8 <sbrk>
        if(a == 0xffffffffffffffffLL)
    3200:	01350a63          	beq	a0,s3,3214 <execout+0x88>
        *(char*)(a + 4096 - 1) = 1;
    3204:	000017b7          	lui	a5,0x1
    3208:	00a787b3          	add	a5,a5,a0
    320c:	ff478fa3          	sb	s4,-1(a5) # fff <unlinkread+0x183>
      while(1){
    3210:	fe9ff06f          	j	31f8 <execout+0x6c>
      for(int i = 0; i < avail; i++)
    3214:	01205a63          	blez	s2,3228 <execout+0x9c>
        sbrk(-4096);
    3218:	fffff537          	lui	a0,0xfffff
    321c:	6ad020ef          	jal	60c8 <sbrk>
      for(int i = 0; i < avail; i++)
    3220:	0014849b          	addiw	s1,s1,1
    3224:	ff249ae3          	bne	s1,s2,3218 <execout+0x8c>
      close(1);
    3228:	00100513          	li	a0,1
    322c:	60d020ef          	jal	6038 <close>
      char *args[] = { "echo", "x", 0 };
    3230:	00003517          	auipc	a0,0x3
    3234:	65850513          	addi	a0,a0,1624 # 6888 <malloc+0x1a8>
    3238:	faa43c23          	sd	a0,-72(s0)
    323c:	00003797          	auipc	a5,0x3
    3240:	6bc78793          	addi	a5,a5,1724 # 68f8 <malloc+0x218>
    3244:	fcf43023          	sd	a5,-64(s0)
    3248:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    324c:	fb840593          	addi	a1,s0,-72
    3250:	601020ef          	jal	6050 <exec>
      exit(0);
    3254:	00000513          	li	a0,0
    3258:	5a5020ef          	jal	5ffc <exit>

000000000000325c <fourteen>:
{
    325c:	fe010113          	addi	sp,sp,-32
    3260:	00113c23          	sd	ra,24(sp)
    3264:	00813823          	sd	s0,16(sp)
    3268:	00913423          	sd	s1,8(sp)
    326c:	02010413          	addi	s0,sp,32
    3270:	00050493          	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    3274:	00004517          	auipc	a0,0x4
    3278:	6ac50513          	addi	a0,a0,1708 # 7920 <malloc+0x1240>
    327c:	61d020ef          	jal	6098 <mkdir>
    3280:	0c051063          	bnez	a0,3340 <fourteen+0xe4>
  if(mkdir("12345678901234/123456789012345") != 0){
    3284:	00004517          	auipc	a0,0x4
    3288:	4f450513          	addi	a0,a0,1268 # 7778 <malloc+0x1098>
    328c:	60d020ef          	jal	6098 <mkdir>
    3290:	0c051463          	bnez	a0,3358 <fourteen+0xfc>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3294:	20000593          	li	a1,512
    3298:	00004517          	auipc	a0,0x4
    329c:	53850513          	addi	a0,a0,1336 # 77d0 <malloc+0x10f0>
    32a0:	5bd020ef          	jal	605c <open>
  if(fd < 0){
    32a4:	0c054663          	bltz	a0,3370 <fourteen+0x114>
  close(fd);
    32a8:	591020ef          	jal	6038 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    32ac:	00000593          	li	a1,0
    32b0:	00004517          	auipc	a0,0x4
    32b4:	59850513          	addi	a0,a0,1432 # 7848 <malloc+0x1168>
    32b8:	5a5020ef          	jal	605c <open>
  if(fd < 0){
    32bc:	0c054663          	bltz	a0,3388 <fourteen+0x12c>
  close(fd);
    32c0:	579020ef          	jal	6038 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    32c4:	00004517          	auipc	a0,0x4
    32c8:	5f450513          	addi	a0,a0,1524 # 78b8 <malloc+0x11d8>
    32cc:	5cd020ef          	jal	6098 <mkdir>
    32d0:	0c050863          	beqz	a0,33a0 <fourteen+0x144>
  if(mkdir("123456789012345/12345678901234") == 0){
    32d4:	00004517          	auipc	a0,0x4
    32d8:	63c50513          	addi	a0,a0,1596 # 7910 <malloc+0x1230>
    32dc:	5bd020ef          	jal	6098 <mkdir>
    32e0:	0c050c63          	beqz	a0,33b8 <fourteen+0x15c>
  unlink("123456789012345/12345678901234");
    32e4:	00004517          	auipc	a0,0x4
    32e8:	62c50513          	addi	a0,a0,1580 # 7910 <malloc+0x1230>
    32ec:	589020ef          	jal	6074 <unlink>
  unlink("12345678901234/12345678901234");
    32f0:	00004517          	auipc	a0,0x4
    32f4:	5c850513          	addi	a0,a0,1480 # 78b8 <malloc+0x11d8>
    32f8:	57d020ef          	jal	6074 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    32fc:	00004517          	auipc	a0,0x4
    3300:	54c50513          	addi	a0,a0,1356 # 7848 <malloc+0x1168>
    3304:	571020ef          	jal	6074 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    3308:	00004517          	auipc	a0,0x4
    330c:	4c850513          	addi	a0,a0,1224 # 77d0 <malloc+0x10f0>
    3310:	565020ef          	jal	6074 <unlink>
  unlink("12345678901234/123456789012345");
    3314:	00004517          	auipc	a0,0x4
    3318:	46450513          	addi	a0,a0,1124 # 7778 <malloc+0x1098>
    331c:	559020ef          	jal	6074 <unlink>
  unlink("12345678901234");
    3320:	00004517          	auipc	a0,0x4
    3324:	60050513          	addi	a0,a0,1536 # 7920 <malloc+0x1240>
    3328:	54d020ef          	jal	6074 <unlink>
}
    332c:	01813083          	ld	ra,24(sp)
    3330:	01013403          	ld	s0,16(sp)
    3334:	00813483          	ld	s1,8(sp)
    3338:	02010113          	addi	sp,sp,32
    333c:	00008067          	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3340:	00048593          	mv	a1,s1
    3344:	00004517          	auipc	a0,0x4
    3348:	40c50513          	addi	a0,a0,1036 # 7750 <malloc+0x1070>
    334c:	294030ef          	jal	65e0 <printf>
    exit(1);
    3350:	00100513          	li	a0,1
    3354:	4a9020ef          	jal	5ffc <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    3358:	00048593          	mv	a1,s1
    335c:	00004517          	auipc	a0,0x4
    3360:	43c50513          	addi	a0,a0,1084 # 7798 <malloc+0x10b8>
    3364:	27c030ef          	jal	65e0 <printf>
    exit(1);
    3368:	00100513          	li	a0,1
    336c:	491020ef          	jal	5ffc <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    3370:	00048593          	mv	a1,s1
    3374:	00004517          	auipc	a0,0x4
    3378:	48c50513          	addi	a0,a0,1164 # 7800 <malloc+0x1120>
    337c:	264030ef          	jal	65e0 <printf>
    exit(1);
    3380:	00100513          	li	a0,1
    3384:	479020ef          	jal	5ffc <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3388:	00048593          	mv	a1,s1
    338c:	00004517          	auipc	a0,0x4
    3390:	4ec50513          	addi	a0,a0,1260 # 7878 <malloc+0x1198>
    3394:	24c030ef          	jal	65e0 <printf>
    exit(1);
    3398:	00100513          	li	a0,1
    339c:	461020ef          	jal	5ffc <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    33a0:	00048593          	mv	a1,s1
    33a4:	00004517          	auipc	a0,0x4
    33a8:	53450513          	addi	a0,a0,1332 # 78d8 <malloc+0x11f8>
    33ac:	234030ef          	jal	65e0 <printf>
    exit(1);
    33b0:	00100513          	li	a0,1
    33b4:	449020ef          	jal	5ffc <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    33b8:	00048593          	mv	a1,s1
    33bc:	00004517          	auipc	a0,0x4
    33c0:	57450513          	addi	a0,a0,1396 # 7930 <malloc+0x1250>
    33c4:	21c030ef          	jal	65e0 <printf>
    exit(1);
    33c8:	00100513          	li	a0,1
    33cc:	431020ef          	jal	5ffc <exit>

00000000000033d0 <diskfull>:
{
    33d0:	b8010113          	addi	sp,sp,-1152
    33d4:	46113c23          	sd	ra,1144(sp)
    33d8:	46813823          	sd	s0,1136(sp)
    33dc:	46913423          	sd	s1,1128(sp)
    33e0:	47213023          	sd	s2,1120(sp)
    33e4:	45313c23          	sd	s3,1112(sp)
    33e8:	45413823          	sd	s4,1104(sp)
    33ec:	45513423          	sd	s5,1096(sp)
    33f0:	45613023          	sd	s6,1088(sp)
    33f4:	43713c23          	sd	s7,1080(sp)
    33f8:	43813823          	sd	s8,1072(sp)
    33fc:	43913423          	sd	s9,1064(sp)
    3400:	48010413          	addi	s0,sp,1152
    3404:	00050c93          	mv	s9,a0
  unlink("diskfulldir");
    3408:	00004517          	auipc	a0,0x4
    340c:	56050513          	addi	a0,a0,1376 # 7968 <malloc+0x1288>
    3410:	465020ef          	jal	6074 <unlink>
    3414:	03000993          	li	s3,48
    name[0] = 'b';
    3418:	06200b13          	li	s6,98
    name[1] = 'i';
    341c:	06900a93          	li	s5,105
    name[2] = 'g';
    3420:	06700a13          	li	s4,103
    3424:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    3428:	07f00c13          	li	s8,127
    342c:	1800006f          	j	35ac <diskfull+0x1dc>
      printf("%s: could not create file %s\n", s, name);
    3430:	b8040613          	addi	a2,s0,-1152
    3434:	000c8593          	mv	a1,s9
    3438:	00004517          	auipc	a0,0x4
    343c:	54050513          	addi	a0,a0,1344 # 7978 <malloc+0x1298>
    3440:	1a0030ef          	jal	65e0 <printf>
      break;
    3444:	0140006f          	j	3458 <diskfull+0x88>
        close(fd);
    3448:	00090513          	mv	a0,s2
    344c:	3ed020ef          	jal	6038 <close>
    close(fd);
    3450:	00090513          	mv	a0,s2
    3454:	3e5020ef          	jal	6038 <close>
  for(int i = 0; i < nzz; i++){
    3458:	00000493          	li	s1,0
    name[0] = 'z';
    345c:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3460:	08000993          	li	s3,128
    name[0] = 'z';
    3464:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    3468:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    346c:	41f4d71b          	sraiw	a4,s1,0x1f
    3470:	01b7571b          	srliw	a4,a4,0x1b
    3474:	009707bb          	addw	a5,a4,s1
    3478:	4057d69b          	sraiw	a3,a5,0x5
    347c:	0306869b          	addiw	a3,a3,48
    3480:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    3484:	01f7f793          	andi	a5,a5,31
    3488:	40e787bb          	subw	a5,a5,a4
    348c:	0307879b          	addiw	a5,a5,48
    3490:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    3494:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    3498:	ba040513          	addi	a0,s0,-1120
    349c:	3d9020ef          	jal	6074 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    34a0:	60200593          	li	a1,1538
    34a4:	ba040513          	addi	a0,s0,-1120
    34a8:	3b5020ef          	jal	605c <open>
    if(fd < 0)
    34ac:	00054863          	bltz	a0,34bc <diskfull+0xec>
    close(fd);
    34b0:	389020ef          	jal	6038 <close>
  for(int i = 0; i < nzz; i++){
    34b4:	0014849b          	addiw	s1,s1,1
    34b8:	fb3496e3          	bne	s1,s3,3464 <diskfull+0x94>
  if(mkdir("diskfulldir") == 0)
    34bc:	00004517          	auipc	a0,0x4
    34c0:	4ac50513          	addi	a0,a0,1196 # 7968 <malloc+0x1288>
    34c4:	3d5020ef          	jal	6098 <mkdir>
    34c8:	12050e63          	beqz	a0,3604 <diskfull+0x234>
  unlink("diskfulldir");
    34cc:	00004517          	auipc	a0,0x4
    34d0:	49c50513          	addi	a0,a0,1180 # 7968 <malloc+0x1288>
    34d4:	3a1020ef          	jal	6074 <unlink>
  for(int i = 0; i < nzz; i++){
    34d8:	00000493          	li	s1,0
    name[0] = 'z';
    34dc:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    34e0:	08000993          	li	s3,128
    name[0] = 'z';
    34e4:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    34e8:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    34ec:	41f4d71b          	sraiw	a4,s1,0x1f
    34f0:	01b7571b          	srliw	a4,a4,0x1b
    34f4:	009707bb          	addw	a5,a4,s1
    34f8:	4057d69b          	sraiw	a3,a5,0x5
    34fc:	0306869b          	addiw	a3,a3,48
    3500:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    3504:	01f7f793          	andi	a5,a5,31
    3508:	40e787bb          	subw	a5,a5,a4
    350c:	0307879b          	addiw	a5,a5,48
    3510:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    3514:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    3518:	ba040513          	addi	a0,s0,-1120
    351c:	359020ef          	jal	6074 <unlink>
  for(int i = 0; i < nzz; i++){
    3520:	0014849b          	addiw	s1,s1,1
    3524:	fd3490e3          	bne	s1,s3,34e4 <diskfull+0x114>
    3528:	03000493          	li	s1,48
    name[0] = 'b';
    352c:	06200a93          	li	s5,98
    name[1] = 'i';
    3530:	06900a13          	li	s4,105
    name[2] = 'g';
    3534:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    3538:	07f00913          	li	s2,127
    name[0] = 'b';
    353c:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    3540:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    3544:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    3548:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    354c:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    3550:	ba040513          	addi	a0,s0,-1120
    3554:	321020ef          	jal	6074 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    3558:	0014849b          	addiw	s1,s1,1
    355c:	0ff4f493          	zext.b	s1,s1
    3560:	fd249ee3          	bne	s1,s2,353c <diskfull+0x16c>
}
    3564:	47813083          	ld	ra,1144(sp)
    3568:	47013403          	ld	s0,1136(sp)
    356c:	46813483          	ld	s1,1128(sp)
    3570:	46013903          	ld	s2,1120(sp)
    3574:	45813983          	ld	s3,1112(sp)
    3578:	45013a03          	ld	s4,1104(sp)
    357c:	44813a83          	ld	s5,1096(sp)
    3580:	44013b03          	ld	s6,1088(sp)
    3584:	43813b83          	ld	s7,1080(sp)
    3588:	43013c03          	ld	s8,1072(sp)
    358c:	42813c83          	ld	s9,1064(sp)
    3590:	48010113          	addi	sp,sp,1152
    3594:	00008067          	ret
    close(fd);
    3598:	00090513          	mv	a0,s2
    359c:	29d020ef          	jal	6038 <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    35a0:	0019899b          	addiw	s3,s3,1
    35a4:	0ff9f993          	zext.b	s3,s3
    35a8:	eb8988e3          	beq	s3,s8,3458 <diskfull+0x88>
    name[0] = 'b';
    35ac:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    35b0:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    35b4:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    35b8:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    35bc:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    35c0:	b8040513          	addi	a0,s0,-1152
    35c4:	2b1020ef          	jal	6074 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    35c8:	60200593          	li	a1,1538
    35cc:	b8040513          	addi	a0,s0,-1152
    35d0:	28d020ef          	jal	605c <open>
    35d4:	00050913          	mv	s2,a0
    if(fd < 0){
    35d8:	e4054ce3          	bltz	a0,3430 <diskfull+0x60>
    35dc:	000b8493          	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    35e0:	40000613          	li	a2,1024
    35e4:	ba040593          	addi	a1,s0,-1120
    35e8:	00090513          	mv	a0,s2
    35ec:	241020ef          	jal	602c <write>
    35f0:	40000793          	li	a5,1024
    35f4:	e4f51ae3          	bne	a0,a5,3448 <diskfull+0x78>
    for(int i = 0; i < MAXFILE; i++){
    35f8:	fff4849b          	addiw	s1,s1,-1
    35fc:	fe0492e3          	bnez	s1,35e0 <diskfull+0x210>
    3600:	f99ff06f          	j	3598 <diskfull+0x1c8>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    3604:	000c8593          	mv	a1,s9
    3608:	00004517          	auipc	a0,0x4
    360c:	39050513          	addi	a0,a0,912 # 7998 <malloc+0x12b8>
    3610:	7d1020ef          	jal	65e0 <printf>
    3614:	eb9ff06f          	j	34cc <diskfull+0xfc>

0000000000003618 <iputtest>:
{
    3618:	fe010113          	addi	sp,sp,-32
    361c:	00113c23          	sd	ra,24(sp)
    3620:	00813823          	sd	s0,16(sp)
    3624:	00913423          	sd	s1,8(sp)
    3628:	02010413          	addi	s0,sp,32
    362c:	00050493          	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3630:	00004517          	auipc	a0,0x4
    3634:	39850513          	addi	a0,a0,920 # 79c8 <malloc+0x12e8>
    3638:	261020ef          	jal	6098 <mkdir>
    363c:	04054463          	bltz	a0,3684 <iputtest+0x6c>
  if(chdir("iputdir") < 0){
    3640:	00004517          	auipc	a0,0x4
    3644:	38850513          	addi	a0,a0,904 # 79c8 <malloc+0x12e8>
    3648:	25d020ef          	jal	60a4 <chdir>
    364c:	04054863          	bltz	a0,369c <iputtest+0x84>
  if(unlink("../iputdir") < 0){
    3650:	00004517          	auipc	a0,0x4
    3654:	3b850513          	addi	a0,a0,952 # 7a08 <malloc+0x1328>
    3658:	21d020ef          	jal	6074 <unlink>
    365c:	04054c63          	bltz	a0,36b4 <iputtest+0x9c>
  if(chdir("/") < 0){
    3660:	00004517          	auipc	a0,0x4
    3664:	3d850513          	addi	a0,a0,984 # 7a38 <malloc+0x1358>
    3668:	23d020ef          	jal	60a4 <chdir>
    366c:	06054063          	bltz	a0,36cc <iputtest+0xb4>
}
    3670:	01813083          	ld	ra,24(sp)
    3674:	01013403          	ld	s0,16(sp)
    3678:	00813483          	ld	s1,8(sp)
    367c:	02010113          	addi	sp,sp,32
    3680:	00008067          	ret
    printf("%s: mkdir failed\n", s);
    3684:	00048593          	mv	a1,s1
    3688:	00004517          	auipc	a0,0x4
    368c:	34850513          	addi	a0,a0,840 # 79d0 <malloc+0x12f0>
    3690:	751020ef          	jal	65e0 <printf>
    exit(1);
    3694:	00100513          	li	a0,1
    3698:	165020ef          	jal	5ffc <exit>
    printf("%s: chdir iputdir failed\n", s);
    369c:	00048593          	mv	a1,s1
    36a0:	00004517          	auipc	a0,0x4
    36a4:	34850513          	addi	a0,a0,840 # 79e8 <malloc+0x1308>
    36a8:	739020ef          	jal	65e0 <printf>
    exit(1);
    36ac:	00100513          	li	a0,1
    36b0:	14d020ef          	jal	5ffc <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    36b4:	00048593          	mv	a1,s1
    36b8:	00004517          	auipc	a0,0x4
    36bc:	36050513          	addi	a0,a0,864 # 7a18 <malloc+0x1338>
    36c0:	721020ef          	jal	65e0 <printf>
    exit(1);
    36c4:	00100513          	li	a0,1
    36c8:	135020ef          	jal	5ffc <exit>
    printf("%s: chdir / failed\n", s);
    36cc:	00048593          	mv	a1,s1
    36d0:	00004517          	auipc	a0,0x4
    36d4:	37050513          	addi	a0,a0,880 # 7a40 <malloc+0x1360>
    36d8:	709020ef          	jal	65e0 <printf>
    exit(1);
    36dc:	00100513          	li	a0,1
    36e0:	11d020ef          	jal	5ffc <exit>

00000000000036e4 <exitiputtest>:
{
    36e4:	fd010113          	addi	sp,sp,-48
    36e8:	02113423          	sd	ra,40(sp)
    36ec:	02813023          	sd	s0,32(sp)
    36f0:	00913c23          	sd	s1,24(sp)
    36f4:	03010413          	addi	s0,sp,48
    36f8:	00050493          	mv	s1,a0
  pid = fork();
    36fc:	0f5020ef          	jal	5ff0 <fork>
  if(pid < 0){
    3700:	04054063          	bltz	a0,3740 <exitiputtest+0x5c>
  if(pid == 0){
    3704:	08051e63          	bnez	a0,37a0 <exitiputtest+0xbc>
    if(mkdir("iputdir") < 0){
    3708:	00004517          	auipc	a0,0x4
    370c:	2c050513          	addi	a0,a0,704 # 79c8 <malloc+0x12e8>
    3710:	189020ef          	jal	6098 <mkdir>
    3714:	04054263          	bltz	a0,3758 <exitiputtest+0x74>
    if(chdir("iputdir") < 0){
    3718:	00004517          	auipc	a0,0x4
    371c:	2b050513          	addi	a0,a0,688 # 79c8 <malloc+0x12e8>
    3720:	185020ef          	jal	60a4 <chdir>
    3724:	04054663          	bltz	a0,3770 <exitiputtest+0x8c>
    if(unlink("../iputdir") < 0){
    3728:	00004517          	auipc	a0,0x4
    372c:	2e050513          	addi	a0,a0,736 # 7a08 <malloc+0x1328>
    3730:	145020ef          	jal	6074 <unlink>
    3734:	04054a63          	bltz	a0,3788 <exitiputtest+0xa4>
    exit(0);
    3738:	00000513          	li	a0,0
    373c:	0c1020ef          	jal	5ffc <exit>
    printf("%s: fork failed\n", s);
    3740:	00048593          	mv	a1,s1
    3744:	00004517          	auipc	a0,0x4
    3748:	9d450513          	addi	a0,a0,-1580 # 7118 <malloc+0xa38>
    374c:	695020ef          	jal	65e0 <printf>
    exit(1);
    3750:	00100513          	li	a0,1
    3754:	0a9020ef          	jal	5ffc <exit>
      printf("%s: mkdir failed\n", s);
    3758:	00048593          	mv	a1,s1
    375c:	00004517          	auipc	a0,0x4
    3760:	27450513          	addi	a0,a0,628 # 79d0 <malloc+0x12f0>
    3764:	67d020ef          	jal	65e0 <printf>
      exit(1);
    3768:	00100513          	li	a0,1
    376c:	091020ef          	jal	5ffc <exit>
      printf("%s: child chdir failed\n", s);
    3770:	00048593          	mv	a1,s1
    3774:	00004517          	auipc	a0,0x4
    3778:	2e450513          	addi	a0,a0,740 # 7a58 <malloc+0x1378>
    377c:	665020ef          	jal	65e0 <printf>
      exit(1);
    3780:	00100513          	li	a0,1
    3784:	079020ef          	jal	5ffc <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3788:	00048593          	mv	a1,s1
    378c:	00004517          	auipc	a0,0x4
    3790:	28c50513          	addi	a0,a0,652 # 7a18 <malloc+0x1338>
    3794:	64d020ef          	jal	65e0 <printf>
      exit(1);
    3798:	00100513          	li	a0,1
    379c:	061020ef          	jal	5ffc <exit>
  wait(&xstatus);
    37a0:	fdc40513          	addi	a0,s0,-36
    37a4:	065020ef          	jal	6008 <wait>
  exit(xstatus);
    37a8:	fdc42503          	lw	a0,-36(s0)
    37ac:	051020ef          	jal	5ffc <exit>

00000000000037b0 <dirtest>:
{
    37b0:	fe010113          	addi	sp,sp,-32
    37b4:	00113c23          	sd	ra,24(sp)
    37b8:	00813823          	sd	s0,16(sp)
    37bc:	00913423          	sd	s1,8(sp)
    37c0:	02010413          	addi	s0,sp,32
    37c4:	00050493          	mv	s1,a0
  if(mkdir("dir0") < 0){
    37c8:	00004517          	auipc	a0,0x4
    37cc:	2a850513          	addi	a0,a0,680 # 7a70 <malloc+0x1390>
    37d0:	0c9020ef          	jal	6098 <mkdir>
    37d4:	04054463          	bltz	a0,381c <dirtest+0x6c>
  if(chdir("dir0") < 0){
    37d8:	00004517          	auipc	a0,0x4
    37dc:	29850513          	addi	a0,a0,664 # 7a70 <malloc+0x1390>
    37e0:	0c5020ef          	jal	60a4 <chdir>
    37e4:	04054863          	bltz	a0,3834 <dirtest+0x84>
  if(chdir("..") < 0){
    37e8:	00004517          	auipc	a0,0x4
    37ec:	2a850513          	addi	a0,a0,680 # 7a90 <malloc+0x13b0>
    37f0:	0b5020ef          	jal	60a4 <chdir>
    37f4:	04054c63          	bltz	a0,384c <dirtest+0x9c>
  if(unlink("dir0") < 0){
    37f8:	00004517          	auipc	a0,0x4
    37fc:	27850513          	addi	a0,a0,632 # 7a70 <malloc+0x1390>
    3800:	075020ef          	jal	6074 <unlink>
    3804:	06054063          	bltz	a0,3864 <dirtest+0xb4>
}
    3808:	01813083          	ld	ra,24(sp)
    380c:	01013403          	ld	s0,16(sp)
    3810:	00813483          	ld	s1,8(sp)
    3814:	02010113          	addi	sp,sp,32
    3818:	00008067          	ret
    printf("%s: mkdir failed\n", s);
    381c:	00048593          	mv	a1,s1
    3820:	00004517          	auipc	a0,0x4
    3824:	1b050513          	addi	a0,a0,432 # 79d0 <malloc+0x12f0>
    3828:	5b9020ef          	jal	65e0 <printf>
    exit(1);
    382c:	00100513          	li	a0,1
    3830:	7cc020ef          	jal	5ffc <exit>
    printf("%s: chdir dir0 failed\n", s);
    3834:	00048593          	mv	a1,s1
    3838:	00004517          	auipc	a0,0x4
    383c:	24050513          	addi	a0,a0,576 # 7a78 <malloc+0x1398>
    3840:	5a1020ef          	jal	65e0 <printf>
    exit(1);
    3844:	00100513          	li	a0,1
    3848:	7b4020ef          	jal	5ffc <exit>
    printf("%s: chdir .. failed\n", s);
    384c:	00048593          	mv	a1,s1
    3850:	00004517          	auipc	a0,0x4
    3854:	24850513          	addi	a0,a0,584 # 7a98 <malloc+0x13b8>
    3858:	589020ef          	jal	65e0 <printf>
    exit(1);
    385c:	00100513          	li	a0,1
    3860:	79c020ef          	jal	5ffc <exit>
    printf("%s: unlink dir0 failed\n", s);
    3864:	00048593          	mv	a1,s1
    3868:	00004517          	auipc	a0,0x4
    386c:	24850513          	addi	a0,a0,584 # 7ab0 <malloc+0x13d0>
    3870:	571020ef          	jal	65e0 <printf>
    exit(1);
    3874:	00100513          	li	a0,1
    3878:	784020ef          	jal	5ffc <exit>

000000000000387c <subdir>:
{
    387c:	fe010113          	addi	sp,sp,-32
    3880:	00113c23          	sd	ra,24(sp)
    3884:	00813823          	sd	s0,16(sp)
    3888:	00913423          	sd	s1,8(sp)
    388c:	01213023          	sd	s2,0(sp)
    3890:	02010413          	addi	s0,sp,32
    3894:	00050913          	mv	s2,a0
  unlink("ff");
    3898:	00004517          	auipc	a0,0x4
    389c:	36050513          	addi	a0,a0,864 # 7bf8 <malloc+0x1518>
    38a0:	7d4020ef          	jal	6074 <unlink>
  if(mkdir("dd") != 0){
    38a4:	00004517          	auipc	a0,0x4
    38a8:	22450513          	addi	a0,a0,548 # 7ac8 <malloc+0x13e8>
    38ac:	7ec020ef          	jal	6098 <mkdir>
    38b0:	30051c63          	bnez	a0,3bc8 <subdir+0x34c>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    38b4:	20200593          	li	a1,514
    38b8:	00004517          	auipc	a0,0x4
    38bc:	23050513          	addi	a0,a0,560 # 7ae8 <malloc+0x1408>
    38c0:	79c020ef          	jal	605c <open>
    38c4:	00050493          	mv	s1,a0
  if(fd < 0){
    38c8:	30054c63          	bltz	a0,3be0 <subdir+0x364>
  write(fd, "ff", 2);
    38cc:	00200613          	li	a2,2
    38d0:	00004597          	auipc	a1,0x4
    38d4:	32858593          	addi	a1,a1,808 # 7bf8 <malloc+0x1518>
    38d8:	754020ef          	jal	602c <write>
  close(fd);
    38dc:	00048513          	mv	a0,s1
    38e0:	758020ef          	jal	6038 <close>
  if(unlink("dd") >= 0){
    38e4:	00004517          	auipc	a0,0x4
    38e8:	1e450513          	addi	a0,a0,484 # 7ac8 <malloc+0x13e8>
    38ec:	788020ef          	jal	6074 <unlink>
    38f0:	30055463          	bgez	a0,3bf8 <subdir+0x37c>
  if(mkdir("/dd/dd") != 0){
    38f4:	00004517          	auipc	a0,0x4
    38f8:	24c50513          	addi	a0,a0,588 # 7b40 <malloc+0x1460>
    38fc:	79c020ef          	jal	6098 <mkdir>
    3900:	30051863          	bnez	a0,3c10 <subdir+0x394>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3904:	20200593          	li	a1,514
    3908:	00004517          	auipc	a0,0x4
    390c:	26050513          	addi	a0,a0,608 # 7b68 <malloc+0x1488>
    3910:	74c020ef          	jal	605c <open>
    3914:	00050493          	mv	s1,a0
  if(fd < 0){
    3918:	30054863          	bltz	a0,3c28 <subdir+0x3ac>
  write(fd, "FF", 2);
    391c:	00200613          	li	a2,2
    3920:	00004597          	auipc	a1,0x4
    3924:	27858593          	addi	a1,a1,632 # 7b98 <malloc+0x14b8>
    3928:	704020ef          	jal	602c <write>
  close(fd);
    392c:	00048513          	mv	a0,s1
    3930:	708020ef          	jal	6038 <close>
  fd = open("dd/dd/../ff", 0);
    3934:	00000593          	li	a1,0
    3938:	00004517          	auipc	a0,0x4
    393c:	26850513          	addi	a0,a0,616 # 7ba0 <malloc+0x14c0>
    3940:	71c020ef          	jal	605c <open>
    3944:	00050493          	mv	s1,a0
  if(fd < 0){
    3948:	2e054c63          	bltz	a0,3c40 <subdir+0x3c4>
  cc = read(fd, buf, sizeof(buf));
    394c:	00003637          	lui	a2,0x3
    3950:	00009597          	auipc	a1,0x9
    3954:	32858593          	addi	a1,a1,808 # cc78 <buf>
    3958:	6c8020ef          	jal	6020 <read>
  if(cc != 2 || buf[0] != 'f'){
    395c:	00200793          	li	a5,2
    3960:	2ef51c63          	bne	a0,a5,3c58 <subdir+0x3dc>
    3964:	00009717          	auipc	a4,0x9
    3968:	31474703          	lbu	a4,788(a4) # cc78 <buf>
    396c:	06600793          	li	a5,102
    3970:	2ef71463          	bne	a4,a5,3c58 <subdir+0x3dc>
  close(fd);
    3974:	00048513          	mv	a0,s1
    3978:	6c0020ef          	jal	6038 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    397c:	00004597          	auipc	a1,0x4
    3980:	27458593          	addi	a1,a1,628 # 7bf0 <malloc+0x1510>
    3984:	00004517          	auipc	a0,0x4
    3988:	1e450513          	addi	a0,a0,484 # 7b68 <malloc+0x1488>
    398c:	700020ef          	jal	608c <link>
    3990:	2e051063          	bnez	a0,3c70 <subdir+0x3f4>
  if(unlink("dd/dd/ff") != 0){
    3994:	00004517          	auipc	a0,0x4
    3998:	1d450513          	addi	a0,a0,468 # 7b68 <malloc+0x1488>
    399c:	6d8020ef          	jal	6074 <unlink>
    39a0:	2e051463          	bnez	a0,3c88 <subdir+0x40c>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    39a4:	00000593          	li	a1,0
    39a8:	00004517          	auipc	a0,0x4
    39ac:	1c050513          	addi	a0,a0,448 # 7b68 <malloc+0x1488>
    39b0:	6ac020ef          	jal	605c <open>
    39b4:	2e055663          	bgez	a0,3ca0 <subdir+0x424>
  if(chdir("dd") != 0){
    39b8:	00004517          	auipc	a0,0x4
    39bc:	11050513          	addi	a0,a0,272 # 7ac8 <malloc+0x13e8>
    39c0:	6e4020ef          	jal	60a4 <chdir>
    39c4:	2e051a63          	bnez	a0,3cb8 <subdir+0x43c>
  if(chdir("dd/../../dd") != 0){
    39c8:	00004517          	auipc	a0,0x4
    39cc:	2c050513          	addi	a0,a0,704 # 7c88 <malloc+0x15a8>
    39d0:	6d4020ef          	jal	60a4 <chdir>
    39d4:	2e051e63          	bnez	a0,3cd0 <subdir+0x454>
  if(chdir("dd/../../../dd") != 0){
    39d8:	00004517          	auipc	a0,0x4
    39dc:	2e050513          	addi	a0,a0,736 # 7cb8 <malloc+0x15d8>
    39e0:	6c4020ef          	jal	60a4 <chdir>
    39e4:	30051263          	bnez	a0,3ce8 <subdir+0x46c>
  if(chdir("./..") != 0){
    39e8:	00004517          	auipc	a0,0x4
    39ec:	30850513          	addi	a0,a0,776 # 7cf0 <malloc+0x1610>
    39f0:	6b4020ef          	jal	60a4 <chdir>
    39f4:	30051663          	bnez	a0,3d00 <subdir+0x484>
  fd = open("dd/dd/ffff", 0);
    39f8:	00000593          	li	a1,0
    39fc:	00004517          	auipc	a0,0x4
    3a00:	1f450513          	addi	a0,a0,500 # 7bf0 <malloc+0x1510>
    3a04:	658020ef          	jal	605c <open>
    3a08:	00050493          	mv	s1,a0
  if(fd < 0){
    3a0c:	30054663          	bltz	a0,3d18 <subdir+0x49c>
  if(read(fd, buf, sizeof(buf)) != 2){
    3a10:	00003637          	lui	a2,0x3
    3a14:	00009597          	auipc	a1,0x9
    3a18:	26458593          	addi	a1,a1,612 # cc78 <buf>
    3a1c:	604020ef          	jal	6020 <read>
    3a20:	00200793          	li	a5,2
    3a24:	30f51663          	bne	a0,a5,3d30 <subdir+0x4b4>
  close(fd);
    3a28:	00048513          	mv	a0,s1
    3a2c:	60c020ef          	jal	6038 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3a30:	00000593          	li	a1,0
    3a34:	00004517          	auipc	a0,0x4
    3a38:	13450513          	addi	a0,a0,308 # 7b68 <malloc+0x1488>
    3a3c:	620020ef          	jal	605c <open>
    3a40:	30055463          	bgez	a0,3d48 <subdir+0x4cc>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3a44:	20200593          	li	a1,514
    3a48:	00004517          	auipc	a0,0x4
    3a4c:	33850513          	addi	a0,a0,824 # 7d80 <malloc+0x16a0>
    3a50:	60c020ef          	jal	605c <open>
    3a54:	30055663          	bgez	a0,3d60 <subdir+0x4e4>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3a58:	20200593          	li	a1,514
    3a5c:	00004517          	auipc	a0,0x4
    3a60:	35450513          	addi	a0,a0,852 # 7db0 <malloc+0x16d0>
    3a64:	5f8020ef          	jal	605c <open>
    3a68:	30055863          	bgez	a0,3d78 <subdir+0x4fc>
  if(open("dd", O_CREATE) >= 0){
    3a6c:	20000593          	li	a1,512
    3a70:	00004517          	auipc	a0,0x4
    3a74:	05850513          	addi	a0,a0,88 # 7ac8 <malloc+0x13e8>
    3a78:	5e4020ef          	jal	605c <open>
    3a7c:	30055a63          	bgez	a0,3d90 <subdir+0x514>
  if(open("dd", O_RDWR) >= 0){
    3a80:	00200593          	li	a1,2
    3a84:	00004517          	auipc	a0,0x4
    3a88:	04450513          	addi	a0,a0,68 # 7ac8 <malloc+0x13e8>
    3a8c:	5d0020ef          	jal	605c <open>
    3a90:	30055c63          	bgez	a0,3da8 <subdir+0x52c>
  if(open("dd", O_WRONLY) >= 0){
    3a94:	00100593          	li	a1,1
    3a98:	00004517          	auipc	a0,0x4
    3a9c:	03050513          	addi	a0,a0,48 # 7ac8 <malloc+0x13e8>
    3aa0:	5bc020ef          	jal	605c <open>
    3aa4:	30055e63          	bgez	a0,3dc0 <subdir+0x544>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3aa8:	00004597          	auipc	a1,0x4
    3aac:	39858593          	addi	a1,a1,920 # 7e40 <malloc+0x1760>
    3ab0:	00004517          	auipc	a0,0x4
    3ab4:	2d050513          	addi	a0,a0,720 # 7d80 <malloc+0x16a0>
    3ab8:	5d4020ef          	jal	608c <link>
    3abc:	30050e63          	beqz	a0,3dd8 <subdir+0x55c>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3ac0:	00004597          	auipc	a1,0x4
    3ac4:	38058593          	addi	a1,a1,896 # 7e40 <malloc+0x1760>
    3ac8:	00004517          	auipc	a0,0x4
    3acc:	2e850513          	addi	a0,a0,744 # 7db0 <malloc+0x16d0>
    3ad0:	5bc020ef          	jal	608c <link>
    3ad4:	30050e63          	beqz	a0,3df0 <subdir+0x574>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3ad8:	00004597          	auipc	a1,0x4
    3adc:	11858593          	addi	a1,a1,280 # 7bf0 <malloc+0x1510>
    3ae0:	00004517          	auipc	a0,0x4
    3ae4:	00850513          	addi	a0,a0,8 # 7ae8 <malloc+0x1408>
    3ae8:	5a4020ef          	jal	608c <link>
    3aec:	30050e63          	beqz	a0,3e08 <subdir+0x58c>
  if(mkdir("dd/ff/ff") == 0){
    3af0:	00004517          	auipc	a0,0x4
    3af4:	29050513          	addi	a0,a0,656 # 7d80 <malloc+0x16a0>
    3af8:	5a0020ef          	jal	6098 <mkdir>
    3afc:	32050263          	beqz	a0,3e20 <subdir+0x5a4>
  if(mkdir("dd/xx/ff") == 0){
    3b00:	00004517          	auipc	a0,0x4
    3b04:	2b050513          	addi	a0,a0,688 # 7db0 <malloc+0x16d0>
    3b08:	590020ef          	jal	6098 <mkdir>
    3b0c:	32050663          	beqz	a0,3e38 <subdir+0x5bc>
  if(mkdir("dd/dd/ffff") == 0){
    3b10:	00004517          	auipc	a0,0x4
    3b14:	0e050513          	addi	a0,a0,224 # 7bf0 <malloc+0x1510>
    3b18:	580020ef          	jal	6098 <mkdir>
    3b1c:	32050a63          	beqz	a0,3e50 <subdir+0x5d4>
  if(unlink("dd/xx/ff") == 0){
    3b20:	00004517          	auipc	a0,0x4
    3b24:	29050513          	addi	a0,a0,656 # 7db0 <malloc+0x16d0>
    3b28:	54c020ef          	jal	6074 <unlink>
    3b2c:	32050e63          	beqz	a0,3e68 <subdir+0x5ec>
  if(unlink("dd/ff/ff") == 0){
    3b30:	00004517          	auipc	a0,0x4
    3b34:	25050513          	addi	a0,a0,592 # 7d80 <malloc+0x16a0>
    3b38:	53c020ef          	jal	6074 <unlink>
    3b3c:	34050263          	beqz	a0,3e80 <subdir+0x604>
  if(chdir("dd/ff") == 0){
    3b40:	00004517          	auipc	a0,0x4
    3b44:	fa850513          	addi	a0,a0,-88 # 7ae8 <malloc+0x1408>
    3b48:	55c020ef          	jal	60a4 <chdir>
    3b4c:	34050663          	beqz	a0,3e98 <subdir+0x61c>
  if(chdir("dd/xx") == 0){
    3b50:	00004517          	auipc	a0,0x4
    3b54:	44050513          	addi	a0,a0,1088 # 7f90 <malloc+0x18b0>
    3b58:	54c020ef          	jal	60a4 <chdir>
    3b5c:	34050a63          	beqz	a0,3eb0 <subdir+0x634>
  if(unlink("dd/dd/ffff") != 0){
    3b60:	00004517          	auipc	a0,0x4
    3b64:	09050513          	addi	a0,a0,144 # 7bf0 <malloc+0x1510>
    3b68:	50c020ef          	jal	6074 <unlink>
    3b6c:	34051e63          	bnez	a0,3ec8 <subdir+0x64c>
  if(unlink("dd/ff") != 0){
    3b70:	00004517          	auipc	a0,0x4
    3b74:	f7850513          	addi	a0,a0,-136 # 7ae8 <malloc+0x1408>
    3b78:	4fc020ef          	jal	6074 <unlink>
    3b7c:	36051263          	bnez	a0,3ee0 <subdir+0x664>
  if(unlink("dd") == 0){
    3b80:	00004517          	auipc	a0,0x4
    3b84:	f4850513          	addi	a0,a0,-184 # 7ac8 <malloc+0x13e8>
    3b88:	4ec020ef          	jal	6074 <unlink>
    3b8c:	36050663          	beqz	a0,3ef8 <subdir+0x67c>
  if(unlink("dd/dd") < 0){
    3b90:	00004517          	auipc	a0,0x4
    3b94:	47050513          	addi	a0,a0,1136 # 8000 <malloc+0x1920>
    3b98:	4dc020ef          	jal	6074 <unlink>
    3b9c:	36054a63          	bltz	a0,3f10 <subdir+0x694>
  if(unlink("dd") < 0){
    3ba0:	00004517          	auipc	a0,0x4
    3ba4:	f2850513          	addi	a0,a0,-216 # 7ac8 <malloc+0x13e8>
    3ba8:	4cc020ef          	jal	6074 <unlink>
    3bac:	36054e63          	bltz	a0,3f28 <subdir+0x6ac>
}
    3bb0:	01813083          	ld	ra,24(sp)
    3bb4:	01013403          	ld	s0,16(sp)
    3bb8:	00813483          	ld	s1,8(sp)
    3bbc:	00013903          	ld	s2,0(sp)
    3bc0:	02010113          	addi	sp,sp,32
    3bc4:	00008067          	ret
    printf("%s: mkdir dd failed\n", s);
    3bc8:	00090593          	mv	a1,s2
    3bcc:	00004517          	auipc	a0,0x4
    3bd0:	f0450513          	addi	a0,a0,-252 # 7ad0 <malloc+0x13f0>
    3bd4:	20d020ef          	jal	65e0 <printf>
    exit(1);
    3bd8:	00100513          	li	a0,1
    3bdc:	420020ef          	jal	5ffc <exit>
    printf("%s: create dd/ff failed\n", s);
    3be0:	00090593          	mv	a1,s2
    3be4:	00004517          	auipc	a0,0x4
    3be8:	f0c50513          	addi	a0,a0,-244 # 7af0 <malloc+0x1410>
    3bec:	1f5020ef          	jal	65e0 <printf>
    exit(1);
    3bf0:	00100513          	li	a0,1
    3bf4:	408020ef          	jal	5ffc <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3bf8:	00090593          	mv	a1,s2
    3bfc:	00004517          	auipc	a0,0x4
    3c00:	f1450513          	addi	a0,a0,-236 # 7b10 <malloc+0x1430>
    3c04:	1dd020ef          	jal	65e0 <printf>
    exit(1);
    3c08:	00100513          	li	a0,1
    3c0c:	3f0020ef          	jal	5ffc <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    3c10:	00090593          	mv	a1,s2
    3c14:	00004517          	auipc	a0,0x4
    3c18:	f3450513          	addi	a0,a0,-204 # 7b48 <malloc+0x1468>
    3c1c:	1c5020ef          	jal	65e0 <printf>
    exit(1);
    3c20:	00100513          	li	a0,1
    3c24:	3d8020ef          	jal	5ffc <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3c28:	00090593          	mv	a1,s2
    3c2c:	00004517          	auipc	a0,0x4
    3c30:	f4c50513          	addi	a0,a0,-180 # 7b78 <malloc+0x1498>
    3c34:	1ad020ef          	jal	65e0 <printf>
    exit(1);
    3c38:	00100513          	li	a0,1
    3c3c:	3c0020ef          	jal	5ffc <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3c40:	00090593          	mv	a1,s2
    3c44:	00004517          	auipc	a0,0x4
    3c48:	f6c50513          	addi	a0,a0,-148 # 7bb0 <malloc+0x14d0>
    3c4c:	195020ef          	jal	65e0 <printf>
    exit(1);
    3c50:	00100513          	li	a0,1
    3c54:	3a8020ef          	jal	5ffc <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3c58:	00090593          	mv	a1,s2
    3c5c:	00004517          	auipc	a0,0x4
    3c60:	f7450513          	addi	a0,a0,-140 # 7bd0 <malloc+0x14f0>
    3c64:	17d020ef          	jal	65e0 <printf>
    exit(1);
    3c68:	00100513          	li	a0,1
    3c6c:	390020ef          	jal	5ffc <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    3c70:	00090593          	mv	a1,s2
    3c74:	00004517          	auipc	a0,0x4
    3c78:	f8c50513          	addi	a0,a0,-116 # 7c00 <malloc+0x1520>
    3c7c:	165020ef          	jal	65e0 <printf>
    exit(1);
    3c80:	00100513          	li	a0,1
    3c84:	378020ef          	jal	5ffc <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3c88:	00090593          	mv	a1,s2
    3c8c:	00004517          	auipc	a0,0x4
    3c90:	f9c50513          	addi	a0,a0,-100 # 7c28 <malloc+0x1548>
    3c94:	14d020ef          	jal	65e0 <printf>
    exit(1);
    3c98:	00100513          	li	a0,1
    3c9c:	360020ef          	jal	5ffc <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3ca0:	00090593          	mv	a1,s2
    3ca4:	00004517          	auipc	a0,0x4
    3ca8:	fa450513          	addi	a0,a0,-92 # 7c48 <malloc+0x1568>
    3cac:	135020ef          	jal	65e0 <printf>
    exit(1);
    3cb0:	00100513          	li	a0,1
    3cb4:	348020ef          	jal	5ffc <exit>
    printf("%s: chdir dd failed\n", s);
    3cb8:	00090593          	mv	a1,s2
    3cbc:	00004517          	auipc	a0,0x4
    3cc0:	fb450513          	addi	a0,a0,-76 # 7c70 <malloc+0x1590>
    3cc4:	11d020ef          	jal	65e0 <printf>
    exit(1);
    3cc8:	00100513          	li	a0,1
    3ccc:	330020ef          	jal	5ffc <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3cd0:	00090593          	mv	a1,s2
    3cd4:	00004517          	auipc	a0,0x4
    3cd8:	fc450513          	addi	a0,a0,-60 # 7c98 <malloc+0x15b8>
    3cdc:	105020ef          	jal	65e0 <printf>
    exit(1);
    3ce0:	00100513          	li	a0,1
    3ce4:	318020ef          	jal	5ffc <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    3ce8:	00090593          	mv	a1,s2
    3cec:	00004517          	auipc	a0,0x4
    3cf0:	fdc50513          	addi	a0,a0,-36 # 7cc8 <malloc+0x15e8>
    3cf4:	0ed020ef          	jal	65e0 <printf>
    exit(1);
    3cf8:	00100513          	li	a0,1
    3cfc:	300020ef          	jal	5ffc <exit>
    printf("%s: chdir ./.. failed\n", s);
    3d00:	00090593          	mv	a1,s2
    3d04:	00004517          	auipc	a0,0x4
    3d08:	ff450513          	addi	a0,a0,-12 # 7cf8 <malloc+0x1618>
    3d0c:	0d5020ef          	jal	65e0 <printf>
    exit(1);
    3d10:	00100513          	li	a0,1
    3d14:	2e8020ef          	jal	5ffc <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3d18:	00090593          	mv	a1,s2
    3d1c:	00004517          	auipc	a0,0x4
    3d20:	ff450513          	addi	a0,a0,-12 # 7d10 <malloc+0x1630>
    3d24:	0bd020ef          	jal	65e0 <printf>
    exit(1);
    3d28:	00100513          	li	a0,1
    3d2c:	2d0020ef          	jal	5ffc <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3d30:	00090593          	mv	a1,s2
    3d34:	00004517          	auipc	a0,0x4
    3d38:	ffc50513          	addi	a0,a0,-4 # 7d30 <malloc+0x1650>
    3d3c:	0a5020ef          	jal	65e0 <printf>
    exit(1);
    3d40:	00100513          	li	a0,1
    3d44:	2b8020ef          	jal	5ffc <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3d48:	00090593          	mv	a1,s2
    3d4c:	00004517          	auipc	a0,0x4
    3d50:	00450513          	addi	a0,a0,4 # 7d50 <malloc+0x1670>
    3d54:	08d020ef          	jal	65e0 <printf>
    exit(1);
    3d58:	00100513          	li	a0,1
    3d5c:	2a0020ef          	jal	5ffc <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3d60:	00090593          	mv	a1,s2
    3d64:	00004517          	auipc	a0,0x4
    3d68:	02c50513          	addi	a0,a0,44 # 7d90 <malloc+0x16b0>
    3d6c:	075020ef          	jal	65e0 <printf>
    exit(1);
    3d70:	00100513          	li	a0,1
    3d74:	288020ef          	jal	5ffc <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3d78:	00090593          	mv	a1,s2
    3d7c:	00004517          	auipc	a0,0x4
    3d80:	04450513          	addi	a0,a0,68 # 7dc0 <malloc+0x16e0>
    3d84:	05d020ef          	jal	65e0 <printf>
    exit(1);
    3d88:	00100513          	li	a0,1
    3d8c:	270020ef          	jal	5ffc <exit>
    printf("%s: create dd succeeded!\n", s);
    3d90:	00090593          	mv	a1,s2
    3d94:	00004517          	auipc	a0,0x4
    3d98:	04c50513          	addi	a0,a0,76 # 7de0 <malloc+0x1700>
    3d9c:	045020ef          	jal	65e0 <printf>
    exit(1);
    3da0:	00100513          	li	a0,1
    3da4:	258020ef          	jal	5ffc <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3da8:	00090593          	mv	a1,s2
    3dac:	00004517          	auipc	a0,0x4
    3db0:	05450513          	addi	a0,a0,84 # 7e00 <malloc+0x1720>
    3db4:	02d020ef          	jal	65e0 <printf>
    exit(1);
    3db8:	00100513          	li	a0,1
    3dbc:	240020ef          	jal	5ffc <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3dc0:	00090593          	mv	a1,s2
    3dc4:	00004517          	auipc	a0,0x4
    3dc8:	05c50513          	addi	a0,a0,92 # 7e20 <malloc+0x1740>
    3dcc:	015020ef          	jal	65e0 <printf>
    exit(1);
    3dd0:	00100513          	li	a0,1
    3dd4:	228020ef          	jal	5ffc <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3dd8:	00090593          	mv	a1,s2
    3ddc:	00004517          	auipc	a0,0x4
    3de0:	07450513          	addi	a0,a0,116 # 7e50 <malloc+0x1770>
    3de4:	7fc020ef          	jal	65e0 <printf>
    exit(1);
    3de8:	00100513          	li	a0,1
    3dec:	210020ef          	jal	5ffc <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3df0:	00090593          	mv	a1,s2
    3df4:	00004517          	auipc	a0,0x4
    3df8:	08450513          	addi	a0,a0,132 # 7e78 <malloc+0x1798>
    3dfc:	7e4020ef          	jal	65e0 <printf>
    exit(1);
    3e00:	00100513          	li	a0,1
    3e04:	1f8020ef          	jal	5ffc <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3e08:	00090593          	mv	a1,s2
    3e0c:	00004517          	auipc	a0,0x4
    3e10:	09450513          	addi	a0,a0,148 # 7ea0 <malloc+0x17c0>
    3e14:	7cc020ef          	jal	65e0 <printf>
    exit(1);
    3e18:	00100513          	li	a0,1
    3e1c:	1e0020ef          	jal	5ffc <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3e20:	00090593          	mv	a1,s2
    3e24:	00004517          	auipc	a0,0x4
    3e28:	0a450513          	addi	a0,a0,164 # 7ec8 <malloc+0x17e8>
    3e2c:	7b4020ef          	jal	65e0 <printf>
    exit(1);
    3e30:	00100513          	li	a0,1
    3e34:	1c8020ef          	jal	5ffc <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3e38:	00090593          	mv	a1,s2
    3e3c:	00004517          	auipc	a0,0x4
    3e40:	0ac50513          	addi	a0,a0,172 # 7ee8 <malloc+0x1808>
    3e44:	79c020ef          	jal	65e0 <printf>
    exit(1);
    3e48:	00100513          	li	a0,1
    3e4c:	1b0020ef          	jal	5ffc <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3e50:	00090593          	mv	a1,s2
    3e54:	00004517          	auipc	a0,0x4
    3e58:	0b450513          	addi	a0,a0,180 # 7f08 <malloc+0x1828>
    3e5c:	784020ef          	jal	65e0 <printf>
    exit(1);
    3e60:	00100513          	li	a0,1
    3e64:	198020ef          	jal	5ffc <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3e68:	00090593          	mv	a1,s2
    3e6c:	00004517          	auipc	a0,0x4
    3e70:	0c450513          	addi	a0,a0,196 # 7f30 <malloc+0x1850>
    3e74:	76c020ef          	jal	65e0 <printf>
    exit(1);
    3e78:	00100513          	li	a0,1
    3e7c:	180020ef          	jal	5ffc <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3e80:	00090593          	mv	a1,s2
    3e84:	00004517          	auipc	a0,0x4
    3e88:	0cc50513          	addi	a0,a0,204 # 7f50 <malloc+0x1870>
    3e8c:	754020ef          	jal	65e0 <printf>
    exit(1);
    3e90:	00100513          	li	a0,1
    3e94:	168020ef          	jal	5ffc <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3e98:	00090593          	mv	a1,s2
    3e9c:	00004517          	auipc	a0,0x4
    3ea0:	0d450513          	addi	a0,a0,212 # 7f70 <malloc+0x1890>
    3ea4:	73c020ef          	jal	65e0 <printf>
    exit(1);
    3ea8:	00100513          	li	a0,1
    3eac:	150020ef          	jal	5ffc <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3eb0:	00090593          	mv	a1,s2
    3eb4:	00004517          	auipc	a0,0x4
    3eb8:	0e450513          	addi	a0,a0,228 # 7f98 <malloc+0x18b8>
    3ebc:	724020ef          	jal	65e0 <printf>
    exit(1);
    3ec0:	00100513          	li	a0,1
    3ec4:	138020ef          	jal	5ffc <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3ec8:	00090593          	mv	a1,s2
    3ecc:	00004517          	auipc	a0,0x4
    3ed0:	d5c50513          	addi	a0,a0,-676 # 7c28 <malloc+0x1548>
    3ed4:	70c020ef          	jal	65e0 <printf>
    exit(1);
    3ed8:	00100513          	li	a0,1
    3edc:	120020ef          	jal	5ffc <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3ee0:	00090593          	mv	a1,s2
    3ee4:	00004517          	auipc	a0,0x4
    3ee8:	0d450513          	addi	a0,a0,212 # 7fb8 <malloc+0x18d8>
    3eec:	6f4020ef          	jal	65e0 <printf>
    exit(1);
    3ef0:	00100513          	li	a0,1
    3ef4:	108020ef          	jal	5ffc <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3ef8:	00090593          	mv	a1,s2
    3efc:	00004517          	auipc	a0,0x4
    3f00:	0dc50513          	addi	a0,a0,220 # 7fd8 <malloc+0x18f8>
    3f04:	6dc020ef          	jal	65e0 <printf>
    exit(1);
    3f08:	00100513          	li	a0,1
    3f0c:	0f0020ef          	jal	5ffc <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3f10:	00090593          	mv	a1,s2
    3f14:	00004517          	auipc	a0,0x4
    3f18:	0f450513          	addi	a0,a0,244 # 8008 <malloc+0x1928>
    3f1c:	6c4020ef          	jal	65e0 <printf>
    exit(1);
    3f20:	00100513          	li	a0,1
    3f24:	0d8020ef          	jal	5ffc <exit>
    printf("%s: unlink dd failed\n", s);
    3f28:	00090593          	mv	a1,s2
    3f2c:	00004517          	auipc	a0,0x4
    3f30:	0fc50513          	addi	a0,a0,252 # 8028 <malloc+0x1948>
    3f34:	6ac020ef          	jal	65e0 <printf>
    exit(1);
    3f38:	00100513          	li	a0,1
    3f3c:	0c0020ef          	jal	5ffc <exit>

0000000000003f40 <rmdot>:
{
    3f40:	fe010113          	addi	sp,sp,-32
    3f44:	00113c23          	sd	ra,24(sp)
    3f48:	00813823          	sd	s0,16(sp)
    3f4c:	00913423          	sd	s1,8(sp)
    3f50:	02010413          	addi	s0,sp,32
    3f54:	00050493          	mv	s1,a0
  if(mkdir("dots") != 0){
    3f58:	00004517          	auipc	a0,0x4
    3f5c:	0e850513          	addi	a0,a0,232 # 8040 <malloc+0x1960>
    3f60:	138020ef          	jal	6098 <mkdir>
    3f64:	08051463          	bnez	a0,3fec <rmdot+0xac>
  if(chdir("dots") != 0){
    3f68:	00004517          	auipc	a0,0x4
    3f6c:	0d850513          	addi	a0,a0,216 # 8040 <malloc+0x1960>
    3f70:	134020ef          	jal	60a4 <chdir>
    3f74:	08051863          	bnez	a0,4004 <rmdot+0xc4>
  if(unlink(".") == 0){
    3f78:	00003517          	auipc	a0,0x3
    3f7c:	ff850513          	addi	a0,a0,-8 # 6f70 <malloc+0x890>
    3f80:	0f4020ef          	jal	6074 <unlink>
    3f84:	08050c63          	beqz	a0,401c <rmdot+0xdc>
  if(unlink("..") == 0){
    3f88:	00004517          	auipc	a0,0x4
    3f8c:	b0850513          	addi	a0,a0,-1272 # 7a90 <malloc+0x13b0>
    3f90:	0e4020ef          	jal	6074 <unlink>
    3f94:	0a050063          	beqz	a0,4034 <rmdot+0xf4>
  if(chdir("/") != 0){
    3f98:	00004517          	auipc	a0,0x4
    3f9c:	aa050513          	addi	a0,a0,-1376 # 7a38 <malloc+0x1358>
    3fa0:	104020ef          	jal	60a4 <chdir>
    3fa4:	0a051463          	bnez	a0,404c <rmdot+0x10c>
  if(unlink("dots/.") == 0){
    3fa8:	00004517          	auipc	a0,0x4
    3fac:	10050513          	addi	a0,a0,256 # 80a8 <malloc+0x19c8>
    3fb0:	0c4020ef          	jal	6074 <unlink>
    3fb4:	0a050863          	beqz	a0,4064 <rmdot+0x124>
  if(unlink("dots/..") == 0){
    3fb8:	00004517          	auipc	a0,0x4
    3fbc:	11850513          	addi	a0,a0,280 # 80d0 <malloc+0x19f0>
    3fc0:	0b4020ef          	jal	6074 <unlink>
    3fc4:	0a050c63          	beqz	a0,407c <rmdot+0x13c>
  if(unlink("dots") != 0){
    3fc8:	00004517          	auipc	a0,0x4
    3fcc:	07850513          	addi	a0,a0,120 # 8040 <malloc+0x1960>
    3fd0:	0a4020ef          	jal	6074 <unlink>
    3fd4:	0c051063          	bnez	a0,4094 <rmdot+0x154>
}
    3fd8:	01813083          	ld	ra,24(sp)
    3fdc:	01013403          	ld	s0,16(sp)
    3fe0:	00813483          	ld	s1,8(sp)
    3fe4:	02010113          	addi	sp,sp,32
    3fe8:	00008067          	ret
    printf("%s: mkdir dots failed\n", s);
    3fec:	00048593          	mv	a1,s1
    3ff0:	00004517          	auipc	a0,0x4
    3ff4:	05850513          	addi	a0,a0,88 # 8048 <malloc+0x1968>
    3ff8:	5e8020ef          	jal	65e0 <printf>
    exit(1);
    3ffc:	00100513          	li	a0,1
    4000:	7fd010ef          	jal	5ffc <exit>
    printf("%s: chdir dots failed\n", s);
    4004:	00048593          	mv	a1,s1
    4008:	00004517          	auipc	a0,0x4
    400c:	05850513          	addi	a0,a0,88 # 8060 <malloc+0x1980>
    4010:	5d0020ef          	jal	65e0 <printf>
    exit(1);
    4014:	00100513          	li	a0,1
    4018:	7e5010ef          	jal	5ffc <exit>
    printf("%s: rm . worked!\n", s);
    401c:	00048593          	mv	a1,s1
    4020:	00004517          	auipc	a0,0x4
    4024:	05850513          	addi	a0,a0,88 # 8078 <malloc+0x1998>
    4028:	5b8020ef          	jal	65e0 <printf>
    exit(1);
    402c:	00100513          	li	a0,1
    4030:	7cd010ef          	jal	5ffc <exit>
    printf("%s: rm .. worked!\n", s);
    4034:	00048593          	mv	a1,s1
    4038:	00004517          	auipc	a0,0x4
    403c:	05850513          	addi	a0,a0,88 # 8090 <malloc+0x19b0>
    4040:	5a0020ef          	jal	65e0 <printf>
    exit(1);
    4044:	00100513          	li	a0,1
    4048:	7b5010ef          	jal	5ffc <exit>
    printf("%s: chdir / failed\n", s);
    404c:	00048593          	mv	a1,s1
    4050:	00004517          	auipc	a0,0x4
    4054:	9f050513          	addi	a0,a0,-1552 # 7a40 <malloc+0x1360>
    4058:	588020ef          	jal	65e0 <printf>
    exit(1);
    405c:	00100513          	li	a0,1
    4060:	79d010ef          	jal	5ffc <exit>
    printf("%s: unlink dots/. worked!\n", s);
    4064:	00048593          	mv	a1,s1
    4068:	00004517          	auipc	a0,0x4
    406c:	04850513          	addi	a0,a0,72 # 80b0 <malloc+0x19d0>
    4070:	570020ef          	jal	65e0 <printf>
    exit(1);
    4074:	00100513          	li	a0,1
    4078:	785010ef          	jal	5ffc <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    407c:	00048593          	mv	a1,s1
    4080:	00004517          	auipc	a0,0x4
    4084:	05850513          	addi	a0,a0,88 # 80d8 <malloc+0x19f8>
    4088:	558020ef          	jal	65e0 <printf>
    exit(1);
    408c:	00100513          	li	a0,1
    4090:	76d010ef          	jal	5ffc <exit>
    printf("%s: unlink dots failed!\n", s);
    4094:	00048593          	mv	a1,s1
    4098:	00004517          	auipc	a0,0x4
    409c:	06050513          	addi	a0,a0,96 # 80f8 <malloc+0x1a18>
    40a0:	540020ef          	jal	65e0 <printf>
    exit(1);
    40a4:	00100513          	li	a0,1
    40a8:	755010ef          	jal	5ffc <exit>

00000000000040ac <dirfile>:
{
    40ac:	fe010113          	addi	sp,sp,-32
    40b0:	00113c23          	sd	ra,24(sp)
    40b4:	00813823          	sd	s0,16(sp)
    40b8:	00913423          	sd	s1,8(sp)
    40bc:	01213023          	sd	s2,0(sp)
    40c0:	02010413          	addi	s0,sp,32
    40c4:	00050913          	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    40c8:	20000593          	li	a1,512
    40cc:	00004517          	auipc	a0,0x4
    40d0:	04c50513          	addi	a0,a0,76 # 8118 <malloc+0x1a38>
    40d4:	789010ef          	jal	605c <open>
  if(fd < 0){
    40d8:	0e054263          	bltz	a0,41bc <dirfile+0x110>
  close(fd);
    40dc:	75d010ef          	jal	6038 <close>
  if(chdir("dirfile") == 0){
    40e0:	00004517          	auipc	a0,0x4
    40e4:	03850513          	addi	a0,a0,56 # 8118 <malloc+0x1a38>
    40e8:	7bd010ef          	jal	60a4 <chdir>
    40ec:	0e050463          	beqz	a0,41d4 <dirfile+0x128>
  fd = open("dirfile/xx", 0);
    40f0:	00000593          	li	a1,0
    40f4:	00004517          	auipc	a0,0x4
    40f8:	06c50513          	addi	a0,a0,108 # 8160 <malloc+0x1a80>
    40fc:	761010ef          	jal	605c <open>
  if(fd >= 0){
    4100:	0e055663          	bgez	a0,41ec <dirfile+0x140>
  fd = open("dirfile/xx", O_CREATE);
    4104:	20000593          	li	a1,512
    4108:	00004517          	auipc	a0,0x4
    410c:	05850513          	addi	a0,a0,88 # 8160 <malloc+0x1a80>
    4110:	74d010ef          	jal	605c <open>
  if(fd >= 0){
    4114:	0e055863          	bgez	a0,4204 <dirfile+0x158>
  if(mkdir("dirfile/xx") == 0){
    4118:	00004517          	auipc	a0,0x4
    411c:	04850513          	addi	a0,a0,72 # 8160 <malloc+0x1a80>
    4120:	779010ef          	jal	6098 <mkdir>
    4124:	0e050c63          	beqz	a0,421c <dirfile+0x170>
  if(unlink("dirfile/xx") == 0){
    4128:	00004517          	auipc	a0,0x4
    412c:	03850513          	addi	a0,a0,56 # 8160 <malloc+0x1a80>
    4130:	745010ef          	jal	6074 <unlink>
    4134:	10050063          	beqz	a0,4234 <dirfile+0x188>
  if(link("README", "dirfile/xx") == 0){
    4138:	00004597          	auipc	a1,0x4
    413c:	02858593          	addi	a1,a1,40 # 8160 <malloc+0x1a80>
    4140:	00003517          	auipc	a0,0x3
    4144:	92050513          	addi	a0,a0,-1760 # 6a60 <malloc+0x380>
    4148:	745010ef          	jal	608c <link>
    414c:	10050063          	beqz	a0,424c <dirfile+0x1a0>
  if(unlink("dirfile") != 0){
    4150:	00004517          	auipc	a0,0x4
    4154:	fc850513          	addi	a0,a0,-56 # 8118 <malloc+0x1a38>
    4158:	71d010ef          	jal	6074 <unlink>
    415c:	10051463          	bnez	a0,4264 <dirfile+0x1b8>
  fd = open(".", O_RDWR);
    4160:	00200593          	li	a1,2
    4164:	00003517          	auipc	a0,0x3
    4168:	e0c50513          	addi	a0,a0,-500 # 6f70 <malloc+0x890>
    416c:	6f1010ef          	jal	605c <open>
  if(fd >= 0){
    4170:	10055663          	bgez	a0,427c <dirfile+0x1d0>
  fd = open(".", 0);
    4174:	00000593          	li	a1,0
    4178:	00003517          	auipc	a0,0x3
    417c:	df850513          	addi	a0,a0,-520 # 6f70 <malloc+0x890>
    4180:	6dd010ef          	jal	605c <open>
    4184:	00050493          	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    4188:	00100613          	li	a2,1
    418c:	00002597          	auipc	a1,0x2
    4190:	76c58593          	addi	a1,a1,1900 # 68f8 <malloc+0x218>
    4194:	699010ef          	jal	602c <write>
    4198:	0ea04e63          	bgtz	a0,4294 <dirfile+0x1e8>
  close(fd);
    419c:	00048513          	mv	a0,s1
    41a0:	699010ef          	jal	6038 <close>
}
    41a4:	01813083          	ld	ra,24(sp)
    41a8:	01013403          	ld	s0,16(sp)
    41ac:	00813483          	ld	s1,8(sp)
    41b0:	00013903          	ld	s2,0(sp)
    41b4:	02010113          	addi	sp,sp,32
    41b8:	00008067          	ret
    printf("%s: create dirfile failed\n", s);
    41bc:	00090593          	mv	a1,s2
    41c0:	00004517          	auipc	a0,0x4
    41c4:	f6050513          	addi	a0,a0,-160 # 8120 <malloc+0x1a40>
    41c8:	418020ef          	jal	65e0 <printf>
    exit(1);
    41cc:	00100513          	li	a0,1
    41d0:	62d010ef          	jal	5ffc <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    41d4:	00090593          	mv	a1,s2
    41d8:	00004517          	auipc	a0,0x4
    41dc:	f6850513          	addi	a0,a0,-152 # 8140 <malloc+0x1a60>
    41e0:	400020ef          	jal	65e0 <printf>
    exit(1);
    41e4:	00100513          	li	a0,1
    41e8:	615010ef          	jal	5ffc <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    41ec:	00090593          	mv	a1,s2
    41f0:	00004517          	auipc	a0,0x4
    41f4:	f8050513          	addi	a0,a0,-128 # 8170 <malloc+0x1a90>
    41f8:	3e8020ef          	jal	65e0 <printf>
    exit(1);
    41fc:	00100513          	li	a0,1
    4200:	5fd010ef          	jal	5ffc <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4204:	00090593          	mv	a1,s2
    4208:	00004517          	auipc	a0,0x4
    420c:	f6850513          	addi	a0,a0,-152 # 8170 <malloc+0x1a90>
    4210:	3d0020ef          	jal	65e0 <printf>
    exit(1);
    4214:	00100513          	li	a0,1
    4218:	5e5010ef          	jal	5ffc <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    421c:	00090593          	mv	a1,s2
    4220:	00004517          	auipc	a0,0x4
    4224:	f7850513          	addi	a0,a0,-136 # 8198 <malloc+0x1ab8>
    4228:	3b8020ef          	jal	65e0 <printf>
    exit(1);
    422c:	00100513          	li	a0,1
    4230:	5cd010ef          	jal	5ffc <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    4234:	00090593          	mv	a1,s2
    4238:	00004517          	auipc	a0,0x4
    423c:	f8850513          	addi	a0,a0,-120 # 81c0 <malloc+0x1ae0>
    4240:	3a0020ef          	jal	65e0 <printf>
    exit(1);
    4244:	00100513          	li	a0,1
    4248:	5b5010ef          	jal	5ffc <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    424c:	00090593          	mv	a1,s2
    4250:	00004517          	auipc	a0,0x4
    4254:	f9850513          	addi	a0,a0,-104 # 81e8 <malloc+0x1b08>
    4258:	388020ef          	jal	65e0 <printf>
    exit(1);
    425c:	00100513          	li	a0,1
    4260:	59d010ef          	jal	5ffc <exit>
    printf("%s: unlink dirfile failed!\n", s);
    4264:	00090593          	mv	a1,s2
    4268:	00004517          	auipc	a0,0x4
    426c:	fa850513          	addi	a0,a0,-88 # 8210 <malloc+0x1b30>
    4270:	370020ef          	jal	65e0 <printf>
    exit(1);
    4274:	00100513          	li	a0,1
    4278:	585010ef          	jal	5ffc <exit>
    printf("%s: open . for writing succeeded!\n", s);
    427c:	00090593          	mv	a1,s2
    4280:	00004517          	auipc	a0,0x4
    4284:	fb050513          	addi	a0,a0,-80 # 8230 <malloc+0x1b50>
    4288:	358020ef          	jal	65e0 <printf>
    exit(1);
    428c:	00100513          	li	a0,1
    4290:	56d010ef          	jal	5ffc <exit>
    printf("%s: write . succeeded!\n", s);
    4294:	00090593          	mv	a1,s2
    4298:	00004517          	auipc	a0,0x4
    429c:	fc050513          	addi	a0,a0,-64 # 8258 <malloc+0x1b78>
    42a0:	340020ef          	jal	65e0 <printf>
    exit(1);
    42a4:	00100513          	li	a0,1
    42a8:	555010ef          	jal	5ffc <exit>

00000000000042ac <iref>:
{
    42ac:	fc010113          	addi	sp,sp,-64
    42b0:	02113c23          	sd	ra,56(sp)
    42b4:	02813823          	sd	s0,48(sp)
    42b8:	02913423          	sd	s1,40(sp)
    42bc:	03213023          	sd	s2,32(sp)
    42c0:	01313c23          	sd	s3,24(sp)
    42c4:	01413823          	sd	s4,16(sp)
    42c8:	01513423          	sd	s5,8(sp)
    42cc:	01613023          	sd	s6,0(sp)
    42d0:	04010413          	addi	s0,sp,64
    42d4:	00050b13          	mv	s6,a0
    42d8:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    42dc:	00004a17          	auipc	s4,0x4
    42e0:	f94a0a13          	addi	s4,s4,-108 # 8270 <malloc+0x1b90>
    mkdir("");
    42e4:	00004497          	auipc	s1,0x4
    42e8:	a9448493          	addi	s1,s1,-1388 # 7d78 <malloc+0x1698>
    link("README", "");
    42ec:	00002a97          	auipc	s5,0x2
    42f0:	774a8a93          	addi	s5,s5,1908 # 6a60 <malloc+0x380>
    fd = open("xx", O_CREATE);
    42f4:	00004997          	auipc	s3,0x4
    42f8:	e7498993          	addi	s3,s3,-396 # 8168 <malloc+0x1a88>
    42fc:	04c0006f          	j	4348 <iref+0x9c>
      printf("%s: mkdir irefd failed\n", s);
    4300:	000b0593          	mv	a1,s6
    4304:	00004517          	auipc	a0,0x4
    4308:	f7450513          	addi	a0,a0,-140 # 8278 <malloc+0x1b98>
    430c:	2d4020ef          	jal	65e0 <printf>
      exit(1);
    4310:	00100513          	li	a0,1
    4314:	4e9010ef          	jal	5ffc <exit>
      printf("%s: chdir irefd failed\n", s);
    4318:	000b0593          	mv	a1,s6
    431c:	00004517          	auipc	a0,0x4
    4320:	f7450513          	addi	a0,a0,-140 # 8290 <malloc+0x1bb0>
    4324:	2bc020ef          	jal	65e0 <printf>
      exit(1);
    4328:	00100513          	li	a0,1
    432c:	4d1010ef          	jal	5ffc <exit>
      close(fd);
    4330:	509010ef          	jal	6038 <close>
    4334:	0500006f          	j	4384 <iref+0xd8>
    unlink("xx");
    4338:	00098513          	mv	a0,s3
    433c:	539010ef          	jal	6074 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4340:	fff9091b          	addiw	s2,s2,-1
    4344:	04090c63          	beqz	s2,439c <iref+0xf0>
    if(mkdir("irefd") != 0){
    4348:	000a0513          	mv	a0,s4
    434c:	54d010ef          	jal	6098 <mkdir>
    4350:	fa0518e3          	bnez	a0,4300 <iref+0x54>
    if(chdir("irefd") != 0){
    4354:	000a0513          	mv	a0,s4
    4358:	54d010ef          	jal	60a4 <chdir>
    435c:	fa051ee3          	bnez	a0,4318 <iref+0x6c>
    mkdir("");
    4360:	00048513          	mv	a0,s1
    4364:	535010ef          	jal	6098 <mkdir>
    link("README", "");
    4368:	00048593          	mv	a1,s1
    436c:	000a8513          	mv	a0,s5
    4370:	51d010ef          	jal	608c <link>
    fd = open("", O_CREATE);
    4374:	20000593          	li	a1,512
    4378:	00048513          	mv	a0,s1
    437c:	4e1010ef          	jal	605c <open>
    if(fd >= 0)
    4380:	fa0558e3          	bgez	a0,4330 <iref+0x84>
    fd = open("xx", O_CREATE);
    4384:	20000593          	li	a1,512
    4388:	00098513          	mv	a0,s3
    438c:	4d1010ef          	jal	605c <open>
    if(fd >= 0)
    4390:	fa0544e3          	bltz	a0,4338 <iref+0x8c>
      close(fd);
    4394:	4a5010ef          	jal	6038 <close>
    4398:	fa1ff06f          	j	4338 <iref+0x8c>
    439c:	03300493          	li	s1,51
    chdir("..");
    43a0:	00003997          	auipc	s3,0x3
    43a4:	6f098993          	addi	s3,s3,1776 # 7a90 <malloc+0x13b0>
    unlink("irefd");
    43a8:	00004917          	auipc	s2,0x4
    43ac:	ec890913          	addi	s2,s2,-312 # 8270 <malloc+0x1b90>
    chdir("..");
    43b0:	00098513          	mv	a0,s3
    43b4:	4f1010ef          	jal	60a4 <chdir>
    unlink("irefd");
    43b8:	00090513          	mv	a0,s2
    43bc:	4b9010ef          	jal	6074 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    43c0:	fff4849b          	addiw	s1,s1,-1
    43c4:	fe0496e3          	bnez	s1,43b0 <iref+0x104>
  chdir("/");
    43c8:	00003517          	auipc	a0,0x3
    43cc:	67050513          	addi	a0,a0,1648 # 7a38 <malloc+0x1358>
    43d0:	4d5010ef          	jal	60a4 <chdir>
}
    43d4:	03813083          	ld	ra,56(sp)
    43d8:	03013403          	ld	s0,48(sp)
    43dc:	02813483          	ld	s1,40(sp)
    43e0:	02013903          	ld	s2,32(sp)
    43e4:	01813983          	ld	s3,24(sp)
    43e8:	01013a03          	ld	s4,16(sp)
    43ec:	00813a83          	ld	s5,8(sp)
    43f0:	00013b03          	ld	s6,0(sp)
    43f4:	04010113          	addi	sp,sp,64
    43f8:	00008067          	ret

00000000000043fc <openiputtest>:
{
    43fc:	fd010113          	addi	sp,sp,-48
    4400:	02113423          	sd	ra,40(sp)
    4404:	02813023          	sd	s0,32(sp)
    4408:	00913c23          	sd	s1,24(sp)
    440c:	03010413          	addi	s0,sp,48
    4410:	00050493          	mv	s1,a0
  if(mkdir("oidir") < 0){
    4414:	00004517          	auipc	a0,0x4
    4418:	e9450513          	addi	a0,a0,-364 # 82a8 <malloc+0x1bc8>
    441c:	47d010ef          	jal	6098 <mkdir>
    4420:	02054e63          	bltz	a0,445c <openiputtest+0x60>
  pid = fork();
    4424:	3cd010ef          	jal	5ff0 <fork>
  if(pid < 0){
    4428:	04054663          	bltz	a0,4474 <openiputtest+0x78>
  if(pid == 0){
    442c:	06051463          	bnez	a0,4494 <openiputtest+0x98>
    int fd = open("oidir", O_RDWR);
    4430:	00200593          	li	a1,2
    4434:	00004517          	auipc	a0,0x4
    4438:	e7450513          	addi	a0,a0,-396 # 82a8 <malloc+0x1bc8>
    443c:	421010ef          	jal	605c <open>
    if(fd >= 0){
    4440:	04054663          	bltz	a0,448c <openiputtest+0x90>
      printf("%s: open directory for write succeeded\n", s);
    4444:	00048593          	mv	a1,s1
    4448:	00004517          	auipc	a0,0x4
    444c:	e8050513          	addi	a0,a0,-384 # 82c8 <malloc+0x1be8>
    4450:	190020ef          	jal	65e0 <printf>
      exit(1);
    4454:	00100513          	li	a0,1
    4458:	3a5010ef          	jal	5ffc <exit>
    printf("%s: mkdir oidir failed\n", s);
    445c:	00048593          	mv	a1,s1
    4460:	00004517          	auipc	a0,0x4
    4464:	e5050513          	addi	a0,a0,-432 # 82b0 <malloc+0x1bd0>
    4468:	178020ef          	jal	65e0 <printf>
    exit(1);
    446c:	00100513          	li	a0,1
    4470:	38d010ef          	jal	5ffc <exit>
    printf("%s: fork failed\n", s);
    4474:	00048593          	mv	a1,s1
    4478:	00003517          	auipc	a0,0x3
    447c:	ca050513          	addi	a0,a0,-864 # 7118 <malloc+0xa38>
    4480:	160020ef          	jal	65e0 <printf>
    exit(1);
    4484:	00100513          	li	a0,1
    4488:	375010ef          	jal	5ffc <exit>
    exit(0);
    448c:	00000513          	li	a0,0
    4490:	36d010ef          	jal	5ffc <exit>
  sleep(1);
    4494:	00100513          	li	a0,1
    4498:	43d010ef          	jal	60d4 <sleep>
  if(unlink("oidir") != 0){
    449c:	00004517          	auipc	a0,0x4
    44a0:	e0c50513          	addi	a0,a0,-500 # 82a8 <malloc+0x1bc8>
    44a4:	3d1010ef          	jal	6074 <unlink>
    44a8:	00050e63          	beqz	a0,44c4 <openiputtest+0xc8>
    printf("%s: unlink failed\n", s);
    44ac:	00048593          	mv	a1,s1
    44b0:	00003517          	auipc	a0,0x3
    44b4:	e5850513          	addi	a0,a0,-424 # 7308 <malloc+0xc28>
    44b8:	128020ef          	jal	65e0 <printf>
    exit(1);
    44bc:	00100513          	li	a0,1
    44c0:	33d010ef          	jal	5ffc <exit>
  wait(&xstatus);
    44c4:	fdc40513          	addi	a0,s0,-36
    44c8:	341010ef          	jal	6008 <wait>
  exit(xstatus);
    44cc:	fdc42503          	lw	a0,-36(s0)
    44d0:	32d010ef          	jal	5ffc <exit>

00000000000044d4 <forkforkfork>:
{
    44d4:	fe010113          	addi	sp,sp,-32
    44d8:	00113c23          	sd	ra,24(sp)
    44dc:	00813823          	sd	s0,16(sp)
    44e0:	00913423          	sd	s1,8(sp)
    44e4:	02010413          	addi	s0,sp,32
    44e8:	00050493          	mv	s1,a0
  unlink("stopforking");
    44ec:	00004517          	auipc	a0,0x4
    44f0:	e0450513          	addi	a0,a0,-508 # 82f0 <malloc+0x1c10>
    44f4:	381010ef          	jal	6074 <unlink>
  int pid = fork();
    44f8:	2f9010ef          	jal	5ff0 <fork>
  if(pid < 0){
    44fc:	04054463          	bltz	a0,4544 <forkforkfork+0x70>
  if(pid == 0){
    4500:	04050e63          	beqz	a0,455c <forkforkfork+0x88>
  sleep(20); // two seconds
    4504:	01400513          	li	a0,20
    4508:	3cd010ef          	jal	60d4 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    450c:	20200593          	li	a1,514
    4510:	00004517          	auipc	a0,0x4
    4514:	de050513          	addi	a0,a0,-544 # 82f0 <malloc+0x1c10>
    4518:	345010ef          	jal	605c <open>
    451c:	31d010ef          	jal	6038 <close>
  wait(0);
    4520:	00000513          	li	a0,0
    4524:	2e5010ef          	jal	6008 <wait>
  sleep(10); // one second
    4528:	00a00513          	li	a0,10
    452c:	3a9010ef          	jal	60d4 <sleep>
}
    4530:	01813083          	ld	ra,24(sp)
    4534:	01013403          	ld	s0,16(sp)
    4538:	00813483          	ld	s1,8(sp)
    453c:	02010113          	addi	sp,sp,32
    4540:	00008067          	ret
    printf("%s: fork failed", s);
    4544:	00048593          	mv	a1,s1
    4548:	00003517          	auipc	a0,0x3
    454c:	d9050513          	addi	a0,a0,-624 # 72d8 <malloc+0xbf8>
    4550:	090020ef          	jal	65e0 <printf>
    exit(1);
    4554:	00100513          	li	a0,1
    4558:	2a5010ef          	jal	5ffc <exit>
      int fd = open("stopforking", 0);
    455c:	00004497          	auipc	s1,0x4
    4560:	d9448493          	addi	s1,s1,-620 # 82f0 <malloc+0x1c10>
    4564:	00000593          	li	a1,0
    4568:	00048513          	mv	a0,s1
    456c:	2f1010ef          	jal	605c <open>
      if(fd >= 0){
    4570:	02055263          	bgez	a0,4594 <forkforkfork+0xc0>
      if(fork() < 0){
    4574:	27d010ef          	jal	5ff0 <fork>
    4578:	fe0556e3          	bgez	a0,4564 <forkforkfork+0x90>
        close(open("stopforking", O_CREATE|O_RDWR));
    457c:	20200593          	li	a1,514
    4580:	00004517          	auipc	a0,0x4
    4584:	d7050513          	addi	a0,a0,-656 # 82f0 <malloc+0x1c10>
    4588:	2d5010ef          	jal	605c <open>
    458c:	2ad010ef          	jal	6038 <close>
    4590:	fd5ff06f          	j	4564 <forkforkfork+0x90>
        exit(0);
    4594:	00000513          	li	a0,0
    4598:	265010ef          	jal	5ffc <exit>

000000000000459c <killstatus>:
{
    459c:	fc010113          	addi	sp,sp,-64
    45a0:	02113c23          	sd	ra,56(sp)
    45a4:	02813823          	sd	s0,48(sp)
    45a8:	02913423          	sd	s1,40(sp)
    45ac:	03213023          	sd	s2,32(sp)
    45b0:	01313c23          	sd	s3,24(sp)
    45b4:	01413823          	sd	s4,16(sp)
    45b8:	04010413          	addi	s0,sp,64
    45bc:	00050a13          	mv	s4,a0
    45c0:	06400913          	li	s2,100
    if(xst != -1) {
    45c4:	fff00993          	li	s3,-1
    int pid1 = fork();
    45c8:	229010ef          	jal	5ff0 <fork>
    45cc:	00050493          	mv	s1,a0
    if(pid1 < 0){
    45d0:	02054c63          	bltz	a0,4608 <killstatus+0x6c>
    if(pid1 == 0){
    45d4:	04050663          	beqz	a0,4620 <killstatus+0x84>
    sleep(1);
    45d8:	00100513          	li	a0,1
    45dc:	2f9010ef          	jal	60d4 <sleep>
    kill(pid1);
    45e0:	00048513          	mv	a0,s1
    45e4:	261010ef          	jal	6044 <kill>
    wait(&xst);
    45e8:	fcc40513          	addi	a0,s0,-52
    45ec:	21d010ef          	jal	6008 <wait>
    if(xst != -1) {
    45f0:	fcc42783          	lw	a5,-52(s0)
    45f4:	03379a63          	bne	a5,s3,4628 <killstatus+0x8c>
  for(int i = 0; i < 100; i++){
    45f8:	fff9091b          	addiw	s2,s2,-1
    45fc:	fc0916e3          	bnez	s2,45c8 <killstatus+0x2c>
  exit(0);
    4600:	00000513          	li	a0,0
    4604:	1f9010ef          	jal	5ffc <exit>
      printf("%s: fork failed\n", s);
    4608:	000a0593          	mv	a1,s4
    460c:	00003517          	auipc	a0,0x3
    4610:	b0c50513          	addi	a0,a0,-1268 # 7118 <malloc+0xa38>
    4614:	7cd010ef          	jal	65e0 <printf>
      exit(1);
    4618:	00100513          	li	a0,1
    461c:	1e1010ef          	jal	5ffc <exit>
        getpid();
    4620:	29d010ef          	jal	60bc <getpid>
      while(1) {
    4624:	ffdff06f          	j	4620 <killstatus+0x84>
       printf("%s: status should be -1\n", s);
    4628:	000a0593          	mv	a1,s4
    462c:	00004517          	auipc	a0,0x4
    4630:	cd450513          	addi	a0,a0,-812 # 8300 <malloc+0x1c20>
    4634:	7ad010ef          	jal	65e0 <printf>
       exit(1);
    4638:	00100513          	li	a0,1
    463c:	1c1010ef          	jal	5ffc <exit>

0000000000004640 <preempt>:
{
    4640:	fc010113          	addi	sp,sp,-64
    4644:	02113c23          	sd	ra,56(sp)
    4648:	02813823          	sd	s0,48(sp)
    464c:	02913423          	sd	s1,40(sp)
    4650:	03213023          	sd	s2,32(sp)
    4654:	01313c23          	sd	s3,24(sp)
    4658:	01413823          	sd	s4,16(sp)
    465c:	04010413          	addi	s0,sp,64
    4660:	00050913          	mv	s2,a0
  pid1 = fork();
    4664:	18d010ef          	jal	5ff0 <fork>
  if(pid1 < 0) {
    4668:	00054863          	bltz	a0,4678 <preempt+0x38>
    466c:	00050493          	mv	s1,a0
  if(pid1 == 0)
    4670:	02051063          	bnez	a0,4690 <preempt+0x50>
    for(;;)
    4674:	0000006f          	j	4674 <preempt+0x34>
    printf("%s: fork failed", s);
    4678:	00090593          	mv	a1,s2
    467c:	00003517          	auipc	a0,0x3
    4680:	c5c50513          	addi	a0,a0,-932 # 72d8 <malloc+0xbf8>
    4684:	75d010ef          	jal	65e0 <printf>
    exit(1);
    4688:	00100513          	li	a0,1
    468c:	171010ef          	jal	5ffc <exit>
  pid2 = fork();
    4690:	161010ef          	jal	5ff0 <fork>
    4694:	00050993          	mv	s3,a0
  if(pid2 < 0) {
    4698:	00054663          	bltz	a0,46a4 <preempt+0x64>
  if(pid2 == 0)
    469c:	02051063          	bnez	a0,46bc <preempt+0x7c>
    for(;;)
    46a0:	0000006f          	j	46a0 <preempt+0x60>
    printf("%s: fork failed\n", s);
    46a4:	00090593          	mv	a1,s2
    46a8:	00003517          	auipc	a0,0x3
    46ac:	a7050513          	addi	a0,a0,-1424 # 7118 <malloc+0xa38>
    46b0:	731010ef          	jal	65e0 <printf>
    exit(1);
    46b4:	00100513          	li	a0,1
    46b8:	145010ef          	jal	5ffc <exit>
  pipe(pfds);
    46bc:	fc840513          	addi	a0,s0,-56
    46c0:	155010ef          	jal	6014 <pipe>
  pid3 = fork();
    46c4:	12d010ef          	jal	5ff0 <fork>
    46c8:	00050a13          	mv	s4,a0
  if(pid3 < 0) {
    46cc:	02054c63          	bltz	a0,4704 <preempt+0xc4>
  if(pid3 == 0){
    46d0:	06051063          	bnez	a0,4730 <preempt+0xf0>
    close(pfds[0]);
    46d4:	fc842503          	lw	a0,-56(s0)
    46d8:	161010ef          	jal	6038 <close>
    if(write(pfds[1], "x", 1) != 1)
    46dc:	00100613          	li	a2,1
    46e0:	00002597          	auipc	a1,0x2
    46e4:	21858593          	addi	a1,a1,536 # 68f8 <malloc+0x218>
    46e8:	fcc42503          	lw	a0,-52(s0)
    46ec:	141010ef          	jal	602c <write>
    46f0:	00100793          	li	a5,1
    46f4:	02f51463          	bne	a0,a5,471c <preempt+0xdc>
    close(pfds[1]);
    46f8:	fcc42503          	lw	a0,-52(s0)
    46fc:	13d010ef          	jal	6038 <close>
    for(;;)
    4700:	0000006f          	j	4700 <preempt+0xc0>
     printf("%s: fork failed\n", s);
    4704:	00090593          	mv	a1,s2
    4708:	00003517          	auipc	a0,0x3
    470c:	a1050513          	addi	a0,a0,-1520 # 7118 <malloc+0xa38>
    4710:	6d1010ef          	jal	65e0 <printf>
     exit(1);
    4714:	00100513          	li	a0,1
    4718:	0e5010ef          	jal	5ffc <exit>
      printf("%s: preempt write error", s);
    471c:	00090593          	mv	a1,s2
    4720:	00004517          	auipc	a0,0x4
    4724:	c0050513          	addi	a0,a0,-1024 # 8320 <malloc+0x1c40>
    4728:	6b9010ef          	jal	65e0 <printf>
    472c:	fcdff06f          	j	46f8 <preempt+0xb8>
  close(pfds[1]);
    4730:	fcc42503          	lw	a0,-52(s0)
    4734:	105010ef          	jal	6038 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4738:	00003637          	lui	a2,0x3
    473c:	00008597          	auipc	a1,0x8
    4740:	53c58593          	addi	a1,a1,1340 # cc78 <buf>
    4744:	fc842503          	lw	a0,-56(s0)
    4748:	0d9010ef          	jal	6020 <read>
    474c:	00100793          	li	a5,1
    4750:	02f50a63          	beq	a0,a5,4784 <preempt+0x144>
    printf("%s: preempt read error", s);
    4754:	00090593          	mv	a1,s2
    4758:	00004517          	auipc	a0,0x4
    475c:	be050513          	addi	a0,a0,-1056 # 8338 <malloc+0x1c58>
    4760:	681010ef          	jal	65e0 <printf>
}
    4764:	03813083          	ld	ra,56(sp)
    4768:	03013403          	ld	s0,48(sp)
    476c:	02813483          	ld	s1,40(sp)
    4770:	02013903          	ld	s2,32(sp)
    4774:	01813983          	ld	s3,24(sp)
    4778:	01013a03          	ld	s4,16(sp)
    477c:	04010113          	addi	sp,sp,64
    4780:	00008067          	ret
  close(pfds[0]);
    4784:	fc842503          	lw	a0,-56(s0)
    4788:	0b1010ef          	jal	6038 <close>
  printf("kill... ");
    478c:	00004517          	auipc	a0,0x4
    4790:	bc450513          	addi	a0,a0,-1084 # 8350 <malloc+0x1c70>
    4794:	64d010ef          	jal	65e0 <printf>
  kill(pid1);
    4798:	00048513          	mv	a0,s1
    479c:	0a9010ef          	jal	6044 <kill>
  kill(pid2);
    47a0:	00098513          	mv	a0,s3
    47a4:	0a1010ef          	jal	6044 <kill>
  kill(pid3);
    47a8:	000a0513          	mv	a0,s4
    47ac:	099010ef          	jal	6044 <kill>
  printf("wait... ");
    47b0:	00004517          	auipc	a0,0x4
    47b4:	bb050513          	addi	a0,a0,-1104 # 8360 <malloc+0x1c80>
    47b8:	629010ef          	jal	65e0 <printf>
  wait(0);
    47bc:	00000513          	li	a0,0
    47c0:	049010ef          	jal	6008 <wait>
  wait(0);
    47c4:	00000513          	li	a0,0
    47c8:	041010ef          	jal	6008 <wait>
  wait(0);
    47cc:	00000513          	li	a0,0
    47d0:	039010ef          	jal	6008 <wait>
    47d4:	f91ff06f          	j	4764 <preempt+0x124>

00000000000047d8 <reparent>:
{
    47d8:	fd010113          	addi	sp,sp,-48
    47dc:	02113423          	sd	ra,40(sp)
    47e0:	02813023          	sd	s0,32(sp)
    47e4:	00913c23          	sd	s1,24(sp)
    47e8:	01213823          	sd	s2,16(sp)
    47ec:	01313423          	sd	s3,8(sp)
    47f0:	01413023          	sd	s4,0(sp)
    47f4:	03010413          	addi	s0,sp,48
    47f8:	00050993          	mv	s3,a0
  int master_pid = getpid();
    47fc:	0c1010ef          	jal	60bc <getpid>
    4800:	00050a13          	mv	s4,a0
    4804:	0c800913          	li	s2,200
    int pid = fork();
    4808:	7e8010ef          	jal	5ff0 <fork>
    480c:	00050493          	mv	s1,a0
    if(pid < 0){
    4810:	02054263          	bltz	a0,4834 <reparent+0x5c>
    if(pid){
    4814:	04050863          	beqz	a0,4864 <reparent+0x8c>
      if(wait(0) != pid){
    4818:	00000513          	li	a0,0
    481c:	7ec010ef          	jal	6008 <wait>
    4820:	02951663          	bne	a0,s1,484c <reparent+0x74>
  for(int i = 0; i < 200; i++){
    4824:	fff9091b          	addiw	s2,s2,-1
    4828:	fe0910e3          	bnez	s2,4808 <reparent+0x30>
  exit(0);
    482c:	00000513          	li	a0,0
    4830:	7cc010ef          	jal	5ffc <exit>
      printf("%s: fork failed\n", s);
    4834:	00098593          	mv	a1,s3
    4838:	00003517          	auipc	a0,0x3
    483c:	8e050513          	addi	a0,a0,-1824 # 7118 <malloc+0xa38>
    4840:	5a1010ef          	jal	65e0 <printf>
      exit(1);
    4844:	00100513          	li	a0,1
    4848:	7b4010ef          	jal	5ffc <exit>
        printf("%s: wait wrong pid\n", s);
    484c:	00098593          	mv	a1,s3
    4850:	00003517          	auipc	a0,0x3
    4854:	a5050513          	addi	a0,a0,-1456 # 72a0 <malloc+0xbc0>
    4858:	589010ef          	jal	65e0 <printf>
        exit(1);
    485c:	00100513          	li	a0,1
    4860:	79c010ef          	jal	5ffc <exit>
      int pid2 = fork();
    4864:	78c010ef          	jal	5ff0 <fork>
      if(pid2 < 0){
    4868:	00054663          	bltz	a0,4874 <reparent+0x9c>
      exit(0);
    486c:	00000513          	li	a0,0
    4870:	78c010ef          	jal	5ffc <exit>
        kill(master_pid);
    4874:	000a0513          	mv	a0,s4
    4878:	7cc010ef          	jal	6044 <kill>
        exit(1);
    487c:	00100513          	li	a0,1
    4880:	77c010ef          	jal	5ffc <exit>

0000000000004884 <sbrkfail>:
{
    4884:	f8010113          	addi	sp,sp,-128
    4888:	06113c23          	sd	ra,120(sp)
    488c:	06813823          	sd	s0,112(sp)
    4890:	06913423          	sd	s1,104(sp)
    4894:	07213023          	sd	s2,96(sp)
    4898:	05313c23          	sd	s3,88(sp)
    489c:	05413823          	sd	s4,80(sp)
    48a0:	05513423          	sd	s5,72(sp)
    48a4:	08010413          	addi	s0,sp,128
    48a8:	00050a93          	mv	s5,a0
  if(pipe(fds) != 0){
    48ac:	fb040513          	addi	a0,s0,-80
    48b0:	764010ef          	jal	6014 <pipe>
    48b4:	00051c63          	bnez	a0,48cc <sbrkfail+0x48>
    48b8:	f8040493          	addi	s1,s0,-128
    48bc:	fa840993          	addi	s3,s0,-88
    48c0:	00048913          	mv	s2,s1
    if(pids[i] != -1)
    48c4:	fff00a13          	li	s4,-1
    48c8:	0540006f          	j	491c <sbrkfail+0x98>
    printf("%s: pipe() failed\n", s);
    48cc:	000a8593          	mv	a1,s5
    48d0:	00003517          	auipc	a0,0x3
    48d4:	95050513          	addi	a0,a0,-1712 # 7220 <malloc+0xb40>
    48d8:	509010ef          	jal	65e0 <printf>
    exit(1);
    48dc:	00100513          	li	a0,1
    48e0:	71c010ef          	jal	5ffc <exit>
      sbrk(BIG - (uint64)sbrk(0));
    48e4:	7e4010ef          	jal	60c8 <sbrk>
    48e8:	064007b7          	lui	a5,0x6400
    48ec:	40a7853b          	subw	a0,a5,a0
    48f0:	7d8010ef          	jal	60c8 <sbrk>
      write(fds[1], "x", 1);
    48f4:	00100613          	li	a2,1
    48f8:	00002597          	auipc	a1,0x2
    48fc:	00058593          	mv	a1,a1
    4900:	fb442503          	lw	a0,-76(s0)
    4904:	728010ef          	jal	602c <write>
      for(;;) sleep(1000);
    4908:	3e800513          	li	a0,1000
    490c:	7c8010ef          	jal	60d4 <sleep>
    4910:	ff9ff06f          	j	4908 <sbrkfail+0x84>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4914:	00490913          	addi	s2,s2,4
    4918:	03390463          	beq	s2,s3,4940 <sbrkfail+0xbc>
    if((pids[i] = fork()) == 0){
    491c:	6d4010ef          	jal	5ff0 <fork>
    4920:	00a92023          	sw	a0,0(s2)
    4924:	fc0500e3          	beqz	a0,48e4 <sbrkfail+0x60>
    if(pids[i] != -1)
    4928:	ff4506e3          	beq	a0,s4,4914 <sbrkfail+0x90>
      read(fds[0], &scratch, 1);
    492c:	00100613          	li	a2,1
    4930:	faf40593          	addi	a1,s0,-81
    4934:	fb042503          	lw	a0,-80(s0)
    4938:	6e8010ef          	jal	6020 <read>
    493c:	fd9ff06f          	j	4914 <sbrkfail+0x90>
  c = sbrk(PGSIZE);
    4940:	00001537          	lui	a0,0x1
    4944:	784010ef          	jal	60c8 <sbrk>
    4948:	00050a13          	mv	s4,a0
    if(pids[i] == -1)
    494c:	fff00913          	li	s2,-1
    4950:	00c0006f          	j	495c <sbrkfail+0xd8>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4954:	00448493          	addi	s1,s1,4
    4958:	01348e63          	beq	s1,s3,4974 <sbrkfail+0xf0>
    if(pids[i] == -1)
    495c:	0004a503          	lw	a0,0(s1)
    4960:	ff250ae3          	beq	a0,s2,4954 <sbrkfail+0xd0>
    kill(pids[i]);
    4964:	6e0010ef          	jal	6044 <kill>
    wait(0);
    4968:	00000513          	li	a0,0
    496c:	69c010ef          	jal	6008 <wait>
    4970:	fe5ff06f          	j	4954 <sbrkfail+0xd0>
  if(c == (char*)0xffffffffffffffffL){
    4974:	fff00793          	li	a5,-1
    4978:	04fa0a63          	beq	s4,a5,49cc <sbrkfail+0x148>
  pid = fork();
    497c:	674010ef          	jal	5ff0 <fork>
    4980:	00050493          	mv	s1,a0
  if(pid < 0){
    4984:	06054063          	bltz	a0,49e4 <sbrkfail+0x160>
  if(pid == 0){
    4988:	06050a63          	beqz	a0,49fc <sbrkfail+0x178>
  wait(&xstatus);
    498c:	fbc40513          	addi	a0,s0,-68
    4990:	678010ef          	jal	6008 <wait>
  if(xstatus != -1 && xstatus != 2)
    4994:	fbc42783          	lw	a5,-68(s0)
    4998:	fff00713          	li	a4,-1
    499c:	00e78663          	beq	a5,a4,49a8 <sbrkfail+0x124>
    49a0:	00200713          	li	a4,2
    49a4:	0ae79463          	bne	a5,a4,4a4c <sbrkfail+0x1c8>
}
    49a8:	07813083          	ld	ra,120(sp)
    49ac:	07013403          	ld	s0,112(sp)
    49b0:	06813483          	ld	s1,104(sp)
    49b4:	06013903          	ld	s2,96(sp)
    49b8:	05813983          	ld	s3,88(sp)
    49bc:	05013a03          	ld	s4,80(sp)
    49c0:	04813a83          	ld	s5,72(sp)
    49c4:	08010113          	addi	sp,sp,128
    49c8:	00008067          	ret
    printf("%s: failed sbrk leaked memory\n", s);
    49cc:	000a8593          	mv	a1,s5
    49d0:	00004517          	auipc	a0,0x4
    49d4:	9a050513          	addi	a0,a0,-1632 # 8370 <malloc+0x1c90>
    49d8:	409010ef          	jal	65e0 <printf>
    exit(1);
    49dc:	00100513          	li	a0,1
    49e0:	61c010ef          	jal	5ffc <exit>
    printf("%s: fork failed\n", s);
    49e4:	000a8593          	mv	a1,s5
    49e8:	00002517          	auipc	a0,0x2
    49ec:	73050513          	addi	a0,a0,1840 # 7118 <malloc+0xa38>
    49f0:	3f1010ef          	jal	65e0 <printf>
    exit(1);
    49f4:	00100513          	li	a0,1
    49f8:	604010ef          	jal	5ffc <exit>
    a = sbrk(0);
    49fc:	00000513          	li	a0,0
    4a00:	6c8010ef          	jal	60c8 <sbrk>
    4a04:	00050913          	mv	s2,a0
    sbrk(10*BIG);
    4a08:	3e800537          	lui	a0,0x3e800
    4a0c:	6bc010ef          	jal	60c8 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4a10:	00090793          	mv	a5,s2
    4a14:	3e800737          	lui	a4,0x3e800
    4a18:	00e90933          	add	s2,s2,a4
    4a1c:	00001737          	lui	a4,0x1
      n += *(a+i);
    4a20:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    4a24:	009684bb          	addw	s1,a3,s1
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4a28:	00e787b3          	add	a5,a5,a4
    4a2c:	fef91ae3          	bne	s2,a5,4a20 <sbrkfail+0x19c>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4a30:	00048613          	mv	a2,s1
    4a34:	000a8593          	mv	a1,s5
    4a38:	00004517          	auipc	a0,0x4
    4a3c:	95850513          	addi	a0,a0,-1704 # 8390 <malloc+0x1cb0>
    4a40:	3a1010ef          	jal	65e0 <printf>
    exit(1);
    4a44:	00100513          	li	a0,1
    4a48:	5b4010ef          	jal	5ffc <exit>
    exit(1);
    4a4c:	00100513          	li	a0,1
    4a50:	5ac010ef          	jal	5ffc <exit>

0000000000004a54 <mem>:
{
    4a54:	fc010113          	addi	sp,sp,-64
    4a58:	02113c23          	sd	ra,56(sp)
    4a5c:	02813823          	sd	s0,48(sp)
    4a60:	02913423          	sd	s1,40(sp)
    4a64:	03213023          	sd	s2,32(sp)
    4a68:	01313c23          	sd	s3,24(sp)
    4a6c:	04010413          	addi	s0,sp,64
    4a70:	00050993          	mv	s3,a0
  if((pid = fork()) == 0){
    4a74:	57c010ef          	jal	5ff0 <fork>
    m1 = 0;
    4a78:	00000493          	li	s1,0
    while((m2 = malloc(10001)) != 0){
    4a7c:	00002937          	lui	s2,0x2
    4a80:	71190913          	addi	s2,s2,1809 # 2711 <manywrites+0x89>
  if((pid = fork()) == 0){
    4a84:	02050263          	beqz	a0,4aa8 <mem+0x54>
    wait(&xstatus);
    4a88:	fcc40513          	addi	a0,s0,-52
    4a8c:	57c010ef          	jal	6008 <wait>
    if(xstatus == -1){
    4a90:	fcc42503          	lw	a0,-52(s0)
    4a94:	fff00793          	li	a5,-1
    4a98:	06f50063          	beq	a0,a5,4af8 <mem+0xa4>
    exit(xstatus);
    4a9c:	560010ef          	jal	5ffc <exit>
      *(char**)m2 = m1;
    4aa0:	00953023          	sd	s1,0(a0)
      m1 = m2;
    4aa4:	00050493          	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4aa8:	00090513          	mv	a0,s2
    4aac:	435010ef          	jal	66e0 <malloc>
    4ab0:	fe0518e3          	bnez	a0,4aa0 <mem+0x4c>
    while(m1){
    4ab4:	00048a63          	beqz	s1,4ac8 <mem+0x74>
      m2 = *(char**)m1;
    4ab8:	00048513          	mv	a0,s1
    4abc:	0004b483          	ld	s1,0(s1)
      free(m1);
    4ac0:	371010ef          	jal	6630 <free>
    while(m1){
    4ac4:	fe049ae3          	bnez	s1,4ab8 <mem+0x64>
    m1 = malloc(1024*20);
    4ac8:	00005537          	lui	a0,0x5
    4acc:	415010ef          	jal	66e0 <malloc>
    if(m1 == 0){
    4ad0:	00050863          	beqz	a0,4ae0 <mem+0x8c>
    free(m1);
    4ad4:	35d010ef          	jal	6630 <free>
    exit(0);
    4ad8:	00000513          	li	a0,0
    4adc:	520010ef          	jal	5ffc <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    4ae0:	00098593          	mv	a1,s3
    4ae4:	00004517          	auipc	a0,0x4
    4ae8:	8dc50513          	addi	a0,a0,-1828 # 83c0 <malloc+0x1ce0>
    4aec:	2f5010ef          	jal	65e0 <printf>
      exit(1);
    4af0:	00100513          	li	a0,1
    4af4:	508010ef          	jal	5ffc <exit>
      exit(0);
    4af8:	00000513          	li	a0,0
    4afc:	500010ef          	jal	5ffc <exit>

0000000000004b00 <sharedfd>:
{
    4b00:	f9010113          	addi	sp,sp,-112
    4b04:	06113423          	sd	ra,104(sp)
    4b08:	06813023          	sd	s0,96(sp)
    4b0c:	05413023          	sd	s4,64(sp)
    4b10:	07010413          	addi	s0,sp,112
    4b14:	00050a13          	mv	s4,a0
  unlink("sharedfd");
    4b18:	00004517          	auipc	a0,0x4
    4b1c:	8c850513          	addi	a0,a0,-1848 # 83e0 <malloc+0x1d00>
    4b20:	554010ef          	jal	6074 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4b24:	20200593          	li	a1,514
    4b28:	00004517          	auipc	a0,0x4
    4b2c:	8b850513          	addi	a0,a0,-1864 # 83e0 <malloc+0x1d00>
    4b30:	52c010ef          	jal	605c <open>
  if(fd < 0){
    4b34:	06054863          	bltz	a0,4ba4 <sharedfd+0xa4>
    4b38:	04913c23          	sd	s1,88(sp)
    4b3c:	05213823          	sd	s2,80(sp)
    4b40:	05313423          	sd	s3,72(sp)
    4b44:	03513c23          	sd	s5,56(sp)
    4b48:	03613823          	sd	s6,48(sp)
    4b4c:	03713423          	sd	s7,40(sp)
    4b50:	00050913          	mv	s2,a0
  pid = fork();
    4b54:	49c010ef          	jal	5ff0 <fork>
    4b58:	00050993          	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4b5c:	07000593          	li	a1,112
    4b60:	00051463          	bnez	a0,4b68 <sharedfd+0x68>
    4b64:	06300593          	li	a1,99
    4b68:	00a00613          	li	a2,10
    4b6c:	fa040513          	addi	a0,s0,-96
    4b70:	18c010ef          	jal	5cfc <memset>
    4b74:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4b78:	00a00613          	li	a2,10
    4b7c:	fa040593          	addi	a1,s0,-96
    4b80:	00090513          	mv	a0,s2
    4b84:	4a8010ef          	jal	602c <write>
    4b88:	00a00793          	li	a5,10
    4b8c:	04f51463          	bne	a0,a5,4bd4 <sharedfd+0xd4>
  for(i = 0; i < N; i++){
    4b90:	fff4849b          	addiw	s1,s1,-1
    4b94:	fe0492e3          	bnez	s1,4b78 <sharedfd+0x78>
  if(pid == 0) {
    4b98:	04099a63          	bnez	s3,4bec <sharedfd+0xec>
    exit(0);
    4b9c:	00000513          	li	a0,0
    4ba0:	45c010ef          	jal	5ffc <exit>
    4ba4:	04913c23          	sd	s1,88(sp)
    4ba8:	05213823          	sd	s2,80(sp)
    4bac:	05313423          	sd	s3,72(sp)
    4bb0:	03513c23          	sd	s5,56(sp)
    4bb4:	03613823          	sd	s6,48(sp)
    4bb8:	03713423          	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    4bbc:	000a0593          	mv	a1,s4
    4bc0:	00004517          	auipc	a0,0x4
    4bc4:	83050513          	addi	a0,a0,-2000 # 83f0 <malloc+0x1d10>
    4bc8:	219010ef          	jal	65e0 <printf>
    exit(1);
    4bcc:	00100513          	li	a0,1
    4bd0:	42c010ef          	jal	5ffc <exit>
      printf("%s: write sharedfd failed\n", s);
    4bd4:	000a0593          	mv	a1,s4
    4bd8:	00004517          	auipc	a0,0x4
    4bdc:	84050513          	addi	a0,a0,-1984 # 8418 <malloc+0x1d38>
    4be0:	201010ef          	jal	65e0 <printf>
      exit(1);
    4be4:	00100513          	li	a0,1
    4be8:	414010ef          	jal	5ffc <exit>
    wait(&xstatus);
    4bec:	f9c40513          	addi	a0,s0,-100
    4bf0:	418010ef          	jal	6008 <wait>
    if(xstatus != 0)
    4bf4:	f9c42983          	lw	s3,-100(s0)
    4bf8:	00098663          	beqz	s3,4c04 <sharedfd+0x104>
      exit(xstatus);
    4bfc:	00098513          	mv	a0,s3
    4c00:	3fc010ef          	jal	5ffc <exit>
  close(fd);
    4c04:	00090513          	mv	a0,s2
    4c08:	430010ef          	jal	6038 <close>
  fd = open("sharedfd", 0);
    4c0c:	00000593          	li	a1,0
    4c10:	00003517          	auipc	a0,0x3
    4c14:	7d050513          	addi	a0,a0,2000 # 83e0 <malloc+0x1d00>
    4c18:	444010ef          	jal	605c <open>
    4c1c:	00050b93          	mv	s7,a0
  nc = np = 0;
    4c20:	00098a93          	mv	s5,s3
  if(fd < 0){
    4c24:	02054663          	bltz	a0,4c50 <sharedfd+0x150>
    4c28:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4c2c:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4c30:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4c34:	00a00613          	li	a2,10
    4c38:	fa040593          	addi	a1,s0,-96
    4c3c:	000b8513          	mv	a0,s7
    4c40:	3e0010ef          	jal	6020 <read>
    4c44:	04a05263          	blez	a0,4c88 <sharedfd+0x188>
    4c48:	fa040793          	addi	a5,s0,-96
    4c4c:	0280006f          	j	4c74 <sharedfd+0x174>
    printf("%s: cannot open sharedfd for reading\n", s);
    4c50:	000a0593          	mv	a1,s4
    4c54:	00003517          	auipc	a0,0x3
    4c58:	7e450513          	addi	a0,a0,2020 # 8438 <malloc+0x1d58>
    4c5c:	185010ef          	jal	65e0 <printf>
    exit(1);
    4c60:	00100513          	li	a0,1
    4c64:	398010ef          	jal	5ffc <exit>
        nc++;
    4c68:	0019899b          	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4c6c:	00178793          	addi	a5,a5,1
    4c70:	fd2782e3          	beq	a5,s2,4c34 <sharedfd+0x134>
      if(buf[i] == 'c')
    4c74:	0007c703          	lbu	a4,0(a5)
    4c78:	fe9708e3          	beq	a4,s1,4c68 <sharedfd+0x168>
      if(buf[i] == 'p')
    4c7c:	ff6718e3          	bne	a4,s6,4c6c <sharedfd+0x16c>
        np++;
    4c80:	001a8a9b          	addiw	s5,s5,1
    4c84:	fe9ff06f          	j	4c6c <sharedfd+0x16c>
  close(fd);
    4c88:	000b8513          	mv	a0,s7
    4c8c:	3ac010ef          	jal	6038 <close>
  unlink("sharedfd");
    4c90:	00003517          	auipc	a0,0x3
    4c94:	75050513          	addi	a0,a0,1872 # 83e0 <malloc+0x1d00>
    4c98:	3dc010ef          	jal	6074 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4c9c:	000027b7          	lui	a5,0x2
    4ca0:	71078793          	addi	a5,a5,1808 # 2710 <manywrites+0x88>
    4ca4:	00f99863          	bne	s3,a5,4cb4 <sharedfd+0x1b4>
    4ca8:	000027b7          	lui	a5,0x2
    4cac:	71078793          	addi	a5,a5,1808 # 2710 <manywrites+0x88>
    4cb0:	00fa8e63          	beq	s5,a5,4ccc <sharedfd+0x1cc>
    printf("%s: nc/np test fails\n", s);
    4cb4:	000a0593          	mv	a1,s4
    4cb8:	00003517          	auipc	a0,0x3
    4cbc:	7a850513          	addi	a0,a0,1960 # 8460 <malloc+0x1d80>
    4cc0:	121010ef          	jal	65e0 <printf>
    exit(1);
    4cc4:	00100513          	li	a0,1
    4cc8:	334010ef          	jal	5ffc <exit>
    exit(0);
    4ccc:	00000513          	li	a0,0
    4cd0:	32c010ef          	jal	5ffc <exit>

0000000000004cd4 <fourfiles>:
{
    4cd4:	f6010113          	addi	sp,sp,-160
    4cd8:	08113c23          	sd	ra,152(sp)
    4cdc:	08813823          	sd	s0,144(sp)
    4ce0:	08913423          	sd	s1,136(sp)
    4ce4:	09213023          	sd	s2,128(sp)
    4ce8:	07313c23          	sd	s3,120(sp)
    4cec:	07413823          	sd	s4,112(sp)
    4cf0:	07513423          	sd	s5,104(sp)
    4cf4:	07613023          	sd	s6,96(sp)
    4cf8:	05713c23          	sd	s7,88(sp)
    4cfc:	05813823          	sd	s8,80(sp)
    4d00:	05913423          	sd	s9,72(sp)
    4d04:	05a13023          	sd	s10,64(sp)
    4d08:	03b13c23          	sd	s11,56(sp)
    4d0c:	0a010413          	addi	s0,sp,160
    4d10:	00050c93          	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4d14:	00003797          	auipc	a5,0x3
    4d18:	76478793          	addi	a5,a5,1892 # 8478 <malloc+0x1d98>
    4d1c:	f6f43823          	sd	a5,-144(s0)
    4d20:	00003797          	auipc	a5,0x3
    4d24:	76078793          	addi	a5,a5,1888 # 8480 <malloc+0x1da0>
    4d28:	f6f43c23          	sd	a5,-136(s0)
    4d2c:	00003797          	auipc	a5,0x3
    4d30:	75c78793          	addi	a5,a5,1884 # 8488 <malloc+0x1da8>
    4d34:	f8f43023          	sd	a5,-128(s0)
    4d38:	00003797          	auipc	a5,0x3
    4d3c:	75878793          	addi	a5,a5,1880 # 8490 <malloc+0x1db0>
    4d40:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4d44:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4d48:	000b8913          	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4d4c:	00000493          	li	s1,0
    4d50:	00400a13          	li	s4,4
    fname = names[pi];
    4d54:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4d58:	00098513          	mv	a0,s3
    4d5c:	318010ef          	jal	6074 <unlink>
    pid = fork();
    4d60:	290010ef          	jal	5ff0 <fork>
    if(pid < 0){
    4d64:	04054663          	bltz	a0,4db0 <fourfiles+0xdc>
    if(pid == 0){
    4d68:	06050063          	beqz	a0,4dc8 <fourfiles+0xf4>
  for(pi = 0; pi < NCHILD; pi++){
    4d6c:	0014849b          	addiw	s1,s1,1
    4d70:	00890913          	addi	s2,s2,8
    4d74:	ff4490e3          	bne	s1,s4,4d54 <fourfiles+0x80>
    4d78:	00400493          	li	s1,4
    wait(&xstatus);
    4d7c:	f6c40513          	addi	a0,s0,-148
    4d80:	288010ef          	jal	6008 <wait>
    if(xstatus != 0)
    4d84:	f6c42a83          	lw	s5,-148(s0)
    4d88:	0c0a9663          	bnez	s5,4e54 <fourfiles+0x180>
  for(pi = 0; pi < NCHILD; pi++){
    4d8c:	fff4849b          	addiw	s1,s1,-1
    4d90:	fe0496e3          	bnez	s1,4d7c <fourfiles+0xa8>
    4d94:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4d98:	00008a17          	auipc	s4,0x8
    4d9c:	ee0a0a13          	addi	s4,s4,-288 # cc78 <buf>
    if(total != N*SZ){
    4da0:	00001d37          	lui	s10,0x1
    4da4:	770d0d13          	addi	s10,s10,1904 # 1770 <truncate3+0x9c>
  for(i = 0; i < NCHILD; i++){
    4da8:	03400d93          	li	s11,52
    4dac:	1200006f          	j	4ecc <fourfiles+0x1f8>
      printf("%s: fork failed\n", s);
    4db0:	000c8593          	mv	a1,s9
    4db4:	00002517          	auipc	a0,0x2
    4db8:	36450513          	addi	a0,a0,868 # 7118 <malloc+0xa38>
    4dbc:	025010ef          	jal	65e0 <printf>
      exit(1);
    4dc0:	00100513          	li	a0,1
    4dc4:	238010ef          	jal	5ffc <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4dc8:	20200593          	li	a1,514
    4dcc:	00098513          	mv	a0,s3
    4dd0:	28c010ef          	jal	605c <open>
    4dd4:	00050913          	mv	s2,a0
      if(fd < 0){
    4dd8:	04054863          	bltz	a0,4e28 <fourfiles+0x154>
      memset(buf, '0'+pi, SZ);
    4ddc:	1f400613          	li	a2,500
    4de0:	0304859b          	addiw	a1,s1,48
    4de4:	00008517          	auipc	a0,0x8
    4de8:	e9450513          	addi	a0,a0,-364 # cc78 <buf>
    4dec:	711000ef          	jal	5cfc <memset>
    4df0:	00c00493          	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4df4:	00008997          	auipc	s3,0x8
    4df8:	e8498993          	addi	s3,s3,-380 # cc78 <buf>
    4dfc:	1f400613          	li	a2,500
    4e00:	00098593          	mv	a1,s3
    4e04:	00090513          	mv	a0,s2
    4e08:	224010ef          	jal	602c <write>
    4e0c:	00050593          	mv	a1,a0
    4e10:	1f400793          	li	a5,500
    4e14:	02f51663          	bne	a0,a5,4e40 <fourfiles+0x16c>
      for(i = 0; i < N; i++){
    4e18:	fff4849b          	addiw	s1,s1,-1
    4e1c:	fe0490e3          	bnez	s1,4dfc <fourfiles+0x128>
      exit(0);
    4e20:	00000513          	li	a0,0
    4e24:	1d8010ef          	jal	5ffc <exit>
        printf("%s: create failed\n", s);
    4e28:	000c8593          	mv	a1,s9
    4e2c:	00002517          	auipc	a0,0x2
    4e30:	38450513          	addi	a0,a0,900 # 71b0 <malloc+0xad0>
    4e34:	7ac010ef          	jal	65e0 <printf>
        exit(1);
    4e38:	00100513          	li	a0,1
    4e3c:	1c0010ef          	jal	5ffc <exit>
          printf("write failed %d\n", n);
    4e40:	00003517          	auipc	a0,0x3
    4e44:	65850513          	addi	a0,a0,1624 # 8498 <malloc+0x1db8>
    4e48:	798010ef          	jal	65e0 <printf>
          exit(1);
    4e4c:	00100513          	li	a0,1
    4e50:	1ac010ef          	jal	5ffc <exit>
      exit(xstatus);
    4e54:	000a8513          	mv	a0,s5
    4e58:	1a4010ef          	jal	5ffc <exit>
          printf("%s: wrong char\n", s);
    4e5c:	000c8593          	mv	a1,s9
    4e60:	00003517          	auipc	a0,0x3
    4e64:	65050513          	addi	a0,a0,1616 # 84b0 <malloc+0x1dd0>
    4e68:	778010ef          	jal	65e0 <printf>
          exit(1);
    4e6c:	00100513          	li	a0,1
    4e70:	18c010ef          	jal	5ffc <exit>
      total += n;
    4e74:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e78:	00003637          	lui	a2,0x3
    4e7c:	000a0593          	mv	a1,s4
    4e80:	00098513          	mv	a0,s3
    4e84:	19c010ef          	jal	6020 <read>
    4e88:	02a05263          	blez	a0,4eac <fourfiles+0x1d8>
    4e8c:	00008797          	auipc	a5,0x8
    4e90:	dec78793          	addi	a5,a5,-532 # cc78 <buf>
    4e94:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4e98:	0007c703          	lbu	a4,0(a5)
    4e9c:	fc9710e3          	bne	a4,s1,4e5c <fourfiles+0x188>
      for(j = 0; j < n; j++){
    4ea0:	00178793          	addi	a5,a5,1
    4ea4:	fed79ae3          	bne	a5,a3,4e98 <fourfiles+0x1c4>
    4ea8:	fcdff06f          	j	4e74 <fourfiles+0x1a0>
    close(fd);
    4eac:	00098513          	mv	a0,s3
    4eb0:	188010ef          	jal	6038 <close>
    if(total != N*SZ){
    4eb4:	03a91c63          	bne	s2,s10,4eec <fourfiles+0x218>
    unlink(fname);
    4eb8:	000c0513          	mv	a0,s8
    4ebc:	1b8010ef          	jal	6074 <unlink>
  for(i = 0; i < NCHILD; i++){
    4ec0:	008b8b93          	addi	s7,s7,8
    4ec4:	001b0b1b          	addiw	s6,s6,1
    4ec8:	03bb0e63          	beq	s6,s11,4f04 <fourfiles+0x230>
    fname = names[i];
    4ecc:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4ed0:	00000593          	li	a1,0
    4ed4:	000c0513          	mv	a0,s8
    4ed8:	184010ef          	jal	605c <open>
    4edc:	00050993          	mv	s3,a0
    total = 0;
    4ee0:	000a8913          	mv	s2,s5
        if(buf[j] != '0'+i){
    4ee4:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4ee8:	f91ff06f          	j	4e78 <fourfiles+0x1a4>
      printf("wrong length %d\n", total);
    4eec:	00090593          	mv	a1,s2
    4ef0:	00003517          	auipc	a0,0x3
    4ef4:	5d050513          	addi	a0,a0,1488 # 84c0 <malloc+0x1de0>
    4ef8:	6e8010ef          	jal	65e0 <printf>
      exit(1);
    4efc:	00100513          	li	a0,1
    4f00:	0fc010ef          	jal	5ffc <exit>
}
    4f04:	09813083          	ld	ra,152(sp)
    4f08:	09013403          	ld	s0,144(sp)
    4f0c:	08813483          	ld	s1,136(sp)
    4f10:	08013903          	ld	s2,128(sp)
    4f14:	07813983          	ld	s3,120(sp)
    4f18:	07013a03          	ld	s4,112(sp)
    4f1c:	06813a83          	ld	s5,104(sp)
    4f20:	06013b03          	ld	s6,96(sp)
    4f24:	05813b83          	ld	s7,88(sp)
    4f28:	05013c03          	ld	s8,80(sp)
    4f2c:	04813c83          	ld	s9,72(sp)
    4f30:	04013d03          	ld	s10,64(sp)
    4f34:	03813d83          	ld	s11,56(sp)
    4f38:	0a010113          	addi	sp,sp,160
    4f3c:	00008067          	ret

0000000000004f40 <concreate>:
{
    4f40:	f6010113          	addi	sp,sp,-160
    4f44:	08113c23          	sd	ra,152(sp)
    4f48:	08813823          	sd	s0,144(sp)
    4f4c:	08913423          	sd	s1,136(sp)
    4f50:	09213023          	sd	s2,128(sp)
    4f54:	07313c23          	sd	s3,120(sp)
    4f58:	07413823          	sd	s4,112(sp)
    4f5c:	07513423          	sd	s5,104(sp)
    4f60:	07613023          	sd	s6,96(sp)
    4f64:	05713c23          	sd	s7,88(sp)
    4f68:	0a010413          	addi	s0,sp,160
    4f6c:	00050993          	mv	s3,a0
  file[0] = 'C';
    4f70:	04300793          	li	a5,67
    4f74:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4f78:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4f7c:	00000913          	li	s2,0
    if(pid && (i % 3) == 1){
    4f80:	00300b13          	li	s6,3
    4f84:	00100a93          	li	s5,1
      link("C0", file);
    4f88:	00003b97          	auipc	s7,0x3
    4f8c:	550b8b93          	addi	s7,s7,1360 # 84d8 <malloc+0x1df8>
  for(i = 0; i < N; i++){
    4f90:	02800a13          	li	s4,40
    4f94:	2880006f          	j	521c <concreate+0x2dc>
      link("C0", file);
    4f98:	fa840593          	addi	a1,s0,-88
    4f9c:	000b8513          	mv	a0,s7
    4fa0:	0ec010ef          	jal	608c <link>
    if(pid == 0) {
    4fa4:	2600006f          	j	5204 <concreate+0x2c4>
    } else if(pid == 0 && (i % 5) == 1){
    4fa8:	00500793          	li	a5,5
    4fac:	02f9693b          	remw	s2,s2,a5
    4fb0:	00100793          	li	a5,1
    4fb4:	02f90663          	beq	s2,a5,4fe0 <concreate+0xa0>
      fd = open(file, O_CREATE | O_RDWR);
    4fb8:	20200593          	li	a1,514
    4fbc:	fa840513          	addi	a0,s0,-88
    4fc0:	09c010ef          	jal	605c <open>
      if(fd < 0){
    4fc4:	22055a63          	bgez	a0,51f8 <concreate+0x2b8>
        printf("concreate create %s failed\n", file);
    4fc8:	fa840593          	addi	a1,s0,-88
    4fcc:	00003517          	auipc	a0,0x3
    4fd0:	51450513          	addi	a0,a0,1300 # 84e0 <malloc+0x1e00>
    4fd4:	60c010ef          	jal	65e0 <printf>
        exit(1);
    4fd8:	00100513          	li	a0,1
    4fdc:	020010ef          	jal	5ffc <exit>
      link("C0", file);
    4fe0:	fa840593          	addi	a1,s0,-88
    4fe4:	00003517          	auipc	a0,0x3
    4fe8:	4f450513          	addi	a0,a0,1268 # 84d8 <malloc+0x1df8>
    4fec:	0a0010ef          	jal	608c <link>
      exit(0);
    4ff0:	00000513          	li	a0,0
    4ff4:	008010ef          	jal	5ffc <exit>
        exit(1);
    4ff8:	00100513          	li	a0,1
    4ffc:	000010ef          	jal	5ffc <exit>
  memset(fa, 0, sizeof(fa));
    5000:	02800613          	li	a2,40
    5004:	00000593          	li	a1,0
    5008:	f8040513          	addi	a0,s0,-128
    500c:	4f1000ef          	jal	5cfc <memset>
  fd = open(".", 0);
    5010:	00000593          	li	a1,0
    5014:	00002517          	auipc	a0,0x2
    5018:	f5c50513          	addi	a0,a0,-164 # 6f70 <malloc+0x890>
    501c:	040010ef          	jal	605c <open>
    5020:	00050913          	mv	s2,a0
  n = 0;
    5024:	00048a93          	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    5028:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    502c:	02700b13          	li	s6,39
      fa[i] = 1;
    5030:	00100b93          	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    5034:	01000613          	li	a2,16
    5038:	f7040593          	addi	a1,s0,-144
    503c:	00090513          	mv	a0,s2
    5040:	7e1000ef          	jal	6020 <read>
    5044:	08a05463          	blez	a0,50cc <concreate+0x18c>
    if(de.inum == 0)
    5048:	f7045783          	lhu	a5,-144(s0)
    504c:	fe0784e3          	beqz	a5,5034 <concreate+0xf4>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    5050:	f7244783          	lbu	a5,-142(s0)
    5054:	ff4790e3          	bne	a5,s4,5034 <concreate+0xf4>
    5058:	f7444783          	lbu	a5,-140(s0)
    505c:	fc079ce3          	bnez	a5,5034 <concreate+0xf4>
      i = de.name[1] - '0';
    5060:	f7344783          	lbu	a5,-141(s0)
    5064:	fd07879b          	addiw	a5,a5,-48
    5068:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    506c:	02eb6463          	bltu	s6,a4,5094 <concreate+0x154>
      if(fa[i]){
    5070:	fb070793          	addi	a5,a4,-80 # fb0 <unlinkread+0x134>
    5074:	008787b3          	add	a5,a5,s0
    5078:	fd07c783          	lbu	a5,-48(a5)
    507c:	02079a63          	bnez	a5,50b0 <concreate+0x170>
      fa[i] = 1;
    5080:	fb070793          	addi	a5,a4,-80
    5084:	00878733          	add	a4,a5,s0
    5088:	fd770823          	sb	s7,-48(a4)
      n++;
    508c:	001a8a9b          	addiw	s5,s5,1
    5090:	fa5ff06f          	j	5034 <concreate+0xf4>
        printf("%s: concreate weird file %s\n", s, de.name);
    5094:	f7240613          	addi	a2,s0,-142
    5098:	00098593          	mv	a1,s3
    509c:	00003517          	auipc	a0,0x3
    50a0:	46450513          	addi	a0,a0,1124 # 8500 <malloc+0x1e20>
    50a4:	53c010ef          	jal	65e0 <printf>
        exit(1);
    50a8:	00100513          	li	a0,1
    50ac:	751000ef          	jal	5ffc <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    50b0:	f7240613          	addi	a2,s0,-142
    50b4:	00098593          	mv	a1,s3
    50b8:	00003517          	auipc	a0,0x3
    50bc:	46850513          	addi	a0,a0,1128 # 8520 <malloc+0x1e40>
    50c0:	520010ef          	jal	65e0 <printf>
        exit(1);
    50c4:	00100513          	li	a0,1
    50c8:	735000ef          	jal	5ffc <exit>
  close(fd);
    50cc:	00090513          	mv	a0,s2
    50d0:	769000ef          	jal	6038 <close>
  if(n != N){
    50d4:	02800793          	li	a5,40
    50d8:	00fa9a63          	bne	s5,a5,50ec <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    50dc:	00300a93          	li	s5,3
    50e0:	00100b13          	li	s6,1
  for(i = 0; i < N; i++){
    50e4:	02800a13          	li	s4,40
    50e8:	0a80006f          	j	5190 <concreate+0x250>
    printf("%s: concreate not enough files in directory listing\n", s);
    50ec:	00098593          	mv	a1,s3
    50f0:	00003517          	auipc	a0,0x3
    50f4:	45850513          	addi	a0,a0,1112 # 8548 <malloc+0x1e68>
    50f8:	4e8010ef          	jal	65e0 <printf>
    exit(1);
    50fc:	00100513          	li	a0,1
    5100:	6fd000ef          	jal	5ffc <exit>
      printf("%s: fork failed\n", s);
    5104:	00098593          	mv	a1,s3
    5108:	00002517          	auipc	a0,0x2
    510c:	01050513          	addi	a0,a0,16 # 7118 <malloc+0xa38>
    5110:	4d0010ef          	jal	65e0 <printf>
      exit(1);
    5114:	00100513          	li	a0,1
    5118:	6e5000ef          	jal	5ffc <exit>
      close(open(file, 0));
    511c:	00000593          	li	a1,0
    5120:	fa840513          	addi	a0,s0,-88
    5124:	739000ef          	jal	605c <open>
    5128:	711000ef          	jal	6038 <close>
      close(open(file, 0));
    512c:	00000593          	li	a1,0
    5130:	fa840513          	addi	a0,s0,-88
    5134:	729000ef          	jal	605c <open>
    5138:	701000ef          	jal	6038 <close>
      close(open(file, 0));
    513c:	00000593          	li	a1,0
    5140:	fa840513          	addi	a0,s0,-88
    5144:	719000ef          	jal	605c <open>
    5148:	6f1000ef          	jal	6038 <close>
      close(open(file, 0));
    514c:	00000593          	li	a1,0
    5150:	fa840513          	addi	a0,s0,-88
    5154:	709000ef          	jal	605c <open>
    5158:	6e1000ef          	jal	6038 <close>
      close(open(file, 0));
    515c:	00000593          	li	a1,0
    5160:	fa840513          	addi	a0,s0,-88
    5164:	6f9000ef          	jal	605c <open>
    5168:	6d1000ef          	jal	6038 <close>
      close(open(file, 0));
    516c:	00000593          	li	a1,0
    5170:	fa840513          	addi	a0,s0,-88
    5174:	6e9000ef          	jal	605c <open>
    5178:	6c1000ef          	jal	6038 <close>
    if(pid == 0)
    517c:	06090a63          	beqz	s2,51f0 <concreate+0x2b0>
      wait(0);
    5180:	00000513          	li	a0,0
    5184:	685000ef          	jal	6008 <wait>
  for(i = 0; i < N; i++){
    5188:	0014849b          	addiw	s1,s1,1
    518c:	0d448263          	beq	s1,s4,5250 <concreate+0x310>
    file[1] = '0' + i;
    5190:	0304879b          	addiw	a5,s1,48
    5194:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    5198:	659000ef          	jal	5ff0 <fork>
    519c:	00050913          	mv	s2,a0
    if(pid < 0){
    51a0:	f60542e3          	bltz	a0,5104 <concreate+0x1c4>
    if(((i % 3) == 0 && pid == 0) ||
    51a4:	0354e73b          	remw	a4,s1,s5
    51a8:	00a767b3          	or	a5,a4,a0
    51ac:	0007879b          	sext.w	a5,a5
    51b0:	f60786e3          	beqz	a5,511c <concreate+0x1dc>
    51b4:	01671463          	bne	a4,s6,51bc <concreate+0x27c>
       ((i % 3) == 1 && pid != 0)){
    51b8:	f60512e3          	bnez	a0,511c <concreate+0x1dc>
      unlink(file);
    51bc:	fa840513          	addi	a0,s0,-88
    51c0:	6b5000ef          	jal	6074 <unlink>
      unlink(file);
    51c4:	fa840513          	addi	a0,s0,-88
    51c8:	6ad000ef          	jal	6074 <unlink>
      unlink(file);
    51cc:	fa840513          	addi	a0,s0,-88
    51d0:	6a5000ef          	jal	6074 <unlink>
      unlink(file);
    51d4:	fa840513          	addi	a0,s0,-88
    51d8:	69d000ef          	jal	6074 <unlink>
      unlink(file);
    51dc:	fa840513          	addi	a0,s0,-88
    51e0:	695000ef          	jal	6074 <unlink>
      unlink(file);
    51e4:	fa840513          	addi	a0,s0,-88
    51e8:	68d000ef          	jal	6074 <unlink>
    51ec:	f91ff06f          	j	517c <concreate+0x23c>
      exit(0);
    51f0:	00000513          	li	a0,0
    51f4:	609000ef          	jal	5ffc <exit>
      close(fd);
    51f8:	641000ef          	jal	6038 <close>
    if(pid == 0) {
    51fc:	df5ff06f          	j	4ff0 <concreate+0xb0>
      close(fd);
    5200:	639000ef          	jal	6038 <close>
      wait(&xstatus);
    5204:	f6c40513          	addi	a0,s0,-148
    5208:	601000ef          	jal	6008 <wait>
      if(xstatus != 0)
    520c:	f6c42483          	lw	s1,-148(s0)
    5210:	de0494e3          	bnez	s1,4ff8 <concreate+0xb8>
  for(i = 0; i < N; i++){
    5214:	0019091b          	addiw	s2,s2,1
    5218:	df4904e3          	beq	s2,s4,5000 <concreate+0xc0>
    file[1] = '0' + i;
    521c:	0309079b          	addiw	a5,s2,48
    5220:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5224:	fa840513          	addi	a0,s0,-88
    5228:	64d000ef          	jal	6074 <unlink>
    pid = fork();
    522c:	5c5000ef          	jal	5ff0 <fork>
    if(pid && (i % 3) == 1){
    5230:	d6050ce3          	beqz	a0,4fa8 <concreate+0x68>
    5234:	036967bb          	remw	a5,s2,s6
    5238:	d75780e3          	beq	a5,s5,4f98 <concreate+0x58>
      fd = open(file, O_CREATE | O_RDWR);
    523c:	20200593          	li	a1,514
    5240:	fa840513          	addi	a0,s0,-88
    5244:	619000ef          	jal	605c <open>
      if(fd < 0){
    5248:	fa055ce3          	bgez	a0,5200 <concreate+0x2c0>
    524c:	d7dff06f          	j	4fc8 <concreate+0x88>
}
    5250:	09813083          	ld	ra,152(sp)
    5254:	09013403          	ld	s0,144(sp)
    5258:	08813483          	ld	s1,136(sp)
    525c:	08013903          	ld	s2,128(sp)
    5260:	07813983          	ld	s3,120(sp)
    5264:	07013a03          	ld	s4,112(sp)
    5268:	06813a83          	ld	s5,104(sp)
    526c:	06013b03          	ld	s6,96(sp)
    5270:	05813b83          	ld	s7,88(sp)
    5274:	0a010113          	addi	sp,sp,160
    5278:	00008067          	ret

000000000000527c <bigfile>:
{
    527c:	fc010113          	addi	sp,sp,-64
    5280:	02113c23          	sd	ra,56(sp)
    5284:	02813823          	sd	s0,48(sp)
    5288:	02913423          	sd	s1,40(sp)
    528c:	03213023          	sd	s2,32(sp)
    5290:	01313c23          	sd	s3,24(sp)
    5294:	01413823          	sd	s4,16(sp)
    5298:	01513423          	sd	s5,8(sp)
    529c:	04010413          	addi	s0,sp,64
    52a0:	00050a93          	mv	s5,a0
  unlink("bigfile.dat");
    52a4:	00003517          	auipc	a0,0x3
    52a8:	2dc50513          	addi	a0,a0,732 # 8580 <malloc+0x1ea0>
    52ac:	5c9000ef          	jal	6074 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    52b0:	20200593          	li	a1,514
    52b4:	00003517          	auipc	a0,0x3
    52b8:	2cc50513          	addi	a0,a0,716 # 8580 <malloc+0x1ea0>
    52bc:	5a1000ef          	jal	605c <open>
    52c0:	00050993          	mv	s3,a0
  for(i = 0; i < N; i++){
    52c4:	00000493          	li	s1,0
    memset(buf, i, SZ);
    52c8:	00008917          	auipc	s2,0x8
    52cc:	9b090913          	addi	s2,s2,-1616 # cc78 <buf>
  for(i = 0; i < N; i++){
    52d0:	01400a13          	li	s4,20
  if(fd < 0){
    52d4:	0a054663          	bltz	a0,5380 <bigfile+0x104>
    memset(buf, i, SZ);
    52d8:	25800613          	li	a2,600
    52dc:	00048593          	mv	a1,s1
    52e0:	00090513          	mv	a0,s2
    52e4:	219000ef          	jal	5cfc <memset>
    if(write(fd, buf, SZ) != SZ){
    52e8:	25800613          	li	a2,600
    52ec:	00090593          	mv	a1,s2
    52f0:	00098513          	mv	a0,s3
    52f4:	539000ef          	jal	602c <write>
    52f8:	25800793          	li	a5,600
    52fc:	08f51e63          	bne	a0,a5,5398 <bigfile+0x11c>
  for(i = 0; i < N; i++){
    5300:	0014849b          	addiw	s1,s1,1
    5304:	fd449ae3          	bne	s1,s4,52d8 <bigfile+0x5c>
  close(fd);
    5308:	00098513          	mv	a0,s3
    530c:	52d000ef          	jal	6038 <close>
  fd = open("bigfile.dat", 0);
    5310:	00000593          	li	a1,0
    5314:	00003517          	auipc	a0,0x3
    5318:	26c50513          	addi	a0,a0,620 # 8580 <malloc+0x1ea0>
    531c:	541000ef          	jal	605c <open>
    5320:	00050a13          	mv	s4,a0
  total = 0;
    5324:	00000993          	li	s3,0
  for(i = 0; ; i++){
    5328:	00000493          	li	s1,0
    cc = read(fd, buf, SZ/2);
    532c:	00008917          	auipc	s2,0x8
    5330:	94c90913          	addi	s2,s2,-1716 # cc78 <buf>
  if(fd < 0){
    5334:	06054e63          	bltz	a0,53b0 <bigfile+0x134>
    cc = read(fd, buf, SZ/2);
    5338:	12c00613          	li	a2,300
    533c:	00090593          	mv	a1,s2
    5340:	000a0513          	mv	a0,s4
    5344:	4dd000ef          	jal	6020 <read>
    if(cc < 0){
    5348:	08054063          	bltz	a0,53c8 <bigfile+0x14c>
    if(cc == 0)
    534c:	0c050263          	beqz	a0,5410 <bigfile+0x194>
    if(cc != SZ/2){
    5350:	12c00793          	li	a5,300
    5354:	08f51663          	bne	a0,a5,53e0 <bigfile+0x164>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    5358:	01f4d79b          	srliw	a5,s1,0x1f
    535c:	009787bb          	addw	a5,a5,s1
    5360:	4017d79b          	sraiw	a5,a5,0x1
    5364:	00094703          	lbu	a4,0(s2)
    5368:	08f71863          	bne	a4,a5,53f8 <bigfile+0x17c>
    536c:	12b94703          	lbu	a4,299(s2)
    5370:	08f71463          	bne	a4,a5,53f8 <bigfile+0x17c>
    total += cc;
    5374:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    5378:	0014849b          	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    537c:	fbdff06f          	j	5338 <bigfile+0xbc>
    printf("%s: cannot create bigfile", s);
    5380:	000a8593          	mv	a1,s5
    5384:	00003517          	auipc	a0,0x3
    5388:	20c50513          	addi	a0,a0,524 # 8590 <malloc+0x1eb0>
    538c:	254010ef          	jal	65e0 <printf>
    exit(1);
    5390:	00100513          	li	a0,1
    5394:	469000ef          	jal	5ffc <exit>
      printf("%s: write bigfile failed\n", s);
    5398:	000a8593          	mv	a1,s5
    539c:	00003517          	auipc	a0,0x3
    53a0:	21450513          	addi	a0,a0,532 # 85b0 <malloc+0x1ed0>
    53a4:	23c010ef          	jal	65e0 <printf>
      exit(1);
    53a8:	00100513          	li	a0,1
    53ac:	451000ef          	jal	5ffc <exit>
    printf("%s: cannot open bigfile\n", s);
    53b0:	000a8593          	mv	a1,s5
    53b4:	00003517          	auipc	a0,0x3
    53b8:	21c50513          	addi	a0,a0,540 # 85d0 <malloc+0x1ef0>
    53bc:	224010ef          	jal	65e0 <printf>
    exit(1);
    53c0:	00100513          	li	a0,1
    53c4:	439000ef          	jal	5ffc <exit>
      printf("%s: read bigfile failed\n", s);
    53c8:	000a8593          	mv	a1,s5
    53cc:	00003517          	auipc	a0,0x3
    53d0:	22450513          	addi	a0,a0,548 # 85f0 <malloc+0x1f10>
    53d4:	20c010ef          	jal	65e0 <printf>
      exit(1);
    53d8:	00100513          	li	a0,1
    53dc:	421000ef          	jal	5ffc <exit>
      printf("%s: short read bigfile\n", s);
    53e0:	000a8593          	mv	a1,s5
    53e4:	00003517          	auipc	a0,0x3
    53e8:	22c50513          	addi	a0,a0,556 # 8610 <malloc+0x1f30>
    53ec:	1f4010ef          	jal	65e0 <printf>
      exit(1);
    53f0:	00100513          	li	a0,1
    53f4:	409000ef          	jal	5ffc <exit>
      printf("%s: read bigfile wrong data\n", s);
    53f8:	000a8593          	mv	a1,s5
    53fc:	00003517          	auipc	a0,0x3
    5400:	22c50513          	addi	a0,a0,556 # 8628 <malloc+0x1f48>
    5404:	1dc010ef          	jal	65e0 <printf>
      exit(1);
    5408:	00100513          	li	a0,1
    540c:	3f1000ef          	jal	5ffc <exit>
  close(fd);
    5410:	000a0513          	mv	a0,s4
    5414:	425000ef          	jal	6038 <close>
  if(total != N*SZ){
    5418:	000037b7          	lui	a5,0x3
    541c:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrkarg+0xc8>
    5420:	02f99a63          	bne	s3,a5,5454 <bigfile+0x1d8>
  unlink("bigfile.dat");
    5424:	00003517          	auipc	a0,0x3
    5428:	15c50513          	addi	a0,a0,348 # 8580 <malloc+0x1ea0>
    542c:	449000ef          	jal	6074 <unlink>
}
    5430:	03813083          	ld	ra,56(sp)
    5434:	03013403          	ld	s0,48(sp)
    5438:	02813483          	ld	s1,40(sp)
    543c:	02013903          	ld	s2,32(sp)
    5440:	01813983          	ld	s3,24(sp)
    5444:	01013a03          	ld	s4,16(sp)
    5448:	00813a83          	ld	s5,8(sp)
    544c:	04010113          	addi	sp,sp,64
    5450:	00008067          	ret
    printf("%s: read bigfile wrong total\n", s);
    5454:	000a8593          	mv	a1,s5
    5458:	00003517          	auipc	a0,0x3
    545c:	1f050513          	addi	a0,a0,496 # 8648 <malloc+0x1f68>
    5460:	180010ef          	jal	65e0 <printf>
    exit(1);
    5464:	00100513          	li	a0,1
    5468:	395000ef          	jal	5ffc <exit>

000000000000546c <bigargtest>:
{
    546c:	e4010113          	addi	sp,sp,-448
    5470:	1a113c23          	sd	ra,440(sp)
    5474:	1a813823          	sd	s0,432(sp)
    5478:	1a913423          	sd	s1,424(sp)
    547c:	1c010413          	addi	s0,sp,448
    5480:	00050493          	mv	s1,a0
  unlink("bigarg-ok");
    5484:	00003517          	auipc	a0,0x3
    5488:	1e450513          	addi	a0,a0,484 # 8668 <malloc+0x1f88>
    548c:	3e9000ef          	jal	6074 <unlink>
  pid = fork();
    5490:	361000ef          	jal	5ff0 <fork>
  if(pid == 0){
    5494:	04050263          	beqz	a0,54d8 <bigargtest+0x6c>
  } else if(pid < 0){
    5498:	0a054463          	bltz	a0,5540 <bigargtest+0xd4>
  wait(&xstatus);
    549c:	fdc40513          	addi	a0,s0,-36
    54a0:	369000ef          	jal	6008 <wait>
  if(xstatus != 0)
    54a4:	fdc42503          	lw	a0,-36(s0)
    54a8:	0a051863          	bnez	a0,5558 <bigargtest+0xec>
  fd = open("bigarg-ok", 0);
    54ac:	00000593          	li	a1,0
    54b0:	00003517          	auipc	a0,0x3
    54b4:	1b850513          	addi	a0,a0,440 # 8668 <malloc+0x1f88>
    54b8:	3a5000ef          	jal	605c <open>
  if(fd < 0){
    54bc:	0a054063          	bltz	a0,555c <bigargtest+0xf0>
  close(fd);
    54c0:	379000ef          	jal	6038 <close>
}
    54c4:	1b813083          	ld	ra,440(sp)
    54c8:	1b013403          	ld	s0,432(sp)
    54cc:	1a813483          	ld	s1,424(sp)
    54d0:	1c010113          	addi	sp,sp,448
    54d4:	00008067          	ret
    memset(big, ' ', sizeof(big));
    54d8:	19000613          	li	a2,400
    54dc:	02000593          	li	a1,32
    54e0:	e4840513          	addi	a0,s0,-440
    54e4:	019000ef          	jal	5cfc <memset>
    big[sizeof(big)-1] = '\0';
    54e8:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    54ec:	00004797          	auipc	a5,0x4
    54f0:	f7478793          	addi	a5,a5,-140 # 9460 <args.1>
    54f4:	00004697          	auipc	a3,0x4
    54f8:	06468693          	addi	a3,a3,100 # 9558 <args.1+0xf8>
      args[i] = big;
    54fc:	e4840713          	addi	a4,s0,-440
    5500:	00e7b023          	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    5504:	00878793          	addi	a5,a5,8
    5508:	fed79ce3          	bne	a5,a3,5500 <bigargtest+0x94>
    args[MAXARG-1] = 0;
    550c:	00004597          	auipc	a1,0x4
    5510:	f5458593          	addi	a1,a1,-172 # 9460 <args.1>
    5514:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    5518:	00001517          	auipc	a0,0x1
    551c:	37050513          	addi	a0,a0,880 # 6888 <malloc+0x1a8>
    5520:	331000ef          	jal	6050 <exec>
    fd = open("bigarg-ok", O_CREATE);
    5524:	20000593          	li	a1,512
    5528:	00003517          	auipc	a0,0x3
    552c:	14050513          	addi	a0,a0,320 # 8668 <malloc+0x1f88>
    5530:	32d000ef          	jal	605c <open>
    close(fd);
    5534:	305000ef          	jal	6038 <close>
    exit(0);
    5538:	00000513          	li	a0,0
    553c:	2c1000ef          	jal	5ffc <exit>
    printf("%s: bigargtest: fork failed\n", s);
    5540:	00048593          	mv	a1,s1
    5544:	00003517          	auipc	a0,0x3
    5548:	13450513          	addi	a0,a0,308 # 8678 <malloc+0x1f98>
    554c:	094010ef          	jal	65e0 <printf>
    exit(1);
    5550:	00100513          	li	a0,1
    5554:	2a9000ef          	jal	5ffc <exit>
    exit(xstatus);
    5558:	2a5000ef          	jal	5ffc <exit>
    printf("%s: bigarg test failed!\n", s);
    555c:	00048593          	mv	a1,s1
    5560:	00003517          	auipc	a0,0x3
    5564:	13850513          	addi	a0,a0,312 # 8698 <malloc+0x1fb8>
    5568:	078010ef          	jal	65e0 <printf>
    exit(1);
    556c:	00100513          	li	a0,1
    5570:	28d000ef          	jal	5ffc <exit>

0000000000005574 <fsfull>:
{
    5574:	f6010113          	addi	sp,sp,-160
    5578:	08113c23          	sd	ra,152(sp)
    557c:	08813823          	sd	s0,144(sp)
    5580:	08913423          	sd	s1,136(sp)
    5584:	09213023          	sd	s2,128(sp)
    5588:	07313c23          	sd	s3,120(sp)
    558c:	07413823          	sd	s4,112(sp)
    5590:	07513423          	sd	s5,104(sp)
    5594:	07613023          	sd	s6,96(sp)
    5598:	05713c23          	sd	s7,88(sp)
    559c:	05813823          	sd	s8,80(sp)
    55a0:	05913423          	sd	s9,72(sp)
    55a4:	05a13023          	sd	s10,64(sp)
    55a8:	0a010413          	addi	s0,sp,160
  printf("fsfull test\n");
    55ac:	00003517          	auipc	a0,0x3
    55b0:	10c50513          	addi	a0,a0,268 # 86b8 <malloc+0x1fd8>
    55b4:	02c010ef          	jal	65e0 <printf>
  for(nfiles = 0; ; nfiles++){
    55b8:	00000493          	li	s1,0
    name[0] = 'f';
    55bc:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    55c0:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    55c4:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    55c8:	00a00b13          	li	s6,10
    printf("writing %s\n", name);
    55cc:	00003c97          	auipc	s9,0x3
    55d0:	0fcc8c93          	addi	s9,s9,252 # 86c8 <malloc+0x1fe8>
    name[0] = 'f';
    55d4:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    55d8:	0384c7bb          	divw	a5,s1,s8
    55dc:	0307879b          	addiw	a5,a5,48
    55e0:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    55e4:	0384e7bb          	remw	a5,s1,s8
    55e8:	0377c7bb          	divw	a5,a5,s7
    55ec:	0307879b          	addiw	a5,a5,48
    55f0:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    55f4:	0374e7bb          	remw	a5,s1,s7
    55f8:	0367c7bb          	divw	a5,a5,s6
    55fc:	0307879b          	addiw	a5,a5,48
    5600:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    5604:	0364e7bb          	remw	a5,s1,s6
    5608:	0307879b          	addiw	a5,a5,48
    560c:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5610:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    5614:	f6040593          	addi	a1,s0,-160
    5618:	000c8513          	mv	a0,s9
    561c:	7c5000ef          	jal	65e0 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    5620:	20200593          	li	a1,514
    5624:	f6040513          	addi	a0,s0,-160
    5628:	235000ef          	jal	605c <open>
    562c:	00050913          	mv	s2,a0
    if(fd < 0){
    5630:	0c055063          	bgez	a0,56f0 <fsfull+0x17c>
      printf("open %s failed\n", name);
    5634:	f6040593          	addi	a1,s0,-160
    5638:	00003517          	auipc	a0,0x3
    563c:	0a050513          	addi	a0,a0,160 # 86d8 <malloc+0x1ff8>
    5640:	7a1000ef          	jal	65e0 <printf>
  while(nfiles >= 0){
    5644:	0604c463          	bltz	s1,56ac <fsfull+0x138>
    name[0] = 'f';
    5648:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    564c:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5650:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5654:	00a00913          	li	s2,10
  while(nfiles >= 0){
    5658:	fff00a93          	li	s5,-1
    name[0] = 'f';
    565c:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    5660:	0344c7bb          	divw	a5,s1,s4
    5664:	0307879b          	addiw	a5,a5,48
    5668:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    566c:	0344e7bb          	remw	a5,s1,s4
    5670:	0337c7bb          	divw	a5,a5,s3
    5674:	0307879b          	addiw	a5,a5,48
    5678:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    567c:	0334e7bb          	remw	a5,s1,s3
    5680:	0327c7bb          	divw	a5,a5,s2
    5684:	0307879b          	addiw	a5,a5,48
    5688:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    568c:	0324e7bb          	remw	a5,s1,s2
    5690:	0307879b          	addiw	a5,a5,48
    5694:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5698:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    569c:	f6040513          	addi	a0,s0,-160
    56a0:	1d5000ef          	jal	6074 <unlink>
    nfiles--;
    56a4:	fff4849b          	addiw	s1,s1,-1
  while(nfiles >= 0){
    56a8:	fb549ae3          	bne	s1,s5,565c <fsfull+0xe8>
  printf("fsfull test finished\n");
    56ac:	00003517          	auipc	a0,0x3
    56b0:	04c50513          	addi	a0,a0,76 # 86f8 <malloc+0x2018>
    56b4:	72d000ef          	jal	65e0 <printf>
}
    56b8:	09813083          	ld	ra,152(sp)
    56bc:	09013403          	ld	s0,144(sp)
    56c0:	08813483          	ld	s1,136(sp)
    56c4:	08013903          	ld	s2,128(sp)
    56c8:	07813983          	ld	s3,120(sp)
    56cc:	07013a03          	ld	s4,112(sp)
    56d0:	06813a83          	ld	s5,104(sp)
    56d4:	06013b03          	ld	s6,96(sp)
    56d8:	05813b83          	ld	s7,88(sp)
    56dc:	05013c03          	ld	s8,80(sp)
    56e0:	04813c83          	ld	s9,72(sp)
    56e4:	04013d03          	ld	s10,64(sp)
    56e8:	0a010113          	addi	sp,sp,160
    56ec:	00008067          	ret
    int total = 0;
    56f0:	00000993          	li	s3,0
      int cc = write(fd, buf, BSIZE);
    56f4:	00007a97          	auipc	s5,0x7
    56f8:	584a8a93          	addi	s5,s5,1412 # cc78 <buf>
      if(cc < BSIZE)
    56fc:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    5700:	40000613          	li	a2,1024
    5704:	000a8593          	mv	a1,s5
    5708:	00090513          	mv	a0,s2
    570c:	121000ef          	jal	602c <write>
      if(cc < BSIZE)
    5710:	00aa5663          	bge	s4,a0,571c <fsfull+0x1a8>
      total += cc;
    5714:	00a989bb          	addw	s3,s3,a0
    while(1){
    5718:	fe9ff06f          	j	5700 <fsfull+0x18c>
    printf("wrote %d bytes\n", total);
    571c:	00098593          	mv	a1,s3
    5720:	00003517          	auipc	a0,0x3
    5724:	fc850513          	addi	a0,a0,-56 # 86e8 <malloc+0x2008>
    5728:	6b9000ef          	jal	65e0 <printf>
    close(fd);
    572c:	00090513          	mv	a0,s2
    5730:	109000ef          	jal	6038 <close>
    if(total == 0)
    5734:	f00988e3          	beqz	s3,5644 <fsfull+0xd0>
  for(nfiles = 0; ; nfiles++){
    5738:	0014849b          	addiw	s1,s1,1
    573c:	e99ff06f          	j	55d4 <fsfull+0x60>

0000000000005740 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5740:	fd010113          	addi	sp,sp,-48
    5744:	02113423          	sd	ra,40(sp)
    5748:	02813023          	sd	s0,32(sp)
    574c:	00913c23          	sd	s1,24(sp)
    5750:	01213823          	sd	s2,16(sp)
    5754:	03010413          	addi	s0,sp,48
    5758:	00050493          	mv	s1,a0
    575c:	00058913          	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5760:	00003517          	auipc	a0,0x3
    5764:	fb050513          	addi	a0,a0,-80 # 8710 <malloc+0x2030>
    5768:	679000ef          	jal	65e0 <printf>
  if((pid = fork()) < 0) {
    576c:	085000ef          	jal	5ff0 <fork>
    5770:	04054263          	bltz	a0,57b4 <run+0x74>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5774:	04050a63          	beqz	a0,57c8 <run+0x88>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5778:	fdc40513          	addi	a0,s0,-36
    577c:	08d000ef          	jal	6008 <wait>
    if(xstatus != 0) 
    5780:	fdc42783          	lw	a5,-36(s0)
    5784:	04078a63          	beqz	a5,57d8 <run+0x98>
      printf("FAILED\n");
    5788:	00003517          	auipc	a0,0x3
    578c:	fb050513          	addi	a0,a0,-80 # 8738 <malloc+0x2058>
    5790:	651000ef          	jal	65e0 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5794:	fdc42503          	lw	a0,-36(s0)
  }
}
    5798:	00153513          	seqz	a0,a0
    579c:	02813083          	ld	ra,40(sp)
    57a0:	02013403          	ld	s0,32(sp)
    57a4:	01813483          	ld	s1,24(sp)
    57a8:	01013903          	ld	s2,16(sp)
    57ac:	03010113          	addi	sp,sp,48
    57b0:	00008067          	ret
    printf("runtest: fork error\n");
    57b4:	00003517          	auipc	a0,0x3
    57b8:	f6c50513          	addi	a0,a0,-148 # 8720 <malloc+0x2040>
    57bc:	625000ef          	jal	65e0 <printf>
    exit(1);
    57c0:	00100513          	li	a0,1
    57c4:	039000ef          	jal	5ffc <exit>
    f(s);
    57c8:	00090513          	mv	a0,s2
    57cc:	000480e7          	jalr	s1
    exit(0);
    57d0:	00000513          	li	a0,0
    57d4:	029000ef          	jal	5ffc <exit>
      printf("OK\n");
    57d8:	00003517          	auipc	a0,0x3
    57dc:	f6850513          	addi	a0,a0,-152 # 8740 <malloc+0x2060>
    57e0:	601000ef          	jal	65e0 <printf>
    57e4:	fb1ff06f          	j	5794 <run+0x54>

00000000000057e8 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    57e8:	fc010113          	addi	sp,sp,-64
    57ec:	02113c23          	sd	ra,56(sp)
    57f0:	02813823          	sd	s0,48(sp)
    57f4:	03213023          	sd	s2,32(sp)
    57f8:	04010413          	addi	s0,sp,64
  for (struct test *t = tests; t->s != 0; t++) {
    57fc:	00853903          	ld	s2,8(a0)
    5800:	0a090463          	beqz	s2,58a8 <runtests+0xc0>
    5804:	02913423          	sd	s1,40(sp)
    5808:	01313c23          	sd	s3,24(sp)
    580c:	01413823          	sd	s4,16(sp)
    5810:	01513423          	sd	s5,8(sp)
    5814:	00050493          	mv	s1,a0
    5818:	00058993          	mv	s3,a1
    581c:	00060a13          	mv	s4,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    5820:	00200a93          	li	s5,2
    5824:	0100006f          	j	5834 <runtests+0x4c>
  for (struct test *t = tests; t->s != 0; t++) {
    5828:	01048493          	addi	s1,s1,16
    582c:	0084b903          	ld	s2,8(s1)
    5830:	04090863          	beqz	s2,5880 <runtests+0x98>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5834:	00098a63          	beqz	s3,5848 <runtests+0x60>
    5838:	00098593          	mv	a1,s3
    583c:	00090513          	mv	a0,s2
    5840:	434000ef          	jal	5c74 <strcmp>
    5844:	fe0512e3          	bnez	a0,5828 <runtests+0x40>
      if(!run(t->f, t->s)){
    5848:	00090593          	mv	a1,s2
    584c:	0004b503          	ld	a0,0(s1)
    5850:	ef1ff0ef          	jal	5740 <run>
    5854:	fc051ae3          	bnez	a0,5828 <runtests+0x40>
        if(continuous != 2){
    5858:	fd5a08e3          	beq	s4,s5,5828 <runtests+0x40>
          printf("SOME TESTS FAILED\n");
    585c:	00003517          	auipc	a0,0x3
    5860:	eec50513          	addi	a0,a0,-276 # 8748 <malloc+0x2068>
    5864:	57d000ef          	jal	65e0 <printf>
          return 1;
    5868:	00100513          	li	a0,1
    586c:	02813483          	ld	s1,40(sp)
    5870:	01813983          	ld	s3,24(sp)
    5874:	01013a03          	ld	s4,16(sp)
    5878:	00813a83          	ld	s5,8(sp)
    587c:	0180006f          	j	5894 <runtests+0xac>
        }
      }
    }
  }
  return 0;
    5880:	00000513          	li	a0,0
    5884:	02813483          	ld	s1,40(sp)
    5888:	01813983          	ld	s3,24(sp)
    588c:	01013a03          	ld	s4,16(sp)
    5890:	00813a83          	ld	s5,8(sp)
}
    5894:	03813083          	ld	ra,56(sp)
    5898:	03013403          	ld	s0,48(sp)
    589c:	02013903          	ld	s2,32(sp)
    58a0:	04010113          	addi	sp,sp,64
    58a4:	00008067          	ret
  return 0;
    58a8:	00000513          	li	a0,0
    58ac:	fe9ff06f          	j	5894 <runtests+0xac>

00000000000058b0 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    58b0:	fc010113          	addi	sp,sp,-64
    58b4:	02113c23          	sd	ra,56(sp)
    58b8:	02813823          	sd	s0,48(sp)
    58bc:	04010413          	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    58c0:	fc840513          	addi	a0,s0,-56
    58c4:	750000ef          	jal	6014 <pipe>
    58c8:	06054a63          	bltz	a0,593c <countfree+0x8c>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    58cc:	724000ef          	jal	5ff0 <fork>

  if(pid < 0){
    58d0:	08054663          	bltz	a0,595c <countfree+0xac>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    58d4:	0a051863          	bnez	a0,5984 <countfree+0xd4>
    58d8:	02913423          	sd	s1,40(sp)
    58dc:	03213023          	sd	s2,32(sp)
    58e0:	01313c23          	sd	s3,24(sp)
    close(fds[0]);
    58e4:	fc842503          	lw	a0,-56(s0)
    58e8:	750000ef          	jal	6038 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    58ec:	fff00913          	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    58f0:	00100493          	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    58f4:	00001997          	auipc	s3,0x1
    58f8:	00498993          	addi	s3,s3,4 # 68f8 <malloc+0x218>
      uint64 a = (uint64) sbrk(4096);
    58fc:	00001537          	lui	a0,0x1
    5900:	7c8000ef          	jal	60c8 <sbrk>
      if(a == 0xffffffffffffffff){
    5904:	07250c63          	beq	a0,s2,597c <countfree+0xcc>
      *(char *)(a + 4096 - 1) = 1;
    5908:	000017b7          	lui	a5,0x1
    590c:	00a787b3          	add	a5,a5,a0
    5910:	fe978fa3          	sb	s1,-1(a5) # fff <unlinkread+0x183>
      if(write(fds[1], "x", 1) != 1){
    5914:	00048613          	mv	a2,s1
    5918:	00098593          	mv	a1,s3
    591c:	fcc42503          	lw	a0,-52(s0)
    5920:	70c000ef          	jal	602c <write>
    5924:	fc950ce3          	beq	a0,s1,58fc <countfree+0x4c>
        printf("write() failed in countfree()\n");
    5928:	00003517          	auipc	a0,0x3
    592c:	e7850513          	addi	a0,a0,-392 # 87a0 <malloc+0x20c0>
    5930:	4b1000ef          	jal	65e0 <printf>
        exit(1);
    5934:	00100513          	li	a0,1
    5938:	6c4000ef          	jal	5ffc <exit>
    593c:	02913423          	sd	s1,40(sp)
    5940:	03213023          	sd	s2,32(sp)
    5944:	01313c23          	sd	s3,24(sp)
    printf("pipe() failed in countfree()\n");
    5948:	00003517          	auipc	a0,0x3
    594c:	e1850513          	addi	a0,a0,-488 # 8760 <malloc+0x2080>
    5950:	491000ef          	jal	65e0 <printf>
    exit(1);
    5954:	00100513          	li	a0,1
    5958:	6a4000ef          	jal	5ffc <exit>
    595c:	02913423          	sd	s1,40(sp)
    5960:	03213023          	sd	s2,32(sp)
    5964:	01313c23          	sd	s3,24(sp)
    printf("fork failed in countfree()\n");
    5968:	00003517          	auipc	a0,0x3
    596c:	e1850513          	addi	a0,a0,-488 # 8780 <malloc+0x20a0>
    5970:	471000ef          	jal	65e0 <printf>
    exit(1);
    5974:	00100513          	li	a0,1
    5978:	684000ef          	jal	5ffc <exit>
      }
    }

    exit(0);
    597c:	00000513          	li	a0,0
    5980:	67c000ef          	jal	5ffc <exit>
    5984:	02913423          	sd	s1,40(sp)
  }

  close(fds[1]);
    5988:	fcc42503          	lw	a0,-52(s0)
    598c:	6ac000ef          	jal	6038 <close>

  int n = 0;
    5990:	00000493          	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    5994:	00100613          	li	a2,1
    5998:	fc740593          	addi	a1,s0,-57
    599c:	fc842503          	lw	a0,-56(s0)
    59a0:	680000ef          	jal	6020 <read>
    if(cc < 0){
    59a4:	00054863          	bltz	a0,59b4 <countfree+0x104>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    59a8:	02050463          	beqz	a0,59d0 <countfree+0x120>
      break;
    n += 1;
    59ac:	0014849b          	addiw	s1,s1,1
  while(1){
    59b0:	fe5ff06f          	j	5994 <countfree+0xe4>
    59b4:	03213023          	sd	s2,32(sp)
    59b8:	01313c23          	sd	s3,24(sp)
      printf("read() failed in countfree()\n");
    59bc:	00003517          	auipc	a0,0x3
    59c0:	e0450513          	addi	a0,a0,-508 # 87c0 <malloc+0x20e0>
    59c4:	41d000ef          	jal	65e0 <printf>
      exit(1);
    59c8:	00100513          	li	a0,1
    59cc:	630000ef          	jal	5ffc <exit>
  }

  close(fds[0]);
    59d0:	fc842503          	lw	a0,-56(s0)
    59d4:	664000ef          	jal	6038 <close>
  wait((int*)0);
    59d8:	00000513          	li	a0,0
    59dc:	62c000ef          	jal	6008 <wait>
  
  return n;
}
    59e0:	00048513          	mv	a0,s1
    59e4:	02813483          	ld	s1,40(sp)
    59e8:	03813083          	ld	ra,56(sp)
    59ec:	03013403          	ld	s0,48(sp)
    59f0:	04010113          	addi	sp,sp,64
    59f4:	00008067          	ret

00000000000059f8 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    59f8:	fa010113          	addi	sp,sp,-96
    59fc:	04113c23          	sd	ra,88(sp)
    5a00:	04813823          	sd	s0,80(sp)
    5a04:	04913423          	sd	s1,72(sp)
    5a08:	05213023          	sd	s2,64(sp)
    5a0c:	03313c23          	sd	s3,56(sp)
    5a10:	03413823          	sd	s4,48(sp)
    5a14:	03513423          	sd	s5,40(sp)
    5a18:	03613023          	sd	s6,32(sp)
    5a1c:	01713c23          	sd	s7,24(sp)
    5a20:	01813823          	sd	s8,16(sp)
    5a24:	01913423          	sd	s9,8(sp)
    5a28:	01a13023          	sd	s10,0(sp)
    5a2c:	06010413          	addi	s0,sp,96
    5a30:	00050a93          	mv	s5,a0
    5a34:	00058913          	mv	s2,a1
    5a38:	00060993          	mv	s3,a2
  do {
    printf("usertests starting\n");
    5a3c:	00003b97          	auipc	s7,0x3
    5a40:	da4b8b93          	addi	s7,s7,-604 # 87e0 <malloc+0x2100>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    5a44:	00003b17          	auipc	s6,0x3
    5a48:	5ccb0b13          	addi	s6,s6,1484 # 9010 <quicktests>
      if(continuous != 2) {
    5a4c:	00200a13          	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone, continuous)) {
    5a50:	00004c17          	auipc	s8,0x4
    5a54:	990c0c13          	addi	s8,s8,-1648 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    5a58:	00003d17          	auipc	s10,0x3
    5a5c:	da0d0d13          	addi	s10,s10,-608 # 87f8 <malloc+0x2118>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5a60:	00003c97          	auipc	s9,0x3
    5a64:	db8c8c93          	addi	s9,s9,-584 # 8818 <malloc+0x2138>
    5a68:	01c0006f          	j	5a84 <drivetests+0x8c>
        printf("usertests slow tests starting\n");
    5a6c:	000d0513          	mv	a0,s10
    5a70:	371000ef          	jal	65e0 <printf>
    5a74:	0400006f          	j	5ab4 <drivetests+0xbc>
    if((free1 = countfree()) < free0) {
    5a78:	e39ff0ef          	jal	58b0 <countfree>
    5a7c:	04954c63          	blt	a0,s1,5ad4 <drivetests+0xdc>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    5a80:	06090c63          	beqz	s2,5af8 <drivetests+0x100>
    printf("usertests starting\n");
    5a84:	000b8513          	mv	a0,s7
    5a88:	359000ef          	jal	65e0 <printf>
    int free0 = countfree();
    5a8c:	e25ff0ef          	jal	58b0 <countfree>
    5a90:	00050493          	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    5a94:	00090613          	mv	a2,s2
    5a98:	00098593          	mv	a1,s3
    5a9c:	000b0513          	mv	a0,s6
    5aa0:	d49ff0ef          	jal	57e8 <runtests>
    5aa4:	00050463          	beqz	a0,5aac <drivetests+0xb4>
      if(continuous != 2) {
    5aa8:	05491463          	bne	s2,s4,5af0 <drivetests+0xf8>
    if(!quick) {
    5aac:	fc0a96e3          	bnez	s5,5a78 <drivetests+0x80>
      if (justone == 0)
    5ab0:	fa098ee3          	beqz	s3,5a6c <drivetests+0x74>
      if (runtests(slowtests, justone, continuous)) {
    5ab4:	00090613          	mv	a2,s2
    5ab8:	00098593          	mv	a1,s3
    5abc:	000c0513          	mv	a0,s8
    5ac0:	d29ff0ef          	jal	57e8 <runtests>
    5ac4:	fa050ae3          	beqz	a0,5a78 <drivetests+0x80>
        if(continuous != 2) {
    5ac8:	fb4908e3          	beq	s2,s4,5a78 <drivetests+0x80>
          return 1;
    5acc:	00100513          	li	a0,1
    5ad0:	02c0006f          	j	5afc <drivetests+0x104>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5ad4:	00048613          	mv	a2,s1
    5ad8:	00050593          	mv	a1,a0
    5adc:	000c8513          	mv	a0,s9
    5ae0:	301000ef          	jal	65e0 <printf>
      if(continuous != 2) {
    5ae4:	fb4900e3          	beq	s2,s4,5a84 <drivetests+0x8c>
        return 1;
    5ae8:	00100513          	li	a0,1
    5aec:	0100006f          	j	5afc <drivetests+0x104>
        return 1;
    5af0:	00100513          	li	a0,1
    5af4:	0080006f          	j	5afc <drivetests+0x104>
  return 0;
    5af8:	00090513          	mv	a0,s2
}
    5afc:	05813083          	ld	ra,88(sp)
    5b00:	05013403          	ld	s0,80(sp)
    5b04:	04813483          	ld	s1,72(sp)
    5b08:	04013903          	ld	s2,64(sp)
    5b0c:	03813983          	ld	s3,56(sp)
    5b10:	03013a03          	ld	s4,48(sp)
    5b14:	02813a83          	ld	s5,40(sp)
    5b18:	02013b03          	ld	s6,32(sp)
    5b1c:	01813b83          	ld	s7,24(sp)
    5b20:	01013c03          	ld	s8,16(sp)
    5b24:	00813c83          	ld	s9,8(sp)
    5b28:	00013d03          	ld	s10,0(sp)
    5b2c:	06010113          	addi	sp,sp,96
    5b30:	00008067          	ret

0000000000005b34 <main>:

int
main(int argc, char *argv[])
{
    5b34:	fe010113          	addi	sp,sp,-32
    5b38:	00113c23          	sd	ra,24(sp)
    5b3c:	00813823          	sd	s0,16(sp)
    5b40:	00913423          	sd	s1,8(sp)
    5b44:	01213023          	sd	s2,0(sp)
    5b48:	02010413          	addi	s0,sp,32
    5b4c:	00050493          	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5b50:	00200793          	li	a5,2
    5b54:	02f50663          	beq	a0,a5,5b80 <main+0x4c>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5b58:	00100793          	li	a5,1
    5b5c:	08a7c063          	blt	a5,a0,5bdc <main+0xa8>
  char *justone = 0;
    5b60:	00000913          	li	s2,0
  int quick = 0;
    5b64:	00000513          	li	a0,0
  int continuous = 0;
    5b68:	00000593          	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    5b6c:	00090613          	mv	a2,s2
    5b70:	e89ff0ef          	jal	59f8 <drivetests>
    5b74:	0a050063          	beqz	a0,5c14 <main+0xe0>
    exit(1);
    5b78:	00100513          	li	a0,1
    5b7c:	480000ef          	jal	5ffc <exit>
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5b80:	0085b903          	ld	s2,8(a1)
    5b84:	00003597          	auipc	a1,0x3
    5b88:	cc458593          	addi	a1,a1,-828 # 8848 <malloc+0x2168>
    5b8c:	00090513          	mv	a0,s2
    5b90:	0e4000ef          	jal	5c74 <strcmp>
    5b94:	00050593          	mv	a1,a0
    5b98:	04050c63          	beqz	a0,5bf0 <main+0xbc>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5b9c:	00003597          	auipc	a1,0x3
    5ba0:	cb458593          	addi	a1,a1,-844 # 8850 <malloc+0x2170>
    5ba4:	00090513          	mv	a0,s2
    5ba8:	0cc000ef          	jal	5c74 <strcmp>
    5bac:	04050863          	beqz	a0,5bfc <main+0xc8>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5bb0:	00003597          	auipc	a1,0x3
    5bb4:	ca858593          	addi	a1,a1,-856 # 8858 <malloc+0x2178>
    5bb8:	00090513          	mv	a0,s2
    5bbc:	0b8000ef          	jal	5c74 <strcmp>
    5bc0:	04050463          	beqz	a0,5c08 <main+0xd4>
  } else if(argc == 2 && argv[1][0] != '-'){
    5bc4:	00094703          	lbu	a4,0(s2)
    5bc8:	02d00793          	li	a5,45
    5bcc:	00f70863          	beq	a4,a5,5bdc <main+0xa8>
  int quick = 0;
    5bd0:	00000513          	li	a0,0
  int continuous = 0;
    5bd4:	00000593          	li	a1,0
    5bd8:	f95ff06f          	j	5b6c <main+0x38>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    5bdc:	00003517          	auipc	a0,0x3
    5be0:	c8450513          	addi	a0,a0,-892 # 8860 <malloc+0x2180>
    5be4:	1fd000ef          	jal	65e0 <printf>
    exit(1);
    5be8:	00100513          	li	a0,1
    5bec:	410000ef          	jal	5ffc <exit>
  char *justone = 0;
    5bf0:	00000913          	li	s2,0
    quick = 1;
    5bf4:	00100513          	li	a0,1
    5bf8:	f75ff06f          	j	5b6c <main+0x38>
  char *justone = 0;
    5bfc:	00000913          	li	s2,0
    continuous = 1;
    5c00:	00100593          	li	a1,1
    5c04:	f69ff06f          	j	5b6c <main+0x38>
    continuous = 2;
    5c08:	00048593          	mv	a1,s1
  char *justone = 0;
    5c0c:	00000913          	li	s2,0
    5c10:	f5dff06f          	j	5b6c <main+0x38>
  }
  printf("ALL TESTS PASSED\n");
    5c14:	00003517          	auipc	a0,0x3
    5c18:	c7c50513          	addi	a0,a0,-900 # 8890 <malloc+0x21b0>
    5c1c:	1c5000ef          	jal	65e0 <printf>
  exit(0);
    5c20:	00000513          	li	a0,0
    5c24:	3d8000ef          	jal	5ffc <exit>

0000000000005c28 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    5c28:	ff010113          	addi	sp,sp,-16
    5c2c:	00113423          	sd	ra,8(sp)
    5c30:	00813023          	sd	s0,0(sp)
    5c34:	01010413          	addi	s0,sp,16
  extern int main();
  main();
    5c38:	efdff0ef          	jal	5b34 <main>
  exit(0);
    5c3c:	00000513          	li	a0,0
    5c40:	3bc000ef          	jal	5ffc <exit>

0000000000005c44 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5c44:	ff010113          	addi	sp,sp,-16
    5c48:	00813423          	sd	s0,8(sp)
    5c4c:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5c50:	00050793          	mv	a5,a0
    5c54:	00158593          	addi	a1,a1,1
    5c58:	00178793          	addi	a5,a5,1
    5c5c:	fff5c703          	lbu	a4,-1(a1)
    5c60:	fee78fa3          	sb	a4,-1(a5)
    5c64:	fe0718e3          	bnez	a4,5c54 <strcpy+0x10>
    ;
  return os;
}
    5c68:	00813403          	ld	s0,8(sp)
    5c6c:	01010113          	addi	sp,sp,16
    5c70:	00008067          	ret

0000000000005c74 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5c74:	ff010113          	addi	sp,sp,-16
    5c78:	00813423          	sd	s0,8(sp)
    5c7c:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
    5c80:	00054783          	lbu	a5,0(a0)
    5c84:	00078e63          	beqz	a5,5ca0 <strcmp+0x2c>
    5c88:	0005c703          	lbu	a4,0(a1)
    5c8c:	00f71a63          	bne	a4,a5,5ca0 <strcmp+0x2c>
    p++, q++;
    5c90:	00150513          	addi	a0,a0,1
    5c94:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
    5c98:	00054783          	lbu	a5,0(a0)
    5c9c:	fe0796e3          	bnez	a5,5c88 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    5ca0:	0005c503          	lbu	a0,0(a1)
}
    5ca4:	40a7853b          	subw	a0,a5,a0
    5ca8:	00813403          	ld	s0,8(sp)
    5cac:	01010113          	addi	sp,sp,16
    5cb0:	00008067          	ret

0000000000005cb4 <strlen>:

uint
strlen(const char *s)
{
    5cb4:	ff010113          	addi	sp,sp,-16
    5cb8:	00813423          	sd	s0,8(sp)
    5cbc:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5cc0:	00054783          	lbu	a5,0(a0)
    5cc4:	02078863          	beqz	a5,5cf4 <strlen+0x40>
    5cc8:	00150513          	addi	a0,a0,1
    5ccc:	00050793          	mv	a5,a0
    5cd0:	00078693          	mv	a3,a5
    5cd4:	00178793          	addi	a5,a5,1
    5cd8:	fff7c703          	lbu	a4,-1(a5)
    5cdc:	fe071ae3          	bnez	a4,5cd0 <strlen+0x1c>
    5ce0:	40a6853b          	subw	a0,a3,a0
    5ce4:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
    5ce8:	00813403          	ld	s0,8(sp)
    5cec:	01010113          	addi	sp,sp,16
    5cf0:	00008067          	ret
  for(n = 0; s[n]; n++)
    5cf4:	00000513          	li	a0,0
    5cf8:	ff1ff06f          	j	5ce8 <strlen+0x34>

0000000000005cfc <memset>:

void*
memset(void *dst, int c, uint n)
{
    5cfc:	ff010113          	addi	sp,sp,-16
    5d00:	00813423          	sd	s0,8(sp)
    5d04:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5d08:	02060063          	beqz	a2,5d28 <memset+0x2c>
    5d0c:	00050793          	mv	a5,a0
    5d10:	02061613          	slli	a2,a2,0x20
    5d14:	02065613          	srli	a2,a2,0x20
    5d18:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5d1c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5d20:	00178793          	addi	a5,a5,1
    5d24:	fee79ce3          	bne	a5,a4,5d1c <memset+0x20>
  }
  return dst;
}
    5d28:	00813403          	ld	s0,8(sp)
    5d2c:	01010113          	addi	sp,sp,16
    5d30:	00008067          	ret

0000000000005d34 <strchr>:

char*
strchr(const char *s, char c)
{
    5d34:	ff010113          	addi	sp,sp,-16
    5d38:	00813423          	sd	s0,8(sp)
    5d3c:	01010413          	addi	s0,sp,16
  for(; *s; s++)
    5d40:	00054783          	lbu	a5,0(a0)
    5d44:	02078263          	beqz	a5,5d68 <strchr+0x34>
    if(*s == c)
    5d48:	00f58a63          	beq	a1,a5,5d5c <strchr+0x28>
  for(; *s; s++)
    5d4c:	00150513          	addi	a0,a0,1
    5d50:	00054783          	lbu	a5,0(a0)
    5d54:	fe079ae3          	bnez	a5,5d48 <strchr+0x14>
      return (char*)s;
  return 0;
    5d58:	00000513          	li	a0,0
}
    5d5c:	00813403          	ld	s0,8(sp)
    5d60:	01010113          	addi	sp,sp,16
    5d64:	00008067          	ret
  return 0;
    5d68:	00000513          	li	a0,0
    5d6c:	ff1ff06f          	j	5d5c <strchr+0x28>

0000000000005d70 <gets>:

char*
gets(char *buf, int max)
{
    5d70:	fa010113          	addi	sp,sp,-96
    5d74:	04113c23          	sd	ra,88(sp)
    5d78:	04813823          	sd	s0,80(sp)
    5d7c:	04913423          	sd	s1,72(sp)
    5d80:	05213023          	sd	s2,64(sp)
    5d84:	03313c23          	sd	s3,56(sp)
    5d88:	03413823          	sd	s4,48(sp)
    5d8c:	03513423          	sd	s5,40(sp)
    5d90:	03613023          	sd	s6,32(sp)
    5d94:	01713c23          	sd	s7,24(sp)
    5d98:	06010413          	addi	s0,sp,96
    5d9c:	00050b93          	mv	s7,a0
    5da0:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5da4:	00050913          	mv	s2,a0
    5da8:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5dac:	00a00a93          	li	s5,10
    5db0:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
    5db4:	00048993          	mv	s3,s1
    5db8:	0014849b          	addiw	s1,s1,1
    5dbc:	0344dc63          	bge	s1,s4,5df4 <gets+0x84>
    cc = read(0, &c, 1);
    5dc0:	00100613          	li	a2,1
    5dc4:	faf40593          	addi	a1,s0,-81
    5dc8:	00000513          	li	a0,0
    5dcc:	254000ef          	jal	6020 <read>
    if(cc < 1)
    5dd0:	02a05263          	blez	a0,5df4 <gets+0x84>
    buf[i++] = c;
    5dd4:	faf44783          	lbu	a5,-81(s0)
    5dd8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5ddc:	01578a63          	beq	a5,s5,5df0 <gets+0x80>
    5de0:	00190913          	addi	s2,s2,1
    5de4:	fd6798e3          	bne	a5,s6,5db4 <gets+0x44>
    buf[i++] = c;
    5de8:	00048993          	mv	s3,s1
    5dec:	0080006f          	j	5df4 <gets+0x84>
    5df0:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5df4:	013b89b3          	add	s3,s7,s3
    5df8:	00098023          	sb	zero,0(s3)
  return buf;
}
    5dfc:	000b8513          	mv	a0,s7
    5e00:	05813083          	ld	ra,88(sp)
    5e04:	05013403          	ld	s0,80(sp)
    5e08:	04813483          	ld	s1,72(sp)
    5e0c:	04013903          	ld	s2,64(sp)
    5e10:	03813983          	ld	s3,56(sp)
    5e14:	03013a03          	ld	s4,48(sp)
    5e18:	02813a83          	ld	s5,40(sp)
    5e1c:	02013b03          	ld	s6,32(sp)
    5e20:	01813b83          	ld	s7,24(sp)
    5e24:	06010113          	addi	sp,sp,96
    5e28:	00008067          	ret

0000000000005e2c <stat>:

int
stat(const char *n, struct stat *st)
{
    5e2c:	fe010113          	addi	sp,sp,-32
    5e30:	00113c23          	sd	ra,24(sp)
    5e34:	00813823          	sd	s0,16(sp)
    5e38:	01213023          	sd	s2,0(sp)
    5e3c:	02010413          	addi	s0,sp,32
    5e40:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5e44:	00000593          	li	a1,0
    5e48:	214000ef          	jal	605c <open>
  if(fd < 0)
    5e4c:	02054e63          	bltz	a0,5e88 <stat+0x5c>
    5e50:	00913423          	sd	s1,8(sp)
    5e54:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5e58:	00090593          	mv	a1,s2
    5e5c:	224000ef          	jal	6080 <fstat>
    5e60:	00050913          	mv	s2,a0
  close(fd);
    5e64:	00048513          	mv	a0,s1
    5e68:	1d0000ef          	jal	6038 <close>
  return r;
    5e6c:	00813483          	ld	s1,8(sp)
}
    5e70:	00090513          	mv	a0,s2
    5e74:	01813083          	ld	ra,24(sp)
    5e78:	01013403          	ld	s0,16(sp)
    5e7c:	00013903          	ld	s2,0(sp)
    5e80:	02010113          	addi	sp,sp,32
    5e84:	00008067          	ret
    return -1;
    5e88:	fff00913          	li	s2,-1
    5e8c:	fe5ff06f          	j	5e70 <stat+0x44>

0000000000005e90 <atoi>:

int
atoi(const char *s)
{
    5e90:	ff010113          	addi	sp,sp,-16
    5e94:	00813423          	sd	s0,8(sp)
    5e98:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5e9c:	00054683          	lbu	a3,0(a0)
    5ea0:	fd06879b          	addiw	a5,a3,-48
    5ea4:	0ff7f793          	zext.b	a5,a5
    5ea8:	00900613          	li	a2,9
    5eac:	04f66063          	bltu	a2,a5,5eec <atoi+0x5c>
    5eb0:	00050713          	mv	a4,a0
  n = 0;
    5eb4:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
    5eb8:	00170713          	addi	a4,a4,1
    5ebc:	0025179b          	slliw	a5,a0,0x2
    5ec0:	00a787bb          	addw	a5,a5,a0
    5ec4:	0017979b          	slliw	a5,a5,0x1
    5ec8:	00d787bb          	addw	a5,a5,a3
    5ecc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5ed0:	00074683          	lbu	a3,0(a4)
    5ed4:	fd06879b          	addiw	a5,a3,-48
    5ed8:	0ff7f793          	zext.b	a5,a5
    5edc:	fcf67ee3          	bgeu	a2,a5,5eb8 <atoi+0x28>
  return n;
}
    5ee0:	00813403          	ld	s0,8(sp)
    5ee4:	01010113          	addi	sp,sp,16
    5ee8:	00008067          	ret
  n = 0;
    5eec:	00000513          	li	a0,0
    5ef0:	ff1ff06f          	j	5ee0 <atoi+0x50>

0000000000005ef4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5ef4:	ff010113          	addi	sp,sp,-16
    5ef8:	00813423          	sd	s0,8(sp)
    5efc:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5f00:	02b57c63          	bgeu	a0,a1,5f38 <memmove+0x44>
    while(n-- > 0)
    5f04:	02c05463          	blez	a2,5f2c <memmove+0x38>
    5f08:	02061613          	slli	a2,a2,0x20
    5f0c:	02065613          	srli	a2,a2,0x20
    5f10:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5f14:	00050713          	mv	a4,a0
      *dst++ = *src++;
    5f18:	00158593          	addi	a1,a1,1
    5f1c:	00170713          	addi	a4,a4,1
    5f20:	fff5c683          	lbu	a3,-1(a1)
    5f24:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5f28:	fef718e3          	bne	a4,a5,5f18 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5f2c:	00813403          	ld	s0,8(sp)
    5f30:	01010113          	addi	sp,sp,16
    5f34:	00008067          	ret
    dst += n;
    5f38:	00c50733          	add	a4,a0,a2
    src += n;
    5f3c:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
    5f40:	fec056e3          	blez	a2,5f2c <memmove+0x38>
    5f44:	fff6079b          	addiw	a5,a2,-1 # 2fff <sbrkbugs+0x83>
    5f48:	02079793          	slli	a5,a5,0x20
    5f4c:	0207d793          	srli	a5,a5,0x20
    5f50:	fff7c793          	not	a5,a5
    5f54:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
    5f58:	fff58593          	addi	a1,a1,-1
    5f5c:	fff70713          	addi	a4,a4,-1
    5f60:	0005c683          	lbu	a3,0(a1)
    5f64:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5f68:	fee798e3          	bne	a5,a4,5f58 <memmove+0x64>
    5f6c:	fc1ff06f          	j	5f2c <memmove+0x38>

0000000000005f70 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5f70:	ff010113          	addi	sp,sp,-16
    5f74:	00813423          	sd	s0,8(sp)
    5f78:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5f7c:	04060463          	beqz	a2,5fc4 <memcmp+0x54>
    5f80:	fff6069b          	addiw	a3,a2,-1
    5f84:	02069693          	slli	a3,a3,0x20
    5f88:	0206d693          	srli	a3,a3,0x20
    5f8c:	00168693          	addi	a3,a3,1
    5f90:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
    5f94:	00054783          	lbu	a5,0(a0)
    5f98:	0005c703          	lbu	a4,0(a1)
    5f9c:	00e79c63          	bne	a5,a4,5fb4 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
    5fa0:	00150513          	addi	a0,a0,1
    p2++;
    5fa4:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
    5fa8:	fed516e3          	bne	a0,a3,5f94 <memcmp+0x24>
  }
  return 0;
    5fac:	00000513          	li	a0,0
    5fb0:	0080006f          	j	5fb8 <memcmp+0x48>
      return *p1 - *p2;
    5fb4:	40e7853b          	subw	a0,a5,a4
}
    5fb8:	00813403          	ld	s0,8(sp)
    5fbc:	01010113          	addi	sp,sp,16
    5fc0:	00008067          	ret
  return 0;
    5fc4:	00000513          	li	a0,0
    5fc8:	ff1ff06f          	j	5fb8 <memcmp+0x48>

0000000000005fcc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5fcc:	ff010113          	addi	sp,sp,-16
    5fd0:	00113423          	sd	ra,8(sp)
    5fd4:	00813023          	sd	s0,0(sp)
    5fd8:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
    5fdc:	f19ff0ef          	jal	5ef4 <memmove>
}
    5fe0:	00813083          	ld	ra,8(sp)
    5fe4:	00013403          	ld	s0,0(sp)
    5fe8:	01010113          	addi	sp,sp,16
    5fec:	00008067          	ret

0000000000005ff0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5ff0:	00100893          	li	a7,1
 ecall
    5ff4:	00000073          	ecall
 ret
    5ff8:	00008067          	ret

0000000000005ffc <exit>:
.global exit
exit:
 li a7, SYS_exit
    5ffc:	00200893          	li	a7,2
 ecall
    6000:	00000073          	ecall
 ret
    6004:	00008067          	ret

0000000000006008 <wait>:
.global wait
wait:
 li a7, SYS_wait
    6008:	00300893          	li	a7,3
 ecall
    600c:	00000073          	ecall
 ret
    6010:	00008067          	ret

0000000000006014 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    6014:	00400893          	li	a7,4
 ecall
    6018:	00000073          	ecall
 ret
    601c:	00008067          	ret

0000000000006020 <read>:
.global read
read:
 li a7, SYS_read
    6020:	00500893          	li	a7,5
 ecall
    6024:	00000073          	ecall
 ret
    6028:	00008067          	ret

000000000000602c <write>:
.global write
write:
 li a7, SYS_write
    602c:	01000893          	li	a7,16
 ecall
    6030:	00000073          	ecall
 ret
    6034:	00008067          	ret

0000000000006038 <close>:
.global close
close:
 li a7, SYS_close
    6038:	01500893          	li	a7,21
 ecall
    603c:	00000073          	ecall
 ret
    6040:	00008067          	ret

0000000000006044 <kill>:
.global kill
kill:
 li a7, SYS_kill
    6044:	00600893          	li	a7,6
 ecall
    6048:	00000073          	ecall
 ret
    604c:	00008067          	ret

0000000000006050 <exec>:
.global exec
exec:
 li a7, SYS_exec
    6050:	00700893          	li	a7,7
 ecall
    6054:	00000073          	ecall
 ret
    6058:	00008067          	ret

000000000000605c <open>:
.global open
open:
 li a7, SYS_open
    605c:	00f00893          	li	a7,15
 ecall
    6060:	00000073          	ecall
 ret
    6064:	00008067          	ret

0000000000006068 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    6068:	01100893          	li	a7,17
 ecall
    606c:	00000073          	ecall
 ret
    6070:	00008067          	ret

0000000000006074 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    6074:	01200893          	li	a7,18
 ecall
    6078:	00000073          	ecall
 ret
    607c:	00008067          	ret

0000000000006080 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    6080:	00800893          	li	a7,8
 ecall
    6084:	00000073          	ecall
 ret
    6088:	00008067          	ret

000000000000608c <link>:
.global link
link:
 li a7, SYS_link
    608c:	01300893          	li	a7,19
 ecall
    6090:	00000073          	ecall
 ret
    6094:	00008067          	ret

0000000000006098 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    6098:	01400893          	li	a7,20
 ecall
    609c:	00000073          	ecall
 ret
    60a0:	00008067          	ret

00000000000060a4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    60a4:	00900893          	li	a7,9
 ecall
    60a8:	00000073          	ecall
 ret
    60ac:	00008067          	ret

00000000000060b0 <dup>:
.global dup
dup:
 li a7, SYS_dup
    60b0:	00a00893          	li	a7,10
 ecall
    60b4:	00000073          	ecall
 ret
    60b8:	00008067          	ret

00000000000060bc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    60bc:	00b00893          	li	a7,11
 ecall
    60c0:	00000073          	ecall
 ret
    60c4:	00008067          	ret

00000000000060c8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    60c8:	00c00893          	li	a7,12
 ecall
    60cc:	00000073          	ecall
 ret
    60d0:	00008067          	ret

00000000000060d4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    60d4:	00d00893          	li	a7,13
 ecall
    60d8:	00000073          	ecall
 ret
    60dc:	00008067          	ret

00000000000060e0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    60e0:	00e00893          	li	a7,14
 ecall
    60e4:	00000073          	ecall
 ret
    60e8:	00008067          	ret

00000000000060ec <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    60ec:	fe010113          	addi	sp,sp,-32
    60f0:	00113c23          	sd	ra,24(sp)
    60f4:	00813823          	sd	s0,16(sp)
    60f8:	02010413          	addi	s0,sp,32
    60fc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    6100:	00100613          	li	a2,1
    6104:	fef40593          	addi	a1,s0,-17
    6108:	f25ff0ef          	jal	602c <write>
}
    610c:	01813083          	ld	ra,24(sp)
    6110:	01013403          	ld	s0,16(sp)
    6114:	02010113          	addi	sp,sp,32
    6118:	00008067          	ret

000000000000611c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    611c:	fc010113          	addi	sp,sp,-64
    6120:	02113c23          	sd	ra,56(sp)
    6124:	02813823          	sd	s0,48(sp)
    6128:	02913423          	sd	s1,40(sp)
    612c:	04010413          	addi	s0,sp,64
    6130:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    6134:	00068463          	beqz	a3,613c <printint+0x20>
    6138:	0c05c263          	bltz	a1,61fc <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    613c:	0005859b          	sext.w	a1,a1
  neg = 0;
    6140:	00000893          	li	a7,0
    6144:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    6148:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
    614c:	0006061b          	sext.w	a2,a2
    6150:	00003517          	auipc	a0,0x3
    6154:	b1050513          	addi	a0,a0,-1264 # 8c60 <digits>
    6158:	00070813          	mv	a6,a4
    615c:	0017071b          	addiw	a4,a4,1
    6160:	02c5f7bb          	remuw	a5,a1,a2
    6164:	02079793          	slli	a5,a5,0x20
    6168:	0207d793          	srli	a5,a5,0x20
    616c:	00f507b3          	add	a5,a0,a5
    6170:	0007c783          	lbu	a5,0(a5)
    6174:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    6178:	0005879b          	sext.w	a5,a1
    617c:	02c5d5bb          	divuw	a1,a1,a2
    6180:	00168693          	addi	a3,a3,1
    6184:	fcc7fae3          	bgeu	a5,a2,6158 <printint+0x3c>
  if(neg)
    6188:	00088c63          	beqz	a7,61a0 <printint+0x84>
    buf[i++] = '-';
    618c:	fd070793          	addi	a5,a4,-48
    6190:	00878733          	add	a4,a5,s0
    6194:	02d00793          	li	a5,45
    6198:	fef70823          	sb	a5,-16(a4)
    619c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    61a0:	04e05463          	blez	a4,61e8 <printint+0xcc>
    61a4:	03213023          	sd	s2,32(sp)
    61a8:	01313c23          	sd	s3,24(sp)
    61ac:	fc040793          	addi	a5,s0,-64
    61b0:	00e78933          	add	s2,a5,a4
    61b4:	fff78993          	addi	s3,a5,-1
    61b8:	00e989b3          	add	s3,s3,a4
    61bc:	fff7071b          	addiw	a4,a4,-1
    61c0:	02071713          	slli	a4,a4,0x20
    61c4:	02075713          	srli	a4,a4,0x20
    61c8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    61cc:	fff94583          	lbu	a1,-1(s2)
    61d0:	00048513          	mv	a0,s1
    61d4:	f19ff0ef          	jal	60ec <putc>
  while(--i >= 0)
    61d8:	fff90913          	addi	s2,s2,-1
    61dc:	ff3918e3          	bne	s2,s3,61cc <printint+0xb0>
    61e0:	02013903          	ld	s2,32(sp)
    61e4:	01813983          	ld	s3,24(sp)
}
    61e8:	03813083          	ld	ra,56(sp)
    61ec:	03013403          	ld	s0,48(sp)
    61f0:	02813483          	ld	s1,40(sp)
    61f4:	04010113          	addi	sp,sp,64
    61f8:	00008067          	ret
    x = -xx;
    61fc:	40b005bb          	negw	a1,a1
    neg = 1;
    6200:	00100893          	li	a7,1
    x = -xx;
    6204:	f41ff06f          	j	6144 <printint+0x28>

0000000000006208 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    6208:	fa010113          	addi	sp,sp,-96
    620c:	04113c23          	sd	ra,88(sp)
    6210:	04813823          	sd	s0,80(sp)
    6214:	05213023          	sd	s2,64(sp)
    6218:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    621c:	0005c903          	lbu	s2,0(a1)
    6220:	36090463          	beqz	s2,6588 <vprintf+0x380>
    6224:	04913423          	sd	s1,72(sp)
    6228:	03313c23          	sd	s3,56(sp)
    622c:	03413823          	sd	s4,48(sp)
    6230:	03513423          	sd	s5,40(sp)
    6234:	03613023          	sd	s6,32(sp)
    6238:	01713c23          	sd	s7,24(sp)
    623c:	01813823          	sd	s8,16(sp)
    6240:	01913423          	sd	s9,8(sp)
    6244:	00050b13          	mv	s6,a0
    6248:	00058a13          	mv	s4,a1
    624c:	00060b93          	mv	s7,a2
  state = 0;
    6250:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
    6254:	00000493          	li	s1,0
    6258:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    625c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    6260:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    6264:	06c00c93          	li	s9,108
    6268:	02c0006f          	j	6294 <vprintf+0x8c>
        putc(fd, c0);
    626c:	00090593          	mv	a1,s2
    6270:	000b0513          	mv	a0,s6
    6274:	e79ff0ef          	jal	60ec <putc>
    6278:	0080006f          	j	6280 <vprintf+0x78>
    } else if(state == '%'){
    627c:	03598663          	beq	s3,s5,62a8 <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
    6280:	0014849b          	addiw	s1,s1,1
    6284:	00048713          	mv	a4,s1
    6288:	009a07b3          	add	a5,s4,s1
    628c:	0007c903          	lbu	s2,0(a5)
    6290:	2c090c63          	beqz	s2,6568 <vprintf+0x360>
    c0 = fmt[i] & 0xff;
    6294:	0009079b          	sext.w	a5,s2
    if(state == 0){
    6298:	fe0992e3          	bnez	s3,627c <vprintf+0x74>
      if(c0 == '%'){
    629c:	fd5798e3          	bne	a5,s5,626c <vprintf+0x64>
        state = '%';
    62a0:	00078993          	mv	s3,a5
    62a4:	fddff06f          	j	6280 <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
    62a8:	00ea06b3          	add	a3,s4,a4
    62ac:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    62b0:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    62b4:	00068663          	beqz	a3,62c0 <vprintf+0xb8>
    62b8:	00ea0733          	add	a4,s4,a4
    62bc:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    62c0:	05878263          	beq	a5,s8,6304 <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
    62c4:	07978263          	beq	a5,s9,6328 <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    62c8:	07500713          	li	a4,117
    62cc:	12e78663          	beq	a5,a4,63f8 <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    62d0:	07800713          	li	a4,120
    62d4:	18e78c63          	beq	a5,a4,646c <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    62d8:	07000713          	li	a4,112
    62dc:	1ce78e63          	beq	a5,a4,64b8 <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    62e0:	07300713          	li	a4,115
    62e4:	22e78a63          	beq	a5,a4,6518 <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    62e8:	02500713          	li	a4,37
    62ec:	04e79e63          	bne	a5,a4,6348 <vprintf+0x140>
        putc(fd, '%');
    62f0:	02500593          	li	a1,37
    62f4:	000b0513          	mv	a0,s6
    62f8:	df5ff0ef          	jal	60ec <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    62fc:	00000993          	li	s3,0
    6300:	f81ff06f          	j	6280 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
    6304:	008b8913          	addi	s2,s7,8
    6308:	00100693          	li	a3,1
    630c:	00a00613          	li	a2,10
    6310:	000ba583          	lw	a1,0(s7)
    6314:	000b0513          	mv	a0,s6
    6318:	e05ff0ef          	jal	611c <printint>
    631c:	00090b93          	mv	s7,s2
      state = 0;
    6320:	00000993          	li	s3,0
    6324:	f5dff06f          	j	6280 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
    6328:	06400793          	li	a5,100
    632c:	02f68e63          	beq	a3,a5,6368 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    6330:	06c00793          	li	a5,108
    6334:	04f68e63          	beq	a3,a5,6390 <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
    6338:	07500793          	li	a5,117
    633c:	0ef68063          	beq	a3,a5,641c <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
    6340:	07800793          	li	a5,120
    6344:	14f68663          	beq	a3,a5,6490 <vprintf+0x288>
        putc(fd, '%');
    6348:	02500593          	li	a1,37
    634c:	000b0513          	mv	a0,s6
    6350:	d9dff0ef          	jal	60ec <putc>
        putc(fd, c0);
    6354:	00090593          	mv	a1,s2
    6358:	000b0513          	mv	a0,s6
    635c:	d91ff0ef          	jal	60ec <putc>
      state = 0;
    6360:	00000993          	li	s3,0
    6364:	f1dff06f          	j	6280 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
    6368:	008b8913          	addi	s2,s7,8
    636c:	00100693          	li	a3,1
    6370:	00a00613          	li	a2,10
    6374:	000ba583          	lw	a1,0(s7)
    6378:	000b0513          	mv	a0,s6
    637c:	da1ff0ef          	jal	611c <printint>
        i += 1;
    6380:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    6384:	00090b93          	mv	s7,s2
      state = 0;
    6388:	00000993          	li	s3,0
        i += 1;
    638c:	ef5ff06f          	j	6280 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    6390:	06400793          	li	a5,100
    6394:	02f60e63          	beq	a2,a5,63d0 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    6398:	07500793          	li	a5,117
    639c:	0af60463          	beq	a2,a5,6444 <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    63a0:	07800793          	li	a5,120
    63a4:	faf612e3          	bne	a2,a5,6348 <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
    63a8:	008b8913          	addi	s2,s7,8
    63ac:	00000693          	li	a3,0
    63b0:	01000613          	li	a2,16
    63b4:	000ba583          	lw	a1,0(s7)
    63b8:	000b0513          	mv	a0,s6
    63bc:	d61ff0ef          	jal	611c <printint>
        i += 2;
    63c0:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    63c4:	00090b93          	mv	s7,s2
      state = 0;
    63c8:	00000993          	li	s3,0
        i += 2;
    63cc:	eb5ff06f          	j	6280 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
    63d0:	008b8913          	addi	s2,s7,8
    63d4:	00100693          	li	a3,1
    63d8:	00a00613          	li	a2,10
    63dc:	000ba583          	lw	a1,0(s7)
    63e0:	000b0513          	mv	a0,s6
    63e4:	d39ff0ef          	jal	611c <printint>
        i += 2;
    63e8:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    63ec:	00090b93          	mv	s7,s2
      state = 0;
    63f0:	00000993          	li	s3,0
        i += 2;
    63f4:	e8dff06f          	j	6280 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
    63f8:	008b8913          	addi	s2,s7,8
    63fc:	00000693          	li	a3,0
    6400:	00a00613          	li	a2,10
    6404:	000ba583          	lw	a1,0(s7)
    6408:	000b0513          	mv	a0,s6
    640c:	d11ff0ef          	jal	611c <printint>
    6410:	00090b93          	mv	s7,s2
      state = 0;
    6414:	00000993          	li	s3,0
    6418:	e69ff06f          	j	6280 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
    641c:	008b8913          	addi	s2,s7,8
    6420:	00000693          	li	a3,0
    6424:	00a00613          	li	a2,10
    6428:	000ba583          	lw	a1,0(s7)
    642c:	000b0513          	mv	a0,s6
    6430:	cedff0ef          	jal	611c <printint>
        i += 1;
    6434:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    6438:	00090b93          	mv	s7,s2
      state = 0;
    643c:	00000993          	li	s3,0
        i += 1;
    6440:	e41ff06f          	j	6280 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
    6444:	008b8913          	addi	s2,s7,8
    6448:	00000693          	li	a3,0
    644c:	00a00613          	li	a2,10
    6450:	000ba583          	lw	a1,0(s7)
    6454:	000b0513          	mv	a0,s6
    6458:	cc5ff0ef          	jal	611c <printint>
        i += 2;
    645c:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    6460:	00090b93          	mv	s7,s2
      state = 0;
    6464:	00000993          	li	s3,0
        i += 2;
    6468:	e19ff06f          	j	6280 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
    646c:	008b8913          	addi	s2,s7,8
    6470:	00000693          	li	a3,0
    6474:	01000613          	li	a2,16
    6478:	000ba583          	lw	a1,0(s7)
    647c:	000b0513          	mv	a0,s6
    6480:	c9dff0ef          	jal	611c <printint>
    6484:	00090b93          	mv	s7,s2
      state = 0;
    6488:	00000993          	li	s3,0
    648c:	df5ff06f          	j	6280 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
    6490:	008b8913          	addi	s2,s7,8
    6494:	00000693          	li	a3,0
    6498:	01000613          	li	a2,16
    649c:	000ba583          	lw	a1,0(s7)
    64a0:	000b0513          	mv	a0,s6
    64a4:	c79ff0ef          	jal	611c <printint>
        i += 1;
    64a8:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    64ac:	00090b93          	mv	s7,s2
      state = 0;
    64b0:	00000993          	li	s3,0
        i += 1;
    64b4:	dcdff06f          	j	6280 <vprintf+0x78>
    64b8:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    64bc:	008b8d13          	addi	s10,s7,8
    64c0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    64c4:	03000593          	li	a1,48
    64c8:	000b0513          	mv	a0,s6
    64cc:	c21ff0ef          	jal	60ec <putc>
  putc(fd, 'x');
    64d0:	07800593          	li	a1,120
    64d4:	000b0513          	mv	a0,s6
    64d8:	c15ff0ef          	jal	60ec <putc>
    64dc:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    64e0:	00002b97          	auipc	s7,0x2
    64e4:	780b8b93          	addi	s7,s7,1920 # 8c60 <digits>
    64e8:	03c9d793          	srli	a5,s3,0x3c
    64ec:	00fb87b3          	add	a5,s7,a5
    64f0:	0007c583          	lbu	a1,0(a5)
    64f4:	000b0513          	mv	a0,s6
    64f8:	bf5ff0ef          	jal	60ec <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    64fc:	00499993          	slli	s3,s3,0x4
    6500:	fff9091b          	addiw	s2,s2,-1
    6504:	fe0912e3          	bnez	s2,64e8 <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
    6508:	000d0b93          	mv	s7,s10
      state = 0;
    650c:	00000993          	li	s3,0
    6510:	00013d03          	ld	s10,0(sp)
    6514:	d6dff06f          	j	6280 <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
    6518:	008b8993          	addi	s3,s7,8
    651c:	000bb903          	ld	s2,0(s7)
    6520:	02090663          	beqz	s2,654c <vprintf+0x344>
        for(; *s; s++)
    6524:	00094583          	lbu	a1,0(s2)
    6528:	02058a63          	beqz	a1,655c <vprintf+0x354>
          putc(fd, *s);
    652c:	000b0513          	mv	a0,s6
    6530:	bbdff0ef          	jal	60ec <putc>
        for(; *s; s++)
    6534:	00190913          	addi	s2,s2,1
    6538:	00094583          	lbu	a1,0(s2)
    653c:	fe0598e3          	bnez	a1,652c <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
    6540:	00098b93          	mv	s7,s3
      state = 0;
    6544:	00000993          	li	s3,0
    6548:	d39ff06f          	j	6280 <vprintf+0x78>
          s = "(null)";
    654c:	00002917          	auipc	s2,0x2
    6550:	69490913          	addi	s2,s2,1684 # 8be0 <malloc+0x2500>
        for(; *s; s++)
    6554:	02800593          	li	a1,40
    6558:	fd5ff06f          	j	652c <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
    655c:	00098b93          	mv	s7,s3
      state = 0;
    6560:	00000993          	li	s3,0
    6564:	d1dff06f          	j	6280 <vprintf+0x78>
    6568:	04813483          	ld	s1,72(sp)
    656c:	03813983          	ld	s3,56(sp)
    6570:	03013a03          	ld	s4,48(sp)
    6574:	02813a83          	ld	s5,40(sp)
    6578:	02013b03          	ld	s6,32(sp)
    657c:	01813b83          	ld	s7,24(sp)
    6580:	01013c03          	ld	s8,16(sp)
    6584:	00813c83          	ld	s9,8(sp)
    }
  }
}
    6588:	05813083          	ld	ra,88(sp)
    658c:	05013403          	ld	s0,80(sp)
    6590:	04013903          	ld	s2,64(sp)
    6594:	06010113          	addi	sp,sp,96
    6598:	00008067          	ret

000000000000659c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    659c:	fb010113          	addi	sp,sp,-80
    65a0:	00113c23          	sd	ra,24(sp)
    65a4:	00813823          	sd	s0,16(sp)
    65a8:	02010413          	addi	s0,sp,32
    65ac:	00c43023          	sd	a2,0(s0)
    65b0:	00d43423          	sd	a3,8(s0)
    65b4:	00e43823          	sd	a4,16(s0)
    65b8:	00f43c23          	sd	a5,24(s0)
    65bc:	03043023          	sd	a6,32(s0)
    65c0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    65c4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    65c8:	00040613          	mv	a2,s0
    65cc:	c3dff0ef          	jal	6208 <vprintf>
}
    65d0:	01813083          	ld	ra,24(sp)
    65d4:	01013403          	ld	s0,16(sp)
    65d8:	05010113          	addi	sp,sp,80
    65dc:	00008067          	ret

00000000000065e0 <printf>:

void
printf(const char *fmt, ...)
{
    65e0:	fa010113          	addi	sp,sp,-96
    65e4:	00113c23          	sd	ra,24(sp)
    65e8:	00813823          	sd	s0,16(sp)
    65ec:	02010413          	addi	s0,sp,32
    65f0:	00b43423          	sd	a1,8(s0)
    65f4:	00c43823          	sd	a2,16(s0)
    65f8:	00d43c23          	sd	a3,24(s0)
    65fc:	02e43023          	sd	a4,32(s0)
    6600:	02f43423          	sd	a5,40(s0)
    6604:	03043823          	sd	a6,48(s0)
    6608:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    660c:	00840613          	addi	a2,s0,8
    6610:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    6614:	00050593          	mv	a1,a0
    6618:	00100513          	li	a0,1
    661c:	bedff0ef          	jal	6208 <vprintf>
}
    6620:	01813083          	ld	ra,24(sp)
    6624:	01013403          	ld	s0,16(sp)
    6628:	06010113          	addi	sp,sp,96
    662c:	00008067          	ret

0000000000006630 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    6630:	ff010113          	addi	sp,sp,-16
    6634:	00813423          	sd	s0,8(sp)
    6638:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    663c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6640:	00003797          	auipc	a5,0x3
    6644:	e107b783          	ld	a5,-496(a5) # 9450 <freep>
    6648:	0400006f          	j	6688 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    664c:	00862703          	lw	a4,8(a2)
    6650:	00b7073b          	addw	a4,a4,a1
    6654:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    6658:	0007b703          	ld	a4,0(a5)
    665c:	00073603          	ld	a2,0(a4)
    6660:	0500006f          	j	66b0 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    6664:	ff852703          	lw	a4,-8(a0)
    6668:	00c7073b          	addw	a4,a4,a2
    666c:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    6670:	ff053683          	ld	a3,-16(a0)
    6674:	0540006f          	j	66c8 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6678:	0007b703          	ld	a4,0(a5)
    667c:	00e7e463          	bltu	a5,a4,6684 <free+0x54>
    6680:	00e6ec63          	bltu	a3,a4,6698 <free+0x68>
{
    6684:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6688:	fed7f8e3          	bgeu	a5,a3,6678 <free+0x48>
    668c:	0007b703          	ld	a4,0(a5)
    6690:	00e6e463          	bltu	a3,a4,6698 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6694:	fee7e8e3          	bltu	a5,a4,6684 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
    6698:	ff852583          	lw	a1,-8(a0)
    669c:	0007b603          	ld	a2,0(a5)
    66a0:	02059813          	slli	a6,a1,0x20
    66a4:	01c85713          	srli	a4,a6,0x1c
    66a8:	00e68733          	add	a4,a3,a4
    66ac:	fae600e3          	beq	a2,a4,664c <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
    66b0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    66b4:	0087a603          	lw	a2,8(a5)
    66b8:	02061593          	slli	a1,a2,0x20
    66bc:	01c5d713          	srli	a4,a1,0x1c
    66c0:	00e78733          	add	a4,a5,a4
    66c4:	fae680e3          	beq	a3,a4,6664 <free+0x34>
    p->s.ptr = bp->s.ptr;
    66c8:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    66cc:	00003717          	auipc	a4,0x3
    66d0:	d8f73223          	sd	a5,-636(a4) # 9450 <freep>
}
    66d4:	00813403          	ld	s0,8(sp)
    66d8:	01010113          	addi	sp,sp,16
    66dc:	00008067          	ret

00000000000066e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    66e0:	fc010113          	addi	sp,sp,-64
    66e4:	02113c23          	sd	ra,56(sp)
    66e8:	02813823          	sd	s0,48(sp)
    66ec:	02913423          	sd	s1,40(sp)
    66f0:	01313c23          	sd	s3,24(sp)
    66f4:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    66f8:	02051493          	slli	s1,a0,0x20
    66fc:	0204d493          	srli	s1,s1,0x20
    6700:	00f48493          	addi	s1,s1,15
    6704:	0044d493          	srli	s1,s1,0x4
    6708:	0014899b          	addiw	s3,s1,1
    670c:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
    6710:	00003517          	auipc	a0,0x3
    6714:	d4053503          	ld	a0,-704(a0) # 9450 <freep>
    6718:	04050663          	beqz	a0,6764 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    671c:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6720:	0087a703          	lw	a4,8(a5)
    6724:	0c977c63          	bgeu	a4,s1,67fc <malloc+0x11c>
    6728:	03213023          	sd	s2,32(sp)
    672c:	01413823          	sd	s4,16(sp)
    6730:	01513423          	sd	s5,8(sp)
    6734:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
    6738:	00098a13          	mv	s4,s3
    673c:	0009871b          	sext.w	a4,s3
    6740:	000016b7          	lui	a3,0x1
    6744:	00d77463          	bgeu	a4,a3,674c <malloc+0x6c>
    6748:	00001a37          	lui	s4,0x1
    674c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    6750:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6754:	00003917          	auipc	s2,0x3
    6758:	cfc90913          	addi	s2,s2,-772 # 9450 <freep>
  if(p == (char*)-1)
    675c:	fff00a93          	li	s5,-1
    6760:	05c0006f          	j	67bc <malloc+0xdc>
    6764:	03213023          	sd	s2,32(sp)
    6768:	01413823          	sd	s4,16(sp)
    676c:	01513423          	sd	s5,8(sp)
    6770:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    6774:	00009797          	auipc	a5,0x9
    6778:	50478793          	addi	a5,a5,1284 # fc78 <base>
    677c:	00003717          	auipc	a4,0x3
    6780:	ccf73a23          	sd	a5,-812(a4) # 9450 <freep>
    6784:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
    6788:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    678c:	fadff06f          	j	6738 <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
    6790:	0007b703          	ld	a4,0(a5)
    6794:	00e53023          	sd	a4,0(a0)
    6798:	0800006f          	j	6818 <malloc+0x138>
  hp->s.size = nu;
    679c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    67a0:	01050513          	addi	a0,a0,16
    67a4:	e8dff0ef          	jal	6630 <free>
  return freep;
    67a8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    67ac:	08050863          	beqz	a0,683c <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    67b0:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
    67b4:	0087a703          	lw	a4,8(a5)
    67b8:	02977a63          	bgeu	a4,s1,67ec <malloc+0x10c>
    if(p == freep)
    67bc:	00093703          	ld	a4,0(s2)
    67c0:	00078513          	mv	a0,a5
    67c4:	fef716e3          	bne	a4,a5,67b0 <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
    67c8:	000a0513          	mv	a0,s4
    67cc:	8fdff0ef          	jal	60c8 <sbrk>
  if(p == (char*)-1)
    67d0:	fd5516e3          	bne	a0,s5,679c <malloc+0xbc>
        return 0;
    67d4:	00000513          	li	a0,0
    67d8:	02013903          	ld	s2,32(sp)
    67dc:	01013a03          	ld	s4,16(sp)
    67e0:	00813a83          	ld	s5,8(sp)
    67e4:	00013b03          	ld	s6,0(sp)
    67e8:	03c0006f          	j	6824 <malloc+0x144>
    67ec:	02013903          	ld	s2,32(sp)
    67f0:	01013a03          	ld	s4,16(sp)
    67f4:	00813a83          	ld	s5,8(sp)
    67f8:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
    67fc:	f8e48ae3          	beq	s1,a4,6790 <malloc+0xb0>
        p->s.size -= nunits;
    6800:	4137073b          	subw	a4,a4,s3
    6804:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
    6808:	02071693          	slli	a3,a4,0x20
    680c:	01c6d713          	srli	a4,a3,0x1c
    6810:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
    6814:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    6818:	00003717          	auipc	a4,0x3
    681c:	c2a73c23          	sd	a0,-968(a4) # 9450 <freep>
      return (void*)(p + 1);
    6820:	01078513          	addi	a0,a5,16
  }
}
    6824:	03813083          	ld	ra,56(sp)
    6828:	03013403          	ld	s0,48(sp)
    682c:	02813483          	ld	s1,40(sp)
    6830:	01813983          	ld	s3,24(sp)
    6834:	04010113          	addi	sp,sp,64
    6838:	00008067          	ret
    683c:	02013903          	ld	s2,32(sp)
    6840:	01013a03          	ld	s4,16(sp)
    6844:	00813a83          	ld	s5,8(sp)
    6848:	00013b03          	ld	s6,0(sp)
    684c:	fd9ff06f          	j	6824 <malloc+0x144>
