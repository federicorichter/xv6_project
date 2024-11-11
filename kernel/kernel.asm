
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
    800000fa:	647010ef          	jal	80001f40 <either_copyin>
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
    80000184:	42d010ef          	jal	80001db0 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	29b010ef          	jal	80001c28 <sleep>
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
    800001d2:	525010ef          	jal	80001ef6 <either_copyout>
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
    800002a0:	4eb010ef          	jal	80001f8a <procdump>
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
    800003e6:	08f010ef          	jal	80001c74 <wakeup>
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
    800008fe:	376010ef          	jal	80001c74 <wakeup>
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
    80000996:	292010ef          	jal	80001c28 <sleep>
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
    80000e9a:	6ba010ef          	jal	80002554 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e9e:	52a040ef          	jal	800053c8 <plicinithart>
  }

  scheduler();        
    80000ea2:	3df000ef          	jal	80001a80 <scheduler>
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
    80000eda:	656010ef          	jal	80002530 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ede:	676010ef          	jal	80002554 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ee2:	4cc040ef          	jal	800053ae <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000ee6:	4e2040ef          	jal	800053c8 <plicinithart>
    binit();         // buffer cache
    80000eea:	48b010ef          	jal	80002b74 <binit>
    iinit();         // inode table
    80000eee:	27c020ef          	jal	8000316a <iinit>
    fileinit();      // file table
    80000ef2:	028030ef          	jal	80003f1a <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000ef6:	5c2040ef          	jal	800054b8 <virtio_disk_init>
    init_priority_control();
    80000efa:	13a010ef          	jal	80002034 <init_priority_control>
    userinit();      // first user process
    80000efe:	2d6010ef          	jal	800021d4 <userinit>
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
    80001910:	45d000ef          	jal	8000256c <usertrapret>
}
    80001914:	60a2                	ld	ra,8(sp)
    80001916:	6402                	ld	s0,0(sp)
    80001918:	0141                	addi	sp,sp,16
    8000191a:	8082                	ret
    fsinit(ROOTDEV);
    8000191c:	4505                	li	a0,1
    8000191e:	7e0010ef          	jal	800030fe <fsinit>
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

000000008000196e <proc_pagetable>:
{
    8000196e:	1101                	addi	sp,sp,-32
    80001970:	ec06                	sd	ra,24(sp)
    80001972:	e822                	sd	s0,16(sp)
    80001974:	e426                	sd	s1,8(sp)
    80001976:	e04a                	sd	s2,0(sp)
    80001978:	1000                	addi	s0,sp,32
    8000197a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000197c:	8e5ff0ef          	jal	80001260 <uvmcreate>
    80001980:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001982:	c915                	beqz	a0,800019b6 <proc_pagetable+0x48>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001984:	4729                	li	a4,10
    80001986:	00004697          	auipc	a3,0x4
    8000198a:	67a68693          	addi	a3,a3,1658 # 80006000 <_trampoline>
    8000198e:	6605                	lui	a2,0x1
    80001990:	000a05b7          	lui	a1,0xa0
    80001994:	15fd                	addi	a1,a1,-1 # 9ffff <_entry-0x7ff60001>
    80001996:	05b2                	slli	a1,a1,0xc
    80001998:	e66ff0ef          	jal	80000ffe <mappages>
    8000199c:	02054463          	bltz	a0,800019c4 <proc_pagetable+0x56>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800019a0:	4719                	li	a4,6
    800019a2:	06093683          	ld	a3,96(s2)
    800019a6:	6605                	lui	a2,0x1
    800019a8:	4595                	li	a1,5
    800019aa:	05f6                	slli	a1,a1,0x1d
    800019ac:	8526                	mv	a0,s1
    800019ae:	e50ff0ef          	jal	80000ffe <mappages>
    800019b2:	00054f63          	bltz	a0,800019d0 <proc_pagetable+0x62>
}
    800019b6:	8526                	mv	a0,s1
    800019b8:	60e2                	ld	ra,24(sp)
    800019ba:	6442                	ld	s0,16(sp)
    800019bc:	64a2                	ld	s1,8(sp)
    800019be:	6902                	ld	s2,0(sp)
    800019c0:	6105                	addi	sp,sp,32
    800019c2:	8082                	ret
    uvmfree(pagetable, 0);
    800019c4:	4581                	li	a1,0
    800019c6:	8526                	mv	a0,s1
    800019c8:	a53ff0ef          	jal	8000141a <uvmfree>
    return 0;
    800019cc:	4481                	li	s1,0
    800019ce:	b7e5                	j	800019b6 <proc_pagetable+0x48>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800019d0:	4681                	li	a3,0
    800019d2:	4605                	li	a2,1
    800019d4:	000a05b7          	lui	a1,0xa0
    800019d8:	15fd                	addi	a1,a1,-1 # 9ffff <_entry-0x7ff60001>
    800019da:	05b2                	slli	a1,a1,0xc
    800019dc:	8526                	mv	a0,s1
    800019de:	fc6ff0ef          	jal	800011a4 <uvmunmap>
    uvmfree(pagetable, 0);
    800019e2:	4581                	li	a1,0
    800019e4:	8526                	mv	a0,s1
    800019e6:	a35ff0ef          	jal	8000141a <uvmfree>
    return 0;
    800019ea:	4481                	li	s1,0
    800019ec:	b7e9                	j	800019b6 <proc_pagetable+0x48>

00000000800019ee <proc_freepagetable>:
{
    800019ee:	1101                	addi	sp,sp,-32
    800019f0:	ec06                	sd	ra,24(sp)
    800019f2:	e822                	sd	s0,16(sp)
    800019f4:	e426                	sd	s1,8(sp)
    800019f6:	e04a                	sd	s2,0(sp)
    800019f8:	1000                	addi	s0,sp,32
    800019fa:	84aa                	mv	s1,a0
    800019fc:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800019fe:	4681                	li	a3,0
    80001a00:	4605                	li	a2,1
    80001a02:	000a05b7          	lui	a1,0xa0
    80001a06:	15fd                	addi	a1,a1,-1 # 9ffff <_entry-0x7ff60001>
    80001a08:	05b2                	slli	a1,a1,0xc
    80001a0a:	f9aff0ef          	jal	800011a4 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a0e:	4681                	li	a3,0
    80001a10:	4605                	li	a2,1
    80001a12:	4595                	li	a1,5
    80001a14:	05f6                	slli	a1,a1,0x1d
    80001a16:	8526                	mv	a0,s1
    80001a18:	f8cff0ef          	jal	800011a4 <uvmunmap>
  uvmfree(pagetable, sz);
    80001a1c:	85ca                	mv	a1,s2
    80001a1e:	8526                	mv	a0,s1
    80001a20:	9fbff0ef          	jal	8000141a <uvmfree>
}
    80001a24:	60e2                	ld	ra,24(sp)
    80001a26:	6442                	ld	s0,16(sp)
    80001a28:	64a2                	ld	s1,8(sp)
    80001a2a:	6902                	ld	s2,0(sp)
    80001a2c:	6105                	addi	sp,sp,32
    80001a2e:	8082                	ret

0000000080001a30 <growproc>:
{
    80001a30:	1101                	addi	sp,sp,-32
    80001a32:	ec06                	sd	ra,24(sp)
    80001a34:	e822                	sd	s0,16(sp)
    80001a36:	e426                	sd	s1,8(sp)
    80001a38:	e04a                	sd	s2,0(sp)
    80001a3a:	1000                	addi	s0,sp,32
    80001a3c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001a3e:	e87ff0ef          	jal	800018c4 <myproc>
    80001a42:	84aa                	mv	s1,a0
  sz = p->sz;
    80001a44:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001a46:	01204c63          	bgtz	s2,80001a5e <growproc+0x2e>
  } else if(n < 0){
    80001a4a:	02094463          	bltz	s2,80001a72 <growproc+0x42>
  p->sz = sz;
    80001a4e:	e4ac                	sd	a1,72(s1)
  return 0;
    80001a50:	4501                	li	a0,0
}
    80001a52:	60e2                	ld	ra,24(sp)
    80001a54:	6442                	ld	s0,16(sp)
    80001a56:	64a2                	ld	s1,8(sp)
    80001a58:	6902                	ld	s2,0(sp)
    80001a5a:	6105                	addi	sp,sp,32
    80001a5c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001a5e:	4691                	li	a3,4
    80001a60:	00b90633          	add	a2,s2,a1
    80001a64:	6928                	ld	a0,80(a0)
    80001a66:	8afff0ef          	jal	80001314 <uvmalloc>
    80001a6a:	85aa                	mv	a1,a0
    80001a6c:	f16d                	bnez	a0,80001a4e <growproc+0x1e>
      return -1;
    80001a6e:	557d                	li	a0,-1
    80001a70:	b7cd                	j	80001a52 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001a72:	00b90633          	add	a2,s2,a1
    80001a76:	6928                	ld	a0,80(a0)
    80001a78:	859ff0ef          	jal	800012d0 <uvmdealloc>
    80001a7c:	85aa                	mv	a1,a0
    80001a7e:	bfc1                	j	80001a4e <growproc+0x1e>

0000000080001a80 <scheduler>:
{
    80001a80:	715d                	addi	sp,sp,-80
    80001a82:	e486                	sd	ra,72(sp)
    80001a84:	e0a2                	sd	s0,64(sp)
    80001a86:	fc26                	sd	s1,56(sp)
    80001a88:	f84a                	sd	s2,48(sp)
    80001a8a:	f44e                	sd	s3,40(sp)
    80001a8c:	f052                	sd	s4,32(sp)
    80001a8e:	ec56                	sd	s5,24(sp)
    80001a90:	e85a                	sd	s6,16(sp)
    80001a92:	e45e                	sd	s7,8(sp)
    80001a94:	e062                	sd	s8,0(sp)
    80001a96:	0880                	addi	s0,sp,80
    80001a98:	8792                	mv	a5,tp
  int id = r_tp();
    80001a9a:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001a9c:	00779b13          	slli	s6,a5,0x7
    80001aa0:	0000e717          	auipc	a4,0xe
    80001aa4:	fc070713          	addi	a4,a4,-64 # 8000fa60 <proc>
    80001aa8:	975a                	add	a4,a4,s6
    80001aaa:	7a073823          	sd	zero,1968(a4)
        swtch(&c->context, &p->context);
    80001aae:	0000e717          	auipc	a4,0xe
    80001ab2:	76a70713          	addi	a4,a4,1898 # 80010218 <cpus+0x8>
    80001ab6:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001ab8:	4c11                	li	s8,4
        c->proc = p;
    80001aba:	079e                	slli	a5,a5,0x7
    80001abc:	0000ea97          	auipc	s5,0xe
    80001ac0:	fa4a8a93          	addi	s5,s5,-92 # 8000fa60 <proc>
    80001ac4:	9abe                	add	s5,s5,a5
        found = 1;
    80001ac6:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ac8:	0000e997          	auipc	s3,0xe
    80001acc:	71898993          	addi	s3,s3,1816 # 800101e0 <pid_lock>
    80001ad0:	a0a9                	j	80001b1a <scheduler+0x9a>
      release(&p->lock);
    80001ad2:	8526                	mv	a0,s1
    80001ad4:	9baff0ef          	jal	80000c8e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ad8:	18048493          	addi	s1,s1,384
    80001adc:	03348563          	beq	s1,s3,80001b06 <scheduler+0x86>
      acquire(&p->lock);
    80001ae0:	8526                	mv	a0,s1
    80001ae2:	914ff0ef          	jal	80000bf6 <acquire>
      if(p->state == RUNNABLE) {
    80001ae6:	4c9c                	lw	a5,24(s1)
    80001ae8:	ff2795e3          	bne	a5,s2,80001ad2 <scheduler+0x52>
        p->state = RUNNING;
    80001aec:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001af0:	7a9ab823          	sd	s1,1968(s5)
        swtch(&c->context, &p->context);
    80001af4:	06848593          	addi	a1,s1,104
    80001af8:	855a                	mv	a0,s6
    80001afa:	1cd000ef          	jal	800024c6 <swtch>
        c->proc = 0;
    80001afe:	7a0ab823          	sd	zero,1968(s5)
        found = 1;
    80001b02:	8a5e                	mv	s4,s7
    80001b04:	b7f9                	j	80001ad2 <scheduler+0x52>
    if(found == 0) {
    80001b06:	000a1a63          	bnez	s4,80001b1a <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b0a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b0e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b12:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001b16:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b1a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b1e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b22:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001b26:	4a01                	li	s4,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001b28:	0000e497          	auipc	s1,0xe
    80001b2c:	f3848493          	addi	s1,s1,-200 # 8000fa60 <proc>
      if(p->state == RUNNABLE) {
    80001b30:	490d                	li	s2,3
    80001b32:	b77d                	j	80001ae0 <scheduler+0x60>

0000000080001b34 <sched>:
{
    80001b34:	7179                	addi	sp,sp,-48
    80001b36:	f406                	sd	ra,40(sp)
    80001b38:	f022                	sd	s0,32(sp)
    80001b3a:	ec26                	sd	s1,24(sp)
    80001b3c:	e84a                	sd	s2,16(sp)
    80001b3e:	e44e                	sd	s3,8(sp)
    80001b40:	e052                	sd	s4,0(sp)
    80001b42:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001b44:	d81ff0ef          	jal	800018c4 <myproc>
    80001b48:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001b4a:	842ff0ef          	jal	80000b8c <holding>
    80001b4e:	cd3d                	beqz	a0,80001bcc <sched+0x98>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b50:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001b52:	2781                	sext.w	a5,a5
    80001b54:	079e                	slli	a5,a5,0x7
    80001b56:	0000e717          	auipc	a4,0xe
    80001b5a:	f0a70713          	addi	a4,a4,-246 # 8000fa60 <proc>
    80001b5e:	973e                	add	a4,a4,a5
    80001b60:	6785                	lui	a5,0x1
    80001b62:	97ba                	add	a5,a5,a4
    80001b64:	8287a703          	lw	a4,-2008(a5) # 828 <_entry-0x7ffff7d8>
    80001b68:	4785                	li	a5,1
    80001b6a:	06f71763          	bne	a4,a5,80001bd8 <sched+0xa4>
  if(p->state == RUNNING)
    80001b6e:	4c98                	lw	a4,24(s1)
    80001b70:	4791                	li	a5,4
    80001b72:	06f70963          	beq	a4,a5,80001be4 <sched+0xb0>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b76:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b7a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001b7c:	ebb5                	bnez	a5,80001bf0 <sched+0xbc>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b7e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001b80:	0000e917          	auipc	s2,0xe
    80001b84:	ee090913          	addi	s2,s2,-288 # 8000fa60 <proc>
    80001b88:	2781                	sext.w	a5,a5
    80001b8a:	079e                	slli	a5,a5,0x7
    80001b8c:	97ca                	add	a5,a5,s2
    80001b8e:	6985                	lui	s3,0x1
    80001b90:	97ce                	add	a5,a5,s3
    80001b92:	82c7aa03          	lw	s4,-2004(a5)
    80001b96:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001b98:	2781                	sext.w	a5,a5
    80001b9a:	079e                	slli	a5,a5,0x7
    80001b9c:	0000e597          	auipc	a1,0xe
    80001ba0:	67c58593          	addi	a1,a1,1660 # 80010218 <cpus+0x8>
    80001ba4:	95be                	add	a1,a1,a5
    80001ba6:	06848513          	addi	a0,s1,104
    80001baa:	11d000ef          	jal	800024c6 <swtch>
    80001bae:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001bb0:	2781                	sext.w	a5,a5
    80001bb2:	079e                	slli	a5,a5,0x7
    80001bb4:	993e                	add	s2,s2,a5
    80001bb6:	99ca                	add	s3,s3,s2
    80001bb8:	8349a623          	sw	s4,-2004(s3) # 82c <_entry-0x7ffff7d4>
}
    80001bbc:	70a2                	ld	ra,40(sp)
    80001bbe:	7402                	ld	s0,32(sp)
    80001bc0:	64e2                	ld	s1,24(sp)
    80001bc2:	6942                	ld	s2,16(sp)
    80001bc4:	69a2                	ld	s3,8(sp)
    80001bc6:	6a02                	ld	s4,0(sp)
    80001bc8:	6145                	addi	sp,sp,48
    80001bca:	8082                	ret
    panic("sched p->lock");
    80001bcc:	00005517          	auipc	a0,0x5
    80001bd0:	65450513          	addi	a0,a0,1620 # 80007220 <etext+0x220>
    80001bd4:	bc1fe0ef          	jal	80000794 <panic>
    panic("sched locks");
    80001bd8:	00005517          	auipc	a0,0x5
    80001bdc:	65850513          	addi	a0,a0,1624 # 80007230 <etext+0x230>
    80001be0:	bb5fe0ef          	jal	80000794 <panic>
    panic("sched running");
    80001be4:	00005517          	auipc	a0,0x5
    80001be8:	65c50513          	addi	a0,a0,1628 # 80007240 <etext+0x240>
    80001bec:	ba9fe0ef          	jal	80000794 <panic>
    panic("sched interruptible");
    80001bf0:	00005517          	auipc	a0,0x5
    80001bf4:	66050513          	addi	a0,a0,1632 # 80007250 <etext+0x250>
    80001bf8:	b9dfe0ef          	jal	80000794 <panic>

0000000080001bfc <yield>:
{
    80001bfc:	1101                	addi	sp,sp,-32
    80001bfe:	ec06                	sd	ra,24(sp)
    80001c00:	e822                	sd	s0,16(sp)
    80001c02:	e426                	sd	s1,8(sp)
    80001c04:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001c06:	cbfff0ef          	jal	800018c4 <myproc>
    80001c0a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001c0c:	febfe0ef          	jal	80000bf6 <acquire>
  p->state = RUNNABLE;
    80001c10:	478d                	li	a5,3
    80001c12:	cc9c                	sw	a5,24(s1)
  sched();
    80001c14:	f21ff0ef          	jal	80001b34 <sched>
  release(&p->lock);
    80001c18:	8526                	mv	a0,s1
    80001c1a:	874ff0ef          	jal	80000c8e <release>
}
    80001c1e:	60e2                	ld	ra,24(sp)
    80001c20:	6442                	ld	s0,16(sp)
    80001c22:	64a2                	ld	s1,8(sp)
    80001c24:	6105                	addi	sp,sp,32
    80001c26:	8082                	ret

0000000080001c28 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001c28:	7179                	addi	sp,sp,-48
    80001c2a:	f406                	sd	ra,40(sp)
    80001c2c:	f022                	sd	s0,32(sp)
    80001c2e:	ec26                	sd	s1,24(sp)
    80001c30:	e84a                	sd	s2,16(sp)
    80001c32:	e44e                	sd	s3,8(sp)
    80001c34:	1800                	addi	s0,sp,48
    80001c36:	89aa                	mv	s3,a0
    80001c38:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c3a:	c8bff0ef          	jal	800018c4 <myproc>
    80001c3e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001c40:	fb7fe0ef          	jal	80000bf6 <acquire>
  release(lk);
    80001c44:	854a                	mv	a0,s2
    80001c46:	848ff0ef          	jal	80000c8e <release>

  // Go to sleep.
  p->chan = chan;
    80001c4a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001c4e:	4789                	li	a5,2
    80001c50:	cc9c                	sw	a5,24(s1)

  sched();
    80001c52:	ee3ff0ef          	jal	80001b34 <sched>

  // Tidy up.
  p->chan = 0;
    80001c56:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001c5a:	8526                	mv	a0,s1
    80001c5c:	832ff0ef          	jal	80000c8e <release>
  acquire(lk);
    80001c60:	854a                	mv	a0,s2
    80001c62:	f95fe0ef          	jal	80000bf6 <acquire>
}
    80001c66:	70a2                	ld	ra,40(sp)
    80001c68:	7402                	ld	s0,32(sp)
    80001c6a:	64e2                	ld	s1,24(sp)
    80001c6c:	6942                	ld	s2,16(sp)
    80001c6e:	69a2                	ld	s3,8(sp)
    80001c70:	6145                	addi	sp,sp,48
    80001c72:	8082                	ret

0000000080001c74 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001c74:	7179                	addi	sp,sp,-48
    80001c76:	f406                	sd	ra,40(sp)
    80001c78:	f022                	sd	s0,32(sp)
    80001c7a:	ec26                	sd	s1,24(sp)
    80001c7c:	e84a                	sd	s2,16(sp)
    80001c7e:	e44e                	sd	s3,8(sp)
    80001c80:	e052                	sd	s4,0(sp)
    80001c82:	1800                	addi	s0,sp,48
    80001c84:	89aa                	mv	s3,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001c86:	0000e497          	auipc	s1,0xe
    80001c8a:	dda48493          	addi	s1,s1,-550 # 8000fa60 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001c8e:	4a09                	li	s4,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c90:	0000e917          	auipc	s2,0xe
    80001c94:	55090913          	addi	s2,s2,1360 # 800101e0 <pid_lock>
    80001c98:	a801                	j	80001ca8 <wakeup+0x34>
        p->state = RUNNABLE;
      }
      release(&p->lock);
    80001c9a:	8526                	mv	a0,s1
    80001c9c:	ff3fe0ef          	jal	80000c8e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ca0:	18048493          	addi	s1,s1,384
    80001ca4:	03248263          	beq	s1,s2,80001cc8 <wakeup+0x54>
    if(p != myproc()){
    80001ca8:	c1dff0ef          	jal	800018c4 <myproc>
    80001cac:	fea48ae3          	beq	s1,a0,80001ca0 <wakeup+0x2c>
      acquire(&p->lock);
    80001cb0:	8526                	mv	a0,s1
    80001cb2:	f45fe0ef          	jal	80000bf6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001cb6:	4c9c                	lw	a5,24(s1)
    80001cb8:	ff4791e3          	bne	a5,s4,80001c9a <wakeup+0x26>
    80001cbc:	709c                	ld	a5,32(s1)
    80001cbe:	fd379ee3          	bne	a5,s3,80001c9a <wakeup+0x26>
        p->state = RUNNABLE;
    80001cc2:	478d                	li	a5,3
    80001cc4:	cc9c                	sw	a5,24(s1)
    80001cc6:	bfd1                	j	80001c9a <wakeup+0x26>
    }
  }
}
    80001cc8:	70a2                	ld	ra,40(sp)
    80001cca:	7402                	ld	s0,32(sp)
    80001ccc:	64e2                	ld	s1,24(sp)
    80001cce:	6942                	ld	s2,16(sp)
    80001cd0:	69a2                	ld	s3,8(sp)
    80001cd2:	6a02                	ld	s4,0(sp)
    80001cd4:	6145                	addi	sp,sp,48
    80001cd6:	8082                	ret

0000000080001cd8 <reparent>:
{
    80001cd8:	7179                	addi	sp,sp,-48
    80001cda:	f406                	sd	ra,40(sp)
    80001cdc:	f022                	sd	s0,32(sp)
    80001cde:	ec26                	sd	s1,24(sp)
    80001ce0:	e84a                	sd	s2,16(sp)
    80001ce2:	e44e                	sd	s3,8(sp)
    80001ce4:	1800                	addi	s0,sp,48
    80001ce6:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ce8:	0000e497          	auipc	s1,0xe
    80001cec:	d7848493          	addi	s1,s1,-648 # 8000fa60 <proc>
    80001cf0:	0000e997          	auipc	s3,0xe
    80001cf4:	4f098993          	addi	s3,s3,1264 # 800101e0 <pid_lock>
    80001cf8:	a029                	j	80001d02 <reparent+0x2a>
    80001cfa:	18048493          	addi	s1,s1,384
    80001cfe:	01348d63          	beq	s1,s3,80001d18 <reparent+0x40>
    if(pp->parent == p){
    80001d02:	7c9c                	ld	a5,56(s1)
    80001d04:	ff279be3          	bne	a5,s2,80001cfa <reparent+0x22>
      pp->parent = initproc;
    80001d08:	00006517          	auipc	a0,0x6
    80001d0c:	c2053503          	ld	a0,-992(a0) # 80007928 <initproc>
    80001d10:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001d12:	f63ff0ef          	jal	80001c74 <wakeup>
    80001d16:	b7d5                	j	80001cfa <reparent+0x22>
}
    80001d18:	70a2                	ld	ra,40(sp)
    80001d1a:	7402                	ld	s0,32(sp)
    80001d1c:	64e2                	ld	s1,24(sp)
    80001d1e:	6942                	ld	s2,16(sp)
    80001d20:	69a2                	ld	s3,8(sp)
    80001d22:	6145                	addi	sp,sp,48
    80001d24:	8082                	ret

0000000080001d26 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001d26:	7179                	addi	sp,sp,-48
    80001d28:	f406                	sd	ra,40(sp)
    80001d2a:	f022                	sd	s0,32(sp)
    80001d2c:	ec26                	sd	s1,24(sp)
    80001d2e:	e84a                	sd	s2,16(sp)
    80001d30:	e44e                	sd	s3,8(sp)
    80001d32:	1800                	addi	s0,sp,48
    80001d34:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001d36:	0000e497          	auipc	s1,0xe
    80001d3a:	d2a48493          	addi	s1,s1,-726 # 8000fa60 <proc>
    80001d3e:	0000e997          	auipc	s3,0xe
    80001d42:	4a298993          	addi	s3,s3,1186 # 800101e0 <pid_lock>
    acquire(&p->lock);
    80001d46:	8526                	mv	a0,s1
    80001d48:	eaffe0ef          	jal	80000bf6 <acquire>
    if(p->pid == pid){
    80001d4c:	589c                	lw	a5,48(s1)
    80001d4e:	03278163          	beq	a5,s2,80001d70 <kill+0x4a>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001d52:	8526                	mv	a0,s1
    80001d54:	f3bfe0ef          	jal	80000c8e <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001d58:	18048493          	addi	s1,s1,384
    80001d5c:	ff3495e3          	bne	s1,s3,80001d46 <kill+0x20>
  }
  return -1;
    80001d60:	557d                	li	a0,-1
}
    80001d62:	70a2                	ld	ra,40(sp)
    80001d64:	7402                	ld	s0,32(sp)
    80001d66:	64e2                	ld	s1,24(sp)
    80001d68:	6942                	ld	s2,16(sp)
    80001d6a:	69a2                	ld	s3,8(sp)
    80001d6c:	6145                	addi	sp,sp,48
    80001d6e:	8082                	ret
      p->killed = 1;
    80001d70:	4785                	li	a5,1
    80001d72:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001d74:	4c98                	lw	a4,24(s1)
    80001d76:	4789                	li	a5,2
    80001d78:	00f70763          	beq	a4,a5,80001d86 <kill+0x60>
      release(&p->lock);
    80001d7c:	8526                	mv	a0,s1
    80001d7e:	f11fe0ef          	jal	80000c8e <release>
      return 0;
    80001d82:	4501                	li	a0,0
    80001d84:	bff9                	j	80001d62 <kill+0x3c>
        p->state = RUNNABLE;
    80001d86:	478d                	li	a5,3
    80001d88:	cc9c                	sw	a5,24(s1)
    80001d8a:	bfcd                	j	80001d7c <kill+0x56>

0000000080001d8c <setkilled>:

void
setkilled(struct proc *p)
{
    80001d8c:	1101                	addi	sp,sp,-32
    80001d8e:	ec06                	sd	ra,24(sp)
    80001d90:	e822                	sd	s0,16(sp)
    80001d92:	e426                	sd	s1,8(sp)
    80001d94:	1000                	addi	s0,sp,32
    80001d96:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001d98:	e5ffe0ef          	jal	80000bf6 <acquire>
  p->killed = 1;
    80001d9c:	4785                	li	a5,1
    80001d9e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001da0:	8526                	mv	a0,s1
    80001da2:	eedfe0ef          	jal	80000c8e <release>
}
    80001da6:	60e2                	ld	ra,24(sp)
    80001da8:	6442                	ld	s0,16(sp)
    80001daa:	64a2                	ld	s1,8(sp)
    80001dac:	6105                	addi	sp,sp,32
    80001dae:	8082                	ret

0000000080001db0 <killed>:

int
killed(struct proc *p)
{
    80001db0:	1101                	addi	sp,sp,-32
    80001db2:	ec06                	sd	ra,24(sp)
    80001db4:	e822                	sd	s0,16(sp)
    80001db6:	e426                	sd	s1,8(sp)
    80001db8:	e04a                	sd	s2,0(sp)
    80001dba:	1000                	addi	s0,sp,32
    80001dbc:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001dbe:	e39fe0ef          	jal	80000bf6 <acquire>
  k = p->killed;
    80001dc2:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001dc6:	8526                	mv	a0,s1
    80001dc8:	ec7fe0ef          	jal	80000c8e <release>
  return k;
}
    80001dcc:	854a                	mv	a0,s2
    80001dce:	60e2                	ld	ra,24(sp)
    80001dd0:	6442                	ld	s0,16(sp)
    80001dd2:	64a2                	ld	s1,8(sp)
    80001dd4:	6902                	ld	s2,0(sp)
    80001dd6:	6105                	addi	sp,sp,32
    80001dd8:	8082                	ret

0000000080001dda <wait>:
{
    80001dda:	715d                	addi	sp,sp,-80
    80001ddc:	e486                	sd	ra,72(sp)
    80001dde:	e0a2                	sd	s0,64(sp)
    80001de0:	fc26                	sd	s1,56(sp)
    80001de2:	f84a                	sd	s2,48(sp)
    80001de4:	f44e                	sd	s3,40(sp)
    80001de6:	f052                	sd	s4,32(sp)
    80001de8:	ec56                	sd	s5,24(sp)
    80001dea:	e85a                	sd	s6,16(sp)
    80001dec:	e45e                	sd	s7,8(sp)
    80001dee:	e062                	sd	s8,0(sp)
    80001df0:	0880                	addi	s0,sp,80
    80001df2:	8c2a                	mv	s8,a0
  struct proc *p = myproc();
    80001df4:	ad1ff0ef          	jal	800018c4 <myproc>
    80001df8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001dfa:	0000e517          	auipc	a0,0xe
    80001dfe:	3fe50513          	addi	a0,a0,1022 # 800101f8 <wait_lock>
    80001e02:	df5fe0ef          	jal	80000bf6 <acquire>
    havekids = 0;
    80001e06:	4a01                	li	s4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001e08:	0000e997          	auipc	s3,0xe
    80001e0c:	3d898993          	addi	s3,s3,984 # 800101e0 <pid_lock>
        if(pp->state == ZOMBIE){
    80001e10:	4b15                	li	s6,5
        havekids = 1;
    80001e12:	4b85                	li	s7,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001e14:	0000ea97          	auipc	s5,0xe
    80001e18:	3e4a8a93          	addi	s5,s5,996 # 800101f8 <wait_lock>
    80001e1c:	a861                	j	80001eb4 <wait+0xda>
        acquire(&pp->lock);
    80001e1e:	8526                	mv	a0,s1
    80001e20:	dd7fe0ef          	jal	80000bf6 <acquire>
        if(pp->state == ZOMBIE){
    80001e24:	4c9c                	lw	a5,24(s1)
    80001e26:	01678763          	beq	a5,s6,80001e34 <wait+0x5a>
        release(&pp->lock);
    80001e2a:	8526                	mv	a0,s1
    80001e2c:	e63fe0ef          	jal	80000c8e <release>
        havekids = 1;
    80001e30:	875e                	mv	a4,s7
    80001e32:	a849                	j	80001ec4 <wait+0xea>
          pid = pp->pid;
    80001e34:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001e38:	000c0c63          	beqz	s8,80001e50 <wait+0x76>
    80001e3c:	4691                	li	a3,4
    80001e3e:	02c48613          	addi	a2,s1,44
    80001e42:	85e2                	mv	a1,s8
    80001e44:	05093503          	ld	a0,80(s2)
    80001e48:	ee0ff0ef          	jal	80001528 <copyout>
    80001e4c:	04054063          	bltz	a0,80001e8c <wait+0xb2>
  p->trapframe = 0;
    80001e50:	0604b023          	sd	zero,96(s1)
  p->base_addr = 0;
    80001e54:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001e58:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001e5c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001e60:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001e64:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001e68:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001e6c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001e70:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001e74:	0004ac23          	sw	zero,24(s1)
          release(&pp->lock);
    80001e78:	8526                	mv	a0,s1
    80001e7a:	e15fe0ef          	jal	80000c8e <release>
          release(&wait_lock);
    80001e7e:	0000e517          	auipc	a0,0xe
    80001e82:	37a50513          	addi	a0,a0,890 # 800101f8 <wait_lock>
    80001e86:	e09fe0ef          	jal	80000c8e <release>
          return pid;
    80001e8a:	a889                	j	80001edc <wait+0x102>
            release(&pp->lock);
    80001e8c:	8526                	mv	a0,s1
    80001e8e:	e01fe0ef          	jal	80000c8e <release>
            release(&wait_lock);
    80001e92:	0000e517          	auipc	a0,0xe
    80001e96:	36650513          	addi	a0,a0,870 # 800101f8 <wait_lock>
    80001e9a:	df5fe0ef          	jal	80000c8e <release>
            return -1;
    80001e9e:	59fd                	li	s3,-1
    80001ea0:	a835                	j	80001edc <wait+0x102>
    if(!havekids || killed(p)){
    80001ea2:	c715                	beqz	a4,80001ece <wait+0xf4>
    80001ea4:	854a                	mv	a0,s2
    80001ea6:	f0bff0ef          	jal	80001db0 <killed>
    80001eaa:	e115                	bnez	a0,80001ece <wait+0xf4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001eac:	85d6                	mv	a1,s5
    80001eae:	854a                	mv	a0,s2
    80001eb0:	d79ff0ef          	jal	80001c28 <sleep>
    havekids = 0;
    80001eb4:	8752                	mv	a4,s4
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001eb6:	0000e497          	auipc	s1,0xe
    80001eba:	baa48493          	addi	s1,s1,-1110 # 8000fa60 <proc>
      if(pp->parent == p){
    80001ebe:	7c9c                	ld	a5,56(s1)
    80001ec0:	f5278fe3          	beq	a5,s2,80001e1e <wait+0x44>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ec4:	18048493          	addi	s1,s1,384
    80001ec8:	ff349be3          	bne	s1,s3,80001ebe <wait+0xe4>
    80001ecc:	bfd9                	j	80001ea2 <wait+0xc8>
      release(&wait_lock);
    80001ece:	0000e517          	auipc	a0,0xe
    80001ed2:	32a50513          	addi	a0,a0,810 # 800101f8 <wait_lock>
    80001ed6:	db9fe0ef          	jal	80000c8e <release>
      return -1;
    80001eda:	59fd                	li	s3,-1
}
    80001edc:	854e                	mv	a0,s3
    80001ede:	60a6                	ld	ra,72(sp)
    80001ee0:	6406                	ld	s0,64(sp)
    80001ee2:	74e2                	ld	s1,56(sp)
    80001ee4:	7942                	ld	s2,48(sp)
    80001ee6:	79a2                	ld	s3,40(sp)
    80001ee8:	7a02                	ld	s4,32(sp)
    80001eea:	6ae2                	ld	s5,24(sp)
    80001eec:	6b42                	ld	s6,16(sp)
    80001eee:	6ba2                	ld	s7,8(sp)
    80001ef0:	6c02                	ld	s8,0(sp)
    80001ef2:	6161                	addi	sp,sp,80
    80001ef4:	8082                	ret

0000000080001ef6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001ef6:	7179                	addi	sp,sp,-48
    80001ef8:	f406                	sd	ra,40(sp)
    80001efa:	f022                	sd	s0,32(sp)
    80001efc:	ec26                	sd	s1,24(sp)
    80001efe:	e84a                	sd	s2,16(sp)
    80001f00:	e44e                	sd	s3,8(sp)
    80001f02:	e052                	sd	s4,0(sp)
    80001f04:	1800                	addi	s0,sp,48
    80001f06:	84aa                	mv	s1,a0
    80001f08:	892e                	mv	s2,a1
    80001f0a:	89b2                	mv	s3,a2
    80001f0c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001f0e:	9b7ff0ef          	jal	800018c4 <myproc>
  if(user_dst){
    80001f12:	cc99                	beqz	s1,80001f30 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001f14:	86d2                	mv	a3,s4
    80001f16:	864e                	mv	a2,s3
    80001f18:	85ca                	mv	a1,s2
    80001f1a:	6928                	ld	a0,80(a0)
    80001f1c:	e0cff0ef          	jal	80001528 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001f20:	70a2                	ld	ra,40(sp)
    80001f22:	7402                	ld	s0,32(sp)
    80001f24:	64e2                	ld	s1,24(sp)
    80001f26:	6942                	ld	s2,16(sp)
    80001f28:	69a2                	ld	s3,8(sp)
    80001f2a:	6a02                	ld	s4,0(sp)
    80001f2c:	6145                	addi	sp,sp,48
    80001f2e:	8082                	ret
    memmove((char *)dst, src, len);
    80001f30:	000a061b          	sext.w	a2,s4
    80001f34:	85ce                	mv	a1,s3
    80001f36:	854a                	mv	a0,s2
    80001f38:	deffe0ef          	jal	80000d26 <memmove>
    return 0;
    80001f3c:	8526                	mv	a0,s1
    80001f3e:	b7cd                	j	80001f20 <either_copyout+0x2a>

0000000080001f40 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001f40:	7179                	addi	sp,sp,-48
    80001f42:	f406                	sd	ra,40(sp)
    80001f44:	f022                	sd	s0,32(sp)
    80001f46:	ec26                	sd	s1,24(sp)
    80001f48:	e84a                	sd	s2,16(sp)
    80001f4a:	e44e                	sd	s3,8(sp)
    80001f4c:	e052                	sd	s4,0(sp)
    80001f4e:	1800                	addi	s0,sp,48
    80001f50:	892a                	mv	s2,a0
    80001f52:	84ae                	mv	s1,a1
    80001f54:	89b2                	mv	s3,a2
    80001f56:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001f58:	96dff0ef          	jal	800018c4 <myproc>
  if(user_src){
    80001f5c:	cc99                	beqz	s1,80001f7a <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001f5e:	86d2                	mv	a3,s4
    80001f60:	864e                	mv	a2,s3
    80001f62:	85ca                	mv	a1,s2
    80001f64:	6928                	ld	a0,80(a0)
    80001f66:	e98ff0ef          	jal	800015fe <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001f6a:	70a2                	ld	ra,40(sp)
    80001f6c:	7402                	ld	s0,32(sp)
    80001f6e:	64e2                	ld	s1,24(sp)
    80001f70:	6942                	ld	s2,16(sp)
    80001f72:	69a2                	ld	s3,8(sp)
    80001f74:	6a02                	ld	s4,0(sp)
    80001f76:	6145                	addi	sp,sp,48
    80001f78:	8082                	ret
    memmove(dst, (char*)src, len);
    80001f7a:	000a061b          	sext.w	a2,s4
    80001f7e:	85ce                	mv	a1,s3
    80001f80:	854a                	mv	a0,s2
    80001f82:	da5fe0ef          	jal	80000d26 <memmove>
    return 0;
    80001f86:	8526                	mv	a0,s1
    80001f88:	b7cd                	j	80001f6a <either_copyin+0x2a>

0000000080001f8a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001f8a:	715d                	addi	sp,sp,-80
    80001f8c:	e486                	sd	ra,72(sp)
    80001f8e:	e0a2                	sd	s0,64(sp)
    80001f90:	fc26                	sd	s1,56(sp)
    80001f92:	f84a                	sd	s2,48(sp)
    80001f94:	f44e                	sd	s3,40(sp)
    80001f96:	f052                	sd	s4,32(sp)
    80001f98:	ec56                	sd	s5,24(sp)
    80001f9a:	e85a                	sd	s6,16(sp)
    80001f9c:	e45e                	sd	s7,8(sp)
    80001f9e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001fa0:	00005517          	auipc	a0,0x5
    80001fa4:	0d850513          	addi	a0,a0,216 # 80007078 <etext+0x78>
    80001fa8:	d1afe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001fac:	0000e497          	auipc	s1,0xe
    80001fb0:	c1448493          	addi	s1,s1,-1004 # 8000fbc0 <proc+0x160>
    80001fb4:	0000e917          	auipc	s2,0xe
    80001fb8:	38c90913          	addi	s2,s2,908 # 80010340 <cpus+0x130>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001fbc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001fbe:	00005a97          	auipc	s5,0x5
    80001fc2:	2aaa8a93          	addi	s5,s5,682 # 80007268 <etext+0x268>
    printf("%d %s %s", p->pid, state, p->name);
    80001fc6:	00005a17          	auipc	s4,0x5
    80001fca:	2aaa0a13          	addi	s4,s4,682 # 80007270 <etext+0x270>
    printf("\n");
    80001fce:	00005997          	auipc	s3,0x5
    80001fd2:	0aa98993          	addi	s3,s3,170 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001fd6:	00005b97          	auipc	s7,0x5
    80001fda:	7e2b8b93          	addi	s7,s7,2018 # 800077b8 <states.0>
    80001fde:	a829                	j	80001ff8 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001fe0:	ed06a583          	lw	a1,-304(a3)
    80001fe4:	8552                	mv	a0,s4
    80001fe6:	cdcfe0ef          	jal	800004c2 <printf>
    printf("\n");
    80001fea:	854e                	mv	a0,s3
    80001fec:	cd6fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ff0:	18048493          	addi	s1,s1,384
    80001ff4:	03248563          	beq	s1,s2,8000201e <procdump+0x94>
    if(p->state == UNUSED)
    80001ff8:	86a6                	mv	a3,s1
    80001ffa:	eb84a783          	lw	a5,-328(s1)
    80001ffe:	dbed                	beqz	a5,80001ff0 <procdump+0x66>
      state = "???";
    80002000:	8656                	mv	a2,s5
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002002:	fcfb6fe3          	bltu	s6,a5,80001fe0 <procdump+0x56>
    80002006:	02079713          	slli	a4,a5,0x20
    8000200a:	01d75793          	srli	a5,a4,0x1d
    8000200e:	97de                	add	a5,a5,s7
    80002010:	6390                	ld	a2,0(a5)
    80002012:	f679                	bnez	a2,80001fe0 <procdump+0x56>
      state = "???";
    80002014:	00005617          	auipc	a2,0x5
    80002018:	25460613          	addi	a2,a2,596 # 80007268 <etext+0x268>
    8000201c:	b7d1                	j	80001fe0 <procdump+0x56>
  }
}
    8000201e:	60a6                	ld	ra,72(sp)
    80002020:	6406                	ld	s0,64(sp)
    80002022:	74e2                	ld	s1,56(sp)
    80002024:	7942                	ld	s2,48(sp)
    80002026:	79a2                	ld	s3,40(sp)
    80002028:	7a02                	ld	s4,32(sp)
    8000202a:	6ae2                	ld	s5,24(sp)
    8000202c:	6b42                	ld	s6,16(sp)
    8000202e:	6ba2                	ld	s7,8(sp)
    80002030:	6161                	addi	sp,sp,80
    80002032:	8082                	ret

0000000080002034 <init_priority_control>:

void init_priority_control(void){
    80002034:	1141                	addi	sp,sp,-16
    80002036:	e406                	sd	ra,8(sp)
    80002038:	e022                	sd	s0,0(sp)
    8000203a:	0800                	addi	s0,sp,16

  initlock(&priority_lock,"priority_lock");
    8000203c:	00005597          	auipc	a1,0x5
    80002040:	24458593          	addi	a1,a1,580 # 80007280 <etext+0x280>
    80002044:	0000e517          	auipc	a0,0xe
    80002048:	5cc50513          	addi	a0,a0,1484 # 80010610 <priority_lock>
    8000204c:	b2bfe0ef          	jal	80000b76 <initlock>

  for(int i = 0;i < MAXPRIORITY; i++){
    80002050:	0000e797          	auipc	a5,0xe
    80002054:	5f078793          	addi	a5,a5,1520 # 80010640 <p_control+0x18>
    80002058:	0000e717          	auipc	a4,0xe
    8000205c:	5d070713          	addi	a4,a4,1488 # 80010628 <p_control>
    80002060:	0000e697          	auipc	a3,0xe
    80002064:	60868693          	addi	a3,a3,1544 # 80010668 <p_control+0x40>
    p_control.head_priority[i] = NULL;
    80002068:	0007b023          	sd	zero,0(a5)
    p_control.present[i] = 0;
    8000206c:	00072023          	sw	zero,0(a4)
    p_control.current_priority[i] = NULL;
    80002070:	0207b423          	sd	zero,40(a5)
  for(int i = 0;i < MAXPRIORITY; i++){
    80002074:	07a1                	addi	a5,a5,8
    80002076:	0711                	addi	a4,a4,4
    80002078:	fed798e3          	bne	a5,a3,80002068 <init_priority_control+0x34>
  }
}
    8000207c:	60a2                	ld	ra,8(sp)
    8000207e:	6402                	ld	s0,0(sp)
    80002080:	0141                	addi	sp,sp,16
    80002082:	8082                	ret

0000000080002084 <set_priority>:

void set_priority(int priority, struct proc *process){
  if((priority > MAXPRIORITY) || (priority < 0) )
    80002084:	4795                	li	a5,5
    80002086:	00a7e563          	bltu	a5,a0,80002090 <set_priority+0xc>
    panic("Priority nos alowed");

  process->priority = priority;
    8000208a:	16a5a823          	sw	a0,368(a1)
    8000208e:	8082                	ret
void set_priority(int priority, struct proc *process){
    80002090:	1141                	addi	sp,sp,-16
    80002092:	e406                	sd	ra,8(sp)
    80002094:	e022                	sd	s0,0(sp)
    80002096:	0800                	addi	s0,sp,16
    panic("Priority nos alowed");
    80002098:	00005517          	auipc	a0,0x5
    8000209c:	1f850513          	addi	a0,a0,504 # 80007290 <etext+0x290>
    800020a0:	ef4fe0ef          	jal	80000794 <panic>

00000000800020a4 <add_process_priority>:

}

//should be called with the lock 
//iterates through linked list to add an element
void add_process_priority(struct proc *p, int priority){
    800020a4:	1141                	addi	sp,sp,-16
    800020a6:	e422                	sd	s0,8(sp)
    800020a8:	0800                	addi	s0,sp,16
  struct proc *aux_p;
  //check if lock held

  if(p_control.head_priority[priority] == NULL){
    800020aa:	00258713          	addi	a4,a1,2
    800020ae:	070e                	slli	a4,a4,0x3
    800020b0:	0000f797          	auipc	a5,0xf
    800020b4:	9b078793          	addi	a5,a5,-1616 # 80010a60 <bcache+0x3b8>
    800020b8:	97ba                	add	a5,a5,a4
    800020ba:	bd07b783          	ld	a5,-1072(a5)
    800020be:	cb91                	beqz	a5,800020d2 <add_process_priority+0x2e>
    p_control.head_priority[priority] = p;
  }
  else{
    aux_p = p_control.head_priority[priority];
    while(aux_p->next_p_priority != NULL){
    800020c0:	873e                	mv	a4,a5
    800020c2:	1787b783          	ld	a5,376(a5)
    800020c6:	ffed                	bnez	a5,800020c0 <add_process_priority+0x1c>
      aux_p = aux_p->next_p_priority;
    }
    aux_p->next_p_priority = p;
    800020c8:	16a73c23          	sd	a0,376(a4)
  }

}
    800020cc:	6422                	ld	s0,8(sp)
    800020ce:	0141                	addi	sp,sp,16
    800020d0:	8082                	ret
    p_control.head_priority[priority] = p;
    800020d2:	0000f797          	auipc	a5,0xf
    800020d6:	98e78793          	addi	a5,a5,-1650 # 80010a60 <bcache+0x3b8>
    800020da:	97ba                	add	a5,a5,a4
    800020dc:	bca7b823          	sd	a0,-1072(a5)
    800020e0:	b7f5                	j	800020cc <add_process_priority+0x28>

00000000800020e2 <allocproc>:
{
    800020e2:	7179                	addi	sp,sp,-48
    800020e4:	f406                	sd	ra,40(sp)
    800020e6:	f022                	sd	s0,32(sp)
    800020e8:	ec26                	sd	s1,24(sp)
    800020ea:	e84a                	sd	s2,16(sp)
    800020ec:	e44e                	sd	s3,8(sp)
    800020ee:	1800                	addi	s0,sp,48
    800020f0:	89aa                	mv	s3,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800020f2:	0000e497          	auipc	s1,0xe
    800020f6:	96e48493          	addi	s1,s1,-1682 # 8000fa60 <proc>
    800020fa:	0000e917          	auipc	s2,0xe
    800020fe:	0e690913          	addi	s2,s2,230 # 800101e0 <pid_lock>
    acquire(&p->lock);
    80002102:	8526                	mv	a0,s1
    80002104:	af3fe0ef          	jal	80000bf6 <acquire>
    if(p->state == UNUSED) {
    80002108:	4c9c                	lw	a5,24(s1)
    8000210a:	c38d                	beqz	a5,8000212c <allocproc+0x4a>
      release(&p->lock);
    8000210c:	8526                	mv	a0,s1
    8000210e:	b81fe0ef          	jal	80000c8e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002112:	18048493          	addi	s1,s1,384
    80002116:	ff2496e3          	bne	s1,s2,80002102 <allocproc+0x20>
  return 0;
    8000211a:	4481                	li	s1,0
}
    8000211c:	8526                	mv	a0,s1
    8000211e:	70a2                	ld	ra,40(sp)
    80002120:	7402                	ld	s0,32(sp)
    80002122:	64e2                	ld	s1,24(sp)
    80002124:	6942                	ld	s2,16(sp)
    80002126:	69a2                	ld	s3,8(sp)
    80002128:	6145                	addi	sp,sp,48
    8000212a:	8082                	ret
    8000212c:	e052                	sd	s4,0(sp)
  p->pid = allocpid();
    8000212e:	803ff0ef          	jal	80001930 <allocpid>
    80002132:	d888                	sw	a0,48(s1)
  p->state = USED;
    80002134:	4905                	li	s2,1
    80002136:	0124ac23          	sw	s2,24(s1)
  p->trapframe = (struct trapframe*) PROCESS_TRAPFRAME(p - proc);
    8000213a:	0000e797          	auipc	a5,0xe
    8000213e:	92678793          	addi	a5,a5,-1754 # 8000fa60 <proc>
    80002142:	40f487b3          	sub	a5,s1,a5
    80002146:	4077d713          	srai	a4,a5,0x7
    8000214a:	faaab7b7          	lui	a5,0xfaaab
    8000214e:	aab78793          	addi	a5,a5,-1365 # fffffffffaaaaaab <end+0xffffffff7aa8f03b>
    80002152:	07b2                	slli	a5,a5,0xc
    80002154:	aab78793          	addi	a5,a5,-1365
    80002158:	07b2                	slli	a5,a5,0xc
    8000215a:	aab78793          	addi	a5,a5,-1365
    8000215e:	07b2                	slli	a5,a5,0xc
    80002160:	aab78793          	addi	a5,a5,-1365
    80002164:	02f707b3          	mul	a5,a4,a5
    80002168:	6709                	lui	a4,0x2
    8000216a:	070d                	addi	a4,a4,3 # 2003 <_entry-0x7fffdffd>
    8000216c:	97ba                	add	a5,a5,a4
    8000216e:	07ca                	slli	a5,a5,0x12
    80002170:	ee078713          	addi	a4,a5,-288
    80002174:	f0b8                	sd	a4,96(s1)
  p->base_addr =(void *) PROCESS_MEM_BASE(p - proc);
    80002176:	fffc0737          	lui	a4,0xfffc0
    8000217a:	97ba                	add	a5,a5,a4
    8000217c:	ecbc                	sd	a5,88(s1)
  p->priority = priority;
    8000217e:	1734a823          	sw	s3,368(s1)
  acquire(&priority_lock);
    80002182:	0000ea17          	auipc	s4,0xe
    80002186:	48ea0a13          	addi	s4,s4,1166 # 80010610 <priority_lock>
    8000218a:	8552                	mv	a0,s4
    8000218c:	a6bfe0ef          	jal	80000bf6 <acquire>
  p_control.present[priority] = 1;
    80002190:	00299713          	slli	a4,s3,0x2
    80002194:	0000f797          	auipc	a5,0xf
    80002198:	8cc78793          	addi	a5,a5,-1844 # 80010a60 <bcache+0x3b8>
    8000219c:	97ba                	add	a5,a5,a4
    8000219e:	bd27a423          	sw	s2,-1080(a5)
  add_process_priority(p,priority);
    800021a2:	85ce                	mv	a1,s3
    800021a4:	8526                	mv	a0,s1
    800021a6:	effff0ef          	jal	800020a4 <add_process_priority>
  release(&priority_lock);
    800021aa:	8552                	mv	a0,s4
    800021ac:	ae3fe0ef          	jal	80000c8e <release>
  memset(&p->context, 0, sizeof(p->context));
    800021b0:	07000613          	li	a2,112
    800021b4:	4581                	li	a1,0
    800021b6:	06848513          	addi	a0,s1,104
    800021ba:	b11fe0ef          	jal	80000cca <memset>
  p->context.ra = (uint64)forkret;
    800021be:	fffff797          	auipc	a5,0xfffff
    800021c2:	73878793          	addi	a5,a5,1848 # 800018f6 <forkret>
    800021c6:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    800021c8:	60bc                	ld	a5,64(s1)
    800021ca:	6705                	lui	a4,0x1
    800021cc:	97ba                	add	a5,a5,a4
    800021ce:	f8bc                	sd	a5,112(s1)
  return p;
    800021d0:	6a02                	ld	s4,0(sp)
    800021d2:	b7a9                	j	8000211c <allocproc+0x3a>

00000000800021d4 <userinit>:
{
    800021d4:	1101                	addi	sp,sp,-32
    800021d6:	ec06                	sd	ra,24(sp)
    800021d8:	e822                	sd	s0,16(sp)
    800021da:	e426                	sd	s1,8(sp)
    800021dc:	1000                	addi	s0,sp,32
  p = allocproc(2);
    800021de:	4509                	li	a0,2
    800021e0:	f03ff0ef          	jal	800020e2 <allocproc>
    800021e4:	84aa                	mv	s1,a0
  initproc = p;
    800021e6:	00005797          	auipc	a5,0x5
    800021ea:	74a7b123          	sd	a0,1858(a5) # 80007928 <initproc>
  memset(p->base_addr, 0, PGSIZE);
    800021ee:	6605                	lui	a2,0x1
    800021f0:	4581                	li	a1,0
    800021f2:	6d28                	ld	a0,88(a0)
    800021f4:	ad7fe0ef          	jal	80000cca <memset>
  memmove(p->base_addr, initcode, sizeof(initcode));
    800021f8:	03400613          	li	a2,52
    800021fc:	00005597          	auipc	a1,0x5
    80002200:	6c458593          	addi	a1,a1,1732 # 800078c0 <initcode>
    80002204:	6ca8                	ld	a0,88(s1)
    80002206:	b21fe0ef          	jal	80000d26 <memmove>
  p->sz = PGSIZE;
    8000220a:	6785                	lui	a5,0x1
    8000220c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000220e:	70b8                	ld	a4,96(s1)
    80002210:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80002214:	70b8                	ld	a4,96(s1)
    80002216:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002218:	4641                	li	a2,16
    8000221a:	00005597          	auipc	a1,0x5
    8000221e:	08e58593          	addi	a1,a1,142 # 800072a8 <etext+0x2a8>
    80002222:	16048513          	addi	a0,s1,352
    80002226:	be3fe0ef          	jal	80000e08 <safestrcpy>
  p->cwd = namei("/");
    8000222a:	00005517          	auipc	a0,0x5
    8000222e:	08e50513          	addi	a0,a0,142 # 800072b8 <etext+0x2b8>
    80002232:	7da010ef          	jal	80003a0c <namei>
    80002236:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    8000223a:	478d                	li	a5,3
    8000223c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000223e:	8526                	mv	a0,s1
    80002240:	a4ffe0ef          	jal	80000c8e <release>
}
    80002244:	60e2                	ld	ra,24(sp)
    80002246:	6442                	ld	s0,16(sp)
    80002248:	64a2                	ld	s1,8(sp)
    8000224a:	6105                	addi	sp,sp,32
    8000224c:	8082                	ret

000000008000224e <fork>:
{
    8000224e:	7139                	addi	sp,sp,-64
    80002250:	fc06                	sd	ra,56(sp)
    80002252:	f822                	sd	s0,48(sp)
    80002254:	f04a                	sd	s2,32(sp)
    80002256:	e456                	sd	s5,8(sp)
    80002258:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000225a:	e6aff0ef          	jal	800018c4 <myproc>
    8000225e:	8aaa                	mv	s5,a0
  if((np = allocproc(p->priority)) == 0){
    80002260:	17052503          	lw	a0,368(a0)
    80002264:	e7fff0ef          	jal	800020e2 <allocproc>
    80002268:	10050b63          	beqz	a0,8000237e <fork+0x130>
    8000226c:	ec4e                	sd	s3,24(sp)
    8000226e:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80002270:	048ab603          	ld	a2,72(s5)
    80002274:	692c                	ld	a1,80(a0)
    80002276:	050ab503          	ld	a0,80(s5)
    8000227a:	9d2ff0ef          	jal	8000144c <uvmcopy>
    8000227e:	04054a63          	bltz	a0,800022d2 <fork+0x84>
    80002282:	f426                	sd	s1,40(sp)
    80002284:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80002286:	048ab783          	ld	a5,72(s5)
    8000228a:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000228e:	060ab683          	ld	a3,96(s5)
    80002292:	87b6                	mv	a5,a3
    80002294:	0609b703          	ld	a4,96(s3)
    80002298:	12068693          	addi	a3,a3,288
    8000229c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800022a0:	6788                	ld	a0,8(a5)
    800022a2:	6b8c                	ld	a1,16(a5)
    800022a4:	6f90                	ld	a2,24(a5)
    800022a6:	01073023          	sd	a6,0(a4)
    800022aa:	e708                	sd	a0,8(a4)
    800022ac:	eb0c                	sd	a1,16(a4)
    800022ae:	ef10                	sd	a2,24(a4)
    800022b0:	02078793          	addi	a5,a5,32
    800022b4:	02070713          	addi	a4,a4,32
    800022b8:	fed792e3          	bne	a5,a3,8000229c <fork+0x4e>
  np->trapframe->a0 = 0;
    800022bc:	0609b783          	ld	a5,96(s3)
    800022c0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800022c4:	0d8a8493          	addi	s1,s5,216
    800022c8:	0d898913          	addi	s2,s3,216
    800022cc:	158a8a13          	addi	s4,s5,344
    800022d0:	a83d                	j	8000230e <fork+0xc0>
  p->trapframe = 0;
    800022d2:	0609b023          	sd	zero,96(s3)
  p->base_addr = 0;
    800022d6:	0409bc23          	sd	zero,88(s3)
  p->sz = 0;
    800022da:	0409b423          	sd	zero,72(s3)
  p->pid = 0;
    800022de:	0209a823          	sw	zero,48(s3)
  p->parent = 0;
    800022e2:	0209bc23          	sd	zero,56(s3)
  p->name[0] = 0;
    800022e6:	16098023          	sb	zero,352(s3)
  p->chan = 0;
    800022ea:	0209b023          	sd	zero,32(s3)
  p->killed = 0;
    800022ee:	0209a423          	sw	zero,40(s3)
  p->xstate = 0;
    800022f2:	0209a623          	sw	zero,44(s3)
  p->state = UNUSED;
    800022f6:	0009ac23          	sw	zero,24(s3)
    release(&np->lock);
    800022fa:	854e                	mv	a0,s3
    800022fc:	993fe0ef          	jal	80000c8e <release>
    return -1;
    80002300:	597d                	li	s2,-1
    80002302:	69e2                	ld	s3,24(sp)
    80002304:	a0b5                	j	80002370 <fork+0x122>
  for(i = 0; i < NOFILE; i++)
    80002306:	04a1                	addi	s1,s1,8
    80002308:	0921                	addi	s2,s2,8
    8000230a:	01448963          	beq	s1,s4,8000231c <fork+0xce>
    if(p->ofile[i])
    8000230e:	6088                	ld	a0,0(s1)
    80002310:	d97d                	beqz	a0,80002306 <fork+0xb8>
      np->ofile[i] = filedup(p->ofile[i]);
    80002312:	48b010ef          	jal	80003f9c <filedup>
    80002316:	00a93023          	sd	a0,0(s2)
    8000231a:	b7f5                	j	80002306 <fork+0xb8>
  np->cwd = idup(p->cwd);
    8000231c:	158ab503          	ld	a0,344(s5)
    80002320:	7dd000ef          	jal	800032fc <idup>
    80002324:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002328:	4641                	li	a2,16
    8000232a:	160a8593          	addi	a1,s5,352
    8000232e:	16098513          	addi	a0,s3,352
    80002332:	ad7fe0ef          	jal	80000e08 <safestrcpy>
  pid = np->pid;
    80002336:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000233a:	854e                	mv	a0,s3
    8000233c:	953fe0ef          	jal	80000c8e <release>
  acquire(&wait_lock);
    80002340:	0000e497          	auipc	s1,0xe
    80002344:	eb848493          	addi	s1,s1,-328 # 800101f8 <wait_lock>
    80002348:	8526                	mv	a0,s1
    8000234a:	8adfe0ef          	jal	80000bf6 <acquire>
  np->parent = p;
    8000234e:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80002352:	8526                	mv	a0,s1
    80002354:	93bfe0ef          	jal	80000c8e <release>
  acquire(&np->lock);
    80002358:	854e                	mv	a0,s3
    8000235a:	89dfe0ef          	jal	80000bf6 <acquire>
  np->state = RUNNABLE;
    8000235e:	478d                	li	a5,3
    80002360:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002364:	854e                	mv	a0,s3
    80002366:	929fe0ef          	jal	80000c8e <release>
  return pid;
    8000236a:	74a2                	ld	s1,40(sp)
    8000236c:	69e2                	ld	s3,24(sp)
    8000236e:	6a42                	ld	s4,16(sp)
}
    80002370:	854a                	mv	a0,s2
    80002372:	70e2                	ld	ra,56(sp)
    80002374:	7442                	ld	s0,48(sp)
    80002376:	7902                	ld	s2,32(sp)
    80002378:	6aa2                	ld	s5,8(sp)
    8000237a:	6121                	addi	sp,sp,64
    8000237c:	8082                	ret
    return -1;
    8000237e:	597d                	li	s2,-1
    80002380:	bfc5                	j	80002370 <fork+0x122>

0000000080002382 <free_process_priority>:

//rearanges the control structure
//updating the linked list
int free_process_priority(struct proc *p){
    80002382:	1141                	addi	sp,sp,-16
    80002384:	e422                	sd	s0,8(sp)
    80002386:	0800                	addi	s0,sp,16

  struct proc *p_aux;

  p_aux = p_control.head_priority[p->priority];
    80002388:	17052703          	lw	a4,368(a0)
    8000238c:	02071693          	slli	a3,a4,0x20
    80002390:	01d6d793          	srli	a5,a3,0x1d
    80002394:	0000e697          	auipc	a3,0xe
    80002398:	6dc68693          	addi	a3,a3,1756 # 80010a70 <bcache+0x3c8>
    8000239c:	97b6                	add	a5,a5,a3
    8000239e:	bd07b783          	ld	a5,-1072(a5)

  if(p_aux == p){
    800023a2:	02f50163          	beq	a0,a5,800023c4 <free_process_priority+0x42>
      p_control.head_priority[p->priority] = p->next_p_priority;  
      p->next_p_priority = NULL;
    }
  }
  else{
    while(p_aux->next_p_priority != p){
    800023a6:	873e                	mv	a4,a5
    800023a8:	1787b783          	ld	a5,376(a5)
    800023ac:	fea79de3          	bne	a5,a0,800023a6 <free_process_priority+0x24>
      p_aux = p_aux->next_p_priority;
    }
    p_aux->next_p_priority = p->next_p_priority;
    800023b0:	17853783          	ld	a5,376(a0)
    800023b4:	16f73c23          	sd	a5,376(a4)
    p->next_p_priority = NULL;
    800023b8:	16053c23          	sd	zero,376(a0)
  }
  
  return 0;
}
    800023bc:	4501                	li	a0,0
    800023be:	6422                	ld	s0,8(sp)
    800023c0:	0141                	addi	sp,sp,16
    800023c2:	8082                	ret
    if(p->next_p_priority == NULL){
    800023c4:	1787b683          	ld	a3,376(a5)
    800023c8:	ce99                	beqz	a3,800023e6 <free_process_priority+0x64>
      p_control.head_priority[p->priority] = p->next_p_priority;  
    800023ca:	02071613          	slli	a2,a4,0x20
    800023ce:	01d65713          	srli	a4,a2,0x1d
    800023d2:	0000e617          	auipc	a2,0xe
    800023d6:	69e60613          	addi	a2,a2,1694 # 80010a70 <bcache+0x3c8>
    800023da:	9732                	add	a4,a4,a2
    800023dc:	bcd73823          	sd	a3,-1072(a4)
      p->next_p_priority = NULL;
    800023e0:	1607bc23          	sd	zero,376(a5)
    800023e4:	bfe1                	j	800023bc <free_process_priority+0x3a>
      p_control.present[p->priority] = 0;
    800023e6:	0000e697          	auipc	a3,0xe
    800023ea:	67a68693          	addi	a3,a3,1658 # 80010a60 <bcache+0x3b8>
    800023ee:	1702                	slli	a4,a4,0x20
    800023f0:	9301                	srli	a4,a4,0x20
    800023f2:	00271793          	slli	a5,a4,0x2
    800023f6:	97b6                	add	a5,a5,a3
    800023f8:	bc07a423          	sw	zero,-1080(a5)
      p_control.head_priority[p->priority] = NULL;
    800023fc:	0709                	addi	a4,a4,2
    800023fe:	00371793          	slli	a5,a4,0x3
    80002402:	96be                	add	a3,a3,a5
    80002404:	bc06b823          	sd	zero,-1072(a3)
    80002408:	bf55                	j	800023bc <free_process_priority+0x3a>

000000008000240a <exit>:
{
    8000240a:	7179                	addi	sp,sp,-48
    8000240c:	f406                	sd	ra,40(sp)
    8000240e:	f022                	sd	s0,32(sp)
    80002410:	ec26                	sd	s1,24(sp)
    80002412:	e84a                	sd	s2,16(sp)
    80002414:	e44e                	sd	s3,8(sp)
    80002416:	e052                	sd	s4,0(sp)
    80002418:	1800                	addi	s0,sp,48
    8000241a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000241c:	ca8ff0ef          	jal	800018c4 <myproc>
    80002420:	89aa                	mv	s3,a0
  if(p == initproc)
    80002422:	00005797          	auipc	a5,0x5
    80002426:	5067b783          	ld	a5,1286(a5) # 80007928 <initproc>
    8000242a:	0d850493          	addi	s1,a0,216
    8000242e:	15850913          	addi	s2,a0,344
    80002432:	00a79f63          	bne	a5,a0,80002450 <exit+0x46>
    panic("init exiting");
    80002436:	00005517          	auipc	a0,0x5
    8000243a:	e8a50513          	addi	a0,a0,-374 # 800072c0 <etext+0x2c0>
    8000243e:	b56fe0ef          	jal	80000794 <panic>
      fileclose(f);
    80002442:	3a1010ef          	jal	80003fe2 <fileclose>
      p->ofile[fd] = 0;
    80002446:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000244a:	04a1                	addi	s1,s1,8
    8000244c:	01248563          	beq	s1,s2,80002456 <exit+0x4c>
    if(p->ofile[fd]){
    80002450:	6088                	ld	a0,0(s1)
    80002452:	f965                	bnez	a0,80002442 <exit+0x38>
    80002454:	bfdd                	j	8000244a <exit+0x40>
  begin_op();
    80002456:	772010ef          	jal	80003bc8 <begin_op>
  iput(p->cwd);
    8000245a:	1589b503          	ld	a0,344(s3)
    8000245e:	056010ef          	jal	800034b4 <iput>
  end_op();
    80002462:	7d0010ef          	jal	80003c32 <end_op>
  p->cwd = 0;
    80002466:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    8000246a:	0000e497          	auipc	s1,0xe
    8000246e:	d8e48493          	addi	s1,s1,-626 # 800101f8 <wait_lock>
    80002472:	8526                	mv	a0,s1
    80002474:	f82fe0ef          	jal	80000bf6 <acquire>
  reparent(p);
    80002478:	854e                	mv	a0,s3
    8000247a:	85fff0ef          	jal	80001cd8 <reparent>
  wakeup(p->parent);
    8000247e:	0389b503          	ld	a0,56(s3)
    80002482:	ff2ff0ef          	jal	80001c74 <wakeup>
  acquire(&p->lock);
    80002486:	854e                	mv	a0,s3
    80002488:	f6efe0ef          	jal	80000bf6 <acquire>
  p->xstate = status;
    8000248c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002490:	4795                	li	a5,5
    80002492:	00f9ac23          	sw	a5,24(s3)
  acquire(&priority_lock);
    80002496:	0000e917          	auipc	s2,0xe
    8000249a:	17a90913          	addi	s2,s2,378 # 80010610 <priority_lock>
    8000249e:	854a                	mv	a0,s2
    800024a0:	f56fe0ef          	jal	80000bf6 <acquire>
  free_process_priority(p);
    800024a4:	854e                	mv	a0,s3
    800024a6:	eddff0ef          	jal	80002382 <free_process_priority>
  release(&priority_lock);
    800024aa:	854a                	mv	a0,s2
    800024ac:	fe2fe0ef          	jal	80000c8e <release>
  release(&wait_lock);
    800024b0:	8526                	mv	a0,s1
    800024b2:	fdcfe0ef          	jal	80000c8e <release>
  sched();
    800024b6:	e7eff0ef          	jal	80001b34 <sched>
  panic("zombie exit");
    800024ba:	00005517          	auipc	a0,0x5
    800024be:	e1650513          	addi	a0,a0,-490 # 800072d0 <etext+0x2d0>
    800024c2:	ad2fe0ef          	jal	80000794 <panic>

00000000800024c6 <swtch>:
    800024c6:	00153023          	sd	ra,0(a0)
    800024ca:	00253423          	sd	sp,8(a0)
    800024ce:	e900                	sd	s0,16(a0)
    800024d0:	ed04                	sd	s1,24(a0)
    800024d2:	03253023          	sd	s2,32(a0)
    800024d6:	03353423          	sd	s3,40(a0)
    800024da:	03453823          	sd	s4,48(a0)
    800024de:	03553c23          	sd	s5,56(a0)
    800024e2:	05653023          	sd	s6,64(a0)
    800024e6:	05753423          	sd	s7,72(a0)
    800024ea:	05853823          	sd	s8,80(a0)
    800024ee:	05953c23          	sd	s9,88(a0)
    800024f2:	07a53023          	sd	s10,96(a0)
    800024f6:	07b53423          	sd	s11,104(a0)
    800024fa:	0005b083          	ld	ra,0(a1)
    800024fe:	0085b103          	ld	sp,8(a1)
    80002502:	6980                	ld	s0,16(a1)
    80002504:	6d84                	ld	s1,24(a1)
    80002506:	0205b903          	ld	s2,32(a1)
    8000250a:	0285b983          	ld	s3,40(a1)
    8000250e:	0305ba03          	ld	s4,48(a1)
    80002512:	0385ba83          	ld	s5,56(a1)
    80002516:	0405bb03          	ld	s6,64(a1)
    8000251a:	0485bb83          	ld	s7,72(a1)
    8000251e:	0505bc03          	ld	s8,80(a1)
    80002522:	0585bc83          	ld	s9,88(a1)
    80002526:	0605bd03          	ld	s10,96(a1)
    8000252a:	0685bd83          	ld	s11,104(a1)
    8000252e:	8082                	ret

0000000080002530 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002530:	1141                	addi	sp,sp,-16
    80002532:	e406                	sd	ra,8(sp)
    80002534:	e022                	sd	s0,0(sp)
    80002536:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002538:	00005597          	auipc	a1,0x5
    8000253c:	dd858593          	addi	a1,a1,-552 # 80007310 <etext+0x310>
    80002540:	0000e517          	auipc	a0,0xe
    80002544:	15050513          	addi	a0,a0,336 # 80010690 <tickslock>
    80002548:	e2efe0ef          	jal	80000b76 <initlock>
}
    8000254c:	60a2                	ld	ra,8(sp)
    8000254e:	6402                	ld	s0,0(sp)
    80002550:	0141                	addi	sp,sp,16
    80002552:	8082                	ret

0000000080002554 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002554:	1141                	addi	sp,sp,-16
    80002556:	e422                	sd	s0,8(sp)
    80002558:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000255a:	00003797          	auipc	a5,0x3
    8000255e:	df678793          	addi	a5,a5,-522 # 80005350 <kernelvec>
    80002562:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002566:	6422                	ld	s0,8(sp)
    80002568:	0141                	addi	sp,sp,16
    8000256a:	8082                	ret

000000008000256c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000256c:	1141                	addi	sp,sp,-16
    8000256e:	e406                	sd	ra,8(sp)
    80002570:	e022                	sd	s0,0(sp)
    80002572:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002574:	b50ff0ef          	jal	800018c4 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002578:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000257c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000257e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002582:	00004697          	auipc	a3,0x4
    80002586:	a7e68693          	addi	a3,a3,-1410 # 80006000 <_trampoline>
    8000258a:	00004717          	auipc	a4,0x4
    8000258e:	a7670713          	addi	a4,a4,-1418 # 80006000 <_trampoline>
    80002592:	8f15                	sub	a4,a4,a3
    80002594:	000a07b7          	lui	a5,0xa0
    80002598:	17fd                	addi	a5,a5,-1 # 9ffff <_entry-0x7ff60001>
    8000259a:	07b2                	slli	a5,a5,0xc
    8000259c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000259e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800025a2:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800025a4:	18002673          	csrr	a2,satp
    800025a8:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800025aa:	7130                	ld	a2,96(a0)
    800025ac:	6138                	ld	a4,64(a0)
    800025ae:	6585                	lui	a1,0x1
    800025b0:	972e                	add	a4,a4,a1
    800025b2:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800025b4:	7138                	ld	a4,96(a0)
    800025b6:	00000617          	auipc	a2,0x0
    800025ba:	11460613          	addi	a2,a2,276 # 800026ca <usertrap>
    800025be:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800025c0:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800025c2:	8612                	mv	a2,tp
    800025c4:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025c6:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800025ca:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800025ce:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025d2:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800025d6:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800025d8:	6f18                	ld	a4,24(a4)
    800025da:	14171073          	csrw	sepc,a4
  uint64 satp = 0;//MAKE_SATP(p->pagetable);

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800025de:	00004717          	auipc	a4,0x4
    800025e2:	abc70713          	addi	a4,a4,-1348 # 8000609a <userret>
    800025e6:	8f15                	sub	a4,a4,a3
    800025e8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800025ea:	4501                	li	a0,0
    800025ec:	9782                	jalr	a5
}
    800025ee:	60a2                	ld	ra,8(sp)
    800025f0:	6402                	ld	s0,0(sp)
    800025f2:	0141                	addi	sp,sp,16
    800025f4:	8082                	ret

00000000800025f6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800025f6:	1101                	addi	sp,sp,-32
    800025f8:	ec06                	sd	ra,24(sp)
    800025fa:	e822                	sd	s0,16(sp)
    800025fc:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800025fe:	a9aff0ef          	jal	80001898 <cpuid>
    80002602:	c505                	beqz	a0,8000262a <clockintr+0x34>
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  printf("Timer\n");
    80002604:	00005517          	auipc	a0,0x5
    80002608:	d1450513          	addi	a0,a0,-748 # 80007318 <etext+0x318>
    8000260c:	eb7fd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002610:	c01027f3          	rdtime	a5
  w_stimecmp(r_time() + 1000000);
    80002614:	000f4737          	lui	a4,0xf4
    80002618:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000261c:	97ba                	add	a5,a5,a4
  asm volatile("csrw stimecmp, %0" : : "r" (x));
    8000261e:	14d79073          	csrw	stimecmp,a5
}
    80002622:	60e2                	ld	ra,24(sp)
    80002624:	6442                	ld	s0,16(sp)
    80002626:	6105                	addi	sp,sp,32
    80002628:	8082                	ret
    8000262a:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000262c:	0000e497          	auipc	s1,0xe
    80002630:	06448493          	addi	s1,s1,100 # 80010690 <tickslock>
    80002634:	8526                	mv	a0,s1
    80002636:	dc0fe0ef          	jal	80000bf6 <acquire>
    ticks++;
    8000263a:	00005517          	auipc	a0,0x5
    8000263e:	2f650513          	addi	a0,a0,758 # 80007930 <ticks>
    80002642:	411c                	lw	a5,0(a0)
    80002644:	2785                	addiw	a5,a5,1
    80002646:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002648:	e2cff0ef          	jal	80001c74 <wakeup>
    release(&tickslock);
    8000264c:	8526                	mv	a0,s1
    8000264e:	e40fe0ef          	jal	80000c8e <release>
    80002652:	64a2                	ld	s1,8(sp)
    80002654:	bf45                	j	80002604 <clockintr+0xe>

0000000080002656 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002656:	1101                	addi	sp,sp,-32
    80002658:	ec06                	sd	ra,24(sp)
    8000265a:	e822                	sd	s0,16(sp)
    8000265c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000265e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002662:	57fd                	li	a5,-1
    80002664:	17fe                	slli	a5,a5,0x3f
    80002666:	07a5                	addi	a5,a5,9
    80002668:	00f70c63          	beq	a4,a5,80002680 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000266c:	57fd                	li	a5,-1
    8000266e:	17fe                	slli	a5,a5,0x3f
    80002670:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002672:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002674:	04f70763          	beq	a4,a5,800026c2 <devintr+0x6c>
  }
}
    80002678:	60e2                	ld	ra,24(sp)
    8000267a:	6442                	ld	s0,16(sp)
    8000267c:	6105                	addi	sp,sp,32
    8000267e:	8082                	ret
    80002680:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002682:	57b020ef          	jal	800053fc <plic_claim>
    80002686:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002688:	47a9                	li	a5,10
    8000268a:	00f50963          	beq	a0,a5,8000269c <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    8000268e:	4785                	li	a5,1
    80002690:	00f50963          	beq	a0,a5,800026a2 <devintr+0x4c>
    return 1;
    80002694:	4505                	li	a0,1
    } else if(irq){
    80002696:	e889                	bnez	s1,800026a8 <devintr+0x52>
    80002698:	64a2                	ld	s1,8(sp)
    8000269a:	bff9                	j	80002678 <devintr+0x22>
      uartintr();
    8000269c:	b6afe0ef          	jal	80000a06 <uartintr>
    if(irq)
    800026a0:	a819                	j	800026b6 <devintr+0x60>
      virtio_disk_intr();
    800026a2:	220030ef          	jal	800058c2 <virtio_disk_intr>
    if(irq)
    800026a6:	a801                	j	800026b6 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800026a8:	85a6                	mv	a1,s1
    800026aa:	00005517          	auipc	a0,0x5
    800026ae:	c7650513          	addi	a0,a0,-906 # 80007320 <etext+0x320>
    800026b2:	e11fd0ef          	jal	800004c2 <printf>
      plic_complete(irq);
    800026b6:	8526                	mv	a0,s1
    800026b8:	565020ef          	jal	8000541c <plic_complete>
    return 1;
    800026bc:	4505                	li	a0,1
    800026be:	64a2                	ld	s1,8(sp)
    800026c0:	bf65                	j	80002678 <devintr+0x22>
    clockintr();
    800026c2:	f35ff0ef          	jal	800025f6 <clockintr>
    return 2;
    800026c6:	4509                	li	a0,2
    800026c8:	bf45                	j	80002678 <devintr+0x22>

00000000800026ca <usertrap>:
{
    800026ca:	1101                	addi	sp,sp,-32
    800026cc:	ec06                	sd	ra,24(sp)
    800026ce:	e822                	sd	s0,16(sp)
    800026d0:	e426                	sd	s1,8(sp)
    800026d2:	e04a                	sd	s2,0(sp)
    800026d4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026d6:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800026da:	1007f793          	andi	a5,a5,256
    800026de:	ef85                	bnez	a5,80002716 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026e0:	00003797          	auipc	a5,0x3
    800026e4:	c7078793          	addi	a5,a5,-912 # 80005350 <kernelvec>
    800026e8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800026ec:	9d8ff0ef          	jal	800018c4 <myproc>
    800026f0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800026f2:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026f4:	14102773          	csrr	a4,sepc
    800026f8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026fa:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800026fe:	47a1                	li	a5,8
    80002700:	02f70163          	beq	a4,a5,80002722 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80002704:	f53ff0ef          	jal	80002656 <devintr>
    80002708:	892a                	mv	s2,a0
    8000270a:	c135                	beqz	a0,8000276e <usertrap+0xa4>
  if(killed(p))
    8000270c:	8526                	mv	a0,s1
    8000270e:	ea2ff0ef          	jal	80001db0 <killed>
    80002712:	cd1d                	beqz	a0,80002750 <usertrap+0x86>
    80002714:	a81d                	j	8000274a <usertrap+0x80>
    panic("usertrap: not from user mode");
    80002716:	00005517          	auipc	a0,0x5
    8000271a:	c2a50513          	addi	a0,a0,-982 # 80007340 <etext+0x340>
    8000271e:	876fe0ef          	jal	80000794 <panic>
    if(killed(p))
    80002722:	e8eff0ef          	jal	80001db0 <killed>
    80002726:	e121                	bnez	a0,80002766 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80002728:	70b8                	ld	a4,96(s1)
    8000272a:	6f1c                	ld	a5,24(a4)
    8000272c:	0791                	addi	a5,a5,4
    8000272e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002730:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002734:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002738:	10079073          	csrw	sstatus,a5
    syscall();
    8000273c:	248000ef          	jal	80002984 <syscall>
  if(killed(p))
    80002740:	8526                	mv	a0,s1
    80002742:	e6eff0ef          	jal	80001db0 <killed>
    80002746:	c901                	beqz	a0,80002756 <usertrap+0x8c>
    80002748:	4901                	li	s2,0
    exit(-1);
    8000274a:	557d                	li	a0,-1
    8000274c:	cbfff0ef          	jal	8000240a <exit>
  if(which_dev == 2)
    80002750:	4789                	li	a5,2
    80002752:	04f90563          	beq	s2,a5,8000279c <usertrap+0xd2>
  usertrapret();
    80002756:	e17ff0ef          	jal	8000256c <usertrapret>
}
    8000275a:	60e2                	ld	ra,24(sp)
    8000275c:	6442                	ld	s0,16(sp)
    8000275e:	64a2                	ld	s1,8(sp)
    80002760:	6902                	ld	s2,0(sp)
    80002762:	6105                	addi	sp,sp,32
    80002764:	8082                	ret
      exit(-1);
    80002766:	557d                	li	a0,-1
    80002768:	ca3ff0ef          	jal	8000240a <exit>
    8000276c:	bf75                	j	80002728 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000276e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002772:	5890                	lw	a2,48(s1)
    80002774:	00005517          	auipc	a0,0x5
    80002778:	bec50513          	addi	a0,a0,-1044 # 80007360 <etext+0x360>
    8000277c:	d47fd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002780:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002784:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002788:	00005517          	auipc	a0,0x5
    8000278c:	c0850513          	addi	a0,a0,-1016 # 80007390 <etext+0x390>
    80002790:	d33fd0ef          	jal	800004c2 <printf>
    setkilled(p);
    80002794:	8526                	mv	a0,s1
    80002796:	df6ff0ef          	jal	80001d8c <setkilled>
    8000279a:	b75d                	j	80002740 <usertrap+0x76>
    yield();
    8000279c:	c60ff0ef          	jal	80001bfc <yield>
    800027a0:	bf5d                	j	80002756 <usertrap+0x8c>

00000000800027a2 <kerneltrap>:
{
    800027a2:	7179                	addi	sp,sp,-48
    800027a4:	f406                	sd	ra,40(sp)
    800027a6:	f022                	sd	s0,32(sp)
    800027a8:	ec26                	sd	s1,24(sp)
    800027aa:	e84a                	sd	s2,16(sp)
    800027ac:	e44e                	sd	s3,8(sp)
    800027ae:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027b0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027b4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027b8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800027bc:	1004f793          	andi	a5,s1,256
    800027c0:	c795                	beqz	a5,800027ec <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027c2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800027c6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800027c8:	eb85                	bnez	a5,800027f8 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    800027ca:	e8dff0ef          	jal	80002656 <devintr>
    800027ce:	c91d                	beqz	a0,80002804 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    800027d0:	4789                	li	a5,2
    800027d2:	04f50a63          	beq	a0,a5,80002826 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800027d6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027da:	10049073          	csrw	sstatus,s1
}
    800027de:	70a2                	ld	ra,40(sp)
    800027e0:	7402                	ld	s0,32(sp)
    800027e2:	64e2                	ld	s1,24(sp)
    800027e4:	6942                	ld	s2,16(sp)
    800027e6:	69a2                	ld	s3,8(sp)
    800027e8:	6145                	addi	sp,sp,48
    800027ea:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800027ec:	00005517          	auipc	a0,0x5
    800027f0:	bcc50513          	addi	a0,a0,-1076 # 800073b8 <etext+0x3b8>
    800027f4:	fa1fd0ef          	jal	80000794 <panic>
    panic("kerneltrap: interrupts enabled");
    800027f8:	00005517          	auipc	a0,0x5
    800027fc:	be850513          	addi	a0,a0,-1048 # 800073e0 <etext+0x3e0>
    80002800:	f95fd0ef          	jal	80000794 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002804:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002808:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    8000280c:	85ce                	mv	a1,s3
    8000280e:	00005517          	auipc	a0,0x5
    80002812:	bf250513          	addi	a0,a0,-1038 # 80007400 <etext+0x400>
    80002816:	cadfd0ef          	jal	800004c2 <printf>
    panic("kerneltrap");
    8000281a:	00005517          	auipc	a0,0x5
    8000281e:	c0e50513          	addi	a0,a0,-1010 # 80007428 <etext+0x428>
    80002822:	f73fd0ef          	jal	80000794 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002826:	89eff0ef          	jal	800018c4 <myproc>
    8000282a:	d555                	beqz	a0,800027d6 <kerneltrap+0x34>
    yield();
    8000282c:	bd0ff0ef          	jal	80001bfc <yield>
    80002830:	b75d                	j	800027d6 <kerneltrap+0x34>

0000000080002832 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002832:	1101                	addi	sp,sp,-32
    80002834:	ec06                	sd	ra,24(sp)
    80002836:	e822                	sd	s0,16(sp)
    80002838:	e426                	sd	s1,8(sp)
    8000283a:	1000                	addi	s0,sp,32
    8000283c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000283e:	886ff0ef          	jal	800018c4 <myproc>
  switch (n) {
    80002842:	4795                	li	a5,5
    80002844:	0497e163          	bltu	a5,s1,80002886 <argraw+0x54>
    80002848:	048a                	slli	s1,s1,0x2
    8000284a:	00005717          	auipc	a4,0x5
    8000284e:	f9e70713          	addi	a4,a4,-98 # 800077e8 <states.0+0x30>
    80002852:	94ba                	add	s1,s1,a4
    80002854:	409c                	lw	a5,0(s1)
    80002856:	97ba                	add	a5,a5,a4
    80002858:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000285a:	713c                	ld	a5,96(a0)
    8000285c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000285e:	60e2                	ld	ra,24(sp)
    80002860:	6442                	ld	s0,16(sp)
    80002862:	64a2                	ld	s1,8(sp)
    80002864:	6105                	addi	sp,sp,32
    80002866:	8082                	ret
    return p->trapframe->a1;
    80002868:	713c                	ld	a5,96(a0)
    8000286a:	7fa8                	ld	a0,120(a5)
    8000286c:	bfcd                	j	8000285e <argraw+0x2c>
    return p->trapframe->a2;
    8000286e:	713c                	ld	a5,96(a0)
    80002870:	63c8                	ld	a0,128(a5)
    80002872:	b7f5                	j	8000285e <argraw+0x2c>
    return p->trapframe->a3;
    80002874:	713c                	ld	a5,96(a0)
    80002876:	67c8                	ld	a0,136(a5)
    80002878:	b7dd                	j	8000285e <argraw+0x2c>
    return p->trapframe->a4;
    8000287a:	713c                	ld	a5,96(a0)
    8000287c:	6bc8                	ld	a0,144(a5)
    8000287e:	b7c5                	j	8000285e <argraw+0x2c>
    return p->trapframe->a5;
    80002880:	713c                	ld	a5,96(a0)
    80002882:	6fc8                	ld	a0,152(a5)
    80002884:	bfe9                	j	8000285e <argraw+0x2c>
  panic("argraw");
    80002886:	00005517          	auipc	a0,0x5
    8000288a:	bb250513          	addi	a0,a0,-1102 # 80007438 <etext+0x438>
    8000288e:	f07fd0ef          	jal	80000794 <panic>

0000000080002892 <fetchaddr>:
{
    80002892:	1101                	addi	sp,sp,-32
    80002894:	ec06                	sd	ra,24(sp)
    80002896:	e822                	sd	s0,16(sp)
    80002898:	e426                	sd	s1,8(sp)
    8000289a:	e04a                	sd	s2,0(sp)
    8000289c:	1000                	addi	s0,sp,32
    8000289e:	84aa                	mv	s1,a0
    800028a0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800028a2:	822ff0ef          	jal	800018c4 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800028a6:	653c                	ld	a5,72(a0)
    800028a8:	02f4f663          	bgeu	s1,a5,800028d4 <fetchaddr+0x42>
    800028ac:	00848713          	addi	a4,s1,8
    800028b0:	02e7e463          	bltu	a5,a4,800028d8 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800028b4:	46a1                	li	a3,8
    800028b6:	8626                	mv	a2,s1
    800028b8:	85ca                	mv	a1,s2
    800028ba:	6928                	ld	a0,80(a0)
    800028bc:	d43fe0ef          	jal	800015fe <copyin>
    800028c0:	00a03533          	snez	a0,a0
    800028c4:	40a00533          	neg	a0,a0
}
    800028c8:	60e2                	ld	ra,24(sp)
    800028ca:	6442                	ld	s0,16(sp)
    800028cc:	64a2                	ld	s1,8(sp)
    800028ce:	6902                	ld	s2,0(sp)
    800028d0:	6105                	addi	sp,sp,32
    800028d2:	8082                	ret
    return -1;
    800028d4:	557d                	li	a0,-1
    800028d6:	bfcd                	j	800028c8 <fetchaddr+0x36>
    800028d8:	557d                	li	a0,-1
    800028da:	b7fd                	j	800028c8 <fetchaddr+0x36>

00000000800028dc <fetchstr>:
{
    800028dc:	7179                	addi	sp,sp,-48
    800028de:	f406                	sd	ra,40(sp)
    800028e0:	f022                	sd	s0,32(sp)
    800028e2:	ec26                	sd	s1,24(sp)
    800028e4:	e84a                	sd	s2,16(sp)
    800028e6:	e44e                	sd	s3,8(sp)
    800028e8:	1800                	addi	s0,sp,48
    800028ea:	892a                	mv	s2,a0
    800028ec:	84ae                	mv	s1,a1
    800028ee:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800028f0:	fd5fe0ef          	jal	800018c4 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800028f4:	86ce                	mv	a3,s3
    800028f6:	864a                	mv	a2,s2
    800028f8:	85a6                	mv	a1,s1
    800028fa:	6928                	ld	a0,80(a0)
    800028fc:	d89fe0ef          	jal	80001684 <copyinstr>
    80002900:	00054c63          	bltz	a0,80002918 <fetchstr+0x3c>
  return strlen(buf);
    80002904:	8526                	mv	a0,s1
    80002906:	d34fe0ef          	jal	80000e3a <strlen>
}
    8000290a:	70a2                	ld	ra,40(sp)
    8000290c:	7402                	ld	s0,32(sp)
    8000290e:	64e2                	ld	s1,24(sp)
    80002910:	6942                	ld	s2,16(sp)
    80002912:	69a2                	ld	s3,8(sp)
    80002914:	6145                	addi	sp,sp,48
    80002916:	8082                	ret
    return -1;
    80002918:	557d                	li	a0,-1
    8000291a:	bfc5                	j	8000290a <fetchstr+0x2e>

000000008000291c <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000291c:	1101                	addi	sp,sp,-32
    8000291e:	ec06                	sd	ra,24(sp)
    80002920:	e822                	sd	s0,16(sp)
    80002922:	e426                	sd	s1,8(sp)
    80002924:	1000                	addi	s0,sp,32
    80002926:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002928:	f0bff0ef          	jal	80002832 <argraw>
    8000292c:	c088                	sw	a0,0(s1)
}
    8000292e:	60e2                	ld	ra,24(sp)
    80002930:	6442                	ld	s0,16(sp)
    80002932:	64a2                	ld	s1,8(sp)
    80002934:	6105                	addi	sp,sp,32
    80002936:	8082                	ret

0000000080002938 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002938:	1101                	addi	sp,sp,-32
    8000293a:	ec06                	sd	ra,24(sp)
    8000293c:	e822                	sd	s0,16(sp)
    8000293e:	e426                	sd	s1,8(sp)
    80002940:	1000                	addi	s0,sp,32
    80002942:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002944:	eefff0ef          	jal	80002832 <argraw>
    80002948:	e088                	sd	a0,0(s1)
}
    8000294a:	60e2                	ld	ra,24(sp)
    8000294c:	6442                	ld	s0,16(sp)
    8000294e:	64a2                	ld	s1,8(sp)
    80002950:	6105                	addi	sp,sp,32
    80002952:	8082                	ret

0000000080002954 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002954:	7179                	addi	sp,sp,-48
    80002956:	f406                	sd	ra,40(sp)
    80002958:	f022                	sd	s0,32(sp)
    8000295a:	ec26                	sd	s1,24(sp)
    8000295c:	e84a                	sd	s2,16(sp)
    8000295e:	1800                	addi	s0,sp,48
    80002960:	84ae                	mv	s1,a1
    80002962:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002964:	fd840593          	addi	a1,s0,-40
    80002968:	fd1ff0ef          	jal	80002938 <argaddr>
  return fetchstr(addr, buf, max);
    8000296c:	864a                	mv	a2,s2
    8000296e:	85a6                	mv	a1,s1
    80002970:	fd843503          	ld	a0,-40(s0)
    80002974:	f69ff0ef          	jal	800028dc <fetchstr>
}
    80002978:	70a2                	ld	ra,40(sp)
    8000297a:	7402                	ld	s0,32(sp)
    8000297c:	64e2                	ld	s1,24(sp)
    8000297e:	6942                	ld	s2,16(sp)
    80002980:	6145                	addi	sp,sp,48
    80002982:	8082                	ret

0000000080002984 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002984:	1101                	addi	sp,sp,-32
    80002986:	ec06                	sd	ra,24(sp)
    80002988:	e822                	sd	s0,16(sp)
    8000298a:	e426                	sd	s1,8(sp)
    8000298c:	e04a                	sd	s2,0(sp)
    8000298e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002990:	f35fe0ef          	jal	800018c4 <myproc>
    80002994:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002996:	06053903          	ld	s2,96(a0)
    8000299a:	0a893783          	ld	a5,168(s2)
    8000299e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800029a2:	37fd                	addiw	a5,a5,-1
    800029a4:	4751                	li	a4,20
    800029a6:	00f76f63          	bltu	a4,a5,800029c4 <syscall+0x40>
    800029aa:	00369713          	slli	a4,a3,0x3
    800029ae:	00005797          	auipc	a5,0x5
    800029b2:	e5278793          	addi	a5,a5,-430 # 80007800 <syscalls>
    800029b6:	97ba                	add	a5,a5,a4
    800029b8:	639c                	ld	a5,0(a5)
    800029ba:	c789                	beqz	a5,800029c4 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800029bc:	9782                	jalr	a5
    800029be:	06a93823          	sd	a0,112(s2)
    800029c2:	a829                	j	800029dc <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800029c4:	16048613          	addi	a2,s1,352
    800029c8:	588c                	lw	a1,48(s1)
    800029ca:	00005517          	auipc	a0,0x5
    800029ce:	a7650513          	addi	a0,a0,-1418 # 80007440 <etext+0x440>
    800029d2:	af1fd0ef          	jal	800004c2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800029d6:	70bc                	ld	a5,96(s1)
    800029d8:	577d                	li	a4,-1
    800029da:	fbb8                	sd	a4,112(a5)
  }
}
    800029dc:	60e2                	ld	ra,24(sp)
    800029de:	6442                	ld	s0,16(sp)
    800029e0:	64a2                	ld	s1,8(sp)
    800029e2:	6902                	ld	s2,0(sp)
    800029e4:	6105                	addi	sp,sp,32
    800029e6:	8082                	ret

00000000800029e8 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800029e8:	1101                	addi	sp,sp,-32
    800029ea:	ec06                	sd	ra,24(sp)
    800029ec:	e822                	sd	s0,16(sp)
    800029ee:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800029f0:	fec40593          	addi	a1,s0,-20
    800029f4:	4501                	li	a0,0
    800029f6:	f27ff0ef          	jal	8000291c <argint>
  exit(n);
    800029fa:	fec42503          	lw	a0,-20(s0)
    800029fe:	a0dff0ef          	jal	8000240a <exit>
  return 0;  // not reached
}
    80002a02:	4501                	li	a0,0
    80002a04:	60e2                	ld	ra,24(sp)
    80002a06:	6442                	ld	s0,16(sp)
    80002a08:	6105                	addi	sp,sp,32
    80002a0a:	8082                	ret

0000000080002a0c <sys_getpid>:

uint64
sys_getpid(void)
{
    80002a0c:	1141                	addi	sp,sp,-16
    80002a0e:	e406                	sd	ra,8(sp)
    80002a10:	e022                	sd	s0,0(sp)
    80002a12:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002a14:	eb1fe0ef          	jal	800018c4 <myproc>
}
    80002a18:	5908                	lw	a0,48(a0)
    80002a1a:	60a2                	ld	ra,8(sp)
    80002a1c:	6402                	ld	s0,0(sp)
    80002a1e:	0141                	addi	sp,sp,16
    80002a20:	8082                	ret

0000000080002a22 <sys_fork>:

uint64
sys_fork(void)
{
    80002a22:	1141                	addi	sp,sp,-16
    80002a24:	e406                	sd	ra,8(sp)
    80002a26:	e022                	sd	s0,0(sp)
    80002a28:	0800                	addi	s0,sp,16
  return fork();
    80002a2a:	825ff0ef          	jal	8000224e <fork>
}
    80002a2e:	60a2                	ld	ra,8(sp)
    80002a30:	6402                	ld	s0,0(sp)
    80002a32:	0141                	addi	sp,sp,16
    80002a34:	8082                	ret

0000000080002a36 <sys_wait>:

uint64
sys_wait(void)
{
    80002a36:	1101                	addi	sp,sp,-32
    80002a38:	ec06                	sd	ra,24(sp)
    80002a3a:	e822                	sd	s0,16(sp)
    80002a3c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002a3e:	fe840593          	addi	a1,s0,-24
    80002a42:	4501                	li	a0,0
    80002a44:	ef5ff0ef          	jal	80002938 <argaddr>
  return wait(p);
    80002a48:	fe843503          	ld	a0,-24(s0)
    80002a4c:	b8eff0ef          	jal	80001dda <wait>
}
    80002a50:	60e2                	ld	ra,24(sp)
    80002a52:	6442                	ld	s0,16(sp)
    80002a54:	6105                	addi	sp,sp,32
    80002a56:	8082                	ret

0000000080002a58 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002a58:	1101                	addi	sp,sp,-32
    80002a5a:	ec06                	sd	ra,24(sp)
    80002a5c:	e822                	sd	s0,16(sp)
    80002a5e:	1000                	addi	s0,sp,32
  uint64 addr;
  int n;

  argint(0, &n);
    80002a60:	fec40593          	addi	a1,s0,-20
    80002a64:	4501                	li	a0,0
    80002a66:	eb7ff0ef          	jal	8000291c <argint>
  addr = myproc()->sz;
    80002a6a:	e5bfe0ef          	jal	800018c4 <myproc>
  //if(growproc(n) < 0)
  //  return -1;
  return addr;
}
    80002a6e:	6528                	ld	a0,72(a0)
    80002a70:	60e2                	ld	ra,24(sp)
    80002a72:	6442                	ld	s0,16(sp)
    80002a74:	6105                	addi	sp,sp,32
    80002a76:	8082                	ret

0000000080002a78 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002a78:	7139                	addi	sp,sp,-64
    80002a7a:	fc06                	sd	ra,56(sp)
    80002a7c:	f822                	sd	s0,48(sp)
    80002a7e:	f04a                	sd	s2,32(sp)
    80002a80:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002a82:	fcc40593          	addi	a1,s0,-52
    80002a86:	4501                	li	a0,0
    80002a88:	e95ff0ef          	jal	8000291c <argint>
  if(n < 0)
    80002a8c:	fcc42783          	lw	a5,-52(s0)
    80002a90:	0607c763          	bltz	a5,80002afe <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002a94:	0000e517          	auipc	a0,0xe
    80002a98:	bfc50513          	addi	a0,a0,-1028 # 80010690 <tickslock>
    80002a9c:	95afe0ef          	jal	80000bf6 <acquire>
  ticks0 = ticks;
    80002aa0:	00005917          	auipc	s2,0x5
    80002aa4:	e9092903          	lw	s2,-368(s2) # 80007930 <ticks>
  while(ticks - ticks0 < n){
    80002aa8:	fcc42783          	lw	a5,-52(s0)
    80002aac:	cf8d                	beqz	a5,80002ae6 <sys_sleep+0x6e>
    80002aae:	f426                	sd	s1,40(sp)
    80002ab0:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002ab2:	0000e997          	auipc	s3,0xe
    80002ab6:	bde98993          	addi	s3,s3,-1058 # 80010690 <tickslock>
    80002aba:	00005497          	auipc	s1,0x5
    80002abe:	e7648493          	addi	s1,s1,-394 # 80007930 <ticks>
    if(killed(myproc())){
    80002ac2:	e03fe0ef          	jal	800018c4 <myproc>
    80002ac6:	aeaff0ef          	jal	80001db0 <killed>
    80002aca:	ed0d                	bnez	a0,80002b04 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002acc:	85ce                	mv	a1,s3
    80002ace:	8526                	mv	a0,s1
    80002ad0:	958ff0ef          	jal	80001c28 <sleep>
  while(ticks - ticks0 < n){
    80002ad4:	409c                	lw	a5,0(s1)
    80002ad6:	412787bb          	subw	a5,a5,s2
    80002ada:	fcc42703          	lw	a4,-52(s0)
    80002ade:	fee7e2e3          	bltu	a5,a4,80002ac2 <sys_sleep+0x4a>
    80002ae2:	74a2                	ld	s1,40(sp)
    80002ae4:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002ae6:	0000e517          	auipc	a0,0xe
    80002aea:	baa50513          	addi	a0,a0,-1110 # 80010690 <tickslock>
    80002aee:	9a0fe0ef          	jal	80000c8e <release>
  return 0;
    80002af2:	4501                	li	a0,0
}
    80002af4:	70e2                	ld	ra,56(sp)
    80002af6:	7442                	ld	s0,48(sp)
    80002af8:	7902                	ld	s2,32(sp)
    80002afa:	6121                	addi	sp,sp,64
    80002afc:	8082                	ret
    n = 0;
    80002afe:	fc042623          	sw	zero,-52(s0)
    80002b02:	bf49                	j	80002a94 <sys_sleep+0x1c>
      release(&tickslock);
    80002b04:	0000e517          	auipc	a0,0xe
    80002b08:	b8c50513          	addi	a0,a0,-1140 # 80010690 <tickslock>
    80002b0c:	982fe0ef          	jal	80000c8e <release>
      return -1;
    80002b10:	557d                	li	a0,-1
    80002b12:	74a2                	ld	s1,40(sp)
    80002b14:	69e2                	ld	s3,24(sp)
    80002b16:	bff9                	j	80002af4 <sys_sleep+0x7c>

0000000080002b18 <sys_kill>:

uint64
sys_kill(void)
{
    80002b18:	1101                	addi	sp,sp,-32
    80002b1a:	ec06                	sd	ra,24(sp)
    80002b1c:	e822                	sd	s0,16(sp)
    80002b1e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002b20:	fec40593          	addi	a1,s0,-20
    80002b24:	4501                	li	a0,0
    80002b26:	df7ff0ef          	jal	8000291c <argint>
  return kill(pid);
    80002b2a:	fec42503          	lw	a0,-20(s0)
    80002b2e:	9f8ff0ef          	jal	80001d26 <kill>
}
    80002b32:	60e2                	ld	ra,24(sp)
    80002b34:	6442                	ld	s0,16(sp)
    80002b36:	6105                	addi	sp,sp,32
    80002b38:	8082                	ret

0000000080002b3a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002b3a:	1101                	addi	sp,sp,-32
    80002b3c:	ec06                	sd	ra,24(sp)
    80002b3e:	e822                	sd	s0,16(sp)
    80002b40:	e426                	sd	s1,8(sp)
    80002b42:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002b44:	0000e517          	auipc	a0,0xe
    80002b48:	b4c50513          	addi	a0,a0,-1204 # 80010690 <tickslock>
    80002b4c:	8aafe0ef          	jal	80000bf6 <acquire>
  xticks = ticks;
    80002b50:	00005497          	auipc	s1,0x5
    80002b54:	de04a483          	lw	s1,-544(s1) # 80007930 <ticks>
  release(&tickslock);
    80002b58:	0000e517          	auipc	a0,0xe
    80002b5c:	b3850513          	addi	a0,a0,-1224 # 80010690 <tickslock>
    80002b60:	92efe0ef          	jal	80000c8e <release>
  return xticks;
}
    80002b64:	02049513          	slli	a0,s1,0x20
    80002b68:	9101                	srli	a0,a0,0x20
    80002b6a:	60e2                	ld	ra,24(sp)
    80002b6c:	6442                	ld	s0,16(sp)
    80002b6e:	64a2                	ld	s1,8(sp)
    80002b70:	6105                	addi	sp,sp,32
    80002b72:	8082                	ret

0000000080002b74 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002b74:	7179                	addi	sp,sp,-48
    80002b76:	f406                	sd	ra,40(sp)
    80002b78:	f022                	sd	s0,32(sp)
    80002b7a:	ec26                	sd	s1,24(sp)
    80002b7c:	e84a                	sd	s2,16(sp)
    80002b7e:	e44e                	sd	s3,8(sp)
    80002b80:	e052                	sd	s4,0(sp)
    80002b82:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002b84:	00005597          	auipc	a1,0x5
    80002b88:	8dc58593          	addi	a1,a1,-1828 # 80007460 <etext+0x460>
    80002b8c:	0000e517          	auipc	a0,0xe
    80002b90:	b1c50513          	addi	a0,a0,-1252 # 800106a8 <bcache>
    80002b94:	fe3fd0ef          	jal	80000b76 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002b98:	00016797          	auipc	a5,0x16
    80002b9c:	b1078793          	addi	a5,a5,-1264 # 800186a8 <bcache+0x8000>
    80002ba0:	00016717          	auipc	a4,0x16
    80002ba4:	d7070713          	addi	a4,a4,-656 # 80018910 <bcache+0x8268>
    80002ba8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002bac:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002bb0:	0000e497          	auipc	s1,0xe
    80002bb4:	b1048493          	addi	s1,s1,-1264 # 800106c0 <bcache+0x18>
    b->next = bcache.head.next;
    80002bb8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002bba:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002bbc:	00005a17          	auipc	s4,0x5
    80002bc0:	8aca0a13          	addi	s4,s4,-1876 # 80007468 <etext+0x468>
    b->next = bcache.head.next;
    80002bc4:	2b893783          	ld	a5,696(s2)
    80002bc8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002bca:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002bce:	85d2                	mv	a1,s4
    80002bd0:	01048513          	addi	a0,s1,16
    80002bd4:	248010ef          	jal	80003e1c <initsleeplock>
    bcache.head.next->prev = b;
    80002bd8:	2b893783          	ld	a5,696(s2)
    80002bdc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002bde:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002be2:	45848493          	addi	s1,s1,1112
    80002be6:	fd349fe3          	bne	s1,s3,80002bc4 <binit+0x50>
  }
}
    80002bea:	70a2                	ld	ra,40(sp)
    80002bec:	7402                	ld	s0,32(sp)
    80002bee:	64e2                	ld	s1,24(sp)
    80002bf0:	6942                	ld	s2,16(sp)
    80002bf2:	69a2                	ld	s3,8(sp)
    80002bf4:	6a02                	ld	s4,0(sp)
    80002bf6:	6145                	addi	sp,sp,48
    80002bf8:	8082                	ret

0000000080002bfa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002bfa:	7179                	addi	sp,sp,-48
    80002bfc:	f406                	sd	ra,40(sp)
    80002bfe:	f022                	sd	s0,32(sp)
    80002c00:	ec26                	sd	s1,24(sp)
    80002c02:	e84a                	sd	s2,16(sp)
    80002c04:	e44e                	sd	s3,8(sp)
    80002c06:	1800                	addi	s0,sp,48
    80002c08:	892a                	mv	s2,a0
    80002c0a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002c0c:	0000e517          	auipc	a0,0xe
    80002c10:	a9c50513          	addi	a0,a0,-1380 # 800106a8 <bcache>
    80002c14:	fe3fd0ef          	jal	80000bf6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002c18:	00016497          	auipc	s1,0x16
    80002c1c:	d484b483          	ld	s1,-696(s1) # 80018960 <bcache+0x82b8>
    80002c20:	00016797          	auipc	a5,0x16
    80002c24:	cf078793          	addi	a5,a5,-784 # 80018910 <bcache+0x8268>
    80002c28:	02f48b63          	beq	s1,a5,80002c5e <bread+0x64>
    80002c2c:	873e                	mv	a4,a5
    80002c2e:	a021                	j	80002c36 <bread+0x3c>
    80002c30:	68a4                	ld	s1,80(s1)
    80002c32:	02e48663          	beq	s1,a4,80002c5e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002c36:	449c                	lw	a5,8(s1)
    80002c38:	ff279ce3          	bne	a5,s2,80002c30 <bread+0x36>
    80002c3c:	44dc                	lw	a5,12(s1)
    80002c3e:	ff3799e3          	bne	a5,s3,80002c30 <bread+0x36>
      b->refcnt++;
    80002c42:	40bc                	lw	a5,64(s1)
    80002c44:	2785                	addiw	a5,a5,1
    80002c46:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c48:	0000e517          	auipc	a0,0xe
    80002c4c:	a6050513          	addi	a0,a0,-1440 # 800106a8 <bcache>
    80002c50:	83efe0ef          	jal	80000c8e <release>
      acquiresleep(&b->lock);
    80002c54:	01048513          	addi	a0,s1,16
    80002c58:	1fa010ef          	jal	80003e52 <acquiresleep>
      return b;
    80002c5c:	a889                	j	80002cae <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c5e:	00016497          	auipc	s1,0x16
    80002c62:	cfa4b483          	ld	s1,-774(s1) # 80018958 <bcache+0x82b0>
    80002c66:	00016797          	auipc	a5,0x16
    80002c6a:	caa78793          	addi	a5,a5,-854 # 80018910 <bcache+0x8268>
    80002c6e:	00f48863          	beq	s1,a5,80002c7e <bread+0x84>
    80002c72:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002c74:	40bc                	lw	a5,64(s1)
    80002c76:	cb91                	beqz	a5,80002c8a <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c78:	64a4                	ld	s1,72(s1)
    80002c7a:	fee49de3          	bne	s1,a4,80002c74 <bread+0x7a>
  panic("bget: no buffers");
    80002c7e:	00004517          	auipc	a0,0x4
    80002c82:	7f250513          	addi	a0,a0,2034 # 80007470 <etext+0x470>
    80002c86:	b0ffd0ef          	jal	80000794 <panic>
      b->dev = dev;
    80002c8a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002c8e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002c92:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002c96:	4785                	li	a5,1
    80002c98:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c9a:	0000e517          	auipc	a0,0xe
    80002c9e:	a0e50513          	addi	a0,a0,-1522 # 800106a8 <bcache>
    80002ca2:	fedfd0ef          	jal	80000c8e <release>
      acquiresleep(&b->lock);
    80002ca6:	01048513          	addi	a0,s1,16
    80002caa:	1a8010ef          	jal	80003e52 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002cae:	409c                	lw	a5,0(s1)
    80002cb0:	cb89                	beqz	a5,80002cc2 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002cb2:	8526                	mv	a0,s1
    80002cb4:	70a2                	ld	ra,40(sp)
    80002cb6:	7402                	ld	s0,32(sp)
    80002cb8:	64e2                	ld	s1,24(sp)
    80002cba:	6942                	ld	s2,16(sp)
    80002cbc:	69a2                	ld	s3,8(sp)
    80002cbe:	6145                	addi	sp,sp,48
    80002cc0:	8082                	ret
    virtio_disk_rw(b, 0);
    80002cc2:	4581                	li	a1,0
    80002cc4:	8526                	mv	a0,s1
    80002cc6:	1eb020ef          	jal	800056b0 <virtio_disk_rw>
    b->valid = 1;
    80002cca:	4785                	li	a5,1
    80002ccc:	c09c                	sw	a5,0(s1)
  return b;
    80002cce:	b7d5                	j	80002cb2 <bread+0xb8>

0000000080002cd0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002cd0:	1101                	addi	sp,sp,-32
    80002cd2:	ec06                	sd	ra,24(sp)
    80002cd4:	e822                	sd	s0,16(sp)
    80002cd6:	e426                	sd	s1,8(sp)
    80002cd8:	1000                	addi	s0,sp,32
    80002cda:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002cdc:	0541                	addi	a0,a0,16
    80002cde:	1f2010ef          	jal	80003ed0 <holdingsleep>
    80002ce2:	c911                	beqz	a0,80002cf6 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002ce4:	4585                	li	a1,1
    80002ce6:	8526                	mv	a0,s1
    80002ce8:	1c9020ef          	jal	800056b0 <virtio_disk_rw>
}
    80002cec:	60e2                	ld	ra,24(sp)
    80002cee:	6442                	ld	s0,16(sp)
    80002cf0:	64a2                	ld	s1,8(sp)
    80002cf2:	6105                	addi	sp,sp,32
    80002cf4:	8082                	ret
    panic("bwrite");
    80002cf6:	00004517          	auipc	a0,0x4
    80002cfa:	79250513          	addi	a0,a0,1938 # 80007488 <etext+0x488>
    80002cfe:	a97fd0ef          	jal	80000794 <panic>

0000000080002d02 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002d02:	1101                	addi	sp,sp,-32
    80002d04:	ec06                	sd	ra,24(sp)
    80002d06:	e822                	sd	s0,16(sp)
    80002d08:	e426                	sd	s1,8(sp)
    80002d0a:	e04a                	sd	s2,0(sp)
    80002d0c:	1000                	addi	s0,sp,32
    80002d0e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d10:	01050913          	addi	s2,a0,16
    80002d14:	854a                	mv	a0,s2
    80002d16:	1ba010ef          	jal	80003ed0 <holdingsleep>
    80002d1a:	c135                	beqz	a0,80002d7e <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002d1c:	854a                	mv	a0,s2
    80002d1e:	17a010ef          	jal	80003e98 <releasesleep>

  acquire(&bcache.lock);
    80002d22:	0000e517          	auipc	a0,0xe
    80002d26:	98650513          	addi	a0,a0,-1658 # 800106a8 <bcache>
    80002d2a:	ecdfd0ef          	jal	80000bf6 <acquire>
  b->refcnt--;
    80002d2e:	40bc                	lw	a5,64(s1)
    80002d30:	37fd                	addiw	a5,a5,-1
    80002d32:	0007871b          	sext.w	a4,a5
    80002d36:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002d38:	e71d                	bnez	a4,80002d66 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002d3a:	68b8                	ld	a4,80(s1)
    80002d3c:	64bc                	ld	a5,72(s1)
    80002d3e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002d40:	68b8                	ld	a4,80(s1)
    80002d42:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002d44:	00016797          	auipc	a5,0x16
    80002d48:	96478793          	addi	a5,a5,-1692 # 800186a8 <bcache+0x8000>
    80002d4c:	2b87b703          	ld	a4,696(a5)
    80002d50:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002d52:	00016717          	auipc	a4,0x16
    80002d56:	bbe70713          	addi	a4,a4,-1090 # 80018910 <bcache+0x8268>
    80002d5a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002d5c:	2b87b703          	ld	a4,696(a5)
    80002d60:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002d62:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002d66:	0000e517          	auipc	a0,0xe
    80002d6a:	94250513          	addi	a0,a0,-1726 # 800106a8 <bcache>
    80002d6e:	f21fd0ef          	jal	80000c8e <release>
}
    80002d72:	60e2                	ld	ra,24(sp)
    80002d74:	6442                	ld	s0,16(sp)
    80002d76:	64a2                	ld	s1,8(sp)
    80002d78:	6902                	ld	s2,0(sp)
    80002d7a:	6105                	addi	sp,sp,32
    80002d7c:	8082                	ret
    panic("brelse");
    80002d7e:	00004517          	auipc	a0,0x4
    80002d82:	71250513          	addi	a0,a0,1810 # 80007490 <etext+0x490>
    80002d86:	a0ffd0ef          	jal	80000794 <panic>

0000000080002d8a <bpin>:

void
bpin(struct buf *b) {
    80002d8a:	1101                	addi	sp,sp,-32
    80002d8c:	ec06                	sd	ra,24(sp)
    80002d8e:	e822                	sd	s0,16(sp)
    80002d90:	e426                	sd	s1,8(sp)
    80002d92:	1000                	addi	s0,sp,32
    80002d94:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d96:	0000e517          	auipc	a0,0xe
    80002d9a:	91250513          	addi	a0,a0,-1774 # 800106a8 <bcache>
    80002d9e:	e59fd0ef          	jal	80000bf6 <acquire>
  b->refcnt++;
    80002da2:	40bc                	lw	a5,64(s1)
    80002da4:	2785                	addiw	a5,a5,1
    80002da6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002da8:	0000e517          	auipc	a0,0xe
    80002dac:	90050513          	addi	a0,a0,-1792 # 800106a8 <bcache>
    80002db0:	edffd0ef          	jal	80000c8e <release>
}
    80002db4:	60e2                	ld	ra,24(sp)
    80002db6:	6442                	ld	s0,16(sp)
    80002db8:	64a2                	ld	s1,8(sp)
    80002dba:	6105                	addi	sp,sp,32
    80002dbc:	8082                	ret

0000000080002dbe <bunpin>:

void
bunpin(struct buf *b) {
    80002dbe:	1101                	addi	sp,sp,-32
    80002dc0:	ec06                	sd	ra,24(sp)
    80002dc2:	e822                	sd	s0,16(sp)
    80002dc4:	e426                	sd	s1,8(sp)
    80002dc6:	1000                	addi	s0,sp,32
    80002dc8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002dca:	0000e517          	auipc	a0,0xe
    80002dce:	8de50513          	addi	a0,a0,-1826 # 800106a8 <bcache>
    80002dd2:	e25fd0ef          	jal	80000bf6 <acquire>
  b->refcnt--;
    80002dd6:	40bc                	lw	a5,64(s1)
    80002dd8:	37fd                	addiw	a5,a5,-1
    80002dda:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002ddc:	0000e517          	auipc	a0,0xe
    80002de0:	8cc50513          	addi	a0,a0,-1844 # 800106a8 <bcache>
    80002de4:	eabfd0ef          	jal	80000c8e <release>
}
    80002de8:	60e2                	ld	ra,24(sp)
    80002dea:	6442                	ld	s0,16(sp)
    80002dec:	64a2                	ld	s1,8(sp)
    80002dee:	6105                	addi	sp,sp,32
    80002df0:	8082                	ret

0000000080002df2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002df2:	1101                	addi	sp,sp,-32
    80002df4:	ec06                	sd	ra,24(sp)
    80002df6:	e822                	sd	s0,16(sp)
    80002df8:	e426                	sd	s1,8(sp)
    80002dfa:	e04a                	sd	s2,0(sp)
    80002dfc:	1000                	addi	s0,sp,32
    80002dfe:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002e00:	00d5d59b          	srliw	a1,a1,0xd
    80002e04:	00016797          	auipc	a5,0x16
    80002e08:	f807a783          	lw	a5,-128(a5) # 80018d84 <sb+0x1c>
    80002e0c:	9dbd                	addw	a1,a1,a5
    80002e0e:	dedff0ef          	jal	80002bfa <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002e12:	0074f713          	andi	a4,s1,7
    80002e16:	4785                	li	a5,1
    80002e18:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002e1c:	14ce                	slli	s1,s1,0x33
    80002e1e:	90d9                	srli	s1,s1,0x36
    80002e20:	00950733          	add	a4,a0,s1
    80002e24:	05874703          	lbu	a4,88(a4)
    80002e28:	00e7f6b3          	and	a3,a5,a4
    80002e2c:	c29d                	beqz	a3,80002e52 <bfree+0x60>
    80002e2e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002e30:	94aa                	add	s1,s1,a0
    80002e32:	fff7c793          	not	a5,a5
    80002e36:	8f7d                	and	a4,a4,a5
    80002e38:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002e3c:	711000ef          	jal	80003d4c <log_write>
  brelse(bp);
    80002e40:	854a                	mv	a0,s2
    80002e42:	ec1ff0ef          	jal	80002d02 <brelse>
}
    80002e46:	60e2                	ld	ra,24(sp)
    80002e48:	6442                	ld	s0,16(sp)
    80002e4a:	64a2                	ld	s1,8(sp)
    80002e4c:	6902                	ld	s2,0(sp)
    80002e4e:	6105                	addi	sp,sp,32
    80002e50:	8082                	ret
    panic("freeing free block");
    80002e52:	00004517          	auipc	a0,0x4
    80002e56:	64650513          	addi	a0,a0,1606 # 80007498 <etext+0x498>
    80002e5a:	93bfd0ef          	jal	80000794 <panic>

0000000080002e5e <balloc>:
{
    80002e5e:	711d                	addi	sp,sp,-96
    80002e60:	ec86                	sd	ra,88(sp)
    80002e62:	e8a2                	sd	s0,80(sp)
    80002e64:	e4a6                	sd	s1,72(sp)
    80002e66:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002e68:	00016797          	auipc	a5,0x16
    80002e6c:	f047a783          	lw	a5,-252(a5) # 80018d6c <sb+0x4>
    80002e70:	0e078f63          	beqz	a5,80002f6e <balloc+0x110>
    80002e74:	e0ca                	sd	s2,64(sp)
    80002e76:	fc4e                	sd	s3,56(sp)
    80002e78:	f852                	sd	s4,48(sp)
    80002e7a:	f456                	sd	s5,40(sp)
    80002e7c:	f05a                	sd	s6,32(sp)
    80002e7e:	ec5e                	sd	s7,24(sp)
    80002e80:	e862                	sd	s8,16(sp)
    80002e82:	e466                	sd	s9,8(sp)
    80002e84:	8baa                	mv	s7,a0
    80002e86:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002e88:	00016b17          	auipc	s6,0x16
    80002e8c:	ee0b0b13          	addi	s6,s6,-288 # 80018d68 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e90:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002e92:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e94:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002e96:	6c89                	lui	s9,0x2
    80002e98:	a0b5                	j	80002f04 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002e9a:	97ca                	add	a5,a5,s2
    80002e9c:	8e55                	or	a2,a2,a3
    80002e9e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002ea2:	854a                	mv	a0,s2
    80002ea4:	6a9000ef          	jal	80003d4c <log_write>
        brelse(bp);
    80002ea8:	854a                	mv	a0,s2
    80002eaa:	e59ff0ef          	jal	80002d02 <brelse>
  bp = bread(dev, bno);
    80002eae:	85a6                	mv	a1,s1
    80002eb0:	855e                	mv	a0,s7
    80002eb2:	d49ff0ef          	jal	80002bfa <bread>
    80002eb6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002eb8:	40000613          	li	a2,1024
    80002ebc:	4581                	li	a1,0
    80002ebe:	05850513          	addi	a0,a0,88
    80002ec2:	e09fd0ef          	jal	80000cca <memset>
  log_write(bp);
    80002ec6:	854a                	mv	a0,s2
    80002ec8:	685000ef          	jal	80003d4c <log_write>
  brelse(bp);
    80002ecc:	854a                	mv	a0,s2
    80002ece:	e35ff0ef          	jal	80002d02 <brelse>
}
    80002ed2:	6906                	ld	s2,64(sp)
    80002ed4:	79e2                	ld	s3,56(sp)
    80002ed6:	7a42                	ld	s4,48(sp)
    80002ed8:	7aa2                	ld	s5,40(sp)
    80002eda:	7b02                	ld	s6,32(sp)
    80002edc:	6be2                	ld	s7,24(sp)
    80002ede:	6c42                	ld	s8,16(sp)
    80002ee0:	6ca2                	ld	s9,8(sp)
}
    80002ee2:	8526                	mv	a0,s1
    80002ee4:	60e6                	ld	ra,88(sp)
    80002ee6:	6446                	ld	s0,80(sp)
    80002ee8:	64a6                	ld	s1,72(sp)
    80002eea:	6125                	addi	sp,sp,96
    80002eec:	8082                	ret
    brelse(bp);
    80002eee:	854a                	mv	a0,s2
    80002ef0:	e13ff0ef          	jal	80002d02 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002ef4:	015c87bb          	addw	a5,s9,s5
    80002ef8:	00078a9b          	sext.w	s5,a5
    80002efc:	004b2703          	lw	a4,4(s6)
    80002f00:	04eaff63          	bgeu	s5,a4,80002f5e <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002f04:	41fad79b          	sraiw	a5,s5,0x1f
    80002f08:	0137d79b          	srliw	a5,a5,0x13
    80002f0c:	015787bb          	addw	a5,a5,s5
    80002f10:	40d7d79b          	sraiw	a5,a5,0xd
    80002f14:	01cb2583          	lw	a1,28(s6)
    80002f18:	9dbd                	addw	a1,a1,a5
    80002f1a:	855e                	mv	a0,s7
    80002f1c:	cdfff0ef          	jal	80002bfa <bread>
    80002f20:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f22:	004b2503          	lw	a0,4(s6)
    80002f26:	000a849b          	sext.w	s1,s5
    80002f2a:	8762                	mv	a4,s8
    80002f2c:	fca4f1e3          	bgeu	s1,a0,80002eee <balloc+0x90>
      m = 1 << (bi % 8);
    80002f30:	00777693          	andi	a3,a4,7
    80002f34:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002f38:	41f7579b          	sraiw	a5,a4,0x1f
    80002f3c:	01d7d79b          	srliw	a5,a5,0x1d
    80002f40:	9fb9                	addw	a5,a5,a4
    80002f42:	4037d79b          	sraiw	a5,a5,0x3
    80002f46:	00f90633          	add	a2,s2,a5
    80002f4a:	05864603          	lbu	a2,88(a2)
    80002f4e:	00c6f5b3          	and	a1,a3,a2
    80002f52:	d5a1                	beqz	a1,80002e9a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f54:	2705                	addiw	a4,a4,1
    80002f56:	2485                	addiw	s1,s1,1
    80002f58:	fd471ae3          	bne	a4,s4,80002f2c <balloc+0xce>
    80002f5c:	bf49                	j	80002eee <balloc+0x90>
    80002f5e:	6906                	ld	s2,64(sp)
    80002f60:	79e2                	ld	s3,56(sp)
    80002f62:	7a42                	ld	s4,48(sp)
    80002f64:	7aa2                	ld	s5,40(sp)
    80002f66:	7b02                	ld	s6,32(sp)
    80002f68:	6be2                	ld	s7,24(sp)
    80002f6a:	6c42                	ld	s8,16(sp)
    80002f6c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002f6e:	00004517          	auipc	a0,0x4
    80002f72:	54250513          	addi	a0,a0,1346 # 800074b0 <etext+0x4b0>
    80002f76:	d4cfd0ef          	jal	800004c2 <printf>
  return 0;
    80002f7a:	4481                	li	s1,0
    80002f7c:	b79d                	j	80002ee2 <balloc+0x84>

0000000080002f7e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002f7e:	7179                	addi	sp,sp,-48
    80002f80:	f406                	sd	ra,40(sp)
    80002f82:	f022                	sd	s0,32(sp)
    80002f84:	ec26                	sd	s1,24(sp)
    80002f86:	e84a                	sd	s2,16(sp)
    80002f88:	e44e                	sd	s3,8(sp)
    80002f8a:	1800                	addi	s0,sp,48
    80002f8c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002f8e:	47ad                	li	a5,11
    80002f90:	02b7e663          	bltu	a5,a1,80002fbc <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002f94:	02059793          	slli	a5,a1,0x20
    80002f98:	01e7d593          	srli	a1,a5,0x1e
    80002f9c:	00b504b3          	add	s1,a0,a1
    80002fa0:	0504a903          	lw	s2,80(s1)
    80002fa4:	06091a63          	bnez	s2,80003018 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002fa8:	4108                	lw	a0,0(a0)
    80002faa:	eb5ff0ef          	jal	80002e5e <balloc>
    80002fae:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002fb2:	06090363          	beqz	s2,80003018 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002fb6:	0524a823          	sw	s2,80(s1)
    80002fba:	a8b9                	j	80003018 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002fbc:	ff45849b          	addiw	s1,a1,-12
    80002fc0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002fc4:	0ff00793          	li	a5,255
    80002fc8:	06e7ee63          	bltu	a5,a4,80003044 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002fcc:	08052903          	lw	s2,128(a0)
    80002fd0:	00091d63          	bnez	s2,80002fea <bmap+0x6c>
      addr = balloc(ip->dev);
    80002fd4:	4108                	lw	a0,0(a0)
    80002fd6:	e89ff0ef          	jal	80002e5e <balloc>
    80002fda:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002fde:	02090d63          	beqz	s2,80003018 <bmap+0x9a>
    80002fe2:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002fe4:	0929a023          	sw	s2,128(s3)
    80002fe8:	a011                	j	80002fec <bmap+0x6e>
    80002fea:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002fec:	85ca                	mv	a1,s2
    80002fee:	0009a503          	lw	a0,0(s3)
    80002ff2:	c09ff0ef          	jal	80002bfa <bread>
    80002ff6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002ff8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002ffc:	02049713          	slli	a4,s1,0x20
    80003000:	01e75593          	srli	a1,a4,0x1e
    80003004:	00b784b3          	add	s1,a5,a1
    80003008:	0004a903          	lw	s2,0(s1)
    8000300c:	00090e63          	beqz	s2,80003028 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003010:	8552                	mv	a0,s4
    80003012:	cf1ff0ef          	jal	80002d02 <brelse>
    return addr;
    80003016:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003018:	854a                	mv	a0,s2
    8000301a:	70a2                	ld	ra,40(sp)
    8000301c:	7402                	ld	s0,32(sp)
    8000301e:	64e2                	ld	s1,24(sp)
    80003020:	6942                	ld	s2,16(sp)
    80003022:	69a2                	ld	s3,8(sp)
    80003024:	6145                	addi	sp,sp,48
    80003026:	8082                	ret
      addr = balloc(ip->dev);
    80003028:	0009a503          	lw	a0,0(s3)
    8000302c:	e33ff0ef          	jal	80002e5e <balloc>
    80003030:	0005091b          	sext.w	s2,a0
      if(addr){
    80003034:	fc090ee3          	beqz	s2,80003010 <bmap+0x92>
        a[bn] = addr;
    80003038:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000303c:	8552                	mv	a0,s4
    8000303e:	50f000ef          	jal	80003d4c <log_write>
    80003042:	b7f9                	j	80003010 <bmap+0x92>
    80003044:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003046:	00004517          	auipc	a0,0x4
    8000304a:	48250513          	addi	a0,a0,1154 # 800074c8 <etext+0x4c8>
    8000304e:	f46fd0ef          	jal	80000794 <panic>

0000000080003052 <iget>:
{
    80003052:	7179                	addi	sp,sp,-48
    80003054:	f406                	sd	ra,40(sp)
    80003056:	f022                	sd	s0,32(sp)
    80003058:	ec26                	sd	s1,24(sp)
    8000305a:	e84a                	sd	s2,16(sp)
    8000305c:	e44e                	sd	s3,8(sp)
    8000305e:	e052                	sd	s4,0(sp)
    80003060:	1800                	addi	s0,sp,48
    80003062:	89aa                	mv	s3,a0
    80003064:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003066:	00016517          	auipc	a0,0x16
    8000306a:	d2250513          	addi	a0,a0,-734 # 80018d88 <itable>
    8000306e:	b89fd0ef          	jal	80000bf6 <acquire>
  empty = 0;
    80003072:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003074:	00016497          	auipc	s1,0x16
    80003078:	d2c48493          	addi	s1,s1,-724 # 80018da0 <itable+0x18>
    8000307c:	00017697          	auipc	a3,0x17
    80003080:	7b468693          	addi	a3,a3,1972 # 8001a830 <log>
    80003084:	a039                	j	80003092 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003086:	02090963          	beqz	s2,800030b8 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000308a:	08848493          	addi	s1,s1,136
    8000308e:	02d48863          	beq	s1,a3,800030be <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003092:	449c                	lw	a5,8(s1)
    80003094:	fef059e3          	blez	a5,80003086 <iget+0x34>
    80003098:	4098                	lw	a4,0(s1)
    8000309a:	ff3716e3          	bne	a4,s3,80003086 <iget+0x34>
    8000309e:	40d8                	lw	a4,4(s1)
    800030a0:	ff4713e3          	bne	a4,s4,80003086 <iget+0x34>
      ip->ref++;
    800030a4:	2785                	addiw	a5,a5,1
    800030a6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800030a8:	00016517          	auipc	a0,0x16
    800030ac:	ce050513          	addi	a0,a0,-800 # 80018d88 <itable>
    800030b0:	bdffd0ef          	jal	80000c8e <release>
      return ip;
    800030b4:	8926                	mv	s2,s1
    800030b6:	a02d                	j	800030e0 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800030b8:	fbe9                	bnez	a5,8000308a <iget+0x38>
      empty = ip;
    800030ba:	8926                	mv	s2,s1
    800030bc:	b7f9                	j	8000308a <iget+0x38>
  if(empty == 0)
    800030be:	02090a63          	beqz	s2,800030f2 <iget+0xa0>
  ip->dev = dev;
    800030c2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800030c6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800030ca:	4785                	li	a5,1
    800030cc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800030d0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800030d4:	00016517          	auipc	a0,0x16
    800030d8:	cb450513          	addi	a0,a0,-844 # 80018d88 <itable>
    800030dc:	bb3fd0ef          	jal	80000c8e <release>
}
    800030e0:	854a                	mv	a0,s2
    800030e2:	70a2                	ld	ra,40(sp)
    800030e4:	7402                	ld	s0,32(sp)
    800030e6:	64e2                	ld	s1,24(sp)
    800030e8:	6942                	ld	s2,16(sp)
    800030ea:	69a2                	ld	s3,8(sp)
    800030ec:	6a02                	ld	s4,0(sp)
    800030ee:	6145                	addi	sp,sp,48
    800030f0:	8082                	ret
    panic("iget: no inodes");
    800030f2:	00004517          	auipc	a0,0x4
    800030f6:	3ee50513          	addi	a0,a0,1006 # 800074e0 <etext+0x4e0>
    800030fa:	e9afd0ef          	jal	80000794 <panic>

00000000800030fe <fsinit>:
fsinit(int dev) {
    800030fe:	7179                	addi	sp,sp,-48
    80003100:	f406                	sd	ra,40(sp)
    80003102:	f022                	sd	s0,32(sp)
    80003104:	ec26                	sd	s1,24(sp)
    80003106:	e84a                	sd	s2,16(sp)
    80003108:	e44e                	sd	s3,8(sp)
    8000310a:	1800                	addi	s0,sp,48
    8000310c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000310e:	4585                	li	a1,1
    80003110:	aebff0ef          	jal	80002bfa <bread>
    80003114:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003116:	00016997          	auipc	s3,0x16
    8000311a:	c5298993          	addi	s3,s3,-942 # 80018d68 <sb>
    8000311e:	02000613          	li	a2,32
    80003122:	05850593          	addi	a1,a0,88
    80003126:	854e                	mv	a0,s3
    80003128:	bfffd0ef          	jal	80000d26 <memmove>
  brelse(bp);
    8000312c:	8526                	mv	a0,s1
    8000312e:	bd5ff0ef          	jal	80002d02 <brelse>
  if(sb.magic != FSMAGIC)
    80003132:	0009a703          	lw	a4,0(s3)
    80003136:	102037b7          	lui	a5,0x10203
    8000313a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000313e:	02f71063          	bne	a4,a5,8000315e <fsinit+0x60>
  initlog(dev, &sb);
    80003142:	00016597          	auipc	a1,0x16
    80003146:	c2658593          	addi	a1,a1,-986 # 80018d68 <sb>
    8000314a:	854a                	mv	a0,s2
    8000314c:	1f9000ef          	jal	80003b44 <initlog>
}
    80003150:	70a2                	ld	ra,40(sp)
    80003152:	7402                	ld	s0,32(sp)
    80003154:	64e2                	ld	s1,24(sp)
    80003156:	6942                	ld	s2,16(sp)
    80003158:	69a2                	ld	s3,8(sp)
    8000315a:	6145                	addi	sp,sp,48
    8000315c:	8082                	ret
    panic("invalid file system");
    8000315e:	00004517          	auipc	a0,0x4
    80003162:	39250513          	addi	a0,a0,914 # 800074f0 <etext+0x4f0>
    80003166:	e2efd0ef          	jal	80000794 <panic>

000000008000316a <iinit>:
{
    8000316a:	7179                	addi	sp,sp,-48
    8000316c:	f406                	sd	ra,40(sp)
    8000316e:	f022                	sd	s0,32(sp)
    80003170:	ec26                	sd	s1,24(sp)
    80003172:	e84a                	sd	s2,16(sp)
    80003174:	e44e                	sd	s3,8(sp)
    80003176:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003178:	00004597          	auipc	a1,0x4
    8000317c:	39058593          	addi	a1,a1,912 # 80007508 <etext+0x508>
    80003180:	00016517          	auipc	a0,0x16
    80003184:	c0850513          	addi	a0,a0,-1016 # 80018d88 <itable>
    80003188:	9effd0ef          	jal	80000b76 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000318c:	00016497          	auipc	s1,0x16
    80003190:	c2448493          	addi	s1,s1,-988 # 80018db0 <itable+0x28>
    80003194:	00017997          	auipc	s3,0x17
    80003198:	6ac98993          	addi	s3,s3,1708 # 8001a840 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000319c:	00004917          	auipc	s2,0x4
    800031a0:	37490913          	addi	s2,s2,884 # 80007510 <etext+0x510>
    800031a4:	85ca                	mv	a1,s2
    800031a6:	8526                	mv	a0,s1
    800031a8:	475000ef          	jal	80003e1c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800031ac:	08848493          	addi	s1,s1,136
    800031b0:	ff349ae3          	bne	s1,s3,800031a4 <iinit+0x3a>
}
    800031b4:	70a2                	ld	ra,40(sp)
    800031b6:	7402                	ld	s0,32(sp)
    800031b8:	64e2                	ld	s1,24(sp)
    800031ba:	6942                	ld	s2,16(sp)
    800031bc:	69a2                	ld	s3,8(sp)
    800031be:	6145                	addi	sp,sp,48
    800031c0:	8082                	ret

00000000800031c2 <ialloc>:
{
    800031c2:	7139                	addi	sp,sp,-64
    800031c4:	fc06                	sd	ra,56(sp)
    800031c6:	f822                	sd	s0,48(sp)
    800031c8:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800031ca:	00016717          	auipc	a4,0x16
    800031ce:	baa72703          	lw	a4,-1110(a4) # 80018d74 <sb+0xc>
    800031d2:	4785                	li	a5,1
    800031d4:	06e7f063          	bgeu	a5,a4,80003234 <ialloc+0x72>
    800031d8:	f426                	sd	s1,40(sp)
    800031da:	f04a                	sd	s2,32(sp)
    800031dc:	ec4e                	sd	s3,24(sp)
    800031de:	e852                	sd	s4,16(sp)
    800031e0:	e456                	sd	s5,8(sp)
    800031e2:	e05a                	sd	s6,0(sp)
    800031e4:	8aaa                	mv	s5,a0
    800031e6:	8b2e                	mv	s6,a1
    800031e8:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800031ea:	00016a17          	auipc	s4,0x16
    800031ee:	b7ea0a13          	addi	s4,s4,-1154 # 80018d68 <sb>
    800031f2:	00495593          	srli	a1,s2,0x4
    800031f6:	018a2783          	lw	a5,24(s4)
    800031fa:	9dbd                	addw	a1,a1,a5
    800031fc:	8556                	mv	a0,s5
    800031fe:	9fdff0ef          	jal	80002bfa <bread>
    80003202:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003204:	05850993          	addi	s3,a0,88
    80003208:	00f97793          	andi	a5,s2,15
    8000320c:	079a                	slli	a5,a5,0x6
    8000320e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003210:	00099783          	lh	a5,0(s3)
    80003214:	cb9d                	beqz	a5,8000324a <ialloc+0x88>
    brelse(bp);
    80003216:	aedff0ef          	jal	80002d02 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000321a:	0905                	addi	s2,s2,1
    8000321c:	00ca2703          	lw	a4,12(s4)
    80003220:	0009079b          	sext.w	a5,s2
    80003224:	fce7e7e3          	bltu	a5,a4,800031f2 <ialloc+0x30>
    80003228:	74a2                	ld	s1,40(sp)
    8000322a:	7902                	ld	s2,32(sp)
    8000322c:	69e2                	ld	s3,24(sp)
    8000322e:	6a42                	ld	s4,16(sp)
    80003230:	6aa2                	ld	s5,8(sp)
    80003232:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003234:	00004517          	auipc	a0,0x4
    80003238:	2e450513          	addi	a0,a0,740 # 80007518 <etext+0x518>
    8000323c:	a86fd0ef          	jal	800004c2 <printf>
  return 0;
    80003240:	4501                	li	a0,0
}
    80003242:	70e2                	ld	ra,56(sp)
    80003244:	7442                	ld	s0,48(sp)
    80003246:	6121                	addi	sp,sp,64
    80003248:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000324a:	04000613          	li	a2,64
    8000324e:	4581                	li	a1,0
    80003250:	854e                	mv	a0,s3
    80003252:	a79fd0ef          	jal	80000cca <memset>
      dip->type = type;
    80003256:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000325a:	8526                	mv	a0,s1
    8000325c:	2f1000ef          	jal	80003d4c <log_write>
      brelse(bp);
    80003260:	8526                	mv	a0,s1
    80003262:	aa1ff0ef          	jal	80002d02 <brelse>
      return iget(dev, inum);
    80003266:	0009059b          	sext.w	a1,s2
    8000326a:	8556                	mv	a0,s5
    8000326c:	de7ff0ef          	jal	80003052 <iget>
    80003270:	74a2                	ld	s1,40(sp)
    80003272:	7902                	ld	s2,32(sp)
    80003274:	69e2                	ld	s3,24(sp)
    80003276:	6a42                	ld	s4,16(sp)
    80003278:	6aa2                	ld	s5,8(sp)
    8000327a:	6b02                	ld	s6,0(sp)
    8000327c:	b7d9                	j	80003242 <ialloc+0x80>

000000008000327e <iupdate>:
{
    8000327e:	1101                	addi	sp,sp,-32
    80003280:	ec06                	sd	ra,24(sp)
    80003282:	e822                	sd	s0,16(sp)
    80003284:	e426                	sd	s1,8(sp)
    80003286:	e04a                	sd	s2,0(sp)
    80003288:	1000                	addi	s0,sp,32
    8000328a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000328c:	415c                	lw	a5,4(a0)
    8000328e:	0047d79b          	srliw	a5,a5,0x4
    80003292:	00016597          	auipc	a1,0x16
    80003296:	aee5a583          	lw	a1,-1298(a1) # 80018d80 <sb+0x18>
    8000329a:	9dbd                	addw	a1,a1,a5
    8000329c:	4108                	lw	a0,0(a0)
    8000329e:	95dff0ef          	jal	80002bfa <bread>
    800032a2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800032a4:	05850793          	addi	a5,a0,88
    800032a8:	40d8                	lw	a4,4(s1)
    800032aa:	8b3d                	andi	a4,a4,15
    800032ac:	071a                	slli	a4,a4,0x6
    800032ae:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800032b0:	04449703          	lh	a4,68(s1)
    800032b4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800032b8:	04649703          	lh	a4,70(s1)
    800032bc:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800032c0:	04849703          	lh	a4,72(s1)
    800032c4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800032c8:	04a49703          	lh	a4,74(s1)
    800032cc:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800032d0:	44f8                	lw	a4,76(s1)
    800032d2:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800032d4:	03400613          	li	a2,52
    800032d8:	05048593          	addi	a1,s1,80
    800032dc:	00c78513          	addi	a0,a5,12
    800032e0:	a47fd0ef          	jal	80000d26 <memmove>
  log_write(bp);
    800032e4:	854a                	mv	a0,s2
    800032e6:	267000ef          	jal	80003d4c <log_write>
  brelse(bp);
    800032ea:	854a                	mv	a0,s2
    800032ec:	a17ff0ef          	jal	80002d02 <brelse>
}
    800032f0:	60e2                	ld	ra,24(sp)
    800032f2:	6442                	ld	s0,16(sp)
    800032f4:	64a2                	ld	s1,8(sp)
    800032f6:	6902                	ld	s2,0(sp)
    800032f8:	6105                	addi	sp,sp,32
    800032fa:	8082                	ret

00000000800032fc <idup>:
{
    800032fc:	1101                	addi	sp,sp,-32
    800032fe:	ec06                	sd	ra,24(sp)
    80003300:	e822                	sd	s0,16(sp)
    80003302:	e426                	sd	s1,8(sp)
    80003304:	1000                	addi	s0,sp,32
    80003306:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003308:	00016517          	auipc	a0,0x16
    8000330c:	a8050513          	addi	a0,a0,-1408 # 80018d88 <itable>
    80003310:	8e7fd0ef          	jal	80000bf6 <acquire>
  ip->ref++;
    80003314:	449c                	lw	a5,8(s1)
    80003316:	2785                	addiw	a5,a5,1
    80003318:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000331a:	00016517          	auipc	a0,0x16
    8000331e:	a6e50513          	addi	a0,a0,-1426 # 80018d88 <itable>
    80003322:	96dfd0ef          	jal	80000c8e <release>
}
    80003326:	8526                	mv	a0,s1
    80003328:	60e2                	ld	ra,24(sp)
    8000332a:	6442                	ld	s0,16(sp)
    8000332c:	64a2                	ld	s1,8(sp)
    8000332e:	6105                	addi	sp,sp,32
    80003330:	8082                	ret

0000000080003332 <ilock>:
{
    80003332:	1101                	addi	sp,sp,-32
    80003334:	ec06                	sd	ra,24(sp)
    80003336:	e822                	sd	s0,16(sp)
    80003338:	e426                	sd	s1,8(sp)
    8000333a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000333c:	cd19                	beqz	a0,8000335a <ilock+0x28>
    8000333e:	84aa                	mv	s1,a0
    80003340:	451c                	lw	a5,8(a0)
    80003342:	00f05c63          	blez	a5,8000335a <ilock+0x28>
  acquiresleep(&ip->lock);
    80003346:	0541                	addi	a0,a0,16
    80003348:	30b000ef          	jal	80003e52 <acquiresleep>
  if(ip->valid == 0){
    8000334c:	40bc                	lw	a5,64(s1)
    8000334e:	cf89                	beqz	a5,80003368 <ilock+0x36>
}
    80003350:	60e2                	ld	ra,24(sp)
    80003352:	6442                	ld	s0,16(sp)
    80003354:	64a2                	ld	s1,8(sp)
    80003356:	6105                	addi	sp,sp,32
    80003358:	8082                	ret
    8000335a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000335c:	00004517          	auipc	a0,0x4
    80003360:	1d450513          	addi	a0,a0,468 # 80007530 <etext+0x530>
    80003364:	c30fd0ef          	jal	80000794 <panic>
    80003368:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000336a:	40dc                	lw	a5,4(s1)
    8000336c:	0047d79b          	srliw	a5,a5,0x4
    80003370:	00016597          	auipc	a1,0x16
    80003374:	a105a583          	lw	a1,-1520(a1) # 80018d80 <sb+0x18>
    80003378:	9dbd                	addw	a1,a1,a5
    8000337a:	4088                	lw	a0,0(s1)
    8000337c:	87fff0ef          	jal	80002bfa <bread>
    80003380:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003382:	05850593          	addi	a1,a0,88
    80003386:	40dc                	lw	a5,4(s1)
    80003388:	8bbd                	andi	a5,a5,15
    8000338a:	079a                	slli	a5,a5,0x6
    8000338c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000338e:	00059783          	lh	a5,0(a1)
    80003392:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003396:	00259783          	lh	a5,2(a1)
    8000339a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000339e:	00459783          	lh	a5,4(a1)
    800033a2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800033a6:	00659783          	lh	a5,6(a1)
    800033aa:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800033ae:	459c                	lw	a5,8(a1)
    800033b0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800033b2:	03400613          	li	a2,52
    800033b6:	05b1                	addi	a1,a1,12
    800033b8:	05048513          	addi	a0,s1,80
    800033bc:	96bfd0ef          	jal	80000d26 <memmove>
    brelse(bp);
    800033c0:	854a                	mv	a0,s2
    800033c2:	941ff0ef          	jal	80002d02 <brelse>
    ip->valid = 1;
    800033c6:	4785                	li	a5,1
    800033c8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800033ca:	04449783          	lh	a5,68(s1)
    800033ce:	c399                	beqz	a5,800033d4 <ilock+0xa2>
    800033d0:	6902                	ld	s2,0(sp)
    800033d2:	bfbd                	j	80003350 <ilock+0x1e>
      panic("ilock: no type");
    800033d4:	00004517          	auipc	a0,0x4
    800033d8:	16450513          	addi	a0,a0,356 # 80007538 <etext+0x538>
    800033dc:	bb8fd0ef          	jal	80000794 <panic>

00000000800033e0 <iunlock>:
{
    800033e0:	1101                	addi	sp,sp,-32
    800033e2:	ec06                	sd	ra,24(sp)
    800033e4:	e822                	sd	s0,16(sp)
    800033e6:	e426                	sd	s1,8(sp)
    800033e8:	e04a                	sd	s2,0(sp)
    800033ea:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800033ec:	c505                	beqz	a0,80003414 <iunlock+0x34>
    800033ee:	84aa                	mv	s1,a0
    800033f0:	01050913          	addi	s2,a0,16
    800033f4:	854a                	mv	a0,s2
    800033f6:	2db000ef          	jal	80003ed0 <holdingsleep>
    800033fa:	cd09                	beqz	a0,80003414 <iunlock+0x34>
    800033fc:	449c                	lw	a5,8(s1)
    800033fe:	00f05b63          	blez	a5,80003414 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003402:	854a                	mv	a0,s2
    80003404:	295000ef          	jal	80003e98 <releasesleep>
}
    80003408:	60e2                	ld	ra,24(sp)
    8000340a:	6442                	ld	s0,16(sp)
    8000340c:	64a2                	ld	s1,8(sp)
    8000340e:	6902                	ld	s2,0(sp)
    80003410:	6105                	addi	sp,sp,32
    80003412:	8082                	ret
    panic("iunlock");
    80003414:	00004517          	auipc	a0,0x4
    80003418:	13450513          	addi	a0,a0,308 # 80007548 <etext+0x548>
    8000341c:	b78fd0ef          	jal	80000794 <panic>

0000000080003420 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003420:	7179                	addi	sp,sp,-48
    80003422:	f406                	sd	ra,40(sp)
    80003424:	f022                	sd	s0,32(sp)
    80003426:	ec26                	sd	s1,24(sp)
    80003428:	e84a                	sd	s2,16(sp)
    8000342a:	e44e                	sd	s3,8(sp)
    8000342c:	1800                	addi	s0,sp,48
    8000342e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003430:	05050493          	addi	s1,a0,80
    80003434:	08050913          	addi	s2,a0,128
    80003438:	a021                	j	80003440 <itrunc+0x20>
    8000343a:	0491                	addi	s1,s1,4
    8000343c:	01248b63          	beq	s1,s2,80003452 <itrunc+0x32>
    if(ip->addrs[i]){
    80003440:	408c                	lw	a1,0(s1)
    80003442:	dde5                	beqz	a1,8000343a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003444:	0009a503          	lw	a0,0(s3)
    80003448:	9abff0ef          	jal	80002df2 <bfree>
      ip->addrs[i] = 0;
    8000344c:	0004a023          	sw	zero,0(s1)
    80003450:	b7ed                	j	8000343a <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003452:	0809a583          	lw	a1,128(s3)
    80003456:	ed89                	bnez	a1,80003470 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003458:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000345c:	854e                	mv	a0,s3
    8000345e:	e21ff0ef          	jal	8000327e <iupdate>
}
    80003462:	70a2                	ld	ra,40(sp)
    80003464:	7402                	ld	s0,32(sp)
    80003466:	64e2                	ld	s1,24(sp)
    80003468:	6942                	ld	s2,16(sp)
    8000346a:	69a2                	ld	s3,8(sp)
    8000346c:	6145                	addi	sp,sp,48
    8000346e:	8082                	ret
    80003470:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003472:	0009a503          	lw	a0,0(s3)
    80003476:	f84ff0ef          	jal	80002bfa <bread>
    8000347a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000347c:	05850493          	addi	s1,a0,88
    80003480:	45850913          	addi	s2,a0,1112
    80003484:	a021                	j	8000348c <itrunc+0x6c>
    80003486:	0491                	addi	s1,s1,4
    80003488:	01248963          	beq	s1,s2,8000349a <itrunc+0x7a>
      if(a[j])
    8000348c:	408c                	lw	a1,0(s1)
    8000348e:	dde5                	beqz	a1,80003486 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003490:	0009a503          	lw	a0,0(s3)
    80003494:	95fff0ef          	jal	80002df2 <bfree>
    80003498:	b7fd                	j	80003486 <itrunc+0x66>
    brelse(bp);
    8000349a:	8552                	mv	a0,s4
    8000349c:	867ff0ef          	jal	80002d02 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800034a0:	0809a583          	lw	a1,128(s3)
    800034a4:	0009a503          	lw	a0,0(s3)
    800034a8:	94bff0ef          	jal	80002df2 <bfree>
    ip->addrs[NDIRECT] = 0;
    800034ac:	0809a023          	sw	zero,128(s3)
    800034b0:	6a02                	ld	s4,0(sp)
    800034b2:	b75d                	j	80003458 <itrunc+0x38>

00000000800034b4 <iput>:
{
    800034b4:	1101                	addi	sp,sp,-32
    800034b6:	ec06                	sd	ra,24(sp)
    800034b8:	e822                	sd	s0,16(sp)
    800034ba:	e426                	sd	s1,8(sp)
    800034bc:	1000                	addi	s0,sp,32
    800034be:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800034c0:	00016517          	auipc	a0,0x16
    800034c4:	8c850513          	addi	a0,a0,-1848 # 80018d88 <itable>
    800034c8:	f2efd0ef          	jal	80000bf6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800034cc:	4498                	lw	a4,8(s1)
    800034ce:	4785                	li	a5,1
    800034d0:	02f70063          	beq	a4,a5,800034f0 <iput+0x3c>
  ip->ref--;
    800034d4:	449c                	lw	a5,8(s1)
    800034d6:	37fd                	addiw	a5,a5,-1
    800034d8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800034da:	00016517          	auipc	a0,0x16
    800034de:	8ae50513          	addi	a0,a0,-1874 # 80018d88 <itable>
    800034e2:	facfd0ef          	jal	80000c8e <release>
}
    800034e6:	60e2                	ld	ra,24(sp)
    800034e8:	6442                	ld	s0,16(sp)
    800034ea:	64a2                	ld	s1,8(sp)
    800034ec:	6105                	addi	sp,sp,32
    800034ee:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800034f0:	40bc                	lw	a5,64(s1)
    800034f2:	d3ed                	beqz	a5,800034d4 <iput+0x20>
    800034f4:	04a49783          	lh	a5,74(s1)
    800034f8:	fff1                	bnez	a5,800034d4 <iput+0x20>
    800034fa:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800034fc:	01048913          	addi	s2,s1,16
    80003500:	854a                	mv	a0,s2
    80003502:	151000ef          	jal	80003e52 <acquiresleep>
    release(&itable.lock);
    80003506:	00016517          	auipc	a0,0x16
    8000350a:	88250513          	addi	a0,a0,-1918 # 80018d88 <itable>
    8000350e:	f80fd0ef          	jal	80000c8e <release>
    itrunc(ip);
    80003512:	8526                	mv	a0,s1
    80003514:	f0dff0ef          	jal	80003420 <itrunc>
    ip->type = 0;
    80003518:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000351c:	8526                	mv	a0,s1
    8000351e:	d61ff0ef          	jal	8000327e <iupdate>
    ip->valid = 0;
    80003522:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003526:	854a                	mv	a0,s2
    80003528:	171000ef          	jal	80003e98 <releasesleep>
    acquire(&itable.lock);
    8000352c:	00016517          	auipc	a0,0x16
    80003530:	85c50513          	addi	a0,a0,-1956 # 80018d88 <itable>
    80003534:	ec2fd0ef          	jal	80000bf6 <acquire>
    80003538:	6902                	ld	s2,0(sp)
    8000353a:	bf69                	j	800034d4 <iput+0x20>

000000008000353c <iunlockput>:
{
    8000353c:	1101                	addi	sp,sp,-32
    8000353e:	ec06                	sd	ra,24(sp)
    80003540:	e822                	sd	s0,16(sp)
    80003542:	e426                	sd	s1,8(sp)
    80003544:	1000                	addi	s0,sp,32
    80003546:	84aa                	mv	s1,a0
  iunlock(ip);
    80003548:	e99ff0ef          	jal	800033e0 <iunlock>
  iput(ip);
    8000354c:	8526                	mv	a0,s1
    8000354e:	f67ff0ef          	jal	800034b4 <iput>
}
    80003552:	60e2                	ld	ra,24(sp)
    80003554:	6442                	ld	s0,16(sp)
    80003556:	64a2                	ld	s1,8(sp)
    80003558:	6105                	addi	sp,sp,32
    8000355a:	8082                	ret

000000008000355c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000355c:	1141                	addi	sp,sp,-16
    8000355e:	e422                	sd	s0,8(sp)
    80003560:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003562:	411c                	lw	a5,0(a0)
    80003564:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003566:	415c                	lw	a5,4(a0)
    80003568:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000356a:	04451783          	lh	a5,68(a0)
    8000356e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003572:	04a51783          	lh	a5,74(a0)
    80003576:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000357a:	04c56783          	lwu	a5,76(a0)
    8000357e:	e99c                	sd	a5,16(a1)
}
    80003580:	6422                	ld	s0,8(sp)
    80003582:	0141                	addi	sp,sp,16
    80003584:	8082                	ret

0000000080003586 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003586:	457c                	lw	a5,76(a0)
    80003588:	0ed7eb63          	bltu	a5,a3,8000367e <readi+0xf8>
{
    8000358c:	7159                	addi	sp,sp,-112
    8000358e:	f486                	sd	ra,104(sp)
    80003590:	f0a2                	sd	s0,96(sp)
    80003592:	eca6                	sd	s1,88(sp)
    80003594:	e0d2                	sd	s4,64(sp)
    80003596:	fc56                	sd	s5,56(sp)
    80003598:	f85a                	sd	s6,48(sp)
    8000359a:	f45e                	sd	s7,40(sp)
    8000359c:	1880                	addi	s0,sp,112
    8000359e:	8b2a                	mv	s6,a0
    800035a0:	8bae                	mv	s7,a1
    800035a2:	8a32                	mv	s4,a2
    800035a4:	84b6                	mv	s1,a3
    800035a6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800035a8:	9f35                	addw	a4,a4,a3
    return 0;
    800035aa:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800035ac:	0cd76063          	bltu	a4,a3,8000366c <readi+0xe6>
    800035b0:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800035b2:	00e7f463          	bgeu	a5,a4,800035ba <readi+0x34>
    n = ip->size - off;
    800035b6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800035ba:	080a8f63          	beqz	s5,80003658 <readi+0xd2>
    800035be:	e8ca                	sd	s2,80(sp)
    800035c0:	f062                	sd	s8,32(sp)
    800035c2:	ec66                	sd	s9,24(sp)
    800035c4:	e86a                	sd	s10,16(sp)
    800035c6:	e46e                	sd	s11,8(sp)
    800035c8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800035ca:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800035ce:	5c7d                	li	s8,-1
    800035d0:	a80d                	j	80003602 <readi+0x7c>
    800035d2:	020d1d93          	slli	s11,s10,0x20
    800035d6:	020ddd93          	srli	s11,s11,0x20
    800035da:	05890613          	addi	a2,s2,88
    800035de:	86ee                	mv	a3,s11
    800035e0:	963a                	add	a2,a2,a4
    800035e2:	85d2                	mv	a1,s4
    800035e4:	855e                	mv	a0,s7
    800035e6:	911fe0ef          	jal	80001ef6 <either_copyout>
    800035ea:	05850763          	beq	a0,s8,80003638 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800035ee:	854a                	mv	a0,s2
    800035f0:	f12ff0ef          	jal	80002d02 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800035f4:	013d09bb          	addw	s3,s10,s3
    800035f8:	009d04bb          	addw	s1,s10,s1
    800035fc:	9a6e                	add	s4,s4,s11
    800035fe:	0559f763          	bgeu	s3,s5,8000364c <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80003602:	00a4d59b          	srliw	a1,s1,0xa
    80003606:	855a                	mv	a0,s6
    80003608:	977ff0ef          	jal	80002f7e <bmap>
    8000360c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003610:	c5b1                	beqz	a1,8000365c <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003612:	000b2503          	lw	a0,0(s6)
    80003616:	de4ff0ef          	jal	80002bfa <bread>
    8000361a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000361c:	3ff4f713          	andi	a4,s1,1023
    80003620:	40ec87bb          	subw	a5,s9,a4
    80003624:	413a86bb          	subw	a3,s5,s3
    80003628:	8d3e                	mv	s10,a5
    8000362a:	2781                	sext.w	a5,a5
    8000362c:	0006861b          	sext.w	a2,a3
    80003630:	faf671e3          	bgeu	a2,a5,800035d2 <readi+0x4c>
    80003634:	8d36                	mv	s10,a3
    80003636:	bf71                	j	800035d2 <readi+0x4c>
      brelse(bp);
    80003638:	854a                	mv	a0,s2
    8000363a:	ec8ff0ef          	jal	80002d02 <brelse>
      tot = -1;
    8000363e:	59fd                	li	s3,-1
      break;
    80003640:	6946                	ld	s2,80(sp)
    80003642:	7c02                	ld	s8,32(sp)
    80003644:	6ce2                	ld	s9,24(sp)
    80003646:	6d42                	ld	s10,16(sp)
    80003648:	6da2                	ld	s11,8(sp)
    8000364a:	a831                	j	80003666 <readi+0xe0>
    8000364c:	6946                	ld	s2,80(sp)
    8000364e:	7c02                	ld	s8,32(sp)
    80003650:	6ce2                	ld	s9,24(sp)
    80003652:	6d42                	ld	s10,16(sp)
    80003654:	6da2                	ld	s11,8(sp)
    80003656:	a801                	j	80003666 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003658:	89d6                	mv	s3,s5
    8000365a:	a031                	j	80003666 <readi+0xe0>
    8000365c:	6946                	ld	s2,80(sp)
    8000365e:	7c02                	ld	s8,32(sp)
    80003660:	6ce2                	ld	s9,24(sp)
    80003662:	6d42                	ld	s10,16(sp)
    80003664:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003666:	0009851b          	sext.w	a0,s3
    8000366a:	69a6                	ld	s3,72(sp)
}
    8000366c:	70a6                	ld	ra,104(sp)
    8000366e:	7406                	ld	s0,96(sp)
    80003670:	64e6                	ld	s1,88(sp)
    80003672:	6a06                	ld	s4,64(sp)
    80003674:	7ae2                	ld	s5,56(sp)
    80003676:	7b42                	ld	s6,48(sp)
    80003678:	7ba2                	ld	s7,40(sp)
    8000367a:	6165                	addi	sp,sp,112
    8000367c:	8082                	ret
    return 0;
    8000367e:	4501                	li	a0,0
}
    80003680:	8082                	ret

0000000080003682 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003682:	457c                	lw	a5,76(a0)
    80003684:	10d7e063          	bltu	a5,a3,80003784 <writei+0x102>
{
    80003688:	7159                	addi	sp,sp,-112
    8000368a:	f486                	sd	ra,104(sp)
    8000368c:	f0a2                	sd	s0,96(sp)
    8000368e:	e8ca                	sd	s2,80(sp)
    80003690:	e0d2                	sd	s4,64(sp)
    80003692:	fc56                	sd	s5,56(sp)
    80003694:	f85a                	sd	s6,48(sp)
    80003696:	f45e                	sd	s7,40(sp)
    80003698:	1880                	addi	s0,sp,112
    8000369a:	8aaa                	mv	s5,a0
    8000369c:	8bae                	mv	s7,a1
    8000369e:	8a32                	mv	s4,a2
    800036a0:	8936                	mv	s2,a3
    800036a2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800036a4:	00e687bb          	addw	a5,a3,a4
    800036a8:	0ed7e063          	bltu	a5,a3,80003788 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800036ac:	00043737          	lui	a4,0x43
    800036b0:	0cf76e63          	bltu	a4,a5,8000378c <writei+0x10a>
    800036b4:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800036b6:	0a0b0f63          	beqz	s6,80003774 <writei+0xf2>
    800036ba:	eca6                	sd	s1,88(sp)
    800036bc:	f062                	sd	s8,32(sp)
    800036be:	ec66                	sd	s9,24(sp)
    800036c0:	e86a                	sd	s10,16(sp)
    800036c2:	e46e                	sd	s11,8(sp)
    800036c4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800036c6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800036ca:	5c7d                	li	s8,-1
    800036cc:	a825                	j	80003704 <writei+0x82>
    800036ce:	020d1d93          	slli	s11,s10,0x20
    800036d2:	020ddd93          	srli	s11,s11,0x20
    800036d6:	05848513          	addi	a0,s1,88
    800036da:	86ee                	mv	a3,s11
    800036dc:	8652                	mv	a2,s4
    800036de:	85de                	mv	a1,s7
    800036e0:	953a                	add	a0,a0,a4
    800036e2:	85ffe0ef          	jal	80001f40 <either_copyin>
    800036e6:	05850a63          	beq	a0,s8,8000373a <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800036ea:	8526                	mv	a0,s1
    800036ec:	660000ef          	jal	80003d4c <log_write>
    brelse(bp);
    800036f0:	8526                	mv	a0,s1
    800036f2:	e10ff0ef          	jal	80002d02 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800036f6:	013d09bb          	addw	s3,s10,s3
    800036fa:	012d093b          	addw	s2,s10,s2
    800036fe:	9a6e                	add	s4,s4,s11
    80003700:	0569f063          	bgeu	s3,s6,80003740 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003704:	00a9559b          	srliw	a1,s2,0xa
    80003708:	8556                	mv	a0,s5
    8000370a:	875ff0ef          	jal	80002f7e <bmap>
    8000370e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003712:	c59d                	beqz	a1,80003740 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003714:	000aa503          	lw	a0,0(s5)
    80003718:	ce2ff0ef          	jal	80002bfa <bread>
    8000371c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000371e:	3ff97713          	andi	a4,s2,1023
    80003722:	40ec87bb          	subw	a5,s9,a4
    80003726:	413b06bb          	subw	a3,s6,s3
    8000372a:	8d3e                	mv	s10,a5
    8000372c:	2781                	sext.w	a5,a5
    8000372e:	0006861b          	sext.w	a2,a3
    80003732:	f8f67ee3          	bgeu	a2,a5,800036ce <writei+0x4c>
    80003736:	8d36                	mv	s10,a3
    80003738:	bf59                	j	800036ce <writei+0x4c>
      brelse(bp);
    8000373a:	8526                	mv	a0,s1
    8000373c:	dc6ff0ef          	jal	80002d02 <brelse>
  }

  if(off > ip->size)
    80003740:	04caa783          	lw	a5,76(s5)
    80003744:	0327fa63          	bgeu	a5,s2,80003778 <writei+0xf6>
    ip->size = off;
    80003748:	052aa623          	sw	s2,76(s5)
    8000374c:	64e6                	ld	s1,88(sp)
    8000374e:	7c02                	ld	s8,32(sp)
    80003750:	6ce2                	ld	s9,24(sp)
    80003752:	6d42                	ld	s10,16(sp)
    80003754:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003756:	8556                	mv	a0,s5
    80003758:	b27ff0ef          	jal	8000327e <iupdate>

  return tot;
    8000375c:	0009851b          	sext.w	a0,s3
    80003760:	69a6                	ld	s3,72(sp)
}
    80003762:	70a6                	ld	ra,104(sp)
    80003764:	7406                	ld	s0,96(sp)
    80003766:	6946                	ld	s2,80(sp)
    80003768:	6a06                	ld	s4,64(sp)
    8000376a:	7ae2                	ld	s5,56(sp)
    8000376c:	7b42                	ld	s6,48(sp)
    8000376e:	7ba2                	ld	s7,40(sp)
    80003770:	6165                	addi	sp,sp,112
    80003772:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003774:	89da                	mv	s3,s6
    80003776:	b7c5                	j	80003756 <writei+0xd4>
    80003778:	64e6                	ld	s1,88(sp)
    8000377a:	7c02                	ld	s8,32(sp)
    8000377c:	6ce2                	ld	s9,24(sp)
    8000377e:	6d42                	ld	s10,16(sp)
    80003780:	6da2                	ld	s11,8(sp)
    80003782:	bfd1                	j	80003756 <writei+0xd4>
    return -1;
    80003784:	557d                	li	a0,-1
}
    80003786:	8082                	ret
    return -1;
    80003788:	557d                	li	a0,-1
    8000378a:	bfe1                	j	80003762 <writei+0xe0>
    return -1;
    8000378c:	557d                	li	a0,-1
    8000378e:	bfd1                	j	80003762 <writei+0xe0>

0000000080003790 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003790:	1141                	addi	sp,sp,-16
    80003792:	e406                	sd	ra,8(sp)
    80003794:	e022                	sd	s0,0(sp)
    80003796:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003798:	4639                	li	a2,14
    8000379a:	dfcfd0ef          	jal	80000d96 <strncmp>
}
    8000379e:	60a2                	ld	ra,8(sp)
    800037a0:	6402                	ld	s0,0(sp)
    800037a2:	0141                	addi	sp,sp,16
    800037a4:	8082                	ret

00000000800037a6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800037a6:	7139                	addi	sp,sp,-64
    800037a8:	fc06                	sd	ra,56(sp)
    800037aa:	f822                	sd	s0,48(sp)
    800037ac:	f426                	sd	s1,40(sp)
    800037ae:	f04a                	sd	s2,32(sp)
    800037b0:	ec4e                	sd	s3,24(sp)
    800037b2:	e852                	sd	s4,16(sp)
    800037b4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800037b6:	04451703          	lh	a4,68(a0)
    800037ba:	4785                	li	a5,1
    800037bc:	00f71a63          	bne	a4,a5,800037d0 <dirlookup+0x2a>
    800037c0:	892a                	mv	s2,a0
    800037c2:	89ae                	mv	s3,a1
    800037c4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800037c6:	457c                	lw	a5,76(a0)
    800037c8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800037ca:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800037cc:	e39d                	bnez	a5,800037f2 <dirlookup+0x4c>
    800037ce:	a095                	j	80003832 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    800037d0:	00004517          	auipc	a0,0x4
    800037d4:	d8050513          	addi	a0,a0,-640 # 80007550 <etext+0x550>
    800037d8:	fbdfc0ef          	jal	80000794 <panic>
      panic("dirlookup read");
    800037dc:	00004517          	auipc	a0,0x4
    800037e0:	d8c50513          	addi	a0,a0,-628 # 80007568 <etext+0x568>
    800037e4:	fb1fc0ef          	jal	80000794 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800037e8:	24c1                	addiw	s1,s1,16
    800037ea:	04c92783          	lw	a5,76(s2)
    800037ee:	04f4f163          	bgeu	s1,a5,80003830 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800037f2:	4741                	li	a4,16
    800037f4:	86a6                	mv	a3,s1
    800037f6:	fc040613          	addi	a2,s0,-64
    800037fa:	4581                	li	a1,0
    800037fc:	854a                	mv	a0,s2
    800037fe:	d89ff0ef          	jal	80003586 <readi>
    80003802:	47c1                	li	a5,16
    80003804:	fcf51ce3          	bne	a0,a5,800037dc <dirlookup+0x36>
    if(de.inum == 0)
    80003808:	fc045783          	lhu	a5,-64(s0)
    8000380c:	dff1                	beqz	a5,800037e8 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    8000380e:	fc240593          	addi	a1,s0,-62
    80003812:	854e                	mv	a0,s3
    80003814:	f7dff0ef          	jal	80003790 <namecmp>
    80003818:	f961                	bnez	a0,800037e8 <dirlookup+0x42>
      if(poff)
    8000381a:	000a0463          	beqz	s4,80003822 <dirlookup+0x7c>
        *poff = off;
    8000381e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003822:	fc045583          	lhu	a1,-64(s0)
    80003826:	00092503          	lw	a0,0(s2)
    8000382a:	829ff0ef          	jal	80003052 <iget>
    8000382e:	a011                	j	80003832 <dirlookup+0x8c>
  return 0;
    80003830:	4501                	li	a0,0
}
    80003832:	70e2                	ld	ra,56(sp)
    80003834:	7442                	ld	s0,48(sp)
    80003836:	74a2                	ld	s1,40(sp)
    80003838:	7902                	ld	s2,32(sp)
    8000383a:	69e2                	ld	s3,24(sp)
    8000383c:	6a42                	ld	s4,16(sp)
    8000383e:	6121                	addi	sp,sp,64
    80003840:	8082                	ret

0000000080003842 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003842:	711d                	addi	sp,sp,-96
    80003844:	ec86                	sd	ra,88(sp)
    80003846:	e8a2                	sd	s0,80(sp)
    80003848:	e4a6                	sd	s1,72(sp)
    8000384a:	e0ca                	sd	s2,64(sp)
    8000384c:	fc4e                	sd	s3,56(sp)
    8000384e:	f852                	sd	s4,48(sp)
    80003850:	f456                	sd	s5,40(sp)
    80003852:	f05a                	sd	s6,32(sp)
    80003854:	ec5e                	sd	s7,24(sp)
    80003856:	e862                	sd	s8,16(sp)
    80003858:	e466                	sd	s9,8(sp)
    8000385a:	1080                	addi	s0,sp,96
    8000385c:	84aa                	mv	s1,a0
    8000385e:	8b2e                	mv	s6,a1
    80003860:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003862:	00054703          	lbu	a4,0(a0)
    80003866:	02f00793          	li	a5,47
    8000386a:	00f70e63          	beq	a4,a5,80003886 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000386e:	856fe0ef          	jal	800018c4 <myproc>
    80003872:	15853503          	ld	a0,344(a0)
    80003876:	a87ff0ef          	jal	800032fc <idup>
    8000387a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000387c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003880:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003882:	4b85                	li	s7,1
    80003884:	a871                	j	80003920 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003886:	4585                	li	a1,1
    80003888:	4505                	li	a0,1
    8000388a:	fc8ff0ef          	jal	80003052 <iget>
    8000388e:	8a2a                	mv	s4,a0
    80003890:	b7f5                	j	8000387c <namex+0x3a>
      iunlockput(ip);
    80003892:	8552                	mv	a0,s4
    80003894:	ca9ff0ef          	jal	8000353c <iunlockput>
      return 0;
    80003898:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000389a:	8552                	mv	a0,s4
    8000389c:	60e6                	ld	ra,88(sp)
    8000389e:	6446                	ld	s0,80(sp)
    800038a0:	64a6                	ld	s1,72(sp)
    800038a2:	6906                	ld	s2,64(sp)
    800038a4:	79e2                	ld	s3,56(sp)
    800038a6:	7a42                	ld	s4,48(sp)
    800038a8:	7aa2                	ld	s5,40(sp)
    800038aa:	7b02                	ld	s6,32(sp)
    800038ac:	6be2                	ld	s7,24(sp)
    800038ae:	6c42                	ld	s8,16(sp)
    800038b0:	6ca2                	ld	s9,8(sp)
    800038b2:	6125                	addi	sp,sp,96
    800038b4:	8082                	ret
      iunlock(ip);
    800038b6:	8552                	mv	a0,s4
    800038b8:	b29ff0ef          	jal	800033e0 <iunlock>
      return ip;
    800038bc:	bff9                	j	8000389a <namex+0x58>
      iunlockput(ip);
    800038be:	8552                	mv	a0,s4
    800038c0:	c7dff0ef          	jal	8000353c <iunlockput>
      return 0;
    800038c4:	8a4e                	mv	s4,s3
    800038c6:	bfd1                	j	8000389a <namex+0x58>
  len = path - s;
    800038c8:	40998633          	sub	a2,s3,s1
    800038cc:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800038d0:	099c5063          	bge	s8,s9,80003950 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    800038d4:	4639                	li	a2,14
    800038d6:	85a6                	mv	a1,s1
    800038d8:	8556                	mv	a0,s5
    800038da:	c4cfd0ef          	jal	80000d26 <memmove>
    800038de:	84ce                	mv	s1,s3
  while(*path == '/')
    800038e0:	0004c783          	lbu	a5,0(s1)
    800038e4:	01279763          	bne	a5,s2,800038f2 <namex+0xb0>
    path++;
    800038e8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800038ea:	0004c783          	lbu	a5,0(s1)
    800038ee:	ff278de3          	beq	a5,s2,800038e8 <namex+0xa6>
    ilock(ip);
    800038f2:	8552                	mv	a0,s4
    800038f4:	a3fff0ef          	jal	80003332 <ilock>
    if(ip->type != T_DIR){
    800038f8:	044a1783          	lh	a5,68(s4)
    800038fc:	f9779be3          	bne	a5,s7,80003892 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003900:	000b0563          	beqz	s6,8000390a <namex+0xc8>
    80003904:	0004c783          	lbu	a5,0(s1)
    80003908:	d7dd                	beqz	a5,800038b6 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000390a:	4601                	li	a2,0
    8000390c:	85d6                	mv	a1,s5
    8000390e:	8552                	mv	a0,s4
    80003910:	e97ff0ef          	jal	800037a6 <dirlookup>
    80003914:	89aa                	mv	s3,a0
    80003916:	d545                	beqz	a0,800038be <namex+0x7c>
    iunlockput(ip);
    80003918:	8552                	mv	a0,s4
    8000391a:	c23ff0ef          	jal	8000353c <iunlockput>
    ip = next;
    8000391e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003920:	0004c783          	lbu	a5,0(s1)
    80003924:	01279763          	bne	a5,s2,80003932 <namex+0xf0>
    path++;
    80003928:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000392a:	0004c783          	lbu	a5,0(s1)
    8000392e:	ff278de3          	beq	a5,s2,80003928 <namex+0xe6>
  if(*path == 0)
    80003932:	cb8d                	beqz	a5,80003964 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003934:	0004c783          	lbu	a5,0(s1)
    80003938:	89a6                	mv	s3,s1
  len = path - s;
    8000393a:	4c81                	li	s9,0
    8000393c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000393e:	01278963          	beq	a5,s2,80003950 <namex+0x10e>
    80003942:	d3d9                	beqz	a5,800038c8 <namex+0x86>
    path++;
    80003944:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003946:	0009c783          	lbu	a5,0(s3)
    8000394a:	ff279ce3          	bne	a5,s2,80003942 <namex+0x100>
    8000394e:	bfad                	j	800038c8 <namex+0x86>
    memmove(name, s, len);
    80003950:	2601                	sext.w	a2,a2
    80003952:	85a6                	mv	a1,s1
    80003954:	8556                	mv	a0,s5
    80003956:	bd0fd0ef          	jal	80000d26 <memmove>
    name[len] = 0;
    8000395a:	9cd6                	add	s9,s9,s5
    8000395c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003960:	84ce                	mv	s1,s3
    80003962:	bfbd                	j	800038e0 <namex+0x9e>
  if(nameiparent){
    80003964:	f20b0be3          	beqz	s6,8000389a <namex+0x58>
    iput(ip);
    80003968:	8552                	mv	a0,s4
    8000396a:	b4bff0ef          	jal	800034b4 <iput>
    return 0;
    8000396e:	4a01                	li	s4,0
    80003970:	b72d                	j	8000389a <namex+0x58>

0000000080003972 <dirlink>:
{
    80003972:	7139                	addi	sp,sp,-64
    80003974:	fc06                	sd	ra,56(sp)
    80003976:	f822                	sd	s0,48(sp)
    80003978:	f04a                	sd	s2,32(sp)
    8000397a:	ec4e                	sd	s3,24(sp)
    8000397c:	e852                	sd	s4,16(sp)
    8000397e:	0080                	addi	s0,sp,64
    80003980:	892a                	mv	s2,a0
    80003982:	8a2e                	mv	s4,a1
    80003984:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003986:	4601                	li	a2,0
    80003988:	e1fff0ef          	jal	800037a6 <dirlookup>
    8000398c:	e535                	bnez	a0,800039f8 <dirlink+0x86>
    8000398e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003990:	04c92483          	lw	s1,76(s2)
    80003994:	c48d                	beqz	s1,800039be <dirlink+0x4c>
    80003996:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003998:	4741                	li	a4,16
    8000399a:	86a6                	mv	a3,s1
    8000399c:	fc040613          	addi	a2,s0,-64
    800039a0:	4581                	li	a1,0
    800039a2:	854a                	mv	a0,s2
    800039a4:	be3ff0ef          	jal	80003586 <readi>
    800039a8:	47c1                	li	a5,16
    800039aa:	04f51b63          	bne	a0,a5,80003a00 <dirlink+0x8e>
    if(de.inum == 0)
    800039ae:	fc045783          	lhu	a5,-64(s0)
    800039b2:	c791                	beqz	a5,800039be <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800039b4:	24c1                	addiw	s1,s1,16
    800039b6:	04c92783          	lw	a5,76(s2)
    800039ba:	fcf4efe3          	bltu	s1,a5,80003998 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    800039be:	4639                	li	a2,14
    800039c0:	85d2                	mv	a1,s4
    800039c2:	fc240513          	addi	a0,s0,-62
    800039c6:	c06fd0ef          	jal	80000dcc <strncpy>
  de.inum = inum;
    800039ca:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800039ce:	4741                	li	a4,16
    800039d0:	86a6                	mv	a3,s1
    800039d2:	fc040613          	addi	a2,s0,-64
    800039d6:	4581                	li	a1,0
    800039d8:	854a                	mv	a0,s2
    800039da:	ca9ff0ef          	jal	80003682 <writei>
    800039de:	1541                	addi	a0,a0,-16
    800039e0:	00a03533          	snez	a0,a0
    800039e4:	40a00533          	neg	a0,a0
    800039e8:	74a2                	ld	s1,40(sp)
}
    800039ea:	70e2                	ld	ra,56(sp)
    800039ec:	7442                	ld	s0,48(sp)
    800039ee:	7902                	ld	s2,32(sp)
    800039f0:	69e2                	ld	s3,24(sp)
    800039f2:	6a42                	ld	s4,16(sp)
    800039f4:	6121                	addi	sp,sp,64
    800039f6:	8082                	ret
    iput(ip);
    800039f8:	abdff0ef          	jal	800034b4 <iput>
    return -1;
    800039fc:	557d                	li	a0,-1
    800039fe:	b7f5                	j	800039ea <dirlink+0x78>
      panic("dirlink read");
    80003a00:	00004517          	auipc	a0,0x4
    80003a04:	b7850513          	addi	a0,a0,-1160 # 80007578 <etext+0x578>
    80003a08:	d8dfc0ef          	jal	80000794 <panic>

0000000080003a0c <namei>:

struct inode*
namei(char *path)
{
    80003a0c:	1101                	addi	sp,sp,-32
    80003a0e:	ec06                	sd	ra,24(sp)
    80003a10:	e822                	sd	s0,16(sp)
    80003a12:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003a14:	fe040613          	addi	a2,s0,-32
    80003a18:	4581                	li	a1,0
    80003a1a:	e29ff0ef          	jal	80003842 <namex>
}
    80003a1e:	60e2                	ld	ra,24(sp)
    80003a20:	6442                	ld	s0,16(sp)
    80003a22:	6105                	addi	sp,sp,32
    80003a24:	8082                	ret

0000000080003a26 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003a26:	1141                	addi	sp,sp,-16
    80003a28:	e406                	sd	ra,8(sp)
    80003a2a:	e022                	sd	s0,0(sp)
    80003a2c:	0800                	addi	s0,sp,16
    80003a2e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003a30:	4585                	li	a1,1
    80003a32:	e11ff0ef          	jal	80003842 <namex>
}
    80003a36:	60a2                	ld	ra,8(sp)
    80003a38:	6402                	ld	s0,0(sp)
    80003a3a:	0141                	addi	sp,sp,16
    80003a3c:	8082                	ret

0000000080003a3e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003a3e:	1101                	addi	sp,sp,-32
    80003a40:	ec06                	sd	ra,24(sp)
    80003a42:	e822                	sd	s0,16(sp)
    80003a44:	e426                	sd	s1,8(sp)
    80003a46:	e04a                	sd	s2,0(sp)
    80003a48:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003a4a:	00017917          	auipc	s2,0x17
    80003a4e:	de690913          	addi	s2,s2,-538 # 8001a830 <log>
    80003a52:	01892583          	lw	a1,24(s2)
    80003a56:	02892503          	lw	a0,40(s2)
    80003a5a:	9a0ff0ef          	jal	80002bfa <bread>
    80003a5e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003a60:	02c92603          	lw	a2,44(s2)
    80003a64:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003a66:	00c05f63          	blez	a2,80003a84 <write_head+0x46>
    80003a6a:	00017717          	auipc	a4,0x17
    80003a6e:	df670713          	addi	a4,a4,-522 # 8001a860 <log+0x30>
    80003a72:	87aa                	mv	a5,a0
    80003a74:	060a                	slli	a2,a2,0x2
    80003a76:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003a78:	4314                	lw	a3,0(a4)
    80003a7a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003a7c:	0711                	addi	a4,a4,4
    80003a7e:	0791                	addi	a5,a5,4
    80003a80:	fec79ce3          	bne	a5,a2,80003a78 <write_head+0x3a>
  }
  bwrite(buf);
    80003a84:	8526                	mv	a0,s1
    80003a86:	a4aff0ef          	jal	80002cd0 <bwrite>
  brelse(buf);
    80003a8a:	8526                	mv	a0,s1
    80003a8c:	a76ff0ef          	jal	80002d02 <brelse>
}
    80003a90:	60e2                	ld	ra,24(sp)
    80003a92:	6442                	ld	s0,16(sp)
    80003a94:	64a2                	ld	s1,8(sp)
    80003a96:	6902                	ld	s2,0(sp)
    80003a98:	6105                	addi	sp,sp,32
    80003a9a:	8082                	ret

0000000080003a9c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a9c:	00017797          	auipc	a5,0x17
    80003aa0:	dc07a783          	lw	a5,-576(a5) # 8001a85c <log+0x2c>
    80003aa4:	08f05f63          	blez	a5,80003b42 <install_trans+0xa6>
{
    80003aa8:	7139                	addi	sp,sp,-64
    80003aaa:	fc06                	sd	ra,56(sp)
    80003aac:	f822                	sd	s0,48(sp)
    80003aae:	f426                	sd	s1,40(sp)
    80003ab0:	f04a                	sd	s2,32(sp)
    80003ab2:	ec4e                	sd	s3,24(sp)
    80003ab4:	e852                	sd	s4,16(sp)
    80003ab6:	e456                	sd	s5,8(sp)
    80003ab8:	e05a                	sd	s6,0(sp)
    80003aba:	0080                	addi	s0,sp,64
    80003abc:	8b2a                	mv	s6,a0
    80003abe:	00017a97          	auipc	s5,0x17
    80003ac2:	da2a8a93          	addi	s5,s5,-606 # 8001a860 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ac6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003ac8:	00017997          	auipc	s3,0x17
    80003acc:	d6898993          	addi	s3,s3,-664 # 8001a830 <log>
    80003ad0:	a829                	j	80003aea <install_trans+0x4e>
    brelse(lbuf);
    80003ad2:	854a                	mv	a0,s2
    80003ad4:	a2eff0ef          	jal	80002d02 <brelse>
    brelse(dbuf);
    80003ad8:	8526                	mv	a0,s1
    80003ada:	a28ff0ef          	jal	80002d02 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ade:	2a05                	addiw	s4,s4,1
    80003ae0:	0a91                	addi	s5,s5,4
    80003ae2:	02c9a783          	lw	a5,44(s3)
    80003ae6:	04fa5463          	bge	s4,a5,80003b2e <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003aea:	0189a583          	lw	a1,24(s3)
    80003aee:	014585bb          	addw	a1,a1,s4
    80003af2:	2585                	addiw	a1,a1,1
    80003af4:	0289a503          	lw	a0,40(s3)
    80003af8:	902ff0ef          	jal	80002bfa <bread>
    80003afc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003afe:	000aa583          	lw	a1,0(s5)
    80003b02:	0289a503          	lw	a0,40(s3)
    80003b06:	8f4ff0ef          	jal	80002bfa <bread>
    80003b0a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003b0c:	40000613          	li	a2,1024
    80003b10:	05890593          	addi	a1,s2,88
    80003b14:	05850513          	addi	a0,a0,88
    80003b18:	a0efd0ef          	jal	80000d26 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003b1c:	8526                	mv	a0,s1
    80003b1e:	9b2ff0ef          	jal	80002cd0 <bwrite>
    if(recovering == 0)
    80003b22:	fa0b18e3          	bnez	s6,80003ad2 <install_trans+0x36>
      bunpin(dbuf);
    80003b26:	8526                	mv	a0,s1
    80003b28:	a96ff0ef          	jal	80002dbe <bunpin>
    80003b2c:	b75d                	j	80003ad2 <install_trans+0x36>
}
    80003b2e:	70e2                	ld	ra,56(sp)
    80003b30:	7442                	ld	s0,48(sp)
    80003b32:	74a2                	ld	s1,40(sp)
    80003b34:	7902                	ld	s2,32(sp)
    80003b36:	69e2                	ld	s3,24(sp)
    80003b38:	6a42                	ld	s4,16(sp)
    80003b3a:	6aa2                	ld	s5,8(sp)
    80003b3c:	6b02                	ld	s6,0(sp)
    80003b3e:	6121                	addi	sp,sp,64
    80003b40:	8082                	ret
    80003b42:	8082                	ret

0000000080003b44 <initlog>:
{
    80003b44:	7179                	addi	sp,sp,-48
    80003b46:	f406                	sd	ra,40(sp)
    80003b48:	f022                	sd	s0,32(sp)
    80003b4a:	ec26                	sd	s1,24(sp)
    80003b4c:	e84a                	sd	s2,16(sp)
    80003b4e:	e44e                	sd	s3,8(sp)
    80003b50:	1800                	addi	s0,sp,48
    80003b52:	892a                	mv	s2,a0
    80003b54:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003b56:	00017497          	auipc	s1,0x17
    80003b5a:	cda48493          	addi	s1,s1,-806 # 8001a830 <log>
    80003b5e:	00004597          	auipc	a1,0x4
    80003b62:	a2a58593          	addi	a1,a1,-1494 # 80007588 <etext+0x588>
    80003b66:	8526                	mv	a0,s1
    80003b68:	80efd0ef          	jal	80000b76 <initlock>
  log.start = sb->logstart;
    80003b6c:	0149a583          	lw	a1,20(s3)
    80003b70:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003b72:	0109a783          	lw	a5,16(s3)
    80003b76:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003b78:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003b7c:	854a                	mv	a0,s2
    80003b7e:	87cff0ef          	jal	80002bfa <bread>
  log.lh.n = lh->n;
    80003b82:	4d30                	lw	a2,88(a0)
    80003b84:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003b86:	00c05f63          	blez	a2,80003ba4 <initlog+0x60>
    80003b8a:	87aa                	mv	a5,a0
    80003b8c:	00017717          	auipc	a4,0x17
    80003b90:	cd470713          	addi	a4,a4,-812 # 8001a860 <log+0x30>
    80003b94:	060a                	slli	a2,a2,0x2
    80003b96:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003b98:	4ff4                	lw	a3,92(a5)
    80003b9a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003b9c:	0791                	addi	a5,a5,4
    80003b9e:	0711                	addi	a4,a4,4
    80003ba0:	fec79ce3          	bne	a5,a2,80003b98 <initlog+0x54>
  brelse(buf);
    80003ba4:	95eff0ef          	jal	80002d02 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003ba8:	4505                	li	a0,1
    80003baa:	ef3ff0ef          	jal	80003a9c <install_trans>
  log.lh.n = 0;
    80003bae:	00017797          	auipc	a5,0x17
    80003bb2:	ca07a723          	sw	zero,-850(a5) # 8001a85c <log+0x2c>
  write_head(); // clear the log
    80003bb6:	e89ff0ef          	jal	80003a3e <write_head>
}
    80003bba:	70a2                	ld	ra,40(sp)
    80003bbc:	7402                	ld	s0,32(sp)
    80003bbe:	64e2                	ld	s1,24(sp)
    80003bc0:	6942                	ld	s2,16(sp)
    80003bc2:	69a2                	ld	s3,8(sp)
    80003bc4:	6145                	addi	sp,sp,48
    80003bc6:	8082                	ret

0000000080003bc8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003bc8:	1101                	addi	sp,sp,-32
    80003bca:	ec06                	sd	ra,24(sp)
    80003bcc:	e822                	sd	s0,16(sp)
    80003bce:	e426                	sd	s1,8(sp)
    80003bd0:	e04a                	sd	s2,0(sp)
    80003bd2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003bd4:	00017517          	auipc	a0,0x17
    80003bd8:	c5c50513          	addi	a0,a0,-932 # 8001a830 <log>
    80003bdc:	81afd0ef          	jal	80000bf6 <acquire>
  while(1){
    if(log.committing){
    80003be0:	00017497          	auipc	s1,0x17
    80003be4:	c5048493          	addi	s1,s1,-944 # 8001a830 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003be8:	4979                	li	s2,30
    80003bea:	a029                	j	80003bf4 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003bec:	85a6                	mv	a1,s1
    80003bee:	8526                	mv	a0,s1
    80003bf0:	838fe0ef          	jal	80001c28 <sleep>
    if(log.committing){
    80003bf4:	50dc                	lw	a5,36(s1)
    80003bf6:	fbfd                	bnez	a5,80003bec <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003bf8:	5098                	lw	a4,32(s1)
    80003bfa:	2705                	addiw	a4,a4,1
    80003bfc:	0027179b          	slliw	a5,a4,0x2
    80003c00:	9fb9                	addw	a5,a5,a4
    80003c02:	0017979b          	slliw	a5,a5,0x1
    80003c06:	54d4                	lw	a3,44(s1)
    80003c08:	9fb5                	addw	a5,a5,a3
    80003c0a:	00f95763          	bge	s2,a5,80003c18 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003c0e:	85a6                	mv	a1,s1
    80003c10:	8526                	mv	a0,s1
    80003c12:	816fe0ef          	jal	80001c28 <sleep>
    80003c16:	bff9                	j	80003bf4 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003c18:	00017517          	auipc	a0,0x17
    80003c1c:	c1850513          	addi	a0,a0,-1000 # 8001a830 <log>
    80003c20:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003c22:	86cfd0ef          	jal	80000c8e <release>
      break;
    }
  }
}
    80003c26:	60e2                	ld	ra,24(sp)
    80003c28:	6442                	ld	s0,16(sp)
    80003c2a:	64a2                	ld	s1,8(sp)
    80003c2c:	6902                	ld	s2,0(sp)
    80003c2e:	6105                	addi	sp,sp,32
    80003c30:	8082                	ret

0000000080003c32 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003c32:	7139                	addi	sp,sp,-64
    80003c34:	fc06                	sd	ra,56(sp)
    80003c36:	f822                	sd	s0,48(sp)
    80003c38:	f426                	sd	s1,40(sp)
    80003c3a:	f04a                	sd	s2,32(sp)
    80003c3c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003c3e:	00017497          	auipc	s1,0x17
    80003c42:	bf248493          	addi	s1,s1,-1038 # 8001a830 <log>
    80003c46:	8526                	mv	a0,s1
    80003c48:	faffc0ef          	jal	80000bf6 <acquire>
  log.outstanding -= 1;
    80003c4c:	509c                	lw	a5,32(s1)
    80003c4e:	37fd                	addiw	a5,a5,-1
    80003c50:	0007891b          	sext.w	s2,a5
    80003c54:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003c56:	50dc                	lw	a5,36(s1)
    80003c58:	ef9d                	bnez	a5,80003c96 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003c5a:	04091763          	bnez	s2,80003ca8 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003c5e:	00017497          	auipc	s1,0x17
    80003c62:	bd248493          	addi	s1,s1,-1070 # 8001a830 <log>
    80003c66:	4785                	li	a5,1
    80003c68:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003c6a:	8526                	mv	a0,s1
    80003c6c:	822fd0ef          	jal	80000c8e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003c70:	54dc                	lw	a5,44(s1)
    80003c72:	04f04b63          	bgtz	a5,80003cc8 <end_op+0x96>
    acquire(&log.lock);
    80003c76:	00017497          	auipc	s1,0x17
    80003c7a:	bba48493          	addi	s1,s1,-1094 # 8001a830 <log>
    80003c7e:	8526                	mv	a0,s1
    80003c80:	f77fc0ef          	jal	80000bf6 <acquire>
    log.committing = 0;
    80003c84:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003c88:	8526                	mv	a0,s1
    80003c8a:	febfd0ef          	jal	80001c74 <wakeup>
    release(&log.lock);
    80003c8e:	8526                	mv	a0,s1
    80003c90:	ffffc0ef          	jal	80000c8e <release>
}
    80003c94:	a025                	j	80003cbc <end_op+0x8a>
    80003c96:	ec4e                	sd	s3,24(sp)
    80003c98:	e852                	sd	s4,16(sp)
    80003c9a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003c9c:	00004517          	auipc	a0,0x4
    80003ca0:	8f450513          	addi	a0,a0,-1804 # 80007590 <etext+0x590>
    80003ca4:	af1fc0ef          	jal	80000794 <panic>
    wakeup(&log);
    80003ca8:	00017497          	auipc	s1,0x17
    80003cac:	b8848493          	addi	s1,s1,-1144 # 8001a830 <log>
    80003cb0:	8526                	mv	a0,s1
    80003cb2:	fc3fd0ef          	jal	80001c74 <wakeup>
  release(&log.lock);
    80003cb6:	8526                	mv	a0,s1
    80003cb8:	fd7fc0ef          	jal	80000c8e <release>
}
    80003cbc:	70e2                	ld	ra,56(sp)
    80003cbe:	7442                	ld	s0,48(sp)
    80003cc0:	74a2                	ld	s1,40(sp)
    80003cc2:	7902                	ld	s2,32(sp)
    80003cc4:	6121                	addi	sp,sp,64
    80003cc6:	8082                	ret
    80003cc8:	ec4e                	sd	s3,24(sp)
    80003cca:	e852                	sd	s4,16(sp)
    80003ccc:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003cce:	00017a97          	auipc	s5,0x17
    80003cd2:	b92a8a93          	addi	s5,s5,-1134 # 8001a860 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003cd6:	00017a17          	auipc	s4,0x17
    80003cda:	b5aa0a13          	addi	s4,s4,-1190 # 8001a830 <log>
    80003cde:	018a2583          	lw	a1,24(s4)
    80003ce2:	012585bb          	addw	a1,a1,s2
    80003ce6:	2585                	addiw	a1,a1,1
    80003ce8:	028a2503          	lw	a0,40(s4)
    80003cec:	f0ffe0ef          	jal	80002bfa <bread>
    80003cf0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003cf2:	000aa583          	lw	a1,0(s5)
    80003cf6:	028a2503          	lw	a0,40(s4)
    80003cfa:	f01fe0ef          	jal	80002bfa <bread>
    80003cfe:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003d00:	40000613          	li	a2,1024
    80003d04:	05850593          	addi	a1,a0,88
    80003d08:	05848513          	addi	a0,s1,88
    80003d0c:	81afd0ef          	jal	80000d26 <memmove>
    bwrite(to);  // write the log
    80003d10:	8526                	mv	a0,s1
    80003d12:	fbffe0ef          	jal	80002cd0 <bwrite>
    brelse(from);
    80003d16:	854e                	mv	a0,s3
    80003d18:	febfe0ef          	jal	80002d02 <brelse>
    brelse(to);
    80003d1c:	8526                	mv	a0,s1
    80003d1e:	fe5fe0ef          	jal	80002d02 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d22:	2905                	addiw	s2,s2,1
    80003d24:	0a91                	addi	s5,s5,4
    80003d26:	02ca2783          	lw	a5,44(s4)
    80003d2a:	faf94ae3          	blt	s2,a5,80003cde <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003d2e:	d11ff0ef          	jal	80003a3e <write_head>
    install_trans(0); // Now install writes to home locations
    80003d32:	4501                	li	a0,0
    80003d34:	d69ff0ef          	jal	80003a9c <install_trans>
    log.lh.n = 0;
    80003d38:	00017797          	auipc	a5,0x17
    80003d3c:	b207a223          	sw	zero,-1244(a5) # 8001a85c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003d40:	cffff0ef          	jal	80003a3e <write_head>
    80003d44:	69e2                	ld	s3,24(sp)
    80003d46:	6a42                	ld	s4,16(sp)
    80003d48:	6aa2                	ld	s5,8(sp)
    80003d4a:	b735                	j	80003c76 <end_op+0x44>

0000000080003d4c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003d4c:	1101                	addi	sp,sp,-32
    80003d4e:	ec06                	sd	ra,24(sp)
    80003d50:	e822                	sd	s0,16(sp)
    80003d52:	e426                	sd	s1,8(sp)
    80003d54:	e04a                	sd	s2,0(sp)
    80003d56:	1000                	addi	s0,sp,32
    80003d58:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003d5a:	00017917          	auipc	s2,0x17
    80003d5e:	ad690913          	addi	s2,s2,-1322 # 8001a830 <log>
    80003d62:	854a                	mv	a0,s2
    80003d64:	e93fc0ef          	jal	80000bf6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003d68:	02c92603          	lw	a2,44(s2)
    80003d6c:	47f5                	li	a5,29
    80003d6e:	06c7c363          	blt	a5,a2,80003dd4 <log_write+0x88>
    80003d72:	00017797          	auipc	a5,0x17
    80003d76:	ada7a783          	lw	a5,-1318(a5) # 8001a84c <log+0x1c>
    80003d7a:	37fd                	addiw	a5,a5,-1
    80003d7c:	04f65c63          	bge	a2,a5,80003dd4 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003d80:	00017797          	auipc	a5,0x17
    80003d84:	ad07a783          	lw	a5,-1328(a5) # 8001a850 <log+0x20>
    80003d88:	04f05c63          	blez	a5,80003de0 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003d8c:	4781                	li	a5,0
    80003d8e:	04c05f63          	blez	a2,80003dec <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003d92:	44cc                	lw	a1,12(s1)
    80003d94:	00017717          	auipc	a4,0x17
    80003d98:	acc70713          	addi	a4,a4,-1332 # 8001a860 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003d9c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003d9e:	4314                	lw	a3,0(a4)
    80003da0:	04b68663          	beq	a3,a1,80003dec <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003da4:	2785                	addiw	a5,a5,1
    80003da6:	0711                	addi	a4,a4,4
    80003da8:	fef61be3          	bne	a2,a5,80003d9e <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003dac:	0621                	addi	a2,a2,8
    80003dae:	060a                	slli	a2,a2,0x2
    80003db0:	00017797          	auipc	a5,0x17
    80003db4:	a8078793          	addi	a5,a5,-1408 # 8001a830 <log>
    80003db8:	97b2                	add	a5,a5,a2
    80003dba:	44d8                	lw	a4,12(s1)
    80003dbc:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003dbe:	8526                	mv	a0,s1
    80003dc0:	fcbfe0ef          	jal	80002d8a <bpin>
    log.lh.n++;
    80003dc4:	00017717          	auipc	a4,0x17
    80003dc8:	a6c70713          	addi	a4,a4,-1428 # 8001a830 <log>
    80003dcc:	575c                	lw	a5,44(a4)
    80003dce:	2785                	addiw	a5,a5,1
    80003dd0:	d75c                	sw	a5,44(a4)
    80003dd2:	a80d                	j	80003e04 <log_write+0xb8>
    panic("too big a transaction");
    80003dd4:	00003517          	auipc	a0,0x3
    80003dd8:	7cc50513          	addi	a0,a0,1996 # 800075a0 <etext+0x5a0>
    80003ddc:	9b9fc0ef          	jal	80000794 <panic>
    panic("log_write outside of trans");
    80003de0:	00003517          	auipc	a0,0x3
    80003de4:	7d850513          	addi	a0,a0,2008 # 800075b8 <etext+0x5b8>
    80003de8:	9adfc0ef          	jal	80000794 <panic>
  log.lh.block[i] = b->blockno;
    80003dec:	00878693          	addi	a3,a5,8
    80003df0:	068a                	slli	a3,a3,0x2
    80003df2:	00017717          	auipc	a4,0x17
    80003df6:	a3e70713          	addi	a4,a4,-1474 # 8001a830 <log>
    80003dfa:	9736                	add	a4,a4,a3
    80003dfc:	44d4                	lw	a3,12(s1)
    80003dfe:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003e00:	faf60fe3          	beq	a2,a5,80003dbe <log_write+0x72>
  }
  release(&log.lock);
    80003e04:	00017517          	auipc	a0,0x17
    80003e08:	a2c50513          	addi	a0,a0,-1492 # 8001a830 <log>
    80003e0c:	e83fc0ef          	jal	80000c8e <release>
}
    80003e10:	60e2                	ld	ra,24(sp)
    80003e12:	6442                	ld	s0,16(sp)
    80003e14:	64a2                	ld	s1,8(sp)
    80003e16:	6902                	ld	s2,0(sp)
    80003e18:	6105                	addi	sp,sp,32
    80003e1a:	8082                	ret

0000000080003e1c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003e1c:	1101                	addi	sp,sp,-32
    80003e1e:	ec06                	sd	ra,24(sp)
    80003e20:	e822                	sd	s0,16(sp)
    80003e22:	e426                	sd	s1,8(sp)
    80003e24:	e04a                	sd	s2,0(sp)
    80003e26:	1000                	addi	s0,sp,32
    80003e28:	84aa                	mv	s1,a0
    80003e2a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003e2c:	00003597          	auipc	a1,0x3
    80003e30:	7ac58593          	addi	a1,a1,1964 # 800075d8 <etext+0x5d8>
    80003e34:	0521                	addi	a0,a0,8
    80003e36:	d41fc0ef          	jal	80000b76 <initlock>
  lk->name = name;
    80003e3a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003e3e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003e42:	0204a423          	sw	zero,40(s1)
}
    80003e46:	60e2                	ld	ra,24(sp)
    80003e48:	6442                	ld	s0,16(sp)
    80003e4a:	64a2                	ld	s1,8(sp)
    80003e4c:	6902                	ld	s2,0(sp)
    80003e4e:	6105                	addi	sp,sp,32
    80003e50:	8082                	ret

0000000080003e52 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003e52:	1101                	addi	sp,sp,-32
    80003e54:	ec06                	sd	ra,24(sp)
    80003e56:	e822                	sd	s0,16(sp)
    80003e58:	e426                	sd	s1,8(sp)
    80003e5a:	e04a                	sd	s2,0(sp)
    80003e5c:	1000                	addi	s0,sp,32
    80003e5e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003e60:	00850913          	addi	s2,a0,8
    80003e64:	854a                	mv	a0,s2
    80003e66:	d91fc0ef          	jal	80000bf6 <acquire>
  while (lk->locked) {
    80003e6a:	409c                	lw	a5,0(s1)
    80003e6c:	c799                	beqz	a5,80003e7a <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003e6e:	85ca                	mv	a1,s2
    80003e70:	8526                	mv	a0,s1
    80003e72:	db7fd0ef          	jal	80001c28 <sleep>
  while (lk->locked) {
    80003e76:	409c                	lw	a5,0(s1)
    80003e78:	fbfd                	bnez	a5,80003e6e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003e7a:	4785                	li	a5,1
    80003e7c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003e7e:	a47fd0ef          	jal	800018c4 <myproc>
    80003e82:	591c                	lw	a5,48(a0)
    80003e84:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003e86:	854a                	mv	a0,s2
    80003e88:	e07fc0ef          	jal	80000c8e <release>
}
    80003e8c:	60e2                	ld	ra,24(sp)
    80003e8e:	6442                	ld	s0,16(sp)
    80003e90:	64a2                	ld	s1,8(sp)
    80003e92:	6902                	ld	s2,0(sp)
    80003e94:	6105                	addi	sp,sp,32
    80003e96:	8082                	ret

0000000080003e98 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003e98:	1101                	addi	sp,sp,-32
    80003e9a:	ec06                	sd	ra,24(sp)
    80003e9c:	e822                	sd	s0,16(sp)
    80003e9e:	e426                	sd	s1,8(sp)
    80003ea0:	e04a                	sd	s2,0(sp)
    80003ea2:	1000                	addi	s0,sp,32
    80003ea4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ea6:	00850913          	addi	s2,a0,8
    80003eaa:	854a                	mv	a0,s2
    80003eac:	d4bfc0ef          	jal	80000bf6 <acquire>
  lk->locked = 0;
    80003eb0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003eb4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003eb8:	8526                	mv	a0,s1
    80003eba:	dbbfd0ef          	jal	80001c74 <wakeup>
  release(&lk->lk);
    80003ebe:	854a                	mv	a0,s2
    80003ec0:	dcffc0ef          	jal	80000c8e <release>
}
    80003ec4:	60e2                	ld	ra,24(sp)
    80003ec6:	6442                	ld	s0,16(sp)
    80003ec8:	64a2                	ld	s1,8(sp)
    80003eca:	6902                	ld	s2,0(sp)
    80003ecc:	6105                	addi	sp,sp,32
    80003ece:	8082                	ret

0000000080003ed0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ed0:	7179                	addi	sp,sp,-48
    80003ed2:	f406                	sd	ra,40(sp)
    80003ed4:	f022                	sd	s0,32(sp)
    80003ed6:	ec26                	sd	s1,24(sp)
    80003ed8:	e84a                	sd	s2,16(sp)
    80003eda:	1800                	addi	s0,sp,48
    80003edc:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003ede:	00850913          	addi	s2,a0,8
    80003ee2:	854a                	mv	a0,s2
    80003ee4:	d13fc0ef          	jal	80000bf6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ee8:	409c                	lw	a5,0(s1)
    80003eea:	ef81                	bnez	a5,80003f02 <holdingsleep+0x32>
    80003eec:	4481                	li	s1,0
  release(&lk->lk);
    80003eee:	854a                	mv	a0,s2
    80003ef0:	d9ffc0ef          	jal	80000c8e <release>
  return r;
}
    80003ef4:	8526                	mv	a0,s1
    80003ef6:	70a2                	ld	ra,40(sp)
    80003ef8:	7402                	ld	s0,32(sp)
    80003efa:	64e2                	ld	s1,24(sp)
    80003efc:	6942                	ld	s2,16(sp)
    80003efe:	6145                	addi	sp,sp,48
    80003f00:	8082                	ret
    80003f02:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003f04:	0284a983          	lw	s3,40(s1)
    80003f08:	9bdfd0ef          	jal	800018c4 <myproc>
    80003f0c:	5904                	lw	s1,48(a0)
    80003f0e:	413484b3          	sub	s1,s1,s3
    80003f12:	0014b493          	seqz	s1,s1
    80003f16:	69a2                	ld	s3,8(sp)
    80003f18:	bfd9                	j	80003eee <holdingsleep+0x1e>

0000000080003f1a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003f1a:	1141                	addi	sp,sp,-16
    80003f1c:	e406                	sd	ra,8(sp)
    80003f1e:	e022                	sd	s0,0(sp)
    80003f20:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003f22:	00003597          	auipc	a1,0x3
    80003f26:	6c658593          	addi	a1,a1,1734 # 800075e8 <etext+0x5e8>
    80003f2a:	00017517          	auipc	a0,0x17
    80003f2e:	a4e50513          	addi	a0,a0,-1458 # 8001a978 <ftable>
    80003f32:	c45fc0ef          	jal	80000b76 <initlock>
}
    80003f36:	60a2                	ld	ra,8(sp)
    80003f38:	6402                	ld	s0,0(sp)
    80003f3a:	0141                	addi	sp,sp,16
    80003f3c:	8082                	ret

0000000080003f3e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003f3e:	1101                	addi	sp,sp,-32
    80003f40:	ec06                	sd	ra,24(sp)
    80003f42:	e822                	sd	s0,16(sp)
    80003f44:	e426                	sd	s1,8(sp)
    80003f46:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003f48:	00017517          	auipc	a0,0x17
    80003f4c:	a3050513          	addi	a0,a0,-1488 # 8001a978 <ftable>
    80003f50:	ca7fc0ef          	jal	80000bf6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003f54:	00017497          	auipc	s1,0x17
    80003f58:	a3c48493          	addi	s1,s1,-1476 # 8001a990 <ftable+0x18>
    80003f5c:	00018717          	auipc	a4,0x18
    80003f60:	9d470713          	addi	a4,a4,-1580 # 8001b930 <disk>
    if(f->ref == 0){
    80003f64:	40dc                	lw	a5,4(s1)
    80003f66:	cf89                	beqz	a5,80003f80 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003f68:	02848493          	addi	s1,s1,40
    80003f6c:	fee49ce3          	bne	s1,a4,80003f64 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003f70:	00017517          	auipc	a0,0x17
    80003f74:	a0850513          	addi	a0,a0,-1528 # 8001a978 <ftable>
    80003f78:	d17fc0ef          	jal	80000c8e <release>
  return 0;
    80003f7c:	4481                	li	s1,0
    80003f7e:	a809                	j	80003f90 <filealloc+0x52>
      f->ref = 1;
    80003f80:	4785                	li	a5,1
    80003f82:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003f84:	00017517          	auipc	a0,0x17
    80003f88:	9f450513          	addi	a0,a0,-1548 # 8001a978 <ftable>
    80003f8c:	d03fc0ef          	jal	80000c8e <release>
}
    80003f90:	8526                	mv	a0,s1
    80003f92:	60e2                	ld	ra,24(sp)
    80003f94:	6442                	ld	s0,16(sp)
    80003f96:	64a2                	ld	s1,8(sp)
    80003f98:	6105                	addi	sp,sp,32
    80003f9a:	8082                	ret

0000000080003f9c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003f9c:	1101                	addi	sp,sp,-32
    80003f9e:	ec06                	sd	ra,24(sp)
    80003fa0:	e822                	sd	s0,16(sp)
    80003fa2:	e426                	sd	s1,8(sp)
    80003fa4:	1000                	addi	s0,sp,32
    80003fa6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003fa8:	00017517          	auipc	a0,0x17
    80003fac:	9d050513          	addi	a0,a0,-1584 # 8001a978 <ftable>
    80003fb0:	c47fc0ef          	jal	80000bf6 <acquire>
  if(f->ref < 1)
    80003fb4:	40dc                	lw	a5,4(s1)
    80003fb6:	02f05063          	blez	a5,80003fd6 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003fba:	2785                	addiw	a5,a5,1
    80003fbc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003fbe:	00017517          	auipc	a0,0x17
    80003fc2:	9ba50513          	addi	a0,a0,-1606 # 8001a978 <ftable>
    80003fc6:	cc9fc0ef          	jal	80000c8e <release>
  return f;
}
    80003fca:	8526                	mv	a0,s1
    80003fcc:	60e2                	ld	ra,24(sp)
    80003fce:	6442                	ld	s0,16(sp)
    80003fd0:	64a2                	ld	s1,8(sp)
    80003fd2:	6105                	addi	sp,sp,32
    80003fd4:	8082                	ret
    panic("filedup");
    80003fd6:	00003517          	auipc	a0,0x3
    80003fda:	61a50513          	addi	a0,a0,1562 # 800075f0 <etext+0x5f0>
    80003fde:	fb6fc0ef          	jal	80000794 <panic>

0000000080003fe2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003fe2:	7139                	addi	sp,sp,-64
    80003fe4:	fc06                	sd	ra,56(sp)
    80003fe6:	f822                	sd	s0,48(sp)
    80003fe8:	f426                	sd	s1,40(sp)
    80003fea:	0080                	addi	s0,sp,64
    80003fec:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003fee:	00017517          	auipc	a0,0x17
    80003ff2:	98a50513          	addi	a0,a0,-1654 # 8001a978 <ftable>
    80003ff6:	c01fc0ef          	jal	80000bf6 <acquire>
  if(f->ref < 1)
    80003ffa:	40dc                	lw	a5,4(s1)
    80003ffc:	04f05a63          	blez	a5,80004050 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80004000:	37fd                	addiw	a5,a5,-1
    80004002:	0007871b          	sext.w	a4,a5
    80004006:	c0dc                	sw	a5,4(s1)
    80004008:	04e04e63          	bgtz	a4,80004064 <fileclose+0x82>
    8000400c:	f04a                	sd	s2,32(sp)
    8000400e:	ec4e                	sd	s3,24(sp)
    80004010:	e852                	sd	s4,16(sp)
    80004012:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004014:	0004a903          	lw	s2,0(s1)
    80004018:	0094ca83          	lbu	s5,9(s1)
    8000401c:	0104ba03          	ld	s4,16(s1)
    80004020:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004024:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004028:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000402c:	00017517          	auipc	a0,0x17
    80004030:	94c50513          	addi	a0,a0,-1716 # 8001a978 <ftable>
    80004034:	c5bfc0ef          	jal	80000c8e <release>

  if(ff.type == FD_PIPE){
    80004038:	4785                	li	a5,1
    8000403a:	04f90063          	beq	s2,a5,8000407a <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000403e:	3979                	addiw	s2,s2,-2
    80004040:	4785                	li	a5,1
    80004042:	0527f563          	bgeu	a5,s2,8000408c <fileclose+0xaa>
    80004046:	7902                	ld	s2,32(sp)
    80004048:	69e2                	ld	s3,24(sp)
    8000404a:	6a42                	ld	s4,16(sp)
    8000404c:	6aa2                	ld	s5,8(sp)
    8000404e:	a00d                	j	80004070 <fileclose+0x8e>
    80004050:	f04a                	sd	s2,32(sp)
    80004052:	ec4e                	sd	s3,24(sp)
    80004054:	e852                	sd	s4,16(sp)
    80004056:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004058:	00003517          	auipc	a0,0x3
    8000405c:	5a050513          	addi	a0,a0,1440 # 800075f8 <etext+0x5f8>
    80004060:	f34fc0ef          	jal	80000794 <panic>
    release(&ftable.lock);
    80004064:	00017517          	auipc	a0,0x17
    80004068:	91450513          	addi	a0,a0,-1772 # 8001a978 <ftable>
    8000406c:	c23fc0ef          	jal	80000c8e <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004070:	70e2                	ld	ra,56(sp)
    80004072:	7442                	ld	s0,48(sp)
    80004074:	74a2                	ld	s1,40(sp)
    80004076:	6121                	addi	sp,sp,64
    80004078:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000407a:	85d6                	mv	a1,s5
    8000407c:	8552                	mv	a0,s4
    8000407e:	336000ef          	jal	800043b4 <pipeclose>
    80004082:	7902                	ld	s2,32(sp)
    80004084:	69e2                	ld	s3,24(sp)
    80004086:	6a42                	ld	s4,16(sp)
    80004088:	6aa2                	ld	s5,8(sp)
    8000408a:	b7dd                	j	80004070 <fileclose+0x8e>
    begin_op();
    8000408c:	b3dff0ef          	jal	80003bc8 <begin_op>
    iput(ff.ip);
    80004090:	854e                	mv	a0,s3
    80004092:	c22ff0ef          	jal	800034b4 <iput>
    end_op();
    80004096:	b9dff0ef          	jal	80003c32 <end_op>
    8000409a:	7902                	ld	s2,32(sp)
    8000409c:	69e2                	ld	s3,24(sp)
    8000409e:	6a42                	ld	s4,16(sp)
    800040a0:	6aa2                	ld	s5,8(sp)
    800040a2:	b7f9                	j	80004070 <fileclose+0x8e>

00000000800040a4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800040a4:	715d                	addi	sp,sp,-80
    800040a6:	e486                	sd	ra,72(sp)
    800040a8:	e0a2                	sd	s0,64(sp)
    800040aa:	fc26                	sd	s1,56(sp)
    800040ac:	f44e                	sd	s3,40(sp)
    800040ae:	0880                	addi	s0,sp,80
    800040b0:	84aa                	mv	s1,a0
    800040b2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800040b4:	811fd0ef          	jal	800018c4 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800040b8:	409c                	lw	a5,0(s1)
    800040ba:	37f9                	addiw	a5,a5,-2
    800040bc:	4705                	li	a4,1
    800040be:	04f76063          	bltu	a4,a5,800040fe <filestat+0x5a>
    800040c2:	f84a                	sd	s2,48(sp)
    800040c4:	892a                	mv	s2,a0
    ilock(f->ip);
    800040c6:	6c88                	ld	a0,24(s1)
    800040c8:	a6aff0ef          	jal	80003332 <ilock>
    stati(f->ip, &st);
    800040cc:	fb840593          	addi	a1,s0,-72
    800040d0:	6c88                	ld	a0,24(s1)
    800040d2:	c8aff0ef          	jal	8000355c <stati>
    iunlock(f->ip);
    800040d6:	6c88                	ld	a0,24(s1)
    800040d8:	b08ff0ef          	jal	800033e0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800040dc:	46e1                	li	a3,24
    800040de:	fb840613          	addi	a2,s0,-72
    800040e2:	85ce                	mv	a1,s3
    800040e4:	05093503          	ld	a0,80(s2)
    800040e8:	c40fd0ef          	jal	80001528 <copyout>
    800040ec:	41f5551b          	sraiw	a0,a0,0x1f
    800040f0:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800040f2:	60a6                	ld	ra,72(sp)
    800040f4:	6406                	ld	s0,64(sp)
    800040f6:	74e2                	ld	s1,56(sp)
    800040f8:	79a2                	ld	s3,40(sp)
    800040fa:	6161                	addi	sp,sp,80
    800040fc:	8082                	ret
  return -1;
    800040fe:	557d                	li	a0,-1
    80004100:	bfcd                	j	800040f2 <filestat+0x4e>

0000000080004102 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004102:	7179                	addi	sp,sp,-48
    80004104:	f406                	sd	ra,40(sp)
    80004106:	f022                	sd	s0,32(sp)
    80004108:	e84a                	sd	s2,16(sp)
    8000410a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000410c:	00854783          	lbu	a5,8(a0)
    80004110:	cfd1                	beqz	a5,800041ac <fileread+0xaa>
    80004112:	ec26                	sd	s1,24(sp)
    80004114:	e44e                	sd	s3,8(sp)
    80004116:	84aa                	mv	s1,a0
    80004118:	89ae                	mv	s3,a1
    8000411a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000411c:	411c                	lw	a5,0(a0)
    8000411e:	4705                	li	a4,1
    80004120:	04e78363          	beq	a5,a4,80004166 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004124:	470d                	li	a4,3
    80004126:	04e78763          	beq	a5,a4,80004174 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000412a:	4709                	li	a4,2
    8000412c:	06e79a63          	bne	a5,a4,800041a0 <fileread+0x9e>
    ilock(f->ip);
    80004130:	6d08                	ld	a0,24(a0)
    80004132:	a00ff0ef          	jal	80003332 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004136:	874a                	mv	a4,s2
    80004138:	5094                	lw	a3,32(s1)
    8000413a:	864e                	mv	a2,s3
    8000413c:	4585                	li	a1,1
    8000413e:	6c88                	ld	a0,24(s1)
    80004140:	c46ff0ef          	jal	80003586 <readi>
    80004144:	892a                	mv	s2,a0
    80004146:	00a05563          	blez	a0,80004150 <fileread+0x4e>
      f->off += r;
    8000414a:	509c                	lw	a5,32(s1)
    8000414c:	9fa9                	addw	a5,a5,a0
    8000414e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004150:	6c88                	ld	a0,24(s1)
    80004152:	a8eff0ef          	jal	800033e0 <iunlock>
    80004156:	64e2                	ld	s1,24(sp)
    80004158:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000415a:	854a                	mv	a0,s2
    8000415c:	70a2                	ld	ra,40(sp)
    8000415e:	7402                	ld	s0,32(sp)
    80004160:	6942                	ld	s2,16(sp)
    80004162:	6145                	addi	sp,sp,48
    80004164:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004166:	6908                	ld	a0,16(a0)
    80004168:	388000ef          	jal	800044f0 <piperead>
    8000416c:	892a                	mv	s2,a0
    8000416e:	64e2                	ld	s1,24(sp)
    80004170:	69a2                	ld	s3,8(sp)
    80004172:	b7e5                	j	8000415a <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004174:	02451783          	lh	a5,36(a0)
    80004178:	03079693          	slli	a3,a5,0x30
    8000417c:	92c1                	srli	a3,a3,0x30
    8000417e:	4725                	li	a4,9
    80004180:	02d76863          	bltu	a4,a3,800041b0 <fileread+0xae>
    80004184:	0792                	slli	a5,a5,0x4
    80004186:	00016717          	auipc	a4,0x16
    8000418a:	75270713          	addi	a4,a4,1874 # 8001a8d8 <devsw>
    8000418e:	97ba                	add	a5,a5,a4
    80004190:	639c                	ld	a5,0(a5)
    80004192:	c39d                	beqz	a5,800041b8 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004194:	4505                	li	a0,1
    80004196:	9782                	jalr	a5
    80004198:	892a                	mv	s2,a0
    8000419a:	64e2                	ld	s1,24(sp)
    8000419c:	69a2                	ld	s3,8(sp)
    8000419e:	bf75                	j	8000415a <fileread+0x58>
    panic("fileread");
    800041a0:	00003517          	auipc	a0,0x3
    800041a4:	46850513          	addi	a0,a0,1128 # 80007608 <etext+0x608>
    800041a8:	decfc0ef          	jal	80000794 <panic>
    return -1;
    800041ac:	597d                	li	s2,-1
    800041ae:	b775                	j	8000415a <fileread+0x58>
      return -1;
    800041b0:	597d                	li	s2,-1
    800041b2:	64e2                	ld	s1,24(sp)
    800041b4:	69a2                	ld	s3,8(sp)
    800041b6:	b755                	j	8000415a <fileread+0x58>
    800041b8:	597d                	li	s2,-1
    800041ba:	64e2                	ld	s1,24(sp)
    800041bc:	69a2                	ld	s3,8(sp)
    800041be:	bf71                	j	8000415a <fileread+0x58>

00000000800041c0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800041c0:	00954783          	lbu	a5,9(a0)
    800041c4:	10078b63          	beqz	a5,800042da <filewrite+0x11a>
{
    800041c8:	715d                	addi	sp,sp,-80
    800041ca:	e486                	sd	ra,72(sp)
    800041cc:	e0a2                	sd	s0,64(sp)
    800041ce:	f84a                	sd	s2,48(sp)
    800041d0:	f052                	sd	s4,32(sp)
    800041d2:	e85a                	sd	s6,16(sp)
    800041d4:	0880                	addi	s0,sp,80
    800041d6:	892a                	mv	s2,a0
    800041d8:	8b2e                	mv	s6,a1
    800041da:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800041dc:	411c                	lw	a5,0(a0)
    800041de:	4705                	li	a4,1
    800041e0:	02e78763          	beq	a5,a4,8000420e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800041e4:	470d                	li	a4,3
    800041e6:	02e78863          	beq	a5,a4,80004216 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800041ea:	4709                	li	a4,2
    800041ec:	0ce79c63          	bne	a5,a4,800042c4 <filewrite+0x104>
    800041f0:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800041f2:	0ac05863          	blez	a2,800042a2 <filewrite+0xe2>
    800041f6:	fc26                	sd	s1,56(sp)
    800041f8:	ec56                	sd	s5,24(sp)
    800041fa:	e45e                	sd	s7,8(sp)
    800041fc:	e062                	sd	s8,0(sp)
    int i = 0;
    800041fe:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004200:	6b85                	lui	s7,0x1
    80004202:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004206:	6c05                	lui	s8,0x1
    80004208:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000420c:	a8b5                	j	80004288 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    8000420e:	6908                	ld	a0,16(a0)
    80004210:	1fc000ef          	jal	8000440c <pipewrite>
    80004214:	a04d                	j	800042b6 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004216:	02451783          	lh	a5,36(a0)
    8000421a:	03079693          	slli	a3,a5,0x30
    8000421e:	92c1                	srli	a3,a3,0x30
    80004220:	4725                	li	a4,9
    80004222:	0ad76e63          	bltu	a4,a3,800042de <filewrite+0x11e>
    80004226:	0792                	slli	a5,a5,0x4
    80004228:	00016717          	auipc	a4,0x16
    8000422c:	6b070713          	addi	a4,a4,1712 # 8001a8d8 <devsw>
    80004230:	97ba                	add	a5,a5,a4
    80004232:	679c                	ld	a5,8(a5)
    80004234:	c7dd                	beqz	a5,800042e2 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80004236:	4505                	li	a0,1
    80004238:	9782                	jalr	a5
    8000423a:	a8b5                	j	800042b6 <filewrite+0xf6>
      if(n1 > max)
    8000423c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004240:	989ff0ef          	jal	80003bc8 <begin_op>
      ilock(f->ip);
    80004244:	01893503          	ld	a0,24(s2)
    80004248:	8eaff0ef          	jal	80003332 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000424c:	8756                	mv	a4,s5
    8000424e:	02092683          	lw	a3,32(s2)
    80004252:	01698633          	add	a2,s3,s6
    80004256:	4585                	li	a1,1
    80004258:	01893503          	ld	a0,24(s2)
    8000425c:	c26ff0ef          	jal	80003682 <writei>
    80004260:	84aa                	mv	s1,a0
    80004262:	00a05763          	blez	a0,80004270 <filewrite+0xb0>
        f->off += r;
    80004266:	02092783          	lw	a5,32(s2)
    8000426a:	9fa9                	addw	a5,a5,a0
    8000426c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004270:	01893503          	ld	a0,24(s2)
    80004274:	96cff0ef          	jal	800033e0 <iunlock>
      end_op();
    80004278:	9bbff0ef          	jal	80003c32 <end_op>

      if(r != n1){
    8000427c:	029a9563          	bne	s5,s1,800042a6 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004280:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004284:	0149da63          	bge	s3,s4,80004298 <filewrite+0xd8>
      int n1 = n - i;
    80004288:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000428c:	0004879b          	sext.w	a5,s1
    80004290:	fafbd6e3          	bge	s7,a5,8000423c <filewrite+0x7c>
    80004294:	84e2                	mv	s1,s8
    80004296:	b75d                	j	8000423c <filewrite+0x7c>
    80004298:	74e2                	ld	s1,56(sp)
    8000429a:	6ae2                	ld	s5,24(sp)
    8000429c:	6ba2                	ld	s7,8(sp)
    8000429e:	6c02                	ld	s8,0(sp)
    800042a0:	a039                	j	800042ae <filewrite+0xee>
    int i = 0;
    800042a2:	4981                	li	s3,0
    800042a4:	a029                	j	800042ae <filewrite+0xee>
    800042a6:	74e2                	ld	s1,56(sp)
    800042a8:	6ae2                	ld	s5,24(sp)
    800042aa:	6ba2                	ld	s7,8(sp)
    800042ac:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800042ae:	033a1c63          	bne	s4,s3,800042e6 <filewrite+0x126>
    800042b2:	8552                	mv	a0,s4
    800042b4:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800042b6:	60a6                	ld	ra,72(sp)
    800042b8:	6406                	ld	s0,64(sp)
    800042ba:	7942                	ld	s2,48(sp)
    800042bc:	7a02                	ld	s4,32(sp)
    800042be:	6b42                	ld	s6,16(sp)
    800042c0:	6161                	addi	sp,sp,80
    800042c2:	8082                	ret
    800042c4:	fc26                	sd	s1,56(sp)
    800042c6:	f44e                	sd	s3,40(sp)
    800042c8:	ec56                	sd	s5,24(sp)
    800042ca:	e45e                	sd	s7,8(sp)
    800042cc:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800042ce:	00003517          	auipc	a0,0x3
    800042d2:	34a50513          	addi	a0,a0,842 # 80007618 <etext+0x618>
    800042d6:	cbefc0ef          	jal	80000794 <panic>
    return -1;
    800042da:	557d                	li	a0,-1
}
    800042dc:	8082                	ret
      return -1;
    800042de:	557d                	li	a0,-1
    800042e0:	bfd9                	j	800042b6 <filewrite+0xf6>
    800042e2:	557d                	li	a0,-1
    800042e4:	bfc9                	j	800042b6 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800042e6:	557d                	li	a0,-1
    800042e8:	79a2                	ld	s3,40(sp)
    800042ea:	b7f1                	j	800042b6 <filewrite+0xf6>

00000000800042ec <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800042ec:	7179                	addi	sp,sp,-48
    800042ee:	f406                	sd	ra,40(sp)
    800042f0:	f022                	sd	s0,32(sp)
    800042f2:	ec26                	sd	s1,24(sp)
    800042f4:	e052                	sd	s4,0(sp)
    800042f6:	1800                	addi	s0,sp,48
    800042f8:	84aa                	mv	s1,a0
    800042fa:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800042fc:	0005b023          	sd	zero,0(a1)
    80004300:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004304:	c3bff0ef          	jal	80003f3e <filealloc>
    80004308:	e088                	sd	a0,0(s1)
    8000430a:	c549                	beqz	a0,80004394 <pipealloc+0xa8>
    8000430c:	c33ff0ef          	jal	80003f3e <filealloc>
    80004310:	00aa3023          	sd	a0,0(s4)
    80004314:	cd25                	beqz	a0,8000438c <pipealloc+0xa0>
    80004316:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004318:	80ffc0ef          	jal	80000b26 <kalloc>
    8000431c:	892a                	mv	s2,a0
    8000431e:	c12d                	beqz	a0,80004380 <pipealloc+0x94>
    80004320:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004322:	4985                	li	s3,1
    80004324:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004328:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000432c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004330:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004334:	00003597          	auipc	a1,0x3
    80004338:	2f458593          	addi	a1,a1,756 # 80007628 <etext+0x628>
    8000433c:	83bfc0ef          	jal	80000b76 <initlock>
  (*f0)->type = FD_PIPE;
    80004340:	609c                	ld	a5,0(s1)
    80004342:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004346:	609c                	ld	a5,0(s1)
    80004348:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000434c:	609c                	ld	a5,0(s1)
    8000434e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004352:	609c                	ld	a5,0(s1)
    80004354:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004358:	000a3783          	ld	a5,0(s4)
    8000435c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004360:	000a3783          	ld	a5,0(s4)
    80004364:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004368:	000a3783          	ld	a5,0(s4)
    8000436c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004370:	000a3783          	ld	a5,0(s4)
    80004374:	0127b823          	sd	s2,16(a5)
  return 0;
    80004378:	4501                	li	a0,0
    8000437a:	6942                	ld	s2,16(sp)
    8000437c:	69a2                	ld	s3,8(sp)
    8000437e:	a01d                	j	800043a4 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004380:	6088                	ld	a0,0(s1)
    80004382:	c119                	beqz	a0,80004388 <pipealloc+0x9c>
    80004384:	6942                	ld	s2,16(sp)
    80004386:	a029                	j	80004390 <pipealloc+0xa4>
    80004388:	6942                	ld	s2,16(sp)
    8000438a:	a029                	j	80004394 <pipealloc+0xa8>
    8000438c:	6088                	ld	a0,0(s1)
    8000438e:	c10d                	beqz	a0,800043b0 <pipealloc+0xc4>
    fileclose(*f0);
    80004390:	c53ff0ef          	jal	80003fe2 <fileclose>
  if(*f1)
    80004394:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004398:	557d                	li	a0,-1
  if(*f1)
    8000439a:	c789                	beqz	a5,800043a4 <pipealloc+0xb8>
    fileclose(*f1);
    8000439c:	853e                	mv	a0,a5
    8000439e:	c45ff0ef          	jal	80003fe2 <fileclose>
  return -1;
    800043a2:	557d                	li	a0,-1
}
    800043a4:	70a2                	ld	ra,40(sp)
    800043a6:	7402                	ld	s0,32(sp)
    800043a8:	64e2                	ld	s1,24(sp)
    800043aa:	6a02                	ld	s4,0(sp)
    800043ac:	6145                	addi	sp,sp,48
    800043ae:	8082                	ret
  return -1;
    800043b0:	557d                	li	a0,-1
    800043b2:	bfcd                	j	800043a4 <pipealloc+0xb8>

00000000800043b4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800043b4:	1101                	addi	sp,sp,-32
    800043b6:	ec06                	sd	ra,24(sp)
    800043b8:	e822                	sd	s0,16(sp)
    800043ba:	e426                	sd	s1,8(sp)
    800043bc:	e04a                	sd	s2,0(sp)
    800043be:	1000                	addi	s0,sp,32
    800043c0:	84aa                	mv	s1,a0
    800043c2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800043c4:	833fc0ef          	jal	80000bf6 <acquire>
  if(writable){
    800043c8:	02090763          	beqz	s2,800043f6 <pipeclose+0x42>
    pi->writeopen = 0;
    800043cc:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800043d0:	21848513          	addi	a0,s1,536
    800043d4:	8a1fd0ef          	jal	80001c74 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800043d8:	2204b783          	ld	a5,544(s1)
    800043dc:	e785                	bnez	a5,80004404 <pipeclose+0x50>
    release(&pi->lock);
    800043de:	8526                	mv	a0,s1
    800043e0:	8affc0ef          	jal	80000c8e <release>
    kfree((char*)pi);
    800043e4:	8526                	mv	a0,s1
    800043e6:	e5cfc0ef          	jal	80000a42 <kfree>
  } else
    release(&pi->lock);
}
    800043ea:	60e2                	ld	ra,24(sp)
    800043ec:	6442                	ld	s0,16(sp)
    800043ee:	64a2                	ld	s1,8(sp)
    800043f0:	6902                	ld	s2,0(sp)
    800043f2:	6105                	addi	sp,sp,32
    800043f4:	8082                	ret
    pi->readopen = 0;
    800043f6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800043fa:	21c48513          	addi	a0,s1,540
    800043fe:	877fd0ef          	jal	80001c74 <wakeup>
    80004402:	bfd9                	j	800043d8 <pipeclose+0x24>
    release(&pi->lock);
    80004404:	8526                	mv	a0,s1
    80004406:	889fc0ef          	jal	80000c8e <release>
}
    8000440a:	b7c5                	j	800043ea <pipeclose+0x36>

000000008000440c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000440c:	711d                	addi	sp,sp,-96
    8000440e:	ec86                	sd	ra,88(sp)
    80004410:	e8a2                	sd	s0,80(sp)
    80004412:	e4a6                	sd	s1,72(sp)
    80004414:	e0ca                	sd	s2,64(sp)
    80004416:	fc4e                	sd	s3,56(sp)
    80004418:	f852                	sd	s4,48(sp)
    8000441a:	f456                	sd	s5,40(sp)
    8000441c:	1080                	addi	s0,sp,96
    8000441e:	84aa                	mv	s1,a0
    80004420:	8aae                	mv	s5,a1
    80004422:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004424:	ca0fd0ef          	jal	800018c4 <myproc>
    80004428:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000442a:	8526                	mv	a0,s1
    8000442c:	fcafc0ef          	jal	80000bf6 <acquire>
  while(i < n){
    80004430:	0b405a63          	blez	s4,800044e4 <pipewrite+0xd8>
    80004434:	f05a                	sd	s6,32(sp)
    80004436:	ec5e                	sd	s7,24(sp)
    80004438:	e862                	sd	s8,16(sp)
  int i = 0;
    8000443a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000443c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000443e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004442:	21c48b93          	addi	s7,s1,540
    80004446:	a81d                	j	8000447c <pipewrite+0x70>
      release(&pi->lock);
    80004448:	8526                	mv	a0,s1
    8000444a:	845fc0ef          	jal	80000c8e <release>
      return -1;
    8000444e:	597d                	li	s2,-1
    80004450:	7b02                	ld	s6,32(sp)
    80004452:	6be2                	ld	s7,24(sp)
    80004454:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004456:	854a                	mv	a0,s2
    80004458:	60e6                	ld	ra,88(sp)
    8000445a:	6446                	ld	s0,80(sp)
    8000445c:	64a6                	ld	s1,72(sp)
    8000445e:	6906                	ld	s2,64(sp)
    80004460:	79e2                	ld	s3,56(sp)
    80004462:	7a42                	ld	s4,48(sp)
    80004464:	7aa2                	ld	s5,40(sp)
    80004466:	6125                	addi	sp,sp,96
    80004468:	8082                	ret
      wakeup(&pi->nread);
    8000446a:	8562                	mv	a0,s8
    8000446c:	809fd0ef          	jal	80001c74 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004470:	85a6                	mv	a1,s1
    80004472:	855e                	mv	a0,s7
    80004474:	fb4fd0ef          	jal	80001c28 <sleep>
  while(i < n){
    80004478:	05495b63          	bge	s2,s4,800044ce <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    8000447c:	2204a783          	lw	a5,544(s1)
    80004480:	d7e1                	beqz	a5,80004448 <pipewrite+0x3c>
    80004482:	854e                	mv	a0,s3
    80004484:	92dfd0ef          	jal	80001db0 <killed>
    80004488:	f161                	bnez	a0,80004448 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000448a:	2184a783          	lw	a5,536(s1)
    8000448e:	21c4a703          	lw	a4,540(s1)
    80004492:	2007879b          	addiw	a5,a5,512
    80004496:	fcf70ae3          	beq	a4,a5,8000446a <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000449a:	4685                	li	a3,1
    8000449c:	01590633          	add	a2,s2,s5
    800044a0:	faf40593          	addi	a1,s0,-81
    800044a4:	0509b503          	ld	a0,80(s3)
    800044a8:	956fd0ef          	jal	800015fe <copyin>
    800044ac:	03650e63          	beq	a0,s6,800044e8 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800044b0:	21c4a783          	lw	a5,540(s1)
    800044b4:	0017871b          	addiw	a4,a5,1
    800044b8:	20e4ae23          	sw	a4,540(s1)
    800044bc:	1ff7f793          	andi	a5,a5,511
    800044c0:	97a6                	add	a5,a5,s1
    800044c2:	faf44703          	lbu	a4,-81(s0)
    800044c6:	00e78c23          	sb	a4,24(a5)
      i++;
    800044ca:	2905                	addiw	s2,s2,1
    800044cc:	b775                	j	80004478 <pipewrite+0x6c>
    800044ce:	7b02                	ld	s6,32(sp)
    800044d0:	6be2                	ld	s7,24(sp)
    800044d2:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800044d4:	21848513          	addi	a0,s1,536
    800044d8:	f9cfd0ef          	jal	80001c74 <wakeup>
  release(&pi->lock);
    800044dc:	8526                	mv	a0,s1
    800044de:	fb0fc0ef          	jal	80000c8e <release>
  return i;
    800044e2:	bf95                	j	80004456 <pipewrite+0x4a>
  int i = 0;
    800044e4:	4901                	li	s2,0
    800044e6:	b7fd                	j	800044d4 <pipewrite+0xc8>
    800044e8:	7b02                	ld	s6,32(sp)
    800044ea:	6be2                	ld	s7,24(sp)
    800044ec:	6c42                	ld	s8,16(sp)
    800044ee:	b7dd                	j	800044d4 <pipewrite+0xc8>

00000000800044f0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800044f0:	715d                	addi	sp,sp,-80
    800044f2:	e486                	sd	ra,72(sp)
    800044f4:	e0a2                	sd	s0,64(sp)
    800044f6:	fc26                	sd	s1,56(sp)
    800044f8:	f84a                	sd	s2,48(sp)
    800044fa:	f44e                	sd	s3,40(sp)
    800044fc:	f052                	sd	s4,32(sp)
    800044fe:	ec56                	sd	s5,24(sp)
    80004500:	0880                	addi	s0,sp,80
    80004502:	84aa                	mv	s1,a0
    80004504:	892e                	mv	s2,a1
    80004506:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004508:	bbcfd0ef          	jal	800018c4 <myproc>
    8000450c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000450e:	8526                	mv	a0,s1
    80004510:	ee6fc0ef          	jal	80000bf6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004514:	2184a703          	lw	a4,536(s1)
    80004518:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000451c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004520:	02f71563          	bne	a4,a5,8000454a <piperead+0x5a>
    80004524:	2244a783          	lw	a5,548(s1)
    80004528:	cb85                	beqz	a5,80004558 <piperead+0x68>
    if(killed(pr)){
    8000452a:	8552                	mv	a0,s4
    8000452c:	885fd0ef          	jal	80001db0 <killed>
    80004530:	ed19                	bnez	a0,8000454e <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004532:	85a6                	mv	a1,s1
    80004534:	854e                	mv	a0,s3
    80004536:	ef2fd0ef          	jal	80001c28 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000453a:	2184a703          	lw	a4,536(s1)
    8000453e:	21c4a783          	lw	a5,540(s1)
    80004542:	fef701e3          	beq	a4,a5,80004524 <piperead+0x34>
    80004546:	e85a                	sd	s6,16(sp)
    80004548:	a809                	j	8000455a <piperead+0x6a>
    8000454a:	e85a                	sd	s6,16(sp)
    8000454c:	a039                	j	8000455a <piperead+0x6a>
      release(&pi->lock);
    8000454e:	8526                	mv	a0,s1
    80004550:	f3efc0ef          	jal	80000c8e <release>
      return -1;
    80004554:	59fd                	li	s3,-1
    80004556:	a8b1                	j	800045b2 <piperead+0xc2>
    80004558:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000455a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000455c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000455e:	05505263          	blez	s5,800045a2 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004562:	2184a783          	lw	a5,536(s1)
    80004566:	21c4a703          	lw	a4,540(s1)
    8000456a:	02f70c63          	beq	a4,a5,800045a2 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000456e:	0017871b          	addiw	a4,a5,1
    80004572:	20e4ac23          	sw	a4,536(s1)
    80004576:	1ff7f793          	andi	a5,a5,511
    8000457a:	97a6                	add	a5,a5,s1
    8000457c:	0187c783          	lbu	a5,24(a5)
    80004580:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004584:	4685                	li	a3,1
    80004586:	fbf40613          	addi	a2,s0,-65
    8000458a:	85ca                	mv	a1,s2
    8000458c:	050a3503          	ld	a0,80(s4)
    80004590:	f99fc0ef          	jal	80001528 <copyout>
    80004594:	01650763          	beq	a0,s6,800045a2 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004598:	2985                	addiw	s3,s3,1
    8000459a:	0905                	addi	s2,s2,1
    8000459c:	fd3a93e3          	bne	s5,s3,80004562 <piperead+0x72>
    800045a0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800045a2:	21c48513          	addi	a0,s1,540
    800045a6:	ecefd0ef          	jal	80001c74 <wakeup>
  release(&pi->lock);
    800045aa:	8526                	mv	a0,s1
    800045ac:	ee2fc0ef          	jal	80000c8e <release>
    800045b0:	6b42                	ld	s6,16(sp)
  return i;
}
    800045b2:	854e                	mv	a0,s3
    800045b4:	60a6                	ld	ra,72(sp)
    800045b6:	6406                	ld	s0,64(sp)
    800045b8:	74e2                	ld	s1,56(sp)
    800045ba:	7942                	ld	s2,48(sp)
    800045bc:	79a2                	ld	s3,40(sp)
    800045be:	7a02                	ld	s4,32(sp)
    800045c0:	6ae2                	ld	s5,24(sp)
    800045c2:	6161                	addi	sp,sp,80
    800045c4:	8082                	ret

00000000800045c6 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800045c6:	1141                	addi	sp,sp,-16
    800045c8:	e422                	sd	s0,8(sp)
    800045ca:	0800                	addi	s0,sp,16
    800045cc:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800045ce:	8905                	andi	a0,a0,1
    800045d0:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800045d2:	8b89                	andi	a5,a5,2
    800045d4:	c399                	beqz	a5,800045da <flags2perm+0x14>
      perm |= PTE_W;
    800045d6:	00456513          	ori	a0,a0,4
    return perm;
}
    800045da:	6422                	ld	s0,8(sp)
    800045dc:	0141                	addi	sp,sp,16
    800045de:	8082                	ret

00000000800045e0 <exec>:

int
exec(char *path, char **argv)
{
    800045e0:	df010113          	addi	sp,sp,-528
    800045e4:	20113423          	sd	ra,520(sp)
    800045e8:	20813023          	sd	s0,512(sp)
    800045ec:	ffa6                	sd	s1,504(sp)
    800045ee:	fbca                	sd	s2,496(sp)
    800045f0:	0c00                	addi	s0,sp,528
    800045f2:	892a                	mv	s2,a0
    800045f4:	dea43c23          	sd	a0,-520(s0)
    800045f8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800045fc:	ac8fd0ef          	jal	800018c4 <myproc>
    80004600:	84aa                	mv	s1,a0

  begin_op();
    80004602:	dc6ff0ef          	jal	80003bc8 <begin_op>

  if((ip = namei(path)) == 0){
    80004606:	854a                	mv	a0,s2
    80004608:	c04ff0ef          	jal	80003a0c <namei>
    8000460c:	c931                	beqz	a0,80004660 <exec+0x80>
    8000460e:	f3d2                	sd	s4,480(sp)
    80004610:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004612:	d21fe0ef          	jal	80003332 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004616:	04000713          	li	a4,64
    8000461a:	4681                	li	a3,0
    8000461c:	e5040613          	addi	a2,s0,-432
    80004620:	4581                	li	a1,0
    80004622:	8552                	mv	a0,s4
    80004624:	f63fe0ef          	jal	80003586 <readi>
    80004628:	04000793          	li	a5,64
    8000462c:	00f51a63          	bne	a0,a5,80004640 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004630:	e5042703          	lw	a4,-432(s0)
    80004634:	464c47b7          	lui	a5,0x464c4
    80004638:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000463c:	02f70663          	beq	a4,a5,80004668 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004640:	8552                	mv	a0,s4
    80004642:	efbfe0ef          	jal	8000353c <iunlockput>
    end_op();
    80004646:	decff0ef          	jal	80003c32 <end_op>
  }
  return -1;
    8000464a:	557d                	li	a0,-1
    8000464c:	7a1e                	ld	s4,480(sp)
}
    8000464e:	20813083          	ld	ra,520(sp)
    80004652:	20013403          	ld	s0,512(sp)
    80004656:	74fe                	ld	s1,504(sp)
    80004658:	795e                	ld	s2,496(sp)
    8000465a:	21010113          	addi	sp,sp,528
    8000465e:	8082                	ret
    end_op();
    80004660:	dd2ff0ef          	jal	80003c32 <end_op>
    return -1;
    80004664:	557d                	li	a0,-1
    80004666:	b7e5                	j	8000464e <exec+0x6e>
    80004668:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000466a:	8526                	mv	a0,s1
    8000466c:	b02fd0ef          	jal	8000196e <proc_pagetable>
    80004670:	8b2a                	mv	s6,a0
    80004672:	2c050b63          	beqz	a0,80004948 <exec+0x368>
    80004676:	f7ce                	sd	s3,488(sp)
    80004678:	efd6                	sd	s5,472(sp)
    8000467a:	e7de                	sd	s7,456(sp)
    8000467c:	e3e2                	sd	s8,448(sp)
    8000467e:	ff66                	sd	s9,440(sp)
    80004680:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004682:	e7042d03          	lw	s10,-400(s0)
    80004686:	e8845783          	lhu	a5,-376(s0)
    8000468a:	12078963          	beqz	a5,800047bc <exec+0x1dc>
    8000468e:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004690:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004692:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004694:	6c85                	lui	s9,0x1
    80004696:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000469a:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000469e:	6a85                	lui	s5,0x1
    800046a0:	a085                	j	80004700 <exec+0x120>
      panic("loadseg: address should exist");
    800046a2:	00003517          	auipc	a0,0x3
    800046a6:	f8e50513          	addi	a0,a0,-114 # 80007630 <etext+0x630>
    800046aa:	8eafc0ef          	jal	80000794 <panic>
    if(sz - i < PGSIZE)
    800046ae:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800046b0:	8726                	mv	a4,s1
    800046b2:	012c06bb          	addw	a3,s8,s2
    800046b6:	4581                	li	a1,0
    800046b8:	8552                	mv	a0,s4
    800046ba:	ecdfe0ef          	jal	80003586 <readi>
    800046be:	2501                	sext.w	a0,a0
    800046c0:	24a49a63          	bne	s1,a0,80004914 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    800046c4:	012a893b          	addw	s2,s5,s2
    800046c8:	03397363          	bgeu	s2,s3,800046ee <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    800046cc:	02091593          	slli	a1,s2,0x20
    800046d0:	9181                	srli	a1,a1,0x20
    800046d2:	95de                	add	a1,a1,s7
    800046d4:	855a                	mv	a0,s6
    800046d6:	8ebfc0ef          	jal	80000fc0 <walkaddr>
    800046da:	862a                	mv	a2,a0
    if(pa == 0)
    800046dc:	d179                	beqz	a0,800046a2 <exec+0xc2>
    if(sz - i < PGSIZE)
    800046de:	412984bb          	subw	s1,s3,s2
    800046e2:	0004879b          	sext.w	a5,s1
    800046e6:	fcfcf4e3          	bgeu	s9,a5,800046ae <exec+0xce>
    800046ea:	84d6                	mv	s1,s5
    800046ec:	b7c9                	j	800046ae <exec+0xce>
    sz = sz1;
    800046ee:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800046f2:	2d85                	addiw	s11,s11,1
    800046f4:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800046f8:	e8845783          	lhu	a5,-376(s0)
    800046fc:	08fdd063          	bge	s11,a5,8000477c <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004700:	2d01                	sext.w	s10,s10
    80004702:	03800713          	li	a4,56
    80004706:	86ea                	mv	a3,s10
    80004708:	e1840613          	addi	a2,s0,-488
    8000470c:	4581                	li	a1,0
    8000470e:	8552                	mv	a0,s4
    80004710:	e77fe0ef          	jal	80003586 <readi>
    80004714:	03800793          	li	a5,56
    80004718:	1cf51663          	bne	a0,a5,800048e4 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    8000471c:	e1842783          	lw	a5,-488(s0)
    80004720:	4705                	li	a4,1
    80004722:	fce798e3          	bne	a5,a4,800046f2 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80004726:	e4043483          	ld	s1,-448(s0)
    8000472a:	e3843783          	ld	a5,-456(s0)
    8000472e:	1af4ef63          	bltu	s1,a5,800048ec <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004732:	e2843783          	ld	a5,-472(s0)
    80004736:	94be                	add	s1,s1,a5
    80004738:	1af4ee63          	bltu	s1,a5,800048f4 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    8000473c:	df043703          	ld	a4,-528(s0)
    80004740:	8ff9                	and	a5,a5,a4
    80004742:	1a079d63          	bnez	a5,800048fc <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004746:	e1c42503          	lw	a0,-484(s0)
    8000474a:	e7dff0ef          	jal	800045c6 <flags2perm>
    8000474e:	86aa                	mv	a3,a0
    80004750:	8626                	mv	a2,s1
    80004752:	85ca                	mv	a1,s2
    80004754:	855a                	mv	a0,s6
    80004756:	bbffc0ef          	jal	80001314 <uvmalloc>
    8000475a:	e0a43423          	sd	a0,-504(s0)
    8000475e:	1a050363          	beqz	a0,80004904 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004762:	e2843b83          	ld	s7,-472(s0)
    80004766:	e2042c03          	lw	s8,-480(s0)
    8000476a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000476e:	00098463          	beqz	s3,80004776 <exec+0x196>
    80004772:	4901                	li	s2,0
    80004774:	bfa1                	j	800046cc <exec+0xec>
    sz = sz1;
    80004776:	e0843903          	ld	s2,-504(s0)
    8000477a:	bfa5                	j	800046f2 <exec+0x112>
    8000477c:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000477e:	8552                	mv	a0,s4
    80004780:	dbdfe0ef          	jal	8000353c <iunlockput>
  end_op();
    80004784:	caeff0ef          	jal	80003c32 <end_op>
  p = myproc();
    80004788:	93cfd0ef          	jal	800018c4 <myproc>
    8000478c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000478e:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004792:	6985                	lui	s3,0x1
    80004794:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004796:	99ca                	add	s3,s3,s2
    80004798:	77fd                	lui	a5,0xfffff
    8000479a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000479e:	4691                	li	a3,4
    800047a0:	6609                	lui	a2,0x2
    800047a2:	964e                	add	a2,a2,s3
    800047a4:	85ce                	mv	a1,s3
    800047a6:	855a                	mv	a0,s6
    800047a8:	b6dfc0ef          	jal	80001314 <uvmalloc>
    800047ac:	892a                	mv	s2,a0
    800047ae:	e0a43423          	sd	a0,-504(s0)
    800047b2:	e519                	bnez	a0,800047c0 <exec+0x1e0>
  if(pagetable)
    800047b4:	e1343423          	sd	s3,-504(s0)
    800047b8:	4a01                	li	s4,0
    800047ba:	aab1                	j	80004916 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800047bc:	4901                	li	s2,0
    800047be:	b7c1                	j	8000477e <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800047c0:	75f9                	lui	a1,0xffffe
    800047c2:	95aa                	add	a1,a1,a0
    800047c4:	855a                	mv	a0,s6
    800047c6:	d39fc0ef          	jal	800014fe <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800047ca:	7bfd                	lui	s7,0xfffff
    800047cc:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800047ce:	e0043783          	ld	a5,-512(s0)
    800047d2:	6388                	ld	a0,0(a5)
    800047d4:	cd39                	beqz	a0,80004832 <exec+0x252>
    800047d6:	e9040993          	addi	s3,s0,-368
    800047da:	f9040c13          	addi	s8,s0,-112
    800047de:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800047e0:	e5afc0ef          	jal	80000e3a <strlen>
    800047e4:	0015079b          	addiw	a5,a0,1
    800047e8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800047ec:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800047f0:	11796e63          	bltu	s2,s7,8000490c <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800047f4:	e0043d03          	ld	s10,-512(s0)
    800047f8:	000d3a03          	ld	s4,0(s10)
    800047fc:	8552                	mv	a0,s4
    800047fe:	e3cfc0ef          	jal	80000e3a <strlen>
    80004802:	0015069b          	addiw	a3,a0,1
    80004806:	8652                	mv	a2,s4
    80004808:	85ca                	mv	a1,s2
    8000480a:	855a                	mv	a0,s6
    8000480c:	d1dfc0ef          	jal	80001528 <copyout>
    80004810:	10054063          	bltz	a0,80004910 <exec+0x330>
    ustack[argc] = sp;
    80004814:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004818:	0485                	addi	s1,s1,1
    8000481a:	008d0793          	addi	a5,s10,8
    8000481e:	e0f43023          	sd	a5,-512(s0)
    80004822:	008d3503          	ld	a0,8(s10)
    80004826:	c909                	beqz	a0,80004838 <exec+0x258>
    if(argc >= MAXARG)
    80004828:	09a1                	addi	s3,s3,8
    8000482a:	fb899be3          	bne	s3,s8,800047e0 <exec+0x200>
  ip = 0;
    8000482e:	4a01                	li	s4,0
    80004830:	a0dd                	j	80004916 <exec+0x336>
  sp = sz;
    80004832:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004836:	4481                	li	s1,0
  ustack[argc] = 0;
    80004838:	00349793          	slli	a5,s1,0x3
    8000483c:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffe3520>
    80004840:	97a2                	add	a5,a5,s0
    80004842:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004846:	00148693          	addi	a3,s1,1
    8000484a:	068e                	slli	a3,a3,0x3
    8000484c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004850:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004854:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004858:	f5796ee3          	bltu	s2,s7,800047b4 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000485c:	e9040613          	addi	a2,s0,-368
    80004860:	85ca                	mv	a1,s2
    80004862:	855a                	mv	a0,s6
    80004864:	cc5fc0ef          	jal	80001528 <copyout>
    80004868:	0e054263          	bltz	a0,8000494c <exec+0x36c>
  p->trapframe->a1 = sp;
    8000486c:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    80004870:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004874:	df843783          	ld	a5,-520(s0)
    80004878:	0007c703          	lbu	a4,0(a5)
    8000487c:	cf11                	beqz	a4,80004898 <exec+0x2b8>
    8000487e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004880:	02f00693          	li	a3,47
    80004884:	a039                	j	80004892 <exec+0x2b2>
      last = s+1;
    80004886:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000488a:	0785                	addi	a5,a5,1
    8000488c:	fff7c703          	lbu	a4,-1(a5)
    80004890:	c701                	beqz	a4,80004898 <exec+0x2b8>
    if(*s == '/')
    80004892:	fed71ce3          	bne	a4,a3,8000488a <exec+0x2aa>
    80004896:	bfc5                	j	80004886 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004898:	4641                	li	a2,16
    8000489a:	df843583          	ld	a1,-520(s0)
    8000489e:	160a8513          	addi	a0,s5,352
    800048a2:	d66fc0ef          	jal	80000e08 <safestrcpy>
  oldpagetable = p->pagetable;
    800048a6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800048aa:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800048ae:	e0843783          	ld	a5,-504(s0)
    800048b2:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800048b6:	060ab783          	ld	a5,96(s5)
    800048ba:	e6843703          	ld	a4,-408(s0)
    800048be:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800048c0:	060ab783          	ld	a5,96(s5)
    800048c4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800048c8:	85e6                	mv	a1,s9
    800048ca:	924fd0ef          	jal	800019ee <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800048ce:	0004851b          	sext.w	a0,s1
    800048d2:	79be                	ld	s3,488(sp)
    800048d4:	7a1e                	ld	s4,480(sp)
    800048d6:	6afe                	ld	s5,472(sp)
    800048d8:	6b5e                	ld	s6,464(sp)
    800048da:	6bbe                	ld	s7,456(sp)
    800048dc:	6c1e                	ld	s8,448(sp)
    800048de:	7cfa                	ld	s9,440(sp)
    800048e0:	7d5a                	ld	s10,432(sp)
    800048e2:	b3b5                	j	8000464e <exec+0x6e>
    800048e4:	e1243423          	sd	s2,-504(s0)
    800048e8:	7dba                	ld	s11,424(sp)
    800048ea:	a035                	j	80004916 <exec+0x336>
    800048ec:	e1243423          	sd	s2,-504(s0)
    800048f0:	7dba                	ld	s11,424(sp)
    800048f2:	a015                	j	80004916 <exec+0x336>
    800048f4:	e1243423          	sd	s2,-504(s0)
    800048f8:	7dba                	ld	s11,424(sp)
    800048fa:	a831                	j	80004916 <exec+0x336>
    800048fc:	e1243423          	sd	s2,-504(s0)
    80004900:	7dba                	ld	s11,424(sp)
    80004902:	a811                	j	80004916 <exec+0x336>
    80004904:	e1243423          	sd	s2,-504(s0)
    80004908:	7dba                	ld	s11,424(sp)
    8000490a:	a031                	j	80004916 <exec+0x336>
  ip = 0;
    8000490c:	4a01                	li	s4,0
    8000490e:	a021                	j	80004916 <exec+0x336>
    80004910:	4a01                	li	s4,0
  if(pagetable)
    80004912:	a011                	j	80004916 <exec+0x336>
    80004914:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004916:	e0843583          	ld	a1,-504(s0)
    8000491a:	855a                	mv	a0,s6
    8000491c:	8d2fd0ef          	jal	800019ee <proc_freepagetable>
  return -1;
    80004920:	557d                	li	a0,-1
  if(ip){
    80004922:	000a1b63          	bnez	s4,80004938 <exec+0x358>
    80004926:	79be                	ld	s3,488(sp)
    80004928:	7a1e                	ld	s4,480(sp)
    8000492a:	6afe                	ld	s5,472(sp)
    8000492c:	6b5e                	ld	s6,464(sp)
    8000492e:	6bbe                	ld	s7,456(sp)
    80004930:	6c1e                	ld	s8,448(sp)
    80004932:	7cfa                	ld	s9,440(sp)
    80004934:	7d5a                	ld	s10,432(sp)
    80004936:	bb21                	j	8000464e <exec+0x6e>
    80004938:	79be                	ld	s3,488(sp)
    8000493a:	6afe                	ld	s5,472(sp)
    8000493c:	6b5e                	ld	s6,464(sp)
    8000493e:	6bbe                	ld	s7,456(sp)
    80004940:	6c1e                	ld	s8,448(sp)
    80004942:	7cfa                	ld	s9,440(sp)
    80004944:	7d5a                	ld	s10,432(sp)
    80004946:	b9ed                	j	80004640 <exec+0x60>
    80004948:	6b5e                	ld	s6,464(sp)
    8000494a:	b9dd                	j	80004640 <exec+0x60>
  sz = sz1;
    8000494c:	e0843983          	ld	s3,-504(s0)
    80004950:	b595                	j	800047b4 <exec+0x1d4>

0000000080004952 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004952:	7179                	addi	sp,sp,-48
    80004954:	f406                	sd	ra,40(sp)
    80004956:	f022                	sd	s0,32(sp)
    80004958:	ec26                	sd	s1,24(sp)
    8000495a:	e84a                	sd	s2,16(sp)
    8000495c:	1800                	addi	s0,sp,48
    8000495e:	892e                	mv	s2,a1
    80004960:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004962:	fdc40593          	addi	a1,s0,-36
    80004966:	fb7fd0ef          	jal	8000291c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000496a:	fdc42703          	lw	a4,-36(s0)
    8000496e:	47bd                	li	a5,15
    80004970:	02e7e963          	bltu	a5,a4,800049a2 <argfd+0x50>
    80004974:	f51fc0ef          	jal	800018c4 <myproc>
    80004978:	fdc42703          	lw	a4,-36(s0)
    8000497c:	01a70793          	addi	a5,a4,26
    80004980:	078e                	slli	a5,a5,0x3
    80004982:	953e                	add	a0,a0,a5
    80004984:	651c                	ld	a5,8(a0)
    80004986:	c385                	beqz	a5,800049a6 <argfd+0x54>
    return -1;
  if(pfd)
    80004988:	00090463          	beqz	s2,80004990 <argfd+0x3e>
    *pfd = fd;
    8000498c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004990:	4501                	li	a0,0
  if(pf)
    80004992:	c091                	beqz	s1,80004996 <argfd+0x44>
    *pf = f;
    80004994:	e09c                	sd	a5,0(s1)
}
    80004996:	70a2                	ld	ra,40(sp)
    80004998:	7402                	ld	s0,32(sp)
    8000499a:	64e2                	ld	s1,24(sp)
    8000499c:	6942                	ld	s2,16(sp)
    8000499e:	6145                	addi	sp,sp,48
    800049a0:	8082                	ret
    return -1;
    800049a2:	557d                	li	a0,-1
    800049a4:	bfcd                	j	80004996 <argfd+0x44>
    800049a6:	557d                	li	a0,-1
    800049a8:	b7fd                	j	80004996 <argfd+0x44>

00000000800049aa <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800049aa:	1101                	addi	sp,sp,-32
    800049ac:	ec06                	sd	ra,24(sp)
    800049ae:	e822                	sd	s0,16(sp)
    800049b0:	e426                	sd	s1,8(sp)
    800049b2:	1000                	addi	s0,sp,32
    800049b4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800049b6:	f0ffc0ef          	jal	800018c4 <myproc>
    800049ba:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800049bc:	0d850793          	addi	a5,a0,216
    800049c0:	4501                	li	a0,0
    800049c2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800049c4:	6398                	ld	a4,0(a5)
    800049c6:	cb19                	beqz	a4,800049dc <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800049c8:	2505                	addiw	a0,a0,1
    800049ca:	07a1                	addi	a5,a5,8
    800049cc:	fed51ce3          	bne	a0,a3,800049c4 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800049d0:	557d                	li	a0,-1
}
    800049d2:	60e2                	ld	ra,24(sp)
    800049d4:	6442                	ld	s0,16(sp)
    800049d6:	64a2                	ld	s1,8(sp)
    800049d8:	6105                	addi	sp,sp,32
    800049da:	8082                	ret
      p->ofile[fd] = f;
    800049dc:	01a50793          	addi	a5,a0,26
    800049e0:	078e                	slli	a5,a5,0x3
    800049e2:	963e                	add	a2,a2,a5
    800049e4:	e604                	sd	s1,8(a2)
      return fd;
    800049e6:	b7f5                	j	800049d2 <fdalloc+0x28>

00000000800049e8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800049e8:	715d                	addi	sp,sp,-80
    800049ea:	e486                	sd	ra,72(sp)
    800049ec:	e0a2                	sd	s0,64(sp)
    800049ee:	fc26                	sd	s1,56(sp)
    800049f0:	f84a                	sd	s2,48(sp)
    800049f2:	f44e                	sd	s3,40(sp)
    800049f4:	ec56                	sd	s5,24(sp)
    800049f6:	e85a                	sd	s6,16(sp)
    800049f8:	0880                	addi	s0,sp,80
    800049fa:	8b2e                	mv	s6,a1
    800049fc:	89b2                	mv	s3,a2
    800049fe:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004a00:	fb040593          	addi	a1,s0,-80
    80004a04:	822ff0ef          	jal	80003a26 <nameiparent>
    80004a08:	84aa                	mv	s1,a0
    80004a0a:	10050a63          	beqz	a0,80004b1e <create+0x136>
    return 0;

  ilock(dp);
    80004a0e:	925fe0ef          	jal	80003332 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004a12:	4601                	li	a2,0
    80004a14:	fb040593          	addi	a1,s0,-80
    80004a18:	8526                	mv	a0,s1
    80004a1a:	d8dfe0ef          	jal	800037a6 <dirlookup>
    80004a1e:	8aaa                	mv	s5,a0
    80004a20:	c129                	beqz	a0,80004a62 <create+0x7a>
    iunlockput(dp);
    80004a22:	8526                	mv	a0,s1
    80004a24:	b19fe0ef          	jal	8000353c <iunlockput>
    ilock(ip);
    80004a28:	8556                	mv	a0,s5
    80004a2a:	909fe0ef          	jal	80003332 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004a2e:	4789                	li	a5,2
    80004a30:	02fb1463          	bne	s6,a5,80004a58 <create+0x70>
    80004a34:	044ad783          	lhu	a5,68(s5)
    80004a38:	37f9                	addiw	a5,a5,-2
    80004a3a:	17c2                	slli	a5,a5,0x30
    80004a3c:	93c1                	srli	a5,a5,0x30
    80004a3e:	4705                	li	a4,1
    80004a40:	00f76c63          	bltu	a4,a5,80004a58 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004a44:	8556                	mv	a0,s5
    80004a46:	60a6                	ld	ra,72(sp)
    80004a48:	6406                	ld	s0,64(sp)
    80004a4a:	74e2                	ld	s1,56(sp)
    80004a4c:	7942                	ld	s2,48(sp)
    80004a4e:	79a2                	ld	s3,40(sp)
    80004a50:	6ae2                	ld	s5,24(sp)
    80004a52:	6b42                	ld	s6,16(sp)
    80004a54:	6161                	addi	sp,sp,80
    80004a56:	8082                	ret
    iunlockput(ip);
    80004a58:	8556                	mv	a0,s5
    80004a5a:	ae3fe0ef          	jal	8000353c <iunlockput>
    return 0;
    80004a5e:	4a81                	li	s5,0
    80004a60:	b7d5                	j	80004a44 <create+0x5c>
    80004a62:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004a64:	85da                	mv	a1,s6
    80004a66:	4088                	lw	a0,0(s1)
    80004a68:	f5afe0ef          	jal	800031c2 <ialloc>
    80004a6c:	8a2a                	mv	s4,a0
    80004a6e:	cd15                	beqz	a0,80004aaa <create+0xc2>
  ilock(ip);
    80004a70:	8c3fe0ef          	jal	80003332 <ilock>
  ip->major = major;
    80004a74:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004a78:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004a7c:	4905                	li	s2,1
    80004a7e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004a82:	8552                	mv	a0,s4
    80004a84:	ffafe0ef          	jal	8000327e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004a88:	032b0763          	beq	s6,s2,80004ab6 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004a8c:	004a2603          	lw	a2,4(s4)
    80004a90:	fb040593          	addi	a1,s0,-80
    80004a94:	8526                	mv	a0,s1
    80004a96:	eddfe0ef          	jal	80003972 <dirlink>
    80004a9a:	06054563          	bltz	a0,80004b04 <create+0x11c>
  iunlockput(dp);
    80004a9e:	8526                	mv	a0,s1
    80004aa0:	a9dfe0ef          	jal	8000353c <iunlockput>
  return ip;
    80004aa4:	8ad2                	mv	s5,s4
    80004aa6:	7a02                	ld	s4,32(sp)
    80004aa8:	bf71                	j	80004a44 <create+0x5c>
    iunlockput(dp);
    80004aaa:	8526                	mv	a0,s1
    80004aac:	a91fe0ef          	jal	8000353c <iunlockput>
    return 0;
    80004ab0:	8ad2                	mv	s5,s4
    80004ab2:	7a02                	ld	s4,32(sp)
    80004ab4:	bf41                	j	80004a44 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004ab6:	004a2603          	lw	a2,4(s4)
    80004aba:	00003597          	auipc	a1,0x3
    80004abe:	b9658593          	addi	a1,a1,-1130 # 80007650 <etext+0x650>
    80004ac2:	8552                	mv	a0,s4
    80004ac4:	eaffe0ef          	jal	80003972 <dirlink>
    80004ac8:	02054e63          	bltz	a0,80004b04 <create+0x11c>
    80004acc:	40d0                	lw	a2,4(s1)
    80004ace:	00003597          	auipc	a1,0x3
    80004ad2:	b8a58593          	addi	a1,a1,-1142 # 80007658 <etext+0x658>
    80004ad6:	8552                	mv	a0,s4
    80004ad8:	e9bfe0ef          	jal	80003972 <dirlink>
    80004adc:	02054463          	bltz	a0,80004b04 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004ae0:	004a2603          	lw	a2,4(s4)
    80004ae4:	fb040593          	addi	a1,s0,-80
    80004ae8:	8526                	mv	a0,s1
    80004aea:	e89fe0ef          	jal	80003972 <dirlink>
    80004aee:	00054b63          	bltz	a0,80004b04 <create+0x11c>
    dp->nlink++;  // for ".."
    80004af2:	04a4d783          	lhu	a5,74(s1)
    80004af6:	2785                	addiw	a5,a5,1
    80004af8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004afc:	8526                	mv	a0,s1
    80004afe:	f80fe0ef          	jal	8000327e <iupdate>
    80004b02:	bf71                	j	80004a9e <create+0xb6>
  ip->nlink = 0;
    80004b04:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004b08:	8552                	mv	a0,s4
    80004b0a:	f74fe0ef          	jal	8000327e <iupdate>
  iunlockput(ip);
    80004b0e:	8552                	mv	a0,s4
    80004b10:	a2dfe0ef          	jal	8000353c <iunlockput>
  iunlockput(dp);
    80004b14:	8526                	mv	a0,s1
    80004b16:	a27fe0ef          	jal	8000353c <iunlockput>
  return 0;
    80004b1a:	7a02                	ld	s4,32(sp)
    80004b1c:	b725                	j	80004a44 <create+0x5c>
    return 0;
    80004b1e:	8aaa                	mv	s5,a0
    80004b20:	b715                	j	80004a44 <create+0x5c>

0000000080004b22 <sys_dup>:
{
    80004b22:	7179                	addi	sp,sp,-48
    80004b24:	f406                	sd	ra,40(sp)
    80004b26:	f022                	sd	s0,32(sp)
    80004b28:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004b2a:	fd840613          	addi	a2,s0,-40
    80004b2e:	4581                	li	a1,0
    80004b30:	4501                	li	a0,0
    80004b32:	e21ff0ef          	jal	80004952 <argfd>
    return -1;
    80004b36:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004b38:	02054363          	bltz	a0,80004b5e <sys_dup+0x3c>
    80004b3c:	ec26                	sd	s1,24(sp)
    80004b3e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004b40:	fd843903          	ld	s2,-40(s0)
    80004b44:	854a                	mv	a0,s2
    80004b46:	e65ff0ef          	jal	800049aa <fdalloc>
    80004b4a:	84aa                	mv	s1,a0
    return -1;
    80004b4c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004b4e:	00054d63          	bltz	a0,80004b68 <sys_dup+0x46>
  filedup(f);
    80004b52:	854a                	mv	a0,s2
    80004b54:	c48ff0ef          	jal	80003f9c <filedup>
  return fd;
    80004b58:	87a6                	mv	a5,s1
    80004b5a:	64e2                	ld	s1,24(sp)
    80004b5c:	6942                	ld	s2,16(sp)
}
    80004b5e:	853e                	mv	a0,a5
    80004b60:	70a2                	ld	ra,40(sp)
    80004b62:	7402                	ld	s0,32(sp)
    80004b64:	6145                	addi	sp,sp,48
    80004b66:	8082                	ret
    80004b68:	64e2                	ld	s1,24(sp)
    80004b6a:	6942                	ld	s2,16(sp)
    80004b6c:	bfcd                	j	80004b5e <sys_dup+0x3c>

0000000080004b6e <sys_read>:
{
    80004b6e:	7179                	addi	sp,sp,-48
    80004b70:	f406                	sd	ra,40(sp)
    80004b72:	f022                	sd	s0,32(sp)
    80004b74:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004b76:	fd840593          	addi	a1,s0,-40
    80004b7a:	4505                	li	a0,1
    80004b7c:	dbdfd0ef          	jal	80002938 <argaddr>
  argint(2, &n);
    80004b80:	fe440593          	addi	a1,s0,-28
    80004b84:	4509                	li	a0,2
    80004b86:	d97fd0ef          	jal	8000291c <argint>
  if(argfd(0, 0, &f) < 0)
    80004b8a:	fe840613          	addi	a2,s0,-24
    80004b8e:	4581                	li	a1,0
    80004b90:	4501                	li	a0,0
    80004b92:	dc1ff0ef          	jal	80004952 <argfd>
    80004b96:	87aa                	mv	a5,a0
    return -1;
    80004b98:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b9a:	0007ca63          	bltz	a5,80004bae <sys_read+0x40>
  return fileread(f, p, n);
    80004b9e:	fe442603          	lw	a2,-28(s0)
    80004ba2:	fd843583          	ld	a1,-40(s0)
    80004ba6:	fe843503          	ld	a0,-24(s0)
    80004baa:	d58ff0ef          	jal	80004102 <fileread>
}
    80004bae:	70a2                	ld	ra,40(sp)
    80004bb0:	7402                	ld	s0,32(sp)
    80004bb2:	6145                	addi	sp,sp,48
    80004bb4:	8082                	ret

0000000080004bb6 <sys_write>:
{
    80004bb6:	7179                	addi	sp,sp,-48
    80004bb8:	f406                	sd	ra,40(sp)
    80004bba:	f022                	sd	s0,32(sp)
    80004bbc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004bbe:	fd840593          	addi	a1,s0,-40
    80004bc2:	4505                	li	a0,1
    80004bc4:	d75fd0ef          	jal	80002938 <argaddr>
  argint(2, &n);
    80004bc8:	fe440593          	addi	a1,s0,-28
    80004bcc:	4509                	li	a0,2
    80004bce:	d4ffd0ef          	jal	8000291c <argint>
  if(argfd(0, 0, &f) < 0)
    80004bd2:	fe840613          	addi	a2,s0,-24
    80004bd6:	4581                	li	a1,0
    80004bd8:	4501                	li	a0,0
    80004bda:	d79ff0ef          	jal	80004952 <argfd>
    80004bde:	87aa                	mv	a5,a0
    return -1;
    80004be0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004be2:	0007ca63          	bltz	a5,80004bf6 <sys_write+0x40>
  return filewrite(f, p, n);
    80004be6:	fe442603          	lw	a2,-28(s0)
    80004bea:	fd843583          	ld	a1,-40(s0)
    80004bee:	fe843503          	ld	a0,-24(s0)
    80004bf2:	dceff0ef          	jal	800041c0 <filewrite>
}
    80004bf6:	70a2                	ld	ra,40(sp)
    80004bf8:	7402                	ld	s0,32(sp)
    80004bfa:	6145                	addi	sp,sp,48
    80004bfc:	8082                	ret

0000000080004bfe <sys_close>:
{
    80004bfe:	1101                	addi	sp,sp,-32
    80004c00:	ec06                	sd	ra,24(sp)
    80004c02:	e822                	sd	s0,16(sp)
    80004c04:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004c06:	fe040613          	addi	a2,s0,-32
    80004c0a:	fec40593          	addi	a1,s0,-20
    80004c0e:	4501                	li	a0,0
    80004c10:	d43ff0ef          	jal	80004952 <argfd>
    return -1;
    80004c14:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004c16:	02054063          	bltz	a0,80004c36 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004c1a:	cabfc0ef          	jal	800018c4 <myproc>
    80004c1e:	fec42783          	lw	a5,-20(s0)
    80004c22:	07e9                	addi	a5,a5,26
    80004c24:	078e                	slli	a5,a5,0x3
    80004c26:	953e                	add	a0,a0,a5
    80004c28:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004c2c:	fe043503          	ld	a0,-32(s0)
    80004c30:	bb2ff0ef          	jal	80003fe2 <fileclose>
  return 0;
    80004c34:	4781                	li	a5,0
}
    80004c36:	853e                	mv	a0,a5
    80004c38:	60e2                	ld	ra,24(sp)
    80004c3a:	6442                	ld	s0,16(sp)
    80004c3c:	6105                	addi	sp,sp,32
    80004c3e:	8082                	ret

0000000080004c40 <sys_fstat>:
{
    80004c40:	1101                	addi	sp,sp,-32
    80004c42:	ec06                	sd	ra,24(sp)
    80004c44:	e822                	sd	s0,16(sp)
    80004c46:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004c48:	fe040593          	addi	a1,s0,-32
    80004c4c:	4505                	li	a0,1
    80004c4e:	cebfd0ef          	jal	80002938 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004c52:	fe840613          	addi	a2,s0,-24
    80004c56:	4581                	li	a1,0
    80004c58:	4501                	li	a0,0
    80004c5a:	cf9ff0ef          	jal	80004952 <argfd>
    80004c5e:	87aa                	mv	a5,a0
    return -1;
    80004c60:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c62:	0007c863          	bltz	a5,80004c72 <sys_fstat+0x32>
  return filestat(f, st);
    80004c66:	fe043583          	ld	a1,-32(s0)
    80004c6a:	fe843503          	ld	a0,-24(s0)
    80004c6e:	c36ff0ef          	jal	800040a4 <filestat>
}
    80004c72:	60e2                	ld	ra,24(sp)
    80004c74:	6442                	ld	s0,16(sp)
    80004c76:	6105                	addi	sp,sp,32
    80004c78:	8082                	ret

0000000080004c7a <sys_link>:
{
    80004c7a:	7169                	addi	sp,sp,-304
    80004c7c:	f606                	sd	ra,296(sp)
    80004c7e:	f222                	sd	s0,288(sp)
    80004c80:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004c82:	08000613          	li	a2,128
    80004c86:	ed040593          	addi	a1,s0,-304
    80004c8a:	4501                	li	a0,0
    80004c8c:	cc9fd0ef          	jal	80002954 <argstr>
    return -1;
    80004c90:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004c92:	0c054e63          	bltz	a0,80004d6e <sys_link+0xf4>
    80004c96:	08000613          	li	a2,128
    80004c9a:	f5040593          	addi	a1,s0,-176
    80004c9e:	4505                	li	a0,1
    80004ca0:	cb5fd0ef          	jal	80002954 <argstr>
    return -1;
    80004ca4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ca6:	0c054463          	bltz	a0,80004d6e <sys_link+0xf4>
    80004caa:	ee26                	sd	s1,280(sp)
  begin_op();
    80004cac:	f1dfe0ef          	jal	80003bc8 <begin_op>
  if((ip = namei(old)) == 0){
    80004cb0:	ed040513          	addi	a0,s0,-304
    80004cb4:	d59fe0ef          	jal	80003a0c <namei>
    80004cb8:	84aa                	mv	s1,a0
    80004cba:	c53d                	beqz	a0,80004d28 <sys_link+0xae>
  ilock(ip);
    80004cbc:	e76fe0ef          	jal	80003332 <ilock>
  if(ip->type == T_DIR){
    80004cc0:	04449703          	lh	a4,68(s1)
    80004cc4:	4785                	li	a5,1
    80004cc6:	06f70663          	beq	a4,a5,80004d32 <sys_link+0xb8>
    80004cca:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004ccc:	04a4d783          	lhu	a5,74(s1)
    80004cd0:	2785                	addiw	a5,a5,1
    80004cd2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004cd6:	8526                	mv	a0,s1
    80004cd8:	da6fe0ef          	jal	8000327e <iupdate>
  iunlock(ip);
    80004cdc:	8526                	mv	a0,s1
    80004cde:	f02fe0ef          	jal	800033e0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004ce2:	fd040593          	addi	a1,s0,-48
    80004ce6:	f5040513          	addi	a0,s0,-176
    80004cea:	d3dfe0ef          	jal	80003a26 <nameiparent>
    80004cee:	892a                	mv	s2,a0
    80004cf0:	cd21                	beqz	a0,80004d48 <sys_link+0xce>
  ilock(dp);
    80004cf2:	e40fe0ef          	jal	80003332 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004cf6:	00092703          	lw	a4,0(s2)
    80004cfa:	409c                	lw	a5,0(s1)
    80004cfc:	04f71363          	bne	a4,a5,80004d42 <sys_link+0xc8>
    80004d00:	40d0                	lw	a2,4(s1)
    80004d02:	fd040593          	addi	a1,s0,-48
    80004d06:	854a                	mv	a0,s2
    80004d08:	c6bfe0ef          	jal	80003972 <dirlink>
    80004d0c:	02054b63          	bltz	a0,80004d42 <sys_link+0xc8>
  iunlockput(dp);
    80004d10:	854a                	mv	a0,s2
    80004d12:	82bfe0ef          	jal	8000353c <iunlockput>
  iput(ip);
    80004d16:	8526                	mv	a0,s1
    80004d18:	f9cfe0ef          	jal	800034b4 <iput>
  end_op();
    80004d1c:	f17fe0ef          	jal	80003c32 <end_op>
  return 0;
    80004d20:	4781                	li	a5,0
    80004d22:	64f2                	ld	s1,280(sp)
    80004d24:	6952                	ld	s2,272(sp)
    80004d26:	a0a1                	j	80004d6e <sys_link+0xf4>
    end_op();
    80004d28:	f0bfe0ef          	jal	80003c32 <end_op>
    return -1;
    80004d2c:	57fd                	li	a5,-1
    80004d2e:	64f2                	ld	s1,280(sp)
    80004d30:	a83d                	j	80004d6e <sys_link+0xf4>
    iunlockput(ip);
    80004d32:	8526                	mv	a0,s1
    80004d34:	809fe0ef          	jal	8000353c <iunlockput>
    end_op();
    80004d38:	efbfe0ef          	jal	80003c32 <end_op>
    return -1;
    80004d3c:	57fd                	li	a5,-1
    80004d3e:	64f2                	ld	s1,280(sp)
    80004d40:	a03d                	j	80004d6e <sys_link+0xf4>
    iunlockput(dp);
    80004d42:	854a                	mv	a0,s2
    80004d44:	ff8fe0ef          	jal	8000353c <iunlockput>
  ilock(ip);
    80004d48:	8526                	mv	a0,s1
    80004d4a:	de8fe0ef          	jal	80003332 <ilock>
  ip->nlink--;
    80004d4e:	04a4d783          	lhu	a5,74(s1)
    80004d52:	37fd                	addiw	a5,a5,-1
    80004d54:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004d58:	8526                	mv	a0,s1
    80004d5a:	d24fe0ef          	jal	8000327e <iupdate>
  iunlockput(ip);
    80004d5e:	8526                	mv	a0,s1
    80004d60:	fdcfe0ef          	jal	8000353c <iunlockput>
  end_op();
    80004d64:	ecffe0ef          	jal	80003c32 <end_op>
  return -1;
    80004d68:	57fd                	li	a5,-1
    80004d6a:	64f2                	ld	s1,280(sp)
    80004d6c:	6952                	ld	s2,272(sp)
}
    80004d6e:	853e                	mv	a0,a5
    80004d70:	70b2                	ld	ra,296(sp)
    80004d72:	7412                	ld	s0,288(sp)
    80004d74:	6155                	addi	sp,sp,304
    80004d76:	8082                	ret

0000000080004d78 <sys_unlink>:
{
    80004d78:	7151                	addi	sp,sp,-240
    80004d7a:	f586                	sd	ra,232(sp)
    80004d7c:	f1a2                	sd	s0,224(sp)
    80004d7e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004d80:	08000613          	li	a2,128
    80004d84:	f3040593          	addi	a1,s0,-208
    80004d88:	4501                	li	a0,0
    80004d8a:	bcbfd0ef          	jal	80002954 <argstr>
    80004d8e:	16054063          	bltz	a0,80004eee <sys_unlink+0x176>
    80004d92:	eda6                	sd	s1,216(sp)
  begin_op();
    80004d94:	e35fe0ef          	jal	80003bc8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004d98:	fb040593          	addi	a1,s0,-80
    80004d9c:	f3040513          	addi	a0,s0,-208
    80004da0:	c87fe0ef          	jal	80003a26 <nameiparent>
    80004da4:	84aa                	mv	s1,a0
    80004da6:	c945                	beqz	a0,80004e56 <sys_unlink+0xde>
  ilock(dp);
    80004da8:	d8afe0ef          	jal	80003332 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004dac:	00003597          	auipc	a1,0x3
    80004db0:	8a458593          	addi	a1,a1,-1884 # 80007650 <etext+0x650>
    80004db4:	fb040513          	addi	a0,s0,-80
    80004db8:	9d9fe0ef          	jal	80003790 <namecmp>
    80004dbc:	10050e63          	beqz	a0,80004ed8 <sys_unlink+0x160>
    80004dc0:	00003597          	auipc	a1,0x3
    80004dc4:	89858593          	addi	a1,a1,-1896 # 80007658 <etext+0x658>
    80004dc8:	fb040513          	addi	a0,s0,-80
    80004dcc:	9c5fe0ef          	jal	80003790 <namecmp>
    80004dd0:	10050463          	beqz	a0,80004ed8 <sys_unlink+0x160>
    80004dd4:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004dd6:	f2c40613          	addi	a2,s0,-212
    80004dda:	fb040593          	addi	a1,s0,-80
    80004dde:	8526                	mv	a0,s1
    80004de0:	9c7fe0ef          	jal	800037a6 <dirlookup>
    80004de4:	892a                	mv	s2,a0
    80004de6:	0e050863          	beqz	a0,80004ed6 <sys_unlink+0x15e>
  ilock(ip);
    80004dea:	d48fe0ef          	jal	80003332 <ilock>
  if(ip->nlink < 1)
    80004dee:	04a91783          	lh	a5,74(s2)
    80004df2:	06f05763          	blez	a5,80004e60 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004df6:	04491703          	lh	a4,68(s2)
    80004dfa:	4785                	li	a5,1
    80004dfc:	06f70963          	beq	a4,a5,80004e6e <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004e00:	4641                	li	a2,16
    80004e02:	4581                	li	a1,0
    80004e04:	fc040513          	addi	a0,s0,-64
    80004e08:	ec3fb0ef          	jal	80000cca <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e0c:	4741                	li	a4,16
    80004e0e:	f2c42683          	lw	a3,-212(s0)
    80004e12:	fc040613          	addi	a2,s0,-64
    80004e16:	4581                	li	a1,0
    80004e18:	8526                	mv	a0,s1
    80004e1a:	869fe0ef          	jal	80003682 <writei>
    80004e1e:	47c1                	li	a5,16
    80004e20:	08f51b63          	bne	a0,a5,80004eb6 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004e24:	04491703          	lh	a4,68(s2)
    80004e28:	4785                	li	a5,1
    80004e2a:	08f70d63          	beq	a4,a5,80004ec4 <sys_unlink+0x14c>
  iunlockput(dp);
    80004e2e:	8526                	mv	a0,s1
    80004e30:	f0cfe0ef          	jal	8000353c <iunlockput>
  ip->nlink--;
    80004e34:	04a95783          	lhu	a5,74(s2)
    80004e38:	37fd                	addiw	a5,a5,-1
    80004e3a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004e3e:	854a                	mv	a0,s2
    80004e40:	c3efe0ef          	jal	8000327e <iupdate>
  iunlockput(ip);
    80004e44:	854a                	mv	a0,s2
    80004e46:	ef6fe0ef          	jal	8000353c <iunlockput>
  end_op();
    80004e4a:	de9fe0ef          	jal	80003c32 <end_op>
  return 0;
    80004e4e:	4501                	li	a0,0
    80004e50:	64ee                	ld	s1,216(sp)
    80004e52:	694e                	ld	s2,208(sp)
    80004e54:	a849                	j	80004ee6 <sys_unlink+0x16e>
    end_op();
    80004e56:	dddfe0ef          	jal	80003c32 <end_op>
    return -1;
    80004e5a:	557d                	li	a0,-1
    80004e5c:	64ee                	ld	s1,216(sp)
    80004e5e:	a061                	j	80004ee6 <sys_unlink+0x16e>
    80004e60:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004e62:	00002517          	auipc	a0,0x2
    80004e66:	7fe50513          	addi	a0,a0,2046 # 80007660 <etext+0x660>
    80004e6a:	92bfb0ef          	jal	80000794 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e6e:	04c92703          	lw	a4,76(s2)
    80004e72:	02000793          	li	a5,32
    80004e76:	f8e7f5e3          	bgeu	a5,a4,80004e00 <sys_unlink+0x88>
    80004e7a:	e5ce                	sd	s3,200(sp)
    80004e7c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e80:	4741                	li	a4,16
    80004e82:	86ce                	mv	a3,s3
    80004e84:	f1840613          	addi	a2,s0,-232
    80004e88:	4581                	li	a1,0
    80004e8a:	854a                	mv	a0,s2
    80004e8c:	efafe0ef          	jal	80003586 <readi>
    80004e90:	47c1                	li	a5,16
    80004e92:	00f51c63          	bne	a0,a5,80004eaa <sys_unlink+0x132>
    if(de.inum != 0)
    80004e96:	f1845783          	lhu	a5,-232(s0)
    80004e9a:	efa1                	bnez	a5,80004ef2 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e9c:	29c1                	addiw	s3,s3,16
    80004e9e:	04c92783          	lw	a5,76(s2)
    80004ea2:	fcf9efe3          	bltu	s3,a5,80004e80 <sys_unlink+0x108>
    80004ea6:	69ae                	ld	s3,200(sp)
    80004ea8:	bfa1                	j	80004e00 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004eaa:	00002517          	auipc	a0,0x2
    80004eae:	7ce50513          	addi	a0,a0,1998 # 80007678 <etext+0x678>
    80004eb2:	8e3fb0ef          	jal	80000794 <panic>
    80004eb6:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004eb8:	00002517          	auipc	a0,0x2
    80004ebc:	7d850513          	addi	a0,a0,2008 # 80007690 <etext+0x690>
    80004ec0:	8d5fb0ef          	jal	80000794 <panic>
    dp->nlink--;
    80004ec4:	04a4d783          	lhu	a5,74(s1)
    80004ec8:	37fd                	addiw	a5,a5,-1
    80004eca:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ece:	8526                	mv	a0,s1
    80004ed0:	baefe0ef          	jal	8000327e <iupdate>
    80004ed4:	bfa9                	j	80004e2e <sys_unlink+0xb6>
    80004ed6:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004ed8:	8526                	mv	a0,s1
    80004eda:	e62fe0ef          	jal	8000353c <iunlockput>
  end_op();
    80004ede:	d55fe0ef          	jal	80003c32 <end_op>
  return -1;
    80004ee2:	557d                	li	a0,-1
    80004ee4:	64ee                	ld	s1,216(sp)
}
    80004ee6:	70ae                	ld	ra,232(sp)
    80004ee8:	740e                	ld	s0,224(sp)
    80004eea:	616d                	addi	sp,sp,240
    80004eec:	8082                	ret
    return -1;
    80004eee:	557d                	li	a0,-1
    80004ef0:	bfdd                	j	80004ee6 <sys_unlink+0x16e>
    iunlockput(ip);
    80004ef2:	854a                	mv	a0,s2
    80004ef4:	e48fe0ef          	jal	8000353c <iunlockput>
    goto bad;
    80004ef8:	694e                	ld	s2,208(sp)
    80004efa:	69ae                	ld	s3,200(sp)
    80004efc:	bff1                	j	80004ed8 <sys_unlink+0x160>

0000000080004efe <sys_open>:

uint64
sys_open(void)
{
    80004efe:	7131                	addi	sp,sp,-192
    80004f00:	fd06                	sd	ra,184(sp)
    80004f02:	f922                	sd	s0,176(sp)
    80004f04:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004f06:	f4c40593          	addi	a1,s0,-180
    80004f0a:	4505                	li	a0,1
    80004f0c:	a11fd0ef          	jal	8000291c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004f10:	08000613          	li	a2,128
    80004f14:	f5040593          	addi	a1,s0,-176
    80004f18:	4501                	li	a0,0
    80004f1a:	a3bfd0ef          	jal	80002954 <argstr>
    80004f1e:	87aa                	mv	a5,a0
    return -1;
    80004f20:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004f22:	0a07c263          	bltz	a5,80004fc6 <sys_open+0xc8>
    80004f26:	f526                	sd	s1,168(sp)

  begin_op();
    80004f28:	ca1fe0ef          	jal	80003bc8 <begin_op>

  if(omode & O_CREATE){
    80004f2c:	f4c42783          	lw	a5,-180(s0)
    80004f30:	2007f793          	andi	a5,a5,512
    80004f34:	c3d5                	beqz	a5,80004fd8 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004f36:	4681                	li	a3,0
    80004f38:	4601                	li	a2,0
    80004f3a:	4589                	li	a1,2
    80004f3c:	f5040513          	addi	a0,s0,-176
    80004f40:	aa9ff0ef          	jal	800049e8 <create>
    80004f44:	84aa                	mv	s1,a0
    if(ip == 0){
    80004f46:	c541                	beqz	a0,80004fce <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004f48:	04449703          	lh	a4,68(s1)
    80004f4c:	478d                	li	a5,3
    80004f4e:	00f71763          	bne	a4,a5,80004f5c <sys_open+0x5e>
    80004f52:	0464d703          	lhu	a4,70(s1)
    80004f56:	47a5                	li	a5,9
    80004f58:	0ae7ed63          	bltu	a5,a4,80005012 <sys_open+0x114>
    80004f5c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004f5e:	fe1fe0ef          	jal	80003f3e <filealloc>
    80004f62:	892a                	mv	s2,a0
    80004f64:	c179                	beqz	a0,8000502a <sys_open+0x12c>
    80004f66:	ed4e                	sd	s3,152(sp)
    80004f68:	a43ff0ef          	jal	800049aa <fdalloc>
    80004f6c:	89aa                	mv	s3,a0
    80004f6e:	0a054a63          	bltz	a0,80005022 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004f72:	04449703          	lh	a4,68(s1)
    80004f76:	478d                	li	a5,3
    80004f78:	0cf70263          	beq	a4,a5,8000503c <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004f7c:	4789                	li	a5,2
    80004f7e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004f82:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004f86:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004f8a:	f4c42783          	lw	a5,-180(s0)
    80004f8e:	0017c713          	xori	a4,a5,1
    80004f92:	8b05                	andi	a4,a4,1
    80004f94:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f98:	0037f713          	andi	a4,a5,3
    80004f9c:	00e03733          	snez	a4,a4
    80004fa0:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004fa4:	4007f793          	andi	a5,a5,1024
    80004fa8:	c791                	beqz	a5,80004fb4 <sys_open+0xb6>
    80004faa:	04449703          	lh	a4,68(s1)
    80004fae:	4789                	li	a5,2
    80004fb0:	08f70d63          	beq	a4,a5,8000504a <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004fb4:	8526                	mv	a0,s1
    80004fb6:	c2afe0ef          	jal	800033e0 <iunlock>
  end_op();
    80004fba:	c79fe0ef          	jal	80003c32 <end_op>

  return fd;
    80004fbe:	854e                	mv	a0,s3
    80004fc0:	74aa                	ld	s1,168(sp)
    80004fc2:	790a                	ld	s2,160(sp)
    80004fc4:	69ea                	ld	s3,152(sp)
}
    80004fc6:	70ea                	ld	ra,184(sp)
    80004fc8:	744a                	ld	s0,176(sp)
    80004fca:	6129                	addi	sp,sp,192
    80004fcc:	8082                	ret
      end_op();
    80004fce:	c65fe0ef          	jal	80003c32 <end_op>
      return -1;
    80004fd2:	557d                	li	a0,-1
    80004fd4:	74aa                	ld	s1,168(sp)
    80004fd6:	bfc5                	j	80004fc6 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004fd8:	f5040513          	addi	a0,s0,-176
    80004fdc:	a31fe0ef          	jal	80003a0c <namei>
    80004fe0:	84aa                	mv	s1,a0
    80004fe2:	c11d                	beqz	a0,80005008 <sys_open+0x10a>
    ilock(ip);
    80004fe4:	b4efe0ef          	jal	80003332 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004fe8:	04449703          	lh	a4,68(s1)
    80004fec:	4785                	li	a5,1
    80004fee:	f4f71de3          	bne	a4,a5,80004f48 <sys_open+0x4a>
    80004ff2:	f4c42783          	lw	a5,-180(s0)
    80004ff6:	d3bd                	beqz	a5,80004f5c <sys_open+0x5e>
      iunlockput(ip);
    80004ff8:	8526                	mv	a0,s1
    80004ffa:	d42fe0ef          	jal	8000353c <iunlockput>
      end_op();
    80004ffe:	c35fe0ef          	jal	80003c32 <end_op>
      return -1;
    80005002:	557d                	li	a0,-1
    80005004:	74aa                	ld	s1,168(sp)
    80005006:	b7c1                	j	80004fc6 <sys_open+0xc8>
      end_op();
    80005008:	c2bfe0ef          	jal	80003c32 <end_op>
      return -1;
    8000500c:	557d                	li	a0,-1
    8000500e:	74aa                	ld	s1,168(sp)
    80005010:	bf5d                	j	80004fc6 <sys_open+0xc8>
    iunlockput(ip);
    80005012:	8526                	mv	a0,s1
    80005014:	d28fe0ef          	jal	8000353c <iunlockput>
    end_op();
    80005018:	c1bfe0ef          	jal	80003c32 <end_op>
    return -1;
    8000501c:	557d                	li	a0,-1
    8000501e:	74aa                	ld	s1,168(sp)
    80005020:	b75d                	j	80004fc6 <sys_open+0xc8>
      fileclose(f);
    80005022:	854a                	mv	a0,s2
    80005024:	fbffe0ef          	jal	80003fe2 <fileclose>
    80005028:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000502a:	8526                	mv	a0,s1
    8000502c:	d10fe0ef          	jal	8000353c <iunlockput>
    end_op();
    80005030:	c03fe0ef          	jal	80003c32 <end_op>
    return -1;
    80005034:	557d                	li	a0,-1
    80005036:	74aa                	ld	s1,168(sp)
    80005038:	790a                	ld	s2,160(sp)
    8000503a:	b771                	j	80004fc6 <sys_open+0xc8>
    f->type = FD_DEVICE;
    8000503c:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005040:	04649783          	lh	a5,70(s1)
    80005044:	02f91223          	sh	a5,36(s2)
    80005048:	bf3d                	j	80004f86 <sys_open+0x88>
    itrunc(ip);
    8000504a:	8526                	mv	a0,s1
    8000504c:	bd4fe0ef          	jal	80003420 <itrunc>
    80005050:	b795                	j	80004fb4 <sys_open+0xb6>

0000000080005052 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005052:	7175                	addi	sp,sp,-144
    80005054:	e506                	sd	ra,136(sp)
    80005056:	e122                	sd	s0,128(sp)
    80005058:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000505a:	b6ffe0ef          	jal	80003bc8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000505e:	08000613          	li	a2,128
    80005062:	f7040593          	addi	a1,s0,-144
    80005066:	4501                	li	a0,0
    80005068:	8edfd0ef          	jal	80002954 <argstr>
    8000506c:	02054363          	bltz	a0,80005092 <sys_mkdir+0x40>
    80005070:	4681                	li	a3,0
    80005072:	4601                	li	a2,0
    80005074:	4585                	li	a1,1
    80005076:	f7040513          	addi	a0,s0,-144
    8000507a:	96fff0ef          	jal	800049e8 <create>
    8000507e:	c911                	beqz	a0,80005092 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005080:	cbcfe0ef          	jal	8000353c <iunlockput>
  end_op();
    80005084:	baffe0ef          	jal	80003c32 <end_op>
  return 0;
    80005088:	4501                	li	a0,0
}
    8000508a:	60aa                	ld	ra,136(sp)
    8000508c:	640a                	ld	s0,128(sp)
    8000508e:	6149                	addi	sp,sp,144
    80005090:	8082                	ret
    end_op();
    80005092:	ba1fe0ef          	jal	80003c32 <end_op>
    return -1;
    80005096:	557d                	li	a0,-1
    80005098:	bfcd                	j	8000508a <sys_mkdir+0x38>

000000008000509a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000509a:	7135                	addi	sp,sp,-160
    8000509c:	ed06                	sd	ra,152(sp)
    8000509e:	e922                	sd	s0,144(sp)
    800050a0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800050a2:	b27fe0ef          	jal	80003bc8 <begin_op>
  argint(1, &major);
    800050a6:	f6c40593          	addi	a1,s0,-148
    800050aa:	4505                	li	a0,1
    800050ac:	871fd0ef          	jal	8000291c <argint>
  argint(2, &minor);
    800050b0:	f6840593          	addi	a1,s0,-152
    800050b4:	4509                	li	a0,2
    800050b6:	867fd0ef          	jal	8000291c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050ba:	08000613          	li	a2,128
    800050be:	f7040593          	addi	a1,s0,-144
    800050c2:	4501                	li	a0,0
    800050c4:	891fd0ef          	jal	80002954 <argstr>
    800050c8:	02054563          	bltz	a0,800050f2 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800050cc:	f6841683          	lh	a3,-152(s0)
    800050d0:	f6c41603          	lh	a2,-148(s0)
    800050d4:	458d                	li	a1,3
    800050d6:	f7040513          	addi	a0,s0,-144
    800050da:	90fff0ef          	jal	800049e8 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050de:	c911                	beqz	a0,800050f2 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050e0:	c5cfe0ef          	jal	8000353c <iunlockput>
  end_op();
    800050e4:	b4ffe0ef          	jal	80003c32 <end_op>
  return 0;
    800050e8:	4501                	li	a0,0
}
    800050ea:	60ea                	ld	ra,152(sp)
    800050ec:	644a                	ld	s0,144(sp)
    800050ee:	610d                	addi	sp,sp,160
    800050f0:	8082                	ret
    end_op();
    800050f2:	b41fe0ef          	jal	80003c32 <end_op>
    return -1;
    800050f6:	557d                	li	a0,-1
    800050f8:	bfcd                	j	800050ea <sys_mknod+0x50>

00000000800050fa <sys_chdir>:

uint64
sys_chdir(void)
{
    800050fa:	7135                	addi	sp,sp,-160
    800050fc:	ed06                	sd	ra,152(sp)
    800050fe:	e922                	sd	s0,144(sp)
    80005100:	e14a                	sd	s2,128(sp)
    80005102:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005104:	fc0fc0ef          	jal	800018c4 <myproc>
    80005108:	892a                	mv	s2,a0
  
  begin_op();
    8000510a:	abffe0ef          	jal	80003bc8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000510e:	08000613          	li	a2,128
    80005112:	f6040593          	addi	a1,s0,-160
    80005116:	4501                	li	a0,0
    80005118:	83dfd0ef          	jal	80002954 <argstr>
    8000511c:	04054363          	bltz	a0,80005162 <sys_chdir+0x68>
    80005120:	e526                	sd	s1,136(sp)
    80005122:	f6040513          	addi	a0,s0,-160
    80005126:	8e7fe0ef          	jal	80003a0c <namei>
    8000512a:	84aa                	mv	s1,a0
    8000512c:	c915                	beqz	a0,80005160 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000512e:	a04fe0ef          	jal	80003332 <ilock>
  if(ip->type != T_DIR){
    80005132:	04449703          	lh	a4,68(s1)
    80005136:	4785                	li	a5,1
    80005138:	02f71963          	bne	a4,a5,8000516a <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000513c:	8526                	mv	a0,s1
    8000513e:	aa2fe0ef          	jal	800033e0 <iunlock>
  iput(p->cwd);
    80005142:	15893503          	ld	a0,344(s2)
    80005146:	b6efe0ef          	jal	800034b4 <iput>
  end_op();
    8000514a:	ae9fe0ef          	jal	80003c32 <end_op>
  p->cwd = ip;
    8000514e:	14993c23          	sd	s1,344(s2)
  return 0;
    80005152:	4501                	li	a0,0
    80005154:	64aa                	ld	s1,136(sp)
}
    80005156:	60ea                	ld	ra,152(sp)
    80005158:	644a                	ld	s0,144(sp)
    8000515a:	690a                	ld	s2,128(sp)
    8000515c:	610d                	addi	sp,sp,160
    8000515e:	8082                	ret
    80005160:	64aa                	ld	s1,136(sp)
    end_op();
    80005162:	ad1fe0ef          	jal	80003c32 <end_op>
    return -1;
    80005166:	557d                	li	a0,-1
    80005168:	b7fd                	j	80005156 <sys_chdir+0x5c>
    iunlockput(ip);
    8000516a:	8526                	mv	a0,s1
    8000516c:	bd0fe0ef          	jal	8000353c <iunlockput>
    end_op();
    80005170:	ac3fe0ef          	jal	80003c32 <end_op>
    return -1;
    80005174:	557d                	li	a0,-1
    80005176:	64aa                	ld	s1,136(sp)
    80005178:	bff9                	j	80005156 <sys_chdir+0x5c>

000000008000517a <sys_exec>:

uint64
sys_exec(void)
{
    8000517a:	7121                	addi	sp,sp,-448
    8000517c:	ff06                	sd	ra,440(sp)
    8000517e:	fb22                	sd	s0,432(sp)
    80005180:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005182:	e4840593          	addi	a1,s0,-440
    80005186:	4505                	li	a0,1
    80005188:	fb0fd0ef          	jal	80002938 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000518c:	08000613          	li	a2,128
    80005190:	f5040593          	addi	a1,s0,-176
    80005194:	4501                	li	a0,0
    80005196:	fbefd0ef          	jal	80002954 <argstr>
    8000519a:	87aa                	mv	a5,a0
    return -1;
    8000519c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000519e:	0c07c463          	bltz	a5,80005266 <sys_exec+0xec>
    800051a2:	f726                	sd	s1,424(sp)
    800051a4:	f34a                	sd	s2,416(sp)
    800051a6:	ef4e                	sd	s3,408(sp)
    800051a8:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800051aa:	10000613          	li	a2,256
    800051ae:	4581                	li	a1,0
    800051b0:	e5040513          	addi	a0,s0,-432
    800051b4:	b17fb0ef          	jal	80000cca <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800051b8:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800051bc:	89a6                	mv	s3,s1
    800051be:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800051c0:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800051c4:	00391513          	slli	a0,s2,0x3
    800051c8:	e4040593          	addi	a1,s0,-448
    800051cc:	e4843783          	ld	a5,-440(s0)
    800051d0:	953e                	add	a0,a0,a5
    800051d2:	ec0fd0ef          	jal	80002892 <fetchaddr>
    800051d6:	02054663          	bltz	a0,80005202 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800051da:	e4043783          	ld	a5,-448(s0)
    800051de:	c3a9                	beqz	a5,80005220 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800051e0:	947fb0ef          	jal	80000b26 <kalloc>
    800051e4:	85aa                	mv	a1,a0
    800051e6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800051ea:	cd01                	beqz	a0,80005202 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800051ec:	6605                	lui	a2,0x1
    800051ee:	e4043503          	ld	a0,-448(s0)
    800051f2:	eeafd0ef          	jal	800028dc <fetchstr>
    800051f6:	00054663          	bltz	a0,80005202 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800051fa:	0905                	addi	s2,s2,1
    800051fc:	09a1                	addi	s3,s3,8
    800051fe:	fd4913e3          	bne	s2,s4,800051c4 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005202:	f5040913          	addi	s2,s0,-176
    80005206:	6088                	ld	a0,0(s1)
    80005208:	c931                	beqz	a0,8000525c <sys_exec+0xe2>
    kfree(argv[i]);
    8000520a:	839fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000520e:	04a1                	addi	s1,s1,8
    80005210:	ff249be3          	bne	s1,s2,80005206 <sys_exec+0x8c>
  return -1;
    80005214:	557d                	li	a0,-1
    80005216:	74ba                	ld	s1,424(sp)
    80005218:	791a                	ld	s2,416(sp)
    8000521a:	69fa                	ld	s3,408(sp)
    8000521c:	6a5a                	ld	s4,400(sp)
    8000521e:	a0a1                	j	80005266 <sys_exec+0xec>
      argv[i] = 0;
    80005220:	0009079b          	sext.w	a5,s2
    80005224:	078e                	slli	a5,a5,0x3
    80005226:	fd078793          	addi	a5,a5,-48
    8000522a:	97a2                	add	a5,a5,s0
    8000522c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005230:	e5040593          	addi	a1,s0,-432
    80005234:	f5040513          	addi	a0,s0,-176
    80005238:	ba8ff0ef          	jal	800045e0 <exec>
    8000523c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000523e:	f5040993          	addi	s3,s0,-176
    80005242:	6088                	ld	a0,0(s1)
    80005244:	c511                	beqz	a0,80005250 <sys_exec+0xd6>
    kfree(argv[i]);
    80005246:	ffcfb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000524a:	04a1                	addi	s1,s1,8
    8000524c:	ff349be3          	bne	s1,s3,80005242 <sys_exec+0xc8>
  return ret;
    80005250:	854a                	mv	a0,s2
    80005252:	74ba                	ld	s1,424(sp)
    80005254:	791a                	ld	s2,416(sp)
    80005256:	69fa                	ld	s3,408(sp)
    80005258:	6a5a                	ld	s4,400(sp)
    8000525a:	a031                	j	80005266 <sys_exec+0xec>
  return -1;
    8000525c:	557d                	li	a0,-1
    8000525e:	74ba                	ld	s1,424(sp)
    80005260:	791a                	ld	s2,416(sp)
    80005262:	69fa                	ld	s3,408(sp)
    80005264:	6a5a                	ld	s4,400(sp)
}
    80005266:	70fa                	ld	ra,440(sp)
    80005268:	745a                	ld	s0,432(sp)
    8000526a:	6139                	addi	sp,sp,448
    8000526c:	8082                	ret

000000008000526e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000526e:	7139                	addi	sp,sp,-64
    80005270:	fc06                	sd	ra,56(sp)
    80005272:	f822                	sd	s0,48(sp)
    80005274:	f426                	sd	s1,40(sp)
    80005276:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005278:	e4cfc0ef          	jal	800018c4 <myproc>
    8000527c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000527e:	fd840593          	addi	a1,s0,-40
    80005282:	4501                	li	a0,0
    80005284:	eb4fd0ef          	jal	80002938 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005288:	fc840593          	addi	a1,s0,-56
    8000528c:	fd040513          	addi	a0,s0,-48
    80005290:	85cff0ef          	jal	800042ec <pipealloc>
    return -1;
    80005294:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005296:	0a054463          	bltz	a0,8000533e <sys_pipe+0xd0>
  fd0 = -1;
    8000529a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000529e:	fd043503          	ld	a0,-48(s0)
    800052a2:	f08ff0ef          	jal	800049aa <fdalloc>
    800052a6:	fca42223          	sw	a0,-60(s0)
    800052aa:	08054163          	bltz	a0,8000532c <sys_pipe+0xbe>
    800052ae:	fc843503          	ld	a0,-56(s0)
    800052b2:	ef8ff0ef          	jal	800049aa <fdalloc>
    800052b6:	fca42023          	sw	a0,-64(s0)
    800052ba:	06054063          	bltz	a0,8000531a <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052be:	4691                	li	a3,4
    800052c0:	fc440613          	addi	a2,s0,-60
    800052c4:	fd843583          	ld	a1,-40(s0)
    800052c8:	68a8                	ld	a0,80(s1)
    800052ca:	a5efc0ef          	jal	80001528 <copyout>
    800052ce:	00054e63          	bltz	a0,800052ea <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800052d2:	4691                	li	a3,4
    800052d4:	fc040613          	addi	a2,s0,-64
    800052d8:	fd843583          	ld	a1,-40(s0)
    800052dc:	0591                	addi	a1,a1,4
    800052de:	68a8                	ld	a0,80(s1)
    800052e0:	a48fc0ef          	jal	80001528 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800052e4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052e6:	04055c63          	bgez	a0,8000533e <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800052ea:	fc442783          	lw	a5,-60(s0)
    800052ee:	07e9                	addi	a5,a5,26
    800052f0:	078e                	slli	a5,a5,0x3
    800052f2:	97a6                	add	a5,a5,s1
    800052f4:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800052f8:	fc042783          	lw	a5,-64(s0)
    800052fc:	07e9                	addi	a5,a5,26
    800052fe:	078e                	slli	a5,a5,0x3
    80005300:	94be                	add	s1,s1,a5
    80005302:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005306:	fd043503          	ld	a0,-48(s0)
    8000530a:	cd9fe0ef          	jal	80003fe2 <fileclose>
    fileclose(wf);
    8000530e:	fc843503          	ld	a0,-56(s0)
    80005312:	cd1fe0ef          	jal	80003fe2 <fileclose>
    return -1;
    80005316:	57fd                	li	a5,-1
    80005318:	a01d                	j	8000533e <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000531a:	fc442783          	lw	a5,-60(s0)
    8000531e:	0007c763          	bltz	a5,8000532c <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005322:	07e9                	addi	a5,a5,26
    80005324:	078e                	slli	a5,a5,0x3
    80005326:	97a6                	add	a5,a5,s1
    80005328:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    8000532c:	fd043503          	ld	a0,-48(s0)
    80005330:	cb3fe0ef          	jal	80003fe2 <fileclose>
    fileclose(wf);
    80005334:	fc843503          	ld	a0,-56(s0)
    80005338:	cabfe0ef          	jal	80003fe2 <fileclose>
    return -1;
    8000533c:	57fd                	li	a5,-1
}
    8000533e:	853e                	mv	a0,a5
    80005340:	70e2                	ld	ra,56(sp)
    80005342:	7442                	ld	s0,48(sp)
    80005344:	74a2                	ld	s1,40(sp)
    80005346:	6121                	addi	sp,sp,64
    80005348:	8082                	ret
    8000534a:	0000                	unimp
    8000534c:	0000                	unimp
	...

0000000080005350 <kernelvec>:
    80005350:	7111                	addi	sp,sp,-256
    80005352:	e006                	sd	ra,0(sp)
    80005354:	e40a                	sd	sp,8(sp)
    80005356:	e80e                	sd	gp,16(sp)
    80005358:	ec12                	sd	tp,24(sp)
    8000535a:	f016                	sd	t0,32(sp)
    8000535c:	f41a                	sd	t1,40(sp)
    8000535e:	f81e                	sd	t2,48(sp)
    80005360:	e4aa                	sd	a0,72(sp)
    80005362:	e8ae                	sd	a1,80(sp)
    80005364:	ecb2                	sd	a2,88(sp)
    80005366:	f0b6                	sd	a3,96(sp)
    80005368:	f4ba                	sd	a4,104(sp)
    8000536a:	f8be                	sd	a5,112(sp)
    8000536c:	fcc2                	sd	a6,120(sp)
    8000536e:	e146                	sd	a7,128(sp)
    80005370:	edf2                	sd	t3,216(sp)
    80005372:	f1f6                	sd	t4,224(sp)
    80005374:	f5fa                	sd	t5,232(sp)
    80005376:	f9fe                	sd	t6,240(sp)
    80005378:	c2afd0ef          	jal	800027a2 <kerneltrap>
    8000537c:	6082                	ld	ra,0(sp)
    8000537e:	6122                	ld	sp,8(sp)
    80005380:	61c2                	ld	gp,16(sp)
    80005382:	7282                	ld	t0,32(sp)
    80005384:	7322                	ld	t1,40(sp)
    80005386:	73c2                	ld	t2,48(sp)
    80005388:	6526                	ld	a0,72(sp)
    8000538a:	65c6                	ld	a1,80(sp)
    8000538c:	6666                	ld	a2,88(sp)
    8000538e:	7686                	ld	a3,96(sp)
    80005390:	7726                	ld	a4,104(sp)
    80005392:	77c6                	ld	a5,112(sp)
    80005394:	7866                	ld	a6,120(sp)
    80005396:	688a                	ld	a7,128(sp)
    80005398:	6e6e                	ld	t3,216(sp)
    8000539a:	7e8e                	ld	t4,224(sp)
    8000539c:	7f2e                	ld	t5,232(sp)
    8000539e:	7fce                	ld	t6,240(sp)
    800053a0:	6111                	addi	sp,sp,256
    800053a2:	10200073          	sret
	...

00000000800053ae <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800053ae:	1141                	addi	sp,sp,-16
    800053b0:	e422                	sd	s0,8(sp)
    800053b2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800053b4:	0c0007b7          	lui	a5,0xc000
    800053b8:	4705                	li	a4,1
    800053ba:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800053bc:	0c0007b7          	lui	a5,0xc000
    800053c0:	c3d8                	sw	a4,4(a5)
}
    800053c2:	6422                	ld	s0,8(sp)
    800053c4:	0141                	addi	sp,sp,16
    800053c6:	8082                	ret

00000000800053c8 <plicinithart>:

void
plicinithart(void)
{
    800053c8:	1141                	addi	sp,sp,-16
    800053ca:	e406                	sd	ra,8(sp)
    800053cc:	e022                	sd	s0,0(sp)
    800053ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053d0:	cc8fc0ef          	jal	80001898 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800053d4:	0085171b          	slliw	a4,a0,0x8
    800053d8:	0c0027b7          	lui	a5,0xc002
    800053dc:	97ba                	add	a5,a5,a4
    800053de:	40200713          	li	a4,1026
    800053e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053e6:	00d5151b          	slliw	a0,a0,0xd
    800053ea:	0c2017b7          	lui	a5,0xc201
    800053ee:	97aa                	add	a5,a5,a0
    800053f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800053f4:	60a2                	ld	ra,8(sp)
    800053f6:	6402                	ld	s0,0(sp)
    800053f8:	0141                	addi	sp,sp,16
    800053fa:	8082                	ret

00000000800053fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800053fc:	1141                	addi	sp,sp,-16
    800053fe:	e406                	sd	ra,8(sp)
    80005400:	e022                	sd	s0,0(sp)
    80005402:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005404:	c94fc0ef          	jal	80001898 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005408:	00d5151b          	slliw	a0,a0,0xd
    8000540c:	0c2017b7          	lui	a5,0xc201
    80005410:	97aa                	add	a5,a5,a0
  return irq;
}
    80005412:	43c8                	lw	a0,4(a5)
    80005414:	60a2                	ld	ra,8(sp)
    80005416:	6402                	ld	s0,0(sp)
    80005418:	0141                	addi	sp,sp,16
    8000541a:	8082                	ret

000000008000541c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000541c:	1101                	addi	sp,sp,-32
    8000541e:	ec06                	sd	ra,24(sp)
    80005420:	e822                	sd	s0,16(sp)
    80005422:	e426                	sd	s1,8(sp)
    80005424:	1000                	addi	s0,sp,32
    80005426:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005428:	c70fc0ef          	jal	80001898 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000542c:	00d5151b          	slliw	a0,a0,0xd
    80005430:	0c2017b7          	lui	a5,0xc201
    80005434:	97aa                	add	a5,a5,a0
    80005436:	c3c4                	sw	s1,4(a5)
}
    80005438:	60e2                	ld	ra,24(sp)
    8000543a:	6442                	ld	s0,16(sp)
    8000543c:	64a2                	ld	s1,8(sp)
    8000543e:	6105                	addi	sp,sp,32
    80005440:	8082                	ret

0000000080005442 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005442:	1141                	addi	sp,sp,-16
    80005444:	e406                	sd	ra,8(sp)
    80005446:	e022                	sd	s0,0(sp)
    80005448:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000544a:	479d                	li	a5,7
    8000544c:	04a7ca63          	blt	a5,a0,800054a0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005450:	00016797          	auipc	a5,0x16
    80005454:	4e078793          	addi	a5,a5,1248 # 8001b930 <disk>
    80005458:	97aa                	add	a5,a5,a0
    8000545a:	0187c783          	lbu	a5,24(a5)
    8000545e:	e7b9                	bnez	a5,800054ac <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005460:	00451693          	slli	a3,a0,0x4
    80005464:	00016797          	auipc	a5,0x16
    80005468:	4cc78793          	addi	a5,a5,1228 # 8001b930 <disk>
    8000546c:	6398                	ld	a4,0(a5)
    8000546e:	9736                	add	a4,a4,a3
    80005470:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005474:	6398                	ld	a4,0(a5)
    80005476:	9736                	add	a4,a4,a3
    80005478:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000547c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005480:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005484:	97aa                	add	a5,a5,a0
    80005486:	4705                	li	a4,1
    80005488:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000548c:	00016517          	auipc	a0,0x16
    80005490:	4bc50513          	addi	a0,a0,1212 # 8001b948 <disk+0x18>
    80005494:	fe0fc0ef          	jal	80001c74 <wakeup>
}
    80005498:	60a2                	ld	ra,8(sp)
    8000549a:	6402                	ld	s0,0(sp)
    8000549c:	0141                	addi	sp,sp,16
    8000549e:	8082                	ret
    panic("free_desc 1");
    800054a0:	00002517          	auipc	a0,0x2
    800054a4:	20050513          	addi	a0,a0,512 # 800076a0 <etext+0x6a0>
    800054a8:	aecfb0ef          	jal	80000794 <panic>
    panic("free_desc 2");
    800054ac:	00002517          	auipc	a0,0x2
    800054b0:	20450513          	addi	a0,a0,516 # 800076b0 <etext+0x6b0>
    800054b4:	ae0fb0ef          	jal	80000794 <panic>

00000000800054b8 <virtio_disk_init>:
{
    800054b8:	1101                	addi	sp,sp,-32
    800054ba:	ec06                	sd	ra,24(sp)
    800054bc:	e822                	sd	s0,16(sp)
    800054be:	e426                	sd	s1,8(sp)
    800054c0:	e04a                	sd	s2,0(sp)
    800054c2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054c4:	00002597          	auipc	a1,0x2
    800054c8:	1fc58593          	addi	a1,a1,508 # 800076c0 <etext+0x6c0>
    800054cc:	00016517          	auipc	a0,0x16
    800054d0:	58c50513          	addi	a0,a0,1420 # 8001ba58 <disk+0x128>
    800054d4:	ea2fb0ef          	jal	80000b76 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054d8:	100017b7          	lui	a5,0x10001
    800054dc:	4398                	lw	a4,0(a5)
    800054de:	2701                	sext.w	a4,a4
    800054e0:	747277b7          	lui	a5,0x74727
    800054e4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054e8:	18f71063          	bne	a4,a5,80005668 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054ec:	100017b7          	lui	a5,0x10001
    800054f0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800054f2:	439c                	lw	a5,0(a5)
    800054f4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054f6:	4709                	li	a4,2
    800054f8:	16e79863          	bne	a5,a4,80005668 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054fc:	100017b7          	lui	a5,0x10001
    80005500:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005502:	439c                	lw	a5,0(a5)
    80005504:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005506:	16e79163          	bne	a5,a4,80005668 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000550a:	100017b7          	lui	a5,0x10001
    8000550e:	47d8                	lw	a4,12(a5)
    80005510:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005512:	554d47b7          	lui	a5,0x554d4
    80005516:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000551a:	14f71763          	bne	a4,a5,80005668 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000551e:	100017b7          	lui	a5,0x10001
    80005522:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005526:	4705                	li	a4,1
    80005528:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000552a:	470d                	li	a4,3
    8000552c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000552e:	10001737          	lui	a4,0x10001
    80005532:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005534:	c7ffe737          	lui	a4,0xc7ffe
    80005538:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fe2cef>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000553c:	8ef9                	and	a3,a3,a4
    8000553e:	10001737          	lui	a4,0x10001
    80005542:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005544:	472d                	li	a4,11
    80005546:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005548:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000554c:	439c                	lw	a5,0(a5)
    8000554e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005552:	8ba1                	andi	a5,a5,8
    80005554:	12078063          	beqz	a5,80005674 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005558:	100017b7          	lui	a5,0x10001
    8000555c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005560:	100017b7          	lui	a5,0x10001
    80005564:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005568:	439c                	lw	a5,0(a5)
    8000556a:	2781                	sext.w	a5,a5
    8000556c:	10079a63          	bnez	a5,80005680 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005570:	100017b7          	lui	a5,0x10001
    80005574:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005578:	439c                	lw	a5,0(a5)
    8000557a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000557c:	10078863          	beqz	a5,8000568c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005580:	471d                	li	a4,7
    80005582:	10f77b63          	bgeu	a4,a5,80005698 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005586:	da0fb0ef          	jal	80000b26 <kalloc>
    8000558a:	00016497          	auipc	s1,0x16
    8000558e:	3a648493          	addi	s1,s1,934 # 8001b930 <disk>
    80005592:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005594:	d92fb0ef          	jal	80000b26 <kalloc>
    80005598:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000559a:	d8cfb0ef          	jal	80000b26 <kalloc>
    8000559e:	87aa                	mv	a5,a0
    800055a0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800055a2:	6088                	ld	a0,0(s1)
    800055a4:	10050063          	beqz	a0,800056a4 <virtio_disk_init+0x1ec>
    800055a8:	00016717          	auipc	a4,0x16
    800055ac:	39073703          	ld	a4,912(a4) # 8001b938 <disk+0x8>
    800055b0:	0e070a63          	beqz	a4,800056a4 <virtio_disk_init+0x1ec>
    800055b4:	0e078863          	beqz	a5,800056a4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800055b8:	6605                	lui	a2,0x1
    800055ba:	4581                	li	a1,0
    800055bc:	f0efb0ef          	jal	80000cca <memset>
  memset(disk.avail, 0, PGSIZE);
    800055c0:	00016497          	auipc	s1,0x16
    800055c4:	37048493          	addi	s1,s1,880 # 8001b930 <disk>
    800055c8:	6605                	lui	a2,0x1
    800055ca:	4581                	li	a1,0
    800055cc:	6488                	ld	a0,8(s1)
    800055ce:	efcfb0ef          	jal	80000cca <memset>
  memset(disk.used, 0, PGSIZE);
    800055d2:	6605                	lui	a2,0x1
    800055d4:	4581                	li	a1,0
    800055d6:	6888                	ld	a0,16(s1)
    800055d8:	ef2fb0ef          	jal	80000cca <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055dc:	100017b7          	lui	a5,0x10001
    800055e0:	4721                	li	a4,8
    800055e2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800055e4:	4098                	lw	a4,0(s1)
    800055e6:	100017b7          	lui	a5,0x10001
    800055ea:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800055ee:	40d8                	lw	a4,4(s1)
    800055f0:	100017b7          	lui	a5,0x10001
    800055f4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800055f8:	649c                	ld	a5,8(s1)
    800055fa:	0007869b          	sext.w	a3,a5
    800055fe:	10001737          	lui	a4,0x10001
    80005602:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005606:	9781                	srai	a5,a5,0x20
    80005608:	10001737          	lui	a4,0x10001
    8000560c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005610:	689c                	ld	a5,16(s1)
    80005612:	0007869b          	sext.w	a3,a5
    80005616:	10001737          	lui	a4,0x10001
    8000561a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000561e:	9781                	srai	a5,a5,0x20
    80005620:	10001737          	lui	a4,0x10001
    80005624:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005628:	10001737          	lui	a4,0x10001
    8000562c:	4785                	li	a5,1
    8000562e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005630:	00f48c23          	sb	a5,24(s1)
    80005634:	00f48ca3          	sb	a5,25(s1)
    80005638:	00f48d23          	sb	a5,26(s1)
    8000563c:	00f48da3          	sb	a5,27(s1)
    80005640:	00f48e23          	sb	a5,28(s1)
    80005644:	00f48ea3          	sb	a5,29(s1)
    80005648:	00f48f23          	sb	a5,30(s1)
    8000564c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005650:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005654:	100017b7          	lui	a5,0x10001
    80005658:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000565c:	60e2                	ld	ra,24(sp)
    8000565e:	6442                	ld	s0,16(sp)
    80005660:	64a2                	ld	s1,8(sp)
    80005662:	6902                	ld	s2,0(sp)
    80005664:	6105                	addi	sp,sp,32
    80005666:	8082                	ret
    panic("could not find virtio disk");
    80005668:	00002517          	auipc	a0,0x2
    8000566c:	06850513          	addi	a0,a0,104 # 800076d0 <etext+0x6d0>
    80005670:	924fb0ef          	jal	80000794 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005674:	00002517          	auipc	a0,0x2
    80005678:	07c50513          	addi	a0,a0,124 # 800076f0 <etext+0x6f0>
    8000567c:	918fb0ef          	jal	80000794 <panic>
    panic("virtio disk should not be ready");
    80005680:	00002517          	auipc	a0,0x2
    80005684:	09050513          	addi	a0,a0,144 # 80007710 <etext+0x710>
    80005688:	90cfb0ef          	jal	80000794 <panic>
    panic("virtio disk has no queue 0");
    8000568c:	00002517          	auipc	a0,0x2
    80005690:	0a450513          	addi	a0,a0,164 # 80007730 <etext+0x730>
    80005694:	900fb0ef          	jal	80000794 <panic>
    panic("virtio disk max queue too short");
    80005698:	00002517          	auipc	a0,0x2
    8000569c:	0b850513          	addi	a0,a0,184 # 80007750 <etext+0x750>
    800056a0:	8f4fb0ef          	jal	80000794 <panic>
    panic("virtio disk kalloc");
    800056a4:	00002517          	auipc	a0,0x2
    800056a8:	0cc50513          	addi	a0,a0,204 # 80007770 <etext+0x770>
    800056ac:	8e8fb0ef          	jal	80000794 <panic>

00000000800056b0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800056b0:	7159                	addi	sp,sp,-112
    800056b2:	f486                	sd	ra,104(sp)
    800056b4:	f0a2                	sd	s0,96(sp)
    800056b6:	eca6                	sd	s1,88(sp)
    800056b8:	e8ca                	sd	s2,80(sp)
    800056ba:	e4ce                	sd	s3,72(sp)
    800056bc:	e0d2                	sd	s4,64(sp)
    800056be:	fc56                	sd	s5,56(sp)
    800056c0:	f85a                	sd	s6,48(sp)
    800056c2:	f45e                	sd	s7,40(sp)
    800056c4:	f062                	sd	s8,32(sp)
    800056c6:	ec66                	sd	s9,24(sp)
    800056c8:	1880                	addi	s0,sp,112
    800056ca:	8a2a                	mv	s4,a0
    800056cc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800056ce:	00c52c83          	lw	s9,12(a0)
    800056d2:	001c9c9b          	slliw	s9,s9,0x1
    800056d6:	1c82                	slli	s9,s9,0x20
    800056d8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800056dc:	00016517          	auipc	a0,0x16
    800056e0:	37c50513          	addi	a0,a0,892 # 8001ba58 <disk+0x128>
    800056e4:	d12fb0ef          	jal	80000bf6 <acquire>
  for(int i = 0; i < 3; i++){
    800056e8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800056ea:	44a1                	li	s1,8
      disk.free[i] = 0;
    800056ec:	00016b17          	auipc	s6,0x16
    800056f0:	244b0b13          	addi	s6,s6,580 # 8001b930 <disk>
  for(int i = 0; i < 3; i++){
    800056f4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056f6:	00016c17          	auipc	s8,0x16
    800056fa:	362c0c13          	addi	s8,s8,866 # 8001ba58 <disk+0x128>
    800056fe:	a8b9                	j	8000575c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005700:	00fb0733          	add	a4,s6,a5
    80005704:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005708:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000570a:	0207c563          	bltz	a5,80005734 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    8000570e:	2905                	addiw	s2,s2,1
    80005710:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005712:	05590963          	beq	s2,s5,80005764 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005716:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005718:	00016717          	auipc	a4,0x16
    8000571c:	21870713          	addi	a4,a4,536 # 8001b930 <disk>
    80005720:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005722:	01874683          	lbu	a3,24(a4)
    80005726:	fee9                	bnez	a3,80005700 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005728:	2785                	addiw	a5,a5,1
    8000572a:	0705                	addi	a4,a4,1
    8000572c:	fe979be3          	bne	a5,s1,80005722 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005730:	57fd                	li	a5,-1
    80005732:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005734:	01205d63          	blez	s2,8000574e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005738:	f9042503          	lw	a0,-112(s0)
    8000573c:	d07ff0ef          	jal	80005442 <free_desc>
      for(int j = 0; j < i; j++)
    80005740:	4785                	li	a5,1
    80005742:	0127d663          	bge	a5,s2,8000574e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005746:	f9442503          	lw	a0,-108(s0)
    8000574a:	cf9ff0ef          	jal	80005442 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000574e:	85e2                	mv	a1,s8
    80005750:	00016517          	auipc	a0,0x16
    80005754:	1f850513          	addi	a0,a0,504 # 8001b948 <disk+0x18>
    80005758:	cd0fc0ef          	jal	80001c28 <sleep>
  for(int i = 0; i < 3; i++){
    8000575c:	f9040613          	addi	a2,s0,-112
    80005760:	894e                	mv	s2,s3
    80005762:	bf55                	j	80005716 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005764:	f9042503          	lw	a0,-112(s0)
    80005768:	00451693          	slli	a3,a0,0x4

  if(write)
    8000576c:	00016797          	auipc	a5,0x16
    80005770:	1c478793          	addi	a5,a5,452 # 8001b930 <disk>
    80005774:	00a50713          	addi	a4,a0,10
    80005778:	0712                	slli	a4,a4,0x4
    8000577a:	973e                	add	a4,a4,a5
    8000577c:	01703633          	snez	a2,s7
    80005780:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005782:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005786:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000578a:	6398                	ld	a4,0(a5)
    8000578c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000578e:	0a868613          	addi	a2,a3,168
    80005792:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005794:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005796:	6390                	ld	a2,0(a5)
    80005798:	00d605b3          	add	a1,a2,a3
    8000579c:	4741                	li	a4,16
    8000579e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800057a0:	4805                	li	a6,1
    800057a2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800057a6:	f9442703          	lw	a4,-108(s0)
    800057aa:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800057ae:	0712                	slli	a4,a4,0x4
    800057b0:	963a                	add	a2,a2,a4
    800057b2:	058a0593          	addi	a1,s4,88
    800057b6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800057b8:	0007b883          	ld	a7,0(a5)
    800057bc:	9746                	add	a4,a4,a7
    800057be:	40000613          	li	a2,1024
    800057c2:	c710                	sw	a2,8(a4)
  if(write)
    800057c4:	001bb613          	seqz	a2,s7
    800057c8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800057cc:	00166613          	ori	a2,a2,1
    800057d0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800057d4:	f9842583          	lw	a1,-104(s0)
    800057d8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800057dc:	00250613          	addi	a2,a0,2
    800057e0:	0612                	slli	a2,a2,0x4
    800057e2:	963e                	add	a2,a2,a5
    800057e4:	577d                	li	a4,-1
    800057e6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800057ea:	0592                	slli	a1,a1,0x4
    800057ec:	98ae                	add	a7,a7,a1
    800057ee:	03068713          	addi	a4,a3,48
    800057f2:	973e                	add	a4,a4,a5
    800057f4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800057f8:	6398                	ld	a4,0(a5)
    800057fa:	972e                	add	a4,a4,a1
    800057fc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005800:	4689                	li	a3,2
    80005802:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005806:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000580a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    8000580e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005812:	6794                	ld	a3,8(a5)
    80005814:	0026d703          	lhu	a4,2(a3)
    80005818:	8b1d                	andi	a4,a4,7
    8000581a:	0706                	slli	a4,a4,0x1
    8000581c:	96ba                	add	a3,a3,a4
    8000581e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005822:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005826:	6798                	ld	a4,8(a5)
    80005828:	00275783          	lhu	a5,2(a4)
    8000582c:	2785                	addiw	a5,a5,1
    8000582e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005832:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005836:	100017b7          	lui	a5,0x10001
    8000583a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000583e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005842:	00016917          	auipc	s2,0x16
    80005846:	21690913          	addi	s2,s2,534 # 8001ba58 <disk+0x128>
  while(b->disk == 1) {
    8000584a:	4485                	li	s1,1
    8000584c:	01079a63          	bne	a5,a6,80005860 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005850:	85ca                	mv	a1,s2
    80005852:	8552                	mv	a0,s4
    80005854:	bd4fc0ef          	jal	80001c28 <sleep>
  while(b->disk == 1) {
    80005858:	004a2783          	lw	a5,4(s4)
    8000585c:	fe978ae3          	beq	a5,s1,80005850 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005860:	f9042903          	lw	s2,-112(s0)
    80005864:	00290713          	addi	a4,s2,2
    80005868:	0712                	slli	a4,a4,0x4
    8000586a:	00016797          	auipc	a5,0x16
    8000586e:	0c678793          	addi	a5,a5,198 # 8001b930 <disk>
    80005872:	97ba                	add	a5,a5,a4
    80005874:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005878:	00016997          	auipc	s3,0x16
    8000587c:	0b898993          	addi	s3,s3,184 # 8001b930 <disk>
    80005880:	00491713          	slli	a4,s2,0x4
    80005884:	0009b783          	ld	a5,0(s3)
    80005888:	97ba                	add	a5,a5,a4
    8000588a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000588e:	854a                	mv	a0,s2
    80005890:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005894:	bafff0ef          	jal	80005442 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005898:	8885                	andi	s1,s1,1
    8000589a:	f0fd                	bnez	s1,80005880 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000589c:	00016517          	auipc	a0,0x16
    800058a0:	1bc50513          	addi	a0,a0,444 # 8001ba58 <disk+0x128>
    800058a4:	beafb0ef          	jal	80000c8e <release>
}
    800058a8:	70a6                	ld	ra,104(sp)
    800058aa:	7406                	ld	s0,96(sp)
    800058ac:	64e6                	ld	s1,88(sp)
    800058ae:	6946                	ld	s2,80(sp)
    800058b0:	69a6                	ld	s3,72(sp)
    800058b2:	6a06                	ld	s4,64(sp)
    800058b4:	7ae2                	ld	s5,56(sp)
    800058b6:	7b42                	ld	s6,48(sp)
    800058b8:	7ba2                	ld	s7,40(sp)
    800058ba:	7c02                	ld	s8,32(sp)
    800058bc:	6ce2                	ld	s9,24(sp)
    800058be:	6165                	addi	sp,sp,112
    800058c0:	8082                	ret

00000000800058c2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058c2:	1101                	addi	sp,sp,-32
    800058c4:	ec06                	sd	ra,24(sp)
    800058c6:	e822                	sd	s0,16(sp)
    800058c8:	e426                	sd	s1,8(sp)
    800058ca:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058cc:	00016497          	auipc	s1,0x16
    800058d0:	06448493          	addi	s1,s1,100 # 8001b930 <disk>
    800058d4:	00016517          	auipc	a0,0x16
    800058d8:	18450513          	addi	a0,a0,388 # 8001ba58 <disk+0x128>
    800058dc:	b1afb0ef          	jal	80000bf6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058e0:	100017b7          	lui	a5,0x10001
    800058e4:	53b8                	lw	a4,96(a5)
    800058e6:	8b0d                	andi	a4,a4,3
    800058e8:	100017b7          	lui	a5,0x10001
    800058ec:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800058ee:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058f2:	689c                	ld	a5,16(s1)
    800058f4:	0204d703          	lhu	a4,32(s1)
    800058f8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800058fc:	04f70663          	beq	a4,a5,80005948 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005900:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005904:	6898                	ld	a4,16(s1)
    80005906:	0204d783          	lhu	a5,32(s1)
    8000590a:	8b9d                	andi	a5,a5,7
    8000590c:	078e                	slli	a5,a5,0x3
    8000590e:	97ba                	add	a5,a5,a4
    80005910:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005912:	00278713          	addi	a4,a5,2
    80005916:	0712                	slli	a4,a4,0x4
    80005918:	9726                	add	a4,a4,s1
    8000591a:	01074703          	lbu	a4,16(a4)
    8000591e:	e321                	bnez	a4,8000595e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005920:	0789                	addi	a5,a5,2
    80005922:	0792                	slli	a5,a5,0x4
    80005924:	97a6                	add	a5,a5,s1
    80005926:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005928:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000592c:	b48fc0ef          	jal	80001c74 <wakeup>

    disk.used_idx += 1;
    80005930:	0204d783          	lhu	a5,32(s1)
    80005934:	2785                	addiw	a5,a5,1
    80005936:	17c2                	slli	a5,a5,0x30
    80005938:	93c1                	srli	a5,a5,0x30
    8000593a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000593e:	6898                	ld	a4,16(s1)
    80005940:	00275703          	lhu	a4,2(a4)
    80005944:	faf71ee3          	bne	a4,a5,80005900 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005948:	00016517          	auipc	a0,0x16
    8000594c:	11050513          	addi	a0,a0,272 # 8001ba58 <disk+0x128>
    80005950:	b3efb0ef          	jal	80000c8e <release>
}
    80005954:	60e2                	ld	ra,24(sp)
    80005956:	6442                	ld	s0,16(sp)
    80005958:	64a2                	ld	s1,8(sp)
    8000595a:	6105                	addi	sp,sp,32
    8000595c:	8082                	ret
      panic("virtio_disk_intr status");
    8000595e:	00002517          	auipc	a0,0x2
    80005962:	e2a50513          	addi	a0,a0,-470 # 80007788 <etext+0x788>
    80005966:	e2ffa0ef          	jal	80000794 <panic>
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
    8000609e:	18051073          	csrw	satp,a0
    800060a2:	12000073          	sfence.vma
    800060a6:	0050051b          	addiw	a0,zero,5
    800060aa:	0576                	slli	a0,a0,0x1d
    800060ac:	02853083          	ld	ra,40(a0)
    800060b0:	03053103          	ld	sp,48(a0)
    800060b4:	03853183          	ld	gp,56(a0)
    800060b8:	04053203          	ld	tp,64(a0)
    800060bc:	04853283          	ld	t0,72(a0)
    800060c0:	05053303          	ld	t1,80(a0)
    800060c4:	05853383          	ld	t2,88(a0)
    800060c8:	7120                	ld	s0,96(a0)
    800060ca:	7524                	ld	s1,104(a0)
    800060cc:	7d2c                	ld	a1,120(a0)
    800060ce:	6150                	ld	a2,128(a0)
    800060d0:	6554                	ld	a3,136(a0)
    800060d2:	6958                	ld	a4,144(a0)
    800060d4:	6d5c                	ld	a5,152(a0)
    800060d6:	0a053803          	ld	a6,160(a0)
    800060da:	0a853883          	ld	a7,168(a0)
    800060de:	0b053903          	ld	s2,176(a0)
    800060e2:	0b853983          	ld	s3,184(a0)
    800060e6:	0c053a03          	ld	s4,192(a0)
    800060ea:	0c853a83          	ld	s5,200(a0)
    800060ee:	0d053b03          	ld	s6,208(a0)
    800060f2:	0d853b83          	ld	s7,216(a0)
    800060f6:	0e053c03          	ld	s8,224(a0)
    800060fa:	0e853c83          	ld	s9,232(a0)
    800060fe:	0f053d03          	ld	s10,240(a0)
    80006102:	0f853d83          	ld	s11,248(a0)
    80006106:	10053e03          	ld	t3,256(a0)
    8000610a:	10853e83          	ld	t4,264(a0)
    8000610e:	11053f03          	ld	t5,272(a0)
    80006112:	11853f83          	ld	t6,280(a0)
    80006116:	7928                	ld	a0,112(a0)
    80006118:	10200073          	sret
	...
