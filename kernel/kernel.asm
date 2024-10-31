
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
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd78f>
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
    800000fa:	17c020ef          	jal	80002276 <either_copyin>
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
    8000015c:	299000ef          	jal	80000bf4 <acquire>
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
    80000180:	76a010ef          	jal	800018ea <myproc>
    80000184:	785010ef          	jal	80002108 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	543010ef          	jal	80001ed0 <sleep>
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
    800001d2:	05a020ef          	jal	8000222c <either_copyout>
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
    80000282:	6c250513          	addi	a0,a0,1730 # 8000f940 <cons>
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
    800002a0:	020020ef          	jal	800022c0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002a4:	0000f517          	auipc	a0,0xf
    800002a8:	69c50513          	addi	a0,a0,1692 # 8000f940 <cons>
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
    800003e6:	337010ef          	jal	80001f1c <wakeup>
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
    80000404:	770000ef          	jal	80000b74 <initlock>

  uartinit();
    80000408:	3f4000ef          	jal	800007fc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000040c:	00020797          	auipc	a5,0x20
    80000410:	acc78793          	addi	a5,a5,-1332 # 8001fed8 <devsw>
    80000414:	00000717          	auipc	a4,0x0
    80000418:	d2270713          	addi	a4,a4,-734 # 80000136 <consoleread>
    8000041c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000041e:	00000717          	auipc	a4,0x0
    80000422:	cb270713          	addi	a4,a4,-846 # 800000d0 <consolewrite>
    80000426:	ef98                	sd	a4,24(a5)
}
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
    80000844:	1c850513          	addi	a0,a0,456 # 8000fa08 <uart_tx_lock>
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
    800008fe:	61e010ef          	jal	80001f1c <wakeup>
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
    80000954:	2a0000ef          	jal	80000bf4 <acquire>
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
    80000996:	53a010ef          	jal	80001ed0 <sleep>
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
    80000a24:	fe848493          	addi	s1,s1,-24 # 8000fa08 <uart_tx_lock>
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
    80000a5a:	61a78793          	addi	a5,a5,1562 # 80021070 <end>
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
    80000a76:	fce90913          	addi	s2,s2,-50 # 8000fa40 <kmem>
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
    80000b04:	f4050513          	addi	a0,a0,-192 # 8000fa40 <kmem>
    80000b08:	06c000ef          	jal	80000b74 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b0c:	45c5                	li	a1,17
    80000b0e:	05ee                	slli	a1,a1,0x1b
    80000b10:	00020517          	auipc	a0,0x20
    80000b14:	56050513          	addi	a0,a0,1376 # 80021070 <end>
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
    80000b32:	f1248493          	addi	s1,s1,-238 # 8000fa40 <kmem>
    80000b36:	8526                	mv	a0,s1
    80000b38:	0bc000ef          	jal	80000bf4 <acquire>
  r = kmem.freelist;
    80000b3c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3e:	c485                	beqz	s1,80000b66 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b40:	609c                	ld	a5,0(s1)
    80000b42:	0000f517          	auipc	a0,0xf
    80000b46:	efe50513          	addi	a0,a0,-258 # 8000fa40 <kmem>
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
    80000b6a:	eda50513          	addi	a0,a0,-294 # 8000fa40 <kmem>
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
    80000b9e:	531000ef          	jal	800018ce <mycpu>
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
    80000bcc:	503000ef          	jal	800018ce <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cb99                	beqz	a5,80000be8 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	4fb000ef          	jal	800018ce <mycpu>
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
    80000be8:	4e7000ef          	jal	800018ce <mycpu>
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
    80000c1c:	4b3000ef          	jal	800018ce <mycpu>
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
    80000c40:	48f000ef          	jal	800018ce <mycpu>
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
    80000d3c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffddf91>
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
    80000e6a:	255000ef          	jal	800018be <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e6e:	00007717          	auipc	a4,0x7
    80000e72:	aaa70713          	addi	a4,a4,-1366 # 80007918 <started>
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
    80000e82:	23d000ef          	jal	800018be <cpuid>
    80000e86:	85aa                	mv	a1,a0
    80000e88:	00006517          	auipc	a0,0x6
    80000e8c:	21050513          	addi	a0,a0,528 # 80007098 <etext+0x98>
    80000e90:	e32ff0ef          	jal	800004c2 <printf>
    kvminithart();    // turn on paging
    80000e94:	080000ef          	jal	80000f14 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e98:	55a010ef          	jal	800023f2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e9c:	3dc040ef          	jal	80005278 <plicinithart>
  }

  scheduler();        
    80000ea0:	67f000ef          	jal	80001d1e <scheduler>
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
    80000ed4:	2ca000ef          	jal	8000119e <kvminit>
    kvminithart();   // turn on paging
    80000ed8:	03c000ef          	jal	80000f14 <kvminithart>
    procinit();      // process table
    80000edc:	123000ef          	jal	800017fe <procinit>
    trapinit();      // trap vectors
    80000ee0:	4ee010ef          	jal	800023ce <trapinit>
    trapinithart();  // install kernel trap vector
    80000ee4:	50e010ef          	jal	800023f2 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ee8:	376040ef          	jal	8000525e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000eec:	38c040ef          	jal	80005278 <plicinithart>
    binit();         // buffer cache
    80000ef0:	335010ef          	jal	80002a24 <binit>
    iinit();         // inode table
    80000ef4:	126020ef          	jal	8000301a <iinit>
    fileinit();      // file table
    80000ef8:	6d3020ef          	jal	80003dca <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efc:	46c040ef          	jal	80005368 <virtio_disk_init>
    userinit();      // first user process
    80000f00:	453000ef          	jal	80001b52 <userinit>
    __sync_synchronize();
    80000f04:	0ff0000f          	fence
    started = 1;
    80000f08:	4785                	li	a5,1
    80000f0a:	00007717          	auipc	a4,0x7
    80000f0e:	a0f72723          	sw	a5,-1522(a4) # 80007918 <started>
    80000f12:	b779                	j	80000ea0 <main+0x3e>

0000000080000f14 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f14:	1141                	addi	sp,sp,-16
    80000f16:	e422                	sd	s0,8(sp)
    80000f18:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f1a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f1e:	00007797          	auipc	a5,0x7
    80000f22:	a027b783          	ld	a5,-1534(a5) # 80007920 <kernel_pagetable>
    80000f26:	83b1                	srli	a5,a5,0xc
    80000f28:	577d                	li	a4,-1
    80000f2a:	177e                	slli	a4,a4,0x3f
    80000f2c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f2e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f32:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f36:	6422                	ld	s0,8(sp)
    80000f38:	0141                	addi	sp,sp,16
    80000f3a:	8082                	ret

0000000080000f3c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f3c:	7139                	addi	sp,sp,-64
    80000f3e:	fc06                	sd	ra,56(sp)
    80000f40:	f822                	sd	s0,48(sp)
    80000f42:	f426                	sd	s1,40(sp)
    80000f44:	f04a                	sd	s2,32(sp)
    80000f46:	ec4e                	sd	s3,24(sp)
    80000f48:	e852                	sd	s4,16(sp)
    80000f4a:	e456                	sd	s5,8(sp)
    80000f4c:	e05a                	sd	s6,0(sp)
    80000f4e:	0080                	addi	s0,sp,64
    80000f50:	84aa                	mv	s1,a0
    80000f52:	89ae                	mv	s3,a1
    80000f54:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f56:	57fd                	li	a5,-1
    80000f58:	83e9                	srli	a5,a5,0x1a
    80000f5a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f5c:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f5e:	02b7fc63          	bgeu	a5,a1,80000f96 <walk+0x5a>
    panic("walk");
    80000f62:	00006517          	auipc	a0,0x6
    80000f66:	14e50513          	addi	a0,a0,334 # 800070b0 <etext+0xb0>
    80000f6a:	82bff0ef          	jal	80000794 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f6e:	060a8263          	beqz	s5,80000fd2 <walk+0x96>
    80000f72:	bb3ff0ef          	jal	80000b24 <kalloc>
    80000f76:	84aa                	mv	s1,a0
    80000f78:	c139                	beqz	a0,80000fbe <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f7a:	6605                	lui	a2,0x1
    80000f7c:	4581                	li	a1,0
    80000f7e:	d4bff0ef          	jal	80000cc8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f82:	00c4d793          	srli	a5,s1,0xc
    80000f86:	07aa                	slli	a5,a5,0xa
    80000f88:	0017e793          	ori	a5,a5,1
    80000f8c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f90:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffddf87>
    80000f92:	036a0063          	beq	s4,s6,80000fb2 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f96:	0149d933          	srl	s2,s3,s4
    80000f9a:	1ff97913          	andi	s2,s2,511
    80000f9e:	090e                	slli	s2,s2,0x3
    80000fa0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fa2:	00093483          	ld	s1,0(s2)
    80000fa6:	0014f793          	andi	a5,s1,1
    80000faa:	d3f1                	beqz	a5,80000f6e <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fac:	80a9                	srli	s1,s1,0xa
    80000fae:	04b2                	slli	s1,s1,0xc
    80000fb0:	b7c5                	j	80000f90 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000fb2:	00c9d513          	srli	a0,s3,0xc
    80000fb6:	1ff57513          	andi	a0,a0,511
    80000fba:	050e                	slli	a0,a0,0x3
    80000fbc:	9526                	add	a0,a0,s1
}
    80000fbe:	70e2                	ld	ra,56(sp)
    80000fc0:	7442                	ld	s0,48(sp)
    80000fc2:	74a2                	ld	s1,40(sp)
    80000fc4:	7902                	ld	s2,32(sp)
    80000fc6:	69e2                	ld	s3,24(sp)
    80000fc8:	6a42                	ld	s4,16(sp)
    80000fca:	6aa2                	ld	s5,8(sp)
    80000fcc:	6b02                	ld	s6,0(sp)
    80000fce:	6121                	addi	sp,sp,64
    80000fd0:	8082                	ret
        return 0;
    80000fd2:	4501                	li	a0,0
    80000fd4:	b7ed                	j	80000fbe <walk+0x82>

0000000080000fd6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fd6:	57fd                	li	a5,-1
    80000fd8:	83e9                	srli	a5,a5,0x1a
    80000fda:	00b7f463          	bgeu	a5,a1,80000fe2 <walkaddr+0xc>
    return 0;
    80000fde:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fe0:	8082                	ret
{
    80000fe2:	1141                	addi	sp,sp,-16
    80000fe4:	e406                	sd	ra,8(sp)
    80000fe6:	e022                	sd	s0,0(sp)
    80000fe8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fea:	4601                	li	a2,0
    80000fec:	f51ff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    80000ff0:	c105                	beqz	a0,80001010 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000ff2:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000ff4:	0117f693          	andi	a3,a5,17
    80000ff8:	4745                	li	a4,17
    return 0;
    80000ffa:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000ffc:	00e68663          	beq	a3,a4,80001008 <walkaddr+0x32>
}
    80001000:	60a2                	ld	ra,8(sp)
    80001002:	6402                	ld	s0,0(sp)
    80001004:	0141                	addi	sp,sp,16
    80001006:	8082                	ret
  pa = PTE2PA(*pte);
    80001008:	83a9                	srli	a5,a5,0xa
    8000100a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000100e:	bfcd                	j	80001000 <walkaddr+0x2a>
    return 0;
    80001010:	4501                	li	a0,0
    80001012:	b7fd                	j	80001000 <walkaddr+0x2a>

0000000080001014 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001014:	715d                	addi	sp,sp,-80
    80001016:	e486                	sd	ra,72(sp)
    80001018:	e0a2                	sd	s0,64(sp)
    8000101a:	fc26                	sd	s1,56(sp)
    8000101c:	f84a                	sd	s2,48(sp)
    8000101e:	f44e                	sd	s3,40(sp)
    80001020:	f052                	sd	s4,32(sp)
    80001022:	ec56                	sd	s5,24(sp)
    80001024:	e85a                	sd	s6,16(sp)
    80001026:	e45e                	sd	s7,8(sp)
    80001028:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000102a:	03459793          	slli	a5,a1,0x34
    8000102e:	e7a9                	bnez	a5,80001078 <mappages+0x64>
    80001030:	8aaa                	mv	s5,a0
    80001032:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001034:	03461793          	slli	a5,a2,0x34
    80001038:	e7b1                	bnez	a5,80001084 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    8000103a:	ca39                	beqz	a2,80001090 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000103c:	77fd                	lui	a5,0xfffff
    8000103e:	963e                	add	a2,a2,a5
    80001040:	00b609b3          	add	s3,a2,a1
  a = va;
    80001044:	892e                	mv	s2,a1
    80001046:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000104a:	6b85                	lui	s7,0x1
    8000104c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001050:	4605                	li	a2,1
    80001052:	85ca                	mv	a1,s2
    80001054:	8556                	mv	a0,s5
    80001056:	ee7ff0ef          	jal	80000f3c <walk>
    8000105a:	c539                	beqz	a0,800010a8 <mappages+0x94>
    if(*pte & PTE_V)
    8000105c:	611c                	ld	a5,0(a0)
    8000105e:	8b85                	andi	a5,a5,1
    80001060:	ef95                	bnez	a5,8000109c <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001062:	80b1                	srli	s1,s1,0xc
    80001064:	04aa                	slli	s1,s1,0xa
    80001066:	0164e4b3          	or	s1,s1,s6
    8000106a:	0014e493          	ori	s1,s1,1
    8000106e:	e104                	sd	s1,0(a0)
    if(a == last)
    80001070:	05390863          	beq	s2,s3,800010c0 <mappages+0xac>
    a += PGSIZE;
    80001074:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001076:	bfd9                	j	8000104c <mappages+0x38>
    panic("mappages: va not aligned");
    80001078:	00006517          	auipc	a0,0x6
    8000107c:	04050513          	addi	a0,a0,64 # 800070b8 <etext+0xb8>
    80001080:	f14ff0ef          	jal	80000794 <panic>
    panic("mappages: size not aligned");
    80001084:	00006517          	auipc	a0,0x6
    80001088:	05450513          	addi	a0,a0,84 # 800070d8 <etext+0xd8>
    8000108c:	f08ff0ef          	jal	80000794 <panic>
    panic("mappages: size");
    80001090:	00006517          	auipc	a0,0x6
    80001094:	06850513          	addi	a0,a0,104 # 800070f8 <etext+0xf8>
    80001098:	efcff0ef          	jal	80000794 <panic>
      panic("mappages: remap");
    8000109c:	00006517          	auipc	a0,0x6
    800010a0:	06c50513          	addi	a0,a0,108 # 80007108 <etext+0x108>
    800010a4:	ef0ff0ef          	jal	80000794 <panic>
      return -1;
    800010a8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010aa:	60a6                	ld	ra,72(sp)
    800010ac:	6406                	ld	s0,64(sp)
    800010ae:	74e2                	ld	s1,56(sp)
    800010b0:	7942                	ld	s2,48(sp)
    800010b2:	79a2                	ld	s3,40(sp)
    800010b4:	7a02                	ld	s4,32(sp)
    800010b6:	6ae2                	ld	s5,24(sp)
    800010b8:	6b42                	ld	s6,16(sp)
    800010ba:	6ba2                	ld	s7,8(sp)
    800010bc:	6161                	addi	sp,sp,80
    800010be:	8082                	ret
  return 0;
    800010c0:	4501                	li	a0,0
    800010c2:	b7e5                	j	800010aa <mappages+0x96>

00000000800010c4 <kvmmap>:
{
    800010c4:	1141                	addi	sp,sp,-16
    800010c6:	e406                	sd	ra,8(sp)
    800010c8:	e022                	sd	s0,0(sp)
    800010ca:	0800                	addi	s0,sp,16
    800010cc:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010ce:	86b2                	mv	a3,a2
    800010d0:	863e                	mv	a2,a5
    800010d2:	f43ff0ef          	jal	80001014 <mappages>
    800010d6:	e509                	bnez	a0,800010e0 <kvmmap+0x1c>
}
    800010d8:	60a2                	ld	ra,8(sp)
    800010da:	6402                	ld	s0,0(sp)
    800010dc:	0141                	addi	sp,sp,16
    800010de:	8082                	ret
    panic("kvmmap");
    800010e0:	00006517          	auipc	a0,0x6
    800010e4:	03850513          	addi	a0,a0,56 # 80007118 <etext+0x118>
    800010e8:	eacff0ef          	jal	80000794 <panic>

00000000800010ec <kvmmake>:
{
    800010ec:	1101                	addi	sp,sp,-32
    800010ee:	ec06                	sd	ra,24(sp)
    800010f0:	e822                	sd	s0,16(sp)
    800010f2:	e426                	sd	s1,8(sp)
    800010f4:	e04a                	sd	s2,0(sp)
    800010f6:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010f8:	a2dff0ef          	jal	80000b24 <kalloc>
    800010fc:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010fe:	6605                	lui	a2,0x1
    80001100:	4581                	li	a1,0
    80001102:	bc7ff0ef          	jal	80000cc8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001106:	4719                	li	a4,6
    80001108:	6685                	lui	a3,0x1
    8000110a:	10000637          	lui	a2,0x10000
    8000110e:	100005b7          	lui	a1,0x10000
    80001112:	8526                	mv	a0,s1
    80001114:	fb1ff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001118:	4719                	li	a4,6
    8000111a:	6685                	lui	a3,0x1
    8000111c:	10001637          	lui	a2,0x10001
    80001120:	100015b7          	lui	a1,0x10001
    80001124:	8526                	mv	a0,s1
    80001126:	f9fff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000112a:	4719                	li	a4,6
    8000112c:	040006b7          	lui	a3,0x4000
    80001130:	0c000637          	lui	a2,0xc000
    80001134:	0c0005b7          	lui	a1,0xc000
    80001138:	8526                	mv	a0,s1
    8000113a:	f8bff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000113e:	00006917          	auipc	s2,0x6
    80001142:	ec290913          	addi	s2,s2,-318 # 80007000 <etext>
    80001146:	4729                	li	a4,10
    80001148:	80006697          	auipc	a3,0x80006
    8000114c:	eb868693          	addi	a3,a3,-328 # 7000 <_entry-0x7fff9000>
    80001150:	4605                	li	a2,1
    80001152:	067e                	slli	a2,a2,0x1f
    80001154:	85b2                	mv	a1,a2
    80001156:	8526                	mv	a0,s1
    80001158:	f6dff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000115c:	46c5                	li	a3,17
    8000115e:	06ee                	slli	a3,a3,0x1b
    80001160:	4719                	li	a4,6
    80001162:	412686b3          	sub	a3,a3,s2
    80001166:	864a                	mv	a2,s2
    80001168:	85ca                	mv	a1,s2
    8000116a:	8526                	mv	a0,s1
    8000116c:	f59ff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001170:	4729                	li	a4,10
    80001172:	6685                	lui	a3,0x1
    80001174:	00005617          	auipc	a2,0x5
    80001178:	e8c60613          	addi	a2,a2,-372 # 80006000 <_trampoline>
    8000117c:	040005b7          	lui	a1,0x4000
    80001180:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001182:	05b2                	slli	a1,a1,0xc
    80001184:	8526                	mv	a0,s1
    80001186:	f3fff0ef          	jal	800010c4 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000118a:	8526                	mv	a0,s1
    8000118c:	5da000ef          	jal	80001766 <proc_mapstacks>
}
    80001190:	8526                	mv	a0,s1
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	64a2                	ld	s1,8(sp)
    80001198:	6902                	ld	s2,0(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret

000000008000119e <kvminit>:
{
    8000119e:	1141                	addi	sp,sp,-16
    800011a0:	e406                	sd	ra,8(sp)
    800011a2:	e022                	sd	s0,0(sp)
    800011a4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011a6:	f47ff0ef          	jal	800010ec <kvmmake>
    800011aa:	00006797          	auipc	a5,0x6
    800011ae:	76a7bb23          	sd	a0,1910(a5) # 80007920 <kernel_pagetable>
}
    800011b2:	60a2                	ld	ra,8(sp)
    800011b4:	6402                	ld	s0,0(sp)
    800011b6:	0141                	addi	sp,sp,16
    800011b8:	8082                	ret

00000000800011ba <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011ba:	715d                	addi	sp,sp,-80
    800011bc:	e486                	sd	ra,72(sp)
    800011be:	e0a2                	sd	s0,64(sp)
    800011c0:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011c2:	03459793          	slli	a5,a1,0x34
    800011c6:	e39d                	bnez	a5,800011ec <uvmunmap+0x32>
    800011c8:	f84a                	sd	s2,48(sp)
    800011ca:	f44e                	sd	s3,40(sp)
    800011cc:	f052                	sd	s4,32(sp)
    800011ce:	ec56                	sd	s5,24(sp)
    800011d0:	e85a                	sd	s6,16(sp)
    800011d2:	e45e                	sd	s7,8(sp)
    800011d4:	8a2a                	mv	s4,a0
    800011d6:	892e                	mv	s2,a1
    800011d8:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011da:	0632                	slli	a2,a2,0xc
    800011dc:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800011e0:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011e2:	6b05                	lui	s6,0x1
    800011e4:	0735ff63          	bgeu	a1,s3,80001262 <uvmunmap+0xa8>
    800011e8:	fc26                	sd	s1,56(sp)
    800011ea:	a0a9                	j	80001234 <uvmunmap+0x7a>
    800011ec:	fc26                	sd	s1,56(sp)
    800011ee:	f84a                	sd	s2,48(sp)
    800011f0:	f44e                	sd	s3,40(sp)
    800011f2:	f052                	sd	s4,32(sp)
    800011f4:	ec56                	sd	s5,24(sp)
    800011f6:	e85a                	sd	s6,16(sp)
    800011f8:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800011fa:	00006517          	auipc	a0,0x6
    800011fe:	f2650513          	addi	a0,a0,-218 # 80007120 <etext+0x120>
    80001202:	d92ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: walk");
    80001206:	00006517          	auipc	a0,0x6
    8000120a:	f3250513          	addi	a0,a0,-206 # 80007138 <etext+0x138>
    8000120e:	d86ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not mapped");
    80001212:	00006517          	auipc	a0,0x6
    80001216:	f3650513          	addi	a0,a0,-202 # 80007148 <etext+0x148>
    8000121a:	d7aff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not a leaf");
    8000121e:	00006517          	auipc	a0,0x6
    80001222:	f4250513          	addi	a0,a0,-190 # 80007160 <etext+0x160>
    80001226:	d6eff0ef          	jal	80000794 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000122a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000122e:	995a                	add	s2,s2,s6
    80001230:	03397863          	bgeu	s2,s3,80001260 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001234:	4601                	li	a2,0
    80001236:	85ca                	mv	a1,s2
    80001238:	8552                	mv	a0,s4
    8000123a:	d03ff0ef          	jal	80000f3c <walk>
    8000123e:	84aa                	mv	s1,a0
    80001240:	d179                	beqz	a0,80001206 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001242:	6108                	ld	a0,0(a0)
    80001244:	00157793          	andi	a5,a0,1
    80001248:	d7e9                	beqz	a5,80001212 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000124a:	3ff57793          	andi	a5,a0,1023
    8000124e:	fd7788e3          	beq	a5,s7,8000121e <uvmunmap+0x64>
    if(do_free){
    80001252:	fc0a8ce3          	beqz	s5,8000122a <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001256:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001258:	0532                	slli	a0,a0,0xc
    8000125a:	fe8ff0ef          	jal	80000a42 <kfree>
    8000125e:	b7f1                	j	8000122a <uvmunmap+0x70>
    80001260:	74e2                	ld	s1,56(sp)
    80001262:	7942                	ld	s2,48(sp)
    80001264:	79a2                	ld	s3,40(sp)
    80001266:	7a02                	ld	s4,32(sp)
    80001268:	6ae2                	ld	s5,24(sp)
    8000126a:	6b42                	ld	s6,16(sp)
    8000126c:	6ba2                	ld	s7,8(sp)
  }
}
    8000126e:	60a6                	ld	ra,72(sp)
    80001270:	6406                	ld	s0,64(sp)
    80001272:	6161                	addi	sp,sp,80
    80001274:	8082                	ret

0000000080001276 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001276:	1101                	addi	sp,sp,-32
    80001278:	ec06                	sd	ra,24(sp)
    8000127a:	e822                	sd	s0,16(sp)
    8000127c:	e426                	sd	s1,8(sp)
    8000127e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001280:	8a5ff0ef          	jal	80000b24 <kalloc>
    80001284:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001286:	c509                	beqz	a0,80001290 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001288:	6605                	lui	a2,0x1
    8000128a:	4581                	li	a1,0
    8000128c:	a3dff0ef          	jal	80000cc8 <memset>
  return pagetable;
}
    80001290:	8526                	mv	a0,s1
    80001292:	60e2                	ld	ra,24(sp)
    80001294:	6442                	ld	s0,16(sp)
    80001296:	64a2                	ld	s1,8(sp)
    80001298:	6105                	addi	sp,sp,32
    8000129a:	8082                	ret

000000008000129c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000129c:	7179                	addi	sp,sp,-48
    8000129e:	f406                	sd	ra,40(sp)
    800012a0:	f022                	sd	s0,32(sp)
    800012a2:	ec26                	sd	s1,24(sp)
    800012a4:	e84a                	sd	s2,16(sp)
    800012a6:	e44e                	sd	s3,8(sp)
    800012a8:	e052                	sd	s4,0(sp)
    800012aa:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012ac:	6785                	lui	a5,0x1
    800012ae:	04f67063          	bgeu	a2,a5,800012ee <uvmfirst+0x52>
    800012b2:	8a2a                	mv	s4,a0
    800012b4:	89ae                	mv	s3,a1
    800012b6:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012b8:	86dff0ef          	jal	80000b24 <kalloc>
    800012bc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012be:	6605                	lui	a2,0x1
    800012c0:	4581                	li	a1,0
    800012c2:	a07ff0ef          	jal	80000cc8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012c6:	4779                	li	a4,30
    800012c8:	86ca                	mv	a3,s2
    800012ca:	6605                	lui	a2,0x1
    800012cc:	4581                	li	a1,0
    800012ce:	8552                	mv	a0,s4
    800012d0:	d45ff0ef          	jal	80001014 <mappages>
  memmove(mem, src, sz);
    800012d4:	8626                	mv	a2,s1
    800012d6:	85ce                	mv	a1,s3
    800012d8:	854a                	mv	a0,s2
    800012da:	a4bff0ef          	jal	80000d24 <memmove>
}
    800012de:	70a2                	ld	ra,40(sp)
    800012e0:	7402                	ld	s0,32(sp)
    800012e2:	64e2                	ld	s1,24(sp)
    800012e4:	6942                	ld	s2,16(sp)
    800012e6:	69a2                	ld	s3,8(sp)
    800012e8:	6a02                	ld	s4,0(sp)
    800012ea:	6145                	addi	sp,sp,48
    800012ec:	8082                	ret
    panic("uvmfirst: more than a page");
    800012ee:	00006517          	auipc	a0,0x6
    800012f2:	e8a50513          	addi	a0,a0,-374 # 80007178 <etext+0x178>
    800012f6:	c9eff0ef          	jal	80000794 <panic>

00000000800012fa <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800012fa:	1101                	addi	sp,sp,-32
    800012fc:	ec06                	sd	ra,24(sp)
    800012fe:	e822                	sd	s0,16(sp)
    80001300:	e426                	sd	s1,8(sp)
    80001302:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001304:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001306:	00b67d63          	bgeu	a2,a1,80001320 <uvmdealloc+0x26>
    8000130a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000130c:	6785                	lui	a5,0x1
    8000130e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001310:	00f60733          	add	a4,a2,a5
    80001314:	76fd                	lui	a3,0xfffff
    80001316:	8f75                	and	a4,a4,a3
    80001318:	97ae                	add	a5,a5,a1
    8000131a:	8ff5                	and	a5,a5,a3
    8000131c:	00f76863          	bltu	a4,a5,8000132c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001320:	8526                	mv	a0,s1
    80001322:	60e2                	ld	ra,24(sp)
    80001324:	6442                	ld	s0,16(sp)
    80001326:	64a2                	ld	s1,8(sp)
    80001328:	6105                	addi	sp,sp,32
    8000132a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000132c:	8f99                	sub	a5,a5,a4
    8000132e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001330:	4685                	li	a3,1
    80001332:	0007861b          	sext.w	a2,a5
    80001336:	85ba                	mv	a1,a4
    80001338:	e83ff0ef          	jal	800011ba <uvmunmap>
    8000133c:	b7d5                	j	80001320 <uvmdealloc+0x26>

000000008000133e <uvmalloc>:
  if(newsz < oldsz)
    8000133e:	08b66f63          	bltu	a2,a1,800013dc <uvmalloc+0x9e>
{
    80001342:	7139                	addi	sp,sp,-64
    80001344:	fc06                	sd	ra,56(sp)
    80001346:	f822                	sd	s0,48(sp)
    80001348:	ec4e                	sd	s3,24(sp)
    8000134a:	e852                	sd	s4,16(sp)
    8000134c:	e456                	sd	s5,8(sp)
    8000134e:	0080                	addi	s0,sp,64
    80001350:	8aaa                	mv	s5,a0
    80001352:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001354:	6785                	lui	a5,0x1
    80001356:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001358:	95be                	add	a1,a1,a5
    8000135a:	77fd                	lui	a5,0xfffff
    8000135c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001360:	08c9f063          	bgeu	s3,a2,800013e0 <uvmalloc+0xa2>
    80001364:	f426                	sd	s1,40(sp)
    80001366:	f04a                	sd	s2,32(sp)
    80001368:	e05a                	sd	s6,0(sp)
    8000136a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000136c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001370:	fb4ff0ef          	jal	80000b24 <kalloc>
    80001374:	84aa                	mv	s1,a0
    if(mem == 0){
    80001376:	c515                	beqz	a0,800013a2 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001378:	6605                	lui	a2,0x1
    8000137a:	4581                	li	a1,0
    8000137c:	94dff0ef          	jal	80000cc8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001380:	875a                	mv	a4,s6
    80001382:	86a6                	mv	a3,s1
    80001384:	6605                	lui	a2,0x1
    80001386:	85ca                	mv	a1,s2
    80001388:	8556                	mv	a0,s5
    8000138a:	c8bff0ef          	jal	80001014 <mappages>
    8000138e:	e915                	bnez	a0,800013c2 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001390:	6785                	lui	a5,0x1
    80001392:	993e                	add	s2,s2,a5
    80001394:	fd496ee3          	bltu	s2,s4,80001370 <uvmalloc+0x32>
  return newsz;
    80001398:	8552                	mv	a0,s4
    8000139a:	74a2                	ld	s1,40(sp)
    8000139c:	7902                	ld	s2,32(sp)
    8000139e:	6b02                	ld	s6,0(sp)
    800013a0:	a811                	j	800013b4 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800013a2:	864e                	mv	a2,s3
    800013a4:	85ca                	mv	a1,s2
    800013a6:	8556                	mv	a0,s5
    800013a8:	f53ff0ef          	jal	800012fa <uvmdealloc>
      return 0;
    800013ac:	4501                	li	a0,0
    800013ae:	74a2                	ld	s1,40(sp)
    800013b0:	7902                	ld	s2,32(sp)
    800013b2:	6b02                	ld	s6,0(sp)
}
    800013b4:	70e2                	ld	ra,56(sp)
    800013b6:	7442                	ld	s0,48(sp)
    800013b8:	69e2                	ld	s3,24(sp)
    800013ba:	6a42                	ld	s4,16(sp)
    800013bc:	6aa2                	ld	s5,8(sp)
    800013be:	6121                	addi	sp,sp,64
    800013c0:	8082                	ret
      kfree(mem);
    800013c2:	8526                	mv	a0,s1
    800013c4:	e7eff0ef          	jal	80000a42 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013c8:	864e                	mv	a2,s3
    800013ca:	85ca                	mv	a1,s2
    800013cc:	8556                	mv	a0,s5
    800013ce:	f2dff0ef          	jal	800012fa <uvmdealloc>
      return 0;
    800013d2:	4501                	li	a0,0
    800013d4:	74a2                	ld	s1,40(sp)
    800013d6:	7902                	ld	s2,32(sp)
    800013d8:	6b02                	ld	s6,0(sp)
    800013da:	bfe9                	j	800013b4 <uvmalloc+0x76>
    return oldsz;
    800013dc:	852e                	mv	a0,a1
}
    800013de:	8082                	ret
  return newsz;
    800013e0:	8532                	mv	a0,a2
    800013e2:	bfc9                	j	800013b4 <uvmalloc+0x76>

00000000800013e4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800013e4:	7179                	addi	sp,sp,-48
    800013e6:	f406                	sd	ra,40(sp)
    800013e8:	f022                	sd	s0,32(sp)
    800013ea:	ec26                	sd	s1,24(sp)
    800013ec:	e84a                	sd	s2,16(sp)
    800013ee:	e44e                	sd	s3,8(sp)
    800013f0:	e052                	sd	s4,0(sp)
    800013f2:	1800                	addi	s0,sp,48
    800013f4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800013f6:	84aa                	mv	s1,a0
    800013f8:	6905                	lui	s2,0x1
    800013fa:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013fc:	4985                	li	s3,1
    800013fe:	a819                	j	80001414 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001400:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001402:	00c79513          	slli	a0,a5,0xc
    80001406:	fdfff0ef          	jal	800013e4 <freewalk>
      pagetable[i] = 0;
    8000140a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000140e:	04a1                	addi	s1,s1,8
    80001410:	01248f63          	beq	s1,s2,8000142e <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001414:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001416:	00f7f713          	andi	a4,a5,15
    8000141a:	ff3703e3          	beq	a4,s3,80001400 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000141e:	8b85                	andi	a5,a5,1
    80001420:	d7fd                	beqz	a5,8000140e <freewalk+0x2a>
      panic("freewalk: leaf");
    80001422:	00006517          	auipc	a0,0x6
    80001426:	d7650513          	addi	a0,a0,-650 # 80007198 <etext+0x198>
    8000142a:	b6aff0ef          	jal	80000794 <panic>
    }
  }
  kfree((void*)pagetable);
    8000142e:	8552                	mv	a0,s4
    80001430:	e12ff0ef          	jal	80000a42 <kfree>
}
    80001434:	70a2                	ld	ra,40(sp)
    80001436:	7402                	ld	s0,32(sp)
    80001438:	64e2                	ld	s1,24(sp)
    8000143a:	6942                	ld	s2,16(sp)
    8000143c:	69a2                	ld	s3,8(sp)
    8000143e:	6a02                	ld	s4,0(sp)
    80001440:	6145                	addi	sp,sp,48
    80001442:	8082                	ret

0000000080001444 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001444:	1101                	addi	sp,sp,-32
    80001446:	ec06                	sd	ra,24(sp)
    80001448:	e822                	sd	s0,16(sp)
    8000144a:	e426                	sd	s1,8(sp)
    8000144c:	1000                	addi	s0,sp,32
    8000144e:	84aa                	mv	s1,a0
  if(sz > 0)
    80001450:	e989                	bnez	a1,80001462 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001452:	8526                	mv	a0,s1
    80001454:	f91ff0ef          	jal	800013e4 <freewalk>
}
    80001458:	60e2                	ld	ra,24(sp)
    8000145a:	6442                	ld	s0,16(sp)
    8000145c:	64a2                	ld	s1,8(sp)
    8000145e:	6105                	addi	sp,sp,32
    80001460:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001462:	6785                	lui	a5,0x1
    80001464:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001466:	95be                	add	a1,a1,a5
    80001468:	4685                	li	a3,1
    8000146a:	00c5d613          	srli	a2,a1,0xc
    8000146e:	4581                	li	a1,0
    80001470:	d4bff0ef          	jal	800011ba <uvmunmap>
    80001474:	bff9                	j	80001452 <uvmfree+0xe>

0000000080001476 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001476:	c65d                	beqz	a2,80001524 <uvmcopy+0xae>
{
    80001478:	715d                	addi	sp,sp,-80
    8000147a:	e486                	sd	ra,72(sp)
    8000147c:	e0a2                	sd	s0,64(sp)
    8000147e:	fc26                	sd	s1,56(sp)
    80001480:	f84a                	sd	s2,48(sp)
    80001482:	f44e                	sd	s3,40(sp)
    80001484:	f052                	sd	s4,32(sp)
    80001486:	ec56                	sd	s5,24(sp)
    80001488:	e85a                	sd	s6,16(sp)
    8000148a:	e45e                	sd	s7,8(sp)
    8000148c:	0880                	addi	s0,sp,80
    8000148e:	8b2a                	mv	s6,a0
    80001490:	8aae                	mv	s5,a1
    80001492:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001494:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001496:	4601                	li	a2,0
    80001498:	85ce                	mv	a1,s3
    8000149a:	855a                	mv	a0,s6
    8000149c:	aa1ff0ef          	jal	80000f3c <walk>
    800014a0:	c121                	beqz	a0,800014e0 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800014a2:	6118                	ld	a4,0(a0)
    800014a4:	00177793          	andi	a5,a4,1
    800014a8:	c3b1                	beqz	a5,800014ec <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800014aa:	00a75593          	srli	a1,a4,0xa
    800014ae:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014b2:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014b6:	e6eff0ef          	jal	80000b24 <kalloc>
    800014ba:	892a                	mv	s2,a0
    800014bc:	c129                	beqz	a0,800014fe <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014be:	6605                	lui	a2,0x1
    800014c0:	85de                	mv	a1,s7
    800014c2:	863ff0ef          	jal	80000d24 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014c6:	8726                	mv	a4,s1
    800014c8:	86ca                	mv	a3,s2
    800014ca:	6605                	lui	a2,0x1
    800014cc:	85ce                	mv	a1,s3
    800014ce:	8556                	mv	a0,s5
    800014d0:	b45ff0ef          	jal	80001014 <mappages>
    800014d4:	e115                	bnez	a0,800014f8 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    800014d6:	6785                	lui	a5,0x1
    800014d8:	99be                	add	s3,s3,a5
    800014da:	fb49eee3          	bltu	s3,s4,80001496 <uvmcopy+0x20>
    800014de:	a805                	j	8000150e <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    800014e0:	00006517          	auipc	a0,0x6
    800014e4:	cc850513          	addi	a0,a0,-824 # 800071a8 <etext+0x1a8>
    800014e8:	aacff0ef          	jal	80000794 <panic>
      panic("uvmcopy: page not present");
    800014ec:	00006517          	auipc	a0,0x6
    800014f0:	cdc50513          	addi	a0,a0,-804 # 800071c8 <etext+0x1c8>
    800014f4:	aa0ff0ef          	jal	80000794 <panic>
      kfree(mem);
    800014f8:	854a                	mv	a0,s2
    800014fa:	d48ff0ef          	jal	80000a42 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800014fe:	4685                	li	a3,1
    80001500:	00c9d613          	srli	a2,s3,0xc
    80001504:	4581                	li	a1,0
    80001506:	8556                	mv	a0,s5
    80001508:	cb3ff0ef          	jal	800011ba <uvmunmap>
  return -1;
    8000150c:	557d                	li	a0,-1
}
    8000150e:	60a6                	ld	ra,72(sp)
    80001510:	6406                	ld	s0,64(sp)
    80001512:	74e2                	ld	s1,56(sp)
    80001514:	7942                	ld	s2,48(sp)
    80001516:	79a2                	ld	s3,40(sp)
    80001518:	7a02                	ld	s4,32(sp)
    8000151a:	6ae2                	ld	s5,24(sp)
    8000151c:	6b42                	ld	s6,16(sp)
    8000151e:	6ba2                	ld	s7,8(sp)
    80001520:	6161                	addi	sp,sp,80
    80001522:	8082                	ret
  return 0;
    80001524:	4501                	li	a0,0
}
    80001526:	8082                	ret

0000000080001528 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001528:	1141                	addi	sp,sp,-16
    8000152a:	e406                	sd	ra,8(sp)
    8000152c:	e022                	sd	s0,0(sp)
    8000152e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001530:	4601                	li	a2,0
    80001532:	a0bff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    80001536:	c901                	beqz	a0,80001546 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001538:	611c                	ld	a5,0(a0)
    8000153a:	9bbd                	andi	a5,a5,-17
    8000153c:	e11c                	sd	a5,0(a0)
}
    8000153e:	60a2                	ld	ra,8(sp)
    80001540:	6402                	ld	s0,0(sp)
    80001542:	0141                	addi	sp,sp,16
    80001544:	8082                	ret
    panic("uvmclear");
    80001546:	00006517          	auipc	a0,0x6
    8000154a:	ca250513          	addi	a0,a0,-862 # 800071e8 <etext+0x1e8>
    8000154e:	a46ff0ef          	jal	80000794 <panic>

0000000080001552 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001552:	cad1                	beqz	a3,800015e6 <copyout+0x94>
{
    80001554:	711d                	addi	sp,sp,-96
    80001556:	ec86                	sd	ra,88(sp)
    80001558:	e8a2                	sd	s0,80(sp)
    8000155a:	e4a6                	sd	s1,72(sp)
    8000155c:	fc4e                	sd	s3,56(sp)
    8000155e:	f456                	sd	s5,40(sp)
    80001560:	f05a                	sd	s6,32(sp)
    80001562:	ec5e                	sd	s7,24(sp)
    80001564:	1080                	addi	s0,sp,96
    80001566:	8baa                	mv	s7,a0
    80001568:	8aae                	mv	s5,a1
    8000156a:	8b32                	mv	s6,a2
    8000156c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000156e:	74fd                	lui	s1,0xfffff
    80001570:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001572:	57fd                	li	a5,-1
    80001574:	83e9                	srli	a5,a5,0x1a
    80001576:	0697ea63          	bltu	a5,s1,800015ea <copyout+0x98>
    8000157a:	e0ca                	sd	s2,64(sp)
    8000157c:	f852                	sd	s4,48(sp)
    8000157e:	e862                	sd	s8,16(sp)
    80001580:	e466                	sd	s9,8(sp)
    80001582:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001584:	4cd5                	li	s9,21
    80001586:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80001588:	8c3e                	mv	s8,a5
    8000158a:	a025                	j	800015b2 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    8000158c:	83a9                	srli	a5,a5,0xa
    8000158e:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001590:	409a8533          	sub	a0,s5,s1
    80001594:	0009061b          	sext.w	a2,s2
    80001598:	85da                	mv	a1,s6
    8000159a:	953e                	add	a0,a0,a5
    8000159c:	f88ff0ef          	jal	80000d24 <memmove>

    len -= n;
    800015a0:	412989b3          	sub	s3,s3,s2
    src += n;
    800015a4:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800015a6:	02098963          	beqz	s3,800015d8 <copyout+0x86>
    if(va0 >= MAXVA)
    800015aa:	054c6263          	bltu	s8,s4,800015ee <copyout+0x9c>
    800015ae:	84d2                	mv	s1,s4
    800015b0:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800015b2:	4601                	li	a2,0
    800015b4:	85a6                	mv	a1,s1
    800015b6:	855e                	mv	a0,s7
    800015b8:	985ff0ef          	jal	80000f3c <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015bc:	c121                	beqz	a0,800015fc <copyout+0xaa>
    800015be:	611c                	ld	a5,0(a0)
    800015c0:	0157f713          	andi	a4,a5,21
    800015c4:	05971b63          	bne	a4,s9,8000161a <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    800015c8:	01a48a33          	add	s4,s1,s10
    800015cc:	415a0933          	sub	s2,s4,s5
    if(n > len)
    800015d0:	fb29fee3          	bgeu	s3,s2,8000158c <copyout+0x3a>
    800015d4:	894e                	mv	s2,s3
    800015d6:	bf5d                	j	8000158c <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    800015d8:	4501                	li	a0,0
    800015da:	6906                	ld	s2,64(sp)
    800015dc:	7a42                	ld	s4,48(sp)
    800015de:	6c42                	ld	s8,16(sp)
    800015e0:	6ca2                	ld	s9,8(sp)
    800015e2:	6d02                	ld	s10,0(sp)
    800015e4:	a015                	j	80001608 <copyout+0xb6>
    800015e6:	4501                	li	a0,0
}
    800015e8:	8082                	ret
      return -1;
    800015ea:	557d                	li	a0,-1
    800015ec:	a831                	j	80001608 <copyout+0xb6>
    800015ee:	557d                	li	a0,-1
    800015f0:	6906                	ld	s2,64(sp)
    800015f2:	7a42                	ld	s4,48(sp)
    800015f4:	6c42                	ld	s8,16(sp)
    800015f6:	6ca2                	ld	s9,8(sp)
    800015f8:	6d02                	ld	s10,0(sp)
    800015fa:	a039                	j	80001608 <copyout+0xb6>
      return -1;
    800015fc:	557d                	li	a0,-1
    800015fe:	6906                	ld	s2,64(sp)
    80001600:	7a42                	ld	s4,48(sp)
    80001602:	6c42                	ld	s8,16(sp)
    80001604:	6ca2                	ld	s9,8(sp)
    80001606:	6d02                	ld	s10,0(sp)
}
    80001608:	60e6                	ld	ra,88(sp)
    8000160a:	6446                	ld	s0,80(sp)
    8000160c:	64a6                	ld	s1,72(sp)
    8000160e:	79e2                	ld	s3,56(sp)
    80001610:	7aa2                	ld	s5,40(sp)
    80001612:	7b02                	ld	s6,32(sp)
    80001614:	6be2                	ld	s7,24(sp)
    80001616:	6125                	addi	sp,sp,96
    80001618:	8082                	ret
      return -1;
    8000161a:	557d                	li	a0,-1
    8000161c:	6906                	ld	s2,64(sp)
    8000161e:	7a42                	ld	s4,48(sp)
    80001620:	6c42                	ld	s8,16(sp)
    80001622:	6ca2                	ld	s9,8(sp)
    80001624:	6d02                	ld	s10,0(sp)
    80001626:	b7cd                	j	80001608 <copyout+0xb6>

0000000080001628 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001628:	c6a5                	beqz	a3,80001690 <copyin+0x68>
{
    8000162a:	715d                	addi	sp,sp,-80
    8000162c:	e486                	sd	ra,72(sp)
    8000162e:	e0a2                	sd	s0,64(sp)
    80001630:	fc26                	sd	s1,56(sp)
    80001632:	f84a                	sd	s2,48(sp)
    80001634:	f44e                	sd	s3,40(sp)
    80001636:	f052                	sd	s4,32(sp)
    80001638:	ec56                	sd	s5,24(sp)
    8000163a:	e85a                	sd	s6,16(sp)
    8000163c:	e45e                	sd	s7,8(sp)
    8000163e:	e062                	sd	s8,0(sp)
    80001640:	0880                	addi	s0,sp,80
    80001642:	8b2a                	mv	s6,a0
    80001644:	8a2e                	mv	s4,a1
    80001646:	8c32                	mv	s8,a2
    80001648:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000164a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000164c:	6a85                	lui	s5,0x1
    8000164e:	a00d                	j	80001670 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001650:	018505b3          	add	a1,a0,s8
    80001654:	0004861b          	sext.w	a2,s1
    80001658:	412585b3          	sub	a1,a1,s2
    8000165c:	8552                	mv	a0,s4
    8000165e:	ec6ff0ef          	jal	80000d24 <memmove>

    len -= n;
    80001662:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001666:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001668:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000166c:	02098063          	beqz	s3,8000168c <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80001670:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001674:	85ca                	mv	a1,s2
    80001676:	855a                	mv	a0,s6
    80001678:	95fff0ef          	jal	80000fd6 <walkaddr>
    if(pa0 == 0)
    8000167c:	cd01                	beqz	a0,80001694 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    8000167e:	418904b3          	sub	s1,s2,s8
    80001682:	94d6                	add	s1,s1,s5
    if(n > len)
    80001684:	fc99f6e3          	bgeu	s3,s1,80001650 <copyin+0x28>
    80001688:	84ce                	mv	s1,s3
    8000168a:	b7d9                	j	80001650 <copyin+0x28>
  }
  return 0;
    8000168c:	4501                	li	a0,0
    8000168e:	a021                	j	80001696 <copyin+0x6e>
    80001690:	4501                	li	a0,0
}
    80001692:	8082                	ret
      return -1;
    80001694:	557d                	li	a0,-1
}
    80001696:	60a6                	ld	ra,72(sp)
    80001698:	6406                	ld	s0,64(sp)
    8000169a:	74e2                	ld	s1,56(sp)
    8000169c:	7942                	ld	s2,48(sp)
    8000169e:	79a2                	ld	s3,40(sp)
    800016a0:	7a02                	ld	s4,32(sp)
    800016a2:	6ae2                	ld	s5,24(sp)
    800016a4:	6b42                	ld	s6,16(sp)
    800016a6:	6ba2                	ld	s7,8(sp)
    800016a8:	6c02                	ld	s8,0(sp)
    800016aa:	6161                	addi	sp,sp,80
    800016ac:	8082                	ret

00000000800016ae <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800016ae:	c6dd                	beqz	a3,8000175c <copyinstr+0xae>
{
    800016b0:	715d                	addi	sp,sp,-80
    800016b2:	e486                	sd	ra,72(sp)
    800016b4:	e0a2                	sd	s0,64(sp)
    800016b6:	fc26                	sd	s1,56(sp)
    800016b8:	f84a                	sd	s2,48(sp)
    800016ba:	f44e                	sd	s3,40(sp)
    800016bc:	f052                	sd	s4,32(sp)
    800016be:	ec56                	sd	s5,24(sp)
    800016c0:	e85a                	sd	s6,16(sp)
    800016c2:	e45e                	sd	s7,8(sp)
    800016c4:	0880                	addi	s0,sp,80
    800016c6:	8a2a                	mv	s4,a0
    800016c8:	8b2e                	mv	s6,a1
    800016ca:	8bb2                	mv	s7,a2
    800016cc:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800016ce:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016d0:	6985                	lui	s3,0x1
    800016d2:	a825                	j	8000170a <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016d4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016d8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016da:	37fd                	addiw	a5,a5,-1
    800016dc:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016e0:	60a6                	ld	ra,72(sp)
    800016e2:	6406                	ld	s0,64(sp)
    800016e4:	74e2                	ld	s1,56(sp)
    800016e6:	7942                	ld	s2,48(sp)
    800016e8:	79a2                	ld	s3,40(sp)
    800016ea:	7a02                	ld	s4,32(sp)
    800016ec:	6ae2                	ld	s5,24(sp)
    800016ee:	6b42                	ld	s6,16(sp)
    800016f0:	6ba2                	ld	s7,8(sp)
    800016f2:	6161                	addi	sp,sp,80
    800016f4:	8082                	ret
    800016f6:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    800016fa:	9742                	add	a4,a4,a6
      --max;
    800016fc:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001700:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001704:	04e58463          	beq	a1,a4,8000174c <copyinstr+0x9e>
{
    80001708:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    8000170a:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000170e:	85a6                	mv	a1,s1
    80001710:	8552                	mv	a0,s4
    80001712:	8c5ff0ef          	jal	80000fd6 <walkaddr>
    if(pa0 == 0)
    80001716:	cd0d                	beqz	a0,80001750 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001718:	417486b3          	sub	a3,s1,s7
    8000171c:	96ce                	add	a3,a3,s3
    if(n > max)
    8000171e:	00d97363          	bgeu	s2,a3,80001724 <copyinstr+0x76>
    80001722:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001724:	955e                	add	a0,a0,s7
    80001726:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001728:	c695                	beqz	a3,80001754 <copyinstr+0xa6>
    8000172a:	87da                	mv	a5,s6
    8000172c:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000172e:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001732:	96da                	add	a3,a3,s6
    80001734:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001736:	00f60733          	add	a4,a2,a5
    8000173a:	00074703          	lbu	a4,0(a4)
    8000173e:	db59                	beqz	a4,800016d4 <copyinstr+0x26>
        *dst = *p;
    80001740:	00e78023          	sb	a4,0(a5)
      dst++;
    80001744:	0785                	addi	a5,a5,1
    while(n > 0){
    80001746:	fed797e3          	bne	a5,a3,80001734 <copyinstr+0x86>
    8000174a:	b775                	j	800016f6 <copyinstr+0x48>
    8000174c:	4781                	li	a5,0
    8000174e:	b771                	j	800016da <copyinstr+0x2c>
      return -1;
    80001750:	557d                	li	a0,-1
    80001752:	b779                	j	800016e0 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001754:	6b85                	lui	s7,0x1
    80001756:	9ba6                	add	s7,s7,s1
    80001758:	87da                	mv	a5,s6
    8000175a:	b77d                	j	80001708 <copyinstr+0x5a>
  int got_null = 0;
    8000175c:	4781                	li	a5,0
  if(got_null){
    8000175e:	37fd                	addiw	a5,a5,-1
    80001760:	0007851b          	sext.w	a0,a5
}
    80001764:	8082                	ret

0000000080001766 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001766:	7139                	addi	sp,sp,-64
    80001768:	fc06                	sd	ra,56(sp)
    8000176a:	f822                	sd	s0,48(sp)
    8000176c:	f426                	sd	s1,40(sp)
    8000176e:	f04a                	sd	s2,32(sp)
    80001770:	ec4e                	sd	s3,24(sp)
    80001772:	e852                	sd	s4,16(sp)
    80001774:	e456                	sd	s5,8(sp)
    80001776:	e05a                	sd	s6,0(sp)
    80001778:	0080                	addi	s0,sp,64
    8000177a:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000177c:	0000e497          	auipc	s1,0xe
    80001780:	71448493          	addi	s1,s1,1812 # 8000fe90 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001784:	8b26                	mv	s6,s1
    80001786:	00a36937          	lui	s2,0xa36
    8000178a:	77d90913          	addi	s2,s2,1917 # a3677d <_entry-0x7f5c9883>
    8000178e:	0932                	slli	s2,s2,0xc
    80001790:	46d90913          	addi	s2,s2,1133
    80001794:	0936                	slli	s2,s2,0xd
    80001796:	df590913          	addi	s2,s2,-523
    8000179a:	093a                	slli	s2,s2,0xe
    8000179c:	6cf90913          	addi	s2,s2,1743
    800017a0:	040009b7          	lui	s3,0x4000
    800017a4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017a6:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017a8:	00014a97          	auipc	s5,0x14
    800017ac:	4e8a8a93          	addi	s5,s5,1256 # 80015c90 <tickslock>
    char *pa = kalloc();
    800017b0:	b74ff0ef          	jal	80000b24 <kalloc>
    800017b4:	862a                	mv	a2,a0
    if(pa == 0)
    800017b6:	cd15                	beqz	a0,800017f2 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017b8:	416485b3          	sub	a1,s1,s6
    800017bc:	858d                	srai	a1,a1,0x3
    800017be:	032585b3          	mul	a1,a1,s2
    800017c2:	2585                	addiw	a1,a1,1
    800017c4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017c8:	4719                	li	a4,6
    800017ca:	6685                	lui	a3,0x1
    800017cc:	40b985b3          	sub	a1,s3,a1
    800017d0:	8552                	mv	a0,s4
    800017d2:	8f3ff0ef          	jal	800010c4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017d6:	17848493          	addi	s1,s1,376
    800017da:	fd549be3          	bne	s1,s5,800017b0 <proc_mapstacks+0x4a>
  }
}
    800017de:	70e2                	ld	ra,56(sp)
    800017e0:	7442                	ld	s0,48(sp)
    800017e2:	74a2                	ld	s1,40(sp)
    800017e4:	7902                	ld	s2,32(sp)
    800017e6:	69e2                	ld	s3,24(sp)
    800017e8:	6a42                	ld	s4,16(sp)
    800017ea:	6aa2                	ld	s5,8(sp)
    800017ec:	6b02                	ld	s6,0(sp)
    800017ee:	6121                	addi	sp,sp,64
    800017f0:	8082                	ret
      panic("kalloc");
    800017f2:	00006517          	auipc	a0,0x6
    800017f6:	a0650513          	addi	a0,a0,-1530 # 800071f8 <etext+0x1f8>
    800017fa:	f9bfe0ef          	jal	80000794 <panic>

00000000800017fe <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800017fe:	715d                	addi	sp,sp,-80
    80001800:	e486                	sd	ra,72(sp)
    80001802:	e0a2                	sd	s0,64(sp)
    80001804:	fc26                	sd	s1,56(sp)
    80001806:	f84a                	sd	s2,48(sp)
    80001808:	f44e                	sd	s3,40(sp)
    8000180a:	f052                	sd	s4,32(sp)
    8000180c:	ec56                	sd	s5,24(sp)
    8000180e:	e85a                	sd	s6,16(sp)
    80001810:	e45e                	sd	s7,8(sp)
    80001812:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001814:	00006597          	auipc	a1,0x6
    80001818:	9ec58593          	addi	a1,a1,-1556 # 80007200 <etext+0x200>
    8000181c:	0000e517          	auipc	a0,0xe
    80001820:	24450513          	addi	a0,a0,580 # 8000fa60 <pid_lock>
    80001824:	b50ff0ef          	jal	80000b74 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001828:	00006597          	auipc	a1,0x6
    8000182c:	9e058593          	addi	a1,a1,-1568 # 80007208 <etext+0x208>
    80001830:	0000e517          	auipc	a0,0xe
    80001834:	24850513          	addi	a0,a0,584 # 8000fa78 <wait_lock>
    80001838:	b3cff0ef          	jal	80000b74 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000183c:	0000e497          	auipc	s1,0xe
    80001840:	65448493          	addi	s1,s1,1620 # 8000fe90 <proc>
      initlock(&p->lock, "proc");
    80001844:	00006b97          	auipc	s7,0x6
    80001848:	9d4b8b93          	addi	s7,s7,-1580 # 80007218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000184c:	8b26                	mv	s6,s1
    8000184e:	00a36937          	lui	s2,0xa36
    80001852:	77d90913          	addi	s2,s2,1917 # a3677d <_entry-0x7f5c9883>
    80001856:	0932                	slli	s2,s2,0xc
    80001858:	46d90913          	addi	s2,s2,1133
    8000185c:	0936                	slli	s2,s2,0xd
    8000185e:	df590913          	addi	s2,s2,-523
    80001862:	093a                	slli	s2,s2,0xe
    80001864:	6cf90913          	addi	s2,s2,1743
    80001868:	040009b7          	lui	s3,0x4000
    8000186c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000186e:	09b2                	slli	s3,s3,0xc
      p->priority = MAXPRIORITY;
    80001870:	4a95                	li	s5,5
  for(p = proc; p < &proc[NPROC]; p++) {
    80001872:	00014a17          	auipc	s4,0x14
    80001876:	41ea0a13          	addi	s4,s4,1054 # 80015c90 <tickslock>
      initlock(&p->lock, "proc");
    8000187a:	85de                	mv	a1,s7
    8000187c:	8526                	mv	a0,s1
    8000187e:	af6ff0ef          	jal	80000b74 <initlock>
      p->state = UNUSED;
    80001882:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001886:	416487b3          	sub	a5,s1,s6
    8000188a:	878d                	srai	a5,a5,0x3
    8000188c:	032787b3          	mul	a5,a5,s2
    80001890:	2785                	addiw	a5,a5,1
    80001892:	00d7979b          	slliw	a5,a5,0xd
    80001896:	40f987b3          	sub	a5,s3,a5
    8000189a:	e0bc                	sd	a5,64(s1)
      p->priority = MAXPRIORITY;
    8000189c:	1754a423          	sw	s5,360(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018a0:	17848493          	addi	s1,s1,376
    800018a4:	fd449be3          	bne	s1,s4,8000187a <procinit+0x7c>
  }
}
    800018a8:	60a6                	ld	ra,72(sp)
    800018aa:	6406                	ld	s0,64(sp)
    800018ac:	74e2                	ld	s1,56(sp)
    800018ae:	7942                	ld	s2,48(sp)
    800018b0:	79a2                	ld	s3,40(sp)
    800018b2:	7a02                	ld	s4,32(sp)
    800018b4:	6ae2                	ld	s5,24(sp)
    800018b6:	6b42                	ld	s6,16(sp)
    800018b8:	6ba2                	ld	s7,8(sp)
    800018ba:	6161                	addi	sp,sp,80
    800018bc:	8082                	ret

00000000800018be <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018be:	1141                	addi	sp,sp,-16
    800018c0:	e422                	sd	s0,8(sp)
    800018c2:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018c4:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018c6:	2501                	sext.w	a0,a0
    800018c8:	6422                	ld	s0,8(sp)
    800018ca:	0141                	addi	sp,sp,16
    800018cc:	8082                	ret

00000000800018ce <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018ce:	1141                	addi	sp,sp,-16
    800018d0:	e422                	sd	s0,8(sp)
    800018d2:	0800                	addi	s0,sp,16
    800018d4:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018d6:	2781                	sext.w	a5,a5
    800018d8:	079e                	slli	a5,a5,0x7
  return c;
}
    800018da:	0000e517          	auipc	a0,0xe
    800018de:	1b650513          	addi	a0,a0,438 # 8000fa90 <cpus>
    800018e2:	953e                	add	a0,a0,a5
    800018e4:	6422                	ld	s0,8(sp)
    800018e6:	0141                	addi	sp,sp,16
    800018e8:	8082                	ret

00000000800018ea <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800018ea:	1101                	addi	sp,sp,-32
    800018ec:	ec06                	sd	ra,24(sp)
    800018ee:	e822                	sd	s0,16(sp)
    800018f0:	e426                	sd	s1,8(sp)
    800018f2:	1000                	addi	s0,sp,32
  push_off();
    800018f4:	ac0ff0ef          	jal	80000bb4 <push_off>
    800018f8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018fa:	2781                	sext.w	a5,a5
    800018fc:	079e                	slli	a5,a5,0x7
    800018fe:	0000e717          	auipc	a4,0xe
    80001902:	16270713          	addi	a4,a4,354 # 8000fa60 <pid_lock>
    80001906:	97ba                	add	a5,a5,a4
    80001908:	7b84                	ld	s1,48(a5)
  pop_off();
    8000190a:	b2eff0ef          	jal	80000c38 <pop_off>
  return p;
}
    8000190e:	8526                	mv	a0,s1
    80001910:	60e2                	ld	ra,24(sp)
    80001912:	6442                	ld	s0,16(sp)
    80001914:	64a2                	ld	s1,8(sp)
    80001916:	6105                	addi	sp,sp,32
    80001918:	8082                	ret

000000008000191a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000191a:	1141                	addi	sp,sp,-16
    8000191c:	e406                	sd	ra,8(sp)
    8000191e:	e022                	sd	s0,0(sp)
    80001920:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001922:	fc9ff0ef          	jal	800018ea <myproc>
    80001926:	b66ff0ef          	jal	80000c8c <release>

  if (first) {
    8000192a:	00006797          	auipc	a5,0x6
    8000192e:	f867a783          	lw	a5,-122(a5) # 800078b0 <first.1>
    80001932:	e799                	bnez	a5,80001940 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001934:	2d7000ef          	jal	8000240a <usertrapret>
}
    80001938:	60a2                	ld	ra,8(sp)
    8000193a:	6402                	ld	s0,0(sp)
    8000193c:	0141                	addi	sp,sp,16
    8000193e:	8082                	ret
    fsinit(ROOTDEV);
    80001940:	4505                	li	a0,1
    80001942:	66c010ef          	jal	80002fae <fsinit>
    first = 0;
    80001946:	00006797          	auipc	a5,0x6
    8000194a:	f607a523          	sw	zero,-150(a5) # 800078b0 <first.1>
    __sync_synchronize();
    8000194e:	0ff0000f          	fence
    80001952:	b7cd                	j	80001934 <forkret+0x1a>

0000000080001954 <allocpid>:
{
    80001954:	1101                	addi	sp,sp,-32
    80001956:	ec06                	sd	ra,24(sp)
    80001958:	e822                	sd	s0,16(sp)
    8000195a:	e426                	sd	s1,8(sp)
    8000195c:	e04a                	sd	s2,0(sp)
    8000195e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001960:	0000e917          	auipc	s2,0xe
    80001964:	10090913          	addi	s2,s2,256 # 8000fa60 <pid_lock>
    80001968:	854a                	mv	a0,s2
    8000196a:	a8aff0ef          	jal	80000bf4 <acquire>
  pid = nextpid;
    8000196e:	00006797          	auipc	a5,0x6
    80001972:	f4678793          	addi	a5,a5,-186 # 800078b4 <nextpid>
    80001976:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001978:	0014871b          	addiw	a4,s1,1
    8000197c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000197e:	854a                	mv	a0,s2
    80001980:	b0cff0ef          	jal	80000c8c <release>
}
    80001984:	8526                	mv	a0,s1
    80001986:	60e2                	ld	ra,24(sp)
    80001988:	6442                	ld	s0,16(sp)
    8000198a:	64a2                	ld	s1,8(sp)
    8000198c:	6902                	ld	s2,0(sp)
    8000198e:	6105                	addi	sp,sp,32
    80001990:	8082                	ret

0000000080001992 <proc_pagetable>:
{
    80001992:	1101                	addi	sp,sp,-32
    80001994:	ec06                	sd	ra,24(sp)
    80001996:	e822                	sd	s0,16(sp)
    80001998:	e426                	sd	s1,8(sp)
    8000199a:	e04a                	sd	s2,0(sp)
    8000199c:	1000                	addi	s0,sp,32
    8000199e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800019a0:	8d7ff0ef          	jal	80001276 <uvmcreate>
    800019a4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800019a6:	cd05                	beqz	a0,800019de <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800019a8:	4729                	li	a4,10
    800019aa:	00004697          	auipc	a3,0x4
    800019ae:	65668693          	addi	a3,a3,1622 # 80006000 <_trampoline>
    800019b2:	6605                	lui	a2,0x1
    800019b4:	040005b7          	lui	a1,0x4000
    800019b8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019ba:	05b2                	slli	a1,a1,0xc
    800019bc:	e58ff0ef          	jal	80001014 <mappages>
    800019c0:	02054663          	bltz	a0,800019ec <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800019c4:	4719                	li	a4,6
    800019c6:	05893683          	ld	a3,88(s2)
    800019ca:	6605                	lui	a2,0x1
    800019cc:	020005b7          	lui	a1,0x2000
    800019d0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019d2:	05b6                	slli	a1,a1,0xd
    800019d4:	8526                	mv	a0,s1
    800019d6:	e3eff0ef          	jal	80001014 <mappages>
    800019da:	00054f63          	bltz	a0,800019f8 <proc_pagetable+0x66>
}
    800019de:	8526                	mv	a0,s1
    800019e0:	60e2                	ld	ra,24(sp)
    800019e2:	6442                	ld	s0,16(sp)
    800019e4:	64a2                	ld	s1,8(sp)
    800019e6:	6902                	ld	s2,0(sp)
    800019e8:	6105                	addi	sp,sp,32
    800019ea:	8082                	ret
    uvmfree(pagetable, 0);
    800019ec:	4581                	li	a1,0
    800019ee:	8526                	mv	a0,s1
    800019f0:	a55ff0ef          	jal	80001444 <uvmfree>
    return 0;
    800019f4:	4481                	li	s1,0
    800019f6:	b7e5                	j	800019de <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800019f8:	4681                	li	a3,0
    800019fa:	4605                	li	a2,1
    800019fc:	040005b7          	lui	a1,0x4000
    80001a00:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a02:	05b2                	slli	a1,a1,0xc
    80001a04:	8526                	mv	a0,s1
    80001a06:	fb4ff0ef          	jal	800011ba <uvmunmap>
    uvmfree(pagetable, 0);
    80001a0a:	4581                	li	a1,0
    80001a0c:	8526                	mv	a0,s1
    80001a0e:	a37ff0ef          	jal	80001444 <uvmfree>
    return 0;
    80001a12:	4481                	li	s1,0
    80001a14:	b7e9                	j	800019de <proc_pagetable+0x4c>

0000000080001a16 <proc_freepagetable>:
{
    80001a16:	1101                	addi	sp,sp,-32
    80001a18:	ec06                	sd	ra,24(sp)
    80001a1a:	e822                	sd	s0,16(sp)
    80001a1c:	e426                	sd	s1,8(sp)
    80001a1e:	e04a                	sd	s2,0(sp)
    80001a20:	1000                	addi	s0,sp,32
    80001a22:	84aa                	mv	s1,a0
    80001a24:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a26:	4681                	li	a3,0
    80001a28:	4605                	li	a2,1
    80001a2a:	040005b7          	lui	a1,0x4000
    80001a2e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a30:	05b2                	slli	a1,a1,0xc
    80001a32:	f88ff0ef          	jal	800011ba <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a36:	4681                	li	a3,0
    80001a38:	4605                	li	a2,1
    80001a3a:	020005b7          	lui	a1,0x2000
    80001a3e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a40:	05b6                	slli	a1,a1,0xd
    80001a42:	8526                	mv	a0,s1
    80001a44:	f76ff0ef          	jal	800011ba <uvmunmap>
  uvmfree(pagetable, sz);
    80001a48:	85ca                	mv	a1,s2
    80001a4a:	8526                	mv	a0,s1
    80001a4c:	9f9ff0ef          	jal	80001444 <uvmfree>
}
    80001a50:	60e2                	ld	ra,24(sp)
    80001a52:	6442                	ld	s0,16(sp)
    80001a54:	64a2                	ld	s1,8(sp)
    80001a56:	6902                	ld	s2,0(sp)
    80001a58:	6105                	addi	sp,sp,32
    80001a5a:	8082                	ret

0000000080001a5c <freeproc>:
{
    80001a5c:	1101                	addi	sp,sp,-32
    80001a5e:	ec06                	sd	ra,24(sp)
    80001a60:	e822                	sd	s0,16(sp)
    80001a62:	e426                	sd	s1,8(sp)
    80001a64:	1000                	addi	s0,sp,32
    80001a66:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001a68:	6d28                	ld	a0,88(a0)
    80001a6a:	c119                	beqz	a0,80001a70 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001a6c:	fd7fe0ef          	jal	80000a42 <kfree>
  p->trapframe = 0;
    80001a70:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001a74:	68a8                	ld	a0,80(s1)
    80001a76:	c501                	beqz	a0,80001a7e <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001a78:	64ac                	ld	a1,72(s1)
    80001a7a:	f9dff0ef          	jal	80001a16 <proc_freepagetable>
  p->pagetable = 0;
    80001a7e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001a82:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001a86:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001a8a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001a8e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001a92:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001a96:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001a9a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001a9e:	0004ac23          	sw	zero,24(s1)
}
    80001aa2:	60e2                	ld	ra,24(sp)
    80001aa4:	6442                	ld	s0,16(sp)
    80001aa6:	64a2                	ld	s1,8(sp)
    80001aa8:	6105                	addi	sp,sp,32
    80001aaa:	8082                	ret

0000000080001aac <allocproc>:
{
    80001aac:	1101                	addi	sp,sp,-32
    80001aae:	ec06                	sd	ra,24(sp)
    80001ab0:	e822                	sd	s0,16(sp)
    80001ab2:	e426                	sd	s1,8(sp)
    80001ab4:	e04a                	sd	s2,0(sp)
    80001ab6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ab8:	0000e497          	auipc	s1,0xe
    80001abc:	3d848493          	addi	s1,s1,984 # 8000fe90 <proc>
    80001ac0:	00014917          	auipc	s2,0x14
    80001ac4:	1d090913          	addi	s2,s2,464 # 80015c90 <tickslock>
    acquire(&p->lock);
    80001ac8:	8526                	mv	a0,s1
    80001aca:	92aff0ef          	jal	80000bf4 <acquire>
    if(p->state == UNUSED) {
    80001ace:	4c9c                	lw	a5,24(s1)
    80001ad0:	cb91                	beqz	a5,80001ae4 <allocproc+0x38>
      release(&p->lock);
    80001ad2:	8526                	mv	a0,s1
    80001ad4:	9b8ff0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ad8:	17848493          	addi	s1,s1,376
    80001adc:	ff2496e3          	bne	s1,s2,80001ac8 <allocproc+0x1c>
  return 0;
    80001ae0:	4481                	li	s1,0
    80001ae2:	a089                	j	80001b24 <allocproc+0x78>
  p->pid = allocpid();
    80001ae4:	e71ff0ef          	jal	80001954 <allocpid>
    80001ae8:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001aea:	4785                	li	a5,1
    80001aec:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001aee:	836ff0ef          	jal	80000b24 <kalloc>
    80001af2:	892a                	mv	s2,a0
    80001af4:	eca8                	sd	a0,88(s1)
    80001af6:	cd15                	beqz	a0,80001b32 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001af8:	8526                	mv	a0,s1
    80001afa:	e99ff0ef          	jal	80001992 <proc_pagetable>
    80001afe:	892a                	mv	s2,a0
    80001b00:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001b02:	c121                	beqz	a0,80001b42 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001b04:	07000613          	li	a2,112
    80001b08:	4581                	li	a1,0
    80001b0a:	06048513          	addi	a0,s1,96
    80001b0e:	9baff0ef          	jal	80000cc8 <memset>
  p->context.ra = (uint64)forkret;
    80001b12:	00000797          	auipc	a5,0x0
    80001b16:	e0878793          	addi	a5,a5,-504 # 8000191a <forkret>
    80001b1a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b1c:	60bc                	ld	a5,64(s1)
    80001b1e:	6705                	lui	a4,0x1
    80001b20:	97ba                	add	a5,a5,a4
    80001b22:	f4bc                	sd	a5,104(s1)
}
    80001b24:	8526                	mv	a0,s1
    80001b26:	60e2                	ld	ra,24(sp)
    80001b28:	6442                	ld	s0,16(sp)
    80001b2a:	64a2                	ld	s1,8(sp)
    80001b2c:	6902                	ld	s2,0(sp)
    80001b2e:	6105                	addi	sp,sp,32
    80001b30:	8082                	ret
    freeproc(p);
    80001b32:	8526                	mv	a0,s1
    80001b34:	f29ff0ef          	jal	80001a5c <freeproc>
    release(&p->lock);
    80001b38:	8526                	mv	a0,s1
    80001b3a:	952ff0ef          	jal	80000c8c <release>
    return 0;
    80001b3e:	84ca                	mv	s1,s2
    80001b40:	b7d5                	j	80001b24 <allocproc+0x78>
    freeproc(p);
    80001b42:	8526                	mv	a0,s1
    80001b44:	f19ff0ef          	jal	80001a5c <freeproc>
    release(&p->lock);
    80001b48:	8526                	mv	a0,s1
    80001b4a:	942ff0ef          	jal	80000c8c <release>
    return 0;
    80001b4e:	84ca                	mv	s1,s2
    80001b50:	bfd1                	j	80001b24 <allocproc+0x78>

0000000080001b52 <userinit>:
{
    80001b52:	1101                	addi	sp,sp,-32
    80001b54:	ec06                	sd	ra,24(sp)
    80001b56:	e822                	sd	s0,16(sp)
    80001b58:	e426                	sd	s1,8(sp)
    80001b5a:	1000                	addi	s0,sp,32
  p = allocproc();
    80001b5c:	f51ff0ef          	jal	80001aac <allocproc>
    80001b60:	84aa                	mv	s1,a0
  initproc = p;
    80001b62:	00006797          	auipc	a5,0x6
    80001b66:	dca7b323          	sd	a0,-570(a5) # 80007928 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001b6a:	03400613          	li	a2,52
    80001b6e:	00006597          	auipc	a1,0x6
    80001b72:	d5258593          	addi	a1,a1,-686 # 800078c0 <initcode>
    80001b76:	6928                	ld	a0,80(a0)
    80001b78:	f24ff0ef          	jal	8000129c <uvmfirst>
  p->sz = PGSIZE;
    80001b7c:	6785                	lui	a5,0x1
    80001b7e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001b80:	6cb8                	ld	a4,88(s1)
    80001b82:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001b86:	6cb8                	ld	a4,88(s1)
    80001b88:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001b8a:	4641                	li	a2,16
    80001b8c:	00005597          	auipc	a1,0x5
    80001b90:	69458593          	addi	a1,a1,1684 # 80007220 <etext+0x220>
    80001b94:	15848513          	addi	a0,s1,344
    80001b98:	a6eff0ef          	jal	80000e06 <safestrcpy>
  p->cwd = namei("/");
    80001b9c:	00005517          	auipc	a0,0x5
    80001ba0:	69450513          	addi	a0,a0,1684 # 80007230 <etext+0x230>
    80001ba4:	519010ef          	jal	800038bc <namei>
    80001ba8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001bac:	478d                	li	a5,3
    80001bae:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001bb0:	8526                	mv	a0,s1
    80001bb2:	8daff0ef          	jal	80000c8c <release>
}
    80001bb6:	60e2                	ld	ra,24(sp)
    80001bb8:	6442                	ld	s0,16(sp)
    80001bba:	64a2                	ld	s1,8(sp)
    80001bbc:	6105                	addi	sp,sp,32
    80001bbe:	8082                	ret

0000000080001bc0 <growproc>:
{
    80001bc0:	1101                	addi	sp,sp,-32
    80001bc2:	ec06                	sd	ra,24(sp)
    80001bc4:	e822                	sd	s0,16(sp)
    80001bc6:	e426                	sd	s1,8(sp)
    80001bc8:	e04a                	sd	s2,0(sp)
    80001bca:	1000                	addi	s0,sp,32
    80001bcc:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001bce:	d1dff0ef          	jal	800018ea <myproc>
    80001bd2:	84aa                	mv	s1,a0
  sz = p->sz;
    80001bd4:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001bd6:	01204c63          	bgtz	s2,80001bee <growproc+0x2e>
  } else if(n < 0){
    80001bda:	02094463          	bltz	s2,80001c02 <growproc+0x42>
  p->sz = sz;
    80001bde:	e4ac                	sd	a1,72(s1)
  return 0;
    80001be0:	4501                	li	a0,0
}
    80001be2:	60e2                	ld	ra,24(sp)
    80001be4:	6442                	ld	s0,16(sp)
    80001be6:	64a2                	ld	s1,8(sp)
    80001be8:	6902                	ld	s2,0(sp)
    80001bea:	6105                	addi	sp,sp,32
    80001bec:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001bee:	4691                	li	a3,4
    80001bf0:	00b90633          	add	a2,s2,a1
    80001bf4:	6928                	ld	a0,80(a0)
    80001bf6:	f48ff0ef          	jal	8000133e <uvmalloc>
    80001bfa:	85aa                	mv	a1,a0
    80001bfc:	f16d                	bnez	a0,80001bde <growproc+0x1e>
      return -1;
    80001bfe:	557d                	li	a0,-1
    80001c00:	b7cd                	j	80001be2 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c02:	00b90633          	add	a2,s2,a1
    80001c06:	6928                	ld	a0,80(a0)
    80001c08:	ef2ff0ef          	jal	800012fa <uvmdealloc>
    80001c0c:	85aa                	mv	a1,a0
    80001c0e:	bfc1                	j	80001bde <growproc+0x1e>

0000000080001c10 <fork>:
{
    80001c10:	7139                	addi	sp,sp,-64
    80001c12:	fc06                	sd	ra,56(sp)
    80001c14:	f822                	sd	s0,48(sp)
    80001c16:	f04a                	sd	s2,32(sp)
    80001c18:	e456                	sd	s5,8(sp)
    80001c1a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c1c:	ccfff0ef          	jal	800018ea <myproc>
    80001c20:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001c22:	e8bff0ef          	jal	80001aac <allocproc>
    80001c26:	0e050a63          	beqz	a0,80001d1a <fork+0x10a>
    80001c2a:	e852                	sd	s4,16(sp)
    80001c2c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001c2e:	048ab603          	ld	a2,72(s5)
    80001c32:	692c                	ld	a1,80(a0)
    80001c34:	050ab503          	ld	a0,80(s5)
    80001c38:	83fff0ef          	jal	80001476 <uvmcopy>
    80001c3c:	04054a63          	bltz	a0,80001c90 <fork+0x80>
    80001c40:	f426                	sd	s1,40(sp)
    80001c42:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001c44:	048ab783          	ld	a5,72(s5)
    80001c48:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001c4c:	058ab683          	ld	a3,88(s5)
    80001c50:	87b6                	mv	a5,a3
    80001c52:	058a3703          	ld	a4,88(s4)
    80001c56:	12068693          	addi	a3,a3,288
    80001c5a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001c5e:	6788                	ld	a0,8(a5)
    80001c60:	6b8c                	ld	a1,16(a5)
    80001c62:	6f90                	ld	a2,24(a5)
    80001c64:	01073023          	sd	a6,0(a4)
    80001c68:	e708                	sd	a0,8(a4)
    80001c6a:	eb0c                	sd	a1,16(a4)
    80001c6c:	ef10                	sd	a2,24(a4)
    80001c6e:	02078793          	addi	a5,a5,32
    80001c72:	02070713          	addi	a4,a4,32
    80001c76:	fed792e3          	bne	a5,a3,80001c5a <fork+0x4a>
  np->trapframe->a0 = 0;
    80001c7a:	058a3783          	ld	a5,88(s4)
    80001c7e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001c82:	0d0a8493          	addi	s1,s5,208
    80001c86:	0d0a0913          	addi	s2,s4,208
    80001c8a:	150a8993          	addi	s3,s5,336
    80001c8e:	a831                	j	80001caa <fork+0x9a>
    freeproc(np);
    80001c90:	8552                	mv	a0,s4
    80001c92:	dcbff0ef          	jal	80001a5c <freeproc>
    release(&np->lock);
    80001c96:	8552                	mv	a0,s4
    80001c98:	ff5fe0ef          	jal	80000c8c <release>
    return -1;
    80001c9c:	597d                	li	s2,-1
    80001c9e:	6a42                	ld	s4,16(sp)
    80001ca0:	a0b5                	j	80001d0c <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001ca2:	04a1                	addi	s1,s1,8
    80001ca4:	0921                	addi	s2,s2,8
    80001ca6:	01348963          	beq	s1,s3,80001cb8 <fork+0xa8>
    if(p->ofile[i])
    80001caa:	6088                	ld	a0,0(s1)
    80001cac:	d97d                	beqz	a0,80001ca2 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001cae:	19e020ef          	jal	80003e4c <filedup>
    80001cb2:	00a93023          	sd	a0,0(s2)
    80001cb6:	b7f5                	j	80001ca2 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001cb8:	150ab503          	ld	a0,336(s5)
    80001cbc:	4f0010ef          	jal	800031ac <idup>
    80001cc0:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001cc4:	4641                	li	a2,16
    80001cc6:	158a8593          	addi	a1,s5,344
    80001cca:	158a0513          	addi	a0,s4,344
    80001cce:	938ff0ef          	jal	80000e06 <safestrcpy>
  pid = np->pid;
    80001cd2:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001cd6:	8552                	mv	a0,s4
    80001cd8:	fb5fe0ef          	jal	80000c8c <release>
  acquire(&wait_lock);
    80001cdc:	0000e497          	auipc	s1,0xe
    80001ce0:	d9c48493          	addi	s1,s1,-612 # 8000fa78 <wait_lock>
    80001ce4:	8526                	mv	a0,s1
    80001ce6:	f0ffe0ef          	jal	80000bf4 <acquire>
  np->parent = p;
    80001cea:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001cee:	8526                	mv	a0,s1
    80001cf0:	f9dfe0ef          	jal	80000c8c <release>
  acquire(&np->lock);
    80001cf4:	8552                	mv	a0,s4
    80001cf6:	efffe0ef          	jal	80000bf4 <acquire>
  np->state = RUNNABLE;
    80001cfa:	478d                	li	a5,3
    80001cfc:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d00:	8552                	mv	a0,s4
    80001d02:	f8bfe0ef          	jal	80000c8c <release>
  return pid;
    80001d06:	74a2                	ld	s1,40(sp)
    80001d08:	69e2                	ld	s3,24(sp)
    80001d0a:	6a42                	ld	s4,16(sp)
}
    80001d0c:	854a                	mv	a0,s2
    80001d0e:	70e2                	ld	ra,56(sp)
    80001d10:	7442                	ld	s0,48(sp)
    80001d12:	7902                	ld	s2,32(sp)
    80001d14:	6aa2                	ld	s5,8(sp)
    80001d16:	6121                	addi	sp,sp,64
    80001d18:	8082                	ret
    return -1;
    80001d1a:	597d                	li	s2,-1
    80001d1c:	bfc5                	j	80001d0c <fork+0xfc>

0000000080001d1e <scheduler>:
{
    80001d1e:	711d                	addi	sp,sp,-96
    80001d20:	ec86                	sd	ra,88(sp)
    80001d22:	e8a2                	sd	s0,80(sp)
    80001d24:	e4a6                	sd	s1,72(sp)
    80001d26:	e0ca                	sd	s2,64(sp)
    80001d28:	fc4e                	sd	s3,56(sp)
    80001d2a:	f852                	sd	s4,48(sp)
    80001d2c:	f456                	sd	s5,40(sp)
    80001d2e:	f05a                	sd	s6,32(sp)
    80001d30:	ec5e                	sd	s7,24(sp)
    80001d32:	e862                	sd	s8,16(sp)
    80001d34:	e466                	sd	s9,8(sp)
    80001d36:	1080                	addi	s0,sp,96
    80001d38:	8792                	mv	a5,tp
  int id = r_tp();
    80001d3a:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d3c:	00779b93          	slli	s7,a5,0x7
    80001d40:	0000e717          	auipc	a4,0xe
    80001d44:	d2070713          	addi	a4,a4,-736 # 8000fa60 <pid_lock>
    80001d48:	975e                	add	a4,a4,s7
    80001d4a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001d4e:	0000e717          	auipc	a4,0xe
    80001d52:	d4a70713          	addi	a4,a4,-694 # 8000fa98 <cpus+0x8>
    80001d56:	9bba                	add	s7,s7,a4
        printf("The process is %s and the priority is %d\n", p->name, p->priority);
    80001d58:	00005c97          	auipc	s9,0x5
    80001d5c:	4e0c8c93          	addi	s9,s9,1248 # 80007238 <etext+0x238>
        p->state = RUNNING;
    80001d60:	4c11                	li	s8,4
        c->proc = p;
    80001d62:	079e                	slli	a5,a5,0x7
    80001d64:	0000ea17          	auipc	s4,0xe
    80001d68:	cfca0a13          	addi	s4,s4,-772 # 8000fa60 <pid_lock>
    80001d6c:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d6e:	00014997          	auipc	s3,0x14
    80001d72:	f2298993          	addi	s3,s3,-222 # 80015c90 <tickslock>
    80001d76:	a8a1                	j	80001dce <scheduler+0xb0>
      release(&p->lock);
    80001d78:	8526                	mv	a0,s1
    80001d7a:	f13fe0ef          	jal	80000c8c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d7e:	17848493          	addi	s1,s1,376
    80001d82:	03348c63          	beq	s1,s3,80001dba <scheduler+0x9c>
      acquire(&p->lock);
    80001d86:	8526                	mv	a0,s1
    80001d88:	e6dfe0ef          	jal	80000bf4 <acquire>
      if(p->state == RUNNABLE) {
    80001d8c:	4c9c                	lw	a5,24(s1)
    80001d8e:	ff2795e3          	bne	a5,s2,80001d78 <scheduler+0x5a>
        printf("The process is %s and the priority is %d\n", p->name, p->priority);
    80001d92:	1684a603          	lw	a2,360(s1)
    80001d96:	15848593          	addi	a1,s1,344
    80001d9a:	8566                	mv	a0,s9
    80001d9c:	f26fe0ef          	jal	800004c2 <printf>
        p->state = RUNNING;
    80001da0:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001da4:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001da8:	06048593          	addi	a1,s1,96
    80001dac:	855e                	mv	a0,s7
    80001dae:	5b6000ef          	jal	80002364 <swtch>
        c->proc = 0;
    80001db2:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001db6:	8ada                	mv	s5,s6
    80001db8:	b7c1                	j	80001d78 <scheduler+0x5a>
    if(found == 0) {
    80001dba:	000a9a63          	bnez	s5,80001dce <scheduler+0xb0>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dbe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dc2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dc6:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001dca:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dd2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd6:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001dda:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ddc:	0000e497          	auipc	s1,0xe
    80001de0:	0b448493          	addi	s1,s1,180 # 8000fe90 <proc>
      if(p->state == RUNNABLE) {
    80001de4:	490d                	li	s2,3
        found = 1;
    80001de6:	4b05                	li	s6,1
    80001de8:	bf79                	j	80001d86 <scheduler+0x68>

0000000080001dea <sched>:
{
    80001dea:	7179                	addi	sp,sp,-48
    80001dec:	f406                	sd	ra,40(sp)
    80001dee:	f022                	sd	s0,32(sp)
    80001df0:	ec26                	sd	s1,24(sp)
    80001df2:	e84a                	sd	s2,16(sp)
    80001df4:	e44e                	sd	s3,8(sp)
    80001df6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001df8:	af3ff0ef          	jal	800018ea <myproc>
    80001dfc:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001dfe:	d8dfe0ef          	jal	80000b8a <holding>
    80001e02:	c92d                	beqz	a0,80001e74 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e04:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001e06:	2781                	sext.w	a5,a5
    80001e08:	079e                	slli	a5,a5,0x7
    80001e0a:	0000e717          	auipc	a4,0xe
    80001e0e:	c5670713          	addi	a4,a4,-938 # 8000fa60 <pid_lock>
    80001e12:	97ba                	add	a5,a5,a4
    80001e14:	0a87a703          	lw	a4,168(a5)
    80001e18:	4785                	li	a5,1
    80001e1a:	06f71363          	bne	a4,a5,80001e80 <sched+0x96>
  if(p->state == RUNNING)
    80001e1e:	4c98                	lw	a4,24(s1)
    80001e20:	4791                	li	a5,4
    80001e22:	06f70563          	beq	a4,a5,80001e8c <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e26:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e2a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e2c:	e7b5                	bnez	a5,80001e98 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e2e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e30:	0000e917          	auipc	s2,0xe
    80001e34:	c3090913          	addi	s2,s2,-976 # 8000fa60 <pid_lock>
    80001e38:	2781                	sext.w	a5,a5
    80001e3a:	079e                	slli	a5,a5,0x7
    80001e3c:	97ca                	add	a5,a5,s2
    80001e3e:	0ac7a983          	lw	s3,172(a5)
    80001e42:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e44:	2781                	sext.w	a5,a5
    80001e46:	079e                	slli	a5,a5,0x7
    80001e48:	0000e597          	auipc	a1,0xe
    80001e4c:	c5058593          	addi	a1,a1,-944 # 8000fa98 <cpus+0x8>
    80001e50:	95be                	add	a1,a1,a5
    80001e52:	06048513          	addi	a0,s1,96
    80001e56:	50e000ef          	jal	80002364 <swtch>
    80001e5a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001e5c:	2781                	sext.w	a5,a5
    80001e5e:	079e                	slli	a5,a5,0x7
    80001e60:	993e                	add	s2,s2,a5
    80001e62:	0b392623          	sw	s3,172(s2)
}
    80001e66:	70a2                	ld	ra,40(sp)
    80001e68:	7402                	ld	s0,32(sp)
    80001e6a:	64e2                	ld	s1,24(sp)
    80001e6c:	6942                	ld	s2,16(sp)
    80001e6e:	69a2                	ld	s3,8(sp)
    80001e70:	6145                	addi	sp,sp,48
    80001e72:	8082                	ret
    panic("sched p->lock");
    80001e74:	00005517          	auipc	a0,0x5
    80001e78:	3f450513          	addi	a0,a0,1012 # 80007268 <etext+0x268>
    80001e7c:	919fe0ef          	jal	80000794 <panic>
    panic("sched locks");
    80001e80:	00005517          	auipc	a0,0x5
    80001e84:	3f850513          	addi	a0,a0,1016 # 80007278 <etext+0x278>
    80001e88:	90dfe0ef          	jal	80000794 <panic>
    panic("sched running");
    80001e8c:	00005517          	auipc	a0,0x5
    80001e90:	3fc50513          	addi	a0,a0,1020 # 80007288 <etext+0x288>
    80001e94:	901fe0ef          	jal	80000794 <panic>
    panic("sched interruptible");
    80001e98:	00005517          	auipc	a0,0x5
    80001e9c:	40050513          	addi	a0,a0,1024 # 80007298 <etext+0x298>
    80001ea0:	8f5fe0ef          	jal	80000794 <panic>

0000000080001ea4 <yield>:
{
    80001ea4:	1101                	addi	sp,sp,-32
    80001ea6:	ec06                	sd	ra,24(sp)
    80001ea8:	e822                	sd	s0,16(sp)
    80001eaa:	e426                	sd	s1,8(sp)
    80001eac:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001eae:	a3dff0ef          	jal	800018ea <myproc>
    80001eb2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001eb4:	d41fe0ef          	jal	80000bf4 <acquire>
  p->state = RUNNABLE;
    80001eb8:	478d                	li	a5,3
    80001eba:	cc9c                	sw	a5,24(s1)
  sched();
    80001ebc:	f2fff0ef          	jal	80001dea <sched>
  release(&p->lock);
    80001ec0:	8526                	mv	a0,s1
    80001ec2:	dcbfe0ef          	jal	80000c8c <release>
}
    80001ec6:	60e2                	ld	ra,24(sp)
    80001ec8:	6442                	ld	s0,16(sp)
    80001eca:	64a2                	ld	s1,8(sp)
    80001ecc:	6105                	addi	sp,sp,32
    80001ece:	8082                	ret

0000000080001ed0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001ed0:	7179                	addi	sp,sp,-48
    80001ed2:	f406                	sd	ra,40(sp)
    80001ed4:	f022                	sd	s0,32(sp)
    80001ed6:	ec26                	sd	s1,24(sp)
    80001ed8:	e84a                	sd	s2,16(sp)
    80001eda:	e44e                	sd	s3,8(sp)
    80001edc:	1800                	addi	s0,sp,48
    80001ede:	89aa                	mv	s3,a0
    80001ee0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ee2:	a09ff0ef          	jal	800018ea <myproc>
    80001ee6:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001ee8:	d0dfe0ef          	jal	80000bf4 <acquire>
  release(lk);
    80001eec:	854a                	mv	a0,s2
    80001eee:	d9ffe0ef          	jal	80000c8c <release>

  // Go to sleep.
  p->chan = chan;
    80001ef2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001ef6:	4789                	li	a5,2
    80001ef8:	cc9c                	sw	a5,24(s1)

  sched();
    80001efa:	ef1ff0ef          	jal	80001dea <sched>

  // Tidy up.
  p->chan = 0;
    80001efe:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001f02:	8526                	mv	a0,s1
    80001f04:	d89fe0ef          	jal	80000c8c <release>
  acquire(lk);
    80001f08:	854a                	mv	a0,s2
    80001f0a:	cebfe0ef          	jal	80000bf4 <acquire>
}
    80001f0e:	70a2                	ld	ra,40(sp)
    80001f10:	7402                	ld	s0,32(sp)
    80001f12:	64e2                	ld	s1,24(sp)
    80001f14:	6942                	ld	s2,16(sp)
    80001f16:	69a2                	ld	s3,8(sp)
    80001f18:	6145                	addi	sp,sp,48
    80001f1a:	8082                	ret

0000000080001f1c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001f1c:	7139                	addi	sp,sp,-64
    80001f1e:	fc06                	sd	ra,56(sp)
    80001f20:	f822                	sd	s0,48(sp)
    80001f22:	f426                	sd	s1,40(sp)
    80001f24:	f04a                	sd	s2,32(sp)
    80001f26:	ec4e                	sd	s3,24(sp)
    80001f28:	e852                	sd	s4,16(sp)
    80001f2a:	e456                	sd	s5,8(sp)
    80001f2c:	0080                	addi	s0,sp,64
    80001f2e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001f30:	0000e497          	auipc	s1,0xe
    80001f34:	f6048493          	addi	s1,s1,-160 # 8000fe90 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001f38:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001f3a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f3c:	00014917          	auipc	s2,0x14
    80001f40:	d5490913          	addi	s2,s2,-684 # 80015c90 <tickslock>
    80001f44:	a801                	j	80001f54 <wakeup+0x38>
      }
      release(&p->lock);
    80001f46:	8526                	mv	a0,s1
    80001f48:	d45fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f4c:	17848493          	addi	s1,s1,376
    80001f50:	03248263          	beq	s1,s2,80001f74 <wakeup+0x58>
    if(p != myproc()){
    80001f54:	997ff0ef          	jal	800018ea <myproc>
    80001f58:	fea48ae3          	beq	s1,a0,80001f4c <wakeup+0x30>
      acquire(&p->lock);
    80001f5c:	8526                	mv	a0,s1
    80001f5e:	c97fe0ef          	jal	80000bf4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001f62:	4c9c                	lw	a5,24(s1)
    80001f64:	ff3791e3          	bne	a5,s3,80001f46 <wakeup+0x2a>
    80001f68:	709c                	ld	a5,32(s1)
    80001f6a:	fd479ee3          	bne	a5,s4,80001f46 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001f6e:	0154ac23          	sw	s5,24(s1)
    80001f72:	bfd1                	j	80001f46 <wakeup+0x2a>
    }
  }
}
    80001f74:	70e2                	ld	ra,56(sp)
    80001f76:	7442                	ld	s0,48(sp)
    80001f78:	74a2                	ld	s1,40(sp)
    80001f7a:	7902                	ld	s2,32(sp)
    80001f7c:	69e2                	ld	s3,24(sp)
    80001f7e:	6a42                	ld	s4,16(sp)
    80001f80:	6aa2                	ld	s5,8(sp)
    80001f82:	6121                	addi	sp,sp,64
    80001f84:	8082                	ret

0000000080001f86 <reparent>:
{
    80001f86:	7179                	addi	sp,sp,-48
    80001f88:	f406                	sd	ra,40(sp)
    80001f8a:	f022                	sd	s0,32(sp)
    80001f8c:	ec26                	sd	s1,24(sp)
    80001f8e:	e84a                	sd	s2,16(sp)
    80001f90:	e44e                	sd	s3,8(sp)
    80001f92:	e052                	sd	s4,0(sp)
    80001f94:	1800                	addi	s0,sp,48
    80001f96:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f98:	0000e497          	auipc	s1,0xe
    80001f9c:	ef848493          	addi	s1,s1,-264 # 8000fe90 <proc>
      pp->parent = initproc;
    80001fa0:	00006a17          	auipc	s4,0x6
    80001fa4:	988a0a13          	addi	s4,s4,-1656 # 80007928 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fa8:	00014997          	auipc	s3,0x14
    80001fac:	ce898993          	addi	s3,s3,-792 # 80015c90 <tickslock>
    80001fb0:	a029                	j	80001fba <reparent+0x34>
    80001fb2:	17848493          	addi	s1,s1,376
    80001fb6:	01348b63          	beq	s1,s3,80001fcc <reparent+0x46>
    if(pp->parent == p){
    80001fba:	7c9c                	ld	a5,56(s1)
    80001fbc:	ff279be3          	bne	a5,s2,80001fb2 <reparent+0x2c>
      pp->parent = initproc;
    80001fc0:	000a3503          	ld	a0,0(s4)
    80001fc4:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001fc6:	f57ff0ef          	jal	80001f1c <wakeup>
    80001fca:	b7e5                	j	80001fb2 <reparent+0x2c>
}
    80001fcc:	70a2                	ld	ra,40(sp)
    80001fce:	7402                	ld	s0,32(sp)
    80001fd0:	64e2                	ld	s1,24(sp)
    80001fd2:	6942                	ld	s2,16(sp)
    80001fd4:	69a2                	ld	s3,8(sp)
    80001fd6:	6a02                	ld	s4,0(sp)
    80001fd8:	6145                	addi	sp,sp,48
    80001fda:	8082                	ret

0000000080001fdc <exit>:
{
    80001fdc:	7179                	addi	sp,sp,-48
    80001fde:	f406                	sd	ra,40(sp)
    80001fe0:	f022                	sd	s0,32(sp)
    80001fe2:	ec26                	sd	s1,24(sp)
    80001fe4:	e84a                	sd	s2,16(sp)
    80001fe6:	e44e                	sd	s3,8(sp)
    80001fe8:	e052                	sd	s4,0(sp)
    80001fea:	1800                	addi	s0,sp,48
    80001fec:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001fee:	8fdff0ef          	jal	800018ea <myproc>
    80001ff2:	89aa                	mv	s3,a0
  if(p == initproc)
    80001ff4:	00006797          	auipc	a5,0x6
    80001ff8:	9347b783          	ld	a5,-1740(a5) # 80007928 <initproc>
    80001ffc:	0d050493          	addi	s1,a0,208
    80002000:	15050913          	addi	s2,a0,336
    80002004:	00a79f63          	bne	a5,a0,80002022 <exit+0x46>
    panic("init exiting");
    80002008:	00005517          	auipc	a0,0x5
    8000200c:	2a850513          	addi	a0,a0,680 # 800072b0 <etext+0x2b0>
    80002010:	f84fe0ef          	jal	80000794 <panic>
      fileclose(f);
    80002014:	67f010ef          	jal	80003e92 <fileclose>
      p->ofile[fd] = 0;
    80002018:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000201c:	04a1                	addi	s1,s1,8
    8000201e:	01248563          	beq	s1,s2,80002028 <exit+0x4c>
    if(p->ofile[fd]){
    80002022:	6088                	ld	a0,0(s1)
    80002024:	f965                	bnez	a0,80002014 <exit+0x38>
    80002026:	bfdd                	j	8000201c <exit+0x40>
  begin_op();
    80002028:	251010ef          	jal	80003a78 <begin_op>
  iput(p->cwd);
    8000202c:	1509b503          	ld	a0,336(s3)
    80002030:	334010ef          	jal	80003364 <iput>
  end_op();
    80002034:	2af010ef          	jal	80003ae2 <end_op>
  p->cwd = 0;
    80002038:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000203c:	0000e497          	auipc	s1,0xe
    80002040:	a3c48493          	addi	s1,s1,-1476 # 8000fa78 <wait_lock>
    80002044:	8526                	mv	a0,s1
    80002046:	baffe0ef          	jal	80000bf4 <acquire>
  reparent(p);
    8000204a:	854e                	mv	a0,s3
    8000204c:	f3bff0ef          	jal	80001f86 <reparent>
  wakeup(p->parent);
    80002050:	0389b503          	ld	a0,56(s3)
    80002054:	ec9ff0ef          	jal	80001f1c <wakeup>
  acquire(&p->lock);
    80002058:	854e                	mv	a0,s3
    8000205a:	b9bfe0ef          	jal	80000bf4 <acquire>
  p->xstate = status;
    8000205e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002062:	4795                	li	a5,5
    80002064:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002068:	8526                	mv	a0,s1
    8000206a:	c23fe0ef          	jal	80000c8c <release>
  sched();
    8000206e:	d7dff0ef          	jal	80001dea <sched>
  panic("zombie exit");
    80002072:	00005517          	auipc	a0,0x5
    80002076:	24e50513          	addi	a0,a0,590 # 800072c0 <etext+0x2c0>
    8000207a:	f1afe0ef          	jal	80000794 <panic>

000000008000207e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000207e:	7179                	addi	sp,sp,-48
    80002080:	f406                	sd	ra,40(sp)
    80002082:	f022                	sd	s0,32(sp)
    80002084:	ec26                	sd	s1,24(sp)
    80002086:	e84a                	sd	s2,16(sp)
    80002088:	e44e                	sd	s3,8(sp)
    8000208a:	1800                	addi	s0,sp,48
    8000208c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000208e:	0000e497          	auipc	s1,0xe
    80002092:	e0248493          	addi	s1,s1,-510 # 8000fe90 <proc>
    80002096:	00014997          	auipc	s3,0x14
    8000209a:	bfa98993          	addi	s3,s3,-1030 # 80015c90 <tickslock>
    acquire(&p->lock);
    8000209e:	8526                	mv	a0,s1
    800020a0:	b55fe0ef          	jal	80000bf4 <acquire>
    if(p->pid == pid){
    800020a4:	589c                	lw	a5,48(s1)
    800020a6:	01278b63          	beq	a5,s2,800020bc <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800020aa:	8526                	mv	a0,s1
    800020ac:	be1fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800020b0:	17848493          	addi	s1,s1,376
    800020b4:	ff3495e3          	bne	s1,s3,8000209e <kill+0x20>
  }
  return -1;
    800020b8:	557d                	li	a0,-1
    800020ba:	a819                	j	800020d0 <kill+0x52>
      p->killed = 1;
    800020bc:	4785                	li	a5,1
    800020be:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800020c0:	4c98                	lw	a4,24(s1)
    800020c2:	4789                	li	a5,2
    800020c4:	00f70d63          	beq	a4,a5,800020de <kill+0x60>
      release(&p->lock);
    800020c8:	8526                	mv	a0,s1
    800020ca:	bc3fe0ef          	jal	80000c8c <release>
      return 0;
    800020ce:	4501                	li	a0,0
}
    800020d0:	70a2                	ld	ra,40(sp)
    800020d2:	7402                	ld	s0,32(sp)
    800020d4:	64e2                	ld	s1,24(sp)
    800020d6:	6942                	ld	s2,16(sp)
    800020d8:	69a2                	ld	s3,8(sp)
    800020da:	6145                	addi	sp,sp,48
    800020dc:	8082                	ret
        p->state = RUNNABLE;
    800020de:	478d                	li	a5,3
    800020e0:	cc9c                	sw	a5,24(s1)
    800020e2:	b7dd                	j	800020c8 <kill+0x4a>

00000000800020e4 <setkilled>:

void
setkilled(struct proc *p)
{
    800020e4:	1101                	addi	sp,sp,-32
    800020e6:	ec06                	sd	ra,24(sp)
    800020e8:	e822                	sd	s0,16(sp)
    800020ea:	e426                	sd	s1,8(sp)
    800020ec:	1000                	addi	s0,sp,32
    800020ee:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020f0:	b05fe0ef          	jal	80000bf4 <acquire>
  p->killed = 1;
    800020f4:	4785                	li	a5,1
    800020f6:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800020f8:	8526                	mv	a0,s1
    800020fa:	b93fe0ef          	jal	80000c8c <release>
}
    800020fe:	60e2                	ld	ra,24(sp)
    80002100:	6442                	ld	s0,16(sp)
    80002102:	64a2                	ld	s1,8(sp)
    80002104:	6105                	addi	sp,sp,32
    80002106:	8082                	ret

0000000080002108 <killed>:

int
killed(struct proc *p)
{
    80002108:	1101                	addi	sp,sp,-32
    8000210a:	ec06                	sd	ra,24(sp)
    8000210c:	e822                	sd	s0,16(sp)
    8000210e:	e426                	sd	s1,8(sp)
    80002110:	e04a                	sd	s2,0(sp)
    80002112:	1000                	addi	s0,sp,32
    80002114:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002116:	adffe0ef          	jal	80000bf4 <acquire>
  k = p->killed;
    8000211a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000211e:	8526                	mv	a0,s1
    80002120:	b6dfe0ef          	jal	80000c8c <release>
  return k;
}
    80002124:	854a                	mv	a0,s2
    80002126:	60e2                	ld	ra,24(sp)
    80002128:	6442                	ld	s0,16(sp)
    8000212a:	64a2                	ld	s1,8(sp)
    8000212c:	6902                	ld	s2,0(sp)
    8000212e:	6105                	addi	sp,sp,32
    80002130:	8082                	ret

0000000080002132 <wait>:
{
    80002132:	715d                	addi	sp,sp,-80
    80002134:	e486                	sd	ra,72(sp)
    80002136:	e0a2                	sd	s0,64(sp)
    80002138:	fc26                	sd	s1,56(sp)
    8000213a:	f84a                	sd	s2,48(sp)
    8000213c:	f44e                	sd	s3,40(sp)
    8000213e:	f052                	sd	s4,32(sp)
    80002140:	ec56                	sd	s5,24(sp)
    80002142:	e85a                	sd	s6,16(sp)
    80002144:	e45e                	sd	s7,8(sp)
    80002146:	e062                	sd	s8,0(sp)
    80002148:	0880                	addi	s0,sp,80
    8000214a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000214c:	f9eff0ef          	jal	800018ea <myproc>
    80002150:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002152:	0000e517          	auipc	a0,0xe
    80002156:	92650513          	addi	a0,a0,-1754 # 8000fa78 <wait_lock>
    8000215a:	a9bfe0ef          	jal	80000bf4 <acquire>
    havekids = 0;
    8000215e:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002160:	4a15                	li	s4,5
        havekids = 1;
    80002162:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002164:	00014997          	auipc	s3,0x14
    80002168:	b2c98993          	addi	s3,s3,-1236 # 80015c90 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000216c:	0000ec17          	auipc	s8,0xe
    80002170:	90cc0c13          	addi	s8,s8,-1780 # 8000fa78 <wait_lock>
    80002174:	a871                	j	80002210 <wait+0xde>
          pid = pp->pid;
    80002176:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000217a:	000b0c63          	beqz	s6,80002192 <wait+0x60>
    8000217e:	4691                	li	a3,4
    80002180:	02c48613          	addi	a2,s1,44
    80002184:	85da                	mv	a1,s6
    80002186:	05093503          	ld	a0,80(s2)
    8000218a:	bc8ff0ef          	jal	80001552 <copyout>
    8000218e:	02054b63          	bltz	a0,800021c4 <wait+0x92>
          freeproc(pp);
    80002192:	8526                	mv	a0,s1
    80002194:	8c9ff0ef          	jal	80001a5c <freeproc>
          release(&pp->lock);
    80002198:	8526                	mv	a0,s1
    8000219a:	af3fe0ef          	jal	80000c8c <release>
          release(&wait_lock);
    8000219e:	0000e517          	auipc	a0,0xe
    800021a2:	8da50513          	addi	a0,a0,-1830 # 8000fa78 <wait_lock>
    800021a6:	ae7fe0ef          	jal	80000c8c <release>
}
    800021aa:	854e                	mv	a0,s3
    800021ac:	60a6                	ld	ra,72(sp)
    800021ae:	6406                	ld	s0,64(sp)
    800021b0:	74e2                	ld	s1,56(sp)
    800021b2:	7942                	ld	s2,48(sp)
    800021b4:	79a2                	ld	s3,40(sp)
    800021b6:	7a02                	ld	s4,32(sp)
    800021b8:	6ae2                	ld	s5,24(sp)
    800021ba:	6b42                	ld	s6,16(sp)
    800021bc:	6ba2                	ld	s7,8(sp)
    800021be:	6c02                	ld	s8,0(sp)
    800021c0:	6161                	addi	sp,sp,80
    800021c2:	8082                	ret
            release(&pp->lock);
    800021c4:	8526                	mv	a0,s1
    800021c6:	ac7fe0ef          	jal	80000c8c <release>
            release(&wait_lock);
    800021ca:	0000e517          	auipc	a0,0xe
    800021ce:	8ae50513          	addi	a0,a0,-1874 # 8000fa78 <wait_lock>
    800021d2:	abbfe0ef          	jal	80000c8c <release>
            return -1;
    800021d6:	59fd                	li	s3,-1
    800021d8:	bfc9                	j	800021aa <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021da:	17848493          	addi	s1,s1,376
    800021de:	03348063          	beq	s1,s3,800021fe <wait+0xcc>
      if(pp->parent == p){
    800021e2:	7c9c                	ld	a5,56(s1)
    800021e4:	ff279be3          	bne	a5,s2,800021da <wait+0xa8>
        acquire(&pp->lock);
    800021e8:	8526                	mv	a0,s1
    800021ea:	a0bfe0ef          	jal	80000bf4 <acquire>
        if(pp->state == ZOMBIE){
    800021ee:	4c9c                	lw	a5,24(s1)
    800021f0:	f94783e3          	beq	a5,s4,80002176 <wait+0x44>
        release(&pp->lock);
    800021f4:	8526                	mv	a0,s1
    800021f6:	a97fe0ef          	jal	80000c8c <release>
        havekids = 1;
    800021fa:	8756                	mv	a4,s5
    800021fc:	bff9                	j	800021da <wait+0xa8>
    if(!havekids || killed(p)){
    800021fe:	cf19                	beqz	a4,8000221c <wait+0xea>
    80002200:	854a                	mv	a0,s2
    80002202:	f07ff0ef          	jal	80002108 <killed>
    80002206:	e919                	bnez	a0,8000221c <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002208:	85e2                	mv	a1,s8
    8000220a:	854a                	mv	a0,s2
    8000220c:	cc5ff0ef          	jal	80001ed0 <sleep>
    havekids = 0;
    80002210:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002212:	0000e497          	auipc	s1,0xe
    80002216:	c7e48493          	addi	s1,s1,-898 # 8000fe90 <proc>
    8000221a:	b7e1                	j	800021e2 <wait+0xb0>
      release(&wait_lock);
    8000221c:	0000e517          	auipc	a0,0xe
    80002220:	85c50513          	addi	a0,a0,-1956 # 8000fa78 <wait_lock>
    80002224:	a69fe0ef          	jal	80000c8c <release>
      return -1;
    80002228:	59fd                	li	s3,-1
    8000222a:	b741                	j	800021aa <wait+0x78>

000000008000222c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000222c:	7179                	addi	sp,sp,-48
    8000222e:	f406                	sd	ra,40(sp)
    80002230:	f022                	sd	s0,32(sp)
    80002232:	ec26                	sd	s1,24(sp)
    80002234:	e84a                	sd	s2,16(sp)
    80002236:	e44e                	sd	s3,8(sp)
    80002238:	e052                	sd	s4,0(sp)
    8000223a:	1800                	addi	s0,sp,48
    8000223c:	84aa                	mv	s1,a0
    8000223e:	892e                	mv	s2,a1
    80002240:	89b2                	mv	s3,a2
    80002242:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002244:	ea6ff0ef          	jal	800018ea <myproc>
  if(user_dst){
    80002248:	cc99                	beqz	s1,80002266 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000224a:	86d2                	mv	a3,s4
    8000224c:	864e                	mv	a2,s3
    8000224e:	85ca                	mv	a1,s2
    80002250:	6928                	ld	a0,80(a0)
    80002252:	b00ff0ef          	jal	80001552 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002256:	70a2                	ld	ra,40(sp)
    80002258:	7402                	ld	s0,32(sp)
    8000225a:	64e2                	ld	s1,24(sp)
    8000225c:	6942                	ld	s2,16(sp)
    8000225e:	69a2                	ld	s3,8(sp)
    80002260:	6a02                	ld	s4,0(sp)
    80002262:	6145                	addi	sp,sp,48
    80002264:	8082                	ret
    memmove((char *)dst, src, len);
    80002266:	000a061b          	sext.w	a2,s4
    8000226a:	85ce                	mv	a1,s3
    8000226c:	854a                	mv	a0,s2
    8000226e:	ab7fe0ef          	jal	80000d24 <memmove>
    return 0;
    80002272:	8526                	mv	a0,s1
    80002274:	b7cd                	j	80002256 <either_copyout+0x2a>

0000000080002276 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002276:	7179                	addi	sp,sp,-48
    80002278:	f406                	sd	ra,40(sp)
    8000227a:	f022                	sd	s0,32(sp)
    8000227c:	ec26                	sd	s1,24(sp)
    8000227e:	e84a                	sd	s2,16(sp)
    80002280:	e44e                	sd	s3,8(sp)
    80002282:	e052                	sd	s4,0(sp)
    80002284:	1800                	addi	s0,sp,48
    80002286:	892a                	mv	s2,a0
    80002288:	84ae                	mv	s1,a1
    8000228a:	89b2                	mv	s3,a2
    8000228c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000228e:	e5cff0ef          	jal	800018ea <myproc>
  if(user_src){
    80002292:	cc99                	beqz	s1,800022b0 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002294:	86d2                	mv	a3,s4
    80002296:	864e                	mv	a2,s3
    80002298:	85ca                	mv	a1,s2
    8000229a:	6928                	ld	a0,80(a0)
    8000229c:	b8cff0ef          	jal	80001628 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800022a0:	70a2                	ld	ra,40(sp)
    800022a2:	7402                	ld	s0,32(sp)
    800022a4:	64e2                	ld	s1,24(sp)
    800022a6:	6942                	ld	s2,16(sp)
    800022a8:	69a2                	ld	s3,8(sp)
    800022aa:	6a02                	ld	s4,0(sp)
    800022ac:	6145                	addi	sp,sp,48
    800022ae:	8082                	ret
    memmove(dst, (char*)src, len);
    800022b0:	000a061b          	sext.w	a2,s4
    800022b4:	85ce                	mv	a1,s3
    800022b6:	854a                	mv	a0,s2
    800022b8:	a6dfe0ef          	jal	80000d24 <memmove>
    return 0;
    800022bc:	8526                	mv	a0,s1
    800022be:	b7cd                	j	800022a0 <either_copyin+0x2a>

00000000800022c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800022c0:	715d                	addi	sp,sp,-80
    800022c2:	e486                	sd	ra,72(sp)
    800022c4:	e0a2                	sd	s0,64(sp)
    800022c6:	fc26                	sd	s1,56(sp)
    800022c8:	f84a                	sd	s2,48(sp)
    800022ca:	f44e                	sd	s3,40(sp)
    800022cc:	f052                	sd	s4,32(sp)
    800022ce:	ec56                	sd	s5,24(sp)
    800022d0:	e85a                	sd	s6,16(sp)
    800022d2:	e45e                	sd	s7,8(sp)
    800022d4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800022d6:	00005517          	auipc	a0,0x5
    800022da:	da250513          	addi	a0,a0,-606 # 80007078 <etext+0x78>
    800022de:	9e4fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800022e2:	0000e497          	auipc	s1,0xe
    800022e6:	d0648493          	addi	s1,s1,-762 # 8000ffe8 <proc+0x158>
    800022ea:	00014917          	auipc	s2,0x14
    800022ee:	afe90913          	addi	s2,s2,-1282 # 80015de8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022f2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800022f4:	00005997          	auipc	s3,0x5
    800022f8:	fdc98993          	addi	s3,s3,-36 # 800072d0 <etext+0x2d0>
    printf("%d %s %s", p->pid, state, p->name);
    800022fc:	00005a97          	auipc	s5,0x5
    80002300:	fdca8a93          	addi	s5,s5,-36 # 800072d8 <etext+0x2d8>
    printf("\n");
    80002304:	00005a17          	auipc	s4,0x5
    80002308:	d74a0a13          	addi	s4,s4,-652 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000230c:	00005b97          	auipc	s7,0x5
    80002310:	4acb8b93          	addi	s7,s7,1196 # 800077b8 <states.0>
    80002314:	a829                	j	8000232e <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002316:	ed86a583          	lw	a1,-296(a3)
    8000231a:	8556                	mv	a0,s5
    8000231c:	9a6fe0ef          	jal	800004c2 <printf>
    printf("\n");
    80002320:	8552                	mv	a0,s4
    80002322:	9a0fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002326:	17848493          	addi	s1,s1,376
    8000232a:	03248263          	beq	s1,s2,8000234e <procdump+0x8e>
    if(p->state == UNUSED)
    8000232e:	86a6                	mv	a3,s1
    80002330:	ec04a783          	lw	a5,-320(s1)
    80002334:	dbed                	beqz	a5,80002326 <procdump+0x66>
      state = "???";
    80002336:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002338:	fcfb6fe3          	bltu	s6,a5,80002316 <procdump+0x56>
    8000233c:	02079713          	slli	a4,a5,0x20
    80002340:	01d75793          	srli	a5,a4,0x1d
    80002344:	97de                	add	a5,a5,s7
    80002346:	6390                	ld	a2,0(a5)
    80002348:	f679                	bnez	a2,80002316 <procdump+0x56>
      state = "???";
    8000234a:	864e                	mv	a2,s3
    8000234c:	b7e9                	j	80002316 <procdump+0x56>
  }
}
    8000234e:	60a6                	ld	ra,72(sp)
    80002350:	6406                	ld	s0,64(sp)
    80002352:	74e2                	ld	s1,56(sp)
    80002354:	7942                	ld	s2,48(sp)
    80002356:	79a2                	ld	s3,40(sp)
    80002358:	7a02                	ld	s4,32(sp)
    8000235a:	6ae2                	ld	s5,24(sp)
    8000235c:	6b42                	ld	s6,16(sp)
    8000235e:	6ba2                	ld	s7,8(sp)
    80002360:	6161                	addi	sp,sp,80
    80002362:	8082                	ret

0000000080002364 <swtch>:
    80002364:	00153023          	sd	ra,0(a0)
    80002368:	00253423          	sd	sp,8(a0)
    8000236c:	e900                	sd	s0,16(a0)
    8000236e:	ed04                	sd	s1,24(a0)
    80002370:	03253023          	sd	s2,32(a0)
    80002374:	03353423          	sd	s3,40(a0)
    80002378:	03453823          	sd	s4,48(a0)
    8000237c:	03553c23          	sd	s5,56(a0)
    80002380:	05653023          	sd	s6,64(a0)
    80002384:	05753423          	sd	s7,72(a0)
    80002388:	05853823          	sd	s8,80(a0)
    8000238c:	05953c23          	sd	s9,88(a0)
    80002390:	07a53023          	sd	s10,96(a0)
    80002394:	07b53423          	sd	s11,104(a0)
    80002398:	0005b083          	ld	ra,0(a1)
    8000239c:	0085b103          	ld	sp,8(a1)
    800023a0:	6980                	ld	s0,16(a1)
    800023a2:	6d84                	ld	s1,24(a1)
    800023a4:	0205b903          	ld	s2,32(a1)
    800023a8:	0285b983          	ld	s3,40(a1)
    800023ac:	0305ba03          	ld	s4,48(a1)
    800023b0:	0385ba83          	ld	s5,56(a1)
    800023b4:	0405bb03          	ld	s6,64(a1)
    800023b8:	0485bb83          	ld	s7,72(a1)
    800023bc:	0505bc03          	ld	s8,80(a1)
    800023c0:	0585bc83          	ld	s9,88(a1)
    800023c4:	0605bd03          	ld	s10,96(a1)
    800023c8:	0685bd83          	ld	s11,104(a1)
    800023cc:	8082                	ret

00000000800023ce <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800023ce:	1141                	addi	sp,sp,-16
    800023d0:	e406                	sd	ra,8(sp)
    800023d2:	e022                	sd	s0,0(sp)
    800023d4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800023d6:	00005597          	auipc	a1,0x5
    800023da:	f4258593          	addi	a1,a1,-190 # 80007318 <etext+0x318>
    800023de:	00014517          	auipc	a0,0x14
    800023e2:	8b250513          	addi	a0,a0,-1870 # 80015c90 <tickslock>
    800023e6:	f8efe0ef          	jal	80000b74 <initlock>
}
    800023ea:	60a2                	ld	ra,8(sp)
    800023ec:	6402                	ld	s0,0(sp)
    800023ee:	0141                	addi	sp,sp,16
    800023f0:	8082                	ret

00000000800023f2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800023f2:	1141                	addi	sp,sp,-16
    800023f4:	e422                	sd	s0,8(sp)
    800023f6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800023f8:	00003797          	auipc	a5,0x3
    800023fc:	e0878793          	addi	a5,a5,-504 # 80005200 <kernelvec>
    80002400:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002404:	6422                	ld	s0,8(sp)
    80002406:	0141                	addi	sp,sp,16
    80002408:	8082                	ret

000000008000240a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000240a:	1141                	addi	sp,sp,-16
    8000240c:	e406                	sd	ra,8(sp)
    8000240e:	e022                	sd	s0,0(sp)
    80002410:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002412:	cd8ff0ef          	jal	800018ea <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002416:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000241a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000241c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002420:	00004697          	auipc	a3,0x4
    80002424:	be068693          	addi	a3,a3,-1056 # 80006000 <_trampoline>
    80002428:	00004717          	auipc	a4,0x4
    8000242c:	bd870713          	addi	a4,a4,-1064 # 80006000 <_trampoline>
    80002430:	8f15                	sub	a4,a4,a3
    80002432:	040007b7          	lui	a5,0x4000
    80002436:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002438:	07b2                	slli	a5,a5,0xc
    8000243a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000243c:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002440:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002442:	18002673          	csrr	a2,satp
    80002446:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002448:	6d30                	ld	a2,88(a0)
    8000244a:	6138                	ld	a4,64(a0)
    8000244c:	6585                	lui	a1,0x1
    8000244e:	972e                	add	a4,a4,a1
    80002450:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002452:	6d38                	ld	a4,88(a0)
    80002454:	00000617          	auipc	a2,0x0
    80002458:	11060613          	addi	a2,a2,272 # 80002564 <usertrap>
    8000245c:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000245e:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002460:	8612                	mv	a2,tp
    80002462:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002464:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002468:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000246c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002470:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002474:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002476:	6f18                	ld	a4,24(a4)
    80002478:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000247c:	6928                	ld	a0,80(a0)
    8000247e:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002480:	00004717          	auipc	a4,0x4
    80002484:	c1c70713          	addi	a4,a4,-996 # 8000609c <userret>
    80002488:	8f15                	sub	a4,a4,a3
    8000248a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000248c:	577d                	li	a4,-1
    8000248e:	177e                	slli	a4,a4,0x3f
    80002490:	8d59                	or	a0,a0,a4
    80002492:	9782                	jalr	a5
}
    80002494:	60a2                	ld	ra,8(sp)
    80002496:	6402                	ld	s0,0(sp)
    80002498:	0141                	addi	sp,sp,16
    8000249a:	8082                	ret

000000008000249c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000249c:	1101                	addi	sp,sp,-32
    8000249e:	ec06                	sd	ra,24(sp)
    800024a0:	e822                	sd	s0,16(sp)
    800024a2:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800024a4:	c1aff0ef          	jal	800018be <cpuid>
    800024a8:	cd11                	beqz	a0,800024c4 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800024aa:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800024ae:	000f4737          	lui	a4,0xf4
    800024b2:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800024b6:	97ba                	add	a5,a5,a4
  asm volatile("csrw stimecmp, %0" : : "r" (x));
    800024b8:	14d79073          	csrw	stimecmp,a5
}
    800024bc:	60e2                	ld	ra,24(sp)
    800024be:	6442                	ld	s0,16(sp)
    800024c0:	6105                	addi	sp,sp,32
    800024c2:	8082                	ret
    800024c4:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800024c6:	00013497          	auipc	s1,0x13
    800024ca:	7ca48493          	addi	s1,s1,1994 # 80015c90 <tickslock>
    800024ce:	8526                	mv	a0,s1
    800024d0:	f24fe0ef          	jal	80000bf4 <acquire>
    ticks++;
    800024d4:	00005517          	auipc	a0,0x5
    800024d8:	45c50513          	addi	a0,a0,1116 # 80007930 <ticks>
    800024dc:	411c                	lw	a5,0(a0)
    800024de:	2785                	addiw	a5,a5,1
    800024e0:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800024e2:	a3bff0ef          	jal	80001f1c <wakeup>
    release(&tickslock);
    800024e6:	8526                	mv	a0,s1
    800024e8:	fa4fe0ef          	jal	80000c8c <release>
    800024ec:	64a2                	ld	s1,8(sp)
    800024ee:	bf75                	j	800024aa <clockintr+0xe>

00000000800024f0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800024f0:	1101                	addi	sp,sp,-32
    800024f2:	ec06                	sd	ra,24(sp)
    800024f4:	e822                	sd	s0,16(sp)
    800024f6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800024f8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800024fc:	57fd                	li	a5,-1
    800024fe:	17fe                	slli	a5,a5,0x3f
    80002500:	07a5                	addi	a5,a5,9
    80002502:	00f70c63          	beq	a4,a5,8000251a <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002506:	57fd                	li	a5,-1
    80002508:	17fe                	slli	a5,a5,0x3f
    8000250a:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000250c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000250e:	04f70763          	beq	a4,a5,8000255c <devintr+0x6c>
  }
}
    80002512:	60e2                	ld	ra,24(sp)
    80002514:	6442                	ld	s0,16(sp)
    80002516:	6105                	addi	sp,sp,32
    80002518:	8082                	ret
    8000251a:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000251c:	591020ef          	jal	800052ac <plic_claim>
    80002520:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002522:	47a9                	li	a5,10
    80002524:	00f50963          	beq	a0,a5,80002536 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80002528:	4785                	li	a5,1
    8000252a:	00f50963          	beq	a0,a5,8000253c <devintr+0x4c>
    return 1;
    8000252e:	4505                	li	a0,1
    } else if(irq){
    80002530:	e889                	bnez	s1,80002542 <devintr+0x52>
    80002532:	64a2                	ld	s1,8(sp)
    80002534:	bff9                	j	80002512 <devintr+0x22>
      uartintr();
    80002536:	cd0fe0ef          	jal	80000a06 <uartintr>
    if(irq)
    8000253a:	a819                	j	80002550 <devintr+0x60>
      virtio_disk_intr();
    8000253c:	236030ef          	jal	80005772 <virtio_disk_intr>
    if(irq)
    80002540:	a801                	j	80002550 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002542:	85a6                	mv	a1,s1
    80002544:	00005517          	auipc	a0,0x5
    80002548:	ddc50513          	addi	a0,a0,-548 # 80007320 <etext+0x320>
    8000254c:	f77fd0ef          	jal	800004c2 <printf>
      plic_complete(irq);
    80002550:	8526                	mv	a0,s1
    80002552:	57b020ef          	jal	800052cc <plic_complete>
    return 1;
    80002556:	4505                	li	a0,1
    80002558:	64a2                	ld	s1,8(sp)
    8000255a:	bf65                	j	80002512 <devintr+0x22>
    clockintr();
    8000255c:	f41ff0ef          	jal	8000249c <clockintr>
    return 2;
    80002560:	4509                	li	a0,2
    80002562:	bf45                	j	80002512 <devintr+0x22>

0000000080002564 <usertrap>:
{
    80002564:	1101                	addi	sp,sp,-32
    80002566:	ec06                	sd	ra,24(sp)
    80002568:	e822                	sd	s0,16(sp)
    8000256a:	e426                	sd	s1,8(sp)
    8000256c:	e04a                	sd	s2,0(sp)
    8000256e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002570:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002574:	1007f793          	andi	a5,a5,256
    80002578:	ef85                	bnez	a5,800025b0 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000257a:	00003797          	auipc	a5,0x3
    8000257e:	c8678793          	addi	a5,a5,-890 # 80005200 <kernelvec>
    80002582:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002586:	b64ff0ef          	jal	800018ea <myproc>
    8000258a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000258c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000258e:	14102773          	csrr	a4,sepc
    80002592:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002594:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002598:	47a1                	li	a5,8
    8000259a:	02f70163          	beq	a4,a5,800025bc <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    8000259e:	f53ff0ef          	jal	800024f0 <devintr>
    800025a2:	892a                	mv	s2,a0
    800025a4:	c135                	beqz	a0,80002608 <usertrap+0xa4>
  if(killed(p))
    800025a6:	8526                	mv	a0,s1
    800025a8:	b61ff0ef          	jal	80002108 <killed>
    800025ac:	cd1d                	beqz	a0,800025ea <usertrap+0x86>
    800025ae:	a81d                	j	800025e4 <usertrap+0x80>
    panic("usertrap: not from user mode");
    800025b0:	00005517          	auipc	a0,0x5
    800025b4:	d9050513          	addi	a0,a0,-624 # 80007340 <etext+0x340>
    800025b8:	9dcfe0ef          	jal	80000794 <panic>
    if(killed(p))
    800025bc:	b4dff0ef          	jal	80002108 <killed>
    800025c0:	e121                	bnez	a0,80002600 <usertrap+0x9c>
    p->trapframe->epc += 4;
    800025c2:	6cb8                	ld	a4,88(s1)
    800025c4:	6f1c                	ld	a5,24(a4)
    800025c6:	0791                	addi	a5,a5,4
    800025c8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025ca:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800025ce:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025d2:	10079073          	csrw	sstatus,a5
    syscall();
    800025d6:	248000ef          	jal	8000281e <syscall>
  if(killed(p))
    800025da:	8526                	mv	a0,s1
    800025dc:	b2dff0ef          	jal	80002108 <killed>
    800025e0:	c901                	beqz	a0,800025f0 <usertrap+0x8c>
    800025e2:	4901                	li	s2,0
    exit(-1);
    800025e4:	557d                	li	a0,-1
    800025e6:	9f7ff0ef          	jal	80001fdc <exit>
  if(which_dev == 2)
    800025ea:	4789                	li	a5,2
    800025ec:	04f90563          	beq	s2,a5,80002636 <usertrap+0xd2>
  usertrapret();
    800025f0:	e1bff0ef          	jal	8000240a <usertrapret>
}
    800025f4:	60e2                	ld	ra,24(sp)
    800025f6:	6442                	ld	s0,16(sp)
    800025f8:	64a2                	ld	s1,8(sp)
    800025fa:	6902                	ld	s2,0(sp)
    800025fc:	6105                	addi	sp,sp,32
    800025fe:	8082                	ret
      exit(-1);
    80002600:	557d                	li	a0,-1
    80002602:	9dbff0ef          	jal	80001fdc <exit>
    80002606:	bf75                	j	800025c2 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002608:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000260c:	5890                	lw	a2,48(s1)
    8000260e:	00005517          	auipc	a0,0x5
    80002612:	d5250513          	addi	a0,a0,-686 # 80007360 <etext+0x360>
    80002616:	eadfd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000261a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000261e:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002622:	00005517          	auipc	a0,0x5
    80002626:	d6e50513          	addi	a0,a0,-658 # 80007390 <etext+0x390>
    8000262a:	e99fd0ef          	jal	800004c2 <printf>
    setkilled(p);
    8000262e:	8526                	mv	a0,s1
    80002630:	ab5ff0ef          	jal	800020e4 <setkilled>
    80002634:	b75d                	j	800025da <usertrap+0x76>
    yield();
    80002636:	86fff0ef          	jal	80001ea4 <yield>
    8000263a:	bf5d                	j	800025f0 <usertrap+0x8c>

000000008000263c <kerneltrap>:
{
    8000263c:	7179                	addi	sp,sp,-48
    8000263e:	f406                	sd	ra,40(sp)
    80002640:	f022                	sd	s0,32(sp)
    80002642:	ec26                	sd	s1,24(sp)
    80002644:	e84a                	sd	s2,16(sp)
    80002646:	e44e                	sd	s3,8(sp)
    80002648:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000264a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000264e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002652:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002656:	1004f793          	andi	a5,s1,256
    8000265a:	c795                	beqz	a5,80002686 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000265c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002660:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002662:	eb85                	bnez	a5,80002692 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002664:	e8dff0ef          	jal	800024f0 <devintr>
    80002668:	c91d                	beqz	a0,8000269e <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    8000266a:	4789                	li	a5,2
    8000266c:	04f50a63          	beq	a0,a5,800026c0 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002670:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002674:	10049073          	csrw	sstatus,s1
}
    80002678:	70a2                	ld	ra,40(sp)
    8000267a:	7402                	ld	s0,32(sp)
    8000267c:	64e2                	ld	s1,24(sp)
    8000267e:	6942                	ld	s2,16(sp)
    80002680:	69a2                	ld	s3,8(sp)
    80002682:	6145                	addi	sp,sp,48
    80002684:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002686:	00005517          	auipc	a0,0x5
    8000268a:	d3250513          	addi	a0,a0,-718 # 800073b8 <etext+0x3b8>
    8000268e:	906fe0ef          	jal	80000794 <panic>
    panic("kerneltrap: interrupts enabled");
    80002692:	00005517          	auipc	a0,0x5
    80002696:	d4e50513          	addi	a0,a0,-690 # 800073e0 <etext+0x3e0>
    8000269a:	8fafe0ef          	jal	80000794 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000269e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800026a2:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800026a6:	85ce                	mv	a1,s3
    800026a8:	00005517          	auipc	a0,0x5
    800026ac:	d5850513          	addi	a0,a0,-680 # 80007400 <etext+0x400>
    800026b0:	e13fd0ef          	jal	800004c2 <printf>
    panic("kerneltrap");
    800026b4:	00005517          	auipc	a0,0x5
    800026b8:	d7450513          	addi	a0,a0,-652 # 80007428 <etext+0x428>
    800026bc:	8d8fe0ef          	jal	80000794 <panic>
  if(which_dev == 2 && myproc() != 0)
    800026c0:	a2aff0ef          	jal	800018ea <myproc>
    800026c4:	d555                	beqz	a0,80002670 <kerneltrap+0x34>
    yield();
    800026c6:	fdeff0ef          	jal	80001ea4 <yield>
    800026ca:	b75d                	j	80002670 <kerneltrap+0x34>

00000000800026cc <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800026cc:	1101                	addi	sp,sp,-32
    800026ce:	ec06                	sd	ra,24(sp)
    800026d0:	e822                	sd	s0,16(sp)
    800026d2:	e426                	sd	s1,8(sp)
    800026d4:	1000                	addi	s0,sp,32
    800026d6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800026d8:	a12ff0ef          	jal	800018ea <myproc>
  switch (n) {
    800026dc:	4795                	li	a5,5
    800026de:	0497e163          	bltu	a5,s1,80002720 <argraw+0x54>
    800026e2:	048a                	slli	s1,s1,0x2
    800026e4:	00005717          	auipc	a4,0x5
    800026e8:	10470713          	addi	a4,a4,260 # 800077e8 <states.0+0x30>
    800026ec:	94ba                	add	s1,s1,a4
    800026ee:	409c                	lw	a5,0(s1)
    800026f0:	97ba                	add	a5,a5,a4
    800026f2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800026f4:	6d3c                	ld	a5,88(a0)
    800026f6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800026f8:	60e2                	ld	ra,24(sp)
    800026fa:	6442                	ld	s0,16(sp)
    800026fc:	64a2                	ld	s1,8(sp)
    800026fe:	6105                	addi	sp,sp,32
    80002700:	8082                	ret
    return p->trapframe->a1;
    80002702:	6d3c                	ld	a5,88(a0)
    80002704:	7fa8                	ld	a0,120(a5)
    80002706:	bfcd                	j	800026f8 <argraw+0x2c>
    return p->trapframe->a2;
    80002708:	6d3c                	ld	a5,88(a0)
    8000270a:	63c8                	ld	a0,128(a5)
    8000270c:	b7f5                	j	800026f8 <argraw+0x2c>
    return p->trapframe->a3;
    8000270e:	6d3c                	ld	a5,88(a0)
    80002710:	67c8                	ld	a0,136(a5)
    80002712:	b7dd                	j	800026f8 <argraw+0x2c>
    return p->trapframe->a4;
    80002714:	6d3c                	ld	a5,88(a0)
    80002716:	6bc8                	ld	a0,144(a5)
    80002718:	b7c5                	j	800026f8 <argraw+0x2c>
    return p->trapframe->a5;
    8000271a:	6d3c                	ld	a5,88(a0)
    8000271c:	6fc8                	ld	a0,152(a5)
    8000271e:	bfe9                	j	800026f8 <argraw+0x2c>
  panic("argraw");
    80002720:	00005517          	auipc	a0,0x5
    80002724:	d1850513          	addi	a0,a0,-744 # 80007438 <etext+0x438>
    80002728:	86cfe0ef          	jal	80000794 <panic>

000000008000272c <fetchaddr>:
{
    8000272c:	1101                	addi	sp,sp,-32
    8000272e:	ec06                	sd	ra,24(sp)
    80002730:	e822                	sd	s0,16(sp)
    80002732:	e426                	sd	s1,8(sp)
    80002734:	e04a                	sd	s2,0(sp)
    80002736:	1000                	addi	s0,sp,32
    80002738:	84aa                	mv	s1,a0
    8000273a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000273c:	9aeff0ef          	jal	800018ea <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002740:	653c                	ld	a5,72(a0)
    80002742:	02f4f663          	bgeu	s1,a5,8000276e <fetchaddr+0x42>
    80002746:	00848713          	addi	a4,s1,8
    8000274a:	02e7e463          	bltu	a5,a4,80002772 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000274e:	46a1                	li	a3,8
    80002750:	8626                	mv	a2,s1
    80002752:	85ca                	mv	a1,s2
    80002754:	6928                	ld	a0,80(a0)
    80002756:	ed3fe0ef          	jal	80001628 <copyin>
    8000275a:	00a03533          	snez	a0,a0
    8000275e:	40a00533          	neg	a0,a0
}
    80002762:	60e2                	ld	ra,24(sp)
    80002764:	6442                	ld	s0,16(sp)
    80002766:	64a2                	ld	s1,8(sp)
    80002768:	6902                	ld	s2,0(sp)
    8000276a:	6105                	addi	sp,sp,32
    8000276c:	8082                	ret
    return -1;
    8000276e:	557d                	li	a0,-1
    80002770:	bfcd                	j	80002762 <fetchaddr+0x36>
    80002772:	557d                	li	a0,-1
    80002774:	b7fd                	j	80002762 <fetchaddr+0x36>

0000000080002776 <fetchstr>:
{
    80002776:	7179                	addi	sp,sp,-48
    80002778:	f406                	sd	ra,40(sp)
    8000277a:	f022                	sd	s0,32(sp)
    8000277c:	ec26                	sd	s1,24(sp)
    8000277e:	e84a                	sd	s2,16(sp)
    80002780:	e44e                	sd	s3,8(sp)
    80002782:	1800                	addi	s0,sp,48
    80002784:	892a                	mv	s2,a0
    80002786:	84ae                	mv	s1,a1
    80002788:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000278a:	960ff0ef          	jal	800018ea <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000278e:	86ce                	mv	a3,s3
    80002790:	864a                	mv	a2,s2
    80002792:	85a6                	mv	a1,s1
    80002794:	6928                	ld	a0,80(a0)
    80002796:	f19fe0ef          	jal	800016ae <copyinstr>
    8000279a:	00054c63          	bltz	a0,800027b2 <fetchstr+0x3c>
  return strlen(buf);
    8000279e:	8526                	mv	a0,s1
    800027a0:	e98fe0ef          	jal	80000e38 <strlen>
}
    800027a4:	70a2                	ld	ra,40(sp)
    800027a6:	7402                	ld	s0,32(sp)
    800027a8:	64e2                	ld	s1,24(sp)
    800027aa:	6942                	ld	s2,16(sp)
    800027ac:	69a2                	ld	s3,8(sp)
    800027ae:	6145                	addi	sp,sp,48
    800027b0:	8082                	ret
    return -1;
    800027b2:	557d                	li	a0,-1
    800027b4:	bfc5                	j	800027a4 <fetchstr+0x2e>

00000000800027b6 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800027b6:	1101                	addi	sp,sp,-32
    800027b8:	ec06                	sd	ra,24(sp)
    800027ba:	e822                	sd	s0,16(sp)
    800027bc:	e426                	sd	s1,8(sp)
    800027be:	1000                	addi	s0,sp,32
    800027c0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027c2:	f0bff0ef          	jal	800026cc <argraw>
    800027c6:	c088                	sw	a0,0(s1)
}
    800027c8:	60e2                	ld	ra,24(sp)
    800027ca:	6442                	ld	s0,16(sp)
    800027cc:	64a2                	ld	s1,8(sp)
    800027ce:	6105                	addi	sp,sp,32
    800027d0:	8082                	ret

00000000800027d2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800027d2:	1101                	addi	sp,sp,-32
    800027d4:	ec06                	sd	ra,24(sp)
    800027d6:	e822                	sd	s0,16(sp)
    800027d8:	e426                	sd	s1,8(sp)
    800027da:	1000                	addi	s0,sp,32
    800027dc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027de:	eefff0ef          	jal	800026cc <argraw>
    800027e2:	e088                	sd	a0,0(s1)
}
    800027e4:	60e2                	ld	ra,24(sp)
    800027e6:	6442                	ld	s0,16(sp)
    800027e8:	64a2                	ld	s1,8(sp)
    800027ea:	6105                	addi	sp,sp,32
    800027ec:	8082                	ret

00000000800027ee <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800027ee:	7179                	addi	sp,sp,-48
    800027f0:	f406                	sd	ra,40(sp)
    800027f2:	f022                	sd	s0,32(sp)
    800027f4:	ec26                	sd	s1,24(sp)
    800027f6:	e84a                	sd	s2,16(sp)
    800027f8:	1800                	addi	s0,sp,48
    800027fa:	84ae                	mv	s1,a1
    800027fc:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800027fe:	fd840593          	addi	a1,s0,-40
    80002802:	fd1ff0ef          	jal	800027d2 <argaddr>
  return fetchstr(addr, buf, max);
    80002806:	864a                	mv	a2,s2
    80002808:	85a6                	mv	a1,s1
    8000280a:	fd843503          	ld	a0,-40(s0)
    8000280e:	f69ff0ef          	jal	80002776 <fetchstr>
}
    80002812:	70a2                	ld	ra,40(sp)
    80002814:	7402                	ld	s0,32(sp)
    80002816:	64e2                	ld	s1,24(sp)
    80002818:	6942                	ld	s2,16(sp)
    8000281a:	6145                	addi	sp,sp,48
    8000281c:	8082                	ret

000000008000281e <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000281e:	1101                	addi	sp,sp,-32
    80002820:	ec06                	sd	ra,24(sp)
    80002822:	e822                	sd	s0,16(sp)
    80002824:	e426                	sd	s1,8(sp)
    80002826:	e04a                	sd	s2,0(sp)
    80002828:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000282a:	8c0ff0ef          	jal	800018ea <myproc>
    8000282e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002830:	05853903          	ld	s2,88(a0)
    80002834:	0a893783          	ld	a5,168(s2)
    80002838:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000283c:	37fd                	addiw	a5,a5,-1
    8000283e:	4751                	li	a4,20
    80002840:	00f76f63          	bltu	a4,a5,8000285e <syscall+0x40>
    80002844:	00369713          	slli	a4,a3,0x3
    80002848:	00005797          	auipc	a5,0x5
    8000284c:	fb878793          	addi	a5,a5,-72 # 80007800 <syscalls>
    80002850:	97ba                	add	a5,a5,a4
    80002852:	639c                	ld	a5,0(a5)
    80002854:	c789                	beqz	a5,8000285e <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002856:	9782                	jalr	a5
    80002858:	06a93823          	sd	a0,112(s2)
    8000285c:	a829                	j	80002876 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000285e:	15848613          	addi	a2,s1,344
    80002862:	588c                	lw	a1,48(s1)
    80002864:	00005517          	auipc	a0,0x5
    80002868:	bdc50513          	addi	a0,a0,-1060 # 80007440 <etext+0x440>
    8000286c:	c57fd0ef          	jal	800004c2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002870:	6cbc                	ld	a5,88(s1)
    80002872:	577d                	li	a4,-1
    80002874:	fbb8                	sd	a4,112(a5)
  }
}
    80002876:	60e2                	ld	ra,24(sp)
    80002878:	6442                	ld	s0,16(sp)
    8000287a:	64a2                	ld	s1,8(sp)
    8000287c:	6902                	ld	s2,0(sp)
    8000287e:	6105                	addi	sp,sp,32
    80002880:	8082                	ret

0000000080002882 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002882:	1101                	addi	sp,sp,-32
    80002884:	ec06                	sd	ra,24(sp)
    80002886:	e822                	sd	s0,16(sp)
    80002888:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000288a:	fec40593          	addi	a1,s0,-20
    8000288e:	4501                	li	a0,0
    80002890:	f27ff0ef          	jal	800027b6 <argint>
  exit(n);
    80002894:	fec42503          	lw	a0,-20(s0)
    80002898:	f44ff0ef          	jal	80001fdc <exit>
  return 0;  // not reached
}
    8000289c:	4501                	li	a0,0
    8000289e:	60e2                	ld	ra,24(sp)
    800028a0:	6442                	ld	s0,16(sp)
    800028a2:	6105                	addi	sp,sp,32
    800028a4:	8082                	ret

00000000800028a6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800028a6:	1141                	addi	sp,sp,-16
    800028a8:	e406                	sd	ra,8(sp)
    800028aa:	e022                	sd	s0,0(sp)
    800028ac:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800028ae:	83cff0ef          	jal	800018ea <myproc>
}
    800028b2:	5908                	lw	a0,48(a0)
    800028b4:	60a2                	ld	ra,8(sp)
    800028b6:	6402                	ld	s0,0(sp)
    800028b8:	0141                	addi	sp,sp,16
    800028ba:	8082                	ret

00000000800028bc <sys_fork>:

uint64
sys_fork(void)
{
    800028bc:	1141                	addi	sp,sp,-16
    800028be:	e406                	sd	ra,8(sp)
    800028c0:	e022                	sd	s0,0(sp)
    800028c2:	0800                	addi	s0,sp,16
  return fork();
    800028c4:	b4cff0ef          	jal	80001c10 <fork>
}
    800028c8:	60a2                	ld	ra,8(sp)
    800028ca:	6402                	ld	s0,0(sp)
    800028cc:	0141                	addi	sp,sp,16
    800028ce:	8082                	ret

00000000800028d0 <sys_wait>:

uint64
sys_wait(void)
{
    800028d0:	1101                	addi	sp,sp,-32
    800028d2:	ec06                	sd	ra,24(sp)
    800028d4:	e822                	sd	s0,16(sp)
    800028d6:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800028d8:	fe840593          	addi	a1,s0,-24
    800028dc:	4501                	li	a0,0
    800028de:	ef5ff0ef          	jal	800027d2 <argaddr>
  return wait(p);
    800028e2:	fe843503          	ld	a0,-24(s0)
    800028e6:	84dff0ef          	jal	80002132 <wait>
}
    800028ea:	60e2                	ld	ra,24(sp)
    800028ec:	6442                	ld	s0,16(sp)
    800028ee:	6105                	addi	sp,sp,32
    800028f0:	8082                	ret

00000000800028f2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800028f2:	7179                	addi	sp,sp,-48
    800028f4:	f406                	sd	ra,40(sp)
    800028f6:	f022                	sd	s0,32(sp)
    800028f8:	ec26                	sd	s1,24(sp)
    800028fa:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800028fc:	fdc40593          	addi	a1,s0,-36
    80002900:	4501                	li	a0,0
    80002902:	eb5ff0ef          	jal	800027b6 <argint>
  addr = myproc()->sz;
    80002906:	fe5fe0ef          	jal	800018ea <myproc>
    8000290a:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000290c:	fdc42503          	lw	a0,-36(s0)
    80002910:	ab0ff0ef          	jal	80001bc0 <growproc>
    80002914:	00054863          	bltz	a0,80002924 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002918:	8526                	mv	a0,s1
    8000291a:	70a2                	ld	ra,40(sp)
    8000291c:	7402                	ld	s0,32(sp)
    8000291e:	64e2                	ld	s1,24(sp)
    80002920:	6145                	addi	sp,sp,48
    80002922:	8082                	ret
    return -1;
    80002924:	54fd                	li	s1,-1
    80002926:	bfcd                	j	80002918 <sys_sbrk+0x26>

0000000080002928 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002928:	7139                	addi	sp,sp,-64
    8000292a:	fc06                	sd	ra,56(sp)
    8000292c:	f822                	sd	s0,48(sp)
    8000292e:	f04a                	sd	s2,32(sp)
    80002930:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002932:	fcc40593          	addi	a1,s0,-52
    80002936:	4501                	li	a0,0
    80002938:	e7fff0ef          	jal	800027b6 <argint>
  if(n < 0)
    8000293c:	fcc42783          	lw	a5,-52(s0)
    80002940:	0607c763          	bltz	a5,800029ae <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002944:	00013517          	auipc	a0,0x13
    80002948:	34c50513          	addi	a0,a0,844 # 80015c90 <tickslock>
    8000294c:	aa8fe0ef          	jal	80000bf4 <acquire>
  ticks0 = ticks;
    80002950:	00005917          	auipc	s2,0x5
    80002954:	fe092903          	lw	s2,-32(s2) # 80007930 <ticks>
  while(ticks - ticks0 < n){
    80002958:	fcc42783          	lw	a5,-52(s0)
    8000295c:	cf8d                	beqz	a5,80002996 <sys_sleep+0x6e>
    8000295e:	f426                	sd	s1,40(sp)
    80002960:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002962:	00013997          	auipc	s3,0x13
    80002966:	32e98993          	addi	s3,s3,814 # 80015c90 <tickslock>
    8000296a:	00005497          	auipc	s1,0x5
    8000296e:	fc648493          	addi	s1,s1,-58 # 80007930 <ticks>
    if(killed(myproc())){
    80002972:	f79fe0ef          	jal	800018ea <myproc>
    80002976:	f92ff0ef          	jal	80002108 <killed>
    8000297a:	ed0d                	bnez	a0,800029b4 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    8000297c:	85ce                	mv	a1,s3
    8000297e:	8526                	mv	a0,s1
    80002980:	d50ff0ef          	jal	80001ed0 <sleep>
  while(ticks - ticks0 < n){
    80002984:	409c                	lw	a5,0(s1)
    80002986:	412787bb          	subw	a5,a5,s2
    8000298a:	fcc42703          	lw	a4,-52(s0)
    8000298e:	fee7e2e3          	bltu	a5,a4,80002972 <sys_sleep+0x4a>
    80002992:	74a2                	ld	s1,40(sp)
    80002994:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002996:	00013517          	auipc	a0,0x13
    8000299a:	2fa50513          	addi	a0,a0,762 # 80015c90 <tickslock>
    8000299e:	aeefe0ef          	jal	80000c8c <release>
  return 0;
    800029a2:	4501                	li	a0,0
}
    800029a4:	70e2                	ld	ra,56(sp)
    800029a6:	7442                	ld	s0,48(sp)
    800029a8:	7902                	ld	s2,32(sp)
    800029aa:	6121                	addi	sp,sp,64
    800029ac:	8082                	ret
    n = 0;
    800029ae:	fc042623          	sw	zero,-52(s0)
    800029b2:	bf49                	j	80002944 <sys_sleep+0x1c>
      release(&tickslock);
    800029b4:	00013517          	auipc	a0,0x13
    800029b8:	2dc50513          	addi	a0,a0,732 # 80015c90 <tickslock>
    800029bc:	ad0fe0ef          	jal	80000c8c <release>
      return -1;
    800029c0:	557d                	li	a0,-1
    800029c2:	74a2                	ld	s1,40(sp)
    800029c4:	69e2                	ld	s3,24(sp)
    800029c6:	bff9                	j	800029a4 <sys_sleep+0x7c>

00000000800029c8 <sys_kill>:

uint64
sys_kill(void)
{
    800029c8:	1101                	addi	sp,sp,-32
    800029ca:	ec06                	sd	ra,24(sp)
    800029cc:	e822                	sd	s0,16(sp)
    800029ce:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800029d0:	fec40593          	addi	a1,s0,-20
    800029d4:	4501                	li	a0,0
    800029d6:	de1ff0ef          	jal	800027b6 <argint>
  return kill(pid);
    800029da:	fec42503          	lw	a0,-20(s0)
    800029de:	ea0ff0ef          	jal	8000207e <kill>
}
    800029e2:	60e2                	ld	ra,24(sp)
    800029e4:	6442                	ld	s0,16(sp)
    800029e6:	6105                	addi	sp,sp,32
    800029e8:	8082                	ret

00000000800029ea <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800029ea:	1101                	addi	sp,sp,-32
    800029ec:	ec06                	sd	ra,24(sp)
    800029ee:	e822                	sd	s0,16(sp)
    800029f0:	e426                	sd	s1,8(sp)
    800029f2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800029f4:	00013517          	auipc	a0,0x13
    800029f8:	29c50513          	addi	a0,a0,668 # 80015c90 <tickslock>
    800029fc:	9f8fe0ef          	jal	80000bf4 <acquire>
  xticks = ticks;
    80002a00:	00005497          	auipc	s1,0x5
    80002a04:	f304a483          	lw	s1,-208(s1) # 80007930 <ticks>
  release(&tickslock);
    80002a08:	00013517          	auipc	a0,0x13
    80002a0c:	28850513          	addi	a0,a0,648 # 80015c90 <tickslock>
    80002a10:	a7cfe0ef          	jal	80000c8c <release>
  return xticks;
}
    80002a14:	02049513          	slli	a0,s1,0x20
    80002a18:	9101                	srli	a0,a0,0x20
    80002a1a:	60e2                	ld	ra,24(sp)
    80002a1c:	6442                	ld	s0,16(sp)
    80002a1e:	64a2                	ld	s1,8(sp)
    80002a20:	6105                	addi	sp,sp,32
    80002a22:	8082                	ret

0000000080002a24 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002a24:	7179                	addi	sp,sp,-48
    80002a26:	f406                	sd	ra,40(sp)
    80002a28:	f022                	sd	s0,32(sp)
    80002a2a:	ec26                	sd	s1,24(sp)
    80002a2c:	e84a                	sd	s2,16(sp)
    80002a2e:	e44e                	sd	s3,8(sp)
    80002a30:	e052                	sd	s4,0(sp)
    80002a32:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002a34:	00005597          	auipc	a1,0x5
    80002a38:	a2c58593          	addi	a1,a1,-1492 # 80007460 <etext+0x460>
    80002a3c:	00013517          	auipc	a0,0x13
    80002a40:	26c50513          	addi	a0,a0,620 # 80015ca8 <bcache>
    80002a44:	930fe0ef          	jal	80000b74 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002a48:	0001b797          	auipc	a5,0x1b
    80002a4c:	26078793          	addi	a5,a5,608 # 8001dca8 <bcache+0x8000>
    80002a50:	0001b717          	auipc	a4,0x1b
    80002a54:	4c070713          	addi	a4,a4,1216 # 8001df10 <bcache+0x8268>
    80002a58:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002a5c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002a60:	00013497          	auipc	s1,0x13
    80002a64:	26048493          	addi	s1,s1,608 # 80015cc0 <bcache+0x18>
    b->next = bcache.head.next;
    80002a68:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002a6a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002a6c:	00005a17          	auipc	s4,0x5
    80002a70:	9fca0a13          	addi	s4,s4,-1540 # 80007468 <etext+0x468>
    b->next = bcache.head.next;
    80002a74:	2b893783          	ld	a5,696(s2)
    80002a78:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002a7a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002a7e:	85d2                	mv	a1,s4
    80002a80:	01048513          	addi	a0,s1,16
    80002a84:	248010ef          	jal	80003ccc <initsleeplock>
    bcache.head.next->prev = b;
    80002a88:	2b893783          	ld	a5,696(s2)
    80002a8c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002a8e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002a92:	45848493          	addi	s1,s1,1112
    80002a96:	fd349fe3          	bne	s1,s3,80002a74 <binit+0x50>
  }
}
    80002a9a:	70a2                	ld	ra,40(sp)
    80002a9c:	7402                	ld	s0,32(sp)
    80002a9e:	64e2                	ld	s1,24(sp)
    80002aa0:	6942                	ld	s2,16(sp)
    80002aa2:	69a2                	ld	s3,8(sp)
    80002aa4:	6a02                	ld	s4,0(sp)
    80002aa6:	6145                	addi	sp,sp,48
    80002aa8:	8082                	ret

0000000080002aaa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002aaa:	7179                	addi	sp,sp,-48
    80002aac:	f406                	sd	ra,40(sp)
    80002aae:	f022                	sd	s0,32(sp)
    80002ab0:	ec26                	sd	s1,24(sp)
    80002ab2:	e84a                	sd	s2,16(sp)
    80002ab4:	e44e                	sd	s3,8(sp)
    80002ab6:	1800                	addi	s0,sp,48
    80002ab8:	892a                	mv	s2,a0
    80002aba:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002abc:	00013517          	auipc	a0,0x13
    80002ac0:	1ec50513          	addi	a0,a0,492 # 80015ca8 <bcache>
    80002ac4:	930fe0ef          	jal	80000bf4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002ac8:	0001b497          	auipc	s1,0x1b
    80002acc:	4984b483          	ld	s1,1176(s1) # 8001df60 <bcache+0x82b8>
    80002ad0:	0001b797          	auipc	a5,0x1b
    80002ad4:	44078793          	addi	a5,a5,1088 # 8001df10 <bcache+0x8268>
    80002ad8:	02f48b63          	beq	s1,a5,80002b0e <bread+0x64>
    80002adc:	873e                	mv	a4,a5
    80002ade:	a021                	j	80002ae6 <bread+0x3c>
    80002ae0:	68a4                	ld	s1,80(s1)
    80002ae2:	02e48663          	beq	s1,a4,80002b0e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002ae6:	449c                	lw	a5,8(s1)
    80002ae8:	ff279ce3          	bne	a5,s2,80002ae0 <bread+0x36>
    80002aec:	44dc                	lw	a5,12(s1)
    80002aee:	ff3799e3          	bne	a5,s3,80002ae0 <bread+0x36>
      b->refcnt++;
    80002af2:	40bc                	lw	a5,64(s1)
    80002af4:	2785                	addiw	a5,a5,1
    80002af6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002af8:	00013517          	auipc	a0,0x13
    80002afc:	1b050513          	addi	a0,a0,432 # 80015ca8 <bcache>
    80002b00:	98cfe0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002b04:	01048513          	addi	a0,s1,16
    80002b08:	1fa010ef          	jal	80003d02 <acquiresleep>
      return b;
    80002b0c:	a889                	j	80002b5e <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002b0e:	0001b497          	auipc	s1,0x1b
    80002b12:	44a4b483          	ld	s1,1098(s1) # 8001df58 <bcache+0x82b0>
    80002b16:	0001b797          	auipc	a5,0x1b
    80002b1a:	3fa78793          	addi	a5,a5,1018 # 8001df10 <bcache+0x8268>
    80002b1e:	00f48863          	beq	s1,a5,80002b2e <bread+0x84>
    80002b22:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002b24:	40bc                	lw	a5,64(s1)
    80002b26:	cb91                	beqz	a5,80002b3a <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002b28:	64a4                	ld	s1,72(s1)
    80002b2a:	fee49de3          	bne	s1,a4,80002b24 <bread+0x7a>
  panic("bget: no buffers");
    80002b2e:	00005517          	auipc	a0,0x5
    80002b32:	94250513          	addi	a0,a0,-1726 # 80007470 <etext+0x470>
    80002b36:	c5ffd0ef          	jal	80000794 <panic>
      b->dev = dev;
    80002b3a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002b3e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002b42:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002b46:	4785                	li	a5,1
    80002b48:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002b4a:	00013517          	auipc	a0,0x13
    80002b4e:	15e50513          	addi	a0,a0,350 # 80015ca8 <bcache>
    80002b52:	93afe0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002b56:	01048513          	addi	a0,s1,16
    80002b5a:	1a8010ef          	jal	80003d02 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002b5e:	409c                	lw	a5,0(s1)
    80002b60:	cb89                	beqz	a5,80002b72 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002b62:	8526                	mv	a0,s1
    80002b64:	70a2                	ld	ra,40(sp)
    80002b66:	7402                	ld	s0,32(sp)
    80002b68:	64e2                	ld	s1,24(sp)
    80002b6a:	6942                	ld	s2,16(sp)
    80002b6c:	69a2                	ld	s3,8(sp)
    80002b6e:	6145                	addi	sp,sp,48
    80002b70:	8082                	ret
    virtio_disk_rw(b, 0);
    80002b72:	4581                	li	a1,0
    80002b74:	8526                	mv	a0,s1
    80002b76:	1eb020ef          	jal	80005560 <virtio_disk_rw>
    b->valid = 1;
    80002b7a:	4785                	li	a5,1
    80002b7c:	c09c                	sw	a5,0(s1)
  return b;
    80002b7e:	b7d5                	j	80002b62 <bread+0xb8>

0000000080002b80 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002b80:	1101                	addi	sp,sp,-32
    80002b82:	ec06                	sd	ra,24(sp)
    80002b84:	e822                	sd	s0,16(sp)
    80002b86:	e426                	sd	s1,8(sp)
    80002b88:	1000                	addi	s0,sp,32
    80002b8a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002b8c:	0541                	addi	a0,a0,16
    80002b8e:	1f2010ef          	jal	80003d80 <holdingsleep>
    80002b92:	c911                	beqz	a0,80002ba6 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002b94:	4585                	li	a1,1
    80002b96:	8526                	mv	a0,s1
    80002b98:	1c9020ef          	jal	80005560 <virtio_disk_rw>
}
    80002b9c:	60e2                	ld	ra,24(sp)
    80002b9e:	6442                	ld	s0,16(sp)
    80002ba0:	64a2                	ld	s1,8(sp)
    80002ba2:	6105                	addi	sp,sp,32
    80002ba4:	8082                	ret
    panic("bwrite");
    80002ba6:	00005517          	auipc	a0,0x5
    80002baa:	8e250513          	addi	a0,a0,-1822 # 80007488 <etext+0x488>
    80002bae:	be7fd0ef          	jal	80000794 <panic>

0000000080002bb2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002bb2:	1101                	addi	sp,sp,-32
    80002bb4:	ec06                	sd	ra,24(sp)
    80002bb6:	e822                	sd	s0,16(sp)
    80002bb8:	e426                	sd	s1,8(sp)
    80002bba:	e04a                	sd	s2,0(sp)
    80002bbc:	1000                	addi	s0,sp,32
    80002bbe:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002bc0:	01050913          	addi	s2,a0,16
    80002bc4:	854a                	mv	a0,s2
    80002bc6:	1ba010ef          	jal	80003d80 <holdingsleep>
    80002bca:	c135                	beqz	a0,80002c2e <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002bcc:	854a                	mv	a0,s2
    80002bce:	17a010ef          	jal	80003d48 <releasesleep>

  acquire(&bcache.lock);
    80002bd2:	00013517          	auipc	a0,0x13
    80002bd6:	0d650513          	addi	a0,a0,214 # 80015ca8 <bcache>
    80002bda:	81afe0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80002bde:	40bc                	lw	a5,64(s1)
    80002be0:	37fd                	addiw	a5,a5,-1
    80002be2:	0007871b          	sext.w	a4,a5
    80002be6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002be8:	e71d                	bnez	a4,80002c16 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002bea:	68b8                	ld	a4,80(s1)
    80002bec:	64bc                	ld	a5,72(s1)
    80002bee:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002bf0:	68b8                	ld	a4,80(s1)
    80002bf2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002bf4:	0001b797          	auipc	a5,0x1b
    80002bf8:	0b478793          	addi	a5,a5,180 # 8001dca8 <bcache+0x8000>
    80002bfc:	2b87b703          	ld	a4,696(a5)
    80002c00:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002c02:	0001b717          	auipc	a4,0x1b
    80002c06:	30e70713          	addi	a4,a4,782 # 8001df10 <bcache+0x8268>
    80002c0a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002c0c:	2b87b703          	ld	a4,696(a5)
    80002c10:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002c12:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002c16:	00013517          	auipc	a0,0x13
    80002c1a:	09250513          	addi	a0,a0,146 # 80015ca8 <bcache>
    80002c1e:	86efe0ef          	jal	80000c8c <release>
}
    80002c22:	60e2                	ld	ra,24(sp)
    80002c24:	6442                	ld	s0,16(sp)
    80002c26:	64a2                	ld	s1,8(sp)
    80002c28:	6902                	ld	s2,0(sp)
    80002c2a:	6105                	addi	sp,sp,32
    80002c2c:	8082                	ret
    panic("brelse");
    80002c2e:	00005517          	auipc	a0,0x5
    80002c32:	86250513          	addi	a0,a0,-1950 # 80007490 <etext+0x490>
    80002c36:	b5ffd0ef          	jal	80000794 <panic>

0000000080002c3a <bpin>:

void
bpin(struct buf *b) {
    80002c3a:	1101                	addi	sp,sp,-32
    80002c3c:	ec06                	sd	ra,24(sp)
    80002c3e:	e822                	sd	s0,16(sp)
    80002c40:	e426                	sd	s1,8(sp)
    80002c42:	1000                	addi	s0,sp,32
    80002c44:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002c46:	00013517          	auipc	a0,0x13
    80002c4a:	06250513          	addi	a0,a0,98 # 80015ca8 <bcache>
    80002c4e:	fa7fd0ef          	jal	80000bf4 <acquire>
  b->refcnt++;
    80002c52:	40bc                	lw	a5,64(s1)
    80002c54:	2785                	addiw	a5,a5,1
    80002c56:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002c58:	00013517          	auipc	a0,0x13
    80002c5c:	05050513          	addi	a0,a0,80 # 80015ca8 <bcache>
    80002c60:	82cfe0ef          	jal	80000c8c <release>
}
    80002c64:	60e2                	ld	ra,24(sp)
    80002c66:	6442                	ld	s0,16(sp)
    80002c68:	64a2                	ld	s1,8(sp)
    80002c6a:	6105                	addi	sp,sp,32
    80002c6c:	8082                	ret

0000000080002c6e <bunpin>:

void
bunpin(struct buf *b) {
    80002c6e:	1101                	addi	sp,sp,-32
    80002c70:	ec06                	sd	ra,24(sp)
    80002c72:	e822                	sd	s0,16(sp)
    80002c74:	e426                	sd	s1,8(sp)
    80002c76:	1000                	addi	s0,sp,32
    80002c78:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002c7a:	00013517          	auipc	a0,0x13
    80002c7e:	02e50513          	addi	a0,a0,46 # 80015ca8 <bcache>
    80002c82:	f73fd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80002c86:	40bc                	lw	a5,64(s1)
    80002c88:	37fd                	addiw	a5,a5,-1
    80002c8a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002c8c:	00013517          	auipc	a0,0x13
    80002c90:	01c50513          	addi	a0,a0,28 # 80015ca8 <bcache>
    80002c94:	ff9fd0ef          	jal	80000c8c <release>
}
    80002c98:	60e2                	ld	ra,24(sp)
    80002c9a:	6442                	ld	s0,16(sp)
    80002c9c:	64a2                	ld	s1,8(sp)
    80002c9e:	6105                	addi	sp,sp,32
    80002ca0:	8082                	ret

0000000080002ca2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002ca2:	1101                	addi	sp,sp,-32
    80002ca4:	ec06                	sd	ra,24(sp)
    80002ca6:	e822                	sd	s0,16(sp)
    80002ca8:	e426                	sd	s1,8(sp)
    80002caa:	e04a                	sd	s2,0(sp)
    80002cac:	1000                	addi	s0,sp,32
    80002cae:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002cb0:	00d5d59b          	srliw	a1,a1,0xd
    80002cb4:	0001b797          	auipc	a5,0x1b
    80002cb8:	6d07a783          	lw	a5,1744(a5) # 8001e384 <sb+0x1c>
    80002cbc:	9dbd                	addw	a1,a1,a5
    80002cbe:	dedff0ef          	jal	80002aaa <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002cc2:	0074f713          	andi	a4,s1,7
    80002cc6:	4785                	li	a5,1
    80002cc8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002ccc:	14ce                	slli	s1,s1,0x33
    80002cce:	90d9                	srli	s1,s1,0x36
    80002cd0:	00950733          	add	a4,a0,s1
    80002cd4:	05874703          	lbu	a4,88(a4)
    80002cd8:	00e7f6b3          	and	a3,a5,a4
    80002cdc:	c29d                	beqz	a3,80002d02 <bfree+0x60>
    80002cde:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002ce0:	94aa                	add	s1,s1,a0
    80002ce2:	fff7c793          	not	a5,a5
    80002ce6:	8f7d                	and	a4,a4,a5
    80002ce8:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002cec:	711000ef          	jal	80003bfc <log_write>
  brelse(bp);
    80002cf0:	854a                	mv	a0,s2
    80002cf2:	ec1ff0ef          	jal	80002bb2 <brelse>
}
    80002cf6:	60e2                	ld	ra,24(sp)
    80002cf8:	6442                	ld	s0,16(sp)
    80002cfa:	64a2                	ld	s1,8(sp)
    80002cfc:	6902                	ld	s2,0(sp)
    80002cfe:	6105                	addi	sp,sp,32
    80002d00:	8082                	ret
    panic("freeing free block");
    80002d02:	00004517          	auipc	a0,0x4
    80002d06:	79650513          	addi	a0,a0,1942 # 80007498 <etext+0x498>
    80002d0a:	a8bfd0ef          	jal	80000794 <panic>

0000000080002d0e <balloc>:
{
    80002d0e:	711d                	addi	sp,sp,-96
    80002d10:	ec86                	sd	ra,88(sp)
    80002d12:	e8a2                	sd	s0,80(sp)
    80002d14:	e4a6                	sd	s1,72(sp)
    80002d16:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002d18:	0001b797          	auipc	a5,0x1b
    80002d1c:	6547a783          	lw	a5,1620(a5) # 8001e36c <sb+0x4>
    80002d20:	0e078f63          	beqz	a5,80002e1e <balloc+0x110>
    80002d24:	e0ca                	sd	s2,64(sp)
    80002d26:	fc4e                	sd	s3,56(sp)
    80002d28:	f852                	sd	s4,48(sp)
    80002d2a:	f456                	sd	s5,40(sp)
    80002d2c:	f05a                	sd	s6,32(sp)
    80002d2e:	ec5e                	sd	s7,24(sp)
    80002d30:	e862                	sd	s8,16(sp)
    80002d32:	e466                	sd	s9,8(sp)
    80002d34:	8baa                	mv	s7,a0
    80002d36:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002d38:	0001bb17          	auipc	s6,0x1b
    80002d3c:	630b0b13          	addi	s6,s6,1584 # 8001e368 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d40:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002d42:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d44:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002d46:	6c89                	lui	s9,0x2
    80002d48:	a0b5                	j	80002db4 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002d4a:	97ca                	add	a5,a5,s2
    80002d4c:	8e55                	or	a2,a2,a3
    80002d4e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002d52:	854a                	mv	a0,s2
    80002d54:	6a9000ef          	jal	80003bfc <log_write>
        brelse(bp);
    80002d58:	854a                	mv	a0,s2
    80002d5a:	e59ff0ef          	jal	80002bb2 <brelse>
  bp = bread(dev, bno);
    80002d5e:	85a6                	mv	a1,s1
    80002d60:	855e                	mv	a0,s7
    80002d62:	d49ff0ef          	jal	80002aaa <bread>
    80002d66:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002d68:	40000613          	li	a2,1024
    80002d6c:	4581                	li	a1,0
    80002d6e:	05850513          	addi	a0,a0,88
    80002d72:	f57fd0ef          	jal	80000cc8 <memset>
  log_write(bp);
    80002d76:	854a                	mv	a0,s2
    80002d78:	685000ef          	jal	80003bfc <log_write>
  brelse(bp);
    80002d7c:	854a                	mv	a0,s2
    80002d7e:	e35ff0ef          	jal	80002bb2 <brelse>
}
    80002d82:	6906                	ld	s2,64(sp)
    80002d84:	79e2                	ld	s3,56(sp)
    80002d86:	7a42                	ld	s4,48(sp)
    80002d88:	7aa2                	ld	s5,40(sp)
    80002d8a:	7b02                	ld	s6,32(sp)
    80002d8c:	6be2                	ld	s7,24(sp)
    80002d8e:	6c42                	ld	s8,16(sp)
    80002d90:	6ca2                	ld	s9,8(sp)
}
    80002d92:	8526                	mv	a0,s1
    80002d94:	60e6                	ld	ra,88(sp)
    80002d96:	6446                	ld	s0,80(sp)
    80002d98:	64a6                	ld	s1,72(sp)
    80002d9a:	6125                	addi	sp,sp,96
    80002d9c:	8082                	ret
    brelse(bp);
    80002d9e:	854a                	mv	a0,s2
    80002da0:	e13ff0ef          	jal	80002bb2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002da4:	015c87bb          	addw	a5,s9,s5
    80002da8:	00078a9b          	sext.w	s5,a5
    80002dac:	004b2703          	lw	a4,4(s6)
    80002db0:	04eaff63          	bgeu	s5,a4,80002e0e <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002db4:	41fad79b          	sraiw	a5,s5,0x1f
    80002db8:	0137d79b          	srliw	a5,a5,0x13
    80002dbc:	015787bb          	addw	a5,a5,s5
    80002dc0:	40d7d79b          	sraiw	a5,a5,0xd
    80002dc4:	01cb2583          	lw	a1,28(s6)
    80002dc8:	9dbd                	addw	a1,a1,a5
    80002dca:	855e                	mv	a0,s7
    80002dcc:	cdfff0ef          	jal	80002aaa <bread>
    80002dd0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002dd2:	004b2503          	lw	a0,4(s6)
    80002dd6:	000a849b          	sext.w	s1,s5
    80002dda:	8762                	mv	a4,s8
    80002ddc:	fca4f1e3          	bgeu	s1,a0,80002d9e <balloc+0x90>
      m = 1 << (bi % 8);
    80002de0:	00777693          	andi	a3,a4,7
    80002de4:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002de8:	41f7579b          	sraiw	a5,a4,0x1f
    80002dec:	01d7d79b          	srliw	a5,a5,0x1d
    80002df0:	9fb9                	addw	a5,a5,a4
    80002df2:	4037d79b          	sraiw	a5,a5,0x3
    80002df6:	00f90633          	add	a2,s2,a5
    80002dfa:	05864603          	lbu	a2,88(a2)
    80002dfe:	00c6f5b3          	and	a1,a3,a2
    80002e02:	d5a1                	beqz	a1,80002d4a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e04:	2705                	addiw	a4,a4,1
    80002e06:	2485                	addiw	s1,s1,1
    80002e08:	fd471ae3          	bne	a4,s4,80002ddc <balloc+0xce>
    80002e0c:	bf49                	j	80002d9e <balloc+0x90>
    80002e0e:	6906                	ld	s2,64(sp)
    80002e10:	79e2                	ld	s3,56(sp)
    80002e12:	7a42                	ld	s4,48(sp)
    80002e14:	7aa2                	ld	s5,40(sp)
    80002e16:	7b02                	ld	s6,32(sp)
    80002e18:	6be2                	ld	s7,24(sp)
    80002e1a:	6c42                	ld	s8,16(sp)
    80002e1c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002e1e:	00004517          	auipc	a0,0x4
    80002e22:	69250513          	addi	a0,a0,1682 # 800074b0 <etext+0x4b0>
    80002e26:	e9cfd0ef          	jal	800004c2 <printf>
  return 0;
    80002e2a:	4481                	li	s1,0
    80002e2c:	b79d                	j	80002d92 <balloc+0x84>

0000000080002e2e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002e2e:	7179                	addi	sp,sp,-48
    80002e30:	f406                	sd	ra,40(sp)
    80002e32:	f022                	sd	s0,32(sp)
    80002e34:	ec26                	sd	s1,24(sp)
    80002e36:	e84a                	sd	s2,16(sp)
    80002e38:	e44e                	sd	s3,8(sp)
    80002e3a:	1800                	addi	s0,sp,48
    80002e3c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002e3e:	47ad                	li	a5,11
    80002e40:	02b7e663          	bltu	a5,a1,80002e6c <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002e44:	02059793          	slli	a5,a1,0x20
    80002e48:	01e7d593          	srli	a1,a5,0x1e
    80002e4c:	00b504b3          	add	s1,a0,a1
    80002e50:	0504a903          	lw	s2,80(s1)
    80002e54:	06091a63          	bnez	s2,80002ec8 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002e58:	4108                	lw	a0,0(a0)
    80002e5a:	eb5ff0ef          	jal	80002d0e <balloc>
    80002e5e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002e62:	06090363          	beqz	s2,80002ec8 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002e66:	0524a823          	sw	s2,80(s1)
    80002e6a:	a8b9                	j	80002ec8 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002e6c:	ff45849b          	addiw	s1,a1,-12
    80002e70:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002e74:	0ff00793          	li	a5,255
    80002e78:	06e7ee63          	bltu	a5,a4,80002ef4 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002e7c:	08052903          	lw	s2,128(a0)
    80002e80:	00091d63          	bnez	s2,80002e9a <bmap+0x6c>
      addr = balloc(ip->dev);
    80002e84:	4108                	lw	a0,0(a0)
    80002e86:	e89ff0ef          	jal	80002d0e <balloc>
    80002e8a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002e8e:	02090d63          	beqz	s2,80002ec8 <bmap+0x9a>
    80002e92:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002e94:	0929a023          	sw	s2,128(s3)
    80002e98:	a011                	j	80002e9c <bmap+0x6e>
    80002e9a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002e9c:	85ca                	mv	a1,s2
    80002e9e:	0009a503          	lw	a0,0(s3)
    80002ea2:	c09ff0ef          	jal	80002aaa <bread>
    80002ea6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002ea8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002eac:	02049713          	slli	a4,s1,0x20
    80002eb0:	01e75593          	srli	a1,a4,0x1e
    80002eb4:	00b784b3          	add	s1,a5,a1
    80002eb8:	0004a903          	lw	s2,0(s1)
    80002ebc:	00090e63          	beqz	s2,80002ed8 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002ec0:	8552                	mv	a0,s4
    80002ec2:	cf1ff0ef          	jal	80002bb2 <brelse>
    return addr;
    80002ec6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002ec8:	854a                	mv	a0,s2
    80002eca:	70a2                	ld	ra,40(sp)
    80002ecc:	7402                	ld	s0,32(sp)
    80002ece:	64e2                	ld	s1,24(sp)
    80002ed0:	6942                	ld	s2,16(sp)
    80002ed2:	69a2                	ld	s3,8(sp)
    80002ed4:	6145                	addi	sp,sp,48
    80002ed6:	8082                	ret
      addr = balloc(ip->dev);
    80002ed8:	0009a503          	lw	a0,0(s3)
    80002edc:	e33ff0ef          	jal	80002d0e <balloc>
    80002ee0:	0005091b          	sext.w	s2,a0
      if(addr){
    80002ee4:	fc090ee3          	beqz	s2,80002ec0 <bmap+0x92>
        a[bn] = addr;
    80002ee8:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002eec:	8552                	mv	a0,s4
    80002eee:	50f000ef          	jal	80003bfc <log_write>
    80002ef2:	b7f9                	j	80002ec0 <bmap+0x92>
    80002ef4:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002ef6:	00004517          	auipc	a0,0x4
    80002efa:	5d250513          	addi	a0,a0,1490 # 800074c8 <etext+0x4c8>
    80002efe:	897fd0ef          	jal	80000794 <panic>

0000000080002f02 <iget>:
{
    80002f02:	7179                	addi	sp,sp,-48
    80002f04:	f406                	sd	ra,40(sp)
    80002f06:	f022                	sd	s0,32(sp)
    80002f08:	ec26                	sd	s1,24(sp)
    80002f0a:	e84a                	sd	s2,16(sp)
    80002f0c:	e44e                	sd	s3,8(sp)
    80002f0e:	e052                	sd	s4,0(sp)
    80002f10:	1800                	addi	s0,sp,48
    80002f12:	89aa                	mv	s3,a0
    80002f14:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002f16:	0001b517          	auipc	a0,0x1b
    80002f1a:	47250513          	addi	a0,a0,1138 # 8001e388 <itable>
    80002f1e:	cd7fd0ef          	jal	80000bf4 <acquire>
  empty = 0;
    80002f22:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002f24:	0001b497          	auipc	s1,0x1b
    80002f28:	47c48493          	addi	s1,s1,1148 # 8001e3a0 <itable+0x18>
    80002f2c:	0001d697          	auipc	a3,0x1d
    80002f30:	f0468693          	addi	a3,a3,-252 # 8001fe30 <log>
    80002f34:	a039                	j	80002f42 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002f36:	02090963          	beqz	s2,80002f68 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002f3a:	08848493          	addi	s1,s1,136
    80002f3e:	02d48863          	beq	s1,a3,80002f6e <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002f42:	449c                	lw	a5,8(s1)
    80002f44:	fef059e3          	blez	a5,80002f36 <iget+0x34>
    80002f48:	4098                	lw	a4,0(s1)
    80002f4a:	ff3716e3          	bne	a4,s3,80002f36 <iget+0x34>
    80002f4e:	40d8                	lw	a4,4(s1)
    80002f50:	ff4713e3          	bne	a4,s4,80002f36 <iget+0x34>
      ip->ref++;
    80002f54:	2785                	addiw	a5,a5,1
    80002f56:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002f58:	0001b517          	auipc	a0,0x1b
    80002f5c:	43050513          	addi	a0,a0,1072 # 8001e388 <itable>
    80002f60:	d2dfd0ef          	jal	80000c8c <release>
      return ip;
    80002f64:	8926                	mv	s2,s1
    80002f66:	a02d                	j	80002f90 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002f68:	fbe9                	bnez	a5,80002f3a <iget+0x38>
      empty = ip;
    80002f6a:	8926                	mv	s2,s1
    80002f6c:	b7f9                	j	80002f3a <iget+0x38>
  if(empty == 0)
    80002f6e:	02090a63          	beqz	s2,80002fa2 <iget+0xa0>
  ip->dev = dev;
    80002f72:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002f76:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002f7a:	4785                	li	a5,1
    80002f7c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002f80:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002f84:	0001b517          	auipc	a0,0x1b
    80002f88:	40450513          	addi	a0,a0,1028 # 8001e388 <itable>
    80002f8c:	d01fd0ef          	jal	80000c8c <release>
}
    80002f90:	854a                	mv	a0,s2
    80002f92:	70a2                	ld	ra,40(sp)
    80002f94:	7402                	ld	s0,32(sp)
    80002f96:	64e2                	ld	s1,24(sp)
    80002f98:	6942                	ld	s2,16(sp)
    80002f9a:	69a2                	ld	s3,8(sp)
    80002f9c:	6a02                	ld	s4,0(sp)
    80002f9e:	6145                	addi	sp,sp,48
    80002fa0:	8082                	ret
    panic("iget: no inodes");
    80002fa2:	00004517          	auipc	a0,0x4
    80002fa6:	53e50513          	addi	a0,a0,1342 # 800074e0 <etext+0x4e0>
    80002faa:	feafd0ef          	jal	80000794 <panic>

0000000080002fae <fsinit>:
fsinit(int dev) {
    80002fae:	7179                	addi	sp,sp,-48
    80002fb0:	f406                	sd	ra,40(sp)
    80002fb2:	f022                	sd	s0,32(sp)
    80002fb4:	ec26                	sd	s1,24(sp)
    80002fb6:	e84a                	sd	s2,16(sp)
    80002fb8:	e44e                	sd	s3,8(sp)
    80002fba:	1800                	addi	s0,sp,48
    80002fbc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002fbe:	4585                	li	a1,1
    80002fc0:	aebff0ef          	jal	80002aaa <bread>
    80002fc4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002fc6:	0001b997          	auipc	s3,0x1b
    80002fca:	3a298993          	addi	s3,s3,930 # 8001e368 <sb>
    80002fce:	02000613          	li	a2,32
    80002fd2:	05850593          	addi	a1,a0,88
    80002fd6:	854e                	mv	a0,s3
    80002fd8:	d4dfd0ef          	jal	80000d24 <memmove>
  brelse(bp);
    80002fdc:	8526                	mv	a0,s1
    80002fde:	bd5ff0ef          	jal	80002bb2 <brelse>
  if(sb.magic != FSMAGIC)
    80002fe2:	0009a703          	lw	a4,0(s3)
    80002fe6:	102037b7          	lui	a5,0x10203
    80002fea:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002fee:	02f71063          	bne	a4,a5,8000300e <fsinit+0x60>
  initlog(dev, &sb);
    80002ff2:	0001b597          	auipc	a1,0x1b
    80002ff6:	37658593          	addi	a1,a1,886 # 8001e368 <sb>
    80002ffa:	854a                	mv	a0,s2
    80002ffc:	1f9000ef          	jal	800039f4 <initlog>
}
    80003000:	70a2                	ld	ra,40(sp)
    80003002:	7402                	ld	s0,32(sp)
    80003004:	64e2                	ld	s1,24(sp)
    80003006:	6942                	ld	s2,16(sp)
    80003008:	69a2                	ld	s3,8(sp)
    8000300a:	6145                	addi	sp,sp,48
    8000300c:	8082                	ret
    panic("invalid file system");
    8000300e:	00004517          	auipc	a0,0x4
    80003012:	4e250513          	addi	a0,a0,1250 # 800074f0 <etext+0x4f0>
    80003016:	f7efd0ef          	jal	80000794 <panic>

000000008000301a <iinit>:
{
    8000301a:	7179                	addi	sp,sp,-48
    8000301c:	f406                	sd	ra,40(sp)
    8000301e:	f022                	sd	s0,32(sp)
    80003020:	ec26                	sd	s1,24(sp)
    80003022:	e84a                	sd	s2,16(sp)
    80003024:	e44e                	sd	s3,8(sp)
    80003026:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003028:	00004597          	auipc	a1,0x4
    8000302c:	4e058593          	addi	a1,a1,1248 # 80007508 <etext+0x508>
    80003030:	0001b517          	auipc	a0,0x1b
    80003034:	35850513          	addi	a0,a0,856 # 8001e388 <itable>
    80003038:	b3dfd0ef          	jal	80000b74 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000303c:	0001b497          	auipc	s1,0x1b
    80003040:	37448493          	addi	s1,s1,884 # 8001e3b0 <itable+0x28>
    80003044:	0001d997          	auipc	s3,0x1d
    80003048:	dfc98993          	addi	s3,s3,-516 # 8001fe40 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000304c:	00004917          	auipc	s2,0x4
    80003050:	4c490913          	addi	s2,s2,1220 # 80007510 <etext+0x510>
    80003054:	85ca                	mv	a1,s2
    80003056:	8526                	mv	a0,s1
    80003058:	475000ef          	jal	80003ccc <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000305c:	08848493          	addi	s1,s1,136
    80003060:	ff349ae3          	bne	s1,s3,80003054 <iinit+0x3a>
}
    80003064:	70a2                	ld	ra,40(sp)
    80003066:	7402                	ld	s0,32(sp)
    80003068:	64e2                	ld	s1,24(sp)
    8000306a:	6942                	ld	s2,16(sp)
    8000306c:	69a2                	ld	s3,8(sp)
    8000306e:	6145                	addi	sp,sp,48
    80003070:	8082                	ret

0000000080003072 <ialloc>:
{
    80003072:	7139                	addi	sp,sp,-64
    80003074:	fc06                	sd	ra,56(sp)
    80003076:	f822                	sd	s0,48(sp)
    80003078:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000307a:	0001b717          	auipc	a4,0x1b
    8000307e:	2fa72703          	lw	a4,762(a4) # 8001e374 <sb+0xc>
    80003082:	4785                	li	a5,1
    80003084:	06e7f063          	bgeu	a5,a4,800030e4 <ialloc+0x72>
    80003088:	f426                	sd	s1,40(sp)
    8000308a:	f04a                	sd	s2,32(sp)
    8000308c:	ec4e                	sd	s3,24(sp)
    8000308e:	e852                	sd	s4,16(sp)
    80003090:	e456                	sd	s5,8(sp)
    80003092:	e05a                	sd	s6,0(sp)
    80003094:	8aaa                	mv	s5,a0
    80003096:	8b2e                	mv	s6,a1
    80003098:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000309a:	0001ba17          	auipc	s4,0x1b
    8000309e:	2cea0a13          	addi	s4,s4,718 # 8001e368 <sb>
    800030a2:	00495593          	srli	a1,s2,0x4
    800030a6:	018a2783          	lw	a5,24(s4)
    800030aa:	9dbd                	addw	a1,a1,a5
    800030ac:	8556                	mv	a0,s5
    800030ae:	9fdff0ef          	jal	80002aaa <bread>
    800030b2:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800030b4:	05850993          	addi	s3,a0,88
    800030b8:	00f97793          	andi	a5,s2,15
    800030bc:	079a                	slli	a5,a5,0x6
    800030be:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800030c0:	00099783          	lh	a5,0(s3)
    800030c4:	cb9d                	beqz	a5,800030fa <ialloc+0x88>
    brelse(bp);
    800030c6:	aedff0ef          	jal	80002bb2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800030ca:	0905                	addi	s2,s2,1
    800030cc:	00ca2703          	lw	a4,12(s4)
    800030d0:	0009079b          	sext.w	a5,s2
    800030d4:	fce7e7e3          	bltu	a5,a4,800030a2 <ialloc+0x30>
    800030d8:	74a2                	ld	s1,40(sp)
    800030da:	7902                	ld	s2,32(sp)
    800030dc:	69e2                	ld	s3,24(sp)
    800030de:	6a42                	ld	s4,16(sp)
    800030e0:	6aa2                	ld	s5,8(sp)
    800030e2:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800030e4:	00004517          	auipc	a0,0x4
    800030e8:	43450513          	addi	a0,a0,1076 # 80007518 <etext+0x518>
    800030ec:	bd6fd0ef          	jal	800004c2 <printf>
  return 0;
    800030f0:	4501                	li	a0,0
}
    800030f2:	70e2                	ld	ra,56(sp)
    800030f4:	7442                	ld	s0,48(sp)
    800030f6:	6121                	addi	sp,sp,64
    800030f8:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800030fa:	04000613          	li	a2,64
    800030fe:	4581                	li	a1,0
    80003100:	854e                	mv	a0,s3
    80003102:	bc7fd0ef          	jal	80000cc8 <memset>
      dip->type = type;
    80003106:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000310a:	8526                	mv	a0,s1
    8000310c:	2f1000ef          	jal	80003bfc <log_write>
      brelse(bp);
    80003110:	8526                	mv	a0,s1
    80003112:	aa1ff0ef          	jal	80002bb2 <brelse>
      return iget(dev, inum);
    80003116:	0009059b          	sext.w	a1,s2
    8000311a:	8556                	mv	a0,s5
    8000311c:	de7ff0ef          	jal	80002f02 <iget>
    80003120:	74a2                	ld	s1,40(sp)
    80003122:	7902                	ld	s2,32(sp)
    80003124:	69e2                	ld	s3,24(sp)
    80003126:	6a42                	ld	s4,16(sp)
    80003128:	6aa2                	ld	s5,8(sp)
    8000312a:	6b02                	ld	s6,0(sp)
    8000312c:	b7d9                	j	800030f2 <ialloc+0x80>

000000008000312e <iupdate>:
{
    8000312e:	1101                	addi	sp,sp,-32
    80003130:	ec06                	sd	ra,24(sp)
    80003132:	e822                	sd	s0,16(sp)
    80003134:	e426                	sd	s1,8(sp)
    80003136:	e04a                	sd	s2,0(sp)
    80003138:	1000                	addi	s0,sp,32
    8000313a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000313c:	415c                	lw	a5,4(a0)
    8000313e:	0047d79b          	srliw	a5,a5,0x4
    80003142:	0001b597          	auipc	a1,0x1b
    80003146:	23e5a583          	lw	a1,574(a1) # 8001e380 <sb+0x18>
    8000314a:	9dbd                	addw	a1,a1,a5
    8000314c:	4108                	lw	a0,0(a0)
    8000314e:	95dff0ef          	jal	80002aaa <bread>
    80003152:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003154:	05850793          	addi	a5,a0,88
    80003158:	40d8                	lw	a4,4(s1)
    8000315a:	8b3d                	andi	a4,a4,15
    8000315c:	071a                	slli	a4,a4,0x6
    8000315e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003160:	04449703          	lh	a4,68(s1)
    80003164:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003168:	04649703          	lh	a4,70(s1)
    8000316c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003170:	04849703          	lh	a4,72(s1)
    80003174:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003178:	04a49703          	lh	a4,74(s1)
    8000317c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003180:	44f8                	lw	a4,76(s1)
    80003182:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003184:	03400613          	li	a2,52
    80003188:	05048593          	addi	a1,s1,80
    8000318c:	00c78513          	addi	a0,a5,12
    80003190:	b95fd0ef          	jal	80000d24 <memmove>
  log_write(bp);
    80003194:	854a                	mv	a0,s2
    80003196:	267000ef          	jal	80003bfc <log_write>
  brelse(bp);
    8000319a:	854a                	mv	a0,s2
    8000319c:	a17ff0ef          	jal	80002bb2 <brelse>
}
    800031a0:	60e2                	ld	ra,24(sp)
    800031a2:	6442                	ld	s0,16(sp)
    800031a4:	64a2                	ld	s1,8(sp)
    800031a6:	6902                	ld	s2,0(sp)
    800031a8:	6105                	addi	sp,sp,32
    800031aa:	8082                	ret

00000000800031ac <idup>:
{
    800031ac:	1101                	addi	sp,sp,-32
    800031ae:	ec06                	sd	ra,24(sp)
    800031b0:	e822                	sd	s0,16(sp)
    800031b2:	e426                	sd	s1,8(sp)
    800031b4:	1000                	addi	s0,sp,32
    800031b6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800031b8:	0001b517          	auipc	a0,0x1b
    800031bc:	1d050513          	addi	a0,a0,464 # 8001e388 <itable>
    800031c0:	a35fd0ef          	jal	80000bf4 <acquire>
  ip->ref++;
    800031c4:	449c                	lw	a5,8(s1)
    800031c6:	2785                	addiw	a5,a5,1
    800031c8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800031ca:	0001b517          	auipc	a0,0x1b
    800031ce:	1be50513          	addi	a0,a0,446 # 8001e388 <itable>
    800031d2:	abbfd0ef          	jal	80000c8c <release>
}
    800031d6:	8526                	mv	a0,s1
    800031d8:	60e2                	ld	ra,24(sp)
    800031da:	6442                	ld	s0,16(sp)
    800031dc:	64a2                	ld	s1,8(sp)
    800031de:	6105                	addi	sp,sp,32
    800031e0:	8082                	ret

00000000800031e2 <ilock>:
{
    800031e2:	1101                	addi	sp,sp,-32
    800031e4:	ec06                	sd	ra,24(sp)
    800031e6:	e822                	sd	s0,16(sp)
    800031e8:	e426                	sd	s1,8(sp)
    800031ea:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800031ec:	cd19                	beqz	a0,8000320a <ilock+0x28>
    800031ee:	84aa                	mv	s1,a0
    800031f0:	451c                	lw	a5,8(a0)
    800031f2:	00f05c63          	blez	a5,8000320a <ilock+0x28>
  acquiresleep(&ip->lock);
    800031f6:	0541                	addi	a0,a0,16
    800031f8:	30b000ef          	jal	80003d02 <acquiresleep>
  if(ip->valid == 0){
    800031fc:	40bc                	lw	a5,64(s1)
    800031fe:	cf89                	beqz	a5,80003218 <ilock+0x36>
}
    80003200:	60e2                	ld	ra,24(sp)
    80003202:	6442                	ld	s0,16(sp)
    80003204:	64a2                	ld	s1,8(sp)
    80003206:	6105                	addi	sp,sp,32
    80003208:	8082                	ret
    8000320a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000320c:	00004517          	auipc	a0,0x4
    80003210:	32450513          	addi	a0,a0,804 # 80007530 <etext+0x530>
    80003214:	d80fd0ef          	jal	80000794 <panic>
    80003218:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000321a:	40dc                	lw	a5,4(s1)
    8000321c:	0047d79b          	srliw	a5,a5,0x4
    80003220:	0001b597          	auipc	a1,0x1b
    80003224:	1605a583          	lw	a1,352(a1) # 8001e380 <sb+0x18>
    80003228:	9dbd                	addw	a1,a1,a5
    8000322a:	4088                	lw	a0,0(s1)
    8000322c:	87fff0ef          	jal	80002aaa <bread>
    80003230:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003232:	05850593          	addi	a1,a0,88
    80003236:	40dc                	lw	a5,4(s1)
    80003238:	8bbd                	andi	a5,a5,15
    8000323a:	079a                	slli	a5,a5,0x6
    8000323c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000323e:	00059783          	lh	a5,0(a1)
    80003242:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003246:	00259783          	lh	a5,2(a1)
    8000324a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000324e:	00459783          	lh	a5,4(a1)
    80003252:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003256:	00659783          	lh	a5,6(a1)
    8000325a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000325e:	459c                	lw	a5,8(a1)
    80003260:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003262:	03400613          	li	a2,52
    80003266:	05b1                	addi	a1,a1,12
    80003268:	05048513          	addi	a0,s1,80
    8000326c:	ab9fd0ef          	jal	80000d24 <memmove>
    brelse(bp);
    80003270:	854a                	mv	a0,s2
    80003272:	941ff0ef          	jal	80002bb2 <brelse>
    ip->valid = 1;
    80003276:	4785                	li	a5,1
    80003278:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000327a:	04449783          	lh	a5,68(s1)
    8000327e:	c399                	beqz	a5,80003284 <ilock+0xa2>
    80003280:	6902                	ld	s2,0(sp)
    80003282:	bfbd                	j	80003200 <ilock+0x1e>
      panic("ilock: no type");
    80003284:	00004517          	auipc	a0,0x4
    80003288:	2b450513          	addi	a0,a0,692 # 80007538 <etext+0x538>
    8000328c:	d08fd0ef          	jal	80000794 <panic>

0000000080003290 <iunlock>:
{
    80003290:	1101                	addi	sp,sp,-32
    80003292:	ec06                	sd	ra,24(sp)
    80003294:	e822                	sd	s0,16(sp)
    80003296:	e426                	sd	s1,8(sp)
    80003298:	e04a                	sd	s2,0(sp)
    8000329a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000329c:	c505                	beqz	a0,800032c4 <iunlock+0x34>
    8000329e:	84aa                	mv	s1,a0
    800032a0:	01050913          	addi	s2,a0,16
    800032a4:	854a                	mv	a0,s2
    800032a6:	2db000ef          	jal	80003d80 <holdingsleep>
    800032aa:	cd09                	beqz	a0,800032c4 <iunlock+0x34>
    800032ac:	449c                	lw	a5,8(s1)
    800032ae:	00f05b63          	blez	a5,800032c4 <iunlock+0x34>
  releasesleep(&ip->lock);
    800032b2:	854a                	mv	a0,s2
    800032b4:	295000ef          	jal	80003d48 <releasesleep>
}
    800032b8:	60e2                	ld	ra,24(sp)
    800032ba:	6442                	ld	s0,16(sp)
    800032bc:	64a2                	ld	s1,8(sp)
    800032be:	6902                	ld	s2,0(sp)
    800032c0:	6105                	addi	sp,sp,32
    800032c2:	8082                	ret
    panic("iunlock");
    800032c4:	00004517          	auipc	a0,0x4
    800032c8:	28450513          	addi	a0,a0,644 # 80007548 <etext+0x548>
    800032cc:	cc8fd0ef          	jal	80000794 <panic>

00000000800032d0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800032d0:	7179                	addi	sp,sp,-48
    800032d2:	f406                	sd	ra,40(sp)
    800032d4:	f022                	sd	s0,32(sp)
    800032d6:	ec26                	sd	s1,24(sp)
    800032d8:	e84a                	sd	s2,16(sp)
    800032da:	e44e                	sd	s3,8(sp)
    800032dc:	1800                	addi	s0,sp,48
    800032de:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800032e0:	05050493          	addi	s1,a0,80
    800032e4:	08050913          	addi	s2,a0,128
    800032e8:	a021                	j	800032f0 <itrunc+0x20>
    800032ea:	0491                	addi	s1,s1,4
    800032ec:	01248b63          	beq	s1,s2,80003302 <itrunc+0x32>
    if(ip->addrs[i]){
    800032f0:	408c                	lw	a1,0(s1)
    800032f2:	dde5                	beqz	a1,800032ea <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800032f4:	0009a503          	lw	a0,0(s3)
    800032f8:	9abff0ef          	jal	80002ca2 <bfree>
      ip->addrs[i] = 0;
    800032fc:	0004a023          	sw	zero,0(s1)
    80003300:	b7ed                	j	800032ea <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003302:	0809a583          	lw	a1,128(s3)
    80003306:	ed89                	bnez	a1,80003320 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003308:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000330c:	854e                	mv	a0,s3
    8000330e:	e21ff0ef          	jal	8000312e <iupdate>
}
    80003312:	70a2                	ld	ra,40(sp)
    80003314:	7402                	ld	s0,32(sp)
    80003316:	64e2                	ld	s1,24(sp)
    80003318:	6942                	ld	s2,16(sp)
    8000331a:	69a2                	ld	s3,8(sp)
    8000331c:	6145                	addi	sp,sp,48
    8000331e:	8082                	ret
    80003320:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003322:	0009a503          	lw	a0,0(s3)
    80003326:	f84ff0ef          	jal	80002aaa <bread>
    8000332a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000332c:	05850493          	addi	s1,a0,88
    80003330:	45850913          	addi	s2,a0,1112
    80003334:	a021                	j	8000333c <itrunc+0x6c>
    80003336:	0491                	addi	s1,s1,4
    80003338:	01248963          	beq	s1,s2,8000334a <itrunc+0x7a>
      if(a[j])
    8000333c:	408c                	lw	a1,0(s1)
    8000333e:	dde5                	beqz	a1,80003336 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003340:	0009a503          	lw	a0,0(s3)
    80003344:	95fff0ef          	jal	80002ca2 <bfree>
    80003348:	b7fd                	j	80003336 <itrunc+0x66>
    brelse(bp);
    8000334a:	8552                	mv	a0,s4
    8000334c:	867ff0ef          	jal	80002bb2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003350:	0809a583          	lw	a1,128(s3)
    80003354:	0009a503          	lw	a0,0(s3)
    80003358:	94bff0ef          	jal	80002ca2 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000335c:	0809a023          	sw	zero,128(s3)
    80003360:	6a02                	ld	s4,0(sp)
    80003362:	b75d                	j	80003308 <itrunc+0x38>

0000000080003364 <iput>:
{
    80003364:	1101                	addi	sp,sp,-32
    80003366:	ec06                	sd	ra,24(sp)
    80003368:	e822                	sd	s0,16(sp)
    8000336a:	e426                	sd	s1,8(sp)
    8000336c:	1000                	addi	s0,sp,32
    8000336e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003370:	0001b517          	auipc	a0,0x1b
    80003374:	01850513          	addi	a0,a0,24 # 8001e388 <itable>
    80003378:	87dfd0ef          	jal	80000bf4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000337c:	4498                	lw	a4,8(s1)
    8000337e:	4785                	li	a5,1
    80003380:	02f70063          	beq	a4,a5,800033a0 <iput+0x3c>
  ip->ref--;
    80003384:	449c                	lw	a5,8(s1)
    80003386:	37fd                	addiw	a5,a5,-1
    80003388:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000338a:	0001b517          	auipc	a0,0x1b
    8000338e:	ffe50513          	addi	a0,a0,-2 # 8001e388 <itable>
    80003392:	8fbfd0ef          	jal	80000c8c <release>
}
    80003396:	60e2                	ld	ra,24(sp)
    80003398:	6442                	ld	s0,16(sp)
    8000339a:	64a2                	ld	s1,8(sp)
    8000339c:	6105                	addi	sp,sp,32
    8000339e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800033a0:	40bc                	lw	a5,64(s1)
    800033a2:	d3ed                	beqz	a5,80003384 <iput+0x20>
    800033a4:	04a49783          	lh	a5,74(s1)
    800033a8:	fff1                	bnez	a5,80003384 <iput+0x20>
    800033aa:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800033ac:	01048913          	addi	s2,s1,16
    800033b0:	854a                	mv	a0,s2
    800033b2:	151000ef          	jal	80003d02 <acquiresleep>
    release(&itable.lock);
    800033b6:	0001b517          	auipc	a0,0x1b
    800033ba:	fd250513          	addi	a0,a0,-46 # 8001e388 <itable>
    800033be:	8cffd0ef          	jal	80000c8c <release>
    itrunc(ip);
    800033c2:	8526                	mv	a0,s1
    800033c4:	f0dff0ef          	jal	800032d0 <itrunc>
    ip->type = 0;
    800033c8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800033cc:	8526                	mv	a0,s1
    800033ce:	d61ff0ef          	jal	8000312e <iupdate>
    ip->valid = 0;
    800033d2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800033d6:	854a                	mv	a0,s2
    800033d8:	171000ef          	jal	80003d48 <releasesleep>
    acquire(&itable.lock);
    800033dc:	0001b517          	auipc	a0,0x1b
    800033e0:	fac50513          	addi	a0,a0,-84 # 8001e388 <itable>
    800033e4:	811fd0ef          	jal	80000bf4 <acquire>
    800033e8:	6902                	ld	s2,0(sp)
    800033ea:	bf69                	j	80003384 <iput+0x20>

00000000800033ec <iunlockput>:
{
    800033ec:	1101                	addi	sp,sp,-32
    800033ee:	ec06                	sd	ra,24(sp)
    800033f0:	e822                	sd	s0,16(sp)
    800033f2:	e426                	sd	s1,8(sp)
    800033f4:	1000                	addi	s0,sp,32
    800033f6:	84aa                	mv	s1,a0
  iunlock(ip);
    800033f8:	e99ff0ef          	jal	80003290 <iunlock>
  iput(ip);
    800033fc:	8526                	mv	a0,s1
    800033fe:	f67ff0ef          	jal	80003364 <iput>
}
    80003402:	60e2                	ld	ra,24(sp)
    80003404:	6442                	ld	s0,16(sp)
    80003406:	64a2                	ld	s1,8(sp)
    80003408:	6105                	addi	sp,sp,32
    8000340a:	8082                	ret

000000008000340c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000340c:	1141                	addi	sp,sp,-16
    8000340e:	e422                	sd	s0,8(sp)
    80003410:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003412:	411c                	lw	a5,0(a0)
    80003414:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003416:	415c                	lw	a5,4(a0)
    80003418:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000341a:	04451783          	lh	a5,68(a0)
    8000341e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003422:	04a51783          	lh	a5,74(a0)
    80003426:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000342a:	04c56783          	lwu	a5,76(a0)
    8000342e:	e99c                	sd	a5,16(a1)
}
    80003430:	6422                	ld	s0,8(sp)
    80003432:	0141                	addi	sp,sp,16
    80003434:	8082                	ret

0000000080003436 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003436:	457c                	lw	a5,76(a0)
    80003438:	0ed7eb63          	bltu	a5,a3,8000352e <readi+0xf8>
{
    8000343c:	7159                	addi	sp,sp,-112
    8000343e:	f486                	sd	ra,104(sp)
    80003440:	f0a2                	sd	s0,96(sp)
    80003442:	eca6                	sd	s1,88(sp)
    80003444:	e0d2                	sd	s4,64(sp)
    80003446:	fc56                	sd	s5,56(sp)
    80003448:	f85a                	sd	s6,48(sp)
    8000344a:	f45e                	sd	s7,40(sp)
    8000344c:	1880                	addi	s0,sp,112
    8000344e:	8b2a                	mv	s6,a0
    80003450:	8bae                	mv	s7,a1
    80003452:	8a32                	mv	s4,a2
    80003454:	84b6                	mv	s1,a3
    80003456:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003458:	9f35                	addw	a4,a4,a3
    return 0;
    8000345a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000345c:	0cd76063          	bltu	a4,a3,8000351c <readi+0xe6>
    80003460:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003462:	00e7f463          	bgeu	a5,a4,8000346a <readi+0x34>
    n = ip->size - off;
    80003466:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000346a:	080a8f63          	beqz	s5,80003508 <readi+0xd2>
    8000346e:	e8ca                	sd	s2,80(sp)
    80003470:	f062                	sd	s8,32(sp)
    80003472:	ec66                	sd	s9,24(sp)
    80003474:	e86a                	sd	s10,16(sp)
    80003476:	e46e                	sd	s11,8(sp)
    80003478:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000347a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000347e:	5c7d                	li	s8,-1
    80003480:	a80d                	j	800034b2 <readi+0x7c>
    80003482:	020d1d93          	slli	s11,s10,0x20
    80003486:	020ddd93          	srli	s11,s11,0x20
    8000348a:	05890613          	addi	a2,s2,88
    8000348e:	86ee                	mv	a3,s11
    80003490:	963a                	add	a2,a2,a4
    80003492:	85d2                	mv	a1,s4
    80003494:	855e                	mv	a0,s7
    80003496:	d97fe0ef          	jal	8000222c <either_copyout>
    8000349a:	05850763          	beq	a0,s8,800034e8 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000349e:	854a                	mv	a0,s2
    800034a0:	f12ff0ef          	jal	80002bb2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800034a4:	013d09bb          	addw	s3,s10,s3
    800034a8:	009d04bb          	addw	s1,s10,s1
    800034ac:	9a6e                	add	s4,s4,s11
    800034ae:	0559f763          	bgeu	s3,s5,800034fc <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    800034b2:	00a4d59b          	srliw	a1,s1,0xa
    800034b6:	855a                	mv	a0,s6
    800034b8:	977ff0ef          	jal	80002e2e <bmap>
    800034bc:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800034c0:	c5b1                	beqz	a1,8000350c <readi+0xd6>
    bp = bread(ip->dev, addr);
    800034c2:	000b2503          	lw	a0,0(s6)
    800034c6:	de4ff0ef          	jal	80002aaa <bread>
    800034ca:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800034cc:	3ff4f713          	andi	a4,s1,1023
    800034d0:	40ec87bb          	subw	a5,s9,a4
    800034d4:	413a86bb          	subw	a3,s5,s3
    800034d8:	8d3e                	mv	s10,a5
    800034da:	2781                	sext.w	a5,a5
    800034dc:	0006861b          	sext.w	a2,a3
    800034e0:	faf671e3          	bgeu	a2,a5,80003482 <readi+0x4c>
    800034e4:	8d36                	mv	s10,a3
    800034e6:	bf71                	j	80003482 <readi+0x4c>
      brelse(bp);
    800034e8:	854a                	mv	a0,s2
    800034ea:	ec8ff0ef          	jal	80002bb2 <brelse>
      tot = -1;
    800034ee:	59fd                	li	s3,-1
      break;
    800034f0:	6946                	ld	s2,80(sp)
    800034f2:	7c02                	ld	s8,32(sp)
    800034f4:	6ce2                	ld	s9,24(sp)
    800034f6:	6d42                	ld	s10,16(sp)
    800034f8:	6da2                	ld	s11,8(sp)
    800034fa:	a831                	j	80003516 <readi+0xe0>
    800034fc:	6946                	ld	s2,80(sp)
    800034fe:	7c02                	ld	s8,32(sp)
    80003500:	6ce2                	ld	s9,24(sp)
    80003502:	6d42                	ld	s10,16(sp)
    80003504:	6da2                	ld	s11,8(sp)
    80003506:	a801                	j	80003516 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003508:	89d6                	mv	s3,s5
    8000350a:	a031                	j	80003516 <readi+0xe0>
    8000350c:	6946                	ld	s2,80(sp)
    8000350e:	7c02                	ld	s8,32(sp)
    80003510:	6ce2                	ld	s9,24(sp)
    80003512:	6d42                	ld	s10,16(sp)
    80003514:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003516:	0009851b          	sext.w	a0,s3
    8000351a:	69a6                	ld	s3,72(sp)
}
    8000351c:	70a6                	ld	ra,104(sp)
    8000351e:	7406                	ld	s0,96(sp)
    80003520:	64e6                	ld	s1,88(sp)
    80003522:	6a06                	ld	s4,64(sp)
    80003524:	7ae2                	ld	s5,56(sp)
    80003526:	7b42                	ld	s6,48(sp)
    80003528:	7ba2                	ld	s7,40(sp)
    8000352a:	6165                	addi	sp,sp,112
    8000352c:	8082                	ret
    return 0;
    8000352e:	4501                	li	a0,0
}
    80003530:	8082                	ret

0000000080003532 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003532:	457c                	lw	a5,76(a0)
    80003534:	10d7e063          	bltu	a5,a3,80003634 <writei+0x102>
{
    80003538:	7159                	addi	sp,sp,-112
    8000353a:	f486                	sd	ra,104(sp)
    8000353c:	f0a2                	sd	s0,96(sp)
    8000353e:	e8ca                	sd	s2,80(sp)
    80003540:	e0d2                	sd	s4,64(sp)
    80003542:	fc56                	sd	s5,56(sp)
    80003544:	f85a                	sd	s6,48(sp)
    80003546:	f45e                	sd	s7,40(sp)
    80003548:	1880                	addi	s0,sp,112
    8000354a:	8aaa                	mv	s5,a0
    8000354c:	8bae                	mv	s7,a1
    8000354e:	8a32                	mv	s4,a2
    80003550:	8936                	mv	s2,a3
    80003552:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003554:	00e687bb          	addw	a5,a3,a4
    80003558:	0ed7e063          	bltu	a5,a3,80003638 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000355c:	00043737          	lui	a4,0x43
    80003560:	0cf76e63          	bltu	a4,a5,8000363c <writei+0x10a>
    80003564:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003566:	0a0b0f63          	beqz	s6,80003624 <writei+0xf2>
    8000356a:	eca6                	sd	s1,88(sp)
    8000356c:	f062                	sd	s8,32(sp)
    8000356e:	ec66                	sd	s9,24(sp)
    80003570:	e86a                	sd	s10,16(sp)
    80003572:	e46e                	sd	s11,8(sp)
    80003574:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003576:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000357a:	5c7d                	li	s8,-1
    8000357c:	a825                	j	800035b4 <writei+0x82>
    8000357e:	020d1d93          	slli	s11,s10,0x20
    80003582:	020ddd93          	srli	s11,s11,0x20
    80003586:	05848513          	addi	a0,s1,88
    8000358a:	86ee                	mv	a3,s11
    8000358c:	8652                	mv	a2,s4
    8000358e:	85de                	mv	a1,s7
    80003590:	953a                	add	a0,a0,a4
    80003592:	ce5fe0ef          	jal	80002276 <either_copyin>
    80003596:	05850a63          	beq	a0,s8,800035ea <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000359a:	8526                	mv	a0,s1
    8000359c:	660000ef          	jal	80003bfc <log_write>
    brelse(bp);
    800035a0:	8526                	mv	a0,s1
    800035a2:	e10ff0ef          	jal	80002bb2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800035a6:	013d09bb          	addw	s3,s10,s3
    800035aa:	012d093b          	addw	s2,s10,s2
    800035ae:	9a6e                	add	s4,s4,s11
    800035b0:	0569f063          	bgeu	s3,s6,800035f0 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800035b4:	00a9559b          	srliw	a1,s2,0xa
    800035b8:	8556                	mv	a0,s5
    800035ba:	875ff0ef          	jal	80002e2e <bmap>
    800035be:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800035c2:	c59d                	beqz	a1,800035f0 <writei+0xbe>
    bp = bread(ip->dev, addr);
    800035c4:	000aa503          	lw	a0,0(s5)
    800035c8:	ce2ff0ef          	jal	80002aaa <bread>
    800035cc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800035ce:	3ff97713          	andi	a4,s2,1023
    800035d2:	40ec87bb          	subw	a5,s9,a4
    800035d6:	413b06bb          	subw	a3,s6,s3
    800035da:	8d3e                	mv	s10,a5
    800035dc:	2781                	sext.w	a5,a5
    800035de:	0006861b          	sext.w	a2,a3
    800035e2:	f8f67ee3          	bgeu	a2,a5,8000357e <writei+0x4c>
    800035e6:	8d36                	mv	s10,a3
    800035e8:	bf59                	j	8000357e <writei+0x4c>
      brelse(bp);
    800035ea:	8526                	mv	a0,s1
    800035ec:	dc6ff0ef          	jal	80002bb2 <brelse>
  }

  if(off > ip->size)
    800035f0:	04caa783          	lw	a5,76(s5)
    800035f4:	0327fa63          	bgeu	a5,s2,80003628 <writei+0xf6>
    ip->size = off;
    800035f8:	052aa623          	sw	s2,76(s5)
    800035fc:	64e6                	ld	s1,88(sp)
    800035fe:	7c02                	ld	s8,32(sp)
    80003600:	6ce2                	ld	s9,24(sp)
    80003602:	6d42                	ld	s10,16(sp)
    80003604:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003606:	8556                	mv	a0,s5
    80003608:	b27ff0ef          	jal	8000312e <iupdate>

  return tot;
    8000360c:	0009851b          	sext.w	a0,s3
    80003610:	69a6                	ld	s3,72(sp)
}
    80003612:	70a6                	ld	ra,104(sp)
    80003614:	7406                	ld	s0,96(sp)
    80003616:	6946                	ld	s2,80(sp)
    80003618:	6a06                	ld	s4,64(sp)
    8000361a:	7ae2                	ld	s5,56(sp)
    8000361c:	7b42                	ld	s6,48(sp)
    8000361e:	7ba2                	ld	s7,40(sp)
    80003620:	6165                	addi	sp,sp,112
    80003622:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003624:	89da                	mv	s3,s6
    80003626:	b7c5                	j	80003606 <writei+0xd4>
    80003628:	64e6                	ld	s1,88(sp)
    8000362a:	7c02                	ld	s8,32(sp)
    8000362c:	6ce2                	ld	s9,24(sp)
    8000362e:	6d42                	ld	s10,16(sp)
    80003630:	6da2                	ld	s11,8(sp)
    80003632:	bfd1                	j	80003606 <writei+0xd4>
    return -1;
    80003634:	557d                	li	a0,-1
}
    80003636:	8082                	ret
    return -1;
    80003638:	557d                	li	a0,-1
    8000363a:	bfe1                	j	80003612 <writei+0xe0>
    return -1;
    8000363c:	557d                	li	a0,-1
    8000363e:	bfd1                	j	80003612 <writei+0xe0>

0000000080003640 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003640:	1141                	addi	sp,sp,-16
    80003642:	e406                	sd	ra,8(sp)
    80003644:	e022                	sd	s0,0(sp)
    80003646:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003648:	4639                	li	a2,14
    8000364a:	f4afd0ef          	jal	80000d94 <strncmp>
}
    8000364e:	60a2                	ld	ra,8(sp)
    80003650:	6402                	ld	s0,0(sp)
    80003652:	0141                	addi	sp,sp,16
    80003654:	8082                	ret

0000000080003656 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003656:	7139                	addi	sp,sp,-64
    80003658:	fc06                	sd	ra,56(sp)
    8000365a:	f822                	sd	s0,48(sp)
    8000365c:	f426                	sd	s1,40(sp)
    8000365e:	f04a                	sd	s2,32(sp)
    80003660:	ec4e                	sd	s3,24(sp)
    80003662:	e852                	sd	s4,16(sp)
    80003664:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003666:	04451703          	lh	a4,68(a0)
    8000366a:	4785                	li	a5,1
    8000366c:	00f71a63          	bne	a4,a5,80003680 <dirlookup+0x2a>
    80003670:	892a                	mv	s2,a0
    80003672:	89ae                	mv	s3,a1
    80003674:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003676:	457c                	lw	a5,76(a0)
    80003678:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000367a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000367c:	e39d                	bnez	a5,800036a2 <dirlookup+0x4c>
    8000367e:	a095                	j	800036e2 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003680:	00004517          	auipc	a0,0x4
    80003684:	ed050513          	addi	a0,a0,-304 # 80007550 <etext+0x550>
    80003688:	90cfd0ef          	jal	80000794 <panic>
      panic("dirlookup read");
    8000368c:	00004517          	auipc	a0,0x4
    80003690:	edc50513          	addi	a0,a0,-292 # 80007568 <etext+0x568>
    80003694:	900fd0ef          	jal	80000794 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003698:	24c1                	addiw	s1,s1,16
    8000369a:	04c92783          	lw	a5,76(s2)
    8000369e:	04f4f163          	bgeu	s1,a5,800036e0 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800036a2:	4741                	li	a4,16
    800036a4:	86a6                	mv	a3,s1
    800036a6:	fc040613          	addi	a2,s0,-64
    800036aa:	4581                	li	a1,0
    800036ac:	854a                	mv	a0,s2
    800036ae:	d89ff0ef          	jal	80003436 <readi>
    800036b2:	47c1                	li	a5,16
    800036b4:	fcf51ce3          	bne	a0,a5,8000368c <dirlookup+0x36>
    if(de.inum == 0)
    800036b8:	fc045783          	lhu	a5,-64(s0)
    800036bc:	dff1                	beqz	a5,80003698 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    800036be:	fc240593          	addi	a1,s0,-62
    800036c2:	854e                	mv	a0,s3
    800036c4:	f7dff0ef          	jal	80003640 <namecmp>
    800036c8:	f961                	bnez	a0,80003698 <dirlookup+0x42>
      if(poff)
    800036ca:	000a0463          	beqz	s4,800036d2 <dirlookup+0x7c>
        *poff = off;
    800036ce:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800036d2:	fc045583          	lhu	a1,-64(s0)
    800036d6:	00092503          	lw	a0,0(s2)
    800036da:	829ff0ef          	jal	80002f02 <iget>
    800036de:	a011                	j	800036e2 <dirlookup+0x8c>
  return 0;
    800036e0:	4501                	li	a0,0
}
    800036e2:	70e2                	ld	ra,56(sp)
    800036e4:	7442                	ld	s0,48(sp)
    800036e6:	74a2                	ld	s1,40(sp)
    800036e8:	7902                	ld	s2,32(sp)
    800036ea:	69e2                	ld	s3,24(sp)
    800036ec:	6a42                	ld	s4,16(sp)
    800036ee:	6121                	addi	sp,sp,64
    800036f0:	8082                	ret

00000000800036f2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800036f2:	711d                	addi	sp,sp,-96
    800036f4:	ec86                	sd	ra,88(sp)
    800036f6:	e8a2                	sd	s0,80(sp)
    800036f8:	e4a6                	sd	s1,72(sp)
    800036fa:	e0ca                	sd	s2,64(sp)
    800036fc:	fc4e                	sd	s3,56(sp)
    800036fe:	f852                	sd	s4,48(sp)
    80003700:	f456                	sd	s5,40(sp)
    80003702:	f05a                	sd	s6,32(sp)
    80003704:	ec5e                	sd	s7,24(sp)
    80003706:	e862                	sd	s8,16(sp)
    80003708:	e466                	sd	s9,8(sp)
    8000370a:	1080                	addi	s0,sp,96
    8000370c:	84aa                	mv	s1,a0
    8000370e:	8b2e                	mv	s6,a1
    80003710:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003712:	00054703          	lbu	a4,0(a0)
    80003716:	02f00793          	li	a5,47
    8000371a:	00f70e63          	beq	a4,a5,80003736 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000371e:	9ccfe0ef          	jal	800018ea <myproc>
    80003722:	15053503          	ld	a0,336(a0)
    80003726:	a87ff0ef          	jal	800031ac <idup>
    8000372a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000372c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003730:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003732:	4b85                	li	s7,1
    80003734:	a871                	j	800037d0 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003736:	4585                	li	a1,1
    80003738:	4505                	li	a0,1
    8000373a:	fc8ff0ef          	jal	80002f02 <iget>
    8000373e:	8a2a                	mv	s4,a0
    80003740:	b7f5                	j	8000372c <namex+0x3a>
      iunlockput(ip);
    80003742:	8552                	mv	a0,s4
    80003744:	ca9ff0ef          	jal	800033ec <iunlockput>
      return 0;
    80003748:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000374a:	8552                	mv	a0,s4
    8000374c:	60e6                	ld	ra,88(sp)
    8000374e:	6446                	ld	s0,80(sp)
    80003750:	64a6                	ld	s1,72(sp)
    80003752:	6906                	ld	s2,64(sp)
    80003754:	79e2                	ld	s3,56(sp)
    80003756:	7a42                	ld	s4,48(sp)
    80003758:	7aa2                	ld	s5,40(sp)
    8000375a:	7b02                	ld	s6,32(sp)
    8000375c:	6be2                	ld	s7,24(sp)
    8000375e:	6c42                	ld	s8,16(sp)
    80003760:	6ca2                	ld	s9,8(sp)
    80003762:	6125                	addi	sp,sp,96
    80003764:	8082                	ret
      iunlock(ip);
    80003766:	8552                	mv	a0,s4
    80003768:	b29ff0ef          	jal	80003290 <iunlock>
      return ip;
    8000376c:	bff9                	j	8000374a <namex+0x58>
      iunlockput(ip);
    8000376e:	8552                	mv	a0,s4
    80003770:	c7dff0ef          	jal	800033ec <iunlockput>
      return 0;
    80003774:	8a4e                	mv	s4,s3
    80003776:	bfd1                	j	8000374a <namex+0x58>
  len = path - s;
    80003778:	40998633          	sub	a2,s3,s1
    8000377c:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003780:	099c5063          	bge	s8,s9,80003800 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003784:	4639                	li	a2,14
    80003786:	85a6                	mv	a1,s1
    80003788:	8556                	mv	a0,s5
    8000378a:	d9afd0ef          	jal	80000d24 <memmove>
    8000378e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003790:	0004c783          	lbu	a5,0(s1)
    80003794:	01279763          	bne	a5,s2,800037a2 <namex+0xb0>
    path++;
    80003798:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000379a:	0004c783          	lbu	a5,0(s1)
    8000379e:	ff278de3          	beq	a5,s2,80003798 <namex+0xa6>
    ilock(ip);
    800037a2:	8552                	mv	a0,s4
    800037a4:	a3fff0ef          	jal	800031e2 <ilock>
    if(ip->type != T_DIR){
    800037a8:	044a1783          	lh	a5,68(s4)
    800037ac:	f9779be3          	bne	a5,s7,80003742 <namex+0x50>
    if(nameiparent && *path == '\0'){
    800037b0:	000b0563          	beqz	s6,800037ba <namex+0xc8>
    800037b4:	0004c783          	lbu	a5,0(s1)
    800037b8:	d7dd                	beqz	a5,80003766 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    800037ba:	4601                	li	a2,0
    800037bc:	85d6                	mv	a1,s5
    800037be:	8552                	mv	a0,s4
    800037c0:	e97ff0ef          	jal	80003656 <dirlookup>
    800037c4:	89aa                	mv	s3,a0
    800037c6:	d545                	beqz	a0,8000376e <namex+0x7c>
    iunlockput(ip);
    800037c8:	8552                	mv	a0,s4
    800037ca:	c23ff0ef          	jal	800033ec <iunlockput>
    ip = next;
    800037ce:	8a4e                	mv	s4,s3
  while(*path == '/')
    800037d0:	0004c783          	lbu	a5,0(s1)
    800037d4:	01279763          	bne	a5,s2,800037e2 <namex+0xf0>
    path++;
    800037d8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800037da:	0004c783          	lbu	a5,0(s1)
    800037de:	ff278de3          	beq	a5,s2,800037d8 <namex+0xe6>
  if(*path == 0)
    800037e2:	cb8d                	beqz	a5,80003814 <namex+0x122>
  while(*path != '/' && *path != 0)
    800037e4:	0004c783          	lbu	a5,0(s1)
    800037e8:	89a6                	mv	s3,s1
  len = path - s;
    800037ea:	4c81                	li	s9,0
    800037ec:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800037ee:	01278963          	beq	a5,s2,80003800 <namex+0x10e>
    800037f2:	d3d9                	beqz	a5,80003778 <namex+0x86>
    path++;
    800037f4:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800037f6:	0009c783          	lbu	a5,0(s3)
    800037fa:	ff279ce3          	bne	a5,s2,800037f2 <namex+0x100>
    800037fe:	bfad                	j	80003778 <namex+0x86>
    memmove(name, s, len);
    80003800:	2601                	sext.w	a2,a2
    80003802:	85a6                	mv	a1,s1
    80003804:	8556                	mv	a0,s5
    80003806:	d1efd0ef          	jal	80000d24 <memmove>
    name[len] = 0;
    8000380a:	9cd6                	add	s9,s9,s5
    8000380c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003810:	84ce                	mv	s1,s3
    80003812:	bfbd                	j	80003790 <namex+0x9e>
  if(nameiparent){
    80003814:	f20b0be3          	beqz	s6,8000374a <namex+0x58>
    iput(ip);
    80003818:	8552                	mv	a0,s4
    8000381a:	b4bff0ef          	jal	80003364 <iput>
    return 0;
    8000381e:	4a01                	li	s4,0
    80003820:	b72d                	j	8000374a <namex+0x58>

0000000080003822 <dirlink>:
{
    80003822:	7139                	addi	sp,sp,-64
    80003824:	fc06                	sd	ra,56(sp)
    80003826:	f822                	sd	s0,48(sp)
    80003828:	f04a                	sd	s2,32(sp)
    8000382a:	ec4e                	sd	s3,24(sp)
    8000382c:	e852                	sd	s4,16(sp)
    8000382e:	0080                	addi	s0,sp,64
    80003830:	892a                	mv	s2,a0
    80003832:	8a2e                	mv	s4,a1
    80003834:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003836:	4601                	li	a2,0
    80003838:	e1fff0ef          	jal	80003656 <dirlookup>
    8000383c:	e535                	bnez	a0,800038a8 <dirlink+0x86>
    8000383e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003840:	04c92483          	lw	s1,76(s2)
    80003844:	c48d                	beqz	s1,8000386e <dirlink+0x4c>
    80003846:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003848:	4741                	li	a4,16
    8000384a:	86a6                	mv	a3,s1
    8000384c:	fc040613          	addi	a2,s0,-64
    80003850:	4581                	li	a1,0
    80003852:	854a                	mv	a0,s2
    80003854:	be3ff0ef          	jal	80003436 <readi>
    80003858:	47c1                	li	a5,16
    8000385a:	04f51b63          	bne	a0,a5,800038b0 <dirlink+0x8e>
    if(de.inum == 0)
    8000385e:	fc045783          	lhu	a5,-64(s0)
    80003862:	c791                	beqz	a5,8000386e <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003864:	24c1                	addiw	s1,s1,16
    80003866:	04c92783          	lw	a5,76(s2)
    8000386a:	fcf4efe3          	bltu	s1,a5,80003848 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    8000386e:	4639                	li	a2,14
    80003870:	85d2                	mv	a1,s4
    80003872:	fc240513          	addi	a0,s0,-62
    80003876:	d54fd0ef          	jal	80000dca <strncpy>
  de.inum = inum;
    8000387a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000387e:	4741                	li	a4,16
    80003880:	86a6                	mv	a3,s1
    80003882:	fc040613          	addi	a2,s0,-64
    80003886:	4581                	li	a1,0
    80003888:	854a                	mv	a0,s2
    8000388a:	ca9ff0ef          	jal	80003532 <writei>
    8000388e:	1541                	addi	a0,a0,-16
    80003890:	00a03533          	snez	a0,a0
    80003894:	40a00533          	neg	a0,a0
    80003898:	74a2                	ld	s1,40(sp)
}
    8000389a:	70e2                	ld	ra,56(sp)
    8000389c:	7442                	ld	s0,48(sp)
    8000389e:	7902                	ld	s2,32(sp)
    800038a0:	69e2                	ld	s3,24(sp)
    800038a2:	6a42                	ld	s4,16(sp)
    800038a4:	6121                	addi	sp,sp,64
    800038a6:	8082                	ret
    iput(ip);
    800038a8:	abdff0ef          	jal	80003364 <iput>
    return -1;
    800038ac:	557d                	li	a0,-1
    800038ae:	b7f5                	j	8000389a <dirlink+0x78>
      panic("dirlink read");
    800038b0:	00004517          	auipc	a0,0x4
    800038b4:	cc850513          	addi	a0,a0,-824 # 80007578 <etext+0x578>
    800038b8:	eddfc0ef          	jal	80000794 <panic>

00000000800038bc <namei>:

struct inode*
namei(char *path)
{
    800038bc:	1101                	addi	sp,sp,-32
    800038be:	ec06                	sd	ra,24(sp)
    800038c0:	e822                	sd	s0,16(sp)
    800038c2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800038c4:	fe040613          	addi	a2,s0,-32
    800038c8:	4581                	li	a1,0
    800038ca:	e29ff0ef          	jal	800036f2 <namex>
}
    800038ce:	60e2                	ld	ra,24(sp)
    800038d0:	6442                	ld	s0,16(sp)
    800038d2:	6105                	addi	sp,sp,32
    800038d4:	8082                	ret

00000000800038d6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800038d6:	1141                	addi	sp,sp,-16
    800038d8:	e406                	sd	ra,8(sp)
    800038da:	e022                	sd	s0,0(sp)
    800038dc:	0800                	addi	s0,sp,16
    800038de:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800038e0:	4585                	li	a1,1
    800038e2:	e11ff0ef          	jal	800036f2 <namex>
}
    800038e6:	60a2                	ld	ra,8(sp)
    800038e8:	6402                	ld	s0,0(sp)
    800038ea:	0141                	addi	sp,sp,16
    800038ec:	8082                	ret

00000000800038ee <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800038ee:	1101                	addi	sp,sp,-32
    800038f0:	ec06                	sd	ra,24(sp)
    800038f2:	e822                	sd	s0,16(sp)
    800038f4:	e426                	sd	s1,8(sp)
    800038f6:	e04a                	sd	s2,0(sp)
    800038f8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800038fa:	0001c917          	auipc	s2,0x1c
    800038fe:	53690913          	addi	s2,s2,1334 # 8001fe30 <log>
    80003902:	01892583          	lw	a1,24(s2)
    80003906:	02892503          	lw	a0,40(s2)
    8000390a:	9a0ff0ef          	jal	80002aaa <bread>
    8000390e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003910:	02c92603          	lw	a2,44(s2)
    80003914:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003916:	00c05f63          	blez	a2,80003934 <write_head+0x46>
    8000391a:	0001c717          	auipc	a4,0x1c
    8000391e:	54670713          	addi	a4,a4,1350 # 8001fe60 <log+0x30>
    80003922:	87aa                	mv	a5,a0
    80003924:	060a                	slli	a2,a2,0x2
    80003926:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003928:	4314                	lw	a3,0(a4)
    8000392a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000392c:	0711                	addi	a4,a4,4
    8000392e:	0791                	addi	a5,a5,4
    80003930:	fec79ce3          	bne	a5,a2,80003928 <write_head+0x3a>
  }
  bwrite(buf);
    80003934:	8526                	mv	a0,s1
    80003936:	a4aff0ef          	jal	80002b80 <bwrite>
  brelse(buf);
    8000393a:	8526                	mv	a0,s1
    8000393c:	a76ff0ef          	jal	80002bb2 <brelse>
}
    80003940:	60e2                	ld	ra,24(sp)
    80003942:	6442                	ld	s0,16(sp)
    80003944:	64a2                	ld	s1,8(sp)
    80003946:	6902                	ld	s2,0(sp)
    80003948:	6105                	addi	sp,sp,32
    8000394a:	8082                	ret

000000008000394c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000394c:	0001c797          	auipc	a5,0x1c
    80003950:	5107a783          	lw	a5,1296(a5) # 8001fe5c <log+0x2c>
    80003954:	08f05f63          	blez	a5,800039f2 <install_trans+0xa6>
{
    80003958:	7139                	addi	sp,sp,-64
    8000395a:	fc06                	sd	ra,56(sp)
    8000395c:	f822                	sd	s0,48(sp)
    8000395e:	f426                	sd	s1,40(sp)
    80003960:	f04a                	sd	s2,32(sp)
    80003962:	ec4e                	sd	s3,24(sp)
    80003964:	e852                	sd	s4,16(sp)
    80003966:	e456                	sd	s5,8(sp)
    80003968:	e05a                	sd	s6,0(sp)
    8000396a:	0080                	addi	s0,sp,64
    8000396c:	8b2a                	mv	s6,a0
    8000396e:	0001ca97          	auipc	s5,0x1c
    80003972:	4f2a8a93          	addi	s5,s5,1266 # 8001fe60 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003976:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003978:	0001c997          	auipc	s3,0x1c
    8000397c:	4b898993          	addi	s3,s3,1208 # 8001fe30 <log>
    80003980:	a829                	j	8000399a <install_trans+0x4e>
    brelse(lbuf);
    80003982:	854a                	mv	a0,s2
    80003984:	a2eff0ef          	jal	80002bb2 <brelse>
    brelse(dbuf);
    80003988:	8526                	mv	a0,s1
    8000398a:	a28ff0ef          	jal	80002bb2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000398e:	2a05                	addiw	s4,s4,1
    80003990:	0a91                	addi	s5,s5,4
    80003992:	02c9a783          	lw	a5,44(s3)
    80003996:	04fa5463          	bge	s4,a5,800039de <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000399a:	0189a583          	lw	a1,24(s3)
    8000399e:	014585bb          	addw	a1,a1,s4
    800039a2:	2585                	addiw	a1,a1,1
    800039a4:	0289a503          	lw	a0,40(s3)
    800039a8:	902ff0ef          	jal	80002aaa <bread>
    800039ac:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800039ae:	000aa583          	lw	a1,0(s5)
    800039b2:	0289a503          	lw	a0,40(s3)
    800039b6:	8f4ff0ef          	jal	80002aaa <bread>
    800039ba:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800039bc:	40000613          	li	a2,1024
    800039c0:	05890593          	addi	a1,s2,88
    800039c4:	05850513          	addi	a0,a0,88
    800039c8:	b5cfd0ef          	jal	80000d24 <memmove>
    bwrite(dbuf);  // write dst to disk
    800039cc:	8526                	mv	a0,s1
    800039ce:	9b2ff0ef          	jal	80002b80 <bwrite>
    if(recovering == 0)
    800039d2:	fa0b18e3          	bnez	s6,80003982 <install_trans+0x36>
      bunpin(dbuf);
    800039d6:	8526                	mv	a0,s1
    800039d8:	a96ff0ef          	jal	80002c6e <bunpin>
    800039dc:	b75d                	j	80003982 <install_trans+0x36>
}
    800039de:	70e2                	ld	ra,56(sp)
    800039e0:	7442                	ld	s0,48(sp)
    800039e2:	74a2                	ld	s1,40(sp)
    800039e4:	7902                	ld	s2,32(sp)
    800039e6:	69e2                	ld	s3,24(sp)
    800039e8:	6a42                	ld	s4,16(sp)
    800039ea:	6aa2                	ld	s5,8(sp)
    800039ec:	6b02                	ld	s6,0(sp)
    800039ee:	6121                	addi	sp,sp,64
    800039f0:	8082                	ret
    800039f2:	8082                	ret

00000000800039f4 <initlog>:
{
    800039f4:	7179                	addi	sp,sp,-48
    800039f6:	f406                	sd	ra,40(sp)
    800039f8:	f022                	sd	s0,32(sp)
    800039fa:	ec26                	sd	s1,24(sp)
    800039fc:	e84a                	sd	s2,16(sp)
    800039fe:	e44e                	sd	s3,8(sp)
    80003a00:	1800                	addi	s0,sp,48
    80003a02:	892a                	mv	s2,a0
    80003a04:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003a06:	0001c497          	auipc	s1,0x1c
    80003a0a:	42a48493          	addi	s1,s1,1066 # 8001fe30 <log>
    80003a0e:	00004597          	auipc	a1,0x4
    80003a12:	b7a58593          	addi	a1,a1,-1158 # 80007588 <etext+0x588>
    80003a16:	8526                	mv	a0,s1
    80003a18:	95cfd0ef          	jal	80000b74 <initlock>
  log.start = sb->logstart;
    80003a1c:	0149a583          	lw	a1,20(s3)
    80003a20:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003a22:	0109a783          	lw	a5,16(s3)
    80003a26:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003a28:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003a2c:	854a                	mv	a0,s2
    80003a2e:	87cff0ef          	jal	80002aaa <bread>
  log.lh.n = lh->n;
    80003a32:	4d30                	lw	a2,88(a0)
    80003a34:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003a36:	00c05f63          	blez	a2,80003a54 <initlog+0x60>
    80003a3a:	87aa                	mv	a5,a0
    80003a3c:	0001c717          	auipc	a4,0x1c
    80003a40:	42470713          	addi	a4,a4,1060 # 8001fe60 <log+0x30>
    80003a44:	060a                	slli	a2,a2,0x2
    80003a46:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003a48:	4ff4                	lw	a3,92(a5)
    80003a4a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003a4c:	0791                	addi	a5,a5,4
    80003a4e:	0711                	addi	a4,a4,4
    80003a50:	fec79ce3          	bne	a5,a2,80003a48 <initlog+0x54>
  brelse(buf);
    80003a54:	95eff0ef          	jal	80002bb2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003a58:	4505                	li	a0,1
    80003a5a:	ef3ff0ef          	jal	8000394c <install_trans>
  log.lh.n = 0;
    80003a5e:	0001c797          	auipc	a5,0x1c
    80003a62:	3e07af23          	sw	zero,1022(a5) # 8001fe5c <log+0x2c>
  write_head(); // clear the log
    80003a66:	e89ff0ef          	jal	800038ee <write_head>
}
    80003a6a:	70a2                	ld	ra,40(sp)
    80003a6c:	7402                	ld	s0,32(sp)
    80003a6e:	64e2                	ld	s1,24(sp)
    80003a70:	6942                	ld	s2,16(sp)
    80003a72:	69a2                	ld	s3,8(sp)
    80003a74:	6145                	addi	sp,sp,48
    80003a76:	8082                	ret

0000000080003a78 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003a78:	1101                	addi	sp,sp,-32
    80003a7a:	ec06                	sd	ra,24(sp)
    80003a7c:	e822                	sd	s0,16(sp)
    80003a7e:	e426                	sd	s1,8(sp)
    80003a80:	e04a                	sd	s2,0(sp)
    80003a82:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003a84:	0001c517          	auipc	a0,0x1c
    80003a88:	3ac50513          	addi	a0,a0,940 # 8001fe30 <log>
    80003a8c:	968fd0ef          	jal	80000bf4 <acquire>
  while(1){
    if(log.committing){
    80003a90:	0001c497          	auipc	s1,0x1c
    80003a94:	3a048493          	addi	s1,s1,928 # 8001fe30 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003a98:	4979                	li	s2,30
    80003a9a:	a029                	j	80003aa4 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003a9c:	85a6                	mv	a1,s1
    80003a9e:	8526                	mv	a0,s1
    80003aa0:	c30fe0ef          	jal	80001ed0 <sleep>
    if(log.committing){
    80003aa4:	50dc                	lw	a5,36(s1)
    80003aa6:	fbfd                	bnez	a5,80003a9c <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003aa8:	5098                	lw	a4,32(s1)
    80003aaa:	2705                	addiw	a4,a4,1
    80003aac:	0027179b          	slliw	a5,a4,0x2
    80003ab0:	9fb9                	addw	a5,a5,a4
    80003ab2:	0017979b          	slliw	a5,a5,0x1
    80003ab6:	54d4                	lw	a3,44(s1)
    80003ab8:	9fb5                	addw	a5,a5,a3
    80003aba:	00f95763          	bge	s2,a5,80003ac8 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003abe:	85a6                	mv	a1,s1
    80003ac0:	8526                	mv	a0,s1
    80003ac2:	c0efe0ef          	jal	80001ed0 <sleep>
    80003ac6:	bff9                	j	80003aa4 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003ac8:	0001c517          	auipc	a0,0x1c
    80003acc:	36850513          	addi	a0,a0,872 # 8001fe30 <log>
    80003ad0:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003ad2:	9bafd0ef          	jal	80000c8c <release>
      break;
    }
  }
}
    80003ad6:	60e2                	ld	ra,24(sp)
    80003ad8:	6442                	ld	s0,16(sp)
    80003ada:	64a2                	ld	s1,8(sp)
    80003adc:	6902                	ld	s2,0(sp)
    80003ade:	6105                	addi	sp,sp,32
    80003ae0:	8082                	ret

0000000080003ae2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003ae2:	7139                	addi	sp,sp,-64
    80003ae4:	fc06                	sd	ra,56(sp)
    80003ae6:	f822                	sd	s0,48(sp)
    80003ae8:	f426                	sd	s1,40(sp)
    80003aea:	f04a                	sd	s2,32(sp)
    80003aec:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003aee:	0001c497          	auipc	s1,0x1c
    80003af2:	34248493          	addi	s1,s1,834 # 8001fe30 <log>
    80003af6:	8526                	mv	a0,s1
    80003af8:	8fcfd0ef          	jal	80000bf4 <acquire>
  log.outstanding -= 1;
    80003afc:	509c                	lw	a5,32(s1)
    80003afe:	37fd                	addiw	a5,a5,-1
    80003b00:	0007891b          	sext.w	s2,a5
    80003b04:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003b06:	50dc                	lw	a5,36(s1)
    80003b08:	ef9d                	bnez	a5,80003b46 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003b0a:	04091763          	bnez	s2,80003b58 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003b0e:	0001c497          	auipc	s1,0x1c
    80003b12:	32248493          	addi	s1,s1,802 # 8001fe30 <log>
    80003b16:	4785                	li	a5,1
    80003b18:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003b1a:	8526                	mv	a0,s1
    80003b1c:	970fd0ef          	jal	80000c8c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003b20:	54dc                	lw	a5,44(s1)
    80003b22:	04f04b63          	bgtz	a5,80003b78 <end_op+0x96>
    acquire(&log.lock);
    80003b26:	0001c497          	auipc	s1,0x1c
    80003b2a:	30a48493          	addi	s1,s1,778 # 8001fe30 <log>
    80003b2e:	8526                	mv	a0,s1
    80003b30:	8c4fd0ef          	jal	80000bf4 <acquire>
    log.committing = 0;
    80003b34:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003b38:	8526                	mv	a0,s1
    80003b3a:	be2fe0ef          	jal	80001f1c <wakeup>
    release(&log.lock);
    80003b3e:	8526                	mv	a0,s1
    80003b40:	94cfd0ef          	jal	80000c8c <release>
}
    80003b44:	a025                	j	80003b6c <end_op+0x8a>
    80003b46:	ec4e                	sd	s3,24(sp)
    80003b48:	e852                	sd	s4,16(sp)
    80003b4a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003b4c:	00004517          	auipc	a0,0x4
    80003b50:	a4450513          	addi	a0,a0,-1468 # 80007590 <etext+0x590>
    80003b54:	c41fc0ef          	jal	80000794 <panic>
    wakeup(&log);
    80003b58:	0001c497          	auipc	s1,0x1c
    80003b5c:	2d848493          	addi	s1,s1,728 # 8001fe30 <log>
    80003b60:	8526                	mv	a0,s1
    80003b62:	bbafe0ef          	jal	80001f1c <wakeup>
  release(&log.lock);
    80003b66:	8526                	mv	a0,s1
    80003b68:	924fd0ef          	jal	80000c8c <release>
}
    80003b6c:	70e2                	ld	ra,56(sp)
    80003b6e:	7442                	ld	s0,48(sp)
    80003b70:	74a2                	ld	s1,40(sp)
    80003b72:	7902                	ld	s2,32(sp)
    80003b74:	6121                	addi	sp,sp,64
    80003b76:	8082                	ret
    80003b78:	ec4e                	sd	s3,24(sp)
    80003b7a:	e852                	sd	s4,16(sp)
    80003b7c:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b7e:	0001ca97          	auipc	s5,0x1c
    80003b82:	2e2a8a93          	addi	s5,s5,738 # 8001fe60 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003b86:	0001ca17          	auipc	s4,0x1c
    80003b8a:	2aaa0a13          	addi	s4,s4,682 # 8001fe30 <log>
    80003b8e:	018a2583          	lw	a1,24(s4)
    80003b92:	012585bb          	addw	a1,a1,s2
    80003b96:	2585                	addiw	a1,a1,1
    80003b98:	028a2503          	lw	a0,40(s4)
    80003b9c:	f0ffe0ef          	jal	80002aaa <bread>
    80003ba0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003ba2:	000aa583          	lw	a1,0(s5)
    80003ba6:	028a2503          	lw	a0,40(s4)
    80003baa:	f01fe0ef          	jal	80002aaa <bread>
    80003bae:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003bb0:	40000613          	li	a2,1024
    80003bb4:	05850593          	addi	a1,a0,88
    80003bb8:	05848513          	addi	a0,s1,88
    80003bbc:	968fd0ef          	jal	80000d24 <memmove>
    bwrite(to);  // write the log
    80003bc0:	8526                	mv	a0,s1
    80003bc2:	fbffe0ef          	jal	80002b80 <bwrite>
    brelse(from);
    80003bc6:	854e                	mv	a0,s3
    80003bc8:	febfe0ef          	jal	80002bb2 <brelse>
    brelse(to);
    80003bcc:	8526                	mv	a0,s1
    80003bce:	fe5fe0ef          	jal	80002bb2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bd2:	2905                	addiw	s2,s2,1
    80003bd4:	0a91                	addi	s5,s5,4
    80003bd6:	02ca2783          	lw	a5,44(s4)
    80003bda:	faf94ae3          	blt	s2,a5,80003b8e <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003bde:	d11ff0ef          	jal	800038ee <write_head>
    install_trans(0); // Now install writes to home locations
    80003be2:	4501                	li	a0,0
    80003be4:	d69ff0ef          	jal	8000394c <install_trans>
    log.lh.n = 0;
    80003be8:	0001c797          	auipc	a5,0x1c
    80003bec:	2607aa23          	sw	zero,628(a5) # 8001fe5c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003bf0:	cffff0ef          	jal	800038ee <write_head>
    80003bf4:	69e2                	ld	s3,24(sp)
    80003bf6:	6a42                	ld	s4,16(sp)
    80003bf8:	6aa2                	ld	s5,8(sp)
    80003bfa:	b735                	j	80003b26 <end_op+0x44>

0000000080003bfc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003bfc:	1101                	addi	sp,sp,-32
    80003bfe:	ec06                	sd	ra,24(sp)
    80003c00:	e822                	sd	s0,16(sp)
    80003c02:	e426                	sd	s1,8(sp)
    80003c04:	e04a                	sd	s2,0(sp)
    80003c06:	1000                	addi	s0,sp,32
    80003c08:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003c0a:	0001c917          	auipc	s2,0x1c
    80003c0e:	22690913          	addi	s2,s2,550 # 8001fe30 <log>
    80003c12:	854a                	mv	a0,s2
    80003c14:	fe1fc0ef          	jal	80000bf4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003c18:	02c92603          	lw	a2,44(s2)
    80003c1c:	47f5                	li	a5,29
    80003c1e:	06c7c363          	blt	a5,a2,80003c84 <log_write+0x88>
    80003c22:	0001c797          	auipc	a5,0x1c
    80003c26:	22a7a783          	lw	a5,554(a5) # 8001fe4c <log+0x1c>
    80003c2a:	37fd                	addiw	a5,a5,-1
    80003c2c:	04f65c63          	bge	a2,a5,80003c84 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003c30:	0001c797          	auipc	a5,0x1c
    80003c34:	2207a783          	lw	a5,544(a5) # 8001fe50 <log+0x20>
    80003c38:	04f05c63          	blez	a5,80003c90 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003c3c:	4781                	li	a5,0
    80003c3e:	04c05f63          	blez	a2,80003c9c <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003c42:	44cc                	lw	a1,12(s1)
    80003c44:	0001c717          	auipc	a4,0x1c
    80003c48:	21c70713          	addi	a4,a4,540 # 8001fe60 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003c4c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003c4e:	4314                	lw	a3,0(a4)
    80003c50:	04b68663          	beq	a3,a1,80003c9c <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003c54:	2785                	addiw	a5,a5,1
    80003c56:	0711                	addi	a4,a4,4
    80003c58:	fef61be3          	bne	a2,a5,80003c4e <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003c5c:	0621                	addi	a2,a2,8
    80003c5e:	060a                	slli	a2,a2,0x2
    80003c60:	0001c797          	auipc	a5,0x1c
    80003c64:	1d078793          	addi	a5,a5,464 # 8001fe30 <log>
    80003c68:	97b2                	add	a5,a5,a2
    80003c6a:	44d8                	lw	a4,12(s1)
    80003c6c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003c6e:	8526                	mv	a0,s1
    80003c70:	fcbfe0ef          	jal	80002c3a <bpin>
    log.lh.n++;
    80003c74:	0001c717          	auipc	a4,0x1c
    80003c78:	1bc70713          	addi	a4,a4,444 # 8001fe30 <log>
    80003c7c:	575c                	lw	a5,44(a4)
    80003c7e:	2785                	addiw	a5,a5,1
    80003c80:	d75c                	sw	a5,44(a4)
    80003c82:	a80d                	j	80003cb4 <log_write+0xb8>
    panic("too big a transaction");
    80003c84:	00004517          	auipc	a0,0x4
    80003c88:	91c50513          	addi	a0,a0,-1764 # 800075a0 <etext+0x5a0>
    80003c8c:	b09fc0ef          	jal	80000794 <panic>
    panic("log_write outside of trans");
    80003c90:	00004517          	auipc	a0,0x4
    80003c94:	92850513          	addi	a0,a0,-1752 # 800075b8 <etext+0x5b8>
    80003c98:	afdfc0ef          	jal	80000794 <panic>
  log.lh.block[i] = b->blockno;
    80003c9c:	00878693          	addi	a3,a5,8
    80003ca0:	068a                	slli	a3,a3,0x2
    80003ca2:	0001c717          	auipc	a4,0x1c
    80003ca6:	18e70713          	addi	a4,a4,398 # 8001fe30 <log>
    80003caa:	9736                	add	a4,a4,a3
    80003cac:	44d4                	lw	a3,12(s1)
    80003cae:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003cb0:	faf60fe3          	beq	a2,a5,80003c6e <log_write+0x72>
  }
  release(&log.lock);
    80003cb4:	0001c517          	auipc	a0,0x1c
    80003cb8:	17c50513          	addi	a0,a0,380 # 8001fe30 <log>
    80003cbc:	fd1fc0ef          	jal	80000c8c <release>
}
    80003cc0:	60e2                	ld	ra,24(sp)
    80003cc2:	6442                	ld	s0,16(sp)
    80003cc4:	64a2                	ld	s1,8(sp)
    80003cc6:	6902                	ld	s2,0(sp)
    80003cc8:	6105                	addi	sp,sp,32
    80003cca:	8082                	ret

0000000080003ccc <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003ccc:	1101                	addi	sp,sp,-32
    80003cce:	ec06                	sd	ra,24(sp)
    80003cd0:	e822                	sd	s0,16(sp)
    80003cd2:	e426                	sd	s1,8(sp)
    80003cd4:	e04a                	sd	s2,0(sp)
    80003cd6:	1000                	addi	s0,sp,32
    80003cd8:	84aa                	mv	s1,a0
    80003cda:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003cdc:	00004597          	auipc	a1,0x4
    80003ce0:	8fc58593          	addi	a1,a1,-1796 # 800075d8 <etext+0x5d8>
    80003ce4:	0521                	addi	a0,a0,8
    80003ce6:	e8ffc0ef          	jal	80000b74 <initlock>
  lk->name = name;
    80003cea:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003cee:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003cf2:	0204a423          	sw	zero,40(s1)
}
    80003cf6:	60e2                	ld	ra,24(sp)
    80003cf8:	6442                	ld	s0,16(sp)
    80003cfa:	64a2                	ld	s1,8(sp)
    80003cfc:	6902                	ld	s2,0(sp)
    80003cfe:	6105                	addi	sp,sp,32
    80003d00:	8082                	ret

0000000080003d02 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003d02:	1101                	addi	sp,sp,-32
    80003d04:	ec06                	sd	ra,24(sp)
    80003d06:	e822                	sd	s0,16(sp)
    80003d08:	e426                	sd	s1,8(sp)
    80003d0a:	e04a                	sd	s2,0(sp)
    80003d0c:	1000                	addi	s0,sp,32
    80003d0e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003d10:	00850913          	addi	s2,a0,8
    80003d14:	854a                	mv	a0,s2
    80003d16:	edffc0ef          	jal	80000bf4 <acquire>
  while (lk->locked) {
    80003d1a:	409c                	lw	a5,0(s1)
    80003d1c:	c799                	beqz	a5,80003d2a <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003d1e:	85ca                	mv	a1,s2
    80003d20:	8526                	mv	a0,s1
    80003d22:	9aefe0ef          	jal	80001ed0 <sleep>
  while (lk->locked) {
    80003d26:	409c                	lw	a5,0(s1)
    80003d28:	fbfd                	bnez	a5,80003d1e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003d2a:	4785                	li	a5,1
    80003d2c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003d2e:	bbdfd0ef          	jal	800018ea <myproc>
    80003d32:	591c                	lw	a5,48(a0)
    80003d34:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003d36:	854a                	mv	a0,s2
    80003d38:	f55fc0ef          	jal	80000c8c <release>
}
    80003d3c:	60e2                	ld	ra,24(sp)
    80003d3e:	6442                	ld	s0,16(sp)
    80003d40:	64a2                	ld	s1,8(sp)
    80003d42:	6902                	ld	s2,0(sp)
    80003d44:	6105                	addi	sp,sp,32
    80003d46:	8082                	ret

0000000080003d48 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003d48:	1101                	addi	sp,sp,-32
    80003d4a:	ec06                	sd	ra,24(sp)
    80003d4c:	e822                	sd	s0,16(sp)
    80003d4e:	e426                	sd	s1,8(sp)
    80003d50:	e04a                	sd	s2,0(sp)
    80003d52:	1000                	addi	s0,sp,32
    80003d54:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003d56:	00850913          	addi	s2,a0,8
    80003d5a:	854a                	mv	a0,s2
    80003d5c:	e99fc0ef          	jal	80000bf4 <acquire>
  lk->locked = 0;
    80003d60:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003d64:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003d68:	8526                	mv	a0,s1
    80003d6a:	9b2fe0ef          	jal	80001f1c <wakeup>
  release(&lk->lk);
    80003d6e:	854a                	mv	a0,s2
    80003d70:	f1dfc0ef          	jal	80000c8c <release>
}
    80003d74:	60e2                	ld	ra,24(sp)
    80003d76:	6442                	ld	s0,16(sp)
    80003d78:	64a2                	ld	s1,8(sp)
    80003d7a:	6902                	ld	s2,0(sp)
    80003d7c:	6105                	addi	sp,sp,32
    80003d7e:	8082                	ret

0000000080003d80 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003d80:	7179                	addi	sp,sp,-48
    80003d82:	f406                	sd	ra,40(sp)
    80003d84:	f022                	sd	s0,32(sp)
    80003d86:	ec26                	sd	s1,24(sp)
    80003d88:	e84a                	sd	s2,16(sp)
    80003d8a:	1800                	addi	s0,sp,48
    80003d8c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003d8e:	00850913          	addi	s2,a0,8
    80003d92:	854a                	mv	a0,s2
    80003d94:	e61fc0ef          	jal	80000bf4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003d98:	409c                	lw	a5,0(s1)
    80003d9a:	ef81                	bnez	a5,80003db2 <holdingsleep+0x32>
    80003d9c:	4481                	li	s1,0
  release(&lk->lk);
    80003d9e:	854a                	mv	a0,s2
    80003da0:	eedfc0ef          	jal	80000c8c <release>
  return r;
}
    80003da4:	8526                	mv	a0,s1
    80003da6:	70a2                	ld	ra,40(sp)
    80003da8:	7402                	ld	s0,32(sp)
    80003daa:	64e2                	ld	s1,24(sp)
    80003dac:	6942                	ld	s2,16(sp)
    80003dae:	6145                	addi	sp,sp,48
    80003db0:	8082                	ret
    80003db2:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003db4:	0284a983          	lw	s3,40(s1)
    80003db8:	b33fd0ef          	jal	800018ea <myproc>
    80003dbc:	5904                	lw	s1,48(a0)
    80003dbe:	413484b3          	sub	s1,s1,s3
    80003dc2:	0014b493          	seqz	s1,s1
    80003dc6:	69a2                	ld	s3,8(sp)
    80003dc8:	bfd9                	j	80003d9e <holdingsleep+0x1e>

0000000080003dca <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003dca:	1141                	addi	sp,sp,-16
    80003dcc:	e406                	sd	ra,8(sp)
    80003dce:	e022                	sd	s0,0(sp)
    80003dd0:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003dd2:	00004597          	auipc	a1,0x4
    80003dd6:	81658593          	addi	a1,a1,-2026 # 800075e8 <etext+0x5e8>
    80003dda:	0001c517          	auipc	a0,0x1c
    80003dde:	19e50513          	addi	a0,a0,414 # 8001ff78 <ftable>
    80003de2:	d93fc0ef          	jal	80000b74 <initlock>
}
    80003de6:	60a2                	ld	ra,8(sp)
    80003de8:	6402                	ld	s0,0(sp)
    80003dea:	0141                	addi	sp,sp,16
    80003dec:	8082                	ret

0000000080003dee <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003dee:	1101                	addi	sp,sp,-32
    80003df0:	ec06                	sd	ra,24(sp)
    80003df2:	e822                	sd	s0,16(sp)
    80003df4:	e426                	sd	s1,8(sp)
    80003df6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003df8:	0001c517          	auipc	a0,0x1c
    80003dfc:	18050513          	addi	a0,a0,384 # 8001ff78 <ftable>
    80003e00:	df5fc0ef          	jal	80000bf4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003e04:	0001c497          	auipc	s1,0x1c
    80003e08:	18c48493          	addi	s1,s1,396 # 8001ff90 <ftable+0x18>
    80003e0c:	0001d717          	auipc	a4,0x1d
    80003e10:	12470713          	addi	a4,a4,292 # 80020f30 <disk>
    if(f->ref == 0){
    80003e14:	40dc                	lw	a5,4(s1)
    80003e16:	cf89                	beqz	a5,80003e30 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003e18:	02848493          	addi	s1,s1,40
    80003e1c:	fee49ce3          	bne	s1,a4,80003e14 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003e20:	0001c517          	auipc	a0,0x1c
    80003e24:	15850513          	addi	a0,a0,344 # 8001ff78 <ftable>
    80003e28:	e65fc0ef          	jal	80000c8c <release>
  return 0;
    80003e2c:	4481                	li	s1,0
    80003e2e:	a809                	j	80003e40 <filealloc+0x52>
      f->ref = 1;
    80003e30:	4785                	li	a5,1
    80003e32:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003e34:	0001c517          	auipc	a0,0x1c
    80003e38:	14450513          	addi	a0,a0,324 # 8001ff78 <ftable>
    80003e3c:	e51fc0ef          	jal	80000c8c <release>
}
    80003e40:	8526                	mv	a0,s1
    80003e42:	60e2                	ld	ra,24(sp)
    80003e44:	6442                	ld	s0,16(sp)
    80003e46:	64a2                	ld	s1,8(sp)
    80003e48:	6105                	addi	sp,sp,32
    80003e4a:	8082                	ret

0000000080003e4c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003e4c:	1101                	addi	sp,sp,-32
    80003e4e:	ec06                	sd	ra,24(sp)
    80003e50:	e822                	sd	s0,16(sp)
    80003e52:	e426                	sd	s1,8(sp)
    80003e54:	1000                	addi	s0,sp,32
    80003e56:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003e58:	0001c517          	auipc	a0,0x1c
    80003e5c:	12050513          	addi	a0,a0,288 # 8001ff78 <ftable>
    80003e60:	d95fc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    80003e64:	40dc                	lw	a5,4(s1)
    80003e66:	02f05063          	blez	a5,80003e86 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003e6a:	2785                	addiw	a5,a5,1
    80003e6c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003e6e:	0001c517          	auipc	a0,0x1c
    80003e72:	10a50513          	addi	a0,a0,266 # 8001ff78 <ftable>
    80003e76:	e17fc0ef          	jal	80000c8c <release>
  return f;
}
    80003e7a:	8526                	mv	a0,s1
    80003e7c:	60e2                	ld	ra,24(sp)
    80003e7e:	6442                	ld	s0,16(sp)
    80003e80:	64a2                	ld	s1,8(sp)
    80003e82:	6105                	addi	sp,sp,32
    80003e84:	8082                	ret
    panic("filedup");
    80003e86:	00003517          	auipc	a0,0x3
    80003e8a:	76a50513          	addi	a0,a0,1898 # 800075f0 <etext+0x5f0>
    80003e8e:	907fc0ef          	jal	80000794 <panic>

0000000080003e92 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003e92:	7139                	addi	sp,sp,-64
    80003e94:	fc06                	sd	ra,56(sp)
    80003e96:	f822                	sd	s0,48(sp)
    80003e98:	f426                	sd	s1,40(sp)
    80003e9a:	0080                	addi	s0,sp,64
    80003e9c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003e9e:	0001c517          	auipc	a0,0x1c
    80003ea2:	0da50513          	addi	a0,a0,218 # 8001ff78 <ftable>
    80003ea6:	d4ffc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    80003eaa:	40dc                	lw	a5,4(s1)
    80003eac:	04f05a63          	blez	a5,80003f00 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003eb0:	37fd                	addiw	a5,a5,-1
    80003eb2:	0007871b          	sext.w	a4,a5
    80003eb6:	c0dc                	sw	a5,4(s1)
    80003eb8:	04e04e63          	bgtz	a4,80003f14 <fileclose+0x82>
    80003ebc:	f04a                	sd	s2,32(sp)
    80003ebe:	ec4e                	sd	s3,24(sp)
    80003ec0:	e852                	sd	s4,16(sp)
    80003ec2:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ec4:	0004a903          	lw	s2,0(s1)
    80003ec8:	0094ca83          	lbu	s5,9(s1)
    80003ecc:	0104ba03          	ld	s4,16(s1)
    80003ed0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ed4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ed8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003edc:	0001c517          	auipc	a0,0x1c
    80003ee0:	09c50513          	addi	a0,a0,156 # 8001ff78 <ftable>
    80003ee4:	da9fc0ef          	jal	80000c8c <release>

  if(ff.type == FD_PIPE){
    80003ee8:	4785                	li	a5,1
    80003eea:	04f90063          	beq	s2,a5,80003f2a <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003eee:	3979                	addiw	s2,s2,-2
    80003ef0:	4785                	li	a5,1
    80003ef2:	0527f563          	bgeu	a5,s2,80003f3c <fileclose+0xaa>
    80003ef6:	7902                	ld	s2,32(sp)
    80003ef8:	69e2                	ld	s3,24(sp)
    80003efa:	6a42                	ld	s4,16(sp)
    80003efc:	6aa2                	ld	s5,8(sp)
    80003efe:	a00d                	j	80003f20 <fileclose+0x8e>
    80003f00:	f04a                	sd	s2,32(sp)
    80003f02:	ec4e                	sd	s3,24(sp)
    80003f04:	e852                	sd	s4,16(sp)
    80003f06:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003f08:	00003517          	auipc	a0,0x3
    80003f0c:	6f050513          	addi	a0,a0,1776 # 800075f8 <etext+0x5f8>
    80003f10:	885fc0ef          	jal	80000794 <panic>
    release(&ftable.lock);
    80003f14:	0001c517          	auipc	a0,0x1c
    80003f18:	06450513          	addi	a0,a0,100 # 8001ff78 <ftable>
    80003f1c:	d71fc0ef          	jal	80000c8c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003f20:	70e2                	ld	ra,56(sp)
    80003f22:	7442                	ld	s0,48(sp)
    80003f24:	74a2                	ld	s1,40(sp)
    80003f26:	6121                	addi	sp,sp,64
    80003f28:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003f2a:	85d6                	mv	a1,s5
    80003f2c:	8552                	mv	a0,s4
    80003f2e:	336000ef          	jal	80004264 <pipeclose>
    80003f32:	7902                	ld	s2,32(sp)
    80003f34:	69e2                	ld	s3,24(sp)
    80003f36:	6a42                	ld	s4,16(sp)
    80003f38:	6aa2                	ld	s5,8(sp)
    80003f3a:	b7dd                	j	80003f20 <fileclose+0x8e>
    begin_op();
    80003f3c:	b3dff0ef          	jal	80003a78 <begin_op>
    iput(ff.ip);
    80003f40:	854e                	mv	a0,s3
    80003f42:	c22ff0ef          	jal	80003364 <iput>
    end_op();
    80003f46:	b9dff0ef          	jal	80003ae2 <end_op>
    80003f4a:	7902                	ld	s2,32(sp)
    80003f4c:	69e2                	ld	s3,24(sp)
    80003f4e:	6a42                	ld	s4,16(sp)
    80003f50:	6aa2                	ld	s5,8(sp)
    80003f52:	b7f9                	j	80003f20 <fileclose+0x8e>

0000000080003f54 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003f54:	715d                	addi	sp,sp,-80
    80003f56:	e486                	sd	ra,72(sp)
    80003f58:	e0a2                	sd	s0,64(sp)
    80003f5a:	fc26                	sd	s1,56(sp)
    80003f5c:	f44e                	sd	s3,40(sp)
    80003f5e:	0880                	addi	s0,sp,80
    80003f60:	84aa                	mv	s1,a0
    80003f62:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003f64:	987fd0ef          	jal	800018ea <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003f68:	409c                	lw	a5,0(s1)
    80003f6a:	37f9                	addiw	a5,a5,-2
    80003f6c:	4705                	li	a4,1
    80003f6e:	04f76063          	bltu	a4,a5,80003fae <filestat+0x5a>
    80003f72:	f84a                	sd	s2,48(sp)
    80003f74:	892a                	mv	s2,a0
    ilock(f->ip);
    80003f76:	6c88                	ld	a0,24(s1)
    80003f78:	a6aff0ef          	jal	800031e2 <ilock>
    stati(f->ip, &st);
    80003f7c:	fb840593          	addi	a1,s0,-72
    80003f80:	6c88                	ld	a0,24(s1)
    80003f82:	c8aff0ef          	jal	8000340c <stati>
    iunlock(f->ip);
    80003f86:	6c88                	ld	a0,24(s1)
    80003f88:	b08ff0ef          	jal	80003290 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003f8c:	46e1                	li	a3,24
    80003f8e:	fb840613          	addi	a2,s0,-72
    80003f92:	85ce                	mv	a1,s3
    80003f94:	05093503          	ld	a0,80(s2)
    80003f98:	dbafd0ef          	jal	80001552 <copyout>
    80003f9c:	41f5551b          	sraiw	a0,a0,0x1f
    80003fa0:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003fa2:	60a6                	ld	ra,72(sp)
    80003fa4:	6406                	ld	s0,64(sp)
    80003fa6:	74e2                	ld	s1,56(sp)
    80003fa8:	79a2                	ld	s3,40(sp)
    80003faa:	6161                	addi	sp,sp,80
    80003fac:	8082                	ret
  return -1;
    80003fae:	557d                	li	a0,-1
    80003fb0:	bfcd                	j	80003fa2 <filestat+0x4e>

0000000080003fb2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003fb2:	7179                	addi	sp,sp,-48
    80003fb4:	f406                	sd	ra,40(sp)
    80003fb6:	f022                	sd	s0,32(sp)
    80003fb8:	e84a                	sd	s2,16(sp)
    80003fba:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003fbc:	00854783          	lbu	a5,8(a0)
    80003fc0:	cfd1                	beqz	a5,8000405c <fileread+0xaa>
    80003fc2:	ec26                	sd	s1,24(sp)
    80003fc4:	e44e                	sd	s3,8(sp)
    80003fc6:	84aa                	mv	s1,a0
    80003fc8:	89ae                	mv	s3,a1
    80003fca:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003fcc:	411c                	lw	a5,0(a0)
    80003fce:	4705                	li	a4,1
    80003fd0:	04e78363          	beq	a5,a4,80004016 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003fd4:	470d                	li	a4,3
    80003fd6:	04e78763          	beq	a5,a4,80004024 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003fda:	4709                	li	a4,2
    80003fdc:	06e79a63          	bne	a5,a4,80004050 <fileread+0x9e>
    ilock(f->ip);
    80003fe0:	6d08                	ld	a0,24(a0)
    80003fe2:	a00ff0ef          	jal	800031e2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003fe6:	874a                	mv	a4,s2
    80003fe8:	5094                	lw	a3,32(s1)
    80003fea:	864e                	mv	a2,s3
    80003fec:	4585                	li	a1,1
    80003fee:	6c88                	ld	a0,24(s1)
    80003ff0:	c46ff0ef          	jal	80003436 <readi>
    80003ff4:	892a                	mv	s2,a0
    80003ff6:	00a05563          	blez	a0,80004000 <fileread+0x4e>
      f->off += r;
    80003ffa:	509c                	lw	a5,32(s1)
    80003ffc:	9fa9                	addw	a5,a5,a0
    80003ffe:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004000:	6c88                	ld	a0,24(s1)
    80004002:	a8eff0ef          	jal	80003290 <iunlock>
    80004006:	64e2                	ld	s1,24(sp)
    80004008:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000400a:	854a                	mv	a0,s2
    8000400c:	70a2                	ld	ra,40(sp)
    8000400e:	7402                	ld	s0,32(sp)
    80004010:	6942                	ld	s2,16(sp)
    80004012:	6145                	addi	sp,sp,48
    80004014:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004016:	6908                	ld	a0,16(a0)
    80004018:	388000ef          	jal	800043a0 <piperead>
    8000401c:	892a                	mv	s2,a0
    8000401e:	64e2                	ld	s1,24(sp)
    80004020:	69a2                	ld	s3,8(sp)
    80004022:	b7e5                	j	8000400a <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004024:	02451783          	lh	a5,36(a0)
    80004028:	03079693          	slli	a3,a5,0x30
    8000402c:	92c1                	srli	a3,a3,0x30
    8000402e:	4725                	li	a4,9
    80004030:	02d76863          	bltu	a4,a3,80004060 <fileread+0xae>
    80004034:	0792                	slli	a5,a5,0x4
    80004036:	0001c717          	auipc	a4,0x1c
    8000403a:	ea270713          	addi	a4,a4,-350 # 8001fed8 <devsw>
    8000403e:	97ba                	add	a5,a5,a4
    80004040:	639c                	ld	a5,0(a5)
    80004042:	c39d                	beqz	a5,80004068 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004044:	4505                	li	a0,1
    80004046:	9782                	jalr	a5
    80004048:	892a                	mv	s2,a0
    8000404a:	64e2                	ld	s1,24(sp)
    8000404c:	69a2                	ld	s3,8(sp)
    8000404e:	bf75                	j	8000400a <fileread+0x58>
    panic("fileread");
    80004050:	00003517          	auipc	a0,0x3
    80004054:	5b850513          	addi	a0,a0,1464 # 80007608 <etext+0x608>
    80004058:	f3cfc0ef          	jal	80000794 <panic>
    return -1;
    8000405c:	597d                	li	s2,-1
    8000405e:	b775                	j	8000400a <fileread+0x58>
      return -1;
    80004060:	597d                	li	s2,-1
    80004062:	64e2                	ld	s1,24(sp)
    80004064:	69a2                	ld	s3,8(sp)
    80004066:	b755                	j	8000400a <fileread+0x58>
    80004068:	597d                	li	s2,-1
    8000406a:	64e2                	ld	s1,24(sp)
    8000406c:	69a2                	ld	s3,8(sp)
    8000406e:	bf71                	j	8000400a <fileread+0x58>

0000000080004070 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004070:	00954783          	lbu	a5,9(a0)
    80004074:	10078b63          	beqz	a5,8000418a <filewrite+0x11a>
{
    80004078:	715d                	addi	sp,sp,-80
    8000407a:	e486                	sd	ra,72(sp)
    8000407c:	e0a2                	sd	s0,64(sp)
    8000407e:	f84a                	sd	s2,48(sp)
    80004080:	f052                	sd	s4,32(sp)
    80004082:	e85a                	sd	s6,16(sp)
    80004084:	0880                	addi	s0,sp,80
    80004086:	892a                	mv	s2,a0
    80004088:	8b2e                	mv	s6,a1
    8000408a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000408c:	411c                	lw	a5,0(a0)
    8000408e:	4705                	li	a4,1
    80004090:	02e78763          	beq	a5,a4,800040be <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004094:	470d                	li	a4,3
    80004096:	02e78863          	beq	a5,a4,800040c6 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000409a:	4709                	li	a4,2
    8000409c:	0ce79c63          	bne	a5,a4,80004174 <filewrite+0x104>
    800040a0:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800040a2:	0ac05863          	blez	a2,80004152 <filewrite+0xe2>
    800040a6:	fc26                	sd	s1,56(sp)
    800040a8:	ec56                	sd	s5,24(sp)
    800040aa:	e45e                	sd	s7,8(sp)
    800040ac:	e062                	sd	s8,0(sp)
    int i = 0;
    800040ae:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800040b0:	6b85                	lui	s7,0x1
    800040b2:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800040b6:	6c05                	lui	s8,0x1
    800040b8:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800040bc:	a8b5                	j	80004138 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800040be:	6908                	ld	a0,16(a0)
    800040c0:	1fc000ef          	jal	800042bc <pipewrite>
    800040c4:	a04d                	j	80004166 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800040c6:	02451783          	lh	a5,36(a0)
    800040ca:	03079693          	slli	a3,a5,0x30
    800040ce:	92c1                	srli	a3,a3,0x30
    800040d0:	4725                	li	a4,9
    800040d2:	0ad76e63          	bltu	a4,a3,8000418e <filewrite+0x11e>
    800040d6:	0792                	slli	a5,a5,0x4
    800040d8:	0001c717          	auipc	a4,0x1c
    800040dc:	e0070713          	addi	a4,a4,-512 # 8001fed8 <devsw>
    800040e0:	97ba                	add	a5,a5,a4
    800040e2:	679c                	ld	a5,8(a5)
    800040e4:	c7dd                	beqz	a5,80004192 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800040e6:	4505                	li	a0,1
    800040e8:	9782                	jalr	a5
    800040ea:	a8b5                	j	80004166 <filewrite+0xf6>
      if(n1 > max)
    800040ec:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800040f0:	989ff0ef          	jal	80003a78 <begin_op>
      ilock(f->ip);
    800040f4:	01893503          	ld	a0,24(s2)
    800040f8:	8eaff0ef          	jal	800031e2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800040fc:	8756                	mv	a4,s5
    800040fe:	02092683          	lw	a3,32(s2)
    80004102:	01698633          	add	a2,s3,s6
    80004106:	4585                	li	a1,1
    80004108:	01893503          	ld	a0,24(s2)
    8000410c:	c26ff0ef          	jal	80003532 <writei>
    80004110:	84aa                	mv	s1,a0
    80004112:	00a05763          	blez	a0,80004120 <filewrite+0xb0>
        f->off += r;
    80004116:	02092783          	lw	a5,32(s2)
    8000411a:	9fa9                	addw	a5,a5,a0
    8000411c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004120:	01893503          	ld	a0,24(s2)
    80004124:	96cff0ef          	jal	80003290 <iunlock>
      end_op();
    80004128:	9bbff0ef          	jal	80003ae2 <end_op>

      if(r != n1){
    8000412c:	029a9563          	bne	s5,s1,80004156 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004130:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004134:	0149da63          	bge	s3,s4,80004148 <filewrite+0xd8>
      int n1 = n - i;
    80004138:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000413c:	0004879b          	sext.w	a5,s1
    80004140:	fafbd6e3          	bge	s7,a5,800040ec <filewrite+0x7c>
    80004144:	84e2                	mv	s1,s8
    80004146:	b75d                	j	800040ec <filewrite+0x7c>
    80004148:	74e2                	ld	s1,56(sp)
    8000414a:	6ae2                	ld	s5,24(sp)
    8000414c:	6ba2                	ld	s7,8(sp)
    8000414e:	6c02                	ld	s8,0(sp)
    80004150:	a039                	j	8000415e <filewrite+0xee>
    int i = 0;
    80004152:	4981                	li	s3,0
    80004154:	a029                	j	8000415e <filewrite+0xee>
    80004156:	74e2                	ld	s1,56(sp)
    80004158:	6ae2                	ld	s5,24(sp)
    8000415a:	6ba2                	ld	s7,8(sp)
    8000415c:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000415e:	033a1c63          	bne	s4,s3,80004196 <filewrite+0x126>
    80004162:	8552                	mv	a0,s4
    80004164:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004166:	60a6                	ld	ra,72(sp)
    80004168:	6406                	ld	s0,64(sp)
    8000416a:	7942                	ld	s2,48(sp)
    8000416c:	7a02                	ld	s4,32(sp)
    8000416e:	6b42                	ld	s6,16(sp)
    80004170:	6161                	addi	sp,sp,80
    80004172:	8082                	ret
    80004174:	fc26                	sd	s1,56(sp)
    80004176:	f44e                	sd	s3,40(sp)
    80004178:	ec56                	sd	s5,24(sp)
    8000417a:	e45e                	sd	s7,8(sp)
    8000417c:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000417e:	00003517          	auipc	a0,0x3
    80004182:	49a50513          	addi	a0,a0,1178 # 80007618 <etext+0x618>
    80004186:	e0efc0ef          	jal	80000794 <panic>
    return -1;
    8000418a:	557d                	li	a0,-1
}
    8000418c:	8082                	ret
      return -1;
    8000418e:	557d                	li	a0,-1
    80004190:	bfd9                	j	80004166 <filewrite+0xf6>
    80004192:	557d                	li	a0,-1
    80004194:	bfc9                	j	80004166 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80004196:	557d                	li	a0,-1
    80004198:	79a2                	ld	s3,40(sp)
    8000419a:	b7f1                	j	80004166 <filewrite+0xf6>

000000008000419c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000419c:	7179                	addi	sp,sp,-48
    8000419e:	f406                	sd	ra,40(sp)
    800041a0:	f022                	sd	s0,32(sp)
    800041a2:	ec26                	sd	s1,24(sp)
    800041a4:	e052                	sd	s4,0(sp)
    800041a6:	1800                	addi	s0,sp,48
    800041a8:	84aa                	mv	s1,a0
    800041aa:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800041ac:	0005b023          	sd	zero,0(a1)
    800041b0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800041b4:	c3bff0ef          	jal	80003dee <filealloc>
    800041b8:	e088                	sd	a0,0(s1)
    800041ba:	c549                	beqz	a0,80004244 <pipealloc+0xa8>
    800041bc:	c33ff0ef          	jal	80003dee <filealloc>
    800041c0:	00aa3023          	sd	a0,0(s4)
    800041c4:	cd25                	beqz	a0,8000423c <pipealloc+0xa0>
    800041c6:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800041c8:	95dfc0ef          	jal	80000b24 <kalloc>
    800041cc:	892a                	mv	s2,a0
    800041ce:	c12d                	beqz	a0,80004230 <pipealloc+0x94>
    800041d0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800041d2:	4985                	li	s3,1
    800041d4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800041d8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800041dc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800041e0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800041e4:	00003597          	auipc	a1,0x3
    800041e8:	44458593          	addi	a1,a1,1092 # 80007628 <etext+0x628>
    800041ec:	989fc0ef          	jal	80000b74 <initlock>
  (*f0)->type = FD_PIPE;
    800041f0:	609c                	ld	a5,0(s1)
    800041f2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800041f6:	609c                	ld	a5,0(s1)
    800041f8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800041fc:	609c                	ld	a5,0(s1)
    800041fe:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004202:	609c                	ld	a5,0(s1)
    80004204:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004208:	000a3783          	ld	a5,0(s4)
    8000420c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004210:	000a3783          	ld	a5,0(s4)
    80004214:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004218:	000a3783          	ld	a5,0(s4)
    8000421c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004220:	000a3783          	ld	a5,0(s4)
    80004224:	0127b823          	sd	s2,16(a5)
  return 0;
    80004228:	4501                	li	a0,0
    8000422a:	6942                	ld	s2,16(sp)
    8000422c:	69a2                	ld	s3,8(sp)
    8000422e:	a01d                	j	80004254 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004230:	6088                	ld	a0,0(s1)
    80004232:	c119                	beqz	a0,80004238 <pipealloc+0x9c>
    80004234:	6942                	ld	s2,16(sp)
    80004236:	a029                	j	80004240 <pipealloc+0xa4>
    80004238:	6942                	ld	s2,16(sp)
    8000423a:	a029                	j	80004244 <pipealloc+0xa8>
    8000423c:	6088                	ld	a0,0(s1)
    8000423e:	c10d                	beqz	a0,80004260 <pipealloc+0xc4>
    fileclose(*f0);
    80004240:	c53ff0ef          	jal	80003e92 <fileclose>
  if(*f1)
    80004244:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004248:	557d                	li	a0,-1
  if(*f1)
    8000424a:	c789                	beqz	a5,80004254 <pipealloc+0xb8>
    fileclose(*f1);
    8000424c:	853e                	mv	a0,a5
    8000424e:	c45ff0ef          	jal	80003e92 <fileclose>
  return -1;
    80004252:	557d                	li	a0,-1
}
    80004254:	70a2                	ld	ra,40(sp)
    80004256:	7402                	ld	s0,32(sp)
    80004258:	64e2                	ld	s1,24(sp)
    8000425a:	6a02                	ld	s4,0(sp)
    8000425c:	6145                	addi	sp,sp,48
    8000425e:	8082                	ret
  return -1;
    80004260:	557d                	li	a0,-1
    80004262:	bfcd                	j	80004254 <pipealloc+0xb8>

0000000080004264 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004264:	1101                	addi	sp,sp,-32
    80004266:	ec06                	sd	ra,24(sp)
    80004268:	e822                	sd	s0,16(sp)
    8000426a:	e426                	sd	s1,8(sp)
    8000426c:	e04a                	sd	s2,0(sp)
    8000426e:	1000                	addi	s0,sp,32
    80004270:	84aa                	mv	s1,a0
    80004272:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004274:	981fc0ef          	jal	80000bf4 <acquire>
  if(writable){
    80004278:	02090763          	beqz	s2,800042a6 <pipeclose+0x42>
    pi->writeopen = 0;
    8000427c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004280:	21848513          	addi	a0,s1,536
    80004284:	c99fd0ef          	jal	80001f1c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004288:	2204b783          	ld	a5,544(s1)
    8000428c:	e785                	bnez	a5,800042b4 <pipeclose+0x50>
    release(&pi->lock);
    8000428e:	8526                	mv	a0,s1
    80004290:	9fdfc0ef          	jal	80000c8c <release>
    kfree((char*)pi);
    80004294:	8526                	mv	a0,s1
    80004296:	facfc0ef          	jal	80000a42 <kfree>
  } else
    release(&pi->lock);
}
    8000429a:	60e2                	ld	ra,24(sp)
    8000429c:	6442                	ld	s0,16(sp)
    8000429e:	64a2                	ld	s1,8(sp)
    800042a0:	6902                	ld	s2,0(sp)
    800042a2:	6105                	addi	sp,sp,32
    800042a4:	8082                	ret
    pi->readopen = 0;
    800042a6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800042aa:	21c48513          	addi	a0,s1,540
    800042ae:	c6ffd0ef          	jal	80001f1c <wakeup>
    800042b2:	bfd9                	j	80004288 <pipeclose+0x24>
    release(&pi->lock);
    800042b4:	8526                	mv	a0,s1
    800042b6:	9d7fc0ef          	jal	80000c8c <release>
}
    800042ba:	b7c5                	j	8000429a <pipeclose+0x36>

00000000800042bc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800042bc:	711d                	addi	sp,sp,-96
    800042be:	ec86                	sd	ra,88(sp)
    800042c0:	e8a2                	sd	s0,80(sp)
    800042c2:	e4a6                	sd	s1,72(sp)
    800042c4:	e0ca                	sd	s2,64(sp)
    800042c6:	fc4e                	sd	s3,56(sp)
    800042c8:	f852                	sd	s4,48(sp)
    800042ca:	f456                	sd	s5,40(sp)
    800042cc:	1080                	addi	s0,sp,96
    800042ce:	84aa                	mv	s1,a0
    800042d0:	8aae                	mv	s5,a1
    800042d2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800042d4:	e16fd0ef          	jal	800018ea <myproc>
    800042d8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800042da:	8526                	mv	a0,s1
    800042dc:	919fc0ef          	jal	80000bf4 <acquire>
  while(i < n){
    800042e0:	0b405a63          	blez	s4,80004394 <pipewrite+0xd8>
    800042e4:	f05a                	sd	s6,32(sp)
    800042e6:	ec5e                	sd	s7,24(sp)
    800042e8:	e862                	sd	s8,16(sp)
  int i = 0;
    800042ea:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800042ec:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800042ee:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800042f2:	21c48b93          	addi	s7,s1,540
    800042f6:	a81d                	j	8000432c <pipewrite+0x70>
      release(&pi->lock);
    800042f8:	8526                	mv	a0,s1
    800042fa:	993fc0ef          	jal	80000c8c <release>
      return -1;
    800042fe:	597d                	li	s2,-1
    80004300:	7b02                	ld	s6,32(sp)
    80004302:	6be2                	ld	s7,24(sp)
    80004304:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004306:	854a                	mv	a0,s2
    80004308:	60e6                	ld	ra,88(sp)
    8000430a:	6446                	ld	s0,80(sp)
    8000430c:	64a6                	ld	s1,72(sp)
    8000430e:	6906                	ld	s2,64(sp)
    80004310:	79e2                	ld	s3,56(sp)
    80004312:	7a42                	ld	s4,48(sp)
    80004314:	7aa2                	ld	s5,40(sp)
    80004316:	6125                	addi	sp,sp,96
    80004318:	8082                	ret
      wakeup(&pi->nread);
    8000431a:	8562                	mv	a0,s8
    8000431c:	c01fd0ef          	jal	80001f1c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004320:	85a6                	mv	a1,s1
    80004322:	855e                	mv	a0,s7
    80004324:	badfd0ef          	jal	80001ed0 <sleep>
  while(i < n){
    80004328:	05495b63          	bge	s2,s4,8000437e <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    8000432c:	2204a783          	lw	a5,544(s1)
    80004330:	d7e1                	beqz	a5,800042f8 <pipewrite+0x3c>
    80004332:	854e                	mv	a0,s3
    80004334:	dd5fd0ef          	jal	80002108 <killed>
    80004338:	f161                	bnez	a0,800042f8 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000433a:	2184a783          	lw	a5,536(s1)
    8000433e:	21c4a703          	lw	a4,540(s1)
    80004342:	2007879b          	addiw	a5,a5,512
    80004346:	fcf70ae3          	beq	a4,a5,8000431a <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000434a:	4685                	li	a3,1
    8000434c:	01590633          	add	a2,s2,s5
    80004350:	faf40593          	addi	a1,s0,-81
    80004354:	0509b503          	ld	a0,80(s3)
    80004358:	ad0fd0ef          	jal	80001628 <copyin>
    8000435c:	03650e63          	beq	a0,s6,80004398 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004360:	21c4a783          	lw	a5,540(s1)
    80004364:	0017871b          	addiw	a4,a5,1
    80004368:	20e4ae23          	sw	a4,540(s1)
    8000436c:	1ff7f793          	andi	a5,a5,511
    80004370:	97a6                	add	a5,a5,s1
    80004372:	faf44703          	lbu	a4,-81(s0)
    80004376:	00e78c23          	sb	a4,24(a5)
      i++;
    8000437a:	2905                	addiw	s2,s2,1
    8000437c:	b775                	j	80004328 <pipewrite+0x6c>
    8000437e:	7b02                	ld	s6,32(sp)
    80004380:	6be2                	ld	s7,24(sp)
    80004382:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004384:	21848513          	addi	a0,s1,536
    80004388:	b95fd0ef          	jal	80001f1c <wakeup>
  release(&pi->lock);
    8000438c:	8526                	mv	a0,s1
    8000438e:	8fffc0ef          	jal	80000c8c <release>
  return i;
    80004392:	bf95                	j	80004306 <pipewrite+0x4a>
  int i = 0;
    80004394:	4901                	li	s2,0
    80004396:	b7fd                	j	80004384 <pipewrite+0xc8>
    80004398:	7b02                	ld	s6,32(sp)
    8000439a:	6be2                	ld	s7,24(sp)
    8000439c:	6c42                	ld	s8,16(sp)
    8000439e:	b7dd                	j	80004384 <pipewrite+0xc8>

00000000800043a0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800043a0:	715d                	addi	sp,sp,-80
    800043a2:	e486                	sd	ra,72(sp)
    800043a4:	e0a2                	sd	s0,64(sp)
    800043a6:	fc26                	sd	s1,56(sp)
    800043a8:	f84a                	sd	s2,48(sp)
    800043aa:	f44e                	sd	s3,40(sp)
    800043ac:	f052                	sd	s4,32(sp)
    800043ae:	ec56                	sd	s5,24(sp)
    800043b0:	0880                	addi	s0,sp,80
    800043b2:	84aa                	mv	s1,a0
    800043b4:	892e                	mv	s2,a1
    800043b6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800043b8:	d32fd0ef          	jal	800018ea <myproc>
    800043bc:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800043be:	8526                	mv	a0,s1
    800043c0:	835fc0ef          	jal	80000bf4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043c4:	2184a703          	lw	a4,536(s1)
    800043c8:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800043cc:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043d0:	02f71563          	bne	a4,a5,800043fa <piperead+0x5a>
    800043d4:	2244a783          	lw	a5,548(s1)
    800043d8:	cb85                	beqz	a5,80004408 <piperead+0x68>
    if(killed(pr)){
    800043da:	8552                	mv	a0,s4
    800043dc:	d2dfd0ef          	jal	80002108 <killed>
    800043e0:	ed19                	bnez	a0,800043fe <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800043e2:	85a6                	mv	a1,s1
    800043e4:	854e                	mv	a0,s3
    800043e6:	aebfd0ef          	jal	80001ed0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043ea:	2184a703          	lw	a4,536(s1)
    800043ee:	21c4a783          	lw	a5,540(s1)
    800043f2:	fef701e3          	beq	a4,a5,800043d4 <piperead+0x34>
    800043f6:	e85a                	sd	s6,16(sp)
    800043f8:	a809                	j	8000440a <piperead+0x6a>
    800043fa:	e85a                	sd	s6,16(sp)
    800043fc:	a039                	j	8000440a <piperead+0x6a>
      release(&pi->lock);
    800043fe:	8526                	mv	a0,s1
    80004400:	88dfc0ef          	jal	80000c8c <release>
      return -1;
    80004404:	59fd                	li	s3,-1
    80004406:	a8b1                	j	80004462 <piperead+0xc2>
    80004408:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000440a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000440c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000440e:	05505263          	blez	s5,80004452 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004412:	2184a783          	lw	a5,536(s1)
    80004416:	21c4a703          	lw	a4,540(s1)
    8000441a:	02f70c63          	beq	a4,a5,80004452 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000441e:	0017871b          	addiw	a4,a5,1
    80004422:	20e4ac23          	sw	a4,536(s1)
    80004426:	1ff7f793          	andi	a5,a5,511
    8000442a:	97a6                	add	a5,a5,s1
    8000442c:	0187c783          	lbu	a5,24(a5)
    80004430:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004434:	4685                	li	a3,1
    80004436:	fbf40613          	addi	a2,s0,-65
    8000443a:	85ca                	mv	a1,s2
    8000443c:	050a3503          	ld	a0,80(s4)
    80004440:	912fd0ef          	jal	80001552 <copyout>
    80004444:	01650763          	beq	a0,s6,80004452 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004448:	2985                	addiw	s3,s3,1
    8000444a:	0905                	addi	s2,s2,1
    8000444c:	fd3a93e3          	bne	s5,s3,80004412 <piperead+0x72>
    80004450:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004452:	21c48513          	addi	a0,s1,540
    80004456:	ac7fd0ef          	jal	80001f1c <wakeup>
  release(&pi->lock);
    8000445a:	8526                	mv	a0,s1
    8000445c:	831fc0ef          	jal	80000c8c <release>
    80004460:	6b42                	ld	s6,16(sp)
  return i;
}
    80004462:	854e                	mv	a0,s3
    80004464:	60a6                	ld	ra,72(sp)
    80004466:	6406                	ld	s0,64(sp)
    80004468:	74e2                	ld	s1,56(sp)
    8000446a:	7942                	ld	s2,48(sp)
    8000446c:	79a2                	ld	s3,40(sp)
    8000446e:	7a02                	ld	s4,32(sp)
    80004470:	6ae2                	ld	s5,24(sp)
    80004472:	6161                	addi	sp,sp,80
    80004474:	8082                	ret

0000000080004476 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004476:	1141                	addi	sp,sp,-16
    80004478:	e422                	sd	s0,8(sp)
    8000447a:	0800                	addi	s0,sp,16
    8000447c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000447e:	8905                	andi	a0,a0,1
    80004480:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004482:	8b89                	andi	a5,a5,2
    80004484:	c399                	beqz	a5,8000448a <flags2perm+0x14>
      perm |= PTE_W;
    80004486:	00456513          	ori	a0,a0,4
    return perm;
}
    8000448a:	6422                	ld	s0,8(sp)
    8000448c:	0141                	addi	sp,sp,16
    8000448e:	8082                	ret

0000000080004490 <exec>:

int
exec(char *path, char **argv)
{
    80004490:	df010113          	addi	sp,sp,-528
    80004494:	20113423          	sd	ra,520(sp)
    80004498:	20813023          	sd	s0,512(sp)
    8000449c:	ffa6                	sd	s1,504(sp)
    8000449e:	fbca                	sd	s2,496(sp)
    800044a0:	0c00                	addi	s0,sp,528
    800044a2:	892a                	mv	s2,a0
    800044a4:	dea43c23          	sd	a0,-520(s0)
    800044a8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800044ac:	c3efd0ef          	jal	800018ea <myproc>
    800044b0:	84aa                	mv	s1,a0

  begin_op();
    800044b2:	dc6ff0ef          	jal	80003a78 <begin_op>

  if((ip = namei(path)) == 0){
    800044b6:	854a                	mv	a0,s2
    800044b8:	c04ff0ef          	jal	800038bc <namei>
    800044bc:	c931                	beqz	a0,80004510 <exec+0x80>
    800044be:	f3d2                	sd	s4,480(sp)
    800044c0:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800044c2:	d21fe0ef          	jal	800031e2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800044c6:	04000713          	li	a4,64
    800044ca:	4681                	li	a3,0
    800044cc:	e5040613          	addi	a2,s0,-432
    800044d0:	4581                	li	a1,0
    800044d2:	8552                	mv	a0,s4
    800044d4:	f63fe0ef          	jal	80003436 <readi>
    800044d8:	04000793          	li	a5,64
    800044dc:	00f51a63          	bne	a0,a5,800044f0 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800044e0:	e5042703          	lw	a4,-432(s0)
    800044e4:	464c47b7          	lui	a5,0x464c4
    800044e8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800044ec:	02f70663          	beq	a4,a5,80004518 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800044f0:	8552                	mv	a0,s4
    800044f2:	efbfe0ef          	jal	800033ec <iunlockput>
    end_op();
    800044f6:	decff0ef          	jal	80003ae2 <end_op>
  }
  return -1;
    800044fa:	557d                	li	a0,-1
    800044fc:	7a1e                	ld	s4,480(sp)
}
    800044fe:	20813083          	ld	ra,520(sp)
    80004502:	20013403          	ld	s0,512(sp)
    80004506:	74fe                	ld	s1,504(sp)
    80004508:	795e                	ld	s2,496(sp)
    8000450a:	21010113          	addi	sp,sp,528
    8000450e:	8082                	ret
    end_op();
    80004510:	dd2ff0ef          	jal	80003ae2 <end_op>
    return -1;
    80004514:	557d                	li	a0,-1
    80004516:	b7e5                	j	800044fe <exec+0x6e>
    80004518:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000451a:	8526                	mv	a0,s1
    8000451c:	c76fd0ef          	jal	80001992 <proc_pagetable>
    80004520:	8b2a                	mv	s6,a0
    80004522:	2c050b63          	beqz	a0,800047f8 <exec+0x368>
    80004526:	f7ce                	sd	s3,488(sp)
    80004528:	efd6                	sd	s5,472(sp)
    8000452a:	e7de                	sd	s7,456(sp)
    8000452c:	e3e2                	sd	s8,448(sp)
    8000452e:	ff66                	sd	s9,440(sp)
    80004530:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004532:	e7042d03          	lw	s10,-400(s0)
    80004536:	e8845783          	lhu	a5,-376(s0)
    8000453a:	12078963          	beqz	a5,8000466c <exec+0x1dc>
    8000453e:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004540:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004542:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004544:	6c85                	lui	s9,0x1
    80004546:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000454a:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000454e:	6a85                	lui	s5,0x1
    80004550:	a085                	j	800045b0 <exec+0x120>
      panic("loadseg: address should exist");
    80004552:	00003517          	auipc	a0,0x3
    80004556:	0de50513          	addi	a0,a0,222 # 80007630 <etext+0x630>
    8000455a:	a3afc0ef          	jal	80000794 <panic>
    if(sz - i < PGSIZE)
    8000455e:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004560:	8726                	mv	a4,s1
    80004562:	012c06bb          	addw	a3,s8,s2
    80004566:	4581                	li	a1,0
    80004568:	8552                	mv	a0,s4
    8000456a:	ecdfe0ef          	jal	80003436 <readi>
    8000456e:	2501                	sext.w	a0,a0
    80004570:	24a49a63          	bne	s1,a0,800047c4 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80004574:	012a893b          	addw	s2,s5,s2
    80004578:	03397363          	bgeu	s2,s3,8000459e <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    8000457c:	02091593          	slli	a1,s2,0x20
    80004580:	9181                	srli	a1,a1,0x20
    80004582:	95de                	add	a1,a1,s7
    80004584:	855a                	mv	a0,s6
    80004586:	a51fc0ef          	jal	80000fd6 <walkaddr>
    8000458a:	862a                	mv	a2,a0
    if(pa == 0)
    8000458c:	d179                	beqz	a0,80004552 <exec+0xc2>
    if(sz - i < PGSIZE)
    8000458e:	412984bb          	subw	s1,s3,s2
    80004592:	0004879b          	sext.w	a5,s1
    80004596:	fcfcf4e3          	bgeu	s9,a5,8000455e <exec+0xce>
    8000459a:	84d6                	mv	s1,s5
    8000459c:	b7c9                	j	8000455e <exec+0xce>
    sz = sz1;
    8000459e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045a2:	2d85                	addiw	s11,s11,1
    800045a4:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800045a8:	e8845783          	lhu	a5,-376(s0)
    800045ac:	08fdd063          	bge	s11,a5,8000462c <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800045b0:	2d01                	sext.w	s10,s10
    800045b2:	03800713          	li	a4,56
    800045b6:	86ea                	mv	a3,s10
    800045b8:	e1840613          	addi	a2,s0,-488
    800045bc:	4581                	li	a1,0
    800045be:	8552                	mv	a0,s4
    800045c0:	e77fe0ef          	jal	80003436 <readi>
    800045c4:	03800793          	li	a5,56
    800045c8:	1cf51663          	bne	a0,a5,80004794 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    800045cc:	e1842783          	lw	a5,-488(s0)
    800045d0:	4705                	li	a4,1
    800045d2:	fce798e3          	bne	a5,a4,800045a2 <exec+0x112>
    if(ph.memsz < ph.filesz)
    800045d6:	e4043483          	ld	s1,-448(s0)
    800045da:	e3843783          	ld	a5,-456(s0)
    800045de:	1af4ef63          	bltu	s1,a5,8000479c <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045e2:	e2843783          	ld	a5,-472(s0)
    800045e6:	94be                	add	s1,s1,a5
    800045e8:	1af4ee63          	bltu	s1,a5,800047a4 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    800045ec:	df043703          	ld	a4,-528(s0)
    800045f0:	8ff9                	and	a5,a5,a4
    800045f2:	1a079d63          	bnez	a5,800047ac <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045f6:	e1c42503          	lw	a0,-484(s0)
    800045fa:	e7dff0ef          	jal	80004476 <flags2perm>
    800045fe:	86aa                	mv	a3,a0
    80004600:	8626                	mv	a2,s1
    80004602:	85ca                	mv	a1,s2
    80004604:	855a                	mv	a0,s6
    80004606:	d39fc0ef          	jal	8000133e <uvmalloc>
    8000460a:	e0a43423          	sd	a0,-504(s0)
    8000460e:	1a050363          	beqz	a0,800047b4 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004612:	e2843b83          	ld	s7,-472(s0)
    80004616:	e2042c03          	lw	s8,-480(s0)
    8000461a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000461e:	00098463          	beqz	s3,80004626 <exec+0x196>
    80004622:	4901                	li	s2,0
    80004624:	bfa1                	j	8000457c <exec+0xec>
    sz = sz1;
    80004626:	e0843903          	ld	s2,-504(s0)
    8000462a:	bfa5                	j	800045a2 <exec+0x112>
    8000462c:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000462e:	8552                	mv	a0,s4
    80004630:	dbdfe0ef          	jal	800033ec <iunlockput>
  end_op();
    80004634:	caeff0ef          	jal	80003ae2 <end_op>
  p = myproc();
    80004638:	ab2fd0ef          	jal	800018ea <myproc>
    8000463c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000463e:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004642:	6985                	lui	s3,0x1
    80004644:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004646:	99ca                	add	s3,s3,s2
    80004648:	77fd                	lui	a5,0xfffff
    8000464a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000464e:	4691                	li	a3,4
    80004650:	6609                	lui	a2,0x2
    80004652:	964e                	add	a2,a2,s3
    80004654:	85ce                	mv	a1,s3
    80004656:	855a                	mv	a0,s6
    80004658:	ce7fc0ef          	jal	8000133e <uvmalloc>
    8000465c:	892a                	mv	s2,a0
    8000465e:	e0a43423          	sd	a0,-504(s0)
    80004662:	e519                	bnez	a0,80004670 <exec+0x1e0>
  if(pagetable)
    80004664:	e1343423          	sd	s3,-504(s0)
    80004668:	4a01                	li	s4,0
    8000466a:	aab1                	j	800047c6 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000466c:	4901                	li	s2,0
    8000466e:	b7c1                	j	8000462e <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004670:	75f9                	lui	a1,0xffffe
    80004672:	95aa                	add	a1,a1,a0
    80004674:	855a                	mv	a0,s6
    80004676:	eb3fc0ef          	jal	80001528 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    8000467a:	7bfd                	lui	s7,0xfffff
    8000467c:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000467e:	e0043783          	ld	a5,-512(s0)
    80004682:	6388                	ld	a0,0(a5)
    80004684:	cd39                	beqz	a0,800046e2 <exec+0x252>
    80004686:	e9040993          	addi	s3,s0,-368
    8000468a:	f9040c13          	addi	s8,s0,-112
    8000468e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004690:	fa8fc0ef          	jal	80000e38 <strlen>
    80004694:	0015079b          	addiw	a5,a0,1
    80004698:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000469c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800046a0:	11796e63          	bltu	s2,s7,800047bc <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800046a4:	e0043d03          	ld	s10,-512(s0)
    800046a8:	000d3a03          	ld	s4,0(s10)
    800046ac:	8552                	mv	a0,s4
    800046ae:	f8afc0ef          	jal	80000e38 <strlen>
    800046b2:	0015069b          	addiw	a3,a0,1
    800046b6:	8652                	mv	a2,s4
    800046b8:	85ca                	mv	a1,s2
    800046ba:	855a                	mv	a0,s6
    800046bc:	e97fc0ef          	jal	80001552 <copyout>
    800046c0:	10054063          	bltz	a0,800047c0 <exec+0x330>
    ustack[argc] = sp;
    800046c4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800046c8:	0485                	addi	s1,s1,1
    800046ca:	008d0793          	addi	a5,s10,8
    800046ce:	e0f43023          	sd	a5,-512(s0)
    800046d2:	008d3503          	ld	a0,8(s10)
    800046d6:	c909                	beqz	a0,800046e8 <exec+0x258>
    if(argc >= MAXARG)
    800046d8:	09a1                	addi	s3,s3,8
    800046da:	fb899be3          	bne	s3,s8,80004690 <exec+0x200>
  ip = 0;
    800046de:	4a01                	li	s4,0
    800046e0:	a0dd                	j	800047c6 <exec+0x336>
  sp = sz;
    800046e2:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800046e6:	4481                	li	s1,0
  ustack[argc] = 0;
    800046e8:	00349793          	slli	a5,s1,0x3
    800046ec:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffddf20>
    800046f0:	97a2                	add	a5,a5,s0
    800046f2:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800046f6:	00148693          	addi	a3,s1,1
    800046fa:	068e                	slli	a3,a3,0x3
    800046fc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004700:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004704:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004708:	f5796ee3          	bltu	s2,s7,80004664 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000470c:	e9040613          	addi	a2,s0,-368
    80004710:	85ca                	mv	a1,s2
    80004712:	855a                	mv	a0,s6
    80004714:	e3ffc0ef          	jal	80001552 <copyout>
    80004718:	0e054263          	bltz	a0,800047fc <exec+0x36c>
  p->trapframe->a1 = sp;
    8000471c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004720:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004724:	df843783          	ld	a5,-520(s0)
    80004728:	0007c703          	lbu	a4,0(a5)
    8000472c:	cf11                	beqz	a4,80004748 <exec+0x2b8>
    8000472e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004730:	02f00693          	li	a3,47
    80004734:	a039                	j	80004742 <exec+0x2b2>
      last = s+1;
    80004736:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000473a:	0785                	addi	a5,a5,1
    8000473c:	fff7c703          	lbu	a4,-1(a5)
    80004740:	c701                	beqz	a4,80004748 <exec+0x2b8>
    if(*s == '/')
    80004742:	fed71ce3          	bne	a4,a3,8000473a <exec+0x2aa>
    80004746:	bfc5                	j	80004736 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004748:	4641                	li	a2,16
    8000474a:	df843583          	ld	a1,-520(s0)
    8000474e:	158a8513          	addi	a0,s5,344
    80004752:	eb4fc0ef          	jal	80000e06 <safestrcpy>
  oldpagetable = p->pagetable;
    80004756:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000475a:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000475e:	e0843783          	ld	a5,-504(s0)
    80004762:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004766:	058ab783          	ld	a5,88(s5)
    8000476a:	e6843703          	ld	a4,-408(s0)
    8000476e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004770:	058ab783          	ld	a5,88(s5)
    80004774:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004778:	85e6                	mv	a1,s9
    8000477a:	a9cfd0ef          	jal	80001a16 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000477e:	0004851b          	sext.w	a0,s1
    80004782:	79be                	ld	s3,488(sp)
    80004784:	7a1e                	ld	s4,480(sp)
    80004786:	6afe                	ld	s5,472(sp)
    80004788:	6b5e                	ld	s6,464(sp)
    8000478a:	6bbe                	ld	s7,456(sp)
    8000478c:	6c1e                	ld	s8,448(sp)
    8000478e:	7cfa                	ld	s9,440(sp)
    80004790:	7d5a                	ld	s10,432(sp)
    80004792:	b3b5                	j	800044fe <exec+0x6e>
    80004794:	e1243423          	sd	s2,-504(s0)
    80004798:	7dba                	ld	s11,424(sp)
    8000479a:	a035                	j	800047c6 <exec+0x336>
    8000479c:	e1243423          	sd	s2,-504(s0)
    800047a0:	7dba                	ld	s11,424(sp)
    800047a2:	a015                	j	800047c6 <exec+0x336>
    800047a4:	e1243423          	sd	s2,-504(s0)
    800047a8:	7dba                	ld	s11,424(sp)
    800047aa:	a831                	j	800047c6 <exec+0x336>
    800047ac:	e1243423          	sd	s2,-504(s0)
    800047b0:	7dba                	ld	s11,424(sp)
    800047b2:	a811                	j	800047c6 <exec+0x336>
    800047b4:	e1243423          	sd	s2,-504(s0)
    800047b8:	7dba                	ld	s11,424(sp)
    800047ba:	a031                	j	800047c6 <exec+0x336>
  ip = 0;
    800047bc:	4a01                	li	s4,0
    800047be:	a021                	j	800047c6 <exec+0x336>
    800047c0:	4a01                	li	s4,0
  if(pagetable)
    800047c2:	a011                	j	800047c6 <exec+0x336>
    800047c4:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800047c6:	e0843583          	ld	a1,-504(s0)
    800047ca:	855a                	mv	a0,s6
    800047cc:	a4afd0ef          	jal	80001a16 <proc_freepagetable>
  return -1;
    800047d0:	557d                	li	a0,-1
  if(ip){
    800047d2:	000a1b63          	bnez	s4,800047e8 <exec+0x358>
    800047d6:	79be                	ld	s3,488(sp)
    800047d8:	7a1e                	ld	s4,480(sp)
    800047da:	6afe                	ld	s5,472(sp)
    800047dc:	6b5e                	ld	s6,464(sp)
    800047de:	6bbe                	ld	s7,456(sp)
    800047e0:	6c1e                	ld	s8,448(sp)
    800047e2:	7cfa                	ld	s9,440(sp)
    800047e4:	7d5a                	ld	s10,432(sp)
    800047e6:	bb21                	j	800044fe <exec+0x6e>
    800047e8:	79be                	ld	s3,488(sp)
    800047ea:	6afe                	ld	s5,472(sp)
    800047ec:	6b5e                	ld	s6,464(sp)
    800047ee:	6bbe                	ld	s7,456(sp)
    800047f0:	6c1e                	ld	s8,448(sp)
    800047f2:	7cfa                	ld	s9,440(sp)
    800047f4:	7d5a                	ld	s10,432(sp)
    800047f6:	b9ed                	j	800044f0 <exec+0x60>
    800047f8:	6b5e                	ld	s6,464(sp)
    800047fa:	b9dd                	j	800044f0 <exec+0x60>
  sz = sz1;
    800047fc:	e0843983          	ld	s3,-504(s0)
    80004800:	b595                	j	80004664 <exec+0x1d4>

0000000080004802 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004802:	7179                	addi	sp,sp,-48
    80004804:	f406                	sd	ra,40(sp)
    80004806:	f022                	sd	s0,32(sp)
    80004808:	ec26                	sd	s1,24(sp)
    8000480a:	e84a                	sd	s2,16(sp)
    8000480c:	1800                	addi	s0,sp,48
    8000480e:	892e                	mv	s2,a1
    80004810:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004812:	fdc40593          	addi	a1,s0,-36
    80004816:	fa1fd0ef          	jal	800027b6 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000481a:	fdc42703          	lw	a4,-36(s0)
    8000481e:	47bd                	li	a5,15
    80004820:	02e7e963          	bltu	a5,a4,80004852 <argfd+0x50>
    80004824:	8c6fd0ef          	jal	800018ea <myproc>
    80004828:	fdc42703          	lw	a4,-36(s0)
    8000482c:	01a70793          	addi	a5,a4,26
    80004830:	078e                	slli	a5,a5,0x3
    80004832:	953e                	add	a0,a0,a5
    80004834:	611c                	ld	a5,0(a0)
    80004836:	c385                	beqz	a5,80004856 <argfd+0x54>
    return -1;
  if(pfd)
    80004838:	00090463          	beqz	s2,80004840 <argfd+0x3e>
    *pfd = fd;
    8000483c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004840:	4501                	li	a0,0
  if(pf)
    80004842:	c091                	beqz	s1,80004846 <argfd+0x44>
    *pf = f;
    80004844:	e09c                	sd	a5,0(s1)
}
    80004846:	70a2                	ld	ra,40(sp)
    80004848:	7402                	ld	s0,32(sp)
    8000484a:	64e2                	ld	s1,24(sp)
    8000484c:	6942                	ld	s2,16(sp)
    8000484e:	6145                	addi	sp,sp,48
    80004850:	8082                	ret
    return -1;
    80004852:	557d                	li	a0,-1
    80004854:	bfcd                	j	80004846 <argfd+0x44>
    80004856:	557d                	li	a0,-1
    80004858:	b7fd                	j	80004846 <argfd+0x44>

000000008000485a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000485a:	1101                	addi	sp,sp,-32
    8000485c:	ec06                	sd	ra,24(sp)
    8000485e:	e822                	sd	s0,16(sp)
    80004860:	e426                	sd	s1,8(sp)
    80004862:	1000                	addi	s0,sp,32
    80004864:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004866:	884fd0ef          	jal	800018ea <myproc>
    8000486a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000486c:	0d050793          	addi	a5,a0,208
    80004870:	4501                	li	a0,0
    80004872:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004874:	6398                	ld	a4,0(a5)
    80004876:	cb19                	beqz	a4,8000488c <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004878:	2505                	addiw	a0,a0,1
    8000487a:	07a1                	addi	a5,a5,8
    8000487c:	fed51ce3          	bne	a0,a3,80004874 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004880:	557d                	li	a0,-1
}
    80004882:	60e2                	ld	ra,24(sp)
    80004884:	6442                	ld	s0,16(sp)
    80004886:	64a2                	ld	s1,8(sp)
    80004888:	6105                	addi	sp,sp,32
    8000488a:	8082                	ret
      p->ofile[fd] = f;
    8000488c:	01a50793          	addi	a5,a0,26
    80004890:	078e                	slli	a5,a5,0x3
    80004892:	963e                	add	a2,a2,a5
    80004894:	e204                	sd	s1,0(a2)
      return fd;
    80004896:	b7f5                	j	80004882 <fdalloc+0x28>

0000000080004898 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004898:	715d                	addi	sp,sp,-80
    8000489a:	e486                	sd	ra,72(sp)
    8000489c:	e0a2                	sd	s0,64(sp)
    8000489e:	fc26                	sd	s1,56(sp)
    800048a0:	f84a                	sd	s2,48(sp)
    800048a2:	f44e                	sd	s3,40(sp)
    800048a4:	ec56                	sd	s5,24(sp)
    800048a6:	e85a                	sd	s6,16(sp)
    800048a8:	0880                	addi	s0,sp,80
    800048aa:	8b2e                	mv	s6,a1
    800048ac:	89b2                	mv	s3,a2
    800048ae:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800048b0:	fb040593          	addi	a1,s0,-80
    800048b4:	822ff0ef          	jal	800038d6 <nameiparent>
    800048b8:	84aa                	mv	s1,a0
    800048ba:	10050a63          	beqz	a0,800049ce <create+0x136>
    return 0;

  ilock(dp);
    800048be:	925fe0ef          	jal	800031e2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800048c2:	4601                	li	a2,0
    800048c4:	fb040593          	addi	a1,s0,-80
    800048c8:	8526                	mv	a0,s1
    800048ca:	d8dfe0ef          	jal	80003656 <dirlookup>
    800048ce:	8aaa                	mv	s5,a0
    800048d0:	c129                	beqz	a0,80004912 <create+0x7a>
    iunlockput(dp);
    800048d2:	8526                	mv	a0,s1
    800048d4:	b19fe0ef          	jal	800033ec <iunlockput>
    ilock(ip);
    800048d8:	8556                	mv	a0,s5
    800048da:	909fe0ef          	jal	800031e2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800048de:	4789                	li	a5,2
    800048e0:	02fb1463          	bne	s6,a5,80004908 <create+0x70>
    800048e4:	044ad783          	lhu	a5,68(s5)
    800048e8:	37f9                	addiw	a5,a5,-2
    800048ea:	17c2                	slli	a5,a5,0x30
    800048ec:	93c1                	srli	a5,a5,0x30
    800048ee:	4705                	li	a4,1
    800048f0:	00f76c63          	bltu	a4,a5,80004908 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800048f4:	8556                	mv	a0,s5
    800048f6:	60a6                	ld	ra,72(sp)
    800048f8:	6406                	ld	s0,64(sp)
    800048fa:	74e2                	ld	s1,56(sp)
    800048fc:	7942                	ld	s2,48(sp)
    800048fe:	79a2                	ld	s3,40(sp)
    80004900:	6ae2                	ld	s5,24(sp)
    80004902:	6b42                	ld	s6,16(sp)
    80004904:	6161                	addi	sp,sp,80
    80004906:	8082                	ret
    iunlockput(ip);
    80004908:	8556                	mv	a0,s5
    8000490a:	ae3fe0ef          	jal	800033ec <iunlockput>
    return 0;
    8000490e:	4a81                	li	s5,0
    80004910:	b7d5                	j	800048f4 <create+0x5c>
    80004912:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004914:	85da                	mv	a1,s6
    80004916:	4088                	lw	a0,0(s1)
    80004918:	f5afe0ef          	jal	80003072 <ialloc>
    8000491c:	8a2a                	mv	s4,a0
    8000491e:	cd15                	beqz	a0,8000495a <create+0xc2>
  ilock(ip);
    80004920:	8c3fe0ef          	jal	800031e2 <ilock>
  ip->major = major;
    80004924:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004928:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000492c:	4905                	li	s2,1
    8000492e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004932:	8552                	mv	a0,s4
    80004934:	ffafe0ef          	jal	8000312e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004938:	032b0763          	beq	s6,s2,80004966 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    8000493c:	004a2603          	lw	a2,4(s4)
    80004940:	fb040593          	addi	a1,s0,-80
    80004944:	8526                	mv	a0,s1
    80004946:	eddfe0ef          	jal	80003822 <dirlink>
    8000494a:	06054563          	bltz	a0,800049b4 <create+0x11c>
  iunlockput(dp);
    8000494e:	8526                	mv	a0,s1
    80004950:	a9dfe0ef          	jal	800033ec <iunlockput>
  return ip;
    80004954:	8ad2                	mv	s5,s4
    80004956:	7a02                	ld	s4,32(sp)
    80004958:	bf71                	j	800048f4 <create+0x5c>
    iunlockput(dp);
    8000495a:	8526                	mv	a0,s1
    8000495c:	a91fe0ef          	jal	800033ec <iunlockput>
    return 0;
    80004960:	8ad2                	mv	s5,s4
    80004962:	7a02                	ld	s4,32(sp)
    80004964:	bf41                	j	800048f4 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004966:	004a2603          	lw	a2,4(s4)
    8000496a:	00003597          	auipc	a1,0x3
    8000496e:	ce658593          	addi	a1,a1,-794 # 80007650 <etext+0x650>
    80004972:	8552                	mv	a0,s4
    80004974:	eaffe0ef          	jal	80003822 <dirlink>
    80004978:	02054e63          	bltz	a0,800049b4 <create+0x11c>
    8000497c:	40d0                	lw	a2,4(s1)
    8000497e:	00003597          	auipc	a1,0x3
    80004982:	cda58593          	addi	a1,a1,-806 # 80007658 <etext+0x658>
    80004986:	8552                	mv	a0,s4
    80004988:	e9bfe0ef          	jal	80003822 <dirlink>
    8000498c:	02054463          	bltz	a0,800049b4 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004990:	004a2603          	lw	a2,4(s4)
    80004994:	fb040593          	addi	a1,s0,-80
    80004998:	8526                	mv	a0,s1
    8000499a:	e89fe0ef          	jal	80003822 <dirlink>
    8000499e:	00054b63          	bltz	a0,800049b4 <create+0x11c>
    dp->nlink++;  // for ".."
    800049a2:	04a4d783          	lhu	a5,74(s1)
    800049a6:	2785                	addiw	a5,a5,1
    800049a8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800049ac:	8526                	mv	a0,s1
    800049ae:	f80fe0ef          	jal	8000312e <iupdate>
    800049b2:	bf71                	j	8000494e <create+0xb6>
  ip->nlink = 0;
    800049b4:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800049b8:	8552                	mv	a0,s4
    800049ba:	f74fe0ef          	jal	8000312e <iupdate>
  iunlockput(ip);
    800049be:	8552                	mv	a0,s4
    800049c0:	a2dfe0ef          	jal	800033ec <iunlockput>
  iunlockput(dp);
    800049c4:	8526                	mv	a0,s1
    800049c6:	a27fe0ef          	jal	800033ec <iunlockput>
  return 0;
    800049ca:	7a02                	ld	s4,32(sp)
    800049cc:	b725                	j	800048f4 <create+0x5c>
    return 0;
    800049ce:	8aaa                	mv	s5,a0
    800049d0:	b715                	j	800048f4 <create+0x5c>

00000000800049d2 <sys_dup>:
{
    800049d2:	7179                	addi	sp,sp,-48
    800049d4:	f406                	sd	ra,40(sp)
    800049d6:	f022                	sd	s0,32(sp)
    800049d8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800049da:	fd840613          	addi	a2,s0,-40
    800049de:	4581                	li	a1,0
    800049e0:	4501                	li	a0,0
    800049e2:	e21ff0ef          	jal	80004802 <argfd>
    return -1;
    800049e6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800049e8:	02054363          	bltz	a0,80004a0e <sys_dup+0x3c>
    800049ec:	ec26                	sd	s1,24(sp)
    800049ee:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800049f0:	fd843903          	ld	s2,-40(s0)
    800049f4:	854a                	mv	a0,s2
    800049f6:	e65ff0ef          	jal	8000485a <fdalloc>
    800049fa:	84aa                	mv	s1,a0
    return -1;
    800049fc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800049fe:	00054d63          	bltz	a0,80004a18 <sys_dup+0x46>
  filedup(f);
    80004a02:	854a                	mv	a0,s2
    80004a04:	c48ff0ef          	jal	80003e4c <filedup>
  return fd;
    80004a08:	87a6                	mv	a5,s1
    80004a0a:	64e2                	ld	s1,24(sp)
    80004a0c:	6942                	ld	s2,16(sp)
}
    80004a0e:	853e                	mv	a0,a5
    80004a10:	70a2                	ld	ra,40(sp)
    80004a12:	7402                	ld	s0,32(sp)
    80004a14:	6145                	addi	sp,sp,48
    80004a16:	8082                	ret
    80004a18:	64e2                	ld	s1,24(sp)
    80004a1a:	6942                	ld	s2,16(sp)
    80004a1c:	bfcd                	j	80004a0e <sys_dup+0x3c>

0000000080004a1e <sys_read>:
{
    80004a1e:	7179                	addi	sp,sp,-48
    80004a20:	f406                	sd	ra,40(sp)
    80004a22:	f022                	sd	s0,32(sp)
    80004a24:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a26:	fd840593          	addi	a1,s0,-40
    80004a2a:	4505                	li	a0,1
    80004a2c:	da7fd0ef          	jal	800027d2 <argaddr>
  argint(2, &n);
    80004a30:	fe440593          	addi	a1,s0,-28
    80004a34:	4509                	li	a0,2
    80004a36:	d81fd0ef          	jal	800027b6 <argint>
  if(argfd(0, 0, &f) < 0)
    80004a3a:	fe840613          	addi	a2,s0,-24
    80004a3e:	4581                	li	a1,0
    80004a40:	4501                	li	a0,0
    80004a42:	dc1ff0ef          	jal	80004802 <argfd>
    80004a46:	87aa                	mv	a5,a0
    return -1;
    80004a48:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a4a:	0007ca63          	bltz	a5,80004a5e <sys_read+0x40>
  return fileread(f, p, n);
    80004a4e:	fe442603          	lw	a2,-28(s0)
    80004a52:	fd843583          	ld	a1,-40(s0)
    80004a56:	fe843503          	ld	a0,-24(s0)
    80004a5a:	d58ff0ef          	jal	80003fb2 <fileread>
}
    80004a5e:	70a2                	ld	ra,40(sp)
    80004a60:	7402                	ld	s0,32(sp)
    80004a62:	6145                	addi	sp,sp,48
    80004a64:	8082                	ret

0000000080004a66 <sys_write>:
{
    80004a66:	7179                	addi	sp,sp,-48
    80004a68:	f406                	sd	ra,40(sp)
    80004a6a:	f022                	sd	s0,32(sp)
    80004a6c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a6e:	fd840593          	addi	a1,s0,-40
    80004a72:	4505                	li	a0,1
    80004a74:	d5ffd0ef          	jal	800027d2 <argaddr>
  argint(2, &n);
    80004a78:	fe440593          	addi	a1,s0,-28
    80004a7c:	4509                	li	a0,2
    80004a7e:	d39fd0ef          	jal	800027b6 <argint>
  if(argfd(0, 0, &f) < 0)
    80004a82:	fe840613          	addi	a2,s0,-24
    80004a86:	4581                	li	a1,0
    80004a88:	4501                	li	a0,0
    80004a8a:	d79ff0ef          	jal	80004802 <argfd>
    80004a8e:	87aa                	mv	a5,a0
    return -1;
    80004a90:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a92:	0007ca63          	bltz	a5,80004aa6 <sys_write+0x40>
  return filewrite(f, p, n);
    80004a96:	fe442603          	lw	a2,-28(s0)
    80004a9a:	fd843583          	ld	a1,-40(s0)
    80004a9e:	fe843503          	ld	a0,-24(s0)
    80004aa2:	dceff0ef          	jal	80004070 <filewrite>
}
    80004aa6:	70a2                	ld	ra,40(sp)
    80004aa8:	7402                	ld	s0,32(sp)
    80004aaa:	6145                	addi	sp,sp,48
    80004aac:	8082                	ret

0000000080004aae <sys_close>:
{
    80004aae:	1101                	addi	sp,sp,-32
    80004ab0:	ec06                	sd	ra,24(sp)
    80004ab2:	e822                	sd	s0,16(sp)
    80004ab4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004ab6:	fe040613          	addi	a2,s0,-32
    80004aba:	fec40593          	addi	a1,s0,-20
    80004abe:	4501                	li	a0,0
    80004ac0:	d43ff0ef          	jal	80004802 <argfd>
    return -1;
    80004ac4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004ac6:	02054063          	bltz	a0,80004ae6 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004aca:	e21fc0ef          	jal	800018ea <myproc>
    80004ace:	fec42783          	lw	a5,-20(s0)
    80004ad2:	07e9                	addi	a5,a5,26
    80004ad4:	078e                	slli	a5,a5,0x3
    80004ad6:	953e                	add	a0,a0,a5
    80004ad8:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004adc:	fe043503          	ld	a0,-32(s0)
    80004ae0:	bb2ff0ef          	jal	80003e92 <fileclose>
  return 0;
    80004ae4:	4781                	li	a5,0
}
    80004ae6:	853e                	mv	a0,a5
    80004ae8:	60e2                	ld	ra,24(sp)
    80004aea:	6442                	ld	s0,16(sp)
    80004aec:	6105                	addi	sp,sp,32
    80004aee:	8082                	ret

0000000080004af0 <sys_fstat>:
{
    80004af0:	1101                	addi	sp,sp,-32
    80004af2:	ec06                	sd	ra,24(sp)
    80004af4:	e822                	sd	s0,16(sp)
    80004af6:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004af8:	fe040593          	addi	a1,s0,-32
    80004afc:	4505                	li	a0,1
    80004afe:	cd5fd0ef          	jal	800027d2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004b02:	fe840613          	addi	a2,s0,-24
    80004b06:	4581                	li	a1,0
    80004b08:	4501                	li	a0,0
    80004b0a:	cf9ff0ef          	jal	80004802 <argfd>
    80004b0e:	87aa                	mv	a5,a0
    return -1;
    80004b10:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b12:	0007c863          	bltz	a5,80004b22 <sys_fstat+0x32>
  return filestat(f, st);
    80004b16:	fe043583          	ld	a1,-32(s0)
    80004b1a:	fe843503          	ld	a0,-24(s0)
    80004b1e:	c36ff0ef          	jal	80003f54 <filestat>
}
    80004b22:	60e2                	ld	ra,24(sp)
    80004b24:	6442                	ld	s0,16(sp)
    80004b26:	6105                	addi	sp,sp,32
    80004b28:	8082                	ret

0000000080004b2a <sys_link>:
{
    80004b2a:	7169                	addi	sp,sp,-304
    80004b2c:	f606                	sd	ra,296(sp)
    80004b2e:	f222                	sd	s0,288(sp)
    80004b30:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b32:	08000613          	li	a2,128
    80004b36:	ed040593          	addi	a1,s0,-304
    80004b3a:	4501                	li	a0,0
    80004b3c:	cb3fd0ef          	jal	800027ee <argstr>
    return -1;
    80004b40:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b42:	0c054e63          	bltz	a0,80004c1e <sys_link+0xf4>
    80004b46:	08000613          	li	a2,128
    80004b4a:	f5040593          	addi	a1,s0,-176
    80004b4e:	4505                	li	a0,1
    80004b50:	c9ffd0ef          	jal	800027ee <argstr>
    return -1;
    80004b54:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b56:	0c054463          	bltz	a0,80004c1e <sys_link+0xf4>
    80004b5a:	ee26                	sd	s1,280(sp)
  begin_op();
    80004b5c:	f1dfe0ef          	jal	80003a78 <begin_op>
  if((ip = namei(old)) == 0){
    80004b60:	ed040513          	addi	a0,s0,-304
    80004b64:	d59fe0ef          	jal	800038bc <namei>
    80004b68:	84aa                	mv	s1,a0
    80004b6a:	c53d                	beqz	a0,80004bd8 <sys_link+0xae>
  ilock(ip);
    80004b6c:	e76fe0ef          	jal	800031e2 <ilock>
  if(ip->type == T_DIR){
    80004b70:	04449703          	lh	a4,68(s1)
    80004b74:	4785                	li	a5,1
    80004b76:	06f70663          	beq	a4,a5,80004be2 <sys_link+0xb8>
    80004b7a:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004b7c:	04a4d783          	lhu	a5,74(s1)
    80004b80:	2785                	addiw	a5,a5,1
    80004b82:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b86:	8526                	mv	a0,s1
    80004b88:	da6fe0ef          	jal	8000312e <iupdate>
  iunlock(ip);
    80004b8c:	8526                	mv	a0,s1
    80004b8e:	f02fe0ef          	jal	80003290 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004b92:	fd040593          	addi	a1,s0,-48
    80004b96:	f5040513          	addi	a0,s0,-176
    80004b9a:	d3dfe0ef          	jal	800038d6 <nameiparent>
    80004b9e:	892a                	mv	s2,a0
    80004ba0:	cd21                	beqz	a0,80004bf8 <sys_link+0xce>
  ilock(dp);
    80004ba2:	e40fe0ef          	jal	800031e2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004ba6:	00092703          	lw	a4,0(s2)
    80004baa:	409c                	lw	a5,0(s1)
    80004bac:	04f71363          	bne	a4,a5,80004bf2 <sys_link+0xc8>
    80004bb0:	40d0                	lw	a2,4(s1)
    80004bb2:	fd040593          	addi	a1,s0,-48
    80004bb6:	854a                	mv	a0,s2
    80004bb8:	c6bfe0ef          	jal	80003822 <dirlink>
    80004bbc:	02054b63          	bltz	a0,80004bf2 <sys_link+0xc8>
  iunlockput(dp);
    80004bc0:	854a                	mv	a0,s2
    80004bc2:	82bfe0ef          	jal	800033ec <iunlockput>
  iput(ip);
    80004bc6:	8526                	mv	a0,s1
    80004bc8:	f9cfe0ef          	jal	80003364 <iput>
  end_op();
    80004bcc:	f17fe0ef          	jal	80003ae2 <end_op>
  return 0;
    80004bd0:	4781                	li	a5,0
    80004bd2:	64f2                	ld	s1,280(sp)
    80004bd4:	6952                	ld	s2,272(sp)
    80004bd6:	a0a1                	j	80004c1e <sys_link+0xf4>
    end_op();
    80004bd8:	f0bfe0ef          	jal	80003ae2 <end_op>
    return -1;
    80004bdc:	57fd                	li	a5,-1
    80004bde:	64f2                	ld	s1,280(sp)
    80004be0:	a83d                	j	80004c1e <sys_link+0xf4>
    iunlockput(ip);
    80004be2:	8526                	mv	a0,s1
    80004be4:	809fe0ef          	jal	800033ec <iunlockput>
    end_op();
    80004be8:	efbfe0ef          	jal	80003ae2 <end_op>
    return -1;
    80004bec:	57fd                	li	a5,-1
    80004bee:	64f2                	ld	s1,280(sp)
    80004bf0:	a03d                	j	80004c1e <sys_link+0xf4>
    iunlockput(dp);
    80004bf2:	854a                	mv	a0,s2
    80004bf4:	ff8fe0ef          	jal	800033ec <iunlockput>
  ilock(ip);
    80004bf8:	8526                	mv	a0,s1
    80004bfa:	de8fe0ef          	jal	800031e2 <ilock>
  ip->nlink--;
    80004bfe:	04a4d783          	lhu	a5,74(s1)
    80004c02:	37fd                	addiw	a5,a5,-1
    80004c04:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c08:	8526                	mv	a0,s1
    80004c0a:	d24fe0ef          	jal	8000312e <iupdate>
  iunlockput(ip);
    80004c0e:	8526                	mv	a0,s1
    80004c10:	fdcfe0ef          	jal	800033ec <iunlockput>
  end_op();
    80004c14:	ecffe0ef          	jal	80003ae2 <end_op>
  return -1;
    80004c18:	57fd                	li	a5,-1
    80004c1a:	64f2                	ld	s1,280(sp)
    80004c1c:	6952                	ld	s2,272(sp)
}
    80004c1e:	853e                	mv	a0,a5
    80004c20:	70b2                	ld	ra,296(sp)
    80004c22:	7412                	ld	s0,288(sp)
    80004c24:	6155                	addi	sp,sp,304
    80004c26:	8082                	ret

0000000080004c28 <sys_unlink>:
{
    80004c28:	7151                	addi	sp,sp,-240
    80004c2a:	f586                	sd	ra,232(sp)
    80004c2c:	f1a2                	sd	s0,224(sp)
    80004c2e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c30:	08000613          	li	a2,128
    80004c34:	f3040593          	addi	a1,s0,-208
    80004c38:	4501                	li	a0,0
    80004c3a:	bb5fd0ef          	jal	800027ee <argstr>
    80004c3e:	16054063          	bltz	a0,80004d9e <sys_unlink+0x176>
    80004c42:	eda6                	sd	s1,216(sp)
  begin_op();
    80004c44:	e35fe0ef          	jal	80003a78 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004c48:	fb040593          	addi	a1,s0,-80
    80004c4c:	f3040513          	addi	a0,s0,-208
    80004c50:	c87fe0ef          	jal	800038d6 <nameiparent>
    80004c54:	84aa                	mv	s1,a0
    80004c56:	c945                	beqz	a0,80004d06 <sys_unlink+0xde>
  ilock(dp);
    80004c58:	d8afe0ef          	jal	800031e2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004c5c:	00003597          	auipc	a1,0x3
    80004c60:	9f458593          	addi	a1,a1,-1548 # 80007650 <etext+0x650>
    80004c64:	fb040513          	addi	a0,s0,-80
    80004c68:	9d9fe0ef          	jal	80003640 <namecmp>
    80004c6c:	10050e63          	beqz	a0,80004d88 <sys_unlink+0x160>
    80004c70:	00003597          	auipc	a1,0x3
    80004c74:	9e858593          	addi	a1,a1,-1560 # 80007658 <etext+0x658>
    80004c78:	fb040513          	addi	a0,s0,-80
    80004c7c:	9c5fe0ef          	jal	80003640 <namecmp>
    80004c80:	10050463          	beqz	a0,80004d88 <sys_unlink+0x160>
    80004c84:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c86:	f2c40613          	addi	a2,s0,-212
    80004c8a:	fb040593          	addi	a1,s0,-80
    80004c8e:	8526                	mv	a0,s1
    80004c90:	9c7fe0ef          	jal	80003656 <dirlookup>
    80004c94:	892a                	mv	s2,a0
    80004c96:	0e050863          	beqz	a0,80004d86 <sys_unlink+0x15e>
  ilock(ip);
    80004c9a:	d48fe0ef          	jal	800031e2 <ilock>
  if(ip->nlink < 1)
    80004c9e:	04a91783          	lh	a5,74(s2)
    80004ca2:	06f05763          	blez	a5,80004d10 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ca6:	04491703          	lh	a4,68(s2)
    80004caa:	4785                	li	a5,1
    80004cac:	06f70963          	beq	a4,a5,80004d1e <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004cb0:	4641                	li	a2,16
    80004cb2:	4581                	li	a1,0
    80004cb4:	fc040513          	addi	a0,s0,-64
    80004cb8:	810fc0ef          	jal	80000cc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cbc:	4741                	li	a4,16
    80004cbe:	f2c42683          	lw	a3,-212(s0)
    80004cc2:	fc040613          	addi	a2,s0,-64
    80004cc6:	4581                	li	a1,0
    80004cc8:	8526                	mv	a0,s1
    80004cca:	869fe0ef          	jal	80003532 <writei>
    80004cce:	47c1                	li	a5,16
    80004cd0:	08f51b63          	bne	a0,a5,80004d66 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004cd4:	04491703          	lh	a4,68(s2)
    80004cd8:	4785                	li	a5,1
    80004cda:	08f70d63          	beq	a4,a5,80004d74 <sys_unlink+0x14c>
  iunlockput(dp);
    80004cde:	8526                	mv	a0,s1
    80004ce0:	f0cfe0ef          	jal	800033ec <iunlockput>
  ip->nlink--;
    80004ce4:	04a95783          	lhu	a5,74(s2)
    80004ce8:	37fd                	addiw	a5,a5,-1
    80004cea:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004cee:	854a                	mv	a0,s2
    80004cf0:	c3efe0ef          	jal	8000312e <iupdate>
  iunlockput(ip);
    80004cf4:	854a                	mv	a0,s2
    80004cf6:	ef6fe0ef          	jal	800033ec <iunlockput>
  end_op();
    80004cfa:	de9fe0ef          	jal	80003ae2 <end_op>
  return 0;
    80004cfe:	4501                	li	a0,0
    80004d00:	64ee                	ld	s1,216(sp)
    80004d02:	694e                	ld	s2,208(sp)
    80004d04:	a849                	j	80004d96 <sys_unlink+0x16e>
    end_op();
    80004d06:	dddfe0ef          	jal	80003ae2 <end_op>
    return -1;
    80004d0a:	557d                	li	a0,-1
    80004d0c:	64ee                	ld	s1,216(sp)
    80004d0e:	a061                	j	80004d96 <sys_unlink+0x16e>
    80004d10:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004d12:	00003517          	auipc	a0,0x3
    80004d16:	94e50513          	addi	a0,a0,-1714 # 80007660 <etext+0x660>
    80004d1a:	a7bfb0ef          	jal	80000794 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d1e:	04c92703          	lw	a4,76(s2)
    80004d22:	02000793          	li	a5,32
    80004d26:	f8e7f5e3          	bgeu	a5,a4,80004cb0 <sys_unlink+0x88>
    80004d2a:	e5ce                	sd	s3,200(sp)
    80004d2c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d30:	4741                	li	a4,16
    80004d32:	86ce                	mv	a3,s3
    80004d34:	f1840613          	addi	a2,s0,-232
    80004d38:	4581                	li	a1,0
    80004d3a:	854a                	mv	a0,s2
    80004d3c:	efafe0ef          	jal	80003436 <readi>
    80004d40:	47c1                	li	a5,16
    80004d42:	00f51c63          	bne	a0,a5,80004d5a <sys_unlink+0x132>
    if(de.inum != 0)
    80004d46:	f1845783          	lhu	a5,-232(s0)
    80004d4a:	efa1                	bnez	a5,80004da2 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d4c:	29c1                	addiw	s3,s3,16
    80004d4e:	04c92783          	lw	a5,76(s2)
    80004d52:	fcf9efe3          	bltu	s3,a5,80004d30 <sys_unlink+0x108>
    80004d56:	69ae                	ld	s3,200(sp)
    80004d58:	bfa1                	j	80004cb0 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004d5a:	00003517          	auipc	a0,0x3
    80004d5e:	91e50513          	addi	a0,a0,-1762 # 80007678 <etext+0x678>
    80004d62:	a33fb0ef          	jal	80000794 <panic>
    80004d66:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004d68:	00003517          	auipc	a0,0x3
    80004d6c:	92850513          	addi	a0,a0,-1752 # 80007690 <etext+0x690>
    80004d70:	a25fb0ef          	jal	80000794 <panic>
    dp->nlink--;
    80004d74:	04a4d783          	lhu	a5,74(s1)
    80004d78:	37fd                	addiw	a5,a5,-1
    80004d7a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d7e:	8526                	mv	a0,s1
    80004d80:	baefe0ef          	jal	8000312e <iupdate>
    80004d84:	bfa9                	j	80004cde <sys_unlink+0xb6>
    80004d86:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004d88:	8526                	mv	a0,s1
    80004d8a:	e62fe0ef          	jal	800033ec <iunlockput>
  end_op();
    80004d8e:	d55fe0ef          	jal	80003ae2 <end_op>
  return -1;
    80004d92:	557d                	li	a0,-1
    80004d94:	64ee                	ld	s1,216(sp)
}
    80004d96:	70ae                	ld	ra,232(sp)
    80004d98:	740e                	ld	s0,224(sp)
    80004d9a:	616d                	addi	sp,sp,240
    80004d9c:	8082                	ret
    return -1;
    80004d9e:	557d                	li	a0,-1
    80004da0:	bfdd                	j	80004d96 <sys_unlink+0x16e>
    iunlockput(ip);
    80004da2:	854a                	mv	a0,s2
    80004da4:	e48fe0ef          	jal	800033ec <iunlockput>
    goto bad;
    80004da8:	694e                	ld	s2,208(sp)
    80004daa:	69ae                	ld	s3,200(sp)
    80004dac:	bff1                	j	80004d88 <sys_unlink+0x160>

0000000080004dae <sys_open>:

uint64
sys_open(void)
{
    80004dae:	7131                	addi	sp,sp,-192
    80004db0:	fd06                	sd	ra,184(sp)
    80004db2:	f922                	sd	s0,176(sp)
    80004db4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004db6:	f4c40593          	addi	a1,s0,-180
    80004dba:	4505                	li	a0,1
    80004dbc:	9fbfd0ef          	jal	800027b6 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004dc0:	08000613          	li	a2,128
    80004dc4:	f5040593          	addi	a1,s0,-176
    80004dc8:	4501                	li	a0,0
    80004dca:	a25fd0ef          	jal	800027ee <argstr>
    80004dce:	87aa                	mv	a5,a0
    return -1;
    80004dd0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004dd2:	0a07c263          	bltz	a5,80004e76 <sys_open+0xc8>
    80004dd6:	f526                	sd	s1,168(sp)

  begin_op();
    80004dd8:	ca1fe0ef          	jal	80003a78 <begin_op>

  if(omode & O_CREATE){
    80004ddc:	f4c42783          	lw	a5,-180(s0)
    80004de0:	2007f793          	andi	a5,a5,512
    80004de4:	c3d5                	beqz	a5,80004e88 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004de6:	4681                	li	a3,0
    80004de8:	4601                	li	a2,0
    80004dea:	4589                	li	a1,2
    80004dec:	f5040513          	addi	a0,s0,-176
    80004df0:	aa9ff0ef          	jal	80004898 <create>
    80004df4:	84aa                	mv	s1,a0
    if(ip == 0){
    80004df6:	c541                	beqz	a0,80004e7e <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004df8:	04449703          	lh	a4,68(s1)
    80004dfc:	478d                	li	a5,3
    80004dfe:	00f71763          	bne	a4,a5,80004e0c <sys_open+0x5e>
    80004e02:	0464d703          	lhu	a4,70(s1)
    80004e06:	47a5                	li	a5,9
    80004e08:	0ae7ed63          	bltu	a5,a4,80004ec2 <sys_open+0x114>
    80004e0c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004e0e:	fe1fe0ef          	jal	80003dee <filealloc>
    80004e12:	892a                	mv	s2,a0
    80004e14:	c179                	beqz	a0,80004eda <sys_open+0x12c>
    80004e16:	ed4e                	sd	s3,152(sp)
    80004e18:	a43ff0ef          	jal	8000485a <fdalloc>
    80004e1c:	89aa                	mv	s3,a0
    80004e1e:	0a054a63          	bltz	a0,80004ed2 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e22:	04449703          	lh	a4,68(s1)
    80004e26:	478d                	li	a5,3
    80004e28:	0cf70263          	beq	a4,a5,80004eec <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e2c:	4789                	li	a5,2
    80004e2e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004e32:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004e36:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004e3a:	f4c42783          	lw	a5,-180(s0)
    80004e3e:	0017c713          	xori	a4,a5,1
    80004e42:	8b05                	andi	a4,a4,1
    80004e44:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e48:	0037f713          	andi	a4,a5,3
    80004e4c:	00e03733          	snez	a4,a4
    80004e50:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e54:	4007f793          	andi	a5,a5,1024
    80004e58:	c791                	beqz	a5,80004e64 <sys_open+0xb6>
    80004e5a:	04449703          	lh	a4,68(s1)
    80004e5e:	4789                	li	a5,2
    80004e60:	08f70d63          	beq	a4,a5,80004efa <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e64:	8526                	mv	a0,s1
    80004e66:	c2afe0ef          	jal	80003290 <iunlock>
  end_op();
    80004e6a:	c79fe0ef          	jal	80003ae2 <end_op>

  return fd;
    80004e6e:	854e                	mv	a0,s3
    80004e70:	74aa                	ld	s1,168(sp)
    80004e72:	790a                	ld	s2,160(sp)
    80004e74:	69ea                	ld	s3,152(sp)
}
    80004e76:	70ea                	ld	ra,184(sp)
    80004e78:	744a                	ld	s0,176(sp)
    80004e7a:	6129                	addi	sp,sp,192
    80004e7c:	8082                	ret
      end_op();
    80004e7e:	c65fe0ef          	jal	80003ae2 <end_op>
      return -1;
    80004e82:	557d                	li	a0,-1
    80004e84:	74aa                	ld	s1,168(sp)
    80004e86:	bfc5                	j	80004e76 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004e88:	f5040513          	addi	a0,s0,-176
    80004e8c:	a31fe0ef          	jal	800038bc <namei>
    80004e90:	84aa                	mv	s1,a0
    80004e92:	c11d                	beqz	a0,80004eb8 <sys_open+0x10a>
    ilock(ip);
    80004e94:	b4efe0ef          	jal	800031e2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e98:	04449703          	lh	a4,68(s1)
    80004e9c:	4785                	li	a5,1
    80004e9e:	f4f71de3          	bne	a4,a5,80004df8 <sys_open+0x4a>
    80004ea2:	f4c42783          	lw	a5,-180(s0)
    80004ea6:	d3bd                	beqz	a5,80004e0c <sys_open+0x5e>
      iunlockput(ip);
    80004ea8:	8526                	mv	a0,s1
    80004eaa:	d42fe0ef          	jal	800033ec <iunlockput>
      end_op();
    80004eae:	c35fe0ef          	jal	80003ae2 <end_op>
      return -1;
    80004eb2:	557d                	li	a0,-1
    80004eb4:	74aa                	ld	s1,168(sp)
    80004eb6:	b7c1                	j	80004e76 <sys_open+0xc8>
      end_op();
    80004eb8:	c2bfe0ef          	jal	80003ae2 <end_op>
      return -1;
    80004ebc:	557d                	li	a0,-1
    80004ebe:	74aa                	ld	s1,168(sp)
    80004ec0:	bf5d                	j	80004e76 <sys_open+0xc8>
    iunlockput(ip);
    80004ec2:	8526                	mv	a0,s1
    80004ec4:	d28fe0ef          	jal	800033ec <iunlockput>
    end_op();
    80004ec8:	c1bfe0ef          	jal	80003ae2 <end_op>
    return -1;
    80004ecc:	557d                	li	a0,-1
    80004ece:	74aa                	ld	s1,168(sp)
    80004ed0:	b75d                	j	80004e76 <sys_open+0xc8>
      fileclose(f);
    80004ed2:	854a                	mv	a0,s2
    80004ed4:	fbffe0ef          	jal	80003e92 <fileclose>
    80004ed8:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004eda:	8526                	mv	a0,s1
    80004edc:	d10fe0ef          	jal	800033ec <iunlockput>
    end_op();
    80004ee0:	c03fe0ef          	jal	80003ae2 <end_op>
    return -1;
    80004ee4:	557d                	li	a0,-1
    80004ee6:	74aa                	ld	s1,168(sp)
    80004ee8:	790a                	ld	s2,160(sp)
    80004eea:	b771                	j	80004e76 <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004eec:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004ef0:	04649783          	lh	a5,70(s1)
    80004ef4:	02f91223          	sh	a5,36(s2)
    80004ef8:	bf3d                	j	80004e36 <sys_open+0x88>
    itrunc(ip);
    80004efa:	8526                	mv	a0,s1
    80004efc:	bd4fe0ef          	jal	800032d0 <itrunc>
    80004f00:	b795                	j	80004e64 <sys_open+0xb6>

0000000080004f02 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f02:	7175                	addi	sp,sp,-144
    80004f04:	e506                	sd	ra,136(sp)
    80004f06:	e122                	sd	s0,128(sp)
    80004f08:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f0a:	b6ffe0ef          	jal	80003a78 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f0e:	08000613          	li	a2,128
    80004f12:	f7040593          	addi	a1,s0,-144
    80004f16:	4501                	li	a0,0
    80004f18:	8d7fd0ef          	jal	800027ee <argstr>
    80004f1c:	02054363          	bltz	a0,80004f42 <sys_mkdir+0x40>
    80004f20:	4681                	li	a3,0
    80004f22:	4601                	li	a2,0
    80004f24:	4585                	li	a1,1
    80004f26:	f7040513          	addi	a0,s0,-144
    80004f2a:	96fff0ef          	jal	80004898 <create>
    80004f2e:	c911                	beqz	a0,80004f42 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f30:	cbcfe0ef          	jal	800033ec <iunlockput>
  end_op();
    80004f34:	baffe0ef          	jal	80003ae2 <end_op>
  return 0;
    80004f38:	4501                	li	a0,0
}
    80004f3a:	60aa                	ld	ra,136(sp)
    80004f3c:	640a                	ld	s0,128(sp)
    80004f3e:	6149                	addi	sp,sp,144
    80004f40:	8082                	ret
    end_op();
    80004f42:	ba1fe0ef          	jal	80003ae2 <end_op>
    return -1;
    80004f46:	557d                	li	a0,-1
    80004f48:	bfcd                	j	80004f3a <sys_mkdir+0x38>

0000000080004f4a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f4a:	7135                	addi	sp,sp,-160
    80004f4c:	ed06                	sd	ra,152(sp)
    80004f4e:	e922                	sd	s0,144(sp)
    80004f50:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f52:	b27fe0ef          	jal	80003a78 <begin_op>
  argint(1, &major);
    80004f56:	f6c40593          	addi	a1,s0,-148
    80004f5a:	4505                	li	a0,1
    80004f5c:	85bfd0ef          	jal	800027b6 <argint>
  argint(2, &minor);
    80004f60:	f6840593          	addi	a1,s0,-152
    80004f64:	4509                	li	a0,2
    80004f66:	851fd0ef          	jal	800027b6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f6a:	08000613          	li	a2,128
    80004f6e:	f7040593          	addi	a1,s0,-144
    80004f72:	4501                	li	a0,0
    80004f74:	87bfd0ef          	jal	800027ee <argstr>
    80004f78:	02054563          	bltz	a0,80004fa2 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f7c:	f6841683          	lh	a3,-152(s0)
    80004f80:	f6c41603          	lh	a2,-148(s0)
    80004f84:	458d                	li	a1,3
    80004f86:	f7040513          	addi	a0,s0,-144
    80004f8a:	90fff0ef          	jal	80004898 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f8e:	c911                	beqz	a0,80004fa2 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f90:	c5cfe0ef          	jal	800033ec <iunlockput>
  end_op();
    80004f94:	b4ffe0ef          	jal	80003ae2 <end_op>
  return 0;
    80004f98:	4501                	li	a0,0
}
    80004f9a:	60ea                	ld	ra,152(sp)
    80004f9c:	644a                	ld	s0,144(sp)
    80004f9e:	610d                	addi	sp,sp,160
    80004fa0:	8082                	ret
    end_op();
    80004fa2:	b41fe0ef          	jal	80003ae2 <end_op>
    return -1;
    80004fa6:	557d                	li	a0,-1
    80004fa8:	bfcd                	j	80004f9a <sys_mknod+0x50>

0000000080004faa <sys_chdir>:

uint64
sys_chdir(void)
{
    80004faa:	7135                	addi	sp,sp,-160
    80004fac:	ed06                	sd	ra,152(sp)
    80004fae:	e922                	sd	s0,144(sp)
    80004fb0:	e14a                	sd	s2,128(sp)
    80004fb2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fb4:	937fc0ef          	jal	800018ea <myproc>
    80004fb8:	892a                	mv	s2,a0
  
  begin_op();
    80004fba:	abffe0ef          	jal	80003a78 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fbe:	08000613          	li	a2,128
    80004fc2:	f6040593          	addi	a1,s0,-160
    80004fc6:	4501                	li	a0,0
    80004fc8:	827fd0ef          	jal	800027ee <argstr>
    80004fcc:	04054363          	bltz	a0,80005012 <sys_chdir+0x68>
    80004fd0:	e526                	sd	s1,136(sp)
    80004fd2:	f6040513          	addi	a0,s0,-160
    80004fd6:	8e7fe0ef          	jal	800038bc <namei>
    80004fda:	84aa                	mv	s1,a0
    80004fdc:	c915                	beqz	a0,80005010 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fde:	a04fe0ef          	jal	800031e2 <ilock>
  if(ip->type != T_DIR){
    80004fe2:	04449703          	lh	a4,68(s1)
    80004fe6:	4785                	li	a5,1
    80004fe8:	02f71963          	bne	a4,a5,8000501a <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fec:	8526                	mv	a0,s1
    80004fee:	aa2fe0ef          	jal	80003290 <iunlock>
  iput(p->cwd);
    80004ff2:	15093503          	ld	a0,336(s2)
    80004ff6:	b6efe0ef          	jal	80003364 <iput>
  end_op();
    80004ffa:	ae9fe0ef          	jal	80003ae2 <end_op>
  p->cwd = ip;
    80004ffe:	14993823          	sd	s1,336(s2)
  return 0;
    80005002:	4501                	li	a0,0
    80005004:	64aa                	ld	s1,136(sp)
}
    80005006:	60ea                	ld	ra,152(sp)
    80005008:	644a                	ld	s0,144(sp)
    8000500a:	690a                	ld	s2,128(sp)
    8000500c:	610d                	addi	sp,sp,160
    8000500e:	8082                	ret
    80005010:	64aa                	ld	s1,136(sp)
    end_op();
    80005012:	ad1fe0ef          	jal	80003ae2 <end_op>
    return -1;
    80005016:	557d                	li	a0,-1
    80005018:	b7fd                	j	80005006 <sys_chdir+0x5c>
    iunlockput(ip);
    8000501a:	8526                	mv	a0,s1
    8000501c:	bd0fe0ef          	jal	800033ec <iunlockput>
    end_op();
    80005020:	ac3fe0ef          	jal	80003ae2 <end_op>
    return -1;
    80005024:	557d                	li	a0,-1
    80005026:	64aa                	ld	s1,136(sp)
    80005028:	bff9                	j	80005006 <sys_chdir+0x5c>

000000008000502a <sys_exec>:

uint64
sys_exec(void)
{
    8000502a:	7121                	addi	sp,sp,-448
    8000502c:	ff06                	sd	ra,440(sp)
    8000502e:	fb22                	sd	s0,432(sp)
    80005030:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005032:	e4840593          	addi	a1,s0,-440
    80005036:	4505                	li	a0,1
    80005038:	f9afd0ef          	jal	800027d2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000503c:	08000613          	li	a2,128
    80005040:	f5040593          	addi	a1,s0,-176
    80005044:	4501                	li	a0,0
    80005046:	fa8fd0ef          	jal	800027ee <argstr>
    8000504a:	87aa                	mv	a5,a0
    return -1;
    8000504c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000504e:	0c07c463          	bltz	a5,80005116 <sys_exec+0xec>
    80005052:	f726                	sd	s1,424(sp)
    80005054:	f34a                	sd	s2,416(sp)
    80005056:	ef4e                	sd	s3,408(sp)
    80005058:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000505a:	10000613          	li	a2,256
    8000505e:	4581                	li	a1,0
    80005060:	e5040513          	addi	a0,s0,-432
    80005064:	c65fb0ef          	jal	80000cc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005068:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000506c:	89a6                	mv	s3,s1
    8000506e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005070:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005074:	00391513          	slli	a0,s2,0x3
    80005078:	e4040593          	addi	a1,s0,-448
    8000507c:	e4843783          	ld	a5,-440(s0)
    80005080:	953e                	add	a0,a0,a5
    80005082:	eaafd0ef          	jal	8000272c <fetchaddr>
    80005086:	02054663          	bltz	a0,800050b2 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    8000508a:	e4043783          	ld	a5,-448(s0)
    8000508e:	c3a9                	beqz	a5,800050d0 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005090:	a95fb0ef          	jal	80000b24 <kalloc>
    80005094:	85aa                	mv	a1,a0
    80005096:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000509a:	cd01                	beqz	a0,800050b2 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000509c:	6605                	lui	a2,0x1
    8000509e:	e4043503          	ld	a0,-448(s0)
    800050a2:	ed4fd0ef          	jal	80002776 <fetchstr>
    800050a6:	00054663          	bltz	a0,800050b2 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800050aa:	0905                	addi	s2,s2,1
    800050ac:	09a1                	addi	s3,s3,8
    800050ae:	fd4913e3          	bne	s2,s4,80005074 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050b2:	f5040913          	addi	s2,s0,-176
    800050b6:	6088                	ld	a0,0(s1)
    800050b8:	c931                	beqz	a0,8000510c <sys_exec+0xe2>
    kfree(argv[i]);
    800050ba:	989fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050be:	04a1                	addi	s1,s1,8
    800050c0:	ff249be3          	bne	s1,s2,800050b6 <sys_exec+0x8c>
  return -1;
    800050c4:	557d                	li	a0,-1
    800050c6:	74ba                	ld	s1,424(sp)
    800050c8:	791a                	ld	s2,416(sp)
    800050ca:	69fa                	ld	s3,408(sp)
    800050cc:	6a5a                	ld	s4,400(sp)
    800050ce:	a0a1                	j	80005116 <sys_exec+0xec>
      argv[i] = 0;
    800050d0:	0009079b          	sext.w	a5,s2
    800050d4:	078e                	slli	a5,a5,0x3
    800050d6:	fd078793          	addi	a5,a5,-48
    800050da:	97a2                	add	a5,a5,s0
    800050dc:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800050e0:	e5040593          	addi	a1,s0,-432
    800050e4:	f5040513          	addi	a0,s0,-176
    800050e8:	ba8ff0ef          	jal	80004490 <exec>
    800050ec:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ee:	f5040993          	addi	s3,s0,-176
    800050f2:	6088                	ld	a0,0(s1)
    800050f4:	c511                	beqz	a0,80005100 <sys_exec+0xd6>
    kfree(argv[i]);
    800050f6:	94dfb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050fa:	04a1                	addi	s1,s1,8
    800050fc:	ff349be3          	bne	s1,s3,800050f2 <sys_exec+0xc8>
  return ret;
    80005100:	854a                	mv	a0,s2
    80005102:	74ba                	ld	s1,424(sp)
    80005104:	791a                	ld	s2,416(sp)
    80005106:	69fa                	ld	s3,408(sp)
    80005108:	6a5a                	ld	s4,400(sp)
    8000510a:	a031                	j	80005116 <sys_exec+0xec>
  return -1;
    8000510c:	557d                	li	a0,-1
    8000510e:	74ba                	ld	s1,424(sp)
    80005110:	791a                	ld	s2,416(sp)
    80005112:	69fa                	ld	s3,408(sp)
    80005114:	6a5a                	ld	s4,400(sp)
}
    80005116:	70fa                	ld	ra,440(sp)
    80005118:	745a                	ld	s0,432(sp)
    8000511a:	6139                	addi	sp,sp,448
    8000511c:	8082                	ret

000000008000511e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000511e:	7139                	addi	sp,sp,-64
    80005120:	fc06                	sd	ra,56(sp)
    80005122:	f822                	sd	s0,48(sp)
    80005124:	f426                	sd	s1,40(sp)
    80005126:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005128:	fc2fc0ef          	jal	800018ea <myproc>
    8000512c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000512e:	fd840593          	addi	a1,s0,-40
    80005132:	4501                	li	a0,0
    80005134:	e9efd0ef          	jal	800027d2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005138:	fc840593          	addi	a1,s0,-56
    8000513c:	fd040513          	addi	a0,s0,-48
    80005140:	85cff0ef          	jal	8000419c <pipealloc>
    return -1;
    80005144:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005146:	0a054463          	bltz	a0,800051ee <sys_pipe+0xd0>
  fd0 = -1;
    8000514a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000514e:	fd043503          	ld	a0,-48(s0)
    80005152:	f08ff0ef          	jal	8000485a <fdalloc>
    80005156:	fca42223          	sw	a0,-60(s0)
    8000515a:	08054163          	bltz	a0,800051dc <sys_pipe+0xbe>
    8000515e:	fc843503          	ld	a0,-56(s0)
    80005162:	ef8ff0ef          	jal	8000485a <fdalloc>
    80005166:	fca42023          	sw	a0,-64(s0)
    8000516a:	06054063          	bltz	a0,800051ca <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000516e:	4691                	li	a3,4
    80005170:	fc440613          	addi	a2,s0,-60
    80005174:	fd843583          	ld	a1,-40(s0)
    80005178:	68a8                	ld	a0,80(s1)
    8000517a:	bd8fc0ef          	jal	80001552 <copyout>
    8000517e:	00054e63          	bltz	a0,8000519a <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005182:	4691                	li	a3,4
    80005184:	fc040613          	addi	a2,s0,-64
    80005188:	fd843583          	ld	a1,-40(s0)
    8000518c:	0591                	addi	a1,a1,4
    8000518e:	68a8                	ld	a0,80(s1)
    80005190:	bc2fc0ef          	jal	80001552 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005194:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005196:	04055c63          	bgez	a0,800051ee <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000519a:	fc442783          	lw	a5,-60(s0)
    8000519e:	07e9                	addi	a5,a5,26
    800051a0:	078e                	slli	a5,a5,0x3
    800051a2:	97a6                	add	a5,a5,s1
    800051a4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800051a8:	fc042783          	lw	a5,-64(s0)
    800051ac:	07e9                	addi	a5,a5,26
    800051ae:	078e                	slli	a5,a5,0x3
    800051b0:	94be                	add	s1,s1,a5
    800051b2:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800051b6:	fd043503          	ld	a0,-48(s0)
    800051ba:	cd9fe0ef          	jal	80003e92 <fileclose>
    fileclose(wf);
    800051be:	fc843503          	ld	a0,-56(s0)
    800051c2:	cd1fe0ef          	jal	80003e92 <fileclose>
    return -1;
    800051c6:	57fd                	li	a5,-1
    800051c8:	a01d                	j	800051ee <sys_pipe+0xd0>
    if(fd0 >= 0)
    800051ca:	fc442783          	lw	a5,-60(s0)
    800051ce:	0007c763          	bltz	a5,800051dc <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800051d2:	07e9                	addi	a5,a5,26
    800051d4:	078e                	slli	a5,a5,0x3
    800051d6:	97a6                	add	a5,a5,s1
    800051d8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800051dc:	fd043503          	ld	a0,-48(s0)
    800051e0:	cb3fe0ef          	jal	80003e92 <fileclose>
    fileclose(wf);
    800051e4:	fc843503          	ld	a0,-56(s0)
    800051e8:	cabfe0ef          	jal	80003e92 <fileclose>
    return -1;
    800051ec:	57fd                	li	a5,-1
}
    800051ee:	853e                	mv	a0,a5
    800051f0:	70e2                	ld	ra,56(sp)
    800051f2:	7442                	ld	s0,48(sp)
    800051f4:	74a2                	ld	s1,40(sp)
    800051f6:	6121                	addi	sp,sp,64
    800051f8:	8082                	ret
    800051fa:	0000                	unimp
    800051fc:	0000                	unimp
	...

0000000080005200 <kernelvec>:
    80005200:	7111                	addi	sp,sp,-256
    80005202:	e006                	sd	ra,0(sp)
    80005204:	e40a                	sd	sp,8(sp)
    80005206:	e80e                	sd	gp,16(sp)
    80005208:	ec12                	sd	tp,24(sp)
    8000520a:	f016                	sd	t0,32(sp)
    8000520c:	f41a                	sd	t1,40(sp)
    8000520e:	f81e                	sd	t2,48(sp)
    80005210:	e4aa                	sd	a0,72(sp)
    80005212:	e8ae                	sd	a1,80(sp)
    80005214:	ecb2                	sd	a2,88(sp)
    80005216:	f0b6                	sd	a3,96(sp)
    80005218:	f4ba                	sd	a4,104(sp)
    8000521a:	f8be                	sd	a5,112(sp)
    8000521c:	fcc2                	sd	a6,120(sp)
    8000521e:	e146                	sd	a7,128(sp)
    80005220:	edf2                	sd	t3,216(sp)
    80005222:	f1f6                	sd	t4,224(sp)
    80005224:	f5fa                	sd	t5,232(sp)
    80005226:	f9fe                	sd	t6,240(sp)
    80005228:	c14fd0ef          	jal	8000263c <kerneltrap>
    8000522c:	6082                	ld	ra,0(sp)
    8000522e:	6122                	ld	sp,8(sp)
    80005230:	61c2                	ld	gp,16(sp)
    80005232:	7282                	ld	t0,32(sp)
    80005234:	7322                	ld	t1,40(sp)
    80005236:	73c2                	ld	t2,48(sp)
    80005238:	6526                	ld	a0,72(sp)
    8000523a:	65c6                	ld	a1,80(sp)
    8000523c:	6666                	ld	a2,88(sp)
    8000523e:	7686                	ld	a3,96(sp)
    80005240:	7726                	ld	a4,104(sp)
    80005242:	77c6                	ld	a5,112(sp)
    80005244:	7866                	ld	a6,120(sp)
    80005246:	688a                	ld	a7,128(sp)
    80005248:	6e6e                	ld	t3,216(sp)
    8000524a:	7e8e                	ld	t4,224(sp)
    8000524c:	7f2e                	ld	t5,232(sp)
    8000524e:	7fce                	ld	t6,240(sp)
    80005250:	6111                	addi	sp,sp,256
    80005252:	10200073          	sret
	...

000000008000525e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000525e:	1141                	addi	sp,sp,-16
    80005260:	e422                	sd	s0,8(sp)
    80005262:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005264:	0c0007b7          	lui	a5,0xc000
    80005268:	4705                	li	a4,1
    8000526a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000526c:	0c0007b7          	lui	a5,0xc000
    80005270:	c3d8                	sw	a4,4(a5)
}
    80005272:	6422                	ld	s0,8(sp)
    80005274:	0141                	addi	sp,sp,16
    80005276:	8082                	ret

0000000080005278 <plicinithart>:

void
plicinithart(void)
{
    80005278:	1141                	addi	sp,sp,-16
    8000527a:	e406                	sd	ra,8(sp)
    8000527c:	e022                	sd	s0,0(sp)
    8000527e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005280:	e3efc0ef          	jal	800018be <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005284:	0085171b          	slliw	a4,a0,0x8
    80005288:	0c0027b7          	lui	a5,0xc002
    8000528c:	97ba                	add	a5,a5,a4
    8000528e:	40200713          	li	a4,1026
    80005292:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005296:	00d5151b          	slliw	a0,a0,0xd
    8000529a:	0c2017b7          	lui	a5,0xc201
    8000529e:	97aa                	add	a5,a5,a0
    800052a0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800052a4:	60a2                	ld	ra,8(sp)
    800052a6:	6402                	ld	s0,0(sp)
    800052a8:	0141                	addi	sp,sp,16
    800052aa:	8082                	ret

00000000800052ac <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052ac:	1141                	addi	sp,sp,-16
    800052ae:	e406                	sd	ra,8(sp)
    800052b0:	e022                	sd	s0,0(sp)
    800052b2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052b4:	e0afc0ef          	jal	800018be <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052b8:	00d5151b          	slliw	a0,a0,0xd
    800052bc:	0c2017b7          	lui	a5,0xc201
    800052c0:	97aa                	add	a5,a5,a0
  return irq;
}
    800052c2:	43c8                	lw	a0,4(a5)
    800052c4:	60a2                	ld	ra,8(sp)
    800052c6:	6402                	ld	s0,0(sp)
    800052c8:	0141                	addi	sp,sp,16
    800052ca:	8082                	ret

00000000800052cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052cc:	1101                	addi	sp,sp,-32
    800052ce:	ec06                	sd	ra,24(sp)
    800052d0:	e822                	sd	s0,16(sp)
    800052d2:	e426                	sd	s1,8(sp)
    800052d4:	1000                	addi	s0,sp,32
    800052d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052d8:	de6fc0ef          	jal	800018be <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052dc:	00d5151b          	slliw	a0,a0,0xd
    800052e0:	0c2017b7          	lui	a5,0xc201
    800052e4:	97aa                	add	a5,a5,a0
    800052e6:	c3c4                	sw	s1,4(a5)
}
    800052e8:	60e2                	ld	ra,24(sp)
    800052ea:	6442                	ld	s0,16(sp)
    800052ec:	64a2                	ld	s1,8(sp)
    800052ee:	6105                	addi	sp,sp,32
    800052f0:	8082                	ret

00000000800052f2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052f2:	1141                	addi	sp,sp,-16
    800052f4:	e406                	sd	ra,8(sp)
    800052f6:	e022                	sd	s0,0(sp)
    800052f8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052fa:	479d                	li	a5,7
    800052fc:	04a7ca63          	blt	a5,a0,80005350 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005300:	0001c797          	auipc	a5,0x1c
    80005304:	c3078793          	addi	a5,a5,-976 # 80020f30 <disk>
    80005308:	97aa                	add	a5,a5,a0
    8000530a:	0187c783          	lbu	a5,24(a5)
    8000530e:	e7b9                	bnez	a5,8000535c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005310:	00451693          	slli	a3,a0,0x4
    80005314:	0001c797          	auipc	a5,0x1c
    80005318:	c1c78793          	addi	a5,a5,-996 # 80020f30 <disk>
    8000531c:	6398                	ld	a4,0(a5)
    8000531e:	9736                	add	a4,a4,a3
    80005320:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005324:	6398                	ld	a4,0(a5)
    80005326:	9736                	add	a4,a4,a3
    80005328:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000532c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005330:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005334:	97aa                	add	a5,a5,a0
    80005336:	4705                	li	a4,1
    80005338:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000533c:	0001c517          	auipc	a0,0x1c
    80005340:	c0c50513          	addi	a0,a0,-1012 # 80020f48 <disk+0x18>
    80005344:	bd9fc0ef          	jal	80001f1c <wakeup>
}
    80005348:	60a2                	ld	ra,8(sp)
    8000534a:	6402                	ld	s0,0(sp)
    8000534c:	0141                	addi	sp,sp,16
    8000534e:	8082                	ret
    panic("free_desc 1");
    80005350:	00002517          	auipc	a0,0x2
    80005354:	35050513          	addi	a0,a0,848 # 800076a0 <etext+0x6a0>
    80005358:	c3cfb0ef          	jal	80000794 <panic>
    panic("free_desc 2");
    8000535c:	00002517          	auipc	a0,0x2
    80005360:	35450513          	addi	a0,a0,852 # 800076b0 <etext+0x6b0>
    80005364:	c30fb0ef          	jal	80000794 <panic>

0000000080005368 <virtio_disk_init>:
{
    80005368:	1101                	addi	sp,sp,-32
    8000536a:	ec06                	sd	ra,24(sp)
    8000536c:	e822                	sd	s0,16(sp)
    8000536e:	e426                	sd	s1,8(sp)
    80005370:	e04a                	sd	s2,0(sp)
    80005372:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005374:	00002597          	auipc	a1,0x2
    80005378:	34c58593          	addi	a1,a1,844 # 800076c0 <etext+0x6c0>
    8000537c:	0001c517          	auipc	a0,0x1c
    80005380:	cdc50513          	addi	a0,a0,-804 # 80021058 <disk+0x128>
    80005384:	ff0fb0ef          	jal	80000b74 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005388:	100017b7          	lui	a5,0x10001
    8000538c:	4398                	lw	a4,0(a5)
    8000538e:	2701                	sext.w	a4,a4
    80005390:	747277b7          	lui	a5,0x74727
    80005394:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005398:	18f71063          	bne	a4,a5,80005518 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000539c:	100017b7          	lui	a5,0x10001
    800053a0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800053a2:	439c                	lw	a5,0(a5)
    800053a4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053a6:	4709                	li	a4,2
    800053a8:	16e79863          	bne	a5,a4,80005518 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053ac:	100017b7          	lui	a5,0x10001
    800053b0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800053b2:	439c                	lw	a5,0(a5)
    800053b4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800053b6:	16e79163          	bne	a5,a4,80005518 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053ba:	100017b7          	lui	a5,0x10001
    800053be:	47d8                	lw	a4,12(a5)
    800053c0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053c2:	554d47b7          	lui	a5,0x554d4
    800053c6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053ca:	14f71763          	bne	a4,a5,80005518 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ce:	100017b7          	lui	a5,0x10001
    800053d2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053d6:	4705                	li	a4,1
    800053d8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053da:	470d                	li	a4,3
    800053dc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053de:	10001737          	lui	a4,0x10001
    800053e2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053e4:	c7ffe737          	lui	a4,0xc7ffe
    800053e8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd6ef>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053ec:	8ef9                	and	a3,a3,a4
    800053ee:	10001737          	lui	a4,0x10001
    800053f2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053f4:	472d                	li	a4,11
    800053f6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053f8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800053fc:	439c                	lw	a5,0(a5)
    800053fe:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005402:	8ba1                	andi	a5,a5,8
    80005404:	12078063          	beqz	a5,80005524 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005408:	100017b7          	lui	a5,0x10001
    8000540c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005410:	100017b7          	lui	a5,0x10001
    80005414:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005418:	439c                	lw	a5,0(a5)
    8000541a:	2781                	sext.w	a5,a5
    8000541c:	10079a63          	bnez	a5,80005530 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005420:	100017b7          	lui	a5,0x10001
    80005424:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005428:	439c                	lw	a5,0(a5)
    8000542a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000542c:	10078863          	beqz	a5,8000553c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005430:	471d                	li	a4,7
    80005432:	10f77b63          	bgeu	a4,a5,80005548 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005436:	eeefb0ef          	jal	80000b24 <kalloc>
    8000543a:	0001c497          	auipc	s1,0x1c
    8000543e:	af648493          	addi	s1,s1,-1290 # 80020f30 <disk>
    80005442:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005444:	ee0fb0ef          	jal	80000b24 <kalloc>
    80005448:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000544a:	edafb0ef          	jal	80000b24 <kalloc>
    8000544e:	87aa                	mv	a5,a0
    80005450:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005452:	6088                	ld	a0,0(s1)
    80005454:	10050063          	beqz	a0,80005554 <virtio_disk_init+0x1ec>
    80005458:	0001c717          	auipc	a4,0x1c
    8000545c:	ae073703          	ld	a4,-1312(a4) # 80020f38 <disk+0x8>
    80005460:	0e070a63          	beqz	a4,80005554 <virtio_disk_init+0x1ec>
    80005464:	0e078863          	beqz	a5,80005554 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005468:	6605                	lui	a2,0x1
    8000546a:	4581                	li	a1,0
    8000546c:	85dfb0ef          	jal	80000cc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005470:	0001c497          	auipc	s1,0x1c
    80005474:	ac048493          	addi	s1,s1,-1344 # 80020f30 <disk>
    80005478:	6605                	lui	a2,0x1
    8000547a:	4581                	li	a1,0
    8000547c:	6488                	ld	a0,8(s1)
    8000547e:	84bfb0ef          	jal	80000cc8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005482:	6605                	lui	a2,0x1
    80005484:	4581                	li	a1,0
    80005486:	6888                	ld	a0,16(s1)
    80005488:	841fb0ef          	jal	80000cc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000548c:	100017b7          	lui	a5,0x10001
    80005490:	4721                	li	a4,8
    80005492:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005494:	4098                	lw	a4,0(s1)
    80005496:	100017b7          	lui	a5,0x10001
    8000549a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000549e:	40d8                	lw	a4,4(s1)
    800054a0:	100017b7          	lui	a5,0x10001
    800054a4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800054a8:	649c                	ld	a5,8(s1)
    800054aa:	0007869b          	sext.w	a3,a5
    800054ae:	10001737          	lui	a4,0x10001
    800054b2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800054b6:	9781                	srai	a5,a5,0x20
    800054b8:	10001737          	lui	a4,0x10001
    800054bc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800054c0:	689c                	ld	a5,16(s1)
    800054c2:	0007869b          	sext.w	a3,a5
    800054c6:	10001737          	lui	a4,0x10001
    800054ca:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800054ce:	9781                	srai	a5,a5,0x20
    800054d0:	10001737          	lui	a4,0x10001
    800054d4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800054d8:	10001737          	lui	a4,0x10001
    800054dc:	4785                	li	a5,1
    800054de:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800054e0:	00f48c23          	sb	a5,24(s1)
    800054e4:	00f48ca3          	sb	a5,25(s1)
    800054e8:	00f48d23          	sb	a5,26(s1)
    800054ec:	00f48da3          	sb	a5,27(s1)
    800054f0:	00f48e23          	sb	a5,28(s1)
    800054f4:	00f48ea3          	sb	a5,29(s1)
    800054f8:	00f48f23          	sb	a5,30(s1)
    800054fc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005500:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005504:	100017b7          	lui	a5,0x10001
    80005508:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000550c:	60e2                	ld	ra,24(sp)
    8000550e:	6442                	ld	s0,16(sp)
    80005510:	64a2                	ld	s1,8(sp)
    80005512:	6902                	ld	s2,0(sp)
    80005514:	6105                	addi	sp,sp,32
    80005516:	8082                	ret
    panic("could not find virtio disk");
    80005518:	00002517          	auipc	a0,0x2
    8000551c:	1b850513          	addi	a0,a0,440 # 800076d0 <etext+0x6d0>
    80005520:	a74fb0ef          	jal	80000794 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005524:	00002517          	auipc	a0,0x2
    80005528:	1cc50513          	addi	a0,a0,460 # 800076f0 <etext+0x6f0>
    8000552c:	a68fb0ef          	jal	80000794 <panic>
    panic("virtio disk should not be ready");
    80005530:	00002517          	auipc	a0,0x2
    80005534:	1e050513          	addi	a0,a0,480 # 80007710 <etext+0x710>
    80005538:	a5cfb0ef          	jal	80000794 <panic>
    panic("virtio disk has no queue 0");
    8000553c:	00002517          	auipc	a0,0x2
    80005540:	1f450513          	addi	a0,a0,500 # 80007730 <etext+0x730>
    80005544:	a50fb0ef          	jal	80000794 <panic>
    panic("virtio disk max queue too short");
    80005548:	00002517          	auipc	a0,0x2
    8000554c:	20850513          	addi	a0,a0,520 # 80007750 <etext+0x750>
    80005550:	a44fb0ef          	jal	80000794 <panic>
    panic("virtio disk kalloc");
    80005554:	00002517          	auipc	a0,0x2
    80005558:	21c50513          	addi	a0,a0,540 # 80007770 <etext+0x770>
    8000555c:	a38fb0ef          	jal	80000794 <panic>

0000000080005560 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005560:	7159                	addi	sp,sp,-112
    80005562:	f486                	sd	ra,104(sp)
    80005564:	f0a2                	sd	s0,96(sp)
    80005566:	eca6                	sd	s1,88(sp)
    80005568:	e8ca                	sd	s2,80(sp)
    8000556a:	e4ce                	sd	s3,72(sp)
    8000556c:	e0d2                	sd	s4,64(sp)
    8000556e:	fc56                	sd	s5,56(sp)
    80005570:	f85a                	sd	s6,48(sp)
    80005572:	f45e                	sd	s7,40(sp)
    80005574:	f062                	sd	s8,32(sp)
    80005576:	ec66                	sd	s9,24(sp)
    80005578:	1880                	addi	s0,sp,112
    8000557a:	8a2a                	mv	s4,a0
    8000557c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000557e:	00c52c83          	lw	s9,12(a0)
    80005582:	001c9c9b          	slliw	s9,s9,0x1
    80005586:	1c82                	slli	s9,s9,0x20
    80005588:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000558c:	0001c517          	auipc	a0,0x1c
    80005590:	acc50513          	addi	a0,a0,-1332 # 80021058 <disk+0x128>
    80005594:	e60fb0ef          	jal	80000bf4 <acquire>
  for(int i = 0; i < 3; i++){
    80005598:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000559a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000559c:	0001cb17          	auipc	s6,0x1c
    800055a0:	994b0b13          	addi	s6,s6,-1644 # 80020f30 <disk>
  for(int i = 0; i < 3; i++){
    800055a4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055a6:	0001cc17          	auipc	s8,0x1c
    800055aa:	ab2c0c13          	addi	s8,s8,-1358 # 80021058 <disk+0x128>
    800055ae:	a8b9                	j	8000560c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    800055b0:	00fb0733          	add	a4,s6,a5
    800055b4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800055b8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800055ba:	0207c563          	bltz	a5,800055e4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800055be:	2905                	addiw	s2,s2,1
    800055c0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800055c2:	05590963          	beq	s2,s5,80005614 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    800055c6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800055c8:	0001c717          	auipc	a4,0x1c
    800055cc:	96870713          	addi	a4,a4,-1688 # 80020f30 <disk>
    800055d0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800055d2:	01874683          	lbu	a3,24(a4)
    800055d6:	fee9                	bnez	a3,800055b0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    800055d8:	2785                	addiw	a5,a5,1
    800055da:	0705                	addi	a4,a4,1
    800055dc:	fe979be3          	bne	a5,s1,800055d2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800055e0:	57fd                	li	a5,-1
    800055e2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800055e4:	01205d63          	blez	s2,800055fe <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800055e8:	f9042503          	lw	a0,-112(s0)
    800055ec:	d07ff0ef          	jal	800052f2 <free_desc>
      for(int j = 0; j < i; j++)
    800055f0:	4785                	li	a5,1
    800055f2:	0127d663          	bge	a5,s2,800055fe <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800055f6:	f9442503          	lw	a0,-108(s0)
    800055fa:	cf9ff0ef          	jal	800052f2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055fe:	85e2                	mv	a1,s8
    80005600:	0001c517          	auipc	a0,0x1c
    80005604:	94850513          	addi	a0,a0,-1720 # 80020f48 <disk+0x18>
    80005608:	8c9fc0ef          	jal	80001ed0 <sleep>
  for(int i = 0; i < 3; i++){
    8000560c:	f9040613          	addi	a2,s0,-112
    80005610:	894e                	mv	s2,s3
    80005612:	bf55                	j	800055c6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005614:	f9042503          	lw	a0,-112(s0)
    80005618:	00451693          	slli	a3,a0,0x4

  if(write)
    8000561c:	0001c797          	auipc	a5,0x1c
    80005620:	91478793          	addi	a5,a5,-1772 # 80020f30 <disk>
    80005624:	00a50713          	addi	a4,a0,10
    80005628:	0712                	slli	a4,a4,0x4
    8000562a:	973e                	add	a4,a4,a5
    8000562c:	01703633          	snez	a2,s7
    80005630:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005632:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005636:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000563a:	6398                	ld	a4,0(a5)
    8000563c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000563e:	0a868613          	addi	a2,a3,168
    80005642:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005644:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005646:	6390                	ld	a2,0(a5)
    80005648:	00d605b3          	add	a1,a2,a3
    8000564c:	4741                	li	a4,16
    8000564e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005650:	4805                	li	a6,1
    80005652:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005656:	f9442703          	lw	a4,-108(s0)
    8000565a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000565e:	0712                	slli	a4,a4,0x4
    80005660:	963a                	add	a2,a2,a4
    80005662:	058a0593          	addi	a1,s4,88
    80005666:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005668:	0007b883          	ld	a7,0(a5)
    8000566c:	9746                	add	a4,a4,a7
    8000566e:	40000613          	li	a2,1024
    80005672:	c710                	sw	a2,8(a4)
  if(write)
    80005674:	001bb613          	seqz	a2,s7
    80005678:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000567c:	00166613          	ori	a2,a2,1
    80005680:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005684:	f9842583          	lw	a1,-104(s0)
    80005688:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000568c:	00250613          	addi	a2,a0,2
    80005690:	0612                	slli	a2,a2,0x4
    80005692:	963e                	add	a2,a2,a5
    80005694:	577d                	li	a4,-1
    80005696:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000569a:	0592                	slli	a1,a1,0x4
    8000569c:	98ae                	add	a7,a7,a1
    8000569e:	03068713          	addi	a4,a3,48
    800056a2:	973e                	add	a4,a4,a5
    800056a4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800056a8:	6398                	ld	a4,0(a5)
    800056aa:	972e                	add	a4,a4,a1
    800056ac:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056b0:	4689                	li	a3,2
    800056b2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800056b6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056ba:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    800056be:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056c2:	6794                	ld	a3,8(a5)
    800056c4:	0026d703          	lhu	a4,2(a3)
    800056c8:	8b1d                	andi	a4,a4,7
    800056ca:	0706                	slli	a4,a4,0x1
    800056cc:	96ba                	add	a3,a3,a4
    800056ce:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800056d2:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056d6:	6798                	ld	a4,8(a5)
    800056d8:	00275783          	lhu	a5,2(a4)
    800056dc:	2785                	addiw	a5,a5,1
    800056de:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056e2:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056e6:	100017b7          	lui	a5,0x10001
    800056ea:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056ee:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800056f2:	0001c917          	auipc	s2,0x1c
    800056f6:	96690913          	addi	s2,s2,-1690 # 80021058 <disk+0x128>
  while(b->disk == 1) {
    800056fa:	4485                	li	s1,1
    800056fc:	01079a63          	bne	a5,a6,80005710 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005700:	85ca                	mv	a1,s2
    80005702:	8552                	mv	a0,s4
    80005704:	fccfc0ef          	jal	80001ed0 <sleep>
  while(b->disk == 1) {
    80005708:	004a2783          	lw	a5,4(s4)
    8000570c:	fe978ae3          	beq	a5,s1,80005700 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005710:	f9042903          	lw	s2,-112(s0)
    80005714:	00290713          	addi	a4,s2,2
    80005718:	0712                	slli	a4,a4,0x4
    8000571a:	0001c797          	auipc	a5,0x1c
    8000571e:	81678793          	addi	a5,a5,-2026 # 80020f30 <disk>
    80005722:	97ba                	add	a5,a5,a4
    80005724:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005728:	0001c997          	auipc	s3,0x1c
    8000572c:	80898993          	addi	s3,s3,-2040 # 80020f30 <disk>
    80005730:	00491713          	slli	a4,s2,0x4
    80005734:	0009b783          	ld	a5,0(s3)
    80005738:	97ba                	add	a5,a5,a4
    8000573a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000573e:	854a                	mv	a0,s2
    80005740:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005744:	bafff0ef          	jal	800052f2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005748:	8885                	andi	s1,s1,1
    8000574a:	f0fd                	bnez	s1,80005730 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000574c:	0001c517          	auipc	a0,0x1c
    80005750:	90c50513          	addi	a0,a0,-1780 # 80021058 <disk+0x128>
    80005754:	d38fb0ef          	jal	80000c8c <release>
}
    80005758:	70a6                	ld	ra,104(sp)
    8000575a:	7406                	ld	s0,96(sp)
    8000575c:	64e6                	ld	s1,88(sp)
    8000575e:	6946                	ld	s2,80(sp)
    80005760:	69a6                	ld	s3,72(sp)
    80005762:	6a06                	ld	s4,64(sp)
    80005764:	7ae2                	ld	s5,56(sp)
    80005766:	7b42                	ld	s6,48(sp)
    80005768:	7ba2                	ld	s7,40(sp)
    8000576a:	7c02                	ld	s8,32(sp)
    8000576c:	6ce2                	ld	s9,24(sp)
    8000576e:	6165                	addi	sp,sp,112
    80005770:	8082                	ret

0000000080005772 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005772:	1101                	addi	sp,sp,-32
    80005774:	ec06                	sd	ra,24(sp)
    80005776:	e822                	sd	s0,16(sp)
    80005778:	e426                	sd	s1,8(sp)
    8000577a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000577c:	0001b497          	auipc	s1,0x1b
    80005780:	7b448493          	addi	s1,s1,1972 # 80020f30 <disk>
    80005784:	0001c517          	auipc	a0,0x1c
    80005788:	8d450513          	addi	a0,a0,-1836 # 80021058 <disk+0x128>
    8000578c:	c68fb0ef          	jal	80000bf4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005790:	100017b7          	lui	a5,0x10001
    80005794:	53b8                	lw	a4,96(a5)
    80005796:	8b0d                	andi	a4,a4,3
    80005798:	100017b7          	lui	a5,0x10001
    8000579c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    8000579e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057a2:	689c                	ld	a5,16(s1)
    800057a4:	0204d703          	lhu	a4,32(s1)
    800057a8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800057ac:	04f70663          	beq	a4,a5,800057f8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    800057b0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057b4:	6898                	ld	a4,16(s1)
    800057b6:	0204d783          	lhu	a5,32(s1)
    800057ba:	8b9d                	andi	a5,a5,7
    800057bc:	078e                	slli	a5,a5,0x3
    800057be:	97ba                	add	a5,a5,a4
    800057c0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057c2:	00278713          	addi	a4,a5,2
    800057c6:	0712                	slli	a4,a4,0x4
    800057c8:	9726                	add	a4,a4,s1
    800057ca:	01074703          	lbu	a4,16(a4)
    800057ce:	e321                	bnez	a4,8000580e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057d0:	0789                	addi	a5,a5,2
    800057d2:	0792                	slli	a5,a5,0x4
    800057d4:	97a6                	add	a5,a5,s1
    800057d6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800057d8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057dc:	f40fc0ef          	jal	80001f1c <wakeup>

    disk.used_idx += 1;
    800057e0:	0204d783          	lhu	a5,32(s1)
    800057e4:	2785                	addiw	a5,a5,1
    800057e6:	17c2                	slli	a5,a5,0x30
    800057e8:	93c1                	srli	a5,a5,0x30
    800057ea:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057ee:	6898                	ld	a4,16(s1)
    800057f0:	00275703          	lhu	a4,2(a4)
    800057f4:	faf71ee3          	bne	a4,a5,800057b0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800057f8:	0001c517          	auipc	a0,0x1c
    800057fc:	86050513          	addi	a0,a0,-1952 # 80021058 <disk+0x128>
    80005800:	c8cfb0ef          	jal	80000c8c <release>
}
    80005804:	60e2                	ld	ra,24(sp)
    80005806:	6442                	ld	s0,16(sp)
    80005808:	64a2                	ld	s1,8(sp)
    8000580a:	6105                	addi	sp,sp,32
    8000580c:	8082                	ret
      panic("virtio_disk_intr status");
    8000580e:	00002517          	auipc	a0,0x2
    80005812:	f7a50513          	addi	a0,a0,-134 # 80007788 <etext+0x788>
    80005816:	f7ffa0ef          	jal	80000794 <panic>
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
