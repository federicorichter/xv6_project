
user/_grind:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	ff010113          	addi	sp,sp,-16
       4:	00813423          	sd	s0,8(sp)
       8:	01010413          	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       c:	00053783          	ld	a5,0(a0)
      10:	80000737          	lui	a4,0x80000
      14:	ffe74713          	xori	a4,a4,-2
      18:	02e7f7b3          	remu	a5,a5,a4
      1c:	00178793          	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      20:	0001f6b7          	lui	a3,0x1f
      24:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      28:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      2c:	00004637          	lui	a2,0x4
      30:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      34:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      38:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      3c:	fffff6b7          	lui	a3,0xfffff
      40:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      44:	02d787b3          	mul	a5,a5,a3
      48:	00f707b3          	add	a5,a4,a5
    if (x < 0)
      4c:	0007ce63          	bltz	a5,68 <do_rand+0x68>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      50:	fff78793          	addi	a5,a5,-1
    *ctx = x;
      54:	00f53023          	sd	a5,0(a0)
    return (x);
}
      58:	0007851b          	sext.w	a0,a5
      5c:	00813403          	ld	s0,8(sp)
      60:	01010113          	addi	sp,sp,16
      64:	00008067          	ret
        x += 0x7fffffff;
      68:	80000737          	lui	a4,0x80000
      6c:	fff74713          	not	a4,a4
      70:	00e787b3          	add	a5,a5,a4
      74:	fddff06f          	j	50 <do_rand+0x50>

0000000000000078 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      78:	ff010113          	addi	sp,sp,-16
      7c:	00113423          	sd	ra,8(sp)
      80:	00813023          	sd	s0,0(sp)
      84:	01010413          	addi	s0,sp,16
    return (do_rand(&rand_next));
      88:	00002517          	auipc	a0,0x2
      8c:	f7850513          	addi	a0,a0,-136 # 2000 <rand_next>
      90:	f71ff0ef          	jal	0 <do_rand>
}
      94:	00813083          	ld	ra,8(sp)
      98:	00013403          	ld	s0,0(sp)
      9c:	01010113          	addi	sp,sp,16
      a0:	00008067          	ret

00000000000000a4 <go>:

