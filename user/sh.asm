
user/_sh:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	fe010113          	addi	sp,sp,-32
       4:	00113c23          	sd	ra,24(sp)
       8:	00813823          	sd	s0,16(sp)
       c:	00913423          	sd	s1,8(sp)
      10:	01213023          	sd	s2,0(sp)
      14:	02010413          	addi	s0,sp,32
      18:	00050493          	mv	s1,a0
      1c:	00058913          	mv	s2,a1
  write(2, "$ ", 2);
      20:	00200613          	li	a2,2
      24:	00002597          	auipc	a1,0x2
      28:	a0c58593          	addi	a1,a1,-1524 # 1a30 <malloc+0x17c>
      2c:	00200513          	li	a0,2
      30:	1d0010ef          	jal	1200 <write>
  memset(buf, 0, nbuf);
      34:	00090613          	mv	a2,s2
      38:	00000593          	li	a1,0
      3c:	00048513          	mv	a0,s1
      40:	691000ef          	jal	ed0 <memset>
  gets(buf, nbuf);
      44:	00090593          	mv	a1,s2
      48:	00048513          	mv	a0,s1
      4c:	6f9000ef          	jal	f44 <gets>
  if(buf[0] == 0) // EOF
      50:	0004c503          	lbu	a0,0(s1)
      54:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      58:	40a00533          	neg	a0,a0
      5c:	01813083          	ld	ra,24(sp)
      60:	01013403          	ld	s0,16(sp)
      64:	00813483          	ld	s1,8(sp)
      68:	00013903          	ld	s2,0(sp)
      6c:	02010113          	addi	sp,sp,32
      70:	00008067          	ret

0000000000000074 <panic>:
  exit(0);
}

void
panic(char *s)
{
      74:	ff010113          	addi	sp,sp,-16
      78:	00113423          	sd	ra,8(sp)
      7c:	00813023          	sd	s0,0(sp)
      80:	01010413          	addi	s0,sp,16
      84:	00050613          	mv	a2,a0
  fprintf(2, "%s\n", s);
      88:	00002597          	auipc	a1,0x2
      8c:	9b858593          	addi	a1,a1,-1608 # 1a40 <malloc+0x18c>
      90:	00200513          	li	a0,2
      94:	6dc010ef          	jal	1770 <fprintf>
  exit(1);
      98:	00100513          	li	a0,1
      9c:	134010ef          	jal	11d0 <exit>

00000000000000a0 <fork1>:
}

int
fork1(void)
{
      a0:	ff010113          	addi	sp,sp,-16
      a4:	00113423          	sd	ra,8(sp)
      a8:	00813023          	sd	s0,0(sp)
      ac:	01010413          	addi	s0,sp,16
  int pid;

  pid = fork();
      b0:	114010ef          	jal	11c4 <fork>
  if(pid == -1)
      b4:	fff00793          	li	a5,-1
      b8:	00f50a63          	beq	a0,a5,cc <fork1+0x2c>
    panic("fork");
  return pid;
}
      bc:	00813083          	ld	ra,8(sp)
      c0:	00013403          	ld	s0,0(sp)
      c4:	01010113          	addi	sp,sp,16
      c8:	00008067          	ret
    panic("fork");
      cc:	00002517          	auipc	a0,0x2
      d0:	97c50513          	addi	a0,a0,-1668 # 1a48 <malloc+0x194>
      d4:	fa1ff0ef          	jal	74 <panic>

