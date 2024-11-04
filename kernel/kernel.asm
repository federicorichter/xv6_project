
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
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd6bf>
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
    800000fa:	6e5010ef          	jal	80001fde <either_copyin>
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
    80000184:	4ed010ef          	jal	80001e70 <killed>
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
    800001d2:	5c3010ef          	jal	80001f94 <either_copyout>
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
    800002a0:	589010ef          	jal	80002028 <procdump>
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
    80000410:	b9c78793          	addi	a5,a5,-1124 # 8001ffa8 <devsw>
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
    80000a5a:	6ea78793          	addi	a5,a5,1770 # 80021140 <end>
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
    80000b14:	63050513          	addi	a0,a0,1584 # 80021140 <end>
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
    80000d3c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffddec1>
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
    80000e98:	716010ef          	jal	800025ae <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e9c:	59c040ef          	jal	80005438 <plicinithart>
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
    80000ee0:	6aa010ef          	jal	8000258a <trapinit>
    trapinithart();  // install kernel trap vector
    80000ee4:	6ca010ef          	jal	800025ae <trapinithart>
    plicinit();      // set up interrupt controller
    80000ee8:	536040ef          	jal	8000541e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000eec:	54c040ef          	jal	80005438 <plicinithart>
    binit();         // buffer cache
    80000ef0:	4f1010ef          	jal	80002be0 <binit>
    iinit();         // inode table
    80000ef4:	2e2020ef          	jal	800031d6 <iinit>
    fileinit();      // file table
    80000ef8:	08e030ef          	jal	80003f86 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efc:	62c040ef          	jal	80005528 <virtio_disk_init>
    init_priority_control();
    80000f00:	1cc010ef          	jal	800020cc <init_priority_control>
    userinit();      // first user process
    80000f04:	356010ef          	jal	8000225a <userinit>
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
    80000f94:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffddeb7>
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
    80001784:	7e048493          	addi	s1,s1,2016 # 8000ff60 <proc>
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
    800017b0:	5b4a8a93          	addi	s5,s5,1460 # 80015d60 <tickslock>
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
    80001844:	72048493          	addi	s1,s1,1824 # 8000ff60 <proc>
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
    8000187a:	4eaa0a13          	addi	s4,s4,1258 # 80015d60 <tickslock>
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
    8000193c:	48b000ef          	jal	800025c6 <usertrapret>
}
    80001940:	60a2                	ld	ra,8(sp)
    80001942:	6402                	ld	s0,0(sp)
    80001944:	0141                	addi	sp,sp,16
    80001946:	8082                	ret
    fsinit(ROOTDEV);
    80001948:	4505                	li	a0,1
    8000194a:	021010ef          	jal	8000316a <fsinit>
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
    80001b58:	20c98993          	addi	s3,s3,524 # 80015d60 <tickslock>
    80001b5c:	a8b5                	j	80001bd8 <scheduler+0xd4>
        p->state = RUNNING;
    80001b5e:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001b62:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001b66:	060a8593          	addi	a1,s5,96
    80001b6a:	855e                	mv	a0,s7
    80001b6c:	1b5000ef          	jal	80002520 <swtch>
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
    80001bea:	37a48493          	addi	s1,s1,890 # 8000ff60 <proc>
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
    80001c60:	0c1000ef          	jal	80002520 <swtch>
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
    80001d3e:	22648493          	addi	s1,s1,550 # 8000ff60 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001d42:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001d44:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d46:	00014917          	auipc	s2,0x14
    80001d4a:	01a90913          	addi	s2,s2,26 # 80015d60 <tickslock>
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
    80001da6:	1be48493          	addi	s1,s1,446 # 8000ff60 <proc>
      pp->parent = initproc;
    80001daa:	00006a17          	auipc	s4,0x6
    80001dae:	bcea0a13          	addi	s4,s4,-1074 # 80007978 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001db2:	00014997          	auipc	s3,0x14
    80001db6:	fae98993          	addi	s3,s3,-82 # 80015d60 <tickslock>
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

0000000080001de6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001de6:	7179                	addi	sp,sp,-48
    80001de8:	f406                	sd	ra,40(sp)
    80001dea:	f022                	sd	s0,32(sp)
    80001dec:	ec26                	sd	s1,24(sp)
    80001dee:	e84a                	sd	s2,16(sp)
    80001df0:	e44e                	sd	s3,8(sp)
    80001df2:	1800                	addi	s0,sp,48
    80001df4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001df6:	0000e497          	auipc	s1,0xe
    80001dfa:	16a48493          	addi	s1,s1,362 # 8000ff60 <proc>
    80001dfe:	00014997          	auipc	s3,0x14
    80001e02:	f6298993          	addi	s3,s3,-158 # 80015d60 <tickslock>
    acquire(&p->lock);
    80001e06:	8526                	mv	a0,s1
    80001e08:	dedfe0ef          	jal	80000bf4 <acquire>
    if(p->pid == pid){
    80001e0c:	589c                	lw	a5,48(s1)
    80001e0e:	01278b63          	beq	a5,s2,80001e24 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001e12:	8526                	mv	a0,s1
    80001e14:	e79fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001e18:	17848493          	addi	s1,s1,376
    80001e1c:	ff3495e3          	bne	s1,s3,80001e06 <kill+0x20>
  }
  return -1;
    80001e20:	557d                	li	a0,-1
    80001e22:	a819                	j	80001e38 <kill+0x52>
      p->killed = 1;
    80001e24:	4785                	li	a5,1
    80001e26:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001e28:	4c98                	lw	a4,24(s1)
    80001e2a:	4789                	li	a5,2
    80001e2c:	00f70d63          	beq	a4,a5,80001e46 <kill+0x60>
      release(&p->lock);
    80001e30:	8526                	mv	a0,s1
    80001e32:	e5bfe0ef          	jal	80000c8c <release>
      return 0;
    80001e36:	4501                	li	a0,0
}
    80001e38:	70a2                	ld	ra,40(sp)
    80001e3a:	7402                	ld	s0,32(sp)
    80001e3c:	64e2                	ld	s1,24(sp)
    80001e3e:	6942                	ld	s2,16(sp)
    80001e40:	69a2                	ld	s3,8(sp)
    80001e42:	6145                	addi	sp,sp,48
    80001e44:	8082                	ret
        p->state = RUNNABLE;
    80001e46:	478d                	li	a5,3
    80001e48:	cc9c                	sw	a5,24(s1)
    80001e4a:	b7dd                	j	80001e30 <kill+0x4a>

0000000080001e4c <setkilled>:

void
setkilled(struct proc *p)
{
    80001e4c:	1101                	addi	sp,sp,-32
    80001e4e:	ec06                	sd	ra,24(sp)
    80001e50:	e822                	sd	s0,16(sp)
    80001e52:	e426                	sd	s1,8(sp)
    80001e54:	1000                	addi	s0,sp,32
    80001e56:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001e58:	d9dfe0ef          	jal	80000bf4 <acquire>
  p->killed = 1;
    80001e5c:	4785                	li	a5,1
    80001e5e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001e60:	8526                	mv	a0,s1
    80001e62:	e2bfe0ef          	jal	80000c8c <release>
}
    80001e66:	60e2                	ld	ra,24(sp)
    80001e68:	6442                	ld	s0,16(sp)
    80001e6a:	64a2                	ld	s1,8(sp)
    80001e6c:	6105                	addi	sp,sp,32
    80001e6e:	8082                	ret

0000000080001e70 <killed>:

int
killed(struct proc *p)
{
    80001e70:	1101                	addi	sp,sp,-32
    80001e72:	ec06                	sd	ra,24(sp)
    80001e74:	e822                	sd	s0,16(sp)
    80001e76:	e426                	sd	s1,8(sp)
    80001e78:	e04a                	sd	s2,0(sp)
    80001e7a:	1000                	addi	s0,sp,32
    80001e7c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001e7e:	d77fe0ef          	jal	80000bf4 <acquire>
  k = p->killed;
    80001e82:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001e86:	8526                	mv	a0,s1
    80001e88:	e05fe0ef          	jal	80000c8c <release>
  return k;
}
    80001e8c:	854a                	mv	a0,s2
    80001e8e:	60e2                	ld	ra,24(sp)
    80001e90:	6442                	ld	s0,16(sp)
    80001e92:	64a2                	ld	s1,8(sp)
    80001e94:	6902                	ld	s2,0(sp)
    80001e96:	6105                	addi	sp,sp,32
    80001e98:	8082                	ret

0000000080001e9a <wait>:
{
    80001e9a:	715d                	addi	sp,sp,-80
    80001e9c:	e486                	sd	ra,72(sp)
    80001e9e:	e0a2                	sd	s0,64(sp)
    80001ea0:	fc26                	sd	s1,56(sp)
    80001ea2:	f84a                	sd	s2,48(sp)
    80001ea4:	f44e                	sd	s3,40(sp)
    80001ea6:	f052                	sd	s4,32(sp)
    80001ea8:	ec56                	sd	s5,24(sp)
    80001eaa:	e85a                	sd	s6,16(sp)
    80001eac:	e45e                	sd	s7,8(sp)
    80001eae:	e062                	sd	s8,0(sp)
    80001eb0:	0880                	addi	s0,sp,80
    80001eb2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001eb4:	a3fff0ef          	jal	800018f2 <myproc>
    80001eb8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001eba:	0000e517          	auipc	a0,0xe
    80001ebe:	c0e50513          	addi	a0,a0,-1010 # 8000fac8 <wait_lock>
    80001ec2:	d33fe0ef          	jal	80000bf4 <acquire>
    havekids = 0;
    80001ec6:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001ec8:	4a15                	li	s4,5
        havekids = 1;
    80001eca:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ecc:	00014997          	auipc	s3,0x14
    80001ed0:	e9498993          	addi	s3,s3,-364 # 80015d60 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001ed4:	0000ec17          	auipc	s8,0xe
    80001ed8:	bf4c0c13          	addi	s8,s8,-1036 # 8000fac8 <wait_lock>
    80001edc:	a871                	j	80001f78 <wait+0xde>
          pid = pp->pid;
    80001ede:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001ee2:	000b0c63          	beqz	s6,80001efa <wait+0x60>
    80001ee6:	4691                	li	a3,4
    80001ee8:	02c48613          	addi	a2,s1,44
    80001eec:	85da                	mv	a1,s6
    80001eee:	05093503          	ld	a0,80(s2)
    80001ef2:	e64ff0ef          	jal	80001556 <copyout>
    80001ef6:	02054b63          	bltz	a0,80001f2c <wait+0x92>
          freeproc(pp);
    80001efa:	8526                	mv	a0,s1
    80001efc:	b69ff0ef          	jal	80001a64 <freeproc>
          release(&pp->lock);
    80001f00:	8526                	mv	a0,s1
    80001f02:	d8bfe0ef          	jal	80000c8c <release>
          release(&wait_lock);
    80001f06:	0000e517          	auipc	a0,0xe
    80001f0a:	bc250513          	addi	a0,a0,-1086 # 8000fac8 <wait_lock>
    80001f0e:	d7ffe0ef          	jal	80000c8c <release>
}
    80001f12:	854e                	mv	a0,s3
    80001f14:	60a6                	ld	ra,72(sp)
    80001f16:	6406                	ld	s0,64(sp)
    80001f18:	74e2                	ld	s1,56(sp)
    80001f1a:	7942                	ld	s2,48(sp)
    80001f1c:	79a2                	ld	s3,40(sp)
    80001f1e:	7a02                	ld	s4,32(sp)
    80001f20:	6ae2                	ld	s5,24(sp)
    80001f22:	6b42                	ld	s6,16(sp)
    80001f24:	6ba2                	ld	s7,8(sp)
    80001f26:	6c02                	ld	s8,0(sp)
    80001f28:	6161                	addi	sp,sp,80
    80001f2a:	8082                	ret
            release(&pp->lock);
    80001f2c:	8526                	mv	a0,s1
    80001f2e:	d5ffe0ef          	jal	80000c8c <release>
            release(&wait_lock);
    80001f32:	0000e517          	auipc	a0,0xe
    80001f36:	b9650513          	addi	a0,a0,-1130 # 8000fac8 <wait_lock>
    80001f3a:	d53fe0ef          	jal	80000c8c <release>
            return -1;
    80001f3e:	59fd                	li	s3,-1
    80001f40:	bfc9                	j	80001f12 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f42:	17848493          	addi	s1,s1,376
    80001f46:	03348063          	beq	s1,s3,80001f66 <wait+0xcc>
      if(pp->parent == p){
    80001f4a:	7c9c                	ld	a5,56(s1)
    80001f4c:	ff279be3          	bne	a5,s2,80001f42 <wait+0xa8>
        acquire(&pp->lock);
    80001f50:	8526                	mv	a0,s1
    80001f52:	ca3fe0ef          	jal	80000bf4 <acquire>
        if(pp->state == ZOMBIE){
    80001f56:	4c9c                	lw	a5,24(s1)
    80001f58:	f94783e3          	beq	a5,s4,80001ede <wait+0x44>
        release(&pp->lock);
    80001f5c:	8526                	mv	a0,s1
    80001f5e:	d2ffe0ef          	jal	80000c8c <release>
        havekids = 1;
    80001f62:	8756                	mv	a4,s5
    80001f64:	bff9                	j	80001f42 <wait+0xa8>
    if(!havekids || killed(p)){
    80001f66:	cf19                	beqz	a4,80001f84 <wait+0xea>
    80001f68:	854a                	mv	a0,s2
    80001f6a:	f07ff0ef          	jal	80001e70 <killed>
    80001f6e:	e919                	bnez	a0,80001f84 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001f70:	85e2                	mv	a1,s8
    80001f72:	854a                	mv	a0,s2
    80001f74:	d67ff0ef          	jal	80001cda <sleep>
    havekids = 0;
    80001f78:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f7a:	0000e497          	auipc	s1,0xe
    80001f7e:	fe648493          	addi	s1,s1,-26 # 8000ff60 <proc>
    80001f82:	b7e1                	j	80001f4a <wait+0xb0>
      release(&wait_lock);
    80001f84:	0000e517          	auipc	a0,0xe
    80001f88:	b4450513          	addi	a0,a0,-1212 # 8000fac8 <wait_lock>
    80001f8c:	d01fe0ef          	jal	80000c8c <release>
      return -1;
    80001f90:	59fd                	li	s3,-1
    80001f92:	b741                	j	80001f12 <wait+0x78>

0000000080001f94 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001f94:	7179                	addi	sp,sp,-48
    80001f96:	f406                	sd	ra,40(sp)
    80001f98:	f022                	sd	s0,32(sp)
    80001f9a:	ec26                	sd	s1,24(sp)
    80001f9c:	e84a                	sd	s2,16(sp)
    80001f9e:	e44e                	sd	s3,8(sp)
    80001fa0:	e052                	sd	s4,0(sp)
    80001fa2:	1800                	addi	s0,sp,48
    80001fa4:	84aa                	mv	s1,a0
    80001fa6:	892e                	mv	s2,a1
    80001fa8:	89b2                	mv	s3,a2
    80001faa:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001fac:	947ff0ef          	jal	800018f2 <myproc>
  if(user_dst){
    80001fb0:	cc99                	beqz	s1,80001fce <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001fb2:	86d2                	mv	a3,s4
    80001fb4:	864e                	mv	a2,s3
    80001fb6:	85ca                	mv	a1,s2
    80001fb8:	6928                	ld	a0,80(a0)
    80001fba:	d9cff0ef          	jal	80001556 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001fbe:	70a2                	ld	ra,40(sp)
    80001fc0:	7402                	ld	s0,32(sp)
    80001fc2:	64e2                	ld	s1,24(sp)
    80001fc4:	6942                	ld	s2,16(sp)
    80001fc6:	69a2                	ld	s3,8(sp)
    80001fc8:	6a02                	ld	s4,0(sp)
    80001fca:	6145                	addi	sp,sp,48
    80001fcc:	8082                	ret
    memmove((char *)dst, src, len);
    80001fce:	000a061b          	sext.w	a2,s4
    80001fd2:	85ce                	mv	a1,s3
    80001fd4:	854a                	mv	a0,s2
    80001fd6:	d4ffe0ef          	jal	80000d24 <memmove>
    return 0;
    80001fda:	8526                	mv	a0,s1
    80001fdc:	b7cd                	j	80001fbe <either_copyout+0x2a>

0000000080001fde <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001fde:	7179                	addi	sp,sp,-48
    80001fe0:	f406                	sd	ra,40(sp)
    80001fe2:	f022                	sd	s0,32(sp)
    80001fe4:	ec26                	sd	s1,24(sp)
    80001fe6:	e84a                	sd	s2,16(sp)
    80001fe8:	e44e                	sd	s3,8(sp)
    80001fea:	e052                	sd	s4,0(sp)
    80001fec:	1800                	addi	s0,sp,48
    80001fee:	892a                	mv	s2,a0
    80001ff0:	84ae                	mv	s1,a1
    80001ff2:	89b2                	mv	s3,a2
    80001ff4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ff6:	8fdff0ef          	jal	800018f2 <myproc>
  if(user_src){
    80001ffa:	cc99                	beqz	s1,80002018 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001ffc:	86d2                	mv	a3,s4
    80001ffe:	864e                	mv	a2,s3
    80002000:	85ca                	mv	a1,s2
    80002002:	6928                	ld	a0,80(a0)
    80002004:	e28ff0ef          	jal	8000162c <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002008:	70a2                	ld	ra,40(sp)
    8000200a:	7402                	ld	s0,32(sp)
    8000200c:	64e2                	ld	s1,24(sp)
    8000200e:	6942                	ld	s2,16(sp)
    80002010:	69a2                	ld	s3,8(sp)
    80002012:	6a02                	ld	s4,0(sp)
    80002014:	6145                	addi	sp,sp,48
    80002016:	8082                	ret
    memmove(dst, (char*)src, len);
    80002018:	000a061b          	sext.w	a2,s4
    8000201c:	85ce                	mv	a1,s3
    8000201e:	854a                	mv	a0,s2
    80002020:	d05fe0ef          	jal	80000d24 <memmove>
    return 0;
    80002024:	8526                	mv	a0,s1
    80002026:	b7cd                	j	80002008 <either_copyin+0x2a>

0000000080002028 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002028:	715d                	addi	sp,sp,-80
    8000202a:	e486                	sd	ra,72(sp)
    8000202c:	e0a2                	sd	s0,64(sp)
    8000202e:	fc26                	sd	s1,56(sp)
    80002030:	f84a                	sd	s2,48(sp)
    80002032:	f44e                	sd	s3,40(sp)
    80002034:	f052                	sd	s4,32(sp)
    80002036:	ec56                	sd	s5,24(sp)
    80002038:	e85a                	sd	s6,16(sp)
    8000203a:	e45e                	sd	s7,8(sp)
    8000203c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000203e:	00005517          	auipc	a0,0x5
    80002042:	03a50513          	addi	a0,a0,58 # 80007078 <etext+0x78>
    80002046:	c7cfe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000204a:	0000e497          	auipc	s1,0xe
    8000204e:	06e48493          	addi	s1,s1,110 # 800100b8 <proc+0x158>
    80002052:	00014917          	auipc	s2,0x14
    80002056:	e6690913          	addi	s2,s2,-410 # 80015eb8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000205a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000205c:	00005997          	auipc	s3,0x5
    80002060:	26498993          	addi	s3,s3,612 # 800072c0 <etext+0x2c0>
    printf("%d %s %s", p->pid, state, p->name);
    80002064:	00005a97          	auipc	s5,0x5
    80002068:	264a8a93          	addi	s5,s5,612 # 800072c8 <etext+0x2c8>
    printf("\n");
    8000206c:	00005a17          	auipc	s4,0x5
    80002070:	00ca0a13          	addi	s4,s4,12 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002074:	00005b97          	auipc	s7,0x5
    80002078:	794b8b93          	addi	s7,s7,1940 # 80007808 <states.0>
    8000207c:	a829                	j	80002096 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000207e:	ed86a583          	lw	a1,-296(a3)
    80002082:	8556                	mv	a0,s5
    80002084:	c3efe0ef          	jal	800004c2 <printf>
    printf("\n");
    80002088:	8552                	mv	a0,s4
    8000208a:	c38fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000208e:	17848493          	addi	s1,s1,376
    80002092:	03248263          	beq	s1,s2,800020b6 <procdump+0x8e>
    if(p->state == UNUSED)
    80002096:	86a6                	mv	a3,s1
    80002098:	ec04a783          	lw	a5,-320(s1)
    8000209c:	dbed                	beqz	a5,8000208e <procdump+0x66>
      state = "???";
    8000209e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800020a0:	fcfb6fe3          	bltu	s6,a5,8000207e <procdump+0x56>
    800020a4:	02079713          	slli	a4,a5,0x20
    800020a8:	01d75793          	srli	a5,a4,0x1d
    800020ac:	97de                	add	a5,a5,s7
    800020ae:	6390                	ld	a2,0(a5)
    800020b0:	f679                	bnez	a2,8000207e <procdump+0x56>
      state = "???";
    800020b2:	864e                	mv	a2,s3
    800020b4:	b7e9                	j	8000207e <procdump+0x56>
  }
}
    800020b6:	60a6                	ld	ra,72(sp)
    800020b8:	6406                	ld	s0,64(sp)
    800020ba:	74e2                	ld	s1,56(sp)
    800020bc:	7942                	ld	s2,48(sp)
    800020be:	79a2                	ld	s3,40(sp)
    800020c0:	7a02                	ld	s4,32(sp)
    800020c2:	6ae2                	ld	s5,24(sp)
    800020c4:	6b42                	ld	s6,16(sp)
    800020c6:	6ba2                	ld	s7,8(sp)
    800020c8:	6161                	addi	sp,sp,80
    800020ca:	8082                	ret

00000000800020cc <init_priority_control>:

void init_priority_control(void){
    800020cc:	1141                	addi	sp,sp,-16
    800020ce:	e406                	sd	ra,8(sp)
    800020d0:	e022                	sd	s0,0(sp)
    800020d2:	0800                	addi	s0,sp,16

  initlock(&priority_lock,"priority_lock");
    800020d4:	00005597          	auipc	a1,0x5
    800020d8:	20458593          	addi	a1,a1,516 # 800072d8 <etext+0x2d8>
    800020dc:	0000e517          	auipc	a0,0xe
    800020e0:	e0450513          	addi	a0,a0,-508 # 8000fee0 <priority_lock>
    800020e4:	a91fe0ef          	jal	80000b74 <initlock>

  for(int i = 0;i < MAXPRIORITY; i++){
    800020e8:	0000e797          	auipc	a5,0xe
    800020ec:	e2878793          	addi	a5,a5,-472 # 8000ff10 <p_control+0x18>
    800020f0:	0000e717          	auipc	a4,0xe
    800020f4:	e0870713          	addi	a4,a4,-504 # 8000fef8 <p_control>
    800020f8:	0000e697          	auipc	a3,0xe
    800020fc:	e4068693          	addi	a3,a3,-448 # 8000ff38 <p_control+0x40>
    p_control.head_priority[i] = NULL;
    80002100:	0007b023          	sd	zero,0(a5)
    p_control.present[i] = 0;
    80002104:	00072023          	sw	zero,0(a4)
    p_control.current_priority[i] = NULL;
    80002108:	0207b423          	sd	zero,40(a5)
  for(int i = 0;i < MAXPRIORITY; i++){
    8000210c:	07a1                	addi	a5,a5,8
    8000210e:	0711                	addi	a4,a4,4
    80002110:	fed798e3          	bne	a5,a3,80002100 <init_priority_control+0x34>
  }
}
    80002114:	60a2                	ld	ra,8(sp)
    80002116:	6402                	ld	s0,0(sp)
    80002118:	0141                	addi	sp,sp,16
    8000211a:	8082                	ret

000000008000211c <set_priority>:

void set_priority(int priority, struct proc *process){
  if((priority > MAXPRIORITY) || (priority < 0) )
    8000211c:	4795                	li	a5,5
    8000211e:	00a7e563          	bltu	a5,a0,80002128 <set_priority+0xc>
    panic("Priority nos alowed");

  process->priority = priority;
    80002122:	16a5a423          	sw	a0,360(a1)
    80002126:	8082                	ret
void set_priority(int priority, struct proc *process){
    80002128:	1141                	addi	sp,sp,-16
    8000212a:	e406                	sd	ra,8(sp)
    8000212c:	e022                	sd	s0,0(sp)
    8000212e:	0800                	addi	s0,sp,16
    panic("Priority nos alowed");
    80002130:	00005517          	auipc	a0,0x5
    80002134:	1b850513          	addi	a0,a0,440 # 800072e8 <etext+0x2e8>
    80002138:	e5cfe0ef          	jal	80000794 <panic>

000000008000213c <add_process_priority>:

}

//should be called with the lock 
//iterates through linked list to add an element
void add_process_priority(struct proc *p, int priority){
    8000213c:	1141                	addi	sp,sp,-16
    8000213e:	e422                	sd	s0,8(sp)
    80002140:	0800                	addi	s0,sp,16
  struct proc *aux_p;
  //check if lock held

  if(p_control.head_priority[priority] == NULL){
    80002142:	00258713          	addi	a4,a1,2
    80002146:	070e                	slli	a4,a4,0x3
    80002148:	0000e797          	auipc	a5,0xe
    8000214c:	96878793          	addi	a5,a5,-1688 # 8000fab0 <pid_lock>
    80002150:	97ba                	add	a5,a5,a4
    80002152:	4507b783          	ld	a5,1104(a5)
    80002156:	cb91                	beqz	a5,8000216a <add_process_priority+0x2e>
    p_control.head_priority[priority] = p;
  }
  else{
    aux_p = p_control.head_priority[priority];
    while(aux_p->next_p_priority != NULL){
    80002158:	873e                	mv	a4,a5
    8000215a:	1707b783          	ld	a5,368(a5)
    8000215e:	ffed                	bnez	a5,80002158 <add_process_priority+0x1c>
      aux_p = aux_p->next_p_priority;
    }
    aux_p->next_p_priority = p;
    80002160:	16a73823          	sd	a0,368(a4)
  }

}
    80002164:	6422                	ld	s0,8(sp)
    80002166:	0141                	addi	sp,sp,16
    80002168:	8082                	ret
    p_control.head_priority[priority] = p;
    8000216a:	0000e797          	auipc	a5,0xe
    8000216e:	94678793          	addi	a5,a5,-1722 # 8000fab0 <pid_lock>
    80002172:	97ba                	add	a5,a5,a4
    80002174:	44a7b823          	sd	a0,1104(a5)
    80002178:	b7f5                	j	80002164 <add_process_priority+0x28>

000000008000217a <allocproc>:
{
    8000217a:	7179                	addi	sp,sp,-48
    8000217c:	f406                	sd	ra,40(sp)
    8000217e:	f022                	sd	s0,32(sp)
    80002180:	ec26                	sd	s1,24(sp)
    80002182:	e84a                	sd	s2,16(sp)
    80002184:	e44e                	sd	s3,8(sp)
    80002186:	1800                	addi	s0,sp,48
    80002188:	89aa                	mv	s3,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    8000218a:	0000e497          	auipc	s1,0xe
    8000218e:	dd648493          	addi	s1,s1,-554 # 8000ff60 <proc>
    80002192:	00014917          	auipc	s2,0x14
    80002196:	bce90913          	addi	s2,s2,-1074 # 80015d60 <tickslock>
    acquire(&p->lock);
    8000219a:	8526                	mv	a0,s1
    8000219c:	a59fe0ef          	jal	80000bf4 <acquire>
    if(p->state == UNUSED) {
    800021a0:	4c9c                	lw	a5,24(s1)
    800021a2:	cb91                	beqz	a5,800021b6 <allocproc+0x3c>
      release(&p->lock);
    800021a4:	8526                	mv	a0,s1
    800021a6:	ae7fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800021aa:	17848493          	addi	s1,s1,376
    800021ae:	ff2496e3          	bne	s1,s2,8000219a <allocproc+0x20>
  return 0;
    800021b2:	4481                	li	s1,0
    800021b4:	a89d                	j	8000222a <allocproc+0xb0>
  p->pid = allocpid();
    800021b6:	fa6ff0ef          	jal	8000195c <allocpid>
    800021ba:	d888                	sw	a0,48(s1)
  p->state = USED;
    800021bc:	4785                	li	a5,1
    800021be:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800021c0:	965fe0ef          	jal	80000b24 <kalloc>
    800021c4:	892a                	mv	s2,a0
    800021c6:	eca8                	sd	a0,88(s1)
    800021c8:	c92d                	beqz	a0,8000223a <allocproc+0xc0>
  p->pagetable = proc_pagetable(p);
    800021ca:	8526                	mv	a0,s1
    800021cc:	fceff0ef          	jal	8000199a <proc_pagetable>
    800021d0:	892a                	mv	s2,a0
    800021d2:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800021d4:	c93d                	beqz	a0,8000224a <allocproc+0xd0>
  p->priority = priority;
    800021d6:	1734a423          	sw	s3,360(s1)
  acquire(&priority_lock);
    800021da:	0000e917          	auipc	s2,0xe
    800021de:	d0690913          	addi	s2,s2,-762 # 8000fee0 <priority_lock>
    800021e2:	854a                	mv	a0,s2
    800021e4:	a11fe0ef          	jal	80000bf4 <acquire>
  p_control.present[priority] = 1;
    800021e8:	00299713          	slli	a4,s3,0x2
    800021ec:	0000e797          	auipc	a5,0xe
    800021f0:	8c478793          	addi	a5,a5,-1852 # 8000fab0 <pid_lock>
    800021f4:	97ba                	add	a5,a5,a4
    800021f6:	4705                	li	a4,1
    800021f8:	44e7a423          	sw	a4,1096(a5)
  add_process_priority(p,priority);
    800021fc:	85ce                	mv	a1,s3
    800021fe:	8526                	mv	a0,s1
    80002200:	f3dff0ef          	jal	8000213c <add_process_priority>
  release(&priority_lock);
    80002204:	854a                	mv	a0,s2
    80002206:	a87fe0ef          	jal	80000c8c <release>
  memset(&p->context, 0, sizeof(p->context));
    8000220a:	07000613          	li	a2,112
    8000220e:	4581                	li	a1,0
    80002210:	06048513          	addi	a0,s1,96
    80002214:	ab5fe0ef          	jal	80000cc8 <memset>
  p->context.ra = (uint64)forkret;
    80002218:	fffff797          	auipc	a5,0xfffff
    8000221c:	70a78793          	addi	a5,a5,1802 # 80001922 <forkret>
    80002220:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80002222:	60bc                	ld	a5,64(s1)
    80002224:	6705                	lui	a4,0x1
    80002226:	97ba                	add	a5,a5,a4
    80002228:	f4bc                	sd	a5,104(s1)
}
    8000222a:	8526                	mv	a0,s1
    8000222c:	70a2                	ld	ra,40(sp)
    8000222e:	7402                	ld	s0,32(sp)
    80002230:	64e2                	ld	s1,24(sp)
    80002232:	6942                	ld	s2,16(sp)
    80002234:	69a2                	ld	s3,8(sp)
    80002236:	6145                	addi	sp,sp,48
    80002238:	8082                	ret
    freeproc(p);
    8000223a:	8526                	mv	a0,s1
    8000223c:	829ff0ef          	jal	80001a64 <freeproc>
    release(&p->lock);
    80002240:	8526                	mv	a0,s1
    80002242:	a4bfe0ef          	jal	80000c8c <release>
    return 0;
    80002246:	84ca                	mv	s1,s2
    80002248:	b7cd                	j	8000222a <allocproc+0xb0>
    freeproc(p);
    8000224a:	8526                	mv	a0,s1
    8000224c:	819ff0ef          	jal	80001a64 <freeproc>
    release(&p->lock);
    80002250:	8526                	mv	a0,s1
    80002252:	a3bfe0ef          	jal	80000c8c <release>
    return 0;
    80002256:	84ca                	mv	s1,s2
    80002258:	bfc9                	j	8000222a <allocproc+0xb0>

000000008000225a <userinit>:
{
    8000225a:	1101                	addi	sp,sp,-32
    8000225c:	ec06                	sd	ra,24(sp)
    8000225e:	e822                	sd	s0,16(sp)
    80002260:	e426                	sd	s1,8(sp)
    80002262:	1000                	addi	s0,sp,32
  p = allocproc(2);
    80002264:	4509                	li	a0,2
    80002266:	f15ff0ef          	jal	8000217a <allocproc>
    8000226a:	84aa                	mv	s1,a0
  initproc = p;
    8000226c:	00005797          	auipc	a5,0x5
    80002270:	70a7b623          	sd	a0,1804(a5) # 80007978 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002274:	03400613          	li	a2,52
    80002278:	00005597          	auipc	a1,0x5
    8000227c:	69858593          	addi	a1,a1,1688 # 80007910 <initcode>
    80002280:	6928                	ld	a0,80(a0)
    80002282:	81eff0ef          	jal	800012a0 <uvmfirst>
  p->sz = PGSIZE;
    80002286:	6785                	lui	a5,0x1
    80002288:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000228a:	6cb8                	ld	a4,88(s1)
    8000228c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80002290:	6cb8                	ld	a4,88(s1)
    80002292:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002294:	4641                	li	a2,16
    80002296:	00005597          	auipc	a1,0x5
    8000229a:	06a58593          	addi	a1,a1,106 # 80007300 <etext+0x300>
    8000229e:	15848513          	addi	a0,s1,344
    800022a2:	b65fe0ef          	jal	80000e06 <safestrcpy>
  p->cwd = namei("/");
    800022a6:	00005517          	auipc	a0,0x5
    800022aa:	06a50513          	addi	a0,a0,106 # 80007310 <etext+0x310>
    800022ae:	7ca010ef          	jal	80003a78 <namei>
    800022b2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800022b6:	478d                	li	a5,3
    800022b8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800022ba:	8526                	mv	a0,s1
    800022bc:	9d1fe0ef          	jal	80000c8c <release>
}
    800022c0:	60e2                	ld	ra,24(sp)
    800022c2:	6442                	ld	s0,16(sp)
    800022c4:	64a2                	ld	s1,8(sp)
    800022c6:	6105                	addi	sp,sp,32
    800022c8:	8082                	ret

00000000800022ca <fork>:
{
    800022ca:	7139                	addi	sp,sp,-64
    800022cc:	fc06                	sd	ra,56(sp)
    800022ce:	f822                	sd	s0,48(sp)
    800022d0:	f04a                	sd	s2,32(sp)
    800022d2:	e456                	sd	s5,8(sp)
    800022d4:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800022d6:	e1cff0ef          	jal	800018f2 <myproc>
    800022da:	8aaa                	mv	s5,a0
  if((np = allocproc(p->priority)) == 0){
    800022dc:	16852503          	lw	a0,360(a0)
    800022e0:	e9bff0ef          	jal	8000217a <allocproc>
    800022e4:	0e050a63          	beqz	a0,800023d8 <fork+0x10e>
    800022e8:	e852                	sd	s4,16(sp)
    800022ea:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800022ec:	048ab603          	ld	a2,72(s5)
    800022f0:	692c                	ld	a1,80(a0)
    800022f2:	050ab503          	ld	a0,80(s5)
    800022f6:	984ff0ef          	jal	8000147a <uvmcopy>
    800022fa:	04054a63          	bltz	a0,8000234e <fork+0x84>
    800022fe:	f426                	sd	s1,40(sp)
    80002300:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80002302:	048ab783          	ld	a5,72(s5)
    80002306:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000230a:	058ab683          	ld	a3,88(s5)
    8000230e:	87b6                	mv	a5,a3
    80002310:	058a3703          	ld	a4,88(s4)
    80002314:	12068693          	addi	a3,a3,288
    80002318:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000231c:	6788                	ld	a0,8(a5)
    8000231e:	6b8c                	ld	a1,16(a5)
    80002320:	6f90                	ld	a2,24(a5)
    80002322:	01073023          	sd	a6,0(a4)
    80002326:	e708                	sd	a0,8(a4)
    80002328:	eb0c                	sd	a1,16(a4)
    8000232a:	ef10                	sd	a2,24(a4)
    8000232c:	02078793          	addi	a5,a5,32
    80002330:	02070713          	addi	a4,a4,32
    80002334:	fed792e3          	bne	a5,a3,80002318 <fork+0x4e>
  np->trapframe->a0 = 0;
    80002338:	058a3783          	ld	a5,88(s4)
    8000233c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002340:	0d0a8493          	addi	s1,s5,208
    80002344:	0d0a0913          	addi	s2,s4,208
    80002348:	150a8993          	addi	s3,s5,336
    8000234c:	a831                	j	80002368 <fork+0x9e>
    freeproc(np);
    8000234e:	8552                	mv	a0,s4
    80002350:	f14ff0ef          	jal	80001a64 <freeproc>
    release(&np->lock);
    80002354:	8552                	mv	a0,s4
    80002356:	937fe0ef          	jal	80000c8c <release>
    return -1;
    8000235a:	597d                	li	s2,-1
    8000235c:	6a42                	ld	s4,16(sp)
    8000235e:	a0b5                	j	800023ca <fork+0x100>
  for(i = 0; i < NOFILE; i++)
    80002360:	04a1                	addi	s1,s1,8
    80002362:	0921                	addi	s2,s2,8
    80002364:	01348963          	beq	s1,s3,80002376 <fork+0xac>
    if(p->ofile[i])
    80002368:	6088                	ld	a0,0(s1)
    8000236a:	d97d                	beqz	a0,80002360 <fork+0x96>
      np->ofile[i] = filedup(p->ofile[i]);
    8000236c:	49d010ef          	jal	80004008 <filedup>
    80002370:	00a93023          	sd	a0,0(s2)
    80002374:	b7f5                	j	80002360 <fork+0x96>
  np->cwd = idup(p->cwd);
    80002376:	150ab503          	ld	a0,336(s5)
    8000237a:	7ef000ef          	jal	80003368 <idup>
    8000237e:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002382:	4641                	li	a2,16
    80002384:	158a8593          	addi	a1,s5,344
    80002388:	158a0513          	addi	a0,s4,344
    8000238c:	a7bfe0ef          	jal	80000e06 <safestrcpy>
  pid = np->pid;
    80002390:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80002394:	8552                	mv	a0,s4
    80002396:	8f7fe0ef          	jal	80000c8c <release>
  acquire(&wait_lock);
    8000239a:	0000d497          	auipc	s1,0xd
    8000239e:	72e48493          	addi	s1,s1,1838 # 8000fac8 <wait_lock>
    800023a2:	8526                	mv	a0,s1
    800023a4:	851fe0ef          	jal	80000bf4 <acquire>
  np->parent = p;
    800023a8:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800023ac:	8526                	mv	a0,s1
    800023ae:	8dffe0ef          	jal	80000c8c <release>
  acquire(&np->lock);
    800023b2:	8552                	mv	a0,s4
    800023b4:	841fe0ef          	jal	80000bf4 <acquire>
  np->state = RUNNABLE;
    800023b8:	478d                	li	a5,3
    800023ba:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800023be:	8552                	mv	a0,s4
    800023c0:	8cdfe0ef          	jal	80000c8c <release>
  return pid;
    800023c4:	74a2                	ld	s1,40(sp)
    800023c6:	69e2                	ld	s3,24(sp)
    800023c8:	6a42                	ld	s4,16(sp)
}
    800023ca:	854a                	mv	a0,s2
    800023cc:	70e2                	ld	ra,56(sp)
    800023ce:	7442                	ld	s0,48(sp)
    800023d0:	7902                	ld	s2,32(sp)
    800023d2:	6aa2                	ld	s5,8(sp)
    800023d4:	6121                	addi	sp,sp,64
    800023d6:	8082                	ret
    return -1;
    800023d8:	597d                	li	s2,-1
    800023da:	bfc5                	j	800023ca <fork+0x100>

00000000800023dc <free_process_priority>:

//rearanges the control structure
//updating the linked list
int free_process_priority(struct proc *p){
    800023dc:	1141                	addi	sp,sp,-16
    800023de:	e422                	sd	s0,8(sp)
    800023e0:	0800                	addi	s0,sp,16

  struct proc *p_aux;

  p_aux = p_control.head_priority[p->priority];
    800023e2:	16852703          	lw	a4,360(a0)
    800023e6:	02071693          	slli	a3,a4,0x20
    800023ea:	01d6d793          	srli	a5,a3,0x1d
    800023ee:	0000d697          	auipc	a3,0xd
    800023f2:	6d268693          	addi	a3,a3,1746 # 8000fac0 <pid_lock+0x10>
    800023f6:	97b6                	add	a5,a5,a3
    800023f8:	4507b783          	ld	a5,1104(a5)

  if(p_aux == p){
    800023fc:	02f50163          	beq	a0,a5,8000241e <free_process_priority+0x42>
      p_control.head_priority[p->priority] = p->next_p_priority;  
      p->next_p_priority = NULL;
    }
  }
  else{
    while(p_aux->next_p_priority != p){
    80002400:	873e                	mv	a4,a5
    80002402:	1707b783          	ld	a5,368(a5)
    80002406:	fea79de3          	bne	a5,a0,80002400 <free_process_priority+0x24>
      p_aux = p_aux->next_p_priority;
    }
    p_aux->next_p_priority = p->next_p_priority;
    8000240a:	17053783          	ld	a5,368(a0)
    8000240e:	16f73823          	sd	a5,368(a4)
    p->next_p_priority = NULL;
    80002412:	16053823          	sd	zero,368(a0)
  }
  
  return 0;
}
    80002416:	4501                	li	a0,0
    80002418:	6422                	ld	s0,8(sp)
    8000241a:	0141                	addi	sp,sp,16
    8000241c:	8082                	ret
    if(p->next_p_priority == NULL){
    8000241e:	1707b683          	ld	a3,368(a5)
    80002422:	ce99                	beqz	a3,80002440 <free_process_priority+0x64>
      p_control.head_priority[p->priority] = p->next_p_priority;  
    80002424:	02071613          	slli	a2,a4,0x20
    80002428:	01d65713          	srli	a4,a2,0x1d
    8000242c:	0000d617          	auipc	a2,0xd
    80002430:	69460613          	addi	a2,a2,1684 # 8000fac0 <pid_lock+0x10>
    80002434:	9732                	add	a4,a4,a2
    80002436:	44d73823          	sd	a3,1104(a4)
      p->next_p_priority = NULL;
    8000243a:	1607b823          	sd	zero,368(a5)
    8000243e:	bfe1                	j	80002416 <free_process_priority+0x3a>
      p_control.present[p->priority] = 0;
    80002440:	0000d697          	auipc	a3,0xd
    80002444:	67068693          	addi	a3,a3,1648 # 8000fab0 <pid_lock>
    80002448:	1702                	slli	a4,a4,0x20
    8000244a:	9301                	srli	a4,a4,0x20
    8000244c:	00271793          	slli	a5,a4,0x2
    80002450:	97b6                	add	a5,a5,a3
    80002452:	4407a423          	sw	zero,1096(a5)
      p_control.head_priority[p->priority] = NULL;
    80002456:	0709                	addi	a4,a4,2
    80002458:	00371793          	slli	a5,a4,0x3
    8000245c:	96be                	add	a3,a3,a5
    8000245e:	4406b823          	sd	zero,1104(a3)
    80002462:	bf55                	j	80002416 <free_process_priority+0x3a>

0000000080002464 <exit>:
{
    80002464:	7179                	addi	sp,sp,-48
    80002466:	f406                	sd	ra,40(sp)
    80002468:	f022                	sd	s0,32(sp)
    8000246a:	ec26                	sd	s1,24(sp)
    8000246c:	e84a                	sd	s2,16(sp)
    8000246e:	e44e                	sd	s3,8(sp)
    80002470:	e052                	sd	s4,0(sp)
    80002472:	1800                	addi	s0,sp,48
    80002474:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002476:	c7cff0ef          	jal	800018f2 <myproc>
    8000247a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000247c:	00005797          	auipc	a5,0x5
    80002480:	4fc7b783          	ld	a5,1276(a5) # 80007978 <initproc>
    80002484:	0d050493          	addi	s1,a0,208
    80002488:	15050913          	addi	s2,a0,336
    8000248c:	00a79f63          	bne	a5,a0,800024aa <exit+0x46>
    panic("init exiting");
    80002490:	00005517          	auipc	a0,0x5
    80002494:	e8850513          	addi	a0,a0,-376 # 80007318 <etext+0x318>
    80002498:	afcfe0ef          	jal	80000794 <panic>
      fileclose(f);
    8000249c:	3b3010ef          	jal	8000404e <fileclose>
      p->ofile[fd] = 0;
    800024a0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800024a4:	04a1                	addi	s1,s1,8
    800024a6:	01248563          	beq	s1,s2,800024b0 <exit+0x4c>
    if(p->ofile[fd]){
    800024aa:	6088                	ld	a0,0(s1)
    800024ac:	f965                	bnez	a0,8000249c <exit+0x38>
    800024ae:	bfdd                	j	800024a4 <exit+0x40>
  begin_op();
    800024b0:	784010ef          	jal	80003c34 <begin_op>
  iput(p->cwd);
    800024b4:	1509b503          	ld	a0,336(s3)
    800024b8:	068010ef          	jal	80003520 <iput>
  end_op();
    800024bc:	7e2010ef          	jal	80003c9e <end_op>
  p->cwd = 0;
    800024c0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800024c4:	0000d497          	auipc	s1,0xd
    800024c8:	60448493          	addi	s1,s1,1540 # 8000fac8 <wait_lock>
    800024cc:	8526                	mv	a0,s1
    800024ce:	f26fe0ef          	jal	80000bf4 <acquire>
  reparent(p);
    800024d2:	854e                	mv	a0,s3
    800024d4:	8bdff0ef          	jal	80001d90 <reparent>
  wakeup(p->parent);
    800024d8:	0389b503          	ld	a0,56(s3)
    800024dc:	84bff0ef          	jal	80001d26 <wakeup>
  acquire(&p->lock);
    800024e0:	854e                	mv	a0,s3
    800024e2:	f12fe0ef          	jal	80000bf4 <acquire>
  p->xstate = status;
    800024e6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800024ea:	4795                	li	a5,5
    800024ec:	00f9ac23          	sw	a5,24(s3)
  acquire(&priority_lock);
    800024f0:	0000e917          	auipc	s2,0xe
    800024f4:	9f090913          	addi	s2,s2,-1552 # 8000fee0 <priority_lock>
    800024f8:	854a                	mv	a0,s2
    800024fa:	efafe0ef          	jal	80000bf4 <acquire>
  free_process_priority(p);
    800024fe:	854e                	mv	a0,s3
    80002500:	eddff0ef          	jal	800023dc <free_process_priority>
  release(&priority_lock);
    80002504:	854a                	mv	a0,s2
    80002506:	f86fe0ef          	jal	80000c8c <release>
  release(&wait_lock);
    8000250a:	8526                	mv	a0,s1
    8000250c:	f80fe0ef          	jal	80000c8c <release>
  sched();
    80002510:	ee4ff0ef          	jal	80001bf4 <sched>
  panic("zombie exit");
    80002514:	00005517          	auipc	a0,0x5
    80002518:	e1450513          	addi	a0,a0,-492 # 80007328 <etext+0x328>
    8000251c:	a78fe0ef          	jal	80000794 <panic>

0000000080002520 <swtch>:
    80002520:	00153023          	sd	ra,0(a0)
    80002524:	00253423          	sd	sp,8(a0)
    80002528:	e900                	sd	s0,16(a0)
    8000252a:	ed04                	sd	s1,24(a0)
    8000252c:	03253023          	sd	s2,32(a0)
    80002530:	03353423          	sd	s3,40(a0)
    80002534:	03453823          	sd	s4,48(a0)
    80002538:	03553c23          	sd	s5,56(a0)
    8000253c:	05653023          	sd	s6,64(a0)
    80002540:	05753423          	sd	s7,72(a0)
    80002544:	05853823          	sd	s8,80(a0)
    80002548:	05953c23          	sd	s9,88(a0)
    8000254c:	07a53023          	sd	s10,96(a0)
    80002550:	07b53423          	sd	s11,104(a0)
    80002554:	0005b083          	ld	ra,0(a1)
    80002558:	0085b103          	ld	sp,8(a1)
    8000255c:	6980                	ld	s0,16(a1)
    8000255e:	6d84                	ld	s1,24(a1)
    80002560:	0205b903          	ld	s2,32(a1)
    80002564:	0285b983          	ld	s3,40(a1)
    80002568:	0305ba03          	ld	s4,48(a1)
    8000256c:	0385ba83          	ld	s5,56(a1)
    80002570:	0405bb03          	ld	s6,64(a1)
    80002574:	0485bb83          	ld	s7,72(a1)
    80002578:	0505bc03          	ld	s8,80(a1)
    8000257c:	0585bc83          	ld	s9,88(a1)
    80002580:	0605bd03          	ld	s10,96(a1)
    80002584:	0685bd83          	ld	s11,104(a1)
    80002588:	8082                	ret

000000008000258a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000258a:	1141                	addi	sp,sp,-16
    8000258c:	e406                	sd	ra,8(sp)
    8000258e:	e022                	sd	s0,0(sp)
    80002590:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002592:	00005597          	auipc	a1,0x5
    80002596:	dd658593          	addi	a1,a1,-554 # 80007368 <etext+0x368>
    8000259a:	00013517          	auipc	a0,0x13
    8000259e:	7c650513          	addi	a0,a0,1990 # 80015d60 <tickslock>
    800025a2:	dd2fe0ef          	jal	80000b74 <initlock>
}
    800025a6:	60a2                	ld	ra,8(sp)
    800025a8:	6402                	ld	s0,0(sp)
    800025aa:	0141                	addi	sp,sp,16
    800025ac:	8082                	ret

00000000800025ae <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800025ae:	1141                	addi	sp,sp,-16
    800025b0:	e422                	sd	s0,8(sp)
    800025b2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025b4:	00003797          	auipc	a5,0x3
    800025b8:	e0c78793          	addi	a5,a5,-500 # 800053c0 <kernelvec>
    800025bc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800025c0:	6422                	ld	s0,8(sp)
    800025c2:	0141                	addi	sp,sp,16
    800025c4:	8082                	ret

00000000800025c6 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800025c6:	1141                	addi	sp,sp,-16
    800025c8:	e406                	sd	ra,8(sp)
    800025ca:	e022                	sd	s0,0(sp)
    800025cc:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800025ce:	b24ff0ef          	jal	800018f2 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025d2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800025d6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025d8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800025dc:	00004697          	auipc	a3,0x4
    800025e0:	a2468693          	addi	a3,a3,-1500 # 80006000 <_trampoline>
    800025e4:	00004717          	auipc	a4,0x4
    800025e8:	a1c70713          	addi	a4,a4,-1508 # 80006000 <_trampoline>
    800025ec:	8f15                	sub	a4,a4,a3
    800025ee:	040007b7          	lui	a5,0x4000
    800025f2:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800025f4:	07b2                	slli	a5,a5,0xc
    800025f6:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025f8:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800025fc:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800025fe:	18002673          	csrr	a2,satp
    80002602:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002604:	6d30                	ld	a2,88(a0)
    80002606:	6138                	ld	a4,64(a0)
    80002608:	6585                	lui	a1,0x1
    8000260a:	972e                	add	a4,a4,a1
    8000260c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000260e:	6d38                	ld	a4,88(a0)
    80002610:	00000617          	auipc	a2,0x0
    80002614:	11060613          	addi	a2,a2,272 # 80002720 <usertrap>
    80002618:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000261a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000261c:	8612                	mv	a2,tp
    8000261e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002620:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002624:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002628:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000262c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002630:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002632:	6f18                	ld	a4,24(a4)
    80002634:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002638:	6928                	ld	a0,80(a0)
    8000263a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000263c:	00004717          	auipc	a4,0x4
    80002640:	a6070713          	addi	a4,a4,-1440 # 8000609c <userret>
    80002644:	8f15                	sub	a4,a4,a3
    80002646:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002648:	577d                	li	a4,-1
    8000264a:	177e                	slli	a4,a4,0x3f
    8000264c:	8d59                	or	a0,a0,a4
    8000264e:	9782                	jalr	a5
}
    80002650:	60a2                	ld	ra,8(sp)
    80002652:	6402                	ld	s0,0(sp)
    80002654:	0141                	addi	sp,sp,16
    80002656:	8082                	ret

0000000080002658 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002658:	1101                	addi	sp,sp,-32
    8000265a:	ec06                	sd	ra,24(sp)
    8000265c:	e822                	sd	s0,16(sp)
    8000265e:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002660:	a66ff0ef          	jal	800018c6 <cpuid>
    80002664:	cd11                	beqz	a0,80002680 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002666:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000266a:	000f4737          	lui	a4,0xf4
    8000266e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002672:	97ba                	add	a5,a5,a4
  asm volatile("csrw stimecmp, %0" : : "r" (x));
    80002674:	14d79073          	csrw	stimecmp,a5
}
    80002678:	60e2                	ld	ra,24(sp)
    8000267a:	6442                	ld	s0,16(sp)
    8000267c:	6105                	addi	sp,sp,32
    8000267e:	8082                	ret
    80002680:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80002682:	00013497          	auipc	s1,0x13
    80002686:	6de48493          	addi	s1,s1,1758 # 80015d60 <tickslock>
    8000268a:	8526                	mv	a0,s1
    8000268c:	d68fe0ef          	jal	80000bf4 <acquire>
    ticks++;
    80002690:	00005517          	auipc	a0,0x5
    80002694:	2f050513          	addi	a0,a0,752 # 80007980 <ticks>
    80002698:	411c                	lw	a5,0(a0)
    8000269a:	2785                	addiw	a5,a5,1
    8000269c:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000269e:	e88ff0ef          	jal	80001d26 <wakeup>
    release(&tickslock);
    800026a2:	8526                	mv	a0,s1
    800026a4:	de8fe0ef          	jal	80000c8c <release>
    800026a8:	64a2                	ld	s1,8(sp)
    800026aa:	bf75                	j	80002666 <clockintr+0xe>

00000000800026ac <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800026ac:	1101                	addi	sp,sp,-32
    800026ae:	ec06                	sd	ra,24(sp)
    800026b0:	e822                	sd	s0,16(sp)
    800026b2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026b4:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800026b8:	57fd                	li	a5,-1
    800026ba:	17fe                	slli	a5,a5,0x3f
    800026bc:	07a5                	addi	a5,a5,9
    800026be:	00f70c63          	beq	a4,a5,800026d6 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800026c2:	57fd                	li	a5,-1
    800026c4:	17fe                	slli	a5,a5,0x3f
    800026c6:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800026c8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800026ca:	04f70763          	beq	a4,a5,80002718 <devintr+0x6c>
  }
}
    800026ce:	60e2                	ld	ra,24(sp)
    800026d0:	6442                	ld	s0,16(sp)
    800026d2:	6105                	addi	sp,sp,32
    800026d4:	8082                	ret
    800026d6:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800026d8:	595020ef          	jal	8000546c <plic_claim>
    800026dc:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800026de:	47a9                	li	a5,10
    800026e0:	00f50963          	beq	a0,a5,800026f2 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800026e4:	4785                	li	a5,1
    800026e6:	00f50963          	beq	a0,a5,800026f8 <devintr+0x4c>
    return 1;
    800026ea:	4505                	li	a0,1
    } else if(irq){
    800026ec:	e889                	bnez	s1,800026fe <devintr+0x52>
    800026ee:	64a2                	ld	s1,8(sp)
    800026f0:	bff9                	j	800026ce <devintr+0x22>
      uartintr();
    800026f2:	b14fe0ef          	jal	80000a06 <uartintr>
    if(irq)
    800026f6:	a819                	j	8000270c <devintr+0x60>
      virtio_disk_intr();
    800026f8:	23a030ef          	jal	80005932 <virtio_disk_intr>
    if(irq)
    800026fc:	a801                	j	8000270c <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800026fe:	85a6                	mv	a1,s1
    80002700:	00005517          	auipc	a0,0x5
    80002704:	c7050513          	addi	a0,a0,-912 # 80007370 <etext+0x370>
    80002708:	dbbfd0ef          	jal	800004c2 <printf>
      plic_complete(irq);
    8000270c:	8526                	mv	a0,s1
    8000270e:	57f020ef          	jal	8000548c <plic_complete>
    return 1;
    80002712:	4505                	li	a0,1
    80002714:	64a2                	ld	s1,8(sp)
    80002716:	bf65                	j	800026ce <devintr+0x22>
    clockintr();
    80002718:	f41ff0ef          	jal	80002658 <clockintr>
    return 2;
    8000271c:	4509                	li	a0,2
    8000271e:	bf45                	j	800026ce <devintr+0x22>

0000000080002720 <usertrap>:
{
    80002720:	1101                	addi	sp,sp,-32
    80002722:	ec06                	sd	ra,24(sp)
    80002724:	e822                	sd	s0,16(sp)
    80002726:	e426                	sd	s1,8(sp)
    80002728:	e04a                	sd	s2,0(sp)
    8000272a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000272c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002730:	1007f793          	andi	a5,a5,256
    80002734:	ef85                	bnez	a5,8000276c <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002736:	00003797          	auipc	a5,0x3
    8000273a:	c8a78793          	addi	a5,a5,-886 # 800053c0 <kernelvec>
    8000273e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002742:	9b0ff0ef          	jal	800018f2 <myproc>
    80002746:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002748:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000274a:	14102773          	csrr	a4,sepc
    8000274e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002750:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002754:	47a1                	li	a5,8
    80002756:	02f70163          	beq	a4,a5,80002778 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    8000275a:	f53ff0ef          	jal	800026ac <devintr>
    8000275e:	892a                	mv	s2,a0
    80002760:	c135                	beqz	a0,800027c4 <usertrap+0xa4>
  if(killed(p))
    80002762:	8526                	mv	a0,s1
    80002764:	f0cff0ef          	jal	80001e70 <killed>
    80002768:	cd1d                	beqz	a0,800027a6 <usertrap+0x86>
    8000276a:	a81d                	j	800027a0 <usertrap+0x80>
    panic("usertrap: not from user mode");
    8000276c:	00005517          	auipc	a0,0x5
    80002770:	c2450513          	addi	a0,a0,-988 # 80007390 <etext+0x390>
    80002774:	820fe0ef          	jal	80000794 <panic>
    if(killed(p))
    80002778:	ef8ff0ef          	jal	80001e70 <killed>
    8000277c:	e121                	bnez	a0,800027bc <usertrap+0x9c>
    p->trapframe->epc += 4;
    8000277e:	6cb8                	ld	a4,88(s1)
    80002780:	6f1c                	ld	a5,24(a4)
    80002782:	0791                	addi	a5,a5,4
    80002784:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002786:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000278a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000278e:	10079073          	csrw	sstatus,a5
    syscall();
    80002792:	248000ef          	jal	800029da <syscall>
  if(killed(p))
    80002796:	8526                	mv	a0,s1
    80002798:	ed8ff0ef          	jal	80001e70 <killed>
    8000279c:	c901                	beqz	a0,800027ac <usertrap+0x8c>
    8000279e:	4901                	li	s2,0
    exit(-1);
    800027a0:	557d                	li	a0,-1
    800027a2:	cc3ff0ef          	jal	80002464 <exit>
  if(which_dev == 2)
    800027a6:	4789                	li	a5,2
    800027a8:	04f90563          	beq	s2,a5,800027f2 <usertrap+0xd2>
  usertrapret();
    800027ac:	e1bff0ef          	jal	800025c6 <usertrapret>
}
    800027b0:	60e2                	ld	ra,24(sp)
    800027b2:	6442                	ld	s0,16(sp)
    800027b4:	64a2                	ld	s1,8(sp)
    800027b6:	6902                	ld	s2,0(sp)
    800027b8:	6105                	addi	sp,sp,32
    800027ba:	8082                	ret
      exit(-1);
    800027bc:	557d                	li	a0,-1
    800027be:	ca7ff0ef          	jal	80002464 <exit>
    800027c2:	bf75                	j	8000277e <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027c4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800027c8:	5890                	lw	a2,48(s1)
    800027ca:	00005517          	auipc	a0,0x5
    800027ce:	be650513          	addi	a0,a0,-1050 # 800073b0 <etext+0x3b0>
    800027d2:	cf1fd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027d6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800027da:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800027de:	00005517          	auipc	a0,0x5
    800027e2:	c0250513          	addi	a0,a0,-1022 # 800073e0 <etext+0x3e0>
    800027e6:	cddfd0ef          	jal	800004c2 <printf>
    setkilled(p);
    800027ea:	8526                	mv	a0,s1
    800027ec:	e60ff0ef          	jal	80001e4c <setkilled>
    800027f0:	b75d                	j	80002796 <usertrap+0x76>
    yield();
    800027f2:	cbcff0ef          	jal	80001cae <yield>
    800027f6:	bf5d                	j	800027ac <usertrap+0x8c>

00000000800027f8 <kerneltrap>:
{
    800027f8:	7179                	addi	sp,sp,-48
    800027fa:	f406                	sd	ra,40(sp)
    800027fc:	f022                	sd	s0,32(sp)
    800027fe:	ec26                	sd	s1,24(sp)
    80002800:	e84a                	sd	s2,16(sp)
    80002802:	e44e                	sd	s3,8(sp)
    80002804:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002806:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000280a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000280e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002812:	1004f793          	andi	a5,s1,256
    80002816:	c795                	beqz	a5,80002842 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002818:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000281c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000281e:	eb85                	bnez	a5,8000284e <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002820:	e8dff0ef          	jal	800026ac <devintr>
    80002824:	c91d                	beqz	a0,8000285a <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002826:	4789                	li	a5,2
    80002828:	04f50a63          	beq	a0,a5,8000287c <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000282c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002830:	10049073          	csrw	sstatus,s1
}
    80002834:	70a2                	ld	ra,40(sp)
    80002836:	7402                	ld	s0,32(sp)
    80002838:	64e2                	ld	s1,24(sp)
    8000283a:	6942                	ld	s2,16(sp)
    8000283c:	69a2                	ld	s3,8(sp)
    8000283e:	6145                	addi	sp,sp,48
    80002840:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002842:	00005517          	auipc	a0,0x5
    80002846:	bc650513          	addi	a0,a0,-1082 # 80007408 <etext+0x408>
    8000284a:	f4bfd0ef          	jal	80000794 <panic>
    panic("kerneltrap: interrupts enabled");
    8000284e:	00005517          	auipc	a0,0x5
    80002852:	be250513          	addi	a0,a0,-1054 # 80007430 <etext+0x430>
    80002856:	f3ffd0ef          	jal	80000794 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000285a:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000285e:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002862:	85ce                	mv	a1,s3
    80002864:	00005517          	auipc	a0,0x5
    80002868:	bec50513          	addi	a0,a0,-1044 # 80007450 <etext+0x450>
    8000286c:	c57fd0ef          	jal	800004c2 <printf>
    panic("kerneltrap");
    80002870:	00005517          	auipc	a0,0x5
    80002874:	c0850513          	addi	a0,a0,-1016 # 80007478 <etext+0x478>
    80002878:	f1dfd0ef          	jal	80000794 <panic>
  if(which_dev == 2 && myproc() != 0)
    8000287c:	876ff0ef          	jal	800018f2 <myproc>
    80002880:	d555                	beqz	a0,8000282c <kerneltrap+0x34>
    yield();
    80002882:	c2cff0ef          	jal	80001cae <yield>
    80002886:	b75d                	j	8000282c <kerneltrap+0x34>

0000000080002888 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002888:	1101                	addi	sp,sp,-32
    8000288a:	ec06                	sd	ra,24(sp)
    8000288c:	e822                	sd	s0,16(sp)
    8000288e:	e426                	sd	s1,8(sp)
    80002890:	1000                	addi	s0,sp,32
    80002892:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002894:	85eff0ef          	jal	800018f2 <myproc>
  switch (n) {
    80002898:	4795                	li	a5,5
    8000289a:	0497e163          	bltu	a5,s1,800028dc <argraw+0x54>
    8000289e:	048a                	slli	s1,s1,0x2
    800028a0:	00005717          	auipc	a4,0x5
    800028a4:	f9870713          	addi	a4,a4,-104 # 80007838 <states.0+0x30>
    800028a8:	94ba                	add	s1,s1,a4
    800028aa:	409c                	lw	a5,0(s1)
    800028ac:	97ba                	add	a5,a5,a4
    800028ae:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800028b0:	6d3c                	ld	a5,88(a0)
    800028b2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800028b4:	60e2                	ld	ra,24(sp)
    800028b6:	6442                	ld	s0,16(sp)
    800028b8:	64a2                	ld	s1,8(sp)
    800028ba:	6105                	addi	sp,sp,32
    800028bc:	8082                	ret
    return p->trapframe->a1;
    800028be:	6d3c                	ld	a5,88(a0)
    800028c0:	7fa8                	ld	a0,120(a5)
    800028c2:	bfcd                	j	800028b4 <argraw+0x2c>
    return p->trapframe->a2;
    800028c4:	6d3c                	ld	a5,88(a0)
    800028c6:	63c8                	ld	a0,128(a5)
    800028c8:	b7f5                	j	800028b4 <argraw+0x2c>
    return p->trapframe->a3;
    800028ca:	6d3c                	ld	a5,88(a0)
    800028cc:	67c8                	ld	a0,136(a5)
    800028ce:	b7dd                	j	800028b4 <argraw+0x2c>
    return p->trapframe->a4;
    800028d0:	6d3c                	ld	a5,88(a0)
    800028d2:	6bc8                	ld	a0,144(a5)
    800028d4:	b7c5                	j	800028b4 <argraw+0x2c>
    return p->trapframe->a5;
    800028d6:	6d3c                	ld	a5,88(a0)
    800028d8:	6fc8                	ld	a0,152(a5)
    800028da:	bfe9                	j	800028b4 <argraw+0x2c>
  panic("argraw");
    800028dc:	00005517          	auipc	a0,0x5
    800028e0:	bac50513          	addi	a0,a0,-1108 # 80007488 <etext+0x488>
    800028e4:	eb1fd0ef          	jal	80000794 <panic>

00000000800028e8 <fetchaddr>:
{
    800028e8:	1101                	addi	sp,sp,-32
    800028ea:	ec06                	sd	ra,24(sp)
    800028ec:	e822                	sd	s0,16(sp)
    800028ee:	e426                	sd	s1,8(sp)
    800028f0:	e04a                	sd	s2,0(sp)
    800028f2:	1000                	addi	s0,sp,32
    800028f4:	84aa                	mv	s1,a0
    800028f6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800028f8:	ffbfe0ef          	jal	800018f2 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800028fc:	653c                	ld	a5,72(a0)
    800028fe:	02f4f663          	bgeu	s1,a5,8000292a <fetchaddr+0x42>
    80002902:	00848713          	addi	a4,s1,8
    80002906:	02e7e463          	bltu	a5,a4,8000292e <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000290a:	46a1                	li	a3,8
    8000290c:	8626                	mv	a2,s1
    8000290e:	85ca                	mv	a1,s2
    80002910:	6928                	ld	a0,80(a0)
    80002912:	d1bfe0ef          	jal	8000162c <copyin>
    80002916:	00a03533          	snez	a0,a0
    8000291a:	40a00533          	neg	a0,a0
}
    8000291e:	60e2                	ld	ra,24(sp)
    80002920:	6442                	ld	s0,16(sp)
    80002922:	64a2                	ld	s1,8(sp)
    80002924:	6902                	ld	s2,0(sp)
    80002926:	6105                	addi	sp,sp,32
    80002928:	8082                	ret
    return -1;
    8000292a:	557d                	li	a0,-1
    8000292c:	bfcd                	j	8000291e <fetchaddr+0x36>
    8000292e:	557d                	li	a0,-1
    80002930:	b7fd                	j	8000291e <fetchaddr+0x36>

0000000080002932 <fetchstr>:
{
    80002932:	7179                	addi	sp,sp,-48
    80002934:	f406                	sd	ra,40(sp)
    80002936:	f022                	sd	s0,32(sp)
    80002938:	ec26                	sd	s1,24(sp)
    8000293a:	e84a                	sd	s2,16(sp)
    8000293c:	e44e                	sd	s3,8(sp)
    8000293e:	1800                	addi	s0,sp,48
    80002940:	892a                	mv	s2,a0
    80002942:	84ae                	mv	s1,a1
    80002944:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002946:	fadfe0ef          	jal	800018f2 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000294a:	86ce                	mv	a3,s3
    8000294c:	864a                	mv	a2,s2
    8000294e:	85a6                	mv	a1,s1
    80002950:	6928                	ld	a0,80(a0)
    80002952:	d61fe0ef          	jal	800016b2 <copyinstr>
    80002956:	00054c63          	bltz	a0,8000296e <fetchstr+0x3c>
  return strlen(buf);
    8000295a:	8526                	mv	a0,s1
    8000295c:	cdcfe0ef          	jal	80000e38 <strlen>
}
    80002960:	70a2                	ld	ra,40(sp)
    80002962:	7402                	ld	s0,32(sp)
    80002964:	64e2                	ld	s1,24(sp)
    80002966:	6942                	ld	s2,16(sp)
    80002968:	69a2                	ld	s3,8(sp)
    8000296a:	6145                	addi	sp,sp,48
    8000296c:	8082                	ret
    return -1;
    8000296e:	557d                	li	a0,-1
    80002970:	bfc5                	j	80002960 <fetchstr+0x2e>

0000000080002972 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002972:	1101                	addi	sp,sp,-32
    80002974:	ec06                	sd	ra,24(sp)
    80002976:	e822                	sd	s0,16(sp)
    80002978:	e426                	sd	s1,8(sp)
    8000297a:	1000                	addi	s0,sp,32
    8000297c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000297e:	f0bff0ef          	jal	80002888 <argraw>
    80002982:	c088                	sw	a0,0(s1)
}
    80002984:	60e2                	ld	ra,24(sp)
    80002986:	6442                	ld	s0,16(sp)
    80002988:	64a2                	ld	s1,8(sp)
    8000298a:	6105                	addi	sp,sp,32
    8000298c:	8082                	ret

000000008000298e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000298e:	1101                	addi	sp,sp,-32
    80002990:	ec06                	sd	ra,24(sp)
    80002992:	e822                	sd	s0,16(sp)
    80002994:	e426                	sd	s1,8(sp)
    80002996:	1000                	addi	s0,sp,32
    80002998:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000299a:	eefff0ef          	jal	80002888 <argraw>
    8000299e:	e088                	sd	a0,0(s1)
}
    800029a0:	60e2                	ld	ra,24(sp)
    800029a2:	6442                	ld	s0,16(sp)
    800029a4:	64a2                	ld	s1,8(sp)
    800029a6:	6105                	addi	sp,sp,32
    800029a8:	8082                	ret

00000000800029aa <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800029aa:	7179                	addi	sp,sp,-48
    800029ac:	f406                	sd	ra,40(sp)
    800029ae:	f022                	sd	s0,32(sp)
    800029b0:	ec26                	sd	s1,24(sp)
    800029b2:	e84a                	sd	s2,16(sp)
    800029b4:	1800                	addi	s0,sp,48
    800029b6:	84ae                	mv	s1,a1
    800029b8:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800029ba:	fd840593          	addi	a1,s0,-40
    800029be:	fd1ff0ef          	jal	8000298e <argaddr>
  return fetchstr(addr, buf, max);
    800029c2:	864a                	mv	a2,s2
    800029c4:	85a6                	mv	a1,s1
    800029c6:	fd843503          	ld	a0,-40(s0)
    800029ca:	f69ff0ef          	jal	80002932 <fetchstr>
}
    800029ce:	70a2                	ld	ra,40(sp)
    800029d0:	7402                	ld	s0,32(sp)
    800029d2:	64e2                	ld	s1,24(sp)
    800029d4:	6942                	ld	s2,16(sp)
    800029d6:	6145                	addi	sp,sp,48
    800029d8:	8082                	ret

00000000800029da <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800029da:	1101                	addi	sp,sp,-32
    800029dc:	ec06                	sd	ra,24(sp)
    800029de:	e822                	sd	s0,16(sp)
    800029e0:	e426                	sd	s1,8(sp)
    800029e2:	e04a                	sd	s2,0(sp)
    800029e4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800029e6:	f0dfe0ef          	jal	800018f2 <myproc>
    800029ea:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800029ec:	05853903          	ld	s2,88(a0)
    800029f0:	0a893783          	ld	a5,168(s2)
    800029f4:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800029f8:	37fd                	addiw	a5,a5,-1
    800029fa:	4751                	li	a4,20
    800029fc:	00f76f63          	bltu	a4,a5,80002a1a <syscall+0x40>
    80002a00:	00369713          	slli	a4,a3,0x3
    80002a04:	00005797          	auipc	a5,0x5
    80002a08:	e4c78793          	addi	a5,a5,-436 # 80007850 <syscalls>
    80002a0c:	97ba                	add	a5,a5,a4
    80002a0e:	639c                	ld	a5,0(a5)
    80002a10:	c789                	beqz	a5,80002a1a <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002a12:	9782                	jalr	a5
    80002a14:	06a93823          	sd	a0,112(s2)
    80002a18:	a829                	j	80002a32 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002a1a:	15848613          	addi	a2,s1,344
    80002a1e:	588c                	lw	a1,48(s1)
    80002a20:	00005517          	auipc	a0,0x5
    80002a24:	a7050513          	addi	a0,a0,-1424 # 80007490 <etext+0x490>
    80002a28:	a9bfd0ef          	jal	800004c2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002a2c:	6cbc                	ld	a5,88(s1)
    80002a2e:	577d                	li	a4,-1
    80002a30:	fbb8                	sd	a4,112(a5)
  }
}
    80002a32:	60e2                	ld	ra,24(sp)
    80002a34:	6442                	ld	s0,16(sp)
    80002a36:	64a2                	ld	s1,8(sp)
    80002a38:	6902                	ld	s2,0(sp)
    80002a3a:	6105                	addi	sp,sp,32
    80002a3c:	8082                	ret

0000000080002a3e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002a3e:	1101                	addi	sp,sp,-32
    80002a40:	ec06                	sd	ra,24(sp)
    80002a42:	e822                	sd	s0,16(sp)
    80002a44:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002a46:	fec40593          	addi	a1,s0,-20
    80002a4a:	4501                	li	a0,0
    80002a4c:	f27ff0ef          	jal	80002972 <argint>
  exit(n);
    80002a50:	fec42503          	lw	a0,-20(s0)
    80002a54:	a11ff0ef          	jal	80002464 <exit>
  return 0;  // not reached
}
    80002a58:	4501                	li	a0,0
    80002a5a:	60e2                	ld	ra,24(sp)
    80002a5c:	6442                	ld	s0,16(sp)
    80002a5e:	6105                	addi	sp,sp,32
    80002a60:	8082                	ret

0000000080002a62 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002a62:	1141                	addi	sp,sp,-16
    80002a64:	e406                	sd	ra,8(sp)
    80002a66:	e022                	sd	s0,0(sp)
    80002a68:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002a6a:	e89fe0ef          	jal	800018f2 <myproc>
}
    80002a6e:	5908                	lw	a0,48(a0)
    80002a70:	60a2                	ld	ra,8(sp)
    80002a72:	6402                	ld	s0,0(sp)
    80002a74:	0141                	addi	sp,sp,16
    80002a76:	8082                	ret

0000000080002a78 <sys_fork>:

uint64
sys_fork(void)
{
    80002a78:	1141                	addi	sp,sp,-16
    80002a7a:	e406                	sd	ra,8(sp)
    80002a7c:	e022                	sd	s0,0(sp)
    80002a7e:	0800                	addi	s0,sp,16
  return fork();
    80002a80:	84bff0ef          	jal	800022ca <fork>
}
    80002a84:	60a2                	ld	ra,8(sp)
    80002a86:	6402                	ld	s0,0(sp)
    80002a88:	0141                	addi	sp,sp,16
    80002a8a:	8082                	ret

0000000080002a8c <sys_wait>:

uint64
sys_wait(void)
{
    80002a8c:	1101                	addi	sp,sp,-32
    80002a8e:	ec06                	sd	ra,24(sp)
    80002a90:	e822                	sd	s0,16(sp)
    80002a92:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002a94:	fe840593          	addi	a1,s0,-24
    80002a98:	4501                	li	a0,0
    80002a9a:	ef5ff0ef          	jal	8000298e <argaddr>
  return wait(p);
    80002a9e:	fe843503          	ld	a0,-24(s0)
    80002aa2:	bf8ff0ef          	jal	80001e9a <wait>
}
    80002aa6:	60e2                	ld	ra,24(sp)
    80002aa8:	6442                	ld	s0,16(sp)
    80002aaa:	6105                	addi	sp,sp,32
    80002aac:	8082                	ret

0000000080002aae <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002aae:	7179                	addi	sp,sp,-48
    80002ab0:	f406                	sd	ra,40(sp)
    80002ab2:	f022                	sd	s0,32(sp)
    80002ab4:	ec26                	sd	s1,24(sp)
    80002ab6:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002ab8:	fdc40593          	addi	a1,s0,-36
    80002abc:	4501                	li	a0,0
    80002abe:	eb5ff0ef          	jal	80002972 <argint>
  addr = myproc()->sz;
    80002ac2:	e31fe0ef          	jal	800018f2 <myproc>
    80002ac6:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002ac8:	fdc42503          	lw	a0,-36(s0)
    80002acc:	fe9fe0ef          	jal	80001ab4 <growproc>
    80002ad0:	00054863          	bltz	a0,80002ae0 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002ad4:	8526                	mv	a0,s1
    80002ad6:	70a2                	ld	ra,40(sp)
    80002ad8:	7402                	ld	s0,32(sp)
    80002ada:	64e2                	ld	s1,24(sp)
    80002adc:	6145                	addi	sp,sp,48
    80002ade:	8082                	ret
    return -1;
    80002ae0:	54fd                	li	s1,-1
    80002ae2:	bfcd                	j	80002ad4 <sys_sbrk+0x26>

0000000080002ae4 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002ae4:	7139                	addi	sp,sp,-64
    80002ae6:	fc06                	sd	ra,56(sp)
    80002ae8:	f822                	sd	s0,48(sp)
    80002aea:	f04a                	sd	s2,32(sp)
    80002aec:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002aee:	fcc40593          	addi	a1,s0,-52
    80002af2:	4501                	li	a0,0
    80002af4:	e7fff0ef          	jal	80002972 <argint>
  if(n < 0)
    80002af8:	fcc42783          	lw	a5,-52(s0)
    80002afc:	0607c763          	bltz	a5,80002b6a <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002b00:	00013517          	auipc	a0,0x13
    80002b04:	26050513          	addi	a0,a0,608 # 80015d60 <tickslock>
    80002b08:	8ecfe0ef          	jal	80000bf4 <acquire>
  ticks0 = ticks;
    80002b0c:	00005917          	auipc	s2,0x5
    80002b10:	e7492903          	lw	s2,-396(s2) # 80007980 <ticks>
  while(ticks - ticks0 < n){
    80002b14:	fcc42783          	lw	a5,-52(s0)
    80002b18:	cf8d                	beqz	a5,80002b52 <sys_sleep+0x6e>
    80002b1a:	f426                	sd	s1,40(sp)
    80002b1c:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002b1e:	00013997          	auipc	s3,0x13
    80002b22:	24298993          	addi	s3,s3,578 # 80015d60 <tickslock>
    80002b26:	00005497          	auipc	s1,0x5
    80002b2a:	e5a48493          	addi	s1,s1,-422 # 80007980 <ticks>
    if(killed(myproc())){
    80002b2e:	dc5fe0ef          	jal	800018f2 <myproc>
    80002b32:	b3eff0ef          	jal	80001e70 <killed>
    80002b36:	ed0d                	bnez	a0,80002b70 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002b38:	85ce                	mv	a1,s3
    80002b3a:	8526                	mv	a0,s1
    80002b3c:	99eff0ef          	jal	80001cda <sleep>
  while(ticks - ticks0 < n){
    80002b40:	409c                	lw	a5,0(s1)
    80002b42:	412787bb          	subw	a5,a5,s2
    80002b46:	fcc42703          	lw	a4,-52(s0)
    80002b4a:	fee7e2e3          	bltu	a5,a4,80002b2e <sys_sleep+0x4a>
    80002b4e:	74a2                	ld	s1,40(sp)
    80002b50:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002b52:	00013517          	auipc	a0,0x13
    80002b56:	20e50513          	addi	a0,a0,526 # 80015d60 <tickslock>
    80002b5a:	932fe0ef          	jal	80000c8c <release>
  return 0;
    80002b5e:	4501                	li	a0,0
}
    80002b60:	70e2                	ld	ra,56(sp)
    80002b62:	7442                	ld	s0,48(sp)
    80002b64:	7902                	ld	s2,32(sp)
    80002b66:	6121                	addi	sp,sp,64
    80002b68:	8082                	ret
    n = 0;
    80002b6a:	fc042623          	sw	zero,-52(s0)
    80002b6e:	bf49                	j	80002b00 <sys_sleep+0x1c>
      release(&tickslock);
    80002b70:	00013517          	auipc	a0,0x13
    80002b74:	1f050513          	addi	a0,a0,496 # 80015d60 <tickslock>
    80002b78:	914fe0ef          	jal	80000c8c <release>
      return -1;
    80002b7c:	557d                	li	a0,-1
    80002b7e:	74a2                	ld	s1,40(sp)
    80002b80:	69e2                	ld	s3,24(sp)
    80002b82:	bff9                	j	80002b60 <sys_sleep+0x7c>

0000000080002b84 <sys_kill>:

uint64
sys_kill(void)
{
    80002b84:	1101                	addi	sp,sp,-32
    80002b86:	ec06                	sd	ra,24(sp)
    80002b88:	e822                	sd	s0,16(sp)
    80002b8a:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002b8c:	fec40593          	addi	a1,s0,-20
    80002b90:	4501                	li	a0,0
    80002b92:	de1ff0ef          	jal	80002972 <argint>
  return kill(pid);
    80002b96:	fec42503          	lw	a0,-20(s0)
    80002b9a:	a4cff0ef          	jal	80001de6 <kill>
}
    80002b9e:	60e2                	ld	ra,24(sp)
    80002ba0:	6442                	ld	s0,16(sp)
    80002ba2:	6105                	addi	sp,sp,32
    80002ba4:	8082                	ret

0000000080002ba6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002ba6:	1101                	addi	sp,sp,-32
    80002ba8:	ec06                	sd	ra,24(sp)
    80002baa:	e822                	sd	s0,16(sp)
    80002bac:	e426                	sd	s1,8(sp)
    80002bae:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002bb0:	00013517          	auipc	a0,0x13
    80002bb4:	1b050513          	addi	a0,a0,432 # 80015d60 <tickslock>
    80002bb8:	83cfe0ef          	jal	80000bf4 <acquire>
  xticks = ticks;
    80002bbc:	00005497          	auipc	s1,0x5
    80002bc0:	dc44a483          	lw	s1,-572(s1) # 80007980 <ticks>
  release(&tickslock);
    80002bc4:	00013517          	auipc	a0,0x13
    80002bc8:	19c50513          	addi	a0,a0,412 # 80015d60 <tickslock>
    80002bcc:	8c0fe0ef          	jal	80000c8c <release>
  return xticks;
}
    80002bd0:	02049513          	slli	a0,s1,0x20
    80002bd4:	9101                	srli	a0,a0,0x20
    80002bd6:	60e2                	ld	ra,24(sp)
    80002bd8:	6442                	ld	s0,16(sp)
    80002bda:	64a2                	ld	s1,8(sp)
    80002bdc:	6105                	addi	sp,sp,32
    80002bde:	8082                	ret

0000000080002be0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002be0:	7179                	addi	sp,sp,-48
    80002be2:	f406                	sd	ra,40(sp)
    80002be4:	f022                	sd	s0,32(sp)
    80002be6:	ec26                	sd	s1,24(sp)
    80002be8:	e84a                	sd	s2,16(sp)
    80002bea:	e44e                	sd	s3,8(sp)
    80002bec:	e052                	sd	s4,0(sp)
    80002bee:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002bf0:	00005597          	auipc	a1,0x5
    80002bf4:	8c058593          	addi	a1,a1,-1856 # 800074b0 <etext+0x4b0>
    80002bf8:	00013517          	auipc	a0,0x13
    80002bfc:	18050513          	addi	a0,a0,384 # 80015d78 <bcache>
    80002c00:	f75fd0ef          	jal	80000b74 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002c04:	0001b797          	auipc	a5,0x1b
    80002c08:	17478793          	addi	a5,a5,372 # 8001dd78 <bcache+0x8000>
    80002c0c:	0001b717          	auipc	a4,0x1b
    80002c10:	3d470713          	addi	a4,a4,980 # 8001dfe0 <bcache+0x8268>
    80002c14:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002c18:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c1c:	00013497          	auipc	s1,0x13
    80002c20:	17448493          	addi	s1,s1,372 # 80015d90 <bcache+0x18>
    b->next = bcache.head.next;
    80002c24:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002c26:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002c28:	00005a17          	auipc	s4,0x5
    80002c2c:	890a0a13          	addi	s4,s4,-1904 # 800074b8 <etext+0x4b8>
    b->next = bcache.head.next;
    80002c30:	2b893783          	ld	a5,696(s2)
    80002c34:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002c36:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002c3a:	85d2                	mv	a1,s4
    80002c3c:	01048513          	addi	a0,s1,16
    80002c40:	248010ef          	jal	80003e88 <initsleeplock>
    bcache.head.next->prev = b;
    80002c44:	2b893783          	ld	a5,696(s2)
    80002c48:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002c4a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c4e:	45848493          	addi	s1,s1,1112
    80002c52:	fd349fe3          	bne	s1,s3,80002c30 <binit+0x50>
  }
}
    80002c56:	70a2                	ld	ra,40(sp)
    80002c58:	7402                	ld	s0,32(sp)
    80002c5a:	64e2                	ld	s1,24(sp)
    80002c5c:	6942                	ld	s2,16(sp)
    80002c5e:	69a2                	ld	s3,8(sp)
    80002c60:	6a02                	ld	s4,0(sp)
    80002c62:	6145                	addi	sp,sp,48
    80002c64:	8082                	ret

0000000080002c66 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002c66:	7179                	addi	sp,sp,-48
    80002c68:	f406                	sd	ra,40(sp)
    80002c6a:	f022                	sd	s0,32(sp)
    80002c6c:	ec26                	sd	s1,24(sp)
    80002c6e:	e84a                	sd	s2,16(sp)
    80002c70:	e44e                	sd	s3,8(sp)
    80002c72:	1800                	addi	s0,sp,48
    80002c74:	892a                	mv	s2,a0
    80002c76:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002c78:	00013517          	auipc	a0,0x13
    80002c7c:	10050513          	addi	a0,a0,256 # 80015d78 <bcache>
    80002c80:	f75fd0ef          	jal	80000bf4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002c84:	0001b497          	auipc	s1,0x1b
    80002c88:	3ac4b483          	ld	s1,940(s1) # 8001e030 <bcache+0x82b8>
    80002c8c:	0001b797          	auipc	a5,0x1b
    80002c90:	35478793          	addi	a5,a5,852 # 8001dfe0 <bcache+0x8268>
    80002c94:	02f48b63          	beq	s1,a5,80002cca <bread+0x64>
    80002c98:	873e                	mv	a4,a5
    80002c9a:	a021                	j	80002ca2 <bread+0x3c>
    80002c9c:	68a4                	ld	s1,80(s1)
    80002c9e:	02e48663          	beq	s1,a4,80002cca <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002ca2:	449c                	lw	a5,8(s1)
    80002ca4:	ff279ce3          	bne	a5,s2,80002c9c <bread+0x36>
    80002ca8:	44dc                	lw	a5,12(s1)
    80002caa:	ff3799e3          	bne	a5,s3,80002c9c <bread+0x36>
      b->refcnt++;
    80002cae:	40bc                	lw	a5,64(s1)
    80002cb0:	2785                	addiw	a5,a5,1
    80002cb2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002cb4:	00013517          	auipc	a0,0x13
    80002cb8:	0c450513          	addi	a0,a0,196 # 80015d78 <bcache>
    80002cbc:	fd1fd0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002cc0:	01048513          	addi	a0,s1,16
    80002cc4:	1fa010ef          	jal	80003ebe <acquiresleep>
      return b;
    80002cc8:	a889                	j	80002d1a <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002cca:	0001b497          	auipc	s1,0x1b
    80002cce:	35e4b483          	ld	s1,862(s1) # 8001e028 <bcache+0x82b0>
    80002cd2:	0001b797          	auipc	a5,0x1b
    80002cd6:	30e78793          	addi	a5,a5,782 # 8001dfe0 <bcache+0x8268>
    80002cda:	00f48863          	beq	s1,a5,80002cea <bread+0x84>
    80002cde:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002ce0:	40bc                	lw	a5,64(s1)
    80002ce2:	cb91                	beqz	a5,80002cf6 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002ce4:	64a4                	ld	s1,72(s1)
    80002ce6:	fee49de3          	bne	s1,a4,80002ce0 <bread+0x7a>
  panic("bget: no buffers");
    80002cea:	00004517          	auipc	a0,0x4
    80002cee:	7d650513          	addi	a0,a0,2006 # 800074c0 <etext+0x4c0>
    80002cf2:	aa3fd0ef          	jal	80000794 <panic>
      b->dev = dev;
    80002cf6:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002cfa:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002cfe:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002d02:	4785                	li	a5,1
    80002d04:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d06:	00013517          	auipc	a0,0x13
    80002d0a:	07250513          	addi	a0,a0,114 # 80015d78 <bcache>
    80002d0e:	f7ffd0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002d12:	01048513          	addi	a0,s1,16
    80002d16:	1a8010ef          	jal	80003ebe <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002d1a:	409c                	lw	a5,0(s1)
    80002d1c:	cb89                	beqz	a5,80002d2e <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002d1e:	8526                	mv	a0,s1
    80002d20:	70a2                	ld	ra,40(sp)
    80002d22:	7402                	ld	s0,32(sp)
    80002d24:	64e2                	ld	s1,24(sp)
    80002d26:	6942                	ld	s2,16(sp)
    80002d28:	69a2                	ld	s3,8(sp)
    80002d2a:	6145                	addi	sp,sp,48
    80002d2c:	8082                	ret
    virtio_disk_rw(b, 0);
    80002d2e:	4581                	li	a1,0
    80002d30:	8526                	mv	a0,s1
    80002d32:	1ef020ef          	jal	80005720 <virtio_disk_rw>
    b->valid = 1;
    80002d36:	4785                	li	a5,1
    80002d38:	c09c                	sw	a5,0(s1)
  return b;
    80002d3a:	b7d5                	j	80002d1e <bread+0xb8>

0000000080002d3c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002d3c:	1101                	addi	sp,sp,-32
    80002d3e:	ec06                	sd	ra,24(sp)
    80002d40:	e822                	sd	s0,16(sp)
    80002d42:	e426                	sd	s1,8(sp)
    80002d44:	1000                	addi	s0,sp,32
    80002d46:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d48:	0541                	addi	a0,a0,16
    80002d4a:	1f2010ef          	jal	80003f3c <holdingsleep>
    80002d4e:	c911                	beqz	a0,80002d62 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002d50:	4585                	li	a1,1
    80002d52:	8526                	mv	a0,s1
    80002d54:	1cd020ef          	jal	80005720 <virtio_disk_rw>
}
    80002d58:	60e2                	ld	ra,24(sp)
    80002d5a:	6442                	ld	s0,16(sp)
    80002d5c:	64a2                	ld	s1,8(sp)
    80002d5e:	6105                	addi	sp,sp,32
    80002d60:	8082                	ret
    panic("bwrite");
    80002d62:	00004517          	auipc	a0,0x4
    80002d66:	77650513          	addi	a0,a0,1910 # 800074d8 <etext+0x4d8>
    80002d6a:	a2bfd0ef          	jal	80000794 <panic>

0000000080002d6e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002d6e:	1101                	addi	sp,sp,-32
    80002d70:	ec06                	sd	ra,24(sp)
    80002d72:	e822                	sd	s0,16(sp)
    80002d74:	e426                	sd	s1,8(sp)
    80002d76:	e04a                	sd	s2,0(sp)
    80002d78:	1000                	addi	s0,sp,32
    80002d7a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d7c:	01050913          	addi	s2,a0,16
    80002d80:	854a                	mv	a0,s2
    80002d82:	1ba010ef          	jal	80003f3c <holdingsleep>
    80002d86:	c135                	beqz	a0,80002dea <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002d88:	854a                	mv	a0,s2
    80002d8a:	17a010ef          	jal	80003f04 <releasesleep>

  acquire(&bcache.lock);
    80002d8e:	00013517          	auipc	a0,0x13
    80002d92:	fea50513          	addi	a0,a0,-22 # 80015d78 <bcache>
    80002d96:	e5ffd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80002d9a:	40bc                	lw	a5,64(s1)
    80002d9c:	37fd                	addiw	a5,a5,-1
    80002d9e:	0007871b          	sext.w	a4,a5
    80002da2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002da4:	e71d                	bnez	a4,80002dd2 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002da6:	68b8                	ld	a4,80(s1)
    80002da8:	64bc                	ld	a5,72(s1)
    80002daa:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002dac:	68b8                	ld	a4,80(s1)
    80002dae:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002db0:	0001b797          	auipc	a5,0x1b
    80002db4:	fc878793          	addi	a5,a5,-56 # 8001dd78 <bcache+0x8000>
    80002db8:	2b87b703          	ld	a4,696(a5)
    80002dbc:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002dbe:	0001b717          	auipc	a4,0x1b
    80002dc2:	22270713          	addi	a4,a4,546 # 8001dfe0 <bcache+0x8268>
    80002dc6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002dc8:	2b87b703          	ld	a4,696(a5)
    80002dcc:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002dce:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002dd2:	00013517          	auipc	a0,0x13
    80002dd6:	fa650513          	addi	a0,a0,-90 # 80015d78 <bcache>
    80002dda:	eb3fd0ef          	jal	80000c8c <release>
}
    80002dde:	60e2                	ld	ra,24(sp)
    80002de0:	6442                	ld	s0,16(sp)
    80002de2:	64a2                	ld	s1,8(sp)
    80002de4:	6902                	ld	s2,0(sp)
    80002de6:	6105                	addi	sp,sp,32
    80002de8:	8082                	ret
    panic("brelse");
    80002dea:	00004517          	auipc	a0,0x4
    80002dee:	6f650513          	addi	a0,a0,1782 # 800074e0 <etext+0x4e0>
    80002df2:	9a3fd0ef          	jal	80000794 <panic>

0000000080002df6 <bpin>:

void
bpin(struct buf *b) {
    80002df6:	1101                	addi	sp,sp,-32
    80002df8:	ec06                	sd	ra,24(sp)
    80002dfa:	e822                	sd	s0,16(sp)
    80002dfc:	e426                	sd	s1,8(sp)
    80002dfe:	1000                	addi	s0,sp,32
    80002e00:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e02:	00013517          	auipc	a0,0x13
    80002e06:	f7650513          	addi	a0,a0,-138 # 80015d78 <bcache>
    80002e0a:	debfd0ef          	jal	80000bf4 <acquire>
  b->refcnt++;
    80002e0e:	40bc                	lw	a5,64(s1)
    80002e10:	2785                	addiw	a5,a5,1
    80002e12:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e14:	00013517          	auipc	a0,0x13
    80002e18:	f6450513          	addi	a0,a0,-156 # 80015d78 <bcache>
    80002e1c:	e71fd0ef          	jal	80000c8c <release>
}
    80002e20:	60e2                	ld	ra,24(sp)
    80002e22:	6442                	ld	s0,16(sp)
    80002e24:	64a2                	ld	s1,8(sp)
    80002e26:	6105                	addi	sp,sp,32
    80002e28:	8082                	ret

0000000080002e2a <bunpin>:

void
bunpin(struct buf *b) {
    80002e2a:	1101                	addi	sp,sp,-32
    80002e2c:	ec06                	sd	ra,24(sp)
    80002e2e:	e822                	sd	s0,16(sp)
    80002e30:	e426                	sd	s1,8(sp)
    80002e32:	1000                	addi	s0,sp,32
    80002e34:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e36:	00013517          	auipc	a0,0x13
    80002e3a:	f4250513          	addi	a0,a0,-190 # 80015d78 <bcache>
    80002e3e:	db7fd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80002e42:	40bc                	lw	a5,64(s1)
    80002e44:	37fd                	addiw	a5,a5,-1
    80002e46:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e48:	00013517          	auipc	a0,0x13
    80002e4c:	f3050513          	addi	a0,a0,-208 # 80015d78 <bcache>
    80002e50:	e3dfd0ef          	jal	80000c8c <release>
}
    80002e54:	60e2                	ld	ra,24(sp)
    80002e56:	6442                	ld	s0,16(sp)
    80002e58:	64a2                	ld	s1,8(sp)
    80002e5a:	6105                	addi	sp,sp,32
    80002e5c:	8082                	ret

0000000080002e5e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002e5e:	1101                	addi	sp,sp,-32
    80002e60:	ec06                	sd	ra,24(sp)
    80002e62:	e822                	sd	s0,16(sp)
    80002e64:	e426                	sd	s1,8(sp)
    80002e66:	e04a                	sd	s2,0(sp)
    80002e68:	1000                	addi	s0,sp,32
    80002e6a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002e6c:	00d5d59b          	srliw	a1,a1,0xd
    80002e70:	0001b797          	auipc	a5,0x1b
    80002e74:	5e47a783          	lw	a5,1508(a5) # 8001e454 <sb+0x1c>
    80002e78:	9dbd                	addw	a1,a1,a5
    80002e7a:	dedff0ef          	jal	80002c66 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002e7e:	0074f713          	andi	a4,s1,7
    80002e82:	4785                	li	a5,1
    80002e84:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002e88:	14ce                	slli	s1,s1,0x33
    80002e8a:	90d9                	srli	s1,s1,0x36
    80002e8c:	00950733          	add	a4,a0,s1
    80002e90:	05874703          	lbu	a4,88(a4)
    80002e94:	00e7f6b3          	and	a3,a5,a4
    80002e98:	c29d                	beqz	a3,80002ebe <bfree+0x60>
    80002e9a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002e9c:	94aa                	add	s1,s1,a0
    80002e9e:	fff7c793          	not	a5,a5
    80002ea2:	8f7d                	and	a4,a4,a5
    80002ea4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002ea8:	711000ef          	jal	80003db8 <log_write>
  brelse(bp);
    80002eac:	854a                	mv	a0,s2
    80002eae:	ec1ff0ef          	jal	80002d6e <brelse>
}
    80002eb2:	60e2                	ld	ra,24(sp)
    80002eb4:	6442                	ld	s0,16(sp)
    80002eb6:	64a2                	ld	s1,8(sp)
    80002eb8:	6902                	ld	s2,0(sp)
    80002eba:	6105                	addi	sp,sp,32
    80002ebc:	8082                	ret
    panic("freeing free block");
    80002ebe:	00004517          	auipc	a0,0x4
    80002ec2:	62a50513          	addi	a0,a0,1578 # 800074e8 <etext+0x4e8>
    80002ec6:	8cffd0ef          	jal	80000794 <panic>

0000000080002eca <balloc>:
{
    80002eca:	711d                	addi	sp,sp,-96
    80002ecc:	ec86                	sd	ra,88(sp)
    80002ece:	e8a2                	sd	s0,80(sp)
    80002ed0:	e4a6                	sd	s1,72(sp)
    80002ed2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002ed4:	0001b797          	auipc	a5,0x1b
    80002ed8:	5687a783          	lw	a5,1384(a5) # 8001e43c <sb+0x4>
    80002edc:	0e078f63          	beqz	a5,80002fda <balloc+0x110>
    80002ee0:	e0ca                	sd	s2,64(sp)
    80002ee2:	fc4e                	sd	s3,56(sp)
    80002ee4:	f852                	sd	s4,48(sp)
    80002ee6:	f456                	sd	s5,40(sp)
    80002ee8:	f05a                	sd	s6,32(sp)
    80002eea:	ec5e                	sd	s7,24(sp)
    80002eec:	e862                	sd	s8,16(sp)
    80002eee:	e466                	sd	s9,8(sp)
    80002ef0:	8baa                	mv	s7,a0
    80002ef2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002ef4:	0001bb17          	auipc	s6,0x1b
    80002ef8:	544b0b13          	addi	s6,s6,1348 # 8001e438 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002efc:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002efe:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f00:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002f02:	6c89                	lui	s9,0x2
    80002f04:	a0b5                	j	80002f70 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002f06:	97ca                	add	a5,a5,s2
    80002f08:	8e55                	or	a2,a2,a3
    80002f0a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002f0e:	854a                	mv	a0,s2
    80002f10:	6a9000ef          	jal	80003db8 <log_write>
        brelse(bp);
    80002f14:	854a                	mv	a0,s2
    80002f16:	e59ff0ef          	jal	80002d6e <brelse>
  bp = bread(dev, bno);
    80002f1a:	85a6                	mv	a1,s1
    80002f1c:	855e                	mv	a0,s7
    80002f1e:	d49ff0ef          	jal	80002c66 <bread>
    80002f22:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002f24:	40000613          	li	a2,1024
    80002f28:	4581                	li	a1,0
    80002f2a:	05850513          	addi	a0,a0,88
    80002f2e:	d9bfd0ef          	jal	80000cc8 <memset>
  log_write(bp);
    80002f32:	854a                	mv	a0,s2
    80002f34:	685000ef          	jal	80003db8 <log_write>
  brelse(bp);
    80002f38:	854a                	mv	a0,s2
    80002f3a:	e35ff0ef          	jal	80002d6e <brelse>
}
    80002f3e:	6906                	ld	s2,64(sp)
    80002f40:	79e2                	ld	s3,56(sp)
    80002f42:	7a42                	ld	s4,48(sp)
    80002f44:	7aa2                	ld	s5,40(sp)
    80002f46:	7b02                	ld	s6,32(sp)
    80002f48:	6be2                	ld	s7,24(sp)
    80002f4a:	6c42                	ld	s8,16(sp)
    80002f4c:	6ca2                	ld	s9,8(sp)
}
    80002f4e:	8526                	mv	a0,s1
    80002f50:	60e6                	ld	ra,88(sp)
    80002f52:	6446                	ld	s0,80(sp)
    80002f54:	64a6                	ld	s1,72(sp)
    80002f56:	6125                	addi	sp,sp,96
    80002f58:	8082                	ret
    brelse(bp);
    80002f5a:	854a                	mv	a0,s2
    80002f5c:	e13ff0ef          	jal	80002d6e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002f60:	015c87bb          	addw	a5,s9,s5
    80002f64:	00078a9b          	sext.w	s5,a5
    80002f68:	004b2703          	lw	a4,4(s6)
    80002f6c:	04eaff63          	bgeu	s5,a4,80002fca <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002f70:	41fad79b          	sraiw	a5,s5,0x1f
    80002f74:	0137d79b          	srliw	a5,a5,0x13
    80002f78:	015787bb          	addw	a5,a5,s5
    80002f7c:	40d7d79b          	sraiw	a5,a5,0xd
    80002f80:	01cb2583          	lw	a1,28(s6)
    80002f84:	9dbd                	addw	a1,a1,a5
    80002f86:	855e                	mv	a0,s7
    80002f88:	cdfff0ef          	jal	80002c66 <bread>
    80002f8c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f8e:	004b2503          	lw	a0,4(s6)
    80002f92:	000a849b          	sext.w	s1,s5
    80002f96:	8762                	mv	a4,s8
    80002f98:	fca4f1e3          	bgeu	s1,a0,80002f5a <balloc+0x90>
      m = 1 << (bi % 8);
    80002f9c:	00777693          	andi	a3,a4,7
    80002fa0:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002fa4:	41f7579b          	sraiw	a5,a4,0x1f
    80002fa8:	01d7d79b          	srliw	a5,a5,0x1d
    80002fac:	9fb9                	addw	a5,a5,a4
    80002fae:	4037d79b          	sraiw	a5,a5,0x3
    80002fb2:	00f90633          	add	a2,s2,a5
    80002fb6:	05864603          	lbu	a2,88(a2)
    80002fba:	00c6f5b3          	and	a1,a3,a2
    80002fbe:	d5a1                	beqz	a1,80002f06 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002fc0:	2705                	addiw	a4,a4,1
    80002fc2:	2485                	addiw	s1,s1,1
    80002fc4:	fd471ae3          	bne	a4,s4,80002f98 <balloc+0xce>
    80002fc8:	bf49                	j	80002f5a <balloc+0x90>
    80002fca:	6906                	ld	s2,64(sp)
    80002fcc:	79e2                	ld	s3,56(sp)
    80002fce:	7a42                	ld	s4,48(sp)
    80002fd0:	7aa2                	ld	s5,40(sp)
    80002fd2:	7b02                	ld	s6,32(sp)
    80002fd4:	6be2                	ld	s7,24(sp)
    80002fd6:	6c42                	ld	s8,16(sp)
    80002fd8:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002fda:	00004517          	auipc	a0,0x4
    80002fde:	52650513          	addi	a0,a0,1318 # 80007500 <etext+0x500>
    80002fe2:	ce0fd0ef          	jal	800004c2 <printf>
  return 0;
    80002fe6:	4481                	li	s1,0
    80002fe8:	b79d                	j	80002f4e <balloc+0x84>

0000000080002fea <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002fea:	7179                	addi	sp,sp,-48
    80002fec:	f406                	sd	ra,40(sp)
    80002fee:	f022                	sd	s0,32(sp)
    80002ff0:	ec26                	sd	s1,24(sp)
    80002ff2:	e84a                	sd	s2,16(sp)
    80002ff4:	e44e                	sd	s3,8(sp)
    80002ff6:	1800                	addi	s0,sp,48
    80002ff8:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002ffa:	47ad                	li	a5,11
    80002ffc:	02b7e663          	bltu	a5,a1,80003028 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80003000:	02059793          	slli	a5,a1,0x20
    80003004:	01e7d593          	srli	a1,a5,0x1e
    80003008:	00b504b3          	add	s1,a0,a1
    8000300c:	0504a903          	lw	s2,80(s1)
    80003010:	06091a63          	bnez	s2,80003084 <bmap+0x9a>
      addr = balloc(ip->dev);
    80003014:	4108                	lw	a0,0(a0)
    80003016:	eb5ff0ef          	jal	80002eca <balloc>
    8000301a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000301e:	06090363          	beqz	s2,80003084 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80003022:	0524a823          	sw	s2,80(s1)
    80003026:	a8b9                	j	80003084 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003028:	ff45849b          	addiw	s1,a1,-12
    8000302c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003030:	0ff00793          	li	a5,255
    80003034:	06e7ee63          	bltu	a5,a4,800030b0 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003038:	08052903          	lw	s2,128(a0)
    8000303c:	00091d63          	bnez	s2,80003056 <bmap+0x6c>
      addr = balloc(ip->dev);
    80003040:	4108                	lw	a0,0(a0)
    80003042:	e89ff0ef          	jal	80002eca <balloc>
    80003046:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000304a:	02090d63          	beqz	s2,80003084 <bmap+0x9a>
    8000304e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003050:	0929a023          	sw	s2,128(s3)
    80003054:	a011                	j	80003058 <bmap+0x6e>
    80003056:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003058:	85ca                	mv	a1,s2
    8000305a:	0009a503          	lw	a0,0(s3)
    8000305e:	c09ff0ef          	jal	80002c66 <bread>
    80003062:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003064:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003068:	02049713          	slli	a4,s1,0x20
    8000306c:	01e75593          	srli	a1,a4,0x1e
    80003070:	00b784b3          	add	s1,a5,a1
    80003074:	0004a903          	lw	s2,0(s1)
    80003078:	00090e63          	beqz	s2,80003094 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000307c:	8552                	mv	a0,s4
    8000307e:	cf1ff0ef          	jal	80002d6e <brelse>
    return addr;
    80003082:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003084:	854a                	mv	a0,s2
    80003086:	70a2                	ld	ra,40(sp)
    80003088:	7402                	ld	s0,32(sp)
    8000308a:	64e2                	ld	s1,24(sp)
    8000308c:	6942                	ld	s2,16(sp)
    8000308e:	69a2                	ld	s3,8(sp)
    80003090:	6145                	addi	sp,sp,48
    80003092:	8082                	ret
      addr = balloc(ip->dev);
    80003094:	0009a503          	lw	a0,0(s3)
    80003098:	e33ff0ef          	jal	80002eca <balloc>
    8000309c:	0005091b          	sext.w	s2,a0
      if(addr){
    800030a0:	fc090ee3          	beqz	s2,8000307c <bmap+0x92>
        a[bn] = addr;
    800030a4:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800030a8:	8552                	mv	a0,s4
    800030aa:	50f000ef          	jal	80003db8 <log_write>
    800030ae:	b7f9                	j	8000307c <bmap+0x92>
    800030b0:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800030b2:	00004517          	auipc	a0,0x4
    800030b6:	46650513          	addi	a0,a0,1126 # 80007518 <etext+0x518>
    800030ba:	edafd0ef          	jal	80000794 <panic>

00000000800030be <iget>:
{
    800030be:	7179                	addi	sp,sp,-48
    800030c0:	f406                	sd	ra,40(sp)
    800030c2:	f022                	sd	s0,32(sp)
    800030c4:	ec26                	sd	s1,24(sp)
    800030c6:	e84a                	sd	s2,16(sp)
    800030c8:	e44e                	sd	s3,8(sp)
    800030ca:	e052                	sd	s4,0(sp)
    800030cc:	1800                	addi	s0,sp,48
    800030ce:	89aa                	mv	s3,a0
    800030d0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800030d2:	0001b517          	auipc	a0,0x1b
    800030d6:	38650513          	addi	a0,a0,902 # 8001e458 <itable>
    800030da:	b1bfd0ef          	jal	80000bf4 <acquire>
  empty = 0;
    800030de:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800030e0:	0001b497          	auipc	s1,0x1b
    800030e4:	39048493          	addi	s1,s1,912 # 8001e470 <itable+0x18>
    800030e8:	0001d697          	auipc	a3,0x1d
    800030ec:	e1868693          	addi	a3,a3,-488 # 8001ff00 <log>
    800030f0:	a039                	j	800030fe <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800030f2:	02090963          	beqz	s2,80003124 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800030f6:	08848493          	addi	s1,s1,136
    800030fa:	02d48863          	beq	s1,a3,8000312a <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800030fe:	449c                	lw	a5,8(s1)
    80003100:	fef059e3          	blez	a5,800030f2 <iget+0x34>
    80003104:	4098                	lw	a4,0(s1)
    80003106:	ff3716e3          	bne	a4,s3,800030f2 <iget+0x34>
    8000310a:	40d8                	lw	a4,4(s1)
    8000310c:	ff4713e3          	bne	a4,s4,800030f2 <iget+0x34>
      ip->ref++;
    80003110:	2785                	addiw	a5,a5,1
    80003112:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003114:	0001b517          	auipc	a0,0x1b
    80003118:	34450513          	addi	a0,a0,836 # 8001e458 <itable>
    8000311c:	b71fd0ef          	jal	80000c8c <release>
      return ip;
    80003120:	8926                	mv	s2,s1
    80003122:	a02d                	j	8000314c <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003124:	fbe9                	bnez	a5,800030f6 <iget+0x38>
      empty = ip;
    80003126:	8926                	mv	s2,s1
    80003128:	b7f9                	j	800030f6 <iget+0x38>
  if(empty == 0)
    8000312a:	02090a63          	beqz	s2,8000315e <iget+0xa0>
  ip->dev = dev;
    8000312e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003132:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003136:	4785                	li	a5,1
    80003138:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000313c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003140:	0001b517          	auipc	a0,0x1b
    80003144:	31850513          	addi	a0,a0,792 # 8001e458 <itable>
    80003148:	b45fd0ef          	jal	80000c8c <release>
}
    8000314c:	854a                	mv	a0,s2
    8000314e:	70a2                	ld	ra,40(sp)
    80003150:	7402                	ld	s0,32(sp)
    80003152:	64e2                	ld	s1,24(sp)
    80003154:	6942                	ld	s2,16(sp)
    80003156:	69a2                	ld	s3,8(sp)
    80003158:	6a02                	ld	s4,0(sp)
    8000315a:	6145                	addi	sp,sp,48
    8000315c:	8082                	ret
    panic("iget: no inodes");
    8000315e:	00004517          	auipc	a0,0x4
    80003162:	3d250513          	addi	a0,a0,978 # 80007530 <etext+0x530>
    80003166:	e2efd0ef          	jal	80000794 <panic>

000000008000316a <fsinit>:
fsinit(int dev) {
    8000316a:	7179                	addi	sp,sp,-48
    8000316c:	f406                	sd	ra,40(sp)
    8000316e:	f022                	sd	s0,32(sp)
    80003170:	ec26                	sd	s1,24(sp)
    80003172:	e84a                	sd	s2,16(sp)
    80003174:	e44e                	sd	s3,8(sp)
    80003176:	1800                	addi	s0,sp,48
    80003178:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000317a:	4585                	li	a1,1
    8000317c:	aebff0ef          	jal	80002c66 <bread>
    80003180:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003182:	0001b997          	auipc	s3,0x1b
    80003186:	2b698993          	addi	s3,s3,694 # 8001e438 <sb>
    8000318a:	02000613          	li	a2,32
    8000318e:	05850593          	addi	a1,a0,88
    80003192:	854e                	mv	a0,s3
    80003194:	b91fd0ef          	jal	80000d24 <memmove>
  brelse(bp);
    80003198:	8526                	mv	a0,s1
    8000319a:	bd5ff0ef          	jal	80002d6e <brelse>
  if(sb.magic != FSMAGIC)
    8000319e:	0009a703          	lw	a4,0(s3)
    800031a2:	102037b7          	lui	a5,0x10203
    800031a6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800031aa:	02f71063          	bne	a4,a5,800031ca <fsinit+0x60>
  initlog(dev, &sb);
    800031ae:	0001b597          	auipc	a1,0x1b
    800031b2:	28a58593          	addi	a1,a1,650 # 8001e438 <sb>
    800031b6:	854a                	mv	a0,s2
    800031b8:	1f9000ef          	jal	80003bb0 <initlog>
}
    800031bc:	70a2                	ld	ra,40(sp)
    800031be:	7402                	ld	s0,32(sp)
    800031c0:	64e2                	ld	s1,24(sp)
    800031c2:	6942                	ld	s2,16(sp)
    800031c4:	69a2                	ld	s3,8(sp)
    800031c6:	6145                	addi	sp,sp,48
    800031c8:	8082                	ret
    panic("invalid file system");
    800031ca:	00004517          	auipc	a0,0x4
    800031ce:	37650513          	addi	a0,a0,886 # 80007540 <etext+0x540>
    800031d2:	dc2fd0ef          	jal	80000794 <panic>

00000000800031d6 <iinit>:
{
    800031d6:	7179                	addi	sp,sp,-48
    800031d8:	f406                	sd	ra,40(sp)
    800031da:	f022                	sd	s0,32(sp)
    800031dc:	ec26                	sd	s1,24(sp)
    800031de:	e84a                	sd	s2,16(sp)
    800031e0:	e44e                	sd	s3,8(sp)
    800031e2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800031e4:	00004597          	auipc	a1,0x4
    800031e8:	37458593          	addi	a1,a1,884 # 80007558 <etext+0x558>
    800031ec:	0001b517          	auipc	a0,0x1b
    800031f0:	26c50513          	addi	a0,a0,620 # 8001e458 <itable>
    800031f4:	981fd0ef          	jal	80000b74 <initlock>
  for(i = 0; i < NINODE; i++) {
    800031f8:	0001b497          	auipc	s1,0x1b
    800031fc:	28848493          	addi	s1,s1,648 # 8001e480 <itable+0x28>
    80003200:	0001d997          	auipc	s3,0x1d
    80003204:	d1098993          	addi	s3,s3,-752 # 8001ff10 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003208:	00004917          	auipc	s2,0x4
    8000320c:	35890913          	addi	s2,s2,856 # 80007560 <etext+0x560>
    80003210:	85ca                	mv	a1,s2
    80003212:	8526                	mv	a0,s1
    80003214:	475000ef          	jal	80003e88 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003218:	08848493          	addi	s1,s1,136
    8000321c:	ff349ae3          	bne	s1,s3,80003210 <iinit+0x3a>
}
    80003220:	70a2                	ld	ra,40(sp)
    80003222:	7402                	ld	s0,32(sp)
    80003224:	64e2                	ld	s1,24(sp)
    80003226:	6942                	ld	s2,16(sp)
    80003228:	69a2                	ld	s3,8(sp)
    8000322a:	6145                	addi	sp,sp,48
    8000322c:	8082                	ret

000000008000322e <ialloc>:
{
    8000322e:	7139                	addi	sp,sp,-64
    80003230:	fc06                	sd	ra,56(sp)
    80003232:	f822                	sd	s0,48(sp)
    80003234:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003236:	0001b717          	auipc	a4,0x1b
    8000323a:	20e72703          	lw	a4,526(a4) # 8001e444 <sb+0xc>
    8000323e:	4785                	li	a5,1
    80003240:	06e7f063          	bgeu	a5,a4,800032a0 <ialloc+0x72>
    80003244:	f426                	sd	s1,40(sp)
    80003246:	f04a                	sd	s2,32(sp)
    80003248:	ec4e                	sd	s3,24(sp)
    8000324a:	e852                	sd	s4,16(sp)
    8000324c:	e456                	sd	s5,8(sp)
    8000324e:	e05a                	sd	s6,0(sp)
    80003250:	8aaa                	mv	s5,a0
    80003252:	8b2e                	mv	s6,a1
    80003254:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003256:	0001ba17          	auipc	s4,0x1b
    8000325a:	1e2a0a13          	addi	s4,s4,482 # 8001e438 <sb>
    8000325e:	00495593          	srli	a1,s2,0x4
    80003262:	018a2783          	lw	a5,24(s4)
    80003266:	9dbd                	addw	a1,a1,a5
    80003268:	8556                	mv	a0,s5
    8000326a:	9fdff0ef          	jal	80002c66 <bread>
    8000326e:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003270:	05850993          	addi	s3,a0,88
    80003274:	00f97793          	andi	a5,s2,15
    80003278:	079a                	slli	a5,a5,0x6
    8000327a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000327c:	00099783          	lh	a5,0(s3)
    80003280:	cb9d                	beqz	a5,800032b6 <ialloc+0x88>
    brelse(bp);
    80003282:	aedff0ef          	jal	80002d6e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003286:	0905                	addi	s2,s2,1
    80003288:	00ca2703          	lw	a4,12(s4)
    8000328c:	0009079b          	sext.w	a5,s2
    80003290:	fce7e7e3          	bltu	a5,a4,8000325e <ialloc+0x30>
    80003294:	74a2                	ld	s1,40(sp)
    80003296:	7902                	ld	s2,32(sp)
    80003298:	69e2                	ld	s3,24(sp)
    8000329a:	6a42                	ld	s4,16(sp)
    8000329c:	6aa2                	ld	s5,8(sp)
    8000329e:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800032a0:	00004517          	auipc	a0,0x4
    800032a4:	2c850513          	addi	a0,a0,712 # 80007568 <etext+0x568>
    800032a8:	a1afd0ef          	jal	800004c2 <printf>
  return 0;
    800032ac:	4501                	li	a0,0
}
    800032ae:	70e2                	ld	ra,56(sp)
    800032b0:	7442                	ld	s0,48(sp)
    800032b2:	6121                	addi	sp,sp,64
    800032b4:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800032b6:	04000613          	li	a2,64
    800032ba:	4581                	li	a1,0
    800032bc:	854e                	mv	a0,s3
    800032be:	a0bfd0ef          	jal	80000cc8 <memset>
      dip->type = type;
    800032c2:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800032c6:	8526                	mv	a0,s1
    800032c8:	2f1000ef          	jal	80003db8 <log_write>
      brelse(bp);
    800032cc:	8526                	mv	a0,s1
    800032ce:	aa1ff0ef          	jal	80002d6e <brelse>
      return iget(dev, inum);
    800032d2:	0009059b          	sext.w	a1,s2
    800032d6:	8556                	mv	a0,s5
    800032d8:	de7ff0ef          	jal	800030be <iget>
    800032dc:	74a2                	ld	s1,40(sp)
    800032de:	7902                	ld	s2,32(sp)
    800032e0:	69e2                	ld	s3,24(sp)
    800032e2:	6a42                	ld	s4,16(sp)
    800032e4:	6aa2                	ld	s5,8(sp)
    800032e6:	6b02                	ld	s6,0(sp)
    800032e8:	b7d9                	j	800032ae <ialloc+0x80>

00000000800032ea <iupdate>:
{
    800032ea:	1101                	addi	sp,sp,-32
    800032ec:	ec06                	sd	ra,24(sp)
    800032ee:	e822                	sd	s0,16(sp)
    800032f0:	e426                	sd	s1,8(sp)
    800032f2:	e04a                	sd	s2,0(sp)
    800032f4:	1000                	addi	s0,sp,32
    800032f6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800032f8:	415c                	lw	a5,4(a0)
    800032fa:	0047d79b          	srliw	a5,a5,0x4
    800032fe:	0001b597          	auipc	a1,0x1b
    80003302:	1525a583          	lw	a1,338(a1) # 8001e450 <sb+0x18>
    80003306:	9dbd                	addw	a1,a1,a5
    80003308:	4108                	lw	a0,0(a0)
    8000330a:	95dff0ef          	jal	80002c66 <bread>
    8000330e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003310:	05850793          	addi	a5,a0,88
    80003314:	40d8                	lw	a4,4(s1)
    80003316:	8b3d                	andi	a4,a4,15
    80003318:	071a                	slli	a4,a4,0x6
    8000331a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000331c:	04449703          	lh	a4,68(s1)
    80003320:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003324:	04649703          	lh	a4,70(s1)
    80003328:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000332c:	04849703          	lh	a4,72(s1)
    80003330:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003334:	04a49703          	lh	a4,74(s1)
    80003338:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000333c:	44f8                	lw	a4,76(s1)
    8000333e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003340:	03400613          	li	a2,52
    80003344:	05048593          	addi	a1,s1,80
    80003348:	00c78513          	addi	a0,a5,12
    8000334c:	9d9fd0ef          	jal	80000d24 <memmove>
  log_write(bp);
    80003350:	854a                	mv	a0,s2
    80003352:	267000ef          	jal	80003db8 <log_write>
  brelse(bp);
    80003356:	854a                	mv	a0,s2
    80003358:	a17ff0ef          	jal	80002d6e <brelse>
}
    8000335c:	60e2                	ld	ra,24(sp)
    8000335e:	6442                	ld	s0,16(sp)
    80003360:	64a2                	ld	s1,8(sp)
    80003362:	6902                	ld	s2,0(sp)
    80003364:	6105                	addi	sp,sp,32
    80003366:	8082                	ret

0000000080003368 <idup>:
{
    80003368:	1101                	addi	sp,sp,-32
    8000336a:	ec06                	sd	ra,24(sp)
    8000336c:	e822                	sd	s0,16(sp)
    8000336e:	e426                	sd	s1,8(sp)
    80003370:	1000                	addi	s0,sp,32
    80003372:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003374:	0001b517          	auipc	a0,0x1b
    80003378:	0e450513          	addi	a0,a0,228 # 8001e458 <itable>
    8000337c:	879fd0ef          	jal	80000bf4 <acquire>
  ip->ref++;
    80003380:	449c                	lw	a5,8(s1)
    80003382:	2785                	addiw	a5,a5,1
    80003384:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003386:	0001b517          	auipc	a0,0x1b
    8000338a:	0d250513          	addi	a0,a0,210 # 8001e458 <itable>
    8000338e:	8fffd0ef          	jal	80000c8c <release>
}
    80003392:	8526                	mv	a0,s1
    80003394:	60e2                	ld	ra,24(sp)
    80003396:	6442                	ld	s0,16(sp)
    80003398:	64a2                	ld	s1,8(sp)
    8000339a:	6105                	addi	sp,sp,32
    8000339c:	8082                	ret

000000008000339e <ilock>:
{
    8000339e:	1101                	addi	sp,sp,-32
    800033a0:	ec06                	sd	ra,24(sp)
    800033a2:	e822                	sd	s0,16(sp)
    800033a4:	e426                	sd	s1,8(sp)
    800033a6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800033a8:	cd19                	beqz	a0,800033c6 <ilock+0x28>
    800033aa:	84aa                	mv	s1,a0
    800033ac:	451c                	lw	a5,8(a0)
    800033ae:	00f05c63          	blez	a5,800033c6 <ilock+0x28>
  acquiresleep(&ip->lock);
    800033b2:	0541                	addi	a0,a0,16
    800033b4:	30b000ef          	jal	80003ebe <acquiresleep>
  if(ip->valid == 0){
    800033b8:	40bc                	lw	a5,64(s1)
    800033ba:	cf89                	beqz	a5,800033d4 <ilock+0x36>
}
    800033bc:	60e2                	ld	ra,24(sp)
    800033be:	6442                	ld	s0,16(sp)
    800033c0:	64a2                	ld	s1,8(sp)
    800033c2:	6105                	addi	sp,sp,32
    800033c4:	8082                	ret
    800033c6:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800033c8:	00004517          	auipc	a0,0x4
    800033cc:	1b850513          	addi	a0,a0,440 # 80007580 <etext+0x580>
    800033d0:	bc4fd0ef          	jal	80000794 <panic>
    800033d4:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800033d6:	40dc                	lw	a5,4(s1)
    800033d8:	0047d79b          	srliw	a5,a5,0x4
    800033dc:	0001b597          	auipc	a1,0x1b
    800033e0:	0745a583          	lw	a1,116(a1) # 8001e450 <sb+0x18>
    800033e4:	9dbd                	addw	a1,a1,a5
    800033e6:	4088                	lw	a0,0(s1)
    800033e8:	87fff0ef          	jal	80002c66 <bread>
    800033ec:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800033ee:	05850593          	addi	a1,a0,88
    800033f2:	40dc                	lw	a5,4(s1)
    800033f4:	8bbd                	andi	a5,a5,15
    800033f6:	079a                	slli	a5,a5,0x6
    800033f8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800033fa:	00059783          	lh	a5,0(a1)
    800033fe:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003402:	00259783          	lh	a5,2(a1)
    80003406:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000340a:	00459783          	lh	a5,4(a1)
    8000340e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003412:	00659783          	lh	a5,6(a1)
    80003416:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000341a:	459c                	lw	a5,8(a1)
    8000341c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000341e:	03400613          	li	a2,52
    80003422:	05b1                	addi	a1,a1,12
    80003424:	05048513          	addi	a0,s1,80
    80003428:	8fdfd0ef          	jal	80000d24 <memmove>
    brelse(bp);
    8000342c:	854a                	mv	a0,s2
    8000342e:	941ff0ef          	jal	80002d6e <brelse>
    ip->valid = 1;
    80003432:	4785                	li	a5,1
    80003434:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003436:	04449783          	lh	a5,68(s1)
    8000343a:	c399                	beqz	a5,80003440 <ilock+0xa2>
    8000343c:	6902                	ld	s2,0(sp)
    8000343e:	bfbd                	j	800033bc <ilock+0x1e>
      panic("ilock: no type");
    80003440:	00004517          	auipc	a0,0x4
    80003444:	14850513          	addi	a0,a0,328 # 80007588 <etext+0x588>
    80003448:	b4cfd0ef          	jal	80000794 <panic>

000000008000344c <iunlock>:
{
    8000344c:	1101                	addi	sp,sp,-32
    8000344e:	ec06                	sd	ra,24(sp)
    80003450:	e822                	sd	s0,16(sp)
    80003452:	e426                	sd	s1,8(sp)
    80003454:	e04a                	sd	s2,0(sp)
    80003456:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003458:	c505                	beqz	a0,80003480 <iunlock+0x34>
    8000345a:	84aa                	mv	s1,a0
    8000345c:	01050913          	addi	s2,a0,16
    80003460:	854a                	mv	a0,s2
    80003462:	2db000ef          	jal	80003f3c <holdingsleep>
    80003466:	cd09                	beqz	a0,80003480 <iunlock+0x34>
    80003468:	449c                	lw	a5,8(s1)
    8000346a:	00f05b63          	blez	a5,80003480 <iunlock+0x34>
  releasesleep(&ip->lock);
    8000346e:	854a                	mv	a0,s2
    80003470:	295000ef          	jal	80003f04 <releasesleep>
}
    80003474:	60e2                	ld	ra,24(sp)
    80003476:	6442                	ld	s0,16(sp)
    80003478:	64a2                	ld	s1,8(sp)
    8000347a:	6902                	ld	s2,0(sp)
    8000347c:	6105                	addi	sp,sp,32
    8000347e:	8082                	ret
    panic("iunlock");
    80003480:	00004517          	auipc	a0,0x4
    80003484:	11850513          	addi	a0,a0,280 # 80007598 <etext+0x598>
    80003488:	b0cfd0ef          	jal	80000794 <panic>

000000008000348c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000348c:	7179                	addi	sp,sp,-48
    8000348e:	f406                	sd	ra,40(sp)
    80003490:	f022                	sd	s0,32(sp)
    80003492:	ec26                	sd	s1,24(sp)
    80003494:	e84a                	sd	s2,16(sp)
    80003496:	e44e                	sd	s3,8(sp)
    80003498:	1800                	addi	s0,sp,48
    8000349a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000349c:	05050493          	addi	s1,a0,80
    800034a0:	08050913          	addi	s2,a0,128
    800034a4:	a021                	j	800034ac <itrunc+0x20>
    800034a6:	0491                	addi	s1,s1,4
    800034a8:	01248b63          	beq	s1,s2,800034be <itrunc+0x32>
    if(ip->addrs[i]){
    800034ac:	408c                	lw	a1,0(s1)
    800034ae:	dde5                	beqz	a1,800034a6 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800034b0:	0009a503          	lw	a0,0(s3)
    800034b4:	9abff0ef          	jal	80002e5e <bfree>
      ip->addrs[i] = 0;
    800034b8:	0004a023          	sw	zero,0(s1)
    800034bc:	b7ed                	j	800034a6 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800034be:	0809a583          	lw	a1,128(s3)
    800034c2:	ed89                	bnez	a1,800034dc <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800034c4:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800034c8:	854e                	mv	a0,s3
    800034ca:	e21ff0ef          	jal	800032ea <iupdate>
}
    800034ce:	70a2                	ld	ra,40(sp)
    800034d0:	7402                	ld	s0,32(sp)
    800034d2:	64e2                	ld	s1,24(sp)
    800034d4:	6942                	ld	s2,16(sp)
    800034d6:	69a2                	ld	s3,8(sp)
    800034d8:	6145                	addi	sp,sp,48
    800034da:	8082                	ret
    800034dc:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800034de:	0009a503          	lw	a0,0(s3)
    800034e2:	f84ff0ef          	jal	80002c66 <bread>
    800034e6:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800034e8:	05850493          	addi	s1,a0,88
    800034ec:	45850913          	addi	s2,a0,1112
    800034f0:	a021                	j	800034f8 <itrunc+0x6c>
    800034f2:	0491                	addi	s1,s1,4
    800034f4:	01248963          	beq	s1,s2,80003506 <itrunc+0x7a>
      if(a[j])
    800034f8:	408c                	lw	a1,0(s1)
    800034fa:	dde5                	beqz	a1,800034f2 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800034fc:	0009a503          	lw	a0,0(s3)
    80003500:	95fff0ef          	jal	80002e5e <bfree>
    80003504:	b7fd                	j	800034f2 <itrunc+0x66>
    brelse(bp);
    80003506:	8552                	mv	a0,s4
    80003508:	867ff0ef          	jal	80002d6e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000350c:	0809a583          	lw	a1,128(s3)
    80003510:	0009a503          	lw	a0,0(s3)
    80003514:	94bff0ef          	jal	80002e5e <bfree>
    ip->addrs[NDIRECT] = 0;
    80003518:	0809a023          	sw	zero,128(s3)
    8000351c:	6a02                	ld	s4,0(sp)
    8000351e:	b75d                	j	800034c4 <itrunc+0x38>

0000000080003520 <iput>:
{
    80003520:	1101                	addi	sp,sp,-32
    80003522:	ec06                	sd	ra,24(sp)
    80003524:	e822                	sd	s0,16(sp)
    80003526:	e426                	sd	s1,8(sp)
    80003528:	1000                	addi	s0,sp,32
    8000352a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000352c:	0001b517          	auipc	a0,0x1b
    80003530:	f2c50513          	addi	a0,a0,-212 # 8001e458 <itable>
    80003534:	ec0fd0ef          	jal	80000bf4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003538:	4498                	lw	a4,8(s1)
    8000353a:	4785                	li	a5,1
    8000353c:	02f70063          	beq	a4,a5,8000355c <iput+0x3c>
  ip->ref--;
    80003540:	449c                	lw	a5,8(s1)
    80003542:	37fd                	addiw	a5,a5,-1
    80003544:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003546:	0001b517          	auipc	a0,0x1b
    8000354a:	f1250513          	addi	a0,a0,-238 # 8001e458 <itable>
    8000354e:	f3efd0ef          	jal	80000c8c <release>
}
    80003552:	60e2                	ld	ra,24(sp)
    80003554:	6442                	ld	s0,16(sp)
    80003556:	64a2                	ld	s1,8(sp)
    80003558:	6105                	addi	sp,sp,32
    8000355a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000355c:	40bc                	lw	a5,64(s1)
    8000355e:	d3ed                	beqz	a5,80003540 <iput+0x20>
    80003560:	04a49783          	lh	a5,74(s1)
    80003564:	fff1                	bnez	a5,80003540 <iput+0x20>
    80003566:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003568:	01048913          	addi	s2,s1,16
    8000356c:	854a                	mv	a0,s2
    8000356e:	151000ef          	jal	80003ebe <acquiresleep>
    release(&itable.lock);
    80003572:	0001b517          	auipc	a0,0x1b
    80003576:	ee650513          	addi	a0,a0,-282 # 8001e458 <itable>
    8000357a:	f12fd0ef          	jal	80000c8c <release>
    itrunc(ip);
    8000357e:	8526                	mv	a0,s1
    80003580:	f0dff0ef          	jal	8000348c <itrunc>
    ip->type = 0;
    80003584:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003588:	8526                	mv	a0,s1
    8000358a:	d61ff0ef          	jal	800032ea <iupdate>
    ip->valid = 0;
    8000358e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003592:	854a                	mv	a0,s2
    80003594:	171000ef          	jal	80003f04 <releasesleep>
    acquire(&itable.lock);
    80003598:	0001b517          	auipc	a0,0x1b
    8000359c:	ec050513          	addi	a0,a0,-320 # 8001e458 <itable>
    800035a0:	e54fd0ef          	jal	80000bf4 <acquire>
    800035a4:	6902                	ld	s2,0(sp)
    800035a6:	bf69                	j	80003540 <iput+0x20>

00000000800035a8 <iunlockput>:
{
    800035a8:	1101                	addi	sp,sp,-32
    800035aa:	ec06                	sd	ra,24(sp)
    800035ac:	e822                	sd	s0,16(sp)
    800035ae:	e426                	sd	s1,8(sp)
    800035b0:	1000                	addi	s0,sp,32
    800035b2:	84aa                	mv	s1,a0
  iunlock(ip);
    800035b4:	e99ff0ef          	jal	8000344c <iunlock>
  iput(ip);
    800035b8:	8526                	mv	a0,s1
    800035ba:	f67ff0ef          	jal	80003520 <iput>
}
    800035be:	60e2                	ld	ra,24(sp)
    800035c0:	6442                	ld	s0,16(sp)
    800035c2:	64a2                	ld	s1,8(sp)
    800035c4:	6105                	addi	sp,sp,32
    800035c6:	8082                	ret

00000000800035c8 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800035c8:	1141                	addi	sp,sp,-16
    800035ca:	e422                	sd	s0,8(sp)
    800035cc:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800035ce:	411c                	lw	a5,0(a0)
    800035d0:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800035d2:	415c                	lw	a5,4(a0)
    800035d4:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800035d6:	04451783          	lh	a5,68(a0)
    800035da:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800035de:	04a51783          	lh	a5,74(a0)
    800035e2:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800035e6:	04c56783          	lwu	a5,76(a0)
    800035ea:	e99c                	sd	a5,16(a1)
}
    800035ec:	6422                	ld	s0,8(sp)
    800035ee:	0141                	addi	sp,sp,16
    800035f0:	8082                	ret

00000000800035f2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800035f2:	457c                	lw	a5,76(a0)
    800035f4:	0ed7eb63          	bltu	a5,a3,800036ea <readi+0xf8>
{
    800035f8:	7159                	addi	sp,sp,-112
    800035fa:	f486                	sd	ra,104(sp)
    800035fc:	f0a2                	sd	s0,96(sp)
    800035fe:	eca6                	sd	s1,88(sp)
    80003600:	e0d2                	sd	s4,64(sp)
    80003602:	fc56                	sd	s5,56(sp)
    80003604:	f85a                	sd	s6,48(sp)
    80003606:	f45e                	sd	s7,40(sp)
    80003608:	1880                	addi	s0,sp,112
    8000360a:	8b2a                	mv	s6,a0
    8000360c:	8bae                	mv	s7,a1
    8000360e:	8a32                	mv	s4,a2
    80003610:	84b6                	mv	s1,a3
    80003612:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003614:	9f35                	addw	a4,a4,a3
    return 0;
    80003616:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003618:	0cd76063          	bltu	a4,a3,800036d8 <readi+0xe6>
    8000361c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000361e:	00e7f463          	bgeu	a5,a4,80003626 <readi+0x34>
    n = ip->size - off;
    80003622:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003626:	080a8f63          	beqz	s5,800036c4 <readi+0xd2>
    8000362a:	e8ca                	sd	s2,80(sp)
    8000362c:	f062                	sd	s8,32(sp)
    8000362e:	ec66                	sd	s9,24(sp)
    80003630:	e86a                	sd	s10,16(sp)
    80003632:	e46e                	sd	s11,8(sp)
    80003634:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003636:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000363a:	5c7d                	li	s8,-1
    8000363c:	a80d                	j	8000366e <readi+0x7c>
    8000363e:	020d1d93          	slli	s11,s10,0x20
    80003642:	020ddd93          	srli	s11,s11,0x20
    80003646:	05890613          	addi	a2,s2,88
    8000364a:	86ee                	mv	a3,s11
    8000364c:	963a                	add	a2,a2,a4
    8000364e:	85d2                	mv	a1,s4
    80003650:	855e                	mv	a0,s7
    80003652:	943fe0ef          	jal	80001f94 <either_copyout>
    80003656:	05850763          	beq	a0,s8,800036a4 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000365a:	854a                	mv	a0,s2
    8000365c:	f12ff0ef          	jal	80002d6e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003660:	013d09bb          	addw	s3,s10,s3
    80003664:	009d04bb          	addw	s1,s10,s1
    80003668:	9a6e                	add	s4,s4,s11
    8000366a:	0559f763          	bgeu	s3,s5,800036b8 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    8000366e:	00a4d59b          	srliw	a1,s1,0xa
    80003672:	855a                	mv	a0,s6
    80003674:	977ff0ef          	jal	80002fea <bmap>
    80003678:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000367c:	c5b1                	beqz	a1,800036c8 <readi+0xd6>
    bp = bread(ip->dev, addr);
    8000367e:	000b2503          	lw	a0,0(s6)
    80003682:	de4ff0ef          	jal	80002c66 <bread>
    80003686:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003688:	3ff4f713          	andi	a4,s1,1023
    8000368c:	40ec87bb          	subw	a5,s9,a4
    80003690:	413a86bb          	subw	a3,s5,s3
    80003694:	8d3e                	mv	s10,a5
    80003696:	2781                	sext.w	a5,a5
    80003698:	0006861b          	sext.w	a2,a3
    8000369c:	faf671e3          	bgeu	a2,a5,8000363e <readi+0x4c>
    800036a0:	8d36                	mv	s10,a3
    800036a2:	bf71                	j	8000363e <readi+0x4c>
      brelse(bp);
    800036a4:	854a                	mv	a0,s2
    800036a6:	ec8ff0ef          	jal	80002d6e <brelse>
      tot = -1;
    800036aa:	59fd                	li	s3,-1
      break;
    800036ac:	6946                	ld	s2,80(sp)
    800036ae:	7c02                	ld	s8,32(sp)
    800036b0:	6ce2                	ld	s9,24(sp)
    800036b2:	6d42                	ld	s10,16(sp)
    800036b4:	6da2                	ld	s11,8(sp)
    800036b6:	a831                	j	800036d2 <readi+0xe0>
    800036b8:	6946                	ld	s2,80(sp)
    800036ba:	7c02                	ld	s8,32(sp)
    800036bc:	6ce2                	ld	s9,24(sp)
    800036be:	6d42                	ld	s10,16(sp)
    800036c0:	6da2                	ld	s11,8(sp)
    800036c2:	a801                	j	800036d2 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800036c4:	89d6                	mv	s3,s5
    800036c6:	a031                	j	800036d2 <readi+0xe0>
    800036c8:	6946                	ld	s2,80(sp)
    800036ca:	7c02                	ld	s8,32(sp)
    800036cc:	6ce2                	ld	s9,24(sp)
    800036ce:	6d42                	ld	s10,16(sp)
    800036d0:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800036d2:	0009851b          	sext.w	a0,s3
    800036d6:	69a6                	ld	s3,72(sp)
}
    800036d8:	70a6                	ld	ra,104(sp)
    800036da:	7406                	ld	s0,96(sp)
    800036dc:	64e6                	ld	s1,88(sp)
    800036de:	6a06                	ld	s4,64(sp)
    800036e0:	7ae2                	ld	s5,56(sp)
    800036e2:	7b42                	ld	s6,48(sp)
    800036e4:	7ba2                	ld	s7,40(sp)
    800036e6:	6165                	addi	sp,sp,112
    800036e8:	8082                	ret
    return 0;
    800036ea:	4501                	li	a0,0
}
    800036ec:	8082                	ret

00000000800036ee <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800036ee:	457c                	lw	a5,76(a0)
    800036f0:	10d7e063          	bltu	a5,a3,800037f0 <writei+0x102>
{
    800036f4:	7159                	addi	sp,sp,-112
    800036f6:	f486                	sd	ra,104(sp)
    800036f8:	f0a2                	sd	s0,96(sp)
    800036fa:	e8ca                	sd	s2,80(sp)
    800036fc:	e0d2                	sd	s4,64(sp)
    800036fe:	fc56                	sd	s5,56(sp)
    80003700:	f85a                	sd	s6,48(sp)
    80003702:	f45e                	sd	s7,40(sp)
    80003704:	1880                	addi	s0,sp,112
    80003706:	8aaa                	mv	s5,a0
    80003708:	8bae                	mv	s7,a1
    8000370a:	8a32                	mv	s4,a2
    8000370c:	8936                	mv	s2,a3
    8000370e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003710:	00e687bb          	addw	a5,a3,a4
    80003714:	0ed7e063          	bltu	a5,a3,800037f4 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003718:	00043737          	lui	a4,0x43
    8000371c:	0cf76e63          	bltu	a4,a5,800037f8 <writei+0x10a>
    80003720:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003722:	0a0b0f63          	beqz	s6,800037e0 <writei+0xf2>
    80003726:	eca6                	sd	s1,88(sp)
    80003728:	f062                	sd	s8,32(sp)
    8000372a:	ec66                	sd	s9,24(sp)
    8000372c:	e86a                	sd	s10,16(sp)
    8000372e:	e46e                	sd	s11,8(sp)
    80003730:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003732:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003736:	5c7d                	li	s8,-1
    80003738:	a825                	j	80003770 <writei+0x82>
    8000373a:	020d1d93          	slli	s11,s10,0x20
    8000373e:	020ddd93          	srli	s11,s11,0x20
    80003742:	05848513          	addi	a0,s1,88
    80003746:	86ee                	mv	a3,s11
    80003748:	8652                	mv	a2,s4
    8000374a:	85de                	mv	a1,s7
    8000374c:	953a                	add	a0,a0,a4
    8000374e:	891fe0ef          	jal	80001fde <either_copyin>
    80003752:	05850a63          	beq	a0,s8,800037a6 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003756:	8526                	mv	a0,s1
    80003758:	660000ef          	jal	80003db8 <log_write>
    brelse(bp);
    8000375c:	8526                	mv	a0,s1
    8000375e:	e10ff0ef          	jal	80002d6e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003762:	013d09bb          	addw	s3,s10,s3
    80003766:	012d093b          	addw	s2,s10,s2
    8000376a:	9a6e                	add	s4,s4,s11
    8000376c:	0569f063          	bgeu	s3,s6,800037ac <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003770:	00a9559b          	srliw	a1,s2,0xa
    80003774:	8556                	mv	a0,s5
    80003776:	875ff0ef          	jal	80002fea <bmap>
    8000377a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000377e:	c59d                	beqz	a1,800037ac <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003780:	000aa503          	lw	a0,0(s5)
    80003784:	ce2ff0ef          	jal	80002c66 <bread>
    80003788:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000378a:	3ff97713          	andi	a4,s2,1023
    8000378e:	40ec87bb          	subw	a5,s9,a4
    80003792:	413b06bb          	subw	a3,s6,s3
    80003796:	8d3e                	mv	s10,a5
    80003798:	2781                	sext.w	a5,a5
    8000379a:	0006861b          	sext.w	a2,a3
    8000379e:	f8f67ee3          	bgeu	a2,a5,8000373a <writei+0x4c>
    800037a2:	8d36                	mv	s10,a3
    800037a4:	bf59                	j	8000373a <writei+0x4c>
      brelse(bp);
    800037a6:	8526                	mv	a0,s1
    800037a8:	dc6ff0ef          	jal	80002d6e <brelse>
  }

  if(off > ip->size)
    800037ac:	04caa783          	lw	a5,76(s5)
    800037b0:	0327fa63          	bgeu	a5,s2,800037e4 <writei+0xf6>
    ip->size = off;
    800037b4:	052aa623          	sw	s2,76(s5)
    800037b8:	64e6                	ld	s1,88(sp)
    800037ba:	7c02                	ld	s8,32(sp)
    800037bc:	6ce2                	ld	s9,24(sp)
    800037be:	6d42                	ld	s10,16(sp)
    800037c0:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800037c2:	8556                	mv	a0,s5
    800037c4:	b27ff0ef          	jal	800032ea <iupdate>

  return tot;
    800037c8:	0009851b          	sext.w	a0,s3
    800037cc:	69a6                	ld	s3,72(sp)
}
    800037ce:	70a6                	ld	ra,104(sp)
    800037d0:	7406                	ld	s0,96(sp)
    800037d2:	6946                	ld	s2,80(sp)
    800037d4:	6a06                	ld	s4,64(sp)
    800037d6:	7ae2                	ld	s5,56(sp)
    800037d8:	7b42                	ld	s6,48(sp)
    800037da:	7ba2                	ld	s7,40(sp)
    800037dc:	6165                	addi	sp,sp,112
    800037de:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800037e0:	89da                	mv	s3,s6
    800037e2:	b7c5                	j	800037c2 <writei+0xd4>
    800037e4:	64e6                	ld	s1,88(sp)
    800037e6:	7c02                	ld	s8,32(sp)
    800037e8:	6ce2                	ld	s9,24(sp)
    800037ea:	6d42                	ld	s10,16(sp)
    800037ec:	6da2                	ld	s11,8(sp)
    800037ee:	bfd1                	j	800037c2 <writei+0xd4>
    return -1;
    800037f0:	557d                	li	a0,-1
}
    800037f2:	8082                	ret
    return -1;
    800037f4:	557d                	li	a0,-1
    800037f6:	bfe1                	j	800037ce <writei+0xe0>
    return -1;
    800037f8:	557d                	li	a0,-1
    800037fa:	bfd1                	j	800037ce <writei+0xe0>

00000000800037fc <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800037fc:	1141                	addi	sp,sp,-16
    800037fe:	e406                	sd	ra,8(sp)
    80003800:	e022                	sd	s0,0(sp)
    80003802:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003804:	4639                	li	a2,14
    80003806:	d8efd0ef          	jal	80000d94 <strncmp>
}
    8000380a:	60a2                	ld	ra,8(sp)
    8000380c:	6402                	ld	s0,0(sp)
    8000380e:	0141                	addi	sp,sp,16
    80003810:	8082                	ret

0000000080003812 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003812:	7139                	addi	sp,sp,-64
    80003814:	fc06                	sd	ra,56(sp)
    80003816:	f822                	sd	s0,48(sp)
    80003818:	f426                	sd	s1,40(sp)
    8000381a:	f04a                	sd	s2,32(sp)
    8000381c:	ec4e                	sd	s3,24(sp)
    8000381e:	e852                	sd	s4,16(sp)
    80003820:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003822:	04451703          	lh	a4,68(a0)
    80003826:	4785                	li	a5,1
    80003828:	00f71a63          	bne	a4,a5,8000383c <dirlookup+0x2a>
    8000382c:	892a                	mv	s2,a0
    8000382e:	89ae                	mv	s3,a1
    80003830:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003832:	457c                	lw	a5,76(a0)
    80003834:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003836:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003838:	e39d                	bnez	a5,8000385e <dirlookup+0x4c>
    8000383a:	a095                	j	8000389e <dirlookup+0x8c>
    panic("dirlookup not DIR");
    8000383c:	00004517          	auipc	a0,0x4
    80003840:	d6450513          	addi	a0,a0,-668 # 800075a0 <etext+0x5a0>
    80003844:	f51fc0ef          	jal	80000794 <panic>
      panic("dirlookup read");
    80003848:	00004517          	auipc	a0,0x4
    8000384c:	d7050513          	addi	a0,a0,-656 # 800075b8 <etext+0x5b8>
    80003850:	f45fc0ef          	jal	80000794 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003854:	24c1                	addiw	s1,s1,16
    80003856:	04c92783          	lw	a5,76(s2)
    8000385a:	04f4f163          	bgeu	s1,a5,8000389c <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000385e:	4741                	li	a4,16
    80003860:	86a6                	mv	a3,s1
    80003862:	fc040613          	addi	a2,s0,-64
    80003866:	4581                	li	a1,0
    80003868:	854a                	mv	a0,s2
    8000386a:	d89ff0ef          	jal	800035f2 <readi>
    8000386e:	47c1                	li	a5,16
    80003870:	fcf51ce3          	bne	a0,a5,80003848 <dirlookup+0x36>
    if(de.inum == 0)
    80003874:	fc045783          	lhu	a5,-64(s0)
    80003878:	dff1                	beqz	a5,80003854 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    8000387a:	fc240593          	addi	a1,s0,-62
    8000387e:	854e                	mv	a0,s3
    80003880:	f7dff0ef          	jal	800037fc <namecmp>
    80003884:	f961                	bnez	a0,80003854 <dirlookup+0x42>
      if(poff)
    80003886:	000a0463          	beqz	s4,8000388e <dirlookup+0x7c>
        *poff = off;
    8000388a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000388e:	fc045583          	lhu	a1,-64(s0)
    80003892:	00092503          	lw	a0,0(s2)
    80003896:	829ff0ef          	jal	800030be <iget>
    8000389a:	a011                	j	8000389e <dirlookup+0x8c>
  return 0;
    8000389c:	4501                	li	a0,0
}
    8000389e:	70e2                	ld	ra,56(sp)
    800038a0:	7442                	ld	s0,48(sp)
    800038a2:	74a2                	ld	s1,40(sp)
    800038a4:	7902                	ld	s2,32(sp)
    800038a6:	69e2                	ld	s3,24(sp)
    800038a8:	6a42                	ld	s4,16(sp)
    800038aa:	6121                	addi	sp,sp,64
    800038ac:	8082                	ret

00000000800038ae <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800038ae:	711d                	addi	sp,sp,-96
    800038b0:	ec86                	sd	ra,88(sp)
    800038b2:	e8a2                	sd	s0,80(sp)
    800038b4:	e4a6                	sd	s1,72(sp)
    800038b6:	e0ca                	sd	s2,64(sp)
    800038b8:	fc4e                	sd	s3,56(sp)
    800038ba:	f852                	sd	s4,48(sp)
    800038bc:	f456                	sd	s5,40(sp)
    800038be:	f05a                	sd	s6,32(sp)
    800038c0:	ec5e                	sd	s7,24(sp)
    800038c2:	e862                	sd	s8,16(sp)
    800038c4:	e466                	sd	s9,8(sp)
    800038c6:	1080                	addi	s0,sp,96
    800038c8:	84aa                	mv	s1,a0
    800038ca:	8b2e                	mv	s6,a1
    800038cc:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800038ce:	00054703          	lbu	a4,0(a0)
    800038d2:	02f00793          	li	a5,47
    800038d6:	00f70e63          	beq	a4,a5,800038f2 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800038da:	818fe0ef          	jal	800018f2 <myproc>
    800038de:	15053503          	ld	a0,336(a0)
    800038e2:	a87ff0ef          	jal	80003368 <idup>
    800038e6:	8a2a                	mv	s4,a0
  while(*path == '/')
    800038e8:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800038ec:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800038ee:	4b85                	li	s7,1
    800038f0:	a871                	j	8000398c <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    800038f2:	4585                	li	a1,1
    800038f4:	4505                	li	a0,1
    800038f6:	fc8ff0ef          	jal	800030be <iget>
    800038fa:	8a2a                	mv	s4,a0
    800038fc:	b7f5                	j	800038e8 <namex+0x3a>
      iunlockput(ip);
    800038fe:	8552                	mv	a0,s4
    80003900:	ca9ff0ef          	jal	800035a8 <iunlockput>
      return 0;
    80003904:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003906:	8552                	mv	a0,s4
    80003908:	60e6                	ld	ra,88(sp)
    8000390a:	6446                	ld	s0,80(sp)
    8000390c:	64a6                	ld	s1,72(sp)
    8000390e:	6906                	ld	s2,64(sp)
    80003910:	79e2                	ld	s3,56(sp)
    80003912:	7a42                	ld	s4,48(sp)
    80003914:	7aa2                	ld	s5,40(sp)
    80003916:	7b02                	ld	s6,32(sp)
    80003918:	6be2                	ld	s7,24(sp)
    8000391a:	6c42                	ld	s8,16(sp)
    8000391c:	6ca2                	ld	s9,8(sp)
    8000391e:	6125                	addi	sp,sp,96
    80003920:	8082                	ret
      iunlock(ip);
    80003922:	8552                	mv	a0,s4
    80003924:	b29ff0ef          	jal	8000344c <iunlock>
      return ip;
    80003928:	bff9                	j	80003906 <namex+0x58>
      iunlockput(ip);
    8000392a:	8552                	mv	a0,s4
    8000392c:	c7dff0ef          	jal	800035a8 <iunlockput>
      return 0;
    80003930:	8a4e                	mv	s4,s3
    80003932:	bfd1                	j	80003906 <namex+0x58>
  len = path - s;
    80003934:	40998633          	sub	a2,s3,s1
    80003938:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000393c:	099c5063          	bge	s8,s9,800039bc <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003940:	4639                	li	a2,14
    80003942:	85a6                	mv	a1,s1
    80003944:	8556                	mv	a0,s5
    80003946:	bdefd0ef          	jal	80000d24 <memmove>
    8000394a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000394c:	0004c783          	lbu	a5,0(s1)
    80003950:	01279763          	bne	a5,s2,8000395e <namex+0xb0>
    path++;
    80003954:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003956:	0004c783          	lbu	a5,0(s1)
    8000395a:	ff278de3          	beq	a5,s2,80003954 <namex+0xa6>
    ilock(ip);
    8000395e:	8552                	mv	a0,s4
    80003960:	a3fff0ef          	jal	8000339e <ilock>
    if(ip->type != T_DIR){
    80003964:	044a1783          	lh	a5,68(s4)
    80003968:	f9779be3          	bne	a5,s7,800038fe <namex+0x50>
    if(nameiparent && *path == '\0'){
    8000396c:	000b0563          	beqz	s6,80003976 <namex+0xc8>
    80003970:	0004c783          	lbu	a5,0(s1)
    80003974:	d7dd                	beqz	a5,80003922 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003976:	4601                	li	a2,0
    80003978:	85d6                	mv	a1,s5
    8000397a:	8552                	mv	a0,s4
    8000397c:	e97ff0ef          	jal	80003812 <dirlookup>
    80003980:	89aa                	mv	s3,a0
    80003982:	d545                	beqz	a0,8000392a <namex+0x7c>
    iunlockput(ip);
    80003984:	8552                	mv	a0,s4
    80003986:	c23ff0ef          	jal	800035a8 <iunlockput>
    ip = next;
    8000398a:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000398c:	0004c783          	lbu	a5,0(s1)
    80003990:	01279763          	bne	a5,s2,8000399e <namex+0xf0>
    path++;
    80003994:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003996:	0004c783          	lbu	a5,0(s1)
    8000399a:	ff278de3          	beq	a5,s2,80003994 <namex+0xe6>
  if(*path == 0)
    8000399e:	cb8d                	beqz	a5,800039d0 <namex+0x122>
  while(*path != '/' && *path != 0)
    800039a0:	0004c783          	lbu	a5,0(s1)
    800039a4:	89a6                	mv	s3,s1
  len = path - s;
    800039a6:	4c81                	li	s9,0
    800039a8:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800039aa:	01278963          	beq	a5,s2,800039bc <namex+0x10e>
    800039ae:	d3d9                	beqz	a5,80003934 <namex+0x86>
    path++;
    800039b0:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800039b2:	0009c783          	lbu	a5,0(s3)
    800039b6:	ff279ce3          	bne	a5,s2,800039ae <namex+0x100>
    800039ba:	bfad                	j	80003934 <namex+0x86>
    memmove(name, s, len);
    800039bc:	2601                	sext.w	a2,a2
    800039be:	85a6                	mv	a1,s1
    800039c0:	8556                	mv	a0,s5
    800039c2:	b62fd0ef          	jal	80000d24 <memmove>
    name[len] = 0;
    800039c6:	9cd6                	add	s9,s9,s5
    800039c8:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800039cc:	84ce                	mv	s1,s3
    800039ce:	bfbd                	j	8000394c <namex+0x9e>
  if(nameiparent){
    800039d0:	f20b0be3          	beqz	s6,80003906 <namex+0x58>
    iput(ip);
    800039d4:	8552                	mv	a0,s4
    800039d6:	b4bff0ef          	jal	80003520 <iput>
    return 0;
    800039da:	4a01                	li	s4,0
    800039dc:	b72d                	j	80003906 <namex+0x58>

00000000800039de <dirlink>:
{
    800039de:	7139                	addi	sp,sp,-64
    800039e0:	fc06                	sd	ra,56(sp)
    800039e2:	f822                	sd	s0,48(sp)
    800039e4:	f04a                	sd	s2,32(sp)
    800039e6:	ec4e                	sd	s3,24(sp)
    800039e8:	e852                	sd	s4,16(sp)
    800039ea:	0080                	addi	s0,sp,64
    800039ec:	892a                	mv	s2,a0
    800039ee:	8a2e                	mv	s4,a1
    800039f0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800039f2:	4601                	li	a2,0
    800039f4:	e1fff0ef          	jal	80003812 <dirlookup>
    800039f8:	e535                	bnez	a0,80003a64 <dirlink+0x86>
    800039fa:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800039fc:	04c92483          	lw	s1,76(s2)
    80003a00:	c48d                	beqz	s1,80003a2a <dirlink+0x4c>
    80003a02:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a04:	4741                	li	a4,16
    80003a06:	86a6                	mv	a3,s1
    80003a08:	fc040613          	addi	a2,s0,-64
    80003a0c:	4581                	li	a1,0
    80003a0e:	854a                	mv	a0,s2
    80003a10:	be3ff0ef          	jal	800035f2 <readi>
    80003a14:	47c1                	li	a5,16
    80003a16:	04f51b63          	bne	a0,a5,80003a6c <dirlink+0x8e>
    if(de.inum == 0)
    80003a1a:	fc045783          	lhu	a5,-64(s0)
    80003a1e:	c791                	beqz	a5,80003a2a <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a20:	24c1                	addiw	s1,s1,16
    80003a22:	04c92783          	lw	a5,76(s2)
    80003a26:	fcf4efe3          	bltu	s1,a5,80003a04 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003a2a:	4639                	li	a2,14
    80003a2c:	85d2                	mv	a1,s4
    80003a2e:	fc240513          	addi	a0,s0,-62
    80003a32:	b98fd0ef          	jal	80000dca <strncpy>
  de.inum = inum;
    80003a36:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a3a:	4741                	li	a4,16
    80003a3c:	86a6                	mv	a3,s1
    80003a3e:	fc040613          	addi	a2,s0,-64
    80003a42:	4581                	li	a1,0
    80003a44:	854a                	mv	a0,s2
    80003a46:	ca9ff0ef          	jal	800036ee <writei>
    80003a4a:	1541                	addi	a0,a0,-16
    80003a4c:	00a03533          	snez	a0,a0
    80003a50:	40a00533          	neg	a0,a0
    80003a54:	74a2                	ld	s1,40(sp)
}
    80003a56:	70e2                	ld	ra,56(sp)
    80003a58:	7442                	ld	s0,48(sp)
    80003a5a:	7902                	ld	s2,32(sp)
    80003a5c:	69e2                	ld	s3,24(sp)
    80003a5e:	6a42                	ld	s4,16(sp)
    80003a60:	6121                	addi	sp,sp,64
    80003a62:	8082                	ret
    iput(ip);
    80003a64:	abdff0ef          	jal	80003520 <iput>
    return -1;
    80003a68:	557d                	li	a0,-1
    80003a6a:	b7f5                	j	80003a56 <dirlink+0x78>
      panic("dirlink read");
    80003a6c:	00004517          	auipc	a0,0x4
    80003a70:	b5c50513          	addi	a0,a0,-1188 # 800075c8 <etext+0x5c8>
    80003a74:	d21fc0ef          	jal	80000794 <panic>

0000000080003a78 <namei>:

struct inode*
namei(char *path)
{
    80003a78:	1101                	addi	sp,sp,-32
    80003a7a:	ec06                	sd	ra,24(sp)
    80003a7c:	e822                	sd	s0,16(sp)
    80003a7e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003a80:	fe040613          	addi	a2,s0,-32
    80003a84:	4581                	li	a1,0
    80003a86:	e29ff0ef          	jal	800038ae <namex>
}
    80003a8a:	60e2                	ld	ra,24(sp)
    80003a8c:	6442                	ld	s0,16(sp)
    80003a8e:	6105                	addi	sp,sp,32
    80003a90:	8082                	ret

0000000080003a92 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003a92:	1141                	addi	sp,sp,-16
    80003a94:	e406                	sd	ra,8(sp)
    80003a96:	e022                	sd	s0,0(sp)
    80003a98:	0800                	addi	s0,sp,16
    80003a9a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003a9c:	4585                	li	a1,1
    80003a9e:	e11ff0ef          	jal	800038ae <namex>
}
    80003aa2:	60a2                	ld	ra,8(sp)
    80003aa4:	6402                	ld	s0,0(sp)
    80003aa6:	0141                	addi	sp,sp,16
    80003aa8:	8082                	ret

0000000080003aaa <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003aaa:	1101                	addi	sp,sp,-32
    80003aac:	ec06                	sd	ra,24(sp)
    80003aae:	e822                	sd	s0,16(sp)
    80003ab0:	e426                	sd	s1,8(sp)
    80003ab2:	e04a                	sd	s2,0(sp)
    80003ab4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003ab6:	0001c917          	auipc	s2,0x1c
    80003aba:	44a90913          	addi	s2,s2,1098 # 8001ff00 <log>
    80003abe:	01892583          	lw	a1,24(s2)
    80003ac2:	02892503          	lw	a0,40(s2)
    80003ac6:	9a0ff0ef          	jal	80002c66 <bread>
    80003aca:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003acc:	02c92603          	lw	a2,44(s2)
    80003ad0:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003ad2:	00c05f63          	blez	a2,80003af0 <write_head+0x46>
    80003ad6:	0001c717          	auipc	a4,0x1c
    80003ada:	45a70713          	addi	a4,a4,1114 # 8001ff30 <log+0x30>
    80003ade:	87aa                	mv	a5,a0
    80003ae0:	060a                	slli	a2,a2,0x2
    80003ae2:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003ae4:	4314                	lw	a3,0(a4)
    80003ae6:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003ae8:	0711                	addi	a4,a4,4
    80003aea:	0791                	addi	a5,a5,4
    80003aec:	fec79ce3          	bne	a5,a2,80003ae4 <write_head+0x3a>
  }
  bwrite(buf);
    80003af0:	8526                	mv	a0,s1
    80003af2:	a4aff0ef          	jal	80002d3c <bwrite>
  brelse(buf);
    80003af6:	8526                	mv	a0,s1
    80003af8:	a76ff0ef          	jal	80002d6e <brelse>
}
    80003afc:	60e2                	ld	ra,24(sp)
    80003afe:	6442                	ld	s0,16(sp)
    80003b00:	64a2                	ld	s1,8(sp)
    80003b02:	6902                	ld	s2,0(sp)
    80003b04:	6105                	addi	sp,sp,32
    80003b06:	8082                	ret

0000000080003b08 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b08:	0001c797          	auipc	a5,0x1c
    80003b0c:	4247a783          	lw	a5,1060(a5) # 8001ff2c <log+0x2c>
    80003b10:	08f05f63          	blez	a5,80003bae <install_trans+0xa6>
{
    80003b14:	7139                	addi	sp,sp,-64
    80003b16:	fc06                	sd	ra,56(sp)
    80003b18:	f822                	sd	s0,48(sp)
    80003b1a:	f426                	sd	s1,40(sp)
    80003b1c:	f04a                	sd	s2,32(sp)
    80003b1e:	ec4e                	sd	s3,24(sp)
    80003b20:	e852                	sd	s4,16(sp)
    80003b22:	e456                	sd	s5,8(sp)
    80003b24:	e05a                	sd	s6,0(sp)
    80003b26:	0080                	addi	s0,sp,64
    80003b28:	8b2a                	mv	s6,a0
    80003b2a:	0001ca97          	auipc	s5,0x1c
    80003b2e:	406a8a93          	addi	s5,s5,1030 # 8001ff30 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b32:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003b34:	0001c997          	auipc	s3,0x1c
    80003b38:	3cc98993          	addi	s3,s3,972 # 8001ff00 <log>
    80003b3c:	a829                	j	80003b56 <install_trans+0x4e>
    brelse(lbuf);
    80003b3e:	854a                	mv	a0,s2
    80003b40:	a2eff0ef          	jal	80002d6e <brelse>
    brelse(dbuf);
    80003b44:	8526                	mv	a0,s1
    80003b46:	a28ff0ef          	jal	80002d6e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b4a:	2a05                	addiw	s4,s4,1
    80003b4c:	0a91                	addi	s5,s5,4
    80003b4e:	02c9a783          	lw	a5,44(s3)
    80003b52:	04fa5463          	bge	s4,a5,80003b9a <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003b56:	0189a583          	lw	a1,24(s3)
    80003b5a:	014585bb          	addw	a1,a1,s4
    80003b5e:	2585                	addiw	a1,a1,1
    80003b60:	0289a503          	lw	a0,40(s3)
    80003b64:	902ff0ef          	jal	80002c66 <bread>
    80003b68:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003b6a:	000aa583          	lw	a1,0(s5)
    80003b6e:	0289a503          	lw	a0,40(s3)
    80003b72:	8f4ff0ef          	jal	80002c66 <bread>
    80003b76:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003b78:	40000613          	li	a2,1024
    80003b7c:	05890593          	addi	a1,s2,88
    80003b80:	05850513          	addi	a0,a0,88
    80003b84:	9a0fd0ef          	jal	80000d24 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003b88:	8526                	mv	a0,s1
    80003b8a:	9b2ff0ef          	jal	80002d3c <bwrite>
    if(recovering == 0)
    80003b8e:	fa0b18e3          	bnez	s6,80003b3e <install_trans+0x36>
      bunpin(dbuf);
    80003b92:	8526                	mv	a0,s1
    80003b94:	a96ff0ef          	jal	80002e2a <bunpin>
    80003b98:	b75d                	j	80003b3e <install_trans+0x36>
}
    80003b9a:	70e2                	ld	ra,56(sp)
    80003b9c:	7442                	ld	s0,48(sp)
    80003b9e:	74a2                	ld	s1,40(sp)
    80003ba0:	7902                	ld	s2,32(sp)
    80003ba2:	69e2                	ld	s3,24(sp)
    80003ba4:	6a42                	ld	s4,16(sp)
    80003ba6:	6aa2                	ld	s5,8(sp)
    80003ba8:	6b02                	ld	s6,0(sp)
    80003baa:	6121                	addi	sp,sp,64
    80003bac:	8082                	ret
    80003bae:	8082                	ret

0000000080003bb0 <initlog>:
{
    80003bb0:	7179                	addi	sp,sp,-48
    80003bb2:	f406                	sd	ra,40(sp)
    80003bb4:	f022                	sd	s0,32(sp)
    80003bb6:	ec26                	sd	s1,24(sp)
    80003bb8:	e84a                	sd	s2,16(sp)
    80003bba:	e44e                	sd	s3,8(sp)
    80003bbc:	1800                	addi	s0,sp,48
    80003bbe:	892a                	mv	s2,a0
    80003bc0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003bc2:	0001c497          	auipc	s1,0x1c
    80003bc6:	33e48493          	addi	s1,s1,830 # 8001ff00 <log>
    80003bca:	00004597          	auipc	a1,0x4
    80003bce:	a0e58593          	addi	a1,a1,-1522 # 800075d8 <etext+0x5d8>
    80003bd2:	8526                	mv	a0,s1
    80003bd4:	fa1fc0ef          	jal	80000b74 <initlock>
  log.start = sb->logstart;
    80003bd8:	0149a583          	lw	a1,20(s3)
    80003bdc:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003bde:	0109a783          	lw	a5,16(s3)
    80003be2:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003be4:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003be8:	854a                	mv	a0,s2
    80003bea:	87cff0ef          	jal	80002c66 <bread>
  log.lh.n = lh->n;
    80003bee:	4d30                	lw	a2,88(a0)
    80003bf0:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003bf2:	00c05f63          	blez	a2,80003c10 <initlog+0x60>
    80003bf6:	87aa                	mv	a5,a0
    80003bf8:	0001c717          	auipc	a4,0x1c
    80003bfc:	33870713          	addi	a4,a4,824 # 8001ff30 <log+0x30>
    80003c00:	060a                	slli	a2,a2,0x2
    80003c02:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003c04:	4ff4                	lw	a3,92(a5)
    80003c06:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003c08:	0791                	addi	a5,a5,4
    80003c0a:	0711                	addi	a4,a4,4
    80003c0c:	fec79ce3          	bne	a5,a2,80003c04 <initlog+0x54>
  brelse(buf);
    80003c10:	95eff0ef          	jal	80002d6e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003c14:	4505                	li	a0,1
    80003c16:	ef3ff0ef          	jal	80003b08 <install_trans>
  log.lh.n = 0;
    80003c1a:	0001c797          	auipc	a5,0x1c
    80003c1e:	3007a923          	sw	zero,786(a5) # 8001ff2c <log+0x2c>
  write_head(); // clear the log
    80003c22:	e89ff0ef          	jal	80003aaa <write_head>
}
    80003c26:	70a2                	ld	ra,40(sp)
    80003c28:	7402                	ld	s0,32(sp)
    80003c2a:	64e2                	ld	s1,24(sp)
    80003c2c:	6942                	ld	s2,16(sp)
    80003c2e:	69a2                	ld	s3,8(sp)
    80003c30:	6145                	addi	sp,sp,48
    80003c32:	8082                	ret

0000000080003c34 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003c34:	1101                	addi	sp,sp,-32
    80003c36:	ec06                	sd	ra,24(sp)
    80003c38:	e822                	sd	s0,16(sp)
    80003c3a:	e426                	sd	s1,8(sp)
    80003c3c:	e04a                	sd	s2,0(sp)
    80003c3e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003c40:	0001c517          	auipc	a0,0x1c
    80003c44:	2c050513          	addi	a0,a0,704 # 8001ff00 <log>
    80003c48:	fadfc0ef          	jal	80000bf4 <acquire>
  while(1){
    if(log.committing){
    80003c4c:	0001c497          	auipc	s1,0x1c
    80003c50:	2b448493          	addi	s1,s1,692 # 8001ff00 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003c54:	4979                	li	s2,30
    80003c56:	a029                	j	80003c60 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003c58:	85a6                	mv	a1,s1
    80003c5a:	8526                	mv	a0,s1
    80003c5c:	87efe0ef          	jal	80001cda <sleep>
    if(log.committing){
    80003c60:	50dc                	lw	a5,36(s1)
    80003c62:	fbfd                	bnez	a5,80003c58 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003c64:	5098                	lw	a4,32(s1)
    80003c66:	2705                	addiw	a4,a4,1
    80003c68:	0027179b          	slliw	a5,a4,0x2
    80003c6c:	9fb9                	addw	a5,a5,a4
    80003c6e:	0017979b          	slliw	a5,a5,0x1
    80003c72:	54d4                	lw	a3,44(s1)
    80003c74:	9fb5                	addw	a5,a5,a3
    80003c76:	00f95763          	bge	s2,a5,80003c84 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003c7a:	85a6                	mv	a1,s1
    80003c7c:	8526                	mv	a0,s1
    80003c7e:	85cfe0ef          	jal	80001cda <sleep>
    80003c82:	bff9                	j	80003c60 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003c84:	0001c517          	auipc	a0,0x1c
    80003c88:	27c50513          	addi	a0,a0,636 # 8001ff00 <log>
    80003c8c:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003c8e:	ffffc0ef          	jal	80000c8c <release>
      break;
    }
  }
}
    80003c92:	60e2                	ld	ra,24(sp)
    80003c94:	6442                	ld	s0,16(sp)
    80003c96:	64a2                	ld	s1,8(sp)
    80003c98:	6902                	ld	s2,0(sp)
    80003c9a:	6105                	addi	sp,sp,32
    80003c9c:	8082                	ret

0000000080003c9e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003c9e:	7139                	addi	sp,sp,-64
    80003ca0:	fc06                	sd	ra,56(sp)
    80003ca2:	f822                	sd	s0,48(sp)
    80003ca4:	f426                	sd	s1,40(sp)
    80003ca6:	f04a                	sd	s2,32(sp)
    80003ca8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003caa:	0001c497          	auipc	s1,0x1c
    80003cae:	25648493          	addi	s1,s1,598 # 8001ff00 <log>
    80003cb2:	8526                	mv	a0,s1
    80003cb4:	f41fc0ef          	jal	80000bf4 <acquire>
  log.outstanding -= 1;
    80003cb8:	509c                	lw	a5,32(s1)
    80003cba:	37fd                	addiw	a5,a5,-1
    80003cbc:	0007891b          	sext.w	s2,a5
    80003cc0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003cc2:	50dc                	lw	a5,36(s1)
    80003cc4:	ef9d                	bnez	a5,80003d02 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003cc6:	04091763          	bnez	s2,80003d14 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003cca:	0001c497          	auipc	s1,0x1c
    80003cce:	23648493          	addi	s1,s1,566 # 8001ff00 <log>
    80003cd2:	4785                	li	a5,1
    80003cd4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003cd6:	8526                	mv	a0,s1
    80003cd8:	fb5fc0ef          	jal	80000c8c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003cdc:	54dc                	lw	a5,44(s1)
    80003cde:	04f04b63          	bgtz	a5,80003d34 <end_op+0x96>
    acquire(&log.lock);
    80003ce2:	0001c497          	auipc	s1,0x1c
    80003ce6:	21e48493          	addi	s1,s1,542 # 8001ff00 <log>
    80003cea:	8526                	mv	a0,s1
    80003cec:	f09fc0ef          	jal	80000bf4 <acquire>
    log.committing = 0;
    80003cf0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003cf4:	8526                	mv	a0,s1
    80003cf6:	830fe0ef          	jal	80001d26 <wakeup>
    release(&log.lock);
    80003cfa:	8526                	mv	a0,s1
    80003cfc:	f91fc0ef          	jal	80000c8c <release>
}
    80003d00:	a025                	j	80003d28 <end_op+0x8a>
    80003d02:	ec4e                	sd	s3,24(sp)
    80003d04:	e852                	sd	s4,16(sp)
    80003d06:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003d08:	00004517          	auipc	a0,0x4
    80003d0c:	8d850513          	addi	a0,a0,-1832 # 800075e0 <etext+0x5e0>
    80003d10:	a85fc0ef          	jal	80000794 <panic>
    wakeup(&log);
    80003d14:	0001c497          	auipc	s1,0x1c
    80003d18:	1ec48493          	addi	s1,s1,492 # 8001ff00 <log>
    80003d1c:	8526                	mv	a0,s1
    80003d1e:	808fe0ef          	jal	80001d26 <wakeup>
  release(&log.lock);
    80003d22:	8526                	mv	a0,s1
    80003d24:	f69fc0ef          	jal	80000c8c <release>
}
    80003d28:	70e2                	ld	ra,56(sp)
    80003d2a:	7442                	ld	s0,48(sp)
    80003d2c:	74a2                	ld	s1,40(sp)
    80003d2e:	7902                	ld	s2,32(sp)
    80003d30:	6121                	addi	sp,sp,64
    80003d32:	8082                	ret
    80003d34:	ec4e                	sd	s3,24(sp)
    80003d36:	e852                	sd	s4,16(sp)
    80003d38:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d3a:	0001ca97          	auipc	s5,0x1c
    80003d3e:	1f6a8a93          	addi	s5,s5,502 # 8001ff30 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003d42:	0001ca17          	auipc	s4,0x1c
    80003d46:	1bea0a13          	addi	s4,s4,446 # 8001ff00 <log>
    80003d4a:	018a2583          	lw	a1,24(s4)
    80003d4e:	012585bb          	addw	a1,a1,s2
    80003d52:	2585                	addiw	a1,a1,1
    80003d54:	028a2503          	lw	a0,40(s4)
    80003d58:	f0ffe0ef          	jal	80002c66 <bread>
    80003d5c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003d5e:	000aa583          	lw	a1,0(s5)
    80003d62:	028a2503          	lw	a0,40(s4)
    80003d66:	f01fe0ef          	jal	80002c66 <bread>
    80003d6a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003d6c:	40000613          	li	a2,1024
    80003d70:	05850593          	addi	a1,a0,88
    80003d74:	05848513          	addi	a0,s1,88
    80003d78:	fadfc0ef          	jal	80000d24 <memmove>
    bwrite(to);  // write the log
    80003d7c:	8526                	mv	a0,s1
    80003d7e:	fbffe0ef          	jal	80002d3c <bwrite>
    brelse(from);
    80003d82:	854e                	mv	a0,s3
    80003d84:	febfe0ef          	jal	80002d6e <brelse>
    brelse(to);
    80003d88:	8526                	mv	a0,s1
    80003d8a:	fe5fe0ef          	jal	80002d6e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d8e:	2905                	addiw	s2,s2,1
    80003d90:	0a91                	addi	s5,s5,4
    80003d92:	02ca2783          	lw	a5,44(s4)
    80003d96:	faf94ae3          	blt	s2,a5,80003d4a <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003d9a:	d11ff0ef          	jal	80003aaa <write_head>
    install_trans(0); // Now install writes to home locations
    80003d9e:	4501                	li	a0,0
    80003da0:	d69ff0ef          	jal	80003b08 <install_trans>
    log.lh.n = 0;
    80003da4:	0001c797          	auipc	a5,0x1c
    80003da8:	1807a423          	sw	zero,392(a5) # 8001ff2c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003dac:	cffff0ef          	jal	80003aaa <write_head>
    80003db0:	69e2                	ld	s3,24(sp)
    80003db2:	6a42                	ld	s4,16(sp)
    80003db4:	6aa2                	ld	s5,8(sp)
    80003db6:	b735                	j	80003ce2 <end_op+0x44>

0000000080003db8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003db8:	1101                	addi	sp,sp,-32
    80003dba:	ec06                	sd	ra,24(sp)
    80003dbc:	e822                	sd	s0,16(sp)
    80003dbe:	e426                	sd	s1,8(sp)
    80003dc0:	e04a                	sd	s2,0(sp)
    80003dc2:	1000                	addi	s0,sp,32
    80003dc4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003dc6:	0001c917          	auipc	s2,0x1c
    80003dca:	13a90913          	addi	s2,s2,314 # 8001ff00 <log>
    80003dce:	854a                	mv	a0,s2
    80003dd0:	e25fc0ef          	jal	80000bf4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003dd4:	02c92603          	lw	a2,44(s2)
    80003dd8:	47f5                	li	a5,29
    80003dda:	06c7c363          	blt	a5,a2,80003e40 <log_write+0x88>
    80003dde:	0001c797          	auipc	a5,0x1c
    80003de2:	13e7a783          	lw	a5,318(a5) # 8001ff1c <log+0x1c>
    80003de6:	37fd                	addiw	a5,a5,-1
    80003de8:	04f65c63          	bge	a2,a5,80003e40 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003dec:	0001c797          	auipc	a5,0x1c
    80003df0:	1347a783          	lw	a5,308(a5) # 8001ff20 <log+0x20>
    80003df4:	04f05c63          	blez	a5,80003e4c <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003df8:	4781                	li	a5,0
    80003dfa:	04c05f63          	blez	a2,80003e58 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003dfe:	44cc                	lw	a1,12(s1)
    80003e00:	0001c717          	auipc	a4,0x1c
    80003e04:	13070713          	addi	a4,a4,304 # 8001ff30 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003e08:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003e0a:	4314                	lw	a3,0(a4)
    80003e0c:	04b68663          	beq	a3,a1,80003e58 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003e10:	2785                	addiw	a5,a5,1
    80003e12:	0711                	addi	a4,a4,4
    80003e14:	fef61be3          	bne	a2,a5,80003e0a <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003e18:	0621                	addi	a2,a2,8
    80003e1a:	060a                	slli	a2,a2,0x2
    80003e1c:	0001c797          	auipc	a5,0x1c
    80003e20:	0e478793          	addi	a5,a5,228 # 8001ff00 <log>
    80003e24:	97b2                	add	a5,a5,a2
    80003e26:	44d8                	lw	a4,12(s1)
    80003e28:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003e2a:	8526                	mv	a0,s1
    80003e2c:	fcbfe0ef          	jal	80002df6 <bpin>
    log.lh.n++;
    80003e30:	0001c717          	auipc	a4,0x1c
    80003e34:	0d070713          	addi	a4,a4,208 # 8001ff00 <log>
    80003e38:	575c                	lw	a5,44(a4)
    80003e3a:	2785                	addiw	a5,a5,1
    80003e3c:	d75c                	sw	a5,44(a4)
    80003e3e:	a80d                	j	80003e70 <log_write+0xb8>
    panic("too big a transaction");
    80003e40:	00003517          	auipc	a0,0x3
    80003e44:	7b050513          	addi	a0,a0,1968 # 800075f0 <etext+0x5f0>
    80003e48:	94dfc0ef          	jal	80000794 <panic>
    panic("log_write outside of trans");
    80003e4c:	00003517          	auipc	a0,0x3
    80003e50:	7bc50513          	addi	a0,a0,1980 # 80007608 <etext+0x608>
    80003e54:	941fc0ef          	jal	80000794 <panic>
  log.lh.block[i] = b->blockno;
    80003e58:	00878693          	addi	a3,a5,8
    80003e5c:	068a                	slli	a3,a3,0x2
    80003e5e:	0001c717          	auipc	a4,0x1c
    80003e62:	0a270713          	addi	a4,a4,162 # 8001ff00 <log>
    80003e66:	9736                	add	a4,a4,a3
    80003e68:	44d4                	lw	a3,12(s1)
    80003e6a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003e6c:	faf60fe3          	beq	a2,a5,80003e2a <log_write+0x72>
  }
  release(&log.lock);
    80003e70:	0001c517          	auipc	a0,0x1c
    80003e74:	09050513          	addi	a0,a0,144 # 8001ff00 <log>
    80003e78:	e15fc0ef          	jal	80000c8c <release>
}
    80003e7c:	60e2                	ld	ra,24(sp)
    80003e7e:	6442                	ld	s0,16(sp)
    80003e80:	64a2                	ld	s1,8(sp)
    80003e82:	6902                	ld	s2,0(sp)
    80003e84:	6105                	addi	sp,sp,32
    80003e86:	8082                	ret

0000000080003e88 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003e88:	1101                	addi	sp,sp,-32
    80003e8a:	ec06                	sd	ra,24(sp)
    80003e8c:	e822                	sd	s0,16(sp)
    80003e8e:	e426                	sd	s1,8(sp)
    80003e90:	e04a                	sd	s2,0(sp)
    80003e92:	1000                	addi	s0,sp,32
    80003e94:	84aa                	mv	s1,a0
    80003e96:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003e98:	00003597          	auipc	a1,0x3
    80003e9c:	79058593          	addi	a1,a1,1936 # 80007628 <etext+0x628>
    80003ea0:	0521                	addi	a0,a0,8
    80003ea2:	cd3fc0ef          	jal	80000b74 <initlock>
  lk->name = name;
    80003ea6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003eaa:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003eae:	0204a423          	sw	zero,40(s1)
}
    80003eb2:	60e2                	ld	ra,24(sp)
    80003eb4:	6442                	ld	s0,16(sp)
    80003eb6:	64a2                	ld	s1,8(sp)
    80003eb8:	6902                	ld	s2,0(sp)
    80003eba:	6105                	addi	sp,sp,32
    80003ebc:	8082                	ret

0000000080003ebe <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003ebe:	1101                	addi	sp,sp,-32
    80003ec0:	ec06                	sd	ra,24(sp)
    80003ec2:	e822                	sd	s0,16(sp)
    80003ec4:	e426                	sd	s1,8(sp)
    80003ec6:	e04a                	sd	s2,0(sp)
    80003ec8:	1000                	addi	s0,sp,32
    80003eca:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ecc:	00850913          	addi	s2,a0,8
    80003ed0:	854a                	mv	a0,s2
    80003ed2:	d23fc0ef          	jal	80000bf4 <acquire>
  while (lk->locked) {
    80003ed6:	409c                	lw	a5,0(s1)
    80003ed8:	c799                	beqz	a5,80003ee6 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003eda:	85ca                	mv	a1,s2
    80003edc:	8526                	mv	a0,s1
    80003ede:	dfdfd0ef          	jal	80001cda <sleep>
  while (lk->locked) {
    80003ee2:	409c                	lw	a5,0(s1)
    80003ee4:	fbfd                	bnez	a5,80003eda <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003ee6:	4785                	li	a5,1
    80003ee8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003eea:	a09fd0ef          	jal	800018f2 <myproc>
    80003eee:	591c                	lw	a5,48(a0)
    80003ef0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003ef2:	854a                	mv	a0,s2
    80003ef4:	d99fc0ef          	jal	80000c8c <release>
}
    80003ef8:	60e2                	ld	ra,24(sp)
    80003efa:	6442                	ld	s0,16(sp)
    80003efc:	64a2                	ld	s1,8(sp)
    80003efe:	6902                	ld	s2,0(sp)
    80003f00:	6105                	addi	sp,sp,32
    80003f02:	8082                	ret

0000000080003f04 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003f04:	1101                	addi	sp,sp,-32
    80003f06:	ec06                	sd	ra,24(sp)
    80003f08:	e822                	sd	s0,16(sp)
    80003f0a:	e426                	sd	s1,8(sp)
    80003f0c:	e04a                	sd	s2,0(sp)
    80003f0e:	1000                	addi	s0,sp,32
    80003f10:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003f12:	00850913          	addi	s2,a0,8
    80003f16:	854a                	mv	a0,s2
    80003f18:	cddfc0ef          	jal	80000bf4 <acquire>
  lk->locked = 0;
    80003f1c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003f20:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003f24:	8526                	mv	a0,s1
    80003f26:	e01fd0ef          	jal	80001d26 <wakeup>
  release(&lk->lk);
    80003f2a:	854a                	mv	a0,s2
    80003f2c:	d61fc0ef          	jal	80000c8c <release>
}
    80003f30:	60e2                	ld	ra,24(sp)
    80003f32:	6442                	ld	s0,16(sp)
    80003f34:	64a2                	ld	s1,8(sp)
    80003f36:	6902                	ld	s2,0(sp)
    80003f38:	6105                	addi	sp,sp,32
    80003f3a:	8082                	ret

0000000080003f3c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003f3c:	7179                	addi	sp,sp,-48
    80003f3e:	f406                	sd	ra,40(sp)
    80003f40:	f022                	sd	s0,32(sp)
    80003f42:	ec26                	sd	s1,24(sp)
    80003f44:	e84a                	sd	s2,16(sp)
    80003f46:	1800                	addi	s0,sp,48
    80003f48:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003f4a:	00850913          	addi	s2,a0,8
    80003f4e:	854a                	mv	a0,s2
    80003f50:	ca5fc0ef          	jal	80000bf4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003f54:	409c                	lw	a5,0(s1)
    80003f56:	ef81                	bnez	a5,80003f6e <holdingsleep+0x32>
    80003f58:	4481                	li	s1,0
  release(&lk->lk);
    80003f5a:	854a                	mv	a0,s2
    80003f5c:	d31fc0ef          	jal	80000c8c <release>
  return r;
}
    80003f60:	8526                	mv	a0,s1
    80003f62:	70a2                	ld	ra,40(sp)
    80003f64:	7402                	ld	s0,32(sp)
    80003f66:	64e2                	ld	s1,24(sp)
    80003f68:	6942                	ld	s2,16(sp)
    80003f6a:	6145                	addi	sp,sp,48
    80003f6c:	8082                	ret
    80003f6e:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003f70:	0284a983          	lw	s3,40(s1)
    80003f74:	97ffd0ef          	jal	800018f2 <myproc>
    80003f78:	5904                	lw	s1,48(a0)
    80003f7a:	413484b3          	sub	s1,s1,s3
    80003f7e:	0014b493          	seqz	s1,s1
    80003f82:	69a2                	ld	s3,8(sp)
    80003f84:	bfd9                	j	80003f5a <holdingsleep+0x1e>

0000000080003f86 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003f86:	1141                	addi	sp,sp,-16
    80003f88:	e406                	sd	ra,8(sp)
    80003f8a:	e022                	sd	s0,0(sp)
    80003f8c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003f8e:	00003597          	auipc	a1,0x3
    80003f92:	6aa58593          	addi	a1,a1,1706 # 80007638 <etext+0x638>
    80003f96:	0001c517          	auipc	a0,0x1c
    80003f9a:	0b250513          	addi	a0,a0,178 # 80020048 <ftable>
    80003f9e:	bd7fc0ef          	jal	80000b74 <initlock>
}
    80003fa2:	60a2                	ld	ra,8(sp)
    80003fa4:	6402                	ld	s0,0(sp)
    80003fa6:	0141                	addi	sp,sp,16
    80003fa8:	8082                	ret

0000000080003faa <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003faa:	1101                	addi	sp,sp,-32
    80003fac:	ec06                	sd	ra,24(sp)
    80003fae:	e822                	sd	s0,16(sp)
    80003fb0:	e426                	sd	s1,8(sp)
    80003fb2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003fb4:	0001c517          	auipc	a0,0x1c
    80003fb8:	09450513          	addi	a0,a0,148 # 80020048 <ftable>
    80003fbc:	c39fc0ef          	jal	80000bf4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003fc0:	0001c497          	auipc	s1,0x1c
    80003fc4:	0a048493          	addi	s1,s1,160 # 80020060 <ftable+0x18>
    80003fc8:	0001d717          	auipc	a4,0x1d
    80003fcc:	03870713          	addi	a4,a4,56 # 80021000 <disk>
    if(f->ref == 0){
    80003fd0:	40dc                	lw	a5,4(s1)
    80003fd2:	cf89                	beqz	a5,80003fec <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003fd4:	02848493          	addi	s1,s1,40
    80003fd8:	fee49ce3          	bne	s1,a4,80003fd0 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003fdc:	0001c517          	auipc	a0,0x1c
    80003fe0:	06c50513          	addi	a0,a0,108 # 80020048 <ftable>
    80003fe4:	ca9fc0ef          	jal	80000c8c <release>
  return 0;
    80003fe8:	4481                	li	s1,0
    80003fea:	a809                	j	80003ffc <filealloc+0x52>
      f->ref = 1;
    80003fec:	4785                	li	a5,1
    80003fee:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ff0:	0001c517          	auipc	a0,0x1c
    80003ff4:	05850513          	addi	a0,a0,88 # 80020048 <ftable>
    80003ff8:	c95fc0ef          	jal	80000c8c <release>
}
    80003ffc:	8526                	mv	a0,s1
    80003ffe:	60e2                	ld	ra,24(sp)
    80004000:	6442                	ld	s0,16(sp)
    80004002:	64a2                	ld	s1,8(sp)
    80004004:	6105                	addi	sp,sp,32
    80004006:	8082                	ret

0000000080004008 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004008:	1101                	addi	sp,sp,-32
    8000400a:	ec06                	sd	ra,24(sp)
    8000400c:	e822                	sd	s0,16(sp)
    8000400e:	e426                	sd	s1,8(sp)
    80004010:	1000                	addi	s0,sp,32
    80004012:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004014:	0001c517          	auipc	a0,0x1c
    80004018:	03450513          	addi	a0,a0,52 # 80020048 <ftable>
    8000401c:	bd9fc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    80004020:	40dc                	lw	a5,4(s1)
    80004022:	02f05063          	blez	a5,80004042 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004026:	2785                	addiw	a5,a5,1
    80004028:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000402a:	0001c517          	auipc	a0,0x1c
    8000402e:	01e50513          	addi	a0,a0,30 # 80020048 <ftable>
    80004032:	c5bfc0ef          	jal	80000c8c <release>
  return f;
}
    80004036:	8526                	mv	a0,s1
    80004038:	60e2                	ld	ra,24(sp)
    8000403a:	6442                	ld	s0,16(sp)
    8000403c:	64a2                	ld	s1,8(sp)
    8000403e:	6105                	addi	sp,sp,32
    80004040:	8082                	ret
    panic("filedup");
    80004042:	00003517          	auipc	a0,0x3
    80004046:	5fe50513          	addi	a0,a0,1534 # 80007640 <etext+0x640>
    8000404a:	f4afc0ef          	jal	80000794 <panic>

000000008000404e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000404e:	7139                	addi	sp,sp,-64
    80004050:	fc06                	sd	ra,56(sp)
    80004052:	f822                	sd	s0,48(sp)
    80004054:	f426                	sd	s1,40(sp)
    80004056:	0080                	addi	s0,sp,64
    80004058:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000405a:	0001c517          	auipc	a0,0x1c
    8000405e:	fee50513          	addi	a0,a0,-18 # 80020048 <ftable>
    80004062:	b93fc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    80004066:	40dc                	lw	a5,4(s1)
    80004068:	04f05a63          	blez	a5,800040bc <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    8000406c:	37fd                	addiw	a5,a5,-1
    8000406e:	0007871b          	sext.w	a4,a5
    80004072:	c0dc                	sw	a5,4(s1)
    80004074:	04e04e63          	bgtz	a4,800040d0 <fileclose+0x82>
    80004078:	f04a                	sd	s2,32(sp)
    8000407a:	ec4e                	sd	s3,24(sp)
    8000407c:	e852                	sd	s4,16(sp)
    8000407e:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004080:	0004a903          	lw	s2,0(s1)
    80004084:	0094ca83          	lbu	s5,9(s1)
    80004088:	0104ba03          	ld	s4,16(s1)
    8000408c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004090:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004094:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004098:	0001c517          	auipc	a0,0x1c
    8000409c:	fb050513          	addi	a0,a0,-80 # 80020048 <ftable>
    800040a0:	bedfc0ef          	jal	80000c8c <release>

  if(ff.type == FD_PIPE){
    800040a4:	4785                	li	a5,1
    800040a6:	04f90063          	beq	s2,a5,800040e6 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800040aa:	3979                	addiw	s2,s2,-2
    800040ac:	4785                	li	a5,1
    800040ae:	0527f563          	bgeu	a5,s2,800040f8 <fileclose+0xaa>
    800040b2:	7902                	ld	s2,32(sp)
    800040b4:	69e2                	ld	s3,24(sp)
    800040b6:	6a42                	ld	s4,16(sp)
    800040b8:	6aa2                	ld	s5,8(sp)
    800040ba:	a00d                	j	800040dc <fileclose+0x8e>
    800040bc:	f04a                	sd	s2,32(sp)
    800040be:	ec4e                	sd	s3,24(sp)
    800040c0:	e852                	sd	s4,16(sp)
    800040c2:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800040c4:	00003517          	auipc	a0,0x3
    800040c8:	58450513          	addi	a0,a0,1412 # 80007648 <etext+0x648>
    800040cc:	ec8fc0ef          	jal	80000794 <panic>
    release(&ftable.lock);
    800040d0:	0001c517          	auipc	a0,0x1c
    800040d4:	f7850513          	addi	a0,a0,-136 # 80020048 <ftable>
    800040d8:	bb5fc0ef          	jal	80000c8c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800040dc:	70e2                	ld	ra,56(sp)
    800040de:	7442                	ld	s0,48(sp)
    800040e0:	74a2                	ld	s1,40(sp)
    800040e2:	6121                	addi	sp,sp,64
    800040e4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800040e6:	85d6                	mv	a1,s5
    800040e8:	8552                	mv	a0,s4
    800040ea:	336000ef          	jal	80004420 <pipeclose>
    800040ee:	7902                	ld	s2,32(sp)
    800040f0:	69e2                	ld	s3,24(sp)
    800040f2:	6a42                	ld	s4,16(sp)
    800040f4:	6aa2                	ld	s5,8(sp)
    800040f6:	b7dd                	j	800040dc <fileclose+0x8e>
    begin_op();
    800040f8:	b3dff0ef          	jal	80003c34 <begin_op>
    iput(ff.ip);
    800040fc:	854e                	mv	a0,s3
    800040fe:	c22ff0ef          	jal	80003520 <iput>
    end_op();
    80004102:	b9dff0ef          	jal	80003c9e <end_op>
    80004106:	7902                	ld	s2,32(sp)
    80004108:	69e2                	ld	s3,24(sp)
    8000410a:	6a42                	ld	s4,16(sp)
    8000410c:	6aa2                	ld	s5,8(sp)
    8000410e:	b7f9                	j	800040dc <fileclose+0x8e>

0000000080004110 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004110:	715d                	addi	sp,sp,-80
    80004112:	e486                	sd	ra,72(sp)
    80004114:	e0a2                	sd	s0,64(sp)
    80004116:	fc26                	sd	s1,56(sp)
    80004118:	f44e                	sd	s3,40(sp)
    8000411a:	0880                	addi	s0,sp,80
    8000411c:	84aa                	mv	s1,a0
    8000411e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004120:	fd2fd0ef          	jal	800018f2 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004124:	409c                	lw	a5,0(s1)
    80004126:	37f9                	addiw	a5,a5,-2
    80004128:	4705                	li	a4,1
    8000412a:	04f76063          	bltu	a4,a5,8000416a <filestat+0x5a>
    8000412e:	f84a                	sd	s2,48(sp)
    80004130:	892a                	mv	s2,a0
    ilock(f->ip);
    80004132:	6c88                	ld	a0,24(s1)
    80004134:	a6aff0ef          	jal	8000339e <ilock>
    stati(f->ip, &st);
    80004138:	fb840593          	addi	a1,s0,-72
    8000413c:	6c88                	ld	a0,24(s1)
    8000413e:	c8aff0ef          	jal	800035c8 <stati>
    iunlock(f->ip);
    80004142:	6c88                	ld	a0,24(s1)
    80004144:	b08ff0ef          	jal	8000344c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004148:	46e1                	li	a3,24
    8000414a:	fb840613          	addi	a2,s0,-72
    8000414e:	85ce                	mv	a1,s3
    80004150:	05093503          	ld	a0,80(s2)
    80004154:	c02fd0ef          	jal	80001556 <copyout>
    80004158:	41f5551b          	sraiw	a0,a0,0x1f
    8000415c:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000415e:	60a6                	ld	ra,72(sp)
    80004160:	6406                	ld	s0,64(sp)
    80004162:	74e2                	ld	s1,56(sp)
    80004164:	79a2                	ld	s3,40(sp)
    80004166:	6161                	addi	sp,sp,80
    80004168:	8082                	ret
  return -1;
    8000416a:	557d                	li	a0,-1
    8000416c:	bfcd                	j	8000415e <filestat+0x4e>

000000008000416e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000416e:	7179                	addi	sp,sp,-48
    80004170:	f406                	sd	ra,40(sp)
    80004172:	f022                	sd	s0,32(sp)
    80004174:	e84a                	sd	s2,16(sp)
    80004176:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004178:	00854783          	lbu	a5,8(a0)
    8000417c:	cfd1                	beqz	a5,80004218 <fileread+0xaa>
    8000417e:	ec26                	sd	s1,24(sp)
    80004180:	e44e                	sd	s3,8(sp)
    80004182:	84aa                	mv	s1,a0
    80004184:	89ae                	mv	s3,a1
    80004186:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004188:	411c                	lw	a5,0(a0)
    8000418a:	4705                	li	a4,1
    8000418c:	04e78363          	beq	a5,a4,800041d2 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004190:	470d                	li	a4,3
    80004192:	04e78763          	beq	a5,a4,800041e0 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004196:	4709                	li	a4,2
    80004198:	06e79a63          	bne	a5,a4,8000420c <fileread+0x9e>
    ilock(f->ip);
    8000419c:	6d08                	ld	a0,24(a0)
    8000419e:	a00ff0ef          	jal	8000339e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800041a2:	874a                	mv	a4,s2
    800041a4:	5094                	lw	a3,32(s1)
    800041a6:	864e                	mv	a2,s3
    800041a8:	4585                	li	a1,1
    800041aa:	6c88                	ld	a0,24(s1)
    800041ac:	c46ff0ef          	jal	800035f2 <readi>
    800041b0:	892a                	mv	s2,a0
    800041b2:	00a05563          	blez	a0,800041bc <fileread+0x4e>
      f->off += r;
    800041b6:	509c                	lw	a5,32(s1)
    800041b8:	9fa9                	addw	a5,a5,a0
    800041ba:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800041bc:	6c88                	ld	a0,24(s1)
    800041be:	a8eff0ef          	jal	8000344c <iunlock>
    800041c2:	64e2                	ld	s1,24(sp)
    800041c4:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800041c6:	854a                	mv	a0,s2
    800041c8:	70a2                	ld	ra,40(sp)
    800041ca:	7402                	ld	s0,32(sp)
    800041cc:	6942                	ld	s2,16(sp)
    800041ce:	6145                	addi	sp,sp,48
    800041d0:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800041d2:	6908                	ld	a0,16(a0)
    800041d4:	388000ef          	jal	8000455c <piperead>
    800041d8:	892a                	mv	s2,a0
    800041da:	64e2                	ld	s1,24(sp)
    800041dc:	69a2                	ld	s3,8(sp)
    800041de:	b7e5                	j	800041c6 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800041e0:	02451783          	lh	a5,36(a0)
    800041e4:	03079693          	slli	a3,a5,0x30
    800041e8:	92c1                	srli	a3,a3,0x30
    800041ea:	4725                	li	a4,9
    800041ec:	02d76863          	bltu	a4,a3,8000421c <fileread+0xae>
    800041f0:	0792                	slli	a5,a5,0x4
    800041f2:	0001c717          	auipc	a4,0x1c
    800041f6:	db670713          	addi	a4,a4,-586 # 8001ffa8 <devsw>
    800041fa:	97ba                	add	a5,a5,a4
    800041fc:	639c                	ld	a5,0(a5)
    800041fe:	c39d                	beqz	a5,80004224 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004200:	4505                	li	a0,1
    80004202:	9782                	jalr	a5
    80004204:	892a                	mv	s2,a0
    80004206:	64e2                	ld	s1,24(sp)
    80004208:	69a2                	ld	s3,8(sp)
    8000420a:	bf75                	j	800041c6 <fileread+0x58>
    panic("fileread");
    8000420c:	00003517          	auipc	a0,0x3
    80004210:	44c50513          	addi	a0,a0,1100 # 80007658 <etext+0x658>
    80004214:	d80fc0ef          	jal	80000794 <panic>
    return -1;
    80004218:	597d                	li	s2,-1
    8000421a:	b775                	j	800041c6 <fileread+0x58>
      return -1;
    8000421c:	597d                	li	s2,-1
    8000421e:	64e2                	ld	s1,24(sp)
    80004220:	69a2                	ld	s3,8(sp)
    80004222:	b755                	j	800041c6 <fileread+0x58>
    80004224:	597d                	li	s2,-1
    80004226:	64e2                	ld	s1,24(sp)
    80004228:	69a2                	ld	s3,8(sp)
    8000422a:	bf71                	j	800041c6 <fileread+0x58>

000000008000422c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000422c:	00954783          	lbu	a5,9(a0)
    80004230:	10078b63          	beqz	a5,80004346 <filewrite+0x11a>
{
    80004234:	715d                	addi	sp,sp,-80
    80004236:	e486                	sd	ra,72(sp)
    80004238:	e0a2                	sd	s0,64(sp)
    8000423a:	f84a                	sd	s2,48(sp)
    8000423c:	f052                	sd	s4,32(sp)
    8000423e:	e85a                	sd	s6,16(sp)
    80004240:	0880                	addi	s0,sp,80
    80004242:	892a                	mv	s2,a0
    80004244:	8b2e                	mv	s6,a1
    80004246:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004248:	411c                	lw	a5,0(a0)
    8000424a:	4705                	li	a4,1
    8000424c:	02e78763          	beq	a5,a4,8000427a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004250:	470d                	li	a4,3
    80004252:	02e78863          	beq	a5,a4,80004282 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004256:	4709                	li	a4,2
    80004258:	0ce79c63          	bne	a5,a4,80004330 <filewrite+0x104>
    8000425c:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000425e:	0ac05863          	blez	a2,8000430e <filewrite+0xe2>
    80004262:	fc26                	sd	s1,56(sp)
    80004264:	ec56                	sd	s5,24(sp)
    80004266:	e45e                	sd	s7,8(sp)
    80004268:	e062                	sd	s8,0(sp)
    int i = 0;
    8000426a:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000426c:	6b85                	lui	s7,0x1
    8000426e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004272:	6c05                	lui	s8,0x1
    80004274:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004278:	a8b5                	j	800042f4 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    8000427a:	6908                	ld	a0,16(a0)
    8000427c:	1fc000ef          	jal	80004478 <pipewrite>
    80004280:	a04d                	j	80004322 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004282:	02451783          	lh	a5,36(a0)
    80004286:	03079693          	slli	a3,a5,0x30
    8000428a:	92c1                	srli	a3,a3,0x30
    8000428c:	4725                	li	a4,9
    8000428e:	0ad76e63          	bltu	a4,a3,8000434a <filewrite+0x11e>
    80004292:	0792                	slli	a5,a5,0x4
    80004294:	0001c717          	auipc	a4,0x1c
    80004298:	d1470713          	addi	a4,a4,-748 # 8001ffa8 <devsw>
    8000429c:	97ba                	add	a5,a5,a4
    8000429e:	679c                	ld	a5,8(a5)
    800042a0:	c7dd                	beqz	a5,8000434e <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800042a2:	4505                	li	a0,1
    800042a4:	9782                	jalr	a5
    800042a6:	a8b5                	j	80004322 <filewrite+0xf6>
      if(n1 > max)
    800042a8:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800042ac:	989ff0ef          	jal	80003c34 <begin_op>
      ilock(f->ip);
    800042b0:	01893503          	ld	a0,24(s2)
    800042b4:	8eaff0ef          	jal	8000339e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800042b8:	8756                	mv	a4,s5
    800042ba:	02092683          	lw	a3,32(s2)
    800042be:	01698633          	add	a2,s3,s6
    800042c2:	4585                	li	a1,1
    800042c4:	01893503          	ld	a0,24(s2)
    800042c8:	c26ff0ef          	jal	800036ee <writei>
    800042cc:	84aa                	mv	s1,a0
    800042ce:	00a05763          	blez	a0,800042dc <filewrite+0xb0>
        f->off += r;
    800042d2:	02092783          	lw	a5,32(s2)
    800042d6:	9fa9                	addw	a5,a5,a0
    800042d8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800042dc:	01893503          	ld	a0,24(s2)
    800042e0:	96cff0ef          	jal	8000344c <iunlock>
      end_op();
    800042e4:	9bbff0ef          	jal	80003c9e <end_op>

      if(r != n1){
    800042e8:	029a9563          	bne	s5,s1,80004312 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800042ec:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800042f0:	0149da63          	bge	s3,s4,80004304 <filewrite+0xd8>
      int n1 = n - i;
    800042f4:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800042f8:	0004879b          	sext.w	a5,s1
    800042fc:	fafbd6e3          	bge	s7,a5,800042a8 <filewrite+0x7c>
    80004300:	84e2                	mv	s1,s8
    80004302:	b75d                	j	800042a8 <filewrite+0x7c>
    80004304:	74e2                	ld	s1,56(sp)
    80004306:	6ae2                	ld	s5,24(sp)
    80004308:	6ba2                	ld	s7,8(sp)
    8000430a:	6c02                	ld	s8,0(sp)
    8000430c:	a039                	j	8000431a <filewrite+0xee>
    int i = 0;
    8000430e:	4981                	li	s3,0
    80004310:	a029                	j	8000431a <filewrite+0xee>
    80004312:	74e2                	ld	s1,56(sp)
    80004314:	6ae2                	ld	s5,24(sp)
    80004316:	6ba2                	ld	s7,8(sp)
    80004318:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000431a:	033a1c63          	bne	s4,s3,80004352 <filewrite+0x126>
    8000431e:	8552                	mv	a0,s4
    80004320:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004322:	60a6                	ld	ra,72(sp)
    80004324:	6406                	ld	s0,64(sp)
    80004326:	7942                	ld	s2,48(sp)
    80004328:	7a02                	ld	s4,32(sp)
    8000432a:	6b42                	ld	s6,16(sp)
    8000432c:	6161                	addi	sp,sp,80
    8000432e:	8082                	ret
    80004330:	fc26                	sd	s1,56(sp)
    80004332:	f44e                	sd	s3,40(sp)
    80004334:	ec56                	sd	s5,24(sp)
    80004336:	e45e                	sd	s7,8(sp)
    80004338:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000433a:	00003517          	auipc	a0,0x3
    8000433e:	32e50513          	addi	a0,a0,814 # 80007668 <etext+0x668>
    80004342:	c52fc0ef          	jal	80000794 <panic>
    return -1;
    80004346:	557d                	li	a0,-1
}
    80004348:	8082                	ret
      return -1;
    8000434a:	557d                	li	a0,-1
    8000434c:	bfd9                	j	80004322 <filewrite+0xf6>
    8000434e:	557d                	li	a0,-1
    80004350:	bfc9                	j	80004322 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80004352:	557d                	li	a0,-1
    80004354:	79a2                	ld	s3,40(sp)
    80004356:	b7f1                	j	80004322 <filewrite+0xf6>

0000000080004358 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004358:	7179                	addi	sp,sp,-48
    8000435a:	f406                	sd	ra,40(sp)
    8000435c:	f022                	sd	s0,32(sp)
    8000435e:	ec26                	sd	s1,24(sp)
    80004360:	e052                	sd	s4,0(sp)
    80004362:	1800                	addi	s0,sp,48
    80004364:	84aa                	mv	s1,a0
    80004366:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004368:	0005b023          	sd	zero,0(a1)
    8000436c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004370:	c3bff0ef          	jal	80003faa <filealloc>
    80004374:	e088                	sd	a0,0(s1)
    80004376:	c549                	beqz	a0,80004400 <pipealloc+0xa8>
    80004378:	c33ff0ef          	jal	80003faa <filealloc>
    8000437c:	00aa3023          	sd	a0,0(s4)
    80004380:	cd25                	beqz	a0,800043f8 <pipealloc+0xa0>
    80004382:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004384:	fa0fc0ef          	jal	80000b24 <kalloc>
    80004388:	892a                	mv	s2,a0
    8000438a:	c12d                	beqz	a0,800043ec <pipealloc+0x94>
    8000438c:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000438e:	4985                	li	s3,1
    80004390:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004394:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004398:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000439c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800043a0:	00003597          	auipc	a1,0x3
    800043a4:	2d858593          	addi	a1,a1,728 # 80007678 <etext+0x678>
    800043a8:	fccfc0ef          	jal	80000b74 <initlock>
  (*f0)->type = FD_PIPE;
    800043ac:	609c                	ld	a5,0(s1)
    800043ae:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800043b2:	609c                	ld	a5,0(s1)
    800043b4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800043b8:	609c                	ld	a5,0(s1)
    800043ba:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800043be:	609c                	ld	a5,0(s1)
    800043c0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800043c4:	000a3783          	ld	a5,0(s4)
    800043c8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800043cc:	000a3783          	ld	a5,0(s4)
    800043d0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800043d4:	000a3783          	ld	a5,0(s4)
    800043d8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800043dc:	000a3783          	ld	a5,0(s4)
    800043e0:	0127b823          	sd	s2,16(a5)
  return 0;
    800043e4:	4501                	li	a0,0
    800043e6:	6942                	ld	s2,16(sp)
    800043e8:	69a2                	ld	s3,8(sp)
    800043ea:	a01d                	j	80004410 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800043ec:	6088                	ld	a0,0(s1)
    800043ee:	c119                	beqz	a0,800043f4 <pipealloc+0x9c>
    800043f0:	6942                	ld	s2,16(sp)
    800043f2:	a029                	j	800043fc <pipealloc+0xa4>
    800043f4:	6942                	ld	s2,16(sp)
    800043f6:	a029                	j	80004400 <pipealloc+0xa8>
    800043f8:	6088                	ld	a0,0(s1)
    800043fa:	c10d                	beqz	a0,8000441c <pipealloc+0xc4>
    fileclose(*f0);
    800043fc:	c53ff0ef          	jal	8000404e <fileclose>
  if(*f1)
    80004400:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004404:	557d                	li	a0,-1
  if(*f1)
    80004406:	c789                	beqz	a5,80004410 <pipealloc+0xb8>
    fileclose(*f1);
    80004408:	853e                	mv	a0,a5
    8000440a:	c45ff0ef          	jal	8000404e <fileclose>
  return -1;
    8000440e:	557d                	li	a0,-1
}
    80004410:	70a2                	ld	ra,40(sp)
    80004412:	7402                	ld	s0,32(sp)
    80004414:	64e2                	ld	s1,24(sp)
    80004416:	6a02                	ld	s4,0(sp)
    80004418:	6145                	addi	sp,sp,48
    8000441a:	8082                	ret
  return -1;
    8000441c:	557d                	li	a0,-1
    8000441e:	bfcd                	j	80004410 <pipealloc+0xb8>

0000000080004420 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004420:	1101                	addi	sp,sp,-32
    80004422:	ec06                	sd	ra,24(sp)
    80004424:	e822                	sd	s0,16(sp)
    80004426:	e426                	sd	s1,8(sp)
    80004428:	e04a                	sd	s2,0(sp)
    8000442a:	1000                	addi	s0,sp,32
    8000442c:	84aa                	mv	s1,a0
    8000442e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004430:	fc4fc0ef          	jal	80000bf4 <acquire>
  if(writable){
    80004434:	02090763          	beqz	s2,80004462 <pipeclose+0x42>
    pi->writeopen = 0;
    80004438:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000443c:	21848513          	addi	a0,s1,536
    80004440:	8e7fd0ef          	jal	80001d26 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004444:	2204b783          	ld	a5,544(s1)
    80004448:	e785                	bnez	a5,80004470 <pipeclose+0x50>
    release(&pi->lock);
    8000444a:	8526                	mv	a0,s1
    8000444c:	841fc0ef          	jal	80000c8c <release>
    kfree((char*)pi);
    80004450:	8526                	mv	a0,s1
    80004452:	df0fc0ef          	jal	80000a42 <kfree>
  } else
    release(&pi->lock);
}
    80004456:	60e2                	ld	ra,24(sp)
    80004458:	6442                	ld	s0,16(sp)
    8000445a:	64a2                	ld	s1,8(sp)
    8000445c:	6902                	ld	s2,0(sp)
    8000445e:	6105                	addi	sp,sp,32
    80004460:	8082                	ret
    pi->readopen = 0;
    80004462:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004466:	21c48513          	addi	a0,s1,540
    8000446a:	8bdfd0ef          	jal	80001d26 <wakeup>
    8000446e:	bfd9                	j	80004444 <pipeclose+0x24>
    release(&pi->lock);
    80004470:	8526                	mv	a0,s1
    80004472:	81bfc0ef          	jal	80000c8c <release>
}
    80004476:	b7c5                	j	80004456 <pipeclose+0x36>

0000000080004478 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004478:	711d                	addi	sp,sp,-96
    8000447a:	ec86                	sd	ra,88(sp)
    8000447c:	e8a2                	sd	s0,80(sp)
    8000447e:	e4a6                	sd	s1,72(sp)
    80004480:	e0ca                	sd	s2,64(sp)
    80004482:	fc4e                	sd	s3,56(sp)
    80004484:	f852                	sd	s4,48(sp)
    80004486:	f456                	sd	s5,40(sp)
    80004488:	1080                	addi	s0,sp,96
    8000448a:	84aa                	mv	s1,a0
    8000448c:	8aae                	mv	s5,a1
    8000448e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004490:	c62fd0ef          	jal	800018f2 <myproc>
    80004494:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004496:	8526                	mv	a0,s1
    80004498:	f5cfc0ef          	jal	80000bf4 <acquire>
  while(i < n){
    8000449c:	0b405a63          	blez	s4,80004550 <pipewrite+0xd8>
    800044a0:	f05a                	sd	s6,32(sp)
    800044a2:	ec5e                	sd	s7,24(sp)
    800044a4:	e862                	sd	s8,16(sp)
  int i = 0;
    800044a6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800044a8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800044aa:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800044ae:	21c48b93          	addi	s7,s1,540
    800044b2:	a81d                	j	800044e8 <pipewrite+0x70>
      release(&pi->lock);
    800044b4:	8526                	mv	a0,s1
    800044b6:	fd6fc0ef          	jal	80000c8c <release>
      return -1;
    800044ba:	597d                	li	s2,-1
    800044bc:	7b02                	ld	s6,32(sp)
    800044be:	6be2                	ld	s7,24(sp)
    800044c0:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800044c2:	854a                	mv	a0,s2
    800044c4:	60e6                	ld	ra,88(sp)
    800044c6:	6446                	ld	s0,80(sp)
    800044c8:	64a6                	ld	s1,72(sp)
    800044ca:	6906                	ld	s2,64(sp)
    800044cc:	79e2                	ld	s3,56(sp)
    800044ce:	7a42                	ld	s4,48(sp)
    800044d0:	7aa2                	ld	s5,40(sp)
    800044d2:	6125                	addi	sp,sp,96
    800044d4:	8082                	ret
      wakeup(&pi->nread);
    800044d6:	8562                	mv	a0,s8
    800044d8:	84ffd0ef          	jal	80001d26 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800044dc:	85a6                	mv	a1,s1
    800044de:	855e                	mv	a0,s7
    800044e0:	ffafd0ef          	jal	80001cda <sleep>
  while(i < n){
    800044e4:	05495b63          	bge	s2,s4,8000453a <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800044e8:	2204a783          	lw	a5,544(s1)
    800044ec:	d7e1                	beqz	a5,800044b4 <pipewrite+0x3c>
    800044ee:	854e                	mv	a0,s3
    800044f0:	981fd0ef          	jal	80001e70 <killed>
    800044f4:	f161                	bnez	a0,800044b4 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800044f6:	2184a783          	lw	a5,536(s1)
    800044fa:	21c4a703          	lw	a4,540(s1)
    800044fe:	2007879b          	addiw	a5,a5,512
    80004502:	fcf70ae3          	beq	a4,a5,800044d6 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004506:	4685                	li	a3,1
    80004508:	01590633          	add	a2,s2,s5
    8000450c:	faf40593          	addi	a1,s0,-81
    80004510:	0509b503          	ld	a0,80(s3)
    80004514:	918fd0ef          	jal	8000162c <copyin>
    80004518:	03650e63          	beq	a0,s6,80004554 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000451c:	21c4a783          	lw	a5,540(s1)
    80004520:	0017871b          	addiw	a4,a5,1
    80004524:	20e4ae23          	sw	a4,540(s1)
    80004528:	1ff7f793          	andi	a5,a5,511
    8000452c:	97a6                	add	a5,a5,s1
    8000452e:	faf44703          	lbu	a4,-81(s0)
    80004532:	00e78c23          	sb	a4,24(a5)
      i++;
    80004536:	2905                	addiw	s2,s2,1
    80004538:	b775                	j	800044e4 <pipewrite+0x6c>
    8000453a:	7b02                	ld	s6,32(sp)
    8000453c:	6be2                	ld	s7,24(sp)
    8000453e:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004540:	21848513          	addi	a0,s1,536
    80004544:	fe2fd0ef          	jal	80001d26 <wakeup>
  release(&pi->lock);
    80004548:	8526                	mv	a0,s1
    8000454a:	f42fc0ef          	jal	80000c8c <release>
  return i;
    8000454e:	bf95                	j	800044c2 <pipewrite+0x4a>
  int i = 0;
    80004550:	4901                	li	s2,0
    80004552:	b7fd                	j	80004540 <pipewrite+0xc8>
    80004554:	7b02                	ld	s6,32(sp)
    80004556:	6be2                	ld	s7,24(sp)
    80004558:	6c42                	ld	s8,16(sp)
    8000455a:	b7dd                	j	80004540 <pipewrite+0xc8>

000000008000455c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000455c:	715d                	addi	sp,sp,-80
    8000455e:	e486                	sd	ra,72(sp)
    80004560:	e0a2                	sd	s0,64(sp)
    80004562:	fc26                	sd	s1,56(sp)
    80004564:	f84a                	sd	s2,48(sp)
    80004566:	f44e                	sd	s3,40(sp)
    80004568:	f052                	sd	s4,32(sp)
    8000456a:	ec56                	sd	s5,24(sp)
    8000456c:	0880                	addi	s0,sp,80
    8000456e:	84aa                	mv	s1,a0
    80004570:	892e                	mv	s2,a1
    80004572:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004574:	b7efd0ef          	jal	800018f2 <myproc>
    80004578:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000457a:	8526                	mv	a0,s1
    8000457c:	e78fc0ef          	jal	80000bf4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004580:	2184a703          	lw	a4,536(s1)
    80004584:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004588:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000458c:	02f71563          	bne	a4,a5,800045b6 <piperead+0x5a>
    80004590:	2244a783          	lw	a5,548(s1)
    80004594:	cb85                	beqz	a5,800045c4 <piperead+0x68>
    if(killed(pr)){
    80004596:	8552                	mv	a0,s4
    80004598:	8d9fd0ef          	jal	80001e70 <killed>
    8000459c:	ed19                	bnez	a0,800045ba <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000459e:	85a6                	mv	a1,s1
    800045a0:	854e                	mv	a0,s3
    800045a2:	f38fd0ef          	jal	80001cda <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800045a6:	2184a703          	lw	a4,536(s1)
    800045aa:	21c4a783          	lw	a5,540(s1)
    800045ae:	fef701e3          	beq	a4,a5,80004590 <piperead+0x34>
    800045b2:	e85a                	sd	s6,16(sp)
    800045b4:	a809                	j	800045c6 <piperead+0x6a>
    800045b6:	e85a                	sd	s6,16(sp)
    800045b8:	a039                	j	800045c6 <piperead+0x6a>
      release(&pi->lock);
    800045ba:	8526                	mv	a0,s1
    800045bc:	ed0fc0ef          	jal	80000c8c <release>
      return -1;
    800045c0:	59fd                	li	s3,-1
    800045c2:	a8b1                	j	8000461e <piperead+0xc2>
    800045c4:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800045c6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800045c8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800045ca:	05505263          	blez	s5,8000460e <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800045ce:	2184a783          	lw	a5,536(s1)
    800045d2:	21c4a703          	lw	a4,540(s1)
    800045d6:	02f70c63          	beq	a4,a5,8000460e <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800045da:	0017871b          	addiw	a4,a5,1
    800045de:	20e4ac23          	sw	a4,536(s1)
    800045e2:	1ff7f793          	andi	a5,a5,511
    800045e6:	97a6                	add	a5,a5,s1
    800045e8:	0187c783          	lbu	a5,24(a5)
    800045ec:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800045f0:	4685                	li	a3,1
    800045f2:	fbf40613          	addi	a2,s0,-65
    800045f6:	85ca                	mv	a1,s2
    800045f8:	050a3503          	ld	a0,80(s4)
    800045fc:	f5bfc0ef          	jal	80001556 <copyout>
    80004600:	01650763          	beq	a0,s6,8000460e <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004604:	2985                	addiw	s3,s3,1
    80004606:	0905                	addi	s2,s2,1
    80004608:	fd3a93e3          	bne	s5,s3,800045ce <piperead+0x72>
    8000460c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000460e:	21c48513          	addi	a0,s1,540
    80004612:	f14fd0ef          	jal	80001d26 <wakeup>
  release(&pi->lock);
    80004616:	8526                	mv	a0,s1
    80004618:	e74fc0ef          	jal	80000c8c <release>
    8000461c:	6b42                	ld	s6,16(sp)
  return i;
}
    8000461e:	854e                	mv	a0,s3
    80004620:	60a6                	ld	ra,72(sp)
    80004622:	6406                	ld	s0,64(sp)
    80004624:	74e2                	ld	s1,56(sp)
    80004626:	7942                	ld	s2,48(sp)
    80004628:	79a2                	ld	s3,40(sp)
    8000462a:	7a02                	ld	s4,32(sp)
    8000462c:	6ae2                	ld	s5,24(sp)
    8000462e:	6161                	addi	sp,sp,80
    80004630:	8082                	ret

0000000080004632 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004632:	1141                	addi	sp,sp,-16
    80004634:	e422                	sd	s0,8(sp)
    80004636:	0800                	addi	s0,sp,16
    80004638:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000463a:	8905                	andi	a0,a0,1
    8000463c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000463e:	8b89                	andi	a5,a5,2
    80004640:	c399                	beqz	a5,80004646 <flags2perm+0x14>
      perm |= PTE_W;
    80004642:	00456513          	ori	a0,a0,4
    return perm;
}
    80004646:	6422                	ld	s0,8(sp)
    80004648:	0141                	addi	sp,sp,16
    8000464a:	8082                	ret

000000008000464c <exec>:

int
exec(char *path, char **argv)
{
    8000464c:	df010113          	addi	sp,sp,-528
    80004650:	20113423          	sd	ra,520(sp)
    80004654:	20813023          	sd	s0,512(sp)
    80004658:	ffa6                	sd	s1,504(sp)
    8000465a:	fbca                	sd	s2,496(sp)
    8000465c:	0c00                	addi	s0,sp,528
    8000465e:	892a                	mv	s2,a0
    80004660:	dea43c23          	sd	a0,-520(s0)
    80004664:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004668:	a8afd0ef          	jal	800018f2 <myproc>
    8000466c:	84aa                	mv	s1,a0

  begin_op();
    8000466e:	dc6ff0ef          	jal	80003c34 <begin_op>

  if((ip = namei(path)) == 0){
    80004672:	854a                	mv	a0,s2
    80004674:	c04ff0ef          	jal	80003a78 <namei>
    80004678:	c931                	beqz	a0,800046cc <exec+0x80>
    8000467a:	f3d2                	sd	s4,480(sp)
    8000467c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000467e:	d21fe0ef          	jal	8000339e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004682:	04000713          	li	a4,64
    80004686:	4681                	li	a3,0
    80004688:	e5040613          	addi	a2,s0,-432
    8000468c:	4581                	li	a1,0
    8000468e:	8552                	mv	a0,s4
    80004690:	f63fe0ef          	jal	800035f2 <readi>
    80004694:	04000793          	li	a5,64
    80004698:	00f51a63          	bne	a0,a5,800046ac <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000469c:	e5042703          	lw	a4,-432(s0)
    800046a0:	464c47b7          	lui	a5,0x464c4
    800046a4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800046a8:	02f70663          	beq	a4,a5,800046d4 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800046ac:	8552                	mv	a0,s4
    800046ae:	efbfe0ef          	jal	800035a8 <iunlockput>
    end_op();
    800046b2:	decff0ef          	jal	80003c9e <end_op>
  }
  return -1;
    800046b6:	557d                	li	a0,-1
    800046b8:	7a1e                	ld	s4,480(sp)
}
    800046ba:	20813083          	ld	ra,520(sp)
    800046be:	20013403          	ld	s0,512(sp)
    800046c2:	74fe                	ld	s1,504(sp)
    800046c4:	795e                	ld	s2,496(sp)
    800046c6:	21010113          	addi	sp,sp,528
    800046ca:	8082                	ret
    end_op();
    800046cc:	dd2ff0ef          	jal	80003c9e <end_op>
    return -1;
    800046d0:	557d                	li	a0,-1
    800046d2:	b7e5                	j	800046ba <exec+0x6e>
    800046d4:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800046d6:	8526                	mv	a0,s1
    800046d8:	ac2fd0ef          	jal	8000199a <proc_pagetable>
    800046dc:	8b2a                	mv	s6,a0
    800046de:	2c050b63          	beqz	a0,800049b4 <exec+0x368>
    800046e2:	f7ce                	sd	s3,488(sp)
    800046e4:	efd6                	sd	s5,472(sp)
    800046e6:	e7de                	sd	s7,456(sp)
    800046e8:	e3e2                	sd	s8,448(sp)
    800046ea:	ff66                	sd	s9,440(sp)
    800046ec:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800046ee:	e7042d03          	lw	s10,-400(s0)
    800046f2:	e8845783          	lhu	a5,-376(s0)
    800046f6:	12078963          	beqz	a5,80004828 <exec+0x1dc>
    800046fa:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800046fc:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800046fe:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004700:	6c85                	lui	s9,0x1
    80004702:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004706:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000470a:	6a85                	lui	s5,0x1
    8000470c:	a085                	j	8000476c <exec+0x120>
      panic("loadseg: address should exist");
    8000470e:	00003517          	auipc	a0,0x3
    80004712:	f7250513          	addi	a0,a0,-142 # 80007680 <etext+0x680>
    80004716:	87efc0ef          	jal	80000794 <panic>
    if(sz - i < PGSIZE)
    8000471a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000471c:	8726                	mv	a4,s1
    8000471e:	012c06bb          	addw	a3,s8,s2
    80004722:	4581                	li	a1,0
    80004724:	8552                	mv	a0,s4
    80004726:	ecdfe0ef          	jal	800035f2 <readi>
    8000472a:	2501                	sext.w	a0,a0
    8000472c:	24a49a63          	bne	s1,a0,80004980 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80004730:	012a893b          	addw	s2,s5,s2
    80004734:	03397363          	bgeu	s2,s3,8000475a <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004738:	02091593          	slli	a1,s2,0x20
    8000473c:	9181                	srli	a1,a1,0x20
    8000473e:	95de                	add	a1,a1,s7
    80004740:	855a                	mv	a0,s6
    80004742:	899fc0ef          	jal	80000fda <walkaddr>
    80004746:	862a                	mv	a2,a0
    if(pa == 0)
    80004748:	d179                	beqz	a0,8000470e <exec+0xc2>
    if(sz - i < PGSIZE)
    8000474a:	412984bb          	subw	s1,s3,s2
    8000474e:	0004879b          	sext.w	a5,s1
    80004752:	fcfcf4e3          	bgeu	s9,a5,8000471a <exec+0xce>
    80004756:	84d6                	mv	s1,s5
    80004758:	b7c9                	j	8000471a <exec+0xce>
    sz = sz1;
    8000475a:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000475e:	2d85                	addiw	s11,s11,1
    80004760:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004764:	e8845783          	lhu	a5,-376(s0)
    80004768:	08fdd063          	bge	s11,a5,800047e8 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000476c:	2d01                	sext.w	s10,s10
    8000476e:	03800713          	li	a4,56
    80004772:	86ea                	mv	a3,s10
    80004774:	e1840613          	addi	a2,s0,-488
    80004778:	4581                	li	a1,0
    8000477a:	8552                	mv	a0,s4
    8000477c:	e77fe0ef          	jal	800035f2 <readi>
    80004780:	03800793          	li	a5,56
    80004784:	1cf51663          	bne	a0,a5,80004950 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004788:	e1842783          	lw	a5,-488(s0)
    8000478c:	4705                	li	a4,1
    8000478e:	fce798e3          	bne	a5,a4,8000475e <exec+0x112>
    if(ph.memsz < ph.filesz)
    80004792:	e4043483          	ld	s1,-448(s0)
    80004796:	e3843783          	ld	a5,-456(s0)
    8000479a:	1af4ef63          	bltu	s1,a5,80004958 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000479e:	e2843783          	ld	a5,-472(s0)
    800047a2:	94be                	add	s1,s1,a5
    800047a4:	1af4ee63          	bltu	s1,a5,80004960 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    800047a8:	df043703          	ld	a4,-528(s0)
    800047ac:	8ff9                	and	a5,a5,a4
    800047ae:	1a079d63          	bnez	a5,80004968 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800047b2:	e1c42503          	lw	a0,-484(s0)
    800047b6:	e7dff0ef          	jal	80004632 <flags2perm>
    800047ba:	86aa                	mv	a3,a0
    800047bc:	8626                	mv	a2,s1
    800047be:	85ca                	mv	a1,s2
    800047c0:	855a                	mv	a0,s6
    800047c2:	b81fc0ef          	jal	80001342 <uvmalloc>
    800047c6:	e0a43423          	sd	a0,-504(s0)
    800047ca:	1a050363          	beqz	a0,80004970 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800047ce:	e2843b83          	ld	s7,-472(s0)
    800047d2:	e2042c03          	lw	s8,-480(s0)
    800047d6:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800047da:	00098463          	beqz	s3,800047e2 <exec+0x196>
    800047de:	4901                	li	s2,0
    800047e0:	bfa1                	j	80004738 <exec+0xec>
    sz = sz1;
    800047e2:	e0843903          	ld	s2,-504(s0)
    800047e6:	bfa5                	j	8000475e <exec+0x112>
    800047e8:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800047ea:	8552                	mv	a0,s4
    800047ec:	dbdfe0ef          	jal	800035a8 <iunlockput>
  end_op();
    800047f0:	caeff0ef          	jal	80003c9e <end_op>
  p = myproc();
    800047f4:	8fefd0ef          	jal	800018f2 <myproc>
    800047f8:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800047fa:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800047fe:	6985                	lui	s3,0x1
    80004800:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004802:	99ca                	add	s3,s3,s2
    80004804:	77fd                	lui	a5,0xfffff
    80004806:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000480a:	4691                	li	a3,4
    8000480c:	6609                	lui	a2,0x2
    8000480e:	964e                	add	a2,a2,s3
    80004810:	85ce                	mv	a1,s3
    80004812:	855a                	mv	a0,s6
    80004814:	b2ffc0ef          	jal	80001342 <uvmalloc>
    80004818:	892a                	mv	s2,a0
    8000481a:	e0a43423          	sd	a0,-504(s0)
    8000481e:	e519                	bnez	a0,8000482c <exec+0x1e0>
  if(pagetable)
    80004820:	e1343423          	sd	s3,-504(s0)
    80004824:	4a01                	li	s4,0
    80004826:	aab1                	j	80004982 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004828:	4901                	li	s2,0
    8000482a:	b7c1                	j	800047ea <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    8000482c:	75f9                	lui	a1,0xffffe
    8000482e:	95aa                	add	a1,a1,a0
    80004830:	855a                	mv	a0,s6
    80004832:	cfbfc0ef          	jal	8000152c <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004836:	7bfd                	lui	s7,0xfffff
    80004838:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000483a:	e0043783          	ld	a5,-512(s0)
    8000483e:	6388                	ld	a0,0(a5)
    80004840:	cd39                	beqz	a0,8000489e <exec+0x252>
    80004842:	e9040993          	addi	s3,s0,-368
    80004846:	f9040c13          	addi	s8,s0,-112
    8000484a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000484c:	decfc0ef          	jal	80000e38 <strlen>
    80004850:	0015079b          	addiw	a5,a0,1
    80004854:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004858:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000485c:	11796e63          	bltu	s2,s7,80004978 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004860:	e0043d03          	ld	s10,-512(s0)
    80004864:	000d3a03          	ld	s4,0(s10)
    80004868:	8552                	mv	a0,s4
    8000486a:	dcefc0ef          	jal	80000e38 <strlen>
    8000486e:	0015069b          	addiw	a3,a0,1
    80004872:	8652                	mv	a2,s4
    80004874:	85ca                	mv	a1,s2
    80004876:	855a                	mv	a0,s6
    80004878:	cdffc0ef          	jal	80001556 <copyout>
    8000487c:	10054063          	bltz	a0,8000497c <exec+0x330>
    ustack[argc] = sp;
    80004880:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004884:	0485                	addi	s1,s1,1
    80004886:	008d0793          	addi	a5,s10,8
    8000488a:	e0f43023          	sd	a5,-512(s0)
    8000488e:	008d3503          	ld	a0,8(s10)
    80004892:	c909                	beqz	a0,800048a4 <exec+0x258>
    if(argc >= MAXARG)
    80004894:	09a1                	addi	s3,s3,8
    80004896:	fb899be3          	bne	s3,s8,8000484c <exec+0x200>
  ip = 0;
    8000489a:	4a01                	li	s4,0
    8000489c:	a0dd                	j	80004982 <exec+0x336>
  sp = sz;
    8000489e:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800048a2:	4481                	li	s1,0
  ustack[argc] = 0;
    800048a4:	00349793          	slli	a5,s1,0x3
    800048a8:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdde50>
    800048ac:	97a2                	add	a5,a5,s0
    800048ae:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800048b2:	00148693          	addi	a3,s1,1
    800048b6:	068e                	slli	a3,a3,0x3
    800048b8:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800048bc:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800048c0:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800048c4:	f5796ee3          	bltu	s2,s7,80004820 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800048c8:	e9040613          	addi	a2,s0,-368
    800048cc:	85ca                	mv	a1,s2
    800048ce:	855a                	mv	a0,s6
    800048d0:	c87fc0ef          	jal	80001556 <copyout>
    800048d4:	0e054263          	bltz	a0,800049b8 <exec+0x36c>
  p->trapframe->a1 = sp;
    800048d8:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800048dc:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800048e0:	df843783          	ld	a5,-520(s0)
    800048e4:	0007c703          	lbu	a4,0(a5)
    800048e8:	cf11                	beqz	a4,80004904 <exec+0x2b8>
    800048ea:	0785                	addi	a5,a5,1
    if(*s == '/')
    800048ec:	02f00693          	li	a3,47
    800048f0:	a039                	j	800048fe <exec+0x2b2>
      last = s+1;
    800048f2:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800048f6:	0785                	addi	a5,a5,1
    800048f8:	fff7c703          	lbu	a4,-1(a5)
    800048fc:	c701                	beqz	a4,80004904 <exec+0x2b8>
    if(*s == '/')
    800048fe:	fed71ce3          	bne	a4,a3,800048f6 <exec+0x2aa>
    80004902:	bfc5                	j	800048f2 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004904:	4641                	li	a2,16
    80004906:	df843583          	ld	a1,-520(s0)
    8000490a:	158a8513          	addi	a0,s5,344
    8000490e:	cf8fc0ef          	jal	80000e06 <safestrcpy>
  oldpagetable = p->pagetable;
    80004912:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004916:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000491a:	e0843783          	ld	a5,-504(s0)
    8000491e:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004922:	058ab783          	ld	a5,88(s5)
    80004926:	e6843703          	ld	a4,-408(s0)
    8000492a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000492c:	058ab783          	ld	a5,88(s5)
    80004930:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004934:	85e6                	mv	a1,s9
    80004936:	8e8fd0ef          	jal	80001a1e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000493a:	0004851b          	sext.w	a0,s1
    8000493e:	79be                	ld	s3,488(sp)
    80004940:	7a1e                	ld	s4,480(sp)
    80004942:	6afe                	ld	s5,472(sp)
    80004944:	6b5e                	ld	s6,464(sp)
    80004946:	6bbe                	ld	s7,456(sp)
    80004948:	6c1e                	ld	s8,448(sp)
    8000494a:	7cfa                	ld	s9,440(sp)
    8000494c:	7d5a                	ld	s10,432(sp)
    8000494e:	b3b5                	j	800046ba <exec+0x6e>
    80004950:	e1243423          	sd	s2,-504(s0)
    80004954:	7dba                	ld	s11,424(sp)
    80004956:	a035                	j	80004982 <exec+0x336>
    80004958:	e1243423          	sd	s2,-504(s0)
    8000495c:	7dba                	ld	s11,424(sp)
    8000495e:	a015                	j	80004982 <exec+0x336>
    80004960:	e1243423          	sd	s2,-504(s0)
    80004964:	7dba                	ld	s11,424(sp)
    80004966:	a831                	j	80004982 <exec+0x336>
    80004968:	e1243423          	sd	s2,-504(s0)
    8000496c:	7dba                	ld	s11,424(sp)
    8000496e:	a811                	j	80004982 <exec+0x336>
    80004970:	e1243423          	sd	s2,-504(s0)
    80004974:	7dba                	ld	s11,424(sp)
    80004976:	a031                	j	80004982 <exec+0x336>
  ip = 0;
    80004978:	4a01                	li	s4,0
    8000497a:	a021                	j	80004982 <exec+0x336>
    8000497c:	4a01                	li	s4,0
  if(pagetable)
    8000497e:	a011                	j	80004982 <exec+0x336>
    80004980:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004982:	e0843583          	ld	a1,-504(s0)
    80004986:	855a                	mv	a0,s6
    80004988:	896fd0ef          	jal	80001a1e <proc_freepagetable>
  return -1;
    8000498c:	557d                	li	a0,-1
  if(ip){
    8000498e:	000a1b63          	bnez	s4,800049a4 <exec+0x358>
    80004992:	79be                	ld	s3,488(sp)
    80004994:	7a1e                	ld	s4,480(sp)
    80004996:	6afe                	ld	s5,472(sp)
    80004998:	6b5e                	ld	s6,464(sp)
    8000499a:	6bbe                	ld	s7,456(sp)
    8000499c:	6c1e                	ld	s8,448(sp)
    8000499e:	7cfa                	ld	s9,440(sp)
    800049a0:	7d5a                	ld	s10,432(sp)
    800049a2:	bb21                	j	800046ba <exec+0x6e>
    800049a4:	79be                	ld	s3,488(sp)
    800049a6:	6afe                	ld	s5,472(sp)
    800049a8:	6b5e                	ld	s6,464(sp)
    800049aa:	6bbe                	ld	s7,456(sp)
    800049ac:	6c1e                	ld	s8,448(sp)
    800049ae:	7cfa                	ld	s9,440(sp)
    800049b0:	7d5a                	ld	s10,432(sp)
    800049b2:	b9ed                	j	800046ac <exec+0x60>
    800049b4:	6b5e                	ld	s6,464(sp)
    800049b6:	b9dd                	j	800046ac <exec+0x60>
  sz = sz1;
    800049b8:	e0843983          	ld	s3,-504(s0)
    800049bc:	b595                	j	80004820 <exec+0x1d4>

00000000800049be <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800049be:	7179                	addi	sp,sp,-48
    800049c0:	f406                	sd	ra,40(sp)
    800049c2:	f022                	sd	s0,32(sp)
    800049c4:	ec26                	sd	s1,24(sp)
    800049c6:	e84a                	sd	s2,16(sp)
    800049c8:	1800                	addi	s0,sp,48
    800049ca:	892e                	mv	s2,a1
    800049cc:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800049ce:	fdc40593          	addi	a1,s0,-36
    800049d2:	fa1fd0ef          	jal	80002972 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800049d6:	fdc42703          	lw	a4,-36(s0)
    800049da:	47bd                	li	a5,15
    800049dc:	02e7e963          	bltu	a5,a4,80004a0e <argfd+0x50>
    800049e0:	f13fc0ef          	jal	800018f2 <myproc>
    800049e4:	fdc42703          	lw	a4,-36(s0)
    800049e8:	01a70793          	addi	a5,a4,26
    800049ec:	078e                	slli	a5,a5,0x3
    800049ee:	953e                	add	a0,a0,a5
    800049f0:	611c                	ld	a5,0(a0)
    800049f2:	c385                	beqz	a5,80004a12 <argfd+0x54>
    return -1;
  if(pfd)
    800049f4:	00090463          	beqz	s2,800049fc <argfd+0x3e>
    *pfd = fd;
    800049f8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800049fc:	4501                	li	a0,0
  if(pf)
    800049fe:	c091                	beqz	s1,80004a02 <argfd+0x44>
    *pf = f;
    80004a00:	e09c                	sd	a5,0(s1)
}
    80004a02:	70a2                	ld	ra,40(sp)
    80004a04:	7402                	ld	s0,32(sp)
    80004a06:	64e2                	ld	s1,24(sp)
    80004a08:	6942                	ld	s2,16(sp)
    80004a0a:	6145                	addi	sp,sp,48
    80004a0c:	8082                	ret
    return -1;
    80004a0e:	557d                	li	a0,-1
    80004a10:	bfcd                	j	80004a02 <argfd+0x44>
    80004a12:	557d                	li	a0,-1
    80004a14:	b7fd                	j	80004a02 <argfd+0x44>

0000000080004a16 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004a16:	1101                	addi	sp,sp,-32
    80004a18:	ec06                	sd	ra,24(sp)
    80004a1a:	e822                	sd	s0,16(sp)
    80004a1c:	e426                	sd	s1,8(sp)
    80004a1e:	1000                	addi	s0,sp,32
    80004a20:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004a22:	ed1fc0ef          	jal	800018f2 <myproc>
    80004a26:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004a28:	0d050793          	addi	a5,a0,208
    80004a2c:	4501                	li	a0,0
    80004a2e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004a30:	6398                	ld	a4,0(a5)
    80004a32:	cb19                	beqz	a4,80004a48 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004a34:	2505                	addiw	a0,a0,1
    80004a36:	07a1                	addi	a5,a5,8
    80004a38:	fed51ce3          	bne	a0,a3,80004a30 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004a3c:	557d                	li	a0,-1
}
    80004a3e:	60e2                	ld	ra,24(sp)
    80004a40:	6442                	ld	s0,16(sp)
    80004a42:	64a2                	ld	s1,8(sp)
    80004a44:	6105                	addi	sp,sp,32
    80004a46:	8082                	ret
      p->ofile[fd] = f;
    80004a48:	01a50793          	addi	a5,a0,26
    80004a4c:	078e                	slli	a5,a5,0x3
    80004a4e:	963e                	add	a2,a2,a5
    80004a50:	e204                	sd	s1,0(a2)
      return fd;
    80004a52:	b7f5                	j	80004a3e <fdalloc+0x28>

0000000080004a54 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004a54:	715d                	addi	sp,sp,-80
    80004a56:	e486                	sd	ra,72(sp)
    80004a58:	e0a2                	sd	s0,64(sp)
    80004a5a:	fc26                	sd	s1,56(sp)
    80004a5c:	f84a                	sd	s2,48(sp)
    80004a5e:	f44e                	sd	s3,40(sp)
    80004a60:	ec56                	sd	s5,24(sp)
    80004a62:	e85a                	sd	s6,16(sp)
    80004a64:	0880                	addi	s0,sp,80
    80004a66:	8b2e                	mv	s6,a1
    80004a68:	89b2                	mv	s3,a2
    80004a6a:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004a6c:	fb040593          	addi	a1,s0,-80
    80004a70:	822ff0ef          	jal	80003a92 <nameiparent>
    80004a74:	84aa                	mv	s1,a0
    80004a76:	10050a63          	beqz	a0,80004b8a <create+0x136>
    return 0;

  ilock(dp);
    80004a7a:	925fe0ef          	jal	8000339e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004a7e:	4601                	li	a2,0
    80004a80:	fb040593          	addi	a1,s0,-80
    80004a84:	8526                	mv	a0,s1
    80004a86:	d8dfe0ef          	jal	80003812 <dirlookup>
    80004a8a:	8aaa                	mv	s5,a0
    80004a8c:	c129                	beqz	a0,80004ace <create+0x7a>
    iunlockput(dp);
    80004a8e:	8526                	mv	a0,s1
    80004a90:	b19fe0ef          	jal	800035a8 <iunlockput>
    ilock(ip);
    80004a94:	8556                	mv	a0,s5
    80004a96:	909fe0ef          	jal	8000339e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004a9a:	4789                	li	a5,2
    80004a9c:	02fb1463          	bne	s6,a5,80004ac4 <create+0x70>
    80004aa0:	044ad783          	lhu	a5,68(s5)
    80004aa4:	37f9                	addiw	a5,a5,-2
    80004aa6:	17c2                	slli	a5,a5,0x30
    80004aa8:	93c1                	srli	a5,a5,0x30
    80004aaa:	4705                	li	a4,1
    80004aac:	00f76c63          	bltu	a4,a5,80004ac4 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004ab0:	8556                	mv	a0,s5
    80004ab2:	60a6                	ld	ra,72(sp)
    80004ab4:	6406                	ld	s0,64(sp)
    80004ab6:	74e2                	ld	s1,56(sp)
    80004ab8:	7942                	ld	s2,48(sp)
    80004aba:	79a2                	ld	s3,40(sp)
    80004abc:	6ae2                	ld	s5,24(sp)
    80004abe:	6b42                	ld	s6,16(sp)
    80004ac0:	6161                	addi	sp,sp,80
    80004ac2:	8082                	ret
    iunlockput(ip);
    80004ac4:	8556                	mv	a0,s5
    80004ac6:	ae3fe0ef          	jal	800035a8 <iunlockput>
    return 0;
    80004aca:	4a81                	li	s5,0
    80004acc:	b7d5                	j	80004ab0 <create+0x5c>
    80004ace:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004ad0:	85da                	mv	a1,s6
    80004ad2:	4088                	lw	a0,0(s1)
    80004ad4:	f5afe0ef          	jal	8000322e <ialloc>
    80004ad8:	8a2a                	mv	s4,a0
    80004ada:	cd15                	beqz	a0,80004b16 <create+0xc2>
  ilock(ip);
    80004adc:	8c3fe0ef          	jal	8000339e <ilock>
  ip->major = major;
    80004ae0:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004ae4:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004ae8:	4905                	li	s2,1
    80004aea:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004aee:	8552                	mv	a0,s4
    80004af0:	ffafe0ef          	jal	800032ea <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004af4:	032b0763          	beq	s6,s2,80004b22 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004af8:	004a2603          	lw	a2,4(s4)
    80004afc:	fb040593          	addi	a1,s0,-80
    80004b00:	8526                	mv	a0,s1
    80004b02:	eddfe0ef          	jal	800039de <dirlink>
    80004b06:	06054563          	bltz	a0,80004b70 <create+0x11c>
  iunlockput(dp);
    80004b0a:	8526                	mv	a0,s1
    80004b0c:	a9dfe0ef          	jal	800035a8 <iunlockput>
  return ip;
    80004b10:	8ad2                	mv	s5,s4
    80004b12:	7a02                	ld	s4,32(sp)
    80004b14:	bf71                	j	80004ab0 <create+0x5c>
    iunlockput(dp);
    80004b16:	8526                	mv	a0,s1
    80004b18:	a91fe0ef          	jal	800035a8 <iunlockput>
    return 0;
    80004b1c:	8ad2                	mv	s5,s4
    80004b1e:	7a02                	ld	s4,32(sp)
    80004b20:	bf41                	j	80004ab0 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004b22:	004a2603          	lw	a2,4(s4)
    80004b26:	00003597          	auipc	a1,0x3
    80004b2a:	b7a58593          	addi	a1,a1,-1158 # 800076a0 <etext+0x6a0>
    80004b2e:	8552                	mv	a0,s4
    80004b30:	eaffe0ef          	jal	800039de <dirlink>
    80004b34:	02054e63          	bltz	a0,80004b70 <create+0x11c>
    80004b38:	40d0                	lw	a2,4(s1)
    80004b3a:	00003597          	auipc	a1,0x3
    80004b3e:	b6e58593          	addi	a1,a1,-1170 # 800076a8 <etext+0x6a8>
    80004b42:	8552                	mv	a0,s4
    80004b44:	e9bfe0ef          	jal	800039de <dirlink>
    80004b48:	02054463          	bltz	a0,80004b70 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004b4c:	004a2603          	lw	a2,4(s4)
    80004b50:	fb040593          	addi	a1,s0,-80
    80004b54:	8526                	mv	a0,s1
    80004b56:	e89fe0ef          	jal	800039de <dirlink>
    80004b5a:	00054b63          	bltz	a0,80004b70 <create+0x11c>
    dp->nlink++;  // for ".."
    80004b5e:	04a4d783          	lhu	a5,74(s1)
    80004b62:	2785                	addiw	a5,a5,1
    80004b64:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b68:	8526                	mv	a0,s1
    80004b6a:	f80fe0ef          	jal	800032ea <iupdate>
    80004b6e:	bf71                	j	80004b0a <create+0xb6>
  ip->nlink = 0;
    80004b70:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004b74:	8552                	mv	a0,s4
    80004b76:	f74fe0ef          	jal	800032ea <iupdate>
  iunlockput(ip);
    80004b7a:	8552                	mv	a0,s4
    80004b7c:	a2dfe0ef          	jal	800035a8 <iunlockput>
  iunlockput(dp);
    80004b80:	8526                	mv	a0,s1
    80004b82:	a27fe0ef          	jal	800035a8 <iunlockput>
  return 0;
    80004b86:	7a02                	ld	s4,32(sp)
    80004b88:	b725                	j	80004ab0 <create+0x5c>
    return 0;
    80004b8a:	8aaa                	mv	s5,a0
    80004b8c:	b715                	j	80004ab0 <create+0x5c>

0000000080004b8e <sys_dup>:
{
    80004b8e:	7179                	addi	sp,sp,-48
    80004b90:	f406                	sd	ra,40(sp)
    80004b92:	f022                	sd	s0,32(sp)
    80004b94:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004b96:	fd840613          	addi	a2,s0,-40
    80004b9a:	4581                	li	a1,0
    80004b9c:	4501                	li	a0,0
    80004b9e:	e21ff0ef          	jal	800049be <argfd>
    return -1;
    80004ba2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004ba4:	02054363          	bltz	a0,80004bca <sys_dup+0x3c>
    80004ba8:	ec26                	sd	s1,24(sp)
    80004baa:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004bac:	fd843903          	ld	s2,-40(s0)
    80004bb0:	854a                	mv	a0,s2
    80004bb2:	e65ff0ef          	jal	80004a16 <fdalloc>
    80004bb6:	84aa                	mv	s1,a0
    return -1;
    80004bb8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004bba:	00054d63          	bltz	a0,80004bd4 <sys_dup+0x46>
  filedup(f);
    80004bbe:	854a                	mv	a0,s2
    80004bc0:	c48ff0ef          	jal	80004008 <filedup>
  return fd;
    80004bc4:	87a6                	mv	a5,s1
    80004bc6:	64e2                	ld	s1,24(sp)
    80004bc8:	6942                	ld	s2,16(sp)
}
    80004bca:	853e                	mv	a0,a5
    80004bcc:	70a2                	ld	ra,40(sp)
    80004bce:	7402                	ld	s0,32(sp)
    80004bd0:	6145                	addi	sp,sp,48
    80004bd2:	8082                	ret
    80004bd4:	64e2                	ld	s1,24(sp)
    80004bd6:	6942                	ld	s2,16(sp)
    80004bd8:	bfcd                	j	80004bca <sys_dup+0x3c>

0000000080004bda <sys_read>:
{
    80004bda:	7179                	addi	sp,sp,-48
    80004bdc:	f406                	sd	ra,40(sp)
    80004bde:	f022                	sd	s0,32(sp)
    80004be0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004be2:	fd840593          	addi	a1,s0,-40
    80004be6:	4505                	li	a0,1
    80004be8:	da7fd0ef          	jal	8000298e <argaddr>
  argint(2, &n);
    80004bec:	fe440593          	addi	a1,s0,-28
    80004bf0:	4509                	li	a0,2
    80004bf2:	d81fd0ef          	jal	80002972 <argint>
  if(argfd(0, 0, &f) < 0)
    80004bf6:	fe840613          	addi	a2,s0,-24
    80004bfa:	4581                	li	a1,0
    80004bfc:	4501                	li	a0,0
    80004bfe:	dc1ff0ef          	jal	800049be <argfd>
    80004c02:	87aa                	mv	a5,a0
    return -1;
    80004c04:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c06:	0007ca63          	bltz	a5,80004c1a <sys_read+0x40>
  return fileread(f, p, n);
    80004c0a:	fe442603          	lw	a2,-28(s0)
    80004c0e:	fd843583          	ld	a1,-40(s0)
    80004c12:	fe843503          	ld	a0,-24(s0)
    80004c16:	d58ff0ef          	jal	8000416e <fileread>
}
    80004c1a:	70a2                	ld	ra,40(sp)
    80004c1c:	7402                	ld	s0,32(sp)
    80004c1e:	6145                	addi	sp,sp,48
    80004c20:	8082                	ret

0000000080004c22 <sys_write>:
{
    80004c22:	7179                	addi	sp,sp,-48
    80004c24:	f406                	sd	ra,40(sp)
    80004c26:	f022                	sd	s0,32(sp)
    80004c28:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004c2a:	fd840593          	addi	a1,s0,-40
    80004c2e:	4505                	li	a0,1
    80004c30:	d5ffd0ef          	jal	8000298e <argaddr>
  argint(2, &n);
    80004c34:	fe440593          	addi	a1,s0,-28
    80004c38:	4509                	li	a0,2
    80004c3a:	d39fd0ef          	jal	80002972 <argint>
  if(argfd(0, 0, &f) < 0)
    80004c3e:	fe840613          	addi	a2,s0,-24
    80004c42:	4581                	li	a1,0
    80004c44:	4501                	li	a0,0
    80004c46:	d79ff0ef          	jal	800049be <argfd>
    80004c4a:	87aa                	mv	a5,a0
    return -1;
    80004c4c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c4e:	0007ca63          	bltz	a5,80004c62 <sys_write+0x40>
  return filewrite(f, p, n);
    80004c52:	fe442603          	lw	a2,-28(s0)
    80004c56:	fd843583          	ld	a1,-40(s0)
    80004c5a:	fe843503          	ld	a0,-24(s0)
    80004c5e:	dceff0ef          	jal	8000422c <filewrite>
}
    80004c62:	70a2                	ld	ra,40(sp)
    80004c64:	7402                	ld	s0,32(sp)
    80004c66:	6145                	addi	sp,sp,48
    80004c68:	8082                	ret

0000000080004c6a <sys_close>:
{
    80004c6a:	1101                	addi	sp,sp,-32
    80004c6c:	ec06                	sd	ra,24(sp)
    80004c6e:	e822                	sd	s0,16(sp)
    80004c70:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004c72:	fe040613          	addi	a2,s0,-32
    80004c76:	fec40593          	addi	a1,s0,-20
    80004c7a:	4501                	li	a0,0
    80004c7c:	d43ff0ef          	jal	800049be <argfd>
    return -1;
    80004c80:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004c82:	02054063          	bltz	a0,80004ca2 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004c86:	c6dfc0ef          	jal	800018f2 <myproc>
    80004c8a:	fec42783          	lw	a5,-20(s0)
    80004c8e:	07e9                	addi	a5,a5,26
    80004c90:	078e                	slli	a5,a5,0x3
    80004c92:	953e                	add	a0,a0,a5
    80004c94:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004c98:	fe043503          	ld	a0,-32(s0)
    80004c9c:	bb2ff0ef          	jal	8000404e <fileclose>
  return 0;
    80004ca0:	4781                	li	a5,0
}
    80004ca2:	853e                	mv	a0,a5
    80004ca4:	60e2                	ld	ra,24(sp)
    80004ca6:	6442                	ld	s0,16(sp)
    80004ca8:	6105                	addi	sp,sp,32
    80004caa:	8082                	ret

0000000080004cac <sys_fstat>:
{
    80004cac:	1101                	addi	sp,sp,-32
    80004cae:	ec06                	sd	ra,24(sp)
    80004cb0:	e822                	sd	s0,16(sp)
    80004cb2:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004cb4:	fe040593          	addi	a1,s0,-32
    80004cb8:	4505                	li	a0,1
    80004cba:	cd5fd0ef          	jal	8000298e <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004cbe:	fe840613          	addi	a2,s0,-24
    80004cc2:	4581                	li	a1,0
    80004cc4:	4501                	li	a0,0
    80004cc6:	cf9ff0ef          	jal	800049be <argfd>
    80004cca:	87aa                	mv	a5,a0
    return -1;
    80004ccc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004cce:	0007c863          	bltz	a5,80004cde <sys_fstat+0x32>
  return filestat(f, st);
    80004cd2:	fe043583          	ld	a1,-32(s0)
    80004cd6:	fe843503          	ld	a0,-24(s0)
    80004cda:	c36ff0ef          	jal	80004110 <filestat>
}
    80004cde:	60e2                	ld	ra,24(sp)
    80004ce0:	6442                	ld	s0,16(sp)
    80004ce2:	6105                	addi	sp,sp,32
    80004ce4:	8082                	ret

0000000080004ce6 <sys_link>:
{
    80004ce6:	7169                	addi	sp,sp,-304
    80004ce8:	f606                	sd	ra,296(sp)
    80004cea:	f222                	sd	s0,288(sp)
    80004cec:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cee:	08000613          	li	a2,128
    80004cf2:	ed040593          	addi	a1,s0,-304
    80004cf6:	4501                	li	a0,0
    80004cf8:	cb3fd0ef          	jal	800029aa <argstr>
    return -1;
    80004cfc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cfe:	0c054e63          	bltz	a0,80004dda <sys_link+0xf4>
    80004d02:	08000613          	li	a2,128
    80004d06:	f5040593          	addi	a1,s0,-176
    80004d0a:	4505                	li	a0,1
    80004d0c:	c9ffd0ef          	jal	800029aa <argstr>
    return -1;
    80004d10:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004d12:	0c054463          	bltz	a0,80004dda <sys_link+0xf4>
    80004d16:	ee26                	sd	s1,280(sp)
  begin_op();
    80004d18:	f1dfe0ef          	jal	80003c34 <begin_op>
  if((ip = namei(old)) == 0){
    80004d1c:	ed040513          	addi	a0,s0,-304
    80004d20:	d59fe0ef          	jal	80003a78 <namei>
    80004d24:	84aa                	mv	s1,a0
    80004d26:	c53d                	beqz	a0,80004d94 <sys_link+0xae>
  ilock(ip);
    80004d28:	e76fe0ef          	jal	8000339e <ilock>
  if(ip->type == T_DIR){
    80004d2c:	04449703          	lh	a4,68(s1)
    80004d30:	4785                	li	a5,1
    80004d32:	06f70663          	beq	a4,a5,80004d9e <sys_link+0xb8>
    80004d36:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004d38:	04a4d783          	lhu	a5,74(s1)
    80004d3c:	2785                	addiw	a5,a5,1
    80004d3e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004d42:	8526                	mv	a0,s1
    80004d44:	da6fe0ef          	jal	800032ea <iupdate>
  iunlock(ip);
    80004d48:	8526                	mv	a0,s1
    80004d4a:	f02fe0ef          	jal	8000344c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004d4e:	fd040593          	addi	a1,s0,-48
    80004d52:	f5040513          	addi	a0,s0,-176
    80004d56:	d3dfe0ef          	jal	80003a92 <nameiparent>
    80004d5a:	892a                	mv	s2,a0
    80004d5c:	cd21                	beqz	a0,80004db4 <sys_link+0xce>
  ilock(dp);
    80004d5e:	e40fe0ef          	jal	8000339e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004d62:	00092703          	lw	a4,0(s2)
    80004d66:	409c                	lw	a5,0(s1)
    80004d68:	04f71363          	bne	a4,a5,80004dae <sys_link+0xc8>
    80004d6c:	40d0                	lw	a2,4(s1)
    80004d6e:	fd040593          	addi	a1,s0,-48
    80004d72:	854a                	mv	a0,s2
    80004d74:	c6bfe0ef          	jal	800039de <dirlink>
    80004d78:	02054b63          	bltz	a0,80004dae <sys_link+0xc8>
  iunlockput(dp);
    80004d7c:	854a                	mv	a0,s2
    80004d7e:	82bfe0ef          	jal	800035a8 <iunlockput>
  iput(ip);
    80004d82:	8526                	mv	a0,s1
    80004d84:	f9cfe0ef          	jal	80003520 <iput>
  end_op();
    80004d88:	f17fe0ef          	jal	80003c9e <end_op>
  return 0;
    80004d8c:	4781                	li	a5,0
    80004d8e:	64f2                	ld	s1,280(sp)
    80004d90:	6952                	ld	s2,272(sp)
    80004d92:	a0a1                	j	80004dda <sys_link+0xf4>
    end_op();
    80004d94:	f0bfe0ef          	jal	80003c9e <end_op>
    return -1;
    80004d98:	57fd                	li	a5,-1
    80004d9a:	64f2                	ld	s1,280(sp)
    80004d9c:	a83d                	j	80004dda <sys_link+0xf4>
    iunlockput(ip);
    80004d9e:	8526                	mv	a0,s1
    80004da0:	809fe0ef          	jal	800035a8 <iunlockput>
    end_op();
    80004da4:	efbfe0ef          	jal	80003c9e <end_op>
    return -1;
    80004da8:	57fd                	li	a5,-1
    80004daa:	64f2                	ld	s1,280(sp)
    80004dac:	a03d                	j	80004dda <sys_link+0xf4>
    iunlockput(dp);
    80004dae:	854a                	mv	a0,s2
    80004db0:	ff8fe0ef          	jal	800035a8 <iunlockput>
  ilock(ip);
    80004db4:	8526                	mv	a0,s1
    80004db6:	de8fe0ef          	jal	8000339e <ilock>
  ip->nlink--;
    80004dba:	04a4d783          	lhu	a5,74(s1)
    80004dbe:	37fd                	addiw	a5,a5,-1
    80004dc0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004dc4:	8526                	mv	a0,s1
    80004dc6:	d24fe0ef          	jal	800032ea <iupdate>
  iunlockput(ip);
    80004dca:	8526                	mv	a0,s1
    80004dcc:	fdcfe0ef          	jal	800035a8 <iunlockput>
  end_op();
    80004dd0:	ecffe0ef          	jal	80003c9e <end_op>
  return -1;
    80004dd4:	57fd                	li	a5,-1
    80004dd6:	64f2                	ld	s1,280(sp)
    80004dd8:	6952                	ld	s2,272(sp)
}
    80004dda:	853e                	mv	a0,a5
    80004ddc:	70b2                	ld	ra,296(sp)
    80004dde:	7412                	ld	s0,288(sp)
    80004de0:	6155                	addi	sp,sp,304
    80004de2:	8082                	ret

0000000080004de4 <sys_unlink>:
{
    80004de4:	7151                	addi	sp,sp,-240
    80004de6:	f586                	sd	ra,232(sp)
    80004de8:	f1a2                	sd	s0,224(sp)
    80004dea:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004dec:	08000613          	li	a2,128
    80004df0:	f3040593          	addi	a1,s0,-208
    80004df4:	4501                	li	a0,0
    80004df6:	bb5fd0ef          	jal	800029aa <argstr>
    80004dfa:	16054063          	bltz	a0,80004f5a <sys_unlink+0x176>
    80004dfe:	eda6                	sd	s1,216(sp)
  begin_op();
    80004e00:	e35fe0ef          	jal	80003c34 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004e04:	fb040593          	addi	a1,s0,-80
    80004e08:	f3040513          	addi	a0,s0,-208
    80004e0c:	c87fe0ef          	jal	80003a92 <nameiparent>
    80004e10:	84aa                	mv	s1,a0
    80004e12:	c945                	beqz	a0,80004ec2 <sys_unlink+0xde>
  ilock(dp);
    80004e14:	d8afe0ef          	jal	8000339e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004e18:	00003597          	auipc	a1,0x3
    80004e1c:	88858593          	addi	a1,a1,-1912 # 800076a0 <etext+0x6a0>
    80004e20:	fb040513          	addi	a0,s0,-80
    80004e24:	9d9fe0ef          	jal	800037fc <namecmp>
    80004e28:	10050e63          	beqz	a0,80004f44 <sys_unlink+0x160>
    80004e2c:	00003597          	auipc	a1,0x3
    80004e30:	87c58593          	addi	a1,a1,-1924 # 800076a8 <etext+0x6a8>
    80004e34:	fb040513          	addi	a0,s0,-80
    80004e38:	9c5fe0ef          	jal	800037fc <namecmp>
    80004e3c:	10050463          	beqz	a0,80004f44 <sys_unlink+0x160>
    80004e40:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004e42:	f2c40613          	addi	a2,s0,-212
    80004e46:	fb040593          	addi	a1,s0,-80
    80004e4a:	8526                	mv	a0,s1
    80004e4c:	9c7fe0ef          	jal	80003812 <dirlookup>
    80004e50:	892a                	mv	s2,a0
    80004e52:	0e050863          	beqz	a0,80004f42 <sys_unlink+0x15e>
  ilock(ip);
    80004e56:	d48fe0ef          	jal	8000339e <ilock>
  if(ip->nlink < 1)
    80004e5a:	04a91783          	lh	a5,74(s2)
    80004e5e:	06f05763          	blez	a5,80004ecc <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004e62:	04491703          	lh	a4,68(s2)
    80004e66:	4785                	li	a5,1
    80004e68:	06f70963          	beq	a4,a5,80004eda <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004e6c:	4641                	li	a2,16
    80004e6e:	4581                	li	a1,0
    80004e70:	fc040513          	addi	a0,s0,-64
    80004e74:	e55fb0ef          	jal	80000cc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e78:	4741                	li	a4,16
    80004e7a:	f2c42683          	lw	a3,-212(s0)
    80004e7e:	fc040613          	addi	a2,s0,-64
    80004e82:	4581                	li	a1,0
    80004e84:	8526                	mv	a0,s1
    80004e86:	869fe0ef          	jal	800036ee <writei>
    80004e8a:	47c1                	li	a5,16
    80004e8c:	08f51b63          	bne	a0,a5,80004f22 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004e90:	04491703          	lh	a4,68(s2)
    80004e94:	4785                	li	a5,1
    80004e96:	08f70d63          	beq	a4,a5,80004f30 <sys_unlink+0x14c>
  iunlockput(dp);
    80004e9a:	8526                	mv	a0,s1
    80004e9c:	f0cfe0ef          	jal	800035a8 <iunlockput>
  ip->nlink--;
    80004ea0:	04a95783          	lhu	a5,74(s2)
    80004ea4:	37fd                	addiw	a5,a5,-1
    80004ea6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004eaa:	854a                	mv	a0,s2
    80004eac:	c3efe0ef          	jal	800032ea <iupdate>
  iunlockput(ip);
    80004eb0:	854a                	mv	a0,s2
    80004eb2:	ef6fe0ef          	jal	800035a8 <iunlockput>
  end_op();
    80004eb6:	de9fe0ef          	jal	80003c9e <end_op>
  return 0;
    80004eba:	4501                	li	a0,0
    80004ebc:	64ee                	ld	s1,216(sp)
    80004ebe:	694e                	ld	s2,208(sp)
    80004ec0:	a849                	j	80004f52 <sys_unlink+0x16e>
    end_op();
    80004ec2:	dddfe0ef          	jal	80003c9e <end_op>
    return -1;
    80004ec6:	557d                	li	a0,-1
    80004ec8:	64ee                	ld	s1,216(sp)
    80004eca:	a061                	j	80004f52 <sys_unlink+0x16e>
    80004ecc:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004ece:	00002517          	auipc	a0,0x2
    80004ed2:	7e250513          	addi	a0,a0,2018 # 800076b0 <etext+0x6b0>
    80004ed6:	8bffb0ef          	jal	80000794 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004eda:	04c92703          	lw	a4,76(s2)
    80004ede:	02000793          	li	a5,32
    80004ee2:	f8e7f5e3          	bgeu	a5,a4,80004e6c <sys_unlink+0x88>
    80004ee6:	e5ce                	sd	s3,200(sp)
    80004ee8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004eec:	4741                	li	a4,16
    80004eee:	86ce                	mv	a3,s3
    80004ef0:	f1840613          	addi	a2,s0,-232
    80004ef4:	4581                	li	a1,0
    80004ef6:	854a                	mv	a0,s2
    80004ef8:	efafe0ef          	jal	800035f2 <readi>
    80004efc:	47c1                	li	a5,16
    80004efe:	00f51c63          	bne	a0,a5,80004f16 <sys_unlink+0x132>
    if(de.inum != 0)
    80004f02:	f1845783          	lhu	a5,-232(s0)
    80004f06:	efa1                	bnez	a5,80004f5e <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004f08:	29c1                	addiw	s3,s3,16
    80004f0a:	04c92783          	lw	a5,76(s2)
    80004f0e:	fcf9efe3          	bltu	s3,a5,80004eec <sys_unlink+0x108>
    80004f12:	69ae                	ld	s3,200(sp)
    80004f14:	bfa1                	j	80004e6c <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004f16:	00002517          	auipc	a0,0x2
    80004f1a:	7b250513          	addi	a0,a0,1970 # 800076c8 <etext+0x6c8>
    80004f1e:	877fb0ef          	jal	80000794 <panic>
    80004f22:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004f24:	00002517          	auipc	a0,0x2
    80004f28:	7bc50513          	addi	a0,a0,1980 # 800076e0 <etext+0x6e0>
    80004f2c:	869fb0ef          	jal	80000794 <panic>
    dp->nlink--;
    80004f30:	04a4d783          	lhu	a5,74(s1)
    80004f34:	37fd                	addiw	a5,a5,-1
    80004f36:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004f3a:	8526                	mv	a0,s1
    80004f3c:	baefe0ef          	jal	800032ea <iupdate>
    80004f40:	bfa9                	j	80004e9a <sys_unlink+0xb6>
    80004f42:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004f44:	8526                	mv	a0,s1
    80004f46:	e62fe0ef          	jal	800035a8 <iunlockput>
  end_op();
    80004f4a:	d55fe0ef          	jal	80003c9e <end_op>
  return -1;
    80004f4e:	557d                	li	a0,-1
    80004f50:	64ee                	ld	s1,216(sp)
}
    80004f52:	70ae                	ld	ra,232(sp)
    80004f54:	740e                	ld	s0,224(sp)
    80004f56:	616d                	addi	sp,sp,240
    80004f58:	8082                	ret
    return -1;
    80004f5a:	557d                	li	a0,-1
    80004f5c:	bfdd                	j	80004f52 <sys_unlink+0x16e>
    iunlockput(ip);
    80004f5e:	854a                	mv	a0,s2
    80004f60:	e48fe0ef          	jal	800035a8 <iunlockput>
    goto bad;
    80004f64:	694e                	ld	s2,208(sp)
    80004f66:	69ae                	ld	s3,200(sp)
    80004f68:	bff1                	j	80004f44 <sys_unlink+0x160>

0000000080004f6a <sys_open>:

uint64
sys_open(void)
{
    80004f6a:	7131                	addi	sp,sp,-192
    80004f6c:	fd06                	sd	ra,184(sp)
    80004f6e:	f922                	sd	s0,176(sp)
    80004f70:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004f72:	f4c40593          	addi	a1,s0,-180
    80004f76:	4505                	li	a0,1
    80004f78:	9fbfd0ef          	jal	80002972 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004f7c:	08000613          	li	a2,128
    80004f80:	f5040593          	addi	a1,s0,-176
    80004f84:	4501                	li	a0,0
    80004f86:	a25fd0ef          	jal	800029aa <argstr>
    80004f8a:	87aa                	mv	a5,a0
    return -1;
    80004f8c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004f8e:	0a07c263          	bltz	a5,80005032 <sys_open+0xc8>
    80004f92:	f526                	sd	s1,168(sp)

  begin_op();
    80004f94:	ca1fe0ef          	jal	80003c34 <begin_op>

  if(omode & O_CREATE){
    80004f98:	f4c42783          	lw	a5,-180(s0)
    80004f9c:	2007f793          	andi	a5,a5,512
    80004fa0:	c3d5                	beqz	a5,80005044 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004fa2:	4681                	li	a3,0
    80004fa4:	4601                	li	a2,0
    80004fa6:	4589                	li	a1,2
    80004fa8:	f5040513          	addi	a0,s0,-176
    80004fac:	aa9ff0ef          	jal	80004a54 <create>
    80004fb0:	84aa                	mv	s1,a0
    if(ip == 0){
    80004fb2:	c541                	beqz	a0,8000503a <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004fb4:	04449703          	lh	a4,68(s1)
    80004fb8:	478d                	li	a5,3
    80004fba:	00f71763          	bne	a4,a5,80004fc8 <sys_open+0x5e>
    80004fbe:	0464d703          	lhu	a4,70(s1)
    80004fc2:	47a5                	li	a5,9
    80004fc4:	0ae7ed63          	bltu	a5,a4,8000507e <sys_open+0x114>
    80004fc8:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004fca:	fe1fe0ef          	jal	80003faa <filealloc>
    80004fce:	892a                	mv	s2,a0
    80004fd0:	c179                	beqz	a0,80005096 <sys_open+0x12c>
    80004fd2:	ed4e                	sd	s3,152(sp)
    80004fd4:	a43ff0ef          	jal	80004a16 <fdalloc>
    80004fd8:	89aa                	mv	s3,a0
    80004fda:	0a054a63          	bltz	a0,8000508e <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004fde:	04449703          	lh	a4,68(s1)
    80004fe2:	478d                	li	a5,3
    80004fe4:	0cf70263          	beq	a4,a5,800050a8 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004fe8:	4789                	li	a5,2
    80004fea:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004fee:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004ff2:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004ff6:	f4c42783          	lw	a5,-180(s0)
    80004ffa:	0017c713          	xori	a4,a5,1
    80004ffe:	8b05                	andi	a4,a4,1
    80005000:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005004:	0037f713          	andi	a4,a5,3
    80005008:	00e03733          	snez	a4,a4
    8000500c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005010:	4007f793          	andi	a5,a5,1024
    80005014:	c791                	beqz	a5,80005020 <sys_open+0xb6>
    80005016:	04449703          	lh	a4,68(s1)
    8000501a:	4789                	li	a5,2
    8000501c:	08f70d63          	beq	a4,a5,800050b6 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80005020:	8526                	mv	a0,s1
    80005022:	c2afe0ef          	jal	8000344c <iunlock>
  end_op();
    80005026:	c79fe0ef          	jal	80003c9e <end_op>

  return fd;
    8000502a:	854e                	mv	a0,s3
    8000502c:	74aa                	ld	s1,168(sp)
    8000502e:	790a                	ld	s2,160(sp)
    80005030:	69ea                	ld	s3,152(sp)
}
    80005032:	70ea                	ld	ra,184(sp)
    80005034:	744a                	ld	s0,176(sp)
    80005036:	6129                	addi	sp,sp,192
    80005038:	8082                	ret
      end_op();
    8000503a:	c65fe0ef          	jal	80003c9e <end_op>
      return -1;
    8000503e:	557d                	li	a0,-1
    80005040:	74aa                	ld	s1,168(sp)
    80005042:	bfc5                	j	80005032 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80005044:	f5040513          	addi	a0,s0,-176
    80005048:	a31fe0ef          	jal	80003a78 <namei>
    8000504c:	84aa                	mv	s1,a0
    8000504e:	c11d                	beqz	a0,80005074 <sys_open+0x10a>
    ilock(ip);
    80005050:	b4efe0ef          	jal	8000339e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005054:	04449703          	lh	a4,68(s1)
    80005058:	4785                	li	a5,1
    8000505a:	f4f71de3          	bne	a4,a5,80004fb4 <sys_open+0x4a>
    8000505e:	f4c42783          	lw	a5,-180(s0)
    80005062:	d3bd                	beqz	a5,80004fc8 <sys_open+0x5e>
      iunlockput(ip);
    80005064:	8526                	mv	a0,s1
    80005066:	d42fe0ef          	jal	800035a8 <iunlockput>
      end_op();
    8000506a:	c35fe0ef          	jal	80003c9e <end_op>
      return -1;
    8000506e:	557d                	li	a0,-1
    80005070:	74aa                	ld	s1,168(sp)
    80005072:	b7c1                	j	80005032 <sys_open+0xc8>
      end_op();
    80005074:	c2bfe0ef          	jal	80003c9e <end_op>
      return -1;
    80005078:	557d                	li	a0,-1
    8000507a:	74aa                	ld	s1,168(sp)
    8000507c:	bf5d                	j	80005032 <sys_open+0xc8>
    iunlockput(ip);
    8000507e:	8526                	mv	a0,s1
    80005080:	d28fe0ef          	jal	800035a8 <iunlockput>
    end_op();
    80005084:	c1bfe0ef          	jal	80003c9e <end_op>
    return -1;
    80005088:	557d                	li	a0,-1
    8000508a:	74aa                	ld	s1,168(sp)
    8000508c:	b75d                	j	80005032 <sys_open+0xc8>
      fileclose(f);
    8000508e:	854a                	mv	a0,s2
    80005090:	fbffe0ef          	jal	8000404e <fileclose>
    80005094:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005096:	8526                	mv	a0,s1
    80005098:	d10fe0ef          	jal	800035a8 <iunlockput>
    end_op();
    8000509c:	c03fe0ef          	jal	80003c9e <end_op>
    return -1;
    800050a0:	557d                	li	a0,-1
    800050a2:	74aa                	ld	s1,168(sp)
    800050a4:	790a                	ld	s2,160(sp)
    800050a6:	b771                	j	80005032 <sys_open+0xc8>
    f->type = FD_DEVICE;
    800050a8:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800050ac:	04649783          	lh	a5,70(s1)
    800050b0:	02f91223          	sh	a5,36(s2)
    800050b4:	bf3d                	j	80004ff2 <sys_open+0x88>
    itrunc(ip);
    800050b6:	8526                	mv	a0,s1
    800050b8:	bd4fe0ef          	jal	8000348c <itrunc>
    800050bc:	b795                	j	80005020 <sys_open+0xb6>

00000000800050be <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800050be:	7175                	addi	sp,sp,-144
    800050c0:	e506                	sd	ra,136(sp)
    800050c2:	e122                	sd	s0,128(sp)
    800050c4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800050c6:	b6ffe0ef          	jal	80003c34 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800050ca:	08000613          	li	a2,128
    800050ce:	f7040593          	addi	a1,s0,-144
    800050d2:	4501                	li	a0,0
    800050d4:	8d7fd0ef          	jal	800029aa <argstr>
    800050d8:	02054363          	bltz	a0,800050fe <sys_mkdir+0x40>
    800050dc:	4681                	li	a3,0
    800050de:	4601                	li	a2,0
    800050e0:	4585                	li	a1,1
    800050e2:	f7040513          	addi	a0,s0,-144
    800050e6:	96fff0ef          	jal	80004a54 <create>
    800050ea:	c911                	beqz	a0,800050fe <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050ec:	cbcfe0ef          	jal	800035a8 <iunlockput>
  end_op();
    800050f0:	baffe0ef          	jal	80003c9e <end_op>
  return 0;
    800050f4:	4501                	li	a0,0
}
    800050f6:	60aa                	ld	ra,136(sp)
    800050f8:	640a                	ld	s0,128(sp)
    800050fa:	6149                	addi	sp,sp,144
    800050fc:	8082                	ret
    end_op();
    800050fe:	ba1fe0ef          	jal	80003c9e <end_op>
    return -1;
    80005102:	557d                	li	a0,-1
    80005104:	bfcd                	j	800050f6 <sys_mkdir+0x38>

0000000080005106 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005106:	7135                	addi	sp,sp,-160
    80005108:	ed06                	sd	ra,152(sp)
    8000510a:	e922                	sd	s0,144(sp)
    8000510c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000510e:	b27fe0ef          	jal	80003c34 <begin_op>
  argint(1, &major);
    80005112:	f6c40593          	addi	a1,s0,-148
    80005116:	4505                	li	a0,1
    80005118:	85bfd0ef          	jal	80002972 <argint>
  argint(2, &minor);
    8000511c:	f6840593          	addi	a1,s0,-152
    80005120:	4509                	li	a0,2
    80005122:	851fd0ef          	jal	80002972 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005126:	08000613          	li	a2,128
    8000512a:	f7040593          	addi	a1,s0,-144
    8000512e:	4501                	li	a0,0
    80005130:	87bfd0ef          	jal	800029aa <argstr>
    80005134:	02054563          	bltz	a0,8000515e <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005138:	f6841683          	lh	a3,-152(s0)
    8000513c:	f6c41603          	lh	a2,-148(s0)
    80005140:	458d                	li	a1,3
    80005142:	f7040513          	addi	a0,s0,-144
    80005146:	90fff0ef          	jal	80004a54 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000514a:	c911                	beqz	a0,8000515e <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000514c:	c5cfe0ef          	jal	800035a8 <iunlockput>
  end_op();
    80005150:	b4ffe0ef          	jal	80003c9e <end_op>
  return 0;
    80005154:	4501                	li	a0,0
}
    80005156:	60ea                	ld	ra,152(sp)
    80005158:	644a                	ld	s0,144(sp)
    8000515a:	610d                	addi	sp,sp,160
    8000515c:	8082                	ret
    end_op();
    8000515e:	b41fe0ef          	jal	80003c9e <end_op>
    return -1;
    80005162:	557d                	li	a0,-1
    80005164:	bfcd                	j	80005156 <sys_mknod+0x50>

0000000080005166 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005166:	7135                	addi	sp,sp,-160
    80005168:	ed06                	sd	ra,152(sp)
    8000516a:	e922                	sd	s0,144(sp)
    8000516c:	e14a                	sd	s2,128(sp)
    8000516e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005170:	f82fc0ef          	jal	800018f2 <myproc>
    80005174:	892a                	mv	s2,a0
  
  begin_op();
    80005176:	abffe0ef          	jal	80003c34 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000517a:	08000613          	li	a2,128
    8000517e:	f6040593          	addi	a1,s0,-160
    80005182:	4501                	li	a0,0
    80005184:	827fd0ef          	jal	800029aa <argstr>
    80005188:	04054363          	bltz	a0,800051ce <sys_chdir+0x68>
    8000518c:	e526                	sd	s1,136(sp)
    8000518e:	f6040513          	addi	a0,s0,-160
    80005192:	8e7fe0ef          	jal	80003a78 <namei>
    80005196:	84aa                	mv	s1,a0
    80005198:	c915                	beqz	a0,800051cc <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000519a:	a04fe0ef          	jal	8000339e <ilock>
  if(ip->type != T_DIR){
    8000519e:	04449703          	lh	a4,68(s1)
    800051a2:	4785                	li	a5,1
    800051a4:	02f71963          	bne	a4,a5,800051d6 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800051a8:	8526                	mv	a0,s1
    800051aa:	aa2fe0ef          	jal	8000344c <iunlock>
  iput(p->cwd);
    800051ae:	15093503          	ld	a0,336(s2)
    800051b2:	b6efe0ef          	jal	80003520 <iput>
  end_op();
    800051b6:	ae9fe0ef          	jal	80003c9e <end_op>
  p->cwd = ip;
    800051ba:	14993823          	sd	s1,336(s2)
  return 0;
    800051be:	4501                	li	a0,0
    800051c0:	64aa                	ld	s1,136(sp)
}
    800051c2:	60ea                	ld	ra,152(sp)
    800051c4:	644a                	ld	s0,144(sp)
    800051c6:	690a                	ld	s2,128(sp)
    800051c8:	610d                	addi	sp,sp,160
    800051ca:	8082                	ret
    800051cc:	64aa                	ld	s1,136(sp)
    end_op();
    800051ce:	ad1fe0ef          	jal	80003c9e <end_op>
    return -1;
    800051d2:	557d                	li	a0,-1
    800051d4:	b7fd                	j	800051c2 <sys_chdir+0x5c>
    iunlockput(ip);
    800051d6:	8526                	mv	a0,s1
    800051d8:	bd0fe0ef          	jal	800035a8 <iunlockput>
    end_op();
    800051dc:	ac3fe0ef          	jal	80003c9e <end_op>
    return -1;
    800051e0:	557d                	li	a0,-1
    800051e2:	64aa                	ld	s1,136(sp)
    800051e4:	bff9                	j	800051c2 <sys_chdir+0x5c>

00000000800051e6 <sys_exec>:

uint64
sys_exec(void)
{
    800051e6:	7121                	addi	sp,sp,-448
    800051e8:	ff06                	sd	ra,440(sp)
    800051ea:	fb22                	sd	s0,432(sp)
    800051ec:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800051ee:	e4840593          	addi	a1,s0,-440
    800051f2:	4505                	li	a0,1
    800051f4:	f9afd0ef          	jal	8000298e <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800051f8:	08000613          	li	a2,128
    800051fc:	f5040593          	addi	a1,s0,-176
    80005200:	4501                	li	a0,0
    80005202:	fa8fd0ef          	jal	800029aa <argstr>
    80005206:	87aa                	mv	a5,a0
    return -1;
    80005208:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000520a:	0c07c463          	bltz	a5,800052d2 <sys_exec+0xec>
    8000520e:	f726                	sd	s1,424(sp)
    80005210:	f34a                	sd	s2,416(sp)
    80005212:	ef4e                	sd	s3,408(sp)
    80005214:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005216:	10000613          	li	a2,256
    8000521a:	4581                	li	a1,0
    8000521c:	e5040513          	addi	a0,s0,-432
    80005220:	aa9fb0ef          	jal	80000cc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005224:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005228:	89a6                	mv	s3,s1
    8000522a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000522c:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005230:	00391513          	slli	a0,s2,0x3
    80005234:	e4040593          	addi	a1,s0,-448
    80005238:	e4843783          	ld	a5,-440(s0)
    8000523c:	953e                	add	a0,a0,a5
    8000523e:	eaafd0ef          	jal	800028e8 <fetchaddr>
    80005242:	02054663          	bltz	a0,8000526e <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80005246:	e4043783          	ld	a5,-448(s0)
    8000524a:	c3a9                	beqz	a5,8000528c <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000524c:	8d9fb0ef          	jal	80000b24 <kalloc>
    80005250:	85aa                	mv	a1,a0
    80005252:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005256:	cd01                	beqz	a0,8000526e <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005258:	6605                	lui	a2,0x1
    8000525a:	e4043503          	ld	a0,-448(s0)
    8000525e:	ed4fd0ef          	jal	80002932 <fetchstr>
    80005262:	00054663          	bltz	a0,8000526e <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80005266:	0905                	addi	s2,s2,1
    80005268:	09a1                	addi	s3,s3,8
    8000526a:	fd4913e3          	bne	s2,s4,80005230 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000526e:	f5040913          	addi	s2,s0,-176
    80005272:	6088                	ld	a0,0(s1)
    80005274:	c931                	beqz	a0,800052c8 <sys_exec+0xe2>
    kfree(argv[i]);
    80005276:	fccfb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000527a:	04a1                	addi	s1,s1,8
    8000527c:	ff249be3          	bne	s1,s2,80005272 <sys_exec+0x8c>
  return -1;
    80005280:	557d                	li	a0,-1
    80005282:	74ba                	ld	s1,424(sp)
    80005284:	791a                	ld	s2,416(sp)
    80005286:	69fa                	ld	s3,408(sp)
    80005288:	6a5a                	ld	s4,400(sp)
    8000528a:	a0a1                	j	800052d2 <sys_exec+0xec>
      argv[i] = 0;
    8000528c:	0009079b          	sext.w	a5,s2
    80005290:	078e                	slli	a5,a5,0x3
    80005292:	fd078793          	addi	a5,a5,-48
    80005296:	97a2                	add	a5,a5,s0
    80005298:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000529c:	e5040593          	addi	a1,s0,-432
    800052a0:	f5040513          	addi	a0,s0,-176
    800052a4:	ba8ff0ef          	jal	8000464c <exec>
    800052a8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052aa:	f5040993          	addi	s3,s0,-176
    800052ae:	6088                	ld	a0,0(s1)
    800052b0:	c511                	beqz	a0,800052bc <sys_exec+0xd6>
    kfree(argv[i]);
    800052b2:	f90fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052b6:	04a1                	addi	s1,s1,8
    800052b8:	ff349be3          	bne	s1,s3,800052ae <sys_exec+0xc8>
  return ret;
    800052bc:	854a                	mv	a0,s2
    800052be:	74ba                	ld	s1,424(sp)
    800052c0:	791a                	ld	s2,416(sp)
    800052c2:	69fa                	ld	s3,408(sp)
    800052c4:	6a5a                	ld	s4,400(sp)
    800052c6:	a031                	j	800052d2 <sys_exec+0xec>
  return -1;
    800052c8:	557d                	li	a0,-1
    800052ca:	74ba                	ld	s1,424(sp)
    800052cc:	791a                	ld	s2,416(sp)
    800052ce:	69fa                	ld	s3,408(sp)
    800052d0:	6a5a                	ld	s4,400(sp)
}
    800052d2:	70fa                	ld	ra,440(sp)
    800052d4:	745a                	ld	s0,432(sp)
    800052d6:	6139                	addi	sp,sp,448
    800052d8:	8082                	ret

00000000800052da <sys_pipe>:

uint64
sys_pipe(void)
{
    800052da:	7139                	addi	sp,sp,-64
    800052dc:	fc06                	sd	ra,56(sp)
    800052de:	f822                	sd	s0,48(sp)
    800052e0:	f426                	sd	s1,40(sp)
    800052e2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800052e4:	e0efc0ef          	jal	800018f2 <myproc>
    800052e8:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800052ea:	fd840593          	addi	a1,s0,-40
    800052ee:	4501                	li	a0,0
    800052f0:	e9efd0ef          	jal	8000298e <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800052f4:	fc840593          	addi	a1,s0,-56
    800052f8:	fd040513          	addi	a0,s0,-48
    800052fc:	85cff0ef          	jal	80004358 <pipealloc>
    return -1;
    80005300:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005302:	0a054463          	bltz	a0,800053aa <sys_pipe+0xd0>
  fd0 = -1;
    80005306:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000530a:	fd043503          	ld	a0,-48(s0)
    8000530e:	f08ff0ef          	jal	80004a16 <fdalloc>
    80005312:	fca42223          	sw	a0,-60(s0)
    80005316:	08054163          	bltz	a0,80005398 <sys_pipe+0xbe>
    8000531a:	fc843503          	ld	a0,-56(s0)
    8000531e:	ef8ff0ef          	jal	80004a16 <fdalloc>
    80005322:	fca42023          	sw	a0,-64(s0)
    80005326:	06054063          	bltz	a0,80005386 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000532a:	4691                	li	a3,4
    8000532c:	fc440613          	addi	a2,s0,-60
    80005330:	fd843583          	ld	a1,-40(s0)
    80005334:	68a8                	ld	a0,80(s1)
    80005336:	a20fc0ef          	jal	80001556 <copyout>
    8000533a:	00054e63          	bltz	a0,80005356 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000533e:	4691                	li	a3,4
    80005340:	fc040613          	addi	a2,s0,-64
    80005344:	fd843583          	ld	a1,-40(s0)
    80005348:	0591                	addi	a1,a1,4
    8000534a:	68a8                	ld	a0,80(s1)
    8000534c:	a0afc0ef          	jal	80001556 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005350:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005352:	04055c63          	bgez	a0,800053aa <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005356:	fc442783          	lw	a5,-60(s0)
    8000535a:	07e9                	addi	a5,a5,26
    8000535c:	078e                	slli	a5,a5,0x3
    8000535e:	97a6                	add	a5,a5,s1
    80005360:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005364:	fc042783          	lw	a5,-64(s0)
    80005368:	07e9                	addi	a5,a5,26
    8000536a:	078e                	slli	a5,a5,0x3
    8000536c:	94be                	add	s1,s1,a5
    8000536e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005372:	fd043503          	ld	a0,-48(s0)
    80005376:	cd9fe0ef          	jal	8000404e <fileclose>
    fileclose(wf);
    8000537a:	fc843503          	ld	a0,-56(s0)
    8000537e:	cd1fe0ef          	jal	8000404e <fileclose>
    return -1;
    80005382:	57fd                	li	a5,-1
    80005384:	a01d                	j	800053aa <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005386:	fc442783          	lw	a5,-60(s0)
    8000538a:	0007c763          	bltz	a5,80005398 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000538e:	07e9                	addi	a5,a5,26
    80005390:	078e                	slli	a5,a5,0x3
    80005392:	97a6                	add	a5,a5,s1
    80005394:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005398:	fd043503          	ld	a0,-48(s0)
    8000539c:	cb3fe0ef          	jal	8000404e <fileclose>
    fileclose(wf);
    800053a0:	fc843503          	ld	a0,-56(s0)
    800053a4:	cabfe0ef          	jal	8000404e <fileclose>
    return -1;
    800053a8:	57fd                	li	a5,-1
}
    800053aa:	853e                	mv	a0,a5
    800053ac:	70e2                	ld	ra,56(sp)
    800053ae:	7442                	ld	s0,48(sp)
    800053b0:	74a2                	ld	s1,40(sp)
    800053b2:	6121                	addi	sp,sp,64
    800053b4:	8082                	ret
	...

00000000800053c0 <kernelvec>:
    800053c0:	7111                	addi	sp,sp,-256
    800053c2:	e006                	sd	ra,0(sp)
    800053c4:	e40a                	sd	sp,8(sp)
    800053c6:	e80e                	sd	gp,16(sp)
    800053c8:	ec12                	sd	tp,24(sp)
    800053ca:	f016                	sd	t0,32(sp)
    800053cc:	f41a                	sd	t1,40(sp)
    800053ce:	f81e                	sd	t2,48(sp)
    800053d0:	e4aa                	sd	a0,72(sp)
    800053d2:	e8ae                	sd	a1,80(sp)
    800053d4:	ecb2                	sd	a2,88(sp)
    800053d6:	f0b6                	sd	a3,96(sp)
    800053d8:	f4ba                	sd	a4,104(sp)
    800053da:	f8be                	sd	a5,112(sp)
    800053dc:	fcc2                	sd	a6,120(sp)
    800053de:	e146                	sd	a7,128(sp)
    800053e0:	edf2                	sd	t3,216(sp)
    800053e2:	f1f6                	sd	t4,224(sp)
    800053e4:	f5fa                	sd	t5,232(sp)
    800053e6:	f9fe                	sd	t6,240(sp)
    800053e8:	c10fd0ef          	jal	800027f8 <kerneltrap>
    800053ec:	6082                	ld	ra,0(sp)
    800053ee:	6122                	ld	sp,8(sp)
    800053f0:	61c2                	ld	gp,16(sp)
    800053f2:	7282                	ld	t0,32(sp)
    800053f4:	7322                	ld	t1,40(sp)
    800053f6:	73c2                	ld	t2,48(sp)
    800053f8:	6526                	ld	a0,72(sp)
    800053fa:	65c6                	ld	a1,80(sp)
    800053fc:	6666                	ld	a2,88(sp)
    800053fe:	7686                	ld	a3,96(sp)
    80005400:	7726                	ld	a4,104(sp)
    80005402:	77c6                	ld	a5,112(sp)
    80005404:	7866                	ld	a6,120(sp)
    80005406:	688a                	ld	a7,128(sp)
    80005408:	6e6e                	ld	t3,216(sp)
    8000540a:	7e8e                	ld	t4,224(sp)
    8000540c:	7f2e                	ld	t5,232(sp)
    8000540e:	7fce                	ld	t6,240(sp)
    80005410:	6111                	addi	sp,sp,256
    80005412:	10200073          	sret
	...

000000008000541e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000541e:	1141                	addi	sp,sp,-16
    80005420:	e422                	sd	s0,8(sp)
    80005422:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005424:	0c0007b7          	lui	a5,0xc000
    80005428:	4705                	li	a4,1
    8000542a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000542c:	0c0007b7          	lui	a5,0xc000
    80005430:	c3d8                	sw	a4,4(a5)
}
    80005432:	6422                	ld	s0,8(sp)
    80005434:	0141                	addi	sp,sp,16
    80005436:	8082                	ret

0000000080005438 <plicinithart>:

void
plicinithart(void)
{
    80005438:	1141                	addi	sp,sp,-16
    8000543a:	e406                	sd	ra,8(sp)
    8000543c:	e022                	sd	s0,0(sp)
    8000543e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005440:	c86fc0ef          	jal	800018c6 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005444:	0085171b          	slliw	a4,a0,0x8
    80005448:	0c0027b7          	lui	a5,0xc002
    8000544c:	97ba                	add	a5,a5,a4
    8000544e:	40200713          	li	a4,1026
    80005452:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005456:	00d5151b          	slliw	a0,a0,0xd
    8000545a:	0c2017b7          	lui	a5,0xc201
    8000545e:	97aa                	add	a5,a5,a0
    80005460:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005464:	60a2                	ld	ra,8(sp)
    80005466:	6402                	ld	s0,0(sp)
    80005468:	0141                	addi	sp,sp,16
    8000546a:	8082                	ret

000000008000546c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000546c:	1141                	addi	sp,sp,-16
    8000546e:	e406                	sd	ra,8(sp)
    80005470:	e022                	sd	s0,0(sp)
    80005472:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005474:	c52fc0ef          	jal	800018c6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005478:	00d5151b          	slliw	a0,a0,0xd
    8000547c:	0c2017b7          	lui	a5,0xc201
    80005480:	97aa                	add	a5,a5,a0
  return irq;
}
    80005482:	43c8                	lw	a0,4(a5)
    80005484:	60a2                	ld	ra,8(sp)
    80005486:	6402                	ld	s0,0(sp)
    80005488:	0141                	addi	sp,sp,16
    8000548a:	8082                	ret

000000008000548c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000548c:	1101                	addi	sp,sp,-32
    8000548e:	ec06                	sd	ra,24(sp)
    80005490:	e822                	sd	s0,16(sp)
    80005492:	e426                	sd	s1,8(sp)
    80005494:	1000                	addi	s0,sp,32
    80005496:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005498:	c2efc0ef          	jal	800018c6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000549c:	00d5151b          	slliw	a0,a0,0xd
    800054a0:	0c2017b7          	lui	a5,0xc201
    800054a4:	97aa                	add	a5,a5,a0
    800054a6:	c3c4                	sw	s1,4(a5)
}
    800054a8:	60e2                	ld	ra,24(sp)
    800054aa:	6442                	ld	s0,16(sp)
    800054ac:	64a2                	ld	s1,8(sp)
    800054ae:	6105                	addi	sp,sp,32
    800054b0:	8082                	ret

00000000800054b2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800054b2:	1141                	addi	sp,sp,-16
    800054b4:	e406                	sd	ra,8(sp)
    800054b6:	e022                	sd	s0,0(sp)
    800054b8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800054ba:	479d                	li	a5,7
    800054bc:	04a7ca63          	blt	a5,a0,80005510 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800054c0:	0001c797          	auipc	a5,0x1c
    800054c4:	b4078793          	addi	a5,a5,-1216 # 80021000 <disk>
    800054c8:	97aa                	add	a5,a5,a0
    800054ca:	0187c783          	lbu	a5,24(a5)
    800054ce:	e7b9                	bnez	a5,8000551c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800054d0:	00451693          	slli	a3,a0,0x4
    800054d4:	0001c797          	auipc	a5,0x1c
    800054d8:	b2c78793          	addi	a5,a5,-1236 # 80021000 <disk>
    800054dc:	6398                	ld	a4,0(a5)
    800054de:	9736                	add	a4,a4,a3
    800054e0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800054e4:	6398                	ld	a4,0(a5)
    800054e6:	9736                	add	a4,a4,a3
    800054e8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800054ec:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800054f0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800054f4:	97aa                	add	a5,a5,a0
    800054f6:	4705                	li	a4,1
    800054f8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800054fc:	0001c517          	auipc	a0,0x1c
    80005500:	b1c50513          	addi	a0,a0,-1252 # 80021018 <disk+0x18>
    80005504:	823fc0ef          	jal	80001d26 <wakeup>
}
    80005508:	60a2                	ld	ra,8(sp)
    8000550a:	6402                	ld	s0,0(sp)
    8000550c:	0141                	addi	sp,sp,16
    8000550e:	8082                	ret
    panic("free_desc 1");
    80005510:	00002517          	auipc	a0,0x2
    80005514:	1e050513          	addi	a0,a0,480 # 800076f0 <etext+0x6f0>
    80005518:	a7cfb0ef          	jal	80000794 <panic>
    panic("free_desc 2");
    8000551c:	00002517          	auipc	a0,0x2
    80005520:	1e450513          	addi	a0,a0,484 # 80007700 <etext+0x700>
    80005524:	a70fb0ef          	jal	80000794 <panic>

0000000080005528 <virtio_disk_init>:
{
    80005528:	1101                	addi	sp,sp,-32
    8000552a:	ec06                	sd	ra,24(sp)
    8000552c:	e822                	sd	s0,16(sp)
    8000552e:	e426                	sd	s1,8(sp)
    80005530:	e04a                	sd	s2,0(sp)
    80005532:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005534:	00002597          	auipc	a1,0x2
    80005538:	1dc58593          	addi	a1,a1,476 # 80007710 <etext+0x710>
    8000553c:	0001c517          	auipc	a0,0x1c
    80005540:	bec50513          	addi	a0,a0,-1044 # 80021128 <disk+0x128>
    80005544:	e30fb0ef          	jal	80000b74 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005548:	100017b7          	lui	a5,0x10001
    8000554c:	4398                	lw	a4,0(a5)
    8000554e:	2701                	sext.w	a4,a4
    80005550:	747277b7          	lui	a5,0x74727
    80005554:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005558:	18f71063          	bne	a4,a5,800056d8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000555c:	100017b7          	lui	a5,0x10001
    80005560:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005562:	439c                	lw	a5,0(a5)
    80005564:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005566:	4709                	li	a4,2
    80005568:	16e79863          	bne	a5,a4,800056d8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000556c:	100017b7          	lui	a5,0x10001
    80005570:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005572:	439c                	lw	a5,0(a5)
    80005574:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005576:	16e79163          	bne	a5,a4,800056d8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000557a:	100017b7          	lui	a5,0x10001
    8000557e:	47d8                	lw	a4,12(a5)
    80005580:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005582:	554d47b7          	lui	a5,0x554d4
    80005586:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000558a:	14f71763          	bne	a4,a5,800056d8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000558e:	100017b7          	lui	a5,0x10001
    80005592:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005596:	4705                	li	a4,1
    80005598:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000559a:	470d                	li	a4,3
    8000559c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000559e:	10001737          	lui	a4,0x10001
    800055a2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800055a4:	c7ffe737          	lui	a4,0xc7ffe
    800055a8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd61f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800055ac:	8ef9                	and	a3,a3,a4
    800055ae:	10001737          	lui	a4,0x10001
    800055b2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055b4:	472d                	li	a4,11
    800055b6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055b8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800055bc:	439c                	lw	a5,0(a5)
    800055be:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800055c2:	8ba1                	andi	a5,a5,8
    800055c4:	12078063          	beqz	a5,800056e4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800055c8:	100017b7          	lui	a5,0x10001
    800055cc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800055d0:	100017b7          	lui	a5,0x10001
    800055d4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800055d8:	439c                	lw	a5,0(a5)
    800055da:	2781                	sext.w	a5,a5
    800055dc:	10079a63          	bnez	a5,800056f0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800055e0:	100017b7          	lui	a5,0x10001
    800055e4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800055e8:	439c                	lw	a5,0(a5)
    800055ea:	2781                	sext.w	a5,a5
  if(max == 0)
    800055ec:	10078863          	beqz	a5,800056fc <virtio_disk_init+0x1d4>
  if(max < NUM)
    800055f0:	471d                	li	a4,7
    800055f2:	10f77b63          	bgeu	a4,a5,80005708 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    800055f6:	d2efb0ef          	jal	80000b24 <kalloc>
    800055fa:	0001c497          	auipc	s1,0x1c
    800055fe:	a0648493          	addi	s1,s1,-1530 # 80021000 <disk>
    80005602:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005604:	d20fb0ef          	jal	80000b24 <kalloc>
    80005608:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000560a:	d1afb0ef          	jal	80000b24 <kalloc>
    8000560e:	87aa                	mv	a5,a0
    80005610:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005612:	6088                	ld	a0,0(s1)
    80005614:	10050063          	beqz	a0,80005714 <virtio_disk_init+0x1ec>
    80005618:	0001c717          	auipc	a4,0x1c
    8000561c:	9f073703          	ld	a4,-1552(a4) # 80021008 <disk+0x8>
    80005620:	0e070a63          	beqz	a4,80005714 <virtio_disk_init+0x1ec>
    80005624:	0e078863          	beqz	a5,80005714 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005628:	6605                	lui	a2,0x1
    8000562a:	4581                	li	a1,0
    8000562c:	e9cfb0ef          	jal	80000cc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005630:	0001c497          	auipc	s1,0x1c
    80005634:	9d048493          	addi	s1,s1,-1584 # 80021000 <disk>
    80005638:	6605                	lui	a2,0x1
    8000563a:	4581                	li	a1,0
    8000563c:	6488                	ld	a0,8(s1)
    8000563e:	e8afb0ef          	jal	80000cc8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005642:	6605                	lui	a2,0x1
    80005644:	4581                	li	a1,0
    80005646:	6888                	ld	a0,16(s1)
    80005648:	e80fb0ef          	jal	80000cc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000564c:	100017b7          	lui	a5,0x10001
    80005650:	4721                	li	a4,8
    80005652:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005654:	4098                	lw	a4,0(s1)
    80005656:	100017b7          	lui	a5,0x10001
    8000565a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000565e:	40d8                	lw	a4,4(s1)
    80005660:	100017b7          	lui	a5,0x10001
    80005664:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005668:	649c                	ld	a5,8(s1)
    8000566a:	0007869b          	sext.w	a3,a5
    8000566e:	10001737          	lui	a4,0x10001
    80005672:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005676:	9781                	srai	a5,a5,0x20
    80005678:	10001737          	lui	a4,0x10001
    8000567c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005680:	689c                	ld	a5,16(s1)
    80005682:	0007869b          	sext.w	a3,a5
    80005686:	10001737          	lui	a4,0x10001
    8000568a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000568e:	9781                	srai	a5,a5,0x20
    80005690:	10001737          	lui	a4,0x10001
    80005694:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005698:	10001737          	lui	a4,0x10001
    8000569c:	4785                	li	a5,1
    8000569e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800056a0:	00f48c23          	sb	a5,24(s1)
    800056a4:	00f48ca3          	sb	a5,25(s1)
    800056a8:	00f48d23          	sb	a5,26(s1)
    800056ac:	00f48da3          	sb	a5,27(s1)
    800056b0:	00f48e23          	sb	a5,28(s1)
    800056b4:	00f48ea3          	sb	a5,29(s1)
    800056b8:	00f48f23          	sb	a5,30(s1)
    800056bc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800056c0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800056c4:	100017b7          	lui	a5,0x10001
    800056c8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800056cc:	60e2                	ld	ra,24(sp)
    800056ce:	6442                	ld	s0,16(sp)
    800056d0:	64a2                	ld	s1,8(sp)
    800056d2:	6902                	ld	s2,0(sp)
    800056d4:	6105                	addi	sp,sp,32
    800056d6:	8082                	ret
    panic("could not find virtio disk");
    800056d8:	00002517          	auipc	a0,0x2
    800056dc:	04850513          	addi	a0,a0,72 # 80007720 <etext+0x720>
    800056e0:	8b4fb0ef          	jal	80000794 <panic>
    panic("virtio disk FEATURES_OK unset");
    800056e4:	00002517          	auipc	a0,0x2
    800056e8:	05c50513          	addi	a0,a0,92 # 80007740 <etext+0x740>
    800056ec:	8a8fb0ef          	jal	80000794 <panic>
    panic("virtio disk should not be ready");
    800056f0:	00002517          	auipc	a0,0x2
    800056f4:	07050513          	addi	a0,a0,112 # 80007760 <etext+0x760>
    800056f8:	89cfb0ef          	jal	80000794 <panic>
    panic("virtio disk has no queue 0");
    800056fc:	00002517          	auipc	a0,0x2
    80005700:	08450513          	addi	a0,a0,132 # 80007780 <etext+0x780>
    80005704:	890fb0ef          	jal	80000794 <panic>
    panic("virtio disk max queue too short");
    80005708:	00002517          	auipc	a0,0x2
    8000570c:	09850513          	addi	a0,a0,152 # 800077a0 <etext+0x7a0>
    80005710:	884fb0ef          	jal	80000794 <panic>
    panic("virtio disk kalloc");
    80005714:	00002517          	auipc	a0,0x2
    80005718:	0ac50513          	addi	a0,a0,172 # 800077c0 <etext+0x7c0>
    8000571c:	878fb0ef          	jal	80000794 <panic>

0000000080005720 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005720:	7159                	addi	sp,sp,-112
    80005722:	f486                	sd	ra,104(sp)
    80005724:	f0a2                	sd	s0,96(sp)
    80005726:	eca6                	sd	s1,88(sp)
    80005728:	e8ca                	sd	s2,80(sp)
    8000572a:	e4ce                	sd	s3,72(sp)
    8000572c:	e0d2                	sd	s4,64(sp)
    8000572e:	fc56                	sd	s5,56(sp)
    80005730:	f85a                	sd	s6,48(sp)
    80005732:	f45e                	sd	s7,40(sp)
    80005734:	f062                	sd	s8,32(sp)
    80005736:	ec66                	sd	s9,24(sp)
    80005738:	1880                	addi	s0,sp,112
    8000573a:	8a2a                	mv	s4,a0
    8000573c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000573e:	00c52c83          	lw	s9,12(a0)
    80005742:	001c9c9b          	slliw	s9,s9,0x1
    80005746:	1c82                	slli	s9,s9,0x20
    80005748:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000574c:	0001c517          	auipc	a0,0x1c
    80005750:	9dc50513          	addi	a0,a0,-1572 # 80021128 <disk+0x128>
    80005754:	ca0fb0ef          	jal	80000bf4 <acquire>
  for(int i = 0; i < 3; i++){
    80005758:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000575a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000575c:	0001cb17          	auipc	s6,0x1c
    80005760:	8a4b0b13          	addi	s6,s6,-1884 # 80021000 <disk>
  for(int i = 0; i < 3; i++){
    80005764:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005766:	0001cc17          	auipc	s8,0x1c
    8000576a:	9c2c0c13          	addi	s8,s8,-1598 # 80021128 <disk+0x128>
    8000576e:	a8b9                	j	800057cc <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005770:	00fb0733          	add	a4,s6,a5
    80005774:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005778:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000577a:	0207c563          	bltz	a5,800057a4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    8000577e:	2905                	addiw	s2,s2,1
    80005780:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005782:	05590963          	beq	s2,s5,800057d4 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005786:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005788:	0001c717          	auipc	a4,0x1c
    8000578c:	87870713          	addi	a4,a4,-1928 # 80021000 <disk>
    80005790:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005792:	01874683          	lbu	a3,24(a4)
    80005796:	fee9                	bnez	a3,80005770 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005798:	2785                	addiw	a5,a5,1
    8000579a:	0705                	addi	a4,a4,1
    8000579c:	fe979be3          	bne	a5,s1,80005792 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800057a0:	57fd                	li	a5,-1
    800057a2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800057a4:	01205d63          	blez	s2,800057be <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800057a8:	f9042503          	lw	a0,-112(s0)
    800057ac:	d07ff0ef          	jal	800054b2 <free_desc>
      for(int j = 0; j < i; j++)
    800057b0:	4785                	li	a5,1
    800057b2:	0127d663          	bge	a5,s2,800057be <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800057b6:	f9442503          	lw	a0,-108(s0)
    800057ba:	cf9ff0ef          	jal	800054b2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057be:	85e2                	mv	a1,s8
    800057c0:	0001c517          	auipc	a0,0x1c
    800057c4:	85850513          	addi	a0,a0,-1960 # 80021018 <disk+0x18>
    800057c8:	d12fc0ef          	jal	80001cda <sleep>
  for(int i = 0; i < 3; i++){
    800057cc:	f9040613          	addi	a2,s0,-112
    800057d0:	894e                	mv	s2,s3
    800057d2:	bf55                	j	80005786 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057d4:	f9042503          	lw	a0,-112(s0)
    800057d8:	00451693          	slli	a3,a0,0x4

  if(write)
    800057dc:	0001c797          	auipc	a5,0x1c
    800057e0:	82478793          	addi	a5,a5,-2012 # 80021000 <disk>
    800057e4:	00a50713          	addi	a4,a0,10
    800057e8:	0712                	slli	a4,a4,0x4
    800057ea:	973e                	add	a4,a4,a5
    800057ec:	01703633          	snez	a2,s7
    800057f0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800057f2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800057f6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800057fa:	6398                	ld	a4,0(a5)
    800057fc:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057fe:	0a868613          	addi	a2,a3,168
    80005802:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005804:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005806:	6390                	ld	a2,0(a5)
    80005808:	00d605b3          	add	a1,a2,a3
    8000580c:	4741                	li	a4,16
    8000580e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005810:	4805                	li	a6,1
    80005812:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005816:	f9442703          	lw	a4,-108(s0)
    8000581a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000581e:	0712                	slli	a4,a4,0x4
    80005820:	963a                	add	a2,a2,a4
    80005822:	058a0593          	addi	a1,s4,88
    80005826:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005828:	0007b883          	ld	a7,0(a5)
    8000582c:	9746                	add	a4,a4,a7
    8000582e:	40000613          	li	a2,1024
    80005832:	c710                	sw	a2,8(a4)
  if(write)
    80005834:	001bb613          	seqz	a2,s7
    80005838:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000583c:	00166613          	ori	a2,a2,1
    80005840:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005844:	f9842583          	lw	a1,-104(s0)
    80005848:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000584c:	00250613          	addi	a2,a0,2
    80005850:	0612                	slli	a2,a2,0x4
    80005852:	963e                	add	a2,a2,a5
    80005854:	577d                	li	a4,-1
    80005856:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000585a:	0592                	slli	a1,a1,0x4
    8000585c:	98ae                	add	a7,a7,a1
    8000585e:	03068713          	addi	a4,a3,48
    80005862:	973e                	add	a4,a4,a5
    80005864:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005868:	6398                	ld	a4,0(a5)
    8000586a:	972e                	add	a4,a4,a1
    8000586c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005870:	4689                	li	a3,2
    80005872:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005876:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000587a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    8000587e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005882:	6794                	ld	a3,8(a5)
    80005884:	0026d703          	lhu	a4,2(a3)
    80005888:	8b1d                	andi	a4,a4,7
    8000588a:	0706                	slli	a4,a4,0x1
    8000588c:	96ba                	add	a3,a3,a4
    8000588e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005892:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005896:	6798                	ld	a4,8(a5)
    80005898:	00275783          	lhu	a5,2(a4)
    8000589c:	2785                	addiw	a5,a5,1
    8000589e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800058a2:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800058a6:	100017b7          	lui	a5,0x10001
    800058aa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800058ae:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800058b2:	0001c917          	auipc	s2,0x1c
    800058b6:	87690913          	addi	s2,s2,-1930 # 80021128 <disk+0x128>
  while(b->disk == 1) {
    800058ba:	4485                	li	s1,1
    800058bc:	01079a63          	bne	a5,a6,800058d0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    800058c0:	85ca                	mv	a1,s2
    800058c2:	8552                	mv	a0,s4
    800058c4:	c16fc0ef          	jal	80001cda <sleep>
  while(b->disk == 1) {
    800058c8:	004a2783          	lw	a5,4(s4)
    800058cc:	fe978ae3          	beq	a5,s1,800058c0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    800058d0:	f9042903          	lw	s2,-112(s0)
    800058d4:	00290713          	addi	a4,s2,2
    800058d8:	0712                	slli	a4,a4,0x4
    800058da:	0001b797          	auipc	a5,0x1b
    800058de:	72678793          	addi	a5,a5,1830 # 80021000 <disk>
    800058e2:	97ba                	add	a5,a5,a4
    800058e4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800058e8:	0001b997          	auipc	s3,0x1b
    800058ec:	71898993          	addi	s3,s3,1816 # 80021000 <disk>
    800058f0:	00491713          	slli	a4,s2,0x4
    800058f4:	0009b783          	ld	a5,0(s3)
    800058f8:	97ba                	add	a5,a5,a4
    800058fa:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800058fe:	854a                	mv	a0,s2
    80005900:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005904:	bafff0ef          	jal	800054b2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005908:	8885                	andi	s1,s1,1
    8000590a:	f0fd                	bnez	s1,800058f0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000590c:	0001c517          	auipc	a0,0x1c
    80005910:	81c50513          	addi	a0,a0,-2020 # 80021128 <disk+0x128>
    80005914:	b78fb0ef          	jal	80000c8c <release>
}
    80005918:	70a6                	ld	ra,104(sp)
    8000591a:	7406                	ld	s0,96(sp)
    8000591c:	64e6                	ld	s1,88(sp)
    8000591e:	6946                	ld	s2,80(sp)
    80005920:	69a6                	ld	s3,72(sp)
    80005922:	6a06                	ld	s4,64(sp)
    80005924:	7ae2                	ld	s5,56(sp)
    80005926:	7b42                	ld	s6,48(sp)
    80005928:	7ba2                	ld	s7,40(sp)
    8000592a:	7c02                	ld	s8,32(sp)
    8000592c:	6ce2                	ld	s9,24(sp)
    8000592e:	6165                	addi	sp,sp,112
    80005930:	8082                	ret

0000000080005932 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005932:	1101                	addi	sp,sp,-32
    80005934:	ec06                	sd	ra,24(sp)
    80005936:	e822                	sd	s0,16(sp)
    80005938:	e426                	sd	s1,8(sp)
    8000593a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000593c:	0001b497          	auipc	s1,0x1b
    80005940:	6c448493          	addi	s1,s1,1732 # 80021000 <disk>
    80005944:	0001b517          	auipc	a0,0x1b
    80005948:	7e450513          	addi	a0,a0,2020 # 80021128 <disk+0x128>
    8000594c:	aa8fb0ef          	jal	80000bf4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005950:	100017b7          	lui	a5,0x10001
    80005954:	53b8                	lw	a4,96(a5)
    80005956:	8b0d                	andi	a4,a4,3
    80005958:	100017b7          	lui	a5,0x10001
    8000595c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    8000595e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005962:	689c                	ld	a5,16(s1)
    80005964:	0204d703          	lhu	a4,32(s1)
    80005968:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000596c:	04f70663          	beq	a4,a5,800059b8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005970:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005974:	6898                	ld	a4,16(s1)
    80005976:	0204d783          	lhu	a5,32(s1)
    8000597a:	8b9d                	andi	a5,a5,7
    8000597c:	078e                	slli	a5,a5,0x3
    8000597e:	97ba                	add	a5,a5,a4
    80005980:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005982:	00278713          	addi	a4,a5,2
    80005986:	0712                	slli	a4,a4,0x4
    80005988:	9726                	add	a4,a4,s1
    8000598a:	01074703          	lbu	a4,16(a4)
    8000598e:	e321                	bnez	a4,800059ce <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005990:	0789                	addi	a5,a5,2
    80005992:	0792                	slli	a5,a5,0x4
    80005994:	97a6                	add	a5,a5,s1
    80005996:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005998:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000599c:	b8afc0ef          	jal	80001d26 <wakeup>

    disk.used_idx += 1;
    800059a0:	0204d783          	lhu	a5,32(s1)
    800059a4:	2785                	addiw	a5,a5,1
    800059a6:	17c2                	slli	a5,a5,0x30
    800059a8:	93c1                	srli	a5,a5,0x30
    800059aa:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800059ae:	6898                	ld	a4,16(s1)
    800059b0:	00275703          	lhu	a4,2(a4)
    800059b4:	faf71ee3          	bne	a4,a5,80005970 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800059b8:	0001b517          	auipc	a0,0x1b
    800059bc:	77050513          	addi	a0,a0,1904 # 80021128 <disk+0x128>
    800059c0:	accfb0ef          	jal	80000c8c <release>
}
    800059c4:	60e2                	ld	ra,24(sp)
    800059c6:	6442                	ld	s0,16(sp)
    800059c8:	64a2                	ld	s1,8(sp)
    800059ca:	6105                	addi	sp,sp,32
    800059cc:	8082                	ret
      panic("virtio_disk_intr status");
    800059ce:	00002517          	auipc	a0,0x2
    800059d2:	e0a50513          	addi	a0,a0,-502 # 800077d8 <etext+0x7d8>
    800059d6:	dbffa0ef          	jal	80000794 <panic>
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