void
go(int which_child)
{
      a4:	f8010113          	addi	sp,sp,-128
      a8:	06113c23          	sd	ra,120(sp)
      ac:	06813823          	sd	s0,112(sp)
      b0:	06913423          	sd	s1,104(sp)
      b4:	05513423          	sd	s5,72(sp)
      b8:	08010413          	addi	s0,sp,128
      bc:	00050493          	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      c0:	00000513          	li	a0,0
      c4:	66d000ef          	jal	f30 <sbrk>
      c8:	00050a93          	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      cc:	00001517          	auipc	a0,0x1
      d0:	5f450513          	addi	a0,a0,1524 # 16c0 <malloc+0x178>
      d4:	62d000ef          	jal	f00 <mkdir>
  if(chdir("grindir") != 0){
      d8:	00001517          	auipc	a0,0x1
      dc:	5e850513          	addi	a0,a0,1512 # 16c0 <malloc+0x178>
      e0:	62d000ef          	jal	f0c <chdir>
      e4:	02050663          	beqz	a0,110 <go+0x6c>
      e8:	07213023          	sd	s2,96(sp)
      ec:	05313c23          	sd	s3,88(sp)
      f0:	05413823          	sd	s4,80(sp)
      f4:	05613023          	sd	s6,64(sp)
      f8:	03713c23          	sd	s7,56(sp)
    printf("grind: chdir grindir failed\n");
      fc:	00001517          	auipc	a0,0x1
     100:	5cc50513          	addi	a0,a0,1484 # 16c8 <malloc+0x180>
     104:	344010ef          	jal	1448 <printf>
    exit(1);
     108:	00100513          	li	a0,1
     10c:	559000ef          	jal	e64 <exit>
     110:	07213023          	sd	s2,96(sp)
     114:	05313c23          	sd	s3,88(sp)
     118:	05413823          	sd	s4,80(sp)
     11c:	05613023          	sd	s6,64(sp)
     120:	03713c23          	sd	s7,56(sp)
  }
  chdir("/");
     124:	00001517          	auipc	a0,0x1
     128:	5cc50513          	addi	a0,a0,1484 # 16f0 <malloc+0x1a8>
     12c:	5e1000ef          	jal	f0c <chdir>
     130:	00001997          	auipc	s3,0x1
     134:	5d098993          	addi	s3,s3,1488 # 1700 <malloc+0x1b8>
     138:	00048663          	beqz	s1,144 <go+0xa0>
     13c:	00001997          	auipc	s3,0x1
     140:	5bc98993          	addi	s3,s3,1468 # 16f8 <malloc+0x1b0>
  uint64 iters = 0;
     144:	00000493          	li	s1,0
  int fd = -1;
     148:	fff00a13          	li	s4,-1
     14c:	00002917          	auipc	s2,0x2
     150:	88490913          	addi	s2,s2,-1916 # 19d0 <malloc+0x488>
     154:	0180006f          	j	16c <go+0xc8>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
     158:	20200593          	li	a1,514
     15c:	00001517          	auipc	a0,0x1
     160:	5ac50513          	addi	a0,a0,1452 # 1708 <malloc+0x1c0>
     164:	561000ef          	jal	ec4 <open>
     168:	539000ef          	jal	ea0 <close>
    iters++;
     16c:	00148493          	addi	s1,s1,1
    if((iters % 500) == 0)
     170:	1f400793          	li	a5,500
     174:	02f4f7b3          	remu	a5,s1,a5
     178:	00079a63          	bnez	a5,18c <go+0xe8>
      write(1, which_child?"B":"A", 1);
     17c:	00100613          	li	a2,1
     180:	00098593          	mv	a1,s3
     184:	00100513          	li	a0,1
     188:	50d000ef          	jal	e94 <write>
    int what = rand() % 23;
     18c:	eedff0ef          	jal	78 <rand>
     190:	01700793          	li	a5,23
     194:	02f5653b          	remw	a0,a0,a5
     198:	0005071b          	sext.w	a4,a0
     19c:	01600793          	li	a5,22
     1a0:	fce7e6e3          	bltu	a5,a4,16c <go+0xc8>
     1a4:	02051793          	slli	a5,a0,0x20
     1a8:	01e7d513          	srli	a0,a5,0x1e
     1ac:	01250533          	add	a0,a0,s2
     1b0:	00052783          	lw	a5,0(a0)
     1b4:	012787b3          	add	a5,a5,s2
     1b8:	00078067          	jr	a5
    } else if(what == 2){
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     1bc:	20200593          	li	a1,514
     1c0:	00001517          	auipc	a0,0x1
     1c4:	55850513          	addi	a0,a0,1368 # 1718 <malloc+0x1d0>
     1c8:	4fd000ef          	jal	ec4 <open>
     1cc:	4d5000ef          	jal	ea0 <close>
     1d0:	f9dff06f          	j	16c <go+0xc8>
    } else if(what == 3){
      unlink("grindir/../a");
     1d4:	00001517          	auipc	a0,0x1
     1d8:	53450513          	addi	a0,a0,1332 # 1708 <malloc+0x1c0>
     1dc:	501000ef          	jal	edc <unlink>
     1e0:	f8dff06f          	j	16c <go+0xc8>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     1e4:	00001517          	auipc	a0,0x1
     1e8:	4dc50513          	addi	a0,a0,1244 # 16c0 <malloc+0x178>
     1ec:	521000ef          	jal	f0c <chdir>
     1f0:	02051063          	bnez	a0,210 <go+0x16c>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     1f4:	00001517          	auipc	a0,0x1
     1f8:	53c50513          	addi	a0,a0,1340 # 1730 <malloc+0x1e8>
     1fc:	4e1000ef          	jal	edc <unlink>
      chdir("/");
     200:	00001517          	auipc	a0,0x1
     204:	4f050513          	addi	a0,a0,1264 # 16f0 <malloc+0x1a8>
     208:	505000ef          	jal	f0c <chdir>
     20c:	f61ff06f          	j	16c <go+0xc8>
        printf("grind: chdir grindir failed\n");
     210:	00001517          	auipc	a0,0x1
     214:	4b850513          	addi	a0,a0,1208 # 16c8 <malloc+0x180>
     218:	230010ef          	jal	1448 <printf>
        exit(1);
     21c:	00100513          	li	a0,1
     220:	445000ef          	jal	e64 <exit>
    } else if(what == 5){
      close(fd);
     224:	000a0513          	mv	a0,s4
     228:	479000ef          	jal	ea0 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     22c:	20200593          	li	a1,514
     230:	00001517          	auipc	a0,0x1
     234:	50850513          	addi	a0,a0,1288 # 1738 <malloc+0x1f0>
     238:	48d000ef          	jal	ec4 <open>
     23c:	00050a13          	mv	s4,a0
     240:	f2dff06f          	j	16c <go+0xc8>
    } else if(what == 6){
      close(fd);
     244:	000a0513          	mv	a0,s4
     248:	459000ef          	jal	ea0 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     24c:	20200593          	li	a1,514
     250:	00001517          	auipc	a0,0x1
     254:	4f850513          	addi	a0,a0,1272 # 1748 <malloc+0x200>
     258:	46d000ef          	jal	ec4 <open>
     25c:	00050a13          	mv	s4,a0
     260:	f0dff06f          	j	16c <go+0xc8>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     264:	3e700613          	li	a2,999
     268:	00002597          	auipc	a1,0x2
     26c:	db858593          	addi	a1,a1,-584 # 2020 <buf.0>
     270:	000a0513          	mv	a0,s4
     274:	421000ef          	jal	e94 <write>
     278:	ef5ff06f          	j	16c <go+0xc8>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     27c:	3e700613          	li	a2,999
     280:	00002597          	auipc	a1,0x2
     284:	da058593          	addi	a1,a1,-608 # 2020 <buf.0>
     288:	000a0513          	mv	a0,s4
     28c:	3fd000ef          	jal	e88 <read>
     290:	eddff06f          	j	16c <go+0xc8>
    } else if(what == 9){
      mkdir("grindir/../a");
     294:	00001517          	auipc	a0,0x1
     298:	47450513          	addi	a0,a0,1140 # 1708 <malloc+0x1c0>
     29c:	465000ef          	jal	f00 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     2a0:	20200593          	li	a1,514
     2a4:	00001517          	auipc	a0,0x1
     2a8:	4bc50513          	addi	a0,a0,1212 # 1760 <malloc+0x218>
     2ac:	419000ef          	jal	ec4 <open>
     2b0:	3f1000ef          	jal	ea0 <close>
      unlink("a/a");
     2b4:	00001517          	auipc	a0,0x1
     2b8:	4bc50513          	addi	a0,a0,1212 # 1770 <malloc+0x228>
     2bc:	421000ef          	jal	edc <unlink>
     2c0:	eadff06f          	j	16c <go+0xc8>
    } else if(what == 10){
      mkdir("/../b");
     2c4:	00001517          	auipc	a0,0x1
     2c8:	4b450513          	addi	a0,a0,1204 # 1778 <malloc+0x230>
     2cc:	435000ef          	jal	f00 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2d0:	20200593          	li	a1,514
     2d4:	00001517          	auipc	a0,0x1
     2d8:	4ac50513          	addi	a0,a0,1196 # 1780 <malloc+0x238>
     2dc:	3e9000ef          	jal	ec4 <open>
     2e0:	3c1000ef          	jal	ea0 <close>
      unlink("b/b");
     2e4:	00001517          	auipc	a0,0x1
     2e8:	4ac50513          	addi	a0,a0,1196 # 1790 <malloc+0x248>
     2ec:	3f1000ef          	jal	edc <unlink>
     2f0:	e7dff06f          	j	16c <go+0xc8>
    } else if(what == 11){
      unlink("b");
     2f4:	00001517          	auipc	a0,0x1
     2f8:	4a450513          	addi	a0,a0,1188 # 1798 <malloc+0x250>
     2fc:	3e1000ef          	jal	edc <unlink>
      link("../grindir/./../a", "../b");
     300:	00001597          	auipc	a1,0x1
     304:	43058593          	addi	a1,a1,1072 # 1730 <malloc+0x1e8>
     308:	00001517          	auipc	a0,0x1
     30c:	49850513          	addi	a0,a0,1176 # 17a0 <malloc+0x258>
     310:	3e5000ef          	jal	ef4 <link>
     314:	e59ff06f          	j	16c <go+0xc8>
    } else if(what == 12){
      unlink("../grindir/../a");
     318:	00001517          	auipc	a0,0x1
     31c:	4a050513          	addi	a0,a0,1184 # 17b8 <malloc+0x270>
     320:	3bd000ef          	jal	edc <unlink>
      link(".././b", "/grindir/../a");
     324:	00001597          	auipc	a1,0x1
     328:	41458593          	addi	a1,a1,1044 # 1738 <malloc+0x1f0>
     32c:	00001517          	auipc	a0,0x1
     330:	49c50513          	addi	a0,a0,1180 # 17c8 <malloc+0x280>
     334:	3c1000ef          	jal	ef4 <link>
     338:	e35ff06f          	j	16c <go+0xc8>
    } else if(what == 13){
      int pid = fork();
     33c:	31d000ef          	jal	e58 <fork>
      if(pid == 0){
     340:	00050a63          	beqz	a0,354 <go+0x2b0>
        exit(0);
      } else if(pid < 0){
     344:	00054a63          	bltz	a0,358 <go+0x2b4>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     348:	00000513          	li	a0,0
     34c:	325000ef          	jal	e70 <wait>
     350:	e1dff06f          	j	16c <go+0xc8>
        exit(0);
     354:	311000ef          	jal	e64 <exit>
        printf("grind: fork failed\n");
     358:	00001517          	auipc	a0,0x1
     35c:	47850513          	addi	a0,a0,1144 # 17d0 <malloc+0x288>
     360:	0e8010ef          	jal	1448 <printf>
        exit(1);
     364:	00100513          	li	a0,1
     368:	2fd000ef          	jal	e64 <exit>
    } else if(what == 14){
      int pid = fork();
     36c:	2ed000ef          	jal	e58 <fork>
      if(pid == 0){
     370:	00050a63          	beqz	a0,384 <go+0x2e0>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     374:	02054063          	bltz	a0,394 <go+0x2f0>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     378:	00000513          	li	a0,0
     37c:	2f5000ef          	jal	e70 <wait>
     380:	dedff06f          	j	16c <go+0xc8>
        fork();
     384:	2d5000ef          	jal	e58 <fork>
        fork();
     388:	2d1000ef          	jal	e58 <fork>
        exit(0);
     38c:	00000513          	li	a0,0
     390:	2d5000ef          	jal	e64 <exit>
        printf("grind: fork failed\n");
     394:	00001517          	auipc	a0,0x1
     398:	43c50513          	addi	a0,a0,1084 # 17d0 <malloc+0x288>
     39c:	0ac010ef          	jal	1448 <printf>
        exit(1);
     3a0:	00100513          	li	a0,1
     3a4:	2c1000ef          	jal	e64 <exit>
    } else if(what == 15){
      sbrk(6011);
     3a8:	00001537          	lui	a0,0x1
     3ac:	77b50513          	addi	a0,a0,1915 # 177b <malloc+0x233>
     3b0:	381000ef          	jal	f30 <sbrk>
     3b4:	db9ff06f          	j	16c <go+0xc8>
    } else if(what == 16){
      if(sbrk(0) > break0)
     3b8:	00000513          	li	a0,0
     3bc:	375000ef          	jal	f30 <sbrk>
     3c0:	daaaf6e3          	bgeu	s5,a0,16c <go+0xc8>
        sbrk(-(sbrk(0) - break0));
     3c4:	00000513          	li	a0,0
     3c8:	369000ef          	jal	f30 <sbrk>
     3cc:	40aa853b          	subw	a0,s5,a0
     3d0:	361000ef          	jal	f30 <sbrk>
     3d4:	d99ff06f          	j	16c <go+0xc8>
    } else if(what == 17){
      int pid = fork();
     3d8:	281000ef          	jal	e58 <fork>
     3dc:	00050b13          	mv	s6,a0
      if(pid == 0){
     3e0:	02050663          	beqz	a0,40c <go+0x368>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     3e4:	04054263          	bltz	a0,428 <go+0x384>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     3e8:	00001517          	auipc	a0,0x1
     3ec:	40850513          	addi	a0,a0,1032 # 17f0 <malloc+0x2a8>
     3f0:	31d000ef          	jal	f0c <chdir>
     3f4:	04051463          	bnez	a0,43c <go+0x398>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     3f8:	000b0513          	mv	a0,s6
     3fc:	2b1000ef          	jal	eac <kill>
      wait(0);
     400:	00000513          	li	a0,0
     404:	26d000ef          	jal	e70 <wait>
     408:	d65ff06f          	j	16c <go+0xc8>
        close(open("a", O_CREATE|O_RDWR));
     40c:	20200593          	li	a1,514
     410:	00001517          	auipc	a0,0x1
     414:	3d850513          	addi	a0,a0,984 # 17e8 <malloc+0x2a0>
     418:	2ad000ef          	jal	ec4 <open>
     41c:	285000ef          	jal	ea0 <close>
        exit(0);
     420:	00000513          	li	a0,0
     424:	241000ef          	jal	e64 <exit>
        printf("grind: fork failed\n");
     428:	00001517          	auipc	a0,0x1
     42c:	3a850513          	addi	a0,a0,936 # 17d0 <malloc+0x288>
     430:	018010ef          	jal	1448 <printf>
        exit(1);
     434:	00100513          	li	a0,1
     438:	22d000ef          	jal	e64 <exit>
        printf("grind: chdir failed\n");
     43c:	00001517          	auipc	a0,0x1
     440:	3c450513          	addi	a0,a0,964 # 1800 <malloc+0x2b8>
     444:	004010ef          	jal	1448 <printf>
        exit(1);
     448:	00100513          	li	a0,1
     44c:	219000ef          	jal	e64 <exit>
    } else if(what == 18){
      int pid = fork();
     450:	209000ef          	jal	e58 <fork>
      if(pid == 0){
     454:	00050a63          	beqz	a0,468 <go+0x3c4>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     458:	02054063          	bltz	a0,478 <go+0x3d4>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     45c:	00000513          	li	a0,0
     460:	211000ef          	jal	e70 <wait>
     464:	d09ff06f          	j	16c <go+0xc8>
        kill(getpid());
     468:	2bd000ef          	jal	f24 <getpid>
     46c:	241000ef          	jal	eac <kill>
        exit(0);
     470:	00000513          	li	a0,0
     474:	1f1000ef          	jal	e64 <exit>
        printf("grind: fork failed\n");
     478:	00001517          	auipc	a0,0x1
     47c:	35850513          	addi	a0,a0,856 # 17d0 <malloc+0x288>
     480:	7c9000ef          	jal	1448 <printf>
        exit(1);
     484:	00100513          	li	a0,1
     488:	1dd000ef          	jal	e64 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     48c:	f9840513          	addi	a0,s0,-104
     490:	1ed000ef          	jal	e7c <pipe>
     494:	02054663          	bltz	a0,4c0 <go+0x41c>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     498:	1c1000ef          	jal	e58 <fork>
      if(pid == 0){
     49c:	02050c63          	beqz	a0,4d4 <go+0x430>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     4a0:	08054c63          	bltz	a0,538 <go+0x494>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     4a4:	f9842503          	lw	a0,-104(s0)
     4a8:	1f9000ef          	jal	ea0 <close>
      close(fds[1]);
     4ac:	f9c42503          	lw	a0,-100(s0)
     4b0:	1f1000ef          	jal	ea0 <close>
      wait(0);
     4b4:	00000513          	li	a0,0
     4b8:	1b9000ef          	jal	e70 <wait>
     4bc:	cb1ff06f          	j	16c <go+0xc8>
        printf("grind: pipe failed\n");
     4c0:	00001517          	auipc	a0,0x1
     4c4:	35850513          	addi	a0,a0,856 # 1818 <malloc+0x2d0>
     4c8:	781000ef          	jal	1448 <printf>
        exit(1);
     4cc:	00100513          	li	a0,1
     4d0:	195000ef          	jal	e64 <exit>
        fork();
     4d4:	185000ef          	jal	e58 <fork>
        fork();
     4d8:	181000ef          	jal	e58 <fork>
        if(write(fds[1], "x", 1) != 1)
     4dc:	00100613          	li	a2,1
     4e0:	00001597          	auipc	a1,0x1
     4e4:	35058593          	addi	a1,a1,848 # 1830 <malloc+0x2e8>
     4e8:	f9c42503          	lw	a0,-100(s0)
     4ec:	1a9000ef          	jal	e94 <write>
     4f0:	00100793          	li	a5,1
     4f4:	02f51263          	bne	a0,a5,518 <go+0x474>
        if(read(fds[0], &c, 1) != 1)
     4f8:	00100613          	li	a2,1
     4fc:	f9040593          	addi	a1,s0,-112
     500:	f9842503          	lw	a0,-104(s0)
     504:	185000ef          	jal	e88 <read>
     508:	00100793          	li	a5,1
     50c:	00f51e63          	bne	a0,a5,528 <go+0x484>
        exit(0);
     510:	00000513          	li	a0,0
     514:	151000ef          	jal	e64 <exit>
          printf("grind: pipe write failed\n");
     518:	00001517          	auipc	a0,0x1
     51c:	32050513          	addi	a0,a0,800 # 1838 <malloc+0x2f0>
     520:	729000ef          	jal	1448 <printf>
     524:	fd5ff06f          	j	4f8 <go+0x454>
          printf("grind: pipe read failed\n");
     528:	00001517          	auipc	a0,0x1
     52c:	33050513          	addi	a0,a0,816 # 1858 <malloc+0x310>
     530:	719000ef          	jal	1448 <printf>
     534:	fddff06f          	j	510 <go+0x46c>
        printf("grind: fork failed\n");
     538:	00001517          	auipc	a0,0x1
     53c:	29850513          	addi	a0,a0,664 # 17d0 <malloc+0x288>
     540:	709000ef          	jal	1448 <printf>
        exit(1);
     544:	00100513          	li	a0,1
     548:	11d000ef          	jal	e64 <exit>
    } else if(what == 20){
      int pid = fork();
     54c:	10d000ef          	jal	e58 <fork>
      if(pid == 0){
     550:	00050a63          	beqz	a0,564 <go+0x4c0>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     554:	06054263          	bltz	a0,5b8 <go+0x514>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     558:	00000513          	li	a0,0
     55c:	115000ef          	jal	e70 <wait>
     560:	c0dff06f          	j	16c <go+0xc8>
        unlink("a");
     564:	00001517          	auipc	a0,0x1
     568:	28450513          	addi	a0,a0,644 # 17e8 <malloc+0x2a0>
     56c:	171000ef          	jal	edc <unlink>
        mkdir("a");
     570:	00001517          	auipc	a0,0x1
     574:	27850513          	addi	a0,a0,632 # 17e8 <malloc+0x2a0>
     578:	189000ef          	jal	f00 <mkdir>
        chdir("a");
     57c:	00001517          	auipc	a0,0x1
     580:	26c50513          	addi	a0,a0,620 # 17e8 <malloc+0x2a0>
     584:	189000ef          	jal	f0c <chdir>
        unlink("../a");
     588:	00001517          	auipc	a0,0x1
     58c:	2f050513          	addi	a0,a0,752 # 1878 <malloc+0x330>
     590:	14d000ef          	jal	edc <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     594:	20200593          	li	a1,514
     598:	00001517          	auipc	a0,0x1
     59c:	29850513          	addi	a0,a0,664 # 1830 <malloc+0x2e8>
     5a0:	125000ef          	jal	ec4 <open>
        unlink("x");
     5a4:	00001517          	auipc	a0,0x1
     5a8:	28c50513          	addi	a0,a0,652 # 1830 <malloc+0x2e8>
     5ac:	131000ef          	jal	edc <unlink>
        exit(0);
     5b0:	00000513          	li	a0,0
     5b4:	0b1000ef          	jal	e64 <exit>
        printf("grind: fork failed\n");
     5b8:	00001517          	auipc	a0,0x1
     5bc:	21850513          	addi	a0,a0,536 # 17d0 <malloc+0x288>
     5c0:	689000ef          	jal	1448 <printf>
        exit(1);
     5c4:	00100513          	li	a0,1
     5c8:	09d000ef          	jal	e64 <exit>
    } else if(what == 21){
      unlink("c");
     5cc:	00001517          	auipc	a0,0x1
     5d0:	2b450513          	addi	a0,a0,692 # 1880 <malloc+0x338>
     5d4:	109000ef          	jal	edc <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     5d8:	20200593          	li	a1,514
     5dc:	00001517          	auipc	a0,0x1
     5e0:	2a450513          	addi	a0,a0,676 # 1880 <malloc+0x338>
     5e4:	0e1000ef          	jal	ec4 <open>
     5e8:	00050b13          	mv	s6,a0
      if(fd1 < 0){
     5ec:	04054e63          	bltz	a0,648 <go+0x5a4>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     5f0:	00100613          	li	a2,1
     5f4:	00001597          	auipc	a1,0x1
     5f8:	23c58593          	addi	a1,a1,572 # 1830 <malloc+0x2e8>
     5fc:	099000ef          	jal	e94 <write>
     600:	00100793          	li	a5,1
     604:	04f51c63          	bne	a0,a5,65c <go+0x5b8>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     608:	f9840593          	addi	a1,s0,-104
     60c:	000b0513          	mv	a0,s6
     610:	0d9000ef          	jal	ee8 <fstat>
     614:	04051e63          	bnez	a0,670 <go+0x5cc>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     618:	fa843583          	ld	a1,-88(s0)
     61c:	00100793          	li	a5,1
     620:	06f59263          	bne	a1,a5,684 <go+0x5e0>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     624:	f9c42583          	lw	a1,-100(s0)
     628:	0c800793          	li	a5,200
     62c:	06b7e863          	bltu	a5,a1,69c <go+0x5f8>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     630:	000b0513          	mv	a0,s6
     634:	06d000ef          	jal	ea0 <close>
      unlink("c");
     638:	00001517          	auipc	a0,0x1
     63c:	24850513          	addi	a0,a0,584 # 1880 <malloc+0x338>
     640:	09d000ef          	jal	edc <unlink>
     644:	b29ff06f          	j	16c <go+0xc8>
        printf("grind: create c failed\n");
     648:	00001517          	auipc	a0,0x1
     64c:	24050513          	addi	a0,a0,576 # 1888 <malloc+0x340>
     650:	5f9000ef          	jal	1448 <printf>
        exit(1);
     654:	00100513          	li	a0,1
     658:	00d000ef          	jal	e64 <exit>
        printf("grind: write c failed\n");
     65c:	00001517          	auipc	a0,0x1
     660:	24450513          	addi	a0,a0,580 # 18a0 <malloc+0x358>
     664:	5e5000ef          	jal	1448 <printf>
        exit(1);
     668:	00100513          	li	a0,1
     66c:	7f8000ef          	jal	e64 <exit>
        printf("grind: fstat failed\n");
     670:	00001517          	auipc	a0,0x1
     674:	24850513          	addi	a0,a0,584 # 18b8 <malloc+0x370>
     678:	5d1000ef          	jal	1448 <printf>
        exit(1);
     67c:	00100513          	li	a0,1
     680:	7e4000ef          	jal	e64 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     684:	0005859b          	sext.w	a1,a1
     688:	00001517          	auipc	a0,0x1
     68c:	24850513          	addi	a0,a0,584 # 18d0 <malloc+0x388>
     690:	5b9000ef          	jal	1448 <printf>
        exit(1);
     694:	00100513          	li	a0,1
     698:	7cc000ef          	jal	e64 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     69c:	00001517          	auipc	a0,0x1
     6a0:	25c50513          	addi	a0,a0,604 # 18f8 <malloc+0x3b0>
     6a4:	5a5000ef          	jal	1448 <printf>
        exit(1);
     6a8:	00100513          	li	a0,1
     6ac:	7b8000ef          	jal	e64 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     6b0:	f8840513          	addi	a0,s0,-120
     6b4:	7c8000ef          	jal	e7c <pipe>
     6b8:	0a054a63          	bltz	a0,76c <go+0x6c8>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     6bc:	f9040513          	addi	a0,s0,-112
     6c0:	7bc000ef          	jal	e7c <pipe>
     6c4:	0c054063          	bltz	a0,784 <go+0x6e0>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     6c8:	790000ef          	jal	e58 <fork>
      if(pid1 == 0){
     6cc:	0c050863          	beqz	a0,79c <go+0x6f8>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     6d0:	16054063          	bltz	a0,830 <go+0x78c>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     6d4:	784000ef          	jal	e58 <fork>
      if(pid2 == 0){
     6d8:	16050863          	beqz	a0,848 <go+0x7a4>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     6dc:	22054063          	bltz	a0,8fc <go+0x858>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     6e0:	f8842503          	lw	a0,-120(s0)
     6e4:	7bc000ef          	jal	ea0 <close>
      close(aa[1]);
     6e8:	f8c42503          	lw	a0,-116(s0)
     6ec:	7b4000ef          	jal	ea0 <close>
      close(bb[1]);
     6f0:	f9442503          	lw	a0,-108(s0)
     6f4:	7ac000ef          	jal	ea0 <close>
      char buf[4] = { 0, 0, 0, 0 };
     6f8:	f8042023          	sw	zero,-128(s0)
      read(bb[0], buf+0, 1);
     6fc:	00100613          	li	a2,1
     700:	f8040593          	addi	a1,s0,-128
     704:	f9042503          	lw	a0,-112(s0)
     708:	780000ef          	jal	e88 <read>
      read(bb[0], buf+1, 1);
     70c:	00100613          	li	a2,1
     710:	f8140593          	addi	a1,s0,-127
     714:	f9042503          	lw	a0,-112(s0)
     718:	770000ef          	jal	e88 <read>
      read(bb[0], buf+2, 1);
     71c:	00100613          	li	a2,1
     720:	f8240593          	addi	a1,s0,-126
     724:	f9042503          	lw	a0,-112(s0)
     728:	760000ef          	jal	e88 <read>
      close(bb[0]);
     72c:	f9042503          	lw	a0,-112(s0)
     730:	770000ef          	jal	ea0 <close>
      int st1, st2;
      wait(&st1);
     734:	f8440513          	addi	a0,s0,-124
     738:	738000ef          	jal	e70 <wait>
      wait(&st2);
     73c:	f9840513          	addi	a0,s0,-104
     740:	730000ef          	jal	e70 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     744:	f8442783          	lw	a5,-124(s0)
     748:	f9842b83          	lw	s7,-104(s0)
     74c:	0177eb33          	or	s6,a5,s7
     750:	1c0b1263          	bnez	s6,914 <go+0x870>
     754:	00001597          	auipc	a1,0x1
     758:	24458593          	addi	a1,a1,580 # 1998 <malloc+0x450>
     75c:	f8040513          	addi	a0,s0,-128
     760:	37c000ef          	jal	adc <strcmp>
     764:	a00504e3          	beqz	a0,16c <go+0xc8>
     768:	1b00006f          	j	918 <go+0x874>
        fprintf(2, "grind: pipe failed\n");
     76c:	00001597          	auipc	a1,0x1
     770:	0ac58593          	addi	a1,a1,172 # 1818 <malloc+0x2d0>
     774:	00200513          	li	a0,2
     778:	48d000ef          	jal	1404 <fprintf>
        exit(1);
     77c:	00100513          	li	a0,1
     780:	6e4000ef          	jal	e64 <exit>
        fprintf(2, "grind: pipe failed\n");
     784:	00001597          	auipc	a1,0x1
     788:	09458593          	addi	a1,a1,148 # 1818 <malloc+0x2d0>
     78c:	00200513          	li	a0,2
     790:	475000ef          	jal	1404 <fprintf>
        exit(1);
     794:	00100513          	li	a0,1
     798:	6cc000ef          	jal	e64 <exit>
        close(bb[0]);
     79c:	f9042503          	lw	a0,-112(s0)
     7a0:	700000ef          	jal	ea0 <close>
        close(bb[1]);
     7a4:	f9442503          	lw	a0,-108(s0)
     7a8:	6f8000ef          	jal	ea0 <close>
        close(aa[0]);
     7ac:	f8842503          	lw	a0,-120(s0)
     7b0:	6f0000ef          	jal	ea0 <close>
        close(1);
     7b4:	00100513          	li	a0,1
     7b8:	6e8000ef          	jal	ea0 <close>
        if(dup(aa[1]) != 1){
     7bc:	f8c42503          	lw	a0,-116(s0)
     7c0:	758000ef          	jal	f18 <dup>
     7c4:	00100793          	li	a5,1
     7c8:	00f50e63          	beq	a0,a5,7e4 <go+0x740>
          fprintf(2, "grind: dup failed\n");
     7cc:	00001597          	auipc	a1,0x1
     7d0:	15458593          	addi	a1,a1,340 # 1920 <malloc+0x3d8>
     7d4:	00200513          	li	a0,2
     7d8:	42d000ef          	jal	1404 <fprintf>
          exit(1);
     7dc:	00100513          	li	a0,1
     7e0:	684000ef          	jal	e64 <exit>
        close(aa[1]);
     7e4:	f8c42503          	lw	a0,-116(s0)
     7e8:	6b8000ef          	jal	ea0 <close>
        char *args[3] = { "echo", "hi", 0 };
     7ec:	00001797          	auipc	a5,0x1
     7f0:	14c78793          	addi	a5,a5,332 # 1938 <malloc+0x3f0>
     7f4:	f8f43c23          	sd	a5,-104(s0)
     7f8:	00001797          	auipc	a5,0x1
     7fc:	14878793          	addi	a5,a5,328 # 1940 <malloc+0x3f8>
     800:	faf43023          	sd	a5,-96(s0)
     804:	fa043423          	sd	zero,-88(s0)
        exec("grindir/../echo", args);
     808:	f9840593          	addi	a1,s0,-104
     80c:	00001517          	auipc	a0,0x1
     810:	13c50513          	addi	a0,a0,316 # 1948 <malloc+0x400>
     814:	6a4000ef          	jal	eb8 <exec>
        fprintf(2, "grind: echo: not found\n");
     818:	00001597          	auipc	a1,0x1
     81c:	14058593          	addi	a1,a1,320 # 1958 <malloc+0x410>
     820:	00200513          	li	a0,2
     824:	3e1000ef          	jal	1404 <fprintf>
        exit(2);
     828:	00200513          	li	a0,2
     82c:	638000ef          	jal	e64 <exit>
        fprintf(2, "grind: fork failed\n");
     830:	00001597          	auipc	a1,0x1
     834:	fa058593          	addi	a1,a1,-96 # 17d0 <malloc+0x288>
     838:	00200513          	li	a0,2
     83c:	3c9000ef          	jal	1404 <fprintf>
        exit(3);
     840:	00300513          	li	a0,3
     844:	620000ef          	jal	e64 <exit>
        close(aa[1]);
     848:	f8c42503          	lw	a0,-116(s0)
     84c:	654000ef          	jal	ea0 <close>
        close(bb[0]);
     850:	f9042503          	lw	a0,-112(s0)
     854:	64c000ef          	jal	ea0 <close>
        close(0);
     858:	00000513          	li	a0,0
     85c:	644000ef          	jal	ea0 <close>
        if(dup(aa[0]) != 0){
     860:	f8842503          	lw	a0,-120(s0)
     864:	6b4000ef          	jal	f18 <dup>
     868:	00050e63          	beqz	a0,884 <go+0x7e0>
          fprintf(2, "grind: dup failed\n");
     86c:	00001597          	auipc	a1,0x1
     870:	0b458593          	addi	a1,a1,180 # 1920 <malloc+0x3d8>
     874:	00200513          	li	a0,2
     878:	38d000ef          	jal	1404 <fprintf>
          exit(4);
     87c:	00400513          	li	a0,4
     880:	5e4000ef          	jal	e64 <exit>
        close(aa[0]);
     884:	f8842503          	lw	a0,-120(s0)
     888:	618000ef          	jal	ea0 <close>
        close(1);
     88c:	00100513          	li	a0,1
     890:	610000ef          	jal	ea0 <close>
        if(dup(bb[1]) != 1){
     894:	f9442503          	lw	a0,-108(s0)
     898:	680000ef          	jal	f18 <dup>
     89c:	00100793          	li	a5,1
     8a0:	00f50e63          	beq	a0,a5,8bc <go+0x818>
          fprintf(2, "grind: dup failed\n");
     8a4:	00001597          	auipc	a1,0x1
     8a8:	07c58593          	addi	a1,a1,124 # 1920 <malloc+0x3d8>
     8ac:	00200513          	li	a0,2
     8b0:	355000ef          	jal	1404 <fprintf>
          exit(5);
     8b4:	00500513          	li	a0,5
     8b8:	5ac000ef          	jal	e64 <exit>
        close(bb[1]);
     8bc:	f9442503          	lw	a0,-108(s0)
     8c0:	5e0000ef          	jal	ea0 <close>
        char *args[2] = { "cat", 0 };
     8c4:	00001797          	auipc	a5,0x1
     8c8:	0ac78793          	addi	a5,a5,172 # 1970 <malloc+0x428>
     8cc:	f8f43c23          	sd	a5,-104(s0)
     8d0:	fa043023          	sd	zero,-96(s0)
        exec("/cat", args);
     8d4:	f9840593          	addi	a1,s0,-104
     8d8:	00001517          	auipc	a0,0x1
     8dc:	0a050513          	addi	a0,a0,160 # 1978 <malloc+0x430>
     8e0:	5d8000ef          	jal	eb8 <exec>
        fprintf(2, "grind: cat: not found\n");
     8e4:	00001597          	auipc	a1,0x1
     8e8:	09c58593          	addi	a1,a1,156 # 1980 <malloc+0x438>
     8ec:	00200513          	li	a0,2
     8f0:	315000ef          	jal	1404 <fprintf>
        exit(6);
     8f4:	00600513          	li	a0,6
     8f8:	56c000ef          	jal	e64 <exit>
        fprintf(2, "grind: fork failed\n");
     8fc:	00001597          	auipc	a1,0x1
     900:	ed458593          	addi	a1,a1,-300 # 17d0 <malloc+0x288>
     904:	00200513          	li	a0,2
     908:	2fd000ef          	jal	1404 <fprintf>
        exit(7);
     90c:	00700513          	li	a0,7
     910:	554000ef          	jal	e64 <exit>
     914:	00078b13          	mv	s6,a5
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     918:	f8040693          	addi	a3,s0,-128
     91c:	000b8613          	mv	a2,s7
     920:	000b0593          	mv	a1,s6
     924:	00001517          	auipc	a0,0x1
     928:	07c50513          	addi	a0,a0,124 # 19a0 <malloc+0x458>
     92c:	31d000ef          	jal	1448 <printf>
        exit(1);
     930:	00100513          	li	a0,1
     934:	530000ef          	jal	e64 <exit>

0000000000000938 <iter>:
  }
}

void
iter()
{
     938:	fd010113          	addi	sp,sp,-48
     93c:	02113423          	sd	ra,40(sp)
     940:	02813023          	sd	s0,32(sp)
     944:	03010413          	addi	s0,sp,48
  unlink("a");
     948:	00001517          	auipc	a0,0x1
     94c:	ea050513          	addi	a0,a0,-352 # 17e8 <malloc+0x2a0>
     950:	58c000ef          	jal	edc <unlink>
  unlink("b");
     954:	00001517          	auipc	a0,0x1
     958:	e4450513          	addi	a0,a0,-444 # 1798 <malloc+0x250>
     95c:	580000ef          	jal	edc <unlink>
  
  int pid1 = fork();
     960:	4f8000ef          	jal	e58 <fork>
  if(pid1 < 0){
     964:	02054863          	bltz	a0,994 <iter+0x5c>
     968:	00913c23          	sd	s1,24(sp)
     96c:	00050493          	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     970:	04051063          	bnez	a0,9b0 <iter+0x78>
     974:	01213823          	sd	s2,16(sp)
    rand_next ^= 31;
     978:	00001717          	auipc	a4,0x1
     97c:	68870713          	addi	a4,a4,1672 # 2000 <rand_next>
     980:	00073783          	ld	a5,0(a4)
     984:	01f7c793          	xori	a5,a5,31
     988:	00f73023          	sd	a5,0(a4)
    go(0);
     98c:	00000513          	li	a0,0
     990:	f14ff0ef          	jal	a4 <go>
     994:	00913c23          	sd	s1,24(sp)
     998:	01213823          	sd	s2,16(sp)
    printf("grind: fork failed\n");
     99c:	00001517          	auipc	a0,0x1
     9a0:	e3450513          	addi	a0,a0,-460 # 17d0 <malloc+0x288>
     9a4:	2a5000ef          	jal	1448 <printf>
    exit(1);
     9a8:	00100513          	li	a0,1
     9ac:	4b8000ef          	jal	e64 <exit>
     9b0:	01213823          	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     9b4:	4a4000ef          	jal	e58 <fork>
     9b8:	00050913          	mv	s2,a0
  if(pid2 < 0){
     9bc:	02054663          	bltz	a0,9e8 <iter+0xb0>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     9c0:	02051e63          	bnez	a0,9fc <iter+0xc4>
    rand_next ^= 7177;
     9c4:	00001697          	auipc	a3,0x1
     9c8:	63c68693          	addi	a3,a3,1596 # 2000 <rand_next>
     9cc:	0006b783          	ld	a5,0(a3)
     9d0:	00002737          	lui	a4,0x2
     9d4:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x1d9>
     9d8:	00e7c7b3          	xor	a5,a5,a4
     9dc:	00f6b023          	sd	a5,0(a3)
    go(1);
     9e0:	00100513          	li	a0,1
     9e4:	ec0ff0ef          	jal	a4 <go>
    printf("grind: fork failed\n");
     9e8:	00001517          	auipc	a0,0x1
     9ec:	de850513          	addi	a0,a0,-536 # 17d0 <malloc+0x288>
     9f0:	259000ef          	jal	1448 <printf>
    exit(1);
     9f4:	00100513          	li	a0,1
     9f8:	46c000ef          	jal	e64 <exit>
    exit(0);
  }

  int st1 = -1;
     9fc:	fff00793          	li	a5,-1
     a00:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     a04:	fdc40513          	addi	a0,s0,-36
     a08:	468000ef          	jal	e70 <wait>
  if(st1 != 0){
     a0c:	fdc42783          	lw	a5,-36(s0)
     a10:	00079e63          	bnez	a5,a2c <iter+0xf4>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     a14:	fff00793          	li	a5,-1
     a18:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     a1c:	fd840513          	addi	a0,s0,-40
     a20:	450000ef          	jal	e70 <wait>

  exit(0);
     a24:	00000513          	li	a0,0
     a28:	43c000ef          	jal	e64 <exit>
    kill(pid1);
     a2c:	00048513          	mv	a0,s1
     a30:	47c000ef          	jal	eac <kill>
    kill(pid2);
     a34:	00090513          	mv	a0,s2
     a38:	474000ef          	jal	eac <kill>
     a3c:	fd9ff06f          	j	a14 <iter+0xdc>

0000000000000a40 <main>:
}

int
main()
{
     a40:	fe010113          	addi	sp,sp,-32
     a44:	00113c23          	sd	ra,24(sp)
     a48:	00813823          	sd	s0,16(sp)
     a4c:	00913423          	sd	s1,8(sp)
     a50:	02010413          	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     a54:	00001497          	auipc	s1,0x1
     a58:	5ac48493          	addi	s1,s1,1452 # 2000 <rand_next>
     a5c:	01c0006f          	j	a78 <main+0x38>
      iter();
     a60:	ed9ff0ef          	jal	938 <iter>
    sleep(20);
     a64:	01400513          	li	a0,20
     a68:	4d4000ef          	jal	f3c <sleep>
    rand_next += 1;
     a6c:	0004b783          	ld	a5,0(s1)
     a70:	00178793          	addi	a5,a5,1
     a74:	00f4b023          	sd	a5,0(s1)
    int pid = fork();
     a78:	3e0000ef          	jal	e58 <fork>
    if(pid == 0){
     a7c:	fe0502e3          	beqz	a0,a60 <main+0x20>
    if(pid > 0){
     a80:	fea052e3          	blez	a0,a64 <main+0x24>
      wait(0);
     a84:	00000513          	li	a0,0
     a88:	3e8000ef          	jal	e70 <wait>
     a8c:	fd9ff06f          	j	a64 <main+0x24>

0000000000000a90 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     a90:	ff010113          	addi	sp,sp,-16
     a94:	00113423          	sd	ra,8(sp)
     a98:	00813023          	sd	s0,0(sp)
     a9c:	01010413          	addi	s0,sp,16
  extern int main();
  main();
     aa0:	fa1ff0ef          	jal	a40 <main>
  exit(0);
     aa4:	00000513          	li	a0,0
     aa8:	3bc000ef          	jal	e64 <exit>

0000000000000aac <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     aac:	ff010113          	addi	sp,sp,-16
     ab0:	00813423          	sd	s0,8(sp)
     ab4:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     ab8:	00050793          	mv	a5,a0
     abc:	00158593          	addi	a1,a1,1
     ac0:	00178793          	addi	a5,a5,1
     ac4:	fff5c703          	lbu	a4,-1(a1)
     ac8:	fee78fa3          	sb	a4,-1(a5)
     acc:	fe0718e3          	bnez	a4,abc <strcpy+0x10>
    ;
  return os;
}
     ad0:	00813403          	ld	s0,8(sp)
     ad4:	01010113          	addi	sp,sp,16
     ad8:	00008067          	ret

0000000000000adc <strcmp>:

int
strcmp(const char *p, const char *q)
{
     adc:	ff010113          	addi	sp,sp,-16
     ae0:	00813423          	sd	s0,8(sp)
     ae4:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
     ae8:	00054783          	lbu	a5,0(a0)
     aec:	00078e63          	beqz	a5,b08 <strcmp+0x2c>
     af0:	0005c703          	lbu	a4,0(a1)
     af4:	00f71a63          	bne	a4,a5,b08 <strcmp+0x2c>
    p++, q++;
     af8:	00150513          	addi	a0,a0,1
     afc:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
     b00:	00054783          	lbu	a5,0(a0)
     b04:	fe0796e3          	bnez	a5,af0 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
     b08:	0005c503          	lbu	a0,0(a1)
}
     b0c:	40a7853b          	subw	a0,a5,a0
     b10:	00813403          	ld	s0,8(sp)
     b14:	01010113          	addi	sp,sp,16
     b18:	00008067          	ret

0000000000000b1c <strlen>:

uint
strlen(const char *s)
{
     b1c:	ff010113          	addi	sp,sp,-16
     b20:	00813423          	sd	s0,8(sp)
     b24:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     b28:	00054783          	lbu	a5,0(a0)
     b2c:	02078863          	beqz	a5,b5c <strlen+0x40>
     b30:	00150513          	addi	a0,a0,1
     b34:	00050793          	mv	a5,a0
     b38:	00078693          	mv	a3,a5
     b3c:	00178793          	addi	a5,a5,1
     b40:	fff7c703          	lbu	a4,-1(a5)
     b44:	fe071ae3          	bnez	a4,b38 <strlen+0x1c>
     b48:	40a6853b          	subw	a0,a3,a0
     b4c:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
     b50:	00813403          	ld	s0,8(sp)
     b54:	01010113          	addi	sp,sp,16
     b58:	00008067          	ret
  for(n = 0; s[n]; n++)
     b5c:	00000513          	li	a0,0
     b60:	ff1ff06f          	j	b50 <strlen+0x34>

0000000000000b64 <memset>:

void*
memset(void *dst, int c, uint n)
{
     b64:	ff010113          	addi	sp,sp,-16
     b68:	00813423          	sd	s0,8(sp)
     b6c:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     b70:	02060063          	beqz	a2,b90 <memset+0x2c>
     b74:	00050793          	mv	a5,a0
     b78:	02061613          	slli	a2,a2,0x20
     b7c:	02065613          	srli	a2,a2,0x20
     b80:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     b84:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     b88:	00178793          	addi	a5,a5,1
     b8c:	fee79ce3          	bne	a5,a4,b84 <memset+0x20>
  }
  return dst;
}
     b90:	00813403          	ld	s0,8(sp)
     b94:	01010113          	addi	sp,sp,16
     b98:	00008067          	ret

0000000000000b9c <strchr>:

char*
strchr(const char *s, char c)
{
     b9c:	ff010113          	addi	sp,sp,-16
     ba0:	00813423          	sd	s0,8(sp)
     ba4:	01010413          	addi	s0,sp,16
  for(; *s; s++)
     ba8:	00054783          	lbu	a5,0(a0)
     bac:	02078263          	beqz	a5,bd0 <strchr+0x34>
    if(*s == c)
     bb0:	00f58a63          	beq	a1,a5,bc4 <strchr+0x28>
  for(; *s; s++)
     bb4:	00150513          	addi	a0,a0,1
     bb8:	00054783          	lbu	a5,0(a0)
     bbc:	fe079ae3          	bnez	a5,bb0 <strchr+0x14>
      return (char*)s;
  return 0;
     bc0:	00000513          	li	a0,0
}
     bc4:	00813403          	ld	s0,8(sp)
     bc8:	01010113          	addi	sp,sp,16
     bcc:	00008067          	ret
  return 0;
     bd0:	00000513          	li	a0,0
     bd4:	ff1ff06f          	j	bc4 <strchr+0x28>

0000000000000bd8 <gets>:

char*
gets(char *buf, int max)
{
     bd8:	fa010113          	addi	sp,sp,-96
     bdc:	04113c23          	sd	ra,88(sp)
     be0:	04813823          	sd	s0,80(sp)
     be4:	04913423          	sd	s1,72(sp)
     be8:	05213023          	sd	s2,64(sp)
     bec:	03313c23          	sd	s3,56(sp)
     bf0:	03413823          	sd	s4,48(sp)
     bf4:	03513423          	sd	s5,40(sp)
     bf8:	03613023          	sd	s6,32(sp)
     bfc:	01713c23          	sd	s7,24(sp)
     c00:	06010413          	addi	s0,sp,96
     c04:	00050b93          	mv	s7,a0
     c08:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c0c:	00050913          	mv	s2,a0
     c10:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c14:	00a00a93          	li	s5,10
     c18:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
     c1c:	00048993          	mv	s3,s1
     c20:	0014849b          	addiw	s1,s1,1
     c24:	0344dc63          	bge	s1,s4,c5c <gets+0x84>
    cc = read(0, &c, 1);
     c28:	00100613          	li	a2,1
     c2c:	faf40593          	addi	a1,s0,-81
     c30:	00000513          	li	a0,0
     c34:	254000ef          	jal	e88 <read>
    if(cc < 1)
     c38:	02a05263          	blez	a0,c5c <gets+0x84>
    buf[i++] = c;
     c3c:	faf44783          	lbu	a5,-81(s0)
     c40:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c44:	01578a63          	beq	a5,s5,c58 <gets+0x80>
     c48:	00190913          	addi	s2,s2,1
     c4c:	fd6798e3          	bne	a5,s6,c1c <gets+0x44>
    buf[i++] = c;
     c50:	00048993          	mv	s3,s1
     c54:	0080006f          	j	c5c <gets+0x84>
     c58:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c5c:	013b89b3          	add	s3,s7,s3
     c60:	00098023          	sb	zero,0(s3)
  return buf;
}
     c64:	000b8513          	mv	a0,s7
     c68:	05813083          	ld	ra,88(sp)
     c6c:	05013403          	ld	s0,80(sp)
     c70:	04813483          	ld	s1,72(sp)
     c74:	04013903          	ld	s2,64(sp)
     c78:	03813983          	ld	s3,56(sp)
     c7c:	03013a03          	ld	s4,48(sp)
     c80:	02813a83          	ld	s5,40(sp)
     c84:	02013b03          	ld	s6,32(sp)
     c88:	01813b83          	ld	s7,24(sp)
     c8c:	06010113          	addi	sp,sp,96
     c90:	00008067          	ret

0000000000000c94 <stat>:

int
stat(const char *n, struct stat *st)
{
     c94:	fe010113          	addi	sp,sp,-32
     c98:	00113c23          	sd	ra,24(sp)
     c9c:	00813823          	sd	s0,16(sp)
     ca0:	01213023          	sd	s2,0(sp)
     ca4:	02010413          	addi	s0,sp,32
     ca8:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cac:	00000593          	li	a1,0
     cb0:	214000ef          	jal	ec4 <open>
  if(fd < 0)
     cb4:	02054e63          	bltz	a0,cf0 <stat+0x5c>
     cb8:	00913423          	sd	s1,8(sp)
     cbc:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     cc0:	00090593          	mv	a1,s2
     cc4:	224000ef          	jal	ee8 <fstat>
     cc8:	00050913          	mv	s2,a0
  close(fd);
     ccc:	00048513          	mv	a0,s1
     cd0:	1d0000ef          	jal	ea0 <close>
  return r;
     cd4:	00813483          	ld	s1,8(sp)
}
     cd8:	00090513          	mv	a0,s2
     cdc:	01813083          	ld	ra,24(sp)
     ce0:	01013403          	ld	s0,16(sp)
     ce4:	00013903          	ld	s2,0(sp)
     ce8:	02010113          	addi	sp,sp,32
     cec:	00008067          	ret
    return -1;
     cf0:	fff00913          	li	s2,-1
     cf4:	fe5ff06f          	j	cd8 <stat+0x44>

0000000000000cf8 <atoi>:

int
atoi(const char *s)
{
     cf8:	ff010113          	addi	sp,sp,-16
     cfc:	00813423          	sd	s0,8(sp)
     d00:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d04:	00054683          	lbu	a3,0(a0)
     d08:	fd06879b          	addiw	a5,a3,-48
     d0c:	0ff7f793          	zext.b	a5,a5
     d10:	00900613          	li	a2,9
     d14:	04f66063          	bltu	a2,a5,d54 <atoi+0x5c>
     d18:	00050713          	mv	a4,a0
  n = 0;
     d1c:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
     d20:	00170713          	addi	a4,a4,1
     d24:	0025179b          	slliw	a5,a0,0x2
     d28:	00a787bb          	addw	a5,a5,a0
     d2c:	0017979b          	slliw	a5,a5,0x1
     d30:	00d787bb          	addw	a5,a5,a3
     d34:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d38:	00074683          	lbu	a3,0(a4)
     d3c:	fd06879b          	addiw	a5,a3,-48
     d40:	0ff7f793          	zext.b	a5,a5
     d44:	fcf67ee3          	bgeu	a2,a5,d20 <atoi+0x28>
  return n;
}
     d48:	00813403          	ld	s0,8(sp)
     d4c:	01010113          	addi	sp,sp,16
     d50:	00008067          	ret
  n = 0;
     d54:	00000513          	li	a0,0
     d58:	ff1ff06f          	j	d48 <atoi+0x50>

0000000000000d5c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d5c:	ff010113          	addi	sp,sp,-16
     d60:	00813423          	sd	s0,8(sp)
     d64:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d68:	02b57c63          	bgeu	a0,a1,da0 <memmove+0x44>
    while(n-- > 0)
     d6c:	02c05463          	blez	a2,d94 <memmove+0x38>
     d70:	02061613          	slli	a2,a2,0x20
     d74:	02065613          	srli	a2,a2,0x20
     d78:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d7c:	00050713          	mv	a4,a0
      *dst++ = *src++;
     d80:	00158593          	addi	a1,a1,1
     d84:	00170713          	addi	a4,a4,1
     d88:	fff5c683          	lbu	a3,-1(a1)
     d8c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d90:	fef718e3          	bne	a4,a5,d80 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d94:	00813403          	ld	s0,8(sp)
     d98:	01010113          	addi	sp,sp,16
     d9c:	00008067          	ret
    dst += n;
     da0:	00c50733          	add	a4,a0,a2
    src += n;
     da4:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
     da8:	fec056e3          	blez	a2,d94 <memmove+0x38>
     dac:	fff6079b          	addiw	a5,a2,-1
     db0:	02079793          	slli	a5,a5,0x20
     db4:	0207d793          	srli	a5,a5,0x20
     db8:	fff7c793          	not	a5,a5
     dbc:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
     dc0:	fff58593          	addi	a1,a1,-1
     dc4:	fff70713          	addi	a4,a4,-1
     dc8:	0005c683          	lbu	a3,0(a1)
     dcc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     dd0:	fee798e3          	bne	a5,a4,dc0 <memmove+0x64>
     dd4:	fc1ff06f          	j	d94 <memmove+0x38>

0000000000000dd8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     dd8:	ff010113          	addi	sp,sp,-16
     ddc:	00813423          	sd	s0,8(sp)
     de0:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     de4:	04060463          	beqz	a2,e2c <memcmp+0x54>
     de8:	fff6069b          	addiw	a3,a2,-1
     dec:	02069693          	slli	a3,a3,0x20
     df0:	0206d693          	srli	a3,a3,0x20
     df4:	00168693          	addi	a3,a3,1
     df8:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
     dfc:	00054783          	lbu	a5,0(a0)
     e00:	0005c703          	lbu	a4,0(a1)
     e04:	00e79c63          	bne	a5,a4,e1c <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
     e08:	00150513          	addi	a0,a0,1
    p2++;
     e0c:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
     e10:	fed516e3          	bne	a0,a3,dfc <memcmp+0x24>
  }
  return 0;
     e14:	00000513          	li	a0,0
     e18:	0080006f          	j	e20 <memcmp+0x48>
      return *p1 - *p2;
     e1c:	40e7853b          	subw	a0,a5,a4
}
     e20:	00813403          	ld	s0,8(sp)
     e24:	01010113          	addi	sp,sp,16
     e28:	00008067          	ret
  return 0;
     e2c:	00000513          	li	a0,0
     e30:	ff1ff06f          	j	e20 <memcmp+0x48>

0000000000000e34 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e34:	ff010113          	addi	sp,sp,-16
     e38:	00113423          	sd	ra,8(sp)
     e3c:	00813023          	sd	s0,0(sp)
     e40:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
     e44:	f19ff0ef          	jal	d5c <memmove>
}
     e48:	00813083          	ld	ra,8(sp)
     e4c:	00013403          	ld	s0,0(sp)
     e50:	01010113          	addi	sp,sp,16
     e54:	00008067          	ret

0000000000000e58 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e58:	00100893          	li	a7,1
 ecall
     e5c:	00000073          	ecall
 ret
     e60:	00008067          	ret

0000000000000e64 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e64:	00200893          	li	a7,2
 ecall
     e68:	00000073          	ecall
 ret
     e6c:	00008067          	ret

0000000000000e70 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e70:	00300893          	li	a7,3
 ecall
     e74:	00000073          	ecall
 ret
     e78:	00008067          	ret

0000000000000e7c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e7c:	00400893          	li	a7,4
 ecall
     e80:	00000073          	ecall
 ret
     e84:	00008067          	ret

0000000000000e88 <read>:
.global read
read:
 li a7, SYS_read
     e88:	00500893          	li	a7,5
 ecall
     e8c:	00000073          	ecall
 ret
     e90:	00008067          	ret

0000000000000e94 <write>:
.global write
write:
 li a7, SYS_write
     e94:	01000893          	li	a7,16
 ecall
     e98:	00000073          	ecall
 ret
     e9c:	00008067          	ret

0000000000000ea0 <close>:
.global close
close:
 li a7, SYS_close
     ea0:	01500893          	li	a7,21
 ecall
     ea4:	00000073          	ecall
 ret
     ea8:	00008067          	ret

0000000000000eac <kill>:
.global kill
kill:
 li a7, SYS_kill
     eac:	00600893          	li	a7,6
 ecall
     eb0:	00000073          	ecall
 ret
     eb4:	00008067          	ret

0000000000000eb8 <exec>:
.global exec
exec:
 li a7, SYS_exec
     eb8:	00700893          	li	a7,7
 ecall
     ebc:	00000073          	ecall
 ret
     ec0:	00008067          	ret

0000000000000ec4 <open>:
.global open
open:
 li a7, SYS_open
     ec4:	00f00893          	li	a7,15
 ecall
     ec8:	00000073          	ecall
 ret
     ecc:	00008067          	ret

0000000000000ed0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     ed0:	01100893          	li	a7,17
 ecall
     ed4:	00000073          	ecall
 ret
     ed8:	00008067          	ret

0000000000000edc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     edc:	01200893          	li	a7,18
 ecall
     ee0:	00000073          	ecall
 ret
     ee4:	00008067          	ret

0000000000000ee8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ee8:	00800893          	li	a7,8
 ecall
     eec:	00000073          	ecall
 ret
     ef0:	00008067          	ret

0000000000000ef4 <link>:
.global link
link:
 li a7, SYS_link
     ef4:	01300893          	li	a7,19
 ecall
     ef8:	00000073          	ecall
 ret
     efc:	00008067          	ret

0000000000000f00 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f00:	01400893          	li	a7,20
 ecall
     f04:	00000073          	ecall
 ret
     f08:	00008067          	ret

0000000000000f0c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f0c:	00900893          	li	a7,9
 ecall
     f10:	00000073          	ecall
 ret
     f14:	00008067          	ret

0000000000000f18 <dup>:
.global dup
dup:
 li a7, SYS_dup
     f18:	00a00893          	li	a7,10
 ecall
     f1c:	00000073          	ecall
 ret
     f20:	00008067          	ret

0000000000000f24 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f24:	00b00893          	li	a7,11
 ecall
     f28:	00000073          	ecall
 ret
     f2c:	00008067          	ret

0000000000000f30 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f30:	00c00893          	li	a7,12
 ecall
     f34:	00000073          	ecall
 ret
     f38:	00008067          	ret

0000000000000f3c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f3c:	00d00893          	li	a7,13
 ecall
     f40:	00000073          	ecall
 ret
     f44:	00008067          	ret

0000000000000f48 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f48:	00e00893          	li	a7,14
 ecall
     f4c:	00000073          	ecall
 ret
     f50:	00008067          	ret

0000000000000f54 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     f54:	fe010113          	addi	sp,sp,-32
     f58:	00113c23          	sd	ra,24(sp)
     f5c:	00813823          	sd	s0,16(sp)
     f60:	02010413          	addi	s0,sp,32
     f64:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f68:	00100613          	li	a2,1
     f6c:	fef40593          	addi	a1,s0,-17
     f70:	f25ff0ef          	jal	e94 <write>
}
     f74:	01813083          	ld	ra,24(sp)
     f78:	01013403          	ld	s0,16(sp)
     f7c:	02010113          	addi	sp,sp,32
     f80:	00008067          	ret

0000000000000f84 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f84:	fc010113          	addi	sp,sp,-64
     f88:	02113c23          	sd	ra,56(sp)
     f8c:	02813823          	sd	s0,48(sp)
     f90:	02913423          	sd	s1,40(sp)
     f94:	04010413          	addi	s0,sp,64
     f98:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f9c:	00068463          	beqz	a3,fa4 <printint+0x20>
     fa0:	0c05c263          	bltz	a1,1064 <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     fa4:	0005859b          	sext.w	a1,a1
  neg = 0;
     fa8:	00000893          	li	a7,0
     fac:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     fb0:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
     fb4:	0006061b          	sext.w	a2,a2
     fb8:	00001517          	auipc	a0,0x1
     fbc:	a7850513          	addi	a0,a0,-1416 # 1a30 <digits>
     fc0:	00070813          	mv	a6,a4
     fc4:	0017071b          	addiw	a4,a4,1
     fc8:	02c5f7bb          	remuw	a5,a1,a2
     fcc:	02079793          	slli	a5,a5,0x20
     fd0:	0207d793          	srli	a5,a5,0x20
     fd4:	00f507b3          	add	a5,a0,a5
     fd8:	0007c783          	lbu	a5,0(a5)
     fdc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     fe0:	0005879b          	sext.w	a5,a1
     fe4:	02c5d5bb          	divuw	a1,a1,a2
     fe8:	00168693          	addi	a3,a3,1
     fec:	fcc7fae3          	bgeu	a5,a2,fc0 <printint+0x3c>
  if(neg)
     ff0:	00088c63          	beqz	a7,1008 <printint+0x84>
    buf[i++] = '-';
     ff4:	fd070793          	addi	a5,a4,-48
     ff8:	00878733          	add	a4,a5,s0
     ffc:	02d00793          	li	a5,45
    1000:	fef70823          	sb	a5,-16(a4)
    1004:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1008:	04e05463          	blez	a4,1050 <printint+0xcc>
    100c:	03213023          	sd	s2,32(sp)
    1010:	01313c23          	sd	s3,24(sp)
    1014:	fc040793          	addi	a5,s0,-64
    1018:	00e78933          	add	s2,a5,a4
    101c:	fff78993          	addi	s3,a5,-1
    1020:	00e989b3          	add	s3,s3,a4
    1024:	fff7071b          	addiw	a4,a4,-1
    1028:	02071713          	slli	a4,a4,0x20
    102c:	02075713          	srli	a4,a4,0x20
    1030:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1034:	fff94583          	lbu	a1,-1(s2)
    1038:	00048513          	mv	a0,s1
    103c:	f19ff0ef          	jal	f54 <putc>
  while(--i >= 0)
    1040:	fff90913          	addi	s2,s2,-1
    1044:	ff3918e3          	bne	s2,s3,1034 <printint+0xb0>
    1048:	02013903          	ld	s2,32(sp)
    104c:	01813983          	ld	s3,24(sp)
}
    1050:	03813083          	ld	ra,56(sp)
    1054:	03013403          	ld	s0,48(sp)
    1058:	02813483          	ld	s1,40(sp)
    105c:	04010113          	addi	sp,sp,64
    1060:	00008067          	ret
    x = -xx;
    1064:	40b005bb          	negw	a1,a1
    neg = 1;
    1068:	00100893          	li	a7,1
    x = -xx;
    106c:	f41ff06f          	j	fac <printint+0x28>

0000000000001070 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1070:	fa010113          	addi	sp,sp,-96
    1074:	04113c23          	sd	ra,88(sp)
    1078:	04813823          	sd	s0,80(sp)
    107c:	05213023          	sd	s2,64(sp)
    1080:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1084:	0005c903          	lbu	s2,0(a1)
    1088:	36090463          	beqz	s2,13f0 <vprintf+0x380>
    108c:	04913423          	sd	s1,72(sp)
    1090:	03313c23          	sd	s3,56(sp)
    1094:	03413823          	sd	s4,48(sp)
    1098:	03513423          	sd	s5,40(sp)
    109c:	03613023          	sd	s6,32(sp)
    10a0:	01713c23          	sd	s7,24(sp)
    10a4:	01813823          	sd	s8,16(sp)
    10a8:	01913423          	sd	s9,8(sp)
    10ac:	00050b13          	mv	s6,a0
    10b0:	00058a13          	mv	s4,a1
    10b4:	00060b93          	mv	s7,a2
  state = 0;
    10b8:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
    10bc:	00000493          	li	s1,0
    10c0:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    10c4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    10c8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    10cc:	06c00c93          	li	s9,108
    10d0:	02c0006f          	j	10fc <vprintf+0x8c>
        putc(fd, c0);
    10d4:	00090593          	mv	a1,s2
    10d8:	000b0513          	mv	a0,s6
    10dc:	e79ff0ef          	jal	f54 <putc>
    10e0:	0080006f          	j	10e8 <vprintf+0x78>
    } else if(state == '%'){
    10e4:	03598663          	beq	s3,s5,1110 <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
    10e8:	0014849b          	addiw	s1,s1,1
    10ec:	00048713          	mv	a4,s1
    10f0:	009a07b3          	add	a5,s4,s1
    10f4:	0007c903          	lbu	s2,0(a5)
    10f8:	2c090c63          	beqz	s2,13d0 <vprintf+0x360>
    c0 = fmt[i] & 0xff;
    10fc:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1100:	fe0992e3          	bnez	s3,10e4 <vprintf+0x74>
      if(c0 == '%'){
    1104:	fd5798e3          	bne	a5,s5,10d4 <vprintf+0x64>
        state = '%';
    1108:	00078993          	mv	s3,a5
    110c:	fddff06f          	j	10e8 <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
    1110:	00ea06b3          	add	a3,s4,a4
    1114:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    1118:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    111c:	00068663          	beqz	a3,1128 <vprintf+0xb8>
    1120:	00ea0733          	add	a4,s4,a4
    1124:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    1128:	05878263          	beq	a5,s8,116c <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
    112c:	07978263          	beq	a5,s9,1190 <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    1130:	07500713          	li	a4,117
    1134:	12e78663          	beq	a5,a4,1260 <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    1138:	07800713          	li	a4,120
    113c:	18e78c63          	beq	a5,a4,12d4 <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1140:	07000713          	li	a4,112
    1144:	1ce78e63          	beq	a5,a4,1320 <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    1148:	07300713          	li	a4,115
    114c:	22e78a63          	beq	a5,a4,1380 <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1150:	02500713          	li	a4,37
    1154:	04e79e63          	bne	a5,a4,11b0 <vprintf+0x140>
        putc(fd, '%');
    1158:	02500593          	li	a1,37
    115c:	000b0513          	mv	a0,s6
    1160:	df5ff0ef          	jal	f54 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    1164:	00000993          	li	s3,0
    1168:	f81ff06f          	j	10e8 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
    116c:	008b8913          	addi	s2,s7,8
    1170:	00100693          	li	a3,1
    1174:	00a00613          	li	a2,10
    1178:	000ba583          	lw	a1,0(s7)
    117c:	000b0513          	mv	a0,s6
    1180:	e05ff0ef          	jal	f84 <printint>
    1184:	00090b93          	mv	s7,s2
      state = 0;
    1188:	00000993          	li	s3,0
    118c:	f5dff06f          	j	10e8 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
    1190:	06400793          	li	a5,100
    1194:	02f68e63          	beq	a3,a5,11d0 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1198:	06c00793          	li	a5,108
    119c:	04f68e63          	beq	a3,a5,11f8 <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
    11a0:	07500793          	li	a5,117
    11a4:	0ef68063          	beq	a3,a5,1284 <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
    11a8:	07800793          	li	a5,120
    11ac:	14f68663          	beq	a3,a5,12f8 <vprintf+0x288>
        putc(fd, '%');
    11b0:	02500593          	li	a1,37
    11b4:	000b0513          	mv	a0,s6
    11b8:	d9dff0ef          	jal	f54 <putc>
        putc(fd, c0);
    11bc:	00090593          	mv	a1,s2
    11c0:	000b0513          	mv	a0,s6
    11c4:	d91ff0ef          	jal	f54 <putc>
      state = 0;
    11c8:	00000993          	li	s3,0
    11cc:	f1dff06f          	j	10e8 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
    11d0:	008b8913          	addi	s2,s7,8
    11d4:	00100693          	li	a3,1
    11d8:	00a00613          	li	a2,10
    11dc:	000ba583          	lw	a1,0(s7)
    11e0:	000b0513          	mv	a0,s6
    11e4:	da1ff0ef          	jal	f84 <printint>
        i += 1;
    11e8:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    11ec:	00090b93          	mv	s7,s2
      state = 0;
    11f0:	00000993          	li	s3,0
        i += 1;
    11f4:	ef5ff06f          	j	10e8 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    11f8:	06400793          	li	a5,100
    11fc:	02f60e63          	beq	a2,a5,1238 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1200:	07500793          	li	a5,117
    1204:	0af60463          	beq	a2,a5,12ac <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1208:	07800793          	li	a5,120
    120c:	faf612e3          	bne	a2,a5,11b0 <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1210:	008b8913          	addi	s2,s7,8
    1214:	00000693          	li	a3,0
    1218:	01000613          	li	a2,16
    121c:	000ba583          	lw	a1,0(s7)
    1220:	000b0513          	mv	a0,s6
    1224:	d61ff0ef          	jal	f84 <printint>
        i += 2;
    1228:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    122c:	00090b93          	mv	s7,s2
      state = 0;
    1230:	00000993          	li	s3,0
        i += 2;
    1234:	eb5ff06f          	j	10e8 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1238:	008b8913          	addi	s2,s7,8
    123c:	00100693          	li	a3,1
    1240:	00a00613          	li	a2,10
    1244:	000ba583          	lw	a1,0(s7)
    1248:	000b0513          	mv	a0,s6
    124c:	d39ff0ef          	jal	f84 <printint>
        i += 2;
    1250:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    1254:	00090b93          	mv	s7,s2
      state = 0;
    1258:	00000993          	li	s3,0
        i += 2;
    125c:	e8dff06f          	j	10e8 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
    1260:	008b8913          	addi	s2,s7,8
    1264:	00000693          	li	a3,0
    1268:	00a00613          	li	a2,10
    126c:	000ba583          	lw	a1,0(s7)
    1270:	000b0513          	mv	a0,s6
    1274:	d11ff0ef          	jal	f84 <printint>
    1278:	00090b93          	mv	s7,s2
      state = 0;
    127c:	00000993          	li	s3,0
    1280:	e69ff06f          	j	10e8 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1284:	008b8913          	addi	s2,s7,8
    1288:	00000693          	li	a3,0
    128c:	00a00613          	li	a2,10
    1290:	000ba583          	lw	a1,0(s7)
    1294:	000b0513          	mv	a0,s6
    1298:	cedff0ef          	jal	f84 <printint>
        i += 1;
    129c:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    12a0:	00090b93          	mv	s7,s2
      state = 0;
    12a4:	00000993          	li	s3,0
        i += 1;
    12a8:	e41ff06f          	j	10e8 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
    12ac:	008b8913          	addi	s2,s7,8
    12b0:	00000693          	li	a3,0
    12b4:	00a00613          	li	a2,10
    12b8:	000ba583          	lw	a1,0(s7)
    12bc:	000b0513          	mv	a0,s6
    12c0:	cc5ff0ef          	jal	f84 <printint>
        i += 2;
    12c4:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    12c8:	00090b93          	mv	s7,s2
      state = 0;
    12cc:	00000993          	li	s3,0
        i += 2;
    12d0:	e19ff06f          	j	10e8 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
    12d4:	008b8913          	addi	s2,s7,8
    12d8:	00000693          	li	a3,0
    12dc:	01000613          	li	a2,16
    12e0:	000ba583          	lw	a1,0(s7)
    12e4:	000b0513          	mv	a0,s6
    12e8:	c9dff0ef          	jal	f84 <printint>
    12ec:	00090b93          	mv	s7,s2
      state = 0;
    12f0:	00000993          	li	s3,0
    12f4:	df5ff06f          	j	10e8 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
    12f8:	008b8913          	addi	s2,s7,8
    12fc:	00000693          	li	a3,0
    1300:	01000613          	li	a2,16
    1304:	000ba583          	lw	a1,0(s7)
    1308:	000b0513          	mv	a0,s6
    130c:	c79ff0ef          	jal	f84 <printint>
        i += 1;
    1310:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1314:	00090b93          	mv	s7,s2
      state = 0;
    1318:	00000993          	li	s3,0
        i += 1;
    131c:	dcdff06f          	j	10e8 <vprintf+0x78>
    1320:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1324:	008b8d13          	addi	s10,s7,8
    1328:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    132c:	03000593          	li	a1,48
    1330:	000b0513          	mv	a0,s6
    1334:	c21ff0ef          	jal	f54 <putc>
  putc(fd, 'x');
    1338:	07800593          	li	a1,120
    133c:	000b0513          	mv	a0,s6
    1340:	c15ff0ef          	jal	f54 <putc>
    1344:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1348:	00000b97          	auipc	s7,0x0
    134c:	6e8b8b93          	addi	s7,s7,1768 # 1a30 <digits>
    1350:	03c9d793          	srli	a5,s3,0x3c
    1354:	00fb87b3          	add	a5,s7,a5
    1358:	0007c583          	lbu	a1,0(a5)
    135c:	000b0513          	mv	a0,s6
    1360:	bf5ff0ef          	jal	f54 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1364:	00499993          	slli	s3,s3,0x4
    1368:	fff9091b          	addiw	s2,s2,-1
    136c:	fe0912e3          	bnez	s2,1350 <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
    1370:	000d0b93          	mv	s7,s10
      state = 0;
    1374:	00000993          	li	s3,0
    1378:	00013d03          	ld	s10,0(sp)
    137c:	d6dff06f          	j	10e8 <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
    1380:	008b8993          	addi	s3,s7,8
    1384:	000bb903          	ld	s2,0(s7)
    1388:	02090663          	beqz	s2,13b4 <vprintf+0x344>
        for(; *s; s++)
    138c:	00094583          	lbu	a1,0(s2)
    1390:	02058a63          	beqz	a1,13c4 <vprintf+0x354>
          putc(fd, *s);
    1394:	000b0513          	mv	a0,s6
    1398:	bbdff0ef          	jal	f54 <putc>
        for(; *s; s++)
    139c:	00190913          	addi	s2,s2,1
    13a0:	00094583          	lbu	a1,0(s2)
    13a4:	fe0598e3          	bnez	a1,1394 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
    13a8:	00098b93          	mv	s7,s3
      state = 0;
    13ac:	00000993          	li	s3,0
    13b0:	d39ff06f          	j	10e8 <vprintf+0x78>
          s = "(null)";
    13b4:	00000917          	auipc	s2,0x0
    13b8:	61490913          	addi	s2,s2,1556 # 19c8 <malloc+0x480>
        for(; *s; s++)
    13bc:	02800593          	li	a1,40
    13c0:	fd5ff06f          	j	1394 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
    13c4:	00098b93          	mv	s7,s3
      state = 0;
    13c8:	00000993          	li	s3,0
    13cc:	d1dff06f          	j	10e8 <vprintf+0x78>
    13d0:	04813483          	ld	s1,72(sp)
    13d4:	03813983          	ld	s3,56(sp)
    13d8:	03013a03          	ld	s4,48(sp)
    13dc:	02813a83          	ld	s5,40(sp)
    13e0:	02013b03          	ld	s6,32(sp)
    13e4:	01813b83          	ld	s7,24(sp)
    13e8:	01013c03          	ld	s8,16(sp)
    13ec:	00813c83          	ld	s9,8(sp)
    }
  }
}
    13f0:	05813083          	ld	ra,88(sp)
    13f4:	05013403          	ld	s0,80(sp)
    13f8:	04013903          	ld	s2,64(sp)
    13fc:	06010113          	addi	sp,sp,96
    1400:	00008067          	ret

0000000000001404 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1404:	fb010113          	addi	sp,sp,-80
    1408:	00113c23          	sd	ra,24(sp)
    140c:	00813823          	sd	s0,16(sp)
    1410:	02010413          	addi	s0,sp,32
    1414:	00c43023          	sd	a2,0(s0)
    1418:	00d43423          	sd	a3,8(s0)
    141c:	00e43823          	sd	a4,16(s0)
    1420:	00f43c23          	sd	a5,24(s0)
    1424:	03043023          	sd	a6,32(s0)
    1428:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    142c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1430:	00040613          	mv	a2,s0
    1434:	c3dff0ef          	jal	1070 <vprintf>
}
    1438:	01813083          	ld	ra,24(sp)
    143c:	01013403          	ld	s0,16(sp)
    1440:	05010113          	addi	sp,sp,80
    1444:	00008067          	ret

0000000000001448 <printf>:

void
printf(const char *fmt, ...)
{
    1448:	fa010113          	addi	sp,sp,-96
    144c:	00113c23          	sd	ra,24(sp)
    1450:	00813823          	sd	s0,16(sp)
    1454:	02010413          	addi	s0,sp,32
    1458:	00b43423          	sd	a1,8(s0)
    145c:	00c43823          	sd	a2,16(s0)
    1460:	00d43c23          	sd	a3,24(s0)
    1464:	02e43023          	sd	a4,32(s0)
    1468:	02f43423          	sd	a5,40(s0)
    146c:	03043823          	sd	a6,48(s0)
    1470:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1474:	00840613          	addi	a2,s0,8
    1478:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    147c:	00050593          	mv	a1,a0
    1480:	00100513          	li	a0,1
    1484:	bedff0ef          	jal	1070 <vprintf>
}
    1488:	01813083          	ld	ra,24(sp)
    148c:	01013403          	ld	s0,16(sp)
    1490:	06010113          	addi	sp,sp,96
    1494:	00008067          	ret

0000000000001498 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1498:	ff010113          	addi	sp,sp,-16
    149c:	00813423          	sd	s0,8(sp)
    14a0:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    14a4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    14a8:	00001797          	auipc	a5,0x1
    14ac:	b687b783          	ld	a5,-1176(a5) # 2010 <freep>
    14b0:	0400006f          	j	14f0 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    14b4:	00862703          	lw	a4,8(a2)
    14b8:	00b7073b          	addw	a4,a4,a1
    14bc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    14c0:	0007b703          	ld	a4,0(a5)
    14c4:	00073603          	ld	a2,0(a4)
    14c8:	0500006f          	j	1518 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    14cc:	ff852703          	lw	a4,-8(a0)
    14d0:	00c7073b          	addw	a4,a4,a2
    14d4:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    14d8:	ff053683          	ld	a3,-16(a0)
    14dc:	0540006f          	j	1530 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    14e0:	0007b703          	ld	a4,0(a5)
    14e4:	00e7e463          	bltu	a5,a4,14ec <free+0x54>
    14e8:	00e6ec63          	bltu	a3,a4,1500 <free+0x68>
{
    14ec:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    14f0:	fed7f8e3          	bgeu	a5,a3,14e0 <free+0x48>
    14f4:	0007b703          	ld	a4,0(a5)
    14f8:	00e6e463          	bltu	a3,a4,1500 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    14fc:	fee7e8e3          	bltu	a5,a4,14ec <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
    1500:	ff852583          	lw	a1,-8(a0)
    1504:	0007b603          	ld	a2,0(a5)
    1508:	02059813          	slli	a6,a1,0x20
    150c:	01c85713          	srli	a4,a6,0x1c
    1510:	00e68733          	add	a4,a3,a4
    1514:	fae600e3          	beq	a2,a4,14b4 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
    1518:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    151c:	0087a603          	lw	a2,8(a5)
    1520:	02061593          	slli	a1,a2,0x20
    1524:	01c5d713          	srli	a4,a1,0x1c
    1528:	00e78733          	add	a4,a5,a4
    152c:	fae680e3          	beq	a3,a4,14cc <free+0x34>
    p->s.ptr = bp->s.ptr;
    1530:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1534:	00001717          	auipc	a4,0x1
    1538:	acf73e23          	sd	a5,-1316(a4) # 2010 <freep>
}
    153c:	00813403          	ld	s0,8(sp)
    1540:	01010113          	addi	sp,sp,16
    1544:	00008067          	ret

0000000000001548 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1548:	fc010113          	addi	sp,sp,-64
    154c:	02113c23          	sd	ra,56(sp)
    1550:	02813823          	sd	s0,48(sp)
    1554:	02913423          	sd	s1,40(sp)
    1558:	01313c23          	sd	s3,24(sp)
    155c:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1560:	02051493          	slli	s1,a0,0x20
    1564:	0204d493          	srli	s1,s1,0x20
    1568:	00f48493          	addi	s1,s1,15
    156c:	0044d493          	srli	s1,s1,0x4
    1570:	0014899b          	addiw	s3,s1,1
    1574:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
    1578:	00001517          	auipc	a0,0x1
    157c:	a9853503          	ld	a0,-1384(a0) # 2010 <freep>
    1580:	04050663          	beqz	a0,15cc <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1584:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1588:	0087a703          	lw	a4,8(a5)
    158c:	0c977c63          	bgeu	a4,s1,1664 <malloc+0x11c>
    1590:	03213023          	sd	s2,32(sp)
    1594:	01413823          	sd	s4,16(sp)
    1598:	01513423          	sd	s5,8(sp)
    159c:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
    15a0:	00098a13          	mv	s4,s3
    15a4:	0009871b          	sext.w	a4,s3
    15a8:	000016b7          	lui	a3,0x1
    15ac:	00d77463          	bgeu	a4,a3,15b4 <malloc+0x6c>
    15b0:	00001a37          	lui	s4,0x1
    15b4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    15b8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    15bc:	00001917          	auipc	s2,0x1
    15c0:	a5490913          	addi	s2,s2,-1452 # 2010 <freep>
  if(p == (char*)-1)
    15c4:	fff00a93          	li	s5,-1
    15c8:	05c0006f          	j	1624 <malloc+0xdc>
    15cc:	03213023          	sd	s2,32(sp)
    15d0:	01413823          	sd	s4,16(sp)
    15d4:	01513423          	sd	s5,8(sp)
    15d8:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    15dc:	00001797          	auipc	a5,0x1
    15e0:	e2c78793          	addi	a5,a5,-468 # 2408 <base>
    15e4:	00001717          	auipc	a4,0x1
    15e8:	a2f73623          	sd	a5,-1492(a4) # 2010 <freep>
    15ec:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
    15f0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    15f4:	fadff06f          	j	15a0 <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
    15f8:	0007b703          	ld	a4,0(a5)
    15fc:	00e53023          	sd	a4,0(a0)
    1600:	0800006f          	j	1680 <malloc+0x138>
  hp->s.size = nu;
    1604:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1608:	01050513          	addi	a0,a0,16
    160c:	e8dff0ef          	jal	1498 <free>
  return freep;
    1610:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1614:	08050863          	beqz	a0,16a4 <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1618:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
    161c:	0087a703          	lw	a4,8(a5)
    1620:	02977a63          	bgeu	a4,s1,1654 <malloc+0x10c>
    if(p == freep)
    1624:	00093703          	ld	a4,0(s2)
    1628:	00078513          	mv	a0,a5
    162c:	fef716e3          	bne	a4,a5,1618 <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
    1630:	000a0513          	mv	a0,s4
    1634:	8fdff0ef          	jal	f30 <sbrk>
  if(p == (char*)-1)
    1638:	fd5516e3          	bne	a0,s5,1604 <malloc+0xbc>
        return 0;
    163c:	00000513          	li	a0,0
    1640:	02013903          	ld	s2,32(sp)
    1644:	01013a03          	ld	s4,16(sp)
    1648:	00813a83          	ld	s5,8(sp)
    164c:	00013b03          	ld	s6,0(sp)
    1650:	03c0006f          	j	168c <malloc+0x144>
    1654:	02013903          	ld	s2,32(sp)
    1658:	01013a03          	ld	s4,16(sp)
    165c:	00813a83          	ld	s5,8(sp)
    1660:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
    1664:	f8e48ae3          	beq	s1,a4,15f8 <malloc+0xb0>
        p->s.size -= nunits;
    1668:	4137073b          	subw	a4,a4,s3
    166c:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
    1670:	02071693          	slli	a3,a4,0x20
    1674:	01c6d713          	srli	a4,a3,0x1c
    1678:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
    167c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1680:	00001717          	auipc	a4,0x1
    1684:	98a73823          	sd	a0,-1648(a4) # 2010 <freep>
      return (void*)(p + 1);
    1688:	01078513          	addi	a0,a5,16
  }
}
    168c:	03813083          	ld	ra,56(sp)
    1690:	03013403          	ld	s0,48(sp)
    1694:	02813483          	ld	s1,40(sp)
    1698:	01813983          	ld	s3,24(sp)
    169c:	04010113          	addi	sp,sp,64
    16a0:	00008067          	ret
    16a4:	02013903          	ld	s2,32(sp)
    16a8:	01013a03          	ld	s4,16(sp)
    16ac:	00813a83          	ld	s5,8(sp)
    16b0:	00013b03          	ld	s6,0(sp)
    16b4:	fd9ff06f          	j	168c <malloc+0x144>
