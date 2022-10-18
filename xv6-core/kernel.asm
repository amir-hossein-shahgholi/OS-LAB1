
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 54 11 80       	mov    $0x801154d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b0 31 10 80       	mov    $0x801031b0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 72 10 80       	push   $0x801072e0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 c5 44 00 00       	call   80104520 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 72 10 80       	push   $0x801072e7
80100097:	50                   	push   %eax
80100098:	e8 53 43 00 00       	call   801043f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 07 46 00 00       	call   801046f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 29 45 00 00       	call   80104690 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 42 00 00       	call   80104430 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 9f 22 00 00       	call   80102430 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ee 72 10 80       	push   $0x801072ee
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 0d 43 00 00       	call   801044d0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 57 22 00 00       	jmp    80102430 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 72 10 80       	push   $0x801072ff
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 cc 42 00 00       	call   801044d0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 7c 42 00 00       	call   80104490 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 d0 44 00 00       	call   801046f0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 1f 44 00 00       	jmp    80104690 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 73 10 80       	push   $0x80107306
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 17 17 00 00       	call   801019b0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 4b 44 00 00       	call   801046f0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 be 3e 00 00       	call   80104190 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 d9 37 00 00       	call   80103ac0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 95 43 00 00       	call   80104690 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 cc 15 00 00       	call   801018d0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 3f 43 00 00       	call   80104690 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 76 15 00 00       	call   801018d0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 a2 26 00 00       	call   80102a40 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 0d 73 10 80       	push   $0x8010730d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 77 7c 10 80 	movl   $0x80107c77,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 73 41 00 00       	call   80104540 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 21 73 10 80       	push   $0x80107321
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 e1 59 00 00       	call   80105e00 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 f6 58 00 00       	call   80105e00 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 ea 58 00 00       	call   80105e00 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 de 58 00 00       	call   80105e00 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 fa 42 00 00       	call   80104850 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 45 42 00 00       	call   801047b0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 25 73 10 80       	push   $0x80107325
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 0c 14 00 00       	call   801019b0 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005ab:	e8 40 41 00 00       	call   801046f0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ef 10 80       	push   $0x8010ef20
801005e4:	e8 a7 40 00 00       	call   80104690 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 de 12 00 00       	call   801018d0 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 88 73 10 80 	movzbl -0x7fef8c78(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ef 10 80       	push   $0x8010ef20
801007e8:	e8 03 3f 00 00       	call   801046f0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 38 73 10 80       	mov    $0x80107338,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ef 10 80       	push   $0x8010ef20
8010085b:	e8 30 3e 00 00       	call   80104690 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 3f 73 10 80       	push   $0x8010733f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
80100885:	53                   	push   %ebx
80100886:	81 ec a8 00 00 00    	sub    $0xa8,%esp
8010088c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010088f:	68 20 ef 10 80       	push   $0x8010ef20
80100894:	e8 57 3e 00 00       	call   801046f0 <acquire>
  while((c = getc()) >= 0){
80100899:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
8010089c:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
801008a3:	00 00 00 
  while((c = getc()) >= 0){
801008a6:	ff d3                	call   *%ebx
801008a8:	89 c6                	mov    %eax,%esi
801008aa:	85 c0                	test   %eax,%eax
801008ac:	0f 88 4e 02 00 00    	js     80100b00 <consoleintr+0x280>
    switch(c){
801008b2:	83 fe 15             	cmp    $0x15,%esi
801008b5:	7f 21                	jg     801008d8 <consoleintr+0x58>
801008b7:	83 fe 07             	cmp    $0x7,%esi
801008ba:	0f 8e 68 02 00 00    	jle    80100b28 <consoleintr+0x2a8>
801008c0:	8d 46 f8             	lea    -0x8(%esi),%eax
801008c3:	83 f8 0d             	cmp    $0xd,%eax
801008c6:	0f 87 5c 02 00 00    	ja     80100b28 <consoleintr+0x2a8>
801008cc:	ff 24 85 50 73 10 80 	jmp    *-0x7fef8cb0(,%eax,4)
801008d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801008d7:	90                   	nop
801008d8:	83 fe 7f             	cmp    $0x7f,%esi
801008db:	0f 84 4f 01 00 00    	je     80100a30 <consoleintr+0x1b0>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008e1:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801008e6:	89 c2                	mov    %eax,%edx
801008e8:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801008ee:	83 fa 7f             	cmp    $0x7f,%edx
801008f1:	77 b3                	ja     801008a6 <consoleintr+0x26>
      input.e++;
801008f3:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008f6:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008fc:	83 e0 7f             	and    $0x7f,%eax
801008ff:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
80100905:	83 fe 0d             	cmp    $0xd,%esi
80100908:	0f 84 6a 02 00 00    	je     80100b78 <consoleintr+0x2f8>
        input.buf[input.e++ % INPUT_BUF] = c;
8010090e:	89 f1                	mov    %esi,%ecx
80100910:	88 88 80 ee 10 80    	mov    %cl,-0x7fef1180(%eax)
  if(panicked){
80100916:	85 d2                	test   %edx,%edx
80100918:	0f 85 79 02 00 00    	jne    80100b97 <consoleintr+0x317>
8010091e:	89 f0                	mov    %esi,%eax
80100920:	e8 db fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100925:	83 fe 0a             	cmp    $0xa,%esi
80100928:	0f 84 5f 02 00 00    	je     80100b8d <consoleintr+0x30d>
8010092e:	83 fe 04             	cmp    $0x4,%esi
80100931:	0f 84 56 02 00 00    	je     80100b8d <consoleintr+0x30d>
80100937:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010093c:	83 e8 80             	sub    $0xffffff80,%eax
8010093f:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100945:	0f 85 5b ff ff ff    	jne    801008a6 <consoleintr+0x26>
          wakeup(&input.r);
8010094b:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010094e:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100953:	68 00 ef 10 80       	push   $0x8010ef00
80100958:	e8 f3 38 00 00       	call   80104250 <wakeup>
8010095d:	83 c4 10             	add    $0x10,%esp
80100960:	e9 41 ff ff ff       	jmp    801008a6 <consoleintr+0x26>
80100965:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100968:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010096d:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
80100973:	0f 84 2d ff ff ff    	je     801008a6 <consoleintr+0x26>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100979:	83 e8 01             	sub    $0x1,%eax
8010097c:	89 c2                	mov    %eax,%edx
8010097e:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100981:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100988:	0f 84 18 ff ff ff    	je     801008a6 <consoleintr+0x26>
  if(panicked){
8010098e:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.e--;
80100994:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100999:	85 c9                	test   %ecx,%ecx
8010099b:	0f 84 36 01 00 00    	je     80100ad7 <consoleintr+0x257>
801009a1:	fa                   	cli    
    for(;;)
801009a2:	eb fe                	jmp    801009a2 <consoleintr+0x122>
801009a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801009a8:	8b 35 58 ef 10 80    	mov    0x8010ef58,%esi
      input.e++;
801009ae:	83 05 08 ef 10 80 01 	addl   $0x1,0x8010ef08
      consputc(97 + input.r);
801009b5:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
  if(panicked){
801009ba:	85 f6                	test   %esi,%esi
801009bc:	0f 84 76 01 00 00    	je     80100b38 <consoleintr+0x2b8>
801009c2:	fa                   	cli    
    for(;;)
801009c3:	eb fe                	jmp    801009c3 <consoleintr+0x143>
801009c5:	8d 76 00             	lea    0x0(%esi),%esi
      for(int i = input.w; i < input.e; i++)
801009c8:	8b 15 04 ef 10 80    	mov    0x8010ef04,%edx
801009ce:	8b 3d 08 ef 10 80    	mov    0x8010ef08,%edi
      int idx = 0;
801009d4:	31 f6                	xor    %esi,%esi
      for(int i = input.w; i < input.e; i++)
801009d6:	39 fa                	cmp    %edi,%edx
801009d8:	0f 83 c2 01 00 00    	jae    80100ba0 <consoleintr+0x320>
801009de:	66 90                	xchg   %ax,%ax
        if(input.buf[i] > '9' || input.buf[i] < '0')
801009e0:	0f b6 82 80 ee 10 80 	movzbl -0x7fef1180(%edx),%eax
801009e7:	8d 48 d0             	lea    -0x30(%eax),%ecx
801009ea:	80 f9 09             	cmp    $0x9,%cl
801009ed:	76 0f                	jbe    801009fe <consoleintr+0x17e>
          newBuf[idx++ % INPUT_BUF] = input.buf[i];
801009ef:	89 f1                	mov    %esi,%ecx
801009f1:	83 c6 01             	add    $0x1,%esi
801009f4:	83 e1 7f             	and    $0x7f,%ecx
801009f7:	88 84 0d 68 ff ff ff 	mov    %al,-0x98(%ebp,%ecx,1)
      for(int i = input.w; i < input.e; i++)
801009fe:	83 c2 01             	add    $0x1,%edx
80100a01:	39 fa                	cmp    %edi,%edx
80100a03:	75 db                	jne    801009e0 <consoleintr+0x160>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a05:	8d 47 ff             	lea    -0x1(%edi),%eax
80100a08:	89 c2                	mov    %eax,%edx
80100a0a:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a0d:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100a14:	74 62                	je     80100a78 <consoleintr+0x1f8>
        input.e--;
80100a16:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100a1b:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100a20:	85 c0                	test   %eax,%eax
80100a22:	74 3c                	je     80100a60 <consoleintr+0x1e0>
80100a24:	fa                   	cli    
    for(;;)
80100a25:	eb fe                	jmp    80100a25 <consoleintr+0x1a5>
80100a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a2e:	66 90                	xchg   %ax,%ax
      if(input.e != input.w){
80100a30:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a35:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100a3b:	0f 84 65 fe ff ff    	je     801008a6 <consoleintr+0x26>
  if(panicked){
80100a41:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
80100a47:	83 e8 01             	sub    $0x1,%eax
80100a4a:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100a4f:	85 d2                	test   %edx,%edx
80100a51:	0f 84 09 01 00 00    	je     80100b60 <consoleintr+0x2e0>
80100a57:	fa                   	cli    
    for(;;)
80100a58:	eb fe                	jmp    80100a58 <consoleintr+0x1d8>
80100a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100a60:	b8 00 01 00 00       	mov    $0x100,%eax
80100a65:	e8 96 f9 ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
80100a6a:	8b 3d 08 ef 10 80    	mov    0x8010ef08,%edi
80100a70:	3b 3d 04 ef 10 80    	cmp    0x8010ef04,%edi
80100a76:	75 8d                	jne    80100a05 <consoleintr+0x185>
      for(int i = 0; i < idx; i++){
80100a78:	31 d2                	xor    %edx,%edx
80100a7a:	85 f6                	test   %esi,%esi
80100a7c:	0f 84 24 fe ff ff    	je     801008a6 <consoleintr+0x26>
        input.e++;
80100a82:	8d 47 01             	lea    0x1(%edi),%eax
        input.buf[(input.w + i) % INPUT_BUF] = newBuf[i];
80100a85:	0f b6 8c 15 68 ff ff 	movzbl -0x98(%ebp,%edx,1),%ecx
80100a8c:	ff 
  if(panicked){
80100a8d:	8b 3d 58 ef 10 80    	mov    0x8010ef58,%edi
        input.e++;
80100a93:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
        input.buf[(input.w + i) % INPUT_BUF] = newBuf[i];
80100a98:	a1 04 ef 10 80       	mov    0x8010ef04,%eax
80100a9d:	01 d0                	add    %edx,%eax
80100a9f:	83 e0 7f             	and    $0x7f,%eax
80100aa2:	88 88 80 ee 10 80    	mov    %cl,-0x7fef1180(%eax)
  if(panicked){
80100aa8:	85 ff                	test   %edi,%edi
80100aaa:	0f 85 bf 00 00 00    	jne    80100b6f <consoleintr+0x2ef>
        consputc(newBuf[i]);
80100ab0:	0f be c1             	movsbl %cl,%eax
80100ab3:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
80100ab9:	e8 42 f9 ff ff       	call   80100400 <consputc.part.0>
      for(int i = 0; i < idx; i++){
80100abe:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
80100ac4:	83 c2 01             	add    $0x1,%edx
80100ac7:	39 d6                	cmp    %edx,%esi
80100ac9:	0f 84 d7 fd ff ff    	je     801008a6 <consoleintr+0x26>
80100acf:	8b 3d 08 ef 10 80    	mov    0x8010ef08,%edi
80100ad5:	eb ab                	jmp    80100a82 <consoleintr+0x202>
80100ad7:	b8 00 01 00 00       	mov    $0x100,%eax
80100adc:	e8 1f f9 ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
80100ae1:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100ae6:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100aec:	0f 85 87 fe ff ff    	jne    80100979 <consoleintr+0xf9>
80100af2:	e9 af fd ff ff       	jmp    801008a6 <consoleintr+0x26>
80100af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100afe:	66 90                	xchg   %ax,%ax
  release(&cons.lock);
80100b00:	83 ec 0c             	sub    $0xc,%esp
80100b03:	68 20 ef 10 80       	push   $0x8010ef20
80100b08:	e8 83 3b 00 00       	call   80104690 <release>
  if(doprocdump) {
80100b0d:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80100b13:	83 c4 10             	add    $0x10,%esp
80100b16:	85 c0                	test   %eax,%eax
80100b18:	75 3a                	jne    80100b54 <consoleintr+0x2d4>
}
80100b1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1d:	5b                   	pop    %ebx
80100b1e:	5e                   	pop    %esi
80100b1f:	5f                   	pop    %edi
80100b20:	5d                   	pop    %ebp
80100b21:	c3                   	ret    
80100b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100b28:	85 f6                	test   %esi,%esi
80100b2a:	0f 84 76 fd ff ff    	je     801008a6 <consoleintr+0x26>
80100b30:	e9 ac fd ff ff       	jmp    801008e1 <consoleintr+0x61>
80100b35:	8d 76 00             	lea    0x0(%esi),%esi
      consputc(97 + input.r);
80100b38:	83 c0 61             	add    $0x61,%eax
80100b3b:	e8 c0 f8 ff ff       	call   80100400 <consputc.part.0>
80100b40:	e9 61 fd ff ff       	jmp    801008a6 <consoleintr+0x26>
    switch(c){
80100b45:	c7 85 64 ff ff ff 01 	movl   $0x1,-0x9c(%ebp)
80100b4c:	00 00 00 
80100b4f:	e9 52 fd ff ff       	jmp    801008a6 <consoleintr+0x26>
}
80100b54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b57:	5b                   	pop    %ebx
80100b58:	5e                   	pop    %esi
80100b59:	5f                   	pop    %edi
80100b5a:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100b5b:	e9 d0 37 00 00       	jmp    80104330 <procdump>
80100b60:	b8 00 01 00 00       	mov    $0x100,%eax
80100b65:	e8 96 f8 ff ff       	call   80100400 <consputc.part.0>
80100b6a:	e9 37 fd ff ff       	jmp    801008a6 <consoleintr+0x26>
80100b6f:	fa                   	cli    
    for(;;)
80100b70:	eb fe                	jmp    80100b70 <consoleintr+0x2f0>
80100b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100b78:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100b7f:	85 d2                	test   %edx,%edx
80100b81:	75 14                	jne    80100b97 <consoleintr+0x317>
80100b83:	b8 0a 00 00 00       	mov    $0xa,%eax
80100b88:	e8 73 f8 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100b8d:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100b92:	e9 b4 fd ff ff       	jmp    8010094b <consoleintr+0xcb>
80100b97:	fa                   	cli    
    for(;;)
80100b98:	eb fe                	jmp    80100b98 <consoleintr+0x318>
80100b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100ba0:	0f 85 5f fe ff ff    	jne    80100a05 <consoleintr+0x185>
80100ba6:	e9 fb fc ff ff       	jmp    801008a6 <consoleintr+0x26>
80100bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100baf:	90                   	nop

80100bb0 <consoleinit>:

void
consoleinit(void)
{
80100bb0:	55                   	push   %ebp
80100bb1:	89 e5                	mov    %esp,%ebp
80100bb3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100bb6:	68 48 73 10 80       	push   $0x80107348
80100bbb:	68 20 ef 10 80       	push   $0x8010ef20
80100bc0:	e8 5b 39 00 00       	call   80104520 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100bc5:	58                   	pop    %eax
80100bc6:	5a                   	pop    %edx
80100bc7:	6a 00                	push   $0x0
80100bc9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100bcb:	c7 05 0c f9 10 80 90 	movl   $0x80100590,0x8010f90c
80100bd2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100bd5:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100bdc:	02 10 80 
  cons.locking = 1;
80100bdf:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100be6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100be9:	e8 e2 19 00 00       	call   801025d0 <ioapicenable>
}
80100bee:	83 c4 10             	add    $0x10,%esp
80100bf1:	c9                   	leave  
80100bf2:	c3                   	ret    
80100bf3:	66 90                	xchg   %ax,%ax
80100bf5:	66 90                	xchg   %ax,%ax
80100bf7:	66 90                	xchg   %ax,%ax
80100bf9:	66 90                	xchg   %ax,%ax
80100bfb:	66 90                	xchg   %ax,%ax
80100bfd:	66 90                	xchg   %ax,%ax
80100bff:	90                   	nop

80100c00 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100c00:	55                   	push   %ebp
80100c01:	89 e5                	mov    %esp,%ebp
80100c03:	57                   	push   %edi
80100c04:	56                   	push   %esi
80100c05:	53                   	push   %ebx
80100c06:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100c0c:	e8 af 2e 00 00       	call   80103ac0 <myproc>
80100c11:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100c17:	e8 94 22 00 00       	call   80102eb0 <begin_op>

  if((ip = namei(path)) == 0){
80100c1c:	83 ec 0c             	sub    $0xc,%esp
80100c1f:	ff 75 08             	push   0x8(%ebp)
80100c22:	e8 c9 15 00 00       	call   801021f0 <namei>
80100c27:	83 c4 10             	add    $0x10,%esp
80100c2a:	85 c0                	test   %eax,%eax
80100c2c:	0f 84 02 03 00 00    	je     80100f34 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100c32:	83 ec 0c             	sub    $0xc,%esp
80100c35:	89 c3                	mov    %eax,%ebx
80100c37:	50                   	push   %eax
80100c38:	e8 93 0c 00 00       	call   801018d0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c3d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100c43:	6a 34                	push   $0x34
80100c45:	6a 00                	push   $0x0
80100c47:	50                   	push   %eax
80100c48:	53                   	push   %ebx
80100c49:	e8 92 0f 00 00       	call   80101be0 <readi>
80100c4e:	83 c4 20             	add    $0x20,%esp
80100c51:	83 f8 34             	cmp    $0x34,%eax
80100c54:	74 22                	je     80100c78 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100c56:	83 ec 0c             	sub    $0xc,%esp
80100c59:	53                   	push   %ebx
80100c5a:	e8 01 0f 00 00       	call   80101b60 <iunlockput>
    end_op();
80100c5f:	e8 bc 22 00 00       	call   80102f20 <end_op>
80100c64:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100c67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c6f:	5b                   	pop    %ebx
80100c70:	5e                   	pop    %esi
80100c71:	5f                   	pop    %edi
80100c72:	5d                   	pop    %ebp
80100c73:	c3                   	ret    
80100c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100c78:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100c7f:	45 4c 46 
80100c82:	75 d2                	jne    80100c56 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100c84:	e8 07 63 00 00       	call   80106f90 <setupkvm>
80100c89:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100c8f:	85 c0                	test   %eax,%eax
80100c91:	74 c3                	je     80100c56 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c93:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100c9a:	00 
80100c9b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100ca1:	0f 84 ac 02 00 00    	je     80100f53 <exec+0x353>
  sz = 0;
80100ca7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100cae:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cb1:	31 ff                	xor    %edi,%edi
80100cb3:	e9 8e 00 00 00       	jmp    80100d46 <exec+0x146>
80100cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100cbf:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100cc0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100cc7:	75 6c                	jne    80100d35 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100cc9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ccf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100cd5:	0f 82 87 00 00 00    	jb     80100d62 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100cdb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ce1:	72 7f                	jb     80100d62 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ce3:	83 ec 04             	sub    $0x4,%esp
80100ce6:	50                   	push   %eax
80100ce7:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100ced:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cf3:	e8 b8 60 00 00       	call   80106db0 <allocuvm>
80100cf8:	83 c4 10             	add    $0x10,%esp
80100cfb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d01:	85 c0                	test   %eax,%eax
80100d03:	74 5d                	je     80100d62 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100d05:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100d0b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100d10:	75 50                	jne    80100d62 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d12:	83 ec 0c             	sub    $0xc,%esp
80100d15:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100d1b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100d21:	53                   	push   %ebx
80100d22:	50                   	push   %eax
80100d23:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d29:	e8 92 5f 00 00       	call   80106cc0 <loaduvm>
80100d2e:	83 c4 20             	add    $0x20,%esp
80100d31:	85 c0                	test   %eax,%eax
80100d33:	78 2d                	js     80100d62 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d35:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100d3c:	83 c7 01             	add    $0x1,%edi
80100d3f:	83 c6 20             	add    $0x20,%esi
80100d42:	39 f8                	cmp    %edi,%eax
80100d44:	7e 3a                	jle    80100d80 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d46:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100d4c:	6a 20                	push   $0x20
80100d4e:	56                   	push   %esi
80100d4f:	50                   	push   %eax
80100d50:	53                   	push   %ebx
80100d51:	e8 8a 0e 00 00       	call   80101be0 <readi>
80100d56:	83 c4 10             	add    $0x10,%esp
80100d59:	83 f8 20             	cmp    $0x20,%eax
80100d5c:	0f 84 5e ff ff ff    	je     80100cc0 <exec+0xc0>
    freevm(pgdir);
80100d62:	83 ec 0c             	sub    $0xc,%esp
80100d65:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d6b:	e8 a0 61 00 00       	call   80106f10 <freevm>
  if(ip){
80100d70:	83 c4 10             	add    $0x10,%esp
80100d73:	e9 de fe ff ff       	jmp    80100c56 <exec+0x56>
80100d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d7f:	90                   	nop
  sz = PGROUNDUP(sz);
80100d80:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d86:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100d8c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d92:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100d98:	83 ec 0c             	sub    $0xc,%esp
80100d9b:	53                   	push   %ebx
80100d9c:	e8 bf 0d 00 00       	call   80101b60 <iunlockput>
  end_op();
80100da1:	e8 7a 21 00 00       	call   80102f20 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100da6:	83 c4 0c             	add    $0xc,%esp
80100da9:	56                   	push   %esi
80100daa:	57                   	push   %edi
80100dab:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100db1:	57                   	push   %edi
80100db2:	e8 f9 5f 00 00       	call   80106db0 <allocuvm>
80100db7:	83 c4 10             	add    $0x10,%esp
80100dba:	89 c6                	mov    %eax,%esi
80100dbc:	85 c0                	test   %eax,%eax
80100dbe:	0f 84 94 00 00 00    	je     80100e58 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dc4:	83 ec 08             	sub    $0x8,%esp
80100dc7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100dcd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dcf:	50                   	push   %eax
80100dd0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100dd1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dd3:	e8 58 62 00 00       	call   80107030 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ddb:	83 c4 10             	add    $0x10,%esp
80100dde:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100de4:	8b 00                	mov    (%eax),%eax
80100de6:	85 c0                	test   %eax,%eax
80100de8:	0f 84 8b 00 00 00    	je     80100e79 <exec+0x279>
80100dee:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100df4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100dfa:	eb 23                	jmp    80100e1f <exec+0x21f>
80100dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e00:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100e03:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100e0a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100e0d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100e13:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100e16:	85 c0                	test   %eax,%eax
80100e18:	74 59                	je     80100e73 <exec+0x273>
    if(argc >= MAXARG)
80100e1a:	83 ff 20             	cmp    $0x20,%edi
80100e1d:	74 39                	je     80100e58 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e1f:	83 ec 0c             	sub    $0xc,%esp
80100e22:	50                   	push   %eax
80100e23:	e8 88 3b 00 00       	call   801049b0 <strlen>
80100e28:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e2a:	58                   	pop    %eax
80100e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e2e:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e31:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e34:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e37:	e8 74 3b 00 00       	call   801049b0 <strlen>
80100e3c:	83 c0 01             	add    $0x1,%eax
80100e3f:	50                   	push   %eax
80100e40:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e43:	ff 34 b8             	push   (%eax,%edi,4)
80100e46:	53                   	push   %ebx
80100e47:	56                   	push   %esi
80100e48:	e8 b3 63 00 00       	call   80107200 <copyout>
80100e4d:	83 c4 20             	add    $0x20,%esp
80100e50:	85 c0                	test   %eax,%eax
80100e52:	79 ac                	jns    80100e00 <exec+0x200>
80100e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100e58:	83 ec 0c             	sub    $0xc,%esp
80100e5b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100e61:	e8 aa 60 00 00       	call   80106f10 <freevm>
80100e66:	83 c4 10             	add    $0x10,%esp
  return -1;
80100e69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e6e:	e9 f9 fd ff ff       	jmp    80100c6c <exec+0x6c>
80100e73:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e79:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100e80:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100e82:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100e89:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e8d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100e8f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100e92:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100e98:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e9a:	50                   	push   %eax
80100e9b:	52                   	push   %edx
80100e9c:	53                   	push   %ebx
80100e9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100ea3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100eaa:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ead:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100eb3:	e8 48 63 00 00       	call   80107200 <copyout>
80100eb8:	83 c4 10             	add    $0x10,%esp
80100ebb:	85 c0                	test   %eax,%eax
80100ebd:	78 99                	js     80100e58 <exec+0x258>
  for(last=s=path; *s; s++)
80100ebf:	8b 45 08             	mov    0x8(%ebp),%eax
80100ec2:	8b 55 08             	mov    0x8(%ebp),%edx
80100ec5:	0f b6 00             	movzbl (%eax),%eax
80100ec8:	84 c0                	test   %al,%al
80100eca:	74 13                	je     80100edf <exec+0x2df>
80100ecc:	89 d1                	mov    %edx,%ecx
80100ece:	66 90                	xchg   %ax,%ax
      last = s+1;
80100ed0:	83 c1 01             	add    $0x1,%ecx
80100ed3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100ed5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100ed8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100edb:	84 c0                	test   %al,%al
80100edd:	75 f1                	jne    80100ed0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100edf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100ee5:	83 ec 04             	sub    $0x4,%esp
80100ee8:	6a 10                	push   $0x10
80100eea:	89 f8                	mov    %edi,%eax
80100eec:	52                   	push   %edx
80100eed:	83 c0 6c             	add    $0x6c,%eax
80100ef0:	50                   	push   %eax
80100ef1:	e8 7a 3a 00 00       	call   80104970 <safestrcpy>
  curproc->pgdir = pgdir;
80100ef6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100efc:	89 f8                	mov    %edi,%eax
80100efe:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100f01:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100f03:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f06:	89 c1                	mov    %eax,%ecx
80100f08:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100f0e:	8b 40 18             	mov    0x18(%eax),%eax
80100f11:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f14:	8b 41 18             	mov    0x18(%ecx),%eax
80100f17:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100f1a:	89 0c 24             	mov    %ecx,(%esp)
80100f1d:	e8 0e 5c 00 00       	call   80106b30 <switchuvm>
  freevm(oldpgdir);
80100f22:	89 3c 24             	mov    %edi,(%esp)
80100f25:	e8 e6 5f 00 00       	call   80106f10 <freevm>
  return 0;
80100f2a:	83 c4 10             	add    $0x10,%esp
80100f2d:	31 c0                	xor    %eax,%eax
80100f2f:	e9 38 fd ff ff       	jmp    80100c6c <exec+0x6c>
    end_op();
80100f34:	e8 e7 1f 00 00       	call   80102f20 <end_op>
    cprintf("exec: fail\n");
80100f39:	83 ec 0c             	sub    $0xc,%esp
80100f3c:	68 99 73 10 80       	push   $0x80107399
80100f41:	e8 5a f7 ff ff       	call   801006a0 <cprintf>
    return -1;
80100f46:	83 c4 10             	add    $0x10,%esp
80100f49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f4e:	e9 19 fd ff ff       	jmp    80100c6c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f53:	be 00 20 00 00       	mov    $0x2000,%esi
80100f58:	31 ff                	xor    %edi,%edi
80100f5a:	e9 39 fe ff ff       	jmp    80100d98 <exec+0x198>
80100f5f:	90                   	nop

80100f60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f66:	68 a5 73 10 80       	push   $0x801073a5
80100f6b:	68 60 ef 10 80       	push   $0x8010ef60
80100f70:	e8 ab 35 00 00       	call   80104520 <initlock>
}
80100f75:	83 c4 10             	add    $0x10,%esp
80100f78:	c9                   	leave  
80100f79:	c3                   	ret    
80100f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f84:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100f89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f8c:	68 60 ef 10 80       	push   $0x8010ef60
80100f91:	e8 5a 37 00 00       	call   801046f0 <acquire>
80100f96:	83 c4 10             	add    $0x10,%esp
80100f99:	eb 10                	jmp    80100fab <filealloc+0x2b>
80100f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f9f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fa0:	83 c3 18             	add    $0x18,%ebx
80100fa3:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100fa9:	74 25                	je     80100fd0 <filealloc+0x50>
    if(f->ref == 0){
80100fab:	8b 43 04             	mov    0x4(%ebx),%eax
80100fae:	85 c0                	test   %eax,%eax
80100fb0:	75 ee                	jne    80100fa0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100fb2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100fb5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100fbc:	68 60 ef 10 80       	push   $0x8010ef60
80100fc1:	e8 ca 36 00 00       	call   80104690 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100fc6:	89 d8                	mov    %ebx,%eax
      return f;
80100fc8:	83 c4 10             	add    $0x10,%esp
}
80100fcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fce:	c9                   	leave  
80100fcf:	c3                   	ret    
  release(&ftable.lock);
80100fd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100fd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100fd5:	68 60 ef 10 80       	push   $0x8010ef60
80100fda:	e8 b1 36 00 00       	call   80104690 <release>
}
80100fdf:	89 d8                	mov    %ebx,%eax
  return 0;
80100fe1:	83 c4 10             	add    $0x10,%esp
}
80100fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fe7:	c9                   	leave  
80100fe8:	c3                   	ret    
80100fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	53                   	push   %ebx
80100ff4:	83 ec 10             	sub    $0x10,%esp
80100ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100ffa:	68 60 ef 10 80       	push   $0x8010ef60
80100fff:	e8 ec 36 00 00       	call   801046f0 <acquire>
  if(f->ref < 1)
80101004:	8b 43 04             	mov    0x4(%ebx),%eax
80101007:	83 c4 10             	add    $0x10,%esp
8010100a:	85 c0                	test   %eax,%eax
8010100c:	7e 1a                	jle    80101028 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010100e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101011:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101014:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101017:	68 60 ef 10 80       	push   $0x8010ef60
8010101c:	e8 6f 36 00 00       	call   80104690 <release>
  return f;
}
80101021:	89 d8                	mov    %ebx,%eax
80101023:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101026:	c9                   	leave  
80101027:	c3                   	ret    
    panic("filedup");
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	68 ac 73 10 80       	push   $0x801073ac
80101030:	e8 4b f3 ff ff       	call   80100380 <panic>
80101035:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010103c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101040 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	83 ec 28             	sub    $0x28,%esp
80101049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010104c:	68 60 ef 10 80       	push   $0x8010ef60
80101051:	e8 9a 36 00 00       	call   801046f0 <acquire>
  if(f->ref < 1)
80101056:	8b 53 04             	mov    0x4(%ebx),%edx
80101059:	83 c4 10             	add    $0x10,%esp
8010105c:	85 d2                	test   %edx,%edx
8010105e:	0f 8e a5 00 00 00    	jle    80101109 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101064:	83 ea 01             	sub    $0x1,%edx
80101067:	89 53 04             	mov    %edx,0x4(%ebx)
8010106a:	75 44                	jne    801010b0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010106c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101070:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101073:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101075:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010107b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010107e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101081:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101084:	68 60 ef 10 80       	push   $0x8010ef60
  ff = *f;
80101089:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010108c:	e8 ff 35 00 00       	call   80104690 <release>

  if(ff.type == FD_PIPE)
80101091:	83 c4 10             	add    $0x10,%esp
80101094:	83 ff 01             	cmp    $0x1,%edi
80101097:	74 57                	je     801010f0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101099:	83 ff 02             	cmp    $0x2,%edi
8010109c:	74 2a                	je     801010c8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010109e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a1:	5b                   	pop    %ebx
801010a2:	5e                   	pop    %esi
801010a3:	5f                   	pop    %edi
801010a4:	5d                   	pop    %ebp
801010a5:	c3                   	ret    
801010a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ad:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
801010b0:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
801010b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010ba:	5b                   	pop    %ebx
801010bb:	5e                   	pop    %esi
801010bc:	5f                   	pop    %edi
801010bd:	5d                   	pop    %ebp
    release(&ftable.lock);
801010be:	e9 cd 35 00 00       	jmp    80104690 <release>
801010c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010c7:	90                   	nop
    begin_op();
801010c8:	e8 e3 1d 00 00       	call   80102eb0 <begin_op>
    iput(ff.ip);
801010cd:	83 ec 0c             	sub    $0xc,%esp
801010d0:	ff 75 e0             	push   -0x20(%ebp)
801010d3:	e8 28 09 00 00       	call   80101a00 <iput>
    end_op();
801010d8:	83 c4 10             	add    $0x10,%esp
}
801010db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010de:	5b                   	pop    %ebx
801010df:	5e                   	pop    %esi
801010e0:	5f                   	pop    %edi
801010e1:	5d                   	pop    %ebp
    end_op();
801010e2:	e9 39 1e 00 00       	jmp    80102f20 <end_op>
801010e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ee:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801010f0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801010f4:	83 ec 08             	sub    $0x8,%esp
801010f7:	53                   	push   %ebx
801010f8:	56                   	push   %esi
801010f9:	e8 82 25 00 00       	call   80103680 <pipeclose>
801010fe:	83 c4 10             	add    $0x10,%esp
}
80101101:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101104:	5b                   	pop    %ebx
80101105:	5e                   	pop    %esi
80101106:	5f                   	pop    %edi
80101107:	5d                   	pop    %ebp
80101108:	c3                   	ret    
    panic("fileclose");
80101109:	83 ec 0c             	sub    $0xc,%esp
8010110c:	68 b4 73 10 80       	push   $0x801073b4
80101111:	e8 6a f2 ff ff       	call   80100380 <panic>
80101116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010111d:	8d 76 00             	lea    0x0(%esi),%esi

80101120 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	53                   	push   %ebx
80101124:	83 ec 04             	sub    $0x4,%esp
80101127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010112a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010112d:	75 31                	jne    80101160 <filestat+0x40>
    ilock(f->ip);
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	ff 73 10             	push   0x10(%ebx)
80101135:	e8 96 07 00 00       	call   801018d0 <ilock>
    stati(f->ip, st);
8010113a:	58                   	pop    %eax
8010113b:	5a                   	pop    %edx
8010113c:	ff 75 0c             	push   0xc(%ebp)
8010113f:	ff 73 10             	push   0x10(%ebx)
80101142:	e8 69 0a 00 00       	call   80101bb0 <stati>
    iunlock(f->ip);
80101147:	59                   	pop    %ecx
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 60 08 00 00       	call   801019b0 <iunlock>
    return 0;
  }
  return -1;
}
80101150:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	31 c0                	xor    %eax,%eax
}
80101158:	c9                   	leave  
80101159:	c3                   	ret    
8010115a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101160:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101163:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101168:	c9                   	leave  
80101169:	c3                   	ret    
8010116a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101170 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101170:	55                   	push   %ebp
80101171:	89 e5                	mov    %esp,%ebp
80101173:	57                   	push   %edi
80101174:	56                   	push   %esi
80101175:	53                   	push   %ebx
80101176:	83 ec 0c             	sub    $0xc,%esp
80101179:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010117c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010117f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101182:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101186:	74 60                	je     801011e8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101188:	8b 03                	mov    (%ebx),%eax
8010118a:	83 f8 01             	cmp    $0x1,%eax
8010118d:	74 41                	je     801011d0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010118f:	83 f8 02             	cmp    $0x2,%eax
80101192:	75 5b                	jne    801011ef <fileread+0x7f>
    ilock(f->ip);
80101194:	83 ec 0c             	sub    $0xc,%esp
80101197:	ff 73 10             	push   0x10(%ebx)
8010119a:	e8 31 07 00 00       	call   801018d0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010119f:	57                   	push   %edi
801011a0:	ff 73 14             	push   0x14(%ebx)
801011a3:	56                   	push   %esi
801011a4:	ff 73 10             	push   0x10(%ebx)
801011a7:	e8 34 0a 00 00       	call   80101be0 <readi>
801011ac:	83 c4 20             	add    $0x20,%esp
801011af:	89 c6                	mov    %eax,%esi
801011b1:	85 c0                	test   %eax,%eax
801011b3:	7e 03                	jle    801011b8 <fileread+0x48>
      f->off += r;
801011b5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801011b8:	83 ec 0c             	sub    $0xc,%esp
801011bb:	ff 73 10             	push   0x10(%ebx)
801011be:	e8 ed 07 00 00       	call   801019b0 <iunlock>
    return r;
801011c3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801011c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011c9:	89 f0                	mov    %esi,%eax
801011cb:	5b                   	pop    %ebx
801011cc:	5e                   	pop    %esi
801011cd:	5f                   	pop    %edi
801011ce:	5d                   	pop    %ebp
801011cf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801011d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801011d3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011d9:	5b                   	pop    %ebx
801011da:	5e                   	pop    %esi
801011db:	5f                   	pop    %edi
801011dc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801011dd:	e9 3e 26 00 00       	jmp    80103820 <piperead>
801011e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011ed:	eb d7                	jmp    801011c6 <fileread+0x56>
  panic("fileread");
801011ef:	83 ec 0c             	sub    $0xc,%esp
801011f2:	68 be 73 10 80       	push   $0x801073be
801011f7:	e8 84 f1 ff ff       	call   80100380 <panic>
801011fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101200 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101200:	55                   	push   %ebp
80101201:	89 e5                	mov    %esp,%ebp
80101203:	57                   	push   %edi
80101204:	56                   	push   %esi
80101205:	53                   	push   %ebx
80101206:	83 ec 1c             	sub    $0x1c,%esp
80101209:	8b 45 0c             	mov    0xc(%ebp),%eax
8010120c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010120f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101212:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101215:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101219:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010121c:	0f 84 bd 00 00 00    	je     801012df <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101222:	8b 03                	mov    (%ebx),%eax
80101224:	83 f8 01             	cmp    $0x1,%eax
80101227:	0f 84 bf 00 00 00    	je     801012ec <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010122d:	83 f8 02             	cmp    $0x2,%eax
80101230:	0f 85 c8 00 00 00    	jne    801012fe <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101239:	31 f6                	xor    %esi,%esi
    while(i < n){
8010123b:	85 c0                	test   %eax,%eax
8010123d:	7f 30                	jg     8010126f <filewrite+0x6f>
8010123f:	e9 94 00 00 00       	jmp    801012d8 <filewrite+0xd8>
80101244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101248:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010124b:	83 ec 0c             	sub    $0xc,%esp
8010124e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101251:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101254:	e8 57 07 00 00       	call   801019b0 <iunlock>
      end_op();
80101259:	e8 c2 1c 00 00       	call   80102f20 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010125e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101261:	83 c4 10             	add    $0x10,%esp
80101264:	39 c7                	cmp    %eax,%edi
80101266:	75 5c                	jne    801012c4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101268:	01 fe                	add    %edi,%esi
    while(i < n){
8010126a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010126d:	7e 69                	jle    801012d8 <filewrite+0xd8>
      int n1 = n - i;
8010126f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101272:	b8 00 06 00 00       	mov    $0x600,%eax
80101277:	29 f7                	sub    %esi,%edi
80101279:	39 c7                	cmp    %eax,%edi
8010127b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010127e:	e8 2d 1c 00 00       	call   80102eb0 <begin_op>
      ilock(f->ip);
80101283:	83 ec 0c             	sub    $0xc,%esp
80101286:	ff 73 10             	push   0x10(%ebx)
80101289:	e8 42 06 00 00       	call   801018d0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010128e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101291:	57                   	push   %edi
80101292:	ff 73 14             	push   0x14(%ebx)
80101295:	01 f0                	add    %esi,%eax
80101297:	50                   	push   %eax
80101298:	ff 73 10             	push   0x10(%ebx)
8010129b:	e8 40 0a 00 00       	call   80101ce0 <writei>
801012a0:	83 c4 20             	add    $0x20,%esp
801012a3:	85 c0                	test   %eax,%eax
801012a5:	7f a1                	jg     80101248 <filewrite+0x48>
      iunlock(f->ip);
801012a7:	83 ec 0c             	sub    $0xc,%esp
801012aa:	ff 73 10             	push   0x10(%ebx)
801012ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801012b0:	e8 fb 06 00 00       	call   801019b0 <iunlock>
      end_op();
801012b5:	e8 66 1c 00 00       	call   80102f20 <end_op>
      if(r < 0)
801012ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012bd:	83 c4 10             	add    $0x10,%esp
801012c0:	85 c0                	test   %eax,%eax
801012c2:	75 1b                	jne    801012df <filewrite+0xdf>
        panic("short filewrite");
801012c4:	83 ec 0c             	sub    $0xc,%esp
801012c7:	68 c7 73 10 80       	push   $0x801073c7
801012cc:	e8 af f0 ff ff       	call   80100380 <panic>
801012d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801012d8:	89 f0                	mov    %esi,%eax
801012da:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801012dd:	74 05                	je     801012e4 <filewrite+0xe4>
801012df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801012e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012e7:	5b                   	pop    %ebx
801012e8:	5e                   	pop    %esi
801012e9:	5f                   	pop    %edi
801012ea:	5d                   	pop    %ebp
801012eb:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801012ec:	8b 43 0c             	mov    0xc(%ebx),%eax
801012ef:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012f5:	5b                   	pop    %ebx
801012f6:	5e                   	pop    %esi
801012f7:	5f                   	pop    %edi
801012f8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801012f9:	e9 22 24 00 00       	jmp    80103720 <pipewrite>
  panic("filewrite");
801012fe:	83 ec 0c             	sub    $0xc,%esp
80101301:	68 cd 73 10 80       	push   $0x801073cd
80101306:	e8 75 f0 ff ff       	call   80100380 <panic>
8010130b:	66 90                	xchg   %ax,%ax
8010130d:	66 90                	xchg   %ax,%ax
8010130f:	90                   	nop

80101310 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101310:	55                   	push   %ebp
80101311:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101313:	89 d0                	mov    %edx,%eax
80101315:	c1 e8 0c             	shr    $0xc,%eax
80101318:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
8010131e:	89 e5                	mov    %esp,%ebp
80101320:	56                   	push   %esi
80101321:	53                   	push   %ebx
80101322:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101324:	83 ec 08             	sub    $0x8,%esp
80101327:	50                   	push   %eax
80101328:	51                   	push   %ecx
80101329:	e8 a2 ed ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010132e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101330:	c1 fb 03             	sar    $0x3,%ebx
80101333:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101336:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101338:	83 e1 07             	and    $0x7,%ecx
8010133b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101340:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101346:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101348:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010134d:	85 c1                	test   %eax,%ecx
8010134f:	74 23                	je     80101374 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101351:	f7 d0                	not    %eax
  log_write(bp);
80101353:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101356:	21 c8                	and    %ecx,%eax
80101358:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010135c:	56                   	push   %esi
8010135d:	e8 2e 1d 00 00       	call   80103090 <log_write>
  brelse(bp);
80101362:	89 34 24             	mov    %esi,(%esp)
80101365:	e8 86 ee ff ff       	call   801001f0 <brelse>
}
8010136a:	83 c4 10             	add    $0x10,%esp
8010136d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101370:	5b                   	pop    %ebx
80101371:	5e                   	pop    %esi
80101372:	5d                   	pop    %ebp
80101373:	c3                   	ret    
    panic("freeing free block");
80101374:	83 ec 0c             	sub    $0xc,%esp
80101377:	68 d7 73 10 80       	push   $0x801073d7
8010137c:	e8 ff ef ff ff       	call   80100380 <panic>
80101381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010138f:	90                   	nop

80101390 <balloc>:
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	56                   	push   %esi
80101395:	53                   	push   %ebx
80101396:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101399:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010139f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801013a2:	85 c9                	test   %ecx,%ecx
801013a4:	0f 84 87 00 00 00    	je     80101431 <balloc+0xa1>
801013aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801013b1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801013b4:	83 ec 08             	sub    $0x8,%esp
801013b7:	89 f0                	mov    %esi,%eax
801013b9:	c1 f8 0c             	sar    $0xc,%eax
801013bc:	03 05 cc 15 11 80    	add    0x801115cc,%eax
801013c2:	50                   	push   %eax
801013c3:	ff 75 d8             	push   -0x28(%ebp)
801013c6:	e8 05 ed ff ff       	call   801000d0 <bread>
801013cb:	83 c4 10             	add    $0x10,%esp
801013ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013d1:	a1 b4 15 11 80       	mov    0x801115b4,%eax
801013d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801013d9:	31 c0                	xor    %eax,%eax
801013db:	eb 2f                	jmp    8010140c <balloc+0x7c>
801013dd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801013e0:	89 c1                	mov    %eax,%ecx
801013e2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801013ea:	83 e1 07             	and    $0x7,%ecx
801013ed:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013ef:	89 c1                	mov    %eax,%ecx
801013f1:	c1 f9 03             	sar    $0x3,%ecx
801013f4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801013f9:	89 fa                	mov    %edi,%edx
801013fb:	85 df                	test   %ebx,%edi
801013fd:	74 41                	je     80101440 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013ff:	83 c0 01             	add    $0x1,%eax
80101402:	83 c6 01             	add    $0x1,%esi
80101405:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010140a:	74 05                	je     80101411 <balloc+0x81>
8010140c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010140f:	77 cf                	ja     801013e0 <balloc+0x50>
    brelse(bp);
80101411:	83 ec 0c             	sub    $0xc,%esp
80101414:	ff 75 e4             	push   -0x1c(%ebp)
80101417:	e8 d4 ed ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010141c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101423:	83 c4 10             	add    $0x10,%esp
80101426:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101429:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
8010142f:	77 80                	ja     801013b1 <balloc+0x21>
  panic("balloc: out of blocks");
80101431:	83 ec 0c             	sub    $0xc,%esp
80101434:	68 ea 73 10 80       	push   $0x801073ea
80101439:	e8 42 ef ff ff       	call   80100380 <panic>
8010143e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101440:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101443:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101446:	09 da                	or     %ebx,%edx
80101448:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010144c:	57                   	push   %edi
8010144d:	e8 3e 1c 00 00       	call   80103090 <log_write>
        brelse(bp);
80101452:	89 3c 24             	mov    %edi,(%esp)
80101455:	e8 96 ed ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010145a:	58                   	pop    %eax
8010145b:	5a                   	pop    %edx
8010145c:	56                   	push   %esi
8010145d:	ff 75 d8             	push   -0x28(%ebp)
80101460:	e8 6b ec ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101465:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101468:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010146a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010146d:	68 00 02 00 00       	push   $0x200
80101472:	6a 00                	push   $0x0
80101474:	50                   	push   %eax
80101475:	e8 36 33 00 00       	call   801047b0 <memset>
  log_write(bp);
8010147a:	89 1c 24             	mov    %ebx,(%esp)
8010147d:	e8 0e 1c 00 00       	call   80103090 <log_write>
  brelse(bp);
80101482:	89 1c 24             	mov    %ebx,(%esp)
80101485:	e8 66 ed ff ff       	call   801001f0 <brelse>
}
8010148a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010148d:	89 f0                	mov    %esi,%eax
8010148f:	5b                   	pop    %ebx
80101490:	5e                   	pop    %esi
80101491:	5f                   	pop    %edi
80101492:	5d                   	pop    %ebp
80101493:	c3                   	ret    
80101494:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010149b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop

801014a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	89 c7                	mov    %eax,%edi
801014a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801014a7:	31 f6                	xor    %esi,%esi
{
801014a9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014aa:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
801014af:	83 ec 28             	sub    $0x28,%esp
801014b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801014b5:	68 60 f9 10 80       	push   $0x8010f960
801014ba:	e8 31 32 00 00       	call   801046f0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801014c2:	83 c4 10             	add    $0x10,%esp
801014c5:	eb 1b                	jmp    801014e2 <iget+0x42>
801014c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ce:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014d0:	39 3b                	cmp    %edi,(%ebx)
801014d2:	74 6c                	je     80101540 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014d4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014da:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801014e0:	73 26                	jae    80101508 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014e2:	8b 43 08             	mov    0x8(%ebx),%eax
801014e5:	85 c0                	test   %eax,%eax
801014e7:	7f e7                	jg     801014d0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801014e9:	85 f6                	test   %esi,%esi
801014eb:	75 e7                	jne    801014d4 <iget+0x34>
801014ed:	85 c0                	test   %eax,%eax
801014ef:	75 76                	jne    80101567 <iget+0xc7>
801014f1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014f3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014f9:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801014ff:	72 e1                	jb     801014e2 <iget+0x42>
80101501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101508:	85 f6                	test   %esi,%esi
8010150a:	74 79                	je     80101585 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010150c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010150f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101511:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101514:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010151b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101522:	68 60 f9 10 80       	push   $0x8010f960
80101527:	e8 64 31 00 00       	call   80104690 <release>

  return ip;
8010152c:	83 c4 10             	add    $0x10,%esp
}
8010152f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101532:	89 f0                	mov    %esi,%eax
80101534:	5b                   	pop    %ebx
80101535:	5e                   	pop    %esi
80101536:	5f                   	pop    %edi
80101537:	5d                   	pop    %ebp
80101538:	c3                   	ret    
80101539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101540:	39 53 04             	cmp    %edx,0x4(%ebx)
80101543:	75 8f                	jne    801014d4 <iget+0x34>
      release(&icache.lock);
80101545:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101548:	83 c0 01             	add    $0x1,%eax
      return ip;
8010154b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010154d:	68 60 f9 10 80       	push   $0x8010f960
      ip->ref++;
80101552:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101555:	e8 36 31 00 00       	call   80104690 <release>
      return ip;
8010155a:	83 c4 10             	add    $0x10,%esp
}
8010155d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101560:	89 f0                	mov    %esi,%eax
80101562:	5b                   	pop    %ebx
80101563:	5e                   	pop    %esi
80101564:	5f                   	pop    %edi
80101565:	5d                   	pop    %ebp
80101566:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101567:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010156d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101573:	73 10                	jae    80101585 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101575:	8b 43 08             	mov    0x8(%ebx),%eax
80101578:	85 c0                	test   %eax,%eax
8010157a:	0f 8f 50 ff ff ff    	jg     801014d0 <iget+0x30>
80101580:	e9 68 ff ff ff       	jmp    801014ed <iget+0x4d>
    panic("iget: no inodes");
80101585:	83 ec 0c             	sub    $0xc,%esp
80101588:	68 00 74 10 80       	push   $0x80107400
8010158d:	e8 ee ed ff ff       	call   80100380 <panic>
80101592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801015a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	57                   	push   %edi
801015a4:	56                   	push   %esi
801015a5:	89 c6                	mov    %eax,%esi
801015a7:	53                   	push   %ebx
801015a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801015ab:	83 fa 0b             	cmp    $0xb,%edx
801015ae:	0f 86 8c 00 00 00    	jbe    80101640 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801015b4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801015b7:	83 fb 7f             	cmp    $0x7f,%ebx
801015ba:	0f 87 a2 00 00 00    	ja     80101662 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801015c0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801015c6:	85 c0                	test   %eax,%eax
801015c8:	74 5e                	je     80101628 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801015ca:	83 ec 08             	sub    $0x8,%esp
801015cd:	50                   	push   %eax
801015ce:	ff 36                	push   (%esi)
801015d0:	e8 fb ea ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801015d5:	83 c4 10             	add    $0x10,%esp
801015d8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801015dc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801015de:	8b 3b                	mov    (%ebx),%edi
801015e0:	85 ff                	test   %edi,%edi
801015e2:	74 1c                	je     80101600 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801015e4:	83 ec 0c             	sub    $0xc,%esp
801015e7:	52                   	push   %edx
801015e8:	e8 03 ec ff ff       	call   801001f0 <brelse>
801015ed:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801015f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015f3:	89 f8                	mov    %edi,%eax
801015f5:	5b                   	pop    %ebx
801015f6:	5e                   	pop    %esi
801015f7:	5f                   	pop    %edi
801015f8:	5d                   	pop    %ebp
801015f9:	c3                   	ret    
801015fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101600:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101603:	8b 06                	mov    (%esi),%eax
80101605:	e8 86 fd ff ff       	call   80101390 <balloc>
      log_write(bp);
8010160a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010160d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101610:	89 03                	mov    %eax,(%ebx)
80101612:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101614:	52                   	push   %edx
80101615:	e8 76 1a 00 00       	call   80103090 <log_write>
8010161a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010161d:	83 c4 10             	add    $0x10,%esp
80101620:	eb c2                	jmp    801015e4 <bmap+0x44>
80101622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101628:	8b 06                	mov    (%esi),%eax
8010162a:	e8 61 fd ff ff       	call   80101390 <balloc>
8010162f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101635:	eb 93                	jmp    801015ca <bmap+0x2a>
80101637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101640:	8d 5a 14             	lea    0x14(%edx),%ebx
80101643:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101647:	85 ff                	test   %edi,%edi
80101649:	75 a5                	jne    801015f0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010164b:	8b 00                	mov    (%eax),%eax
8010164d:	e8 3e fd ff ff       	call   80101390 <balloc>
80101652:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101656:	89 c7                	mov    %eax,%edi
}
80101658:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010165b:	5b                   	pop    %ebx
8010165c:	89 f8                	mov    %edi,%eax
8010165e:	5e                   	pop    %esi
8010165f:	5f                   	pop    %edi
80101660:	5d                   	pop    %ebp
80101661:	c3                   	ret    
  panic("bmap: out of range");
80101662:	83 ec 0c             	sub    $0xc,%esp
80101665:	68 10 74 10 80       	push   $0x80107410
8010166a:	e8 11 ed ff ff       	call   80100380 <panic>
8010166f:	90                   	nop

80101670 <readsb>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101678:	83 ec 08             	sub    $0x8,%esp
8010167b:	6a 01                	push   $0x1
8010167d:	ff 75 08             	push   0x8(%ebp)
80101680:	e8 4b ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101685:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101688:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010168a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010168d:	6a 1c                	push   $0x1c
8010168f:	50                   	push   %eax
80101690:	56                   	push   %esi
80101691:	e8 ba 31 00 00       	call   80104850 <memmove>
  brelse(bp);
80101696:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101699:	83 c4 10             	add    $0x10,%esp
}
8010169c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010169f:	5b                   	pop    %ebx
801016a0:	5e                   	pop    %esi
801016a1:	5d                   	pop    %ebp
  brelse(bp);
801016a2:	e9 49 eb ff ff       	jmp    801001f0 <brelse>
801016a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016ae:	66 90                	xchg   %ax,%ax

801016b0 <iinit>:
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	53                   	push   %ebx
801016b4:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
801016b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801016bc:	68 23 74 10 80       	push   $0x80107423
801016c1:	68 60 f9 10 80       	push   $0x8010f960
801016c6:	e8 55 2e 00 00       	call   80104520 <initlock>
  for(i = 0; i < NINODE; i++) {
801016cb:	83 c4 10             	add    $0x10,%esp
801016ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801016d0:	83 ec 08             	sub    $0x8,%esp
801016d3:	68 2a 74 10 80       	push   $0x8010742a
801016d8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801016d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801016df:	e8 0c 2d 00 00       	call   801043f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801016e4:	83 c4 10             	add    $0x10,%esp
801016e7:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
801016ed:	75 e1                	jne    801016d0 <iinit+0x20>
  bp = bread(dev, 1);
801016ef:	83 ec 08             	sub    $0x8,%esp
801016f2:	6a 01                	push   $0x1
801016f4:	ff 75 08             	push   0x8(%ebp)
801016f7:	e8 d4 e9 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801016fc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801016ff:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101701:	8d 40 5c             	lea    0x5c(%eax),%eax
80101704:	6a 1c                	push   $0x1c
80101706:	50                   	push   %eax
80101707:	68 b4 15 11 80       	push   $0x801115b4
8010170c:	e8 3f 31 00 00       	call   80104850 <memmove>
  brelse(bp);
80101711:	89 1c 24             	mov    %ebx,(%esp)
80101714:	e8 d7 ea ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101719:	ff 35 cc 15 11 80    	push   0x801115cc
8010171f:	ff 35 c8 15 11 80    	push   0x801115c8
80101725:	ff 35 c4 15 11 80    	push   0x801115c4
8010172b:	ff 35 c0 15 11 80    	push   0x801115c0
80101731:	ff 35 bc 15 11 80    	push   0x801115bc
80101737:	ff 35 b8 15 11 80    	push   0x801115b8
8010173d:	ff 35 b4 15 11 80    	push   0x801115b4
80101743:	68 90 74 10 80       	push   $0x80107490
80101748:	e8 53 ef ff ff       	call   801006a0 <cprintf>
}
8010174d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101750:	83 c4 30             	add    $0x30,%esp
80101753:	c9                   	leave  
80101754:	c3                   	ret    
80101755:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010175c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101760 <ialloc>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	57                   	push   %edi
80101764:	56                   	push   %esi
80101765:	53                   	push   %ebx
80101766:	83 ec 1c             	sub    $0x1c,%esp
80101769:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010176c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101773:	8b 75 08             	mov    0x8(%ebp),%esi
80101776:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101779:	0f 86 91 00 00 00    	jbe    80101810 <ialloc+0xb0>
8010177f:	bf 01 00 00 00       	mov    $0x1,%edi
80101784:	eb 21                	jmp    801017a7 <ialloc+0x47>
80101786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010178d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101790:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101793:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101796:	53                   	push   %ebx
80101797:	e8 54 ea ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010179c:	83 c4 10             	add    $0x10,%esp
8010179f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
801017a5:	73 69                	jae    80101810 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801017a7:	89 f8                	mov    %edi,%eax
801017a9:	83 ec 08             	sub    $0x8,%esp
801017ac:	c1 e8 03             	shr    $0x3,%eax
801017af:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017b5:	50                   	push   %eax
801017b6:	56                   	push   %esi
801017b7:	e8 14 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801017bc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801017bf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801017c1:	89 f8                	mov    %edi,%eax
801017c3:	83 e0 07             	and    $0x7,%eax
801017c6:	c1 e0 06             	shl    $0x6,%eax
801017c9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801017cd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801017d1:	75 bd                	jne    80101790 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801017d3:	83 ec 04             	sub    $0x4,%esp
801017d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801017d9:	6a 40                	push   $0x40
801017db:	6a 00                	push   $0x0
801017dd:	51                   	push   %ecx
801017de:	e8 cd 2f 00 00       	call   801047b0 <memset>
      dip->type = type;
801017e3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017ea:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017ed:	89 1c 24             	mov    %ebx,(%esp)
801017f0:	e8 9b 18 00 00       	call   80103090 <log_write>
      brelse(bp);
801017f5:	89 1c 24             	mov    %ebx,(%esp)
801017f8:	e8 f3 e9 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801017fd:	83 c4 10             	add    $0x10,%esp
}
80101800:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101803:	89 fa                	mov    %edi,%edx
}
80101805:	5b                   	pop    %ebx
      return iget(dev, inum);
80101806:	89 f0                	mov    %esi,%eax
}
80101808:	5e                   	pop    %esi
80101809:	5f                   	pop    %edi
8010180a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010180b:	e9 90 fc ff ff       	jmp    801014a0 <iget>
  panic("ialloc: no inodes");
80101810:	83 ec 0c             	sub    $0xc,%esp
80101813:	68 30 74 10 80       	push   $0x80107430
80101818:	e8 63 eb ff ff       	call   80100380 <panic>
8010181d:	8d 76 00             	lea    0x0(%esi),%esi

80101820 <iupdate>:
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	56                   	push   %esi
80101824:	53                   	push   %ebx
80101825:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101828:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010182b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010182e:	83 ec 08             	sub    $0x8,%esp
80101831:	c1 e8 03             	shr    $0x3,%eax
80101834:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010183a:	50                   	push   %eax
8010183b:	ff 73 a4             	push   -0x5c(%ebx)
8010183e:	e8 8d e8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101843:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101847:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010184a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010184c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010184f:	83 e0 07             	and    $0x7,%eax
80101852:	c1 e0 06             	shl    $0x6,%eax
80101855:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101859:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010185c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101860:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101863:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101867:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010186b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010186f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101873:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101877:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010187a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010187d:	6a 34                	push   $0x34
8010187f:	53                   	push   %ebx
80101880:	50                   	push   %eax
80101881:	e8 ca 2f 00 00       	call   80104850 <memmove>
  log_write(bp);
80101886:	89 34 24             	mov    %esi,(%esp)
80101889:	e8 02 18 00 00       	call   80103090 <log_write>
  brelse(bp);
8010188e:	89 75 08             	mov    %esi,0x8(%ebp)
80101891:	83 c4 10             	add    $0x10,%esp
}
80101894:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101897:	5b                   	pop    %ebx
80101898:	5e                   	pop    %esi
80101899:	5d                   	pop    %ebp
  brelse(bp);
8010189a:	e9 51 e9 ff ff       	jmp    801001f0 <brelse>
8010189f:	90                   	nop

801018a0 <idup>:
{
801018a0:	55                   	push   %ebp
801018a1:	89 e5                	mov    %esp,%ebp
801018a3:	53                   	push   %ebx
801018a4:	83 ec 10             	sub    $0x10,%esp
801018a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801018aa:	68 60 f9 10 80       	push   $0x8010f960
801018af:	e8 3c 2e 00 00       	call   801046f0 <acquire>
  ip->ref++;
801018b4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018b8:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801018bf:	e8 cc 2d 00 00       	call   80104690 <release>
}
801018c4:	89 d8                	mov    %ebx,%eax
801018c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018c9:	c9                   	leave  
801018ca:	c3                   	ret    
801018cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018cf:	90                   	nop

801018d0 <ilock>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	56                   	push   %esi
801018d4:	53                   	push   %ebx
801018d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801018d8:	85 db                	test   %ebx,%ebx
801018da:	0f 84 b7 00 00 00    	je     80101997 <ilock+0xc7>
801018e0:	8b 53 08             	mov    0x8(%ebx),%edx
801018e3:	85 d2                	test   %edx,%edx
801018e5:	0f 8e ac 00 00 00    	jle    80101997 <ilock+0xc7>
  acquiresleep(&ip->lock);
801018eb:	83 ec 0c             	sub    $0xc,%esp
801018ee:	8d 43 0c             	lea    0xc(%ebx),%eax
801018f1:	50                   	push   %eax
801018f2:	e8 39 2b 00 00       	call   80104430 <acquiresleep>
  if(ip->valid == 0){
801018f7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018fa:	83 c4 10             	add    $0x10,%esp
801018fd:	85 c0                	test   %eax,%eax
801018ff:	74 0f                	je     80101910 <ilock+0x40>
}
80101901:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101904:	5b                   	pop    %ebx
80101905:	5e                   	pop    %esi
80101906:	5d                   	pop    %ebp
80101907:	c3                   	ret    
80101908:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010190f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101910:	8b 43 04             	mov    0x4(%ebx),%eax
80101913:	83 ec 08             	sub    $0x8,%esp
80101916:	c1 e8 03             	shr    $0x3,%eax
80101919:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010191f:	50                   	push   %eax
80101920:	ff 33                	push   (%ebx)
80101922:	e8 a9 e7 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101927:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010192a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010192c:	8b 43 04             	mov    0x4(%ebx),%eax
8010192f:	83 e0 07             	and    $0x7,%eax
80101932:	c1 e0 06             	shl    $0x6,%eax
80101935:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101939:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010193c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010193f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101943:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101947:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010194b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010194f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101953:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101957:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010195b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010195e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101961:	6a 34                	push   $0x34
80101963:	50                   	push   %eax
80101964:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101967:	50                   	push   %eax
80101968:	e8 e3 2e 00 00       	call   80104850 <memmove>
    brelse(bp);
8010196d:	89 34 24             	mov    %esi,(%esp)
80101970:	e8 7b e8 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101975:	83 c4 10             	add    $0x10,%esp
80101978:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010197d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101984:	0f 85 77 ff ff ff    	jne    80101901 <ilock+0x31>
      panic("ilock: no type");
8010198a:	83 ec 0c             	sub    $0xc,%esp
8010198d:	68 48 74 10 80       	push   $0x80107448
80101992:	e8 e9 e9 ff ff       	call   80100380 <panic>
    panic("ilock");
80101997:	83 ec 0c             	sub    $0xc,%esp
8010199a:	68 42 74 10 80       	push   $0x80107442
8010199f:	e8 dc e9 ff ff       	call   80100380 <panic>
801019a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019af:	90                   	nop

801019b0 <iunlock>:
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	56                   	push   %esi
801019b4:	53                   	push   %ebx
801019b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801019b8:	85 db                	test   %ebx,%ebx
801019ba:	74 28                	je     801019e4 <iunlock+0x34>
801019bc:	83 ec 0c             	sub    $0xc,%esp
801019bf:	8d 73 0c             	lea    0xc(%ebx),%esi
801019c2:	56                   	push   %esi
801019c3:	e8 08 2b 00 00       	call   801044d0 <holdingsleep>
801019c8:	83 c4 10             	add    $0x10,%esp
801019cb:	85 c0                	test   %eax,%eax
801019cd:	74 15                	je     801019e4 <iunlock+0x34>
801019cf:	8b 43 08             	mov    0x8(%ebx),%eax
801019d2:	85 c0                	test   %eax,%eax
801019d4:	7e 0e                	jle    801019e4 <iunlock+0x34>
  releasesleep(&ip->lock);
801019d6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801019d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019dc:	5b                   	pop    %ebx
801019dd:	5e                   	pop    %esi
801019de:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801019df:	e9 ac 2a 00 00       	jmp    80104490 <releasesleep>
    panic("iunlock");
801019e4:	83 ec 0c             	sub    $0xc,%esp
801019e7:	68 57 74 10 80       	push   $0x80107457
801019ec:	e8 8f e9 ff ff       	call   80100380 <panic>
801019f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ff:	90                   	nop

80101a00 <iput>:
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	57                   	push   %edi
80101a04:	56                   	push   %esi
80101a05:	53                   	push   %ebx
80101a06:	83 ec 28             	sub    $0x28,%esp
80101a09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101a0c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101a0f:	57                   	push   %edi
80101a10:	e8 1b 2a 00 00       	call   80104430 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101a15:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101a18:	83 c4 10             	add    $0x10,%esp
80101a1b:	85 d2                	test   %edx,%edx
80101a1d:	74 07                	je     80101a26 <iput+0x26>
80101a1f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101a24:	74 32                	je     80101a58 <iput+0x58>
  releasesleep(&ip->lock);
80101a26:	83 ec 0c             	sub    $0xc,%esp
80101a29:	57                   	push   %edi
80101a2a:	e8 61 2a 00 00       	call   80104490 <releasesleep>
  acquire(&icache.lock);
80101a2f:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101a36:	e8 b5 2c 00 00       	call   801046f0 <acquire>
  ip->ref--;
80101a3b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a3f:	83 c4 10             	add    $0x10,%esp
80101a42:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101a49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4c:	5b                   	pop    %ebx
80101a4d:	5e                   	pop    %esi
80101a4e:	5f                   	pop    %edi
80101a4f:	5d                   	pop    %ebp
  release(&icache.lock);
80101a50:	e9 3b 2c 00 00       	jmp    80104690 <release>
80101a55:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a58:	83 ec 0c             	sub    $0xc,%esp
80101a5b:	68 60 f9 10 80       	push   $0x8010f960
80101a60:	e8 8b 2c 00 00       	call   801046f0 <acquire>
    int r = ip->ref;
80101a65:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a68:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101a6f:	e8 1c 2c 00 00       	call   80104690 <release>
    if(r == 1){
80101a74:	83 c4 10             	add    $0x10,%esp
80101a77:	83 fe 01             	cmp    $0x1,%esi
80101a7a:	75 aa                	jne    80101a26 <iput+0x26>
80101a7c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a82:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a85:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a88:	89 cf                	mov    %ecx,%edi
80101a8a:	eb 0b                	jmp    80101a97 <iput+0x97>
80101a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a90:	83 c6 04             	add    $0x4,%esi
80101a93:	39 fe                	cmp    %edi,%esi
80101a95:	74 19                	je     80101ab0 <iput+0xb0>
    if(ip->addrs[i]){
80101a97:	8b 16                	mov    (%esi),%edx
80101a99:	85 d2                	test   %edx,%edx
80101a9b:	74 f3                	je     80101a90 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a9d:	8b 03                	mov    (%ebx),%eax
80101a9f:	e8 6c f8 ff ff       	call   80101310 <bfree>
      ip->addrs[i] = 0;
80101aa4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101aaa:	eb e4                	jmp    80101a90 <iput+0x90>
80101aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101ab0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101ab6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101ab9:	85 c0                	test   %eax,%eax
80101abb:	75 2d                	jne    80101aea <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101abd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101ac0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101ac7:	53                   	push   %ebx
80101ac8:	e8 53 fd ff ff       	call   80101820 <iupdate>
      ip->type = 0;
80101acd:	31 c0                	xor    %eax,%eax
80101acf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101ad3:	89 1c 24             	mov    %ebx,(%esp)
80101ad6:	e8 45 fd ff ff       	call   80101820 <iupdate>
      ip->valid = 0;
80101adb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101ae2:	83 c4 10             	add    $0x10,%esp
80101ae5:	e9 3c ff ff ff       	jmp    80101a26 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101aea:	83 ec 08             	sub    $0x8,%esp
80101aed:	50                   	push   %eax
80101aee:	ff 33                	push   (%ebx)
80101af0:	e8 db e5 ff ff       	call   801000d0 <bread>
80101af5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101af8:	83 c4 10             	add    $0x10,%esp
80101afb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101b01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101b04:	8d 70 5c             	lea    0x5c(%eax),%esi
80101b07:	89 cf                	mov    %ecx,%edi
80101b09:	eb 0c                	jmp    80101b17 <iput+0x117>
80101b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b0f:	90                   	nop
80101b10:	83 c6 04             	add    $0x4,%esi
80101b13:	39 f7                	cmp    %esi,%edi
80101b15:	74 0f                	je     80101b26 <iput+0x126>
      if(a[j])
80101b17:	8b 16                	mov    (%esi),%edx
80101b19:	85 d2                	test   %edx,%edx
80101b1b:	74 f3                	je     80101b10 <iput+0x110>
        bfree(ip->dev, a[j]);
80101b1d:	8b 03                	mov    (%ebx),%eax
80101b1f:	e8 ec f7 ff ff       	call   80101310 <bfree>
80101b24:	eb ea                	jmp    80101b10 <iput+0x110>
    brelse(bp);
80101b26:	83 ec 0c             	sub    $0xc,%esp
80101b29:	ff 75 e4             	push   -0x1c(%ebp)
80101b2c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b2f:	e8 bc e6 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b34:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101b3a:	8b 03                	mov    (%ebx),%eax
80101b3c:	e8 cf f7 ff ff       	call   80101310 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b41:	83 c4 10             	add    $0x10,%esp
80101b44:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b4b:	00 00 00 
80101b4e:	e9 6a ff ff ff       	jmp    80101abd <iput+0xbd>
80101b53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101b60 <iunlockput>:
{
80101b60:	55                   	push   %ebp
80101b61:	89 e5                	mov    %esp,%ebp
80101b63:	56                   	push   %esi
80101b64:	53                   	push   %ebx
80101b65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b68:	85 db                	test   %ebx,%ebx
80101b6a:	74 34                	je     80101ba0 <iunlockput+0x40>
80101b6c:	83 ec 0c             	sub    $0xc,%esp
80101b6f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b72:	56                   	push   %esi
80101b73:	e8 58 29 00 00       	call   801044d0 <holdingsleep>
80101b78:	83 c4 10             	add    $0x10,%esp
80101b7b:	85 c0                	test   %eax,%eax
80101b7d:	74 21                	je     80101ba0 <iunlockput+0x40>
80101b7f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b82:	85 c0                	test   %eax,%eax
80101b84:	7e 1a                	jle    80101ba0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101b86:	83 ec 0c             	sub    $0xc,%esp
80101b89:	56                   	push   %esi
80101b8a:	e8 01 29 00 00       	call   80104490 <releasesleep>
  iput(ip);
80101b8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b92:	83 c4 10             	add    $0x10,%esp
}
80101b95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b98:	5b                   	pop    %ebx
80101b99:	5e                   	pop    %esi
80101b9a:	5d                   	pop    %ebp
  iput(ip);
80101b9b:	e9 60 fe ff ff       	jmp    80101a00 <iput>
    panic("iunlock");
80101ba0:	83 ec 0c             	sub    $0xc,%esp
80101ba3:	68 57 74 10 80       	push   $0x80107457
80101ba8:	e8 d3 e7 ff ff       	call   80100380 <panic>
80101bad:	8d 76 00             	lea    0x0(%esi),%esi

80101bb0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	8b 55 08             	mov    0x8(%ebp),%edx
80101bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101bb9:	8b 0a                	mov    (%edx),%ecx
80101bbb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101bbe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101bc1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101bc4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101bc8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101bcb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101bcf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101bd3:	8b 52 58             	mov    0x58(%edx),%edx
80101bd6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101bd9:	5d                   	pop    %ebp
80101bda:	c3                   	ret    
80101bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bdf:	90                   	nop

80101be0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 1c             	sub    $0x1c,%esp
80101be9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bec:	8b 45 08             	mov    0x8(%ebp),%eax
80101bef:	8b 75 10             	mov    0x10(%ebp),%esi
80101bf2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101bf5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bf8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bfd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c00:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101c03:	0f 84 a7 00 00 00    	je     80101cb0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101c09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c0c:	8b 40 58             	mov    0x58(%eax),%eax
80101c0f:	39 c6                	cmp    %eax,%esi
80101c11:	0f 87 ba 00 00 00    	ja     80101cd1 <readi+0xf1>
80101c17:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c1a:	31 c9                	xor    %ecx,%ecx
80101c1c:	89 da                	mov    %ebx,%edx
80101c1e:	01 f2                	add    %esi,%edx
80101c20:	0f 92 c1             	setb   %cl
80101c23:	89 cf                	mov    %ecx,%edi
80101c25:	0f 82 a6 00 00 00    	jb     80101cd1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c2b:	89 c1                	mov    %eax,%ecx
80101c2d:	29 f1                	sub    %esi,%ecx
80101c2f:	39 d0                	cmp    %edx,%eax
80101c31:	0f 43 cb             	cmovae %ebx,%ecx
80101c34:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c37:	85 c9                	test   %ecx,%ecx
80101c39:	74 67                	je     80101ca2 <readi+0xc2>
80101c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c3f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c40:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c43:	89 f2                	mov    %esi,%edx
80101c45:	c1 ea 09             	shr    $0x9,%edx
80101c48:	89 d8                	mov    %ebx,%eax
80101c4a:	e8 51 f9 ff ff       	call   801015a0 <bmap>
80101c4f:	83 ec 08             	sub    $0x8,%esp
80101c52:	50                   	push   %eax
80101c53:	ff 33                	push   (%ebx)
80101c55:	e8 76 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c5d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c62:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c64:	89 f0                	mov    %esi,%eax
80101c66:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c6b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c6d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c70:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c72:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c76:	39 d9                	cmp    %ebx,%ecx
80101c78:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c7b:	83 c4 0c             	add    $0xc,%esp
80101c7e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c7f:	01 df                	add    %ebx,%edi
80101c81:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101c83:	50                   	push   %eax
80101c84:	ff 75 e0             	push   -0x20(%ebp)
80101c87:	e8 c4 2b 00 00       	call   80104850 <memmove>
    brelse(bp);
80101c8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c8f:	89 14 24             	mov    %edx,(%esp)
80101c92:	e8 59 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c97:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c9a:	83 c4 10             	add    $0x10,%esp
80101c9d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ca0:	77 9e                	ja     80101c40 <readi+0x60>
  }
  return n;
80101ca2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ca5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ca8:	5b                   	pop    %ebx
80101ca9:	5e                   	pop    %esi
80101caa:	5f                   	pop    %edi
80101cab:	5d                   	pop    %ebp
80101cac:	c3                   	ret    
80101cad:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101cb0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cb4:	66 83 f8 09          	cmp    $0x9,%ax
80101cb8:	77 17                	ja     80101cd1 <readi+0xf1>
80101cba:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101cc1:	85 c0                	test   %eax,%eax
80101cc3:	74 0c                	je     80101cd1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101cc5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ccb:	5b                   	pop    %ebx
80101ccc:	5e                   	pop    %esi
80101ccd:	5f                   	pop    %edi
80101cce:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101ccf:	ff e0                	jmp    *%eax
      return -1;
80101cd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cd6:	eb cd                	jmp    80101ca5 <readi+0xc5>
80101cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdf:	90                   	nop

80101ce0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cec:	8b 75 0c             	mov    0xc(%ebp),%esi
80101cef:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cf2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101cf7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101cfa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cfd:	8b 75 10             	mov    0x10(%ebp),%esi
80101d00:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101d03:	0f 84 b7 00 00 00    	je     80101dc0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101d09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d0c:	3b 70 58             	cmp    0x58(%eax),%esi
80101d0f:	0f 87 e7 00 00 00    	ja     80101dfc <writei+0x11c>
80101d15:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d18:	31 d2                	xor    %edx,%edx
80101d1a:	89 f8                	mov    %edi,%eax
80101d1c:	01 f0                	add    %esi,%eax
80101d1e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101d21:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101d26:	0f 87 d0 00 00 00    	ja     80101dfc <writei+0x11c>
80101d2c:	85 d2                	test   %edx,%edx
80101d2e:	0f 85 c8 00 00 00    	jne    80101dfc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d34:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101d3b:	85 ff                	test   %edi,%edi
80101d3d:	74 72                	je     80101db1 <writei+0xd1>
80101d3f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d40:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d43:	89 f2                	mov    %esi,%edx
80101d45:	c1 ea 09             	shr    $0x9,%edx
80101d48:	89 f8                	mov    %edi,%eax
80101d4a:	e8 51 f8 ff ff       	call   801015a0 <bmap>
80101d4f:	83 ec 08             	sub    $0x8,%esp
80101d52:	50                   	push   %eax
80101d53:	ff 37                	push   (%edi)
80101d55:	e8 76 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d5a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d5f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d62:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d65:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d67:	89 f0                	mov    %esi,%eax
80101d69:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d6e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d70:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d74:	39 d9                	cmp    %ebx,%ecx
80101d76:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d79:	83 c4 0c             	add    $0xc,%esp
80101d7c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d7d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101d7f:	ff 75 dc             	push   -0x24(%ebp)
80101d82:	50                   	push   %eax
80101d83:	e8 c8 2a 00 00       	call   80104850 <memmove>
    log_write(bp);
80101d88:	89 3c 24             	mov    %edi,(%esp)
80101d8b:	e8 00 13 00 00       	call   80103090 <log_write>
    brelse(bp);
80101d90:	89 3c 24             	mov    %edi,(%esp)
80101d93:	e8 58 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d98:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d9b:	83 c4 10             	add    $0x10,%esp
80101d9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101da1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101da4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101da7:	77 97                	ja     80101d40 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101da9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101dac:	3b 70 58             	cmp    0x58(%eax),%esi
80101daf:	77 37                	ja     80101de8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101db1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db7:	5b                   	pop    %ebx
80101db8:	5e                   	pop    %esi
80101db9:	5f                   	pop    %edi
80101dba:	5d                   	pop    %ebp
80101dbb:	c3                   	ret    
80101dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101dc0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101dc4:	66 83 f8 09          	cmp    $0x9,%ax
80101dc8:	77 32                	ja     80101dfc <writei+0x11c>
80101dca:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101dd1:	85 c0                	test   %eax,%eax
80101dd3:	74 27                	je     80101dfc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101dd5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101dd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101ddf:	ff e0                	jmp    *%eax
80101de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101de8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101deb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101dee:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101df1:	50                   	push   %eax
80101df2:	e8 29 fa ff ff       	call   80101820 <iupdate>
80101df7:	83 c4 10             	add    $0x10,%esp
80101dfa:	eb b5                	jmp    80101db1 <writei+0xd1>
      return -1;
80101dfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e01:	eb b1                	jmp    80101db4 <writei+0xd4>
80101e03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101e10 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101e16:	6a 0e                	push   $0xe
80101e18:	ff 75 0c             	push   0xc(%ebp)
80101e1b:	ff 75 08             	push   0x8(%ebp)
80101e1e:	e8 9d 2a 00 00       	call   801048c0 <strncmp>
}
80101e23:	c9                   	leave  
80101e24:	c3                   	ret    
80101e25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e30 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 1c             	sub    $0x1c,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101e3c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e41:	0f 85 85 00 00 00    	jne    80101ecc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e47:	8b 53 58             	mov    0x58(%ebx),%edx
80101e4a:	31 ff                	xor    %edi,%edi
80101e4c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4f:	85 d2                	test   %edx,%edx
80101e51:	74 3e                	je     80101e91 <dirlookup+0x61>
80101e53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e57:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 7e fd ff ff       	call   80101be0 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 55                	jne    80101ebf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	74 18                	je     80101e89 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101e71:	83 ec 04             	sub    $0x4,%esp
80101e74:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e77:	6a 0e                	push   $0xe
80101e79:	50                   	push   %eax
80101e7a:	ff 75 0c             	push   0xc(%ebp)
80101e7d:	e8 3e 2a 00 00       	call   801048c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e82:	83 c4 10             	add    $0x10,%esp
80101e85:	85 c0                	test   %eax,%eax
80101e87:	74 17                	je     80101ea0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e89:	83 c7 10             	add    $0x10,%edi
80101e8c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e8f:	72 c7                	jb     80101e58 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e94:	31 c0                	xor    %eax,%eax
}
80101e96:	5b                   	pop    %ebx
80101e97:	5e                   	pop    %esi
80101e98:	5f                   	pop    %edi
80101e99:	5d                   	pop    %ebp
80101e9a:	c3                   	ret    
80101e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e9f:	90                   	nop
      if(poff)
80101ea0:	8b 45 10             	mov    0x10(%ebp),%eax
80101ea3:	85 c0                	test   %eax,%eax
80101ea5:	74 05                	je     80101eac <dirlookup+0x7c>
        *poff = off;
80101ea7:	8b 45 10             	mov    0x10(%ebp),%eax
80101eaa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101eac:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101eb0:	8b 03                	mov    (%ebx),%eax
80101eb2:	e8 e9 f5 ff ff       	call   801014a0 <iget>
}
80101eb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eba:	5b                   	pop    %ebx
80101ebb:	5e                   	pop    %esi
80101ebc:	5f                   	pop    %edi
80101ebd:	5d                   	pop    %ebp
80101ebe:	c3                   	ret    
      panic("dirlookup read");
80101ebf:	83 ec 0c             	sub    $0xc,%esp
80101ec2:	68 71 74 10 80       	push   $0x80107471
80101ec7:	e8 b4 e4 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101ecc:	83 ec 0c             	sub    $0xc,%esp
80101ecf:	68 5f 74 10 80       	push   $0x8010745f
80101ed4:	e8 a7 e4 ff ff       	call   80100380 <panic>
80101ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ee0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ee0:	55                   	push   %ebp
80101ee1:	89 e5                	mov    %esp,%ebp
80101ee3:	57                   	push   %edi
80101ee4:	56                   	push   %esi
80101ee5:	53                   	push   %ebx
80101ee6:	89 c3                	mov    %eax,%ebx
80101ee8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101eeb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101eee:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101ef1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101ef4:	0f 84 64 01 00 00    	je     8010205e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101efa:	e8 c1 1b 00 00       	call   80103ac0 <myproc>
  acquire(&icache.lock);
80101eff:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101f02:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101f05:	68 60 f9 10 80       	push   $0x8010f960
80101f0a:	e8 e1 27 00 00       	call   801046f0 <acquire>
  ip->ref++;
80101f0f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101f13:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101f1a:	e8 71 27 00 00       	call   80104690 <release>
80101f1f:	83 c4 10             	add    $0x10,%esp
80101f22:	eb 07                	jmp    80101f2b <namex+0x4b>
80101f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f28:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f2b:	0f b6 03             	movzbl (%ebx),%eax
80101f2e:	3c 2f                	cmp    $0x2f,%al
80101f30:	74 f6                	je     80101f28 <namex+0x48>
  if(*path == 0)
80101f32:	84 c0                	test   %al,%al
80101f34:	0f 84 06 01 00 00    	je     80102040 <namex+0x160>
  while(*path != '/' && *path != 0)
80101f3a:	0f b6 03             	movzbl (%ebx),%eax
80101f3d:	84 c0                	test   %al,%al
80101f3f:	0f 84 10 01 00 00    	je     80102055 <namex+0x175>
80101f45:	89 df                	mov    %ebx,%edi
80101f47:	3c 2f                	cmp    $0x2f,%al
80101f49:	0f 84 06 01 00 00    	je     80102055 <namex+0x175>
80101f4f:	90                   	nop
80101f50:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101f54:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101f57:	3c 2f                	cmp    $0x2f,%al
80101f59:	74 04                	je     80101f5f <namex+0x7f>
80101f5b:	84 c0                	test   %al,%al
80101f5d:	75 f1                	jne    80101f50 <namex+0x70>
  len = path - s;
80101f5f:	89 f8                	mov    %edi,%eax
80101f61:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101f63:	83 f8 0d             	cmp    $0xd,%eax
80101f66:	0f 8e ac 00 00 00    	jle    80102018 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101f6c:	83 ec 04             	sub    $0x4,%esp
80101f6f:	6a 0e                	push   $0xe
80101f71:	53                   	push   %ebx
    path++;
80101f72:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101f74:	ff 75 e4             	push   -0x1c(%ebp)
80101f77:	e8 d4 28 00 00       	call   80104850 <memmove>
80101f7c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f7f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f82:	75 0c                	jne    80101f90 <namex+0xb0>
80101f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f88:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f8b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f8e:	74 f8                	je     80101f88 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f90:	83 ec 0c             	sub    $0xc,%esp
80101f93:	56                   	push   %esi
80101f94:	e8 37 f9 ff ff       	call   801018d0 <ilock>
    if(ip->type != T_DIR){
80101f99:	83 c4 10             	add    $0x10,%esp
80101f9c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101fa1:	0f 85 cd 00 00 00    	jne    80102074 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101fa7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101faa:	85 c0                	test   %eax,%eax
80101fac:	74 09                	je     80101fb7 <namex+0xd7>
80101fae:	80 3b 00             	cmpb   $0x0,(%ebx)
80101fb1:	0f 84 22 01 00 00    	je     801020d9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101fb7:	83 ec 04             	sub    $0x4,%esp
80101fba:	6a 00                	push   $0x0
80101fbc:	ff 75 e4             	push   -0x1c(%ebp)
80101fbf:	56                   	push   %esi
80101fc0:	e8 6b fe ff ff       	call   80101e30 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fc5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101fc8:	83 c4 10             	add    $0x10,%esp
80101fcb:	89 c7                	mov    %eax,%edi
80101fcd:	85 c0                	test   %eax,%eax
80101fcf:	0f 84 e1 00 00 00    	je     801020b6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fd5:	83 ec 0c             	sub    $0xc,%esp
80101fd8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101fdb:	52                   	push   %edx
80101fdc:	e8 ef 24 00 00       	call   801044d0 <holdingsleep>
80101fe1:	83 c4 10             	add    $0x10,%esp
80101fe4:	85 c0                	test   %eax,%eax
80101fe6:	0f 84 30 01 00 00    	je     8010211c <namex+0x23c>
80101fec:	8b 56 08             	mov    0x8(%esi),%edx
80101fef:	85 d2                	test   %edx,%edx
80101ff1:	0f 8e 25 01 00 00    	jle    8010211c <namex+0x23c>
  releasesleep(&ip->lock);
80101ff7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ffa:	83 ec 0c             	sub    $0xc,%esp
80101ffd:	52                   	push   %edx
80101ffe:	e8 8d 24 00 00       	call   80104490 <releasesleep>
  iput(ip);
80102003:	89 34 24             	mov    %esi,(%esp)
80102006:	89 fe                	mov    %edi,%esi
80102008:	e8 f3 f9 ff ff       	call   80101a00 <iput>
8010200d:	83 c4 10             	add    $0x10,%esp
80102010:	e9 16 ff ff ff       	jmp    80101f2b <namex+0x4b>
80102015:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102018:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010201b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
8010201e:	83 ec 04             	sub    $0x4,%esp
80102021:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102024:	50                   	push   %eax
80102025:	53                   	push   %ebx
    name[len] = 0;
80102026:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102028:	ff 75 e4             	push   -0x1c(%ebp)
8010202b:	e8 20 28 00 00       	call   80104850 <memmove>
    name[len] = 0;
80102030:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102033:	83 c4 10             	add    $0x10,%esp
80102036:	c6 02 00             	movb   $0x0,(%edx)
80102039:	e9 41 ff ff ff       	jmp    80101f7f <namex+0x9f>
8010203e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102040:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102043:	85 c0                	test   %eax,%eax
80102045:	0f 85 be 00 00 00    	jne    80102109 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010204b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010204e:	89 f0                	mov    %esi,%eax
80102050:	5b                   	pop    %ebx
80102051:	5e                   	pop    %esi
80102052:	5f                   	pop    %edi
80102053:	5d                   	pop    %ebp
80102054:	c3                   	ret    
  while(*path != '/' && *path != 0)
80102055:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102058:	89 df                	mov    %ebx,%edi
8010205a:	31 c0                	xor    %eax,%eax
8010205c:	eb c0                	jmp    8010201e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010205e:	ba 01 00 00 00       	mov    $0x1,%edx
80102063:	b8 01 00 00 00       	mov    $0x1,%eax
80102068:	e8 33 f4 ff ff       	call   801014a0 <iget>
8010206d:	89 c6                	mov    %eax,%esi
8010206f:	e9 b7 fe ff ff       	jmp    80101f2b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102074:	83 ec 0c             	sub    $0xc,%esp
80102077:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010207a:	53                   	push   %ebx
8010207b:	e8 50 24 00 00       	call   801044d0 <holdingsleep>
80102080:	83 c4 10             	add    $0x10,%esp
80102083:	85 c0                	test   %eax,%eax
80102085:	0f 84 91 00 00 00    	je     8010211c <namex+0x23c>
8010208b:	8b 46 08             	mov    0x8(%esi),%eax
8010208e:	85 c0                	test   %eax,%eax
80102090:	0f 8e 86 00 00 00    	jle    8010211c <namex+0x23c>
  releasesleep(&ip->lock);
80102096:	83 ec 0c             	sub    $0xc,%esp
80102099:	53                   	push   %ebx
8010209a:	e8 f1 23 00 00       	call   80104490 <releasesleep>
  iput(ip);
8010209f:	89 34 24             	mov    %esi,(%esp)
      return 0;
801020a2:	31 f6                	xor    %esi,%esi
  iput(ip);
801020a4:	e8 57 f9 ff ff       	call   80101a00 <iput>
      return 0;
801020a9:	83 c4 10             	add    $0x10,%esp
}
801020ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020af:	89 f0                	mov    %esi,%eax
801020b1:	5b                   	pop    %ebx
801020b2:	5e                   	pop    %esi
801020b3:	5f                   	pop    %edi
801020b4:	5d                   	pop    %ebp
801020b5:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801020b6:	83 ec 0c             	sub    $0xc,%esp
801020b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801020bc:	52                   	push   %edx
801020bd:	e8 0e 24 00 00       	call   801044d0 <holdingsleep>
801020c2:	83 c4 10             	add    $0x10,%esp
801020c5:	85 c0                	test   %eax,%eax
801020c7:	74 53                	je     8010211c <namex+0x23c>
801020c9:	8b 4e 08             	mov    0x8(%esi),%ecx
801020cc:	85 c9                	test   %ecx,%ecx
801020ce:	7e 4c                	jle    8010211c <namex+0x23c>
  releasesleep(&ip->lock);
801020d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801020d3:	83 ec 0c             	sub    $0xc,%esp
801020d6:	52                   	push   %edx
801020d7:	eb c1                	jmp    8010209a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801020d9:	83 ec 0c             	sub    $0xc,%esp
801020dc:	8d 5e 0c             	lea    0xc(%esi),%ebx
801020df:	53                   	push   %ebx
801020e0:	e8 eb 23 00 00       	call   801044d0 <holdingsleep>
801020e5:	83 c4 10             	add    $0x10,%esp
801020e8:	85 c0                	test   %eax,%eax
801020ea:	74 30                	je     8010211c <namex+0x23c>
801020ec:	8b 7e 08             	mov    0x8(%esi),%edi
801020ef:	85 ff                	test   %edi,%edi
801020f1:	7e 29                	jle    8010211c <namex+0x23c>
  releasesleep(&ip->lock);
801020f3:	83 ec 0c             	sub    $0xc,%esp
801020f6:	53                   	push   %ebx
801020f7:	e8 94 23 00 00       	call   80104490 <releasesleep>
}
801020fc:	83 c4 10             	add    $0x10,%esp
}
801020ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102102:	89 f0                	mov    %esi,%eax
80102104:	5b                   	pop    %ebx
80102105:	5e                   	pop    %esi
80102106:	5f                   	pop    %edi
80102107:	5d                   	pop    %ebp
80102108:	c3                   	ret    
    iput(ip);
80102109:	83 ec 0c             	sub    $0xc,%esp
8010210c:	56                   	push   %esi
    return 0;
8010210d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010210f:	e8 ec f8 ff ff       	call   80101a00 <iput>
    return 0;
80102114:	83 c4 10             	add    $0x10,%esp
80102117:	e9 2f ff ff ff       	jmp    8010204b <namex+0x16b>
    panic("iunlock");
8010211c:	83 ec 0c             	sub    $0xc,%esp
8010211f:	68 57 74 10 80       	push   $0x80107457
80102124:	e8 57 e2 ff ff       	call   80100380 <panic>
80102129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102130 <dirlink>:
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	57                   	push   %edi
80102134:	56                   	push   %esi
80102135:	53                   	push   %ebx
80102136:	83 ec 20             	sub    $0x20,%esp
80102139:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010213c:	6a 00                	push   $0x0
8010213e:	ff 75 0c             	push   0xc(%ebp)
80102141:	53                   	push   %ebx
80102142:	e8 e9 fc ff ff       	call   80101e30 <dirlookup>
80102147:	83 c4 10             	add    $0x10,%esp
8010214a:	85 c0                	test   %eax,%eax
8010214c:	75 67                	jne    801021b5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010214e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102151:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102154:	85 ff                	test   %edi,%edi
80102156:	74 29                	je     80102181 <dirlink+0x51>
80102158:	31 ff                	xor    %edi,%edi
8010215a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010215d:	eb 09                	jmp    80102168 <dirlink+0x38>
8010215f:	90                   	nop
80102160:	83 c7 10             	add    $0x10,%edi
80102163:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102166:	73 19                	jae    80102181 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102168:	6a 10                	push   $0x10
8010216a:	57                   	push   %edi
8010216b:	56                   	push   %esi
8010216c:	53                   	push   %ebx
8010216d:	e8 6e fa ff ff       	call   80101be0 <readi>
80102172:	83 c4 10             	add    $0x10,%esp
80102175:	83 f8 10             	cmp    $0x10,%eax
80102178:	75 4e                	jne    801021c8 <dirlink+0x98>
    if(de.inum == 0)
8010217a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010217f:	75 df                	jne    80102160 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102181:	83 ec 04             	sub    $0x4,%esp
80102184:	8d 45 da             	lea    -0x26(%ebp),%eax
80102187:	6a 0e                	push   $0xe
80102189:	ff 75 0c             	push   0xc(%ebp)
8010218c:	50                   	push   %eax
8010218d:	e8 7e 27 00 00       	call   80104910 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102192:	6a 10                	push   $0x10
  de.inum = inum;
80102194:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102197:	57                   	push   %edi
80102198:	56                   	push   %esi
80102199:	53                   	push   %ebx
  de.inum = inum;
8010219a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010219e:	e8 3d fb ff ff       	call   80101ce0 <writei>
801021a3:	83 c4 20             	add    $0x20,%esp
801021a6:	83 f8 10             	cmp    $0x10,%eax
801021a9:	75 2a                	jne    801021d5 <dirlink+0xa5>
  return 0;
801021ab:	31 c0                	xor    %eax,%eax
}
801021ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021b0:	5b                   	pop    %ebx
801021b1:	5e                   	pop    %esi
801021b2:	5f                   	pop    %edi
801021b3:	5d                   	pop    %ebp
801021b4:	c3                   	ret    
    iput(ip);
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	50                   	push   %eax
801021b9:	e8 42 f8 ff ff       	call   80101a00 <iput>
    return -1;
801021be:	83 c4 10             	add    $0x10,%esp
801021c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021c6:	eb e5                	jmp    801021ad <dirlink+0x7d>
      panic("dirlink read");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 80 74 10 80       	push   $0x80107480
801021d0:	e8 ab e1 ff ff       	call   80100380 <panic>
    panic("dirlink");
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	68 5e 7a 10 80       	push   $0x80107a5e
801021dd:	e8 9e e1 ff ff       	call   80100380 <panic>
801021e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021f0 <namei>:

struct inode*
namei(char *path)
{
801021f0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801021f1:	31 d2                	xor    %edx,%edx
{
801021f3:	89 e5                	mov    %esp,%ebp
801021f5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801021f8:	8b 45 08             	mov    0x8(%ebp),%eax
801021fb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801021fe:	e8 dd fc ff ff       	call   80101ee0 <namex>
}
80102203:	c9                   	leave  
80102204:	c3                   	ret    
80102205:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010220c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102210 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102210:	55                   	push   %ebp
  return namex(path, 1, name);
80102211:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102216:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102218:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010221b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010221e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010221f:	e9 bc fc ff ff       	jmp    80101ee0 <namex>
80102224:	66 90                	xchg   %ax,%ax
80102226:	66 90                	xchg   %ax,%ax
80102228:	66 90                	xchg   %ax,%ax
8010222a:	66 90                	xchg   %ax,%ax
8010222c:	66 90                	xchg   %ax,%ax
8010222e:	66 90                	xchg   %ax,%ax

80102230 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	57                   	push   %edi
80102234:	56                   	push   %esi
80102235:	53                   	push   %ebx
80102236:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102239:	85 c0                	test   %eax,%eax
8010223b:	0f 84 b4 00 00 00    	je     801022f5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102241:	8b 70 08             	mov    0x8(%eax),%esi
80102244:	89 c3                	mov    %eax,%ebx
80102246:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010224c:	0f 87 96 00 00 00    	ja     801022e8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102252:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010225e:	66 90                	xchg   %ax,%ax
80102260:	89 ca                	mov    %ecx,%edx
80102262:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102263:	83 e0 c0             	and    $0xffffffc0,%eax
80102266:	3c 40                	cmp    $0x40,%al
80102268:	75 f6                	jne    80102260 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010226a:	31 ff                	xor    %edi,%edi
8010226c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102271:	89 f8                	mov    %edi,%eax
80102273:	ee                   	out    %al,(%dx)
80102274:	b8 01 00 00 00       	mov    $0x1,%eax
80102279:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010227e:	ee                   	out    %al,(%dx)
8010227f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102284:	89 f0                	mov    %esi,%eax
80102286:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102287:	89 f0                	mov    %esi,%eax
80102289:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010228e:	c1 f8 08             	sar    $0x8,%eax
80102291:	ee                   	out    %al,(%dx)
80102292:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102297:	89 f8                	mov    %edi,%eax
80102299:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010229a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010229e:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022a3:	c1 e0 04             	shl    $0x4,%eax
801022a6:	83 e0 10             	and    $0x10,%eax
801022a9:	83 c8 e0             	or     $0xffffffe0,%eax
801022ac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801022ad:	f6 03 04             	testb  $0x4,(%ebx)
801022b0:	75 16                	jne    801022c8 <idestart+0x98>
801022b2:	b8 20 00 00 00       	mov    $0x20,%eax
801022b7:	89 ca                	mov    %ecx,%edx
801022b9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801022ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022bd:	5b                   	pop    %ebx
801022be:	5e                   	pop    %esi
801022bf:	5f                   	pop    %edi
801022c0:	5d                   	pop    %ebp
801022c1:	c3                   	ret    
801022c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022c8:	b8 30 00 00 00       	mov    $0x30,%eax
801022cd:	89 ca                	mov    %ecx,%edx
801022cf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801022d0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801022d5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801022d8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022dd:	fc                   	cld    
801022de:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801022e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022e3:	5b                   	pop    %ebx
801022e4:	5e                   	pop    %esi
801022e5:	5f                   	pop    %edi
801022e6:	5d                   	pop    %ebp
801022e7:	c3                   	ret    
    panic("incorrect blockno");
801022e8:	83 ec 0c             	sub    $0xc,%esp
801022eb:	68 ec 74 10 80       	push   $0x801074ec
801022f0:	e8 8b e0 ff ff       	call   80100380 <panic>
    panic("idestart");
801022f5:	83 ec 0c             	sub    $0xc,%esp
801022f8:	68 e3 74 10 80       	push   $0x801074e3
801022fd:	e8 7e e0 ff ff       	call   80100380 <panic>
80102302:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102310 <ideinit>:
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102316:	68 fe 74 10 80       	push   $0x801074fe
8010231b:	68 00 16 11 80       	push   $0x80111600
80102320:	e8 fb 21 00 00       	call   80104520 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102325:	58                   	pop    %eax
80102326:	a1 84 17 11 80       	mov    0x80111784,%eax
8010232b:	5a                   	pop    %edx
8010232c:	83 e8 01             	sub    $0x1,%eax
8010232f:	50                   	push   %eax
80102330:	6a 0e                	push   $0xe
80102332:	e8 99 02 00 00       	call   801025d0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102337:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010233a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010233f:	90                   	nop
80102340:	ec                   	in     (%dx),%al
80102341:	83 e0 c0             	and    $0xffffffc0,%eax
80102344:	3c 40                	cmp    $0x40,%al
80102346:	75 f8                	jne    80102340 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102348:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010234d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102352:	ee                   	out    %al,(%dx)
80102353:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102358:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010235d:	eb 06                	jmp    80102365 <ideinit+0x55>
8010235f:	90                   	nop
  for(i=0; i<1000; i++){
80102360:	83 e9 01             	sub    $0x1,%ecx
80102363:	74 0f                	je     80102374 <ideinit+0x64>
80102365:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102366:	84 c0                	test   %al,%al
80102368:	74 f6                	je     80102360 <ideinit+0x50>
      havedisk1 = 1;
8010236a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102371:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102374:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102379:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010237e:	ee                   	out    %al,(%dx)
}
8010237f:	c9                   	leave  
80102380:	c3                   	ret    
80102381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop

80102390 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	57                   	push   %edi
80102394:	56                   	push   %esi
80102395:	53                   	push   %ebx
80102396:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102399:	68 00 16 11 80       	push   $0x80111600
8010239e:	e8 4d 23 00 00       	call   801046f0 <acquire>

  if((b = idequeue) == 0){
801023a3:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
801023a9:	83 c4 10             	add    $0x10,%esp
801023ac:	85 db                	test   %ebx,%ebx
801023ae:	74 63                	je     80102413 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801023b0:	8b 43 58             	mov    0x58(%ebx),%eax
801023b3:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801023b8:	8b 33                	mov    (%ebx),%esi
801023ba:	f7 c6 04 00 00 00    	test   $0x4,%esi
801023c0:	75 2f                	jne    801023f1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023c2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ce:	66 90                	xchg   %ax,%ax
801023d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023d1:	89 c1                	mov    %eax,%ecx
801023d3:	83 e1 c0             	and    $0xffffffc0,%ecx
801023d6:	80 f9 40             	cmp    $0x40,%cl
801023d9:	75 f5                	jne    801023d0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801023db:	a8 21                	test   $0x21,%al
801023dd:	75 12                	jne    801023f1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801023df:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801023e2:	b9 80 00 00 00       	mov    $0x80,%ecx
801023e7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801023ec:	fc                   	cld    
801023ed:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801023ef:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801023f1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801023f4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801023f7:	83 ce 02             	or     $0x2,%esi
801023fa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801023fc:	53                   	push   %ebx
801023fd:	e8 4e 1e 00 00       	call   80104250 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102402:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80102407:	83 c4 10             	add    $0x10,%esp
8010240a:	85 c0                	test   %eax,%eax
8010240c:	74 05                	je     80102413 <ideintr+0x83>
    idestart(idequeue);
8010240e:	e8 1d fe ff ff       	call   80102230 <idestart>
    release(&idelock);
80102413:	83 ec 0c             	sub    $0xc,%esp
80102416:	68 00 16 11 80       	push   $0x80111600
8010241b:	e8 70 22 00 00       	call   80104690 <release>

  release(&idelock);
}
80102420:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102423:	5b                   	pop    %ebx
80102424:	5e                   	pop    %esi
80102425:	5f                   	pop    %edi
80102426:	5d                   	pop    %ebp
80102427:	c3                   	ret    
80102428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242f:	90                   	nop

80102430 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	53                   	push   %ebx
80102434:	83 ec 10             	sub    $0x10,%esp
80102437:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010243a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010243d:	50                   	push   %eax
8010243e:	e8 8d 20 00 00       	call   801044d0 <holdingsleep>
80102443:	83 c4 10             	add    $0x10,%esp
80102446:	85 c0                	test   %eax,%eax
80102448:	0f 84 c3 00 00 00    	je     80102511 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010244e:	8b 03                	mov    (%ebx),%eax
80102450:	83 e0 06             	and    $0x6,%eax
80102453:	83 f8 02             	cmp    $0x2,%eax
80102456:	0f 84 a8 00 00 00    	je     80102504 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010245c:	8b 53 04             	mov    0x4(%ebx),%edx
8010245f:	85 d2                	test   %edx,%edx
80102461:	74 0d                	je     80102470 <iderw+0x40>
80102463:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102468:	85 c0                	test   %eax,%eax
8010246a:	0f 84 87 00 00 00    	je     801024f7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102470:	83 ec 0c             	sub    $0xc,%esp
80102473:	68 00 16 11 80       	push   $0x80111600
80102478:	e8 73 22 00 00       	call   801046f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010247d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102482:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102489:	83 c4 10             	add    $0x10,%esp
8010248c:	85 c0                	test   %eax,%eax
8010248e:	74 60                	je     801024f0 <iderw+0xc0>
80102490:	89 c2                	mov    %eax,%edx
80102492:	8b 40 58             	mov    0x58(%eax),%eax
80102495:	85 c0                	test   %eax,%eax
80102497:	75 f7                	jne    80102490 <iderw+0x60>
80102499:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010249c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010249e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
801024a4:	74 3a                	je     801024e0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801024a6:	8b 03                	mov    (%ebx),%eax
801024a8:	83 e0 06             	and    $0x6,%eax
801024ab:	83 f8 02             	cmp    $0x2,%eax
801024ae:	74 1b                	je     801024cb <iderw+0x9b>
    sleep(b, &idelock);
801024b0:	83 ec 08             	sub    $0x8,%esp
801024b3:	68 00 16 11 80       	push   $0x80111600
801024b8:	53                   	push   %ebx
801024b9:	e8 d2 1c 00 00       	call   80104190 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801024be:	8b 03                	mov    (%ebx),%eax
801024c0:	83 c4 10             	add    $0x10,%esp
801024c3:	83 e0 06             	and    $0x6,%eax
801024c6:	83 f8 02             	cmp    $0x2,%eax
801024c9:	75 e5                	jne    801024b0 <iderw+0x80>
  }


  release(&idelock);
801024cb:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
801024d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024d5:	c9                   	leave  
  release(&idelock);
801024d6:	e9 b5 21 00 00       	jmp    80104690 <release>
801024db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024df:	90                   	nop
    idestart(b);
801024e0:	89 d8                	mov    %ebx,%eax
801024e2:	e8 49 fd ff ff       	call   80102230 <idestart>
801024e7:	eb bd                	jmp    801024a6 <iderw+0x76>
801024e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024f0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801024f5:	eb a5                	jmp    8010249c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801024f7:	83 ec 0c             	sub    $0xc,%esp
801024fa:	68 2d 75 10 80       	push   $0x8010752d
801024ff:	e8 7c de ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102504:	83 ec 0c             	sub    $0xc,%esp
80102507:	68 18 75 10 80       	push   $0x80107518
8010250c:	e8 6f de ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102511:	83 ec 0c             	sub    $0xc,%esp
80102514:	68 02 75 10 80       	push   $0x80107502
80102519:	e8 62 de ff ff       	call   80100380 <panic>
8010251e:	66 90                	xchg   %ax,%ax

80102520 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102520:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102521:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
80102528:	00 c0 fe 
{
8010252b:	89 e5                	mov    %esp,%ebp
8010252d:	56                   	push   %esi
8010252e:	53                   	push   %ebx
  ioapic->reg = reg;
8010252f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102536:	00 00 00 
  return ioapic->data;
80102539:	8b 15 34 16 11 80    	mov    0x80111634,%edx
8010253f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102542:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102548:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010254e:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102555:	c1 ee 10             	shr    $0x10,%esi
80102558:	89 f0                	mov    %esi,%eax
8010255a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010255d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102560:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102563:	39 c2                	cmp    %eax,%edx
80102565:	74 16                	je     8010257d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102567:	83 ec 0c             	sub    $0xc,%esp
8010256a:	68 4c 75 10 80       	push   $0x8010754c
8010256f:	e8 2c e1 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102574:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
8010257a:	83 c4 10             	add    $0x10,%esp
8010257d:	83 c6 21             	add    $0x21,%esi
{
80102580:	ba 10 00 00 00       	mov    $0x10,%edx
80102585:	b8 20 00 00 00       	mov    $0x20,%eax
8010258a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102590:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102592:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102594:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  for(i = 0; i <= maxintr; i++){
8010259a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010259d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801025a3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801025a6:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
801025a9:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801025ac:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801025ae:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
801025b4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801025bb:	39 f0                	cmp    %esi,%eax
801025bd:	75 d1                	jne    80102590 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801025bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c2:	5b                   	pop    %ebx
801025c3:	5e                   	pop    %esi
801025c4:	5d                   	pop    %ebp
801025c5:	c3                   	ret    
801025c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025cd:	8d 76 00             	lea    0x0(%esi),%esi

801025d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801025d0:	55                   	push   %ebp
  ioapic->reg = reg;
801025d1:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
801025d7:	89 e5                	mov    %esp,%ebp
801025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801025dc:	8d 50 20             	lea    0x20(%eax),%edx
801025df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801025e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025e5:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801025ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801025f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025f6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801025fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102601:	5d                   	pop    %ebp
80102602:	c3                   	ret    
80102603:	66 90                	xchg   %ax,%ax
80102605:	66 90                	xchg   %ax,%ax
80102607:	66 90                	xchg   %ax,%ax
80102609:	66 90                	xchg   %ax,%ax
8010260b:	66 90                	xchg   %ax,%ax
8010260d:	66 90                	xchg   %ax,%ax
8010260f:	90                   	nop

80102610 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	53                   	push   %ebx
80102614:	83 ec 04             	sub    $0x4,%esp
80102617:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010261a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102620:	75 76                	jne    80102698 <kfree+0x88>
80102622:	81 fb d0 54 11 80    	cmp    $0x801154d0,%ebx
80102628:	72 6e                	jb     80102698 <kfree+0x88>
8010262a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102630:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102635:	77 61                	ja     80102698 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102637:	83 ec 04             	sub    $0x4,%esp
8010263a:	68 00 10 00 00       	push   $0x1000
8010263f:	6a 01                	push   $0x1
80102641:	53                   	push   %ebx
80102642:	e8 69 21 00 00       	call   801047b0 <memset>

  if(kmem.use_lock)
80102647:	8b 15 74 16 11 80    	mov    0x80111674,%edx
8010264d:	83 c4 10             	add    $0x10,%esp
80102650:	85 d2                	test   %edx,%edx
80102652:	75 1c                	jne    80102670 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102654:	a1 78 16 11 80       	mov    0x80111678,%eax
80102659:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010265b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102660:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102666:	85 c0                	test   %eax,%eax
80102668:	75 1e                	jne    80102688 <kfree+0x78>
    release(&kmem.lock);
}
8010266a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010266d:	c9                   	leave  
8010266e:	c3                   	ret    
8010266f:	90                   	nop
    acquire(&kmem.lock);
80102670:	83 ec 0c             	sub    $0xc,%esp
80102673:	68 40 16 11 80       	push   $0x80111640
80102678:	e8 73 20 00 00       	call   801046f0 <acquire>
8010267d:	83 c4 10             	add    $0x10,%esp
80102680:	eb d2                	jmp    80102654 <kfree+0x44>
80102682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102688:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010268f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102692:	c9                   	leave  
    release(&kmem.lock);
80102693:	e9 f8 1f 00 00       	jmp    80104690 <release>
    panic("kfree");
80102698:	83 ec 0c             	sub    $0xc,%esp
8010269b:	68 7e 75 10 80       	push   $0x8010757e
801026a0:	e8 db dc ff ff       	call   80100380 <panic>
801026a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801026b0 <freerange>:
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801026b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801026ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026cd:	39 de                	cmp    %ebx,%esi
801026cf:	72 23                	jb     801026f4 <freerange+0x44>
801026d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026d8:	83 ec 0c             	sub    $0xc,%esp
801026db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026e7:	50                   	push   %eax
801026e8:	e8 23 ff ff ff       	call   80102610 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ed:	83 c4 10             	add    $0x10,%esp
801026f0:	39 f3                	cmp    %esi,%ebx
801026f2:	76 e4                	jbe    801026d8 <freerange+0x28>
}
801026f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026f7:	5b                   	pop    %ebx
801026f8:	5e                   	pop    %esi
801026f9:	5d                   	pop    %ebp
801026fa:	c3                   	ret    
801026fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026ff:	90                   	nop

80102700 <kinit2>:
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102704:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102707:	8b 75 0c             	mov    0xc(%ebp),%esi
8010270a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010270b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102711:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102717:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010271d:	39 de                	cmp    %ebx,%esi
8010271f:	72 23                	jb     80102744 <kinit2+0x44>
80102721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102728:	83 ec 0c             	sub    $0xc,%esp
8010272b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102731:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102737:	50                   	push   %eax
80102738:	e8 d3 fe ff ff       	call   80102610 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010273d:	83 c4 10             	add    $0x10,%esp
80102740:	39 de                	cmp    %ebx,%esi
80102742:	73 e4                	jae    80102728 <kinit2+0x28>
  kmem.use_lock = 1;
80102744:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010274b:	00 00 00 
}
8010274e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102751:	5b                   	pop    %ebx
80102752:	5e                   	pop    %esi
80102753:	5d                   	pop    %ebp
80102754:	c3                   	ret    
80102755:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010275c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102760 <kinit1>:
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	56                   	push   %esi
80102764:	53                   	push   %ebx
80102765:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102768:	83 ec 08             	sub    $0x8,%esp
8010276b:	68 84 75 10 80       	push   $0x80107584
80102770:	68 40 16 11 80       	push   $0x80111640
80102775:	e8 a6 1d 00 00       	call   80104520 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010277a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010277d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102780:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102787:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010278a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102790:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102796:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010279c:	39 de                	cmp    %ebx,%esi
8010279e:	72 1c                	jb     801027bc <kinit1+0x5c>
    kfree(p);
801027a0:	83 ec 0c             	sub    $0xc,%esp
801027a3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027af:	50                   	push   %eax
801027b0:	e8 5b fe ff ff       	call   80102610 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027b5:	83 c4 10             	add    $0x10,%esp
801027b8:	39 de                	cmp    %ebx,%esi
801027ba:	73 e4                	jae    801027a0 <kinit1+0x40>
}
801027bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027bf:	5b                   	pop    %ebx
801027c0:	5e                   	pop    %esi
801027c1:	5d                   	pop    %ebp
801027c2:	c3                   	ret    
801027c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801027d0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801027d0:	a1 74 16 11 80       	mov    0x80111674,%eax
801027d5:	85 c0                	test   %eax,%eax
801027d7:	75 1f                	jne    801027f8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801027d9:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
801027de:	85 c0                	test   %eax,%eax
801027e0:	74 0e                	je     801027f0 <kalloc+0x20>
    kmem.freelist = r->next;
801027e2:	8b 10                	mov    (%eax),%edx
801027e4:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
801027ea:	c3                   	ret    
801027eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027ef:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801027f0:	c3                   	ret    
801027f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801027f8:	55                   	push   %ebp
801027f9:	89 e5                	mov    %esp,%ebp
801027fb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801027fe:	68 40 16 11 80       	push   $0x80111640
80102803:	e8 e8 1e 00 00       	call   801046f0 <acquire>
  r = kmem.freelist;
80102808:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
8010280d:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
80102813:	83 c4 10             	add    $0x10,%esp
80102816:	85 c0                	test   %eax,%eax
80102818:	74 08                	je     80102822 <kalloc+0x52>
    kmem.freelist = r->next;
8010281a:	8b 08                	mov    (%eax),%ecx
8010281c:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
80102822:	85 d2                	test   %edx,%edx
80102824:	74 16                	je     8010283c <kalloc+0x6c>
    release(&kmem.lock);
80102826:	83 ec 0c             	sub    $0xc,%esp
80102829:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010282c:	68 40 16 11 80       	push   $0x80111640
80102831:	e8 5a 1e 00 00       	call   80104690 <release>
  return (char*)r;
80102836:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102839:	83 c4 10             	add    $0x10,%esp
}
8010283c:	c9                   	leave  
8010283d:	c3                   	ret    
8010283e:	66 90                	xchg   %ax,%ax

80102840 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102840:	ba 64 00 00 00       	mov    $0x64,%edx
80102845:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102846:	a8 01                	test   $0x1,%al
80102848:	0f 84 c2 00 00 00    	je     80102910 <kbdgetc+0xd0>
{
8010284e:	55                   	push   %ebp
8010284f:	ba 60 00 00 00       	mov    $0x60,%edx
80102854:	89 e5                	mov    %esp,%ebp
80102856:	53                   	push   %ebx
80102857:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102858:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010285e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102861:	3c e0                	cmp    $0xe0,%al
80102863:	74 5b                	je     801028c0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102865:	89 da                	mov    %ebx,%edx
80102867:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010286a:	84 c0                	test   %al,%al
8010286c:	78 62                	js     801028d0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010286e:	85 d2                	test   %edx,%edx
80102870:	74 09                	je     8010287b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102872:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102875:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102878:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010287b:	0f b6 91 c0 76 10 80 	movzbl -0x7fef8940(%ecx),%edx
  shift ^= togglecode[data];
80102882:	0f b6 81 c0 75 10 80 	movzbl -0x7fef8a40(%ecx),%eax
  shift |= shiftcode[data];
80102889:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010288b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010288d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010288f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102895:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102898:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010289b:	8b 04 85 a0 75 10 80 	mov    -0x7fef8a60(,%eax,4),%eax
801028a2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801028a6:	74 0b                	je     801028b3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801028a8:	8d 50 9f             	lea    -0x61(%eax),%edx
801028ab:	83 fa 19             	cmp    $0x19,%edx
801028ae:	77 48                	ja     801028f8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801028b0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801028b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028b6:	c9                   	leave  
801028b7:	c3                   	ret    
801028b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop
    shift |= E0ESC;
801028c0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801028c3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801028c5:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
801028cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028ce:	c9                   	leave  
801028cf:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801028d0:	83 e0 7f             	and    $0x7f,%eax
801028d3:	85 d2                	test   %edx,%edx
801028d5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801028d8:	0f b6 81 c0 76 10 80 	movzbl -0x7fef8940(%ecx),%eax
801028df:	83 c8 40             	or     $0x40,%eax
801028e2:	0f b6 c0             	movzbl %al,%eax
801028e5:	f7 d0                	not    %eax
801028e7:	21 d8                	and    %ebx,%eax
}
801028e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801028ec:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801028f1:	31 c0                	xor    %eax,%eax
}
801028f3:	c9                   	leave  
801028f4:	c3                   	ret    
801028f5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801028f8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801028fb:	8d 50 20             	lea    0x20(%eax),%edx
}
801028fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102901:	c9                   	leave  
      c += 'a' - 'A';
80102902:	83 f9 1a             	cmp    $0x1a,%ecx
80102905:	0f 42 c2             	cmovb  %edx,%eax
}
80102908:	c3                   	ret    
80102909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102915:	c3                   	ret    
80102916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291d:	8d 76 00             	lea    0x0(%esi),%esi

80102920 <kbdintr>:

void
kbdintr(void)
{
80102920:	55                   	push   %ebp
80102921:	89 e5                	mov    %esp,%ebp
80102923:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102926:	68 40 28 10 80       	push   $0x80102840
8010292b:	e8 50 df ff ff       	call   80100880 <consoleintr>
}
80102930:	83 c4 10             	add    $0x10,%esp
80102933:	c9                   	leave  
80102934:	c3                   	ret    
80102935:	66 90                	xchg   %ax,%ax
80102937:	66 90                	xchg   %ax,%ax
80102939:	66 90                	xchg   %ax,%ax
8010293b:	66 90                	xchg   %ax,%ax
8010293d:	66 90                	xchg   %ax,%ax
8010293f:	90                   	nop

80102940 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102940:	a1 80 16 11 80       	mov    0x80111680,%eax
80102945:	85 c0                	test   %eax,%eax
80102947:	0f 84 cb 00 00 00    	je     80102a18 <lapicinit+0xd8>
  lapic[index] = value;
8010294d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102954:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102957:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010295a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102961:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102964:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102967:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010296e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102971:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102974:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010297b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010297e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102981:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102988:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010298b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010298e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102995:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102998:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010299b:	8b 50 30             	mov    0x30(%eax),%edx
8010299e:	c1 ea 10             	shr    $0x10,%edx
801029a1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801029a7:	75 77                	jne    80102a20 <lapicinit+0xe0>
  lapic[index] = value;
801029a9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801029b0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029b6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029bd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029ca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029cd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029d7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029dd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801029e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801029f1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801029f4:	8b 50 20             	mov    0x20(%eax),%edx
801029f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029fe:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a00:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a06:	80 e6 10             	and    $0x10,%dh
80102a09:	75 f5                	jne    80102a00 <lapicinit+0xc0>
  lapic[index] = value;
80102a0b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a12:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a15:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a18:	c3                   	ret    
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102a20:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a27:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102a2d:	e9 77 ff ff ff       	jmp    801029a9 <lapicinit+0x69>
80102a32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a40 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a40:	a1 80 16 11 80       	mov    0x80111680,%eax
80102a45:	85 c0                	test   %eax,%eax
80102a47:	74 07                	je     80102a50 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102a49:	8b 40 20             	mov    0x20(%eax),%eax
80102a4c:	c1 e8 18             	shr    $0x18,%eax
80102a4f:	c3                   	ret    
    return 0;
80102a50:	31 c0                	xor    %eax,%eax
}
80102a52:	c3                   	ret    
80102a53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a60 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a60:	a1 80 16 11 80       	mov    0x80111680,%eax
80102a65:	85 c0                	test   %eax,%eax
80102a67:	74 0d                	je     80102a76 <lapiceoi+0x16>
  lapic[index] = value;
80102a69:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a70:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a73:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a76:	c3                   	ret    
80102a77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a7e:	66 90                	xchg   %ax,%ax

80102a80 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a80:	c3                   	ret    
80102a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a8f:	90                   	nop

80102a90 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a90:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a91:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a96:	ba 70 00 00 00       	mov    $0x70,%edx
80102a9b:	89 e5                	mov    %esp,%ebp
80102a9d:	53                   	push   %ebx
80102a9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102aa1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102aa4:	ee                   	out    %al,(%dx)
80102aa5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102aaa:	ba 71 00 00 00       	mov    $0x71,%edx
80102aaf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ab0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102ab2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102ab5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102abb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102abd:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102ac0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102ac2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ac5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102ac8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102ace:	a1 80 16 11 80       	mov    0x80111680,%eax
80102ad3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ad9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102adc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ae3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ae6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ae9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102af0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102af3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102af6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102afc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102aff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b05:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b08:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b0e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b11:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b17:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b1d:	c9                   	leave  
80102b1e:	c3                   	ret    
80102b1f:	90                   	nop

80102b20 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b20:	55                   	push   %ebp
80102b21:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b26:	ba 70 00 00 00       	mov    $0x70,%edx
80102b2b:	89 e5                	mov    %esp,%ebp
80102b2d:	57                   	push   %edi
80102b2e:	56                   	push   %esi
80102b2f:	53                   	push   %ebx
80102b30:	83 ec 4c             	sub    $0x4c,%esp
80102b33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b34:	ba 71 00 00 00       	mov    $0x71,%edx
80102b39:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102b3a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b3d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102b42:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b45:	8d 76 00             	lea    0x0(%esi),%esi
80102b48:	31 c0                	xor    %eax,%eax
80102b4a:	89 da                	mov    %ebx,%edx
80102b4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b52:	89 ca                	mov    %ecx,%edx
80102b54:	ec                   	in     (%dx),%al
80102b55:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b58:	89 da                	mov    %ebx,%edx
80102b5a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b5f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b60:	89 ca                	mov    %ecx,%edx
80102b62:	ec                   	in     (%dx),%al
80102b63:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b66:	89 da                	mov    %ebx,%edx
80102b68:	b8 04 00 00 00       	mov    $0x4,%eax
80102b6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6e:	89 ca                	mov    %ecx,%edx
80102b70:	ec                   	in     (%dx),%al
80102b71:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b74:	89 da                	mov    %ebx,%edx
80102b76:	b8 07 00 00 00       	mov    $0x7,%eax
80102b7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b7c:	89 ca                	mov    %ecx,%edx
80102b7e:	ec                   	in     (%dx),%al
80102b7f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b82:	89 da                	mov    %ebx,%edx
80102b84:	b8 08 00 00 00       	mov    $0x8,%eax
80102b89:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b8a:	89 ca                	mov    %ecx,%edx
80102b8c:	ec                   	in     (%dx),%al
80102b8d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b8f:	89 da                	mov    %ebx,%edx
80102b91:	b8 09 00 00 00       	mov    $0x9,%eax
80102b96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b97:	89 ca                	mov    %ecx,%edx
80102b99:	ec                   	in     (%dx),%al
80102b9a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b9c:	89 da                	mov    %ebx,%edx
80102b9e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ba3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ba4:	89 ca                	mov    %ecx,%edx
80102ba6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ba7:	84 c0                	test   %al,%al
80102ba9:	78 9d                	js     80102b48 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102bab:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102baf:	89 fa                	mov    %edi,%edx
80102bb1:	0f b6 fa             	movzbl %dl,%edi
80102bb4:	89 f2                	mov    %esi,%edx
80102bb6:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102bb9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102bbd:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc0:	89 da                	mov    %ebx,%edx
80102bc2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102bc5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102bc8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102bcc:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102bcf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102bd2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102bd6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102bd9:	31 c0                	xor    %eax,%eax
80102bdb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdc:	89 ca                	mov    %ecx,%edx
80102bde:	ec                   	in     (%dx),%al
80102bdf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be2:	89 da                	mov    %ebx,%edx
80102be4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102be7:	b8 02 00 00 00       	mov    $0x2,%eax
80102bec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bed:	89 ca                	mov    %ecx,%edx
80102bef:	ec                   	in     (%dx),%al
80102bf0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf3:	89 da                	mov    %ebx,%edx
80102bf5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102bf8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bfd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfe:	89 ca                	mov    %ecx,%edx
80102c00:	ec                   	in     (%dx),%al
80102c01:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c04:	89 da                	mov    %ebx,%edx
80102c06:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c09:	b8 07 00 00 00       	mov    $0x7,%eax
80102c0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0f:	89 ca                	mov    %ecx,%edx
80102c11:	ec                   	in     (%dx),%al
80102c12:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c15:	89 da                	mov    %ebx,%edx
80102c17:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c1a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c20:	89 ca                	mov    %ecx,%edx
80102c22:	ec                   	in     (%dx),%al
80102c23:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c26:	89 da                	mov    %ebx,%edx
80102c28:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c2b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c30:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c31:	89 ca                	mov    %ecx,%edx
80102c33:	ec                   	in     (%dx),%al
80102c34:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c37:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c3d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c40:	6a 18                	push   $0x18
80102c42:	50                   	push   %eax
80102c43:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c46:	50                   	push   %eax
80102c47:	e8 b4 1b 00 00       	call   80104800 <memcmp>
80102c4c:	83 c4 10             	add    $0x10,%esp
80102c4f:	85 c0                	test   %eax,%eax
80102c51:	0f 85 f1 fe ff ff    	jne    80102b48 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c57:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102c5b:	75 78                	jne    80102cd5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c5d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c60:	89 c2                	mov    %eax,%edx
80102c62:	83 e0 0f             	and    $0xf,%eax
80102c65:	c1 ea 04             	shr    $0x4,%edx
80102c68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c6e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c71:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c74:	89 c2                	mov    %eax,%edx
80102c76:	83 e0 0f             	and    $0xf,%eax
80102c79:	c1 ea 04             	shr    $0x4,%edx
80102c7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c82:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c85:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c88:	89 c2                	mov    %eax,%edx
80102c8a:	83 e0 0f             	and    $0xf,%eax
80102c8d:	c1 ea 04             	shr    $0x4,%edx
80102c90:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c93:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c96:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c9c:	89 c2                	mov    %eax,%edx
80102c9e:	83 e0 0f             	and    $0xf,%eax
80102ca1:	c1 ea 04             	shr    $0x4,%edx
80102ca4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ca7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102caa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102cad:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cb0:	89 c2                	mov    %eax,%edx
80102cb2:	83 e0 0f             	and    $0xf,%eax
80102cb5:	c1 ea 04             	shr    $0x4,%edx
80102cb8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cbb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cbe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102cc1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cc4:	89 c2                	mov    %eax,%edx
80102cc6:	83 e0 0f             	and    $0xf,%eax
80102cc9:	c1 ea 04             	shr    $0x4,%edx
80102ccc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ccf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cd2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102cd5:	8b 75 08             	mov    0x8(%ebp),%esi
80102cd8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cdb:	89 06                	mov    %eax,(%esi)
80102cdd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ce0:	89 46 04             	mov    %eax,0x4(%esi)
80102ce3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ce6:	89 46 08             	mov    %eax,0x8(%esi)
80102ce9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cec:	89 46 0c             	mov    %eax,0xc(%esi)
80102cef:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cf2:	89 46 10             	mov    %eax,0x10(%esi)
80102cf5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cf8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102cfb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d05:	5b                   	pop    %ebx
80102d06:	5e                   	pop    %esi
80102d07:	5f                   	pop    %edi
80102d08:	5d                   	pop    %ebp
80102d09:	c3                   	ret    
80102d0a:	66 90                	xchg   %ax,%ax
80102d0c:	66 90                	xchg   %ax,%ax
80102d0e:	66 90                	xchg   %ax,%ax

80102d10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d10:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102d16:	85 c9                	test   %ecx,%ecx
80102d18:	0f 8e 8a 00 00 00    	jle    80102da8 <install_trans+0x98>
{
80102d1e:	55                   	push   %ebp
80102d1f:	89 e5                	mov    %esp,%ebp
80102d21:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d22:	31 ff                	xor    %edi,%edi
{
80102d24:	56                   	push   %esi
80102d25:	53                   	push   %ebx
80102d26:	83 ec 0c             	sub    $0xc,%esp
80102d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d30:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102d35:	83 ec 08             	sub    $0x8,%esp
80102d38:	01 f8                	add    %edi,%eax
80102d3a:	83 c0 01             	add    $0x1,%eax
80102d3d:	50                   	push   %eax
80102d3e:	ff 35 e4 16 11 80    	push   0x801116e4
80102d44:	e8 87 d3 ff ff       	call   801000d0 <bread>
80102d49:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d4b:	58                   	pop    %eax
80102d4c:	5a                   	pop    %edx
80102d4d:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102d54:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d5a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d5d:	e8 6e d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d62:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d65:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d67:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d6a:	68 00 02 00 00       	push   $0x200
80102d6f:	50                   	push   %eax
80102d70:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102d73:	50                   	push   %eax
80102d74:	e8 d7 1a 00 00       	call   80104850 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d79:	89 1c 24             	mov    %ebx,(%esp)
80102d7c:	e8 2f d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102d81:	89 34 24             	mov    %esi,(%esp)
80102d84:	e8 67 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102d89:	89 1c 24             	mov    %ebx,(%esp)
80102d8c:	e8 5f d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d91:	83 c4 10             	add    $0x10,%esp
80102d94:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102d9a:	7f 94                	jg     80102d30 <install_trans+0x20>
  }
}
80102d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d9f:	5b                   	pop    %ebx
80102da0:	5e                   	pop    %esi
80102da1:	5f                   	pop    %edi
80102da2:	5d                   	pop    %ebp
80102da3:	c3                   	ret    
80102da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102da8:	c3                   	ret    
80102da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102db0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	53                   	push   %ebx
80102db4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102db7:	ff 35 d4 16 11 80    	push   0x801116d4
80102dbd:	ff 35 e4 16 11 80    	push   0x801116e4
80102dc3:	e8 08 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102dc8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102dcb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102dcd:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102dd2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102dd5:	85 c0                	test   %eax,%eax
80102dd7:	7e 19                	jle    80102df2 <write_head+0x42>
80102dd9:	31 d2                	xor    %edx,%edx
80102ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ddf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102de0:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102de7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102deb:	83 c2 01             	add    $0x1,%edx
80102dee:	39 d0                	cmp    %edx,%eax
80102df0:	75 ee                	jne    80102de0 <write_head+0x30>
  }
  bwrite(buf);
80102df2:	83 ec 0c             	sub    $0xc,%esp
80102df5:	53                   	push   %ebx
80102df6:	e8 b5 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102dfb:	89 1c 24             	mov    %ebx,(%esp)
80102dfe:	e8 ed d3 ff ff       	call   801001f0 <brelse>
}
80102e03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e06:	83 c4 10             	add    $0x10,%esp
80102e09:	c9                   	leave  
80102e0a:	c3                   	ret    
80102e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e0f:	90                   	nop

80102e10 <initlog>:
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	53                   	push   %ebx
80102e14:	83 ec 2c             	sub    $0x2c,%esp
80102e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e1a:	68 c0 77 10 80       	push   $0x801077c0
80102e1f:	68 a0 16 11 80       	push   $0x801116a0
80102e24:	e8 f7 16 00 00       	call   80104520 <initlock>
  readsb(dev, &sb);
80102e29:	58                   	pop    %eax
80102e2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e2d:	5a                   	pop    %edx
80102e2e:	50                   	push   %eax
80102e2f:	53                   	push   %ebx
80102e30:	e8 3b e8 ff ff       	call   80101670 <readsb>
  log.start = sb.logstart;
80102e35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e38:	59                   	pop    %ecx
  log.dev = dev;
80102e39:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102e3f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e42:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102e47:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102e4d:	5a                   	pop    %edx
80102e4e:	50                   	push   %eax
80102e4f:	53                   	push   %ebx
80102e50:	e8 7b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102e55:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102e58:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102e5b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102e61:	85 db                	test   %ebx,%ebx
80102e63:	7e 1d                	jle    80102e82 <initlog+0x72>
80102e65:	31 d2                	xor    %edx,%edx
80102e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102e70:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102e74:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e7b:	83 c2 01             	add    $0x1,%edx
80102e7e:	39 d3                	cmp    %edx,%ebx
80102e80:	75 ee                	jne    80102e70 <initlog+0x60>
  brelse(buf);
80102e82:	83 ec 0c             	sub    $0xc,%esp
80102e85:	50                   	push   %eax
80102e86:	e8 65 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e8b:	e8 80 fe ff ff       	call   80102d10 <install_trans>
  log.lh.n = 0;
80102e90:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102e97:	00 00 00 
  write_head(); // clear the log
80102e9a:	e8 11 ff ff ff       	call   80102db0 <write_head>
}
80102e9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ea2:	83 c4 10             	add    $0x10,%esp
80102ea5:	c9                   	leave  
80102ea6:	c3                   	ret    
80102ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eae:	66 90                	xchg   %ax,%ax

80102eb0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102eb6:	68 a0 16 11 80       	push   $0x801116a0
80102ebb:	e8 30 18 00 00       	call   801046f0 <acquire>
80102ec0:	83 c4 10             	add    $0x10,%esp
80102ec3:	eb 18                	jmp    80102edd <begin_op+0x2d>
80102ec5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ec8:	83 ec 08             	sub    $0x8,%esp
80102ecb:	68 a0 16 11 80       	push   $0x801116a0
80102ed0:	68 a0 16 11 80       	push   $0x801116a0
80102ed5:	e8 b6 12 00 00       	call   80104190 <sleep>
80102eda:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102edd:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102ee2:	85 c0                	test   %eax,%eax
80102ee4:	75 e2                	jne    80102ec8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ee6:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102eeb:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102ef1:	83 c0 01             	add    $0x1,%eax
80102ef4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ef7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102efa:	83 fa 1e             	cmp    $0x1e,%edx
80102efd:	7f c9                	jg     80102ec8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102eff:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f02:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102f07:	68 a0 16 11 80       	push   $0x801116a0
80102f0c:	e8 7f 17 00 00       	call   80104690 <release>
      break;
    }
  }
}
80102f11:	83 c4 10             	add    $0x10,%esp
80102f14:	c9                   	leave  
80102f15:	c3                   	ret    
80102f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f1d:	8d 76 00             	lea    0x0(%esi),%esi

80102f20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	57                   	push   %edi
80102f24:	56                   	push   %esi
80102f25:	53                   	push   %ebx
80102f26:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f29:	68 a0 16 11 80       	push   $0x801116a0
80102f2e:	e8 bd 17 00 00       	call   801046f0 <acquire>
  log.outstanding -= 1;
80102f33:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102f38:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102f3e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f41:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f44:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102f4a:	85 f6                	test   %esi,%esi
80102f4c:	0f 85 22 01 00 00    	jne    80103074 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f52:	85 db                	test   %ebx,%ebx
80102f54:	0f 85 f6 00 00 00    	jne    80103050 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102f5a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102f61:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f64:	83 ec 0c             	sub    $0xc,%esp
80102f67:	68 a0 16 11 80       	push   $0x801116a0
80102f6c:	e8 1f 17 00 00       	call   80104690 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f71:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102f77:	83 c4 10             	add    $0x10,%esp
80102f7a:	85 c9                	test   %ecx,%ecx
80102f7c:	7f 42                	jg     80102fc0 <end_op+0xa0>
    acquire(&log.lock);
80102f7e:	83 ec 0c             	sub    $0xc,%esp
80102f81:	68 a0 16 11 80       	push   $0x801116a0
80102f86:	e8 65 17 00 00       	call   801046f0 <acquire>
    wakeup(&log);
80102f8b:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
    log.committing = 0;
80102f92:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102f99:	00 00 00 
    wakeup(&log);
80102f9c:	e8 af 12 00 00       	call   80104250 <wakeup>
    release(&log.lock);
80102fa1:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102fa8:	e8 e3 16 00 00       	call   80104690 <release>
80102fad:	83 c4 10             	add    $0x10,%esp
}
80102fb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fb3:	5b                   	pop    %ebx
80102fb4:	5e                   	pop    %esi
80102fb5:	5f                   	pop    %edi
80102fb6:	5d                   	pop    %ebp
80102fb7:	c3                   	ret    
80102fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fbf:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102fc0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102fc5:	83 ec 08             	sub    $0x8,%esp
80102fc8:	01 d8                	add    %ebx,%eax
80102fca:	83 c0 01             	add    $0x1,%eax
80102fcd:	50                   	push   %eax
80102fce:	ff 35 e4 16 11 80    	push   0x801116e4
80102fd4:	e8 f7 d0 ff ff       	call   801000d0 <bread>
80102fd9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fdb:	58                   	pop    %eax
80102fdc:	5a                   	pop    %edx
80102fdd:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102fe4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102fea:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fed:	e8 de d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ff2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ff5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ff7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ffa:	68 00 02 00 00       	push   $0x200
80102fff:	50                   	push   %eax
80103000:	8d 46 5c             	lea    0x5c(%esi),%eax
80103003:	50                   	push   %eax
80103004:	e8 47 18 00 00       	call   80104850 <memmove>
    bwrite(to);  // write the log
80103009:	89 34 24             	mov    %esi,(%esp)
8010300c:	e8 9f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103011:	89 3c 24             	mov    %edi,(%esp)
80103014:	e8 d7 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103019:	89 34 24             	mov    %esi,(%esp)
8010301c:	e8 cf d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103021:	83 c4 10             	add    $0x10,%esp
80103024:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
8010302a:	7c 94                	jl     80102fc0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010302c:	e8 7f fd ff ff       	call   80102db0 <write_head>
    install_trans(); // Now install writes to home locations
80103031:	e8 da fc ff ff       	call   80102d10 <install_trans>
    log.lh.n = 0;
80103036:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
8010303d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103040:	e8 6b fd ff ff       	call   80102db0 <write_head>
80103045:	e9 34 ff ff ff       	jmp    80102f7e <end_op+0x5e>
8010304a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103050:	83 ec 0c             	sub    $0xc,%esp
80103053:	68 a0 16 11 80       	push   $0x801116a0
80103058:	e8 f3 11 00 00       	call   80104250 <wakeup>
  release(&log.lock);
8010305d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80103064:	e8 27 16 00 00       	call   80104690 <release>
80103069:	83 c4 10             	add    $0x10,%esp
}
8010306c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010306f:	5b                   	pop    %ebx
80103070:	5e                   	pop    %esi
80103071:	5f                   	pop    %edi
80103072:	5d                   	pop    %ebp
80103073:	c3                   	ret    
    panic("log.committing");
80103074:	83 ec 0c             	sub    $0xc,%esp
80103077:	68 c4 77 10 80       	push   $0x801077c4
8010307c:	e8 ff d2 ff ff       	call   80100380 <panic>
80103081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103088:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010308f:	90                   	nop

80103090 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103090:	55                   	push   %ebp
80103091:	89 e5                	mov    %esp,%ebp
80103093:	53                   	push   %ebx
80103094:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103097:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
8010309d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030a0:	83 fa 1d             	cmp    $0x1d,%edx
801030a3:	0f 8f 85 00 00 00    	jg     8010312e <log_write+0x9e>
801030a9:	a1 d8 16 11 80       	mov    0x801116d8,%eax
801030ae:	83 e8 01             	sub    $0x1,%eax
801030b1:	39 c2                	cmp    %eax,%edx
801030b3:	7d 79                	jge    8010312e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
801030b5:	a1 dc 16 11 80       	mov    0x801116dc,%eax
801030ba:	85 c0                	test   %eax,%eax
801030bc:	7e 7d                	jle    8010313b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
801030be:	83 ec 0c             	sub    $0xc,%esp
801030c1:	68 a0 16 11 80       	push   $0x801116a0
801030c6:	e8 25 16 00 00       	call   801046f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801030cb:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
801030d1:	83 c4 10             	add    $0x10,%esp
801030d4:	85 d2                	test   %edx,%edx
801030d6:	7e 4a                	jle    80103122 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030d8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801030db:	31 c0                	xor    %eax,%eax
801030dd:	eb 08                	jmp    801030e7 <log_write+0x57>
801030df:	90                   	nop
801030e0:	83 c0 01             	add    $0x1,%eax
801030e3:	39 c2                	cmp    %eax,%edx
801030e5:	74 29                	je     80103110 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030e7:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
801030ee:	75 f0                	jne    801030e0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801030f0:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801030f7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801030fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801030fd:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80103104:	c9                   	leave  
  release(&log.lock);
80103105:	e9 86 15 00 00       	jmp    80104690 <release>
8010310a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103110:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80103117:	83 c2 01             	add    $0x1,%edx
8010311a:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80103120:	eb d5                	jmp    801030f7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103122:	8b 43 08             	mov    0x8(%ebx),%eax
80103125:	a3 ec 16 11 80       	mov    %eax,0x801116ec
  if (i == log.lh.n)
8010312a:	75 cb                	jne    801030f7 <log_write+0x67>
8010312c:	eb e9                	jmp    80103117 <log_write+0x87>
    panic("too big a transaction");
8010312e:	83 ec 0c             	sub    $0xc,%esp
80103131:	68 d3 77 10 80       	push   $0x801077d3
80103136:	e8 45 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010313b:	83 ec 0c             	sub    $0xc,%esp
8010313e:	68 e9 77 10 80       	push   $0x801077e9
80103143:	e8 38 d2 ff ff       	call   80100380 <panic>
80103148:	66 90                	xchg   %ax,%ax
8010314a:	66 90                	xchg   %ax,%ax
8010314c:	66 90                	xchg   %ax,%ax
8010314e:	66 90                	xchg   %ax,%ax

80103150 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	53                   	push   %ebx
80103154:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103157:	e8 44 09 00 00       	call   80103aa0 <cpuid>
8010315c:	89 c3                	mov    %eax,%ebx
8010315e:	e8 3d 09 00 00       	call   80103aa0 <cpuid>
80103163:	83 ec 04             	sub    $0x4,%esp
80103166:	53                   	push   %ebx
80103167:	50                   	push   %eax
80103168:	68 04 78 10 80       	push   $0x80107804
8010316d:	e8 2e d5 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103172:	e8 b9 28 00 00       	call   80105a30 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103177:	e8 c4 08 00 00       	call   80103a40 <mycpu>
8010317c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010317e:	b8 01 00 00 00       	mov    $0x1,%eax
80103183:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010318a:	e8 f1 0b 00 00       	call   80103d80 <scheduler>
8010318f:	90                   	nop

80103190 <mpenter>:
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103196:	e8 85 39 00 00       	call   80106b20 <switchkvm>
  seginit();
8010319b:	e8 f0 38 00 00       	call   80106a90 <seginit>
  lapicinit();
801031a0:	e8 9b f7 ff ff       	call   80102940 <lapicinit>
  mpmain();
801031a5:	e8 a6 ff ff ff       	call   80103150 <mpmain>
801031aa:	66 90                	xchg   %ax,%ax
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <main>:
{
801031b0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801031b4:	83 e4 f0             	and    $0xfffffff0,%esp
801031b7:	ff 71 fc             	push   -0x4(%ecx)
801031ba:	55                   	push   %ebp
801031bb:	89 e5                	mov    %esp,%ebp
801031bd:	53                   	push   %ebx
801031be:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801031bf:	83 ec 08             	sub    $0x8,%esp
801031c2:	68 00 00 40 80       	push   $0x80400000
801031c7:	68 d0 54 11 80       	push   $0x801154d0
801031cc:	e8 8f f5 ff ff       	call   80102760 <kinit1>
  kvmalloc();      // kernel page table
801031d1:	e8 3a 3e 00 00       	call   80107010 <kvmalloc>
  mpinit();        // detect other processors
801031d6:	e8 85 01 00 00       	call   80103360 <mpinit>
  lapicinit();     // interrupt controller
801031db:	e8 60 f7 ff ff       	call   80102940 <lapicinit>
  seginit();       // segment descriptors
801031e0:	e8 ab 38 00 00       	call   80106a90 <seginit>
  picinit();       // disable pic
801031e5:	e8 76 03 00 00       	call   80103560 <picinit>
  ioapicinit();    // another interrupt controller
801031ea:	e8 31 f3 ff ff       	call   80102520 <ioapicinit>
  consoleinit();   // console hardware
801031ef:	e8 bc d9 ff ff       	call   80100bb0 <consoleinit>
  uartinit();      // serial port
801031f4:	e8 27 2b 00 00       	call   80105d20 <uartinit>
  pinit();         // process table
801031f9:	e8 22 08 00 00       	call   80103a20 <pinit>
  tvinit();        // trap vectors
801031fe:	e8 ad 27 00 00       	call   801059b0 <tvinit>
  binit();         // buffer cache
80103203:	e8 38 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103208:	e8 53 dd ff ff       	call   80100f60 <fileinit>
  ideinit();       // disk 
8010320d:	e8 fe f0 ff ff       	call   80102310 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103212:	83 c4 0c             	add    $0xc,%esp
80103215:	68 8a 00 00 00       	push   $0x8a
8010321a:	68 8c a4 10 80       	push   $0x8010a48c
8010321f:	68 00 70 00 80       	push   $0x80007000
80103224:	e8 27 16 00 00       	call   80104850 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103229:	83 c4 10             	add    $0x10,%esp
8010322c:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103233:	00 00 00 
80103236:	05 a0 17 11 80       	add    $0x801117a0,%eax
8010323b:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80103240:	76 7e                	jbe    801032c0 <main+0x110>
80103242:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80103247:	eb 20                	jmp    80103269 <main+0xb9>
80103249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103250:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103257:	00 00 00 
8010325a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103260:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103265:	39 c3                	cmp    %eax,%ebx
80103267:	73 57                	jae    801032c0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103269:	e8 d2 07 00 00       	call   80103a40 <mycpu>
8010326e:	39 c3                	cmp    %eax,%ebx
80103270:	74 de                	je     80103250 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103272:	e8 59 f5 ff ff       	call   801027d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103277:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010327a:	c7 05 f8 6f 00 80 90 	movl   $0x80103190,0x80006ff8
80103281:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103284:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010328b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010328e:	05 00 10 00 00       	add    $0x1000,%eax
80103293:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103298:	0f b6 03             	movzbl (%ebx),%eax
8010329b:	68 00 70 00 00       	push   $0x7000
801032a0:	50                   	push   %eax
801032a1:	e8 ea f7 ff ff       	call   80102a90 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801032a6:	83 c4 10             	add    $0x10,%esp
801032a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032b0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801032b6:	85 c0                	test   %eax,%eax
801032b8:	74 f6                	je     801032b0 <main+0x100>
801032ba:	eb 94                	jmp    80103250 <main+0xa0>
801032bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801032c0:	83 ec 08             	sub    $0x8,%esp
801032c3:	68 00 00 00 8e       	push   $0x8e000000
801032c8:	68 00 00 40 80       	push   $0x80400000
801032cd:	e8 2e f4 ff ff       	call   80102700 <kinit2>
  userinit();      // first user process
801032d2:	e8 19 08 00 00       	call   80103af0 <userinit>
  mpmain();        // finish this processor's setup
801032d7:	e8 74 fe ff ff       	call   80103150 <mpmain>
801032dc:	66 90                	xchg   %ax,%ax
801032de:	66 90                	xchg   %ax,%ax

801032e0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	57                   	push   %edi
801032e4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801032e5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801032eb:	53                   	push   %ebx
  e = addr+len;
801032ec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801032ef:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801032f2:	39 de                	cmp    %ebx,%esi
801032f4:	72 10                	jb     80103306 <mpsearch1+0x26>
801032f6:	eb 50                	jmp    80103348 <mpsearch1+0x68>
801032f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032ff:	90                   	nop
80103300:	89 fe                	mov    %edi,%esi
80103302:	39 fb                	cmp    %edi,%ebx
80103304:	76 42                	jbe    80103348 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103306:	83 ec 04             	sub    $0x4,%esp
80103309:	8d 7e 10             	lea    0x10(%esi),%edi
8010330c:	6a 04                	push   $0x4
8010330e:	68 18 78 10 80       	push   $0x80107818
80103313:	56                   	push   %esi
80103314:	e8 e7 14 00 00       	call   80104800 <memcmp>
80103319:	83 c4 10             	add    $0x10,%esp
8010331c:	85 c0                	test   %eax,%eax
8010331e:	75 e0                	jne    80103300 <mpsearch1+0x20>
80103320:	89 f2                	mov    %esi,%edx
80103322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103328:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010332b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010332e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103330:	39 fa                	cmp    %edi,%edx
80103332:	75 f4                	jne    80103328 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103334:	84 c0                	test   %al,%al
80103336:	75 c8                	jne    80103300 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103338:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333b:	89 f0                	mov    %esi,%eax
8010333d:	5b                   	pop    %ebx
8010333e:	5e                   	pop    %esi
8010333f:	5f                   	pop    %edi
80103340:	5d                   	pop    %ebp
80103341:	c3                   	ret    
80103342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103348:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010334b:	31 f6                	xor    %esi,%esi
}
8010334d:	5b                   	pop    %ebx
8010334e:	89 f0                	mov    %esi,%eax
80103350:	5e                   	pop    %esi
80103351:	5f                   	pop    %edi
80103352:	5d                   	pop    %ebp
80103353:	c3                   	ret    
80103354:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010335b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010335f:	90                   	nop

80103360 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	57                   	push   %edi
80103364:	56                   	push   %esi
80103365:	53                   	push   %ebx
80103366:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103369:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103370:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103377:	c1 e0 08             	shl    $0x8,%eax
8010337a:	09 d0                	or     %edx,%eax
8010337c:	c1 e0 04             	shl    $0x4,%eax
8010337f:	75 1b                	jne    8010339c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103381:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103388:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010338f:	c1 e0 08             	shl    $0x8,%eax
80103392:	09 d0                	or     %edx,%eax
80103394:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103397:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010339c:	ba 00 04 00 00       	mov    $0x400,%edx
801033a1:	e8 3a ff ff ff       	call   801032e0 <mpsearch1>
801033a6:	89 c3                	mov    %eax,%ebx
801033a8:	85 c0                	test   %eax,%eax
801033aa:	0f 84 40 01 00 00    	je     801034f0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033b0:	8b 73 04             	mov    0x4(%ebx),%esi
801033b3:	85 f6                	test   %esi,%esi
801033b5:	0f 84 25 01 00 00    	je     801034e0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
801033bb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033be:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801033c4:	6a 04                	push   $0x4
801033c6:	68 1d 78 10 80       	push   $0x8010781d
801033cb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801033cf:	e8 2c 14 00 00       	call   80104800 <memcmp>
801033d4:	83 c4 10             	add    $0x10,%esp
801033d7:	85 c0                	test   %eax,%eax
801033d9:	0f 85 01 01 00 00    	jne    801034e0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801033df:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801033e6:	3c 01                	cmp    $0x1,%al
801033e8:	74 08                	je     801033f2 <mpinit+0x92>
801033ea:	3c 04                	cmp    $0x4,%al
801033ec:	0f 85 ee 00 00 00    	jne    801034e0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801033f2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801033f9:	66 85 d2             	test   %dx,%dx
801033fc:	74 22                	je     80103420 <mpinit+0xc0>
801033fe:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103401:	89 f0                	mov    %esi,%eax
  sum = 0;
80103403:	31 d2                	xor    %edx,%edx
80103405:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103408:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010340f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103412:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103414:	39 c7                	cmp    %eax,%edi
80103416:	75 f0                	jne    80103408 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103418:	84 d2                	test   %dl,%dl
8010341a:	0f 85 c0 00 00 00    	jne    801034e0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103420:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103426:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010342b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103432:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103438:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010343d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103440:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103443:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103447:	90                   	nop
80103448:	39 d0                	cmp    %edx,%eax
8010344a:	73 15                	jae    80103461 <mpinit+0x101>
    switch(*p){
8010344c:	0f b6 08             	movzbl (%eax),%ecx
8010344f:	80 f9 02             	cmp    $0x2,%cl
80103452:	74 4c                	je     801034a0 <mpinit+0x140>
80103454:	77 3a                	ja     80103490 <mpinit+0x130>
80103456:	84 c9                	test   %cl,%cl
80103458:	74 56                	je     801034b0 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010345a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010345d:	39 d0                	cmp    %edx,%eax
8010345f:	72 eb                	jb     8010344c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103461:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103464:	85 f6                	test   %esi,%esi
80103466:	0f 84 d9 00 00 00    	je     80103545 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010346c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103470:	74 15                	je     80103487 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103472:	b8 70 00 00 00       	mov    $0x70,%eax
80103477:	ba 22 00 00 00       	mov    $0x22,%edx
8010347c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010347d:	ba 23 00 00 00       	mov    $0x23,%edx
80103482:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103483:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103486:	ee                   	out    %al,(%dx)
  }
}
80103487:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010348a:	5b                   	pop    %ebx
8010348b:	5e                   	pop    %esi
8010348c:	5f                   	pop    %edi
8010348d:	5d                   	pop    %ebp
8010348e:	c3                   	ret    
8010348f:	90                   	nop
    switch(*p){
80103490:	83 e9 03             	sub    $0x3,%ecx
80103493:	80 f9 01             	cmp    $0x1,%cl
80103496:	76 c2                	jbe    8010345a <mpinit+0xfa>
80103498:	31 f6                	xor    %esi,%esi
8010349a:	eb ac                	jmp    80103448 <mpinit+0xe8>
8010349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801034a0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801034a4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801034a7:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
801034ad:	eb 99                	jmp    80103448 <mpinit+0xe8>
801034af:	90                   	nop
      if(ncpu < NCPU) {
801034b0:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
801034b6:	83 f9 07             	cmp    $0x7,%ecx
801034b9:	7f 19                	jg     801034d4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034bb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801034c1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801034c5:	83 c1 01             	add    $0x1,%ecx
801034c8:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034ce:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
801034d4:	83 c0 14             	add    $0x14,%eax
      continue;
801034d7:	e9 6c ff ff ff       	jmp    80103448 <mpinit+0xe8>
801034dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801034e0:	83 ec 0c             	sub    $0xc,%esp
801034e3:	68 22 78 10 80       	push   $0x80107822
801034e8:	e8 93 ce ff ff       	call   80100380 <panic>
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801034f0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801034f5:	eb 13                	jmp    8010350a <mpinit+0x1aa>
801034f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034fe:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103500:	89 f3                	mov    %esi,%ebx
80103502:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103508:	74 d6                	je     801034e0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010350a:	83 ec 04             	sub    $0x4,%esp
8010350d:	8d 73 10             	lea    0x10(%ebx),%esi
80103510:	6a 04                	push   $0x4
80103512:	68 18 78 10 80       	push   $0x80107818
80103517:	53                   	push   %ebx
80103518:	e8 e3 12 00 00       	call   80104800 <memcmp>
8010351d:	83 c4 10             	add    $0x10,%esp
80103520:	85 c0                	test   %eax,%eax
80103522:	75 dc                	jne    80103500 <mpinit+0x1a0>
80103524:	89 da                	mov    %ebx,%edx
80103526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010352d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103530:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103533:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103536:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103538:	39 d6                	cmp    %edx,%esi
8010353a:	75 f4                	jne    80103530 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010353c:	84 c0                	test   %al,%al
8010353e:	75 c0                	jne    80103500 <mpinit+0x1a0>
80103540:	e9 6b fe ff ff       	jmp    801033b0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103545:	83 ec 0c             	sub    $0xc,%esp
80103548:	68 3c 78 10 80       	push   $0x8010783c
8010354d:	e8 2e ce ff ff       	call   80100380 <panic>
80103552:	66 90                	xchg   %ax,%ax
80103554:	66 90                	xchg   %ax,%ax
80103556:	66 90                	xchg   %ax,%ax
80103558:	66 90                	xchg   %ax,%ax
8010355a:	66 90                	xchg   %ax,%ax
8010355c:	66 90                	xchg   %ax,%ax
8010355e:	66 90                	xchg   %ax,%ax

80103560 <picinit>:
80103560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103565:	ba 21 00 00 00       	mov    $0x21,%edx
8010356a:	ee                   	out    %al,(%dx)
8010356b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103570:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103571:	c3                   	ret    
80103572:	66 90                	xchg   %ax,%ax
80103574:	66 90                	xchg   %ax,%ax
80103576:	66 90                	xchg   %ax,%ax
80103578:	66 90                	xchg   %ax,%ax
8010357a:	66 90                	xchg   %ax,%ax
8010357c:	66 90                	xchg   %ax,%ax
8010357e:	66 90                	xchg   %ax,%ax

80103580 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	57                   	push   %edi
80103584:	56                   	push   %esi
80103585:	53                   	push   %ebx
80103586:	83 ec 0c             	sub    $0xc,%esp
80103589:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010358c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010358f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103595:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010359b:	e8 e0 d9 ff ff       	call   80100f80 <filealloc>
801035a0:	89 03                	mov    %eax,(%ebx)
801035a2:	85 c0                	test   %eax,%eax
801035a4:	0f 84 a8 00 00 00    	je     80103652 <pipealloc+0xd2>
801035aa:	e8 d1 d9 ff ff       	call   80100f80 <filealloc>
801035af:	89 06                	mov    %eax,(%esi)
801035b1:	85 c0                	test   %eax,%eax
801035b3:	0f 84 87 00 00 00    	je     80103640 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035b9:	e8 12 f2 ff ff       	call   801027d0 <kalloc>
801035be:	89 c7                	mov    %eax,%edi
801035c0:	85 c0                	test   %eax,%eax
801035c2:	0f 84 b0 00 00 00    	je     80103678 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801035c8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035cf:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801035d2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801035d5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035dc:	00 00 00 
  p->nwrite = 0;
801035df:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035e6:	00 00 00 
  p->nread = 0;
801035e9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035f0:	00 00 00 
  initlock(&p->lock, "pipe");
801035f3:	68 5b 78 10 80       	push   $0x8010785b
801035f8:	50                   	push   %eax
801035f9:	e8 22 0f 00 00       	call   80104520 <initlock>
  (*f0)->type = FD_PIPE;
801035fe:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103600:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103603:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103609:	8b 03                	mov    (%ebx),%eax
8010360b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010360f:	8b 03                	mov    (%ebx),%eax
80103611:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103615:	8b 03                	mov    (%ebx),%eax
80103617:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010361a:	8b 06                	mov    (%esi),%eax
8010361c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103622:	8b 06                	mov    (%esi),%eax
80103624:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103628:	8b 06                	mov    (%esi),%eax
8010362a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010362e:	8b 06                	mov    (%esi),%eax
80103630:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103633:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103636:	31 c0                	xor    %eax,%eax
}
80103638:	5b                   	pop    %ebx
80103639:	5e                   	pop    %esi
8010363a:	5f                   	pop    %edi
8010363b:	5d                   	pop    %ebp
8010363c:	c3                   	ret    
8010363d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103640:	8b 03                	mov    (%ebx),%eax
80103642:	85 c0                	test   %eax,%eax
80103644:	74 1e                	je     80103664 <pipealloc+0xe4>
    fileclose(*f0);
80103646:	83 ec 0c             	sub    $0xc,%esp
80103649:	50                   	push   %eax
8010364a:	e8 f1 d9 ff ff       	call   80101040 <fileclose>
8010364f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103652:	8b 06                	mov    (%esi),%eax
80103654:	85 c0                	test   %eax,%eax
80103656:	74 0c                	je     80103664 <pipealloc+0xe4>
    fileclose(*f1);
80103658:	83 ec 0c             	sub    $0xc,%esp
8010365b:	50                   	push   %eax
8010365c:	e8 df d9 ff ff       	call   80101040 <fileclose>
80103661:	83 c4 10             	add    $0x10,%esp
}
80103664:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010366c:	5b                   	pop    %ebx
8010366d:	5e                   	pop    %esi
8010366e:	5f                   	pop    %edi
8010366f:	5d                   	pop    %ebp
80103670:	c3                   	ret    
80103671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103678:	8b 03                	mov    (%ebx),%eax
8010367a:	85 c0                	test   %eax,%eax
8010367c:	75 c8                	jne    80103646 <pipealloc+0xc6>
8010367e:	eb d2                	jmp    80103652 <pipealloc+0xd2>

80103680 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	56                   	push   %esi
80103684:	53                   	push   %ebx
80103685:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103688:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010368b:	83 ec 0c             	sub    $0xc,%esp
8010368e:	53                   	push   %ebx
8010368f:	e8 5c 10 00 00       	call   801046f0 <acquire>
  if(writable){
80103694:	83 c4 10             	add    $0x10,%esp
80103697:	85 f6                	test   %esi,%esi
80103699:	74 65                	je     80103700 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010369b:	83 ec 0c             	sub    $0xc,%esp
8010369e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801036a4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036ab:	00 00 00 
    wakeup(&p->nread);
801036ae:	50                   	push   %eax
801036af:	e8 9c 0b 00 00       	call   80104250 <wakeup>
801036b4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801036b7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036bd:	85 d2                	test   %edx,%edx
801036bf:	75 0a                	jne    801036cb <pipeclose+0x4b>
801036c1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801036c7:	85 c0                	test   %eax,%eax
801036c9:	74 15                	je     801036e0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801036ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036d1:	5b                   	pop    %ebx
801036d2:	5e                   	pop    %esi
801036d3:	5d                   	pop    %ebp
    release(&p->lock);
801036d4:	e9 b7 0f 00 00       	jmp    80104690 <release>
801036d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801036e0:	83 ec 0c             	sub    $0xc,%esp
801036e3:	53                   	push   %ebx
801036e4:	e8 a7 0f 00 00       	call   80104690 <release>
    kfree((char*)p);
801036e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036ec:	83 c4 10             	add    $0x10,%esp
}
801036ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036f2:	5b                   	pop    %ebx
801036f3:	5e                   	pop    %esi
801036f4:	5d                   	pop    %ebp
    kfree((char*)p);
801036f5:	e9 16 ef ff ff       	jmp    80102610 <kfree>
801036fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103709:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103710:	00 00 00 
    wakeup(&p->nwrite);
80103713:	50                   	push   %eax
80103714:	e8 37 0b 00 00       	call   80104250 <wakeup>
80103719:	83 c4 10             	add    $0x10,%esp
8010371c:	eb 99                	jmp    801036b7 <pipeclose+0x37>
8010371e:	66 90                	xchg   %ax,%ax

80103720 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	57                   	push   %edi
80103724:	56                   	push   %esi
80103725:	53                   	push   %ebx
80103726:	83 ec 28             	sub    $0x28,%esp
80103729:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010372c:	53                   	push   %ebx
8010372d:	e8 be 0f 00 00       	call   801046f0 <acquire>
  for(i = 0; i < n; i++){
80103732:	8b 45 10             	mov    0x10(%ebp),%eax
80103735:	83 c4 10             	add    $0x10,%esp
80103738:	85 c0                	test   %eax,%eax
8010373a:	0f 8e c0 00 00 00    	jle    80103800 <pipewrite+0xe0>
80103740:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103743:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103749:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010374f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103752:	03 45 10             	add    0x10(%ebp),%eax
80103755:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103758:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010375e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103764:	89 ca                	mov    %ecx,%edx
80103766:	05 00 02 00 00       	add    $0x200,%eax
8010376b:	39 c1                	cmp    %eax,%ecx
8010376d:	74 3f                	je     801037ae <pipewrite+0x8e>
8010376f:	eb 67                	jmp    801037d8 <pipewrite+0xb8>
80103771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103778:	e8 43 03 00 00       	call   80103ac0 <myproc>
8010377d:	8b 48 24             	mov    0x24(%eax),%ecx
80103780:	85 c9                	test   %ecx,%ecx
80103782:	75 34                	jne    801037b8 <pipewrite+0x98>
      wakeup(&p->nread);
80103784:	83 ec 0c             	sub    $0xc,%esp
80103787:	57                   	push   %edi
80103788:	e8 c3 0a 00 00       	call   80104250 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010378d:	58                   	pop    %eax
8010378e:	5a                   	pop    %edx
8010378f:	53                   	push   %ebx
80103790:	56                   	push   %esi
80103791:	e8 fa 09 00 00       	call   80104190 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103796:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010379c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801037a2:	83 c4 10             	add    $0x10,%esp
801037a5:	05 00 02 00 00       	add    $0x200,%eax
801037aa:	39 c2                	cmp    %eax,%edx
801037ac:	75 2a                	jne    801037d8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801037ae:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037b4:	85 c0                	test   %eax,%eax
801037b6:	75 c0                	jne    80103778 <pipewrite+0x58>
        release(&p->lock);
801037b8:	83 ec 0c             	sub    $0xc,%esp
801037bb:	53                   	push   %ebx
801037bc:	e8 cf 0e 00 00       	call   80104690 <release>
        return -1;
801037c1:	83 c4 10             	add    $0x10,%esp
801037c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801037c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037cc:	5b                   	pop    %ebx
801037cd:	5e                   	pop    %esi
801037ce:	5f                   	pop    %edi
801037cf:	5d                   	pop    %ebp
801037d0:	c3                   	ret    
801037d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037d8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801037db:	8d 4a 01             	lea    0x1(%edx),%ecx
801037de:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037e4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801037ea:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801037ed:	83 c6 01             	add    $0x1,%esi
801037f0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037f3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801037f7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801037fa:	0f 85 58 ff ff ff    	jne    80103758 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103800:	83 ec 0c             	sub    $0xc,%esp
80103803:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103809:	50                   	push   %eax
8010380a:	e8 41 0a 00 00       	call   80104250 <wakeup>
  release(&p->lock);
8010380f:	89 1c 24             	mov    %ebx,(%esp)
80103812:	e8 79 0e 00 00       	call   80104690 <release>
  return n;
80103817:	8b 45 10             	mov    0x10(%ebp),%eax
8010381a:	83 c4 10             	add    $0x10,%esp
8010381d:	eb aa                	jmp    801037c9 <pipewrite+0xa9>
8010381f:	90                   	nop

80103820 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	57                   	push   %edi
80103824:	56                   	push   %esi
80103825:	53                   	push   %ebx
80103826:	83 ec 18             	sub    $0x18,%esp
80103829:	8b 75 08             	mov    0x8(%ebp),%esi
8010382c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010382f:	56                   	push   %esi
80103830:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103836:	e8 b5 0e 00 00       	call   801046f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010383b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103841:	83 c4 10             	add    $0x10,%esp
80103844:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010384a:	74 2f                	je     8010387b <piperead+0x5b>
8010384c:	eb 37                	jmp    80103885 <piperead+0x65>
8010384e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103850:	e8 6b 02 00 00       	call   80103ac0 <myproc>
80103855:	8b 48 24             	mov    0x24(%eax),%ecx
80103858:	85 c9                	test   %ecx,%ecx
8010385a:	0f 85 80 00 00 00    	jne    801038e0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103860:	83 ec 08             	sub    $0x8,%esp
80103863:	56                   	push   %esi
80103864:	53                   	push   %ebx
80103865:	e8 26 09 00 00       	call   80104190 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010386a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103870:	83 c4 10             	add    $0x10,%esp
80103873:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103879:	75 0a                	jne    80103885 <piperead+0x65>
8010387b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103881:	85 c0                	test   %eax,%eax
80103883:	75 cb                	jne    80103850 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103885:	8b 55 10             	mov    0x10(%ebp),%edx
80103888:	31 db                	xor    %ebx,%ebx
8010388a:	85 d2                	test   %edx,%edx
8010388c:	7f 20                	jg     801038ae <piperead+0x8e>
8010388e:	eb 2c                	jmp    801038bc <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103890:	8d 48 01             	lea    0x1(%eax),%ecx
80103893:	25 ff 01 00 00       	and    $0x1ff,%eax
80103898:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010389e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801038a3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038a6:	83 c3 01             	add    $0x1,%ebx
801038a9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801038ac:	74 0e                	je     801038bc <piperead+0x9c>
    if(p->nread == p->nwrite)
801038ae:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038b4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801038ba:	75 d4                	jne    80103890 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801038bc:	83 ec 0c             	sub    $0xc,%esp
801038bf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801038c5:	50                   	push   %eax
801038c6:	e8 85 09 00 00       	call   80104250 <wakeup>
  release(&p->lock);
801038cb:	89 34 24             	mov    %esi,(%esp)
801038ce:	e8 bd 0d 00 00       	call   80104690 <release>
  return i;
801038d3:	83 c4 10             	add    $0x10,%esp
}
801038d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038d9:	89 d8                	mov    %ebx,%eax
801038db:	5b                   	pop    %ebx
801038dc:	5e                   	pop    %esi
801038dd:	5f                   	pop    %edi
801038de:	5d                   	pop    %ebp
801038df:	c3                   	ret    
      release(&p->lock);
801038e0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038e3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038e8:	56                   	push   %esi
801038e9:	e8 a2 0d 00 00       	call   80104690 <release>
      return -1;
801038ee:	83 c4 10             	add    $0x10,%esp
}
801038f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038f4:	89 d8                	mov    %ebx,%eax
801038f6:	5b                   	pop    %ebx
801038f7:	5e                   	pop    %esi
801038f8:	5f                   	pop    %edi
801038f9:	5d                   	pop    %ebp
801038fa:	c3                   	ret    
801038fb:	66 90                	xchg   %ax,%ax
801038fd:	66 90                	xchg   %ax,%ax
801038ff:	90                   	nop

80103900 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103904:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
80103909:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010390c:	68 20 1d 11 80       	push   $0x80111d20
80103911:	e8 da 0d 00 00       	call   801046f0 <acquire>
80103916:	83 c4 10             	add    $0x10,%esp
80103919:	eb 10                	jmp    8010392b <allocproc+0x2b>
8010391b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010391f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103920:	83 c3 7c             	add    $0x7c,%ebx
80103923:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103929:	74 75                	je     801039a0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010392b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010392e:	85 c0                	test   %eax,%eax
80103930:	75 ee                	jne    80103920 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103932:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103937:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010393a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103941:	89 43 10             	mov    %eax,0x10(%ebx)
80103944:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103947:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
8010394c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103952:	e8 39 0d 00 00       	call   80104690 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103957:	e8 74 ee ff ff       	call   801027d0 <kalloc>
8010395c:	83 c4 10             	add    $0x10,%esp
8010395f:	89 43 08             	mov    %eax,0x8(%ebx)
80103962:	85 c0                	test   %eax,%eax
80103964:	74 53                	je     801039b9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103966:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010396c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010396f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103974:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103977:	c7 40 14 a2 59 10 80 	movl   $0x801059a2,0x14(%eax)
  p->context = (struct context*)sp;
8010397e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103981:	6a 14                	push   $0x14
80103983:	6a 00                	push   $0x0
80103985:	50                   	push   %eax
80103986:	e8 25 0e 00 00       	call   801047b0 <memset>
  p->context->eip = (uint)forkret;
8010398b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010398e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103991:	c7 40 10 d0 39 10 80 	movl   $0x801039d0,0x10(%eax)
}
80103998:	89 d8                	mov    %ebx,%eax
8010399a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010399d:	c9                   	leave  
8010399e:	c3                   	ret    
8010399f:	90                   	nop
  release(&ptable.lock);
801039a0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801039a3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801039a5:	68 20 1d 11 80       	push   $0x80111d20
801039aa:	e8 e1 0c 00 00       	call   80104690 <release>
}
801039af:	89 d8                	mov    %ebx,%eax
  return 0;
801039b1:	83 c4 10             	add    $0x10,%esp
}
801039b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039b7:	c9                   	leave  
801039b8:	c3                   	ret    
    p->state = UNUSED;
801039b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801039c0:	31 db                	xor    %ebx,%ebx
}
801039c2:	89 d8                	mov    %ebx,%eax
801039c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039c7:	c9                   	leave  
801039c8:	c3                   	ret    
801039c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801039d6:	68 20 1d 11 80       	push   $0x80111d20
801039db:	e8 b0 0c 00 00       	call   80104690 <release>

  if (first) {
801039e0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801039e5:	83 c4 10             	add    $0x10,%esp
801039e8:	85 c0                	test   %eax,%eax
801039ea:	75 04                	jne    801039f0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039ec:	c9                   	leave  
801039ed:	c3                   	ret    
801039ee:	66 90                	xchg   %ax,%ax
    first = 0;
801039f0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801039f7:	00 00 00 
    iinit(ROOTDEV);
801039fa:	83 ec 0c             	sub    $0xc,%esp
801039fd:	6a 01                	push   $0x1
801039ff:	e8 ac dc ff ff       	call   801016b0 <iinit>
    initlog(ROOTDEV);
80103a04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a0b:	e8 00 f4 ff ff       	call   80102e10 <initlog>
}
80103a10:	83 c4 10             	add    $0x10,%esp
80103a13:	c9                   	leave  
80103a14:	c3                   	ret    
80103a15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a20 <pinit>:
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a26:	68 60 78 10 80       	push   $0x80107860
80103a2b:	68 20 1d 11 80       	push   $0x80111d20
80103a30:	e8 eb 0a 00 00       	call   80104520 <initlock>
}
80103a35:	83 c4 10             	add    $0x10,%esp
80103a38:	c9                   	leave  
80103a39:	c3                   	ret    
80103a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a40 <mycpu>:
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	56                   	push   %esi
80103a44:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a45:	9c                   	pushf  
80103a46:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a47:	f6 c4 02             	test   $0x2,%ah
80103a4a:	75 46                	jne    80103a92 <mycpu+0x52>
  apicid = lapicid();
80103a4c:	e8 ef ef ff ff       	call   80102a40 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a51:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103a57:	85 f6                	test   %esi,%esi
80103a59:	7e 2a                	jle    80103a85 <mycpu+0x45>
80103a5b:	31 d2                	xor    %edx,%edx
80103a5d:	eb 08                	jmp    80103a67 <mycpu+0x27>
80103a5f:	90                   	nop
80103a60:	83 c2 01             	add    $0x1,%edx
80103a63:	39 f2                	cmp    %esi,%edx
80103a65:	74 1e                	je     80103a85 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103a67:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a6d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103a74:	39 c3                	cmp    %eax,%ebx
80103a76:	75 e8                	jne    80103a60 <mycpu+0x20>
}
80103a78:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a7b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103a81:	5b                   	pop    %ebx
80103a82:	5e                   	pop    %esi
80103a83:	5d                   	pop    %ebp
80103a84:	c3                   	ret    
  panic("unknown apicid\n");
80103a85:	83 ec 0c             	sub    $0xc,%esp
80103a88:	68 67 78 10 80       	push   $0x80107867
80103a8d:	e8 ee c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a92:	83 ec 0c             	sub    $0xc,%esp
80103a95:	68 44 79 10 80       	push   $0x80107944
80103a9a:	e8 e1 c8 ff ff       	call   80100380 <panic>
80103a9f:	90                   	nop

80103aa0 <cpuid>:
cpuid() {
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103aa6:	e8 95 ff ff ff       	call   80103a40 <mycpu>
}
80103aab:	c9                   	leave  
  return mycpu()-cpus;
80103aac:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103ab1:	c1 f8 04             	sar    $0x4,%eax
80103ab4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103aba:	c3                   	ret    
80103abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103abf:	90                   	nop

80103ac0 <myproc>:
myproc(void) {
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	53                   	push   %ebx
80103ac4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ac7:	e8 d4 0a 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103acc:	e8 6f ff ff ff       	call   80103a40 <mycpu>
  p = c->proc;
80103ad1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ad7:	e8 14 0b 00 00       	call   801045f0 <popcli>
}
80103adc:	89 d8                	mov    %ebx,%eax
80103ade:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ae1:	c9                   	leave  
80103ae2:	c3                   	ret    
80103ae3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103af0 <userinit>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	53                   	push   %ebx
80103af4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103af7:	e8 04 fe ff ff       	call   80103900 <allocproc>
80103afc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103afe:	a3 54 3c 11 80       	mov    %eax,0x80113c54
  if((p->pgdir = setupkvm()) == 0)
80103b03:	e8 88 34 00 00       	call   80106f90 <setupkvm>
80103b08:	89 43 04             	mov    %eax,0x4(%ebx)
80103b0b:	85 c0                	test   %eax,%eax
80103b0d:	0f 84 bd 00 00 00    	je     80103bd0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b13:	83 ec 04             	sub    $0x4,%esp
80103b16:	68 2c 00 00 00       	push   $0x2c
80103b1b:	68 60 a4 10 80       	push   $0x8010a460
80103b20:	50                   	push   %eax
80103b21:	e8 1a 31 00 00       	call   80106c40 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b26:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b29:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b2f:	6a 4c                	push   $0x4c
80103b31:	6a 00                	push   $0x0
80103b33:	ff 73 18             	push   0x18(%ebx)
80103b36:	e8 75 0c 00 00       	call   801047b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b3e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b43:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b46:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b4b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b4f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b52:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b56:	8b 43 18             	mov    0x18(%ebx),%eax
80103b59:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b5d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b61:	8b 43 18             	mov    0x18(%ebx),%eax
80103b64:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b68:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b6c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b6f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b76:	8b 43 18             	mov    0x18(%ebx),%eax
80103b79:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b80:	8b 43 18             	mov    0x18(%ebx),%eax
80103b83:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b8a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b8d:	6a 10                	push   $0x10
80103b8f:	68 90 78 10 80       	push   $0x80107890
80103b94:	50                   	push   %eax
80103b95:	e8 d6 0d 00 00       	call   80104970 <safestrcpy>
  p->cwd = namei("/");
80103b9a:	c7 04 24 99 78 10 80 	movl   $0x80107899,(%esp)
80103ba1:	e8 4a e6 ff ff       	call   801021f0 <namei>
80103ba6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ba9:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103bb0:	e8 3b 0b 00 00       	call   801046f0 <acquire>
  p->state = RUNNABLE;
80103bb5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bbc:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103bc3:	e8 c8 0a 00 00       	call   80104690 <release>
}
80103bc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bcb:	83 c4 10             	add    $0x10,%esp
80103bce:	c9                   	leave  
80103bcf:	c3                   	ret    
    panic("userinit: out of memory?");
80103bd0:	83 ec 0c             	sub    $0xc,%esp
80103bd3:	68 77 78 10 80       	push   $0x80107877
80103bd8:	e8 a3 c7 ff ff       	call   80100380 <panic>
80103bdd:	8d 76 00             	lea    0x0(%esi),%esi

80103be0 <growproc>:
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	56                   	push   %esi
80103be4:	53                   	push   %ebx
80103be5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103be8:	e8 b3 09 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103bed:	e8 4e fe ff ff       	call   80103a40 <mycpu>
  p = c->proc;
80103bf2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bf8:	e8 f3 09 00 00       	call   801045f0 <popcli>
  sz = curproc->sz;
80103bfd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103bff:	85 f6                	test   %esi,%esi
80103c01:	7f 1d                	jg     80103c20 <growproc+0x40>
  } else if(n < 0){
80103c03:	75 3b                	jne    80103c40 <growproc+0x60>
  switchuvm(curproc);
80103c05:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c08:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c0a:	53                   	push   %ebx
80103c0b:	e8 20 2f 00 00       	call   80106b30 <switchuvm>
  return 0;
80103c10:	83 c4 10             	add    $0x10,%esp
80103c13:	31 c0                	xor    %eax,%eax
}
80103c15:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c18:	5b                   	pop    %ebx
80103c19:	5e                   	pop    %esi
80103c1a:	5d                   	pop    %ebp
80103c1b:	c3                   	ret    
80103c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c20:	83 ec 04             	sub    $0x4,%esp
80103c23:	01 c6                	add    %eax,%esi
80103c25:	56                   	push   %esi
80103c26:	50                   	push   %eax
80103c27:	ff 73 04             	push   0x4(%ebx)
80103c2a:	e8 81 31 00 00       	call   80106db0 <allocuvm>
80103c2f:	83 c4 10             	add    $0x10,%esp
80103c32:	85 c0                	test   %eax,%eax
80103c34:	75 cf                	jne    80103c05 <growproc+0x25>
      return -1;
80103c36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c3b:	eb d8                	jmp    80103c15 <growproc+0x35>
80103c3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c40:	83 ec 04             	sub    $0x4,%esp
80103c43:	01 c6                	add    %eax,%esi
80103c45:	56                   	push   %esi
80103c46:	50                   	push   %eax
80103c47:	ff 73 04             	push   0x4(%ebx)
80103c4a:	e8 91 32 00 00       	call   80106ee0 <deallocuvm>
80103c4f:	83 c4 10             	add    $0x10,%esp
80103c52:	85 c0                	test   %eax,%eax
80103c54:	75 af                	jne    80103c05 <growproc+0x25>
80103c56:	eb de                	jmp    80103c36 <growproc+0x56>
80103c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c5f:	90                   	nop

80103c60 <fork>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	57                   	push   %edi
80103c64:	56                   	push   %esi
80103c65:	53                   	push   %ebx
80103c66:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c69:	e8 32 09 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103c6e:	e8 cd fd ff ff       	call   80103a40 <mycpu>
  p = c->proc;
80103c73:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c79:	e8 72 09 00 00       	call   801045f0 <popcli>
  if((np = allocproc()) == 0){
80103c7e:	e8 7d fc ff ff       	call   80103900 <allocproc>
80103c83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c86:	85 c0                	test   %eax,%eax
80103c88:	0f 84 b7 00 00 00    	je     80103d45 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c8e:	83 ec 08             	sub    $0x8,%esp
80103c91:	ff 33                	push   (%ebx)
80103c93:	89 c7                	mov    %eax,%edi
80103c95:	ff 73 04             	push   0x4(%ebx)
80103c98:	e8 e3 33 00 00       	call   80107080 <copyuvm>
80103c9d:	83 c4 10             	add    $0x10,%esp
80103ca0:	89 47 04             	mov    %eax,0x4(%edi)
80103ca3:	85 c0                	test   %eax,%eax
80103ca5:	0f 84 a1 00 00 00    	je     80103d4c <fork+0xec>
  np->sz = curproc->sz;
80103cab:	8b 03                	mov    (%ebx),%eax
80103cad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103cb0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103cb2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103cb5:	89 c8                	mov    %ecx,%eax
80103cb7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103cba:	b9 13 00 00 00       	mov    $0x13,%ecx
80103cbf:	8b 73 18             	mov    0x18(%ebx),%esi
80103cc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103cc4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103cc6:	8b 40 18             	mov    0x18(%eax),%eax
80103cc9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103cd0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103cd4:	85 c0                	test   %eax,%eax
80103cd6:	74 13                	je     80103ceb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103cd8:	83 ec 0c             	sub    $0xc,%esp
80103cdb:	50                   	push   %eax
80103cdc:	e8 0f d3 ff ff       	call   80100ff0 <filedup>
80103ce1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ce4:	83 c4 10             	add    $0x10,%esp
80103ce7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103ceb:	83 c6 01             	add    $0x1,%esi
80103cee:	83 fe 10             	cmp    $0x10,%esi
80103cf1:	75 dd                	jne    80103cd0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103cf3:	83 ec 0c             	sub    $0xc,%esp
80103cf6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cf9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103cfc:	e8 9f db ff ff       	call   801018a0 <idup>
80103d01:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d04:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d07:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d0a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d0d:	6a 10                	push   $0x10
80103d0f:	53                   	push   %ebx
80103d10:	50                   	push   %eax
80103d11:	e8 5a 0c 00 00       	call   80104970 <safestrcpy>
  pid = np->pid;
80103d16:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d19:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103d20:	e8 cb 09 00 00       	call   801046f0 <acquire>
  np->state = RUNNABLE;
80103d25:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d2c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103d33:	e8 58 09 00 00       	call   80104690 <release>
  return pid;
80103d38:	83 c4 10             	add    $0x10,%esp
}
80103d3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d3e:	89 d8                	mov    %ebx,%eax
80103d40:	5b                   	pop    %ebx
80103d41:	5e                   	pop    %esi
80103d42:	5f                   	pop    %edi
80103d43:	5d                   	pop    %ebp
80103d44:	c3                   	ret    
    return -1;
80103d45:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d4a:	eb ef                	jmp    80103d3b <fork+0xdb>
    kfree(np->kstack);
80103d4c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d4f:	83 ec 0c             	sub    $0xc,%esp
80103d52:	ff 73 08             	push   0x8(%ebx)
80103d55:	e8 b6 e8 ff ff       	call   80102610 <kfree>
    np->kstack = 0;
80103d5a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d61:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d64:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d6b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d70:	eb c9                	jmp    80103d3b <fork+0xdb>
80103d72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d80 <scheduler>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	57                   	push   %edi
80103d84:	56                   	push   %esi
80103d85:	53                   	push   %ebx
80103d86:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d89:	e8 b2 fc ff ff       	call   80103a40 <mycpu>
  c->proc = 0;
80103d8e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d95:	00 00 00 
  struct cpu *c = mycpu();
80103d98:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d9a:	8d 78 04             	lea    0x4(%eax),%edi
80103d9d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103da0:	fb                   	sti    
    acquire(&ptable.lock);
80103da1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103da4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103da9:	68 20 1d 11 80       	push   $0x80111d20
80103dae:	e8 3d 09 00 00       	call   801046f0 <acquire>
80103db3:	83 c4 10             	add    $0x10,%esp
80103db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dbd:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103dc0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103dc4:	75 33                	jne    80103df9 <scheduler+0x79>
      switchuvm(p);
80103dc6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103dc9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103dcf:	53                   	push   %ebx
80103dd0:	e8 5b 2d 00 00       	call   80106b30 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103dd5:	58                   	pop    %eax
80103dd6:	5a                   	pop    %edx
80103dd7:	ff 73 1c             	push   0x1c(%ebx)
80103dda:	57                   	push   %edi
      p->state = RUNNING;
80103ddb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103de2:	e8 e4 0b 00 00       	call   801049cb <swtch>
      switchkvm();
80103de7:	e8 34 2d 00 00       	call   80106b20 <switchkvm>
      c->proc = 0;
80103dec:	83 c4 10             	add    $0x10,%esp
80103def:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103df6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df9:	83 c3 7c             	add    $0x7c,%ebx
80103dfc:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103e02:	75 bc                	jne    80103dc0 <scheduler+0x40>
    release(&ptable.lock);
80103e04:	83 ec 0c             	sub    $0xc,%esp
80103e07:	68 20 1d 11 80       	push   $0x80111d20
80103e0c:	e8 7f 08 00 00       	call   80104690 <release>
    sti();
80103e11:	83 c4 10             	add    $0x10,%esp
80103e14:	eb 8a                	jmp    80103da0 <scheduler+0x20>
80103e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e1d:	8d 76 00             	lea    0x0(%esi),%esi

80103e20 <sched>:
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	56                   	push   %esi
80103e24:	53                   	push   %ebx
  pushcli();
80103e25:	e8 76 07 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103e2a:	e8 11 fc ff ff       	call   80103a40 <mycpu>
  p = c->proc;
80103e2f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e35:	e8 b6 07 00 00       	call   801045f0 <popcli>
  if(!holding(&ptable.lock))
80103e3a:	83 ec 0c             	sub    $0xc,%esp
80103e3d:	68 20 1d 11 80       	push   $0x80111d20
80103e42:	e8 09 08 00 00       	call   80104650 <holding>
80103e47:	83 c4 10             	add    $0x10,%esp
80103e4a:	85 c0                	test   %eax,%eax
80103e4c:	74 4f                	je     80103e9d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103e4e:	e8 ed fb ff ff       	call   80103a40 <mycpu>
80103e53:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e5a:	75 68                	jne    80103ec4 <sched+0xa4>
  if(p->state == RUNNING)
80103e5c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e60:	74 55                	je     80103eb7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e62:	9c                   	pushf  
80103e63:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e64:	f6 c4 02             	test   $0x2,%ah
80103e67:	75 41                	jne    80103eaa <sched+0x8a>
  intena = mycpu()->intena;
80103e69:	e8 d2 fb ff ff       	call   80103a40 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e6e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e71:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e77:	e8 c4 fb ff ff       	call   80103a40 <mycpu>
80103e7c:	83 ec 08             	sub    $0x8,%esp
80103e7f:	ff 70 04             	push   0x4(%eax)
80103e82:	53                   	push   %ebx
80103e83:	e8 43 0b 00 00       	call   801049cb <swtch>
  mycpu()->intena = intena;
80103e88:	e8 b3 fb ff ff       	call   80103a40 <mycpu>
}
80103e8d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e90:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e99:	5b                   	pop    %ebx
80103e9a:	5e                   	pop    %esi
80103e9b:	5d                   	pop    %ebp
80103e9c:	c3                   	ret    
    panic("sched ptable.lock");
80103e9d:	83 ec 0c             	sub    $0xc,%esp
80103ea0:	68 9b 78 10 80       	push   $0x8010789b
80103ea5:	e8 d6 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103eaa:	83 ec 0c             	sub    $0xc,%esp
80103ead:	68 c7 78 10 80       	push   $0x801078c7
80103eb2:	e8 c9 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103eb7:	83 ec 0c             	sub    $0xc,%esp
80103eba:	68 b9 78 10 80       	push   $0x801078b9
80103ebf:	e8 bc c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103ec4:	83 ec 0c             	sub    $0xc,%esp
80103ec7:	68 ad 78 10 80       	push   $0x801078ad
80103ecc:	e8 af c4 ff ff       	call   80100380 <panic>
80103ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edf:	90                   	nop

80103ee0 <exit>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	57                   	push   %edi
80103ee4:	56                   	push   %esi
80103ee5:	53                   	push   %ebx
80103ee6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103ee9:	e8 d2 fb ff ff       	call   80103ac0 <myproc>
  if(curproc == initproc)
80103eee:	39 05 54 3c 11 80    	cmp    %eax,0x80113c54
80103ef4:	0f 84 fd 00 00 00    	je     80103ff7 <exit+0x117>
80103efa:	89 c3                	mov    %eax,%ebx
80103efc:	8d 70 28             	lea    0x28(%eax),%esi
80103eff:	8d 78 68             	lea    0x68(%eax),%edi
80103f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103f08:	8b 06                	mov    (%esi),%eax
80103f0a:	85 c0                	test   %eax,%eax
80103f0c:	74 12                	je     80103f20 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103f0e:	83 ec 0c             	sub    $0xc,%esp
80103f11:	50                   	push   %eax
80103f12:	e8 29 d1 ff ff       	call   80101040 <fileclose>
      curproc->ofile[fd] = 0;
80103f17:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f1d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f20:	83 c6 04             	add    $0x4,%esi
80103f23:	39 f7                	cmp    %esi,%edi
80103f25:	75 e1                	jne    80103f08 <exit+0x28>
  begin_op();
80103f27:	e8 84 ef ff ff       	call   80102eb0 <begin_op>
  iput(curproc->cwd);
80103f2c:	83 ec 0c             	sub    $0xc,%esp
80103f2f:	ff 73 68             	push   0x68(%ebx)
80103f32:	e8 c9 da ff ff       	call   80101a00 <iput>
  end_op();
80103f37:	e8 e4 ef ff ff       	call   80102f20 <end_op>
  curproc->cwd = 0;
80103f3c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103f43:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103f4a:	e8 a1 07 00 00       	call   801046f0 <acquire>
  wakeup1(curproc->parent);
80103f4f:	8b 53 14             	mov    0x14(%ebx),%edx
80103f52:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f55:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103f5a:	eb 0e                	jmp    80103f6a <exit+0x8a>
80103f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f60:	83 c0 7c             	add    $0x7c,%eax
80103f63:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103f68:	74 1c                	je     80103f86 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103f6a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f6e:	75 f0                	jne    80103f60 <exit+0x80>
80103f70:	3b 50 20             	cmp    0x20(%eax),%edx
80103f73:	75 eb                	jne    80103f60 <exit+0x80>
      p->state = RUNNABLE;
80103f75:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f7c:	83 c0 7c             	add    $0x7c,%eax
80103f7f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103f84:	75 e4                	jne    80103f6a <exit+0x8a>
      p->parent = initproc;
80103f86:	8b 0d 54 3c 11 80    	mov    0x80113c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f8c:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103f91:	eb 10                	jmp    80103fa3 <exit+0xc3>
80103f93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f97:	90                   	nop
80103f98:	83 c2 7c             	add    $0x7c,%edx
80103f9b:	81 fa 54 3c 11 80    	cmp    $0x80113c54,%edx
80103fa1:	74 3b                	je     80103fde <exit+0xfe>
    if(p->parent == curproc){
80103fa3:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103fa6:	75 f0                	jne    80103f98 <exit+0xb8>
      if(p->state == ZOMBIE)
80103fa8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103fac:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103faf:	75 e7                	jne    80103f98 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fb1:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103fb6:	eb 12                	jmp    80103fca <exit+0xea>
80103fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fbf:	90                   	nop
80103fc0:	83 c0 7c             	add    $0x7c,%eax
80103fc3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103fc8:	74 ce                	je     80103f98 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103fca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fce:	75 f0                	jne    80103fc0 <exit+0xe0>
80103fd0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103fd3:	75 eb                	jne    80103fc0 <exit+0xe0>
      p->state = RUNNABLE;
80103fd5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fdc:	eb e2                	jmp    80103fc0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103fde:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103fe5:	e8 36 fe ff ff       	call   80103e20 <sched>
  panic("zombie exit");
80103fea:	83 ec 0c             	sub    $0xc,%esp
80103fed:	68 e8 78 10 80       	push   $0x801078e8
80103ff2:	e8 89 c3 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103ff7:	83 ec 0c             	sub    $0xc,%esp
80103ffa:	68 db 78 10 80       	push   $0x801078db
80103fff:	e8 7c c3 ff ff       	call   80100380 <panic>
80104004:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010400b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010400f:	90                   	nop

80104010 <wait>:
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	56                   	push   %esi
80104014:	53                   	push   %ebx
  pushcli();
80104015:	e8 86 05 00 00       	call   801045a0 <pushcli>
  c = mycpu();
8010401a:	e8 21 fa ff ff       	call   80103a40 <mycpu>
  p = c->proc;
8010401f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104025:	e8 c6 05 00 00       	call   801045f0 <popcli>
  acquire(&ptable.lock);
8010402a:	83 ec 0c             	sub    $0xc,%esp
8010402d:	68 20 1d 11 80       	push   $0x80111d20
80104032:	e8 b9 06 00 00       	call   801046f0 <acquire>
80104037:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010403a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010403c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80104041:	eb 10                	jmp    80104053 <wait+0x43>
80104043:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104047:	90                   	nop
80104048:	83 c3 7c             	add    $0x7c,%ebx
8010404b:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80104051:	74 1b                	je     8010406e <wait+0x5e>
      if(p->parent != curproc)
80104053:	39 73 14             	cmp    %esi,0x14(%ebx)
80104056:	75 f0                	jne    80104048 <wait+0x38>
      if(p->state == ZOMBIE){
80104058:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010405c:	74 62                	je     801040c0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010405e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104061:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104066:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
8010406c:	75 e5                	jne    80104053 <wait+0x43>
    if(!havekids || curproc->killed){
8010406e:	85 c0                	test   %eax,%eax
80104070:	0f 84 a0 00 00 00    	je     80104116 <wait+0x106>
80104076:	8b 46 24             	mov    0x24(%esi),%eax
80104079:	85 c0                	test   %eax,%eax
8010407b:	0f 85 95 00 00 00    	jne    80104116 <wait+0x106>
  pushcli();
80104081:	e8 1a 05 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80104086:	e8 b5 f9 ff ff       	call   80103a40 <mycpu>
  p = c->proc;
8010408b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104091:	e8 5a 05 00 00       	call   801045f0 <popcli>
  if(p == 0)
80104096:	85 db                	test   %ebx,%ebx
80104098:	0f 84 8f 00 00 00    	je     8010412d <wait+0x11d>
  p->chan = chan;
8010409e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801040a1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040a8:	e8 73 fd ff ff       	call   80103e20 <sched>
  p->chan = 0;
801040ad:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040b4:	eb 84                	jmp    8010403a <wait+0x2a>
801040b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040bd:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
801040c0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801040c3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040c6:	ff 73 08             	push   0x8(%ebx)
801040c9:	e8 42 e5 ff ff       	call   80102610 <kfree>
        p->kstack = 0;
801040ce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040d5:	5a                   	pop    %edx
801040d6:	ff 73 04             	push   0x4(%ebx)
801040d9:	e8 32 2e 00 00       	call   80106f10 <freevm>
        p->pid = 0;
801040de:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040e5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040ec:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040f0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040f7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040fe:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104105:	e8 86 05 00 00       	call   80104690 <release>
        return pid;
8010410a:	83 c4 10             	add    $0x10,%esp
}
8010410d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104110:	89 f0                	mov    %esi,%eax
80104112:	5b                   	pop    %ebx
80104113:	5e                   	pop    %esi
80104114:	5d                   	pop    %ebp
80104115:	c3                   	ret    
      release(&ptable.lock);
80104116:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104119:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010411e:	68 20 1d 11 80       	push   $0x80111d20
80104123:	e8 68 05 00 00       	call   80104690 <release>
      return -1;
80104128:	83 c4 10             	add    $0x10,%esp
8010412b:	eb e0                	jmp    8010410d <wait+0xfd>
    panic("sleep");
8010412d:	83 ec 0c             	sub    $0xc,%esp
80104130:	68 f4 78 10 80       	push   $0x801078f4
80104135:	e8 46 c2 ff ff       	call   80100380 <panic>
8010413a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104140 <yield>:
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104147:	68 20 1d 11 80       	push   $0x80111d20
8010414c:	e8 9f 05 00 00       	call   801046f0 <acquire>
  pushcli();
80104151:	e8 4a 04 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80104156:	e8 e5 f8 ff ff       	call   80103a40 <mycpu>
  p = c->proc;
8010415b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104161:	e8 8a 04 00 00       	call   801045f0 <popcli>
  myproc()->state = RUNNABLE;
80104166:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010416d:	e8 ae fc ff ff       	call   80103e20 <sched>
  release(&ptable.lock);
80104172:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104179:	e8 12 05 00 00       	call   80104690 <release>
}
8010417e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104181:	83 c4 10             	add    $0x10,%esp
80104184:	c9                   	leave  
80104185:	c3                   	ret    
80104186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010418d:	8d 76 00             	lea    0x0(%esi),%esi

80104190 <sleep>:
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	57                   	push   %edi
80104194:	56                   	push   %esi
80104195:	53                   	push   %ebx
80104196:	83 ec 0c             	sub    $0xc,%esp
80104199:	8b 7d 08             	mov    0x8(%ebp),%edi
8010419c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010419f:	e8 fc 03 00 00       	call   801045a0 <pushcli>
  c = mycpu();
801041a4:	e8 97 f8 ff ff       	call   80103a40 <mycpu>
  p = c->proc;
801041a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041af:	e8 3c 04 00 00       	call   801045f0 <popcli>
  if(p == 0)
801041b4:	85 db                	test   %ebx,%ebx
801041b6:	0f 84 87 00 00 00    	je     80104243 <sleep+0xb3>
  if(lk == 0)
801041bc:	85 f6                	test   %esi,%esi
801041be:	74 76                	je     80104236 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041c0:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801041c6:	74 50                	je     80104218 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041c8:	83 ec 0c             	sub    $0xc,%esp
801041cb:	68 20 1d 11 80       	push   $0x80111d20
801041d0:	e8 1b 05 00 00       	call   801046f0 <acquire>
    release(lk);
801041d5:	89 34 24             	mov    %esi,(%esp)
801041d8:	e8 b3 04 00 00       	call   80104690 <release>
  p->chan = chan;
801041dd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041e0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041e7:	e8 34 fc ff ff       	call   80103e20 <sched>
  p->chan = 0;
801041ec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801041f3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801041fa:	e8 91 04 00 00       	call   80104690 <release>
    acquire(lk);
801041ff:	89 75 08             	mov    %esi,0x8(%ebp)
80104202:	83 c4 10             	add    $0x10,%esp
}
80104205:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104208:	5b                   	pop    %ebx
80104209:	5e                   	pop    %esi
8010420a:	5f                   	pop    %edi
8010420b:	5d                   	pop    %ebp
    acquire(lk);
8010420c:	e9 df 04 00 00       	jmp    801046f0 <acquire>
80104211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104218:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010421b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104222:	e8 f9 fb ff ff       	call   80103e20 <sched>
  p->chan = 0;
80104227:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010422e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104231:	5b                   	pop    %ebx
80104232:	5e                   	pop    %esi
80104233:	5f                   	pop    %edi
80104234:	5d                   	pop    %ebp
80104235:	c3                   	ret    
    panic("sleep without lk");
80104236:	83 ec 0c             	sub    $0xc,%esp
80104239:	68 fa 78 10 80       	push   $0x801078fa
8010423e:	e8 3d c1 ff ff       	call   80100380 <panic>
    panic("sleep");
80104243:	83 ec 0c             	sub    $0xc,%esp
80104246:	68 f4 78 10 80       	push   $0x801078f4
8010424b:	e8 30 c1 ff ff       	call   80100380 <panic>

80104250 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 10             	sub    $0x10,%esp
80104257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010425a:	68 20 1d 11 80       	push   $0x80111d20
8010425f:	e8 8c 04 00 00       	call   801046f0 <acquire>
80104264:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104267:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010426c:	eb 0c                	jmp    8010427a <wakeup+0x2a>
8010426e:	66 90                	xchg   %ax,%ax
80104270:	83 c0 7c             	add    $0x7c,%eax
80104273:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104278:	74 1c                	je     80104296 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010427a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010427e:	75 f0                	jne    80104270 <wakeup+0x20>
80104280:	3b 58 20             	cmp    0x20(%eax),%ebx
80104283:	75 eb                	jne    80104270 <wakeup+0x20>
      p->state = RUNNABLE;
80104285:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010428c:	83 c0 7c             	add    $0x7c,%eax
8010428f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104294:	75 e4                	jne    8010427a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104296:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
8010429d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042a0:	c9                   	leave  
  release(&ptable.lock);
801042a1:	e9 ea 03 00 00       	jmp    80104690 <release>
801042a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ad:	8d 76 00             	lea    0x0(%esi),%esi

801042b0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	53                   	push   %ebx
801042b4:	83 ec 10             	sub    $0x10,%esp
801042b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801042ba:	68 20 1d 11 80       	push   $0x80111d20
801042bf:	e8 2c 04 00 00       	call   801046f0 <acquire>
801042c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042c7:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801042cc:	eb 0c                	jmp    801042da <kill+0x2a>
801042ce:	66 90                	xchg   %ax,%ax
801042d0:	83 c0 7c             	add    $0x7c,%eax
801042d3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801042d8:	74 36                	je     80104310 <kill+0x60>
    if(p->pid == pid){
801042da:	39 58 10             	cmp    %ebx,0x10(%eax)
801042dd:	75 f1                	jne    801042d0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042df:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042e3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042ea:	75 07                	jne    801042f3 <kill+0x43>
        p->state = RUNNABLE;
801042ec:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042f3:	83 ec 0c             	sub    $0xc,%esp
801042f6:	68 20 1d 11 80       	push   $0x80111d20
801042fb:	e8 90 03 00 00       	call   80104690 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104300:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104303:	83 c4 10             	add    $0x10,%esp
80104306:	31 c0                	xor    %eax,%eax
}
80104308:	c9                   	leave  
80104309:	c3                   	ret    
8010430a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104310:	83 ec 0c             	sub    $0xc,%esp
80104313:	68 20 1d 11 80       	push   $0x80111d20
80104318:	e8 73 03 00 00       	call   80104690 <release>
}
8010431d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104320:	83 c4 10             	add    $0x10,%esp
80104323:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104328:	c9                   	leave  
80104329:	c3                   	ret    
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104330 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	57                   	push   %edi
80104334:	56                   	push   %esi
80104335:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104338:	53                   	push   %ebx
80104339:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010433e:	83 ec 3c             	sub    $0x3c,%esp
80104341:	eb 24                	jmp    80104367 <procdump+0x37>
80104343:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104347:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104348:	83 ec 0c             	sub    $0xc,%esp
8010434b:	68 77 7c 10 80       	push   $0x80107c77
80104350:	e8 4b c3 ff ff       	call   801006a0 <cprintf>
80104355:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104358:	83 c3 7c             	add    $0x7c,%ebx
8010435b:	81 fb c0 3c 11 80    	cmp    $0x80113cc0,%ebx
80104361:	0f 84 81 00 00 00    	je     801043e8 <procdump+0xb8>
    if(p->state == UNUSED)
80104367:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010436a:	85 c0                	test   %eax,%eax
8010436c:	74 ea                	je     80104358 <procdump+0x28>
      state = "???";
8010436e:	ba 0b 79 10 80       	mov    $0x8010790b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104373:	83 f8 05             	cmp    $0x5,%eax
80104376:	77 11                	ja     80104389 <procdump+0x59>
80104378:	8b 14 85 6c 79 10 80 	mov    -0x7fef8694(,%eax,4),%edx
      state = "???";
8010437f:	b8 0b 79 10 80       	mov    $0x8010790b,%eax
80104384:	85 d2                	test   %edx,%edx
80104386:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104389:	53                   	push   %ebx
8010438a:	52                   	push   %edx
8010438b:	ff 73 a4             	push   -0x5c(%ebx)
8010438e:	68 0f 79 10 80       	push   $0x8010790f
80104393:	e8 08 c3 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104398:	83 c4 10             	add    $0x10,%esp
8010439b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010439f:	75 a7                	jne    80104348 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801043a1:	83 ec 08             	sub    $0x8,%esp
801043a4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801043a7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801043aa:	50                   	push   %eax
801043ab:	8b 43 b0             	mov    -0x50(%ebx),%eax
801043ae:	8b 40 0c             	mov    0xc(%eax),%eax
801043b1:	83 c0 08             	add    $0x8,%eax
801043b4:	50                   	push   %eax
801043b5:	e8 86 01 00 00       	call   80104540 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801043ba:	83 c4 10             	add    $0x10,%esp
801043bd:	8d 76 00             	lea    0x0(%esi),%esi
801043c0:	8b 17                	mov    (%edi),%edx
801043c2:	85 d2                	test   %edx,%edx
801043c4:	74 82                	je     80104348 <procdump+0x18>
        cprintf(" %p", pc[i]);
801043c6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801043c9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801043cc:	52                   	push   %edx
801043cd:	68 21 73 10 80       	push   $0x80107321
801043d2:	e8 c9 c2 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043d7:	83 c4 10             	add    $0x10,%esp
801043da:	39 fe                	cmp    %edi,%esi
801043dc:	75 e2                	jne    801043c0 <procdump+0x90>
801043de:	e9 65 ff ff ff       	jmp    80104348 <procdump+0x18>
801043e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043e7:	90                   	nop
  }
}
801043e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043eb:	5b                   	pop    %ebx
801043ec:	5e                   	pop    %esi
801043ed:	5f                   	pop    %edi
801043ee:	5d                   	pop    %ebp
801043ef:	c3                   	ret    

801043f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	53                   	push   %ebx
801043f4:	83 ec 0c             	sub    $0xc,%esp
801043f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043fa:	68 84 79 10 80       	push   $0x80107984
801043ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104402:	50                   	push   %eax
80104403:	e8 18 01 00 00       	call   80104520 <initlock>
  lk->name = name;
80104408:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010440b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104411:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104414:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010441b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010441e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104421:	c9                   	leave  
80104422:	c3                   	ret    
80104423:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010442a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104430 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	56                   	push   %esi
80104434:	53                   	push   %ebx
80104435:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104438:	8d 73 04             	lea    0x4(%ebx),%esi
8010443b:	83 ec 0c             	sub    $0xc,%esp
8010443e:	56                   	push   %esi
8010443f:	e8 ac 02 00 00       	call   801046f0 <acquire>
  while (lk->locked) {
80104444:	8b 13                	mov    (%ebx),%edx
80104446:	83 c4 10             	add    $0x10,%esp
80104449:	85 d2                	test   %edx,%edx
8010444b:	74 16                	je     80104463 <acquiresleep+0x33>
8010444d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104450:	83 ec 08             	sub    $0x8,%esp
80104453:	56                   	push   %esi
80104454:	53                   	push   %ebx
80104455:	e8 36 fd ff ff       	call   80104190 <sleep>
  while (lk->locked) {
8010445a:	8b 03                	mov    (%ebx),%eax
8010445c:	83 c4 10             	add    $0x10,%esp
8010445f:	85 c0                	test   %eax,%eax
80104461:	75 ed                	jne    80104450 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104463:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104469:	e8 52 f6 ff ff       	call   80103ac0 <myproc>
8010446e:	8b 40 10             	mov    0x10(%eax),%eax
80104471:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104474:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104477:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010447a:	5b                   	pop    %ebx
8010447b:	5e                   	pop    %esi
8010447c:	5d                   	pop    %ebp
  release(&lk->lk);
8010447d:	e9 0e 02 00 00       	jmp    80104690 <release>
80104482:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104490 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	56                   	push   %esi
80104494:	53                   	push   %ebx
80104495:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104498:	8d 73 04             	lea    0x4(%ebx),%esi
8010449b:	83 ec 0c             	sub    $0xc,%esp
8010449e:	56                   	push   %esi
8010449f:	e8 4c 02 00 00       	call   801046f0 <acquire>
  lk->locked = 0;
801044a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801044aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801044b1:	89 1c 24             	mov    %ebx,(%esp)
801044b4:	e8 97 fd ff ff       	call   80104250 <wakeup>
  release(&lk->lk);
801044b9:	89 75 08             	mov    %esi,0x8(%ebp)
801044bc:	83 c4 10             	add    $0x10,%esp
}
801044bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044c2:	5b                   	pop    %ebx
801044c3:	5e                   	pop    %esi
801044c4:	5d                   	pop    %ebp
  release(&lk->lk);
801044c5:	e9 c6 01 00 00       	jmp    80104690 <release>
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	57                   	push   %edi
801044d4:	31 ff                	xor    %edi,%edi
801044d6:	56                   	push   %esi
801044d7:	53                   	push   %ebx
801044d8:	83 ec 18             	sub    $0x18,%esp
801044db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044de:	8d 73 04             	lea    0x4(%ebx),%esi
801044e1:	56                   	push   %esi
801044e2:	e8 09 02 00 00       	call   801046f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044e7:	8b 03                	mov    (%ebx),%eax
801044e9:	83 c4 10             	add    $0x10,%esp
801044ec:	85 c0                	test   %eax,%eax
801044ee:	75 18                	jne    80104508 <holdingsleep+0x38>
  release(&lk->lk);
801044f0:	83 ec 0c             	sub    $0xc,%esp
801044f3:	56                   	push   %esi
801044f4:	e8 97 01 00 00       	call   80104690 <release>
  return r;
}
801044f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044fc:	89 f8                	mov    %edi,%eax
801044fe:	5b                   	pop    %ebx
801044ff:	5e                   	pop    %esi
80104500:	5f                   	pop    %edi
80104501:	5d                   	pop    %ebp
80104502:	c3                   	ret    
80104503:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104507:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104508:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010450b:	e8 b0 f5 ff ff       	call   80103ac0 <myproc>
80104510:	39 58 10             	cmp    %ebx,0x10(%eax)
80104513:	0f 94 c0             	sete   %al
80104516:	0f b6 c0             	movzbl %al,%eax
80104519:	89 c7                	mov    %eax,%edi
8010451b:	eb d3                	jmp    801044f0 <holdingsleep+0x20>
8010451d:	66 90                	xchg   %ax,%ax
8010451f:	90                   	nop

80104520 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104526:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104529:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010452f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104532:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104539:	5d                   	pop    %ebp
8010453a:	c3                   	ret    
8010453b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010453f:	90                   	nop

80104540 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104540:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104541:	31 d2                	xor    %edx,%edx
{
80104543:	89 e5                	mov    %esp,%ebp
80104545:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104546:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104549:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010454c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010454f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104550:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104556:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010455c:	77 1a                	ja     80104578 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010455e:	8b 58 04             	mov    0x4(%eax),%ebx
80104561:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104564:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104567:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104569:	83 fa 0a             	cmp    $0xa,%edx
8010456c:	75 e2                	jne    80104550 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010456e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104571:	c9                   	leave  
80104572:	c3                   	ret    
80104573:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104577:	90                   	nop
  for(; i < 10; i++)
80104578:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010457b:	8d 51 28             	lea    0x28(%ecx),%edx
8010457e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104580:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104586:	83 c0 04             	add    $0x4,%eax
80104589:	39 d0                	cmp    %edx,%eax
8010458b:	75 f3                	jne    80104580 <getcallerpcs+0x40>
}
8010458d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104590:	c9                   	leave  
80104591:	c3                   	ret    
80104592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 04             	sub    $0x4,%esp
801045a7:	9c                   	pushf  
801045a8:	5b                   	pop    %ebx
  asm volatile("cli");
801045a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801045aa:	e8 91 f4 ff ff       	call   80103a40 <mycpu>
801045af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801045b5:	85 c0                	test   %eax,%eax
801045b7:	74 17                	je     801045d0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801045b9:	e8 82 f4 ff ff       	call   80103a40 <mycpu>
801045be:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045c8:	c9                   	leave  
801045c9:	c3                   	ret    
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801045d0:	e8 6b f4 ff ff       	call   80103a40 <mycpu>
801045d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801045e1:	eb d6                	jmp    801045b9 <pushcli+0x19>
801045e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045f0 <popcli>:

void
popcli(void)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045f6:	9c                   	pushf  
801045f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045f8:	f6 c4 02             	test   $0x2,%ah
801045fb:	75 35                	jne    80104632 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045fd:	e8 3e f4 ff ff       	call   80103a40 <mycpu>
80104602:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104609:	78 34                	js     8010463f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010460b:	e8 30 f4 ff ff       	call   80103a40 <mycpu>
80104610:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104616:	85 d2                	test   %edx,%edx
80104618:	74 06                	je     80104620 <popcli+0x30>
    sti();
}
8010461a:	c9                   	leave  
8010461b:	c3                   	ret    
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104620:	e8 1b f4 ff ff       	call   80103a40 <mycpu>
80104625:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010462b:	85 c0                	test   %eax,%eax
8010462d:	74 eb                	je     8010461a <popcli+0x2a>
  asm volatile("sti");
8010462f:	fb                   	sti    
}
80104630:	c9                   	leave  
80104631:	c3                   	ret    
    panic("popcli - interruptible");
80104632:	83 ec 0c             	sub    $0xc,%esp
80104635:	68 8f 79 10 80       	push   $0x8010798f
8010463a:	e8 41 bd ff ff       	call   80100380 <panic>
    panic("popcli");
8010463f:	83 ec 0c             	sub    $0xc,%esp
80104642:	68 a6 79 10 80       	push   $0x801079a6
80104647:	e8 34 bd ff ff       	call   80100380 <panic>
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104650 <holding>:
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
80104655:	8b 75 08             	mov    0x8(%ebp),%esi
80104658:	31 db                	xor    %ebx,%ebx
  pushcli();
8010465a:	e8 41 ff ff ff       	call   801045a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010465f:	8b 06                	mov    (%esi),%eax
80104661:	85 c0                	test   %eax,%eax
80104663:	75 0b                	jne    80104670 <holding+0x20>
  popcli();
80104665:	e8 86 ff ff ff       	call   801045f0 <popcli>
}
8010466a:	89 d8                	mov    %ebx,%eax
8010466c:	5b                   	pop    %ebx
8010466d:	5e                   	pop    %esi
8010466e:	5d                   	pop    %ebp
8010466f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104670:	8b 5e 08             	mov    0x8(%esi),%ebx
80104673:	e8 c8 f3 ff ff       	call   80103a40 <mycpu>
80104678:	39 c3                	cmp    %eax,%ebx
8010467a:	0f 94 c3             	sete   %bl
  popcli();
8010467d:	e8 6e ff ff ff       	call   801045f0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104682:	0f b6 db             	movzbl %bl,%ebx
}
80104685:	89 d8                	mov    %ebx,%eax
80104687:	5b                   	pop    %ebx
80104688:	5e                   	pop    %esi
80104689:	5d                   	pop    %ebp
8010468a:	c3                   	ret    
8010468b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010468f:	90                   	nop

80104690 <release>:
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	53                   	push   %ebx
80104695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104698:	e8 03 ff ff ff       	call   801045a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010469d:	8b 03                	mov    (%ebx),%eax
8010469f:	85 c0                	test   %eax,%eax
801046a1:	75 15                	jne    801046b8 <release+0x28>
  popcli();
801046a3:	e8 48 ff ff ff       	call   801045f0 <popcli>
    panic("release");
801046a8:	83 ec 0c             	sub    $0xc,%esp
801046ab:	68 ad 79 10 80       	push   $0x801079ad
801046b0:	e8 cb bc ff ff       	call   80100380 <panic>
801046b5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801046b8:	8b 73 08             	mov    0x8(%ebx),%esi
801046bb:	e8 80 f3 ff ff       	call   80103a40 <mycpu>
801046c0:	39 c6                	cmp    %eax,%esi
801046c2:	75 df                	jne    801046a3 <release+0x13>
  popcli();
801046c4:	e8 27 ff ff ff       	call   801045f0 <popcli>
  lk->pcs[0] = 0;
801046c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046d0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046d7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801046dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801046e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046e5:	5b                   	pop    %ebx
801046e6:	5e                   	pop    %esi
801046e7:	5d                   	pop    %ebp
  popcli();
801046e8:	e9 03 ff ff ff       	jmp    801045f0 <popcli>
801046ed:	8d 76 00             	lea    0x0(%esi),%esi

801046f0 <acquire>:
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801046f7:	e8 a4 fe ff ff       	call   801045a0 <pushcli>
  if(holding(lk))
801046fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801046ff:	e8 9c fe ff ff       	call   801045a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104704:	8b 03                	mov    (%ebx),%eax
80104706:	85 c0                	test   %eax,%eax
80104708:	75 7e                	jne    80104788 <acquire+0x98>
  popcli();
8010470a:	e8 e1 fe ff ff       	call   801045f0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010470f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104718:	8b 55 08             	mov    0x8(%ebp),%edx
8010471b:	89 c8                	mov    %ecx,%eax
8010471d:	f0 87 02             	lock xchg %eax,(%edx)
80104720:	85 c0                	test   %eax,%eax
80104722:	75 f4                	jne    80104718 <acquire+0x28>
  __sync_synchronize();
80104724:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104729:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010472c:	e8 0f f3 ff ff       	call   80103a40 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104731:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104734:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104736:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104739:	31 c0                	xor    %eax,%eax
8010473b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010473f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104740:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104746:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010474c:	77 1a                	ja     80104768 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010474e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104751:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104755:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104758:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010475a:	83 f8 0a             	cmp    $0xa,%eax
8010475d:	75 e1                	jne    80104740 <acquire+0x50>
}
8010475f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104762:	c9                   	leave  
80104763:	c3                   	ret    
80104764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104768:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010476c:	8d 51 34             	lea    0x34(%ecx),%edx
8010476f:	90                   	nop
    pcs[i] = 0;
80104770:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104776:	83 c0 04             	add    $0x4,%eax
80104779:	39 c2                	cmp    %eax,%edx
8010477b:	75 f3                	jne    80104770 <acquire+0x80>
}
8010477d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104780:	c9                   	leave  
80104781:	c3                   	ret    
80104782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104788:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010478b:	e8 b0 f2 ff ff       	call   80103a40 <mycpu>
80104790:	39 c3                	cmp    %eax,%ebx
80104792:	0f 85 72 ff ff ff    	jne    8010470a <acquire+0x1a>
  popcli();
80104798:	e8 53 fe ff ff       	call   801045f0 <popcli>
    panic("acquire");
8010479d:	83 ec 0c             	sub    $0xc,%esp
801047a0:	68 b5 79 10 80       	push   $0x801079b5
801047a5:	e8 d6 bb ff ff       	call   80100380 <panic>
801047aa:	66 90                	xchg   %ax,%ax
801047ac:	66 90                	xchg   %ax,%ax
801047ae:	66 90                	xchg   %ax,%ax

801047b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	57                   	push   %edi
801047b4:	8b 55 08             	mov    0x8(%ebp),%edx
801047b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047ba:	53                   	push   %ebx
801047bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801047be:	89 d7                	mov    %edx,%edi
801047c0:	09 cf                	or     %ecx,%edi
801047c2:	83 e7 03             	and    $0x3,%edi
801047c5:	75 29                	jne    801047f0 <memset+0x40>
    c &= 0xFF;
801047c7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047ca:	c1 e0 18             	shl    $0x18,%eax
801047cd:	89 fb                	mov    %edi,%ebx
801047cf:	c1 e9 02             	shr    $0x2,%ecx
801047d2:	c1 e3 10             	shl    $0x10,%ebx
801047d5:	09 d8                	or     %ebx,%eax
801047d7:	09 f8                	or     %edi,%eax
801047d9:	c1 e7 08             	shl    $0x8,%edi
801047dc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801047de:	89 d7                	mov    %edx,%edi
801047e0:	fc                   	cld    
801047e1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801047e3:	5b                   	pop    %ebx
801047e4:	89 d0                	mov    %edx,%eax
801047e6:	5f                   	pop    %edi
801047e7:	5d                   	pop    %ebp
801047e8:	c3                   	ret    
801047e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801047f0:	89 d7                	mov    %edx,%edi
801047f2:	fc                   	cld    
801047f3:	f3 aa                	rep stos %al,%es:(%edi)
801047f5:	5b                   	pop    %ebx
801047f6:	89 d0                	mov    %edx,%eax
801047f8:	5f                   	pop    %edi
801047f9:	5d                   	pop    %ebp
801047fa:	c3                   	ret    
801047fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047ff:	90                   	nop

80104800 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	8b 75 10             	mov    0x10(%ebp),%esi
80104807:	8b 55 08             	mov    0x8(%ebp),%edx
8010480a:	53                   	push   %ebx
8010480b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010480e:	85 f6                	test   %esi,%esi
80104810:	74 2e                	je     80104840 <memcmp+0x40>
80104812:	01 c6                	add    %eax,%esi
80104814:	eb 14                	jmp    8010482a <memcmp+0x2a>
80104816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010481d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104820:	83 c0 01             	add    $0x1,%eax
80104823:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104826:	39 f0                	cmp    %esi,%eax
80104828:	74 16                	je     80104840 <memcmp+0x40>
    if(*s1 != *s2)
8010482a:	0f b6 0a             	movzbl (%edx),%ecx
8010482d:	0f b6 18             	movzbl (%eax),%ebx
80104830:	38 d9                	cmp    %bl,%cl
80104832:	74 ec                	je     80104820 <memcmp+0x20>
      return *s1 - *s2;
80104834:	0f b6 c1             	movzbl %cl,%eax
80104837:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104839:	5b                   	pop    %ebx
8010483a:	5e                   	pop    %esi
8010483b:	5d                   	pop    %ebp
8010483c:	c3                   	ret    
8010483d:	8d 76 00             	lea    0x0(%esi),%esi
80104840:	5b                   	pop    %ebx
  return 0;
80104841:	31 c0                	xor    %eax,%eax
}
80104843:	5e                   	pop    %esi
80104844:	5d                   	pop    %ebp
80104845:	c3                   	ret    
80104846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484d:	8d 76 00             	lea    0x0(%esi),%esi

80104850 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	57                   	push   %edi
80104854:	8b 55 08             	mov    0x8(%ebp),%edx
80104857:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010485a:	56                   	push   %esi
8010485b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010485e:	39 d6                	cmp    %edx,%esi
80104860:	73 26                	jae    80104888 <memmove+0x38>
80104862:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104865:	39 fa                	cmp    %edi,%edx
80104867:	73 1f                	jae    80104888 <memmove+0x38>
80104869:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010486c:	85 c9                	test   %ecx,%ecx
8010486e:	74 0c                	je     8010487c <memmove+0x2c>
      *--d = *--s;
80104870:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104874:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104877:	83 e8 01             	sub    $0x1,%eax
8010487a:	73 f4                	jae    80104870 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010487c:	5e                   	pop    %esi
8010487d:	89 d0                	mov    %edx,%eax
8010487f:	5f                   	pop    %edi
80104880:	5d                   	pop    %ebp
80104881:	c3                   	ret    
80104882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104888:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010488b:	89 d7                	mov    %edx,%edi
8010488d:	85 c9                	test   %ecx,%ecx
8010488f:	74 eb                	je     8010487c <memmove+0x2c>
80104891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104898:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104899:	39 c6                	cmp    %eax,%esi
8010489b:	75 fb                	jne    80104898 <memmove+0x48>
}
8010489d:	5e                   	pop    %esi
8010489e:	89 d0                	mov    %edx,%eax
801048a0:	5f                   	pop    %edi
801048a1:	5d                   	pop    %ebp
801048a2:	c3                   	ret    
801048a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801048b0:	eb 9e                	jmp    80104850 <memmove>
801048b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048c0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	56                   	push   %esi
801048c4:	8b 75 10             	mov    0x10(%ebp),%esi
801048c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048ca:	53                   	push   %ebx
801048cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801048ce:	85 f6                	test   %esi,%esi
801048d0:	74 2e                	je     80104900 <strncmp+0x40>
801048d2:	01 d6                	add    %edx,%esi
801048d4:	eb 18                	jmp    801048ee <strncmp+0x2e>
801048d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
801048e0:	38 d8                	cmp    %bl,%al
801048e2:	75 14                	jne    801048f8 <strncmp+0x38>
    n--, p++, q++;
801048e4:	83 c2 01             	add    $0x1,%edx
801048e7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801048ea:	39 f2                	cmp    %esi,%edx
801048ec:	74 12                	je     80104900 <strncmp+0x40>
801048ee:	0f b6 01             	movzbl (%ecx),%eax
801048f1:	0f b6 1a             	movzbl (%edx),%ebx
801048f4:	84 c0                	test   %al,%al
801048f6:	75 e8                	jne    801048e0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801048f8:	29 d8                	sub    %ebx,%eax
}
801048fa:	5b                   	pop    %ebx
801048fb:	5e                   	pop    %esi
801048fc:	5d                   	pop    %ebp
801048fd:	c3                   	ret    
801048fe:	66 90                	xchg   %ax,%ax
80104900:	5b                   	pop    %ebx
    return 0;
80104901:	31 c0                	xor    %eax,%eax
}
80104903:	5e                   	pop    %esi
80104904:	5d                   	pop    %ebp
80104905:	c3                   	ret    
80104906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490d:	8d 76 00             	lea    0x0(%esi),%esi

80104910 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	57                   	push   %edi
80104914:	56                   	push   %esi
80104915:	8b 75 08             	mov    0x8(%ebp),%esi
80104918:	53                   	push   %ebx
80104919:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010491c:	89 f0                	mov    %esi,%eax
8010491e:	eb 15                	jmp    80104935 <strncpy+0x25>
80104920:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104924:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104927:	83 c0 01             	add    $0x1,%eax
8010492a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010492e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104931:	84 d2                	test   %dl,%dl
80104933:	74 09                	je     8010493e <strncpy+0x2e>
80104935:	89 cb                	mov    %ecx,%ebx
80104937:	83 e9 01             	sub    $0x1,%ecx
8010493a:	85 db                	test   %ebx,%ebx
8010493c:	7f e2                	jg     80104920 <strncpy+0x10>
    ;
  while(n-- > 0)
8010493e:	89 c2                	mov    %eax,%edx
80104940:	85 c9                	test   %ecx,%ecx
80104942:	7e 17                	jle    8010495b <strncpy+0x4b>
80104944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104948:	83 c2 01             	add    $0x1,%edx
8010494b:	89 c1                	mov    %eax,%ecx
8010494d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104951:	29 d1                	sub    %edx,%ecx
80104953:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104957:	85 c9                	test   %ecx,%ecx
80104959:	7f ed                	jg     80104948 <strncpy+0x38>
  return os;
}
8010495b:	5b                   	pop    %ebx
8010495c:	89 f0                	mov    %esi,%eax
8010495e:	5e                   	pop    %esi
8010495f:	5f                   	pop    %edi
80104960:	5d                   	pop    %ebp
80104961:	c3                   	ret    
80104962:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104970 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	56                   	push   %esi
80104974:	8b 55 10             	mov    0x10(%ebp),%edx
80104977:	8b 75 08             	mov    0x8(%ebp),%esi
8010497a:	53                   	push   %ebx
8010497b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010497e:	85 d2                	test   %edx,%edx
80104980:	7e 25                	jle    801049a7 <safestrcpy+0x37>
80104982:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104986:	89 f2                	mov    %esi,%edx
80104988:	eb 16                	jmp    801049a0 <safestrcpy+0x30>
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104990:	0f b6 08             	movzbl (%eax),%ecx
80104993:	83 c0 01             	add    $0x1,%eax
80104996:	83 c2 01             	add    $0x1,%edx
80104999:	88 4a ff             	mov    %cl,-0x1(%edx)
8010499c:	84 c9                	test   %cl,%cl
8010499e:	74 04                	je     801049a4 <safestrcpy+0x34>
801049a0:	39 d8                	cmp    %ebx,%eax
801049a2:	75 ec                	jne    80104990 <safestrcpy+0x20>
    ;
  *s = 0;
801049a4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801049a7:	89 f0                	mov    %esi,%eax
801049a9:	5b                   	pop    %ebx
801049aa:	5e                   	pop    %esi
801049ab:	5d                   	pop    %ebp
801049ac:	c3                   	ret    
801049ad:	8d 76 00             	lea    0x0(%esi),%esi

801049b0 <strlen>:

int
strlen(const char *s)
{
801049b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801049b1:	31 c0                	xor    %eax,%eax
{
801049b3:	89 e5                	mov    %esp,%ebp
801049b5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801049b8:	80 3a 00             	cmpb   $0x0,(%edx)
801049bb:	74 0c                	je     801049c9 <strlen+0x19>
801049bd:	8d 76 00             	lea    0x0(%esi),%esi
801049c0:	83 c0 01             	add    $0x1,%eax
801049c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049c7:	75 f7                	jne    801049c0 <strlen+0x10>
    ;
  return n;
}
801049c9:	5d                   	pop    %ebp
801049ca:	c3                   	ret    

801049cb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801049cb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801049cf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801049d3:	55                   	push   %ebp
  pushl %ebx
801049d4:	53                   	push   %ebx
  pushl %esi
801049d5:	56                   	push   %esi
  pushl %edi
801049d6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801049d7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801049d9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801049db:	5f                   	pop    %edi
  popl %esi
801049dc:	5e                   	pop    %esi
  popl %ebx
801049dd:	5b                   	pop    %ebx
  popl %ebp
801049de:	5d                   	pop    %ebp
  ret
801049df:	c3                   	ret    

801049e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	53                   	push   %ebx
801049e4:	83 ec 04             	sub    $0x4,%esp
801049e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801049ea:	e8 d1 f0 ff ff       	call   80103ac0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049ef:	8b 00                	mov    (%eax),%eax
801049f1:	39 d8                	cmp    %ebx,%eax
801049f3:	76 1b                	jbe    80104a10 <fetchint+0x30>
801049f5:	8d 53 04             	lea    0x4(%ebx),%edx
801049f8:	39 d0                	cmp    %edx,%eax
801049fa:	72 14                	jb     80104a10 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801049fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ff:	8b 13                	mov    (%ebx),%edx
80104a01:	89 10                	mov    %edx,(%eax)
  return 0;
80104a03:	31 c0                	xor    %eax,%eax
}
80104a05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a08:	c9                   	leave  
80104a09:	c3                   	ret    
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a15:	eb ee                	jmp    80104a05 <fetchint+0x25>
80104a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1e:	66 90                	xchg   %ax,%ax

80104a20 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	53                   	push   %ebx
80104a24:	83 ec 04             	sub    $0x4,%esp
80104a27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a2a:	e8 91 f0 ff ff       	call   80103ac0 <myproc>

  if(addr >= curproc->sz)
80104a2f:	39 18                	cmp    %ebx,(%eax)
80104a31:	76 2d                	jbe    80104a60 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104a33:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a36:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a38:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a3a:	39 d3                	cmp    %edx,%ebx
80104a3c:	73 22                	jae    80104a60 <fetchstr+0x40>
80104a3e:	89 d8                	mov    %ebx,%eax
80104a40:	eb 0d                	jmp    80104a4f <fetchstr+0x2f>
80104a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a48:	83 c0 01             	add    $0x1,%eax
80104a4b:	39 c2                	cmp    %eax,%edx
80104a4d:	76 11                	jbe    80104a60 <fetchstr+0x40>
    if(*s == 0)
80104a4f:	80 38 00             	cmpb   $0x0,(%eax)
80104a52:	75 f4                	jne    80104a48 <fetchstr+0x28>
      return s - *pp;
80104a54:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104a56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a59:	c9                   	leave  
80104a5a:	c3                   	ret    
80104a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a5f:	90                   	nop
80104a60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104a63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a68:	c9                   	leave  
80104a69:	c3                   	ret    
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a75:	e8 46 f0 ff ff       	call   80103ac0 <myproc>
80104a7a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a7d:	8b 40 18             	mov    0x18(%eax),%eax
80104a80:	8b 40 44             	mov    0x44(%eax),%eax
80104a83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a86:	e8 35 f0 ff ff       	call   80103ac0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a8b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a8e:	8b 00                	mov    (%eax),%eax
80104a90:	39 c6                	cmp    %eax,%esi
80104a92:	73 1c                	jae    80104ab0 <argint+0x40>
80104a94:	8d 53 08             	lea    0x8(%ebx),%edx
80104a97:	39 d0                	cmp    %edx,%eax
80104a99:	72 15                	jb     80104ab0 <argint+0x40>
  *ip = *(int*)(addr);
80104a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104aa1:	89 10                	mov    %edx,(%eax)
  return 0;
80104aa3:	31 c0                	xor    %eax,%eax
}
80104aa5:	5b                   	pop    %ebx
80104aa6:	5e                   	pop    %esi
80104aa7:	5d                   	pop    %ebp
80104aa8:	c3                   	ret    
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ab5:	eb ee                	jmp    80104aa5 <argint+0x35>
80104ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abe:	66 90                	xchg   %ax,%ax

80104ac0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	53                   	push   %ebx
80104ac6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104ac9:	e8 f2 ef ff ff       	call   80103ac0 <myproc>
80104ace:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ad0:	e8 eb ef ff ff       	call   80103ac0 <myproc>
80104ad5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ad8:	8b 40 18             	mov    0x18(%eax),%eax
80104adb:	8b 40 44             	mov    0x44(%eax),%eax
80104ade:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ae1:	e8 da ef ff ff       	call   80103ac0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ae6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ae9:	8b 00                	mov    (%eax),%eax
80104aeb:	39 c7                	cmp    %eax,%edi
80104aed:	73 31                	jae    80104b20 <argptr+0x60>
80104aef:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104af2:	39 c8                	cmp    %ecx,%eax
80104af4:	72 2a                	jb     80104b20 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104af6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104af9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104afc:	85 d2                	test   %edx,%edx
80104afe:	78 20                	js     80104b20 <argptr+0x60>
80104b00:	8b 16                	mov    (%esi),%edx
80104b02:	39 c2                	cmp    %eax,%edx
80104b04:	76 1a                	jbe    80104b20 <argptr+0x60>
80104b06:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b09:	01 c3                	add    %eax,%ebx
80104b0b:	39 da                	cmp    %ebx,%edx
80104b0d:	72 11                	jb     80104b20 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b12:	89 02                	mov    %eax,(%edx)
  return 0;
80104b14:	31 c0                	xor    %eax,%eax
}
80104b16:	83 c4 0c             	add    $0xc,%esp
80104b19:	5b                   	pop    %ebx
80104b1a:	5e                   	pop    %esi
80104b1b:	5f                   	pop    %edi
80104b1c:	5d                   	pop    %ebp
80104b1d:	c3                   	ret    
80104b1e:	66 90                	xchg   %ax,%ax
    return -1;
80104b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b25:	eb ef                	jmp    80104b16 <argptr+0x56>
80104b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b2e:	66 90                	xchg   %ax,%ax

80104b30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	56                   	push   %esi
80104b34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b35:	e8 86 ef ff ff       	call   80103ac0 <myproc>
80104b3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b3d:	8b 40 18             	mov    0x18(%eax),%eax
80104b40:	8b 40 44             	mov    0x44(%eax),%eax
80104b43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b46:	e8 75 ef ff ff       	call   80103ac0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b4b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b4e:	8b 00                	mov    (%eax),%eax
80104b50:	39 c6                	cmp    %eax,%esi
80104b52:	73 44                	jae    80104b98 <argstr+0x68>
80104b54:	8d 53 08             	lea    0x8(%ebx),%edx
80104b57:	39 d0                	cmp    %edx,%eax
80104b59:	72 3d                	jb     80104b98 <argstr+0x68>
  *ip = *(int*)(addr);
80104b5b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104b5e:	e8 5d ef ff ff       	call   80103ac0 <myproc>
  if(addr >= curproc->sz)
80104b63:	3b 18                	cmp    (%eax),%ebx
80104b65:	73 31                	jae    80104b98 <argstr+0x68>
  *pp = (char*)addr;
80104b67:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b6a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b6c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b6e:	39 d3                	cmp    %edx,%ebx
80104b70:	73 26                	jae    80104b98 <argstr+0x68>
80104b72:	89 d8                	mov    %ebx,%eax
80104b74:	eb 11                	jmp    80104b87 <argstr+0x57>
80104b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7d:	8d 76 00             	lea    0x0(%esi),%esi
80104b80:	83 c0 01             	add    $0x1,%eax
80104b83:	39 c2                	cmp    %eax,%edx
80104b85:	76 11                	jbe    80104b98 <argstr+0x68>
    if(*s == 0)
80104b87:	80 38 00             	cmpb   $0x0,(%eax)
80104b8a:	75 f4                	jne    80104b80 <argstr+0x50>
      return s - *pp;
80104b8c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104b8e:	5b                   	pop    %ebx
80104b8f:	5e                   	pop    %esi
80104b90:	5d                   	pop    %ebp
80104b91:	c3                   	ret    
80104b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b98:	5b                   	pop    %ebx
    return -1;
80104b99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b9e:	5e                   	pop    %esi
80104b9f:	5d                   	pop    %ebp
80104ba0:	c3                   	ret    
80104ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104baf:	90                   	nop

80104bb0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	53                   	push   %ebx
80104bb4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104bb7:	e8 04 ef ff ff       	call   80103ac0 <myproc>
80104bbc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104bbe:	8b 40 18             	mov    0x18(%eax),%eax
80104bc1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104bc4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104bc7:	83 fa 14             	cmp    $0x14,%edx
80104bca:	77 24                	ja     80104bf0 <syscall+0x40>
80104bcc:	8b 14 85 e0 79 10 80 	mov    -0x7fef8620(,%eax,4),%edx
80104bd3:	85 d2                	test   %edx,%edx
80104bd5:	74 19                	je     80104bf0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104bd7:	ff d2                	call   *%edx
80104bd9:	89 c2                	mov    %eax,%edx
80104bdb:	8b 43 18             	mov    0x18(%ebx),%eax
80104bde:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104be1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104be4:	c9                   	leave  
80104be5:	c3                   	ret    
80104be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bed:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104bf0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104bf1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104bf4:	50                   	push   %eax
80104bf5:	ff 73 10             	push   0x10(%ebx)
80104bf8:	68 bd 79 10 80       	push   $0x801079bd
80104bfd:	e8 9e ba ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104c02:	8b 43 18             	mov    0x18(%ebx),%eax
80104c05:	83 c4 10             	add    $0x10,%esp
80104c08:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c12:	c9                   	leave  
80104c13:	c3                   	ret    
80104c14:	66 90                	xchg   %ax,%ax
80104c16:	66 90                	xchg   %ax,%ax
80104c18:	66 90                	xchg   %ax,%ax
80104c1a:	66 90                	xchg   %ax,%ax
80104c1c:	66 90                	xchg   %ax,%ax
80104c1e:	66 90                	xchg   %ax,%ax

80104c20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	57                   	push   %edi
80104c24:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c25:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104c28:	53                   	push   %ebx
80104c29:	83 ec 34             	sub    $0x34,%esp
80104c2c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104c32:	57                   	push   %edi
80104c33:	50                   	push   %eax
{
80104c34:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c37:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c3a:	e8 d1 d5 ff ff       	call   80102210 <nameiparent>
80104c3f:	83 c4 10             	add    $0x10,%esp
80104c42:	85 c0                	test   %eax,%eax
80104c44:	0f 84 46 01 00 00    	je     80104d90 <create+0x170>
    return 0;
  ilock(dp);
80104c4a:	83 ec 0c             	sub    $0xc,%esp
80104c4d:	89 c3                	mov    %eax,%ebx
80104c4f:	50                   	push   %eax
80104c50:	e8 7b cc ff ff       	call   801018d0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104c55:	83 c4 0c             	add    $0xc,%esp
80104c58:	6a 00                	push   $0x0
80104c5a:	57                   	push   %edi
80104c5b:	53                   	push   %ebx
80104c5c:	e8 cf d1 ff ff       	call   80101e30 <dirlookup>
80104c61:	83 c4 10             	add    $0x10,%esp
80104c64:	89 c6                	mov    %eax,%esi
80104c66:	85 c0                	test   %eax,%eax
80104c68:	74 56                	je     80104cc0 <create+0xa0>
    iunlockput(dp);
80104c6a:	83 ec 0c             	sub    $0xc,%esp
80104c6d:	53                   	push   %ebx
80104c6e:	e8 ed ce ff ff       	call   80101b60 <iunlockput>
    ilock(ip);
80104c73:	89 34 24             	mov    %esi,(%esp)
80104c76:	e8 55 cc ff ff       	call   801018d0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c7b:	83 c4 10             	add    $0x10,%esp
80104c7e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104c83:	75 1b                	jne    80104ca0 <create+0x80>
80104c85:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104c8a:	75 14                	jne    80104ca0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c8f:	89 f0                	mov    %esi,%eax
80104c91:	5b                   	pop    %ebx
80104c92:	5e                   	pop    %esi
80104c93:	5f                   	pop    %edi
80104c94:	5d                   	pop    %ebp
80104c95:	c3                   	ret    
80104c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104ca0:	83 ec 0c             	sub    $0xc,%esp
80104ca3:	56                   	push   %esi
    return 0;
80104ca4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104ca6:	e8 b5 ce ff ff       	call   80101b60 <iunlockput>
    return 0;
80104cab:	83 c4 10             	add    $0x10,%esp
}
80104cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cb1:	89 f0                	mov    %esi,%eax
80104cb3:	5b                   	pop    %ebx
80104cb4:	5e                   	pop    %esi
80104cb5:	5f                   	pop    %edi
80104cb6:	5d                   	pop    %ebp
80104cb7:	c3                   	ret    
80104cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104cc0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104cc4:	83 ec 08             	sub    $0x8,%esp
80104cc7:	50                   	push   %eax
80104cc8:	ff 33                	push   (%ebx)
80104cca:	e8 91 ca ff ff       	call   80101760 <ialloc>
80104ccf:	83 c4 10             	add    $0x10,%esp
80104cd2:	89 c6                	mov    %eax,%esi
80104cd4:	85 c0                	test   %eax,%eax
80104cd6:	0f 84 cd 00 00 00    	je     80104da9 <create+0x189>
  ilock(ip);
80104cdc:	83 ec 0c             	sub    $0xc,%esp
80104cdf:	50                   	push   %eax
80104ce0:	e8 eb cb ff ff       	call   801018d0 <ilock>
  ip->major = major;
80104ce5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104ce9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104ced:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104cf1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104cf5:	b8 01 00 00 00       	mov    $0x1,%eax
80104cfa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104cfe:	89 34 24             	mov    %esi,(%esp)
80104d01:	e8 1a cb ff ff       	call   80101820 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d06:	83 c4 10             	add    $0x10,%esp
80104d09:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d0e:	74 30                	je     80104d40 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104d10:	83 ec 04             	sub    $0x4,%esp
80104d13:	ff 76 04             	push   0x4(%esi)
80104d16:	57                   	push   %edi
80104d17:	53                   	push   %ebx
80104d18:	e8 13 d4 ff ff       	call   80102130 <dirlink>
80104d1d:	83 c4 10             	add    $0x10,%esp
80104d20:	85 c0                	test   %eax,%eax
80104d22:	78 78                	js     80104d9c <create+0x17c>
  iunlockput(dp);
80104d24:	83 ec 0c             	sub    $0xc,%esp
80104d27:	53                   	push   %ebx
80104d28:	e8 33 ce ff ff       	call   80101b60 <iunlockput>
  return ip;
80104d2d:	83 c4 10             	add    $0x10,%esp
}
80104d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d33:	89 f0                	mov    %esi,%eax
80104d35:	5b                   	pop    %ebx
80104d36:	5e                   	pop    %esi
80104d37:	5f                   	pop    %edi
80104d38:	5d                   	pop    %ebp
80104d39:	c3                   	ret    
80104d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104d40:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104d43:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104d48:	53                   	push   %ebx
80104d49:	e8 d2 ca ff ff       	call   80101820 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d4e:	83 c4 0c             	add    $0xc,%esp
80104d51:	ff 76 04             	push   0x4(%esi)
80104d54:	68 54 7a 10 80       	push   $0x80107a54
80104d59:	56                   	push   %esi
80104d5a:	e8 d1 d3 ff ff       	call   80102130 <dirlink>
80104d5f:	83 c4 10             	add    $0x10,%esp
80104d62:	85 c0                	test   %eax,%eax
80104d64:	78 18                	js     80104d7e <create+0x15e>
80104d66:	83 ec 04             	sub    $0x4,%esp
80104d69:	ff 73 04             	push   0x4(%ebx)
80104d6c:	68 53 7a 10 80       	push   $0x80107a53
80104d71:	56                   	push   %esi
80104d72:	e8 b9 d3 ff ff       	call   80102130 <dirlink>
80104d77:	83 c4 10             	add    $0x10,%esp
80104d7a:	85 c0                	test   %eax,%eax
80104d7c:	79 92                	jns    80104d10 <create+0xf0>
      panic("create dots");
80104d7e:	83 ec 0c             	sub    $0xc,%esp
80104d81:	68 47 7a 10 80       	push   $0x80107a47
80104d86:	e8 f5 b5 ff ff       	call   80100380 <panic>
80104d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d8f:	90                   	nop
}
80104d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d93:	31 f6                	xor    %esi,%esi
}
80104d95:	5b                   	pop    %ebx
80104d96:	89 f0                	mov    %esi,%eax
80104d98:	5e                   	pop    %esi
80104d99:	5f                   	pop    %edi
80104d9a:	5d                   	pop    %ebp
80104d9b:	c3                   	ret    
    panic("create: dirlink");
80104d9c:	83 ec 0c             	sub    $0xc,%esp
80104d9f:	68 56 7a 10 80       	push   $0x80107a56
80104da4:	e8 d7 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104da9:	83 ec 0c             	sub    $0xc,%esp
80104dac:	68 38 7a 10 80       	push   $0x80107a38
80104db1:	e8 ca b5 ff ff       	call   80100380 <panic>
80104db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dbd:	8d 76 00             	lea    0x0(%esi),%esi

80104dc0 <sys_dup>:
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	56                   	push   %esi
80104dc4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104dc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104dc8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104dcb:	50                   	push   %eax
80104dcc:	6a 00                	push   $0x0
80104dce:	e8 9d fc ff ff       	call   80104a70 <argint>
80104dd3:	83 c4 10             	add    $0x10,%esp
80104dd6:	85 c0                	test   %eax,%eax
80104dd8:	78 36                	js     80104e10 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dde:	77 30                	ja     80104e10 <sys_dup+0x50>
80104de0:	e8 db ec ff ff       	call   80103ac0 <myproc>
80104de5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104de8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104dec:	85 f6                	test   %esi,%esi
80104dee:	74 20                	je     80104e10 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104df0:	e8 cb ec ff ff       	call   80103ac0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104df5:	31 db                	xor    %ebx,%ebx
80104df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dfe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104e00:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e04:	85 d2                	test   %edx,%edx
80104e06:	74 18                	je     80104e20 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104e08:	83 c3 01             	add    $0x1,%ebx
80104e0b:	83 fb 10             	cmp    $0x10,%ebx
80104e0e:	75 f0                	jne    80104e00 <sys_dup+0x40>
}
80104e10:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e13:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e18:	89 d8                	mov    %ebx,%eax
80104e1a:	5b                   	pop    %ebx
80104e1b:	5e                   	pop    %esi
80104e1c:	5d                   	pop    %ebp
80104e1d:	c3                   	ret    
80104e1e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104e20:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104e23:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e27:	56                   	push   %esi
80104e28:	e8 c3 c1 ff ff       	call   80100ff0 <filedup>
  return fd;
80104e2d:	83 c4 10             	add    $0x10,%esp
}
80104e30:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e33:	89 d8                	mov    %ebx,%eax
80104e35:	5b                   	pop    %ebx
80104e36:	5e                   	pop    %esi
80104e37:	5d                   	pop    %ebp
80104e38:	c3                   	ret    
80104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e40 <sys_read>:
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e45:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e4b:	53                   	push   %ebx
80104e4c:	6a 00                	push   $0x0
80104e4e:	e8 1d fc ff ff       	call   80104a70 <argint>
80104e53:	83 c4 10             	add    $0x10,%esp
80104e56:	85 c0                	test   %eax,%eax
80104e58:	78 5e                	js     80104eb8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e5e:	77 58                	ja     80104eb8 <sys_read+0x78>
80104e60:	e8 5b ec ff ff       	call   80103ac0 <myproc>
80104e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e68:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e6c:	85 f6                	test   %esi,%esi
80104e6e:	74 48                	je     80104eb8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e70:	83 ec 08             	sub    $0x8,%esp
80104e73:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e76:	50                   	push   %eax
80104e77:	6a 02                	push   $0x2
80104e79:	e8 f2 fb ff ff       	call   80104a70 <argint>
80104e7e:	83 c4 10             	add    $0x10,%esp
80104e81:	85 c0                	test   %eax,%eax
80104e83:	78 33                	js     80104eb8 <sys_read+0x78>
80104e85:	83 ec 04             	sub    $0x4,%esp
80104e88:	ff 75 f0             	push   -0x10(%ebp)
80104e8b:	53                   	push   %ebx
80104e8c:	6a 01                	push   $0x1
80104e8e:	e8 2d fc ff ff       	call   80104ac0 <argptr>
80104e93:	83 c4 10             	add    $0x10,%esp
80104e96:	85 c0                	test   %eax,%eax
80104e98:	78 1e                	js     80104eb8 <sys_read+0x78>
  return fileread(f, p, n);
80104e9a:	83 ec 04             	sub    $0x4,%esp
80104e9d:	ff 75 f0             	push   -0x10(%ebp)
80104ea0:	ff 75 f4             	push   -0xc(%ebp)
80104ea3:	56                   	push   %esi
80104ea4:	e8 c7 c2 ff ff       	call   80101170 <fileread>
80104ea9:	83 c4 10             	add    $0x10,%esp
}
80104eac:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eaf:	5b                   	pop    %ebx
80104eb0:	5e                   	pop    %esi
80104eb1:	5d                   	pop    %ebp
80104eb2:	c3                   	ret    
80104eb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eb7:	90                   	nop
    return -1;
80104eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ebd:	eb ed                	jmp    80104eac <sys_read+0x6c>
80104ebf:	90                   	nop

80104ec0 <sys_write>:
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	56                   	push   %esi
80104ec4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ec5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ec8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ecb:	53                   	push   %ebx
80104ecc:	6a 00                	push   $0x0
80104ece:	e8 9d fb ff ff       	call   80104a70 <argint>
80104ed3:	83 c4 10             	add    $0x10,%esp
80104ed6:	85 c0                	test   %eax,%eax
80104ed8:	78 5e                	js     80104f38 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ede:	77 58                	ja     80104f38 <sys_write+0x78>
80104ee0:	e8 db eb ff ff       	call   80103ac0 <myproc>
80104ee5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ee8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104eec:	85 f6                	test   %esi,%esi
80104eee:	74 48                	je     80104f38 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ef0:	83 ec 08             	sub    $0x8,%esp
80104ef3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ef6:	50                   	push   %eax
80104ef7:	6a 02                	push   $0x2
80104ef9:	e8 72 fb ff ff       	call   80104a70 <argint>
80104efe:	83 c4 10             	add    $0x10,%esp
80104f01:	85 c0                	test   %eax,%eax
80104f03:	78 33                	js     80104f38 <sys_write+0x78>
80104f05:	83 ec 04             	sub    $0x4,%esp
80104f08:	ff 75 f0             	push   -0x10(%ebp)
80104f0b:	53                   	push   %ebx
80104f0c:	6a 01                	push   $0x1
80104f0e:	e8 ad fb ff ff       	call   80104ac0 <argptr>
80104f13:	83 c4 10             	add    $0x10,%esp
80104f16:	85 c0                	test   %eax,%eax
80104f18:	78 1e                	js     80104f38 <sys_write+0x78>
  return filewrite(f, p, n);
80104f1a:	83 ec 04             	sub    $0x4,%esp
80104f1d:	ff 75 f0             	push   -0x10(%ebp)
80104f20:	ff 75 f4             	push   -0xc(%ebp)
80104f23:	56                   	push   %esi
80104f24:	e8 d7 c2 ff ff       	call   80101200 <filewrite>
80104f29:	83 c4 10             	add    $0x10,%esp
}
80104f2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f2f:	5b                   	pop    %ebx
80104f30:	5e                   	pop    %esi
80104f31:	5d                   	pop    %ebp
80104f32:	c3                   	ret    
80104f33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f37:	90                   	nop
    return -1;
80104f38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f3d:	eb ed                	jmp    80104f2c <sys_write+0x6c>
80104f3f:	90                   	nop

80104f40 <sys_close>:
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f45:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f4b:	50                   	push   %eax
80104f4c:	6a 00                	push   $0x0
80104f4e:	e8 1d fb ff ff       	call   80104a70 <argint>
80104f53:	83 c4 10             	add    $0x10,%esp
80104f56:	85 c0                	test   %eax,%eax
80104f58:	78 3e                	js     80104f98 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f5e:	77 38                	ja     80104f98 <sys_close+0x58>
80104f60:	e8 5b eb ff ff       	call   80103ac0 <myproc>
80104f65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f68:	8d 5a 08             	lea    0x8(%edx),%ebx
80104f6b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104f6f:	85 f6                	test   %esi,%esi
80104f71:	74 25                	je     80104f98 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104f73:	e8 48 eb ff ff       	call   80103ac0 <myproc>
  fileclose(f);
80104f78:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f7b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104f82:	00 
  fileclose(f);
80104f83:	56                   	push   %esi
80104f84:	e8 b7 c0 ff ff       	call   80101040 <fileclose>
  return 0;
80104f89:	83 c4 10             	add    $0x10,%esp
80104f8c:	31 c0                	xor    %eax,%eax
}
80104f8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f91:	5b                   	pop    %ebx
80104f92:	5e                   	pop    %esi
80104f93:	5d                   	pop    %ebp
80104f94:	c3                   	ret    
80104f95:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f9d:	eb ef                	jmp    80104f8e <sys_close+0x4e>
80104f9f:	90                   	nop

80104fa0 <sys_fstat>:
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fa5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fa8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fab:	53                   	push   %ebx
80104fac:	6a 00                	push   $0x0
80104fae:	e8 bd fa ff ff       	call   80104a70 <argint>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 46                	js     80105000 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fbe:	77 40                	ja     80105000 <sys_fstat+0x60>
80104fc0:	e8 fb ea ff ff       	call   80103ac0 <myproc>
80104fc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fc8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fcc:	85 f6                	test   %esi,%esi
80104fce:	74 30                	je     80105000 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104fd0:	83 ec 04             	sub    $0x4,%esp
80104fd3:	6a 14                	push   $0x14
80104fd5:	53                   	push   %ebx
80104fd6:	6a 01                	push   $0x1
80104fd8:	e8 e3 fa ff ff       	call   80104ac0 <argptr>
80104fdd:	83 c4 10             	add    $0x10,%esp
80104fe0:	85 c0                	test   %eax,%eax
80104fe2:	78 1c                	js     80105000 <sys_fstat+0x60>
  return filestat(f, st);
80104fe4:	83 ec 08             	sub    $0x8,%esp
80104fe7:	ff 75 f4             	push   -0xc(%ebp)
80104fea:	56                   	push   %esi
80104feb:	e8 30 c1 ff ff       	call   80101120 <filestat>
80104ff0:	83 c4 10             	add    $0x10,%esp
}
80104ff3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ff6:	5b                   	pop    %ebx
80104ff7:	5e                   	pop    %esi
80104ff8:	5d                   	pop    %ebp
80104ff9:	c3                   	ret    
80104ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105005:	eb ec                	jmp    80104ff3 <sys_fstat+0x53>
80105007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010500e:	66 90                	xchg   %ax,%ax

80105010 <sys_link>:
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	57                   	push   %edi
80105014:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105015:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105018:	53                   	push   %ebx
80105019:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010501c:	50                   	push   %eax
8010501d:	6a 00                	push   $0x0
8010501f:	e8 0c fb ff ff       	call   80104b30 <argstr>
80105024:	83 c4 10             	add    $0x10,%esp
80105027:	85 c0                	test   %eax,%eax
80105029:	0f 88 fb 00 00 00    	js     8010512a <sys_link+0x11a>
8010502f:	83 ec 08             	sub    $0x8,%esp
80105032:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105035:	50                   	push   %eax
80105036:	6a 01                	push   $0x1
80105038:	e8 f3 fa ff ff       	call   80104b30 <argstr>
8010503d:	83 c4 10             	add    $0x10,%esp
80105040:	85 c0                	test   %eax,%eax
80105042:	0f 88 e2 00 00 00    	js     8010512a <sys_link+0x11a>
  begin_op();
80105048:	e8 63 de ff ff       	call   80102eb0 <begin_op>
  if((ip = namei(old)) == 0){
8010504d:	83 ec 0c             	sub    $0xc,%esp
80105050:	ff 75 d4             	push   -0x2c(%ebp)
80105053:	e8 98 d1 ff ff       	call   801021f0 <namei>
80105058:	83 c4 10             	add    $0x10,%esp
8010505b:	89 c3                	mov    %eax,%ebx
8010505d:	85 c0                	test   %eax,%eax
8010505f:	0f 84 e4 00 00 00    	je     80105149 <sys_link+0x139>
  ilock(ip);
80105065:	83 ec 0c             	sub    $0xc,%esp
80105068:	50                   	push   %eax
80105069:	e8 62 c8 ff ff       	call   801018d0 <ilock>
  if(ip->type == T_DIR){
8010506e:	83 c4 10             	add    $0x10,%esp
80105071:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105076:	0f 84 b5 00 00 00    	je     80105131 <sys_link+0x121>
  iupdate(ip);
8010507c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010507f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105084:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105087:	53                   	push   %ebx
80105088:	e8 93 c7 ff ff       	call   80101820 <iupdate>
  iunlock(ip);
8010508d:	89 1c 24             	mov    %ebx,(%esp)
80105090:	e8 1b c9 ff ff       	call   801019b0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105095:	58                   	pop    %eax
80105096:	5a                   	pop    %edx
80105097:	57                   	push   %edi
80105098:	ff 75 d0             	push   -0x30(%ebp)
8010509b:	e8 70 d1 ff ff       	call   80102210 <nameiparent>
801050a0:	83 c4 10             	add    $0x10,%esp
801050a3:	89 c6                	mov    %eax,%esi
801050a5:	85 c0                	test   %eax,%eax
801050a7:	74 5b                	je     80105104 <sys_link+0xf4>
  ilock(dp);
801050a9:	83 ec 0c             	sub    $0xc,%esp
801050ac:	50                   	push   %eax
801050ad:	e8 1e c8 ff ff       	call   801018d0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801050b2:	8b 03                	mov    (%ebx),%eax
801050b4:	83 c4 10             	add    $0x10,%esp
801050b7:	39 06                	cmp    %eax,(%esi)
801050b9:	75 3d                	jne    801050f8 <sys_link+0xe8>
801050bb:	83 ec 04             	sub    $0x4,%esp
801050be:	ff 73 04             	push   0x4(%ebx)
801050c1:	57                   	push   %edi
801050c2:	56                   	push   %esi
801050c3:	e8 68 d0 ff ff       	call   80102130 <dirlink>
801050c8:	83 c4 10             	add    $0x10,%esp
801050cb:	85 c0                	test   %eax,%eax
801050cd:	78 29                	js     801050f8 <sys_link+0xe8>
  iunlockput(dp);
801050cf:	83 ec 0c             	sub    $0xc,%esp
801050d2:	56                   	push   %esi
801050d3:	e8 88 ca ff ff       	call   80101b60 <iunlockput>
  iput(ip);
801050d8:	89 1c 24             	mov    %ebx,(%esp)
801050db:	e8 20 c9 ff ff       	call   80101a00 <iput>
  end_op();
801050e0:	e8 3b de ff ff       	call   80102f20 <end_op>
  return 0;
801050e5:	83 c4 10             	add    $0x10,%esp
801050e8:	31 c0                	xor    %eax,%eax
}
801050ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050ed:	5b                   	pop    %ebx
801050ee:	5e                   	pop    %esi
801050ef:	5f                   	pop    %edi
801050f0:	5d                   	pop    %ebp
801050f1:	c3                   	ret    
801050f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801050f8:	83 ec 0c             	sub    $0xc,%esp
801050fb:	56                   	push   %esi
801050fc:	e8 5f ca ff ff       	call   80101b60 <iunlockput>
    goto bad;
80105101:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105104:	83 ec 0c             	sub    $0xc,%esp
80105107:	53                   	push   %ebx
80105108:	e8 c3 c7 ff ff       	call   801018d0 <ilock>
  ip->nlink--;
8010510d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105112:	89 1c 24             	mov    %ebx,(%esp)
80105115:	e8 06 c7 ff ff       	call   80101820 <iupdate>
  iunlockput(ip);
8010511a:	89 1c 24             	mov    %ebx,(%esp)
8010511d:	e8 3e ca ff ff       	call   80101b60 <iunlockput>
  end_op();
80105122:	e8 f9 dd ff ff       	call   80102f20 <end_op>
  return -1;
80105127:	83 c4 10             	add    $0x10,%esp
8010512a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010512f:	eb b9                	jmp    801050ea <sys_link+0xda>
    iunlockput(ip);
80105131:	83 ec 0c             	sub    $0xc,%esp
80105134:	53                   	push   %ebx
80105135:	e8 26 ca ff ff       	call   80101b60 <iunlockput>
    end_op();
8010513a:	e8 e1 dd ff ff       	call   80102f20 <end_op>
    return -1;
8010513f:	83 c4 10             	add    $0x10,%esp
80105142:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105147:	eb a1                	jmp    801050ea <sys_link+0xda>
    end_op();
80105149:	e8 d2 dd ff ff       	call   80102f20 <end_op>
    return -1;
8010514e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105153:	eb 95                	jmp    801050ea <sys_link+0xda>
80105155:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105160 <sys_unlink>:
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	57                   	push   %edi
80105164:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105165:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105168:	53                   	push   %ebx
80105169:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010516c:	50                   	push   %eax
8010516d:	6a 00                	push   $0x0
8010516f:	e8 bc f9 ff ff       	call   80104b30 <argstr>
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	85 c0                	test   %eax,%eax
80105179:	0f 88 7a 01 00 00    	js     801052f9 <sys_unlink+0x199>
  begin_op();
8010517f:	e8 2c dd ff ff       	call   80102eb0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105184:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105187:	83 ec 08             	sub    $0x8,%esp
8010518a:	53                   	push   %ebx
8010518b:	ff 75 c0             	push   -0x40(%ebp)
8010518e:	e8 7d d0 ff ff       	call   80102210 <nameiparent>
80105193:	83 c4 10             	add    $0x10,%esp
80105196:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105199:	85 c0                	test   %eax,%eax
8010519b:	0f 84 62 01 00 00    	je     80105303 <sys_unlink+0x1a3>
  ilock(dp);
801051a1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801051a4:	83 ec 0c             	sub    $0xc,%esp
801051a7:	57                   	push   %edi
801051a8:	e8 23 c7 ff ff       	call   801018d0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801051ad:	58                   	pop    %eax
801051ae:	5a                   	pop    %edx
801051af:	68 54 7a 10 80       	push   $0x80107a54
801051b4:	53                   	push   %ebx
801051b5:	e8 56 cc ff ff       	call   80101e10 <namecmp>
801051ba:	83 c4 10             	add    $0x10,%esp
801051bd:	85 c0                	test   %eax,%eax
801051bf:	0f 84 fb 00 00 00    	je     801052c0 <sys_unlink+0x160>
801051c5:	83 ec 08             	sub    $0x8,%esp
801051c8:	68 53 7a 10 80       	push   $0x80107a53
801051cd:	53                   	push   %ebx
801051ce:	e8 3d cc ff ff       	call   80101e10 <namecmp>
801051d3:	83 c4 10             	add    $0x10,%esp
801051d6:	85 c0                	test   %eax,%eax
801051d8:	0f 84 e2 00 00 00    	je     801052c0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801051de:	83 ec 04             	sub    $0x4,%esp
801051e1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801051e4:	50                   	push   %eax
801051e5:	53                   	push   %ebx
801051e6:	57                   	push   %edi
801051e7:	e8 44 cc ff ff       	call   80101e30 <dirlookup>
801051ec:	83 c4 10             	add    $0x10,%esp
801051ef:	89 c3                	mov    %eax,%ebx
801051f1:	85 c0                	test   %eax,%eax
801051f3:	0f 84 c7 00 00 00    	je     801052c0 <sys_unlink+0x160>
  ilock(ip);
801051f9:	83 ec 0c             	sub    $0xc,%esp
801051fc:	50                   	push   %eax
801051fd:	e8 ce c6 ff ff       	call   801018d0 <ilock>
  if(ip->nlink < 1)
80105202:	83 c4 10             	add    $0x10,%esp
80105205:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010520a:	0f 8e 1c 01 00 00    	jle    8010532c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105210:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105215:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105218:	74 66                	je     80105280 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010521a:	83 ec 04             	sub    $0x4,%esp
8010521d:	6a 10                	push   $0x10
8010521f:	6a 00                	push   $0x0
80105221:	57                   	push   %edi
80105222:	e8 89 f5 ff ff       	call   801047b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105227:	6a 10                	push   $0x10
80105229:	ff 75 c4             	push   -0x3c(%ebp)
8010522c:	57                   	push   %edi
8010522d:	ff 75 b4             	push   -0x4c(%ebp)
80105230:	e8 ab ca ff ff       	call   80101ce0 <writei>
80105235:	83 c4 20             	add    $0x20,%esp
80105238:	83 f8 10             	cmp    $0x10,%eax
8010523b:	0f 85 de 00 00 00    	jne    8010531f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105241:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105246:	0f 84 94 00 00 00    	je     801052e0 <sys_unlink+0x180>
  iunlockput(dp);
8010524c:	83 ec 0c             	sub    $0xc,%esp
8010524f:	ff 75 b4             	push   -0x4c(%ebp)
80105252:	e8 09 c9 ff ff       	call   80101b60 <iunlockput>
  ip->nlink--;
80105257:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010525c:	89 1c 24             	mov    %ebx,(%esp)
8010525f:	e8 bc c5 ff ff       	call   80101820 <iupdate>
  iunlockput(ip);
80105264:	89 1c 24             	mov    %ebx,(%esp)
80105267:	e8 f4 c8 ff ff       	call   80101b60 <iunlockput>
  end_op();
8010526c:	e8 af dc ff ff       	call   80102f20 <end_op>
  return 0;
80105271:	83 c4 10             	add    $0x10,%esp
80105274:	31 c0                	xor    %eax,%eax
}
80105276:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105279:	5b                   	pop    %ebx
8010527a:	5e                   	pop    %esi
8010527b:	5f                   	pop    %edi
8010527c:	5d                   	pop    %ebp
8010527d:	c3                   	ret    
8010527e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105280:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105284:	76 94                	jbe    8010521a <sys_unlink+0xba>
80105286:	be 20 00 00 00       	mov    $0x20,%esi
8010528b:	eb 0b                	jmp    80105298 <sys_unlink+0x138>
8010528d:	8d 76 00             	lea    0x0(%esi),%esi
80105290:	83 c6 10             	add    $0x10,%esi
80105293:	3b 73 58             	cmp    0x58(%ebx),%esi
80105296:	73 82                	jae    8010521a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105298:	6a 10                	push   $0x10
8010529a:	56                   	push   %esi
8010529b:	57                   	push   %edi
8010529c:	53                   	push   %ebx
8010529d:	e8 3e c9 ff ff       	call   80101be0 <readi>
801052a2:	83 c4 10             	add    $0x10,%esp
801052a5:	83 f8 10             	cmp    $0x10,%eax
801052a8:	75 68                	jne    80105312 <sys_unlink+0x1b2>
    if(de.inum != 0)
801052aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801052af:	74 df                	je     80105290 <sys_unlink+0x130>
    iunlockput(ip);
801052b1:	83 ec 0c             	sub    $0xc,%esp
801052b4:	53                   	push   %ebx
801052b5:	e8 a6 c8 ff ff       	call   80101b60 <iunlockput>
    goto bad;
801052ba:	83 c4 10             	add    $0x10,%esp
801052bd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801052c0:	83 ec 0c             	sub    $0xc,%esp
801052c3:	ff 75 b4             	push   -0x4c(%ebp)
801052c6:	e8 95 c8 ff ff       	call   80101b60 <iunlockput>
  end_op();
801052cb:	e8 50 dc ff ff       	call   80102f20 <end_op>
  return -1;
801052d0:	83 c4 10             	add    $0x10,%esp
801052d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052d8:	eb 9c                	jmp    80105276 <sys_unlink+0x116>
801052da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801052e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801052e3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801052e6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801052eb:	50                   	push   %eax
801052ec:	e8 2f c5 ff ff       	call   80101820 <iupdate>
801052f1:	83 c4 10             	add    $0x10,%esp
801052f4:	e9 53 ff ff ff       	jmp    8010524c <sys_unlink+0xec>
    return -1;
801052f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052fe:	e9 73 ff ff ff       	jmp    80105276 <sys_unlink+0x116>
    end_op();
80105303:	e8 18 dc ff ff       	call   80102f20 <end_op>
    return -1;
80105308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010530d:	e9 64 ff ff ff       	jmp    80105276 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105312:	83 ec 0c             	sub    $0xc,%esp
80105315:	68 78 7a 10 80       	push   $0x80107a78
8010531a:	e8 61 b0 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010531f:	83 ec 0c             	sub    $0xc,%esp
80105322:	68 8a 7a 10 80       	push   $0x80107a8a
80105327:	e8 54 b0 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010532c:	83 ec 0c             	sub    $0xc,%esp
8010532f:	68 66 7a 10 80       	push   $0x80107a66
80105334:	e8 47 b0 ff ff       	call   80100380 <panic>
80105339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105340 <sys_open>:

int
sys_open(void)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	57                   	push   %edi
80105344:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105345:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105348:	53                   	push   %ebx
80105349:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010534c:	50                   	push   %eax
8010534d:	6a 00                	push   $0x0
8010534f:	e8 dc f7 ff ff       	call   80104b30 <argstr>
80105354:	83 c4 10             	add    $0x10,%esp
80105357:	85 c0                	test   %eax,%eax
80105359:	0f 88 8e 00 00 00    	js     801053ed <sys_open+0xad>
8010535f:	83 ec 08             	sub    $0x8,%esp
80105362:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105365:	50                   	push   %eax
80105366:	6a 01                	push   $0x1
80105368:	e8 03 f7 ff ff       	call   80104a70 <argint>
8010536d:	83 c4 10             	add    $0x10,%esp
80105370:	85 c0                	test   %eax,%eax
80105372:	78 79                	js     801053ed <sys_open+0xad>
    return -1;

  begin_op();
80105374:	e8 37 db ff ff       	call   80102eb0 <begin_op>

  if(omode & O_CREATE){
80105379:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010537d:	75 79                	jne    801053f8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010537f:	83 ec 0c             	sub    $0xc,%esp
80105382:	ff 75 e0             	push   -0x20(%ebp)
80105385:	e8 66 ce ff ff       	call   801021f0 <namei>
8010538a:	83 c4 10             	add    $0x10,%esp
8010538d:	89 c6                	mov    %eax,%esi
8010538f:	85 c0                	test   %eax,%eax
80105391:	0f 84 7e 00 00 00    	je     80105415 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105397:	83 ec 0c             	sub    $0xc,%esp
8010539a:	50                   	push   %eax
8010539b:	e8 30 c5 ff ff       	call   801018d0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801053a0:	83 c4 10             	add    $0x10,%esp
801053a3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801053a8:	0f 84 c2 00 00 00    	je     80105470 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801053ae:	e8 cd bb ff ff       	call   80100f80 <filealloc>
801053b3:	89 c7                	mov    %eax,%edi
801053b5:	85 c0                	test   %eax,%eax
801053b7:	74 23                	je     801053dc <sys_open+0x9c>
  struct proc *curproc = myproc();
801053b9:	e8 02 e7 ff ff       	call   80103ac0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801053be:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801053c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053c4:	85 d2                	test   %edx,%edx
801053c6:	74 60                	je     80105428 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801053c8:	83 c3 01             	add    $0x1,%ebx
801053cb:	83 fb 10             	cmp    $0x10,%ebx
801053ce:	75 f0                	jne    801053c0 <sys_open+0x80>
    if(f)
      fileclose(f);
801053d0:	83 ec 0c             	sub    $0xc,%esp
801053d3:	57                   	push   %edi
801053d4:	e8 67 bc ff ff       	call   80101040 <fileclose>
801053d9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801053dc:	83 ec 0c             	sub    $0xc,%esp
801053df:	56                   	push   %esi
801053e0:	e8 7b c7 ff ff       	call   80101b60 <iunlockput>
    end_op();
801053e5:	e8 36 db ff ff       	call   80102f20 <end_op>
    return -1;
801053ea:	83 c4 10             	add    $0x10,%esp
801053ed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053f2:	eb 6d                	jmp    80105461 <sys_open+0x121>
801053f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801053f8:	83 ec 0c             	sub    $0xc,%esp
801053fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801053fe:	31 c9                	xor    %ecx,%ecx
80105400:	ba 02 00 00 00       	mov    $0x2,%edx
80105405:	6a 00                	push   $0x0
80105407:	e8 14 f8 ff ff       	call   80104c20 <create>
    if(ip == 0){
8010540c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010540f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105411:	85 c0                	test   %eax,%eax
80105413:	75 99                	jne    801053ae <sys_open+0x6e>
      end_op();
80105415:	e8 06 db ff ff       	call   80102f20 <end_op>
      return -1;
8010541a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010541f:	eb 40                	jmp    80105461 <sys_open+0x121>
80105421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105428:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010542b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010542f:	56                   	push   %esi
80105430:	e8 7b c5 ff ff       	call   801019b0 <iunlock>
  end_op();
80105435:	e8 e6 da ff ff       	call   80102f20 <end_op>

  f->type = FD_INODE;
8010543a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105440:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105443:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105446:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105449:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010544b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105452:	f7 d0                	not    %eax
80105454:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105457:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010545a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010545d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105461:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105464:	89 d8                	mov    %ebx,%eax
80105466:	5b                   	pop    %ebx
80105467:	5e                   	pop    %esi
80105468:	5f                   	pop    %edi
80105469:	5d                   	pop    %ebp
8010546a:	c3                   	ret    
8010546b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010546f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105470:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105473:	85 c9                	test   %ecx,%ecx
80105475:	0f 84 33 ff ff ff    	je     801053ae <sys_open+0x6e>
8010547b:	e9 5c ff ff ff       	jmp    801053dc <sys_open+0x9c>

80105480 <sys_mkdir>:

int
sys_mkdir(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105486:	e8 25 da ff ff       	call   80102eb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010548b:	83 ec 08             	sub    $0x8,%esp
8010548e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105491:	50                   	push   %eax
80105492:	6a 00                	push   $0x0
80105494:	e8 97 f6 ff ff       	call   80104b30 <argstr>
80105499:	83 c4 10             	add    $0x10,%esp
8010549c:	85 c0                	test   %eax,%eax
8010549e:	78 30                	js     801054d0 <sys_mkdir+0x50>
801054a0:	83 ec 0c             	sub    $0xc,%esp
801054a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054a6:	31 c9                	xor    %ecx,%ecx
801054a8:	ba 01 00 00 00       	mov    $0x1,%edx
801054ad:	6a 00                	push   $0x0
801054af:	e8 6c f7 ff ff       	call   80104c20 <create>
801054b4:	83 c4 10             	add    $0x10,%esp
801054b7:	85 c0                	test   %eax,%eax
801054b9:	74 15                	je     801054d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054bb:	83 ec 0c             	sub    $0xc,%esp
801054be:	50                   	push   %eax
801054bf:	e8 9c c6 ff ff       	call   80101b60 <iunlockput>
  end_op();
801054c4:	e8 57 da ff ff       	call   80102f20 <end_op>
  return 0;
801054c9:	83 c4 10             	add    $0x10,%esp
801054cc:	31 c0                	xor    %eax,%eax
}
801054ce:	c9                   	leave  
801054cf:	c3                   	ret    
    end_op();
801054d0:	e8 4b da ff ff       	call   80102f20 <end_op>
    return -1;
801054d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054da:	c9                   	leave  
801054db:	c3                   	ret    
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054e0 <sys_mknod>:

int
sys_mknod(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801054e6:	e8 c5 d9 ff ff       	call   80102eb0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801054eb:	83 ec 08             	sub    $0x8,%esp
801054ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
801054f1:	50                   	push   %eax
801054f2:	6a 00                	push   $0x0
801054f4:	e8 37 f6 ff ff       	call   80104b30 <argstr>
801054f9:	83 c4 10             	add    $0x10,%esp
801054fc:	85 c0                	test   %eax,%eax
801054fe:	78 60                	js     80105560 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105500:	83 ec 08             	sub    $0x8,%esp
80105503:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105506:	50                   	push   %eax
80105507:	6a 01                	push   $0x1
80105509:	e8 62 f5 ff ff       	call   80104a70 <argint>
  if((argstr(0, &path)) < 0 ||
8010550e:	83 c4 10             	add    $0x10,%esp
80105511:	85 c0                	test   %eax,%eax
80105513:	78 4b                	js     80105560 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105515:	83 ec 08             	sub    $0x8,%esp
80105518:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010551b:	50                   	push   %eax
8010551c:	6a 02                	push   $0x2
8010551e:	e8 4d f5 ff ff       	call   80104a70 <argint>
     argint(1, &major) < 0 ||
80105523:	83 c4 10             	add    $0x10,%esp
80105526:	85 c0                	test   %eax,%eax
80105528:	78 36                	js     80105560 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010552a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010552e:	83 ec 0c             	sub    $0xc,%esp
80105531:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105535:	ba 03 00 00 00       	mov    $0x3,%edx
8010553a:	50                   	push   %eax
8010553b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010553e:	e8 dd f6 ff ff       	call   80104c20 <create>
     argint(2, &minor) < 0 ||
80105543:	83 c4 10             	add    $0x10,%esp
80105546:	85 c0                	test   %eax,%eax
80105548:	74 16                	je     80105560 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010554a:	83 ec 0c             	sub    $0xc,%esp
8010554d:	50                   	push   %eax
8010554e:	e8 0d c6 ff ff       	call   80101b60 <iunlockput>
  end_op();
80105553:	e8 c8 d9 ff ff       	call   80102f20 <end_op>
  return 0;
80105558:	83 c4 10             	add    $0x10,%esp
8010555b:	31 c0                	xor    %eax,%eax
}
8010555d:	c9                   	leave  
8010555e:	c3                   	ret    
8010555f:	90                   	nop
    end_op();
80105560:	e8 bb d9 ff ff       	call   80102f20 <end_op>
    return -1;
80105565:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010556a:	c9                   	leave  
8010556b:	c3                   	ret    
8010556c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105570 <sys_chdir>:

int
sys_chdir(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	56                   	push   %esi
80105574:	53                   	push   %ebx
80105575:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105578:	e8 43 e5 ff ff       	call   80103ac0 <myproc>
8010557d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010557f:	e8 2c d9 ff ff       	call   80102eb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105584:	83 ec 08             	sub    $0x8,%esp
80105587:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010558a:	50                   	push   %eax
8010558b:	6a 00                	push   $0x0
8010558d:	e8 9e f5 ff ff       	call   80104b30 <argstr>
80105592:	83 c4 10             	add    $0x10,%esp
80105595:	85 c0                	test   %eax,%eax
80105597:	78 77                	js     80105610 <sys_chdir+0xa0>
80105599:	83 ec 0c             	sub    $0xc,%esp
8010559c:	ff 75 f4             	push   -0xc(%ebp)
8010559f:	e8 4c cc ff ff       	call   801021f0 <namei>
801055a4:	83 c4 10             	add    $0x10,%esp
801055a7:	89 c3                	mov    %eax,%ebx
801055a9:	85 c0                	test   %eax,%eax
801055ab:	74 63                	je     80105610 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801055ad:	83 ec 0c             	sub    $0xc,%esp
801055b0:	50                   	push   %eax
801055b1:	e8 1a c3 ff ff       	call   801018d0 <ilock>
  if(ip->type != T_DIR){
801055b6:	83 c4 10             	add    $0x10,%esp
801055b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055be:	75 30                	jne    801055f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801055c0:	83 ec 0c             	sub    $0xc,%esp
801055c3:	53                   	push   %ebx
801055c4:	e8 e7 c3 ff ff       	call   801019b0 <iunlock>
  iput(curproc->cwd);
801055c9:	58                   	pop    %eax
801055ca:	ff 76 68             	push   0x68(%esi)
801055cd:	e8 2e c4 ff ff       	call   80101a00 <iput>
  end_op();
801055d2:	e8 49 d9 ff ff       	call   80102f20 <end_op>
  curproc->cwd = ip;
801055d7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801055da:	83 c4 10             	add    $0x10,%esp
801055dd:	31 c0                	xor    %eax,%eax
}
801055df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055e2:	5b                   	pop    %ebx
801055e3:	5e                   	pop    %esi
801055e4:	5d                   	pop    %ebp
801055e5:	c3                   	ret    
801055e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801055f0:	83 ec 0c             	sub    $0xc,%esp
801055f3:	53                   	push   %ebx
801055f4:	e8 67 c5 ff ff       	call   80101b60 <iunlockput>
    end_op();
801055f9:	e8 22 d9 ff ff       	call   80102f20 <end_op>
    return -1;
801055fe:	83 c4 10             	add    $0x10,%esp
80105601:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105606:	eb d7                	jmp    801055df <sys_chdir+0x6f>
80105608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560f:	90                   	nop
    end_op();
80105610:	e8 0b d9 ff ff       	call   80102f20 <end_op>
    return -1;
80105615:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010561a:	eb c3                	jmp    801055df <sys_chdir+0x6f>
8010561c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105620 <sys_exec>:

int
sys_exec(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	57                   	push   %edi
80105624:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105625:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010562b:	53                   	push   %ebx
8010562c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105632:	50                   	push   %eax
80105633:	6a 00                	push   $0x0
80105635:	e8 f6 f4 ff ff       	call   80104b30 <argstr>
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	85 c0                	test   %eax,%eax
8010563f:	0f 88 87 00 00 00    	js     801056cc <sys_exec+0xac>
80105645:	83 ec 08             	sub    $0x8,%esp
80105648:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010564e:	50                   	push   %eax
8010564f:	6a 01                	push   $0x1
80105651:	e8 1a f4 ff ff       	call   80104a70 <argint>
80105656:	83 c4 10             	add    $0x10,%esp
80105659:	85 c0                	test   %eax,%eax
8010565b:	78 6f                	js     801056cc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010565d:	83 ec 04             	sub    $0x4,%esp
80105660:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105666:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105668:	68 80 00 00 00       	push   $0x80
8010566d:	6a 00                	push   $0x0
8010566f:	56                   	push   %esi
80105670:	e8 3b f1 ff ff       	call   801047b0 <memset>
80105675:	83 c4 10             	add    $0x10,%esp
80105678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010567f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105680:	83 ec 08             	sub    $0x8,%esp
80105683:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105689:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105690:	50                   	push   %eax
80105691:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105697:	01 f8                	add    %edi,%eax
80105699:	50                   	push   %eax
8010569a:	e8 41 f3 ff ff       	call   801049e0 <fetchint>
8010569f:	83 c4 10             	add    $0x10,%esp
801056a2:	85 c0                	test   %eax,%eax
801056a4:	78 26                	js     801056cc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801056a6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801056ac:	85 c0                	test   %eax,%eax
801056ae:	74 30                	je     801056e0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801056b0:	83 ec 08             	sub    $0x8,%esp
801056b3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801056b6:	52                   	push   %edx
801056b7:	50                   	push   %eax
801056b8:	e8 63 f3 ff ff       	call   80104a20 <fetchstr>
801056bd:	83 c4 10             	add    $0x10,%esp
801056c0:	85 c0                	test   %eax,%eax
801056c2:	78 08                	js     801056cc <sys_exec+0xac>
  for(i=0;; i++){
801056c4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801056c7:	83 fb 20             	cmp    $0x20,%ebx
801056ca:	75 b4                	jne    80105680 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801056cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801056cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056d4:	5b                   	pop    %ebx
801056d5:	5e                   	pop    %esi
801056d6:	5f                   	pop    %edi
801056d7:	5d                   	pop    %ebp
801056d8:	c3                   	ret    
801056d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801056e0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801056e7:	00 00 00 00 
  return exec(path, argv);
801056eb:	83 ec 08             	sub    $0x8,%esp
801056ee:	56                   	push   %esi
801056ef:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801056f5:	e8 06 b5 ff ff       	call   80100c00 <exec>
801056fa:	83 c4 10             	add    $0x10,%esp
}
801056fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105700:	5b                   	pop    %ebx
80105701:	5e                   	pop    %esi
80105702:	5f                   	pop    %edi
80105703:	5d                   	pop    %ebp
80105704:	c3                   	ret    
80105705:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105710 <sys_pipe>:

int
sys_pipe(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	57                   	push   %edi
80105714:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105715:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105718:	53                   	push   %ebx
80105719:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010571c:	6a 08                	push   $0x8
8010571e:	50                   	push   %eax
8010571f:	6a 00                	push   $0x0
80105721:	e8 9a f3 ff ff       	call   80104ac0 <argptr>
80105726:	83 c4 10             	add    $0x10,%esp
80105729:	85 c0                	test   %eax,%eax
8010572b:	78 4a                	js     80105777 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010572d:	83 ec 08             	sub    $0x8,%esp
80105730:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105733:	50                   	push   %eax
80105734:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105737:	50                   	push   %eax
80105738:	e8 43 de ff ff       	call   80103580 <pipealloc>
8010573d:	83 c4 10             	add    $0x10,%esp
80105740:	85 c0                	test   %eax,%eax
80105742:	78 33                	js     80105777 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105744:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105747:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105749:	e8 72 e3 ff ff       	call   80103ac0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010574e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105750:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105754:	85 f6                	test   %esi,%esi
80105756:	74 28                	je     80105780 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105758:	83 c3 01             	add    $0x1,%ebx
8010575b:	83 fb 10             	cmp    $0x10,%ebx
8010575e:	75 f0                	jne    80105750 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	ff 75 e0             	push   -0x20(%ebp)
80105766:	e8 d5 b8 ff ff       	call   80101040 <fileclose>
    fileclose(wf);
8010576b:	58                   	pop    %eax
8010576c:	ff 75 e4             	push   -0x1c(%ebp)
8010576f:	e8 cc b8 ff ff       	call   80101040 <fileclose>
    return -1;
80105774:	83 c4 10             	add    $0x10,%esp
80105777:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577c:	eb 53                	jmp    801057d1 <sys_pipe+0xc1>
8010577e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105780:	8d 73 08             	lea    0x8(%ebx),%esi
80105783:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105787:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010578a:	e8 31 e3 ff ff       	call   80103ac0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010578f:	31 d2                	xor    %edx,%edx
80105791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105798:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010579c:	85 c9                	test   %ecx,%ecx
8010579e:	74 20                	je     801057c0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801057a0:	83 c2 01             	add    $0x1,%edx
801057a3:	83 fa 10             	cmp    $0x10,%edx
801057a6:	75 f0                	jne    80105798 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801057a8:	e8 13 e3 ff ff       	call   80103ac0 <myproc>
801057ad:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801057b4:	00 
801057b5:	eb a9                	jmp    80105760 <sys_pipe+0x50>
801057b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057be:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801057c0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801057c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057c7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801057c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057cc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801057cf:	31 c0                	xor    %eax,%eax
}
801057d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057d4:	5b                   	pop    %ebx
801057d5:	5e                   	pop    %esi
801057d6:	5f                   	pop    %edi
801057d7:	5d                   	pop    %ebp
801057d8:	c3                   	ret    
801057d9:	66 90                	xchg   %ax,%ax
801057db:	66 90                	xchg   %ax,%ax
801057dd:	66 90                	xchg   %ax,%ax
801057df:	90                   	nop

801057e0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801057e0:	e9 7b e4 ff ff       	jmp    80103c60 <fork>
801057e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_exit>:
}

int
sys_exit(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801057f6:	e8 e5 e6 ff ff       	call   80103ee0 <exit>
  return 0;  // not reached
}
801057fb:	31 c0                	xor    %eax,%eax
801057fd:	c9                   	leave  
801057fe:	c3                   	ret    
801057ff:	90                   	nop

80105800 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105800:	e9 0b e8 ff ff       	jmp    80104010 <wait>
80105805:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105810 <sys_kill>:
}

int
sys_kill(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105816:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105819:	50                   	push   %eax
8010581a:	6a 00                	push   $0x0
8010581c:	e8 4f f2 ff ff       	call   80104a70 <argint>
80105821:	83 c4 10             	add    $0x10,%esp
80105824:	85 c0                	test   %eax,%eax
80105826:	78 18                	js     80105840 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105828:	83 ec 0c             	sub    $0xc,%esp
8010582b:	ff 75 f4             	push   -0xc(%ebp)
8010582e:	e8 7d ea ff ff       	call   801042b0 <kill>
80105833:	83 c4 10             	add    $0x10,%esp
}
80105836:	c9                   	leave  
80105837:	c3                   	ret    
80105838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583f:	90                   	nop
80105840:	c9                   	leave  
    return -1;
80105841:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105846:	c3                   	ret    
80105847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584e:	66 90                	xchg   %ax,%ax

80105850 <sys_getpid>:

int
sys_getpid(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105856:	e8 65 e2 ff ff       	call   80103ac0 <myproc>
8010585b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010585e:	c9                   	leave  
8010585f:	c3                   	ret    

80105860 <sys_sbrk>:

int
sys_sbrk(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105864:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105867:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010586a:	50                   	push   %eax
8010586b:	6a 00                	push   $0x0
8010586d:	e8 fe f1 ff ff       	call   80104a70 <argint>
80105872:	83 c4 10             	add    $0x10,%esp
80105875:	85 c0                	test   %eax,%eax
80105877:	78 27                	js     801058a0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105879:	e8 42 e2 ff ff       	call   80103ac0 <myproc>
  if(growproc(n) < 0)
8010587e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105881:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105883:	ff 75 f4             	push   -0xc(%ebp)
80105886:	e8 55 e3 ff ff       	call   80103be0 <growproc>
8010588b:	83 c4 10             	add    $0x10,%esp
8010588e:	85 c0                	test   %eax,%eax
80105890:	78 0e                	js     801058a0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105892:	89 d8                	mov    %ebx,%eax
80105894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105897:	c9                   	leave  
80105898:	c3                   	ret    
80105899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801058a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058a5:	eb eb                	jmp    80105892 <sys_sbrk+0x32>
801058a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ae:	66 90                	xchg   %ax,%ax

801058b0 <sys_sleep>:

int
sys_sleep(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801058b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801058ba:	50                   	push   %eax
801058bb:	6a 00                	push   $0x0
801058bd:	e8 ae f1 ff ff       	call   80104a70 <argint>
801058c2:	83 c4 10             	add    $0x10,%esp
801058c5:	85 c0                	test   %eax,%eax
801058c7:	0f 88 8a 00 00 00    	js     80105957 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801058cd:	83 ec 0c             	sub    $0xc,%esp
801058d0:	68 80 3c 11 80       	push   $0x80113c80
801058d5:	e8 16 ee ff ff       	call   801046f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801058da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801058dd:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  while(ticks - ticks0 < n){
801058e3:	83 c4 10             	add    $0x10,%esp
801058e6:	85 d2                	test   %edx,%edx
801058e8:	75 27                	jne    80105911 <sys_sleep+0x61>
801058ea:	eb 54                	jmp    80105940 <sys_sleep+0x90>
801058ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801058f0:	83 ec 08             	sub    $0x8,%esp
801058f3:	68 80 3c 11 80       	push   $0x80113c80
801058f8:	68 60 3c 11 80       	push   $0x80113c60
801058fd:	e8 8e e8 ff ff       	call   80104190 <sleep>
  while(ticks - ticks0 < n){
80105902:	a1 60 3c 11 80       	mov    0x80113c60,%eax
80105907:	83 c4 10             	add    $0x10,%esp
8010590a:	29 d8                	sub    %ebx,%eax
8010590c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010590f:	73 2f                	jae    80105940 <sys_sleep+0x90>
    if(myproc()->killed){
80105911:	e8 aa e1 ff ff       	call   80103ac0 <myproc>
80105916:	8b 40 24             	mov    0x24(%eax),%eax
80105919:	85 c0                	test   %eax,%eax
8010591b:	74 d3                	je     801058f0 <sys_sleep+0x40>
      release(&tickslock);
8010591d:	83 ec 0c             	sub    $0xc,%esp
80105920:	68 80 3c 11 80       	push   $0x80113c80
80105925:	e8 66 ed ff ff       	call   80104690 <release>
  }
  release(&tickslock);
  return 0;
}
8010592a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010592d:	83 c4 10             	add    $0x10,%esp
80105930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105935:	c9                   	leave  
80105936:	c3                   	ret    
80105937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105940:	83 ec 0c             	sub    $0xc,%esp
80105943:	68 80 3c 11 80       	push   $0x80113c80
80105948:	e8 43 ed ff ff       	call   80104690 <release>
  return 0;
8010594d:	83 c4 10             	add    $0x10,%esp
80105950:	31 c0                	xor    %eax,%eax
}
80105952:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105955:	c9                   	leave  
80105956:	c3                   	ret    
    return -1;
80105957:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010595c:	eb f4                	jmp    80105952 <sys_sleep+0xa2>
8010595e:	66 90                	xchg   %ax,%ax

80105960 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	53                   	push   %ebx
80105964:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105967:	68 80 3c 11 80       	push   $0x80113c80
8010596c:	e8 7f ed ff ff       	call   801046f0 <acquire>
  xticks = ticks;
80105971:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  release(&tickslock);
80105977:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
8010597e:	e8 0d ed ff ff       	call   80104690 <release>
  return xticks;
}
80105983:	89 d8                	mov    %ebx,%eax
80105985:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105988:	c9                   	leave  
80105989:	c3                   	ret    

8010598a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010598a:	1e                   	push   %ds
  pushl %es
8010598b:	06                   	push   %es
  pushl %fs
8010598c:	0f a0                	push   %fs
  pushl %gs
8010598e:	0f a8                	push   %gs
  pushal
80105990:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105991:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105995:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105997:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105999:	54                   	push   %esp
  call trap
8010599a:	e8 c1 00 00 00       	call   80105a60 <trap>
  addl $4, %esp
8010599f:	83 c4 04             	add    $0x4,%esp

801059a2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801059a2:	61                   	popa   
  popl %gs
801059a3:	0f a9                	pop    %gs
  popl %fs
801059a5:	0f a1                	pop    %fs
  popl %es
801059a7:	07                   	pop    %es
  popl %ds
801059a8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801059a9:	83 c4 08             	add    $0x8,%esp
  iret
801059ac:	cf                   	iret   
801059ad:	66 90                	xchg   %ax,%ax
801059af:	90                   	nop

801059b0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801059b0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801059b1:	31 c0                	xor    %eax,%eax
{
801059b3:	89 e5                	mov    %esp,%ebp
801059b5:	83 ec 08             	sub    $0x8,%esp
801059b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059bf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801059c0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801059c7:	c7 04 c5 c2 3c 11 80 	movl   $0x8e000008,-0x7feec33e(,%eax,8)
801059ce:	08 00 00 8e 
801059d2:	66 89 14 c5 c0 3c 11 	mov    %dx,-0x7feec340(,%eax,8)
801059d9:	80 
801059da:	c1 ea 10             	shr    $0x10,%edx
801059dd:	66 89 14 c5 c6 3c 11 	mov    %dx,-0x7feec33a(,%eax,8)
801059e4:	80 
  for(i = 0; i < 256; i++)
801059e5:	83 c0 01             	add    $0x1,%eax
801059e8:	3d 00 01 00 00       	cmp    $0x100,%eax
801059ed:	75 d1                	jne    801059c0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801059ef:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059f2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801059f7:	c7 05 c2 3e 11 80 08 	movl   $0xef000008,0x80113ec2
801059fe:	00 00 ef 
  initlock(&tickslock, "time");
80105a01:	68 99 7a 10 80       	push   $0x80107a99
80105a06:	68 80 3c 11 80       	push   $0x80113c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a0b:	66 a3 c0 3e 11 80    	mov    %ax,0x80113ec0
80105a11:	c1 e8 10             	shr    $0x10,%eax
80105a14:	66 a3 c6 3e 11 80    	mov    %ax,0x80113ec6
  initlock(&tickslock, "time");
80105a1a:	e8 01 eb ff ff       	call   80104520 <initlock>
}
80105a1f:	83 c4 10             	add    $0x10,%esp
80105a22:	c9                   	leave  
80105a23:	c3                   	ret    
80105a24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a2f:	90                   	nop

80105a30 <idtinit>:

void
idtinit(void)
{
80105a30:	55                   	push   %ebp
  pd[0] = size-1;
80105a31:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105a36:	89 e5                	mov    %esp,%ebp
80105a38:	83 ec 10             	sub    $0x10,%esp
80105a3b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105a3f:	b8 c0 3c 11 80       	mov    $0x80113cc0,%eax
80105a44:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105a48:	c1 e8 10             	shr    $0x10,%eax
80105a4b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105a4f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105a52:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105a55:	c9                   	leave  
80105a56:	c3                   	ret    
80105a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5e:	66 90                	xchg   %ax,%ax

80105a60 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	57                   	push   %edi
80105a64:	56                   	push   %esi
80105a65:	53                   	push   %ebx
80105a66:	83 ec 1c             	sub    $0x1c,%esp
80105a69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105a6c:	8b 43 30             	mov    0x30(%ebx),%eax
80105a6f:	83 f8 40             	cmp    $0x40,%eax
80105a72:	0f 84 68 01 00 00    	je     80105be0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105a78:	83 e8 20             	sub    $0x20,%eax
80105a7b:	83 f8 1f             	cmp    $0x1f,%eax
80105a7e:	0f 87 8c 00 00 00    	ja     80105b10 <trap+0xb0>
80105a84:	ff 24 85 40 7b 10 80 	jmp    *-0x7fef84c0(,%eax,4)
80105a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a8f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105a90:	e8 fb c8 ff ff       	call   80102390 <ideintr>
    lapiceoi();
80105a95:	e8 c6 cf ff ff       	call   80102a60 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a9a:	e8 21 e0 ff ff       	call   80103ac0 <myproc>
80105a9f:	85 c0                	test   %eax,%eax
80105aa1:	74 1d                	je     80105ac0 <trap+0x60>
80105aa3:	e8 18 e0 ff ff       	call   80103ac0 <myproc>
80105aa8:	8b 50 24             	mov    0x24(%eax),%edx
80105aab:	85 d2                	test   %edx,%edx
80105aad:	74 11                	je     80105ac0 <trap+0x60>
80105aaf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ab3:	83 e0 03             	and    $0x3,%eax
80105ab6:	66 83 f8 03          	cmp    $0x3,%ax
80105aba:	0f 84 e8 01 00 00    	je     80105ca8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ac0:	e8 fb df ff ff       	call   80103ac0 <myproc>
80105ac5:	85 c0                	test   %eax,%eax
80105ac7:	74 0f                	je     80105ad8 <trap+0x78>
80105ac9:	e8 f2 df ff ff       	call   80103ac0 <myproc>
80105ace:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ad2:	0f 84 b8 00 00 00    	je     80105b90 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ad8:	e8 e3 df ff ff       	call   80103ac0 <myproc>
80105add:	85 c0                	test   %eax,%eax
80105adf:	74 1d                	je     80105afe <trap+0x9e>
80105ae1:	e8 da df ff ff       	call   80103ac0 <myproc>
80105ae6:	8b 40 24             	mov    0x24(%eax),%eax
80105ae9:	85 c0                	test   %eax,%eax
80105aeb:	74 11                	je     80105afe <trap+0x9e>
80105aed:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105af1:	83 e0 03             	and    $0x3,%eax
80105af4:	66 83 f8 03          	cmp    $0x3,%ax
80105af8:	0f 84 0f 01 00 00    	je     80105c0d <trap+0x1ad>
    exit();
}
80105afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b01:	5b                   	pop    %ebx
80105b02:	5e                   	pop    %esi
80105b03:	5f                   	pop    %edi
80105b04:	5d                   	pop    %ebp
80105b05:	c3                   	ret    
80105b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105b10:	e8 ab df ff ff       	call   80103ac0 <myproc>
80105b15:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b18:	85 c0                	test   %eax,%eax
80105b1a:	0f 84 a2 01 00 00    	je     80105cc2 <trap+0x262>
80105b20:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105b24:	0f 84 98 01 00 00    	je     80105cc2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105b2a:	0f 20 d1             	mov    %cr2,%ecx
80105b2d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b30:	e8 6b df ff ff       	call   80103aa0 <cpuid>
80105b35:	8b 73 30             	mov    0x30(%ebx),%esi
80105b38:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105b3b:	8b 43 34             	mov    0x34(%ebx),%eax
80105b3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105b41:	e8 7a df ff ff       	call   80103ac0 <myproc>
80105b46:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105b49:	e8 72 df ff ff       	call   80103ac0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b4e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105b51:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105b54:	51                   	push   %ecx
80105b55:	57                   	push   %edi
80105b56:	52                   	push   %edx
80105b57:	ff 75 e4             	push   -0x1c(%ebp)
80105b5a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105b5b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105b5e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b61:	56                   	push   %esi
80105b62:	ff 70 10             	push   0x10(%eax)
80105b65:	68 fc 7a 10 80       	push   $0x80107afc
80105b6a:	e8 31 ab ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105b6f:	83 c4 20             	add    $0x20,%esp
80105b72:	e8 49 df ff ff       	call   80103ac0 <myproc>
80105b77:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b7e:	e8 3d df ff ff       	call   80103ac0 <myproc>
80105b83:	85 c0                	test   %eax,%eax
80105b85:	0f 85 18 ff ff ff    	jne    80105aa3 <trap+0x43>
80105b8b:	e9 30 ff ff ff       	jmp    80105ac0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105b90:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105b94:	0f 85 3e ff ff ff    	jne    80105ad8 <trap+0x78>
    yield();
80105b9a:	e8 a1 e5 ff ff       	call   80104140 <yield>
80105b9f:	e9 34 ff ff ff       	jmp    80105ad8 <trap+0x78>
80105ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ba8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105bab:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105baf:	e8 ec de ff ff       	call   80103aa0 <cpuid>
80105bb4:	57                   	push   %edi
80105bb5:	56                   	push   %esi
80105bb6:	50                   	push   %eax
80105bb7:	68 a4 7a 10 80       	push   $0x80107aa4
80105bbc:	e8 df aa ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105bc1:	e8 9a ce ff ff       	call   80102a60 <lapiceoi>
    break;
80105bc6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bc9:	e8 f2 de ff ff       	call   80103ac0 <myproc>
80105bce:	85 c0                	test   %eax,%eax
80105bd0:	0f 85 cd fe ff ff    	jne    80105aa3 <trap+0x43>
80105bd6:	e9 e5 fe ff ff       	jmp    80105ac0 <trap+0x60>
80105bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bdf:	90                   	nop
    if(myproc()->killed)
80105be0:	e8 db de ff ff       	call   80103ac0 <myproc>
80105be5:	8b 70 24             	mov    0x24(%eax),%esi
80105be8:	85 f6                	test   %esi,%esi
80105bea:	0f 85 c8 00 00 00    	jne    80105cb8 <trap+0x258>
    myproc()->tf = tf;
80105bf0:	e8 cb de ff ff       	call   80103ac0 <myproc>
80105bf5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105bf8:	e8 b3 ef ff ff       	call   80104bb0 <syscall>
    if(myproc()->killed)
80105bfd:	e8 be de ff ff       	call   80103ac0 <myproc>
80105c02:	8b 48 24             	mov    0x24(%eax),%ecx
80105c05:	85 c9                	test   %ecx,%ecx
80105c07:	0f 84 f1 fe ff ff    	je     80105afe <trap+0x9e>
}
80105c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c10:	5b                   	pop    %ebx
80105c11:	5e                   	pop    %esi
80105c12:	5f                   	pop    %edi
80105c13:	5d                   	pop    %ebp
      exit();
80105c14:	e9 c7 e2 ff ff       	jmp    80103ee0 <exit>
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105c20:	e8 3b 02 00 00       	call   80105e60 <uartintr>
    lapiceoi();
80105c25:	e8 36 ce ff ff       	call   80102a60 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c2a:	e8 91 de ff ff       	call   80103ac0 <myproc>
80105c2f:	85 c0                	test   %eax,%eax
80105c31:	0f 85 6c fe ff ff    	jne    80105aa3 <trap+0x43>
80105c37:	e9 84 fe ff ff       	jmp    80105ac0 <trap+0x60>
80105c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105c40:	e8 db cc ff ff       	call   80102920 <kbdintr>
    lapiceoi();
80105c45:	e8 16 ce ff ff       	call   80102a60 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c4a:	e8 71 de ff ff       	call   80103ac0 <myproc>
80105c4f:	85 c0                	test   %eax,%eax
80105c51:	0f 85 4c fe ff ff    	jne    80105aa3 <trap+0x43>
80105c57:	e9 64 fe ff ff       	jmp    80105ac0 <trap+0x60>
80105c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105c60:	e8 3b de ff ff       	call   80103aa0 <cpuid>
80105c65:	85 c0                	test   %eax,%eax
80105c67:	0f 85 28 fe ff ff    	jne    80105a95 <trap+0x35>
      acquire(&tickslock);
80105c6d:	83 ec 0c             	sub    $0xc,%esp
80105c70:	68 80 3c 11 80       	push   $0x80113c80
80105c75:	e8 76 ea ff ff       	call   801046f0 <acquire>
      wakeup(&ticks);
80105c7a:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
      ticks++;
80105c81:	83 05 60 3c 11 80 01 	addl   $0x1,0x80113c60
      wakeup(&ticks);
80105c88:	e8 c3 e5 ff ff       	call   80104250 <wakeup>
      release(&tickslock);
80105c8d:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105c94:	e8 f7 e9 ff ff       	call   80104690 <release>
80105c99:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105c9c:	e9 f4 fd ff ff       	jmp    80105a95 <trap+0x35>
80105ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105ca8:	e8 33 e2 ff ff       	call   80103ee0 <exit>
80105cad:	e9 0e fe ff ff       	jmp    80105ac0 <trap+0x60>
80105cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105cb8:	e8 23 e2 ff ff       	call   80103ee0 <exit>
80105cbd:	e9 2e ff ff ff       	jmp    80105bf0 <trap+0x190>
80105cc2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105cc5:	e8 d6 dd ff ff       	call   80103aa0 <cpuid>
80105cca:	83 ec 0c             	sub    $0xc,%esp
80105ccd:	56                   	push   %esi
80105cce:	57                   	push   %edi
80105ccf:	50                   	push   %eax
80105cd0:	ff 73 30             	push   0x30(%ebx)
80105cd3:	68 c8 7a 10 80       	push   $0x80107ac8
80105cd8:	e8 c3 a9 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105cdd:	83 c4 14             	add    $0x14,%esp
80105ce0:	68 9e 7a 10 80       	push   $0x80107a9e
80105ce5:	e8 96 a6 ff ff       	call   80100380 <panic>
80105cea:	66 90                	xchg   %ax,%ax
80105cec:	66 90                	xchg   %ax,%ax
80105cee:	66 90                	xchg   %ax,%ax

80105cf0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105cf0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105cf5:	85 c0                	test   %eax,%eax
80105cf7:	74 17                	je     80105d10 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105cf9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cfe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105cff:	a8 01                	test   $0x1,%al
80105d01:	74 0d                	je     80105d10 <uartgetc+0x20>
80105d03:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d08:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105d09:	0f b6 c0             	movzbl %al,%eax
80105d0c:	c3                   	ret    
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d15:	c3                   	ret    
80105d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1d:	8d 76 00             	lea    0x0(%esi),%esi

80105d20 <uartinit>:
{
80105d20:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d21:	31 c9                	xor    %ecx,%ecx
80105d23:	89 c8                	mov    %ecx,%eax
80105d25:	89 e5                	mov    %esp,%ebp
80105d27:	57                   	push   %edi
80105d28:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105d2d:	56                   	push   %esi
80105d2e:	89 fa                	mov    %edi,%edx
80105d30:	53                   	push   %ebx
80105d31:	83 ec 1c             	sub    $0x1c,%esp
80105d34:	ee                   	out    %al,(%dx)
80105d35:	be fb 03 00 00       	mov    $0x3fb,%esi
80105d3a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d3f:	89 f2                	mov    %esi,%edx
80105d41:	ee                   	out    %al,(%dx)
80105d42:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d47:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d4c:	ee                   	out    %al,(%dx)
80105d4d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105d52:	89 c8                	mov    %ecx,%eax
80105d54:	89 da                	mov    %ebx,%edx
80105d56:	ee                   	out    %al,(%dx)
80105d57:	b8 03 00 00 00       	mov    $0x3,%eax
80105d5c:	89 f2                	mov    %esi,%edx
80105d5e:	ee                   	out    %al,(%dx)
80105d5f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d64:	89 c8                	mov    %ecx,%eax
80105d66:	ee                   	out    %al,(%dx)
80105d67:	b8 01 00 00 00       	mov    $0x1,%eax
80105d6c:	89 da                	mov    %ebx,%edx
80105d6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d6f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d74:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d75:	3c ff                	cmp    $0xff,%al
80105d77:	74 78                	je     80105df1 <uartinit+0xd1>
  uart = 1;
80105d79:	c7 05 c0 44 11 80 01 	movl   $0x1,0x801144c0
80105d80:	00 00 00 
80105d83:	89 fa                	mov    %edi,%edx
80105d85:	ec                   	in     (%dx),%al
80105d86:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d8b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105d8c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105d8f:	bf c0 7b 10 80       	mov    $0x80107bc0,%edi
80105d94:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105d99:	6a 00                	push   $0x0
80105d9b:	6a 04                	push   $0x4
80105d9d:	e8 2e c8 ff ff       	call   801025d0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105da2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105da6:	83 c4 10             	add    $0x10,%esp
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105db0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105db5:	bb 80 00 00 00       	mov    $0x80,%ebx
80105dba:	85 c0                	test   %eax,%eax
80105dbc:	75 14                	jne    80105dd2 <uartinit+0xb2>
80105dbe:	eb 23                	jmp    80105de3 <uartinit+0xc3>
    microdelay(10);
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	6a 0a                	push   $0xa
80105dc5:	e8 b6 cc ff ff       	call   80102a80 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105dca:	83 c4 10             	add    $0x10,%esp
80105dcd:	83 eb 01             	sub    $0x1,%ebx
80105dd0:	74 07                	je     80105dd9 <uartinit+0xb9>
80105dd2:	89 f2                	mov    %esi,%edx
80105dd4:	ec                   	in     (%dx),%al
80105dd5:	a8 20                	test   $0x20,%al
80105dd7:	74 e7                	je     80105dc0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105dd9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105ddd:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105de2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105de3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105de7:	83 c7 01             	add    $0x1,%edi
80105dea:	88 45 e7             	mov    %al,-0x19(%ebp)
80105ded:	84 c0                	test   %al,%al
80105def:	75 bf                	jne    80105db0 <uartinit+0x90>
}
80105df1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105df4:	5b                   	pop    %ebx
80105df5:	5e                   	pop    %esi
80105df6:	5f                   	pop    %edi
80105df7:	5d                   	pop    %ebp
80105df8:	c3                   	ret    
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e00 <uartputc>:
  if(!uart)
80105e00:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105e05:	85 c0                	test   %eax,%eax
80105e07:	74 47                	je     80105e50 <uartputc+0x50>
{
80105e09:	55                   	push   %ebp
80105e0a:	89 e5                	mov    %esp,%ebp
80105e0c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e0d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105e12:	53                   	push   %ebx
80105e13:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e18:	eb 18                	jmp    80105e32 <uartputc+0x32>
80105e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105e20:	83 ec 0c             	sub    $0xc,%esp
80105e23:	6a 0a                	push   $0xa
80105e25:	e8 56 cc ff ff       	call   80102a80 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e2a:	83 c4 10             	add    $0x10,%esp
80105e2d:	83 eb 01             	sub    $0x1,%ebx
80105e30:	74 07                	je     80105e39 <uartputc+0x39>
80105e32:	89 f2                	mov    %esi,%edx
80105e34:	ec                   	in     (%dx),%al
80105e35:	a8 20                	test   $0x20,%al
80105e37:	74 e7                	je     80105e20 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e39:	8b 45 08             	mov    0x8(%ebp),%eax
80105e3c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e41:	ee                   	out    %al,(%dx)
}
80105e42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e45:	5b                   	pop    %ebx
80105e46:	5e                   	pop    %esi
80105e47:	5d                   	pop    %ebp
80105e48:	c3                   	ret    
80105e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e50:	c3                   	ret    
80105e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e5f:	90                   	nop

80105e60 <uartintr>:

void
uartintr(void)
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105e66:	68 f0 5c 10 80       	push   $0x80105cf0
80105e6b:	e8 10 aa ff ff       	call   80100880 <consoleintr>
}
80105e70:	83 c4 10             	add    $0x10,%esp
80105e73:	c9                   	leave  
80105e74:	c3                   	ret    

80105e75 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105e75:	6a 00                	push   $0x0
  pushl $0
80105e77:	6a 00                	push   $0x0
  jmp alltraps
80105e79:	e9 0c fb ff ff       	jmp    8010598a <alltraps>

80105e7e <vector1>:
.globl vector1
vector1:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $1
80105e80:	6a 01                	push   $0x1
  jmp alltraps
80105e82:	e9 03 fb ff ff       	jmp    8010598a <alltraps>

80105e87 <vector2>:
.globl vector2
vector2:
  pushl $0
80105e87:	6a 00                	push   $0x0
  pushl $2
80105e89:	6a 02                	push   $0x2
  jmp alltraps
80105e8b:	e9 fa fa ff ff       	jmp    8010598a <alltraps>

80105e90 <vector3>:
.globl vector3
vector3:
  pushl $0
80105e90:	6a 00                	push   $0x0
  pushl $3
80105e92:	6a 03                	push   $0x3
  jmp alltraps
80105e94:	e9 f1 fa ff ff       	jmp    8010598a <alltraps>

80105e99 <vector4>:
.globl vector4
vector4:
  pushl $0
80105e99:	6a 00                	push   $0x0
  pushl $4
80105e9b:	6a 04                	push   $0x4
  jmp alltraps
80105e9d:	e9 e8 fa ff ff       	jmp    8010598a <alltraps>

80105ea2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $5
80105ea4:	6a 05                	push   $0x5
  jmp alltraps
80105ea6:	e9 df fa ff ff       	jmp    8010598a <alltraps>

80105eab <vector6>:
.globl vector6
vector6:
  pushl $0
80105eab:	6a 00                	push   $0x0
  pushl $6
80105ead:	6a 06                	push   $0x6
  jmp alltraps
80105eaf:	e9 d6 fa ff ff       	jmp    8010598a <alltraps>

80105eb4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105eb4:	6a 00                	push   $0x0
  pushl $7
80105eb6:	6a 07                	push   $0x7
  jmp alltraps
80105eb8:	e9 cd fa ff ff       	jmp    8010598a <alltraps>

80105ebd <vector8>:
.globl vector8
vector8:
  pushl $8
80105ebd:	6a 08                	push   $0x8
  jmp alltraps
80105ebf:	e9 c6 fa ff ff       	jmp    8010598a <alltraps>

80105ec4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105ec4:	6a 00                	push   $0x0
  pushl $9
80105ec6:	6a 09                	push   $0x9
  jmp alltraps
80105ec8:	e9 bd fa ff ff       	jmp    8010598a <alltraps>

80105ecd <vector10>:
.globl vector10
vector10:
  pushl $10
80105ecd:	6a 0a                	push   $0xa
  jmp alltraps
80105ecf:	e9 b6 fa ff ff       	jmp    8010598a <alltraps>

80105ed4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105ed4:	6a 0b                	push   $0xb
  jmp alltraps
80105ed6:	e9 af fa ff ff       	jmp    8010598a <alltraps>

80105edb <vector12>:
.globl vector12
vector12:
  pushl $12
80105edb:	6a 0c                	push   $0xc
  jmp alltraps
80105edd:	e9 a8 fa ff ff       	jmp    8010598a <alltraps>

80105ee2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105ee2:	6a 0d                	push   $0xd
  jmp alltraps
80105ee4:	e9 a1 fa ff ff       	jmp    8010598a <alltraps>

80105ee9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105ee9:	6a 0e                	push   $0xe
  jmp alltraps
80105eeb:	e9 9a fa ff ff       	jmp    8010598a <alltraps>

80105ef0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105ef0:	6a 00                	push   $0x0
  pushl $15
80105ef2:	6a 0f                	push   $0xf
  jmp alltraps
80105ef4:	e9 91 fa ff ff       	jmp    8010598a <alltraps>

80105ef9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105ef9:	6a 00                	push   $0x0
  pushl $16
80105efb:	6a 10                	push   $0x10
  jmp alltraps
80105efd:	e9 88 fa ff ff       	jmp    8010598a <alltraps>

80105f02 <vector17>:
.globl vector17
vector17:
  pushl $17
80105f02:	6a 11                	push   $0x11
  jmp alltraps
80105f04:	e9 81 fa ff ff       	jmp    8010598a <alltraps>

80105f09 <vector18>:
.globl vector18
vector18:
  pushl $0
80105f09:	6a 00                	push   $0x0
  pushl $18
80105f0b:	6a 12                	push   $0x12
  jmp alltraps
80105f0d:	e9 78 fa ff ff       	jmp    8010598a <alltraps>

80105f12 <vector19>:
.globl vector19
vector19:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $19
80105f14:	6a 13                	push   $0x13
  jmp alltraps
80105f16:	e9 6f fa ff ff       	jmp    8010598a <alltraps>

80105f1b <vector20>:
.globl vector20
vector20:
  pushl $0
80105f1b:	6a 00                	push   $0x0
  pushl $20
80105f1d:	6a 14                	push   $0x14
  jmp alltraps
80105f1f:	e9 66 fa ff ff       	jmp    8010598a <alltraps>

80105f24 <vector21>:
.globl vector21
vector21:
  pushl $0
80105f24:	6a 00                	push   $0x0
  pushl $21
80105f26:	6a 15                	push   $0x15
  jmp alltraps
80105f28:	e9 5d fa ff ff       	jmp    8010598a <alltraps>

80105f2d <vector22>:
.globl vector22
vector22:
  pushl $0
80105f2d:	6a 00                	push   $0x0
  pushl $22
80105f2f:	6a 16                	push   $0x16
  jmp alltraps
80105f31:	e9 54 fa ff ff       	jmp    8010598a <alltraps>

80105f36 <vector23>:
.globl vector23
vector23:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $23
80105f38:	6a 17                	push   $0x17
  jmp alltraps
80105f3a:	e9 4b fa ff ff       	jmp    8010598a <alltraps>

80105f3f <vector24>:
.globl vector24
vector24:
  pushl $0
80105f3f:	6a 00                	push   $0x0
  pushl $24
80105f41:	6a 18                	push   $0x18
  jmp alltraps
80105f43:	e9 42 fa ff ff       	jmp    8010598a <alltraps>

80105f48 <vector25>:
.globl vector25
vector25:
  pushl $0
80105f48:	6a 00                	push   $0x0
  pushl $25
80105f4a:	6a 19                	push   $0x19
  jmp alltraps
80105f4c:	e9 39 fa ff ff       	jmp    8010598a <alltraps>

80105f51 <vector26>:
.globl vector26
vector26:
  pushl $0
80105f51:	6a 00                	push   $0x0
  pushl $26
80105f53:	6a 1a                	push   $0x1a
  jmp alltraps
80105f55:	e9 30 fa ff ff       	jmp    8010598a <alltraps>

80105f5a <vector27>:
.globl vector27
vector27:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $27
80105f5c:	6a 1b                	push   $0x1b
  jmp alltraps
80105f5e:	e9 27 fa ff ff       	jmp    8010598a <alltraps>

80105f63 <vector28>:
.globl vector28
vector28:
  pushl $0
80105f63:	6a 00                	push   $0x0
  pushl $28
80105f65:	6a 1c                	push   $0x1c
  jmp alltraps
80105f67:	e9 1e fa ff ff       	jmp    8010598a <alltraps>

80105f6c <vector29>:
.globl vector29
vector29:
  pushl $0
80105f6c:	6a 00                	push   $0x0
  pushl $29
80105f6e:	6a 1d                	push   $0x1d
  jmp alltraps
80105f70:	e9 15 fa ff ff       	jmp    8010598a <alltraps>

80105f75 <vector30>:
.globl vector30
vector30:
  pushl $0
80105f75:	6a 00                	push   $0x0
  pushl $30
80105f77:	6a 1e                	push   $0x1e
  jmp alltraps
80105f79:	e9 0c fa ff ff       	jmp    8010598a <alltraps>

80105f7e <vector31>:
.globl vector31
vector31:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $31
80105f80:	6a 1f                	push   $0x1f
  jmp alltraps
80105f82:	e9 03 fa ff ff       	jmp    8010598a <alltraps>

80105f87 <vector32>:
.globl vector32
vector32:
  pushl $0
80105f87:	6a 00                	push   $0x0
  pushl $32
80105f89:	6a 20                	push   $0x20
  jmp alltraps
80105f8b:	e9 fa f9 ff ff       	jmp    8010598a <alltraps>

80105f90 <vector33>:
.globl vector33
vector33:
  pushl $0
80105f90:	6a 00                	push   $0x0
  pushl $33
80105f92:	6a 21                	push   $0x21
  jmp alltraps
80105f94:	e9 f1 f9 ff ff       	jmp    8010598a <alltraps>

80105f99 <vector34>:
.globl vector34
vector34:
  pushl $0
80105f99:	6a 00                	push   $0x0
  pushl $34
80105f9b:	6a 22                	push   $0x22
  jmp alltraps
80105f9d:	e9 e8 f9 ff ff       	jmp    8010598a <alltraps>

80105fa2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $35
80105fa4:	6a 23                	push   $0x23
  jmp alltraps
80105fa6:	e9 df f9 ff ff       	jmp    8010598a <alltraps>

80105fab <vector36>:
.globl vector36
vector36:
  pushl $0
80105fab:	6a 00                	push   $0x0
  pushl $36
80105fad:	6a 24                	push   $0x24
  jmp alltraps
80105faf:	e9 d6 f9 ff ff       	jmp    8010598a <alltraps>

80105fb4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105fb4:	6a 00                	push   $0x0
  pushl $37
80105fb6:	6a 25                	push   $0x25
  jmp alltraps
80105fb8:	e9 cd f9 ff ff       	jmp    8010598a <alltraps>

80105fbd <vector38>:
.globl vector38
vector38:
  pushl $0
80105fbd:	6a 00                	push   $0x0
  pushl $38
80105fbf:	6a 26                	push   $0x26
  jmp alltraps
80105fc1:	e9 c4 f9 ff ff       	jmp    8010598a <alltraps>

80105fc6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $39
80105fc8:	6a 27                	push   $0x27
  jmp alltraps
80105fca:	e9 bb f9 ff ff       	jmp    8010598a <alltraps>

80105fcf <vector40>:
.globl vector40
vector40:
  pushl $0
80105fcf:	6a 00                	push   $0x0
  pushl $40
80105fd1:	6a 28                	push   $0x28
  jmp alltraps
80105fd3:	e9 b2 f9 ff ff       	jmp    8010598a <alltraps>

80105fd8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105fd8:	6a 00                	push   $0x0
  pushl $41
80105fda:	6a 29                	push   $0x29
  jmp alltraps
80105fdc:	e9 a9 f9 ff ff       	jmp    8010598a <alltraps>

80105fe1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105fe1:	6a 00                	push   $0x0
  pushl $42
80105fe3:	6a 2a                	push   $0x2a
  jmp alltraps
80105fe5:	e9 a0 f9 ff ff       	jmp    8010598a <alltraps>

80105fea <vector43>:
.globl vector43
vector43:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $43
80105fec:	6a 2b                	push   $0x2b
  jmp alltraps
80105fee:	e9 97 f9 ff ff       	jmp    8010598a <alltraps>

80105ff3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $44
80105ff5:	6a 2c                	push   $0x2c
  jmp alltraps
80105ff7:	e9 8e f9 ff ff       	jmp    8010598a <alltraps>

80105ffc <vector45>:
.globl vector45
vector45:
  pushl $0
80105ffc:	6a 00                	push   $0x0
  pushl $45
80105ffe:	6a 2d                	push   $0x2d
  jmp alltraps
80106000:	e9 85 f9 ff ff       	jmp    8010598a <alltraps>

80106005 <vector46>:
.globl vector46
vector46:
  pushl $0
80106005:	6a 00                	push   $0x0
  pushl $46
80106007:	6a 2e                	push   $0x2e
  jmp alltraps
80106009:	e9 7c f9 ff ff       	jmp    8010598a <alltraps>

8010600e <vector47>:
.globl vector47
vector47:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $47
80106010:	6a 2f                	push   $0x2f
  jmp alltraps
80106012:	e9 73 f9 ff ff       	jmp    8010598a <alltraps>

80106017 <vector48>:
.globl vector48
vector48:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $48
80106019:	6a 30                	push   $0x30
  jmp alltraps
8010601b:	e9 6a f9 ff ff       	jmp    8010598a <alltraps>

80106020 <vector49>:
.globl vector49
vector49:
  pushl $0
80106020:	6a 00                	push   $0x0
  pushl $49
80106022:	6a 31                	push   $0x31
  jmp alltraps
80106024:	e9 61 f9 ff ff       	jmp    8010598a <alltraps>

80106029 <vector50>:
.globl vector50
vector50:
  pushl $0
80106029:	6a 00                	push   $0x0
  pushl $50
8010602b:	6a 32                	push   $0x32
  jmp alltraps
8010602d:	e9 58 f9 ff ff       	jmp    8010598a <alltraps>

80106032 <vector51>:
.globl vector51
vector51:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $51
80106034:	6a 33                	push   $0x33
  jmp alltraps
80106036:	e9 4f f9 ff ff       	jmp    8010598a <alltraps>

8010603b <vector52>:
.globl vector52
vector52:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $52
8010603d:	6a 34                	push   $0x34
  jmp alltraps
8010603f:	e9 46 f9 ff ff       	jmp    8010598a <alltraps>

80106044 <vector53>:
.globl vector53
vector53:
  pushl $0
80106044:	6a 00                	push   $0x0
  pushl $53
80106046:	6a 35                	push   $0x35
  jmp alltraps
80106048:	e9 3d f9 ff ff       	jmp    8010598a <alltraps>

8010604d <vector54>:
.globl vector54
vector54:
  pushl $0
8010604d:	6a 00                	push   $0x0
  pushl $54
8010604f:	6a 36                	push   $0x36
  jmp alltraps
80106051:	e9 34 f9 ff ff       	jmp    8010598a <alltraps>

80106056 <vector55>:
.globl vector55
vector55:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $55
80106058:	6a 37                	push   $0x37
  jmp alltraps
8010605a:	e9 2b f9 ff ff       	jmp    8010598a <alltraps>

8010605f <vector56>:
.globl vector56
vector56:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $56
80106061:	6a 38                	push   $0x38
  jmp alltraps
80106063:	e9 22 f9 ff ff       	jmp    8010598a <alltraps>

80106068 <vector57>:
.globl vector57
vector57:
  pushl $0
80106068:	6a 00                	push   $0x0
  pushl $57
8010606a:	6a 39                	push   $0x39
  jmp alltraps
8010606c:	e9 19 f9 ff ff       	jmp    8010598a <alltraps>

80106071 <vector58>:
.globl vector58
vector58:
  pushl $0
80106071:	6a 00                	push   $0x0
  pushl $58
80106073:	6a 3a                	push   $0x3a
  jmp alltraps
80106075:	e9 10 f9 ff ff       	jmp    8010598a <alltraps>

8010607a <vector59>:
.globl vector59
vector59:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $59
8010607c:	6a 3b                	push   $0x3b
  jmp alltraps
8010607e:	e9 07 f9 ff ff       	jmp    8010598a <alltraps>

80106083 <vector60>:
.globl vector60
vector60:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $60
80106085:	6a 3c                	push   $0x3c
  jmp alltraps
80106087:	e9 fe f8 ff ff       	jmp    8010598a <alltraps>

8010608c <vector61>:
.globl vector61
vector61:
  pushl $0
8010608c:	6a 00                	push   $0x0
  pushl $61
8010608e:	6a 3d                	push   $0x3d
  jmp alltraps
80106090:	e9 f5 f8 ff ff       	jmp    8010598a <alltraps>

80106095 <vector62>:
.globl vector62
vector62:
  pushl $0
80106095:	6a 00                	push   $0x0
  pushl $62
80106097:	6a 3e                	push   $0x3e
  jmp alltraps
80106099:	e9 ec f8 ff ff       	jmp    8010598a <alltraps>

8010609e <vector63>:
.globl vector63
vector63:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $63
801060a0:	6a 3f                	push   $0x3f
  jmp alltraps
801060a2:	e9 e3 f8 ff ff       	jmp    8010598a <alltraps>

801060a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $64
801060a9:	6a 40                	push   $0x40
  jmp alltraps
801060ab:	e9 da f8 ff ff       	jmp    8010598a <alltraps>

801060b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801060b0:	6a 00                	push   $0x0
  pushl $65
801060b2:	6a 41                	push   $0x41
  jmp alltraps
801060b4:	e9 d1 f8 ff ff       	jmp    8010598a <alltraps>

801060b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $66
801060bb:	6a 42                	push   $0x42
  jmp alltraps
801060bd:	e9 c8 f8 ff ff       	jmp    8010598a <alltraps>

801060c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $67
801060c4:	6a 43                	push   $0x43
  jmp alltraps
801060c6:	e9 bf f8 ff ff       	jmp    8010598a <alltraps>

801060cb <vector68>:
.globl vector68
vector68:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $68
801060cd:	6a 44                	push   $0x44
  jmp alltraps
801060cf:	e9 b6 f8 ff ff       	jmp    8010598a <alltraps>

801060d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801060d4:	6a 00                	push   $0x0
  pushl $69
801060d6:	6a 45                	push   $0x45
  jmp alltraps
801060d8:	e9 ad f8 ff ff       	jmp    8010598a <alltraps>

801060dd <vector70>:
.globl vector70
vector70:
  pushl $0
801060dd:	6a 00                	push   $0x0
  pushl $70
801060df:	6a 46                	push   $0x46
  jmp alltraps
801060e1:	e9 a4 f8 ff ff       	jmp    8010598a <alltraps>

801060e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $71
801060e8:	6a 47                	push   $0x47
  jmp alltraps
801060ea:	e9 9b f8 ff ff       	jmp    8010598a <alltraps>

801060ef <vector72>:
.globl vector72
vector72:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $72
801060f1:	6a 48                	push   $0x48
  jmp alltraps
801060f3:	e9 92 f8 ff ff       	jmp    8010598a <alltraps>

801060f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801060f8:	6a 00                	push   $0x0
  pushl $73
801060fa:	6a 49                	push   $0x49
  jmp alltraps
801060fc:	e9 89 f8 ff ff       	jmp    8010598a <alltraps>

80106101 <vector74>:
.globl vector74
vector74:
  pushl $0
80106101:	6a 00                	push   $0x0
  pushl $74
80106103:	6a 4a                	push   $0x4a
  jmp alltraps
80106105:	e9 80 f8 ff ff       	jmp    8010598a <alltraps>

8010610a <vector75>:
.globl vector75
vector75:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $75
8010610c:	6a 4b                	push   $0x4b
  jmp alltraps
8010610e:	e9 77 f8 ff ff       	jmp    8010598a <alltraps>

80106113 <vector76>:
.globl vector76
vector76:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $76
80106115:	6a 4c                	push   $0x4c
  jmp alltraps
80106117:	e9 6e f8 ff ff       	jmp    8010598a <alltraps>

8010611c <vector77>:
.globl vector77
vector77:
  pushl $0
8010611c:	6a 00                	push   $0x0
  pushl $77
8010611e:	6a 4d                	push   $0x4d
  jmp alltraps
80106120:	e9 65 f8 ff ff       	jmp    8010598a <alltraps>

80106125 <vector78>:
.globl vector78
vector78:
  pushl $0
80106125:	6a 00                	push   $0x0
  pushl $78
80106127:	6a 4e                	push   $0x4e
  jmp alltraps
80106129:	e9 5c f8 ff ff       	jmp    8010598a <alltraps>

8010612e <vector79>:
.globl vector79
vector79:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $79
80106130:	6a 4f                	push   $0x4f
  jmp alltraps
80106132:	e9 53 f8 ff ff       	jmp    8010598a <alltraps>

80106137 <vector80>:
.globl vector80
vector80:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $80
80106139:	6a 50                	push   $0x50
  jmp alltraps
8010613b:	e9 4a f8 ff ff       	jmp    8010598a <alltraps>

80106140 <vector81>:
.globl vector81
vector81:
  pushl $0
80106140:	6a 00                	push   $0x0
  pushl $81
80106142:	6a 51                	push   $0x51
  jmp alltraps
80106144:	e9 41 f8 ff ff       	jmp    8010598a <alltraps>

80106149 <vector82>:
.globl vector82
vector82:
  pushl $0
80106149:	6a 00                	push   $0x0
  pushl $82
8010614b:	6a 52                	push   $0x52
  jmp alltraps
8010614d:	e9 38 f8 ff ff       	jmp    8010598a <alltraps>

80106152 <vector83>:
.globl vector83
vector83:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $83
80106154:	6a 53                	push   $0x53
  jmp alltraps
80106156:	e9 2f f8 ff ff       	jmp    8010598a <alltraps>

8010615b <vector84>:
.globl vector84
vector84:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $84
8010615d:	6a 54                	push   $0x54
  jmp alltraps
8010615f:	e9 26 f8 ff ff       	jmp    8010598a <alltraps>

80106164 <vector85>:
.globl vector85
vector85:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $85
80106166:	6a 55                	push   $0x55
  jmp alltraps
80106168:	e9 1d f8 ff ff       	jmp    8010598a <alltraps>

8010616d <vector86>:
.globl vector86
vector86:
  pushl $0
8010616d:	6a 00                	push   $0x0
  pushl $86
8010616f:	6a 56                	push   $0x56
  jmp alltraps
80106171:	e9 14 f8 ff ff       	jmp    8010598a <alltraps>

80106176 <vector87>:
.globl vector87
vector87:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $87
80106178:	6a 57                	push   $0x57
  jmp alltraps
8010617a:	e9 0b f8 ff ff       	jmp    8010598a <alltraps>

8010617f <vector88>:
.globl vector88
vector88:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $88
80106181:	6a 58                	push   $0x58
  jmp alltraps
80106183:	e9 02 f8 ff ff       	jmp    8010598a <alltraps>

80106188 <vector89>:
.globl vector89
vector89:
  pushl $0
80106188:	6a 00                	push   $0x0
  pushl $89
8010618a:	6a 59                	push   $0x59
  jmp alltraps
8010618c:	e9 f9 f7 ff ff       	jmp    8010598a <alltraps>

80106191 <vector90>:
.globl vector90
vector90:
  pushl $0
80106191:	6a 00                	push   $0x0
  pushl $90
80106193:	6a 5a                	push   $0x5a
  jmp alltraps
80106195:	e9 f0 f7 ff ff       	jmp    8010598a <alltraps>

8010619a <vector91>:
.globl vector91
vector91:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $91
8010619c:	6a 5b                	push   $0x5b
  jmp alltraps
8010619e:	e9 e7 f7 ff ff       	jmp    8010598a <alltraps>

801061a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $92
801061a5:	6a 5c                	push   $0x5c
  jmp alltraps
801061a7:	e9 de f7 ff ff       	jmp    8010598a <alltraps>

801061ac <vector93>:
.globl vector93
vector93:
  pushl $0
801061ac:	6a 00                	push   $0x0
  pushl $93
801061ae:	6a 5d                	push   $0x5d
  jmp alltraps
801061b0:	e9 d5 f7 ff ff       	jmp    8010598a <alltraps>

801061b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801061b5:	6a 00                	push   $0x0
  pushl $94
801061b7:	6a 5e                	push   $0x5e
  jmp alltraps
801061b9:	e9 cc f7 ff ff       	jmp    8010598a <alltraps>

801061be <vector95>:
.globl vector95
vector95:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $95
801061c0:	6a 5f                	push   $0x5f
  jmp alltraps
801061c2:	e9 c3 f7 ff ff       	jmp    8010598a <alltraps>

801061c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $96
801061c9:	6a 60                	push   $0x60
  jmp alltraps
801061cb:	e9 ba f7 ff ff       	jmp    8010598a <alltraps>

801061d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801061d0:	6a 00                	push   $0x0
  pushl $97
801061d2:	6a 61                	push   $0x61
  jmp alltraps
801061d4:	e9 b1 f7 ff ff       	jmp    8010598a <alltraps>

801061d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $98
801061db:	6a 62                	push   $0x62
  jmp alltraps
801061dd:	e9 a8 f7 ff ff       	jmp    8010598a <alltraps>

801061e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $99
801061e4:	6a 63                	push   $0x63
  jmp alltraps
801061e6:	e9 9f f7 ff ff       	jmp    8010598a <alltraps>

801061eb <vector100>:
.globl vector100
vector100:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $100
801061ed:	6a 64                	push   $0x64
  jmp alltraps
801061ef:	e9 96 f7 ff ff       	jmp    8010598a <alltraps>

801061f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $101
801061f6:	6a 65                	push   $0x65
  jmp alltraps
801061f8:	e9 8d f7 ff ff       	jmp    8010598a <alltraps>

801061fd <vector102>:
.globl vector102
vector102:
  pushl $0
801061fd:	6a 00                	push   $0x0
  pushl $102
801061ff:	6a 66                	push   $0x66
  jmp alltraps
80106201:	e9 84 f7 ff ff       	jmp    8010598a <alltraps>

80106206 <vector103>:
.globl vector103
vector103:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $103
80106208:	6a 67                	push   $0x67
  jmp alltraps
8010620a:	e9 7b f7 ff ff       	jmp    8010598a <alltraps>

8010620f <vector104>:
.globl vector104
vector104:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $104
80106211:	6a 68                	push   $0x68
  jmp alltraps
80106213:	e9 72 f7 ff ff       	jmp    8010598a <alltraps>

80106218 <vector105>:
.globl vector105
vector105:
  pushl $0
80106218:	6a 00                	push   $0x0
  pushl $105
8010621a:	6a 69                	push   $0x69
  jmp alltraps
8010621c:	e9 69 f7 ff ff       	jmp    8010598a <alltraps>

80106221 <vector106>:
.globl vector106
vector106:
  pushl $0
80106221:	6a 00                	push   $0x0
  pushl $106
80106223:	6a 6a                	push   $0x6a
  jmp alltraps
80106225:	e9 60 f7 ff ff       	jmp    8010598a <alltraps>

8010622a <vector107>:
.globl vector107
vector107:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $107
8010622c:	6a 6b                	push   $0x6b
  jmp alltraps
8010622e:	e9 57 f7 ff ff       	jmp    8010598a <alltraps>

80106233 <vector108>:
.globl vector108
vector108:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $108
80106235:	6a 6c                	push   $0x6c
  jmp alltraps
80106237:	e9 4e f7 ff ff       	jmp    8010598a <alltraps>

8010623c <vector109>:
.globl vector109
vector109:
  pushl $0
8010623c:	6a 00                	push   $0x0
  pushl $109
8010623e:	6a 6d                	push   $0x6d
  jmp alltraps
80106240:	e9 45 f7 ff ff       	jmp    8010598a <alltraps>

80106245 <vector110>:
.globl vector110
vector110:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $110
80106247:	6a 6e                	push   $0x6e
  jmp alltraps
80106249:	e9 3c f7 ff ff       	jmp    8010598a <alltraps>

8010624e <vector111>:
.globl vector111
vector111:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $111
80106250:	6a 6f                	push   $0x6f
  jmp alltraps
80106252:	e9 33 f7 ff ff       	jmp    8010598a <alltraps>

80106257 <vector112>:
.globl vector112
vector112:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $112
80106259:	6a 70                	push   $0x70
  jmp alltraps
8010625b:	e9 2a f7 ff ff       	jmp    8010598a <alltraps>

80106260 <vector113>:
.globl vector113
vector113:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $113
80106262:	6a 71                	push   $0x71
  jmp alltraps
80106264:	e9 21 f7 ff ff       	jmp    8010598a <alltraps>

80106269 <vector114>:
.globl vector114
vector114:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $114
8010626b:	6a 72                	push   $0x72
  jmp alltraps
8010626d:	e9 18 f7 ff ff       	jmp    8010598a <alltraps>

80106272 <vector115>:
.globl vector115
vector115:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $115
80106274:	6a 73                	push   $0x73
  jmp alltraps
80106276:	e9 0f f7 ff ff       	jmp    8010598a <alltraps>

8010627b <vector116>:
.globl vector116
vector116:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $116
8010627d:	6a 74                	push   $0x74
  jmp alltraps
8010627f:	e9 06 f7 ff ff       	jmp    8010598a <alltraps>

80106284 <vector117>:
.globl vector117
vector117:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $117
80106286:	6a 75                	push   $0x75
  jmp alltraps
80106288:	e9 fd f6 ff ff       	jmp    8010598a <alltraps>

8010628d <vector118>:
.globl vector118
vector118:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $118
8010628f:	6a 76                	push   $0x76
  jmp alltraps
80106291:	e9 f4 f6 ff ff       	jmp    8010598a <alltraps>

80106296 <vector119>:
.globl vector119
vector119:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $119
80106298:	6a 77                	push   $0x77
  jmp alltraps
8010629a:	e9 eb f6 ff ff       	jmp    8010598a <alltraps>

8010629f <vector120>:
.globl vector120
vector120:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $120
801062a1:	6a 78                	push   $0x78
  jmp alltraps
801062a3:	e9 e2 f6 ff ff       	jmp    8010598a <alltraps>

801062a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $121
801062aa:	6a 79                	push   $0x79
  jmp alltraps
801062ac:	e9 d9 f6 ff ff       	jmp    8010598a <alltraps>

801062b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $122
801062b3:	6a 7a                	push   $0x7a
  jmp alltraps
801062b5:	e9 d0 f6 ff ff       	jmp    8010598a <alltraps>

801062ba <vector123>:
.globl vector123
vector123:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $123
801062bc:	6a 7b                	push   $0x7b
  jmp alltraps
801062be:	e9 c7 f6 ff ff       	jmp    8010598a <alltraps>

801062c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $124
801062c5:	6a 7c                	push   $0x7c
  jmp alltraps
801062c7:	e9 be f6 ff ff       	jmp    8010598a <alltraps>

801062cc <vector125>:
.globl vector125
vector125:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $125
801062ce:	6a 7d                	push   $0x7d
  jmp alltraps
801062d0:	e9 b5 f6 ff ff       	jmp    8010598a <alltraps>

801062d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $126
801062d7:	6a 7e                	push   $0x7e
  jmp alltraps
801062d9:	e9 ac f6 ff ff       	jmp    8010598a <alltraps>

801062de <vector127>:
.globl vector127
vector127:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $127
801062e0:	6a 7f                	push   $0x7f
  jmp alltraps
801062e2:	e9 a3 f6 ff ff       	jmp    8010598a <alltraps>

801062e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $128
801062e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801062ee:	e9 97 f6 ff ff       	jmp    8010598a <alltraps>

801062f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $129
801062f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801062fa:	e9 8b f6 ff ff       	jmp    8010598a <alltraps>

801062ff <vector130>:
.globl vector130
vector130:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $130
80106301:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106306:	e9 7f f6 ff ff       	jmp    8010598a <alltraps>

8010630b <vector131>:
.globl vector131
vector131:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $131
8010630d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106312:	e9 73 f6 ff ff       	jmp    8010598a <alltraps>

80106317 <vector132>:
.globl vector132
vector132:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $132
80106319:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010631e:	e9 67 f6 ff ff       	jmp    8010598a <alltraps>

80106323 <vector133>:
.globl vector133
vector133:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $133
80106325:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010632a:	e9 5b f6 ff ff       	jmp    8010598a <alltraps>

8010632f <vector134>:
.globl vector134
vector134:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $134
80106331:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106336:	e9 4f f6 ff ff       	jmp    8010598a <alltraps>

8010633b <vector135>:
.globl vector135
vector135:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $135
8010633d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106342:	e9 43 f6 ff ff       	jmp    8010598a <alltraps>

80106347 <vector136>:
.globl vector136
vector136:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $136
80106349:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010634e:	e9 37 f6 ff ff       	jmp    8010598a <alltraps>

80106353 <vector137>:
.globl vector137
vector137:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $137
80106355:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010635a:	e9 2b f6 ff ff       	jmp    8010598a <alltraps>

8010635f <vector138>:
.globl vector138
vector138:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $138
80106361:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106366:	e9 1f f6 ff ff       	jmp    8010598a <alltraps>

8010636b <vector139>:
.globl vector139
vector139:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $139
8010636d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106372:	e9 13 f6 ff ff       	jmp    8010598a <alltraps>

80106377 <vector140>:
.globl vector140
vector140:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $140
80106379:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010637e:	e9 07 f6 ff ff       	jmp    8010598a <alltraps>

80106383 <vector141>:
.globl vector141
vector141:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $141
80106385:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010638a:	e9 fb f5 ff ff       	jmp    8010598a <alltraps>

8010638f <vector142>:
.globl vector142
vector142:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $142
80106391:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106396:	e9 ef f5 ff ff       	jmp    8010598a <alltraps>

8010639b <vector143>:
.globl vector143
vector143:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $143
8010639d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801063a2:	e9 e3 f5 ff ff       	jmp    8010598a <alltraps>

801063a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $144
801063a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801063ae:	e9 d7 f5 ff ff       	jmp    8010598a <alltraps>

801063b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $145
801063b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801063ba:	e9 cb f5 ff ff       	jmp    8010598a <alltraps>

801063bf <vector146>:
.globl vector146
vector146:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $146
801063c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801063c6:	e9 bf f5 ff ff       	jmp    8010598a <alltraps>

801063cb <vector147>:
.globl vector147
vector147:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $147
801063cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801063d2:	e9 b3 f5 ff ff       	jmp    8010598a <alltraps>

801063d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $148
801063d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801063de:	e9 a7 f5 ff ff       	jmp    8010598a <alltraps>

801063e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $149
801063e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801063ea:	e9 9b f5 ff ff       	jmp    8010598a <alltraps>

801063ef <vector150>:
.globl vector150
vector150:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $150
801063f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801063f6:	e9 8f f5 ff ff       	jmp    8010598a <alltraps>

801063fb <vector151>:
.globl vector151
vector151:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $151
801063fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106402:	e9 83 f5 ff ff       	jmp    8010598a <alltraps>

80106407 <vector152>:
.globl vector152
vector152:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $152
80106409:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010640e:	e9 77 f5 ff ff       	jmp    8010598a <alltraps>

80106413 <vector153>:
.globl vector153
vector153:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $153
80106415:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010641a:	e9 6b f5 ff ff       	jmp    8010598a <alltraps>

8010641f <vector154>:
.globl vector154
vector154:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $154
80106421:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106426:	e9 5f f5 ff ff       	jmp    8010598a <alltraps>

8010642b <vector155>:
.globl vector155
vector155:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $155
8010642d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106432:	e9 53 f5 ff ff       	jmp    8010598a <alltraps>

80106437 <vector156>:
.globl vector156
vector156:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $156
80106439:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010643e:	e9 47 f5 ff ff       	jmp    8010598a <alltraps>

80106443 <vector157>:
.globl vector157
vector157:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $157
80106445:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010644a:	e9 3b f5 ff ff       	jmp    8010598a <alltraps>

8010644f <vector158>:
.globl vector158
vector158:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $158
80106451:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106456:	e9 2f f5 ff ff       	jmp    8010598a <alltraps>

8010645b <vector159>:
.globl vector159
vector159:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $159
8010645d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106462:	e9 23 f5 ff ff       	jmp    8010598a <alltraps>

80106467 <vector160>:
.globl vector160
vector160:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $160
80106469:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010646e:	e9 17 f5 ff ff       	jmp    8010598a <alltraps>

80106473 <vector161>:
.globl vector161
vector161:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $161
80106475:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010647a:	e9 0b f5 ff ff       	jmp    8010598a <alltraps>

8010647f <vector162>:
.globl vector162
vector162:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $162
80106481:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106486:	e9 ff f4 ff ff       	jmp    8010598a <alltraps>

8010648b <vector163>:
.globl vector163
vector163:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $163
8010648d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106492:	e9 f3 f4 ff ff       	jmp    8010598a <alltraps>

80106497 <vector164>:
.globl vector164
vector164:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $164
80106499:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010649e:	e9 e7 f4 ff ff       	jmp    8010598a <alltraps>

801064a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $165
801064a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801064aa:	e9 db f4 ff ff       	jmp    8010598a <alltraps>

801064af <vector166>:
.globl vector166
vector166:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $166
801064b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801064b6:	e9 cf f4 ff ff       	jmp    8010598a <alltraps>

801064bb <vector167>:
.globl vector167
vector167:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $167
801064bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801064c2:	e9 c3 f4 ff ff       	jmp    8010598a <alltraps>

801064c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $168
801064c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801064ce:	e9 b7 f4 ff ff       	jmp    8010598a <alltraps>

801064d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $169
801064d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801064da:	e9 ab f4 ff ff       	jmp    8010598a <alltraps>

801064df <vector170>:
.globl vector170
vector170:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $170
801064e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801064e6:	e9 9f f4 ff ff       	jmp    8010598a <alltraps>

801064eb <vector171>:
.globl vector171
vector171:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $171
801064ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801064f2:	e9 93 f4 ff ff       	jmp    8010598a <alltraps>

801064f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $172
801064f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801064fe:	e9 87 f4 ff ff       	jmp    8010598a <alltraps>

80106503 <vector173>:
.globl vector173
vector173:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $173
80106505:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010650a:	e9 7b f4 ff ff       	jmp    8010598a <alltraps>

8010650f <vector174>:
.globl vector174
vector174:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $174
80106511:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106516:	e9 6f f4 ff ff       	jmp    8010598a <alltraps>

8010651b <vector175>:
.globl vector175
vector175:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $175
8010651d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106522:	e9 63 f4 ff ff       	jmp    8010598a <alltraps>

80106527 <vector176>:
.globl vector176
vector176:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $176
80106529:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010652e:	e9 57 f4 ff ff       	jmp    8010598a <alltraps>

80106533 <vector177>:
.globl vector177
vector177:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $177
80106535:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010653a:	e9 4b f4 ff ff       	jmp    8010598a <alltraps>

8010653f <vector178>:
.globl vector178
vector178:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $178
80106541:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106546:	e9 3f f4 ff ff       	jmp    8010598a <alltraps>

8010654b <vector179>:
.globl vector179
vector179:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $179
8010654d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106552:	e9 33 f4 ff ff       	jmp    8010598a <alltraps>

80106557 <vector180>:
.globl vector180
vector180:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $180
80106559:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010655e:	e9 27 f4 ff ff       	jmp    8010598a <alltraps>

80106563 <vector181>:
.globl vector181
vector181:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $181
80106565:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010656a:	e9 1b f4 ff ff       	jmp    8010598a <alltraps>

8010656f <vector182>:
.globl vector182
vector182:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $182
80106571:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106576:	e9 0f f4 ff ff       	jmp    8010598a <alltraps>

8010657b <vector183>:
.globl vector183
vector183:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $183
8010657d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106582:	e9 03 f4 ff ff       	jmp    8010598a <alltraps>

80106587 <vector184>:
.globl vector184
vector184:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $184
80106589:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010658e:	e9 f7 f3 ff ff       	jmp    8010598a <alltraps>

80106593 <vector185>:
.globl vector185
vector185:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $185
80106595:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010659a:	e9 eb f3 ff ff       	jmp    8010598a <alltraps>

8010659f <vector186>:
.globl vector186
vector186:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $186
801065a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801065a6:	e9 df f3 ff ff       	jmp    8010598a <alltraps>

801065ab <vector187>:
.globl vector187
vector187:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $187
801065ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801065b2:	e9 d3 f3 ff ff       	jmp    8010598a <alltraps>

801065b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $188
801065b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801065be:	e9 c7 f3 ff ff       	jmp    8010598a <alltraps>

801065c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $189
801065c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801065ca:	e9 bb f3 ff ff       	jmp    8010598a <alltraps>

801065cf <vector190>:
.globl vector190
vector190:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $190
801065d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801065d6:	e9 af f3 ff ff       	jmp    8010598a <alltraps>

801065db <vector191>:
.globl vector191
vector191:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $191
801065dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801065e2:	e9 a3 f3 ff ff       	jmp    8010598a <alltraps>

801065e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $192
801065e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801065ee:	e9 97 f3 ff ff       	jmp    8010598a <alltraps>

801065f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $193
801065f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801065fa:	e9 8b f3 ff ff       	jmp    8010598a <alltraps>

801065ff <vector194>:
.globl vector194
vector194:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $194
80106601:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106606:	e9 7f f3 ff ff       	jmp    8010598a <alltraps>

8010660b <vector195>:
.globl vector195
vector195:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $195
8010660d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106612:	e9 73 f3 ff ff       	jmp    8010598a <alltraps>

80106617 <vector196>:
.globl vector196
vector196:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $196
80106619:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010661e:	e9 67 f3 ff ff       	jmp    8010598a <alltraps>

80106623 <vector197>:
.globl vector197
vector197:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $197
80106625:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010662a:	e9 5b f3 ff ff       	jmp    8010598a <alltraps>

8010662f <vector198>:
.globl vector198
vector198:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $198
80106631:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106636:	e9 4f f3 ff ff       	jmp    8010598a <alltraps>

8010663b <vector199>:
.globl vector199
vector199:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $199
8010663d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106642:	e9 43 f3 ff ff       	jmp    8010598a <alltraps>

80106647 <vector200>:
.globl vector200
vector200:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $200
80106649:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010664e:	e9 37 f3 ff ff       	jmp    8010598a <alltraps>

80106653 <vector201>:
.globl vector201
vector201:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $201
80106655:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010665a:	e9 2b f3 ff ff       	jmp    8010598a <alltraps>

8010665f <vector202>:
.globl vector202
vector202:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $202
80106661:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106666:	e9 1f f3 ff ff       	jmp    8010598a <alltraps>

8010666b <vector203>:
.globl vector203
vector203:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $203
8010666d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106672:	e9 13 f3 ff ff       	jmp    8010598a <alltraps>

80106677 <vector204>:
.globl vector204
vector204:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $204
80106679:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010667e:	e9 07 f3 ff ff       	jmp    8010598a <alltraps>

80106683 <vector205>:
.globl vector205
vector205:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $205
80106685:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010668a:	e9 fb f2 ff ff       	jmp    8010598a <alltraps>

8010668f <vector206>:
.globl vector206
vector206:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $206
80106691:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106696:	e9 ef f2 ff ff       	jmp    8010598a <alltraps>

8010669b <vector207>:
.globl vector207
vector207:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $207
8010669d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801066a2:	e9 e3 f2 ff ff       	jmp    8010598a <alltraps>

801066a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $208
801066a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801066ae:	e9 d7 f2 ff ff       	jmp    8010598a <alltraps>

801066b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $209
801066b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801066ba:	e9 cb f2 ff ff       	jmp    8010598a <alltraps>

801066bf <vector210>:
.globl vector210
vector210:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $210
801066c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801066c6:	e9 bf f2 ff ff       	jmp    8010598a <alltraps>

801066cb <vector211>:
.globl vector211
vector211:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $211
801066cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801066d2:	e9 b3 f2 ff ff       	jmp    8010598a <alltraps>

801066d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $212
801066d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801066de:	e9 a7 f2 ff ff       	jmp    8010598a <alltraps>

801066e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $213
801066e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801066ea:	e9 9b f2 ff ff       	jmp    8010598a <alltraps>

801066ef <vector214>:
.globl vector214
vector214:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $214
801066f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801066f6:	e9 8f f2 ff ff       	jmp    8010598a <alltraps>

801066fb <vector215>:
.globl vector215
vector215:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $215
801066fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106702:	e9 83 f2 ff ff       	jmp    8010598a <alltraps>

80106707 <vector216>:
.globl vector216
vector216:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $216
80106709:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010670e:	e9 77 f2 ff ff       	jmp    8010598a <alltraps>

80106713 <vector217>:
.globl vector217
vector217:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $217
80106715:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010671a:	e9 6b f2 ff ff       	jmp    8010598a <alltraps>

8010671f <vector218>:
.globl vector218
vector218:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $218
80106721:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106726:	e9 5f f2 ff ff       	jmp    8010598a <alltraps>

8010672b <vector219>:
.globl vector219
vector219:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $219
8010672d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106732:	e9 53 f2 ff ff       	jmp    8010598a <alltraps>

80106737 <vector220>:
.globl vector220
vector220:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $220
80106739:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010673e:	e9 47 f2 ff ff       	jmp    8010598a <alltraps>

80106743 <vector221>:
.globl vector221
vector221:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $221
80106745:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010674a:	e9 3b f2 ff ff       	jmp    8010598a <alltraps>

8010674f <vector222>:
.globl vector222
vector222:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $222
80106751:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106756:	e9 2f f2 ff ff       	jmp    8010598a <alltraps>

8010675b <vector223>:
.globl vector223
vector223:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $223
8010675d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106762:	e9 23 f2 ff ff       	jmp    8010598a <alltraps>

80106767 <vector224>:
.globl vector224
vector224:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $224
80106769:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010676e:	e9 17 f2 ff ff       	jmp    8010598a <alltraps>

80106773 <vector225>:
.globl vector225
vector225:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $225
80106775:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010677a:	e9 0b f2 ff ff       	jmp    8010598a <alltraps>

8010677f <vector226>:
.globl vector226
vector226:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $226
80106781:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106786:	e9 ff f1 ff ff       	jmp    8010598a <alltraps>

8010678b <vector227>:
.globl vector227
vector227:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $227
8010678d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106792:	e9 f3 f1 ff ff       	jmp    8010598a <alltraps>

80106797 <vector228>:
.globl vector228
vector228:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $228
80106799:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010679e:	e9 e7 f1 ff ff       	jmp    8010598a <alltraps>

801067a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $229
801067a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801067aa:	e9 db f1 ff ff       	jmp    8010598a <alltraps>

801067af <vector230>:
.globl vector230
vector230:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $230
801067b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801067b6:	e9 cf f1 ff ff       	jmp    8010598a <alltraps>

801067bb <vector231>:
.globl vector231
vector231:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $231
801067bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801067c2:	e9 c3 f1 ff ff       	jmp    8010598a <alltraps>

801067c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $232
801067c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801067ce:	e9 b7 f1 ff ff       	jmp    8010598a <alltraps>

801067d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $233
801067d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801067da:	e9 ab f1 ff ff       	jmp    8010598a <alltraps>

801067df <vector234>:
.globl vector234
vector234:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $234
801067e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801067e6:	e9 9f f1 ff ff       	jmp    8010598a <alltraps>

801067eb <vector235>:
.globl vector235
vector235:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $235
801067ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801067f2:	e9 93 f1 ff ff       	jmp    8010598a <alltraps>

801067f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $236
801067f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801067fe:	e9 87 f1 ff ff       	jmp    8010598a <alltraps>

80106803 <vector237>:
.globl vector237
vector237:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $237
80106805:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010680a:	e9 7b f1 ff ff       	jmp    8010598a <alltraps>

8010680f <vector238>:
.globl vector238
vector238:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $238
80106811:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106816:	e9 6f f1 ff ff       	jmp    8010598a <alltraps>

8010681b <vector239>:
.globl vector239
vector239:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $239
8010681d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106822:	e9 63 f1 ff ff       	jmp    8010598a <alltraps>

80106827 <vector240>:
.globl vector240
vector240:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $240
80106829:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010682e:	e9 57 f1 ff ff       	jmp    8010598a <alltraps>

80106833 <vector241>:
.globl vector241
vector241:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $241
80106835:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010683a:	e9 4b f1 ff ff       	jmp    8010598a <alltraps>

8010683f <vector242>:
.globl vector242
vector242:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $242
80106841:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106846:	e9 3f f1 ff ff       	jmp    8010598a <alltraps>

8010684b <vector243>:
.globl vector243
vector243:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $243
8010684d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106852:	e9 33 f1 ff ff       	jmp    8010598a <alltraps>

80106857 <vector244>:
.globl vector244
vector244:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $244
80106859:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010685e:	e9 27 f1 ff ff       	jmp    8010598a <alltraps>

80106863 <vector245>:
.globl vector245
vector245:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $245
80106865:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010686a:	e9 1b f1 ff ff       	jmp    8010598a <alltraps>

8010686f <vector246>:
.globl vector246
vector246:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $246
80106871:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106876:	e9 0f f1 ff ff       	jmp    8010598a <alltraps>

8010687b <vector247>:
.globl vector247
vector247:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $247
8010687d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106882:	e9 03 f1 ff ff       	jmp    8010598a <alltraps>

80106887 <vector248>:
.globl vector248
vector248:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $248
80106889:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010688e:	e9 f7 f0 ff ff       	jmp    8010598a <alltraps>

80106893 <vector249>:
.globl vector249
vector249:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $249
80106895:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010689a:	e9 eb f0 ff ff       	jmp    8010598a <alltraps>

8010689f <vector250>:
.globl vector250
vector250:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $250
801068a1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801068a6:	e9 df f0 ff ff       	jmp    8010598a <alltraps>

801068ab <vector251>:
.globl vector251
vector251:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $251
801068ad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801068b2:	e9 d3 f0 ff ff       	jmp    8010598a <alltraps>

801068b7 <vector252>:
.globl vector252
vector252:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $252
801068b9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801068be:	e9 c7 f0 ff ff       	jmp    8010598a <alltraps>

801068c3 <vector253>:
.globl vector253
vector253:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $253
801068c5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801068ca:	e9 bb f0 ff ff       	jmp    8010598a <alltraps>

801068cf <vector254>:
.globl vector254
vector254:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $254
801068d1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801068d6:	e9 af f0 ff ff       	jmp    8010598a <alltraps>

801068db <vector255>:
.globl vector255
vector255:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $255
801068dd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801068e2:	e9 a3 f0 ff ff       	jmp    8010598a <alltraps>
801068e7:	66 90                	xchg   %ax,%ax
801068e9:	66 90                	xchg   %ax,%ax
801068eb:	66 90                	xchg   %ax,%ax
801068ed:	66 90                	xchg   %ax,%ax
801068ef:	90                   	nop

801068f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	57                   	push   %edi
801068f4:	56                   	push   %esi
801068f5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801068f6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801068fc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106902:	83 ec 1c             	sub    $0x1c,%esp
80106905:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106908:	39 d3                	cmp    %edx,%ebx
8010690a:	73 49                	jae    80106955 <deallocuvm.part.0+0x65>
8010690c:	89 c7                	mov    %eax,%edi
8010690e:	eb 0c                	jmp    8010691c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106910:	83 c0 01             	add    $0x1,%eax
80106913:	c1 e0 16             	shl    $0x16,%eax
80106916:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106918:	39 da                	cmp    %ebx,%edx
8010691a:	76 39                	jbe    80106955 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010691c:	89 d8                	mov    %ebx,%eax
8010691e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106921:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106924:	f6 c1 01             	test   $0x1,%cl
80106927:	74 e7                	je     80106910 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106929:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010692b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106931:	c1 ee 0a             	shr    $0xa,%esi
80106934:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010693a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106941:	85 f6                	test   %esi,%esi
80106943:	74 cb                	je     80106910 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106945:	8b 06                	mov    (%esi),%eax
80106947:	a8 01                	test   $0x1,%al
80106949:	75 15                	jne    80106960 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010694b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106951:	39 da                	cmp    %ebx,%edx
80106953:	77 c7                	ja     8010691c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106955:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106958:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010695b:	5b                   	pop    %ebx
8010695c:	5e                   	pop    %esi
8010695d:	5f                   	pop    %edi
8010695e:	5d                   	pop    %ebp
8010695f:	c3                   	ret    
      if(pa == 0)
80106960:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106965:	74 25                	je     8010698c <deallocuvm.part.0+0x9c>
      kfree(v);
80106967:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010696a:	05 00 00 00 80       	add    $0x80000000,%eax
8010696f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106972:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106978:	50                   	push   %eax
80106979:	e8 92 bc ff ff       	call   80102610 <kfree>
      *pte = 0;
8010697e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106984:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106987:	83 c4 10             	add    $0x10,%esp
8010698a:	eb 8c                	jmp    80106918 <deallocuvm.part.0+0x28>
        panic("kfree");
8010698c:	83 ec 0c             	sub    $0xc,%esp
8010698f:	68 7e 75 10 80       	push   $0x8010757e
80106994:	e8 e7 99 ff ff       	call   80100380 <panic>
80106999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069a0 <mappages>:
{
801069a0:	55                   	push   %ebp
801069a1:	89 e5                	mov    %esp,%ebp
801069a3:	57                   	push   %edi
801069a4:	56                   	push   %esi
801069a5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801069a6:	89 d3                	mov    %edx,%ebx
801069a8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801069ae:	83 ec 1c             	sub    $0x1c,%esp
801069b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801069b4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801069b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801069bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801069c0:	8b 45 08             	mov    0x8(%ebp),%eax
801069c3:	29 d8                	sub    %ebx,%eax
801069c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801069c8:	eb 3d                	jmp    80106a07 <mappages+0x67>
801069ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801069d0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801069d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801069d7:	c1 ea 0a             	shr    $0xa,%edx
801069da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801069e0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801069e7:	85 c0                	test   %eax,%eax
801069e9:	74 75                	je     80106a60 <mappages+0xc0>
    if(*pte & PTE_P)
801069eb:	f6 00 01             	testb  $0x1,(%eax)
801069ee:	0f 85 86 00 00 00    	jne    80106a7a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801069f4:	0b 75 0c             	or     0xc(%ebp),%esi
801069f7:	83 ce 01             	or     $0x1,%esi
801069fa:	89 30                	mov    %esi,(%eax)
    if(a == last)
801069fc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801069ff:	74 6f                	je     80106a70 <mappages+0xd0>
    a += PGSIZE;
80106a01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106a07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106a0a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a0d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106a10:	89 d8                	mov    %ebx,%eax
80106a12:	c1 e8 16             	shr    $0x16,%eax
80106a15:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106a18:	8b 07                	mov    (%edi),%eax
80106a1a:	a8 01                	test   $0x1,%al
80106a1c:	75 b2                	jne    801069d0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106a1e:	e8 ad bd ff ff       	call   801027d0 <kalloc>
80106a23:	85 c0                	test   %eax,%eax
80106a25:	74 39                	je     80106a60 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106a27:	83 ec 04             	sub    $0x4,%esp
80106a2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106a2d:	68 00 10 00 00       	push   $0x1000
80106a32:	6a 00                	push   $0x0
80106a34:	50                   	push   %eax
80106a35:	e8 76 dd ff ff       	call   801047b0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106a3a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106a3d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106a40:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106a46:	83 c8 07             	or     $0x7,%eax
80106a49:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106a4b:	89 d8                	mov    %ebx,%eax
80106a4d:	c1 e8 0a             	shr    $0xa,%eax
80106a50:	25 fc 0f 00 00       	and    $0xffc,%eax
80106a55:	01 d0                	add    %edx,%eax
80106a57:	eb 92                	jmp    801069eb <mappages+0x4b>
80106a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106a60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106a63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a68:	5b                   	pop    %ebx
80106a69:	5e                   	pop    %esi
80106a6a:	5f                   	pop    %edi
80106a6b:	5d                   	pop    %ebp
80106a6c:	c3                   	ret    
80106a6d:	8d 76 00             	lea    0x0(%esi),%esi
80106a70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106a73:	31 c0                	xor    %eax,%eax
}
80106a75:	5b                   	pop    %ebx
80106a76:	5e                   	pop    %esi
80106a77:	5f                   	pop    %edi
80106a78:	5d                   	pop    %ebp
80106a79:	c3                   	ret    
      panic("remap");
80106a7a:	83 ec 0c             	sub    $0xc,%esp
80106a7d:	68 c8 7b 10 80       	push   $0x80107bc8
80106a82:	e8 f9 98 ff ff       	call   80100380 <panic>
80106a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a8e:	66 90                	xchg   %ax,%ax

80106a90 <seginit>:
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106a96:	e8 05 d0 ff ff       	call   80103aa0 <cpuid>
  pd[0] = size-1;
80106a9b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106aa0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106aa6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106aaa:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106ab1:	ff 00 00 
80106ab4:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106abb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106abe:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106ac5:	ff 00 00 
80106ac8:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106acf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ad2:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106ad9:	ff 00 00 
80106adc:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106ae3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ae6:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106aed:	ff 00 00 
80106af0:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106af7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106afa:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106aff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106b03:	c1 e8 10             	shr    $0x10,%eax
80106b06:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106b0a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106b0d:	0f 01 10             	lgdtl  (%eax)
}
80106b10:	c9                   	leave  
80106b11:	c3                   	ret    
80106b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b20 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b20:	a1 c4 44 11 80       	mov    0x801144c4,%eax
80106b25:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b2a:	0f 22 d8             	mov    %eax,%cr3
}
80106b2d:	c3                   	ret    
80106b2e:	66 90                	xchg   %ax,%ax

80106b30 <switchuvm>:
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	56                   	push   %esi
80106b35:	53                   	push   %ebx
80106b36:	83 ec 1c             	sub    $0x1c,%esp
80106b39:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106b3c:	85 f6                	test   %esi,%esi
80106b3e:	0f 84 cb 00 00 00    	je     80106c0f <switchuvm+0xdf>
  if(p->kstack == 0)
80106b44:	8b 46 08             	mov    0x8(%esi),%eax
80106b47:	85 c0                	test   %eax,%eax
80106b49:	0f 84 da 00 00 00    	je     80106c29 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106b4f:	8b 46 04             	mov    0x4(%esi),%eax
80106b52:	85 c0                	test   %eax,%eax
80106b54:	0f 84 c2 00 00 00    	je     80106c1c <switchuvm+0xec>
  pushcli();
80106b5a:	e8 41 da ff ff       	call   801045a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b5f:	e8 dc ce ff ff       	call   80103a40 <mycpu>
80106b64:	89 c3                	mov    %eax,%ebx
80106b66:	e8 d5 ce ff ff       	call   80103a40 <mycpu>
80106b6b:	89 c7                	mov    %eax,%edi
80106b6d:	e8 ce ce ff ff       	call   80103a40 <mycpu>
80106b72:	83 c7 08             	add    $0x8,%edi
80106b75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b78:	e8 c3 ce ff ff       	call   80103a40 <mycpu>
80106b7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b80:	ba 67 00 00 00       	mov    $0x67,%edx
80106b85:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106b8c:	83 c0 08             	add    $0x8,%eax
80106b8f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b96:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b9b:	83 c1 08             	add    $0x8,%ecx
80106b9e:	c1 e8 18             	shr    $0x18,%eax
80106ba1:	c1 e9 10             	shr    $0x10,%ecx
80106ba4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106baa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106bb0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106bb5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106bbc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106bc1:	e8 7a ce ff ff       	call   80103a40 <mycpu>
80106bc6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106bcd:	e8 6e ce ff ff       	call   80103a40 <mycpu>
80106bd2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106bd6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106bd9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bdf:	e8 5c ce ff ff       	call   80103a40 <mycpu>
80106be4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106be7:	e8 54 ce ff ff       	call   80103a40 <mycpu>
80106bec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106bf0:	b8 28 00 00 00       	mov    $0x28,%eax
80106bf5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106bf8:	8b 46 04             	mov    0x4(%esi),%eax
80106bfb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c00:	0f 22 d8             	mov    %eax,%cr3
}
80106c03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c06:	5b                   	pop    %ebx
80106c07:	5e                   	pop    %esi
80106c08:	5f                   	pop    %edi
80106c09:	5d                   	pop    %ebp
  popcli();
80106c0a:	e9 e1 d9 ff ff       	jmp    801045f0 <popcli>
    panic("switchuvm: no process");
80106c0f:	83 ec 0c             	sub    $0xc,%esp
80106c12:	68 ce 7b 10 80       	push   $0x80107bce
80106c17:	e8 64 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106c1c:	83 ec 0c             	sub    $0xc,%esp
80106c1f:	68 f9 7b 10 80       	push   $0x80107bf9
80106c24:	e8 57 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106c29:	83 ec 0c             	sub    $0xc,%esp
80106c2c:	68 e4 7b 10 80       	push   $0x80107be4
80106c31:	e8 4a 97 ff ff       	call   80100380 <panic>
80106c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c3d:	8d 76 00             	lea    0x0(%esi),%esi

80106c40 <inituvm>:
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	57                   	push   %edi
80106c44:	56                   	push   %esi
80106c45:	53                   	push   %ebx
80106c46:	83 ec 1c             	sub    $0x1c,%esp
80106c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c4c:	8b 75 10             	mov    0x10(%ebp),%esi
80106c4f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106c55:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c5b:	77 4b                	ja     80106ca8 <inituvm+0x68>
  mem = kalloc();
80106c5d:	e8 6e bb ff ff       	call   801027d0 <kalloc>
  memset(mem, 0, PGSIZE);
80106c62:	83 ec 04             	sub    $0x4,%esp
80106c65:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106c6a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106c6c:	6a 00                	push   $0x0
80106c6e:	50                   	push   %eax
80106c6f:	e8 3c db ff ff       	call   801047b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c74:	58                   	pop    %eax
80106c75:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c7b:	5a                   	pop    %edx
80106c7c:	6a 06                	push   $0x6
80106c7e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c83:	31 d2                	xor    %edx,%edx
80106c85:	50                   	push   %eax
80106c86:	89 f8                	mov    %edi,%eax
80106c88:	e8 13 fd ff ff       	call   801069a0 <mappages>
  memmove(mem, init, sz);
80106c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c90:	89 75 10             	mov    %esi,0x10(%ebp)
80106c93:	83 c4 10             	add    $0x10,%esp
80106c96:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106c99:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106c9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c9f:	5b                   	pop    %ebx
80106ca0:	5e                   	pop    %esi
80106ca1:	5f                   	pop    %edi
80106ca2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ca3:	e9 a8 db ff ff       	jmp    80104850 <memmove>
    panic("inituvm: more than a page");
80106ca8:	83 ec 0c             	sub    $0xc,%esp
80106cab:	68 0d 7c 10 80       	push   $0x80107c0d
80106cb0:	e8 cb 96 ff ff       	call   80100380 <panic>
80106cb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106cc0 <loaduvm>:
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	53                   	push   %ebx
80106cc6:	83 ec 1c             	sub    $0x1c,%esp
80106cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ccc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106ccf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106cd4:	0f 85 bb 00 00 00    	jne    80106d95 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106cda:	01 f0                	add    %esi,%eax
80106cdc:	89 f3                	mov    %esi,%ebx
80106cde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ce1:	8b 45 14             	mov    0x14(%ebp),%eax
80106ce4:	01 f0                	add    %esi,%eax
80106ce6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106ce9:	85 f6                	test   %esi,%esi
80106ceb:	0f 84 87 00 00 00    	je     80106d78 <loaduvm+0xb8>
80106cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106cf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106cfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106cfe:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106d00:	89 c2                	mov    %eax,%edx
80106d02:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106d05:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106d08:	f6 c2 01             	test   $0x1,%dl
80106d0b:	75 13                	jne    80106d20 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106d0d:	83 ec 0c             	sub    $0xc,%esp
80106d10:	68 27 7c 10 80       	push   $0x80107c27
80106d15:	e8 66 96 ff ff       	call   80100380 <panic>
80106d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d20:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d23:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106d29:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d2e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106d35:	85 c0                	test   %eax,%eax
80106d37:	74 d4                	je     80106d0d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106d39:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d3b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106d3e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106d43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106d48:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106d4e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d51:	29 d9                	sub    %ebx,%ecx
80106d53:	05 00 00 00 80       	add    $0x80000000,%eax
80106d58:	57                   	push   %edi
80106d59:	51                   	push   %ecx
80106d5a:	50                   	push   %eax
80106d5b:	ff 75 10             	push   0x10(%ebp)
80106d5e:	e8 7d ae ff ff       	call   80101be0 <readi>
80106d63:	83 c4 10             	add    $0x10,%esp
80106d66:	39 f8                	cmp    %edi,%eax
80106d68:	75 1e                	jne    80106d88 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106d6a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106d70:	89 f0                	mov    %esi,%eax
80106d72:	29 d8                	sub    %ebx,%eax
80106d74:	39 c6                	cmp    %eax,%esi
80106d76:	77 80                	ja     80106cf8 <loaduvm+0x38>
}
80106d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d7b:	31 c0                	xor    %eax,%eax
}
80106d7d:	5b                   	pop    %ebx
80106d7e:	5e                   	pop    %esi
80106d7f:	5f                   	pop    %edi
80106d80:	5d                   	pop    %ebp
80106d81:	c3                   	ret    
80106d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d88:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d90:	5b                   	pop    %ebx
80106d91:	5e                   	pop    %esi
80106d92:	5f                   	pop    %edi
80106d93:	5d                   	pop    %ebp
80106d94:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106d95:	83 ec 0c             	sub    $0xc,%esp
80106d98:	68 c8 7c 10 80       	push   $0x80107cc8
80106d9d:	e8 de 95 ff ff       	call   80100380 <panic>
80106da2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106db0 <allocuvm>:
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	57                   	push   %edi
80106db4:	56                   	push   %esi
80106db5:	53                   	push   %ebx
80106db6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106db9:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106dbc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106dbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106dc2:	85 c0                	test   %eax,%eax
80106dc4:	0f 88 b6 00 00 00    	js     80106e80 <allocuvm+0xd0>
  if(newsz < oldsz)
80106dca:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106dd0:	0f 82 9a 00 00 00    	jb     80106e70 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106dd6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106ddc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106de2:	39 75 10             	cmp    %esi,0x10(%ebp)
80106de5:	77 44                	ja     80106e2b <allocuvm+0x7b>
80106de7:	e9 87 00 00 00       	jmp    80106e73 <allocuvm+0xc3>
80106dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106df0:	83 ec 04             	sub    $0x4,%esp
80106df3:	68 00 10 00 00       	push   $0x1000
80106df8:	6a 00                	push   $0x0
80106dfa:	50                   	push   %eax
80106dfb:	e8 b0 d9 ff ff       	call   801047b0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106e00:	58                   	pop    %eax
80106e01:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e07:	5a                   	pop    %edx
80106e08:	6a 06                	push   $0x6
80106e0a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e0f:	89 f2                	mov    %esi,%edx
80106e11:	50                   	push   %eax
80106e12:	89 f8                	mov    %edi,%eax
80106e14:	e8 87 fb ff ff       	call   801069a0 <mappages>
80106e19:	83 c4 10             	add    $0x10,%esp
80106e1c:	85 c0                	test   %eax,%eax
80106e1e:	78 78                	js     80106e98 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106e20:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e26:	39 75 10             	cmp    %esi,0x10(%ebp)
80106e29:	76 48                	jbe    80106e73 <allocuvm+0xc3>
    mem = kalloc();
80106e2b:	e8 a0 b9 ff ff       	call   801027d0 <kalloc>
80106e30:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106e32:	85 c0                	test   %eax,%eax
80106e34:	75 ba                	jne    80106df0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106e36:	83 ec 0c             	sub    $0xc,%esp
80106e39:	68 45 7c 10 80       	push   $0x80107c45
80106e3e:	e8 5d 98 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106e43:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e46:	83 c4 10             	add    $0x10,%esp
80106e49:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e4c:	74 32                	je     80106e80 <allocuvm+0xd0>
80106e4e:	8b 55 10             	mov    0x10(%ebp),%edx
80106e51:	89 c1                	mov    %eax,%ecx
80106e53:	89 f8                	mov    %edi,%eax
80106e55:	e8 96 fa ff ff       	call   801068f0 <deallocuvm.part.0>
      return 0;
80106e5a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106e61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e67:	5b                   	pop    %ebx
80106e68:	5e                   	pop    %esi
80106e69:	5f                   	pop    %edi
80106e6a:	5d                   	pop    %ebp
80106e6b:	c3                   	ret    
80106e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106e70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106e73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e79:	5b                   	pop    %ebx
80106e7a:	5e                   	pop    %esi
80106e7b:	5f                   	pop    %edi
80106e7c:	5d                   	pop    %ebp
80106e7d:	c3                   	ret    
80106e7e:	66 90                	xchg   %ax,%ax
    return 0;
80106e80:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e8d:	5b                   	pop    %ebx
80106e8e:	5e                   	pop    %esi
80106e8f:	5f                   	pop    %edi
80106e90:	5d                   	pop    %ebp
80106e91:	c3                   	ret    
80106e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106e98:	83 ec 0c             	sub    $0xc,%esp
80106e9b:	68 5d 7c 10 80       	push   $0x80107c5d
80106ea0:	e8 fb 97 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ea8:	83 c4 10             	add    $0x10,%esp
80106eab:	39 45 10             	cmp    %eax,0x10(%ebp)
80106eae:	74 0c                	je     80106ebc <allocuvm+0x10c>
80106eb0:	8b 55 10             	mov    0x10(%ebp),%edx
80106eb3:	89 c1                	mov    %eax,%ecx
80106eb5:	89 f8                	mov    %edi,%eax
80106eb7:	e8 34 fa ff ff       	call   801068f0 <deallocuvm.part.0>
      kfree(mem);
80106ebc:	83 ec 0c             	sub    $0xc,%esp
80106ebf:	53                   	push   %ebx
80106ec0:	e8 4b b7 ff ff       	call   80102610 <kfree>
      return 0;
80106ec5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106ecc:	83 c4 10             	add    $0x10,%esp
}
80106ecf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ed2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ed5:	5b                   	pop    %ebx
80106ed6:	5e                   	pop    %esi
80106ed7:	5f                   	pop    %edi
80106ed8:	5d                   	pop    %ebp
80106ed9:	c3                   	ret    
80106eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ee0 <deallocuvm>:
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ee6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106eec:	39 d1                	cmp    %edx,%ecx
80106eee:	73 10                	jae    80106f00 <deallocuvm+0x20>
}
80106ef0:	5d                   	pop    %ebp
80106ef1:	e9 fa f9 ff ff       	jmp    801068f0 <deallocuvm.part.0>
80106ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106efd:	8d 76 00             	lea    0x0(%esi),%esi
80106f00:	89 d0                	mov    %edx,%eax
80106f02:	5d                   	pop    %ebp
80106f03:	c3                   	ret    
80106f04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f0f:	90                   	nop

80106f10 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
80106f14:	56                   	push   %esi
80106f15:	53                   	push   %ebx
80106f16:	83 ec 0c             	sub    $0xc,%esp
80106f19:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106f1c:	85 f6                	test   %esi,%esi
80106f1e:	74 59                	je     80106f79 <freevm+0x69>
  if(newsz >= oldsz)
80106f20:	31 c9                	xor    %ecx,%ecx
80106f22:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106f27:	89 f0                	mov    %esi,%eax
80106f29:	89 f3                	mov    %esi,%ebx
80106f2b:	e8 c0 f9 ff ff       	call   801068f0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106f30:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106f36:	eb 0f                	jmp    80106f47 <freevm+0x37>
80106f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f3f:	90                   	nop
80106f40:	83 c3 04             	add    $0x4,%ebx
80106f43:	39 df                	cmp    %ebx,%edi
80106f45:	74 23                	je     80106f6a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106f47:	8b 03                	mov    (%ebx),%eax
80106f49:	a8 01                	test   $0x1,%al
80106f4b:	74 f3                	je     80106f40 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106f52:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f55:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f58:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106f5d:	50                   	push   %eax
80106f5e:	e8 ad b6 ff ff       	call   80102610 <kfree>
80106f63:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f66:	39 df                	cmp    %ebx,%edi
80106f68:	75 dd                	jne    80106f47 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106f6a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f70:	5b                   	pop    %ebx
80106f71:	5e                   	pop    %esi
80106f72:	5f                   	pop    %edi
80106f73:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106f74:	e9 97 b6 ff ff       	jmp    80102610 <kfree>
    panic("freevm: no pgdir");
80106f79:	83 ec 0c             	sub    $0xc,%esp
80106f7c:	68 79 7c 10 80       	push   $0x80107c79
80106f81:	e8 fa 93 ff ff       	call   80100380 <panic>
80106f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f8d:	8d 76 00             	lea    0x0(%esi),%esi

80106f90 <setupkvm>:
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	56                   	push   %esi
80106f94:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106f95:	e8 36 b8 ff ff       	call   801027d0 <kalloc>
80106f9a:	89 c6                	mov    %eax,%esi
80106f9c:	85 c0                	test   %eax,%eax
80106f9e:	74 42                	je     80106fe2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106fa0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106fa3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106fa8:	68 00 10 00 00       	push   $0x1000
80106fad:	6a 00                	push   $0x0
80106faf:	50                   	push   %eax
80106fb0:	e8 fb d7 ff ff       	call   801047b0 <memset>
80106fb5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106fb8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106fbb:	83 ec 08             	sub    $0x8,%esp
80106fbe:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106fc1:	ff 73 0c             	push   0xc(%ebx)
80106fc4:	8b 13                	mov    (%ebx),%edx
80106fc6:	50                   	push   %eax
80106fc7:	29 c1                	sub    %eax,%ecx
80106fc9:	89 f0                	mov    %esi,%eax
80106fcb:	e8 d0 f9 ff ff       	call   801069a0 <mappages>
80106fd0:	83 c4 10             	add    $0x10,%esp
80106fd3:	85 c0                	test   %eax,%eax
80106fd5:	78 19                	js     80106ff0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106fd7:	83 c3 10             	add    $0x10,%ebx
80106fda:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106fe0:	75 d6                	jne    80106fb8 <setupkvm+0x28>
}
80106fe2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106fe5:	89 f0                	mov    %esi,%eax
80106fe7:	5b                   	pop    %ebx
80106fe8:	5e                   	pop    %esi
80106fe9:	5d                   	pop    %ebp
80106fea:	c3                   	ret    
80106feb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fef:	90                   	nop
      freevm(pgdir);
80106ff0:	83 ec 0c             	sub    $0xc,%esp
80106ff3:	56                   	push   %esi
      return 0;
80106ff4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106ff6:	e8 15 ff ff ff       	call   80106f10 <freevm>
      return 0;
80106ffb:	83 c4 10             	add    $0x10,%esp
}
80106ffe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107001:	89 f0                	mov    %esi,%eax
80107003:	5b                   	pop    %ebx
80107004:	5e                   	pop    %esi
80107005:	5d                   	pop    %ebp
80107006:	c3                   	ret    
80107007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010700e:	66 90                	xchg   %ax,%ax

80107010 <kvmalloc>:
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107016:	e8 75 ff ff ff       	call   80106f90 <setupkvm>
8010701b:	a3 c4 44 11 80       	mov    %eax,0x801144c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107020:	05 00 00 00 80       	add    $0x80000000,%eax
80107025:	0f 22 d8             	mov    %eax,%cr3
}
80107028:	c9                   	leave  
80107029:	c3                   	ret    
8010702a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107030 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	83 ec 08             	sub    $0x8,%esp
80107036:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107039:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010703c:	89 c1                	mov    %eax,%ecx
8010703e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107041:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107044:	f6 c2 01             	test   $0x1,%dl
80107047:	75 17                	jne    80107060 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107049:	83 ec 0c             	sub    $0xc,%esp
8010704c:	68 8a 7c 10 80       	push   $0x80107c8a
80107051:	e8 2a 93 ff ff       	call   80100380 <panic>
80107056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010705d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107060:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107063:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107069:	25 fc 0f 00 00       	and    $0xffc,%eax
8010706e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107075:	85 c0                	test   %eax,%eax
80107077:	74 d0                	je     80107049 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107079:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010707c:	c9                   	leave  
8010707d:	c3                   	ret    
8010707e:	66 90                	xchg   %ax,%ax

80107080 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	57                   	push   %edi
80107084:	56                   	push   %esi
80107085:	53                   	push   %ebx
80107086:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107089:	e8 02 ff ff ff       	call   80106f90 <setupkvm>
8010708e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107091:	85 c0                	test   %eax,%eax
80107093:	0f 84 bd 00 00 00    	je     80107156 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107099:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010709c:	85 c9                	test   %ecx,%ecx
8010709e:	0f 84 b2 00 00 00    	je     80107156 <copyuvm+0xd6>
801070a4:	31 f6                	xor    %esi,%esi
801070a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801070b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801070b3:	89 f0                	mov    %esi,%eax
801070b5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801070b8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801070bb:	a8 01                	test   $0x1,%al
801070bd:	75 11                	jne    801070d0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801070bf:	83 ec 0c             	sub    $0xc,%esp
801070c2:	68 94 7c 10 80       	push   $0x80107c94
801070c7:	e8 b4 92 ff ff       	call   80100380 <panic>
801070cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801070d0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801070d7:	c1 ea 0a             	shr    $0xa,%edx
801070da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801070e0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801070e7:	85 c0                	test   %eax,%eax
801070e9:	74 d4                	je     801070bf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801070eb:	8b 00                	mov    (%eax),%eax
801070ed:	a8 01                	test   $0x1,%al
801070ef:	0f 84 9f 00 00 00    	je     80107194 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801070f5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801070f7:	25 ff 0f 00 00       	and    $0xfff,%eax
801070fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801070ff:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107105:	e8 c6 b6 ff ff       	call   801027d0 <kalloc>
8010710a:	89 c3                	mov    %eax,%ebx
8010710c:	85 c0                	test   %eax,%eax
8010710e:	74 64                	je     80107174 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107110:	83 ec 04             	sub    $0x4,%esp
80107113:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107119:	68 00 10 00 00       	push   $0x1000
8010711e:	57                   	push   %edi
8010711f:	50                   	push   %eax
80107120:	e8 2b d7 ff ff       	call   80104850 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107125:	58                   	pop    %eax
80107126:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010712c:	5a                   	pop    %edx
8010712d:	ff 75 e4             	push   -0x1c(%ebp)
80107130:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107135:	89 f2                	mov    %esi,%edx
80107137:	50                   	push   %eax
80107138:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010713b:	e8 60 f8 ff ff       	call   801069a0 <mappages>
80107140:	83 c4 10             	add    $0x10,%esp
80107143:	85 c0                	test   %eax,%eax
80107145:	78 21                	js     80107168 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107147:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010714d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107150:	0f 87 5a ff ff ff    	ja     801070b0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107156:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107159:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010715c:	5b                   	pop    %ebx
8010715d:	5e                   	pop    %esi
8010715e:	5f                   	pop    %edi
8010715f:	5d                   	pop    %ebp
80107160:	c3                   	ret    
80107161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107168:	83 ec 0c             	sub    $0xc,%esp
8010716b:	53                   	push   %ebx
8010716c:	e8 9f b4 ff ff       	call   80102610 <kfree>
      goto bad;
80107171:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107174:	83 ec 0c             	sub    $0xc,%esp
80107177:	ff 75 e0             	push   -0x20(%ebp)
8010717a:	e8 91 fd ff ff       	call   80106f10 <freevm>
  return 0;
8010717f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107186:	83 c4 10             	add    $0x10,%esp
}
80107189:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010718c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010718f:	5b                   	pop    %ebx
80107190:	5e                   	pop    %esi
80107191:	5f                   	pop    %edi
80107192:	5d                   	pop    %ebp
80107193:	c3                   	ret    
      panic("copyuvm: page not present");
80107194:	83 ec 0c             	sub    $0xc,%esp
80107197:	68 ae 7c 10 80       	push   $0x80107cae
8010719c:	e8 df 91 ff ff       	call   80100380 <panic>
801071a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071af:	90                   	nop

801071b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801071b6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801071b9:	89 c1                	mov    %eax,%ecx
801071bb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801071be:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801071c1:	f6 c2 01             	test   $0x1,%dl
801071c4:	0f 84 00 01 00 00    	je     801072ca <uva2ka.cold>
  return &pgtab[PTX(va)];
801071ca:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071cd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801071d3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801071d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801071d9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801071e0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801071e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801071e7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801071ea:	05 00 00 00 80       	add    $0x80000000,%eax
801071ef:	83 fa 05             	cmp    $0x5,%edx
801071f2:	ba 00 00 00 00       	mov    $0x0,%edx
801071f7:	0f 45 c2             	cmovne %edx,%eax
}
801071fa:	c3                   	ret    
801071fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071ff:	90                   	nop

80107200 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	57                   	push   %edi
80107204:	56                   	push   %esi
80107205:	53                   	push   %ebx
80107206:	83 ec 0c             	sub    $0xc,%esp
80107209:	8b 75 14             	mov    0x14(%ebp),%esi
8010720c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010720f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107212:	85 f6                	test   %esi,%esi
80107214:	75 51                	jne    80107267 <copyout+0x67>
80107216:	e9 a5 00 00 00       	jmp    801072c0 <copyout+0xc0>
8010721b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010721f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107220:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107226:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010722c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107232:	74 75                	je     801072a9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107234:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107236:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107239:	29 c3                	sub    %eax,%ebx
8010723b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107241:	39 f3                	cmp    %esi,%ebx
80107243:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107246:	29 f8                	sub    %edi,%eax
80107248:	83 ec 04             	sub    $0x4,%esp
8010724b:	01 c1                	add    %eax,%ecx
8010724d:	53                   	push   %ebx
8010724e:	52                   	push   %edx
8010724f:	51                   	push   %ecx
80107250:	e8 fb d5 ff ff       	call   80104850 <memmove>
    len -= n;
    buf += n;
80107255:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107258:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010725e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107261:	01 da                	add    %ebx,%edx
  while(len > 0){
80107263:	29 de                	sub    %ebx,%esi
80107265:	74 59                	je     801072c0 <copyout+0xc0>
  if(*pde & PTE_P){
80107267:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010726a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010726c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010726e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107271:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107277:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010727a:	f6 c1 01             	test   $0x1,%cl
8010727d:	0f 84 4e 00 00 00    	je     801072d1 <copyout.cold>
  return &pgtab[PTX(va)];
80107283:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107285:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010728b:	c1 eb 0c             	shr    $0xc,%ebx
8010728e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107294:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010729b:	89 d9                	mov    %ebx,%ecx
8010729d:	83 e1 05             	and    $0x5,%ecx
801072a0:	83 f9 05             	cmp    $0x5,%ecx
801072a3:	0f 84 77 ff ff ff    	je     80107220 <copyout+0x20>
  }
  return 0;
}
801072a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801072ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072b1:	5b                   	pop    %ebx
801072b2:	5e                   	pop    %esi
801072b3:	5f                   	pop    %edi
801072b4:	5d                   	pop    %ebp
801072b5:	c3                   	ret    
801072b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072bd:	8d 76 00             	lea    0x0(%esi),%esi
801072c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801072c3:	31 c0                	xor    %eax,%eax
}
801072c5:	5b                   	pop    %ebx
801072c6:	5e                   	pop    %esi
801072c7:	5f                   	pop    %edi
801072c8:	5d                   	pop    %ebp
801072c9:	c3                   	ret    

801072ca <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801072ca:	a1 00 00 00 00       	mov    0x0,%eax
801072cf:	0f 0b                	ud2    

801072d1 <copyout.cold>:
801072d1:	a1 00 00 00 00       	mov    0x0,%eax
801072d6:	0f 0b                	ud2    
