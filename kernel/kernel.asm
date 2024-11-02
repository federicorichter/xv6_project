
kernel/kernel:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	99010113          	addi	sp,sp,-1648 # 80007990 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
// Machine Environment Configuration Register
static inline uint64
r_menvcfg()
{
  uint64 x;
  asm volatile("csrr %0, menvcfg" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4
}

static inline void 
w_menvcfg(uint64 x)
{
  asm volatile("csrw menvcfg, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw stimecmp, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd6af>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	de278793          	addi	a5,a5,-542 # 80000e62 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	f84a                	sd	s2,48(sp)
    800000d8:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000da:	04c05263          	blez	a2,8000011e <consolewrite+0x4e>
    800000de:	fc26                	sd	s1,56(sp)
    800000e0:	f44e                	sd	s3,40(sp)
    800000e2:	f052                	sd	s4,32(sp)
    800000e4:	ec56                	sd	s5,24(sp)
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	787010ef          	jal	80002080 <either_copyin>
    800000fe:	03550263          	beq	a0,s5,80000122 <consolewrite+0x52>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	035000ef          	jal	8000093a <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
    80000112:	894e                	mv	s2,s3
    80000114:	74e2                	ld	s1,56(sp)
    80000116:	79a2                	ld	s3,40(sp)
    80000118:	7a02                	ld	s4,32(sp)
    8000011a:	6ae2                	ld	s5,24(sp)
    8000011c:	a039                	j	8000012a <consolewrite+0x5a>
    8000011e:	4901                	li	s2,0
    80000120:	a029                	j	8000012a <consolewrite+0x5a>
    80000122:	74e2                	ld	s1,56(sp)
    80000124:	79a2                	ld	s3,40(sp)
    80000126:	7a02                	ld	s4,32(sp)
    80000128:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    8000012a:	854a                	mv	a0,s2
    8000012c:	60a6                	ld	ra,72(sp)
    8000012e:	6406                	ld	s0,64(sp)
    80000130:	7942                	ld	s2,48(sp)
    80000132:	6161                	addi	sp,sp,80
    80000134:	8082                	ret

0000000080000136 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000136:	711d                	addi	sp,sp,-96
    80000138:	ec86                	sd	ra,88(sp)
    8000013a:	e8a2                	sd	s0,80(sp)
    8000013c:	e4a6                	sd	s1,72(sp)
    8000013e:	e0ca                	sd	s2,64(sp)
    80000140:	fc4e                	sd	s3,56(sp)
    80000142:	f852                	sd	s4,48(sp)
    80000144:	f456                	sd	s5,40(sp)
    80000146:	f05a                	sd	s6,32(sp)
    80000148:	1080                	addi	s0,sp,96
    8000014a:	8aaa                	mv	s5,a0
    8000014c:	8a2e                	mv	s4,a1
    8000014e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000150:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000154:	00010517          	auipc	a0,0x10
    80000158:	83c50513          	addi	a0,a0,-1988 # 8000f990 <cons>
    8000015c:	299000ef          	jal	80000bf4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00010497          	auipc	s1,0x10
    80000164:	83048493          	addi	s1,s1,-2000 # 8000f990 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00010917          	auipc	s2,0x10
    8000016c:	8c090913          	addi	s2,s2,-1856 # 8000fa28 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	772010ef          	jal	800018f2 <myproc>
    80000184:	58f010ef          	jal	80001f12 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	34d010ef          	jal	80001cda <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	0000f717          	auipc	a4,0xf
    800001a4:	7f070713          	addi	a4,a4,2032 # 8000f990 <cons>
    800001a8:	0017869b          	addiw	a3,a5,1
    800001ac:	08d72c23          	sw	a3,152(a4)
    800001b0:	07f7f693          	andi	a3,a5,127
    800001b4:	9736                	add	a4,a4,a3
    800001b6:	01874703          	lbu	a4,24(a4)
    800001ba:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001be:	4691                	li	a3,4
    800001c0:	04db8663          	beq	s7,a3,8000020c <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001c4:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001c8:	4685                	li	a3,1
    800001ca:	faf40613          	addi	a2,s0,-81
    800001ce:	85d2                	mv	a1,s4
    800001d0:	8556                	mv	a0,s5
    800001d2:	665010ef          	jal	80002036 <either_copyout>
    800001d6:	57fd                	li	a5,-1
    800001d8:	04f50863          	beq	a0,a5,80000228 <consoleread+0xf2>
      break;

    dst++;
    800001dc:	0a05                	addi	s4,s4,1
    --n;
    800001de:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001e0:	47a9                	li	a5,10
    800001e2:	04fb8d63          	beq	s7,a5,8000023c <consoleread+0x106>
    800001e6:	6be2                	ld	s7,24(sp)
    800001e8:	b761                	j	80000170 <consoleread+0x3a>
        release(&cons.lock);
    800001ea:	0000f517          	auipc	a0,0xf
    800001ee:	7a650513          	addi	a0,a0,1958 # 8000f990 <cons>
    800001f2:	29b000ef          	jal	80000c8c <release>
        return -1;
    800001f6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800001f8:	60e6                	ld	ra,88(sp)
    800001fa:	6446                	ld	s0,80(sp)
    800001fc:	64a6                	ld	s1,72(sp)
    800001fe:	6906                	ld	s2,64(sp)
    80000200:	79e2                	ld	s3,56(sp)
    80000202:	7a42                	ld	s4,48(sp)
    80000204:	7aa2                	ld	s5,40(sp)
    80000206:	7b02                	ld	s6,32(sp)
    80000208:	6125                	addi	sp,sp,96
    8000020a:	8082                	ret
      if(n < target){
    8000020c:	0009871b          	sext.w	a4,s3
    80000210:	01677a63          	bgeu	a4,s6,80000224 <consoleread+0xee>
        cons.r--;
    80000214:	00010717          	auipc	a4,0x10
    80000218:	80f72a23          	sw	a5,-2028(a4) # 8000fa28 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	0000f517          	auipc	a0,0xf
    8000022e:	76650513          	addi	a0,a0,1894 # 8000f990 <cons>
    80000232:	25b000ef          	jal	80000c8c <release>
  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	bf7d                	j	800001f8 <consoleread+0xc2>
    8000023c:	6be2                	ld	s7,24(sp)
    8000023e:	b7f5                	j	8000022a <consoleread+0xf4>

0000000080000240 <consputc>:
{
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e406                	sd	ra,8(sp)
    80000244:	e022                	sd	s0,0(sp)
    80000246:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000248:	10000793          	li	a5,256
    8000024c:	00f50863          	beq	a0,a5,8000025c <consputc+0x1c>
    uartputc_sync(c);
    80000250:	604000ef          	jal	80000854 <uartputc_sync>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000025c:	4521                	li	a0,8
    8000025e:	5f6000ef          	jal	80000854 <uartputc_sync>
    80000262:	02000513          	li	a0,32
    80000266:	5ee000ef          	jal	80000854 <uartputc_sync>
    8000026a:	4521                	li	a0,8
    8000026c:	5e8000ef          	jal	80000854 <uartputc_sync>
    80000270:	b7d5                	j	80000254 <consputc+0x14>

0000000080000272 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000272:	1101                	addi	sp,sp,-32
    80000274:	ec06                	sd	ra,24(sp)
    80000276:	e822                	sd	s0,16(sp)
    80000278:	e426                	sd	s1,8(sp)
    8000027a:	1000                	addi	s0,sp,32
    8000027c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000027e:	0000f517          	auipc	a0,0xf
    80000282:	71250513          	addi	a0,a0,1810 # 8000f990 <cons>
    80000286:	16f000ef          	jal	80000bf4 <acquire>

  switch(c){
    8000028a:	47d5                	li	a5,21
    8000028c:	08f48f63          	beq	s1,a5,8000032a <consoleintr+0xb8>
    80000290:	0297c563          	blt	a5,s1,800002ba <consoleintr+0x48>
    80000294:	47a1                	li	a5,8
    80000296:	0ef48463          	beq	s1,a5,8000037e <consoleintr+0x10c>
    8000029a:	47c1                	li	a5,16
    8000029c:	10f49563          	bne	s1,a5,800003a6 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800002a0:	62b010ef          	jal	800020ca <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002a4:	0000f517          	auipc	a0,0xf
    800002a8:	6ec50513          	addi	a0,a0,1772 # 8000f990 <cons>
    800002ac:	1e1000ef          	jal	80000c8c <release>
}
    800002b0:	60e2                	ld	ra,24(sp)
    800002b2:	6442                	ld	s0,16(sp)
    800002b4:	64a2                	ld	s1,8(sp)
    800002b6:	6105                	addi	sp,sp,32
    800002b8:	8082                	ret
  switch(c){
    800002ba:	07f00793          	li	a5,127
    800002be:	0cf48063          	beq	s1,a5,8000037e <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002c2:	0000f717          	auipc	a4,0xf
    800002c6:	6ce70713          	addi	a4,a4,1742 # 8000f990 <cons>
    800002ca:	0a072783          	lw	a5,160(a4)
    800002ce:	09872703          	lw	a4,152(a4)
    800002d2:	9f99                	subw	a5,a5,a4
    800002d4:	07f00713          	li	a4,127
    800002d8:	fcf766e3          	bltu	a4,a5,800002a4 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800002dc:	47b5                	li	a5,13
    800002de:	0cf48763          	beq	s1,a5,800003ac <consoleintr+0x13a>
      consputc(c);
    800002e2:	8526                	mv	a0,s1
    800002e4:	f5dff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002e8:	0000f797          	auipc	a5,0xf
    800002ec:	6a878793          	addi	a5,a5,1704 # 8000f990 <cons>
    800002f0:	0a07a683          	lw	a3,160(a5)
    800002f4:	0016871b          	addiw	a4,a3,1
    800002f8:	0007061b          	sext.w	a2,a4
    800002fc:	0ae7a023          	sw	a4,160(a5)
    80000300:	07f6f693          	andi	a3,a3,127
    80000304:	97b6                	add	a5,a5,a3
    80000306:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000030a:	47a9                	li	a5,10
    8000030c:	0cf48563          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000310:	4791                	li	a5,4
    80000312:	0cf48263          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000316:	0000f797          	auipc	a5,0xf
    8000031a:	7127a783          	lw	a5,1810(a5) # 8000fa28 <cons+0x98>
    8000031e:	9f1d                	subw	a4,a4,a5
    80000320:	08000793          	li	a5,128
    80000324:	f8f710e3          	bne	a4,a5,800002a4 <consoleintr+0x32>
    80000328:	a07d                	j	800003d6 <consoleintr+0x164>
    8000032a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000032c:	0000f717          	auipc	a4,0xf
    80000330:	66470713          	addi	a4,a4,1636 # 8000f990 <cons>
    80000334:	0a072783          	lw	a5,160(a4)
    80000338:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000033c:	0000f497          	auipc	s1,0xf
    80000340:	65448493          	addi	s1,s1,1620 # 8000f990 <cons>
    while(cons.e != cons.w &&
    80000344:	4929                	li	s2,10
    80000346:	02f70863          	beq	a4,a5,80000376 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	37fd                	addiw	a5,a5,-1
    8000034c:	07f7f713          	andi	a4,a5,127
    80000350:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000352:	01874703          	lbu	a4,24(a4)
    80000356:	03270263          	beq	a4,s2,8000037a <consoleintr+0x108>
      cons.e--;
    8000035a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000035e:	10000513          	li	a0,256
    80000362:	edfff0ef          	jal	80000240 <consputc>
    while(cons.e != cons.w &&
    80000366:	0a04a783          	lw	a5,160(s1)
    8000036a:	09c4a703          	lw	a4,156(s1)
    8000036e:	fcf71ee3          	bne	a4,a5,8000034a <consoleintr+0xd8>
    80000372:	6902                	ld	s2,0(sp)
    80000374:	bf05                	j	800002a4 <consoleintr+0x32>
    80000376:	6902                	ld	s2,0(sp)
    80000378:	b735                	j	800002a4 <consoleintr+0x32>
    8000037a:	6902                	ld	s2,0(sp)
    8000037c:	b725                	j	800002a4 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000037e:	0000f717          	auipc	a4,0xf
    80000382:	61270713          	addi	a4,a4,1554 # 8000f990 <cons>
    80000386:	0a072783          	lw	a5,160(a4)
    8000038a:	09c72703          	lw	a4,156(a4)
    8000038e:	f0f70be3          	beq	a4,a5,800002a4 <consoleintr+0x32>
      cons.e--;
    80000392:	37fd                	addiw	a5,a5,-1
    80000394:	0000f717          	auipc	a4,0xf
    80000398:	68f72e23          	sw	a5,1692(a4) # 8000fa30 <cons+0xa0>
      consputc(BACKSPACE);
    8000039c:	10000513          	li	a0,256
    800003a0:	ea1ff0ef          	jal	80000240 <consputc>
    800003a4:	b701                	j	800002a4 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003a6:	ee048fe3          	beqz	s1,800002a4 <consoleintr+0x32>
    800003aa:	bf21                	j	800002c2 <consoleintr+0x50>
      consputc(c);
    800003ac:	4529                	li	a0,10
    800003ae:	e93ff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003b2:	0000f797          	auipc	a5,0xf
    800003b6:	5de78793          	addi	a5,a5,1502 # 8000f990 <cons>
    800003ba:	0a07a703          	lw	a4,160(a5)
    800003be:	0017069b          	addiw	a3,a4,1
    800003c2:	0006861b          	sext.w	a2,a3
    800003c6:	0ad7a023          	sw	a3,160(a5)
    800003ca:	07f77713          	andi	a4,a4,127
    800003ce:	97ba                	add	a5,a5,a4
    800003d0:	4729                	li	a4,10
    800003d2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003d6:	0000f797          	auipc	a5,0xf
    800003da:	64c7ab23          	sw	a2,1622(a5) # 8000fa2c <cons+0x9c>
        wakeup(&cons.r);
    800003de:	0000f517          	auipc	a0,0xf
    800003e2:	64a50513          	addi	a0,a0,1610 # 8000fa28 <cons+0x98>
    800003e6:	141010ef          	jal	80001d26 <wakeup>
    800003ea:	bd6d                	j	800002a4 <consoleintr+0x32>

00000000800003ec <consoleinit>:

void
consoleinit(void)
{
    800003ec:	1141                	addi	sp,sp,-16
    800003ee:	e406                	sd	ra,8(sp)
    800003f0:	e022                	sd	s0,0(sp)
    800003f2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800003f4:	00007597          	auipc	a1,0x7
    800003f8:	c0c58593          	addi	a1,a1,-1012 # 80007000 <etext>
    800003fc:	0000f517          	auipc	a0,0xf
    80000400:	59450513          	addi	a0,a0,1428 # 8000f990 <cons>
    80000404:	770000ef          	jal	80000b74 <initlock>

  uartinit();
    80000408:	3f4000ef          	jal	800007fc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000040c:	00020797          	auipc	a5,0x20
    80000410:	bac78793          	addi	a5,a5,-1108 # 8001ffb8 <devsw>
    80000414:	00000717          	auipc	a4,0x0
    80000418:	d2270713          	addi	a4,a4,-734 # 80000136 <consoleread>
    8000041c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000041e:	00000717          	auipc	a4,0x0
    80000422:	cb270713          	addi	a4,a4,-846 # 800000d0 <consolewrite>
    80000426:	ef98                	sd	a4,24(a5)
    80000428:	60a2                	ld	ra,8(sp)
    8000042a:	6402                	ld	s0,0(sp)
    8000042c:	0141                	addi	sp,sp,16
    8000042e:	8082                	ret

0000000080000430 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000430:	7179                	addi	sp,sp,-48
    80000432:	f406                	sd	ra,40(sp)
    80000434:	f022                	sd	s0,32(sp)
    80000436:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000438:	c219                	beqz	a2,8000043e <printint+0xe>
    8000043a:	08054063          	bltz	a0,800004ba <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000043e:	4881                	li	a7,0
    80000440:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000444:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000446:	00007617          	auipc	a2,0x7
    8000044a:	3aa60613          	addi	a2,a2,938 # 800077f0 <digits>
    8000044e:	883e                	mv	a6,a5
    80000450:	2785                	addiw	a5,a5,1
    80000452:	02b57733          	remu	a4,a0,a1
    80000456:	9732                	add	a4,a4,a2
    80000458:	00074703          	lbu	a4,0(a4)
    8000045c:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000460:	872a                	mv	a4,a0
    80000462:	02b55533          	divu	a0,a0,a1
    80000466:	0685                	addi	a3,a3,1
    80000468:	feb773e3          	bgeu	a4,a1,8000044e <printint+0x1e>

  if(sign)
    8000046c:	00088a63          	beqz	a7,80000480 <printint+0x50>
    buf[i++] = '-';
    80000470:	1781                	addi	a5,a5,-32
    80000472:	97a2                	add	a5,a5,s0
    80000474:	02d00713          	li	a4,45
    80000478:	fee78823          	sb	a4,-16(a5)
    8000047c:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80000480:	02f05963          	blez	a5,800004b2 <printint+0x82>
    80000484:	ec26                	sd	s1,24(sp)
    80000486:	e84a                	sd	s2,16(sp)
    80000488:	fd040713          	addi	a4,s0,-48
    8000048c:	00f704b3          	add	s1,a4,a5
    80000490:	fff70913          	addi	s2,a4,-1
    80000494:	993e                	add	s2,s2,a5
    80000496:	37fd                	addiw	a5,a5,-1
    80000498:	1782                	slli	a5,a5,0x20
    8000049a:	9381                	srli	a5,a5,0x20
    8000049c:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004a0:	fff4c503          	lbu	a0,-1(s1)
    800004a4:	d9dff0ef          	jal	80000240 <consputc>
  while(--i >= 0)
    800004a8:	14fd                	addi	s1,s1,-1
    800004aa:	ff249be3          	bne	s1,s2,800004a0 <printint+0x70>
    800004ae:	64e2                	ld	s1,24(sp)
    800004b0:	6942                	ld	s2,16(sp)
}
    800004b2:	70a2                	ld	ra,40(sp)
    800004b4:	7402                	ld	s0,32(sp)
    800004b6:	6145                	addi	sp,sp,48
    800004b8:	8082                	ret
    x = -xx;
    800004ba:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004be:	4885                	li	a7,1
    x = -xx;
    800004c0:	b741                	j	80000440 <printint+0x10>

00000000800004c2 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004c2:	7155                	addi	sp,sp,-208
    800004c4:	e506                	sd	ra,136(sp)
    800004c6:	e122                	sd	s0,128(sp)
    800004c8:	f0d2                	sd	s4,96(sp)
    800004ca:	0900                	addi	s0,sp,144
    800004cc:	8a2a                	mv	s4,a0
    800004ce:	e40c                	sd	a1,8(s0)
    800004d0:	e810                	sd	a2,16(s0)
    800004d2:	ec14                	sd	a3,24(s0)
    800004d4:	f018                	sd	a4,32(s0)
    800004d6:	f41c                	sd	a5,40(s0)
    800004d8:	03043823          	sd	a6,48(s0)
    800004dc:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004e0:	0000f797          	auipc	a5,0xf
    800004e4:	5707a783          	lw	a5,1392(a5) # 8000fa50 <pr+0x18>
    800004e8:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004ec:	e3a1                	bnez	a5,8000052c <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004ee:	00840793          	addi	a5,s0,8
    800004f2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004f6:	00054503          	lbu	a0,0(a0)
    800004fa:	26050763          	beqz	a0,80000768 <printf+0x2a6>
    800004fe:	fca6                	sd	s1,120(sp)
    80000500:	f8ca                	sd	s2,112(sp)
    80000502:	f4ce                	sd	s3,104(sp)
    80000504:	ecd6                	sd	s5,88(sp)
    80000506:	e8da                	sd	s6,80(sp)
    80000508:	e0e2                	sd	s8,64(sp)
    8000050a:	fc66                	sd	s9,56(sp)
    8000050c:	f86a                	sd	s10,48(sp)
    8000050e:	f46e                	sd	s11,40(sp)
    80000510:	4981                	li	s3,0
    if(cx != '%'){
    80000512:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000516:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000051a:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000051e:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000522:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000526:	07000d93          	li	s11,112
    8000052a:	a815                	j	8000055e <printf+0x9c>
    acquire(&pr.lock);
    8000052c:	0000f517          	auipc	a0,0xf
    80000530:	50c50513          	addi	a0,a0,1292 # 8000fa38 <pr>
    80000534:	6c0000ef          	jal	80000bf4 <acquire>
  va_start(ap, fmt);
    80000538:	00840793          	addi	a5,s0,8
    8000053c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000540:	000a4503          	lbu	a0,0(s4)
    80000544:	fd4d                	bnez	a0,800004fe <printf+0x3c>
    80000546:	a481                	j	80000786 <printf+0x2c4>
      consputc(cx);
    80000548:	cf9ff0ef          	jal	80000240 <consputc>
      continue;
    8000054c:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054e:	0014899b          	addiw	s3,s1,1
    80000552:	013a07b3          	add	a5,s4,s3
    80000556:	0007c503          	lbu	a0,0(a5)
    8000055a:	1e050b63          	beqz	a0,80000750 <printf+0x28e>
    if(cx != '%'){
    8000055e:	ff5515e3          	bne	a0,s5,80000548 <printf+0x86>
    i++;
    80000562:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000566:	009a07b3          	add	a5,s4,s1
    8000056a:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000056e:	1e090163          	beqz	s2,80000750 <printf+0x28e>
    80000572:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000576:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000578:	c789                	beqz	a5,80000582 <printf+0xc0>
    8000057a:	009a0733          	add	a4,s4,s1
    8000057e:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000582:	03690763          	beq	s2,s6,800005b0 <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80000586:	05890163          	beq	s2,s8,800005c8 <printf+0x106>
    } else if(c0 == 'u'){
    8000058a:	0d990b63          	beq	s2,s9,80000660 <printf+0x19e>
    } else if(c0 == 'x'){
    8000058e:	13a90163          	beq	s2,s10,800006b0 <printf+0x1ee>
    } else if(c0 == 'p'){
    80000592:	13b90b63          	beq	s2,s11,800006c8 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80000596:	07300793          	li	a5,115
    8000059a:	16f90a63          	beq	s2,a5,8000070e <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000059e:	1b590463          	beq	s2,s5,80000746 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005a2:	8556                	mv	a0,s5
    800005a4:	c9dff0ef          	jal	80000240 <consputc>
      consputc(c0);
    800005a8:	854a                	mv	a0,s2
    800005aa:	c97ff0ef          	jal	80000240 <consputc>
    800005ae:	b745                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005b0:	f8843783          	ld	a5,-120(s0)
    800005b4:	00878713          	addi	a4,a5,8
    800005b8:	f8e43423          	sd	a4,-120(s0)
    800005bc:	4605                	li	a2,1
    800005be:	45a9                	li	a1,10
    800005c0:	4388                	lw	a0,0(a5)
    800005c2:	e6fff0ef          	jal	80000430 <printint>
    800005c6:	b761                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005c8:	03678663          	beq	a5,s6,800005f4 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005cc:	05878263          	beq	a5,s8,80000610 <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800005d0:	0b978463          	beq	a5,s9,80000678 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800005d4:	fda797e3          	bne	a5,s10,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800005d8:	f8843783          	ld	a5,-120(s0)
    800005dc:	00878713          	addi	a4,a5,8
    800005e0:	f8e43423          	sd	a4,-120(s0)
    800005e4:	4601                	li	a2,0
    800005e6:	45c1                	li	a1,16
    800005e8:	6388                	ld	a0,0(a5)
    800005ea:	e47ff0ef          	jal	80000430 <printint>
      i += 1;
    800005ee:	0029849b          	addiw	s1,s3,2
    800005f2:	bfb1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800005f4:	f8843783          	ld	a5,-120(s0)
    800005f8:	00878713          	addi	a4,a5,8
    800005fc:	f8e43423          	sd	a4,-120(s0)
    80000600:	4605                	li	a2,1
    80000602:	45a9                	li	a1,10
    80000604:	6388                	ld	a0,0(a5)
    80000606:	e2bff0ef          	jal	80000430 <printint>
      i += 1;
    8000060a:	0029849b          	addiw	s1,s3,2
    8000060e:	b781                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000610:	06400793          	li	a5,100
    80000614:	02f68863          	beq	a3,a5,80000644 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000618:	07500793          	li	a5,117
    8000061c:	06f68c63          	beq	a3,a5,80000694 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000620:	07800793          	li	a5,120
    80000624:	f6f69fe3          	bne	a3,a5,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80000628:	f8843783          	ld	a5,-120(s0)
    8000062c:	00878713          	addi	a4,a5,8
    80000630:	f8e43423          	sd	a4,-120(s0)
    80000634:	4601                	li	a2,0
    80000636:	45c1                	li	a1,16
    80000638:	6388                	ld	a0,0(a5)
    8000063a:	df7ff0ef          	jal	80000430 <printint>
      i += 2;
    8000063e:	0039849b          	addiw	s1,s3,3
    80000642:	b731                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4605                	li	a2,1
    80000652:	45a9                	li	a1,10
    80000654:	6388                	ld	a0,0(a5)
    80000656:	ddbff0ef          	jal	80000430 <printint>
      i += 2;
    8000065a:	0039849b          	addiw	s1,s3,3
    8000065e:	bdc5                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    80000660:	f8843783          	ld	a5,-120(s0)
    80000664:	00878713          	addi	a4,a5,8
    80000668:	f8e43423          	sd	a4,-120(s0)
    8000066c:	4601                	li	a2,0
    8000066e:	45a9                	li	a1,10
    80000670:	4388                	lw	a0,0(a5)
    80000672:	dbfff0ef          	jal	80000430 <printint>
    80000676:	bde1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	4601                	li	a2,0
    80000686:	45a9                	li	a1,10
    80000688:	6388                	ld	a0,0(a5)
    8000068a:	da7ff0ef          	jal	80000430 <printint>
      i += 1;
    8000068e:	0029849b          	addiw	s1,s3,2
    80000692:	bd75                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000694:	f8843783          	ld	a5,-120(s0)
    80000698:	00878713          	addi	a4,a5,8
    8000069c:	f8e43423          	sd	a4,-120(s0)
    800006a0:	4601                	li	a2,0
    800006a2:	45a9                	li	a1,10
    800006a4:	6388                	ld	a0,0(a5)
    800006a6:	d8bff0ef          	jal	80000430 <printint>
      i += 2;
    800006aa:	0039849b          	addiw	s1,s3,3
    800006ae:	b545                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006b0:	f8843783          	ld	a5,-120(s0)
    800006b4:	00878713          	addi	a4,a5,8
    800006b8:	f8e43423          	sd	a4,-120(s0)
    800006bc:	4601                	li	a2,0
    800006be:	45c1                	li	a1,16
    800006c0:	4388                	lw	a0,0(a5)
    800006c2:	d6fff0ef          	jal	80000430 <printint>
    800006c6:	b561                	j	8000054e <printf+0x8c>
    800006c8:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006ca:	f8843783          	ld	a5,-120(s0)
    800006ce:	00878713          	addi	a4,a5,8
    800006d2:	f8e43423          	sd	a4,-120(s0)
    800006d6:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006da:	03000513          	li	a0,48
    800006de:	b63ff0ef          	jal	80000240 <consputc>
  consputc('x');
    800006e2:	07800513          	li	a0,120
    800006e6:	b5bff0ef          	jal	80000240 <consputc>
    800006ea:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ec:	00007b97          	auipc	s7,0x7
    800006f0:	104b8b93          	addi	s7,s7,260 # 800077f0 <digits>
    800006f4:	03c9d793          	srli	a5,s3,0x3c
    800006f8:	97de                	add	a5,a5,s7
    800006fa:	0007c503          	lbu	a0,0(a5)
    800006fe:	b43ff0ef          	jal	80000240 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000702:	0992                	slli	s3,s3,0x4
    80000704:	397d                	addiw	s2,s2,-1
    80000706:	fe0917e3          	bnez	s2,800006f4 <printf+0x232>
    8000070a:	6ba6                	ld	s7,72(sp)
    8000070c:	b589                	j	8000054e <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000070e:	f8843783          	ld	a5,-120(s0)
    80000712:	00878713          	addi	a4,a5,8
    80000716:	f8e43423          	sd	a4,-120(s0)
    8000071a:	0007b903          	ld	s2,0(a5)
    8000071e:	00090d63          	beqz	s2,80000738 <printf+0x276>
      for(; *s; s++)
    80000722:	00094503          	lbu	a0,0(s2)
    80000726:	e20504e3          	beqz	a0,8000054e <printf+0x8c>
        consputc(*s);
    8000072a:	b17ff0ef          	jal	80000240 <consputc>
      for(; *s; s++)
    8000072e:	0905                	addi	s2,s2,1
    80000730:	00094503          	lbu	a0,0(s2)
    80000734:	f97d                	bnez	a0,8000072a <printf+0x268>
    80000736:	bd21                	j	8000054e <printf+0x8c>
        s = "(null)";
    80000738:	00007917          	auipc	s2,0x7
    8000073c:	8d090913          	addi	s2,s2,-1840 # 80007008 <etext+0x8>
      for(; *s; s++)
    80000740:	02800513          	li	a0,40
    80000744:	b7dd                	j	8000072a <printf+0x268>
      consputc('%');
    80000746:	02500513          	li	a0,37
    8000074a:	af7ff0ef          	jal	80000240 <consputc>
    8000074e:	b501                	j	8000054e <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80000750:	f7843783          	ld	a5,-136(s0)
    80000754:	e385                	bnez	a5,80000774 <printf+0x2b2>
    80000756:	74e6                	ld	s1,120(sp)
    80000758:	7946                	ld	s2,112(sp)
    8000075a:	79a6                	ld	s3,104(sp)
    8000075c:	6ae6                	ld	s5,88(sp)
    8000075e:	6b46                	ld	s6,80(sp)
    80000760:	6c06                	ld	s8,64(sp)
    80000762:	7ce2                	ld	s9,56(sp)
    80000764:	7d42                	ld	s10,48(sp)
    80000766:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80000768:	4501                	li	a0,0
    8000076a:	60aa                	ld	ra,136(sp)
    8000076c:	640a                	ld	s0,128(sp)
    8000076e:	7a06                	ld	s4,96(sp)
    80000770:	6169                	addi	sp,sp,208
    80000772:	8082                	ret
    80000774:	74e6                	ld	s1,120(sp)
    80000776:	7946                	ld	s2,112(sp)
    80000778:	79a6                	ld	s3,104(sp)
    8000077a:	6ae6                	ld	s5,88(sp)
    8000077c:	6b46                	ld	s6,80(sp)
    8000077e:	6c06                	ld	s8,64(sp)
    80000780:	7ce2                	ld	s9,56(sp)
    80000782:	7d42                	ld	s10,48(sp)
    80000784:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80000786:	0000f517          	auipc	a0,0xf
    8000078a:	2b250513          	addi	a0,a0,690 # 8000fa38 <pr>
    8000078e:	4fe000ef          	jal	80000c8c <release>
    80000792:	bfd9                	j	80000768 <printf+0x2a6>

0000000080000794 <panic>:

void
panic(char *s)
{
    80000794:	1101                	addi	sp,sp,-32
    80000796:	ec06                	sd	ra,24(sp)
    80000798:	e822                	sd	s0,16(sp)
    8000079a:	e426                	sd	s1,8(sp)
    8000079c:	1000                	addi	s0,sp,32
    8000079e:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007a0:	0000f797          	auipc	a5,0xf
    800007a4:	2a07a823          	sw	zero,688(a5) # 8000fa50 <pr+0x18>
  printf("panic: ");
    800007a8:	00007517          	auipc	a0,0x7
    800007ac:	87050513          	addi	a0,a0,-1936 # 80007018 <etext+0x18>
    800007b0:	d13ff0ef          	jal	800004c2 <printf>
  printf("%s\n", s);
    800007b4:	85a6                	mv	a1,s1
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	86a50513          	addi	a0,a0,-1942 # 80007020 <etext+0x20>
    800007be:	d05ff0ef          	jal	800004c2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007c2:	4785                	li	a5,1
    800007c4:	00007717          	auipc	a4,0x7
    800007c8:	18f72623          	sw	a5,396(a4) # 80007950 <panicked>
  for(;;)
    800007cc:	a001                	j	800007cc <panic+0x38>

00000000800007ce <printfinit>:
    ;
}

void
printfinit(void)
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007d8:	0000f497          	auipc	s1,0xf
    800007dc:	26048493          	addi	s1,s1,608 # 8000fa38 <pr>
    800007e0:	00007597          	auipc	a1,0x7
    800007e4:	84858593          	addi	a1,a1,-1976 # 80007028 <etext+0x28>
    800007e8:	8526                	mv	a0,s1
    800007ea:	38a000ef          	jal	80000b74 <initlock>
  pr.locking = 1;
    800007ee:	4785                	li	a5,1
    800007f0:	cc9c                	sw	a5,24(s1)
}
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007fc:	1141                	addi	sp,sp,-16
    800007fe:	e406                	sd	ra,8(sp)
    80000800:	e022                	sd	s0,0(sp)
    80000802:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000804:	100007b7          	lui	a5,0x10000
    80000808:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000080c:	10000737          	lui	a4,0x10000
    80000810:	f8000693          	li	a3,-128
    80000814:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000818:	468d                	li	a3,3
    8000081a:	10000637          	lui	a2,0x10000
    8000081e:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000822:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000826:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000082a:	10000737          	lui	a4,0x10000
    8000082e:	461d                	li	a2,7
    80000830:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000834:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000838:	00006597          	auipc	a1,0x6
    8000083c:	7f858593          	addi	a1,a1,2040 # 80007030 <etext+0x30>
    80000840:	0000f517          	auipc	a0,0xf
    80000844:	21850513          	addi	a0,a0,536 # 8000fa58 <uart_tx_lock>
    80000848:	32c000ef          	jal	80000b74 <initlock>
}
    8000084c:	60a2                	ld	ra,8(sp)
    8000084e:	6402                	ld	s0,0(sp)
    80000850:	0141                	addi	sp,sp,16
    80000852:	8082                	ret

0000000080000854 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	1000                	addi	s0,sp,32
    8000085e:	84aa                	mv	s1,a0
  push_off();
    80000860:	354000ef          	jal	80000bb4 <push_off>

  if(panicked){
    80000864:	00007797          	auipc	a5,0x7
    80000868:	0ec7a783          	lw	a5,236(a5) # 80007950 <panicked>
    8000086c:	e795                	bnez	a5,80000898 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000086e:	10000737          	lui	a4,0x10000
    80000872:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000874:	00074783          	lbu	a5,0(a4)
    80000878:	0207f793          	andi	a5,a5,32
    8000087c:	dfe5                	beqz	a5,80000874 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000087e:	0ff4f513          	zext.b	a0,s1
    80000882:	100007b7          	lui	a5,0x10000
    80000886:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000088a:	3ae000ef          	jal	80000c38 <pop_off>
}
    8000088e:	60e2                	ld	ra,24(sp)
    80000890:	6442                	ld	s0,16(sp)
    80000892:	64a2                	ld	s1,8(sp)
    80000894:	6105                	addi	sp,sp,32
    80000896:	8082                	ret
    for(;;)
    80000898:	a001                	j	80000898 <uartputc_sync+0x44>

000000008000089a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000089a:	00007797          	auipc	a5,0x7
    8000089e:	0be7b783          	ld	a5,190(a5) # 80007958 <uart_tx_r>
    800008a2:	00007717          	auipc	a4,0x7
    800008a6:	0be73703          	ld	a4,190(a4) # 80007960 <uart_tx_w>
    800008aa:	08f70263          	beq	a4,a5,8000092e <uartstart+0x94>
{
    800008ae:	7139                	addi	sp,sp,-64
    800008b0:	fc06                	sd	ra,56(sp)
    800008b2:	f822                	sd	s0,48(sp)
    800008b4:	f426                	sd	s1,40(sp)
    800008b6:	f04a                	sd	s2,32(sp)
    800008b8:	ec4e                	sd	s3,24(sp)
    800008ba:	e852                	sd	s4,16(sp)
    800008bc:	e456                	sd	s5,8(sp)
    800008be:	e05a                	sd	s6,0(sp)
    800008c0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008c2:	10000937          	lui	s2,0x10000
    800008c6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008c8:	0000fa97          	auipc	s5,0xf
    800008cc:	190a8a93          	addi	s5,s5,400 # 8000fa58 <uart_tx_lock>
    uart_tx_r += 1;
    800008d0:	00007497          	auipc	s1,0x7
    800008d4:	08848493          	addi	s1,s1,136 # 80007958 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008d8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008dc:	00007997          	auipc	s3,0x7
    800008e0:	08498993          	addi	s3,s3,132 # 80007960 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008e4:	00094703          	lbu	a4,0(s2)
    800008e8:	02077713          	andi	a4,a4,32
    800008ec:	c71d                	beqz	a4,8000091a <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ee:	01f7f713          	andi	a4,a5,31
    800008f2:	9756                	add	a4,a4,s5
    800008f4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008f8:	0785                	addi	a5,a5,1
    800008fa:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008fc:	8526                	mv	a0,s1
    800008fe:	428010ef          	jal	80001d26 <wakeup>
    WriteReg(THR, c);
    80000902:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000906:	609c                	ld	a5,0(s1)
    80000908:	0009b703          	ld	a4,0(s3)
    8000090c:	fcf71ce3          	bne	a4,a5,800008e4 <uartstart+0x4a>
      ReadReg(ISR);
    80000910:	100007b7          	lui	a5,0x10000
    80000914:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000916:	0007c783          	lbu	a5,0(a5)
  }
}
    8000091a:	70e2                	ld	ra,56(sp)
    8000091c:	7442                	ld	s0,48(sp)
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	69e2                	ld	s3,24(sp)
    80000924:	6a42                	ld	s4,16(sp)
    80000926:	6aa2                	ld	s5,8(sp)
    80000928:	6b02                	ld	s6,0(sp)
    8000092a:	6121                	addi	sp,sp,64
    8000092c:	8082                	ret
      ReadReg(ISR);
    8000092e:	100007b7          	lui	a5,0x10000
    80000932:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000934:	0007c783          	lbu	a5,0(a5)
      return;
    80000938:	8082                	ret

000000008000093a <uartputc>:
{
    8000093a:	7179                	addi	sp,sp,-48
    8000093c:	f406                	sd	ra,40(sp)
    8000093e:	f022                	sd	s0,32(sp)
    80000940:	ec26                	sd	s1,24(sp)
    80000942:	e84a                	sd	s2,16(sp)
    80000944:	e44e                	sd	s3,8(sp)
    80000946:	e052                	sd	s4,0(sp)
    80000948:	1800                	addi	s0,sp,48
    8000094a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000094c:	0000f517          	auipc	a0,0xf
    80000950:	10c50513          	addi	a0,a0,268 # 8000fa58 <uart_tx_lock>
    80000954:	2a0000ef          	jal	80000bf4 <acquire>
  if(panicked){
    80000958:	00007797          	auipc	a5,0x7
    8000095c:	ff87a783          	lw	a5,-8(a5) # 80007950 <panicked>
    80000960:	efbd                	bnez	a5,800009de <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000962:	00007717          	auipc	a4,0x7
    80000966:	ffe73703          	ld	a4,-2(a4) # 80007960 <uart_tx_w>
    8000096a:	00007797          	auipc	a5,0x7
    8000096e:	fee7b783          	ld	a5,-18(a5) # 80007958 <uart_tx_r>
    80000972:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000976:	0000f997          	auipc	s3,0xf
    8000097a:	0e298993          	addi	s3,s3,226 # 8000fa58 <uart_tx_lock>
    8000097e:	00007497          	auipc	s1,0x7
    80000982:	fda48493          	addi	s1,s1,-38 # 80007958 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00007917          	auipc	s2,0x7
    8000098a:	fda90913          	addi	s2,s2,-38 # 80007960 <uart_tx_w>
    8000098e:	00e79d63          	bne	a5,a4,800009a8 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000992:	85ce                	mv	a1,s3
    80000994:	8526                	mv	a0,s1
    80000996:	344010ef          	jal	80001cda <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099a:	00093703          	ld	a4,0(s2)
    8000099e:	609c                	ld	a5,0(s1)
    800009a0:	02078793          	addi	a5,a5,32
    800009a4:	fee787e3          	beq	a5,a4,80000992 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a8:	0000f497          	auipc	s1,0xf
    800009ac:	0b048493          	addi	s1,s1,176 # 8000fa58 <uart_tx_lock>
    800009b0:	01f77793          	andi	a5,a4,31
    800009b4:	97a6                	add	a5,a5,s1
    800009b6:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009ba:	0705                	addi	a4,a4,1
    800009bc:	00007797          	auipc	a5,0x7
    800009c0:	fae7b223          	sd	a4,-92(a5) # 80007960 <uart_tx_w>
  uartstart();
    800009c4:	ed7ff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    800009c8:	8526                	mv	a0,s1
    800009ca:	2c2000ef          	jal	80000c8c <release>
}
    800009ce:	70a2                	ld	ra,40(sp)
    800009d0:	7402                	ld	s0,32(sp)
    800009d2:	64e2                	ld	s1,24(sp)
    800009d4:	6942                	ld	s2,16(sp)
    800009d6:	69a2                	ld	s3,8(sp)
    800009d8:	6a02                	ld	s4,0(sp)
    800009da:	6145                	addi	sp,sp,48
    800009dc:	8082                	ret
    for(;;)
    800009de:	a001                	j	800009de <uartputc+0xa4>

00000000800009e0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009e0:	1141                	addi	sp,sp,-16
    800009e2:	e422                	sd	s0,8(sp)
    800009e4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009e6:	100007b7          	lui	a5,0x10000
    800009ea:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009ec:	0007c783          	lbu	a5,0(a5)
    800009f0:	8b85                	andi	a5,a5,1
    800009f2:	cb81                	beqz	a5,80000a02 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009f4:	100007b7          	lui	a5,0x10000
    800009f8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009fc:	6422                	ld	s0,8(sp)
    800009fe:	0141                	addi	sp,sp,16
    80000a00:	8082                	ret
    return -1;
    80000a02:	557d                	li	a0,-1
    80000a04:	bfe5                	j	800009fc <uartgetc+0x1c>

0000000080000a06 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a06:	1101                	addi	sp,sp,-32
    80000a08:	ec06                	sd	ra,24(sp)
    80000a0a:	e822                	sd	s0,16(sp)
    80000a0c:	e426                	sd	s1,8(sp)
    80000a0e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a10:	54fd                	li	s1,-1
    80000a12:	a019                	j	80000a18 <uartintr+0x12>
      break;
    consoleintr(c);
    80000a14:	85fff0ef          	jal	80000272 <consoleintr>
    int c = uartgetc();
    80000a18:	fc9ff0ef          	jal	800009e0 <uartgetc>
    if(c == -1)
    80000a1c:	fe951ce3          	bne	a0,s1,80000a14 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a20:	0000f497          	auipc	s1,0xf
    80000a24:	03848493          	addi	s1,s1,56 # 8000fa58 <uart_tx_lock>
    80000a28:	8526                	mv	a0,s1
    80000a2a:	1ca000ef          	jal	80000bf4 <acquire>
  uartstart();
    80000a2e:	e6dff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    80000a32:	8526                	mv	a0,s1
    80000a34:	258000ef          	jal	80000c8c <release>
}
    80000a38:	60e2                	ld	ra,24(sp)
    80000a3a:	6442                	ld	s0,16(sp)
    80000a3c:	64a2                	ld	s1,8(sp)
    80000a3e:	6105                	addi	sp,sp,32
    80000a40:	8082                	ret

0000000080000a42 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a42:	1101                	addi	sp,sp,-32
    80000a44:	ec06                	sd	ra,24(sp)
    80000a46:	e822                	sd	s0,16(sp)
    80000a48:	e426                	sd	s1,8(sp)
    80000a4a:	e04a                	sd	s2,0(sp)
    80000a4c:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a4e:	03451793          	slli	a5,a0,0x34
    80000a52:	e7a9                	bnez	a5,80000a9c <kfree+0x5a>
    80000a54:	84aa                	mv	s1,a0
    80000a56:	00020797          	auipc	a5,0x20
    80000a5a:	6fa78793          	addi	a5,a5,1786 # 80021150 <end>
    80000a5e:	02f56f63          	bltu	a0,a5,80000a9c <kfree+0x5a>
    80000a62:	47c5                	li	a5,17
    80000a64:	07ee                	slli	a5,a5,0x1b
    80000a66:	02f57b63          	bgeu	a0,a5,80000a9c <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a6a:	6605                	lui	a2,0x1
    80000a6c:	4585                	li	a1,1
    80000a6e:	25a000ef          	jal	80000cc8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a72:	0000f917          	auipc	s2,0xf
    80000a76:	01e90913          	addi	s2,s2,30 # 8000fa90 <kmem>
    80000a7a:	854a                	mv	a0,s2
    80000a7c:	178000ef          	jal	80000bf4 <acquire>
  r->next = kmem.freelist;
    80000a80:	01893783          	ld	a5,24(s2)
    80000a84:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a86:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a8a:	854a                	mv	a0,s2
    80000a8c:	200000ef          	jal	80000c8c <release>
}
    80000a90:	60e2                	ld	ra,24(sp)
    80000a92:	6442                	ld	s0,16(sp)
    80000a94:	64a2                	ld	s1,8(sp)
    80000a96:	6902                	ld	s2,0(sp)
    80000a98:	6105                	addi	sp,sp,32
    80000a9a:	8082                	ret
    panic("kfree");
    80000a9c:	00006517          	auipc	a0,0x6
    80000aa0:	59c50513          	addi	a0,a0,1436 # 80007038 <etext+0x38>
    80000aa4:	cf1ff0ef          	jal	80000794 <panic>

0000000080000aa8 <freerange>:
{
    80000aa8:	7179                	addi	sp,sp,-48
    80000aaa:	f406                	sd	ra,40(sp)
    80000aac:	f022                	sd	s0,32(sp)
    80000aae:	ec26                	sd	s1,24(sp)
    80000ab0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab2:	6785                	lui	a5,0x1
    80000ab4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ab8:	00e504b3          	add	s1,a0,a4
    80000abc:	777d                	lui	a4,0xfffff
    80000abe:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac0:	94be                	add	s1,s1,a5
    80000ac2:	0295e263          	bltu	a1,s1,80000ae6 <freerange+0x3e>
    80000ac6:	e84a                	sd	s2,16(sp)
    80000ac8:	e44e                	sd	s3,8(sp)
    80000aca:	e052                	sd	s4,0(sp)
    80000acc:	892e                	mv	s2,a1
    kfree(p);
    80000ace:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad0:	6985                	lui	s3,0x1
    kfree(p);
    80000ad2:	01448533          	add	a0,s1,s4
    80000ad6:	f6dff0ef          	jal	80000a42 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ada:	94ce                	add	s1,s1,s3
    80000adc:	fe997be3          	bgeu	s2,s1,80000ad2 <freerange+0x2a>
    80000ae0:	6942                	ld	s2,16(sp)
    80000ae2:	69a2                	ld	s3,8(sp)
    80000ae4:	6a02                	ld	s4,0(sp)
}
    80000ae6:	70a2                	ld	ra,40(sp)
    80000ae8:	7402                	ld	s0,32(sp)
    80000aea:	64e2                	ld	s1,24(sp)
    80000aec:	6145                	addi	sp,sp,48
    80000aee:	8082                	ret

0000000080000af0 <kinit>:
{
    80000af0:	1141                	addi	sp,sp,-16
    80000af2:	e406                	sd	ra,8(sp)
    80000af4:	e022                	sd	s0,0(sp)
    80000af6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af8:	00006597          	auipc	a1,0x6
    80000afc:	54858593          	addi	a1,a1,1352 # 80007040 <etext+0x40>
    80000b00:	0000f517          	auipc	a0,0xf
    80000b04:	f9050513          	addi	a0,a0,-112 # 8000fa90 <kmem>
    80000b08:	06c000ef          	jal	80000b74 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b0c:	45c5                	li	a1,17
    80000b0e:	05ee                	slli	a1,a1,0x1b
    80000b10:	00020517          	auipc	a0,0x20
    80000b14:	64050513          	addi	a0,a0,1600 # 80021150 <end>
    80000b18:	f91ff0ef          	jal	80000aa8 <freerange>
}
    80000b1c:	60a2                	ld	ra,8(sp)
    80000b1e:	6402                	ld	s0,0(sp)
    80000b20:	0141                	addi	sp,sp,16
    80000b22:	8082                	ret

0000000080000b24 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b24:	1101                	addi	sp,sp,-32
    80000b26:	ec06                	sd	ra,24(sp)
    80000b28:	e822                	sd	s0,16(sp)
    80000b2a:	e426                	sd	s1,8(sp)
    80000b2c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b2e:	0000f497          	auipc	s1,0xf
    80000b32:	f6248493          	addi	s1,s1,-158 # 8000fa90 <kmem>
    80000b36:	8526                	mv	a0,s1
    80000b38:	0bc000ef          	jal	80000bf4 <acquire>
  r = kmem.freelist;
    80000b3c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3e:	c485                	beqz	s1,80000b66 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b40:	609c                	ld	a5,0(s1)
    80000b42:	0000f517          	auipc	a0,0xf
    80000b46:	f4e50513          	addi	a0,a0,-178 # 8000fa90 <kmem>
    80000b4a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b4c:	140000ef          	jal	80000c8c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b50:	6605                	lui	a2,0x1
    80000b52:	4595                	li	a1,5
    80000b54:	8526                	mv	a0,s1
    80000b56:	172000ef          	jal	80000cc8 <memset>
  return (void*)r;
}
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	60e2                	ld	ra,24(sp)
    80000b5e:	6442                	ld	s0,16(sp)
    80000b60:	64a2                	ld	s1,8(sp)
    80000b62:	6105                	addi	sp,sp,32
    80000b64:	8082                	ret
  release(&kmem.lock);
    80000b66:	0000f517          	auipc	a0,0xf
    80000b6a:	f2a50513          	addi	a0,a0,-214 # 8000fa90 <kmem>
    80000b6e:	11e000ef          	jal	80000c8c <release>
  if(r)
    80000b72:	b7e5                	j	80000b5a <kalloc+0x36>

0000000080000b74 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b74:	1141                	addi	sp,sp,-16
    80000b76:	e422                	sd	s0,8(sp)
    80000b78:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b7a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b7c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b80:	00053823          	sd	zero,16(a0)
}
    80000b84:	6422                	ld	s0,8(sp)
    80000b86:	0141                	addi	sp,sp,16
    80000b88:	8082                	ret

0000000080000b8a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b8a:	411c                	lw	a5,0(a0)
    80000b8c:	e399                	bnez	a5,80000b92 <holding+0x8>
    80000b8e:	4501                	li	a0,0
  return r;
}
    80000b90:	8082                	ret
{
    80000b92:	1101                	addi	sp,sp,-32
    80000b94:	ec06                	sd	ra,24(sp)
    80000b96:	e822                	sd	s0,16(sp)
    80000b98:	e426                	sd	s1,8(sp)
    80000b9a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b9c:	6904                	ld	s1,16(a0)
    80000b9e:	539000ef          	jal	800018d6 <mycpu>
    80000ba2:	40a48533          	sub	a0,s1,a0
    80000ba6:	00153513          	seqz	a0,a0
}
    80000baa:	60e2                	ld	ra,24(sp)
    80000bac:	6442                	ld	s0,16(sp)
    80000bae:	64a2                	ld	s1,8(sp)
    80000bb0:	6105                	addi	sp,sp,32
    80000bb2:	8082                	ret

0000000080000bb4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb4:	1101                	addi	sp,sp,-32
    80000bb6:	ec06                	sd	ra,24(sp)
    80000bb8:	e822                	sd	s0,16(sp)
    80000bba:	e426                	sd	s1,8(sp)
    80000bbc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bbe:	100024f3          	csrr	s1,sstatus
    80000bc2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bc8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bcc:	50b000ef          	jal	800018d6 <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cb99                	beqz	a5,80000be8 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	503000ef          	jal	800018d6 <mycpu>
    80000bd8:	5d3c                	lw	a5,120(a0)
    80000bda:	2785                	addiw	a5,a5,1
    80000bdc:	dd3c                	sw	a5,120(a0)
}
    80000bde:	60e2                	ld	ra,24(sp)
    80000be0:	6442                	ld	s0,16(sp)
    80000be2:	64a2                	ld	s1,8(sp)
    80000be4:	6105                	addi	sp,sp,32
    80000be6:	8082                	ret
    mycpu()->intena = old;
    80000be8:	4ef000ef          	jal	800018d6 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bec:	8085                	srli	s1,s1,0x1
    80000bee:	8885                	andi	s1,s1,1
    80000bf0:	dd64                	sw	s1,124(a0)
    80000bf2:	b7cd                	j	80000bd4 <push_off+0x20>

0000000080000bf4 <acquire>:
{
    80000bf4:	1101                	addi	sp,sp,-32
    80000bf6:	ec06                	sd	ra,24(sp)
    80000bf8:	e822                	sd	s0,16(sp)
    80000bfa:	e426                	sd	s1,8(sp)
    80000bfc:	1000                	addi	s0,sp,32
    80000bfe:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c00:	fb5ff0ef          	jal	80000bb4 <push_off>
  if(holding(lk))
    80000c04:	8526                	mv	a0,s1
    80000c06:	f85ff0ef          	jal	80000b8a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0a:	4705                	li	a4,1
  if(holding(lk))
    80000c0c:	e105                	bnez	a0,80000c2c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0e:	87ba                	mv	a5,a4
    80000c10:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c14:	2781                	sext.w	a5,a5
    80000c16:	ffe5                	bnez	a5,80000c0e <acquire+0x1a>
  __sync_synchronize();
    80000c18:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c1c:	4bb000ef          	jal	800018d6 <mycpu>
    80000c20:	e888                	sd	a0,16(s1)
}
    80000c22:	60e2                	ld	ra,24(sp)
    80000c24:	6442                	ld	s0,16(sp)
    80000c26:	64a2                	ld	s1,8(sp)
    80000c28:	6105                	addi	sp,sp,32
    80000c2a:	8082                	ret
    panic("acquire");
    80000c2c:	00006517          	auipc	a0,0x6
    80000c30:	41c50513          	addi	a0,a0,1052 # 80007048 <etext+0x48>
    80000c34:	b61ff0ef          	jal	80000794 <panic>

0000000080000c38 <pop_off>:

void
pop_off(void)
{
    80000c38:	1141                	addi	sp,sp,-16
    80000c3a:	e406                	sd	ra,8(sp)
    80000c3c:	e022                	sd	s0,0(sp)
    80000c3e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c40:	497000ef          	jal	800018d6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c44:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c48:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c4a:	e78d                	bnez	a5,80000c74 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c4c:	5d3c                	lw	a5,120(a0)
    80000c4e:	02f05963          	blez	a5,80000c80 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c52:	37fd                	addiw	a5,a5,-1
    80000c54:	0007871b          	sext.w	a4,a5
    80000c58:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c5a:	eb09                	bnez	a4,80000c6c <pop_off+0x34>
    80000c5c:	5d7c                	lw	a5,124(a0)
    80000c5e:	c799                	beqz	a5,80000c6c <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c60:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c64:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c68:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c6c:	60a2                	ld	ra,8(sp)
    80000c6e:	6402                	ld	s0,0(sp)
    80000c70:	0141                	addi	sp,sp,16
    80000c72:	8082                	ret
    panic("pop_off - interruptible");
    80000c74:	00006517          	auipc	a0,0x6
    80000c78:	3dc50513          	addi	a0,a0,988 # 80007050 <etext+0x50>
    80000c7c:	b19ff0ef          	jal	80000794 <panic>
    panic("pop_off");
    80000c80:	00006517          	auipc	a0,0x6
    80000c84:	3e850513          	addi	a0,a0,1000 # 80007068 <etext+0x68>
    80000c88:	b0dff0ef          	jal	80000794 <panic>

0000000080000c8c <release>:
{
    80000c8c:	1101                	addi	sp,sp,-32
    80000c8e:	ec06                	sd	ra,24(sp)
    80000c90:	e822                	sd	s0,16(sp)
    80000c92:	e426                	sd	s1,8(sp)
    80000c94:	1000                	addi	s0,sp,32
    80000c96:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c98:	ef3ff0ef          	jal	80000b8a <holding>
    80000c9c:	c105                	beqz	a0,80000cbc <release+0x30>
  lk->cpu = 0;
    80000c9e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca2:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca6:	0f50000f          	fence	iorw,ow
    80000caa:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cae:	f8bff0ef          	jal	80000c38 <pop_off>
}
    80000cb2:	60e2                	ld	ra,24(sp)
    80000cb4:	6442                	ld	s0,16(sp)
    80000cb6:	64a2                	ld	s1,8(sp)
    80000cb8:	6105                	addi	sp,sp,32
    80000cba:	8082                	ret
    panic("release");
    80000cbc:	00006517          	auipc	a0,0x6
    80000cc0:	3b450513          	addi	a0,a0,948 # 80007070 <etext+0x70>
    80000cc4:	ad1ff0ef          	jal	80000794 <panic>

0000000080000cc8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cc8:	1141                	addi	sp,sp,-16
    80000cca:	e422                	sd	s0,8(sp)
    80000ccc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cce:	ca19                	beqz	a2,80000ce4 <memset+0x1c>
    80000cd0:	87aa                	mv	a5,a0
    80000cd2:	1602                	slli	a2,a2,0x20
    80000cd4:	9201                	srli	a2,a2,0x20
    80000cd6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cda:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cde:	0785                	addi	a5,a5,1
    80000ce0:	fee79de3          	bne	a5,a4,80000cda <memset+0x12>
  }
  return dst;
}
    80000ce4:	6422                	ld	s0,8(sp)
    80000ce6:	0141                	addi	sp,sp,16
    80000ce8:	8082                	ret

0000000080000cea <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cea:	1141                	addi	sp,sp,-16
    80000cec:	e422                	sd	s0,8(sp)
    80000cee:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf0:	ca05                	beqz	a2,80000d20 <memcmp+0x36>
    80000cf2:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cf6:	1682                	slli	a3,a3,0x20
    80000cf8:	9281                	srli	a3,a3,0x20
    80000cfa:	0685                	addi	a3,a3,1
    80000cfc:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cfe:	00054783          	lbu	a5,0(a0)
    80000d02:	0005c703          	lbu	a4,0(a1)
    80000d06:	00e79863          	bne	a5,a4,80000d16 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d0a:	0505                	addi	a0,a0,1
    80000d0c:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d0e:	fed518e3          	bne	a0,a3,80000cfe <memcmp+0x14>
  }

  return 0;
    80000d12:	4501                	li	a0,0
    80000d14:	a019                	j	80000d1a <memcmp+0x30>
      return *s1 - *s2;
    80000d16:	40e7853b          	subw	a0,a5,a4
}
    80000d1a:	6422                	ld	s0,8(sp)
    80000d1c:	0141                	addi	sp,sp,16
    80000d1e:	8082                	ret
  return 0;
    80000d20:	4501                	li	a0,0
    80000d22:	bfe5                	j	80000d1a <memcmp+0x30>

0000000080000d24 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d24:	1141                	addi	sp,sp,-16
    80000d26:	e422                	sd	s0,8(sp)
    80000d28:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d2a:	c205                	beqz	a2,80000d4a <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d2c:	02a5e263          	bltu	a1,a0,80000d50 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d30:	1602                	slli	a2,a2,0x20
    80000d32:	9201                	srli	a2,a2,0x20
    80000d34:	00c587b3          	add	a5,a1,a2
{
    80000d38:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d3a:	0585                	addi	a1,a1,1
    80000d3c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffddeb1>
    80000d3e:	fff5c683          	lbu	a3,-1(a1)
    80000d42:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d46:	feb79ae3          	bne	a5,a1,80000d3a <memmove+0x16>

  return dst;
}
    80000d4a:	6422                	ld	s0,8(sp)
    80000d4c:	0141                	addi	sp,sp,16
    80000d4e:	8082                	ret
  if(s < d && s + n > d){
    80000d50:	02061693          	slli	a3,a2,0x20
    80000d54:	9281                	srli	a3,a3,0x20
    80000d56:	00d58733          	add	a4,a1,a3
    80000d5a:	fce57be3          	bgeu	a0,a4,80000d30 <memmove+0xc>
    d += n;
    80000d5e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d60:	fff6079b          	addiw	a5,a2,-1
    80000d64:	1782                	slli	a5,a5,0x20
    80000d66:	9381                	srli	a5,a5,0x20
    80000d68:	fff7c793          	not	a5,a5
    80000d6c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d6e:	177d                	addi	a4,a4,-1
    80000d70:	16fd                	addi	a3,a3,-1
    80000d72:	00074603          	lbu	a2,0(a4)
    80000d76:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d7a:	fef71ae3          	bne	a4,a5,80000d6e <memmove+0x4a>
    80000d7e:	b7f1                	j	80000d4a <memmove+0x26>

0000000080000d80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d80:	1141                	addi	sp,sp,-16
    80000d82:	e406                	sd	ra,8(sp)
    80000d84:	e022                	sd	s0,0(sp)
    80000d86:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d88:	f9dff0ef          	jal	80000d24 <memmove>
}
    80000d8c:	60a2                	ld	ra,8(sp)
    80000d8e:	6402                	ld	s0,0(sp)
    80000d90:	0141                	addi	sp,sp,16
    80000d92:	8082                	ret

0000000080000d94 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d94:	1141                	addi	sp,sp,-16
    80000d96:	e422                	sd	s0,8(sp)
    80000d98:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d9a:	ce11                	beqz	a2,80000db6 <strncmp+0x22>
    80000d9c:	00054783          	lbu	a5,0(a0)
    80000da0:	cf89                	beqz	a5,80000dba <strncmp+0x26>
    80000da2:	0005c703          	lbu	a4,0(a1)
    80000da6:	00f71a63          	bne	a4,a5,80000dba <strncmp+0x26>
    n--, p++, q++;
    80000daa:	367d                	addiw	a2,a2,-1
    80000dac:	0505                	addi	a0,a0,1
    80000dae:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db0:	f675                	bnez	a2,80000d9c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db2:	4501                	li	a0,0
    80000db4:	a801                	j	80000dc4 <strncmp+0x30>
    80000db6:	4501                	li	a0,0
    80000db8:	a031                	j	80000dc4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000dba:	00054503          	lbu	a0,0(a0)
    80000dbe:	0005c783          	lbu	a5,0(a1)
    80000dc2:	9d1d                	subw	a0,a0,a5
}
    80000dc4:	6422                	ld	s0,8(sp)
    80000dc6:	0141                	addi	sp,sp,16
    80000dc8:	8082                	ret

0000000080000dca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dca:	1141                	addi	sp,sp,-16
    80000dcc:	e422                	sd	s0,8(sp)
    80000dce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dd0:	87aa                	mv	a5,a0
    80000dd2:	86b2                	mv	a3,a2
    80000dd4:	367d                	addiw	a2,a2,-1
    80000dd6:	02d05563          	blez	a3,80000e00 <strncpy+0x36>
    80000dda:	0785                	addi	a5,a5,1
    80000ddc:	0005c703          	lbu	a4,0(a1)
    80000de0:	fee78fa3          	sb	a4,-1(a5)
    80000de4:	0585                	addi	a1,a1,1
    80000de6:	f775                	bnez	a4,80000dd2 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000de8:	873e                	mv	a4,a5
    80000dea:	9fb5                	addw	a5,a5,a3
    80000dec:	37fd                	addiw	a5,a5,-1
    80000dee:	00c05963          	blez	a2,80000e00 <strncpy+0x36>
    *s++ = 0;
    80000df2:	0705                	addi	a4,a4,1
    80000df4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000df8:	40e786bb          	subw	a3,a5,a4
    80000dfc:	fed04be3          	bgtz	a3,80000df2 <strncpy+0x28>
  return os;
}
    80000e00:	6422                	ld	s0,8(sp)
    80000e02:	0141                	addi	sp,sp,16
    80000e04:	8082                	ret

0000000080000e06 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e06:	1141                	addi	sp,sp,-16
    80000e08:	e422                	sd	s0,8(sp)
    80000e0a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e0c:	02c05363          	blez	a2,80000e32 <safestrcpy+0x2c>
    80000e10:	fff6069b          	addiw	a3,a2,-1
    80000e14:	1682                	slli	a3,a3,0x20
    80000e16:	9281                	srli	a3,a3,0x20
    80000e18:	96ae                	add	a3,a3,a1
    80000e1a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e1c:	00d58963          	beq	a1,a3,80000e2e <safestrcpy+0x28>
    80000e20:	0585                	addi	a1,a1,1
    80000e22:	0785                	addi	a5,a5,1
    80000e24:	fff5c703          	lbu	a4,-1(a1)
    80000e28:	fee78fa3          	sb	a4,-1(a5)
    80000e2c:	fb65                	bnez	a4,80000e1c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e2e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <strlen>:

int
strlen(const char *s)
{
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e422                	sd	s0,8(sp)
    80000e3c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e3e:	00054783          	lbu	a5,0(a0)
    80000e42:	cf91                	beqz	a5,80000e5e <strlen+0x26>
    80000e44:	0505                	addi	a0,a0,1
    80000e46:	87aa                	mv	a5,a0
    80000e48:	86be                	mv	a3,a5
    80000e4a:	0785                	addi	a5,a5,1
    80000e4c:	fff7c703          	lbu	a4,-1(a5)
    80000e50:	ff65                	bnez	a4,80000e48 <strlen+0x10>
    80000e52:	40a6853b          	subw	a0,a3,a0
    80000e56:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e58:	6422                	ld	s0,8(sp)
    80000e5a:	0141                	addi	sp,sp,16
    80000e5c:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e5e:	4501                	li	a0,0
    80000e60:	bfe5                	j	80000e58 <strlen+0x20>

0000000080000e62 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e406                	sd	ra,8(sp)
    80000e66:	e022                	sd	s0,0(sp)
    80000e68:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e6a:	25d000ef          	jal	800018c6 <cpuid>
    init_priority_control();
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e6e:	00007717          	auipc	a4,0x7
    80000e72:	afa70713          	addi	a4,a4,-1286 # 80007968 <started>
  if(cpuid() == 0){
    80000e76:	c51d                	beqz	a0,80000ea4 <main+0x42>
    while(started == 0)
    80000e78:	431c                	lw	a5,0(a4)
    80000e7a:	2781                	sext.w	a5,a5
    80000e7c:	dff5                	beqz	a5,80000e78 <main+0x16>
      ;
    __sync_synchronize();
    80000e7e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e82:	245000ef          	jal	800018c6 <cpuid>
    80000e86:	85aa                	mv	a1,a0
    80000e88:	00006517          	auipc	a0,0x6
    80000e8c:	21050513          	addi	a0,a0,528 # 80007098 <etext+0x98>
    80000e90:	e32ff0ef          	jal	800004c2 <printf>
    kvminithart();    // turn on paging
    80000e94:	084000ef          	jal	80000f18 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e98:	67e010ef          	jal	80002516 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e9c:	4fc040ef          	jal	80005398 <plicinithart>
  }

  scheduler();        
    80000ea0:	465000ef          	jal	80001b04 <scheduler>
    consoleinit();
    80000ea4:	d48ff0ef          	jal	800003ec <consoleinit>
    printfinit();
    80000ea8:	927ff0ef          	jal	800007ce <printfinit>
    printf("\n");
    80000eac:	00006517          	auipc	a0,0x6
    80000eb0:	1cc50513          	addi	a0,a0,460 # 80007078 <etext+0x78>
    80000eb4:	e0eff0ef          	jal	800004c2 <printf>
    printf("xv6 kernel is booting\n");
    80000eb8:	00006517          	auipc	a0,0x6
    80000ebc:	1c850513          	addi	a0,a0,456 # 80007080 <etext+0x80>
    80000ec0:	e02ff0ef          	jal	800004c2 <printf>
    printf("\n");
    80000ec4:	00006517          	auipc	a0,0x6
    80000ec8:	1b450513          	addi	a0,a0,436 # 80007078 <etext+0x78>
    80000ecc:	df6ff0ef          	jal	800004c2 <printf>
    kinit();         // physical page allocator
    80000ed0:	c21ff0ef          	jal	80000af0 <kinit>
    kvminit();       // create kernel page table
    80000ed4:	2ce000ef          	jal	800011a2 <kvminit>
    kvminithart();   // turn on paging
    80000ed8:	040000ef          	jal	80000f18 <kvminithart>
    procinit();      // process table
    80000edc:	127000ef          	jal	80001802 <procinit>
    trapinit();      // trap vectors
    80000ee0:	612010ef          	jal	800024f2 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ee4:	632010ef          	jal	80002516 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ee8:	496040ef          	jal	8000537e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000eec:	4ac040ef          	jal	80005398 <plicinithart>
    binit();         // buffer cache
    80000ef0:	459010ef          	jal	80002b48 <binit>
    iinit();         // inode table
    80000ef4:	24a020ef          	jal	8000313e <iinit>
    fileinit();      // file table
    80000ef8:	7f7020ef          	jal	80003eee <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efc:	58c040ef          	jal	80005488 <virtio_disk_init>
    init_priority_control();
    80000f00:	26e010ef          	jal	8000216e <init_priority_control>
    userinit();      // first user process
    80000f04:	402010ef          	jal	80002306 <userinit>
    __sync_synchronize();
    80000f08:	0ff0000f          	fence
    started = 1;
    80000f0c:	4785                	li	a5,1
    80000f0e:	00007717          	auipc	a4,0x7
    80000f12:	a4f72d23          	sw	a5,-1446(a4) # 80007968 <started>
    80000f16:	b769                	j	80000ea0 <main+0x3e>

0000000080000f18 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f18:	1141                	addi	sp,sp,-16
    80000f1a:	e422                	sd	s0,8(sp)
    80000f1c:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f1e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f22:	00007797          	auipc	a5,0x7
    80000f26:	a4e7b783          	ld	a5,-1458(a5) # 80007970 <kernel_pagetable>
    80000f2a:	83b1                	srli	a5,a5,0xc
    80000f2c:	577d                	li	a4,-1
    80000f2e:	177e                	slli	a4,a4,0x3f
    80000f30:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f32:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f36:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f3a:	6422                	ld	s0,8(sp)
    80000f3c:	0141                	addi	sp,sp,16
    80000f3e:	8082                	ret

0000000080000f40 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f40:	7139                	addi	sp,sp,-64
    80000f42:	fc06                	sd	ra,56(sp)
    80000f44:	f822                	sd	s0,48(sp)
    80000f46:	f426                	sd	s1,40(sp)
    80000f48:	f04a                	sd	s2,32(sp)
    80000f4a:	ec4e                	sd	s3,24(sp)
    80000f4c:	e852                	sd	s4,16(sp)
    80000f4e:	e456                	sd	s5,8(sp)
    80000f50:	e05a                	sd	s6,0(sp)
    80000f52:	0080                	addi	s0,sp,64
    80000f54:	84aa                	mv	s1,a0
    80000f56:	89ae                	mv	s3,a1
    80000f58:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f5a:	57fd                	li	a5,-1
    80000f5c:	83e9                	srli	a5,a5,0x1a
    80000f5e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f60:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f62:	02b7fc63          	bgeu	a5,a1,80000f9a <walk+0x5a>
    panic("walk");
    80000f66:	00006517          	auipc	a0,0x6
    80000f6a:	14a50513          	addi	a0,a0,330 # 800070b0 <etext+0xb0>
    80000f6e:	827ff0ef          	jal	80000794 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f72:	060a8263          	beqz	s5,80000fd6 <walk+0x96>
    80000f76:	bafff0ef          	jal	80000b24 <kalloc>
    80000f7a:	84aa                	mv	s1,a0
    80000f7c:	c139                	beqz	a0,80000fc2 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f7e:	6605                	lui	a2,0x1
    80000f80:	4581                	li	a1,0
    80000f82:	d47ff0ef          	jal	80000cc8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f86:	00c4d793          	srli	a5,s1,0xc
    80000f8a:	07aa                	slli	a5,a5,0xa
    80000f8c:	0017e793          	ori	a5,a5,1
    80000f90:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f94:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffddea7>
    80000f96:	036a0063          	beq	s4,s6,80000fb6 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f9a:	0149d933          	srl	s2,s3,s4
    80000f9e:	1ff97913          	andi	s2,s2,511
    80000fa2:	090e                	slli	s2,s2,0x3
    80000fa4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fa6:	00093483          	ld	s1,0(s2)
    80000faa:	0014f793          	andi	a5,s1,1
    80000fae:	d3f1                	beqz	a5,80000f72 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fb0:	80a9                	srli	s1,s1,0xa
    80000fb2:	04b2                	slli	s1,s1,0xc
    80000fb4:	b7c5                	j	80000f94 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000fb6:	00c9d513          	srli	a0,s3,0xc
    80000fba:	1ff57513          	andi	a0,a0,511
    80000fbe:	050e                	slli	a0,a0,0x3
    80000fc0:	9526                	add	a0,a0,s1
}
    80000fc2:	70e2                	ld	ra,56(sp)
    80000fc4:	7442                	ld	s0,48(sp)
    80000fc6:	74a2                	ld	s1,40(sp)
    80000fc8:	7902                	ld	s2,32(sp)
    80000fca:	69e2                	ld	s3,24(sp)
    80000fcc:	6a42                	ld	s4,16(sp)
    80000fce:	6aa2                	ld	s5,8(sp)
    80000fd0:	6b02                	ld	s6,0(sp)
    80000fd2:	6121                	addi	sp,sp,64
    80000fd4:	8082                	ret
        return 0;
    80000fd6:	4501                	li	a0,0
    80000fd8:	b7ed                	j	80000fc2 <walk+0x82>

0000000080000fda <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fda:	57fd                	li	a5,-1
    80000fdc:	83e9                	srli	a5,a5,0x1a
    80000fde:	00b7f463          	bgeu	a5,a1,80000fe6 <walkaddr+0xc>
    return 0;
    80000fe2:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fe4:	8082                	ret
{
    80000fe6:	1141                	addi	sp,sp,-16
    80000fe8:	e406                	sd	ra,8(sp)
    80000fea:	e022                	sd	s0,0(sp)
    80000fec:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fee:	4601                	li	a2,0
    80000ff0:	f51ff0ef          	jal	80000f40 <walk>
  if(pte == 0)
    80000ff4:	c105                	beqz	a0,80001014 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000ff6:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000ff8:	0117f693          	andi	a3,a5,17
    80000ffc:	4745                	li	a4,17
    return 0;
    80000ffe:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001000:	00e68663          	beq	a3,a4,8000100c <walkaddr+0x32>
}
    80001004:	60a2                	ld	ra,8(sp)
    80001006:	6402                	ld	s0,0(sp)
    80001008:	0141                	addi	sp,sp,16
    8000100a:	8082                	ret
  pa = PTE2PA(*pte);
    8000100c:	83a9                	srli	a5,a5,0xa
    8000100e:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001012:	bfcd                	j	80001004 <walkaddr+0x2a>
    return 0;
    80001014:	4501                	li	a0,0
    80001016:	b7fd                	j	80001004 <walkaddr+0x2a>

0000000080001018 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001018:	715d                	addi	sp,sp,-80
    8000101a:	e486                	sd	ra,72(sp)
    8000101c:	e0a2                	sd	s0,64(sp)
    8000101e:	fc26                	sd	s1,56(sp)
    80001020:	f84a                	sd	s2,48(sp)
    80001022:	f44e                	sd	s3,40(sp)
    80001024:	f052                	sd	s4,32(sp)
    80001026:	ec56                	sd	s5,24(sp)
    80001028:	e85a                	sd	s6,16(sp)
    8000102a:	e45e                	sd	s7,8(sp)
    8000102c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000102e:	03459793          	slli	a5,a1,0x34
    80001032:	e7a9                	bnez	a5,8000107c <mappages+0x64>
    80001034:	8aaa                	mv	s5,a0
    80001036:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001038:	03461793          	slli	a5,a2,0x34
    8000103c:	e7b1                	bnez	a5,80001088 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    8000103e:	ca39                	beqz	a2,80001094 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001040:	77fd                	lui	a5,0xfffff
    80001042:	963e                	add	a2,a2,a5
    80001044:	00b609b3          	add	s3,a2,a1
  a = va;
    80001048:	892e                	mv	s2,a1
    8000104a:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000104e:	6b85                	lui	s7,0x1
    80001050:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001054:	4605                	li	a2,1
    80001056:	85ca                	mv	a1,s2
    80001058:	8556                	mv	a0,s5
    8000105a:	ee7ff0ef          	jal	80000f40 <walk>
    8000105e:	c539                	beqz	a0,800010ac <mappages+0x94>
    if(*pte & PTE_V)
    80001060:	611c                	ld	a5,0(a0)
    80001062:	8b85                	andi	a5,a5,1
    80001064:	ef95                	bnez	a5,800010a0 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001066:	80b1                	srli	s1,s1,0xc
    80001068:	04aa                	slli	s1,s1,0xa
    8000106a:	0164e4b3          	or	s1,s1,s6
    8000106e:	0014e493          	ori	s1,s1,1
    80001072:	e104                	sd	s1,0(a0)
    if(a == last)
    80001074:	05390863          	beq	s2,s3,800010c4 <mappages+0xac>
    a += PGSIZE;
    80001078:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000107a:	bfd9                	j	80001050 <mappages+0x38>
    panic("mappages: va not aligned");
    8000107c:	00006517          	auipc	a0,0x6
    80001080:	03c50513          	addi	a0,a0,60 # 800070b8 <etext+0xb8>
    80001084:	f10ff0ef          	jal	80000794 <panic>
    panic("mappages: size not aligned");
    80001088:	00006517          	auipc	a0,0x6
    8000108c:	05050513          	addi	a0,a0,80 # 800070d8 <etext+0xd8>
    80001090:	f04ff0ef          	jal	80000794 <panic>
    panic("mappages: size");
    80001094:	00006517          	auipc	a0,0x6
    80001098:	06450513          	addi	a0,a0,100 # 800070f8 <etext+0xf8>
    8000109c:	ef8ff0ef          	jal	80000794 <panic>
      panic("mappages: remap");
    800010a0:	00006517          	auipc	a0,0x6
    800010a4:	06850513          	addi	a0,a0,104 # 80007108 <etext+0x108>
    800010a8:	eecff0ef          	jal	80000794 <panic>
      return -1;
    800010ac:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010ae:	60a6                	ld	ra,72(sp)
    800010b0:	6406                	ld	s0,64(sp)
    800010b2:	74e2                	ld	s1,56(sp)
    800010b4:	7942                	ld	s2,48(sp)
    800010b6:	79a2                	ld	s3,40(sp)
    800010b8:	7a02                	ld	s4,32(sp)
    800010ba:	6ae2                	ld	s5,24(sp)
    800010bc:	6b42                	ld	s6,16(sp)
    800010be:	6ba2                	ld	s7,8(sp)
    800010c0:	6161                	addi	sp,sp,80
    800010c2:	8082                	ret
  return 0;
    800010c4:	4501                	li	a0,0
    800010c6:	b7e5                	j	800010ae <mappages+0x96>

00000000800010c8 <kvmmap>:
{
    800010c8:	1141                	addi	sp,sp,-16
    800010ca:	e406                	sd	ra,8(sp)
    800010cc:	e022                	sd	s0,0(sp)
    800010ce:	0800                	addi	s0,sp,16
    800010d0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010d2:	86b2                	mv	a3,a2
    800010d4:	863e                	mv	a2,a5
    800010d6:	f43ff0ef          	jal	80001018 <mappages>
    800010da:	e509                	bnez	a0,800010e4 <kvmmap+0x1c>
}
    800010dc:	60a2                	ld	ra,8(sp)
    800010de:	6402                	ld	s0,0(sp)
    800010e0:	0141                	addi	sp,sp,16
    800010e2:	8082                	ret
    panic("kvmmap");
    800010e4:	00006517          	auipc	a0,0x6
    800010e8:	03450513          	addi	a0,a0,52 # 80007118 <etext+0x118>
    800010ec:	ea8ff0ef          	jal	80000794 <panic>

00000000800010f0 <kvmmake>:
{
    800010f0:	1101                	addi	sp,sp,-32
    800010f2:	ec06                	sd	ra,24(sp)
    800010f4:	e822                	sd	s0,16(sp)
    800010f6:	e426                	sd	s1,8(sp)
    800010f8:	e04a                	sd	s2,0(sp)
    800010fa:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010fc:	a29ff0ef          	jal	80000b24 <kalloc>
    80001100:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001102:	6605                	lui	a2,0x1
    80001104:	4581                	li	a1,0
    80001106:	bc3ff0ef          	jal	80000cc8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000110a:	4719                	li	a4,6
    8000110c:	6685                	lui	a3,0x1
    8000110e:	10000637          	lui	a2,0x10000
    80001112:	100005b7          	lui	a1,0x10000
    80001116:	8526                	mv	a0,s1
    80001118:	fb1ff0ef          	jal	800010c8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000111c:	4719                	li	a4,6
    8000111e:	6685                	lui	a3,0x1
    80001120:	10001637          	lui	a2,0x10001
    80001124:	100015b7          	lui	a1,0x10001
    80001128:	8526                	mv	a0,s1
    8000112a:	f9fff0ef          	jal	800010c8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000112e:	4719                	li	a4,6
    80001130:	040006b7          	lui	a3,0x4000
    80001134:	0c000637          	lui	a2,0xc000
    80001138:	0c0005b7          	lui	a1,0xc000
    8000113c:	8526                	mv	a0,s1
    8000113e:	f8bff0ef          	jal	800010c8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001142:	00006917          	auipc	s2,0x6
    80001146:	ebe90913          	addi	s2,s2,-322 # 80007000 <etext>
    8000114a:	4729                	li	a4,10
    8000114c:	80006697          	auipc	a3,0x80006
    80001150:	eb468693          	addi	a3,a3,-332 # 7000 <_entry-0x7fff9000>
    80001154:	4605                	li	a2,1
    80001156:	067e                	slli	a2,a2,0x1f
    80001158:	85b2                	mv	a1,a2
    8000115a:	8526                	mv	a0,s1
    8000115c:	f6dff0ef          	jal	800010c8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001160:	46c5                	li	a3,17
    80001162:	06ee                	slli	a3,a3,0x1b
    80001164:	4719                	li	a4,6
    80001166:	412686b3          	sub	a3,a3,s2
    8000116a:	864a                	mv	a2,s2
    8000116c:	85ca                	mv	a1,s2
    8000116e:	8526                	mv	a0,s1
    80001170:	f59ff0ef          	jal	800010c8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001174:	4729                	li	a4,10
    80001176:	6685                	lui	a3,0x1
    80001178:	00005617          	auipc	a2,0x5
    8000117c:	e8860613          	addi	a2,a2,-376 # 80006000 <_trampoline>
    80001180:	040005b7          	lui	a1,0x4000
    80001184:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001186:	05b2                	slli	a1,a1,0xc
    80001188:	8526                	mv	a0,s1
    8000118a:	f3fff0ef          	jal	800010c8 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000118e:	8526                	mv	a0,s1
    80001190:	5da000ef          	jal	8000176a <proc_mapstacks>
}
    80001194:	8526                	mv	a0,s1
    80001196:	60e2                	ld	ra,24(sp)
    80001198:	6442                	ld	s0,16(sp)
    8000119a:	64a2                	ld	s1,8(sp)
    8000119c:	6902                	ld	s2,0(sp)
    8000119e:	6105                	addi	sp,sp,32
    800011a0:	8082                	ret

00000000800011a2 <kvminit>:
{
    800011a2:	1141                	addi	sp,sp,-16
    800011a4:	e406                	sd	ra,8(sp)
    800011a6:	e022                	sd	s0,0(sp)
    800011a8:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011aa:	f47ff0ef          	jal	800010f0 <kvmmake>
    800011ae:	00006797          	auipc	a5,0x6
    800011b2:	7ca7b123          	sd	a0,1986(a5) # 80007970 <kernel_pagetable>
}
    800011b6:	60a2                	ld	ra,8(sp)
    800011b8:	6402                	ld	s0,0(sp)
    800011ba:	0141                	addi	sp,sp,16
    800011bc:	8082                	ret

00000000800011be <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011be:	715d                	addi	sp,sp,-80
    800011c0:	e486                	sd	ra,72(sp)
    800011c2:	e0a2                	sd	s0,64(sp)
    800011c4:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011c6:	03459793          	slli	a5,a1,0x34
    800011ca:	e39d                	bnez	a5,800011f0 <uvmunmap+0x32>
    800011cc:	f84a                	sd	s2,48(sp)
    800011ce:	f44e                	sd	s3,40(sp)
    800011d0:	f052                	sd	s4,32(sp)
    800011d2:	ec56                	sd	s5,24(sp)
    800011d4:	e85a                	sd	s6,16(sp)
    800011d6:	e45e                	sd	s7,8(sp)
    800011d8:	8a2a                	mv	s4,a0
    800011da:	892e                	mv	s2,a1
    800011dc:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011de:	0632                	slli	a2,a2,0xc
    800011e0:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800011e4:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011e6:	6b05                	lui	s6,0x1
    800011e8:	0735ff63          	bgeu	a1,s3,80001266 <uvmunmap+0xa8>
    800011ec:	fc26                	sd	s1,56(sp)
    800011ee:	a0a9                	j	80001238 <uvmunmap+0x7a>
    800011f0:	fc26                	sd	s1,56(sp)
    800011f2:	f84a                	sd	s2,48(sp)
    800011f4:	f44e                	sd	s3,40(sp)
    800011f6:	f052                	sd	s4,32(sp)
    800011f8:	ec56                	sd	s5,24(sp)
    800011fa:	e85a                	sd	s6,16(sp)
    800011fc:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800011fe:	00006517          	auipc	a0,0x6
    80001202:	f2250513          	addi	a0,a0,-222 # 80007120 <etext+0x120>
    80001206:	d8eff0ef          	jal	80000794 <panic>
      panic("uvmunmap: walk");
    8000120a:	00006517          	auipc	a0,0x6
    8000120e:	f2e50513          	addi	a0,a0,-210 # 80007138 <etext+0x138>
    80001212:	d82ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not mapped");
    80001216:	00006517          	auipc	a0,0x6
    8000121a:	f3250513          	addi	a0,a0,-206 # 80007148 <etext+0x148>
    8000121e:	d76ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not a leaf");
    80001222:	00006517          	auipc	a0,0x6
    80001226:	f3e50513          	addi	a0,a0,-194 # 80007160 <etext+0x160>
    8000122a:	d6aff0ef          	jal	80000794 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000122e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001232:	995a                	add	s2,s2,s6
    80001234:	03397863          	bgeu	s2,s3,80001264 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001238:	4601                	li	a2,0
    8000123a:	85ca                	mv	a1,s2
    8000123c:	8552                	mv	a0,s4
    8000123e:	d03ff0ef          	jal	80000f40 <walk>
    80001242:	84aa                	mv	s1,a0
    80001244:	d179                	beqz	a0,8000120a <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001246:	6108                	ld	a0,0(a0)
    80001248:	00157793          	andi	a5,a0,1
    8000124c:	d7e9                	beqz	a5,80001216 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000124e:	3ff57793          	andi	a5,a0,1023
    80001252:	fd7788e3          	beq	a5,s7,80001222 <uvmunmap+0x64>
    if(do_free){
    80001256:	fc0a8ce3          	beqz	s5,8000122e <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    8000125a:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000125c:	0532                	slli	a0,a0,0xc
    8000125e:	fe4ff0ef          	jal	80000a42 <kfree>
    80001262:	b7f1                	j	8000122e <uvmunmap+0x70>
    80001264:	74e2                	ld	s1,56(sp)
    80001266:	7942                	ld	s2,48(sp)
    80001268:	79a2                	ld	s3,40(sp)
    8000126a:	7a02                	ld	s4,32(sp)
    8000126c:	6ae2                	ld	s5,24(sp)
    8000126e:	6b42                	ld	s6,16(sp)
    80001270:	6ba2                	ld	s7,8(sp)
  }
}
    80001272:	60a6                	ld	ra,72(sp)
    80001274:	6406                	ld	s0,64(sp)
    80001276:	6161                	addi	sp,sp,80
    80001278:	8082                	ret

000000008000127a <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000127a:	1101                	addi	sp,sp,-32
    8000127c:	ec06                	sd	ra,24(sp)
    8000127e:	e822                	sd	s0,16(sp)
    80001280:	e426                	sd	s1,8(sp)
    80001282:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001284:	8a1ff0ef          	jal	80000b24 <kalloc>
    80001288:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000128a:	c509                	beqz	a0,80001294 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000128c:	6605                	lui	a2,0x1
    8000128e:	4581                	li	a1,0
    80001290:	a39ff0ef          	jal	80000cc8 <memset>
  return pagetable;
}
    80001294:	8526                	mv	a0,s1
    80001296:	60e2                	ld	ra,24(sp)
    80001298:	6442                	ld	s0,16(sp)
    8000129a:	64a2                	ld	s1,8(sp)
    8000129c:	6105                	addi	sp,sp,32
    8000129e:	8082                	ret

00000000800012a0 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800012a0:	7179                	addi	sp,sp,-48
    800012a2:	f406                	sd	ra,40(sp)
    800012a4:	f022                	sd	s0,32(sp)
    800012a6:	ec26                	sd	s1,24(sp)
    800012a8:	e84a                	sd	s2,16(sp)
    800012aa:	e44e                	sd	s3,8(sp)
    800012ac:	e052                	sd	s4,0(sp)
    800012ae:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012b0:	6785                	lui	a5,0x1
    800012b2:	04f67063          	bgeu	a2,a5,800012f2 <uvmfirst+0x52>
    800012b6:	8a2a                	mv	s4,a0
    800012b8:	89ae                	mv	s3,a1
    800012ba:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012bc:	869ff0ef          	jal	80000b24 <kalloc>
    800012c0:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012c2:	6605                	lui	a2,0x1
    800012c4:	4581                	li	a1,0
    800012c6:	a03ff0ef          	jal	80000cc8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012ca:	4779                	li	a4,30
    800012cc:	86ca                	mv	a3,s2
    800012ce:	6605                	lui	a2,0x1
    800012d0:	4581                	li	a1,0
    800012d2:	8552                	mv	a0,s4
    800012d4:	d45ff0ef          	jal	80001018 <mappages>
  memmove(mem, src, sz);
    800012d8:	8626                	mv	a2,s1
    800012da:	85ce                	mv	a1,s3
    800012dc:	854a                	mv	a0,s2
    800012de:	a47ff0ef          	jal	80000d24 <memmove>
}
    800012e2:	70a2                	ld	ra,40(sp)
    800012e4:	7402                	ld	s0,32(sp)
    800012e6:	64e2                	ld	s1,24(sp)
    800012e8:	6942                	ld	s2,16(sp)
    800012ea:	69a2                	ld	s3,8(sp)
    800012ec:	6a02                	ld	s4,0(sp)
    800012ee:	6145                	addi	sp,sp,48
    800012f0:	8082                	ret
    panic("uvmfirst: more than a page");
    800012f2:	00006517          	auipc	a0,0x6
    800012f6:	e8650513          	addi	a0,a0,-378 # 80007178 <etext+0x178>
    800012fa:	c9aff0ef          	jal	80000794 <panic>

00000000800012fe <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800012fe:	1101                	addi	sp,sp,-32
    80001300:	ec06                	sd	ra,24(sp)
    80001302:	e822                	sd	s0,16(sp)
    80001304:	e426                	sd	s1,8(sp)
    80001306:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001308:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000130a:	00b67d63          	bgeu	a2,a1,80001324 <uvmdealloc+0x26>
    8000130e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001310:	6785                	lui	a5,0x1
    80001312:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001314:	00f60733          	add	a4,a2,a5
    80001318:	76fd                	lui	a3,0xfffff
    8000131a:	8f75                	and	a4,a4,a3
    8000131c:	97ae                	add	a5,a5,a1
    8000131e:	8ff5                	and	a5,a5,a3
    80001320:	00f76863          	bltu	a4,a5,80001330 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001324:	8526                	mv	a0,s1
    80001326:	60e2                	ld	ra,24(sp)
    80001328:	6442                	ld	s0,16(sp)
    8000132a:	64a2                	ld	s1,8(sp)
    8000132c:	6105                	addi	sp,sp,32
    8000132e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001330:	8f99                	sub	a5,a5,a4
    80001332:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001334:	4685                	li	a3,1
    80001336:	0007861b          	sext.w	a2,a5
    8000133a:	85ba                	mv	a1,a4
    8000133c:	e83ff0ef          	jal	800011be <uvmunmap>
    80001340:	b7d5                	j	80001324 <uvmdealloc+0x26>

0000000080001342 <uvmalloc>:
  if(newsz < oldsz)
    80001342:	08b66f63          	bltu	a2,a1,800013e0 <uvmalloc+0x9e>
{
    80001346:	7139                	addi	sp,sp,-64
    80001348:	fc06                	sd	ra,56(sp)
    8000134a:	f822                	sd	s0,48(sp)
    8000134c:	ec4e                	sd	s3,24(sp)
    8000134e:	e852                	sd	s4,16(sp)
    80001350:	e456                	sd	s5,8(sp)
    80001352:	0080                	addi	s0,sp,64
    80001354:	8aaa                	mv	s5,a0
    80001356:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001358:	6785                	lui	a5,0x1
    8000135a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000135c:	95be                	add	a1,a1,a5
    8000135e:	77fd                	lui	a5,0xfffff
    80001360:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001364:	08c9f063          	bgeu	s3,a2,800013e4 <uvmalloc+0xa2>
    80001368:	f426                	sd	s1,40(sp)
    8000136a:	f04a                	sd	s2,32(sp)
    8000136c:	e05a                	sd	s6,0(sp)
    8000136e:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001370:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001374:	fb0ff0ef          	jal	80000b24 <kalloc>
    80001378:	84aa                	mv	s1,a0
    if(mem == 0){
    8000137a:	c515                	beqz	a0,800013a6 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000137c:	6605                	lui	a2,0x1
    8000137e:	4581                	li	a1,0
    80001380:	949ff0ef          	jal	80000cc8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001384:	875a                	mv	a4,s6
    80001386:	86a6                	mv	a3,s1
    80001388:	6605                	lui	a2,0x1
    8000138a:	85ca                	mv	a1,s2
    8000138c:	8556                	mv	a0,s5
    8000138e:	c8bff0ef          	jal	80001018 <mappages>
    80001392:	e915                	bnez	a0,800013c6 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001394:	6785                	lui	a5,0x1
    80001396:	993e                	add	s2,s2,a5
    80001398:	fd496ee3          	bltu	s2,s4,80001374 <uvmalloc+0x32>
  return newsz;
    8000139c:	8552                	mv	a0,s4
    8000139e:	74a2                	ld	s1,40(sp)
    800013a0:	7902                	ld	s2,32(sp)
    800013a2:	6b02                	ld	s6,0(sp)
    800013a4:	a811                	j	800013b8 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800013a6:	864e                	mv	a2,s3
    800013a8:	85ca                	mv	a1,s2
    800013aa:	8556                	mv	a0,s5
    800013ac:	f53ff0ef          	jal	800012fe <uvmdealloc>
      return 0;
    800013b0:	4501                	li	a0,0
    800013b2:	74a2                	ld	s1,40(sp)
    800013b4:	7902                	ld	s2,32(sp)
    800013b6:	6b02                	ld	s6,0(sp)
}
    800013b8:	70e2                	ld	ra,56(sp)
    800013ba:	7442                	ld	s0,48(sp)
    800013bc:	69e2                	ld	s3,24(sp)
    800013be:	6a42                	ld	s4,16(sp)
    800013c0:	6aa2                	ld	s5,8(sp)
    800013c2:	6121                	addi	sp,sp,64
    800013c4:	8082                	ret
      kfree(mem);
    800013c6:	8526                	mv	a0,s1
    800013c8:	e7aff0ef          	jal	80000a42 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013cc:	864e                	mv	a2,s3
    800013ce:	85ca                	mv	a1,s2
    800013d0:	8556                	mv	a0,s5
    800013d2:	f2dff0ef          	jal	800012fe <uvmdealloc>
      return 0;
    800013d6:	4501                	li	a0,0
    800013d8:	74a2                	ld	s1,40(sp)
    800013da:	7902                	ld	s2,32(sp)
    800013dc:	6b02                	ld	s6,0(sp)
    800013de:	bfe9                	j	800013b8 <uvmalloc+0x76>
    return oldsz;
    800013e0:	852e                	mv	a0,a1
}
    800013e2:	8082                	ret
  return newsz;
    800013e4:	8532                	mv	a0,a2
    800013e6:	bfc9                	j	800013b8 <uvmalloc+0x76>

00000000800013e8 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800013e8:	7179                	addi	sp,sp,-48
    800013ea:	f406                	sd	ra,40(sp)
    800013ec:	f022                	sd	s0,32(sp)
    800013ee:	ec26                	sd	s1,24(sp)
    800013f0:	e84a                	sd	s2,16(sp)
    800013f2:	e44e                	sd	s3,8(sp)
    800013f4:	e052                	sd	s4,0(sp)
    800013f6:	1800                	addi	s0,sp,48
    800013f8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800013fa:	84aa                	mv	s1,a0
    800013fc:	6905                	lui	s2,0x1
    800013fe:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001400:	4985                	li	s3,1
    80001402:	a819                	j	80001418 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001404:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001406:	00c79513          	slli	a0,a5,0xc
    8000140a:	fdfff0ef          	jal	800013e8 <freewalk>
      pagetable[i] = 0;
    8000140e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001412:	04a1                	addi	s1,s1,8
    80001414:	01248f63          	beq	s1,s2,80001432 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001418:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000141a:	00f7f713          	andi	a4,a5,15
    8000141e:	ff3703e3          	beq	a4,s3,80001404 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001422:	8b85                	andi	a5,a5,1
    80001424:	d7fd                	beqz	a5,80001412 <freewalk+0x2a>
      panic("freewalk: leaf");
    80001426:	00006517          	auipc	a0,0x6
    8000142a:	d7250513          	addi	a0,a0,-654 # 80007198 <etext+0x198>
    8000142e:	b66ff0ef          	jal	80000794 <panic>
    }
  }
  kfree((void*)pagetable);
    80001432:	8552                	mv	a0,s4
    80001434:	e0eff0ef          	jal	80000a42 <kfree>
}
    80001438:	70a2                	ld	ra,40(sp)
    8000143a:	7402                	ld	s0,32(sp)
    8000143c:	64e2                	ld	s1,24(sp)
    8000143e:	6942                	ld	s2,16(sp)
    80001440:	69a2                	ld	s3,8(sp)
    80001442:	6a02                	ld	s4,0(sp)
    80001444:	6145                	addi	sp,sp,48
    80001446:	8082                	ret

0000000080001448 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001448:	1101                	addi	sp,sp,-32
    8000144a:	ec06                	sd	ra,24(sp)
    8000144c:	e822                	sd	s0,16(sp)
    8000144e:	e426                	sd	s1,8(sp)
    80001450:	1000                	addi	s0,sp,32
    80001452:	84aa                	mv	s1,a0
  if(sz > 0)
    80001454:	e989                	bnez	a1,80001466 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001456:	8526                	mv	a0,s1
    80001458:	f91ff0ef          	jal	800013e8 <freewalk>
}
    8000145c:	60e2                	ld	ra,24(sp)
    8000145e:	6442                	ld	s0,16(sp)
    80001460:	64a2                	ld	s1,8(sp)
    80001462:	6105                	addi	sp,sp,32
    80001464:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001466:	6785                	lui	a5,0x1
    80001468:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000146a:	95be                	add	a1,a1,a5
    8000146c:	4685                	li	a3,1
    8000146e:	00c5d613          	srli	a2,a1,0xc
    80001472:	4581                	li	a1,0
    80001474:	d4bff0ef          	jal	800011be <uvmunmap>
    80001478:	bff9                	j	80001456 <uvmfree+0xe>

000000008000147a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000147a:	c65d                	beqz	a2,80001528 <uvmcopy+0xae>
{
    8000147c:	715d                	addi	sp,sp,-80
    8000147e:	e486                	sd	ra,72(sp)
    80001480:	e0a2                	sd	s0,64(sp)
    80001482:	fc26                	sd	s1,56(sp)
    80001484:	f84a                	sd	s2,48(sp)
    80001486:	f44e                	sd	s3,40(sp)
    80001488:	f052                	sd	s4,32(sp)
    8000148a:	ec56                	sd	s5,24(sp)
    8000148c:	e85a                	sd	s6,16(sp)
    8000148e:	e45e                	sd	s7,8(sp)
    80001490:	0880                	addi	s0,sp,80
    80001492:	8b2a                	mv	s6,a0
    80001494:	8aae                	mv	s5,a1
    80001496:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001498:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000149a:	4601                	li	a2,0
    8000149c:	85ce                	mv	a1,s3
    8000149e:	855a                	mv	a0,s6
    800014a0:	aa1ff0ef          	jal	80000f40 <walk>
    800014a4:	c121                	beqz	a0,800014e4 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800014a6:	6118                	ld	a4,0(a0)
    800014a8:	00177793          	andi	a5,a4,1
    800014ac:	c3b1                	beqz	a5,800014f0 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800014ae:	00a75593          	srli	a1,a4,0xa
    800014b2:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014b6:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014ba:	e6aff0ef          	jal	80000b24 <kalloc>
    800014be:	892a                	mv	s2,a0
    800014c0:	c129                	beqz	a0,80001502 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014c2:	6605                	lui	a2,0x1
    800014c4:	85de                	mv	a1,s7
    800014c6:	85fff0ef          	jal	80000d24 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014ca:	8726                	mv	a4,s1
    800014cc:	86ca                	mv	a3,s2
    800014ce:	6605                	lui	a2,0x1
    800014d0:	85ce                	mv	a1,s3
    800014d2:	8556                	mv	a0,s5
    800014d4:	b45ff0ef          	jal	80001018 <mappages>
    800014d8:	e115                	bnez	a0,800014fc <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    800014da:	6785                	lui	a5,0x1
    800014dc:	99be                	add	s3,s3,a5
    800014de:	fb49eee3          	bltu	s3,s4,8000149a <uvmcopy+0x20>
    800014e2:	a805                	j	80001512 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    800014e4:	00006517          	auipc	a0,0x6
    800014e8:	cc450513          	addi	a0,a0,-828 # 800071a8 <etext+0x1a8>
    800014ec:	aa8ff0ef          	jal	80000794 <panic>
      panic("uvmcopy: page not present");
    800014f0:	00006517          	auipc	a0,0x6
    800014f4:	cd850513          	addi	a0,a0,-808 # 800071c8 <etext+0x1c8>
    800014f8:	a9cff0ef          	jal	80000794 <panic>
      kfree(mem);
    800014fc:	854a                	mv	a0,s2
    800014fe:	d44ff0ef          	jal	80000a42 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001502:	4685                	li	a3,1
    80001504:	00c9d613          	srli	a2,s3,0xc
    80001508:	4581                	li	a1,0
    8000150a:	8556                	mv	a0,s5
    8000150c:	cb3ff0ef          	jal	800011be <uvmunmap>
  return -1;
    80001510:	557d                	li	a0,-1
}
    80001512:	60a6                	ld	ra,72(sp)
    80001514:	6406                	ld	s0,64(sp)
    80001516:	74e2                	ld	s1,56(sp)
    80001518:	7942                	ld	s2,48(sp)
    8000151a:	79a2                	ld	s3,40(sp)
    8000151c:	7a02                	ld	s4,32(sp)
    8000151e:	6ae2                	ld	s5,24(sp)
    80001520:	6b42                	ld	s6,16(sp)
    80001522:	6ba2                	ld	s7,8(sp)
    80001524:	6161                	addi	sp,sp,80
    80001526:	8082                	ret
  return 0;
    80001528:	4501                	li	a0,0
}
    8000152a:	8082                	ret

000000008000152c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000152c:	1141                	addi	sp,sp,-16
    8000152e:	e406                	sd	ra,8(sp)
    80001530:	e022                	sd	s0,0(sp)
    80001532:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001534:	4601                	li	a2,0
    80001536:	a0bff0ef          	jal	80000f40 <walk>
  if(pte == 0)
    8000153a:	c901                	beqz	a0,8000154a <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000153c:	611c                	ld	a5,0(a0)
    8000153e:	9bbd                	andi	a5,a5,-17
    80001540:	e11c                	sd	a5,0(a0)
}
    80001542:	60a2                	ld	ra,8(sp)
    80001544:	6402                	ld	s0,0(sp)
    80001546:	0141                	addi	sp,sp,16
    80001548:	8082                	ret
    panic("uvmclear");
    8000154a:	00006517          	auipc	a0,0x6
    8000154e:	c9e50513          	addi	a0,a0,-866 # 800071e8 <etext+0x1e8>
    80001552:	a42ff0ef          	jal	80000794 <panic>

0000000080001556 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001556:	cad1                	beqz	a3,800015ea <copyout+0x94>
{
    80001558:	711d                	addi	sp,sp,-96
    8000155a:	ec86                	sd	ra,88(sp)
    8000155c:	e8a2                	sd	s0,80(sp)
    8000155e:	e4a6                	sd	s1,72(sp)
    80001560:	fc4e                	sd	s3,56(sp)
    80001562:	f456                	sd	s5,40(sp)
    80001564:	f05a                	sd	s6,32(sp)
    80001566:	ec5e                	sd	s7,24(sp)
    80001568:	1080                	addi	s0,sp,96
    8000156a:	8baa                	mv	s7,a0
    8000156c:	8aae                	mv	s5,a1
    8000156e:	8b32                	mv	s6,a2
    80001570:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001572:	74fd                	lui	s1,0xfffff
    80001574:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001576:	57fd                	li	a5,-1
    80001578:	83e9                	srli	a5,a5,0x1a
    8000157a:	0697ea63          	bltu	a5,s1,800015ee <copyout+0x98>
    8000157e:	e0ca                	sd	s2,64(sp)
    80001580:	f852                	sd	s4,48(sp)
    80001582:	e862                	sd	s8,16(sp)
    80001584:	e466                	sd	s9,8(sp)
    80001586:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001588:	4cd5                	li	s9,21
    8000158a:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    8000158c:	8c3e                	mv	s8,a5
    8000158e:	a025                	j	800015b6 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80001590:	83a9                	srli	a5,a5,0xa
    80001592:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001594:	409a8533          	sub	a0,s5,s1
    80001598:	0009061b          	sext.w	a2,s2
    8000159c:	85da                	mv	a1,s6
    8000159e:	953e                	add	a0,a0,a5
    800015a0:	f84ff0ef          	jal	80000d24 <memmove>

    len -= n;
    800015a4:	412989b3          	sub	s3,s3,s2
    src += n;
    800015a8:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800015aa:	02098963          	beqz	s3,800015dc <copyout+0x86>
    if(va0 >= MAXVA)
    800015ae:	054c6263          	bltu	s8,s4,800015f2 <copyout+0x9c>
    800015b2:	84d2                	mv	s1,s4
    800015b4:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800015b6:	4601                	li	a2,0
    800015b8:	85a6                	mv	a1,s1
    800015ba:	855e                	mv	a0,s7
    800015bc:	985ff0ef          	jal	80000f40 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015c0:	c121                	beqz	a0,80001600 <copyout+0xaa>
    800015c2:	611c                	ld	a5,0(a0)
    800015c4:	0157f713          	andi	a4,a5,21
    800015c8:	05971b63          	bne	a4,s9,8000161e <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    800015cc:	01a48a33          	add	s4,s1,s10
    800015d0:	415a0933          	sub	s2,s4,s5
    if(n > len)
    800015d4:	fb29fee3          	bgeu	s3,s2,80001590 <copyout+0x3a>
    800015d8:	894e                	mv	s2,s3
    800015da:	bf5d                	j	80001590 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    800015dc:	4501                	li	a0,0
    800015de:	6906                	ld	s2,64(sp)
    800015e0:	7a42                	ld	s4,48(sp)
    800015e2:	6c42                	ld	s8,16(sp)
    800015e4:	6ca2                	ld	s9,8(sp)
    800015e6:	6d02                	ld	s10,0(sp)
    800015e8:	a015                	j	8000160c <copyout+0xb6>
    800015ea:	4501                	li	a0,0
}
    800015ec:	8082                	ret
      return -1;
    800015ee:	557d                	li	a0,-1
    800015f0:	a831                	j	8000160c <copyout+0xb6>
    800015f2:	557d                	li	a0,-1
    800015f4:	6906                	ld	s2,64(sp)
    800015f6:	7a42                	ld	s4,48(sp)
    800015f8:	6c42                	ld	s8,16(sp)
    800015fa:	6ca2                	ld	s9,8(sp)
    800015fc:	6d02                	ld	s10,0(sp)
    800015fe:	a039                	j	8000160c <copyout+0xb6>
      return -1;
    80001600:	557d                	li	a0,-1
    80001602:	6906                	ld	s2,64(sp)
    80001604:	7a42                	ld	s4,48(sp)
    80001606:	6c42                	ld	s8,16(sp)
    80001608:	6ca2                	ld	s9,8(sp)
    8000160a:	6d02                	ld	s10,0(sp)
}
    8000160c:	60e6                	ld	ra,88(sp)
    8000160e:	6446                	ld	s0,80(sp)
    80001610:	64a6                	ld	s1,72(sp)
    80001612:	79e2                	ld	s3,56(sp)
    80001614:	7aa2                	ld	s5,40(sp)
    80001616:	7b02                	ld	s6,32(sp)
    80001618:	6be2                	ld	s7,24(sp)
    8000161a:	6125                	addi	sp,sp,96
    8000161c:	8082                	ret
      return -1;
    8000161e:	557d                	li	a0,-1
    80001620:	6906                	ld	s2,64(sp)
    80001622:	7a42                	ld	s4,48(sp)
    80001624:	6c42                	ld	s8,16(sp)
    80001626:	6ca2                	ld	s9,8(sp)
    80001628:	6d02                	ld	s10,0(sp)
    8000162a:	b7cd                	j	8000160c <copyout+0xb6>

000000008000162c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000162c:	c6a5                	beqz	a3,80001694 <copyin+0x68>
{
    8000162e:	715d                	addi	sp,sp,-80
    80001630:	e486                	sd	ra,72(sp)
    80001632:	e0a2                	sd	s0,64(sp)
    80001634:	fc26                	sd	s1,56(sp)
    80001636:	f84a                	sd	s2,48(sp)
    80001638:	f44e                	sd	s3,40(sp)
    8000163a:	f052                	sd	s4,32(sp)
    8000163c:	ec56                	sd	s5,24(sp)
    8000163e:	e85a                	sd	s6,16(sp)
    80001640:	e45e                	sd	s7,8(sp)
    80001642:	e062                	sd	s8,0(sp)
    80001644:	0880                	addi	s0,sp,80
    80001646:	8b2a                	mv	s6,a0
    80001648:	8a2e                	mv	s4,a1
    8000164a:	8c32                	mv	s8,a2
    8000164c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000164e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001650:	6a85                	lui	s5,0x1
    80001652:	a00d                	j	80001674 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001654:	018505b3          	add	a1,a0,s8
    80001658:	0004861b          	sext.w	a2,s1
    8000165c:	412585b3          	sub	a1,a1,s2
    80001660:	8552                	mv	a0,s4
    80001662:	ec2ff0ef          	jal	80000d24 <memmove>

    len -= n;
    80001666:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000166a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000166c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001670:	02098063          	beqz	s3,80001690 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80001674:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001678:	85ca                	mv	a1,s2
    8000167a:	855a                	mv	a0,s6
    8000167c:	95fff0ef          	jal	80000fda <walkaddr>
    if(pa0 == 0)
    80001680:	cd01                	beqz	a0,80001698 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80001682:	418904b3          	sub	s1,s2,s8
    80001686:	94d6                	add	s1,s1,s5
    if(n > len)
    80001688:	fc99f6e3          	bgeu	s3,s1,80001654 <copyin+0x28>
    8000168c:	84ce                	mv	s1,s3
    8000168e:	b7d9                	j	80001654 <copyin+0x28>
  }
  return 0;
    80001690:	4501                	li	a0,0
    80001692:	a021                	j	8000169a <copyin+0x6e>
    80001694:	4501                	li	a0,0
}
    80001696:	8082                	ret
      return -1;
    80001698:	557d                	li	a0,-1
}
    8000169a:	60a6                	ld	ra,72(sp)
    8000169c:	6406                	ld	s0,64(sp)
    8000169e:	74e2                	ld	s1,56(sp)
    800016a0:	7942                	ld	s2,48(sp)
    800016a2:	79a2                	ld	s3,40(sp)
    800016a4:	7a02                	ld	s4,32(sp)
    800016a6:	6ae2                	ld	s5,24(sp)
    800016a8:	6b42                	ld	s6,16(sp)
    800016aa:	6ba2                	ld	s7,8(sp)
    800016ac:	6c02                	ld	s8,0(sp)
    800016ae:	6161                	addi	sp,sp,80
    800016b0:	8082                	ret

00000000800016b2 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800016b2:	c6dd                	beqz	a3,80001760 <copyinstr+0xae>
{
    800016b4:	715d                	addi	sp,sp,-80
    800016b6:	e486                	sd	ra,72(sp)
    800016b8:	e0a2                	sd	s0,64(sp)
    800016ba:	fc26                	sd	s1,56(sp)
    800016bc:	f84a                	sd	s2,48(sp)
    800016be:	f44e                	sd	s3,40(sp)
    800016c0:	f052                	sd	s4,32(sp)
    800016c2:	ec56                	sd	s5,24(sp)
    800016c4:	e85a                	sd	s6,16(sp)
    800016c6:	e45e                	sd	s7,8(sp)
    800016c8:	0880                	addi	s0,sp,80
    800016ca:	8a2a                	mv	s4,a0
    800016cc:	8b2e                	mv	s6,a1
    800016ce:	8bb2                	mv	s7,a2
    800016d0:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800016d2:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016d4:	6985                	lui	s3,0x1
    800016d6:	a825                	j	8000170e <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016d8:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016dc:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016de:	37fd                	addiw	a5,a5,-1
    800016e0:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016e4:	60a6                	ld	ra,72(sp)
    800016e6:	6406                	ld	s0,64(sp)
    800016e8:	74e2                	ld	s1,56(sp)
    800016ea:	7942                	ld	s2,48(sp)
    800016ec:	79a2                	ld	s3,40(sp)
    800016ee:	7a02                	ld	s4,32(sp)
    800016f0:	6ae2                	ld	s5,24(sp)
    800016f2:	6b42                	ld	s6,16(sp)
    800016f4:	6ba2                	ld	s7,8(sp)
    800016f6:	6161                	addi	sp,sp,80
    800016f8:	8082                	ret
    800016fa:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    800016fe:	9742                	add	a4,a4,a6
      --max;
    80001700:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001704:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001708:	04e58463          	beq	a1,a4,80001750 <copyinstr+0x9e>
{
    8000170c:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    8000170e:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001712:	85a6                	mv	a1,s1
    80001714:	8552                	mv	a0,s4
    80001716:	8c5ff0ef          	jal	80000fda <walkaddr>
    if(pa0 == 0)
    8000171a:	cd0d                	beqz	a0,80001754 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    8000171c:	417486b3          	sub	a3,s1,s7
    80001720:	96ce                	add	a3,a3,s3
    if(n > max)
    80001722:	00d97363          	bgeu	s2,a3,80001728 <copyinstr+0x76>
    80001726:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001728:	955e                	add	a0,a0,s7
    8000172a:	8d05                	sub	a0,a0,s1
    while(n > 0){
    8000172c:	c695                	beqz	a3,80001758 <copyinstr+0xa6>
    8000172e:	87da                	mv	a5,s6
    80001730:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001732:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001736:	96da                	add	a3,a3,s6
    80001738:	85be                	mv	a1,a5
      if(*p == '\0'){
    8000173a:	00f60733          	add	a4,a2,a5
    8000173e:	00074703          	lbu	a4,0(a4)
    80001742:	db59                	beqz	a4,800016d8 <copyinstr+0x26>
        *dst = *p;
    80001744:	00e78023          	sb	a4,0(a5)
      dst++;
    80001748:	0785                	addi	a5,a5,1
    while(n > 0){
    8000174a:	fed797e3          	bne	a5,a3,80001738 <copyinstr+0x86>
    8000174e:	b775                	j	800016fa <copyinstr+0x48>
    80001750:	4781                	li	a5,0
    80001752:	b771                	j	800016de <copyinstr+0x2c>
      return -1;
    80001754:	557d                	li	a0,-1
    80001756:	b779                	j	800016e4 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001758:	6b85                	lui	s7,0x1
    8000175a:	9ba6                	add	s7,s7,s1
    8000175c:	87da                	mv	a5,s6
    8000175e:	b77d                	j	8000170c <copyinstr+0x5a>
  int got_null = 0;
    80001760:	4781                	li	a5,0
  if(got_null){
    80001762:	37fd                	addiw	a5,a5,-1
    80001764:	0007851b          	sext.w	a0,a5
}
    80001768:	8082                	ret

000000008000176a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000176a:	7139                	addi	sp,sp,-64
    8000176c:	fc06                	sd	ra,56(sp)
    8000176e:	f822                	sd	s0,48(sp)
    80001770:	f426                	sd	s1,40(sp)
    80001772:	f04a                	sd	s2,32(sp)
    80001774:	ec4e                	sd	s3,24(sp)
    80001776:	e852                	sd	s4,16(sp)
    80001778:	e456                	sd	s5,8(sp)
    8000177a:	e05a                	sd	s6,0(sp)
    8000177c:	0080                	addi	s0,sp,64
    8000177e:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001780:	0000e497          	auipc	s1,0xe
    80001784:	7f048493          	addi	s1,s1,2032 # 8000ff70 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001788:	8b26                	mv	s6,s1
    8000178a:	00a36937          	lui	s2,0xa36
    8000178e:	77d90913          	addi	s2,s2,1917 # a3677d <_entry-0x7f5c9883>
    80001792:	0932                	slli	s2,s2,0xc
    80001794:	46d90913          	addi	s2,s2,1133
    80001798:	0936                	slli	s2,s2,0xd
    8000179a:	df590913          	addi	s2,s2,-523
    8000179e:	093a                	slli	s2,s2,0xe
    800017a0:	6cf90913          	addi	s2,s2,1743
    800017a4:	040009b7          	lui	s3,0x4000
    800017a8:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017aa:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ac:	00014a97          	auipc	s5,0x14
    800017b0:	5c4a8a93          	addi	s5,s5,1476 # 80015d70 <tickslock>
    char *pa = kalloc();
    800017b4:	b70ff0ef          	jal	80000b24 <kalloc>
    800017b8:	862a                	mv	a2,a0
    if(pa == 0)
    800017ba:	cd15                	beqz	a0,800017f6 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017bc:	416485b3          	sub	a1,s1,s6
    800017c0:	858d                	srai	a1,a1,0x3
    800017c2:	032585b3          	mul	a1,a1,s2
    800017c6:	2585                	addiw	a1,a1,1
    800017c8:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017cc:	4719                	li	a4,6
    800017ce:	6685                	lui	a3,0x1
    800017d0:	40b985b3          	sub	a1,s3,a1
    800017d4:	8552                	mv	a0,s4
    800017d6:	8f3ff0ef          	jal	800010c8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017da:	17848493          	addi	s1,s1,376
    800017de:	fd549be3          	bne	s1,s5,800017b4 <proc_mapstacks+0x4a>
  }
}
    800017e2:	70e2                	ld	ra,56(sp)
    800017e4:	7442                	ld	s0,48(sp)
    800017e6:	74a2                	ld	s1,40(sp)
    800017e8:	7902                	ld	s2,32(sp)
    800017ea:	69e2                	ld	s3,24(sp)
    800017ec:	6a42                	ld	s4,16(sp)
    800017ee:	6aa2                	ld	s5,8(sp)
    800017f0:	6b02                	ld	s6,0(sp)
    800017f2:	6121                	addi	sp,sp,64
    800017f4:	8082                	ret
      panic("kalloc");
    800017f6:	00006517          	auipc	a0,0x6
    800017fa:	a0250513          	addi	a0,a0,-1534 # 800071f8 <etext+0x1f8>
    800017fe:	f97fe0ef          	jal	80000794 <panic>

0000000080001802 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001802:	715d                	addi	sp,sp,-80
    80001804:	e486                	sd	ra,72(sp)
    80001806:	e0a2                	sd	s0,64(sp)
    80001808:	fc26                	sd	s1,56(sp)
    8000180a:	f84a                	sd	s2,48(sp)
    8000180c:	f44e                	sd	s3,40(sp)
    8000180e:	f052                	sd	s4,32(sp)
    80001810:	ec56                	sd	s5,24(sp)
    80001812:	e85a                	sd	s6,16(sp)
    80001814:	e45e                	sd	s7,8(sp)
    80001816:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001818:	00006597          	auipc	a1,0x6
    8000181c:	9e858593          	addi	a1,a1,-1560 # 80007200 <etext+0x200>
    80001820:	0000e517          	auipc	a0,0xe
    80001824:	29050513          	addi	a0,a0,656 # 8000fab0 <pid_lock>
    80001828:	b4cff0ef          	jal	80000b74 <initlock>
  initlock(&wait_lock, "wait_lock");
    8000182c:	00006597          	auipc	a1,0x6
    80001830:	9dc58593          	addi	a1,a1,-1572 # 80007208 <etext+0x208>
    80001834:	0000e517          	auipc	a0,0xe
    80001838:	29450513          	addi	a0,a0,660 # 8000fac8 <wait_lock>
    8000183c:	b38ff0ef          	jal	80000b74 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001840:	0000e497          	auipc	s1,0xe
    80001844:	73048493          	addi	s1,s1,1840 # 8000ff70 <proc>
      initlock(&p->lock, "proc");
    80001848:	00006b97          	auipc	s7,0x6
    8000184c:	9d0b8b93          	addi	s7,s7,-1584 # 80007218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001850:	8b26                	mv	s6,s1
    80001852:	00a36937          	lui	s2,0xa36
    80001856:	77d90913          	addi	s2,s2,1917 # a3677d <_entry-0x7f5c9883>
    8000185a:	0932                	slli	s2,s2,0xc
    8000185c:	46d90913          	addi	s2,s2,1133
    80001860:	0936                	slli	s2,s2,0xd
    80001862:	df590913          	addi	s2,s2,-523
    80001866:	093a                	slli	s2,s2,0xe
    80001868:	6cf90913          	addi	s2,s2,1743
    8000186c:	040009b7          	lui	s3,0x4000
    80001870:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001872:	09b2                	slli	s3,s3,0xc
      p->priority = 1;
    80001874:	4a85                	li	s5,1
  for(p = proc; p < &proc[NPROC]; p++) {
    80001876:	00014a17          	auipc	s4,0x14
    8000187a:	4faa0a13          	addi	s4,s4,1274 # 80015d70 <tickslock>
      initlock(&p->lock, "proc");
    8000187e:	85de                	mv	a1,s7
    80001880:	8526                	mv	a0,s1
    80001882:	af2ff0ef          	jal	80000b74 <initlock>
      p->state = UNUSED;
    80001886:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    8000188a:	416487b3          	sub	a5,s1,s6
    8000188e:	878d                	srai	a5,a5,0x3
    80001890:	032787b3          	mul	a5,a5,s2
    80001894:	2785                	addiw	a5,a5,1
    80001896:	00d7979b          	slliw	a5,a5,0xd
    8000189a:	40f987b3          	sub	a5,s3,a5
    8000189e:	e0bc                	sd	a5,64(s1)
      p->priority = 1;
    800018a0:	1754a423          	sw	s5,360(s1)
      p->next_p_priority = NULL;
    800018a4:	1604b823          	sd	zero,368(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018a8:	17848493          	addi	s1,s1,376
    800018ac:	fd4499e3          	bne	s1,s4,8000187e <procinit+0x7c>
  }
}
    800018b0:	60a6                	ld	ra,72(sp)
    800018b2:	6406                	ld	s0,64(sp)
    800018b4:	74e2                	ld	s1,56(sp)
    800018b6:	7942                	ld	s2,48(sp)
    800018b8:	79a2                	ld	s3,40(sp)
    800018ba:	7a02                	ld	s4,32(sp)
    800018bc:	6ae2                	ld	s5,24(sp)
    800018be:	6b42                	ld	s6,16(sp)
    800018c0:	6ba2                	ld	s7,8(sp)
    800018c2:	6161                	addi	sp,sp,80
    800018c4:	8082                	ret

00000000800018c6 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018c6:	1141                	addi	sp,sp,-16
    800018c8:	e422                	sd	s0,8(sp)
    800018ca:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018cc:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018ce:	2501                	sext.w	a0,a0
    800018d0:	6422                	ld	s0,8(sp)
    800018d2:	0141                	addi	sp,sp,16
    800018d4:	8082                	ret

00000000800018d6 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018d6:	1141                	addi	sp,sp,-16
    800018d8:	e422                	sd	s0,8(sp)
    800018da:	0800                	addi	s0,sp,16
    800018dc:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018de:	2781                	sext.w	a5,a5
    800018e0:	079e                	slli	a5,a5,0x7
  return c;
}
    800018e2:	0000e517          	auipc	a0,0xe
    800018e6:	1fe50513          	addi	a0,a0,510 # 8000fae0 <cpus>
    800018ea:	953e                	add	a0,a0,a5
    800018ec:	6422                	ld	s0,8(sp)
    800018ee:	0141                	addi	sp,sp,16
    800018f0:	8082                	ret

00000000800018f2 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800018f2:	1101                	addi	sp,sp,-32
    800018f4:	ec06                	sd	ra,24(sp)
    800018f6:	e822                	sd	s0,16(sp)
    800018f8:	e426                	sd	s1,8(sp)
    800018fa:	1000                	addi	s0,sp,32
  push_off();
    800018fc:	ab8ff0ef          	jal	80000bb4 <push_off>
    80001900:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001902:	2781                	sext.w	a5,a5
    80001904:	079e                	slli	a5,a5,0x7
    80001906:	0000e717          	auipc	a4,0xe
    8000190a:	1aa70713          	addi	a4,a4,426 # 8000fab0 <pid_lock>
    8000190e:	97ba                	add	a5,a5,a4
    80001910:	7b84                	ld	s1,48(a5)
  pop_off();
    80001912:	b26ff0ef          	jal	80000c38 <pop_off>
  return p;
}
    80001916:	8526                	mv	a0,s1
    80001918:	60e2                	ld	ra,24(sp)
    8000191a:	6442                	ld	s0,16(sp)
    8000191c:	64a2                	ld	s1,8(sp)
    8000191e:	6105                	addi	sp,sp,32
    80001920:	8082                	ret

0000000080001922 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001922:	1141                	addi	sp,sp,-16
    80001924:	e406                	sd	ra,8(sp)
    80001926:	e022                	sd	s0,0(sp)
    80001928:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000192a:	fc9ff0ef          	jal	800018f2 <myproc>
    8000192e:	b5eff0ef          	jal	80000c8c <release>

  if (first) {
    80001932:	00006797          	auipc	a5,0x6
    80001936:	fce7a783          	lw	a5,-50(a5) # 80007900 <first.1>
    8000193a:	e799                	bnez	a5,80001948 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    8000193c:	3f3000ef          	jal	8000252e <usertrapret>
}
    80001940:	60a2                	ld	ra,8(sp)
    80001942:	6402                	ld	s0,0(sp)
    80001944:	0141                	addi	sp,sp,16
    80001946:	8082                	ret
    fsinit(ROOTDEV);
    80001948:	4505                	li	a0,1
    8000194a:	788010ef          	jal	800030d2 <fsinit>
    first = 0;
    8000194e:	00006797          	auipc	a5,0x6
    80001952:	fa07a923          	sw	zero,-78(a5) # 80007900 <first.1>
    __sync_synchronize();
    80001956:	0ff0000f          	fence
    8000195a:	b7cd                	j	8000193c <forkret+0x1a>

000000008000195c <allocpid>:
{
    8000195c:	1101                	addi	sp,sp,-32
    8000195e:	ec06                	sd	ra,24(sp)
    80001960:	e822                	sd	s0,16(sp)
    80001962:	e426                	sd	s1,8(sp)
    80001964:	e04a                	sd	s2,0(sp)
    80001966:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001968:	0000e917          	auipc	s2,0xe
    8000196c:	14890913          	addi	s2,s2,328 # 8000fab0 <pid_lock>
    80001970:	854a                	mv	a0,s2
    80001972:	a82ff0ef          	jal	80000bf4 <acquire>
  pid = nextpid;
    80001976:	00006797          	auipc	a5,0x6
    8000197a:	f8e78793          	addi	a5,a5,-114 # 80007904 <nextpid>
    8000197e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001980:	0014871b          	addiw	a4,s1,1
    80001984:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001986:	854a                	mv	a0,s2
    80001988:	b04ff0ef          	jal	80000c8c <release>
}
    8000198c:	8526                	mv	a0,s1
    8000198e:	60e2                	ld	ra,24(sp)
    80001990:	6442                	ld	s0,16(sp)
    80001992:	64a2                	ld	s1,8(sp)
    80001994:	6902                	ld	s2,0(sp)
    80001996:	6105                	addi	sp,sp,32
    80001998:	8082                	ret

000000008000199a <proc_pagetable>:
{
    8000199a:	1101                	addi	sp,sp,-32
    8000199c:	ec06                	sd	ra,24(sp)
    8000199e:	e822                	sd	s0,16(sp)
    800019a0:	e426                	sd	s1,8(sp)
    800019a2:	e04a                	sd	s2,0(sp)
    800019a4:	1000                	addi	s0,sp,32
    800019a6:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800019a8:	8d3ff0ef          	jal	8000127a <uvmcreate>
    800019ac:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800019ae:	cd05                	beqz	a0,800019e6 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800019b0:	4729                	li	a4,10
    800019b2:	00004697          	auipc	a3,0x4
    800019b6:	64e68693          	addi	a3,a3,1614 # 80006000 <_trampoline>
    800019ba:	6605                	lui	a2,0x1
    800019bc:	040005b7          	lui	a1,0x4000
    800019c0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019c2:	05b2                	slli	a1,a1,0xc
    800019c4:	e54ff0ef          	jal	80001018 <mappages>
    800019c8:	02054663          	bltz	a0,800019f4 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800019cc:	4719                	li	a4,6
    800019ce:	05893683          	ld	a3,88(s2)
    800019d2:	6605                	lui	a2,0x1
    800019d4:	020005b7          	lui	a1,0x2000
    800019d8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019da:	05b6                	slli	a1,a1,0xd
    800019dc:	8526                	mv	a0,s1
    800019de:	e3aff0ef          	jal	80001018 <mappages>
    800019e2:	00054f63          	bltz	a0,80001a00 <proc_pagetable+0x66>
}
    800019e6:	8526                	mv	a0,s1
    800019e8:	60e2                	ld	ra,24(sp)
    800019ea:	6442                	ld	s0,16(sp)
    800019ec:	64a2                	ld	s1,8(sp)
    800019ee:	6902                	ld	s2,0(sp)
    800019f0:	6105                	addi	sp,sp,32
    800019f2:	8082                	ret
    uvmfree(pagetable, 0);
    800019f4:	4581                	li	a1,0
    800019f6:	8526                	mv	a0,s1
    800019f8:	a51ff0ef          	jal	80001448 <uvmfree>
    return 0;
    800019fc:	4481                	li	s1,0
    800019fe:	b7e5                	j	800019e6 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a00:	4681                	li	a3,0
    80001a02:	4605                	li	a2,1
    80001a04:	040005b7          	lui	a1,0x4000
    80001a08:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a0a:	05b2                	slli	a1,a1,0xc
    80001a0c:	8526                	mv	a0,s1
    80001a0e:	fb0ff0ef          	jal	800011be <uvmunmap>
    uvmfree(pagetable, 0);
    80001a12:	4581                	li	a1,0
    80001a14:	8526                	mv	a0,s1
    80001a16:	a33ff0ef          	jal	80001448 <uvmfree>
    return 0;
    80001a1a:	4481                	li	s1,0
    80001a1c:	b7e9                	j	800019e6 <proc_pagetable+0x4c>

0000000080001a1e <proc_freepagetable>:
{
    80001a1e:	1101                	addi	sp,sp,-32
    80001a20:	ec06                	sd	ra,24(sp)
    80001a22:	e822                	sd	s0,16(sp)
    80001a24:	e426                	sd	s1,8(sp)
    80001a26:	e04a                	sd	s2,0(sp)
    80001a28:	1000                	addi	s0,sp,32
    80001a2a:	84aa                	mv	s1,a0
    80001a2c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a2e:	4681                	li	a3,0
    80001a30:	4605                	li	a2,1
    80001a32:	040005b7          	lui	a1,0x4000
    80001a36:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a38:	05b2                	slli	a1,a1,0xc
    80001a3a:	f84ff0ef          	jal	800011be <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a3e:	4681                	li	a3,0
    80001a40:	4605                	li	a2,1
    80001a42:	020005b7          	lui	a1,0x2000
    80001a46:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a48:	05b6                	slli	a1,a1,0xd
    80001a4a:	8526                	mv	a0,s1
    80001a4c:	f72ff0ef          	jal	800011be <uvmunmap>
  uvmfree(pagetable, sz);
    80001a50:	85ca                	mv	a1,s2
    80001a52:	8526                	mv	a0,s1
    80001a54:	9f5ff0ef          	jal	80001448 <uvmfree>
}
    80001a58:	60e2                	ld	ra,24(sp)
    80001a5a:	6442                	ld	s0,16(sp)
    80001a5c:	64a2                	ld	s1,8(sp)
    80001a5e:	6902                	ld	s2,0(sp)
    80001a60:	6105                	addi	sp,sp,32
    80001a62:	8082                	ret

0000000080001a64 <freeproc>:
{
    80001a64:	1101                	addi	sp,sp,-32
    80001a66:	ec06                	sd	ra,24(sp)
    80001a68:	e822                	sd	s0,16(sp)
    80001a6a:	e426                	sd	s1,8(sp)
    80001a6c:	1000                	addi	s0,sp,32
    80001a6e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001a70:	6d28                	ld	a0,88(a0)
    80001a72:	c119                	beqz	a0,80001a78 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001a74:	fcffe0ef          	jal	80000a42 <kfree>
  p->trapframe = 0;
    80001a78:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001a7c:	68a8                	ld	a0,80(s1)
    80001a7e:	c501                	beqz	a0,80001a86 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001a80:	64ac                	ld	a1,72(s1)
    80001a82:	f9dff0ef          	jal	80001a1e <proc_freepagetable>
  p->pagetable = 0;
    80001a86:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001a8a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001a8e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001a92:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001a96:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001a9a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001a9e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001aa2:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001aa6:	0004ac23          	sw	zero,24(s1)
}
    80001aaa:	60e2                	ld	ra,24(sp)
    80001aac:	6442                	ld	s0,16(sp)
    80001aae:	64a2                	ld	s1,8(sp)
    80001ab0:	6105                	addi	sp,sp,32
    80001ab2:	8082                	ret

0000000080001ab4 <growproc>:
{
    80001ab4:	1101                	addi	sp,sp,-32
    80001ab6:	ec06                	sd	ra,24(sp)
    80001ab8:	e822                	sd	s0,16(sp)
    80001aba:	e426                	sd	s1,8(sp)
    80001abc:	e04a                	sd	s2,0(sp)
    80001abe:	1000                	addi	s0,sp,32
    80001ac0:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001ac2:	e31ff0ef          	jal	800018f2 <myproc>
    80001ac6:	84aa                	mv	s1,a0
  sz = p->sz;
    80001ac8:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001aca:	01204c63          	bgtz	s2,80001ae2 <growproc+0x2e>
  } else if(n < 0){
    80001ace:	02094463          	bltz	s2,80001af6 <growproc+0x42>
  p->sz = sz;
    80001ad2:	e4ac                	sd	a1,72(s1)
  return 0;
    80001ad4:	4501                	li	a0,0
}
    80001ad6:	60e2                	ld	ra,24(sp)
    80001ad8:	6442                	ld	s0,16(sp)
    80001ada:	64a2                	ld	s1,8(sp)
    80001adc:	6902                	ld	s2,0(sp)
    80001ade:	6105                	addi	sp,sp,32
    80001ae0:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001ae2:	4691                	li	a3,4
    80001ae4:	00b90633          	add	a2,s2,a1
    80001ae8:	6928                	ld	a0,80(a0)
    80001aea:	859ff0ef          	jal	80001342 <uvmalloc>
    80001aee:	85aa                	mv	a1,a0
    80001af0:	f16d                	bnez	a0,80001ad2 <growproc+0x1e>
      return -1;
    80001af2:	557d                	li	a0,-1
    80001af4:	b7cd                	j	80001ad6 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001af6:	00b90633          	add	a2,s2,a1
    80001afa:	6928                	ld	a0,80(a0)
    80001afc:	803ff0ef          	jal	800012fe <uvmdealloc>
    80001b00:	85aa                	mv	a1,a0
    80001b02:	bfc1                	j	80001ad2 <growproc+0x1e>

0000000080001b04 <scheduler>:
{
    80001b04:	711d                	addi	sp,sp,-96
    80001b06:	ec86                	sd	ra,88(sp)
    80001b08:	e8a2                	sd	s0,80(sp)
    80001b0a:	e4a6                	sd	s1,72(sp)
    80001b0c:	e0ca                	sd	s2,64(sp)
    80001b0e:	fc4e                	sd	s3,56(sp)
    80001b10:	f852                	sd	s4,48(sp)
    80001b12:	f456                	sd	s5,40(sp)
    80001b14:	f05a                	sd	s6,32(sp)
    80001b16:	ec5e                	sd	s7,24(sp)
    80001b18:	e862                	sd	s8,16(sp)
    80001b1a:	e466                	sd	s9,8(sp)
    80001b1c:	1080                	addi	s0,sp,96
    80001b1e:	8792                	mv	a5,tp
  int id = r_tp();
    80001b20:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001b22:	00779b93          	slli	s7,a5,0x7
    80001b26:	0000e717          	auipc	a4,0xe
    80001b2a:	f8a70713          	addi	a4,a4,-118 # 8000fab0 <pid_lock>
    80001b2e:	975e                	add	a4,a4,s7
    80001b30:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001b34:	0000e717          	auipc	a4,0xe
    80001b38:	fb470713          	addi	a4,a4,-76 # 8000fae8 <cpus+0x8>
    80001b3c:	9bba                	add	s7,s7,a4
        printf("The process is %s and the priority is %d\n", p->name, p->priority);
    80001b3e:	00005c97          	auipc	s9,0x5
    80001b42:	6e2c8c93          	addi	s9,s9,1762 # 80007220 <etext+0x220>
        p->state = RUNNING;
    80001b46:	4c11                	li	s8,4
        c->proc = p;
    80001b48:	079e                	slli	a5,a5,0x7
    80001b4a:	0000ea17          	auipc	s4,0xe
    80001b4e:	f66a0a13          	addi	s4,s4,-154 # 8000fab0 <pid_lock>
    80001b52:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001b54:	00014997          	auipc	s3,0x14
    80001b58:	21c98993          	addi	s3,s3,540 # 80015d70 <tickslock>
    80001b5c:	a8b5                	j	80001bd8 <scheduler+0xd4>
        p->state = RUNNING;
    80001b5e:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001b62:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001b66:	060a8593          	addi	a1,s5,96
    80001b6a:	855e                	mv	a0,s7
    80001b6c:	11d000ef          	jal	80002488 <swtch>
        c->proc = 0;
    80001b70:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001b74:	8ada                	mv	s5,s6
      release(&p->lock);
    80001b76:	8526                	mv	a0,s1
    80001b78:	914ff0ef          	jal	80000c8c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001b7c:	17848493          	addi	s1,s1,376
    80001b80:	05348263          	beq	s1,s3,80001bc4 <scheduler+0xc0>
      acquire(&p->lock);
    80001b84:	8526                	mv	a0,s1
    80001b86:	86eff0ef          	jal	80000bf4 <acquire>
      if(p->state == RUNNABLE) {
    80001b8a:	4c9c                	lw	a5,24(s1)
    80001b8c:	ff2795e3          	bne	a5,s2,80001b76 <scheduler+0x72>
    80001b90:	8aa6                	mv	s5,s1
        printf("The process is %s and the priority is %d\n", p->name, p->priority);
    80001b92:	1684a603          	lw	a2,360(s1)
    80001b96:	15848593          	addi	a1,s1,344
    80001b9a:	8566                	mv	a0,s9
    80001b9c:	927fe0ef          	jal	800004c2 <printf>
        if(p->next_p_priority != NULL){
    80001ba0:	1704b583          	ld	a1,368(s1)
    80001ba4:	ddcd                	beqz	a1,80001b5e <scheduler+0x5a>
          printf("The next process of priority is %s \n", p->next_p_priority->name);
    80001ba6:	15858593          	addi	a1,a1,344
    80001baa:	00005517          	auipc	a0,0x5
    80001bae:	6a650513          	addi	a0,a0,1702 # 80007250 <etext+0x250>
    80001bb2:	911fe0ef          	jal	800004c2 <printf>
          printf("\n");
    80001bb6:	00005517          	auipc	a0,0x5
    80001bba:	4c250513          	addi	a0,a0,1218 # 80007078 <etext+0x78>
    80001bbe:	905fe0ef          	jal	800004c2 <printf>
    80001bc2:	bf71                	j	80001b5e <scheduler+0x5a>
    if(found == 0) {
    80001bc4:	000a9a63          	bnez	s5,80001bd8 <scheduler+0xd4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bc8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001bcc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bd0:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001bd4:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bd8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001bdc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001be0:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001be4:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001be6:	0000e497          	auipc	s1,0xe
    80001bea:	38a48493          	addi	s1,s1,906 # 8000ff70 <proc>
      if(p->state == RUNNABLE) {
    80001bee:	490d                	li	s2,3
        found = 1;
    80001bf0:	4b05                	li	s6,1
    80001bf2:	bf49                	j	80001b84 <scheduler+0x80>

0000000080001bf4 <sched>:
{
    80001bf4:	7179                	addi	sp,sp,-48
    80001bf6:	f406                	sd	ra,40(sp)
    80001bf8:	f022                	sd	s0,32(sp)
    80001bfa:	ec26                	sd	s1,24(sp)
    80001bfc:	e84a                	sd	s2,16(sp)
    80001bfe:	e44e                	sd	s3,8(sp)
    80001c00:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001c02:	cf1ff0ef          	jal	800018f2 <myproc>
    80001c06:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001c08:	f83fe0ef          	jal	80000b8a <holding>
    80001c0c:	c92d                	beqz	a0,80001c7e <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c0e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001c10:	2781                	sext.w	a5,a5
    80001c12:	079e                	slli	a5,a5,0x7
    80001c14:	0000e717          	auipc	a4,0xe
    80001c18:	e9c70713          	addi	a4,a4,-356 # 8000fab0 <pid_lock>
    80001c1c:	97ba                	add	a5,a5,a4
    80001c1e:	0a87a703          	lw	a4,168(a5)
    80001c22:	4785                	li	a5,1
    80001c24:	06f71363          	bne	a4,a5,80001c8a <sched+0x96>
  if(p->state == RUNNING)
    80001c28:	4c98                	lw	a4,24(s1)
    80001c2a:	4791                	li	a5,4
    80001c2c:	06f70563          	beq	a4,a5,80001c96 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c30:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001c34:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001c36:	e7b5                	bnez	a5,80001ca2 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c38:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001c3a:	0000e917          	auipc	s2,0xe
    80001c3e:	e7690913          	addi	s2,s2,-394 # 8000fab0 <pid_lock>
    80001c42:	2781                	sext.w	a5,a5
    80001c44:	079e                	slli	a5,a5,0x7
    80001c46:	97ca                	add	a5,a5,s2
    80001c48:	0ac7a983          	lw	s3,172(a5)
    80001c4c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001c4e:	2781                	sext.w	a5,a5
    80001c50:	079e                	slli	a5,a5,0x7
    80001c52:	0000e597          	auipc	a1,0xe
    80001c56:	e9658593          	addi	a1,a1,-362 # 8000fae8 <cpus+0x8>
    80001c5a:	95be                	add	a1,a1,a5
    80001c5c:	06048513          	addi	a0,s1,96
    80001c60:	029000ef          	jal	80002488 <swtch>
    80001c64:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001c66:	2781                	sext.w	a5,a5
    80001c68:	079e                	slli	a5,a5,0x7
    80001c6a:	993e                	add	s2,s2,a5
    80001c6c:	0b392623          	sw	s3,172(s2)
}
    80001c70:	70a2                	ld	ra,40(sp)
    80001c72:	7402                	ld	s0,32(sp)
    80001c74:	64e2                	ld	s1,24(sp)
    80001c76:	6942                	ld	s2,16(sp)
    80001c78:	69a2                	ld	s3,8(sp)
    80001c7a:	6145                	addi	sp,sp,48
    80001c7c:	8082                	ret
    panic("sched p->lock");
    80001c7e:	00005517          	auipc	a0,0x5
    80001c82:	5fa50513          	addi	a0,a0,1530 # 80007278 <etext+0x278>
    80001c86:	b0ffe0ef          	jal	80000794 <panic>
    panic("sched locks");
    80001c8a:	00005517          	auipc	a0,0x5
    80001c8e:	5fe50513          	addi	a0,a0,1534 # 80007288 <etext+0x288>
    80001c92:	b03fe0ef          	jal	80000794 <panic>
    panic("sched running");
    80001c96:	00005517          	auipc	a0,0x5
    80001c9a:	60250513          	addi	a0,a0,1538 # 80007298 <etext+0x298>
    80001c9e:	af7fe0ef          	jal	80000794 <panic>
    panic("sched interruptible");
    80001ca2:	00005517          	auipc	a0,0x5
    80001ca6:	60650513          	addi	a0,a0,1542 # 800072a8 <etext+0x2a8>
    80001caa:	aebfe0ef          	jal	80000794 <panic>

0000000080001cae <yield>:
{
    80001cae:	1101                	addi	sp,sp,-32
    80001cb0:	ec06                	sd	ra,24(sp)
    80001cb2:	e822                	sd	s0,16(sp)
    80001cb4:	e426                	sd	s1,8(sp)
    80001cb6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001cb8:	c3bff0ef          	jal	800018f2 <myproc>
    80001cbc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001cbe:	f37fe0ef          	jal	80000bf4 <acquire>
  p->state = RUNNABLE;
    80001cc2:	478d                	li	a5,3
    80001cc4:	cc9c                	sw	a5,24(s1)
  sched();
    80001cc6:	f2fff0ef          	jal	80001bf4 <sched>
  release(&p->lock);
    80001cca:	8526                	mv	a0,s1
    80001ccc:	fc1fe0ef          	jal	80000c8c <release>
}
    80001cd0:	60e2                	ld	ra,24(sp)
    80001cd2:	6442                	ld	s0,16(sp)
    80001cd4:	64a2                	ld	s1,8(sp)
    80001cd6:	6105                	addi	sp,sp,32
    80001cd8:	8082                	ret

0000000080001cda <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001cda:	7179                	addi	sp,sp,-48
    80001cdc:	f406                	sd	ra,40(sp)
    80001cde:	f022                	sd	s0,32(sp)
    80001ce0:	ec26                	sd	s1,24(sp)
    80001ce2:	e84a                	sd	s2,16(sp)
    80001ce4:	e44e                	sd	s3,8(sp)
    80001ce6:	1800                	addi	s0,sp,48
    80001ce8:	89aa                	mv	s3,a0
    80001cea:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001cec:	c07ff0ef          	jal	800018f2 <myproc>
    80001cf0:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001cf2:	f03fe0ef          	jal	80000bf4 <acquire>
  release(lk);
    80001cf6:	854a                	mv	a0,s2
    80001cf8:	f95fe0ef          	jal	80000c8c <release>

  // Go to sleep.
  p->chan = chan;
    80001cfc:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001d00:	4789                	li	a5,2
    80001d02:	cc9c                	sw	a5,24(s1)

  sched();
    80001d04:	ef1ff0ef          	jal	80001bf4 <sched>

  // Tidy up.
  p->chan = 0;
    80001d08:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001d0c:	8526                	mv	a0,s1
    80001d0e:	f7ffe0ef          	jal	80000c8c <release>
  acquire(lk);
    80001d12:	854a                	mv	a0,s2
    80001d14:	ee1fe0ef          	jal	80000bf4 <acquire>
}
    80001d18:	70a2                	ld	ra,40(sp)
    80001d1a:	7402                	ld	s0,32(sp)
    80001d1c:	64e2                	ld	s1,24(sp)
    80001d1e:	6942                	ld	s2,16(sp)
    80001d20:	69a2                	ld	s3,8(sp)
    80001d22:	6145                	addi	sp,sp,48
    80001d24:	8082                	ret

0000000080001d26 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001d26:	7139                	addi	sp,sp,-64
    80001d28:	fc06                	sd	ra,56(sp)
    80001d2a:	f822                	sd	s0,48(sp)
    80001d2c:	f426                	sd	s1,40(sp)
    80001d2e:	f04a                	sd	s2,32(sp)
    80001d30:	ec4e                	sd	s3,24(sp)
    80001d32:	e852                	sd	s4,16(sp)
    80001d34:	e456                	sd	s5,8(sp)
    80001d36:	0080                	addi	s0,sp,64
    80001d38:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001d3a:	0000e497          	auipc	s1,0xe
    80001d3e:	23648493          	addi	s1,s1,566 # 8000ff70 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001d42:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001d44:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d46:	00014917          	auipc	s2,0x14
    80001d4a:	02a90913          	addi	s2,s2,42 # 80015d70 <tickslock>
    80001d4e:	a801                	j	80001d5e <wakeup+0x38>
      }
      release(&p->lock);
    80001d50:	8526                	mv	a0,s1
    80001d52:	f3bfe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d56:	17848493          	addi	s1,s1,376
    80001d5a:	03248263          	beq	s1,s2,80001d7e <wakeup+0x58>
    if(p != myproc()){
    80001d5e:	b95ff0ef          	jal	800018f2 <myproc>
    80001d62:	fea48ae3          	beq	s1,a0,80001d56 <wakeup+0x30>
      acquire(&p->lock);
    80001d66:	8526                	mv	a0,s1
    80001d68:	e8dfe0ef          	jal	80000bf4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001d6c:	4c9c                	lw	a5,24(s1)
    80001d6e:	ff3791e3          	bne	a5,s3,80001d50 <wakeup+0x2a>
    80001d72:	709c                	ld	a5,32(s1)
    80001d74:	fd479ee3          	bne	a5,s4,80001d50 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001d78:	0154ac23          	sw	s5,24(s1)
    80001d7c:	bfd1                	j	80001d50 <wakeup+0x2a>
    }
  }
}
    80001d7e:	70e2                	ld	ra,56(sp)
    80001d80:	7442                	ld	s0,48(sp)
    80001d82:	74a2                	ld	s1,40(sp)
    80001d84:	7902                	ld	s2,32(sp)
    80001d86:	69e2                	ld	s3,24(sp)
    80001d88:	6a42                	ld	s4,16(sp)
    80001d8a:	6aa2                	ld	s5,8(sp)
    80001d8c:	6121                	addi	sp,sp,64
    80001d8e:	8082                	ret

0000000080001d90 <reparent>:
{
    80001d90:	7179                	addi	sp,sp,-48
    80001d92:	f406                	sd	ra,40(sp)
    80001d94:	f022                	sd	s0,32(sp)
    80001d96:	ec26                	sd	s1,24(sp)
    80001d98:	e84a                	sd	s2,16(sp)
    80001d9a:	e44e                	sd	s3,8(sp)
    80001d9c:	e052                	sd	s4,0(sp)
    80001d9e:	1800                	addi	s0,sp,48
    80001da0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001da2:	0000e497          	auipc	s1,0xe
    80001da6:	1ce48493          	addi	s1,s1,462 # 8000ff70 <proc>
      pp->parent = initproc;
    80001daa:	00006a17          	auipc	s4,0x6
    80001dae:	bcea0a13          	addi	s4,s4,-1074 # 80007978 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001db2:	00014997          	auipc	s3,0x14
    80001db6:	fbe98993          	addi	s3,s3,-66 # 80015d70 <tickslock>
    80001dba:	a029                	j	80001dc4 <reparent+0x34>
    80001dbc:	17848493          	addi	s1,s1,376
    80001dc0:	01348b63          	beq	s1,s3,80001dd6 <reparent+0x46>
    if(pp->parent == p){
    80001dc4:	7c9c                	ld	a5,56(s1)
    80001dc6:	ff279be3          	bne	a5,s2,80001dbc <reparent+0x2c>
      pp->parent = initproc;
    80001dca:	000a3503          	ld	a0,0(s4)
    80001dce:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001dd0:	f57ff0ef          	jal	80001d26 <wakeup>
    80001dd4:	b7e5                	j	80001dbc <reparent+0x2c>
}
    80001dd6:	70a2                	ld	ra,40(sp)
    80001dd8:	7402                	ld	s0,32(sp)
    80001dda:	64e2                	ld	s1,24(sp)
    80001ddc:	6942                	ld	s2,16(sp)
    80001dde:	69a2                	ld	s3,8(sp)
    80001de0:	6a02                	ld	s4,0(sp)
    80001de2:	6145                	addi	sp,sp,48
    80001de4:	8082                	ret

0000000080001de6 <exit>:
{
    80001de6:	7179                	addi	sp,sp,-48
    80001de8:	f406                	sd	ra,40(sp)
    80001dea:	f022                	sd	s0,32(sp)
    80001dec:	ec26                	sd	s1,24(sp)
    80001dee:	e84a                	sd	s2,16(sp)
    80001df0:	e44e                	sd	s3,8(sp)
    80001df2:	e052                	sd	s4,0(sp)
    80001df4:	1800                	addi	s0,sp,48
    80001df6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001df8:	afbff0ef          	jal	800018f2 <myproc>
    80001dfc:	89aa                	mv	s3,a0
  if(p == initproc)
    80001dfe:	00006797          	auipc	a5,0x6
    80001e02:	b7a7b783          	ld	a5,-1158(a5) # 80007978 <initproc>
    80001e06:	0d050493          	addi	s1,a0,208
    80001e0a:	15050913          	addi	s2,a0,336
    80001e0e:	00a79f63          	bne	a5,a0,80001e2c <exit+0x46>
    panic("init exiting");
    80001e12:	00005517          	auipc	a0,0x5
    80001e16:	4ae50513          	addi	a0,a0,1198 # 800072c0 <etext+0x2c0>
    80001e1a:	97bfe0ef          	jal	80000794 <panic>
      fileclose(f);
    80001e1e:	198020ef          	jal	80003fb6 <fileclose>
      p->ofile[fd] = 0;
    80001e22:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001e26:	04a1                	addi	s1,s1,8
    80001e28:	01248563          	beq	s1,s2,80001e32 <exit+0x4c>
    if(p->ofile[fd]){
    80001e2c:	6088                	ld	a0,0(s1)
    80001e2e:	f965                	bnez	a0,80001e1e <exit+0x38>
    80001e30:	bfdd                	j	80001e26 <exit+0x40>
  begin_op();
    80001e32:	56b010ef          	jal	80003b9c <begin_op>
  iput(p->cwd);
    80001e36:	1509b503          	ld	a0,336(s3)
    80001e3a:	64e010ef          	jal	80003488 <iput>
  end_op();
    80001e3e:	5c9010ef          	jal	80003c06 <end_op>
  p->cwd = 0;
    80001e42:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001e46:	0000e497          	auipc	s1,0xe
    80001e4a:	c8248493          	addi	s1,s1,-894 # 8000fac8 <wait_lock>
    80001e4e:	8526                	mv	a0,s1
    80001e50:	da5fe0ef          	jal	80000bf4 <acquire>
  reparent(p);
    80001e54:	854e                	mv	a0,s3
    80001e56:	f3bff0ef          	jal	80001d90 <reparent>
  wakeup(p->parent);
    80001e5a:	0389b503          	ld	a0,56(s3)
    80001e5e:	ec9ff0ef          	jal	80001d26 <wakeup>
  acquire(&p->lock);
    80001e62:	854e                	mv	a0,s3
    80001e64:	d91fe0ef          	jal	80000bf4 <acquire>
  p->xstate = status;
    80001e68:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001e6c:	4795                	li	a5,5
    80001e6e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001e72:	8526                	mv	a0,s1
    80001e74:	e19fe0ef          	jal	80000c8c <release>
  sched();
    80001e78:	d7dff0ef          	jal	80001bf4 <sched>
  panic("zombie exit");
    80001e7c:	00005517          	auipc	a0,0x5
    80001e80:	45450513          	addi	a0,a0,1108 # 800072d0 <etext+0x2d0>
    80001e84:	911fe0ef          	jal	80000794 <panic>

0000000080001e88 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001e88:	7179                	addi	sp,sp,-48
    80001e8a:	f406                	sd	ra,40(sp)
    80001e8c:	f022                	sd	s0,32(sp)
    80001e8e:	ec26                	sd	s1,24(sp)
    80001e90:	e84a                	sd	s2,16(sp)
    80001e92:	e44e                	sd	s3,8(sp)
    80001e94:	1800                	addi	s0,sp,48
    80001e96:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001e98:	0000e497          	auipc	s1,0xe
    80001e9c:	0d848493          	addi	s1,s1,216 # 8000ff70 <proc>
    80001ea0:	00014997          	auipc	s3,0x14
    80001ea4:	ed098993          	addi	s3,s3,-304 # 80015d70 <tickslock>
    acquire(&p->lock);
    80001ea8:	8526                	mv	a0,s1
    80001eaa:	d4bfe0ef          	jal	80000bf4 <acquire>
    if(p->pid == pid){
    80001eae:	589c                	lw	a5,48(s1)
    80001eb0:	01278b63          	beq	a5,s2,80001ec6 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001eb4:	8526                	mv	a0,s1
    80001eb6:	dd7fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001eba:	17848493          	addi	s1,s1,376
    80001ebe:	ff3495e3          	bne	s1,s3,80001ea8 <kill+0x20>
  }
  return -1;
    80001ec2:	557d                	li	a0,-1
    80001ec4:	a819                	j	80001eda <kill+0x52>
      p->killed = 1;
    80001ec6:	4785                	li	a5,1
    80001ec8:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001eca:	4c98                	lw	a4,24(s1)
    80001ecc:	4789                	li	a5,2
    80001ece:	00f70d63          	beq	a4,a5,80001ee8 <kill+0x60>
      release(&p->lock);
    80001ed2:	8526                	mv	a0,s1
    80001ed4:	db9fe0ef          	jal	80000c8c <release>
      return 0;
    80001ed8:	4501                	li	a0,0
}
    80001eda:	70a2                	ld	ra,40(sp)
    80001edc:	7402                	ld	s0,32(sp)
    80001ede:	64e2                	ld	s1,24(sp)
    80001ee0:	6942                	ld	s2,16(sp)
    80001ee2:	69a2                	ld	s3,8(sp)
    80001ee4:	6145                	addi	sp,sp,48
    80001ee6:	8082                	ret
        p->state = RUNNABLE;
    80001ee8:	478d                	li	a5,3
    80001eea:	cc9c                	sw	a5,24(s1)
    80001eec:	b7dd                	j	80001ed2 <kill+0x4a>

0000000080001eee <setkilled>:

void
setkilled(struct proc *p)
{
    80001eee:	1101                	addi	sp,sp,-32
    80001ef0:	ec06                	sd	ra,24(sp)
    80001ef2:	e822                	sd	s0,16(sp)
    80001ef4:	e426                	sd	s1,8(sp)
    80001ef6:	1000                	addi	s0,sp,32
    80001ef8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001efa:	cfbfe0ef          	jal	80000bf4 <acquire>
  p->killed = 1;
    80001efe:	4785                	li	a5,1
    80001f00:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001f02:	8526                	mv	a0,s1
    80001f04:	d89fe0ef          	jal	80000c8c <release>
}
    80001f08:	60e2                	ld	ra,24(sp)
    80001f0a:	6442                	ld	s0,16(sp)
    80001f0c:	64a2                	ld	s1,8(sp)
    80001f0e:	6105                	addi	sp,sp,32
    80001f10:	8082                	ret

0000000080001f12 <killed>:

int
killed(struct proc *p)
{
    80001f12:	1101                	addi	sp,sp,-32
    80001f14:	ec06                	sd	ra,24(sp)
    80001f16:	e822                	sd	s0,16(sp)
    80001f18:	e426                	sd	s1,8(sp)
    80001f1a:	e04a                	sd	s2,0(sp)
    80001f1c:	1000                	addi	s0,sp,32
    80001f1e:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001f20:	cd5fe0ef          	jal	80000bf4 <acquire>
  k = p->killed;
    80001f24:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001f28:	8526                	mv	a0,s1
    80001f2a:	d63fe0ef          	jal	80000c8c <release>
  return k;
}
    80001f2e:	854a                	mv	a0,s2
    80001f30:	60e2                	ld	ra,24(sp)
    80001f32:	6442                	ld	s0,16(sp)
    80001f34:	64a2                	ld	s1,8(sp)
    80001f36:	6902                	ld	s2,0(sp)
    80001f38:	6105                	addi	sp,sp,32
    80001f3a:	8082                	ret

0000000080001f3c <wait>:
{
    80001f3c:	715d                	addi	sp,sp,-80
    80001f3e:	e486                	sd	ra,72(sp)
    80001f40:	e0a2                	sd	s0,64(sp)
    80001f42:	fc26                	sd	s1,56(sp)
    80001f44:	f84a                	sd	s2,48(sp)
    80001f46:	f44e                	sd	s3,40(sp)
    80001f48:	f052                	sd	s4,32(sp)
    80001f4a:	ec56                	sd	s5,24(sp)
    80001f4c:	e85a                	sd	s6,16(sp)
    80001f4e:	e45e                	sd	s7,8(sp)
    80001f50:	e062                	sd	s8,0(sp)
    80001f52:	0880                	addi	s0,sp,80
    80001f54:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001f56:	99dff0ef          	jal	800018f2 <myproc>
    80001f5a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001f5c:	0000e517          	auipc	a0,0xe
    80001f60:	b6c50513          	addi	a0,a0,-1172 # 8000fac8 <wait_lock>
    80001f64:	c91fe0ef          	jal	80000bf4 <acquire>
    havekids = 0;
    80001f68:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001f6a:	4a15                	li	s4,5
        havekids = 1;
    80001f6c:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f6e:	00014997          	auipc	s3,0x14
    80001f72:	e0298993          	addi	s3,s3,-510 # 80015d70 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001f76:	0000ec17          	auipc	s8,0xe
    80001f7a:	b52c0c13          	addi	s8,s8,-1198 # 8000fac8 <wait_lock>
    80001f7e:	a871                	j	8000201a <wait+0xde>
          pid = pp->pid;
    80001f80:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001f84:	000b0c63          	beqz	s6,80001f9c <wait+0x60>
    80001f88:	4691                	li	a3,4
    80001f8a:	02c48613          	addi	a2,s1,44
    80001f8e:	85da                	mv	a1,s6
    80001f90:	05093503          	ld	a0,80(s2)
    80001f94:	dc2ff0ef          	jal	80001556 <copyout>
    80001f98:	02054b63          	bltz	a0,80001fce <wait+0x92>
          freeproc(pp);
    80001f9c:	8526                	mv	a0,s1
    80001f9e:	ac7ff0ef          	jal	80001a64 <freeproc>
          release(&pp->lock);
    80001fa2:	8526                	mv	a0,s1
    80001fa4:	ce9fe0ef          	jal	80000c8c <release>
          release(&wait_lock);
    80001fa8:	0000e517          	auipc	a0,0xe
    80001fac:	b2050513          	addi	a0,a0,-1248 # 8000fac8 <wait_lock>
    80001fb0:	cddfe0ef          	jal	80000c8c <release>
}
    80001fb4:	854e                	mv	a0,s3
    80001fb6:	60a6                	ld	ra,72(sp)
    80001fb8:	6406                	ld	s0,64(sp)
    80001fba:	74e2                	ld	s1,56(sp)
    80001fbc:	7942                	ld	s2,48(sp)
    80001fbe:	79a2                	ld	s3,40(sp)
    80001fc0:	7a02                	ld	s4,32(sp)
    80001fc2:	6ae2                	ld	s5,24(sp)
    80001fc4:	6b42                	ld	s6,16(sp)
    80001fc6:	6ba2                	ld	s7,8(sp)
    80001fc8:	6c02                	ld	s8,0(sp)
    80001fca:	6161                	addi	sp,sp,80
    80001fcc:	8082                	ret
            release(&pp->lock);
    80001fce:	8526                	mv	a0,s1
    80001fd0:	cbdfe0ef          	jal	80000c8c <release>
            release(&wait_lock);
    80001fd4:	0000e517          	auipc	a0,0xe
    80001fd8:	af450513          	addi	a0,a0,-1292 # 8000fac8 <wait_lock>
    80001fdc:	cb1fe0ef          	jal	80000c8c <release>
            return -1;
    80001fe0:	59fd                	li	s3,-1
    80001fe2:	bfc9                	j	80001fb4 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fe4:	17848493          	addi	s1,s1,376
    80001fe8:	03348063          	beq	s1,s3,80002008 <wait+0xcc>
      if(pp->parent == p){
    80001fec:	7c9c                	ld	a5,56(s1)
    80001fee:	ff279be3          	bne	a5,s2,80001fe4 <wait+0xa8>
        acquire(&pp->lock);
    80001ff2:	8526                	mv	a0,s1
    80001ff4:	c01fe0ef          	jal	80000bf4 <acquire>
        if(pp->state == ZOMBIE){
    80001ff8:	4c9c                	lw	a5,24(s1)
    80001ffa:	f94783e3          	beq	a5,s4,80001f80 <wait+0x44>
        release(&pp->lock);
    80001ffe:	8526                	mv	a0,s1
    80002000:	c8dfe0ef          	jal	80000c8c <release>
        havekids = 1;
    80002004:	8756                	mv	a4,s5
    80002006:	bff9                	j	80001fe4 <wait+0xa8>
    if(!havekids || killed(p)){
    80002008:	cf19                	beqz	a4,80002026 <wait+0xea>
    8000200a:	854a                	mv	a0,s2
    8000200c:	f07ff0ef          	jal	80001f12 <killed>
    80002010:	e919                	bnez	a0,80002026 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002012:	85e2                	mv	a1,s8
    80002014:	854a                	mv	a0,s2
    80002016:	cc5ff0ef          	jal	80001cda <sleep>
    havekids = 0;
    8000201a:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000201c:	0000e497          	auipc	s1,0xe
    80002020:	f5448493          	addi	s1,s1,-172 # 8000ff70 <proc>
    80002024:	b7e1                	j	80001fec <wait+0xb0>
      release(&wait_lock);
    80002026:	0000e517          	auipc	a0,0xe
    8000202a:	aa250513          	addi	a0,a0,-1374 # 8000fac8 <wait_lock>
    8000202e:	c5ffe0ef          	jal	80000c8c <release>
      return -1;
    80002032:	59fd                	li	s3,-1
    80002034:	b741                	j	80001fb4 <wait+0x78>

0000000080002036 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002036:	7179                	addi	sp,sp,-48
    80002038:	f406                	sd	ra,40(sp)
    8000203a:	f022                	sd	s0,32(sp)
    8000203c:	ec26                	sd	s1,24(sp)
    8000203e:	e84a                	sd	s2,16(sp)
    80002040:	e44e                	sd	s3,8(sp)
    80002042:	e052                	sd	s4,0(sp)
    80002044:	1800                	addi	s0,sp,48
    80002046:	84aa                	mv	s1,a0
    80002048:	892e                	mv	s2,a1
    8000204a:	89b2                	mv	s3,a2
    8000204c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000204e:	8a5ff0ef          	jal	800018f2 <myproc>
  if(user_dst){
    80002052:	cc99                	beqz	s1,80002070 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002054:	86d2                	mv	a3,s4
    80002056:	864e                	mv	a2,s3
    80002058:	85ca                	mv	a1,s2
    8000205a:	6928                	ld	a0,80(a0)
    8000205c:	cfaff0ef          	jal	80001556 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002060:	70a2                	ld	ra,40(sp)
    80002062:	7402                	ld	s0,32(sp)
    80002064:	64e2                	ld	s1,24(sp)
    80002066:	6942                	ld	s2,16(sp)
    80002068:	69a2                	ld	s3,8(sp)
    8000206a:	6a02                	ld	s4,0(sp)
    8000206c:	6145                	addi	sp,sp,48
    8000206e:	8082                	ret
    memmove((char *)dst, src, len);
    80002070:	000a061b          	sext.w	a2,s4
    80002074:	85ce                	mv	a1,s3
    80002076:	854a                	mv	a0,s2
    80002078:	cadfe0ef          	jal	80000d24 <memmove>
    return 0;
    8000207c:	8526                	mv	a0,s1
    8000207e:	b7cd                	j	80002060 <either_copyout+0x2a>

0000000080002080 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002080:	7179                	addi	sp,sp,-48
    80002082:	f406                	sd	ra,40(sp)
    80002084:	f022                	sd	s0,32(sp)
    80002086:	ec26                	sd	s1,24(sp)
    80002088:	e84a                	sd	s2,16(sp)
    8000208a:	e44e                	sd	s3,8(sp)
    8000208c:	e052                	sd	s4,0(sp)
    8000208e:	1800                	addi	s0,sp,48
    80002090:	892a                	mv	s2,a0
    80002092:	84ae                	mv	s1,a1
    80002094:	89b2                	mv	s3,a2
    80002096:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002098:	85bff0ef          	jal	800018f2 <myproc>
  if(user_src){
    8000209c:	cc99                	beqz	s1,800020ba <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000209e:	86d2                	mv	a3,s4
    800020a0:	864e                	mv	a2,s3
    800020a2:	85ca                	mv	a1,s2
    800020a4:	6928                	ld	a0,80(a0)
    800020a6:	d86ff0ef          	jal	8000162c <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800020aa:	70a2                	ld	ra,40(sp)
    800020ac:	7402                	ld	s0,32(sp)
    800020ae:	64e2                	ld	s1,24(sp)
    800020b0:	6942                	ld	s2,16(sp)
    800020b2:	69a2                	ld	s3,8(sp)
    800020b4:	6a02                	ld	s4,0(sp)
    800020b6:	6145                	addi	sp,sp,48
    800020b8:	8082                	ret
    memmove(dst, (char*)src, len);
    800020ba:	000a061b          	sext.w	a2,s4
    800020be:	85ce                	mv	a1,s3
    800020c0:	854a                	mv	a0,s2
    800020c2:	c63fe0ef          	jal	80000d24 <memmove>
    return 0;
    800020c6:	8526                	mv	a0,s1
    800020c8:	b7cd                	j	800020aa <either_copyin+0x2a>

00000000800020ca <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800020ca:	715d                	addi	sp,sp,-80
    800020cc:	e486                	sd	ra,72(sp)
    800020ce:	e0a2                	sd	s0,64(sp)
    800020d0:	fc26                	sd	s1,56(sp)
    800020d2:	f84a                	sd	s2,48(sp)
    800020d4:	f44e                	sd	s3,40(sp)
    800020d6:	f052                	sd	s4,32(sp)
    800020d8:	ec56                	sd	s5,24(sp)
    800020da:	e85a                	sd	s6,16(sp)
    800020dc:	e45e                	sd	s7,8(sp)
    800020de:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800020e0:	00005517          	auipc	a0,0x5
    800020e4:	f9850513          	addi	a0,a0,-104 # 80007078 <etext+0x78>
    800020e8:	bdafe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800020ec:	0000e497          	auipc	s1,0xe
    800020f0:	fdc48493          	addi	s1,s1,-36 # 800100c8 <proc+0x158>
    800020f4:	00014917          	auipc	s2,0x14
    800020f8:	dd490913          	addi	s2,s2,-556 # 80015ec8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800020fc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800020fe:	00005997          	auipc	s3,0x5
    80002102:	1e298993          	addi	s3,s3,482 # 800072e0 <etext+0x2e0>
    printf("%d %s %s", p->pid, state, p->name);
    80002106:	00005a97          	auipc	s5,0x5
    8000210a:	1e2a8a93          	addi	s5,s5,482 # 800072e8 <etext+0x2e8>
    printf("\n");
    8000210e:	00005a17          	auipc	s4,0x5
    80002112:	f6aa0a13          	addi	s4,s4,-150 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002116:	00005b97          	auipc	s7,0x5
    8000211a:	6f2b8b93          	addi	s7,s7,1778 # 80007808 <states.0>
    8000211e:	a829                	j	80002138 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002120:	ed86a583          	lw	a1,-296(a3)
    80002124:	8556                	mv	a0,s5
    80002126:	b9cfe0ef          	jal	800004c2 <printf>
    printf("\n");
    8000212a:	8552                	mv	a0,s4
    8000212c:	b96fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002130:	17848493          	addi	s1,s1,376
    80002134:	03248263          	beq	s1,s2,80002158 <procdump+0x8e>
    if(p->state == UNUSED)
    80002138:	86a6                	mv	a3,s1
    8000213a:	ec04a783          	lw	a5,-320(s1)
    8000213e:	dbed                	beqz	a5,80002130 <procdump+0x66>
      state = "???";
    80002140:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002142:	fcfb6fe3          	bltu	s6,a5,80002120 <procdump+0x56>
    80002146:	02079713          	slli	a4,a5,0x20
    8000214a:	01d75793          	srli	a5,a4,0x1d
    8000214e:	97de                	add	a5,a5,s7
    80002150:	6390                	ld	a2,0(a5)
    80002152:	f679                	bnez	a2,80002120 <procdump+0x56>
      state = "???";
    80002154:	864e                	mv	a2,s3
    80002156:	b7e9                	j	80002120 <procdump+0x56>
  }
}
    80002158:	60a6                	ld	ra,72(sp)
    8000215a:	6406                	ld	s0,64(sp)
    8000215c:	74e2                	ld	s1,56(sp)
    8000215e:	7942                	ld	s2,48(sp)
    80002160:	79a2                	ld	s3,40(sp)
    80002162:	7a02                	ld	s4,32(sp)
    80002164:	6ae2                	ld	s5,24(sp)
    80002166:	6b42                	ld	s6,16(sp)
    80002168:	6ba2                	ld	s7,8(sp)
    8000216a:	6161                	addi	sp,sp,80
    8000216c:	8082                	ret

000000008000216e <init_priority_control>:

void init_priority_control(void){
    8000216e:	1141                	addi	sp,sp,-16
    80002170:	e406                	sd	ra,8(sp)
    80002172:	e022                	sd	s0,0(sp)
    80002174:	0800                	addi	s0,sp,16

  initlock(&priority_lock,"priority_lock");
    80002176:	00005597          	auipc	a1,0x5
    8000217a:	18258593          	addi	a1,a1,386 # 800072f8 <etext+0x2f8>
    8000217e:	0000e517          	auipc	a0,0xe
    80002182:	d6250513          	addi	a0,a0,-670 # 8000fee0 <priority_lock>
    80002186:	9effe0ef          	jal	80000b74 <initlock>

  for(int i = 0;i < MAXPRIORITY; i++){
    8000218a:	0000e797          	auipc	a5,0xe
    8000218e:	d9678793          	addi	a5,a5,-618 # 8000ff20 <p_control+0x28>
    80002192:	0000e717          	auipc	a4,0xe
    80002196:	d7a70713          	addi	a4,a4,-646 # 8000ff0c <p_control+0x14>
    8000219a:	0000e697          	auipc	a3,0xe
    8000219e:	dae68693          	addi	a3,a3,-594 # 8000ff48 <p_control+0x50>
    p_control.head_priority[i] = NULL;
    800021a2:	0007b023          	sd	zero,0(a5)
    p_control.present[i] = 0;
    800021a6:	00072023          	sw	zero,0(a4)
    p_control.current_priority[i] = NULL;
    800021aa:	0207b423          	sd	zero,40(a5)
  for(int i = 0;i < MAXPRIORITY; i++){
    800021ae:	07a1                	addi	a5,a5,8
    800021b0:	0711                	addi	a4,a4,4
    800021b2:	fed798e3          	bne	a5,a3,800021a2 <init_priority_control+0x34>
  }
}
    800021b6:	60a2                	ld	ra,8(sp)
    800021b8:	6402                	ld	s0,0(sp)
    800021ba:	0141                	addi	sp,sp,16
    800021bc:	8082                	ret

00000000800021be <set_priority>:

void set_priority(int priority, struct proc *process){
  if((priority > MAXPRIORITY) || (priority < 0) )
    800021be:	4795                	li	a5,5
    800021c0:	00a7e563          	bltu	a5,a0,800021ca <set_priority+0xc>
    panic("Priority nos alowed");

  process->priority = priority;
    800021c4:	16a5a423          	sw	a0,360(a1)
    800021c8:	8082                	ret
void set_priority(int priority, struct proc *process){
    800021ca:	1141                	addi	sp,sp,-16
    800021cc:	e406                	sd	ra,8(sp)
    800021ce:	e022                	sd	s0,0(sp)
    800021d0:	0800                	addi	s0,sp,16
    panic("Priority nos alowed");
    800021d2:	00005517          	auipc	a0,0x5
    800021d6:	13650513          	addi	a0,a0,310 # 80007308 <etext+0x308>
    800021da:	dbafe0ef          	jal	80000794 <panic>

00000000800021de <add_process_priority>:

}

//should be called with the lock 
//iterates through linked list to add an element
void add_process_priority(struct proc *p, int priority){
    800021de:	1141                	addi	sp,sp,-16
    800021e0:	e422                	sd	s0,8(sp)
    800021e2:	0800                	addi	s0,sp,16
  struct proc *aux_p;
  //check if lock held

  if(p_control.head_priority[priority] == NULL){
    800021e4:	00458713          	addi	a4,a1,4
    800021e8:	070e                	slli	a4,a4,0x3
    800021ea:	0000e797          	auipc	a5,0xe
    800021ee:	8c678793          	addi	a5,a5,-1850 # 8000fab0 <pid_lock>
    800021f2:	97ba                	add	a5,a5,a4
    800021f4:	4507b783          	ld	a5,1104(a5)
    800021f8:	cb91                	beqz	a5,8000220c <add_process_priority+0x2e>
    p_control.head_priority[priority] = p;
  }
  else{
    aux_p = p_control.head_priority[priority];
    while(aux_p->next_p_priority != NULL){
    800021fa:	873e                	mv	a4,a5
    800021fc:	1707b783          	ld	a5,368(a5)
    80002200:	ffed                	bnez	a5,800021fa <add_process_priority+0x1c>
      aux_p = aux_p->next_p_priority;
    }
    aux_p->next_p_priority = p;
    80002202:	16a73823          	sd	a0,368(a4)
  }

}
    80002206:	6422                	ld	s0,8(sp)
    80002208:	0141                	addi	sp,sp,16
    8000220a:	8082                	ret
    p_control.head_priority[priority] = p;
    8000220c:	0000e797          	auipc	a5,0xe
    80002210:	8a478793          	addi	a5,a5,-1884 # 8000fab0 <pid_lock>
    80002214:	97ba                	add	a5,a5,a4
    80002216:	44a7b823          	sd	a0,1104(a5)
    8000221a:	b7f5                	j	80002206 <add_process_priority+0x28>

000000008000221c <allocproc>:
{
    8000221c:	7179                	addi	sp,sp,-48
    8000221e:	f406                	sd	ra,40(sp)
    80002220:	f022                	sd	s0,32(sp)
    80002222:	ec26                	sd	s1,24(sp)
    80002224:	e84a                	sd	s2,16(sp)
    80002226:	e44e                	sd	s3,8(sp)
    80002228:	1800                	addi	s0,sp,48
    8000222a:	89aa                	mv	s3,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    8000222c:	0000e497          	auipc	s1,0xe
    80002230:	d4448493          	addi	s1,s1,-700 # 8000ff70 <proc>
    80002234:	00014917          	auipc	s2,0x14
    80002238:	b3c90913          	addi	s2,s2,-1220 # 80015d70 <tickslock>
    acquire(&p->lock);
    8000223c:	8526                	mv	a0,s1
    8000223e:	9b7fe0ef          	jal	80000bf4 <acquire>
    if(p->state == UNUSED) {
    80002242:	4c9c                	lw	a5,24(s1)
    80002244:	cb91                	beqz	a5,80002258 <allocproc+0x3c>
      release(&p->lock);
    80002246:	8526                	mv	a0,s1
    80002248:	a45fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000224c:	17848493          	addi	s1,s1,376
    80002250:	ff2496e3          	bne	s1,s2,8000223c <allocproc+0x20>
  return 0;
    80002254:	4481                	li	s1,0
    80002256:	a8b5                	j	800022d2 <allocproc+0xb6>
    80002258:	e052                	sd	s4,0(sp)
  p->pid = allocpid();
    8000225a:	f02ff0ef          	jal	8000195c <allocpid>
    8000225e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80002260:	4a05                	li	s4,1
    80002262:	0144ac23          	sw	s4,24(s1)
  p->priority = priority;
    80002266:	1734a423          	sw	s3,360(s1)
  acquire(&priority_lock);
    8000226a:	0000e917          	auipc	s2,0xe
    8000226e:	c7690913          	addi	s2,s2,-906 # 8000fee0 <priority_lock>
    80002272:	854a                	mv	a0,s2
    80002274:	981fe0ef          	jal	80000bf4 <acquire>
  p_control.present[priority] = 1;
    80002278:	00498713          	addi	a4,s3,4
    8000227c:	070a                	slli	a4,a4,0x2
    8000227e:	0000e797          	auipc	a5,0xe
    80002282:	83278793          	addi	a5,a5,-1998 # 8000fab0 <pid_lock>
    80002286:	97ba                	add	a5,a5,a4
    80002288:	4547a623          	sw	s4,1100(a5)
  add_process_priority(p,priority);
    8000228c:	85ce                	mv	a1,s3
    8000228e:	8526                	mv	a0,s1
    80002290:	f4fff0ef          	jal	800021de <add_process_priority>
  release(&priority_lock);
    80002294:	854a                	mv	a0,s2
    80002296:	9f7fe0ef          	jal	80000c8c <release>
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000229a:	88bfe0ef          	jal	80000b24 <kalloc>
    8000229e:	892a                	mv	s2,a0
    800022a0:	eca8                	sd	a0,88(s1)
    800022a2:	c121                	beqz	a0,800022e2 <allocproc+0xc6>
  p->pagetable = proc_pagetable(p);
    800022a4:	8526                	mv	a0,s1
    800022a6:	ef4ff0ef          	jal	8000199a <proc_pagetable>
    800022aa:	892a                	mv	s2,a0
    800022ac:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800022ae:	c139                	beqz	a0,800022f4 <allocproc+0xd8>
  memset(&p->context, 0, sizeof(p->context));
    800022b0:	07000613          	li	a2,112
    800022b4:	4581                	li	a1,0
    800022b6:	06048513          	addi	a0,s1,96
    800022ba:	a0ffe0ef          	jal	80000cc8 <memset>
  p->context.ra = (uint64)forkret;
    800022be:	fffff797          	auipc	a5,0xfffff
    800022c2:	66478793          	addi	a5,a5,1636 # 80001922 <forkret>
    800022c6:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800022c8:	60bc                	ld	a5,64(s1)
    800022ca:	6705                	lui	a4,0x1
    800022cc:	97ba                	add	a5,a5,a4
    800022ce:	f4bc                	sd	a5,104(s1)
    800022d0:	6a02                	ld	s4,0(sp)
}
    800022d2:	8526                	mv	a0,s1
    800022d4:	70a2                	ld	ra,40(sp)
    800022d6:	7402                	ld	s0,32(sp)
    800022d8:	64e2                	ld	s1,24(sp)
    800022da:	6942                	ld	s2,16(sp)
    800022dc:	69a2                	ld	s3,8(sp)
    800022de:	6145                	addi	sp,sp,48
    800022e0:	8082                	ret
    freeproc(p);
    800022e2:	8526                	mv	a0,s1
    800022e4:	f80ff0ef          	jal	80001a64 <freeproc>
    release(&p->lock);
    800022e8:	8526                	mv	a0,s1
    800022ea:	9a3fe0ef          	jal	80000c8c <release>
    return 0;
    800022ee:	84ca                	mv	s1,s2
    800022f0:	6a02                	ld	s4,0(sp)
    800022f2:	b7c5                	j	800022d2 <allocproc+0xb6>
    freeproc(p);
    800022f4:	8526                	mv	a0,s1
    800022f6:	f6eff0ef          	jal	80001a64 <freeproc>
    release(&p->lock);
    800022fa:	8526                	mv	a0,s1
    800022fc:	991fe0ef          	jal	80000c8c <release>
    return 0;
    80002300:	84ca                	mv	s1,s2
    80002302:	6a02                	ld	s4,0(sp)
    80002304:	b7f9                	j	800022d2 <allocproc+0xb6>

0000000080002306 <userinit>:
{
    80002306:	1101                	addi	sp,sp,-32
    80002308:	ec06                	sd	ra,24(sp)
    8000230a:	e822                	sd	s0,16(sp)
    8000230c:	e426                	sd	s1,8(sp)
    8000230e:	1000                	addi	s0,sp,32
  p = allocproc(2);
    80002310:	4509                	li	a0,2
    80002312:	f0bff0ef          	jal	8000221c <allocproc>
    80002316:	84aa                	mv	s1,a0
  initproc = p;
    80002318:	00005797          	auipc	a5,0x5
    8000231c:	66a7b023          	sd	a0,1632(a5) # 80007978 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002320:	03400613          	li	a2,52
    80002324:	00005597          	auipc	a1,0x5
    80002328:	5ec58593          	addi	a1,a1,1516 # 80007910 <initcode>
    8000232c:	6928                	ld	a0,80(a0)
    8000232e:	f73fe0ef          	jal	800012a0 <uvmfirst>
  p->sz = PGSIZE;
    80002332:	6785                	lui	a5,0x1
    80002334:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80002336:	6cb8                	ld	a4,88(s1)
    80002338:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000233c:	6cb8                	ld	a4,88(s1)
    8000233e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002340:	4641                	li	a2,16
    80002342:	00005597          	auipc	a1,0x5
    80002346:	fde58593          	addi	a1,a1,-34 # 80007320 <etext+0x320>
    8000234a:	15848513          	addi	a0,s1,344
    8000234e:	ab9fe0ef          	jal	80000e06 <safestrcpy>
  p->cwd = namei("/");
    80002352:	00005517          	auipc	a0,0x5
    80002356:	fde50513          	addi	a0,a0,-34 # 80007330 <etext+0x330>
    8000235a:	686010ef          	jal	800039e0 <namei>
    8000235e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80002362:	478d                	li	a5,3
    80002364:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80002366:	8526                	mv	a0,s1
    80002368:	925fe0ef          	jal	80000c8c <release>
}
    8000236c:	60e2                	ld	ra,24(sp)
    8000236e:	6442                	ld	s0,16(sp)
    80002370:	64a2                	ld	s1,8(sp)
    80002372:	6105                	addi	sp,sp,32
    80002374:	8082                	ret

0000000080002376 <fork>:
{
    80002376:	7139                	addi	sp,sp,-64
    80002378:	fc06                	sd	ra,56(sp)
    8000237a:	f822                	sd	s0,48(sp)
    8000237c:	f04a                	sd	s2,32(sp)
    8000237e:	e456                	sd	s5,8(sp)
    80002380:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002382:	d70ff0ef          	jal	800018f2 <myproc>
    80002386:	8aaa                	mv	s5,a0
  if((np = allocproc(p->priority)) == 0){
    80002388:	16852503          	lw	a0,360(a0)
    8000238c:	e91ff0ef          	jal	8000221c <allocproc>
    80002390:	0e050a63          	beqz	a0,80002484 <fork+0x10e>
    80002394:	e852                	sd	s4,16(sp)
    80002396:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80002398:	048ab603          	ld	a2,72(s5)
    8000239c:	692c                	ld	a1,80(a0)
    8000239e:	050ab503          	ld	a0,80(s5)
    800023a2:	8d8ff0ef          	jal	8000147a <uvmcopy>
    800023a6:	04054a63          	bltz	a0,800023fa <fork+0x84>
    800023aa:	f426                	sd	s1,40(sp)
    800023ac:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800023ae:	048ab783          	ld	a5,72(s5)
    800023b2:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800023b6:	058ab683          	ld	a3,88(s5)
    800023ba:	87b6                	mv	a5,a3
    800023bc:	058a3703          	ld	a4,88(s4)
    800023c0:	12068693          	addi	a3,a3,288
    800023c4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800023c8:	6788                	ld	a0,8(a5)
    800023ca:	6b8c                	ld	a1,16(a5)
    800023cc:	6f90                	ld	a2,24(a5)
    800023ce:	01073023          	sd	a6,0(a4)
    800023d2:	e708                	sd	a0,8(a4)
    800023d4:	eb0c                	sd	a1,16(a4)
    800023d6:	ef10                	sd	a2,24(a4)
    800023d8:	02078793          	addi	a5,a5,32
    800023dc:	02070713          	addi	a4,a4,32
    800023e0:	fed792e3          	bne	a5,a3,800023c4 <fork+0x4e>
  np->trapframe->a0 = 0;
    800023e4:	058a3783          	ld	a5,88(s4)
    800023e8:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800023ec:	0d0a8493          	addi	s1,s5,208
    800023f0:	0d0a0913          	addi	s2,s4,208
    800023f4:	150a8993          	addi	s3,s5,336
    800023f8:	a831                	j	80002414 <fork+0x9e>
    freeproc(np);
    800023fa:	8552                	mv	a0,s4
    800023fc:	e68ff0ef          	jal	80001a64 <freeproc>
    release(&np->lock);
    80002400:	8552                	mv	a0,s4
    80002402:	88bfe0ef          	jal	80000c8c <release>
    return -1;
    80002406:	597d                	li	s2,-1
    80002408:	6a42                	ld	s4,16(sp)
    8000240a:	a0b5                	j	80002476 <fork+0x100>
  for(i = 0; i < NOFILE; i++)
    8000240c:	04a1                	addi	s1,s1,8
    8000240e:	0921                	addi	s2,s2,8
    80002410:	01348963          	beq	s1,s3,80002422 <fork+0xac>
    if(p->ofile[i])
    80002414:	6088                	ld	a0,0(s1)
    80002416:	d97d                	beqz	a0,8000240c <fork+0x96>
      np->ofile[i] = filedup(p->ofile[i]);
    80002418:	359010ef          	jal	80003f70 <filedup>
    8000241c:	00a93023          	sd	a0,0(s2)
    80002420:	b7f5                	j	8000240c <fork+0x96>
  np->cwd = idup(p->cwd);
    80002422:	150ab503          	ld	a0,336(s5)
    80002426:	6ab000ef          	jal	800032d0 <idup>
    8000242a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000242e:	4641                	li	a2,16
    80002430:	158a8593          	addi	a1,s5,344
    80002434:	158a0513          	addi	a0,s4,344
    80002438:	9cffe0ef          	jal	80000e06 <safestrcpy>
  pid = np->pid;
    8000243c:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80002440:	8552                	mv	a0,s4
    80002442:	84bfe0ef          	jal	80000c8c <release>
  acquire(&wait_lock);
    80002446:	0000d497          	auipc	s1,0xd
    8000244a:	68248493          	addi	s1,s1,1666 # 8000fac8 <wait_lock>
    8000244e:	8526                	mv	a0,s1
    80002450:	fa4fe0ef          	jal	80000bf4 <acquire>
  np->parent = p;
    80002454:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80002458:	8526                	mv	a0,s1
    8000245a:	833fe0ef          	jal	80000c8c <release>
  acquire(&np->lock);
    8000245e:	8552                	mv	a0,s4
    80002460:	f94fe0ef          	jal	80000bf4 <acquire>
  np->state = RUNNABLE;
    80002464:	478d                	li	a5,3
    80002466:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000246a:	8552                	mv	a0,s4
    8000246c:	821fe0ef          	jal	80000c8c <release>
  return pid;
    80002470:	74a2                	ld	s1,40(sp)
    80002472:	69e2                	ld	s3,24(sp)
    80002474:	6a42                	ld	s4,16(sp)
}
    80002476:	854a                	mv	a0,s2
    80002478:	70e2                	ld	ra,56(sp)
    8000247a:	7442                	ld	s0,48(sp)
    8000247c:	7902                	ld	s2,32(sp)
    8000247e:	6aa2                	ld	s5,8(sp)
    80002480:	6121                	addi	sp,sp,64
    80002482:	8082                	ret
    return -1;
    80002484:	597d                	li	s2,-1
    80002486:	bfc5                	j	80002476 <fork+0x100>

0000000080002488 <swtch>:
    80002488:	00153023          	sd	ra,0(a0)
    8000248c:	00253423          	sd	sp,8(a0)
    80002490:	e900                	sd	s0,16(a0)
    80002492:	ed04                	sd	s1,24(a0)
    80002494:	03253023          	sd	s2,32(a0)
    80002498:	03353423          	sd	s3,40(a0)
    8000249c:	03453823          	sd	s4,48(a0)
    800024a0:	03553c23          	sd	s5,56(a0)
    800024a4:	05653023          	sd	s6,64(a0)
    800024a8:	05753423          	sd	s7,72(a0)
    800024ac:	05853823          	sd	s8,80(a0)
    800024b0:	05953c23          	sd	s9,88(a0)
    800024b4:	07a53023          	sd	s10,96(a0)
    800024b8:	07b53423          	sd	s11,104(a0)
    800024bc:	0005b083          	ld	ra,0(a1)
    800024c0:	0085b103          	ld	sp,8(a1)
    800024c4:	6980                	ld	s0,16(a1)
    800024c6:	6d84                	ld	s1,24(a1)
    800024c8:	0205b903          	ld	s2,32(a1)
    800024cc:	0285b983          	ld	s3,40(a1)
    800024d0:	0305ba03          	ld	s4,48(a1)
    800024d4:	0385ba83          	ld	s5,56(a1)
    800024d8:	0405bb03          	ld	s6,64(a1)
    800024dc:	0485bb83          	ld	s7,72(a1)
    800024e0:	0505bc03          	ld	s8,80(a1)
    800024e4:	0585bc83          	ld	s9,88(a1)
    800024e8:	0605bd03          	ld	s10,96(a1)
    800024ec:	0685bd83          	ld	s11,104(a1)
    800024f0:	8082                	ret

00000000800024f2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800024f2:	1141                	addi	sp,sp,-16
    800024f4:	e406                	sd	ra,8(sp)
    800024f6:	e022                	sd	s0,0(sp)
    800024f8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800024fa:	00005597          	auipc	a1,0x5
    800024fe:	e6e58593          	addi	a1,a1,-402 # 80007368 <etext+0x368>
    80002502:	00014517          	auipc	a0,0x14
    80002506:	86e50513          	addi	a0,a0,-1938 # 80015d70 <tickslock>
    8000250a:	e6afe0ef          	jal	80000b74 <initlock>
}
    8000250e:	60a2                	ld	ra,8(sp)
    80002510:	6402                	ld	s0,0(sp)
    80002512:	0141                	addi	sp,sp,16
    80002514:	8082                	ret

0000000080002516 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002516:	1141                	addi	sp,sp,-16
    80002518:	e422                	sd	s0,8(sp)
    8000251a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000251c:	00003797          	auipc	a5,0x3
    80002520:	e0478793          	addi	a5,a5,-508 # 80005320 <kernelvec>
    80002524:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002528:	6422                	ld	s0,8(sp)
    8000252a:	0141                	addi	sp,sp,16
    8000252c:	8082                	ret

000000008000252e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000252e:	1141                	addi	sp,sp,-16
    80002530:	e406                	sd	ra,8(sp)
    80002532:	e022                	sd	s0,0(sp)
    80002534:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002536:	bbcff0ef          	jal	800018f2 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000253a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000253e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002540:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002544:	00004697          	auipc	a3,0x4
    80002548:	abc68693          	addi	a3,a3,-1348 # 80006000 <_trampoline>
    8000254c:	00004717          	auipc	a4,0x4
    80002550:	ab470713          	addi	a4,a4,-1356 # 80006000 <_trampoline>
    80002554:	8f15                	sub	a4,a4,a3
    80002556:	040007b7          	lui	a5,0x4000
    8000255a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000255c:	07b2                	slli	a5,a5,0xc
    8000255e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002560:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002564:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002566:	18002673          	csrr	a2,satp
    8000256a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000256c:	6d30                	ld	a2,88(a0)
    8000256e:	6138                	ld	a4,64(a0)
    80002570:	6585                	lui	a1,0x1
    80002572:	972e                	add	a4,a4,a1
    80002574:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002576:	6d38                	ld	a4,88(a0)
    80002578:	00000617          	auipc	a2,0x0
    8000257c:	11060613          	addi	a2,a2,272 # 80002688 <usertrap>
    80002580:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002582:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002584:	8612                	mv	a2,tp
    80002586:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002588:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000258c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002590:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002594:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002598:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000259a:	6f18                	ld	a4,24(a4)
    8000259c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800025a0:	6928                	ld	a0,80(a0)
    800025a2:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800025a4:	00004717          	auipc	a4,0x4
    800025a8:	af870713          	addi	a4,a4,-1288 # 8000609c <userret>
    800025ac:	8f15                	sub	a4,a4,a3
    800025ae:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800025b0:	577d                	li	a4,-1
    800025b2:	177e                	slli	a4,a4,0x3f
    800025b4:	8d59                	or	a0,a0,a4
    800025b6:	9782                	jalr	a5
}
    800025b8:	60a2                	ld	ra,8(sp)
    800025ba:	6402                	ld	s0,0(sp)
    800025bc:	0141                	addi	sp,sp,16
    800025be:	8082                	ret

00000000800025c0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800025c0:	1101                	addi	sp,sp,-32
    800025c2:	ec06                	sd	ra,24(sp)
    800025c4:	e822                	sd	s0,16(sp)
    800025c6:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800025c8:	afeff0ef          	jal	800018c6 <cpuid>
    800025cc:	cd11                	beqz	a0,800025e8 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800025ce:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800025d2:	000f4737          	lui	a4,0xf4
    800025d6:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800025da:	97ba                	add	a5,a5,a4
  asm volatile("csrw stimecmp, %0" : : "r" (x));
    800025dc:	14d79073          	csrw	stimecmp,a5
}
    800025e0:	60e2                	ld	ra,24(sp)
    800025e2:	6442                	ld	s0,16(sp)
    800025e4:	6105                	addi	sp,sp,32
    800025e6:	8082                	ret
    800025e8:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800025ea:	00013497          	auipc	s1,0x13
    800025ee:	78648493          	addi	s1,s1,1926 # 80015d70 <tickslock>
    800025f2:	8526                	mv	a0,s1
    800025f4:	e00fe0ef          	jal	80000bf4 <acquire>
    ticks++;
    800025f8:	00005517          	auipc	a0,0x5
    800025fc:	38850513          	addi	a0,a0,904 # 80007980 <ticks>
    80002600:	411c                	lw	a5,0(a0)
    80002602:	2785                	addiw	a5,a5,1
    80002604:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002606:	f20ff0ef          	jal	80001d26 <wakeup>
    release(&tickslock);
    8000260a:	8526                	mv	a0,s1
    8000260c:	e80fe0ef          	jal	80000c8c <release>
    80002610:	64a2                	ld	s1,8(sp)
    80002612:	bf75                	j	800025ce <clockintr+0xe>

0000000080002614 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002614:	1101                	addi	sp,sp,-32
    80002616:	ec06                	sd	ra,24(sp)
    80002618:	e822                	sd	s0,16(sp)
    8000261a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000261c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002620:	57fd                	li	a5,-1
    80002622:	17fe                	slli	a5,a5,0x3f
    80002624:	07a5                	addi	a5,a5,9
    80002626:	00f70c63          	beq	a4,a5,8000263e <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000262a:	57fd                	li	a5,-1
    8000262c:	17fe                	slli	a5,a5,0x3f
    8000262e:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002630:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002632:	04f70763          	beq	a4,a5,80002680 <devintr+0x6c>
  }
}
    80002636:	60e2                	ld	ra,24(sp)
    80002638:	6442                	ld	s0,16(sp)
    8000263a:	6105                	addi	sp,sp,32
    8000263c:	8082                	ret
    8000263e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002640:	58d020ef          	jal	800053cc <plic_claim>
    80002644:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002646:	47a9                	li	a5,10
    80002648:	00f50963          	beq	a0,a5,8000265a <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    8000264c:	4785                	li	a5,1
    8000264e:	00f50963          	beq	a0,a5,80002660 <devintr+0x4c>
    return 1;
    80002652:	4505                	li	a0,1
    } else if(irq){
    80002654:	e889                	bnez	s1,80002666 <devintr+0x52>
    80002656:	64a2                	ld	s1,8(sp)
    80002658:	bff9                	j	80002636 <devintr+0x22>
      uartintr();
    8000265a:	bacfe0ef          	jal	80000a06 <uartintr>
    if(irq)
    8000265e:	a819                	j	80002674 <devintr+0x60>
      virtio_disk_intr();
    80002660:	232030ef          	jal	80005892 <virtio_disk_intr>
    if(irq)
    80002664:	a801                	j	80002674 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002666:	85a6                	mv	a1,s1
    80002668:	00005517          	auipc	a0,0x5
    8000266c:	d0850513          	addi	a0,a0,-760 # 80007370 <etext+0x370>
    80002670:	e53fd0ef          	jal	800004c2 <printf>
      plic_complete(irq);
    80002674:	8526                	mv	a0,s1
    80002676:	577020ef          	jal	800053ec <plic_complete>
    return 1;
    8000267a:	4505                	li	a0,1
    8000267c:	64a2                	ld	s1,8(sp)
    8000267e:	bf65                	j	80002636 <devintr+0x22>
    clockintr();
    80002680:	f41ff0ef          	jal	800025c0 <clockintr>
    return 2;
    80002684:	4509                	li	a0,2
    80002686:	bf45                	j	80002636 <devintr+0x22>

0000000080002688 <usertrap>:
{
    80002688:	1101                	addi	sp,sp,-32
    8000268a:	ec06                	sd	ra,24(sp)
    8000268c:	e822                	sd	s0,16(sp)
    8000268e:	e426                	sd	s1,8(sp)
    80002690:	e04a                	sd	s2,0(sp)
    80002692:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002694:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002698:	1007f793          	andi	a5,a5,256
    8000269c:	ef85                	bnez	a5,800026d4 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000269e:	00003797          	auipc	a5,0x3
    800026a2:	c8278793          	addi	a5,a5,-894 # 80005320 <kernelvec>
    800026a6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800026aa:	a48ff0ef          	jal	800018f2 <myproc>
    800026ae:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800026b0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026b2:	14102773          	csrr	a4,sepc
    800026b6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026b8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800026bc:	47a1                	li	a5,8
    800026be:	02f70163          	beq	a4,a5,800026e0 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800026c2:	f53ff0ef          	jal	80002614 <devintr>
    800026c6:	892a                	mv	s2,a0
    800026c8:	c135                	beqz	a0,8000272c <usertrap+0xa4>
  if(killed(p))
    800026ca:	8526                	mv	a0,s1
    800026cc:	847ff0ef          	jal	80001f12 <killed>
    800026d0:	cd1d                	beqz	a0,8000270e <usertrap+0x86>
    800026d2:	a81d                	j	80002708 <usertrap+0x80>
    panic("usertrap: not from user mode");
    800026d4:	00005517          	auipc	a0,0x5
    800026d8:	cbc50513          	addi	a0,a0,-836 # 80007390 <etext+0x390>
    800026dc:	8b8fe0ef          	jal	80000794 <panic>
    if(killed(p))
    800026e0:	833ff0ef          	jal	80001f12 <killed>
    800026e4:	e121                	bnez	a0,80002724 <usertrap+0x9c>
    p->trapframe->epc += 4;
    800026e6:	6cb8                	ld	a4,88(s1)
    800026e8:	6f1c                	ld	a5,24(a4)
    800026ea:	0791                	addi	a5,a5,4
    800026ec:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800026f2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026f6:	10079073          	csrw	sstatus,a5
    syscall();
    800026fa:	248000ef          	jal	80002942 <syscall>
  if(killed(p))
    800026fe:	8526                	mv	a0,s1
    80002700:	813ff0ef          	jal	80001f12 <killed>
    80002704:	c901                	beqz	a0,80002714 <usertrap+0x8c>
    80002706:	4901                	li	s2,0
    exit(-1);
    80002708:	557d                	li	a0,-1
    8000270a:	edcff0ef          	jal	80001de6 <exit>
  if(which_dev == 2)
    8000270e:	4789                	li	a5,2
    80002710:	04f90563          	beq	s2,a5,8000275a <usertrap+0xd2>
  usertrapret();
    80002714:	e1bff0ef          	jal	8000252e <usertrapret>
}
    80002718:	60e2                	ld	ra,24(sp)
    8000271a:	6442                	ld	s0,16(sp)
    8000271c:	64a2                	ld	s1,8(sp)
    8000271e:	6902                	ld	s2,0(sp)
    80002720:	6105                	addi	sp,sp,32
    80002722:	8082                	ret
      exit(-1);
    80002724:	557d                	li	a0,-1
    80002726:	ec0ff0ef          	jal	80001de6 <exit>
    8000272a:	bf75                	j	800026e6 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000272c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002730:	5890                	lw	a2,48(s1)
    80002732:	00005517          	auipc	a0,0x5
    80002736:	c7e50513          	addi	a0,a0,-898 # 800073b0 <etext+0x3b0>
    8000273a:	d89fd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000273e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002742:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002746:	00005517          	auipc	a0,0x5
    8000274a:	c9a50513          	addi	a0,a0,-870 # 800073e0 <etext+0x3e0>
    8000274e:	d75fd0ef          	jal	800004c2 <printf>
    setkilled(p);
    80002752:	8526                	mv	a0,s1
    80002754:	f9aff0ef          	jal	80001eee <setkilled>
    80002758:	b75d                	j	800026fe <usertrap+0x76>
    yield();
    8000275a:	d54ff0ef          	jal	80001cae <yield>
    8000275e:	bf5d                	j	80002714 <usertrap+0x8c>

0000000080002760 <kerneltrap>:
{
    80002760:	7179                	addi	sp,sp,-48
    80002762:	f406                	sd	ra,40(sp)
    80002764:	f022                	sd	s0,32(sp)
    80002766:	ec26                	sd	s1,24(sp)
    80002768:	e84a                	sd	s2,16(sp)
    8000276a:	e44e                	sd	s3,8(sp)
    8000276c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000276e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002772:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002776:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000277a:	1004f793          	andi	a5,s1,256
    8000277e:	c795                	beqz	a5,800027aa <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002780:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002784:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002786:	eb85                	bnez	a5,800027b6 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002788:	e8dff0ef          	jal	80002614 <devintr>
    8000278c:	c91d                	beqz	a0,800027c2 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    8000278e:	4789                	li	a5,2
    80002790:	04f50a63          	beq	a0,a5,800027e4 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002794:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002798:	10049073          	csrw	sstatus,s1
}
    8000279c:	70a2                	ld	ra,40(sp)
    8000279e:	7402                	ld	s0,32(sp)
    800027a0:	64e2                	ld	s1,24(sp)
    800027a2:	6942                	ld	s2,16(sp)
    800027a4:	69a2                	ld	s3,8(sp)
    800027a6:	6145                	addi	sp,sp,48
    800027a8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800027aa:	00005517          	auipc	a0,0x5
    800027ae:	c5e50513          	addi	a0,a0,-930 # 80007408 <etext+0x408>
    800027b2:	fe3fd0ef          	jal	80000794 <panic>
    panic("kerneltrap: interrupts enabled");
    800027b6:	00005517          	auipc	a0,0x5
    800027ba:	c7a50513          	addi	a0,a0,-902 # 80007430 <etext+0x430>
    800027be:	fd7fd0ef          	jal	80000794 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027c2:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800027c6:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800027ca:	85ce                	mv	a1,s3
    800027cc:	00005517          	auipc	a0,0x5
    800027d0:	c8450513          	addi	a0,a0,-892 # 80007450 <etext+0x450>
    800027d4:	ceffd0ef          	jal	800004c2 <printf>
    panic("kerneltrap");
    800027d8:	00005517          	auipc	a0,0x5
    800027dc:	ca050513          	addi	a0,a0,-864 # 80007478 <etext+0x478>
    800027e0:	fb5fd0ef          	jal	80000794 <panic>
  if(which_dev == 2 && myproc() != 0)
    800027e4:	90eff0ef          	jal	800018f2 <myproc>
    800027e8:	d555                	beqz	a0,80002794 <kerneltrap+0x34>
    yield();
    800027ea:	cc4ff0ef          	jal	80001cae <yield>
    800027ee:	b75d                	j	80002794 <kerneltrap+0x34>

00000000800027f0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800027f0:	1101                	addi	sp,sp,-32
    800027f2:	ec06                	sd	ra,24(sp)
    800027f4:	e822                	sd	s0,16(sp)
    800027f6:	e426                	sd	s1,8(sp)
    800027f8:	1000                	addi	s0,sp,32
    800027fa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800027fc:	8f6ff0ef          	jal	800018f2 <myproc>
  switch (n) {
    80002800:	4795                	li	a5,5
    80002802:	0497e163          	bltu	a5,s1,80002844 <argraw+0x54>
    80002806:	048a                	slli	s1,s1,0x2
    80002808:	00005717          	auipc	a4,0x5
    8000280c:	03070713          	addi	a4,a4,48 # 80007838 <states.0+0x30>
    80002810:	94ba                	add	s1,s1,a4
    80002812:	409c                	lw	a5,0(s1)
    80002814:	97ba                	add	a5,a5,a4
    80002816:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002818:	6d3c                	ld	a5,88(a0)
    8000281a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000281c:	60e2                	ld	ra,24(sp)
    8000281e:	6442                	ld	s0,16(sp)
    80002820:	64a2                	ld	s1,8(sp)
    80002822:	6105                	addi	sp,sp,32
    80002824:	8082                	ret
    return p->trapframe->a1;
    80002826:	6d3c                	ld	a5,88(a0)
    80002828:	7fa8                	ld	a0,120(a5)
    8000282a:	bfcd                	j	8000281c <argraw+0x2c>
    return p->trapframe->a2;
    8000282c:	6d3c                	ld	a5,88(a0)
    8000282e:	63c8                	ld	a0,128(a5)
    80002830:	b7f5                	j	8000281c <argraw+0x2c>
    return p->trapframe->a3;
    80002832:	6d3c                	ld	a5,88(a0)
    80002834:	67c8                	ld	a0,136(a5)
    80002836:	b7dd                	j	8000281c <argraw+0x2c>
    return p->trapframe->a4;
    80002838:	6d3c                	ld	a5,88(a0)
    8000283a:	6bc8                	ld	a0,144(a5)
    8000283c:	b7c5                	j	8000281c <argraw+0x2c>
    return p->trapframe->a5;
    8000283e:	6d3c                	ld	a5,88(a0)
    80002840:	6fc8                	ld	a0,152(a5)
    80002842:	bfe9                	j	8000281c <argraw+0x2c>
  panic("argraw");
    80002844:	00005517          	auipc	a0,0x5
    80002848:	c4450513          	addi	a0,a0,-956 # 80007488 <etext+0x488>
    8000284c:	f49fd0ef          	jal	80000794 <panic>

0000000080002850 <fetchaddr>:
{
    80002850:	1101                	addi	sp,sp,-32
    80002852:	ec06                	sd	ra,24(sp)
    80002854:	e822                	sd	s0,16(sp)
    80002856:	e426                	sd	s1,8(sp)
    80002858:	e04a                	sd	s2,0(sp)
    8000285a:	1000                	addi	s0,sp,32
    8000285c:	84aa                	mv	s1,a0
    8000285e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002860:	892ff0ef          	jal	800018f2 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002864:	653c                	ld	a5,72(a0)
    80002866:	02f4f663          	bgeu	s1,a5,80002892 <fetchaddr+0x42>
    8000286a:	00848713          	addi	a4,s1,8
    8000286e:	02e7e463          	bltu	a5,a4,80002896 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002872:	46a1                	li	a3,8
    80002874:	8626                	mv	a2,s1
    80002876:	85ca                	mv	a1,s2
    80002878:	6928                	ld	a0,80(a0)
    8000287a:	db3fe0ef          	jal	8000162c <copyin>
    8000287e:	00a03533          	snez	a0,a0
    80002882:	40a00533          	neg	a0,a0
}
    80002886:	60e2                	ld	ra,24(sp)
    80002888:	6442                	ld	s0,16(sp)
    8000288a:	64a2                	ld	s1,8(sp)
    8000288c:	6902                	ld	s2,0(sp)
    8000288e:	6105                	addi	sp,sp,32
    80002890:	8082                	ret
    return -1;
    80002892:	557d                	li	a0,-1
    80002894:	bfcd                	j	80002886 <fetchaddr+0x36>
    80002896:	557d                	li	a0,-1
    80002898:	b7fd                	j	80002886 <fetchaddr+0x36>

000000008000289a <fetchstr>:
{
    8000289a:	7179                	addi	sp,sp,-48
    8000289c:	f406                	sd	ra,40(sp)
    8000289e:	f022                	sd	s0,32(sp)
    800028a0:	ec26                	sd	s1,24(sp)
    800028a2:	e84a                	sd	s2,16(sp)
    800028a4:	e44e                	sd	s3,8(sp)
    800028a6:	1800                	addi	s0,sp,48
    800028a8:	892a                	mv	s2,a0
    800028aa:	84ae                	mv	s1,a1
    800028ac:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800028ae:	844ff0ef          	jal	800018f2 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800028b2:	86ce                	mv	a3,s3
    800028b4:	864a                	mv	a2,s2
    800028b6:	85a6                	mv	a1,s1
    800028b8:	6928                	ld	a0,80(a0)
    800028ba:	df9fe0ef          	jal	800016b2 <copyinstr>
    800028be:	00054c63          	bltz	a0,800028d6 <fetchstr+0x3c>
  return strlen(buf);
    800028c2:	8526                	mv	a0,s1
    800028c4:	d74fe0ef          	jal	80000e38 <strlen>
}
    800028c8:	70a2                	ld	ra,40(sp)
    800028ca:	7402                	ld	s0,32(sp)
    800028cc:	64e2                	ld	s1,24(sp)
    800028ce:	6942                	ld	s2,16(sp)
    800028d0:	69a2                	ld	s3,8(sp)
    800028d2:	6145                	addi	sp,sp,48
    800028d4:	8082                	ret
    return -1;
    800028d6:	557d                	li	a0,-1
    800028d8:	bfc5                	j	800028c8 <fetchstr+0x2e>

00000000800028da <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800028da:	1101                	addi	sp,sp,-32
    800028dc:	ec06                	sd	ra,24(sp)
    800028de:	e822                	sd	s0,16(sp)
    800028e0:	e426                	sd	s1,8(sp)
    800028e2:	1000                	addi	s0,sp,32
    800028e4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800028e6:	f0bff0ef          	jal	800027f0 <argraw>
    800028ea:	c088                	sw	a0,0(s1)
}
    800028ec:	60e2                	ld	ra,24(sp)
    800028ee:	6442                	ld	s0,16(sp)
    800028f0:	64a2                	ld	s1,8(sp)
    800028f2:	6105                	addi	sp,sp,32
    800028f4:	8082                	ret

00000000800028f6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800028f6:	1101                	addi	sp,sp,-32
    800028f8:	ec06                	sd	ra,24(sp)
    800028fa:	e822                	sd	s0,16(sp)
    800028fc:	e426                	sd	s1,8(sp)
    800028fe:	1000                	addi	s0,sp,32
    80002900:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002902:	eefff0ef          	jal	800027f0 <argraw>
    80002906:	e088                	sd	a0,0(s1)
}
    80002908:	60e2                	ld	ra,24(sp)
    8000290a:	6442                	ld	s0,16(sp)
    8000290c:	64a2                	ld	s1,8(sp)
    8000290e:	6105                	addi	sp,sp,32
    80002910:	8082                	ret

0000000080002912 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002912:	7179                	addi	sp,sp,-48
    80002914:	f406                	sd	ra,40(sp)
    80002916:	f022                	sd	s0,32(sp)
    80002918:	ec26                	sd	s1,24(sp)
    8000291a:	e84a                	sd	s2,16(sp)
    8000291c:	1800                	addi	s0,sp,48
    8000291e:	84ae                	mv	s1,a1
    80002920:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002922:	fd840593          	addi	a1,s0,-40
    80002926:	fd1ff0ef          	jal	800028f6 <argaddr>
  return fetchstr(addr, buf, max);
    8000292a:	864a                	mv	a2,s2
    8000292c:	85a6                	mv	a1,s1
    8000292e:	fd843503          	ld	a0,-40(s0)
    80002932:	f69ff0ef          	jal	8000289a <fetchstr>
}
    80002936:	70a2                	ld	ra,40(sp)
    80002938:	7402                	ld	s0,32(sp)
    8000293a:	64e2                	ld	s1,24(sp)
    8000293c:	6942                	ld	s2,16(sp)
    8000293e:	6145                	addi	sp,sp,48
    80002940:	8082                	ret

0000000080002942 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002942:	1101                	addi	sp,sp,-32
    80002944:	ec06                	sd	ra,24(sp)
    80002946:	e822                	sd	s0,16(sp)
    80002948:	e426                	sd	s1,8(sp)
    8000294a:	e04a                	sd	s2,0(sp)
    8000294c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000294e:	fa5fe0ef          	jal	800018f2 <myproc>
    80002952:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002954:	05853903          	ld	s2,88(a0)
    80002958:	0a893783          	ld	a5,168(s2)
    8000295c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002960:	37fd                	addiw	a5,a5,-1
    80002962:	4751                	li	a4,20
    80002964:	00f76f63          	bltu	a4,a5,80002982 <syscall+0x40>
    80002968:	00369713          	slli	a4,a3,0x3
    8000296c:	00005797          	auipc	a5,0x5
    80002970:	ee478793          	addi	a5,a5,-284 # 80007850 <syscalls>
    80002974:	97ba                	add	a5,a5,a4
    80002976:	639c                	ld	a5,0(a5)
    80002978:	c789                	beqz	a5,80002982 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000297a:	9782                	jalr	a5
    8000297c:	06a93823          	sd	a0,112(s2)
    80002980:	a829                	j	8000299a <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002982:	15848613          	addi	a2,s1,344
    80002986:	588c                	lw	a1,48(s1)
    80002988:	00005517          	auipc	a0,0x5
    8000298c:	b0850513          	addi	a0,a0,-1272 # 80007490 <etext+0x490>
    80002990:	b33fd0ef          	jal	800004c2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002994:	6cbc                	ld	a5,88(s1)
    80002996:	577d                	li	a4,-1
    80002998:	fbb8                	sd	a4,112(a5)
  }
}
    8000299a:	60e2                	ld	ra,24(sp)
    8000299c:	6442                	ld	s0,16(sp)
    8000299e:	64a2                	ld	s1,8(sp)
    800029a0:	6902                	ld	s2,0(sp)
    800029a2:	6105                	addi	sp,sp,32
    800029a4:	8082                	ret

00000000800029a6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800029a6:	1101                	addi	sp,sp,-32
    800029a8:	ec06                	sd	ra,24(sp)
    800029aa:	e822                	sd	s0,16(sp)
    800029ac:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800029ae:	fec40593          	addi	a1,s0,-20
    800029b2:	4501                	li	a0,0
    800029b4:	f27ff0ef          	jal	800028da <argint>
  exit(n);
    800029b8:	fec42503          	lw	a0,-20(s0)
    800029bc:	c2aff0ef          	jal	80001de6 <exit>
  return 0;  // not reached
}
    800029c0:	4501                	li	a0,0
    800029c2:	60e2                	ld	ra,24(sp)
    800029c4:	6442                	ld	s0,16(sp)
    800029c6:	6105                	addi	sp,sp,32
    800029c8:	8082                	ret

00000000800029ca <sys_getpid>:

uint64
sys_getpid(void)
{
    800029ca:	1141                	addi	sp,sp,-16
    800029cc:	e406                	sd	ra,8(sp)
    800029ce:	e022                	sd	s0,0(sp)
    800029d0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800029d2:	f21fe0ef          	jal	800018f2 <myproc>
}
    800029d6:	5908                	lw	a0,48(a0)
    800029d8:	60a2                	ld	ra,8(sp)
    800029da:	6402                	ld	s0,0(sp)
    800029dc:	0141                	addi	sp,sp,16
    800029de:	8082                	ret

00000000800029e0 <sys_fork>:

uint64
sys_fork(void)
{
    800029e0:	1141                	addi	sp,sp,-16
    800029e2:	e406                	sd	ra,8(sp)
    800029e4:	e022                	sd	s0,0(sp)
    800029e6:	0800                	addi	s0,sp,16
  return fork();
    800029e8:	98fff0ef          	jal	80002376 <fork>
}
    800029ec:	60a2                	ld	ra,8(sp)
    800029ee:	6402                	ld	s0,0(sp)
    800029f0:	0141                	addi	sp,sp,16
    800029f2:	8082                	ret

00000000800029f4 <sys_wait>:

uint64
sys_wait(void)
{
    800029f4:	1101                	addi	sp,sp,-32
    800029f6:	ec06                	sd	ra,24(sp)
    800029f8:	e822                	sd	s0,16(sp)
    800029fa:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800029fc:	fe840593          	addi	a1,s0,-24
    80002a00:	4501                	li	a0,0
    80002a02:	ef5ff0ef          	jal	800028f6 <argaddr>
  return wait(p);
    80002a06:	fe843503          	ld	a0,-24(s0)
    80002a0a:	d32ff0ef          	jal	80001f3c <wait>
}
    80002a0e:	60e2                	ld	ra,24(sp)
    80002a10:	6442                	ld	s0,16(sp)
    80002a12:	6105                	addi	sp,sp,32
    80002a14:	8082                	ret

0000000080002a16 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002a16:	7179                	addi	sp,sp,-48
    80002a18:	f406                	sd	ra,40(sp)
    80002a1a:	f022                	sd	s0,32(sp)
    80002a1c:	ec26                	sd	s1,24(sp)
    80002a1e:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002a20:	fdc40593          	addi	a1,s0,-36
    80002a24:	4501                	li	a0,0
    80002a26:	eb5ff0ef          	jal	800028da <argint>
  addr = myproc()->sz;
    80002a2a:	ec9fe0ef          	jal	800018f2 <myproc>
    80002a2e:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002a30:	fdc42503          	lw	a0,-36(s0)
    80002a34:	880ff0ef          	jal	80001ab4 <growproc>
    80002a38:	00054863          	bltz	a0,80002a48 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002a3c:	8526                	mv	a0,s1
    80002a3e:	70a2                	ld	ra,40(sp)
    80002a40:	7402                	ld	s0,32(sp)
    80002a42:	64e2                	ld	s1,24(sp)
    80002a44:	6145                	addi	sp,sp,48
    80002a46:	8082                	ret
    return -1;
    80002a48:	54fd                	li	s1,-1
    80002a4a:	bfcd                	j	80002a3c <sys_sbrk+0x26>

0000000080002a4c <sys_sleep>:

uint64
sys_sleep(void)
{
    80002a4c:	7139                	addi	sp,sp,-64
    80002a4e:	fc06                	sd	ra,56(sp)
    80002a50:	f822                	sd	s0,48(sp)
    80002a52:	f04a                	sd	s2,32(sp)
    80002a54:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002a56:	fcc40593          	addi	a1,s0,-52
    80002a5a:	4501                	li	a0,0
    80002a5c:	e7fff0ef          	jal	800028da <argint>
  if(n < 0)
    80002a60:	fcc42783          	lw	a5,-52(s0)
    80002a64:	0607c763          	bltz	a5,80002ad2 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002a68:	00013517          	auipc	a0,0x13
    80002a6c:	30850513          	addi	a0,a0,776 # 80015d70 <tickslock>
    80002a70:	984fe0ef          	jal	80000bf4 <acquire>
  ticks0 = ticks;
    80002a74:	00005917          	auipc	s2,0x5
    80002a78:	f0c92903          	lw	s2,-244(s2) # 80007980 <ticks>
  while(ticks - ticks0 < n){
    80002a7c:	fcc42783          	lw	a5,-52(s0)
    80002a80:	cf8d                	beqz	a5,80002aba <sys_sleep+0x6e>
    80002a82:	f426                	sd	s1,40(sp)
    80002a84:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002a86:	00013997          	auipc	s3,0x13
    80002a8a:	2ea98993          	addi	s3,s3,746 # 80015d70 <tickslock>
    80002a8e:	00005497          	auipc	s1,0x5
    80002a92:	ef248493          	addi	s1,s1,-270 # 80007980 <ticks>
    if(killed(myproc())){
    80002a96:	e5dfe0ef          	jal	800018f2 <myproc>
    80002a9a:	c78ff0ef          	jal	80001f12 <killed>
    80002a9e:	ed0d                	bnez	a0,80002ad8 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002aa0:	85ce                	mv	a1,s3
    80002aa2:	8526                	mv	a0,s1
    80002aa4:	a36ff0ef          	jal	80001cda <sleep>
  while(ticks - ticks0 < n){
    80002aa8:	409c                	lw	a5,0(s1)
    80002aaa:	412787bb          	subw	a5,a5,s2
    80002aae:	fcc42703          	lw	a4,-52(s0)
    80002ab2:	fee7e2e3          	bltu	a5,a4,80002a96 <sys_sleep+0x4a>
    80002ab6:	74a2                	ld	s1,40(sp)
    80002ab8:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002aba:	00013517          	auipc	a0,0x13
    80002abe:	2b650513          	addi	a0,a0,694 # 80015d70 <tickslock>
    80002ac2:	9cafe0ef          	jal	80000c8c <release>
  return 0;
    80002ac6:	4501                	li	a0,0
}
    80002ac8:	70e2                	ld	ra,56(sp)
    80002aca:	7442                	ld	s0,48(sp)
    80002acc:	7902                	ld	s2,32(sp)
    80002ace:	6121                	addi	sp,sp,64
    80002ad0:	8082                	ret
    n = 0;
    80002ad2:	fc042623          	sw	zero,-52(s0)
    80002ad6:	bf49                	j	80002a68 <sys_sleep+0x1c>
      release(&tickslock);
    80002ad8:	00013517          	auipc	a0,0x13
    80002adc:	29850513          	addi	a0,a0,664 # 80015d70 <tickslock>
    80002ae0:	9acfe0ef          	jal	80000c8c <release>
      return -1;
    80002ae4:	557d                	li	a0,-1
    80002ae6:	74a2                	ld	s1,40(sp)
    80002ae8:	69e2                	ld	s3,24(sp)
    80002aea:	bff9                	j	80002ac8 <sys_sleep+0x7c>

0000000080002aec <sys_kill>:

uint64
sys_kill(void)
{
    80002aec:	1101                	addi	sp,sp,-32
    80002aee:	ec06                	sd	ra,24(sp)
    80002af0:	e822                	sd	s0,16(sp)
    80002af2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002af4:	fec40593          	addi	a1,s0,-20
    80002af8:	4501                	li	a0,0
    80002afa:	de1ff0ef          	jal	800028da <argint>
  return kill(pid);
    80002afe:	fec42503          	lw	a0,-20(s0)
    80002b02:	b86ff0ef          	jal	80001e88 <kill>
}
    80002b06:	60e2                	ld	ra,24(sp)
    80002b08:	6442                	ld	s0,16(sp)
    80002b0a:	6105                	addi	sp,sp,32
    80002b0c:	8082                	ret

0000000080002b0e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002b0e:	1101                	addi	sp,sp,-32
    80002b10:	ec06                	sd	ra,24(sp)
    80002b12:	e822                	sd	s0,16(sp)
    80002b14:	e426                	sd	s1,8(sp)
    80002b16:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002b18:	00013517          	auipc	a0,0x13
    80002b1c:	25850513          	addi	a0,a0,600 # 80015d70 <tickslock>
    80002b20:	8d4fe0ef          	jal	80000bf4 <acquire>
  xticks = ticks;
    80002b24:	00005497          	auipc	s1,0x5
    80002b28:	e5c4a483          	lw	s1,-420(s1) # 80007980 <ticks>
  release(&tickslock);
    80002b2c:	00013517          	auipc	a0,0x13
    80002b30:	24450513          	addi	a0,a0,580 # 80015d70 <tickslock>
    80002b34:	958fe0ef          	jal	80000c8c <release>
  return xticks;
}
    80002b38:	02049513          	slli	a0,s1,0x20
    80002b3c:	9101                	srli	a0,a0,0x20
    80002b3e:	60e2                	ld	ra,24(sp)
    80002b40:	6442                	ld	s0,16(sp)
    80002b42:	64a2                	ld	s1,8(sp)
    80002b44:	6105                	addi	sp,sp,32
    80002b46:	8082                	ret

0000000080002b48 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002b48:	7179                	addi	sp,sp,-48
    80002b4a:	f406                	sd	ra,40(sp)
    80002b4c:	f022                	sd	s0,32(sp)
    80002b4e:	ec26                	sd	s1,24(sp)
    80002b50:	e84a                	sd	s2,16(sp)
    80002b52:	e44e                	sd	s3,8(sp)
    80002b54:	e052                	sd	s4,0(sp)
    80002b56:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002b58:	00005597          	auipc	a1,0x5
    80002b5c:	95858593          	addi	a1,a1,-1704 # 800074b0 <etext+0x4b0>
    80002b60:	00013517          	auipc	a0,0x13
    80002b64:	22850513          	addi	a0,a0,552 # 80015d88 <bcache>
    80002b68:	80cfe0ef          	jal	80000b74 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002b6c:	0001b797          	auipc	a5,0x1b
    80002b70:	21c78793          	addi	a5,a5,540 # 8001dd88 <bcache+0x8000>
    80002b74:	0001b717          	auipc	a4,0x1b
    80002b78:	47c70713          	addi	a4,a4,1148 # 8001dff0 <bcache+0x8268>
    80002b7c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002b80:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b84:	00013497          	auipc	s1,0x13
    80002b88:	21c48493          	addi	s1,s1,540 # 80015da0 <bcache+0x18>
    b->next = bcache.head.next;
    80002b8c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002b8e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002b90:	00005a17          	auipc	s4,0x5
    80002b94:	928a0a13          	addi	s4,s4,-1752 # 800074b8 <etext+0x4b8>
    b->next = bcache.head.next;
    80002b98:	2b893783          	ld	a5,696(s2)
    80002b9c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002b9e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002ba2:	85d2                	mv	a1,s4
    80002ba4:	01048513          	addi	a0,s1,16
    80002ba8:	248010ef          	jal	80003df0 <initsleeplock>
    bcache.head.next->prev = b;
    80002bac:	2b893783          	ld	a5,696(s2)
    80002bb0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002bb2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002bb6:	45848493          	addi	s1,s1,1112
    80002bba:	fd349fe3          	bne	s1,s3,80002b98 <binit+0x50>
  }
}
    80002bbe:	70a2                	ld	ra,40(sp)
    80002bc0:	7402                	ld	s0,32(sp)
    80002bc2:	64e2                	ld	s1,24(sp)
    80002bc4:	6942                	ld	s2,16(sp)
    80002bc6:	69a2                	ld	s3,8(sp)
    80002bc8:	6a02                	ld	s4,0(sp)
    80002bca:	6145                	addi	sp,sp,48
    80002bcc:	8082                	ret

0000000080002bce <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002bce:	7179                	addi	sp,sp,-48
    80002bd0:	f406                	sd	ra,40(sp)
    80002bd2:	f022                	sd	s0,32(sp)
    80002bd4:	ec26                	sd	s1,24(sp)
    80002bd6:	e84a                	sd	s2,16(sp)
    80002bd8:	e44e                	sd	s3,8(sp)
    80002bda:	1800                	addi	s0,sp,48
    80002bdc:	892a                	mv	s2,a0
    80002bde:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002be0:	00013517          	auipc	a0,0x13
    80002be4:	1a850513          	addi	a0,a0,424 # 80015d88 <bcache>
    80002be8:	80cfe0ef          	jal	80000bf4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002bec:	0001b497          	auipc	s1,0x1b
    80002bf0:	4544b483          	ld	s1,1108(s1) # 8001e040 <bcache+0x82b8>
    80002bf4:	0001b797          	auipc	a5,0x1b
    80002bf8:	3fc78793          	addi	a5,a5,1020 # 8001dff0 <bcache+0x8268>
    80002bfc:	02f48b63          	beq	s1,a5,80002c32 <bread+0x64>
    80002c00:	873e                	mv	a4,a5
    80002c02:	a021                	j	80002c0a <bread+0x3c>
    80002c04:	68a4                	ld	s1,80(s1)
    80002c06:	02e48663          	beq	s1,a4,80002c32 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002c0a:	449c                	lw	a5,8(s1)
    80002c0c:	ff279ce3          	bne	a5,s2,80002c04 <bread+0x36>
    80002c10:	44dc                	lw	a5,12(s1)
    80002c12:	ff3799e3          	bne	a5,s3,80002c04 <bread+0x36>
      b->refcnt++;
    80002c16:	40bc                	lw	a5,64(s1)
    80002c18:	2785                	addiw	a5,a5,1
    80002c1a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c1c:	00013517          	auipc	a0,0x13
    80002c20:	16c50513          	addi	a0,a0,364 # 80015d88 <bcache>
    80002c24:	868fe0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002c28:	01048513          	addi	a0,s1,16
    80002c2c:	1fa010ef          	jal	80003e26 <acquiresleep>
      return b;
    80002c30:	a889                	j	80002c82 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c32:	0001b497          	auipc	s1,0x1b
    80002c36:	4064b483          	ld	s1,1030(s1) # 8001e038 <bcache+0x82b0>
    80002c3a:	0001b797          	auipc	a5,0x1b
    80002c3e:	3b678793          	addi	a5,a5,950 # 8001dff0 <bcache+0x8268>
    80002c42:	00f48863          	beq	s1,a5,80002c52 <bread+0x84>
    80002c46:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002c48:	40bc                	lw	a5,64(s1)
    80002c4a:	cb91                	beqz	a5,80002c5e <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c4c:	64a4                	ld	s1,72(s1)
    80002c4e:	fee49de3          	bne	s1,a4,80002c48 <bread+0x7a>
  panic("bget: no buffers");
    80002c52:	00005517          	auipc	a0,0x5
    80002c56:	86e50513          	addi	a0,a0,-1938 # 800074c0 <etext+0x4c0>
    80002c5a:	b3bfd0ef          	jal	80000794 <panic>
      b->dev = dev;
    80002c5e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002c62:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002c66:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002c6a:	4785                	li	a5,1
    80002c6c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c6e:	00013517          	auipc	a0,0x13
    80002c72:	11a50513          	addi	a0,a0,282 # 80015d88 <bcache>
    80002c76:	816fe0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002c7a:	01048513          	addi	a0,s1,16
    80002c7e:	1a8010ef          	jal	80003e26 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002c82:	409c                	lw	a5,0(s1)
    80002c84:	cb89                	beqz	a5,80002c96 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002c86:	8526                	mv	a0,s1
    80002c88:	70a2                	ld	ra,40(sp)
    80002c8a:	7402                	ld	s0,32(sp)
    80002c8c:	64e2                	ld	s1,24(sp)
    80002c8e:	6942                	ld	s2,16(sp)
    80002c90:	69a2                	ld	s3,8(sp)
    80002c92:	6145                	addi	sp,sp,48
    80002c94:	8082                	ret
    virtio_disk_rw(b, 0);
    80002c96:	4581                	li	a1,0
    80002c98:	8526                	mv	a0,s1
    80002c9a:	1e7020ef          	jal	80005680 <virtio_disk_rw>
    b->valid = 1;
    80002c9e:	4785                	li	a5,1
    80002ca0:	c09c                	sw	a5,0(s1)
  return b;
    80002ca2:	b7d5                	j	80002c86 <bread+0xb8>

0000000080002ca4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002ca4:	1101                	addi	sp,sp,-32
    80002ca6:	ec06                	sd	ra,24(sp)
    80002ca8:	e822                	sd	s0,16(sp)
    80002caa:	e426                	sd	s1,8(sp)
    80002cac:	1000                	addi	s0,sp,32
    80002cae:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002cb0:	0541                	addi	a0,a0,16
    80002cb2:	1f2010ef          	jal	80003ea4 <holdingsleep>
    80002cb6:	c911                	beqz	a0,80002cca <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002cb8:	4585                	li	a1,1
    80002cba:	8526                	mv	a0,s1
    80002cbc:	1c5020ef          	jal	80005680 <virtio_disk_rw>
}
    80002cc0:	60e2                	ld	ra,24(sp)
    80002cc2:	6442                	ld	s0,16(sp)
    80002cc4:	64a2                	ld	s1,8(sp)
    80002cc6:	6105                	addi	sp,sp,32
    80002cc8:	8082                	ret
    panic("bwrite");
    80002cca:	00005517          	auipc	a0,0x5
    80002cce:	80e50513          	addi	a0,a0,-2034 # 800074d8 <etext+0x4d8>
    80002cd2:	ac3fd0ef          	jal	80000794 <panic>

0000000080002cd6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002cd6:	1101                	addi	sp,sp,-32
    80002cd8:	ec06                	sd	ra,24(sp)
    80002cda:	e822                	sd	s0,16(sp)
    80002cdc:	e426                	sd	s1,8(sp)
    80002cde:	e04a                	sd	s2,0(sp)
    80002ce0:	1000                	addi	s0,sp,32
    80002ce2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ce4:	01050913          	addi	s2,a0,16
    80002ce8:	854a                	mv	a0,s2
    80002cea:	1ba010ef          	jal	80003ea4 <holdingsleep>
    80002cee:	c135                	beqz	a0,80002d52 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002cf0:	854a                	mv	a0,s2
    80002cf2:	17a010ef          	jal	80003e6c <releasesleep>

  acquire(&bcache.lock);
    80002cf6:	00013517          	auipc	a0,0x13
    80002cfa:	09250513          	addi	a0,a0,146 # 80015d88 <bcache>
    80002cfe:	ef7fd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80002d02:	40bc                	lw	a5,64(s1)
    80002d04:	37fd                	addiw	a5,a5,-1
    80002d06:	0007871b          	sext.w	a4,a5
    80002d0a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002d0c:	e71d                	bnez	a4,80002d3a <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002d0e:	68b8                	ld	a4,80(s1)
    80002d10:	64bc                	ld	a5,72(s1)
    80002d12:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002d14:	68b8                	ld	a4,80(s1)
    80002d16:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002d18:	0001b797          	auipc	a5,0x1b
    80002d1c:	07078793          	addi	a5,a5,112 # 8001dd88 <bcache+0x8000>
    80002d20:	2b87b703          	ld	a4,696(a5)
    80002d24:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002d26:	0001b717          	auipc	a4,0x1b
    80002d2a:	2ca70713          	addi	a4,a4,714 # 8001dff0 <bcache+0x8268>
    80002d2e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002d30:	2b87b703          	ld	a4,696(a5)
    80002d34:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002d36:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002d3a:	00013517          	auipc	a0,0x13
    80002d3e:	04e50513          	addi	a0,a0,78 # 80015d88 <bcache>
    80002d42:	f4bfd0ef          	jal	80000c8c <release>
}
    80002d46:	60e2                	ld	ra,24(sp)
    80002d48:	6442                	ld	s0,16(sp)
    80002d4a:	64a2                	ld	s1,8(sp)
    80002d4c:	6902                	ld	s2,0(sp)
    80002d4e:	6105                	addi	sp,sp,32
    80002d50:	8082                	ret
    panic("brelse");
    80002d52:	00004517          	auipc	a0,0x4
    80002d56:	78e50513          	addi	a0,a0,1934 # 800074e0 <etext+0x4e0>
    80002d5a:	a3bfd0ef          	jal	80000794 <panic>

0000000080002d5e <bpin>:

void
bpin(struct buf *b) {
    80002d5e:	1101                	addi	sp,sp,-32
    80002d60:	ec06                	sd	ra,24(sp)
    80002d62:	e822                	sd	s0,16(sp)
    80002d64:	e426                	sd	s1,8(sp)
    80002d66:	1000                	addi	s0,sp,32
    80002d68:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d6a:	00013517          	auipc	a0,0x13
    80002d6e:	01e50513          	addi	a0,a0,30 # 80015d88 <bcache>
    80002d72:	e83fd0ef          	jal	80000bf4 <acquire>
  b->refcnt++;
    80002d76:	40bc                	lw	a5,64(s1)
    80002d78:	2785                	addiw	a5,a5,1
    80002d7a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d7c:	00013517          	auipc	a0,0x13
    80002d80:	00c50513          	addi	a0,a0,12 # 80015d88 <bcache>
    80002d84:	f09fd0ef          	jal	80000c8c <release>
}
    80002d88:	60e2                	ld	ra,24(sp)
    80002d8a:	6442                	ld	s0,16(sp)
    80002d8c:	64a2                	ld	s1,8(sp)
    80002d8e:	6105                	addi	sp,sp,32
    80002d90:	8082                	ret

0000000080002d92 <bunpin>:

void
bunpin(struct buf *b) {
    80002d92:	1101                	addi	sp,sp,-32
    80002d94:	ec06                	sd	ra,24(sp)
    80002d96:	e822                	sd	s0,16(sp)
    80002d98:	e426                	sd	s1,8(sp)
    80002d9a:	1000                	addi	s0,sp,32
    80002d9c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d9e:	00013517          	auipc	a0,0x13
    80002da2:	fea50513          	addi	a0,a0,-22 # 80015d88 <bcache>
    80002da6:	e4ffd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80002daa:	40bc                	lw	a5,64(s1)
    80002dac:	37fd                	addiw	a5,a5,-1
    80002dae:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002db0:	00013517          	auipc	a0,0x13
    80002db4:	fd850513          	addi	a0,a0,-40 # 80015d88 <bcache>
    80002db8:	ed5fd0ef          	jal	80000c8c <release>
}
    80002dbc:	60e2                	ld	ra,24(sp)
    80002dbe:	6442                	ld	s0,16(sp)
    80002dc0:	64a2                	ld	s1,8(sp)
    80002dc2:	6105                	addi	sp,sp,32
    80002dc4:	8082                	ret

0000000080002dc6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002dc6:	1101                	addi	sp,sp,-32
    80002dc8:	ec06                	sd	ra,24(sp)
    80002dca:	e822                	sd	s0,16(sp)
    80002dcc:	e426                	sd	s1,8(sp)
    80002dce:	e04a                	sd	s2,0(sp)
    80002dd0:	1000                	addi	s0,sp,32
    80002dd2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002dd4:	00d5d59b          	srliw	a1,a1,0xd
    80002dd8:	0001b797          	auipc	a5,0x1b
    80002ddc:	68c7a783          	lw	a5,1676(a5) # 8001e464 <sb+0x1c>
    80002de0:	9dbd                	addw	a1,a1,a5
    80002de2:	dedff0ef          	jal	80002bce <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002de6:	0074f713          	andi	a4,s1,7
    80002dea:	4785                	li	a5,1
    80002dec:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002df0:	14ce                	slli	s1,s1,0x33
    80002df2:	90d9                	srli	s1,s1,0x36
    80002df4:	00950733          	add	a4,a0,s1
    80002df8:	05874703          	lbu	a4,88(a4)
    80002dfc:	00e7f6b3          	and	a3,a5,a4
    80002e00:	c29d                	beqz	a3,80002e26 <bfree+0x60>
    80002e02:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002e04:	94aa                	add	s1,s1,a0
    80002e06:	fff7c793          	not	a5,a5
    80002e0a:	8f7d                	and	a4,a4,a5
    80002e0c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002e10:	711000ef          	jal	80003d20 <log_write>
  brelse(bp);
    80002e14:	854a                	mv	a0,s2
    80002e16:	ec1ff0ef          	jal	80002cd6 <brelse>
}
    80002e1a:	60e2                	ld	ra,24(sp)
    80002e1c:	6442                	ld	s0,16(sp)
    80002e1e:	64a2                	ld	s1,8(sp)
    80002e20:	6902                	ld	s2,0(sp)
    80002e22:	6105                	addi	sp,sp,32
    80002e24:	8082                	ret
    panic("freeing free block");
    80002e26:	00004517          	auipc	a0,0x4
    80002e2a:	6c250513          	addi	a0,a0,1730 # 800074e8 <etext+0x4e8>
    80002e2e:	967fd0ef          	jal	80000794 <panic>

0000000080002e32 <balloc>:
{
    80002e32:	711d                	addi	sp,sp,-96
    80002e34:	ec86                	sd	ra,88(sp)
    80002e36:	e8a2                	sd	s0,80(sp)
    80002e38:	e4a6                	sd	s1,72(sp)
    80002e3a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002e3c:	0001b797          	auipc	a5,0x1b
    80002e40:	6107a783          	lw	a5,1552(a5) # 8001e44c <sb+0x4>
    80002e44:	0e078f63          	beqz	a5,80002f42 <balloc+0x110>
    80002e48:	e0ca                	sd	s2,64(sp)
    80002e4a:	fc4e                	sd	s3,56(sp)
    80002e4c:	f852                	sd	s4,48(sp)
    80002e4e:	f456                	sd	s5,40(sp)
    80002e50:	f05a                	sd	s6,32(sp)
    80002e52:	ec5e                	sd	s7,24(sp)
    80002e54:	e862                	sd	s8,16(sp)
    80002e56:	e466                	sd	s9,8(sp)
    80002e58:	8baa                	mv	s7,a0
    80002e5a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002e5c:	0001bb17          	auipc	s6,0x1b
    80002e60:	5ecb0b13          	addi	s6,s6,1516 # 8001e448 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e64:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002e66:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e68:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002e6a:	6c89                	lui	s9,0x2
    80002e6c:	a0b5                	j	80002ed8 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002e6e:	97ca                	add	a5,a5,s2
    80002e70:	8e55                	or	a2,a2,a3
    80002e72:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002e76:	854a                	mv	a0,s2
    80002e78:	6a9000ef          	jal	80003d20 <log_write>
        brelse(bp);
    80002e7c:	854a                	mv	a0,s2
    80002e7e:	e59ff0ef          	jal	80002cd6 <brelse>
  bp = bread(dev, bno);
    80002e82:	85a6                	mv	a1,s1
    80002e84:	855e                	mv	a0,s7
    80002e86:	d49ff0ef          	jal	80002bce <bread>
    80002e8a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002e8c:	40000613          	li	a2,1024
    80002e90:	4581                	li	a1,0
    80002e92:	05850513          	addi	a0,a0,88
    80002e96:	e33fd0ef          	jal	80000cc8 <memset>
  log_write(bp);
    80002e9a:	854a                	mv	a0,s2
    80002e9c:	685000ef          	jal	80003d20 <log_write>
  brelse(bp);
    80002ea0:	854a                	mv	a0,s2
    80002ea2:	e35ff0ef          	jal	80002cd6 <brelse>
}
    80002ea6:	6906                	ld	s2,64(sp)
    80002ea8:	79e2                	ld	s3,56(sp)
    80002eaa:	7a42                	ld	s4,48(sp)
    80002eac:	7aa2                	ld	s5,40(sp)
    80002eae:	7b02                	ld	s6,32(sp)
    80002eb0:	6be2                	ld	s7,24(sp)
    80002eb2:	6c42                	ld	s8,16(sp)
    80002eb4:	6ca2                	ld	s9,8(sp)
}
    80002eb6:	8526                	mv	a0,s1
    80002eb8:	60e6                	ld	ra,88(sp)
    80002eba:	6446                	ld	s0,80(sp)
    80002ebc:	64a6                	ld	s1,72(sp)
    80002ebe:	6125                	addi	sp,sp,96
    80002ec0:	8082                	ret
    brelse(bp);
    80002ec2:	854a                	mv	a0,s2
    80002ec4:	e13ff0ef          	jal	80002cd6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002ec8:	015c87bb          	addw	a5,s9,s5
    80002ecc:	00078a9b          	sext.w	s5,a5
    80002ed0:	004b2703          	lw	a4,4(s6)
    80002ed4:	04eaff63          	bgeu	s5,a4,80002f32 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002ed8:	41fad79b          	sraiw	a5,s5,0x1f
    80002edc:	0137d79b          	srliw	a5,a5,0x13
    80002ee0:	015787bb          	addw	a5,a5,s5
    80002ee4:	40d7d79b          	sraiw	a5,a5,0xd
    80002ee8:	01cb2583          	lw	a1,28(s6)
    80002eec:	9dbd                	addw	a1,a1,a5
    80002eee:	855e                	mv	a0,s7
    80002ef0:	cdfff0ef          	jal	80002bce <bread>
    80002ef4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002ef6:	004b2503          	lw	a0,4(s6)
    80002efa:	000a849b          	sext.w	s1,s5
    80002efe:	8762                	mv	a4,s8
    80002f00:	fca4f1e3          	bgeu	s1,a0,80002ec2 <balloc+0x90>
      m = 1 << (bi % 8);
    80002f04:	00777693          	andi	a3,a4,7
    80002f08:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002f0c:	41f7579b          	sraiw	a5,a4,0x1f
    80002f10:	01d7d79b          	srliw	a5,a5,0x1d
    80002f14:	9fb9                	addw	a5,a5,a4
    80002f16:	4037d79b          	sraiw	a5,a5,0x3
    80002f1a:	00f90633          	add	a2,s2,a5
    80002f1e:	05864603          	lbu	a2,88(a2)
    80002f22:	00c6f5b3          	and	a1,a3,a2
    80002f26:	d5a1                	beqz	a1,80002e6e <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f28:	2705                	addiw	a4,a4,1
    80002f2a:	2485                	addiw	s1,s1,1
    80002f2c:	fd471ae3          	bne	a4,s4,80002f00 <balloc+0xce>
    80002f30:	bf49                	j	80002ec2 <balloc+0x90>
    80002f32:	6906                	ld	s2,64(sp)
    80002f34:	79e2                	ld	s3,56(sp)
    80002f36:	7a42                	ld	s4,48(sp)
    80002f38:	7aa2                	ld	s5,40(sp)
    80002f3a:	7b02                	ld	s6,32(sp)
    80002f3c:	6be2                	ld	s7,24(sp)
    80002f3e:	6c42                	ld	s8,16(sp)
    80002f40:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002f42:	00004517          	auipc	a0,0x4
    80002f46:	5be50513          	addi	a0,a0,1470 # 80007500 <etext+0x500>
    80002f4a:	d78fd0ef          	jal	800004c2 <printf>
  return 0;
    80002f4e:	4481                	li	s1,0
    80002f50:	b79d                	j	80002eb6 <balloc+0x84>

0000000080002f52 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002f52:	7179                	addi	sp,sp,-48
    80002f54:	f406                	sd	ra,40(sp)
    80002f56:	f022                	sd	s0,32(sp)
    80002f58:	ec26                	sd	s1,24(sp)
    80002f5a:	e84a                	sd	s2,16(sp)
    80002f5c:	e44e                	sd	s3,8(sp)
    80002f5e:	1800                	addi	s0,sp,48
    80002f60:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002f62:	47ad                	li	a5,11
    80002f64:	02b7e663          	bltu	a5,a1,80002f90 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002f68:	02059793          	slli	a5,a1,0x20
    80002f6c:	01e7d593          	srli	a1,a5,0x1e
    80002f70:	00b504b3          	add	s1,a0,a1
    80002f74:	0504a903          	lw	s2,80(s1)
    80002f78:	06091a63          	bnez	s2,80002fec <bmap+0x9a>
      addr = balloc(ip->dev);
    80002f7c:	4108                	lw	a0,0(a0)
    80002f7e:	eb5ff0ef          	jal	80002e32 <balloc>
    80002f82:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002f86:	06090363          	beqz	s2,80002fec <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002f8a:	0524a823          	sw	s2,80(s1)
    80002f8e:	a8b9                	j	80002fec <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002f90:	ff45849b          	addiw	s1,a1,-12
    80002f94:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002f98:	0ff00793          	li	a5,255
    80002f9c:	06e7ee63          	bltu	a5,a4,80003018 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002fa0:	08052903          	lw	s2,128(a0)
    80002fa4:	00091d63          	bnez	s2,80002fbe <bmap+0x6c>
      addr = balloc(ip->dev);
    80002fa8:	4108                	lw	a0,0(a0)
    80002faa:	e89ff0ef          	jal	80002e32 <balloc>
    80002fae:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002fb2:	02090d63          	beqz	s2,80002fec <bmap+0x9a>
    80002fb6:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002fb8:	0929a023          	sw	s2,128(s3)
    80002fbc:	a011                	j	80002fc0 <bmap+0x6e>
    80002fbe:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002fc0:	85ca                	mv	a1,s2
    80002fc2:	0009a503          	lw	a0,0(s3)
    80002fc6:	c09ff0ef          	jal	80002bce <bread>
    80002fca:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002fcc:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002fd0:	02049713          	slli	a4,s1,0x20
    80002fd4:	01e75593          	srli	a1,a4,0x1e
    80002fd8:	00b784b3          	add	s1,a5,a1
    80002fdc:	0004a903          	lw	s2,0(s1)
    80002fe0:	00090e63          	beqz	s2,80002ffc <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002fe4:	8552                	mv	a0,s4
    80002fe6:	cf1ff0ef          	jal	80002cd6 <brelse>
    return addr;
    80002fea:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002fec:	854a                	mv	a0,s2
    80002fee:	70a2                	ld	ra,40(sp)
    80002ff0:	7402                	ld	s0,32(sp)
    80002ff2:	64e2                	ld	s1,24(sp)
    80002ff4:	6942                	ld	s2,16(sp)
    80002ff6:	69a2                	ld	s3,8(sp)
    80002ff8:	6145                	addi	sp,sp,48
    80002ffa:	8082                	ret
      addr = balloc(ip->dev);
    80002ffc:	0009a503          	lw	a0,0(s3)
    80003000:	e33ff0ef          	jal	80002e32 <balloc>
    80003004:	0005091b          	sext.w	s2,a0
      if(addr){
    80003008:	fc090ee3          	beqz	s2,80002fe4 <bmap+0x92>
        a[bn] = addr;
    8000300c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003010:	8552                	mv	a0,s4
    80003012:	50f000ef          	jal	80003d20 <log_write>
    80003016:	b7f9                	j	80002fe4 <bmap+0x92>
    80003018:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000301a:	00004517          	auipc	a0,0x4
    8000301e:	4fe50513          	addi	a0,a0,1278 # 80007518 <etext+0x518>
    80003022:	f72fd0ef          	jal	80000794 <panic>

0000000080003026 <iget>:
{
    80003026:	7179                	addi	sp,sp,-48
    80003028:	f406                	sd	ra,40(sp)
    8000302a:	f022                	sd	s0,32(sp)
    8000302c:	ec26                	sd	s1,24(sp)
    8000302e:	e84a                	sd	s2,16(sp)
    80003030:	e44e                	sd	s3,8(sp)
    80003032:	e052                	sd	s4,0(sp)
    80003034:	1800                	addi	s0,sp,48
    80003036:	89aa                	mv	s3,a0
    80003038:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000303a:	0001b517          	auipc	a0,0x1b
    8000303e:	42e50513          	addi	a0,a0,1070 # 8001e468 <itable>
    80003042:	bb3fd0ef          	jal	80000bf4 <acquire>
  empty = 0;
    80003046:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003048:	0001b497          	auipc	s1,0x1b
    8000304c:	43848493          	addi	s1,s1,1080 # 8001e480 <itable+0x18>
    80003050:	0001d697          	auipc	a3,0x1d
    80003054:	ec068693          	addi	a3,a3,-320 # 8001ff10 <log>
    80003058:	a039                	j	80003066 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000305a:	02090963          	beqz	s2,8000308c <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000305e:	08848493          	addi	s1,s1,136
    80003062:	02d48863          	beq	s1,a3,80003092 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003066:	449c                	lw	a5,8(s1)
    80003068:	fef059e3          	blez	a5,8000305a <iget+0x34>
    8000306c:	4098                	lw	a4,0(s1)
    8000306e:	ff3716e3          	bne	a4,s3,8000305a <iget+0x34>
    80003072:	40d8                	lw	a4,4(s1)
    80003074:	ff4713e3          	bne	a4,s4,8000305a <iget+0x34>
      ip->ref++;
    80003078:	2785                	addiw	a5,a5,1
    8000307a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000307c:	0001b517          	auipc	a0,0x1b
    80003080:	3ec50513          	addi	a0,a0,1004 # 8001e468 <itable>
    80003084:	c09fd0ef          	jal	80000c8c <release>
      return ip;
    80003088:	8926                	mv	s2,s1
    8000308a:	a02d                	j	800030b4 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000308c:	fbe9                	bnez	a5,8000305e <iget+0x38>
      empty = ip;
    8000308e:	8926                	mv	s2,s1
    80003090:	b7f9                	j	8000305e <iget+0x38>
  if(empty == 0)
    80003092:	02090a63          	beqz	s2,800030c6 <iget+0xa0>
  ip->dev = dev;
    80003096:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000309a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000309e:	4785                	li	a5,1
    800030a0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800030a4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800030a8:	0001b517          	auipc	a0,0x1b
    800030ac:	3c050513          	addi	a0,a0,960 # 8001e468 <itable>
    800030b0:	bddfd0ef          	jal	80000c8c <release>
}
    800030b4:	854a                	mv	a0,s2
    800030b6:	70a2                	ld	ra,40(sp)
    800030b8:	7402                	ld	s0,32(sp)
    800030ba:	64e2                	ld	s1,24(sp)
    800030bc:	6942                	ld	s2,16(sp)
    800030be:	69a2                	ld	s3,8(sp)
    800030c0:	6a02                	ld	s4,0(sp)
    800030c2:	6145                	addi	sp,sp,48
    800030c4:	8082                	ret
    panic("iget: no inodes");
    800030c6:	00004517          	auipc	a0,0x4
    800030ca:	46a50513          	addi	a0,a0,1130 # 80007530 <etext+0x530>
    800030ce:	ec6fd0ef          	jal	80000794 <panic>

00000000800030d2 <fsinit>:
fsinit(int dev) {
    800030d2:	7179                	addi	sp,sp,-48
    800030d4:	f406                	sd	ra,40(sp)
    800030d6:	f022                	sd	s0,32(sp)
    800030d8:	ec26                	sd	s1,24(sp)
    800030da:	e84a                	sd	s2,16(sp)
    800030dc:	e44e                	sd	s3,8(sp)
    800030de:	1800                	addi	s0,sp,48
    800030e0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800030e2:	4585                	li	a1,1
    800030e4:	aebff0ef          	jal	80002bce <bread>
    800030e8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800030ea:	0001b997          	auipc	s3,0x1b
    800030ee:	35e98993          	addi	s3,s3,862 # 8001e448 <sb>
    800030f2:	02000613          	li	a2,32
    800030f6:	05850593          	addi	a1,a0,88
    800030fa:	854e                	mv	a0,s3
    800030fc:	c29fd0ef          	jal	80000d24 <memmove>
  brelse(bp);
    80003100:	8526                	mv	a0,s1
    80003102:	bd5ff0ef          	jal	80002cd6 <brelse>
  if(sb.magic != FSMAGIC)
    80003106:	0009a703          	lw	a4,0(s3)
    8000310a:	102037b7          	lui	a5,0x10203
    8000310e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003112:	02f71063          	bne	a4,a5,80003132 <fsinit+0x60>
  initlog(dev, &sb);
    80003116:	0001b597          	auipc	a1,0x1b
    8000311a:	33258593          	addi	a1,a1,818 # 8001e448 <sb>
    8000311e:	854a                	mv	a0,s2
    80003120:	1f9000ef          	jal	80003b18 <initlog>
}
    80003124:	70a2                	ld	ra,40(sp)
    80003126:	7402                	ld	s0,32(sp)
    80003128:	64e2                	ld	s1,24(sp)
    8000312a:	6942                	ld	s2,16(sp)
    8000312c:	69a2                	ld	s3,8(sp)
    8000312e:	6145                	addi	sp,sp,48
    80003130:	8082                	ret
    panic("invalid file system");
    80003132:	00004517          	auipc	a0,0x4
    80003136:	40e50513          	addi	a0,a0,1038 # 80007540 <etext+0x540>
    8000313a:	e5afd0ef          	jal	80000794 <panic>

000000008000313e <iinit>:
{
    8000313e:	7179                	addi	sp,sp,-48
    80003140:	f406                	sd	ra,40(sp)
    80003142:	f022                	sd	s0,32(sp)
    80003144:	ec26                	sd	s1,24(sp)
    80003146:	e84a                	sd	s2,16(sp)
    80003148:	e44e                	sd	s3,8(sp)
    8000314a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000314c:	00004597          	auipc	a1,0x4
    80003150:	40c58593          	addi	a1,a1,1036 # 80007558 <etext+0x558>
    80003154:	0001b517          	auipc	a0,0x1b
    80003158:	31450513          	addi	a0,a0,788 # 8001e468 <itable>
    8000315c:	a19fd0ef          	jal	80000b74 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003160:	0001b497          	auipc	s1,0x1b
    80003164:	33048493          	addi	s1,s1,816 # 8001e490 <itable+0x28>
    80003168:	0001d997          	auipc	s3,0x1d
    8000316c:	db898993          	addi	s3,s3,-584 # 8001ff20 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003170:	00004917          	auipc	s2,0x4
    80003174:	3f090913          	addi	s2,s2,1008 # 80007560 <etext+0x560>
    80003178:	85ca                	mv	a1,s2
    8000317a:	8526                	mv	a0,s1
    8000317c:	475000ef          	jal	80003df0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003180:	08848493          	addi	s1,s1,136
    80003184:	ff349ae3          	bne	s1,s3,80003178 <iinit+0x3a>
}
    80003188:	70a2                	ld	ra,40(sp)
    8000318a:	7402                	ld	s0,32(sp)
    8000318c:	64e2                	ld	s1,24(sp)
    8000318e:	6942                	ld	s2,16(sp)
    80003190:	69a2                	ld	s3,8(sp)
    80003192:	6145                	addi	sp,sp,48
    80003194:	8082                	ret

0000000080003196 <ialloc>:
{
    80003196:	7139                	addi	sp,sp,-64
    80003198:	fc06                	sd	ra,56(sp)
    8000319a:	f822                	sd	s0,48(sp)
    8000319c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000319e:	0001b717          	auipc	a4,0x1b
    800031a2:	2b672703          	lw	a4,694(a4) # 8001e454 <sb+0xc>
    800031a6:	4785                	li	a5,1
    800031a8:	06e7f063          	bgeu	a5,a4,80003208 <ialloc+0x72>
    800031ac:	f426                	sd	s1,40(sp)
    800031ae:	f04a                	sd	s2,32(sp)
    800031b0:	ec4e                	sd	s3,24(sp)
    800031b2:	e852                	sd	s4,16(sp)
    800031b4:	e456                	sd	s5,8(sp)
    800031b6:	e05a                	sd	s6,0(sp)
    800031b8:	8aaa                	mv	s5,a0
    800031ba:	8b2e                	mv	s6,a1
    800031bc:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800031be:	0001ba17          	auipc	s4,0x1b
    800031c2:	28aa0a13          	addi	s4,s4,650 # 8001e448 <sb>
    800031c6:	00495593          	srli	a1,s2,0x4
    800031ca:	018a2783          	lw	a5,24(s4)
    800031ce:	9dbd                	addw	a1,a1,a5
    800031d0:	8556                	mv	a0,s5
    800031d2:	9fdff0ef          	jal	80002bce <bread>
    800031d6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800031d8:	05850993          	addi	s3,a0,88
    800031dc:	00f97793          	andi	a5,s2,15
    800031e0:	079a                	slli	a5,a5,0x6
    800031e2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800031e4:	00099783          	lh	a5,0(s3)
    800031e8:	cb9d                	beqz	a5,8000321e <ialloc+0x88>
    brelse(bp);
    800031ea:	aedff0ef          	jal	80002cd6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800031ee:	0905                	addi	s2,s2,1
    800031f0:	00ca2703          	lw	a4,12(s4)
    800031f4:	0009079b          	sext.w	a5,s2
    800031f8:	fce7e7e3          	bltu	a5,a4,800031c6 <ialloc+0x30>
    800031fc:	74a2                	ld	s1,40(sp)
    800031fe:	7902                	ld	s2,32(sp)
    80003200:	69e2                	ld	s3,24(sp)
    80003202:	6a42                	ld	s4,16(sp)
    80003204:	6aa2                	ld	s5,8(sp)
    80003206:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003208:	00004517          	auipc	a0,0x4
    8000320c:	36050513          	addi	a0,a0,864 # 80007568 <etext+0x568>
    80003210:	ab2fd0ef          	jal	800004c2 <printf>
  return 0;
    80003214:	4501                	li	a0,0
}
    80003216:	70e2                	ld	ra,56(sp)
    80003218:	7442                	ld	s0,48(sp)
    8000321a:	6121                	addi	sp,sp,64
    8000321c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000321e:	04000613          	li	a2,64
    80003222:	4581                	li	a1,0
    80003224:	854e                	mv	a0,s3
    80003226:	aa3fd0ef          	jal	80000cc8 <memset>
      dip->type = type;
    8000322a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000322e:	8526                	mv	a0,s1
    80003230:	2f1000ef          	jal	80003d20 <log_write>
      brelse(bp);
    80003234:	8526                	mv	a0,s1
    80003236:	aa1ff0ef          	jal	80002cd6 <brelse>
      return iget(dev, inum);
    8000323a:	0009059b          	sext.w	a1,s2
    8000323e:	8556                	mv	a0,s5
    80003240:	de7ff0ef          	jal	80003026 <iget>
    80003244:	74a2                	ld	s1,40(sp)
    80003246:	7902                	ld	s2,32(sp)
    80003248:	69e2                	ld	s3,24(sp)
    8000324a:	6a42                	ld	s4,16(sp)
    8000324c:	6aa2                	ld	s5,8(sp)
    8000324e:	6b02                	ld	s6,0(sp)
    80003250:	b7d9                	j	80003216 <ialloc+0x80>

0000000080003252 <iupdate>:
{
    80003252:	1101                	addi	sp,sp,-32
    80003254:	ec06                	sd	ra,24(sp)
    80003256:	e822                	sd	s0,16(sp)
    80003258:	e426                	sd	s1,8(sp)
    8000325a:	e04a                	sd	s2,0(sp)
    8000325c:	1000                	addi	s0,sp,32
    8000325e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003260:	415c                	lw	a5,4(a0)
    80003262:	0047d79b          	srliw	a5,a5,0x4
    80003266:	0001b597          	auipc	a1,0x1b
    8000326a:	1fa5a583          	lw	a1,506(a1) # 8001e460 <sb+0x18>
    8000326e:	9dbd                	addw	a1,a1,a5
    80003270:	4108                	lw	a0,0(a0)
    80003272:	95dff0ef          	jal	80002bce <bread>
    80003276:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003278:	05850793          	addi	a5,a0,88
    8000327c:	40d8                	lw	a4,4(s1)
    8000327e:	8b3d                	andi	a4,a4,15
    80003280:	071a                	slli	a4,a4,0x6
    80003282:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003284:	04449703          	lh	a4,68(s1)
    80003288:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000328c:	04649703          	lh	a4,70(s1)
    80003290:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003294:	04849703          	lh	a4,72(s1)
    80003298:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000329c:	04a49703          	lh	a4,74(s1)
    800032a0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800032a4:	44f8                	lw	a4,76(s1)
    800032a6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800032a8:	03400613          	li	a2,52
    800032ac:	05048593          	addi	a1,s1,80
    800032b0:	00c78513          	addi	a0,a5,12
    800032b4:	a71fd0ef          	jal	80000d24 <memmove>
  log_write(bp);
    800032b8:	854a                	mv	a0,s2
    800032ba:	267000ef          	jal	80003d20 <log_write>
  brelse(bp);
    800032be:	854a                	mv	a0,s2
    800032c0:	a17ff0ef          	jal	80002cd6 <brelse>
}
    800032c4:	60e2                	ld	ra,24(sp)
    800032c6:	6442                	ld	s0,16(sp)
    800032c8:	64a2                	ld	s1,8(sp)
    800032ca:	6902                	ld	s2,0(sp)
    800032cc:	6105                	addi	sp,sp,32
    800032ce:	8082                	ret

00000000800032d0 <idup>:
{
    800032d0:	1101                	addi	sp,sp,-32
    800032d2:	ec06                	sd	ra,24(sp)
    800032d4:	e822                	sd	s0,16(sp)
    800032d6:	e426                	sd	s1,8(sp)
    800032d8:	1000                	addi	s0,sp,32
    800032da:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800032dc:	0001b517          	auipc	a0,0x1b
    800032e0:	18c50513          	addi	a0,a0,396 # 8001e468 <itable>
    800032e4:	911fd0ef          	jal	80000bf4 <acquire>
  ip->ref++;
    800032e8:	449c                	lw	a5,8(s1)
    800032ea:	2785                	addiw	a5,a5,1
    800032ec:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800032ee:	0001b517          	auipc	a0,0x1b
    800032f2:	17a50513          	addi	a0,a0,378 # 8001e468 <itable>
    800032f6:	997fd0ef          	jal	80000c8c <release>
}
    800032fa:	8526                	mv	a0,s1
    800032fc:	60e2                	ld	ra,24(sp)
    800032fe:	6442                	ld	s0,16(sp)
    80003300:	64a2                	ld	s1,8(sp)
    80003302:	6105                	addi	sp,sp,32
    80003304:	8082                	ret

0000000080003306 <ilock>:
{
    80003306:	1101                	addi	sp,sp,-32
    80003308:	ec06                	sd	ra,24(sp)
    8000330a:	e822                	sd	s0,16(sp)
    8000330c:	e426                	sd	s1,8(sp)
    8000330e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003310:	cd19                	beqz	a0,8000332e <ilock+0x28>
    80003312:	84aa                	mv	s1,a0
    80003314:	451c                	lw	a5,8(a0)
    80003316:	00f05c63          	blez	a5,8000332e <ilock+0x28>
  acquiresleep(&ip->lock);
    8000331a:	0541                	addi	a0,a0,16
    8000331c:	30b000ef          	jal	80003e26 <acquiresleep>
  if(ip->valid == 0){
    80003320:	40bc                	lw	a5,64(s1)
    80003322:	cf89                	beqz	a5,8000333c <ilock+0x36>
}
    80003324:	60e2                	ld	ra,24(sp)
    80003326:	6442                	ld	s0,16(sp)
    80003328:	64a2                	ld	s1,8(sp)
    8000332a:	6105                	addi	sp,sp,32
    8000332c:	8082                	ret
    8000332e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003330:	00004517          	auipc	a0,0x4
    80003334:	25050513          	addi	a0,a0,592 # 80007580 <etext+0x580>
    80003338:	c5cfd0ef          	jal	80000794 <panic>
    8000333c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000333e:	40dc                	lw	a5,4(s1)
    80003340:	0047d79b          	srliw	a5,a5,0x4
    80003344:	0001b597          	auipc	a1,0x1b
    80003348:	11c5a583          	lw	a1,284(a1) # 8001e460 <sb+0x18>
    8000334c:	9dbd                	addw	a1,a1,a5
    8000334e:	4088                	lw	a0,0(s1)
    80003350:	87fff0ef          	jal	80002bce <bread>
    80003354:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003356:	05850593          	addi	a1,a0,88
    8000335a:	40dc                	lw	a5,4(s1)
    8000335c:	8bbd                	andi	a5,a5,15
    8000335e:	079a                	slli	a5,a5,0x6
    80003360:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003362:	00059783          	lh	a5,0(a1)
    80003366:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000336a:	00259783          	lh	a5,2(a1)
    8000336e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003372:	00459783          	lh	a5,4(a1)
    80003376:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000337a:	00659783          	lh	a5,6(a1)
    8000337e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003382:	459c                	lw	a5,8(a1)
    80003384:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003386:	03400613          	li	a2,52
    8000338a:	05b1                	addi	a1,a1,12
    8000338c:	05048513          	addi	a0,s1,80
    80003390:	995fd0ef          	jal	80000d24 <memmove>
    brelse(bp);
    80003394:	854a                	mv	a0,s2
    80003396:	941ff0ef          	jal	80002cd6 <brelse>
    ip->valid = 1;
    8000339a:	4785                	li	a5,1
    8000339c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000339e:	04449783          	lh	a5,68(s1)
    800033a2:	c399                	beqz	a5,800033a8 <ilock+0xa2>
    800033a4:	6902                	ld	s2,0(sp)
    800033a6:	bfbd                	j	80003324 <ilock+0x1e>
      panic("ilock: no type");
    800033a8:	00004517          	auipc	a0,0x4
    800033ac:	1e050513          	addi	a0,a0,480 # 80007588 <etext+0x588>
    800033b0:	be4fd0ef          	jal	80000794 <panic>

00000000800033b4 <iunlock>:
{
    800033b4:	1101                	addi	sp,sp,-32
    800033b6:	ec06                	sd	ra,24(sp)
    800033b8:	e822                	sd	s0,16(sp)
    800033ba:	e426                	sd	s1,8(sp)
    800033bc:	e04a                	sd	s2,0(sp)
    800033be:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800033c0:	c505                	beqz	a0,800033e8 <iunlock+0x34>
    800033c2:	84aa                	mv	s1,a0
    800033c4:	01050913          	addi	s2,a0,16
    800033c8:	854a                	mv	a0,s2
    800033ca:	2db000ef          	jal	80003ea4 <holdingsleep>
    800033ce:	cd09                	beqz	a0,800033e8 <iunlock+0x34>
    800033d0:	449c                	lw	a5,8(s1)
    800033d2:	00f05b63          	blez	a5,800033e8 <iunlock+0x34>
  releasesleep(&ip->lock);
    800033d6:	854a                	mv	a0,s2
    800033d8:	295000ef          	jal	80003e6c <releasesleep>
}
    800033dc:	60e2                	ld	ra,24(sp)
    800033de:	6442                	ld	s0,16(sp)
    800033e0:	64a2                	ld	s1,8(sp)
    800033e2:	6902                	ld	s2,0(sp)
    800033e4:	6105                	addi	sp,sp,32
    800033e6:	8082                	ret
    panic("iunlock");
    800033e8:	00004517          	auipc	a0,0x4
    800033ec:	1b050513          	addi	a0,a0,432 # 80007598 <etext+0x598>
    800033f0:	ba4fd0ef          	jal	80000794 <panic>

00000000800033f4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800033f4:	7179                	addi	sp,sp,-48
    800033f6:	f406                	sd	ra,40(sp)
    800033f8:	f022                	sd	s0,32(sp)
    800033fa:	ec26                	sd	s1,24(sp)
    800033fc:	e84a                	sd	s2,16(sp)
    800033fe:	e44e                	sd	s3,8(sp)
    80003400:	1800                	addi	s0,sp,48
    80003402:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003404:	05050493          	addi	s1,a0,80
    80003408:	08050913          	addi	s2,a0,128
    8000340c:	a021                	j	80003414 <itrunc+0x20>
    8000340e:	0491                	addi	s1,s1,4
    80003410:	01248b63          	beq	s1,s2,80003426 <itrunc+0x32>
    if(ip->addrs[i]){
    80003414:	408c                	lw	a1,0(s1)
    80003416:	dde5                	beqz	a1,8000340e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003418:	0009a503          	lw	a0,0(s3)
    8000341c:	9abff0ef          	jal	80002dc6 <bfree>
      ip->addrs[i] = 0;
    80003420:	0004a023          	sw	zero,0(s1)
    80003424:	b7ed                	j	8000340e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003426:	0809a583          	lw	a1,128(s3)
    8000342a:	ed89                	bnez	a1,80003444 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000342c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003430:	854e                	mv	a0,s3
    80003432:	e21ff0ef          	jal	80003252 <iupdate>
}
    80003436:	70a2                	ld	ra,40(sp)
    80003438:	7402                	ld	s0,32(sp)
    8000343a:	64e2                	ld	s1,24(sp)
    8000343c:	6942                	ld	s2,16(sp)
    8000343e:	69a2                	ld	s3,8(sp)
    80003440:	6145                	addi	sp,sp,48
    80003442:	8082                	ret
    80003444:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003446:	0009a503          	lw	a0,0(s3)
    8000344a:	f84ff0ef          	jal	80002bce <bread>
    8000344e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003450:	05850493          	addi	s1,a0,88
    80003454:	45850913          	addi	s2,a0,1112
    80003458:	a021                	j	80003460 <itrunc+0x6c>
    8000345a:	0491                	addi	s1,s1,4
    8000345c:	01248963          	beq	s1,s2,8000346e <itrunc+0x7a>
      if(a[j])
    80003460:	408c                	lw	a1,0(s1)
    80003462:	dde5                	beqz	a1,8000345a <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003464:	0009a503          	lw	a0,0(s3)
    80003468:	95fff0ef          	jal	80002dc6 <bfree>
    8000346c:	b7fd                	j	8000345a <itrunc+0x66>
    brelse(bp);
    8000346e:	8552                	mv	a0,s4
    80003470:	867ff0ef          	jal	80002cd6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003474:	0809a583          	lw	a1,128(s3)
    80003478:	0009a503          	lw	a0,0(s3)
    8000347c:	94bff0ef          	jal	80002dc6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003480:	0809a023          	sw	zero,128(s3)
    80003484:	6a02                	ld	s4,0(sp)
    80003486:	b75d                	j	8000342c <itrunc+0x38>

0000000080003488 <iput>:
{
    80003488:	1101                	addi	sp,sp,-32
    8000348a:	ec06                	sd	ra,24(sp)
    8000348c:	e822                	sd	s0,16(sp)
    8000348e:	e426                	sd	s1,8(sp)
    80003490:	1000                	addi	s0,sp,32
    80003492:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003494:	0001b517          	auipc	a0,0x1b
    80003498:	fd450513          	addi	a0,a0,-44 # 8001e468 <itable>
    8000349c:	f58fd0ef          	jal	80000bf4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800034a0:	4498                	lw	a4,8(s1)
    800034a2:	4785                	li	a5,1
    800034a4:	02f70063          	beq	a4,a5,800034c4 <iput+0x3c>
  ip->ref--;
    800034a8:	449c                	lw	a5,8(s1)
    800034aa:	37fd                	addiw	a5,a5,-1
    800034ac:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800034ae:	0001b517          	auipc	a0,0x1b
    800034b2:	fba50513          	addi	a0,a0,-70 # 8001e468 <itable>
    800034b6:	fd6fd0ef          	jal	80000c8c <release>
}
    800034ba:	60e2                	ld	ra,24(sp)
    800034bc:	6442                	ld	s0,16(sp)
    800034be:	64a2                	ld	s1,8(sp)
    800034c0:	6105                	addi	sp,sp,32
    800034c2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800034c4:	40bc                	lw	a5,64(s1)
    800034c6:	d3ed                	beqz	a5,800034a8 <iput+0x20>
    800034c8:	04a49783          	lh	a5,74(s1)
    800034cc:	fff1                	bnez	a5,800034a8 <iput+0x20>
    800034ce:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800034d0:	01048913          	addi	s2,s1,16
    800034d4:	854a                	mv	a0,s2
    800034d6:	151000ef          	jal	80003e26 <acquiresleep>
    release(&itable.lock);
    800034da:	0001b517          	auipc	a0,0x1b
    800034de:	f8e50513          	addi	a0,a0,-114 # 8001e468 <itable>
    800034e2:	faafd0ef          	jal	80000c8c <release>
    itrunc(ip);
    800034e6:	8526                	mv	a0,s1
    800034e8:	f0dff0ef          	jal	800033f4 <itrunc>
    ip->type = 0;
    800034ec:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800034f0:	8526                	mv	a0,s1
    800034f2:	d61ff0ef          	jal	80003252 <iupdate>
    ip->valid = 0;
    800034f6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800034fa:	854a                	mv	a0,s2
    800034fc:	171000ef          	jal	80003e6c <releasesleep>
    acquire(&itable.lock);
    80003500:	0001b517          	auipc	a0,0x1b
    80003504:	f6850513          	addi	a0,a0,-152 # 8001e468 <itable>
    80003508:	eecfd0ef          	jal	80000bf4 <acquire>
    8000350c:	6902                	ld	s2,0(sp)
    8000350e:	bf69                	j	800034a8 <iput+0x20>

0000000080003510 <iunlockput>:
{
    80003510:	1101                	addi	sp,sp,-32
    80003512:	ec06                	sd	ra,24(sp)
    80003514:	e822                	sd	s0,16(sp)
    80003516:	e426                	sd	s1,8(sp)
    80003518:	1000                	addi	s0,sp,32
    8000351a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000351c:	e99ff0ef          	jal	800033b4 <iunlock>
  iput(ip);
    80003520:	8526                	mv	a0,s1
    80003522:	f67ff0ef          	jal	80003488 <iput>
}
    80003526:	60e2                	ld	ra,24(sp)
    80003528:	6442                	ld	s0,16(sp)
    8000352a:	64a2                	ld	s1,8(sp)
    8000352c:	6105                	addi	sp,sp,32
    8000352e:	8082                	ret

0000000080003530 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003530:	1141                	addi	sp,sp,-16
    80003532:	e422                	sd	s0,8(sp)
    80003534:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003536:	411c                	lw	a5,0(a0)
    80003538:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000353a:	415c                	lw	a5,4(a0)
    8000353c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000353e:	04451783          	lh	a5,68(a0)
    80003542:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003546:	04a51783          	lh	a5,74(a0)
    8000354a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000354e:	04c56783          	lwu	a5,76(a0)
    80003552:	e99c                	sd	a5,16(a1)
}
    80003554:	6422                	ld	s0,8(sp)
    80003556:	0141                	addi	sp,sp,16
    80003558:	8082                	ret

000000008000355a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000355a:	457c                	lw	a5,76(a0)
    8000355c:	0ed7eb63          	bltu	a5,a3,80003652 <readi+0xf8>
{
    80003560:	7159                	addi	sp,sp,-112
    80003562:	f486                	sd	ra,104(sp)
    80003564:	f0a2                	sd	s0,96(sp)
    80003566:	eca6                	sd	s1,88(sp)
    80003568:	e0d2                	sd	s4,64(sp)
    8000356a:	fc56                	sd	s5,56(sp)
    8000356c:	f85a                	sd	s6,48(sp)
    8000356e:	f45e                	sd	s7,40(sp)
    80003570:	1880                	addi	s0,sp,112
    80003572:	8b2a                	mv	s6,a0
    80003574:	8bae                	mv	s7,a1
    80003576:	8a32                	mv	s4,a2
    80003578:	84b6                	mv	s1,a3
    8000357a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000357c:	9f35                	addw	a4,a4,a3
    return 0;
    8000357e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003580:	0cd76063          	bltu	a4,a3,80003640 <readi+0xe6>
    80003584:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003586:	00e7f463          	bgeu	a5,a4,8000358e <readi+0x34>
    n = ip->size - off;
    8000358a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000358e:	080a8f63          	beqz	s5,8000362c <readi+0xd2>
    80003592:	e8ca                	sd	s2,80(sp)
    80003594:	f062                	sd	s8,32(sp)
    80003596:	ec66                	sd	s9,24(sp)
    80003598:	e86a                	sd	s10,16(sp)
    8000359a:	e46e                	sd	s11,8(sp)
    8000359c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000359e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800035a2:	5c7d                	li	s8,-1
    800035a4:	a80d                	j	800035d6 <readi+0x7c>
    800035a6:	020d1d93          	slli	s11,s10,0x20
    800035aa:	020ddd93          	srli	s11,s11,0x20
    800035ae:	05890613          	addi	a2,s2,88
    800035b2:	86ee                	mv	a3,s11
    800035b4:	963a                	add	a2,a2,a4
    800035b6:	85d2                	mv	a1,s4
    800035b8:	855e                	mv	a0,s7
    800035ba:	a7dfe0ef          	jal	80002036 <either_copyout>
    800035be:	05850763          	beq	a0,s8,8000360c <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800035c2:	854a                	mv	a0,s2
    800035c4:	f12ff0ef          	jal	80002cd6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800035c8:	013d09bb          	addw	s3,s10,s3
    800035cc:	009d04bb          	addw	s1,s10,s1
    800035d0:	9a6e                	add	s4,s4,s11
    800035d2:	0559f763          	bgeu	s3,s5,80003620 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    800035d6:	00a4d59b          	srliw	a1,s1,0xa
    800035da:	855a                	mv	a0,s6
    800035dc:	977ff0ef          	jal	80002f52 <bmap>
    800035e0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800035e4:	c5b1                	beqz	a1,80003630 <readi+0xd6>
    bp = bread(ip->dev, addr);
    800035e6:	000b2503          	lw	a0,0(s6)
    800035ea:	de4ff0ef          	jal	80002bce <bread>
    800035ee:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800035f0:	3ff4f713          	andi	a4,s1,1023
    800035f4:	40ec87bb          	subw	a5,s9,a4
    800035f8:	413a86bb          	subw	a3,s5,s3
    800035fc:	8d3e                	mv	s10,a5
    800035fe:	2781                	sext.w	a5,a5
    80003600:	0006861b          	sext.w	a2,a3
    80003604:	faf671e3          	bgeu	a2,a5,800035a6 <readi+0x4c>
    80003608:	8d36                	mv	s10,a3
    8000360a:	bf71                	j	800035a6 <readi+0x4c>
      brelse(bp);
    8000360c:	854a                	mv	a0,s2
    8000360e:	ec8ff0ef          	jal	80002cd6 <brelse>
      tot = -1;
    80003612:	59fd                	li	s3,-1
      break;
    80003614:	6946                	ld	s2,80(sp)
    80003616:	7c02                	ld	s8,32(sp)
    80003618:	6ce2                	ld	s9,24(sp)
    8000361a:	6d42                	ld	s10,16(sp)
    8000361c:	6da2                	ld	s11,8(sp)
    8000361e:	a831                	j	8000363a <readi+0xe0>
    80003620:	6946                	ld	s2,80(sp)
    80003622:	7c02                	ld	s8,32(sp)
    80003624:	6ce2                	ld	s9,24(sp)
    80003626:	6d42                	ld	s10,16(sp)
    80003628:	6da2                	ld	s11,8(sp)
    8000362a:	a801                	j	8000363a <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000362c:	89d6                	mv	s3,s5
    8000362e:	a031                	j	8000363a <readi+0xe0>
    80003630:	6946                	ld	s2,80(sp)
    80003632:	7c02                	ld	s8,32(sp)
    80003634:	6ce2                	ld	s9,24(sp)
    80003636:	6d42                	ld	s10,16(sp)
    80003638:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000363a:	0009851b          	sext.w	a0,s3
    8000363e:	69a6                	ld	s3,72(sp)
}
    80003640:	70a6                	ld	ra,104(sp)
    80003642:	7406                	ld	s0,96(sp)
    80003644:	64e6                	ld	s1,88(sp)
    80003646:	6a06                	ld	s4,64(sp)
    80003648:	7ae2                	ld	s5,56(sp)
    8000364a:	7b42                	ld	s6,48(sp)
    8000364c:	7ba2                	ld	s7,40(sp)
    8000364e:	6165                	addi	sp,sp,112
    80003650:	8082                	ret
    return 0;
    80003652:	4501                	li	a0,0
}
    80003654:	8082                	ret

0000000080003656 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003656:	457c                	lw	a5,76(a0)
    80003658:	10d7e063          	bltu	a5,a3,80003758 <writei+0x102>
{
    8000365c:	7159                	addi	sp,sp,-112
    8000365e:	f486                	sd	ra,104(sp)
    80003660:	f0a2                	sd	s0,96(sp)
    80003662:	e8ca                	sd	s2,80(sp)
    80003664:	e0d2                	sd	s4,64(sp)
    80003666:	fc56                	sd	s5,56(sp)
    80003668:	f85a                	sd	s6,48(sp)
    8000366a:	f45e                	sd	s7,40(sp)
    8000366c:	1880                	addi	s0,sp,112
    8000366e:	8aaa                	mv	s5,a0
    80003670:	8bae                	mv	s7,a1
    80003672:	8a32                	mv	s4,a2
    80003674:	8936                	mv	s2,a3
    80003676:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003678:	00e687bb          	addw	a5,a3,a4
    8000367c:	0ed7e063          	bltu	a5,a3,8000375c <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003680:	00043737          	lui	a4,0x43
    80003684:	0cf76e63          	bltu	a4,a5,80003760 <writei+0x10a>
    80003688:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000368a:	0a0b0f63          	beqz	s6,80003748 <writei+0xf2>
    8000368e:	eca6                	sd	s1,88(sp)
    80003690:	f062                	sd	s8,32(sp)
    80003692:	ec66                	sd	s9,24(sp)
    80003694:	e86a                	sd	s10,16(sp)
    80003696:	e46e                	sd	s11,8(sp)
    80003698:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000369a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000369e:	5c7d                	li	s8,-1
    800036a0:	a825                	j	800036d8 <writei+0x82>
    800036a2:	020d1d93          	slli	s11,s10,0x20
    800036a6:	020ddd93          	srli	s11,s11,0x20
    800036aa:	05848513          	addi	a0,s1,88
    800036ae:	86ee                	mv	a3,s11
    800036b0:	8652                	mv	a2,s4
    800036b2:	85de                	mv	a1,s7
    800036b4:	953a                	add	a0,a0,a4
    800036b6:	9cbfe0ef          	jal	80002080 <either_copyin>
    800036ba:	05850a63          	beq	a0,s8,8000370e <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800036be:	8526                	mv	a0,s1
    800036c0:	660000ef          	jal	80003d20 <log_write>
    brelse(bp);
    800036c4:	8526                	mv	a0,s1
    800036c6:	e10ff0ef          	jal	80002cd6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800036ca:	013d09bb          	addw	s3,s10,s3
    800036ce:	012d093b          	addw	s2,s10,s2
    800036d2:	9a6e                	add	s4,s4,s11
    800036d4:	0569f063          	bgeu	s3,s6,80003714 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800036d8:	00a9559b          	srliw	a1,s2,0xa
    800036dc:	8556                	mv	a0,s5
    800036de:	875ff0ef          	jal	80002f52 <bmap>
    800036e2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800036e6:	c59d                	beqz	a1,80003714 <writei+0xbe>
    bp = bread(ip->dev, addr);
    800036e8:	000aa503          	lw	a0,0(s5)
    800036ec:	ce2ff0ef          	jal	80002bce <bread>
    800036f0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800036f2:	3ff97713          	andi	a4,s2,1023
    800036f6:	40ec87bb          	subw	a5,s9,a4
    800036fa:	413b06bb          	subw	a3,s6,s3
    800036fe:	8d3e                	mv	s10,a5
    80003700:	2781                	sext.w	a5,a5
    80003702:	0006861b          	sext.w	a2,a3
    80003706:	f8f67ee3          	bgeu	a2,a5,800036a2 <writei+0x4c>
    8000370a:	8d36                	mv	s10,a3
    8000370c:	bf59                	j	800036a2 <writei+0x4c>
      brelse(bp);
    8000370e:	8526                	mv	a0,s1
    80003710:	dc6ff0ef          	jal	80002cd6 <brelse>
  }

  if(off > ip->size)
    80003714:	04caa783          	lw	a5,76(s5)
    80003718:	0327fa63          	bgeu	a5,s2,8000374c <writei+0xf6>
    ip->size = off;
    8000371c:	052aa623          	sw	s2,76(s5)
    80003720:	64e6                	ld	s1,88(sp)
    80003722:	7c02                	ld	s8,32(sp)
    80003724:	6ce2                	ld	s9,24(sp)
    80003726:	6d42                	ld	s10,16(sp)
    80003728:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000372a:	8556                	mv	a0,s5
    8000372c:	b27ff0ef          	jal	80003252 <iupdate>

  return tot;
    80003730:	0009851b          	sext.w	a0,s3
    80003734:	69a6                	ld	s3,72(sp)
}
    80003736:	70a6                	ld	ra,104(sp)
    80003738:	7406                	ld	s0,96(sp)
    8000373a:	6946                	ld	s2,80(sp)
    8000373c:	6a06                	ld	s4,64(sp)
    8000373e:	7ae2                	ld	s5,56(sp)
    80003740:	7b42                	ld	s6,48(sp)
    80003742:	7ba2                	ld	s7,40(sp)
    80003744:	6165                	addi	sp,sp,112
    80003746:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003748:	89da                	mv	s3,s6
    8000374a:	b7c5                	j	8000372a <writei+0xd4>
    8000374c:	64e6                	ld	s1,88(sp)
    8000374e:	7c02                	ld	s8,32(sp)
    80003750:	6ce2                	ld	s9,24(sp)
    80003752:	6d42                	ld	s10,16(sp)
    80003754:	6da2                	ld	s11,8(sp)
    80003756:	bfd1                	j	8000372a <writei+0xd4>
    return -1;
    80003758:	557d                	li	a0,-1
}
    8000375a:	8082                	ret
    return -1;
    8000375c:	557d                	li	a0,-1
    8000375e:	bfe1                	j	80003736 <writei+0xe0>
    return -1;
    80003760:	557d                	li	a0,-1
    80003762:	bfd1                	j	80003736 <writei+0xe0>

0000000080003764 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003764:	1141                	addi	sp,sp,-16
    80003766:	e406                	sd	ra,8(sp)
    80003768:	e022                	sd	s0,0(sp)
    8000376a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000376c:	4639                	li	a2,14
    8000376e:	e26fd0ef          	jal	80000d94 <strncmp>
}
    80003772:	60a2                	ld	ra,8(sp)
    80003774:	6402                	ld	s0,0(sp)
    80003776:	0141                	addi	sp,sp,16
    80003778:	8082                	ret

000000008000377a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000377a:	7139                	addi	sp,sp,-64
    8000377c:	fc06                	sd	ra,56(sp)
    8000377e:	f822                	sd	s0,48(sp)
    80003780:	f426                	sd	s1,40(sp)
    80003782:	f04a                	sd	s2,32(sp)
    80003784:	ec4e                	sd	s3,24(sp)
    80003786:	e852                	sd	s4,16(sp)
    80003788:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000378a:	04451703          	lh	a4,68(a0)
    8000378e:	4785                	li	a5,1
    80003790:	00f71a63          	bne	a4,a5,800037a4 <dirlookup+0x2a>
    80003794:	892a                	mv	s2,a0
    80003796:	89ae                	mv	s3,a1
    80003798:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000379a:	457c                	lw	a5,76(a0)
    8000379c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000379e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800037a0:	e39d                	bnez	a5,800037c6 <dirlookup+0x4c>
    800037a2:	a095                	j	80003806 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    800037a4:	00004517          	auipc	a0,0x4
    800037a8:	dfc50513          	addi	a0,a0,-516 # 800075a0 <etext+0x5a0>
    800037ac:	fe9fc0ef          	jal	80000794 <panic>
      panic("dirlookup read");
    800037b0:	00004517          	auipc	a0,0x4
    800037b4:	e0850513          	addi	a0,a0,-504 # 800075b8 <etext+0x5b8>
    800037b8:	fddfc0ef          	jal	80000794 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800037bc:	24c1                	addiw	s1,s1,16
    800037be:	04c92783          	lw	a5,76(s2)
    800037c2:	04f4f163          	bgeu	s1,a5,80003804 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800037c6:	4741                	li	a4,16
    800037c8:	86a6                	mv	a3,s1
    800037ca:	fc040613          	addi	a2,s0,-64
    800037ce:	4581                	li	a1,0
    800037d0:	854a                	mv	a0,s2
    800037d2:	d89ff0ef          	jal	8000355a <readi>
    800037d6:	47c1                	li	a5,16
    800037d8:	fcf51ce3          	bne	a0,a5,800037b0 <dirlookup+0x36>
    if(de.inum == 0)
    800037dc:	fc045783          	lhu	a5,-64(s0)
    800037e0:	dff1                	beqz	a5,800037bc <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    800037e2:	fc240593          	addi	a1,s0,-62
    800037e6:	854e                	mv	a0,s3
    800037e8:	f7dff0ef          	jal	80003764 <namecmp>
    800037ec:	f961                	bnez	a0,800037bc <dirlookup+0x42>
      if(poff)
    800037ee:	000a0463          	beqz	s4,800037f6 <dirlookup+0x7c>
        *poff = off;
    800037f2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800037f6:	fc045583          	lhu	a1,-64(s0)
    800037fa:	00092503          	lw	a0,0(s2)
    800037fe:	829ff0ef          	jal	80003026 <iget>
    80003802:	a011                	j	80003806 <dirlookup+0x8c>
  return 0;
    80003804:	4501                	li	a0,0
}
    80003806:	70e2                	ld	ra,56(sp)
    80003808:	7442                	ld	s0,48(sp)
    8000380a:	74a2                	ld	s1,40(sp)
    8000380c:	7902                	ld	s2,32(sp)
    8000380e:	69e2                	ld	s3,24(sp)
    80003810:	6a42                	ld	s4,16(sp)
    80003812:	6121                	addi	sp,sp,64
    80003814:	8082                	ret

0000000080003816 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003816:	711d                	addi	sp,sp,-96
    80003818:	ec86                	sd	ra,88(sp)
    8000381a:	e8a2                	sd	s0,80(sp)
    8000381c:	e4a6                	sd	s1,72(sp)
    8000381e:	e0ca                	sd	s2,64(sp)
    80003820:	fc4e                	sd	s3,56(sp)
    80003822:	f852                	sd	s4,48(sp)
    80003824:	f456                	sd	s5,40(sp)
    80003826:	f05a                	sd	s6,32(sp)
    80003828:	ec5e                	sd	s7,24(sp)
    8000382a:	e862                	sd	s8,16(sp)
    8000382c:	e466                	sd	s9,8(sp)
    8000382e:	1080                	addi	s0,sp,96
    80003830:	84aa                	mv	s1,a0
    80003832:	8b2e                	mv	s6,a1
    80003834:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003836:	00054703          	lbu	a4,0(a0)
    8000383a:	02f00793          	li	a5,47
    8000383e:	00f70e63          	beq	a4,a5,8000385a <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003842:	8b0fe0ef          	jal	800018f2 <myproc>
    80003846:	15053503          	ld	a0,336(a0)
    8000384a:	a87ff0ef          	jal	800032d0 <idup>
    8000384e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003850:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003854:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003856:	4b85                	li	s7,1
    80003858:	a871                	j	800038f4 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    8000385a:	4585                	li	a1,1
    8000385c:	4505                	li	a0,1
    8000385e:	fc8ff0ef          	jal	80003026 <iget>
    80003862:	8a2a                	mv	s4,a0
    80003864:	b7f5                	j	80003850 <namex+0x3a>
      iunlockput(ip);
    80003866:	8552                	mv	a0,s4
    80003868:	ca9ff0ef          	jal	80003510 <iunlockput>
      return 0;
    8000386c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000386e:	8552                	mv	a0,s4
    80003870:	60e6                	ld	ra,88(sp)
    80003872:	6446                	ld	s0,80(sp)
    80003874:	64a6                	ld	s1,72(sp)
    80003876:	6906                	ld	s2,64(sp)
    80003878:	79e2                	ld	s3,56(sp)
    8000387a:	7a42                	ld	s4,48(sp)
    8000387c:	7aa2                	ld	s5,40(sp)
    8000387e:	7b02                	ld	s6,32(sp)
    80003880:	6be2                	ld	s7,24(sp)
    80003882:	6c42                	ld	s8,16(sp)
    80003884:	6ca2                	ld	s9,8(sp)
    80003886:	6125                	addi	sp,sp,96
    80003888:	8082                	ret
      iunlock(ip);
    8000388a:	8552                	mv	a0,s4
    8000388c:	b29ff0ef          	jal	800033b4 <iunlock>
      return ip;
    80003890:	bff9                	j	8000386e <namex+0x58>
      iunlockput(ip);
    80003892:	8552                	mv	a0,s4
    80003894:	c7dff0ef          	jal	80003510 <iunlockput>
      return 0;
    80003898:	8a4e                	mv	s4,s3
    8000389a:	bfd1                	j	8000386e <namex+0x58>
  len = path - s;
    8000389c:	40998633          	sub	a2,s3,s1
    800038a0:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800038a4:	099c5063          	bge	s8,s9,80003924 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    800038a8:	4639                	li	a2,14
    800038aa:	85a6                	mv	a1,s1
    800038ac:	8556                	mv	a0,s5
    800038ae:	c76fd0ef          	jal	80000d24 <memmove>
    800038b2:	84ce                	mv	s1,s3
  while(*path == '/')
    800038b4:	0004c783          	lbu	a5,0(s1)
    800038b8:	01279763          	bne	a5,s2,800038c6 <namex+0xb0>
    path++;
    800038bc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800038be:	0004c783          	lbu	a5,0(s1)
    800038c2:	ff278de3          	beq	a5,s2,800038bc <namex+0xa6>
    ilock(ip);
    800038c6:	8552                	mv	a0,s4
    800038c8:	a3fff0ef          	jal	80003306 <ilock>
    if(ip->type != T_DIR){
    800038cc:	044a1783          	lh	a5,68(s4)
    800038d0:	f9779be3          	bne	a5,s7,80003866 <namex+0x50>
    if(nameiparent && *path == '\0'){
    800038d4:	000b0563          	beqz	s6,800038de <namex+0xc8>
    800038d8:	0004c783          	lbu	a5,0(s1)
    800038dc:	d7dd                	beqz	a5,8000388a <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    800038de:	4601                	li	a2,0
    800038e0:	85d6                	mv	a1,s5
    800038e2:	8552                	mv	a0,s4
    800038e4:	e97ff0ef          	jal	8000377a <dirlookup>
    800038e8:	89aa                	mv	s3,a0
    800038ea:	d545                	beqz	a0,80003892 <namex+0x7c>
    iunlockput(ip);
    800038ec:	8552                	mv	a0,s4
    800038ee:	c23ff0ef          	jal	80003510 <iunlockput>
    ip = next;
    800038f2:	8a4e                	mv	s4,s3
  while(*path == '/')
    800038f4:	0004c783          	lbu	a5,0(s1)
    800038f8:	01279763          	bne	a5,s2,80003906 <namex+0xf0>
    path++;
    800038fc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800038fe:	0004c783          	lbu	a5,0(s1)
    80003902:	ff278de3          	beq	a5,s2,800038fc <namex+0xe6>
  if(*path == 0)
    80003906:	cb8d                	beqz	a5,80003938 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003908:	0004c783          	lbu	a5,0(s1)
    8000390c:	89a6                	mv	s3,s1
  len = path - s;
    8000390e:	4c81                	li	s9,0
    80003910:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003912:	01278963          	beq	a5,s2,80003924 <namex+0x10e>
    80003916:	d3d9                	beqz	a5,8000389c <namex+0x86>
    path++;
    80003918:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000391a:	0009c783          	lbu	a5,0(s3)
    8000391e:	ff279ce3          	bne	a5,s2,80003916 <namex+0x100>
    80003922:	bfad                	j	8000389c <namex+0x86>
    memmove(name, s, len);
    80003924:	2601                	sext.w	a2,a2
    80003926:	85a6                	mv	a1,s1
    80003928:	8556                	mv	a0,s5
    8000392a:	bfafd0ef          	jal	80000d24 <memmove>
    name[len] = 0;
    8000392e:	9cd6                	add	s9,s9,s5
    80003930:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003934:	84ce                	mv	s1,s3
    80003936:	bfbd                	j	800038b4 <namex+0x9e>
  if(nameiparent){
    80003938:	f20b0be3          	beqz	s6,8000386e <namex+0x58>
    iput(ip);
    8000393c:	8552                	mv	a0,s4
    8000393e:	b4bff0ef          	jal	80003488 <iput>
    return 0;
    80003942:	4a01                	li	s4,0
    80003944:	b72d                	j	8000386e <namex+0x58>

0000000080003946 <dirlink>:
{
    80003946:	7139                	addi	sp,sp,-64
    80003948:	fc06                	sd	ra,56(sp)
    8000394a:	f822                	sd	s0,48(sp)
    8000394c:	f04a                	sd	s2,32(sp)
    8000394e:	ec4e                	sd	s3,24(sp)
    80003950:	e852                	sd	s4,16(sp)
    80003952:	0080                	addi	s0,sp,64
    80003954:	892a                	mv	s2,a0
    80003956:	8a2e                	mv	s4,a1
    80003958:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000395a:	4601                	li	a2,0
    8000395c:	e1fff0ef          	jal	8000377a <dirlookup>
    80003960:	e535                	bnez	a0,800039cc <dirlink+0x86>
    80003962:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003964:	04c92483          	lw	s1,76(s2)
    80003968:	c48d                	beqz	s1,80003992 <dirlink+0x4c>
    8000396a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000396c:	4741                	li	a4,16
    8000396e:	86a6                	mv	a3,s1
    80003970:	fc040613          	addi	a2,s0,-64
    80003974:	4581                	li	a1,0
    80003976:	854a                	mv	a0,s2
    80003978:	be3ff0ef          	jal	8000355a <readi>
    8000397c:	47c1                	li	a5,16
    8000397e:	04f51b63          	bne	a0,a5,800039d4 <dirlink+0x8e>
    if(de.inum == 0)
    80003982:	fc045783          	lhu	a5,-64(s0)
    80003986:	c791                	beqz	a5,80003992 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003988:	24c1                	addiw	s1,s1,16
    8000398a:	04c92783          	lw	a5,76(s2)
    8000398e:	fcf4efe3          	bltu	s1,a5,8000396c <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003992:	4639                	li	a2,14
    80003994:	85d2                	mv	a1,s4
    80003996:	fc240513          	addi	a0,s0,-62
    8000399a:	c30fd0ef          	jal	80000dca <strncpy>
  de.inum = inum;
    8000399e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800039a2:	4741                	li	a4,16
    800039a4:	86a6                	mv	a3,s1
    800039a6:	fc040613          	addi	a2,s0,-64
    800039aa:	4581                	li	a1,0
    800039ac:	854a                	mv	a0,s2
    800039ae:	ca9ff0ef          	jal	80003656 <writei>
    800039b2:	1541                	addi	a0,a0,-16
    800039b4:	00a03533          	snez	a0,a0
    800039b8:	40a00533          	neg	a0,a0
    800039bc:	74a2                	ld	s1,40(sp)
}
    800039be:	70e2                	ld	ra,56(sp)
    800039c0:	7442                	ld	s0,48(sp)
    800039c2:	7902                	ld	s2,32(sp)
    800039c4:	69e2                	ld	s3,24(sp)
    800039c6:	6a42                	ld	s4,16(sp)
    800039c8:	6121                	addi	sp,sp,64
    800039ca:	8082                	ret
    iput(ip);
    800039cc:	abdff0ef          	jal	80003488 <iput>
    return -1;
    800039d0:	557d                	li	a0,-1
    800039d2:	b7f5                	j	800039be <dirlink+0x78>
      panic("dirlink read");
    800039d4:	00004517          	auipc	a0,0x4
    800039d8:	bf450513          	addi	a0,a0,-1036 # 800075c8 <etext+0x5c8>
    800039dc:	db9fc0ef          	jal	80000794 <panic>

00000000800039e0 <namei>:

struct inode*
namei(char *path)
{
    800039e0:	1101                	addi	sp,sp,-32
    800039e2:	ec06                	sd	ra,24(sp)
    800039e4:	e822                	sd	s0,16(sp)
    800039e6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800039e8:	fe040613          	addi	a2,s0,-32
    800039ec:	4581                	li	a1,0
    800039ee:	e29ff0ef          	jal	80003816 <namex>
}
    800039f2:	60e2                	ld	ra,24(sp)
    800039f4:	6442                	ld	s0,16(sp)
    800039f6:	6105                	addi	sp,sp,32
    800039f8:	8082                	ret

00000000800039fa <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800039fa:	1141                	addi	sp,sp,-16
    800039fc:	e406                	sd	ra,8(sp)
    800039fe:	e022                	sd	s0,0(sp)
    80003a00:	0800                	addi	s0,sp,16
    80003a02:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003a04:	4585                	li	a1,1
    80003a06:	e11ff0ef          	jal	80003816 <namex>
}
    80003a0a:	60a2                	ld	ra,8(sp)
    80003a0c:	6402                	ld	s0,0(sp)
    80003a0e:	0141                	addi	sp,sp,16
    80003a10:	8082                	ret

0000000080003a12 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003a12:	1101                	addi	sp,sp,-32
    80003a14:	ec06                	sd	ra,24(sp)
    80003a16:	e822                	sd	s0,16(sp)
    80003a18:	e426                	sd	s1,8(sp)
    80003a1a:	e04a                	sd	s2,0(sp)
    80003a1c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003a1e:	0001c917          	auipc	s2,0x1c
    80003a22:	4f290913          	addi	s2,s2,1266 # 8001ff10 <log>
    80003a26:	01892583          	lw	a1,24(s2)
    80003a2a:	02892503          	lw	a0,40(s2)
    80003a2e:	9a0ff0ef          	jal	80002bce <bread>
    80003a32:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003a34:	02c92603          	lw	a2,44(s2)
    80003a38:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003a3a:	00c05f63          	blez	a2,80003a58 <write_head+0x46>
    80003a3e:	0001c717          	auipc	a4,0x1c
    80003a42:	50270713          	addi	a4,a4,1282 # 8001ff40 <log+0x30>
    80003a46:	87aa                	mv	a5,a0
    80003a48:	060a                	slli	a2,a2,0x2
    80003a4a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003a4c:	4314                	lw	a3,0(a4)
    80003a4e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003a50:	0711                	addi	a4,a4,4
    80003a52:	0791                	addi	a5,a5,4
    80003a54:	fec79ce3          	bne	a5,a2,80003a4c <write_head+0x3a>
  }
  bwrite(buf);
    80003a58:	8526                	mv	a0,s1
    80003a5a:	a4aff0ef          	jal	80002ca4 <bwrite>
  brelse(buf);
    80003a5e:	8526                	mv	a0,s1
    80003a60:	a76ff0ef          	jal	80002cd6 <brelse>
}
    80003a64:	60e2                	ld	ra,24(sp)
    80003a66:	6442                	ld	s0,16(sp)
    80003a68:	64a2                	ld	s1,8(sp)
    80003a6a:	6902                	ld	s2,0(sp)
    80003a6c:	6105                	addi	sp,sp,32
    80003a6e:	8082                	ret

0000000080003a70 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a70:	0001c797          	auipc	a5,0x1c
    80003a74:	4cc7a783          	lw	a5,1228(a5) # 8001ff3c <log+0x2c>
    80003a78:	08f05f63          	blez	a5,80003b16 <install_trans+0xa6>
{
    80003a7c:	7139                	addi	sp,sp,-64
    80003a7e:	fc06                	sd	ra,56(sp)
    80003a80:	f822                	sd	s0,48(sp)
    80003a82:	f426                	sd	s1,40(sp)
    80003a84:	f04a                	sd	s2,32(sp)
    80003a86:	ec4e                	sd	s3,24(sp)
    80003a88:	e852                	sd	s4,16(sp)
    80003a8a:	e456                	sd	s5,8(sp)
    80003a8c:	e05a                	sd	s6,0(sp)
    80003a8e:	0080                	addi	s0,sp,64
    80003a90:	8b2a                	mv	s6,a0
    80003a92:	0001ca97          	auipc	s5,0x1c
    80003a96:	4aea8a93          	addi	s5,s5,1198 # 8001ff40 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a9a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003a9c:	0001c997          	auipc	s3,0x1c
    80003aa0:	47498993          	addi	s3,s3,1140 # 8001ff10 <log>
    80003aa4:	a829                	j	80003abe <install_trans+0x4e>
    brelse(lbuf);
    80003aa6:	854a                	mv	a0,s2
    80003aa8:	a2eff0ef          	jal	80002cd6 <brelse>
    brelse(dbuf);
    80003aac:	8526                	mv	a0,s1
    80003aae:	a28ff0ef          	jal	80002cd6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ab2:	2a05                	addiw	s4,s4,1
    80003ab4:	0a91                	addi	s5,s5,4
    80003ab6:	02c9a783          	lw	a5,44(s3)
    80003aba:	04fa5463          	bge	s4,a5,80003b02 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003abe:	0189a583          	lw	a1,24(s3)
    80003ac2:	014585bb          	addw	a1,a1,s4
    80003ac6:	2585                	addiw	a1,a1,1
    80003ac8:	0289a503          	lw	a0,40(s3)
    80003acc:	902ff0ef          	jal	80002bce <bread>
    80003ad0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003ad2:	000aa583          	lw	a1,0(s5)
    80003ad6:	0289a503          	lw	a0,40(s3)
    80003ada:	8f4ff0ef          	jal	80002bce <bread>
    80003ade:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003ae0:	40000613          	li	a2,1024
    80003ae4:	05890593          	addi	a1,s2,88
    80003ae8:	05850513          	addi	a0,a0,88
    80003aec:	a38fd0ef          	jal	80000d24 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003af0:	8526                	mv	a0,s1
    80003af2:	9b2ff0ef          	jal	80002ca4 <bwrite>
    if(recovering == 0)
    80003af6:	fa0b18e3          	bnez	s6,80003aa6 <install_trans+0x36>
      bunpin(dbuf);
    80003afa:	8526                	mv	a0,s1
    80003afc:	a96ff0ef          	jal	80002d92 <bunpin>
    80003b00:	b75d                	j	80003aa6 <install_trans+0x36>
}
    80003b02:	70e2                	ld	ra,56(sp)
    80003b04:	7442                	ld	s0,48(sp)
    80003b06:	74a2                	ld	s1,40(sp)
    80003b08:	7902                	ld	s2,32(sp)
    80003b0a:	69e2                	ld	s3,24(sp)
    80003b0c:	6a42                	ld	s4,16(sp)
    80003b0e:	6aa2                	ld	s5,8(sp)
    80003b10:	6b02                	ld	s6,0(sp)
    80003b12:	6121                	addi	sp,sp,64
    80003b14:	8082                	ret
    80003b16:	8082                	ret

0000000080003b18 <initlog>:
{
    80003b18:	7179                	addi	sp,sp,-48
    80003b1a:	f406                	sd	ra,40(sp)
    80003b1c:	f022                	sd	s0,32(sp)
    80003b1e:	ec26                	sd	s1,24(sp)
    80003b20:	e84a                	sd	s2,16(sp)
    80003b22:	e44e                	sd	s3,8(sp)
    80003b24:	1800                	addi	s0,sp,48
    80003b26:	892a                	mv	s2,a0
    80003b28:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003b2a:	0001c497          	auipc	s1,0x1c
    80003b2e:	3e648493          	addi	s1,s1,998 # 8001ff10 <log>
    80003b32:	00004597          	auipc	a1,0x4
    80003b36:	aa658593          	addi	a1,a1,-1370 # 800075d8 <etext+0x5d8>
    80003b3a:	8526                	mv	a0,s1
    80003b3c:	838fd0ef          	jal	80000b74 <initlock>
  log.start = sb->logstart;
    80003b40:	0149a583          	lw	a1,20(s3)
    80003b44:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003b46:	0109a783          	lw	a5,16(s3)
    80003b4a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003b4c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003b50:	854a                	mv	a0,s2
    80003b52:	87cff0ef          	jal	80002bce <bread>
  log.lh.n = lh->n;
    80003b56:	4d30                	lw	a2,88(a0)
    80003b58:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003b5a:	00c05f63          	blez	a2,80003b78 <initlog+0x60>
    80003b5e:	87aa                	mv	a5,a0
    80003b60:	0001c717          	auipc	a4,0x1c
    80003b64:	3e070713          	addi	a4,a4,992 # 8001ff40 <log+0x30>
    80003b68:	060a                	slli	a2,a2,0x2
    80003b6a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003b6c:	4ff4                	lw	a3,92(a5)
    80003b6e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003b70:	0791                	addi	a5,a5,4
    80003b72:	0711                	addi	a4,a4,4
    80003b74:	fec79ce3          	bne	a5,a2,80003b6c <initlog+0x54>
  brelse(buf);
    80003b78:	95eff0ef          	jal	80002cd6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003b7c:	4505                	li	a0,1
    80003b7e:	ef3ff0ef          	jal	80003a70 <install_trans>
  log.lh.n = 0;
    80003b82:	0001c797          	auipc	a5,0x1c
    80003b86:	3a07ad23          	sw	zero,954(a5) # 8001ff3c <log+0x2c>
  write_head(); // clear the log
    80003b8a:	e89ff0ef          	jal	80003a12 <write_head>
}
    80003b8e:	70a2                	ld	ra,40(sp)
    80003b90:	7402                	ld	s0,32(sp)
    80003b92:	64e2                	ld	s1,24(sp)
    80003b94:	6942                	ld	s2,16(sp)
    80003b96:	69a2                	ld	s3,8(sp)
    80003b98:	6145                	addi	sp,sp,48
    80003b9a:	8082                	ret

0000000080003b9c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003b9c:	1101                	addi	sp,sp,-32
    80003b9e:	ec06                	sd	ra,24(sp)
    80003ba0:	e822                	sd	s0,16(sp)
    80003ba2:	e426                	sd	s1,8(sp)
    80003ba4:	e04a                	sd	s2,0(sp)
    80003ba6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003ba8:	0001c517          	auipc	a0,0x1c
    80003bac:	36850513          	addi	a0,a0,872 # 8001ff10 <log>
    80003bb0:	844fd0ef          	jal	80000bf4 <acquire>
  while(1){
    if(log.committing){
    80003bb4:	0001c497          	auipc	s1,0x1c
    80003bb8:	35c48493          	addi	s1,s1,860 # 8001ff10 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003bbc:	4979                	li	s2,30
    80003bbe:	a029                	j	80003bc8 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003bc0:	85a6                	mv	a1,s1
    80003bc2:	8526                	mv	a0,s1
    80003bc4:	916fe0ef          	jal	80001cda <sleep>
    if(log.committing){
    80003bc8:	50dc                	lw	a5,36(s1)
    80003bca:	fbfd                	bnez	a5,80003bc0 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003bcc:	5098                	lw	a4,32(s1)
    80003bce:	2705                	addiw	a4,a4,1
    80003bd0:	0027179b          	slliw	a5,a4,0x2
    80003bd4:	9fb9                	addw	a5,a5,a4
    80003bd6:	0017979b          	slliw	a5,a5,0x1
    80003bda:	54d4                	lw	a3,44(s1)
    80003bdc:	9fb5                	addw	a5,a5,a3
    80003bde:	00f95763          	bge	s2,a5,80003bec <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003be2:	85a6                	mv	a1,s1
    80003be4:	8526                	mv	a0,s1
    80003be6:	8f4fe0ef          	jal	80001cda <sleep>
    80003bea:	bff9                	j	80003bc8 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003bec:	0001c517          	auipc	a0,0x1c
    80003bf0:	32450513          	addi	a0,a0,804 # 8001ff10 <log>
    80003bf4:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003bf6:	896fd0ef          	jal	80000c8c <release>
      break;
    }
  }
}
    80003bfa:	60e2                	ld	ra,24(sp)
    80003bfc:	6442                	ld	s0,16(sp)
    80003bfe:	64a2                	ld	s1,8(sp)
    80003c00:	6902                	ld	s2,0(sp)
    80003c02:	6105                	addi	sp,sp,32
    80003c04:	8082                	ret

0000000080003c06 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003c06:	7139                	addi	sp,sp,-64
    80003c08:	fc06                	sd	ra,56(sp)
    80003c0a:	f822                	sd	s0,48(sp)
    80003c0c:	f426                	sd	s1,40(sp)
    80003c0e:	f04a                	sd	s2,32(sp)
    80003c10:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003c12:	0001c497          	auipc	s1,0x1c
    80003c16:	2fe48493          	addi	s1,s1,766 # 8001ff10 <log>
    80003c1a:	8526                	mv	a0,s1
    80003c1c:	fd9fc0ef          	jal	80000bf4 <acquire>
  log.outstanding -= 1;
    80003c20:	509c                	lw	a5,32(s1)
    80003c22:	37fd                	addiw	a5,a5,-1
    80003c24:	0007891b          	sext.w	s2,a5
    80003c28:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003c2a:	50dc                	lw	a5,36(s1)
    80003c2c:	ef9d                	bnez	a5,80003c6a <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003c2e:	04091763          	bnez	s2,80003c7c <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003c32:	0001c497          	auipc	s1,0x1c
    80003c36:	2de48493          	addi	s1,s1,734 # 8001ff10 <log>
    80003c3a:	4785                	li	a5,1
    80003c3c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003c3e:	8526                	mv	a0,s1
    80003c40:	84cfd0ef          	jal	80000c8c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003c44:	54dc                	lw	a5,44(s1)
    80003c46:	04f04b63          	bgtz	a5,80003c9c <end_op+0x96>
    acquire(&log.lock);
    80003c4a:	0001c497          	auipc	s1,0x1c
    80003c4e:	2c648493          	addi	s1,s1,710 # 8001ff10 <log>
    80003c52:	8526                	mv	a0,s1
    80003c54:	fa1fc0ef          	jal	80000bf4 <acquire>
    log.committing = 0;
    80003c58:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003c5c:	8526                	mv	a0,s1
    80003c5e:	8c8fe0ef          	jal	80001d26 <wakeup>
    release(&log.lock);
    80003c62:	8526                	mv	a0,s1
    80003c64:	828fd0ef          	jal	80000c8c <release>
}
    80003c68:	a025                	j	80003c90 <end_op+0x8a>
    80003c6a:	ec4e                	sd	s3,24(sp)
    80003c6c:	e852                	sd	s4,16(sp)
    80003c6e:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003c70:	00004517          	auipc	a0,0x4
    80003c74:	97050513          	addi	a0,a0,-1680 # 800075e0 <etext+0x5e0>
    80003c78:	b1dfc0ef          	jal	80000794 <panic>
    wakeup(&log);
    80003c7c:	0001c497          	auipc	s1,0x1c
    80003c80:	29448493          	addi	s1,s1,660 # 8001ff10 <log>
    80003c84:	8526                	mv	a0,s1
    80003c86:	8a0fe0ef          	jal	80001d26 <wakeup>
  release(&log.lock);
    80003c8a:	8526                	mv	a0,s1
    80003c8c:	800fd0ef          	jal	80000c8c <release>
}
    80003c90:	70e2                	ld	ra,56(sp)
    80003c92:	7442                	ld	s0,48(sp)
    80003c94:	74a2                	ld	s1,40(sp)
    80003c96:	7902                	ld	s2,32(sp)
    80003c98:	6121                	addi	sp,sp,64
    80003c9a:	8082                	ret
    80003c9c:	ec4e                	sd	s3,24(sp)
    80003c9e:	e852                	sd	s4,16(sp)
    80003ca0:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ca2:	0001ca97          	auipc	s5,0x1c
    80003ca6:	29ea8a93          	addi	s5,s5,670 # 8001ff40 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003caa:	0001ca17          	auipc	s4,0x1c
    80003cae:	266a0a13          	addi	s4,s4,614 # 8001ff10 <log>
    80003cb2:	018a2583          	lw	a1,24(s4)
    80003cb6:	012585bb          	addw	a1,a1,s2
    80003cba:	2585                	addiw	a1,a1,1
    80003cbc:	028a2503          	lw	a0,40(s4)
    80003cc0:	f0ffe0ef          	jal	80002bce <bread>
    80003cc4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003cc6:	000aa583          	lw	a1,0(s5)
    80003cca:	028a2503          	lw	a0,40(s4)
    80003cce:	f01fe0ef          	jal	80002bce <bread>
    80003cd2:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003cd4:	40000613          	li	a2,1024
    80003cd8:	05850593          	addi	a1,a0,88
    80003cdc:	05848513          	addi	a0,s1,88
    80003ce0:	844fd0ef          	jal	80000d24 <memmove>
    bwrite(to);  // write the log
    80003ce4:	8526                	mv	a0,s1
    80003ce6:	fbffe0ef          	jal	80002ca4 <bwrite>
    brelse(from);
    80003cea:	854e                	mv	a0,s3
    80003cec:	febfe0ef          	jal	80002cd6 <brelse>
    brelse(to);
    80003cf0:	8526                	mv	a0,s1
    80003cf2:	fe5fe0ef          	jal	80002cd6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003cf6:	2905                	addiw	s2,s2,1
    80003cf8:	0a91                	addi	s5,s5,4
    80003cfa:	02ca2783          	lw	a5,44(s4)
    80003cfe:	faf94ae3          	blt	s2,a5,80003cb2 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003d02:	d11ff0ef          	jal	80003a12 <write_head>
    install_trans(0); // Now install writes to home locations
    80003d06:	4501                	li	a0,0
    80003d08:	d69ff0ef          	jal	80003a70 <install_trans>
    log.lh.n = 0;
    80003d0c:	0001c797          	auipc	a5,0x1c
    80003d10:	2207a823          	sw	zero,560(a5) # 8001ff3c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003d14:	cffff0ef          	jal	80003a12 <write_head>
    80003d18:	69e2                	ld	s3,24(sp)
    80003d1a:	6a42                	ld	s4,16(sp)
    80003d1c:	6aa2                	ld	s5,8(sp)
    80003d1e:	b735                	j	80003c4a <end_op+0x44>

0000000080003d20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003d20:	1101                	addi	sp,sp,-32
    80003d22:	ec06                	sd	ra,24(sp)
    80003d24:	e822                	sd	s0,16(sp)
    80003d26:	e426                	sd	s1,8(sp)
    80003d28:	e04a                	sd	s2,0(sp)
    80003d2a:	1000                	addi	s0,sp,32
    80003d2c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003d2e:	0001c917          	auipc	s2,0x1c
    80003d32:	1e290913          	addi	s2,s2,482 # 8001ff10 <log>
    80003d36:	854a                	mv	a0,s2
    80003d38:	ebdfc0ef          	jal	80000bf4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003d3c:	02c92603          	lw	a2,44(s2)
    80003d40:	47f5                	li	a5,29
    80003d42:	06c7c363          	blt	a5,a2,80003da8 <log_write+0x88>
    80003d46:	0001c797          	auipc	a5,0x1c
    80003d4a:	1e67a783          	lw	a5,486(a5) # 8001ff2c <log+0x1c>
    80003d4e:	37fd                	addiw	a5,a5,-1
    80003d50:	04f65c63          	bge	a2,a5,80003da8 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003d54:	0001c797          	auipc	a5,0x1c
    80003d58:	1dc7a783          	lw	a5,476(a5) # 8001ff30 <log+0x20>
    80003d5c:	04f05c63          	blez	a5,80003db4 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003d60:	4781                	li	a5,0
    80003d62:	04c05f63          	blez	a2,80003dc0 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003d66:	44cc                	lw	a1,12(s1)
    80003d68:	0001c717          	auipc	a4,0x1c
    80003d6c:	1d870713          	addi	a4,a4,472 # 8001ff40 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003d70:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003d72:	4314                	lw	a3,0(a4)
    80003d74:	04b68663          	beq	a3,a1,80003dc0 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003d78:	2785                	addiw	a5,a5,1
    80003d7a:	0711                	addi	a4,a4,4
    80003d7c:	fef61be3          	bne	a2,a5,80003d72 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003d80:	0621                	addi	a2,a2,8
    80003d82:	060a                	slli	a2,a2,0x2
    80003d84:	0001c797          	auipc	a5,0x1c
    80003d88:	18c78793          	addi	a5,a5,396 # 8001ff10 <log>
    80003d8c:	97b2                	add	a5,a5,a2
    80003d8e:	44d8                	lw	a4,12(s1)
    80003d90:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003d92:	8526                	mv	a0,s1
    80003d94:	fcbfe0ef          	jal	80002d5e <bpin>
    log.lh.n++;
    80003d98:	0001c717          	auipc	a4,0x1c
    80003d9c:	17870713          	addi	a4,a4,376 # 8001ff10 <log>
    80003da0:	575c                	lw	a5,44(a4)
    80003da2:	2785                	addiw	a5,a5,1
    80003da4:	d75c                	sw	a5,44(a4)
    80003da6:	a80d                	j	80003dd8 <log_write+0xb8>
    panic("too big a transaction");
    80003da8:	00004517          	auipc	a0,0x4
    80003dac:	84850513          	addi	a0,a0,-1976 # 800075f0 <etext+0x5f0>
    80003db0:	9e5fc0ef          	jal	80000794 <panic>
    panic("log_write outside of trans");
    80003db4:	00004517          	auipc	a0,0x4
    80003db8:	85450513          	addi	a0,a0,-1964 # 80007608 <etext+0x608>
    80003dbc:	9d9fc0ef          	jal	80000794 <panic>
  log.lh.block[i] = b->blockno;
    80003dc0:	00878693          	addi	a3,a5,8
    80003dc4:	068a                	slli	a3,a3,0x2
    80003dc6:	0001c717          	auipc	a4,0x1c
    80003dca:	14a70713          	addi	a4,a4,330 # 8001ff10 <log>
    80003dce:	9736                	add	a4,a4,a3
    80003dd0:	44d4                	lw	a3,12(s1)
    80003dd2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003dd4:	faf60fe3          	beq	a2,a5,80003d92 <log_write+0x72>
  }
  release(&log.lock);
    80003dd8:	0001c517          	auipc	a0,0x1c
    80003ddc:	13850513          	addi	a0,a0,312 # 8001ff10 <log>
    80003de0:	eadfc0ef          	jal	80000c8c <release>
}
    80003de4:	60e2                	ld	ra,24(sp)
    80003de6:	6442                	ld	s0,16(sp)
    80003de8:	64a2                	ld	s1,8(sp)
    80003dea:	6902                	ld	s2,0(sp)
    80003dec:	6105                	addi	sp,sp,32
    80003dee:	8082                	ret

0000000080003df0 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003df0:	1101                	addi	sp,sp,-32
    80003df2:	ec06                	sd	ra,24(sp)
    80003df4:	e822                	sd	s0,16(sp)
    80003df6:	e426                	sd	s1,8(sp)
    80003df8:	e04a                	sd	s2,0(sp)
    80003dfa:	1000                	addi	s0,sp,32
    80003dfc:	84aa                	mv	s1,a0
    80003dfe:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003e00:	00004597          	auipc	a1,0x4
    80003e04:	82858593          	addi	a1,a1,-2008 # 80007628 <etext+0x628>
    80003e08:	0521                	addi	a0,a0,8
    80003e0a:	d6bfc0ef          	jal	80000b74 <initlock>
  lk->name = name;
    80003e0e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003e12:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003e16:	0204a423          	sw	zero,40(s1)
}
    80003e1a:	60e2                	ld	ra,24(sp)
    80003e1c:	6442                	ld	s0,16(sp)
    80003e1e:	64a2                	ld	s1,8(sp)
    80003e20:	6902                	ld	s2,0(sp)
    80003e22:	6105                	addi	sp,sp,32
    80003e24:	8082                	ret

0000000080003e26 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003e26:	1101                	addi	sp,sp,-32
    80003e28:	ec06                	sd	ra,24(sp)
    80003e2a:	e822                	sd	s0,16(sp)
    80003e2c:	e426                	sd	s1,8(sp)
    80003e2e:	e04a                	sd	s2,0(sp)
    80003e30:	1000                	addi	s0,sp,32
    80003e32:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003e34:	00850913          	addi	s2,a0,8
    80003e38:	854a                	mv	a0,s2
    80003e3a:	dbbfc0ef          	jal	80000bf4 <acquire>
  while (lk->locked) {
    80003e3e:	409c                	lw	a5,0(s1)
    80003e40:	c799                	beqz	a5,80003e4e <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003e42:	85ca                	mv	a1,s2
    80003e44:	8526                	mv	a0,s1
    80003e46:	e95fd0ef          	jal	80001cda <sleep>
  while (lk->locked) {
    80003e4a:	409c                	lw	a5,0(s1)
    80003e4c:	fbfd                	bnez	a5,80003e42 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003e4e:	4785                	li	a5,1
    80003e50:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003e52:	aa1fd0ef          	jal	800018f2 <myproc>
    80003e56:	591c                	lw	a5,48(a0)
    80003e58:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003e5a:	854a                	mv	a0,s2
    80003e5c:	e31fc0ef          	jal	80000c8c <release>
}
    80003e60:	60e2                	ld	ra,24(sp)
    80003e62:	6442                	ld	s0,16(sp)
    80003e64:	64a2                	ld	s1,8(sp)
    80003e66:	6902                	ld	s2,0(sp)
    80003e68:	6105                	addi	sp,sp,32
    80003e6a:	8082                	ret

0000000080003e6c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003e6c:	1101                	addi	sp,sp,-32
    80003e6e:	ec06                	sd	ra,24(sp)
    80003e70:	e822                	sd	s0,16(sp)
    80003e72:	e426                	sd	s1,8(sp)
    80003e74:	e04a                	sd	s2,0(sp)
    80003e76:	1000                	addi	s0,sp,32
    80003e78:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003e7a:	00850913          	addi	s2,a0,8
    80003e7e:	854a                	mv	a0,s2
    80003e80:	d75fc0ef          	jal	80000bf4 <acquire>
  lk->locked = 0;
    80003e84:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003e88:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003e8c:	8526                	mv	a0,s1
    80003e8e:	e99fd0ef          	jal	80001d26 <wakeup>
  release(&lk->lk);
    80003e92:	854a                	mv	a0,s2
    80003e94:	df9fc0ef          	jal	80000c8c <release>
}
    80003e98:	60e2                	ld	ra,24(sp)
    80003e9a:	6442                	ld	s0,16(sp)
    80003e9c:	64a2                	ld	s1,8(sp)
    80003e9e:	6902                	ld	s2,0(sp)
    80003ea0:	6105                	addi	sp,sp,32
    80003ea2:	8082                	ret

0000000080003ea4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ea4:	7179                	addi	sp,sp,-48
    80003ea6:	f406                	sd	ra,40(sp)
    80003ea8:	f022                	sd	s0,32(sp)
    80003eaa:	ec26                	sd	s1,24(sp)
    80003eac:	e84a                	sd	s2,16(sp)
    80003eae:	1800                	addi	s0,sp,48
    80003eb0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003eb2:	00850913          	addi	s2,a0,8
    80003eb6:	854a                	mv	a0,s2
    80003eb8:	d3dfc0ef          	jal	80000bf4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ebc:	409c                	lw	a5,0(s1)
    80003ebe:	ef81                	bnez	a5,80003ed6 <holdingsleep+0x32>
    80003ec0:	4481                	li	s1,0
  release(&lk->lk);
    80003ec2:	854a                	mv	a0,s2
    80003ec4:	dc9fc0ef          	jal	80000c8c <release>
  return r;
}
    80003ec8:	8526                	mv	a0,s1
    80003eca:	70a2                	ld	ra,40(sp)
    80003ecc:	7402                	ld	s0,32(sp)
    80003ece:	64e2                	ld	s1,24(sp)
    80003ed0:	6942                	ld	s2,16(sp)
    80003ed2:	6145                	addi	sp,sp,48
    80003ed4:	8082                	ret
    80003ed6:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ed8:	0284a983          	lw	s3,40(s1)
    80003edc:	a17fd0ef          	jal	800018f2 <myproc>
    80003ee0:	5904                	lw	s1,48(a0)
    80003ee2:	413484b3          	sub	s1,s1,s3
    80003ee6:	0014b493          	seqz	s1,s1
    80003eea:	69a2                	ld	s3,8(sp)
    80003eec:	bfd9                	j	80003ec2 <holdingsleep+0x1e>

0000000080003eee <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003eee:	1141                	addi	sp,sp,-16
    80003ef0:	e406                	sd	ra,8(sp)
    80003ef2:	e022                	sd	s0,0(sp)
    80003ef4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ef6:	00003597          	auipc	a1,0x3
    80003efa:	74258593          	addi	a1,a1,1858 # 80007638 <etext+0x638>
    80003efe:	0001c517          	auipc	a0,0x1c
    80003f02:	15a50513          	addi	a0,a0,346 # 80020058 <ftable>
    80003f06:	c6ffc0ef          	jal	80000b74 <initlock>
}
    80003f0a:	60a2                	ld	ra,8(sp)
    80003f0c:	6402                	ld	s0,0(sp)
    80003f0e:	0141                	addi	sp,sp,16
    80003f10:	8082                	ret

0000000080003f12 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003f12:	1101                	addi	sp,sp,-32
    80003f14:	ec06                	sd	ra,24(sp)
    80003f16:	e822                	sd	s0,16(sp)
    80003f18:	e426                	sd	s1,8(sp)
    80003f1a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003f1c:	0001c517          	auipc	a0,0x1c
    80003f20:	13c50513          	addi	a0,a0,316 # 80020058 <ftable>
    80003f24:	cd1fc0ef          	jal	80000bf4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003f28:	0001c497          	auipc	s1,0x1c
    80003f2c:	14848493          	addi	s1,s1,328 # 80020070 <ftable+0x18>
    80003f30:	0001d717          	auipc	a4,0x1d
    80003f34:	0e070713          	addi	a4,a4,224 # 80021010 <disk>
    if(f->ref == 0){
    80003f38:	40dc                	lw	a5,4(s1)
    80003f3a:	cf89                	beqz	a5,80003f54 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003f3c:	02848493          	addi	s1,s1,40
    80003f40:	fee49ce3          	bne	s1,a4,80003f38 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003f44:	0001c517          	auipc	a0,0x1c
    80003f48:	11450513          	addi	a0,a0,276 # 80020058 <ftable>
    80003f4c:	d41fc0ef          	jal	80000c8c <release>
  return 0;
    80003f50:	4481                	li	s1,0
    80003f52:	a809                	j	80003f64 <filealloc+0x52>
      f->ref = 1;
    80003f54:	4785                	li	a5,1
    80003f56:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003f58:	0001c517          	auipc	a0,0x1c
    80003f5c:	10050513          	addi	a0,a0,256 # 80020058 <ftable>
    80003f60:	d2dfc0ef          	jal	80000c8c <release>
}
    80003f64:	8526                	mv	a0,s1
    80003f66:	60e2                	ld	ra,24(sp)
    80003f68:	6442                	ld	s0,16(sp)
    80003f6a:	64a2                	ld	s1,8(sp)
    80003f6c:	6105                	addi	sp,sp,32
    80003f6e:	8082                	ret

0000000080003f70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003f70:	1101                	addi	sp,sp,-32
    80003f72:	ec06                	sd	ra,24(sp)
    80003f74:	e822                	sd	s0,16(sp)
    80003f76:	e426                	sd	s1,8(sp)
    80003f78:	1000                	addi	s0,sp,32
    80003f7a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003f7c:	0001c517          	auipc	a0,0x1c
    80003f80:	0dc50513          	addi	a0,a0,220 # 80020058 <ftable>
    80003f84:	c71fc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    80003f88:	40dc                	lw	a5,4(s1)
    80003f8a:	02f05063          	blez	a5,80003faa <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003f8e:	2785                	addiw	a5,a5,1
    80003f90:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003f92:	0001c517          	auipc	a0,0x1c
    80003f96:	0c650513          	addi	a0,a0,198 # 80020058 <ftable>
    80003f9a:	cf3fc0ef          	jal	80000c8c <release>
  return f;
}
    80003f9e:	8526                	mv	a0,s1
    80003fa0:	60e2                	ld	ra,24(sp)
    80003fa2:	6442                	ld	s0,16(sp)
    80003fa4:	64a2                	ld	s1,8(sp)
    80003fa6:	6105                	addi	sp,sp,32
    80003fa8:	8082                	ret
    panic("filedup");
    80003faa:	00003517          	auipc	a0,0x3
    80003fae:	69650513          	addi	a0,a0,1686 # 80007640 <etext+0x640>
    80003fb2:	fe2fc0ef          	jal	80000794 <panic>

0000000080003fb6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003fb6:	7139                	addi	sp,sp,-64
    80003fb8:	fc06                	sd	ra,56(sp)
    80003fba:	f822                	sd	s0,48(sp)
    80003fbc:	f426                	sd	s1,40(sp)
    80003fbe:	0080                	addi	s0,sp,64
    80003fc0:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003fc2:	0001c517          	auipc	a0,0x1c
    80003fc6:	09650513          	addi	a0,a0,150 # 80020058 <ftable>
    80003fca:	c2bfc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    80003fce:	40dc                	lw	a5,4(s1)
    80003fd0:	04f05a63          	blez	a5,80004024 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003fd4:	37fd                	addiw	a5,a5,-1
    80003fd6:	0007871b          	sext.w	a4,a5
    80003fda:	c0dc                	sw	a5,4(s1)
    80003fdc:	04e04e63          	bgtz	a4,80004038 <fileclose+0x82>
    80003fe0:	f04a                	sd	s2,32(sp)
    80003fe2:	ec4e                	sd	s3,24(sp)
    80003fe4:	e852                	sd	s4,16(sp)
    80003fe6:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003fe8:	0004a903          	lw	s2,0(s1)
    80003fec:	0094ca83          	lbu	s5,9(s1)
    80003ff0:	0104ba03          	ld	s4,16(s1)
    80003ff4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ff8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ffc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004000:	0001c517          	auipc	a0,0x1c
    80004004:	05850513          	addi	a0,a0,88 # 80020058 <ftable>
    80004008:	c85fc0ef          	jal	80000c8c <release>

  if(ff.type == FD_PIPE){
    8000400c:	4785                	li	a5,1
    8000400e:	04f90063          	beq	s2,a5,8000404e <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004012:	3979                	addiw	s2,s2,-2
    80004014:	4785                	li	a5,1
    80004016:	0527f563          	bgeu	a5,s2,80004060 <fileclose+0xaa>
    8000401a:	7902                	ld	s2,32(sp)
    8000401c:	69e2                	ld	s3,24(sp)
    8000401e:	6a42                	ld	s4,16(sp)
    80004020:	6aa2                	ld	s5,8(sp)
    80004022:	a00d                	j	80004044 <fileclose+0x8e>
    80004024:	f04a                	sd	s2,32(sp)
    80004026:	ec4e                	sd	s3,24(sp)
    80004028:	e852                	sd	s4,16(sp)
    8000402a:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000402c:	00003517          	auipc	a0,0x3
    80004030:	61c50513          	addi	a0,a0,1564 # 80007648 <etext+0x648>
    80004034:	f60fc0ef          	jal	80000794 <panic>
    release(&ftable.lock);
    80004038:	0001c517          	auipc	a0,0x1c
    8000403c:	02050513          	addi	a0,a0,32 # 80020058 <ftable>
    80004040:	c4dfc0ef          	jal	80000c8c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004044:	70e2                	ld	ra,56(sp)
    80004046:	7442                	ld	s0,48(sp)
    80004048:	74a2                	ld	s1,40(sp)
    8000404a:	6121                	addi	sp,sp,64
    8000404c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000404e:	85d6                	mv	a1,s5
    80004050:	8552                	mv	a0,s4
    80004052:	336000ef          	jal	80004388 <pipeclose>
    80004056:	7902                	ld	s2,32(sp)
    80004058:	69e2                	ld	s3,24(sp)
    8000405a:	6a42                	ld	s4,16(sp)
    8000405c:	6aa2                	ld	s5,8(sp)
    8000405e:	b7dd                	j	80004044 <fileclose+0x8e>
    begin_op();
    80004060:	b3dff0ef          	jal	80003b9c <begin_op>
    iput(ff.ip);
    80004064:	854e                	mv	a0,s3
    80004066:	c22ff0ef          	jal	80003488 <iput>
    end_op();
    8000406a:	b9dff0ef          	jal	80003c06 <end_op>
    8000406e:	7902                	ld	s2,32(sp)
    80004070:	69e2                	ld	s3,24(sp)
    80004072:	6a42                	ld	s4,16(sp)
    80004074:	6aa2                	ld	s5,8(sp)
    80004076:	b7f9                	j	80004044 <fileclose+0x8e>

0000000080004078 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004078:	715d                	addi	sp,sp,-80
    8000407a:	e486                	sd	ra,72(sp)
    8000407c:	e0a2                	sd	s0,64(sp)
    8000407e:	fc26                	sd	s1,56(sp)
    80004080:	f44e                	sd	s3,40(sp)
    80004082:	0880                	addi	s0,sp,80
    80004084:	84aa                	mv	s1,a0
    80004086:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004088:	86bfd0ef          	jal	800018f2 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000408c:	409c                	lw	a5,0(s1)
    8000408e:	37f9                	addiw	a5,a5,-2
    80004090:	4705                	li	a4,1
    80004092:	04f76063          	bltu	a4,a5,800040d2 <filestat+0x5a>
    80004096:	f84a                	sd	s2,48(sp)
    80004098:	892a                	mv	s2,a0
    ilock(f->ip);
    8000409a:	6c88                	ld	a0,24(s1)
    8000409c:	a6aff0ef          	jal	80003306 <ilock>
    stati(f->ip, &st);
    800040a0:	fb840593          	addi	a1,s0,-72
    800040a4:	6c88                	ld	a0,24(s1)
    800040a6:	c8aff0ef          	jal	80003530 <stati>
    iunlock(f->ip);
    800040aa:	6c88                	ld	a0,24(s1)
    800040ac:	b08ff0ef          	jal	800033b4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800040b0:	46e1                	li	a3,24
    800040b2:	fb840613          	addi	a2,s0,-72
    800040b6:	85ce                	mv	a1,s3
    800040b8:	05093503          	ld	a0,80(s2)
    800040bc:	c9afd0ef          	jal	80001556 <copyout>
    800040c0:	41f5551b          	sraiw	a0,a0,0x1f
    800040c4:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800040c6:	60a6                	ld	ra,72(sp)
    800040c8:	6406                	ld	s0,64(sp)
    800040ca:	74e2                	ld	s1,56(sp)
    800040cc:	79a2                	ld	s3,40(sp)
    800040ce:	6161                	addi	sp,sp,80
    800040d0:	8082                	ret
  return -1;
    800040d2:	557d                	li	a0,-1
    800040d4:	bfcd                	j	800040c6 <filestat+0x4e>

00000000800040d6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800040d6:	7179                	addi	sp,sp,-48
    800040d8:	f406                	sd	ra,40(sp)
    800040da:	f022                	sd	s0,32(sp)
    800040dc:	e84a                	sd	s2,16(sp)
    800040de:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800040e0:	00854783          	lbu	a5,8(a0)
    800040e4:	cfd1                	beqz	a5,80004180 <fileread+0xaa>
    800040e6:	ec26                	sd	s1,24(sp)
    800040e8:	e44e                	sd	s3,8(sp)
    800040ea:	84aa                	mv	s1,a0
    800040ec:	89ae                	mv	s3,a1
    800040ee:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800040f0:	411c                	lw	a5,0(a0)
    800040f2:	4705                	li	a4,1
    800040f4:	04e78363          	beq	a5,a4,8000413a <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800040f8:	470d                	li	a4,3
    800040fa:	04e78763          	beq	a5,a4,80004148 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800040fe:	4709                	li	a4,2
    80004100:	06e79a63          	bne	a5,a4,80004174 <fileread+0x9e>
    ilock(f->ip);
    80004104:	6d08                	ld	a0,24(a0)
    80004106:	a00ff0ef          	jal	80003306 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000410a:	874a                	mv	a4,s2
    8000410c:	5094                	lw	a3,32(s1)
    8000410e:	864e                	mv	a2,s3
    80004110:	4585                	li	a1,1
    80004112:	6c88                	ld	a0,24(s1)
    80004114:	c46ff0ef          	jal	8000355a <readi>
    80004118:	892a                	mv	s2,a0
    8000411a:	00a05563          	blez	a0,80004124 <fileread+0x4e>
      f->off += r;
    8000411e:	509c                	lw	a5,32(s1)
    80004120:	9fa9                	addw	a5,a5,a0
    80004122:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004124:	6c88                	ld	a0,24(s1)
    80004126:	a8eff0ef          	jal	800033b4 <iunlock>
    8000412a:	64e2                	ld	s1,24(sp)
    8000412c:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000412e:	854a                	mv	a0,s2
    80004130:	70a2                	ld	ra,40(sp)
    80004132:	7402                	ld	s0,32(sp)
    80004134:	6942                	ld	s2,16(sp)
    80004136:	6145                	addi	sp,sp,48
    80004138:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000413a:	6908                	ld	a0,16(a0)
    8000413c:	388000ef          	jal	800044c4 <piperead>
    80004140:	892a                	mv	s2,a0
    80004142:	64e2                	ld	s1,24(sp)
    80004144:	69a2                	ld	s3,8(sp)
    80004146:	b7e5                	j	8000412e <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004148:	02451783          	lh	a5,36(a0)
    8000414c:	03079693          	slli	a3,a5,0x30
    80004150:	92c1                	srli	a3,a3,0x30
    80004152:	4725                	li	a4,9
    80004154:	02d76863          	bltu	a4,a3,80004184 <fileread+0xae>
    80004158:	0792                	slli	a5,a5,0x4
    8000415a:	0001c717          	auipc	a4,0x1c
    8000415e:	e5e70713          	addi	a4,a4,-418 # 8001ffb8 <devsw>
    80004162:	97ba                	add	a5,a5,a4
    80004164:	639c                	ld	a5,0(a5)
    80004166:	c39d                	beqz	a5,8000418c <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004168:	4505                	li	a0,1
    8000416a:	9782                	jalr	a5
    8000416c:	892a                	mv	s2,a0
    8000416e:	64e2                	ld	s1,24(sp)
    80004170:	69a2                	ld	s3,8(sp)
    80004172:	bf75                	j	8000412e <fileread+0x58>
    panic("fileread");
    80004174:	00003517          	auipc	a0,0x3
    80004178:	4e450513          	addi	a0,a0,1252 # 80007658 <etext+0x658>
    8000417c:	e18fc0ef          	jal	80000794 <panic>
    return -1;
    80004180:	597d                	li	s2,-1
    80004182:	b775                	j	8000412e <fileread+0x58>
      return -1;
    80004184:	597d                	li	s2,-1
    80004186:	64e2                	ld	s1,24(sp)
    80004188:	69a2                	ld	s3,8(sp)
    8000418a:	b755                	j	8000412e <fileread+0x58>
    8000418c:	597d                	li	s2,-1
    8000418e:	64e2                	ld	s1,24(sp)
    80004190:	69a2                	ld	s3,8(sp)
    80004192:	bf71                	j	8000412e <fileread+0x58>

0000000080004194 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004194:	00954783          	lbu	a5,9(a0)
    80004198:	10078b63          	beqz	a5,800042ae <filewrite+0x11a>
{
    8000419c:	715d                	addi	sp,sp,-80
    8000419e:	e486                	sd	ra,72(sp)
    800041a0:	e0a2                	sd	s0,64(sp)
    800041a2:	f84a                	sd	s2,48(sp)
    800041a4:	f052                	sd	s4,32(sp)
    800041a6:	e85a                	sd	s6,16(sp)
    800041a8:	0880                	addi	s0,sp,80
    800041aa:	892a                	mv	s2,a0
    800041ac:	8b2e                	mv	s6,a1
    800041ae:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800041b0:	411c                	lw	a5,0(a0)
    800041b2:	4705                	li	a4,1
    800041b4:	02e78763          	beq	a5,a4,800041e2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800041b8:	470d                	li	a4,3
    800041ba:	02e78863          	beq	a5,a4,800041ea <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800041be:	4709                	li	a4,2
    800041c0:	0ce79c63          	bne	a5,a4,80004298 <filewrite+0x104>
    800041c4:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800041c6:	0ac05863          	blez	a2,80004276 <filewrite+0xe2>
    800041ca:	fc26                	sd	s1,56(sp)
    800041cc:	ec56                	sd	s5,24(sp)
    800041ce:	e45e                	sd	s7,8(sp)
    800041d0:	e062                	sd	s8,0(sp)
    int i = 0;
    800041d2:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800041d4:	6b85                	lui	s7,0x1
    800041d6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800041da:	6c05                	lui	s8,0x1
    800041dc:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800041e0:	a8b5                	j	8000425c <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800041e2:	6908                	ld	a0,16(a0)
    800041e4:	1fc000ef          	jal	800043e0 <pipewrite>
    800041e8:	a04d                	j	8000428a <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800041ea:	02451783          	lh	a5,36(a0)
    800041ee:	03079693          	slli	a3,a5,0x30
    800041f2:	92c1                	srli	a3,a3,0x30
    800041f4:	4725                	li	a4,9
    800041f6:	0ad76e63          	bltu	a4,a3,800042b2 <filewrite+0x11e>
    800041fa:	0792                	slli	a5,a5,0x4
    800041fc:	0001c717          	auipc	a4,0x1c
    80004200:	dbc70713          	addi	a4,a4,-580 # 8001ffb8 <devsw>
    80004204:	97ba                	add	a5,a5,a4
    80004206:	679c                	ld	a5,8(a5)
    80004208:	c7dd                	beqz	a5,800042b6 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000420a:	4505                	li	a0,1
    8000420c:	9782                	jalr	a5
    8000420e:	a8b5                	j	8000428a <filewrite+0xf6>
      if(n1 > max)
    80004210:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004214:	989ff0ef          	jal	80003b9c <begin_op>
      ilock(f->ip);
    80004218:	01893503          	ld	a0,24(s2)
    8000421c:	8eaff0ef          	jal	80003306 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004220:	8756                	mv	a4,s5
    80004222:	02092683          	lw	a3,32(s2)
    80004226:	01698633          	add	a2,s3,s6
    8000422a:	4585                	li	a1,1
    8000422c:	01893503          	ld	a0,24(s2)
    80004230:	c26ff0ef          	jal	80003656 <writei>
    80004234:	84aa                	mv	s1,a0
    80004236:	00a05763          	blez	a0,80004244 <filewrite+0xb0>
        f->off += r;
    8000423a:	02092783          	lw	a5,32(s2)
    8000423e:	9fa9                	addw	a5,a5,a0
    80004240:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004244:	01893503          	ld	a0,24(s2)
    80004248:	96cff0ef          	jal	800033b4 <iunlock>
      end_op();
    8000424c:	9bbff0ef          	jal	80003c06 <end_op>

      if(r != n1){
    80004250:	029a9563          	bne	s5,s1,8000427a <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004254:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004258:	0149da63          	bge	s3,s4,8000426c <filewrite+0xd8>
      int n1 = n - i;
    8000425c:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004260:	0004879b          	sext.w	a5,s1
    80004264:	fafbd6e3          	bge	s7,a5,80004210 <filewrite+0x7c>
    80004268:	84e2                	mv	s1,s8
    8000426a:	b75d                	j	80004210 <filewrite+0x7c>
    8000426c:	74e2                	ld	s1,56(sp)
    8000426e:	6ae2                	ld	s5,24(sp)
    80004270:	6ba2                	ld	s7,8(sp)
    80004272:	6c02                	ld	s8,0(sp)
    80004274:	a039                	j	80004282 <filewrite+0xee>
    int i = 0;
    80004276:	4981                	li	s3,0
    80004278:	a029                	j	80004282 <filewrite+0xee>
    8000427a:	74e2                	ld	s1,56(sp)
    8000427c:	6ae2                	ld	s5,24(sp)
    8000427e:	6ba2                	ld	s7,8(sp)
    80004280:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004282:	033a1c63          	bne	s4,s3,800042ba <filewrite+0x126>
    80004286:	8552                	mv	a0,s4
    80004288:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000428a:	60a6                	ld	ra,72(sp)
    8000428c:	6406                	ld	s0,64(sp)
    8000428e:	7942                	ld	s2,48(sp)
    80004290:	7a02                	ld	s4,32(sp)
    80004292:	6b42                	ld	s6,16(sp)
    80004294:	6161                	addi	sp,sp,80
    80004296:	8082                	ret
    80004298:	fc26                	sd	s1,56(sp)
    8000429a:	f44e                	sd	s3,40(sp)
    8000429c:	ec56                	sd	s5,24(sp)
    8000429e:	e45e                	sd	s7,8(sp)
    800042a0:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800042a2:	00003517          	auipc	a0,0x3
    800042a6:	3c650513          	addi	a0,a0,966 # 80007668 <etext+0x668>
    800042aa:	ceafc0ef          	jal	80000794 <panic>
    return -1;
    800042ae:	557d                	li	a0,-1
}
    800042b0:	8082                	ret
      return -1;
    800042b2:	557d                	li	a0,-1
    800042b4:	bfd9                	j	8000428a <filewrite+0xf6>
    800042b6:	557d                	li	a0,-1
    800042b8:	bfc9                	j	8000428a <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800042ba:	557d                	li	a0,-1
    800042bc:	79a2                	ld	s3,40(sp)
    800042be:	b7f1                	j	8000428a <filewrite+0xf6>

00000000800042c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800042c0:	7179                	addi	sp,sp,-48
    800042c2:	f406                	sd	ra,40(sp)
    800042c4:	f022                	sd	s0,32(sp)
    800042c6:	ec26                	sd	s1,24(sp)
    800042c8:	e052                	sd	s4,0(sp)
    800042ca:	1800                	addi	s0,sp,48
    800042cc:	84aa                	mv	s1,a0
    800042ce:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800042d0:	0005b023          	sd	zero,0(a1)
    800042d4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800042d8:	c3bff0ef          	jal	80003f12 <filealloc>
    800042dc:	e088                	sd	a0,0(s1)
    800042de:	c549                	beqz	a0,80004368 <pipealloc+0xa8>
    800042e0:	c33ff0ef          	jal	80003f12 <filealloc>
    800042e4:	00aa3023          	sd	a0,0(s4)
    800042e8:	cd25                	beqz	a0,80004360 <pipealloc+0xa0>
    800042ea:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800042ec:	839fc0ef          	jal	80000b24 <kalloc>
    800042f0:	892a                	mv	s2,a0
    800042f2:	c12d                	beqz	a0,80004354 <pipealloc+0x94>
    800042f4:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800042f6:	4985                	li	s3,1
    800042f8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800042fc:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004300:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004304:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004308:	00003597          	auipc	a1,0x3
    8000430c:	37058593          	addi	a1,a1,880 # 80007678 <etext+0x678>
    80004310:	865fc0ef          	jal	80000b74 <initlock>
  (*f0)->type = FD_PIPE;
    80004314:	609c                	ld	a5,0(s1)
    80004316:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000431a:	609c                	ld	a5,0(s1)
    8000431c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004320:	609c                	ld	a5,0(s1)
    80004322:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004326:	609c                	ld	a5,0(s1)
    80004328:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000432c:	000a3783          	ld	a5,0(s4)
    80004330:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004334:	000a3783          	ld	a5,0(s4)
    80004338:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000433c:	000a3783          	ld	a5,0(s4)
    80004340:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004344:	000a3783          	ld	a5,0(s4)
    80004348:	0127b823          	sd	s2,16(a5)
  return 0;
    8000434c:	4501                	li	a0,0
    8000434e:	6942                	ld	s2,16(sp)
    80004350:	69a2                	ld	s3,8(sp)
    80004352:	a01d                	j	80004378 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004354:	6088                	ld	a0,0(s1)
    80004356:	c119                	beqz	a0,8000435c <pipealloc+0x9c>
    80004358:	6942                	ld	s2,16(sp)
    8000435a:	a029                	j	80004364 <pipealloc+0xa4>
    8000435c:	6942                	ld	s2,16(sp)
    8000435e:	a029                	j	80004368 <pipealloc+0xa8>
    80004360:	6088                	ld	a0,0(s1)
    80004362:	c10d                	beqz	a0,80004384 <pipealloc+0xc4>
    fileclose(*f0);
    80004364:	c53ff0ef          	jal	80003fb6 <fileclose>
  if(*f1)
    80004368:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000436c:	557d                	li	a0,-1
  if(*f1)
    8000436e:	c789                	beqz	a5,80004378 <pipealloc+0xb8>
    fileclose(*f1);
    80004370:	853e                	mv	a0,a5
    80004372:	c45ff0ef          	jal	80003fb6 <fileclose>
  return -1;
    80004376:	557d                	li	a0,-1
}
    80004378:	70a2                	ld	ra,40(sp)
    8000437a:	7402                	ld	s0,32(sp)
    8000437c:	64e2                	ld	s1,24(sp)
    8000437e:	6a02                	ld	s4,0(sp)
    80004380:	6145                	addi	sp,sp,48
    80004382:	8082                	ret
  return -1;
    80004384:	557d                	li	a0,-1
    80004386:	bfcd                	j	80004378 <pipealloc+0xb8>

0000000080004388 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004388:	1101                	addi	sp,sp,-32
    8000438a:	ec06                	sd	ra,24(sp)
    8000438c:	e822                	sd	s0,16(sp)
    8000438e:	e426                	sd	s1,8(sp)
    80004390:	e04a                	sd	s2,0(sp)
    80004392:	1000                	addi	s0,sp,32
    80004394:	84aa                	mv	s1,a0
    80004396:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004398:	85dfc0ef          	jal	80000bf4 <acquire>
  if(writable){
    8000439c:	02090763          	beqz	s2,800043ca <pipeclose+0x42>
    pi->writeopen = 0;
    800043a0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800043a4:	21848513          	addi	a0,s1,536
    800043a8:	97ffd0ef          	jal	80001d26 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800043ac:	2204b783          	ld	a5,544(s1)
    800043b0:	e785                	bnez	a5,800043d8 <pipeclose+0x50>
    release(&pi->lock);
    800043b2:	8526                	mv	a0,s1
    800043b4:	8d9fc0ef          	jal	80000c8c <release>
    kfree((char*)pi);
    800043b8:	8526                	mv	a0,s1
    800043ba:	e88fc0ef          	jal	80000a42 <kfree>
  } else
    release(&pi->lock);
}
    800043be:	60e2                	ld	ra,24(sp)
    800043c0:	6442                	ld	s0,16(sp)
    800043c2:	64a2                	ld	s1,8(sp)
    800043c4:	6902                	ld	s2,0(sp)
    800043c6:	6105                	addi	sp,sp,32
    800043c8:	8082                	ret
    pi->readopen = 0;
    800043ca:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800043ce:	21c48513          	addi	a0,s1,540
    800043d2:	955fd0ef          	jal	80001d26 <wakeup>
    800043d6:	bfd9                	j	800043ac <pipeclose+0x24>
    release(&pi->lock);
    800043d8:	8526                	mv	a0,s1
    800043da:	8b3fc0ef          	jal	80000c8c <release>
}
    800043de:	b7c5                	j	800043be <pipeclose+0x36>

00000000800043e0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800043e0:	711d                	addi	sp,sp,-96
    800043e2:	ec86                	sd	ra,88(sp)
    800043e4:	e8a2                	sd	s0,80(sp)
    800043e6:	e4a6                	sd	s1,72(sp)
    800043e8:	e0ca                	sd	s2,64(sp)
    800043ea:	fc4e                	sd	s3,56(sp)
    800043ec:	f852                	sd	s4,48(sp)
    800043ee:	f456                	sd	s5,40(sp)
    800043f0:	1080                	addi	s0,sp,96
    800043f2:	84aa                	mv	s1,a0
    800043f4:	8aae                	mv	s5,a1
    800043f6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800043f8:	cfafd0ef          	jal	800018f2 <myproc>
    800043fc:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800043fe:	8526                	mv	a0,s1
    80004400:	ff4fc0ef          	jal	80000bf4 <acquire>
  while(i < n){
    80004404:	0b405a63          	blez	s4,800044b8 <pipewrite+0xd8>
    80004408:	f05a                	sd	s6,32(sp)
    8000440a:	ec5e                	sd	s7,24(sp)
    8000440c:	e862                	sd	s8,16(sp)
  int i = 0;
    8000440e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004410:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004412:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004416:	21c48b93          	addi	s7,s1,540
    8000441a:	a81d                	j	80004450 <pipewrite+0x70>
      release(&pi->lock);
    8000441c:	8526                	mv	a0,s1
    8000441e:	86ffc0ef          	jal	80000c8c <release>
      return -1;
    80004422:	597d                	li	s2,-1
    80004424:	7b02                	ld	s6,32(sp)
    80004426:	6be2                	ld	s7,24(sp)
    80004428:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000442a:	854a                	mv	a0,s2
    8000442c:	60e6                	ld	ra,88(sp)
    8000442e:	6446                	ld	s0,80(sp)
    80004430:	64a6                	ld	s1,72(sp)
    80004432:	6906                	ld	s2,64(sp)
    80004434:	79e2                	ld	s3,56(sp)
    80004436:	7a42                	ld	s4,48(sp)
    80004438:	7aa2                	ld	s5,40(sp)
    8000443a:	6125                	addi	sp,sp,96
    8000443c:	8082                	ret
      wakeup(&pi->nread);
    8000443e:	8562                	mv	a0,s8
    80004440:	8e7fd0ef          	jal	80001d26 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004444:	85a6                	mv	a1,s1
    80004446:	855e                	mv	a0,s7
    80004448:	893fd0ef          	jal	80001cda <sleep>
  while(i < n){
    8000444c:	05495b63          	bge	s2,s4,800044a2 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80004450:	2204a783          	lw	a5,544(s1)
    80004454:	d7e1                	beqz	a5,8000441c <pipewrite+0x3c>
    80004456:	854e                	mv	a0,s3
    80004458:	abbfd0ef          	jal	80001f12 <killed>
    8000445c:	f161                	bnez	a0,8000441c <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000445e:	2184a783          	lw	a5,536(s1)
    80004462:	21c4a703          	lw	a4,540(s1)
    80004466:	2007879b          	addiw	a5,a5,512
    8000446a:	fcf70ae3          	beq	a4,a5,8000443e <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000446e:	4685                	li	a3,1
    80004470:	01590633          	add	a2,s2,s5
    80004474:	faf40593          	addi	a1,s0,-81
    80004478:	0509b503          	ld	a0,80(s3)
    8000447c:	9b0fd0ef          	jal	8000162c <copyin>
    80004480:	03650e63          	beq	a0,s6,800044bc <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004484:	21c4a783          	lw	a5,540(s1)
    80004488:	0017871b          	addiw	a4,a5,1
    8000448c:	20e4ae23          	sw	a4,540(s1)
    80004490:	1ff7f793          	andi	a5,a5,511
    80004494:	97a6                	add	a5,a5,s1
    80004496:	faf44703          	lbu	a4,-81(s0)
    8000449a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000449e:	2905                	addiw	s2,s2,1
    800044a0:	b775                	j	8000444c <pipewrite+0x6c>
    800044a2:	7b02                	ld	s6,32(sp)
    800044a4:	6be2                	ld	s7,24(sp)
    800044a6:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800044a8:	21848513          	addi	a0,s1,536
    800044ac:	87bfd0ef          	jal	80001d26 <wakeup>
  release(&pi->lock);
    800044b0:	8526                	mv	a0,s1
    800044b2:	fdafc0ef          	jal	80000c8c <release>
  return i;
    800044b6:	bf95                	j	8000442a <pipewrite+0x4a>
  int i = 0;
    800044b8:	4901                	li	s2,0
    800044ba:	b7fd                	j	800044a8 <pipewrite+0xc8>
    800044bc:	7b02                	ld	s6,32(sp)
    800044be:	6be2                	ld	s7,24(sp)
    800044c0:	6c42                	ld	s8,16(sp)
    800044c2:	b7dd                	j	800044a8 <pipewrite+0xc8>

00000000800044c4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800044c4:	715d                	addi	sp,sp,-80
    800044c6:	e486                	sd	ra,72(sp)
    800044c8:	e0a2                	sd	s0,64(sp)
    800044ca:	fc26                	sd	s1,56(sp)
    800044cc:	f84a                	sd	s2,48(sp)
    800044ce:	f44e                	sd	s3,40(sp)
    800044d0:	f052                	sd	s4,32(sp)
    800044d2:	ec56                	sd	s5,24(sp)
    800044d4:	0880                	addi	s0,sp,80
    800044d6:	84aa                	mv	s1,a0
    800044d8:	892e                	mv	s2,a1
    800044da:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800044dc:	c16fd0ef          	jal	800018f2 <myproc>
    800044e0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800044e2:	8526                	mv	a0,s1
    800044e4:	f10fc0ef          	jal	80000bf4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800044e8:	2184a703          	lw	a4,536(s1)
    800044ec:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800044f0:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800044f4:	02f71563          	bne	a4,a5,8000451e <piperead+0x5a>
    800044f8:	2244a783          	lw	a5,548(s1)
    800044fc:	cb85                	beqz	a5,8000452c <piperead+0x68>
    if(killed(pr)){
    800044fe:	8552                	mv	a0,s4
    80004500:	a13fd0ef          	jal	80001f12 <killed>
    80004504:	ed19                	bnez	a0,80004522 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004506:	85a6                	mv	a1,s1
    80004508:	854e                	mv	a0,s3
    8000450a:	fd0fd0ef          	jal	80001cda <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000450e:	2184a703          	lw	a4,536(s1)
    80004512:	21c4a783          	lw	a5,540(s1)
    80004516:	fef701e3          	beq	a4,a5,800044f8 <piperead+0x34>
    8000451a:	e85a                	sd	s6,16(sp)
    8000451c:	a809                	j	8000452e <piperead+0x6a>
    8000451e:	e85a                	sd	s6,16(sp)
    80004520:	a039                	j	8000452e <piperead+0x6a>
      release(&pi->lock);
    80004522:	8526                	mv	a0,s1
    80004524:	f68fc0ef          	jal	80000c8c <release>
      return -1;
    80004528:	59fd                	li	s3,-1
    8000452a:	a8b1                	j	80004586 <piperead+0xc2>
    8000452c:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000452e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004530:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004532:	05505263          	blez	s5,80004576 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004536:	2184a783          	lw	a5,536(s1)
    8000453a:	21c4a703          	lw	a4,540(s1)
    8000453e:	02f70c63          	beq	a4,a5,80004576 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004542:	0017871b          	addiw	a4,a5,1
    80004546:	20e4ac23          	sw	a4,536(s1)
    8000454a:	1ff7f793          	andi	a5,a5,511
    8000454e:	97a6                	add	a5,a5,s1
    80004550:	0187c783          	lbu	a5,24(a5)
    80004554:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004558:	4685                	li	a3,1
    8000455a:	fbf40613          	addi	a2,s0,-65
    8000455e:	85ca                	mv	a1,s2
    80004560:	050a3503          	ld	a0,80(s4)
    80004564:	ff3fc0ef          	jal	80001556 <copyout>
    80004568:	01650763          	beq	a0,s6,80004576 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000456c:	2985                	addiw	s3,s3,1
    8000456e:	0905                	addi	s2,s2,1
    80004570:	fd3a93e3          	bne	s5,s3,80004536 <piperead+0x72>
    80004574:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004576:	21c48513          	addi	a0,s1,540
    8000457a:	facfd0ef          	jal	80001d26 <wakeup>
  release(&pi->lock);
    8000457e:	8526                	mv	a0,s1
    80004580:	f0cfc0ef          	jal	80000c8c <release>
    80004584:	6b42                	ld	s6,16(sp)
  return i;
}
    80004586:	854e                	mv	a0,s3
    80004588:	60a6                	ld	ra,72(sp)
    8000458a:	6406                	ld	s0,64(sp)
    8000458c:	74e2                	ld	s1,56(sp)
    8000458e:	7942                	ld	s2,48(sp)
    80004590:	79a2                	ld	s3,40(sp)
    80004592:	7a02                	ld	s4,32(sp)
    80004594:	6ae2                	ld	s5,24(sp)
    80004596:	6161                	addi	sp,sp,80
    80004598:	8082                	ret

000000008000459a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000459a:	1141                	addi	sp,sp,-16
    8000459c:	e422                	sd	s0,8(sp)
    8000459e:	0800                	addi	s0,sp,16
    800045a0:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800045a2:	8905                	andi	a0,a0,1
    800045a4:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800045a6:	8b89                	andi	a5,a5,2
    800045a8:	c399                	beqz	a5,800045ae <flags2perm+0x14>
      perm |= PTE_W;
    800045aa:	00456513          	ori	a0,a0,4
    return perm;
}
    800045ae:	6422                	ld	s0,8(sp)
    800045b0:	0141                	addi	sp,sp,16
    800045b2:	8082                	ret

00000000800045b4 <exec>:

int
exec(char *path, char **argv)
{
    800045b4:	df010113          	addi	sp,sp,-528
    800045b8:	20113423          	sd	ra,520(sp)
    800045bc:	20813023          	sd	s0,512(sp)
    800045c0:	ffa6                	sd	s1,504(sp)
    800045c2:	fbca                	sd	s2,496(sp)
    800045c4:	0c00                	addi	s0,sp,528
    800045c6:	892a                	mv	s2,a0
    800045c8:	dea43c23          	sd	a0,-520(s0)
    800045cc:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800045d0:	b22fd0ef          	jal	800018f2 <myproc>
    800045d4:	84aa                	mv	s1,a0

  begin_op();
    800045d6:	dc6ff0ef          	jal	80003b9c <begin_op>

  if((ip = namei(path)) == 0){
    800045da:	854a                	mv	a0,s2
    800045dc:	c04ff0ef          	jal	800039e0 <namei>
    800045e0:	c931                	beqz	a0,80004634 <exec+0x80>
    800045e2:	f3d2                	sd	s4,480(sp)
    800045e4:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800045e6:	d21fe0ef          	jal	80003306 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800045ea:	04000713          	li	a4,64
    800045ee:	4681                	li	a3,0
    800045f0:	e5040613          	addi	a2,s0,-432
    800045f4:	4581                	li	a1,0
    800045f6:	8552                	mv	a0,s4
    800045f8:	f63fe0ef          	jal	8000355a <readi>
    800045fc:	04000793          	li	a5,64
    80004600:	00f51a63          	bne	a0,a5,80004614 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004604:	e5042703          	lw	a4,-432(s0)
    80004608:	464c47b7          	lui	a5,0x464c4
    8000460c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004610:	02f70663          	beq	a4,a5,8000463c <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004614:	8552                	mv	a0,s4
    80004616:	efbfe0ef          	jal	80003510 <iunlockput>
    end_op();
    8000461a:	decff0ef          	jal	80003c06 <end_op>
  }
  return -1;
    8000461e:	557d                	li	a0,-1
    80004620:	7a1e                	ld	s4,480(sp)
}
    80004622:	20813083          	ld	ra,520(sp)
    80004626:	20013403          	ld	s0,512(sp)
    8000462a:	74fe                	ld	s1,504(sp)
    8000462c:	795e                	ld	s2,496(sp)
    8000462e:	21010113          	addi	sp,sp,528
    80004632:	8082                	ret
    end_op();
    80004634:	dd2ff0ef          	jal	80003c06 <end_op>
    return -1;
    80004638:	557d                	li	a0,-1
    8000463a:	b7e5                	j	80004622 <exec+0x6e>
    8000463c:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000463e:	8526                	mv	a0,s1
    80004640:	b5afd0ef          	jal	8000199a <proc_pagetable>
    80004644:	8b2a                	mv	s6,a0
    80004646:	2c050b63          	beqz	a0,8000491c <exec+0x368>
    8000464a:	f7ce                	sd	s3,488(sp)
    8000464c:	efd6                	sd	s5,472(sp)
    8000464e:	e7de                	sd	s7,456(sp)
    80004650:	e3e2                	sd	s8,448(sp)
    80004652:	ff66                	sd	s9,440(sp)
    80004654:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004656:	e7042d03          	lw	s10,-400(s0)
    8000465a:	e8845783          	lhu	a5,-376(s0)
    8000465e:	12078963          	beqz	a5,80004790 <exec+0x1dc>
    80004662:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004664:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004666:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004668:	6c85                	lui	s9,0x1
    8000466a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000466e:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004672:	6a85                	lui	s5,0x1
    80004674:	a085                	j	800046d4 <exec+0x120>
      panic("loadseg: address should exist");
    80004676:	00003517          	auipc	a0,0x3
    8000467a:	00a50513          	addi	a0,a0,10 # 80007680 <etext+0x680>
    8000467e:	916fc0ef          	jal	80000794 <panic>
    if(sz - i < PGSIZE)
    80004682:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004684:	8726                	mv	a4,s1
    80004686:	012c06bb          	addw	a3,s8,s2
    8000468a:	4581                	li	a1,0
    8000468c:	8552                	mv	a0,s4
    8000468e:	ecdfe0ef          	jal	8000355a <readi>
    80004692:	2501                	sext.w	a0,a0
    80004694:	24a49a63          	bne	s1,a0,800048e8 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80004698:	012a893b          	addw	s2,s5,s2
    8000469c:	03397363          	bgeu	s2,s3,800046c2 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    800046a0:	02091593          	slli	a1,s2,0x20
    800046a4:	9181                	srli	a1,a1,0x20
    800046a6:	95de                	add	a1,a1,s7
    800046a8:	855a                	mv	a0,s6
    800046aa:	931fc0ef          	jal	80000fda <walkaddr>
    800046ae:	862a                	mv	a2,a0
    if(pa == 0)
    800046b0:	d179                	beqz	a0,80004676 <exec+0xc2>
    if(sz - i < PGSIZE)
    800046b2:	412984bb          	subw	s1,s3,s2
    800046b6:	0004879b          	sext.w	a5,s1
    800046ba:	fcfcf4e3          	bgeu	s9,a5,80004682 <exec+0xce>
    800046be:	84d6                	mv	s1,s5
    800046c0:	b7c9                	j	80004682 <exec+0xce>
    sz = sz1;
    800046c2:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800046c6:	2d85                	addiw	s11,s11,1
    800046c8:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800046cc:	e8845783          	lhu	a5,-376(s0)
    800046d0:	08fdd063          	bge	s11,a5,80004750 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800046d4:	2d01                	sext.w	s10,s10
    800046d6:	03800713          	li	a4,56
    800046da:	86ea                	mv	a3,s10
    800046dc:	e1840613          	addi	a2,s0,-488
    800046e0:	4581                	li	a1,0
    800046e2:	8552                	mv	a0,s4
    800046e4:	e77fe0ef          	jal	8000355a <readi>
    800046e8:	03800793          	li	a5,56
    800046ec:	1cf51663          	bne	a0,a5,800048b8 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    800046f0:	e1842783          	lw	a5,-488(s0)
    800046f4:	4705                	li	a4,1
    800046f6:	fce798e3          	bne	a5,a4,800046c6 <exec+0x112>
    if(ph.memsz < ph.filesz)
    800046fa:	e4043483          	ld	s1,-448(s0)
    800046fe:	e3843783          	ld	a5,-456(s0)
    80004702:	1af4ef63          	bltu	s1,a5,800048c0 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004706:	e2843783          	ld	a5,-472(s0)
    8000470a:	94be                	add	s1,s1,a5
    8000470c:	1af4ee63          	bltu	s1,a5,800048c8 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004710:	df043703          	ld	a4,-528(s0)
    80004714:	8ff9                	and	a5,a5,a4
    80004716:	1a079d63          	bnez	a5,800048d0 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000471a:	e1c42503          	lw	a0,-484(s0)
    8000471e:	e7dff0ef          	jal	8000459a <flags2perm>
    80004722:	86aa                	mv	a3,a0
    80004724:	8626                	mv	a2,s1
    80004726:	85ca                	mv	a1,s2
    80004728:	855a                	mv	a0,s6
    8000472a:	c19fc0ef          	jal	80001342 <uvmalloc>
    8000472e:	e0a43423          	sd	a0,-504(s0)
    80004732:	1a050363          	beqz	a0,800048d8 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004736:	e2843b83          	ld	s7,-472(s0)
    8000473a:	e2042c03          	lw	s8,-480(s0)
    8000473e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004742:	00098463          	beqz	s3,8000474a <exec+0x196>
    80004746:	4901                	li	s2,0
    80004748:	bfa1                	j	800046a0 <exec+0xec>
    sz = sz1;
    8000474a:	e0843903          	ld	s2,-504(s0)
    8000474e:	bfa5                	j	800046c6 <exec+0x112>
    80004750:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004752:	8552                	mv	a0,s4
    80004754:	dbdfe0ef          	jal	80003510 <iunlockput>
  end_op();
    80004758:	caeff0ef          	jal	80003c06 <end_op>
  p = myproc();
    8000475c:	996fd0ef          	jal	800018f2 <myproc>
    80004760:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004762:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004766:	6985                	lui	s3,0x1
    80004768:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000476a:	99ca                	add	s3,s3,s2
    8000476c:	77fd                	lui	a5,0xfffff
    8000476e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004772:	4691                	li	a3,4
    80004774:	6609                	lui	a2,0x2
    80004776:	964e                	add	a2,a2,s3
    80004778:	85ce                	mv	a1,s3
    8000477a:	855a                	mv	a0,s6
    8000477c:	bc7fc0ef          	jal	80001342 <uvmalloc>
    80004780:	892a                	mv	s2,a0
    80004782:	e0a43423          	sd	a0,-504(s0)
    80004786:	e519                	bnez	a0,80004794 <exec+0x1e0>
  if(pagetable)
    80004788:	e1343423          	sd	s3,-504(s0)
    8000478c:	4a01                	li	s4,0
    8000478e:	aab1                	j	800048ea <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004790:	4901                	li	s2,0
    80004792:	b7c1                	j	80004752 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004794:	75f9                	lui	a1,0xffffe
    80004796:	95aa                	add	a1,a1,a0
    80004798:	855a                	mv	a0,s6
    8000479a:	d93fc0ef          	jal	8000152c <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    8000479e:	7bfd                	lui	s7,0xfffff
    800047a0:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800047a2:	e0043783          	ld	a5,-512(s0)
    800047a6:	6388                	ld	a0,0(a5)
    800047a8:	cd39                	beqz	a0,80004806 <exec+0x252>
    800047aa:	e9040993          	addi	s3,s0,-368
    800047ae:	f9040c13          	addi	s8,s0,-112
    800047b2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800047b4:	e84fc0ef          	jal	80000e38 <strlen>
    800047b8:	0015079b          	addiw	a5,a0,1
    800047bc:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800047c0:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800047c4:	11796e63          	bltu	s2,s7,800048e0 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800047c8:	e0043d03          	ld	s10,-512(s0)
    800047cc:	000d3a03          	ld	s4,0(s10)
    800047d0:	8552                	mv	a0,s4
    800047d2:	e66fc0ef          	jal	80000e38 <strlen>
    800047d6:	0015069b          	addiw	a3,a0,1
    800047da:	8652                	mv	a2,s4
    800047dc:	85ca                	mv	a1,s2
    800047de:	855a                	mv	a0,s6
    800047e0:	d77fc0ef          	jal	80001556 <copyout>
    800047e4:	10054063          	bltz	a0,800048e4 <exec+0x330>
    ustack[argc] = sp;
    800047e8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800047ec:	0485                	addi	s1,s1,1
    800047ee:	008d0793          	addi	a5,s10,8
    800047f2:	e0f43023          	sd	a5,-512(s0)
    800047f6:	008d3503          	ld	a0,8(s10)
    800047fa:	c909                	beqz	a0,8000480c <exec+0x258>
    if(argc >= MAXARG)
    800047fc:	09a1                	addi	s3,s3,8
    800047fe:	fb899be3          	bne	s3,s8,800047b4 <exec+0x200>
  ip = 0;
    80004802:	4a01                	li	s4,0
    80004804:	a0dd                	j	800048ea <exec+0x336>
  sp = sz;
    80004806:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000480a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000480c:	00349793          	slli	a5,s1,0x3
    80004810:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdde40>
    80004814:	97a2                	add	a5,a5,s0
    80004816:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000481a:	00148693          	addi	a3,s1,1
    8000481e:	068e                	slli	a3,a3,0x3
    80004820:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004824:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004828:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000482c:	f5796ee3          	bltu	s2,s7,80004788 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004830:	e9040613          	addi	a2,s0,-368
    80004834:	85ca                	mv	a1,s2
    80004836:	855a                	mv	a0,s6
    80004838:	d1ffc0ef          	jal	80001556 <copyout>
    8000483c:	0e054263          	bltz	a0,80004920 <exec+0x36c>
  p->trapframe->a1 = sp;
    80004840:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004844:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004848:	df843783          	ld	a5,-520(s0)
    8000484c:	0007c703          	lbu	a4,0(a5)
    80004850:	cf11                	beqz	a4,8000486c <exec+0x2b8>
    80004852:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004854:	02f00693          	li	a3,47
    80004858:	a039                	j	80004866 <exec+0x2b2>
      last = s+1;
    8000485a:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000485e:	0785                	addi	a5,a5,1
    80004860:	fff7c703          	lbu	a4,-1(a5)
    80004864:	c701                	beqz	a4,8000486c <exec+0x2b8>
    if(*s == '/')
    80004866:	fed71ce3          	bne	a4,a3,8000485e <exec+0x2aa>
    8000486a:	bfc5                	j	8000485a <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    8000486c:	4641                	li	a2,16
    8000486e:	df843583          	ld	a1,-520(s0)
    80004872:	158a8513          	addi	a0,s5,344
    80004876:	d90fc0ef          	jal	80000e06 <safestrcpy>
  oldpagetable = p->pagetable;
    8000487a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000487e:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004882:	e0843783          	ld	a5,-504(s0)
    80004886:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000488a:	058ab783          	ld	a5,88(s5)
    8000488e:	e6843703          	ld	a4,-408(s0)
    80004892:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004894:	058ab783          	ld	a5,88(s5)
    80004898:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000489c:	85e6                	mv	a1,s9
    8000489e:	980fd0ef          	jal	80001a1e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800048a2:	0004851b          	sext.w	a0,s1
    800048a6:	79be                	ld	s3,488(sp)
    800048a8:	7a1e                	ld	s4,480(sp)
    800048aa:	6afe                	ld	s5,472(sp)
    800048ac:	6b5e                	ld	s6,464(sp)
    800048ae:	6bbe                	ld	s7,456(sp)
    800048b0:	6c1e                	ld	s8,448(sp)
    800048b2:	7cfa                	ld	s9,440(sp)
    800048b4:	7d5a                	ld	s10,432(sp)
    800048b6:	b3b5                	j	80004622 <exec+0x6e>
    800048b8:	e1243423          	sd	s2,-504(s0)
    800048bc:	7dba                	ld	s11,424(sp)
    800048be:	a035                	j	800048ea <exec+0x336>
    800048c0:	e1243423          	sd	s2,-504(s0)
    800048c4:	7dba                	ld	s11,424(sp)
    800048c6:	a015                	j	800048ea <exec+0x336>
    800048c8:	e1243423          	sd	s2,-504(s0)
    800048cc:	7dba                	ld	s11,424(sp)
    800048ce:	a831                	j	800048ea <exec+0x336>
    800048d0:	e1243423          	sd	s2,-504(s0)
    800048d4:	7dba                	ld	s11,424(sp)
    800048d6:	a811                	j	800048ea <exec+0x336>
    800048d8:	e1243423          	sd	s2,-504(s0)
    800048dc:	7dba                	ld	s11,424(sp)
    800048de:	a031                	j	800048ea <exec+0x336>
  ip = 0;
    800048e0:	4a01                	li	s4,0
    800048e2:	a021                	j	800048ea <exec+0x336>
    800048e4:	4a01                	li	s4,0
  if(pagetable)
    800048e6:	a011                	j	800048ea <exec+0x336>
    800048e8:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800048ea:	e0843583          	ld	a1,-504(s0)
    800048ee:	855a                	mv	a0,s6
    800048f0:	92efd0ef          	jal	80001a1e <proc_freepagetable>
  return -1;
    800048f4:	557d                	li	a0,-1
  if(ip){
    800048f6:	000a1b63          	bnez	s4,8000490c <exec+0x358>
    800048fa:	79be                	ld	s3,488(sp)
    800048fc:	7a1e                	ld	s4,480(sp)
    800048fe:	6afe                	ld	s5,472(sp)
    80004900:	6b5e                	ld	s6,464(sp)
    80004902:	6bbe                	ld	s7,456(sp)
    80004904:	6c1e                	ld	s8,448(sp)
    80004906:	7cfa                	ld	s9,440(sp)
    80004908:	7d5a                	ld	s10,432(sp)
    8000490a:	bb21                	j	80004622 <exec+0x6e>
    8000490c:	79be                	ld	s3,488(sp)
    8000490e:	6afe                	ld	s5,472(sp)
    80004910:	6b5e                	ld	s6,464(sp)
    80004912:	6bbe                	ld	s7,456(sp)
    80004914:	6c1e                	ld	s8,448(sp)
    80004916:	7cfa                	ld	s9,440(sp)
    80004918:	7d5a                	ld	s10,432(sp)
    8000491a:	b9ed                	j	80004614 <exec+0x60>
    8000491c:	6b5e                	ld	s6,464(sp)
    8000491e:	b9dd                	j	80004614 <exec+0x60>
  sz = sz1;
    80004920:	e0843983          	ld	s3,-504(s0)
    80004924:	b595                	j	80004788 <exec+0x1d4>

0000000080004926 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004926:	7179                	addi	sp,sp,-48
    80004928:	f406                	sd	ra,40(sp)
    8000492a:	f022                	sd	s0,32(sp)
    8000492c:	ec26                	sd	s1,24(sp)
    8000492e:	e84a                	sd	s2,16(sp)
    80004930:	1800                	addi	s0,sp,48
    80004932:	892e                	mv	s2,a1
    80004934:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004936:	fdc40593          	addi	a1,s0,-36
    8000493a:	fa1fd0ef          	jal	800028da <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000493e:	fdc42703          	lw	a4,-36(s0)
    80004942:	47bd                	li	a5,15
    80004944:	02e7e963          	bltu	a5,a4,80004976 <argfd+0x50>
    80004948:	fabfc0ef          	jal	800018f2 <myproc>
    8000494c:	fdc42703          	lw	a4,-36(s0)
    80004950:	01a70793          	addi	a5,a4,26
    80004954:	078e                	slli	a5,a5,0x3
    80004956:	953e                	add	a0,a0,a5
    80004958:	611c                	ld	a5,0(a0)
    8000495a:	c385                	beqz	a5,8000497a <argfd+0x54>
    return -1;
  if(pfd)
    8000495c:	00090463          	beqz	s2,80004964 <argfd+0x3e>
    *pfd = fd;
    80004960:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004964:	4501                	li	a0,0
  if(pf)
    80004966:	c091                	beqz	s1,8000496a <argfd+0x44>
    *pf = f;
    80004968:	e09c                	sd	a5,0(s1)
}
    8000496a:	70a2                	ld	ra,40(sp)
    8000496c:	7402                	ld	s0,32(sp)
    8000496e:	64e2                	ld	s1,24(sp)
    80004970:	6942                	ld	s2,16(sp)
    80004972:	6145                	addi	sp,sp,48
    80004974:	8082                	ret
    return -1;
    80004976:	557d                	li	a0,-1
    80004978:	bfcd                	j	8000496a <argfd+0x44>
    8000497a:	557d                	li	a0,-1
    8000497c:	b7fd                	j	8000496a <argfd+0x44>

000000008000497e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000497e:	1101                	addi	sp,sp,-32
    80004980:	ec06                	sd	ra,24(sp)
    80004982:	e822                	sd	s0,16(sp)
    80004984:	e426                	sd	s1,8(sp)
    80004986:	1000                	addi	s0,sp,32
    80004988:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000498a:	f69fc0ef          	jal	800018f2 <myproc>
    8000498e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004990:	0d050793          	addi	a5,a0,208
    80004994:	4501                	li	a0,0
    80004996:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004998:	6398                	ld	a4,0(a5)
    8000499a:	cb19                	beqz	a4,800049b0 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    8000499c:	2505                	addiw	a0,a0,1
    8000499e:	07a1                	addi	a5,a5,8
    800049a0:	fed51ce3          	bne	a0,a3,80004998 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800049a4:	557d                	li	a0,-1
}
    800049a6:	60e2                	ld	ra,24(sp)
    800049a8:	6442                	ld	s0,16(sp)
    800049aa:	64a2                	ld	s1,8(sp)
    800049ac:	6105                	addi	sp,sp,32
    800049ae:	8082                	ret
      p->ofile[fd] = f;
    800049b0:	01a50793          	addi	a5,a0,26
    800049b4:	078e                	slli	a5,a5,0x3
    800049b6:	963e                	add	a2,a2,a5
    800049b8:	e204                	sd	s1,0(a2)
      return fd;
    800049ba:	b7f5                	j	800049a6 <fdalloc+0x28>

00000000800049bc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800049bc:	715d                	addi	sp,sp,-80
    800049be:	e486                	sd	ra,72(sp)
    800049c0:	e0a2                	sd	s0,64(sp)
    800049c2:	fc26                	sd	s1,56(sp)
    800049c4:	f84a                	sd	s2,48(sp)
    800049c6:	f44e                	sd	s3,40(sp)
    800049c8:	ec56                	sd	s5,24(sp)
    800049ca:	e85a                	sd	s6,16(sp)
    800049cc:	0880                	addi	s0,sp,80
    800049ce:	8b2e                	mv	s6,a1
    800049d0:	89b2                	mv	s3,a2
    800049d2:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800049d4:	fb040593          	addi	a1,s0,-80
    800049d8:	822ff0ef          	jal	800039fa <nameiparent>
    800049dc:	84aa                	mv	s1,a0
    800049de:	10050a63          	beqz	a0,80004af2 <create+0x136>
    return 0;

  ilock(dp);
    800049e2:	925fe0ef          	jal	80003306 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800049e6:	4601                	li	a2,0
    800049e8:	fb040593          	addi	a1,s0,-80
    800049ec:	8526                	mv	a0,s1
    800049ee:	d8dfe0ef          	jal	8000377a <dirlookup>
    800049f2:	8aaa                	mv	s5,a0
    800049f4:	c129                	beqz	a0,80004a36 <create+0x7a>
    iunlockput(dp);
    800049f6:	8526                	mv	a0,s1
    800049f8:	b19fe0ef          	jal	80003510 <iunlockput>
    ilock(ip);
    800049fc:	8556                	mv	a0,s5
    800049fe:	909fe0ef          	jal	80003306 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004a02:	4789                	li	a5,2
    80004a04:	02fb1463          	bne	s6,a5,80004a2c <create+0x70>
    80004a08:	044ad783          	lhu	a5,68(s5)
    80004a0c:	37f9                	addiw	a5,a5,-2
    80004a0e:	17c2                	slli	a5,a5,0x30
    80004a10:	93c1                	srli	a5,a5,0x30
    80004a12:	4705                	li	a4,1
    80004a14:	00f76c63          	bltu	a4,a5,80004a2c <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004a18:	8556                	mv	a0,s5
    80004a1a:	60a6                	ld	ra,72(sp)
    80004a1c:	6406                	ld	s0,64(sp)
    80004a1e:	74e2                	ld	s1,56(sp)
    80004a20:	7942                	ld	s2,48(sp)
    80004a22:	79a2                	ld	s3,40(sp)
    80004a24:	6ae2                	ld	s5,24(sp)
    80004a26:	6b42                	ld	s6,16(sp)
    80004a28:	6161                	addi	sp,sp,80
    80004a2a:	8082                	ret
    iunlockput(ip);
    80004a2c:	8556                	mv	a0,s5
    80004a2e:	ae3fe0ef          	jal	80003510 <iunlockput>
    return 0;
    80004a32:	4a81                	li	s5,0
    80004a34:	b7d5                	j	80004a18 <create+0x5c>
    80004a36:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004a38:	85da                	mv	a1,s6
    80004a3a:	4088                	lw	a0,0(s1)
    80004a3c:	f5afe0ef          	jal	80003196 <ialloc>
    80004a40:	8a2a                	mv	s4,a0
    80004a42:	cd15                	beqz	a0,80004a7e <create+0xc2>
  ilock(ip);
    80004a44:	8c3fe0ef          	jal	80003306 <ilock>
  ip->major = major;
    80004a48:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004a4c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004a50:	4905                	li	s2,1
    80004a52:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004a56:	8552                	mv	a0,s4
    80004a58:	ffafe0ef          	jal	80003252 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004a5c:	032b0763          	beq	s6,s2,80004a8a <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004a60:	004a2603          	lw	a2,4(s4)
    80004a64:	fb040593          	addi	a1,s0,-80
    80004a68:	8526                	mv	a0,s1
    80004a6a:	eddfe0ef          	jal	80003946 <dirlink>
    80004a6e:	06054563          	bltz	a0,80004ad8 <create+0x11c>
  iunlockput(dp);
    80004a72:	8526                	mv	a0,s1
    80004a74:	a9dfe0ef          	jal	80003510 <iunlockput>
  return ip;
    80004a78:	8ad2                	mv	s5,s4
    80004a7a:	7a02                	ld	s4,32(sp)
    80004a7c:	bf71                	j	80004a18 <create+0x5c>
    iunlockput(dp);
    80004a7e:	8526                	mv	a0,s1
    80004a80:	a91fe0ef          	jal	80003510 <iunlockput>
    return 0;
    80004a84:	8ad2                	mv	s5,s4
    80004a86:	7a02                	ld	s4,32(sp)
    80004a88:	bf41                	j	80004a18 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004a8a:	004a2603          	lw	a2,4(s4)
    80004a8e:	00003597          	auipc	a1,0x3
    80004a92:	c1258593          	addi	a1,a1,-1006 # 800076a0 <etext+0x6a0>
    80004a96:	8552                	mv	a0,s4
    80004a98:	eaffe0ef          	jal	80003946 <dirlink>
    80004a9c:	02054e63          	bltz	a0,80004ad8 <create+0x11c>
    80004aa0:	40d0                	lw	a2,4(s1)
    80004aa2:	00003597          	auipc	a1,0x3
    80004aa6:	c0658593          	addi	a1,a1,-1018 # 800076a8 <etext+0x6a8>
    80004aaa:	8552                	mv	a0,s4
    80004aac:	e9bfe0ef          	jal	80003946 <dirlink>
    80004ab0:	02054463          	bltz	a0,80004ad8 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004ab4:	004a2603          	lw	a2,4(s4)
    80004ab8:	fb040593          	addi	a1,s0,-80
    80004abc:	8526                	mv	a0,s1
    80004abe:	e89fe0ef          	jal	80003946 <dirlink>
    80004ac2:	00054b63          	bltz	a0,80004ad8 <create+0x11c>
    dp->nlink++;  // for ".."
    80004ac6:	04a4d783          	lhu	a5,74(s1)
    80004aca:	2785                	addiw	a5,a5,1
    80004acc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ad0:	8526                	mv	a0,s1
    80004ad2:	f80fe0ef          	jal	80003252 <iupdate>
    80004ad6:	bf71                	j	80004a72 <create+0xb6>
  ip->nlink = 0;
    80004ad8:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004adc:	8552                	mv	a0,s4
    80004ade:	f74fe0ef          	jal	80003252 <iupdate>
  iunlockput(ip);
    80004ae2:	8552                	mv	a0,s4
    80004ae4:	a2dfe0ef          	jal	80003510 <iunlockput>
  iunlockput(dp);
    80004ae8:	8526                	mv	a0,s1
    80004aea:	a27fe0ef          	jal	80003510 <iunlockput>
  return 0;
    80004aee:	7a02                	ld	s4,32(sp)
    80004af0:	b725                	j	80004a18 <create+0x5c>
    return 0;
    80004af2:	8aaa                	mv	s5,a0
    80004af4:	b715                	j	80004a18 <create+0x5c>

0000000080004af6 <sys_dup>:
{
    80004af6:	7179                	addi	sp,sp,-48
    80004af8:	f406                	sd	ra,40(sp)
    80004afa:	f022                	sd	s0,32(sp)
    80004afc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004afe:	fd840613          	addi	a2,s0,-40
    80004b02:	4581                	li	a1,0
    80004b04:	4501                	li	a0,0
    80004b06:	e21ff0ef          	jal	80004926 <argfd>
    return -1;
    80004b0a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004b0c:	02054363          	bltz	a0,80004b32 <sys_dup+0x3c>
    80004b10:	ec26                	sd	s1,24(sp)
    80004b12:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004b14:	fd843903          	ld	s2,-40(s0)
    80004b18:	854a                	mv	a0,s2
    80004b1a:	e65ff0ef          	jal	8000497e <fdalloc>
    80004b1e:	84aa                	mv	s1,a0
    return -1;
    80004b20:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004b22:	00054d63          	bltz	a0,80004b3c <sys_dup+0x46>
  filedup(f);
    80004b26:	854a                	mv	a0,s2
    80004b28:	c48ff0ef          	jal	80003f70 <filedup>
  return fd;
    80004b2c:	87a6                	mv	a5,s1
    80004b2e:	64e2                	ld	s1,24(sp)
    80004b30:	6942                	ld	s2,16(sp)
}
    80004b32:	853e                	mv	a0,a5
    80004b34:	70a2                	ld	ra,40(sp)
    80004b36:	7402                	ld	s0,32(sp)
    80004b38:	6145                	addi	sp,sp,48
    80004b3a:	8082                	ret
    80004b3c:	64e2                	ld	s1,24(sp)
    80004b3e:	6942                	ld	s2,16(sp)
    80004b40:	bfcd                	j	80004b32 <sys_dup+0x3c>

0000000080004b42 <sys_read>:
{
    80004b42:	7179                	addi	sp,sp,-48
    80004b44:	f406                	sd	ra,40(sp)
    80004b46:	f022                	sd	s0,32(sp)
    80004b48:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004b4a:	fd840593          	addi	a1,s0,-40
    80004b4e:	4505                	li	a0,1
    80004b50:	da7fd0ef          	jal	800028f6 <argaddr>
  argint(2, &n);
    80004b54:	fe440593          	addi	a1,s0,-28
    80004b58:	4509                	li	a0,2
    80004b5a:	d81fd0ef          	jal	800028da <argint>
  if(argfd(0, 0, &f) < 0)
    80004b5e:	fe840613          	addi	a2,s0,-24
    80004b62:	4581                	li	a1,0
    80004b64:	4501                	li	a0,0
    80004b66:	dc1ff0ef          	jal	80004926 <argfd>
    80004b6a:	87aa                	mv	a5,a0
    return -1;
    80004b6c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b6e:	0007ca63          	bltz	a5,80004b82 <sys_read+0x40>
  return fileread(f, p, n);
    80004b72:	fe442603          	lw	a2,-28(s0)
    80004b76:	fd843583          	ld	a1,-40(s0)
    80004b7a:	fe843503          	ld	a0,-24(s0)
    80004b7e:	d58ff0ef          	jal	800040d6 <fileread>
}
    80004b82:	70a2                	ld	ra,40(sp)
    80004b84:	7402                	ld	s0,32(sp)
    80004b86:	6145                	addi	sp,sp,48
    80004b88:	8082                	ret

0000000080004b8a <sys_write>:
{
    80004b8a:	7179                	addi	sp,sp,-48
    80004b8c:	f406                	sd	ra,40(sp)
    80004b8e:	f022                	sd	s0,32(sp)
    80004b90:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004b92:	fd840593          	addi	a1,s0,-40
    80004b96:	4505                	li	a0,1
    80004b98:	d5ffd0ef          	jal	800028f6 <argaddr>
  argint(2, &n);
    80004b9c:	fe440593          	addi	a1,s0,-28
    80004ba0:	4509                	li	a0,2
    80004ba2:	d39fd0ef          	jal	800028da <argint>
  if(argfd(0, 0, &f) < 0)
    80004ba6:	fe840613          	addi	a2,s0,-24
    80004baa:	4581                	li	a1,0
    80004bac:	4501                	li	a0,0
    80004bae:	d79ff0ef          	jal	80004926 <argfd>
    80004bb2:	87aa                	mv	a5,a0
    return -1;
    80004bb4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004bb6:	0007ca63          	bltz	a5,80004bca <sys_write+0x40>
  return filewrite(f, p, n);
    80004bba:	fe442603          	lw	a2,-28(s0)
    80004bbe:	fd843583          	ld	a1,-40(s0)
    80004bc2:	fe843503          	ld	a0,-24(s0)
    80004bc6:	dceff0ef          	jal	80004194 <filewrite>
}
    80004bca:	70a2                	ld	ra,40(sp)
    80004bcc:	7402                	ld	s0,32(sp)
    80004bce:	6145                	addi	sp,sp,48
    80004bd0:	8082                	ret

0000000080004bd2 <sys_close>:
{
    80004bd2:	1101                	addi	sp,sp,-32
    80004bd4:	ec06                	sd	ra,24(sp)
    80004bd6:	e822                	sd	s0,16(sp)
    80004bd8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004bda:	fe040613          	addi	a2,s0,-32
    80004bde:	fec40593          	addi	a1,s0,-20
    80004be2:	4501                	li	a0,0
    80004be4:	d43ff0ef          	jal	80004926 <argfd>
    return -1;
    80004be8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004bea:	02054063          	bltz	a0,80004c0a <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004bee:	d05fc0ef          	jal	800018f2 <myproc>
    80004bf2:	fec42783          	lw	a5,-20(s0)
    80004bf6:	07e9                	addi	a5,a5,26
    80004bf8:	078e                	slli	a5,a5,0x3
    80004bfa:	953e                	add	a0,a0,a5
    80004bfc:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004c00:	fe043503          	ld	a0,-32(s0)
    80004c04:	bb2ff0ef          	jal	80003fb6 <fileclose>
  return 0;
    80004c08:	4781                	li	a5,0
}
    80004c0a:	853e                	mv	a0,a5
    80004c0c:	60e2                	ld	ra,24(sp)
    80004c0e:	6442                	ld	s0,16(sp)
    80004c10:	6105                	addi	sp,sp,32
    80004c12:	8082                	ret

0000000080004c14 <sys_fstat>:
{
    80004c14:	1101                	addi	sp,sp,-32
    80004c16:	ec06                	sd	ra,24(sp)
    80004c18:	e822                	sd	s0,16(sp)
    80004c1a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004c1c:	fe040593          	addi	a1,s0,-32
    80004c20:	4505                	li	a0,1
    80004c22:	cd5fd0ef          	jal	800028f6 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004c26:	fe840613          	addi	a2,s0,-24
    80004c2a:	4581                	li	a1,0
    80004c2c:	4501                	li	a0,0
    80004c2e:	cf9ff0ef          	jal	80004926 <argfd>
    80004c32:	87aa                	mv	a5,a0
    return -1;
    80004c34:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c36:	0007c863          	bltz	a5,80004c46 <sys_fstat+0x32>
  return filestat(f, st);
    80004c3a:	fe043583          	ld	a1,-32(s0)
    80004c3e:	fe843503          	ld	a0,-24(s0)
    80004c42:	c36ff0ef          	jal	80004078 <filestat>
}
    80004c46:	60e2                	ld	ra,24(sp)
    80004c48:	6442                	ld	s0,16(sp)
    80004c4a:	6105                	addi	sp,sp,32
    80004c4c:	8082                	ret

0000000080004c4e <sys_link>:
{
    80004c4e:	7169                	addi	sp,sp,-304
    80004c50:	f606                	sd	ra,296(sp)
    80004c52:	f222                	sd	s0,288(sp)
    80004c54:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004c56:	08000613          	li	a2,128
    80004c5a:	ed040593          	addi	a1,s0,-304
    80004c5e:	4501                	li	a0,0
    80004c60:	cb3fd0ef          	jal	80002912 <argstr>
    return -1;
    80004c64:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004c66:	0c054e63          	bltz	a0,80004d42 <sys_link+0xf4>
    80004c6a:	08000613          	li	a2,128
    80004c6e:	f5040593          	addi	a1,s0,-176
    80004c72:	4505                	li	a0,1
    80004c74:	c9ffd0ef          	jal	80002912 <argstr>
    return -1;
    80004c78:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004c7a:	0c054463          	bltz	a0,80004d42 <sys_link+0xf4>
    80004c7e:	ee26                	sd	s1,280(sp)
  begin_op();
    80004c80:	f1dfe0ef          	jal	80003b9c <begin_op>
  if((ip = namei(old)) == 0){
    80004c84:	ed040513          	addi	a0,s0,-304
    80004c88:	d59fe0ef          	jal	800039e0 <namei>
    80004c8c:	84aa                	mv	s1,a0
    80004c8e:	c53d                	beqz	a0,80004cfc <sys_link+0xae>
  ilock(ip);
    80004c90:	e76fe0ef          	jal	80003306 <ilock>
  if(ip->type == T_DIR){
    80004c94:	04449703          	lh	a4,68(s1)
    80004c98:	4785                	li	a5,1
    80004c9a:	06f70663          	beq	a4,a5,80004d06 <sys_link+0xb8>
    80004c9e:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004ca0:	04a4d783          	lhu	a5,74(s1)
    80004ca4:	2785                	addiw	a5,a5,1
    80004ca6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004caa:	8526                	mv	a0,s1
    80004cac:	da6fe0ef          	jal	80003252 <iupdate>
  iunlock(ip);
    80004cb0:	8526                	mv	a0,s1
    80004cb2:	f02fe0ef          	jal	800033b4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004cb6:	fd040593          	addi	a1,s0,-48
    80004cba:	f5040513          	addi	a0,s0,-176
    80004cbe:	d3dfe0ef          	jal	800039fa <nameiparent>
    80004cc2:	892a                	mv	s2,a0
    80004cc4:	cd21                	beqz	a0,80004d1c <sys_link+0xce>
  ilock(dp);
    80004cc6:	e40fe0ef          	jal	80003306 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004cca:	00092703          	lw	a4,0(s2)
    80004cce:	409c                	lw	a5,0(s1)
    80004cd0:	04f71363          	bne	a4,a5,80004d16 <sys_link+0xc8>
    80004cd4:	40d0                	lw	a2,4(s1)
    80004cd6:	fd040593          	addi	a1,s0,-48
    80004cda:	854a                	mv	a0,s2
    80004cdc:	c6bfe0ef          	jal	80003946 <dirlink>
    80004ce0:	02054b63          	bltz	a0,80004d16 <sys_link+0xc8>
  iunlockput(dp);
    80004ce4:	854a                	mv	a0,s2
    80004ce6:	82bfe0ef          	jal	80003510 <iunlockput>
  iput(ip);
    80004cea:	8526                	mv	a0,s1
    80004cec:	f9cfe0ef          	jal	80003488 <iput>
  end_op();
    80004cf0:	f17fe0ef          	jal	80003c06 <end_op>
  return 0;
    80004cf4:	4781                	li	a5,0
    80004cf6:	64f2                	ld	s1,280(sp)
    80004cf8:	6952                	ld	s2,272(sp)
    80004cfa:	a0a1                	j	80004d42 <sys_link+0xf4>
    end_op();
    80004cfc:	f0bfe0ef          	jal	80003c06 <end_op>
    return -1;
    80004d00:	57fd                	li	a5,-1
    80004d02:	64f2                	ld	s1,280(sp)
    80004d04:	a83d                	j	80004d42 <sys_link+0xf4>
    iunlockput(ip);
    80004d06:	8526                	mv	a0,s1
    80004d08:	809fe0ef          	jal	80003510 <iunlockput>
    end_op();
    80004d0c:	efbfe0ef          	jal	80003c06 <end_op>
    return -1;
    80004d10:	57fd                	li	a5,-1
    80004d12:	64f2                	ld	s1,280(sp)
    80004d14:	a03d                	j	80004d42 <sys_link+0xf4>
    iunlockput(dp);
    80004d16:	854a                	mv	a0,s2
    80004d18:	ff8fe0ef          	jal	80003510 <iunlockput>
  ilock(ip);
    80004d1c:	8526                	mv	a0,s1
    80004d1e:	de8fe0ef          	jal	80003306 <ilock>
  ip->nlink--;
    80004d22:	04a4d783          	lhu	a5,74(s1)
    80004d26:	37fd                	addiw	a5,a5,-1
    80004d28:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004d2c:	8526                	mv	a0,s1
    80004d2e:	d24fe0ef          	jal	80003252 <iupdate>
  iunlockput(ip);
    80004d32:	8526                	mv	a0,s1
    80004d34:	fdcfe0ef          	jal	80003510 <iunlockput>
  end_op();
    80004d38:	ecffe0ef          	jal	80003c06 <end_op>
  return -1;
    80004d3c:	57fd                	li	a5,-1
    80004d3e:	64f2                	ld	s1,280(sp)
    80004d40:	6952                	ld	s2,272(sp)
}
    80004d42:	853e                	mv	a0,a5
    80004d44:	70b2                	ld	ra,296(sp)
    80004d46:	7412                	ld	s0,288(sp)
    80004d48:	6155                	addi	sp,sp,304
    80004d4a:	8082                	ret

0000000080004d4c <sys_unlink>:
{
    80004d4c:	7151                	addi	sp,sp,-240
    80004d4e:	f586                	sd	ra,232(sp)
    80004d50:	f1a2                	sd	s0,224(sp)
    80004d52:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004d54:	08000613          	li	a2,128
    80004d58:	f3040593          	addi	a1,s0,-208
    80004d5c:	4501                	li	a0,0
    80004d5e:	bb5fd0ef          	jal	80002912 <argstr>
    80004d62:	16054063          	bltz	a0,80004ec2 <sys_unlink+0x176>
    80004d66:	eda6                	sd	s1,216(sp)
  begin_op();
    80004d68:	e35fe0ef          	jal	80003b9c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004d6c:	fb040593          	addi	a1,s0,-80
    80004d70:	f3040513          	addi	a0,s0,-208
    80004d74:	c87fe0ef          	jal	800039fa <nameiparent>
    80004d78:	84aa                	mv	s1,a0
    80004d7a:	c945                	beqz	a0,80004e2a <sys_unlink+0xde>
  ilock(dp);
    80004d7c:	d8afe0ef          	jal	80003306 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004d80:	00003597          	auipc	a1,0x3
    80004d84:	92058593          	addi	a1,a1,-1760 # 800076a0 <etext+0x6a0>
    80004d88:	fb040513          	addi	a0,s0,-80
    80004d8c:	9d9fe0ef          	jal	80003764 <namecmp>
    80004d90:	10050e63          	beqz	a0,80004eac <sys_unlink+0x160>
    80004d94:	00003597          	auipc	a1,0x3
    80004d98:	91458593          	addi	a1,a1,-1772 # 800076a8 <etext+0x6a8>
    80004d9c:	fb040513          	addi	a0,s0,-80
    80004da0:	9c5fe0ef          	jal	80003764 <namecmp>
    80004da4:	10050463          	beqz	a0,80004eac <sys_unlink+0x160>
    80004da8:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004daa:	f2c40613          	addi	a2,s0,-212
    80004dae:	fb040593          	addi	a1,s0,-80
    80004db2:	8526                	mv	a0,s1
    80004db4:	9c7fe0ef          	jal	8000377a <dirlookup>
    80004db8:	892a                	mv	s2,a0
    80004dba:	0e050863          	beqz	a0,80004eaa <sys_unlink+0x15e>
  ilock(ip);
    80004dbe:	d48fe0ef          	jal	80003306 <ilock>
  if(ip->nlink < 1)
    80004dc2:	04a91783          	lh	a5,74(s2)
    80004dc6:	06f05763          	blez	a5,80004e34 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004dca:	04491703          	lh	a4,68(s2)
    80004dce:	4785                	li	a5,1
    80004dd0:	06f70963          	beq	a4,a5,80004e42 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004dd4:	4641                	li	a2,16
    80004dd6:	4581                	li	a1,0
    80004dd8:	fc040513          	addi	a0,s0,-64
    80004ddc:	eedfb0ef          	jal	80000cc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004de0:	4741                	li	a4,16
    80004de2:	f2c42683          	lw	a3,-212(s0)
    80004de6:	fc040613          	addi	a2,s0,-64
    80004dea:	4581                	li	a1,0
    80004dec:	8526                	mv	a0,s1
    80004dee:	869fe0ef          	jal	80003656 <writei>
    80004df2:	47c1                	li	a5,16
    80004df4:	08f51b63          	bne	a0,a5,80004e8a <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004df8:	04491703          	lh	a4,68(s2)
    80004dfc:	4785                	li	a5,1
    80004dfe:	08f70d63          	beq	a4,a5,80004e98 <sys_unlink+0x14c>
  iunlockput(dp);
    80004e02:	8526                	mv	a0,s1
    80004e04:	f0cfe0ef          	jal	80003510 <iunlockput>
  ip->nlink--;
    80004e08:	04a95783          	lhu	a5,74(s2)
    80004e0c:	37fd                	addiw	a5,a5,-1
    80004e0e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004e12:	854a                	mv	a0,s2
    80004e14:	c3efe0ef          	jal	80003252 <iupdate>
  iunlockput(ip);
    80004e18:	854a                	mv	a0,s2
    80004e1a:	ef6fe0ef          	jal	80003510 <iunlockput>
  end_op();
    80004e1e:	de9fe0ef          	jal	80003c06 <end_op>
  return 0;
    80004e22:	4501                	li	a0,0
    80004e24:	64ee                	ld	s1,216(sp)
    80004e26:	694e                	ld	s2,208(sp)
    80004e28:	a849                	j	80004eba <sys_unlink+0x16e>
    end_op();
    80004e2a:	dddfe0ef          	jal	80003c06 <end_op>
    return -1;
    80004e2e:	557d                	li	a0,-1
    80004e30:	64ee                	ld	s1,216(sp)
    80004e32:	a061                	j	80004eba <sys_unlink+0x16e>
    80004e34:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004e36:	00003517          	auipc	a0,0x3
    80004e3a:	87a50513          	addi	a0,a0,-1926 # 800076b0 <etext+0x6b0>
    80004e3e:	957fb0ef          	jal	80000794 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e42:	04c92703          	lw	a4,76(s2)
    80004e46:	02000793          	li	a5,32
    80004e4a:	f8e7f5e3          	bgeu	a5,a4,80004dd4 <sys_unlink+0x88>
    80004e4e:	e5ce                	sd	s3,200(sp)
    80004e50:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e54:	4741                	li	a4,16
    80004e56:	86ce                	mv	a3,s3
    80004e58:	f1840613          	addi	a2,s0,-232
    80004e5c:	4581                	li	a1,0
    80004e5e:	854a                	mv	a0,s2
    80004e60:	efafe0ef          	jal	8000355a <readi>
    80004e64:	47c1                	li	a5,16
    80004e66:	00f51c63          	bne	a0,a5,80004e7e <sys_unlink+0x132>
    if(de.inum != 0)
    80004e6a:	f1845783          	lhu	a5,-232(s0)
    80004e6e:	efa1                	bnez	a5,80004ec6 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e70:	29c1                	addiw	s3,s3,16
    80004e72:	04c92783          	lw	a5,76(s2)
    80004e76:	fcf9efe3          	bltu	s3,a5,80004e54 <sys_unlink+0x108>
    80004e7a:	69ae                	ld	s3,200(sp)
    80004e7c:	bfa1                	j	80004dd4 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004e7e:	00003517          	auipc	a0,0x3
    80004e82:	84a50513          	addi	a0,a0,-1974 # 800076c8 <etext+0x6c8>
    80004e86:	90ffb0ef          	jal	80000794 <panic>
    80004e8a:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004e8c:	00003517          	auipc	a0,0x3
    80004e90:	85450513          	addi	a0,a0,-1964 # 800076e0 <etext+0x6e0>
    80004e94:	901fb0ef          	jal	80000794 <panic>
    dp->nlink--;
    80004e98:	04a4d783          	lhu	a5,74(s1)
    80004e9c:	37fd                	addiw	a5,a5,-1
    80004e9e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ea2:	8526                	mv	a0,s1
    80004ea4:	baefe0ef          	jal	80003252 <iupdate>
    80004ea8:	bfa9                	j	80004e02 <sys_unlink+0xb6>
    80004eaa:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004eac:	8526                	mv	a0,s1
    80004eae:	e62fe0ef          	jal	80003510 <iunlockput>
  end_op();
    80004eb2:	d55fe0ef          	jal	80003c06 <end_op>
  return -1;
    80004eb6:	557d                	li	a0,-1
    80004eb8:	64ee                	ld	s1,216(sp)
}
    80004eba:	70ae                	ld	ra,232(sp)
    80004ebc:	740e                	ld	s0,224(sp)
    80004ebe:	616d                	addi	sp,sp,240
    80004ec0:	8082                	ret
    return -1;
    80004ec2:	557d                	li	a0,-1
    80004ec4:	bfdd                	j	80004eba <sys_unlink+0x16e>
    iunlockput(ip);
    80004ec6:	854a                	mv	a0,s2
    80004ec8:	e48fe0ef          	jal	80003510 <iunlockput>
    goto bad;
    80004ecc:	694e                	ld	s2,208(sp)
    80004ece:	69ae                	ld	s3,200(sp)
    80004ed0:	bff1                	j	80004eac <sys_unlink+0x160>

0000000080004ed2 <sys_open>:

uint64
sys_open(void)
{
    80004ed2:	7131                	addi	sp,sp,-192
    80004ed4:	fd06                	sd	ra,184(sp)
    80004ed6:	f922                	sd	s0,176(sp)
    80004ed8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004eda:	f4c40593          	addi	a1,s0,-180
    80004ede:	4505                	li	a0,1
    80004ee0:	9fbfd0ef          	jal	800028da <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ee4:	08000613          	li	a2,128
    80004ee8:	f5040593          	addi	a1,s0,-176
    80004eec:	4501                	li	a0,0
    80004eee:	a25fd0ef          	jal	80002912 <argstr>
    80004ef2:	87aa                	mv	a5,a0
    return -1;
    80004ef4:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ef6:	0a07c263          	bltz	a5,80004f9a <sys_open+0xc8>
    80004efa:	f526                	sd	s1,168(sp)

  begin_op();
    80004efc:	ca1fe0ef          	jal	80003b9c <begin_op>

  if(omode & O_CREATE){
    80004f00:	f4c42783          	lw	a5,-180(s0)
    80004f04:	2007f793          	andi	a5,a5,512
    80004f08:	c3d5                	beqz	a5,80004fac <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004f0a:	4681                	li	a3,0
    80004f0c:	4601                	li	a2,0
    80004f0e:	4589                	li	a1,2
    80004f10:	f5040513          	addi	a0,s0,-176
    80004f14:	aa9ff0ef          	jal	800049bc <create>
    80004f18:	84aa                	mv	s1,a0
    if(ip == 0){
    80004f1a:	c541                	beqz	a0,80004fa2 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004f1c:	04449703          	lh	a4,68(s1)
    80004f20:	478d                	li	a5,3
    80004f22:	00f71763          	bne	a4,a5,80004f30 <sys_open+0x5e>
    80004f26:	0464d703          	lhu	a4,70(s1)
    80004f2a:	47a5                	li	a5,9
    80004f2c:	0ae7ed63          	bltu	a5,a4,80004fe6 <sys_open+0x114>
    80004f30:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004f32:	fe1fe0ef          	jal	80003f12 <filealloc>
    80004f36:	892a                	mv	s2,a0
    80004f38:	c179                	beqz	a0,80004ffe <sys_open+0x12c>
    80004f3a:	ed4e                	sd	s3,152(sp)
    80004f3c:	a43ff0ef          	jal	8000497e <fdalloc>
    80004f40:	89aa                	mv	s3,a0
    80004f42:	0a054a63          	bltz	a0,80004ff6 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004f46:	04449703          	lh	a4,68(s1)
    80004f4a:	478d                	li	a5,3
    80004f4c:	0cf70263          	beq	a4,a5,80005010 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004f50:	4789                	li	a5,2
    80004f52:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004f56:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004f5a:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004f5e:	f4c42783          	lw	a5,-180(s0)
    80004f62:	0017c713          	xori	a4,a5,1
    80004f66:	8b05                	andi	a4,a4,1
    80004f68:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f6c:	0037f713          	andi	a4,a5,3
    80004f70:	00e03733          	snez	a4,a4
    80004f74:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f78:	4007f793          	andi	a5,a5,1024
    80004f7c:	c791                	beqz	a5,80004f88 <sys_open+0xb6>
    80004f7e:	04449703          	lh	a4,68(s1)
    80004f82:	4789                	li	a5,2
    80004f84:	08f70d63          	beq	a4,a5,8000501e <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004f88:	8526                	mv	a0,s1
    80004f8a:	c2afe0ef          	jal	800033b4 <iunlock>
  end_op();
    80004f8e:	c79fe0ef          	jal	80003c06 <end_op>

  return fd;
    80004f92:	854e                	mv	a0,s3
    80004f94:	74aa                	ld	s1,168(sp)
    80004f96:	790a                	ld	s2,160(sp)
    80004f98:	69ea                	ld	s3,152(sp)
}
    80004f9a:	70ea                	ld	ra,184(sp)
    80004f9c:	744a                	ld	s0,176(sp)
    80004f9e:	6129                	addi	sp,sp,192
    80004fa0:	8082                	ret
      end_op();
    80004fa2:	c65fe0ef          	jal	80003c06 <end_op>
      return -1;
    80004fa6:	557d                	li	a0,-1
    80004fa8:	74aa                	ld	s1,168(sp)
    80004faa:	bfc5                	j	80004f9a <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004fac:	f5040513          	addi	a0,s0,-176
    80004fb0:	a31fe0ef          	jal	800039e0 <namei>
    80004fb4:	84aa                	mv	s1,a0
    80004fb6:	c11d                	beqz	a0,80004fdc <sys_open+0x10a>
    ilock(ip);
    80004fb8:	b4efe0ef          	jal	80003306 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004fbc:	04449703          	lh	a4,68(s1)
    80004fc0:	4785                	li	a5,1
    80004fc2:	f4f71de3          	bne	a4,a5,80004f1c <sys_open+0x4a>
    80004fc6:	f4c42783          	lw	a5,-180(s0)
    80004fca:	d3bd                	beqz	a5,80004f30 <sys_open+0x5e>
      iunlockput(ip);
    80004fcc:	8526                	mv	a0,s1
    80004fce:	d42fe0ef          	jal	80003510 <iunlockput>
      end_op();
    80004fd2:	c35fe0ef          	jal	80003c06 <end_op>
      return -1;
    80004fd6:	557d                	li	a0,-1
    80004fd8:	74aa                	ld	s1,168(sp)
    80004fda:	b7c1                	j	80004f9a <sys_open+0xc8>
      end_op();
    80004fdc:	c2bfe0ef          	jal	80003c06 <end_op>
      return -1;
    80004fe0:	557d                	li	a0,-1
    80004fe2:	74aa                	ld	s1,168(sp)
    80004fe4:	bf5d                	j	80004f9a <sys_open+0xc8>
    iunlockput(ip);
    80004fe6:	8526                	mv	a0,s1
    80004fe8:	d28fe0ef          	jal	80003510 <iunlockput>
    end_op();
    80004fec:	c1bfe0ef          	jal	80003c06 <end_op>
    return -1;
    80004ff0:	557d                	li	a0,-1
    80004ff2:	74aa                	ld	s1,168(sp)
    80004ff4:	b75d                	j	80004f9a <sys_open+0xc8>
      fileclose(f);
    80004ff6:	854a                	mv	a0,s2
    80004ff8:	fbffe0ef          	jal	80003fb6 <fileclose>
    80004ffc:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004ffe:	8526                	mv	a0,s1
    80005000:	d10fe0ef          	jal	80003510 <iunlockput>
    end_op();
    80005004:	c03fe0ef          	jal	80003c06 <end_op>
    return -1;
    80005008:	557d                	li	a0,-1
    8000500a:	74aa                	ld	s1,168(sp)
    8000500c:	790a                	ld	s2,160(sp)
    8000500e:	b771                	j	80004f9a <sys_open+0xc8>
    f->type = FD_DEVICE;
    80005010:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005014:	04649783          	lh	a5,70(s1)
    80005018:	02f91223          	sh	a5,36(s2)
    8000501c:	bf3d                	j	80004f5a <sys_open+0x88>
    itrunc(ip);
    8000501e:	8526                	mv	a0,s1
    80005020:	bd4fe0ef          	jal	800033f4 <itrunc>
    80005024:	b795                	j	80004f88 <sys_open+0xb6>

0000000080005026 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005026:	7175                	addi	sp,sp,-144
    80005028:	e506                	sd	ra,136(sp)
    8000502a:	e122                	sd	s0,128(sp)
    8000502c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000502e:	b6ffe0ef          	jal	80003b9c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005032:	08000613          	li	a2,128
    80005036:	f7040593          	addi	a1,s0,-144
    8000503a:	4501                	li	a0,0
    8000503c:	8d7fd0ef          	jal	80002912 <argstr>
    80005040:	02054363          	bltz	a0,80005066 <sys_mkdir+0x40>
    80005044:	4681                	li	a3,0
    80005046:	4601                	li	a2,0
    80005048:	4585                	li	a1,1
    8000504a:	f7040513          	addi	a0,s0,-144
    8000504e:	96fff0ef          	jal	800049bc <create>
    80005052:	c911                	beqz	a0,80005066 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005054:	cbcfe0ef          	jal	80003510 <iunlockput>
  end_op();
    80005058:	baffe0ef          	jal	80003c06 <end_op>
  return 0;
    8000505c:	4501                	li	a0,0
}
    8000505e:	60aa                	ld	ra,136(sp)
    80005060:	640a                	ld	s0,128(sp)
    80005062:	6149                	addi	sp,sp,144
    80005064:	8082                	ret
    end_op();
    80005066:	ba1fe0ef          	jal	80003c06 <end_op>
    return -1;
    8000506a:	557d                	li	a0,-1
    8000506c:	bfcd                	j	8000505e <sys_mkdir+0x38>

000000008000506e <sys_mknod>:

uint64
sys_mknod(void)
{
    8000506e:	7135                	addi	sp,sp,-160
    80005070:	ed06                	sd	ra,152(sp)
    80005072:	e922                	sd	s0,144(sp)
    80005074:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005076:	b27fe0ef          	jal	80003b9c <begin_op>
  argint(1, &major);
    8000507a:	f6c40593          	addi	a1,s0,-148
    8000507e:	4505                	li	a0,1
    80005080:	85bfd0ef          	jal	800028da <argint>
  argint(2, &minor);
    80005084:	f6840593          	addi	a1,s0,-152
    80005088:	4509                	li	a0,2
    8000508a:	851fd0ef          	jal	800028da <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000508e:	08000613          	li	a2,128
    80005092:	f7040593          	addi	a1,s0,-144
    80005096:	4501                	li	a0,0
    80005098:	87bfd0ef          	jal	80002912 <argstr>
    8000509c:	02054563          	bltz	a0,800050c6 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800050a0:	f6841683          	lh	a3,-152(s0)
    800050a4:	f6c41603          	lh	a2,-148(s0)
    800050a8:	458d                	li	a1,3
    800050aa:	f7040513          	addi	a0,s0,-144
    800050ae:	90fff0ef          	jal	800049bc <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050b2:	c911                	beqz	a0,800050c6 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050b4:	c5cfe0ef          	jal	80003510 <iunlockput>
  end_op();
    800050b8:	b4ffe0ef          	jal	80003c06 <end_op>
  return 0;
    800050bc:	4501                	li	a0,0
}
    800050be:	60ea                	ld	ra,152(sp)
    800050c0:	644a                	ld	s0,144(sp)
    800050c2:	610d                	addi	sp,sp,160
    800050c4:	8082                	ret
    end_op();
    800050c6:	b41fe0ef          	jal	80003c06 <end_op>
    return -1;
    800050ca:	557d                	li	a0,-1
    800050cc:	bfcd                	j	800050be <sys_mknod+0x50>

00000000800050ce <sys_chdir>:

uint64
sys_chdir(void)
{
    800050ce:	7135                	addi	sp,sp,-160
    800050d0:	ed06                	sd	ra,152(sp)
    800050d2:	e922                	sd	s0,144(sp)
    800050d4:	e14a                	sd	s2,128(sp)
    800050d6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800050d8:	81bfc0ef          	jal	800018f2 <myproc>
    800050dc:	892a                	mv	s2,a0
  
  begin_op();
    800050de:	abffe0ef          	jal	80003b9c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800050e2:	08000613          	li	a2,128
    800050e6:	f6040593          	addi	a1,s0,-160
    800050ea:	4501                	li	a0,0
    800050ec:	827fd0ef          	jal	80002912 <argstr>
    800050f0:	04054363          	bltz	a0,80005136 <sys_chdir+0x68>
    800050f4:	e526                	sd	s1,136(sp)
    800050f6:	f6040513          	addi	a0,s0,-160
    800050fa:	8e7fe0ef          	jal	800039e0 <namei>
    800050fe:	84aa                	mv	s1,a0
    80005100:	c915                	beqz	a0,80005134 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005102:	a04fe0ef          	jal	80003306 <ilock>
  if(ip->type != T_DIR){
    80005106:	04449703          	lh	a4,68(s1)
    8000510a:	4785                	li	a5,1
    8000510c:	02f71963          	bne	a4,a5,8000513e <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005110:	8526                	mv	a0,s1
    80005112:	aa2fe0ef          	jal	800033b4 <iunlock>
  iput(p->cwd);
    80005116:	15093503          	ld	a0,336(s2)
    8000511a:	b6efe0ef          	jal	80003488 <iput>
  end_op();
    8000511e:	ae9fe0ef          	jal	80003c06 <end_op>
  p->cwd = ip;
    80005122:	14993823          	sd	s1,336(s2)
  return 0;
    80005126:	4501                	li	a0,0
    80005128:	64aa                	ld	s1,136(sp)
}
    8000512a:	60ea                	ld	ra,152(sp)
    8000512c:	644a                	ld	s0,144(sp)
    8000512e:	690a                	ld	s2,128(sp)
    80005130:	610d                	addi	sp,sp,160
    80005132:	8082                	ret
    80005134:	64aa                	ld	s1,136(sp)
    end_op();
    80005136:	ad1fe0ef          	jal	80003c06 <end_op>
    return -1;
    8000513a:	557d                	li	a0,-1
    8000513c:	b7fd                	j	8000512a <sys_chdir+0x5c>
    iunlockput(ip);
    8000513e:	8526                	mv	a0,s1
    80005140:	bd0fe0ef          	jal	80003510 <iunlockput>
    end_op();
    80005144:	ac3fe0ef          	jal	80003c06 <end_op>
    return -1;
    80005148:	557d                	li	a0,-1
    8000514a:	64aa                	ld	s1,136(sp)
    8000514c:	bff9                	j	8000512a <sys_chdir+0x5c>

000000008000514e <sys_exec>:

uint64
sys_exec(void)
{
    8000514e:	7121                	addi	sp,sp,-448
    80005150:	ff06                	sd	ra,440(sp)
    80005152:	fb22                	sd	s0,432(sp)
    80005154:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005156:	e4840593          	addi	a1,s0,-440
    8000515a:	4505                	li	a0,1
    8000515c:	f9afd0ef          	jal	800028f6 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005160:	08000613          	li	a2,128
    80005164:	f5040593          	addi	a1,s0,-176
    80005168:	4501                	li	a0,0
    8000516a:	fa8fd0ef          	jal	80002912 <argstr>
    8000516e:	87aa                	mv	a5,a0
    return -1;
    80005170:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005172:	0c07c463          	bltz	a5,8000523a <sys_exec+0xec>
    80005176:	f726                	sd	s1,424(sp)
    80005178:	f34a                	sd	s2,416(sp)
    8000517a:	ef4e                	sd	s3,408(sp)
    8000517c:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000517e:	10000613          	li	a2,256
    80005182:	4581                	li	a1,0
    80005184:	e5040513          	addi	a0,s0,-432
    80005188:	b41fb0ef          	jal	80000cc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000518c:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005190:	89a6                	mv	s3,s1
    80005192:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005194:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005198:	00391513          	slli	a0,s2,0x3
    8000519c:	e4040593          	addi	a1,s0,-448
    800051a0:	e4843783          	ld	a5,-440(s0)
    800051a4:	953e                	add	a0,a0,a5
    800051a6:	eaafd0ef          	jal	80002850 <fetchaddr>
    800051aa:	02054663          	bltz	a0,800051d6 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800051ae:	e4043783          	ld	a5,-448(s0)
    800051b2:	c3a9                	beqz	a5,800051f4 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800051b4:	971fb0ef          	jal	80000b24 <kalloc>
    800051b8:	85aa                	mv	a1,a0
    800051ba:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800051be:	cd01                	beqz	a0,800051d6 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800051c0:	6605                	lui	a2,0x1
    800051c2:	e4043503          	ld	a0,-448(s0)
    800051c6:	ed4fd0ef          	jal	8000289a <fetchstr>
    800051ca:	00054663          	bltz	a0,800051d6 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800051ce:	0905                	addi	s2,s2,1
    800051d0:	09a1                	addi	s3,s3,8
    800051d2:	fd4913e3          	bne	s2,s4,80005198 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051d6:	f5040913          	addi	s2,s0,-176
    800051da:	6088                	ld	a0,0(s1)
    800051dc:	c931                	beqz	a0,80005230 <sys_exec+0xe2>
    kfree(argv[i]);
    800051de:	865fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051e2:	04a1                	addi	s1,s1,8
    800051e4:	ff249be3          	bne	s1,s2,800051da <sys_exec+0x8c>
  return -1;
    800051e8:	557d                	li	a0,-1
    800051ea:	74ba                	ld	s1,424(sp)
    800051ec:	791a                	ld	s2,416(sp)
    800051ee:	69fa                	ld	s3,408(sp)
    800051f0:	6a5a                	ld	s4,400(sp)
    800051f2:	a0a1                	j	8000523a <sys_exec+0xec>
      argv[i] = 0;
    800051f4:	0009079b          	sext.w	a5,s2
    800051f8:	078e                	slli	a5,a5,0x3
    800051fa:	fd078793          	addi	a5,a5,-48
    800051fe:	97a2                	add	a5,a5,s0
    80005200:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005204:	e5040593          	addi	a1,s0,-432
    80005208:	f5040513          	addi	a0,s0,-176
    8000520c:	ba8ff0ef          	jal	800045b4 <exec>
    80005210:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005212:	f5040993          	addi	s3,s0,-176
    80005216:	6088                	ld	a0,0(s1)
    80005218:	c511                	beqz	a0,80005224 <sys_exec+0xd6>
    kfree(argv[i]);
    8000521a:	829fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000521e:	04a1                	addi	s1,s1,8
    80005220:	ff349be3          	bne	s1,s3,80005216 <sys_exec+0xc8>
  return ret;
    80005224:	854a                	mv	a0,s2
    80005226:	74ba                	ld	s1,424(sp)
    80005228:	791a                	ld	s2,416(sp)
    8000522a:	69fa                	ld	s3,408(sp)
    8000522c:	6a5a                	ld	s4,400(sp)
    8000522e:	a031                	j	8000523a <sys_exec+0xec>
  return -1;
    80005230:	557d                	li	a0,-1
    80005232:	74ba                	ld	s1,424(sp)
    80005234:	791a                	ld	s2,416(sp)
    80005236:	69fa                	ld	s3,408(sp)
    80005238:	6a5a                	ld	s4,400(sp)
}
    8000523a:	70fa                	ld	ra,440(sp)
    8000523c:	745a                	ld	s0,432(sp)
    8000523e:	6139                	addi	sp,sp,448
    80005240:	8082                	ret

0000000080005242 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005242:	7139                	addi	sp,sp,-64
    80005244:	fc06                	sd	ra,56(sp)
    80005246:	f822                	sd	s0,48(sp)
    80005248:	f426                	sd	s1,40(sp)
    8000524a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000524c:	ea6fc0ef          	jal	800018f2 <myproc>
    80005250:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005252:	fd840593          	addi	a1,s0,-40
    80005256:	4501                	li	a0,0
    80005258:	e9efd0ef          	jal	800028f6 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000525c:	fc840593          	addi	a1,s0,-56
    80005260:	fd040513          	addi	a0,s0,-48
    80005264:	85cff0ef          	jal	800042c0 <pipealloc>
    return -1;
    80005268:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000526a:	0a054463          	bltz	a0,80005312 <sys_pipe+0xd0>
  fd0 = -1;
    8000526e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005272:	fd043503          	ld	a0,-48(s0)
    80005276:	f08ff0ef          	jal	8000497e <fdalloc>
    8000527a:	fca42223          	sw	a0,-60(s0)
    8000527e:	08054163          	bltz	a0,80005300 <sys_pipe+0xbe>
    80005282:	fc843503          	ld	a0,-56(s0)
    80005286:	ef8ff0ef          	jal	8000497e <fdalloc>
    8000528a:	fca42023          	sw	a0,-64(s0)
    8000528e:	06054063          	bltz	a0,800052ee <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005292:	4691                	li	a3,4
    80005294:	fc440613          	addi	a2,s0,-60
    80005298:	fd843583          	ld	a1,-40(s0)
    8000529c:	68a8                	ld	a0,80(s1)
    8000529e:	ab8fc0ef          	jal	80001556 <copyout>
    800052a2:	00054e63          	bltz	a0,800052be <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800052a6:	4691                	li	a3,4
    800052a8:	fc040613          	addi	a2,s0,-64
    800052ac:	fd843583          	ld	a1,-40(s0)
    800052b0:	0591                	addi	a1,a1,4
    800052b2:	68a8                	ld	a0,80(s1)
    800052b4:	aa2fc0ef          	jal	80001556 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800052b8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052ba:	04055c63          	bgez	a0,80005312 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800052be:	fc442783          	lw	a5,-60(s0)
    800052c2:	07e9                	addi	a5,a5,26
    800052c4:	078e                	slli	a5,a5,0x3
    800052c6:	97a6                	add	a5,a5,s1
    800052c8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800052cc:	fc042783          	lw	a5,-64(s0)
    800052d0:	07e9                	addi	a5,a5,26
    800052d2:	078e                	slli	a5,a5,0x3
    800052d4:	94be                	add	s1,s1,a5
    800052d6:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800052da:	fd043503          	ld	a0,-48(s0)
    800052de:	cd9fe0ef          	jal	80003fb6 <fileclose>
    fileclose(wf);
    800052e2:	fc843503          	ld	a0,-56(s0)
    800052e6:	cd1fe0ef          	jal	80003fb6 <fileclose>
    return -1;
    800052ea:	57fd                	li	a5,-1
    800052ec:	a01d                	j	80005312 <sys_pipe+0xd0>
    if(fd0 >= 0)
    800052ee:	fc442783          	lw	a5,-60(s0)
    800052f2:	0007c763          	bltz	a5,80005300 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800052f6:	07e9                	addi	a5,a5,26
    800052f8:	078e                	slli	a5,a5,0x3
    800052fa:	97a6                	add	a5,a5,s1
    800052fc:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005300:	fd043503          	ld	a0,-48(s0)
    80005304:	cb3fe0ef          	jal	80003fb6 <fileclose>
    fileclose(wf);
    80005308:	fc843503          	ld	a0,-56(s0)
    8000530c:	cabfe0ef          	jal	80003fb6 <fileclose>
    return -1;
    80005310:	57fd                	li	a5,-1
}
    80005312:	853e                	mv	a0,a5
    80005314:	70e2                	ld	ra,56(sp)
    80005316:	7442                	ld	s0,48(sp)
    80005318:	74a2                	ld	s1,40(sp)
    8000531a:	6121                	addi	sp,sp,64
    8000531c:	8082                	ret
	...

0000000080005320 <kernelvec>:
    80005320:	7111                	addi	sp,sp,-256
    80005322:	e006                	sd	ra,0(sp)
    80005324:	e40a                	sd	sp,8(sp)
    80005326:	e80e                	sd	gp,16(sp)
    80005328:	ec12                	sd	tp,24(sp)
    8000532a:	f016                	sd	t0,32(sp)
    8000532c:	f41a                	sd	t1,40(sp)
    8000532e:	f81e                	sd	t2,48(sp)
    80005330:	e4aa                	sd	a0,72(sp)
    80005332:	e8ae                	sd	a1,80(sp)
    80005334:	ecb2                	sd	a2,88(sp)
    80005336:	f0b6                	sd	a3,96(sp)
    80005338:	f4ba                	sd	a4,104(sp)
    8000533a:	f8be                	sd	a5,112(sp)
    8000533c:	fcc2                	sd	a6,120(sp)
    8000533e:	e146                	sd	a7,128(sp)
    80005340:	edf2                	sd	t3,216(sp)
    80005342:	f1f6                	sd	t4,224(sp)
    80005344:	f5fa                	sd	t5,232(sp)
    80005346:	f9fe                	sd	t6,240(sp)
    80005348:	c18fd0ef          	jal	80002760 <kerneltrap>
    8000534c:	6082                	ld	ra,0(sp)
    8000534e:	6122                	ld	sp,8(sp)
    80005350:	61c2                	ld	gp,16(sp)
    80005352:	7282                	ld	t0,32(sp)
    80005354:	7322                	ld	t1,40(sp)
    80005356:	73c2                	ld	t2,48(sp)
    80005358:	6526                	ld	a0,72(sp)
    8000535a:	65c6                	ld	a1,80(sp)
    8000535c:	6666                	ld	a2,88(sp)
    8000535e:	7686                	ld	a3,96(sp)
    80005360:	7726                	ld	a4,104(sp)
    80005362:	77c6                	ld	a5,112(sp)
    80005364:	7866                	ld	a6,120(sp)
    80005366:	688a                	ld	a7,128(sp)
    80005368:	6e6e                	ld	t3,216(sp)
    8000536a:	7e8e                	ld	t4,224(sp)
    8000536c:	7f2e                	ld	t5,232(sp)
    8000536e:	7fce                	ld	t6,240(sp)
    80005370:	6111                	addi	sp,sp,256
    80005372:	10200073          	sret
	...

000000008000537e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000537e:	1141                	addi	sp,sp,-16
    80005380:	e422                	sd	s0,8(sp)
    80005382:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005384:	0c0007b7          	lui	a5,0xc000
    80005388:	4705                	li	a4,1
    8000538a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000538c:	0c0007b7          	lui	a5,0xc000
    80005390:	c3d8                	sw	a4,4(a5)
}
    80005392:	6422                	ld	s0,8(sp)
    80005394:	0141                	addi	sp,sp,16
    80005396:	8082                	ret

0000000080005398 <plicinithart>:

void
plicinithart(void)
{
    80005398:	1141                	addi	sp,sp,-16
    8000539a:	e406                	sd	ra,8(sp)
    8000539c:	e022                	sd	s0,0(sp)
    8000539e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053a0:	d26fc0ef          	jal	800018c6 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800053a4:	0085171b          	slliw	a4,a0,0x8
    800053a8:	0c0027b7          	lui	a5,0xc002
    800053ac:	97ba                	add	a5,a5,a4
    800053ae:	40200713          	li	a4,1026
    800053b2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053b6:	00d5151b          	slliw	a0,a0,0xd
    800053ba:	0c2017b7          	lui	a5,0xc201
    800053be:	97aa                	add	a5,a5,a0
    800053c0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800053c4:	60a2                	ld	ra,8(sp)
    800053c6:	6402                	ld	s0,0(sp)
    800053c8:	0141                	addi	sp,sp,16
    800053ca:	8082                	ret

00000000800053cc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800053cc:	1141                	addi	sp,sp,-16
    800053ce:	e406                	sd	ra,8(sp)
    800053d0:	e022                	sd	s0,0(sp)
    800053d2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053d4:	cf2fc0ef          	jal	800018c6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053d8:	00d5151b          	slliw	a0,a0,0xd
    800053dc:	0c2017b7          	lui	a5,0xc201
    800053e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800053e2:	43c8                	lw	a0,4(a5)
    800053e4:	60a2                	ld	ra,8(sp)
    800053e6:	6402                	ld	s0,0(sp)
    800053e8:	0141                	addi	sp,sp,16
    800053ea:	8082                	ret

00000000800053ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053ec:	1101                	addi	sp,sp,-32
    800053ee:	ec06                	sd	ra,24(sp)
    800053f0:	e822                	sd	s0,16(sp)
    800053f2:	e426                	sd	s1,8(sp)
    800053f4:	1000                	addi	s0,sp,32
    800053f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053f8:	ccefc0ef          	jal	800018c6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053fc:	00d5151b          	slliw	a0,a0,0xd
    80005400:	0c2017b7          	lui	a5,0xc201
    80005404:	97aa                	add	a5,a5,a0
    80005406:	c3c4                	sw	s1,4(a5)
}
    80005408:	60e2                	ld	ra,24(sp)
    8000540a:	6442                	ld	s0,16(sp)
    8000540c:	64a2                	ld	s1,8(sp)
    8000540e:	6105                	addi	sp,sp,32
    80005410:	8082                	ret

0000000080005412 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005412:	1141                	addi	sp,sp,-16
    80005414:	e406                	sd	ra,8(sp)
    80005416:	e022                	sd	s0,0(sp)
    80005418:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000541a:	479d                	li	a5,7
    8000541c:	04a7ca63          	blt	a5,a0,80005470 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005420:	0001c797          	auipc	a5,0x1c
    80005424:	bf078793          	addi	a5,a5,-1040 # 80021010 <disk>
    80005428:	97aa                	add	a5,a5,a0
    8000542a:	0187c783          	lbu	a5,24(a5)
    8000542e:	e7b9                	bnez	a5,8000547c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005430:	00451693          	slli	a3,a0,0x4
    80005434:	0001c797          	auipc	a5,0x1c
    80005438:	bdc78793          	addi	a5,a5,-1060 # 80021010 <disk>
    8000543c:	6398                	ld	a4,0(a5)
    8000543e:	9736                	add	a4,a4,a3
    80005440:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005444:	6398                	ld	a4,0(a5)
    80005446:	9736                	add	a4,a4,a3
    80005448:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000544c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005450:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005454:	97aa                	add	a5,a5,a0
    80005456:	4705                	li	a4,1
    80005458:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000545c:	0001c517          	auipc	a0,0x1c
    80005460:	bcc50513          	addi	a0,a0,-1076 # 80021028 <disk+0x18>
    80005464:	8c3fc0ef          	jal	80001d26 <wakeup>
}
    80005468:	60a2                	ld	ra,8(sp)
    8000546a:	6402                	ld	s0,0(sp)
    8000546c:	0141                	addi	sp,sp,16
    8000546e:	8082                	ret
    panic("free_desc 1");
    80005470:	00002517          	auipc	a0,0x2
    80005474:	28050513          	addi	a0,a0,640 # 800076f0 <etext+0x6f0>
    80005478:	b1cfb0ef          	jal	80000794 <panic>
    panic("free_desc 2");
    8000547c:	00002517          	auipc	a0,0x2
    80005480:	28450513          	addi	a0,a0,644 # 80007700 <etext+0x700>
    80005484:	b10fb0ef          	jal	80000794 <panic>

0000000080005488 <virtio_disk_init>:
{
    80005488:	1101                	addi	sp,sp,-32
    8000548a:	ec06                	sd	ra,24(sp)
    8000548c:	e822                	sd	s0,16(sp)
    8000548e:	e426                	sd	s1,8(sp)
    80005490:	e04a                	sd	s2,0(sp)
    80005492:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005494:	00002597          	auipc	a1,0x2
    80005498:	27c58593          	addi	a1,a1,636 # 80007710 <etext+0x710>
    8000549c:	0001c517          	auipc	a0,0x1c
    800054a0:	c9c50513          	addi	a0,a0,-868 # 80021138 <disk+0x128>
    800054a4:	ed0fb0ef          	jal	80000b74 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054a8:	100017b7          	lui	a5,0x10001
    800054ac:	4398                	lw	a4,0(a5)
    800054ae:	2701                	sext.w	a4,a4
    800054b0:	747277b7          	lui	a5,0x74727
    800054b4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054b8:	18f71063          	bne	a4,a5,80005638 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054bc:	100017b7          	lui	a5,0x10001
    800054c0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800054c2:	439c                	lw	a5,0(a5)
    800054c4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054c6:	4709                	li	a4,2
    800054c8:	16e79863          	bne	a5,a4,80005638 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054cc:	100017b7          	lui	a5,0x10001
    800054d0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800054d2:	439c                	lw	a5,0(a5)
    800054d4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054d6:	16e79163          	bne	a5,a4,80005638 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054da:	100017b7          	lui	a5,0x10001
    800054de:	47d8                	lw	a4,12(a5)
    800054e0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054e2:	554d47b7          	lui	a5,0x554d4
    800054e6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054ea:	14f71763          	bne	a4,a5,80005638 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ee:	100017b7          	lui	a5,0x10001
    800054f2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054f6:	4705                	li	a4,1
    800054f8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054fa:	470d                	li	a4,3
    800054fc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054fe:	10001737          	lui	a4,0x10001
    80005502:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005504:	c7ffe737          	lui	a4,0xc7ffe
    80005508:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd60f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000550c:	8ef9                	and	a3,a3,a4
    8000550e:	10001737          	lui	a4,0x10001
    80005512:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005514:	472d                	li	a4,11
    80005516:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005518:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000551c:	439c                	lw	a5,0(a5)
    8000551e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005522:	8ba1                	andi	a5,a5,8
    80005524:	12078063          	beqz	a5,80005644 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005528:	100017b7          	lui	a5,0x10001
    8000552c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005530:	100017b7          	lui	a5,0x10001
    80005534:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005538:	439c                	lw	a5,0(a5)
    8000553a:	2781                	sext.w	a5,a5
    8000553c:	10079a63          	bnez	a5,80005650 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005540:	100017b7          	lui	a5,0x10001
    80005544:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005548:	439c                	lw	a5,0(a5)
    8000554a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000554c:	10078863          	beqz	a5,8000565c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005550:	471d                	li	a4,7
    80005552:	10f77b63          	bgeu	a4,a5,80005668 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005556:	dcefb0ef          	jal	80000b24 <kalloc>
    8000555a:	0001c497          	auipc	s1,0x1c
    8000555e:	ab648493          	addi	s1,s1,-1354 # 80021010 <disk>
    80005562:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005564:	dc0fb0ef          	jal	80000b24 <kalloc>
    80005568:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000556a:	dbafb0ef          	jal	80000b24 <kalloc>
    8000556e:	87aa                	mv	a5,a0
    80005570:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005572:	6088                	ld	a0,0(s1)
    80005574:	10050063          	beqz	a0,80005674 <virtio_disk_init+0x1ec>
    80005578:	0001c717          	auipc	a4,0x1c
    8000557c:	aa073703          	ld	a4,-1376(a4) # 80021018 <disk+0x8>
    80005580:	0e070a63          	beqz	a4,80005674 <virtio_disk_init+0x1ec>
    80005584:	0e078863          	beqz	a5,80005674 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005588:	6605                	lui	a2,0x1
    8000558a:	4581                	li	a1,0
    8000558c:	f3cfb0ef          	jal	80000cc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005590:	0001c497          	auipc	s1,0x1c
    80005594:	a8048493          	addi	s1,s1,-1408 # 80021010 <disk>
    80005598:	6605                	lui	a2,0x1
    8000559a:	4581                	li	a1,0
    8000559c:	6488                	ld	a0,8(s1)
    8000559e:	f2afb0ef          	jal	80000cc8 <memset>
  memset(disk.used, 0, PGSIZE);
    800055a2:	6605                	lui	a2,0x1
    800055a4:	4581                	li	a1,0
    800055a6:	6888                	ld	a0,16(s1)
    800055a8:	f20fb0ef          	jal	80000cc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055ac:	100017b7          	lui	a5,0x10001
    800055b0:	4721                	li	a4,8
    800055b2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800055b4:	4098                	lw	a4,0(s1)
    800055b6:	100017b7          	lui	a5,0x10001
    800055ba:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800055be:	40d8                	lw	a4,4(s1)
    800055c0:	100017b7          	lui	a5,0x10001
    800055c4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800055c8:	649c                	ld	a5,8(s1)
    800055ca:	0007869b          	sext.w	a3,a5
    800055ce:	10001737          	lui	a4,0x10001
    800055d2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800055d6:	9781                	srai	a5,a5,0x20
    800055d8:	10001737          	lui	a4,0x10001
    800055dc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800055e0:	689c                	ld	a5,16(s1)
    800055e2:	0007869b          	sext.w	a3,a5
    800055e6:	10001737          	lui	a4,0x10001
    800055ea:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800055ee:	9781                	srai	a5,a5,0x20
    800055f0:	10001737          	lui	a4,0x10001
    800055f4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800055f8:	10001737          	lui	a4,0x10001
    800055fc:	4785                	li	a5,1
    800055fe:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005600:	00f48c23          	sb	a5,24(s1)
    80005604:	00f48ca3          	sb	a5,25(s1)
    80005608:	00f48d23          	sb	a5,26(s1)
    8000560c:	00f48da3          	sb	a5,27(s1)
    80005610:	00f48e23          	sb	a5,28(s1)
    80005614:	00f48ea3          	sb	a5,29(s1)
    80005618:	00f48f23          	sb	a5,30(s1)
    8000561c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005620:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005624:	100017b7          	lui	a5,0x10001
    80005628:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000562c:	60e2                	ld	ra,24(sp)
    8000562e:	6442                	ld	s0,16(sp)
    80005630:	64a2                	ld	s1,8(sp)
    80005632:	6902                	ld	s2,0(sp)
    80005634:	6105                	addi	sp,sp,32
    80005636:	8082                	ret
    panic("could not find virtio disk");
    80005638:	00002517          	auipc	a0,0x2
    8000563c:	0e850513          	addi	a0,a0,232 # 80007720 <etext+0x720>
    80005640:	954fb0ef          	jal	80000794 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005644:	00002517          	auipc	a0,0x2
    80005648:	0fc50513          	addi	a0,a0,252 # 80007740 <etext+0x740>
    8000564c:	948fb0ef          	jal	80000794 <panic>
    panic("virtio disk should not be ready");
    80005650:	00002517          	auipc	a0,0x2
    80005654:	11050513          	addi	a0,a0,272 # 80007760 <etext+0x760>
    80005658:	93cfb0ef          	jal	80000794 <panic>
    panic("virtio disk has no queue 0");
    8000565c:	00002517          	auipc	a0,0x2
    80005660:	12450513          	addi	a0,a0,292 # 80007780 <etext+0x780>
    80005664:	930fb0ef          	jal	80000794 <panic>
    panic("virtio disk max queue too short");
    80005668:	00002517          	auipc	a0,0x2
    8000566c:	13850513          	addi	a0,a0,312 # 800077a0 <etext+0x7a0>
    80005670:	924fb0ef          	jal	80000794 <panic>
    panic("virtio disk kalloc");
    80005674:	00002517          	auipc	a0,0x2
    80005678:	14c50513          	addi	a0,a0,332 # 800077c0 <etext+0x7c0>
    8000567c:	918fb0ef          	jal	80000794 <panic>

0000000080005680 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005680:	7159                	addi	sp,sp,-112
    80005682:	f486                	sd	ra,104(sp)
    80005684:	f0a2                	sd	s0,96(sp)
    80005686:	eca6                	sd	s1,88(sp)
    80005688:	e8ca                	sd	s2,80(sp)
    8000568a:	e4ce                	sd	s3,72(sp)
    8000568c:	e0d2                	sd	s4,64(sp)
    8000568e:	fc56                	sd	s5,56(sp)
    80005690:	f85a                	sd	s6,48(sp)
    80005692:	f45e                	sd	s7,40(sp)
    80005694:	f062                	sd	s8,32(sp)
    80005696:	ec66                	sd	s9,24(sp)
    80005698:	1880                	addi	s0,sp,112
    8000569a:	8a2a                	mv	s4,a0
    8000569c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000569e:	00c52c83          	lw	s9,12(a0)
    800056a2:	001c9c9b          	slliw	s9,s9,0x1
    800056a6:	1c82                	slli	s9,s9,0x20
    800056a8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800056ac:	0001c517          	auipc	a0,0x1c
    800056b0:	a8c50513          	addi	a0,a0,-1396 # 80021138 <disk+0x128>
    800056b4:	d40fb0ef          	jal	80000bf4 <acquire>
  for(int i = 0; i < 3; i++){
    800056b8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800056ba:	44a1                	li	s1,8
      disk.free[i] = 0;
    800056bc:	0001cb17          	auipc	s6,0x1c
    800056c0:	954b0b13          	addi	s6,s6,-1708 # 80021010 <disk>
  for(int i = 0; i < 3; i++){
    800056c4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056c6:	0001cc17          	auipc	s8,0x1c
    800056ca:	a72c0c13          	addi	s8,s8,-1422 # 80021138 <disk+0x128>
    800056ce:	a8b9                	j	8000572c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    800056d0:	00fb0733          	add	a4,s6,a5
    800056d4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800056d8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800056da:	0207c563          	bltz	a5,80005704 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800056de:	2905                	addiw	s2,s2,1
    800056e0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800056e2:	05590963          	beq	s2,s5,80005734 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    800056e6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800056e8:	0001c717          	auipc	a4,0x1c
    800056ec:	92870713          	addi	a4,a4,-1752 # 80021010 <disk>
    800056f0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800056f2:	01874683          	lbu	a3,24(a4)
    800056f6:	fee9                	bnez	a3,800056d0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    800056f8:	2785                	addiw	a5,a5,1
    800056fa:	0705                	addi	a4,a4,1
    800056fc:	fe979be3          	bne	a5,s1,800056f2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005700:	57fd                	li	a5,-1
    80005702:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005704:	01205d63          	blez	s2,8000571e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005708:	f9042503          	lw	a0,-112(s0)
    8000570c:	d07ff0ef          	jal	80005412 <free_desc>
      for(int j = 0; j < i; j++)
    80005710:	4785                	li	a5,1
    80005712:	0127d663          	bge	a5,s2,8000571e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005716:	f9442503          	lw	a0,-108(s0)
    8000571a:	cf9ff0ef          	jal	80005412 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000571e:	85e2                	mv	a1,s8
    80005720:	0001c517          	auipc	a0,0x1c
    80005724:	90850513          	addi	a0,a0,-1784 # 80021028 <disk+0x18>
    80005728:	db2fc0ef          	jal	80001cda <sleep>
  for(int i = 0; i < 3; i++){
    8000572c:	f9040613          	addi	a2,s0,-112
    80005730:	894e                	mv	s2,s3
    80005732:	bf55                	j	800056e6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005734:	f9042503          	lw	a0,-112(s0)
    80005738:	00451693          	slli	a3,a0,0x4

  if(write)
    8000573c:	0001c797          	auipc	a5,0x1c
    80005740:	8d478793          	addi	a5,a5,-1836 # 80021010 <disk>
    80005744:	00a50713          	addi	a4,a0,10
    80005748:	0712                	slli	a4,a4,0x4
    8000574a:	973e                	add	a4,a4,a5
    8000574c:	01703633          	snez	a2,s7
    80005750:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005752:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005756:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000575a:	6398                	ld	a4,0(a5)
    8000575c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000575e:	0a868613          	addi	a2,a3,168
    80005762:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005764:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005766:	6390                	ld	a2,0(a5)
    80005768:	00d605b3          	add	a1,a2,a3
    8000576c:	4741                	li	a4,16
    8000576e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005770:	4805                	li	a6,1
    80005772:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005776:	f9442703          	lw	a4,-108(s0)
    8000577a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000577e:	0712                	slli	a4,a4,0x4
    80005780:	963a                	add	a2,a2,a4
    80005782:	058a0593          	addi	a1,s4,88
    80005786:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005788:	0007b883          	ld	a7,0(a5)
    8000578c:	9746                	add	a4,a4,a7
    8000578e:	40000613          	li	a2,1024
    80005792:	c710                	sw	a2,8(a4)
  if(write)
    80005794:	001bb613          	seqz	a2,s7
    80005798:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000579c:	00166613          	ori	a2,a2,1
    800057a0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800057a4:	f9842583          	lw	a1,-104(s0)
    800057a8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800057ac:	00250613          	addi	a2,a0,2
    800057b0:	0612                	slli	a2,a2,0x4
    800057b2:	963e                	add	a2,a2,a5
    800057b4:	577d                	li	a4,-1
    800057b6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800057ba:	0592                	slli	a1,a1,0x4
    800057bc:	98ae                	add	a7,a7,a1
    800057be:	03068713          	addi	a4,a3,48
    800057c2:	973e                	add	a4,a4,a5
    800057c4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800057c8:	6398                	ld	a4,0(a5)
    800057ca:	972e                	add	a4,a4,a1
    800057cc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057d0:	4689                	li	a3,2
    800057d2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800057d6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057da:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    800057de:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057e2:	6794                	ld	a3,8(a5)
    800057e4:	0026d703          	lhu	a4,2(a3)
    800057e8:	8b1d                	andi	a4,a4,7
    800057ea:	0706                	slli	a4,a4,0x1
    800057ec:	96ba                	add	a3,a3,a4
    800057ee:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800057f2:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057f6:	6798                	ld	a4,8(a5)
    800057f8:	00275783          	lhu	a5,2(a4)
    800057fc:	2785                	addiw	a5,a5,1
    800057fe:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005802:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005806:	100017b7          	lui	a5,0x10001
    8000580a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000580e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005812:	0001c917          	auipc	s2,0x1c
    80005816:	92690913          	addi	s2,s2,-1754 # 80021138 <disk+0x128>
  while(b->disk == 1) {
    8000581a:	4485                	li	s1,1
    8000581c:	01079a63          	bne	a5,a6,80005830 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005820:	85ca                	mv	a1,s2
    80005822:	8552                	mv	a0,s4
    80005824:	cb6fc0ef          	jal	80001cda <sleep>
  while(b->disk == 1) {
    80005828:	004a2783          	lw	a5,4(s4)
    8000582c:	fe978ae3          	beq	a5,s1,80005820 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005830:	f9042903          	lw	s2,-112(s0)
    80005834:	00290713          	addi	a4,s2,2
    80005838:	0712                	slli	a4,a4,0x4
    8000583a:	0001b797          	auipc	a5,0x1b
    8000583e:	7d678793          	addi	a5,a5,2006 # 80021010 <disk>
    80005842:	97ba                	add	a5,a5,a4
    80005844:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005848:	0001b997          	auipc	s3,0x1b
    8000584c:	7c898993          	addi	s3,s3,1992 # 80021010 <disk>
    80005850:	00491713          	slli	a4,s2,0x4
    80005854:	0009b783          	ld	a5,0(s3)
    80005858:	97ba                	add	a5,a5,a4
    8000585a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000585e:	854a                	mv	a0,s2
    80005860:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005864:	bafff0ef          	jal	80005412 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005868:	8885                	andi	s1,s1,1
    8000586a:	f0fd                	bnez	s1,80005850 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000586c:	0001c517          	auipc	a0,0x1c
    80005870:	8cc50513          	addi	a0,a0,-1844 # 80021138 <disk+0x128>
    80005874:	c18fb0ef          	jal	80000c8c <release>
}
    80005878:	70a6                	ld	ra,104(sp)
    8000587a:	7406                	ld	s0,96(sp)
    8000587c:	64e6                	ld	s1,88(sp)
    8000587e:	6946                	ld	s2,80(sp)
    80005880:	69a6                	ld	s3,72(sp)
    80005882:	6a06                	ld	s4,64(sp)
    80005884:	7ae2                	ld	s5,56(sp)
    80005886:	7b42                	ld	s6,48(sp)
    80005888:	7ba2                	ld	s7,40(sp)
    8000588a:	7c02                	ld	s8,32(sp)
    8000588c:	6ce2                	ld	s9,24(sp)
    8000588e:	6165                	addi	sp,sp,112
    80005890:	8082                	ret

0000000080005892 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005892:	1101                	addi	sp,sp,-32
    80005894:	ec06                	sd	ra,24(sp)
    80005896:	e822                	sd	s0,16(sp)
    80005898:	e426                	sd	s1,8(sp)
    8000589a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000589c:	0001b497          	auipc	s1,0x1b
    800058a0:	77448493          	addi	s1,s1,1908 # 80021010 <disk>
    800058a4:	0001c517          	auipc	a0,0x1c
    800058a8:	89450513          	addi	a0,a0,-1900 # 80021138 <disk+0x128>
    800058ac:	b48fb0ef          	jal	80000bf4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058b0:	100017b7          	lui	a5,0x10001
    800058b4:	53b8                	lw	a4,96(a5)
    800058b6:	8b0d                	andi	a4,a4,3
    800058b8:	100017b7          	lui	a5,0x10001
    800058bc:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800058be:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058c2:	689c                	ld	a5,16(s1)
    800058c4:	0204d703          	lhu	a4,32(s1)
    800058c8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800058cc:	04f70663          	beq	a4,a5,80005918 <virtio_disk_intr+0x86>
    __sync_synchronize();
    800058d0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058d4:	6898                	ld	a4,16(s1)
    800058d6:	0204d783          	lhu	a5,32(s1)
    800058da:	8b9d                	andi	a5,a5,7
    800058dc:	078e                	slli	a5,a5,0x3
    800058de:	97ba                	add	a5,a5,a4
    800058e0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058e2:	00278713          	addi	a4,a5,2
    800058e6:	0712                	slli	a4,a4,0x4
    800058e8:	9726                	add	a4,a4,s1
    800058ea:	01074703          	lbu	a4,16(a4)
    800058ee:	e321                	bnez	a4,8000592e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058f0:	0789                	addi	a5,a5,2
    800058f2:	0792                	slli	a5,a5,0x4
    800058f4:	97a6                	add	a5,a5,s1
    800058f6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800058f8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058fc:	c2afc0ef          	jal	80001d26 <wakeup>

    disk.used_idx += 1;
    80005900:	0204d783          	lhu	a5,32(s1)
    80005904:	2785                	addiw	a5,a5,1
    80005906:	17c2                	slli	a5,a5,0x30
    80005908:	93c1                	srli	a5,a5,0x30
    8000590a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000590e:	6898                	ld	a4,16(s1)
    80005910:	00275703          	lhu	a4,2(a4)
    80005914:	faf71ee3          	bne	a4,a5,800058d0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005918:	0001c517          	auipc	a0,0x1c
    8000591c:	82050513          	addi	a0,a0,-2016 # 80021138 <disk+0x128>
    80005920:	b6cfb0ef          	jal	80000c8c <release>
}
    80005924:	60e2                	ld	ra,24(sp)
    80005926:	6442                	ld	s0,16(sp)
    80005928:	64a2                	ld	s1,8(sp)
    8000592a:	6105                	addi	sp,sp,32
    8000592c:	8082                	ret
      panic("virtio_disk_intr status");
    8000592e:	00002517          	auipc	a0,0x2
    80005932:	eaa50513          	addi	a0,a0,-342 # 800077d8 <etext+0x7d8>
    80005936:	e5ffa0ef          	jal	80000794 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