00000000000000d8 <runcmd>:
{
      d8:	fd010113          	addi	sp,sp,-48
      dc:	02113423          	sd	ra,40(sp)
      e0:	02813023          	sd	s0,32(sp)
      e4:	03010413          	addi	s0,sp,48
  if(cmd == 0)
      e8:	02050c63          	beqz	a0,120 <runcmd+0x48>
      ec:	00913c23          	sd	s1,24(sp)
      f0:	00050493          	mv	s1,a0
  switch(cmd->type){
      f4:	00052703          	lw	a4,0(a0)
      f8:	00500793          	li	a5,5
      fc:	02e7e863          	bltu	a5,a4,12c <runcmd+0x54>
     100:	00056783          	lwu	a5,0(a0)
     104:	00279793          	slli	a5,a5,0x2
     108:	00002717          	auipc	a4,0x2
     10c:	a4070713          	addi	a4,a4,-1472 # 1b48 <malloc+0x294>
     110:	00e787b3          	add	a5,a5,a4
     114:	0007a783          	lw	a5,0(a5)
     118:	00e787b3          	add	a5,a5,a4
     11c:	00078067          	jr	a5
     120:	00913c23          	sd	s1,24(sp)
    exit(1);
     124:	00100513          	li	a0,1
     128:	0a8010ef          	jal	11d0 <exit>
    panic("runcmd");
     12c:	00002517          	auipc	a0,0x2
     130:	92450513          	addi	a0,a0,-1756 # 1a50 <malloc+0x19c>
     134:	f41ff0ef          	jal	74 <panic>
    if(ecmd->argv[0] == 0)
     138:	00853503          	ld	a0,8(a0)
     13c:	02050463          	beqz	a0,164 <runcmd+0x8c>
    exec(ecmd->argv[0], ecmd->argv);
     140:	00848593          	addi	a1,s1,8
     144:	0e0010ef          	jal	1224 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     148:	0084b603          	ld	a2,8(s1)
     14c:	00002597          	auipc	a1,0x2
     150:	90c58593          	addi	a1,a1,-1780 # 1a58 <malloc+0x1a4>
     154:	00200513          	li	a0,2
     158:	618010ef          	jal	1770 <fprintf>
  exit(0);
     15c:	00000513          	li	a0,0
     160:	070010ef          	jal	11d0 <exit>
      exit(1);
     164:	00100513          	li	a0,1
     168:	068010ef          	jal	11d0 <exit>
    close(rcmd->fd);
     16c:	02452503          	lw	a0,36(a0)
     170:	09c010ef          	jal	120c <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     174:	0204a583          	lw	a1,32(s1)
     178:	0104b503          	ld	a0,16(s1)
     17c:	0b4010ef          	jal	1230 <open>
     180:	00054663          	bltz	a0,18c <runcmd+0xb4>
    runcmd(rcmd->cmd);
     184:	0084b503          	ld	a0,8(s1)
     188:	f51ff0ef          	jal	d8 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     18c:	0104b603          	ld	a2,16(s1)
     190:	00002597          	auipc	a1,0x2
     194:	8d858593          	addi	a1,a1,-1832 # 1a68 <malloc+0x1b4>
     198:	00200513          	li	a0,2
     19c:	5d4010ef          	jal	1770 <fprintf>
      exit(1);
     1a0:	00100513          	li	a0,1
     1a4:	02c010ef          	jal	11d0 <exit>
    if(fork1() == 0)
     1a8:	ef9ff0ef          	jal	a0 <fork1>
     1ac:	00051663          	bnez	a0,1b8 <runcmd+0xe0>
      runcmd(lcmd->left);
     1b0:	0084b503          	ld	a0,8(s1)
     1b4:	f25ff0ef          	jal	d8 <runcmd>
    wait(0);
     1b8:	00000513          	li	a0,0
     1bc:	020010ef          	jal	11dc <wait>
    runcmd(lcmd->right);
     1c0:	0104b503          	ld	a0,16(s1)
     1c4:	f15ff0ef          	jal	d8 <runcmd>
    if(pipe(p) < 0)
     1c8:	fd840513          	addi	a0,s0,-40
     1cc:	01c010ef          	jal	11e8 <pipe>
     1d0:	02054a63          	bltz	a0,204 <runcmd+0x12c>
    if(fork1() == 0){
     1d4:	ecdff0ef          	jal	a0 <fork1>
     1d8:	02051c63          	bnez	a0,210 <runcmd+0x138>
      close(1);
     1dc:	00100513          	li	a0,1
     1e0:	02c010ef          	jal	120c <close>
      dup(p[1]);
     1e4:	fdc42503          	lw	a0,-36(s0)
     1e8:	09c010ef          	jal	1284 <dup>
      close(p[0]);
     1ec:	fd842503          	lw	a0,-40(s0)
     1f0:	01c010ef          	jal	120c <close>
      close(p[1]);
     1f4:	fdc42503          	lw	a0,-36(s0)
     1f8:	014010ef          	jal	120c <close>
      runcmd(pcmd->left);
     1fc:	0084b503          	ld	a0,8(s1)
     200:	ed9ff0ef          	jal	d8 <runcmd>
      panic("pipe");
     204:	00002517          	auipc	a0,0x2
     208:	87450513          	addi	a0,a0,-1932 # 1a78 <malloc+0x1c4>
     20c:	e69ff0ef          	jal	74 <panic>
    if(fork1() == 0){
     210:	e91ff0ef          	jal	a0 <fork1>
     214:	02051463          	bnez	a0,23c <runcmd+0x164>
      close(0);
     218:	7f5000ef          	jal	120c <close>
      dup(p[0]);
     21c:	fd842503          	lw	a0,-40(s0)
     220:	064010ef          	jal	1284 <dup>
      close(p[0]);
     224:	fd842503          	lw	a0,-40(s0)
     228:	7e5000ef          	jal	120c <close>
      close(p[1]);
     22c:	fdc42503          	lw	a0,-36(s0)
     230:	7dd000ef          	jal	120c <close>
      runcmd(pcmd->right);
     234:	0104b503          	ld	a0,16(s1)
     238:	ea1ff0ef          	jal	d8 <runcmd>
    close(p[0]);
     23c:	fd842503          	lw	a0,-40(s0)
     240:	7cd000ef          	jal	120c <close>
    close(p[1]);
     244:	fdc42503          	lw	a0,-36(s0)
     248:	7c5000ef          	jal	120c <close>
    wait(0);
     24c:	00000513          	li	a0,0
     250:	78d000ef          	jal	11dc <wait>
    wait(0);
     254:	00000513          	li	a0,0
     258:	785000ef          	jal	11dc <wait>
    break;
     25c:	f01ff06f          	j	15c <runcmd+0x84>
    if(fork1() == 0)
     260:	e41ff0ef          	jal	a0 <fork1>
     264:	ee051ce3          	bnez	a0,15c <runcmd+0x84>
      runcmd(bcmd->cmd);
     268:	0084b503          	ld	a0,8(s1)
     26c:	e6dff0ef          	jal	d8 <runcmd>

0000000000000270 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     270:	fe010113          	addi	sp,sp,-32
     274:	00113c23          	sd	ra,24(sp)
     278:	00813823          	sd	s0,16(sp)
     27c:	00913423          	sd	s1,8(sp)
     280:	02010413          	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     284:	0a800513          	li	a0,168
     288:	62c010ef          	jal	18b4 <malloc>
     28c:	00050493          	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     290:	0a800613          	li	a2,168
     294:	00000593          	li	a1,0
     298:	439000ef          	jal	ed0 <memset>
  cmd->type = EXEC;
     29c:	00100793          	li	a5,1
     2a0:	00f4a023          	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2a4:	00048513          	mv	a0,s1
     2a8:	01813083          	ld	ra,24(sp)
     2ac:	01013403          	ld	s0,16(sp)
     2b0:	00813483          	ld	s1,8(sp)
     2b4:	02010113          	addi	sp,sp,32
     2b8:	00008067          	ret

00000000000002bc <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2bc:	fc010113          	addi	sp,sp,-64
     2c0:	02113c23          	sd	ra,56(sp)
     2c4:	02813823          	sd	s0,48(sp)
     2c8:	02913423          	sd	s1,40(sp)
     2cc:	03213023          	sd	s2,32(sp)
     2d0:	01313c23          	sd	s3,24(sp)
     2d4:	01413823          	sd	s4,16(sp)
     2d8:	01513423          	sd	s5,8(sp)
     2dc:	01613023          	sd	s6,0(sp)
     2e0:	04010413          	addi	s0,sp,64
     2e4:	00050b13          	mv	s6,a0
     2e8:	00058a93          	mv	s5,a1
     2ec:	00060a13          	mv	s4,a2
     2f0:	00068993          	mv	s3,a3
     2f4:	00070913          	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2f8:	02800513          	li	a0,40
     2fc:	5b8010ef          	jal	18b4 <malloc>
     300:	00050493          	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     304:	02800613          	li	a2,40
     308:	00000593          	li	a1,0
     30c:	3c5000ef          	jal	ed0 <memset>
  cmd->type = REDIR;
     310:	00200793          	li	a5,2
     314:	00f4a023          	sw	a5,0(s1)
  cmd->cmd = subcmd;
     318:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     31c:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     320:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     324:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     328:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     32c:	00048513          	mv	a0,s1
     330:	03813083          	ld	ra,56(sp)
     334:	03013403          	ld	s0,48(sp)
     338:	02813483          	ld	s1,40(sp)
     33c:	02013903          	ld	s2,32(sp)
     340:	01813983          	ld	s3,24(sp)
     344:	01013a03          	ld	s4,16(sp)
     348:	00813a83          	ld	s5,8(sp)
     34c:	00013b03          	ld	s6,0(sp)
     350:	04010113          	addi	sp,sp,64
     354:	00008067          	ret

0000000000000358 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     358:	fd010113          	addi	sp,sp,-48
     35c:	02113423          	sd	ra,40(sp)
     360:	02813023          	sd	s0,32(sp)
     364:	00913c23          	sd	s1,24(sp)
     368:	01213823          	sd	s2,16(sp)
     36c:	01313423          	sd	s3,8(sp)
     370:	03010413          	addi	s0,sp,48
     374:	00050993          	mv	s3,a0
     378:	00058913          	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     37c:	01800513          	li	a0,24
     380:	534010ef          	jal	18b4 <malloc>
     384:	00050493          	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     388:	01800613          	li	a2,24
     38c:	00000593          	li	a1,0
     390:	341000ef          	jal	ed0 <memset>
  cmd->type = PIPE;
     394:	00300793          	li	a5,3
     398:	00f4a023          	sw	a5,0(s1)
  cmd->left = left;
     39c:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     3a0:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     3a4:	00048513          	mv	a0,s1
     3a8:	02813083          	ld	ra,40(sp)
     3ac:	02013403          	ld	s0,32(sp)
     3b0:	01813483          	ld	s1,24(sp)
     3b4:	01013903          	ld	s2,16(sp)
     3b8:	00813983          	ld	s3,8(sp)
     3bc:	03010113          	addi	sp,sp,48
     3c0:	00008067          	ret

00000000000003c4 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     3c4:	fd010113          	addi	sp,sp,-48
     3c8:	02113423          	sd	ra,40(sp)
     3cc:	02813023          	sd	s0,32(sp)
     3d0:	00913c23          	sd	s1,24(sp)
     3d4:	01213823          	sd	s2,16(sp)
     3d8:	01313423          	sd	s3,8(sp)
     3dc:	03010413          	addi	s0,sp,48
     3e0:	00050993          	mv	s3,a0
     3e4:	00058913          	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3e8:	01800513          	li	a0,24
     3ec:	4c8010ef          	jal	18b4 <malloc>
     3f0:	00050493          	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3f4:	01800613          	li	a2,24
     3f8:	00000593          	li	a1,0
     3fc:	2d5000ef          	jal	ed0 <memset>
  cmd->type = LIST;
     400:	00400793          	li	a5,4
     404:	00f4a023          	sw	a5,0(s1)
  cmd->left = left;
     408:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     40c:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     410:	00048513          	mv	a0,s1
     414:	02813083          	ld	ra,40(sp)
     418:	02013403          	ld	s0,32(sp)
     41c:	01813483          	ld	s1,24(sp)
     420:	01013903          	ld	s2,16(sp)
     424:	00813983          	ld	s3,8(sp)
     428:	03010113          	addi	sp,sp,48
     42c:	00008067          	ret

0000000000000430 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     430:	fe010113          	addi	sp,sp,-32
     434:	00113c23          	sd	ra,24(sp)
     438:	00813823          	sd	s0,16(sp)
     43c:	00913423          	sd	s1,8(sp)
     440:	01213023          	sd	s2,0(sp)
     444:	02010413          	addi	s0,sp,32
     448:	00050913          	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     44c:	01000513          	li	a0,16
     450:	464010ef          	jal	18b4 <malloc>
     454:	00050493          	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     458:	01000613          	li	a2,16
     45c:	00000593          	li	a1,0
     460:	271000ef          	jal	ed0 <memset>
  cmd->type = BACK;
     464:	00500793          	li	a5,5
     468:	00f4a023          	sw	a5,0(s1)
  cmd->cmd = subcmd;
     46c:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     470:	00048513          	mv	a0,s1
     474:	01813083          	ld	ra,24(sp)
     478:	01013403          	ld	s0,16(sp)
     47c:	00813483          	ld	s1,8(sp)
     480:	00013903          	ld	s2,0(sp)
     484:	02010113          	addi	sp,sp,32
     488:	00008067          	ret

000000000000048c <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     48c:	fc010113          	addi	sp,sp,-64
     490:	02113c23          	sd	ra,56(sp)
     494:	02813823          	sd	s0,48(sp)
     498:	02913423          	sd	s1,40(sp)
     49c:	03213023          	sd	s2,32(sp)
     4a0:	01313c23          	sd	s3,24(sp)
     4a4:	01413823          	sd	s4,16(sp)
     4a8:	01513423          	sd	s5,8(sp)
     4ac:	01613023          	sd	s6,0(sp)
     4b0:	04010413          	addi	s0,sp,64
     4b4:	00050a13          	mv	s4,a0
     4b8:	00058913          	mv	s2,a1
     4bc:	00060a93          	mv	s5,a2
     4c0:	00068b13          	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     4c4:	00053483          	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     4c8:	00002997          	auipc	s3,0x2
     4cc:	b4098993          	addi	s3,s3,-1216 # 2008 <whitespace>
     4d0:	02b4f063          	bgeu	s1,a1,4f0 <gettoken+0x64>
     4d4:	0004c583          	lbu	a1,0(s1)
     4d8:	00098513          	mv	a0,s3
     4dc:	22d000ef          	jal	f08 <strchr>
     4e0:	00050863          	beqz	a0,4f0 <gettoken+0x64>
    s++;
     4e4:	00148493          	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     4e8:	fe9916e3          	bne	s2,s1,4d4 <gettoken+0x48>
     4ec:	00090493          	mv	s1,s2
  if(q)
     4f0:	000a8463          	beqz	s5,4f8 <gettoken+0x6c>
    *q = s;
     4f4:	009ab023          	sd	s1,0(s5)
  ret = *s;
     4f8:	0004c783          	lbu	a5,0(s1)
     4fc:	00078a9b          	sext.w	s5,a5
  switch(*s){
     500:	03c00713          	li	a4,60
     504:	08f76663          	bltu	a4,a5,590 <gettoken+0x104>
     508:	03a00713          	li	a4,58
     50c:	02f76063          	bltu	a4,a5,52c <gettoken+0xa0>
     510:	02078063          	beqz	a5,530 <gettoken+0xa4>
     514:	02600713          	li	a4,38
     518:	00e78a63          	beq	a5,a4,52c <gettoken+0xa0>
     51c:	fd87879b          	addiw	a5,a5,-40
     520:	0ff7f793          	zext.b	a5,a5
     524:	00100713          	li	a4,1
     528:	08f76e63          	bltu	a4,a5,5c4 <gettoken+0x138>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     52c:	00148493          	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     530:	000b0463          	beqz	s6,538 <gettoken+0xac>
    *eq = s;
     534:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     538:	00002997          	auipc	s3,0x2
     53c:	ad098993          	addi	s3,s3,-1328 # 2008 <whitespace>
     540:	0324f063          	bgeu	s1,s2,560 <gettoken+0xd4>
     544:	0004c583          	lbu	a1,0(s1)
     548:	00098513          	mv	a0,s3
     54c:	1bd000ef          	jal	f08 <strchr>
     550:	00050863          	beqz	a0,560 <gettoken+0xd4>
    s++;
     554:	00148493          	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     558:	fe9916e3          	bne	s2,s1,544 <gettoken+0xb8>
     55c:	00090493          	mv	s1,s2
  *ps = s;
     560:	009a3023          	sd	s1,0(s4)
  return ret;
}
     564:	000a8513          	mv	a0,s5
     568:	03813083          	ld	ra,56(sp)
     56c:	03013403          	ld	s0,48(sp)
     570:	02813483          	ld	s1,40(sp)
     574:	02013903          	ld	s2,32(sp)
     578:	01813983          	ld	s3,24(sp)
     57c:	01013a03          	ld	s4,16(sp)
     580:	00813a83          	ld	s5,8(sp)
     584:	00013b03          	ld	s6,0(sp)
     588:	04010113          	addi	sp,sp,64
     58c:	00008067          	ret
  switch(*s){
     590:	03e00713          	li	a4,62
     594:	02e79463          	bne	a5,a4,5bc <gettoken+0x130>
    s++;
     598:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     59c:	0014c703          	lbu	a4,1(s1)
     5a0:	03e00793          	li	a5,62
      s++;
     5a4:	00248493          	addi	s1,s1,2
      ret = '+';
     5a8:	02b00a93          	li	s5,43
    if(*s == '>'){
     5ac:	f8f702e3          	beq	a4,a5,530 <gettoken+0xa4>
    s++;
     5b0:	00068493          	mv	s1,a3
  ret = *s;
     5b4:	03e00a93          	li	s5,62
     5b8:	f79ff06f          	j	530 <gettoken+0xa4>
  switch(*s){
     5bc:	07c00713          	li	a4,124
     5c0:	f6e786e3          	beq	a5,a4,52c <gettoken+0xa0>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5c4:	00002997          	auipc	s3,0x2
     5c8:	a4498993          	addi	s3,s3,-1468 # 2008 <whitespace>
     5cc:	00002a97          	auipc	s5,0x2
     5d0:	a34a8a93          	addi	s5,s5,-1484 # 2000 <symbols>
     5d4:	0524f663          	bgeu	s1,s2,620 <gettoken+0x194>
     5d8:	0004c583          	lbu	a1,0(s1)
     5dc:	00098513          	mv	a0,s3
     5e0:	129000ef          	jal	f08 <strchr>
     5e4:	02051a63          	bnez	a0,618 <gettoken+0x18c>
     5e8:	0004c583          	lbu	a1,0(s1)
     5ec:	000a8513          	mv	a0,s5
     5f0:	119000ef          	jal	f08 <strchr>
     5f4:	00051e63          	bnez	a0,610 <gettoken+0x184>
      s++;
     5f8:	00148493          	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5fc:	fc991ee3          	bne	s2,s1,5d8 <gettoken+0x14c>
  if(eq)
     600:	00090493          	mv	s1,s2
    ret = 'a';
     604:	06100a93          	li	s5,97
  if(eq)
     608:	f20b16e3          	bnez	s6,534 <gettoken+0xa8>
     60c:	f55ff06f          	j	560 <gettoken+0xd4>
    ret = 'a';
     610:	06100a93          	li	s5,97
     614:	f1dff06f          	j	530 <gettoken+0xa4>
     618:	06100a93          	li	s5,97
     61c:	f15ff06f          	j	530 <gettoken+0xa4>
     620:	06100a93          	li	s5,97
  if(eq)
     624:	f00b18e3          	bnez	s6,534 <gettoken+0xa8>
     628:	f39ff06f          	j	560 <gettoken+0xd4>

000000000000062c <peek>:

int
peek(char **ps, char *es, char *toks)
{
     62c:	fc010113          	addi	sp,sp,-64
     630:	02113c23          	sd	ra,56(sp)
     634:	02813823          	sd	s0,48(sp)
     638:	02913423          	sd	s1,40(sp)
     63c:	03213023          	sd	s2,32(sp)
     640:	01313c23          	sd	s3,24(sp)
     644:	01413823          	sd	s4,16(sp)
     648:	01513423          	sd	s5,8(sp)
     64c:	04010413          	addi	s0,sp,64
     650:	00050a13          	mv	s4,a0
     654:	00058913          	mv	s2,a1
     658:	00060a93          	mv	s5,a2
  char *s;

  s = *ps;
     65c:	00053483          	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     660:	00002997          	auipc	s3,0x2
     664:	9a898993          	addi	s3,s3,-1624 # 2008 <whitespace>
     668:	02b4f063          	bgeu	s1,a1,688 <peek+0x5c>
     66c:	0004c583          	lbu	a1,0(s1)
     670:	00098513          	mv	a0,s3
     674:	095000ef          	jal	f08 <strchr>
     678:	00050863          	beqz	a0,688 <peek+0x5c>
    s++;
     67c:	00148493          	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     680:	fe9916e3          	bne	s2,s1,66c <peek+0x40>
     684:	00090493          	mv	s1,s2
  *ps = s;
     688:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     68c:	0004c583          	lbu	a1,0(s1)
     690:	00000513          	li	a0,0
     694:	02059463          	bnez	a1,6bc <peek+0x90>
}
     698:	03813083          	ld	ra,56(sp)
     69c:	03013403          	ld	s0,48(sp)
     6a0:	02813483          	ld	s1,40(sp)
     6a4:	02013903          	ld	s2,32(sp)
     6a8:	01813983          	ld	s3,24(sp)
     6ac:	01013a03          	ld	s4,16(sp)
     6b0:	00813a83          	ld	s5,8(sp)
     6b4:	04010113          	addi	sp,sp,64
     6b8:	00008067          	ret
  return *s && strchr(toks, *s);
     6bc:	000a8513          	mv	a0,s5
     6c0:	049000ef          	jal	f08 <strchr>
     6c4:	00a03533          	snez	a0,a0
     6c8:	fd1ff06f          	j	698 <peek+0x6c>

00000000000006cc <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     6cc:	fa010113          	addi	sp,sp,-96
     6d0:	04113c23          	sd	ra,88(sp)
     6d4:	04813823          	sd	s0,80(sp)
     6d8:	04913423          	sd	s1,72(sp)
     6dc:	05213023          	sd	s2,64(sp)
     6e0:	03313c23          	sd	s3,56(sp)
     6e4:	03413823          	sd	s4,48(sp)
     6e8:	03513423          	sd	s5,40(sp)
     6ec:	03613023          	sd	s6,32(sp)
     6f0:	01713c23          	sd	s7,24(sp)
     6f4:	06010413          	addi	s0,sp,96
     6f8:	00050a13          	mv	s4,a0
     6fc:	00058993          	mv	s3,a1
     700:	00060913          	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     704:	00001a97          	auipc	s5,0x1
     708:	39ca8a93          	addi	s5,s5,924 # 1aa0 <malloc+0x1ec>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     70c:	06100b13          	li	s6,97
      panic("missing file for redirection");
    switch(tok){
     710:	03c00b93          	li	s7,60
  while(peek(ps, es, "<>")){
     714:	02c0006f          	j	740 <parseredirs+0x74>
      panic("missing file for redirection");
     718:	00001517          	auipc	a0,0x1
     71c:	36850513          	addi	a0,a0,872 # 1a80 <malloc+0x1cc>
     720:	955ff0ef          	jal	74 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     724:	00000713          	li	a4,0
     728:	00000693          	li	a3,0
     72c:	fa043603          	ld	a2,-96(s0)
     730:	fa843583          	ld	a1,-88(s0)
     734:	000a0513          	mv	a0,s4
     738:	b85ff0ef          	jal	2bc <redircmd>
     73c:	00050a13          	mv	s4,a0
  while(peek(ps, es, "<>")){
     740:	000a8613          	mv	a2,s5
     744:	00090593          	mv	a1,s2
     748:	00098513          	mv	a0,s3
     74c:	ee1ff0ef          	jal	62c <peek>
     750:	08050463          	beqz	a0,7d8 <parseredirs+0x10c>
    tok = gettoken(ps, es, 0, 0);
     754:	00000693          	li	a3,0
     758:	00000613          	li	a2,0
     75c:	00090593          	mv	a1,s2
     760:	00098513          	mv	a0,s3
     764:	d29ff0ef          	jal	48c <gettoken>
     768:	00050493          	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     76c:	fa040693          	addi	a3,s0,-96
     770:	fa840613          	addi	a2,s0,-88
     774:	00090593          	mv	a1,s2
     778:	00098513          	mv	a0,s3
     77c:	d11ff0ef          	jal	48c <gettoken>
     780:	f9651ce3          	bne	a0,s6,718 <parseredirs+0x4c>
    switch(tok){
     784:	fb7480e3          	beq	s1,s7,724 <parseredirs+0x58>
     788:	03e00793          	li	a5,62
     78c:	02f48663          	beq	s1,a5,7b8 <parseredirs+0xec>
     790:	02b00793          	li	a5,43
     794:	faf496e3          	bne	s1,a5,740 <parseredirs+0x74>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     798:	00100713          	li	a4,1
     79c:	20100693          	li	a3,513
     7a0:	fa043603          	ld	a2,-96(s0)
     7a4:	fa843583          	ld	a1,-88(s0)
     7a8:	000a0513          	mv	a0,s4
     7ac:	b11ff0ef          	jal	2bc <redircmd>
     7b0:	00050a13          	mv	s4,a0
      break;
     7b4:	f8dff06f          	j	740 <parseredirs+0x74>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     7b8:	00100713          	li	a4,1
     7bc:	60100693          	li	a3,1537
     7c0:	fa043603          	ld	a2,-96(s0)
     7c4:	fa843583          	ld	a1,-88(s0)
     7c8:	000a0513          	mv	a0,s4
     7cc:	af1ff0ef          	jal	2bc <redircmd>
     7d0:	00050a13          	mv	s4,a0
      break;
     7d4:	f6dff06f          	j	740 <parseredirs+0x74>
    }
  }
  return cmd;
}
     7d8:	000a0513          	mv	a0,s4
     7dc:	05813083          	ld	ra,88(sp)
     7e0:	05013403          	ld	s0,80(sp)
     7e4:	04813483          	ld	s1,72(sp)
     7e8:	04013903          	ld	s2,64(sp)
     7ec:	03813983          	ld	s3,56(sp)
     7f0:	03013a03          	ld	s4,48(sp)
     7f4:	02813a83          	ld	s5,40(sp)
     7f8:	02013b03          	ld	s6,32(sp)
     7fc:	01813b83          	ld	s7,24(sp)
     800:	06010113          	addi	sp,sp,96
     804:	00008067          	ret

0000000000000808 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     808:	f9010113          	addi	sp,sp,-112
     80c:	06113423          	sd	ra,104(sp)
     810:	06813023          	sd	s0,96(sp)
     814:	04913c23          	sd	s1,88(sp)
     818:	05413023          	sd	s4,64(sp)
     81c:	03513c23          	sd	s5,56(sp)
     820:	07010413          	addi	s0,sp,112
     824:	00050a13          	mv	s4,a0
     828:	00058a93          	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     82c:	00001617          	auipc	a2,0x1
     830:	27c60613          	addi	a2,a2,636 # 1aa8 <malloc+0x1f4>
     834:	df9ff0ef          	jal	62c <peek>
     838:	04051863          	bnez	a0,888 <parseexec+0x80>
     83c:	05213823          	sd	s2,80(sp)
     840:	05313423          	sd	s3,72(sp)
     844:	03613823          	sd	s6,48(sp)
     848:	03713423          	sd	s7,40(sp)
     84c:	03813023          	sd	s8,32(sp)
     850:	01913c23          	sd	s9,24(sp)
     854:	00050993          	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     858:	a19ff0ef          	jal	270 <execcmd>
     85c:	00050c13          	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     860:	000a8613          	mv	a2,s5
     864:	000a0593          	mv	a1,s4
     868:	e65ff0ef          	jal	6cc <parseredirs>
     86c:	00050493          	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     870:	008c0913          	addi	s2,s8,8
     874:	00001b17          	auipc	s6,0x1
     878:	254b0b13          	addi	s6,s6,596 # 1ac8 <malloc+0x214>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     87c:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     880:	00a00b93          	li	s7,10
  while(!peek(ps, es, "|)&;")){
     884:	0540006f          	j	8d8 <parseexec+0xd0>
    return parseblock(ps, es);
     888:	000a8593          	mv	a1,s5
     88c:	000a0513          	mv	a0,s4
     890:	244000ef          	jal	ad4 <parseblock>
     894:	00050493          	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     898:	00048513          	mv	a0,s1
     89c:	06813083          	ld	ra,104(sp)
     8a0:	06013403          	ld	s0,96(sp)
     8a4:	05813483          	ld	s1,88(sp)
     8a8:	04013a03          	ld	s4,64(sp)
     8ac:	03813a83          	ld	s5,56(sp)
     8b0:	07010113          	addi	sp,sp,112
     8b4:	00008067          	ret
      panic("syntax");
     8b8:	00001517          	auipc	a0,0x1
     8bc:	1f850513          	addi	a0,a0,504 # 1ab0 <malloc+0x1fc>
     8c0:	fb4ff0ef          	jal	74 <panic>
    ret = parseredirs(ret, ps, es);
     8c4:	000a8613          	mv	a2,s5
     8c8:	000a0593          	mv	a1,s4
     8cc:	00048513          	mv	a0,s1
     8d0:	dfdff0ef          	jal	6cc <parseredirs>
     8d4:	00050493          	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     8d8:	000b0613          	mv	a2,s6
     8dc:	000a8593          	mv	a1,s5
     8e0:	000a0513          	mv	a0,s4
     8e4:	d49ff0ef          	jal	62c <peek>
     8e8:	04051463          	bnez	a0,930 <parseexec+0x128>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     8ec:	f9040693          	addi	a3,s0,-112
     8f0:	f9840613          	addi	a2,s0,-104
     8f4:	000a8593          	mv	a1,s5
     8f8:	000a0513          	mv	a0,s4
     8fc:	b91ff0ef          	jal	48c <gettoken>
     900:	02050863          	beqz	a0,930 <parseexec+0x128>
    if(tok != 'a')
     904:	fb951ae3          	bne	a0,s9,8b8 <parseexec+0xb0>
    cmd->argv[argc] = q;
     908:	f9843783          	ld	a5,-104(s0)
     90c:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     910:	f9043783          	ld	a5,-112(s0)
     914:	04f93823          	sd	a5,80(s2)
    argc++;
     918:	0019899b          	addiw	s3,s3,1
    if(argc >= MAXARGS)
     91c:	00890913          	addi	s2,s2,8
     920:	fb7992e3          	bne	s3,s7,8c4 <parseexec+0xbc>
      panic("too many args");
     924:	00001517          	auipc	a0,0x1
     928:	19450513          	addi	a0,a0,404 # 1ab8 <malloc+0x204>
     92c:	f48ff0ef          	jal	74 <panic>
  cmd->argv[argc] = 0;
     930:	00399993          	slli	s3,s3,0x3
     934:	013c0c33          	add	s8,s8,s3
     938:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     93c:	040c3c23          	sd	zero,88(s8)
     940:	05013903          	ld	s2,80(sp)
     944:	04813983          	ld	s3,72(sp)
     948:	03013b03          	ld	s6,48(sp)
     94c:	02813b83          	ld	s7,40(sp)
     950:	02013c03          	ld	s8,32(sp)
     954:	01813c83          	ld	s9,24(sp)
  return ret;
     958:	f41ff06f          	j	898 <parseexec+0x90>

000000000000095c <parsepipe>:
{
     95c:	fd010113          	addi	sp,sp,-48
     960:	02113423          	sd	ra,40(sp)
     964:	02813023          	sd	s0,32(sp)
     968:	00913c23          	sd	s1,24(sp)
     96c:	01213823          	sd	s2,16(sp)
     970:	01313423          	sd	s3,8(sp)
     974:	03010413          	addi	s0,sp,48
     978:	00050913          	mv	s2,a0
     97c:	00058993          	mv	s3,a1
  cmd = parseexec(ps, es);
     980:	e89ff0ef          	jal	808 <parseexec>
     984:	00050493          	mv	s1,a0
  if(peek(ps, es, "|")){
     988:	00001617          	auipc	a2,0x1
     98c:	14860613          	addi	a2,a2,328 # 1ad0 <malloc+0x21c>
     990:	00098593          	mv	a1,s3
     994:	00090513          	mv	a0,s2
     998:	c95ff0ef          	jal	62c <peek>
     99c:	02051263          	bnez	a0,9c0 <parsepipe+0x64>
}
     9a0:	00048513          	mv	a0,s1
     9a4:	02813083          	ld	ra,40(sp)
     9a8:	02013403          	ld	s0,32(sp)
     9ac:	01813483          	ld	s1,24(sp)
     9b0:	01013903          	ld	s2,16(sp)
     9b4:	00813983          	ld	s3,8(sp)
     9b8:	03010113          	addi	sp,sp,48
     9bc:	00008067          	ret
    gettoken(ps, es, 0, 0);
     9c0:	00000693          	li	a3,0
     9c4:	00000613          	li	a2,0
     9c8:	00098593          	mv	a1,s3
     9cc:	00090513          	mv	a0,s2
     9d0:	abdff0ef          	jal	48c <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     9d4:	00098593          	mv	a1,s3
     9d8:	00090513          	mv	a0,s2
     9dc:	f81ff0ef          	jal	95c <parsepipe>
     9e0:	00050593          	mv	a1,a0
     9e4:	00048513          	mv	a0,s1
     9e8:	971ff0ef          	jal	358 <pipecmd>
     9ec:	00050493          	mv	s1,a0
  return cmd;
     9f0:	fb1ff06f          	j	9a0 <parsepipe+0x44>

00000000000009f4 <parseline>:
{
     9f4:	fd010113          	addi	sp,sp,-48
     9f8:	02113423          	sd	ra,40(sp)
     9fc:	02813023          	sd	s0,32(sp)
     a00:	00913c23          	sd	s1,24(sp)
     a04:	01213823          	sd	s2,16(sp)
     a08:	01313423          	sd	s3,8(sp)
     a0c:	01413023          	sd	s4,0(sp)
     a10:	03010413          	addi	s0,sp,48
     a14:	00050913          	mv	s2,a0
     a18:	00058993          	mv	s3,a1
  cmd = parsepipe(ps, es);
     a1c:	f41ff0ef          	jal	95c <parsepipe>
     a20:	00050493          	mv	s1,a0
  while(peek(ps, es, "&")){
     a24:	00001a17          	auipc	s4,0x1
     a28:	0b4a0a13          	addi	s4,s4,180 # 1ad8 <malloc+0x224>
     a2c:	0240006f          	j	a50 <parseline+0x5c>
    gettoken(ps, es, 0, 0);
     a30:	00000693          	li	a3,0
     a34:	00000613          	li	a2,0
     a38:	00098593          	mv	a1,s3
     a3c:	00090513          	mv	a0,s2
     a40:	a4dff0ef          	jal	48c <gettoken>
    cmd = backcmd(cmd);
     a44:	00048513          	mv	a0,s1
     a48:	9e9ff0ef          	jal	430 <backcmd>
     a4c:	00050493          	mv	s1,a0
  while(peek(ps, es, "&")){
     a50:	000a0613          	mv	a2,s4
     a54:	00098593          	mv	a1,s3
     a58:	00090513          	mv	a0,s2
     a5c:	bd1ff0ef          	jal	62c <peek>
     a60:	fc0518e3          	bnez	a0,a30 <parseline+0x3c>
  if(peek(ps, es, ";")){
     a64:	00001617          	auipc	a2,0x1
     a68:	07c60613          	addi	a2,a2,124 # 1ae0 <malloc+0x22c>
     a6c:	00098593          	mv	a1,s3
     a70:	00090513          	mv	a0,s2
     a74:	bb9ff0ef          	jal	62c <peek>
     a78:	02051463          	bnez	a0,aa0 <parseline+0xac>
}
     a7c:	00048513          	mv	a0,s1
     a80:	02813083          	ld	ra,40(sp)
     a84:	02013403          	ld	s0,32(sp)
     a88:	01813483          	ld	s1,24(sp)
     a8c:	01013903          	ld	s2,16(sp)
     a90:	00813983          	ld	s3,8(sp)
     a94:	00013a03          	ld	s4,0(sp)
     a98:	03010113          	addi	sp,sp,48
     a9c:	00008067          	ret
    gettoken(ps, es, 0, 0);
     aa0:	00000693          	li	a3,0
     aa4:	00000613          	li	a2,0
     aa8:	00098593          	mv	a1,s3
     aac:	00090513          	mv	a0,s2
     ab0:	9ddff0ef          	jal	48c <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     ab4:	00098593          	mv	a1,s3
     ab8:	00090513          	mv	a0,s2
     abc:	f39ff0ef          	jal	9f4 <parseline>
     ac0:	00050593          	mv	a1,a0
     ac4:	00048513          	mv	a0,s1
     ac8:	8fdff0ef          	jal	3c4 <listcmd>
     acc:	00050493          	mv	s1,a0
  return cmd;
     ad0:	fadff06f          	j	a7c <parseline+0x88>

0000000000000ad4 <parseblock>:
{
     ad4:	fd010113          	addi	sp,sp,-48
     ad8:	02113423          	sd	ra,40(sp)
     adc:	02813023          	sd	s0,32(sp)
     ae0:	00913c23          	sd	s1,24(sp)
     ae4:	01213823          	sd	s2,16(sp)
     ae8:	01313423          	sd	s3,8(sp)
     aec:	03010413          	addi	s0,sp,48
     af0:	00050493          	mv	s1,a0
     af4:	00058913          	mv	s2,a1
  if(!peek(ps, es, "("))
     af8:	00001617          	auipc	a2,0x1
     afc:	fb060613          	addi	a2,a2,-80 # 1aa8 <malloc+0x1f4>
     b00:	b2dff0ef          	jal	62c <peek>
     b04:	08050063          	beqz	a0,b84 <parseblock+0xb0>
  gettoken(ps, es, 0, 0);
     b08:	00000693          	li	a3,0
     b0c:	00000613          	li	a2,0
     b10:	00090593          	mv	a1,s2
     b14:	00048513          	mv	a0,s1
     b18:	975ff0ef          	jal	48c <gettoken>
  cmd = parseline(ps, es);
     b1c:	00090593          	mv	a1,s2
     b20:	00048513          	mv	a0,s1
     b24:	ed1ff0ef          	jal	9f4 <parseline>
     b28:	00050993          	mv	s3,a0
  if(!peek(ps, es, ")"))
     b2c:	00001617          	auipc	a2,0x1
     b30:	fcc60613          	addi	a2,a2,-52 # 1af8 <malloc+0x244>
     b34:	00090593          	mv	a1,s2
     b38:	00048513          	mv	a0,s1
     b3c:	af1ff0ef          	jal	62c <peek>
     b40:	04050863          	beqz	a0,b90 <parseblock+0xbc>
  gettoken(ps, es, 0, 0);
     b44:	00000693          	li	a3,0
     b48:	00000613          	li	a2,0
     b4c:	00090593          	mv	a1,s2
     b50:	00048513          	mv	a0,s1
     b54:	939ff0ef          	jal	48c <gettoken>
  cmd = parseredirs(cmd, ps, es);
     b58:	00090613          	mv	a2,s2
     b5c:	00048593          	mv	a1,s1
     b60:	00098513          	mv	a0,s3
     b64:	b69ff0ef          	jal	6cc <parseredirs>
}
     b68:	02813083          	ld	ra,40(sp)
     b6c:	02013403          	ld	s0,32(sp)
     b70:	01813483          	ld	s1,24(sp)
     b74:	01013903          	ld	s2,16(sp)
     b78:	00813983          	ld	s3,8(sp)
     b7c:	03010113          	addi	sp,sp,48
     b80:	00008067          	ret
    panic("parseblock");
     b84:	00001517          	auipc	a0,0x1
     b88:	f6450513          	addi	a0,a0,-156 # 1ae8 <malloc+0x234>
     b8c:	ce8ff0ef          	jal	74 <panic>
    panic("syntax - missing )");
     b90:	00001517          	auipc	a0,0x1
     b94:	f7050513          	addi	a0,a0,-144 # 1b00 <malloc+0x24c>
     b98:	cdcff0ef          	jal	74 <panic>

0000000000000b9c <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     b9c:	fe010113          	addi	sp,sp,-32
     ba0:	00113c23          	sd	ra,24(sp)
     ba4:	00813823          	sd	s0,16(sp)
     ba8:	00913423          	sd	s1,8(sp)
     bac:	02010413          	addi	s0,sp,32
     bb0:	00050493          	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     bb4:	06050263          	beqz	a0,c18 <nulterminate+0x7c>
    return 0;

  switch(cmd->type){
     bb8:	00052703          	lw	a4,0(a0)
     bbc:	00500793          	li	a5,5
     bc0:	04e7ec63          	bltu	a5,a4,c18 <nulterminate+0x7c>
     bc4:	00056783          	lwu	a5,0(a0)
     bc8:	00279793          	slli	a5,a5,0x2
     bcc:	00001717          	auipc	a4,0x1
     bd0:	f9470713          	addi	a4,a4,-108 # 1b60 <malloc+0x2ac>
     bd4:	00e787b3          	add	a5,a5,a4
     bd8:	0007a783          	lw	a5,0(a5)
     bdc:	00e787b3          	add	a5,a5,a4
     be0:	00078067          	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     be4:	00853783          	ld	a5,8(a0)
     be8:	02078863          	beqz	a5,c18 <nulterminate+0x7c>
     bec:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     bf0:	0487b703          	ld	a4,72(a5)
     bf4:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     bf8:	00878793          	addi	a5,a5,8
     bfc:	ff87b703          	ld	a4,-8(a5)
     c00:	fe0718e3          	bnez	a4,bf0 <nulterminate+0x54>
     c04:	0140006f          	j	c18 <nulterminate+0x7c>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     c08:	00853503          	ld	a0,8(a0)
     c0c:	f91ff0ef          	jal	b9c <nulterminate>
    *rcmd->efile = 0;
     c10:	0184b783          	ld	a5,24(s1)
     c14:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     c18:	00048513          	mv	a0,s1
     c1c:	01813083          	ld	ra,24(sp)
     c20:	01013403          	ld	s0,16(sp)
     c24:	00813483          	ld	s1,8(sp)
     c28:	02010113          	addi	sp,sp,32
     c2c:	00008067          	ret
    nulterminate(pcmd->left);
     c30:	00853503          	ld	a0,8(a0)
     c34:	f69ff0ef          	jal	b9c <nulterminate>
    nulterminate(pcmd->right);
     c38:	0104b503          	ld	a0,16(s1)
     c3c:	f61ff0ef          	jal	b9c <nulterminate>
    break;
     c40:	fd9ff06f          	j	c18 <nulterminate+0x7c>
    nulterminate(lcmd->left);
     c44:	00853503          	ld	a0,8(a0)
     c48:	f55ff0ef          	jal	b9c <nulterminate>
    nulterminate(lcmd->right);
     c4c:	0104b503          	ld	a0,16(s1)
     c50:	f4dff0ef          	jal	b9c <nulterminate>
    break;
     c54:	fc5ff06f          	j	c18 <nulterminate+0x7c>
    nulterminate(bcmd->cmd);
     c58:	00853503          	ld	a0,8(a0)
     c5c:	f41ff0ef          	jal	b9c <nulterminate>
    break;
     c60:	fb9ff06f          	j	c18 <nulterminate+0x7c>

0000000000000c64 <parsecmd>:
{
     c64:	fd010113          	addi	sp,sp,-48
     c68:	02113423          	sd	ra,40(sp)
     c6c:	02813023          	sd	s0,32(sp)
     c70:	00913c23          	sd	s1,24(sp)
     c74:	01213823          	sd	s2,16(sp)
     c78:	03010413          	addi	s0,sp,48
     c7c:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     c80:	00050493          	mv	s1,a0
     c84:	204000ef          	jal	e88 <strlen>
     c88:	02051513          	slli	a0,a0,0x20
     c8c:	02055513          	srli	a0,a0,0x20
     c90:	00a484b3          	add	s1,s1,a0
  cmd = parseline(&s, es);
     c94:	00048593          	mv	a1,s1
     c98:	fd840513          	addi	a0,s0,-40
     c9c:	d59ff0ef          	jal	9f4 <parseline>
     ca0:	00050913          	mv	s2,a0
  peek(&s, es, "");
     ca4:	00001617          	auipc	a2,0x1
     ca8:	d9460613          	addi	a2,a2,-620 # 1a38 <malloc+0x184>
     cac:	00048593          	mv	a1,s1
     cb0:	fd840513          	addi	a0,s0,-40
     cb4:	979ff0ef          	jal	62c <peek>
  if(s != es){
     cb8:	fd843603          	ld	a2,-40(s0)
     cbc:	02961463          	bne	a2,s1,ce4 <parsecmd+0x80>
  nulterminate(cmd);
     cc0:	00090513          	mv	a0,s2
     cc4:	ed9ff0ef          	jal	b9c <nulterminate>
}
     cc8:	00090513          	mv	a0,s2
     ccc:	02813083          	ld	ra,40(sp)
     cd0:	02013403          	ld	s0,32(sp)
     cd4:	01813483          	ld	s1,24(sp)
     cd8:	01013903          	ld	s2,16(sp)
     cdc:	03010113          	addi	sp,sp,48
     ce0:	00008067          	ret
    fprintf(2, "leftovers: %s\n", s);
     ce4:	00001597          	auipc	a1,0x1
     ce8:	e3458593          	addi	a1,a1,-460 # 1b18 <malloc+0x264>
     cec:	00200513          	li	a0,2
     cf0:	281000ef          	jal	1770 <fprintf>
    panic("syntax");
     cf4:	00001517          	auipc	a0,0x1
     cf8:	dbc50513          	addi	a0,a0,-580 # 1ab0 <malloc+0x1fc>
     cfc:	b78ff0ef          	jal	74 <panic>

0000000000000d00 <main>:
{
     d00:	fd010113          	addi	sp,sp,-48
     d04:	02113423          	sd	ra,40(sp)
     d08:	02813023          	sd	s0,32(sp)
     d0c:	00913c23          	sd	s1,24(sp)
     d10:	01213823          	sd	s2,16(sp)
     d14:	01313423          	sd	s3,8(sp)
     d18:	01413023          	sd	s4,0(sp)
     d1c:	03010413          	addi	s0,sp,48
  while((fd = open("console", O_RDWR)) >= 0){
     d20:	00001497          	auipc	s1,0x1
     d24:	e0848493          	addi	s1,s1,-504 # 1b28 <malloc+0x274>
     d28:	00200593          	li	a1,2
     d2c:	00048513          	mv	a0,s1
     d30:	500000ef          	jal	1230 <open>
     d34:	00054863          	bltz	a0,d44 <main+0x44>
    if(fd >= 3){
     d38:	00200793          	li	a5,2
     d3c:	fea7d6e3          	bge	a5,a0,d28 <main+0x28>
      close(fd);
     d40:	4cc000ef          	jal	120c <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     d44:	00001497          	auipc	s1,0x1
     d48:	2dc48493          	addi	s1,s1,732 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     d4c:	06300913          	li	s2,99
     d50:	02000993          	li	s3,32
     d54:	0140006f          	j	d68 <main+0x68>
    if(fork1() == 0)
     d58:	b48ff0ef          	jal	a0 <fork1>
     d5c:	08050463          	beqz	a0,de4 <main+0xe4>
    wait(0);
     d60:	00000513          	li	a0,0
     d64:	478000ef          	jal	11dc <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     d68:	06400593          	li	a1,100
     d6c:	00048513          	mv	a0,s1
     d70:	a90ff0ef          	jal	0 <getcmd>
     d74:	08054063          	bltz	a0,df4 <main+0xf4>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     d78:	0004c783          	lbu	a5,0(s1)
     d7c:	fd279ee3          	bne	a5,s2,d58 <main+0x58>
     d80:	0014c703          	lbu	a4,1(s1)
     d84:	06400793          	li	a5,100
     d88:	fcf718e3          	bne	a4,a5,d58 <main+0x58>
     d8c:	0024c783          	lbu	a5,2(s1)
     d90:	fd3794e3          	bne	a5,s3,d58 <main+0x58>
      buf[strlen(buf)-1] = 0;  // chop \n
     d94:	00001a17          	auipc	s4,0x1
     d98:	28ca0a13          	addi	s4,s4,652 # 2020 <buf.0>
     d9c:	000a0513          	mv	a0,s4
     da0:	0e8000ef          	jal	e88 <strlen>
     da4:	fff5079b          	addiw	a5,a0,-1
     da8:	02079793          	slli	a5,a5,0x20
     dac:	0207d793          	srli	a5,a5,0x20
     db0:	00fa0a33          	add	s4,s4,a5
     db4:	000a0023          	sb	zero,0(s4)
      if(chdir(buf+3) < 0)
     db8:	00001517          	auipc	a0,0x1
     dbc:	26b50513          	addi	a0,a0,619 # 2023 <buf.0+0x3>
     dc0:	4b8000ef          	jal	1278 <chdir>
     dc4:	fa0552e3          	bgez	a0,d68 <main+0x68>
        fprintf(2, "cannot cd %s\n", buf+3);
     dc8:	00001617          	auipc	a2,0x1
     dcc:	25b60613          	addi	a2,a2,603 # 2023 <buf.0+0x3>
     dd0:	00001597          	auipc	a1,0x1
     dd4:	d6058593          	addi	a1,a1,-672 # 1b30 <malloc+0x27c>
     dd8:	00200513          	li	a0,2
     ddc:	195000ef          	jal	1770 <fprintf>
     de0:	f89ff06f          	j	d68 <main+0x68>
      runcmd(parsecmd(buf));
     de4:	00001517          	auipc	a0,0x1
     de8:	23c50513          	addi	a0,a0,572 # 2020 <buf.0>
     dec:	e79ff0ef          	jal	c64 <parsecmd>
     df0:	ae8ff0ef          	jal	d8 <runcmd>
  exit(0);
     df4:	00000513          	li	a0,0
     df8:	3d8000ef          	jal	11d0 <exit>

0000000000000dfc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     dfc:	ff010113          	addi	sp,sp,-16
     e00:	00113423          	sd	ra,8(sp)
     e04:	00813023          	sd	s0,0(sp)
     e08:	01010413          	addi	s0,sp,16
  extern int main();
  main();
     e0c:	ef5ff0ef          	jal	d00 <main>
  exit(0);
     e10:	00000513          	li	a0,0
     e14:	3bc000ef          	jal	11d0 <exit>

0000000000000e18 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     e18:	ff010113          	addi	sp,sp,-16
     e1c:	00813423          	sd	s0,8(sp)
     e20:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     e24:	00050793          	mv	a5,a0
     e28:	00158593          	addi	a1,a1,1
     e2c:	00178793          	addi	a5,a5,1
     e30:	fff5c703          	lbu	a4,-1(a1)
     e34:	fee78fa3          	sb	a4,-1(a5)
     e38:	fe0718e3          	bnez	a4,e28 <strcpy+0x10>
    ;
  return os;
}
     e3c:	00813403          	ld	s0,8(sp)
     e40:	01010113          	addi	sp,sp,16
     e44:	00008067          	ret

0000000000000e48 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     e48:	ff010113          	addi	sp,sp,-16
     e4c:	00813423          	sd	s0,8(sp)
     e50:	01010413          	addi	s0,sp,16
  while(*p && *p == *q)
     e54:	00054783          	lbu	a5,0(a0)
     e58:	00078e63          	beqz	a5,e74 <strcmp+0x2c>
     e5c:	0005c703          	lbu	a4,0(a1)
     e60:	00f71a63          	bne	a4,a5,e74 <strcmp+0x2c>
    p++, q++;
     e64:	00150513          	addi	a0,a0,1
     e68:	00158593          	addi	a1,a1,1
  while(*p && *p == *q)
     e6c:	00054783          	lbu	a5,0(a0)
     e70:	fe0796e3          	bnez	a5,e5c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
     e74:	0005c503          	lbu	a0,0(a1)
}
     e78:	40a7853b          	subw	a0,a5,a0
     e7c:	00813403          	ld	s0,8(sp)
     e80:	01010113          	addi	sp,sp,16
     e84:	00008067          	ret

0000000000000e88 <strlen>:

uint
strlen(const char *s)
{
     e88:	ff010113          	addi	sp,sp,-16
     e8c:	00813423          	sd	s0,8(sp)
     e90:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     e94:	00054783          	lbu	a5,0(a0)
     e98:	02078863          	beqz	a5,ec8 <strlen+0x40>
     e9c:	00150513          	addi	a0,a0,1
     ea0:	00050793          	mv	a5,a0
     ea4:	00078693          	mv	a3,a5
     ea8:	00178793          	addi	a5,a5,1
     eac:	fff7c703          	lbu	a4,-1(a5)
     eb0:	fe071ae3          	bnez	a4,ea4 <strlen+0x1c>
     eb4:	40a6853b          	subw	a0,a3,a0
     eb8:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
     ebc:	00813403          	ld	s0,8(sp)
     ec0:	01010113          	addi	sp,sp,16
     ec4:	00008067          	ret
  for(n = 0; s[n]; n++)
     ec8:	00000513          	li	a0,0
     ecc:	ff1ff06f          	j	ebc <strlen+0x34>

0000000000000ed0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     ed0:	ff010113          	addi	sp,sp,-16
     ed4:	00813423          	sd	s0,8(sp)
     ed8:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     edc:	02060063          	beqz	a2,efc <memset+0x2c>
     ee0:	00050793          	mv	a5,a0
     ee4:	02061613          	slli	a2,a2,0x20
     ee8:	02065613          	srli	a2,a2,0x20
     eec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     ef0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     ef4:	00178793          	addi	a5,a5,1
     ef8:	fee79ce3          	bne	a5,a4,ef0 <memset+0x20>
  }
  return dst;
}
     efc:	00813403          	ld	s0,8(sp)
     f00:	01010113          	addi	sp,sp,16
     f04:	00008067          	ret

0000000000000f08 <strchr>:

char*
strchr(const char *s, char c)
{
     f08:	ff010113          	addi	sp,sp,-16
     f0c:	00813423          	sd	s0,8(sp)
     f10:	01010413          	addi	s0,sp,16
  for(; *s; s++)
     f14:	00054783          	lbu	a5,0(a0)
     f18:	02078263          	beqz	a5,f3c <strchr+0x34>
    if(*s == c)
     f1c:	00f58a63          	beq	a1,a5,f30 <strchr+0x28>
  for(; *s; s++)
     f20:	00150513          	addi	a0,a0,1
     f24:	00054783          	lbu	a5,0(a0)
     f28:	fe079ae3          	bnez	a5,f1c <strchr+0x14>
      return (char*)s;
  return 0;
     f2c:	00000513          	li	a0,0
}
     f30:	00813403          	ld	s0,8(sp)
     f34:	01010113          	addi	sp,sp,16
     f38:	00008067          	ret
  return 0;
     f3c:	00000513          	li	a0,0
     f40:	ff1ff06f          	j	f30 <strchr+0x28>

0000000000000f44 <gets>:

char*
gets(char *buf, int max)
{
     f44:	fa010113          	addi	sp,sp,-96
     f48:	04113c23          	sd	ra,88(sp)
     f4c:	04813823          	sd	s0,80(sp)
     f50:	04913423          	sd	s1,72(sp)
     f54:	05213023          	sd	s2,64(sp)
     f58:	03313c23          	sd	s3,56(sp)
     f5c:	03413823          	sd	s4,48(sp)
     f60:	03513423          	sd	s5,40(sp)
     f64:	03613023          	sd	s6,32(sp)
     f68:	01713c23          	sd	s7,24(sp)
     f6c:	06010413          	addi	s0,sp,96
     f70:	00050b93          	mv	s7,a0
     f74:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     f78:	00050913          	mv	s2,a0
     f7c:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     f80:	00a00a93          	li	s5,10
     f84:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
     f88:	00048993          	mv	s3,s1
     f8c:	0014849b          	addiw	s1,s1,1
     f90:	0344dc63          	bge	s1,s4,fc8 <gets+0x84>
    cc = read(0, &c, 1);
     f94:	00100613          	li	a2,1
     f98:	faf40593          	addi	a1,s0,-81
     f9c:	00000513          	li	a0,0
     fa0:	254000ef          	jal	11f4 <read>
    if(cc < 1)
     fa4:	02a05263          	blez	a0,fc8 <gets+0x84>
    buf[i++] = c;
     fa8:	faf44783          	lbu	a5,-81(s0)
     fac:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     fb0:	01578a63          	beq	a5,s5,fc4 <gets+0x80>
     fb4:	00190913          	addi	s2,s2,1
     fb8:	fd6798e3          	bne	a5,s6,f88 <gets+0x44>
    buf[i++] = c;
     fbc:	00048993          	mv	s3,s1
     fc0:	0080006f          	j	fc8 <gets+0x84>
     fc4:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     fc8:	013b89b3          	add	s3,s7,s3
     fcc:	00098023          	sb	zero,0(s3)
  return buf;
}
     fd0:	000b8513          	mv	a0,s7
     fd4:	05813083          	ld	ra,88(sp)
     fd8:	05013403          	ld	s0,80(sp)
     fdc:	04813483          	ld	s1,72(sp)
     fe0:	04013903          	ld	s2,64(sp)
     fe4:	03813983          	ld	s3,56(sp)
     fe8:	03013a03          	ld	s4,48(sp)
     fec:	02813a83          	ld	s5,40(sp)
     ff0:	02013b03          	ld	s6,32(sp)
     ff4:	01813b83          	ld	s7,24(sp)
     ff8:	06010113          	addi	sp,sp,96
     ffc:	00008067          	ret

0000000000001000 <stat>:

int
stat(const char *n, struct stat *st)
{
    1000:	fe010113          	addi	sp,sp,-32
    1004:	00113c23          	sd	ra,24(sp)
    1008:	00813823          	sd	s0,16(sp)
    100c:	01213023          	sd	s2,0(sp)
    1010:	02010413          	addi	s0,sp,32
    1014:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1018:	00000593          	li	a1,0
    101c:	214000ef          	jal	1230 <open>
  if(fd < 0)
    1020:	02054e63          	bltz	a0,105c <stat+0x5c>
    1024:	00913423          	sd	s1,8(sp)
    1028:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    102c:	00090593          	mv	a1,s2
    1030:	224000ef          	jal	1254 <fstat>
    1034:	00050913          	mv	s2,a0
  close(fd);
    1038:	00048513          	mv	a0,s1
    103c:	1d0000ef          	jal	120c <close>
  return r;
    1040:	00813483          	ld	s1,8(sp)
}
    1044:	00090513          	mv	a0,s2
    1048:	01813083          	ld	ra,24(sp)
    104c:	01013403          	ld	s0,16(sp)
    1050:	00013903          	ld	s2,0(sp)
    1054:	02010113          	addi	sp,sp,32
    1058:	00008067          	ret
    return -1;
    105c:	fff00913          	li	s2,-1
    1060:	fe5ff06f          	j	1044 <stat+0x44>

0000000000001064 <atoi>:

int
atoi(const char *s)
{
    1064:	ff010113          	addi	sp,sp,-16
    1068:	00813423          	sd	s0,8(sp)
    106c:	01010413          	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1070:	00054683          	lbu	a3,0(a0)
    1074:	fd06879b          	addiw	a5,a3,-48
    1078:	0ff7f793          	zext.b	a5,a5
    107c:	00900613          	li	a2,9
    1080:	04f66063          	bltu	a2,a5,10c0 <atoi+0x5c>
    1084:	00050713          	mv	a4,a0
  n = 0;
    1088:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
    108c:	00170713          	addi	a4,a4,1
    1090:	0025179b          	slliw	a5,a0,0x2
    1094:	00a787bb          	addw	a5,a5,a0
    1098:	0017979b          	slliw	a5,a5,0x1
    109c:	00d787bb          	addw	a5,a5,a3
    10a0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    10a4:	00074683          	lbu	a3,0(a4)
    10a8:	fd06879b          	addiw	a5,a3,-48
    10ac:	0ff7f793          	zext.b	a5,a5
    10b0:	fcf67ee3          	bgeu	a2,a5,108c <atoi+0x28>
  return n;
}
    10b4:	00813403          	ld	s0,8(sp)
    10b8:	01010113          	addi	sp,sp,16
    10bc:	00008067          	ret
  n = 0;
    10c0:	00000513          	li	a0,0
    10c4:	ff1ff06f          	j	10b4 <atoi+0x50>

00000000000010c8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    10c8:	ff010113          	addi	sp,sp,-16
    10cc:	00813423          	sd	s0,8(sp)
    10d0:	01010413          	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    10d4:	02b57c63          	bgeu	a0,a1,110c <memmove+0x44>
    while(n-- > 0)
    10d8:	02c05463          	blez	a2,1100 <memmove+0x38>
    10dc:	02061613          	slli	a2,a2,0x20
    10e0:	02065613          	srli	a2,a2,0x20
    10e4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    10e8:	00050713          	mv	a4,a0
      *dst++ = *src++;
    10ec:	00158593          	addi	a1,a1,1
    10f0:	00170713          	addi	a4,a4,1
    10f4:	fff5c683          	lbu	a3,-1(a1)
    10f8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    10fc:	fef718e3          	bne	a4,a5,10ec <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    1100:	00813403          	ld	s0,8(sp)
    1104:	01010113          	addi	sp,sp,16
    1108:	00008067          	ret
    dst += n;
    110c:	00c50733          	add	a4,a0,a2
    src += n;
    1110:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
    1114:	fec056e3          	blez	a2,1100 <memmove+0x38>
    1118:	fff6079b          	addiw	a5,a2,-1
    111c:	02079793          	slli	a5,a5,0x20
    1120:	0207d793          	srli	a5,a5,0x20
    1124:	fff7c793          	not	a5,a5
    1128:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
    112c:	fff58593          	addi	a1,a1,-1
    1130:	fff70713          	addi	a4,a4,-1
    1134:	0005c683          	lbu	a3,0(a1)
    1138:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    113c:	fee798e3          	bne	a5,a4,112c <memmove+0x64>
    1140:	fc1ff06f          	j	1100 <memmove+0x38>

0000000000001144 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    1144:	ff010113          	addi	sp,sp,-16
    1148:	00813423          	sd	s0,8(sp)
    114c:	01010413          	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    1150:	04060463          	beqz	a2,1198 <memcmp+0x54>
    1154:	fff6069b          	addiw	a3,a2,-1
    1158:	02069693          	slli	a3,a3,0x20
    115c:	0206d693          	srli	a3,a3,0x20
    1160:	00168693          	addi	a3,a3,1
    1164:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
    1168:	00054783          	lbu	a5,0(a0)
    116c:	0005c703          	lbu	a4,0(a1)
    1170:	00e79c63          	bne	a5,a4,1188 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
    1174:	00150513          	addi	a0,a0,1
    p2++;
    1178:	00158593          	addi	a1,a1,1
  while (n-- > 0) {
    117c:	fed516e3          	bne	a0,a3,1168 <memcmp+0x24>
  }
  return 0;
    1180:	00000513          	li	a0,0
    1184:	0080006f          	j	118c <memcmp+0x48>
      return *p1 - *p2;
    1188:	40e7853b          	subw	a0,a5,a4
}
    118c:	00813403          	ld	s0,8(sp)
    1190:	01010113          	addi	sp,sp,16
    1194:	00008067          	ret
  return 0;
    1198:	00000513          	li	a0,0
    119c:	ff1ff06f          	j	118c <memcmp+0x48>

00000000000011a0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    11a0:	ff010113          	addi	sp,sp,-16
    11a4:	00113423          	sd	ra,8(sp)
    11a8:	00813023          	sd	s0,0(sp)
    11ac:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
    11b0:	f19ff0ef          	jal	10c8 <memmove>
}
    11b4:	00813083          	ld	ra,8(sp)
    11b8:	00013403          	ld	s0,0(sp)
    11bc:	01010113          	addi	sp,sp,16
    11c0:	00008067          	ret

00000000000011c4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    11c4:	00100893          	li	a7,1
 ecall
    11c8:	00000073          	ecall
 ret
    11cc:	00008067          	ret

00000000000011d0 <exit>:
.global exit
exit:
 li a7, SYS_exit
    11d0:	00200893          	li	a7,2
 ecall
    11d4:	00000073          	ecall
 ret
    11d8:	00008067          	ret

00000000000011dc <wait>:
.global wait
wait:
 li a7, SYS_wait
    11dc:	00300893          	li	a7,3
 ecall
    11e0:	00000073          	ecall
 ret
    11e4:	00008067          	ret

00000000000011e8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    11e8:	00400893          	li	a7,4
 ecall
    11ec:	00000073          	ecall
 ret
    11f0:	00008067          	ret

00000000000011f4 <read>:
.global read
read:
 li a7, SYS_read
    11f4:	00500893          	li	a7,5
 ecall
    11f8:	00000073          	ecall
 ret
    11fc:	00008067          	ret

0000000000001200 <write>:
.global write
write:
 li a7, SYS_write
    1200:	01000893          	li	a7,16
 ecall
    1204:	00000073          	ecall
 ret
    1208:	00008067          	ret

000000000000120c <close>:
.global close
close:
 li a7, SYS_close
    120c:	01500893          	li	a7,21
 ecall
    1210:	00000073          	ecall
 ret
    1214:	00008067          	ret

0000000000001218 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1218:	00600893          	li	a7,6
 ecall
    121c:	00000073          	ecall
 ret
    1220:	00008067          	ret

0000000000001224 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1224:	00700893          	li	a7,7
 ecall
    1228:	00000073          	ecall
 ret
    122c:	00008067          	ret

0000000000001230 <open>:
.global open
open:
 li a7, SYS_open
    1230:	00f00893          	li	a7,15
 ecall
    1234:	00000073          	ecall
 ret
    1238:	00008067          	ret

000000000000123c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    123c:	01100893          	li	a7,17
 ecall
    1240:	00000073          	ecall
 ret
    1244:	00008067          	ret

0000000000001248 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1248:	01200893          	li	a7,18
 ecall
    124c:	00000073          	ecall
 ret
    1250:	00008067          	ret

0000000000001254 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1254:	00800893          	li	a7,8
 ecall
    1258:	00000073          	ecall
 ret
    125c:	00008067          	ret

0000000000001260 <link>:
.global link
link:
 li a7, SYS_link
    1260:	01300893          	li	a7,19
 ecall
    1264:	00000073          	ecall
 ret
    1268:	00008067          	ret

000000000000126c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    126c:	01400893          	li	a7,20
 ecall
    1270:	00000073          	ecall
 ret
    1274:	00008067          	ret

0000000000001278 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1278:	00900893          	li	a7,9
 ecall
    127c:	00000073          	ecall
 ret
    1280:	00008067          	ret

0000000000001284 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1284:	00a00893          	li	a7,10
 ecall
    1288:	00000073          	ecall
 ret
    128c:	00008067          	ret

0000000000001290 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1290:	00b00893          	li	a7,11
 ecall
    1294:	00000073          	ecall
 ret
    1298:	00008067          	ret

000000000000129c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    129c:	00c00893          	li	a7,12
 ecall
    12a0:	00000073          	ecall
 ret
    12a4:	00008067          	ret

00000000000012a8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    12a8:	00d00893          	li	a7,13
 ecall
    12ac:	00000073          	ecall
 ret
    12b0:	00008067          	ret

00000000000012b4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    12b4:	00e00893          	li	a7,14
 ecall
    12b8:	00000073          	ecall
 ret
    12bc:	00008067          	ret

00000000000012c0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    12c0:	fe010113          	addi	sp,sp,-32
    12c4:	00113c23          	sd	ra,24(sp)
    12c8:	00813823          	sd	s0,16(sp)
    12cc:	02010413          	addi	s0,sp,32
    12d0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    12d4:	00100613          	li	a2,1
    12d8:	fef40593          	addi	a1,s0,-17
    12dc:	f25ff0ef          	jal	1200 <write>
}
    12e0:	01813083          	ld	ra,24(sp)
    12e4:	01013403          	ld	s0,16(sp)
    12e8:	02010113          	addi	sp,sp,32
    12ec:	00008067          	ret

00000000000012f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    12f0:	fc010113          	addi	sp,sp,-64
    12f4:	02113c23          	sd	ra,56(sp)
    12f8:	02813823          	sd	s0,48(sp)
    12fc:	02913423          	sd	s1,40(sp)
    1300:	04010413          	addi	s0,sp,64
    1304:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1308:	00068463          	beqz	a3,1310 <printint+0x20>
    130c:	0c05c263          	bltz	a1,13d0 <printint+0xe0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1310:	0005859b          	sext.w	a1,a1
  neg = 0;
    1314:	00000893          	li	a7,0
    1318:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    131c:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1320:	0006061b          	sext.w	a2,a2
    1324:	00001517          	auipc	a0,0x1
    1328:	85450513          	addi	a0,a0,-1964 # 1b78 <digits>
    132c:	00070813          	mv	a6,a4
    1330:	0017071b          	addiw	a4,a4,1
    1334:	02c5f7bb          	remuw	a5,a1,a2
    1338:	02079793          	slli	a5,a5,0x20
    133c:	0207d793          	srli	a5,a5,0x20
    1340:	00f507b3          	add	a5,a0,a5
    1344:	0007c783          	lbu	a5,0(a5)
    1348:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    134c:	0005879b          	sext.w	a5,a1
    1350:	02c5d5bb          	divuw	a1,a1,a2
    1354:	00168693          	addi	a3,a3,1
    1358:	fcc7fae3          	bgeu	a5,a2,132c <printint+0x3c>
  if(neg)
    135c:	00088c63          	beqz	a7,1374 <printint+0x84>
    buf[i++] = '-';
    1360:	fd070793          	addi	a5,a4,-48
    1364:	00878733          	add	a4,a5,s0
    1368:	02d00793          	li	a5,45
    136c:	fef70823          	sb	a5,-16(a4)
    1370:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1374:	04e05463          	blez	a4,13bc <printint+0xcc>
    1378:	03213023          	sd	s2,32(sp)
    137c:	01313c23          	sd	s3,24(sp)
    1380:	fc040793          	addi	a5,s0,-64
    1384:	00e78933          	add	s2,a5,a4
    1388:	fff78993          	addi	s3,a5,-1
    138c:	00e989b3          	add	s3,s3,a4
    1390:	fff7071b          	addiw	a4,a4,-1
    1394:	02071713          	slli	a4,a4,0x20
    1398:	02075713          	srli	a4,a4,0x20
    139c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    13a0:	fff94583          	lbu	a1,-1(s2)
    13a4:	00048513          	mv	a0,s1
    13a8:	f19ff0ef          	jal	12c0 <putc>
  while(--i >= 0)
    13ac:	fff90913          	addi	s2,s2,-1
    13b0:	ff3918e3          	bne	s2,s3,13a0 <printint+0xb0>
    13b4:	02013903          	ld	s2,32(sp)
    13b8:	01813983          	ld	s3,24(sp)
}
    13bc:	03813083          	ld	ra,56(sp)
    13c0:	03013403          	ld	s0,48(sp)
    13c4:	02813483          	ld	s1,40(sp)
    13c8:	04010113          	addi	sp,sp,64
    13cc:	00008067          	ret
    x = -xx;
    13d0:	40b005bb          	negw	a1,a1
    neg = 1;
    13d4:	00100893          	li	a7,1
    x = -xx;
    13d8:	f41ff06f          	j	1318 <printint+0x28>

00000000000013dc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    13dc:	fa010113          	addi	sp,sp,-96
    13e0:	04113c23          	sd	ra,88(sp)
    13e4:	04813823          	sd	s0,80(sp)
    13e8:	05213023          	sd	s2,64(sp)
    13ec:	06010413          	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    13f0:	0005c903          	lbu	s2,0(a1)
    13f4:	36090463          	beqz	s2,175c <vprintf+0x380>
    13f8:	04913423          	sd	s1,72(sp)
    13fc:	03313c23          	sd	s3,56(sp)
    1400:	03413823          	sd	s4,48(sp)
    1404:	03513423          	sd	s5,40(sp)
    1408:	03613023          	sd	s6,32(sp)
    140c:	01713c23          	sd	s7,24(sp)
    1410:	01813823          	sd	s8,16(sp)
    1414:	01913423          	sd	s9,8(sp)
    1418:	00050b13          	mv	s6,a0
    141c:	00058a13          	mv	s4,a1
    1420:	00060b93          	mv	s7,a2
  state = 0;
    1424:	00000993          	li	s3,0
  for(i = 0; fmt[i]; i++){
    1428:	00000493          	li	s1,0
    142c:	00000713          	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    1430:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    1434:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    1438:	06c00c93          	li	s9,108
    143c:	02c0006f          	j	1468 <vprintf+0x8c>
        putc(fd, c0);
    1440:	00090593          	mv	a1,s2
    1444:	000b0513          	mv	a0,s6
    1448:	e79ff0ef          	jal	12c0 <putc>
    144c:	0080006f          	j	1454 <vprintf+0x78>
    } else if(state == '%'){
    1450:	03598663          	beq	s3,s5,147c <vprintf+0xa0>
  for(i = 0; fmt[i]; i++){
    1454:	0014849b          	addiw	s1,s1,1
    1458:	00048713          	mv	a4,s1
    145c:	009a07b3          	add	a5,s4,s1
    1460:	0007c903          	lbu	s2,0(a5)
    1464:	2c090c63          	beqz	s2,173c <vprintf+0x360>
    c0 = fmt[i] & 0xff;
    1468:	0009079b          	sext.w	a5,s2
    if(state == 0){
    146c:	fe0992e3          	bnez	s3,1450 <vprintf+0x74>
      if(c0 == '%'){
    1470:	fd5798e3          	bne	a5,s5,1440 <vprintf+0x64>
        state = '%';
    1474:	00078993          	mv	s3,a5
    1478:	fddff06f          	j	1454 <vprintf+0x78>
      if(c0) c1 = fmt[i+1] & 0xff;
    147c:	00ea06b3          	add	a3,s4,a4
    1480:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    1484:	00068613          	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    1488:	00068663          	beqz	a3,1494 <vprintf+0xb8>
    148c:	00ea0733          	add	a4,s4,a4
    1490:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    1494:	05878263          	beq	a5,s8,14d8 <vprintf+0xfc>
      } else if(c0 == 'l' && c1 == 'd'){
    1498:	07978263          	beq	a5,s9,14fc <vprintf+0x120>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    149c:	07500713          	li	a4,117
    14a0:	12e78663          	beq	a5,a4,15cc <vprintf+0x1f0>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    14a4:	07800713          	li	a4,120
    14a8:	18e78c63          	beq	a5,a4,1640 <vprintf+0x264>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    14ac:	07000713          	li	a4,112
    14b0:	1ce78e63          	beq	a5,a4,168c <vprintf+0x2b0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    14b4:	07300713          	li	a4,115
    14b8:	22e78a63          	beq	a5,a4,16ec <vprintf+0x310>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    14bc:	02500713          	li	a4,37
    14c0:	04e79e63          	bne	a5,a4,151c <vprintf+0x140>
        putc(fd, '%');
    14c4:	02500593          	li	a1,37
    14c8:	000b0513          	mv	a0,s6
    14cc:	df5ff0ef          	jal	12c0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    14d0:	00000993          	li	s3,0
    14d4:	f81ff06f          	j	1454 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 1);
    14d8:	008b8913          	addi	s2,s7,8
    14dc:	00100693          	li	a3,1
    14e0:	00a00613          	li	a2,10
    14e4:	000ba583          	lw	a1,0(s7)
    14e8:	000b0513          	mv	a0,s6
    14ec:	e05ff0ef          	jal	12f0 <printint>
    14f0:	00090b93          	mv	s7,s2
      state = 0;
    14f4:	00000993          	li	s3,0
    14f8:	f5dff06f          	j	1454 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'd'){
    14fc:	06400793          	li	a5,100
    1500:	02f68e63          	beq	a3,a5,153c <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1504:	06c00793          	li	a5,108
    1508:	04f68e63          	beq	a3,a5,1564 <vprintf+0x188>
      } else if(c0 == 'l' && c1 == 'u'){
    150c:	07500793          	li	a5,117
    1510:	0ef68063          	beq	a3,a5,15f0 <vprintf+0x214>
      } else if(c0 == 'l' && c1 == 'x'){
    1514:	07800793          	li	a5,120
    1518:	14f68663          	beq	a3,a5,1664 <vprintf+0x288>
        putc(fd, '%');
    151c:	02500593          	li	a1,37
    1520:	000b0513          	mv	a0,s6
    1524:	d9dff0ef          	jal	12c0 <putc>
        putc(fd, c0);
    1528:	00090593          	mv	a1,s2
    152c:	000b0513          	mv	a0,s6
    1530:	d91ff0ef          	jal	12c0 <putc>
      state = 0;
    1534:	00000993          	li	s3,0
    1538:	f1dff06f          	j	1454 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
    153c:	008b8913          	addi	s2,s7,8
    1540:	00100693          	li	a3,1
    1544:	00a00613          	li	a2,10
    1548:	000ba583          	lw	a1,0(s7)
    154c:	000b0513          	mv	a0,s6
    1550:	da1ff0ef          	jal	12f0 <printint>
        i += 1;
    1554:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    1558:	00090b93          	mv	s7,s2
      state = 0;
    155c:	00000993          	li	s3,0
        i += 1;
    1560:	ef5ff06f          	j	1454 <vprintf+0x78>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1564:	06400793          	li	a5,100
    1568:	02f60e63          	beq	a2,a5,15a4 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    156c:	07500793          	li	a5,117
    1570:	0af60463          	beq	a2,a5,1618 <vprintf+0x23c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1574:	07800793          	li	a5,120
    1578:	faf612e3          	bne	a2,a5,151c <vprintf+0x140>
        printint(fd, va_arg(ap, uint64), 16, 0);
    157c:	008b8913          	addi	s2,s7,8
    1580:	00000693          	li	a3,0
    1584:	01000613          	li	a2,16
    1588:	000ba583          	lw	a1,0(s7)
    158c:	000b0513          	mv	a0,s6
    1590:	d61ff0ef          	jal	12f0 <printint>
        i += 2;
    1594:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    1598:	00090b93          	mv	s7,s2
      state = 0;
    159c:	00000993          	li	s3,0
        i += 2;
    15a0:	eb5ff06f          	j	1454 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 1);
    15a4:	008b8913          	addi	s2,s7,8
    15a8:	00100693          	li	a3,1
    15ac:	00a00613          	li	a2,10
    15b0:	000ba583          	lw	a1,0(s7)
    15b4:	000b0513          	mv	a0,s6
    15b8:	d39ff0ef          	jal	12f0 <printint>
        i += 2;
    15bc:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    15c0:	00090b93          	mv	s7,s2
      state = 0;
    15c4:	00000993          	li	s3,0
        i += 2;
    15c8:	e8dff06f          	j	1454 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 10, 0);
    15cc:	008b8913          	addi	s2,s7,8
    15d0:	00000693          	li	a3,0
    15d4:	00a00613          	li	a2,10
    15d8:	000ba583          	lw	a1,0(s7)
    15dc:	000b0513          	mv	a0,s6
    15e0:	d11ff0ef          	jal	12f0 <printint>
    15e4:	00090b93          	mv	s7,s2
      state = 0;
    15e8:	00000993          	li	s3,0
    15ec:	e69ff06f          	j	1454 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
    15f0:	008b8913          	addi	s2,s7,8
    15f4:	00000693          	li	a3,0
    15f8:	00a00613          	li	a2,10
    15fc:	000ba583          	lw	a1,0(s7)
    1600:	000b0513          	mv	a0,s6
    1604:	cedff0ef          	jal	12f0 <printint>
        i += 1;
    1608:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    160c:	00090b93          	mv	s7,s2
      state = 0;
    1610:	00000993          	li	s3,0
        i += 1;
    1614:	e41ff06f          	j	1454 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1618:	008b8913          	addi	s2,s7,8
    161c:	00000693          	li	a3,0
    1620:	00a00613          	li	a2,10
    1624:	000ba583          	lw	a1,0(s7)
    1628:	000b0513          	mv	a0,s6
    162c:	cc5ff0ef          	jal	12f0 <printint>
        i += 2;
    1630:	0024849b          	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1634:	00090b93          	mv	s7,s2
      state = 0;
    1638:	00000993          	li	s3,0
        i += 2;
    163c:	e19ff06f          	j	1454 <vprintf+0x78>
        printint(fd, va_arg(ap, int), 16, 0);
    1640:	008b8913          	addi	s2,s7,8
    1644:	00000693          	li	a3,0
    1648:	01000613          	li	a2,16
    164c:	000ba583          	lw	a1,0(s7)
    1650:	000b0513          	mv	a0,s6
    1654:	c9dff0ef          	jal	12f0 <printint>
    1658:	00090b93          	mv	s7,s2
      state = 0;
    165c:	00000993          	li	s3,0
    1660:	df5ff06f          	j	1454 <vprintf+0x78>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1664:	008b8913          	addi	s2,s7,8
    1668:	00000693          	li	a3,0
    166c:	01000613          	li	a2,16
    1670:	000ba583          	lw	a1,0(s7)
    1674:	000b0513          	mv	a0,s6
    1678:	c79ff0ef          	jal	12f0 <printint>
        i += 1;
    167c:	0014849b          	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1680:	00090b93          	mv	s7,s2
      state = 0;
    1684:	00000993          	li	s3,0
        i += 1;
    1688:	dcdff06f          	j	1454 <vprintf+0x78>
    168c:	01a13023          	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1690:	008b8d13          	addi	s10,s7,8
    1694:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1698:	03000593          	li	a1,48
    169c:	000b0513          	mv	a0,s6
    16a0:	c21ff0ef          	jal	12c0 <putc>
  putc(fd, 'x');
    16a4:	07800593          	li	a1,120
    16a8:	000b0513          	mv	a0,s6
    16ac:	c15ff0ef          	jal	12c0 <putc>
    16b0:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    16b4:	00000b97          	auipc	s7,0x0
    16b8:	4c4b8b93          	addi	s7,s7,1220 # 1b78 <digits>
    16bc:	03c9d793          	srli	a5,s3,0x3c
    16c0:	00fb87b3          	add	a5,s7,a5
    16c4:	0007c583          	lbu	a1,0(a5)
    16c8:	000b0513          	mv	a0,s6
    16cc:	bf5ff0ef          	jal	12c0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    16d0:	00499993          	slli	s3,s3,0x4
    16d4:	fff9091b          	addiw	s2,s2,-1
    16d8:	fe0912e3          	bnez	s2,16bc <vprintf+0x2e0>
        printptr(fd, va_arg(ap, uint64));
    16dc:	000d0b93          	mv	s7,s10
      state = 0;
    16e0:	00000993          	li	s3,0
    16e4:	00013d03          	ld	s10,0(sp)
    16e8:	d6dff06f          	j	1454 <vprintf+0x78>
        if((s = va_arg(ap, char*)) == 0)
    16ec:	008b8993          	addi	s3,s7,8
    16f0:	000bb903          	ld	s2,0(s7)
    16f4:	02090663          	beqz	s2,1720 <vprintf+0x344>
        for(; *s; s++)
    16f8:	00094583          	lbu	a1,0(s2)
    16fc:	02058a63          	beqz	a1,1730 <vprintf+0x354>
          putc(fd, *s);
    1700:	000b0513          	mv	a0,s6
    1704:	bbdff0ef          	jal	12c0 <putc>
        for(; *s; s++)
    1708:	00190913          	addi	s2,s2,1
    170c:	00094583          	lbu	a1,0(s2)
    1710:	fe0598e3          	bnez	a1,1700 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
    1714:	00098b93          	mv	s7,s3
      state = 0;
    1718:	00000993          	li	s3,0
    171c:	d39ff06f          	j	1454 <vprintf+0x78>
          s = "(null)";
    1720:	00000917          	auipc	s2,0x0
    1724:	42090913          	addi	s2,s2,1056 # 1b40 <malloc+0x28c>
        for(; *s; s++)
    1728:	02800593          	li	a1,40
    172c:	fd5ff06f          	j	1700 <vprintf+0x324>
        if((s = va_arg(ap, char*)) == 0)
    1730:	00098b93          	mv	s7,s3
      state = 0;
    1734:	00000993          	li	s3,0
    1738:	d1dff06f          	j	1454 <vprintf+0x78>
    173c:	04813483          	ld	s1,72(sp)
    1740:	03813983          	ld	s3,56(sp)
    1744:	03013a03          	ld	s4,48(sp)
    1748:	02813a83          	ld	s5,40(sp)
    174c:	02013b03          	ld	s6,32(sp)
    1750:	01813b83          	ld	s7,24(sp)
    1754:	01013c03          	ld	s8,16(sp)
    1758:	00813c83          	ld	s9,8(sp)
    }
  }
}
    175c:	05813083          	ld	ra,88(sp)
    1760:	05013403          	ld	s0,80(sp)
    1764:	04013903          	ld	s2,64(sp)
    1768:	06010113          	addi	sp,sp,96
    176c:	00008067          	ret

0000000000001770 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1770:	fb010113          	addi	sp,sp,-80
    1774:	00113c23          	sd	ra,24(sp)
    1778:	00813823          	sd	s0,16(sp)
    177c:	02010413          	addi	s0,sp,32
    1780:	00c43023          	sd	a2,0(s0)
    1784:	00d43423          	sd	a3,8(s0)
    1788:	00e43823          	sd	a4,16(s0)
    178c:	00f43c23          	sd	a5,24(s0)
    1790:	03043023          	sd	a6,32(s0)
    1794:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1798:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    179c:	00040613          	mv	a2,s0
    17a0:	c3dff0ef          	jal	13dc <vprintf>
}
    17a4:	01813083          	ld	ra,24(sp)
    17a8:	01013403          	ld	s0,16(sp)
    17ac:	05010113          	addi	sp,sp,80
    17b0:	00008067          	ret

00000000000017b4 <printf>:

void
printf(const char *fmt, ...)
{
    17b4:	fa010113          	addi	sp,sp,-96
    17b8:	00113c23          	sd	ra,24(sp)
    17bc:	00813823          	sd	s0,16(sp)
    17c0:	02010413          	addi	s0,sp,32
    17c4:	00b43423          	sd	a1,8(s0)
    17c8:	00c43823          	sd	a2,16(s0)
    17cc:	00d43c23          	sd	a3,24(s0)
    17d0:	02e43023          	sd	a4,32(s0)
    17d4:	02f43423          	sd	a5,40(s0)
    17d8:	03043823          	sd	a6,48(s0)
    17dc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    17e0:	00840613          	addi	a2,s0,8
    17e4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    17e8:	00050593          	mv	a1,a0
    17ec:	00100513          	li	a0,1
    17f0:	bedff0ef          	jal	13dc <vprintf>
}
    17f4:	01813083          	ld	ra,24(sp)
    17f8:	01013403          	ld	s0,16(sp)
    17fc:	06010113          	addi	sp,sp,96
    1800:	00008067          	ret

0000000000001804 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1804:	ff010113          	addi	sp,sp,-16
    1808:	00813423          	sd	s0,8(sp)
    180c:	01010413          	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1810:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1814:	00000797          	auipc	a5,0x0
    1818:	7fc7b783          	ld	a5,2044(a5) # 2010 <freep>
    181c:	0400006f          	j	185c <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1820:	00862703          	lw	a4,8(a2)
    1824:	00b7073b          	addw	a4,a4,a1
    1828:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    182c:	0007b703          	ld	a4,0(a5)
    1830:	00073603          	ld	a2,0(a4)
    1834:	0500006f          	j	1884 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1838:	ff852703          	lw	a4,-8(a0)
    183c:	00c7073b          	addw	a4,a4,a2
    1840:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1844:	ff053683          	ld	a3,-16(a0)
    1848:	0540006f          	j	189c <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    184c:	0007b703          	ld	a4,0(a5)
    1850:	00e7e463          	bltu	a5,a4,1858 <free+0x54>
    1854:	00e6ec63          	bltu	a3,a4,186c <free+0x68>
{
    1858:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    185c:	fed7f8e3          	bgeu	a5,a3,184c <free+0x48>
    1860:	0007b703          	ld	a4,0(a5)
    1864:	00e6e463          	bltu	a3,a4,186c <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1868:	fee7e8e3          	bltu	a5,a4,1858 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
    186c:	ff852583          	lw	a1,-8(a0)
    1870:	0007b603          	ld	a2,0(a5)
    1874:	02059813          	slli	a6,a1,0x20
    1878:	01c85713          	srli	a4,a6,0x1c
    187c:	00e68733          	add	a4,a3,a4
    1880:	fae600e3          	beq	a2,a4,1820 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
    1884:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1888:	0087a603          	lw	a2,8(a5)
    188c:	02061593          	slli	a1,a2,0x20
    1890:	01c5d713          	srli	a4,a1,0x1c
    1894:	00e78733          	add	a4,a5,a4
    1898:	fae680e3          	beq	a3,a4,1838 <free+0x34>
    p->s.ptr = bp->s.ptr;
    189c:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    18a0:	00000717          	auipc	a4,0x0
    18a4:	76f73823          	sd	a5,1904(a4) # 2010 <freep>
}
    18a8:	00813403          	ld	s0,8(sp)
    18ac:	01010113          	addi	sp,sp,16
    18b0:	00008067          	ret

00000000000018b4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    18b4:	fc010113          	addi	sp,sp,-64
    18b8:	02113c23          	sd	ra,56(sp)
    18bc:	02813823          	sd	s0,48(sp)
    18c0:	02913423          	sd	s1,40(sp)
    18c4:	01313c23          	sd	s3,24(sp)
    18c8:	04010413          	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    18cc:	02051493          	slli	s1,a0,0x20
    18d0:	0204d493          	srli	s1,s1,0x20
    18d4:	00f48493          	addi	s1,s1,15
    18d8:	0044d493          	srli	s1,s1,0x4
    18dc:	0014899b          	addiw	s3,s1,1
    18e0:	00148493          	addi	s1,s1,1
  if((prevp = freep) == 0){
    18e4:	00000517          	auipc	a0,0x0
    18e8:	72c53503          	ld	a0,1836(a0) # 2010 <freep>
    18ec:	04050663          	beqz	a0,1938 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18f0:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
    18f4:	0087a703          	lw	a4,8(a5)
    18f8:	0c977c63          	bgeu	a4,s1,19d0 <malloc+0x11c>
    18fc:	03213023          	sd	s2,32(sp)
    1900:	01413823          	sd	s4,16(sp)
    1904:	01513423          	sd	s5,8(sp)
    1908:	01613023          	sd	s6,0(sp)
  if(nu < 4096)
    190c:	00098a13          	mv	s4,s3
    1910:	0009871b          	sext.w	a4,s3
    1914:	000016b7          	lui	a3,0x1
    1918:	00d77463          	bgeu	a4,a3,1920 <malloc+0x6c>
    191c:	00001a37          	lui	s4,0x1
    1920:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1924:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1928:	00000917          	auipc	s2,0x0
    192c:	6e890913          	addi	s2,s2,1768 # 2010 <freep>
  if(p == (char*)-1)
    1930:	fff00a93          	li	s5,-1
    1934:	05c0006f          	j	1990 <malloc+0xdc>
    1938:	03213023          	sd	s2,32(sp)
    193c:	01413823          	sd	s4,16(sp)
    1940:	01513423          	sd	s5,8(sp)
    1944:	01613023          	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1948:	00000797          	auipc	a5,0x0
    194c:	74078793          	addi	a5,a5,1856 # 2088 <base>
    1950:	00000717          	auipc	a4,0x0
    1954:	6cf73023          	sd	a5,1728(a4) # 2010 <freep>
    1958:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
    195c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1960:	fadff06f          	j	190c <malloc+0x58>
        prevp->s.ptr = p->s.ptr;
    1964:	0007b703          	ld	a4,0(a5)
    1968:	00e53023          	sd	a4,0(a0)
    196c:	0800006f          	j	19ec <malloc+0x138>
  hp->s.size = nu;
    1970:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1974:	01050513          	addi	a0,a0,16
    1978:	e8dff0ef          	jal	1804 <free>
  return freep;
    197c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1980:	08050863          	beqz	a0,1a10 <malloc+0x15c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1984:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1988:	0087a703          	lw	a4,8(a5)
    198c:	02977a63          	bgeu	a4,s1,19c0 <malloc+0x10c>
    if(p == freep)
    1990:	00093703          	ld	a4,0(s2)
    1994:	00078513          	mv	a0,a5
    1998:	fef716e3          	bne	a4,a5,1984 <malloc+0xd0>
  p = sbrk(nu * sizeof(Header));
    199c:	000a0513          	mv	a0,s4
    19a0:	8fdff0ef          	jal	129c <sbrk>
  if(p == (char*)-1)
    19a4:	fd5516e3          	bne	a0,s5,1970 <malloc+0xbc>
        return 0;
    19a8:	00000513          	li	a0,0
    19ac:	02013903          	ld	s2,32(sp)
    19b0:	01013a03          	ld	s4,16(sp)
    19b4:	00813a83          	ld	s5,8(sp)
    19b8:	00013b03          	ld	s6,0(sp)
    19bc:	03c0006f          	j	19f8 <malloc+0x144>
    19c0:	02013903          	ld	s2,32(sp)
    19c4:	01013a03          	ld	s4,16(sp)
    19c8:	00813a83          	ld	s5,8(sp)
    19cc:	00013b03          	ld	s6,0(sp)
      if(p->s.size == nunits)
    19d0:	f8e48ae3          	beq	s1,a4,1964 <malloc+0xb0>
        p->s.size -= nunits;
    19d4:	4137073b          	subw	a4,a4,s3
    19d8:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
    19dc:	02071693          	slli	a3,a4,0x20
    19e0:	01c6d713          	srli	a4,a3,0x1c
    19e4:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
    19e8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    19ec:	00000717          	auipc	a4,0x0
    19f0:	62a73223          	sd	a0,1572(a4) # 2010 <freep>
      return (void*)(p + 1);
    19f4:	01078513          	addi	a0,a5,16
  }
}
    19f8:	03813083          	ld	ra,56(sp)
    19fc:	03013403          	ld	s0,48(sp)
    1a00:	02813483          	ld	s1,40(sp)
    1a04:	01813983          	ld	s3,24(sp)
    1a08:	04010113          	addi	sp,sp,64
    1a0c:	00008067          	ret
    1a10:	02013903          	ld	s2,32(sp)
    1a14:	01013a03          	ld	s4,16(sp)
    1a18:	00813a83          	ld	s5,8(sp)
    1a1c:	00013b03          	ld	s6,0(sp)
    1a20:	fd9ff06f          	j	19f8 <malloc+0x144>
