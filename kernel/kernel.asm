
kernel/kernel:     formato del fichero elf64-littleriscv


Desensamblado de la sección .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	91010113          	addi	sp,sp,-1776 # 80009910 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	05e000ef          	jal	80000074 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	ff010113          	addi	sp,sp,-16
    80000020:	00813423          	sd	s0,8(sp)
    80000024:	01010413          	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000028:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    8000002c:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    80000030:	30479073          	csrw	mie,a5
// Machine Environment Configuration Register
static inline uint64
r_menvcfg()
{
  uint64 x;
  asm volatile("csrr %0, menvcfg" : "=r" (x) );
    80000034:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000038:	fff00713          	li	a4,-1
    8000003c:	03f71713          	slli	a4,a4,0x3f
    80000040:	00e7e7b3          	or	a5,a5,a4
}

static inline void 
w_menvcfg(uint64 x)
{
  asm volatile("csrw menvcfg, %0" : : "r" (x));
    80000044:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80000048:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    8000004c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000050:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000054:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80000058:	000f4737          	lui	a4,0xf4
    8000005c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000060:	00e787b3          	add	a5,a5,a4
  asm volatile("csrw stimecmp, %0" : : "r" (x));
    80000064:	14d79073          	csrw	stimecmp,a5
}
    80000068:	00813403          	ld	s0,8(sp)
    8000006c:	01010113          	addi	sp,sp,16
    80000070:	00008067          	ret

0000000080000074 <start>:
{
    80000074:	ff010113          	addi	sp,sp,-16
    80000078:	00113423          	sd	ra,8(sp)
    8000007c:	00813023          	sd	s0,0(sp)
    80000080:	01010413          	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000084:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000088:	ffffe737          	lui	a4,0xffffe
    8000008c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdbbbf>
    80000090:	00e7f7b3          	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000094:	00001737          	lui	a4,0x1
    80000098:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000009c:	00e7e7b3          	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a0:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a4:	00001797          	auipc	a5,0x1
    800000a8:	35878793          	addi	a5,a5,856 # 800013fc <main>
    800000ac:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b0:	00000793          	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b8:	000107b7          	lui	a5,0x10
    800000bc:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c0:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c4:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000c8:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000cc:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d0:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d4:	fff00793          	li	a5,-1
    800000d8:	00a7d793          	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000e0:	00f00793          	li	a5,15
    800000e4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e8:	f35ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	0007879b          	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f4:	00078213          	mv	tp,a5
  asm volatile("mret");
    800000f8:	30200073          	mret
}
    800000fc:	00813083          	ld	ra,8(sp)
    80000100:	00013403          	ld	s0,0(sp)
    80000104:	01010113          	addi	sp,sp,16
    80000108:	00008067          	ret

000000008000010c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000010c:	fb010113          	addi	sp,sp,-80
    80000110:	04113423          	sd	ra,72(sp)
    80000114:	04813023          	sd	s0,64(sp)
    80000118:	03213823          	sd	s2,48(sp)
    8000011c:	05010413          	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000120:	06c05663          	blez	a2,8000018c <consolewrite+0x80>
    80000124:	02913c23          	sd	s1,56(sp)
    80000128:	03313423          	sd	s3,40(sp)
    8000012c:	03413023          	sd	s4,32(sp)
    80000130:	01513c23          	sd	s5,24(sp)
    80000134:	00050a13          	mv	s4,a0
    80000138:	00058493          	mv	s1,a1
    8000013c:	00060993          	mv	s3,a2
    80000140:	00000913          	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000144:	fff00a93          	li	s5,-1
    80000148:	00100693          	li	a3,1
    8000014c:	00048613          	mv	a2,s1
    80000150:	000a0593          	mv	a1,s4
    80000154:	fbf40513          	addi	a0,s0,-65
    80000158:	0f0030ef          	jal	80003248 <either_copyin>
    8000015c:	03550c63          	beq	a0,s5,80000194 <consolewrite+0x88>
      break;
    uartputc(c);
    80000160:	fbf44503          	lbu	a0,-65(s0)
    80000164:	2dd000ef          	jal	80000c40 <uartputc>
  for(i = 0; i < n; i++){
    80000168:	0019091b          	addiw	s2,s2,1
    8000016c:	00148493          	addi	s1,s1,1
    80000170:	fd299ce3          	bne	s3,s2,80000148 <consolewrite+0x3c>
    80000174:	00098913          	mv	s2,s3
    80000178:	03813483          	ld	s1,56(sp)
    8000017c:	02813983          	ld	s3,40(sp)
    80000180:	02013a03          	ld	s4,32(sp)
    80000184:	01813a83          	ld	s5,24(sp)
    80000188:	01c0006f          	j	800001a4 <consolewrite+0x98>
    8000018c:	00000913          	li	s2,0
    80000190:	0140006f          	j	800001a4 <consolewrite+0x98>
    80000194:	03813483          	ld	s1,56(sp)
    80000198:	02813983          	ld	s3,40(sp)
    8000019c:	02013a03          	ld	s4,32(sp)
    800001a0:	01813a83          	ld	s5,24(sp)
  }

  return i;
}
    800001a4:	00090513          	mv	a0,s2
    800001a8:	04813083          	ld	ra,72(sp)
    800001ac:	04013403          	ld	s0,64(sp)
    800001b0:	03013903          	ld	s2,48(sp)
    800001b4:	05010113          	addi	sp,sp,80
    800001b8:	00008067          	ret

00000000800001bc <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800001bc:	fa010113          	addi	sp,sp,-96
    800001c0:	04113c23          	sd	ra,88(sp)
    800001c4:	04813823          	sd	s0,80(sp)
    800001c8:	04913423          	sd	s1,72(sp)
    800001cc:	05213023          	sd	s2,64(sp)
    800001d0:	03313c23          	sd	s3,56(sp)
    800001d4:	03413823          	sd	s4,48(sp)
    800001d8:	03513423          	sd	s5,40(sp)
    800001dc:	03613023          	sd	s6,32(sp)
    800001e0:	06010413          	addi	s0,sp,96
    800001e4:	00050a93          	mv	s5,a0
    800001e8:	00058a13          	mv	s4,a1
    800001ec:	00060993          	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800001f0:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800001f4:	00011517          	auipc	a0,0x11
    800001f8:	71c50513          	addi	a0,a0,1820 # 80011910 <cons>
    800001fc:	64d000ef          	jal	80001048 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000200:	00011497          	auipc	s1,0x11
    80000204:	71048493          	addi	s1,s1,1808 # 80011910 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000208:	00011917          	auipc	s2,0x11
    8000020c:	7a090913          	addi	s2,s2,1952 # 800119a8 <cons+0x98>
  while(n > 0){
    80000210:	0f305e63          	blez	s3,8000030c <consoleread+0x150>
    while(cons.r == cons.w){
    80000214:	0984a783          	lw	a5,152(s1)
    80000218:	09c4a703          	lw	a4,156(s1)
    8000021c:	0cf71e63          	bne	a4,a5,800002f8 <consoleread+0x13c>
      if(killed(myproc())){
    80000220:	23c020ef          	jal	8000245c <myproc>
    80000224:	5f5020ef          	jal	80003018 <killed>
    80000228:	08051063          	bnez	a0,800002a8 <consoleread+0xec>
      sleep(&cons.r, &cons.lock);
    8000022c:	00048593          	mv	a1,s1
    80000230:	00090513          	mv	a0,s2
    80000234:	2a5020ef          	jal	80002cd8 <sleep>
    while(cons.r == cons.w){
    80000238:	0984a783          	lw	a5,152(s1)
    8000023c:	09c4a703          	lw	a4,156(s1)
    80000240:	fef700e3          	beq	a4,a5,80000220 <consoleread+0x64>
    80000244:	01713c23          	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80000248:	00011717          	auipc	a4,0x11
    8000024c:	6c870713          	addi	a4,a4,1736 # 80011910 <cons>
    80000250:	0017869b          	addiw	a3,a5,1
    80000254:	08d72c23          	sw	a3,152(a4)
    80000258:	07f7f693          	andi	a3,a5,127
    8000025c:	00d70733          	add	a4,a4,a3
    80000260:	01874703          	lbu	a4,24(a4)
    80000264:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80000268:	00400693          	li	a3,4
    8000026c:	06db8a63          	beq	s7,a3,800002e0 <consoleread+0x124>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000270:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000274:	00100693          	li	a3,1
    80000278:	faf40613          	addi	a2,s0,-81
    8000027c:	000a0593          	mv	a1,s4
    80000280:	000a8513          	mv	a0,s5
    80000284:	741020ef          	jal	800031c4 <either_copyout>
    80000288:	fff00793          	li	a5,-1
    8000028c:	06f50e63          	beq	a0,a5,80000308 <consoleread+0x14c>
      break;

    dst++;
    80000290:	001a0a13          	addi	s4,s4,1
    --n;
    80000294:	fff9899b          	addiw	s3,s3,-1

    if(c == '\n'){
    80000298:	00a00793          	li	a5,10
    8000029c:	08fb8263          	beq	s7,a5,80000320 <consoleread+0x164>
    800002a0:	01813b83          	ld	s7,24(sp)
    800002a4:	f6dff06f          	j	80000210 <consoleread+0x54>
        release(&cons.lock);
    800002a8:	00011517          	auipc	a0,0x11
    800002ac:	66850513          	addi	a0,a0,1640 # 80011910 <cons>
    800002b0:	675000ef          	jal	80001124 <release>
        return -1;
    800002b4:	fff00513          	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800002b8:	05813083          	ld	ra,88(sp)
    800002bc:	05013403          	ld	s0,80(sp)
    800002c0:	04813483          	ld	s1,72(sp)
    800002c4:	04013903          	ld	s2,64(sp)
    800002c8:	03813983          	ld	s3,56(sp)
    800002cc:	03013a03          	ld	s4,48(sp)
    800002d0:	02813a83          	ld	s5,40(sp)
    800002d4:	02013b03          	ld	s6,32(sp)
    800002d8:	06010113          	addi	sp,sp,96
    800002dc:	00008067          	ret
      if(n < target){
    800002e0:	0009871b          	sext.w	a4,s3
    800002e4:	01677e63          	bgeu	a4,s6,80000300 <consoleread+0x144>
        cons.r--;
    800002e8:	00011717          	auipc	a4,0x11
    800002ec:	6cf72023          	sw	a5,1728(a4) # 800119a8 <cons+0x98>
    800002f0:	01813b83          	ld	s7,24(sp)
    800002f4:	0180006f          	j	8000030c <consoleread+0x150>
    800002f8:	01713c23          	sd	s7,24(sp)
    800002fc:	f4dff06f          	j	80000248 <consoleread+0x8c>
    80000300:	01813b83          	ld	s7,24(sp)
    80000304:	0080006f          	j	8000030c <consoleread+0x150>
    80000308:	01813b83          	ld	s7,24(sp)
  release(&cons.lock);
    8000030c:	00011517          	auipc	a0,0x11
    80000310:	60450513          	addi	a0,a0,1540 # 80011910 <cons>
    80000314:	611000ef          	jal	80001124 <release>
  return target - n;
    80000318:	413b053b          	subw	a0,s6,s3
    8000031c:	f9dff06f          	j	800002b8 <consoleread+0xfc>
    80000320:	01813b83          	ld	s7,24(sp)
    80000324:	fe9ff06f          	j	8000030c <consoleread+0x150>

0000000080000328 <consputc>:
{
    80000328:	ff010113          	addi	sp,sp,-16
    8000032c:	00113423          	sd	ra,8(sp)
    80000330:	00813023          	sd	s0,0(sp)
    80000334:	01010413          	addi	s0,sp,16
  if(c == BACKSPACE){
    80000338:	10000793          	li	a5,256
    8000033c:	00f50c63          	beq	a0,a5,80000354 <consputc+0x2c>
    uartputc_sync(c);
    80000340:	7c0000ef          	jal	80000b00 <uartputc_sync>
}
    80000344:	00813083          	ld	ra,8(sp)
    80000348:	00013403          	ld	s0,0(sp)
    8000034c:	01010113          	addi	sp,sp,16
    80000350:	00008067          	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000354:	00800513          	li	a0,8
    80000358:	7a8000ef          	jal	80000b00 <uartputc_sync>
    8000035c:	02000513          	li	a0,32
    80000360:	7a0000ef          	jal	80000b00 <uartputc_sync>
    80000364:	00800513          	li	a0,8
    80000368:	798000ef          	jal	80000b00 <uartputc_sync>
    8000036c:	fd9ff06f          	j	80000344 <consputc+0x1c>

0000000080000370 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000370:	fe010113          	addi	sp,sp,-32
    80000374:	00113c23          	sd	ra,24(sp)
    80000378:	00813823          	sd	s0,16(sp)
    8000037c:	00913423          	sd	s1,8(sp)
    80000380:	02010413          	addi	s0,sp,32
    80000384:	00050493          	mv	s1,a0
  acquire(&cons.lock);
    80000388:	00011517          	auipc	a0,0x11
    8000038c:	58850513          	addi	a0,a0,1416 # 80011910 <cons>
    80000390:	4b9000ef          	jal	80001048 <acquire>

  switch(c){
    80000394:	01500793          	li	a5,21
    80000398:	0af48e63          	beq	s1,a5,80000454 <consoleintr+0xe4>
    8000039c:	0297cc63          	blt	a5,s1,800003d4 <consoleintr+0x64>
    800003a0:	00800793          	li	a5,8
    800003a4:	10f48c63          	beq	s1,a5,800004bc <consoleintr+0x14c>
    800003a8:	01000793          	li	a5,16
    800003ac:	12f49e63          	bne	s1,a5,800004e8 <consoleintr+0x178>
  case C('P'):  // Print process list.
    procdump();
    800003b0:	71d020ef          	jal	800032cc <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800003b4:	00011517          	auipc	a0,0x11
    800003b8:	55c50513          	addi	a0,a0,1372 # 80011910 <cons>
    800003bc:	569000ef          	jal	80001124 <release>
}
    800003c0:	01813083          	ld	ra,24(sp)
    800003c4:	01013403          	ld	s0,16(sp)
    800003c8:	00813483          	ld	s1,8(sp)
    800003cc:	02010113          	addi	sp,sp,32
    800003d0:	00008067          	ret
  switch(c){
    800003d4:	07f00793          	li	a5,127
    800003d8:	0ef48263          	beq	s1,a5,800004bc <consoleintr+0x14c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003dc:	00011717          	auipc	a4,0x11
    800003e0:	53470713          	addi	a4,a4,1332 # 80011910 <cons>
    800003e4:	0a072783          	lw	a5,160(a4)
    800003e8:	09872703          	lw	a4,152(a4)
    800003ec:	40e787bb          	subw	a5,a5,a4
    800003f0:	07f00713          	li	a4,127
    800003f4:	fcf760e3          	bltu	a4,a5,800003b4 <consoleintr+0x44>
      c = (c == '\r') ? '\n' : c;
    800003f8:	00d00793          	li	a5,13
    800003fc:	0ef48a63          	beq	s1,a5,800004f0 <consoleintr+0x180>
      consputc(c);
    80000400:	00048513          	mv	a0,s1
    80000404:	f25ff0ef          	jal	80000328 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000408:	00011797          	auipc	a5,0x11
    8000040c:	50878793          	addi	a5,a5,1288 # 80011910 <cons>
    80000410:	0a07a683          	lw	a3,160(a5)
    80000414:	0016871b          	addiw	a4,a3,1
    80000418:	0007061b          	sext.w	a2,a4
    8000041c:	0ae7a023          	sw	a4,160(a5)
    80000420:	07f6f693          	andi	a3,a3,127
    80000424:	00d787b3          	add	a5,a5,a3
    80000428:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000042c:	00a00793          	li	a5,10
    80000430:	0ef48863          	beq	s1,a5,80000520 <consoleintr+0x1b0>
    80000434:	00400793          	li	a5,4
    80000438:	0ef48463          	beq	s1,a5,80000520 <consoleintr+0x1b0>
    8000043c:	00011797          	auipc	a5,0x11
    80000440:	56c7a783          	lw	a5,1388(a5) # 800119a8 <cons+0x98>
    80000444:	40f7073b          	subw	a4,a4,a5
    80000448:	08000793          	li	a5,128
    8000044c:	f6f714e3          	bne	a4,a5,800003b4 <consoleintr+0x44>
    80000450:	0d00006f          	j	80000520 <consoleintr+0x1b0>
    80000454:	01213023          	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000458:	00011717          	auipc	a4,0x11
    8000045c:	4b870713          	addi	a4,a4,1208 # 80011910 <cons>
    80000460:	0a072783          	lw	a5,160(a4)
    80000464:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000468:	00011497          	auipc	s1,0x11
    8000046c:	4a848493          	addi	s1,s1,1192 # 80011910 <cons>
    while(cons.e != cons.w &&
    80000470:	00a00913          	li	s2,10
    80000474:	02f70c63          	beq	a4,a5,800004ac <consoleintr+0x13c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000478:	fff7879b          	addiw	a5,a5,-1
    8000047c:	07f7f713          	andi	a4,a5,127
    80000480:	00e48733          	add	a4,s1,a4
    while(cons.e != cons.w &&
    80000484:	01874703          	lbu	a4,24(a4)
    80000488:	03270663          	beq	a4,s2,800004b4 <consoleintr+0x144>
      cons.e--;
    8000048c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000490:	10000513          	li	a0,256
    80000494:	e95ff0ef          	jal	80000328 <consputc>
    while(cons.e != cons.w &&
    80000498:	0a04a783          	lw	a5,160(s1)
    8000049c:	09c4a703          	lw	a4,156(s1)
    800004a0:	fcf71ce3          	bne	a4,a5,80000478 <consoleintr+0x108>
    800004a4:	00013903          	ld	s2,0(sp)
    800004a8:	f0dff06f          	j	800003b4 <consoleintr+0x44>
    800004ac:	00013903          	ld	s2,0(sp)
    800004b0:	f05ff06f          	j	800003b4 <consoleintr+0x44>
    800004b4:	00013903          	ld	s2,0(sp)
    800004b8:	efdff06f          	j	800003b4 <consoleintr+0x44>
    if(cons.e != cons.w){
    800004bc:	00011717          	auipc	a4,0x11
    800004c0:	45470713          	addi	a4,a4,1108 # 80011910 <cons>
    800004c4:	0a072783          	lw	a5,160(a4)
    800004c8:	09c72703          	lw	a4,156(a4)
    800004cc:	eef704e3          	beq	a4,a5,800003b4 <consoleintr+0x44>
      cons.e--;
    800004d0:	fff7879b          	addiw	a5,a5,-1
    800004d4:	00011717          	auipc	a4,0x11
    800004d8:	4cf72e23          	sw	a5,1244(a4) # 800119b0 <cons+0xa0>
      consputc(BACKSPACE);
    800004dc:	10000513          	li	a0,256
    800004e0:	e49ff0ef          	jal	80000328 <consputc>
    800004e4:	ed1ff06f          	j	800003b4 <consoleintr+0x44>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800004e8:	ec0486e3          	beqz	s1,800003b4 <consoleintr+0x44>
    800004ec:	ef1ff06f          	j	800003dc <consoleintr+0x6c>
      consputc(c);
    800004f0:	00a00513          	li	a0,10
    800004f4:	e35ff0ef          	jal	80000328 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800004f8:	00011797          	auipc	a5,0x11
    800004fc:	41878793          	addi	a5,a5,1048 # 80011910 <cons>
    80000500:	0a07a703          	lw	a4,160(a5)
    80000504:	0017069b          	addiw	a3,a4,1
    80000508:	0006861b          	sext.w	a2,a3
    8000050c:	0ad7a023          	sw	a3,160(a5)
    80000510:	07f77713          	andi	a4,a4,127
    80000514:	00e787b3          	add	a5,a5,a4
    80000518:	00a00713          	li	a4,10
    8000051c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000520:	00011797          	auipc	a5,0x11
    80000524:	48c7a623          	sw	a2,1164(a5) # 800119ac <cons+0x9c>
        wakeup(&cons.r);
    80000528:	00011517          	auipc	a0,0x11
    8000052c:	48050513          	addi	a0,a0,1152 # 800119a8 <cons+0x98>
    80000530:	021020ef          	jal	80002d50 <wakeup>
    80000534:	e81ff06f          	j	800003b4 <consoleintr+0x44>

0000000080000538 <consoleinit>:

void
consoleinit(void)
{
    80000538:	ff010113          	addi	sp,sp,-16
    8000053c:	00113423          	sd	ra,8(sp)
    80000540:	00813023          	sd	s0,0(sp)
    80000544:	01010413          	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000548:	00009597          	auipc	a1,0x9
    8000054c:	ab858593          	addi	a1,a1,-1352 # 80009000 <etext>
    80000550:	00011517          	auipc	a0,0x11
    80000554:	3c050513          	addi	a0,a0,960 # 80011910 <cons>
    80000558:	21d000ef          	jal	80000f74 <initlock>

  uartinit();
    8000055c:	538000ef          	jal	80000a94 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000560:	00021797          	auipc	a5,0x21
    80000564:	54878793          	addi	a5,a5,1352 # 80021aa8 <devsw>
    80000568:	00000717          	auipc	a4,0x0
    8000056c:	c5470713          	addi	a4,a4,-940 # 800001bc <consoleread>
    80000570:	00e7b823          	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000574:	00000717          	auipc	a4,0x0
    80000578:	b9870713          	addi	a4,a4,-1128 # 8000010c <consolewrite>
    8000057c:	00e7bc23          	sd	a4,24(a5)
}
    80000580:	00813083          	ld	ra,8(sp)
    80000584:	00013403          	ld	s0,0(sp)
    80000588:	01010113          	addi	sp,sp,16
    8000058c:	00008067          	ret

0000000080000590 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000590:	fd010113          	addi	sp,sp,-48
    80000594:	02113423          	sd	ra,40(sp)
    80000598:	02813023          	sd	s0,32(sp)
    8000059c:	03010413          	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800005a0:	00060463          	beqz	a2,800005a8 <printint+0x18>
    800005a4:	0a054663          	bltz	a0,80000650 <printint+0xc0>
    x = -xx;
  else
    x = xx;
    800005a8:	00000893          	li	a7,0
    800005ac:	fd040693          	addi	a3,s0,-48

  i = 0;
    800005b0:	00000793          	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800005b4:	00009617          	auipc	a2,0x9
    800005b8:	1bc60613          	addi	a2,a2,444 # 80009770 <digits>
    800005bc:	00078813          	mv	a6,a5
    800005c0:	0017879b          	addiw	a5,a5,1
    800005c4:	02b57733          	remu	a4,a0,a1
    800005c8:	00e60733          	add	a4,a2,a4
    800005cc:	00074703          	lbu	a4,0(a4)
    800005d0:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800005d4:	00050713          	mv	a4,a0
    800005d8:	02b55533          	divu	a0,a0,a1
    800005dc:	00168693          	addi	a3,a3,1
    800005e0:	fcb77ee3          	bgeu	a4,a1,800005bc <printint+0x2c>

  if(sign)
    800005e4:	00088c63          	beqz	a7,800005fc <printint+0x6c>
    buf[i++] = '-';
    800005e8:	fe078793          	addi	a5,a5,-32
    800005ec:	008787b3          	add	a5,a5,s0
    800005f0:	02d00713          	li	a4,45
    800005f4:	fee78823          	sb	a4,-16(a5)
    800005f8:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800005fc:	04f05263          	blez	a5,80000640 <printint+0xb0>
    80000600:	00913c23          	sd	s1,24(sp)
    80000604:	01213823          	sd	s2,16(sp)
    80000608:	fd040713          	addi	a4,s0,-48
    8000060c:	00f704b3          	add	s1,a4,a5
    80000610:	fff70913          	addi	s2,a4,-1
    80000614:	00f90933          	add	s2,s2,a5
    80000618:	fff7879b          	addiw	a5,a5,-1
    8000061c:	02079793          	slli	a5,a5,0x20
    80000620:	0207d793          	srli	a5,a5,0x20
    80000624:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    80000628:	fff4c503          	lbu	a0,-1(s1)
    8000062c:	cfdff0ef          	jal	80000328 <consputc>
  while(--i >= 0)
    80000630:	fff48493          	addi	s1,s1,-1
    80000634:	ff249ae3          	bne	s1,s2,80000628 <printint+0x98>
    80000638:	01813483          	ld	s1,24(sp)
    8000063c:	01013903          	ld	s2,16(sp)
}
    80000640:	02813083          	ld	ra,40(sp)
    80000644:	02013403          	ld	s0,32(sp)
    80000648:	03010113          	addi	sp,sp,48
    8000064c:	00008067          	ret
    x = -xx;
    80000650:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80000654:	00100893          	li	a7,1
    x = -xx;
    80000658:	f55ff06f          	j	800005ac <printint+0x1c>

000000008000065c <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    8000065c:	f3010113          	addi	sp,sp,-208
    80000660:	08113423          	sd	ra,136(sp)
    80000664:	08813023          	sd	s0,128(sp)
    80000668:	07413023          	sd	s4,96(sp)
    8000066c:	09010413          	addi	s0,sp,144
    80000670:	00050a13          	mv	s4,a0
    80000674:	00b43423          	sd	a1,8(s0)
    80000678:	00c43823          	sd	a2,16(s0)
    8000067c:	00d43c23          	sd	a3,24(s0)
    80000680:	02e43023          	sd	a4,32(s0)
    80000684:	02f43423          	sd	a5,40(s0)
    80000688:	03043823          	sd	a6,48(s0)
    8000068c:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80000690:	00011797          	auipc	a5,0x11
    80000694:	3407a783          	lw	a5,832(a5) # 800119d0 <pr+0x18>
    80000698:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000069c:	04079c63          	bnez	a5,800006f4 <printf+0x98>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800006a0:	00840793          	addi	a5,s0,8
    800006a4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800006a8:	00054503          	lbu	a0,0(a0)
    800006ac:	30050463          	beqz	a0,800009b4 <printf+0x358>
    800006b0:	06913c23          	sd	s1,120(sp)
    800006b4:	07213823          	sd	s2,112(sp)
    800006b8:	07313423          	sd	s3,104(sp)
    800006bc:	05513c23          	sd	s5,88(sp)
    800006c0:	05613823          	sd	s6,80(sp)
    800006c4:	05813023          	sd	s8,64(sp)
    800006c8:	03913c23          	sd	s9,56(sp)
    800006cc:	03a13823          	sd	s10,48(sp)
    800006d0:	03b13423          	sd	s11,40(sp)
    800006d4:	00000993          	li	s3,0
    if(cx != '%'){
    800006d8:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800006dc:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800006e0:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800006e4:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800006e8:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800006ec:	07000d93          	li	s11,112
    800006f0:	03c0006f          	j	8000072c <printf+0xd0>
    acquire(&pr.lock);
    800006f4:	00011517          	auipc	a0,0x11
    800006f8:	2c450513          	addi	a0,a0,708 # 800119b8 <pr>
    800006fc:	14d000ef          	jal	80001048 <acquire>
  va_start(ap, fmt);
    80000700:	00840793          	addi	a5,s0,8
    80000704:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000708:	000a4503          	lbu	a0,0(s4)
    8000070c:	fa0512e3          	bnez	a0,800006b0 <printf+0x54>
    80000710:	2e00006f          	j	800009f0 <printf+0x394>
      consputc(cx);
    80000714:	c15ff0ef          	jal	80000328 <consputc>
      continue;
    80000718:	00098493          	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000071c:	0014899b          	addiw	s3,s1,1
    80000720:	013a07b3          	add	a5,s4,s3
    80000724:	0007c503          	lbu	a0,0(a5)
    80000728:	26050063          	beqz	a0,80000988 <printf+0x32c>
    if(cx != '%'){
    8000072c:	ff5514e3          	bne	a0,s5,80000714 <printf+0xb8>
    i++;
    80000730:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000734:	009a07b3          	add	a5,s4,s1
    80000738:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000073c:	24090663          	beqz	s2,80000988 <printf+0x32c>
    80000740:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000744:	00078693          	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000748:	00078663          	beqz	a5,80000754 <printf+0xf8>
    8000074c:	009a0733          	add	a4,s4,s1
    80000750:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000754:	03690a63          	beq	s2,s6,80000788 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'd'){
    80000758:	05890863          	beq	s2,s8,800007a8 <printf+0x14c>
    } else if(c0 == 'u'){
    8000075c:	11990263          	beq	s2,s9,80000860 <printf+0x204>
    } else if(c0 == 'x'){
    80000760:	17a90463          	beq	s2,s10,800008c8 <printf+0x26c>
    } else if(c0 == 'p'){
    80000764:	19b90263          	beq	s2,s11,800008e8 <printf+0x28c>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80000768:	07300793          	li	a5,115
    8000076c:	1cf90863          	beq	s2,a5,8000093c <printf+0x2e0>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80000770:	21590663          	beq	s2,s5,8000097c <printf+0x320>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80000774:	000a8513          	mv	a0,s5
    80000778:	bb1ff0ef          	jal	80000328 <consputc>
      consputc(c0);
    8000077c:	00090513          	mv	a0,s2
    80000780:	ba9ff0ef          	jal	80000328 <consputc>
    80000784:	f99ff06f          	j	8000071c <printf+0xc0>
      printint(va_arg(ap, int), 10, 1);
    80000788:	f8843783          	ld	a5,-120(s0)
    8000078c:	00878713          	addi	a4,a5,8
    80000790:	f8e43423          	sd	a4,-120(s0)
    80000794:	00100613          	li	a2,1
    80000798:	00a00593          	li	a1,10
    8000079c:	0007a503          	lw	a0,0(a5)
    800007a0:	df1ff0ef          	jal	80000590 <printint>
    800007a4:	f79ff06f          	j	8000071c <printf+0xc0>
    } else if(c0 == 'l' && c1 == 'd'){
    800007a8:	03678a63          	beq	a5,s6,800007dc <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800007ac:	05878a63          	beq	a5,s8,80000800 <printf+0x1a4>
    } else if(c0 == 'l' && c1 == 'u'){
    800007b0:	0d978863          	beq	a5,s9,80000880 <printf+0x224>
    } else if(c0 == 'l' && c1 == 'x'){
    800007b4:	fda790e3          	bne	a5,s10,80000774 <printf+0x118>
      printint(va_arg(ap, uint64), 16, 0);
    800007b8:	f8843783          	ld	a5,-120(s0)
    800007bc:	00878713          	addi	a4,a5,8
    800007c0:	f8e43423          	sd	a4,-120(s0)
    800007c4:	00000613          	li	a2,0
    800007c8:	01000593          	li	a1,16
    800007cc:	0007b503          	ld	a0,0(a5)
    800007d0:	dc1ff0ef          	jal	80000590 <printint>
      i += 1;
    800007d4:	0029849b          	addiw	s1,s3,2
    800007d8:	f45ff06f          	j	8000071c <printf+0xc0>
      printint(va_arg(ap, uint64), 10, 1);
    800007dc:	f8843783          	ld	a5,-120(s0)
    800007e0:	00878713          	addi	a4,a5,8
    800007e4:	f8e43423          	sd	a4,-120(s0)
    800007e8:	00100613          	li	a2,1
    800007ec:	00a00593          	li	a1,10
    800007f0:	0007b503          	ld	a0,0(a5)
    800007f4:	d9dff0ef          	jal	80000590 <printint>
      i += 1;
    800007f8:	0029849b          	addiw	s1,s3,2
    800007fc:	f21ff06f          	j	8000071c <printf+0xc0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000800:	06400793          	li	a5,100
    80000804:	02f68c63          	beq	a3,a5,8000083c <printf+0x1e0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000808:	07500793          	li	a5,117
    8000080c:	08f68c63          	beq	a3,a5,800008a4 <printf+0x248>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000810:	07800793          	li	a5,120
    80000814:	f6f690e3          	bne	a3,a5,80000774 <printf+0x118>
      printint(va_arg(ap, uint64), 16, 0);
    80000818:	f8843783          	ld	a5,-120(s0)
    8000081c:	00878713          	addi	a4,a5,8
    80000820:	f8e43423          	sd	a4,-120(s0)
    80000824:	00000613          	li	a2,0
    80000828:	01000593          	li	a1,16
    8000082c:	0007b503          	ld	a0,0(a5)
    80000830:	d61ff0ef          	jal	80000590 <printint>
      i += 2;
    80000834:	0039849b          	addiw	s1,s3,3
    80000838:	ee5ff06f          	j	8000071c <printf+0xc0>
      printint(va_arg(ap, uint64), 10, 1);
    8000083c:	f8843783          	ld	a5,-120(s0)
    80000840:	00878713          	addi	a4,a5,8
    80000844:	f8e43423          	sd	a4,-120(s0)
    80000848:	00100613          	li	a2,1
    8000084c:	00a00593          	li	a1,10
    80000850:	0007b503          	ld	a0,0(a5)
    80000854:	d3dff0ef          	jal	80000590 <printint>
      i += 2;
    80000858:	0039849b          	addiw	s1,s3,3
    8000085c:	ec1ff06f          	j	8000071c <printf+0xc0>
      printint(va_arg(ap, int), 10, 0);
    80000860:	f8843783          	ld	a5,-120(s0)
    80000864:	00878713          	addi	a4,a5,8
    80000868:	f8e43423          	sd	a4,-120(s0)
    8000086c:	00000613          	li	a2,0
    80000870:	00a00593          	li	a1,10
    80000874:	0007a503          	lw	a0,0(a5)
    80000878:	d19ff0ef          	jal	80000590 <printint>
    8000087c:	ea1ff06f          	j	8000071c <printf+0xc0>
      printint(va_arg(ap, uint64), 10, 0);
    80000880:	f8843783          	ld	a5,-120(s0)
    80000884:	00878713          	addi	a4,a5,8
    80000888:	f8e43423          	sd	a4,-120(s0)
    8000088c:	00000613          	li	a2,0
    80000890:	00a00593          	li	a1,10
    80000894:	0007b503          	ld	a0,0(a5)
    80000898:	cf9ff0ef          	jal	80000590 <printint>
      i += 1;
    8000089c:	0029849b          	addiw	s1,s3,2
    800008a0:	e7dff06f          	j	8000071c <printf+0xc0>
      printint(va_arg(ap, uint64), 10, 0);
    800008a4:	f8843783          	ld	a5,-120(s0)
    800008a8:	00878713          	addi	a4,a5,8
    800008ac:	f8e43423          	sd	a4,-120(s0)
    800008b0:	00000613          	li	a2,0
    800008b4:	00a00593          	li	a1,10
    800008b8:	0007b503          	ld	a0,0(a5)
    800008bc:	cd5ff0ef          	jal	80000590 <printint>
      i += 2;
    800008c0:	0039849b          	addiw	s1,s3,3
    800008c4:	e59ff06f          	j	8000071c <printf+0xc0>
      printint(va_arg(ap, int), 16, 0);
    800008c8:	f8843783          	ld	a5,-120(s0)
    800008cc:	00878713          	addi	a4,a5,8
    800008d0:	f8e43423          	sd	a4,-120(s0)
    800008d4:	00000613          	li	a2,0
    800008d8:	01000593          	li	a1,16
    800008dc:	0007a503          	lw	a0,0(a5)
    800008e0:	cb1ff0ef          	jal	80000590 <printint>
    800008e4:	e39ff06f          	j	8000071c <printf+0xc0>
    800008e8:	05713423          	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800008ec:	f8843783          	ld	a5,-120(s0)
    800008f0:	00878713          	addi	a4,a5,8
    800008f4:	f8e43423          	sd	a4,-120(s0)
    800008f8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800008fc:	03000513          	li	a0,48
    80000900:	a29ff0ef          	jal	80000328 <consputc>
  consputc('x');
    80000904:	07800513          	li	a0,120
    80000908:	a21ff0ef          	jal	80000328 <consputc>
    8000090c:	01000913          	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000910:	00009b97          	auipc	s7,0x9
    80000914:	e60b8b93          	addi	s7,s7,-416 # 80009770 <digits>
    80000918:	03c9d793          	srli	a5,s3,0x3c
    8000091c:	00fb87b3          	add	a5,s7,a5
    80000920:	0007c503          	lbu	a0,0(a5)
    80000924:	a05ff0ef          	jal	80000328 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000928:	00499993          	slli	s3,s3,0x4
    8000092c:	fff9091b          	addiw	s2,s2,-1
    80000930:	fe0914e3          	bnez	s2,80000918 <printf+0x2bc>
    80000934:	04813b83          	ld	s7,72(sp)
    80000938:	de5ff06f          	j	8000071c <printf+0xc0>
      if((s = va_arg(ap, char*)) == 0)
    8000093c:	f8843783          	ld	a5,-120(s0)
    80000940:	00878713          	addi	a4,a5,8
    80000944:	f8e43423          	sd	a4,-120(s0)
    80000948:	0007b903          	ld	s2,0(a5)
    8000094c:	02090063          	beqz	s2,8000096c <printf+0x310>
      for(; *s; s++)
    80000950:	00094503          	lbu	a0,0(s2)
    80000954:	dc0504e3          	beqz	a0,8000071c <printf+0xc0>
        consputc(*s);
    80000958:	9d1ff0ef          	jal	80000328 <consputc>
      for(; *s; s++)
    8000095c:	00190913          	addi	s2,s2,1
    80000960:	00094503          	lbu	a0,0(s2)
    80000964:	fe051ae3          	bnez	a0,80000958 <printf+0x2fc>
    80000968:	db5ff06f          	j	8000071c <printf+0xc0>
        s = "(null)";
    8000096c:	00008917          	auipc	s2,0x8
    80000970:	69c90913          	addi	s2,s2,1692 # 80009008 <etext+0x8>
      for(; *s; s++)
    80000974:	02800513          	li	a0,40
    80000978:	fe1ff06f          	j	80000958 <printf+0x2fc>
      consputc('%');
    8000097c:	02500513          	li	a0,37
    80000980:	9a9ff0ef          	jal	80000328 <consputc>
    80000984:	d99ff06f          	j	8000071c <printf+0xc0>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80000988:	f7843783          	ld	a5,-136(s0)
    8000098c:	04079063          	bnez	a5,800009cc <printf+0x370>
    80000990:	07813483          	ld	s1,120(sp)
    80000994:	07013903          	ld	s2,112(sp)
    80000998:	06813983          	ld	s3,104(sp)
    8000099c:	05813a83          	ld	s5,88(sp)
    800009a0:	05013b03          	ld	s6,80(sp)
    800009a4:	04013c03          	ld	s8,64(sp)
    800009a8:	03813c83          	ld	s9,56(sp)
    800009ac:	03013d03          	ld	s10,48(sp)
    800009b0:	02813d83          	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800009b4:	00000513          	li	a0,0
    800009b8:	08813083          	ld	ra,136(sp)
    800009bc:	08013403          	ld	s0,128(sp)
    800009c0:	06013a03          	ld	s4,96(sp)
    800009c4:	0d010113          	addi	sp,sp,208
    800009c8:	00008067          	ret
    800009cc:	07813483          	ld	s1,120(sp)
    800009d0:	07013903          	ld	s2,112(sp)
    800009d4:	06813983          	ld	s3,104(sp)
    800009d8:	05813a83          	ld	s5,88(sp)
    800009dc:	05013b03          	ld	s6,80(sp)
    800009e0:	04013c03          	ld	s8,64(sp)
    800009e4:	03813c83          	ld	s9,56(sp)
    800009e8:	03013d03          	ld	s10,48(sp)
    800009ec:	02813d83          	ld	s11,40(sp)
    release(&pr.lock);
    800009f0:	00011517          	auipc	a0,0x11
    800009f4:	fc850513          	addi	a0,a0,-56 # 800119b8 <pr>
    800009f8:	72c000ef          	jal	80001124 <release>
    800009fc:	fb9ff06f          	j	800009b4 <printf+0x358>

0000000080000a00 <panic>:

void
panic(char *s)
{
    80000a00:	fe010113          	addi	sp,sp,-32
    80000a04:	00113c23          	sd	ra,24(sp)
    80000a08:	00813823          	sd	s0,16(sp)
    80000a0c:	00913423          	sd	s1,8(sp)
    80000a10:	02010413          	addi	s0,sp,32
    80000a14:	00050493          	mv	s1,a0
  pr.locking = 0;
    80000a18:	00011797          	auipc	a5,0x11
    80000a1c:	fa07ac23          	sw	zero,-72(a5) # 800119d0 <pr+0x18>
  printf("panic: ");
    80000a20:	00008517          	auipc	a0,0x8
    80000a24:	5f850513          	addi	a0,a0,1528 # 80009018 <etext+0x18>
    80000a28:	c35ff0ef          	jal	8000065c <printf>
  printf("%s\n", s);
    80000a2c:	00048593          	mv	a1,s1
    80000a30:	00008517          	auipc	a0,0x8
    80000a34:	5f050513          	addi	a0,a0,1520 # 80009020 <etext+0x20>
    80000a38:	c25ff0ef          	jal	8000065c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000a3c:	00100793          	li	a5,1
    80000a40:	00009717          	auipc	a4,0x9
    80000a44:	e8f72823          	sw	a5,-368(a4) # 800098d0 <panicked>
  for(;;)
    80000a48:	0000006f          	j	80000a48 <panic+0x48>

0000000080000a4c <printfinit>:
    ;
}

void
printfinit(void)
{
    80000a4c:	fe010113          	addi	sp,sp,-32
    80000a50:	00113c23          	sd	ra,24(sp)
    80000a54:	00813823          	sd	s0,16(sp)
    80000a58:	00913423          	sd	s1,8(sp)
    80000a5c:	02010413          	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000a60:	00011497          	auipc	s1,0x11
    80000a64:	f5848493          	addi	s1,s1,-168 # 800119b8 <pr>
    80000a68:	00008597          	auipc	a1,0x8
    80000a6c:	5c058593          	addi	a1,a1,1472 # 80009028 <etext+0x28>
    80000a70:	00048513          	mv	a0,s1
    80000a74:	500000ef          	jal	80000f74 <initlock>
  pr.locking = 1;
    80000a78:	00100793          	li	a5,1
    80000a7c:	00f4ac23          	sw	a5,24(s1)
}
    80000a80:	01813083          	ld	ra,24(sp)
    80000a84:	01013403          	ld	s0,16(sp)
    80000a88:	00813483          	ld	s1,8(sp)
    80000a8c:	02010113          	addi	sp,sp,32
    80000a90:	00008067          	ret

0000000080000a94 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000a94:	ff010113          	addi	sp,sp,-16
    80000a98:	00113423          	sd	ra,8(sp)
    80000a9c:	00813023          	sd	s0,0(sp)
    80000aa0:	01010413          	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000aa4:	100007b7          	lui	a5,0x10000
    80000aa8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000aac:	10000737          	lui	a4,0x10000
    80000ab0:	f8000693          	li	a3,-128
    80000ab4:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000ab8:	00300693          	li	a3,3
    80000abc:	10000637          	lui	a2,0x10000
    80000ac0:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000ac4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000ac8:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000acc:	10000737          	lui	a4,0x10000
    80000ad0:	00700613          	li	a2,7
    80000ad4:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000ad8:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000adc:	00008597          	auipc	a1,0x8
    80000ae0:	55458593          	addi	a1,a1,1364 # 80009030 <etext+0x30>
    80000ae4:	00011517          	auipc	a0,0x11
    80000ae8:	ef450513          	addi	a0,a0,-268 # 800119d8 <uart_tx_lock>
    80000aec:	488000ef          	jal	80000f74 <initlock>
}
    80000af0:	00813083          	ld	ra,8(sp)
    80000af4:	00013403          	ld	s0,0(sp)
    80000af8:	01010113          	addi	sp,sp,16
    80000afc:	00008067          	ret

0000000080000b00 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000b00:	fe010113          	addi	sp,sp,-32
    80000b04:	00113c23          	sd	ra,24(sp)
    80000b08:	00813823          	sd	s0,16(sp)
    80000b0c:	00913423          	sd	s1,8(sp)
    80000b10:	02010413          	addi	s0,sp,32
    80000b14:	00050493          	mv	s1,a0
  push_off();
    80000b18:	4c8000ef          	jal	80000fe0 <push_off>

  if(panicked){
    80000b1c:	00009797          	auipc	a5,0x9
    80000b20:	db47a783          	lw	a5,-588(a5) # 800098d0 <panicked>
    80000b24:	02079e63          	bnez	a5,80000b60 <uartputc_sync+0x60>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000b28:	10000737          	lui	a4,0x10000
    80000b2c:	00570713          	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000b30:	00074783          	lbu	a5,0(a4)
    80000b34:	0207f793          	andi	a5,a5,32
    80000b38:	fe078ce3          	beqz	a5,80000b30 <uartputc_sync+0x30>
    ;
  WriteReg(THR, c);
    80000b3c:	0ff4f513          	zext.b	a0,s1
    80000b40:	100007b7          	lui	a5,0x10000
    80000b44:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000b48:	568000ef          	jal	800010b0 <pop_off>
}
    80000b4c:	01813083          	ld	ra,24(sp)
    80000b50:	01013403          	ld	s0,16(sp)
    80000b54:	00813483          	ld	s1,8(sp)
    80000b58:	02010113          	addi	sp,sp,32
    80000b5c:	00008067          	ret
    for(;;)
    80000b60:	0000006f          	j	80000b60 <uartputc_sync+0x60>

0000000080000b64 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000b64:	00009797          	auipc	a5,0x9
    80000b68:	d747b783          	ld	a5,-652(a5) # 800098d8 <uart_tx_r>
    80000b6c:	00009717          	auipc	a4,0x9
    80000b70:	d7473703          	ld	a4,-652(a4) # 800098e0 <uart_tx_w>
    80000b74:	0af70e63          	beq	a4,a5,80000c30 <uartstart+0xcc>
{
    80000b78:	fc010113          	addi	sp,sp,-64
    80000b7c:	02113c23          	sd	ra,56(sp)
    80000b80:	02813823          	sd	s0,48(sp)
    80000b84:	02913423          	sd	s1,40(sp)
    80000b88:	03213023          	sd	s2,32(sp)
    80000b8c:	01313c23          	sd	s3,24(sp)
    80000b90:	01413823          	sd	s4,16(sp)
    80000b94:	01513423          	sd	s5,8(sp)
    80000b98:	01613023          	sd	s6,0(sp)
    80000b9c:	04010413          	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000ba0:	10000937          	lui	s2,0x10000
    80000ba4:	00590913          	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000ba8:	00011a97          	auipc	s5,0x11
    80000bac:	e30a8a93          	addi	s5,s5,-464 # 800119d8 <uart_tx_lock>
    uart_tx_r += 1;
    80000bb0:	00009497          	auipc	s1,0x9
    80000bb4:	d2848493          	addi	s1,s1,-728 # 800098d8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80000bb8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80000bbc:	00009997          	auipc	s3,0x9
    80000bc0:	d2498993          	addi	s3,s3,-732 # 800098e0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000bc4:	00094703          	lbu	a4,0(s2)
    80000bc8:	02077713          	andi	a4,a4,32
    80000bcc:	02070e63          	beqz	a4,80000c08 <uartstart+0xa4>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000bd0:	01f7f713          	andi	a4,a5,31
    80000bd4:	00ea8733          	add	a4,s5,a4
    80000bd8:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80000bdc:	00178793          	addi	a5,a5,1
    80000be0:	00f4b023          	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80000be4:	00048513          	mv	a0,s1
    80000be8:	168020ef          	jal	80002d50 <wakeup>
    WriteReg(THR, c);
    80000bec:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000bf0:	0004b783          	ld	a5,0(s1)
    80000bf4:	0009b703          	ld	a4,0(s3)
    80000bf8:	fcf716e3          	bne	a4,a5,80000bc4 <uartstart+0x60>
      ReadReg(ISR);
    80000bfc:	100007b7          	lui	a5,0x10000
    80000c00:	00278793          	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000c04:	0007c783          	lbu	a5,0(a5)
  }
}
    80000c08:	03813083          	ld	ra,56(sp)
    80000c0c:	03013403          	ld	s0,48(sp)
    80000c10:	02813483          	ld	s1,40(sp)
    80000c14:	02013903          	ld	s2,32(sp)
    80000c18:	01813983          	ld	s3,24(sp)
    80000c1c:	01013a03          	ld	s4,16(sp)
    80000c20:	00813a83          	ld	s5,8(sp)
    80000c24:	00013b03          	ld	s6,0(sp)
    80000c28:	04010113          	addi	sp,sp,64
    80000c2c:	00008067          	ret
      ReadReg(ISR);
    80000c30:	100007b7          	lui	a5,0x10000
    80000c34:	00278793          	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000c38:	0007c783          	lbu	a5,0(a5)
      return;
    80000c3c:	00008067          	ret

0000000080000c40 <uartputc>:
{
    80000c40:	fd010113          	addi	sp,sp,-48
    80000c44:	02113423          	sd	ra,40(sp)
    80000c48:	02813023          	sd	s0,32(sp)
    80000c4c:	00913c23          	sd	s1,24(sp)
    80000c50:	01213823          	sd	s2,16(sp)
    80000c54:	01313423          	sd	s3,8(sp)
    80000c58:	01413023          	sd	s4,0(sp)
    80000c5c:	03010413          	addi	s0,sp,48
    80000c60:	00050a13          	mv	s4,a0
  acquire(&uart_tx_lock);
    80000c64:	00011517          	auipc	a0,0x11
    80000c68:	d7450513          	addi	a0,a0,-652 # 800119d8 <uart_tx_lock>
    80000c6c:	3dc000ef          	jal	80001048 <acquire>
  if(panicked){
    80000c70:	00009797          	auipc	a5,0x9
    80000c74:	c607a783          	lw	a5,-928(a5) # 800098d0 <panicked>
    80000c78:	08079e63          	bnez	a5,80000d14 <uartputc+0xd4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000c7c:	00009717          	auipc	a4,0x9
    80000c80:	c6473703          	ld	a4,-924(a4) # 800098e0 <uart_tx_w>
    80000c84:	00009797          	auipc	a5,0x9
    80000c88:	c547b783          	ld	a5,-940(a5) # 800098d8 <uart_tx_r>
    80000c8c:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000c90:	00011997          	auipc	s3,0x11
    80000c94:	d4898993          	addi	s3,s3,-696 # 800119d8 <uart_tx_lock>
    80000c98:	00009497          	auipc	s1,0x9
    80000c9c:	c4048493          	addi	s1,s1,-960 # 800098d8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000ca0:	00009917          	auipc	s2,0x9
    80000ca4:	c4090913          	addi	s2,s2,-960 # 800098e0 <uart_tx_w>
    80000ca8:	02e79063          	bne	a5,a4,80000cc8 <uartputc+0x88>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000cac:	00098593          	mv	a1,s3
    80000cb0:	00048513          	mv	a0,s1
    80000cb4:	024020ef          	jal	80002cd8 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000cb8:	00093703          	ld	a4,0(s2)
    80000cbc:	0004b783          	ld	a5,0(s1)
    80000cc0:	02078793          	addi	a5,a5,32
    80000cc4:	fee784e3          	beq	a5,a4,80000cac <uartputc+0x6c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000cc8:	00011497          	auipc	s1,0x11
    80000ccc:	d1048493          	addi	s1,s1,-752 # 800119d8 <uart_tx_lock>
    80000cd0:	01f77793          	andi	a5,a4,31
    80000cd4:	00f487b3          	add	a5,s1,a5
    80000cd8:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000cdc:	00170713          	addi	a4,a4,1
    80000ce0:	00009797          	auipc	a5,0x9
    80000ce4:	c0e7b023          	sd	a4,-1024(a5) # 800098e0 <uart_tx_w>
  uartstart();
    80000ce8:	e7dff0ef          	jal	80000b64 <uartstart>
  release(&uart_tx_lock);
    80000cec:	00048513          	mv	a0,s1
    80000cf0:	434000ef          	jal	80001124 <release>
}
    80000cf4:	02813083          	ld	ra,40(sp)
    80000cf8:	02013403          	ld	s0,32(sp)
    80000cfc:	01813483          	ld	s1,24(sp)
    80000d00:	01013903          	ld	s2,16(sp)
    80000d04:	00813983          	ld	s3,8(sp)
    80000d08:	00013a03          	ld	s4,0(sp)
    80000d0c:	03010113          	addi	sp,sp,48
    80000d10:	00008067          	ret
    for(;;)
    80000d14:	0000006f          	j	80000d14 <uartputc+0xd4>

0000000080000d18 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000d18:	ff010113          	addi	sp,sp,-16
    80000d1c:	00813423          	sd	s0,8(sp)
    80000d20:	01010413          	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000d24:	100007b7          	lui	a5,0x10000
    80000d28:	00578793          	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80000d2c:	0007c783          	lbu	a5,0(a5)
    80000d30:	0017f793          	andi	a5,a5,1
    80000d34:	00078c63          	beqz	a5,80000d4c <uartgetc+0x34>
    // input data is ready.
    return ReadReg(RHR);
    80000d38:	100007b7          	lui	a5,0x10000
    80000d3c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000d40:	00813403          	ld	s0,8(sp)
    80000d44:	01010113          	addi	sp,sp,16
    80000d48:	00008067          	ret
    return -1;
    80000d4c:	fff00513          	li	a0,-1
    80000d50:	ff1ff06f          	j	80000d40 <uartgetc+0x28>

0000000080000d54 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000d54:	fe010113          	addi	sp,sp,-32
    80000d58:	00113c23          	sd	ra,24(sp)
    80000d5c:	00813823          	sd	s0,16(sp)
    80000d60:	00913423          	sd	s1,8(sp)
    80000d64:	02010413          	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000d68:	fff00493          	li	s1,-1
    80000d6c:	0080006f          	j	80000d74 <uartintr+0x20>
      break;
    consoleintr(c);
    80000d70:	e00ff0ef          	jal	80000370 <consoleintr>
    int c = uartgetc();
    80000d74:	fa5ff0ef          	jal	80000d18 <uartgetc>
    if(c == -1)
    80000d78:	fe951ce3          	bne	a0,s1,80000d70 <uartintr+0x1c>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000d7c:	00011497          	auipc	s1,0x11
    80000d80:	c5c48493          	addi	s1,s1,-932 # 800119d8 <uart_tx_lock>
    80000d84:	00048513          	mv	a0,s1
    80000d88:	2c0000ef          	jal	80001048 <acquire>
  uartstart();
    80000d8c:	dd9ff0ef          	jal	80000b64 <uartstart>
  release(&uart_tx_lock);
    80000d90:	00048513          	mv	a0,s1
    80000d94:	390000ef          	jal	80001124 <release>
}
    80000d98:	01813083          	ld	ra,24(sp)
    80000d9c:	01013403          	ld	s0,16(sp)
    80000da0:	00813483          	ld	s1,8(sp)
    80000da4:	02010113          	addi	sp,sp,32
    80000da8:	00008067          	ret

0000000080000dac <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000dac:	fe010113          	addi	sp,sp,-32
    80000db0:	00113c23          	sd	ra,24(sp)
    80000db4:	00813823          	sd	s0,16(sp)
    80000db8:	00913423          	sd	s1,8(sp)
    80000dbc:	01213023          	sd	s2,0(sp)
    80000dc0:	02010413          	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000dc4:	03451793          	slli	a5,a0,0x34
    80000dc8:	06079463          	bnez	a5,80000e30 <kfree+0x84>
    80000dcc:	00050493          	mv	s1,a0
    80000dd0:	00022797          	auipc	a5,0x22
    80000dd4:	e7078793          	addi	a5,a5,-400 # 80022c40 <end>
    80000dd8:	04f56c63          	bltu	a0,a5,80000e30 <kfree+0x84>
    80000ddc:	01100793          	li	a5,17
    80000de0:	01b79793          	slli	a5,a5,0x1b
    80000de4:	04f57663          	bgeu	a0,a5,80000e30 <kfree+0x84>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000de8:	00001637          	lui	a2,0x1
    80000dec:	00100593          	li	a1,1
    80000df0:	388000ef          	jal	80001178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000df4:	00011917          	auipc	s2,0x11
    80000df8:	c1c90913          	addi	s2,s2,-996 # 80011a10 <kmem>
    80000dfc:	00090513          	mv	a0,s2
    80000e00:	248000ef          	jal	80001048 <acquire>
  r->next = kmem.freelist;
    80000e04:	01893783          	ld	a5,24(s2)
    80000e08:	00f4b023          	sd	a5,0(s1)
  kmem.freelist = r;
    80000e0c:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000e10:	00090513          	mv	a0,s2
    80000e14:	310000ef          	jal	80001124 <release>
}
    80000e18:	01813083          	ld	ra,24(sp)
    80000e1c:	01013403          	ld	s0,16(sp)
    80000e20:	00813483          	ld	s1,8(sp)
    80000e24:	00013903          	ld	s2,0(sp)
    80000e28:	02010113          	addi	sp,sp,32
    80000e2c:	00008067          	ret
    panic("kfree");
    80000e30:	00008517          	auipc	a0,0x8
    80000e34:	20850513          	addi	a0,a0,520 # 80009038 <etext+0x38>
    80000e38:	bc9ff0ef          	jal	80000a00 <panic>

0000000080000e3c <freerange>:
{
    80000e3c:	fd010113          	addi	sp,sp,-48
    80000e40:	02113423          	sd	ra,40(sp)
    80000e44:	02813023          	sd	s0,32(sp)
    80000e48:	00913c23          	sd	s1,24(sp)
    80000e4c:	03010413          	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000e50:	000017b7          	lui	a5,0x1
    80000e54:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000e58:	00e504b3          	add	s1,a0,a4
    80000e5c:	fffff737          	lui	a4,0xfffff
    80000e60:	00e4f4b3          	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000e64:	00f484b3          	add	s1,s1,a5
    80000e68:	0295ec63          	bltu	a1,s1,80000ea0 <freerange+0x64>
    80000e6c:	01213823          	sd	s2,16(sp)
    80000e70:	01313423          	sd	s3,8(sp)
    80000e74:	01413023          	sd	s4,0(sp)
    80000e78:	00058913          	mv	s2,a1
    kfree(p);
    80000e7c:	fffffa37          	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000e80:	000019b7          	lui	s3,0x1
    kfree(p);
    80000e84:	01448533          	add	a0,s1,s4
    80000e88:	f25ff0ef          	jal	80000dac <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000e8c:	013484b3          	add	s1,s1,s3
    80000e90:	fe997ae3          	bgeu	s2,s1,80000e84 <freerange+0x48>
    80000e94:	01013903          	ld	s2,16(sp)
    80000e98:	00813983          	ld	s3,8(sp)
    80000e9c:	00013a03          	ld	s4,0(sp)
}
    80000ea0:	02813083          	ld	ra,40(sp)
    80000ea4:	02013403          	ld	s0,32(sp)
    80000ea8:	01813483          	ld	s1,24(sp)
    80000eac:	03010113          	addi	sp,sp,48
    80000eb0:	00008067          	ret

0000000080000eb4 <kinit>:
{
    80000eb4:	ff010113          	addi	sp,sp,-16
    80000eb8:	00113423          	sd	ra,8(sp)
    80000ebc:	00813023          	sd	s0,0(sp)
    80000ec0:	01010413          	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ec4:	00008597          	auipc	a1,0x8
    80000ec8:	17c58593          	addi	a1,a1,380 # 80009040 <etext+0x40>
    80000ecc:	00011517          	auipc	a0,0x11
    80000ed0:	b4450513          	addi	a0,a0,-1212 # 80011a10 <kmem>
    80000ed4:	0a0000ef          	jal	80000f74 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ed8:	01100593          	li	a1,17
    80000edc:	01b59593          	slli	a1,a1,0x1b
    80000ee0:	00022517          	auipc	a0,0x22
    80000ee4:	d6050513          	addi	a0,a0,-672 # 80022c40 <end>
    80000ee8:	f55ff0ef          	jal	80000e3c <freerange>
}
    80000eec:	00813083          	ld	ra,8(sp)
    80000ef0:	00013403          	ld	s0,0(sp)
    80000ef4:	01010113          	addi	sp,sp,16
    80000ef8:	00008067          	ret

0000000080000efc <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000efc:	fe010113          	addi	sp,sp,-32
    80000f00:	00113c23          	sd	ra,24(sp)
    80000f04:	00813823          	sd	s0,16(sp)
    80000f08:	00913423          	sd	s1,8(sp)
    80000f0c:	02010413          	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000f10:	00011497          	auipc	s1,0x11
    80000f14:	b0048493          	addi	s1,s1,-1280 # 80011a10 <kmem>
    80000f18:	00048513          	mv	a0,s1
    80000f1c:	12c000ef          	jal	80001048 <acquire>
  r = kmem.freelist;
    80000f20:	0184b483          	ld	s1,24(s1)
  if(r)
    80000f24:	04048063          	beqz	s1,80000f64 <kalloc+0x68>
    kmem.freelist = r->next;
    80000f28:	0004b783          	ld	a5,0(s1)
    80000f2c:	00011517          	auipc	a0,0x11
    80000f30:	ae450513          	addi	a0,a0,-1308 # 80011a10 <kmem>
    80000f34:	00f53c23          	sd	a5,24(a0)
  release(&kmem.lock);
    80000f38:	1ec000ef          	jal	80001124 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000f3c:	00001637          	lui	a2,0x1
    80000f40:	00500593          	li	a1,5
    80000f44:	00048513          	mv	a0,s1
    80000f48:	230000ef          	jal	80001178 <memset>
  return (void*)r;
}
    80000f4c:	00048513          	mv	a0,s1
    80000f50:	01813083          	ld	ra,24(sp)
    80000f54:	01013403          	ld	s0,16(sp)
    80000f58:	00813483          	ld	s1,8(sp)
    80000f5c:	02010113          	addi	sp,sp,32
    80000f60:	00008067          	ret
  release(&kmem.lock);
    80000f64:	00011517          	auipc	a0,0x11
    80000f68:	aac50513          	addi	a0,a0,-1364 # 80011a10 <kmem>
    80000f6c:	1b8000ef          	jal	80001124 <release>
  if(r)
    80000f70:	fddff06f          	j	80000f4c <kalloc+0x50>

0000000080000f74 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000f74:	ff010113          	addi	sp,sp,-16
    80000f78:	00813423          	sd	s0,8(sp)
    80000f7c:	01010413          	addi	s0,sp,16
  lk->name = name;
    80000f80:	00b53423          	sd	a1,8(a0)
  lk->locked = 0;
    80000f84:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000f88:	00053823          	sd	zero,16(a0)
}
    80000f8c:	00813403          	ld	s0,8(sp)
    80000f90:	01010113          	addi	sp,sp,16
    80000f94:	00008067          	ret

0000000080000f98 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000f98:	00052783          	lw	a5,0(a0)
    80000f9c:	00079663          	bnez	a5,80000fa8 <holding+0x10>
    80000fa0:	00000513          	li	a0,0
  return r;
}
    80000fa4:	00008067          	ret
{
    80000fa8:	fe010113          	addi	sp,sp,-32
    80000fac:	00113c23          	sd	ra,24(sp)
    80000fb0:	00813823          	sd	s0,16(sp)
    80000fb4:	00913423          	sd	s1,8(sp)
    80000fb8:	02010413          	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000fbc:	01053483          	ld	s1,16(a0)
    80000fc0:	46c010ef          	jal	8000242c <mycpu>
    80000fc4:	40a48533          	sub	a0,s1,a0
    80000fc8:	00153513          	seqz	a0,a0
}
    80000fcc:	01813083          	ld	ra,24(sp)
    80000fd0:	01013403          	ld	s0,16(sp)
    80000fd4:	00813483          	ld	s1,8(sp)
    80000fd8:	02010113          	addi	sp,sp,32
    80000fdc:	00008067          	ret

0000000080000fe0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000fe0:	fe010113          	addi	sp,sp,-32
    80000fe4:	00113c23          	sd	ra,24(sp)
    80000fe8:	00813823          	sd	s0,16(sp)
    80000fec:	00913423          	sd	s1,8(sp)
    80000ff0:	02010413          	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000ff4:	100024f3          	csrr	s1,sstatus
    80000ff8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000ffc:	ffd7f793          	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001000:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80001004:	428010ef          	jal	8000242c <mycpu>
    80001008:	07852783          	lw	a5,120(a0)
    8000100c:	02078463          	beqz	a5,80001034 <push_off+0x54>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80001010:	41c010ef          	jal	8000242c <mycpu>
    80001014:	07852783          	lw	a5,120(a0)
    80001018:	0017879b          	addiw	a5,a5,1
    8000101c:	06f52c23          	sw	a5,120(a0)
}
    80001020:	01813083          	ld	ra,24(sp)
    80001024:	01013403          	ld	s0,16(sp)
    80001028:	00813483          	ld	s1,8(sp)
    8000102c:	02010113          	addi	sp,sp,32
    80001030:	00008067          	ret
    mycpu()->intena = old;
    80001034:	3f8010ef          	jal	8000242c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80001038:	0014d493          	srli	s1,s1,0x1
    8000103c:	0014f493          	andi	s1,s1,1
    80001040:	06952e23          	sw	s1,124(a0)
    80001044:	fcdff06f          	j	80001010 <push_off+0x30>

0000000080001048 <acquire>:
{
    80001048:	fe010113          	addi	sp,sp,-32
    8000104c:	00113c23          	sd	ra,24(sp)
    80001050:	00813823          	sd	s0,16(sp)
    80001054:	00913423          	sd	s1,8(sp)
    80001058:	02010413          	addi	s0,sp,32
    8000105c:	00050493          	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80001060:	f81ff0ef          	jal	80000fe0 <push_off>
  if(holding(lk))
    80001064:	00048513          	mv	a0,s1
    80001068:	f31ff0ef          	jal	80000f98 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000106c:	00100713          	li	a4,1
  if(holding(lk))
    80001070:	02051a63          	bnez	a0,800010a4 <acquire+0x5c>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80001074:	00070793          	mv	a5,a4
    80001078:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000107c:	0007879b          	sext.w	a5,a5
    80001080:	fe079ae3          	bnez	a5,80001074 <acquire+0x2c>
  __sync_synchronize();
    80001084:	0ff0000f          	fence
  lk->cpu = mycpu();
    80001088:	3a4010ef          	jal	8000242c <mycpu>
    8000108c:	00a4b823          	sd	a0,16(s1)
}
    80001090:	01813083          	ld	ra,24(sp)
    80001094:	01013403          	ld	s0,16(sp)
    80001098:	00813483          	ld	s1,8(sp)
    8000109c:	02010113          	addi	sp,sp,32
    800010a0:	00008067          	ret
    panic("acquire");
    800010a4:	00008517          	auipc	a0,0x8
    800010a8:	fa450513          	addi	a0,a0,-92 # 80009048 <etext+0x48>
    800010ac:	955ff0ef          	jal	80000a00 <panic>

00000000800010b0 <pop_off>:

void
pop_off(void)
{
    800010b0:	ff010113          	addi	sp,sp,-16
    800010b4:	00113423          	sd	ra,8(sp)
    800010b8:	00813023          	sd	s0,0(sp)
    800010bc:	01010413          	addi	s0,sp,16
  struct cpu *c = mycpu();
    800010c0:	36c010ef          	jal	8000242c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800010c4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800010c8:	0027f793          	andi	a5,a5,2
  if(intr_get())
    800010cc:	04079063          	bnez	a5,8000110c <pop_off+0x5c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800010d0:	07852783          	lw	a5,120(a0)
    800010d4:	04f05263          	blez	a5,80001118 <pop_off+0x68>
    panic("pop_off");
  c->noff -= 1;
    800010d8:	fff7879b          	addiw	a5,a5,-1
    800010dc:	0007871b          	sext.w	a4,a5
    800010e0:	06f52c23          	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800010e4:	00071c63          	bnez	a4,800010fc <pop_off+0x4c>
    800010e8:	07c52783          	lw	a5,124(a0)
    800010ec:	00078863          	beqz	a5,800010fc <pop_off+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800010f0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800010f4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800010f8:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800010fc:	00813083          	ld	ra,8(sp)
    80001100:	00013403          	ld	s0,0(sp)
    80001104:	01010113          	addi	sp,sp,16
    80001108:	00008067          	ret
    panic("pop_off - interruptible");
    8000110c:	00008517          	auipc	a0,0x8
    80001110:	f4450513          	addi	a0,a0,-188 # 80009050 <etext+0x50>
    80001114:	8edff0ef          	jal	80000a00 <panic>
    panic("pop_off");
    80001118:	00008517          	auipc	a0,0x8
    8000111c:	f5050513          	addi	a0,a0,-176 # 80009068 <etext+0x68>
    80001120:	8e1ff0ef          	jal	80000a00 <panic>

0000000080001124 <release>:
{
    80001124:	fe010113          	addi	sp,sp,-32
    80001128:	00113c23          	sd	ra,24(sp)
    8000112c:	00813823          	sd	s0,16(sp)
    80001130:	00913423          	sd	s1,8(sp)
    80001134:	02010413          	addi	s0,sp,32
    80001138:	00050493          	mv	s1,a0
  if(!holding(lk))
    8000113c:	e5dff0ef          	jal	80000f98 <holding>
    80001140:	02050663          	beqz	a0,8000116c <release+0x48>
  lk->cpu = 0;
    80001144:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80001148:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000114c:	0f50000f          	fence	iorw,ow
    80001150:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80001154:	f5dff0ef          	jal	800010b0 <pop_off>
}
    80001158:	01813083          	ld	ra,24(sp)
    8000115c:	01013403          	ld	s0,16(sp)
    80001160:	00813483          	ld	s1,8(sp)
    80001164:	02010113          	addi	sp,sp,32
    80001168:	00008067          	ret
    panic("release");
    8000116c:	00008517          	auipc	a0,0x8
    80001170:	f0450513          	addi	a0,a0,-252 # 80009070 <etext+0x70>
    80001174:	88dff0ef          	jal	80000a00 <panic>

0000000080001178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80001178:	ff010113          	addi	sp,sp,-16
    8000117c:	00813423          	sd	s0,8(sp)
    80001180:	01010413          	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80001184:	02060063          	beqz	a2,800011a4 <memset+0x2c>
    80001188:	00050793          	mv	a5,a0
    8000118c:	02061613          	slli	a2,a2,0x20
    80001190:	02065613          	srli	a2,a2,0x20
    80001194:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80001198:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000119c:	00178793          	addi	a5,a5,1
    800011a0:	fee79ce3          	bne	a5,a4,80001198 <memset+0x20>
  }
  return dst;
}
    800011a4:	00813403          	ld	s0,8(sp)
    800011a8:	01010113          	addi	sp,sp,16
    800011ac:	00008067          	ret

00000000800011b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800011b0:	ff010113          	addi	sp,sp,-16
    800011b4:	00813423          	sd	s0,8(sp)
    800011b8:	01010413          	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800011bc:	04060463          	beqz	a2,80001204 <memcmp+0x54>
    800011c0:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800011c4:	02069693          	slli	a3,a3,0x20
    800011c8:	0206d693          	srli	a3,a3,0x20
    800011cc:	00168693          	addi	a3,a3,1
    800011d0:	00d506b3          	add	a3,a0,a3
    if(*s1 != *s2)
    800011d4:	00054783          	lbu	a5,0(a0)
    800011d8:	0005c703          	lbu	a4,0(a1)
    800011dc:	00e79c63          	bne	a5,a4,800011f4 <memcmp+0x44>
      return *s1 - *s2;
    s1++, s2++;
    800011e0:	00150513          	addi	a0,a0,1
    800011e4:	00158593          	addi	a1,a1,1
  while(n-- > 0){
    800011e8:	fed516e3          	bne	a0,a3,800011d4 <memcmp+0x24>
  }

  return 0;
    800011ec:	00000513          	li	a0,0
    800011f0:	0080006f          	j	800011f8 <memcmp+0x48>
      return *s1 - *s2;
    800011f4:	40e7853b          	subw	a0,a5,a4
}
    800011f8:	00813403          	ld	s0,8(sp)
    800011fc:	01010113          	addi	sp,sp,16
    80001200:	00008067          	ret
  return 0;
    80001204:	00000513          	li	a0,0
    80001208:	ff1ff06f          	j	800011f8 <memcmp+0x48>

000000008000120c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000120c:	ff010113          	addi	sp,sp,-16
    80001210:	00813423          	sd	s0,8(sp)
    80001214:	01010413          	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80001218:	02060663          	beqz	a2,80001244 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000121c:	02a5ea63          	bltu	a1,a0,80001250 <memmove+0x44>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80001220:	02061613          	slli	a2,a2,0x20
    80001224:	02065613          	srli	a2,a2,0x20
    80001228:	00c587b3          	add	a5,a1,a2
{
    8000122c:	00050713          	mv	a4,a0
      *d++ = *s++;
    80001230:	00158593          	addi	a1,a1,1
    80001234:	00170713          	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdc3c1>
    80001238:	fff5c683          	lbu	a3,-1(a1)
    8000123c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80001240:	feb798e3          	bne	a5,a1,80001230 <memmove+0x24>

  return dst;
}
    80001244:	00813403          	ld	s0,8(sp)
    80001248:	01010113          	addi	sp,sp,16
    8000124c:	00008067          	ret
  if(s < d && s + n > d){
    80001250:	02061693          	slli	a3,a2,0x20
    80001254:	0206d693          	srli	a3,a3,0x20
    80001258:	00d58733          	add	a4,a1,a3
    8000125c:	fce572e3          	bgeu	a0,a4,80001220 <memmove+0x14>
    d += n;
    80001260:	00d506b3          	add	a3,a0,a3
    while(n-- > 0)
    80001264:	fff6079b          	addiw	a5,a2,-1
    80001268:	02079793          	slli	a5,a5,0x20
    8000126c:	0207d793          	srli	a5,a5,0x20
    80001270:	fff7c793          	not	a5,a5
    80001274:	00f707b3          	add	a5,a4,a5
      *--d = *--s;
    80001278:	fff70713          	addi	a4,a4,-1
    8000127c:	fff68693          	addi	a3,a3,-1
    80001280:	00074603          	lbu	a2,0(a4)
    80001284:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80001288:	fef718e3          	bne	a4,a5,80001278 <memmove+0x6c>
    8000128c:	fb9ff06f          	j	80001244 <memmove+0x38>

0000000080001290 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80001290:	ff010113          	addi	sp,sp,-16
    80001294:	00113423          	sd	ra,8(sp)
    80001298:	00813023          	sd	s0,0(sp)
    8000129c:	01010413          	addi	s0,sp,16
  return memmove(dst, src, n);
    800012a0:	f6dff0ef          	jal	8000120c <memmove>
}
    800012a4:	00813083          	ld	ra,8(sp)
    800012a8:	00013403          	ld	s0,0(sp)
    800012ac:	01010113          	addi	sp,sp,16
    800012b0:	00008067          	ret

00000000800012b4 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800012b4:	ff010113          	addi	sp,sp,-16
    800012b8:	00813423          	sd	s0,8(sp)
    800012bc:	01010413          	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800012c0:	02060663          	beqz	a2,800012ec <strncmp+0x38>
    800012c4:	00054783          	lbu	a5,0(a0)
    800012c8:	02078663          	beqz	a5,800012f4 <strncmp+0x40>
    800012cc:	0005c703          	lbu	a4,0(a1)
    800012d0:	02f71263          	bne	a4,a5,800012f4 <strncmp+0x40>
    n--, p++, q++;
    800012d4:	fff6061b          	addiw	a2,a2,-1
    800012d8:	00150513          	addi	a0,a0,1
    800012dc:	00158593          	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800012e0:	fe0612e3          	bnez	a2,800012c4 <strncmp+0x10>
  if(n == 0)
    return 0;
    800012e4:	00000513          	li	a0,0
    800012e8:	0180006f          	j	80001300 <strncmp+0x4c>
    800012ec:	00000513          	li	a0,0
    800012f0:	0100006f          	j	80001300 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
    800012f4:	00054503          	lbu	a0,0(a0)
    800012f8:	0005c783          	lbu	a5,0(a1)
    800012fc:	40f5053b          	subw	a0,a0,a5
}
    80001300:	00813403          	ld	s0,8(sp)
    80001304:	01010113          	addi	sp,sp,16
    80001308:	00008067          	ret

000000008000130c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000130c:	ff010113          	addi	sp,sp,-16
    80001310:	00813423          	sd	s0,8(sp)
    80001314:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80001318:	00050793          	mv	a5,a0
    8000131c:	00060693          	mv	a3,a2
    80001320:	fff6061b          	addiw	a2,a2,-1
    80001324:	02d05c63          	blez	a3,8000135c <strncpy+0x50>
    80001328:	00178793          	addi	a5,a5,1
    8000132c:	0005c703          	lbu	a4,0(a1)
    80001330:	fee78fa3          	sb	a4,-1(a5)
    80001334:	00158593          	addi	a1,a1,1
    80001338:	fe0712e3          	bnez	a4,8000131c <strncpy+0x10>
    ;
  while(n-- > 0)
    8000133c:	00078713          	mv	a4,a5
    80001340:	00d787bb          	addw	a5,a5,a3
    80001344:	fff7879b          	addiw	a5,a5,-1
    80001348:	00c05a63          	blez	a2,8000135c <strncpy+0x50>
    *s++ = 0;
    8000134c:	00170713          	addi	a4,a4,1
    80001350:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80001354:	40e786bb          	subw	a3,a5,a4
    80001358:	fed04ae3          	bgtz	a3,8000134c <strncpy+0x40>
  return os;
}
    8000135c:	00813403          	ld	s0,8(sp)
    80001360:	01010113          	addi	sp,sp,16
    80001364:	00008067          	ret

0000000080001368 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80001368:	ff010113          	addi	sp,sp,-16
    8000136c:	00813423          	sd	s0,8(sp)
    80001370:	01010413          	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80001374:	02c05a63          	blez	a2,800013a8 <safestrcpy+0x40>
    80001378:	fff6069b          	addiw	a3,a2,-1
    8000137c:	02069693          	slli	a3,a3,0x20
    80001380:	0206d693          	srli	a3,a3,0x20
    80001384:	00d586b3          	add	a3,a1,a3
    80001388:	00050793          	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000138c:	00d58c63          	beq	a1,a3,800013a4 <safestrcpy+0x3c>
    80001390:	00158593          	addi	a1,a1,1
    80001394:	00178793          	addi	a5,a5,1
    80001398:	fff5c703          	lbu	a4,-1(a1)
    8000139c:	fee78fa3          	sb	a4,-1(a5)
    800013a0:	fe0716e3          	bnez	a4,8000138c <safestrcpy+0x24>
    ;
  *s = 0;
    800013a4:	00078023          	sb	zero,0(a5)
  return os;
}
    800013a8:	00813403          	ld	s0,8(sp)
    800013ac:	01010113          	addi	sp,sp,16
    800013b0:	00008067          	ret

00000000800013b4 <strlen>:

int
strlen(const char *s)
{
    800013b4:	ff010113          	addi	sp,sp,-16
    800013b8:	00813423          	sd	s0,8(sp)
    800013bc:	01010413          	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800013c0:	00054783          	lbu	a5,0(a0)
    800013c4:	02078863          	beqz	a5,800013f4 <strlen+0x40>
    800013c8:	00150513          	addi	a0,a0,1
    800013cc:	00050793          	mv	a5,a0
    800013d0:	00078693          	mv	a3,a5
    800013d4:	00178793          	addi	a5,a5,1
    800013d8:	fff7c703          	lbu	a4,-1(a5)
    800013dc:	fe071ae3          	bnez	a4,800013d0 <strlen+0x1c>
    800013e0:	40a6853b          	subw	a0,a3,a0
    800013e4:	0015051b          	addiw	a0,a0,1
    ;
  return n;
}
    800013e8:	00813403          	ld	s0,8(sp)
    800013ec:	01010113          	addi	sp,sp,16
    800013f0:	00008067          	ret
  for(n = 0; s[n]; n++)
    800013f4:	00000513          	li	a0,0
    800013f8:	ff1ff06f          	j	800013e8 <strlen+0x34>

00000000800013fc <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800013fc:	ff010113          	addi	sp,sp,-16
    80001400:	00113423          	sd	ra,8(sp)
    80001404:	00813023          	sd	s0,0(sp)
    80001408:	01010413          	addi	s0,sp,16
  if(cpuid() == 0){
    8000140c:	000010ef          	jal	8000240c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80001410:	00008717          	auipc	a4,0x8
    80001414:	4d870713          	addi	a4,a4,1240 # 800098e8 <started>
  if(cpuid() == 0){
    80001418:	02050c63          	beqz	a0,80001450 <main+0x54>
    while(started == 0)
    8000141c:	00072783          	lw	a5,0(a4)
    80001420:	0007879b          	sext.w	a5,a5
    80001424:	fe078ce3          	beqz	a5,8000141c <main+0x20>
      ;
    __sync_synchronize();
    80001428:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000142c:	7e1000ef          	jal	8000240c <cpuid>
    80001430:	00050593          	mv	a1,a0
    80001434:	00008517          	auipc	a0,0x8
    80001438:	c6450513          	addi	a0,a0,-924 # 80009098 <etext+0x98>
    8000143c:	a20ff0ef          	jal	8000065c <printf>
    kvminithart();    // turn on paging
    80001440:	084000ef          	jal	800014c4 <kvminithart>
    trapinithart();   // install kernel trap vector
    80001444:	010020ef          	jal	80003454 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80001448:	304060ef          	jal	8000774c <plicinithart>
  }

  scheduler();        
    8000144c:	650010ef          	jal	80002a9c <scheduler>
    consoleinit();
    80001450:	8e8ff0ef          	jal	80000538 <consoleinit>
    printfinit();
    80001454:	df8ff0ef          	jal	80000a4c <printfinit>
    printf("\n");
    80001458:	00008517          	auipc	a0,0x8
    8000145c:	c2050513          	addi	a0,a0,-992 # 80009078 <etext+0x78>
    80001460:	9fcff0ef          	jal	8000065c <printf>
    printf("xv6 kernel is booting\n");
    80001464:	00008517          	auipc	a0,0x8
    80001468:	c1c50513          	addi	a0,a0,-996 # 80009080 <etext+0x80>
    8000146c:	9f0ff0ef          	jal	8000065c <printf>
    printf("\n");
    80001470:	00008517          	auipc	a0,0x8
    80001474:	c0850513          	addi	a0,a0,-1016 # 80009078 <etext+0x78>
    80001478:	9e4ff0ef          	jal	8000065c <printf>
    kinit();         // physical page allocator
    8000147c:	a39ff0ef          	jal	80000eb4 <kinit>
    kvminit();       // create kernel page table
    80001480:	428000ef          	jal	800018a8 <kvminit>
    kvminithart();   // turn on paging
    80001484:	040000ef          	jal	800014c4 <kvminithart>
    procinit();      // process table
    80001488:	691000ef          	jal	80002318 <procinit>
    trapinit();      // trap vectors
    8000148c:	795010ef          	jal	80003420 <trapinit>
    trapinithart();  // install kernel trap vector
    80001490:	7c5010ef          	jal	80003454 <trapinithart>
    plicinit();      // set up interrupt controller
    80001494:	28c060ef          	jal	80007720 <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001498:	2b4060ef          	jal	8000774c <plicinithart>
    binit();         // buffer cache
    8000149c:	0fd020ef          	jal	80003d98 <binit>
    iinit();         // inode table
    800014a0:	144030ef          	jal	800045e4 <iinit>
    fileinit();      // file table
    800014a4:	56c040ef          	jal	80005a10 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800014a8:	3f8060ef          	jal	800078a0 <virtio_disk_init>
    userinit();      // first user process
    800014ac:	364010ef          	jal	80002810 <userinit>
    __sync_synchronize();
    800014b0:	0ff0000f          	fence
    started = 1;
    800014b4:	00100793          	li	a5,1
    800014b8:	00008717          	auipc	a4,0x8
    800014bc:	42f72823          	sw	a5,1072(a4) # 800098e8 <started>
    800014c0:	f8dff06f          	j	8000144c <main+0x50>

00000000800014c4 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800014c4:	ff010113          	addi	sp,sp,-16
    800014c8:	00813423          	sd	s0,8(sp)
    800014cc:	01010413          	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800014d0:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800014d4:	00008797          	auipc	a5,0x8
    800014d8:	41c7b783          	ld	a5,1052(a5) # 800098f0 <kernel_pagetable>
    800014dc:	00c7d793          	srli	a5,a5,0xc
    800014e0:	fff00713          	li	a4,-1
    800014e4:	03f71713          	slli	a4,a4,0x3f
    800014e8:	00e7e7b3          	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800014ec:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800014f0:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800014f4:	00813403          	ld	s0,8(sp)
    800014f8:	01010113          	addi	sp,sp,16
    800014fc:	00008067          	ret

0000000080001500 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001500:	fc010113          	addi	sp,sp,-64
    80001504:	02113c23          	sd	ra,56(sp)
    80001508:	02813823          	sd	s0,48(sp)
    8000150c:	02913423          	sd	s1,40(sp)
    80001510:	03213023          	sd	s2,32(sp)
    80001514:	01313c23          	sd	s3,24(sp)
    80001518:	01413823          	sd	s4,16(sp)
    8000151c:	01513423          	sd	s5,8(sp)
    80001520:	01613023          	sd	s6,0(sp)
    80001524:	04010413          	addi	s0,sp,64
    80001528:	00050493          	mv	s1,a0
    8000152c:	00058993          	mv	s3,a1
    80001530:	00060a93          	mv	s5,a2
  if(va >= MAXVA)
    80001534:	fff00793          	li	a5,-1
    80001538:	01a7d793          	srli	a5,a5,0x1a
    8000153c:	01e00a13          	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001540:	00c00b13          	li	s6,12
  if(va >= MAXVA)
    80001544:	04b7f263          	bgeu	a5,a1,80001588 <walk+0x88>
    panic("walk");
    80001548:	00008517          	auipc	a0,0x8
    8000154c:	b6850513          	addi	a0,a0,-1176 # 800090b0 <etext+0xb0>
    80001550:	cb0ff0ef          	jal	80000a00 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001554:	080a8a63          	beqz	s5,800015e8 <walk+0xe8>
    80001558:	9a5ff0ef          	jal	80000efc <kalloc>
    8000155c:	00050493          	mv	s1,a0
    80001560:	06050063          	beqz	a0,800015c0 <walk+0xc0>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001564:	00001637          	lui	a2,0x1
    80001568:	00000593          	li	a1,0
    8000156c:	c0dff0ef          	jal	80001178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001570:	00c4d793          	srli	a5,s1,0xc
    80001574:	00a79793          	slli	a5,a5,0xa
    80001578:	0017e793          	ori	a5,a5,1
    8000157c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001580:	ff7a0a1b          	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdc3b7>
    80001584:	036a0663          	beq	s4,s6,800015b0 <walk+0xb0>
    pte_t *pte = &pagetable[PX(level, va)];
    80001588:	0149d933          	srl	s2,s3,s4
    8000158c:	1ff97913          	andi	s2,s2,511
    80001590:	00391913          	slli	s2,s2,0x3
    80001594:	01248933          	add	s2,s1,s2
    if(*pte & PTE_V) {
    80001598:	00093483          	ld	s1,0(s2)
    8000159c:	0014f793          	andi	a5,s1,1
    800015a0:	fa078ae3          	beqz	a5,80001554 <walk+0x54>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800015a4:	00a4d493          	srli	s1,s1,0xa
    800015a8:	00c49493          	slli	s1,s1,0xc
    800015ac:	fd5ff06f          	j	80001580 <walk+0x80>
    }
  }
  return &pagetable[PX(0, va)];
    800015b0:	00c9d513          	srli	a0,s3,0xc
    800015b4:	1ff57513          	andi	a0,a0,511
    800015b8:	00351513          	slli	a0,a0,0x3
    800015bc:	00a48533          	add	a0,s1,a0
}
    800015c0:	03813083          	ld	ra,56(sp)
    800015c4:	03013403          	ld	s0,48(sp)
    800015c8:	02813483          	ld	s1,40(sp)
    800015cc:	02013903          	ld	s2,32(sp)
    800015d0:	01813983          	ld	s3,24(sp)
    800015d4:	01013a03          	ld	s4,16(sp)
    800015d8:	00813a83          	ld	s5,8(sp)
    800015dc:	00013b03          	ld	s6,0(sp)
    800015e0:	04010113          	addi	sp,sp,64
    800015e4:	00008067          	ret
        return 0;
    800015e8:	00000513          	li	a0,0
    800015ec:	fd5ff06f          	j	800015c0 <walk+0xc0>

00000000800015f0 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800015f0:	fff00793          	li	a5,-1
    800015f4:	01a7d793          	srli	a5,a5,0x1a
    800015f8:	00b7f663          	bgeu	a5,a1,80001604 <walkaddr+0x14>
    return 0;
    800015fc:	00000513          	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001600:	00008067          	ret
{
    80001604:	ff010113          	addi	sp,sp,-16
    80001608:	00113423          	sd	ra,8(sp)
    8000160c:	00813023          	sd	s0,0(sp)
    80001610:	01010413          	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001614:	00000613          	li	a2,0
    80001618:	ee9ff0ef          	jal	80001500 <walk>
  if(pte == 0)
    8000161c:	02050a63          	beqz	a0,80001650 <walkaddr+0x60>
  if((*pte & PTE_V) == 0)
    80001620:	00053783          	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001624:	0117f693          	andi	a3,a5,17
    80001628:	01100713          	li	a4,17
    return 0;
    8000162c:	00000513          	li	a0,0
  if((*pte & PTE_U) == 0)
    80001630:	00e68a63          	beq	a3,a4,80001644 <walkaddr+0x54>
}
    80001634:	00813083          	ld	ra,8(sp)
    80001638:	00013403          	ld	s0,0(sp)
    8000163c:	01010113          	addi	sp,sp,16
    80001640:	00008067          	ret
  pa = PTE2PA(*pte);
    80001644:	00a7d793          	srli	a5,a5,0xa
    80001648:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000164c:	fe9ff06f          	j	80001634 <walkaddr+0x44>
    return 0;
    80001650:	00000513          	li	a0,0
    80001654:	fe1ff06f          	j	80001634 <walkaddr+0x44>

0000000080001658 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001658:	fb010113          	addi	sp,sp,-80
    8000165c:	04113423          	sd	ra,72(sp)
    80001660:	04813023          	sd	s0,64(sp)
    80001664:	02913c23          	sd	s1,56(sp)
    80001668:	03213823          	sd	s2,48(sp)
    8000166c:	03313423          	sd	s3,40(sp)
    80001670:	03413023          	sd	s4,32(sp)
    80001674:	01513c23          	sd	s5,24(sp)
    80001678:	01613823          	sd	s6,16(sp)
    8000167c:	01713423          	sd	s7,8(sp)
    80001680:	05010413          	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001684:	03459793          	slli	a5,a1,0x34
    80001688:	06079a63          	bnez	a5,800016fc <mappages+0xa4>
    8000168c:	00050a93          	mv	s5,a0
    80001690:	00070b13          	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001694:	03461793          	slli	a5,a2,0x34
    80001698:	06079863          	bnez	a5,80001708 <mappages+0xb0>
    panic("mappages: size not aligned");

  if(size == 0)
    8000169c:	06060c63          	beqz	a2,80001714 <mappages+0xbc>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800016a0:	fffff7b7          	lui	a5,0xfffff
    800016a4:	00f60633          	add	a2,a2,a5
    800016a8:	00b609b3          	add	s3,a2,a1
  a = va;
    800016ac:	00058913          	mv	s2,a1
    800016b0:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800016b4:	00001bb7          	lui	s7,0x1
    800016b8:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800016bc:	00100613          	li	a2,1
    800016c0:	00090593          	mv	a1,s2
    800016c4:	000a8513          	mv	a0,s5
    800016c8:	e39ff0ef          	jal	80001500 <walk>
    800016cc:	06050063          	beqz	a0,8000172c <mappages+0xd4>
    if(*pte & PTE_V)
    800016d0:	00053783          	ld	a5,0(a0)
    800016d4:	0017f793          	andi	a5,a5,1
    800016d8:	04079463          	bnez	a5,80001720 <mappages+0xc8>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800016dc:	00c4d493          	srli	s1,s1,0xc
    800016e0:	00a49493          	slli	s1,s1,0xa
    800016e4:	0164e4b3          	or	s1,s1,s6
    800016e8:	0014e493          	ori	s1,s1,1
    800016ec:	00953023          	sd	s1,0(a0)
    if(a == last)
    800016f0:	07390663          	beq	s2,s3,8000175c <mappages+0x104>
    a += PGSIZE;
    800016f4:	01790933          	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800016f8:	fc1ff06f          	j	800016b8 <mappages+0x60>
    panic("mappages: va not aligned");
    800016fc:	00008517          	auipc	a0,0x8
    80001700:	9bc50513          	addi	a0,a0,-1604 # 800090b8 <etext+0xb8>
    80001704:	afcff0ef          	jal	80000a00 <panic>
    panic("mappages: size not aligned");
    80001708:	00008517          	auipc	a0,0x8
    8000170c:	9d050513          	addi	a0,a0,-1584 # 800090d8 <etext+0xd8>
    80001710:	af0ff0ef          	jal	80000a00 <panic>
    panic("mappages: size");
    80001714:	00008517          	auipc	a0,0x8
    80001718:	9e450513          	addi	a0,a0,-1564 # 800090f8 <etext+0xf8>
    8000171c:	ae4ff0ef          	jal	80000a00 <panic>
      panic("mappages: remap");
    80001720:	00008517          	auipc	a0,0x8
    80001724:	9e850513          	addi	a0,a0,-1560 # 80009108 <etext+0x108>
    80001728:	ad8ff0ef          	jal	80000a00 <panic>
      return -1;
    8000172c:	fff00513          	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001730:	04813083          	ld	ra,72(sp)
    80001734:	04013403          	ld	s0,64(sp)
    80001738:	03813483          	ld	s1,56(sp)
    8000173c:	03013903          	ld	s2,48(sp)
    80001740:	02813983          	ld	s3,40(sp)
    80001744:	02013a03          	ld	s4,32(sp)
    80001748:	01813a83          	ld	s5,24(sp)
    8000174c:	01013b03          	ld	s6,16(sp)
    80001750:	00813b83          	ld	s7,8(sp)
    80001754:	05010113          	addi	sp,sp,80
    80001758:	00008067          	ret
  return 0;
    8000175c:	00000513          	li	a0,0
    80001760:	fd1ff06f          	j	80001730 <mappages+0xd8>

0000000080001764 <kvmmap>:
{
    80001764:	ff010113          	addi	sp,sp,-16
    80001768:	00113423          	sd	ra,8(sp)
    8000176c:	00813023          	sd	s0,0(sp)
    80001770:	01010413          	addi	s0,sp,16
    80001774:	00068793          	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001778:	00060693          	mv	a3,a2
    8000177c:	00078613          	mv	a2,a5
    80001780:	ed9ff0ef          	jal	80001658 <mappages>
    80001784:	00051a63          	bnez	a0,80001798 <kvmmap+0x34>
}
    80001788:	00813083          	ld	ra,8(sp)
    8000178c:	00013403          	ld	s0,0(sp)
    80001790:	01010113          	addi	sp,sp,16
    80001794:	00008067          	ret
    panic("kvmmap");
    80001798:	00008517          	auipc	a0,0x8
    8000179c:	98050513          	addi	a0,a0,-1664 # 80009118 <etext+0x118>
    800017a0:	a60ff0ef          	jal	80000a00 <panic>

00000000800017a4 <kvmmake>:
{
    800017a4:	fe010113          	addi	sp,sp,-32
    800017a8:	00113c23          	sd	ra,24(sp)
    800017ac:	00813823          	sd	s0,16(sp)
    800017b0:	00913423          	sd	s1,8(sp)
    800017b4:	01213023          	sd	s2,0(sp)
    800017b8:	02010413          	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800017bc:	f40ff0ef          	jal	80000efc <kalloc>
    800017c0:	00050493          	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800017c4:	00001637          	lui	a2,0x1
    800017c8:	00000593          	li	a1,0
    800017cc:	9adff0ef          	jal	80001178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800017d0:	00600713          	li	a4,6
    800017d4:	000016b7          	lui	a3,0x1
    800017d8:	10000637          	lui	a2,0x10000
    800017dc:	100005b7          	lui	a1,0x10000
    800017e0:	00048513          	mv	a0,s1
    800017e4:	f81ff0ef          	jal	80001764 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800017e8:	00600713          	li	a4,6
    800017ec:	000016b7          	lui	a3,0x1
    800017f0:	10001637          	lui	a2,0x10001
    800017f4:	100015b7          	lui	a1,0x10001
    800017f8:	00048513          	mv	a0,s1
    800017fc:	f69ff0ef          	jal	80001764 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001800:	00600713          	li	a4,6
    80001804:	040006b7          	lui	a3,0x4000
    80001808:	0c000637          	lui	a2,0xc000
    8000180c:	0c0005b7          	lui	a1,0xc000
    80001810:	00048513          	mv	a0,s1
    80001814:	f51ff0ef          	jal	80001764 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001818:	00007917          	auipc	s2,0x7
    8000181c:	7e890913          	addi	s2,s2,2024 # 80009000 <etext>
    80001820:	00a00713          	li	a4,10
    80001824:	80007697          	auipc	a3,0x80007
    80001828:	7dc68693          	addi	a3,a3,2012 # 9000 <_entry-0x7fff7000>
    8000182c:	00100613          	li	a2,1
    80001830:	01f61613          	slli	a2,a2,0x1f
    80001834:	00060593          	mv	a1,a2
    80001838:	00048513          	mv	a0,s1
    8000183c:	f29ff0ef          	jal	80001764 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001840:	01100693          	li	a3,17
    80001844:	01b69693          	slli	a3,a3,0x1b
    80001848:	00600713          	li	a4,6
    8000184c:	412686b3          	sub	a3,a3,s2
    80001850:	00090613          	mv	a2,s2
    80001854:	00090593          	mv	a1,s2
    80001858:	00048513          	mv	a0,s1
    8000185c:	f09ff0ef          	jal	80001764 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001860:	00a00713          	li	a4,10
    80001864:	000016b7          	lui	a3,0x1
    80001868:	00006617          	auipc	a2,0x6
    8000186c:	79860613          	addi	a2,a2,1944 # 80008000 <_trampoline>
    80001870:	040005b7          	lui	a1,0x4000
    80001874:	fff58593          	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001878:	00c59593          	slli	a1,a1,0xc
    8000187c:	00048513          	mv	a0,s1
    80001880:	ee5ff0ef          	jal	80001764 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001884:	00048513          	mv	a0,s1
    80001888:	1b5000ef          	jal	8000223c <proc_mapstacks>
}
    8000188c:	00048513          	mv	a0,s1
    80001890:	01813083          	ld	ra,24(sp)
    80001894:	01013403          	ld	s0,16(sp)
    80001898:	00813483          	ld	s1,8(sp)
    8000189c:	00013903          	ld	s2,0(sp)
    800018a0:	02010113          	addi	sp,sp,32
    800018a4:	00008067          	ret

00000000800018a8 <kvminit>:
{
    800018a8:	ff010113          	addi	sp,sp,-16
    800018ac:	00113423          	sd	ra,8(sp)
    800018b0:	00813023          	sd	s0,0(sp)
    800018b4:	01010413          	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800018b8:	eedff0ef          	jal	800017a4 <kvmmake>
    800018bc:	00008797          	auipc	a5,0x8
    800018c0:	02a7ba23          	sd	a0,52(a5) # 800098f0 <kernel_pagetable>
}
    800018c4:	00813083          	ld	ra,8(sp)
    800018c8:	00013403          	ld	s0,0(sp)
    800018cc:	01010113          	addi	sp,sp,16
    800018d0:	00008067          	ret

00000000800018d4 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800018d4:	fb010113          	addi	sp,sp,-80
    800018d8:	04113423          	sd	ra,72(sp)
    800018dc:	04813023          	sd	s0,64(sp)
    800018e0:	05010413          	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800018e4:	03459793          	slli	a5,a1,0x34
    800018e8:	04079263          	bnez	a5,8000192c <uvmunmap+0x58>
    800018ec:	03213823          	sd	s2,48(sp)
    800018f0:	03313423          	sd	s3,40(sp)
    800018f4:	03413023          	sd	s4,32(sp)
    800018f8:	01513c23          	sd	s5,24(sp)
    800018fc:	01613823          	sd	s6,16(sp)
    80001900:	01713423          	sd	s7,8(sp)
    80001904:	00050a13          	mv	s4,a0
    80001908:	00058913          	mv	s2,a1
    8000190c:	00068a93          	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001910:	00c61613          	slli	a2,a2,0xc
    80001914:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001918:	00100b93          	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000191c:	00001b37          	lui	s6,0x1
    80001920:	0b35f463          	bgeu	a1,s3,800019c8 <uvmunmap+0xf4>
    80001924:	02913c23          	sd	s1,56(sp)
    80001928:	05c0006f          	j	80001984 <uvmunmap+0xb0>
    8000192c:	02913c23          	sd	s1,56(sp)
    80001930:	03213823          	sd	s2,48(sp)
    80001934:	03313423          	sd	s3,40(sp)
    80001938:	03413023          	sd	s4,32(sp)
    8000193c:	01513c23          	sd	s5,24(sp)
    80001940:	01613823          	sd	s6,16(sp)
    80001944:	01713423          	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001948:	00007517          	auipc	a0,0x7
    8000194c:	7d850513          	addi	a0,a0,2008 # 80009120 <etext+0x120>
    80001950:	8b0ff0ef          	jal	80000a00 <panic>
      panic("uvmunmap: walk");
    80001954:	00007517          	auipc	a0,0x7
    80001958:	7e450513          	addi	a0,a0,2020 # 80009138 <etext+0x138>
    8000195c:	8a4ff0ef          	jal	80000a00 <panic>
      panic("uvmunmap: not mapped");
    80001960:	00007517          	auipc	a0,0x7
    80001964:	7e850513          	addi	a0,a0,2024 # 80009148 <etext+0x148>
    80001968:	898ff0ef          	jal	80000a00 <panic>
      panic("uvmunmap: not a leaf");
    8000196c:	00007517          	auipc	a0,0x7
    80001970:	7f450513          	addi	a0,a0,2036 # 80009160 <etext+0x160>
    80001974:	88cff0ef          	jal	80000a00 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001978:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000197c:	01690933          	add	s2,s2,s6
    80001980:	05397263          	bgeu	s2,s3,800019c4 <uvmunmap+0xf0>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001984:	00000613          	li	a2,0
    80001988:	00090593          	mv	a1,s2
    8000198c:	000a0513          	mv	a0,s4
    80001990:	b71ff0ef          	jal	80001500 <walk>
    80001994:	00050493          	mv	s1,a0
    80001998:	fa050ee3          	beqz	a0,80001954 <uvmunmap+0x80>
    if((*pte & PTE_V) == 0)
    8000199c:	00053503          	ld	a0,0(a0)
    800019a0:	00157793          	andi	a5,a0,1
    800019a4:	fa078ee3          	beqz	a5,80001960 <uvmunmap+0x8c>
    if(PTE_FLAGS(*pte) == PTE_V)
    800019a8:	3ff57793          	andi	a5,a0,1023
    800019ac:	fd7780e3          	beq	a5,s7,8000196c <uvmunmap+0x98>
    if(do_free){
    800019b0:	fc0a84e3          	beqz	s5,80001978 <uvmunmap+0xa4>
      uint64 pa = PTE2PA(*pte);
    800019b4:	00a55513          	srli	a0,a0,0xa
      kfree((void*)pa);
    800019b8:	00c51513          	slli	a0,a0,0xc
    800019bc:	bf0ff0ef          	jal	80000dac <kfree>
    800019c0:	fb9ff06f          	j	80001978 <uvmunmap+0xa4>
    800019c4:	03813483          	ld	s1,56(sp)
    800019c8:	03013903          	ld	s2,48(sp)
    800019cc:	02813983          	ld	s3,40(sp)
    800019d0:	02013a03          	ld	s4,32(sp)
    800019d4:	01813a83          	ld	s5,24(sp)
    800019d8:	01013b03          	ld	s6,16(sp)
    800019dc:	00813b83          	ld	s7,8(sp)
  }
}
    800019e0:	04813083          	ld	ra,72(sp)
    800019e4:	04013403          	ld	s0,64(sp)
    800019e8:	05010113          	addi	sp,sp,80
    800019ec:	00008067          	ret

00000000800019f0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800019f0:	fe010113          	addi	sp,sp,-32
    800019f4:	00113c23          	sd	ra,24(sp)
    800019f8:	00813823          	sd	s0,16(sp)
    800019fc:	00913423          	sd	s1,8(sp)
    80001a00:	02010413          	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001a04:	cf8ff0ef          	jal	80000efc <kalloc>
    80001a08:	00050493          	mv	s1,a0
  if(pagetable == 0)
    80001a0c:	00050863          	beqz	a0,80001a1c <uvmcreate+0x2c>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001a10:	00001637          	lui	a2,0x1
    80001a14:	00000593          	li	a1,0
    80001a18:	f60ff0ef          	jal	80001178 <memset>
  return pagetable;
}
    80001a1c:	00048513          	mv	a0,s1
    80001a20:	01813083          	ld	ra,24(sp)
    80001a24:	01013403          	ld	s0,16(sp)
    80001a28:	00813483          	ld	s1,8(sp)
    80001a2c:	02010113          	addi	sp,sp,32
    80001a30:	00008067          	ret

0000000080001a34 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001a34:	fd010113          	addi	sp,sp,-48
    80001a38:	02113423          	sd	ra,40(sp)
    80001a3c:	02813023          	sd	s0,32(sp)
    80001a40:	00913c23          	sd	s1,24(sp)
    80001a44:	01213823          	sd	s2,16(sp)
    80001a48:	01313423          	sd	s3,8(sp)
    80001a4c:	01413023          	sd	s4,0(sp)
    80001a50:	03010413          	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001a54:	000017b7          	lui	a5,0x1
    80001a58:	06f67663          	bgeu	a2,a5,80001ac4 <uvmfirst+0x90>
    80001a5c:	00050a13          	mv	s4,a0
    80001a60:	00058993          	mv	s3,a1
    80001a64:	00060493          	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001a68:	c94ff0ef          	jal	80000efc <kalloc>
    80001a6c:	00050913          	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001a70:	00001637          	lui	a2,0x1
    80001a74:	00000593          	li	a1,0
    80001a78:	f00ff0ef          	jal	80001178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001a7c:	01e00713          	li	a4,30
    80001a80:	00090693          	mv	a3,s2
    80001a84:	00001637          	lui	a2,0x1
    80001a88:	00000593          	li	a1,0
    80001a8c:	000a0513          	mv	a0,s4
    80001a90:	bc9ff0ef          	jal	80001658 <mappages>
  memmove(mem, src, sz);
    80001a94:	00048613          	mv	a2,s1
    80001a98:	00098593          	mv	a1,s3
    80001a9c:	00090513          	mv	a0,s2
    80001aa0:	f6cff0ef          	jal	8000120c <memmove>
}
    80001aa4:	02813083          	ld	ra,40(sp)
    80001aa8:	02013403          	ld	s0,32(sp)
    80001aac:	01813483          	ld	s1,24(sp)
    80001ab0:	01013903          	ld	s2,16(sp)
    80001ab4:	00813983          	ld	s3,8(sp)
    80001ab8:	00013a03          	ld	s4,0(sp)
    80001abc:	03010113          	addi	sp,sp,48
    80001ac0:	00008067          	ret
    panic("uvmfirst: more than a page");
    80001ac4:	00007517          	auipc	a0,0x7
    80001ac8:	6b450513          	addi	a0,a0,1716 # 80009178 <etext+0x178>
    80001acc:	f35fe0ef          	jal	80000a00 <panic>

0000000080001ad0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001ad0:	fe010113          	addi	sp,sp,-32
    80001ad4:	00113c23          	sd	ra,24(sp)
    80001ad8:	00813823          	sd	s0,16(sp)
    80001adc:	00913423          	sd	s1,8(sp)
    80001ae0:	02010413          	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001ae4:	00058493          	mv	s1,a1
  if(newsz >= oldsz)
    80001ae8:	02b67463          	bgeu	a2,a1,80001b10 <uvmdealloc+0x40>
    80001aec:	00060493          	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001af0:	000017b7          	lui	a5,0x1
    80001af4:	fff78793          	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001af8:	00f60733          	add	a4,a2,a5
    80001afc:	fffff6b7          	lui	a3,0xfffff
    80001b00:	00d77733          	and	a4,a4,a3
    80001b04:	00f587b3          	add	a5,a1,a5
    80001b08:	00d7f7b3          	and	a5,a5,a3
    80001b0c:	00f76e63          	bltu	a4,a5,80001b28 <uvmdealloc+0x58>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001b10:	00048513          	mv	a0,s1
    80001b14:	01813083          	ld	ra,24(sp)
    80001b18:	01013403          	ld	s0,16(sp)
    80001b1c:	00813483          	ld	s1,8(sp)
    80001b20:	02010113          	addi	sp,sp,32
    80001b24:	00008067          	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001b28:	40e787b3          	sub	a5,a5,a4
    80001b2c:	00c7d793          	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001b30:	00100693          	li	a3,1
    80001b34:	0007861b          	sext.w	a2,a5
    80001b38:	00070593          	mv	a1,a4
    80001b3c:	d99ff0ef          	jal	800018d4 <uvmunmap>
    80001b40:	fd1ff06f          	j	80001b10 <uvmdealloc+0x40>

0000000080001b44 <uvmalloc>:
  if(newsz < oldsz)
    80001b44:	10b66863          	bltu	a2,a1,80001c54 <uvmalloc+0x110>
{
    80001b48:	fc010113          	addi	sp,sp,-64
    80001b4c:	02113c23          	sd	ra,56(sp)
    80001b50:	02813823          	sd	s0,48(sp)
    80001b54:	01313c23          	sd	s3,24(sp)
    80001b58:	01413823          	sd	s4,16(sp)
    80001b5c:	01513423          	sd	s5,8(sp)
    80001b60:	04010413          	addi	s0,sp,64
    80001b64:	00050a93          	mv	s5,a0
    80001b68:	00060a13          	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001b6c:	000017b7          	lui	a5,0x1
    80001b70:	fff78793          	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001b74:	00f585b3          	add	a1,a1,a5
    80001b78:	fffff7b7          	lui	a5,0xfffff
    80001b7c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001b80:	0cc9fe63          	bgeu	s3,a2,80001c5c <uvmalloc+0x118>
    80001b84:	02913423          	sd	s1,40(sp)
    80001b88:	03213023          	sd	s2,32(sp)
    80001b8c:	01613023          	sd	s6,0(sp)
    80001b90:	00098913          	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001b94:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001b98:	b64ff0ef          	jal	80000efc <kalloc>
    80001b9c:	00050493          	mv	s1,a0
    if(mem == 0){
    80001ba0:	04050663          	beqz	a0,80001bec <uvmalloc+0xa8>
    memset(mem, 0, PGSIZE);
    80001ba4:	00001637          	lui	a2,0x1
    80001ba8:	00000593          	li	a1,0
    80001bac:	dccff0ef          	jal	80001178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001bb0:	000b0713          	mv	a4,s6
    80001bb4:	00048693          	mv	a3,s1
    80001bb8:	00001637          	lui	a2,0x1
    80001bbc:	00090593          	mv	a1,s2
    80001bc0:	000a8513          	mv	a0,s5
    80001bc4:	a95ff0ef          	jal	80001658 <mappages>
    80001bc8:	06051063          	bnez	a0,80001c28 <uvmalloc+0xe4>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001bcc:	000017b7          	lui	a5,0x1
    80001bd0:	00f90933          	add	s2,s2,a5
    80001bd4:	fd4962e3          	bltu	s2,s4,80001b98 <uvmalloc+0x54>
  return newsz;
    80001bd8:	000a0513          	mv	a0,s4
    80001bdc:	02813483          	ld	s1,40(sp)
    80001be0:	02013903          	ld	s2,32(sp)
    80001be4:	00013b03          	ld	s6,0(sp)
    80001be8:	0240006f          	j	80001c0c <uvmalloc+0xc8>
      uvmdealloc(pagetable, a, oldsz);
    80001bec:	00098613          	mv	a2,s3
    80001bf0:	00090593          	mv	a1,s2
    80001bf4:	000a8513          	mv	a0,s5
    80001bf8:	ed9ff0ef          	jal	80001ad0 <uvmdealloc>
      return 0;
    80001bfc:	00000513          	li	a0,0
    80001c00:	02813483          	ld	s1,40(sp)
    80001c04:	02013903          	ld	s2,32(sp)
    80001c08:	00013b03          	ld	s6,0(sp)
}
    80001c0c:	03813083          	ld	ra,56(sp)
    80001c10:	03013403          	ld	s0,48(sp)
    80001c14:	01813983          	ld	s3,24(sp)
    80001c18:	01013a03          	ld	s4,16(sp)
    80001c1c:	00813a83          	ld	s5,8(sp)
    80001c20:	04010113          	addi	sp,sp,64
    80001c24:	00008067          	ret
      kfree(mem);
    80001c28:	00048513          	mv	a0,s1
    80001c2c:	980ff0ef          	jal	80000dac <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001c30:	00098613          	mv	a2,s3
    80001c34:	00090593          	mv	a1,s2
    80001c38:	000a8513          	mv	a0,s5
    80001c3c:	e95ff0ef          	jal	80001ad0 <uvmdealloc>
      return 0;
    80001c40:	00000513          	li	a0,0
    80001c44:	02813483          	ld	s1,40(sp)
    80001c48:	02013903          	ld	s2,32(sp)
    80001c4c:	00013b03          	ld	s6,0(sp)
    80001c50:	fbdff06f          	j	80001c0c <uvmalloc+0xc8>
    return oldsz;
    80001c54:	00058513          	mv	a0,a1
}
    80001c58:	00008067          	ret
  return newsz;
    80001c5c:	00060513          	mv	a0,a2
    80001c60:	fadff06f          	j	80001c0c <uvmalloc+0xc8>

0000000080001c64 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001c64:	fd010113          	addi	sp,sp,-48
    80001c68:	02113423          	sd	ra,40(sp)
    80001c6c:	02813023          	sd	s0,32(sp)
    80001c70:	00913c23          	sd	s1,24(sp)
    80001c74:	01213823          	sd	s2,16(sp)
    80001c78:	01313423          	sd	s3,8(sp)
    80001c7c:	01413023          	sd	s4,0(sp)
    80001c80:	03010413          	addi	s0,sp,48
    80001c84:	00050a13          	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001c88:	00050493          	mv	s1,a0
    80001c8c:	00001937          	lui	s2,0x1
    80001c90:	01250933          	add	s2,a0,s2
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001c94:	00100993          	li	s3,1
    80001c98:	01c0006f          	j	80001cb4 <freewalk+0x50>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001c9c:	00a7d793          	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001ca0:	00c79513          	slli	a0,a5,0xc
    80001ca4:	fc1ff0ef          	jal	80001c64 <freewalk>
      pagetable[i] = 0;
    80001ca8:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001cac:	00848493          	addi	s1,s1,8
    80001cb0:	03248263          	beq	s1,s2,80001cd4 <freewalk+0x70>
    pte_t pte = pagetable[i];
    80001cb4:	0004b783          	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001cb8:	00f7f713          	andi	a4,a5,15
    80001cbc:	ff3700e3          	beq	a4,s3,80001c9c <freewalk+0x38>
    } else if(pte & PTE_V){
    80001cc0:	0017f793          	andi	a5,a5,1
    80001cc4:	fe0784e3          	beqz	a5,80001cac <freewalk+0x48>
      panic("freewalk: leaf");
    80001cc8:	00007517          	auipc	a0,0x7
    80001ccc:	4d050513          	addi	a0,a0,1232 # 80009198 <etext+0x198>
    80001cd0:	d31fe0ef          	jal	80000a00 <panic>
    }
  }
  kfree((void*)pagetable);
    80001cd4:	000a0513          	mv	a0,s4
    80001cd8:	8d4ff0ef          	jal	80000dac <kfree>
}
    80001cdc:	02813083          	ld	ra,40(sp)
    80001ce0:	02013403          	ld	s0,32(sp)
    80001ce4:	01813483          	ld	s1,24(sp)
    80001ce8:	01013903          	ld	s2,16(sp)
    80001cec:	00813983          	ld	s3,8(sp)
    80001cf0:	00013a03          	ld	s4,0(sp)
    80001cf4:	03010113          	addi	sp,sp,48
    80001cf8:	00008067          	ret

0000000080001cfc <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001cfc:	fe010113          	addi	sp,sp,-32
    80001d00:	00113c23          	sd	ra,24(sp)
    80001d04:	00813823          	sd	s0,16(sp)
    80001d08:	00913423          	sd	s1,8(sp)
    80001d0c:	02010413          	addi	s0,sp,32
    80001d10:	00050493          	mv	s1,a0
  if(sz > 0)
    80001d14:	02059063          	bnez	a1,80001d34 <uvmfree+0x38>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001d18:	00048513          	mv	a0,s1
    80001d1c:	f49ff0ef          	jal	80001c64 <freewalk>
}
    80001d20:	01813083          	ld	ra,24(sp)
    80001d24:	01013403          	ld	s0,16(sp)
    80001d28:	00813483          	ld	s1,8(sp)
    80001d2c:	02010113          	addi	sp,sp,32
    80001d30:	00008067          	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001d34:	000017b7          	lui	a5,0x1
    80001d38:	fff78793          	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001d3c:	00f585b3          	add	a1,a1,a5
    80001d40:	00100693          	li	a3,1
    80001d44:	00c5d613          	srli	a2,a1,0xc
    80001d48:	00000593          	li	a1,0
    80001d4c:	b89ff0ef          	jal	800018d4 <uvmunmap>
    80001d50:	fc9ff06f          	j	80001d18 <uvmfree+0x1c>

0000000080001d54 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001d54:	10060a63          	beqz	a2,80001e68 <uvmcopy+0x114>
{
    80001d58:	fb010113          	addi	sp,sp,-80
    80001d5c:	04113423          	sd	ra,72(sp)
    80001d60:	04813023          	sd	s0,64(sp)
    80001d64:	02913c23          	sd	s1,56(sp)
    80001d68:	03213823          	sd	s2,48(sp)
    80001d6c:	03313423          	sd	s3,40(sp)
    80001d70:	03413023          	sd	s4,32(sp)
    80001d74:	01513c23          	sd	s5,24(sp)
    80001d78:	01613823          	sd	s6,16(sp)
    80001d7c:	01713423          	sd	s7,8(sp)
    80001d80:	05010413          	addi	s0,sp,80
    80001d84:	00050b13          	mv	s6,a0
    80001d88:	00058a93          	mv	s5,a1
    80001d8c:	00060a13          	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001d90:	00000993          	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001d94:	00000613          	li	a2,0
    80001d98:	00098593          	mv	a1,s3
    80001d9c:	000b0513          	mv	a0,s6
    80001da0:	f60ff0ef          	jal	80001500 <walk>
    80001da4:	06050063          	beqz	a0,80001e04 <uvmcopy+0xb0>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001da8:	00053703          	ld	a4,0(a0)
    80001dac:	00177793          	andi	a5,a4,1
    80001db0:	06078063          	beqz	a5,80001e10 <uvmcopy+0xbc>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001db4:	00a75593          	srli	a1,a4,0xa
    80001db8:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001dbc:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001dc0:	93cff0ef          	jal	80000efc <kalloc>
    80001dc4:	00050913          	mv	s2,a0
    80001dc8:	04050e63          	beqz	a0,80001e24 <uvmcopy+0xd0>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001dcc:	00001637          	lui	a2,0x1
    80001dd0:	000b8593          	mv	a1,s7
    80001dd4:	c38ff0ef          	jal	8000120c <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001dd8:	00048713          	mv	a4,s1
    80001ddc:	00090693          	mv	a3,s2
    80001de0:	00001637          	lui	a2,0x1
    80001de4:	00098593          	mv	a1,s3
    80001de8:	000a8513          	mv	a0,s5
    80001dec:	86dff0ef          	jal	80001658 <mappages>
    80001df0:	02051663          	bnez	a0,80001e1c <uvmcopy+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
    80001df4:	000017b7          	lui	a5,0x1
    80001df8:	00f989b3          	add	s3,s3,a5
    80001dfc:	f949ece3          	bltu	s3,s4,80001d94 <uvmcopy+0x40>
    80001e00:	03c0006f          	j	80001e3c <uvmcopy+0xe8>
      panic("uvmcopy: pte should exist");
    80001e04:	00007517          	auipc	a0,0x7
    80001e08:	3a450513          	addi	a0,a0,932 # 800091a8 <etext+0x1a8>
    80001e0c:	bf5fe0ef          	jal	80000a00 <panic>
      panic("uvmcopy: page not present");
    80001e10:	00007517          	auipc	a0,0x7
    80001e14:	3b850513          	addi	a0,a0,952 # 800091c8 <etext+0x1c8>
    80001e18:	be9fe0ef          	jal	80000a00 <panic>
      kfree(mem);
    80001e1c:	00090513          	mv	a0,s2
    80001e20:	f8dfe0ef          	jal	80000dac <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001e24:	00100693          	li	a3,1
    80001e28:	00c9d613          	srli	a2,s3,0xc
    80001e2c:	00000593          	li	a1,0
    80001e30:	000a8513          	mv	a0,s5
    80001e34:	aa1ff0ef          	jal	800018d4 <uvmunmap>
  return -1;
    80001e38:	fff00513          	li	a0,-1
}
    80001e3c:	04813083          	ld	ra,72(sp)
    80001e40:	04013403          	ld	s0,64(sp)
    80001e44:	03813483          	ld	s1,56(sp)
    80001e48:	03013903          	ld	s2,48(sp)
    80001e4c:	02813983          	ld	s3,40(sp)
    80001e50:	02013a03          	ld	s4,32(sp)
    80001e54:	01813a83          	ld	s5,24(sp)
    80001e58:	01013b03          	ld	s6,16(sp)
    80001e5c:	00813b83          	ld	s7,8(sp)
    80001e60:	05010113          	addi	sp,sp,80
    80001e64:	00008067          	ret
  return 0;
    80001e68:	00000513          	li	a0,0
}
    80001e6c:	00008067          	ret

0000000080001e70 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001e70:	ff010113          	addi	sp,sp,-16
    80001e74:	00113423          	sd	ra,8(sp)
    80001e78:	00813023          	sd	s0,0(sp)
    80001e7c:	01010413          	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001e80:	00000613          	li	a2,0
    80001e84:	e7cff0ef          	jal	80001500 <walk>
  if(pte == 0)
    80001e88:	02050063          	beqz	a0,80001ea8 <uvmclear+0x38>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001e8c:	00053783          	ld	a5,0(a0)
    80001e90:	fef7f793          	andi	a5,a5,-17
    80001e94:	00f53023          	sd	a5,0(a0)
}
    80001e98:	00813083          	ld	ra,8(sp)
    80001e9c:	00013403          	ld	s0,0(sp)
    80001ea0:	01010113          	addi	sp,sp,16
    80001ea4:	00008067          	ret
    panic("uvmclear");
    80001ea8:	00007517          	auipc	a0,0x7
    80001eac:	34050513          	addi	a0,a0,832 # 800091e8 <etext+0x1e8>
    80001eb0:	b51fe0ef          	jal	80000a00 <panic>

0000000080001eb4 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001eb4:	0e068a63          	beqz	a3,80001fa8 <copyout+0xf4>
{
    80001eb8:	fa010113          	addi	sp,sp,-96
    80001ebc:	04113c23          	sd	ra,88(sp)
    80001ec0:	04813823          	sd	s0,80(sp)
    80001ec4:	04913423          	sd	s1,72(sp)
    80001ec8:	03313c23          	sd	s3,56(sp)
    80001ecc:	03513423          	sd	s5,40(sp)
    80001ed0:	03613023          	sd	s6,32(sp)
    80001ed4:	01713c23          	sd	s7,24(sp)
    80001ed8:	06010413          	addi	s0,sp,96
    80001edc:	00050b93          	mv	s7,a0
    80001ee0:	00058a93          	mv	s5,a1
    80001ee4:	00060b13          	mv	s6,a2
    80001ee8:	00068993          	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001eec:	fffff4b7          	lui	s1,0xfffff
    80001ef0:	0095f4b3          	and	s1,a1,s1
    if(va0 >= MAXVA)
    80001ef4:	fff00793          	li	a5,-1
    80001ef8:	01a7d793          	srli	a5,a5,0x1a
    80001efc:	0a97ea63          	bltu	a5,s1,80001fb0 <copyout+0xfc>
    80001f00:	05213023          	sd	s2,64(sp)
    80001f04:	03413823          	sd	s4,48(sp)
    80001f08:	01813823          	sd	s8,16(sp)
    80001f0c:	01913423          	sd	s9,8(sp)
    80001f10:	01a13023          	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001f14:	01500c93          	li	s9,21
    80001f18:	00001d37          	lui	s10,0x1
    if(va0 >= MAXVA)
    80001f1c:	00078c13          	mv	s8,a5
    80001f20:	0380006f          	j	80001f58 <copyout+0xa4>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80001f24:	00a7d793          	srli	a5,a5,0xa
    80001f28:	00c79793          	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001f2c:	409a8533          	sub	a0,s5,s1
    80001f30:	0009061b          	sext.w	a2,s2
    80001f34:	000b0593          	mv	a1,s6
    80001f38:	00a78533          	add	a0,a5,a0
    80001f3c:	ad0ff0ef          	jal	8000120c <memmove>

    len -= n;
    80001f40:	412989b3          	sub	s3,s3,s2
    src += n;
    80001f44:	012b0b33          	add	s6,s6,s2
  while(len > 0){
    80001f48:	04098263          	beqz	s3,80001f8c <copyout+0xd8>
    if(va0 >= MAXVA)
    80001f4c:	074c6663          	bltu	s8,s4,80001fb8 <copyout+0x104>
    80001f50:	000a0493          	mv	s1,s4
    80001f54:	000a0a93          	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80001f58:	00000613          	li	a2,0
    80001f5c:	00048593          	mv	a1,s1
    80001f60:	000b8513          	mv	a0,s7
    80001f64:	d9cff0ef          	jal	80001500 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001f68:	06050663          	beqz	a0,80001fd4 <copyout+0x120>
    80001f6c:	00053783          	ld	a5,0(a0)
    80001f70:	0157f713          	andi	a4,a5,21
    80001f74:	09971e63          	bne	a4,s9,80002010 <copyout+0x15c>
    n = PGSIZE - (dstva - va0);
    80001f78:	01a48a33          	add	s4,s1,s10
    80001f7c:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80001f80:	fb29f2e3          	bgeu	s3,s2,80001f24 <copyout+0x70>
    80001f84:	00098913          	mv	s2,s3
    80001f88:	f9dff06f          	j	80001f24 <copyout+0x70>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80001f8c:	00000513          	li	a0,0
    80001f90:	04013903          	ld	s2,64(sp)
    80001f94:	03013a03          	ld	s4,48(sp)
    80001f98:	01013c03          	ld	s8,16(sp)
    80001f9c:	00813c83          	ld	s9,8(sp)
    80001fa0:	00013d03          	ld	s10,0(sp)
    80001fa4:	0480006f          	j	80001fec <copyout+0x138>
    80001fa8:	00000513          	li	a0,0
}
    80001fac:	00008067          	ret
      return -1;
    80001fb0:	fff00513          	li	a0,-1
    80001fb4:	0380006f          	j	80001fec <copyout+0x138>
    80001fb8:	fff00513          	li	a0,-1
    80001fbc:	04013903          	ld	s2,64(sp)
    80001fc0:	03013a03          	ld	s4,48(sp)
    80001fc4:	01013c03          	ld	s8,16(sp)
    80001fc8:	00813c83          	ld	s9,8(sp)
    80001fcc:	00013d03          	ld	s10,0(sp)
    80001fd0:	01c0006f          	j	80001fec <copyout+0x138>
      return -1;
    80001fd4:	fff00513          	li	a0,-1
    80001fd8:	04013903          	ld	s2,64(sp)
    80001fdc:	03013a03          	ld	s4,48(sp)
    80001fe0:	01013c03          	ld	s8,16(sp)
    80001fe4:	00813c83          	ld	s9,8(sp)
    80001fe8:	00013d03          	ld	s10,0(sp)
}
    80001fec:	05813083          	ld	ra,88(sp)
    80001ff0:	05013403          	ld	s0,80(sp)
    80001ff4:	04813483          	ld	s1,72(sp)
    80001ff8:	03813983          	ld	s3,56(sp)
    80001ffc:	02813a83          	ld	s5,40(sp)
    80002000:	02013b03          	ld	s6,32(sp)
    80002004:	01813b83          	ld	s7,24(sp)
    80002008:	06010113          	addi	sp,sp,96
    8000200c:	00008067          	ret
      return -1;
    80002010:	fff00513          	li	a0,-1
    80002014:	04013903          	ld	s2,64(sp)
    80002018:	03013a03          	ld	s4,48(sp)
    8000201c:	01013c03          	ld	s8,16(sp)
    80002020:	00813c83          	ld	s9,8(sp)
    80002024:	00013d03          	ld	s10,0(sp)
    80002028:	fc5ff06f          	j	80001fec <copyout+0x138>

000000008000202c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000202c:	0a068263          	beqz	a3,800020d0 <copyin+0xa4>
{
    80002030:	fb010113          	addi	sp,sp,-80
    80002034:	04113423          	sd	ra,72(sp)
    80002038:	04813023          	sd	s0,64(sp)
    8000203c:	02913c23          	sd	s1,56(sp)
    80002040:	03213823          	sd	s2,48(sp)
    80002044:	03313423          	sd	s3,40(sp)
    80002048:	03413023          	sd	s4,32(sp)
    8000204c:	01513c23          	sd	s5,24(sp)
    80002050:	01613823          	sd	s6,16(sp)
    80002054:	01713423          	sd	s7,8(sp)
    80002058:	01813023          	sd	s8,0(sp)
    8000205c:	05010413          	addi	s0,sp,80
    80002060:	00050b13          	mv	s6,a0
    80002064:	00058a13          	mv	s4,a1
    80002068:	00060c13          	mv	s8,a2
    8000206c:	00068993          	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80002070:	fffffbb7          	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80002074:	00001ab7          	lui	s5,0x1
    80002078:	0280006f          	j	800020a0 <copyin+0x74>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000207c:	018505b3          	add	a1,a0,s8
    80002080:	0004861b          	sext.w	a2,s1
    80002084:	412585b3          	sub	a1,a1,s2
    80002088:	000a0513          	mv	a0,s4
    8000208c:	980ff0ef          	jal	8000120c <memmove>

    len -= n;
    80002090:	409989b3          	sub	s3,s3,s1
    dst += n;
    80002094:	009a0a33          	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80002098:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000209c:	02098663          	beqz	s3,800020c8 <copyin+0x9c>
    va0 = PGROUNDDOWN(srcva);
    800020a0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800020a4:	00090593          	mv	a1,s2
    800020a8:	000b0513          	mv	a0,s6
    800020ac:	d44ff0ef          	jal	800015f0 <walkaddr>
    if(pa0 == 0)
    800020b0:	02050463          	beqz	a0,800020d8 <copyin+0xac>
    n = PGSIZE - (srcva - va0);
    800020b4:	418904b3          	sub	s1,s2,s8
    800020b8:	015484b3          	add	s1,s1,s5
    if(n > len)
    800020bc:	fc99f0e3          	bgeu	s3,s1,8000207c <copyin+0x50>
    800020c0:	00098493          	mv	s1,s3
    800020c4:	fb9ff06f          	j	8000207c <copyin+0x50>
  }
  return 0;
    800020c8:	00000513          	li	a0,0
    800020cc:	0100006f          	j	800020dc <copyin+0xb0>
    800020d0:	00000513          	li	a0,0
}
    800020d4:	00008067          	ret
      return -1;
    800020d8:	fff00513          	li	a0,-1
}
    800020dc:	04813083          	ld	ra,72(sp)
    800020e0:	04013403          	ld	s0,64(sp)
    800020e4:	03813483          	ld	s1,56(sp)
    800020e8:	03013903          	ld	s2,48(sp)
    800020ec:	02813983          	ld	s3,40(sp)
    800020f0:	02013a03          	ld	s4,32(sp)
    800020f4:	01813a83          	ld	s5,24(sp)
    800020f8:	01013b03          	ld	s6,16(sp)
    800020fc:	00813b83          	ld	s7,8(sp)
    80002100:	00013c03          	ld	s8,0(sp)
    80002104:	05010113          	addi	sp,sp,80
    80002108:	00008067          	ret

000000008000210c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000210c:	12068063          	beqz	a3,8000222c <copyinstr+0x120>
{
    80002110:	fb010113          	addi	sp,sp,-80
    80002114:	04113423          	sd	ra,72(sp)
    80002118:	04813023          	sd	s0,64(sp)
    8000211c:	02913c23          	sd	s1,56(sp)
    80002120:	03213823          	sd	s2,48(sp)
    80002124:	03313423          	sd	s3,40(sp)
    80002128:	03413023          	sd	s4,32(sp)
    8000212c:	01513c23          	sd	s5,24(sp)
    80002130:	01613823          	sd	s6,16(sp)
    80002134:	01713423          	sd	s7,8(sp)
    80002138:	05010413          	addi	s0,sp,80
    8000213c:	00050a13          	mv	s4,a0
    80002140:	00058b13          	mv	s6,a1
    80002144:	00060b93          	mv	s7,a2
    80002148:	00068913          	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    8000214c:	fffffab7          	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80002150:	000019b7          	lui	s3,0x1
    80002154:	0580006f          	j	800021ac <copyinstr+0xa0>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80002158:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000215c:	00100793          	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80002160:	fff7879b          	addiw	a5,a5,-1
    80002164:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80002168:	04813083          	ld	ra,72(sp)
    8000216c:	04013403          	ld	s0,64(sp)
    80002170:	03813483          	ld	s1,56(sp)
    80002174:	03013903          	ld	s2,48(sp)
    80002178:	02813983          	ld	s3,40(sp)
    8000217c:	02013a03          	ld	s4,32(sp)
    80002180:	01813a83          	ld	s5,24(sp)
    80002184:	01013b03          	ld	s6,16(sp)
    80002188:	00813b83          	ld	s7,8(sp)
    8000218c:	05010113          	addi	sp,sp,80
    80002190:	00008067          	ret
    80002194:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80002198:	01070733          	add	a4,a4,a6
      --max;
    8000219c:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    800021a0:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    800021a4:	06e58463          	beq	a1,a4,8000220c <copyinstr+0x100>
{
    800021a8:	00078b13          	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    800021ac:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800021b0:	00048593          	mv	a1,s1
    800021b4:	000a0513          	mv	a0,s4
    800021b8:	c38ff0ef          	jal	800015f0 <walkaddr>
    if(pa0 == 0)
    800021bc:	04050c63          	beqz	a0,80002214 <copyinstr+0x108>
    n = PGSIZE - (srcva - va0);
    800021c0:	417486b3          	sub	a3,s1,s7
    800021c4:	013686b3          	add	a3,a3,s3
    if(n > max)
    800021c8:	00d97463          	bgeu	s2,a3,800021d0 <copyinstr+0xc4>
    800021cc:	00090693          	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    800021d0:	01750533          	add	a0,a0,s7
    800021d4:	40950533          	sub	a0,a0,s1
    while(n > 0){
    800021d8:	04068263          	beqz	a3,8000221c <copyinstr+0x110>
    800021dc:	000b0793          	mv	a5,s6
    800021e0:	000b0813          	mv	a6,s6
      if(*p == '\0'){
    800021e4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    800021e8:	00db06b3          	add	a3,s6,a3
    800021ec:	00078593          	mv	a1,a5
      if(*p == '\0'){
    800021f0:	00f60733          	add	a4,a2,a5
    800021f4:	00074703          	lbu	a4,0(a4)
    800021f8:	f60700e3          	beqz	a4,80002158 <copyinstr+0x4c>
        *dst = *p;
    800021fc:	00e78023          	sb	a4,0(a5)
      dst++;
    80002200:	00178793          	addi	a5,a5,1
    while(n > 0){
    80002204:	fed794e3          	bne	a5,a3,800021ec <copyinstr+0xe0>
    80002208:	f8dff06f          	j	80002194 <copyinstr+0x88>
    8000220c:	00000793          	li	a5,0
    80002210:	f51ff06f          	j	80002160 <copyinstr+0x54>
      return -1;
    80002214:	fff00513          	li	a0,-1
    80002218:	f51ff06f          	j	80002168 <copyinstr+0x5c>
    srcva = va0 + PGSIZE;
    8000221c:	00001bb7          	lui	s7,0x1
    80002220:	01748bb3          	add	s7,s1,s7
    80002224:	000b0793          	mv	a5,s6
    80002228:	f81ff06f          	j	800021a8 <copyinstr+0x9c>
  int got_null = 0;
    8000222c:	00000793          	li	a5,0
  if(got_null){
    80002230:	fff7879b          	addiw	a5,a5,-1
    80002234:	0007851b          	sext.w	a0,a5
}
    80002238:	00008067          	ret

000000008000223c <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000223c:	fc010113          	addi	sp,sp,-64
    80002240:	02113c23          	sd	ra,56(sp)
    80002244:	02813823          	sd	s0,48(sp)
    80002248:	02913423          	sd	s1,40(sp)
    8000224c:	03213023          	sd	s2,32(sp)
    80002250:	01313c23          	sd	s3,24(sp)
    80002254:	01413823          	sd	s4,16(sp)
    80002258:	01513423          	sd	s5,8(sp)
    8000225c:	01613023          	sd	s6,0(sp)
    80002260:	04010413          	addi	s0,sp,64
    80002264:	00050a13          	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80002268:	00010497          	auipc	s1,0x10
    8000226c:	bf848493          	addi	s1,s1,-1032 # 80011e60 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80002270:	00048b13          	mv	s6,s1
    80002274:	04fa5937          	lui	s2,0x4fa5
    80002278:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    8000227c:	00c91913          	slli	s2,s2,0xc
    80002280:	fa590913          	addi	s2,s2,-91
    80002284:	00c91913          	slli	s2,s2,0xc
    80002288:	fa590913          	addi	s2,s2,-91
    8000228c:	00c91913          	slli	s2,s2,0xc
    80002290:	fa590913          	addi	s2,s2,-91
    80002294:	040009b7          	lui	s3,0x4000
    80002298:	fff98993          	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000229c:	00c99993          	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800022a0:	00015a97          	auipc	s5,0x15
    800022a4:	5c0a8a93          	addi	s5,s5,1472 # 80017860 <tickslock>
    char *pa = kalloc();
    800022a8:	c55fe0ef          	jal	80000efc <kalloc>
    800022ac:	00050613          	mv	a2,a0
    if(pa == 0)
    800022b0:	04050e63          	beqz	a0,8000230c <proc_mapstacks+0xd0>
    uint64 va = KSTACK((int) (p - proc));
    800022b4:	416485b3          	sub	a1,s1,s6
    800022b8:	4035d593          	srai	a1,a1,0x3
    800022bc:	032585b3          	mul	a1,a1,s2
    800022c0:	0015859b          	addiw	a1,a1,1
    800022c4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800022c8:	00600713          	li	a4,6
    800022cc:	000016b7          	lui	a3,0x1
    800022d0:	40b985b3          	sub	a1,s3,a1
    800022d4:	000a0513          	mv	a0,s4
    800022d8:	c8cff0ef          	jal	80001764 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800022dc:	16848493          	addi	s1,s1,360
    800022e0:	fd5494e3          	bne	s1,s5,800022a8 <proc_mapstacks+0x6c>
  }
}
    800022e4:	03813083          	ld	ra,56(sp)
    800022e8:	03013403          	ld	s0,48(sp)
    800022ec:	02813483          	ld	s1,40(sp)
    800022f0:	02013903          	ld	s2,32(sp)
    800022f4:	01813983          	ld	s3,24(sp)
    800022f8:	01013a03          	ld	s4,16(sp)
    800022fc:	00813a83          	ld	s5,8(sp)
    80002300:	00013b03          	ld	s6,0(sp)
    80002304:	04010113          	addi	sp,sp,64
    80002308:	00008067          	ret
      panic("kalloc");
    8000230c:	00007517          	auipc	a0,0x7
    80002310:	eec50513          	addi	a0,a0,-276 # 800091f8 <etext+0x1f8>
    80002314:	eecfe0ef          	jal	80000a00 <panic>

0000000080002318 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80002318:	fc010113          	addi	sp,sp,-64
    8000231c:	02113c23          	sd	ra,56(sp)
    80002320:	02813823          	sd	s0,48(sp)
    80002324:	02913423          	sd	s1,40(sp)
    80002328:	03213023          	sd	s2,32(sp)
    8000232c:	01313c23          	sd	s3,24(sp)
    80002330:	01413823          	sd	s4,16(sp)
    80002334:	01513423          	sd	s5,8(sp)
    80002338:	01613023          	sd	s6,0(sp)
    8000233c:	04010413          	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80002340:	00007597          	auipc	a1,0x7
    80002344:	ec058593          	addi	a1,a1,-320 # 80009200 <etext+0x200>
    80002348:	0000f517          	auipc	a0,0xf
    8000234c:	6e850513          	addi	a0,a0,1768 # 80011a30 <pid_lock>
    80002350:	c25fe0ef          	jal	80000f74 <initlock>
  initlock(&wait_lock, "wait_lock");
    80002354:	00007597          	auipc	a1,0x7
    80002358:	eb458593          	addi	a1,a1,-332 # 80009208 <etext+0x208>
    8000235c:	0000f517          	auipc	a0,0xf
    80002360:	6ec50513          	addi	a0,a0,1772 # 80011a48 <wait_lock>
    80002364:	c11fe0ef          	jal	80000f74 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002368:	00010497          	auipc	s1,0x10
    8000236c:	af848493          	addi	s1,s1,-1288 # 80011e60 <proc>
      initlock(&p->lock, "proc");
    80002370:	00007b17          	auipc	s6,0x7
    80002374:	ea8b0b13          	addi	s6,s6,-344 # 80009218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80002378:	00048a93          	mv	s5,s1
    8000237c:	04fa5937          	lui	s2,0x4fa5
    80002380:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80002384:	00c91913          	slli	s2,s2,0xc
    80002388:	fa590913          	addi	s2,s2,-91
    8000238c:	00c91913          	slli	s2,s2,0xc
    80002390:	fa590913          	addi	s2,s2,-91
    80002394:	00c91913          	slli	s2,s2,0xc
    80002398:	fa590913          	addi	s2,s2,-91
    8000239c:	040009b7          	lui	s3,0x4000
    800023a0:	fff98993          	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800023a4:	00c99993          	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800023a8:	00015a17          	auipc	s4,0x15
    800023ac:	4b8a0a13          	addi	s4,s4,1208 # 80017860 <tickslock>
      initlock(&p->lock, "proc");
    800023b0:	000b0593          	mv	a1,s6
    800023b4:	00048513          	mv	a0,s1
    800023b8:	bbdfe0ef          	jal	80000f74 <initlock>
      p->state = UNUSED;
    800023bc:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800023c0:	415487b3          	sub	a5,s1,s5
    800023c4:	4037d793          	srai	a5,a5,0x3
    800023c8:	032787b3          	mul	a5,a5,s2
    800023cc:	0017879b          	addiw	a5,a5,1
    800023d0:	00d7979b          	slliw	a5,a5,0xd
    800023d4:	40f987b3          	sub	a5,s3,a5
    800023d8:	04f4b023          	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800023dc:	16848493          	addi	s1,s1,360
    800023e0:	fd4498e3          	bne	s1,s4,800023b0 <procinit+0x98>
  }
}
    800023e4:	03813083          	ld	ra,56(sp)
    800023e8:	03013403          	ld	s0,48(sp)
    800023ec:	02813483          	ld	s1,40(sp)
    800023f0:	02013903          	ld	s2,32(sp)
    800023f4:	01813983          	ld	s3,24(sp)
    800023f8:	01013a03          	ld	s4,16(sp)
    800023fc:	00813a83          	ld	s5,8(sp)
    80002400:	00013b03          	ld	s6,0(sp)
    80002404:	04010113          	addi	sp,sp,64
    80002408:	00008067          	ret

000000008000240c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000240c:	ff010113          	addi	sp,sp,-16
    80002410:	00813423          	sd	s0,8(sp)
    80002414:	01010413          	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80002418:	00020513          	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000241c:	0005051b          	sext.w	a0,a0
    80002420:	00813403          	ld	s0,8(sp)
    80002424:	01010113          	addi	sp,sp,16
    80002428:	00008067          	ret

000000008000242c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    8000242c:	ff010113          	addi	sp,sp,-16
    80002430:	00813423          	sd	s0,8(sp)
    80002434:	01010413          	addi	s0,sp,16
    80002438:	00020793          	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000243c:	0007879b          	sext.w	a5,a5
    80002440:	00779793          	slli	a5,a5,0x7
  return c;
}
    80002444:	0000f517          	auipc	a0,0xf
    80002448:	61c50513          	addi	a0,a0,1564 # 80011a60 <cpus>
    8000244c:	00f50533          	add	a0,a0,a5
    80002450:	00813403          	ld	s0,8(sp)
    80002454:	01010113          	addi	sp,sp,16
    80002458:	00008067          	ret

000000008000245c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    8000245c:	fe010113          	addi	sp,sp,-32
    80002460:	00113c23          	sd	ra,24(sp)
    80002464:	00813823          	sd	s0,16(sp)
    80002468:	00913423          	sd	s1,8(sp)
    8000246c:	02010413          	addi	s0,sp,32
  push_off();
    80002470:	b71fe0ef          	jal	80000fe0 <push_off>
    80002474:	00020793          	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80002478:	0007879b          	sext.w	a5,a5
    8000247c:	00779793          	slli	a5,a5,0x7
    80002480:	0000f717          	auipc	a4,0xf
    80002484:	5b070713          	addi	a4,a4,1456 # 80011a30 <pid_lock>
    80002488:	00f707b3          	add	a5,a4,a5
    8000248c:	0307b483          	ld	s1,48(a5)
  pop_off();
    80002490:	c21fe0ef          	jal	800010b0 <pop_off>
  return p;
}
    80002494:	00048513          	mv	a0,s1
    80002498:	01813083          	ld	ra,24(sp)
    8000249c:	01013403          	ld	s0,16(sp)
    800024a0:	00813483          	ld	s1,8(sp)
    800024a4:	02010113          	addi	sp,sp,32
    800024a8:	00008067          	ret

00000000800024ac <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800024ac:	ff010113          	addi	sp,sp,-16
    800024b0:	00113423          	sd	ra,8(sp)
    800024b4:	00813023          	sd	s0,0(sp)
    800024b8:	01010413          	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800024bc:	fa1ff0ef          	jal	8000245c <myproc>
    800024c0:	c65fe0ef          	jal	80001124 <release>

  if (first) {
    800024c4:	00007797          	auipc	a5,0x7
    800024c8:	3bc7a783          	lw	a5,956(a5) # 80009880 <first.1>
    800024cc:	00079c63          	bnez	a5,800024e4 <forkret+0x38>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    800024d0:	7a9000ef          	jal	80003478 <usertrapret>
}
    800024d4:	00813083          	ld	ra,8(sp)
    800024d8:	00013403          	ld	s0,0(sp)
    800024dc:	01010113          	addi	sp,sp,16
    800024e0:	00008067          	ret
    fsinit(ROOTDEV);
    800024e4:	00100513          	li	a0,1
    800024e8:	068020ef          	jal	80004550 <fsinit>
    first = 0;
    800024ec:	00007797          	auipc	a5,0x7
    800024f0:	3807aa23          	sw	zero,916(a5) # 80009880 <first.1>
    __sync_synchronize();
    800024f4:	0ff0000f          	fence
    800024f8:	fd9ff06f          	j	800024d0 <forkret+0x24>

00000000800024fc <allocpid>:
{
    800024fc:	fe010113          	addi	sp,sp,-32
    80002500:	00113c23          	sd	ra,24(sp)
    80002504:	00813823          	sd	s0,16(sp)
    80002508:	00913423          	sd	s1,8(sp)
    8000250c:	01213023          	sd	s2,0(sp)
    80002510:	02010413          	addi	s0,sp,32
  acquire(&pid_lock);
    80002514:	0000f917          	auipc	s2,0xf
    80002518:	51c90913          	addi	s2,s2,1308 # 80011a30 <pid_lock>
    8000251c:	00090513          	mv	a0,s2
    80002520:	b29fe0ef          	jal	80001048 <acquire>
  pid = nextpid;
    80002524:	00007797          	auipc	a5,0x7
    80002528:	36078793          	addi	a5,a5,864 # 80009884 <nextpid>
    8000252c:	0007a483          	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80002530:	0014871b          	addiw	a4,s1,1
    80002534:	00e7a023          	sw	a4,0(a5)
  release(&pid_lock);
    80002538:	00090513          	mv	a0,s2
    8000253c:	be9fe0ef          	jal	80001124 <release>
}
    80002540:	00048513          	mv	a0,s1
    80002544:	01813083          	ld	ra,24(sp)
    80002548:	01013403          	ld	s0,16(sp)
    8000254c:	00813483          	ld	s1,8(sp)
    80002550:	00013903          	ld	s2,0(sp)
    80002554:	02010113          	addi	sp,sp,32
    80002558:	00008067          	ret

000000008000255c <proc_pagetable>:
{
    8000255c:	fe010113          	addi	sp,sp,-32
    80002560:	00113c23          	sd	ra,24(sp)
    80002564:	00813823          	sd	s0,16(sp)
    80002568:	00913423          	sd	s1,8(sp)
    8000256c:	01213023          	sd	s2,0(sp)
    80002570:	02010413          	addi	s0,sp,32
    80002574:	00050913          	mv	s2,a0
  pagetable = uvmcreate();
    80002578:	c78ff0ef          	jal	800019f0 <uvmcreate>
    8000257c:	00050493          	mv	s1,a0
  if(pagetable == 0)
    80002580:	04050663          	beqz	a0,800025cc <proc_pagetable+0x70>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80002584:	00a00713          	li	a4,10
    80002588:	00006697          	auipc	a3,0x6
    8000258c:	a7868693          	addi	a3,a3,-1416 # 80008000 <_trampoline>
    80002590:	00001637          	lui	a2,0x1
    80002594:	040005b7          	lui	a1,0x4000
    80002598:	fff58593          	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000259c:	00c59593          	slli	a1,a1,0xc
    800025a0:	8b8ff0ef          	jal	80001658 <mappages>
    800025a4:	04054263          	bltz	a0,800025e8 <proc_pagetable+0x8c>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800025a8:	00600713          	li	a4,6
    800025ac:	05893683          	ld	a3,88(s2)
    800025b0:	00001637          	lui	a2,0x1
    800025b4:	020005b7          	lui	a1,0x2000
    800025b8:	fff58593          	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800025bc:	00d59593          	slli	a1,a1,0xd
    800025c0:	00048513          	mv	a0,s1
    800025c4:	894ff0ef          	jal	80001658 <mappages>
    800025c8:	02054a63          	bltz	a0,800025fc <proc_pagetable+0xa0>
}
    800025cc:	00048513          	mv	a0,s1
    800025d0:	01813083          	ld	ra,24(sp)
    800025d4:	01013403          	ld	s0,16(sp)
    800025d8:	00813483          	ld	s1,8(sp)
    800025dc:	00013903          	ld	s2,0(sp)
    800025e0:	02010113          	addi	sp,sp,32
    800025e4:	00008067          	ret
    uvmfree(pagetable, 0);
    800025e8:	00000593          	li	a1,0
    800025ec:	00048513          	mv	a0,s1
    800025f0:	f0cff0ef          	jal	80001cfc <uvmfree>
    return 0;
    800025f4:	00000493          	li	s1,0
    800025f8:	fd5ff06f          	j	800025cc <proc_pagetable+0x70>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800025fc:	00000693          	li	a3,0
    80002600:	00100613          	li	a2,1
    80002604:	040005b7          	lui	a1,0x4000
    80002608:	fff58593          	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000260c:	00c59593          	slli	a1,a1,0xc
    80002610:	00048513          	mv	a0,s1
    80002614:	ac0ff0ef          	jal	800018d4 <uvmunmap>
    uvmfree(pagetable, 0);
    80002618:	00000593          	li	a1,0
    8000261c:	00048513          	mv	a0,s1
    80002620:	edcff0ef          	jal	80001cfc <uvmfree>
    return 0;
    80002624:	00000493          	li	s1,0
    80002628:	fa5ff06f          	j	800025cc <proc_pagetable+0x70>

000000008000262c <proc_freepagetable>:
{
    8000262c:	fe010113          	addi	sp,sp,-32
    80002630:	00113c23          	sd	ra,24(sp)
    80002634:	00813823          	sd	s0,16(sp)
    80002638:	00913423          	sd	s1,8(sp)
    8000263c:	01213023          	sd	s2,0(sp)
    80002640:	02010413          	addi	s0,sp,32
    80002644:	00050493          	mv	s1,a0
    80002648:	00058913          	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000264c:	00000693          	li	a3,0
    80002650:	00100613          	li	a2,1
    80002654:	040005b7          	lui	a1,0x4000
    80002658:	fff58593          	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000265c:	00c59593          	slli	a1,a1,0xc
    80002660:	a74ff0ef          	jal	800018d4 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80002664:	00000693          	li	a3,0
    80002668:	00100613          	li	a2,1
    8000266c:	020005b7          	lui	a1,0x2000
    80002670:	fff58593          	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002674:	00d59593          	slli	a1,a1,0xd
    80002678:	00048513          	mv	a0,s1
    8000267c:	a58ff0ef          	jal	800018d4 <uvmunmap>
  uvmfree(pagetable, sz);
    80002680:	00090593          	mv	a1,s2
    80002684:	00048513          	mv	a0,s1
    80002688:	e74ff0ef          	jal	80001cfc <uvmfree>
}
    8000268c:	01813083          	ld	ra,24(sp)
    80002690:	01013403          	ld	s0,16(sp)
    80002694:	00813483          	ld	s1,8(sp)
    80002698:	00013903          	ld	s2,0(sp)
    8000269c:	02010113          	addi	sp,sp,32
    800026a0:	00008067          	ret

00000000800026a4 <freeproc>:
{
    800026a4:	fe010113          	addi	sp,sp,-32
    800026a8:	00113c23          	sd	ra,24(sp)
    800026ac:	00813823          	sd	s0,16(sp)
    800026b0:	00913423          	sd	s1,8(sp)
    800026b4:	02010413          	addi	s0,sp,32
    800026b8:	00050493          	mv	s1,a0
  if(p->trapframe)
    800026bc:	05853503          	ld	a0,88(a0)
    800026c0:	00050463          	beqz	a0,800026c8 <freeproc+0x24>
    kfree((void*)p->trapframe);
    800026c4:	ee8fe0ef          	jal	80000dac <kfree>
  p->trapframe = 0;
    800026c8:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800026cc:	0504b503          	ld	a0,80(s1)
    800026d0:	00050663          	beqz	a0,800026dc <freeproc+0x38>
    proc_freepagetable(p->pagetable, p->sz);
    800026d4:	0484b583          	ld	a1,72(s1)
    800026d8:	f55ff0ef          	jal	8000262c <proc_freepagetable>
  p->pagetable = 0;
    800026dc:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800026e0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800026e4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800026e8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800026ec:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800026f0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800026f4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800026f8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800026fc:	0004ac23          	sw	zero,24(s1)
}
    80002700:	01813083          	ld	ra,24(sp)
    80002704:	01013403          	ld	s0,16(sp)
    80002708:	00813483          	ld	s1,8(sp)
    8000270c:	02010113          	addi	sp,sp,32
    80002710:	00008067          	ret

0000000080002714 <allocproc>:
{
    80002714:	fe010113          	addi	sp,sp,-32
    80002718:	00113c23          	sd	ra,24(sp)
    8000271c:	00813823          	sd	s0,16(sp)
    80002720:	00913423          	sd	s1,8(sp)
    80002724:	01213023          	sd	s2,0(sp)
    80002728:	02010413          	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000272c:	0000f497          	auipc	s1,0xf
    80002730:	73448493          	addi	s1,s1,1844 # 80011e60 <proc>
    80002734:	00015917          	auipc	s2,0x15
    80002738:	12c90913          	addi	s2,s2,300 # 80017860 <tickslock>
    acquire(&p->lock);
    8000273c:	00048513          	mv	a0,s1
    80002740:	909fe0ef          	jal	80001048 <acquire>
    if(p->state == UNUSED) {
    80002744:	0184a783          	lw	a5,24(s1)
    80002748:	00078e63          	beqz	a5,80002764 <allocproc+0x50>
      release(&p->lock);
    8000274c:	00048513          	mv	a0,s1
    80002750:	9d5fe0ef          	jal	80001124 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002754:	16848493          	addi	s1,s1,360
    80002758:	ff2492e3          	bne	s1,s2,8000273c <allocproc+0x28>
  return 0;
    8000275c:	00000493          	li	s1,0
    80002760:	0640006f          	j	800027c4 <allocproc+0xb0>
  p->pid = allocpid();
    80002764:	d99ff0ef          	jal	800024fc <allocpid>
    80002768:	02a4a823          	sw	a0,48(s1)
  p->state = USED;
    8000276c:	00100793          	li	a5,1
    80002770:	00f4ac23          	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80002774:	f88fe0ef          	jal	80000efc <kalloc>
    80002778:	00050913          	mv	s2,a0
    8000277c:	04a4bc23          	sd	a0,88(s1)
    80002780:	06050063          	beqz	a0,800027e0 <allocproc+0xcc>
  p->pagetable = proc_pagetable(p);
    80002784:	00048513          	mv	a0,s1
    80002788:	dd5ff0ef          	jal	8000255c <proc_pagetable>
    8000278c:	00050913          	mv	s2,a0
    80002790:	04a4b823          	sd	a0,80(s1)
  if(p->pagetable == 0){
    80002794:	06050263          	beqz	a0,800027f8 <allocproc+0xe4>
  memset(&p->context, 0, sizeof(p->context));
    80002798:	07000613          	li	a2,112
    8000279c:	00000593          	li	a1,0
    800027a0:	06048513          	addi	a0,s1,96
    800027a4:	9d5fe0ef          	jal	80001178 <memset>
  p->context.ra = (uint64)forkret;
    800027a8:	00000797          	auipc	a5,0x0
    800027ac:	d0478793          	addi	a5,a5,-764 # 800024ac <forkret>
    800027b0:	06f4b023          	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800027b4:	0404b783          	ld	a5,64(s1)
    800027b8:	00001737          	lui	a4,0x1
    800027bc:	00e787b3          	add	a5,a5,a4
    800027c0:	06f4b423          	sd	a5,104(s1)
}
    800027c4:	00048513          	mv	a0,s1
    800027c8:	01813083          	ld	ra,24(sp)
    800027cc:	01013403          	ld	s0,16(sp)
    800027d0:	00813483          	ld	s1,8(sp)
    800027d4:	00013903          	ld	s2,0(sp)
    800027d8:	02010113          	addi	sp,sp,32
    800027dc:	00008067          	ret
    freeproc(p);
    800027e0:	00048513          	mv	a0,s1
    800027e4:	ec1ff0ef          	jal	800026a4 <freeproc>
    release(&p->lock);
    800027e8:	00048513          	mv	a0,s1
    800027ec:	939fe0ef          	jal	80001124 <release>
    return 0;
    800027f0:	00090493          	mv	s1,s2
    800027f4:	fd1ff06f          	j	800027c4 <allocproc+0xb0>
    freeproc(p);
    800027f8:	00048513          	mv	a0,s1
    800027fc:	ea9ff0ef          	jal	800026a4 <freeproc>
    release(&p->lock);
    80002800:	00048513          	mv	a0,s1
    80002804:	921fe0ef          	jal	80001124 <release>
    return 0;
    80002808:	00090493          	mv	s1,s2
    8000280c:	fb9ff06f          	j	800027c4 <allocproc+0xb0>

0000000080002810 <userinit>:
{
    80002810:	fe010113          	addi	sp,sp,-32
    80002814:	00113c23          	sd	ra,24(sp)
    80002818:	00813823          	sd	s0,16(sp)
    8000281c:	00913423          	sd	s1,8(sp)
    80002820:	02010413          	addi	s0,sp,32
  p = allocproc();
    80002824:	ef1ff0ef          	jal	80002714 <allocproc>
    80002828:	00050493          	mv	s1,a0
  initproc = p;
    8000282c:	00007797          	auipc	a5,0x7
    80002830:	0ca7b623          	sd	a0,204(a5) # 800098f8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002834:	03400613          	li	a2,52
    80002838:	00007597          	auipc	a1,0x7
    8000283c:	05858593          	addi	a1,a1,88 # 80009890 <initcode>
    80002840:	05053503          	ld	a0,80(a0)
    80002844:	9f0ff0ef          	jal	80001a34 <uvmfirst>
  p->sz = PGSIZE;
    80002848:	000017b7          	lui	a5,0x1
    8000284c:	04f4b423          	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80002850:	0584b703          	ld	a4,88(s1)
    80002854:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80002858:	0584b703          	ld	a4,88(s1)
    8000285c:	02f73823          	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002860:	01000613          	li	a2,16
    80002864:	00007597          	auipc	a1,0x7
    80002868:	9bc58593          	addi	a1,a1,-1604 # 80009220 <etext+0x220>
    8000286c:	15848513          	addi	a0,s1,344
    80002870:	af9fe0ef          	jal	80001368 <safestrcpy>
  p->cwd = namei("/");
    80002874:	00007517          	auipc	a0,0x7
    80002878:	9bc50513          	addi	a0,a0,-1604 # 80009230 <etext+0x230>
    8000287c:	239020ef          	jal	800052b4 <namei>
    80002880:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80002884:	00300793          	li	a5,3
    80002888:	00f4ac23          	sw	a5,24(s1)
  release(&p->lock);
    8000288c:	00048513          	mv	a0,s1
    80002890:	895fe0ef          	jal	80001124 <release>
}
    80002894:	01813083          	ld	ra,24(sp)
    80002898:	01013403          	ld	s0,16(sp)
    8000289c:	00813483          	ld	s1,8(sp)
    800028a0:	02010113          	addi	sp,sp,32
    800028a4:	00008067          	ret

00000000800028a8 <growproc>:
{
    800028a8:	fe010113          	addi	sp,sp,-32
    800028ac:	00113c23          	sd	ra,24(sp)
    800028b0:	00813823          	sd	s0,16(sp)
    800028b4:	00913423          	sd	s1,8(sp)
    800028b8:	01213023          	sd	s2,0(sp)
    800028bc:	02010413          	addi	s0,sp,32
    800028c0:	00050913          	mv	s2,a0
  struct proc *p = myproc();
    800028c4:	b99ff0ef          	jal	8000245c <myproc>
    800028c8:	00050493          	mv	s1,a0
  sz = p->sz;
    800028cc:	04853583          	ld	a1,72(a0)
  if(n > 0){
    800028d0:	03204463          	bgtz	s2,800028f8 <growproc+0x50>
  } else if(n < 0){
    800028d4:	04094263          	bltz	s2,80002918 <growproc+0x70>
  p->sz = sz;
    800028d8:	04b4b423          	sd	a1,72(s1)
  return 0;
    800028dc:	00000513          	li	a0,0
}
    800028e0:	01813083          	ld	ra,24(sp)
    800028e4:	01013403          	ld	s0,16(sp)
    800028e8:	00813483          	ld	s1,8(sp)
    800028ec:	00013903          	ld	s2,0(sp)
    800028f0:	02010113          	addi	sp,sp,32
    800028f4:	00008067          	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800028f8:	00400693          	li	a3,4
    800028fc:	00b90633          	add	a2,s2,a1
    80002900:	05053503          	ld	a0,80(a0)
    80002904:	a40ff0ef          	jal	80001b44 <uvmalloc>
    80002908:	00050593          	mv	a1,a0
    8000290c:	fc0516e3          	bnez	a0,800028d8 <growproc+0x30>
      return -1;
    80002910:	fff00513          	li	a0,-1
    80002914:	fcdff06f          	j	800028e0 <growproc+0x38>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002918:	00b90633          	add	a2,s2,a1
    8000291c:	05053503          	ld	a0,80(a0)
    80002920:	9b0ff0ef          	jal	80001ad0 <uvmdealloc>
    80002924:	00050593          	mv	a1,a0
    80002928:	fb1ff06f          	j	800028d8 <growproc+0x30>

000000008000292c <fork>:
{
    8000292c:	fc010113          	addi	sp,sp,-64
    80002930:	02113c23          	sd	ra,56(sp)
    80002934:	02813823          	sd	s0,48(sp)
    80002938:	03213023          	sd	s2,32(sp)
    8000293c:	01513423          	sd	s5,8(sp)
    80002940:	04010413          	addi	s0,sp,64
  struct proc *p = myproc();
    80002944:	b19ff0ef          	jal	8000245c <myproc>
    80002948:	00050a93          	mv	s5,a0
  if((np = allocproc()) == 0){
    8000294c:	dc9ff0ef          	jal	80002714 <allocproc>
    80002950:	14050263          	beqz	a0,80002a94 <fork+0x168>
    80002954:	01413823          	sd	s4,16(sp)
    80002958:	00050a13          	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000295c:	048ab603          	ld	a2,72(s5)
    80002960:	05053583          	ld	a1,80(a0)
    80002964:	050ab503          	ld	a0,80(s5)
    80002968:	becff0ef          	jal	80001d54 <uvmcopy>
    8000296c:	06054463          	bltz	a0,800029d4 <fork+0xa8>
    80002970:	02913423          	sd	s1,40(sp)
    80002974:	01313c23          	sd	s3,24(sp)
  np->sz = p->sz;
    80002978:	048ab783          	ld	a5,72(s5)
    8000297c:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80002980:	058ab683          	ld	a3,88(s5)
    80002984:	00068793          	mv	a5,a3
    80002988:	058a3703          	ld	a4,88(s4)
    8000298c:	12068693          	addi	a3,a3,288
    80002990:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80002994:	0087b503          	ld	a0,8(a5)
    80002998:	0107b583          	ld	a1,16(a5)
    8000299c:	0187b603          	ld	a2,24(a5)
    800029a0:	01073023          	sd	a6,0(a4)
    800029a4:	00a73423          	sd	a0,8(a4)
    800029a8:	00b73823          	sd	a1,16(a4)
    800029ac:	00c73c23          	sd	a2,24(a4)
    800029b0:	02078793          	addi	a5,a5,32
    800029b4:	02070713          	addi	a4,a4,32
    800029b8:	fcd79ce3          	bne	a5,a3,80002990 <fork+0x64>
  np->trapframe->a0 = 0;
    800029bc:	058a3783          	ld	a5,88(s4)
    800029c0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800029c4:	0d0a8493          	addi	s1,s5,208
    800029c8:	0d0a0913          	addi	s2,s4,208
    800029cc:	150a8993          	addi	s3,s5,336
    800029d0:	02c0006f          	j	800029fc <fork+0xd0>
    freeproc(np);
    800029d4:	000a0513          	mv	a0,s4
    800029d8:	ccdff0ef          	jal	800026a4 <freeproc>
    release(&np->lock);
    800029dc:	000a0513          	mv	a0,s4
    800029e0:	f44fe0ef          	jal	80001124 <release>
    return -1;
    800029e4:	fff00913          	li	s2,-1
    800029e8:	01013a03          	ld	s4,16(sp)
    800029ec:	08c0006f          	j	80002a78 <fork+0x14c>
  for(i = 0; i < NOFILE; i++)
    800029f0:	00848493          	addi	s1,s1,8
    800029f4:	00890913          	addi	s2,s2,8
    800029f8:	01348c63          	beq	s1,s3,80002a10 <fork+0xe4>
    if(p->ofile[i])
    800029fc:	0004b503          	ld	a0,0(s1)
    80002a00:	fe0508e3          	beqz	a0,800029f0 <fork+0xc4>
      np->ofile[i] = filedup(p->ofile[i]);
    80002a04:	0c0030ef          	jal	80005ac4 <filedup>
    80002a08:	00a93023          	sd	a0,0(s2)
    80002a0c:	fe5ff06f          	j	800029f0 <fork+0xc4>
  np->cwd = idup(p->cwd);
    80002a10:	150ab503          	ld	a0,336(s5)
    80002a14:	60d010ef          	jal	80004820 <idup>
    80002a18:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002a1c:	01000613          	li	a2,16
    80002a20:	158a8593          	addi	a1,s5,344
    80002a24:	158a0513          	addi	a0,s4,344
    80002a28:	941fe0ef          	jal	80001368 <safestrcpy>
  pid = np->pid;
    80002a2c:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80002a30:	000a0513          	mv	a0,s4
    80002a34:	ef0fe0ef          	jal	80001124 <release>
  acquire(&wait_lock);
    80002a38:	0000f497          	auipc	s1,0xf
    80002a3c:	01048493          	addi	s1,s1,16 # 80011a48 <wait_lock>
    80002a40:	00048513          	mv	a0,s1
    80002a44:	e04fe0ef          	jal	80001048 <acquire>
  np->parent = p;
    80002a48:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80002a4c:	00048513          	mv	a0,s1
    80002a50:	ed4fe0ef          	jal	80001124 <release>
  acquire(&np->lock);
    80002a54:	000a0513          	mv	a0,s4
    80002a58:	df0fe0ef          	jal	80001048 <acquire>
  np->state = RUNNABLE;
    80002a5c:	00300793          	li	a5,3
    80002a60:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80002a64:	000a0513          	mv	a0,s4
    80002a68:	ebcfe0ef          	jal	80001124 <release>
  return pid;
    80002a6c:	02813483          	ld	s1,40(sp)
    80002a70:	01813983          	ld	s3,24(sp)
    80002a74:	01013a03          	ld	s4,16(sp)
}
    80002a78:	00090513          	mv	a0,s2
    80002a7c:	03813083          	ld	ra,56(sp)
    80002a80:	03013403          	ld	s0,48(sp)
    80002a84:	02013903          	ld	s2,32(sp)
    80002a88:	00813a83          	ld	s5,8(sp)
    80002a8c:	04010113          	addi	sp,sp,64
    80002a90:	00008067          	ret
    return -1;
    80002a94:	fff00913          	li	s2,-1
    80002a98:	fe1ff06f          	j	80002a78 <fork+0x14c>

0000000080002a9c <scheduler>:
{
    80002a9c:	fb010113          	addi	sp,sp,-80
    80002aa0:	04113423          	sd	ra,72(sp)
    80002aa4:	04813023          	sd	s0,64(sp)
    80002aa8:	02913c23          	sd	s1,56(sp)
    80002aac:	03213823          	sd	s2,48(sp)
    80002ab0:	03313423          	sd	s3,40(sp)
    80002ab4:	03413023          	sd	s4,32(sp)
    80002ab8:	01513c23          	sd	s5,24(sp)
    80002abc:	01613823          	sd	s6,16(sp)
    80002ac0:	01713423          	sd	s7,8(sp)
    80002ac4:	01813023          	sd	s8,0(sp)
    80002ac8:	05010413          	addi	s0,sp,80
    80002acc:	00020793          	mv	a5,tp
  int id = r_tp();
    80002ad0:	0007879b          	sext.w	a5,a5
  c->proc = 0;
    80002ad4:	00779b13          	slli	s6,a5,0x7
    80002ad8:	0000f717          	auipc	a4,0xf
    80002adc:	f5870713          	addi	a4,a4,-168 # 80011a30 <pid_lock>
    80002ae0:	01670733          	add	a4,a4,s6
    80002ae4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002ae8:	0000f717          	auipc	a4,0xf
    80002aec:	f8070713          	addi	a4,a4,-128 # 80011a68 <cpus+0x8>
    80002af0:	00eb0b33          	add	s6,s6,a4
        p->state = RUNNING;
    80002af4:	00400c13          	li	s8,4
        c->proc = p;
    80002af8:	00779793          	slli	a5,a5,0x7
    80002afc:	0000fa17          	auipc	s4,0xf
    80002b00:	f34a0a13          	addi	s4,s4,-204 # 80011a30 <pid_lock>
    80002b04:	00fa0a33          	add	s4,s4,a5
        found = 1;
    80002b08:	00100b93          	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80002b0c:	00015997          	auipc	s3,0x15
    80002b10:	d5498993          	addi	s3,s3,-684 # 80017860 <tickslock>
    80002b14:	0580006f          	j	80002b6c <scheduler+0xd0>
      release(&p->lock);
    80002b18:	00048513          	mv	a0,s1
    80002b1c:	e08fe0ef          	jal	80001124 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002b20:	16848493          	addi	s1,s1,360
    80002b24:	03348a63          	beq	s1,s3,80002b58 <scheduler+0xbc>
      acquire(&p->lock);
    80002b28:	00048513          	mv	a0,s1
    80002b2c:	d1cfe0ef          	jal	80001048 <acquire>
      if(p->state == RUNNABLE) {
    80002b30:	0184a783          	lw	a5,24(s1)
    80002b34:	ff2792e3          	bne	a5,s2,80002b18 <scheduler+0x7c>
        p->state = RUNNING;
    80002b38:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80002b3c:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80002b40:	06048593          	addi	a1,s1,96
    80002b44:	000b0513          	mv	a0,s6
    80002b48:	06d000ef          	jal	800033b4 <swtch>
        c->proc = 0;
    80002b4c:	020a3823          	sd	zero,48(s4)
        found = 1;
    80002b50:	000b8a93          	mv	s5,s7
    80002b54:	fc5ff06f          	j	80002b18 <scheduler+0x7c>
    if(found == 0) {
    80002b58:	000a9a63          	bnez	s5,80002b6c <scheduler+0xd0>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b5c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002b60:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b64:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80002b68:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b6c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002b70:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b74:	10079073          	csrw	sstatus,a5
    int found = 0;
    80002b78:	00000a93          	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80002b7c:	0000f497          	auipc	s1,0xf
    80002b80:	2e448493          	addi	s1,s1,740 # 80011e60 <proc>
      if(p->state == RUNNABLE) {
    80002b84:	00300913          	li	s2,3
    80002b88:	fa1ff06f          	j	80002b28 <scheduler+0x8c>

0000000080002b8c <sched>:
{
    80002b8c:	fd010113          	addi	sp,sp,-48
    80002b90:	02113423          	sd	ra,40(sp)
    80002b94:	02813023          	sd	s0,32(sp)
    80002b98:	00913c23          	sd	s1,24(sp)
    80002b9c:	01213823          	sd	s2,16(sp)
    80002ba0:	01313423          	sd	s3,8(sp)
    80002ba4:	03010413          	addi	s0,sp,48
  struct proc *p = myproc();
    80002ba8:	8b5ff0ef          	jal	8000245c <myproc>
    80002bac:	00050493          	mv	s1,a0
  if(!holding(&p->lock))
    80002bb0:	be8fe0ef          	jal	80000f98 <holding>
    80002bb4:	0a050663          	beqz	a0,80002c60 <sched+0xd4>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002bb8:	00020793          	mv	a5,tp
  if(mycpu()->noff != 1)
    80002bbc:	0007879b          	sext.w	a5,a5
    80002bc0:	00779793          	slli	a5,a5,0x7
    80002bc4:	0000f717          	auipc	a4,0xf
    80002bc8:	e6c70713          	addi	a4,a4,-404 # 80011a30 <pid_lock>
    80002bcc:	00f707b3          	add	a5,a4,a5
    80002bd0:	0a87a703          	lw	a4,168(a5)
    80002bd4:	00100793          	li	a5,1
    80002bd8:	08f71a63          	bne	a4,a5,80002c6c <sched+0xe0>
  if(p->state == RUNNING)
    80002bdc:	0184a703          	lw	a4,24(s1)
    80002be0:	00400793          	li	a5,4
    80002be4:	08f70a63          	beq	a4,a5,80002c78 <sched+0xec>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002be8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002bec:	0027f793          	andi	a5,a5,2
  if(intr_get())
    80002bf0:	08079a63          	bnez	a5,80002c84 <sched+0xf8>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002bf4:	00020793          	mv	a5,tp
  intena = mycpu()->intena;
    80002bf8:	0000f917          	auipc	s2,0xf
    80002bfc:	e3890913          	addi	s2,s2,-456 # 80011a30 <pid_lock>
    80002c00:	0007879b          	sext.w	a5,a5
    80002c04:	00779793          	slli	a5,a5,0x7
    80002c08:	00f907b3          	add	a5,s2,a5
    80002c0c:	0ac7a983          	lw	s3,172(a5)
    80002c10:	00020793          	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002c14:	0007879b          	sext.w	a5,a5
    80002c18:	00779793          	slli	a5,a5,0x7
    80002c1c:	0000f597          	auipc	a1,0xf
    80002c20:	e4c58593          	addi	a1,a1,-436 # 80011a68 <cpus+0x8>
    80002c24:	00b785b3          	add	a1,a5,a1
    80002c28:	06048513          	addi	a0,s1,96
    80002c2c:	788000ef          	jal	800033b4 <swtch>
    80002c30:	00020793          	mv	a5,tp
  mycpu()->intena = intena;
    80002c34:	0007879b          	sext.w	a5,a5
    80002c38:	00779793          	slli	a5,a5,0x7
    80002c3c:	00f90933          	add	s2,s2,a5
    80002c40:	0b392623          	sw	s3,172(s2)
}
    80002c44:	02813083          	ld	ra,40(sp)
    80002c48:	02013403          	ld	s0,32(sp)
    80002c4c:	01813483          	ld	s1,24(sp)
    80002c50:	01013903          	ld	s2,16(sp)
    80002c54:	00813983          	ld	s3,8(sp)
    80002c58:	03010113          	addi	sp,sp,48
    80002c5c:	00008067          	ret
    panic("sched p->lock");
    80002c60:	00006517          	auipc	a0,0x6
    80002c64:	5d850513          	addi	a0,a0,1496 # 80009238 <etext+0x238>
    80002c68:	d99fd0ef          	jal	80000a00 <panic>
    panic("sched locks");
    80002c6c:	00006517          	auipc	a0,0x6
    80002c70:	5dc50513          	addi	a0,a0,1500 # 80009248 <etext+0x248>
    80002c74:	d8dfd0ef          	jal	80000a00 <panic>
    panic("sched running");
    80002c78:	00006517          	auipc	a0,0x6
    80002c7c:	5e050513          	addi	a0,a0,1504 # 80009258 <etext+0x258>
    80002c80:	d81fd0ef          	jal	80000a00 <panic>
    panic("sched interruptible");
    80002c84:	00006517          	auipc	a0,0x6
    80002c88:	5e450513          	addi	a0,a0,1508 # 80009268 <etext+0x268>
    80002c8c:	d75fd0ef          	jal	80000a00 <panic>

0000000080002c90 <yield>:
{
    80002c90:	fe010113          	addi	sp,sp,-32
    80002c94:	00113c23          	sd	ra,24(sp)
    80002c98:	00813823          	sd	s0,16(sp)
    80002c9c:	00913423          	sd	s1,8(sp)
    80002ca0:	02010413          	addi	s0,sp,32
  struct proc *p = myproc();
    80002ca4:	fb8ff0ef          	jal	8000245c <myproc>
    80002ca8:	00050493          	mv	s1,a0
  acquire(&p->lock);
    80002cac:	b9cfe0ef          	jal	80001048 <acquire>
  p->state = RUNNABLE;
    80002cb0:	00300793          	li	a5,3
    80002cb4:	00f4ac23          	sw	a5,24(s1)
  sched();
    80002cb8:	ed5ff0ef          	jal	80002b8c <sched>
  release(&p->lock);
    80002cbc:	00048513          	mv	a0,s1
    80002cc0:	c64fe0ef          	jal	80001124 <release>
}
    80002cc4:	01813083          	ld	ra,24(sp)
    80002cc8:	01013403          	ld	s0,16(sp)
    80002ccc:	00813483          	ld	s1,8(sp)
    80002cd0:	02010113          	addi	sp,sp,32
    80002cd4:	00008067          	ret

0000000080002cd8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002cd8:	fd010113          	addi	sp,sp,-48
    80002cdc:	02113423          	sd	ra,40(sp)
    80002ce0:	02813023          	sd	s0,32(sp)
    80002ce4:	00913c23          	sd	s1,24(sp)
    80002ce8:	01213823          	sd	s2,16(sp)
    80002cec:	01313423          	sd	s3,8(sp)
    80002cf0:	03010413          	addi	s0,sp,48
    80002cf4:	00050993          	mv	s3,a0
    80002cf8:	00058913          	mv	s2,a1
  struct proc *p = myproc();
    80002cfc:	f60ff0ef          	jal	8000245c <myproc>
    80002d00:	00050493          	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002d04:	b44fe0ef          	jal	80001048 <acquire>
  release(lk);
    80002d08:	00090513          	mv	a0,s2
    80002d0c:	c18fe0ef          	jal	80001124 <release>

  // Go to sleep.
  p->chan = chan;
    80002d10:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002d14:	00200793          	li	a5,2
    80002d18:	00f4ac23          	sw	a5,24(s1)

  sched();
    80002d1c:	e71ff0ef          	jal	80002b8c <sched>

  // Tidy up.
  p->chan = 0;
    80002d20:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002d24:	00048513          	mv	a0,s1
    80002d28:	bfcfe0ef          	jal	80001124 <release>
  acquire(lk);
    80002d2c:	00090513          	mv	a0,s2
    80002d30:	b18fe0ef          	jal	80001048 <acquire>
}
    80002d34:	02813083          	ld	ra,40(sp)
    80002d38:	02013403          	ld	s0,32(sp)
    80002d3c:	01813483          	ld	s1,24(sp)
    80002d40:	01013903          	ld	s2,16(sp)
    80002d44:	00813983          	ld	s3,8(sp)
    80002d48:	03010113          	addi	sp,sp,48
    80002d4c:	00008067          	ret

0000000080002d50 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002d50:	fc010113          	addi	sp,sp,-64
    80002d54:	02113c23          	sd	ra,56(sp)
    80002d58:	02813823          	sd	s0,48(sp)
    80002d5c:	02913423          	sd	s1,40(sp)
    80002d60:	03213023          	sd	s2,32(sp)
    80002d64:	01313c23          	sd	s3,24(sp)
    80002d68:	01413823          	sd	s4,16(sp)
    80002d6c:	01513423          	sd	s5,8(sp)
    80002d70:	04010413          	addi	s0,sp,64
    80002d74:	00050a13          	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002d78:	0000f497          	auipc	s1,0xf
    80002d7c:	0e848493          	addi	s1,s1,232 # 80011e60 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002d80:	00200993          	li	s3,2
        p->state = RUNNABLE;
    80002d84:	00300a93          	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002d88:	00015917          	auipc	s2,0x15
    80002d8c:	ad890913          	addi	s2,s2,-1320 # 80017860 <tickslock>
    80002d90:	0140006f          	j	80002da4 <wakeup+0x54>
      }
      release(&p->lock);
    80002d94:	00048513          	mv	a0,s1
    80002d98:	b8cfe0ef          	jal	80001124 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002d9c:	16848493          	addi	s1,s1,360
    80002da0:	03248663          	beq	s1,s2,80002dcc <wakeup+0x7c>
    if(p != myproc()){
    80002da4:	eb8ff0ef          	jal	8000245c <myproc>
    80002da8:	fea48ae3          	beq	s1,a0,80002d9c <wakeup+0x4c>
      acquire(&p->lock);
    80002dac:	00048513          	mv	a0,s1
    80002db0:	a98fe0ef          	jal	80001048 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002db4:	0184a783          	lw	a5,24(s1)
    80002db8:	fd379ee3          	bne	a5,s3,80002d94 <wakeup+0x44>
    80002dbc:	0204b783          	ld	a5,32(s1)
    80002dc0:	fd479ae3          	bne	a5,s4,80002d94 <wakeup+0x44>
        p->state = RUNNABLE;
    80002dc4:	0154ac23          	sw	s5,24(s1)
    80002dc8:	fcdff06f          	j	80002d94 <wakeup+0x44>
    }
  }
}
    80002dcc:	03813083          	ld	ra,56(sp)
    80002dd0:	03013403          	ld	s0,48(sp)
    80002dd4:	02813483          	ld	s1,40(sp)
    80002dd8:	02013903          	ld	s2,32(sp)
    80002ddc:	01813983          	ld	s3,24(sp)
    80002de0:	01013a03          	ld	s4,16(sp)
    80002de4:	00813a83          	ld	s5,8(sp)
    80002de8:	04010113          	addi	sp,sp,64
    80002dec:	00008067          	ret

0000000080002df0 <reparent>:
{
    80002df0:	fd010113          	addi	sp,sp,-48
    80002df4:	02113423          	sd	ra,40(sp)
    80002df8:	02813023          	sd	s0,32(sp)
    80002dfc:	00913c23          	sd	s1,24(sp)
    80002e00:	01213823          	sd	s2,16(sp)
    80002e04:	01313423          	sd	s3,8(sp)
    80002e08:	01413023          	sd	s4,0(sp)
    80002e0c:	03010413          	addi	s0,sp,48
    80002e10:	00050913          	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002e14:	0000f497          	auipc	s1,0xf
    80002e18:	04c48493          	addi	s1,s1,76 # 80011e60 <proc>
      pp->parent = initproc;
    80002e1c:	00007a17          	auipc	s4,0x7
    80002e20:	adca0a13          	addi	s4,s4,-1316 # 800098f8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002e24:	00015997          	auipc	s3,0x15
    80002e28:	a3c98993          	addi	s3,s3,-1476 # 80017860 <tickslock>
    80002e2c:	00c0006f          	j	80002e38 <reparent+0x48>
    80002e30:	16848493          	addi	s1,s1,360
    80002e34:	01348e63          	beq	s1,s3,80002e50 <reparent+0x60>
    if(pp->parent == p){
    80002e38:	0384b783          	ld	a5,56(s1)
    80002e3c:	ff279ae3          	bne	a5,s2,80002e30 <reparent+0x40>
      pp->parent = initproc;
    80002e40:	000a3503          	ld	a0,0(s4)
    80002e44:	02a4bc23          	sd	a0,56(s1)
      wakeup(initproc);
    80002e48:	f09ff0ef          	jal	80002d50 <wakeup>
    80002e4c:	fe5ff06f          	j	80002e30 <reparent+0x40>
}
    80002e50:	02813083          	ld	ra,40(sp)
    80002e54:	02013403          	ld	s0,32(sp)
    80002e58:	01813483          	ld	s1,24(sp)
    80002e5c:	01013903          	ld	s2,16(sp)
    80002e60:	00813983          	ld	s3,8(sp)
    80002e64:	00013a03          	ld	s4,0(sp)
    80002e68:	03010113          	addi	sp,sp,48
    80002e6c:	00008067          	ret

0000000080002e70 <exit>:
{
    80002e70:	fd010113          	addi	sp,sp,-48
    80002e74:	02113423          	sd	ra,40(sp)
    80002e78:	02813023          	sd	s0,32(sp)
    80002e7c:	00913c23          	sd	s1,24(sp)
    80002e80:	01213823          	sd	s2,16(sp)
    80002e84:	01313423          	sd	s3,8(sp)
    80002e88:	01413023          	sd	s4,0(sp)
    80002e8c:	03010413          	addi	s0,sp,48
    80002e90:	00050a13          	mv	s4,a0
  struct proc *p = myproc();
    80002e94:	dc8ff0ef          	jal	8000245c <myproc>
    80002e98:	00050993          	mv	s3,a0
  if(p == initproc)
    80002e9c:	00007797          	auipc	a5,0x7
    80002ea0:	a5c7b783          	ld	a5,-1444(a5) # 800098f8 <initproc>
    80002ea4:	0d050493          	addi	s1,a0,208
    80002ea8:	15050913          	addi	s2,a0,336
    80002eac:	02a79063          	bne	a5,a0,80002ecc <exit+0x5c>
    panic("init exiting");
    80002eb0:	00006517          	auipc	a0,0x6
    80002eb4:	3d050513          	addi	a0,a0,976 # 80009280 <etext+0x280>
    80002eb8:	b49fd0ef          	jal	80000a00 <panic>
      fileclose(f);
    80002ebc:	46d020ef          	jal	80005b28 <fileclose>
      p->ofile[fd] = 0;
    80002ec0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002ec4:	00848493          	addi	s1,s1,8
    80002ec8:	01248863          	beq	s1,s2,80002ed8 <exit+0x68>
    if(p->ofile[fd]){
    80002ecc:	0004b503          	ld	a0,0(s1)
    80002ed0:	fe0516e3          	bnez	a0,80002ebc <exit+0x4c>
    80002ed4:	ff1ff06f          	j	80002ec4 <exit+0x54>
  begin_op();
    80002ed8:	66c020ef          	jal	80005544 <begin_op>
  iput(p->cwd);
    80002edc:	1509b503          	ld	a0,336(s3)
    80002ee0:	3c1010ef          	jal	80004aa0 <iput>
  end_op();
    80002ee4:	700020ef          	jal	800055e4 <end_op>
  p->cwd = 0;
    80002ee8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002eec:	0000f497          	auipc	s1,0xf
    80002ef0:	b5c48493          	addi	s1,s1,-1188 # 80011a48 <wait_lock>
    80002ef4:	00048513          	mv	a0,s1
    80002ef8:	950fe0ef          	jal	80001048 <acquire>
  reparent(p);
    80002efc:	00098513          	mv	a0,s3
    80002f00:	ef1ff0ef          	jal	80002df0 <reparent>
  wakeup(p->parent);
    80002f04:	0389b503          	ld	a0,56(s3)
    80002f08:	e49ff0ef          	jal	80002d50 <wakeup>
  acquire(&p->lock);
    80002f0c:	00098513          	mv	a0,s3
    80002f10:	938fe0ef          	jal	80001048 <acquire>
  p->xstate = status;
    80002f14:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002f18:	00500793          	li	a5,5
    80002f1c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002f20:	00048513          	mv	a0,s1
    80002f24:	a00fe0ef          	jal	80001124 <release>
  sched();
    80002f28:	c65ff0ef          	jal	80002b8c <sched>
  panic("zombie exit");
    80002f2c:	00006517          	auipc	a0,0x6
    80002f30:	36450513          	addi	a0,a0,868 # 80009290 <etext+0x290>
    80002f34:	acdfd0ef          	jal	80000a00 <panic>

0000000080002f38 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002f38:	fd010113          	addi	sp,sp,-48
    80002f3c:	02113423          	sd	ra,40(sp)
    80002f40:	02813023          	sd	s0,32(sp)
    80002f44:	00913c23          	sd	s1,24(sp)
    80002f48:	01213823          	sd	s2,16(sp)
    80002f4c:	01313423          	sd	s3,8(sp)
    80002f50:	03010413          	addi	s0,sp,48
    80002f54:	00050913          	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002f58:	0000f497          	auipc	s1,0xf
    80002f5c:	f0848493          	addi	s1,s1,-248 # 80011e60 <proc>
    80002f60:	00015997          	auipc	s3,0x15
    80002f64:	90098993          	addi	s3,s3,-1792 # 80017860 <tickslock>
    acquire(&p->lock);
    80002f68:	00048513          	mv	a0,s1
    80002f6c:	8dcfe0ef          	jal	80001048 <acquire>
    if(p->pid == pid){
    80002f70:	0304a783          	lw	a5,48(s1)
    80002f74:	01278e63          	beq	a5,s2,80002f90 <kill+0x58>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002f78:	00048513          	mv	a0,s1
    80002f7c:	9a8fe0ef          	jal	80001124 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002f80:	16848493          	addi	s1,s1,360
    80002f84:	ff3492e3          	bne	s1,s3,80002f68 <kill+0x30>
  }
  return -1;
    80002f88:	fff00513          	li	a0,-1
    80002f8c:	0240006f          	j	80002fb0 <kill+0x78>
      p->killed = 1;
    80002f90:	00100793          	li	a5,1
    80002f94:	02f4a423          	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002f98:	0184a703          	lw	a4,24(s1)
    80002f9c:	00200793          	li	a5,2
    80002fa0:	02f70663          	beq	a4,a5,80002fcc <kill+0x94>
      release(&p->lock);
    80002fa4:	00048513          	mv	a0,s1
    80002fa8:	97cfe0ef          	jal	80001124 <release>
      return 0;
    80002fac:	00000513          	li	a0,0
}
    80002fb0:	02813083          	ld	ra,40(sp)
    80002fb4:	02013403          	ld	s0,32(sp)
    80002fb8:	01813483          	ld	s1,24(sp)
    80002fbc:	01013903          	ld	s2,16(sp)
    80002fc0:	00813983          	ld	s3,8(sp)
    80002fc4:	03010113          	addi	sp,sp,48
    80002fc8:	00008067          	ret
        p->state = RUNNABLE;
    80002fcc:	00300793          	li	a5,3
    80002fd0:	00f4ac23          	sw	a5,24(s1)
    80002fd4:	fd1ff06f          	j	80002fa4 <kill+0x6c>

0000000080002fd8 <setkilled>:

void
setkilled(struct proc *p)
{
    80002fd8:	fe010113          	addi	sp,sp,-32
    80002fdc:	00113c23          	sd	ra,24(sp)
    80002fe0:	00813823          	sd	s0,16(sp)
    80002fe4:	00913423          	sd	s1,8(sp)
    80002fe8:	02010413          	addi	s0,sp,32
    80002fec:	00050493          	mv	s1,a0
  acquire(&p->lock);
    80002ff0:	858fe0ef          	jal	80001048 <acquire>
  p->killed = 1;
    80002ff4:	00100793          	li	a5,1
    80002ff8:	02f4a423          	sw	a5,40(s1)
  release(&p->lock);
    80002ffc:	00048513          	mv	a0,s1
    80003000:	924fe0ef          	jal	80001124 <release>
}
    80003004:	01813083          	ld	ra,24(sp)
    80003008:	01013403          	ld	s0,16(sp)
    8000300c:	00813483          	ld	s1,8(sp)
    80003010:	02010113          	addi	sp,sp,32
    80003014:	00008067          	ret

0000000080003018 <killed>:

int
killed(struct proc *p)
{
    80003018:	fe010113          	addi	sp,sp,-32
    8000301c:	00113c23          	sd	ra,24(sp)
    80003020:	00813823          	sd	s0,16(sp)
    80003024:	00913423          	sd	s1,8(sp)
    80003028:	01213023          	sd	s2,0(sp)
    8000302c:	02010413          	addi	s0,sp,32
    80003030:	00050493          	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80003034:	814fe0ef          	jal	80001048 <acquire>
  k = p->killed;
    80003038:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000303c:	00048513          	mv	a0,s1
    80003040:	8e4fe0ef          	jal	80001124 <release>
  return k;
}
    80003044:	00090513          	mv	a0,s2
    80003048:	01813083          	ld	ra,24(sp)
    8000304c:	01013403          	ld	s0,16(sp)
    80003050:	00813483          	ld	s1,8(sp)
    80003054:	00013903          	ld	s2,0(sp)
    80003058:	02010113          	addi	sp,sp,32
    8000305c:	00008067          	ret

0000000080003060 <wait>:
{
    80003060:	fb010113          	addi	sp,sp,-80
    80003064:	04113423          	sd	ra,72(sp)
    80003068:	04813023          	sd	s0,64(sp)
    8000306c:	02913c23          	sd	s1,56(sp)
    80003070:	03213823          	sd	s2,48(sp)
    80003074:	03313423          	sd	s3,40(sp)
    80003078:	03413023          	sd	s4,32(sp)
    8000307c:	01513c23          	sd	s5,24(sp)
    80003080:	01613823          	sd	s6,16(sp)
    80003084:	01713423          	sd	s7,8(sp)
    80003088:	01813023          	sd	s8,0(sp)
    8000308c:	05010413          	addi	s0,sp,80
    80003090:	00050b13          	mv	s6,a0
  struct proc *p = myproc();
    80003094:	bc8ff0ef          	jal	8000245c <myproc>
    80003098:	00050913          	mv	s2,a0
  acquire(&wait_lock);
    8000309c:	0000f517          	auipc	a0,0xf
    800030a0:	9ac50513          	addi	a0,a0,-1620 # 80011a48 <wait_lock>
    800030a4:	fa5fd0ef          	jal	80001048 <acquire>
    havekids = 0;
    800030a8:	00000b93          	li	s7,0
        if(pp->state == ZOMBIE){
    800030ac:	00500a13          	li	s4,5
        havekids = 1;
    800030b0:	00100a93          	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800030b4:	00014997          	auipc	s3,0x14
    800030b8:	7ac98993          	addi	s3,s3,1964 # 80017860 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800030bc:	0000fc17          	auipc	s8,0xf
    800030c0:	98cc0c13          	addi	s8,s8,-1652 # 80011a48 <wait_lock>
    800030c4:	0dc0006f          	j	800031a0 <wait+0x140>
          pid = pp->pid;
    800030c8:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800030cc:	000b0e63          	beqz	s6,800030e8 <wait+0x88>
    800030d0:	00400693          	li	a3,4
    800030d4:	02c48613          	addi	a2,s1,44
    800030d8:	000b0593          	mv	a1,s6
    800030dc:	05093503          	ld	a0,80(s2)
    800030e0:	dd5fe0ef          	jal	80001eb4 <copyout>
    800030e4:	04054a63          	bltz	a0,80003138 <wait+0xd8>
          freeproc(pp);
    800030e8:	00048513          	mv	a0,s1
    800030ec:	db8ff0ef          	jal	800026a4 <freeproc>
          release(&pp->lock);
    800030f0:	00048513          	mv	a0,s1
    800030f4:	830fe0ef          	jal	80001124 <release>
          release(&wait_lock);
    800030f8:	0000f517          	auipc	a0,0xf
    800030fc:	95050513          	addi	a0,a0,-1712 # 80011a48 <wait_lock>
    80003100:	824fe0ef          	jal	80001124 <release>
}
    80003104:	00098513          	mv	a0,s3
    80003108:	04813083          	ld	ra,72(sp)
    8000310c:	04013403          	ld	s0,64(sp)
    80003110:	03813483          	ld	s1,56(sp)
    80003114:	03013903          	ld	s2,48(sp)
    80003118:	02813983          	ld	s3,40(sp)
    8000311c:	02013a03          	ld	s4,32(sp)
    80003120:	01813a83          	ld	s5,24(sp)
    80003124:	01013b03          	ld	s6,16(sp)
    80003128:	00813b83          	ld	s7,8(sp)
    8000312c:	00013c03          	ld	s8,0(sp)
    80003130:	05010113          	addi	sp,sp,80
    80003134:	00008067          	ret
            release(&pp->lock);
    80003138:	00048513          	mv	a0,s1
    8000313c:	fe9fd0ef          	jal	80001124 <release>
            release(&wait_lock);
    80003140:	0000f517          	auipc	a0,0xf
    80003144:	90850513          	addi	a0,a0,-1784 # 80011a48 <wait_lock>
    80003148:	fddfd0ef          	jal	80001124 <release>
            return -1;
    8000314c:	fff00993          	li	s3,-1
    80003150:	fb5ff06f          	j	80003104 <wait+0xa4>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80003154:	16848493          	addi	s1,s1,360
    80003158:	03348663          	beq	s1,s3,80003184 <wait+0x124>
      if(pp->parent == p){
    8000315c:	0384b783          	ld	a5,56(s1)
    80003160:	ff279ae3          	bne	a5,s2,80003154 <wait+0xf4>
        acquire(&pp->lock);
    80003164:	00048513          	mv	a0,s1
    80003168:	ee1fd0ef          	jal	80001048 <acquire>
        if(pp->state == ZOMBIE){
    8000316c:	0184a783          	lw	a5,24(s1)
    80003170:	f5478ce3          	beq	a5,s4,800030c8 <wait+0x68>
        release(&pp->lock);
    80003174:	00048513          	mv	a0,s1
    80003178:	fadfd0ef          	jal	80001124 <release>
        havekids = 1;
    8000317c:	000a8713          	mv	a4,s5
    80003180:	fd5ff06f          	j	80003154 <wait+0xf4>
    if(!havekids || killed(p)){
    80003184:	02070663          	beqz	a4,800031b0 <wait+0x150>
    80003188:	00090513          	mv	a0,s2
    8000318c:	e8dff0ef          	jal	80003018 <killed>
    80003190:	02051063          	bnez	a0,800031b0 <wait+0x150>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80003194:	000c0593          	mv	a1,s8
    80003198:	00090513          	mv	a0,s2
    8000319c:	b3dff0ef          	jal	80002cd8 <sleep>
    havekids = 0;
    800031a0:	000b8713          	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800031a4:	0000f497          	auipc	s1,0xf
    800031a8:	cbc48493          	addi	s1,s1,-836 # 80011e60 <proc>
    800031ac:	fb1ff06f          	j	8000315c <wait+0xfc>
      release(&wait_lock);
    800031b0:	0000f517          	auipc	a0,0xf
    800031b4:	89850513          	addi	a0,a0,-1896 # 80011a48 <wait_lock>
    800031b8:	f6dfd0ef          	jal	80001124 <release>
      return -1;
    800031bc:	fff00993          	li	s3,-1
    800031c0:	f45ff06f          	j	80003104 <wait+0xa4>

00000000800031c4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800031c4:	fd010113          	addi	sp,sp,-48
    800031c8:	02113423          	sd	ra,40(sp)
    800031cc:	02813023          	sd	s0,32(sp)
    800031d0:	00913c23          	sd	s1,24(sp)
    800031d4:	01213823          	sd	s2,16(sp)
    800031d8:	01313423          	sd	s3,8(sp)
    800031dc:	01413023          	sd	s4,0(sp)
    800031e0:	03010413          	addi	s0,sp,48
    800031e4:	00050493          	mv	s1,a0
    800031e8:	00058913          	mv	s2,a1
    800031ec:	00060993          	mv	s3,a2
    800031f0:	00068a13          	mv	s4,a3
  struct proc *p = myproc();
    800031f4:	a68ff0ef          	jal	8000245c <myproc>
  if(user_dst){
    800031f8:	02048c63          	beqz	s1,80003230 <either_copyout+0x6c>
    return copyout(p->pagetable, dst, src, len);
    800031fc:	000a0693          	mv	a3,s4
    80003200:	00098613          	mv	a2,s3
    80003204:	00090593          	mv	a1,s2
    80003208:	05053503          	ld	a0,80(a0)
    8000320c:	ca9fe0ef          	jal	80001eb4 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80003210:	02813083          	ld	ra,40(sp)
    80003214:	02013403          	ld	s0,32(sp)
    80003218:	01813483          	ld	s1,24(sp)
    8000321c:	01013903          	ld	s2,16(sp)
    80003220:	00813983          	ld	s3,8(sp)
    80003224:	00013a03          	ld	s4,0(sp)
    80003228:	03010113          	addi	sp,sp,48
    8000322c:	00008067          	ret
    memmove((char *)dst, src, len);
    80003230:	000a061b          	sext.w	a2,s4
    80003234:	00098593          	mv	a1,s3
    80003238:	00090513          	mv	a0,s2
    8000323c:	fd1fd0ef          	jal	8000120c <memmove>
    return 0;
    80003240:	00048513          	mv	a0,s1
    80003244:	fcdff06f          	j	80003210 <either_copyout+0x4c>

0000000080003248 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80003248:	fd010113          	addi	sp,sp,-48
    8000324c:	02113423          	sd	ra,40(sp)
    80003250:	02813023          	sd	s0,32(sp)
    80003254:	00913c23          	sd	s1,24(sp)
    80003258:	01213823          	sd	s2,16(sp)
    8000325c:	01313423          	sd	s3,8(sp)
    80003260:	01413023          	sd	s4,0(sp)
    80003264:	03010413          	addi	s0,sp,48
    80003268:	00050913          	mv	s2,a0
    8000326c:	00058493          	mv	s1,a1
    80003270:	00060993          	mv	s3,a2
    80003274:	00068a13          	mv	s4,a3
  struct proc *p = myproc();
    80003278:	9e4ff0ef          	jal	8000245c <myproc>
  if(user_src){
    8000327c:	02048c63          	beqz	s1,800032b4 <either_copyin+0x6c>
    return copyin(p->pagetable, dst, src, len);
    80003280:	000a0693          	mv	a3,s4
    80003284:	00098613          	mv	a2,s3
    80003288:	00090593          	mv	a1,s2
    8000328c:	05053503          	ld	a0,80(a0)
    80003290:	d9dfe0ef          	jal	8000202c <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80003294:	02813083          	ld	ra,40(sp)
    80003298:	02013403          	ld	s0,32(sp)
    8000329c:	01813483          	ld	s1,24(sp)
    800032a0:	01013903          	ld	s2,16(sp)
    800032a4:	00813983          	ld	s3,8(sp)
    800032a8:	00013a03          	ld	s4,0(sp)
    800032ac:	03010113          	addi	sp,sp,48
    800032b0:	00008067          	ret
    memmove(dst, (char*)src, len);
    800032b4:	000a061b          	sext.w	a2,s4
    800032b8:	00098593          	mv	a1,s3
    800032bc:	00090513          	mv	a0,s2
    800032c0:	f4dfd0ef          	jal	8000120c <memmove>
    return 0;
    800032c4:	00048513          	mv	a0,s1
    800032c8:	fcdff06f          	j	80003294 <either_copyin+0x4c>

00000000800032cc <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800032cc:	fb010113          	addi	sp,sp,-80
    800032d0:	04113423          	sd	ra,72(sp)
    800032d4:	04813023          	sd	s0,64(sp)
    800032d8:	02913c23          	sd	s1,56(sp)
    800032dc:	03213823          	sd	s2,48(sp)
    800032e0:	03313423          	sd	s3,40(sp)
    800032e4:	03413023          	sd	s4,32(sp)
    800032e8:	01513c23          	sd	s5,24(sp)
    800032ec:	01613823          	sd	s6,16(sp)
    800032f0:	01713423          	sd	s7,8(sp)
    800032f4:	05010413          	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800032f8:	00006517          	auipc	a0,0x6
    800032fc:	d8050513          	addi	a0,a0,-640 # 80009078 <etext+0x78>
    80003300:	b5cfd0ef          	jal	8000065c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80003304:	0000f497          	auipc	s1,0xf
    80003308:	cb448493          	addi	s1,s1,-844 # 80011fb8 <proc+0x158>
    8000330c:	00014917          	auipc	s2,0x14
    80003310:	6ac90913          	addi	s2,s2,1708 # 800179b8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80003314:	00500b13          	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80003318:	00006997          	auipc	s3,0x6
    8000331c:	f8898993          	addi	s3,s3,-120 # 800092a0 <etext+0x2a0>
    printf("%d %s %s", p->pid, state, p->name);
    80003320:	00006a97          	auipc	s5,0x6
    80003324:	f88a8a93          	addi	s5,s5,-120 # 800092a8 <etext+0x2a8>
    printf("\n");
    80003328:	00006a17          	auipc	s4,0x6
    8000332c:	d50a0a13          	addi	s4,s4,-688 # 80009078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80003330:	00006b97          	auipc	s7,0x6
    80003334:	458b8b93          	addi	s7,s7,1112 # 80009788 <states.0>
    80003338:	0200006f          	j	80003358 <procdump+0x8c>
    printf("%d %s %s", p->pid, state, p->name);
    8000333c:	ed86a583          	lw	a1,-296(a3)
    80003340:	000a8513          	mv	a0,s5
    80003344:	b18fd0ef          	jal	8000065c <printf>
    printf("\n");
    80003348:	000a0513          	mv	a0,s4
    8000334c:	b10fd0ef          	jal	8000065c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80003350:	16848493          	addi	s1,s1,360
    80003354:	03248a63          	beq	s1,s2,80003388 <procdump+0xbc>
    if(p->state == UNUSED)
    80003358:	00048693          	mv	a3,s1
    8000335c:	ec04a783          	lw	a5,-320(s1)
    80003360:	fe0788e3          	beqz	a5,80003350 <procdump+0x84>
      state = "???";
    80003364:	00098613          	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80003368:	fcfb6ae3          	bltu	s6,a5,8000333c <procdump+0x70>
    8000336c:	02079713          	slli	a4,a5,0x20
    80003370:	01d75793          	srli	a5,a4,0x1d
    80003374:	00fb87b3          	add	a5,s7,a5
    80003378:	0007b603          	ld	a2,0(a5)
    8000337c:	fc0610e3          	bnez	a2,8000333c <procdump+0x70>
      state = "???";
    80003380:	00098613          	mv	a2,s3
    80003384:	fb9ff06f          	j	8000333c <procdump+0x70>
  }
}
    80003388:	04813083          	ld	ra,72(sp)
    8000338c:	04013403          	ld	s0,64(sp)
    80003390:	03813483          	ld	s1,56(sp)
    80003394:	03013903          	ld	s2,48(sp)
    80003398:	02813983          	ld	s3,40(sp)
    8000339c:	02013a03          	ld	s4,32(sp)
    800033a0:	01813a83          	ld	s5,24(sp)
    800033a4:	01013b03          	ld	s6,16(sp)
    800033a8:	00813b83          	ld	s7,8(sp)
    800033ac:	05010113          	addi	sp,sp,80
    800033b0:	00008067          	ret

00000000800033b4 <swtch>:
    800033b4:	00153023          	sd	ra,0(a0)
    800033b8:	00253423          	sd	sp,8(a0)
    800033bc:	e900                	sd	s0,16(a0)
    800033be:	ed04                	sd	s1,24(a0)
    800033c0:	03253023          	sd	s2,32(a0)
    800033c4:	03353423          	sd	s3,40(a0)
    800033c8:	03453823          	sd	s4,48(a0)
    800033cc:	03553c23          	sd	s5,56(a0)
    800033d0:	05653023          	sd	s6,64(a0)
    800033d4:	05753423          	sd	s7,72(a0)
    800033d8:	05853823          	sd	s8,80(a0)
    800033dc:	05953c23          	sd	s9,88(a0)
    800033e0:	07a53023          	sd	s10,96(a0)
    800033e4:	07b53423          	sd	s11,104(a0)
    800033e8:	0005b083          	ld	ra,0(a1)
    800033ec:	0085b103          	ld	sp,8(a1)
    800033f0:	6980                	ld	s0,16(a1)
    800033f2:	6d84                	ld	s1,24(a1)
    800033f4:	0205b903          	ld	s2,32(a1)
    800033f8:	0285b983          	ld	s3,40(a1)
    800033fc:	0305ba03          	ld	s4,48(a1)
    80003400:	0385ba83          	ld	s5,56(a1)
    80003404:	0405bb03          	ld	s6,64(a1)
    80003408:	0485bb83          	ld	s7,72(a1)
    8000340c:	0505bc03          	ld	s8,80(a1)
    80003410:	0585bc83          	ld	s9,88(a1)
    80003414:	0605bd03          	ld	s10,96(a1)
    80003418:	0685bd83          	ld	s11,104(a1)
    8000341c:	8082                	ret
	...

0000000080003420 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80003420:	ff010113          	addi	sp,sp,-16
    80003424:	00113423          	sd	ra,8(sp)
    80003428:	00813023          	sd	s0,0(sp)
    8000342c:	01010413          	addi	s0,sp,16
  initlock(&tickslock, "time");
    80003430:	00006597          	auipc	a1,0x6
    80003434:	eb858593          	addi	a1,a1,-328 # 800092e8 <etext+0x2e8>
    80003438:	00014517          	auipc	a0,0x14
    8000343c:	42850513          	addi	a0,a0,1064 # 80017860 <tickslock>
    80003440:	b35fd0ef          	jal	80000f74 <initlock>
}
    80003444:	00813083          	ld	ra,8(sp)
    80003448:	00013403          	ld	s0,0(sp)
    8000344c:	01010113          	addi	sp,sp,16
    80003450:	00008067          	ret

0000000080003454 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80003454:	ff010113          	addi	sp,sp,-16
    80003458:	00813423          	sd	s0,8(sp)
    8000345c:	01010413          	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003460:	00004797          	auipc	a5,0x4
    80003464:	26078793          	addi	a5,a5,608 # 800076c0 <kernelvec>
    80003468:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000346c:	00813403          	ld	s0,8(sp)
    80003470:	01010113          	addi	sp,sp,16
    80003474:	00008067          	ret

0000000080003478 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80003478:	ff010113          	addi	sp,sp,-16
    8000347c:	00113423          	sd	ra,8(sp)
    80003480:	00813023          	sd	s0,0(sp)
    80003484:	01010413          	addi	s0,sp,16
  struct proc *p = myproc();
    80003488:	fd5fe0ef          	jal	8000245c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000348c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003490:	ffd7f793          	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003494:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80003498:	00005697          	auipc	a3,0x5
    8000349c:	b6868693          	addi	a3,a3,-1176 # 80008000 <_trampoline>
    800034a0:	00005717          	auipc	a4,0x5
    800034a4:	b6070713          	addi	a4,a4,-1184 # 80008000 <_trampoline>
    800034a8:	40d70733          	sub	a4,a4,a3
    800034ac:	040007b7          	lui	a5,0x4000
    800034b0:	fff78793          	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800034b4:	00c79793          	slli	a5,a5,0xc
    800034b8:	00f70733          	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800034bc:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800034c0:	05853703          	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800034c4:	18002673          	csrr	a2,satp
    800034c8:	00c73023          	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800034cc:	05853603          	ld	a2,88(a0)
    800034d0:	04053703          	ld	a4,64(a0)
    800034d4:	000015b7          	lui	a1,0x1
    800034d8:	00b70733          	add	a4,a4,a1
    800034dc:	00e63423          	sd	a4,8(a2) # 1008 <_entry-0x7fffeff8>
  p->trapframe->kernel_trap = (uint64)usertrap;
    800034e0:	05853703          	ld	a4,88(a0)
    800034e4:	00000617          	auipc	a2,0x0
    800034e8:	19860613          	addi	a2,a2,408 # 8000367c <usertrap>
    800034ec:	00c73823          	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800034f0:	05853703          	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800034f4:	00020613          	mv	a2,tp
    800034f8:	02c73023          	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800034fc:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80003500:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80003504:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003508:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000350c:	05853703          	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003510:	01873703          	ld	a4,24(a4)
    80003514:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80003518:	05053503          	ld	a0,80(a0)
    8000351c:	00c55513          	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80003520:	00005717          	auipc	a4,0x5
    80003524:	b7c70713          	addi	a4,a4,-1156 # 8000809c <userret>
    80003528:	40d70733          	sub	a4,a4,a3
    8000352c:	00f707b3          	add	a5,a4,a5
  ((void (*)(uint64))trampoline_userret)(satp);
    80003530:	fff00713          	li	a4,-1
    80003534:	03f71713          	slli	a4,a4,0x3f
    80003538:	00e56533          	or	a0,a0,a4
    8000353c:	000780e7          	jalr	a5
}
    80003540:	00813083          	ld	ra,8(sp)
    80003544:	00013403          	ld	s0,0(sp)
    80003548:	01010113          	addi	sp,sp,16
    8000354c:	00008067          	ret

0000000080003550 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80003550:	fe010113          	addi	sp,sp,-32
    80003554:	00113c23          	sd	ra,24(sp)
    80003558:	00813823          	sd	s0,16(sp)
    8000355c:	02010413          	addi	s0,sp,32
  if(cpuid() == 0){
    80003560:	eadfe0ef          	jal	8000240c <cpuid>
    80003564:	02050463          	beqz	a0,8000358c <clockintr+0x3c>
  asm volatile("csrr %0, time" : "=r" (x) );
    80003568:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000356c:	000f4737          	lui	a4,0xf4
    80003570:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80003574:	00e787b3          	add	a5,a5,a4
  asm volatile("csrw stimecmp, %0" : : "r" (x));
    80003578:	14d79073          	csrw	stimecmp,a5
}
    8000357c:	01813083          	ld	ra,24(sp)
    80003580:	01013403          	ld	s0,16(sp)
    80003584:	02010113          	addi	sp,sp,32
    80003588:	00008067          	ret
    8000358c:	00913423          	sd	s1,8(sp)
    acquire(&tickslock);
    80003590:	00014497          	auipc	s1,0x14
    80003594:	2d048493          	addi	s1,s1,720 # 80017860 <tickslock>
    80003598:	00048513          	mv	a0,s1
    8000359c:	aadfd0ef          	jal	80001048 <acquire>
    ticks++;
    800035a0:	00006517          	auipc	a0,0x6
    800035a4:	36050513          	addi	a0,a0,864 # 80009900 <ticks>
    800035a8:	00052783          	lw	a5,0(a0)
    800035ac:	0017879b          	addiw	a5,a5,1
    800035b0:	00f52023          	sw	a5,0(a0)
    wakeup(&ticks);
    800035b4:	f9cff0ef          	jal	80002d50 <wakeup>
    release(&tickslock);
    800035b8:	00048513          	mv	a0,s1
    800035bc:	b69fd0ef          	jal	80001124 <release>
    800035c0:	00813483          	ld	s1,8(sp)
    800035c4:	fa5ff06f          	j	80003568 <clockintr+0x18>

00000000800035c8 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800035c8:	fe010113          	addi	sp,sp,-32
    800035cc:	00113c23          	sd	ra,24(sp)
    800035d0:	00813823          	sd	s0,16(sp)
    800035d4:	02010413          	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800035d8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800035dc:	fff00793          	li	a5,-1
    800035e0:	03f79793          	slli	a5,a5,0x3f
    800035e4:	00978793          	addi	a5,a5,9
    800035e8:	02f70463          	beq	a4,a5,80003610 <devintr+0x48>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800035ec:	fff00793          	li	a5,-1
    800035f0:	03f79793          	slli	a5,a5,0x3f
    800035f4:	00578793          	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800035f8:	00000513          	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800035fc:	06f70a63          	beq	a4,a5,80003670 <devintr+0xa8>
  }
}
    80003600:	01813083          	ld	ra,24(sp)
    80003604:	01013403          	ld	s0,16(sp)
    80003608:	02010113          	addi	sp,sp,32
    8000360c:	00008067          	ret
    80003610:	00913423          	sd	s1,8(sp)
    int irq = plic_claim();
    80003614:	180040ef          	jal	80007794 <plic_claim>
    80003618:	00050493          	mv	s1,a0
    if(irq == UART0_IRQ){
    8000361c:	00a00793          	li	a5,10
    80003620:	00f50e63          	beq	a0,a5,8000363c <devintr+0x74>
    } else if(irq == VIRTIO0_IRQ){
    80003624:	00100793          	li	a5,1
    80003628:	00f50e63          	beq	a0,a5,80003644 <devintr+0x7c>
    return 1;
    8000362c:	00100513          	li	a0,1
    } else if(irq){
    80003630:	00049e63          	bnez	s1,8000364c <devintr+0x84>
    80003634:	00813483          	ld	s1,8(sp)
    80003638:	fc9ff06f          	j	80003600 <devintr+0x38>
      uartintr();
    8000363c:	f18fd0ef          	jal	80000d54 <uartintr>
    if(irq)
    80003640:	01c0006f          	j	8000365c <devintr+0x94>
      virtio_disk_intr();
    80003644:	790040ef          	jal	80007dd4 <virtio_disk_intr>
    if(irq)
    80003648:	0140006f          	j	8000365c <devintr+0x94>
      printf("unexpected interrupt irq=%d\n", irq);
    8000364c:	00048593          	mv	a1,s1
    80003650:	00006517          	auipc	a0,0x6
    80003654:	ca050513          	addi	a0,a0,-864 # 800092f0 <etext+0x2f0>
    80003658:	804fd0ef          	jal	8000065c <printf>
      plic_complete(irq);
    8000365c:	00048513          	mv	a0,s1
    80003660:	168040ef          	jal	800077c8 <plic_complete>
    return 1;
    80003664:	00100513          	li	a0,1
    80003668:	00813483          	ld	s1,8(sp)
    8000366c:	f95ff06f          	j	80003600 <devintr+0x38>
    clockintr();
    80003670:	ee1ff0ef          	jal	80003550 <clockintr>
    return 2;
    80003674:	00200513          	li	a0,2
    80003678:	f89ff06f          	j	80003600 <devintr+0x38>

000000008000367c <usertrap>:
{
    8000367c:	fe010113          	addi	sp,sp,-32
    80003680:	00113c23          	sd	ra,24(sp)
    80003684:	00813823          	sd	s0,16(sp)
    80003688:	00913423          	sd	s1,8(sp)
    8000368c:	01213023          	sd	s2,0(sp)
    80003690:	02010413          	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003694:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80003698:	1007f793          	andi	a5,a5,256
    8000369c:	04079663          	bnez	a5,800036e8 <usertrap+0x6c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800036a0:	00004797          	auipc	a5,0x4
    800036a4:	02078793          	addi	a5,a5,32 # 800076c0 <kernelvec>
    800036a8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800036ac:	db1fe0ef          	jal	8000245c <myproc>
    800036b0:	00050493          	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800036b4:	05853783          	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800036b8:	14102773          	csrr	a4,sepc
    800036bc:	00e7bc23          	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800036c0:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800036c4:	00800793          	li	a5,8
    800036c8:	02f70663          	beq	a4,a5,800036f4 <usertrap+0x78>
  } else if((which_dev = devintr()) != 0){
    800036cc:	efdff0ef          	jal	800035c8 <devintr>
    800036d0:	00050913          	mv	s2,a0
    800036d4:	08050863          	beqz	a0,80003764 <usertrap+0xe8>
  if(killed(p))
    800036d8:	00048513          	mv	a0,s1
    800036dc:	93dff0ef          	jal	80003018 <killed>
    800036e0:	04050a63          	beqz	a0,80003734 <usertrap+0xb8>
    800036e4:	0480006f          	j	8000372c <usertrap+0xb0>
    panic("usertrap: not from user mode");
    800036e8:	00006517          	auipc	a0,0x6
    800036ec:	c2850513          	addi	a0,a0,-984 # 80009310 <etext+0x310>
    800036f0:	b10fd0ef          	jal	80000a00 <panic>
    if(killed(p))
    800036f4:	925ff0ef          	jal	80003018 <killed>
    800036f8:	06051063          	bnez	a0,80003758 <usertrap+0xdc>
    p->trapframe->epc += 4;
    800036fc:	0584b703          	ld	a4,88(s1)
    80003700:	01873783          	ld	a5,24(a4)
    80003704:	00478793          	addi	a5,a5,4
    80003708:	00f73c23          	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000370c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003710:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003714:	10079073          	csrw	sstatus,a5
    syscall();
    80003718:	388000ef          	jal	80003aa0 <syscall>
  if(killed(p))
    8000371c:	00048513          	mv	a0,s1
    80003720:	8f9ff0ef          	jal	80003018 <killed>
    80003724:	00050c63          	beqz	a0,8000373c <usertrap+0xc0>
    80003728:	00000913          	li	s2,0
    exit(-1);
    8000372c:	fff00513          	li	a0,-1
    80003730:	f40ff0ef          	jal	80002e70 <exit>
  if(which_dev == 2)
    80003734:	00200793          	li	a5,2
    80003738:	06f90063          	beq	s2,a5,80003798 <usertrap+0x11c>
  usertrapret();
    8000373c:	d3dff0ef          	jal	80003478 <usertrapret>
}
    80003740:	01813083          	ld	ra,24(sp)
    80003744:	01013403          	ld	s0,16(sp)
    80003748:	00813483          	ld	s1,8(sp)
    8000374c:	00013903          	ld	s2,0(sp)
    80003750:	02010113          	addi	sp,sp,32
    80003754:	00008067          	ret
      exit(-1);
    80003758:	fff00513          	li	a0,-1
    8000375c:	f14ff0ef          	jal	80002e70 <exit>
    80003760:	f9dff06f          	j	800036fc <usertrap+0x80>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003764:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80003768:	0304a603          	lw	a2,48(s1)
    8000376c:	00006517          	auipc	a0,0x6
    80003770:	bc450513          	addi	a0,a0,-1084 # 80009330 <etext+0x330>
    80003774:	ee9fc0ef          	jal	8000065c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003778:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000377c:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80003780:	00006517          	auipc	a0,0x6
    80003784:	be050513          	addi	a0,a0,-1056 # 80009360 <etext+0x360>
    80003788:	ed5fc0ef          	jal	8000065c <printf>
    setkilled(p);
    8000378c:	00048513          	mv	a0,s1
    80003790:	849ff0ef          	jal	80002fd8 <setkilled>
    80003794:	f89ff06f          	j	8000371c <usertrap+0xa0>
    yield();
    80003798:	cf8ff0ef          	jal	80002c90 <yield>
    8000379c:	fa1ff06f          	j	8000373c <usertrap+0xc0>

00000000800037a0 <kerneltrap>:
{
    800037a0:	fd010113          	addi	sp,sp,-48
    800037a4:	02113423          	sd	ra,40(sp)
    800037a8:	02813023          	sd	s0,32(sp)
    800037ac:	00913c23          	sd	s1,24(sp)
    800037b0:	01213823          	sd	s2,16(sp)
    800037b4:	01313423          	sd	s3,8(sp)
    800037b8:	03010413          	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800037bc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800037c0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800037c4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800037c8:	1004f793          	andi	a5,s1,256
    800037cc:	04078263          	beqz	a5,80003810 <kerneltrap+0x70>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800037d0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800037d4:	0027f793          	andi	a5,a5,2
  if(intr_get() != 0)
    800037d8:	04079263          	bnez	a5,8000381c <kerneltrap+0x7c>
  if((which_dev = devintr()) == 0){
    800037dc:	dedff0ef          	jal	800035c8 <devintr>
    800037e0:	04050463          	beqz	a0,80003828 <kerneltrap+0x88>
  if(which_dev == 2 && myproc() != 0)
    800037e4:	00200793          	li	a5,2
    800037e8:	06f50263          	beq	a0,a5,8000384c <kerneltrap+0xac>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800037ec:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800037f0:	10049073          	csrw	sstatus,s1
}
    800037f4:	02813083          	ld	ra,40(sp)
    800037f8:	02013403          	ld	s0,32(sp)
    800037fc:	01813483          	ld	s1,24(sp)
    80003800:	01013903          	ld	s2,16(sp)
    80003804:	00813983          	ld	s3,8(sp)
    80003808:	03010113          	addi	sp,sp,48
    8000380c:	00008067          	ret
    panic("kerneltrap: not from supervisor mode");
    80003810:	00006517          	auipc	a0,0x6
    80003814:	b7850513          	addi	a0,a0,-1160 # 80009388 <etext+0x388>
    80003818:	9e8fd0ef          	jal	80000a00 <panic>
    panic("kerneltrap: interrupts enabled");
    8000381c:	00006517          	auipc	a0,0x6
    80003820:	b9450513          	addi	a0,a0,-1132 # 800093b0 <etext+0x3b0>
    80003824:	9dcfd0ef          	jal	80000a00 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003828:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000382c:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80003830:	00098593          	mv	a1,s3
    80003834:	00006517          	auipc	a0,0x6
    80003838:	b9c50513          	addi	a0,a0,-1124 # 800093d0 <etext+0x3d0>
    8000383c:	e21fc0ef          	jal	8000065c <printf>
    panic("kerneltrap");
    80003840:	00006517          	auipc	a0,0x6
    80003844:	bb850513          	addi	a0,a0,-1096 # 800093f8 <etext+0x3f8>
    80003848:	9b8fd0ef          	jal	80000a00 <panic>
  if(which_dev == 2 && myproc() != 0)
    8000384c:	c11fe0ef          	jal	8000245c <myproc>
    80003850:	f8050ee3          	beqz	a0,800037ec <kerneltrap+0x4c>
    yield();
    80003854:	c3cff0ef          	jal	80002c90 <yield>
    80003858:	f95ff06f          	j	800037ec <kerneltrap+0x4c>

000000008000385c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000385c:	fe010113          	addi	sp,sp,-32
    80003860:	00113c23          	sd	ra,24(sp)
    80003864:	00813823          	sd	s0,16(sp)
    80003868:	00913423          	sd	s1,8(sp)
    8000386c:	02010413          	addi	s0,sp,32
    80003870:	00050493          	mv	s1,a0
  struct proc *p = myproc();
    80003874:	be9fe0ef          	jal	8000245c <myproc>
  switch (n) {
    80003878:	00500793          	li	a5,5
    8000387c:	0697ec63          	bltu	a5,s1,800038f4 <argraw+0x98>
    80003880:	00249493          	slli	s1,s1,0x2
    80003884:	00006717          	auipc	a4,0x6
    80003888:	f3470713          	addi	a4,a4,-204 # 800097b8 <states.0+0x30>
    8000388c:	00e484b3          	add	s1,s1,a4
    80003890:	0004a783          	lw	a5,0(s1)
    80003894:	00e787b3          	add	a5,a5,a4
    80003898:	00078067          	jr	a5
  case 0:
    return p->trapframe->a0;
    8000389c:	05853783          	ld	a5,88(a0)
    800038a0:	0707b503          	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800038a4:	01813083          	ld	ra,24(sp)
    800038a8:	01013403          	ld	s0,16(sp)
    800038ac:	00813483          	ld	s1,8(sp)
    800038b0:	02010113          	addi	sp,sp,32
    800038b4:	00008067          	ret
    return p->trapframe->a1;
    800038b8:	05853783          	ld	a5,88(a0)
    800038bc:	0787b503          	ld	a0,120(a5)
    800038c0:	fe5ff06f          	j	800038a4 <argraw+0x48>
    return p->trapframe->a2;
    800038c4:	05853783          	ld	a5,88(a0)
    800038c8:	0807b503          	ld	a0,128(a5)
    800038cc:	fd9ff06f          	j	800038a4 <argraw+0x48>
    return p->trapframe->a3;
    800038d0:	05853783          	ld	a5,88(a0)
    800038d4:	0887b503          	ld	a0,136(a5)
    800038d8:	fcdff06f          	j	800038a4 <argraw+0x48>
    return p->trapframe->a4;
    800038dc:	05853783          	ld	a5,88(a0)
    800038e0:	0907b503          	ld	a0,144(a5)
    800038e4:	fc1ff06f          	j	800038a4 <argraw+0x48>
    return p->trapframe->a5;
    800038e8:	05853783          	ld	a5,88(a0)
    800038ec:	0987b503          	ld	a0,152(a5)
    800038f0:	fb5ff06f          	j	800038a4 <argraw+0x48>
  panic("argraw");
    800038f4:	00006517          	auipc	a0,0x6
    800038f8:	b1450513          	addi	a0,a0,-1260 # 80009408 <etext+0x408>
    800038fc:	904fd0ef          	jal	80000a00 <panic>

0000000080003900 <fetchaddr>:
{
    80003900:	fe010113          	addi	sp,sp,-32
    80003904:	00113c23          	sd	ra,24(sp)
    80003908:	00813823          	sd	s0,16(sp)
    8000390c:	00913423          	sd	s1,8(sp)
    80003910:	01213023          	sd	s2,0(sp)
    80003914:	02010413          	addi	s0,sp,32
    80003918:	00050493          	mv	s1,a0
    8000391c:	00058913          	mv	s2,a1
  struct proc *p = myproc();
    80003920:	b3dfe0ef          	jal	8000245c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003924:	04853783          	ld	a5,72(a0)
    80003928:	04f4f063          	bgeu	s1,a5,80003968 <fetchaddr+0x68>
    8000392c:	00848713          	addi	a4,s1,8
    80003930:	04e7e063          	bltu	a5,a4,80003970 <fetchaddr+0x70>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003934:	00800693          	li	a3,8
    80003938:	00048613          	mv	a2,s1
    8000393c:	00090593          	mv	a1,s2
    80003940:	05053503          	ld	a0,80(a0)
    80003944:	ee8fe0ef          	jal	8000202c <copyin>
    80003948:	00a03533          	snez	a0,a0
    8000394c:	40a00533          	neg	a0,a0
}
    80003950:	01813083          	ld	ra,24(sp)
    80003954:	01013403          	ld	s0,16(sp)
    80003958:	00813483          	ld	s1,8(sp)
    8000395c:	00013903          	ld	s2,0(sp)
    80003960:	02010113          	addi	sp,sp,32
    80003964:	00008067          	ret
    return -1;
    80003968:	fff00513          	li	a0,-1
    8000396c:	fe5ff06f          	j	80003950 <fetchaddr+0x50>
    80003970:	fff00513          	li	a0,-1
    80003974:	fddff06f          	j	80003950 <fetchaddr+0x50>

0000000080003978 <fetchstr>:
{
    80003978:	fd010113          	addi	sp,sp,-48
    8000397c:	02113423          	sd	ra,40(sp)
    80003980:	02813023          	sd	s0,32(sp)
    80003984:	00913c23          	sd	s1,24(sp)
    80003988:	01213823          	sd	s2,16(sp)
    8000398c:	01313423          	sd	s3,8(sp)
    80003990:	03010413          	addi	s0,sp,48
    80003994:	00050913          	mv	s2,a0
    80003998:	00058493          	mv	s1,a1
    8000399c:	00060993          	mv	s3,a2
  struct proc *p = myproc();
    800039a0:	abdfe0ef          	jal	8000245c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800039a4:	00098693          	mv	a3,s3
    800039a8:	00090613          	mv	a2,s2
    800039ac:	00048593          	mv	a1,s1
    800039b0:	05053503          	ld	a0,80(a0)
    800039b4:	f58fe0ef          	jal	8000210c <copyinstr>
    800039b8:	02054463          	bltz	a0,800039e0 <fetchstr+0x68>
  return strlen(buf);
    800039bc:	00048513          	mv	a0,s1
    800039c0:	9f5fd0ef          	jal	800013b4 <strlen>
}
    800039c4:	02813083          	ld	ra,40(sp)
    800039c8:	02013403          	ld	s0,32(sp)
    800039cc:	01813483          	ld	s1,24(sp)
    800039d0:	01013903          	ld	s2,16(sp)
    800039d4:	00813983          	ld	s3,8(sp)
    800039d8:	03010113          	addi	sp,sp,48
    800039dc:	00008067          	ret
    return -1;
    800039e0:	fff00513          	li	a0,-1
    800039e4:	fe1ff06f          	j	800039c4 <fetchstr+0x4c>

00000000800039e8 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800039e8:	fe010113          	addi	sp,sp,-32
    800039ec:	00113c23          	sd	ra,24(sp)
    800039f0:	00813823          	sd	s0,16(sp)
    800039f4:	00913423          	sd	s1,8(sp)
    800039f8:	02010413          	addi	s0,sp,32
    800039fc:	00058493          	mv	s1,a1
  *ip = argraw(n);
    80003a00:	e5dff0ef          	jal	8000385c <argraw>
    80003a04:	00a4a023          	sw	a0,0(s1)
}
    80003a08:	01813083          	ld	ra,24(sp)
    80003a0c:	01013403          	ld	s0,16(sp)
    80003a10:	00813483          	ld	s1,8(sp)
    80003a14:	02010113          	addi	sp,sp,32
    80003a18:	00008067          	ret

0000000080003a1c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80003a1c:	fe010113          	addi	sp,sp,-32
    80003a20:	00113c23          	sd	ra,24(sp)
    80003a24:	00813823          	sd	s0,16(sp)
    80003a28:	00913423          	sd	s1,8(sp)
    80003a2c:	02010413          	addi	s0,sp,32
    80003a30:	00058493          	mv	s1,a1
  *ip = argraw(n);
    80003a34:	e29ff0ef          	jal	8000385c <argraw>
    80003a38:	00a4b023          	sd	a0,0(s1)
}
    80003a3c:	01813083          	ld	ra,24(sp)
    80003a40:	01013403          	ld	s0,16(sp)
    80003a44:	00813483          	ld	s1,8(sp)
    80003a48:	02010113          	addi	sp,sp,32
    80003a4c:	00008067          	ret

0000000080003a50 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80003a50:	fd010113          	addi	sp,sp,-48
    80003a54:	02113423          	sd	ra,40(sp)
    80003a58:	02813023          	sd	s0,32(sp)
    80003a5c:	00913c23          	sd	s1,24(sp)
    80003a60:	01213823          	sd	s2,16(sp)
    80003a64:	03010413          	addi	s0,sp,48
    80003a68:	00058493          	mv	s1,a1
    80003a6c:	00060913          	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80003a70:	fd840593          	addi	a1,s0,-40
    80003a74:	fa9ff0ef          	jal	80003a1c <argaddr>
  return fetchstr(addr, buf, max);
    80003a78:	00090613          	mv	a2,s2
    80003a7c:	00048593          	mv	a1,s1
    80003a80:	fd843503          	ld	a0,-40(s0)
    80003a84:	ef5ff0ef          	jal	80003978 <fetchstr>
}
    80003a88:	02813083          	ld	ra,40(sp)
    80003a8c:	02013403          	ld	s0,32(sp)
    80003a90:	01813483          	ld	s1,24(sp)
    80003a94:	01013903          	ld	s2,16(sp)
    80003a98:	03010113          	addi	sp,sp,48
    80003a9c:	00008067          	ret

0000000080003aa0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80003aa0:	fe010113          	addi	sp,sp,-32
    80003aa4:	00113c23          	sd	ra,24(sp)
    80003aa8:	00813823          	sd	s0,16(sp)
    80003aac:	00913423          	sd	s1,8(sp)
    80003ab0:	01213023          	sd	s2,0(sp)
    80003ab4:	02010413          	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80003ab8:	9a5fe0ef          	jal	8000245c <myproc>
    80003abc:	00050493          	mv	s1,a0

  num = p->trapframe->a7;
    80003ac0:	05853903          	ld	s2,88(a0)
    80003ac4:	0a893783          	ld	a5,168(s2)
    80003ac8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003acc:	fff7879b          	addiw	a5,a5,-1
    80003ad0:	01400713          	li	a4,20
    80003ad4:	02f76463          	bltu	a4,a5,80003afc <syscall+0x5c>
    80003ad8:	00369713          	slli	a4,a3,0x3
    80003adc:	00006797          	auipc	a5,0x6
    80003ae0:	cf478793          	addi	a5,a5,-780 # 800097d0 <syscalls>
    80003ae4:	00e787b3          	add	a5,a5,a4
    80003ae8:	0007b783          	ld	a5,0(a5)
    80003aec:	00078863          	beqz	a5,80003afc <syscall+0x5c>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80003af0:	000780e7          	jalr	a5
    80003af4:	06a93823          	sd	a0,112(s2)
    80003af8:	0240006f          	j	80003b1c <syscall+0x7c>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003afc:	15848613          	addi	a2,s1,344
    80003b00:	0304a583          	lw	a1,48(s1)
    80003b04:	00006517          	auipc	a0,0x6
    80003b08:	90c50513          	addi	a0,a0,-1780 # 80009410 <etext+0x410>
    80003b0c:	b51fc0ef          	jal	8000065c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003b10:	0584b783          	ld	a5,88(s1)
    80003b14:	fff00713          	li	a4,-1
    80003b18:	06e7b823          	sd	a4,112(a5)
  }
}
    80003b1c:	01813083          	ld	ra,24(sp)
    80003b20:	01013403          	ld	s0,16(sp)
    80003b24:	00813483          	ld	s1,8(sp)
    80003b28:	00013903          	ld	s2,0(sp)
    80003b2c:	02010113          	addi	sp,sp,32
    80003b30:	00008067          	ret

0000000080003b34 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003b34:	fe010113          	addi	sp,sp,-32
    80003b38:	00113c23          	sd	ra,24(sp)
    80003b3c:	00813823          	sd	s0,16(sp)
    80003b40:	02010413          	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003b44:	fec40593          	addi	a1,s0,-20
    80003b48:	00000513          	li	a0,0
    80003b4c:	e9dff0ef          	jal	800039e8 <argint>
  exit(n);
    80003b50:	fec42503          	lw	a0,-20(s0)
    80003b54:	b1cff0ef          	jal	80002e70 <exit>
  return 0;  // not reached
}
    80003b58:	00000513          	li	a0,0
    80003b5c:	01813083          	ld	ra,24(sp)
    80003b60:	01013403          	ld	s0,16(sp)
    80003b64:	02010113          	addi	sp,sp,32
    80003b68:	00008067          	ret

0000000080003b6c <sys_getpid>:

uint64
sys_getpid(void)
{
    80003b6c:	ff010113          	addi	sp,sp,-16
    80003b70:	00113423          	sd	ra,8(sp)
    80003b74:	00813023          	sd	s0,0(sp)
    80003b78:	01010413          	addi	s0,sp,16
  return myproc()->pid;
    80003b7c:	8e1fe0ef          	jal	8000245c <myproc>
}
    80003b80:	03052503          	lw	a0,48(a0)
    80003b84:	00813083          	ld	ra,8(sp)
    80003b88:	00013403          	ld	s0,0(sp)
    80003b8c:	01010113          	addi	sp,sp,16
    80003b90:	00008067          	ret

0000000080003b94 <sys_fork>:

uint64
sys_fork(void)
{
    80003b94:	ff010113          	addi	sp,sp,-16
    80003b98:	00113423          	sd	ra,8(sp)
    80003b9c:	00813023          	sd	s0,0(sp)
    80003ba0:	01010413          	addi	s0,sp,16
  return fork();
    80003ba4:	d89fe0ef          	jal	8000292c <fork>
}
    80003ba8:	00813083          	ld	ra,8(sp)
    80003bac:	00013403          	ld	s0,0(sp)
    80003bb0:	01010113          	addi	sp,sp,16
    80003bb4:	00008067          	ret

0000000080003bb8 <sys_wait>:

uint64
sys_wait(void)
{
    80003bb8:	fe010113          	addi	sp,sp,-32
    80003bbc:	00113c23          	sd	ra,24(sp)
    80003bc0:	00813823          	sd	s0,16(sp)
    80003bc4:	02010413          	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003bc8:	fe840593          	addi	a1,s0,-24
    80003bcc:	00000513          	li	a0,0
    80003bd0:	e4dff0ef          	jal	80003a1c <argaddr>
  return wait(p);
    80003bd4:	fe843503          	ld	a0,-24(s0)
    80003bd8:	c88ff0ef          	jal	80003060 <wait>
}
    80003bdc:	01813083          	ld	ra,24(sp)
    80003be0:	01013403          	ld	s0,16(sp)
    80003be4:	02010113          	addi	sp,sp,32
    80003be8:	00008067          	ret

0000000080003bec <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003bec:	fd010113          	addi	sp,sp,-48
    80003bf0:	02113423          	sd	ra,40(sp)
    80003bf4:	02813023          	sd	s0,32(sp)
    80003bf8:	00913c23          	sd	s1,24(sp)
    80003bfc:	03010413          	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80003c00:	fdc40593          	addi	a1,s0,-36
    80003c04:	00000513          	li	a0,0
    80003c08:	de1ff0ef          	jal	800039e8 <argint>
  addr = myproc()->sz;
    80003c0c:	851fe0ef          	jal	8000245c <myproc>
    80003c10:	04853483          	ld	s1,72(a0)
  if(growproc(n) < 0)
    80003c14:	fdc42503          	lw	a0,-36(s0)
    80003c18:	c91fe0ef          	jal	800028a8 <growproc>
    80003c1c:	00054e63          	bltz	a0,80003c38 <sys_sbrk+0x4c>
    return -1;
  return addr;
}
    80003c20:	00048513          	mv	a0,s1
    80003c24:	02813083          	ld	ra,40(sp)
    80003c28:	02013403          	ld	s0,32(sp)
    80003c2c:	01813483          	ld	s1,24(sp)
    80003c30:	03010113          	addi	sp,sp,48
    80003c34:	00008067          	ret
    return -1;
    80003c38:	fff00493          	li	s1,-1
    80003c3c:	fe5ff06f          	j	80003c20 <sys_sbrk+0x34>

0000000080003c40 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003c40:	fc010113          	addi	sp,sp,-64
    80003c44:	02113c23          	sd	ra,56(sp)
    80003c48:	02813823          	sd	s0,48(sp)
    80003c4c:	03213023          	sd	s2,32(sp)
    80003c50:	04010413          	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003c54:	fcc40593          	addi	a1,s0,-52
    80003c58:	00000513          	li	a0,0
    80003c5c:	d8dff0ef          	jal	800039e8 <argint>
  if(n < 0)
    80003c60:	fcc42783          	lw	a5,-52(s0)
    80003c64:	0807c663          	bltz	a5,80003cf0 <sys_sleep+0xb0>
    n = 0;
  acquire(&tickslock);
    80003c68:	00014517          	auipc	a0,0x14
    80003c6c:	bf850513          	addi	a0,a0,-1032 # 80017860 <tickslock>
    80003c70:	bd8fd0ef          	jal	80001048 <acquire>
  ticks0 = ticks;
    80003c74:	00006917          	auipc	s2,0x6
    80003c78:	c8c92903          	lw	s2,-884(s2) # 80009900 <ticks>
  while(ticks - ticks0 < n){
    80003c7c:	fcc42783          	lw	a5,-52(s0)
    80003c80:	04078663          	beqz	a5,80003ccc <sys_sleep+0x8c>
    80003c84:	02913423          	sd	s1,40(sp)
    80003c88:	01313c23          	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003c8c:	00014997          	auipc	s3,0x14
    80003c90:	bd498993          	addi	s3,s3,-1068 # 80017860 <tickslock>
    80003c94:	00006497          	auipc	s1,0x6
    80003c98:	c6c48493          	addi	s1,s1,-916 # 80009900 <ticks>
    if(killed(myproc())){
    80003c9c:	fc0fe0ef          	jal	8000245c <myproc>
    80003ca0:	b78ff0ef          	jal	80003018 <killed>
    80003ca4:	04051a63          	bnez	a0,80003cf8 <sys_sleep+0xb8>
    sleep(&ticks, &tickslock);
    80003ca8:	00098593          	mv	a1,s3
    80003cac:	00048513          	mv	a0,s1
    80003cb0:	828ff0ef          	jal	80002cd8 <sleep>
  while(ticks - ticks0 < n){
    80003cb4:	0004a783          	lw	a5,0(s1)
    80003cb8:	412787bb          	subw	a5,a5,s2
    80003cbc:	fcc42703          	lw	a4,-52(s0)
    80003cc0:	fce7eee3          	bltu	a5,a4,80003c9c <sys_sleep+0x5c>
    80003cc4:	02813483          	ld	s1,40(sp)
    80003cc8:	01813983          	ld	s3,24(sp)
  }
  release(&tickslock);
    80003ccc:	00014517          	auipc	a0,0x14
    80003cd0:	b9450513          	addi	a0,a0,-1132 # 80017860 <tickslock>
    80003cd4:	c50fd0ef          	jal	80001124 <release>
  return 0;
    80003cd8:	00000513          	li	a0,0
}
    80003cdc:	03813083          	ld	ra,56(sp)
    80003ce0:	03013403          	ld	s0,48(sp)
    80003ce4:	02013903          	ld	s2,32(sp)
    80003ce8:	04010113          	addi	sp,sp,64
    80003cec:	00008067          	ret
    n = 0;
    80003cf0:	fc042623          	sw	zero,-52(s0)
    80003cf4:	f75ff06f          	j	80003c68 <sys_sleep+0x28>
      release(&tickslock);
    80003cf8:	00014517          	auipc	a0,0x14
    80003cfc:	b6850513          	addi	a0,a0,-1176 # 80017860 <tickslock>
    80003d00:	c24fd0ef          	jal	80001124 <release>
      return -1;
    80003d04:	fff00513          	li	a0,-1
    80003d08:	02813483          	ld	s1,40(sp)
    80003d0c:	01813983          	ld	s3,24(sp)
    80003d10:	fcdff06f          	j	80003cdc <sys_sleep+0x9c>

0000000080003d14 <sys_kill>:

uint64
sys_kill(void)
{
    80003d14:	fe010113          	addi	sp,sp,-32
    80003d18:	00113c23          	sd	ra,24(sp)
    80003d1c:	00813823          	sd	s0,16(sp)
    80003d20:	02010413          	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003d24:	fec40593          	addi	a1,s0,-20
    80003d28:	00000513          	li	a0,0
    80003d2c:	cbdff0ef          	jal	800039e8 <argint>
  return kill(pid);
    80003d30:	fec42503          	lw	a0,-20(s0)
    80003d34:	a04ff0ef          	jal	80002f38 <kill>
}
    80003d38:	01813083          	ld	ra,24(sp)
    80003d3c:	01013403          	ld	s0,16(sp)
    80003d40:	02010113          	addi	sp,sp,32
    80003d44:	00008067          	ret

0000000080003d48 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003d48:	fe010113          	addi	sp,sp,-32
    80003d4c:	00113c23          	sd	ra,24(sp)
    80003d50:	00813823          	sd	s0,16(sp)
    80003d54:	00913423          	sd	s1,8(sp)
    80003d58:	02010413          	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003d5c:	00014517          	auipc	a0,0x14
    80003d60:	b0450513          	addi	a0,a0,-1276 # 80017860 <tickslock>
    80003d64:	ae4fd0ef          	jal	80001048 <acquire>
  xticks = ticks;
    80003d68:	00006497          	auipc	s1,0x6
    80003d6c:	b984a483          	lw	s1,-1128(s1) # 80009900 <ticks>
  release(&tickslock);
    80003d70:	00014517          	auipc	a0,0x14
    80003d74:	af050513          	addi	a0,a0,-1296 # 80017860 <tickslock>
    80003d78:	bacfd0ef          	jal	80001124 <release>
  return xticks;
}
    80003d7c:	02049513          	slli	a0,s1,0x20
    80003d80:	02055513          	srli	a0,a0,0x20
    80003d84:	01813083          	ld	ra,24(sp)
    80003d88:	01013403          	ld	s0,16(sp)
    80003d8c:	00813483          	ld	s1,8(sp)
    80003d90:	02010113          	addi	sp,sp,32
    80003d94:	00008067          	ret

0000000080003d98 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003d98:	fd010113          	addi	sp,sp,-48
    80003d9c:	02113423          	sd	ra,40(sp)
    80003da0:	02813023          	sd	s0,32(sp)
    80003da4:	00913c23          	sd	s1,24(sp)
    80003da8:	01213823          	sd	s2,16(sp)
    80003dac:	01313423          	sd	s3,8(sp)
    80003db0:	01413023          	sd	s4,0(sp)
    80003db4:	03010413          	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003db8:	00005597          	auipc	a1,0x5
    80003dbc:	67858593          	addi	a1,a1,1656 # 80009430 <etext+0x430>
    80003dc0:	00014517          	auipc	a0,0x14
    80003dc4:	ab850513          	addi	a0,a0,-1352 # 80017878 <bcache>
    80003dc8:	9acfd0ef          	jal	80000f74 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003dcc:	0001c797          	auipc	a5,0x1c
    80003dd0:	aac78793          	addi	a5,a5,-1364 # 8001f878 <bcache+0x8000>
    80003dd4:	0001c717          	auipc	a4,0x1c
    80003dd8:	d0c70713          	addi	a4,a4,-756 # 8001fae0 <bcache+0x8268>
    80003ddc:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003de0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003de4:	00014497          	auipc	s1,0x14
    80003de8:	aac48493          	addi	s1,s1,-1364 # 80017890 <bcache+0x18>
    b->next = bcache.head.next;
    80003dec:	00078913          	mv	s2,a5
    b->prev = &bcache.head;
    80003df0:	00070993          	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003df4:	00005a17          	auipc	s4,0x5
    80003df8:	644a0a13          	addi	s4,s4,1604 # 80009438 <etext+0x438>
    b->next = bcache.head.next;
    80003dfc:	2b893783          	ld	a5,696(s2)
    80003e00:	04f4b823          	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003e04:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003e08:	000a0593          	mv	a1,s4
    80003e0c:	01048513          	addi	a0,s1,16
    80003e10:	265010ef          	jal	80005874 <initsleeplock>
    bcache.head.next->prev = b;
    80003e14:	2b893783          	ld	a5,696(s2)
    80003e18:	0497b423          	sd	s1,72(a5)
    bcache.head.next = b;
    80003e1c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003e20:	45848493          	addi	s1,s1,1112
    80003e24:	fd349ce3          	bne	s1,s3,80003dfc <binit+0x64>
  }
}
    80003e28:	02813083          	ld	ra,40(sp)
    80003e2c:	02013403          	ld	s0,32(sp)
    80003e30:	01813483          	ld	s1,24(sp)
    80003e34:	01013903          	ld	s2,16(sp)
    80003e38:	00813983          	ld	s3,8(sp)
    80003e3c:	00013a03          	ld	s4,0(sp)
    80003e40:	03010113          	addi	sp,sp,48
    80003e44:	00008067          	ret

0000000080003e48 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003e48:	fd010113          	addi	sp,sp,-48
    80003e4c:	02113423          	sd	ra,40(sp)
    80003e50:	02813023          	sd	s0,32(sp)
    80003e54:	00913c23          	sd	s1,24(sp)
    80003e58:	01213823          	sd	s2,16(sp)
    80003e5c:	01313423          	sd	s3,8(sp)
    80003e60:	03010413          	addi	s0,sp,48
    80003e64:	00050913          	mv	s2,a0
    80003e68:	00058993          	mv	s3,a1
  acquire(&bcache.lock);
    80003e6c:	00014517          	auipc	a0,0x14
    80003e70:	a0c50513          	addi	a0,a0,-1524 # 80017878 <bcache>
    80003e74:	9d4fd0ef          	jal	80001048 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003e78:	0001c497          	auipc	s1,0x1c
    80003e7c:	cb84b483          	ld	s1,-840(s1) # 8001fb30 <bcache+0x82b8>
    80003e80:	0001c797          	auipc	a5,0x1c
    80003e84:	c6078793          	addi	a5,a5,-928 # 8001fae0 <bcache+0x8268>
    80003e88:	04f48463          	beq	s1,a5,80003ed0 <bread+0x88>
    80003e8c:	00078713          	mv	a4,a5
    80003e90:	00c0006f          	j	80003e9c <bread+0x54>
    80003e94:	0504b483          	ld	s1,80(s1)
    80003e98:	02e48c63          	beq	s1,a4,80003ed0 <bread+0x88>
    if(b->dev == dev && b->blockno == blockno){
    80003e9c:	0084a783          	lw	a5,8(s1)
    80003ea0:	ff279ae3          	bne	a5,s2,80003e94 <bread+0x4c>
    80003ea4:	00c4a783          	lw	a5,12(s1)
    80003ea8:	ff3796e3          	bne	a5,s3,80003e94 <bread+0x4c>
      b->refcnt++;
    80003eac:	0404a783          	lw	a5,64(s1)
    80003eb0:	0017879b          	addiw	a5,a5,1
    80003eb4:	04f4a023          	sw	a5,64(s1)
      release(&bcache.lock);
    80003eb8:	00014517          	auipc	a0,0x14
    80003ebc:	9c050513          	addi	a0,a0,-1600 # 80017878 <bcache>
    80003ec0:	a64fd0ef          	jal	80001124 <release>
      acquiresleep(&b->lock);
    80003ec4:	01048513          	addi	a0,s1,16
    80003ec8:	201010ef          	jal	800058c8 <acquiresleep>
      return b;
    80003ecc:	0600006f          	j	80003f2c <bread+0xe4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003ed0:	0001c497          	auipc	s1,0x1c
    80003ed4:	c584b483          	ld	s1,-936(s1) # 8001fb28 <bcache+0x82b0>
    80003ed8:	0001c797          	auipc	a5,0x1c
    80003edc:	c0878793          	addi	a5,a5,-1016 # 8001fae0 <bcache+0x8268>
    80003ee0:	00f48c63          	beq	s1,a5,80003ef8 <bread+0xb0>
    80003ee4:	00078713          	mv	a4,a5
    if(b->refcnt == 0) {
    80003ee8:	0404a783          	lw	a5,64(s1)
    80003eec:	00078c63          	beqz	a5,80003f04 <bread+0xbc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003ef0:	0484b483          	ld	s1,72(s1)
    80003ef4:	fee49ae3          	bne	s1,a4,80003ee8 <bread+0xa0>
  panic("bget: no buffers");
    80003ef8:	00005517          	auipc	a0,0x5
    80003efc:	54850513          	addi	a0,a0,1352 # 80009440 <etext+0x440>
    80003f00:	b01fc0ef          	jal	80000a00 <panic>
      b->dev = dev;
    80003f04:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003f08:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003f0c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003f10:	00100793          	li	a5,1
    80003f14:	04f4a023          	sw	a5,64(s1)
      release(&bcache.lock);
    80003f18:	00014517          	auipc	a0,0x14
    80003f1c:	96050513          	addi	a0,a0,-1696 # 80017878 <bcache>
    80003f20:	a04fd0ef          	jal	80001124 <release>
      acquiresleep(&b->lock);
    80003f24:	01048513          	addi	a0,s1,16
    80003f28:	1a1010ef          	jal	800058c8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003f2c:	0004a783          	lw	a5,0(s1)
    80003f30:	02078263          	beqz	a5,80003f54 <bread+0x10c>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003f34:	00048513          	mv	a0,s1
    80003f38:	02813083          	ld	ra,40(sp)
    80003f3c:	02013403          	ld	s0,32(sp)
    80003f40:	01813483          	ld	s1,24(sp)
    80003f44:	01013903          	ld	s2,16(sp)
    80003f48:	00813983          	ld	s3,8(sp)
    80003f4c:	03010113          	addi	sp,sp,48
    80003f50:	00008067          	ret
    virtio_disk_rw(b, 0);
    80003f54:	00000593          	li	a1,0
    80003f58:	00048513          	mv	a0,s1
    80003f5c:	3b9030ef          	jal	80007b14 <virtio_disk_rw>
    b->valid = 1;
    80003f60:	00100793          	li	a5,1
    80003f64:	00f4a023          	sw	a5,0(s1)
  return b;
    80003f68:	fcdff06f          	j	80003f34 <bread+0xec>

0000000080003f6c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003f6c:	fe010113          	addi	sp,sp,-32
    80003f70:	00113c23          	sd	ra,24(sp)
    80003f74:	00813823          	sd	s0,16(sp)
    80003f78:	00913423          	sd	s1,8(sp)
    80003f7c:	02010413          	addi	s0,sp,32
    80003f80:	00050493          	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003f84:	01050513          	addi	a0,a0,16
    80003f88:	211010ef          	jal	80005998 <holdingsleep>
    80003f8c:	02050263          	beqz	a0,80003fb0 <bwrite+0x44>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003f90:	00100593          	li	a1,1
    80003f94:	00048513          	mv	a0,s1
    80003f98:	37d030ef          	jal	80007b14 <virtio_disk_rw>
}
    80003f9c:	01813083          	ld	ra,24(sp)
    80003fa0:	01013403          	ld	s0,16(sp)
    80003fa4:	00813483          	ld	s1,8(sp)
    80003fa8:	02010113          	addi	sp,sp,32
    80003fac:	00008067          	ret
    panic("bwrite");
    80003fb0:	00005517          	auipc	a0,0x5
    80003fb4:	4a850513          	addi	a0,a0,1192 # 80009458 <etext+0x458>
    80003fb8:	a49fc0ef          	jal	80000a00 <panic>

0000000080003fbc <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003fbc:	fe010113          	addi	sp,sp,-32
    80003fc0:	00113c23          	sd	ra,24(sp)
    80003fc4:	00813823          	sd	s0,16(sp)
    80003fc8:	00913423          	sd	s1,8(sp)
    80003fcc:	01213023          	sd	s2,0(sp)
    80003fd0:	02010413          	addi	s0,sp,32
    80003fd4:	00050493          	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003fd8:	01050913          	addi	s2,a0,16
    80003fdc:	00090513          	mv	a0,s2
    80003fe0:	1b9010ef          	jal	80005998 <holdingsleep>
    80003fe4:	08050663          	beqz	a0,80004070 <brelse+0xb4>
    panic("brelse");

  releasesleep(&b->lock);
    80003fe8:	00090513          	mv	a0,s2
    80003fec:	155010ef          	jal	80005940 <releasesleep>

  acquire(&bcache.lock);
    80003ff0:	00014517          	auipc	a0,0x14
    80003ff4:	88850513          	addi	a0,a0,-1912 # 80017878 <bcache>
    80003ff8:	850fd0ef          	jal	80001048 <acquire>
  b->refcnt--;
    80003ffc:	0404a783          	lw	a5,64(s1)
    80004000:	fff7879b          	addiw	a5,a5,-1
    80004004:	0007871b          	sext.w	a4,a5
    80004008:	04f4a023          	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000400c:	04071063          	bnez	a4,8000404c <brelse+0x90>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80004010:	0504b703          	ld	a4,80(s1)
    80004014:	0484b783          	ld	a5,72(s1)
    80004018:	04f73423          	sd	a5,72(a4)
    b->prev->next = b->next;
    8000401c:	0504b703          	ld	a4,80(s1)
    80004020:	04e7b823          	sd	a4,80(a5)
    b->next = bcache.head.next;
    80004024:	0001c797          	auipc	a5,0x1c
    80004028:	85478793          	addi	a5,a5,-1964 # 8001f878 <bcache+0x8000>
    8000402c:	2b87b703          	ld	a4,696(a5)
    80004030:	04e4b823          	sd	a4,80(s1)
    b->prev = &bcache.head;
    80004034:	0001c717          	auipc	a4,0x1c
    80004038:	aac70713          	addi	a4,a4,-1364 # 8001fae0 <bcache+0x8268>
    8000403c:	04e4b423          	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80004040:	2b87b703          	ld	a4,696(a5)
    80004044:	04973423          	sd	s1,72(a4)
    bcache.head.next = b;
    80004048:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000404c:	00014517          	auipc	a0,0x14
    80004050:	82c50513          	addi	a0,a0,-2004 # 80017878 <bcache>
    80004054:	8d0fd0ef          	jal	80001124 <release>
}
    80004058:	01813083          	ld	ra,24(sp)
    8000405c:	01013403          	ld	s0,16(sp)
    80004060:	00813483          	ld	s1,8(sp)
    80004064:	00013903          	ld	s2,0(sp)
    80004068:	02010113          	addi	sp,sp,32
    8000406c:	00008067          	ret
    panic("brelse");
    80004070:	00005517          	auipc	a0,0x5
    80004074:	3f050513          	addi	a0,a0,1008 # 80009460 <etext+0x460>
    80004078:	989fc0ef          	jal	80000a00 <panic>

000000008000407c <bpin>:

void
bpin(struct buf *b) {
    8000407c:	fe010113          	addi	sp,sp,-32
    80004080:	00113c23          	sd	ra,24(sp)
    80004084:	00813823          	sd	s0,16(sp)
    80004088:	00913423          	sd	s1,8(sp)
    8000408c:	02010413          	addi	s0,sp,32
    80004090:	00050493          	mv	s1,a0
  acquire(&bcache.lock);
    80004094:	00013517          	auipc	a0,0x13
    80004098:	7e450513          	addi	a0,a0,2020 # 80017878 <bcache>
    8000409c:	fadfc0ef          	jal	80001048 <acquire>
  b->refcnt++;
    800040a0:	0404a783          	lw	a5,64(s1)
    800040a4:	0017879b          	addiw	a5,a5,1
    800040a8:	04f4a023          	sw	a5,64(s1)
  release(&bcache.lock);
    800040ac:	00013517          	auipc	a0,0x13
    800040b0:	7cc50513          	addi	a0,a0,1996 # 80017878 <bcache>
    800040b4:	870fd0ef          	jal	80001124 <release>
}
    800040b8:	01813083          	ld	ra,24(sp)
    800040bc:	01013403          	ld	s0,16(sp)
    800040c0:	00813483          	ld	s1,8(sp)
    800040c4:	02010113          	addi	sp,sp,32
    800040c8:	00008067          	ret

00000000800040cc <bunpin>:

void
bunpin(struct buf *b) {
    800040cc:	fe010113          	addi	sp,sp,-32
    800040d0:	00113c23          	sd	ra,24(sp)
    800040d4:	00813823          	sd	s0,16(sp)
    800040d8:	00913423          	sd	s1,8(sp)
    800040dc:	02010413          	addi	s0,sp,32
    800040e0:	00050493          	mv	s1,a0
  acquire(&bcache.lock);
    800040e4:	00013517          	auipc	a0,0x13
    800040e8:	79450513          	addi	a0,a0,1940 # 80017878 <bcache>
    800040ec:	f5dfc0ef          	jal	80001048 <acquire>
  b->refcnt--;
    800040f0:	0404a783          	lw	a5,64(s1)
    800040f4:	fff7879b          	addiw	a5,a5,-1
    800040f8:	04f4a023          	sw	a5,64(s1)
  release(&bcache.lock);
    800040fc:	00013517          	auipc	a0,0x13
    80004100:	77c50513          	addi	a0,a0,1916 # 80017878 <bcache>
    80004104:	820fd0ef          	jal	80001124 <release>
}
    80004108:	01813083          	ld	ra,24(sp)
    8000410c:	01013403          	ld	s0,16(sp)
    80004110:	00813483          	ld	s1,8(sp)
    80004114:	02010113          	addi	sp,sp,32
    80004118:	00008067          	ret

000000008000411c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000411c:	fe010113          	addi	sp,sp,-32
    80004120:	00113c23          	sd	ra,24(sp)
    80004124:	00813823          	sd	s0,16(sp)
    80004128:	00913423          	sd	s1,8(sp)
    8000412c:	01213023          	sd	s2,0(sp)
    80004130:	02010413          	addi	s0,sp,32
    80004134:	00058493          	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80004138:	00d5d59b          	srliw	a1,a1,0xd
    8000413c:	0001c797          	auipc	a5,0x1c
    80004140:	e187a783          	lw	a5,-488(a5) # 8001ff54 <sb+0x1c>
    80004144:	00f585bb          	addw	a1,a1,a5
    80004148:	d01ff0ef          	jal	80003e48 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000414c:	0074f713          	andi	a4,s1,7
    80004150:	00100793          	li	a5,1
    80004154:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80004158:	03349493          	slli	s1,s1,0x33
    8000415c:	0364d493          	srli	s1,s1,0x36
    80004160:	00950733          	add	a4,a0,s1
    80004164:	05874703          	lbu	a4,88(a4)
    80004168:	00e7f6b3          	and	a3,a5,a4
    8000416c:	02068e63          	beqz	a3,800041a8 <bfree+0x8c>
    80004170:	00050913          	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80004174:	009504b3          	add	s1,a0,s1
    80004178:	fff7c793          	not	a5,a5
    8000417c:	00f77733          	and	a4,a4,a5
    80004180:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80004184:	5d8010ef          	jal	8000575c <log_write>
  brelse(bp);
    80004188:	00090513          	mv	a0,s2
    8000418c:	e31ff0ef          	jal	80003fbc <brelse>
}
    80004190:	01813083          	ld	ra,24(sp)
    80004194:	01013403          	ld	s0,16(sp)
    80004198:	00813483          	ld	s1,8(sp)
    8000419c:	00013903          	ld	s2,0(sp)
    800041a0:	02010113          	addi	sp,sp,32
    800041a4:	00008067          	ret
    panic("freeing free block");
    800041a8:	00005517          	auipc	a0,0x5
    800041ac:	2c050513          	addi	a0,a0,704 # 80009468 <etext+0x468>
    800041b0:	851fc0ef          	jal	80000a00 <panic>

00000000800041b4 <balloc>:
{
    800041b4:	fa010113          	addi	sp,sp,-96
    800041b8:	04113c23          	sd	ra,88(sp)
    800041bc:	04813823          	sd	s0,80(sp)
    800041c0:	04913423          	sd	s1,72(sp)
    800041c4:	06010413          	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800041c8:	0001c797          	auipc	a5,0x1c
    800041cc:	d747a783          	lw	a5,-652(a5) # 8001ff3c <sb+0x4>
    800041d0:	16078863          	beqz	a5,80004340 <balloc+0x18c>
    800041d4:	05213023          	sd	s2,64(sp)
    800041d8:	03313c23          	sd	s3,56(sp)
    800041dc:	03413823          	sd	s4,48(sp)
    800041e0:	03513423          	sd	s5,40(sp)
    800041e4:	03613023          	sd	s6,32(sp)
    800041e8:	01713c23          	sd	s7,24(sp)
    800041ec:	01813823          	sd	s8,16(sp)
    800041f0:	01913423          	sd	s9,8(sp)
    800041f4:	00050b93          	mv	s7,a0
    800041f8:	00000a93          	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800041fc:	0001cb17          	auipc	s6,0x1c
    80004200:	d3cb0b13          	addi	s6,s6,-708 # 8001ff38 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004204:	00000c13          	li	s8,0
      m = 1 << (bi % 8);
    80004208:	00100993          	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000420c:	00002a37          	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80004210:	00002cb7          	lui	s9,0x2
    80004214:	0a00006f          	j	800042b4 <balloc+0x100>
        bp->data[bi/8] |= m;  // Mark block in use.
    80004218:	00f907b3          	add	a5,s2,a5
    8000421c:	00d66633          	or	a2,a2,a3
    80004220:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80004224:	00090513          	mv	a0,s2
    80004228:	534010ef          	jal	8000575c <log_write>
        brelse(bp);
    8000422c:	00090513          	mv	a0,s2
    80004230:	d8dff0ef          	jal	80003fbc <brelse>
  bp = bread(dev, bno);
    80004234:	00048593          	mv	a1,s1
    80004238:	000b8513          	mv	a0,s7
    8000423c:	c0dff0ef          	jal	80003e48 <bread>
    80004240:	00050913          	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80004244:	40000613          	li	a2,1024
    80004248:	00000593          	li	a1,0
    8000424c:	05850513          	addi	a0,a0,88
    80004250:	f29fc0ef          	jal	80001178 <memset>
  log_write(bp);
    80004254:	00090513          	mv	a0,s2
    80004258:	504010ef          	jal	8000575c <log_write>
  brelse(bp);
    8000425c:	00090513          	mv	a0,s2
    80004260:	d5dff0ef          	jal	80003fbc <brelse>
}
    80004264:	04013903          	ld	s2,64(sp)
    80004268:	03813983          	ld	s3,56(sp)
    8000426c:	03013a03          	ld	s4,48(sp)
    80004270:	02813a83          	ld	s5,40(sp)
    80004274:	02013b03          	ld	s6,32(sp)
    80004278:	01813b83          	ld	s7,24(sp)
    8000427c:	01013c03          	ld	s8,16(sp)
    80004280:	00813c83          	ld	s9,8(sp)
}
    80004284:	00048513          	mv	a0,s1
    80004288:	05813083          	ld	ra,88(sp)
    8000428c:	05013403          	ld	s0,80(sp)
    80004290:	04813483          	ld	s1,72(sp)
    80004294:	06010113          	addi	sp,sp,96
    80004298:	00008067          	ret
    brelse(bp);
    8000429c:	00090513          	mv	a0,s2
    800042a0:	d1dff0ef          	jal	80003fbc <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800042a4:	015c87bb          	addw	a5,s9,s5
    800042a8:	00078a9b          	sext.w	s5,a5
    800042ac:	004b2703          	lw	a4,4(s6)
    800042b0:	06eaf863          	bgeu	s5,a4,80004320 <balloc+0x16c>
    bp = bread(dev, BBLOCK(b, sb));
    800042b4:	41fad79b          	sraiw	a5,s5,0x1f
    800042b8:	0137d79b          	srliw	a5,a5,0x13
    800042bc:	015787bb          	addw	a5,a5,s5
    800042c0:	40d7d79b          	sraiw	a5,a5,0xd
    800042c4:	01cb2583          	lw	a1,28(s6)
    800042c8:	00b785bb          	addw	a1,a5,a1
    800042cc:	000b8513          	mv	a0,s7
    800042d0:	b79ff0ef          	jal	80003e48 <bread>
    800042d4:	00050913          	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800042d8:	004b2503          	lw	a0,4(s6)
    800042dc:	000a849b          	sext.w	s1,s5
    800042e0:	000c0713          	mv	a4,s8
    800042e4:	faa4fce3          	bgeu	s1,a0,8000429c <balloc+0xe8>
      m = 1 << (bi % 8);
    800042e8:	00777693          	andi	a3,a4,7
    800042ec:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800042f0:	41f7579b          	sraiw	a5,a4,0x1f
    800042f4:	01d7d79b          	srliw	a5,a5,0x1d
    800042f8:	00e787bb          	addw	a5,a5,a4
    800042fc:	4037d79b          	sraiw	a5,a5,0x3
    80004300:	00f90633          	add	a2,s2,a5
    80004304:	05864603          	lbu	a2,88(a2)
    80004308:	00c6f5b3          	and	a1,a3,a2
    8000430c:	f00586e3          	beqz	a1,80004218 <balloc+0x64>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004310:	0017071b          	addiw	a4,a4,1
    80004314:	0014849b          	addiw	s1,s1,1
    80004318:	fd4716e3          	bne	a4,s4,800042e4 <balloc+0x130>
    8000431c:	f81ff06f          	j	8000429c <balloc+0xe8>
    80004320:	04013903          	ld	s2,64(sp)
    80004324:	03813983          	ld	s3,56(sp)
    80004328:	03013a03          	ld	s4,48(sp)
    8000432c:	02813a83          	ld	s5,40(sp)
    80004330:	02013b03          	ld	s6,32(sp)
    80004334:	01813b83          	ld	s7,24(sp)
    80004338:	01013c03          	ld	s8,16(sp)
    8000433c:	00813c83          	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80004340:	00005517          	auipc	a0,0x5
    80004344:	14050513          	addi	a0,a0,320 # 80009480 <etext+0x480>
    80004348:	b14fc0ef          	jal	8000065c <printf>
  return 0;
    8000434c:	00000493          	li	s1,0
    80004350:	f35ff06f          	j	80004284 <balloc+0xd0>

0000000080004354 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80004354:	fd010113          	addi	sp,sp,-48
    80004358:	02113423          	sd	ra,40(sp)
    8000435c:	02813023          	sd	s0,32(sp)
    80004360:	00913c23          	sd	s1,24(sp)
    80004364:	01213823          	sd	s2,16(sp)
    80004368:	01313423          	sd	s3,8(sp)
    8000436c:	03010413          	addi	s0,sp,48
    80004370:	00050993          	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80004374:	00b00793          	li	a5,11
    80004378:	02b7e863          	bltu	a5,a1,800043a8 <bmap+0x54>
    if((addr = ip->addrs[bn]) == 0){
    8000437c:	02059793          	slli	a5,a1,0x20
    80004380:	01e7d593          	srli	a1,a5,0x1e
    80004384:	00b504b3          	add	s1,a0,a1
    80004388:	0504a903          	lw	s2,80(s1)
    8000438c:	08091463          	bnez	s2,80004414 <bmap+0xc0>
      addr = balloc(ip->dev);
    80004390:	00052503          	lw	a0,0(a0)
    80004394:	e21ff0ef          	jal	800041b4 <balloc>
    80004398:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000439c:	06090c63          	beqz	s2,80004414 <bmap+0xc0>
        return 0;
      ip->addrs[bn] = addr;
    800043a0:	0524a823          	sw	s2,80(s1)
    800043a4:	0700006f          	j	80004414 <bmap+0xc0>
    }
    return addr;
  }
  bn -= NDIRECT;
    800043a8:	ff45849b          	addiw	s1,a1,-12
    800043ac:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800043b0:	0ff00793          	li	a5,255
    800043b4:	0ae7e063          	bltu	a5,a4,80004454 <bmap+0x100>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800043b8:	08052903          	lw	s2,128(a0)
    800043bc:	02091063          	bnez	s2,800043dc <bmap+0x88>
      addr = balloc(ip->dev);
    800043c0:	00052503          	lw	a0,0(a0)
    800043c4:	df1ff0ef          	jal	800041b4 <balloc>
    800043c8:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800043cc:	04090463          	beqz	s2,80004414 <bmap+0xc0>
    800043d0:	01413023          	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800043d4:	0929a023          	sw	s2,128(s3)
    800043d8:	0080006f          	j	800043e0 <bmap+0x8c>
    800043dc:	01413023          	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800043e0:	00090593          	mv	a1,s2
    800043e4:	0009a503          	lw	a0,0(s3)
    800043e8:	a61ff0ef          	jal	80003e48 <bread>
    800043ec:	00050a13          	mv	s4,a0
    a = (uint*)bp->data;
    800043f0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800043f4:	02049713          	slli	a4,s1,0x20
    800043f8:	01e75593          	srli	a1,a4,0x1e
    800043fc:	00b784b3          	add	s1,a5,a1
    80004400:	0004a903          	lw	s2,0(s1)
    80004404:	02090863          	beqz	s2,80004434 <bmap+0xe0>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80004408:	000a0513          	mv	a0,s4
    8000440c:	bb1ff0ef          	jal	80003fbc <brelse>
    return addr;
    80004410:	00013a03          	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80004414:	00090513          	mv	a0,s2
    80004418:	02813083          	ld	ra,40(sp)
    8000441c:	02013403          	ld	s0,32(sp)
    80004420:	01813483          	ld	s1,24(sp)
    80004424:	01013903          	ld	s2,16(sp)
    80004428:	00813983          	ld	s3,8(sp)
    8000442c:	03010113          	addi	sp,sp,48
    80004430:	00008067          	ret
      addr = balloc(ip->dev);
    80004434:	0009a503          	lw	a0,0(s3)
    80004438:	d7dff0ef          	jal	800041b4 <balloc>
    8000443c:	0005091b          	sext.w	s2,a0
      if(addr){
    80004440:	fc0904e3          	beqz	s2,80004408 <bmap+0xb4>
        a[bn] = addr;
    80004444:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80004448:	000a0513          	mv	a0,s4
    8000444c:	310010ef          	jal	8000575c <log_write>
    80004450:	fb9ff06f          	j	80004408 <bmap+0xb4>
    80004454:	01413023          	sd	s4,0(sp)
  panic("bmap: out of range");
    80004458:	00005517          	auipc	a0,0x5
    8000445c:	04050513          	addi	a0,a0,64 # 80009498 <etext+0x498>
    80004460:	da0fc0ef          	jal	80000a00 <panic>

0000000080004464 <iget>:
{
    80004464:	fd010113          	addi	sp,sp,-48
    80004468:	02113423          	sd	ra,40(sp)
    8000446c:	02813023          	sd	s0,32(sp)
    80004470:	00913c23          	sd	s1,24(sp)
    80004474:	01213823          	sd	s2,16(sp)
    80004478:	01313423          	sd	s3,8(sp)
    8000447c:	01413023          	sd	s4,0(sp)
    80004480:	03010413          	addi	s0,sp,48
    80004484:	00050993          	mv	s3,a0
    80004488:	00058a13          	mv	s4,a1
  acquire(&itable.lock);
    8000448c:	0001c517          	auipc	a0,0x1c
    80004490:	acc50513          	addi	a0,a0,-1332 # 8001ff58 <itable>
    80004494:	bb5fc0ef          	jal	80001048 <acquire>
  empty = 0;
    80004498:	00000913          	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000449c:	0001c497          	auipc	s1,0x1c
    800044a0:	ad448493          	addi	s1,s1,-1324 # 8001ff70 <itable+0x18>
    800044a4:	0001d697          	auipc	a3,0x1d
    800044a8:	55c68693          	addi	a3,a3,1372 # 80021a00 <log>
    800044ac:	0100006f          	j	800044bc <iget+0x58>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800044b0:	04090063          	beqz	s2,800044f0 <iget+0x8c>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800044b4:	08848493          	addi	s1,s1,136
    800044b8:	04d48263          	beq	s1,a3,800044fc <iget+0x98>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800044bc:	0084a783          	lw	a5,8(s1)
    800044c0:	fef058e3          	blez	a5,800044b0 <iget+0x4c>
    800044c4:	0004a703          	lw	a4,0(s1)
    800044c8:	ff3714e3          	bne	a4,s3,800044b0 <iget+0x4c>
    800044cc:	0044a703          	lw	a4,4(s1)
    800044d0:	ff4710e3          	bne	a4,s4,800044b0 <iget+0x4c>
      ip->ref++;
    800044d4:	0017879b          	addiw	a5,a5,1
    800044d8:	00f4a423          	sw	a5,8(s1)
      release(&itable.lock);
    800044dc:	0001c517          	auipc	a0,0x1c
    800044e0:	a7c50513          	addi	a0,a0,-1412 # 8001ff58 <itable>
    800044e4:	c41fc0ef          	jal	80001124 <release>
      return ip;
    800044e8:	00048913          	mv	s2,s1
    800044ec:	0340006f          	j	80004520 <iget+0xbc>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800044f0:	fc0792e3          	bnez	a5,800044b4 <iget+0x50>
      empty = ip;
    800044f4:	00048913          	mv	s2,s1
    800044f8:	fbdff06f          	j	800044b4 <iget+0x50>
  if(empty == 0)
    800044fc:	04090463          	beqz	s2,80004544 <iget+0xe0>
  ip->dev = dev;
    80004500:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80004504:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80004508:	00100793          	li	a5,1
    8000450c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80004510:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80004514:	0001c517          	auipc	a0,0x1c
    80004518:	a4450513          	addi	a0,a0,-1468 # 8001ff58 <itable>
    8000451c:	c09fc0ef          	jal	80001124 <release>
}
    80004520:	00090513          	mv	a0,s2
    80004524:	02813083          	ld	ra,40(sp)
    80004528:	02013403          	ld	s0,32(sp)
    8000452c:	01813483          	ld	s1,24(sp)
    80004530:	01013903          	ld	s2,16(sp)
    80004534:	00813983          	ld	s3,8(sp)
    80004538:	00013a03          	ld	s4,0(sp)
    8000453c:	03010113          	addi	sp,sp,48
    80004540:	00008067          	ret
    panic("iget: no inodes");
    80004544:	00005517          	auipc	a0,0x5
    80004548:	f6c50513          	addi	a0,a0,-148 # 800094b0 <etext+0x4b0>
    8000454c:	cb4fc0ef          	jal	80000a00 <panic>

0000000080004550 <fsinit>:
fsinit(int dev) {
    80004550:	fd010113          	addi	sp,sp,-48
    80004554:	02113423          	sd	ra,40(sp)
    80004558:	02813023          	sd	s0,32(sp)
    8000455c:	00913c23          	sd	s1,24(sp)
    80004560:	01213823          	sd	s2,16(sp)
    80004564:	01313423          	sd	s3,8(sp)
    80004568:	03010413          	addi	s0,sp,48
    8000456c:	00050913          	mv	s2,a0
  bp = bread(dev, 1);
    80004570:	00100593          	li	a1,1
    80004574:	8d5ff0ef          	jal	80003e48 <bread>
    80004578:	00050493          	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000457c:	0001c997          	auipc	s3,0x1c
    80004580:	9bc98993          	addi	s3,s3,-1604 # 8001ff38 <sb>
    80004584:	02000613          	li	a2,32
    80004588:	05850593          	addi	a1,a0,88
    8000458c:	00098513          	mv	a0,s3
    80004590:	c7dfc0ef          	jal	8000120c <memmove>
  brelse(bp);
    80004594:	00048513          	mv	a0,s1
    80004598:	a25ff0ef          	jal	80003fbc <brelse>
  if(sb.magic != FSMAGIC)
    8000459c:	0009a703          	lw	a4,0(s3)
    800045a0:	102037b7          	lui	a5,0x10203
    800045a4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800045a8:	02f71863          	bne	a4,a5,800045d8 <fsinit+0x88>
  initlog(dev, &sb);
    800045ac:	0001c597          	auipc	a1,0x1c
    800045b0:	98c58593          	addi	a1,a1,-1652 # 8001ff38 <sb>
    800045b4:	00090513          	mv	a0,s2
    800045b8:	6cd000ef          	jal	80005484 <initlog>
}
    800045bc:	02813083          	ld	ra,40(sp)
    800045c0:	02013403          	ld	s0,32(sp)
    800045c4:	01813483          	ld	s1,24(sp)
    800045c8:	01013903          	ld	s2,16(sp)
    800045cc:	00813983          	ld	s3,8(sp)
    800045d0:	03010113          	addi	sp,sp,48
    800045d4:	00008067          	ret
    panic("invalid file system");
    800045d8:	00005517          	auipc	a0,0x5
    800045dc:	ee850513          	addi	a0,a0,-280 # 800094c0 <etext+0x4c0>
    800045e0:	c20fc0ef          	jal	80000a00 <panic>

00000000800045e4 <iinit>:
{
    800045e4:	fd010113          	addi	sp,sp,-48
    800045e8:	02113423          	sd	ra,40(sp)
    800045ec:	02813023          	sd	s0,32(sp)
    800045f0:	00913c23          	sd	s1,24(sp)
    800045f4:	01213823          	sd	s2,16(sp)
    800045f8:	01313423          	sd	s3,8(sp)
    800045fc:	03010413          	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80004600:	00005597          	auipc	a1,0x5
    80004604:	ed858593          	addi	a1,a1,-296 # 800094d8 <etext+0x4d8>
    80004608:	0001c517          	auipc	a0,0x1c
    8000460c:	95050513          	addi	a0,a0,-1712 # 8001ff58 <itable>
    80004610:	965fc0ef          	jal	80000f74 <initlock>
  for(i = 0; i < NINODE; i++) {
    80004614:	0001c497          	auipc	s1,0x1c
    80004618:	96c48493          	addi	s1,s1,-1684 # 8001ff80 <itable+0x28>
    8000461c:	0001d997          	auipc	s3,0x1d
    80004620:	3f498993          	addi	s3,s3,1012 # 80021a10 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80004624:	00005917          	auipc	s2,0x5
    80004628:	ebc90913          	addi	s2,s2,-324 # 800094e0 <etext+0x4e0>
    8000462c:	00090593          	mv	a1,s2
    80004630:	00048513          	mv	a0,s1
    80004634:	240010ef          	jal	80005874 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80004638:	08848493          	addi	s1,s1,136
    8000463c:	ff3498e3          	bne	s1,s3,8000462c <iinit+0x48>
}
    80004640:	02813083          	ld	ra,40(sp)
    80004644:	02013403          	ld	s0,32(sp)
    80004648:	01813483          	ld	s1,24(sp)
    8000464c:	01013903          	ld	s2,16(sp)
    80004650:	00813983          	ld	s3,8(sp)
    80004654:	03010113          	addi	sp,sp,48
    80004658:	00008067          	ret

000000008000465c <ialloc>:
{
    8000465c:	fc010113          	addi	sp,sp,-64
    80004660:	02113c23          	sd	ra,56(sp)
    80004664:	02813823          	sd	s0,48(sp)
    80004668:	04010413          	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000466c:	0001c717          	auipc	a4,0x1c
    80004670:	8d872703          	lw	a4,-1832(a4) # 8001ff44 <sb+0xc>
    80004674:	00100793          	li	a5,1
    80004678:	08e7f663          	bgeu	a5,a4,80004704 <ialloc+0xa8>
    8000467c:	02913423          	sd	s1,40(sp)
    80004680:	03213023          	sd	s2,32(sp)
    80004684:	01313c23          	sd	s3,24(sp)
    80004688:	01413823          	sd	s4,16(sp)
    8000468c:	01513423          	sd	s5,8(sp)
    80004690:	01613023          	sd	s6,0(sp)
    80004694:	00050a93          	mv	s5,a0
    80004698:	00058b13          	mv	s6,a1
    8000469c:	00100913          	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800046a0:	0001ca17          	auipc	s4,0x1c
    800046a4:	898a0a13          	addi	s4,s4,-1896 # 8001ff38 <sb>
    800046a8:	00495593          	srli	a1,s2,0x4
    800046ac:	018a2783          	lw	a5,24(s4)
    800046b0:	00b785bb          	addw	a1,a5,a1
    800046b4:	000a8513          	mv	a0,s5
    800046b8:	f90ff0ef          	jal	80003e48 <bread>
    800046bc:	00050493          	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800046c0:	05850993          	addi	s3,a0,88
    800046c4:	00f97793          	andi	a5,s2,15
    800046c8:	00679793          	slli	a5,a5,0x6
    800046cc:	00f989b3          	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800046d0:	00099783          	lh	a5,0(s3)
    800046d4:	04078863          	beqz	a5,80004724 <ialloc+0xc8>
    brelse(bp);
    800046d8:	8e5ff0ef          	jal	80003fbc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800046dc:	00190913          	addi	s2,s2,1
    800046e0:	00ca2703          	lw	a4,12(s4)
    800046e4:	0009079b          	sext.w	a5,s2
    800046e8:	fce7e0e3          	bltu	a5,a4,800046a8 <ialloc+0x4c>
    800046ec:	02813483          	ld	s1,40(sp)
    800046f0:	02013903          	ld	s2,32(sp)
    800046f4:	01813983          	ld	s3,24(sp)
    800046f8:	01013a03          	ld	s4,16(sp)
    800046fc:	00813a83          	ld	s5,8(sp)
    80004700:	00013b03          	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80004704:	00005517          	auipc	a0,0x5
    80004708:	de450513          	addi	a0,a0,-540 # 800094e8 <etext+0x4e8>
    8000470c:	f51fb0ef          	jal	8000065c <printf>
  return 0;
    80004710:	00000513          	li	a0,0
}
    80004714:	03813083          	ld	ra,56(sp)
    80004718:	03013403          	ld	s0,48(sp)
    8000471c:	04010113          	addi	sp,sp,64
    80004720:	00008067          	ret
      memset(dip, 0, sizeof(*dip));
    80004724:	04000613          	li	a2,64
    80004728:	00000593          	li	a1,0
    8000472c:	00098513          	mv	a0,s3
    80004730:	a49fc0ef          	jal	80001178 <memset>
      dip->type = type;
    80004734:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80004738:	00048513          	mv	a0,s1
    8000473c:	020010ef          	jal	8000575c <log_write>
      brelse(bp);
    80004740:	00048513          	mv	a0,s1
    80004744:	879ff0ef          	jal	80003fbc <brelse>
      return iget(dev, inum);
    80004748:	0009059b          	sext.w	a1,s2
    8000474c:	000a8513          	mv	a0,s5
    80004750:	d15ff0ef          	jal	80004464 <iget>
    80004754:	02813483          	ld	s1,40(sp)
    80004758:	02013903          	ld	s2,32(sp)
    8000475c:	01813983          	ld	s3,24(sp)
    80004760:	01013a03          	ld	s4,16(sp)
    80004764:	00813a83          	ld	s5,8(sp)
    80004768:	00013b03          	ld	s6,0(sp)
    8000476c:	fa9ff06f          	j	80004714 <ialloc+0xb8>

0000000080004770 <iupdate>:
{
    80004770:	fe010113          	addi	sp,sp,-32
    80004774:	00113c23          	sd	ra,24(sp)
    80004778:	00813823          	sd	s0,16(sp)
    8000477c:	00913423          	sd	s1,8(sp)
    80004780:	01213023          	sd	s2,0(sp)
    80004784:	02010413          	addi	s0,sp,32
    80004788:	00050493          	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000478c:	00452783          	lw	a5,4(a0)
    80004790:	0047d79b          	srliw	a5,a5,0x4
    80004794:	0001b597          	auipc	a1,0x1b
    80004798:	7bc5a583          	lw	a1,1980(a1) # 8001ff50 <sb+0x18>
    8000479c:	00b785bb          	addw	a1,a5,a1
    800047a0:	00052503          	lw	a0,0(a0)
    800047a4:	ea4ff0ef          	jal	80003e48 <bread>
    800047a8:	00050913          	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800047ac:	05850793          	addi	a5,a0,88
    800047b0:	0044a703          	lw	a4,4(s1)
    800047b4:	00f77713          	andi	a4,a4,15
    800047b8:	00671713          	slli	a4,a4,0x6
    800047bc:	00e787b3          	add	a5,a5,a4
  dip->type = ip->type;
    800047c0:	04449703          	lh	a4,68(s1)
    800047c4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800047c8:	04649703          	lh	a4,70(s1)
    800047cc:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800047d0:	04849703          	lh	a4,72(s1)
    800047d4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800047d8:	04a49703          	lh	a4,74(s1)
    800047dc:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800047e0:	04c4a703          	lw	a4,76(s1)
    800047e4:	00e7a423          	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800047e8:	03400613          	li	a2,52
    800047ec:	05048593          	addi	a1,s1,80
    800047f0:	00c78513          	addi	a0,a5,12
    800047f4:	a19fc0ef          	jal	8000120c <memmove>
  log_write(bp);
    800047f8:	00090513          	mv	a0,s2
    800047fc:	761000ef          	jal	8000575c <log_write>
  brelse(bp);
    80004800:	00090513          	mv	a0,s2
    80004804:	fb8ff0ef          	jal	80003fbc <brelse>
}
    80004808:	01813083          	ld	ra,24(sp)
    8000480c:	01013403          	ld	s0,16(sp)
    80004810:	00813483          	ld	s1,8(sp)
    80004814:	00013903          	ld	s2,0(sp)
    80004818:	02010113          	addi	sp,sp,32
    8000481c:	00008067          	ret

0000000080004820 <idup>:
{
    80004820:	fe010113          	addi	sp,sp,-32
    80004824:	00113c23          	sd	ra,24(sp)
    80004828:	00813823          	sd	s0,16(sp)
    8000482c:	00913423          	sd	s1,8(sp)
    80004830:	02010413          	addi	s0,sp,32
    80004834:	00050493          	mv	s1,a0
  acquire(&itable.lock);
    80004838:	0001b517          	auipc	a0,0x1b
    8000483c:	72050513          	addi	a0,a0,1824 # 8001ff58 <itable>
    80004840:	809fc0ef          	jal	80001048 <acquire>
  ip->ref++;
    80004844:	0084a783          	lw	a5,8(s1)
    80004848:	0017879b          	addiw	a5,a5,1
    8000484c:	00f4a423          	sw	a5,8(s1)
  release(&itable.lock);
    80004850:	0001b517          	auipc	a0,0x1b
    80004854:	70850513          	addi	a0,a0,1800 # 8001ff58 <itable>
    80004858:	8cdfc0ef          	jal	80001124 <release>
}
    8000485c:	00048513          	mv	a0,s1
    80004860:	01813083          	ld	ra,24(sp)
    80004864:	01013403          	ld	s0,16(sp)
    80004868:	00813483          	ld	s1,8(sp)
    8000486c:	02010113          	addi	sp,sp,32
    80004870:	00008067          	ret

0000000080004874 <ilock>:
{
    80004874:	fe010113          	addi	sp,sp,-32
    80004878:	00113c23          	sd	ra,24(sp)
    8000487c:	00813823          	sd	s0,16(sp)
    80004880:	00913423          	sd	s1,8(sp)
    80004884:	02010413          	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80004888:	02050a63          	beqz	a0,800048bc <ilock+0x48>
    8000488c:	00050493          	mv	s1,a0
    80004890:	00852783          	lw	a5,8(a0)
    80004894:	02f05463          	blez	a5,800048bc <ilock+0x48>
  acquiresleep(&ip->lock);
    80004898:	01050513          	addi	a0,a0,16
    8000489c:	02c010ef          	jal	800058c8 <acquiresleep>
  if(ip->valid == 0){
    800048a0:	0404a783          	lw	a5,64(s1)
    800048a4:	02078463          	beqz	a5,800048cc <ilock+0x58>
}
    800048a8:	01813083          	ld	ra,24(sp)
    800048ac:	01013403          	ld	s0,16(sp)
    800048b0:	00813483          	ld	s1,8(sp)
    800048b4:	02010113          	addi	sp,sp,32
    800048b8:	00008067          	ret
    800048bc:	01213023          	sd	s2,0(sp)
    panic("ilock");
    800048c0:	00005517          	auipc	a0,0x5
    800048c4:	c4050513          	addi	a0,a0,-960 # 80009500 <etext+0x500>
    800048c8:	938fc0ef          	jal	80000a00 <panic>
    800048cc:	01213023          	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800048d0:	0044a783          	lw	a5,4(s1)
    800048d4:	0047d79b          	srliw	a5,a5,0x4
    800048d8:	0001b597          	auipc	a1,0x1b
    800048dc:	6785a583          	lw	a1,1656(a1) # 8001ff50 <sb+0x18>
    800048e0:	00b785bb          	addw	a1,a5,a1
    800048e4:	0004a503          	lw	a0,0(s1)
    800048e8:	d60ff0ef          	jal	80003e48 <bread>
    800048ec:	00050913          	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800048f0:	05850593          	addi	a1,a0,88
    800048f4:	0044a783          	lw	a5,4(s1)
    800048f8:	00f7f793          	andi	a5,a5,15
    800048fc:	00679793          	slli	a5,a5,0x6
    80004900:	00f585b3          	add	a1,a1,a5
    ip->type = dip->type;
    80004904:	00059783          	lh	a5,0(a1)
    80004908:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000490c:	00259783          	lh	a5,2(a1)
    80004910:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80004914:	00459783          	lh	a5,4(a1)
    80004918:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000491c:	00659783          	lh	a5,6(a1)
    80004920:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80004924:	0085a783          	lw	a5,8(a1)
    80004928:	04f4a623          	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000492c:	03400613          	li	a2,52
    80004930:	00c58593          	addi	a1,a1,12
    80004934:	05048513          	addi	a0,s1,80
    80004938:	8d5fc0ef          	jal	8000120c <memmove>
    brelse(bp);
    8000493c:	00090513          	mv	a0,s2
    80004940:	e7cff0ef          	jal	80003fbc <brelse>
    ip->valid = 1;
    80004944:	00100793          	li	a5,1
    80004948:	04f4a023          	sw	a5,64(s1)
    if(ip->type == 0)
    8000494c:	04449783          	lh	a5,68(s1)
    80004950:	00078663          	beqz	a5,8000495c <ilock+0xe8>
    80004954:	00013903          	ld	s2,0(sp)
    80004958:	f51ff06f          	j	800048a8 <ilock+0x34>
      panic("ilock: no type");
    8000495c:	00005517          	auipc	a0,0x5
    80004960:	bac50513          	addi	a0,a0,-1108 # 80009508 <etext+0x508>
    80004964:	89cfc0ef          	jal	80000a00 <panic>

0000000080004968 <iunlock>:
{
    80004968:	fe010113          	addi	sp,sp,-32
    8000496c:	00113c23          	sd	ra,24(sp)
    80004970:	00813823          	sd	s0,16(sp)
    80004974:	00913423          	sd	s1,8(sp)
    80004978:	01213023          	sd	s2,0(sp)
    8000497c:	02010413          	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004980:	04050063          	beqz	a0,800049c0 <iunlock+0x58>
    80004984:	00050493          	mv	s1,a0
    80004988:	01050913          	addi	s2,a0,16
    8000498c:	00090513          	mv	a0,s2
    80004990:	008010ef          	jal	80005998 <holdingsleep>
    80004994:	02050663          	beqz	a0,800049c0 <iunlock+0x58>
    80004998:	0084a783          	lw	a5,8(s1)
    8000499c:	02f05263          	blez	a5,800049c0 <iunlock+0x58>
  releasesleep(&ip->lock);
    800049a0:	00090513          	mv	a0,s2
    800049a4:	79d000ef          	jal	80005940 <releasesleep>
}
    800049a8:	01813083          	ld	ra,24(sp)
    800049ac:	01013403          	ld	s0,16(sp)
    800049b0:	00813483          	ld	s1,8(sp)
    800049b4:	00013903          	ld	s2,0(sp)
    800049b8:	02010113          	addi	sp,sp,32
    800049bc:	00008067          	ret
    panic("iunlock");
    800049c0:	00005517          	auipc	a0,0x5
    800049c4:	b5850513          	addi	a0,a0,-1192 # 80009518 <etext+0x518>
    800049c8:	838fc0ef          	jal	80000a00 <panic>

00000000800049cc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800049cc:	fd010113          	addi	sp,sp,-48
    800049d0:	02113423          	sd	ra,40(sp)
    800049d4:	02813023          	sd	s0,32(sp)
    800049d8:	00913c23          	sd	s1,24(sp)
    800049dc:	01213823          	sd	s2,16(sp)
    800049e0:	01313423          	sd	s3,8(sp)
    800049e4:	03010413          	addi	s0,sp,48
    800049e8:	00050993          	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800049ec:	05050493          	addi	s1,a0,80
    800049f0:	08050913          	addi	s2,a0,128
    800049f4:	00c0006f          	j	80004a00 <itrunc+0x34>
    800049f8:	00448493          	addi	s1,s1,4
    800049fc:	01248e63          	beq	s1,s2,80004a18 <itrunc+0x4c>
    if(ip->addrs[i]){
    80004a00:	0004a583          	lw	a1,0(s1)
    80004a04:	fe058ae3          	beqz	a1,800049f8 <itrunc+0x2c>
      bfree(ip->dev, ip->addrs[i]);
    80004a08:	0009a503          	lw	a0,0(s3)
    80004a0c:	f10ff0ef          	jal	8000411c <bfree>
      ip->addrs[i] = 0;
    80004a10:	0004a023          	sw	zero,0(s1)
    80004a14:	fe5ff06f          	j	800049f8 <itrunc+0x2c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80004a18:	0809a583          	lw	a1,128(s3)
    80004a1c:	02059663          	bnez	a1,80004a48 <itrunc+0x7c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80004a20:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80004a24:	00098513          	mv	a0,s3
    80004a28:	d49ff0ef          	jal	80004770 <iupdate>
}
    80004a2c:	02813083          	ld	ra,40(sp)
    80004a30:	02013403          	ld	s0,32(sp)
    80004a34:	01813483          	ld	s1,24(sp)
    80004a38:	01013903          	ld	s2,16(sp)
    80004a3c:	00813983          	ld	s3,8(sp)
    80004a40:	03010113          	addi	sp,sp,48
    80004a44:	00008067          	ret
    80004a48:	01413023          	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80004a4c:	0009a503          	lw	a0,0(s3)
    80004a50:	bf8ff0ef          	jal	80003e48 <bread>
    80004a54:	00050a13          	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80004a58:	05850493          	addi	s1,a0,88
    80004a5c:	45850913          	addi	s2,a0,1112
    80004a60:	00c0006f          	j	80004a6c <itrunc+0xa0>
    80004a64:	00448493          	addi	s1,s1,4
    80004a68:	01248c63          	beq	s1,s2,80004a80 <itrunc+0xb4>
      if(a[j])
    80004a6c:	0004a583          	lw	a1,0(s1)
    80004a70:	fe058ae3          	beqz	a1,80004a64 <itrunc+0x98>
        bfree(ip->dev, a[j]);
    80004a74:	0009a503          	lw	a0,0(s3)
    80004a78:	ea4ff0ef          	jal	8000411c <bfree>
    80004a7c:	fe9ff06f          	j	80004a64 <itrunc+0x98>
    brelse(bp);
    80004a80:	000a0513          	mv	a0,s4
    80004a84:	d38ff0ef          	jal	80003fbc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004a88:	0809a583          	lw	a1,128(s3)
    80004a8c:	0009a503          	lw	a0,0(s3)
    80004a90:	e8cff0ef          	jal	8000411c <bfree>
    ip->addrs[NDIRECT] = 0;
    80004a94:	0809a023          	sw	zero,128(s3)
    80004a98:	00013a03          	ld	s4,0(sp)
    80004a9c:	f85ff06f          	j	80004a20 <itrunc+0x54>

0000000080004aa0 <iput>:
{
    80004aa0:	fe010113          	addi	sp,sp,-32
    80004aa4:	00113c23          	sd	ra,24(sp)
    80004aa8:	00813823          	sd	s0,16(sp)
    80004aac:	00913423          	sd	s1,8(sp)
    80004ab0:	02010413          	addi	s0,sp,32
    80004ab4:	00050493          	mv	s1,a0
  acquire(&itable.lock);
    80004ab8:	0001b517          	auipc	a0,0x1b
    80004abc:	4a050513          	addi	a0,a0,1184 # 8001ff58 <itable>
    80004ac0:	d88fc0ef          	jal	80001048 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004ac4:	0084a703          	lw	a4,8(s1)
    80004ac8:	00100793          	li	a5,1
    80004acc:	02f70863          	beq	a4,a5,80004afc <iput+0x5c>
  ip->ref--;
    80004ad0:	0084a783          	lw	a5,8(s1)
    80004ad4:	fff7879b          	addiw	a5,a5,-1
    80004ad8:	00f4a423          	sw	a5,8(s1)
  release(&itable.lock);
    80004adc:	0001b517          	auipc	a0,0x1b
    80004ae0:	47c50513          	addi	a0,a0,1148 # 8001ff58 <itable>
    80004ae4:	e40fc0ef          	jal	80001124 <release>
}
    80004ae8:	01813083          	ld	ra,24(sp)
    80004aec:	01013403          	ld	s0,16(sp)
    80004af0:	00813483          	ld	s1,8(sp)
    80004af4:	02010113          	addi	sp,sp,32
    80004af8:	00008067          	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004afc:	0404a783          	lw	a5,64(s1)
    80004b00:	fc0788e3          	beqz	a5,80004ad0 <iput+0x30>
    80004b04:	04a49783          	lh	a5,74(s1)
    80004b08:	fc0794e3          	bnez	a5,80004ad0 <iput+0x30>
    80004b0c:	01213023          	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80004b10:	01048913          	addi	s2,s1,16
    80004b14:	00090513          	mv	a0,s2
    80004b18:	5b1000ef          	jal	800058c8 <acquiresleep>
    release(&itable.lock);
    80004b1c:	0001b517          	auipc	a0,0x1b
    80004b20:	43c50513          	addi	a0,a0,1084 # 8001ff58 <itable>
    80004b24:	e00fc0ef          	jal	80001124 <release>
    itrunc(ip);
    80004b28:	00048513          	mv	a0,s1
    80004b2c:	ea1ff0ef          	jal	800049cc <itrunc>
    ip->type = 0;
    80004b30:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004b34:	00048513          	mv	a0,s1
    80004b38:	c39ff0ef          	jal	80004770 <iupdate>
    ip->valid = 0;
    80004b3c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004b40:	00090513          	mv	a0,s2
    80004b44:	5fd000ef          	jal	80005940 <releasesleep>
    acquire(&itable.lock);
    80004b48:	0001b517          	auipc	a0,0x1b
    80004b4c:	41050513          	addi	a0,a0,1040 # 8001ff58 <itable>
    80004b50:	cf8fc0ef          	jal	80001048 <acquire>
    80004b54:	00013903          	ld	s2,0(sp)
    80004b58:	f79ff06f          	j	80004ad0 <iput+0x30>

0000000080004b5c <iunlockput>:
{
    80004b5c:	fe010113          	addi	sp,sp,-32
    80004b60:	00113c23          	sd	ra,24(sp)
    80004b64:	00813823          	sd	s0,16(sp)
    80004b68:	00913423          	sd	s1,8(sp)
    80004b6c:	02010413          	addi	s0,sp,32
    80004b70:	00050493          	mv	s1,a0
  iunlock(ip);
    80004b74:	df5ff0ef          	jal	80004968 <iunlock>
  iput(ip);
    80004b78:	00048513          	mv	a0,s1
    80004b7c:	f25ff0ef          	jal	80004aa0 <iput>
}
    80004b80:	01813083          	ld	ra,24(sp)
    80004b84:	01013403          	ld	s0,16(sp)
    80004b88:	00813483          	ld	s1,8(sp)
    80004b8c:	02010113          	addi	sp,sp,32
    80004b90:	00008067          	ret

0000000080004b94 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004b94:	ff010113          	addi	sp,sp,-16
    80004b98:	00813423          	sd	s0,8(sp)
    80004b9c:	01010413          	addi	s0,sp,16
  st->dev = ip->dev;
    80004ba0:	00052783          	lw	a5,0(a0)
    80004ba4:	00f5a023          	sw	a5,0(a1)
  st->ino = ip->inum;
    80004ba8:	00452783          	lw	a5,4(a0)
    80004bac:	00f5a223          	sw	a5,4(a1)
  st->type = ip->type;
    80004bb0:	04451783          	lh	a5,68(a0)
    80004bb4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004bb8:	04a51783          	lh	a5,74(a0)
    80004bbc:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004bc0:	04c56783          	lwu	a5,76(a0)
    80004bc4:	00f5b823          	sd	a5,16(a1)
}
    80004bc8:	00813403          	ld	s0,8(sp)
    80004bcc:	01010113          	addi	sp,sp,16
    80004bd0:	00008067          	ret

0000000080004bd4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004bd4:	04c52783          	lw	a5,76(a0)
    80004bd8:	18d7e063          	bltu	a5,a3,80004d58 <readi+0x184>
{
    80004bdc:	f9010113          	addi	sp,sp,-112
    80004be0:	06113423          	sd	ra,104(sp)
    80004be4:	06813023          	sd	s0,96(sp)
    80004be8:	04913c23          	sd	s1,88(sp)
    80004bec:	05413023          	sd	s4,64(sp)
    80004bf0:	03513c23          	sd	s5,56(sp)
    80004bf4:	03613823          	sd	s6,48(sp)
    80004bf8:	03713423          	sd	s7,40(sp)
    80004bfc:	07010413          	addi	s0,sp,112
    80004c00:	00050b13          	mv	s6,a0
    80004c04:	00058b93          	mv	s7,a1
    80004c08:	00060a13          	mv	s4,a2
    80004c0c:	00068493          	mv	s1,a3
    80004c10:	00070a93          	mv	s5,a4
  if(off > ip->size || off + n < off)
    80004c14:	00e6873b          	addw	a4,a3,a4
    return 0;
    80004c18:	00000513          	li	a0,0
  if(off > ip->size || off + n < off)
    80004c1c:	10d76c63          	bltu	a4,a3,80004d34 <readi+0x160>
    80004c20:	05313423          	sd	s3,72(sp)
  if(off + n > ip->size)
    80004c24:	00e7f463          	bgeu	a5,a4,80004c2c <readi+0x58>
    n = ip->size - off;
    80004c28:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004c2c:	0e0a8263          	beqz	s5,80004d10 <readi+0x13c>
    80004c30:	05213823          	sd	s2,80(sp)
    80004c34:	03813023          	sd	s8,32(sp)
    80004c38:	01913c23          	sd	s9,24(sp)
    80004c3c:	01a13823          	sd	s10,16(sp)
    80004c40:	01b13423          	sd	s11,8(sp)
    80004c44:	00000993          	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004c48:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004c4c:	fff00c13          	li	s8,-1
    80004c50:	0400006f          	j	80004c90 <readi+0xbc>
    80004c54:	020d1d93          	slli	s11,s10,0x20
    80004c58:	020ddd93          	srli	s11,s11,0x20
    80004c5c:	05890613          	addi	a2,s2,88
    80004c60:	000d8693          	mv	a3,s11
    80004c64:	00e60633          	add	a2,a2,a4
    80004c68:	000a0593          	mv	a1,s4
    80004c6c:	000b8513          	mv	a0,s7
    80004c70:	d54fe0ef          	jal	800031c4 <either_copyout>
    80004c74:	07850063          	beq	a0,s8,80004cd4 <readi+0x100>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004c78:	00090513          	mv	a0,s2
    80004c7c:	b40ff0ef          	jal	80003fbc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004c80:	013d09bb          	addw	s3,s10,s3
    80004c84:	009d04bb          	addw	s1,s10,s1
    80004c88:	01ba0a33          	add	s4,s4,s11
    80004c8c:	0759f663          	bgeu	s3,s5,80004cf8 <readi+0x124>
    uint addr = bmap(ip, off/BSIZE);
    80004c90:	00a4d59b          	srliw	a1,s1,0xa
    80004c94:	000b0513          	mv	a0,s6
    80004c98:	ebcff0ef          	jal	80004354 <bmap>
    80004c9c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004ca0:	06058c63          	beqz	a1,80004d18 <readi+0x144>
    bp = bread(ip->dev, addr);
    80004ca4:	000b2503          	lw	a0,0(s6)
    80004ca8:	9a0ff0ef          	jal	80003e48 <bread>
    80004cac:	00050913          	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004cb0:	3ff4f713          	andi	a4,s1,1023
    80004cb4:	40ec87bb          	subw	a5,s9,a4
    80004cb8:	413a86bb          	subw	a3,s5,s3
    80004cbc:	00078d13          	mv	s10,a5
    80004cc0:	0007879b          	sext.w	a5,a5
    80004cc4:	0006861b          	sext.w	a2,a3
    80004cc8:	f8f676e3          	bgeu	a2,a5,80004c54 <readi+0x80>
    80004ccc:	00068d13          	mv	s10,a3
    80004cd0:	f85ff06f          	j	80004c54 <readi+0x80>
      brelse(bp);
    80004cd4:	00090513          	mv	a0,s2
    80004cd8:	ae4ff0ef          	jal	80003fbc <brelse>
      tot = -1;
    80004cdc:	fff00993          	li	s3,-1
      break;
    80004ce0:	05013903          	ld	s2,80(sp)
    80004ce4:	02013c03          	ld	s8,32(sp)
    80004ce8:	01813c83          	ld	s9,24(sp)
    80004cec:	01013d03          	ld	s10,16(sp)
    80004cf0:	00813d83          	ld	s11,8(sp)
    80004cf4:	0380006f          	j	80004d2c <readi+0x158>
    80004cf8:	05013903          	ld	s2,80(sp)
    80004cfc:	02013c03          	ld	s8,32(sp)
    80004d00:	01813c83          	ld	s9,24(sp)
    80004d04:	01013d03          	ld	s10,16(sp)
    80004d08:	00813d83          	ld	s11,8(sp)
    80004d0c:	0200006f          	j	80004d2c <readi+0x158>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004d10:	000a8993          	mv	s3,s5
    80004d14:	0180006f          	j	80004d2c <readi+0x158>
    80004d18:	05013903          	ld	s2,80(sp)
    80004d1c:	02013c03          	ld	s8,32(sp)
    80004d20:	01813c83          	ld	s9,24(sp)
    80004d24:	01013d03          	ld	s10,16(sp)
    80004d28:	00813d83          	ld	s11,8(sp)
  }
  return tot;
    80004d2c:	0009851b          	sext.w	a0,s3
    80004d30:	04813983          	ld	s3,72(sp)
}
    80004d34:	06813083          	ld	ra,104(sp)
    80004d38:	06013403          	ld	s0,96(sp)
    80004d3c:	05813483          	ld	s1,88(sp)
    80004d40:	04013a03          	ld	s4,64(sp)
    80004d44:	03813a83          	ld	s5,56(sp)
    80004d48:	03013b03          	ld	s6,48(sp)
    80004d4c:	02813b83          	ld	s7,40(sp)
    80004d50:	07010113          	addi	sp,sp,112
    80004d54:	00008067          	ret
    return 0;
    80004d58:	00000513          	li	a0,0
}
    80004d5c:	00008067          	ret

0000000080004d60 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004d60:	04c52783          	lw	a5,76(a0)
    80004d64:	16d7ee63          	bltu	a5,a3,80004ee0 <writei+0x180>
{
    80004d68:	f9010113          	addi	sp,sp,-112
    80004d6c:	06113423          	sd	ra,104(sp)
    80004d70:	06813023          	sd	s0,96(sp)
    80004d74:	05213823          	sd	s2,80(sp)
    80004d78:	05413023          	sd	s4,64(sp)
    80004d7c:	03513c23          	sd	s5,56(sp)
    80004d80:	03613823          	sd	s6,48(sp)
    80004d84:	03713423          	sd	s7,40(sp)
    80004d88:	07010413          	addi	s0,sp,112
    80004d8c:	00050a93          	mv	s5,a0
    80004d90:	00058b93          	mv	s7,a1
    80004d94:	00060a13          	mv	s4,a2
    80004d98:	00068913          	mv	s2,a3
    80004d9c:	00070b13          	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004da0:	00e687bb          	addw	a5,a3,a4
    80004da4:	14d7e263          	bltu	a5,a3,80004ee8 <writei+0x188>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004da8:	00043737          	lui	a4,0x43
    80004dac:	14f76263          	bltu	a4,a5,80004ef0 <writei+0x190>
    80004db0:	05313423          	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004db4:	100b0663          	beqz	s6,80004ec0 <writei+0x160>
    80004db8:	04913c23          	sd	s1,88(sp)
    80004dbc:	03813023          	sd	s8,32(sp)
    80004dc0:	01913c23          	sd	s9,24(sp)
    80004dc4:	01a13823          	sd	s10,16(sp)
    80004dc8:	01b13423          	sd	s11,8(sp)
    80004dcc:	00000993          	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004dd0:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004dd4:	fff00c13          	li	s8,-1
    80004dd8:	0480006f          	j	80004e20 <writei+0xc0>
    80004ddc:	020d1d93          	slli	s11,s10,0x20
    80004de0:	020ddd93          	srli	s11,s11,0x20
    80004de4:	05848513          	addi	a0,s1,88
    80004de8:	000d8693          	mv	a3,s11
    80004dec:	000a0613          	mv	a2,s4
    80004df0:	000b8593          	mv	a1,s7
    80004df4:	00e50533          	add	a0,a0,a4
    80004df8:	c50fe0ef          	jal	80003248 <either_copyin>
    80004dfc:	07850463          	beq	a0,s8,80004e64 <writei+0x104>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004e00:	00048513          	mv	a0,s1
    80004e04:	159000ef          	jal	8000575c <log_write>
    brelse(bp);
    80004e08:	00048513          	mv	a0,s1
    80004e0c:	9b0ff0ef          	jal	80003fbc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004e10:	013d09bb          	addw	s3,s10,s3
    80004e14:	012d093b          	addw	s2,s10,s2
    80004e18:	01ba0a33          	add	s4,s4,s11
    80004e1c:	0569f863          	bgeu	s3,s6,80004e6c <writei+0x10c>
    uint addr = bmap(ip, off/BSIZE);
    80004e20:	00a9559b          	srliw	a1,s2,0xa
    80004e24:	000a8513          	mv	a0,s5
    80004e28:	d2cff0ef          	jal	80004354 <bmap>
    80004e2c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004e30:	02058e63          	beqz	a1,80004e6c <writei+0x10c>
    bp = bread(ip->dev, addr);
    80004e34:	000aa503          	lw	a0,0(s5)
    80004e38:	810ff0ef          	jal	80003e48 <bread>
    80004e3c:	00050493          	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004e40:	3ff97713          	andi	a4,s2,1023
    80004e44:	40ec87bb          	subw	a5,s9,a4
    80004e48:	413b06bb          	subw	a3,s6,s3
    80004e4c:	00078d13          	mv	s10,a5
    80004e50:	0007879b          	sext.w	a5,a5
    80004e54:	0006861b          	sext.w	a2,a3
    80004e58:	f8f672e3          	bgeu	a2,a5,80004ddc <writei+0x7c>
    80004e5c:	00068d13          	mv	s10,a3
    80004e60:	f7dff06f          	j	80004ddc <writei+0x7c>
      brelse(bp);
    80004e64:	00048513          	mv	a0,s1
    80004e68:	954ff0ef          	jal	80003fbc <brelse>
  }

  if(off > ip->size)
    80004e6c:	04caa783          	lw	a5,76(s5)
    80004e70:	0527fc63          	bgeu	a5,s2,80004ec8 <writei+0x168>
    ip->size = off;
    80004e74:	052aa623          	sw	s2,76(s5)
    80004e78:	05813483          	ld	s1,88(sp)
    80004e7c:	02013c03          	ld	s8,32(sp)
    80004e80:	01813c83          	ld	s9,24(sp)
    80004e84:	01013d03          	ld	s10,16(sp)
    80004e88:	00813d83          	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004e8c:	000a8513          	mv	a0,s5
    80004e90:	8e1ff0ef          	jal	80004770 <iupdate>

  return tot;
    80004e94:	0009851b          	sext.w	a0,s3
    80004e98:	04813983          	ld	s3,72(sp)
}
    80004e9c:	06813083          	ld	ra,104(sp)
    80004ea0:	06013403          	ld	s0,96(sp)
    80004ea4:	05013903          	ld	s2,80(sp)
    80004ea8:	04013a03          	ld	s4,64(sp)
    80004eac:	03813a83          	ld	s5,56(sp)
    80004eb0:	03013b03          	ld	s6,48(sp)
    80004eb4:	02813b83          	ld	s7,40(sp)
    80004eb8:	07010113          	addi	sp,sp,112
    80004ebc:	00008067          	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004ec0:	000b0993          	mv	s3,s6
    80004ec4:	fc9ff06f          	j	80004e8c <writei+0x12c>
    80004ec8:	05813483          	ld	s1,88(sp)
    80004ecc:	02013c03          	ld	s8,32(sp)
    80004ed0:	01813c83          	ld	s9,24(sp)
    80004ed4:	01013d03          	ld	s10,16(sp)
    80004ed8:	00813d83          	ld	s11,8(sp)
    80004edc:	fb1ff06f          	j	80004e8c <writei+0x12c>
    return -1;
    80004ee0:	fff00513          	li	a0,-1
}
    80004ee4:	00008067          	ret
    return -1;
    80004ee8:	fff00513          	li	a0,-1
    80004eec:	fb1ff06f          	j	80004e9c <writei+0x13c>
    return -1;
    80004ef0:	fff00513          	li	a0,-1
    80004ef4:	fa9ff06f          	j	80004e9c <writei+0x13c>

0000000080004ef8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004ef8:	ff010113          	addi	sp,sp,-16
    80004efc:	00113423          	sd	ra,8(sp)
    80004f00:	00813023          	sd	s0,0(sp)
    80004f04:	01010413          	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004f08:	00e00613          	li	a2,14
    80004f0c:	ba8fc0ef          	jal	800012b4 <strncmp>
}
    80004f10:	00813083          	ld	ra,8(sp)
    80004f14:	00013403          	ld	s0,0(sp)
    80004f18:	01010113          	addi	sp,sp,16
    80004f1c:	00008067          	ret

0000000080004f20 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004f20:	fc010113          	addi	sp,sp,-64
    80004f24:	02113c23          	sd	ra,56(sp)
    80004f28:	02813823          	sd	s0,48(sp)
    80004f2c:	02913423          	sd	s1,40(sp)
    80004f30:	03213023          	sd	s2,32(sp)
    80004f34:	01313c23          	sd	s3,24(sp)
    80004f38:	01413823          	sd	s4,16(sp)
    80004f3c:	04010413          	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004f40:	04451703          	lh	a4,68(a0)
    80004f44:	00100793          	li	a5,1
    80004f48:	02f71263          	bne	a4,a5,80004f6c <dirlookup+0x4c>
    80004f4c:	00050913          	mv	s2,a0
    80004f50:	00058993          	mv	s3,a1
    80004f54:	00060a13          	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004f58:	04c52783          	lw	a5,76(a0)
    80004f5c:	00000493          	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004f60:	00000513          	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004f64:	02079663          	bnez	a5,80004f90 <dirlookup+0x70>
    80004f68:	07c0006f          	j	80004fe4 <dirlookup+0xc4>
    panic("dirlookup not DIR");
    80004f6c:	00004517          	auipc	a0,0x4
    80004f70:	5b450513          	addi	a0,a0,1460 # 80009520 <etext+0x520>
    80004f74:	a8dfb0ef          	jal	80000a00 <panic>
      panic("dirlookup read");
    80004f78:	00004517          	auipc	a0,0x4
    80004f7c:	5c050513          	addi	a0,a0,1472 # 80009538 <etext+0x538>
    80004f80:	a81fb0ef          	jal	80000a00 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004f84:	0104849b          	addiw	s1,s1,16
    80004f88:	04c92783          	lw	a5,76(s2)
    80004f8c:	04f4fa63          	bgeu	s1,a5,80004fe0 <dirlookup+0xc0>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004f90:	01000713          	li	a4,16
    80004f94:	00048693          	mv	a3,s1
    80004f98:	fc040613          	addi	a2,s0,-64
    80004f9c:	00000593          	li	a1,0
    80004fa0:	00090513          	mv	a0,s2
    80004fa4:	c31ff0ef          	jal	80004bd4 <readi>
    80004fa8:	01000793          	li	a5,16
    80004fac:	fcf516e3          	bne	a0,a5,80004f78 <dirlookup+0x58>
    if(de.inum == 0)
    80004fb0:	fc045783          	lhu	a5,-64(s0)
    80004fb4:	fc0788e3          	beqz	a5,80004f84 <dirlookup+0x64>
    if(namecmp(name, de.name) == 0){
    80004fb8:	fc240593          	addi	a1,s0,-62
    80004fbc:	00098513          	mv	a0,s3
    80004fc0:	f39ff0ef          	jal	80004ef8 <namecmp>
    80004fc4:	fc0510e3          	bnez	a0,80004f84 <dirlookup+0x64>
      if(poff)
    80004fc8:	000a0463          	beqz	s4,80004fd0 <dirlookup+0xb0>
        *poff = off;
    80004fcc:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004fd0:	fc045583          	lhu	a1,-64(s0)
    80004fd4:	00092503          	lw	a0,0(s2)
    80004fd8:	c8cff0ef          	jal	80004464 <iget>
    80004fdc:	0080006f          	j	80004fe4 <dirlookup+0xc4>
  return 0;
    80004fe0:	00000513          	li	a0,0
}
    80004fe4:	03813083          	ld	ra,56(sp)
    80004fe8:	03013403          	ld	s0,48(sp)
    80004fec:	02813483          	ld	s1,40(sp)
    80004ff0:	02013903          	ld	s2,32(sp)
    80004ff4:	01813983          	ld	s3,24(sp)
    80004ff8:	01013a03          	ld	s4,16(sp)
    80004ffc:	04010113          	addi	sp,sp,64
    80005000:	00008067          	ret

0000000080005004 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80005004:	fa010113          	addi	sp,sp,-96
    80005008:	04113c23          	sd	ra,88(sp)
    8000500c:	04813823          	sd	s0,80(sp)
    80005010:	04913423          	sd	s1,72(sp)
    80005014:	05213023          	sd	s2,64(sp)
    80005018:	03313c23          	sd	s3,56(sp)
    8000501c:	03413823          	sd	s4,48(sp)
    80005020:	03513423          	sd	s5,40(sp)
    80005024:	03613023          	sd	s6,32(sp)
    80005028:	01713c23          	sd	s7,24(sp)
    8000502c:	01813823          	sd	s8,16(sp)
    80005030:	01913423          	sd	s9,8(sp)
    80005034:	06010413          	addi	s0,sp,96
    80005038:	00050493          	mv	s1,a0
    8000503c:	00058b13          	mv	s6,a1
    80005040:	00060a93          	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80005044:	00054703          	lbu	a4,0(a0)
    80005048:	02f00793          	li	a5,47
    8000504c:	02f70263          	beq	a4,a5,80005070 <namex+0x6c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80005050:	c0cfd0ef          	jal	8000245c <myproc>
    80005054:	15053503          	ld	a0,336(a0)
    80005058:	fc8ff0ef          	jal	80004820 <idup>
    8000505c:	00050a13          	mv	s4,a0
  while(*path == '/')
    80005060:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80005064:	00d00c13          	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80005068:	00100b93          	li	s7,1
    8000506c:	0ec0006f          	j	80005158 <namex+0x154>
    ip = iget(ROOTDEV, ROOTINO);
    80005070:	00100593          	li	a1,1
    80005074:	00100513          	li	a0,1
    80005078:	becff0ef          	jal	80004464 <iget>
    8000507c:	00050a13          	mv	s4,a0
    80005080:	fe1ff06f          	j	80005060 <namex+0x5c>
      iunlockput(ip);
    80005084:	000a0513          	mv	a0,s4
    80005088:	ad5ff0ef          	jal	80004b5c <iunlockput>
      return 0;
    8000508c:	00000a13          	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80005090:	000a0513          	mv	a0,s4
    80005094:	05813083          	ld	ra,88(sp)
    80005098:	05013403          	ld	s0,80(sp)
    8000509c:	04813483          	ld	s1,72(sp)
    800050a0:	04013903          	ld	s2,64(sp)
    800050a4:	03813983          	ld	s3,56(sp)
    800050a8:	03013a03          	ld	s4,48(sp)
    800050ac:	02813a83          	ld	s5,40(sp)
    800050b0:	02013b03          	ld	s6,32(sp)
    800050b4:	01813b83          	ld	s7,24(sp)
    800050b8:	01013c03          	ld	s8,16(sp)
    800050bc:	00813c83          	ld	s9,8(sp)
    800050c0:	06010113          	addi	sp,sp,96
    800050c4:	00008067          	ret
      iunlock(ip);
    800050c8:	000a0513          	mv	a0,s4
    800050cc:	89dff0ef          	jal	80004968 <iunlock>
      return ip;
    800050d0:	fc1ff06f          	j	80005090 <namex+0x8c>
      iunlockput(ip);
    800050d4:	000a0513          	mv	a0,s4
    800050d8:	a85ff0ef          	jal	80004b5c <iunlockput>
      return 0;
    800050dc:	00098a13          	mv	s4,s3
    800050e0:	fb1ff06f          	j	80005090 <namex+0x8c>
  len = path - s;
    800050e4:	40998633          	sub	a2,s3,s1
    800050e8:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800050ec:	0b9c5663          	bge	s8,s9,80005198 <namex+0x194>
    memmove(name, s, DIRSIZ);
    800050f0:	00e00613          	li	a2,14
    800050f4:	00048593          	mv	a1,s1
    800050f8:	000a8513          	mv	a0,s5
    800050fc:	910fc0ef          	jal	8000120c <memmove>
    80005100:	00098493          	mv	s1,s3
  while(*path == '/')
    80005104:	0004c783          	lbu	a5,0(s1)
    80005108:	01279863          	bne	a5,s2,80005118 <namex+0x114>
    path++;
    8000510c:	00148493          	addi	s1,s1,1
  while(*path == '/')
    80005110:	0004c783          	lbu	a5,0(s1)
    80005114:	ff278ce3          	beq	a5,s2,8000510c <namex+0x108>
    ilock(ip);
    80005118:	000a0513          	mv	a0,s4
    8000511c:	f58ff0ef          	jal	80004874 <ilock>
    if(ip->type != T_DIR){
    80005120:	044a1783          	lh	a5,68(s4)
    80005124:	f77790e3          	bne	a5,s7,80005084 <namex+0x80>
    if(nameiparent && *path == '\0'){
    80005128:	000b0663          	beqz	s6,80005134 <namex+0x130>
    8000512c:	0004c783          	lbu	a5,0(s1)
    80005130:	f8078ce3          	beqz	a5,800050c8 <namex+0xc4>
    if((next = dirlookup(ip, name, 0)) == 0){
    80005134:	00000613          	li	a2,0
    80005138:	000a8593          	mv	a1,s5
    8000513c:	000a0513          	mv	a0,s4
    80005140:	de1ff0ef          	jal	80004f20 <dirlookup>
    80005144:	00050993          	mv	s3,a0
    80005148:	f80506e3          	beqz	a0,800050d4 <namex+0xd0>
    iunlockput(ip);
    8000514c:	000a0513          	mv	a0,s4
    80005150:	a0dff0ef          	jal	80004b5c <iunlockput>
    ip = next;
    80005154:	00098a13          	mv	s4,s3
  while(*path == '/')
    80005158:	0004c783          	lbu	a5,0(s1)
    8000515c:	01279863          	bne	a5,s2,8000516c <namex+0x168>
    path++;
    80005160:	00148493          	addi	s1,s1,1
  while(*path == '/')
    80005164:	0004c783          	lbu	a5,0(s1)
    80005168:	ff278ce3          	beq	a5,s2,80005160 <namex+0x15c>
  if(*path == 0)
    8000516c:	04078663          	beqz	a5,800051b8 <namex+0x1b4>
  while(*path != '/' && *path != 0)
    80005170:	0004c783          	lbu	a5,0(s1)
    80005174:	00048993          	mv	s3,s1
  len = path - s;
    80005178:	00000c93          	li	s9,0
    8000517c:	00000613          	li	a2,0
  while(*path != '/' && *path != 0)
    80005180:	01278c63          	beq	a5,s2,80005198 <namex+0x194>
    80005184:	f60780e3          	beqz	a5,800050e4 <namex+0xe0>
    path++;
    80005188:	00198993          	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000518c:	0009c783          	lbu	a5,0(s3)
    80005190:	ff279ae3          	bne	a5,s2,80005184 <namex+0x180>
    80005194:	f51ff06f          	j	800050e4 <namex+0xe0>
    memmove(name, s, len);
    80005198:	0006061b          	sext.w	a2,a2
    8000519c:	00048593          	mv	a1,s1
    800051a0:	000a8513          	mv	a0,s5
    800051a4:	868fc0ef          	jal	8000120c <memmove>
    name[len] = 0;
    800051a8:	019a8cb3          	add	s9,s5,s9
    800051ac:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800051b0:	00098493          	mv	s1,s3
    800051b4:	f51ff06f          	j	80005104 <namex+0x100>
  if(nameiparent){
    800051b8:	ec0b0ce3          	beqz	s6,80005090 <namex+0x8c>
    iput(ip);
    800051bc:	000a0513          	mv	a0,s4
    800051c0:	8e1ff0ef          	jal	80004aa0 <iput>
    return 0;
    800051c4:	00000a13          	li	s4,0
    800051c8:	ec9ff06f          	j	80005090 <namex+0x8c>

00000000800051cc <dirlink>:
{
    800051cc:	fc010113          	addi	sp,sp,-64
    800051d0:	02113c23          	sd	ra,56(sp)
    800051d4:	02813823          	sd	s0,48(sp)
    800051d8:	03213023          	sd	s2,32(sp)
    800051dc:	01313c23          	sd	s3,24(sp)
    800051e0:	01413823          	sd	s4,16(sp)
    800051e4:	04010413          	addi	s0,sp,64
    800051e8:	00050913          	mv	s2,a0
    800051ec:	00058a13          	mv	s4,a1
    800051f0:	00060993          	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800051f4:	00000613          	li	a2,0
    800051f8:	d29ff0ef          	jal	80004f20 <dirlookup>
    800051fc:	0a051063          	bnez	a0,8000529c <dirlink+0xd0>
    80005200:	02913423          	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005204:	04c92483          	lw	s1,76(s2)
    80005208:	02048e63          	beqz	s1,80005244 <dirlink+0x78>
    8000520c:	00000493          	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005210:	01000713          	li	a4,16
    80005214:	00048693          	mv	a3,s1
    80005218:	fc040613          	addi	a2,s0,-64
    8000521c:	00000593          	li	a1,0
    80005220:	00090513          	mv	a0,s2
    80005224:	9b1ff0ef          	jal	80004bd4 <readi>
    80005228:	01000793          	li	a5,16
    8000522c:	06f51e63          	bne	a0,a5,800052a8 <dirlink+0xdc>
    if(de.inum == 0)
    80005230:	fc045783          	lhu	a5,-64(s0)
    80005234:	00078863          	beqz	a5,80005244 <dirlink+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005238:	0104849b          	addiw	s1,s1,16
    8000523c:	04c92783          	lw	a5,76(s2)
    80005240:	fcf4e8e3          	bltu	s1,a5,80005210 <dirlink+0x44>
  strncpy(de.name, name, DIRSIZ);
    80005244:	00e00613          	li	a2,14
    80005248:	000a0593          	mv	a1,s4
    8000524c:	fc240513          	addi	a0,s0,-62
    80005250:	8bcfc0ef          	jal	8000130c <strncpy>
  de.inum = inum;
    80005254:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005258:	01000713          	li	a4,16
    8000525c:	00048693          	mv	a3,s1
    80005260:	fc040613          	addi	a2,s0,-64
    80005264:	00000593          	li	a1,0
    80005268:	00090513          	mv	a0,s2
    8000526c:	af5ff0ef          	jal	80004d60 <writei>
    80005270:	ff050513          	addi	a0,a0,-16
    80005274:	00a03533          	snez	a0,a0
    80005278:	40a00533          	neg	a0,a0
    8000527c:	02813483          	ld	s1,40(sp)
}
    80005280:	03813083          	ld	ra,56(sp)
    80005284:	03013403          	ld	s0,48(sp)
    80005288:	02013903          	ld	s2,32(sp)
    8000528c:	01813983          	ld	s3,24(sp)
    80005290:	01013a03          	ld	s4,16(sp)
    80005294:	04010113          	addi	sp,sp,64
    80005298:	00008067          	ret
    iput(ip);
    8000529c:	805ff0ef          	jal	80004aa0 <iput>
    return -1;
    800052a0:	fff00513          	li	a0,-1
    800052a4:	fddff06f          	j	80005280 <dirlink+0xb4>
      panic("dirlink read");
    800052a8:	00004517          	auipc	a0,0x4
    800052ac:	2a050513          	addi	a0,a0,672 # 80009548 <etext+0x548>
    800052b0:	f50fb0ef          	jal	80000a00 <panic>

00000000800052b4 <namei>:

struct inode*
namei(char *path)
{
    800052b4:	fe010113          	addi	sp,sp,-32
    800052b8:	00113c23          	sd	ra,24(sp)
    800052bc:	00813823          	sd	s0,16(sp)
    800052c0:	02010413          	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800052c4:	fe040613          	addi	a2,s0,-32
    800052c8:	00000593          	li	a1,0
    800052cc:	d39ff0ef          	jal	80005004 <namex>
}
    800052d0:	01813083          	ld	ra,24(sp)
    800052d4:	01013403          	ld	s0,16(sp)
    800052d8:	02010113          	addi	sp,sp,32
    800052dc:	00008067          	ret

00000000800052e0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800052e0:	ff010113          	addi	sp,sp,-16
    800052e4:	00113423          	sd	ra,8(sp)
    800052e8:	00813023          	sd	s0,0(sp)
    800052ec:	01010413          	addi	s0,sp,16
    800052f0:	00058613          	mv	a2,a1
  return namex(path, 1, name);
    800052f4:	00100593          	li	a1,1
    800052f8:	d0dff0ef          	jal	80005004 <namex>
}
    800052fc:	00813083          	ld	ra,8(sp)
    80005300:	00013403          	ld	s0,0(sp)
    80005304:	01010113          	addi	sp,sp,16
    80005308:	00008067          	ret

000000008000530c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000530c:	fe010113          	addi	sp,sp,-32
    80005310:	00113c23          	sd	ra,24(sp)
    80005314:	00813823          	sd	s0,16(sp)
    80005318:	00913423          	sd	s1,8(sp)
    8000531c:	01213023          	sd	s2,0(sp)
    80005320:	02010413          	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80005324:	0001c917          	auipc	s2,0x1c
    80005328:	6dc90913          	addi	s2,s2,1756 # 80021a00 <log>
    8000532c:	01892583          	lw	a1,24(s2)
    80005330:	02892503          	lw	a0,40(s2)
    80005334:	b15fe0ef          	jal	80003e48 <bread>
    80005338:	00050493          	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000533c:	02c92603          	lw	a2,44(s2)
    80005340:	04c52c23          	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80005344:	02c05663          	blez	a2,80005370 <write_head+0x64>
    80005348:	0001c717          	auipc	a4,0x1c
    8000534c:	6e870713          	addi	a4,a4,1768 # 80021a30 <log+0x30>
    80005350:	00050793          	mv	a5,a0
    80005354:	00261613          	slli	a2,a2,0x2
    80005358:	00a60633          	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000535c:	00072683          	lw	a3,0(a4)
    80005360:	04d7ae23          	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80005364:	00470713          	addi	a4,a4,4
    80005368:	00478793          	addi	a5,a5,4
    8000536c:	fec798e3          	bne	a5,a2,8000535c <write_head+0x50>
  }
  bwrite(buf);
    80005370:	00048513          	mv	a0,s1
    80005374:	bf9fe0ef          	jal	80003f6c <bwrite>
  brelse(buf);
    80005378:	00048513          	mv	a0,s1
    8000537c:	c41fe0ef          	jal	80003fbc <brelse>
}
    80005380:	01813083          	ld	ra,24(sp)
    80005384:	01013403          	ld	s0,16(sp)
    80005388:	00813483          	ld	s1,8(sp)
    8000538c:	00013903          	ld	s2,0(sp)
    80005390:	02010113          	addi	sp,sp,32
    80005394:	00008067          	ret

0000000080005398 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80005398:	0001c797          	auipc	a5,0x1c
    8000539c:	6947a783          	lw	a5,1684(a5) # 80021a2c <log+0x2c>
    800053a0:	0ef05063          	blez	a5,80005480 <install_trans+0xe8>
{
    800053a4:	fc010113          	addi	sp,sp,-64
    800053a8:	02113c23          	sd	ra,56(sp)
    800053ac:	02813823          	sd	s0,48(sp)
    800053b0:	02913423          	sd	s1,40(sp)
    800053b4:	03213023          	sd	s2,32(sp)
    800053b8:	01313c23          	sd	s3,24(sp)
    800053bc:	01413823          	sd	s4,16(sp)
    800053c0:	01513423          	sd	s5,8(sp)
    800053c4:	01613023          	sd	s6,0(sp)
    800053c8:	04010413          	addi	s0,sp,64
    800053cc:	00050b13          	mv	s6,a0
    800053d0:	0001ca97          	auipc	s5,0x1c
    800053d4:	660a8a93          	addi	s5,s5,1632 # 80021a30 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800053d8:	00000a13          	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800053dc:	0001c997          	auipc	s3,0x1c
    800053e0:	62498993          	addi	s3,s3,1572 # 80021a00 <log>
    800053e4:	0240006f          	j	80005408 <install_trans+0x70>
    brelse(lbuf);
    800053e8:	00090513          	mv	a0,s2
    800053ec:	bd1fe0ef          	jal	80003fbc <brelse>
    brelse(dbuf);
    800053f0:	00048513          	mv	a0,s1
    800053f4:	bc9fe0ef          	jal	80003fbc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800053f8:	001a0a1b          	addiw	s4,s4,1
    800053fc:	004a8a93          	addi	s5,s5,4
    80005400:	02c9a783          	lw	a5,44(s3)
    80005404:	04fa5a63          	bge	s4,a5,80005458 <install_trans+0xc0>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80005408:	0189a583          	lw	a1,24(s3)
    8000540c:	014585bb          	addw	a1,a1,s4
    80005410:	0015859b          	addiw	a1,a1,1
    80005414:	0289a503          	lw	a0,40(s3)
    80005418:	a31fe0ef          	jal	80003e48 <bread>
    8000541c:	00050913          	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80005420:	000aa583          	lw	a1,0(s5)
    80005424:	0289a503          	lw	a0,40(s3)
    80005428:	a21fe0ef          	jal	80003e48 <bread>
    8000542c:	00050493          	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80005430:	40000613          	li	a2,1024
    80005434:	05890593          	addi	a1,s2,88
    80005438:	05850513          	addi	a0,a0,88
    8000543c:	dd1fb0ef          	jal	8000120c <memmove>
    bwrite(dbuf);  // write dst to disk
    80005440:	00048513          	mv	a0,s1
    80005444:	b29fe0ef          	jal	80003f6c <bwrite>
    if(recovering == 0)
    80005448:	fa0b10e3          	bnez	s6,800053e8 <install_trans+0x50>
      bunpin(dbuf);
    8000544c:	00048513          	mv	a0,s1
    80005450:	c7dfe0ef          	jal	800040cc <bunpin>
    80005454:	f95ff06f          	j	800053e8 <install_trans+0x50>
}
    80005458:	03813083          	ld	ra,56(sp)
    8000545c:	03013403          	ld	s0,48(sp)
    80005460:	02813483          	ld	s1,40(sp)
    80005464:	02013903          	ld	s2,32(sp)
    80005468:	01813983          	ld	s3,24(sp)
    8000546c:	01013a03          	ld	s4,16(sp)
    80005470:	00813a83          	ld	s5,8(sp)
    80005474:	00013b03          	ld	s6,0(sp)
    80005478:	04010113          	addi	sp,sp,64
    8000547c:	00008067          	ret
    80005480:	00008067          	ret

0000000080005484 <initlog>:
{
    80005484:	fd010113          	addi	sp,sp,-48
    80005488:	02113423          	sd	ra,40(sp)
    8000548c:	02813023          	sd	s0,32(sp)
    80005490:	00913c23          	sd	s1,24(sp)
    80005494:	01213823          	sd	s2,16(sp)
    80005498:	01313423          	sd	s3,8(sp)
    8000549c:	03010413          	addi	s0,sp,48
    800054a0:	00050913          	mv	s2,a0
    800054a4:	00058993          	mv	s3,a1
  initlock(&log.lock, "log");
    800054a8:	0001c497          	auipc	s1,0x1c
    800054ac:	55848493          	addi	s1,s1,1368 # 80021a00 <log>
    800054b0:	00004597          	auipc	a1,0x4
    800054b4:	0a858593          	addi	a1,a1,168 # 80009558 <etext+0x558>
    800054b8:	00048513          	mv	a0,s1
    800054bc:	ab9fb0ef          	jal	80000f74 <initlock>
  log.start = sb->logstart;
    800054c0:	0149a583          	lw	a1,20(s3)
    800054c4:	00b4ac23          	sw	a1,24(s1)
  log.size = sb->nlog;
    800054c8:	0109a783          	lw	a5,16(s3)
    800054cc:	00f4ae23          	sw	a5,28(s1)
  log.dev = dev;
    800054d0:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800054d4:	00090513          	mv	a0,s2
    800054d8:	971fe0ef          	jal	80003e48 <bread>
  log.lh.n = lh->n;
    800054dc:	05852603          	lw	a2,88(a0)
    800054e0:	02c4a623          	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800054e4:	02c05663          	blez	a2,80005510 <initlog+0x8c>
    800054e8:	00050793          	mv	a5,a0
    800054ec:	0001c717          	auipc	a4,0x1c
    800054f0:	54470713          	addi	a4,a4,1348 # 80021a30 <log+0x30>
    800054f4:	00261613          	slli	a2,a2,0x2
    800054f8:	00a60633          	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800054fc:	05c7a683          	lw	a3,92(a5)
    80005500:	00d72023          	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80005504:	00478793          	addi	a5,a5,4
    80005508:	00470713          	addi	a4,a4,4
    8000550c:	fec798e3          	bne	a5,a2,800054fc <initlog+0x78>
  brelse(buf);
    80005510:	aadfe0ef          	jal	80003fbc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80005514:	00100513          	li	a0,1
    80005518:	e81ff0ef          	jal	80005398 <install_trans>
  log.lh.n = 0;
    8000551c:	0001c797          	auipc	a5,0x1c
    80005520:	5007a823          	sw	zero,1296(a5) # 80021a2c <log+0x2c>
  write_head(); // clear the log
    80005524:	de9ff0ef          	jal	8000530c <write_head>
}
    80005528:	02813083          	ld	ra,40(sp)
    8000552c:	02013403          	ld	s0,32(sp)
    80005530:	01813483          	ld	s1,24(sp)
    80005534:	01013903          	ld	s2,16(sp)
    80005538:	00813983          	ld	s3,8(sp)
    8000553c:	03010113          	addi	sp,sp,48
    80005540:	00008067          	ret

0000000080005544 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80005544:	fe010113          	addi	sp,sp,-32
    80005548:	00113c23          	sd	ra,24(sp)
    8000554c:	00813823          	sd	s0,16(sp)
    80005550:	00913423          	sd	s1,8(sp)
    80005554:	01213023          	sd	s2,0(sp)
    80005558:	02010413          	addi	s0,sp,32
  acquire(&log.lock);
    8000555c:	0001c517          	auipc	a0,0x1c
    80005560:	4a450513          	addi	a0,a0,1188 # 80021a00 <log>
    80005564:	ae5fb0ef          	jal	80001048 <acquire>
  while(1){
    if(log.committing){
    80005568:	0001c497          	auipc	s1,0x1c
    8000556c:	49848493          	addi	s1,s1,1176 # 80021a00 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80005570:	01e00913          	li	s2,30
    80005574:	0100006f          	j	80005584 <begin_op+0x40>
      sleep(&log, &log.lock);
    80005578:	00048593          	mv	a1,s1
    8000557c:	00048513          	mv	a0,s1
    80005580:	f58fd0ef          	jal	80002cd8 <sleep>
    if(log.committing){
    80005584:	0244a783          	lw	a5,36(s1)
    80005588:	fe0798e3          	bnez	a5,80005578 <begin_op+0x34>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000558c:	0204a703          	lw	a4,32(s1)
    80005590:	0017071b          	addiw	a4,a4,1
    80005594:	0027179b          	slliw	a5,a4,0x2
    80005598:	00e787bb          	addw	a5,a5,a4
    8000559c:	0017979b          	slliw	a5,a5,0x1
    800055a0:	02c4a683          	lw	a3,44(s1)
    800055a4:	00d787bb          	addw	a5,a5,a3
    800055a8:	00f95a63          	bge	s2,a5,800055bc <begin_op+0x78>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800055ac:	00048593          	mv	a1,s1
    800055b0:	00048513          	mv	a0,s1
    800055b4:	f24fd0ef          	jal	80002cd8 <sleep>
    800055b8:	fcdff06f          	j	80005584 <begin_op+0x40>
    } else {
      log.outstanding += 1;
    800055bc:	0001c517          	auipc	a0,0x1c
    800055c0:	44450513          	addi	a0,a0,1092 # 80021a00 <log>
    800055c4:	02e52023          	sw	a4,32(a0)
      release(&log.lock);
    800055c8:	b5dfb0ef          	jal	80001124 <release>
      break;
    }
  }
}
    800055cc:	01813083          	ld	ra,24(sp)
    800055d0:	01013403          	ld	s0,16(sp)
    800055d4:	00813483          	ld	s1,8(sp)
    800055d8:	00013903          	ld	s2,0(sp)
    800055dc:	02010113          	addi	sp,sp,32
    800055e0:	00008067          	ret

00000000800055e4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800055e4:	fc010113          	addi	sp,sp,-64
    800055e8:	02113c23          	sd	ra,56(sp)
    800055ec:	02813823          	sd	s0,48(sp)
    800055f0:	02913423          	sd	s1,40(sp)
    800055f4:	03213023          	sd	s2,32(sp)
    800055f8:	04010413          	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800055fc:	0001c497          	auipc	s1,0x1c
    80005600:	40448493          	addi	s1,s1,1028 # 80021a00 <log>
    80005604:	00048513          	mv	a0,s1
    80005608:	a41fb0ef          	jal	80001048 <acquire>
  log.outstanding -= 1;
    8000560c:	0204a783          	lw	a5,32(s1)
    80005610:	fff7879b          	addiw	a5,a5,-1
    80005614:	0007891b          	sext.w	s2,a5
    80005618:	02f4a023          	sw	a5,32(s1)
  if(log.committing)
    8000561c:	0244a783          	lw	a5,36(s1)
    80005620:	04079863          	bnez	a5,80005670 <end_op+0x8c>
    panic("log.committing");
  if(log.outstanding == 0){
    80005624:	06091263          	bnez	s2,80005688 <end_op+0xa4>
    do_commit = 1;
    log.committing = 1;
    80005628:	0001c497          	auipc	s1,0x1c
    8000562c:	3d848493          	addi	s1,s1,984 # 80021a00 <log>
    80005630:	00100793          	li	a5,1
    80005634:	02f4a223          	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80005638:	00048513          	mv	a0,s1
    8000563c:	ae9fb0ef          	jal	80001124 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80005640:	02c4a783          	lw	a5,44(s1)
    80005644:	06f04a63          	bgtz	a5,800056b8 <end_op+0xd4>
    acquire(&log.lock);
    80005648:	0001c497          	auipc	s1,0x1c
    8000564c:	3b848493          	addi	s1,s1,952 # 80021a00 <log>
    80005650:	00048513          	mv	a0,s1
    80005654:	9f5fb0ef          	jal	80001048 <acquire>
    log.committing = 0;
    80005658:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000565c:	00048513          	mv	a0,s1
    80005660:	ef0fd0ef          	jal	80002d50 <wakeup>
    release(&log.lock);
    80005664:	00048513          	mv	a0,s1
    80005668:	abdfb0ef          	jal	80001124 <release>
}
    8000566c:	0340006f          	j	800056a0 <end_op+0xbc>
    80005670:	01313c23          	sd	s3,24(sp)
    80005674:	01413823          	sd	s4,16(sp)
    80005678:	01513423          	sd	s5,8(sp)
    panic("log.committing");
    8000567c:	00004517          	auipc	a0,0x4
    80005680:	ee450513          	addi	a0,a0,-284 # 80009560 <etext+0x560>
    80005684:	b7cfb0ef          	jal	80000a00 <panic>
    wakeup(&log);
    80005688:	0001c497          	auipc	s1,0x1c
    8000568c:	37848493          	addi	s1,s1,888 # 80021a00 <log>
    80005690:	00048513          	mv	a0,s1
    80005694:	ebcfd0ef          	jal	80002d50 <wakeup>
  release(&log.lock);
    80005698:	00048513          	mv	a0,s1
    8000569c:	a89fb0ef          	jal	80001124 <release>
}
    800056a0:	03813083          	ld	ra,56(sp)
    800056a4:	03013403          	ld	s0,48(sp)
    800056a8:	02813483          	ld	s1,40(sp)
    800056ac:	02013903          	ld	s2,32(sp)
    800056b0:	04010113          	addi	sp,sp,64
    800056b4:	00008067          	ret
    800056b8:	01313c23          	sd	s3,24(sp)
    800056bc:	01413823          	sd	s4,16(sp)
    800056c0:	01513423          	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800056c4:	0001ca97          	auipc	s5,0x1c
    800056c8:	36ca8a93          	addi	s5,s5,876 # 80021a30 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800056cc:	0001ca17          	auipc	s4,0x1c
    800056d0:	334a0a13          	addi	s4,s4,820 # 80021a00 <log>
    800056d4:	018a2583          	lw	a1,24(s4)
    800056d8:	012585bb          	addw	a1,a1,s2
    800056dc:	0015859b          	addiw	a1,a1,1
    800056e0:	028a2503          	lw	a0,40(s4)
    800056e4:	f64fe0ef          	jal	80003e48 <bread>
    800056e8:	00050493          	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800056ec:	000aa583          	lw	a1,0(s5)
    800056f0:	028a2503          	lw	a0,40(s4)
    800056f4:	f54fe0ef          	jal	80003e48 <bread>
    800056f8:	00050993          	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800056fc:	40000613          	li	a2,1024
    80005700:	05850593          	addi	a1,a0,88
    80005704:	05848513          	addi	a0,s1,88
    80005708:	b05fb0ef          	jal	8000120c <memmove>
    bwrite(to);  // write the log
    8000570c:	00048513          	mv	a0,s1
    80005710:	85dfe0ef          	jal	80003f6c <bwrite>
    brelse(from);
    80005714:	00098513          	mv	a0,s3
    80005718:	8a5fe0ef          	jal	80003fbc <brelse>
    brelse(to);
    8000571c:	00048513          	mv	a0,s1
    80005720:	89dfe0ef          	jal	80003fbc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005724:	0019091b          	addiw	s2,s2,1
    80005728:	004a8a93          	addi	s5,s5,4
    8000572c:	02ca2783          	lw	a5,44(s4)
    80005730:	faf942e3          	blt	s2,a5,800056d4 <end_op+0xf0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80005734:	bd9ff0ef          	jal	8000530c <write_head>
    install_trans(0); // Now install writes to home locations
    80005738:	00000513          	li	a0,0
    8000573c:	c5dff0ef          	jal	80005398 <install_trans>
    log.lh.n = 0;
    80005740:	0001c797          	auipc	a5,0x1c
    80005744:	2e07a623          	sw	zero,748(a5) # 80021a2c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80005748:	bc5ff0ef          	jal	8000530c <write_head>
    8000574c:	01813983          	ld	s3,24(sp)
    80005750:	01013a03          	ld	s4,16(sp)
    80005754:	00813a83          	ld	s5,8(sp)
    80005758:	ef1ff06f          	j	80005648 <end_op+0x64>

000000008000575c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000575c:	fe010113          	addi	sp,sp,-32
    80005760:	00113c23          	sd	ra,24(sp)
    80005764:	00813823          	sd	s0,16(sp)
    80005768:	00913423          	sd	s1,8(sp)
    8000576c:	01213023          	sd	s2,0(sp)
    80005770:	02010413          	addi	s0,sp,32
    80005774:	00050493          	mv	s1,a0
  int i;

  acquire(&log.lock);
    80005778:	0001c917          	auipc	s2,0x1c
    8000577c:	28890913          	addi	s2,s2,648 # 80021a00 <log>
    80005780:	00090513          	mv	a0,s2
    80005784:	8c5fb0ef          	jal	80001048 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80005788:	02c92603          	lw	a2,44(s2)
    8000578c:	01d00793          	li	a5,29
    80005790:	08c7c463          	blt	a5,a2,80005818 <log_write+0xbc>
    80005794:	0001c797          	auipc	a5,0x1c
    80005798:	2887a783          	lw	a5,648(a5) # 80021a1c <log+0x1c>
    8000579c:	fff7879b          	addiw	a5,a5,-1
    800057a0:	06f65c63          	bge	a2,a5,80005818 <log_write+0xbc>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800057a4:	0001c797          	auipc	a5,0x1c
    800057a8:	27c7a783          	lw	a5,636(a5) # 80021a20 <log+0x20>
    800057ac:	06f05c63          	blez	a5,80005824 <log_write+0xc8>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800057b0:	00000793          	li	a5,0
    800057b4:	06c05e63          	blez	a2,80005830 <log_write+0xd4>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800057b8:	00c4a583          	lw	a1,12(s1)
    800057bc:	0001c717          	auipc	a4,0x1c
    800057c0:	27470713          	addi	a4,a4,628 # 80021a30 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800057c4:	00000793          	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800057c8:	00072683          	lw	a3,0(a4)
    800057cc:	06b68263          	beq	a3,a1,80005830 <log_write+0xd4>
  for (i = 0; i < log.lh.n; i++) {
    800057d0:	0017879b          	addiw	a5,a5,1
    800057d4:	00470713          	addi	a4,a4,4
    800057d8:	fef618e3          	bne	a2,a5,800057c8 <log_write+0x6c>
      break;
  }
  log.lh.block[i] = b->blockno;
    800057dc:	00860613          	addi	a2,a2,8
    800057e0:	00261613          	slli	a2,a2,0x2
    800057e4:	0001c797          	auipc	a5,0x1c
    800057e8:	21c78793          	addi	a5,a5,540 # 80021a00 <log>
    800057ec:	00c787b3          	add	a5,a5,a2
    800057f0:	00c4a703          	lw	a4,12(s1)
    800057f4:	00e7a823          	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800057f8:	00048513          	mv	a0,s1
    800057fc:	881fe0ef          	jal	8000407c <bpin>
    log.lh.n++;
    80005800:	0001c717          	auipc	a4,0x1c
    80005804:	20070713          	addi	a4,a4,512 # 80021a00 <log>
    80005808:	02c72783          	lw	a5,44(a4)
    8000580c:	0017879b          	addiw	a5,a5,1
    80005810:	02f72623          	sw	a5,44(a4)
    80005814:	03c0006f          	j	80005850 <log_write+0xf4>
    panic("too big a transaction");
    80005818:	00004517          	auipc	a0,0x4
    8000581c:	d5850513          	addi	a0,a0,-680 # 80009570 <etext+0x570>
    80005820:	9e0fb0ef          	jal	80000a00 <panic>
    panic("log_write outside of trans");
    80005824:	00004517          	auipc	a0,0x4
    80005828:	d6450513          	addi	a0,a0,-668 # 80009588 <etext+0x588>
    8000582c:	9d4fb0ef          	jal	80000a00 <panic>
  log.lh.block[i] = b->blockno;
    80005830:	00878693          	addi	a3,a5,8
    80005834:	00269693          	slli	a3,a3,0x2
    80005838:	0001c717          	auipc	a4,0x1c
    8000583c:	1c870713          	addi	a4,a4,456 # 80021a00 <log>
    80005840:	00d70733          	add	a4,a4,a3
    80005844:	00c4a683          	lw	a3,12(s1)
    80005848:	00d72823          	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000584c:	faf606e3          	beq	a2,a5,800057f8 <log_write+0x9c>
  }
  release(&log.lock);
    80005850:	0001c517          	auipc	a0,0x1c
    80005854:	1b050513          	addi	a0,a0,432 # 80021a00 <log>
    80005858:	8cdfb0ef          	jal	80001124 <release>
}
    8000585c:	01813083          	ld	ra,24(sp)
    80005860:	01013403          	ld	s0,16(sp)
    80005864:	00813483          	ld	s1,8(sp)
    80005868:	00013903          	ld	s2,0(sp)
    8000586c:	02010113          	addi	sp,sp,32
    80005870:	00008067          	ret

0000000080005874 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80005874:	fe010113          	addi	sp,sp,-32
    80005878:	00113c23          	sd	ra,24(sp)
    8000587c:	00813823          	sd	s0,16(sp)
    80005880:	00913423          	sd	s1,8(sp)
    80005884:	01213023          	sd	s2,0(sp)
    80005888:	02010413          	addi	s0,sp,32
    8000588c:	00050493          	mv	s1,a0
    80005890:	00058913          	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80005894:	00004597          	auipc	a1,0x4
    80005898:	d1458593          	addi	a1,a1,-748 # 800095a8 <etext+0x5a8>
    8000589c:	00850513          	addi	a0,a0,8
    800058a0:	ed4fb0ef          	jal	80000f74 <initlock>
  lk->name = name;
    800058a4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800058a8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800058ac:	0204a423          	sw	zero,40(s1)
}
    800058b0:	01813083          	ld	ra,24(sp)
    800058b4:	01013403          	ld	s0,16(sp)
    800058b8:	00813483          	ld	s1,8(sp)
    800058bc:	00013903          	ld	s2,0(sp)
    800058c0:	02010113          	addi	sp,sp,32
    800058c4:	00008067          	ret

00000000800058c8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800058c8:	fe010113          	addi	sp,sp,-32
    800058cc:	00113c23          	sd	ra,24(sp)
    800058d0:	00813823          	sd	s0,16(sp)
    800058d4:	00913423          	sd	s1,8(sp)
    800058d8:	01213023          	sd	s2,0(sp)
    800058dc:	02010413          	addi	s0,sp,32
    800058e0:	00050493          	mv	s1,a0
  acquire(&lk->lk);
    800058e4:	00850913          	addi	s2,a0,8
    800058e8:	00090513          	mv	a0,s2
    800058ec:	f5cfb0ef          	jal	80001048 <acquire>
  while (lk->locked) {
    800058f0:	0004a783          	lw	a5,0(s1)
    800058f4:	00078c63          	beqz	a5,8000590c <acquiresleep+0x44>
    sleep(lk, &lk->lk);
    800058f8:	00090593          	mv	a1,s2
    800058fc:	00048513          	mv	a0,s1
    80005900:	bd8fd0ef          	jal	80002cd8 <sleep>
  while (lk->locked) {
    80005904:	0004a783          	lw	a5,0(s1)
    80005908:	fe0798e3          	bnez	a5,800058f8 <acquiresleep+0x30>
  }
  lk->locked = 1;
    8000590c:	00100793          	li	a5,1
    80005910:	00f4a023          	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80005914:	b49fc0ef          	jal	8000245c <myproc>
    80005918:	03052783          	lw	a5,48(a0)
    8000591c:	02f4a423          	sw	a5,40(s1)
  release(&lk->lk);
    80005920:	00090513          	mv	a0,s2
    80005924:	801fb0ef          	jal	80001124 <release>
}
    80005928:	01813083          	ld	ra,24(sp)
    8000592c:	01013403          	ld	s0,16(sp)
    80005930:	00813483          	ld	s1,8(sp)
    80005934:	00013903          	ld	s2,0(sp)
    80005938:	02010113          	addi	sp,sp,32
    8000593c:	00008067          	ret

0000000080005940 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80005940:	fe010113          	addi	sp,sp,-32
    80005944:	00113c23          	sd	ra,24(sp)
    80005948:	00813823          	sd	s0,16(sp)
    8000594c:	00913423          	sd	s1,8(sp)
    80005950:	01213023          	sd	s2,0(sp)
    80005954:	02010413          	addi	s0,sp,32
    80005958:	00050493          	mv	s1,a0
  acquire(&lk->lk);
    8000595c:	00850913          	addi	s2,a0,8
    80005960:	00090513          	mv	a0,s2
    80005964:	ee4fb0ef          	jal	80001048 <acquire>
  lk->locked = 0;
    80005968:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000596c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80005970:	00048513          	mv	a0,s1
    80005974:	bdcfd0ef          	jal	80002d50 <wakeup>
  release(&lk->lk);
    80005978:	00090513          	mv	a0,s2
    8000597c:	fa8fb0ef          	jal	80001124 <release>
}
    80005980:	01813083          	ld	ra,24(sp)
    80005984:	01013403          	ld	s0,16(sp)
    80005988:	00813483          	ld	s1,8(sp)
    8000598c:	00013903          	ld	s2,0(sp)
    80005990:	02010113          	addi	sp,sp,32
    80005994:	00008067          	ret

0000000080005998 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80005998:	fd010113          	addi	sp,sp,-48
    8000599c:	02113423          	sd	ra,40(sp)
    800059a0:	02813023          	sd	s0,32(sp)
    800059a4:	00913c23          	sd	s1,24(sp)
    800059a8:	01213823          	sd	s2,16(sp)
    800059ac:	03010413          	addi	s0,sp,48
    800059b0:	00050493          	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800059b4:	00850913          	addi	s2,a0,8
    800059b8:	00090513          	mv	a0,s2
    800059bc:	e8cfb0ef          	jal	80001048 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800059c0:	0004a783          	lw	a5,0(s1)
    800059c4:	02079663          	bnez	a5,800059f0 <holdingsleep+0x58>
    800059c8:	00000493          	li	s1,0
  release(&lk->lk);
    800059cc:	00090513          	mv	a0,s2
    800059d0:	f54fb0ef          	jal	80001124 <release>
  return r;
}
    800059d4:	00048513          	mv	a0,s1
    800059d8:	02813083          	ld	ra,40(sp)
    800059dc:	02013403          	ld	s0,32(sp)
    800059e0:	01813483          	ld	s1,24(sp)
    800059e4:	01013903          	ld	s2,16(sp)
    800059e8:	03010113          	addi	sp,sp,48
    800059ec:	00008067          	ret
    800059f0:	01313423          	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800059f4:	0284a983          	lw	s3,40(s1)
    800059f8:	a65fc0ef          	jal	8000245c <myproc>
    800059fc:	03052483          	lw	s1,48(a0)
    80005a00:	413484b3          	sub	s1,s1,s3
    80005a04:	0014b493          	seqz	s1,s1
    80005a08:	00813983          	ld	s3,8(sp)
    80005a0c:	fc1ff06f          	j	800059cc <holdingsleep+0x34>

0000000080005a10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80005a10:	ff010113          	addi	sp,sp,-16
    80005a14:	00113423          	sd	ra,8(sp)
    80005a18:	00813023          	sd	s0,0(sp)
    80005a1c:	01010413          	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80005a20:	00004597          	auipc	a1,0x4
    80005a24:	b9858593          	addi	a1,a1,-1128 # 800095b8 <etext+0x5b8>
    80005a28:	0001c517          	auipc	a0,0x1c
    80005a2c:	12050513          	addi	a0,a0,288 # 80021b48 <ftable>
    80005a30:	d44fb0ef          	jal	80000f74 <initlock>
}
    80005a34:	00813083          	ld	ra,8(sp)
    80005a38:	00013403          	ld	s0,0(sp)
    80005a3c:	01010113          	addi	sp,sp,16
    80005a40:	00008067          	ret

0000000080005a44 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80005a44:	fe010113          	addi	sp,sp,-32
    80005a48:	00113c23          	sd	ra,24(sp)
    80005a4c:	00813823          	sd	s0,16(sp)
    80005a50:	00913423          	sd	s1,8(sp)
    80005a54:	02010413          	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80005a58:	0001c517          	auipc	a0,0x1c
    80005a5c:	0f050513          	addi	a0,a0,240 # 80021b48 <ftable>
    80005a60:	de8fb0ef          	jal	80001048 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005a64:	0001c497          	auipc	s1,0x1c
    80005a68:	0fc48493          	addi	s1,s1,252 # 80021b60 <ftable+0x18>
    80005a6c:	0001d717          	auipc	a4,0x1d
    80005a70:	09470713          	addi	a4,a4,148 # 80022b00 <disk>
    if(f->ref == 0){
    80005a74:	0044a783          	lw	a5,4(s1)
    80005a78:	02078063          	beqz	a5,80005a98 <filealloc+0x54>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005a7c:	02848493          	addi	s1,s1,40
    80005a80:	fee49ae3          	bne	s1,a4,80005a74 <filealloc+0x30>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80005a84:	0001c517          	auipc	a0,0x1c
    80005a88:	0c450513          	addi	a0,a0,196 # 80021b48 <ftable>
    80005a8c:	e98fb0ef          	jal	80001124 <release>
  return 0;
    80005a90:	00000493          	li	s1,0
    80005a94:	0180006f          	j	80005aac <filealloc+0x68>
      f->ref = 1;
    80005a98:	00100793          	li	a5,1
    80005a9c:	00f4a223          	sw	a5,4(s1)
      release(&ftable.lock);
    80005aa0:	0001c517          	auipc	a0,0x1c
    80005aa4:	0a850513          	addi	a0,a0,168 # 80021b48 <ftable>
    80005aa8:	e7cfb0ef          	jal	80001124 <release>
}
    80005aac:	00048513          	mv	a0,s1
    80005ab0:	01813083          	ld	ra,24(sp)
    80005ab4:	01013403          	ld	s0,16(sp)
    80005ab8:	00813483          	ld	s1,8(sp)
    80005abc:	02010113          	addi	sp,sp,32
    80005ac0:	00008067          	ret

0000000080005ac4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80005ac4:	fe010113          	addi	sp,sp,-32
    80005ac8:	00113c23          	sd	ra,24(sp)
    80005acc:	00813823          	sd	s0,16(sp)
    80005ad0:	00913423          	sd	s1,8(sp)
    80005ad4:	02010413          	addi	s0,sp,32
    80005ad8:	00050493          	mv	s1,a0
  acquire(&ftable.lock);
    80005adc:	0001c517          	auipc	a0,0x1c
    80005ae0:	06c50513          	addi	a0,a0,108 # 80021b48 <ftable>
    80005ae4:	d64fb0ef          	jal	80001048 <acquire>
  if(f->ref < 1)
    80005ae8:	0044a783          	lw	a5,4(s1)
    80005aec:	02f05863          	blez	a5,80005b1c <filedup+0x58>
    panic("filedup");
  f->ref++;
    80005af0:	0017879b          	addiw	a5,a5,1
    80005af4:	00f4a223          	sw	a5,4(s1)
  release(&ftable.lock);
    80005af8:	0001c517          	auipc	a0,0x1c
    80005afc:	05050513          	addi	a0,a0,80 # 80021b48 <ftable>
    80005b00:	e24fb0ef          	jal	80001124 <release>
  return f;
}
    80005b04:	00048513          	mv	a0,s1
    80005b08:	01813083          	ld	ra,24(sp)
    80005b0c:	01013403          	ld	s0,16(sp)
    80005b10:	00813483          	ld	s1,8(sp)
    80005b14:	02010113          	addi	sp,sp,32
    80005b18:	00008067          	ret
    panic("filedup");
    80005b1c:	00004517          	auipc	a0,0x4
    80005b20:	aa450513          	addi	a0,a0,-1372 # 800095c0 <etext+0x5c0>
    80005b24:	eddfa0ef          	jal	80000a00 <panic>

0000000080005b28 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80005b28:	fc010113          	addi	sp,sp,-64
    80005b2c:	02113c23          	sd	ra,56(sp)
    80005b30:	02813823          	sd	s0,48(sp)
    80005b34:	02913423          	sd	s1,40(sp)
    80005b38:	04010413          	addi	s0,sp,64
    80005b3c:	00050493          	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80005b40:	0001c517          	auipc	a0,0x1c
    80005b44:	00850513          	addi	a0,a0,8 # 80021b48 <ftable>
    80005b48:	d00fb0ef          	jal	80001048 <acquire>
  if(f->ref < 1)
    80005b4c:	0044a783          	lw	a5,4(s1)
    80005b50:	06f05863          	blez	a5,80005bc0 <fileclose+0x98>
    panic("fileclose");
  if(--f->ref > 0){
    80005b54:	fff7879b          	addiw	a5,a5,-1
    80005b58:	0007871b          	sext.w	a4,a5
    80005b5c:	00f4a223          	sw	a5,4(s1)
    80005b60:	06e04e63          	bgtz	a4,80005bdc <fileclose+0xb4>
    80005b64:	03213023          	sd	s2,32(sp)
    80005b68:	01313c23          	sd	s3,24(sp)
    80005b6c:	01413823          	sd	s4,16(sp)
    80005b70:	01513423          	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80005b74:	0004a903          	lw	s2,0(s1)
    80005b78:	0094ca83          	lbu	s5,9(s1)
    80005b7c:	0104ba03          	ld	s4,16(s1)
    80005b80:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80005b84:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80005b88:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80005b8c:	0001c517          	auipc	a0,0x1c
    80005b90:	fbc50513          	addi	a0,a0,-68 # 80021b48 <ftable>
    80005b94:	d90fb0ef          	jal	80001124 <release>

  if(ff.type == FD_PIPE){
    80005b98:	00100793          	li	a5,1
    80005b9c:	06f90063          	beq	s2,a5,80005bfc <fileclose+0xd4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80005ba0:	ffe9091b          	addiw	s2,s2,-2
    80005ba4:	00100793          	li	a5,1
    80005ba8:	0727fa63          	bgeu	a5,s2,80005c1c <fileclose+0xf4>
    80005bac:	02013903          	ld	s2,32(sp)
    80005bb0:	01813983          	ld	s3,24(sp)
    80005bb4:	01013a03          	ld	s4,16(sp)
    80005bb8:	00813a83          	ld	s5,8(sp)
    80005bbc:	02c0006f          	j	80005be8 <fileclose+0xc0>
    80005bc0:	03213023          	sd	s2,32(sp)
    80005bc4:	01313c23          	sd	s3,24(sp)
    80005bc8:	01413823          	sd	s4,16(sp)
    80005bcc:	01513423          	sd	s5,8(sp)
    panic("fileclose");
    80005bd0:	00004517          	auipc	a0,0x4
    80005bd4:	9f850513          	addi	a0,a0,-1544 # 800095c8 <etext+0x5c8>
    80005bd8:	e29fa0ef          	jal	80000a00 <panic>
    release(&ftable.lock);
    80005bdc:	0001c517          	auipc	a0,0x1c
    80005be0:	f6c50513          	addi	a0,a0,-148 # 80021b48 <ftable>
    80005be4:	d40fb0ef          	jal	80001124 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80005be8:	03813083          	ld	ra,56(sp)
    80005bec:	03013403          	ld	s0,48(sp)
    80005bf0:	02813483          	ld	s1,40(sp)
    80005bf4:	04010113          	addi	sp,sp,64
    80005bf8:	00008067          	ret
    pipeclose(ff.pipe, ff.writable);
    80005bfc:	000a8593          	mv	a1,s5
    80005c00:	000a0513          	mv	a0,s4
    80005c04:	4e8000ef          	jal	800060ec <pipeclose>
    80005c08:	02013903          	ld	s2,32(sp)
    80005c0c:	01813983          	ld	s3,24(sp)
    80005c10:	01013a03          	ld	s4,16(sp)
    80005c14:	00813a83          	ld	s5,8(sp)
    80005c18:	fd1ff06f          	j	80005be8 <fileclose+0xc0>
    begin_op();
    80005c1c:	929ff0ef          	jal	80005544 <begin_op>
    iput(ff.ip);
    80005c20:	00098513          	mv	a0,s3
    80005c24:	e7dfe0ef          	jal	80004aa0 <iput>
    end_op();
    80005c28:	9bdff0ef          	jal	800055e4 <end_op>
    80005c2c:	02013903          	ld	s2,32(sp)
    80005c30:	01813983          	ld	s3,24(sp)
    80005c34:	01013a03          	ld	s4,16(sp)
    80005c38:	00813a83          	ld	s5,8(sp)
    80005c3c:	fadff06f          	j	80005be8 <fileclose+0xc0>

0000000080005c40 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80005c40:	fb010113          	addi	sp,sp,-80
    80005c44:	04113423          	sd	ra,72(sp)
    80005c48:	04813023          	sd	s0,64(sp)
    80005c4c:	02913c23          	sd	s1,56(sp)
    80005c50:	03313423          	sd	s3,40(sp)
    80005c54:	05010413          	addi	s0,sp,80
    80005c58:	00050493          	mv	s1,a0
    80005c5c:	00058993          	mv	s3,a1
  struct proc *p = myproc();
    80005c60:	ffcfc0ef          	jal	8000245c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80005c64:	0004a783          	lw	a5,0(s1)
    80005c68:	ffe7879b          	addiw	a5,a5,-2
    80005c6c:	00100713          	li	a4,1
    80005c70:	04f76e63          	bltu	a4,a5,80005ccc <filestat+0x8c>
    80005c74:	03213823          	sd	s2,48(sp)
    80005c78:	00050913          	mv	s2,a0
    ilock(f->ip);
    80005c7c:	0184b503          	ld	a0,24(s1)
    80005c80:	bf5fe0ef          	jal	80004874 <ilock>
    stati(f->ip, &st);
    80005c84:	fb840593          	addi	a1,s0,-72
    80005c88:	0184b503          	ld	a0,24(s1)
    80005c8c:	f09fe0ef          	jal	80004b94 <stati>
    iunlock(f->ip);
    80005c90:	0184b503          	ld	a0,24(s1)
    80005c94:	cd5fe0ef          	jal	80004968 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80005c98:	01800693          	li	a3,24
    80005c9c:	fb840613          	addi	a2,s0,-72
    80005ca0:	00098593          	mv	a1,s3
    80005ca4:	05093503          	ld	a0,80(s2)
    80005ca8:	a0cfc0ef          	jal	80001eb4 <copyout>
    80005cac:	41f5551b          	sraiw	a0,a0,0x1f
    80005cb0:	03013903          	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80005cb4:	04813083          	ld	ra,72(sp)
    80005cb8:	04013403          	ld	s0,64(sp)
    80005cbc:	03813483          	ld	s1,56(sp)
    80005cc0:	02813983          	ld	s3,40(sp)
    80005cc4:	05010113          	addi	sp,sp,80
    80005cc8:	00008067          	ret
  return -1;
    80005ccc:	fff00513          	li	a0,-1
    80005cd0:	fe5ff06f          	j	80005cb4 <filestat+0x74>

0000000080005cd4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80005cd4:	fd010113          	addi	sp,sp,-48
    80005cd8:	02113423          	sd	ra,40(sp)
    80005cdc:	02813023          	sd	s0,32(sp)
    80005ce0:	01213823          	sd	s2,16(sp)
    80005ce4:	03010413          	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80005ce8:	00854783          	lbu	a5,8(a0)
    80005cec:	0e078c63          	beqz	a5,80005de4 <fileread+0x110>
    80005cf0:	00913c23          	sd	s1,24(sp)
    80005cf4:	01313423          	sd	s3,8(sp)
    80005cf8:	00050493          	mv	s1,a0
    80005cfc:	00058993          	mv	s3,a1
    80005d00:	00060913          	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80005d04:	00052783          	lw	a5,0(a0)
    80005d08:	00100713          	li	a4,1
    80005d0c:	06e78863          	beq	a5,a4,80005d7c <fileread+0xa8>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005d10:	00300713          	li	a4,3
    80005d14:	08e78063          	beq	a5,a4,80005d94 <fileread+0xc0>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80005d18:	00200713          	li	a4,2
    80005d1c:	0ae79e63          	bne	a5,a4,80005dd8 <fileread+0x104>
    ilock(f->ip);
    80005d20:	01853503          	ld	a0,24(a0)
    80005d24:	b51fe0ef          	jal	80004874 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80005d28:	00090713          	mv	a4,s2
    80005d2c:	0204a683          	lw	a3,32(s1)
    80005d30:	00098613          	mv	a2,s3
    80005d34:	00100593          	li	a1,1
    80005d38:	0184b503          	ld	a0,24(s1)
    80005d3c:	e99fe0ef          	jal	80004bd4 <readi>
    80005d40:	00050913          	mv	s2,a0
    80005d44:	00a05863          	blez	a0,80005d54 <fileread+0x80>
      f->off += r;
    80005d48:	0204a783          	lw	a5,32(s1)
    80005d4c:	00a787bb          	addw	a5,a5,a0
    80005d50:	02f4a023          	sw	a5,32(s1)
    iunlock(f->ip);
    80005d54:	0184b503          	ld	a0,24(s1)
    80005d58:	c11fe0ef          	jal	80004968 <iunlock>
    80005d5c:	01813483          	ld	s1,24(sp)
    80005d60:	00813983          	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80005d64:	00090513          	mv	a0,s2
    80005d68:	02813083          	ld	ra,40(sp)
    80005d6c:	02013403          	ld	s0,32(sp)
    80005d70:	01013903          	ld	s2,16(sp)
    80005d74:	03010113          	addi	sp,sp,48
    80005d78:	00008067          	ret
    r = piperead(f->pipe, addr, n);
    80005d7c:	01053503          	ld	a0,16(a0)
    80005d80:	540000ef          	jal	800062c0 <piperead>
    80005d84:	00050913          	mv	s2,a0
    80005d88:	01813483          	ld	s1,24(sp)
    80005d8c:	00813983          	ld	s3,8(sp)
    80005d90:	fd5ff06f          	j	80005d64 <fileread+0x90>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80005d94:	02451783          	lh	a5,36(a0)
    80005d98:	03079693          	slli	a3,a5,0x30
    80005d9c:	0306d693          	srli	a3,a3,0x30
    80005da0:	00900713          	li	a4,9
    80005da4:	04d76463          	bltu	a4,a3,80005dec <fileread+0x118>
    80005da8:	00479793          	slli	a5,a5,0x4
    80005dac:	0001c717          	auipc	a4,0x1c
    80005db0:	cfc70713          	addi	a4,a4,-772 # 80021aa8 <devsw>
    80005db4:	00f707b3          	add	a5,a4,a5
    80005db8:	0007b783          	ld	a5,0(a5)
    80005dbc:	04078063          	beqz	a5,80005dfc <fileread+0x128>
    r = devsw[f->major].read(1, addr, n);
    80005dc0:	00100513          	li	a0,1
    80005dc4:	000780e7          	jalr	a5
    80005dc8:	00050913          	mv	s2,a0
    80005dcc:	01813483          	ld	s1,24(sp)
    80005dd0:	00813983          	ld	s3,8(sp)
    80005dd4:	f91ff06f          	j	80005d64 <fileread+0x90>
    panic("fileread");
    80005dd8:	00004517          	auipc	a0,0x4
    80005ddc:	80050513          	addi	a0,a0,-2048 # 800095d8 <etext+0x5d8>
    80005de0:	c21fa0ef          	jal	80000a00 <panic>
    return -1;
    80005de4:	fff00913          	li	s2,-1
    80005de8:	f7dff06f          	j	80005d64 <fileread+0x90>
      return -1;
    80005dec:	fff00913          	li	s2,-1
    80005df0:	01813483          	ld	s1,24(sp)
    80005df4:	00813983          	ld	s3,8(sp)
    80005df8:	f6dff06f          	j	80005d64 <fileread+0x90>
    80005dfc:	fff00913          	li	s2,-1
    80005e00:	01813483          	ld	s1,24(sp)
    80005e04:	00813983          	ld	s3,8(sp)
    80005e08:	f5dff06f          	j	80005d64 <fileread+0x90>

0000000080005e0c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80005e0c:	00954783          	lbu	a5,9(a0)
    80005e10:	18078c63          	beqz	a5,80005fa8 <filewrite+0x19c>
{
    80005e14:	fb010113          	addi	sp,sp,-80
    80005e18:	04113423          	sd	ra,72(sp)
    80005e1c:	04813023          	sd	s0,64(sp)
    80005e20:	03213823          	sd	s2,48(sp)
    80005e24:	03413023          	sd	s4,32(sp)
    80005e28:	01613823          	sd	s6,16(sp)
    80005e2c:	05010413          	addi	s0,sp,80
    80005e30:	00050913          	mv	s2,a0
    80005e34:	00058b13          	mv	s6,a1
    80005e38:	00060a13          	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80005e3c:	00052783          	lw	a5,0(a0)
    80005e40:	00100713          	li	a4,1
    80005e44:	04e78263          	beq	a5,a4,80005e88 <filewrite+0x7c>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005e48:	00300713          	li	a4,3
    80005e4c:	04e78463          	beq	a5,a4,80005e94 <filewrite+0x88>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80005e50:	00200713          	li	a4,2
    80005e54:	12e79a63          	bne	a5,a4,80005f88 <filewrite+0x17c>
    80005e58:	03313423          	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80005e5c:	0ec05663          	blez	a2,80005f48 <filewrite+0x13c>
    80005e60:	02913c23          	sd	s1,56(sp)
    80005e64:	01513c23          	sd	s5,24(sp)
    80005e68:	01713423          	sd	s7,8(sp)
    80005e6c:	01813023          	sd	s8,0(sp)
    int i = 0;
    80005e70:	00000993          	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80005e74:	00001bb7          	lui	s7,0x1
    80005e78:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80005e7c:	00001c37          	lui	s8,0x1
    80005e80:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80005e84:	09c0006f          	j	80005f20 <filewrite+0x114>
    ret = pipewrite(f->pipe, addr, n);
    80005e88:	01053503          	ld	a0,16(a0)
    80005e8c:	2e0000ef          	jal	8000616c <pipewrite>
    80005e90:	0dc0006f          	j	80005f6c <filewrite+0x160>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80005e94:	02451783          	lh	a5,36(a0)
    80005e98:	03079693          	slli	a3,a5,0x30
    80005e9c:	0306d693          	srli	a3,a3,0x30
    80005ea0:	00900713          	li	a4,9
    80005ea4:	10d76663          	bltu	a4,a3,80005fb0 <filewrite+0x1a4>
    80005ea8:	00479793          	slli	a5,a5,0x4
    80005eac:	0001c717          	auipc	a4,0x1c
    80005eb0:	bfc70713          	addi	a4,a4,-1028 # 80021aa8 <devsw>
    80005eb4:	00f707b3          	add	a5,a4,a5
    80005eb8:	0087b783          	ld	a5,8(a5)
    80005ebc:	0e078e63          	beqz	a5,80005fb8 <filewrite+0x1ac>
    ret = devsw[f->major].write(1, addr, n);
    80005ec0:	00100513          	li	a0,1
    80005ec4:	000780e7          	jalr	a5
    80005ec8:	0a40006f          	j	80005f6c <filewrite+0x160>
      if(n1 > max)
    80005ecc:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80005ed0:	e74ff0ef          	jal	80005544 <begin_op>
      ilock(f->ip);
    80005ed4:	01893503          	ld	a0,24(s2)
    80005ed8:	99dfe0ef          	jal	80004874 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005edc:	000a8713          	mv	a4,s5
    80005ee0:	02092683          	lw	a3,32(s2)
    80005ee4:	01698633          	add	a2,s3,s6
    80005ee8:	00100593          	li	a1,1
    80005eec:	01893503          	ld	a0,24(s2)
    80005ef0:	e71fe0ef          	jal	80004d60 <writei>
    80005ef4:	00050493          	mv	s1,a0
    80005ef8:	00a05863          	blez	a0,80005f08 <filewrite+0xfc>
        f->off += r;
    80005efc:	02092783          	lw	a5,32(s2)
    80005f00:	00a787bb          	addw	a5,a5,a0
    80005f04:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80005f08:	01893503          	ld	a0,24(s2)
    80005f0c:	a5dfe0ef          	jal	80004968 <iunlock>
      end_op();
    80005f10:	ed4ff0ef          	jal	800055e4 <end_op>

      if(r != n1){
    80005f14:	029a9e63          	bne	s5,s1,80005f50 <filewrite+0x144>
        // error from writei
        break;
      }
      i += r;
    80005f18:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80005f1c:	0149dc63          	bge	s3,s4,80005f34 <filewrite+0x128>
      int n1 = n - i;
    80005f20:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80005f24:	0004879b          	sext.w	a5,s1
    80005f28:	fafbd2e3          	bge	s7,a5,80005ecc <filewrite+0xc0>
    80005f2c:	000c0493          	mv	s1,s8
    80005f30:	f9dff06f          	j	80005ecc <filewrite+0xc0>
    80005f34:	03813483          	ld	s1,56(sp)
    80005f38:	01813a83          	ld	s5,24(sp)
    80005f3c:	00813b83          	ld	s7,8(sp)
    80005f40:	00013c03          	ld	s8,0(sp)
    80005f44:	01c0006f          	j	80005f60 <filewrite+0x154>
    int i = 0;
    80005f48:	00000993          	li	s3,0
    80005f4c:	0140006f          	j	80005f60 <filewrite+0x154>
    80005f50:	03813483          	ld	s1,56(sp)
    80005f54:	01813a83          	ld	s5,24(sp)
    80005f58:	00813b83          	ld	s7,8(sp)
    80005f5c:	00013c03          	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80005f60:	073a1063          	bne	s4,s3,80005fc0 <filewrite+0x1b4>
    80005f64:	000a0513          	mv	a0,s4
    80005f68:	02813983          	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80005f6c:	04813083          	ld	ra,72(sp)
    80005f70:	04013403          	ld	s0,64(sp)
    80005f74:	03013903          	ld	s2,48(sp)
    80005f78:	02013a03          	ld	s4,32(sp)
    80005f7c:	01013b03          	ld	s6,16(sp)
    80005f80:	05010113          	addi	sp,sp,80
    80005f84:	00008067          	ret
    80005f88:	02913c23          	sd	s1,56(sp)
    80005f8c:	03313423          	sd	s3,40(sp)
    80005f90:	01513c23          	sd	s5,24(sp)
    80005f94:	01713423          	sd	s7,8(sp)
    80005f98:	01813023          	sd	s8,0(sp)
    panic("filewrite");
    80005f9c:	00003517          	auipc	a0,0x3
    80005fa0:	64c50513          	addi	a0,a0,1612 # 800095e8 <etext+0x5e8>
    80005fa4:	a5dfa0ef          	jal	80000a00 <panic>
    return -1;
    80005fa8:	fff00513          	li	a0,-1
}
    80005fac:	00008067          	ret
      return -1;
    80005fb0:	fff00513          	li	a0,-1
    80005fb4:	fb9ff06f          	j	80005f6c <filewrite+0x160>
    80005fb8:	fff00513          	li	a0,-1
    80005fbc:	fb1ff06f          	j	80005f6c <filewrite+0x160>
    ret = (i == n ? n : -1);
    80005fc0:	fff00513          	li	a0,-1
    80005fc4:	02813983          	ld	s3,40(sp)
    80005fc8:	fa5ff06f          	j	80005f6c <filewrite+0x160>

0000000080005fcc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005fcc:	fd010113          	addi	sp,sp,-48
    80005fd0:	02113423          	sd	ra,40(sp)
    80005fd4:	02813023          	sd	s0,32(sp)
    80005fd8:	00913c23          	sd	s1,24(sp)
    80005fdc:	01413023          	sd	s4,0(sp)
    80005fe0:	03010413          	addi	s0,sp,48
    80005fe4:	00050493          	mv	s1,a0
    80005fe8:	00058a13          	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80005fec:	0005b023          	sd	zero,0(a1)
    80005ff0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80005ff4:	a51ff0ef          	jal	80005a44 <filealloc>
    80005ff8:	00a4b023          	sd	a0,0(s1)
    80005ffc:	0a050c63          	beqz	a0,800060b4 <pipealloc+0xe8>
    80006000:	a45ff0ef          	jal	80005a44 <filealloc>
    80006004:	00aa3023          	sd	a0,0(s4)
    80006008:	0a050063          	beqz	a0,800060a8 <pipealloc+0xdc>
    8000600c:	01213823          	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80006010:	eedfa0ef          	jal	80000efc <kalloc>
    80006014:	00050913          	mv	s2,a0
    80006018:	06050c63          	beqz	a0,80006090 <pipealloc+0xc4>
    8000601c:	01313423          	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80006020:	00100993          	li	s3,1
    80006024:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80006028:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000602c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80006030:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80006034:	00003597          	auipc	a1,0x3
    80006038:	5c458593          	addi	a1,a1,1476 # 800095f8 <etext+0x5f8>
    8000603c:	f39fa0ef          	jal	80000f74 <initlock>
  (*f0)->type = FD_PIPE;
    80006040:	0004b783          	ld	a5,0(s1)
    80006044:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80006048:	0004b783          	ld	a5,0(s1)
    8000604c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80006050:	0004b783          	ld	a5,0(s1)
    80006054:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80006058:	0004b783          	ld	a5,0(s1)
    8000605c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80006060:	000a3783          	ld	a5,0(s4)
    80006064:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80006068:	000a3783          	ld	a5,0(s4)
    8000606c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80006070:	000a3783          	ld	a5,0(s4)
    80006074:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80006078:	000a3783          	ld	a5,0(s4)
    8000607c:	0127b823          	sd	s2,16(a5)
  return 0;
    80006080:	00000513          	li	a0,0
    80006084:	01013903          	ld	s2,16(sp)
    80006088:	00813983          	ld	s3,8(sp)
    8000608c:	0400006f          	j	800060cc <pipealloc+0x100>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80006090:	0004b503          	ld	a0,0(s1)
    80006094:	00050663          	beqz	a0,800060a0 <pipealloc+0xd4>
    80006098:	01013903          	ld	s2,16(sp)
    8000609c:	0140006f          	j	800060b0 <pipealloc+0xe4>
    800060a0:	01013903          	ld	s2,16(sp)
    800060a4:	0100006f          	j	800060b4 <pipealloc+0xe8>
    800060a8:	0004b503          	ld	a0,0(s1)
    800060ac:	02050c63          	beqz	a0,800060e4 <pipealloc+0x118>
    fileclose(*f0);
    800060b0:	a79ff0ef          	jal	80005b28 <fileclose>
  if(*f1)
    800060b4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800060b8:	fff00513          	li	a0,-1
  if(*f1)
    800060bc:	00078863          	beqz	a5,800060cc <pipealloc+0x100>
    fileclose(*f1);
    800060c0:	00078513          	mv	a0,a5
    800060c4:	a65ff0ef          	jal	80005b28 <fileclose>
  return -1;
    800060c8:	fff00513          	li	a0,-1
}
    800060cc:	02813083          	ld	ra,40(sp)
    800060d0:	02013403          	ld	s0,32(sp)
    800060d4:	01813483          	ld	s1,24(sp)
    800060d8:	00013a03          	ld	s4,0(sp)
    800060dc:	03010113          	addi	sp,sp,48
    800060e0:	00008067          	ret
  return -1;
    800060e4:	fff00513          	li	a0,-1
    800060e8:	fe5ff06f          	j	800060cc <pipealloc+0x100>

00000000800060ec <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800060ec:	fe010113          	addi	sp,sp,-32
    800060f0:	00113c23          	sd	ra,24(sp)
    800060f4:	00813823          	sd	s0,16(sp)
    800060f8:	00913423          	sd	s1,8(sp)
    800060fc:	01213023          	sd	s2,0(sp)
    80006100:	02010413          	addi	s0,sp,32
    80006104:	00050493          	mv	s1,a0
    80006108:	00058913          	mv	s2,a1
  acquire(&pi->lock);
    8000610c:	f3dfa0ef          	jal	80001048 <acquire>
  if(writable){
    80006110:	04090063          	beqz	s2,80006150 <pipeclose+0x64>
    pi->writeopen = 0;
    80006114:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80006118:	21848513          	addi	a0,s1,536
    8000611c:	c35fc0ef          	jal	80002d50 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80006120:	2204b783          	ld	a5,544(s1)
    80006124:	02079e63          	bnez	a5,80006160 <pipeclose+0x74>
    release(&pi->lock);
    80006128:	00048513          	mv	a0,s1
    8000612c:	ff9fa0ef          	jal	80001124 <release>
    kfree((char*)pi);
    80006130:	00048513          	mv	a0,s1
    80006134:	c79fa0ef          	jal	80000dac <kfree>
  } else
    release(&pi->lock);
}
    80006138:	01813083          	ld	ra,24(sp)
    8000613c:	01013403          	ld	s0,16(sp)
    80006140:	00813483          	ld	s1,8(sp)
    80006144:	00013903          	ld	s2,0(sp)
    80006148:	02010113          	addi	sp,sp,32
    8000614c:	00008067          	ret
    pi->readopen = 0;
    80006150:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80006154:	21c48513          	addi	a0,s1,540
    80006158:	bf9fc0ef          	jal	80002d50 <wakeup>
    8000615c:	fc5ff06f          	j	80006120 <pipeclose+0x34>
    release(&pi->lock);
    80006160:	00048513          	mv	a0,s1
    80006164:	fc1fa0ef          	jal	80001124 <release>
}
    80006168:	fd1ff06f          	j	80006138 <pipeclose+0x4c>

000000008000616c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000616c:	fa010113          	addi	sp,sp,-96
    80006170:	04113c23          	sd	ra,88(sp)
    80006174:	04813823          	sd	s0,80(sp)
    80006178:	04913423          	sd	s1,72(sp)
    8000617c:	05213023          	sd	s2,64(sp)
    80006180:	03313c23          	sd	s3,56(sp)
    80006184:	03413823          	sd	s4,48(sp)
    80006188:	03513423          	sd	s5,40(sp)
    8000618c:	06010413          	addi	s0,sp,96
    80006190:	00050493          	mv	s1,a0
    80006194:	00058a93          	mv	s5,a1
    80006198:	00060a13          	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000619c:	ac0fc0ef          	jal	8000245c <myproc>
    800061a0:	00050993          	mv	s3,a0

  acquire(&pi->lock);
    800061a4:	00048513          	mv	a0,s1
    800061a8:	ea1fa0ef          	jal	80001048 <acquire>
  while(i < n){
    800061ac:	0f405e63          	blez	s4,800062a8 <pipewrite+0x13c>
    800061b0:	03613023          	sd	s6,32(sp)
    800061b4:	01713c23          	sd	s7,24(sp)
    800061b8:	01813823          	sd	s8,16(sp)
  int i = 0;
    800061bc:	00000913          	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800061c0:	fff00b13          	li	s6,-1
      wakeup(&pi->nread);
    800061c4:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800061c8:	21c48b93          	addi	s7,s1,540
    800061cc:	05c0006f          	j	80006228 <pipewrite+0xbc>
      release(&pi->lock);
    800061d0:	00048513          	mv	a0,s1
    800061d4:	f51fa0ef          	jal	80001124 <release>
      return -1;
    800061d8:	fff00913          	li	s2,-1
    800061dc:	02013b03          	ld	s6,32(sp)
    800061e0:	01813b83          	ld	s7,24(sp)
    800061e4:	01013c03          	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800061e8:	00090513          	mv	a0,s2
    800061ec:	05813083          	ld	ra,88(sp)
    800061f0:	05013403          	ld	s0,80(sp)
    800061f4:	04813483          	ld	s1,72(sp)
    800061f8:	04013903          	ld	s2,64(sp)
    800061fc:	03813983          	ld	s3,56(sp)
    80006200:	03013a03          	ld	s4,48(sp)
    80006204:	02813a83          	ld	s5,40(sp)
    80006208:	06010113          	addi	sp,sp,96
    8000620c:	00008067          	ret
      wakeup(&pi->nread);
    80006210:	000c0513          	mv	a0,s8
    80006214:	b3dfc0ef          	jal	80002d50 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80006218:	00048593          	mv	a1,s1
    8000621c:	000b8513          	mv	a0,s7
    80006220:	ab9fc0ef          	jal	80002cd8 <sleep>
  while(i < n){
    80006224:	07495263          	bge	s2,s4,80006288 <pipewrite+0x11c>
    if(pi->readopen == 0 || killed(pr)){
    80006228:	2204a783          	lw	a5,544(s1)
    8000622c:	fa0782e3          	beqz	a5,800061d0 <pipewrite+0x64>
    80006230:	00098513          	mv	a0,s3
    80006234:	de5fc0ef          	jal	80003018 <killed>
    80006238:	f8051ce3          	bnez	a0,800061d0 <pipewrite+0x64>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000623c:	2184a783          	lw	a5,536(s1)
    80006240:	21c4a703          	lw	a4,540(s1)
    80006244:	2007879b          	addiw	a5,a5,512
    80006248:	fcf704e3          	beq	a4,a5,80006210 <pipewrite+0xa4>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000624c:	00100693          	li	a3,1
    80006250:	01590633          	add	a2,s2,s5
    80006254:	faf40593          	addi	a1,s0,-81
    80006258:	0509b503          	ld	a0,80(s3)
    8000625c:	dd1fb0ef          	jal	8000202c <copyin>
    80006260:	05650863          	beq	a0,s6,800062b0 <pipewrite+0x144>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80006264:	21c4a783          	lw	a5,540(s1)
    80006268:	0017871b          	addiw	a4,a5,1
    8000626c:	20e4ae23          	sw	a4,540(s1)
    80006270:	1ff7f793          	andi	a5,a5,511
    80006274:	00f487b3          	add	a5,s1,a5
    80006278:	faf44703          	lbu	a4,-81(s0)
    8000627c:	00e78c23          	sb	a4,24(a5)
      i++;
    80006280:	0019091b          	addiw	s2,s2,1
    80006284:	fa1ff06f          	j	80006224 <pipewrite+0xb8>
    80006288:	02013b03          	ld	s6,32(sp)
    8000628c:	01813b83          	ld	s7,24(sp)
    80006290:	01013c03          	ld	s8,16(sp)
  wakeup(&pi->nread);
    80006294:	21848513          	addi	a0,s1,536
    80006298:	ab9fc0ef          	jal	80002d50 <wakeup>
  release(&pi->lock);
    8000629c:	00048513          	mv	a0,s1
    800062a0:	e85fa0ef          	jal	80001124 <release>
  return i;
    800062a4:	f45ff06f          	j	800061e8 <pipewrite+0x7c>
  int i = 0;
    800062a8:	00000913          	li	s2,0
    800062ac:	fe9ff06f          	j	80006294 <pipewrite+0x128>
    800062b0:	02013b03          	ld	s6,32(sp)
    800062b4:	01813b83          	ld	s7,24(sp)
    800062b8:	01013c03          	ld	s8,16(sp)
    800062bc:	fd9ff06f          	j	80006294 <pipewrite+0x128>

00000000800062c0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800062c0:	fb010113          	addi	sp,sp,-80
    800062c4:	04113423          	sd	ra,72(sp)
    800062c8:	04813023          	sd	s0,64(sp)
    800062cc:	02913c23          	sd	s1,56(sp)
    800062d0:	03213823          	sd	s2,48(sp)
    800062d4:	03313423          	sd	s3,40(sp)
    800062d8:	03413023          	sd	s4,32(sp)
    800062dc:	01513c23          	sd	s5,24(sp)
    800062e0:	05010413          	addi	s0,sp,80
    800062e4:	00050493          	mv	s1,a0
    800062e8:	00058913          	mv	s2,a1
    800062ec:	00060a93          	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800062f0:	96cfc0ef          	jal	8000245c <myproc>
    800062f4:	00050a13          	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800062f8:	00048513          	mv	a0,s1
    800062fc:	d4dfa0ef          	jal	80001048 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80006300:	2184a703          	lw	a4,536(s1)
    80006304:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80006308:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000630c:	02f71c63          	bne	a4,a5,80006344 <piperead+0x84>
    80006310:	2244a783          	lw	a5,548(s1)
    80006314:	04078463          	beqz	a5,8000635c <piperead+0x9c>
    if(killed(pr)){
    80006318:	000a0513          	mv	a0,s4
    8000631c:	cfdfc0ef          	jal	80003018 <killed>
    80006320:	02051663          	bnez	a0,8000634c <piperead+0x8c>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80006324:	00048593          	mv	a1,s1
    80006328:	00098513          	mv	a0,s3
    8000632c:	9adfc0ef          	jal	80002cd8 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80006330:	2184a703          	lw	a4,536(s1)
    80006334:	21c4a783          	lw	a5,540(s1)
    80006338:	fcf70ce3          	beq	a4,a5,80006310 <piperead+0x50>
    8000633c:	01613823          	sd	s6,16(sp)
    80006340:	0200006f          	j	80006360 <piperead+0xa0>
    80006344:	01613823          	sd	s6,16(sp)
    80006348:	0180006f          	j	80006360 <piperead+0xa0>
      release(&pi->lock);
    8000634c:	00048513          	mv	a0,s1
    80006350:	dd5fa0ef          	jal	80001124 <release>
      return -1;
    80006354:	fff00993          	li	s3,-1
    80006358:	0740006f          	j	800063cc <piperead+0x10c>
    8000635c:	01613823          	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80006360:	00000993          	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80006364:	fff00b13          	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80006368:	05505863          	blez	s5,800063b8 <piperead+0xf8>
    if(pi->nread == pi->nwrite)
    8000636c:	2184a783          	lw	a5,536(s1)
    80006370:	21c4a703          	lw	a4,540(s1)
    80006374:	04f70263          	beq	a4,a5,800063b8 <piperead+0xf8>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80006378:	0017871b          	addiw	a4,a5,1
    8000637c:	20e4ac23          	sw	a4,536(s1)
    80006380:	1ff7f793          	andi	a5,a5,511
    80006384:	00f487b3          	add	a5,s1,a5
    80006388:	0187c783          	lbu	a5,24(a5)
    8000638c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80006390:	00100693          	li	a3,1
    80006394:	fbf40613          	addi	a2,s0,-65
    80006398:	00090593          	mv	a1,s2
    8000639c:	050a3503          	ld	a0,80(s4)
    800063a0:	b15fb0ef          	jal	80001eb4 <copyout>
    800063a4:	01650a63          	beq	a0,s6,800063b8 <piperead+0xf8>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800063a8:	0019899b          	addiw	s3,s3,1
    800063ac:	00190913          	addi	s2,s2,1
    800063b0:	fb3a9ee3          	bne	s5,s3,8000636c <piperead+0xac>
    800063b4:	000a8993          	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800063b8:	21c48513          	addi	a0,s1,540
    800063bc:	995fc0ef          	jal	80002d50 <wakeup>
  release(&pi->lock);
    800063c0:	00048513          	mv	a0,s1
    800063c4:	d61fa0ef          	jal	80001124 <release>
    800063c8:	01013b03          	ld	s6,16(sp)
  return i;
}
    800063cc:	00098513          	mv	a0,s3
    800063d0:	04813083          	ld	ra,72(sp)
    800063d4:	04013403          	ld	s0,64(sp)
    800063d8:	03813483          	ld	s1,56(sp)
    800063dc:	03013903          	ld	s2,48(sp)
    800063e0:	02813983          	ld	s3,40(sp)
    800063e4:	02013a03          	ld	s4,32(sp)
    800063e8:	01813a83          	ld	s5,24(sp)
    800063ec:	05010113          	addi	sp,sp,80
    800063f0:	00008067          	ret

00000000800063f4 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800063f4:	ff010113          	addi	sp,sp,-16
    800063f8:	00813423          	sd	s0,8(sp)
    800063fc:	01010413          	addi	s0,sp,16
    80006400:	00050793          	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80006404:	00157513          	andi	a0,a0,1
    80006408:	00351513          	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000640c:	0027f793          	andi	a5,a5,2
    80006410:	00078463          	beqz	a5,80006418 <flags2perm+0x24>
      perm |= PTE_W;
    80006414:	00456513          	ori	a0,a0,4
    return perm;
}
    80006418:	00813403          	ld	s0,8(sp)
    8000641c:	01010113          	addi	sp,sp,16
    80006420:	00008067          	ret

0000000080006424 <exec>:

int
exec(char *path, char **argv)
{
    80006424:	df010113          	addi	sp,sp,-528
    80006428:	20113423          	sd	ra,520(sp)
    8000642c:	20813023          	sd	s0,512(sp)
    80006430:	1e913c23          	sd	s1,504(sp)
    80006434:	1f213823          	sd	s2,496(sp)
    80006438:	21010413          	addi	s0,sp,528
    8000643c:	00050913          	mv	s2,a0
    80006440:	dea43c23          	sd	a0,-520(s0)
    80006444:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80006448:	814fc0ef          	jal	8000245c <myproc>
    8000644c:	00050493          	mv	s1,a0

  begin_op();
    80006450:	8f4ff0ef          	jal	80005544 <begin_op>

  if((ip = namei(path)) == 0){
    80006454:	00090513          	mv	a0,s2
    80006458:	e5dfe0ef          	jal	800052b4 <namei>
    8000645c:	06050663          	beqz	a0,800064c8 <exec+0xa4>
    80006460:	1f413023          	sd	s4,480(sp)
    80006464:	00050a13          	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80006468:	c0cfe0ef          	jal	80004874 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000646c:	04000713          	li	a4,64
    80006470:	00000693          	li	a3,0
    80006474:	e5040613          	addi	a2,s0,-432
    80006478:	00000593          	li	a1,0
    8000647c:	000a0513          	mv	a0,s4
    80006480:	f54fe0ef          	jal	80004bd4 <readi>
    80006484:	04000793          	li	a5,64
    80006488:	00f51a63          	bne	a0,a5,8000649c <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000648c:	e5042703          	lw	a4,-432(s0)
    80006490:	464c47b7          	lui	a5,0x464c4
    80006494:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80006498:	02f70e63          	beq	a4,a5,800064d4 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000649c:	000a0513          	mv	a0,s4
    800064a0:	ebcfe0ef          	jal	80004b5c <iunlockput>
    end_op();
    800064a4:	940ff0ef          	jal	800055e4 <end_op>
  }
  return -1;
    800064a8:	fff00513          	li	a0,-1
    800064ac:	1e013a03          	ld	s4,480(sp)
}
    800064b0:	20813083          	ld	ra,520(sp)
    800064b4:	20013403          	ld	s0,512(sp)
    800064b8:	1f813483          	ld	s1,504(sp)
    800064bc:	1f013903          	ld	s2,496(sp)
    800064c0:	21010113          	addi	sp,sp,528
    800064c4:	00008067          	ret
    end_op();
    800064c8:	91cff0ef          	jal	800055e4 <end_op>
    return -1;
    800064cc:	fff00513          	li	a0,-1
    800064d0:	fe1ff06f          	j	800064b0 <exec+0x8c>
    800064d4:	1d613823          	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800064d8:	00048513          	mv	a0,s1
    800064dc:	880fc0ef          	jal	8000255c <proc_pagetable>
    800064e0:	00050b13          	mv	s6,a0
    800064e4:	3c050e63          	beqz	a0,800068c0 <exec+0x49c>
    800064e8:	1f313423          	sd	s3,488(sp)
    800064ec:	1d513c23          	sd	s5,472(sp)
    800064f0:	1d713423          	sd	s7,456(sp)
    800064f4:	1d813023          	sd	s8,448(sp)
    800064f8:	1b913c23          	sd	s9,440(sp)
    800064fc:	1ba13823          	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006500:	e7042d03          	lw	s10,-400(s0)
    80006504:	e8845783          	lhu	a5,-376(s0)
    80006508:	18078a63          	beqz	a5,8000669c <exec+0x278>
    8000650c:	1bb13423          	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80006510:	00000913          	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006514:	00000d93          	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80006518:	00001cb7          	lui	s9,0x1
    8000651c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80006520:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80006524:	00001ab7          	lui	s5,0x1
    80006528:	07c0006f          	j	800065a4 <exec+0x180>
      panic("loadseg: address should exist");
    8000652c:	00003517          	auipc	a0,0x3
    80006530:	0d450513          	addi	a0,a0,212 # 80009600 <etext+0x600>
    80006534:	cccfa0ef          	jal	80000a00 <panic>
    if(sz - i < PGSIZE)
    80006538:	0004849b          	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000653c:	00048713          	mv	a4,s1
    80006540:	012c06bb          	addw	a3,s8,s2
    80006544:	00000593          	li	a1,0
    80006548:	000a0513          	mv	a0,s4
    8000654c:	e88fe0ef          	jal	80004bd4 <readi>
    80006550:	0005051b          	sext.w	a0,a0
    80006554:	30a49863          	bne	s1,a0,80006864 <exec+0x440>
  for(i = 0; i < sz; i += PGSIZE){
    80006558:	012a893b          	addw	s2,s5,s2
    8000655c:	03397a63          	bgeu	s2,s3,80006590 <exec+0x16c>
    pa = walkaddr(pagetable, va + i);
    80006560:	02091593          	slli	a1,s2,0x20
    80006564:	0205d593          	srli	a1,a1,0x20
    80006568:	017585b3          	add	a1,a1,s7
    8000656c:	000b0513          	mv	a0,s6
    80006570:	880fb0ef          	jal	800015f0 <walkaddr>
    80006574:	00050613          	mv	a2,a0
    if(pa == 0)
    80006578:	fa050ae3          	beqz	a0,8000652c <exec+0x108>
    if(sz - i < PGSIZE)
    8000657c:	412984bb          	subw	s1,s3,s2
    80006580:	0004879b          	sext.w	a5,s1
    80006584:	fafcfae3          	bgeu	s9,a5,80006538 <exec+0x114>
    80006588:	000a8493          	mv	s1,s5
    8000658c:	fadff06f          	j	80006538 <exec+0x114>
    sz = sz1;
    80006590:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006594:	001d8d9b          	addiw	s11,s11,1
    80006598:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    8000659c:	e8845783          	lhu	a5,-376(s0)
    800065a0:	08fdde63          	bge	s11,a5,8000663c <exec+0x218>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800065a4:	000d0d1b          	sext.w	s10,s10
    800065a8:	03800713          	li	a4,56
    800065ac:	000d0693          	mv	a3,s10
    800065b0:	e1840613          	addi	a2,s0,-488
    800065b4:	00000593          	li	a1,0
    800065b8:	000a0513          	mv	a0,s4
    800065bc:	e18fe0ef          	jal	80004bd4 <readi>
    800065c0:	03800793          	li	a5,56
    800065c4:	24f51a63          	bne	a0,a5,80006818 <exec+0x3f4>
    if(ph.type != ELF_PROG_LOAD)
    800065c8:	e1842783          	lw	a5,-488(s0)
    800065cc:	00100713          	li	a4,1
    800065d0:	fce792e3          	bne	a5,a4,80006594 <exec+0x170>
    if(ph.memsz < ph.filesz)
    800065d4:	e4043483          	ld	s1,-448(s0)
    800065d8:	e3843783          	ld	a5,-456(s0)
    800065dc:	24f4e463          	bltu	s1,a5,80006824 <exec+0x400>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800065e0:	e2843783          	ld	a5,-472(s0)
    800065e4:	00f484b3          	add	s1,s1,a5
    800065e8:	24f4e463          	bltu	s1,a5,80006830 <exec+0x40c>
    if(ph.vaddr % PGSIZE != 0)
    800065ec:	df043703          	ld	a4,-528(s0)
    800065f0:	00e7f7b3          	and	a5,a5,a4
    800065f4:	24079463          	bnez	a5,8000683c <exec+0x418>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800065f8:	e1c42503          	lw	a0,-484(s0)
    800065fc:	df9ff0ef          	jal	800063f4 <flags2perm>
    80006600:	00050693          	mv	a3,a0
    80006604:	00048613          	mv	a2,s1
    80006608:	00090593          	mv	a1,s2
    8000660c:	000b0513          	mv	a0,s6
    80006610:	d34fb0ef          	jal	80001b44 <uvmalloc>
    80006614:	e0a43423          	sd	a0,-504(s0)
    80006618:	22050863          	beqz	a0,80006848 <exec+0x424>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000661c:	e2843b83          	ld	s7,-472(s0)
    80006620:	e2042c03          	lw	s8,-480(s0)
    80006624:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80006628:	00098663          	beqz	s3,80006634 <exec+0x210>
    8000662c:	00000913          	li	s2,0
    80006630:	f31ff06f          	j	80006560 <exec+0x13c>
    sz = sz1;
    80006634:	e0843903          	ld	s2,-504(s0)
    80006638:	f5dff06f          	j	80006594 <exec+0x170>
    8000663c:	1a813d83          	ld	s11,424(sp)
  iunlockput(ip);
    80006640:	000a0513          	mv	a0,s4
    80006644:	d18fe0ef          	jal	80004b5c <iunlockput>
  end_op();
    80006648:	f9dfe0ef          	jal	800055e4 <end_op>
  p = myproc();
    8000664c:	e11fb0ef          	jal	8000245c <myproc>
    80006650:	00050a93          	mv	s5,a0
  uint64 oldsz = p->sz;
    80006654:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80006658:	000019b7          	lui	s3,0x1
    8000665c:	fff98993          	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80006660:	013909b3          	add	s3,s2,s3
    80006664:	fffff7b7          	lui	a5,0xfffff
    80006668:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000666c:	00400693          	li	a3,4
    80006670:	00002637          	lui	a2,0x2
    80006674:	00c98633          	add	a2,s3,a2
    80006678:	00098593          	mv	a1,s3
    8000667c:	000b0513          	mv	a0,s6
    80006680:	cc4fb0ef          	jal	80001b44 <uvmalloc>
    80006684:	00050913          	mv	s2,a0
    80006688:	e0a43423          	sd	a0,-504(s0)
    8000668c:	00051c63          	bnez	a0,800066a4 <exec+0x280>
  if(pagetable)
    80006690:	e1343423          	sd	s3,-504(s0)
    80006694:	00000a13          	li	s4,0
    80006698:	1d00006f          	j	80006868 <exec+0x444>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000669c:	00000913          	li	s2,0
    800066a0:	fa1ff06f          	j	80006640 <exec+0x21c>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800066a4:	ffffe5b7          	lui	a1,0xffffe
    800066a8:	00b505b3          	add	a1,a0,a1
    800066ac:	000b0513          	mv	a0,s6
    800066b0:	fc0fb0ef          	jal	80001e70 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800066b4:	fffffbb7          	lui	s7,0xfffff
    800066b8:	01790bb3          	add	s7,s2,s7
  for(argc = 0; argv[argc]; argc++) {
    800066bc:	e0043783          	ld	a5,-512(s0)
    800066c0:	0007b503          	ld	a0,0(a5) # fffffffffffff000 <end+0xffffffff7ffdc3c0>
    800066c4:	06050a63          	beqz	a0,80006738 <exec+0x314>
    800066c8:	e9040993          	addi	s3,s0,-368
    800066cc:	f9040c13          	addi	s8,s0,-112
    800066d0:	00000493          	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800066d4:	ce1fa0ef          	jal	800013b4 <strlen>
    800066d8:	0015079b          	addiw	a5,a0,1
    800066dc:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800066e0:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800066e4:	17796863          	bltu	s2,s7,80006854 <exec+0x430>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800066e8:	e0043d03          	ld	s10,-512(s0)
    800066ec:	000d3a03          	ld	s4,0(s10)
    800066f0:	000a0513          	mv	a0,s4
    800066f4:	cc1fa0ef          	jal	800013b4 <strlen>
    800066f8:	0015069b          	addiw	a3,a0,1
    800066fc:	000a0613          	mv	a2,s4
    80006700:	00090593          	mv	a1,s2
    80006704:	000b0513          	mv	a0,s6
    80006708:	facfb0ef          	jal	80001eb4 <copyout>
    8000670c:	14054863          	bltz	a0,8000685c <exec+0x438>
    ustack[argc] = sp;
    80006710:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80006714:	00148493          	addi	s1,s1,1
    80006718:	008d0793          	addi	a5,s10,8
    8000671c:	e0f43023          	sd	a5,-512(s0)
    80006720:	008d3503          	ld	a0,8(s10)
    80006724:	00050e63          	beqz	a0,80006740 <exec+0x31c>
    if(argc >= MAXARG)
    80006728:	00898993          	addi	s3,s3,8
    8000672c:	fb8994e3          	bne	s3,s8,800066d4 <exec+0x2b0>
  ip = 0;
    80006730:	00000a13          	li	s4,0
    80006734:	1340006f          	j	80006868 <exec+0x444>
  sp = sz;
    80006738:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000673c:	00000493          	li	s1,0
  ustack[argc] = 0;
    80006740:	00349793          	slli	a5,s1,0x3
    80006744:	f9078793          	addi	a5,a5,-112
    80006748:	008787b3          	add	a5,a5,s0
    8000674c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80006750:	00148693          	addi	a3,s1,1
    80006754:	00369693          	slli	a3,a3,0x3
    80006758:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000675c:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80006760:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80006764:	f37966e3          	bltu	s2,s7,80006690 <exec+0x26c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80006768:	e9040613          	addi	a2,s0,-368
    8000676c:	00090593          	mv	a1,s2
    80006770:	000b0513          	mv	a0,s6
    80006774:	f40fb0ef          	jal	80001eb4 <copyout>
    80006778:	14054863          	bltz	a0,800068c8 <exec+0x4a4>
  p->trapframe->a1 = sp;
    8000677c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80006780:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80006784:	df843783          	ld	a5,-520(s0)
    80006788:	0007c703          	lbu	a4,0(a5)
    8000678c:	02070463          	beqz	a4,800067b4 <exec+0x390>
    80006790:	00178793          	addi	a5,a5,1
    if(*s == '/')
    80006794:	02f00693          	li	a3,47
    80006798:	0140006f          	j	800067ac <exec+0x388>
      last = s+1;
    8000679c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800067a0:	00178793          	addi	a5,a5,1
    800067a4:	fff7c703          	lbu	a4,-1(a5)
    800067a8:	00070663          	beqz	a4,800067b4 <exec+0x390>
    if(*s == '/')
    800067ac:	fed71ae3          	bne	a4,a3,800067a0 <exec+0x37c>
    800067b0:	fedff06f          	j	8000679c <exec+0x378>
  safestrcpy(p->name, last, sizeof(p->name));
    800067b4:	01000613          	li	a2,16
    800067b8:	df843583          	ld	a1,-520(s0)
    800067bc:	158a8513          	addi	a0,s5,344
    800067c0:	ba9fa0ef          	jal	80001368 <safestrcpy>
  oldpagetable = p->pagetable;
    800067c4:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800067c8:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800067cc:	e0843783          	ld	a5,-504(s0)
    800067d0:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800067d4:	058ab783          	ld	a5,88(s5)
    800067d8:	e6843703          	ld	a4,-408(s0)
    800067dc:	00e7bc23          	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800067e0:	058ab783          	ld	a5,88(s5)
    800067e4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800067e8:	000c8593          	mv	a1,s9
    800067ec:	e41fb0ef          	jal	8000262c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800067f0:	0004851b          	sext.w	a0,s1
    800067f4:	1e813983          	ld	s3,488(sp)
    800067f8:	1e013a03          	ld	s4,480(sp)
    800067fc:	1d813a83          	ld	s5,472(sp)
    80006800:	1d013b03          	ld	s6,464(sp)
    80006804:	1c813b83          	ld	s7,456(sp)
    80006808:	1c013c03          	ld	s8,448(sp)
    8000680c:	1b813c83          	ld	s9,440(sp)
    80006810:	1b013d03          	ld	s10,432(sp)
    80006814:	c9dff06f          	j	800064b0 <exec+0x8c>
    80006818:	e1243423          	sd	s2,-504(s0)
    8000681c:	1a813d83          	ld	s11,424(sp)
    80006820:	0480006f          	j	80006868 <exec+0x444>
    80006824:	e1243423          	sd	s2,-504(s0)
    80006828:	1a813d83          	ld	s11,424(sp)
    8000682c:	03c0006f          	j	80006868 <exec+0x444>
    80006830:	e1243423          	sd	s2,-504(s0)
    80006834:	1a813d83          	ld	s11,424(sp)
    80006838:	0300006f          	j	80006868 <exec+0x444>
    8000683c:	e1243423          	sd	s2,-504(s0)
    80006840:	1a813d83          	ld	s11,424(sp)
    80006844:	0240006f          	j	80006868 <exec+0x444>
    80006848:	e1243423          	sd	s2,-504(s0)
    8000684c:	1a813d83          	ld	s11,424(sp)
    80006850:	0180006f          	j	80006868 <exec+0x444>
  ip = 0;
    80006854:	00000a13          	li	s4,0
    80006858:	0100006f          	j	80006868 <exec+0x444>
    8000685c:	00000a13          	li	s4,0
  if(pagetable)
    80006860:	0080006f          	j	80006868 <exec+0x444>
    80006864:	1a813d83          	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80006868:	e0843583          	ld	a1,-504(s0)
    8000686c:	000b0513          	mv	a0,s6
    80006870:	dbdfb0ef          	jal	8000262c <proc_freepagetable>
  return -1;
    80006874:	fff00513          	li	a0,-1
  if(ip){
    80006878:	020a1463          	bnez	s4,800068a0 <exec+0x47c>
    8000687c:	1e813983          	ld	s3,488(sp)
    80006880:	1e013a03          	ld	s4,480(sp)
    80006884:	1d813a83          	ld	s5,472(sp)
    80006888:	1d013b03          	ld	s6,464(sp)
    8000688c:	1c813b83          	ld	s7,456(sp)
    80006890:	1c013c03          	ld	s8,448(sp)
    80006894:	1b813c83          	ld	s9,440(sp)
    80006898:	1b013d03          	ld	s10,432(sp)
    8000689c:	c15ff06f          	j	800064b0 <exec+0x8c>
    800068a0:	1e813983          	ld	s3,488(sp)
    800068a4:	1d813a83          	ld	s5,472(sp)
    800068a8:	1d013b03          	ld	s6,464(sp)
    800068ac:	1c813b83          	ld	s7,456(sp)
    800068b0:	1c013c03          	ld	s8,448(sp)
    800068b4:	1b813c83          	ld	s9,440(sp)
    800068b8:	1b013d03          	ld	s10,432(sp)
    800068bc:	be1ff06f          	j	8000649c <exec+0x78>
    800068c0:	1d013b03          	ld	s6,464(sp)
    800068c4:	bd9ff06f          	j	8000649c <exec+0x78>
  sz = sz1;
    800068c8:	e0843983          	ld	s3,-504(s0)
    800068cc:	dc5ff06f          	j	80006690 <exec+0x26c>

00000000800068d0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800068d0:	fd010113          	addi	sp,sp,-48
    800068d4:	02113423          	sd	ra,40(sp)
    800068d8:	02813023          	sd	s0,32(sp)
    800068dc:	00913c23          	sd	s1,24(sp)
    800068e0:	01213823          	sd	s2,16(sp)
    800068e4:	03010413          	addi	s0,sp,48
    800068e8:	00058913          	mv	s2,a1
    800068ec:	00060493          	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800068f0:	fdc40593          	addi	a1,s0,-36
    800068f4:	8f4fd0ef          	jal	800039e8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800068f8:	fdc42703          	lw	a4,-36(s0)
    800068fc:	00f00793          	li	a5,15
    80006900:	04e7e663          	bltu	a5,a4,8000694c <argfd+0x7c>
    80006904:	b59fb0ef          	jal	8000245c <myproc>
    80006908:	fdc42703          	lw	a4,-36(s0)
    8000690c:	01a70793          	addi	a5,a4,26
    80006910:	00379793          	slli	a5,a5,0x3
    80006914:	00f50533          	add	a0,a0,a5
    80006918:	00053783          	ld	a5,0(a0)
    8000691c:	02078c63          	beqz	a5,80006954 <argfd+0x84>
    return -1;
  if(pfd)
    80006920:	00090463          	beqz	s2,80006928 <argfd+0x58>
    *pfd = fd;
    80006924:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80006928:	00000513          	li	a0,0
  if(pf)
    8000692c:	00048463          	beqz	s1,80006934 <argfd+0x64>
    *pf = f;
    80006930:	00f4b023          	sd	a5,0(s1)
}
    80006934:	02813083          	ld	ra,40(sp)
    80006938:	02013403          	ld	s0,32(sp)
    8000693c:	01813483          	ld	s1,24(sp)
    80006940:	01013903          	ld	s2,16(sp)
    80006944:	03010113          	addi	sp,sp,48
    80006948:	00008067          	ret
    return -1;
    8000694c:	fff00513          	li	a0,-1
    80006950:	fe5ff06f          	j	80006934 <argfd+0x64>
    80006954:	fff00513          	li	a0,-1
    80006958:	fddff06f          	j	80006934 <argfd+0x64>

000000008000695c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000695c:	fe010113          	addi	sp,sp,-32
    80006960:	00113c23          	sd	ra,24(sp)
    80006964:	00813823          	sd	s0,16(sp)
    80006968:	00913423          	sd	s1,8(sp)
    8000696c:	02010413          	addi	s0,sp,32
    80006970:	00050493          	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80006974:	ae9fb0ef          	jal	8000245c <myproc>
    80006978:	00050613          	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000697c:	0d050793          	addi	a5,a0,208
    80006980:	00000513          	li	a0,0
    80006984:	01000693          	li	a3,16
    if(p->ofile[fd] == 0){
    80006988:	0007b703          	ld	a4,0(a5)
    8000698c:	02070463          	beqz	a4,800069b4 <fdalloc+0x58>
  for(fd = 0; fd < NOFILE; fd++){
    80006990:	0015051b          	addiw	a0,a0,1
    80006994:	00878793          	addi	a5,a5,8
    80006998:	fed518e3          	bne	a0,a3,80006988 <fdalloc+0x2c>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000699c:	fff00513          	li	a0,-1
}
    800069a0:	01813083          	ld	ra,24(sp)
    800069a4:	01013403          	ld	s0,16(sp)
    800069a8:	00813483          	ld	s1,8(sp)
    800069ac:	02010113          	addi	sp,sp,32
    800069b0:	00008067          	ret
      p->ofile[fd] = f;
    800069b4:	01a50793          	addi	a5,a0,26
    800069b8:	00379793          	slli	a5,a5,0x3
    800069bc:	00f60633          	add	a2,a2,a5
    800069c0:	00963023          	sd	s1,0(a2) # 2000 <_entry-0x7fffe000>
      return fd;
    800069c4:	fddff06f          	j	800069a0 <fdalloc+0x44>

00000000800069c8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800069c8:	fb010113          	addi	sp,sp,-80
    800069cc:	04113423          	sd	ra,72(sp)
    800069d0:	04813023          	sd	s0,64(sp)
    800069d4:	02913c23          	sd	s1,56(sp)
    800069d8:	03213823          	sd	s2,48(sp)
    800069dc:	03313423          	sd	s3,40(sp)
    800069e0:	01513c23          	sd	s5,24(sp)
    800069e4:	01613823          	sd	s6,16(sp)
    800069e8:	05010413          	addi	s0,sp,80
    800069ec:	00058b13          	mv	s6,a1
    800069f0:	00060993          	mv	s3,a2
    800069f4:	00068913          	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800069f8:	fb040593          	addi	a1,s0,-80
    800069fc:	8e5fe0ef          	jal	800052e0 <nameiparent>
    80006a00:	00050493          	mv	s1,a0
    80006a04:	16050e63          	beqz	a0,80006b80 <create+0x1b8>
    return 0;

  ilock(dp);
    80006a08:	e6dfd0ef          	jal	80004874 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80006a0c:	00000613          	li	a2,0
    80006a10:	fb040593          	addi	a1,s0,-80
    80006a14:	00048513          	mv	a0,s1
    80006a18:	d08fe0ef          	jal	80004f20 <dirlookup>
    80006a1c:	00050a93          	mv	s5,a0
    80006a20:	06050663          	beqz	a0,80006a8c <create+0xc4>
    iunlockput(dp);
    80006a24:	00048513          	mv	a0,s1
    80006a28:	934fe0ef          	jal	80004b5c <iunlockput>
    ilock(ip);
    80006a2c:	000a8513          	mv	a0,s5
    80006a30:	e45fd0ef          	jal	80004874 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80006a34:	00200793          	li	a5,2
    80006a38:	04fb1263          	bne	s6,a5,80006a7c <create+0xb4>
    80006a3c:	044ad783          	lhu	a5,68(s5)
    80006a40:	ffe7879b          	addiw	a5,a5,-2
    80006a44:	03079793          	slli	a5,a5,0x30
    80006a48:	0307d793          	srli	a5,a5,0x30
    80006a4c:	00100713          	li	a4,1
    80006a50:	02f76663          	bltu	a4,a5,80006a7c <create+0xb4>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80006a54:	000a8513          	mv	a0,s5
    80006a58:	04813083          	ld	ra,72(sp)
    80006a5c:	04013403          	ld	s0,64(sp)
    80006a60:	03813483          	ld	s1,56(sp)
    80006a64:	03013903          	ld	s2,48(sp)
    80006a68:	02813983          	ld	s3,40(sp)
    80006a6c:	01813a83          	ld	s5,24(sp)
    80006a70:	01013b03          	ld	s6,16(sp)
    80006a74:	05010113          	addi	sp,sp,80
    80006a78:	00008067          	ret
    iunlockput(ip);
    80006a7c:	000a8513          	mv	a0,s5
    80006a80:	8dcfe0ef          	jal	80004b5c <iunlockput>
    return 0;
    80006a84:	00000a93          	li	s5,0
    80006a88:	fcdff06f          	j	80006a54 <create+0x8c>
    80006a8c:	03413023          	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80006a90:	000b0593          	mv	a1,s6
    80006a94:	0004a503          	lw	a0,0(s1)
    80006a98:	bc5fd0ef          	jal	8000465c <ialloc>
    80006a9c:	00050a13          	mv	s4,a0
    80006aa0:	04050663          	beqz	a0,80006aec <create+0x124>
  ilock(ip);
    80006aa4:	dd1fd0ef          	jal	80004874 <ilock>
  ip->major = major;
    80006aa8:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80006aac:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80006ab0:	00100913          	li	s2,1
    80006ab4:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80006ab8:	000a0513          	mv	a0,s4
    80006abc:	cb5fd0ef          	jal	80004770 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80006ac0:	052b0063          	beq	s6,s2,80006b00 <create+0x138>
  if(dirlink(dp, name, ip->inum) < 0)
    80006ac4:	004a2603          	lw	a2,4(s4)
    80006ac8:	fb040593          	addi	a1,s0,-80
    80006acc:	00048513          	mv	a0,s1
    80006ad0:	efcfe0ef          	jal	800051cc <dirlink>
    80006ad4:	08054463          	bltz	a0,80006b5c <create+0x194>
  iunlockput(dp);
    80006ad8:	00048513          	mv	a0,s1
    80006adc:	880fe0ef          	jal	80004b5c <iunlockput>
  return ip;
    80006ae0:	000a0a93          	mv	s5,s4
    80006ae4:	02013a03          	ld	s4,32(sp)
    80006ae8:	f6dff06f          	j	80006a54 <create+0x8c>
    iunlockput(dp);
    80006aec:	00048513          	mv	a0,s1
    80006af0:	86cfe0ef          	jal	80004b5c <iunlockput>
    return 0;
    80006af4:	000a0a93          	mv	s5,s4
    80006af8:	02013a03          	ld	s4,32(sp)
    80006afc:	f59ff06f          	j	80006a54 <create+0x8c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80006b00:	004a2603          	lw	a2,4(s4)
    80006b04:	00003597          	auipc	a1,0x3
    80006b08:	b1c58593          	addi	a1,a1,-1252 # 80009620 <etext+0x620>
    80006b0c:	000a0513          	mv	a0,s4
    80006b10:	ebcfe0ef          	jal	800051cc <dirlink>
    80006b14:	04054463          	bltz	a0,80006b5c <create+0x194>
    80006b18:	0044a603          	lw	a2,4(s1)
    80006b1c:	00003597          	auipc	a1,0x3
    80006b20:	b0c58593          	addi	a1,a1,-1268 # 80009628 <etext+0x628>
    80006b24:	000a0513          	mv	a0,s4
    80006b28:	ea4fe0ef          	jal	800051cc <dirlink>
    80006b2c:	02054863          	bltz	a0,80006b5c <create+0x194>
  if(dirlink(dp, name, ip->inum) < 0)
    80006b30:	004a2603          	lw	a2,4(s4)
    80006b34:	fb040593          	addi	a1,s0,-80
    80006b38:	00048513          	mv	a0,s1
    80006b3c:	e90fe0ef          	jal	800051cc <dirlink>
    80006b40:	00054e63          	bltz	a0,80006b5c <create+0x194>
    dp->nlink++;  // for ".."
    80006b44:	04a4d783          	lhu	a5,74(s1)
    80006b48:	0017879b          	addiw	a5,a5,1
    80006b4c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80006b50:	00048513          	mv	a0,s1
    80006b54:	c1dfd0ef          	jal	80004770 <iupdate>
    80006b58:	f81ff06f          	j	80006ad8 <create+0x110>
  ip->nlink = 0;
    80006b5c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80006b60:	000a0513          	mv	a0,s4
    80006b64:	c0dfd0ef          	jal	80004770 <iupdate>
  iunlockput(ip);
    80006b68:	000a0513          	mv	a0,s4
    80006b6c:	ff1fd0ef          	jal	80004b5c <iunlockput>
  iunlockput(dp);
    80006b70:	00048513          	mv	a0,s1
    80006b74:	fe9fd0ef          	jal	80004b5c <iunlockput>
  return 0;
    80006b78:	02013a03          	ld	s4,32(sp)
    80006b7c:	ed9ff06f          	j	80006a54 <create+0x8c>
    return 0;
    80006b80:	00050a93          	mv	s5,a0
    80006b84:	ed1ff06f          	j	80006a54 <create+0x8c>

0000000080006b88 <sys_dup>:
{
    80006b88:	fd010113          	addi	sp,sp,-48
    80006b8c:	02113423          	sd	ra,40(sp)
    80006b90:	02813023          	sd	s0,32(sp)
    80006b94:	03010413          	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80006b98:	fd840613          	addi	a2,s0,-40
    80006b9c:	00000593          	li	a1,0
    80006ba0:	00000513          	li	a0,0
    80006ba4:	d2dff0ef          	jal	800068d0 <argfd>
    return -1;
    80006ba8:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80006bac:	02054c63          	bltz	a0,80006be4 <sys_dup+0x5c>
    80006bb0:	00913c23          	sd	s1,24(sp)
    80006bb4:	01213823          	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80006bb8:	fd843903          	ld	s2,-40(s0)
    80006bbc:	00090513          	mv	a0,s2
    80006bc0:	d9dff0ef          	jal	8000695c <fdalloc>
    80006bc4:	00050493          	mv	s1,a0
    return -1;
    80006bc8:	fff00793          	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80006bcc:	02054663          	bltz	a0,80006bf8 <sys_dup+0x70>
  filedup(f);
    80006bd0:	00090513          	mv	a0,s2
    80006bd4:	ef1fe0ef          	jal	80005ac4 <filedup>
  return fd;
    80006bd8:	00048793          	mv	a5,s1
    80006bdc:	01813483          	ld	s1,24(sp)
    80006be0:	01013903          	ld	s2,16(sp)
}
    80006be4:	00078513          	mv	a0,a5
    80006be8:	02813083          	ld	ra,40(sp)
    80006bec:	02013403          	ld	s0,32(sp)
    80006bf0:	03010113          	addi	sp,sp,48
    80006bf4:	00008067          	ret
    80006bf8:	01813483          	ld	s1,24(sp)
    80006bfc:	01013903          	ld	s2,16(sp)
    80006c00:	fe5ff06f          	j	80006be4 <sys_dup+0x5c>

0000000080006c04 <sys_read>:
{
    80006c04:	fd010113          	addi	sp,sp,-48
    80006c08:	02113423          	sd	ra,40(sp)
    80006c0c:	02813023          	sd	s0,32(sp)
    80006c10:	03010413          	addi	s0,sp,48
  argaddr(1, &p);
    80006c14:	fd840593          	addi	a1,s0,-40
    80006c18:	00100513          	li	a0,1
    80006c1c:	e01fc0ef          	jal	80003a1c <argaddr>
  argint(2, &n);
    80006c20:	fe440593          	addi	a1,s0,-28
    80006c24:	00200513          	li	a0,2
    80006c28:	dc1fc0ef          	jal	800039e8 <argint>
  if(argfd(0, 0, &f) < 0)
    80006c2c:	fe840613          	addi	a2,s0,-24
    80006c30:	00000593          	li	a1,0
    80006c34:	00000513          	li	a0,0
    80006c38:	c99ff0ef          	jal	800068d0 <argfd>
    80006c3c:	00050793          	mv	a5,a0
    return -1;
    80006c40:	fff00513          	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80006c44:	0007ca63          	bltz	a5,80006c58 <sys_read+0x54>
  return fileread(f, p, n);
    80006c48:	fe442603          	lw	a2,-28(s0)
    80006c4c:	fd843583          	ld	a1,-40(s0)
    80006c50:	fe843503          	ld	a0,-24(s0)
    80006c54:	880ff0ef          	jal	80005cd4 <fileread>
}
    80006c58:	02813083          	ld	ra,40(sp)
    80006c5c:	02013403          	ld	s0,32(sp)
    80006c60:	03010113          	addi	sp,sp,48
    80006c64:	00008067          	ret

0000000080006c68 <sys_write>:
{
    80006c68:	fd010113          	addi	sp,sp,-48
    80006c6c:	02113423          	sd	ra,40(sp)
    80006c70:	02813023          	sd	s0,32(sp)
    80006c74:	03010413          	addi	s0,sp,48
  argaddr(1, &p);
    80006c78:	fd840593          	addi	a1,s0,-40
    80006c7c:	00100513          	li	a0,1
    80006c80:	d9dfc0ef          	jal	80003a1c <argaddr>
  argint(2, &n);
    80006c84:	fe440593          	addi	a1,s0,-28
    80006c88:	00200513          	li	a0,2
    80006c8c:	d5dfc0ef          	jal	800039e8 <argint>
  if(argfd(0, 0, &f) < 0)
    80006c90:	fe840613          	addi	a2,s0,-24
    80006c94:	00000593          	li	a1,0
    80006c98:	00000513          	li	a0,0
    80006c9c:	c35ff0ef          	jal	800068d0 <argfd>
    80006ca0:	00050793          	mv	a5,a0
    return -1;
    80006ca4:	fff00513          	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80006ca8:	0007ca63          	bltz	a5,80006cbc <sys_write+0x54>
  return filewrite(f, p, n);
    80006cac:	fe442603          	lw	a2,-28(s0)
    80006cb0:	fd843583          	ld	a1,-40(s0)
    80006cb4:	fe843503          	ld	a0,-24(s0)
    80006cb8:	954ff0ef          	jal	80005e0c <filewrite>
}
    80006cbc:	02813083          	ld	ra,40(sp)
    80006cc0:	02013403          	ld	s0,32(sp)
    80006cc4:	03010113          	addi	sp,sp,48
    80006cc8:	00008067          	ret

0000000080006ccc <sys_close>:
{
    80006ccc:	fe010113          	addi	sp,sp,-32
    80006cd0:	00113c23          	sd	ra,24(sp)
    80006cd4:	00813823          	sd	s0,16(sp)
    80006cd8:	02010413          	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80006cdc:	fe040613          	addi	a2,s0,-32
    80006ce0:	fec40593          	addi	a1,s0,-20
    80006ce4:	00000513          	li	a0,0
    80006ce8:	be9ff0ef          	jal	800068d0 <argfd>
    return -1;
    80006cec:	fff00793          	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80006cf0:	02054463          	bltz	a0,80006d18 <sys_close+0x4c>
  myproc()->ofile[fd] = 0;
    80006cf4:	f68fb0ef          	jal	8000245c <myproc>
    80006cf8:	fec42783          	lw	a5,-20(s0)
    80006cfc:	01a78793          	addi	a5,a5,26
    80006d00:	00379793          	slli	a5,a5,0x3
    80006d04:	00f50533          	add	a0,a0,a5
    80006d08:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80006d0c:	fe043503          	ld	a0,-32(s0)
    80006d10:	e19fe0ef          	jal	80005b28 <fileclose>
  return 0;
    80006d14:	00000793          	li	a5,0
}
    80006d18:	00078513          	mv	a0,a5
    80006d1c:	01813083          	ld	ra,24(sp)
    80006d20:	01013403          	ld	s0,16(sp)
    80006d24:	02010113          	addi	sp,sp,32
    80006d28:	00008067          	ret

0000000080006d2c <sys_fstat>:
{
    80006d2c:	fe010113          	addi	sp,sp,-32
    80006d30:	00113c23          	sd	ra,24(sp)
    80006d34:	00813823          	sd	s0,16(sp)
    80006d38:	02010413          	addi	s0,sp,32
  argaddr(1, &st);
    80006d3c:	fe040593          	addi	a1,s0,-32
    80006d40:	00100513          	li	a0,1
    80006d44:	cd9fc0ef          	jal	80003a1c <argaddr>
  if(argfd(0, 0, &f) < 0)
    80006d48:	fe840613          	addi	a2,s0,-24
    80006d4c:	00000593          	li	a1,0
    80006d50:	00000513          	li	a0,0
    80006d54:	b7dff0ef          	jal	800068d0 <argfd>
    80006d58:	00050793          	mv	a5,a0
    return -1;
    80006d5c:	fff00513          	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80006d60:	0007c863          	bltz	a5,80006d70 <sys_fstat+0x44>
  return filestat(f, st);
    80006d64:	fe043583          	ld	a1,-32(s0)
    80006d68:	fe843503          	ld	a0,-24(s0)
    80006d6c:	ed5fe0ef          	jal	80005c40 <filestat>
}
    80006d70:	01813083          	ld	ra,24(sp)
    80006d74:	01013403          	ld	s0,16(sp)
    80006d78:	02010113          	addi	sp,sp,32
    80006d7c:	00008067          	ret

0000000080006d80 <sys_link>:
{
    80006d80:	ed010113          	addi	sp,sp,-304
    80006d84:	12113423          	sd	ra,296(sp)
    80006d88:	12813023          	sd	s0,288(sp)
    80006d8c:	13010413          	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80006d90:	08000613          	li	a2,128
    80006d94:	ed040593          	addi	a1,s0,-304
    80006d98:	00000513          	li	a0,0
    80006d9c:	cb5fc0ef          	jal	80003a50 <argstr>
    return -1;
    80006da0:	fff00793          	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80006da4:	12054263          	bltz	a0,80006ec8 <sys_link+0x148>
    80006da8:	08000613          	li	a2,128
    80006dac:	f5040593          	addi	a1,s0,-176
    80006db0:	00100513          	li	a0,1
    80006db4:	c9dfc0ef          	jal	80003a50 <argstr>
    return -1;
    80006db8:	fff00793          	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80006dbc:	10054663          	bltz	a0,80006ec8 <sys_link+0x148>
    80006dc0:	10913c23          	sd	s1,280(sp)
  begin_op();
    80006dc4:	f80fe0ef          	jal	80005544 <begin_op>
  if((ip = namei(old)) == 0){
    80006dc8:	ed040513          	addi	a0,s0,-304
    80006dcc:	ce8fe0ef          	jal	800052b4 <namei>
    80006dd0:	00050493          	mv	s1,a0
    80006dd4:	08050863          	beqz	a0,80006e64 <sys_link+0xe4>
  ilock(ip);
    80006dd8:	a9dfd0ef          	jal	80004874 <ilock>
  if(ip->type == T_DIR){
    80006ddc:	04449703          	lh	a4,68(s1)
    80006de0:	00100793          	li	a5,1
    80006de4:	08f70863          	beq	a4,a5,80006e74 <sys_link+0xf4>
    80006de8:	11213823          	sd	s2,272(sp)
  ip->nlink++;
    80006dec:	04a4d783          	lhu	a5,74(s1)
    80006df0:	0017879b          	addiw	a5,a5,1
    80006df4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80006df8:	00048513          	mv	a0,s1
    80006dfc:	975fd0ef          	jal	80004770 <iupdate>
  iunlock(ip);
    80006e00:	00048513          	mv	a0,s1
    80006e04:	b65fd0ef          	jal	80004968 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80006e08:	fd040593          	addi	a1,s0,-48
    80006e0c:	f5040513          	addi	a0,s0,-176
    80006e10:	cd0fe0ef          	jal	800052e0 <nameiparent>
    80006e14:	00050913          	mv	s2,a0
    80006e18:	06050e63          	beqz	a0,80006e94 <sys_link+0x114>
  ilock(dp);
    80006e1c:	a59fd0ef          	jal	80004874 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80006e20:	00092703          	lw	a4,0(s2)
    80006e24:	0004a783          	lw	a5,0(s1)
    80006e28:	06f71263          	bne	a4,a5,80006e8c <sys_link+0x10c>
    80006e2c:	0044a603          	lw	a2,4(s1)
    80006e30:	fd040593          	addi	a1,s0,-48
    80006e34:	00090513          	mv	a0,s2
    80006e38:	b94fe0ef          	jal	800051cc <dirlink>
    80006e3c:	04054863          	bltz	a0,80006e8c <sys_link+0x10c>
  iunlockput(dp);
    80006e40:	00090513          	mv	a0,s2
    80006e44:	d19fd0ef          	jal	80004b5c <iunlockput>
  iput(ip);
    80006e48:	00048513          	mv	a0,s1
    80006e4c:	c55fd0ef          	jal	80004aa0 <iput>
  end_op();
    80006e50:	f94fe0ef          	jal	800055e4 <end_op>
  return 0;
    80006e54:	00000793          	li	a5,0
    80006e58:	11813483          	ld	s1,280(sp)
    80006e5c:	11013903          	ld	s2,272(sp)
    80006e60:	0680006f          	j	80006ec8 <sys_link+0x148>
    end_op();
    80006e64:	f80fe0ef          	jal	800055e4 <end_op>
    return -1;
    80006e68:	fff00793          	li	a5,-1
    80006e6c:	11813483          	ld	s1,280(sp)
    80006e70:	0580006f          	j	80006ec8 <sys_link+0x148>
    iunlockput(ip);
    80006e74:	00048513          	mv	a0,s1
    80006e78:	ce5fd0ef          	jal	80004b5c <iunlockput>
    end_op();
    80006e7c:	f68fe0ef          	jal	800055e4 <end_op>
    return -1;
    80006e80:	fff00793          	li	a5,-1
    80006e84:	11813483          	ld	s1,280(sp)
    80006e88:	0400006f          	j	80006ec8 <sys_link+0x148>
    iunlockput(dp);
    80006e8c:	00090513          	mv	a0,s2
    80006e90:	ccdfd0ef          	jal	80004b5c <iunlockput>
  ilock(ip);
    80006e94:	00048513          	mv	a0,s1
    80006e98:	9ddfd0ef          	jal	80004874 <ilock>
  ip->nlink--;
    80006e9c:	04a4d783          	lhu	a5,74(s1)
    80006ea0:	fff7879b          	addiw	a5,a5,-1
    80006ea4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80006ea8:	00048513          	mv	a0,s1
    80006eac:	8c5fd0ef          	jal	80004770 <iupdate>
  iunlockput(ip);
    80006eb0:	00048513          	mv	a0,s1
    80006eb4:	ca9fd0ef          	jal	80004b5c <iunlockput>
  end_op();
    80006eb8:	f2cfe0ef          	jal	800055e4 <end_op>
  return -1;
    80006ebc:	fff00793          	li	a5,-1
    80006ec0:	11813483          	ld	s1,280(sp)
    80006ec4:	11013903          	ld	s2,272(sp)
}
    80006ec8:	00078513          	mv	a0,a5
    80006ecc:	12813083          	ld	ra,296(sp)
    80006ed0:	12013403          	ld	s0,288(sp)
    80006ed4:	13010113          	addi	sp,sp,304
    80006ed8:	00008067          	ret

0000000080006edc <sys_unlink>:
{
    80006edc:	f1010113          	addi	sp,sp,-240
    80006ee0:	0e113423          	sd	ra,232(sp)
    80006ee4:	0e813023          	sd	s0,224(sp)
    80006ee8:	0f010413          	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80006eec:	08000613          	li	a2,128
    80006ef0:	f3040593          	addi	a1,s0,-208
    80006ef4:	00000513          	li	a0,0
    80006ef8:	b59fc0ef          	jal	80003a50 <argstr>
    80006efc:	1c054063          	bltz	a0,800070bc <sys_unlink+0x1e0>
    80006f00:	0c913c23          	sd	s1,216(sp)
  begin_op();
    80006f04:	e40fe0ef          	jal	80005544 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80006f08:	fb040593          	addi	a1,s0,-80
    80006f0c:	f3040513          	addi	a0,s0,-208
    80006f10:	bd0fe0ef          	jal	800052e0 <nameiparent>
    80006f14:	00050493          	mv	s1,a0
    80006f18:	0c050c63          	beqz	a0,80006ff0 <sys_unlink+0x114>
  ilock(dp);
    80006f1c:	959fd0ef          	jal	80004874 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80006f20:	00002597          	auipc	a1,0x2
    80006f24:	70058593          	addi	a1,a1,1792 # 80009620 <etext+0x620>
    80006f28:	fb040513          	addi	a0,s0,-80
    80006f2c:	fcdfd0ef          	jal	80004ef8 <namecmp>
    80006f30:	16050463          	beqz	a0,80007098 <sys_unlink+0x1bc>
    80006f34:	00002597          	auipc	a1,0x2
    80006f38:	6f458593          	addi	a1,a1,1780 # 80009628 <etext+0x628>
    80006f3c:	fb040513          	addi	a0,s0,-80
    80006f40:	fb9fd0ef          	jal	80004ef8 <namecmp>
    80006f44:	14050a63          	beqz	a0,80007098 <sys_unlink+0x1bc>
    80006f48:	0d213823          	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80006f4c:	f2c40613          	addi	a2,s0,-212
    80006f50:	fb040593          	addi	a1,s0,-80
    80006f54:	00048513          	mv	a0,s1
    80006f58:	fc9fd0ef          	jal	80004f20 <dirlookup>
    80006f5c:	00050913          	mv	s2,a0
    80006f60:	12050a63          	beqz	a0,80007094 <sys_unlink+0x1b8>
  ilock(ip);
    80006f64:	911fd0ef          	jal	80004874 <ilock>
  if(ip->nlink < 1)
    80006f68:	04a91783          	lh	a5,74(s2)
    80006f6c:	08f05a63          	blez	a5,80007000 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80006f70:	04491703          	lh	a4,68(s2)
    80006f74:	00100793          	li	a5,1
    80006f78:	08f70c63          	beq	a4,a5,80007010 <sys_unlink+0x134>
  memset(&de, 0, sizeof(de));
    80006f7c:	01000613          	li	a2,16
    80006f80:	00000593          	li	a1,0
    80006f84:	fc040513          	addi	a0,s0,-64
    80006f88:	9f0fa0ef          	jal	80001178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80006f8c:	01000713          	li	a4,16
    80006f90:	f2c42683          	lw	a3,-212(s0)
    80006f94:	fc040613          	addi	a2,s0,-64
    80006f98:	00000593          	li	a1,0
    80006f9c:	00048513          	mv	a0,s1
    80006fa0:	dc1fd0ef          	jal	80004d60 <writei>
    80006fa4:	01000793          	li	a5,16
    80006fa8:	0cf51263          	bne	a0,a5,8000706c <sys_unlink+0x190>
  if(ip->type == T_DIR){
    80006fac:	04491703          	lh	a4,68(s2)
    80006fb0:	00100793          	li	a5,1
    80006fb4:	0cf70463          	beq	a4,a5,8000707c <sys_unlink+0x1a0>
  iunlockput(dp);
    80006fb8:	00048513          	mv	a0,s1
    80006fbc:	ba1fd0ef          	jal	80004b5c <iunlockput>
  ip->nlink--;
    80006fc0:	04a95783          	lhu	a5,74(s2)
    80006fc4:	fff7879b          	addiw	a5,a5,-1
    80006fc8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80006fcc:	00090513          	mv	a0,s2
    80006fd0:	fa0fd0ef          	jal	80004770 <iupdate>
  iunlockput(ip);
    80006fd4:	00090513          	mv	a0,s2
    80006fd8:	b85fd0ef          	jal	80004b5c <iunlockput>
  end_op();
    80006fdc:	e08fe0ef          	jal	800055e4 <end_op>
  return 0;
    80006fe0:	00000513          	li	a0,0
    80006fe4:	0d813483          	ld	s1,216(sp)
    80006fe8:	0d013903          	ld	s2,208(sp)
    80006fec:	0c00006f          	j	800070ac <sys_unlink+0x1d0>
    end_op();
    80006ff0:	df4fe0ef          	jal	800055e4 <end_op>
    return -1;
    80006ff4:	fff00513          	li	a0,-1
    80006ff8:	0d813483          	ld	s1,216(sp)
    80006ffc:	0b00006f          	j	800070ac <sys_unlink+0x1d0>
    80007000:	0d313423          	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80007004:	00002517          	auipc	a0,0x2
    80007008:	62c50513          	addi	a0,a0,1580 # 80009630 <etext+0x630>
    8000700c:	9f5f90ef          	jal	80000a00 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007010:	04c92703          	lw	a4,76(s2)
    80007014:	02000793          	li	a5,32
    80007018:	f6e7f2e3          	bgeu	a5,a4,80006f7c <sys_unlink+0xa0>
    8000701c:	0d313423          	sd	s3,200(sp)
    80007020:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80007024:	01000713          	li	a4,16
    80007028:	00098693          	mv	a3,s3
    8000702c:	f1840613          	addi	a2,s0,-232
    80007030:	00000593          	li	a1,0
    80007034:	00090513          	mv	a0,s2
    80007038:	b9dfd0ef          	jal	80004bd4 <readi>
    8000703c:	01000793          	li	a5,16
    80007040:	02f51063          	bne	a0,a5,80007060 <sys_unlink+0x184>
    if(de.inum != 0)
    80007044:	f1845783          	lhu	a5,-232(s0)
    80007048:	06079e63          	bnez	a5,800070c4 <sys_unlink+0x1e8>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000704c:	0109899b          	addiw	s3,s3,16
    80007050:	04c92783          	lw	a5,76(s2)
    80007054:	fcf9e8e3          	bltu	s3,a5,80007024 <sys_unlink+0x148>
    80007058:	0c813983          	ld	s3,200(sp)
    8000705c:	f21ff06f          	j	80006f7c <sys_unlink+0xa0>
      panic("isdirempty: readi");
    80007060:	00002517          	auipc	a0,0x2
    80007064:	5e850513          	addi	a0,a0,1512 # 80009648 <etext+0x648>
    80007068:	999f90ef          	jal	80000a00 <panic>
    8000706c:	0d313423          	sd	s3,200(sp)
    panic("unlink: writei");
    80007070:	00002517          	auipc	a0,0x2
    80007074:	5f050513          	addi	a0,a0,1520 # 80009660 <etext+0x660>
    80007078:	989f90ef          	jal	80000a00 <panic>
    dp->nlink--;
    8000707c:	04a4d783          	lhu	a5,74(s1)
    80007080:	fff7879b          	addiw	a5,a5,-1
    80007084:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80007088:	00048513          	mv	a0,s1
    8000708c:	ee4fd0ef          	jal	80004770 <iupdate>
    80007090:	f29ff06f          	j	80006fb8 <sys_unlink+0xdc>
    80007094:	0d013903          	ld	s2,208(sp)
  iunlockput(dp);
    80007098:	00048513          	mv	a0,s1
    8000709c:	ac1fd0ef          	jal	80004b5c <iunlockput>
  end_op();
    800070a0:	d44fe0ef          	jal	800055e4 <end_op>
  return -1;
    800070a4:	fff00513          	li	a0,-1
    800070a8:	0d813483          	ld	s1,216(sp)
}
    800070ac:	0e813083          	ld	ra,232(sp)
    800070b0:	0e013403          	ld	s0,224(sp)
    800070b4:	0f010113          	addi	sp,sp,240
    800070b8:	00008067          	ret
    return -1;
    800070bc:	fff00513          	li	a0,-1
    800070c0:	fedff06f          	j	800070ac <sys_unlink+0x1d0>
    iunlockput(ip);
    800070c4:	00090513          	mv	a0,s2
    800070c8:	a95fd0ef          	jal	80004b5c <iunlockput>
    goto bad;
    800070cc:	0d013903          	ld	s2,208(sp)
    800070d0:	0c813983          	ld	s3,200(sp)
    800070d4:	fc5ff06f          	j	80007098 <sys_unlink+0x1bc>

00000000800070d8 <sys_open>:

uint64
sys_open(void)
{
    800070d8:	f4010113          	addi	sp,sp,-192
    800070dc:	0a113c23          	sd	ra,184(sp)
    800070e0:	0a813823          	sd	s0,176(sp)
    800070e4:	0c010413          	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800070e8:	f4c40593          	addi	a1,s0,-180
    800070ec:	00100513          	li	a0,1
    800070f0:	8f9fc0ef          	jal	800039e8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800070f4:	08000613          	li	a2,128
    800070f8:	f5040593          	addi	a1,s0,-176
    800070fc:	00000513          	li	a0,0
    80007100:	951fc0ef          	jal	80003a50 <argstr>
    80007104:	00050793          	mv	a5,a0
    return -1;
    80007108:	fff00513          	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000710c:	0c07ca63          	bltz	a5,800071e0 <sys_open+0x108>
    80007110:	0a913423          	sd	s1,168(sp)

  begin_op();
    80007114:	c30fe0ef          	jal	80005544 <begin_op>

  if(omode & O_CREATE){
    80007118:	f4c42783          	lw	a5,-180(s0)
    8000711c:	2007f793          	andi	a5,a5,512
    80007120:	0e078063          	beqz	a5,80007200 <sys_open+0x128>
    ip = create(path, T_FILE, 0, 0);
    80007124:	00000693          	li	a3,0
    80007128:	00000613          	li	a2,0
    8000712c:	00200593          	li	a1,2
    80007130:	f5040513          	addi	a0,s0,-176
    80007134:	895ff0ef          	jal	800069c8 <create>
    80007138:	00050493          	mv	s1,a0
    if(ip == 0){
    8000713c:	0a050a63          	beqz	a0,800071f0 <sys_open+0x118>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80007140:	04449703          	lh	a4,68(s1)
    80007144:	00300793          	li	a5,3
    80007148:	00f71863          	bne	a4,a5,80007158 <sys_open+0x80>
    8000714c:	0464d703          	lhu	a4,70(s1)
    80007150:	00900793          	li	a5,9
    80007154:	0ee7ee63          	bltu	a5,a4,80007250 <sys_open+0x178>
    80007158:	0b213023          	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000715c:	8e9fe0ef          	jal	80005a44 <filealloc>
    80007160:	00050913          	mv	s2,a0
    80007164:	10050863          	beqz	a0,80007274 <sys_open+0x19c>
    80007168:	09313c23          	sd	s3,152(sp)
    8000716c:	ff0ff0ef          	jal	8000695c <fdalloc>
    80007170:	00050993          	mv	s3,a0
    80007174:	0e054a63          	bltz	a0,80007268 <sys_open+0x190>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80007178:	04449703          	lh	a4,68(s1)
    8000717c:	00300793          	li	a5,3
    80007180:	10f70863          	beq	a4,a5,80007290 <sys_open+0x1b8>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80007184:	00200793          	li	a5,2
    80007188:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000718c:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80007190:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80007194:	f4c42783          	lw	a5,-180(s0)
    80007198:	0017c713          	xori	a4,a5,1
    8000719c:	00177713          	andi	a4,a4,1
    800071a0:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800071a4:	0037f713          	andi	a4,a5,3
    800071a8:	00e03733          	snez	a4,a4
    800071ac:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800071b0:	4007f793          	andi	a5,a5,1024
    800071b4:	00078863          	beqz	a5,800071c4 <sys_open+0xec>
    800071b8:	04449703          	lh	a4,68(s1)
    800071bc:	00200793          	li	a5,2
    800071c0:	0ef70063          	beq	a4,a5,800072a0 <sys_open+0x1c8>
    itrunc(ip);
  }

  iunlock(ip);
    800071c4:	00048513          	mv	a0,s1
    800071c8:	fa0fd0ef          	jal	80004968 <iunlock>
  end_op();
    800071cc:	c18fe0ef          	jal	800055e4 <end_op>

  return fd;
    800071d0:	00098513          	mv	a0,s3
    800071d4:	0a813483          	ld	s1,168(sp)
    800071d8:	0a013903          	ld	s2,160(sp)
    800071dc:	09813983          	ld	s3,152(sp)
}
    800071e0:	0b813083          	ld	ra,184(sp)
    800071e4:	0b013403          	ld	s0,176(sp)
    800071e8:	0c010113          	addi	sp,sp,192
    800071ec:	00008067          	ret
      end_op();
    800071f0:	bf4fe0ef          	jal	800055e4 <end_op>
      return -1;
    800071f4:	fff00513          	li	a0,-1
    800071f8:	0a813483          	ld	s1,168(sp)
    800071fc:	fe5ff06f          	j	800071e0 <sys_open+0x108>
    if((ip = namei(path)) == 0){
    80007200:	f5040513          	addi	a0,s0,-176
    80007204:	8b0fe0ef          	jal	800052b4 <namei>
    80007208:	00050493          	mv	s1,a0
    8000720c:	02050a63          	beqz	a0,80007240 <sys_open+0x168>
    ilock(ip);
    80007210:	e64fd0ef          	jal	80004874 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80007214:	04449703          	lh	a4,68(s1)
    80007218:	00100793          	li	a5,1
    8000721c:	f2f712e3          	bne	a4,a5,80007140 <sys_open+0x68>
    80007220:	f4c42783          	lw	a5,-180(s0)
    80007224:	f2078ae3          	beqz	a5,80007158 <sys_open+0x80>
      iunlockput(ip);
    80007228:	00048513          	mv	a0,s1
    8000722c:	931fd0ef          	jal	80004b5c <iunlockput>
      end_op();
    80007230:	bb4fe0ef          	jal	800055e4 <end_op>
      return -1;
    80007234:	fff00513          	li	a0,-1
    80007238:	0a813483          	ld	s1,168(sp)
    8000723c:	fa5ff06f          	j	800071e0 <sys_open+0x108>
      end_op();
    80007240:	ba4fe0ef          	jal	800055e4 <end_op>
      return -1;
    80007244:	fff00513          	li	a0,-1
    80007248:	0a813483          	ld	s1,168(sp)
    8000724c:	f95ff06f          	j	800071e0 <sys_open+0x108>
    iunlockput(ip);
    80007250:	00048513          	mv	a0,s1
    80007254:	909fd0ef          	jal	80004b5c <iunlockput>
    end_op();
    80007258:	b8cfe0ef          	jal	800055e4 <end_op>
    return -1;
    8000725c:	fff00513          	li	a0,-1
    80007260:	0a813483          	ld	s1,168(sp)
    80007264:	f7dff06f          	j	800071e0 <sys_open+0x108>
      fileclose(f);
    80007268:	00090513          	mv	a0,s2
    8000726c:	8bdfe0ef          	jal	80005b28 <fileclose>
    80007270:	09813983          	ld	s3,152(sp)
    iunlockput(ip);
    80007274:	00048513          	mv	a0,s1
    80007278:	8e5fd0ef          	jal	80004b5c <iunlockput>
    end_op();
    8000727c:	b68fe0ef          	jal	800055e4 <end_op>
    return -1;
    80007280:	fff00513          	li	a0,-1
    80007284:	0a813483          	ld	s1,168(sp)
    80007288:	0a013903          	ld	s2,160(sp)
    8000728c:	f55ff06f          	j	800071e0 <sys_open+0x108>
    f->type = FD_DEVICE;
    80007290:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80007294:	04649783          	lh	a5,70(s1)
    80007298:	02f91223          	sh	a5,36(s2)
    8000729c:	ef5ff06f          	j	80007190 <sys_open+0xb8>
    itrunc(ip);
    800072a0:	00048513          	mv	a0,s1
    800072a4:	f28fd0ef          	jal	800049cc <itrunc>
    800072a8:	f1dff06f          	j	800071c4 <sys_open+0xec>

00000000800072ac <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800072ac:	f7010113          	addi	sp,sp,-144
    800072b0:	08113423          	sd	ra,136(sp)
    800072b4:	08813023          	sd	s0,128(sp)
    800072b8:	09010413          	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800072bc:	a88fe0ef          	jal	80005544 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800072c0:	08000613          	li	a2,128
    800072c4:	f7040593          	addi	a1,s0,-144
    800072c8:	00000513          	li	a0,0
    800072cc:	f84fc0ef          	jal	80003a50 <argstr>
    800072d0:	02054c63          	bltz	a0,80007308 <sys_mkdir+0x5c>
    800072d4:	00000693          	li	a3,0
    800072d8:	00000613          	li	a2,0
    800072dc:	00100593          	li	a1,1
    800072e0:	f7040513          	addi	a0,s0,-144
    800072e4:	ee4ff0ef          	jal	800069c8 <create>
    800072e8:	02050063          	beqz	a0,80007308 <sys_mkdir+0x5c>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800072ec:	871fd0ef          	jal	80004b5c <iunlockput>
  end_op();
    800072f0:	af4fe0ef          	jal	800055e4 <end_op>
  return 0;
    800072f4:	00000513          	li	a0,0
}
    800072f8:	08813083          	ld	ra,136(sp)
    800072fc:	08013403          	ld	s0,128(sp)
    80007300:	09010113          	addi	sp,sp,144
    80007304:	00008067          	ret
    end_op();
    80007308:	adcfe0ef          	jal	800055e4 <end_op>
    return -1;
    8000730c:	fff00513          	li	a0,-1
    80007310:	fe9ff06f          	j	800072f8 <sys_mkdir+0x4c>

0000000080007314 <sys_mknod>:

uint64
sys_mknod(void)
{
    80007314:	f6010113          	addi	sp,sp,-160
    80007318:	08113c23          	sd	ra,152(sp)
    8000731c:	08813823          	sd	s0,144(sp)
    80007320:	0a010413          	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80007324:	a20fe0ef          	jal	80005544 <begin_op>
  argint(1, &major);
    80007328:	f6c40593          	addi	a1,s0,-148
    8000732c:	00100513          	li	a0,1
    80007330:	eb8fc0ef          	jal	800039e8 <argint>
  argint(2, &minor);
    80007334:	f6840593          	addi	a1,s0,-152
    80007338:	00200513          	li	a0,2
    8000733c:	eacfc0ef          	jal	800039e8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80007340:	08000613          	li	a2,128
    80007344:	f7040593          	addi	a1,s0,-144
    80007348:	00000513          	li	a0,0
    8000734c:	f04fc0ef          	jal	80003a50 <argstr>
    80007350:	02054c63          	bltz	a0,80007388 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80007354:	f6841683          	lh	a3,-152(s0)
    80007358:	f6c41603          	lh	a2,-148(s0)
    8000735c:	00300593          	li	a1,3
    80007360:	f7040513          	addi	a0,s0,-144
    80007364:	e64ff0ef          	jal	800069c8 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80007368:	02050063          	beqz	a0,80007388 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000736c:	ff0fd0ef          	jal	80004b5c <iunlockput>
  end_op();
    80007370:	a74fe0ef          	jal	800055e4 <end_op>
  return 0;
    80007374:	00000513          	li	a0,0
}
    80007378:	09813083          	ld	ra,152(sp)
    8000737c:	09013403          	ld	s0,144(sp)
    80007380:	0a010113          	addi	sp,sp,160
    80007384:	00008067          	ret
    end_op();
    80007388:	a5cfe0ef          	jal	800055e4 <end_op>
    return -1;
    8000738c:	fff00513          	li	a0,-1
    80007390:	fe9ff06f          	j	80007378 <sys_mknod+0x64>

0000000080007394 <sys_chdir>:

uint64
sys_chdir(void)
{
    80007394:	f6010113          	addi	sp,sp,-160
    80007398:	08113c23          	sd	ra,152(sp)
    8000739c:	08813823          	sd	s0,144(sp)
    800073a0:	09213023          	sd	s2,128(sp)
    800073a4:	0a010413          	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800073a8:	8b4fb0ef          	jal	8000245c <myproc>
    800073ac:	00050913          	mv	s2,a0
  
  begin_op();
    800073b0:	994fe0ef          	jal	80005544 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800073b4:	08000613          	li	a2,128
    800073b8:	f6040593          	addi	a1,s0,-160
    800073bc:	00000513          	li	a0,0
    800073c0:	e90fc0ef          	jal	80003a50 <argstr>
    800073c4:	06054063          	bltz	a0,80007424 <sys_chdir+0x90>
    800073c8:	08913423          	sd	s1,136(sp)
    800073cc:	f6040513          	addi	a0,s0,-160
    800073d0:	ee5fd0ef          	jal	800052b4 <namei>
    800073d4:	00050493          	mv	s1,a0
    800073d8:	04050463          	beqz	a0,80007420 <sys_chdir+0x8c>
    end_op();
    return -1;
  }
  ilock(ip);
    800073dc:	c98fd0ef          	jal	80004874 <ilock>
  if(ip->type != T_DIR){
    800073e0:	04449703          	lh	a4,68(s1)
    800073e4:	00100793          	li	a5,1
    800073e8:	04f71463          	bne	a4,a5,80007430 <sys_chdir+0x9c>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800073ec:	00048513          	mv	a0,s1
    800073f0:	d78fd0ef          	jal	80004968 <iunlock>
  iput(p->cwd);
    800073f4:	15093503          	ld	a0,336(s2)
    800073f8:	ea8fd0ef          	jal	80004aa0 <iput>
  end_op();
    800073fc:	9e8fe0ef          	jal	800055e4 <end_op>
  p->cwd = ip;
    80007400:	14993823          	sd	s1,336(s2)
  return 0;
    80007404:	00000513          	li	a0,0
    80007408:	08813483          	ld	s1,136(sp)
}
    8000740c:	09813083          	ld	ra,152(sp)
    80007410:	09013403          	ld	s0,144(sp)
    80007414:	08013903          	ld	s2,128(sp)
    80007418:	0a010113          	addi	sp,sp,160
    8000741c:	00008067          	ret
    80007420:	08813483          	ld	s1,136(sp)
    end_op();
    80007424:	9c0fe0ef          	jal	800055e4 <end_op>
    return -1;
    80007428:	fff00513          	li	a0,-1
    8000742c:	fe1ff06f          	j	8000740c <sys_chdir+0x78>
    iunlockput(ip);
    80007430:	00048513          	mv	a0,s1
    80007434:	f28fd0ef          	jal	80004b5c <iunlockput>
    end_op();
    80007438:	9acfe0ef          	jal	800055e4 <end_op>
    return -1;
    8000743c:	fff00513          	li	a0,-1
    80007440:	08813483          	ld	s1,136(sp)
    80007444:	fc9ff06f          	j	8000740c <sys_chdir+0x78>

0000000080007448 <sys_exec>:

uint64
sys_exec(void)
{
    80007448:	e4010113          	addi	sp,sp,-448
    8000744c:	1a113c23          	sd	ra,440(sp)
    80007450:	1a813823          	sd	s0,432(sp)
    80007454:	1c010413          	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80007458:	e4840593          	addi	a1,s0,-440
    8000745c:	00100513          	li	a0,1
    80007460:	dbcfc0ef          	jal	80003a1c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80007464:	08000613          	li	a2,128
    80007468:	f5040593          	addi	a1,s0,-176
    8000746c:	00000513          	li	a0,0
    80007470:	de0fc0ef          	jal	80003a50 <argstr>
    80007474:	00050793          	mv	a5,a0
    return -1;
    80007478:	fff00513          	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000747c:	1007cc63          	bltz	a5,80007594 <sys_exec+0x14c>
    80007480:	1a913423          	sd	s1,424(sp)
    80007484:	1b213023          	sd	s2,416(sp)
    80007488:	19313c23          	sd	s3,408(sp)
    8000748c:	19413823          	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80007490:	10000613          	li	a2,256
    80007494:	00000593          	li	a1,0
    80007498:	e5040513          	addi	a0,s0,-432
    8000749c:	cddf90ef          	jal	80001178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800074a0:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800074a4:	00048993          	mv	s3,s1
    800074a8:	00000913          	li	s2,0
    if(i >= NELEM(argv)){
    800074ac:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800074b0:	00391513          	slli	a0,s2,0x3
    800074b4:	e4040593          	addi	a1,s0,-448
    800074b8:	e4843783          	ld	a5,-440(s0)
    800074bc:	00f50533          	add	a0,a0,a5
    800074c0:	c40fc0ef          	jal	80003900 <fetchaddr>
    800074c4:	02054c63          	bltz	a0,800074fc <sys_exec+0xb4>
      goto bad;
    }
    if(uarg == 0){
    800074c8:	e4043783          	ld	a5,-448(s0)
    800074cc:	06078063          	beqz	a5,8000752c <sys_exec+0xe4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800074d0:	a2df90ef          	jal	80000efc <kalloc>
    800074d4:	00050593          	mv	a1,a0
    800074d8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800074dc:	02050063          	beqz	a0,800074fc <sys_exec+0xb4>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800074e0:	00001637          	lui	a2,0x1
    800074e4:	e4043503          	ld	a0,-448(s0)
    800074e8:	c90fc0ef          	jal	80003978 <fetchstr>
    800074ec:	00054863          	bltz	a0,800074fc <sys_exec+0xb4>
    if(i >= NELEM(argv)){
    800074f0:	00190913          	addi	s2,s2,1
    800074f4:	00898993          	addi	s3,s3,8
    800074f8:	fb491ce3          	bne	s2,s4,800074b0 <sys_exec+0x68>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800074fc:	f5040913          	addi	s2,s0,-176
    80007500:	0004b503          	ld	a0,0(s1)
    80007504:	06050e63          	beqz	a0,80007580 <sys_exec+0x138>
    kfree(argv[i]);
    80007508:	8a5f90ef          	jal	80000dac <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000750c:	00848493          	addi	s1,s1,8
    80007510:	ff2498e3          	bne	s1,s2,80007500 <sys_exec+0xb8>
  return -1;
    80007514:	fff00513          	li	a0,-1
    80007518:	1a813483          	ld	s1,424(sp)
    8000751c:	1a013903          	ld	s2,416(sp)
    80007520:	19813983          	ld	s3,408(sp)
    80007524:	19013a03          	ld	s4,400(sp)
    80007528:	06c0006f          	j	80007594 <sys_exec+0x14c>
      argv[i] = 0;
    8000752c:	0009079b          	sext.w	a5,s2
    80007530:	00379793          	slli	a5,a5,0x3
    80007534:	fd078793          	addi	a5,a5,-48
    80007538:	008787b3          	add	a5,a5,s0
    8000753c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80007540:	e5040593          	addi	a1,s0,-432
    80007544:	f5040513          	addi	a0,s0,-176
    80007548:	eddfe0ef          	jal	80006424 <exec>
    8000754c:	00050913          	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007550:	f5040993          	addi	s3,s0,-176
    80007554:	0004b503          	ld	a0,0(s1)
    80007558:	00050863          	beqz	a0,80007568 <sys_exec+0x120>
    kfree(argv[i]);
    8000755c:	851f90ef          	jal	80000dac <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007560:	00848493          	addi	s1,s1,8
    80007564:	ff3498e3          	bne	s1,s3,80007554 <sys_exec+0x10c>
  return ret;
    80007568:	00090513          	mv	a0,s2
    8000756c:	1a813483          	ld	s1,424(sp)
    80007570:	1a013903          	ld	s2,416(sp)
    80007574:	19813983          	ld	s3,408(sp)
    80007578:	19013a03          	ld	s4,400(sp)
    8000757c:	0180006f          	j	80007594 <sys_exec+0x14c>
  return -1;
    80007580:	fff00513          	li	a0,-1
    80007584:	1a813483          	ld	s1,424(sp)
    80007588:	1a013903          	ld	s2,416(sp)
    8000758c:	19813983          	ld	s3,408(sp)
    80007590:	19013a03          	ld	s4,400(sp)
}
    80007594:	1b813083          	ld	ra,440(sp)
    80007598:	1b013403          	ld	s0,432(sp)
    8000759c:	1c010113          	addi	sp,sp,448
    800075a0:	00008067          	ret

00000000800075a4 <sys_pipe>:

uint64
sys_pipe(void)
{
    800075a4:	fc010113          	addi	sp,sp,-64
    800075a8:	02113c23          	sd	ra,56(sp)
    800075ac:	02813823          	sd	s0,48(sp)
    800075b0:	02913423          	sd	s1,40(sp)
    800075b4:	04010413          	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800075b8:	ea5fa0ef          	jal	8000245c <myproc>
    800075bc:	00050493          	mv	s1,a0

  argaddr(0, &fdarray);
    800075c0:	fd840593          	addi	a1,s0,-40
    800075c4:	00000513          	li	a0,0
    800075c8:	c54fc0ef          	jal	80003a1c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800075cc:	fc840593          	addi	a1,s0,-56
    800075d0:	fd040513          	addi	a0,s0,-48
    800075d4:	9f9fe0ef          	jal	80005fcc <pipealloc>
    return -1;
    800075d8:	fff00793          	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800075dc:	0c054663          	bltz	a0,800076a8 <sys_pipe+0x104>
  fd0 = -1;
    800075e0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800075e4:	fd043503          	ld	a0,-48(s0)
    800075e8:	b74ff0ef          	jal	8000695c <fdalloc>
    800075ec:	fca42223          	sw	a0,-60(s0)
    800075f0:	0a054263          	bltz	a0,80007694 <sys_pipe+0xf0>
    800075f4:	fc843503          	ld	a0,-56(s0)
    800075f8:	b64ff0ef          	jal	8000695c <fdalloc>
    800075fc:	fca42023          	sw	a0,-64(s0)
    80007600:	06054e63          	bltz	a0,8000767c <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80007604:	00400693          	li	a3,4
    80007608:	fc440613          	addi	a2,s0,-60
    8000760c:	fd843583          	ld	a1,-40(s0)
    80007610:	0504b503          	ld	a0,80(s1)
    80007614:	8a1fa0ef          	jal	80001eb4 <copyout>
    80007618:	02054263          	bltz	a0,8000763c <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000761c:	00400693          	li	a3,4
    80007620:	fc040613          	addi	a2,s0,-64
    80007624:	fd843583          	ld	a1,-40(s0)
    80007628:	00458593          	addi	a1,a1,4
    8000762c:	0504b503          	ld	a0,80(s1)
    80007630:	885fa0ef          	jal	80001eb4 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80007634:	00000793          	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80007638:	06055863          	bgez	a0,800076a8 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000763c:	fc442783          	lw	a5,-60(s0)
    80007640:	01a78793          	addi	a5,a5,26
    80007644:	00379793          	slli	a5,a5,0x3
    80007648:	00f487b3          	add	a5,s1,a5
    8000764c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80007650:	fc042783          	lw	a5,-64(s0)
    80007654:	01a78793          	addi	a5,a5,26
    80007658:	00379793          	slli	a5,a5,0x3
    8000765c:	00f484b3          	add	s1,s1,a5
    80007660:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80007664:	fd043503          	ld	a0,-48(s0)
    80007668:	cc0fe0ef          	jal	80005b28 <fileclose>
    fileclose(wf);
    8000766c:	fc843503          	ld	a0,-56(s0)
    80007670:	cb8fe0ef          	jal	80005b28 <fileclose>
    return -1;
    80007674:	fff00793          	li	a5,-1
    80007678:	0300006f          	j	800076a8 <sys_pipe+0x104>
    if(fd0 >= 0)
    8000767c:	fc442783          	lw	a5,-60(s0)
    80007680:	0007ca63          	bltz	a5,80007694 <sys_pipe+0xf0>
      p->ofile[fd0] = 0;
    80007684:	01a78793          	addi	a5,a5,26
    80007688:	00379793          	slli	a5,a5,0x3
    8000768c:	00f487b3          	add	a5,s1,a5
    80007690:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80007694:	fd043503          	ld	a0,-48(s0)
    80007698:	c90fe0ef          	jal	80005b28 <fileclose>
    fileclose(wf);
    8000769c:	fc843503          	ld	a0,-56(s0)
    800076a0:	c88fe0ef          	jal	80005b28 <fileclose>
    return -1;
    800076a4:	fff00793          	li	a5,-1
}
    800076a8:	00078513          	mv	a0,a5
    800076ac:	03813083          	ld	ra,56(sp)
    800076b0:	03013403          	ld	s0,48(sp)
    800076b4:	02813483          	ld	s1,40(sp)
    800076b8:	04010113          	addi	sp,sp,64
    800076bc:	00008067          	ret

00000000800076c0 <kernelvec>:
    800076c0:	7111                	addi	sp,sp,-256
    800076c2:	e006                	sd	ra,0(sp)
    800076c4:	e40a                	sd	sp,8(sp)
    800076c6:	e80e                	sd	gp,16(sp)
    800076c8:	ec12                	sd	tp,24(sp)
    800076ca:	f016                	sd	t0,32(sp)
    800076cc:	f41a                	sd	t1,40(sp)
    800076ce:	f81e                	sd	t2,48(sp)
    800076d0:	e4aa                	sd	a0,72(sp)
    800076d2:	e8ae                	sd	a1,80(sp)
    800076d4:	ecb2                	sd	a2,88(sp)
    800076d6:	f0b6                	sd	a3,96(sp)
    800076d8:	f4ba                	sd	a4,104(sp)
    800076da:	f8be                	sd	a5,112(sp)
    800076dc:	fcc2                	sd	a6,120(sp)
    800076de:	e146                	sd	a7,128(sp)
    800076e0:	edf2                	sd	t3,216(sp)
    800076e2:	f1f6                	sd	t4,224(sp)
    800076e4:	f5fa                	sd	t5,232(sp)
    800076e6:	f9fe                	sd	t6,240(sp)
    800076e8:	8b8fc0ef          	jal	800037a0 <kerneltrap>
    800076ec:	6082                	ld	ra,0(sp)
    800076ee:	6122                	ld	sp,8(sp)
    800076f0:	61c2                	ld	gp,16(sp)
    800076f2:	7282                	ld	t0,32(sp)
    800076f4:	7322                	ld	t1,40(sp)
    800076f6:	73c2                	ld	t2,48(sp)
    800076f8:	6526                	ld	a0,72(sp)
    800076fa:	65c6                	ld	a1,80(sp)
    800076fc:	6666                	ld	a2,88(sp)
    800076fe:	7686                	ld	a3,96(sp)
    80007700:	7726                	ld	a4,104(sp)
    80007702:	77c6                	ld	a5,112(sp)
    80007704:	7866                	ld	a6,120(sp)
    80007706:	688a                	ld	a7,128(sp)
    80007708:	6e6e                	ld	t3,216(sp)
    8000770a:	7e8e                	ld	t4,224(sp)
    8000770c:	7f2e                	ld	t5,232(sp)
    8000770e:	7fce                	ld	t6,240(sp)
    80007710:	6111                	addi	sp,sp,256
    80007712:	10200073          	sret
	...

0000000080007720 <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80007720:	ff010113          	addi	sp,sp,-16
    80007724:	00813423          	sd	s0,8(sp)
    80007728:	01010413          	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    8000772c:	0c0007b7          	lui	a5,0xc000
    80007730:	00100713          	li	a4,1
    80007734:	02e7a423          	sw	a4,40(a5) # c000028 <_entry-0x73ffffd8>
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80007738:	0c0007b7          	lui	a5,0xc000
    8000773c:	00e7a223          	sw	a4,4(a5) # c000004 <_entry-0x73fffffc>
}
    80007740:	00813403          	ld	s0,8(sp)
    80007744:	01010113          	addi	sp,sp,16
    80007748:	00008067          	ret

000000008000774c <plicinithart>:

void
plicinithart(void)
{
    8000774c:	ff010113          	addi	sp,sp,-16
    80007750:	00113423          	sd	ra,8(sp)
    80007754:	00813023          	sd	s0,0(sp)
    80007758:	01010413          	addi	s0,sp,16
  int hart = cpuid();
    8000775c:	cb1fa0ef          	jal	8000240c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80007760:	0085171b          	slliw	a4,a0,0x8
    80007764:	0c0027b7          	lui	a5,0xc002
    80007768:	00e787b3          	add	a5,a5,a4
    8000776c:	40200713          	li	a4,1026
    80007770:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80007774:	00d5151b          	slliw	a0,a0,0xd
    80007778:	0c2017b7          	lui	a5,0xc201
    8000777c:	00a787b3          	add	a5,a5,a0
    80007780:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80007784:	00813083          	ld	ra,8(sp)
    80007788:	00013403          	ld	s0,0(sp)
    8000778c:	01010113          	addi	sp,sp,16
    80007790:	00008067          	ret

0000000080007794 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80007794:	ff010113          	addi	sp,sp,-16
    80007798:	00113423          	sd	ra,8(sp)
    8000779c:	00813023          	sd	s0,0(sp)
    800077a0:	01010413          	addi	s0,sp,16
  int hart = cpuid();
    800077a4:	c69fa0ef          	jal	8000240c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800077a8:	00d5151b          	slliw	a0,a0,0xd
    800077ac:	0c2017b7          	lui	a5,0xc201
    800077b0:	00a787b3          	add	a5,a5,a0
  return irq;
}
    800077b4:	0047a503          	lw	a0,4(a5) # c201004 <_entry-0x73dfeffc>
    800077b8:	00813083          	ld	ra,8(sp)
    800077bc:	00013403          	ld	s0,0(sp)
    800077c0:	01010113          	addi	sp,sp,16
    800077c4:	00008067          	ret

00000000800077c8 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800077c8:	fe010113          	addi	sp,sp,-32
    800077cc:	00113c23          	sd	ra,24(sp)
    800077d0:	00813823          	sd	s0,16(sp)
    800077d4:	00913423          	sd	s1,8(sp)
    800077d8:	02010413          	addi	s0,sp,32
    800077dc:	00050493          	mv	s1,a0
  int hart = cpuid();
    800077e0:	c2dfa0ef          	jal	8000240c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800077e4:	00d5151b          	slliw	a0,a0,0xd
    800077e8:	0c2017b7          	lui	a5,0xc201
    800077ec:	00a787b3          	add	a5,a5,a0
    800077f0:	0097a223          	sw	s1,4(a5) # c201004 <_entry-0x73dfeffc>
}
    800077f4:	01813083          	ld	ra,24(sp)
    800077f8:	01013403          	ld	s0,16(sp)
    800077fc:	00813483          	ld	s1,8(sp)
    80007800:	02010113          	addi	sp,sp,32
    80007804:	00008067          	ret

0000000080007808 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80007808:	ff010113          	addi	sp,sp,-16
    8000780c:	00113423          	sd	ra,8(sp)
    80007810:	00813023          	sd	s0,0(sp)
    80007814:	01010413          	addi	s0,sp,16
  if(i >= NUM)
    80007818:	00700793          	li	a5,7
    8000781c:	06a7c663          	blt	a5,a0,80007888 <free_desc+0x80>
    panic("free_desc 1");
  if(disk.free[i])
    80007820:	0001b797          	auipc	a5,0x1b
    80007824:	2e078793          	addi	a5,a5,736 # 80022b00 <disk>
    80007828:	00a787b3          	add	a5,a5,a0
    8000782c:	0187c783          	lbu	a5,24(a5)
    80007830:	06079263          	bnez	a5,80007894 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80007834:	00451693          	slli	a3,a0,0x4
    80007838:	0001b797          	auipc	a5,0x1b
    8000783c:	2c878793          	addi	a5,a5,712 # 80022b00 <disk>
    80007840:	0007b703          	ld	a4,0(a5)
    80007844:	00d70733          	add	a4,a4,a3
    80007848:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000784c:	0007b703          	ld	a4,0(a5)
    80007850:	00d70733          	add	a4,a4,a3
    80007854:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80007858:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000785c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80007860:	00a787b3          	add	a5,a5,a0
    80007864:	00100713          	li	a4,1
    80007868:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000786c:	0001b517          	auipc	a0,0x1b
    80007870:	2ac50513          	addi	a0,a0,684 # 80022b18 <disk+0x18>
    80007874:	cdcfb0ef          	jal	80002d50 <wakeup>
}
    80007878:	00813083          	ld	ra,8(sp)
    8000787c:	00013403          	ld	s0,0(sp)
    80007880:	01010113          	addi	sp,sp,16
    80007884:	00008067          	ret
    panic("free_desc 1");
    80007888:	00002517          	auipc	a0,0x2
    8000788c:	de850513          	addi	a0,a0,-536 # 80009670 <etext+0x670>
    80007890:	970f90ef          	jal	80000a00 <panic>
    panic("free_desc 2");
    80007894:	00002517          	auipc	a0,0x2
    80007898:	dec50513          	addi	a0,a0,-532 # 80009680 <etext+0x680>
    8000789c:	964f90ef          	jal	80000a00 <panic>

00000000800078a0 <virtio_disk_init>:
{
    800078a0:	fe010113          	addi	sp,sp,-32
    800078a4:	00113c23          	sd	ra,24(sp)
    800078a8:	00813823          	sd	s0,16(sp)
    800078ac:	00913423          	sd	s1,8(sp)
    800078b0:	01213023          	sd	s2,0(sp)
    800078b4:	02010413          	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800078b8:	00002597          	auipc	a1,0x2
    800078bc:	dd858593          	addi	a1,a1,-552 # 80009690 <etext+0x690>
    800078c0:	0001b517          	auipc	a0,0x1b
    800078c4:	36850513          	addi	a0,a0,872 # 80022c28 <disk+0x128>
    800078c8:	eacf90ef          	jal	80000f74 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800078cc:	100017b7          	lui	a5,0x10001
    800078d0:	0007a703          	lw	a4,0(a5) # 10001000 <_entry-0x6ffff000>
    800078d4:	0007071b          	sext.w	a4,a4
    800078d8:	747277b7          	lui	a5,0x74727
    800078dc:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800078e0:	1ef71663          	bne	a4,a5,80007acc <virtio_disk_init+0x22c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800078e4:	100017b7          	lui	a5,0x10001
    800078e8:	00478793          	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800078ec:	0007a783          	lw	a5,0(a5)
    800078f0:	0007879b          	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800078f4:	00200713          	li	a4,2
    800078f8:	1ce79a63          	bne	a5,a4,80007acc <virtio_disk_init+0x22c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800078fc:	100017b7          	lui	a5,0x10001
    80007900:	00878793          	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80007904:	0007a783          	lw	a5,0(a5)
    80007908:	0007879b          	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000790c:	1ce79063          	bne	a5,a4,80007acc <virtio_disk_init+0x22c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80007910:	100017b7          	lui	a5,0x10001
    80007914:	00c7a703          	lw	a4,12(a5) # 1000100c <_entry-0x6fffeff4>
    80007918:	0007071b          	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000791c:	554d47b7          	lui	a5,0x554d4
    80007920:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80007924:	1af71463          	bne	a4,a5,80007acc <virtio_disk_init+0x22c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80007928:	100017b7          	lui	a5,0x10001
    8000792c:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80007930:	00100713          	li	a4,1
    80007934:	06e7a823          	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80007938:	00300713          	li	a4,3
    8000793c:	06e7a823          	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80007940:	10001737          	lui	a4,0x10001
    80007944:	01072683          	lw	a3,16(a4) # 10001010 <_entry-0x6fffeff0>
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80007948:	c7ffe737          	lui	a4,0xc7ffe
    8000794c:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdbb1f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80007950:	00e6f6b3          	and	a3,a3,a4
    80007954:	10001737          	lui	a4,0x10001
    80007958:	02d72023          	sw	a3,32(a4) # 10001020 <_entry-0x6fffefe0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000795c:	00b00713          	li	a4,11
    80007960:	06e7a823          	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80007964:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80007968:	0007a783          	lw	a5,0(a5)
    8000796c:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80007970:	0087f793          	andi	a5,a5,8
    80007974:	16078263          	beqz	a5,80007ad8 <virtio_disk_init+0x238>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80007978:	100017b7          	lui	a5,0x10001
    8000797c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80007980:	100017b7          	lui	a5,0x10001
    80007984:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80007988:	0007a783          	lw	a5,0(a5)
    8000798c:	0007879b          	sext.w	a5,a5
    80007990:	14079a63          	bnez	a5,80007ae4 <virtio_disk_init+0x244>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80007994:	100017b7          	lui	a5,0x10001
    80007998:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000799c:	0007a783          	lw	a5,0(a5)
    800079a0:	0007879b          	sext.w	a5,a5
  if(max == 0)
    800079a4:	14078663          	beqz	a5,80007af0 <virtio_disk_init+0x250>
  if(max < NUM)
    800079a8:	00700713          	li	a4,7
    800079ac:	14f77863          	bgeu	a4,a5,80007afc <virtio_disk_init+0x25c>
  disk.desc = kalloc();
    800079b0:	d4cf90ef          	jal	80000efc <kalloc>
    800079b4:	0001b497          	auipc	s1,0x1b
    800079b8:	14c48493          	addi	s1,s1,332 # 80022b00 <disk>
    800079bc:	00a4b023          	sd	a0,0(s1)
  disk.avail = kalloc();
    800079c0:	d3cf90ef          	jal	80000efc <kalloc>
    800079c4:	00a4b423          	sd	a0,8(s1)
  disk.used = kalloc();
    800079c8:	d34f90ef          	jal	80000efc <kalloc>
    800079cc:	00050793          	mv	a5,a0
    800079d0:	00a4b823          	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800079d4:	0004b503          	ld	a0,0(s1)
    800079d8:	12050863          	beqz	a0,80007b08 <virtio_disk_init+0x268>
    800079dc:	0001b717          	auipc	a4,0x1b
    800079e0:	12c73703          	ld	a4,300(a4) # 80022b08 <disk+0x8>
    800079e4:	12070263          	beqz	a4,80007b08 <virtio_disk_init+0x268>
    800079e8:	12078063          	beqz	a5,80007b08 <virtio_disk_init+0x268>
  memset(disk.desc, 0, PGSIZE);
    800079ec:	00001637          	lui	a2,0x1
    800079f0:	00000593          	li	a1,0
    800079f4:	f84f90ef          	jal	80001178 <memset>
  memset(disk.avail, 0, PGSIZE);
    800079f8:	0001b497          	auipc	s1,0x1b
    800079fc:	10848493          	addi	s1,s1,264 # 80022b00 <disk>
    80007a00:	00001637          	lui	a2,0x1
    80007a04:	00000593          	li	a1,0
    80007a08:	0084b503          	ld	a0,8(s1)
    80007a0c:	f6cf90ef          	jal	80001178 <memset>
  memset(disk.used, 0, PGSIZE);
    80007a10:	00001637          	lui	a2,0x1
    80007a14:	00000593          	li	a1,0
    80007a18:	0104b503          	ld	a0,16(s1)
    80007a1c:	f5cf90ef          	jal	80001178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80007a20:	100017b7          	lui	a5,0x10001
    80007a24:	00800713          	li	a4,8
    80007a28:	02e7ac23          	sw	a4,56(a5) # 10001038 <_entry-0x6fffefc8>
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80007a2c:	0004a703          	lw	a4,0(s1)
    80007a30:	100017b7          	lui	a5,0x10001
    80007a34:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80007a38:	0044a703          	lw	a4,4(s1)
    80007a3c:	100017b7          	lui	a5,0x10001
    80007a40:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80007a44:	0084b783          	ld	a5,8(s1)
    80007a48:	0007869b          	sext.w	a3,a5
    80007a4c:	10001737          	lui	a4,0x10001
    80007a50:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80007a54:	4207d793          	srai	a5,a5,0x20
    80007a58:	10001737          	lui	a4,0x10001
    80007a5c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80007a60:	0104b783          	ld	a5,16(s1)
    80007a64:	0007869b          	sext.w	a3,a5
    80007a68:	10001737          	lui	a4,0x10001
    80007a6c:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80007a70:	4207d793          	srai	a5,a5,0x20
    80007a74:	10001737          	lui	a4,0x10001
    80007a78:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80007a7c:	10001737          	lui	a4,0x10001
    80007a80:	00100793          	li	a5,1
    80007a84:	04f72223          	sw	a5,68(a4) # 10001044 <_entry-0x6fffefbc>
    disk.free[i] = 1;
    80007a88:	00f48c23          	sb	a5,24(s1)
    80007a8c:	00f48ca3          	sb	a5,25(s1)
    80007a90:	00f48d23          	sb	a5,26(s1)
    80007a94:	00f48da3          	sb	a5,27(s1)
    80007a98:	00f48e23          	sb	a5,28(s1)
    80007a9c:	00f48ea3          	sb	a5,29(s1)
    80007aa0:	00f48f23          	sb	a5,30(s1)
    80007aa4:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80007aa8:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80007aac:	100017b7          	lui	a5,0x10001
    80007ab0:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80007ab4:	01813083          	ld	ra,24(sp)
    80007ab8:	01013403          	ld	s0,16(sp)
    80007abc:	00813483          	ld	s1,8(sp)
    80007ac0:	00013903          	ld	s2,0(sp)
    80007ac4:	02010113          	addi	sp,sp,32
    80007ac8:	00008067          	ret
    panic("could not find virtio disk");
    80007acc:	00002517          	auipc	a0,0x2
    80007ad0:	bd450513          	addi	a0,a0,-1068 # 800096a0 <etext+0x6a0>
    80007ad4:	f2df80ef          	jal	80000a00 <panic>
    panic("virtio disk FEATURES_OK unset");
    80007ad8:	00002517          	auipc	a0,0x2
    80007adc:	be850513          	addi	a0,a0,-1048 # 800096c0 <etext+0x6c0>
    80007ae0:	f21f80ef          	jal	80000a00 <panic>
    panic("virtio disk should not be ready");
    80007ae4:	00002517          	auipc	a0,0x2
    80007ae8:	bfc50513          	addi	a0,a0,-1028 # 800096e0 <etext+0x6e0>
    80007aec:	f15f80ef          	jal	80000a00 <panic>
    panic("virtio disk has no queue 0");
    80007af0:	00002517          	auipc	a0,0x2
    80007af4:	c1050513          	addi	a0,a0,-1008 # 80009700 <etext+0x700>
    80007af8:	f09f80ef          	jal	80000a00 <panic>
    panic("virtio disk max queue too short");
    80007afc:	00002517          	auipc	a0,0x2
    80007b00:	c2450513          	addi	a0,a0,-988 # 80009720 <etext+0x720>
    80007b04:	efdf80ef          	jal	80000a00 <panic>
    panic("virtio disk kalloc");
    80007b08:	00002517          	auipc	a0,0x2
    80007b0c:	c3850513          	addi	a0,a0,-968 # 80009740 <etext+0x740>
    80007b10:	ef1f80ef          	jal	80000a00 <panic>

0000000080007b14 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80007b14:	f9010113          	addi	sp,sp,-112
    80007b18:	06113423          	sd	ra,104(sp)
    80007b1c:	06813023          	sd	s0,96(sp)
    80007b20:	04913c23          	sd	s1,88(sp)
    80007b24:	05213823          	sd	s2,80(sp)
    80007b28:	05313423          	sd	s3,72(sp)
    80007b2c:	05413023          	sd	s4,64(sp)
    80007b30:	03513c23          	sd	s5,56(sp)
    80007b34:	03613823          	sd	s6,48(sp)
    80007b38:	03713423          	sd	s7,40(sp)
    80007b3c:	03813023          	sd	s8,32(sp)
    80007b40:	01913c23          	sd	s9,24(sp)
    80007b44:	07010413          	addi	s0,sp,112
    80007b48:	00050a13          	mv	s4,a0
    80007b4c:	00058b93          	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80007b50:	00c52c83          	lw	s9,12(a0)
    80007b54:	001c9c9b          	slliw	s9,s9,0x1
    80007b58:	020c9c93          	slli	s9,s9,0x20
    80007b5c:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80007b60:	0001b517          	auipc	a0,0x1b
    80007b64:	0c850513          	addi	a0,a0,200 # 80022c28 <disk+0x128>
    80007b68:	ce0f90ef          	jal	80001048 <acquire>
  for(int i = 0; i < 3; i++){
    80007b6c:	00000993          	li	s3,0
  for(int i = 0; i < NUM; i++){
    80007b70:	00800493          	li	s1,8
      disk.free[i] = 0;
    80007b74:	0001bb17          	auipc	s6,0x1b
    80007b78:	f8cb0b13          	addi	s6,s6,-116 # 80022b00 <disk>
  for(int i = 0; i < 3; i++){
    80007b7c:	00300a93          	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80007b80:	0001bc17          	auipc	s8,0x1b
    80007b84:	0a8c0c13          	addi	s8,s8,168 # 80022c28 <disk+0x128>
    80007b88:	0780006f          	j	80007c00 <virtio_disk_rw+0xec>
      disk.free[i] = 0;
    80007b8c:	00fb0733          	add	a4,s6,a5
    80007b90:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80007b94:	00f5a023          	sw	a5,0(a1)
    if(idx[i] < 0){
    80007b98:	0207ce63          	bltz	a5,80007bd4 <virtio_disk_rw+0xc0>
  for(int i = 0; i < 3; i++){
    80007b9c:	0019091b          	addiw	s2,s2,1
    80007ba0:	00460613          	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80007ba4:	07590463          	beq	s2,s5,80007c0c <virtio_disk_rw+0xf8>
    idx[i] = alloc_desc();
    80007ba8:	00060593          	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80007bac:	0001b717          	auipc	a4,0x1b
    80007bb0:	f5470713          	addi	a4,a4,-172 # 80022b00 <disk>
    80007bb4:	00098793          	mv	a5,s3
    if(disk.free[i]){
    80007bb8:	01874683          	lbu	a3,24(a4)
    80007bbc:	fc0698e3          	bnez	a3,80007b8c <virtio_disk_rw+0x78>
  for(int i = 0; i < NUM; i++){
    80007bc0:	0017879b          	addiw	a5,a5,1
    80007bc4:	00170713          	addi	a4,a4,1
    80007bc8:	fe9798e3          	bne	a5,s1,80007bb8 <virtio_disk_rw+0xa4>
    idx[i] = alloc_desc();
    80007bcc:	fff00793          	li	a5,-1
    80007bd0:	00f5a023          	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80007bd4:	01205e63          	blez	s2,80007bf0 <virtio_disk_rw+0xdc>
        free_desc(idx[j]);
    80007bd8:	f9042503          	lw	a0,-112(s0)
    80007bdc:	c2dff0ef          	jal	80007808 <free_desc>
      for(int j = 0; j < i; j++)
    80007be0:	00100793          	li	a5,1
    80007be4:	0127d663          	bge	a5,s2,80007bf0 <virtio_disk_rw+0xdc>
        free_desc(idx[j]);
    80007be8:	f9442503          	lw	a0,-108(s0)
    80007bec:	c1dff0ef          	jal	80007808 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80007bf0:	000c0593          	mv	a1,s8
    80007bf4:	0001b517          	auipc	a0,0x1b
    80007bf8:	f2450513          	addi	a0,a0,-220 # 80022b18 <disk+0x18>
    80007bfc:	8dcfb0ef          	jal	80002cd8 <sleep>
  for(int i = 0; i < 3; i++){
    80007c00:	f9040613          	addi	a2,s0,-112
    80007c04:	00098913          	mv	s2,s3
    80007c08:	fa1ff06f          	j	80007ba8 <virtio_disk_rw+0x94>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80007c0c:	f9042503          	lw	a0,-112(s0)
    80007c10:	00451693          	slli	a3,a0,0x4

  if(write)
    80007c14:	0001b797          	auipc	a5,0x1b
    80007c18:	eec78793          	addi	a5,a5,-276 # 80022b00 <disk>
    80007c1c:	00a50713          	addi	a4,a0,10
    80007c20:	00471713          	slli	a4,a4,0x4
    80007c24:	00e78733          	add	a4,a5,a4
    80007c28:	01703633          	snez	a2,s7
    80007c2c:	00c72423          	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80007c30:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80007c34:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80007c38:	0007b703          	ld	a4,0(a5)
    80007c3c:	00d70733          	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80007c40:	0a868613          	addi	a2,a3,168
    80007c44:	00c78633          	add	a2,a5,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80007c48:	00c73023          	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80007c4c:	0007b603          	ld	a2,0(a5)
    80007c50:	00d605b3          	add	a1,a2,a3
    80007c54:	01000713          	li	a4,16
    80007c58:	00e5a423          	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80007c5c:	00100813          	li	a6,1
    80007c60:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80007c64:	f9442703          	lw	a4,-108(s0)
    80007c68:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80007c6c:	00471713          	slli	a4,a4,0x4
    80007c70:	00e60633          	add	a2,a2,a4
    80007c74:	058a0593          	addi	a1,s4,88
    80007c78:	00b63023          	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80007c7c:	0007b883          	ld	a7,0(a5)
    80007c80:	00e88733          	add	a4,a7,a4
    80007c84:	40000613          	li	a2,1024
    80007c88:	00c72423          	sw	a2,8(a4)
  if(write)
    80007c8c:	001bb613          	seqz	a2,s7
    80007c90:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80007c94:	00166613          	ori	a2,a2,1
    80007c98:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80007c9c:	f9842583          	lw	a1,-104(s0)
    80007ca0:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80007ca4:	00250613          	addi	a2,a0,2
    80007ca8:	00461613          	slli	a2,a2,0x4
    80007cac:	00c78633          	add	a2,a5,a2
    80007cb0:	fff00713          	li	a4,-1
    80007cb4:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80007cb8:	00459593          	slli	a1,a1,0x4
    80007cbc:	00b888b3          	add	a7,a7,a1
    80007cc0:	03068713          	addi	a4,a3,48
    80007cc4:	00e78733          	add	a4,a5,a4
    80007cc8:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80007ccc:	0007b703          	ld	a4,0(a5)
    80007cd0:	00b70733          	add	a4,a4,a1
    80007cd4:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80007cd8:	00200693          	li	a3,2
    80007cdc:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80007ce0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80007ce4:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80007ce8:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80007cec:	0087b683          	ld	a3,8(a5)
    80007cf0:	0026d703          	lhu	a4,2(a3)
    80007cf4:	00777713          	andi	a4,a4,7
    80007cf8:	00171713          	slli	a4,a4,0x1
    80007cfc:	00e686b3          	add	a3,a3,a4
    80007d00:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80007d04:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80007d08:	0087b703          	ld	a4,8(a5)
    80007d0c:	00275783          	lhu	a5,2(a4)
    80007d10:	0017879b          	addiw	a5,a5,1
    80007d14:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80007d18:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80007d1c:	100017b7          	lui	a5,0x10001
    80007d20:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80007d24:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80007d28:	0001b917          	auipc	s2,0x1b
    80007d2c:	f0090913          	addi	s2,s2,-256 # 80022c28 <disk+0x128>
  while(b->disk == 1) {
    80007d30:	00100493          	li	s1,1
    80007d34:	01079c63          	bne	a5,a6,80007d4c <virtio_disk_rw+0x238>
    sleep(b, &disk.vdisk_lock);
    80007d38:	00090593          	mv	a1,s2
    80007d3c:	000a0513          	mv	a0,s4
    80007d40:	f99fa0ef          	jal	80002cd8 <sleep>
  while(b->disk == 1) {
    80007d44:	004a2783          	lw	a5,4(s4)
    80007d48:	fe9788e3          	beq	a5,s1,80007d38 <virtio_disk_rw+0x224>
  }

  disk.info[idx[0]].b = 0;
    80007d4c:	f9042903          	lw	s2,-112(s0)
    80007d50:	00290713          	addi	a4,s2,2
    80007d54:	00471713          	slli	a4,a4,0x4
    80007d58:	0001b797          	auipc	a5,0x1b
    80007d5c:	da878793          	addi	a5,a5,-600 # 80022b00 <disk>
    80007d60:	00e787b3          	add	a5,a5,a4
    80007d64:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80007d68:	0001b997          	auipc	s3,0x1b
    80007d6c:	d9898993          	addi	s3,s3,-616 # 80022b00 <disk>
    80007d70:	00491713          	slli	a4,s2,0x4
    80007d74:	0009b783          	ld	a5,0(s3)
    80007d78:	00e787b3          	add	a5,a5,a4
    80007d7c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80007d80:	00090513          	mv	a0,s2
    80007d84:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80007d88:	a81ff0ef          	jal	80007808 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80007d8c:	0014f493          	andi	s1,s1,1
    80007d90:	fe0490e3          	bnez	s1,80007d70 <virtio_disk_rw+0x25c>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80007d94:	0001b517          	auipc	a0,0x1b
    80007d98:	e9450513          	addi	a0,a0,-364 # 80022c28 <disk+0x128>
    80007d9c:	b88f90ef          	jal	80001124 <release>
}
    80007da0:	06813083          	ld	ra,104(sp)
    80007da4:	06013403          	ld	s0,96(sp)
    80007da8:	05813483          	ld	s1,88(sp)
    80007dac:	05013903          	ld	s2,80(sp)
    80007db0:	04813983          	ld	s3,72(sp)
    80007db4:	04013a03          	ld	s4,64(sp)
    80007db8:	03813a83          	ld	s5,56(sp)
    80007dbc:	03013b03          	ld	s6,48(sp)
    80007dc0:	02813b83          	ld	s7,40(sp)
    80007dc4:	02013c03          	ld	s8,32(sp)
    80007dc8:	01813c83          	ld	s9,24(sp)
    80007dcc:	07010113          	addi	sp,sp,112
    80007dd0:	00008067          	ret

0000000080007dd4 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80007dd4:	fe010113          	addi	sp,sp,-32
    80007dd8:	00113c23          	sd	ra,24(sp)
    80007ddc:	00813823          	sd	s0,16(sp)
    80007de0:	00913423          	sd	s1,8(sp)
    80007de4:	02010413          	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80007de8:	0001b497          	auipc	s1,0x1b
    80007dec:	d1848493          	addi	s1,s1,-744 # 80022b00 <disk>
    80007df0:	0001b517          	auipc	a0,0x1b
    80007df4:	e3850513          	addi	a0,a0,-456 # 80022c28 <disk+0x128>
    80007df8:	a50f90ef          	jal	80001048 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80007dfc:	100017b7          	lui	a5,0x10001
    80007e00:	0607a703          	lw	a4,96(a5) # 10001060 <_entry-0x6fffefa0>
    80007e04:	00377713          	andi	a4,a4,3
    80007e08:	100017b7          	lui	a5,0x10001
    80007e0c:	06e7a223          	sw	a4,100(a5) # 10001064 <_entry-0x6fffef9c>

  __sync_synchronize();
    80007e10:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80007e14:	0104b783          	ld	a5,16(s1)
    80007e18:	0204d703          	lhu	a4,32(s1)
    80007e1c:	0027d783          	lhu	a5,2(a5)
    80007e20:	06f70663          	beq	a4,a5,80007e8c <virtio_disk_intr+0xb8>
    __sync_synchronize();
    80007e24:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80007e28:	0104b703          	ld	a4,16(s1)
    80007e2c:	0204d783          	lhu	a5,32(s1)
    80007e30:	0077f793          	andi	a5,a5,7
    80007e34:	00379793          	slli	a5,a5,0x3
    80007e38:	00f707b3          	add	a5,a4,a5
    80007e3c:	0047a783          	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80007e40:	00278713          	addi	a4,a5,2
    80007e44:	00471713          	slli	a4,a4,0x4
    80007e48:	00e48733          	add	a4,s1,a4
    80007e4c:	01074703          	lbu	a4,16(a4)
    80007e50:	04071e63          	bnez	a4,80007eac <virtio_disk_intr+0xd8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80007e54:	00278793          	addi	a5,a5,2
    80007e58:	00479793          	slli	a5,a5,0x4
    80007e5c:	00f487b3          	add	a5,s1,a5
    80007e60:	0087b503          	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80007e64:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80007e68:	ee9fa0ef          	jal	80002d50 <wakeup>

    disk.used_idx += 1;
    80007e6c:	0204d783          	lhu	a5,32(s1)
    80007e70:	0017879b          	addiw	a5,a5,1
    80007e74:	03079793          	slli	a5,a5,0x30
    80007e78:	0307d793          	srli	a5,a5,0x30
    80007e7c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80007e80:	0104b703          	ld	a4,16(s1)
    80007e84:	00275703          	lhu	a4,2(a4)
    80007e88:	f8f71ee3          	bne	a4,a5,80007e24 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80007e8c:	0001b517          	auipc	a0,0x1b
    80007e90:	d9c50513          	addi	a0,a0,-612 # 80022c28 <disk+0x128>
    80007e94:	a90f90ef          	jal	80001124 <release>
}
    80007e98:	01813083          	ld	ra,24(sp)
    80007e9c:	01013403          	ld	s0,16(sp)
    80007ea0:	00813483          	ld	s1,8(sp)
    80007ea4:	02010113          	addi	sp,sp,32
    80007ea8:	00008067          	ret
      panic("virtio_disk_intr status");
    80007eac:	00002517          	auipc	a0,0x2
    80007eb0:	8ac50513          	addi	a0,a0,-1876 # 80009758 <etext+0x758>
    80007eb4:	b4df80ef          	jal	80000a00 <panic>
	...

0000000080008000 <_trampoline>:
    80008000:	14051073          	csrw	sscratch,a0
    80008004:	02000537          	lui	a0,0x2000
    80008008:	357d                	.insn	2, 0x357d
    8000800a:	0536                	.insn	2, 0x0536
    8000800c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80008010:	02253823          	sd	sp,48(a0)
    80008014:	02353c23          	sd	gp,56(a0)
    80008018:	04453023          	sd	tp,64(a0)
    8000801c:	04553423          	sd	t0,72(a0)
    80008020:	04653823          	sd	t1,80(a0)
    80008024:	04753c23          	sd	t2,88(a0)
    80008028:	f120                	.insn	2, 0xf120
    8000802a:	f524                	.insn	2, 0xf524
    8000802c:	fd2c                	.insn	2, 0xfd2c
    8000802e:	e150                	.insn	2, 0xe150
    80008030:	e554                	.insn	2, 0xe554
    80008032:	e958                	.insn	2, 0xe958
    80008034:	ed5c                	.insn	2, 0xed5c
    80008036:	0b053023          	sd	a6,160(a0)
    8000803a:	0b153423          	sd	a7,168(a0)
    8000803e:	0b253823          	sd	s2,176(a0)
    80008042:	0b353c23          	sd	s3,184(a0)
    80008046:	0d453023          	sd	s4,192(a0)
    8000804a:	0d553423          	sd	s5,200(a0)
    8000804e:	0d653823          	sd	s6,208(a0)
    80008052:	0d753c23          	sd	s7,216(a0)
    80008056:	0f853023          	sd	s8,224(a0)
    8000805a:	0f953423          	sd	s9,232(a0)
    8000805e:	0fa53823          	sd	s10,240(a0)
    80008062:	0fb53c23          	sd	s11,248(a0)
    80008066:	11c53023          	sd	t3,256(a0)
    8000806a:	11d53423          	sd	t4,264(a0)
    8000806e:	11e53823          	sd	t5,272(a0)
    80008072:	11f53c23          	sd	t6,280(a0)
    80008076:	140022f3          	csrr	t0,sscratch
    8000807a:	06553823          	sd	t0,112(a0)
    8000807e:	00853103          	ld	sp,8(a0)
    80008082:	02053203          	ld	tp,32(a0)
    80008086:	01053283          	ld	t0,16(a0)
    8000808a:	00053303          	ld	t1,0(a0)
    8000808e:	12000073          	sfence.vma
    80008092:	18031073          	csrw	satp,t1
    80008096:	12000073          	sfence.vma
    8000809a:	8282                	.insn	2, 0x8282

000000008000809c <userret>:
    8000809c:	12000073          	sfence.vma
    800080a0:	18051073          	csrw	satp,a0
    800080a4:	12000073          	sfence.vma
    800080a8:	02000537          	lui	a0,0x2000
    800080ac:	357d                	.insn	2, 0x357d
    800080ae:	0536                	.insn	2, 0x0536
    800080b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800080b4:	03053103          	ld	sp,48(a0)
    800080b8:	03853183          	ld	gp,56(a0)
    800080bc:	04053203          	ld	tp,64(a0)
    800080c0:	04853283          	ld	t0,72(a0)
    800080c4:	05053303          	ld	t1,80(a0)
    800080c8:	05853383          	ld	t2,88(a0)
    800080cc:	7120                	.insn	2, 0x7120
    800080ce:	7524                	.insn	2, 0x7524
    800080d0:	7d2c                	.insn	2, 0x7d2c
    800080d2:	6150                	.insn	2, 0x6150
    800080d4:	6554                	.insn	2, 0x6554
    800080d6:	6958                	.insn	2, 0x6958
    800080d8:	6d5c                	.insn	2, 0x6d5c
    800080da:	0a053803          	ld	a6,160(a0)
    800080de:	0a853883          	ld	a7,168(a0)
    800080e2:	0b053903          	ld	s2,176(a0)
    800080e6:	0b853983          	ld	s3,184(a0)
    800080ea:	0c053a03          	ld	s4,192(a0)
    800080ee:	0c853a83          	ld	s5,200(a0)
    800080f2:	0d053b03          	ld	s6,208(a0)
    800080f6:	0d853b83          	ld	s7,216(a0)
    800080fa:	0e053c03          	ld	s8,224(a0)
    800080fe:	0e853c83          	ld	s9,232(a0)
    80008102:	0f053d03          	ld	s10,240(a0)
    80008106:	0f853d83          	ld	s11,248(a0)
    8000810a:	10053e03          	ld	t3,256(a0)
    8000810e:	10853e83          	ld	t4,264(a0)
    80008112:	11053f03          	ld	t5,272(a0)
    80008116:	11853f83          	ld	t6,280(a0)
    8000811a:	7928                	.insn	2, 0x7928
    8000811c:	10200073          	sret
	...
