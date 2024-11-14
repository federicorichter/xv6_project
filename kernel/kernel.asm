
kernel/kernel:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	94010113          	addi	sp,sp,-1728 # 80007940 <stack0>
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
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffe2d8f>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	de478793          	addi	a5,a5,-540 # 80000e64 <main>
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
    800000fa:	689010ef          	jal	80001f82 <either_copyin>
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
    80000154:	0000f517          	auipc	a0,0xf
    80000158:	7ec50513          	addi	a0,a0,2028 # 8000f940 <cons>
    8000015c:	29b000ef          	jal	80000bf6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	0000f497          	auipc	s1,0xf
    80000164:	7e048493          	addi	s1,s1,2016 # 8000f940 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00010917          	auipc	s2,0x10
    8000016c:	87090913          	addi	s2,s2,-1936 # 8000f9d8 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	744010ef          	jal	800018c4 <myproc>
    80000184:	46f010ef          	jal	80001df2 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	2dd010ef          	jal	80001c6a <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	0000f717          	auipc	a4,0xf
    800001a4:	7a070713          	addi	a4,a4,1952 # 8000f940 <cons>
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
    800001d2:	567010ef          	jal	80001f38 <either_copyout>
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
    800001ee:	75650513          	addi	a0,a0,1878 # 8000f940 <cons>
    800001f2:	29d000ef          	jal	80000c8e <release>
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
    80000214:	0000f717          	auipc	a4,0xf
    80000218:	7cf72223          	sw	a5,1988(a4) # 8000f9d8 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	0000f517          	auipc	a0,0xf
    8000022e:	71650513          	addi	a0,a0,1814 # 8000f940 <cons>
    80000232:	25d000ef          	jal	80000c8e <release>
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
    80000282:	6c250513          	addi	a0,a0,1730 # 8000f940 <cons>
    80000286:	171000ef          	jal	80000bf6 <acquire>

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
    800002a0:	52d010ef          	jal	80001fcc <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002a4:	0000f517          	auipc	a0,0xf
    800002a8:	69c50513          	addi	a0,a0,1692 # 8000f940 <cons>
    800002ac:	1e3000ef          	jal	80000c8e <release>
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
    800002c6:	67e70713          	addi	a4,a4,1662 # 8000f940 <cons>
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
    800002ec:	65878793          	addi	a5,a5,1624 # 8000f940 <cons>
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
    8000031a:	6c27a783          	lw	a5,1730(a5) # 8000f9d8 <cons+0x98>
    8000031e:	9f1d                	subw	a4,a4,a5
    80000320:	08000793          	li	a5,128
    80000324:	f8f710e3          	bne	a4,a5,800002a4 <consoleintr+0x32>
    80000328:	a07d                	j	800003d6 <consoleintr+0x164>
    8000032a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000032c:	0000f717          	auipc	a4,0xf
    80000330:	61470713          	addi	a4,a4,1556 # 8000f940 <cons>
    80000334:	0a072783          	lw	a5,160(a4)
    80000338:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000033c:	0000f497          	auipc	s1,0xf
    80000340:	60448493          	addi	s1,s1,1540 # 8000f940 <cons>
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
    80000382:	5c270713          	addi	a4,a4,1474 # 8000f940 <cons>
    80000386:	0a072783          	lw	a5,160(a4)
    8000038a:	09c72703          	lw	a4,156(a4)
    8000038e:	f0f70be3          	beq	a4,a5,800002a4 <consoleintr+0x32>
      cons.e--;
    80000392:	37fd                	addiw	a5,a5,-1
    80000394:	0000f717          	auipc	a4,0xf
    80000398:	64f72623          	sw	a5,1612(a4) # 8000f9e0 <cons+0xa0>
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
    800003b6:	58e78793          	addi	a5,a5,1422 # 8000f940 <cons>
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
    800003da:	60c7a323          	sw	a2,1542(a5) # 8000f9dc <cons+0x9c>
        wakeup(&cons.r);
    800003de:	0000f517          	auipc	a0,0xf
    800003e2:	5fa50513          	addi	a0,a0,1530 # 8000f9d8 <cons+0x98>
    800003e6:	0d1010ef          	jal	80001cb6 <wakeup>
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
    80000400:	54450513          	addi	a0,a0,1348 # 8000f940 <cons>
    80000404:	772000ef          	jal	80000b76 <initlock>

  uartinit();
    80000408:	3f4000ef          	jal	800007fc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000040c:	0001a797          	auipc	a5,0x1a
    80000410:	4cc78793          	addi	a5,a5,1228 # 8001a8d8 <devsw>
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
    8000044a:	35a60613          	addi	a2,a2,858 # 800077a0 <digits>
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
    800004e4:	5207a783          	lw	a5,1312(a5) # 8000fa00 <pr+0x18>
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
    80000530:	4bc50513          	addi	a0,a0,1212 # 8000f9e8 <pr>
    80000534:	6c2000ef          	jal	80000bf6 <acquire>
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
    800006f0:	0b4b8b93          	addi	s7,s7,180 # 800077a0 <digits>
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
    8000078a:	26250513          	addi	a0,a0,610 # 8000f9e8 <pr>
    8000078e:	500000ef          	jal	80000c8e <release>
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
    800007a4:	2607a023          	sw	zero,608(a5) # 8000fa00 <pr+0x18>
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
    800007c8:	12f72e23          	sw	a5,316(a4) # 80007900 <panicked>
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
    800007dc:	21048493          	addi	s1,s1,528 # 8000f9e8 <pr>
    800007e0:	00007597          	auipc	a1,0x7
    800007e4:	84858593          	addi	a1,a1,-1976 # 80007028 <etext+0x28>
    800007e8:	8526                	mv	a0,s1
    800007ea:	38c000ef          	jal	80000b76 <initlock>
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
    80000844:	1c850513          	addi	a0,a0,456 # 8000fa08 <uart_tx_lock>
    80000848:	32e000ef          	jal	80000b76 <initlock>
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
    80000860:	356000ef          	jal	80000bb6 <push_off>

  if(panicked){
    80000864:	00007797          	auipc	a5,0x7
    80000868:	09c7a783          	lw	a5,156(a5) # 80007900 <panicked>
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
    8000088a:	3b0000ef          	jal	80000c3a <pop_off>
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
    8000089e:	06e7b783          	ld	a5,110(a5) # 80007908 <uart_tx_r>
    800008a2:	00007717          	auipc	a4,0x7
    800008a6:	06e73703          	ld	a4,110(a4) # 80007910 <uart_tx_w>
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
    800008cc:	140a8a93          	addi	s5,s5,320 # 8000fa08 <uart_tx_lock>
    uart_tx_r += 1;
    800008d0:	00007497          	auipc	s1,0x7
    800008d4:	03848493          	addi	s1,s1,56 # 80007908 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008d8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008dc:	00007997          	auipc	s3,0x7
    800008e0:	03498993          	addi	s3,s3,52 # 80007910 <uart_tx_w>
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
    800008fe:	3b8010ef          	jal	80001cb6 <wakeup>
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
    80000950:	0bc50513          	addi	a0,a0,188 # 8000fa08 <uart_tx_lock>
    80000954:	2a2000ef          	jal	80000bf6 <acquire>
  if(panicked){
    80000958:	00007797          	auipc	a5,0x7
    8000095c:	fa87a783          	lw	a5,-88(a5) # 80007900 <panicked>
    80000960:	efbd                	bnez	a5,800009de <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000962:	00007717          	auipc	a4,0x7
    80000966:	fae73703          	ld	a4,-82(a4) # 80007910 <uart_tx_w>
    8000096a:	00007797          	auipc	a5,0x7
    8000096e:	f9e7b783          	ld	a5,-98(a5) # 80007908 <uart_tx_r>
    80000972:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000976:	0000f997          	auipc	s3,0xf
    8000097a:	09298993          	addi	s3,s3,146 # 8000fa08 <uart_tx_lock>
    8000097e:	00007497          	auipc	s1,0x7
    80000982:	f8a48493          	addi	s1,s1,-118 # 80007908 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00007917          	auipc	s2,0x7
    8000098a:	f8a90913          	addi	s2,s2,-118 # 80007910 <uart_tx_w>
    8000098e:	00e79d63          	bne	a5,a4,800009a8 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000992:	85ce                	mv	a1,s3
    80000994:	8526                	mv	a0,s1
    80000996:	2d4010ef          	jal	80001c6a <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099a:	00093703          	ld	a4,0(s2)
    8000099e:	609c                	ld	a5,0(s1)
    800009a0:	02078793          	addi	a5,a5,32
    800009a4:	fee787e3          	beq	a5,a4,80000992 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a8:	0000f497          	auipc	s1,0xf
    800009ac:	06048493          	addi	s1,s1,96 # 8000fa08 <uart_tx_lock>
    800009b0:	01f77793          	andi	a5,a4,31
    800009b4:	97a6                	add	a5,a5,s1
    800009b6:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009ba:	0705                	addi	a4,a4,1
    800009bc:	00007797          	auipc	a5,0x7
    800009c0:	f4e7ba23          	sd	a4,-172(a5) # 80007910 <uart_tx_w>
  uartstart();
    800009c4:	ed7ff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    800009c8:	8526                	mv	a0,s1
    800009ca:	2c4000ef          	jal	80000c8e <release>
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
    80000a24:	fe848493          	addi	s1,s1,-24 # 8000fa08 <uart_tx_lock>
    80000a28:	8526                	mv	a0,s1
    80000a2a:	1cc000ef          	jal	80000bf6 <acquire>
  uartstart();
    80000a2e:	e6dff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    80000a32:	8526                	mv	a0,s1
    80000a34:	25a000ef          	jal	80000c8e <release>
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
    80000a56:	0001b797          	auipc	a5,0x1b
    80000a5a:	01a78793          	addi	a5,a5,26 # 8001ba70 <end>
    80000a5e:	02f56f63          	bltu	a0,a5,80000a9c <kfree+0x5a>
    80000a62:	4795                	li	a5,5
    80000a64:	07f6                	slli	a5,a5,0x1d
    80000a66:	02f57b63          	bgeu	a0,a5,80000a9c <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a6a:	6605                	lui	a2,0x1
    80000a6c:	4585                	li	a1,1
    80000a6e:	25c000ef          	jal	80000cca <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a72:	0000f917          	auipc	s2,0xf
    80000a76:	fce90913          	addi	s2,s2,-50 # 8000fa40 <kmem>
    80000a7a:	854a                	mv	a0,s2
    80000a7c:	17a000ef          	jal	80000bf6 <acquire>
  r->next = kmem.freelist;
    80000a80:	01893783          	ld	a5,24(s2)
    80000a84:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a86:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a8a:	854a                	mv	a0,s2
    80000a8c:	202000ef          	jal	80000c8e <release>
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
    80000b04:	f4050513          	addi	a0,a0,-192 # 8000fa40 <kmem>
    80000b08:	06e000ef          	jal	80000b76 <initlock>
  freerange(end, (void*)PROC_SPACE);
    80000b0c:	010015b7          	lui	a1,0x1001
    80000b10:	059e                	slli	a1,a1,0x7
    80000b12:	0001b517          	auipc	a0,0x1b
    80000b16:	f5e50513          	addi	a0,a0,-162 # 8001ba70 <end>
    80000b1a:	f8fff0ef          	jal	80000aa8 <freerange>
}
    80000b1e:	60a2                	ld	ra,8(sp)
    80000b20:	6402                	ld	s0,0(sp)
    80000b22:	0141                	addi	sp,sp,16
    80000b24:	8082                	ret

0000000080000b26 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b26:	1101                	addi	sp,sp,-32
    80000b28:	ec06                	sd	ra,24(sp)
    80000b2a:	e822                	sd	s0,16(sp)
    80000b2c:	e426                	sd	s1,8(sp)
    80000b2e:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b30:	0000f497          	auipc	s1,0xf
    80000b34:	f1048493          	addi	s1,s1,-240 # 8000fa40 <kmem>
    80000b38:	8526                	mv	a0,s1
    80000b3a:	0bc000ef          	jal	80000bf6 <acquire>
  r = kmem.freelist;
    80000b3e:	6c84                	ld	s1,24(s1)
  if(r)
    80000b40:	c485                	beqz	s1,80000b68 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b42:	609c                	ld	a5,0(s1)
    80000b44:	0000f517          	auipc	a0,0xf
    80000b48:	efc50513          	addi	a0,a0,-260 # 8000fa40 <kmem>
    80000b4c:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b4e:	140000ef          	jal	80000c8e <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b52:	6605                	lui	a2,0x1
    80000b54:	4595                	li	a1,5
    80000b56:	8526                	mv	a0,s1
    80000b58:	172000ef          	jal	80000cca <memset>
  return (void*)r;
}
    80000b5c:	8526                	mv	a0,s1
    80000b5e:	60e2                	ld	ra,24(sp)
    80000b60:	6442                	ld	s0,16(sp)
    80000b62:	64a2                	ld	s1,8(sp)
    80000b64:	6105                	addi	sp,sp,32
    80000b66:	8082                	ret
  release(&kmem.lock);
    80000b68:	0000f517          	auipc	a0,0xf
    80000b6c:	ed850513          	addi	a0,a0,-296 # 8000fa40 <kmem>
    80000b70:	11e000ef          	jal	80000c8e <release>
  if(r)
    80000b74:	b7e5                	j	80000b5c <kalloc+0x36>

0000000080000b76 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b76:	1141                	addi	sp,sp,-16
    80000b78:	e422                	sd	s0,8(sp)
    80000b7a:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b7c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b7e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b82:	00053823          	sd	zero,16(a0)
}
    80000b86:	6422                	ld	s0,8(sp)
    80000b88:	0141                	addi	sp,sp,16
    80000b8a:	8082                	ret

0000000080000b8c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b8c:	411c                	lw	a5,0(a0)
    80000b8e:	e399                	bnez	a5,80000b94 <holding+0x8>
    80000b90:	4501                	li	a0,0
  return r;
}
    80000b92:	8082                	ret
{
    80000b94:	1101                	addi	sp,sp,-32
    80000b96:	ec06                	sd	ra,24(sp)
    80000b98:	e822                	sd	s0,16(sp)
    80000b9a:	e426                	sd	s1,8(sp)
    80000b9c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b9e:	6904                	ld	s1,16(a0)
    80000ba0:	509000ef          	jal	800018a8 <mycpu>
    80000ba4:	40a48533          	sub	a0,s1,a0
    80000ba8:	00153513          	seqz	a0,a0
}
    80000bac:	60e2                	ld	ra,24(sp)
    80000bae:	6442                	ld	s0,16(sp)
    80000bb0:	64a2                	ld	s1,8(sp)
    80000bb2:	6105                	addi	sp,sp,32
    80000bb4:	8082                	ret

0000000080000bb6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb6:	1101                	addi	sp,sp,-32
    80000bb8:	ec06                	sd	ra,24(sp)
    80000bba:	e822                	sd	s0,16(sp)
    80000bbc:	e426                	sd	s1,8(sp)
    80000bbe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bc0:	100024f3          	csrr	s1,sstatus
    80000bc4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bca:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bce:	4db000ef          	jal	800018a8 <mycpu>
    80000bd2:	5d3c                	lw	a5,120(a0)
    80000bd4:	cb99                	beqz	a5,80000bea <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd6:	4d3000ef          	jal	800018a8 <mycpu>
    80000bda:	5d3c                	lw	a5,120(a0)
    80000bdc:	2785                	addiw	a5,a5,1
    80000bde:	dd3c                	sw	a5,120(a0)
}
    80000be0:	60e2                	ld	ra,24(sp)
    80000be2:	6442                	ld	s0,16(sp)
    80000be4:	64a2                	ld	s1,8(sp)
    80000be6:	6105                	addi	sp,sp,32
    80000be8:	8082                	ret
    mycpu()->intena = old;
    80000bea:	4bf000ef          	jal	800018a8 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bee:	8085                	srli	s1,s1,0x1
    80000bf0:	8885                	andi	s1,s1,1
    80000bf2:	dd64                	sw	s1,124(a0)
    80000bf4:	b7cd                	j	80000bd6 <push_off+0x20>

0000000080000bf6 <acquire>:
{
    80000bf6:	1101                	addi	sp,sp,-32
    80000bf8:	ec06                	sd	ra,24(sp)
    80000bfa:	e822                	sd	s0,16(sp)
    80000bfc:	e426                	sd	s1,8(sp)
    80000bfe:	1000                	addi	s0,sp,32
    80000c00:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c02:	fb5ff0ef          	jal	80000bb6 <push_off>
  if(holding(lk))
    80000c06:	8526                	mv	a0,s1
    80000c08:	f85ff0ef          	jal	80000b8c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0c:	4705                	li	a4,1
  if(holding(lk))
    80000c0e:	e105                	bnez	a0,80000c2e <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c10:	87ba                	mv	a5,a4
    80000c12:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c16:	2781                	sext.w	a5,a5
    80000c18:	ffe5                	bnez	a5,80000c10 <acquire+0x1a>
  __sync_synchronize();
    80000c1a:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c1e:	48b000ef          	jal	800018a8 <mycpu>
    80000c22:	e888                	sd	a0,16(s1)
}
    80000c24:	60e2                	ld	ra,24(sp)
    80000c26:	6442                	ld	s0,16(sp)
    80000c28:	64a2                	ld	s1,8(sp)
    80000c2a:	6105                	addi	sp,sp,32
    80000c2c:	8082                	ret
    panic("acquire");
    80000c2e:	00006517          	auipc	a0,0x6
    80000c32:	41a50513          	addi	a0,a0,1050 # 80007048 <etext+0x48>
    80000c36:	b5fff0ef          	jal	80000794 <panic>

0000000080000c3a <pop_off>:

void
pop_off(void)
{
    80000c3a:	1141                	addi	sp,sp,-16
    80000c3c:	e406                	sd	ra,8(sp)
    80000c3e:	e022                	sd	s0,0(sp)
    80000c40:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c42:	467000ef          	jal	800018a8 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c46:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c4a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c4c:	e78d                	bnez	a5,80000c76 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c4e:	5d3c                	lw	a5,120(a0)
    80000c50:	02f05963          	blez	a5,80000c82 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c54:	37fd                	addiw	a5,a5,-1
    80000c56:	0007871b          	sext.w	a4,a5
    80000c5a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c5c:	eb09                	bnez	a4,80000c6e <pop_off+0x34>
    80000c5e:	5d7c                	lw	a5,124(a0)
    80000c60:	c799                	beqz	a5,80000c6e <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c62:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c66:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c6a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c6e:	60a2                	ld	ra,8(sp)
    80000c70:	6402                	ld	s0,0(sp)
    80000c72:	0141                	addi	sp,sp,16
    80000c74:	8082                	ret
    panic("pop_off - interruptible");
    80000c76:	00006517          	auipc	a0,0x6
    80000c7a:	3da50513          	addi	a0,a0,986 # 80007050 <etext+0x50>
    80000c7e:	b17ff0ef          	jal	80000794 <panic>
    panic("pop_off");
    80000c82:	00006517          	auipc	a0,0x6
    80000c86:	3e650513          	addi	a0,a0,998 # 80007068 <etext+0x68>
    80000c8a:	b0bff0ef          	jal	80000794 <panic>

0000000080000c8e <release>:
{
    80000c8e:	1101                	addi	sp,sp,-32
    80000c90:	ec06                	sd	ra,24(sp)
    80000c92:	e822                	sd	s0,16(sp)
    80000c94:	e426                	sd	s1,8(sp)
    80000c96:	1000                	addi	s0,sp,32
    80000c98:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c9a:	ef3ff0ef          	jal	80000b8c <holding>
    80000c9e:	c105                	beqz	a0,80000cbe <release+0x30>
  lk->cpu = 0;
    80000ca0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca8:	0f50000f          	fence	iorw,ow
    80000cac:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cb0:	f8bff0ef          	jal	80000c3a <pop_off>
}
    80000cb4:	60e2                	ld	ra,24(sp)
    80000cb6:	6442                	ld	s0,16(sp)
    80000cb8:	64a2                	ld	s1,8(sp)
    80000cba:	6105                	addi	sp,sp,32
    80000cbc:	8082                	ret
    panic("release");
    80000cbe:	00006517          	auipc	a0,0x6
    80000cc2:	3b250513          	addi	a0,a0,946 # 80007070 <etext+0x70>
    80000cc6:	acfff0ef          	jal	80000794 <panic>

0000000080000cca <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cca:	1141                	addi	sp,sp,-16
    80000ccc:	e422                	sd	s0,8(sp)
    80000cce:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd0:	ca19                	beqz	a2,80000ce6 <memset+0x1c>
    80000cd2:	87aa                	mv	a5,a0
    80000cd4:	1602                	slli	a2,a2,0x20
    80000cd6:	9201                	srli	a2,a2,0x20
    80000cd8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cdc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce0:	0785                	addi	a5,a5,1
    80000ce2:	fee79de3          	bne	a5,a4,80000cdc <memset+0x12>
  }
  return dst;
}
    80000ce6:	6422                	ld	s0,8(sp)
    80000ce8:	0141                	addi	sp,sp,16
    80000cea:	8082                	ret

0000000080000cec <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cec:	1141                	addi	sp,sp,-16
    80000cee:	e422                	sd	s0,8(sp)
    80000cf0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf2:	ca05                	beqz	a2,80000d22 <memcmp+0x36>
    80000cf4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cf8:	1682                	slli	a3,a3,0x20
    80000cfa:	9281                	srli	a3,a3,0x20
    80000cfc:	0685                	addi	a3,a3,1
    80000cfe:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d00:	00054783          	lbu	a5,0(a0)
    80000d04:	0005c703          	lbu	a4,0(a1) # 1001000 <_entry-0x7efff000>
    80000d08:	00e79863          	bne	a5,a4,80000d18 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d0c:	0505                	addi	a0,a0,1
    80000d0e:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d10:	fed518e3          	bne	a0,a3,80000d00 <memcmp+0x14>
  }

  return 0;
    80000d14:	4501                	li	a0,0
    80000d16:	a019                	j	80000d1c <memcmp+0x30>
      return *s1 - *s2;
    80000d18:	40e7853b          	subw	a0,a5,a4
}
    80000d1c:	6422                	ld	s0,8(sp)
    80000d1e:	0141                	addi	sp,sp,16
    80000d20:	8082                	ret
  return 0;
    80000d22:	4501                	li	a0,0
    80000d24:	bfe5                	j	80000d1c <memcmp+0x30>

0000000080000d26 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d26:	1141                	addi	sp,sp,-16
    80000d28:	e422                	sd	s0,8(sp)
    80000d2a:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d2c:	c205                	beqz	a2,80000d4c <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d2e:	02a5e263          	bltu	a1,a0,80000d52 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d32:	1602                	slli	a2,a2,0x20
    80000d34:	9201                	srli	a2,a2,0x20
    80000d36:	00c587b3          	add	a5,a1,a2
{
    80000d3a:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d3c:	0585                	addi	a1,a1,1
    80000d3e:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffe3591>
    80000d40:	fff5c683          	lbu	a3,-1(a1)
    80000d44:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d48:	feb79ae3          	bne	a5,a1,80000d3c <memmove+0x16>

  return dst;
}
    80000d4c:	6422                	ld	s0,8(sp)
    80000d4e:	0141                	addi	sp,sp,16
    80000d50:	8082                	ret
  if(s < d && s + n > d){
    80000d52:	02061693          	slli	a3,a2,0x20
    80000d56:	9281                	srli	a3,a3,0x20
    80000d58:	00d58733          	add	a4,a1,a3
    80000d5c:	fce57be3          	bgeu	a0,a4,80000d32 <memmove+0xc>
    d += n;
    80000d60:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d62:	fff6079b          	addiw	a5,a2,-1
    80000d66:	1782                	slli	a5,a5,0x20
    80000d68:	9381                	srli	a5,a5,0x20
    80000d6a:	fff7c793          	not	a5,a5
    80000d6e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d70:	177d                	addi	a4,a4,-1
    80000d72:	16fd                	addi	a3,a3,-1
    80000d74:	00074603          	lbu	a2,0(a4)
    80000d78:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d7c:	fef71ae3          	bne	a4,a5,80000d70 <memmove+0x4a>
    80000d80:	b7f1                	j	80000d4c <memmove+0x26>

0000000080000d82 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d82:	1141                	addi	sp,sp,-16
    80000d84:	e406                	sd	ra,8(sp)
    80000d86:	e022                	sd	s0,0(sp)
    80000d88:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d8a:	f9dff0ef          	jal	80000d26 <memmove>
}
    80000d8e:	60a2                	ld	ra,8(sp)
    80000d90:	6402                	ld	s0,0(sp)
    80000d92:	0141                	addi	sp,sp,16
    80000d94:	8082                	ret

0000000080000d96 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d96:	1141                	addi	sp,sp,-16
    80000d98:	e422                	sd	s0,8(sp)
    80000d9a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d9c:	ce11                	beqz	a2,80000db8 <strncmp+0x22>
    80000d9e:	00054783          	lbu	a5,0(a0)
    80000da2:	cf89                	beqz	a5,80000dbc <strncmp+0x26>
    80000da4:	0005c703          	lbu	a4,0(a1)
    80000da8:	00f71a63          	bne	a4,a5,80000dbc <strncmp+0x26>
    n--, p++, q++;
    80000dac:	367d                	addiw	a2,a2,-1
    80000dae:	0505                	addi	a0,a0,1
    80000db0:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db2:	f675                	bnez	a2,80000d9e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db4:	4501                	li	a0,0
    80000db6:	a801                	j	80000dc6 <strncmp+0x30>
    80000db8:	4501                	li	a0,0
    80000dba:	a031                	j	80000dc6 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000dbc:	00054503          	lbu	a0,0(a0)
    80000dc0:	0005c783          	lbu	a5,0(a1)
    80000dc4:	9d1d                	subw	a0,a0,a5
}
    80000dc6:	6422                	ld	s0,8(sp)
    80000dc8:	0141                	addi	sp,sp,16
    80000dca:	8082                	ret

0000000080000dcc <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dcc:	1141                	addi	sp,sp,-16
    80000dce:	e422                	sd	s0,8(sp)
    80000dd0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dd2:	87aa                	mv	a5,a0
    80000dd4:	86b2                	mv	a3,a2
    80000dd6:	367d                	addiw	a2,a2,-1
    80000dd8:	02d05563          	blez	a3,80000e02 <strncpy+0x36>
    80000ddc:	0785                	addi	a5,a5,1
    80000dde:	0005c703          	lbu	a4,0(a1)
    80000de2:	fee78fa3          	sb	a4,-1(a5)
    80000de6:	0585                	addi	a1,a1,1
    80000de8:	f775                	bnez	a4,80000dd4 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000dea:	873e                	mv	a4,a5
    80000dec:	9fb5                	addw	a5,a5,a3
    80000dee:	37fd                	addiw	a5,a5,-1
    80000df0:	00c05963          	blez	a2,80000e02 <strncpy+0x36>
    *s++ = 0;
    80000df4:	0705                	addi	a4,a4,1
    80000df6:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000dfa:	40e786bb          	subw	a3,a5,a4
    80000dfe:	fed04be3          	bgtz	a3,80000df4 <strncpy+0x28>
  return os;
}
    80000e02:	6422                	ld	s0,8(sp)
    80000e04:	0141                	addi	sp,sp,16
    80000e06:	8082                	ret

0000000080000e08 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e08:	1141                	addi	sp,sp,-16
    80000e0a:	e422                	sd	s0,8(sp)
    80000e0c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e0e:	02c05363          	blez	a2,80000e34 <safestrcpy+0x2c>
    80000e12:	fff6069b          	addiw	a3,a2,-1
    80000e16:	1682                	slli	a3,a3,0x20
    80000e18:	9281                	srli	a3,a3,0x20
    80000e1a:	96ae                	add	a3,a3,a1
    80000e1c:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e1e:	00d58963          	beq	a1,a3,80000e30 <safestrcpy+0x28>
    80000e22:	0585                	addi	a1,a1,1
    80000e24:	0785                	addi	a5,a5,1
    80000e26:	fff5c703          	lbu	a4,-1(a1)
    80000e2a:	fee78fa3          	sb	a4,-1(a5)
    80000e2e:	fb65                	bnez	a4,80000e1e <safestrcpy+0x16>
    ;
  *s = 0;
    80000e30:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e34:	6422                	ld	s0,8(sp)
    80000e36:	0141                	addi	sp,sp,16
    80000e38:	8082                	ret

0000000080000e3a <strlen>:

int
strlen(const char *s)
{
    80000e3a:	1141                	addi	sp,sp,-16
    80000e3c:	e422                	sd	s0,8(sp)
    80000e3e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e40:	00054783          	lbu	a5,0(a0)
    80000e44:	cf91                	beqz	a5,80000e60 <strlen+0x26>
    80000e46:	0505                	addi	a0,a0,1
    80000e48:	87aa                	mv	a5,a0
    80000e4a:	86be                	mv	a3,a5
    80000e4c:	0785                	addi	a5,a5,1
    80000e4e:	fff7c703          	lbu	a4,-1(a5)
    80000e52:	ff65                	bnez	a4,80000e4a <strlen+0x10>
    80000e54:	40a6853b          	subw	a0,a3,a0
    80000e58:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e5a:	6422                	ld	s0,8(sp)
    80000e5c:	0141                	addi	sp,sp,16
    80000e5e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e60:	4501                	li	a0,0
    80000e62:	bfe5                	j	80000e5a <strlen+0x20>

0000000080000e64 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e64:	1141                	addi	sp,sp,-16
    80000e66:	e406                	sd	ra,8(sp)
    80000e68:	e022                	sd	s0,0(sp)
    80000e6a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e6c:	22d000ef          	jal	80001898 <cpuid>
    userinit();      // first user process
    __sync_synchronize();
    started = 1;

  } else {
    while(started == 0)
    80000e70:	00007717          	auipc	a4,0x7
    80000e74:	aa870713          	addi	a4,a4,-1368 # 80007918 <started>
  if(cpuid() == 0){
    80000e78:	c51d                	beqz	a0,80000ea6 <main+0x42>
    while(started == 0)
    80000e7a:	431c                	lw	a5,0(a4)
    80000e7c:	2781                	sext.w	a5,a5
    80000e7e:	dff5                	beqz	a5,80000e7a <main+0x16>
      ;
    __sync_synchronize();
    80000e80:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e84:	215000ef          	jal	80001898 <cpuid>
    80000e88:	85aa                	mv	a1,a0
    80000e8a:	00006517          	auipc	a0,0x6
    80000e8e:	20e50513          	addi	a0,a0,526 # 80007098 <etext+0x98>
    80000e92:	e30ff0ef          	jal	800004c2 <printf>
    kvminithart();    // turn on paging
    80000e96:	07c000ef          	jal	80000f12 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e9a:	700010ef          	jal	8000259a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e9e:	55a040ef          	jal	800053f8 <plicinithart>
  }

  scheduler();        
    80000ea2:	421000ef          	jal	80001ac2 <scheduler>
    consoleinit();
    80000ea6:	d46ff0ef          	jal	800003ec <consoleinit>
    printfinit();
    80000eaa:	925ff0ef          	jal	800007ce <printfinit>
    printf("\n");
    80000eae:	00006517          	auipc	a0,0x6
    80000eb2:	1ca50513          	addi	a0,a0,458 # 80007078 <etext+0x78>
    80000eb6:	e0cff0ef          	jal	800004c2 <printf>
    printf("xv6 kernel is booting\n");
    80000eba:	00006517          	auipc	a0,0x6
    80000ebe:	1c650513          	addi	a0,a0,454 # 80007080 <etext+0x80>
    80000ec2:	e00ff0ef          	jal	800004c2 <printf>
    printf("\n");
    80000ec6:	00006517          	auipc	a0,0x6
    80000eca:	1b250513          	addi	a0,a0,434 # 80007078 <etext+0x78>
    80000ece:	df4ff0ef          	jal	800004c2 <printf>
    kinit();         // physical page allocator
    80000ed2:	c1fff0ef          	jal	80000af0 <kinit>
    procinit();      // process table
    80000ed6:	0ff000ef          	jal	800017d4 <procinit>
    trapinit();      // trap vectors
    80000eda:	69c010ef          	jal	80002576 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ede:	6bc010ef          	jal	8000259a <trapinithart>
    plicinit();      // set up interrupt controller
    80000ee2:	4fc040ef          	jal	800053de <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000ee6:	512040ef          	jal	800053f8 <plicinithart>
    binit();         // buffer cache
    80000eea:	4b5010ef          	jal	80002b9e <binit>
    iinit();         // inode table
    80000eee:	2a6020ef          	jal	80003194 <iinit>
    fileinit();      // file table
    80000ef2:	052030ef          	jal	80003f44 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000ef6:	5f2040ef          	jal	800054e8 <virtio_disk_init>
    init_priority_control();
    80000efa:	17c010ef          	jal	80002076 <init_priority_control>
    userinit();      // first user process
    80000efe:	318010ef          	jal	80002216 <userinit>
    __sync_synchronize();
    80000f02:	0ff0000f          	fence
    started = 1;
    80000f06:	4785                	li	a5,1
    80000f08:	00007717          	auipc	a4,0x7
    80000f0c:	a0f72823          	sw	a5,-1520(a4) # 80007918 <started>
    80000f10:	bf49                	j	80000ea2 <main+0x3e>

0000000080000f12 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f12:	1141                	addi	sp,sp,-16
    80000f14:	e422                	sd	s0,8(sp)
    80000f16:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f18:	12000073          	sfence.vma
    80000f1c:	12000073          	sfence.vma

  //w_satp(MAKE_SATP(kernel_pagetable));

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f20:	6422                	ld	s0,8(sp)
    80000f22:	0141                	addi	sp,sp,16
    80000f24:	8082                	ret

0000000080000f26 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f26:	7139                	addi	sp,sp,-64
    80000f28:	fc06                	sd	ra,56(sp)
    80000f2a:	f822                	sd	s0,48(sp)
    80000f2c:	f426                	sd	s1,40(sp)
    80000f2e:	f04a                	sd	s2,32(sp)
    80000f30:	ec4e                	sd	s3,24(sp)
    80000f32:	e852                	sd	s4,16(sp)
    80000f34:	e456                	sd	s5,8(sp)
    80000f36:	e05a                	sd	s6,0(sp)
    80000f38:	0080                	addi	s0,sp,64
    80000f3a:	84aa                	mv	s1,a0
    80000f3c:	89ae                	mv	s3,a1
    80000f3e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f40:	57fd                	li	a5,-1
    80000f42:	83e9                	srli	a5,a5,0x1a
    80000f44:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f46:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f48:	02b7fc63          	bgeu	a5,a1,80000f80 <walk+0x5a>
    panic("walk");
    80000f4c:	00006517          	auipc	a0,0x6
    80000f50:	16450513          	addi	a0,a0,356 # 800070b0 <etext+0xb0>
    80000f54:	841ff0ef          	jal	80000794 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f58:	060a8263          	beqz	s5,80000fbc <walk+0x96>
    80000f5c:	bcbff0ef          	jal	80000b26 <kalloc>
    80000f60:	84aa                	mv	s1,a0
    80000f62:	c139                	beqz	a0,80000fa8 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f64:	6605                	lui	a2,0x1
    80000f66:	4581                	li	a1,0
    80000f68:	d63ff0ef          	jal	80000cca <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f6c:	00c4d793          	srli	a5,s1,0xc
    80000f70:	07aa                	slli	a5,a5,0xa
    80000f72:	0017e793          	ori	a5,a5,1
    80000f76:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f7a:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffe3587>
    80000f7c:	036a0063          	beq	s4,s6,80000f9c <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f80:	0149d933          	srl	s2,s3,s4
    80000f84:	1ff97913          	andi	s2,s2,511
    80000f88:	090e                	slli	s2,s2,0x3
    80000f8a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f8c:	00093483          	ld	s1,0(s2)
    80000f90:	0014f793          	andi	a5,s1,1
    80000f94:	d3f1                	beqz	a5,80000f58 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f96:	80a9                	srli	s1,s1,0xa
    80000f98:	04b2                	slli	s1,s1,0xc
    80000f9a:	b7c5                	j	80000f7a <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000f9c:	00c9d513          	srli	a0,s3,0xc
    80000fa0:	1ff57513          	andi	a0,a0,511
    80000fa4:	050e                	slli	a0,a0,0x3
    80000fa6:	9526                	add	a0,a0,s1
}
    80000fa8:	70e2                	ld	ra,56(sp)
    80000faa:	7442                	ld	s0,48(sp)
    80000fac:	74a2                	ld	s1,40(sp)
    80000fae:	7902                	ld	s2,32(sp)
    80000fb0:	69e2                	ld	s3,24(sp)
    80000fb2:	6a42                	ld	s4,16(sp)
    80000fb4:	6aa2                	ld	s5,8(sp)
    80000fb6:	6b02                	ld	s6,0(sp)
    80000fb8:	6121                	addi	sp,sp,64
    80000fba:	8082                	ret
        return 0;
    80000fbc:	4501                	li	a0,0
    80000fbe:	b7ed                	j	80000fa8 <walk+0x82>

0000000080000fc0 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fc0:	57fd                	li	a5,-1
    80000fc2:	83e9                	srli	a5,a5,0x1a
    80000fc4:	00b7f463          	bgeu	a5,a1,80000fcc <walkaddr+0xc>
    return 0;
    80000fc8:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fca:	8082                	ret
{
    80000fcc:	1141                	addi	sp,sp,-16
    80000fce:	e406                	sd	ra,8(sp)
    80000fd0:	e022                	sd	s0,0(sp)
    80000fd2:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fd4:	4601                	li	a2,0
    80000fd6:	f51ff0ef          	jal	80000f26 <walk>
  if(pte == 0)
    80000fda:	c105                	beqz	a0,80000ffa <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000fdc:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000fde:	0117f693          	andi	a3,a5,17
    80000fe2:	4745                	li	a4,17
    return 0;
    80000fe4:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000fe6:	00e68663          	beq	a3,a4,80000ff2 <walkaddr+0x32>
}
    80000fea:	60a2                	ld	ra,8(sp)
    80000fec:	6402                	ld	s0,0(sp)
    80000fee:	0141                	addi	sp,sp,16
    80000ff0:	8082                	ret
  pa = PTE2PA(*pte);
    80000ff2:	83a9                	srli	a5,a5,0xa
    80000ff4:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000ff8:	bfcd                	j	80000fea <walkaddr+0x2a>
    return 0;
    80000ffa:	4501                	li	a0,0
    80000ffc:	b7fd                	j	80000fea <walkaddr+0x2a>

0000000080000ffe <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000ffe:	715d                	addi	sp,sp,-80
    80001000:	e486                	sd	ra,72(sp)
    80001002:	e0a2                	sd	s0,64(sp)
    80001004:	fc26                	sd	s1,56(sp)
    80001006:	f84a                	sd	s2,48(sp)
    80001008:	f44e                	sd	s3,40(sp)
    8000100a:	f052                	sd	s4,32(sp)
    8000100c:	ec56                	sd	s5,24(sp)
    8000100e:	e85a                	sd	s6,16(sp)
    80001010:	e45e                	sd	s7,8(sp)
    80001012:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001014:	03459793          	slli	a5,a1,0x34
    80001018:	e7a9                	bnez	a5,80001062 <mappages+0x64>
    8000101a:	8aaa                	mv	s5,a0
    8000101c:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000101e:	03461793          	slli	a5,a2,0x34
    80001022:	e7b1                	bnez	a5,8000106e <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80001024:	ca39                	beqz	a2,8000107a <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001026:	77fd                	lui	a5,0xfffff
    80001028:	963e                	add	a2,a2,a5
    8000102a:	00b609b3          	add	s3,a2,a1
  a = va;
    8000102e:	892e                	mv	s2,a1
    80001030:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001034:	6b85                	lui	s7,0x1
    80001036:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000103a:	4605                	li	a2,1
    8000103c:	85ca                	mv	a1,s2
    8000103e:	8556                	mv	a0,s5
    80001040:	ee7ff0ef          	jal	80000f26 <walk>
    80001044:	c539                	beqz	a0,80001092 <mappages+0x94>
    if(*pte & PTE_V)
    80001046:	611c                	ld	a5,0(a0)
    80001048:	8b85                	andi	a5,a5,1
    8000104a:	ef95                	bnez	a5,80001086 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000104c:	80b1                	srli	s1,s1,0xc
    8000104e:	04aa                	slli	s1,s1,0xa
    80001050:	0164e4b3          	or	s1,s1,s6
    80001054:	0014e493          	ori	s1,s1,1
    80001058:	e104                	sd	s1,0(a0)
    if(a == last)
    8000105a:	05390863          	beq	s2,s3,800010aa <mappages+0xac>
    a += PGSIZE;
    8000105e:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001060:	bfd9                	j	80001036 <mappages+0x38>
    panic("mappages: va not aligned");
    80001062:	00006517          	auipc	a0,0x6
    80001066:	05650513          	addi	a0,a0,86 # 800070b8 <etext+0xb8>
    8000106a:	f2aff0ef          	jal	80000794 <panic>
    panic("mappages: size not aligned");
    8000106e:	00006517          	auipc	a0,0x6
    80001072:	06a50513          	addi	a0,a0,106 # 800070d8 <etext+0xd8>
    80001076:	f1eff0ef          	jal	80000794 <panic>
    panic("mappages: size");
    8000107a:	00006517          	auipc	a0,0x6
    8000107e:	07e50513          	addi	a0,a0,126 # 800070f8 <etext+0xf8>
    80001082:	f12ff0ef          	jal	80000794 <panic>
      panic("mappages: remap");
    80001086:	00006517          	auipc	a0,0x6
    8000108a:	08250513          	addi	a0,a0,130 # 80007108 <etext+0x108>
    8000108e:	f06ff0ef          	jal	80000794 <panic>
      return -1;
    80001092:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001094:	60a6                	ld	ra,72(sp)
    80001096:	6406                	ld	s0,64(sp)
    80001098:	74e2                	ld	s1,56(sp)
    8000109a:	7942                	ld	s2,48(sp)
    8000109c:	79a2                	ld	s3,40(sp)
    8000109e:	7a02                	ld	s4,32(sp)
    800010a0:	6ae2                	ld	s5,24(sp)
    800010a2:	6b42                	ld	s6,16(sp)
    800010a4:	6ba2                	ld	s7,8(sp)
    800010a6:	6161                	addi	sp,sp,80
    800010a8:	8082                	ret
  return 0;
    800010aa:	4501                	li	a0,0
    800010ac:	b7e5                	j	80001094 <mappages+0x96>

00000000800010ae <kvmmap>:
{
    800010ae:	1141                	addi	sp,sp,-16
    800010b0:	e406                	sd	ra,8(sp)
    800010b2:	e022                	sd	s0,0(sp)
    800010b4:	0800                	addi	s0,sp,16
    800010b6:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010b8:	86b2                	mv	a3,a2
    800010ba:	863e                	mv	a2,a5
    800010bc:	f43ff0ef          	jal	80000ffe <mappages>
    800010c0:	e509                	bnez	a0,800010ca <kvmmap+0x1c>
}
    800010c2:	60a2                	ld	ra,8(sp)
    800010c4:	6402                	ld	s0,0(sp)
    800010c6:	0141                	addi	sp,sp,16
    800010c8:	8082                	ret
    panic("kvmmap");
    800010ca:	00006517          	auipc	a0,0x6
    800010ce:	04e50513          	addi	a0,a0,78 # 80007118 <etext+0x118>
    800010d2:	ec2ff0ef          	jal	80000794 <panic>

00000000800010d6 <kvmmake>:
{
    800010d6:	1101                	addi	sp,sp,-32
    800010d8:	ec06                	sd	ra,24(sp)
    800010da:	e822                	sd	s0,16(sp)
    800010dc:	e426                	sd	s1,8(sp)
    800010de:	e04a                	sd	s2,0(sp)
    800010e0:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010e2:	a45ff0ef          	jal	80000b26 <kalloc>
    800010e6:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010e8:	6605                	lui	a2,0x1
    800010ea:	4581                	li	a1,0
    800010ec:	bdfff0ef          	jal	80000cca <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800010f0:	4719                	li	a4,6
    800010f2:	6685                	lui	a3,0x1
    800010f4:	10000637          	lui	a2,0x10000
    800010f8:	100005b7          	lui	a1,0x10000
    800010fc:	8526                	mv	a0,s1
    800010fe:	fb1ff0ef          	jal	800010ae <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001102:	4719                	li	a4,6
    80001104:	6685                	lui	a3,0x1
    80001106:	10001637          	lui	a2,0x10001
    8000110a:	100015b7          	lui	a1,0x10001
    8000110e:	8526                	mv	a0,s1
    80001110:	f9fff0ef          	jal	800010ae <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001114:	4719                	li	a4,6
    80001116:	040006b7          	lui	a3,0x4000
    8000111a:	0c000637          	lui	a2,0xc000
    8000111e:	0c0005b7          	lui	a1,0xc000
    80001122:	8526                	mv	a0,s1
    80001124:	f8bff0ef          	jal	800010ae <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001128:	00006917          	auipc	s2,0x6
    8000112c:	ed890913          	addi	s2,s2,-296 # 80007000 <etext>
    80001130:	4729                	li	a4,10
    80001132:	80006697          	auipc	a3,0x80006
    80001136:	ece68693          	addi	a3,a3,-306 # 7000 <_entry-0x7fff9000>
    8000113a:	4605                	li	a2,1
    8000113c:	067e                	slli	a2,a2,0x1f
    8000113e:	85b2                	mv	a1,a2
    80001140:	8526                	mv	a0,s1
    80001142:	f6dff0ef          	jal	800010ae <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001146:	4695                	li	a3,5
    80001148:	06f6                	slli	a3,a3,0x1d
    8000114a:	4719                	li	a4,6
    8000114c:	412686b3          	sub	a3,a3,s2
    80001150:	864a                	mv	a2,s2
    80001152:	85ca                	mv	a1,s2
    80001154:	8526                	mv	a0,s1
    80001156:	f59ff0ef          	jal	800010ae <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000115a:	4729                	li	a4,10
    8000115c:	6685                	lui	a3,0x1
    8000115e:	00005617          	auipc	a2,0x5
    80001162:	ea260613          	addi	a2,a2,-350 # 80006000 <_trampoline>
    80001166:	000a05b7          	lui	a1,0xa0
    8000116a:	15fd                	addi	a1,a1,-1 # 9ffff <_entry-0x7ff60001>
    8000116c:	05b2                	slli	a1,a1,0xc
    8000116e:	8526                	mv	a0,s1
    80001170:	f3fff0ef          	jal	800010ae <kvmmap>
  proc_mapstacks(kpgtbl);
    80001174:	8526                	mv	a0,s1
    80001176:	5c6000ef          	jal	8000173c <proc_mapstacks>
}
    8000117a:	8526                	mv	a0,s1
    8000117c:	60e2                	ld	ra,24(sp)
    8000117e:	6442                	ld	s0,16(sp)
    80001180:	64a2                	ld	s1,8(sp)
    80001182:	6902                	ld	s2,0(sp)
    80001184:	6105                	addi	sp,sp,32
    80001186:	8082                	ret

0000000080001188 <kvminit>:
{
    80001188:	1141                	addi	sp,sp,-16
    8000118a:	e406                	sd	ra,8(sp)
    8000118c:	e022                	sd	s0,0(sp)
    8000118e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001190:	f47ff0ef          	jal	800010d6 <kvmmake>
    80001194:	00006797          	auipc	a5,0x6
    80001198:	78a7b623          	sd	a0,1932(a5) # 80007920 <kernel_pagetable>
}
    8000119c:	60a2                	ld	ra,8(sp)
    8000119e:	6402                	ld	s0,0(sp)
    800011a0:	0141                	addi	sp,sp,16
    800011a2:	8082                	ret

00000000800011a4 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011a4:	715d                	addi	sp,sp,-80
    800011a6:	e486                	sd	ra,72(sp)
    800011a8:	e0a2                	sd	s0,64(sp)
    800011aa:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011ac:	03459793          	slli	a5,a1,0x34
    800011b0:	e39d                	bnez	a5,800011d6 <uvmunmap+0x32>
    800011b2:	f84a                	sd	s2,48(sp)
    800011b4:	f44e                	sd	s3,40(sp)
    800011b6:	f052                	sd	s4,32(sp)
    800011b8:	ec56                	sd	s5,24(sp)
    800011ba:	e85a                	sd	s6,16(sp)
    800011bc:	e45e                	sd	s7,8(sp)
    800011be:	8a2a                	mv	s4,a0
    800011c0:	892e                	mv	s2,a1
    800011c2:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011c4:	0632                	slli	a2,a2,0xc
    800011c6:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800011ca:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011cc:	6b05                	lui	s6,0x1
    800011ce:	0735ff63          	bgeu	a1,s3,8000124c <uvmunmap+0xa8>
    800011d2:	fc26                	sd	s1,56(sp)
    800011d4:	a0a9                	j	8000121e <uvmunmap+0x7a>
    800011d6:	fc26                	sd	s1,56(sp)
    800011d8:	f84a                	sd	s2,48(sp)
    800011da:	f44e                	sd	s3,40(sp)
    800011dc:	f052                	sd	s4,32(sp)
    800011de:	ec56                	sd	s5,24(sp)
    800011e0:	e85a                	sd	s6,16(sp)
    800011e2:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800011e4:	00006517          	auipc	a0,0x6
    800011e8:	f3c50513          	addi	a0,a0,-196 # 80007120 <etext+0x120>
    800011ec:	da8ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: walk");
    800011f0:	00006517          	auipc	a0,0x6
    800011f4:	f4850513          	addi	a0,a0,-184 # 80007138 <etext+0x138>
    800011f8:	d9cff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not mapped");
    800011fc:	00006517          	auipc	a0,0x6
    80001200:	f4c50513          	addi	a0,a0,-180 # 80007148 <etext+0x148>
    80001204:	d90ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not a leaf");
    80001208:	00006517          	auipc	a0,0x6
    8000120c:	f5850513          	addi	a0,a0,-168 # 80007160 <etext+0x160>
    80001210:	d84ff0ef          	jal	80000794 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001214:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001218:	995a                	add	s2,s2,s6
    8000121a:	03397863          	bgeu	s2,s3,8000124a <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000121e:	4601                	li	a2,0
    80001220:	85ca                	mv	a1,s2
    80001222:	8552                	mv	a0,s4
    80001224:	d03ff0ef          	jal	80000f26 <walk>
    80001228:	84aa                	mv	s1,a0
    8000122a:	d179                	beqz	a0,800011f0 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    8000122c:	6108                	ld	a0,0(a0)
    8000122e:	00157793          	andi	a5,a0,1
    80001232:	d7e9                	beqz	a5,800011fc <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001234:	3ff57793          	andi	a5,a0,1023
    80001238:	fd7788e3          	beq	a5,s7,80001208 <uvmunmap+0x64>
    if(do_free){
    8000123c:	fc0a8ce3          	beqz	s5,80001214 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001240:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001242:	0532                	slli	a0,a0,0xc
    80001244:	ffeff0ef          	jal	80000a42 <kfree>
    80001248:	b7f1                	j	80001214 <uvmunmap+0x70>
    8000124a:	74e2                	ld	s1,56(sp)
    8000124c:	7942                	ld	s2,48(sp)
    8000124e:	79a2                	ld	s3,40(sp)
    80001250:	7a02                	ld	s4,32(sp)
    80001252:	6ae2                	ld	s5,24(sp)
    80001254:	6b42                	ld	s6,16(sp)
    80001256:	6ba2                	ld	s7,8(sp)
  }
}
    80001258:	60a6                	ld	ra,72(sp)
    8000125a:	6406                	ld	s0,64(sp)
    8000125c:	6161                	addi	sp,sp,80
    8000125e:	8082                	ret

0000000080001260 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001260:	1101                	addi	sp,sp,-32
    80001262:	ec06                	sd	ra,24(sp)
    80001264:	e822                	sd	s0,16(sp)
    80001266:	e426                	sd	s1,8(sp)
    80001268:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000126a:	8bdff0ef          	jal	80000b26 <kalloc>
    8000126e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001270:	c509                	beqz	a0,8000127a <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001272:	6605                	lui	a2,0x1
    80001274:	4581                	li	a1,0
    80001276:	a55ff0ef          	jal	80000cca <memset>
  return pagetable;
}
    8000127a:	8526                	mv	a0,s1
    8000127c:	60e2                	ld	ra,24(sp)
    8000127e:	6442                	ld	s0,16(sp)
    80001280:	64a2                	ld	s1,8(sp)
    80001282:	6105                	addi	sp,sp,32
    80001284:	8082                	ret

0000000080001286 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001286:	7179                	addi	sp,sp,-48
    80001288:	f406                	sd	ra,40(sp)
    8000128a:	f022                	sd	s0,32(sp)
    8000128c:	ec26                	sd	s1,24(sp)
    8000128e:	e84a                	sd	s2,16(sp)
    80001290:	e44e                	sd	s3,8(sp)
    80001292:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001294:	6785                	lui	a5,0x1
    80001296:	02f67763          	bgeu	a2,a5,800012c4 <uvmfirst+0x3e>
    8000129a:	892e                	mv	s2,a1
    8000129c:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000129e:	889ff0ef          	jal	80000b26 <kalloc>
    800012a2:	89aa                	mv	s3,a0
  memset(mem, 0, PGSIZE);
    800012a4:	6605                	lui	a2,0x1
    800012a6:	4581                	li	a1,0
    800012a8:	a23ff0ef          	jal	80000cca <memset>
  //mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
  memmove(mem, src, sz);
    800012ac:	8626                	mv	a2,s1
    800012ae:	85ca                	mv	a1,s2
    800012b0:	854e                	mv	a0,s3
    800012b2:	a75ff0ef          	jal	80000d26 <memmove>
}
    800012b6:	70a2                	ld	ra,40(sp)
    800012b8:	7402                	ld	s0,32(sp)
    800012ba:	64e2                	ld	s1,24(sp)
    800012bc:	6942                	ld	s2,16(sp)
    800012be:	69a2                	ld	s3,8(sp)
    800012c0:	6145                	addi	sp,sp,48
    800012c2:	8082                	ret
    panic("uvmfirst: more than a page");
    800012c4:	00006517          	auipc	a0,0x6
    800012c8:	eb450513          	addi	a0,a0,-332 # 80007178 <etext+0x178>
    800012cc:	cc8ff0ef          	jal	80000794 <panic>

00000000800012d0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800012d0:	1101                	addi	sp,sp,-32
    800012d2:	ec06                	sd	ra,24(sp)
    800012d4:	e822                	sd	s0,16(sp)
    800012d6:	e426                	sd	s1,8(sp)
    800012d8:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800012da:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800012dc:	00b67d63          	bgeu	a2,a1,800012f6 <uvmdealloc+0x26>
    800012e0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800012e2:	6785                	lui	a5,0x1
    800012e4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012e6:	00f60733          	add	a4,a2,a5
    800012ea:	76fd                	lui	a3,0xfffff
    800012ec:	8f75                	and	a4,a4,a3
    800012ee:	97ae                	add	a5,a5,a1
    800012f0:	8ff5                	and	a5,a5,a3
    800012f2:	00f76863          	bltu	a4,a5,80001302 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800012f6:	8526                	mv	a0,s1
    800012f8:	60e2                	ld	ra,24(sp)
    800012fa:	6442                	ld	s0,16(sp)
    800012fc:	64a2                	ld	s1,8(sp)
    800012fe:	6105                	addi	sp,sp,32
    80001300:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001302:	8f99                	sub	a5,a5,a4
    80001304:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001306:	4685                	li	a3,1
    80001308:	0007861b          	sext.w	a2,a5
    8000130c:	85ba                	mv	a1,a4
    8000130e:	e97ff0ef          	jal	800011a4 <uvmunmap>
    80001312:	b7d5                	j	800012f6 <uvmdealloc+0x26>

0000000080001314 <uvmalloc>:
  if(newsz < oldsz)
    80001314:	08b66f63          	bltu	a2,a1,800013b2 <uvmalloc+0x9e>
{
    80001318:	7139                	addi	sp,sp,-64
    8000131a:	fc06                	sd	ra,56(sp)
    8000131c:	f822                	sd	s0,48(sp)
    8000131e:	ec4e                	sd	s3,24(sp)
    80001320:	e852                	sd	s4,16(sp)
    80001322:	e456                	sd	s5,8(sp)
    80001324:	0080                	addi	s0,sp,64
    80001326:	8aaa                	mv	s5,a0
    80001328:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000132a:	6785                	lui	a5,0x1
    8000132c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000132e:	95be                	add	a1,a1,a5
    80001330:	77fd                	lui	a5,0xfffff
    80001332:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001336:	08c9f063          	bgeu	s3,a2,800013b6 <uvmalloc+0xa2>
    8000133a:	f426                	sd	s1,40(sp)
    8000133c:	f04a                	sd	s2,32(sp)
    8000133e:	e05a                	sd	s6,0(sp)
    80001340:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001342:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001346:	fe0ff0ef          	jal	80000b26 <kalloc>
    8000134a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000134c:	c515                	beqz	a0,80001378 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000134e:	6605                	lui	a2,0x1
    80001350:	4581                	li	a1,0
    80001352:	979ff0ef          	jal	80000cca <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001356:	875a                	mv	a4,s6
    80001358:	86a6                	mv	a3,s1
    8000135a:	6605                	lui	a2,0x1
    8000135c:	85ca                	mv	a1,s2
    8000135e:	8556                	mv	a0,s5
    80001360:	c9fff0ef          	jal	80000ffe <mappages>
    80001364:	e915                	bnez	a0,80001398 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001366:	6785                	lui	a5,0x1
    80001368:	993e                	add	s2,s2,a5
    8000136a:	fd496ee3          	bltu	s2,s4,80001346 <uvmalloc+0x32>
  return newsz;
    8000136e:	8552                	mv	a0,s4
    80001370:	74a2                	ld	s1,40(sp)
    80001372:	7902                	ld	s2,32(sp)
    80001374:	6b02                	ld	s6,0(sp)
    80001376:	a811                	j	8000138a <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    80001378:	864e                	mv	a2,s3
    8000137a:	85ca                	mv	a1,s2
    8000137c:	8556                	mv	a0,s5
    8000137e:	f53ff0ef          	jal	800012d0 <uvmdealloc>
      return 0;
    80001382:	4501                	li	a0,0
    80001384:	74a2                	ld	s1,40(sp)
    80001386:	7902                	ld	s2,32(sp)
    80001388:	6b02                	ld	s6,0(sp)
}
    8000138a:	70e2                	ld	ra,56(sp)
    8000138c:	7442                	ld	s0,48(sp)
    8000138e:	69e2                	ld	s3,24(sp)
    80001390:	6a42                	ld	s4,16(sp)
    80001392:	6aa2                	ld	s5,8(sp)
    80001394:	6121                	addi	sp,sp,64
    80001396:	8082                	ret
      kfree(mem);
    80001398:	8526                	mv	a0,s1
    8000139a:	ea8ff0ef          	jal	80000a42 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000139e:	864e                	mv	a2,s3
    800013a0:	85ca                	mv	a1,s2
    800013a2:	8556                	mv	a0,s5
    800013a4:	f2dff0ef          	jal	800012d0 <uvmdealloc>
      return 0;
    800013a8:	4501                	li	a0,0
    800013aa:	74a2                	ld	s1,40(sp)
    800013ac:	7902                	ld	s2,32(sp)
    800013ae:	6b02                	ld	s6,0(sp)
    800013b0:	bfe9                	j	8000138a <uvmalloc+0x76>
    return oldsz;
    800013b2:	852e                	mv	a0,a1
}
    800013b4:	8082                	ret
  return newsz;
    800013b6:	8532                	mv	a0,a2
    800013b8:	bfc9                	j	8000138a <uvmalloc+0x76>

00000000800013ba <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800013ba:	7179                	addi	sp,sp,-48
    800013bc:	f406                	sd	ra,40(sp)
    800013be:	f022                	sd	s0,32(sp)
    800013c0:	ec26                	sd	s1,24(sp)
    800013c2:	e84a                	sd	s2,16(sp)
    800013c4:	e44e                	sd	s3,8(sp)
    800013c6:	e052                	sd	s4,0(sp)
    800013c8:	1800                	addi	s0,sp,48
    800013ca:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800013cc:	84aa                	mv	s1,a0
    800013ce:	6905                	lui	s2,0x1
    800013d0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013d2:	4985                	li	s3,1
    800013d4:	a819                	j	800013ea <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800013d6:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800013d8:	00c79513          	slli	a0,a5,0xc
    800013dc:	fdfff0ef          	jal	800013ba <freewalk>
      pagetable[i] = 0;
    800013e0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800013e4:	04a1                	addi	s1,s1,8
    800013e6:	01248f63          	beq	s1,s2,80001404 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800013ea:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013ec:	00f7f713          	andi	a4,a5,15
    800013f0:	ff3703e3          	beq	a4,s3,800013d6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800013f4:	8b85                	andi	a5,a5,1
    800013f6:	d7fd                	beqz	a5,800013e4 <freewalk+0x2a>
      panic("freewalk: leaf");
    800013f8:	00006517          	auipc	a0,0x6
    800013fc:	da050513          	addi	a0,a0,-608 # 80007198 <etext+0x198>
    80001400:	b94ff0ef          	jal	80000794 <panic>
    }
  }
  kfree((void*)pagetable);
    80001404:	8552                	mv	a0,s4
    80001406:	e3cff0ef          	jal	80000a42 <kfree>
}
    8000140a:	70a2                	ld	ra,40(sp)
    8000140c:	7402                	ld	s0,32(sp)
    8000140e:	64e2                	ld	s1,24(sp)
    80001410:	6942                	ld	s2,16(sp)
    80001412:	69a2                	ld	s3,8(sp)
    80001414:	6a02                	ld	s4,0(sp)
    80001416:	6145                	addi	sp,sp,48
    80001418:	8082                	ret

000000008000141a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000141a:	1101                	addi	sp,sp,-32
    8000141c:	ec06                	sd	ra,24(sp)
    8000141e:	e822                	sd	s0,16(sp)
    80001420:	e426                	sd	s1,8(sp)
    80001422:	1000                	addi	s0,sp,32
    80001424:	84aa                	mv	s1,a0
  if(sz > 0)
    80001426:	e989                	bnez	a1,80001438 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001428:	8526                	mv	a0,s1
    8000142a:	f91ff0ef          	jal	800013ba <freewalk>
}
    8000142e:	60e2                	ld	ra,24(sp)
    80001430:	6442                	ld	s0,16(sp)
    80001432:	64a2                	ld	s1,8(sp)
    80001434:	6105                	addi	sp,sp,32
    80001436:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001438:	6785                	lui	a5,0x1
    8000143a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000143c:	95be                	add	a1,a1,a5
    8000143e:	4685                	li	a3,1
    80001440:	00c5d613          	srli	a2,a1,0xc
    80001444:	4581                	li	a1,0
    80001446:	d5fff0ef          	jal	800011a4 <uvmunmap>
    8000144a:	bff9                	j	80001428 <uvmfree+0xe>

000000008000144c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000144c:	c65d                	beqz	a2,800014fa <uvmcopy+0xae>
{
    8000144e:	715d                	addi	sp,sp,-80
    80001450:	e486                	sd	ra,72(sp)
    80001452:	e0a2                	sd	s0,64(sp)
    80001454:	fc26                	sd	s1,56(sp)
    80001456:	f84a                	sd	s2,48(sp)
    80001458:	f44e                	sd	s3,40(sp)
    8000145a:	f052                	sd	s4,32(sp)
    8000145c:	ec56                	sd	s5,24(sp)
    8000145e:	e85a                	sd	s6,16(sp)
    80001460:	e45e                	sd	s7,8(sp)
    80001462:	0880                	addi	s0,sp,80
    80001464:	8b2a                	mv	s6,a0
    80001466:	8aae                	mv	s5,a1
    80001468:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000146a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000146c:	4601                	li	a2,0
    8000146e:	85ce                	mv	a1,s3
    80001470:	855a                	mv	a0,s6
    80001472:	ab5ff0ef          	jal	80000f26 <walk>
    80001476:	c121                	beqz	a0,800014b6 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001478:	6118                	ld	a4,0(a0)
    8000147a:	00177793          	andi	a5,a4,1
    8000147e:	c3b1                	beqz	a5,800014c2 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001480:	00a75593          	srli	a1,a4,0xa
    80001484:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001488:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000148c:	e9aff0ef          	jal	80000b26 <kalloc>
    80001490:	892a                	mv	s2,a0
    80001492:	c129                	beqz	a0,800014d4 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001494:	6605                	lui	a2,0x1
    80001496:	85de                	mv	a1,s7
    80001498:	88fff0ef          	jal	80000d26 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000149c:	8726                	mv	a4,s1
    8000149e:	86ca                	mv	a3,s2
    800014a0:	6605                	lui	a2,0x1
    800014a2:	85ce                	mv	a1,s3
    800014a4:	8556                	mv	a0,s5
    800014a6:	b59ff0ef          	jal	80000ffe <mappages>
    800014aa:	e115                	bnez	a0,800014ce <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    800014ac:	6785                	lui	a5,0x1
    800014ae:	99be                	add	s3,s3,a5
    800014b0:	fb49eee3          	bltu	s3,s4,8000146c <uvmcopy+0x20>
    800014b4:	a805                	j	800014e4 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    800014b6:	00006517          	auipc	a0,0x6
    800014ba:	cf250513          	addi	a0,a0,-782 # 800071a8 <etext+0x1a8>
    800014be:	ad6ff0ef          	jal	80000794 <panic>
      panic("uvmcopy: page not present");
    800014c2:	00006517          	auipc	a0,0x6
    800014c6:	d0650513          	addi	a0,a0,-762 # 800071c8 <etext+0x1c8>
    800014ca:	acaff0ef          	jal	80000794 <panic>
      kfree(mem);
    800014ce:	854a                	mv	a0,s2
    800014d0:	d72ff0ef          	jal	80000a42 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800014d4:	4685                	li	a3,1
    800014d6:	00c9d613          	srli	a2,s3,0xc
    800014da:	4581                	li	a1,0
    800014dc:	8556                	mv	a0,s5
    800014de:	cc7ff0ef          	jal	800011a4 <uvmunmap>
  return -1;
    800014e2:	557d                	li	a0,-1
}
    800014e4:	60a6                	ld	ra,72(sp)
    800014e6:	6406                	ld	s0,64(sp)
    800014e8:	74e2                	ld	s1,56(sp)
    800014ea:	7942                	ld	s2,48(sp)
    800014ec:	79a2                	ld	s3,40(sp)
    800014ee:	7a02                	ld	s4,32(sp)
    800014f0:	6ae2                	ld	s5,24(sp)
    800014f2:	6b42                	ld	s6,16(sp)
    800014f4:	6ba2                	ld	s7,8(sp)
    800014f6:	6161                	addi	sp,sp,80
    800014f8:	8082                	ret
  return 0;
    800014fa:	4501                	li	a0,0
}
    800014fc:	8082                	ret

00000000800014fe <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800014fe:	1141                	addi	sp,sp,-16
    80001500:	e406                	sd	ra,8(sp)
    80001502:	e022                	sd	s0,0(sp)
    80001504:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001506:	4601                	li	a2,0
    80001508:	a1fff0ef          	jal	80000f26 <walk>
  if(pte == 0)
    8000150c:	c901                	beqz	a0,8000151c <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000150e:	611c                	ld	a5,0(a0)
    80001510:	9bbd                	andi	a5,a5,-17
    80001512:	e11c                	sd	a5,0(a0)
}
    80001514:	60a2                	ld	ra,8(sp)
    80001516:	6402                	ld	s0,0(sp)
    80001518:	0141                	addi	sp,sp,16
    8000151a:	8082                	ret
    panic("uvmclear");
    8000151c:	00006517          	auipc	a0,0x6
    80001520:	ccc50513          	addi	a0,a0,-820 # 800071e8 <etext+0x1e8>
    80001524:	a70ff0ef          	jal	80000794 <panic>

0000000080001528 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001528:	cad1                	beqz	a3,800015bc <copyout+0x94>
{
    8000152a:	711d                	addi	sp,sp,-96
    8000152c:	ec86                	sd	ra,88(sp)
    8000152e:	e8a2                	sd	s0,80(sp)
    80001530:	e4a6                	sd	s1,72(sp)
    80001532:	fc4e                	sd	s3,56(sp)
    80001534:	f456                	sd	s5,40(sp)
    80001536:	f05a                	sd	s6,32(sp)
    80001538:	ec5e                	sd	s7,24(sp)
    8000153a:	1080                	addi	s0,sp,96
    8000153c:	8baa                	mv	s7,a0
    8000153e:	8aae                	mv	s5,a1
    80001540:	8b32                	mv	s6,a2
    80001542:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001544:	74fd                	lui	s1,0xfffff
    80001546:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001548:	57fd                	li	a5,-1
    8000154a:	83e9                	srli	a5,a5,0x1a
    8000154c:	0697ea63          	bltu	a5,s1,800015c0 <copyout+0x98>
    80001550:	e0ca                	sd	s2,64(sp)
    80001552:	f852                	sd	s4,48(sp)
    80001554:	e862                	sd	s8,16(sp)
    80001556:	e466                	sd	s9,8(sp)
    80001558:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    8000155a:	4cd5                	li	s9,21
    8000155c:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    8000155e:	8c3e                	mv	s8,a5
    80001560:	a025                	j	80001588 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80001562:	83a9                	srli	a5,a5,0xa
    80001564:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001566:	409a8533          	sub	a0,s5,s1
    8000156a:	0009061b          	sext.w	a2,s2
    8000156e:	85da                	mv	a1,s6
    80001570:	953e                	add	a0,a0,a5
    80001572:	fb4ff0ef          	jal	80000d26 <memmove>

    len -= n;
    80001576:	412989b3          	sub	s3,s3,s2
    src += n;
    8000157a:	9b4a                	add	s6,s6,s2
  while(len > 0){
    8000157c:	02098963          	beqz	s3,800015ae <copyout+0x86>
    if(va0 >= MAXVA)
    80001580:	054c6263          	bltu	s8,s4,800015c4 <copyout+0x9c>
    80001584:	84d2                	mv	s1,s4
    80001586:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80001588:	4601                	li	a2,0
    8000158a:	85a6                	mv	a1,s1
    8000158c:	855e                	mv	a0,s7
    8000158e:	999ff0ef          	jal	80000f26 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001592:	c121                	beqz	a0,800015d2 <copyout+0xaa>
    80001594:	611c                	ld	a5,0(a0)
    80001596:	0157f713          	andi	a4,a5,21
    8000159a:	05971b63          	bne	a4,s9,800015f0 <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    8000159e:	01a48a33          	add	s4,s1,s10
    800015a2:	415a0933          	sub	s2,s4,s5
    if(n > len)
    800015a6:	fb29fee3          	bgeu	s3,s2,80001562 <copyout+0x3a>
    800015aa:	894e                	mv	s2,s3
    800015ac:	bf5d                	j	80001562 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    800015ae:	4501                	li	a0,0
    800015b0:	6906                	ld	s2,64(sp)
    800015b2:	7a42                	ld	s4,48(sp)
    800015b4:	6c42                	ld	s8,16(sp)
    800015b6:	6ca2                	ld	s9,8(sp)
    800015b8:	6d02                	ld	s10,0(sp)
    800015ba:	a015                	j	800015de <copyout+0xb6>
    800015bc:	4501                	li	a0,0
}
    800015be:	8082                	ret
      return -1;
    800015c0:	557d                	li	a0,-1
    800015c2:	a831                	j	800015de <copyout+0xb6>
    800015c4:	557d                	li	a0,-1
    800015c6:	6906                	ld	s2,64(sp)
    800015c8:	7a42                	ld	s4,48(sp)
    800015ca:	6c42                	ld	s8,16(sp)
    800015cc:	6ca2                	ld	s9,8(sp)
    800015ce:	6d02                	ld	s10,0(sp)
    800015d0:	a039                	j	800015de <copyout+0xb6>
      return -1;
    800015d2:	557d                	li	a0,-1
    800015d4:	6906                	ld	s2,64(sp)
    800015d6:	7a42                	ld	s4,48(sp)
    800015d8:	6c42                	ld	s8,16(sp)
    800015da:	6ca2                	ld	s9,8(sp)
    800015dc:	6d02                	ld	s10,0(sp)
}
    800015de:	60e6                	ld	ra,88(sp)
    800015e0:	6446                	ld	s0,80(sp)
    800015e2:	64a6                	ld	s1,72(sp)
    800015e4:	79e2                	ld	s3,56(sp)
    800015e6:	7aa2                	ld	s5,40(sp)
    800015e8:	7b02                	ld	s6,32(sp)
    800015ea:	6be2                	ld	s7,24(sp)
    800015ec:	6125                	addi	sp,sp,96
    800015ee:	8082                	ret
      return -1;
    800015f0:	557d                	li	a0,-1
    800015f2:	6906                	ld	s2,64(sp)
    800015f4:	7a42                	ld	s4,48(sp)
    800015f6:	6c42                	ld	s8,16(sp)
    800015f8:	6ca2                	ld	s9,8(sp)
    800015fa:	6d02                	ld	s10,0(sp)
    800015fc:	b7cd                	j	800015de <copyout+0xb6>

00000000800015fe <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800015fe:	c6a5                	beqz	a3,80001666 <copyin+0x68>
{
    80001600:	715d                	addi	sp,sp,-80
    80001602:	e486                	sd	ra,72(sp)
    80001604:	e0a2                	sd	s0,64(sp)
    80001606:	fc26                	sd	s1,56(sp)
    80001608:	f84a                	sd	s2,48(sp)
    8000160a:	f44e                	sd	s3,40(sp)
    8000160c:	f052                	sd	s4,32(sp)
    8000160e:	ec56                	sd	s5,24(sp)
    80001610:	e85a                	sd	s6,16(sp)
    80001612:	e45e                	sd	s7,8(sp)
    80001614:	e062                	sd	s8,0(sp)
    80001616:	0880                	addi	s0,sp,80
    80001618:	8b2a                	mv	s6,a0
    8000161a:	8a2e                	mv	s4,a1
    8000161c:	8c32                	mv	s8,a2
    8000161e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001620:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001622:	6a85                	lui	s5,0x1
    80001624:	a00d                	j	80001646 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001626:	018505b3          	add	a1,a0,s8
    8000162a:	0004861b          	sext.w	a2,s1
    8000162e:	412585b3          	sub	a1,a1,s2
    80001632:	8552                	mv	a0,s4
    80001634:	ef2ff0ef          	jal	80000d26 <memmove>

    len -= n;
    80001638:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000163c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000163e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001642:	02098063          	beqz	s3,80001662 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80001646:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000164a:	85ca                	mv	a1,s2
    8000164c:	855a                	mv	a0,s6
    8000164e:	973ff0ef          	jal	80000fc0 <walkaddr>
    if(pa0 == 0)
    80001652:	cd01                	beqz	a0,8000166a <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80001654:	418904b3          	sub	s1,s2,s8
    80001658:	94d6                	add	s1,s1,s5
    if(n > len)
    8000165a:	fc99f6e3          	bgeu	s3,s1,80001626 <copyin+0x28>
    8000165e:	84ce                	mv	s1,s3
    80001660:	b7d9                	j	80001626 <copyin+0x28>
  }
  return 0;
    80001662:	4501                	li	a0,0
    80001664:	a021                	j	8000166c <copyin+0x6e>
    80001666:	4501                	li	a0,0
}
    80001668:	8082                	ret
      return -1;
    8000166a:	557d                	li	a0,-1
}
    8000166c:	60a6                	ld	ra,72(sp)
    8000166e:	6406                	ld	s0,64(sp)
    80001670:	74e2                	ld	s1,56(sp)
    80001672:	7942                	ld	s2,48(sp)
    80001674:	79a2                	ld	s3,40(sp)
    80001676:	7a02                	ld	s4,32(sp)
    80001678:	6ae2                	ld	s5,24(sp)
    8000167a:	6b42                	ld	s6,16(sp)
    8000167c:	6ba2                	ld	s7,8(sp)
    8000167e:	6c02                	ld	s8,0(sp)
    80001680:	6161                	addi	sp,sp,80
    80001682:	8082                	ret

0000000080001684 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001684:	c6dd                	beqz	a3,80001732 <copyinstr+0xae>
{
    80001686:	715d                	addi	sp,sp,-80
    80001688:	e486                	sd	ra,72(sp)
    8000168a:	e0a2                	sd	s0,64(sp)
    8000168c:	fc26                	sd	s1,56(sp)
    8000168e:	f84a                	sd	s2,48(sp)
    80001690:	f44e                	sd	s3,40(sp)
    80001692:	f052                	sd	s4,32(sp)
    80001694:	ec56                	sd	s5,24(sp)
    80001696:	e85a                	sd	s6,16(sp)
    80001698:	e45e                	sd	s7,8(sp)
    8000169a:	0880                	addi	s0,sp,80
    8000169c:	8a2a                	mv	s4,a0
    8000169e:	8b2e                	mv	s6,a1
    800016a0:	8bb2                	mv	s7,a2
    800016a2:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800016a4:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016a6:	6985                	lui	s3,0x1
    800016a8:	a825                	j	800016e0 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016aa:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016ae:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016b0:	37fd                	addiw	a5,a5,-1
    800016b2:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016b6:	60a6                	ld	ra,72(sp)
    800016b8:	6406                	ld	s0,64(sp)
    800016ba:	74e2                	ld	s1,56(sp)
    800016bc:	7942                	ld	s2,48(sp)
    800016be:	79a2                	ld	s3,40(sp)
    800016c0:	7a02                	ld	s4,32(sp)
    800016c2:	6ae2                	ld	s5,24(sp)
    800016c4:	6b42                	ld	s6,16(sp)
    800016c6:	6ba2                	ld	s7,8(sp)
    800016c8:	6161                	addi	sp,sp,80
    800016ca:	8082                	ret
    800016cc:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    800016d0:	9742                	add	a4,a4,a6
      --max;
    800016d2:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    800016d6:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    800016da:	04e58463          	beq	a1,a4,80001722 <copyinstr+0x9e>
{
    800016de:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    800016e0:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800016e4:	85a6                	mv	a1,s1
    800016e6:	8552                	mv	a0,s4
    800016e8:	8d9ff0ef          	jal	80000fc0 <walkaddr>
    if(pa0 == 0)
    800016ec:	cd0d                	beqz	a0,80001726 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800016ee:	417486b3          	sub	a3,s1,s7
    800016f2:	96ce                	add	a3,a3,s3
    if(n > max)
    800016f4:	00d97363          	bgeu	s2,a3,800016fa <copyinstr+0x76>
    800016f8:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    800016fa:	955e                	add	a0,a0,s7
    800016fc:	8d05                	sub	a0,a0,s1
    while(n > 0){
    800016fe:	c695                	beqz	a3,8000172a <copyinstr+0xa6>
    80001700:	87da                	mv	a5,s6
    80001702:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001704:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001708:	96da                	add	a3,a3,s6
    8000170a:	85be                	mv	a1,a5
      if(*p == '\0'){
    8000170c:	00f60733          	add	a4,a2,a5
    80001710:	00074703          	lbu	a4,0(a4)
    80001714:	db59                	beqz	a4,800016aa <copyinstr+0x26>
        *dst = *p;
    80001716:	00e78023          	sb	a4,0(a5)
      dst++;
    8000171a:	0785                	addi	a5,a5,1
    while(n > 0){
    8000171c:	fed797e3          	bne	a5,a3,8000170a <copyinstr+0x86>
    80001720:	b775                	j	800016cc <copyinstr+0x48>
    80001722:	4781                	li	a5,0
    80001724:	b771                	j	800016b0 <copyinstr+0x2c>
      return -1;
    80001726:	557d                	li	a0,-1
    80001728:	b779                	j	800016b6 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    8000172a:	6b85                	lui	s7,0x1
    8000172c:	9ba6                	add	s7,s7,s1
    8000172e:	87da                	mv	a5,s6
    80001730:	b77d                	j	800016de <copyinstr+0x5a>
  int got_null = 0;
    80001732:	4781                	li	a5,0
  if(got_null){
    80001734:	37fd                	addiw	a5,a5,-1
    80001736:	0007851b          	sext.w	a0,a5
}
    8000173a:	8082                	ret

000000008000173c <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000173c:	7139                	addi	sp,sp,-64
    8000173e:	fc06                	sd	ra,56(sp)
    80001740:	f822                	sd	s0,48(sp)
    80001742:	f426                	sd	s1,40(sp)
    80001744:	f04a                	sd	s2,32(sp)
    80001746:	ec4e                	sd	s3,24(sp)
    80001748:	e852                	sd	s4,16(sp)
    8000174a:	e456                	sd	s5,8(sp)
    8000174c:	e05a                	sd	s6,0(sp)
    8000174e:	0080                	addi	s0,sp,64
    80001750:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001752:	0000e497          	auipc	s1,0xe
    80001756:	30e48493          	addi	s1,s1,782 # 8000fa60 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    8000175a:	8b26                	mv	s6,s1
    8000175c:	faaab937          	lui	s2,0xfaaab
    80001760:	aab90913          	addi	s2,s2,-1365 # fffffffffaaaaaab <end+0xffffffff7aa8f03b>
    80001764:	0932                	slli	s2,s2,0xc
    80001766:	aab90913          	addi	s2,s2,-1365
    8000176a:	0932                	slli	s2,s2,0xc
    8000176c:	aab90913          	addi	s2,s2,-1365
    80001770:	0932                	slli	s2,s2,0xc
    80001772:	aab90913          	addi	s2,s2,-1365
    80001776:	000a09b7          	lui	s3,0xa0
    8000177a:	19fd                	addi	s3,s3,-1 # 9ffff <_entry-0x7ff60001>
    8000177c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000177e:	0000fa97          	auipc	s5,0xf
    80001782:	a62a8a93          	addi	s5,s5,-1438 # 800101e0 <pid_lock>
    char *pa = kalloc();
    80001786:	ba0ff0ef          	jal	80000b26 <kalloc>
    8000178a:	862a                	mv	a2,a0
    if(pa == 0)
    8000178c:	cd15                	beqz	a0,800017c8 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    8000178e:	416485b3          	sub	a1,s1,s6
    80001792:	859d                	srai	a1,a1,0x7
    80001794:	032585b3          	mul	a1,a1,s2
    80001798:	2585                	addiw	a1,a1,1
    8000179a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000179e:	4719                	li	a4,6
    800017a0:	6685                	lui	a3,0x1
    800017a2:	40b985b3          	sub	a1,s3,a1
    800017a6:	8552                	mv	a0,s4
    800017a8:	907ff0ef          	jal	800010ae <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ac:	18048493          	addi	s1,s1,384
    800017b0:	fd549be3          	bne	s1,s5,80001786 <proc_mapstacks+0x4a>
  }
}
    800017b4:	70e2                	ld	ra,56(sp)
    800017b6:	7442                	ld	s0,48(sp)
    800017b8:	74a2                	ld	s1,40(sp)
    800017ba:	7902                	ld	s2,32(sp)
    800017bc:	69e2                	ld	s3,24(sp)
    800017be:	6a42                	ld	s4,16(sp)
    800017c0:	6aa2                	ld	s5,8(sp)
    800017c2:	6b02                	ld	s6,0(sp)
    800017c4:	6121                	addi	sp,sp,64
    800017c6:	8082                	ret
      panic("kalloc");
    800017c8:	00006517          	auipc	a0,0x6
    800017cc:	a3050513          	addi	a0,a0,-1488 # 800071f8 <etext+0x1f8>
    800017d0:	fc5fe0ef          	jal	80000794 <panic>

00000000800017d4 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800017d4:	715d                	addi	sp,sp,-80
    800017d6:	e486                	sd	ra,72(sp)
    800017d8:	e0a2                	sd	s0,64(sp)
    800017da:	fc26                	sd	s1,56(sp)
    800017dc:	f84a                	sd	s2,48(sp)
    800017de:	f44e                	sd	s3,40(sp)
    800017e0:	f052                	sd	s4,32(sp)
    800017e2:	ec56                	sd	s5,24(sp)
    800017e4:	e85a                	sd	s6,16(sp)
    800017e6:	e45e                	sd	s7,8(sp)
    800017e8:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800017ea:	00006597          	auipc	a1,0x6
    800017ee:	a1658593          	addi	a1,a1,-1514 # 80007200 <etext+0x200>
    800017f2:	0000f517          	auipc	a0,0xf
    800017f6:	9ee50513          	addi	a0,a0,-1554 # 800101e0 <pid_lock>
    800017fa:	b7cff0ef          	jal	80000b76 <initlock>
  initlock(&wait_lock, "wait_lock");
    800017fe:	00006597          	auipc	a1,0x6
    80001802:	a0a58593          	addi	a1,a1,-1526 # 80007208 <etext+0x208>
    80001806:	0000f517          	auipc	a0,0xf
    8000180a:	9f250513          	addi	a0,a0,-1550 # 800101f8 <wait_lock>
    8000180e:	b68ff0ef          	jal	80000b76 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001812:	0000e497          	auipc	s1,0xe
    80001816:	24e48493          	addi	s1,s1,590 # 8000fa60 <proc>
      initlock(&p->lock, "proc");
    8000181a:	00006b97          	auipc	s7,0x6
    8000181e:	9feb8b93          	addi	s7,s7,-1538 # 80007218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001822:	8b26                	mv	s6,s1
    80001824:	faaab937          	lui	s2,0xfaaab
    80001828:	aab90913          	addi	s2,s2,-1365 # fffffffffaaaaaab <end+0xffffffff7aa8f03b>
    8000182c:	0932                	slli	s2,s2,0xc
    8000182e:	aab90913          	addi	s2,s2,-1365
    80001832:	0932                	slli	s2,s2,0xc
    80001834:	aab90913          	addi	s2,s2,-1365
    80001838:	0932                	slli	s2,s2,0xc
    8000183a:	aab90913          	addi	s2,s2,-1365
    8000183e:	000a09b7          	lui	s3,0xa0
    80001842:	19fd                	addi	s3,s3,-1 # 9ffff <_entry-0x7ff60001>
    80001844:	09b2                	slli	s3,s3,0xc
      p->priority = 1;
    80001846:	4a85                	li	s5,1
  for(p = proc; p < &proc[NPROC]; p++) {
    80001848:	0000fa17          	auipc	s4,0xf
    8000184c:	998a0a13          	addi	s4,s4,-1640 # 800101e0 <pid_lock>
      initlock(&p->lock, "proc");
    80001850:	85de                	mv	a1,s7
    80001852:	8526                	mv	a0,s1
    80001854:	b22ff0ef          	jal	80000b76 <initlock>
      p->state = UNUSED;
    80001858:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    8000185c:	416487b3          	sub	a5,s1,s6
    80001860:	879d                	srai	a5,a5,0x7
    80001862:	032787b3          	mul	a5,a5,s2
    80001866:	2785                	addiw	a5,a5,1
    80001868:	00d7979b          	slliw	a5,a5,0xd
    8000186c:	40f987b3          	sub	a5,s3,a5
    80001870:	e0bc                	sd	a5,64(s1)
      p->priority = 1;
    80001872:	1754a823          	sw	s5,368(s1)
      p->next_p_priority = NULL;
    80001876:	1604bc23          	sd	zero,376(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000187a:	18048493          	addi	s1,s1,384
    8000187e:	fd4499e3          	bne	s1,s4,80001850 <procinit+0x7c>
  }
}
    80001882:	60a6                	ld	ra,72(sp)
    80001884:	6406                	ld	s0,64(sp)
    80001886:	74e2                	ld	s1,56(sp)
    80001888:	7942                	ld	s2,48(sp)
    8000188a:	79a2                	ld	s3,40(sp)
    8000188c:	7a02                	ld	s4,32(sp)
    8000188e:	6ae2                	ld	s5,24(sp)
    80001890:	6b42                	ld	s6,16(sp)
    80001892:	6ba2                	ld	s7,8(sp)
    80001894:	6161                	addi	sp,sp,80
    80001896:	8082                	ret

0000000080001898 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001898:	1141                	addi	sp,sp,-16
    8000189a:	e422                	sd	s0,8(sp)
    8000189c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000189e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018a0:	2501                	sext.w	a0,a0
    800018a2:	6422                	ld	s0,8(sp)
    800018a4:	0141                	addi	sp,sp,16
    800018a6:	8082                	ret

00000000800018a8 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018a8:	1141                	addi	sp,sp,-16
    800018aa:	e422                	sd	s0,8(sp)
    800018ac:	0800                	addi	s0,sp,16
    800018ae:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018b0:	2781                	sext.w	a5,a5
    800018b2:	079e                	slli	a5,a5,0x7
  return c;
}
    800018b4:	0000f517          	auipc	a0,0xf
    800018b8:	95c50513          	addi	a0,a0,-1700 # 80010210 <cpus>
    800018bc:	953e                	add	a0,a0,a5
    800018be:	6422                	ld	s0,8(sp)
    800018c0:	0141                	addi	sp,sp,16
    800018c2:	8082                	ret

00000000800018c4 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800018c4:	1101                	addi	sp,sp,-32
    800018c6:	ec06                	sd	ra,24(sp)
    800018c8:	e822                	sd	s0,16(sp)
    800018ca:	e426                	sd	s1,8(sp)
    800018cc:	1000                	addi	s0,sp,32
  push_off();
    800018ce:	ae8ff0ef          	jal	80000bb6 <push_off>
    800018d2:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018d4:	2781                	sext.w	a5,a5
    800018d6:	079e                	slli	a5,a5,0x7
    800018d8:	0000e717          	auipc	a4,0xe
    800018dc:	18870713          	addi	a4,a4,392 # 8000fa60 <proc>
    800018e0:	97ba                	add	a5,a5,a4
    800018e2:	7b07b483          	ld	s1,1968(a5)
  pop_off();
    800018e6:	b54ff0ef          	jal	80000c3a <pop_off>
  return p;
}
    800018ea:	8526                	mv	a0,s1
    800018ec:	60e2                	ld	ra,24(sp)
    800018ee:	6442                	ld	s0,16(sp)
    800018f0:	64a2                	ld	s1,8(sp)
    800018f2:	6105                	addi	sp,sp,32
    800018f4:	8082                	ret

00000000800018f6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800018f6:	1141                	addi	sp,sp,-16
    800018f8:	e406                	sd	ra,8(sp)
    800018fa:	e022                	sd	s0,0(sp)
    800018fc:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800018fe:	fc7ff0ef          	jal	800018c4 <myproc>
    80001902:	b8cff0ef          	jal	80000c8e <release>

  if (first) {
    80001906:	00006797          	auipc	a5,0x6
    8000190a:	faa7a783          	lw	a5,-86(a5) # 800078b0 <first.1>
    8000190e:	e799                	bnez	a5,8000191c <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001910:	4a3000ef          	jal	800025b2 <usertrapret>
}
    80001914:	60a2                	ld	ra,8(sp)
    80001916:	6402                	ld	s0,0(sp)
    80001918:	0141                	addi	sp,sp,16
    8000191a:	8082                	ret
    fsinit(ROOTDEV);
    8000191c:	4505                	li	a0,1
    8000191e:	00b010ef          	jal	80003128 <fsinit>
    first = 0;
    80001922:	00006797          	auipc	a5,0x6
    80001926:	f807a723          	sw	zero,-114(a5) # 800078b0 <first.1>
    __sync_synchronize();
    8000192a:	0ff0000f          	fence
    8000192e:	b7cd                	j	80001910 <forkret+0x1a>

0000000080001930 <allocpid>:
{
    80001930:	1101                	addi	sp,sp,-32
    80001932:	ec06                	sd	ra,24(sp)
    80001934:	e822                	sd	s0,16(sp)
    80001936:	e426                	sd	s1,8(sp)
    80001938:	e04a                	sd	s2,0(sp)
    8000193a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000193c:	0000f917          	auipc	s2,0xf
    80001940:	8a490913          	addi	s2,s2,-1884 # 800101e0 <pid_lock>
    80001944:	854a                	mv	a0,s2
    80001946:	ab0ff0ef          	jal	80000bf6 <acquire>
  pid = nextpid;
    8000194a:	00006797          	auipc	a5,0x6
    8000194e:	f6a78793          	addi	a5,a5,-150 # 800078b4 <nextpid>
    80001952:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001954:	0014871b          	addiw	a4,s1,1
    80001958:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000195a:	854a                	mv	a0,s2
    8000195c:	b32ff0ef          	jal	80000c8e <release>
}
    80001960:	8526                	mv	a0,s1
    80001962:	60e2                	ld	ra,24(sp)
    80001964:	6442                	ld	s0,16(sp)
    80001966:	64a2                	ld	s1,8(sp)
    80001968:	6902                	ld	s2,0(sp)
    8000196a:	6105                	addi	sp,sp,32
    8000196c:	8082                	ret

000000008000196e <get_trapframe>:
struct trapframe* get_trapframe(struct proc *p) {
    8000196e:	1141                	addi	sp,sp,-16
    80001970:	e422                	sd	s0,8(sp)
    80001972:	0800                	addi	s0,sp,16
  return (struct trapframe*) PROCESS_TRAPFRAME(p - proc);
    80001974:	0000e797          	auipc	a5,0xe
    80001978:	0ec78793          	addi	a5,a5,236 # 8000fa60 <proc>
    8000197c:	8d1d                	sub	a0,a0,a5
    8000197e:	851d                	srai	a0,a0,0x7
    80001980:	faaab7b7          	lui	a5,0xfaaab
    80001984:	aab78793          	addi	a5,a5,-1365 # fffffffffaaaaaab <end+0xffffffff7aa8f03b>
    80001988:	07b2                	slli	a5,a5,0xc
    8000198a:	aab78793          	addi	a5,a5,-1365
    8000198e:	07b2                	slli	a5,a5,0xc
    80001990:	aab78793          	addi	a5,a5,-1365
    80001994:	07b2                	slli	a5,a5,0xc
    80001996:	aab78793          	addi	a5,a5,-1365
    8000199a:	02f50533          	mul	a0,a0,a5
    8000199e:	6789                	lui	a5,0x2
    800019a0:	078d                	addi	a5,a5,3 # 2003 <_entry-0x7fffdffd>
    800019a2:	953e                	add	a0,a0,a5
    800019a4:	054a                	slli	a0,a0,0x12
}
    800019a6:	ee050513          	addi	a0,a0,-288
    800019aa:	6422                	ld	s0,8(sp)
    800019ac:	0141                	addi	sp,sp,16
    800019ae:	8082                	ret

00000000800019b0 <proc_pagetable>:
{
    800019b0:	1101                	addi	sp,sp,-32
    800019b2:	ec06                	sd	ra,24(sp)
    800019b4:	e822                	sd	s0,16(sp)
    800019b6:	e426                	sd	s1,8(sp)
    800019b8:	e04a                	sd	s2,0(sp)
    800019ba:	1000                	addi	s0,sp,32
    800019bc:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800019be:	8a3ff0ef          	jal	80001260 <uvmcreate>
    800019c2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800019c4:	c915                	beqz	a0,800019f8 <proc_pagetable+0x48>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800019c6:	4729                	li	a4,10
    800019c8:	00004697          	auipc	a3,0x4
    800019cc:	63868693          	addi	a3,a3,1592 # 80006000 <_trampoline>
    800019d0:	6605                	lui	a2,0x1
    800019d2:	000a05b7          	lui	a1,0xa0
    800019d6:	15fd                	addi	a1,a1,-1 # 9ffff <_entry-0x7ff60001>
    800019d8:	05b2                	slli	a1,a1,0xc
    800019da:	e24ff0ef          	jal	80000ffe <mappages>
    800019de:	02054463          	bltz	a0,80001a06 <proc_pagetable+0x56>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800019e2:	4719                	li	a4,6
    800019e4:	06093683          	ld	a3,96(s2)
    800019e8:	6605                	lui	a2,0x1
    800019ea:	4595                	li	a1,5
    800019ec:	05f6                	slli	a1,a1,0x1d
    800019ee:	8526                	mv	a0,s1
    800019f0:	e0eff0ef          	jal	80000ffe <mappages>
    800019f4:	00054f63          	bltz	a0,80001a12 <proc_pagetable+0x62>
}
    800019f8:	8526                	mv	a0,s1
    800019fa:	60e2                	ld	ra,24(sp)
    800019fc:	6442                	ld	s0,16(sp)
    800019fe:	64a2                	ld	s1,8(sp)
    80001a00:	6902                	ld	s2,0(sp)
    80001a02:	6105                	addi	sp,sp,32
    80001a04:	8082                	ret
    uvmfree(pagetable, 0);
    80001a06:	4581                	li	a1,0
    80001a08:	8526                	mv	a0,s1
    80001a0a:	a11ff0ef          	jal	8000141a <uvmfree>
    return 0;
    80001a0e:	4481                	li	s1,0
    80001a10:	b7e5                	j	800019f8 <proc_pagetable+0x48>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a12:	4681                	li	a3,0
    80001a14:	4605                	li	a2,1
    80001a16:	000a05b7          	lui	a1,0xa0
    80001a1a:	15fd                	addi	a1,a1,-1 # 9ffff <_entry-0x7ff60001>
    80001a1c:	05b2                	slli	a1,a1,0xc
    80001a1e:	8526                	mv	a0,s1
    80001a20:	f84ff0ef          	jal	800011a4 <uvmunmap>
    uvmfree(pagetable, 0);
    80001a24:	4581                	li	a1,0
    80001a26:	8526                	mv	a0,s1
    80001a28:	9f3ff0ef          	jal	8000141a <uvmfree>
    return 0;
    80001a2c:	4481                	li	s1,0
    80001a2e:	b7e9                	j	800019f8 <proc_pagetable+0x48>

0000000080001a30 <proc_freepagetable>:
{
    80001a30:	1101                	addi	sp,sp,-32
    80001a32:	ec06                	sd	ra,24(sp)
    80001a34:	e822                	sd	s0,16(sp)
    80001a36:	e426                	sd	s1,8(sp)
    80001a38:	e04a                	sd	s2,0(sp)
    80001a3a:	1000                	addi	s0,sp,32
    80001a3c:	84aa                	mv	s1,a0
    80001a3e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a40:	4681                	li	a3,0
    80001a42:	4605                	li	a2,1
    80001a44:	000a05b7          	lui	a1,0xa0
    80001a48:	15fd                	addi	a1,a1,-1 # 9ffff <_entry-0x7ff60001>
    80001a4a:	05b2                	slli	a1,a1,0xc
    80001a4c:	f58ff0ef          	jal	800011a4 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a50:	4681                	li	a3,0
    80001a52:	4605                	li	a2,1
    80001a54:	4595                	li	a1,5
    80001a56:	05f6                	slli	a1,a1,0x1d
    80001a58:	8526                	mv	a0,s1
    80001a5a:	f4aff0ef          	jal	800011a4 <uvmunmap>
  uvmfree(pagetable, sz);
    80001a5e:	85ca                	mv	a1,s2
    80001a60:	8526                	mv	a0,s1
    80001a62:	9b9ff0ef          	jal	8000141a <uvmfree>
}
    80001a66:	60e2                	ld	ra,24(sp)
    80001a68:	6442                	ld	s0,16(sp)
    80001a6a:	64a2                	ld	s1,8(sp)
    80001a6c:	6902                	ld	s2,0(sp)
    80001a6e:	6105                	addi	sp,sp,32
    80001a70:	8082                	ret

0000000080001a72 <growproc>:
{
    80001a72:	1101                	addi	sp,sp,-32
    80001a74:	ec06                	sd	ra,24(sp)
    80001a76:	e822                	sd	s0,16(sp)
    80001a78:	e426                	sd	s1,8(sp)
    80001a7a:	e04a                	sd	s2,0(sp)
    80001a7c:	1000                	addi	s0,sp,32
    80001a7e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001a80:	e45ff0ef          	jal	800018c4 <myproc>
    80001a84:	84aa                	mv	s1,a0
  sz = p->sz;
    80001a86:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001a88:	01204c63          	bgtz	s2,80001aa0 <growproc+0x2e>
  } else if(n < 0){
    80001a8c:	02094463          	bltz	s2,80001ab4 <growproc+0x42>
  p->sz = sz;
    80001a90:	e4ac                	sd	a1,72(s1)
  return 0;
    80001a92:	4501                	li	a0,0
}
    80001a94:	60e2                	ld	ra,24(sp)
    80001a96:	6442                	ld	s0,16(sp)
    80001a98:	64a2                	ld	s1,8(sp)
    80001a9a:	6902                	ld	s2,0(sp)
    80001a9c:	6105                	addi	sp,sp,32
    80001a9e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001aa0:	4691                	li	a3,4
    80001aa2:	00b90633          	add	a2,s2,a1
    80001aa6:	6928                	ld	a0,80(a0)
    80001aa8:	86dff0ef          	jal	80001314 <uvmalloc>
    80001aac:	85aa                	mv	a1,a0
    80001aae:	f16d                	bnez	a0,80001a90 <growproc+0x1e>
      return -1;
    80001ab0:	557d                	li	a0,-1
    80001ab2:	b7cd                	j	80001a94 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001ab4:	00b90633          	add	a2,s2,a1
    80001ab8:	6928                	ld	a0,80(a0)
    80001aba:	817ff0ef          	jal	800012d0 <uvmdealloc>
    80001abe:	85aa                	mv	a1,a0
    80001ac0:	bfc1                	j	80001a90 <growproc+0x1e>

0000000080001ac2 <scheduler>:
{
    80001ac2:	715d                	addi	sp,sp,-80
    80001ac4:	e486                	sd	ra,72(sp)
    80001ac6:	e0a2                	sd	s0,64(sp)
    80001ac8:	fc26                	sd	s1,56(sp)
    80001aca:	f84a                	sd	s2,48(sp)
    80001acc:	f44e                	sd	s3,40(sp)
    80001ace:	f052                	sd	s4,32(sp)
    80001ad0:	ec56                	sd	s5,24(sp)
    80001ad2:	e85a                	sd	s6,16(sp)
    80001ad4:	e45e                	sd	s7,8(sp)
    80001ad6:	e062                	sd	s8,0(sp)
    80001ad8:	0880                	addi	s0,sp,80
    80001ada:	8792                	mv	a5,tp
  int id = r_tp();
    80001adc:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001ade:	00779b13          	slli	s6,a5,0x7
    80001ae2:	0000e717          	auipc	a4,0xe
    80001ae6:	f7e70713          	addi	a4,a4,-130 # 8000fa60 <proc>
    80001aea:	975a                	add	a4,a4,s6
    80001aec:	7a073823          	sd	zero,1968(a4)
        swtch(&c->context, &p->context);
    80001af0:	0000e717          	auipc	a4,0xe
    80001af4:	72870713          	addi	a4,a4,1832 # 80010218 <cpus+0x8>
    80001af8:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001afa:	4c11                	li	s8,4
        c->proc = p;
    80001afc:	079e                	slli	a5,a5,0x7
    80001afe:	0000ea97          	auipc	s5,0xe
    80001b02:	f62a8a93          	addi	s5,s5,-158 # 8000fa60 <proc>
    80001b06:	9abe                	add	s5,s5,a5
        found = 1;
    80001b08:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001b0a:	0000e997          	auipc	s3,0xe
    80001b0e:	6d698993          	addi	s3,s3,1750 # 800101e0 <pid_lock>
    80001b12:	a0a9                	j	80001b5c <scheduler+0x9a>
      release(&p->lock);
    80001b14:	8526                	mv	a0,s1
    80001b16:	978ff0ef          	jal	80000c8e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001b1a:	18048493          	addi	s1,s1,384
    80001b1e:	03348563          	beq	s1,s3,80001b48 <scheduler+0x86>
      acquire(&p->lock);
    80001b22:	8526                	mv	a0,s1
    80001b24:	8d2ff0ef          	jal	80000bf6 <acquire>
      if(p->state == RUNNABLE) {
    80001b28:	4c9c                	lw	a5,24(s1)
    80001b2a:	ff2795e3          	bne	a5,s2,80001b14 <scheduler+0x52>
        p->state = RUNNING;
    80001b2e:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001b32:	7a9ab823          	sd	s1,1968(s5)
        swtch(&c->context, &p->context);
    80001b36:	06848593          	addi	a1,s1,104
    80001b3a:	855a                	mv	a0,s6
    80001b3c:	1d1000ef          	jal	8000250c <swtch>
        c->proc = 0;
    80001b40:	7a0ab823          	sd	zero,1968(s5)
        found = 1;
    80001b44:	8a5e                	mv	s4,s7
    80001b46:	b7f9                	j	80001b14 <scheduler+0x52>
    if(found == 0) {
    80001b48:	000a1a63          	bnez	s4,80001b5c <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b4c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b50:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b54:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001b58:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b5c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b60:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b64:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001b68:	4a01                	li	s4,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001b6a:	0000e497          	auipc	s1,0xe
    80001b6e:	ef648493          	addi	s1,s1,-266 # 8000fa60 <proc>
      if(p->state == RUNNABLE) {
    80001b72:	490d                	li	s2,3
    80001b74:	b77d                	j	80001b22 <scheduler+0x60>

0000000080001b76 <sched>:
{
    80001b76:	7179                	addi	sp,sp,-48
    80001b78:	f406                	sd	ra,40(sp)
    80001b7a:	f022                	sd	s0,32(sp)
    80001b7c:	ec26                	sd	s1,24(sp)
    80001b7e:	e84a                	sd	s2,16(sp)
    80001b80:	e44e                	sd	s3,8(sp)
    80001b82:	e052                	sd	s4,0(sp)
    80001b84:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001b86:	d3fff0ef          	jal	800018c4 <myproc>
    80001b8a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001b8c:	800ff0ef          	jal	80000b8c <holding>
    80001b90:	cd3d                	beqz	a0,80001c0e <sched+0x98>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b92:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001b94:	2781                	sext.w	a5,a5
    80001b96:	079e                	slli	a5,a5,0x7
    80001b98:	0000e717          	auipc	a4,0xe
    80001b9c:	ec870713          	addi	a4,a4,-312 # 8000fa60 <proc>
    80001ba0:	973e                	add	a4,a4,a5
    80001ba2:	6785                	lui	a5,0x1
    80001ba4:	97ba                	add	a5,a5,a4
    80001ba6:	8287a703          	lw	a4,-2008(a5) # 828 <_entry-0x7ffff7d8>
    80001baa:	4785                	li	a5,1
    80001bac:	06f71763          	bne	a4,a5,80001c1a <sched+0xa4>
  if(p->state == RUNNING)
    80001bb0:	4c98                	lw	a4,24(s1)
    80001bb2:	4791                	li	a5,4
    80001bb4:	06f70963          	beq	a4,a5,80001c26 <sched+0xb0>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bb8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001bbc:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001bbe:	ebb5                	bnez	a5,80001c32 <sched+0xbc>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bc0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001bc2:	0000e917          	auipc	s2,0xe
    80001bc6:	e9e90913          	addi	s2,s2,-354 # 8000fa60 <proc>
    80001bca:	2781                	sext.w	a5,a5
    80001bcc:	079e                	slli	a5,a5,0x7
    80001bce:	97ca                	add	a5,a5,s2
    80001bd0:	6985                	lui	s3,0x1
    80001bd2:	97ce                	add	a5,a5,s3
    80001bd4:	82c7aa03          	lw	s4,-2004(a5)
    80001bd8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001bda:	2781                	sext.w	a5,a5
    80001bdc:	079e                	slli	a5,a5,0x7
    80001bde:	0000e597          	auipc	a1,0xe
    80001be2:	63a58593          	addi	a1,a1,1594 # 80010218 <cpus+0x8>
    80001be6:	95be                	add	a1,a1,a5
    80001be8:	06848513          	addi	a0,s1,104
    80001bec:	121000ef          	jal	8000250c <swtch>
    80001bf0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001bf2:	2781                	sext.w	a5,a5
    80001bf4:	079e                	slli	a5,a5,0x7
    80001bf6:	993e                	add	s2,s2,a5
    80001bf8:	99ca                	add	s3,s3,s2
    80001bfa:	8349a623          	sw	s4,-2004(s3) # 82c <_entry-0x7ffff7d4>
}
    80001bfe:	70a2                	ld	ra,40(sp)
    80001c00:	7402                	ld	s0,32(sp)
    80001c02:	64e2                	ld	s1,24(sp)
    80001c04:	6942                	ld	s2,16(sp)
    80001c06:	69a2                	ld	s3,8(sp)
    80001c08:	6a02                	ld	s4,0(sp)
    80001c0a:	6145                	addi	sp,sp,48
    80001c0c:	8082                	ret
    panic("sched p->lock");
    80001c0e:	00005517          	auipc	a0,0x5
    80001c12:	61250513          	addi	a0,a0,1554 # 80007220 <etext+0x220>
    80001c16:	b7ffe0ef          	jal	80000794 <panic>
    panic("sched locks");
    80001c1a:	00005517          	auipc	a0,0x5
    80001c1e:	61650513          	addi	a0,a0,1558 # 80007230 <etext+0x230>
    80001c22:	b73fe0ef          	jal	80000794 <panic>
    panic("sched running");
    80001c26:	00005517          	auipc	a0,0x5
    80001c2a:	61a50513          	addi	a0,a0,1562 # 80007240 <etext+0x240>
    80001c2e:	b67fe0ef          	jal	80000794 <panic>
    panic("sched interruptible");
    80001c32:	00005517          	auipc	a0,0x5
    80001c36:	61e50513          	addi	a0,a0,1566 # 80007250 <etext+0x250>
    80001c3a:	b5bfe0ef          	jal	80000794 <panic>

0000000080001c3e <yield>:
{
    80001c3e:	1101                	addi	sp,sp,-32
    80001c40:	ec06                	sd	ra,24(sp)
    80001c42:	e822                	sd	s0,16(sp)
    80001c44:	e426                	sd	s1,8(sp)
    80001c46:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001c48:	c7dff0ef          	jal	800018c4 <myproc>
    80001c4c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001c4e:	fa9fe0ef          	jal	80000bf6 <acquire>
  p->state = RUNNABLE;
    80001c52:	478d                	li	a5,3
    80001c54:	cc9c                	sw	a5,24(s1)
  sched();
    80001c56:	f21ff0ef          	jal	80001b76 <sched>
  release(&p->lock);
    80001c5a:	8526                	mv	a0,s1
    80001c5c:	832ff0ef          	jal	80000c8e <release>
}
    80001c60:	60e2                	ld	ra,24(sp)
    80001c62:	6442                	ld	s0,16(sp)
    80001c64:	64a2                	ld	s1,8(sp)
    80001c66:	6105                	addi	sp,sp,32
    80001c68:	8082                	ret

0000000080001c6a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001c6a:	7179                	addi	sp,sp,-48
    80001c6c:	f406                	sd	ra,40(sp)
    80001c6e:	f022                	sd	s0,32(sp)
    80001c70:	ec26                	sd	s1,24(sp)
    80001c72:	e84a                	sd	s2,16(sp)
    80001c74:	e44e                	sd	s3,8(sp)
    80001c76:	1800                	addi	s0,sp,48
    80001c78:	89aa                	mv	s3,a0
    80001c7a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c7c:	c49ff0ef          	jal	800018c4 <myproc>
    80001c80:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001c82:	f75fe0ef          	jal	80000bf6 <acquire>
  release(lk);
    80001c86:	854a                	mv	a0,s2
    80001c88:	806ff0ef          	jal	80000c8e <release>

  // Go to sleep.
  p->chan = chan;
    80001c8c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001c90:	4789                	li	a5,2
    80001c92:	cc9c                	sw	a5,24(s1)

  sched();
    80001c94:	ee3ff0ef          	jal	80001b76 <sched>

  // Tidy up.
  p->chan = 0;
    80001c98:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001c9c:	8526                	mv	a0,s1
    80001c9e:	ff1fe0ef          	jal	80000c8e <release>
  acquire(lk);
    80001ca2:	854a                	mv	a0,s2
    80001ca4:	f53fe0ef          	jal	80000bf6 <acquire>
}
    80001ca8:	70a2                	ld	ra,40(sp)
    80001caa:	7402                	ld	s0,32(sp)
    80001cac:	64e2                	ld	s1,24(sp)
    80001cae:	6942                	ld	s2,16(sp)
    80001cb0:	69a2                	ld	s3,8(sp)
    80001cb2:	6145                	addi	sp,sp,48
    80001cb4:	8082                	ret

0000000080001cb6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001cb6:	7179                	addi	sp,sp,-48
    80001cb8:	f406                	sd	ra,40(sp)
    80001cba:	f022                	sd	s0,32(sp)
    80001cbc:	ec26                	sd	s1,24(sp)
    80001cbe:	e84a                	sd	s2,16(sp)
    80001cc0:	e44e                	sd	s3,8(sp)
    80001cc2:	e052                	sd	s4,0(sp)
    80001cc4:	1800                	addi	s0,sp,48
    80001cc6:	89aa                	mv	s3,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001cc8:	0000e497          	auipc	s1,0xe
    80001ccc:	d9848493          	addi	s1,s1,-616 # 8000fa60 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001cd0:	4a09                	li	s4,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cd2:	0000e917          	auipc	s2,0xe
    80001cd6:	50e90913          	addi	s2,s2,1294 # 800101e0 <pid_lock>
    80001cda:	a801                	j	80001cea <wakeup+0x34>
        p->state = RUNNABLE;
      }
      release(&p->lock);
    80001cdc:	8526                	mv	a0,s1
    80001cde:	fb1fe0ef          	jal	80000c8e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ce2:	18048493          	addi	s1,s1,384
    80001ce6:	03248263          	beq	s1,s2,80001d0a <wakeup+0x54>
    if(p != myproc()){
    80001cea:	bdbff0ef          	jal	800018c4 <myproc>
    80001cee:	fea48ae3          	beq	s1,a0,80001ce2 <wakeup+0x2c>
      acquire(&p->lock);
    80001cf2:	8526                	mv	a0,s1
    80001cf4:	f03fe0ef          	jal	80000bf6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001cf8:	4c9c                	lw	a5,24(s1)
    80001cfa:	ff4791e3          	bne	a5,s4,80001cdc <wakeup+0x26>
    80001cfe:	709c                	ld	a5,32(s1)
    80001d00:	fd379ee3          	bne	a5,s3,80001cdc <wakeup+0x26>
        p->state = RUNNABLE;
    80001d04:	478d                	li	a5,3
    80001d06:	cc9c                	sw	a5,24(s1)
    80001d08:	bfd1                	j	80001cdc <wakeup+0x26>
    }
  }
}
    80001d0a:	70a2                	ld	ra,40(sp)
    80001d0c:	7402                	ld	s0,32(sp)
    80001d0e:	64e2                	ld	s1,24(sp)
    80001d10:	6942                	ld	s2,16(sp)
    80001d12:	69a2                	ld	s3,8(sp)
    80001d14:	6a02                	ld	s4,0(sp)
    80001d16:	6145                	addi	sp,sp,48
    80001d18:	8082                	ret

0000000080001d1a <reparent>:
{
    80001d1a:	7179                	addi	sp,sp,-48
    80001d1c:	f406                	sd	ra,40(sp)
    80001d1e:	f022                	sd	s0,32(sp)
    80001d20:	ec26                	sd	s1,24(sp)
    80001d22:	e84a                	sd	s2,16(sp)
    80001d24:	e44e                	sd	s3,8(sp)
    80001d26:	1800                	addi	s0,sp,48
    80001d28:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001d2a:	0000e497          	auipc	s1,0xe
    80001d2e:	d3648493          	addi	s1,s1,-714 # 8000fa60 <proc>
    80001d32:	0000e997          	auipc	s3,0xe
    80001d36:	4ae98993          	addi	s3,s3,1198 # 800101e0 <pid_lock>
    80001d3a:	a029                	j	80001d44 <reparent+0x2a>
    80001d3c:	18048493          	addi	s1,s1,384
    80001d40:	01348d63          	beq	s1,s3,80001d5a <reparent+0x40>
    if(pp->parent == p){
    80001d44:	7c9c                	ld	a5,56(s1)
    80001d46:	ff279be3          	bne	a5,s2,80001d3c <reparent+0x22>
      pp->parent = initproc;
    80001d4a:	00006517          	auipc	a0,0x6
    80001d4e:	bde53503          	ld	a0,-1058(a0) # 80007928 <initproc>
    80001d52:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001d54:	f63ff0ef          	jal	80001cb6 <wakeup>
    80001d58:	b7d5                	j	80001d3c <reparent+0x22>
}
    80001d5a:	70a2                	ld	ra,40(sp)
    80001d5c:	7402                	ld	s0,32(sp)
    80001d5e:	64e2                	ld	s1,24(sp)
    80001d60:	6942                	ld	s2,16(sp)
    80001d62:	69a2                	ld	s3,8(sp)
    80001d64:	6145                	addi	sp,sp,48
    80001d66:	8082                	ret

0000000080001d68 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001d68:	7179                	addi	sp,sp,-48
    80001d6a:	f406                	sd	ra,40(sp)
    80001d6c:	f022                	sd	s0,32(sp)
    80001d6e:	ec26                	sd	s1,24(sp)
    80001d70:	e84a                	sd	s2,16(sp)
    80001d72:	e44e                	sd	s3,8(sp)
    80001d74:	1800                	addi	s0,sp,48
    80001d76:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001d78:	0000e497          	auipc	s1,0xe
    80001d7c:	ce848493          	addi	s1,s1,-792 # 8000fa60 <proc>
    80001d80:	0000e997          	auipc	s3,0xe
    80001d84:	46098993          	addi	s3,s3,1120 # 800101e0 <pid_lock>
    acquire(&p->lock);
    80001d88:	8526                	mv	a0,s1
    80001d8a:	e6dfe0ef          	jal	80000bf6 <acquire>
    if(p->pid == pid){
    80001d8e:	589c                	lw	a5,48(s1)
    80001d90:	03278163          	beq	a5,s2,80001db2 <kill+0x4a>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001d94:	8526                	mv	a0,s1
    80001d96:	ef9fe0ef          	jal	80000c8e <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001d9a:	18048493          	addi	s1,s1,384
    80001d9e:	ff3495e3          	bne	s1,s3,80001d88 <kill+0x20>
  }
  return -1;
    80001da2:	557d                	li	a0,-1
}
    80001da4:	70a2                	ld	ra,40(sp)
    80001da6:	7402                	ld	s0,32(sp)
    80001da8:	64e2                	ld	s1,24(sp)
    80001daa:	6942                	ld	s2,16(sp)
    80001dac:	69a2                	ld	s3,8(sp)
    80001dae:	6145                	addi	sp,sp,48
    80001db0:	8082                	ret
      p->killed = 1;
    80001db2:	4785                	li	a5,1
    80001db4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001db6:	4c98                	lw	a4,24(s1)
    80001db8:	4789                	li	a5,2
    80001dba:	00f70763          	beq	a4,a5,80001dc8 <kill+0x60>
      release(&p->lock);
    80001dbe:	8526                	mv	a0,s1
    80001dc0:	ecffe0ef          	jal	80000c8e <release>
      return 0;
    80001dc4:	4501                	li	a0,0
    80001dc6:	bff9                	j	80001da4 <kill+0x3c>
        p->state = RUNNABLE;
    80001dc8:	478d                	li	a5,3
    80001dca:	cc9c                	sw	a5,24(s1)
    80001dcc:	bfcd                	j	80001dbe <kill+0x56>

0000000080001dce <setkilled>:

void
setkilled(struct proc *p)
{
    80001dce:	1101                	addi	sp,sp,-32
    80001dd0:	ec06                	sd	ra,24(sp)
    80001dd2:	e822                	sd	s0,16(sp)
    80001dd4:	e426                	sd	s1,8(sp)
    80001dd6:	1000                	addi	s0,sp,32
    80001dd8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001dda:	e1dfe0ef          	jal	80000bf6 <acquire>
  p->killed = 1;
    80001dde:	4785                	li	a5,1
    80001de0:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001de2:	8526                	mv	a0,s1
    80001de4:	eabfe0ef          	jal	80000c8e <release>
}
    80001de8:	60e2                	ld	ra,24(sp)
    80001dea:	6442                	ld	s0,16(sp)
    80001dec:	64a2                	ld	s1,8(sp)
    80001dee:	6105                	addi	sp,sp,32
    80001df0:	8082                	ret

0000000080001df2 <killed>:

int
killed(struct proc *p)
{
    80001df2:	1101                	addi	sp,sp,-32
    80001df4:	ec06                	sd	ra,24(sp)
    80001df6:	e822                	sd	s0,16(sp)
    80001df8:	e426                	sd	s1,8(sp)
    80001dfa:	e04a                	sd	s2,0(sp)
    80001dfc:	1000                	addi	s0,sp,32
    80001dfe:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001e00:	df7fe0ef          	jal	80000bf6 <acquire>
  k = p->killed;
    80001e04:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001e08:	8526                	mv	a0,s1
    80001e0a:	e85fe0ef          	jal	80000c8e <release>
  return k;
}
    80001e0e:	854a                	mv	a0,s2
    80001e10:	60e2                	ld	ra,24(sp)
    80001e12:	6442                	ld	s0,16(sp)
    80001e14:	64a2                	ld	s1,8(sp)
    80001e16:	6902                	ld	s2,0(sp)
    80001e18:	6105                	addi	sp,sp,32
    80001e1a:	8082                	ret

0000000080001e1c <wait>:
{
    80001e1c:	715d                	addi	sp,sp,-80
    80001e1e:	e486                	sd	ra,72(sp)
    80001e20:	e0a2                	sd	s0,64(sp)
    80001e22:	fc26                	sd	s1,56(sp)
    80001e24:	f84a                	sd	s2,48(sp)
    80001e26:	f44e                	sd	s3,40(sp)
    80001e28:	f052                	sd	s4,32(sp)
    80001e2a:	ec56                	sd	s5,24(sp)
    80001e2c:	e85a                	sd	s6,16(sp)
    80001e2e:	e45e                	sd	s7,8(sp)
    80001e30:	e062                	sd	s8,0(sp)
    80001e32:	0880                	addi	s0,sp,80
    80001e34:	8c2a                	mv	s8,a0
  struct proc *p = myproc();
    80001e36:	a8fff0ef          	jal	800018c4 <myproc>
    80001e3a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001e3c:	0000e517          	auipc	a0,0xe
    80001e40:	3bc50513          	addi	a0,a0,956 # 800101f8 <wait_lock>
    80001e44:	db3fe0ef          	jal	80000bf6 <acquire>
    havekids = 0;
    80001e48:	4a01                	li	s4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001e4a:	0000e997          	auipc	s3,0xe
    80001e4e:	39698993          	addi	s3,s3,918 # 800101e0 <pid_lock>
        if(pp->state == ZOMBIE){
    80001e52:	4b15                	li	s6,5
        havekids = 1;
    80001e54:	4b85                	li	s7,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001e56:	0000ea97          	auipc	s5,0xe
    80001e5a:	3a2a8a93          	addi	s5,s5,930 # 800101f8 <wait_lock>
    80001e5e:	a861                	j	80001ef6 <wait+0xda>
        acquire(&pp->lock);
    80001e60:	8526                	mv	a0,s1
    80001e62:	d95fe0ef          	jal	80000bf6 <acquire>
        if(pp->state == ZOMBIE){
    80001e66:	4c9c                	lw	a5,24(s1)
    80001e68:	01678763          	beq	a5,s6,80001e76 <wait+0x5a>
        release(&pp->lock);
    80001e6c:	8526                	mv	a0,s1
    80001e6e:	e21fe0ef          	jal	80000c8e <release>
        havekids = 1;
    80001e72:	875e                	mv	a4,s7
    80001e74:	a849                	j	80001f06 <wait+0xea>
          pid = pp->pid;
    80001e76:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001e7a:	000c0c63          	beqz	s8,80001e92 <wait+0x76>
    80001e7e:	4691                	li	a3,4
    80001e80:	02c48613          	addi	a2,s1,44
    80001e84:	85e2                	mv	a1,s8
    80001e86:	05093503          	ld	a0,80(s2)
    80001e8a:	e9eff0ef          	jal	80001528 <copyout>
    80001e8e:	04054063          	bltz	a0,80001ece <wait+0xb2>
  p->trapframe = 0;
    80001e92:	0604b023          	sd	zero,96(s1)
  p->base_addr = 0;
    80001e96:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001e9a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001e9e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001ea2:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001ea6:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001eaa:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001eae:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001eb2:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001eb6:	0004ac23          	sw	zero,24(s1)
          release(&pp->lock);
    80001eba:	8526                	mv	a0,s1
    80001ebc:	dd3fe0ef          	jal	80000c8e <release>
          release(&wait_lock);
    80001ec0:	0000e517          	auipc	a0,0xe
    80001ec4:	33850513          	addi	a0,a0,824 # 800101f8 <wait_lock>
    80001ec8:	dc7fe0ef          	jal	80000c8e <release>
          return pid;
    80001ecc:	a889                	j	80001f1e <wait+0x102>
            release(&pp->lock);
    80001ece:	8526                	mv	a0,s1
    80001ed0:	dbffe0ef          	jal	80000c8e <release>
            release(&wait_lock);
    80001ed4:	0000e517          	auipc	a0,0xe
    80001ed8:	32450513          	addi	a0,a0,804 # 800101f8 <wait_lock>
    80001edc:	db3fe0ef          	jal	80000c8e <release>
            return -1;
    80001ee0:	59fd                	li	s3,-1
    80001ee2:	a835                	j	80001f1e <wait+0x102>
    if(!havekids || killed(p)){
    80001ee4:	c715                	beqz	a4,80001f10 <wait+0xf4>
    80001ee6:	854a                	mv	a0,s2
    80001ee8:	f0bff0ef          	jal	80001df2 <killed>
    80001eec:	e115                	bnez	a0,80001f10 <wait+0xf4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001eee:	85d6                	mv	a1,s5
    80001ef0:	854a                	mv	a0,s2
    80001ef2:	d79ff0ef          	jal	80001c6a <sleep>
    havekids = 0;
    80001ef6:	8752                	mv	a4,s4
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ef8:	0000e497          	auipc	s1,0xe
    80001efc:	b6848493          	addi	s1,s1,-1176 # 8000fa60 <proc>
      if(pp->parent == p){
    80001f00:	7c9c                	ld	a5,56(s1)
    80001f02:	f5278fe3          	beq	a5,s2,80001e60 <wait+0x44>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f06:	18048493          	addi	s1,s1,384
    80001f0a:	ff349be3          	bne	s1,s3,80001f00 <wait+0xe4>
    80001f0e:	bfd9                	j	80001ee4 <wait+0xc8>
      release(&wait_lock);
    80001f10:	0000e517          	auipc	a0,0xe
    80001f14:	2e850513          	addi	a0,a0,744 # 800101f8 <wait_lock>
    80001f18:	d77fe0ef          	jal	80000c8e <release>
      return -1;
    80001f1c:	59fd                	li	s3,-1
}
    80001f1e:	854e                	mv	a0,s3
    80001f20:	60a6                	ld	ra,72(sp)
    80001f22:	6406                	ld	s0,64(sp)
    80001f24:	74e2                	ld	s1,56(sp)
    80001f26:	7942                	ld	s2,48(sp)
    80001f28:	79a2                	ld	s3,40(sp)
    80001f2a:	7a02                	ld	s4,32(sp)
    80001f2c:	6ae2                	ld	s5,24(sp)
    80001f2e:	6b42                	ld	s6,16(sp)
    80001f30:	6ba2                	ld	s7,8(sp)
    80001f32:	6c02                	ld	s8,0(sp)
    80001f34:	6161                	addi	sp,sp,80
    80001f36:	8082                	ret

0000000080001f38 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001f38:	7179                	addi	sp,sp,-48
    80001f3a:	f406                	sd	ra,40(sp)
    80001f3c:	f022                	sd	s0,32(sp)
    80001f3e:	ec26                	sd	s1,24(sp)
    80001f40:	e84a                	sd	s2,16(sp)
    80001f42:	e44e                	sd	s3,8(sp)
    80001f44:	e052                	sd	s4,0(sp)
    80001f46:	1800                	addi	s0,sp,48
    80001f48:	84aa                	mv	s1,a0
    80001f4a:	892e                	mv	s2,a1
    80001f4c:	89b2                	mv	s3,a2
    80001f4e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001f50:	975ff0ef          	jal	800018c4 <myproc>
  if(user_dst){
    80001f54:	cc99                	beqz	s1,80001f72 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001f56:	86d2                	mv	a3,s4
    80001f58:	864e                	mv	a2,s3
    80001f5a:	85ca                	mv	a1,s2
    80001f5c:	6928                	ld	a0,80(a0)
    80001f5e:	dcaff0ef          	jal	80001528 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001f62:	70a2                	ld	ra,40(sp)
    80001f64:	7402                	ld	s0,32(sp)
    80001f66:	64e2                	ld	s1,24(sp)
    80001f68:	6942                	ld	s2,16(sp)
    80001f6a:	69a2                	ld	s3,8(sp)
    80001f6c:	6a02                	ld	s4,0(sp)
    80001f6e:	6145                	addi	sp,sp,48
    80001f70:	8082                	ret
    memmove((char *)dst, src, len);
    80001f72:	000a061b          	sext.w	a2,s4
    80001f76:	85ce                	mv	a1,s3
    80001f78:	854a                	mv	a0,s2
    80001f7a:	dadfe0ef          	jal	80000d26 <memmove>
    return 0;
    80001f7e:	8526                	mv	a0,s1
    80001f80:	b7cd                	j	80001f62 <either_copyout+0x2a>

0000000080001f82 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001f82:	7179                	addi	sp,sp,-48
    80001f84:	f406                	sd	ra,40(sp)
    80001f86:	f022                	sd	s0,32(sp)
    80001f88:	ec26                	sd	s1,24(sp)
    80001f8a:	e84a                	sd	s2,16(sp)
    80001f8c:	e44e                	sd	s3,8(sp)
    80001f8e:	e052                	sd	s4,0(sp)
    80001f90:	1800                	addi	s0,sp,48
    80001f92:	892a                	mv	s2,a0
    80001f94:	84ae                	mv	s1,a1
    80001f96:	89b2                	mv	s3,a2
    80001f98:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001f9a:	92bff0ef          	jal	800018c4 <myproc>
  if(user_src){
    80001f9e:	cc99                	beqz	s1,80001fbc <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001fa0:	86d2                	mv	a3,s4
    80001fa2:	864e                	mv	a2,s3
    80001fa4:	85ca                	mv	a1,s2
    80001fa6:	6928                	ld	a0,80(a0)
    80001fa8:	e56ff0ef          	jal	800015fe <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001fac:	70a2                	ld	ra,40(sp)
    80001fae:	7402                	ld	s0,32(sp)
    80001fb0:	64e2                	ld	s1,24(sp)
    80001fb2:	6942                	ld	s2,16(sp)
    80001fb4:	69a2                	ld	s3,8(sp)
    80001fb6:	6a02                	ld	s4,0(sp)
    80001fb8:	6145                	addi	sp,sp,48
    80001fba:	8082                	ret
    memmove(dst, (char*)src, len);
    80001fbc:	000a061b          	sext.w	a2,s4
    80001fc0:	85ce                	mv	a1,s3
    80001fc2:	854a                	mv	a0,s2
    80001fc4:	d63fe0ef          	jal	80000d26 <memmove>
    return 0;
    80001fc8:	8526                	mv	a0,s1
    80001fca:	b7cd                	j	80001fac <either_copyin+0x2a>

0000000080001fcc <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001fcc:	715d                	addi	sp,sp,-80
    80001fce:	e486                	sd	ra,72(sp)
    80001fd0:	e0a2                	sd	s0,64(sp)
    80001fd2:	fc26                	sd	s1,56(sp)
    80001fd4:	f84a                	sd	s2,48(sp)
    80001fd6:	f44e                	sd	s3,40(sp)
    80001fd8:	f052                	sd	s4,32(sp)
    80001fda:	ec56                	sd	s5,24(sp)
    80001fdc:	e85a                	sd	s6,16(sp)
    80001fde:	e45e                	sd	s7,8(sp)
    80001fe0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001fe2:	00005517          	auipc	a0,0x5
    80001fe6:	09650513          	addi	a0,a0,150 # 80007078 <etext+0x78>
    80001fea:	cd8fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001fee:	0000e497          	auipc	s1,0xe
    80001ff2:	bd248493          	addi	s1,s1,-1070 # 8000fbc0 <proc+0x160>
    80001ff6:	0000e917          	auipc	s2,0xe
    80001ffa:	34a90913          	addi	s2,s2,842 # 80010340 <cpus+0x130>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ffe:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002000:	00005a97          	auipc	s5,0x5
    80002004:	268a8a93          	addi	s5,s5,616 # 80007268 <etext+0x268>
    printf("%d %s %s", p->pid, state, p->name);
    80002008:	00005a17          	auipc	s4,0x5
    8000200c:	268a0a13          	addi	s4,s4,616 # 80007270 <etext+0x270>
    printf("\n");
    80002010:	00005997          	auipc	s3,0x5
    80002014:	06898993          	addi	s3,s3,104 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002018:	00005b97          	auipc	s7,0x5
    8000201c:	7a0b8b93          	addi	s7,s7,1952 # 800077b8 <states.0>
    80002020:	a829                	j	8000203a <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002022:	ed06a583          	lw	a1,-304(a3)
    80002026:	8552                	mv	a0,s4
    80002028:	c9afe0ef          	jal	800004c2 <printf>
    printf("\n");
    8000202c:	854e                	mv	a0,s3
    8000202e:	c94fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002032:	18048493          	addi	s1,s1,384
    80002036:	03248563          	beq	s1,s2,80002060 <procdump+0x94>
    if(p->state == UNUSED)
    8000203a:	86a6                	mv	a3,s1
    8000203c:	eb84a783          	lw	a5,-328(s1)
    80002040:	dbed                	beqz	a5,80002032 <procdump+0x66>
      state = "???";
    80002042:	8656                	mv	a2,s5
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002044:	fcfb6fe3          	bltu	s6,a5,80002022 <procdump+0x56>
    80002048:	02079713          	slli	a4,a5,0x20
    8000204c:	01d75793          	srli	a5,a4,0x1d
    80002050:	97de                	add	a5,a5,s7
    80002052:	6390                	ld	a2,0(a5)
    80002054:	f679                	bnez	a2,80002022 <procdump+0x56>
      state = "???";
    80002056:	00005617          	auipc	a2,0x5
    8000205a:	21260613          	addi	a2,a2,530 # 80007268 <etext+0x268>
    8000205e:	b7d1                	j	80002022 <procdump+0x56>
  }
}
    80002060:	60a6                	ld	ra,72(sp)
    80002062:	6406                	ld	s0,64(sp)
    80002064:	74e2                	ld	s1,56(sp)
    80002066:	7942                	ld	s2,48(sp)
    80002068:	79a2                	ld	s3,40(sp)
    8000206a:	7a02                	ld	s4,32(sp)
    8000206c:	6ae2                	ld	s5,24(sp)
    8000206e:	6b42                	ld	s6,16(sp)
    80002070:	6ba2                	ld	s7,8(sp)
    80002072:	6161                	addi	sp,sp,80
    80002074:	8082                	ret

0000000080002076 <init_priority_control>:

void init_priority_control(void){
    80002076:	1141                	addi	sp,sp,-16
    80002078:	e406                	sd	ra,8(sp)
    8000207a:	e022                	sd	s0,0(sp)
    8000207c:	0800                	addi	s0,sp,16

  initlock(&priority_lock,"priority_lock");
    8000207e:	00005597          	auipc	a1,0x5
    80002082:	20258593          	addi	a1,a1,514 # 80007280 <etext+0x280>
    80002086:	0000e517          	auipc	a0,0xe
    8000208a:	58a50513          	addi	a0,a0,1418 # 80010610 <priority_lock>
    8000208e:	ae9fe0ef          	jal	80000b76 <initlock>

  for(int i = 0;i < MAXPRIORITY; i++){
    80002092:	0000e797          	auipc	a5,0xe
    80002096:	5ae78793          	addi	a5,a5,1454 # 80010640 <p_control+0x18>
    8000209a:	0000e717          	auipc	a4,0xe
    8000209e:	58e70713          	addi	a4,a4,1422 # 80010628 <p_control>
    800020a2:	0000e697          	auipc	a3,0xe
    800020a6:	5c668693          	addi	a3,a3,1478 # 80010668 <p_control+0x40>
    p_control.head_priority[i] = NULL;
    800020aa:	0007b023          	sd	zero,0(a5)
    p_control.present[i] = 0;
    800020ae:	00072023          	sw	zero,0(a4)
    p_control.current_priority[i] = NULL;
    800020b2:	0207b423          	sd	zero,40(a5)
  for(int i = 0;i < MAXPRIORITY; i++){
    800020b6:	07a1                	addi	a5,a5,8
    800020b8:	0711                	addi	a4,a4,4
    800020ba:	fed798e3          	bne	a5,a3,800020aa <init_priority_control+0x34>
  }
}
    800020be:	60a2                	ld	ra,8(sp)
    800020c0:	6402                	ld	s0,0(sp)
    800020c2:	0141                	addi	sp,sp,16
    800020c4:	8082                	ret

00000000800020c6 <set_priority>:

void set_priority(int priority, struct proc *process){
  if((priority > MAXPRIORITY) || (priority < 0) )
    800020c6:	4795                	li	a5,5
    800020c8:	00a7e563          	bltu	a5,a0,800020d2 <set_priority+0xc>
    panic("Priority nos alowed");

  process->priority = priority;
    800020cc:	16a5a823          	sw	a0,368(a1)
    800020d0:	8082                	ret
void set_priority(int priority, struct proc *process){
    800020d2:	1141                	addi	sp,sp,-16
    800020d4:	e406                	sd	ra,8(sp)
    800020d6:	e022                	sd	s0,0(sp)
    800020d8:	0800                	addi	s0,sp,16
    panic("Priority nos alowed");
    800020da:	00005517          	auipc	a0,0x5
    800020de:	1b650513          	addi	a0,a0,438 # 80007290 <etext+0x290>
    800020e2:	eb2fe0ef          	jal	80000794 <panic>

00000000800020e6 <add_process_priority>:

}

//should be called with the lock 
//iterates through linked list to add an element
void add_process_priority(struct proc *p, int priority){
    800020e6:	1141                	addi	sp,sp,-16
    800020e8:	e422                	sd	s0,8(sp)
    800020ea:	0800                	addi	s0,sp,16
  struct proc *aux_p;
  //check if lock held

  if(p_control.head_priority[priority] == NULL){
    800020ec:	00258713          	addi	a4,a1,2
    800020f0:	070e                	slli	a4,a4,0x3
    800020f2:	0000f797          	auipc	a5,0xf
    800020f6:	96e78793          	addi	a5,a5,-1682 # 80010a60 <bcache+0x3b8>
    800020fa:	97ba                	add	a5,a5,a4
    800020fc:	bd07b783          	ld	a5,-1072(a5)
    80002100:	cb91                	beqz	a5,80002114 <add_process_priority+0x2e>
    p_control.head_priority[priority] = p;
  }
  else{
    aux_p = p_control.head_priority[priority];
    while(aux_p->next_p_priority != NULL){
    80002102:	873e                	mv	a4,a5
    80002104:	1787b783          	ld	a5,376(a5)
    80002108:	ffed                	bnez	a5,80002102 <add_process_priority+0x1c>
      aux_p = aux_p->next_p_priority;
    }
    aux_p->next_p_priority = p;
    8000210a:	16a73c23          	sd	a0,376(a4)
  }

}
    8000210e:	6422                	ld	s0,8(sp)
    80002110:	0141                	addi	sp,sp,16
    80002112:	8082                	ret
    p_control.head_priority[priority] = p;
    80002114:	0000f797          	auipc	a5,0xf
    80002118:	94c78793          	addi	a5,a5,-1716 # 80010a60 <bcache+0x3b8>
    8000211c:	97ba                	add	a5,a5,a4
    8000211e:	bca7b823          	sd	a0,-1072(a5)
    80002122:	b7f5                	j	8000210e <add_process_priority+0x28>

0000000080002124 <allocproc>:
{
    80002124:	7179                	addi	sp,sp,-48
    80002126:	f406                	sd	ra,40(sp)
    80002128:	f022                	sd	s0,32(sp)
    8000212a:	ec26                	sd	s1,24(sp)
    8000212c:	e84a                	sd	s2,16(sp)
    8000212e:	e44e                	sd	s3,8(sp)
    80002130:	1800                	addi	s0,sp,48
    80002132:	89aa                	mv	s3,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002134:	0000e497          	auipc	s1,0xe
    80002138:	92c48493          	addi	s1,s1,-1748 # 8000fa60 <proc>
    8000213c:	0000e917          	auipc	s2,0xe
    80002140:	0a490913          	addi	s2,s2,164 # 800101e0 <pid_lock>
    acquire(&p->lock);
    80002144:	8526                	mv	a0,s1
    80002146:	ab1fe0ef          	jal	80000bf6 <acquire>
    if(p->state == UNUSED) {
    8000214a:	4c9c                	lw	a5,24(s1)
    8000214c:	c38d                	beqz	a5,8000216e <allocproc+0x4a>
      release(&p->lock);
    8000214e:	8526                	mv	a0,s1
    80002150:	b3ffe0ef          	jal	80000c8e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002154:	18048493          	addi	s1,s1,384
    80002158:	ff2496e3          	bne	s1,s2,80002144 <allocproc+0x20>
  return 0;
    8000215c:	4481                	li	s1,0
}
    8000215e:	8526                	mv	a0,s1
    80002160:	70a2                	ld	ra,40(sp)
    80002162:	7402                	ld	s0,32(sp)
    80002164:	64e2                	ld	s1,24(sp)
    80002166:	6942                	ld	s2,16(sp)
    80002168:	69a2                	ld	s3,8(sp)
    8000216a:	6145                	addi	sp,sp,48
    8000216c:	8082                	ret
    8000216e:	e052                	sd	s4,0(sp)
  p->pid = allocpid();
    80002170:	fc0ff0ef          	jal	80001930 <allocpid>
    80002174:	d888                	sw	a0,48(s1)
  p->state = USED;
    80002176:	4905                	li	s2,1
    80002178:	0124ac23          	sw	s2,24(s1)
  p->trapframe = (struct trapframe*) PROCESS_TRAPFRAME(p - proc);
    8000217c:	0000e797          	auipc	a5,0xe
    80002180:	8e478793          	addi	a5,a5,-1820 # 8000fa60 <proc>
    80002184:	40f487b3          	sub	a5,s1,a5
    80002188:	4077d713          	srai	a4,a5,0x7
    8000218c:	faaab7b7          	lui	a5,0xfaaab
    80002190:	aab78793          	addi	a5,a5,-1365 # fffffffffaaaaaab <end+0xffffffff7aa8f03b>
    80002194:	07b2                	slli	a5,a5,0xc
    80002196:	aab78793          	addi	a5,a5,-1365
    8000219a:	07b2                	slli	a5,a5,0xc
    8000219c:	aab78793          	addi	a5,a5,-1365
    800021a0:	07b2                	slli	a5,a5,0xc
    800021a2:	aab78793          	addi	a5,a5,-1365
    800021a6:	02f707b3          	mul	a5,a4,a5
    800021aa:	6709                	lui	a4,0x2
    800021ac:	070d                	addi	a4,a4,3 # 2003 <_entry-0x7fffdffd>
    800021ae:	97ba                	add	a5,a5,a4
    800021b0:	07ca                	slli	a5,a5,0x12
    800021b2:	ee078713          	addi	a4,a5,-288
    800021b6:	f0b8                	sd	a4,96(s1)
  p->base_addr =(void *) PROCESS_MEM_BASE(p - proc);
    800021b8:	fffc0737          	lui	a4,0xfffc0
    800021bc:	97ba                	add	a5,a5,a4
    800021be:	ecbc                	sd	a5,88(s1)
  p->priority = priority;
    800021c0:	1734a823          	sw	s3,368(s1)
  acquire(&priority_lock);
    800021c4:	0000ea17          	auipc	s4,0xe
    800021c8:	44ca0a13          	addi	s4,s4,1100 # 80010610 <priority_lock>
    800021cc:	8552                	mv	a0,s4
    800021ce:	a29fe0ef          	jal	80000bf6 <acquire>
  p_control.present[priority] = 1;
    800021d2:	00299713          	slli	a4,s3,0x2
    800021d6:	0000f797          	auipc	a5,0xf
    800021da:	88a78793          	addi	a5,a5,-1910 # 80010a60 <bcache+0x3b8>
    800021de:	97ba                	add	a5,a5,a4
    800021e0:	bd27a423          	sw	s2,-1080(a5)
  add_process_priority(p,priority);
    800021e4:	85ce                	mv	a1,s3
    800021e6:	8526                	mv	a0,s1
    800021e8:	effff0ef          	jal	800020e6 <add_process_priority>
  release(&priority_lock);
    800021ec:	8552                	mv	a0,s4
    800021ee:	aa1fe0ef          	jal	80000c8e <release>
  memset(&p->context, 0, sizeof(p->context));
    800021f2:	07000613          	li	a2,112
    800021f6:	4581                	li	a1,0
    800021f8:	06848513          	addi	a0,s1,104
    800021fc:	acffe0ef          	jal	80000cca <memset>
  p->context.ra = (uint64)forkret;
    80002200:	fffff797          	auipc	a5,0xfffff
    80002204:	6f678793          	addi	a5,a5,1782 # 800018f6 <forkret>
    80002208:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000220a:	60bc                	ld	a5,64(s1)
    8000220c:	6705                	lui	a4,0x1
    8000220e:	97ba                	add	a5,a5,a4
    80002210:	f8bc                	sd	a5,112(s1)
  return p;
    80002212:	6a02                	ld	s4,0(sp)
    80002214:	b7a9                	j	8000215e <allocproc+0x3a>

0000000080002216 <userinit>:
{
    80002216:	1101                	addi	sp,sp,-32
    80002218:	ec06                	sd	ra,24(sp)
    8000221a:	e822                	sd	s0,16(sp)
    8000221c:	e426                	sd	s1,8(sp)
    8000221e:	1000                	addi	s0,sp,32
  p = allocproc(2);
    80002220:	4509                	li	a0,2
    80002222:	f03ff0ef          	jal	80002124 <allocproc>
    80002226:	84aa                	mv	s1,a0
  initproc = p;
    80002228:	00005797          	auipc	a5,0x5
    8000222c:	70a7b023          	sd	a0,1792(a5) # 80007928 <initproc>
  memset(p->base_addr, 0, PGSIZE);
    80002230:	6605                	lui	a2,0x1
    80002232:	4581                	li	a1,0
    80002234:	6d28                	ld	a0,88(a0)
    80002236:	a95fe0ef          	jal	80000cca <memset>
  memmove(p->base_addr, initcode, sizeof(initcode));
    8000223a:	03400613          	li	a2,52
    8000223e:	00005597          	auipc	a1,0x5
    80002242:	68258593          	addi	a1,a1,1666 # 800078c0 <initcode>
    80002246:	6ca8                	ld	a0,88(s1)
    80002248:	adffe0ef          	jal	80000d26 <memmove>
  p->sz = PGSIZE;
    8000224c:	6705                	lui	a4,0x1
    8000224e:	e4b8                	sd	a4,72(s1)
  p->trapframe->epc =(uint64) p->base_addr;      // user program counter
    80002250:	70bc                	ld	a5,96(s1)
    80002252:	6cb4                	ld	a3,88(s1)
    80002254:	ef94                	sd	a3,24(a5)
  p->trapframe->sp = (uint64)p->base_addr + PGSIZE;  // user stack pointer
    80002256:	70b4                	ld	a3,96(s1)
    80002258:	6cbc                	ld	a5,88(s1)
    8000225a:	97ba                	add	a5,a5,a4
    8000225c:	fa9c                	sd	a5,48(a3)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000225e:	4641                	li	a2,16
    80002260:	00005597          	auipc	a1,0x5
    80002264:	04858593          	addi	a1,a1,72 # 800072a8 <etext+0x2a8>
    80002268:	16048513          	addi	a0,s1,352
    8000226c:	b9dfe0ef          	jal	80000e08 <safestrcpy>
  p->cwd = namei("/");
    80002270:	00005517          	auipc	a0,0x5
    80002274:	04850513          	addi	a0,a0,72 # 800072b8 <etext+0x2b8>
    80002278:	7be010ef          	jal	80003a36 <namei>
    8000227c:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80002280:	478d                	li	a5,3
    80002282:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80002284:	8526                	mv	a0,s1
    80002286:	a09fe0ef          	jal	80000c8e <release>
}
    8000228a:	60e2                	ld	ra,24(sp)
    8000228c:	6442                	ld	s0,16(sp)
    8000228e:	64a2                	ld	s1,8(sp)
    80002290:	6105                	addi	sp,sp,32
    80002292:	8082                	ret

0000000080002294 <fork>:
{
    80002294:	7139                	addi	sp,sp,-64
    80002296:	fc06                	sd	ra,56(sp)
    80002298:	f822                	sd	s0,48(sp)
    8000229a:	f04a                	sd	s2,32(sp)
    8000229c:	e456                	sd	s5,8(sp)
    8000229e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800022a0:	e24ff0ef          	jal	800018c4 <myproc>
    800022a4:	8aaa                	mv	s5,a0
  if((np = allocproc(p->priority)) == 0){
    800022a6:	17052503          	lw	a0,368(a0)
    800022aa:	e7bff0ef          	jal	80002124 <allocproc>
    800022ae:	10050b63          	beqz	a0,800023c4 <fork+0x130>
    800022b2:	ec4e                	sd	s3,24(sp)
    800022b4:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800022b6:	048ab603          	ld	a2,72(s5)
    800022ba:	692c                	ld	a1,80(a0)
    800022bc:	050ab503          	ld	a0,80(s5)
    800022c0:	98cff0ef          	jal	8000144c <uvmcopy>
    800022c4:	04054a63          	bltz	a0,80002318 <fork+0x84>
    800022c8:	f426                	sd	s1,40(sp)
    800022ca:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    800022cc:	048ab783          	ld	a5,72(s5)
    800022d0:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800022d4:	060ab683          	ld	a3,96(s5)
    800022d8:	87b6                	mv	a5,a3
    800022da:	0609b703          	ld	a4,96(s3)
    800022de:	12068693          	addi	a3,a3,288
    800022e2:	0007b803          	ld	a6,0(a5)
    800022e6:	6788                	ld	a0,8(a5)
    800022e8:	6b8c                	ld	a1,16(a5)
    800022ea:	6f90                	ld	a2,24(a5)
    800022ec:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    800022f0:	e708                	sd	a0,8(a4)
    800022f2:	eb0c                	sd	a1,16(a4)
    800022f4:	ef10                	sd	a2,24(a4)
    800022f6:	02078793          	addi	a5,a5,32
    800022fa:	02070713          	addi	a4,a4,32
    800022fe:	fed792e3          	bne	a5,a3,800022e2 <fork+0x4e>
  np->trapframe->a0 = 0;
    80002302:	0609b783          	ld	a5,96(s3)
    80002306:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000230a:	0d8a8493          	addi	s1,s5,216
    8000230e:	0d898913          	addi	s2,s3,216
    80002312:	158a8a13          	addi	s4,s5,344
    80002316:	a83d                	j	80002354 <fork+0xc0>
  p->trapframe = 0;
    80002318:	0609b023          	sd	zero,96(s3)
  p->base_addr = 0;
    8000231c:	0409bc23          	sd	zero,88(s3)
  p->sz = 0;
    80002320:	0409b423          	sd	zero,72(s3)
  p->pid = 0;
    80002324:	0209a823          	sw	zero,48(s3)
  p->parent = 0;
    80002328:	0209bc23          	sd	zero,56(s3)
  p->name[0] = 0;
    8000232c:	16098023          	sb	zero,352(s3)
  p->chan = 0;
    80002330:	0209b023          	sd	zero,32(s3)
  p->killed = 0;
    80002334:	0209a423          	sw	zero,40(s3)
  p->xstate = 0;
    80002338:	0209a623          	sw	zero,44(s3)
  p->state = UNUSED;
    8000233c:	0009ac23          	sw	zero,24(s3)
    release(&np->lock);
    80002340:	854e                	mv	a0,s3
    80002342:	94dfe0ef          	jal	80000c8e <release>
    return -1;
    80002346:	597d                	li	s2,-1
    80002348:	69e2                	ld	s3,24(sp)
    8000234a:	a0b5                	j	800023b6 <fork+0x122>
  for(i = 0; i < NOFILE; i++)
    8000234c:	04a1                	addi	s1,s1,8
    8000234e:	0921                	addi	s2,s2,8
    80002350:	01448963          	beq	s1,s4,80002362 <fork+0xce>
    if(p->ofile[i])
    80002354:	6088                	ld	a0,0(s1)
    80002356:	d97d                	beqz	a0,8000234c <fork+0xb8>
      np->ofile[i] = filedup(p->ofile[i]);
    80002358:	46f010ef          	jal	80003fc6 <filedup>
    8000235c:	00a93023          	sd	a0,0(s2)
    80002360:	b7f5                	j	8000234c <fork+0xb8>
  np->cwd = idup(p->cwd);
    80002362:	158ab503          	ld	a0,344(s5)
    80002366:	7c1000ef          	jal	80003326 <idup>
    8000236a:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000236e:	4641                	li	a2,16
    80002370:	160a8593          	addi	a1,s5,352
    80002374:	16098513          	addi	a0,s3,352
    80002378:	a91fe0ef          	jal	80000e08 <safestrcpy>
  pid = np->pid;
    8000237c:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80002380:	854e                	mv	a0,s3
    80002382:	90dfe0ef          	jal	80000c8e <release>
  acquire(&wait_lock);
    80002386:	0000e497          	auipc	s1,0xe
    8000238a:	e7248493          	addi	s1,s1,-398 # 800101f8 <wait_lock>
    8000238e:	8526                	mv	a0,s1
    80002390:	867fe0ef          	jal	80000bf6 <acquire>
  np->parent = p;
    80002394:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80002398:	8526                	mv	a0,s1
    8000239a:	8f5fe0ef          	jal	80000c8e <release>
  acquire(&np->lock);
    8000239e:	854e                	mv	a0,s3
    800023a0:	857fe0ef          	jal	80000bf6 <acquire>
  np->state = RUNNABLE;
    800023a4:	478d                	li	a5,3
    800023a6:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800023aa:	854e                	mv	a0,s3
    800023ac:	8e3fe0ef          	jal	80000c8e <release>
  return pid;
    800023b0:	74a2                	ld	s1,40(sp)
    800023b2:	69e2                	ld	s3,24(sp)
    800023b4:	6a42                	ld	s4,16(sp)
}
    800023b6:	854a                	mv	a0,s2
    800023b8:	70e2                	ld	ra,56(sp)
    800023ba:	7442                	ld	s0,48(sp)
    800023bc:	7902                	ld	s2,32(sp)
    800023be:	6aa2                	ld	s5,8(sp)
    800023c0:	6121                	addi	sp,sp,64
    800023c2:	8082                	ret
    return -1;
    800023c4:	597d                	li	s2,-1
    800023c6:	bfc5                	j	800023b6 <fork+0x122>

00000000800023c8 <free_process_priority>:

//rearanges the control structure
//updating the linked list
int free_process_priority(struct proc *p){
    800023c8:	1141                	addi	sp,sp,-16
    800023ca:	e422                	sd	s0,8(sp)
    800023cc:	0800                	addi	s0,sp,16

  struct proc *p_aux;

  p_aux = p_control.head_priority[p->priority];
    800023ce:	17052703          	lw	a4,368(a0)
    800023d2:	02071693          	slli	a3,a4,0x20
    800023d6:	01d6d793          	srli	a5,a3,0x1d
    800023da:	0000e697          	auipc	a3,0xe
    800023de:	69668693          	addi	a3,a3,1686 # 80010a70 <bcache+0x3c8>
    800023e2:	97b6                	add	a5,a5,a3
    800023e4:	bd07b783          	ld	a5,-1072(a5)

  if(p_aux == p){
    800023e8:	02f50163          	beq	a0,a5,8000240a <free_process_priority+0x42>
      p_control.head_priority[p->priority] = p->next_p_priority;  
      p->next_p_priority = NULL;
    }
  }
  else{
    while(p_aux->next_p_priority != p){
    800023ec:	873e                	mv	a4,a5
    800023ee:	1787b783          	ld	a5,376(a5)
    800023f2:	fea79de3          	bne	a5,a0,800023ec <free_process_priority+0x24>
      p_aux = p_aux->next_p_priority;
    }
    p_aux->next_p_priority = p->next_p_priority;
    800023f6:	17853783          	ld	a5,376(a0)
    800023fa:	16f73c23          	sd	a5,376(a4)
    p->next_p_priority = NULL;
    800023fe:	16053c23          	sd	zero,376(a0)
  }
  
  return 0;
}
    80002402:	4501                	li	a0,0
    80002404:	6422                	ld	s0,8(sp)
    80002406:	0141                	addi	sp,sp,16
    80002408:	8082                	ret
    if(p->next_p_priority == NULL){
    8000240a:	1787b683          	ld	a3,376(a5)
    8000240e:	ce99                	beqz	a3,8000242c <free_process_priority+0x64>
      p_control.head_priority[p->priority] = p->next_p_priority;  
    80002410:	02071613          	slli	a2,a4,0x20
    80002414:	01d65713          	srli	a4,a2,0x1d
    80002418:	0000e617          	auipc	a2,0xe
    8000241c:	65860613          	addi	a2,a2,1624 # 80010a70 <bcache+0x3c8>
    80002420:	9732                	add	a4,a4,a2
    80002422:	bcd73823          	sd	a3,-1072(a4)
      p->next_p_priority = NULL;
    80002426:	1607bc23          	sd	zero,376(a5)
    8000242a:	bfe1                	j	80002402 <free_process_priority+0x3a>
      p_control.present[p->priority] = 0;
    8000242c:	0000e697          	auipc	a3,0xe
    80002430:	63468693          	addi	a3,a3,1588 # 80010a60 <bcache+0x3b8>
    80002434:	1702                	slli	a4,a4,0x20
    80002436:	9301                	srli	a4,a4,0x20
    80002438:	00271793          	slli	a5,a4,0x2
    8000243c:	97b6                	add	a5,a5,a3
    8000243e:	bc07a423          	sw	zero,-1080(a5)
      p_control.head_priority[p->priority] = NULL;
    80002442:	0709                	addi	a4,a4,2
    80002444:	00371793          	slli	a5,a4,0x3
    80002448:	96be                	add	a3,a3,a5
    8000244a:	bc06b823          	sd	zero,-1072(a3)
    8000244e:	bf55                	j	80002402 <free_process_priority+0x3a>

0000000080002450 <exit>:
{
    80002450:	7179                	addi	sp,sp,-48
    80002452:	f406                	sd	ra,40(sp)
    80002454:	f022                	sd	s0,32(sp)
    80002456:	ec26                	sd	s1,24(sp)
    80002458:	e84a                	sd	s2,16(sp)
    8000245a:	e44e                	sd	s3,8(sp)
    8000245c:	e052                	sd	s4,0(sp)
    8000245e:	1800                	addi	s0,sp,48
    80002460:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002462:	c62ff0ef          	jal	800018c4 <myproc>
    80002466:	89aa                	mv	s3,a0
  if(p == initproc)
    80002468:	00005797          	auipc	a5,0x5
    8000246c:	4c07b783          	ld	a5,1216(a5) # 80007928 <initproc>
    80002470:	0d850493          	addi	s1,a0,216
    80002474:	15850913          	addi	s2,a0,344
    80002478:	00a79f63          	bne	a5,a0,80002496 <exit+0x46>
    panic("init exiting");
    8000247c:	00005517          	auipc	a0,0x5
    80002480:	e4450513          	addi	a0,a0,-444 # 800072c0 <etext+0x2c0>
    80002484:	b10fe0ef          	jal	80000794 <panic>
      fileclose(f);
    80002488:	385010ef          	jal	8000400c <fileclose>
      p->ofile[fd] = 0;
    8000248c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002490:	04a1                	addi	s1,s1,8
    80002492:	01248563          	beq	s1,s2,8000249c <exit+0x4c>
    if(p->ofile[fd]){
    80002496:	6088                	ld	a0,0(s1)
    80002498:	f965                	bnez	a0,80002488 <exit+0x38>
    8000249a:	bfdd                	j	80002490 <exit+0x40>
  begin_op();
    8000249c:	756010ef          	jal	80003bf2 <begin_op>
  iput(p->cwd);
    800024a0:	1589b503          	ld	a0,344(s3)
    800024a4:	03a010ef          	jal	800034de <iput>
  end_op();
    800024a8:	7b4010ef          	jal	80003c5c <end_op>
  p->cwd = 0;
    800024ac:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800024b0:	0000e497          	auipc	s1,0xe
    800024b4:	d4848493          	addi	s1,s1,-696 # 800101f8 <wait_lock>
    800024b8:	8526                	mv	a0,s1
    800024ba:	f3cfe0ef          	jal	80000bf6 <acquire>
  reparent(p);
    800024be:	854e                	mv	a0,s3
    800024c0:	85bff0ef          	jal	80001d1a <reparent>
  wakeup(p->parent);
    800024c4:	0389b503          	ld	a0,56(s3)
    800024c8:	feeff0ef          	jal	80001cb6 <wakeup>
  acquire(&p->lock);
    800024cc:	854e                	mv	a0,s3
    800024ce:	f28fe0ef          	jal	80000bf6 <acquire>
  p->xstate = status;
    800024d2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800024d6:	4795                	li	a5,5
    800024d8:	00f9ac23          	sw	a5,24(s3)
  acquire(&priority_lock);
    800024dc:	0000e917          	auipc	s2,0xe
    800024e0:	13490913          	addi	s2,s2,308 # 80010610 <priority_lock>
    800024e4:	854a                	mv	a0,s2
    800024e6:	f10fe0ef          	jal	80000bf6 <acquire>
  free_process_priority(p);
    800024ea:	854e                	mv	a0,s3
    800024ec:	eddff0ef          	jal	800023c8 <free_process_priority>
  release(&priority_lock);
    800024f0:	854a                	mv	a0,s2
    800024f2:	f9cfe0ef          	jal	80000c8e <release>
  release(&wait_lock);
    800024f6:	8526                	mv	a0,s1
    800024f8:	f96fe0ef          	jal	80000c8e <release>
  sched();
    800024fc:	e7aff0ef          	jal	80001b76 <sched>
  panic("zombie exit");
    80002500:	00005517          	auipc	a0,0x5
    80002504:	dd050513          	addi	a0,a0,-560 # 800072d0 <etext+0x2d0>
    80002508:	a8cfe0ef          	jal	80000794 <panic>

000000008000250c <swtch>:
    8000250c:	00153023          	sd	ra,0(a0)
    80002510:	00253423          	sd	sp,8(a0)
    80002514:	e900                	sd	s0,16(a0)
    80002516:	ed04                	sd	s1,24(a0)
    80002518:	03253023          	sd	s2,32(a0)
    8000251c:	03353423          	sd	s3,40(a0)
    80002520:	03453823          	sd	s4,48(a0)
    80002524:	03553c23          	sd	s5,56(a0)
    80002528:	05653023          	sd	s6,64(a0)
    8000252c:	05753423          	sd	s7,72(a0)
    80002530:	05853823          	sd	s8,80(a0)
    80002534:	05953c23          	sd	s9,88(a0)
    80002538:	07a53023          	sd	s10,96(a0)
    8000253c:	07b53423          	sd	s11,104(a0)
    80002540:	0005b083          	ld	ra,0(a1)
    80002544:	0085b103          	ld	sp,8(a1)
    80002548:	6980                	ld	s0,16(a1)
    8000254a:	6d84                	ld	s1,24(a1)
    8000254c:	0205b903          	ld	s2,32(a1)
    80002550:	0285b983          	ld	s3,40(a1)
    80002554:	0305ba03          	ld	s4,48(a1)
    80002558:	0385ba83          	ld	s5,56(a1)
    8000255c:	0405bb03          	ld	s6,64(a1)
    80002560:	0485bb83          	ld	s7,72(a1)
    80002564:	0505bc03          	ld	s8,80(a1)
    80002568:	0585bc83          	ld	s9,88(a1)
    8000256c:	0605bd03          	ld	s10,96(a1)
    80002570:	0685bd83          	ld	s11,104(a1)
    80002574:	8082                	ret

0000000080002576 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002576:	1141                	addi	sp,sp,-16
    80002578:	e406                	sd	ra,8(sp)
    8000257a:	e022                	sd	s0,0(sp)
    8000257c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000257e:	00005597          	auipc	a1,0x5
    80002582:	d9258593          	addi	a1,a1,-622 # 80007310 <etext+0x310>
    80002586:	0000e517          	auipc	a0,0xe
    8000258a:	10a50513          	addi	a0,a0,266 # 80010690 <tickslock>
    8000258e:	de8fe0ef          	jal	80000b76 <initlock>
}
    80002592:	60a2                	ld	ra,8(sp)
    80002594:	6402                	ld	s0,0(sp)
    80002596:	0141                	addi	sp,sp,16
    80002598:	8082                	ret

000000008000259a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000259a:	1141                	addi	sp,sp,-16
    8000259c:	e422                	sd	s0,8(sp)
    8000259e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025a0:	00003797          	auipc	a5,0x3
    800025a4:	de078793          	addi	a5,a5,-544 # 80005380 <kernelvec>
    800025a8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800025ac:	6422                	ld	s0,8(sp)
    800025ae:	0141                	addi	sp,sp,16
    800025b0:	8082                	ret

00000000800025b2 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800025b2:	1141                	addi	sp,sp,-16
    800025b4:	e406                	sd	ra,8(sp)
    800025b6:	e022                	sd	s0,0(sp)
    800025b8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800025ba:	b0aff0ef          	jal	800018c4 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025be:	10002773          	csrr	a4,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800025c2:	9b75                	andi	a4,a4,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025c4:	10071073          	csrw	sstatus,a4
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = (uint64)trampoline + (uservec - trampoline);
    800025c8:	00004717          	auipc	a4,0x4
    800025cc:	a3870713          	addi	a4,a4,-1480 # 80006000 <_trampoline>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025d0:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800025d4:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800025d6:	180026f3          	csrr	a3,satp
    800025da:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800025dc:	7134                	ld	a3,96(a0)
    800025de:	6138                	ld	a4,64(a0)
    800025e0:	6605                	lui	a2,0x1
    800025e2:	9732                	add	a4,a4,a2
    800025e4:	e698                	sd	a4,8(a3)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800025e6:	7138                	ld	a4,96(a0)
    800025e8:	00000697          	auipc	a3,0x0
    800025ec:	10c68693          	addi	a3,a3,268 # 800026f4 <usertrap>
    800025f0:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800025f2:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800025f4:	8692                	mv	a3,tp
    800025f6:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025f8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800025fc:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002600:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002604:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002608:	713c                	ld	a5,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000260a:	6f9c                	ld	a5,24(a5)
    8000260c:	14179073          	csrw	sepc,a5

  // tell trampoline.S the user page table to switch to.
  //uint64 satp = 0;//MAKE_SATP(p->pagetable);
  struct trapframe* trapframe = get_trapframe(p); //PROCESS_TRAPFRAME(p - proc);
    80002610:	b5eff0ef          	jal	8000196e <get_trapframe>

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = (uint64)trampoline + (userret - trampoline);
  ((void (*)(struct trapframe*))trampoline_userret)(trapframe);
    80002614:	287030ef          	jal	8000609a <userret>
}
    80002618:	60a2                	ld	ra,8(sp)
    8000261a:	6402                	ld	s0,0(sp)
    8000261c:	0141                	addi	sp,sp,16
    8000261e:	8082                	ret

0000000080002620 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002620:	1101                	addi	sp,sp,-32
    80002622:	ec06                	sd	ra,24(sp)
    80002624:	e822                	sd	s0,16(sp)
    80002626:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002628:	a70ff0ef          	jal	80001898 <cpuid>
    8000262c:	c505                	beqz	a0,80002654 <clockintr+0x34>
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  printf("Timer\n");
    8000262e:	00005517          	auipc	a0,0x5
    80002632:	cea50513          	addi	a0,a0,-790 # 80007318 <etext+0x318>
    80002636:	e8dfd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000263a:	c01027f3          	rdtime	a5
  w_stimecmp(r_time() + 1000000);
    8000263e:	000f4737          	lui	a4,0xf4
    80002642:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002646:	97ba                	add	a5,a5,a4
  asm volatile("csrw stimecmp, %0" : : "r" (x));
    80002648:	14d79073          	csrw	stimecmp,a5
}
    8000264c:	60e2                	ld	ra,24(sp)
    8000264e:	6442                	ld	s0,16(sp)
    80002650:	6105                	addi	sp,sp,32
    80002652:	8082                	ret
    80002654:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80002656:	0000e497          	auipc	s1,0xe
    8000265a:	03a48493          	addi	s1,s1,58 # 80010690 <tickslock>
    8000265e:	8526                	mv	a0,s1
    80002660:	d96fe0ef          	jal	80000bf6 <acquire>
    ticks++;
    80002664:	00005517          	auipc	a0,0x5
    80002668:	2cc50513          	addi	a0,a0,716 # 80007930 <ticks>
    8000266c:	411c                	lw	a5,0(a0)
    8000266e:	2785                	addiw	a5,a5,1
    80002670:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002672:	e44ff0ef          	jal	80001cb6 <wakeup>
    release(&tickslock);
    80002676:	8526                	mv	a0,s1
    80002678:	e16fe0ef          	jal	80000c8e <release>
    8000267c:	64a2                	ld	s1,8(sp)
    8000267e:	bf45                	j	8000262e <clockintr+0xe>

0000000080002680 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002680:	1101                	addi	sp,sp,-32
    80002682:	ec06                	sd	ra,24(sp)
    80002684:	e822                	sd	s0,16(sp)
    80002686:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002688:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000268c:	57fd                	li	a5,-1
    8000268e:	17fe                	slli	a5,a5,0x3f
    80002690:	07a5                	addi	a5,a5,9
    80002692:	00f70c63          	beq	a4,a5,800026aa <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002696:	57fd                	li	a5,-1
    80002698:	17fe                	slli	a5,a5,0x3f
    8000269a:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000269c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000269e:	04f70763          	beq	a4,a5,800026ec <devintr+0x6c>
  }
}
    800026a2:	60e2                	ld	ra,24(sp)
    800026a4:	6442                	ld	s0,16(sp)
    800026a6:	6105                	addi	sp,sp,32
    800026a8:	8082                	ret
    800026aa:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800026ac:	581020ef          	jal	8000542c <plic_claim>
    800026b0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800026b2:	47a9                	li	a5,10
    800026b4:	00f50963          	beq	a0,a5,800026c6 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800026b8:	4785                	li	a5,1
    800026ba:	00f50963          	beq	a0,a5,800026cc <devintr+0x4c>
    return 1;
    800026be:	4505                	li	a0,1
    } else if(irq){
    800026c0:	e889                	bnez	s1,800026d2 <devintr+0x52>
    800026c2:	64a2                	ld	s1,8(sp)
    800026c4:	bff9                	j	800026a2 <devintr+0x22>
      uartintr();
    800026c6:	b40fe0ef          	jal	80000a06 <uartintr>
    if(irq)
    800026ca:	a819                	j	800026e0 <devintr+0x60>
      virtio_disk_intr();
    800026cc:	226030ef          	jal	800058f2 <virtio_disk_intr>
    if(irq)
    800026d0:	a801                	j	800026e0 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800026d2:	85a6                	mv	a1,s1
    800026d4:	00005517          	auipc	a0,0x5
    800026d8:	c4c50513          	addi	a0,a0,-948 # 80007320 <etext+0x320>
    800026dc:	de7fd0ef          	jal	800004c2 <printf>
      plic_complete(irq);
    800026e0:	8526                	mv	a0,s1
    800026e2:	56b020ef          	jal	8000544c <plic_complete>
    return 1;
    800026e6:	4505                	li	a0,1
    800026e8:	64a2                	ld	s1,8(sp)
    800026ea:	bf65                	j	800026a2 <devintr+0x22>
    clockintr();
    800026ec:	f35ff0ef          	jal	80002620 <clockintr>
    return 2;
    800026f0:	4509                	li	a0,2
    800026f2:	bf45                	j	800026a2 <devintr+0x22>

00000000800026f4 <usertrap>:
{
    800026f4:	1101                	addi	sp,sp,-32
    800026f6:	ec06                	sd	ra,24(sp)
    800026f8:	e822                	sd	s0,16(sp)
    800026fa:	e426                	sd	s1,8(sp)
    800026fc:	e04a                	sd	s2,0(sp)
    800026fe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002700:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002704:	1007f793          	andi	a5,a5,256
    80002708:	ef85                	bnez	a5,80002740 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000270a:	00003797          	auipc	a5,0x3
    8000270e:	c7678793          	addi	a5,a5,-906 # 80005380 <kernelvec>
    80002712:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002716:	9aeff0ef          	jal	800018c4 <myproc>
    8000271a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000271c:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000271e:	14102773          	csrr	a4,sepc
    80002722:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002724:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002728:	47a1                	li	a5,8
    8000272a:	02f70163          	beq	a4,a5,8000274c <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    8000272e:	f53ff0ef          	jal	80002680 <devintr>
    80002732:	892a                	mv	s2,a0
    80002734:	c135                	beqz	a0,80002798 <usertrap+0xa4>
  if(killed(p))
    80002736:	8526                	mv	a0,s1
    80002738:	ebaff0ef          	jal	80001df2 <killed>
    8000273c:	cd1d                	beqz	a0,8000277a <usertrap+0x86>
    8000273e:	a81d                	j	80002774 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80002740:	00005517          	auipc	a0,0x5
    80002744:	c0050513          	addi	a0,a0,-1024 # 80007340 <etext+0x340>
    80002748:	84cfe0ef          	jal	80000794 <panic>
    if(killed(p))
    8000274c:	ea6ff0ef          	jal	80001df2 <killed>
    80002750:	e121                	bnez	a0,80002790 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80002752:	70b8                	ld	a4,96(s1)
    80002754:	6f1c                	ld	a5,24(a4)
    80002756:	0791                	addi	a5,a5,4
    80002758:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000275a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000275e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002762:	10079073          	csrw	sstatus,a5
    syscall();
    80002766:	248000ef          	jal	800029ae <syscall>
  if(killed(p))
    8000276a:	8526                	mv	a0,s1
    8000276c:	e86ff0ef          	jal	80001df2 <killed>
    80002770:	c901                	beqz	a0,80002780 <usertrap+0x8c>
    80002772:	4901                	li	s2,0
    exit(-1);
    80002774:	557d                	li	a0,-1
    80002776:	cdbff0ef          	jal	80002450 <exit>
  if(which_dev == 2)
    8000277a:	4789                	li	a5,2
    8000277c:	04f90563          	beq	s2,a5,800027c6 <usertrap+0xd2>
  usertrapret();
    80002780:	e33ff0ef          	jal	800025b2 <usertrapret>
}
    80002784:	60e2                	ld	ra,24(sp)
    80002786:	6442                	ld	s0,16(sp)
    80002788:	64a2                	ld	s1,8(sp)
    8000278a:	6902                	ld	s2,0(sp)
    8000278c:	6105                	addi	sp,sp,32
    8000278e:	8082                	ret
      exit(-1);
    80002790:	557d                	li	a0,-1
    80002792:	cbfff0ef          	jal	80002450 <exit>
    80002796:	bf75                	j	80002752 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002798:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000279c:	5890                	lw	a2,48(s1)
    8000279e:	00005517          	auipc	a0,0x5
    800027a2:	bc250513          	addi	a0,a0,-1086 # 80007360 <etext+0x360>
    800027a6:	d1dfd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027aa:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800027ae:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800027b2:	00005517          	auipc	a0,0x5
    800027b6:	bde50513          	addi	a0,a0,-1058 # 80007390 <etext+0x390>
    800027ba:	d09fd0ef          	jal	800004c2 <printf>
    setkilled(p);
    800027be:	8526                	mv	a0,s1
    800027c0:	e0eff0ef          	jal	80001dce <setkilled>
    800027c4:	b75d                	j	8000276a <usertrap+0x76>
    yield();
    800027c6:	c78ff0ef          	jal	80001c3e <yield>
    800027ca:	bf5d                	j	80002780 <usertrap+0x8c>

00000000800027cc <kerneltrap>:
{
    800027cc:	7179                	addi	sp,sp,-48
    800027ce:	f406                	sd	ra,40(sp)
    800027d0:	f022                	sd	s0,32(sp)
    800027d2:	ec26                	sd	s1,24(sp)
    800027d4:	e84a                	sd	s2,16(sp)
    800027d6:	e44e                	sd	s3,8(sp)
    800027d8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027da:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027de:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027e2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800027e6:	1004f793          	andi	a5,s1,256
    800027ea:	c795                	beqz	a5,80002816 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ec:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800027f0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800027f2:	eb85                	bnez	a5,80002822 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    800027f4:	e8dff0ef          	jal	80002680 <devintr>
    800027f8:	c91d                	beqz	a0,8000282e <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    800027fa:	4789                	li	a5,2
    800027fc:	04f50a63          	beq	a0,a5,80002850 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002800:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002804:	10049073          	csrw	sstatus,s1
}
    80002808:	70a2                	ld	ra,40(sp)
    8000280a:	7402                	ld	s0,32(sp)
    8000280c:	64e2                	ld	s1,24(sp)
    8000280e:	6942                	ld	s2,16(sp)
    80002810:	69a2                	ld	s3,8(sp)
    80002812:	6145                	addi	sp,sp,48
    80002814:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002816:	00005517          	auipc	a0,0x5
    8000281a:	ba250513          	addi	a0,a0,-1118 # 800073b8 <etext+0x3b8>
    8000281e:	f77fd0ef          	jal	80000794 <panic>
    panic("kerneltrap: interrupts enabled");
    80002822:	00005517          	auipc	a0,0x5
    80002826:	bbe50513          	addi	a0,a0,-1090 # 800073e0 <etext+0x3e0>
    8000282a:	f6bfd0ef          	jal	80000794 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000282e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002832:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002836:	85ce                	mv	a1,s3
    80002838:	00005517          	auipc	a0,0x5
    8000283c:	bc850513          	addi	a0,a0,-1080 # 80007400 <etext+0x400>
    80002840:	c83fd0ef          	jal	800004c2 <printf>
    panic("kerneltrap");
    80002844:	00005517          	auipc	a0,0x5
    80002848:	be450513          	addi	a0,a0,-1052 # 80007428 <etext+0x428>
    8000284c:	f49fd0ef          	jal	80000794 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002850:	874ff0ef          	jal	800018c4 <myproc>
    80002854:	d555                	beqz	a0,80002800 <kerneltrap+0x34>
    yield();
    80002856:	be8ff0ef          	jal	80001c3e <yield>
    8000285a:	b75d                	j	80002800 <kerneltrap+0x34>

000000008000285c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000285c:	1101                	addi	sp,sp,-32
    8000285e:	ec06                	sd	ra,24(sp)
    80002860:	e822                	sd	s0,16(sp)
    80002862:	e426                	sd	s1,8(sp)
    80002864:	1000                	addi	s0,sp,32
    80002866:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002868:	85cff0ef          	jal	800018c4 <myproc>
  switch (n) {
    8000286c:	4795                	li	a5,5
    8000286e:	0497e163          	bltu	a5,s1,800028b0 <argraw+0x54>
    80002872:	048a                	slli	s1,s1,0x2
    80002874:	00005717          	auipc	a4,0x5
    80002878:	f7470713          	addi	a4,a4,-140 # 800077e8 <states.0+0x30>
    8000287c:	94ba                	add	s1,s1,a4
    8000287e:	409c                	lw	a5,0(s1)
    80002880:	97ba                	add	a5,a5,a4
    80002882:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002884:	713c                	ld	a5,96(a0)
    80002886:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002888:	60e2                	ld	ra,24(sp)
    8000288a:	6442                	ld	s0,16(sp)
    8000288c:	64a2                	ld	s1,8(sp)
    8000288e:	6105                	addi	sp,sp,32
    80002890:	8082                	ret
    return p->trapframe->a1;
    80002892:	713c                	ld	a5,96(a0)
    80002894:	7fa8                	ld	a0,120(a5)
    80002896:	bfcd                	j	80002888 <argraw+0x2c>
    return p->trapframe->a2;
    80002898:	713c                	ld	a5,96(a0)
    8000289a:	63c8                	ld	a0,128(a5)
    8000289c:	b7f5                	j	80002888 <argraw+0x2c>
    return p->trapframe->a3;
    8000289e:	713c                	ld	a5,96(a0)
    800028a0:	67c8                	ld	a0,136(a5)
    800028a2:	b7dd                	j	80002888 <argraw+0x2c>
    return p->trapframe->a4;
    800028a4:	713c                	ld	a5,96(a0)
    800028a6:	6bc8                	ld	a0,144(a5)
    800028a8:	b7c5                	j	80002888 <argraw+0x2c>
    return p->trapframe->a5;
    800028aa:	713c                	ld	a5,96(a0)
    800028ac:	6fc8                	ld	a0,152(a5)
    800028ae:	bfe9                	j	80002888 <argraw+0x2c>
  panic("argraw");
    800028b0:	00005517          	auipc	a0,0x5
    800028b4:	b8850513          	addi	a0,a0,-1144 # 80007438 <etext+0x438>
    800028b8:	eddfd0ef          	jal	80000794 <panic>

00000000800028bc <fetchaddr>:
{
    800028bc:	1101                	addi	sp,sp,-32
    800028be:	ec06                	sd	ra,24(sp)
    800028c0:	e822                	sd	s0,16(sp)
    800028c2:	e426                	sd	s1,8(sp)
    800028c4:	e04a                	sd	s2,0(sp)
    800028c6:	1000                	addi	s0,sp,32
    800028c8:	84aa                	mv	s1,a0
    800028ca:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800028cc:	ff9fe0ef          	jal	800018c4 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800028d0:	653c                	ld	a5,72(a0)
    800028d2:	02f4f663          	bgeu	s1,a5,800028fe <fetchaddr+0x42>
    800028d6:	00848713          	addi	a4,s1,8
    800028da:	02e7e463          	bltu	a5,a4,80002902 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800028de:	46a1                	li	a3,8
    800028e0:	8626                	mv	a2,s1
    800028e2:	85ca                	mv	a1,s2
    800028e4:	6928                	ld	a0,80(a0)
    800028e6:	d19fe0ef          	jal	800015fe <copyin>
    800028ea:	00a03533          	snez	a0,a0
    800028ee:	40a00533          	neg	a0,a0
}
    800028f2:	60e2                	ld	ra,24(sp)
    800028f4:	6442                	ld	s0,16(sp)
    800028f6:	64a2                	ld	s1,8(sp)
    800028f8:	6902                	ld	s2,0(sp)
    800028fa:	6105                	addi	sp,sp,32
    800028fc:	8082                	ret
    return -1;
    800028fe:	557d                	li	a0,-1
    80002900:	bfcd                	j	800028f2 <fetchaddr+0x36>
    80002902:	557d                	li	a0,-1
    80002904:	b7fd                	j	800028f2 <fetchaddr+0x36>

0000000080002906 <fetchstr>:
{
    80002906:	7179                	addi	sp,sp,-48
    80002908:	f406                	sd	ra,40(sp)
    8000290a:	f022                	sd	s0,32(sp)
    8000290c:	ec26                	sd	s1,24(sp)
    8000290e:	e84a                	sd	s2,16(sp)
    80002910:	e44e                	sd	s3,8(sp)
    80002912:	1800                	addi	s0,sp,48
    80002914:	892a                	mv	s2,a0
    80002916:	84ae                	mv	s1,a1
    80002918:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000291a:	fabfe0ef          	jal	800018c4 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000291e:	86ce                	mv	a3,s3
    80002920:	864a                	mv	a2,s2
    80002922:	85a6                	mv	a1,s1
    80002924:	6928                	ld	a0,80(a0)
    80002926:	d5ffe0ef          	jal	80001684 <copyinstr>
    8000292a:	00054c63          	bltz	a0,80002942 <fetchstr+0x3c>
  return strlen(buf);
    8000292e:	8526                	mv	a0,s1
    80002930:	d0afe0ef          	jal	80000e3a <strlen>
}
    80002934:	70a2                	ld	ra,40(sp)
    80002936:	7402                	ld	s0,32(sp)
    80002938:	64e2                	ld	s1,24(sp)
    8000293a:	6942                	ld	s2,16(sp)
    8000293c:	69a2                	ld	s3,8(sp)
    8000293e:	6145                	addi	sp,sp,48
    80002940:	8082                	ret
    return -1;
    80002942:	557d                	li	a0,-1
    80002944:	bfc5                	j	80002934 <fetchstr+0x2e>

0000000080002946 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002946:	1101                	addi	sp,sp,-32
    80002948:	ec06                	sd	ra,24(sp)
    8000294a:	e822                	sd	s0,16(sp)
    8000294c:	e426                	sd	s1,8(sp)
    8000294e:	1000                	addi	s0,sp,32
    80002950:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002952:	f0bff0ef          	jal	8000285c <argraw>
    80002956:	c088                	sw	a0,0(s1)
}
    80002958:	60e2                	ld	ra,24(sp)
    8000295a:	6442                	ld	s0,16(sp)
    8000295c:	64a2                	ld	s1,8(sp)
    8000295e:	6105                	addi	sp,sp,32
    80002960:	8082                	ret

0000000080002962 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002962:	1101                	addi	sp,sp,-32
    80002964:	ec06                	sd	ra,24(sp)
    80002966:	e822                	sd	s0,16(sp)
    80002968:	e426                	sd	s1,8(sp)
    8000296a:	1000                	addi	s0,sp,32
    8000296c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000296e:	eefff0ef          	jal	8000285c <argraw>
    80002972:	e088                	sd	a0,0(s1)
}
    80002974:	60e2                	ld	ra,24(sp)
    80002976:	6442                	ld	s0,16(sp)
    80002978:	64a2                	ld	s1,8(sp)
    8000297a:	6105                	addi	sp,sp,32
    8000297c:	8082                	ret

000000008000297e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000297e:	7179                	addi	sp,sp,-48
    80002980:	f406                	sd	ra,40(sp)
    80002982:	f022                	sd	s0,32(sp)
    80002984:	ec26                	sd	s1,24(sp)
    80002986:	e84a                	sd	s2,16(sp)
    80002988:	1800                	addi	s0,sp,48
    8000298a:	84ae                	mv	s1,a1
    8000298c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000298e:	fd840593          	addi	a1,s0,-40
    80002992:	fd1ff0ef          	jal	80002962 <argaddr>
  return fetchstr(addr, buf, max);
    80002996:	864a                	mv	a2,s2
    80002998:	85a6                	mv	a1,s1
    8000299a:	fd843503          	ld	a0,-40(s0)
    8000299e:	f69ff0ef          	jal	80002906 <fetchstr>
}
    800029a2:	70a2                	ld	ra,40(sp)
    800029a4:	7402                	ld	s0,32(sp)
    800029a6:	64e2                	ld	s1,24(sp)
    800029a8:	6942                	ld	s2,16(sp)
    800029aa:	6145                	addi	sp,sp,48
    800029ac:	8082                	ret

00000000800029ae <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800029ae:	1101                	addi	sp,sp,-32
    800029b0:	ec06                	sd	ra,24(sp)
    800029b2:	e822                	sd	s0,16(sp)
    800029b4:	e426                	sd	s1,8(sp)
    800029b6:	e04a                	sd	s2,0(sp)
    800029b8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800029ba:	f0bfe0ef          	jal	800018c4 <myproc>
    800029be:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800029c0:	06053903          	ld	s2,96(a0)
    800029c4:	0a893783          	ld	a5,168(s2)
    800029c8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800029cc:	37fd                	addiw	a5,a5,-1
    800029ce:	4751                	li	a4,20
    800029d0:	00f76f63          	bltu	a4,a5,800029ee <syscall+0x40>
    800029d4:	00369713          	slli	a4,a3,0x3
    800029d8:	00005797          	auipc	a5,0x5
    800029dc:	e2878793          	addi	a5,a5,-472 # 80007800 <syscalls>
    800029e0:	97ba                	add	a5,a5,a4
    800029e2:	639c                	ld	a5,0(a5)
    800029e4:	c789                	beqz	a5,800029ee <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800029e6:	9782                	jalr	a5
    800029e8:	06a93823          	sd	a0,112(s2)
    800029ec:	a829                	j	80002a06 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800029ee:	16048613          	addi	a2,s1,352
    800029f2:	588c                	lw	a1,48(s1)
    800029f4:	00005517          	auipc	a0,0x5
    800029f8:	a4c50513          	addi	a0,a0,-1460 # 80007440 <etext+0x440>
    800029fc:	ac7fd0ef          	jal	800004c2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002a00:	70bc                	ld	a5,96(s1)
    80002a02:	577d                	li	a4,-1
    80002a04:	fbb8                	sd	a4,112(a5)
  }
}
    80002a06:	60e2                	ld	ra,24(sp)
    80002a08:	6442                	ld	s0,16(sp)
    80002a0a:	64a2                	ld	s1,8(sp)
    80002a0c:	6902                	ld	s2,0(sp)
    80002a0e:	6105                	addi	sp,sp,32
    80002a10:	8082                	ret

0000000080002a12 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002a12:	1101                	addi	sp,sp,-32
    80002a14:	ec06                	sd	ra,24(sp)
    80002a16:	e822                	sd	s0,16(sp)
    80002a18:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002a1a:	fec40593          	addi	a1,s0,-20
    80002a1e:	4501                	li	a0,0
    80002a20:	f27ff0ef          	jal	80002946 <argint>
  exit(n);
    80002a24:	fec42503          	lw	a0,-20(s0)
    80002a28:	a29ff0ef          	jal	80002450 <exit>
  return 0;  // not reached
}
    80002a2c:	4501                	li	a0,0
    80002a2e:	60e2                	ld	ra,24(sp)
    80002a30:	6442                	ld	s0,16(sp)
    80002a32:	6105                	addi	sp,sp,32
    80002a34:	8082                	ret

0000000080002a36 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002a36:	1141                	addi	sp,sp,-16
    80002a38:	e406                	sd	ra,8(sp)
    80002a3a:	e022                	sd	s0,0(sp)
    80002a3c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002a3e:	e87fe0ef          	jal	800018c4 <myproc>
}
    80002a42:	5908                	lw	a0,48(a0)
    80002a44:	60a2                	ld	ra,8(sp)
    80002a46:	6402                	ld	s0,0(sp)
    80002a48:	0141                	addi	sp,sp,16
    80002a4a:	8082                	ret

0000000080002a4c <sys_fork>:

uint64
sys_fork(void)
{
    80002a4c:	1141                	addi	sp,sp,-16
    80002a4e:	e406                	sd	ra,8(sp)
    80002a50:	e022                	sd	s0,0(sp)
    80002a52:	0800                	addi	s0,sp,16
  return fork();
    80002a54:	841ff0ef          	jal	80002294 <fork>
}
    80002a58:	60a2                	ld	ra,8(sp)
    80002a5a:	6402                	ld	s0,0(sp)
    80002a5c:	0141                	addi	sp,sp,16
    80002a5e:	8082                	ret

0000000080002a60 <sys_wait>:

uint64
sys_wait(void)
{
    80002a60:	1101                	addi	sp,sp,-32
    80002a62:	ec06                	sd	ra,24(sp)
    80002a64:	e822                	sd	s0,16(sp)
    80002a66:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002a68:	fe840593          	addi	a1,s0,-24
    80002a6c:	4501                	li	a0,0
    80002a6e:	ef5ff0ef          	jal	80002962 <argaddr>
  return wait(p);
    80002a72:	fe843503          	ld	a0,-24(s0)
    80002a76:	ba6ff0ef          	jal	80001e1c <wait>
}
    80002a7a:	60e2                	ld	ra,24(sp)
    80002a7c:	6442                	ld	s0,16(sp)
    80002a7e:	6105                	addi	sp,sp,32
    80002a80:	8082                	ret

0000000080002a82 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002a82:	1101                	addi	sp,sp,-32
    80002a84:	ec06                	sd	ra,24(sp)
    80002a86:	e822                	sd	s0,16(sp)
    80002a88:	1000                	addi	s0,sp,32
  uint64 addr;
  int n;

  argint(0, &n);
    80002a8a:	fec40593          	addi	a1,s0,-20
    80002a8e:	4501                	li	a0,0
    80002a90:	eb7ff0ef          	jal	80002946 <argint>
  addr = myproc()->sz;
    80002a94:	e31fe0ef          	jal	800018c4 <myproc>
  //if(growproc(n) < 0)
  //  return -1;
  return addr;
}
    80002a98:	6528                	ld	a0,72(a0)
    80002a9a:	60e2                	ld	ra,24(sp)
    80002a9c:	6442                	ld	s0,16(sp)
    80002a9e:	6105                	addi	sp,sp,32
    80002aa0:	8082                	ret

0000000080002aa2 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002aa2:	7139                	addi	sp,sp,-64
    80002aa4:	fc06                	sd	ra,56(sp)
    80002aa6:	f822                	sd	s0,48(sp)
    80002aa8:	f04a                	sd	s2,32(sp)
    80002aaa:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002aac:	fcc40593          	addi	a1,s0,-52
    80002ab0:	4501                	li	a0,0
    80002ab2:	e95ff0ef          	jal	80002946 <argint>
  if(n < 0)
    80002ab6:	fcc42783          	lw	a5,-52(s0)
    80002aba:	0607c763          	bltz	a5,80002b28 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002abe:	0000e517          	auipc	a0,0xe
    80002ac2:	bd250513          	addi	a0,a0,-1070 # 80010690 <tickslock>
    80002ac6:	930fe0ef          	jal	80000bf6 <acquire>
  ticks0 = ticks;
    80002aca:	00005917          	auipc	s2,0x5
    80002ace:	e6692903          	lw	s2,-410(s2) # 80007930 <ticks>
  while(ticks - ticks0 < n){
    80002ad2:	fcc42783          	lw	a5,-52(s0)
    80002ad6:	cf8d                	beqz	a5,80002b10 <sys_sleep+0x6e>
    80002ad8:	f426                	sd	s1,40(sp)
    80002ada:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002adc:	0000e997          	auipc	s3,0xe
    80002ae0:	bb498993          	addi	s3,s3,-1100 # 80010690 <tickslock>
    80002ae4:	00005497          	auipc	s1,0x5
    80002ae8:	e4c48493          	addi	s1,s1,-436 # 80007930 <ticks>
    if(killed(myproc())){
    80002aec:	dd9fe0ef          	jal	800018c4 <myproc>
    80002af0:	b02ff0ef          	jal	80001df2 <killed>
    80002af4:	ed0d                	bnez	a0,80002b2e <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002af6:	85ce                	mv	a1,s3
    80002af8:	8526                	mv	a0,s1
    80002afa:	970ff0ef          	jal	80001c6a <sleep>
  while(ticks - ticks0 < n){
    80002afe:	409c                	lw	a5,0(s1)
    80002b00:	412787bb          	subw	a5,a5,s2
    80002b04:	fcc42703          	lw	a4,-52(s0)
    80002b08:	fee7e2e3          	bltu	a5,a4,80002aec <sys_sleep+0x4a>
    80002b0c:	74a2                	ld	s1,40(sp)
    80002b0e:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002b10:	0000e517          	auipc	a0,0xe
    80002b14:	b8050513          	addi	a0,a0,-1152 # 80010690 <tickslock>
    80002b18:	976fe0ef          	jal	80000c8e <release>
  return 0;
    80002b1c:	4501                	li	a0,0
}
    80002b1e:	70e2                	ld	ra,56(sp)
    80002b20:	7442                	ld	s0,48(sp)
    80002b22:	7902                	ld	s2,32(sp)
    80002b24:	6121                	addi	sp,sp,64
    80002b26:	8082                	ret
    n = 0;
    80002b28:	fc042623          	sw	zero,-52(s0)
    80002b2c:	bf49                	j	80002abe <sys_sleep+0x1c>
      release(&tickslock);
    80002b2e:	0000e517          	auipc	a0,0xe
    80002b32:	b6250513          	addi	a0,a0,-1182 # 80010690 <tickslock>
    80002b36:	958fe0ef          	jal	80000c8e <release>
      return -1;
    80002b3a:	557d                	li	a0,-1
    80002b3c:	74a2                	ld	s1,40(sp)
    80002b3e:	69e2                	ld	s3,24(sp)
    80002b40:	bff9                	j	80002b1e <sys_sleep+0x7c>

0000000080002b42 <sys_kill>:

uint64
sys_kill(void)
{
    80002b42:	1101                	addi	sp,sp,-32
    80002b44:	ec06                	sd	ra,24(sp)
    80002b46:	e822                	sd	s0,16(sp)
    80002b48:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002b4a:	fec40593          	addi	a1,s0,-20
    80002b4e:	4501                	li	a0,0
    80002b50:	df7ff0ef          	jal	80002946 <argint>
  return kill(pid);
    80002b54:	fec42503          	lw	a0,-20(s0)
    80002b58:	a10ff0ef          	jal	80001d68 <kill>
}
    80002b5c:	60e2                	ld	ra,24(sp)
    80002b5e:	6442                	ld	s0,16(sp)
    80002b60:	6105                	addi	sp,sp,32
    80002b62:	8082                	ret

0000000080002b64 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002b64:	1101                	addi	sp,sp,-32
    80002b66:	ec06                	sd	ra,24(sp)
    80002b68:	e822                	sd	s0,16(sp)
    80002b6a:	e426                	sd	s1,8(sp)
    80002b6c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002b6e:	0000e517          	auipc	a0,0xe
    80002b72:	b2250513          	addi	a0,a0,-1246 # 80010690 <tickslock>
    80002b76:	880fe0ef          	jal	80000bf6 <acquire>
  xticks = ticks;
    80002b7a:	00005497          	auipc	s1,0x5
    80002b7e:	db64a483          	lw	s1,-586(s1) # 80007930 <ticks>
  release(&tickslock);
    80002b82:	0000e517          	auipc	a0,0xe
    80002b86:	b0e50513          	addi	a0,a0,-1266 # 80010690 <tickslock>
    80002b8a:	904fe0ef          	jal	80000c8e <release>
  return xticks;
}
    80002b8e:	02049513          	slli	a0,s1,0x20
    80002b92:	9101                	srli	a0,a0,0x20
    80002b94:	60e2                	ld	ra,24(sp)
    80002b96:	6442                	ld	s0,16(sp)
    80002b98:	64a2                	ld	s1,8(sp)
    80002b9a:	6105                	addi	sp,sp,32
    80002b9c:	8082                	ret

0000000080002b9e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002b9e:	7179                	addi	sp,sp,-48
    80002ba0:	f406                	sd	ra,40(sp)
    80002ba2:	f022                	sd	s0,32(sp)
    80002ba4:	ec26                	sd	s1,24(sp)
    80002ba6:	e84a                	sd	s2,16(sp)
    80002ba8:	e44e                	sd	s3,8(sp)
    80002baa:	e052                	sd	s4,0(sp)
    80002bac:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002bae:	00005597          	auipc	a1,0x5
    80002bb2:	8b258593          	addi	a1,a1,-1870 # 80007460 <etext+0x460>
    80002bb6:	0000e517          	auipc	a0,0xe
    80002bba:	af250513          	addi	a0,a0,-1294 # 800106a8 <bcache>
    80002bbe:	fb9fd0ef          	jal	80000b76 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002bc2:	00016797          	auipc	a5,0x16
    80002bc6:	ae678793          	addi	a5,a5,-1306 # 800186a8 <bcache+0x8000>
    80002bca:	00016717          	auipc	a4,0x16
    80002bce:	d4670713          	addi	a4,a4,-698 # 80018910 <bcache+0x8268>
    80002bd2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002bd6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002bda:	0000e497          	auipc	s1,0xe
    80002bde:	ae648493          	addi	s1,s1,-1306 # 800106c0 <bcache+0x18>
    b->next = bcache.head.next;
    80002be2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002be4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002be6:	00005a17          	auipc	s4,0x5
    80002bea:	882a0a13          	addi	s4,s4,-1918 # 80007468 <etext+0x468>
    b->next = bcache.head.next;
    80002bee:	2b893783          	ld	a5,696(s2)
    80002bf2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002bf4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002bf8:	85d2                	mv	a1,s4
    80002bfa:	01048513          	addi	a0,s1,16
    80002bfe:	248010ef          	jal	80003e46 <initsleeplock>
    bcache.head.next->prev = b;
    80002c02:	2b893783          	ld	a5,696(s2)
    80002c06:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002c08:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c0c:	45848493          	addi	s1,s1,1112
    80002c10:	fd349fe3          	bne	s1,s3,80002bee <binit+0x50>
  }
}
    80002c14:	70a2                	ld	ra,40(sp)
    80002c16:	7402                	ld	s0,32(sp)
    80002c18:	64e2                	ld	s1,24(sp)
    80002c1a:	6942                	ld	s2,16(sp)
    80002c1c:	69a2                	ld	s3,8(sp)
    80002c1e:	6a02                	ld	s4,0(sp)
    80002c20:	6145                	addi	sp,sp,48
    80002c22:	8082                	ret

0000000080002c24 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002c24:	7179                	addi	sp,sp,-48
    80002c26:	f406                	sd	ra,40(sp)
    80002c28:	f022                	sd	s0,32(sp)
    80002c2a:	ec26                	sd	s1,24(sp)
    80002c2c:	e84a                	sd	s2,16(sp)
    80002c2e:	e44e                	sd	s3,8(sp)
    80002c30:	1800                	addi	s0,sp,48
    80002c32:	892a                	mv	s2,a0
    80002c34:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002c36:	0000e517          	auipc	a0,0xe
    80002c3a:	a7250513          	addi	a0,a0,-1422 # 800106a8 <bcache>
    80002c3e:	fb9fd0ef          	jal	80000bf6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002c42:	00016497          	auipc	s1,0x16
    80002c46:	d1e4b483          	ld	s1,-738(s1) # 80018960 <bcache+0x82b8>
    80002c4a:	00016797          	auipc	a5,0x16
    80002c4e:	cc678793          	addi	a5,a5,-826 # 80018910 <bcache+0x8268>
    80002c52:	02f48b63          	beq	s1,a5,80002c88 <bread+0x64>
    80002c56:	873e                	mv	a4,a5
    80002c58:	a021                	j	80002c60 <bread+0x3c>
    80002c5a:	68a4                	ld	s1,80(s1)
    80002c5c:	02e48663          	beq	s1,a4,80002c88 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002c60:	449c                	lw	a5,8(s1)
    80002c62:	ff279ce3          	bne	a5,s2,80002c5a <bread+0x36>
    80002c66:	44dc                	lw	a5,12(s1)
    80002c68:	ff3799e3          	bne	a5,s3,80002c5a <bread+0x36>
      b->refcnt++;
    80002c6c:	40bc                	lw	a5,64(s1)
    80002c6e:	2785                	addiw	a5,a5,1
    80002c70:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c72:	0000e517          	auipc	a0,0xe
    80002c76:	a3650513          	addi	a0,a0,-1482 # 800106a8 <bcache>
    80002c7a:	814fe0ef          	jal	80000c8e <release>
      acquiresleep(&b->lock);
    80002c7e:	01048513          	addi	a0,s1,16
    80002c82:	1fa010ef          	jal	80003e7c <acquiresleep>
      return b;
    80002c86:	a889                	j	80002cd8 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c88:	00016497          	auipc	s1,0x16
    80002c8c:	cd04b483          	ld	s1,-816(s1) # 80018958 <bcache+0x82b0>
    80002c90:	00016797          	auipc	a5,0x16
    80002c94:	c8078793          	addi	a5,a5,-896 # 80018910 <bcache+0x8268>
    80002c98:	00f48863          	beq	s1,a5,80002ca8 <bread+0x84>
    80002c9c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002c9e:	40bc                	lw	a5,64(s1)
    80002ca0:	cb91                	beqz	a5,80002cb4 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002ca2:	64a4                	ld	s1,72(s1)
    80002ca4:	fee49de3          	bne	s1,a4,80002c9e <bread+0x7a>
  panic("bget: no buffers");
    80002ca8:	00004517          	auipc	a0,0x4
    80002cac:	7c850513          	addi	a0,a0,1992 # 80007470 <etext+0x470>
    80002cb0:	ae5fd0ef          	jal	80000794 <panic>
      b->dev = dev;
    80002cb4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002cb8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002cbc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002cc0:	4785                	li	a5,1
    80002cc2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002cc4:	0000e517          	auipc	a0,0xe
    80002cc8:	9e450513          	addi	a0,a0,-1564 # 800106a8 <bcache>
    80002ccc:	fc3fd0ef          	jal	80000c8e <release>
      acquiresleep(&b->lock);
    80002cd0:	01048513          	addi	a0,s1,16
    80002cd4:	1a8010ef          	jal	80003e7c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002cd8:	409c                	lw	a5,0(s1)
    80002cda:	cb89                	beqz	a5,80002cec <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002cdc:	8526                	mv	a0,s1
    80002cde:	70a2                	ld	ra,40(sp)
    80002ce0:	7402                	ld	s0,32(sp)
    80002ce2:	64e2                	ld	s1,24(sp)
    80002ce4:	6942                	ld	s2,16(sp)
    80002ce6:	69a2                	ld	s3,8(sp)
    80002ce8:	6145                	addi	sp,sp,48
    80002cea:	8082                	ret
    virtio_disk_rw(b, 0);
    80002cec:	4581                	li	a1,0
    80002cee:	8526                	mv	a0,s1
    80002cf0:	1f1020ef          	jal	800056e0 <virtio_disk_rw>
    b->valid = 1;
    80002cf4:	4785                	li	a5,1
    80002cf6:	c09c                	sw	a5,0(s1)
  return b;
    80002cf8:	b7d5                	j	80002cdc <bread+0xb8>

0000000080002cfa <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002cfa:	1101                	addi	sp,sp,-32
    80002cfc:	ec06                	sd	ra,24(sp)
    80002cfe:	e822                	sd	s0,16(sp)
    80002d00:	e426                	sd	s1,8(sp)
    80002d02:	1000                	addi	s0,sp,32
    80002d04:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d06:	0541                	addi	a0,a0,16
    80002d08:	1f2010ef          	jal	80003efa <holdingsleep>
    80002d0c:	c911                	beqz	a0,80002d20 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002d0e:	4585                	li	a1,1
    80002d10:	8526                	mv	a0,s1
    80002d12:	1cf020ef          	jal	800056e0 <virtio_disk_rw>
}
    80002d16:	60e2                	ld	ra,24(sp)
    80002d18:	6442                	ld	s0,16(sp)
    80002d1a:	64a2                	ld	s1,8(sp)
    80002d1c:	6105                	addi	sp,sp,32
    80002d1e:	8082                	ret
    panic("bwrite");
    80002d20:	00004517          	auipc	a0,0x4
    80002d24:	76850513          	addi	a0,a0,1896 # 80007488 <etext+0x488>
    80002d28:	a6dfd0ef          	jal	80000794 <panic>

0000000080002d2c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002d2c:	1101                	addi	sp,sp,-32
    80002d2e:	ec06                	sd	ra,24(sp)
    80002d30:	e822                	sd	s0,16(sp)
    80002d32:	e426                	sd	s1,8(sp)
    80002d34:	e04a                	sd	s2,0(sp)
    80002d36:	1000                	addi	s0,sp,32
    80002d38:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d3a:	01050913          	addi	s2,a0,16
    80002d3e:	854a                	mv	a0,s2
    80002d40:	1ba010ef          	jal	80003efa <holdingsleep>
    80002d44:	c135                	beqz	a0,80002da8 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002d46:	854a                	mv	a0,s2
    80002d48:	17a010ef          	jal	80003ec2 <releasesleep>

  acquire(&bcache.lock);
    80002d4c:	0000e517          	auipc	a0,0xe
    80002d50:	95c50513          	addi	a0,a0,-1700 # 800106a8 <bcache>
    80002d54:	ea3fd0ef          	jal	80000bf6 <acquire>
  b->refcnt--;
    80002d58:	40bc                	lw	a5,64(s1)
    80002d5a:	37fd                	addiw	a5,a5,-1
    80002d5c:	0007871b          	sext.w	a4,a5
    80002d60:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002d62:	e71d                	bnez	a4,80002d90 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002d64:	68b8                	ld	a4,80(s1)
    80002d66:	64bc                	ld	a5,72(s1)
    80002d68:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002d6a:	68b8                	ld	a4,80(s1)
    80002d6c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002d6e:	00016797          	auipc	a5,0x16
    80002d72:	93a78793          	addi	a5,a5,-1734 # 800186a8 <bcache+0x8000>
    80002d76:	2b87b703          	ld	a4,696(a5)
    80002d7a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002d7c:	00016717          	auipc	a4,0x16
    80002d80:	b9470713          	addi	a4,a4,-1132 # 80018910 <bcache+0x8268>
    80002d84:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002d86:	2b87b703          	ld	a4,696(a5)
    80002d8a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002d8c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002d90:	0000e517          	auipc	a0,0xe
    80002d94:	91850513          	addi	a0,a0,-1768 # 800106a8 <bcache>
    80002d98:	ef7fd0ef          	jal	80000c8e <release>
}
    80002d9c:	60e2                	ld	ra,24(sp)
    80002d9e:	6442                	ld	s0,16(sp)
    80002da0:	64a2                	ld	s1,8(sp)
    80002da2:	6902                	ld	s2,0(sp)
    80002da4:	6105                	addi	sp,sp,32
    80002da6:	8082                	ret
    panic("brelse");
    80002da8:	00004517          	auipc	a0,0x4
    80002dac:	6e850513          	addi	a0,a0,1768 # 80007490 <etext+0x490>
    80002db0:	9e5fd0ef          	jal	80000794 <panic>

0000000080002db4 <bpin>:

void
bpin(struct buf *b) {
    80002db4:	1101                	addi	sp,sp,-32
    80002db6:	ec06                	sd	ra,24(sp)
    80002db8:	e822                	sd	s0,16(sp)
    80002dba:	e426                	sd	s1,8(sp)
    80002dbc:	1000                	addi	s0,sp,32
    80002dbe:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002dc0:	0000e517          	auipc	a0,0xe
    80002dc4:	8e850513          	addi	a0,a0,-1816 # 800106a8 <bcache>
    80002dc8:	e2ffd0ef          	jal	80000bf6 <acquire>
  b->refcnt++;
    80002dcc:	40bc                	lw	a5,64(s1)
    80002dce:	2785                	addiw	a5,a5,1
    80002dd0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002dd2:	0000e517          	auipc	a0,0xe
    80002dd6:	8d650513          	addi	a0,a0,-1834 # 800106a8 <bcache>
    80002dda:	eb5fd0ef          	jal	80000c8e <release>
}
    80002dde:	60e2                	ld	ra,24(sp)
    80002de0:	6442                	ld	s0,16(sp)
    80002de2:	64a2                	ld	s1,8(sp)
    80002de4:	6105                	addi	sp,sp,32
    80002de6:	8082                	ret

0000000080002de8 <bunpin>:

void
bunpin(struct buf *b) {
    80002de8:	1101                	addi	sp,sp,-32
    80002dea:	ec06                	sd	ra,24(sp)
    80002dec:	e822                	sd	s0,16(sp)
    80002dee:	e426                	sd	s1,8(sp)
    80002df0:	1000                	addi	s0,sp,32
    80002df2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002df4:	0000e517          	auipc	a0,0xe
    80002df8:	8b450513          	addi	a0,a0,-1868 # 800106a8 <bcache>
    80002dfc:	dfbfd0ef          	jal	80000bf6 <acquire>
  b->refcnt--;
    80002e00:	40bc                	lw	a5,64(s1)
    80002e02:	37fd                	addiw	a5,a5,-1
    80002e04:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e06:	0000e517          	auipc	a0,0xe
    80002e0a:	8a250513          	addi	a0,a0,-1886 # 800106a8 <bcache>
    80002e0e:	e81fd0ef          	jal	80000c8e <release>
}
    80002e12:	60e2                	ld	ra,24(sp)
    80002e14:	6442                	ld	s0,16(sp)
    80002e16:	64a2                	ld	s1,8(sp)
    80002e18:	6105                	addi	sp,sp,32
    80002e1a:	8082                	ret

0000000080002e1c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002e1c:	1101                	addi	sp,sp,-32
    80002e1e:	ec06                	sd	ra,24(sp)
    80002e20:	e822                	sd	s0,16(sp)
    80002e22:	e426                	sd	s1,8(sp)
    80002e24:	e04a                	sd	s2,0(sp)
    80002e26:	1000                	addi	s0,sp,32
    80002e28:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002e2a:	00d5d59b          	srliw	a1,a1,0xd
    80002e2e:	00016797          	auipc	a5,0x16
    80002e32:	f567a783          	lw	a5,-170(a5) # 80018d84 <sb+0x1c>
    80002e36:	9dbd                	addw	a1,a1,a5
    80002e38:	dedff0ef          	jal	80002c24 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002e3c:	0074f713          	andi	a4,s1,7
    80002e40:	4785                	li	a5,1
    80002e42:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002e46:	14ce                	slli	s1,s1,0x33
    80002e48:	90d9                	srli	s1,s1,0x36
    80002e4a:	00950733          	add	a4,a0,s1
    80002e4e:	05874703          	lbu	a4,88(a4)
    80002e52:	00e7f6b3          	and	a3,a5,a4
    80002e56:	c29d                	beqz	a3,80002e7c <bfree+0x60>
    80002e58:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002e5a:	94aa                	add	s1,s1,a0
    80002e5c:	fff7c793          	not	a5,a5
    80002e60:	8f7d                	and	a4,a4,a5
    80002e62:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002e66:	711000ef          	jal	80003d76 <log_write>
  brelse(bp);
    80002e6a:	854a                	mv	a0,s2
    80002e6c:	ec1ff0ef          	jal	80002d2c <brelse>
}
    80002e70:	60e2                	ld	ra,24(sp)
    80002e72:	6442                	ld	s0,16(sp)
    80002e74:	64a2                	ld	s1,8(sp)
    80002e76:	6902                	ld	s2,0(sp)
    80002e78:	6105                	addi	sp,sp,32
    80002e7a:	8082                	ret
    panic("freeing free block");
    80002e7c:	00004517          	auipc	a0,0x4
    80002e80:	61c50513          	addi	a0,a0,1564 # 80007498 <etext+0x498>
    80002e84:	911fd0ef          	jal	80000794 <panic>

0000000080002e88 <balloc>:
{
    80002e88:	711d                	addi	sp,sp,-96
    80002e8a:	ec86                	sd	ra,88(sp)
    80002e8c:	e8a2                	sd	s0,80(sp)
    80002e8e:	e4a6                	sd	s1,72(sp)
    80002e90:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002e92:	00016797          	auipc	a5,0x16
    80002e96:	eda7a783          	lw	a5,-294(a5) # 80018d6c <sb+0x4>
    80002e9a:	0e078f63          	beqz	a5,80002f98 <balloc+0x110>
    80002e9e:	e0ca                	sd	s2,64(sp)
    80002ea0:	fc4e                	sd	s3,56(sp)
    80002ea2:	f852                	sd	s4,48(sp)
    80002ea4:	f456                	sd	s5,40(sp)
    80002ea6:	f05a                	sd	s6,32(sp)
    80002ea8:	ec5e                	sd	s7,24(sp)
    80002eaa:	e862                	sd	s8,16(sp)
    80002eac:	e466                	sd	s9,8(sp)
    80002eae:	8baa                	mv	s7,a0
    80002eb0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002eb2:	00016b17          	auipc	s6,0x16
    80002eb6:	eb6b0b13          	addi	s6,s6,-330 # 80018d68 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002eba:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002ebc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002ebe:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002ec0:	6c89                	lui	s9,0x2
    80002ec2:	a0b5                	j	80002f2e <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002ec4:	97ca                	add	a5,a5,s2
    80002ec6:	8e55                	or	a2,a2,a3
    80002ec8:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002ecc:	854a                	mv	a0,s2
    80002ece:	6a9000ef          	jal	80003d76 <log_write>
        brelse(bp);
    80002ed2:	854a                	mv	a0,s2
    80002ed4:	e59ff0ef          	jal	80002d2c <brelse>
  bp = bread(dev, bno);
    80002ed8:	85a6                	mv	a1,s1
    80002eda:	855e                	mv	a0,s7
    80002edc:	d49ff0ef          	jal	80002c24 <bread>
    80002ee0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002ee2:	40000613          	li	a2,1024
    80002ee6:	4581                	li	a1,0
    80002ee8:	05850513          	addi	a0,a0,88
    80002eec:	ddffd0ef          	jal	80000cca <memset>
  log_write(bp);
    80002ef0:	854a                	mv	a0,s2
    80002ef2:	685000ef          	jal	80003d76 <log_write>
  brelse(bp);
    80002ef6:	854a                	mv	a0,s2
    80002ef8:	e35ff0ef          	jal	80002d2c <brelse>
}
    80002efc:	6906                	ld	s2,64(sp)
    80002efe:	79e2                	ld	s3,56(sp)
    80002f00:	7a42                	ld	s4,48(sp)
    80002f02:	7aa2                	ld	s5,40(sp)
    80002f04:	7b02                	ld	s6,32(sp)
    80002f06:	6be2                	ld	s7,24(sp)
    80002f08:	6c42                	ld	s8,16(sp)
    80002f0a:	6ca2                	ld	s9,8(sp)
}
    80002f0c:	8526                	mv	a0,s1
    80002f0e:	60e6                	ld	ra,88(sp)
    80002f10:	6446                	ld	s0,80(sp)
    80002f12:	64a6                	ld	s1,72(sp)
    80002f14:	6125                	addi	sp,sp,96
    80002f16:	8082                	ret
    brelse(bp);
    80002f18:	854a                	mv	a0,s2
    80002f1a:	e13ff0ef          	jal	80002d2c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002f1e:	015c87bb          	addw	a5,s9,s5
    80002f22:	00078a9b          	sext.w	s5,a5
    80002f26:	004b2703          	lw	a4,4(s6)
    80002f2a:	04eaff63          	bgeu	s5,a4,80002f88 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002f2e:	41fad79b          	sraiw	a5,s5,0x1f
    80002f32:	0137d79b          	srliw	a5,a5,0x13
    80002f36:	015787bb          	addw	a5,a5,s5
    80002f3a:	40d7d79b          	sraiw	a5,a5,0xd
    80002f3e:	01cb2583          	lw	a1,28(s6)
    80002f42:	9dbd                	addw	a1,a1,a5
    80002f44:	855e                	mv	a0,s7
    80002f46:	cdfff0ef          	jal	80002c24 <bread>
    80002f4a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f4c:	004b2503          	lw	a0,4(s6)
    80002f50:	000a849b          	sext.w	s1,s5
    80002f54:	8762                	mv	a4,s8
    80002f56:	fca4f1e3          	bgeu	s1,a0,80002f18 <balloc+0x90>
      m = 1 << (bi % 8);
    80002f5a:	00777693          	andi	a3,a4,7
    80002f5e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002f62:	41f7579b          	sraiw	a5,a4,0x1f
    80002f66:	01d7d79b          	srliw	a5,a5,0x1d
    80002f6a:	9fb9                	addw	a5,a5,a4
    80002f6c:	4037d79b          	sraiw	a5,a5,0x3
    80002f70:	00f90633          	add	a2,s2,a5
    80002f74:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80002f78:	00c6f5b3          	and	a1,a3,a2
    80002f7c:	d5a1                	beqz	a1,80002ec4 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f7e:	2705                	addiw	a4,a4,1
    80002f80:	2485                	addiw	s1,s1,1
    80002f82:	fd471ae3          	bne	a4,s4,80002f56 <balloc+0xce>
    80002f86:	bf49                	j	80002f18 <balloc+0x90>
    80002f88:	6906                	ld	s2,64(sp)
    80002f8a:	79e2                	ld	s3,56(sp)
    80002f8c:	7a42                	ld	s4,48(sp)
    80002f8e:	7aa2                	ld	s5,40(sp)
    80002f90:	7b02                	ld	s6,32(sp)
    80002f92:	6be2                	ld	s7,24(sp)
    80002f94:	6c42                	ld	s8,16(sp)
    80002f96:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002f98:	00004517          	auipc	a0,0x4
    80002f9c:	51850513          	addi	a0,a0,1304 # 800074b0 <etext+0x4b0>
    80002fa0:	d22fd0ef          	jal	800004c2 <printf>
  return 0;
    80002fa4:	4481                	li	s1,0
    80002fa6:	b79d                	j	80002f0c <balloc+0x84>

0000000080002fa8 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002fa8:	7179                	addi	sp,sp,-48
    80002faa:	f406                	sd	ra,40(sp)
    80002fac:	f022                	sd	s0,32(sp)
    80002fae:	ec26                	sd	s1,24(sp)
    80002fb0:	e84a                	sd	s2,16(sp)
    80002fb2:	e44e                	sd	s3,8(sp)
    80002fb4:	1800                	addi	s0,sp,48
    80002fb6:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002fb8:	47ad                	li	a5,11
    80002fba:	02b7e663          	bltu	a5,a1,80002fe6 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002fbe:	02059793          	slli	a5,a1,0x20
    80002fc2:	01e7d593          	srli	a1,a5,0x1e
    80002fc6:	00b504b3          	add	s1,a0,a1
    80002fca:	0504a903          	lw	s2,80(s1)
    80002fce:	06091a63          	bnez	s2,80003042 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002fd2:	4108                	lw	a0,0(a0)
    80002fd4:	eb5ff0ef          	jal	80002e88 <balloc>
    80002fd8:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002fdc:	06090363          	beqz	s2,80003042 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002fe0:	0524a823          	sw	s2,80(s1)
    80002fe4:	a8b9                	j	80003042 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002fe6:	ff45849b          	addiw	s1,a1,-12
    80002fea:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002fee:	0ff00793          	li	a5,255
    80002ff2:	06e7ee63          	bltu	a5,a4,8000306e <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002ff6:	08052903          	lw	s2,128(a0)
    80002ffa:	00091d63          	bnez	s2,80003014 <bmap+0x6c>
      addr = balloc(ip->dev);
    80002ffe:	4108                	lw	a0,0(a0)
    80003000:	e89ff0ef          	jal	80002e88 <balloc>
    80003004:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003008:	02090d63          	beqz	s2,80003042 <bmap+0x9a>
    8000300c:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000300e:	0929a023          	sw	s2,128(s3)
    80003012:	a011                	j	80003016 <bmap+0x6e>
    80003014:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003016:	85ca                	mv	a1,s2
    80003018:	0009a503          	lw	a0,0(s3)
    8000301c:	c09ff0ef          	jal	80002c24 <bread>
    80003020:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003022:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003026:	02049713          	slli	a4,s1,0x20
    8000302a:	01e75593          	srli	a1,a4,0x1e
    8000302e:	00b784b3          	add	s1,a5,a1
    80003032:	0004a903          	lw	s2,0(s1)
    80003036:	00090e63          	beqz	s2,80003052 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000303a:	8552                	mv	a0,s4
    8000303c:	cf1ff0ef          	jal	80002d2c <brelse>
    return addr;
    80003040:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003042:	854a                	mv	a0,s2
    80003044:	70a2                	ld	ra,40(sp)
    80003046:	7402                	ld	s0,32(sp)
    80003048:	64e2                	ld	s1,24(sp)
    8000304a:	6942                	ld	s2,16(sp)
    8000304c:	69a2                	ld	s3,8(sp)
    8000304e:	6145                	addi	sp,sp,48
    80003050:	8082                	ret
      addr = balloc(ip->dev);
    80003052:	0009a503          	lw	a0,0(s3)
    80003056:	e33ff0ef          	jal	80002e88 <balloc>
    8000305a:	0005091b          	sext.w	s2,a0
      if(addr){
    8000305e:	fc090ee3          	beqz	s2,8000303a <bmap+0x92>
        a[bn] = addr;
    80003062:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003066:	8552                	mv	a0,s4
    80003068:	50f000ef          	jal	80003d76 <log_write>
    8000306c:	b7f9                	j	8000303a <bmap+0x92>
    8000306e:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003070:	00004517          	auipc	a0,0x4
    80003074:	45850513          	addi	a0,a0,1112 # 800074c8 <etext+0x4c8>
    80003078:	f1cfd0ef          	jal	80000794 <panic>

000000008000307c <iget>:
{
    8000307c:	7179                	addi	sp,sp,-48
    8000307e:	f406                	sd	ra,40(sp)
    80003080:	f022                	sd	s0,32(sp)
    80003082:	ec26                	sd	s1,24(sp)
    80003084:	e84a                	sd	s2,16(sp)
    80003086:	e44e                	sd	s3,8(sp)
    80003088:	e052                	sd	s4,0(sp)
    8000308a:	1800                	addi	s0,sp,48
    8000308c:	89aa                	mv	s3,a0
    8000308e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003090:	00016517          	auipc	a0,0x16
    80003094:	cf850513          	addi	a0,a0,-776 # 80018d88 <itable>
    80003098:	b5ffd0ef          	jal	80000bf6 <acquire>
  empty = 0;
    8000309c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000309e:	00016497          	auipc	s1,0x16
    800030a2:	d0248493          	addi	s1,s1,-766 # 80018da0 <itable+0x18>
    800030a6:	00017697          	auipc	a3,0x17
    800030aa:	78a68693          	addi	a3,a3,1930 # 8001a830 <log>
    800030ae:	a039                	j	800030bc <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800030b0:	02090963          	beqz	s2,800030e2 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800030b4:	08848493          	addi	s1,s1,136
    800030b8:	02d48863          	beq	s1,a3,800030e8 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800030bc:	449c                	lw	a5,8(s1)
    800030be:	fef059e3          	blez	a5,800030b0 <iget+0x34>
    800030c2:	4098                	lw	a4,0(s1)
    800030c4:	ff3716e3          	bne	a4,s3,800030b0 <iget+0x34>
    800030c8:	40d8                	lw	a4,4(s1)
    800030ca:	ff4713e3          	bne	a4,s4,800030b0 <iget+0x34>
      ip->ref++;
    800030ce:	2785                	addiw	a5,a5,1
    800030d0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800030d2:	00016517          	auipc	a0,0x16
    800030d6:	cb650513          	addi	a0,a0,-842 # 80018d88 <itable>
    800030da:	bb5fd0ef          	jal	80000c8e <release>
      return ip;
    800030de:	8926                	mv	s2,s1
    800030e0:	a02d                	j	8000310a <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800030e2:	fbe9                	bnez	a5,800030b4 <iget+0x38>
      empty = ip;
    800030e4:	8926                	mv	s2,s1
    800030e6:	b7f9                	j	800030b4 <iget+0x38>
  if(empty == 0)
    800030e8:	02090a63          	beqz	s2,8000311c <iget+0xa0>
  ip->dev = dev;
    800030ec:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800030f0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800030f4:	4785                	li	a5,1
    800030f6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800030fa:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800030fe:	00016517          	auipc	a0,0x16
    80003102:	c8a50513          	addi	a0,a0,-886 # 80018d88 <itable>
    80003106:	b89fd0ef          	jal	80000c8e <release>
}
    8000310a:	854a                	mv	a0,s2
    8000310c:	70a2                	ld	ra,40(sp)
    8000310e:	7402                	ld	s0,32(sp)
    80003110:	64e2                	ld	s1,24(sp)
    80003112:	6942                	ld	s2,16(sp)
    80003114:	69a2                	ld	s3,8(sp)
    80003116:	6a02                	ld	s4,0(sp)
    80003118:	6145                	addi	sp,sp,48
    8000311a:	8082                	ret
    panic("iget: no inodes");
    8000311c:	00004517          	auipc	a0,0x4
    80003120:	3c450513          	addi	a0,a0,964 # 800074e0 <etext+0x4e0>
    80003124:	e70fd0ef          	jal	80000794 <panic>

0000000080003128 <fsinit>:
fsinit(int dev) {
    80003128:	7179                	addi	sp,sp,-48
    8000312a:	f406                	sd	ra,40(sp)
    8000312c:	f022                	sd	s0,32(sp)
    8000312e:	ec26                	sd	s1,24(sp)
    80003130:	e84a                	sd	s2,16(sp)
    80003132:	e44e                	sd	s3,8(sp)
    80003134:	1800                	addi	s0,sp,48
    80003136:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003138:	4585                	li	a1,1
    8000313a:	aebff0ef          	jal	80002c24 <bread>
    8000313e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003140:	00016997          	auipc	s3,0x16
    80003144:	c2898993          	addi	s3,s3,-984 # 80018d68 <sb>
    80003148:	02000613          	li	a2,32
    8000314c:	05850593          	addi	a1,a0,88
    80003150:	854e                	mv	a0,s3
    80003152:	bd5fd0ef          	jal	80000d26 <memmove>
  brelse(bp);
    80003156:	8526                	mv	a0,s1
    80003158:	bd5ff0ef          	jal	80002d2c <brelse>
  if(sb.magic != FSMAGIC)
    8000315c:	0009a703          	lw	a4,0(s3)
    80003160:	102037b7          	lui	a5,0x10203
    80003164:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003168:	02f71063          	bne	a4,a5,80003188 <fsinit+0x60>
  initlog(dev, &sb);
    8000316c:	00016597          	auipc	a1,0x16
    80003170:	bfc58593          	addi	a1,a1,-1028 # 80018d68 <sb>
    80003174:	854a                	mv	a0,s2
    80003176:	1f9000ef          	jal	80003b6e <initlog>
}
    8000317a:	70a2                	ld	ra,40(sp)
    8000317c:	7402                	ld	s0,32(sp)
    8000317e:	64e2                	ld	s1,24(sp)
    80003180:	6942                	ld	s2,16(sp)
    80003182:	69a2                	ld	s3,8(sp)
    80003184:	6145                	addi	sp,sp,48
    80003186:	8082                	ret
    panic("invalid file system");
    80003188:	00004517          	auipc	a0,0x4
    8000318c:	36850513          	addi	a0,a0,872 # 800074f0 <etext+0x4f0>
    80003190:	e04fd0ef          	jal	80000794 <panic>

0000000080003194 <iinit>:
{
    80003194:	7179                	addi	sp,sp,-48
    80003196:	f406                	sd	ra,40(sp)
    80003198:	f022                	sd	s0,32(sp)
    8000319a:	ec26                	sd	s1,24(sp)
    8000319c:	e84a                	sd	s2,16(sp)
    8000319e:	e44e                	sd	s3,8(sp)
    800031a0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800031a2:	00004597          	auipc	a1,0x4
    800031a6:	36658593          	addi	a1,a1,870 # 80007508 <etext+0x508>
    800031aa:	00016517          	auipc	a0,0x16
    800031ae:	bde50513          	addi	a0,a0,-1058 # 80018d88 <itable>
    800031b2:	9c5fd0ef          	jal	80000b76 <initlock>
  for(i = 0; i < NINODE; i++) {
    800031b6:	00016497          	auipc	s1,0x16
    800031ba:	bfa48493          	addi	s1,s1,-1030 # 80018db0 <itable+0x28>
    800031be:	00017997          	auipc	s3,0x17
    800031c2:	68298993          	addi	s3,s3,1666 # 8001a840 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800031c6:	00004917          	auipc	s2,0x4
    800031ca:	34a90913          	addi	s2,s2,842 # 80007510 <etext+0x510>
    800031ce:	85ca                	mv	a1,s2
    800031d0:	8526                	mv	a0,s1
    800031d2:	475000ef          	jal	80003e46 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800031d6:	08848493          	addi	s1,s1,136
    800031da:	ff349ae3          	bne	s1,s3,800031ce <iinit+0x3a>
}
    800031de:	70a2                	ld	ra,40(sp)
    800031e0:	7402                	ld	s0,32(sp)
    800031e2:	64e2                	ld	s1,24(sp)
    800031e4:	6942                	ld	s2,16(sp)
    800031e6:	69a2                	ld	s3,8(sp)
    800031e8:	6145                	addi	sp,sp,48
    800031ea:	8082                	ret

00000000800031ec <ialloc>:
{
    800031ec:	7139                	addi	sp,sp,-64
    800031ee:	fc06                	sd	ra,56(sp)
    800031f0:	f822                	sd	s0,48(sp)
    800031f2:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800031f4:	00016717          	auipc	a4,0x16
    800031f8:	b8072703          	lw	a4,-1152(a4) # 80018d74 <sb+0xc>
    800031fc:	4785                	li	a5,1
    800031fe:	06e7f063          	bgeu	a5,a4,8000325e <ialloc+0x72>
    80003202:	f426                	sd	s1,40(sp)
    80003204:	f04a                	sd	s2,32(sp)
    80003206:	ec4e                	sd	s3,24(sp)
    80003208:	e852                	sd	s4,16(sp)
    8000320a:	e456                	sd	s5,8(sp)
    8000320c:	e05a                	sd	s6,0(sp)
    8000320e:	8aaa                	mv	s5,a0
    80003210:	8b2e                	mv	s6,a1
    80003212:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003214:	00016a17          	auipc	s4,0x16
    80003218:	b54a0a13          	addi	s4,s4,-1196 # 80018d68 <sb>
    8000321c:	00495593          	srli	a1,s2,0x4
    80003220:	018a2783          	lw	a5,24(s4)
    80003224:	9dbd                	addw	a1,a1,a5
    80003226:	8556                	mv	a0,s5
    80003228:	9fdff0ef          	jal	80002c24 <bread>
    8000322c:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000322e:	05850993          	addi	s3,a0,88
    80003232:	00f97793          	andi	a5,s2,15
    80003236:	079a                	slli	a5,a5,0x6
    80003238:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000323a:	00099783          	lh	a5,0(s3)
    8000323e:	cb9d                	beqz	a5,80003274 <ialloc+0x88>
    brelse(bp);
    80003240:	aedff0ef          	jal	80002d2c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003244:	0905                	addi	s2,s2,1
    80003246:	00ca2703          	lw	a4,12(s4)
    8000324a:	0009079b          	sext.w	a5,s2
    8000324e:	fce7e7e3          	bltu	a5,a4,8000321c <ialloc+0x30>
    80003252:	74a2                	ld	s1,40(sp)
    80003254:	7902                	ld	s2,32(sp)
    80003256:	69e2                	ld	s3,24(sp)
    80003258:	6a42                	ld	s4,16(sp)
    8000325a:	6aa2                	ld	s5,8(sp)
    8000325c:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000325e:	00004517          	auipc	a0,0x4
    80003262:	2ba50513          	addi	a0,a0,698 # 80007518 <etext+0x518>
    80003266:	a5cfd0ef          	jal	800004c2 <printf>
  return 0;
    8000326a:	4501                	li	a0,0
}
    8000326c:	70e2                	ld	ra,56(sp)
    8000326e:	7442                	ld	s0,48(sp)
    80003270:	6121                	addi	sp,sp,64
    80003272:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003274:	04000613          	li	a2,64
    80003278:	4581                	li	a1,0
    8000327a:	854e                	mv	a0,s3
    8000327c:	a4ffd0ef          	jal	80000cca <memset>
      dip->type = type;
    80003280:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003284:	8526                	mv	a0,s1
    80003286:	2f1000ef          	jal	80003d76 <log_write>
      brelse(bp);
    8000328a:	8526                	mv	a0,s1
    8000328c:	aa1ff0ef          	jal	80002d2c <brelse>
      return iget(dev, inum);
    80003290:	0009059b          	sext.w	a1,s2
    80003294:	8556                	mv	a0,s5
    80003296:	de7ff0ef          	jal	8000307c <iget>
    8000329a:	74a2                	ld	s1,40(sp)
    8000329c:	7902                	ld	s2,32(sp)
    8000329e:	69e2                	ld	s3,24(sp)
    800032a0:	6a42                	ld	s4,16(sp)
    800032a2:	6aa2                	ld	s5,8(sp)
    800032a4:	6b02                	ld	s6,0(sp)
    800032a6:	b7d9                	j	8000326c <ialloc+0x80>

00000000800032a8 <iupdate>:
{
    800032a8:	1101                	addi	sp,sp,-32
    800032aa:	ec06                	sd	ra,24(sp)
    800032ac:	e822                	sd	s0,16(sp)
    800032ae:	e426                	sd	s1,8(sp)
    800032b0:	e04a                	sd	s2,0(sp)
    800032b2:	1000                	addi	s0,sp,32
    800032b4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800032b6:	415c                	lw	a5,4(a0)
    800032b8:	0047d79b          	srliw	a5,a5,0x4
    800032bc:	00016597          	auipc	a1,0x16
    800032c0:	ac45a583          	lw	a1,-1340(a1) # 80018d80 <sb+0x18>
    800032c4:	9dbd                	addw	a1,a1,a5
    800032c6:	4108                	lw	a0,0(a0)
    800032c8:	95dff0ef          	jal	80002c24 <bread>
    800032cc:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800032ce:	05850793          	addi	a5,a0,88
    800032d2:	40d8                	lw	a4,4(s1)
    800032d4:	8b3d                	andi	a4,a4,15
    800032d6:	071a                	slli	a4,a4,0x6
    800032d8:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800032da:	04449703          	lh	a4,68(s1)
    800032de:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800032e2:	04649703          	lh	a4,70(s1)
    800032e6:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800032ea:	04849703          	lh	a4,72(s1)
    800032ee:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800032f2:	04a49703          	lh	a4,74(s1)
    800032f6:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800032fa:	44f8                	lw	a4,76(s1)
    800032fc:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800032fe:	03400613          	li	a2,52
    80003302:	05048593          	addi	a1,s1,80
    80003306:	00c78513          	addi	a0,a5,12
    8000330a:	a1dfd0ef          	jal	80000d26 <memmove>
  log_write(bp);
    8000330e:	854a                	mv	a0,s2
    80003310:	267000ef          	jal	80003d76 <log_write>
  brelse(bp);
    80003314:	854a                	mv	a0,s2
    80003316:	a17ff0ef          	jal	80002d2c <brelse>
}
    8000331a:	60e2                	ld	ra,24(sp)
    8000331c:	6442                	ld	s0,16(sp)
    8000331e:	64a2                	ld	s1,8(sp)
    80003320:	6902                	ld	s2,0(sp)
    80003322:	6105                	addi	sp,sp,32
    80003324:	8082                	ret

0000000080003326 <idup>:
{
    80003326:	1101                	addi	sp,sp,-32
    80003328:	ec06                	sd	ra,24(sp)
    8000332a:	e822                	sd	s0,16(sp)
    8000332c:	e426                	sd	s1,8(sp)
    8000332e:	1000                	addi	s0,sp,32
    80003330:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003332:	00016517          	auipc	a0,0x16
    80003336:	a5650513          	addi	a0,a0,-1450 # 80018d88 <itable>
    8000333a:	8bdfd0ef          	jal	80000bf6 <acquire>
  ip->ref++;
    8000333e:	449c                	lw	a5,8(s1)
    80003340:	2785                	addiw	a5,a5,1
    80003342:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003344:	00016517          	auipc	a0,0x16
    80003348:	a4450513          	addi	a0,a0,-1468 # 80018d88 <itable>
    8000334c:	943fd0ef          	jal	80000c8e <release>
}
    80003350:	8526                	mv	a0,s1
    80003352:	60e2                	ld	ra,24(sp)
    80003354:	6442                	ld	s0,16(sp)
    80003356:	64a2                	ld	s1,8(sp)
    80003358:	6105                	addi	sp,sp,32
    8000335a:	8082                	ret

000000008000335c <ilock>:
{
    8000335c:	1101                	addi	sp,sp,-32
    8000335e:	ec06                	sd	ra,24(sp)
    80003360:	e822                	sd	s0,16(sp)
    80003362:	e426                	sd	s1,8(sp)
    80003364:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003366:	cd19                	beqz	a0,80003384 <ilock+0x28>
    80003368:	84aa                	mv	s1,a0
    8000336a:	451c                	lw	a5,8(a0)
    8000336c:	00f05c63          	blez	a5,80003384 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003370:	0541                	addi	a0,a0,16
    80003372:	30b000ef          	jal	80003e7c <acquiresleep>
  if(ip->valid == 0){
    80003376:	40bc                	lw	a5,64(s1)
    80003378:	cf89                	beqz	a5,80003392 <ilock+0x36>
}
    8000337a:	60e2                	ld	ra,24(sp)
    8000337c:	6442                	ld	s0,16(sp)
    8000337e:	64a2                	ld	s1,8(sp)
    80003380:	6105                	addi	sp,sp,32
    80003382:	8082                	ret
    80003384:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003386:	00004517          	auipc	a0,0x4
    8000338a:	1aa50513          	addi	a0,a0,426 # 80007530 <etext+0x530>
    8000338e:	c06fd0ef          	jal	80000794 <panic>
    80003392:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003394:	40dc                	lw	a5,4(s1)
    80003396:	0047d79b          	srliw	a5,a5,0x4
    8000339a:	00016597          	auipc	a1,0x16
    8000339e:	9e65a583          	lw	a1,-1562(a1) # 80018d80 <sb+0x18>
    800033a2:	9dbd                	addw	a1,a1,a5
    800033a4:	4088                	lw	a0,0(s1)
    800033a6:	87fff0ef          	jal	80002c24 <bread>
    800033aa:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800033ac:	05850593          	addi	a1,a0,88
    800033b0:	40dc                	lw	a5,4(s1)
    800033b2:	8bbd                	andi	a5,a5,15
    800033b4:	079a                	slli	a5,a5,0x6
    800033b6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800033b8:	00059783          	lh	a5,0(a1)
    800033bc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800033c0:	00259783          	lh	a5,2(a1)
    800033c4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800033c8:	00459783          	lh	a5,4(a1)
    800033cc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800033d0:	00659783          	lh	a5,6(a1)
    800033d4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800033d8:	459c                	lw	a5,8(a1)
    800033da:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800033dc:	03400613          	li	a2,52
    800033e0:	05b1                	addi	a1,a1,12
    800033e2:	05048513          	addi	a0,s1,80
    800033e6:	941fd0ef          	jal	80000d26 <memmove>
    brelse(bp);
    800033ea:	854a                	mv	a0,s2
    800033ec:	941ff0ef          	jal	80002d2c <brelse>
    ip->valid = 1;
    800033f0:	4785                	li	a5,1
    800033f2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800033f4:	04449783          	lh	a5,68(s1)
    800033f8:	c399                	beqz	a5,800033fe <ilock+0xa2>
    800033fa:	6902                	ld	s2,0(sp)
    800033fc:	bfbd                	j	8000337a <ilock+0x1e>
      panic("ilock: no type");
    800033fe:	00004517          	auipc	a0,0x4
    80003402:	13a50513          	addi	a0,a0,314 # 80007538 <etext+0x538>
    80003406:	b8efd0ef          	jal	80000794 <panic>

000000008000340a <iunlock>:
{
    8000340a:	1101                	addi	sp,sp,-32
    8000340c:	ec06                	sd	ra,24(sp)
    8000340e:	e822                	sd	s0,16(sp)
    80003410:	e426                	sd	s1,8(sp)
    80003412:	e04a                	sd	s2,0(sp)
    80003414:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003416:	c505                	beqz	a0,8000343e <iunlock+0x34>
    80003418:	84aa                	mv	s1,a0
    8000341a:	01050913          	addi	s2,a0,16
    8000341e:	854a                	mv	a0,s2
    80003420:	2db000ef          	jal	80003efa <holdingsleep>
    80003424:	cd09                	beqz	a0,8000343e <iunlock+0x34>
    80003426:	449c                	lw	a5,8(s1)
    80003428:	00f05b63          	blez	a5,8000343e <iunlock+0x34>
  releasesleep(&ip->lock);
    8000342c:	854a                	mv	a0,s2
    8000342e:	295000ef          	jal	80003ec2 <releasesleep>
}
    80003432:	60e2                	ld	ra,24(sp)
    80003434:	6442                	ld	s0,16(sp)
    80003436:	64a2                	ld	s1,8(sp)
    80003438:	6902                	ld	s2,0(sp)
    8000343a:	6105                	addi	sp,sp,32
    8000343c:	8082                	ret
    panic("iunlock");
    8000343e:	00004517          	auipc	a0,0x4
    80003442:	10a50513          	addi	a0,a0,266 # 80007548 <etext+0x548>
    80003446:	b4efd0ef          	jal	80000794 <panic>

000000008000344a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000344a:	7179                	addi	sp,sp,-48
    8000344c:	f406                	sd	ra,40(sp)
    8000344e:	f022                	sd	s0,32(sp)
    80003450:	ec26                	sd	s1,24(sp)
    80003452:	e84a                	sd	s2,16(sp)
    80003454:	e44e                	sd	s3,8(sp)
    80003456:	1800                	addi	s0,sp,48
    80003458:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000345a:	05050493          	addi	s1,a0,80
    8000345e:	08050913          	addi	s2,a0,128
    80003462:	a021                	j	8000346a <itrunc+0x20>
    80003464:	0491                	addi	s1,s1,4
    80003466:	01248b63          	beq	s1,s2,8000347c <itrunc+0x32>
    if(ip->addrs[i]){
    8000346a:	408c                	lw	a1,0(s1)
    8000346c:	dde5                	beqz	a1,80003464 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000346e:	0009a503          	lw	a0,0(s3)
    80003472:	9abff0ef          	jal	80002e1c <bfree>
      ip->addrs[i] = 0;
    80003476:	0004a023          	sw	zero,0(s1)
    8000347a:	b7ed                	j	80003464 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000347c:	0809a583          	lw	a1,128(s3)
    80003480:	ed89                	bnez	a1,8000349a <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003482:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003486:	854e                	mv	a0,s3
    80003488:	e21ff0ef          	jal	800032a8 <iupdate>
}
    8000348c:	70a2                	ld	ra,40(sp)
    8000348e:	7402                	ld	s0,32(sp)
    80003490:	64e2                	ld	s1,24(sp)
    80003492:	6942                	ld	s2,16(sp)
    80003494:	69a2                	ld	s3,8(sp)
    80003496:	6145                	addi	sp,sp,48
    80003498:	8082                	ret
    8000349a:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000349c:	0009a503          	lw	a0,0(s3)
    800034a0:	f84ff0ef          	jal	80002c24 <bread>
    800034a4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800034a6:	05850493          	addi	s1,a0,88
    800034aa:	45850913          	addi	s2,a0,1112
    800034ae:	a021                	j	800034b6 <itrunc+0x6c>
    800034b0:	0491                	addi	s1,s1,4
    800034b2:	01248963          	beq	s1,s2,800034c4 <itrunc+0x7a>
      if(a[j])
    800034b6:	408c                	lw	a1,0(s1)
    800034b8:	dde5                	beqz	a1,800034b0 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800034ba:	0009a503          	lw	a0,0(s3)
    800034be:	95fff0ef          	jal	80002e1c <bfree>
    800034c2:	b7fd                	j	800034b0 <itrunc+0x66>
    brelse(bp);
    800034c4:	8552                	mv	a0,s4
    800034c6:	867ff0ef          	jal	80002d2c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800034ca:	0809a583          	lw	a1,128(s3)
    800034ce:	0009a503          	lw	a0,0(s3)
    800034d2:	94bff0ef          	jal	80002e1c <bfree>
    ip->addrs[NDIRECT] = 0;
    800034d6:	0809a023          	sw	zero,128(s3)
    800034da:	6a02                	ld	s4,0(sp)
    800034dc:	b75d                	j	80003482 <itrunc+0x38>

00000000800034de <iput>:
{
    800034de:	1101                	addi	sp,sp,-32
    800034e0:	ec06                	sd	ra,24(sp)
    800034e2:	e822                	sd	s0,16(sp)
    800034e4:	e426                	sd	s1,8(sp)
    800034e6:	1000                	addi	s0,sp,32
    800034e8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800034ea:	00016517          	auipc	a0,0x16
    800034ee:	89e50513          	addi	a0,a0,-1890 # 80018d88 <itable>
    800034f2:	f04fd0ef          	jal	80000bf6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800034f6:	4498                	lw	a4,8(s1)
    800034f8:	4785                	li	a5,1
    800034fa:	02f70063          	beq	a4,a5,8000351a <iput+0x3c>
  ip->ref--;
    800034fe:	449c                	lw	a5,8(s1)
    80003500:	37fd                	addiw	a5,a5,-1
    80003502:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003504:	00016517          	auipc	a0,0x16
    80003508:	88450513          	addi	a0,a0,-1916 # 80018d88 <itable>
    8000350c:	f82fd0ef          	jal	80000c8e <release>
}
    80003510:	60e2                	ld	ra,24(sp)
    80003512:	6442                	ld	s0,16(sp)
    80003514:	64a2                	ld	s1,8(sp)
    80003516:	6105                	addi	sp,sp,32
    80003518:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000351a:	40bc                	lw	a5,64(s1)
    8000351c:	d3ed                	beqz	a5,800034fe <iput+0x20>
    8000351e:	04a49783          	lh	a5,74(s1)
    80003522:	fff1                	bnez	a5,800034fe <iput+0x20>
    80003524:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003526:	01048913          	addi	s2,s1,16
    8000352a:	854a                	mv	a0,s2
    8000352c:	151000ef          	jal	80003e7c <acquiresleep>
    release(&itable.lock);
    80003530:	00016517          	auipc	a0,0x16
    80003534:	85850513          	addi	a0,a0,-1960 # 80018d88 <itable>
    80003538:	f56fd0ef          	jal	80000c8e <release>
    itrunc(ip);
    8000353c:	8526                	mv	a0,s1
    8000353e:	f0dff0ef          	jal	8000344a <itrunc>
    ip->type = 0;
    80003542:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003546:	8526                	mv	a0,s1
    80003548:	d61ff0ef          	jal	800032a8 <iupdate>
    ip->valid = 0;
    8000354c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003550:	854a                	mv	a0,s2
    80003552:	171000ef          	jal	80003ec2 <releasesleep>
    acquire(&itable.lock);
    80003556:	00016517          	auipc	a0,0x16
    8000355a:	83250513          	addi	a0,a0,-1998 # 80018d88 <itable>
    8000355e:	e98fd0ef          	jal	80000bf6 <acquire>
    80003562:	6902                	ld	s2,0(sp)
    80003564:	bf69                	j	800034fe <iput+0x20>

0000000080003566 <iunlockput>:
{
    80003566:	1101                	addi	sp,sp,-32
    80003568:	ec06                	sd	ra,24(sp)
    8000356a:	e822                	sd	s0,16(sp)
    8000356c:	e426                	sd	s1,8(sp)
    8000356e:	1000                	addi	s0,sp,32
    80003570:	84aa                	mv	s1,a0
  iunlock(ip);
    80003572:	e99ff0ef          	jal	8000340a <iunlock>
  iput(ip);
    80003576:	8526                	mv	a0,s1
    80003578:	f67ff0ef          	jal	800034de <iput>
}
    8000357c:	60e2                	ld	ra,24(sp)
    8000357e:	6442                	ld	s0,16(sp)
    80003580:	64a2                	ld	s1,8(sp)
    80003582:	6105                	addi	sp,sp,32
    80003584:	8082                	ret

0000000080003586 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003586:	1141                	addi	sp,sp,-16
    80003588:	e422                	sd	s0,8(sp)
    8000358a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000358c:	411c                	lw	a5,0(a0)
    8000358e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003590:	415c                	lw	a5,4(a0)
    80003592:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003594:	04451783          	lh	a5,68(a0)
    80003598:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000359c:	04a51783          	lh	a5,74(a0)
    800035a0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800035a4:	04c56783          	lwu	a5,76(a0)
    800035a8:	e99c                	sd	a5,16(a1)
}
    800035aa:	6422                	ld	s0,8(sp)
    800035ac:	0141                	addi	sp,sp,16
    800035ae:	8082                	ret

00000000800035b0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800035b0:	457c                	lw	a5,76(a0)
    800035b2:	0ed7eb63          	bltu	a5,a3,800036a8 <readi+0xf8>
{
    800035b6:	7159                	addi	sp,sp,-112
    800035b8:	f486                	sd	ra,104(sp)
    800035ba:	f0a2                	sd	s0,96(sp)
    800035bc:	eca6                	sd	s1,88(sp)
    800035be:	e0d2                	sd	s4,64(sp)
    800035c0:	fc56                	sd	s5,56(sp)
    800035c2:	f85a                	sd	s6,48(sp)
    800035c4:	f45e                	sd	s7,40(sp)
    800035c6:	1880                	addi	s0,sp,112
    800035c8:	8b2a                	mv	s6,a0
    800035ca:	8bae                	mv	s7,a1
    800035cc:	8a32                	mv	s4,a2
    800035ce:	84b6                	mv	s1,a3
    800035d0:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800035d2:	9f35                	addw	a4,a4,a3
    return 0;
    800035d4:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800035d6:	0cd76063          	bltu	a4,a3,80003696 <readi+0xe6>
    800035da:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800035dc:	00e7f463          	bgeu	a5,a4,800035e4 <readi+0x34>
    n = ip->size - off;
    800035e0:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800035e4:	080a8f63          	beqz	s5,80003682 <readi+0xd2>
    800035e8:	e8ca                	sd	s2,80(sp)
    800035ea:	f062                	sd	s8,32(sp)
    800035ec:	ec66                	sd	s9,24(sp)
    800035ee:	e86a                	sd	s10,16(sp)
    800035f0:	e46e                	sd	s11,8(sp)
    800035f2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800035f4:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800035f8:	5c7d                	li	s8,-1
    800035fa:	a80d                	j	8000362c <readi+0x7c>
    800035fc:	020d1d93          	slli	s11,s10,0x20
    80003600:	020ddd93          	srli	s11,s11,0x20
    80003604:	05890613          	addi	a2,s2,88
    80003608:	86ee                	mv	a3,s11
    8000360a:	963a                	add	a2,a2,a4
    8000360c:	85d2                	mv	a1,s4
    8000360e:	855e                	mv	a0,s7
    80003610:	929fe0ef          	jal	80001f38 <either_copyout>
    80003614:	05850763          	beq	a0,s8,80003662 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003618:	854a                	mv	a0,s2
    8000361a:	f12ff0ef          	jal	80002d2c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000361e:	013d09bb          	addw	s3,s10,s3
    80003622:	009d04bb          	addw	s1,s10,s1
    80003626:	9a6e                	add	s4,s4,s11
    80003628:	0559f763          	bgeu	s3,s5,80003676 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    8000362c:	00a4d59b          	srliw	a1,s1,0xa
    80003630:	855a                	mv	a0,s6
    80003632:	977ff0ef          	jal	80002fa8 <bmap>
    80003636:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000363a:	c5b1                	beqz	a1,80003686 <readi+0xd6>
    bp = bread(ip->dev, addr);
    8000363c:	000b2503          	lw	a0,0(s6)
    80003640:	de4ff0ef          	jal	80002c24 <bread>
    80003644:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003646:	3ff4f713          	andi	a4,s1,1023
    8000364a:	40ec87bb          	subw	a5,s9,a4
    8000364e:	413a86bb          	subw	a3,s5,s3
    80003652:	8d3e                	mv	s10,a5
    80003654:	2781                	sext.w	a5,a5
    80003656:	0006861b          	sext.w	a2,a3
    8000365a:	faf671e3          	bgeu	a2,a5,800035fc <readi+0x4c>
    8000365e:	8d36                	mv	s10,a3
    80003660:	bf71                	j	800035fc <readi+0x4c>
      brelse(bp);
    80003662:	854a                	mv	a0,s2
    80003664:	ec8ff0ef          	jal	80002d2c <brelse>
      tot = -1;
    80003668:	59fd                	li	s3,-1
      break;
    8000366a:	6946                	ld	s2,80(sp)
    8000366c:	7c02                	ld	s8,32(sp)
    8000366e:	6ce2                	ld	s9,24(sp)
    80003670:	6d42                	ld	s10,16(sp)
    80003672:	6da2                	ld	s11,8(sp)
    80003674:	a831                	j	80003690 <readi+0xe0>
    80003676:	6946                	ld	s2,80(sp)
    80003678:	7c02                	ld	s8,32(sp)
    8000367a:	6ce2                	ld	s9,24(sp)
    8000367c:	6d42                	ld	s10,16(sp)
    8000367e:	6da2                	ld	s11,8(sp)
    80003680:	a801                	j	80003690 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003682:	89d6                	mv	s3,s5
    80003684:	a031                	j	80003690 <readi+0xe0>
    80003686:	6946                	ld	s2,80(sp)
    80003688:	7c02                	ld	s8,32(sp)
    8000368a:	6ce2                	ld	s9,24(sp)
    8000368c:	6d42                	ld	s10,16(sp)
    8000368e:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003690:	0009851b          	sext.w	a0,s3
    80003694:	69a6                	ld	s3,72(sp)
}
    80003696:	70a6                	ld	ra,104(sp)
    80003698:	7406                	ld	s0,96(sp)
    8000369a:	64e6                	ld	s1,88(sp)
    8000369c:	6a06                	ld	s4,64(sp)
    8000369e:	7ae2                	ld	s5,56(sp)
    800036a0:	7b42                	ld	s6,48(sp)
    800036a2:	7ba2                	ld	s7,40(sp)
    800036a4:	6165                	addi	sp,sp,112
    800036a6:	8082                	ret
    return 0;
    800036a8:	4501                	li	a0,0
}
    800036aa:	8082                	ret

00000000800036ac <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800036ac:	457c                	lw	a5,76(a0)
    800036ae:	10d7e063          	bltu	a5,a3,800037ae <writei+0x102>
{
    800036b2:	7159                	addi	sp,sp,-112
    800036b4:	f486                	sd	ra,104(sp)
    800036b6:	f0a2                	sd	s0,96(sp)
    800036b8:	e8ca                	sd	s2,80(sp)
    800036ba:	e0d2                	sd	s4,64(sp)
    800036bc:	fc56                	sd	s5,56(sp)
    800036be:	f85a                	sd	s6,48(sp)
    800036c0:	f45e                	sd	s7,40(sp)
    800036c2:	1880                	addi	s0,sp,112
    800036c4:	8aaa                	mv	s5,a0
    800036c6:	8bae                	mv	s7,a1
    800036c8:	8a32                	mv	s4,a2
    800036ca:	8936                	mv	s2,a3
    800036cc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800036ce:	00e687bb          	addw	a5,a3,a4
    800036d2:	0ed7e063          	bltu	a5,a3,800037b2 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800036d6:	00043737          	lui	a4,0x43
    800036da:	0cf76e63          	bltu	a4,a5,800037b6 <writei+0x10a>
    800036de:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800036e0:	0a0b0f63          	beqz	s6,8000379e <writei+0xf2>
    800036e4:	eca6                	sd	s1,88(sp)
    800036e6:	f062                	sd	s8,32(sp)
    800036e8:	ec66                	sd	s9,24(sp)
    800036ea:	e86a                	sd	s10,16(sp)
    800036ec:	e46e                	sd	s11,8(sp)
    800036ee:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800036f0:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800036f4:	5c7d                	li	s8,-1
    800036f6:	a825                	j	8000372e <writei+0x82>
    800036f8:	020d1d93          	slli	s11,s10,0x20
    800036fc:	020ddd93          	srli	s11,s11,0x20
    80003700:	05848513          	addi	a0,s1,88
    80003704:	86ee                	mv	a3,s11
    80003706:	8652                	mv	a2,s4
    80003708:	85de                	mv	a1,s7
    8000370a:	953a                	add	a0,a0,a4
    8000370c:	877fe0ef          	jal	80001f82 <either_copyin>
    80003710:	05850a63          	beq	a0,s8,80003764 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003714:	8526                	mv	a0,s1
    80003716:	660000ef          	jal	80003d76 <log_write>
    brelse(bp);
    8000371a:	8526                	mv	a0,s1
    8000371c:	e10ff0ef          	jal	80002d2c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003720:	013d09bb          	addw	s3,s10,s3
    80003724:	012d093b          	addw	s2,s10,s2
    80003728:	9a6e                	add	s4,s4,s11
    8000372a:	0569f063          	bgeu	s3,s6,8000376a <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    8000372e:	00a9559b          	srliw	a1,s2,0xa
    80003732:	8556                	mv	a0,s5
    80003734:	875ff0ef          	jal	80002fa8 <bmap>
    80003738:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000373c:	c59d                	beqz	a1,8000376a <writei+0xbe>
    bp = bread(ip->dev, addr);
    8000373e:	000aa503          	lw	a0,0(s5)
    80003742:	ce2ff0ef          	jal	80002c24 <bread>
    80003746:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003748:	3ff97713          	andi	a4,s2,1023
    8000374c:	40ec87bb          	subw	a5,s9,a4
    80003750:	413b06bb          	subw	a3,s6,s3
    80003754:	8d3e                	mv	s10,a5
    80003756:	2781                	sext.w	a5,a5
    80003758:	0006861b          	sext.w	a2,a3
    8000375c:	f8f67ee3          	bgeu	a2,a5,800036f8 <writei+0x4c>
    80003760:	8d36                	mv	s10,a3
    80003762:	bf59                	j	800036f8 <writei+0x4c>
      brelse(bp);
    80003764:	8526                	mv	a0,s1
    80003766:	dc6ff0ef          	jal	80002d2c <brelse>
  }

  if(off > ip->size)
    8000376a:	04caa783          	lw	a5,76(s5)
    8000376e:	0327fa63          	bgeu	a5,s2,800037a2 <writei+0xf6>
    ip->size = off;
    80003772:	052aa623          	sw	s2,76(s5)
    80003776:	64e6                	ld	s1,88(sp)
    80003778:	7c02                	ld	s8,32(sp)
    8000377a:	6ce2                	ld	s9,24(sp)
    8000377c:	6d42                	ld	s10,16(sp)
    8000377e:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003780:	8556                	mv	a0,s5
    80003782:	b27ff0ef          	jal	800032a8 <iupdate>

  return tot;
    80003786:	0009851b          	sext.w	a0,s3
    8000378a:	69a6                	ld	s3,72(sp)
}
    8000378c:	70a6                	ld	ra,104(sp)
    8000378e:	7406                	ld	s0,96(sp)
    80003790:	6946                	ld	s2,80(sp)
    80003792:	6a06                	ld	s4,64(sp)
    80003794:	7ae2                	ld	s5,56(sp)
    80003796:	7b42                	ld	s6,48(sp)
    80003798:	7ba2                	ld	s7,40(sp)
    8000379a:	6165                	addi	sp,sp,112
    8000379c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000379e:	89da                	mv	s3,s6
    800037a0:	b7c5                	j	80003780 <writei+0xd4>
    800037a2:	64e6                	ld	s1,88(sp)
    800037a4:	7c02                	ld	s8,32(sp)
    800037a6:	6ce2                	ld	s9,24(sp)
    800037a8:	6d42                	ld	s10,16(sp)
    800037aa:	6da2                	ld	s11,8(sp)
    800037ac:	bfd1                	j	80003780 <writei+0xd4>
    return -1;
    800037ae:	557d                	li	a0,-1
}
    800037b0:	8082                	ret
    return -1;
    800037b2:	557d                	li	a0,-1
    800037b4:	bfe1                	j	8000378c <writei+0xe0>
    return -1;
    800037b6:	557d                	li	a0,-1
    800037b8:	bfd1                	j	8000378c <writei+0xe0>

00000000800037ba <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800037ba:	1141                	addi	sp,sp,-16
    800037bc:	e406                	sd	ra,8(sp)
    800037be:	e022                	sd	s0,0(sp)
    800037c0:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800037c2:	4639                	li	a2,14
    800037c4:	dd2fd0ef          	jal	80000d96 <strncmp>
}
    800037c8:	60a2                	ld	ra,8(sp)
    800037ca:	6402                	ld	s0,0(sp)
    800037cc:	0141                	addi	sp,sp,16
    800037ce:	8082                	ret

00000000800037d0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800037d0:	7139                	addi	sp,sp,-64
    800037d2:	fc06                	sd	ra,56(sp)
    800037d4:	f822                	sd	s0,48(sp)
    800037d6:	f426                	sd	s1,40(sp)
    800037d8:	f04a                	sd	s2,32(sp)
    800037da:	ec4e                	sd	s3,24(sp)
    800037dc:	e852                	sd	s4,16(sp)
    800037de:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800037e0:	04451703          	lh	a4,68(a0)
    800037e4:	4785                	li	a5,1
    800037e6:	00f71a63          	bne	a4,a5,800037fa <dirlookup+0x2a>
    800037ea:	892a                	mv	s2,a0
    800037ec:	89ae                	mv	s3,a1
    800037ee:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800037f0:	457c                	lw	a5,76(a0)
    800037f2:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800037f4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800037f6:	e39d                	bnez	a5,8000381c <dirlookup+0x4c>
    800037f8:	a095                	j	8000385c <dirlookup+0x8c>
    panic("dirlookup not DIR");
    800037fa:	00004517          	auipc	a0,0x4
    800037fe:	d5650513          	addi	a0,a0,-682 # 80007550 <etext+0x550>
    80003802:	f93fc0ef          	jal	80000794 <panic>
      panic("dirlookup read");
    80003806:	00004517          	auipc	a0,0x4
    8000380a:	d6250513          	addi	a0,a0,-670 # 80007568 <etext+0x568>
    8000380e:	f87fc0ef          	jal	80000794 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003812:	24c1                	addiw	s1,s1,16
    80003814:	04c92783          	lw	a5,76(s2)
    80003818:	04f4f163          	bgeu	s1,a5,8000385a <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000381c:	4741                	li	a4,16
    8000381e:	86a6                	mv	a3,s1
    80003820:	fc040613          	addi	a2,s0,-64
    80003824:	4581                	li	a1,0
    80003826:	854a                	mv	a0,s2
    80003828:	d89ff0ef          	jal	800035b0 <readi>
    8000382c:	47c1                	li	a5,16
    8000382e:	fcf51ce3          	bne	a0,a5,80003806 <dirlookup+0x36>
    if(de.inum == 0)
    80003832:	fc045783          	lhu	a5,-64(s0)
    80003836:	dff1                	beqz	a5,80003812 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003838:	fc240593          	addi	a1,s0,-62
    8000383c:	854e                	mv	a0,s3
    8000383e:	f7dff0ef          	jal	800037ba <namecmp>
    80003842:	f961                	bnez	a0,80003812 <dirlookup+0x42>
      if(poff)
    80003844:	000a0463          	beqz	s4,8000384c <dirlookup+0x7c>
        *poff = off;
    80003848:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000384c:	fc045583          	lhu	a1,-64(s0)
    80003850:	00092503          	lw	a0,0(s2)
    80003854:	829ff0ef          	jal	8000307c <iget>
    80003858:	a011                	j	8000385c <dirlookup+0x8c>
  return 0;
    8000385a:	4501                	li	a0,0
}
    8000385c:	70e2                	ld	ra,56(sp)
    8000385e:	7442                	ld	s0,48(sp)
    80003860:	74a2                	ld	s1,40(sp)
    80003862:	7902                	ld	s2,32(sp)
    80003864:	69e2                	ld	s3,24(sp)
    80003866:	6a42                	ld	s4,16(sp)
    80003868:	6121                	addi	sp,sp,64
    8000386a:	8082                	ret

000000008000386c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000386c:	711d                	addi	sp,sp,-96
    8000386e:	ec86                	sd	ra,88(sp)
    80003870:	e8a2                	sd	s0,80(sp)
    80003872:	e4a6                	sd	s1,72(sp)
    80003874:	e0ca                	sd	s2,64(sp)
    80003876:	fc4e                	sd	s3,56(sp)
    80003878:	f852                	sd	s4,48(sp)
    8000387a:	f456                	sd	s5,40(sp)
    8000387c:	f05a                	sd	s6,32(sp)
    8000387e:	ec5e                	sd	s7,24(sp)
    80003880:	e862                	sd	s8,16(sp)
    80003882:	e466                	sd	s9,8(sp)
    80003884:	1080                	addi	s0,sp,96
    80003886:	84aa                	mv	s1,a0
    80003888:	8b2e                	mv	s6,a1
    8000388a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000388c:	00054703          	lbu	a4,0(a0)
    80003890:	02f00793          	li	a5,47
    80003894:	00f70e63          	beq	a4,a5,800038b0 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003898:	82cfe0ef          	jal	800018c4 <myproc>
    8000389c:	15853503          	ld	a0,344(a0)
    800038a0:	a87ff0ef          	jal	80003326 <idup>
    800038a4:	8a2a                	mv	s4,a0
  while(*path == '/')
    800038a6:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800038aa:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800038ac:	4b85                	li	s7,1
    800038ae:	a871                	j	8000394a <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    800038b0:	4585                	li	a1,1
    800038b2:	4505                	li	a0,1
    800038b4:	fc8ff0ef          	jal	8000307c <iget>
    800038b8:	8a2a                	mv	s4,a0
    800038ba:	b7f5                	j	800038a6 <namex+0x3a>
      iunlockput(ip);
    800038bc:	8552                	mv	a0,s4
    800038be:	ca9ff0ef          	jal	80003566 <iunlockput>
      return 0;
    800038c2:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800038c4:	8552                	mv	a0,s4
    800038c6:	60e6                	ld	ra,88(sp)
    800038c8:	6446                	ld	s0,80(sp)
    800038ca:	64a6                	ld	s1,72(sp)
    800038cc:	6906                	ld	s2,64(sp)
    800038ce:	79e2                	ld	s3,56(sp)
    800038d0:	7a42                	ld	s4,48(sp)
    800038d2:	7aa2                	ld	s5,40(sp)
    800038d4:	7b02                	ld	s6,32(sp)
    800038d6:	6be2                	ld	s7,24(sp)
    800038d8:	6c42                	ld	s8,16(sp)
    800038da:	6ca2                	ld	s9,8(sp)
    800038dc:	6125                	addi	sp,sp,96
    800038de:	8082                	ret
      iunlock(ip);
    800038e0:	8552                	mv	a0,s4
    800038e2:	b29ff0ef          	jal	8000340a <iunlock>
      return ip;
    800038e6:	bff9                	j	800038c4 <namex+0x58>
      iunlockput(ip);
    800038e8:	8552                	mv	a0,s4
    800038ea:	c7dff0ef          	jal	80003566 <iunlockput>
      return 0;
    800038ee:	8a4e                	mv	s4,s3
    800038f0:	bfd1                	j	800038c4 <namex+0x58>
  len = path - s;
    800038f2:	40998633          	sub	a2,s3,s1
    800038f6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800038fa:	099c5063          	bge	s8,s9,8000397a <namex+0x10e>
    memmove(name, s, DIRSIZ);
    800038fe:	4639                	li	a2,14
    80003900:	85a6                	mv	a1,s1
    80003902:	8556                	mv	a0,s5
    80003904:	c22fd0ef          	jal	80000d26 <memmove>
    80003908:	84ce                	mv	s1,s3
  while(*path == '/')
    8000390a:	0004c783          	lbu	a5,0(s1)
    8000390e:	01279763          	bne	a5,s2,8000391c <namex+0xb0>
    path++;
    80003912:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003914:	0004c783          	lbu	a5,0(s1)
    80003918:	ff278de3          	beq	a5,s2,80003912 <namex+0xa6>
    ilock(ip);
    8000391c:	8552                	mv	a0,s4
    8000391e:	a3fff0ef          	jal	8000335c <ilock>
    if(ip->type != T_DIR){
    80003922:	044a1783          	lh	a5,68(s4)
    80003926:	f9779be3          	bne	a5,s7,800038bc <namex+0x50>
    if(nameiparent && *path == '\0'){
    8000392a:	000b0563          	beqz	s6,80003934 <namex+0xc8>
    8000392e:	0004c783          	lbu	a5,0(s1)
    80003932:	d7dd                	beqz	a5,800038e0 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003934:	4601                	li	a2,0
    80003936:	85d6                	mv	a1,s5
    80003938:	8552                	mv	a0,s4
    8000393a:	e97ff0ef          	jal	800037d0 <dirlookup>
    8000393e:	89aa                	mv	s3,a0
    80003940:	d545                	beqz	a0,800038e8 <namex+0x7c>
    iunlockput(ip);
    80003942:	8552                	mv	a0,s4
    80003944:	c23ff0ef          	jal	80003566 <iunlockput>
    ip = next;
    80003948:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000394a:	0004c783          	lbu	a5,0(s1)
    8000394e:	01279763          	bne	a5,s2,8000395c <namex+0xf0>
    path++;
    80003952:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003954:	0004c783          	lbu	a5,0(s1)
    80003958:	ff278de3          	beq	a5,s2,80003952 <namex+0xe6>
  if(*path == 0)
    8000395c:	cb8d                	beqz	a5,8000398e <namex+0x122>
  while(*path != '/' && *path != 0)
    8000395e:	0004c783          	lbu	a5,0(s1)
    80003962:	89a6                	mv	s3,s1
  len = path - s;
    80003964:	4c81                	li	s9,0
    80003966:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003968:	01278963          	beq	a5,s2,8000397a <namex+0x10e>
    8000396c:	d3d9                	beqz	a5,800038f2 <namex+0x86>
    path++;
    8000396e:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003970:	0009c783          	lbu	a5,0(s3)
    80003974:	ff279ce3          	bne	a5,s2,8000396c <namex+0x100>
    80003978:	bfad                	j	800038f2 <namex+0x86>
    memmove(name, s, len);
    8000397a:	2601                	sext.w	a2,a2
    8000397c:	85a6                	mv	a1,s1
    8000397e:	8556                	mv	a0,s5
    80003980:	ba6fd0ef          	jal	80000d26 <memmove>
    name[len] = 0;
    80003984:	9cd6                	add	s9,s9,s5
    80003986:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000398a:	84ce                	mv	s1,s3
    8000398c:	bfbd                	j	8000390a <namex+0x9e>
  if(nameiparent){
    8000398e:	f20b0be3          	beqz	s6,800038c4 <namex+0x58>
    iput(ip);
    80003992:	8552                	mv	a0,s4
    80003994:	b4bff0ef          	jal	800034de <iput>
    return 0;
    80003998:	4a01                	li	s4,0
    8000399a:	b72d                	j	800038c4 <namex+0x58>

000000008000399c <dirlink>:
{
    8000399c:	7139                	addi	sp,sp,-64
    8000399e:	fc06                	sd	ra,56(sp)
    800039a0:	f822                	sd	s0,48(sp)
    800039a2:	f04a                	sd	s2,32(sp)
    800039a4:	ec4e                	sd	s3,24(sp)
    800039a6:	e852                	sd	s4,16(sp)
    800039a8:	0080                	addi	s0,sp,64
    800039aa:	892a                	mv	s2,a0
    800039ac:	8a2e                	mv	s4,a1
    800039ae:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800039b0:	4601                	li	a2,0
    800039b2:	e1fff0ef          	jal	800037d0 <dirlookup>
    800039b6:	e535                	bnez	a0,80003a22 <dirlink+0x86>
    800039b8:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800039ba:	04c92483          	lw	s1,76(s2)
    800039be:	c48d                	beqz	s1,800039e8 <dirlink+0x4c>
    800039c0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800039c2:	4741                	li	a4,16
    800039c4:	86a6                	mv	a3,s1
    800039c6:	fc040613          	addi	a2,s0,-64
    800039ca:	4581                	li	a1,0
    800039cc:	854a                	mv	a0,s2
    800039ce:	be3ff0ef          	jal	800035b0 <readi>
    800039d2:	47c1                	li	a5,16
    800039d4:	04f51b63          	bne	a0,a5,80003a2a <dirlink+0x8e>
    if(de.inum == 0)
    800039d8:	fc045783          	lhu	a5,-64(s0)
    800039dc:	c791                	beqz	a5,800039e8 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800039de:	24c1                	addiw	s1,s1,16
    800039e0:	04c92783          	lw	a5,76(s2)
    800039e4:	fcf4efe3          	bltu	s1,a5,800039c2 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    800039e8:	4639                	li	a2,14
    800039ea:	85d2                	mv	a1,s4
    800039ec:	fc240513          	addi	a0,s0,-62
    800039f0:	bdcfd0ef          	jal	80000dcc <strncpy>
  de.inum = inum;
    800039f4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800039f8:	4741                	li	a4,16
    800039fa:	86a6                	mv	a3,s1
    800039fc:	fc040613          	addi	a2,s0,-64
    80003a00:	4581                	li	a1,0
    80003a02:	854a                	mv	a0,s2
    80003a04:	ca9ff0ef          	jal	800036ac <writei>
    80003a08:	1541                	addi	a0,a0,-16
    80003a0a:	00a03533          	snez	a0,a0
    80003a0e:	40a00533          	neg	a0,a0
    80003a12:	74a2                	ld	s1,40(sp)
}
    80003a14:	70e2                	ld	ra,56(sp)
    80003a16:	7442                	ld	s0,48(sp)
    80003a18:	7902                	ld	s2,32(sp)
    80003a1a:	69e2                	ld	s3,24(sp)
    80003a1c:	6a42                	ld	s4,16(sp)
    80003a1e:	6121                	addi	sp,sp,64
    80003a20:	8082                	ret
    iput(ip);
    80003a22:	abdff0ef          	jal	800034de <iput>
    return -1;
    80003a26:	557d                	li	a0,-1
    80003a28:	b7f5                	j	80003a14 <dirlink+0x78>
      panic("dirlink read");
    80003a2a:	00004517          	auipc	a0,0x4
    80003a2e:	b4e50513          	addi	a0,a0,-1202 # 80007578 <etext+0x578>
    80003a32:	d63fc0ef          	jal	80000794 <panic>

0000000080003a36 <namei>:

struct inode*
namei(char *path)
{
    80003a36:	1101                	addi	sp,sp,-32
    80003a38:	ec06                	sd	ra,24(sp)
    80003a3a:	e822                	sd	s0,16(sp)
    80003a3c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003a3e:	fe040613          	addi	a2,s0,-32
    80003a42:	4581                	li	a1,0
    80003a44:	e29ff0ef          	jal	8000386c <namex>
}
    80003a48:	60e2                	ld	ra,24(sp)
    80003a4a:	6442                	ld	s0,16(sp)
    80003a4c:	6105                	addi	sp,sp,32
    80003a4e:	8082                	ret

0000000080003a50 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003a50:	1141                	addi	sp,sp,-16
    80003a52:	e406                	sd	ra,8(sp)
    80003a54:	e022                	sd	s0,0(sp)
    80003a56:	0800                	addi	s0,sp,16
    80003a58:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003a5a:	4585                	li	a1,1
    80003a5c:	e11ff0ef          	jal	8000386c <namex>
}
    80003a60:	60a2                	ld	ra,8(sp)
    80003a62:	6402                	ld	s0,0(sp)
    80003a64:	0141                	addi	sp,sp,16
    80003a66:	8082                	ret

0000000080003a68 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003a68:	1101                	addi	sp,sp,-32
    80003a6a:	ec06                	sd	ra,24(sp)
    80003a6c:	e822                	sd	s0,16(sp)
    80003a6e:	e426                	sd	s1,8(sp)
    80003a70:	e04a                	sd	s2,0(sp)
    80003a72:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003a74:	00017917          	auipc	s2,0x17
    80003a78:	dbc90913          	addi	s2,s2,-580 # 8001a830 <log>
    80003a7c:	01892583          	lw	a1,24(s2)
    80003a80:	02892503          	lw	a0,40(s2)
    80003a84:	9a0ff0ef          	jal	80002c24 <bread>
    80003a88:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003a8a:	02c92603          	lw	a2,44(s2)
    80003a8e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003a90:	00c05f63          	blez	a2,80003aae <write_head+0x46>
    80003a94:	00017717          	auipc	a4,0x17
    80003a98:	dcc70713          	addi	a4,a4,-564 # 8001a860 <log+0x30>
    80003a9c:	87aa                	mv	a5,a0
    80003a9e:	060a                	slli	a2,a2,0x2
    80003aa0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003aa2:	4314                	lw	a3,0(a4)
    80003aa4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003aa6:	0711                	addi	a4,a4,4
    80003aa8:	0791                	addi	a5,a5,4
    80003aaa:	fec79ce3          	bne	a5,a2,80003aa2 <write_head+0x3a>
  }
  bwrite(buf);
    80003aae:	8526                	mv	a0,s1
    80003ab0:	a4aff0ef          	jal	80002cfa <bwrite>
  brelse(buf);
    80003ab4:	8526                	mv	a0,s1
    80003ab6:	a76ff0ef          	jal	80002d2c <brelse>
}
    80003aba:	60e2                	ld	ra,24(sp)
    80003abc:	6442                	ld	s0,16(sp)
    80003abe:	64a2                	ld	s1,8(sp)
    80003ac0:	6902                	ld	s2,0(sp)
    80003ac2:	6105                	addi	sp,sp,32
    80003ac4:	8082                	ret

0000000080003ac6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ac6:	00017797          	auipc	a5,0x17
    80003aca:	d967a783          	lw	a5,-618(a5) # 8001a85c <log+0x2c>
    80003ace:	08f05f63          	blez	a5,80003b6c <install_trans+0xa6>
{
    80003ad2:	7139                	addi	sp,sp,-64
    80003ad4:	fc06                	sd	ra,56(sp)
    80003ad6:	f822                	sd	s0,48(sp)
    80003ad8:	f426                	sd	s1,40(sp)
    80003ada:	f04a                	sd	s2,32(sp)
    80003adc:	ec4e                	sd	s3,24(sp)
    80003ade:	e852                	sd	s4,16(sp)
    80003ae0:	e456                	sd	s5,8(sp)
    80003ae2:	e05a                	sd	s6,0(sp)
    80003ae4:	0080                	addi	s0,sp,64
    80003ae6:	8b2a                	mv	s6,a0
    80003ae8:	00017a97          	auipc	s5,0x17
    80003aec:	d78a8a93          	addi	s5,s5,-648 # 8001a860 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003af0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003af2:	00017997          	auipc	s3,0x17
    80003af6:	d3e98993          	addi	s3,s3,-706 # 8001a830 <log>
    80003afa:	a829                	j	80003b14 <install_trans+0x4e>
    brelse(lbuf);
    80003afc:	854a                	mv	a0,s2
    80003afe:	a2eff0ef          	jal	80002d2c <brelse>
    brelse(dbuf);
    80003b02:	8526                	mv	a0,s1
    80003b04:	a28ff0ef          	jal	80002d2c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b08:	2a05                	addiw	s4,s4,1
    80003b0a:	0a91                	addi	s5,s5,4
    80003b0c:	02c9a783          	lw	a5,44(s3)
    80003b10:	04fa5463          	bge	s4,a5,80003b58 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003b14:	0189a583          	lw	a1,24(s3)
    80003b18:	014585bb          	addw	a1,a1,s4
    80003b1c:	2585                	addiw	a1,a1,1
    80003b1e:	0289a503          	lw	a0,40(s3)
    80003b22:	902ff0ef          	jal	80002c24 <bread>
    80003b26:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003b28:	000aa583          	lw	a1,0(s5)
    80003b2c:	0289a503          	lw	a0,40(s3)
    80003b30:	8f4ff0ef          	jal	80002c24 <bread>
    80003b34:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003b36:	40000613          	li	a2,1024
    80003b3a:	05890593          	addi	a1,s2,88
    80003b3e:	05850513          	addi	a0,a0,88
    80003b42:	9e4fd0ef          	jal	80000d26 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003b46:	8526                	mv	a0,s1
    80003b48:	9b2ff0ef          	jal	80002cfa <bwrite>
    if(recovering == 0)
    80003b4c:	fa0b18e3          	bnez	s6,80003afc <install_trans+0x36>
      bunpin(dbuf);
    80003b50:	8526                	mv	a0,s1
    80003b52:	a96ff0ef          	jal	80002de8 <bunpin>
    80003b56:	b75d                	j	80003afc <install_trans+0x36>
}
    80003b58:	70e2                	ld	ra,56(sp)
    80003b5a:	7442                	ld	s0,48(sp)
    80003b5c:	74a2                	ld	s1,40(sp)
    80003b5e:	7902                	ld	s2,32(sp)
    80003b60:	69e2                	ld	s3,24(sp)
    80003b62:	6a42                	ld	s4,16(sp)
    80003b64:	6aa2                	ld	s5,8(sp)
    80003b66:	6b02                	ld	s6,0(sp)
    80003b68:	6121                	addi	sp,sp,64
    80003b6a:	8082                	ret
    80003b6c:	8082                	ret

0000000080003b6e <initlog>:
{
    80003b6e:	7179                	addi	sp,sp,-48
    80003b70:	f406                	sd	ra,40(sp)
    80003b72:	f022                	sd	s0,32(sp)
    80003b74:	ec26                	sd	s1,24(sp)
    80003b76:	e84a                	sd	s2,16(sp)
    80003b78:	e44e                	sd	s3,8(sp)
    80003b7a:	1800                	addi	s0,sp,48
    80003b7c:	892a                	mv	s2,a0
    80003b7e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003b80:	00017497          	auipc	s1,0x17
    80003b84:	cb048493          	addi	s1,s1,-848 # 8001a830 <log>
    80003b88:	00004597          	auipc	a1,0x4
    80003b8c:	a0058593          	addi	a1,a1,-1536 # 80007588 <etext+0x588>
    80003b90:	8526                	mv	a0,s1
    80003b92:	fe5fc0ef          	jal	80000b76 <initlock>
  log.start = sb->logstart;
    80003b96:	0149a583          	lw	a1,20(s3)
    80003b9a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003b9c:	0109a783          	lw	a5,16(s3)
    80003ba0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003ba2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003ba6:	854a                	mv	a0,s2
    80003ba8:	87cff0ef          	jal	80002c24 <bread>
  log.lh.n = lh->n;
    80003bac:	4d30                	lw	a2,88(a0)
    80003bae:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003bb0:	00c05f63          	blez	a2,80003bce <initlog+0x60>
    80003bb4:	87aa                	mv	a5,a0
    80003bb6:	00017717          	auipc	a4,0x17
    80003bba:	caa70713          	addi	a4,a4,-854 # 8001a860 <log+0x30>
    80003bbe:	060a                	slli	a2,a2,0x2
    80003bc0:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003bc2:	4ff4                	lw	a3,92(a5)
    80003bc4:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003bc6:	0791                	addi	a5,a5,4
    80003bc8:	0711                	addi	a4,a4,4
    80003bca:	fec79ce3          	bne	a5,a2,80003bc2 <initlog+0x54>
  brelse(buf);
    80003bce:	95eff0ef          	jal	80002d2c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003bd2:	4505                	li	a0,1
    80003bd4:	ef3ff0ef          	jal	80003ac6 <install_trans>
  log.lh.n = 0;
    80003bd8:	00017797          	auipc	a5,0x17
    80003bdc:	c807a223          	sw	zero,-892(a5) # 8001a85c <log+0x2c>
  write_head(); // clear the log
    80003be0:	e89ff0ef          	jal	80003a68 <write_head>
}
    80003be4:	70a2                	ld	ra,40(sp)
    80003be6:	7402                	ld	s0,32(sp)
    80003be8:	64e2                	ld	s1,24(sp)
    80003bea:	6942                	ld	s2,16(sp)
    80003bec:	69a2                	ld	s3,8(sp)
    80003bee:	6145                	addi	sp,sp,48
    80003bf0:	8082                	ret

0000000080003bf2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003bf2:	1101                	addi	sp,sp,-32
    80003bf4:	ec06                	sd	ra,24(sp)
    80003bf6:	e822                	sd	s0,16(sp)
    80003bf8:	e426                	sd	s1,8(sp)
    80003bfa:	e04a                	sd	s2,0(sp)
    80003bfc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003bfe:	00017517          	auipc	a0,0x17
    80003c02:	c3250513          	addi	a0,a0,-974 # 8001a830 <log>
    80003c06:	ff1fc0ef          	jal	80000bf6 <acquire>
  while(1){
    if(log.committing){
    80003c0a:	00017497          	auipc	s1,0x17
    80003c0e:	c2648493          	addi	s1,s1,-986 # 8001a830 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003c12:	4979                	li	s2,30
    80003c14:	a029                	j	80003c1e <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003c16:	85a6                	mv	a1,s1
    80003c18:	8526                	mv	a0,s1
    80003c1a:	850fe0ef          	jal	80001c6a <sleep>
    if(log.committing){
    80003c1e:	50dc                	lw	a5,36(s1)
    80003c20:	fbfd                	bnez	a5,80003c16 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003c22:	5098                	lw	a4,32(s1)
    80003c24:	2705                	addiw	a4,a4,1
    80003c26:	0027179b          	slliw	a5,a4,0x2
    80003c2a:	9fb9                	addw	a5,a5,a4
    80003c2c:	0017979b          	slliw	a5,a5,0x1
    80003c30:	54d4                	lw	a3,44(s1)
    80003c32:	9fb5                	addw	a5,a5,a3
    80003c34:	00f95763          	bge	s2,a5,80003c42 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003c38:	85a6                	mv	a1,s1
    80003c3a:	8526                	mv	a0,s1
    80003c3c:	82efe0ef          	jal	80001c6a <sleep>
    80003c40:	bff9                	j	80003c1e <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003c42:	00017517          	auipc	a0,0x17
    80003c46:	bee50513          	addi	a0,a0,-1042 # 8001a830 <log>
    80003c4a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003c4c:	842fd0ef          	jal	80000c8e <release>
      break;
    }
  }
}
    80003c50:	60e2                	ld	ra,24(sp)
    80003c52:	6442                	ld	s0,16(sp)
    80003c54:	64a2                	ld	s1,8(sp)
    80003c56:	6902                	ld	s2,0(sp)
    80003c58:	6105                	addi	sp,sp,32
    80003c5a:	8082                	ret

0000000080003c5c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003c5c:	7139                	addi	sp,sp,-64
    80003c5e:	fc06                	sd	ra,56(sp)
    80003c60:	f822                	sd	s0,48(sp)
    80003c62:	f426                	sd	s1,40(sp)
    80003c64:	f04a                	sd	s2,32(sp)
    80003c66:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003c68:	00017497          	auipc	s1,0x17
    80003c6c:	bc848493          	addi	s1,s1,-1080 # 8001a830 <log>
    80003c70:	8526                	mv	a0,s1
    80003c72:	f85fc0ef          	jal	80000bf6 <acquire>
  log.outstanding -= 1;
    80003c76:	509c                	lw	a5,32(s1)
    80003c78:	37fd                	addiw	a5,a5,-1
    80003c7a:	0007891b          	sext.w	s2,a5
    80003c7e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003c80:	50dc                	lw	a5,36(s1)
    80003c82:	ef9d                	bnez	a5,80003cc0 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003c84:	04091763          	bnez	s2,80003cd2 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003c88:	00017497          	auipc	s1,0x17
    80003c8c:	ba848493          	addi	s1,s1,-1112 # 8001a830 <log>
    80003c90:	4785                	li	a5,1
    80003c92:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003c94:	8526                	mv	a0,s1
    80003c96:	ff9fc0ef          	jal	80000c8e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003c9a:	54dc                	lw	a5,44(s1)
    80003c9c:	04f04b63          	bgtz	a5,80003cf2 <end_op+0x96>
    acquire(&log.lock);
    80003ca0:	00017497          	auipc	s1,0x17
    80003ca4:	b9048493          	addi	s1,s1,-1136 # 8001a830 <log>
    80003ca8:	8526                	mv	a0,s1
    80003caa:	f4dfc0ef          	jal	80000bf6 <acquire>
    log.committing = 0;
    80003cae:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003cb2:	8526                	mv	a0,s1
    80003cb4:	802fe0ef          	jal	80001cb6 <wakeup>
    release(&log.lock);
    80003cb8:	8526                	mv	a0,s1
    80003cba:	fd5fc0ef          	jal	80000c8e <release>
}
    80003cbe:	a025                	j	80003ce6 <end_op+0x8a>
    80003cc0:	ec4e                	sd	s3,24(sp)
    80003cc2:	e852                	sd	s4,16(sp)
    80003cc4:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003cc6:	00004517          	auipc	a0,0x4
    80003cca:	8ca50513          	addi	a0,a0,-1846 # 80007590 <etext+0x590>
    80003cce:	ac7fc0ef          	jal	80000794 <panic>
    wakeup(&log);
    80003cd2:	00017497          	auipc	s1,0x17
    80003cd6:	b5e48493          	addi	s1,s1,-1186 # 8001a830 <log>
    80003cda:	8526                	mv	a0,s1
    80003cdc:	fdbfd0ef          	jal	80001cb6 <wakeup>
  release(&log.lock);
    80003ce0:	8526                	mv	a0,s1
    80003ce2:	fadfc0ef          	jal	80000c8e <release>
}
    80003ce6:	70e2                	ld	ra,56(sp)
    80003ce8:	7442                	ld	s0,48(sp)
    80003cea:	74a2                	ld	s1,40(sp)
    80003cec:	7902                	ld	s2,32(sp)
    80003cee:	6121                	addi	sp,sp,64
    80003cf0:	8082                	ret
    80003cf2:	ec4e                	sd	s3,24(sp)
    80003cf4:	e852                	sd	s4,16(sp)
    80003cf6:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003cf8:	00017a97          	auipc	s5,0x17
    80003cfc:	b68a8a93          	addi	s5,s5,-1176 # 8001a860 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003d00:	00017a17          	auipc	s4,0x17
    80003d04:	b30a0a13          	addi	s4,s4,-1232 # 8001a830 <log>
    80003d08:	018a2583          	lw	a1,24(s4)
    80003d0c:	012585bb          	addw	a1,a1,s2
    80003d10:	2585                	addiw	a1,a1,1
    80003d12:	028a2503          	lw	a0,40(s4)
    80003d16:	f0ffe0ef          	jal	80002c24 <bread>
    80003d1a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003d1c:	000aa583          	lw	a1,0(s5)
    80003d20:	028a2503          	lw	a0,40(s4)
    80003d24:	f01fe0ef          	jal	80002c24 <bread>
    80003d28:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003d2a:	40000613          	li	a2,1024
    80003d2e:	05850593          	addi	a1,a0,88
    80003d32:	05848513          	addi	a0,s1,88
    80003d36:	ff1fc0ef          	jal	80000d26 <memmove>
    bwrite(to);  // write the log
    80003d3a:	8526                	mv	a0,s1
    80003d3c:	fbffe0ef          	jal	80002cfa <bwrite>
    brelse(from);
    80003d40:	854e                	mv	a0,s3
    80003d42:	febfe0ef          	jal	80002d2c <brelse>
    brelse(to);
    80003d46:	8526                	mv	a0,s1
    80003d48:	fe5fe0ef          	jal	80002d2c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d4c:	2905                	addiw	s2,s2,1
    80003d4e:	0a91                	addi	s5,s5,4
    80003d50:	02ca2783          	lw	a5,44(s4)
    80003d54:	faf94ae3          	blt	s2,a5,80003d08 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003d58:	d11ff0ef          	jal	80003a68 <write_head>
    install_trans(0); // Now install writes to home locations
    80003d5c:	4501                	li	a0,0
    80003d5e:	d69ff0ef          	jal	80003ac6 <install_trans>
    log.lh.n = 0;
    80003d62:	00017797          	auipc	a5,0x17
    80003d66:	ae07ad23          	sw	zero,-1286(a5) # 8001a85c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003d6a:	cffff0ef          	jal	80003a68 <write_head>
    80003d6e:	69e2                	ld	s3,24(sp)
    80003d70:	6a42                	ld	s4,16(sp)
    80003d72:	6aa2                	ld	s5,8(sp)
    80003d74:	b735                	j	80003ca0 <end_op+0x44>

0000000080003d76 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003d76:	1101                	addi	sp,sp,-32
    80003d78:	ec06                	sd	ra,24(sp)
    80003d7a:	e822                	sd	s0,16(sp)
    80003d7c:	e426                	sd	s1,8(sp)
    80003d7e:	e04a                	sd	s2,0(sp)
    80003d80:	1000                	addi	s0,sp,32
    80003d82:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003d84:	00017917          	auipc	s2,0x17
    80003d88:	aac90913          	addi	s2,s2,-1364 # 8001a830 <log>
    80003d8c:	854a                	mv	a0,s2
    80003d8e:	e69fc0ef          	jal	80000bf6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003d92:	02c92603          	lw	a2,44(s2)
    80003d96:	47f5                	li	a5,29
    80003d98:	06c7c363          	blt	a5,a2,80003dfe <log_write+0x88>
    80003d9c:	00017797          	auipc	a5,0x17
    80003da0:	ab07a783          	lw	a5,-1360(a5) # 8001a84c <log+0x1c>
    80003da4:	37fd                	addiw	a5,a5,-1
    80003da6:	04f65c63          	bge	a2,a5,80003dfe <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003daa:	00017797          	auipc	a5,0x17
    80003dae:	aa67a783          	lw	a5,-1370(a5) # 8001a850 <log+0x20>
    80003db2:	04f05c63          	blez	a5,80003e0a <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003db6:	4781                	li	a5,0
    80003db8:	04c05f63          	blez	a2,80003e16 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003dbc:	44cc                	lw	a1,12(s1)
    80003dbe:	00017717          	auipc	a4,0x17
    80003dc2:	aa270713          	addi	a4,a4,-1374 # 8001a860 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003dc6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003dc8:	4314                	lw	a3,0(a4)
    80003dca:	04b68663          	beq	a3,a1,80003e16 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003dce:	2785                	addiw	a5,a5,1
    80003dd0:	0711                	addi	a4,a4,4
    80003dd2:	fef61be3          	bne	a2,a5,80003dc8 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003dd6:	0621                	addi	a2,a2,8
    80003dd8:	060a                	slli	a2,a2,0x2
    80003dda:	00017797          	auipc	a5,0x17
    80003dde:	a5678793          	addi	a5,a5,-1450 # 8001a830 <log>
    80003de2:	97b2                	add	a5,a5,a2
    80003de4:	44d8                	lw	a4,12(s1)
    80003de6:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003de8:	8526                	mv	a0,s1
    80003dea:	fcbfe0ef          	jal	80002db4 <bpin>
    log.lh.n++;
    80003dee:	00017717          	auipc	a4,0x17
    80003df2:	a4270713          	addi	a4,a4,-1470 # 8001a830 <log>
    80003df6:	575c                	lw	a5,44(a4)
    80003df8:	2785                	addiw	a5,a5,1
    80003dfa:	d75c                	sw	a5,44(a4)
    80003dfc:	a80d                	j	80003e2e <log_write+0xb8>
    panic("too big a transaction");
    80003dfe:	00003517          	auipc	a0,0x3
    80003e02:	7a250513          	addi	a0,a0,1954 # 800075a0 <etext+0x5a0>
    80003e06:	98ffc0ef          	jal	80000794 <panic>
    panic("log_write outside of trans");
    80003e0a:	00003517          	auipc	a0,0x3
    80003e0e:	7ae50513          	addi	a0,a0,1966 # 800075b8 <etext+0x5b8>
    80003e12:	983fc0ef          	jal	80000794 <panic>
  log.lh.block[i] = b->blockno;
    80003e16:	00878693          	addi	a3,a5,8
    80003e1a:	068a                	slli	a3,a3,0x2
    80003e1c:	00017717          	auipc	a4,0x17
    80003e20:	a1470713          	addi	a4,a4,-1516 # 8001a830 <log>
    80003e24:	9736                	add	a4,a4,a3
    80003e26:	44d4                	lw	a3,12(s1)
    80003e28:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003e2a:	faf60fe3          	beq	a2,a5,80003de8 <log_write+0x72>
  }
  release(&log.lock);
    80003e2e:	00017517          	auipc	a0,0x17
    80003e32:	a0250513          	addi	a0,a0,-1534 # 8001a830 <log>
    80003e36:	e59fc0ef          	jal	80000c8e <release>
}
    80003e3a:	60e2                	ld	ra,24(sp)
    80003e3c:	6442                	ld	s0,16(sp)
    80003e3e:	64a2                	ld	s1,8(sp)
    80003e40:	6902                	ld	s2,0(sp)
    80003e42:	6105                	addi	sp,sp,32
    80003e44:	8082                	ret

0000000080003e46 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003e46:	1101                	addi	sp,sp,-32
    80003e48:	ec06                	sd	ra,24(sp)
    80003e4a:	e822                	sd	s0,16(sp)
    80003e4c:	e426                	sd	s1,8(sp)
    80003e4e:	e04a                	sd	s2,0(sp)
    80003e50:	1000                	addi	s0,sp,32
    80003e52:	84aa                	mv	s1,a0
    80003e54:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003e56:	00003597          	auipc	a1,0x3
    80003e5a:	78258593          	addi	a1,a1,1922 # 800075d8 <etext+0x5d8>
    80003e5e:	0521                	addi	a0,a0,8
    80003e60:	d17fc0ef          	jal	80000b76 <initlock>
  lk->name = name;
    80003e64:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003e68:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003e6c:	0204a423          	sw	zero,40(s1)
}
    80003e70:	60e2                	ld	ra,24(sp)
    80003e72:	6442                	ld	s0,16(sp)
    80003e74:	64a2                	ld	s1,8(sp)
    80003e76:	6902                	ld	s2,0(sp)
    80003e78:	6105                	addi	sp,sp,32
    80003e7a:	8082                	ret

0000000080003e7c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003e7c:	1101                	addi	sp,sp,-32
    80003e7e:	ec06                	sd	ra,24(sp)
    80003e80:	e822                	sd	s0,16(sp)
    80003e82:	e426                	sd	s1,8(sp)
    80003e84:	e04a                	sd	s2,0(sp)
    80003e86:	1000                	addi	s0,sp,32
    80003e88:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003e8a:	00850913          	addi	s2,a0,8
    80003e8e:	854a                	mv	a0,s2
    80003e90:	d67fc0ef          	jal	80000bf6 <acquire>
  while (lk->locked) {
    80003e94:	409c                	lw	a5,0(s1)
    80003e96:	c799                	beqz	a5,80003ea4 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003e98:	85ca                	mv	a1,s2
    80003e9a:	8526                	mv	a0,s1
    80003e9c:	dcffd0ef          	jal	80001c6a <sleep>
  while (lk->locked) {
    80003ea0:	409c                	lw	a5,0(s1)
    80003ea2:	fbfd                	bnez	a5,80003e98 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003ea4:	4785                	li	a5,1
    80003ea6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003ea8:	a1dfd0ef          	jal	800018c4 <myproc>
    80003eac:	591c                	lw	a5,48(a0)
    80003eae:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003eb0:	854a                	mv	a0,s2
    80003eb2:	dddfc0ef          	jal	80000c8e <release>
}
    80003eb6:	60e2                	ld	ra,24(sp)
    80003eb8:	6442                	ld	s0,16(sp)
    80003eba:	64a2                	ld	s1,8(sp)
    80003ebc:	6902                	ld	s2,0(sp)
    80003ebe:	6105                	addi	sp,sp,32
    80003ec0:	8082                	ret

0000000080003ec2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003ec2:	1101                	addi	sp,sp,-32
    80003ec4:	ec06                	sd	ra,24(sp)
    80003ec6:	e822                	sd	s0,16(sp)
    80003ec8:	e426                	sd	s1,8(sp)
    80003eca:	e04a                	sd	s2,0(sp)
    80003ecc:	1000                	addi	s0,sp,32
    80003ece:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ed0:	00850913          	addi	s2,a0,8
    80003ed4:	854a                	mv	a0,s2
    80003ed6:	d21fc0ef          	jal	80000bf6 <acquire>
  lk->locked = 0;
    80003eda:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ede:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003ee2:	8526                	mv	a0,s1
    80003ee4:	dd3fd0ef          	jal	80001cb6 <wakeup>
  release(&lk->lk);
    80003ee8:	854a                	mv	a0,s2
    80003eea:	da5fc0ef          	jal	80000c8e <release>
}
    80003eee:	60e2                	ld	ra,24(sp)
    80003ef0:	6442                	ld	s0,16(sp)
    80003ef2:	64a2                	ld	s1,8(sp)
    80003ef4:	6902                	ld	s2,0(sp)
    80003ef6:	6105                	addi	sp,sp,32
    80003ef8:	8082                	ret

0000000080003efa <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003efa:	7179                	addi	sp,sp,-48
    80003efc:	f406                	sd	ra,40(sp)
    80003efe:	f022                	sd	s0,32(sp)
    80003f00:	ec26                	sd	s1,24(sp)
    80003f02:	e84a                	sd	s2,16(sp)
    80003f04:	1800                	addi	s0,sp,48
    80003f06:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003f08:	00850913          	addi	s2,a0,8
    80003f0c:	854a                	mv	a0,s2
    80003f0e:	ce9fc0ef          	jal	80000bf6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003f12:	409c                	lw	a5,0(s1)
    80003f14:	ef81                	bnez	a5,80003f2c <holdingsleep+0x32>
    80003f16:	4481                	li	s1,0
  release(&lk->lk);
    80003f18:	854a                	mv	a0,s2
    80003f1a:	d75fc0ef          	jal	80000c8e <release>
  return r;
}
    80003f1e:	8526                	mv	a0,s1
    80003f20:	70a2                	ld	ra,40(sp)
    80003f22:	7402                	ld	s0,32(sp)
    80003f24:	64e2                	ld	s1,24(sp)
    80003f26:	6942                	ld	s2,16(sp)
    80003f28:	6145                	addi	sp,sp,48
    80003f2a:	8082                	ret
    80003f2c:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003f2e:	0284a983          	lw	s3,40(s1)
    80003f32:	993fd0ef          	jal	800018c4 <myproc>
    80003f36:	5904                	lw	s1,48(a0)
    80003f38:	413484b3          	sub	s1,s1,s3
    80003f3c:	0014b493          	seqz	s1,s1
    80003f40:	69a2                	ld	s3,8(sp)
    80003f42:	bfd9                	j	80003f18 <holdingsleep+0x1e>

0000000080003f44 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003f44:	1141                	addi	sp,sp,-16
    80003f46:	e406                	sd	ra,8(sp)
    80003f48:	e022                	sd	s0,0(sp)
    80003f4a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003f4c:	00003597          	auipc	a1,0x3
    80003f50:	69c58593          	addi	a1,a1,1692 # 800075e8 <etext+0x5e8>
    80003f54:	00017517          	auipc	a0,0x17
    80003f58:	a2450513          	addi	a0,a0,-1500 # 8001a978 <ftable>
    80003f5c:	c1bfc0ef          	jal	80000b76 <initlock>
}
    80003f60:	60a2                	ld	ra,8(sp)
    80003f62:	6402                	ld	s0,0(sp)
    80003f64:	0141                	addi	sp,sp,16
    80003f66:	8082                	ret

0000000080003f68 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003f68:	1101                	addi	sp,sp,-32
    80003f6a:	ec06                	sd	ra,24(sp)
    80003f6c:	e822                	sd	s0,16(sp)
    80003f6e:	e426                	sd	s1,8(sp)
    80003f70:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003f72:	00017517          	auipc	a0,0x17
    80003f76:	a0650513          	addi	a0,a0,-1530 # 8001a978 <ftable>
    80003f7a:	c7dfc0ef          	jal	80000bf6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003f7e:	00017497          	auipc	s1,0x17
    80003f82:	a1248493          	addi	s1,s1,-1518 # 8001a990 <ftable+0x18>
    80003f86:	00018717          	auipc	a4,0x18
    80003f8a:	9aa70713          	addi	a4,a4,-1622 # 8001b930 <disk>
    if(f->ref == 0){
    80003f8e:	40dc                	lw	a5,4(s1)
    80003f90:	cf89                	beqz	a5,80003faa <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003f92:	02848493          	addi	s1,s1,40
    80003f96:	fee49ce3          	bne	s1,a4,80003f8e <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003f9a:	00017517          	auipc	a0,0x17
    80003f9e:	9de50513          	addi	a0,a0,-1570 # 8001a978 <ftable>
    80003fa2:	cedfc0ef          	jal	80000c8e <release>
  return 0;
    80003fa6:	4481                	li	s1,0
    80003fa8:	a809                	j	80003fba <filealloc+0x52>
      f->ref = 1;
    80003faa:	4785                	li	a5,1
    80003fac:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003fae:	00017517          	auipc	a0,0x17
    80003fb2:	9ca50513          	addi	a0,a0,-1590 # 8001a978 <ftable>
    80003fb6:	cd9fc0ef          	jal	80000c8e <release>
}
    80003fba:	8526                	mv	a0,s1
    80003fbc:	60e2                	ld	ra,24(sp)
    80003fbe:	6442                	ld	s0,16(sp)
    80003fc0:	64a2                	ld	s1,8(sp)
    80003fc2:	6105                	addi	sp,sp,32
    80003fc4:	8082                	ret

0000000080003fc6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003fc6:	1101                	addi	sp,sp,-32
    80003fc8:	ec06                	sd	ra,24(sp)
    80003fca:	e822                	sd	s0,16(sp)
    80003fcc:	e426                	sd	s1,8(sp)
    80003fce:	1000                	addi	s0,sp,32
    80003fd0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003fd2:	00017517          	auipc	a0,0x17
    80003fd6:	9a650513          	addi	a0,a0,-1626 # 8001a978 <ftable>
    80003fda:	c1dfc0ef          	jal	80000bf6 <acquire>
  if(f->ref < 1)
    80003fde:	40dc                	lw	a5,4(s1)
    80003fe0:	02f05063          	blez	a5,80004000 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003fe4:	2785                	addiw	a5,a5,1
    80003fe6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003fe8:	00017517          	auipc	a0,0x17
    80003fec:	99050513          	addi	a0,a0,-1648 # 8001a978 <ftable>
    80003ff0:	c9ffc0ef          	jal	80000c8e <release>
  return f;
}
    80003ff4:	8526                	mv	a0,s1
    80003ff6:	60e2                	ld	ra,24(sp)
    80003ff8:	6442                	ld	s0,16(sp)
    80003ffa:	64a2                	ld	s1,8(sp)
    80003ffc:	6105                	addi	sp,sp,32
    80003ffe:	8082                	ret
    panic("filedup");
    80004000:	00003517          	auipc	a0,0x3
    80004004:	5f050513          	addi	a0,a0,1520 # 800075f0 <etext+0x5f0>
    80004008:	f8cfc0ef          	jal	80000794 <panic>

000000008000400c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000400c:	7139                	addi	sp,sp,-64
    8000400e:	fc06                	sd	ra,56(sp)
    80004010:	f822                	sd	s0,48(sp)
    80004012:	f426                	sd	s1,40(sp)
    80004014:	0080                	addi	s0,sp,64
    80004016:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004018:	00017517          	auipc	a0,0x17
    8000401c:	96050513          	addi	a0,a0,-1696 # 8001a978 <ftable>
    80004020:	bd7fc0ef          	jal	80000bf6 <acquire>
  if(f->ref < 1)
    80004024:	40dc                	lw	a5,4(s1)
    80004026:	04f05a63          	blez	a5,8000407a <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    8000402a:	37fd                	addiw	a5,a5,-1
    8000402c:	0007871b          	sext.w	a4,a5
    80004030:	c0dc                	sw	a5,4(s1)
    80004032:	04e04e63          	bgtz	a4,8000408e <fileclose+0x82>
    80004036:	f04a                	sd	s2,32(sp)
    80004038:	ec4e                	sd	s3,24(sp)
    8000403a:	e852                	sd	s4,16(sp)
    8000403c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000403e:	0004a903          	lw	s2,0(s1)
    80004042:	0094ca83          	lbu	s5,9(s1)
    80004046:	0104ba03          	ld	s4,16(s1)
    8000404a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000404e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004052:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004056:	00017517          	auipc	a0,0x17
    8000405a:	92250513          	addi	a0,a0,-1758 # 8001a978 <ftable>
    8000405e:	c31fc0ef          	jal	80000c8e <release>

  if(ff.type == FD_PIPE){
    80004062:	4785                	li	a5,1
    80004064:	04f90063          	beq	s2,a5,800040a4 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004068:	3979                	addiw	s2,s2,-2
    8000406a:	4785                	li	a5,1
    8000406c:	0527f563          	bgeu	a5,s2,800040b6 <fileclose+0xaa>
    80004070:	7902                	ld	s2,32(sp)
    80004072:	69e2                	ld	s3,24(sp)
    80004074:	6a42                	ld	s4,16(sp)
    80004076:	6aa2                	ld	s5,8(sp)
    80004078:	a00d                	j	8000409a <fileclose+0x8e>
    8000407a:	f04a                	sd	s2,32(sp)
    8000407c:	ec4e                	sd	s3,24(sp)
    8000407e:	e852                	sd	s4,16(sp)
    80004080:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004082:	00003517          	auipc	a0,0x3
    80004086:	57650513          	addi	a0,a0,1398 # 800075f8 <etext+0x5f8>
    8000408a:	f0afc0ef          	jal	80000794 <panic>
    release(&ftable.lock);
    8000408e:	00017517          	auipc	a0,0x17
    80004092:	8ea50513          	addi	a0,a0,-1814 # 8001a978 <ftable>
    80004096:	bf9fc0ef          	jal	80000c8e <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000409a:	70e2                	ld	ra,56(sp)
    8000409c:	7442                	ld	s0,48(sp)
    8000409e:	74a2                	ld	s1,40(sp)
    800040a0:	6121                	addi	sp,sp,64
    800040a2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800040a4:	85d6                	mv	a1,s5
    800040a6:	8552                	mv	a0,s4
    800040a8:	336000ef          	jal	800043de <pipeclose>
    800040ac:	7902                	ld	s2,32(sp)
    800040ae:	69e2                	ld	s3,24(sp)
    800040b0:	6a42                	ld	s4,16(sp)
    800040b2:	6aa2                	ld	s5,8(sp)
    800040b4:	b7dd                	j	8000409a <fileclose+0x8e>
    begin_op();
    800040b6:	b3dff0ef          	jal	80003bf2 <begin_op>
    iput(ff.ip);
    800040ba:	854e                	mv	a0,s3
    800040bc:	c22ff0ef          	jal	800034de <iput>
    end_op();
    800040c0:	b9dff0ef          	jal	80003c5c <end_op>
    800040c4:	7902                	ld	s2,32(sp)
    800040c6:	69e2                	ld	s3,24(sp)
    800040c8:	6a42                	ld	s4,16(sp)
    800040ca:	6aa2                	ld	s5,8(sp)
    800040cc:	b7f9                	j	8000409a <fileclose+0x8e>

00000000800040ce <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800040ce:	715d                	addi	sp,sp,-80
    800040d0:	e486                	sd	ra,72(sp)
    800040d2:	e0a2                	sd	s0,64(sp)
    800040d4:	fc26                	sd	s1,56(sp)
    800040d6:	f44e                	sd	s3,40(sp)
    800040d8:	0880                	addi	s0,sp,80
    800040da:	84aa                	mv	s1,a0
    800040dc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800040de:	fe6fd0ef          	jal	800018c4 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800040e2:	409c                	lw	a5,0(s1)
    800040e4:	37f9                	addiw	a5,a5,-2
    800040e6:	4705                	li	a4,1
    800040e8:	04f76063          	bltu	a4,a5,80004128 <filestat+0x5a>
    800040ec:	f84a                	sd	s2,48(sp)
    800040ee:	892a                	mv	s2,a0
    ilock(f->ip);
    800040f0:	6c88                	ld	a0,24(s1)
    800040f2:	a6aff0ef          	jal	8000335c <ilock>
    stati(f->ip, &st);
    800040f6:	fb840593          	addi	a1,s0,-72
    800040fa:	6c88                	ld	a0,24(s1)
    800040fc:	c8aff0ef          	jal	80003586 <stati>
    iunlock(f->ip);
    80004100:	6c88                	ld	a0,24(s1)
    80004102:	b08ff0ef          	jal	8000340a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004106:	46e1                	li	a3,24
    80004108:	fb840613          	addi	a2,s0,-72
    8000410c:	85ce                	mv	a1,s3
    8000410e:	05093503          	ld	a0,80(s2)
    80004112:	c16fd0ef          	jal	80001528 <copyout>
    80004116:	41f5551b          	sraiw	a0,a0,0x1f
    8000411a:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000411c:	60a6                	ld	ra,72(sp)
    8000411e:	6406                	ld	s0,64(sp)
    80004120:	74e2                	ld	s1,56(sp)
    80004122:	79a2                	ld	s3,40(sp)
    80004124:	6161                	addi	sp,sp,80
    80004126:	8082                	ret
  return -1;
    80004128:	557d                	li	a0,-1
    8000412a:	bfcd                	j	8000411c <filestat+0x4e>

000000008000412c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000412c:	7179                	addi	sp,sp,-48
    8000412e:	f406                	sd	ra,40(sp)
    80004130:	f022                	sd	s0,32(sp)
    80004132:	e84a                	sd	s2,16(sp)
    80004134:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004136:	00854783          	lbu	a5,8(a0)
    8000413a:	cfd1                	beqz	a5,800041d6 <fileread+0xaa>
    8000413c:	ec26                	sd	s1,24(sp)
    8000413e:	e44e                	sd	s3,8(sp)
    80004140:	84aa                	mv	s1,a0
    80004142:	89ae                	mv	s3,a1
    80004144:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004146:	411c                	lw	a5,0(a0)
    80004148:	4705                	li	a4,1
    8000414a:	04e78363          	beq	a5,a4,80004190 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000414e:	470d                	li	a4,3
    80004150:	04e78763          	beq	a5,a4,8000419e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004154:	4709                	li	a4,2
    80004156:	06e79a63          	bne	a5,a4,800041ca <fileread+0x9e>
    ilock(f->ip);
    8000415a:	6d08                	ld	a0,24(a0)
    8000415c:	a00ff0ef          	jal	8000335c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004160:	874a                	mv	a4,s2
    80004162:	5094                	lw	a3,32(s1)
    80004164:	864e                	mv	a2,s3
    80004166:	4585                	li	a1,1
    80004168:	6c88                	ld	a0,24(s1)
    8000416a:	c46ff0ef          	jal	800035b0 <readi>
    8000416e:	892a                	mv	s2,a0
    80004170:	00a05563          	blez	a0,8000417a <fileread+0x4e>
      f->off += r;
    80004174:	509c                	lw	a5,32(s1)
    80004176:	9fa9                	addw	a5,a5,a0
    80004178:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000417a:	6c88                	ld	a0,24(s1)
    8000417c:	a8eff0ef          	jal	8000340a <iunlock>
    80004180:	64e2                	ld	s1,24(sp)
    80004182:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004184:	854a                	mv	a0,s2
    80004186:	70a2                	ld	ra,40(sp)
    80004188:	7402                	ld	s0,32(sp)
    8000418a:	6942                	ld	s2,16(sp)
    8000418c:	6145                	addi	sp,sp,48
    8000418e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004190:	6908                	ld	a0,16(a0)
    80004192:	388000ef          	jal	8000451a <piperead>
    80004196:	892a                	mv	s2,a0
    80004198:	64e2                	ld	s1,24(sp)
    8000419a:	69a2                	ld	s3,8(sp)
    8000419c:	b7e5                	j	80004184 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000419e:	02451783          	lh	a5,36(a0)
    800041a2:	03079693          	slli	a3,a5,0x30
    800041a6:	92c1                	srli	a3,a3,0x30
    800041a8:	4725                	li	a4,9
    800041aa:	02d76863          	bltu	a4,a3,800041da <fileread+0xae>
    800041ae:	0792                	slli	a5,a5,0x4
    800041b0:	00016717          	auipc	a4,0x16
    800041b4:	72870713          	addi	a4,a4,1832 # 8001a8d8 <devsw>
    800041b8:	97ba                	add	a5,a5,a4
    800041ba:	639c                	ld	a5,0(a5)
    800041bc:	c39d                	beqz	a5,800041e2 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800041be:	4505                	li	a0,1
    800041c0:	9782                	jalr	a5
    800041c2:	892a                	mv	s2,a0
    800041c4:	64e2                	ld	s1,24(sp)
    800041c6:	69a2                	ld	s3,8(sp)
    800041c8:	bf75                	j	80004184 <fileread+0x58>
    panic("fileread");
    800041ca:	00003517          	auipc	a0,0x3
    800041ce:	43e50513          	addi	a0,a0,1086 # 80007608 <etext+0x608>
    800041d2:	dc2fc0ef          	jal	80000794 <panic>
    return -1;
    800041d6:	597d                	li	s2,-1
    800041d8:	b775                	j	80004184 <fileread+0x58>
      return -1;
    800041da:	597d                	li	s2,-1
    800041dc:	64e2                	ld	s1,24(sp)
    800041de:	69a2                	ld	s3,8(sp)
    800041e0:	b755                	j	80004184 <fileread+0x58>
    800041e2:	597d                	li	s2,-1
    800041e4:	64e2                	ld	s1,24(sp)
    800041e6:	69a2                	ld	s3,8(sp)
    800041e8:	bf71                	j	80004184 <fileread+0x58>

00000000800041ea <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800041ea:	00954783          	lbu	a5,9(a0)
    800041ee:	10078b63          	beqz	a5,80004304 <filewrite+0x11a>
{
    800041f2:	715d                	addi	sp,sp,-80
    800041f4:	e486                	sd	ra,72(sp)
    800041f6:	e0a2                	sd	s0,64(sp)
    800041f8:	f84a                	sd	s2,48(sp)
    800041fa:	f052                	sd	s4,32(sp)
    800041fc:	e85a                	sd	s6,16(sp)
    800041fe:	0880                	addi	s0,sp,80
    80004200:	892a                	mv	s2,a0
    80004202:	8b2e                	mv	s6,a1
    80004204:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004206:	411c                	lw	a5,0(a0)
    80004208:	4705                	li	a4,1
    8000420a:	02e78763          	beq	a5,a4,80004238 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000420e:	470d                	li	a4,3
    80004210:	02e78863          	beq	a5,a4,80004240 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004214:	4709                	li	a4,2
    80004216:	0ce79c63          	bne	a5,a4,800042ee <filewrite+0x104>
    8000421a:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000421c:	0ac05863          	blez	a2,800042cc <filewrite+0xe2>
    80004220:	fc26                	sd	s1,56(sp)
    80004222:	ec56                	sd	s5,24(sp)
    80004224:	e45e                	sd	s7,8(sp)
    80004226:	e062                	sd	s8,0(sp)
    int i = 0;
    80004228:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000422a:	6b85                	lui	s7,0x1
    8000422c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004230:	6c05                	lui	s8,0x1
    80004232:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004236:	a8b5                	j	800042b2 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80004238:	6908                	ld	a0,16(a0)
    8000423a:	1fc000ef          	jal	80004436 <pipewrite>
    8000423e:	a04d                	j	800042e0 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004240:	02451783          	lh	a5,36(a0)
    80004244:	03079693          	slli	a3,a5,0x30
    80004248:	92c1                	srli	a3,a3,0x30
    8000424a:	4725                	li	a4,9
    8000424c:	0ad76e63          	bltu	a4,a3,80004308 <filewrite+0x11e>
    80004250:	0792                	slli	a5,a5,0x4
    80004252:	00016717          	auipc	a4,0x16
    80004256:	68670713          	addi	a4,a4,1670 # 8001a8d8 <devsw>
    8000425a:	97ba                	add	a5,a5,a4
    8000425c:	679c                	ld	a5,8(a5)
    8000425e:	c7dd                	beqz	a5,8000430c <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80004260:	4505                	li	a0,1
    80004262:	9782                	jalr	a5
    80004264:	a8b5                	j	800042e0 <filewrite+0xf6>
      if(n1 > max)
    80004266:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    8000426a:	989ff0ef          	jal	80003bf2 <begin_op>
      ilock(f->ip);
    8000426e:	01893503          	ld	a0,24(s2)
    80004272:	8eaff0ef          	jal	8000335c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004276:	8756                	mv	a4,s5
    80004278:	02092683          	lw	a3,32(s2)
    8000427c:	01698633          	add	a2,s3,s6
    80004280:	4585                	li	a1,1
    80004282:	01893503          	ld	a0,24(s2)
    80004286:	c26ff0ef          	jal	800036ac <writei>
    8000428a:	84aa                	mv	s1,a0
    8000428c:	00a05763          	blez	a0,8000429a <filewrite+0xb0>
        f->off += r;
    80004290:	02092783          	lw	a5,32(s2)
    80004294:	9fa9                	addw	a5,a5,a0
    80004296:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000429a:	01893503          	ld	a0,24(s2)
    8000429e:	96cff0ef          	jal	8000340a <iunlock>
      end_op();
    800042a2:	9bbff0ef          	jal	80003c5c <end_op>

      if(r != n1){
    800042a6:	029a9563          	bne	s5,s1,800042d0 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800042aa:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800042ae:	0149da63          	bge	s3,s4,800042c2 <filewrite+0xd8>
      int n1 = n - i;
    800042b2:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800042b6:	0004879b          	sext.w	a5,s1
    800042ba:	fafbd6e3          	bge	s7,a5,80004266 <filewrite+0x7c>
    800042be:	84e2                	mv	s1,s8
    800042c0:	b75d                	j	80004266 <filewrite+0x7c>
    800042c2:	74e2                	ld	s1,56(sp)
    800042c4:	6ae2                	ld	s5,24(sp)
    800042c6:	6ba2                	ld	s7,8(sp)
    800042c8:	6c02                	ld	s8,0(sp)
    800042ca:	a039                	j	800042d8 <filewrite+0xee>
    int i = 0;
    800042cc:	4981                	li	s3,0
    800042ce:	a029                	j	800042d8 <filewrite+0xee>
    800042d0:	74e2                	ld	s1,56(sp)
    800042d2:	6ae2                	ld	s5,24(sp)
    800042d4:	6ba2                	ld	s7,8(sp)
    800042d6:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800042d8:	033a1c63          	bne	s4,s3,80004310 <filewrite+0x126>
    800042dc:	8552                	mv	a0,s4
    800042de:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800042e0:	60a6                	ld	ra,72(sp)
    800042e2:	6406                	ld	s0,64(sp)
    800042e4:	7942                	ld	s2,48(sp)
    800042e6:	7a02                	ld	s4,32(sp)
    800042e8:	6b42                	ld	s6,16(sp)
    800042ea:	6161                	addi	sp,sp,80
    800042ec:	8082                	ret
    800042ee:	fc26                	sd	s1,56(sp)
    800042f0:	f44e                	sd	s3,40(sp)
    800042f2:	ec56                	sd	s5,24(sp)
    800042f4:	e45e                	sd	s7,8(sp)
    800042f6:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800042f8:	00003517          	auipc	a0,0x3
    800042fc:	32050513          	addi	a0,a0,800 # 80007618 <etext+0x618>
    80004300:	c94fc0ef          	jal	80000794 <panic>
    return -1;
    80004304:	557d                	li	a0,-1
}
    80004306:	8082                	ret
      return -1;
    80004308:	557d                	li	a0,-1
    8000430a:	bfd9                	j	800042e0 <filewrite+0xf6>
    8000430c:	557d                	li	a0,-1
    8000430e:	bfc9                	j	800042e0 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80004310:	557d                	li	a0,-1
    80004312:	79a2                	ld	s3,40(sp)
    80004314:	b7f1                	j	800042e0 <filewrite+0xf6>

0000000080004316 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004316:	7179                	addi	sp,sp,-48
    80004318:	f406                	sd	ra,40(sp)
    8000431a:	f022                	sd	s0,32(sp)
    8000431c:	ec26                	sd	s1,24(sp)
    8000431e:	e052                	sd	s4,0(sp)
    80004320:	1800                	addi	s0,sp,48
    80004322:	84aa                	mv	s1,a0
    80004324:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004326:	0005b023          	sd	zero,0(a1)
    8000432a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000432e:	c3bff0ef          	jal	80003f68 <filealloc>
    80004332:	e088                	sd	a0,0(s1)
    80004334:	c549                	beqz	a0,800043be <pipealloc+0xa8>
    80004336:	c33ff0ef          	jal	80003f68 <filealloc>
    8000433a:	00aa3023          	sd	a0,0(s4)
    8000433e:	cd25                	beqz	a0,800043b6 <pipealloc+0xa0>
    80004340:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004342:	fe4fc0ef          	jal	80000b26 <kalloc>
    80004346:	892a                	mv	s2,a0
    80004348:	c12d                	beqz	a0,800043aa <pipealloc+0x94>
    8000434a:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000434c:	4985                	li	s3,1
    8000434e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004352:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004356:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000435a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000435e:	00003597          	auipc	a1,0x3
    80004362:	2ca58593          	addi	a1,a1,714 # 80007628 <etext+0x628>
    80004366:	811fc0ef          	jal	80000b76 <initlock>
  (*f0)->type = FD_PIPE;
    8000436a:	609c                	ld	a5,0(s1)
    8000436c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004370:	609c                	ld	a5,0(s1)
    80004372:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004376:	609c                	ld	a5,0(s1)
    80004378:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000437c:	609c                	ld	a5,0(s1)
    8000437e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004382:	000a3783          	ld	a5,0(s4)
    80004386:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000438a:	000a3783          	ld	a5,0(s4)
    8000438e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004392:	000a3783          	ld	a5,0(s4)
    80004396:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000439a:	000a3783          	ld	a5,0(s4)
    8000439e:	0127b823          	sd	s2,16(a5)
  return 0;
    800043a2:	4501                	li	a0,0
    800043a4:	6942                	ld	s2,16(sp)
    800043a6:	69a2                	ld	s3,8(sp)
    800043a8:	a01d                	j	800043ce <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800043aa:	6088                	ld	a0,0(s1)
    800043ac:	c119                	beqz	a0,800043b2 <pipealloc+0x9c>
    800043ae:	6942                	ld	s2,16(sp)
    800043b0:	a029                	j	800043ba <pipealloc+0xa4>
    800043b2:	6942                	ld	s2,16(sp)
    800043b4:	a029                	j	800043be <pipealloc+0xa8>
    800043b6:	6088                	ld	a0,0(s1)
    800043b8:	c10d                	beqz	a0,800043da <pipealloc+0xc4>
    fileclose(*f0);
    800043ba:	c53ff0ef          	jal	8000400c <fileclose>
  if(*f1)
    800043be:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800043c2:	557d                	li	a0,-1
  if(*f1)
    800043c4:	c789                	beqz	a5,800043ce <pipealloc+0xb8>
    fileclose(*f1);
    800043c6:	853e                	mv	a0,a5
    800043c8:	c45ff0ef          	jal	8000400c <fileclose>
  return -1;
    800043cc:	557d                	li	a0,-1
}
    800043ce:	70a2                	ld	ra,40(sp)
    800043d0:	7402                	ld	s0,32(sp)
    800043d2:	64e2                	ld	s1,24(sp)
    800043d4:	6a02                	ld	s4,0(sp)
    800043d6:	6145                	addi	sp,sp,48
    800043d8:	8082                	ret
  return -1;
    800043da:	557d                	li	a0,-1
    800043dc:	bfcd                	j	800043ce <pipealloc+0xb8>

00000000800043de <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800043de:	1101                	addi	sp,sp,-32
    800043e0:	ec06                	sd	ra,24(sp)
    800043e2:	e822                	sd	s0,16(sp)
    800043e4:	e426                	sd	s1,8(sp)
    800043e6:	e04a                	sd	s2,0(sp)
    800043e8:	1000                	addi	s0,sp,32
    800043ea:	84aa                	mv	s1,a0
    800043ec:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800043ee:	809fc0ef          	jal	80000bf6 <acquire>
  if(writable){
    800043f2:	02090763          	beqz	s2,80004420 <pipeclose+0x42>
    pi->writeopen = 0;
    800043f6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800043fa:	21848513          	addi	a0,s1,536
    800043fe:	8b9fd0ef          	jal	80001cb6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004402:	2204b783          	ld	a5,544(s1)
    80004406:	e785                	bnez	a5,8000442e <pipeclose+0x50>
    release(&pi->lock);
    80004408:	8526                	mv	a0,s1
    8000440a:	885fc0ef          	jal	80000c8e <release>
    kfree((char*)pi);
    8000440e:	8526                	mv	a0,s1
    80004410:	e32fc0ef          	jal	80000a42 <kfree>
  } else
    release(&pi->lock);
}
    80004414:	60e2                	ld	ra,24(sp)
    80004416:	6442                	ld	s0,16(sp)
    80004418:	64a2                	ld	s1,8(sp)
    8000441a:	6902                	ld	s2,0(sp)
    8000441c:	6105                	addi	sp,sp,32
    8000441e:	8082                	ret
    pi->readopen = 0;
    80004420:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004424:	21c48513          	addi	a0,s1,540
    80004428:	88ffd0ef          	jal	80001cb6 <wakeup>
    8000442c:	bfd9                	j	80004402 <pipeclose+0x24>
    release(&pi->lock);
    8000442e:	8526                	mv	a0,s1
    80004430:	85ffc0ef          	jal	80000c8e <release>
}
    80004434:	b7c5                	j	80004414 <pipeclose+0x36>

0000000080004436 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004436:	711d                	addi	sp,sp,-96
    80004438:	ec86                	sd	ra,88(sp)
    8000443a:	e8a2                	sd	s0,80(sp)
    8000443c:	e4a6                	sd	s1,72(sp)
    8000443e:	e0ca                	sd	s2,64(sp)
    80004440:	fc4e                	sd	s3,56(sp)
    80004442:	f852                	sd	s4,48(sp)
    80004444:	f456                	sd	s5,40(sp)
    80004446:	1080                	addi	s0,sp,96
    80004448:	84aa                	mv	s1,a0
    8000444a:	8aae                	mv	s5,a1
    8000444c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000444e:	c76fd0ef          	jal	800018c4 <myproc>
    80004452:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004454:	8526                	mv	a0,s1
    80004456:	fa0fc0ef          	jal	80000bf6 <acquire>
  while(i < n){
    8000445a:	0b405a63          	blez	s4,8000450e <pipewrite+0xd8>
    8000445e:	f05a                	sd	s6,32(sp)
    80004460:	ec5e                	sd	s7,24(sp)
    80004462:	e862                	sd	s8,16(sp)
  int i = 0;
    80004464:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004466:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004468:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000446c:	21c48b93          	addi	s7,s1,540
    80004470:	a81d                	j	800044a6 <pipewrite+0x70>
      release(&pi->lock);
    80004472:	8526                	mv	a0,s1
    80004474:	81bfc0ef          	jal	80000c8e <release>
      return -1;
    80004478:	597d                	li	s2,-1
    8000447a:	7b02                	ld	s6,32(sp)
    8000447c:	6be2                	ld	s7,24(sp)
    8000447e:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004480:	854a                	mv	a0,s2
    80004482:	60e6                	ld	ra,88(sp)
    80004484:	6446                	ld	s0,80(sp)
    80004486:	64a6                	ld	s1,72(sp)
    80004488:	6906                	ld	s2,64(sp)
    8000448a:	79e2                	ld	s3,56(sp)
    8000448c:	7a42                	ld	s4,48(sp)
    8000448e:	7aa2                	ld	s5,40(sp)
    80004490:	6125                	addi	sp,sp,96
    80004492:	8082                	ret
      wakeup(&pi->nread);
    80004494:	8562                	mv	a0,s8
    80004496:	821fd0ef          	jal	80001cb6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000449a:	85a6                	mv	a1,s1
    8000449c:	855e                	mv	a0,s7
    8000449e:	fccfd0ef          	jal	80001c6a <sleep>
  while(i < n){
    800044a2:	05495b63          	bge	s2,s4,800044f8 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800044a6:	2204a783          	lw	a5,544(s1)
    800044aa:	d7e1                	beqz	a5,80004472 <pipewrite+0x3c>
    800044ac:	854e                	mv	a0,s3
    800044ae:	945fd0ef          	jal	80001df2 <killed>
    800044b2:	f161                	bnez	a0,80004472 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800044b4:	2184a783          	lw	a5,536(s1)
    800044b8:	21c4a703          	lw	a4,540(s1)
    800044bc:	2007879b          	addiw	a5,a5,512
    800044c0:	fcf70ae3          	beq	a4,a5,80004494 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800044c4:	4685                	li	a3,1
    800044c6:	01590633          	add	a2,s2,s5
    800044ca:	faf40593          	addi	a1,s0,-81
    800044ce:	0509b503          	ld	a0,80(s3)
    800044d2:	92cfd0ef          	jal	800015fe <copyin>
    800044d6:	03650e63          	beq	a0,s6,80004512 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800044da:	21c4a783          	lw	a5,540(s1)
    800044de:	0017871b          	addiw	a4,a5,1
    800044e2:	20e4ae23          	sw	a4,540(s1)
    800044e6:	1ff7f793          	andi	a5,a5,511
    800044ea:	97a6                	add	a5,a5,s1
    800044ec:	faf44703          	lbu	a4,-81(s0)
    800044f0:	00e78c23          	sb	a4,24(a5)
      i++;
    800044f4:	2905                	addiw	s2,s2,1
    800044f6:	b775                	j	800044a2 <pipewrite+0x6c>
    800044f8:	7b02                	ld	s6,32(sp)
    800044fa:	6be2                	ld	s7,24(sp)
    800044fc:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800044fe:	21848513          	addi	a0,s1,536
    80004502:	fb4fd0ef          	jal	80001cb6 <wakeup>
  release(&pi->lock);
    80004506:	8526                	mv	a0,s1
    80004508:	f86fc0ef          	jal	80000c8e <release>
  return i;
    8000450c:	bf95                	j	80004480 <pipewrite+0x4a>
  int i = 0;
    8000450e:	4901                	li	s2,0
    80004510:	b7fd                	j	800044fe <pipewrite+0xc8>
    80004512:	7b02                	ld	s6,32(sp)
    80004514:	6be2                	ld	s7,24(sp)
    80004516:	6c42                	ld	s8,16(sp)
    80004518:	b7dd                	j	800044fe <pipewrite+0xc8>

000000008000451a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000451a:	715d                	addi	sp,sp,-80
    8000451c:	e486                	sd	ra,72(sp)
    8000451e:	e0a2                	sd	s0,64(sp)
    80004520:	fc26                	sd	s1,56(sp)
    80004522:	f84a                	sd	s2,48(sp)
    80004524:	f44e                	sd	s3,40(sp)
    80004526:	f052                	sd	s4,32(sp)
    80004528:	ec56                	sd	s5,24(sp)
    8000452a:	0880                	addi	s0,sp,80
    8000452c:	84aa                	mv	s1,a0
    8000452e:	892e                	mv	s2,a1
    80004530:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004532:	b92fd0ef          	jal	800018c4 <myproc>
    80004536:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004538:	8526                	mv	a0,s1
    8000453a:	ebcfc0ef          	jal	80000bf6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000453e:	2184a703          	lw	a4,536(s1)
    80004542:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004546:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000454a:	02f71563          	bne	a4,a5,80004574 <piperead+0x5a>
    8000454e:	2244a783          	lw	a5,548(s1)
    80004552:	cb85                	beqz	a5,80004582 <piperead+0x68>
    if(killed(pr)){
    80004554:	8552                	mv	a0,s4
    80004556:	89dfd0ef          	jal	80001df2 <killed>
    8000455a:	ed19                	bnez	a0,80004578 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000455c:	85a6                	mv	a1,s1
    8000455e:	854e                	mv	a0,s3
    80004560:	f0afd0ef          	jal	80001c6a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004564:	2184a703          	lw	a4,536(s1)
    80004568:	21c4a783          	lw	a5,540(s1)
    8000456c:	fef701e3          	beq	a4,a5,8000454e <piperead+0x34>
    80004570:	e85a                	sd	s6,16(sp)
    80004572:	a809                	j	80004584 <piperead+0x6a>
    80004574:	e85a                	sd	s6,16(sp)
    80004576:	a039                	j	80004584 <piperead+0x6a>
      release(&pi->lock);
    80004578:	8526                	mv	a0,s1
    8000457a:	f14fc0ef          	jal	80000c8e <release>
      return -1;
    8000457e:	59fd                	li	s3,-1
    80004580:	a8b1                	j	800045dc <piperead+0xc2>
    80004582:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004584:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004586:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004588:	05505263          	blez	s5,800045cc <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    8000458c:	2184a783          	lw	a5,536(s1)
    80004590:	21c4a703          	lw	a4,540(s1)
    80004594:	02f70c63          	beq	a4,a5,800045cc <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004598:	0017871b          	addiw	a4,a5,1
    8000459c:	20e4ac23          	sw	a4,536(s1)
    800045a0:	1ff7f793          	andi	a5,a5,511
    800045a4:	97a6                	add	a5,a5,s1
    800045a6:	0187c783          	lbu	a5,24(a5)
    800045aa:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800045ae:	4685                	li	a3,1
    800045b0:	fbf40613          	addi	a2,s0,-65
    800045b4:	85ca                	mv	a1,s2
    800045b6:	050a3503          	ld	a0,80(s4)
    800045ba:	f6ffc0ef          	jal	80001528 <copyout>
    800045be:	01650763          	beq	a0,s6,800045cc <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800045c2:	2985                	addiw	s3,s3,1
    800045c4:	0905                	addi	s2,s2,1
    800045c6:	fd3a93e3          	bne	s5,s3,8000458c <piperead+0x72>
    800045ca:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800045cc:	21c48513          	addi	a0,s1,540
    800045d0:	ee6fd0ef          	jal	80001cb6 <wakeup>
  release(&pi->lock);
    800045d4:	8526                	mv	a0,s1
    800045d6:	eb8fc0ef          	jal	80000c8e <release>
    800045da:	6b42                	ld	s6,16(sp)
  return i;
}
    800045dc:	854e                	mv	a0,s3
    800045de:	60a6                	ld	ra,72(sp)
    800045e0:	6406                	ld	s0,64(sp)
    800045e2:	74e2                	ld	s1,56(sp)
    800045e4:	7942                	ld	s2,48(sp)
    800045e6:	79a2                	ld	s3,40(sp)
    800045e8:	7a02                	ld	s4,32(sp)
    800045ea:	6ae2                	ld	s5,24(sp)
    800045ec:	6161                	addi	sp,sp,80
    800045ee:	8082                	ret

00000000800045f0 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800045f0:	1141                	addi	sp,sp,-16
    800045f2:	e422                	sd	s0,8(sp)
    800045f4:	0800                	addi	s0,sp,16
    800045f6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800045f8:	8905                	andi	a0,a0,1
    800045fa:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800045fc:	8b89                	andi	a5,a5,2
    800045fe:	c399                	beqz	a5,80004604 <flags2perm+0x14>
      perm |= PTE_W;
    80004600:	00456513          	ori	a0,a0,4
    return perm;
}
    80004604:	6422                	ld	s0,8(sp)
    80004606:	0141                	addi	sp,sp,16
    80004608:	8082                	ret

000000008000460a <exec>:

int
exec(char *path, char **argv)
{
    8000460a:	df010113          	addi	sp,sp,-528
    8000460e:	20113423          	sd	ra,520(sp)
    80004612:	20813023          	sd	s0,512(sp)
    80004616:	ffa6                	sd	s1,504(sp)
    80004618:	fbca                	sd	s2,496(sp)
    8000461a:	0c00                	addi	s0,sp,528
    8000461c:	892a                	mv	s2,a0
    8000461e:	dea43c23          	sd	a0,-520(s0)
    80004622:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004626:	a9efd0ef          	jal	800018c4 <myproc>
    8000462a:	84aa                	mv	s1,a0

  begin_op();
    8000462c:	dc6ff0ef          	jal	80003bf2 <begin_op>

  if((ip = namei(path)) == 0){
    80004630:	854a                	mv	a0,s2
    80004632:	c04ff0ef          	jal	80003a36 <namei>
    80004636:	c931                	beqz	a0,8000468a <exec+0x80>
    80004638:	f3d2                	sd	s4,480(sp)
    8000463a:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000463c:	d21fe0ef          	jal	8000335c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004640:	04000713          	li	a4,64
    80004644:	4681                	li	a3,0
    80004646:	e5040613          	addi	a2,s0,-432
    8000464a:	4581                	li	a1,0
    8000464c:	8552                	mv	a0,s4
    8000464e:	f63fe0ef          	jal	800035b0 <readi>
    80004652:	04000793          	li	a5,64
    80004656:	00f51a63          	bne	a0,a5,8000466a <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000465a:	e5042703          	lw	a4,-432(s0)
    8000465e:	464c47b7          	lui	a5,0x464c4
    80004662:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004666:	02f70663          	beq	a4,a5,80004692 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000466a:	8552                	mv	a0,s4
    8000466c:	efbfe0ef          	jal	80003566 <iunlockput>
    end_op();
    80004670:	decff0ef          	jal	80003c5c <end_op>
  }
  return -1;
    80004674:	557d                	li	a0,-1
    80004676:	7a1e                	ld	s4,480(sp)
}
    80004678:	20813083          	ld	ra,520(sp)
    8000467c:	20013403          	ld	s0,512(sp)
    80004680:	74fe                	ld	s1,504(sp)
    80004682:	795e                	ld	s2,496(sp)
    80004684:	21010113          	addi	sp,sp,528
    80004688:	8082                	ret
    end_op();
    8000468a:	dd2ff0ef          	jal	80003c5c <end_op>
    return -1;
    8000468e:	557d                	li	a0,-1
    80004690:	b7e5                	j	80004678 <exec+0x6e>
    80004692:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004694:	8526                	mv	a0,s1
    80004696:	b1afd0ef          	jal	800019b0 <proc_pagetable>
    8000469a:	8b2a                	mv	s6,a0
    8000469c:	2c050b63          	beqz	a0,80004972 <exec+0x368>
    800046a0:	f7ce                	sd	s3,488(sp)
    800046a2:	efd6                	sd	s5,472(sp)
    800046a4:	e7de                	sd	s7,456(sp)
    800046a6:	e3e2                	sd	s8,448(sp)
    800046a8:	ff66                	sd	s9,440(sp)
    800046aa:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800046ac:	e7042d03          	lw	s10,-400(s0)
    800046b0:	e8845783          	lhu	a5,-376(s0)
    800046b4:	12078963          	beqz	a5,800047e6 <exec+0x1dc>
    800046b8:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800046ba:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800046bc:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800046be:	6c85                	lui	s9,0x1
    800046c0:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800046c4:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800046c8:	6a85                	lui	s5,0x1
    800046ca:	a085                	j	8000472a <exec+0x120>
      panic("loadseg: address should exist");
    800046cc:	00003517          	auipc	a0,0x3
    800046d0:	f6450513          	addi	a0,a0,-156 # 80007630 <etext+0x630>
    800046d4:	8c0fc0ef          	jal	80000794 <panic>
    if(sz - i < PGSIZE)
    800046d8:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800046da:	8726                	mv	a4,s1
    800046dc:	012c06bb          	addw	a3,s8,s2
    800046e0:	4581                	li	a1,0
    800046e2:	8552                	mv	a0,s4
    800046e4:	ecdfe0ef          	jal	800035b0 <readi>
    800046e8:	2501                	sext.w	a0,a0
    800046ea:	24a49a63          	bne	s1,a0,8000493e <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    800046ee:	012a893b          	addw	s2,s5,s2
    800046f2:	03397363          	bgeu	s2,s3,80004718 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    800046f6:	02091593          	slli	a1,s2,0x20
    800046fa:	9181                	srli	a1,a1,0x20
    800046fc:	95de                	add	a1,a1,s7
    800046fe:	855a                	mv	a0,s6
    80004700:	8c1fc0ef          	jal	80000fc0 <walkaddr>
    80004704:	862a                	mv	a2,a0
    if(pa == 0)
    80004706:	d179                	beqz	a0,800046cc <exec+0xc2>
    if(sz - i < PGSIZE)
    80004708:	412984bb          	subw	s1,s3,s2
    8000470c:	0004879b          	sext.w	a5,s1
    80004710:	fcfcf4e3          	bgeu	s9,a5,800046d8 <exec+0xce>
    80004714:	84d6                	mv	s1,s5
    80004716:	b7c9                	j	800046d8 <exec+0xce>
    sz = sz1;
    80004718:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000471c:	2d85                	addiw	s11,s11,1
    8000471e:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004722:	e8845783          	lhu	a5,-376(s0)
    80004726:	08fdd063          	bge	s11,a5,800047a6 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000472a:	2d01                	sext.w	s10,s10
    8000472c:	03800713          	li	a4,56
    80004730:	86ea                	mv	a3,s10
    80004732:	e1840613          	addi	a2,s0,-488
    80004736:	4581                	li	a1,0
    80004738:	8552                	mv	a0,s4
    8000473a:	e77fe0ef          	jal	800035b0 <readi>
    8000473e:	03800793          	li	a5,56
    80004742:	1cf51663          	bne	a0,a5,8000490e <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004746:	e1842783          	lw	a5,-488(s0)
    8000474a:	4705                	li	a4,1
    8000474c:	fce798e3          	bne	a5,a4,8000471c <exec+0x112>
    if(ph.memsz < ph.filesz)
    80004750:	e4043483          	ld	s1,-448(s0)
    80004754:	e3843783          	ld	a5,-456(s0)
    80004758:	1af4ef63          	bltu	s1,a5,80004916 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000475c:	e2843783          	ld	a5,-472(s0)
    80004760:	94be                	add	s1,s1,a5
    80004762:	1af4ee63          	bltu	s1,a5,8000491e <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004766:	df043703          	ld	a4,-528(s0)
    8000476a:	8ff9                	and	a5,a5,a4
    8000476c:	1a079d63          	bnez	a5,80004926 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004770:	e1c42503          	lw	a0,-484(s0)
    80004774:	e7dff0ef          	jal	800045f0 <flags2perm>
    80004778:	86aa                	mv	a3,a0
    8000477a:	8626                	mv	a2,s1
    8000477c:	85ca                	mv	a1,s2
    8000477e:	855a                	mv	a0,s6
    80004780:	b95fc0ef          	jal	80001314 <uvmalloc>
    80004784:	e0a43423          	sd	a0,-504(s0)
    80004788:	1a050363          	beqz	a0,8000492e <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000478c:	e2843b83          	ld	s7,-472(s0)
    80004790:	e2042c03          	lw	s8,-480(s0)
    80004794:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004798:	00098463          	beqz	s3,800047a0 <exec+0x196>
    8000479c:	4901                	li	s2,0
    8000479e:	bfa1                	j	800046f6 <exec+0xec>
    sz = sz1;
    800047a0:	e0843903          	ld	s2,-504(s0)
    800047a4:	bfa5                	j	8000471c <exec+0x112>
    800047a6:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800047a8:	8552                	mv	a0,s4
    800047aa:	dbdfe0ef          	jal	80003566 <iunlockput>
  end_op();
    800047ae:	caeff0ef          	jal	80003c5c <end_op>
  p = myproc();
    800047b2:	912fd0ef          	jal	800018c4 <myproc>
    800047b6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800047b8:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800047bc:	6985                	lui	s3,0x1
    800047be:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800047c0:	99ca                	add	s3,s3,s2
    800047c2:	77fd                	lui	a5,0xfffff
    800047c4:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800047c8:	4691                	li	a3,4
    800047ca:	6609                	lui	a2,0x2
    800047cc:	964e                	add	a2,a2,s3
    800047ce:	85ce                	mv	a1,s3
    800047d0:	855a                	mv	a0,s6
    800047d2:	b43fc0ef          	jal	80001314 <uvmalloc>
    800047d6:	892a                	mv	s2,a0
    800047d8:	e0a43423          	sd	a0,-504(s0)
    800047dc:	e519                	bnez	a0,800047ea <exec+0x1e0>
  if(pagetable)
    800047de:	e1343423          	sd	s3,-504(s0)
    800047e2:	4a01                	li	s4,0
    800047e4:	aab1                	j	80004940 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800047e6:	4901                	li	s2,0
    800047e8:	b7c1                	j	800047a8 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800047ea:	75f9                	lui	a1,0xffffe
    800047ec:	95aa                	add	a1,a1,a0
    800047ee:	855a                	mv	a0,s6
    800047f0:	d0ffc0ef          	jal	800014fe <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800047f4:	7bfd                	lui	s7,0xfffff
    800047f6:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800047f8:	e0043783          	ld	a5,-512(s0)
    800047fc:	6388                	ld	a0,0(a5)
    800047fe:	cd39                	beqz	a0,8000485c <exec+0x252>
    80004800:	e9040993          	addi	s3,s0,-368
    80004804:	f9040c13          	addi	s8,s0,-112
    80004808:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000480a:	e30fc0ef          	jal	80000e3a <strlen>
    8000480e:	0015079b          	addiw	a5,a0,1
    80004812:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004816:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000481a:	11796e63          	bltu	s2,s7,80004936 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000481e:	e0043d03          	ld	s10,-512(s0)
    80004822:	000d3a03          	ld	s4,0(s10)
    80004826:	8552                	mv	a0,s4
    80004828:	e12fc0ef          	jal	80000e3a <strlen>
    8000482c:	0015069b          	addiw	a3,a0,1
    80004830:	8652                	mv	a2,s4
    80004832:	85ca                	mv	a1,s2
    80004834:	855a                	mv	a0,s6
    80004836:	cf3fc0ef          	jal	80001528 <copyout>
    8000483a:	10054063          	bltz	a0,8000493a <exec+0x330>
    ustack[argc] = sp;
    8000483e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004842:	0485                	addi	s1,s1,1
    80004844:	008d0793          	addi	a5,s10,8
    80004848:	e0f43023          	sd	a5,-512(s0)
    8000484c:	008d3503          	ld	a0,8(s10)
    80004850:	c909                	beqz	a0,80004862 <exec+0x258>
    if(argc >= MAXARG)
    80004852:	09a1                	addi	s3,s3,8
    80004854:	fb899be3          	bne	s3,s8,8000480a <exec+0x200>
  ip = 0;
    80004858:	4a01                	li	s4,0
    8000485a:	a0dd                	j	80004940 <exec+0x336>
  sp = sz;
    8000485c:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004860:	4481                	li	s1,0
  ustack[argc] = 0;
    80004862:	00349793          	slli	a5,s1,0x3
    80004866:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffe3520>
    8000486a:	97a2                	add	a5,a5,s0
    8000486c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004870:	00148693          	addi	a3,s1,1
    80004874:	068e                	slli	a3,a3,0x3
    80004876:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000487a:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000487e:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004882:	f5796ee3          	bltu	s2,s7,800047de <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004886:	e9040613          	addi	a2,s0,-368
    8000488a:	85ca                	mv	a1,s2
    8000488c:	855a                	mv	a0,s6
    8000488e:	c9bfc0ef          	jal	80001528 <copyout>
    80004892:	0e054263          	bltz	a0,80004976 <exec+0x36c>
  p->trapframe->a1 = sp;
    80004896:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    8000489a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000489e:	df843783          	ld	a5,-520(s0)
    800048a2:	0007c703          	lbu	a4,0(a5)
    800048a6:	cf11                	beqz	a4,800048c2 <exec+0x2b8>
    800048a8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800048aa:	02f00693          	li	a3,47
    800048ae:	a039                	j	800048bc <exec+0x2b2>
      last = s+1;
    800048b0:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800048b4:	0785                	addi	a5,a5,1
    800048b6:	fff7c703          	lbu	a4,-1(a5)
    800048ba:	c701                	beqz	a4,800048c2 <exec+0x2b8>
    if(*s == '/')
    800048bc:	fed71ce3          	bne	a4,a3,800048b4 <exec+0x2aa>
    800048c0:	bfc5                	j	800048b0 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    800048c2:	4641                	li	a2,16
    800048c4:	df843583          	ld	a1,-520(s0)
    800048c8:	160a8513          	addi	a0,s5,352
    800048cc:	d3cfc0ef          	jal	80000e08 <safestrcpy>
  oldpagetable = p->pagetable;
    800048d0:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800048d4:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800048d8:	e0843783          	ld	a5,-504(s0)
    800048dc:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800048e0:	060ab783          	ld	a5,96(s5)
    800048e4:	e6843703          	ld	a4,-408(s0)
    800048e8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800048ea:	060ab783          	ld	a5,96(s5)
    800048ee:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800048f2:	85e6                	mv	a1,s9
    800048f4:	93cfd0ef          	jal	80001a30 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800048f8:	0004851b          	sext.w	a0,s1
    800048fc:	79be                	ld	s3,488(sp)
    800048fe:	7a1e                	ld	s4,480(sp)
    80004900:	6afe                	ld	s5,472(sp)
    80004902:	6b5e                	ld	s6,464(sp)
    80004904:	6bbe                	ld	s7,456(sp)
    80004906:	6c1e                	ld	s8,448(sp)
    80004908:	7cfa                	ld	s9,440(sp)
    8000490a:	7d5a                	ld	s10,432(sp)
    8000490c:	b3b5                	j	80004678 <exec+0x6e>
    8000490e:	e1243423          	sd	s2,-504(s0)
    80004912:	7dba                	ld	s11,424(sp)
    80004914:	a035                	j	80004940 <exec+0x336>
    80004916:	e1243423          	sd	s2,-504(s0)
    8000491a:	7dba                	ld	s11,424(sp)
    8000491c:	a015                	j	80004940 <exec+0x336>
    8000491e:	e1243423          	sd	s2,-504(s0)
    80004922:	7dba                	ld	s11,424(sp)
    80004924:	a831                	j	80004940 <exec+0x336>
    80004926:	e1243423          	sd	s2,-504(s0)
    8000492a:	7dba                	ld	s11,424(sp)
    8000492c:	a811                	j	80004940 <exec+0x336>
    8000492e:	e1243423          	sd	s2,-504(s0)
    80004932:	7dba                	ld	s11,424(sp)
    80004934:	a031                	j	80004940 <exec+0x336>
  ip = 0;
    80004936:	4a01                	li	s4,0
    80004938:	a021                	j	80004940 <exec+0x336>
    8000493a:	4a01                	li	s4,0
  if(pagetable)
    8000493c:	a011                	j	80004940 <exec+0x336>
    8000493e:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004940:	e0843583          	ld	a1,-504(s0)
    80004944:	855a                	mv	a0,s6
    80004946:	8eafd0ef          	jal	80001a30 <proc_freepagetable>
  return -1;
    8000494a:	557d                	li	a0,-1
  if(ip){
    8000494c:	000a1b63          	bnez	s4,80004962 <exec+0x358>
    80004950:	79be                	ld	s3,488(sp)
    80004952:	7a1e                	ld	s4,480(sp)
    80004954:	6afe                	ld	s5,472(sp)
    80004956:	6b5e                	ld	s6,464(sp)
    80004958:	6bbe                	ld	s7,456(sp)
    8000495a:	6c1e                	ld	s8,448(sp)
    8000495c:	7cfa                	ld	s9,440(sp)
    8000495e:	7d5a                	ld	s10,432(sp)
    80004960:	bb21                	j	80004678 <exec+0x6e>
    80004962:	79be                	ld	s3,488(sp)
    80004964:	6afe                	ld	s5,472(sp)
    80004966:	6b5e                	ld	s6,464(sp)
    80004968:	6bbe                	ld	s7,456(sp)
    8000496a:	6c1e                	ld	s8,448(sp)
    8000496c:	7cfa                	ld	s9,440(sp)
    8000496e:	7d5a                	ld	s10,432(sp)
    80004970:	b9ed                	j	8000466a <exec+0x60>
    80004972:	6b5e                	ld	s6,464(sp)
    80004974:	b9dd                	j	8000466a <exec+0x60>
  sz = sz1;
    80004976:	e0843983          	ld	s3,-504(s0)
    8000497a:	b595                	j	800047de <exec+0x1d4>

000000008000497c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000497c:	7179                	addi	sp,sp,-48
    8000497e:	f406                	sd	ra,40(sp)
    80004980:	f022                	sd	s0,32(sp)
    80004982:	ec26                	sd	s1,24(sp)
    80004984:	e84a                	sd	s2,16(sp)
    80004986:	1800                	addi	s0,sp,48
    80004988:	892e                	mv	s2,a1
    8000498a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000498c:	fdc40593          	addi	a1,s0,-36
    80004990:	fb7fd0ef          	jal	80002946 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004994:	fdc42703          	lw	a4,-36(s0)
    80004998:	47bd                	li	a5,15
    8000499a:	02e7e963          	bltu	a5,a4,800049cc <argfd+0x50>
    8000499e:	f27fc0ef          	jal	800018c4 <myproc>
    800049a2:	fdc42703          	lw	a4,-36(s0)
    800049a6:	01a70793          	addi	a5,a4,26
    800049aa:	078e                	slli	a5,a5,0x3
    800049ac:	953e                	add	a0,a0,a5
    800049ae:	651c                	ld	a5,8(a0)
    800049b0:	c385                	beqz	a5,800049d0 <argfd+0x54>
    return -1;
  if(pfd)
    800049b2:	00090463          	beqz	s2,800049ba <argfd+0x3e>
    *pfd = fd;
    800049b6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800049ba:	4501                	li	a0,0
  if(pf)
    800049bc:	c091                	beqz	s1,800049c0 <argfd+0x44>
    *pf = f;
    800049be:	e09c                	sd	a5,0(s1)
}
    800049c0:	70a2                	ld	ra,40(sp)
    800049c2:	7402                	ld	s0,32(sp)
    800049c4:	64e2                	ld	s1,24(sp)
    800049c6:	6942                	ld	s2,16(sp)
    800049c8:	6145                	addi	sp,sp,48
    800049ca:	8082                	ret
    return -1;
    800049cc:	557d                	li	a0,-1
    800049ce:	bfcd                	j	800049c0 <argfd+0x44>
    800049d0:	557d                	li	a0,-1
    800049d2:	b7fd                	j	800049c0 <argfd+0x44>

00000000800049d4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800049d4:	1101                	addi	sp,sp,-32
    800049d6:	ec06                	sd	ra,24(sp)
    800049d8:	e822                	sd	s0,16(sp)
    800049da:	e426                	sd	s1,8(sp)
    800049dc:	1000                	addi	s0,sp,32
    800049de:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800049e0:	ee5fc0ef          	jal	800018c4 <myproc>
    800049e4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800049e6:	0d850793          	addi	a5,a0,216
    800049ea:	4501                	li	a0,0
    800049ec:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800049ee:	6398                	ld	a4,0(a5)
    800049f0:	cb19                	beqz	a4,80004a06 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800049f2:	2505                	addiw	a0,a0,1
    800049f4:	07a1                	addi	a5,a5,8
    800049f6:	fed51ce3          	bne	a0,a3,800049ee <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800049fa:	557d                	li	a0,-1
}
    800049fc:	60e2                	ld	ra,24(sp)
    800049fe:	6442                	ld	s0,16(sp)
    80004a00:	64a2                	ld	s1,8(sp)
    80004a02:	6105                	addi	sp,sp,32
    80004a04:	8082                	ret
      p->ofile[fd] = f;
    80004a06:	01a50793          	addi	a5,a0,26
    80004a0a:	078e                	slli	a5,a5,0x3
    80004a0c:	963e                	add	a2,a2,a5
    80004a0e:	e604                	sd	s1,8(a2)
      return fd;
    80004a10:	b7f5                	j	800049fc <fdalloc+0x28>

0000000080004a12 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004a12:	715d                	addi	sp,sp,-80
    80004a14:	e486                	sd	ra,72(sp)
    80004a16:	e0a2                	sd	s0,64(sp)
    80004a18:	fc26                	sd	s1,56(sp)
    80004a1a:	f84a                	sd	s2,48(sp)
    80004a1c:	f44e                	sd	s3,40(sp)
    80004a1e:	ec56                	sd	s5,24(sp)
    80004a20:	e85a                	sd	s6,16(sp)
    80004a22:	0880                	addi	s0,sp,80
    80004a24:	8b2e                	mv	s6,a1
    80004a26:	89b2                	mv	s3,a2
    80004a28:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004a2a:	fb040593          	addi	a1,s0,-80
    80004a2e:	822ff0ef          	jal	80003a50 <nameiparent>
    80004a32:	84aa                	mv	s1,a0
    80004a34:	10050a63          	beqz	a0,80004b48 <create+0x136>
    return 0;

  ilock(dp);
    80004a38:	925fe0ef          	jal	8000335c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004a3c:	4601                	li	a2,0
    80004a3e:	fb040593          	addi	a1,s0,-80
    80004a42:	8526                	mv	a0,s1
    80004a44:	d8dfe0ef          	jal	800037d0 <dirlookup>
    80004a48:	8aaa                	mv	s5,a0
    80004a4a:	c129                	beqz	a0,80004a8c <create+0x7a>
    iunlockput(dp);
    80004a4c:	8526                	mv	a0,s1
    80004a4e:	b19fe0ef          	jal	80003566 <iunlockput>
    ilock(ip);
    80004a52:	8556                	mv	a0,s5
    80004a54:	909fe0ef          	jal	8000335c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004a58:	4789                	li	a5,2
    80004a5a:	02fb1463          	bne	s6,a5,80004a82 <create+0x70>
    80004a5e:	044ad783          	lhu	a5,68(s5)
    80004a62:	37f9                	addiw	a5,a5,-2
    80004a64:	17c2                	slli	a5,a5,0x30
    80004a66:	93c1                	srli	a5,a5,0x30
    80004a68:	4705                	li	a4,1
    80004a6a:	00f76c63          	bltu	a4,a5,80004a82 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004a6e:	8556                	mv	a0,s5
    80004a70:	60a6                	ld	ra,72(sp)
    80004a72:	6406                	ld	s0,64(sp)
    80004a74:	74e2                	ld	s1,56(sp)
    80004a76:	7942                	ld	s2,48(sp)
    80004a78:	79a2                	ld	s3,40(sp)
    80004a7a:	6ae2                	ld	s5,24(sp)
    80004a7c:	6b42                	ld	s6,16(sp)
    80004a7e:	6161                	addi	sp,sp,80
    80004a80:	8082                	ret
    iunlockput(ip);
    80004a82:	8556                	mv	a0,s5
    80004a84:	ae3fe0ef          	jal	80003566 <iunlockput>
    return 0;
    80004a88:	4a81                	li	s5,0
    80004a8a:	b7d5                	j	80004a6e <create+0x5c>
    80004a8c:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004a8e:	85da                	mv	a1,s6
    80004a90:	4088                	lw	a0,0(s1)
    80004a92:	f5afe0ef          	jal	800031ec <ialloc>
    80004a96:	8a2a                	mv	s4,a0
    80004a98:	cd15                	beqz	a0,80004ad4 <create+0xc2>
  ilock(ip);
    80004a9a:	8c3fe0ef          	jal	8000335c <ilock>
  ip->major = major;
    80004a9e:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004aa2:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004aa6:	4905                	li	s2,1
    80004aa8:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004aac:	8552                	mv	a0,s4
    80004aae:	ffafe0ef          	jal	800032a8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004ab2:	032b0763          	beq	s6,s2,80004ae0 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004ab6:	004a2603          	lw	a2,4(s4)
    80004aba:	fb040593          	addi	a1,s0,-80
    80004abe:	8526                	mv	a0,s1
    80004ac0:	eddfe0ef          	jal	8000399c <dirlink>
    80004ac4:	06054563          	bltz	a0,80004b2e <create+0x11c>
  iunlockput(dp);
    80004ac8:	8526                	mv	a0,s1
    80004aca:	a9dfe0ef          	jal	80003566 <iunlockput>
  return ip;
    80004ace:	8ad2                	mv	s5,s4
    80004ad0:	7a02                	ld	s4,32(sp)
    80004ad2:	bf71                	j	80004a6e <create+0x5c>
    iunlockput(dp);
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	a91fe0ef          	jal	80003566 <iunlockput>
    return 0;
    80004ada:	8ad2                	mv	s5,s4
    80004adc:	7a02                	ld	s4,32(sp)
    80004ade:	bf41                	j	80004a6e <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004ae0:	004a2603          	lw	a2,4(s4)
    80004ae4:	00003597          	auipc	a1,0x3
    80004ae8:	b6c58593          	addi	a1,a1,-1172 # 80007650 <etext+0x650>
    80004aec:	8552                	mv	a0,s4
    80004aee:	eaffe0ef          	jal	8000399c <dirlink>
    80004af2:	02054e63          	bltz	a0,80004b2e <create+0x11c>
    80004af6:	40d0                	lw	a2,4(s1)
    80004af8:	00003597          	auipc	a1,0x3
    80004afc:	b6058593          	addi	a1,a1,-1184 # 80007658 <etext+0x658>
    80004b00:	8552                	mv	a0,s4
    80004b02:	e9bfe0ef          	jal	8000399c <dirlink>
    80004b06:	02054463          	bltz	a0,80004b2e <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004b0a:	004a2603          	lw	a2,4(s4)
    80004b0e:	fb040593          	addi	a1,s0,-80
    80004b12:	8526                	mv	a0,s1
    80004b14:	e89fe0ef          	jal	8000399c <dirlink>
    80004b18:	00054b63          	bltz	a0,80004b2e <create+0x11c>
    dp->nlink++;  // for ".."
    80004b1c:	04a4d783          	lhu	a5,74(s1)
    80004b20:	2785                	addiw	a5,a5,1
    80004b22:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b26:	8526                	mv	a0,s1
    80004b28:	f80fe0ef          	jal	800032a8 <iupdate>
    80004b2c:	bf71                	j	80004ac8 <create+0xb6>
  ip->nlink = 0;
    80004b2e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004b32:	8552                	mv	a0,s4
    80004b34:	f74fe0ef          	jal	800032a8 <iupdate>
  iunlockput(ip);
    80004b38:	8552                	mv	a0,s4
    80004b3a:	a2dfe0ef          	jal	80003566 <iunlockput>
  iunlockput(dp);
    80004b3e:	8526                	mv	a0,s1
    80004b40:	a27fe0ef          	jal	80003566 <iunlockput>
  return 0;
    80004b44:	7a02                	ld	s4,32(sp)
    80004b46:	b725                	j	80004a6e <create+0x5c>
    return 0;
    80004b48:	8aaa                	mv	s5,a0
    80004b4a:	b715                	j	80004a6e <create+0x5c>

0000000080004b4c <sys_dup>:
{
    80004b4c:	7179                	addi	sp,sp,-48
    80004b4e:	f406                	sd	ra,40(sp)
    80004b50:	f022                	sd	s0,32(sp)
    80004b52:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004b54:	fd840613          	addi	a2,s0,-40
    80004b58:	4581                	li	a1,0
    80004b5a:	4501                	li	a0,0
    80004b5c:	e21ff0ef          	jal	8000497c <argfd>
    return -1;
    80004b60:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004b62:	02054363          	bltz	a0,80004b88 <sys_dup+0x3c>
    80004b66:	ec26                	sd	s1,24(sp)
    80004b68:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004b6a:	fd843903          	ld	s2,-40(s0)
    80004b6e:	854a                	mv	a0,s2
    80004b70:	e65ff0ef          	jal	800049d4 <fdalloc>
    80004b74:	84aa                	mv	s1,a0
    return -1;
    80004b76:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004b78:	00054d63          	bltz	a0,80004b92 <sys_dup+0x46>
  filedup(f);
    80004b7c:	854a                	mv	a0,s2
    80004b7e:	c48ff0ef          	jal	80003fc6 <filedup>
  return fd;
    80004b82:	87a6                	mv	a5,s1
    80004b84:	64e2                	ld	s1,24(sp)
    80004b86:	6942                	ld	s2,16(sp)
}
    80004b88:	853e                	mv	a0,a5
    80004b8a:	70a2                	ld	ra,40(sp)
    80004b8c:	7402                	ld	s0,32(sp)
    80004b8e:	6145                	addi	sp,sp,48
    80004b90:	8082                	ret
    80004b92:	64e2                	ld	s1,24(sp)
    80004b94:	6942                	ld	s2,16(sp)
    80004b96:	bfcd                	j	80004b88 <sys_dup+0x3c>

0000000080004b98 <sys_read>:
{
    80004b98:	7179                	addi	sp,sp,-48
    80004b9a:	f406                	sd	ra,40(sp)
    80004b9c:	f022                	sd	s0,32(sp)
    80004b9e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004ba0:	fd840593          	addi	a1,s0,-40
    80004ba4:	4505                	li	a0,1
    80004ba6:	dbdfd0ef          	jal	80002962 <argaddr>
  argint(2, &n);
    80004baa:	fe440593          	addi	a1,s0,-28
    80004bae:	4509                	li	a0,2
    80004bb0:	d97fd0ef          	jal	80002946 <argint>
  if(argfd(0, 0, &f) < 0)
    80004bb4:	fe840613          	addi	a2,s0,-24
    80004bb8:	4581                	li	a1,0
    80004bba:	4501                	li	a0,0
    80004bbc:	dc1ff0ef          	jal	8000497c <argfd>
    80004bc0:	87aa                	mv	a5,a0
    return -1;
    80004bc2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004bc4:	0007ca63          	bltz	a5,80004bd8 <sys_read+0x40>
  return fileread(f, p, n);
    80004bc8:	fe442603          	lw	a2,-28(s0)
    80004bcc:	fd843583          	ld	a1,-40(s0)
    80004bd0:	fe843503          	ld	a0,-24(s0)
    80004bd4:	d58ff0ef          	jal	8000412c <fileread>
}
    80004bd8:	70a2                	ld	ra,40(sp)
    80004bda:	7402                	ld	s0,32(sp)
    80004bdc:	6145                	addi	sp,sp,48
    80004bde:	8082                	ret

0000000080004be0 <sys_write>:
{
    80004be0:	7179                	addi	sp,sp,-48
    80004be2:	f406                	sd	ra,40(sp)
    80004be4:	f022                	sd	s0,32(sp)
    80004be6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004be8:	fd840593          	addi	a1,s0,-40
    80004bec:	4505                	li	a0,1
    80004bee:	d75fd0ef          	jal	80002962 <argaddr>
  argint(2, &n);
    80004bf2:	fe440593          	addi	a1,s0,-28
    80004bf6:	4509                	li	a0,2
    80004bf8:	d4ffd0ef          	jal	80002946 <argint>
  if(argfd(0, 0, &f) < 0)
    80004bfc:	fe840613          	addi	a2,s0,-24
    80004c00:	4581                	li	a1,0
    80004c02:	4501                	li	a0,0
    80004c04:	d79ff0ef          	jal	8000497c <argfd>
    80004c08:	87aa                	mv	a5,a0
    return -1;
    80004c0a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c0c:	0007ca63          	bltz	a5,80004c20 <sys_write+0x40>
  return filewrite(f, p, n);
    80004c10:	fe442603          	lw	a2,-28(s0)
    80004c14:	fd843583          	ld	a1,-40(s0)
    80004c18:	fe843503          	ld	a0,-24(s0)
    80004c1c:	dceff0ef          	jal	800041ea <filewrite>
}
    80004c20:	70a2                	ld	ra,40(sp)
    80004c22:	7402                	ld	s0,32(sp)
    80004c24:	6145                	addi	sp,sp,48
    80004c26:	8082                	ret

0000000080004c28 <sys_close>:
{
    80004c28:	1101                	addi	sp,sp,-32
    80004c2a:	ec06                	sd	ra,24(sp)
    80004c2c:	e822                	sd	s0,16(sp)
    80004c2e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004c30:	fe040613          	addi	a2,s0,-32
    80004c34:	fec40593          	addi	a1,s0,-20
    80004c38:	4501                	li	a0,0
    80004c3a:	d43ff0ef          	jal	8000497c <argfd>
    return -1;
    80004c3e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004c40:	02054063          	bltz	a0,80004c60 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004c44:	c81fc0ef          	jal	800018c4 <myproc>
    80004c48:	fec42783          	lw	a5,-20(s0)
    80004c4c:	07e9                	addi	a5,a5,26
    80004c4e:	078e                	slli	a5,a5,0x3
    80004c50:	953e                	add	a0,a0,a5
    80004c52:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004c56:	fe043503          	ld	a0,-32(s0)
    80004c5a:	bb2ff0ef          	jal	8000400c <fileclose>
  return 0;
    80004c5e:	4781                	li	a5,0
}
    80004c60:	853e                	mv	a0,a5
    80004c62:	60e2                	ld	ra,24(sp)
    80004c64:	6442                	ld	s0,16(sp)
    80004c66:	6105                	addi	sp,sp,32
    80004c68:	8082                	ret

0000000080004c6a <sys_fstat>:
{
    80004c6a:	1101                	addi	sp,sp,-32
    80004c6c:	ec06                	sd	ra,24(sp)
    80004c6e:	e822                	sd	s0,16(sp)
    80004c70:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004c72:	fe040593          	addi	a1,s0,-32
    80004c76:	4505                	li	a0,1
    80004c78:	cebfd0ef          	jal	80002962 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004c7c:	fe840613          	addi	a2,s0,-24
    80004c80:	4581                	li	a1,0
    80004c82:	4501                	li	a0,0
    80004c84:	cf9ff0ef          	jal	8000497c <argfd>
    80004c88:	87aa                	mv	a5,a0
    return -1;
    80004c8a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c8c:	0007c863          	bltz	a5,80004c9c <sys_fstat+0x32>
  return filestat(f, st);
    80004c90:	fe043583          	ld	a1,-32(s0)
    80004c94:	fe843503          	ld	a0,-24(s0)
    80004c98:	c36ff0ef          	jal	800040ce <filestat>
}
    80004c9c:	60e2                	ld	ra,24(sp)
    80004c9e:	6442                	ld	s0,16(sp)
    80004ca0:	6105                	addi	sp,sp,32
    80004ca2:	8082                	ret

0000000080004ca4 <sys_link>:
{
    80004ca4:	7169                	addi	sp,sp,-304
    80004ca6:	f606                	sd	ra,296(sp)
    80004ca8:	f222                	sd	s0,288(sp)
    80004caa:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cac:	08000613          	li	a2,128
    80004cb0:	ed040593          	addi	a1,s0,-304
    80004cb4:	4501                	li	a0,0
    80004cb6:	cc9fd0ef          	jal	8000297e <argstr>
    return -1;
    80004cba:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cbc:	0c054e63          	bltz	a0,80004d98 <sys_link+0xf4>
    80004cc0:	08000613          	li	a2,128
    80004cc4:	f5040593          	addi	a1,s0,-176
    80004cc8:	4505                	li	a0,1
    80004cca:	cb5fd0ef          	jal	8000297e <argstr>
    return -1;
    80004cce:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cd0:	0c054463          	bltz	a0,80004d98 <sys_link+0xf4>
    80004cd4:	ee26                	sd	s1,280(sp)
  begin_op();
    80004cd6:	f1dfe0ef          	jal	80003bf2 <begin_op>
  if((ip = namei(old)) == 0){
    80004cda:	ed040513          	addi	a0,s0,-304
    80004cde:	d59fe0ef          	jal	80003a36 <namei>
    80004ce2:	84aa                	mv	s1,a0
    80004ce4:	c53d                	beqz	a0,80004d52 <sys_link+0xae>
  ilock(ip);
    80004ce6:	e76fe0ef          	jal	8000335c <ilock>
  if(ip->type == T_DIR){
    80004cea:	04449703          	lh	a4,68(s1)
    80004cee:	4785                	li	a5,1
    80004cf0:	06f70663          	beq	a4,a5,80004d5c <sys_link+0xb8>
    80004cf4:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004cf6:	04a4d783          	lhu	a5,74(s1)
    80004cfa:	2785                	addiw	a5,a5,1
    80004cfc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004d00:	8526                	mv	a0,s1
    80004d02:	da6fe0ef          	jal	800032a8 <iupdate>
  iunlock(ip);
    80004d06:	8526                	mv	a0,s1
    80004d08:	f02fe0ef          	jal	8000340a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004d0c:	fd040593          	addi	a1,s0,-48
    80004d10:	f5040513          	addi	a0,s0,-176
    80004d14:	d3dfe0ef          	jal	80003a50 <nameiparent>
    80004d18:	892a                	mv	s2,a0
    80004d1a:	cd21                	beqz	a0,80004d72 <sys_link+0xce>
  ilock(dp);
    80004d1c:	e40fe0ef          	jal	8000335c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004d20:	00092703          	lw	a4,0(s2)
    80004d24:	409c                	lw	a5,0(s1)
    80004d26:	04f71363          	bne	a4,a5,80004d6c <sys_link+0xc8>
    80004d2a:	40d0                	lw	a2,4(s1)
    80004d2c:	fd040593          	addi	a1,s0,-48
    80004d30:	854a                	mv	a0,s2
    80004d32:	c6bfe0ef          	jal	8000399c <dirlink>
    80004d36:	02054b63          	bltz	a0,80004d6c <sys_link+0xc8>
  iunlockput(dp);
    80004d3a:	854a                	mv	a0,s2
    80004d3c:	82bfe0ef          	jal	80003566 <iunlockput>
  iput(ip);
    80004d40:	8526                	mv	a0,s1
    80004d42:	f9cfe0ef          	jal	800034de <iput>
  end_op();
    80004d46:	f17fe0ef          	jal	80003c5c <end_op>
  return 0;
    80004d4a:	4781                	li	a5,0
    80004d4c:	64f2                	ld	s1,280(sp)
    80004d4e:	6952                	ld	s2,272(sp)
    80004d50:	a0a1                	j	80004d98 <sys_link+0xf4>
    end_op();
    80004d52:	f0bfe0ef          	jal	80003c5c <end_op>
    return -1;
    80004d56:	57fd                	li	a5,-1
    80004d58:	64f2                	ld	s1,280(sp)
    80004d5a:	a83d                	j	80004d98 <sys_link+0xf4>
    iunlockput(ip);
    80004d5c:	8526                	mv	a0,s1
    80004d5e:	809fe0ef          	jal	80003566 <iunlockput>
    end_op();
    80004d62:	efbfe0ef          	jal	80003c5c <end_op>
    return -1;
    80004d66:	57fd                	li	a5,-1
    80004d68:	64f2                	ld	s1,280(sp)
    80004d6a:	a03d                	j	80004d98 <sys_link+0xf4>
    iunlockput(dp);
    80004d6c:	854a                	mv	a0,s2
    80004d6e:	ff8fe0ef          	jal	80003566 <iunlockput>
  ilock(ip);
    80004d72:	8526                	mv	a0,s1
    80004d74:	de8fe0ef          	jal	8000335c <ilock>
  ip->nlink--;
    80004d78:	04a4d783          	lhu	a5,74(s1)
    80004d7c:	37fd                	addiw	a5,a5,-1
    80004d7e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004d82:	8526                	mv	a0,s1
    80004d84:	d24fe0ef          	jal	800032a8 <iupdate>
  iunlockput(ip);
    80004d88:	8526                	mv	a0,s1
    80004d8a:	fdcfe0ef          	jal	80003566 <iunlockput>
  end_op();
    80004d8e:	ecffe0ef          	jal	80003c5c <end_op>
  return -1;
    80004d92:	57fd                	li	a5,-1
    80004d94:	64f2                	ld	s1,280(sp)
    80004d96:	6952                	ld	s2,272(sp)
}
    80004d98:	853e                	mv	a0,a5
    80004d9a:	70b2                	ld	ra,296(sp)
    80004d9c:	7412                	ld	s0,288(sp)
    80004d9e:	6155                	addi	sp,sp,304
    80004da0:	8082                	ret

0000000080004da2 <sys_unlink>:
{
    80004da2:	7151                	addi	sp,sp,-240
    80004da4:	f586                	sd	ra,232(sp)
    80004da6:	f1a2                	sd	s0,224(sp)
    80004da8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004daa:	08000613          	li	a2,128
    80004dae:	f3040593          	addi	a1,s0,-208
    80004db2:	4501                	li	a0,0
    80004db4:	bcbfd0ef          	jal	8000297e <argstr>
    80004db8:	16054063          	bltz	a0,80004f18 <sys_unlink+0x176>
    80004dbc:	eda6                	sd	s1,216(sp)
  begin_op();
    80004dbe:	e35fe0ef          	jal	80003bf2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004dc2:	fb040593          	addi	a1,s0,-80
    80004dc6:	f3040513          	addi	a0,s0,-208
    80004dca:	c87fe0ef          	jal	80003a50 <nameiparent>
    80004dce:	84aa                	mv	s1,a0
    80004dd0:	c945                	beqz	a0,80004e80 <sys_unlink+0xde>
  ilock(dp);
    80004dd2:	d8afe0ef          	jal	8000335c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004dd6:	00003597          	auipc	a1,0x3
    80004dda:	87a58593          	addi	a1,a1,-1926 # 80007650 <etext+0x650>
    80004dde:	fb040513          	addi	a0,s0,-80
    80004de2:	9d9fe0ef          	jal	800037ba <namecmp>
    80004de6:	10050e63          	beqz	a0,80004f02 <sys_unlink+0x160>
    80004dea:	00003597          	auipc	a1,0x3
    80004dee:	86e58593          	addi	a1,a1,-1938 # 80007658 <etext+0x658>
    80004df2:	fb040513          	addi	a0,s0,-80
    80004df6:	9c5fe0ef          	jal	800037ba <namecmp>
    80004dfa:	10050463          	beqz	a0,80004f02 <sys_unlink+0x160>
    80004dfe:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004e00:	f2c40613          	addi	a2,s0,-212
    80004e04:	fb040593          	addi	a1,s0,-80
    80004e08:	8526                	mv	a0,s1
    80004e0a:	9c7fe0ef          	jal	800037d0 <dirlookup>
    80004e0e:	892a                	mv	s2,a0
    80004e10:	0e050863          	beqz	a0,80004f00 <sys_unlink+0x15e>
  ilock(ip);
    80004e14:	d48fe0ef          	jal	8000335c <ilock>
  if(ip->nlink < 1)
    80004e18:	04a91783          	lh	a5,74(s2)
    80004e1c:	06f05763          	blez	a5,80004e8a <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004e20:	04491703          	lh	a4,68(s2)
    80004e24:	4785                	li	a5,1
    80004e26:	06f70963          	beq	a4,a5,80004e98 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004e2a:	4641                	li	a2,16
    80004e2c:	4581                	li	a1,0
    80004e2e:	fc040513          	addi	a0,s0,-64
    80004e32:	e99fb0ef          	jal	80000cca <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e36:	4741                	li	a4,16
    80004e38:	f2c42683          	lw	a3,-212(s0)
    80004e3c:	fc040613          	addi	a2,s0,-64
    80004e40:	4581                	li	a1,0
    80004e42:	8526                	mv	a0,s1
    80004e44:	869fe0ef          	jal	800036ac <writei>
    80004e48:	47c1                	li	a5,16
    80004e4a:	08f51b63          	bne	a0,a5,80004ee0 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004e4e:	04491703          	lh	a4,68(s2)
    80004e52:	4785                	li	a5,1
    80004e54:	08f70d63          	beq	a4,a5,80004eee <sys_unlink+0x14c>
  iunlockput(dp);
    80004e58:	8526                	mv	a0,s1
    80004e5a:	f0cfe0ef          	jal	80003566 <iunlockput>
  ip->nlink--;
    80004e5e:	04a95783          	lhu	a5,74(s2)
    80004e62:	37fd                	addiw	a5,a5,-1
    80004e64:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004e68:	854a                	mv	a0,s2
    80004e6a:	c3efe0ef          	jal	800032a8 <iupdate>
  iunlockput(ip);
    80004e6e:	854a                	mv	a0,s2
    80004e70:	ef6fe0ef          	jal	80003566 <iunlockput>
  end_op();
    80004e74:	de9fe0ef          	jal	80003c5c <end_op>
  return 0;
    80004e78:	4501                	li	a0,0
    80004e7a:	64ee                	ld	s1,216(sp)
    80004e7c:	694e                	ld	s2,208(sp)
    80004e7e:	a849                	j	80004f10 <sys_unlink+0x16e>
    end_op();
    80004e80:	dddfe0ef          	jal	80003c5c <end_op>
    return -1;
    80004e84:	557d                	li	a0,-1
    80004e86:	64ee                	ld	s1,216(sp)
    80004e88:	a061                	j	80004f10 <sys_unlink+0x16e>
    80004e8a:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004e8c:	00002517          	auipc	a0,0x2
    80004e90:	7d450513          	addi	a0,a0,2004 # 80007660 <etext+0x660>
    80004e94:	901fb0ef          	jal	80000794 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e98:	04c92703          	lw	a4,76(s2)
    80004e9c:	02000793          	li	a5,32
    80004ea0:	f8e7f5e3          	bgeu	a5,a4,80004e2a <sys_unlink+0x88>
    80004ea4:	e5ce                	sd	s3,200(sp)
    80004ea6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004eaa:	4741                	li	a4,16
    80004eac:	86ce                	mv	a3,s3
    80004eae:	f1840613          	addi	a2,s0,-232
    80004eb2:	4581                	li	a1,0
    80004eb4:	854a                	mv	a0,s2
    80004eb6:	efafe0ef          	jal	800035b0 <readi>
    80004eba:	47c1                	li	a5,16
    80004ebc:	00f51c63          	bne	a0,a5,80004ed4 <sys_unlink+0x132>
    if(de.inum != 0)
    80004ec0:	f1845783          	lhu	a5,-232(s0)
    80004ec4:	efa1                	bnez	a5,80004f1c <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ec6:	29c1                	addiw	s3,s3,16
    80004ec8:	04c92783          	lw	a5,76(s2)
    80004ecc:	fcf9efe3          	bltu	s3,a5,80004eaa <sys_unlink+0x108>
    80004ed0:	69ae                	ld	s3,200(sp)
    80004ed2:	bfa1                	j	80004e2a <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004ed4:	00002517          	auipc	a0,0x2
    80004ed8:	7a450513          	addi	a0,a0,1956 # 80007678 <etext+0x678>
    80004edc:	8b9fb0ef          	jal	80000794 <panic>
    80004ee0:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004ee2:	00002517          	auipc	a0,0x2
    80004ee6:	7ae50513          	addi	a0,a0,1966 # 80007690 <etext+0x690>
    80004eea:	8abfb0ef          	jal	80000794 <panic>
    dp->nlink--;
    80004eee:	04a4d783          	lhu	a5,74(s1)
    80004ef2:	37fd                	addiw	a5,a5,-1
    80004ef4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ef8:	8526                	mv	a0,s1
    80004efa:	baefe0ef          	jal	800032a8 <iupdate>
    80004efe:	bfa9                	j	80004e58 <sys_unlink+0xb6>
    80004f00:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004f02:	8526                	mv	a0,s1
    80004f04:	e62fe0ef          	jal	80003566 <iunlockput>
  end_op();
    80004f08:	d55fe0ef          	jal	80003c5c <end_op>
  return -1;
    80004f0c:	557d                	li	a0,-1
    80004f0e:	64ee                	ld	s1,216(sp)
}
    80004f10:	70ae                	ld	ra,232(sp)
    80004f12:	740e                	ld	s0,224(sp)
    80004f14:	616d                	addi	sp,sp,240
    80004f16:	8082                	ret
    return -1;
    80004f18:	557d                	li	a0,-1
    80004f1a:	bfdd                	j	80004f10 <sys_unlink+0x16e>
    iunlockput(ip);
    80004f1c:	854a                	mv	a0,s2
    80004f1e:	e48fe0ef          	jal	80003566 <iunlockput>
    goto bad;
    80004f22:	694e                	ld	s2,208(sp)
    80004f24:	69ae                	ld	s3,200(sp)
    80004f26:	bff1                	j	80004f02 <sys_unlink+0x160>

0000000080004f28 <sys_open>:

uint64
sys_open(void)
{
    80004f28:	7131                	addi	sp,sp,-192
    80004f2a:	fd06                	sd	ra,184(sp)
    80004f2c:	f922                	sd	s0,176(sp)
    80004f2e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004f30:	f4c40593          	addi	a1,s0,-180
    80004f34:	4505                	li	a0,1
    80004f36:	a11fd0ef          	jal	80002946 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004f3a:	08000613          	li	a2,128
    80004f3e:	f5040593          	addi	a1,s0,-176
    80004f42:	4501                	li	a0,0
    80004f44:	a3bfd0ef          	jal	8000297e <argstr>
    80004f48:	87aa                	mv	a5,a0
    return -1;
    80004f4a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004f4c:	0a07c263          	bltz	a5,80004ff0 <sys_open+0xc8>
    80004f50:	f526                	sd	s1,168(sp)

  begin_op();
    80004f52:	ca1fe0ef          	jal	80003bf2 <begin_op>

  if(omode & O_CREATE){
    80004f56:	f4c42783          	lw	a5,-180(s0)
    80004f5a:	2007f793          	andi	a5,a5,512
    80004f5e:	c3d5                	beqz	a5,80005002 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004f60:	4681                	li	a3,0
    80004f62:	4601                	li	a2,0
    80004f64:	4589                	li	a1,2
    80004f66:	f5040513          	addi	a0,s0,-176
    80004f6a:	aa9ff0ef          	jal	80004a12 <create>
    80004f6e:	84aa                	mv	s1,a0
    if(ip == 0){
    80004f70:	c541                	beqz	a0,80004ff8 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004f72:	04449703          	lh	a4,68(s1)
    80004f76:	478d                	li	a5,3
    80004f78:	00f71763          	bne	a4,a5,80004f86 <sys_open+0x5e>
    80004f7c:	0464d703          	lhu	a4,70(s1)
    80004f80:	47a5                	li	a5,9
    80004f82:	0ae7ed63          	bltu	a5,a4,8000503c <sys_open+0x114>
    80004f86:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004f88:	fe1fe0ef          	jal	80003f68 <filealloc>
    80004f8c:	892a                	mv	s2,a0
    80004f8e:	c179                	beqz	a0,80005054 <sys_open+0x12c>
    80004f90:	ed4e                	sd	s3,152(sp)
    80004f92:	a43ff0ef          	jal	800049d4 <fdalloc>
    80004f96:	89aa                	mv	s3,a0
    80004f98:	0a054a63          	bltz	a0,8000504c <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004f9c:	04449703          	lh	a4,68(s1)
    80004fa0:	478d                	li	a5,3
    80004fa2:	0cf70263          	beq	a4,a5,80005066 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004fa6:	4789                	li	a5,2
    80004fa8:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004fac:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004fb0:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004fb4:	f4c42783          	lw	a5,-180(s0)
    80004fb8:	0017c713          	xori	a4,a5,1
    80004fbc:	8b05                	andi	a4,a4,1
    80004fbe:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004fc2:	0037f713          	andi	a4,a5,3
    80004fc6:	00e03733          	snez	a4,a4
    80004fca:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004fce:	4007f793          	andi	a5,a5,1024
    80004fd2:	c791                	beqz	a5,80004fde <sys_open+0xb6>
    80004fd4:	04449703          	lh	a4,68(s1)
    80004fd8:	4789                	li	a5,2
    80004fda:	08f70d63          	beq	a4,a5,80005074 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004fde:	8526                	mv	a0,s1
    80004fe0:	c2afe0ef          	jal	8000340a <iunlock>
  end_op();
    80004fe4:	c79fe0ef          	jal	80003c5c <end_op>

  return fd;
    80004fe8:	854e                	mv	a0,s3
    80004fea:	74aa                	ld	s1,168(sp)
    80004fec:	790a                	ld	s2,160(sp)
    80004fee:	69ea                	ld	s3,152(sp)
}
    80004ff0:	70ea                	ld	ra,184(sp)
    80004ff2:	744a                	ld	s0,176(sp)
    80004ff4:	6129                	addi	sp,sp,192
    80004ff6:	8082                	ret
      end_op();
    80004ff8:	c65fe0ef          	jal	80003c5c <end_op>
      return -1;
    80004ffc:	557d                	li	a0,-1
    80004ffe:	74aa                	ld	s1,168(sp)
    80005000:	bfc5                	j	80004ff0 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80005002:	f5040513          	addi	a0,s0,-176
    80005006:	a31fe0ef          	jal	80003a36 <namei>
    8000500a:	84aa                	mv	s1,a0
    8000500c:	c11d                	beqz	a0,80005032 <sys_open+0x10a>
    ilock(ip);
    8000500e:	b4efe0ef          	jal	8000335c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005012:	04449703          	lh	a4,68(s1)
    80005016:	4785                	li	a5,1
    80005018:	f4f71de3          	bne	a4,a5,80004f72 <sys_open+0x4a>
    8000501c:	f4c42783          	lw	a5,-180(s0)
    80005020:	d3bd                	beqz	a5,80004f86 <sys_open+0x5e>
      iunlockput(ip);
    80005022:	8526                	mv	a0,s1
    80005024:	d42fe0ef          	jal	80003566 <iunlockput>
      end_op();
    80005028:	c35fe0ef          	jal	80003c5c <end_op>
      return -1;
    8000502c:	557d                	li	a0,-1
    8000502e:	74aa                	ld	s1,168(sp)
    80005030:	b7c1                	j	80004ff0 <sys_open+0xc8>
      end_op();
    80005032:	c2bfe0ef          	jal	80003c5c <end_op>
      return -1;
    80005036:	557d                	li	a0,-1
    80005038:	74aa                	ld	s1,168(sp)
    8000503a:	bf5d                	j	80004ff0 <sys_open+0xc8>
    iunlockput(ip);
    8000503c:	8526                	mv	a0,s1
    8000503e:	d28fe0ef          	jal	80003566 <iunlockput>
    end_op();
    80005042:	c1bfe0ef          	jal	80003c5c <end_op>
    return -1;
    80005046:	557d                	li	a0,-1
    80005048:	74aa                	ld	s1,168(sp)
    8000504a:	b75d                	j	80004ff0 <sys_open+0xc8>
      fileclose(f);
    8000504c:	854a                	mv	a0,s2
    8000504e:	fbffe0ef          	jal	8000400c <fileclose>
    80005052:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005054:	8526                	mv	a0,s1
    80005056:	d10fe0ef          	jal	80003566 <iunlockput>
    end_op();
    8000505a:	c03fe0ef          	jal	80003c5c <end_op>
    return -1;
    8000505e:	557d                	li	a0,-1
    80005060:	74aa                	ld	s1,168(sp)
    80005062:	790a                	ld	s2,160(sp)
    80005064:	b771                	j	80004ff0 <sys_open+0xc8>
    f->type = FD_DEVICE;
    80005066:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000506a:	04649783          	lh	a5,70(s1)
    8000506e:	02f91223          	sh	a5,36(s2)
    80005072:	bf3d                	j	80004fb0 <sys_open+0x88>
    itrunc(ip);
    80005074:	8526                	mv	a0,s1
    80005076:	bd4fe0ef          	jal	8000344a <itrunc>
    8000507a:	b795                	j	80004fde <sys_open+0xb6>

000000008000507c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000507c:	7175                	addi	sp,sp,-144
    8000507e:	e506                	sd	ra,136(sp)
    80005080:	e122                	sd	s0,128(sp)
    80005082:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005084:	b6ffe0ef          	jal	80003bf2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005088:	08000613          	li	a2,128
    8000508c:	f7040593          	addi	a1,s0,-144
    80005090:	4501                	li	a0,0
    80005092:	8edfd0ef          	jal	8000297e <argstr>
    80005096:	02054363          	bltz	a0,800050bc <sys_mkdir+0x40>
    8000509a:	4681                	li	a3,0
    8000509c:	4601                	li	a2,0
    8000509e:	4585                	li	a1,1
    800050a0:	f7040513          	addi	a0,s0,-144
    800050a4:	96fff0ef          	jal	80004a12 <create>
    800050a8:	c911                	beqz	a0,800050bc <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050aa:	cbcfe0ef          	jal	80003566 <iunlockput>
  end_op();
    800050ae:	baffe0ef          	jal	80003c5c <end_op>
  return 0;
    800050b2:	4501                	li	a0,0
}
    800050b4:	60aa                	ld	ra,136(sp)
    800050b6:	640a                	ld	s0,128(sp)
    800050b8:	6149                	addi	sp,sp,144
    800050ba:	8082                	ret
    end_op();
    800050bc:	ba1fe0ef          	jal	80003c5c <end_op>
    return -1;
    800050c0:	557d                	li	a0,-1
    800050c2:	bfcd                	j	800050b4 <sys_mkdir+0x38>

00000000800050c4 <sys_mknod>:

uint64
sys_mknod(void)
{
    800050c4:	7135                	addi	sp,sp,-160
    800050c6:	ed06                	sd	ra,152(sp)
    800050c8:	e922                	sd	s0,144(sp)
    800050ca:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800050cc:	b27fe0ef          	jal	80003bf2 <begin_op>
  argint(1, &major);
    800050d0:	f6c40593          	addi	a1,s0,-148
    800050d4:	4505                	li	a0,1
    800050d6:	871fd0ef          	jal	80002946 <argint>
  argint(2, &minor);
    800050da:	f6840593          	addi	a1,s0,-152
    800050de:	4509                	li	a0,2
    800050e0:	867fd0ef          	jal	80002946 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050e4:	08000613          	li	a2,128
    800050e8:	f7040593          	addi	a1,s0,-144
    800050ec:	4501                	li	a0,0
    800050ee:	891fd0ef          	jal	8000297e <argstr>
    800050f2:	02054563          	bltz	a0,8000511c <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800050f6:	f6841683          	lh	a3,-152(s0)
    800050fa:	f6c41603          	lh	a2,-148(s0)
    800050fe:	458d                	li	a1,3
    80005100:	f7040513          	addi	a0,s0,-144
    80005104:	90fff0ef          	jal	80004a12 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005108:	c911                	beqz	a0,8000511c <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000510a:	c5cfe0ef          	jal	80003566 <iunlockput>
  end_op();
    8000510e:	b4ffe0ef          	jal	80003c5c <end_op>
  return 0;
    80005112:	4501                	li	a0,0
}
    80005114:	60ea                	ld	ra,152(sp)
    80005116:	644a                	ld	s0,144(sp)
    80005118:	610d                	addi	sp,sp,160
    8000511a:	8082                	ret
    end_op();
    8000511c:	b41fe0ef          	jal	80003c5c <end_op>
    return -1;
    80005120:	557d                	li	a0,-1
    80005122:	bfcd                	j	80005114 <sys_mknod+0x50>

0000000080005124 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005124:	7135                	addi	sp,sp,-160
    80005126:	ed06                	sd	ra,152(sp)
    80005128:	e922                	sd	s0,144(sp)
    8000512a:	e14a                	sd	s2,128(sp)
    8000512c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000512e:	f96fc0ef          	jal	800018c4 <myproc>
    80005132:	892a                	mv	s2,a0
  
  begin_op();
    80005134:	abffe0ef          	jal	80003bf2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005138:	08000613          	li	a2,128
    8000513c:	f6040593          	addi	a1,s0,-160
    80005140:	4501                	li	a0,0
    80005142:	83dfd0ef          	jal	8000297e <argstr>
    80005146:	04054363          	bltz	a0,8000518c <sys_chdir+0x68>
    8000514a:	e526                	sd	s1,136(sp)
    8000514c:	f6040513          	addi	a0,s0,-160
    80005150:	8e7fe0ef          	jal	80003a36 <namei>
    80005154:	84aa                	mv	s1,a0
    80005156:	c915                	beqz	a0,8000518a <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005158:	a04fe0ef          	jal	8000335c <ilock>
  if(ip->type != T_DIR){
    8000515c:	04449703          	lh	a4,68(s1)
    80005160:	4785                	li	a5,1
    80005162:	02f71963          	bne	a4,a5,80005194 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005166:	8526                	mv	a0,s1
    80005168:	aa2fe0ef          	jal	8000340a <iunlock>
  iput(p->cwd);
    8000516c:	15893503          	ld	a0,344(s2)
    80005170:	b6efe0ef          	jal	800034de <iput>
  end_op();
    80005174:	ae9fe0ef          	jal	80003c5c <end_op>
  p->cwd = ip;
    80005178:	14993c23          	sd	s1,344(s2)
  return 0;
    8000517c:	4501                	li	a0,0
    8000517e:	64aa                	ld	s1,136(sp)
}
    80005180:	60ea                	ld	ra,152(sp)
    80005182:	644a                	ld	s0,144(sp)
    80005184:	690a                	ld	s2,128(sp)
    80005186:	610d                	addi	sp,sp,160
    80005188:	8082                	ret
    8000518a:	64aa                	ld	s1,136(sp)
    end_op();
    8000518c:	ad1fe0ef          	jal	80003c5c <end_op>
    return -1;
    80005190:	557d                	li	a0,-1
    80005192:	b7fd                	j	80005180 <sys_chdir+0x5c>
    iunlockput(ip);
    80005194:	8526                	mv	a0,s1
    80005196:	bd0fe0ef          	jal	80003566 <iunlockput>
    end_op();
    8000519a:	ac3fe0ef          	jal	80003c5c <end_op>
    return -1;
    8000519e:	557d                	li	a0,-1
    800051a0:	64aa                	ld	s1,136(sp)
    800051a2:	bff9                	j	80005180 <sys_chdir+0x5c>

00000000800051a4 <sys_exec>:

uint64
sys_exec(void)
{
    800051a4:	7121                	addi	sp,sp,-448
    800051a6:	ff06                	sd	ra,440(sp)
    800051a8:	fb22                	sd	s0,432(sp)
    800051aa:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800051ac:	e4840593          	addi	a1,s0,-440
    800051b0:	4505                	li	a0,1
    800051b2:	fb0fd0ef          	jal	80002962 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800051b6:	08000613          	li	a2,128
    800051ba:	f5040593          	addi	a1,s0,-176
    800051be:	4501                	li	a0,0
    800051c0:	fbefd0ef          	jal	8000297e <argstr>
    800051c4:	87aa                	mv	a5,a0
    return -1;
    800051c6:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800051c8:	0c07c463          	bltz	a5,80005290 <sys_exec+0xec>
    800051cc:	f726                	sd	s1,424(sp)
    800051ce:	f34a                	sd	s2,416(sp)
    800051d0:	ef4e                	sd	s3,408(sp)
    800051d2:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800051d4:	10000613          	li	a2,256
    800051d8:	4581                	li	a1,0
    800051da:	e5040513          	addi	a0,s0,-432
    800051de:	aedfb0ef          	jal	80000cca <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800051e2:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800051e6:	89a6                	mv	s3,s1
    800051e8:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800051ea:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800051ee:	00391513          	slli	a0,s2,0x3
    800051f2:	e4040593          	addi	a1,s0,-448
    800051f6:	e4843783          	ld	a5,-440(s0)
    800051fa:	953e                	add	a0,a0,a5
    800051fc:	ec0fd0ef          	jal	800028bc <fetchaddr>
    80005200:	02054663          	bltz	a0,8000522c <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80005204:	e4043783          	ld	a5,-448(s0)
    80005208:	c3a9                	beqz	a5,8000524a <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000520a:	91dfb0ef          	jal	80000b26 <kalloc>
    8000520e:	85aa                	mv	a1,a0
    80005210:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005214:	cd01                	beqz	a0,8000522c <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005216:	6605                	lui	a2,0x1
    80005218:	e4043503          	ld	a0,-448(s0)
    8000521c:	eeafd0ef          	jal	80002906 <fetchstr>
    80005220:	00054663          	bltz	a0,8000522c <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80005224:	0905                	addi	s2,s2,1
    80005226:	09a1                	addi	s3,s3,8
    80005228:	fd4913e3          	bne	s2,s4,800051ee <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000522c:	f5040913          	addi	s2,s0,-176
    80005230:	6088                	ld	a0,0(s1)
    80005232:	c931                	beqz	a0,80005286 <sys_exec+0xe2>
    kfree(argv[i]);
    80005234:	80ffb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005238:	04a1                	addi	s1,s1,8
    8000523a:	ff249be3          	bne	s1,s2,80005230 <sys_exec+0x8c>
  return -1;
    8000523e:	557d                	li	a0,-1
    80005240:	74ba                	ld	s1,424(sp)
    80005242:	791a                	ld	s2,416(sp)
    80005244:	69fa                	ld	s3,408(sp)
    80005246:	6a5a                	ld	s4,400(sp)
    80005248:	a0a1                	j	80005290 <sys_exec+0xec>
      argv[i] = 0;
    8000524a:	0009079b          	sext.w	a5,s2
    8000524e:	078e                	slli	a5,a5,0x3
    80005250:	fd078793          	addi	a5,a5,-48
    80005254:	97a2                	add	a5,a5,s0
    80005256:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000525a:	e5040593          	addi	a1,s0,-432
    8000525e:	f5040513          	addi	a0,s0,-176
    80005262:	ba8ff0ef          	jal	8000460a <exec>
    80005266:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005268:	f5040993          	addi	s3,s0,-176
    8000526c:	6088                	ld	a0,0(s1)
    8000526e:	c511                	beqz	a0,8000527a <sys_exec+0xd6>
    kfree(argv[i]);
    80005270:	fd2fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005274:	04a1                	addi	s1,s1,8
    80005276:	ff349be3          	bne	s1,s3,8000526c <sys_exec+0xc8>
  return ret;
    8000527a:	854a                	mv	a0,s2
    8000527c:	74ba                	ld	s1,424(sp)
    8000527e:	791a                	ld	s2,416(sp)
    80005280:	69fa                	ld	s3,408(sp)
    80005282:	6a5a                	ld	s4,400(sp)
    80005284:	a031                	j	80005290 <sys_exec+0xec>
  return -1;
    80005286:	557d                	li	a0,-1
    80005288:	74ba                	ld	s1,424(sp)
    8000528a:	791a                	ld	s2,416(sp)
    8000528c:	69fa                	ld	s3,408(sp)
    8000528e:	6a5a                	ld	s4,400(sp)
}
    80005290:	70fa                	ld	ra,440(sp)
    80005292:	745a                	ld	s0,432(sp)
    80005294:	6139                	addi	sp,sp,448
    80005296:	8082                	ret

0000000080005298 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005298:	7139                	addi	sp,sp,-64
    8000529a:	fc06                	sd	ra,56(sp)
    8000529c:	f822                	sd	s0,48(sp)
    8000529e:	f426                	sd	s1,40(sp)
    800052a0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800052a2:	e22fc0ef          	jal	800018c4 <myproc>
    800052a6:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800052a8:	fd840593          	addi	a1,s0,-40
    800052ac:	4501                	li	a0,0
    800052ae:	eb4fd0ef          	jal	80002962 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800052b2:	fc840593          	addi	a1,s0,-56
    800052b6:	fd040513          	addi	a0,s0,-48
    800052ba:	85cff0ef          	jal	80004316 <pipealloc>
    return -1;
    800052be:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800052c0:	0a054463          	bltz	a0,80005368 <sys_pipe+0xd0>
  fd0 = -1;
    800052c4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800052c8:	fd043503          	ld	a0,-48(s0)
    800052cc:	f08ff0ef          	jal	800049d4 <fdalloc>
    800052d0:	fca42223          	sw	a0,-60(s0)
    800052d4:	08054163          	bltz	a0,80005356 <sys_pipe+0xbe>
    800052d8:	fc843503          	ld	a0,-56(s0)
    800052dc:	ef8ff0ef          	jal	800049d4 <fdalloc>
    800052e0:	fca42023          	sw	a0,-64(s0)
    800052e4:	06054063          	bltz	a0,80005344 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052e8:	4691                	li	a3,4
    800052ea:	fc440613          	addi	a2,s0,-60
    800052ee:	fd843583          	ld	a1,-40(s0)
    800052f2:	68a8                	ld	a0,80(s1)
    800052f4:	a34fc0ef          	jal	80001528 <copyout>
    800052f8:	00054e63          	bltz	a0,80005314 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800052fc:	4691                	li	a3,4
    800052fe:	fc040613          	addi	a2,s0,-64
    80005302:	fd843583          	ld	a1,-40(s0)
    80005306:	0591                	addi	a1,a1,4
    80005308:	68a8                	ld	a0,80(s1)
    8000530a:	a1efc0ef          	jal	80001528 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000530e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005310:	04055c63          	bgez	a0,80005368 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005314:	fc442783          	lw	a5,-60(s0)
    80005318:	07e9                	addi	a5,a5,26
    8000531a:	078e                	slli	a5,a5,0x3
    8000531c:	97a6                	add	a5,a5,s1
    8000531e:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005322:	fc042783          	lw	a5,-64(s0)
    80005326:	07e9                	addi	a5,a5,26
    80005328:	078e                	slli	a5,a5,0x3
    8000532a:	94be                	add	s1,s1,a5
    8000532c:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005330:	fd043503          	ld	a0,-48(s0)
    80005334:	cd9fe0ef          	jal	8000400c <fileclose>
    fileclose(wf);
    80005338:	fc843503          	ld	a0,-56(s0)
    8000533c:	cd1fe0ef          	jal	8000400c <fileclose>
    return -1;
    80005340:	57fd                	li	a5,-1
    80005342:	a01d                	j	80005368 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005344:	fc442783          	lw	a5,-60(s0)
    80005348:	0007c763          	bltz	a5,80005356 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000534c:	07e9                	addi	a5,a5,26
    8000534e:	078e                	slli	a5,a5,0x3
    80005350:	97a6                	add	a5,a5,s1
    80005352:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005356:	fd043503          	ld	a0,-48(s0)
    8000535a:	cb3fe0ef          	jal	8000400c <fileclose>
    fileclose(wf);
    8000535e:	fc843503          	ld	a0,-56(s0)
    80005362:	cabfe0ef          	jal	8000400c <fileclose>
    return -1;
    80005366:	57fd                	li	a5,-1
}
    80005368:	853e                	mv	a0,a5
    8000536a:	70e2                	ld	ra,56(sp)
    8000536c:	7442                	ld	s0,48(sp)
    8000536e:	74a2                	ld	s1,40(sp)
    80005370:	6121                	addi	sp,sp,64
    80005372:	8082                	ret
	...

0000000080005380 <kernelvec>:
    80005380:	7111                	addi	sp,sp,-256
    80005382:	e006                	sd	ra,0(sp)
    80005384:	e40a                	sd	sp,8(sp)
    80005386:	e80e                	sd	gp,16(sp)
    80005388:	ec12                	sd	tp,24(sp)
    8000538a:	f016                	sd	t0,32(sp)
    8000538c:	f41a                	sd	t1,40(sp)
    8000538e:	f81e                	sd	t2,48(sp)
    80005390:	e4aa                	sd	a0,72(sp)
    80005392:	e8ae                	sd	a1,80(sp)
    80005394:	ecb2                	sd	a2,88(sp)
    80005396:	f0b6                	sd	a3,96(sp)
    80005398:	f4ba                	sd	a4,104(sp)
    8000539a:	f8be                	sd	a5,112(sp)
    8000539c:	fcc2                	sd	a6,120(sp)
    8000539e:	e146                	sd	a7,128(sp)
    800053a0:	edf2                	sd	t3,216(sp)
    800053a2:	f1f6                	sd	t4,224(sp)
    800053a4:	f5fa                	sd	t5,232(sp)
    800053a6:	f9fe                	sd	t6,240(sp)
    800053a8:	c24fd0ef          	jal	800027cc <kerneltrap>
    800053ac:	6082                	ld	ra,0(sp)
    800053ae:	6122                	ld	sp,8(sp)
    800053b0:	61c2                	ld	gp,16(sp)
    800053b2:	7282                	ld	t0,32(sp)
    800053b4:	7322                	ld	t1,40(sp)
    800053b6:	73c2                	ld	t2,48(sp)
    800053b8:	6526                	ld	a0,72(sp)
    800053ba:	65c6                	ld	a1,80(sp)
    800053bc:	6666                	ld	a2,88(sp)
    800053be:	7686                	ld	a3,96(sp)
    800053c0:	7726                	ld	a4,104(sp)
    800053c2:	77c6                	ld	a5,112(sp)
    800053c4:	7866                	ld	a6,120(sp)
    800053c6:	688a                	ld	a7,128(sp)
    800053c8:	6e6e                	ld	t3,216(sp)
    800053ca:	7e8e                	ld	t4,224(sp)
    800053cc:	7f2e                	ld	t5,232(sp)
    800053ce:	7fce                	ld	t6,240(sp)
    800053d0:	6111                	addi	sp,sp,256
    800053d2:	10200073          	sret
	...

00000000800053de <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800053de:	1141                	addi	sp,sp,-16
    800053e0:	e422                	sd	s0,8(sp)
    800053e2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800053e4:	0c0007b7          	lui	a5,0xc000
    800053e8:	4705                	li	a4,1
    800053ea:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800053ec:	0c0007b7          	lui	a5,0xc000
    800053f0:	c3d8                	sw	a4,4(a5)
}
    800053f2:	6422                	ld	s0,8(sp)
    800053f4:	0141                	addi	sp,sp,16
    800053f6:	8082                	ret

00000000800053f8 <plicinithart>:

void
plicinithart(void)
{
    800053f8:	1141                	addi	sp,sp,-16
    800053fa:	e406                	sd	ra,8(sp)
    800053fc:	e022                	sd	s0,0(sp)
    800053fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005400:	c98fc0ef          	jal	80001898 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005404:	0085171b          	slliw	a4,a0,0x8
    80005408:	0c0027b7          	lui	a5,0xc002
    8000540c:	97ba                	add	a5,a5,a4
    8000540e:	40200713          	li	a4,1026
    80005412:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005416:	00d5151b          	slliw	a0,a0,0xd
    8000541a:	0c2017b7          	lui	a5,0xc201
    8000541e:	97aa                	add	a5,a5,a0
    80005420:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005424:	60a2                	ld	ra,8(sp)
    80005426:	6402                	ld	s0,0(sp)
    80005428:	0141                	addi	sp,sp,16
    8000542a:	8082                	ret

000000008000542c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000542c:	1141                	addi	sp,sp,-16
    8000542e:	e406                	sd	ra,8(sp)
    80005430:	e022                	sd	s0,0(sp)
    80005432:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005434:	c64fc0ef          	jal	80001898 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005438:	00d5151b          	slliw	a0,a0,0xd
    8000543c:	0c2017b7          	lui	a5,0xc201
    80005440:	97aa                	add	a5,a5,a0
  return irq;
}
    80005442:	43c8                	lw	a0,4(a5)
    80005444:	60a2                	ld	ra,8(sp)
    80005446:	6402                	ld	s0,0(sp)
    80005448:	0141                	addi	sp,sp,16
    8000544a:	8082                	ret

000000008000544c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000544c:	1101                	addi	sp,sp,-32
    8000544e:	ec06                	sd	ra,24(sp)
    80005450:	e822                	sd	s0,16(sp)
    80005452:	e426                	sd	s1,8(sp)
    80005454:	1000                	addi	s0,sp,32
    80005456:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005458:	c40fc0ef          	jal	80001898 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000545c:	00d5151b          	slliw	a0,a0,0xd
    80005460:	0c2017b7          	lui	a5,0xc201
    80005464:	97aa                	add	a5,a5,a0
    80005466:	c3c4                	sw	s1,4(a5)
}
    80005468:	60e2                	ld	ra,24(sp)
    8000546a:	6442                	ld	s0,16(sp)
    8000546c:	64a2                	ld	s1,8(sp)
    8000546e:	6105                	addi	sp,sp,32
    80005470:	8082                	ret

0000000080005472 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005472:	1141                	addi	sp,sp,-16
    80005474:	e406                	sd	ra,8(sp)
    80005476:	e022                	sd	s0,0(sp)
    80005478:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000547a:	479d                	li	a5,7
    8000547c:	04a7ca63          	blt	a5,a0,800054d0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005480:	00016797          	auipc	a5,0x16
    80005484:	4b078793          	addi	a5,a5,1200 # 8001b930 <disk>
    80005488:	97aa                	add	a5,a5,a0
    8000548a:	0187c783          	lbu	a5,24(a5)
    8000548e:	e7b9                	bnez	a5,800054dc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005490:	00451693          	slli	a3,a0,0x4
    80005494:	00016797          	auipc	a5,0x16
    80005498:	49c78793          	addi	a5,a5,1180 # 8001b930 <disk>
    8000549c:	6398                	ld	a4,0(a5)
    8000549e:	9736                	add	a4,a4,a3
    800054a0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800054a4:	6398                	ld	a4,0(a5)
    800054a6:	9736                	add	a4,a4,a3
    800054a8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800054ac:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800054b0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800054b4:	97aa                	add	a5,a5,a0
    800054b6:	4705                	li	a4,1
    800054b8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800054bc:	00016517          	auipc	a0,0x16
    800054c0:	48c50513          	addi	a0,a0,1164 # 8001b948 <disk+0x18>
    800054c4:	ff2fc0ef          	jal	80001cb6 <wakeup>
}
    800054c8:	60a2                	ld	ra,8(sp)
    800054ca:	6402                	ld	s0,0(sp)
    800054cc:	0141                	addi	sp,sp,16
    800054ce:	8082                	ret
    panic("free_desc 1");
    800054d0:	00002517          	auipc	a0,0x2
    800054d4:	1d050513          	addi	a0,a0,464 # 800076a0 <etext+0x6a0>
    800054d8:	abcfb0ef          	jal	80000794 <panic>
    panic("free_desc 2");
    800054dc:	00002517          	auipc	a0,0x2
    800054e0:	1d450513          	addi	a0,a0,468 # 800076b0 <etext+0x6b0>
    800054e4:	ab0fb0ef          	jal	80000794 <panic>

00000000800054e8 <virtio_disk_init>:
{
    800054e8:	1101                	addi	sp,sp,-32
    800054ea:	ec06                	sd	ra,24(sp)
    800054ec:	e822                	sd	s0,16(sp)
    800054ee:	e426                	sd	s1,8(sp)
    800054f0:	e04a                	sd	s2,0(sp)
    800054f2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054f4:	00002597          	auipc	a1,0x2
    800054f8:	1cc58593          	addi	a1,a1,460 # 800076c0 <etext+0x6c0>
    800054fc:	00016517          	auipc	a0,0x16
    80005500:	55c50513          	addi	a0,a0,1372 # 8001ba58 <disk+0x128>
    80005504:	e72fb0ef          	jal	80000b76 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005508:	100017b7          	lui	a5,0x10001
    8000550c:	4398                	lw	a4,0(a5)
    8000550e:	2701                	sext.w	a4,a4
    80005510:	747277b7          	lui	a5,0x74727
    80005514:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005518:	18f71063          	bne	a4,a5,80005698 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000551c:	100017b7          	lui	a5,0x10001
    80005520:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005522:	439c                	lw	a5,0(a5)
    80005524:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005526:	4709                	li	a4,2
    80005528:	16e79863          	bne	a5,a4,80005698 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000552c:	100017b7          	lui	a5,0x10001
    80005530:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005532:	439c                	lw	a5,0(a5)
    80005534:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005536:	16e79163          	bne	a5,a4,80005698 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000553a:	100017b7          	lui	a5,0x10001
    8000553e:	47d8                	lw	a4,12(a5)
    80005540:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005542:	554d47b7          	lui	a5,0x554d4
    80005546:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000554a:	14f71763          	bne	a4,a5,80005698 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000554e:	100017b7          	lui	a5,0x10001
    80005552:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005556:	4705                	li	a4,1
    80005558:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000555a:	470d                	li	a4,3
    8000555c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000555e:	10001737          	lui	a4,0x10001
    80005562:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005564:	c7ffe737          	lui	a4,0xc7ffe
    80005568:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fe2cef>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000556c:	8ef9                	and	a3,a3,a4
    8000556e:	10001737          	lui	a4,0x10001
    80005572:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005574:	472d                	li	a4,11
    80005576:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005578:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000557c:	439c                	lw	a5,0(a5)
    8000557e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005582:	8ba1                	andi	a5,a5,8
    80005584:	12078063          	beqz	a5,800056a4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005588:	100017b7          	lui	a5,0x10001
    8000558c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005590:	100017b7          	lui	a5,0x10001
    80005594:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005598:	439c                	lw	a5,0(a5)
    8000559a:	2781                	sext.w	a5,a5
    8000559c:	10079a63          	bnez	a5,800056b0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800055a0:	100017b7          	lui	a5,0x10001
    800055a4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800055a8:	439c                	lw	a5,0(a5)
    800055aa:	2781                	sext.w	a5,a5
  if(max == 0)
    800055ac:	10078863          	beqz	a5,800056bc <virtio_disk_init+0x1d4>
  if(max < NUM)
    800055b0:	471d                	li	a4,7
    800055b2:	10f77b63          	bgeu	a4,a5,800056c8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    800055b6:	d70fb0ef          	jal	80000b26 <kalloc>
    800055ba:	00016497          	auipc	s1,0x16
    800055be:	37648493          	addi	s1,s1,886 # 8001b930 <disk>
    800055c2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800055c4:	d62fb0ef          	jal	80000b26 <kalloc>
    800055c8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800055ca:	d5cfb0ef          	jal	80000b26 <kalloc>
    800055ce:	87aa                	mv	a5,a0
    800055d0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800055d2:	6088                	ld	a0,0(s1)
    800055d4:	10050063          	beqz	a0,800056d4 <virtio_disk_init+0x1ec>
    800055d8:	00016717          	auipc	a4,0x16
    800055dc:	36073703          	ld	a4,864(a4) # 8001b938 <disk+0x8>
    800055e0:	0e070a63          	beqz	a4,800056d4 <virtio_disk_init+0x1ec>
    800055e4:	0e078863          	beqz	a5,800056d4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800055e8:	6605                	lui	a2,0x1
    800055ea:	4581                	li	a1,0
    800055ec:	edefb0ef          	jal	80000cca <memset>
  memset(disk.avail, 0, PGSIZE);
    800055f0:	00016497          	auipc	s1,0x16
    800055f4:	34048493          	addi	s1,s1,832 # 8001b930 <disk>
    800055f8:	6605                	lui	a2,0x1
    800055fa:	4581                	li	a1,0
    800055fc:	6488                	ld	a0,8(s1)
    800055fe:	eccfb0ef          	jal	80000cca <memset>
  memset(disk.used, 0, PGSIZE);
    80005602:	6605                	lui	a2,0x1
    80005604:	4581                	li	a1,0
    80005606:	6888                	ld	a0,16(s1)
    80005608:	ec2fb0ef          	jal	80000cca <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000560c:	100017b7          	lui	a5,0x10001
    80005610:	4721                	li	a4,8
    80005612:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005614:	4098                	lw	a4,0(s1)
    80005616:	100017b7          	lui	a5,0x10001
    8000561a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000561e:	40d8                	lw	a4,4(s1)
    80005620:	100017b7          	lui	a5,0x10001
    80005624:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005628:	649c                	ld	a5,8(s1)
    8000562a:	0007869b          	sext.w	a3,a5
    8000562e:	10001737          	lui	a4,0x10001
    80005632:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005636:	9781                	srai	a5,a5,0x20
    80005638:	10001737          	lui	a4,0x10001
    8000563c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005640:	689c                	ld	a5,16(s1)
    80005642:	0007869b          	sext.w	a3,a5
    80005646:	10001737          	lui	a4,0x10001
    8000564a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000564e:	9781                	srai	a5,a5,0x20
    80005650:	10001737          	lui	a4,0x10001
    80005654:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005658:	10001737          	lui	a4,0x10001
    8000565c:	4785                	li	a5,1
    8000565e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005660:	00f48c23          	sb	a5,24(s1)
    80005664:	00f48ca3          	sb	a5,25(s1)
    80005668:	00f48d23          	sb	a5,26(s1)
    8000566c:	00f48da3          	sb	a5,27(s1)
    80005670:	00f48e23          	sb	a5,28(s1)
    80005674:	00f48ea3          	sb	a5,29(s1)
    80005678:	00f48f23          	sb	a5,30(s1)
    8000567c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005680:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005684:	100017b7          	lui	a5,0x10001
    80005688:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000568c:	60e2                	ld	ra,24(sp)
    8000568e:	6442                	ld	s0,16(sp)
    80005690:	64a2                	ld	s1,8(sp)
    80005692:	6902                	ld	s2,0(sp)
    80005694:	6105                	addi	sp,sp,32
    80005696:	8082                	ret
    panic("could not find virtio disk");
    80005698:	00002517          	auipc	a0,0x2
    8000569c:	03850513          	addi	a0,a0,56 # 800076d0 <etext+0x6d0>
    800056a0:	8f4fb0ef          	jal	80000794 <panic>
    panic("virtio disk FEATURES_OK unset");
    800056a4:	00002517          	auipc	a0,0x2
    800056a8:	04c50513          	addi	a0,a0,76 # 800076f0 <etext+0x6f0>
    800056ac:	8e8fb0ef          	jal	80000794 <panic>
    panic("virtio disk should not be ready");
    800056b0:	00002517          	auipc	a0,0x2
    800056b4:	06050513          	addi	a0,a0,96 # 80007710 <etext+0x710>
    800056b8:	8dcfb0ef          	jal	80000794 <panic>
    panic("virtio disk has no queue 0");
    800056bc:	00002517          	auipc	a0,0x2
    800056c0:	07450513          	addi	a0,a0,116 # 80007730 <etext+0x730>
    800056c4:	8d0fb0ef          	jal	80000794 <panic>
    panic("virtio disk max queue too short");
    800056c8:	00002517          	auipc	a0,0x2
    800056cc:	08850513          	addi	a0,a0,136 # 80007750 <etext+0x750>
    800056d0:	8c4fb0ef          	jal	80000794 <panic>
    panic("virtio disk kalloc");
    800056d4:	00002517          	auipc	a0,0x2
    800056d8:	09c50513          	addi	a0,a0,156 # 80007770 <etext+0x770>
    800056dc:	8b8fb0ef          	jal	80000794 <panic>

00000000800056e0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800056e0:	7159                	addi	sp,sp,-112
    800056e2:	f486                	sd	ra,104(sp)
    800056e4:	f0a2                	sd	s0,96(sp)
    800056e6:	eca6                	sd	s1,88(sp)
    800056e8:	e8ca                	sd	s2,80(sp)
    800056ea:	e4ce                	sd	s3,72(sp)
    800056ec:	e0d2                	sd	s4,64(sp)
    800056ee:	fc56                	sd	s5,56(sp)
    800056f0:	f85a                	sd	s6,48(sp)
    800056f2:	f45e                	sd	s7,40(sp)
    800056f4:	f062                	sd	s8,32(sp)
    800056f6:	ec66                	sd	s9,24(sp)
    800056f8:	1880                	addi	s0,sp,112
    800056fa:	8a2a                	mv	s4,a0
    800056fc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800056fe:	00c52c83          	lw	s9,12(a0)
    80005702:	001c9c9b          	slliw	s9,s9,0x1
    80005706:	1c82                	slli	s9,s9,0x20
    80005708:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000570c:	00016517          	auipc	a0,0x16
    80005710:	34c50513          	addi	a0,a0,844 # 8001ba58 <disk+0x128>
    80005714:	ce2fb0ef          	jal	80000bf6 <acquire>
  for(int i = 0; i < 3; i++){
    80005718:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000571a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000571c:	00016b17          	auipc	s6,0x16
    80005720:	214b0b13          	addi	s6,s6,532 # 8001b930 <disk>
  for(int i = 0; i < 3; i++){
    80005724:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005726:	00016c17          	auipc	s8,0x16
    8000572a:	332c0c13          	addi	s8,s8,818 # 8001ba58 <disk+0x128>
    8000572e:	a8b9                	j	8000578c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005730:	00fb0733          	add	a4,s6,a5
    80005734:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005738:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000573a:	0207c563          	bltz	a5,80005764 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    8000573e:	2905                	addiw	s2,s2,1
    80005740:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005742:	05590963          	beq	s2,s5,80005794 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005746:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005748:	00016717          	auipc	a4,0x16
    8000574c:	1e870713          	addi	a4,a4,488 # 8001b930 <disk>
    80005750:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005752:	01874683          	lbu	a3,24(a4)
    80005756:	fee9                	bnez	a3,80005730 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005758:	2785                	addiw	a5,a5,1
    8000575a:	0705                	addi	a4,a4,1
    8000575c:	fe979be3          	bne	a5,s1,80005752 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005760:	57fd                	li	a5,-1
    80005762:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005764:	01205d63          	blez	s2,8000577e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005768:	f9042503          	lw	a0,-112(s0)
    8000576c:	d07ff0ef          	jal	80005472 <free_desc>
      for(int j = 0; j < i; j++)
    80005770:	4785                	li	a5,1
    80005772:	0127d663          	bge	a5,s2,8000577e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005776:	f9442503          	lw	a0,-108(s0)
    8000577a:	cf9ff0ef          	jal	80005472 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000577e:	85e2                	mv	a1,s8
    80005780:	00016517          	auipc	a0,0x16
    80005784:	1c850513          	addi	a0,a0,456 # 8001b948 <disk+0x18>
    80005788:	ce2fc0ef          	jal	80001c6a <sleep>
  for(int i = 0; i < 3; i++){
    8000578c:	f9040613          	addi	a2,s0,-112
    80005790:	894e                	mv	s2,s3
    80005792:	bf55                	j	80005746 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005794:	f9042503          	lw	a0,-112(s0)
    80005798:	00451693          	slli	a3,a0,0x4

  if(write)
    8000579c:	00016797          	auipc	a5,0x16
    800057a0:	19478793          	addi	a5,a5,404 # 8001b930 <disk>
    800057a4:	00a50713          	addi	a4,a0,10
    800057a8:	0712                	slli	a4,a4,0x4
    800057aa:	973e                	add	a4,a4,a5
    800057ac:	01703633          	snez	a2,s7
    800057b0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800057b2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800057b6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800057ba:	6398                	ld	a4,0(a5)
    800057bc:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057be:	0a868613          	addi	a2,a3,168
    800057c2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800057c4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800057c6:	6390                	ld	a2,0(a5)
    800057c8:	00d605b3          	add	a1,a2,a3
    800057cc:	4741                	li	a4,16
    800057ce:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800057d0:	4805                	li	a6,1
    800057d2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800057d6:	f9442703          	lw	a4,-108(s0)
    800057da:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800057de:	0712                	slli	a4,a4,0x4
    800057e0:	963a                	add	a2,a2,a4
    800057e2:	058a0593          	addi	a1,s4,88
    800057e6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800057e8:	0007b883          	ld	a7,0(a5)
    800057ec:	9746                	add	a4,a4,a7
    800057ee:	40000613          	li	a2,1024
    800057f2:	c710                	sw	a2,8(a4)
  if(write)
    800057f4:	001bb613          	seqz	a2,s7
    800057f8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800057fc:	00166613          	ori	a2,a2,1
    80005800:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005804:	f9842583          	lw	a1,-104(s0)
    80005808:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000580c:	00250613          	addi	a2,a0,2
    80005810:	0612                	slli	a2,a2,0x4
    80005812:	963e                	add	a2,a2,a5
    80005814:	577d                	li	a4,-1
    80005816:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000581a:	0592                	slli	a1,a1,0x4
    8000581c:	98ae                	add	a7,a7,a1
    8000581e:	03068713          	addi	a4,a3,48
    80005822:	973e                	add	a4,a4,a5
    80005824:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005828:	6398                	ld	a4,0(a5)
    8000582a:	972e                	add	a4,a4,a1
    8000582c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005830:	4689                	li	a3,2
    80005832:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005836:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000583a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    8000583e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005842:	6794                	ld	a3,8(a5)
    80005844:	0026d703          	lhu	a4,2(a3)
    80005848:	8b1d                	andi	a4,a4,7
    8000584a:	0706                	slli	a4,a4,0x1
    8000584c:	96ba                	add	a3,a3,a4
    8000584e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005852:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005856:	6798                	ld	a4,8(a5)
    80005858:	00275783          	lhu	a5,2(a4)
    8000585c:	2785                	addiw	a5,a5,1
    8000585e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005862:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005866:	100017b7          	lui	a5,0x10001
    8000586a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000586e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005872:	00016917          	auipc	s2,0x16
    80005876:	1e690913          	addi	s2,s2,486 # 8001ba58 <disk+0x128>
  while(b->disk == 1) {
    8000587a:	4485                	li	s1,1
    8000587c:	01079a63          	bne	a5,a6,80005890 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005880:	85ca                	mv	a1,s2
    80005882:	8552                	mv	a0,s4
    80005884:	be6fc0ef          	jal	80001c6a <sleep>
  while(b->disk == 1) {
    80005888:	004a2783          	lw	a5,4(s4)
    8000588c:	fe978ae3          	beq	a5,s1,80005880 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005890:	f9042903          	lw	s2,-112(s0)
    80005894:	00290713          	addi	a4,s2,2
    80005898:	0712                	slli	a4,a4,0x4
    8000589a:	00016797          	auipc	a5,0x16
    8000589e:	09678793          	addi	a5,a5,150 # 8001b930 <disk>
    800058a2:	97ba                	add	a5,a5,a4
    800058a4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800058a8:	00016997          	auipc	s3,0x16
    800058ac:	08898993          	addi	s3,s3,136 # 8001b930 <disk>
    800058b0:	00491713          	slli	a4,s2,0x4
    800058b4:	0009b783          	ld	a5,0(s3)
    800058b8:	97ba                	add	a5,a5,a4
    800058ba:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800058be:	854a                	mv	a0,s2
    800058c0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800058c4:	bafff0ef          	jal	80005472 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800058c8:	8885                	andi	s1,s1,1
    800058ca:	f0fd                	bnez	s1,800058b0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800058cc:	00016517          	auipc	a0,0x16
    800058d0:	18c50513          	addi	a0,a0,396 # 8001ba58 <disk+0x128>
    800058d4:	bbafb0ef          	jal	80000c8e <release>
}
    800058d8:	70a6                	ld	ra,104(sp)
    800058da:	7406                	ld	s0,96(sp)
    800058dc:	64e6                	ld	s1,88(sp)
    800058de:	6946                	ld	s2,80(sp)
    800058e0:	69a6                	ld	s3,72(sp)
    800058e2:	6a06                	ld	s4,64(sp)
    800058e4:	7ae2                	ld	s5,56(sp)
    800058e6:	7b42                	ld	s6,48(sp)
    800058e8:	7ba2                	ld	s7,40(sp)
    800058ea:	7c02                	ld	s8,32(sp)
    800058ec:	6ce2                	ld	s9,24(sp)
    800058ee:	6165                	addi	sp,sp,112
    800058f0:	8082                	ret

00000000800058f2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058f2:	1101                	addi	sp,sp,-32
    800058f4:	ec06                	sd	ra,24(sp)
    800058f6:	e822                	sd	s0,16(sp)
    800058f8:	e426                	sd	s1,8(sp)
    800058fa:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058fc:	00016497          	auipc	s1,0x16
    80005900:	03448493          	addi	s1,s1,52 # 8001b930 <disk>
    80005904:	00016517          	auipc	a0,0x16
    80005908:	15450513          	addi	a0,a0,340 # 8001ba58 <disk+0x128>
    8000590c:	aeafb0ef          	jal	80000bf6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005910:	100017b7          	lui	a5,0x10001
    80005914:	53b8                	lw	a4,96(a5)
    80005916:	8b0d                	andi	a4,a4,3
    80005918:	100017b7          	lui	a5,0x10001
    8000591c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    8000591e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005922:	689c                	ld	a5,16(s1)
    80005924:	0204d703          	lhu	a4,32(s1)
    80005928:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000592c:	04f70663          	beq	a4,a5,80005978 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005930:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005934:	6898                	ld	a4,16(s1)
    80005936:	0204d783          	lhu	a5,32(s1)
    8000593a:	8b9d                	andi	a5,a5,7
    8000593c:	078e                	slli	a5,a5,0x3
    8000593e:	97ba                	add	a5,a5,a4
    80005940:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005942:	00278713          	addi	a4,a5,2
    80005946:	0712                	slli	a4,a4,0x4
    80005948:	9726                	add	a4,a4,s1
    8000594a:	01074703          	lbu	a4,16(a4)
    8000594e:	e321                	bnez	a4,8000598e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005950:	0789                	addi	a5,a5,2
    80005952:	0792                	slli	a5,a5,0x4
    80005954:	97a6                	add	a5,a5,s1
    80005956:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005958:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000595c:	b5afc0ef          	jal	80001cb6 <wakeup>

    disk.used_idx += 1;
    80005960:	0204d783          	lhu	a5,32(s1)
    80005964:	2785                	addiw	a5,a5,1
    80005966:	17c2                	slli	a5,a5,0x30
    80005968:	93c1                	srli	a5,a5,0x30
    8000596a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000596e:	6898                	ld	a4,16(s1)
    80005970:	00275703          	lhu	a4,2(a4)
    80005974:	faf71ee3          	bne	a4,a5,80005930 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005978:	00016517          	auipc	a0,0x16
    8000597c:	0e050513          	addi	a0,a0,224 # 8001ba58 <disk+0x128>
    80005980:	b0efb0ef          	jal	80000c8e <release>
}
    80005984:	60e2                	ld	ra,24(sp)
    80005986:	6442                	ld	s0,16(sp)
    80005988:	64a2                	ld	s1,8(sp)
    8000598a:	6105                	addi	sp,sp,32
    8000598c:	8082                	ret
      panic("virtio_disk_intr status");
    8000598e:	00002517          	auipc	a0,0x2
    80005992:	dfa50513          	addi	a0,a0,-518 # 80007788 <etext+0x788>
    80005996:	dfffa0ef          	jal	80000794 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	0050051b          	addiw	a0,zero,5
    80006008:	0576                	slli	a0,a0,0x1d
    8000600a:	02153423          	sd	ra,40(a0)
    8000600e:	02253823          	sd	sp,48(a0)
    80006012:	02353c23          	sd	gp,56(a0)
    80006016:	04453023          	sd	tp,64(a0)
    8000601a:	04553423          	sd	t0,72(a0)
    8000601e:	04653823          	sd	t1,80(a0)
    80006022:	04753c23          	sd	t2,88(a0)
    80006026:	f120                	sd	s0,96(a0)
    80006028:	f524                	sd	s1,104(a0)
    8000602a:	fd2c                	sd	a1,120(a0)
    8000602c:	e150                	sd	a2,128(a0)
    8000602e:	e554                	sd	a3,136(a0)
    80006030:	e958                	sd	a4,144(a0)
    80006032:	ed5c                	sd	a5,152(a0)
    80006034:	0b053023          	sd	a6,160(a0)
    80006038:	0b153423          	sd	a7,168(a0)
    8000603c:	0b253823          	sd	s2,176(a0)
    80006040:	0b353c23          	sd	s3,184(a0)
    80006044:	0d453023          	sd	s4,192(a0)
    80006048:	0d553423          	sd	s5,200(a0)
    8000604c:	0d653823          	sd	s6,208(a0)
    80006050:	0d753c23          	sd	s7,216(a0)
    80006054:	0f853023          	sd	s8,224(a0)
    80006058:	0f953423          	sd	s9,232(a0)
    8000605c:	0fa53823          	sd	s10,240(a0)
    80006060:	0fb53c23          	sd	s11,248(a0)
    80006064:	11c53023          	sd	t3,256(a0)
    80006068:	11d53423          	sd	t4,264(a0)
    8000606c:	11e53823          	sd	t5,272(a0)
    80006070:	11f53c23          	sd	t6,280(a0)
    80006074:	140022f3          	csrr	t0,sscratch
    80006078:	06553823          	sd	t0,112(a0)
    8000607c:	00853103          	ld	sp,8(a0)
    80006080:	02053203          	ld	tp,32(a0)
    80006084:	01053283          	ld	t0,16(a0)
    80006088:	00053303          	ld	t1,0(a0)
    8000608c:	12000073          	sfence.vma
    80006090:	18031073          	csrw	satp,t1
    80006094:	12000073          	sfence.vma
    80006098:	8282                	jr	t0

000000008000609a <userret>:
    8000609a:	12000073          	sfence.vma
    8000609e:	4581                	li	a1,0
    800060a0:	18059073          	csrw	satp,a1
    800060a4:	12000073          	sfence.vma
    800060a8:	02853083          	ld	ra,40(a0)
    800060ac:	03053103          	ld	sp,48(a0)
    800060b0:	03853183          	ld	gp,56(a0)
    800060b4:	04053203          	ld	tp,64(a0)
    800060b8:	04853283          	ld	t0,72(a0)
    800060bc:	05053303          	ld	t1,80(a0)
    800060c0:	05853383          	ld	t2,88(a0)
    800060c4:	7120                	ld	s0,96(a0)
    800060c6:	7524                	ld	s1,104(a0)
    800060c8:	7d2c                	ld	a1,120(a0)
    800060ca:	6150                	ld	a2,128(a0)
    800060cc:	6554                	ld	a3,136(a0)
    800060ce:	6958                	ld	a4,144(a0)
    800060d0:	6d5c                	ld	a5,152(a0)
    800060d2:	0a053803          	ld	a6,160(a0)
    800060d6:	0a853883          	ld	a7,168(a0)
    800060da:	0b053903          	ld	s2,176(a0)
    800060de:	0b853983          	ld	s3,184(a0)
    800060e2:	0c053a03          	ld	s4,192(a0)
    800060e6:	0c853a83          	ld	s5,200(a0)
    800060ea:	0d053b03          	ld	s6,208(a0)
    800060ee:	0d853b83          	ld	s7,216(a0)
    800060f2:	0e053c03          	ld	s8,224(a0)
    800060f6:	0e853c83          	ld	s9,232(a0)
    800060fa:	0f053d03          	ld	s10,240(a0)
    800060fe:	0f853d83          	ld	s11,248(a0)
    80006102:	10053e03          	ld	t3,256(a0)
    80006106:	10853e83          	ld	t4,264(a0)
    8000610a:	11053f03          	ld	t5,272(a0)
    8000610e:	11853f83          	ld	t6,280(a0)
    80006112:	7928                	ld	a0,112(a0)
    80006114:	10200073          	sret
	...
